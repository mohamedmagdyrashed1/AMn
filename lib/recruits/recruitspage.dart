import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:flutteramndatabase/recruits/recruits.dart';
import 'package:flutteramndatabase/recruits/recruitsdetails.dart';

class RecruitsPage extends StatefulWidget {
  const RecruitsPage({super.key});

  @override
  _RecruitsPageState createState() => _RecruitsPageState();
}

class _RecruitsPageState extends State<RecruitsPage> {
  List<Recruits> recruits = [];
  List<Recruits> filteredRecruits = [];
  String searchType = 'الاسم'; // افتراضي هو البحث بالاسم
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExcelData();
  }

  Future<void> _loadExcelData() async {
    try {
      final data = await rootBundle.load('assets/recruits.xlsx');
      final bytes = data.buffer.asUint8List();
      final decoder = SpreadsheetDecoder.decodeBytes(bytes);

      final sheet = decoder.tables.keys.first;
      final table = decoder.tables[sheet];

      if (table != null) {
        setState(() {
          recruits.clear();
          for (var row in table.rows.skip(2)) { // تخطي رأس الجدول
            if (row.isNotEmpty) { // التأكد من وجود بيانات في الصف
              final recruit = Recruits(
                name: row.length > 1 ? row[1]?.toString() ?? 'لا يوجد بيانات' : 'لا يوجد بيانات',
                policeNumber: row.length > 2 ? row[2]?.toString() ?? 'لا يوجد بيانات' : 'لا يوجد بيانات',
                recruitmentDate: row.length > 3 ? row[3]?.toString() ?? 'لا يوجد بيانات' : 'لا يوجد بيانات',
                address: row.length > 4 ? row[4]?.toString() ?? 'لا يوجد بيانات' : 'لا يوجد بيانات',
                degree: row.length > 5 ? row[5]?.toString() ?? 'لا يوجد بيانات' : 'لا يوجد بيانات',
                nationalId: row.length > 6 ? row[6]?.toString() ?? 'لا يوجد بيانات' : 'لا يوجد بيانات',
                birthDate: row.length > 7 ? row[7]?.toString() ?? 'لا يوجد بيانات' : 'لا يوجد بيانات',
                penalities: row.length > 8 ? row[8]?.toString() ?? 'لا يوجد بيانات' : 'لا يوجد بيانات',
                employer: row.length > 9 ? row[9]?.toString() ?? 'لا يوجد بيانات' : 'لا يوجد بيانات',
                politicalInvestigationsNumber: row.length > 10 && row[10] != null ? (row[10].toString().split('/').isNotEmpty ? row[10].toString().split('/')[0] : 'لا يوجد بيانات') : 'لا يوجد بيانات',
                politicalInvestigationsDate: row.length > 10 && row[10] != null ? (row[10].toString().split('/').length > 1 ? row[10].toString().split('/')[1] : 'لا يوجد بيانات') : 'لا يوجد بيانات',
                politicalInvestigationsResult: row.length > 11 ? row[11]?.toString() ?? 'لا يوجد بيانات' : 'لا يوجد بيانات',
                criminalInvestigationsNumber: row.length > 12 && row[12] != null ? (row[12].toString().split('/').isNotEmpty ? row[12].toString().split('/')[0] : 'لا يوجد بيانات') : 'لا يوجد بيانات',
                criminalInvestigationsDate: row.length > 12 && row[12] != null ? (row[12].toString().split('/').length > 1 ? row[12].toString().split('/')[1] : 'لا يوجد بيانات') : 'لا يوجد بيانات',
                criminalInvestigationsResult: row.length > 13 ? row[13]?.toString() ?? 'لا يوجد بيانات' : 'لا يوجد بيانات',
                facts: row.length > 14 ? row[14]?.toString() ?? 'لا يوجد بيانات' : 'لا يوجد بيانات',
                behaviour: row.length > 15 ? row[15]?.toString() ?? 'لا يوجد بيانات' : 'لا يوجد بيانات',
              );
              recruits.add(recruit);
            }
          }
          // قم بتعيين القائمة المفلترة لتكون نفس قائمة المجندين عند فتح الصفحة
          filteredRecruits = recruits;
        });
      }
        } catch (e) {
      print("Error loading Excel file: $e");
    }
  }

  void _searchRecruit(String query) {
    setState(() {
      if (searchType == 'الاسم') {
        filteredRecruits = recruits
            .where((recruit) => recruit.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else if (searchType == 'العنوان') {
        filteredRecruits = recruits
            .where((recruit) => recruit.address.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _selectRecruit(Recruits recruit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecruitDetailsPage(recruit: recruit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المجندين'),
          backgroundColor: Colors.teal[800],
          elevation: 12,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              bottom: 0,
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/amn.png',
                  width: double.infinity,
                  height: 500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            labelText: 'بحث',
                            border: const OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.teal[800]),
                            suffixIcon: DropdownButton<String>(
                              value: searchType,
                              icon: const Icon(Icons.arrow_drop_down),
                              onChanged: (String? newValue) {
                                setState(() {
                                  searchType = newValue!;
                                });
                                _searchRecruit(searchController.text); // إعادة البحث عند تغيير النوع
                              },
                              items: <String>['الاسم', 'العنوان'].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          onChanged: (value) {
                            _searchRecruit(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: filteredRecruits.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredRecruits.length,
                            itemBuilder: (context, index) {
                              final recruit = filteredRecruits[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                elevation: 6.0,
                                color: Colors.white.withOpacity(0.9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0), // تصغير حجم الكارت
                                  side: BorderSide(color: Colors.teal[800]!, width: 2.0),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12.0),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          recruit.name,
                                          style: TextStyle(
                                            fontSize: 16, // تقليل حجم الخط
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal[800],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'رقم الشرطة: ${recruit.policeNumber}',
                                        style: TextStyle(
                                          fontSize: 14, // تقليل حجم الخط
                                          color: Colors.teal[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'العنوان: ${recruit.address}',
                                          style: TextStyle(
                                            fontSize: 14, // تقليل حجم الخط
                                            color: Colors.teal[600],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'الجهة: ${recruit.employer}',
                                        style: TextStyle(
                                          fontSize: 14, // تقليل حجم الخط
                                          color: Colors.teal[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () => _selectRecruit(recruit),
                                ),
                              );
                            },
                          )
                        : const Center(child: Text('لا توجد بيانات', style: TextStyle(color: Colors.black, fontSize: 25))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
