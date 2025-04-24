import 'package:flutter/material.dart';

class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({super.key});

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2D0A4F),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),

                    // Title - Making it match the design with "ADDRESS BOOK"
                    const Column(
                      children: [
                        Text(
                          'ADDRESS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'BOOK',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),

                    // Map Button
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.location_on, color: Colors.white, size: 20),
                        onPressed: () {
                          // Handle map action
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // White curved background for the content area - Fixed to match design
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView(
                        children: [
                          // Home Address Card
                          AddressCard(
                            type: 'Home',
                            icon: Icons.home,
                            isDefault: true,
                            name: 'Ms Green',
                            address: 'No.245, Abc road, Qrs, Xyz',
                            city: 'Colombo 1',
                            postalCode: '12345',
                            phone: '012-3456789',
                            onEdit: () {
                              showAddressForm(
                                context,
                                isEditing: true,
                                addressType: 'Home',
                                initialName: 'Ms Green',
                                initialAddress: 'No.245, Abc road, Qrs, Xyz',
                                initialDistrict: 'Colombo 1',
                                initialPostalCode: '12345',
                                initialPhone: '012-3456789',
                                initialIsDefault: true,
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // Office Address Card
                          AddressCard(
                            type: 'Office',
                            icon: Icons.business,
                            isDefault: false,
                            name: 'Ms Green',
                            address: 'No.123, Main Street, City',
                            city: 'Colombo 7',
                            postalCode: '54321',
                            phone: '012-9876543',
                            onEdit: () {
                              showAddressForm(
                                context,
                                isEditing: true,
                                addressType: 'Office',
                                initialName: 'Ms Green',
                                initialAddress: 'No.123, Main Street, City',
                                initialDistrict: 'Colombo 7',
                                initialPostalCode: '54321',
                                initialPhone: '012-9876543',
                                initialIsDefault: false,
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // Add New Address Button - Match the design
                          Container(
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.withAlpha(76),
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                showAddressForm(context);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 32,
                                    color: Colors.black.withAlpha(153),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Add',
                                    style: TextStyle(
                                      color: Colors.black.withAlpha(153),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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

  // Updated method to show Address form for both Add and Edit
  void showAddressForm(
      BuildContext context, {
        bool isEditing = false,
        String addressType = 'Home',
        String initialName = '',
        String initialAddress = '',
        String initialDistrict = '',
        String initialPostalCode = '',
        String initialPhone = '',
        bool initialIsDefault = false,
      }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddressForm(
            isEditing: isEditing,
            addressType: addressType,
            initialName: initialName,
            initialAddress: initialAddress,
            initialDistrict: initialDistrict,
            initialPostalCode: initialPostalCode,
            initialPhone: initialPhone,
            initialIsDefault: initialIsDefault,
          ),
        );
      },
    );
  }
}

class AddressCard extends StatelessWidget {
  final String type;
  final IconData icon;
  final bool isDefault;
  final String name;
  final String address;
  final String city;
  final String postalCode;
  final String phone;
  final VoidCallback onEdit;

  const AddressCard({
    super.key,
    required this.type,
    required this.icon,
    required this.isDefault,
    required this.name,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.phone,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withAlpha(51),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type and Actions Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Type with icon - Matching the design
                Row(
                  children: [
                    Icon(icon, size: 20, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      type,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D0A4F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Default',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // Edit and Delete buttons - Matching the design
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: onEdit,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () {
                        // Handle delete action
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Address Details - Matching the design spacing
            Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              address,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              city,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              postalCode,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              phone,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Renamed and updated class to handle both Add and Edit
class AddressForm extends StatefulWidget {
  final bool isEditing;
  final String addressType;
  final String initialName;
  final String initialAddress;
  final String initialDistrict;
  final String initialPostalCode;
  final String initialPhone;
  final bool initialIsDefault;

  const AddressForm({
    super.key,
    this.isEditing = false,
    this.addressType = 'Home',
    this.initialName = '',
    this.initialAddress = '',
    this.initialDistrict = '',
    this.initialPostalCode = '',
    this.initialPhone = '',
    this.initialIsDefault = false,
  });

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _districtController;
  late TextEditingController _postalCodeController;
  late TextEditingController _phoneController;
  late bool _isHomeSelected;
  late bool _isDefaultAddress;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with provided values or defaults
    _nameController = TextEditingController(
      text: widget.initialName.isNotEmpty ? widget.initialName : "Ms Green",
    );
    _addressController = TextEditingController(
      text: widget.initialAddress.isNotEmpty ? widget.initialAddress : "No.245, Abc road, Qrs, Xyz",
    );
    _districtController = TextEditingController(
      text: widget.initialDistrict.isNotEmpty ? widget.initialDistrict : "Colombo 1",
    );
    _postalCodeController = TextEditingController(
      text: widget.initialPostalCode.isNotEmpty ? widget.initialPostalCode : "12345",
    );
    _phoneController = TextEditingController(
      text: widget.initialPhone.isNotEmpty ? widget.initialPhone : "012-3456789",
    );
    _isHomeSelected = widget.addressType == 'Home';
    _isDefaultAddress = widget.initialIsDefault;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _districtController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Text(
                widget.isEditing ? 'Edit Address' : 'Add Address',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B0B56),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Form fields - Matching the design
            _buildFormField(
              icon: Icons.person,
              label: "Recipient's Name",
              controller: _nameController,
            ),
            const SizedBox(height: 16),

            _buildFormField(
              icon: Icons.location_on,
              label: "Address",
              controller: _addressController,
            ),
            const SizedBox(height: 16),

            _buildFormField(
              icon: Icons.apartment,
              label: "District",
              controller: _districtController,
            ),
            const SizedBox(height: 16),

            _buildFormField(
              icon: Icons.tag,
              label: "Postal Code",
              controller: _postalCodeController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            _buildFormField(
              icon: Icons.phone,
              label: "Recipient's Phone",
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),

            // Category
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Category",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2B0B56),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Home Button - Matching the design
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isHomeSelected = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isHomeSelected ? const Color(0xFF2D0A4F) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: _isHomeSelected
                                ? null
                                : Border.all(color: Colors.grey.withAlpha(127)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.home,
                                color: _isHomeSelected ? Colors.white : Colors.black,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Home",
                                style: TextStyle(
                                  color: _isHomeSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Office Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isHomeSelected = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isHomeSelected ? const Color(0xFF2D0A4F) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: !_isHomeSelected
                                ? null
                                : Border.all(color: Colors.grey.withAlpha(127)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.business,
                                color: !_isHomeSelected ? Colors.white : Colors.black,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Office",
                                style: TextStyle(
                                  color: !_isHomeSelected ? Colors.white : Colors.black,
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
              ],
            ),
            const SizedBox(height: 24),

            // Default Address Toggle - Matching the design
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 18,
                      color: Color(0xFF2B0B56),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Set as Default Address",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2B0B56),
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _isDefaultAddress,
                  activeColor: const Color(0xFF2D0A4F),
                  onChanged: (value) {
                    setState(() {
                      _isDefaultAddress = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Add/Update Address Button - Matching the design
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF2D0A4F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.isEditing ? Icons.check : Icons.add,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.isEditing ? "Update Address" : "Add Address",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: const Color(0xFF2B0B56),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2B0B56),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: Colors.grey.withAlpha(25),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            hintText: label,
          ),
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}