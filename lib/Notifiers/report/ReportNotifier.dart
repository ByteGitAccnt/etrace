import 'package:etrace/Api/FetchService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Services/pdf_service.dart';

class ReportNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> generateExpenseReport({
    required DateTime from,
    required DateTime to,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final bytes = await FetchService().downloadExpenseReport(from, to);
      final fileName =
          "expense-report-"
          "${from.year}-${from.month}-${from.day}"
          "_to_"
          "${to.year}-${to.month}-${to.day}-${DateTime.now().millisecondsSinceEpoch}.pdf";

      await PdfService.saveAndOpenReport(bytes, fileName);
    });
  }
}

final reportNotifierProvider = AsyncNotifierProvider<ReportNotifier, void>(
  ReportNotifier.new,
);
