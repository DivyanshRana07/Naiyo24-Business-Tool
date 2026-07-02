import 'package:flutter/material.dart';
import '../theme/theme.dart';

void showChatSupportPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) => const ChatSupportPopup(),
  );
}

class ChatSupportPopup extends StatelessWidget {
  const ChatSupportPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxWidth = size.width - 48; // 24px padding on both sides
    final maxHeight = size.height - 120; // safe area + padding

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 24, bottom: 90),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: maxWidth < 360 ? maxWidth : 360,
            height: maxHeight < 640 ? maxHeight : 640,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                Expanded(child: _buildMessagesArea()),
                _buildInputArea(context),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF6D28D9), // Primary purple
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppBorderRadius.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6), // Lighter purple active state
                            borderRadius: BorderRadius.circular(AppBorderRadius.full),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.chat_bubble_rounded, size: 14, color: Colors.white),
                              const SizedBox(width: 6),
                              Text('Messages', style: AppTextStyles.labelMedium.copyWith(color: Colors.white)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: Text('Articles', style: AppTextStyles.labelMedium.copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white70),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFC4B5FD), Color(0xFF4C1D95)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.change_history_rounded, color: Colors.white, size: 24),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Questions? Chat with us.',
                      style: AppTextStyles.h2.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Our team can also help',
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesArea() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6), // Light grey
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            ),
            child: Text(
              'Hello! How can I help you? 🙂',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        ),
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Compose your message...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                isDense: true,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined, color: AppColors.textSecondary),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Emojis coming soon')),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file_rounded, color: AppColors.textSecondary),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Attachments coming soon')),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
                IconButton(
                  icon: const Icon(Icons.graphic_eq_rounded, color: AppColors.textSecondary), // Audio icon equivalent
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Voice messages coming soon')),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: Color(0xFFC4B5FD)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Message sent!')),
                    );
                    Navigator.of(context).pop();
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: AppSpacing.md, top: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Answers by ', style: AppTextStyles.caption),
          const Icon(Icons.auto_awesome_mosaic_rounded, size: 14, color: AppColors.textPrimary),
          Text(' Naiyo24', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
