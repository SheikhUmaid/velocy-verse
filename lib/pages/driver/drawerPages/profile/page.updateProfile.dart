// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'dart:io';

// import 'package:velocyverse/models/model.driverDetails.dart';
// import 'package:velocyverse/providers/driver/provider.driver_profile.dart';

// class EditProfileScreen extends StatefulWidget {
//   final DriverDetailsModel userProfile;

//   const
//     ({super.key, required this.userProfile});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _nameFocusNode = FocusNode();
//   final _emailFocusNode = FocusNode();
//   File? _newImageFile;
//   String? _newImagePath;
//   String? _profileImagePath;
//   bool _isLoading = false;
//   bool _hasChanges = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeFields();
//   }

//   void _initializeFields() {
//     _nameController.text = widget.userProfile.username!;
//     _emailController.text = widget.userProfile.email;
//     _profileImagePath = widget.userProfile.profileImage;

//     // Listen for changes
//     _nameController.addListener(_onFieldChanged);
//     _emailController.addListener(_onFieldChanged);
//   }

//   void _onFieldChanged() {
//     final hasChanges =
//         _nameController.text != widget.userProfile.username! ||
//         _emailController.text != widget.userProfile.email ||
//         _profileImagePath != widget.userProfile.profileImage;

//     if (hasChanges != _hasChanges) {
//       setState(() {
//         _hasChanges = hasChanges;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _nameFocusNode.dispose();
//     _emailFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: _buildAppBar(),
//         body: _buildBody(context),
//       ),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       leading: IconButton(
//         icon: const Icon(Icons.close, color: Colors.black87),
//         onPressed: () => _onCancelTap(),
//       ),
//       title: const Text(
//         'Edit Profile',
//         style: TextStyle(
//           color: Colors.black87,
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       centerTitle: true,
//     );
//   }

//   Widget _buildBody(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               _buildProfileImageSection(context),
//               const SizedBox(height: 40),
//               _buildFormFields(),
//               const SizedBox(height: 40),
//               _buildDeleteAccountButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileImageSection(BuildContext context) {
//     return Center(
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: _onProfileImageTap,
//             child: Stack(
//               children: [
//                 Container(
//                   width: 120,
//                   height: 120,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 4),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 12,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: ClipOval(child: _buildProfileImage(context)),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: Container(
//                     width: 36,
//                     height: 36,
//                     decoration: BoxDecoration(
//                       color: Colors.blue[600],
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 2),
//                     ),
//                     child: const Icon(
//                       Icons.camera_alt,
//                       color: Colors.white,
//                       size: 18,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text('display image path = ${_newImagePath ?? _profileImagePath}'),
//           Text(
//             'Tap to change profile photo',
//             style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileImage(BuildContext context) {
//     if (_profileImagePath != null) {
//       // Check if it's a local file or network image
//       if (_profileImagePath!.startsWith('http')) {
//         return (_newImageFile == null)
//             ? Image.network(
//                 _profileImagePath!,
//                 width: 120,
//                 height: 120,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) =>
//                     _buildDefaultAvatar(),
//               )
//             : Image.file(
//                 _newImageFile!,
//                 width: 120,
//                 height: 120,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) =>
//                     _buildDefaultAvatar(),
//               );
//       } else {
//         return Image.file(
//           File(_profileImagePath!),
//           width: 120,
//           height: 120,
//           fit: BoxFit.cover,
//           errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
//         );
//       }
//     }
//     return _buildDefaultAvatar();
//   }

//   Widget _buildDefaultAvatar() {
//     return Container(
//       width: 120,
//       height: 120,
//       color: Colors.grey[200],
//       child: Icon(Icons.person, size: 60, color: Colors.grey[400]),
//     );
//   }

//   Widget _buildFormFields() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildFormField(
//             label: 'Name',
//             controller: _nameController,
//             focusNode: _nameFocusNode,
//             validator: _validateName,
//             textInputAction: TextInputAction.next,
//             onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
//           ),
//           const SizedBox(height: 24),
//           _buildFormField(
//             label: 'Email',
//             controller: _emailController,
//             focusNode: _emailFocusNode,
//             validator: _validateEmail,
//             keyboardType: TextInputType.emailAddress,
//             textInputAction: TextInputAction.done,
//           ),
//           Container(
//             margin: EdgeInsets.only(top: 12),
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: _onSaveTap,
//               style: ElevatedButton.styleFrom(
//                 elevation: 0,
//                 backgroundColor: Colors.white,
//                 side: BorderSide(
//                   color: _hasChanges ? Colors.blue : Colors.grey,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//               child: Text(
//                 'Save',
//                 style: TextStyle(
//                   color: _hasChanges ? Colors.blue : Colors.grey,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFormField({
//     required String label,
//     required TextEditingController controller,
//     required FocusNode focusNode,
//     required String? Function(String?) validator,
//     TextInputType? keyboardType,
//     TextInputAction? textInputAction,
//     Function(String)? onFieldSubmitted,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: controller,
//           focusNode: focusNode,
//           validator: validator,
//           keyboardType: keyboardType,
//           textInputAction: textInputAction,
//           onFieldSubmitted: onFieldSubmitted,
//           style: const TextStyle(fontSize: 16, color: Colors.black87),
//           decoration: InputDecoration(
//             hintText: 'Enter your $label',
//             hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
//             filled: true,
//             fillColor: Colors.grey[50],
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.red, width: 2),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 16,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDeleteAccountButton() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Danger Zone',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             child: OutlinedButton(
//               onPressed: _onDeleteAccountTap,
//               style: OutlinedButton.styleFrom(
//                 side: const BorderSide(color: Colors.red),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//               child: const Text(
//                 'Delete Account',
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'This action cannot be undone. All your data will be permanently deleted.',
//             style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//           ),
//         ],
//       ),
//     );
//   }

//   // Validation Methods
//   String? _validateName(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Name is required';
//     }
//     if (value.trim().length < 2) {
//       return 'Name must be at least 2 characters';
//     }
//     if (value.trim().length > 50) {
//       return 'Name must be less than 50 characters';
//     }
//     return null;
//   }

//   String? _validateEmail(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Email is required';
//     }
//     final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
//     if (!emailRegex.hasMatch(value.trim())) {
//       return 'Please enter a valid email address';
//     }
//     return null;
//   }

//   // Event Handlers
//   void _onProfileImageTap() {
//     _showImagePickerOptions();
//   }

//   void _showImagePickerOptions() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Change Profile Photo',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildImageOption(
//                   icon: Icons.camera_alt,
//                   label: 'Camera',
//                   onTap: () => _pickImageFromCamera(),
//                 ),
//                 _buildImageOption(
//                   icon: Icons.photo_library,
//                   label: 'Gallery',
//                   onTap: () => _pickImageFromGallery(),
//                 ),
//                 if (_profileImagePath != null)
//                   _buildImageOption(
//                     icon: Icons.delete,
//                     label: 'Remove',
//                     onTap: () => _removeProfileImage(),
//                     color: Colors.red,
//                   ),
//               ],
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildImageOption({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//     Color? color,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               color: (color ?? Colors.blue[600])?.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: color ?? Colors.blue[600], size: 24),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: TextStyle(fontSize: 14, color: color ?? Colors.black87),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _pickImageFromCamera() async {
//     Navigator.pop(context);
//     // Uncomment when using image_picker

//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 1024,
//         maxHeight: 1024,
//         imageQuality: 85,
//       );

//       if (image != null) {
//         setState(() {
//           print("Image path from camera = ${image.path}");
//           _newImageFile = File(image.path);
//         });
//         // await _cropImage(image.path);
//       }
//     } catch (e) {
//       _showErrorSnackBar('Failed to pick image from camera');
//     }

//     // Mock implementation for demo
//     // await Future.delayed(const Duration(milliseconds: 500));
//     // setState(() {
//     //   _profileImagePath = '/mock/camera/image/path.jpg';
//     //   _onFieldChanged();
//     // });
//     _showSuccessSnackBar('Image captured successfully');
//   }

//   Future<void> _pickImageFromGallery() async {
//     Navigator.pop(context);
//     try {
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['jpg', 'jpeg', 'png'],
//       );

//       if (result != null && result.files.single.path != null) {
//         // return result.files.single.path!;
//         setState(() {
//           print("Image path from camera = ${result.paths}");
//           _newImageFile = File(result.paths.first!);
//         });
//       }
//       return null; // user canceled
//     } catch (e) {
//       print("Error picking image: $e");
//       return null;
//     }
//     // Uncomment when using image_picker
//     /*
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 1024,
//         maxHeight: 1024,
//         imageQuality: 85,
//       );

//       if (image != null) {
//         await _cropImage(image.path);
//       }
//     } catch (e) {
//       _showErrorSnackBar('Failed to pick image from gallery');
//     }
//     */

//     // Mock implementation for demo
//     // await Future.delayed(const Duration(milliseconds: 500));
//     // setState(() {
//     //   _profileImagePath = '/mock/gallery/image/path.jpg';
//     //   _onFieldChanged();
//     // });
//     _showSuccessSnackBar('Image selected successfully');
//   }

//   /*
//   Future<void> _cropImage(String imagePath) async {
//     try {
//       final croppedFile = await ImageCropper().cropImage(
//         sourcePath: imagePath,
//         aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
//         uiSettings: [
//           AndroidUiSettings(
//             toolbarTitle: 'Crop Image',
//             toolbarColor: Colors.blue[600],
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.square,
//             lockAspectRatio: true,
//           ),
//           IOSUiSettings(
//             title: 'Crop Image',
//             aspectRatioLockEnabled: true,
//             resetAspectRatioEnabled: false,
//           ),
//         ],
//       );

//       if (croppedFile != null) {
//         setState(() {
//           _profileImagePath = croppedFile.path;
//           _onFieldChanged();
//         });
//         _showSuccessSnackBar('Image updated successfully');
//       }
//     } catch (e) {
//       _showErrorSnackBar('Failed to crop image');
//     }
//   }
//   */

//   void _removeProfileImage() {
//     Navigator.pop(context);
//     setState(() {
//       _profileImagePath = null;
//       _onFieldChanged();
//     });
//     _showSuccessSnackBar('Profile image removed');
//   }

//   Future<void> _onSaveTap() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     Future.microtask(() async {
//       print("Updating driver profile");
//       var imagePath = _newImageFile != null
//           ? _newImageFile!.path
//           : _profileImagePath!;
//       // bool success =
//       //     await Provider.of<DriverProfileProvider>(
//       //       context,
//       //       listen: false,
//       //     ).updateDriverProfile(
//       //       name: _nameController.text.trim(),
//       //       email: _emailController.text.trim(),
//       //       imagePath: imagePath, // can be null if not changing image
//       //     );

//       // if (!success) {
//       //   debugPrint("Failed to update driver profile");
//       // }
//     });
//     //  finally {
//     //       if (mounted) {
//     //         setState(() {
//     //           _isLoading = false;
//     //         });
//     //       }
//     //     }
//   }

//   void _onCancelTap() {
//     if (_hasChanges) {
//       _showDiscardChangesDialog();
//     } else {
//       Navigator.pop(context);
//     }
//   }

//   Future<bool> _onWillPop() async {
//     if (_hasChanges) {
//       _showDiscardChangesDialog();
//       return false;
//     }
//     return true;
//   }

//   void _showDiscardChangesDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Discard Changes?'),
//         content: const Text(
//           'You have unsaved changes. Are you sure you want to discard them?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Close dialog
//               Navigator.pop(context); // Close edit screen
//             },
//             child: const Text('Discard', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onDeleteAccountTap() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Account'),
//         content: const Text(
//           'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context); // Close dialog
//               // Handle account deletion
//               _showErrorSnackBar('Account deletion not implemented in demo');
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   // Utility Methods
//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(16),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(16),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }
// }

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:velocyverse/models/model.driverDetails.dart';
import 'package:velocyverse/providers/driver/provider.driver_profile.dart';

class EditProfileScreen extends StatefulWidget {
  final DriverDetailsModel userProfile;

  const EditProfileScreen({super.key, required this.userProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  File? _newImageFile;
  String? _newImagePath;
  String? _profileImagePath;
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _nameController.text = widget.userProfile.username!;
    _emailController.text = widget.userProfile.email;
    _profileImagePath = widget.userProfile.profileImage;

    // Listen for changes
    _nameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final hasChanges =
        _nameController.text != widget.userProfile.username! ||
        _emailController.text != widget.userProfile.email ||
        _profileImagePath != widget.userProfile.profileImage;

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(),
        body: _buildBody(context),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.black87),
        onPressed: () => _onCancelTap(),
      ),
      title: const Text(
        'Edit Profile',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildProfileImageSection(context),
              const SizedBox(height: 40),
              _buildFormFields(),
              const SizedBox(height: 40),
              _buildDeleteAccountButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _onProfileImageTap,
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(child: _buildProfileImage(context)),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tap to change profile photo',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    if (_profileImagePath != null) {
      // Check if it's a local file or network image
      if (_profileImagePath!.startsWith('http')) {
        return (_newImageFile == null)
            ? Image.network(
                _profileImagePath!,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildDefaultAvatar(),
              )
            : Image.file(
                _newImageFile!,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildDefaultAvatar(),
              );
      } else {
        return Image.file(
          File(_profileImagePath!),
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
        );
      }
    }
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 120,
      height: 120,
      color: Colors.grey[200],
      child: Icon(Icons.person, size: 60, color: Colors.grey[400]),
    );
  }

  Widget _buildFormFields() {
    final profileUpdateProvider = Provider.of<DriverProfileProvider>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormField(
            label: 'Name',
            controller: _nameController,
            focusNode: _nameFocusNode,
            validator: _validateName,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
          ),
          const SizedBox(height: 24),
          _buildFormField(
            label: 'Email',
            controller: _emailController,
            focusNode: _emailFocusNode,
            validator: _validateEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onSaveTap,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: _hasChanges ? Colors.blue : Colors.grey,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: profileUpdateProvider.isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      'Save',
                      style: TextStyle(
                        color: _hasChanges ? Colors.blue : Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    Function(String)? onFieldSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          decoration: InputDecoration(
            hintText: 'Enter your $label',
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteAccountButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Danger Zone',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _onDeleteAccountTap,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Delete Account',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This action cannot be undone. All your data will be permanently deleted.',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // Validation Methods
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Name must be less than 50 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Event Handlers
  void _onProfileImageTap() {
    _showImagePickerOptions();
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Change Profile Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () => _pickImageFromCamera(),
                ),
                _buildImageOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () => _pickImageFromGallery(),
                ),
                if (_profileImagePath != null)
                  _buildImageOption(
                    icon: Icons.delete,
                    label: 'Remove',
                    onTap: () => _removeProfileImage(),
                    color: Colors.red,
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: (color ?? Colors.blue[600])?.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color ?? Colors.blue[600], size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: color ?? Colors.black87),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    Navigator.pop(context);
    // Uncomment when using image_picker

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          print("Image path from camera = ${image.path}");
          _newImageFile = File(image.path);
        });
        // await _cropImage(image.path);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image from camera');
    }

    // Mock implementation for demo
    // await Future.delayed(const Duration(milliseconds: 500));
    // setState(() {
    //   _profileImagePath = '/mock/camera/image/path.jpg';
    //   _onFieldChanged();
    // });
    _showSuccessSnackBar('Image captured successfully');
  }

  Future<void> _pickImageFromGallery() async {
    Navigator.pop(context);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        // return result.files.single.path!;
        setState(() {
          print("Image path from camera = ${result.paths}");
          _newImageFile = File(result.paths.first!);
        });
      }
      return null; // user canceled
    } catch (e) {
      print("Error picking image: $e");
      return null;
    }
    // Uncomment when using image_picker
    /*
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        await _cropImage(image.path);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image from gallery');
    }
    */

    // Mock implementation for demo
    // await Future.delayed(const Duration(milliseconds: 500));
    // setState(() {
    //   _profileImagePath = '/mock/gallery/image/path.jpg';
    //   _onFieldChanged();
    // });
    _showSuccessSnackBar('Image selected successfully');
  }

  /*
  Future<void> _cropImage(String imagePath) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue[600],
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _profileImagePath = croppedFile.path;
          _onFieldChanged();
        });
        _showSuccessSnackBar('Image updated successfully');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to crop image');
    }
  }
  */

  void _removeProfileImage() {
    Navigator.pop(context);
    setState(() {
      _profileImagePath = null;
      _onFieldChanged();
    });
    _showSuccessSnackBar('Profile image removed');
  }

  Future<void> _onSaveTap() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.microtask(() async {
      print("Updating driver profile");
      var imagePath = _newImageFile != null
          ? _newImageFile!.path
          : _profileImagePath!;
      bool success =
          await Provider.of<DriverProfileProvider>(
            context,
            listen: false,
          ).updateDriverProfile(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            imagePath: imagePath, // can be null if not changing image
          );

      if (!success) {
        debugPrint("Failed to update driver profile");
      } else {
        setState(() {
          _hasChanges = false;
        });
        _showSuccessSnackBar("Details updated");
      }
    });
    //  finally {
    //       if (mounted) {
    //         setState(() {
    //           _isLoading = false;
    //         });
    //       }
    //     }
  }

  void _onCancelTap() {
    if (_hasChanges) {
      _showDiscardChangesDialog();
    } else {
      print('here');
      Navigator.pop(context);
    }
  }

  Future<bool> _onWillPop() async {
    if (_hasChanges) {
      _showDiscardChangesDialog();
      return false;
    }
    return true;
  }

  void _showDiscardChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to discard them?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Navigator.pop(context); // Close edit screen
            },
            child: const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _onDeleteAccountTap() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              // Handle account deletion
              _showErrorSnackBar('Account deletion not implemented in demo');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Utility Methods
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
