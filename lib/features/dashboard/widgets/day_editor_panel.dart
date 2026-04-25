import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/worklog/worklog_model.dart';
import '../../../core/worklog/worklog_providers.dart';
import '../state/dashboard_providers.dart';

class DayEditorPanel extends ConsumerStatefulWidget {
  const DayEditorPanel({super.key});

  @override
  ConsumerState<DayEditorPanel> createState() => _DayEditorPanelState();
}

class _DayEditorPanelState extends ConsumerState<DayEditorPanel> {
  final _formKey = GlobalKey<FormState>();
  final _hoursController = TextEditingController();
  final _notesController = TextEditingController();
  final _hoursFocusNode = FocusNode();
  bool _isExtraDay = false;
  DateTime? _loadedFor;

  @override
  void dispose() {
    _hoursController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _loadLog(DateTime day, WorkLog? log) {
    _loadedFor = day;
    _hoursController.text = log != null ? log.hoursWorked.toString() : '';
    _notesController.text = log?.notes ?? '';
    _isExtraDay = log?.isExtraDay ?? false;
    _hoursFocusNode.requestFocus();
  }

  Future<void> _save(DateTime day) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final hours = double.tryParse(_hoursController.text) ?? 0;
    final log = WorkLog(
      date: day,
      hoursWorked: hours,
      isExtraDay: _isExtraDay,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );
    await ref.read(worklogRepositoryProvider).put(log);
  }

  Future<void> _clear(DateTime day) async {
    await ref.read(worklogRepositoryProvider).delete(day);
    _hoursController.clear();
    _notesController.clear();
    setState(() => _isExtraDay = false);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = ref.watch(selectedDayProvider);

    if (selectedDay == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Select a day to log hours', textAlign: TextAlign.center),
        ),
      );
    }

    final month = DateTime(selectedDay.year, selectedDay.month);
    final logsAsync = ref.watch(worklogsForMonthProvider(month));
    final logs = logsAsync.valueOrNull ?? [];
    final log = logs.cast<WorkLog?>().firstWhere(
      (l) => l?.key == WorkLog.keyFor(selectedDay),
      orElse: () => null,
    );

    // Seed form when selected day or log changes
    if (_loadedFor != selectedDay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _loadLog(selectedDay, log));
      });
    }

    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat.yMMMMEEEEd().format(selectedDay),
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: TextFormField(
                  controller: _hoursController,
                  focusNode: _hoursFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'Hours Worked',
                    suffixText: 'h',
                    hintText: '0 = missed / holiday',
                    border: InputBorder.none,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  validator: (v) {
                    if (v == null || v.isEmpty) return null; // empty = clear
                    final n = double.tryParse(v);
                    if (n == null || n < 0 || n > 24) {
                      return 'Enter 0–24';
                    }
                    return null;
                  },
                  onChanged: (v) {
                    if (v.isNotEmpty) {
                      setState(() {});
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Extra Day'),
                subtitle: const Text('Weekend or overtime'),
                value: _isExtraDay,
                onChanged: (v) => setState(() => _isExtraDay = v),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    border: InputBorder.none,
                  ),
                  maxLines: 3,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  if (log != null)
                    OutlinedButton(
                      onPressed: () => _clear(selectedDay),
                      child: const Text('Clear'),
                    ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _hoursController.text.isEmpty && log == null
                        ? null
                        : () => _save(selectedDay),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
