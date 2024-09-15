import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'weapons.dart'; // تأكد من صحة المسار
import 'weaponsdetails.dart'; // تأكد من صحة المسار

class WeaponsPage extends StatefulWidget {
  const WeaponsPage({super.key});

  @override
  _WeaponsPageState createState() => _WeaponsPageState();
}

class _WeaponsPageState extends State<WeaponsPage> {
  List<Weapons> weapons = [];
  List<Weapons> filteredWeapons = [];
  Weapons? selectedWeapon;

  @override
  void initState() {
    super.initState();
    _loadExcelData();
  }

  Future<void> _loadExcelData() async {
    try {
      final data = await rootBundle.load('assets/weapons.xlsx');
      final bytes = data.buffer.asUint8List();
      final decoder = SpreadsheetDecoder.decodeBytes(bytes);

      final sheet = decoder.tables.keys.first; // افترض وجود ورقة واحدة فقط
      final table = decoder.tables[sheet];

      if (table != null) {
        setState(() {
          weapons.clear();
          for (var row in table.rows.skip(1)) { // تخطي الصف الأول كونه العناوين
            final weapon = Weapons(
              weaponType: row[1]?.toString() ?? '',
              weaponNumber: row[2]?.toString() ?? '',
              weaponSigns: row[3]?.toString() ?? '',
              directory: row[4]?.toString() ?? '',
              notes: row[5]?.toString() ?? '',
            );
            weapons.add(weapon);
          }
          filteredWeapons = weapons;
        });
      } else {
        print("No table found in the Excel file.");
      }
        } catch (e) {
      print("Error loading Excel file: $e");
    }
  }

  void _searchWeapon(String query) {
    setState(() {
      filteredWeapons = weapons
          .where((weapon) => weapon.weaponType?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    });
  }

  void _selectWeapon(Weapons weapon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeaponsDetailsPage(weapon: weapon),
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
            'الأسلحة',
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
                  delegate: WeaponSearchDelegate(
                    weapons: weapons,
                    onSearch: _searchWeapon,
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
                      onChanged: _searchWeapon,
                    ),
                  ),
                  Expanded(
                    child: filteredWeapons.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredWeapons.length,
                            itemBuilder: (context, index) {
                              final weapon = filteredWeapons[index];
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
                                    weapon.weaponType ?? '', // التعامل مع القيم null
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal[800], // لون النص
                                    ),
                                  ),
                                  subtitle: Text(
                                    'رقم السلاح: ${weapon.weaponNumber ?? ''}', // التعامل مع القيم null
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.teal[800], // لون النص
                                    ),
                                  ),
                                  onTap: () => _selectWeapon(weapon),
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

class WeaponSearchDelegate extends SearchDelegate {
  final List<Weapons> weapons;
  final Function(String) onSearch;

  WeaponSearchDelegate({required this.weapons, required this.onSearch});

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
    final suggestions = weapons.where((weapon) => weapon.weaponType?.toLowerCase().contains(queryLowerCase) ?? false).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final weapon = suggestions[index];
        return ListTile(
          title: Text(weapon.weaponType ?? '', style: const TextStyle(fontSize: 16)), // التعامل مع القيم null
          subtitle: Text(weapon.weaponNumber ?? '', style: const TextStyle(fontSize: 14)), // التعامل مع القيم null
          onTap: () {
            onSearch(weapon.weaponType ?? '');
            showResults(context);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final queryLowerCase = query.toLowerCase();
    final results = weapons.where((weapon) => weapon.weaponType?.toLowerCase().contains(queryLowerCase) ?? false).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final weapon = results[index];
        return ListTile(
          title: Text(weapon.weaponType ?? '', style: const TextStyle(fontSize: 16)), // التعامل مع القيم null
          subtitle: Text(weapon.weaponNumber ?? '', style: const TextStyle(fontSize: 14)), // التعامل مع القيم null
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WeaponsDetailsPage(weapon: weapon),
              ),
            );
          },
        );
      },
    );
  }
}
