import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddDependentScreen extends StatefulWidget {
  const AddDependentScreen({super.key});

  @override
  State<AddDependentScreen> createState() => _AddDependentScreenState();
}

class _AddDependentScreenState extends State<AddDependentScreen> {
  // State variables
  String? nickname;
  String gender = 'Male';
  DateTime birthday = DateTime(2022, 12, 31);
  String category = 'Love';
  bool isSmartFitCompleted = false;

  // Image picker and selected images
  final ImagePicker _picker = ImagePicker();
  File? upperBodyImage;
  File? fullBodyImage1;
  File? fullBodyImage2;

  // UI Colors
  final Color primaryColor = const Color(0xFF1B0331); // Dark purple
  final Color secondaryColor = const Color(0xFFF42A41); // Red for "Not Completed"

  // Function to pick image
  Future<void> _pickImage(int imageType) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          switch (imageType) {
            case 0: // Upper Body
              upperBodyImage = File(pickedFile.path);
              break;
            case 1: // Full Body 1
              fullBodyImage1 = File(pickedFile.path);
              break;
            case 2: // Full Body 2
              fullBodyImage2 = File(pickedFile.path);
              break;
          }
        });
      }
    } catch (e) {
      // Handle error
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isLargeScreen = screenWidth > 600;

    // Adjust paddings based on screen size
    final horizontalPadding = isSmallScreen ? 10.0 : (isLargeScreen ? 24.0 : 15.0);
    final verticalPadding = isSmallScreen ? 8.0 : (isLargeScreen ? 20.0 : 15.0);

    // Adjust font sizes based on screen size
    final titleFontSize = isSmallScreen ? 18.0 : (isLargeScreen ? 24.0 : 20.0);
    final sectionTitleFontSize = isSmallScreen ? 14.0 : (isLargeScreen ? 18.0 : 16.0);
    final bodyTextFontSize = isSmallScreen ? 13.0 : (isLargeScreen ? 16.0 : 14.0);

    // Adjust photo container heights based on screen size
    final photoContainerHeight = isSmallScreen ? 100.0 : (isLargeScreen ? 160.0 : 120.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: verticalPadding, bottom: verticalPadding),
                  child: Text(
                    'Add New Person',
                    style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1B0331)
                    ),
                  ),
                ),
              ),

              // Make the rest of the content scrollable
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nickname Field
                              Container(
                                padding: EdgeInsets.symmetric(vertical: verticalPadding * 0.5),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.person, size: 20, color: Colors.black),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Nickname',
                                          hintStyle: TextStyle(
                                            color: const Color(0xFF1B0331),
                                            fontSize: bodyTextFontSize,
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        style: TextStyle(fontSize: bodyTextFontSize),
                                        onChanged: (value) {
                                          setState(() {
                                            nickname = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding * 0.7),

                              // Gender Selection
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
                                        padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 6.0 : 8.0),
                                        decoration: BoxDecoration(
                                          color: gender == 'Male' ? primaryColor : const Color(0xFFF5F5F5),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(3),
                                              decoration: const BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(4),
                                                ),
                                              ),
                                              child: Text(
                                                'T',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: isSmallScreen ? 10.0 : 12.0,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Male',
                                              style: TextStyle(
                                                color: gender == 'Male' ? Colors.white : Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: bodyTextFontSize,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: isSmallScreen ? 8 : 15),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          gender = 'Female';
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 6.0 : 8.0),
                                        decoration: BoxDecoration(
                                          color: gender == 'Female' ? primaryColor : const Color(0xFFF5F5F5),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(3),
                                              decoration: const BoxDecoration(
                                                color: Colors.purple,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(4),
                                                ),
                                              ),
                                              child: Text(
                                                'F',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: isSmallScreen ? 10.0 : 12.0,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Female',
                                              style: TextStyle(
                                                color: gender == 'Female' ? Colors.white : Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: bodyTextFontSize,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: verticalPadding * 0.7),

                              // Birthday Section
                              Text(
                                'Birthday',
                                style: TextStyle(
                                    fontSize: sectionTitleFontSize,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1B0331)
                                ),
                              ),
                              SizedBox(height: verticalPadding * 0.7),

                              // Date Picker
                              SizedBox(
                                height: isSmallScreen ? 30 : (isLargeScreen ? 45 : 35),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _buildDatePicker(
                                        values: List.generate(
                                          30,
                                              (index) => (2000 + index).toString(),
                                        ),
                                        selectedIndex: 2,
                                        fontSize: isSmallScreen ? 16.0 : (isLargeScreen ? 20.0 : 18.0),
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: _buildDatePicker(
                                        values: List.generate(
                                          12,
                                              (index) => (index + 1).toString().padLeft(2, '0'),
                                        ),
                                        selectedIndex: 11,
                                        fontSize: isSmallScreen ? 16.0 : (isLargeScreen ? 20.0 : 18.0),
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: _buildDatePicker(
                                        values: List.generate(
                                          31,
                                              (index) => (index + 1).toString().padLeft(2, '0'),
                                        ),
                                        selectedIndex: 30,
                                        fontSize: isSmallScreen ? 16.0 : (isLargeScreen ? 20.0 : 18.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding),

                              // Category Section
                              Text(
                                'Category',
                                style: TextStyle(
                                    fontSize: sectionTitleFontSize,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1B0331)
                                ),
                              ),
                              SizedBox(height: verticalPadding * 0.5),

                              // Category Selection - Responsive grid or row based on screen size
                              isLargeScreen ?
                              // For larger screens - put all in a row
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCategoryOption(
                                      icon: Icons.home,
                                      label: 'Family',
                                      isSelected: category == 'Family',
                                      onTap: () {
                                        setState(() {
                                          category = 'Family';
                                        });
                                      },
                                      textSize: bodyTextFontSize,
                                      iconSize: isSmallScreen ? 18.0 : (isLargeScreen ? 26.0 : 22.0),
                                    ),
                                  ),
                                  SizedBox(width: horizontalPadding * 0.7),
                                  Expanded(
                                    child: _buildCategoryOption(
                                      icon: Icons.favorite,
                                      label: 'Love',
                                      isSelected: category == 'Love',
                                      onTap: () {
                                        setState(() {
                                          category = 'Love';
                                        });
                                      },
                                      textSize: bodyTextFontSize,
                                      iconSize: isSmallScreen ? 18.0 : (isLargeScreen ? 26.0 : 22.0),
                                    ),
                                  ),
                                  SizedBox(width: horizontalPadding * 0.7),
                                  Expanded(
                                    child: _buildCategoryOption(
                                      icon: Icons.people,
                                      label: 'Friend',
                                      isSelected: category == 'Friend',
                                      onTap: () {
                                        setState(() {
                                          category = 'Friend';
                                        });
                                      },
                                      textSize: bodyTextFontSize,
                                      iconSize: isSmallScreen ? 18.0 : (isLargeScreen ? 26.0 : 22.0),
                                    ),
                                  ),
                                ],
                              ) :
                              // For smaller screens - create a wrapping grid
                              Wrap(
                                spacing: horizontalPadding * 0.7,
                                runSpacing: verticalPadding * 0.7,
                                children: [
                                  SizedBox(
                                    width: (screenWidth - (horizontalPadding * 2 + horizontalPadding * 0.7)) / 2,
                                    child: _buildCategoryOption(
                                      icon: Icons.home,
                                      label: 'Family',
                                      isSelected: category == 'Family',
                                      onTap: () {
                                        setState(() {
                                          category = 'Family';
                                        });
                                      },
                                      textSize: bodyTextFontSize,
                                      iconSize: isSmallScreen ? 18.0 : 22.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: (screenWidth - (horizontalPadding * 2 + horizontalPadding * 0.7)) / 2,
                                    child: _buildCategoryOption(
                                      icon: Icons.favorite,
                                      label: 'Love',
                                      isSelected: category == 'Love',
                                      onTap: () {
                                        setState(() {
                                          category = 'Love';
                                        });
                                      },
                                      textSize: bodyTextFontSize,
                                      iconSize: isSmallScreen ? 18.0 : 22.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: (screenWidth - (horizontalPadding * 2 + horizontalPadding * 0.7)) / 2,
                                    child: _buildCategoryOption(
                                      icon: Icons.people,
                                      label: 'Friend',
                                      isSelected: category == 'Friend',
                                      onTap: () {
                                        setState(() {
                                          category = 'Friend';
                                        });
                                      },
                                      textSize: bodyTextFontSize,
                                      iconSize: isSmallScreen ? 18.0 : 22.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: verticalPadding),

                              // Photos Section
                              Text(
                                'Photos',
                                style: TextStyle(
                                    fontSize: sectionTitleFontSize,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1B0331)
                                ),
                              ),
                              SizedBox(height: verticalPadding * 0.7),

                              // Photo Upload Options - Responsive grid or row based on screen size
                              isLargeScreen ?
                              // For larger screens - put all in a row
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildPhotoUploadOption(
                                      icon: Icons.person_outline,
                                      label: 'Upper Body',
                                      onTap: () => _pickImage(0),
                                      image: upperBodyImage,
                                      height: photoContainerHeight,
                                      textSize: bodyTextFontSize,
                                      iconSize: isSmallScreen ? 24.0 : (isLargeScreen ? 36.0 : 30.0),
                                    ),
                                  ),
                                  SizedBox(width: horizontalPadding * 0.7),
                                  Expanded(
                                    child: _buildPhotoUploadOption(
                                      icon: Icons.accessibility,
                                      label: 'Full Body',
                                      onTap: () => _pickImage(1),
                                      image: fullBodyImage1,
                                      height: photoContainerHeight,
                                      textSize: bodyTextFontSize,
                                      iconSize: isSmallScreen ? 24.0 : (isLargeScreen ? 36.0 : 30.0),
                                    ),
                                  ),
                                  SizedBox(width: horizontalPadding * 0.7),
                                  Expanded(
                                    child: _buildPhotoUploadOption(
                                      icon: Icons.accessibility,
                                      label: 'Full Body',
                                      onTap: () => _pickImage(2),
                                      image: fullBodyImage2,
                                      height: photoContainerHeight,
                                      textSize: bodyTextFontSize,
                                      iconSize: isSmallScreen ? 24.0 : (isLargeScreen ? 36.0 : 30.0),
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                ],
                              ) :
                              // For smaller screens - create a wrapping grid
                              Wrap(
                                spacing: horizontalPadding * 0.7,
                                runSpacing: verticalPadding * 0.7,
                                children: [
                                  SizedBox(
                                    width: (screenWidth - (horizontalPadding * 2 + horizontalPadding * 0.7)) / 2,
                                    child: _buildPhotoUploadOption(
                                      icon: Icons.person_outline,
                                      label: 'Upper Body',
                                      onTap: () => _pickImage(0),
                                      image: upperBodyImage,
                                      height: photoContainerHeight,
                                      textSize: bodyTextFontSize,
                                      iconSize: isSmallScreen ? 24.0 : 30.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: (screenWidth - (horizontalPadding * 2 + horizontalPadding * 0.7)) / 2,
                                    child: _buildPhotoUploadOption(
                                      icon: Icons.accessibility,
                                      label: 'Full Body',
                                      onTap: () => _pickImage(1),
                                      image: fullBodyImage1,
                                      height: photoContainerHeight,
                                      textSize: bodyTextFontSize,
                                      iconSize: isSmallScreen ? 24.0 : 30.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: (screenWidth - (horizontalPadding * 2 + horizontalPadding * 0.7)) / 2,
                                    child: _buildPhotoUploadOption(
                                      icon: Icons.accessibility,
                                      label: 'Full Body',
                                      onTap: () => _pickImage(2),
                                      image: fullBodyImage2,
                                      height: photoContainerHeight,
                                      textSize: bodyTextFontSize,
                                      iconSize: isSmallScreen ? 24.0 : 30.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: verticalPadding),

                              // Measurements Section
                              Text(
                                'Measurements',
                                style: TextStyle(
                                    fontSize: sectionTitleFontSize,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1B0331)
                                ),
                              ),
                              SizedBox(height: verticalPadding * 0.7),

                              // Smart Fit Option
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding,
                                  vertical: verticalPadding,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.straighten, size: isSmallScreen ? 16.0 : 20.0),
                                    SizedBox(width: horizontalPadding * 0.7),
                                    Text(
                                      'Smart Fit Measures',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: bodyTextFontSize,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '[Not Completed]',
                                      style: TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: bodyTextFontSize,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Additional space at the bottom for better scrolling
                              SizedBox(height: verticalPadding * 3),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Add Person Button (outside the ScrollView)
              Padding(
                padding: EdgeInsets.only(top: verticalPadding * 0.7, bottom: verticalPadding * 0.7),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add person logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 12.0 : (isLargeScreen ? 18.0 : 15.0)
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: isSmallScreen ? 16.0 : 20.0),
                        SizedBox(width: isSmallScreen ? 5.0 : 8.0),
                        Text(
                          'Add Person',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: isSmallScreen ? 14.0 : (isLargeScreen ? 18.0 : 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for date picker
  Widget _buildDatePicker({
    required List<String> values,
    required int selectedIndex,
    required double fontSize,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B0331),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CupertinoPicker(
        backgroundColor: Colors.transparent,
        itemExtent: 30,
        squeeze: 1.0,
        diameterRatio: 1.1,
        useMagnifier: true,
        magnification: 1.1,
        selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
          background: Colors.transparent,
        ),
        onSelectedItemChanged: (int index) {
          // Handle date selection
        },
        scrollController: FixedExtentScrollController(
          initialItem: selectedIndex,
        ),
        children: values.map((value) {
          return Center(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Helper widget for category option
  Widget _buildCategoryOption({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required double textSize,
    required double iconSize,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
              size: iconSize,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: textSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for photo upload option - enhanced with image selection
  Widget _buildPhotoUploadOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required File? image,
    required double height,
    required double textSize,
    required double iconSize,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF1B0331),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: image != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                image,
                fit: BoxFit.cover,
              ),
              // Semi-transparent overlay with edit icon
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: textSize,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: textSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(height: 5),
            Icon(
              Icons.add_circle_outline,
              size: iconSize * 0.7,
              color: const Color(0xFF1B0331),
            ),
          ],
        ),
      ),
    );
  }
}