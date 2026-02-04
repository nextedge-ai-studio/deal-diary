import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/merchant_assets.dart';

/// 商家頭像元件
class MerchantAvatar extends StatelessWidget {
  final String? logoUrl;
  final String merchantName;
  final double size;
  final Color? backgroundColor;
  final Color? borderColor;

  const MerchantAvatar({
    super.key,
    this.logoUrl,
    required this.merchantName,
    this.size = 48,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final assetPath = MerchantAssets.getAssetPath(merchantName);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor ?? AppColors.border,
          width: 0.6,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: assetPath != null
          ? _buildAssetImage(assetPath)
          : (logoUrl != null && logoUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: logoUrl!,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => _buildPlaceholder(),
                  errorWidget: (context, url, error) => _buildFallback(),
                )
              : _buildFallback()),
    );
  }

  Widget _buildAssetImage(String path) {
    if (path.endsWith('.svg')) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          path,
          fit: BoxFit.contain,
        ),
      );
    }
    return Image.asset(
      path,
      fit: BoxFit.cover,
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.tagBackground,
      child: Center(
        child: SizedBox(
          width: size * 0.4,
          height: size * 0.4,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildFallback() {
    final initial = merchantName.isNotEmpty ? merchantName[0].toUpperCase() : '?';
    return Container(
      color: AppColors.tagBackground,
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: size * 0.4,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
