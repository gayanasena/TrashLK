import 'package:flutter/material.dart';
import 'package:wasteapp/utils/enums.dart';

extension BuildContextDimention on BuildContext {
  double get mQHeight => MediaQuery.of(this).size.height;
  double get mQWidth => MediaQuery.of(this).size.width;

  double get appBarHeight => AppBar().preferredSize.height;
  double get mQPaddingTopHeight => MediaQuery.of(this).padding.top;
  double get mQPaddingBottomHeight => MediaQuery.of(this).padding.bottom;
  double get mQPaddingBottomInsets => MediaQuery.of(this).viewInsets.bottom;
  double get mQTopSafeArea => MediaQuery.of(this).viewPadding.top;
  double get mQBottomSafeArea => MediaQuery.of(this).viewPadding.bottom;

  DeviceType getDeviceType() {
    final data = MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.single);
    return data.size.shortestSide < 600 ? DeviceType.Mobile : DeviceType.Tablet;
  }
}

class UI {
  static const padding = 8.0;
  static const padding2x = 16.0;
  static const padding3x = 24.0;
  static const padding4x = 32.0;
  static const padding8x = 64.0;
}

class Dimens {
  // Default
  static const defaultButtonBorderRadius = 25.0;
  static const defaultCheckBoxBorderRadius = 3.0;
  static const defaultContainerMaxWidthForTablet = 600.0;
  static const defaultPadding = 8.0;
  static const defaultBorderRadius = 8.0;
  static const defaultCardPadding = 8.0;
  static const defaultControlBottom = 6.0;
  static const defaultBottomSheetRadius = 24.0;
  static const circularProgressIndicatorSize = 15.0;
}
