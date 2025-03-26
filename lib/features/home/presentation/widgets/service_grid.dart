import 'package:flutter/material.dart';
import 'package:wasteapp/core/resources/colors.dart';
import 'package:wasteapp/core/resources/dimens.dart';
import 'package:wasteapp/features/home/presentation/pages/activity_view.dart';
import 'package:wasteapp/features/home/presentation/pages/schadule_view.dart';

class ServiceGrid extends StatelessWidget {
  const ServiceGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ServiceButton(
            title: " Schedules",
            icon: Icons.schedule,
            onClick: () {
              showShadulesModal(context);
            },
          ),
          ServiceButton(
            title: "Recent Activities",
            icon: Icons.history,
            onClick: () {
              showActivitiesModal(context);
            },
          ),
        ],
      ),
    );
  }
}

void showShadulesModal(BuildContext context) {
  showModalBottomSheet(
    clipBehavior: Clip.antiAlias,
    context: context,
    isDismissible: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimens.defaultBottomSheetRadius),
        topRight: Radius.circular(Dimens.defaultBottomSheetRadius),
      ),
    ),
    builder: (context) {
      return Container(
        constraints: BoxConstraints(maxHeight: context.mQHeight * 0.8),
        child: const Scaffold(body: SchedulesView()),
      );
    },
  );
}

void showActivitiesModal(BuildContext context) {
  showModalBottomSheet(
    clipBehavior: Clip.antiAlias,
    context: context,
    isDismissible: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimens.defaultBottomSheetRadius),
        topRight: Radius.circular(Dimens.defaultBottomSheetRadius),
      ),
    ),
    builder: (context) {
      return Container(
        constraints: BoxConstraints(maxHeight: context.mQHeight * 0.8),
        child: ActivityView(),
      );
    },
  );
}

class ServiceButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onClick;

  const ServiceButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: 60,
          width: 180,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [primaryColor, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 24.0),
                const SizedBox(width: 2.0),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
