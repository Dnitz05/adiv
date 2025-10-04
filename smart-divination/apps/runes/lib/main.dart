import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:common/l10n/common_strings.dart';
import 'package:common/shared/infrastructure/localization/common_strings_extensions.dart';

import 'api/draw_runes_api.dart';

void main() {
  runApp(const SmartRunesApp());
}

class SmartRunesApp extends StatelessWidget {
  const SmartRunesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: CommonStrings.localizationsDelegates,
      supportedLocales: CommonStrings.supportedLocales,
      onGenerateTitle: (context) => CommonStrings.of(context).appTitle('runes'),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const _RunesHomeScreen(),
    );
  }
}

class _RunesHistoryRecord {
  const _RunesHistoryRecord({
    required this.moment,
    required this.response,
  });

  final DateTime moment;
  final RunesDrawResponse response;
}

class _RunesHomeScreen extends StatefulWidget {
  const _RunesHomeScreen();

  @override
  State<_RunesHomeScreen> createState() => _RunesHomeScreenState();
}

class _RunesHomeScreenState extends State<_RunesHomeScreen> {
  bool _loading = false;
  String? _error;
  RunesDrawResponse? _response;
  int _count = 3;
  bool _allowReversed = true;
  final List<_RunesHistoryRecord> _history = <_RunesHistoryRecord>[];

  Future<void> _drawRunes() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result =
          await drawRunes(count: _count, allowReversed: _allowReversed);
      final record =
          _RunesHistoryRecord(moment: DateTime.now(), response: result);
      setState(() {
        _response = result;
        _history.insert(0, record);
        if (_history.length > 10) {
          _history.removeRange(10, _history.length);
        }
      });
    } catch (error) {
      setState(() {
        if (error is TechniqueUnavailableException) {
          _response = null;
          _error = error.message;
        } else {
          _error = error.toString();
        }
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localisation = CommonStrings.of(context);
    final runes = _response?.result ?? const <RuneResult>[];

    return Scaffold(
      appBar: AppBar(title: Text(localisation.appTitle('runes'))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loading ? null : _drawRunes,
        icon: _loading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.auto_fix_high),
        label: Text(_loading ? 'Casting...' : 'Draw runes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              localisation.welcome,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _count.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: '$_count runes',
                    onChanged: _loading
                        ? null
                        : (value) {
                            setState(() {
                              _count = value.toInt();
                            });
                          },
                  ),
                ),
                Text('$_count'),
              ],
            ),
            SwitchListTile.adaptive(
              title: const Text('Allow reversed runes'),
              value: _allowReversed,
              onChanged: _loading
                  ? null
                  : (value) {
                      setState(() {
                        _allowReversed = value;
                      });
                    },
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Text(
                _error!,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  if (runes.isNotEmpty)
                    _buildCurrentRunesCard(context, runes)
                  else
                    _buildPlaceholder(context),
                  if (_history.length > 1) ...[
                    const SizedBox(height: 16),
                    Text('Previous casts',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    for (final record in _history.skip(1))
                      _buildHistoryTile(context, record),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentRunesCard(BuildContext context, List<RuneResult> runes) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current draw (${runes.length} runes)',
                style: theme.textTheme.titleMedium),
            if (_response?.spread.isNotEmpty ?? false)
              Text('Spread: ${_response?.spread}',
                  style: theme.textTheme.bodyMedium),
            Text('Seed: ${_response?.seed ?? ''}',
                style: theme.textTheme.bodySmall),
            Text('Method: ${_response?.method ?? ''}',
                style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            for (final rune in runes)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading:
                    Text(rune.symbol, style: const TextStyle(fontSize: 28)),
                title: Text(rune.name),
                subtitle: Text(
                  '${rune.isReversed ? 'Reversed' : 'Upright'} - ${rune.meaning}',
                ),
                trailing: Text('#${rune.position}'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTile(BuildContext context, _RunesHistoryRecord record) {
    final names = record.response.result.map((rune) => rune.name).join(', ');
    return ListTile(
      leading: const Icon(Icons.history),
      title: Text(names.isEmpty ? 'Runes draw' : names),
      subtitle: Text(_formatTimestamp(record.moment)),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Draw runes to receive guidance.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime time) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(time.toLocal());
  }
}
