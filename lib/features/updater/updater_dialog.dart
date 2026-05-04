import 'package:flutter/material.dart';

class UpdaterDialog extends StatelessWidget {
  const UpdaterDialog({
    required this.version,
    required this.onUpdateSelected,
    super.key,
  });

  /// The new version available
  final String version;

  /// The function called when the 'Update now' button its pressed
  final Function onUpdateSelected;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Actualizacion Disponible - $version"),
      content: Text(
        "La version $version esta disponible. Deseas actualizar ahora?",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Más tarde"),
        ),
        FilledButton(
          onPressed: () {
            onUpdateSelected();
          },
          child: const Text("Actualizar ahora"),
        ),
      ],
    );
  }
}
