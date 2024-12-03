import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';

Future<pw.Font> loadFont(String fontPath) async {
  final fontData = await rootBundle.load(fontPath);
  return pw.Font.ttf(fontData.buffer.asByteData());
}

Future<void> generatePdf(
  BuildContext context,
  List<List<String>> products,
  String transactionId,
  String paymentMethod,
  double total,
  String logoPath,
) async {
  final pdf = pw.Document();

  try {
    // Muat font Anton-Regular
    final antonFont = await loadFont('assets/images/fonts/Anton-Regular.ttf');

    // Muat logo
    final logoBytes = (await rootBundle.load(logoPath)).buffer.asUint8List();
    final imageLogo = pw.MemoryImage(logoBytes);

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: antonFont,
          bold: antonFont,
        ),
        build: (context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Image(imageLogo, height: 80),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                "Terima Kasih telah melakukan transaksi di EGO GYM.",
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                "Rincian Pembelian",
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "ITEM",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "QTY",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "MENIT",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          "HARGA",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  for (var item in products)
                    pw.TableRow(
                      children: item
                          .map(
                            (data) => pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(
                                data,
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                "TOTAL: Rp ${total.toStringAsFixed(2)}",
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.right,
              ),
              pw.Text(
                "Pembayaran: $paymentMethod",
                style: pw.TextStyle(fontSize: 16),
                textAlign: pw.TextAlign.right,
              ),
              pw.SizedBox(height: 32),
              pw.Text(
                "ID Transaksi:",
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
              pw.Center(
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: "Invoice #$transactionId",
                  width: 80,
                  height: 80,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final bytes = await pdf.save();

    // Logika penyimpanan
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/invoice_ego_gym.pdf');
    await file.writeAsBytes(bytes);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF berhasil disimpan: ${file.path}")),
    );
    OpenFile.open(file.path);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gagal membuat PDF: $e")),
    );
  }
}
