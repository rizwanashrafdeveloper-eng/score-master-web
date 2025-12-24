import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scorer_web/constants/appcolors.dart';
import 'package:scorer_web/constants/appimages.dart';
import 'package:scorer_web/view/gradient_background.dart';
import 'package:scorer_web/widgets/bold_text.dart';
import 'package:scorer_web/widgets/custom_appbar.dart';
import 'package:scorer_web/widgets/forward_button_container.dart';

class NotificationScreenWeb extends StatefulWidget {
  const NotificationScreenWeb({super.key});

  @override
  State<NotificationScreenWeb> createState() => _NotificationScreenWebState();
}

class _NotificationScreenWebState extends State<NotificationScreenWeb> {
  // Sample notification data
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'New Session Created',
      message: 'A new gaming session "Summer Tournament" has been scheduled for tomorrow.',
      time: '2 minutes ago',
      type: NotificationType.session,
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Session Starting Soon',
      message: 'Your session "Team Challenge" starts in 30 minutes.',
      time: '30 minutes ago',
      type: NotificationType.reminder,
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Game Score Updated',
      message: 'Team Blue has taken the lead in the current match!',
      time: '1 hour ago',
      type: NotificationType.game,
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'New User Joined',
      message: 'John Doe has joined as a facilitator.',
      time: '2 hours ago',
      type: NotificationType.user,
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'Session Completed',
      message: 'The session "Morning Practice" has been completed successfully.',
      time: '5 hours ago',
      type: NotificationType.session,
      isRead: true,
    ),
  ];

  void _markAsRead(String id) {
    setState(() {
      final notification = _notifications.firstWhere((n) => n.id == id);
      notification.isRead = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
    Get.snackbar(
      'notifications_marked_read'.tr,
      'all_notifications_marked'.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.forwardColor,
      colorText: Colors.white,
    );
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });
    Get.snackbar(
      'notification_deleted'.tr,
      'notification_removed'.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.session:
        return Icons.event;
      case NotificationType.game:
        return Icons.sports_esports;
      case NotificationType.reminder:
        return Icons.notifications_active;
      case NotificationType.user:
        return Icons.person_add;
      case NotificationType.system:
        return Icons.info;
    }
  }

  Color _getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.session:
        return AppColors.forwardColor;
      case NotificationType.game:
        return Colors.green;
      case NotificationType.reminder:
        return Colors.orange;
      case NotificationType.user:
        return Colors.blue;
      case NotificationType.system:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              CustomAppbar(ishow: true),
              SizedBox(height: 56.h),
              Expanded(
                child: Center(
                  child: Container(
                    width: 794.w,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Column(
                      children: [
                        /// Top Section
                        SizedBox(
                          height: 235.h,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: 50.h,
                                left: -40.w,
                                child: ForwardButtonContainer(
                                  onTap: () => Get.back(),
                                  imageH: 20.h,
                                  imageW: 23.5.w,
                                  height1: 90.h,
                                  height2: 65.h,
                                  width1: 90.w,
                                  width2: 65.w,
                                  image: Appimages.arrowback,
                                ),
                              ),
                              Positioned(
                                top: -140,
                                right: 312.w,
                                left: 312.w,
                                child: Image.asset(
                                  Appimages.prince2,
                                  height: 225.h,
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        BoldText(
                                          text: 'notifications'.tr,
                                          fontSize: 48.sp,
                                          selectionColor: AppColors.blueColor,
                                        ),
                                        if (unreadCount > 0) ...[
                                          SizedBox(width: 16.w),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16.w,
                                              vertical: 8.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(20.r),
                                            ),
                                            child: Text(
                                              '$unreadCount',
                                              style: TextStyle(
                                                fontSize: 24.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'stay_updated_with_latest'.tr,
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        color: AppColors.teamColor,
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Notifications Content
                        Expanded(
                          child: Column(
                            children: [
                              /// Mark All as Read Button
                              if (unreadCount > 0)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 20.h),
                                  child: GestureDetector(
                                    onTap: _markAllAsRead,
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(vertical: 16.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.forwardColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(15.r),
                                        border: Border.all(
                                          color: AppColors.forwardColor,
                                          width: 1.5.w,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.done_all,
                                            color: AppColors.forwardColor,
                                            size: 24.sp,
                                          ),
                                          SizedBox(width: 12.w),
                                          Text(
                                            'mark_all_read'.tr,
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              color: AppColors.forwardColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              /// Notifications List
                              Expanded(
                                child: _notifications.isEmpty
                                    ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.notifications_off,
                                        size: 80.sp,
                                        color: AppColors.greyColor,
                                      ),
                                      SizedBox(height: 20.h),
                                      Text(
                                        'no_notifications'.tr,
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          color: AppColors.teamColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    : ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(context).copyWith(
                                    scrollbars: false,
                                  ),
                                  child: ListView.builder(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 80.w,
                                      vertical: 20.h,
                                    ),
                                    itemCount: _notifications.length,
                                    itemBuilder: (context, index) {
                                      final notification = _notifications[index];
                                      return Dismissible(
                                        key: Key(notification.id),
                                        direction: DismissDirection.endToStart,
                                        background: Container(
                                          margin: EdgeInsets.only(bottom: 16.h),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(20.r),
                                          ),
                                          alignment: Alignment.centerRight,
                                          padding: EdgeInsets.only(right: 30.w),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 36.sp,
                                          ),
                                        ),
                                        onDismissed: (direction) {
                                          _deleteNotification(notification.id);
                                        },
                                        child: GestureDetector(
                                          onTap: () {
                                            if (!notification.isRead) {
                                              _markAsRead(notification.id);
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 16.h),
                                            padding: EdgeInsets.all(24.w),
                                            decoration: BoxDecoration(
                                              color: notification.isRead
                                                  ? Colors.white
                                                  : AppColors.forwardColor.withOpacity(0.05),
                                              borderRadius: BorderRadius.circular(20.r),
                                              border: Border.all(
                                                color: notification.isRead
                                                    ? AppColors.greyColor
                                                    : AppColors.forwardColor.withOpacity(0.3),
                                                width: 1.5.w,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.05),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                /// Icon
                                                Container(
                                                  width: 60.w,
                                                  height: 60.h,
                                                  decoration: BoxDecoration(
                                                    color: _getColorForType(notification.type)
                                                        .withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(15.r),
                                                  ),
                                                  child: Icon(
                                                    _getIconForType(notification.type),
                                                    color: _getColorForType(notification.type),
                                                    size: 32.sp,
                                                  ),
                                                ),
                                                SizedBox(width: 20.w),

                                                /// Content
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              notification.title,
                                                              style: TextStyle(
                                                                fontSize: 22.sp,
                                                                fontWeight: notification.isRead
                                                                    ? FontWeight.w500
                                                                    : FontWeight.bold,
                                                                color: Colors.black87,
                                                              ),
                                                            ),
                                                          ),
                                                          if (!notification.isRead)
                                                            Container(
                                                              width: 12.w,
                                                              height: 12.h,
                                                              decoration: BoxDecoration(
                                                                color: Colors.red,
                                                                shape: BoxShape.circle,
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 8.h),
                                                      Text(
                                                        notification.message,
                                                        style: TextStyle(
                                                          fontSize: 18.sp,
                                                          color: AppColors.teamColor,
                                                          height: 1.4,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      SizedBox(height: 8.h),
                                                      Text(
                                                        notification.time,
                                                        style: TextStyle(
                                                          fontSize: 16.sp,
                                                          color: AppColors.greyColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Notification Item Model
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

enum NotificationType {
  session,
  game,
  reminder,
  user,
  system,
}