import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Comprehensive Responsive System
///
/// Breakpoints:
/// - Mobile: < 600px
/// - Tablet: 600px - 1200px
/// - Desktop: >= 1200px
class ResponsiveUtils {
  // ==================== BREAKPOINTS ====================
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1200;

  // ==================== DEVICE TYPE CHECKS ====================
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
          MediaQuery.of(context).size.width < tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  static String getDeviceType(BuildContext context) {
    if (isMobile(context)) return 'Mobile';
    if (isTablet(context)) return 'Tablet';
    return 'Desktop';
  }

  // ==================== RESPONSIVE VALUES ====================
  /// Get responsive value based on device type
  static T value<T>(
      BuildContext context, {
        required T mobile,
        T? tablet,
        T? desktop,
      }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  // ==================== FONT SIZES ====================
  static double fontSize(
      BuildContext context, {
        double mobile = 14,
        double? tablet,
        double? desktop,
      }) {
    return value(
      context,
      mobile: mobile.sp,
      tablet: (tablet ?? mobile * 1.15).sp,
      desktop: (desktop ?? mobile * 1.3).sp,
    );
  }

  // Predefined font sizes
  static double get titleFont => 24.sp;
  static double get headingFont => 20.sp;
  static double get bodyFont => 16.sp;
  static double get captionFont => 14.sp;
  static double get smallFont => 12.sp;

  // ==================== SPACING ====================
  static double spacing(
      BuildContext context, {
        double mobile = 8,
        double? tablet,
        double? desktop,
      }) {
    return value(
      context,
      mobile: mobile.w,
      tablet: (tablet ?? mobile * 1.5).w,
      desktop: (desktop ?? mobile * 2).w,
    );
  }

  // Predefined spacing values
  static double get tinySpace => 4.w;
  static double get smallSpace => 8.w;
  static double get mediumSpace => 16.w;
  static double get largeSpace => 24.w;
  static double get extraLargeSpace => 32.w;

  // ==================== PADDING ====================
  static EdgeInsets padding(
      BuildContext context, {
        double mobile = 16,
        double? tablet,
        double? desktop,
      }) {
    final value = spacing(context, mobile: mobile, tablet: tablet, desktop: desktop);
    return EdgeInsets.all(value);
  }

  static EdgeInsets paddingHorizontal(
      BuildContext context, {
        double mobile = 16,
        double? tablet,
        double? desktop,
      }) {
    final value = spacing(context, mobile: mobile, tablet: tablet, desktop: desktop);
    return EdgeInsets.symmetric(horizontal: value);
  }

  static EdgeInsets paddingVertical(
      BuildContext context, {
        double mobile = 16,
        double? tablet,
        double? desktop,
      }) {
    final value = spacing(context, mobile: mobile, tablet: tablet, desktop: desktop);
    return EdgeInsets.symmetric(vertical: value);
  }

  // Predefined padding
  static EdgeInsets get tinyPadding => EdgeInsets.all(4.w);
  static EdgeInsets get smallPadding => EdgeInsets.all(8.w);
  static EdgeInsets get mediumPadding => EdgeInsets.all(16.w);
  static EdgeInsets get largePadding => EdgeInsets.all(24.w);

  // ==================== ICON SIZES ====================
  static double iconSize(
      BuildContext context, {
        double mobile = 24,
        double? tablet,
        double? desktop,
      }) {
    return value(
      context,
      mobile: mobile.sp,
      tablet: (tablet ?? mobile * 1.2).sp,
      desktop: (desktop ?? mobile * 1.5).sp,
    );
  }

  // Predefined icon sizes
  static double get smallIcon => 16.sp;
  static double get mediumIcon => 24.sp;
  static double get largeIcon => 32.sp;
  static double get extraLargeIcon => 48.sp;

  // ==================== DIMENSIONS ====================
  static double width(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }

  static double height(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }

  // Get screen dimensions
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  // ==================== BUTTON SIZES ====================
  static Size buttonSize(BuildContext context, {
    Size mobile = const Size(120, 45),
    Size? tablet,
    Size? desktop,
  }) {
    return value(
      context,
      mobile: Size(mobile.width.w, mobile.height.h),
      tablet: tablet != null ? Size(tablet.width.w, tablet.height.h) : null,
      desktop: desktop != null ? Size(desktop.width.w, desktop.height.h) : null,
    );
  }

  // ==================== BORDER RADIUS ====================
  static BorderRadius borderRadius(
      BuildContext context, {
        double mobile = 8,
        double? tablet,
        double? desktop,
      }) {
    final value = spacing(context, mobile: mobile, tablet: tablet, desktop: desktop);
    return BorderRadius.circular(value);
  }

  static double get smallRadius => 4.r;
  static double get mediumRadius => 8.r;
  static double get largeRadius => 16.r;
  static double get extraLargeRadius => 24.r;

  // ==================== GRID COLUMNS ====================
  static int gridColumns(BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    return value(context, mobile: mobile, tablet: tablet, desktop: desktop);
  }

  // ==================== SAFE AREA ====================
  static EdgeInsets safeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  // ==================== ORIENTATION ====================
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }
}

// ==================== EXTENSION METHODS ====================
/// Extensions for easy access to responsive utilities
extension ResponsiveContext on BuildContext {
  // Device type checks
  bool get isMobile => ResponsiveUtils.isMobile(this);
  bool get isTablet => ResponsiveUtils.isTablet(this);
  bool get isDesktop => ResponsiveUtils.isDesktop(this);
  String get deviceType => ResponsiveUtils.getDeviceType(this);

  // Responsive values
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) => ResponsiveUtils.value(this, mobile: mobile, tablet: tablet, desktop: desktop);

  // Dimensions
  double widthPercent(double percentage) => ResponsiveUtils.width(this, percentage);
  double heightPercent(double percentage) => ResponsiveUtils.height(this, percentage);
  double get screenWidth => ResponsiveUtils.screenWidth(this);
  double get screenHeight => ResponsiveUtils.screenHeight(this);

  // Spacing
  double spacing({double mobile = 8, double? tablet, double? desktop}) =>
      ResponsiveUtils.spacing(this, mobile: mobile, tablet: tablet, desktop: desktop);

  // Padding
  EdgeInsets padding({double mobile = 16, double? tablet, double? desktop}) =>
      ResponsiveUtils.padding(this, mobile: mobile, tablet: tablet, desktop: desktop);

  EdgeInsets paddingH({double mobile = 16, double? tablet, double? desktop}) =>
      ResponsiveUtils.paddingHorizontal(this, mobile: mobile, tablet: tablet, desktop: desktop);

  EdgeInsets paddingV({double mobile = 16, double? tablet, double? desktop}) =>
      ResponsiveUtils.paddingVertical(this, mobile: mobile, tablet: tablet, desktop: desktop);

  // Font sizes
  double fontSize({double mobile = 14, double? tablet, double? desktop}) =>
      ResponsiveUtils.fontSize(this, mobile: mobile, tablet: tablet, desktop: desktop);

  // Icon sizes
  double iconSize({double mobile = 24, double? tablet, double? desktop}) =>
      ResponsiveUtils.iconSize(this, mobile: mobile, tablet: tablet, desktop: desktop);

  // Border radius
  BorderRadius borderRadius({double mobile = 8, double? tablet, double? desktop}) =>
      ResponsiveUtils.borderRadius(this, mobile: mobile, tablet: tablet, desktop: desktop);

  // Grid columns
  int gridColumns({int mobile = 1, int tablet = 2, int desktop = 3}) =>
      ResponsiveUtils.gridColumns(this, mobile: mobile, tablet: tablet, desktop: desktop);

  // Orientation
  bool get isPortrait => ResponsiveUtils.isPortrait(this);
  bool get isLandscape => ResponsiveUtils.isLandscape(this);
}

// ==================== RESPONSIVE WIDGETS ====================
/// Responsive builder widget
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, String deviceType) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, ResponsiveUtils.getDeviceType(context));
  }
}

/// Responsive layout with separate widgets for each device type
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveUtils.isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    }
    if (ResponsiveUtils.isTablet(context)) {
      return tablet ?? mobile;
    }
    return mobile;
  }
}

/// Responsive sized box
class ResponsiveSizedBox extends StatelessWidget {
  final double? mobile;
  final double? tablet;
  final double? desktop;
  final bool isHeight;

  const ResponsiveSizedBox({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.isHeight = true,
  });

  const ResponsiveSizedBox.width({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
  }) : isHeight = false;

  @override
  Widget build(BuildContext context) {
    final value = ResponsiveUtils.spacing(
      context,
      mobile: mobile ?? 0,
      tablet: tablet,
      desktop: desktop,
    );

    return isHeight
        ? SizedBox(height: value)
        : SizedBox(width: value);
  }
}