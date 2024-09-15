import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as excel;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:flutteramndatabase/weapons/weapons.dart';

class EditWeaponPage extends StatefulWidget {
  final Weapons weapon;

  const EditWeaponPage({super.key, required this.weapon});

  @override
  _EditWeaponPageState createState() => _EditWeaponPageState();
}

class _EditWeaponPageState extends State<EditWeaponPage> {
  late TextEditingController weaponTypeController;
  late TextEditingController weaponNumberController;
  late TextEditingController weaponSignsController;
  late TextEditingController directoryController;
  late TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    weaponTypeController = TextEditingController(text: widget.weapon.weaponType);
    weaponNumberController = TextEditingController(text: widget.weapon.weaponNumber);
    weaponSignsController = TextEditingController(text: widget.weapon.weaponSigns);
    directoryController = TextEditingController(text: widget.weapon.directory);
    notesController = TextEditingController(text: widget.weapon.notes);
  }

  @override
  void dispose() {
    weaponTypeController.dispose();
    weaponNumberController.dispose();
    weaponSignsController.dispose();
    directoryController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      widget.weapon.weaponType = weaponTypeController.text;
      widget.weapon.weaponNumber = weaponNumberController.text;
      widget.weapon.weaponSigns = weaponSignsController.text;
      widget.weapon.directory = directoryController.text;
      widget.weapon.notes = notesController.text;

      print("Saving weapon data...");
      await updateWeaponInExcel(widget.weapon);

      print("Data saved successfully, navigating back...");
      Navigator.pop(context, widget.weapon); 
    } catch (e) {
      print('Error saving weapon details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تعديل البيانات'),
          backgroundColor: Colors.teal[700],
        ),
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: 0.3,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(
                      'assets/images/amn.png',
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildEditableCard('نوع السلاح:', weaponTypeController),
                    _buildEditableCard('رقم السلاح:', weaponNumberController),
                    _buildEditableCard('علامات السلاح:', weaponSignsController),
                    _buildEditableCard('الإدارة:', directoryController),
                    _buildEditableCard('ملاحظات:', notesController),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveChanges,
                      child: const Text('حفظ التعديلات'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableCard(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal.shade200),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.teal.shade50,
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.teal.shade900,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> updateWeaponInExcel(Weapons weapon) async {
  try {
    // احصل على مسار التخزين المحلي
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/weapons.xlsx';

    // تحميل الملف من الأصول إلى التخزين المحلي إذا لم يكن موجودًا
    final file = File(filePath);
    if (!await file.exists()) {
      final data = await rootBundle.load('assets/weapons.xlsx');
      await file.writeAsBytes(data.buffer.asUint8List());
    }

    // قراءة الملف من التخزين المحلي
    var bytes = await file.readAsBytes();
    var excelFile = excel.Excel.decodeBytes(bytes);

    var sheet = excelFile.tables['Sheet1'];

    if (sheet == null) {
      print('Sheet1 not found');
      return;
    }

    bool found = false;
    for (var row in sheet.rows) {
      if (row[0] != null && row[0] == weapon.weaponNumber) {
        print("Row found, updating...");

        // تحديث القيم باستخدام indexByString وتحديث الخلية
        var rowIndex = sheet.rows.indexOf(row) + 1; // الحصول على رقم الصف

        //sheet.updateCell(excel.CellIndex.indexByString("B$rowIndex"), (weapon.weaponType ?? '') as excel.CellValue);
        sheet.updateCell(excel.CellIndex.indexByString("C$rowIndex"), (weapon.weaponSigns ?? '') as excel.CellValue?);
        sheet.updateCell(excel.CellIndex.indexByString("D$rowIndex"), (weapon.directory ?? '') as excel.CellValue?);
        sheet.updateCell(excel.CellIndex.indexByString("E$rowIndex"), (weapon.notes ?? '') as excel.CellValue?);

        found = true;
        break;
      }
    }

    if (!found) {
      print("Weapon with number ${weapon.weaponNumber} not found in Excel.");
      return;
    }

    var fileBytes = excelFile.encode();
    if (fileBytes != null) {
      await file.writeAsBytes(fileBytes, flush: true);
      print("Data saved to Excel file.");
    }
  } catch (e) {
    print('Error updating Excel file: $e');
  }
}
