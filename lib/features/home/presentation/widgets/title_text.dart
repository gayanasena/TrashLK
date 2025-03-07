import 'package:flutter/material.dart';
import 'package:wasteapp/core/resources/text_styles.dart';

class TitleText extends StatelessWidget {
  final String titleText;
  const TitleText({super.key, required this.titleText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 0, 0.0),
      child: Text(titleText, style: TextStyles(context).homeCarouselHeaderText),
    );
  }
}
