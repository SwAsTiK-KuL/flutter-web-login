import 'package:flutter/material.dart';

class LoginImageWidget extends StatelessWidget {
  const LoginImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final containerWidth = constraints.maxWidth;

        // Determine device type
        final bool isMobile = screenWidth < 768;
        final bool isTablet = screenWidth >= 768 && screenWidth < 1024;
        final bool isDesktop = screenWidth >= 1024;

        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: _getMaxImageWidth(isMobile, isTablet, containerWidth),
              maxHeight: _getMaxImageHeight(isMobile, isTablet, isDesktop),
            ),
            child: _buildResponsiveImage(
              context,
              isMobile,
              isTablet,
              isDesktop,
            ),
          ),
        );
      },
    );
  }

  Widget _buildResponsiveImage(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  ) {
    return AspectRatio(
      aspectRatio: _getAspectRatio(isMobile, isTablet),
      child: Container(
        padding: EdgeInsets.all(_getImagePadding(isMobile, isTablet)),
        child: Image.asset(
          'assets/login-image-png.png',
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/login-image.svg',
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return _buildResponsiveFallback(isMobile, isTablet, isDesktop);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildResponsiveFallback(
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  ) {
    return Container(
      height: _getFallbackHeight(isMobile, isTablet, isDesktop),
      padding: EdgeInsets.all(_getImagePadding(isMobile, isTablet)),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: _getFallbackIconSize(isMobile, isTablet, isDesktop),
              color: const Color(0xFF6B7280),
            ),
            const SizedBox(height: 16),
            Text(
              _getFallbackText(isMobile),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _getFallbackTextSize(isMobile, isTablet),
                color: const Color(0xFF6B7280),
                fontWeight: FontWeight.w400,
              ),
            ),
            if (!isMobile) ...[
              const SizedBox(height: 8),
              Text(
                'Image will appear here when available',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _getFallbackSubtextSize(isMobile, isTablet),
                  color: const Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Responsive sizing methods
  double _getMaxImageWidth(
    bool isMobile,
    bool isTablet,
    double containerWidth,
  ) {
    if (isMobile) {
      return containerWidth * 0.9; // 90% of container width on mobile
    } else if (isTablet) {
      return containerWidth * 0.85; // 85% on tablet
    }
    return containerWidth * 0.8; // 80% on desktop
  }

  double _getMaxImageHeight(bool isMobile, bool isTablet, bool isDesktop) {
    if (isMobile) return 280;
    if (isTablet) return 380;
    return 450; // Desktop
  }

  double _getAspectRatio(bool isMobile, bool isTablet) {
    if (isMobile) return 1.2; // Slightly wider than tall on mobile
    if (isTablet) return 1.3;
    return 1.4; // More rectangular on desktop
  }

  double _getImagePadding(bool isMobile, bool isTablet) {
    if (isMobile) return 8.0;
    if (isTablet) return 12.0;
    return 16.0; // Desktop
  }

  double _getFallbackHeight(bool isMobile, bool isTablet, bool isDesktop) {
    if (isMobile) return 200;
    if (isTablet) return 300;
    return 400; // Desktop
  }

  double _getFallbackIconSize(bool isMobile, bool isTablet, bool isDesktop) {
    if (isMobile) return 48;
    if (isTablet) return 64;
    return 80; // Desktop
  }

  String _getFallbackText(bool isMobile) {
    return isMobile ? 'Login Image' : 'Login Image\nPlaceholder';
  }

  double _getFallbackTextSize(bool isMobile, bool isTablet) {
    if (isMobile) return 14;
    if (isTablet) return 15;
    return 16; // Desktop
  }

  double _getFallbackSubtextSize(bool isMobile, bool isTablet) {
    if (isMobile) return 11;
    if (isTablet) return 12;
    return 13; // Desktop
  }
}

class ResponsiveLoginImage extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit? fit;

  const ResponsiveLoginImage({Key? key, this.width, this.height, this.fit})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 768;

        return Container(
          width:
              width ??
              (isMobile
                  ? constraints.maxWidth * 0.9
                  : constraints.maxWidth * 0.8),
          height: height ?? (isMobile ? 250 : 400),
          child: Image.asset(
            'assets/login-image-png.png',
            fit: fit ?? BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 48,
                    color: Color(0xFF6B7280),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
