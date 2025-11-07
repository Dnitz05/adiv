import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../../state/lunar_cycle_controller.dart';
import '../lunar_calendar_dialog.dart';

class CalendarTab extends StatelessWidget {
  const CalendarTab({
    super.key,
    required this.controller,
    required this.strings,
  });

  final LunarCycleController controller;
  final CommonStrings strings;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LunarCalendarContent(
            controller: controller,
            strings: strings,
          ),
        ],
      ),
    );
  }
}
