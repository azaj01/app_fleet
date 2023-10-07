import 'package:app_fleet/app/launcher/data/launcher_repository.dart';
import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:app_fleet/utils/app_tooltip_builder.dart';
import 'package:app_fleet/utils/app_window_buttons.dart';
import 'package:app_fleet/utils/show_app_info_dialog.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

Widget appBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 9.0),
    child: SizedBox(
      height: 60,
      child: Row(
        children: [
          AppTooltipBuilder.wrap(
            text: "Open Workspace Launcher",
            child: IconButton(
              onPressed: () {
                DependencyInjection.find<LauncherRepository>()
                    .launchWorkspaceLauncher();
              },
              icon: Image.asset(
                AppIcons.appFleet,
                width: 32,
              ),
              iconSize: 32,
            ),
          ),
          const SizedBox(width: 17),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "App Fleet",
                    style: AppTheme.fontSize(20).makeBold(),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      showAppInfo(context);
                    },
                    child: const Icon(
                      Icons.info_outlined,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
              Text(
                "Manage workspace profiles, with a startup workspace launcher.",
                style: AppTheme.fontSize(14),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    appWindowButton(
                      color: Colors.red,
                      onPressed: () {
                        appWindow.close();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}