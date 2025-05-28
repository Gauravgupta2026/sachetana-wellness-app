//
// import 'dart:convert';
// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
// import 'dart:ui' as ui;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:intl/intl.dart';
//
// void main() {
//   runApp(ProfilePage());
// }
//
// class ProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ProfileScreen(),
//     );
//   }
// }
//
// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   bool isEditable = false;
//   final _formKey = GlobalKey<FormState>();
//
//   // Firebase instances
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//
//   // Controllers for each field
//   TextEditingController nameController = TextEditingController(text: "GAURAV GUPTA");
//   TextEditingController collegeController = TextEditingController(text: "Manipal Institute of Technology");
//   TextEditingController dobController = TextEditingController(text: "13/11/2002");
//   TextEditingController phoneController = TextEditingController(text: "7635968591");
//   TextEditingController emailController = TextEditingController(text: "gauravssa08@gmail.com");
//   TextEditingController collegeMailController = TextEditingController(text: "gauravssa08@gmail.com");
//   TextEditingController fathersContactController = TextEditingController(text: "23456345768");
//   TextEditingController mothersContactController = TextEditingController(text: "467845678512");
//
//   // Variables for image picker
//   String? _base64Image;
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   // Load user data from Firebase
//   Future<void> _loadUserData() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       DocumentSnapshot userData =
//       await _firestore.collection('users').doc(user.uid).get();
//
//       if (userData.exists) {
//         setState(() {
//           nameController.text = userData['name'] ?? '';
//           collegeController.text = userData['college'] ?? '';
//           dobController.text = userData['dob'] ?? '';
//           phoneController.text = userData['phone'] ?? '';
//           emailController.text = userData['email'] ?? '';
//           collegeMailController.text = userData['collegeMail'] ?? '';
//           fathersContactController.text = userData['fathersContact'] ?? '';
//           mothersContactController.text = userData['mothersContact'] ?? '';
//           _base64Image = userData['profilePictureBase64'];
//         });
//       }
//     }
//   }
//
//   // Save user data to Firebase
//   Future<void> _saveUserData() async {
//     if (_formKey.currentState!.validate()) {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         await _firestore.collection('users').doc(user.uid).set({
//           'name': nameController.text,
//           'college': collegeController.text,
//           'dob': dobController.text,
//           'phone': phoneController.text,
//           'email': emailController.text,
//           'collegeMail': collegeMailController.text,
//           'fathersContact': fathersContactController.text,
//           'mothersContact': mothersContactController.text,
//           'profilePictureBase64': _base64Image,
//         }, SetOptions(merge: true));
//
//         setState(() {
//           isEditable = false;
//         });
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Profile updated successfully')),
//         );
//       }
//     }
//   }
//
//
//   // To select date for DOB
//   Future<void> _selectDate(BuildContext context) async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       setState(() {
//         dobController.text = DateFormat('dd/MM/yyyy').format(picked);
//       });
//     }
//   }
//
//   // To pick an image from the gallery
//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       try {
//         // Read the image file
//         final bytes = await pickedFile.readAsBytes();
//
//         // Decode the image
//         final image = await decodeImageFromList(bytes);
//
//         // Calculate new dimensions (e.g., max width of 800 pixels)
//         const int maxWidth = 800;
//         final double aspectRatio = image.width / image.height;
//         final int newWidth = image.width > maxWidth ? maxWidth : image.width;
//         final int newHeight = (newWidth / aspectRatio).round();
//
//         // Resize the image using a more reliable method
//         final ui.Image resizedImage = await _resizeImage(image, newWidth, newHeight);
//
//         // Convert the resized image to bytes
//         final ByteData? byteData = await resizedImage.toByteData(format: ui.ImageByteFormat.png);
//         if (byteData == null) {
//           throw Exception('Failed to convert image to byte data');
//         }
//         final Uint8List resizedBytes = byteData.buffer.asUint8List();
//
//         // Encode to base64
//         final base64Image = base64Encode(resizedBytes);
//
//         setState(() {
//           _base64Image = base64Image;
//         });
//
//         User? user = _auth.currentUser;
//         if (user != null) {
//           await _firestore.collection('users').doc(user.uid).update({
//             'profilePictureBase64': _base64Image,
//           });
//
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Profile picture updated successfully')),
//           );
//         }
//       } catch (e) {
//         print('Error updating profile picture: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to update profile picture: ${e.toString()}'),
//             duration: Duration(seconds: 5),
//           ),
//         );
//       }
//     }
//   }
//
//
//   // Helper method to resize the image
//   Future<ui.Image> _resizeImage(
//       ui.Image image, int targetWidth, int targetHeight) async {
//     final pictureRecorder = ui.PictureRecorder();
//     final canvas = Canvas(pictureRecorder);
//     canvas.drawImageRect(
//       image,
//       Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
//       Rect.fromLTRB(0, 0, targetWidth.toDouble(), targetHeight.toDouble()),
//       Paint()..filterQuality = FilterQuality.high,
//     );
//     final picture = pictureRecorder.endRecording();
//     return await picture.toImage(targetWidth, targetHeight);
//   }
//
//
//   // Generate initials from name
//   String getInitials(String name) {
//     if (name.isEmpty) return '';
//     List<String> nameParts = name.split(' ');
//     String initials = '';
//     if (nameParts.isNotEmpty) {
//       initials += nameParts[0].isNotEmpty ? nameParts[0][0] : '';
//       if (nameParts.length > 1 && nameParts.last.isNotEmpty) {
//         initials += nameParts.last[0];
//       }
//     }
//     return initials.toUpperCase();
//   }
//
//
//   // Validation Function
//   String? _validateField(String value, String fieldName) {
//     if (value.isEmpty) {
//       return '$fieldName is required';
//     }
//     if (fieldName == "Email" || fieldName == "College Mail") {
//       String pattern = r'^[a-zA-Z0-9._]+@[a-zA-Z]+\.[a-zA-Z]+';
//       RegExp regex = RegExp(pattern);
//       if (!regex.hasMatch(value)) {
//         return 'Enter a valid email address';
//       }
//     } else if (fieldName == "Phone" || fieldName.contains("Contact")) {
//       if (value.length != 10) {
//         return 'Contact should be exactly 10 digits';
//       }
//     }
//     return null;
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 100),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Text(
//                   "PROFILE",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20,
//                     fontFamily: 'DMSans',
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//
//                 // Profile Picture with Edit Button
//                 Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: 150,
//                       backgroundImage: _image == null
//                           ? AssetImage('assets/images/profile.jpg')
//                           : FileImage(_image!) as ImageProvider,
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: InkWell(
//                         onTap: _pickImage, // Change profile picture
//                         child: Container(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.lightBlue.shade100,
//                           ),
//                           padding: const EdgeInsets.all(8),
//                           child: const Icon(
//                             Icons.edit,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//
//                 // Name
//                 Text(
//                   nameController.text,
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//
//                 // User role
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: Colors.blue[200],
//                   ),
//                   child: const Text(
//                     "STUDENT",
//                     style: TextStyle(
//                         fontFamily: 'DMSans', fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//
//                 const Divider(height: 5, color: Colors.grey),
//                 const SizedBox(height: 30),
//
//                 // Profile Information Section
//                 const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Profile Information",
//                     style: TextStyle(
//                       fontFamily: 'DMSans',
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//
//                 // Profile Fields
//                 buildProfileField("Name", nameController),
//                 buildProfileField("College", collegeController),
//                 const SizedBox(height: 20),
//
//                 Divider(height: 5, color: Colors.grey),
//                 const SizedBox(height: 30),
//
//                 // Personal Information Section
//                 const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Personal Information",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//
//                 // Personal Fields
//                 buildProfileField("DOB", dobController, isDate: true),
//                 buildProfileField("Phone", phoneController),
//                 buildProfileField("Email", emailController),
//                 buildProfileField("College Mail", collegeMailController),
//                 const SizedBox(height: 20),
//
//                 Divider(height: 5, color: Colors.grey),
//                 const SizedBox(height: 30),
//
//                 // Emergency Contact Section
//                 const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Emergency Contact",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//
//                 // Emergency Fields
//                 buildProfileField("Father's Contact", fathersContactController),
//                 buildProfileField("Mother's Contact", mothersContactController),
//                 const SizedBox(height: 30),
//
//                 // Edit / Submit Button
//                 ElevatedButton(
//                   onPressed: () {
//                     if (isEditable) {
//                       if (_formKey.currentState!.validate()) {
//                         setState(() {
//                           isEditable = false; // Save changes
//                         });
//                       }
//                     } else {
//                       setState(() {
//                         isEditable = true; // Enable edit mode
//                       });
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                   ),
//                   child: Text(
//                     isEditable ? "SUBMIT" : "EDIT",
//                     style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Function to build input fields with optional date picker
//   Widget buildProfileField(String label, TextEditingController controller, {bool isDate = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               label,
//               style: const TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.bold),
//             ),
//           ),
//           const SizedBox(width: 30),
//           Expanded(
//             flex: 2,
//             child: Stack(
//               alignment: Alignment.centerRight,
//               children: [
//                 TextFormField(
//                   controller: controller,
//                   readOnly: !isEditable || isDate,
//                   onTap: isDate && isEditable ? () => _selectDate(context) : null,
//                   decoration: InputDecoration(
//                     border: isEditable
//                         ? OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(color: Colors.red),
//                     )
//                         : InputBorder.none,
//                     suffixIcon: controller.text.isEmpty
//                         ? const Icon(Icons.warning, color: Colors.red)
//                         : null,
//                   ),
//                   validator: (value) => _validateField(value!, label),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }











import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

void main() {
  runApp(ProfilePage());
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditable = false;
  final _formKey = GlobalKey<FormState>();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for each field
  TextEditingController nameController = TextEditingController();
  TextEditingController collegeController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController collegeMailController = TextEditingController();
  TextEditingController fathersContactController = TextEditingController();
  TextEditingController mothersContactController = TextEditingController();

  // Variables for image picker
  String? _base64Image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from Firebase
  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userData =
      await _firestore.collection('users').doc(user.uid).get();

      if (userData.exists) {
        setState(() {
          nameController.text = userData['name'] ?? '';
          collegeController.text = userData['college'] ?? '';
          dobController.text = userData['dob'] ?? '';
          phoneController.text = userData['phone'] ?? '';
          emailController.text = userData['email'] ?? '';
          collegeMailController.text = userData['collegeMail'] ?? '';
          fathersContactController.text = userData['fathersContact'] ?? '';
          mothersContactController.text = userData['mothersContact'] ?? '';
          _base64Image = userData['profilePictureBase64'];
        });
      }
    }
  }

  // Save user data to Firebase
  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': nameController.text,
          'college': collegeController.text,
          'dob': dobController.text,
          'phone': phoneController.text,
          'email': emailController.text,
          'collegeMail': collegeMailController.text,
          'fathersContact': fathersContactController.text,
          'mothersContact': mothersContactController.text,
          'profilePictureBase64': _base64Image,
        }, SetOptions(merge: true));

        setState(() {
          isEditable = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      }
    }
  }

  // To select date for DOB
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // To pick an image from the gallery, resize it, and encode to base64
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        // Read the image file
        final bytes = await pickedFile.readAsBytes();

        // Decode the image
        final image = await decodeImageFromList(bytes);

        // Calculate new dimensions (e.g., max width of 800 pixels)
        final int maxWidth = 800;
        final double aspectRatio = image.width / image.height;
        final int newWidth = image.width > maxWidth ? maxWidth : image.width;
        final int newHeight = (newWidth / aspectRatio).round();

        // Resize the image using a more reliable method
        final ui.Image resizedImage =
        await _resizeImage(image, newWidth, newHeight);

        // Convert the resized image to bytes
        final ByteData? byteData =
        await resizedImage.toByteData(format: ui.ImageByteFormat.png);
        if (byteData == null) {
          throw Exception('Failed to convert image to byte data');
        }
        final Uint8List resizedBytes = byteData.buffer.asUint8List();

        // Encode to base64
        final base64Image = base64Encode(resizedBytes);

        setState(() {
          _base64Image = base64Image;
        });

        User? user = _auth.currentUser;
        if (user != null) {
          await _firestore.collection('users').doc(user.uid).update({
            'profilePictureBase64': _base64Image,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile picture updated successfully')),
          );
        }
      } catch (e) {
        print('Error updating profile picture: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile picture: ${e.toString()}'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  // Helper method to resize the image
  Future<ui.Image> _resizeImage(
      ui.Image image, int targetWidth, int targetHeight) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    canvas.drawImageRect(
      image,
      Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTRB(0, 0, targetWidth.toDouble(), targetHeight.toDouble()),
      Paint()..filterQuality = FilterQuality.high,
    );
    final picture = pictureRecorder.endRecording();
    return await picture.toImage(targetWidth, targetHeight);
  }

  // Generate initials from name
  String getInitials(String name) {
    if (name.isEmpty) return '';
    List<String> nameParts = name.split(' ');
    String initials = '';
    if (nameParts.isNotEmpty) {
      initials += nameParts[0].isNotEmpty ? nameParts[0][0] : '';
      if (nameParts.length > 1 && nameParts.last.isNotEmpty) {
        initials += nameParts.last[0];
      }
    }
    return initials.toUpperCase();
  }

  // Validation Function
  String? _validateField(String value, String fieldName) {
    if (value.isEmpty) {
      return '$fieldName is required';
    }
    if (fieldName == "Email" || fieldName == "College Mail") {
      String pattern = r'^[a-zA-Z0-9._]+@[a-zA-Z]+\.[a-zA-Z]+';
      RegExp regex = RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return 'Enter a valid email address';
      }
    } else if (fieldName == "Phone" || fieldName.contains("Contact")) {
      if (value.length != 10) {
        return 'Contact should be exactly 10 digits';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 100),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "PROFILE",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'DMSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Profile Picture with Edit Button
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.blue,
                      child: _base64Image != null
                          ? ClipOval(
                        child: Image.memory(
                          base64Decode(_base64Image!),
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Text(
                        getInitials(nameController.text).isNotEmpty
                            ? getInitials(nameController.text)
                            : '?', // Display a question mark or any other placeholder when initials are empty
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _pickImage,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.lightBlue.shade100,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Name
                Text(
                  nameController.text,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // User role
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue[200],
                  ),
                  child: const Text(
                    "STUDENT",
                    style: TextStyle(
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),

                const Divider(height: 5, color: Colors.grey),
                const SizedBox(height: 30),

                // Profile Information Section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Profile Information",
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Profile Fields
                buildProfileField("Name", nameController),
                buildProfileField("College", collegeController),
                const SizedBox(height: 20),

                Divider(height: 5, color: Colors.grey),
                const SizedBox(height: 30),

                // Personal Information Section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Personal Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Personal Fields
                buildProfileField("DOB", dobController, isDate: true),
                buildProfileField("Phone", phoneController),
                buildProfileField("Email", emailController),
                buildProfileField("College Mail", collegeMailController),
                const SizedBox(height: 20),

                Divider(height: 5, color: Colors.grey),
                const SizedBox(height: 30),

                // Emergency Contact Section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Emergency Contact",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Emergency Fields
                buildProfileField("Father's Contact", fathersContactController),
                buildProfileField("Mother's Contact", mothersContactController),
                const SizedBox(height: 30),

                // Edit / Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (isEditable) {
                      _saveUserData();
                    } else {
                      setState(() {
                        isEditable = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    isEditable ? "SUBMIT" : "EDIT",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to build input fields with optional date picker
  Widget buildProfileField(String label, TextEditingController controller,
      {bool isDate = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: controller,
              readOnly: !isEditable || isDate,
              onTap: isDate && isEditable ? () => _selectDate(context) : null,
              decoration: InputDecoration(
                border: isEditable
                    ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                )
                    : InputBorder.none,
              ),
              validator: (value) => _validateField(value!, label),
            ),
          ),
        ],
      ),
    );
  }
}