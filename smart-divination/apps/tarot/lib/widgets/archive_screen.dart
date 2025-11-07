import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../state/journal_controller.dart';
import 'journal/journal_calendar_view.dart';
import 'journal/journal_filter_panel.dart';
import 'journal/journal_stats_card.dart';
import 'journal/journal_timeline_view.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({
    super.key,
    required this.userId,
    required this.locale,
  });

  final String userId;
  final String locale;

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late JournalController _journalController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _journalController = JournalController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
  }

  Future<void> _loadInitialData() async {
    await _journalController.loadInitial(
      userId: widget.userId,
      locale: widget.locale,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userModel = UserModel(id: widget.userId, locale: widget.locale);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _journalController),
        Provider.value(value: userModel),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Archive'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.timeline), text: 'Timeline'),
              Tab(icon: Icon(Icons.calendar_month), text: 'Calendar'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterPanel(context),
            ),
          ],
        ),
        body: Column(
          children: [
            const JournalStatsCard(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  JournalTimelineView(),
                  JournalCalendarView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterPanel(BuildContext context) {
    final userModel = UserModel(id: widget.userId, locale: widget.locale);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (modalContext) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: _journalController),
          Provider.value(value: userModel),
        ],
        child: const JournalFilterPanel(),
      ),
    );
  }
}
