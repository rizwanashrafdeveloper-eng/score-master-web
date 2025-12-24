import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/main_text.dart';
import 'package:scorer_web/widgets/useable_container.dart';

class PlayersContainers extends StatefulWidget {
  final String text1;
  final String text2;
  final String image;
  final Color? color;
  final String? text3;
  final double? width1;
  final IconData? icon;
  final String? text4;
  final Color? iconColor;
  final Color? containerColor;
  final bool ishow;
  final double? imageheight;
  final double? imageWidth;
  final double? leftPadding;
  final Duration? delay;
  final VoidCallback? onTap;
  final bool isSmallScreen;

  const PlayersContainers({
    super.key,
    required this.text1,
    required this.text2,
    required this.image,
    this.color,
    this.text3,
    this.width1,
    this.icon,
    this.text4,
    this.containerColor,
    this.iconColor,
    this.ishow = false,
    this.imageheight,
    this.imageWidth,
    this.leftPadding,
    this.delay,
    this.onTap,
    this.isSmallScreen = false,
  });

  @override
  State<PlayersContainers> createState() => _PlayersContainersState();
}

class _PlayersContainersState extends State<PlayersContainers>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    print("🎬 [Web PlayersContainers] Initializing animations for ${widget.text2}");

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    Future.delayed(widget.delay ?? Duration.zero, () {
      if (mounted) {
        _controller.forward();
        print("✅ [Web PlayersContainers] Animation started for ${widget.text2}");
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    print("🗑️ [Web PlayersContainers] Disposed animations for ${widget.text2}");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTap: () {
              print("👆 [Web PlayersContainers] Player tapped: ${widget.text2}");
              widget.onTap?.call();
            },
            child: Container(
              width: double.infinity,
              height: widget.isSmallScreen ? 70.h : 85.h,
              constraints: BoxConstraints(
                maxHeight: 85.h,
                minHeight: 60.h,
              ),
              decoration: BoxDecoration(
                color: widget.containerColor ?? AppColors.playerColor,
                borderRadius: BorderRadius.circular(widget.isSmallScreen ? 20.r : 30.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: widget.leftPadding ?? (widget.isSmallScreen ? 15.w : 30.w),
                  right: widget.isSmallScreen ? 15.w : 30.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          if (widget.ishow && widget.icon != null)
                            Icon(
                              widget.icon,
                              color: widget.iconColor ?? AppColors.forwardColor,
                              size: widget.isSmallScreen ? 30.w : 40.w,
                            ),
                          if (widget.ishow && widget.icon != null)
                            SizedBox(width: widget.isSmallScreen ? 5.w : 7.w),
                          BoldText(
                            text: widget.text1,
                            selectionColor: AppColors.blueColor,
                            fontSize: widget.isSmallScreen ? 12.sp : 15.sp,
                          ),
                          SizedBox(width: widget.isSmallScreen ? 10.w : 17.w),
                          Hero(
                            tag: 'player_${widget.text2}',
                            child: Container(
                              width: widget.imageWidth ?? (widget.isSmallScreen ? 45.w : 60.w),
                              height: widget.imageheight ?? (widget.isSmallScreen ? 45.w : 60.w),
                              constraints: BoxConstraints(
                                maxWidth: 60.w,
                                minWidth: 40.w,
                                maxHeight: 60.w,
                                minHeight: 40.w,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(widget.image),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(
                                  color: AppColors.forwardColor.withOpacity(0.3),
                                  width: 1.5.w,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: widget.isSmallScreen ? 5.w : 7.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MainText(
                                  text: widget.text2,
                                  fontSize: widget.isSmallScreen ? 11.sp : 13.sp,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (widget.text3 != null && !widget.ishow)
                                  MainText(
                                    text: widget.text3!,
                                    fontSize: widget.isSmallScreen ? 9.sp : 11.sp,
                                    color: AppColors.teamColor,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.ishow && widget.text4 != null)
                      BoldText(
                        text: widget.text4 ?? "",
                        fontSize: widget.isSmallScreen ? 18.sp : 24.sp,
                        selectionColor: AppColors.blueColor,
                      )
                    else if (!widget.ishow)
                      Flexible(
                        child: UseableContainer(
                          fontSize: widget.isSmallScreen ? 14.sp : 18.sp,
                          text: widget.text3 ?? "active".tr,
                          color: widget.color ?? AppColors.forwardColor,
                         // isSmallScreen: widget.isSmallScreen,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:scorer_web/constants/appcolors.dart';
// import 'package:scorer_web/widgets/bold_text.dart';
// import 'package:scorer_web/widgets/main_text.dart';
// import 'package:scorer_web/widgets/useable_container.dart';
//
// class PlayersContainers extends StatefulWidget {
//   final String text1;
//   final String text2;
//   final String image;
//   final Color? color;
//   final String? text3;
//   final double? width1;
//   final IconData? icon;
//   final String? text4;
//   final Color? iconColor;
//   final Color? containerColor;
//   final bool ishow;
//   final double? imageheight;
//   final double? imageWidth;
//   final double? leftPadding;
//   final Duration? delay;
//   final VoidCallback? onTap;
//
//   const PlayersContainers({
//     super.key,
//     required this.text1,
//     required this.text2,
//     required this.image,
//     this.color,
//     this.text3,
//     this.width1,
//     this.icon,
//     this.text4,
//     this.containerColor,
//     this.iconColor,
//     this.ishow = false,
//     this.imageheight,
//     this.imageWidth,
//     this.leftPadding,
//     this.delay,
//     this.onTap,
//   });
//
//   @override
//   State<PlayersContainers> createState() => _PlayersContainersState();
// }
//
// class _PlayersContainersState extends State<PlayersContainers>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     print("🎬 [Web PlayersContainers] Initializing animations for ${widget.text2}");
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(-0.3, 0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOutCubic,
//     ));
//
//     _fadeAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeIn,
//     ));
//
//     _scaleAnimation = Tween<double>(
//       begin: 0.9,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.elasticOut,
//     ));
//
//     Future.delayed(widget.delay ?? Duration.zero, () {
//       if (mounted) {
//         _controller.forward();
//         print("✅ [Web PlayersContainers] Animation started for ${widget.text2}");
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     print("🗑️ [Web PlayersContainers] Disposed animations for ${widget.text2}");
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SlideTransition(
//       position: _slideAnimation,
//       child: FadeTransition(
//         opacity: _fadeAnimation,
//         child: ScaleTransition(
//           scale: _scaleAnimation,
//           child: GestureDetector(
//             onTap: () {
//               print("👆 [Web PlayersContainers] Player tapped: ${widget.text2}");
//               widget.onTap?.call();
//             },
//             child: Container(
//               width: double.infinity,
//               height: 85.h,
//               decoration: BoxDecoration(
//                 color: widget.containerColor ?? AppColors.playerColor,
//                 borderRadius: BorderRadius.circular(30.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 8.r,
//                     offset: Offset(0, 2.h),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: EdgeInsets.only(
//                   left: widget.leftPadding ?? 30.w,
//                   right: 30.w,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         if (widget.ishow && widget.icon != null)
//                           Icon(
//                             widget.icon,
//                             color: widget.iconColor ?? AppColors.forwardColor,
//                             size: 40.w,
//                           ),
//                         if (widget.ishow && widget.icon != null) SizedBox(width: 7.w),
//                         BoldText(
//                           text: widget.text1,
//                           selectionColor: AppColors.blueColor,
//                           fontSize: 15.sp,
//                         ),
//                         SizedBox(width: 17.w),
//                         Hero(
//                           tag: 'player_${widget.text2}',
//                           child: Container(
//                             width: widget.imageWidth ?? 60.w,
//                             height: widget.imageheight ?? 60.w,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               image: DecorationImage(
//                                 image: AssetImage(widget.image),
//                                 fit: BoxFit.cover,
//                               ),
//                               border: Border.all(
//                                 color: AppColors.forwardColor.withOpacity(0.3),
//                                 width: 2.w,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 7.w),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               MainText(
//                                 text: widget.text2,
//                                 fontSize: 13.sp,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               if (widget.text3 != null && !widget.ishow)
//                                 MainText(
//                                   text: widget.text3!,
//                                   fontSize: 11.sp,
//                                   color: AppColors.teamColor,
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     if (widget.ishow && widget.text4 != null)
//                       BoldText(
//                         text: widget.text4 ?? "",
//                         fontSize: 24.sp,
//                         selectionColor: AppColors.blueColor,
//                       )
//                     else if (!widget.ishow)
//                       Flexible(
//                         child: UseableContainer(
//                           fontSize: 18.sp,
//                           text: widget.text3 ?? "active".tr,
//                           color: widget.color ?? AppColors.forwardColor,
//
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }