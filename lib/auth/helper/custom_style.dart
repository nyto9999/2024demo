import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Custom {
  static Widget gap = SizedBox(
    height: 12.r,
  );

  static TextStyle greyBold = TextStyle(
    color: Colors.grey[700],
    fontWeight: FontWeight.w500,
  );

  static Widget divider(String text) => Column(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(text, style: Custom.greyBold),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey,
          ),
          SizedBox(height: 5.h),
        ],
      );

  //sign_in_button package
  static double siginInLeftPadToCenter = 65.sp;

  static EdgeInsetsGeometry padding = EdgeInsets.all(12.r);
  static double paddingR = 12.r;

  static EdgeInsets pad = EdgeInsets.all(12.r);

  static Size minimumSizeR = const Size(80, 44);
  static Size maximumSizeR = const Size(120, 44);

  static Size minimumSizeM = const Size(120, 44);
  static Size maximumSizeM = const Size(150, 44);

  // 四個字以內
  static ElevatedButton defaultButton({
    required Widget child,
    required Function() onPressed,
  }) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          minimumSize: Custom.minimumSizeR,
          maximumSize: Custom.maximumSizeR,
        ),
        onPressed: onPressed,
        child: child,
      );

  // 六個字
  static ElevatedButton mediumButton({
    required Widget child,
    required Function() onPressed,
  }) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          minimumSize: Custom.minimumSizeM,
          maximumSize: Custom.maximumSizeM,
        ),
        onPressed: onPressed,
        child: child,
      );

  static Widget spinner(BuildContext context) => Center(
          child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).buttonTheme.colorScheme!.primary,
          ),
        ),
      ));
}
