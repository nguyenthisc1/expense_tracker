import 'dart:io';

import 'package:expense_tracker/features/export/data/datasource/export_local_datasource.dart';
import 'package:expense_tracker/features/reports/domain/entity/detailed_report_entity.dart';
import 'package:expense_tracker/features/transactions/data/model/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ExportLocalDatasourceImpl implements ExportLocalDatasource {
  @override
  Future<String> exportReportPdf(DetailedReportEntity report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text(
            'MoneyFlow Report',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Period: ${_formatDate(report.startDate)} - ${_formatDate(report.endDate)}',
          ),
          pw.SizedBox(height: 20),

          pw.Text(
            'Summary',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: const ['Metric', 'Value'],
            data: [
              ['Total Income', report.totalIncome.toStringAsFixed(2)],
              ['Total Expense', report.totalExpense.toStringAsFixed(2)],
              ['Balance', report.balance.toStringAsFixed(2)],
            ],
          ),

          pw.SizedBox(height: 20),
          pw.Text(
            'Expense By Category',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: const ['Category', 'Amount'],
            data: report.expenseByCategory
                .map(
                  (item) => [
                    item.categoryName,
                    item.totalAmount.toStringAsFixed(2),
                  ],
                )
                .toList(),
          ),
        ],
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'report_${_timestamp()}.pdf';
    final file = File('${directory.path}/$fileName');

    await file.writeAsBytes(await pdf.save());

    return file.path;
  }

  @override
  Future<String> exportTransactionsCsv(
    List<TransactionModel> transactions,
  ) async {
    final buffer = StringBuffer();

    buffer.writeln('Date,Title,Type,CategoryId,Amount,Note');

    for (final transaction in transactions) {
      buffer.writeln(
        [
          _escapeCsv(_formatDate(transaction.date)),
          _escapeCsv(transaction.title),
          _escapeCsv(transaction.type),
          _escapeCsv(transaction.categoryId),
          transaction.amount.toString(),
          _escapeCsv(transaction.note ?? ''),
        ].join(','),
      );
    }

    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'transactions_${_timestamp()}.csv';
    final file = File('${directory.path}/$fileName');

    await file.writeAsString(buffer.toString());

    return file.path;
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  String _timestamp() {
    return DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  }

  String _escapeCsv(String value) {
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }
}
