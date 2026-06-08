import 'package:flutter/material.dart';

class OptionsSection extends StatelessWidget {
  const OptionsSection({
    super.key,
    required this.onSave,
  });

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF0e1411),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1)))
      ),
      padding: EdgeInsets.only(left: 18, right: 18, top: 12),
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    "CANCEL",
                    style: TextStyle(color: Color(0xFF9aa59e)),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: GestureDetector(
              onTap: onSave,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Color(0xFF16201b),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    "SAVE CHANGES",
                    style: TextStyle(
                      color: Color(0xFF5c6b62),
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
