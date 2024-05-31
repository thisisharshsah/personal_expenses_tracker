import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(
        width: double.infinity,
      ),
      child: MaterialButton(
        elevation: 0,
        color: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.sp),
        ),
        padding: EdgeInsets.all(15.sp),
        textColor: Theme.of(context).colorScheme.onSecondary,
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
