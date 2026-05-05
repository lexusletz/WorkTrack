import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sync_orchestrator.dart';

/// Overridden in main.dart after the orchestrator is initialized.
final syncOrchestratorProvider = Provider<SyncOrchestrator>(
  (_) => throw UnimplementedError('syncOrchestratorProvider not overridden'),
);
