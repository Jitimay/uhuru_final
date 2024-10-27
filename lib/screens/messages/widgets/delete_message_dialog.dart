import 'package:flutter/material.dart';
import 'package:uhuru/common/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteMessageDialog extends StatelessWidget {
  final VoidCallback onDelete;
  const DeleteMessageDialog({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Message'),
      content: Text(AppLocalizations.of(context)?.areyousurewanttodelete ?? "Are you sure you want to delete this message"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            AppLocalizations.of(context)?.cancel ?? "Cancel",
            style: TextStyle(color: messageColor),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: messageColor),
          onPressed: onDelete,
          child: Text(
            AppLocalizations.of(context)?.delete ?? "Delete",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
