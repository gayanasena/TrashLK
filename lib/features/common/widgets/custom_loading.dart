import 'package:flutter/material.dart';
import 'package:wasteapp/core/resources/colors.dart';
import 'package:wasteapp/core/resources/dimens.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key, required this.isLoading, this.progress});

  final bool isLoading;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isLoading,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            height: context.mQHeight,
            width: context.mQWidth,
            color: ApplicationColors(context).white.withValues(alpha: 0.2),
            transformAlignment: AlignmentDirectional.center,
          ),
          if (progress != null)
            CircularProgressIndicator(value: progress)
          else
            const Align(
              alignment: Alignment.bottomCenter,
              child: LinearProgressIndicator(minHeight: 5.0),
            ),
        ],
      ),
    );
  }
}
