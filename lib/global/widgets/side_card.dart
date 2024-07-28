import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SideCard extends StatelessWidget {
  const SideCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.sideBool,
    this.selected = false,
    this.onPressed,
  });

  final String title;
  final String subtitle;
  final String icon;
  final bool sideBool;
  final bool selected;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Align(
        alignment: sideBool ? Alignment.centerLeft : Alignment.centerRight,
        child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: sideBool ? Radius.circular(50.sp) : Radius.zero,
              bottomRight: sideBool ? Radius.circular(50.sp) : Radius.zero,
              topLeft: sideBool ? Radius.zero : Radius.circular(50.sp),
              bottomLeft: sideBool ? Radius.zero : Radius.circular(50.sp),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.sp),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 20.sp,
                  backgroundColor: sideBool
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  child: Icon(
                    // icon='0xe88a'
                    selected
                        ? Icons.check
                        : IconData(
                      int.parse(icon),
                      fontFamily: 'MaterialIcons',
                    ),
                    color: sideBool
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSecondary,
                    size: 20.sp,
                  ),
                ),
                10.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                10.horizontalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}