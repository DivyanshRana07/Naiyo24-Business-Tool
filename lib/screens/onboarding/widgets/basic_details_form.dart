import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BasicDetailsForm extends StatefulWidget {
  final VoidCallback onNext;
  const BasicDetailsForm({super.key, required this.onNext});

  @override
  State<BasicDetailsForm> createState() => _BasicDetailsFormState();
}

class _BasicDetailsFormState extends State<BasicDetailsForm> {
  bool _hasGst = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Let's setup your business",
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 40),
        
        Align(
          alignment: Alignment.centerLeft,
          child: _buildLabel("1. Business Name*", sub: "Official Name used across Accounting documents and reports."),
        ),
        TextFormField(
          decoration: _inputDecoration("If you're a freelancer, add your personal name"),
        ),
        const SizedBox(height: 12),
        
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add Brand name coming soon')),
              );
            },
            icon: const Icon(Icons.add_box_outlined, color: Color(0xFF7C3AED), size: 18),
            label: Text(
              "Add Brand or Display name",
              style: GoogleFonts.inter(color: const Color(0xFF7C3AED)),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
        const SizedBox(height: 24),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("2. Team Size*"),
                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration("Select Team Size"),
                    items: const [],
                    onChanged: (v) {},
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("3. Website"),
                  TextFormField(
                    decoration: _inputDecoration("Your Work Website"),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        Align(
          alignment: Alignment.centerLeft,
          child: _buildLabel("4. Phone Number*", sub: "Contact phone number associated with your business"),
        ),
        TextFormField(
          decoration: _inputDecoration("").copyWith(
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 12),
                const Text("🇮🇳", style: TextStyle(fontSize: 16)),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
                const SizedBox(width: 8),
                Text("+91", style: GoogleFonts.inter(fontSize: 14, color: Colors.black87)),
                const SizedBox(width: 12),
                Container(width: 1, height: 24, color: Colors.grey.shade300),
                const SizedBox(width: 12),
              ],
            ),
          ),
          initialValue: "98973-69111",
        ),
        const SizedBox(height: 24),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("5. Country*"),
                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration("India"),
                    items: const [],
                    onChanged: (v) {},
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("6. Currency*"),
                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration("Indian Rupee(INR, ₹)"),
                    items: const [],
                    onChanged: (v) {},
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _buildLabel("7. Have GST Number?", sub: "Add your GSTIN to unlock smart AI and GST workflows."),
            ),
            Switch(
              value: _hasGst,
              activeColor: const Color(0xFF7C3AED),
              onChanged: (v) {
                setState(() {
                  _hasGst = v;
                });
              },
            ),
          ],
        ),
        if (_hasGst) ...[
          const SizedBox(height: 12),
          TextFormField(
            decoration: _inputDecoration("Enter Your GST Number"),
          ),
        ],
        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: widget.onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Continue",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
              ],
            ),
          ),
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
      hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade400),
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
