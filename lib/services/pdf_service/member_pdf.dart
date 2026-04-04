import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_app/screens/members/model/member_model.dart';

class PdfHelper {
  static Future<void> downloadFullMemberList(List<Member> members) async {
    try {
      final pdf = pw.Document();

      // Chunk the members list into pairs for a 2-column table
      List<List<Member>> pairs = [];
      for (var i = 0; i < members.length; i += 2) {
        pairs.add(members.sublist(i, i + 2 > members.length ? members.length : i + 2));
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              pw.Table(
                children: pairs.map((pair) {
                  return pw.TableRow(
                    children: [
                      _buildMemberCell(pair[0]),
                      // If there is a second member in the pair, add their cell; otherwise add empty space
                      pair.length > 1 ? _buildMemberCell(pair[1]) : pw.SizedBox(),
                    ],
                  );
                }).toList(),
              ),
            ];
          },
        ),
      );

      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = "${directory.path}/Full_Member_Directory.pdf";
      final File file = File(filePath);

      await file.writeAsBytes(await pdf.save());
      await OpenFilex.open(filePath);
    } catch (e) {
      // This approach prevents 'TooManyPagesException'
      debugPrint("PDF Generation Error: $e");
    }
  }

  static pw.Widget _buildMemberCell(Member member) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 20, right: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            member.name.toUpperCase(),
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
          ),
          pw.Text("Firm: ${member.msFirmName ?? '-'}", style: const pw.TextStyle(fontSize: 8)),
          // Address line as shown in image
          pw.Text("${member.area ?? ''} ${member.pincode ?? ''}", style: const pw.TextStyle(fontSize: 8)),
          pw.SizedBox(height: 4),
          pw.Text("PH: ${member.mobile}", style: const pw.TextStyle(fontSize: 8)),
          pw.Text(
            "Edu: ${member.education ?? 'N/A'} | Occ: ${member.occupation ?? 'N/A'} | BG: ${member.bloodGroup ?? 'N/A'}",
            style: const pw.TextStyle(fontSize: 8),
          ),
          pw.Text("Hobbies: ${member.hobbies ?? 'N/A'}", style: const pw.TextStyle(fontSize: 8)),
        ],
      ),
    );
  }
}