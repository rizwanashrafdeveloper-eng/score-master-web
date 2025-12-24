import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorer_web/constants/appcolors.dart';

class LoginTextfield extends StatefulWidget {
  final double? fontsize;
  final String text;
  final bool isPassword;
  final bool ishow;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final int? maxLines;

  const LoginTextfield({
    super.key,
    required this.text,
    this.fontsize,
    this.isPassword = false,
    this.ishow = true,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  State<LoginTextfield> createState() => _LoginTextfieldState();
}

class _LoginTextfieldState extends State<LoginTextfield> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 768;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSmallScreen ? 12.r : 16.r),
        border: Border.all(
          color: widget.ishow
              ? AppColors.selectLangugaeColor.withOpacity(0.1)
              : Colors.transparent,
          width: widget.ishow ? 2.w : 0,
        ),
        color: widget.ishow ? null : Colors.grey.shade100,
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        validator: widget.validator,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        style: TextStyle(
          fontFamily: "giory",
          fontSize: widget.fontsize ?? (isSmallScreen ? 16.sp : 18.sp),
          color: Colors.black,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12.w : 16.w,
            vertical: isSmallScreen ? 14.h : 16.h,
          ),
          hintText: widget.text,
          hintStyle: TextStyle(
            fontFamily: "giory",
            fontSize: widget.fontsize ?? (isSmallScreen ? 16.sp : 18.sp),
            color: AppColors.languageTextColor.withOpacity(0.6),
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: AppColors.languageTextColor,
              size: isSmallScreen ? 20.sp : 24.sp,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:scorer_web/constants/appcolors.dart';
//
// class LoginTextfield extends StatefulWidget {
//   final double? fontsize;
//   final String text;
//   final double? height;
//   final bool isPassword;
//   final bool ishow; // Added ishow parameter
//   final TextEditingController? controller;
//   final String? Function(String?)? validator;
//   final Function(String)? onChanged; // Added onChanged parameter
//   final TextInputType? keyboardType; // Added keyboardType parameter
//   final int? maxLines; // Added maxLines for multiline support
//
//   const LoginTextfield({
//     super.key,
//     required this.text,
//     this.fontsize,
//     this.height,
//     this.isPassword = false,
//     this.ishow = true, // Default value for ishow
//     this.controller,
//     this.validator,
//     this.onChanged,
//     this.keyboardType,
//     this.maxLines = 1,
//   });
//
//   @override
//   State<LoginTextfield> createState() => _LoginTextfieldState();
// }
//
// class _LoginTextfieldState extends State<LoginTextfield> {
//   bool _obscureText = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _obscureText = widget.isPassword;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: widget.height ?? 74.h,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(26.r),
//         border: Border.all(
//           color: widget.ishow
//               ? AppColors.selectLangugaeColor.withOpacity(0.1)
//               : Colors.transparent, // Handle ishow for border visibility
//           width: widget.ishow ? 3.w : 0,
//         ),
//         color: widget.ishow ? null : Colors.grey.shade100, // Optional background when no border
//       ),
//       child: TextFormField(
//         controller: widget.controller,
//         obscureText: widget.isPassword ? _obscureText : false,
//         validator: widget.validator,
//         onChanged: widget.onChanged,
//         keyboardType: widget.keyboardType,
//         maxLines: widget.maxLines,
//         decoration: InputDecoration(
//           contentPadding: EdgeInsets.symmetric(
//             horizontal: 16.w,
//             vertical: 18.h,
//           ),
//           hintText: widget.text,
//           hintStyle: TextStyle(
//             fontFamily: "giory",
//             fontSize: widget.fontsize ?? 21.sp,
//             color: AppColors.languageTextColor,
//           ),
//           enabledBorder: InputBorder.none,
//           focusedBorder: InputBorder.none,
//           suffixIcon: widget.isPassword
//               ? IconButton(
//             icon: Icon(
//               _obscureText ? Icons.visibility_off : Icons.visibility,
//               color: AppColors.languageTextColor,
//             ),
//             onPressed: () {
//               setState(() {
//                 _obscureText = !_obscureText;
//               });
//             },
//           )
//               : null,
//         ),
//       ),
//     );
//   }
// }