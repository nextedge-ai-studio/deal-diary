import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// 動作按鈕元件（收藏、分享、通知）
class ActionButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback? onTap;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const ActionButton({
    super.key,
    required this.icon,
    this.isActive = false,
    this.onTap,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: size,
          color: isActive
              ? (activeColor ?? AppColors.primary)
              : (inactiveColor ?? AppColors.textSecondary),
        ),
      ),
    );
  }
}

/// 收藏按鈕
class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback? onTap;
  final double size;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    this.onTap,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(isFavorite),
          size: size,
          color: isFavorite ? Colors.red : AppColors.textSecondary,
        ),
      ),
    );
  }
}

/// 分享按鈕
class ShareButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;

  const ShareButton({
    super.key,
    this.onTap,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          Icons.ios_share,
          size: size,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

/// 通知按鈕
class NotificationButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onTap;
  final double size;

  const NotificationButton({
    super.key,
    required this.isEnabled,
    this.onTap,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          isEnabled ? Icons.notifications : Icons.notifications_none,
          key: ValueKey(isEnabled),
          size: size,
          color: isEnabled ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}

/// 動作按鈕列
class ActionButtonRow extends StatelessWidget {
  final bool isFavorite;
  final bool notificationEnabled;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onNotificationTap;

  const ActionButtonRow({
    super.key,
    this.isFavorite = false,
    this.notificationEnabled = false,
    this.onFavoriteTap,
    this.onShareTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FavoriteButton(
          isFavorite: isFavorite,
          onTap: onFavoriteTap,
        ),
        const SizedBox(width: 15),
        ShareButton(onTap: onShareTap),
        const SizedBox(width: 15),
        NotificationButton(
          isEnabled: notificationEnabled,
          onTap: onNotificationTap,
        ),
      ],
    );
  }
}
