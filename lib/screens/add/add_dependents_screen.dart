import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddDependentsScreen extends StatefulWidget {
  @override
  _AddDependentsScreenState createState() => _AddDependentsScreenState();
}

class _AddDependentsScreenState extends State<AddDependentsScreen> with SingleTickerProviderStateMixin {
  // State variables
  final _nameController = TextEditingController();
  String gender = 'Male';
  DateTime birthday = DateTime(2000, 1, 1);
  
  // Image picker and images
  final ImagePicker _picker = ImagePicker();
  File? upperBodyImage;
  File? fullBodyImage;
  File? additionalImage;
  
  // UI Colors
  final Color primaryColor = const Color(0xFF1B0331); // Dark purple

  // Function to pick image
  Future<void> _pickImage(ImageType type) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      
      if (pickedFile != null) {
        setState(() {
          switch (type) {
            case ImageType.upperBody:
              upperBodyImage = File(pickedFile.path);
              break;
            case ImageType.fullBody:
              fullBodyImage = File(pickedFile.path);
              break;
            case ImageType.additional:
              additionalImage = File(pickedFile.path);
              break;
          }
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Field
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter name',
                      fillColor: Colors.grey[100],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.person, color: primaryColor),
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Gender Selection
                  Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              gender = 'Male';
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: gender == 'Male' ? primaryColor : Colors.grey[100],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.male,
                                  color: gender == 'Male' ? Colors.white : primaryColor,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Male',
                                  style: TextStyle(
                                    color: gender == 'Male' ? Colors.white : primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              gender = 'Female';
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: gender == 'Female' ? primaryColor : Colors.grey[100],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.female,
                                  color: gender == 'Female' ? Colors.white : primaryColor,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Female',
                                  style: TextStyle(
                                    color: gender == 'Female' ? Colors.white : primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Birthday Selection
                  Text(
                    'Birthday',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      _showDatePicker(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: primaryColor),
                          SizedBox(width: 12),
                          Text(
                            '${birthday.day}/${birthday.month}/${birthday.year}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_drop_down, color: primaryColor),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Photo Upload Section
                  Text(
                    'Photos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Three photo upload options
                  Row(
                    children: [
                      Expanded(
                        child: _buildPhotoUploadCard(
                          title: 'Upper Body',
                          icon: Icons.accessibility_new,
                          image: upperBodyImage,
                          onTap: () => _pickImage(ImageType.upperBody),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildPhotoUploadCard(
                          title: 'Full Body',
                          icon: Icons.accessibility,
                          image: fullBodyImage,
                          onTap: () => _pickImage(ImageType.fullBody),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildPhotoUploadCard(
                          title: 'Add More',
                          icon: Icons.add_photo_alternate,
                          image: additionalImage,
                          onTap: () => _pickImage(ImageType.additional),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Save Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build photo upload card
  Widget _buildPhotoUploadCard({
    required String title,
    required IconData icon,
    required File? image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: image != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                      ),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: primaryColor,
                    size: 36,
                  ),
                  SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Icon(
                    Icons.add_circle,
                    color: primaryColor,
                    size: 24,
                  ),
                ],
              ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 40,
              color: primaryColor.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    padding: EdgeInsets.zero,
                  ),
                  CupertinoButton(
                    child: Text('Done'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: birthday,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    birthday = newDate;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Enum for image types
enum ImageType {
  upperBody,
  fullBody,
  additional,
}