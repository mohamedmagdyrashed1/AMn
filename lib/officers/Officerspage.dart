import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'officer.dart';
import 'officers_details_page.dart';

class OfficersPage extends StatefulWidget {
  const OfficersPage({super.key});

  @override
  _OfficersPageState createState() => _OfficersPageState();
}

class _OfficersPageState extends State<OfficersPage> {
  List<Officer> officers = [];
  List<Officer> filteredOfficers = [];
  Officer? selectedOfficer;

  @override
  void initState() {
    super.initState();
    _loadExcelData();
  }

  Future<void> _loadExcelData() async {
    try {
      final data = await rootBundle.load('assets/officers.xlsx');
      final bytes = data.buffer.asUint8List();
      final decoder = SpreadsheetDecoder.decodeBytes(bytes);

      final sheet = decoder.tables.keys.first; // افترض وجود ورقة واحدة فقط
      final table = decoder.tables[sheet];

      if (table != null) {
        setState(() {
          officers.clear();
          for (var row in table.rows.skip(1)) { // تخطي الصف الأول كونه العناوين
            final officer = Officer(
              name: row[2]?.toString() ?? '',
              rank: row[1]?.toString() ?? '',
              seniority: row[3]?.toString() ?? '',
              address: row[4]?.toString() ?? '',
              phoneNumber: row[5]?.toString() ?? '',
              employer: row[6]?.toString() ?? '',
              assignedWork: row[7]?.toString() ?? '',
              previousEmployer: row[8]?.toString() ?? '',
              weaponNumber: row[9]?.toString() ?? '',
              maritalStatus: row[10]?.toString() ?? '',
              trainingBand: row[11]?.toString() ?? '',
              degree: row[12]?.toString() ?? '',
              nationalId: row[13]?.toString() ?? '',
              birthDate: row[14]?.toString() ?? '',
              missions: row[15]?.toString() ?? '',
              penalties: row[16]?.toString() ?? '',
              facts: row[17]?.toString() ?? '',
              healthStatus: row[18]?.toString() ?? '',
              behaviour: row[19]?.toString() ?? '',
              publicName: row[20]?.toString() ?? '',
              imagePath: row[21]?.toString() ?? '',
            );
            officers.add(officer);
          }
          filteredOfficers = officers;
        });
      } else {
        print("No table found in the Excel file.");
      }
        } catch (e) {
      print("Error loading Excel file: $e");
    }
  }

  void _searchOfficer(String query) {
    setState(() {
      filteredOfficers = officers
          .where((officer) => officer.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectOfficer(Officer officer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OfficerDetailsPage(officer: officer),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // تغيير الاتجاه إلى اليمين للشمال
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'الضباط',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // تحسين حجم النص وسمكه
          ),
          backgroundColor: Colors.teal[800], // لون خلفية عصري
          elevation: 12, // زيادة تأثير الظل
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search, size: 24, color: Colors.white), // تصغير حجم الأيقونة
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: OfficerSearchDelegate(
                    officers: officers,
                    onSearch: _searchOfficer,
                  ),
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              bottom: 0,
              child: Opacity(
                opacity: 0.5, // تقليل تباين الصورة
                child: Image.asset(
                  'assets/images/amn.png',
                  //fit: BoxFit.cover,
                  width: double.infinity,
                  height: 500, // تحديد ارتفاع الصورة
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0), // تقليل الحشو
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10), // إضافة هوامش فوق وتحت الصورة
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'بحث',
                        border: const OutlineInputBorder(),
                        labelStyle: TextStyle(color: Colors.teal[800]), // لون النص في حقل البحث
                      ),
                      onChanged: _searchOfficer,
                    ),
                  ),
                  Expanded(
                    child: filteredOfficers.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredOfficers.length,
                            itemBuilder: (context, index) {
                              final officer = filteredOfficers[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4.0), // تقليل المسافة بين الكروت
                                elevation: 6, // زيادة تأثير الظل لجعل الكروت أكثر بروزاً
                                color: Colors.white.withOpacity(0.8), // تحديد لون الكارت مع الشفافية
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0), // تحديد حدود دائرية للكروت
                                  side: BorderSide(
                                    color: Colors.teal[800]!, // لون حدود الكروت
                                    width: 2.0, // سمك حدود الكروت
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12.0), // تقليل الحشو الداخلي
                                  title: Text(
                                    officer.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal[800], // لون النص
                                    ),
                                  ),
                                  subtitle: Text(
                                    'رتبة: ${officer.rank}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.teal[800], // لون النص
                                    ),
                                  ),
                                  onTap: () => _selectOfficer(officer),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 20, color: Colors.teal[800]), // تصغير حجم الأيقونة ولونها عصري
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'لا توجد بيانات',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.teal[800], // لون النص
                              ),
                            ),
                          ),
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

class OfficerSearchDelegate extends SearchDelegate {
  final List<Officer> officers;
  final Function(String) onSearch;

  OfficerSearchDelegate({required this.officers, required this.onSearch});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.clear, size: 24), // تصغير حجم الأيقونة
        onPressed: () {
          query = ''; // Clear the search query
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, size: 24), // تصغير حجم الأيقونة
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final queryLowerCase = query.toLowerCase();
    final suggestions = officers.where((officer) => officer.name.toLowerCase().contains(queryLowerCase)).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final officer = suggestions[index];
        return ListTile(
          title: Text(officer.name, style: const TextStyle(fontSize: 16)), // تصغير حجم النص
          subtitle: Text(officer.rank, style: const TextStyle(fontSize: 14)), // تصغير حجم النص
          onTap: () {
            onSearch(officer.name);
            showResults(context);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final queryLowerCase = query.toLowerCase();
    final results = officers.where((officer) => officer.name.toLowerCase().contains(queryLowerCase)).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final officer = results[index];
        return ListTile(
          title: Text(officer.name, style: const TextStyle(fontSize: 16)), // تصغير حجم النص
          subtitle: Text(officer.rank, style: const TextStyle(fontSize: 14)), // تصغير حجم النص
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OfficerDetailsPage(officer: officer),
              ),
            );
          },
        );
      },
    );
  }
}
