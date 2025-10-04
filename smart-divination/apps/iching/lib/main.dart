import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:common/l10n/common_strings.dart';
import 'package:common/shared/infrastructure/localization/common_strings_extensions.dart';

import 'api/draw_coins_api.dart';

void main() {
  runApp(const SmartIChingApp());
}

class SmartIChingApp extends StatelessWidget {
  const SmartIChingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: CommonStrings.localizationsDelegates,
      supportedLocales: CommonStrings.supportedLocales,
      onGenerateTitle: (context) =>
          CommonStrings.of(context).appTitle('iching'),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const _IChingHomeScreen(),
    );
  }
}

class _IChingHistoryRecord {
  const _IChingHistoryRecord({
    required this.moment,
    required this.response,
  });

  final DateTime moment;
  final CoinsDrawResponse response;
}

class _IChingHomeScreen extends StatefulWidget {
  const _IChingHomeScreen();

  @override
  State<_IChingHomeScreen> createState() => _IChingHomeScreenState();
}

class _IChingHomeScreenState extends State<_IChingHomeScreen> {
  bool _loading = false;
  String? _error;
  CoinsDrawResponse? _response;
  final List<_IChingHistoryRecord> _history = <_IChingHistoryRecord>[];

  Future<void> _drawHexagram() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await drawCoins();
      final record =
          _IChingHistoryRecord(moment: DateTime.now(), response: result);
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
    final result = _response?.result;

    return Scaffold(
      appBar: AppBar(title: Text(localisation.appTitle('iching'))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loading ? null : _drawHexagram,
        icon: _loading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.change_circle_outlined),
        label: Text(_loading ? 'Consulting...' : 'Cast coins'),
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
                  if (result != null)
                    _buildCurrentHexagramCard(context, result)
                  else
                    _buildPlaceholder(context),
                  if (_history.length > 1) ...[
                    const SizedBox(height: 16),
                    Text('Previous consultations',
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

  Widget _buildCurrentHexagramCard(
      BuildContext context, CoinsDrawResult result) {
    final theme = Theme.of(context);
    final primary = result.primaryHexagram;
    final transformed = result.resultHexagram;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Primary hexagram', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('#${primary.number} - ${primary.name}',
                style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: result.lines
                  .map((value) => Chip(label: Text(value.toString())))
                  .toList(),
            ),
            const SizedBox(height: 12),
            Text(
              result.changingLines.isEmpty
                  ? 'Changing lines: none'
                  : 'Changing lines: ${result.changingLines.join(', ')}',
            ),
            const SizedBox(height: 12),
            if (transformed != null) ...[
              Text('Result hexagram', style: theme.textTheme.titleSmall),
              Text('#${transformed.number} - ${transformed.name}'),
              const SizedBox(height: 12),
            ],
            Text('Seed: ${_response?.seed ?? ''}',
                style: theme.textTheme.bodySmall),
            Text('Method: ${_response?.method ?? ''}',
                style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            ...primary.lines.map(
              (line) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Text('#${line.position}'),
                title: Text('Value ${line.value} (${line.type.toUpperCase()})'),
                subtitle:
                    Text(line.isChanging ? 'Changing line' : 'Stable line'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTile(BuildContext context, _IChingHistoryRecord record) {
    final primary = record.response.result.primaryHexagram;
    final subtitle =
        '${_formatTimestamp(record.moment)} - #${primary.number} ${primary.name}';
    return ListTile(
      leading: const Icon(Icons.history),
      title: Text('Primary hexagram #${primary.number}'),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Cast the coins to receive guidance.',
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
