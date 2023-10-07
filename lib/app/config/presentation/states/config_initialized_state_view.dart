import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/app/config/presentation/config_controller.dart';
import 'package:app_fleet/app/config/presentation/widgets/workspace_app_box.dart';
import 'package:app_fleet/app/config/presentation/widgets/workspace_icon_box.dart';
import 'package:app_fleet/app/config/presentation/widgets/workspace_map_box.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/utils/bottom_bar.dart';
import 'package:app_fleet/utils/show_app_selection_dialog.dart';
import 'package:app_fleet/utils/show_confirm_delete_dialog.dart';
import 'package:app_fleet/utils/show_discard_edits_dialog.dart';
import 'package:flutter/material.dart';

enum ConfigUIMode { edit, create }

class ConfigInitializedStateView extends StatefulWidget {
  const ConfigInitializedStateView({
    super.key,
    required this.controller,
    required this.workspaceEntity,
    required this.configUIMode,
  });

  final WorkspaceEntity workspaceEntity;
  final ConfigController controller;
  final ConfigUIMode configUIMode;

  @override
  State<ConfigInitializedStateView> createState() =>
      _ConfigInitializedStateViewState();
}

class _ConfigInitializedStateViewState
    extends State<ConfigInitializedStateView> {
  late WorkspaceEntity workspaceEntity;

  final formKey = GlobalKey<FormState>();

  final FocusNode focusNode = FocusNode();

  late TextEditingController workspaceNameController;

  @override
  void initState() {
    super.initState();
    workspaceEntity = WorkspaceEntity.clone(widget.workspaceEntity);
    workspaceNameController = TextEditingController(text: workspaceEntity.name);
    Future.delayed(const Duration(milliseconds: 1), () {
      focusNode.requestFocus();
    });
  }

  void saveConfig() {
    widget.controller.removeConfiguration(widget.workspaceEntity);
    widget.controller.saveConfiguration(workspaceEntity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CallbackShortcuts(
        bindings: {
          const CharacterActivator('f', control: true): () {
            showAppSelectionDialog(
              context: context,
              onClose: (app) {
                setState(
                  () {
                    if (app != null) {
                      workspaceEntity.apps.remove(app);
                      workspaceEntity.apps.add(app);
                    }
                  },
                );
              },
            );
          },
        },
        child: Focus(
          focusNode: focusNode,
          child: GestureDetector(
            onTap: () {
              focusNode.requestFocus();
            },
            child: Form(
              key: formKey,
              child: Stack(
                children: [
                  Align(
                    child: Container(
                      width: 700,
                      height: 500,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.withOpacity(0.4),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.keyboard_arrow_left,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    if (widget.workspaceEntity ==
                                        workspaceEntity) {
                                      widget.controller.gotoHomeRoute();
                                    } else {
                                      showDiscardEditsDialog(
                                        context: context,
                                        onSelection: (mode) {
                                          switch (mode) {
                                            case DiscardMode.save:
                                              saveConfig();
                                              break;
                                            case DiscardMode.discard:
                                              widget.controller.gotoHomeRoute();
                                              break;
                                            case DiscardMode.continueEditing:
                                              break;
                                          }
                                        },
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.configUIMode == ConfigUIMode.create
                                          ? "Create"
                                          : "Edit",
                                      style: AppTheme.fontSize(20).makeBold(),
                                    ),
                                    Text(
                                      widget.configUIMode == ConfigUIMode.create
                                          ? "A New Workspace Configuration"
                                          : "Make changes to your workspace",
                                      style: AppTheme.fontSize(14),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (widget.configUIMode ==
                                          ConfigUIMode.edit)
                                        IconButton(
                                          onPressed: () {
                                            showConfirmDeleteDialog(
                                              context: context,
                                              onSelection: (delete) {
                                                if (delete) {
                                                  widget.controller
                                                      .removeConfiguration(
                                                          widget
                                                              .workspaceEntity);
                                                }
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                            size: 32,
                                          ),
                                        ),
                                      IconButton(
                                        onPressed: () {
                                          saveConfig();
                                        },
                                        icon: const Icon(
                                          Icons.save,
                                          size: 32,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 10.0),
                              child: Row(
                                children: [
                                  WorkspaceIconBox(
                                    workspaceEntity: workspaceEntity,
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Workspace Name",
                                        style: AppTheme.fontSize(14).makeBold(),
                                      ),
                                      SizedBox(
                                        width: 220,
                                        height: 45,
                                        child: TextFormField(
                                          controller: workspaceNameController,
                                          style: AppTheme.fontSize(15),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "**Required";
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            workspaceEntity.name = value;
                                          },
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.grey, width: 2),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.green,
                                                  width: 4),
                                            ),
                                            disabledBorder:
                                                UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                            border: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.blue, width: 2),
                                            ),
                                            hintText: "e.g: 'Its Hero Time'",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            WorkspaceAppBox(
                              workspaceEntity: workspaceEntity,
                              onRebuildRequested: () {
                                setState(() {});
                              },
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              child: (workspaceEntity.apps.length > 1)
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        left: 30.0,
                                        top: 20.0,
                                      ),
                                      child: WorkspaceMapBox(
                                        workspaceEntity: workspaceEntity,
                                        onRebuildRequested: () {
                                          setState(() {});
                                        },
                                      ),
                                    )
                                  : const SizedBox(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  bottomBar(
                    text: "Config Creator",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
