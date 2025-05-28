

// code 7
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:sachetana_firebase/screens/gemini/const.dart';

class GeminiChatScreen extends StatefulWidget {
  @override
  _GeminiChatScreenState createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: GEMINI_API_KEY);

  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(
    id: "0",
    firstName: "User",
  );
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
  );

  ChatMessage? _currentGeminiMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [

            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                  child: Text(
                    'Sachetana',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontFamily: 'Tangerine',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    'Have any Questions?',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'DMSans',
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),

            // Blue Chat Area
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.67,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0), // Ample space between bubbles
                              child: Align(
                                alignment: message.user.id == currentUser.id
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: message.user.id == currentUser.id
                                        ? Colors.blueAccent
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomLeft: message.user.id == currentUser.id
                                          ? Radius.circular(12)
                                          : Radius.circular(0),
                                      bottomRight: message.user.id == currentUser.id
                                          ? Radius.circular(0)
                                          : Radius.circular(12),
                                    ),
                                  ),
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.75, // Restrict width to appear like chat bubble
                                  ),
                                  child: Text(
                                    message.text,
                                    style: TextStyle(
                                      fontFamily: 'DMSans',
                                      fontSize: 14, // Reduced text size to fit smaller chat bubbles
                                      color: message.user.id == currentUser.id
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Input field, media button, and send button
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'Type your question...',
                                filled: true,
                                fillColor: Colors.grey[100],
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20), // Elongated
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: TextStyle(fontFamily: 'DMSans'),
                            ),
                          ),
                          SizedBox(width: 10),
                          // Send button (smaller)
                          CircleAvatar(
                            radius: 25, // Smaller button
                            backgroundColor: Colors.blueAccent,
                            child: IconButton(
                              icon: Icon(Icons.send, color: Colors.white),
                              onPressed: () {
                                if (_controller.text.isNotEmpty) {
                                  _handleSendMessage();
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          // Media button (shifted to the rightmost with circular black background, smaller)
                          CircleAvatar(
                            radius: 25, // Smaller button
                            backgroundColor: Colors.blueAccent,
                            child: IconButton(
                              icon: Icon(Icons.image, color: Colors.white),
                              onPressed: _sendMediaMessage, // Call image picker
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSendMessage() {
    String messageText = _controller.text;
    _controller.clear(); // Clear the input after sending

    ChatMessage chatMessage = ChatMessage(
      user: currentUser,
      createdAt: DateTime.now(),
      text: messageText,
    );

    _sendMessage(chatMessage);
  }

  void _sendMessage(ChatMessage chatMessage) {
    // Append user message to the message list
    setState(() {
      messages.add(chatMessage); // User message added to the bottom of the list
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;

      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }

      _currentGeminiMessage = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: "",
      );

      gemini.streamGenerateContent(
        question,
        images: images,
      ).listen((event) {
        String response = event.content?.parts?.fold(
            "", (previous, current) => "$previous ${current.text}") ??
            "";

        setState(() {
          if (_currentGeminiMessage != null) {
            // Update Gemini's response as it streams
            _currentGeminiMessage!.text += response;
          }
        });
      }).onDone(() {
        if (_currentGeminiMessage != null) {
          // Append Gemini's response to the message list once done
          setState(() {
            messages.add(_currentGeminiMessage!); // Gemini's response added below user message
          });
          _currentGeminiMessage = null;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Tell me more about this picture?",
        medias: [
          ChatMedia(url: file.path, fileName: "", type: MediaType.image),
        ],
      );

      _sendMessage(chatMessage);
    }
  }
}

