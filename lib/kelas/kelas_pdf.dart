import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

Future<void> generatePdf(
  BuildContext context,
  List<List<String>> products, 
  String transactionId,       
  String paymentMethod,      
  int total,                  
  String logoPath,            
) async {
  final pdf = pw.Document();
  final now = DateTime.now();
  final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

  try {
    final logoBytes = (await rootBundle.load(logoPath)).buffer.asUint8List();
    final imageLogo = pw.MemoryImage(logoBytes);

    final pdfTheme = pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pdfTheme,
        header: (context) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Image(imageLogo, height: 80),
            pw.Text(
              "EGO GYM",
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
        footer: (context) => pw.Text(
          "Created At $formattedDate",
          style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
        ),
        build: (context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Terima Kasih telah melakukan transaksi di EGO GYM.",
                style: pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                "Rincian Pembelian",
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
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
                        child: pw.Text("ITEM", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text("QTY", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text("MENIT", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text("HARGA", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  for (var item in products)
                    pw.TableRow(
                      children: item
                          .map(
                            (data) => pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(data),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                "TOTAL: Rp ${NumberFormat("#,##0", "id_ID").format(total)}",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
              ),
              pw.Text(
                "Pembayaran: $paymentMethod",
                style: pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 32),
              pw.Text(
                "ID Transaksi:",
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
              pw.Center(
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: "Invoice #$transactionId",
                  width: 80,
                  height: 80,
                ),
              ),
              pw.SizedBox(height: 32),
              pw.Text(
                "Alamat: Jl. Contoh No.123, Bandung, Jawa Barat, Indonesia",
                style: pw.TextStyle(fontSize: 14, color: PdfColors.black),
              ),
            ],
          ),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/invoice_ego_gym.pdf");
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("PDF berhasil dibuat di ${file.path}"),
        action: SnackBarAction(
          label: "Buka",
          onPressed: () {
            OpenFile.open(file.path);
          },
        ),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gagal membuat PDF: $e")),
    );
  }
}
