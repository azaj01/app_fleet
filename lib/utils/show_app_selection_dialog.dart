import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/assets/generators/linux_app_finder.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/utils/app_tooltip_builder.dart';
import 'package:app_fleet/utils/app_window_buttons.dart';
import 'package:app_fleet/utils/utils.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void showAppSelectionDialog({
  required BuildContext context,
  required void Function(App? app) onClose,
}) {
  String searchText = "";
  FocusNode focusNode = FocusNode();
  Future.delayed(const Duration(milliseconds: 250), () {
    focusNode.requestFocus();
  });
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: MoveWindow(
          onDoubleTap: () {
            // this will prevent maximize operation
          },
          child: Align(
            child: FittedBox(
              child: Container(
                width: 500,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      blurRadius: 16,
                    )
                  ],
                ),
                child: StatefulBuilder(builder: (context, setState) {
                  return Stack(
                    children: [
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Pick an App (${LinuxAppFinder.apps.length} Detected)",
                                    style: AppTheme.fontSize(18).makeBold(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 300,
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    children: [
                                      ...LinuxAppFinder.apps
                                          .where((e) => containsIgnoreCase(
                                              e.name, searchText))
                                          .map((e) {
                                        bool hover = false;
                                        return GestureDetector(
                                          onTap: () {
                                            onClose(e);
                                            Navigator.pop(context);
                                          },
                                          child: StatefulBuilder(
                                            builder: (context, setIconState) {
                                              return MouseRegion(
                                                onEnter: (e) => setIconState(
                                                    () => hover = true),
                                                onExit: (e) => setIconState(
                                                    () => hover = false),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: SizedBox(
                                                    width: 48,
                                                    height: 48,
                                                    child: AnimatedScale(
                                                      duration: const Duration(
                                                          milliseconds: 250),
                                                      scale: hover ? 0.8 : 1.0,
                                                      child: AppTooltipBuilder
                                                          .wrap(
                                                        text: e.name,
                                                        child: e.iconPath
                                                                .endsWith(
                                                                    ".svg")
                                                            ? SvgPicture.asset(
                                                                e.iconPath,
                                                                width: 48,
                                                                placeholderBuilder:
                                                                    (context) =>
                                                                        Image
                                                                            .asset(
                                                                  AppIcons
                                                                      .unknown,
                                                                  width: 48,
                                                                ),
                                                              )
                                                            : Image.asset(
                                                                e.iconPath,
                                                                width: 48,
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 120,
                          child: TextField(
                            focusNode: focusNode,
                            textAlign: TextAlign.center,
                            style: AppTheme.fontSize(14).makeBold(),
                            decoration: const InputDecoration(
                              hintText: "Search by Name",
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchText = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: appWindowButton(
                            color: Colors.red,
                            onPressed: () {
                              onClose(null);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      );
    },
  );
}