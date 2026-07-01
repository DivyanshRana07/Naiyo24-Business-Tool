import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../utils/export_helper.dart';

class SendOptionsDialog extends StatelessWidget {
  const SendOptionsDialog({
    super.key,
    required this.title,
    required this.whatsappText,
    required this.pdfContent,
    required this.filenamePrefix,
    required this.onClose,
  });

  final String title;
  final String whatsappText;
  final String pdfContent;
  final String filenamePrefix;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
      ),
      elevation: 8,
      backgroundColor: AppColors.surface,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Export Options', style: AppTextStyles.h2),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                    onClose();
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Select your preferred format to export the $title list.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildOptionCard(
              context: context,
              icon: Icons.chat_outlined,
              color: Colors.green,
              title: 'Send to WhatsApp...',
              subtitle: 'Open WhatsApp with data summary text',
              onTap: () {
                shareToWhatsApp(text: whatsappText);
                Navigator.pop(context);
                onClose();
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _buildOptionCard(
              context: context,
              icon: Icons.picture_as_pdf_rounded,
              color: AppColors.error,
              title: 'Download / Print as PDF',
              subtitle: 'Download printable text report document (.pdf)',
              onTap: () {
                downloadFile(
                  filename: '${filenamePrefix}_report.pdf',
                  content: pdfContent,
                  mimeType: 'application/pdf',
                );
                Navigator.pop(context);
                onClose();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('PDF report exported successfully!'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _buildOptionCard(
              context: context,
              icon: Icons.share_rounded,
              color: Colors.teal,
              title: 'Share via other apps',
              subtitle: 'Share standard format text...',
              onTap: () {
                // For web, this usually triggers the native share sheet or falls back
                // We will just use the download logic or copy to clipboard
                downloadFile(
                  filename: '${filenamePrefix}_share.txt',
                  content: whatsappText,
                  mimeType: 'text/plain',
                );
                Navigator.pop(context);
                onClose();
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onClose();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                ),
                child: Text('Cancel', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
