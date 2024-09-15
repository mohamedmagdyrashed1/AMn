import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutteramndatabase/individuals/individual.dart';
import 'package:flutteramndatabase/individuals/IndividualsDetailspage.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class IndividualsPage extends StatefulWidget {
  const IndividualsPage({super.key});

  @override
  _IndividualsPageState createState() => _IndividualsPageState();
}

class _IndividualsPageState extends State<IndividualsPage> {
  List<Individual> individuals = [];
  List<Individual> filteredIndividuals = [];
  Individual? selectedIndividual;

  @override
  void initState() {
    super.initState();
    _loadExcelData();
  }

  Future<void> _loadExcelData() async {
    try {
      final data = await rootBundle.load('assets/individuals.xlsx');
      final bytes = data.buffer.asUint8List();
      final decoder = SpreadsheetDecoder.decodeBytes(bytes);

      final sheet = decoder.tables.keys.first;
      final table = decoder.tables[sheet];

      if (table != null) {
        setState(() {
          individuals.clear();
          for (var row in table.rows.skip(2)) { 
            if (row.length >= 3) {
              final individual = Individual(
                name: row[1]?.toString() ?? '',
                rank: row[2]?.toString() ?? '',
                policeNumber: row.length > 3 ? row[3]?.toString() ?? '' : '',
                hiringDate : row.length > 4 ? row[4]?.toString() ?? '' : '',
                nationalId: row.length > 5 ? row[5]?.toString() ?? '' : '',
                birthDate: row.length > 6 ? row[6]?.toString() ?? '' : '',
                employer: row.length > 7 ? row[7]?.toString() ?? '' : '',
                assignedWork: row.length > 8 ? row[8]?.toString() ?? '' : '',
                address: row.length > 9 ? row[9]?.toString() ?? '' : '',
                maritalStatus: row.length > 10 ? row[10]?.toString() ?? '' : '',
                degree: row.length > 11 ? row[11]?.toString() ?? '' : '',
                politicalinvestnum: row.length > 12 ? row[12]?.toString() ?? '' : '',
                politicalinvesdate: row.length > 13 ? row[13]?.toString() ?? '' : '',
                politicalinvestres: row.length > 14 ? row [14]?.toString()?? '' : '',
                criminalinvestNum: row.length > 15 ? row[15]?.toString() ?? '' : '',
                criminalinvestdate: row.length > 16 ? row[16]?.toString() ?? '' : '',
                criminalinvestres: row.length > 17 ? row[17]?.toString() ?? '' : '',
                secretNote: row.length > 18 ? row[18]?.toString() ?? '' : '',
                healthStatus: row.length > 21 ? row[21]?.toString() ?? '' : '',
                penalities: row.length > 19 ? row[19]?.toString() ?? '' : '',
                facts: row.length > 20 ? row[20]?.toString() ?? '' : '',
                behaviour: row.length > 22 ? row[22]?.toString() ?? '' : '',
                phoneNumber: row.length > 23 ? row[23]?.toString() ?? '' : '',
                imagePath: row.length > 24 ? row[24]?.toString() ?? '' : '',
              );
              individuals.add(individual);
            } else {
              print("Skipping row due to insufficient columns.");
            }
          }
          filteredIndividuals = individuals;
        });
      } else {
        print("No table found in the Excel file.");
      }
        } catch (e) {
      print("Error loading Excel file: $e");
    }
  }

  void _searchIndividual(String query) {
    setState(() {
      filteredIndividuals = individuals
          .where((individual) => individual.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      selectedIndividual = null; // Reset selected individual on search
    });
  }

  void _selectIndividual(Individual individual) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IndividualDetailsPage(individual: individual),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الأفراد'),
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
                //  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'بحث',
                      border: const OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.teal[800]),
                    ),
                    onChanged: _searchIndividual,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: filteredIndividuals.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredIndividuals.length,
                            itemBuilder: (context, index) {
                              final individual = filteredIndividuals[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                elevation: 6.0,
                                color: Colors.white.withOpacity(0.9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: BorderSide(color: Colors.teal[800]!, width: 2.0),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16.0),
                                  title: Text(individual.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[800])),
                                  subtitle: Text(individual.rank, style: TextStyle(fontSize: 16, color: Colors.teal[600])),
                                  onTap: () => _selectIndividual(individual),
                                ),
                              );
                            },
                          )
                        : Center(child: Text('لا توجد بيانات', style: TextStyle(color: Colors.teal[800], fontSize: 16))),
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
