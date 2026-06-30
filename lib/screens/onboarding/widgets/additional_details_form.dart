import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdditionalDetailsForm extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onFinish;

  const AdditionalDetailsForm({
    super.key,
    required this.onBack,
    required this.onFinish,
  });

  @override
  State<AdditionalDetailsForm> createState() => _AdditionalDetailsFormState();
}

class _AdditionalDetailsFormState extends State<AdditionalDetailsForm> {
  String? _selectedCategory;

  final List<Map<String, dynamic>> _categories = [
    {"icon": Icons.factory_outlined, "title": "Manufacturer", "sub": "Produce & sell goods."},
    {"icon": Icons.inventory_2_outlined, "title": "Trading", "sub": "Buy & resell goods."},
    {"icon": Icons.storefront_outlined, "title": "Retail", "sub": "Sell via physical stores."},
    {"icon": Icons.shopping_cart_outlined, "title": "Online", "sub": "Online store or marketplace."},
    {"icon": Icons.business_center_outlined, "title": "Professional Services", "sub": "Provide expertise & consulting."},
    {"icon": Icons.construction_outlined, "title": "Contractor", "sub": "End-to-end project delivery."},
    {"icon": Icons.computer_outlined, "title": "Software", "sub": "Sell software or digital products."},
    {"icon": Icons.auto_awesome_outlined, "title": "Something else", "sub": "My business is different."},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Tell us more about your business",
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 40),

        Align(
          alignment: Alignment.centerLeft,
          child: _buildLabel("1. What do you want to use Refrens for?*", sub: "Help us serve you better!"),
        ),
        DropdownButtonFormField<String>(
          decoration: _inputDecoration("Select..."),
          items: const [],
          onChanged: (v) {},
        ),
        const SizedBox(height: 24),

        Align(
          alignment: Alignment.centerLeft,
          child: _buildLabel("2. What best describes your business?", sub: "Choose the category that matches how your business operates to get a personalized onboarding experience."),
        ),
        
        LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            bool isMobile = width < 500;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: _categories.map((cat) {
                bool isSelected = _selectedCategory == cat["title"];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = cat["title"];
                    });
                  },
                  child: CategoryCard(
                    icon: cat["icon"],
                    title: cat["title"],
                    subtitle: cat["sub"],
                    isSelected: isSelected,
                    width: isMobile ? width : (width - 16) / 2,
                  ),
                );
              }).toList(),
            );
          }
        ),

        const SizedBox(height: 40),

        Row(
          children: [
            TextButton.icon(
              onPressed: widget.onBack,
              icon: const Icon(Icons.arrow_back, size: 18, color: Colors.black87),
              label: Text(
                "Back",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 52, // Matched height
                child: ElevatedButton(
                  onPressed: widget.onFinish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: Text(
                    "Finish Setup",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabel(String main, {String? sub}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: main.replaceAll('*', ''),
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            children: [
              if (main.contains('*'))
                const TextSpan(text: '*', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        if (sub != null) ...[
          const SizedBox(height: 4),
          Text(
            sub,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final double width;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? const Color(0xFF7C3AED) : Colors.grey.shade300,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey.shade500, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFF7C3AED) : Colors.grey.shade300,
                width: isSelected ? 5 : 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
