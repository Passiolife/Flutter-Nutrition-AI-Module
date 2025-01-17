part of '../permission_manager.dart';

class SettingDialogWidget extends StatelessWidget {
  const SettingDialogWidget({
    this.title,
    this.description,
    this.onTapNegative,
    super.key,
  });

  final String? title;
  final String? description;
  final VoidCallback? onTapNegative;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(title ?? 'Permission'),
      content: Text(description ?? 'Please allow permission access.'),
      actions: <Widget>[
        adaptiveAction(
          context: context,
          onPressed: () {
            Navigator.pop(context);
            onTapNegative?.call();
          },
          child: const Text('Cancel'),
        ),
        adaptiveAction(
          context: context,
          onPressed: () async {
            await openAppSettings();
          },
          child: const Text('Open Settings'),
        ),
      ],
    );
  }
}
