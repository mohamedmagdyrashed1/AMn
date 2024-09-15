import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'vehicles.dart';
import 'vehiclesdetails.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  _VehiclesPageState createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  List<Vehicle> vehicles = [];
  List<Vehicle> filteredVehicles = [];
  Vehicle? selectedVehicle;
  String searchType = 'النوع'; // نوع البحث الافتراضي

  @override
  void initState() {
    super.initState();
    _loadExcelData();
  }

  Future<void> _loadExcelData() async {
    try {
      final data = await rootBundle.load('assets/vehicles.xlsx');
      final bytes = data.buffer.asUint8List();
      final decoder = SpreadsheetDecoder.decodeBytes(bytes);

      final sheet = decoder.tables.keys.first;
      final table = decoder.tables[sheet];

      if (table != null) {
        setState(() {
          vehicles.clear();
          for (var row in table.rows.skip(2)) {
            if (row.length >= 3) {
              final vehicle = Vehicle(
                type: row[1]?.toString() ?? '',
                model: row[2]?.toString() ?? '',
                employer: row.length > 3 ? row[3]?.toString() ?? '' : '',
                chasisNumber: row.length > 4 ? row[4]?.toString() ?? '' : '',
                secretNumber: row.length > 5 ? row[5]?.toString() ?? '' : '',
                operation: row.length > 6 ? row[6]?.toString() ?? '' : '',
                daily: row.length > 7 ? row[7]?.toString() ?? '' : '',
                service: row.length > 8 ? row[8]?.toString() ?? '' : '',
                technicalCondition: row.length > 9 ? row[9]?.toString() ?? '' : '',
                manufacturingYear: row.length > 10 ? row[10]?.toString() ?? '' : '',
                attachmentsPath: row.length > 11 ? row[11]?.toString() ?? '' : '',
              );
              vehicles.add(vehicle);
            } else {
              print("Skipping row due to insufficient columns.");
            }
          }
          filteredVehicles = vehicles;
        });
      } else {
        print("No table found in the Excel file.");
      }
        } catch (e) {
      print("Error loading Excel file: $e");
    }
  }

  void _searchVehicle(String query) {
    setState(() {
      filteredVehicles = vehicles.where((vehicle) {
        final lowerQuery = query.toLowerCase();
        if (searchType == 'رقم اللوحة') {
          return vehicle.chasisNumber.toLowerCase().contains(lowerQuery);
        } else {
          // افتراضيًا، نقوم بالبحث بناءً على النوع
          return vehicle.type.toLowerCase().contains(lowerQuery);
        }
      }).toList();
      selectedVehicle = null; // Reset selected vehicle on search
    });
  }

  void _selectVehicle(Vehicle vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleDetailsPage(vehicle: vehicle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المركبات'),
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
                          decoration: InputDecoration(
                            labelText: 'بحث',
                            border: const OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.teal[800]),
                          ),
                          onChanged: _searchVehicle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: searchType,
                        items: const [
                          DropdownMenuItem(value: 'النوع', child: Text('بحث بالنوع')),
                          DropdownMenuItem(value: 'رقم اللوحة', child: Text('بحث برقم اللوحة')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            searchType = value ?? 'النوع';
                          });
                        },
                        underline: const SizedBox(),
                        icon: Icon(Icons.arrow_drop_down, color: Colors.teal[800]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: filteredVehicles.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredVehicles.length,
                            itemBuilder: (context, index) {
                              final vehicle = filteredVehicles[index];
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
                                  title: Text(vehicle.model, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[800])),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(vehicle.type, style: TextStyle(fontSize: 16, color: Colors.teal[600])),
                                      Text('الجهة: ${vehicle.employer}', style: TextStyle(fontSize: 14, color: Colors.teal[600])),
                                      Text('الرقم: ${vehicle.chasisNumber}', style: TextStyle(fontSize: 14, color: Colors.teal[600])),
                                    ],
                                  ),
                                  onTap: () => _selectVehicle(vehicle),
                                ),
                              );
                            },
                          )
                        : const Center(child: Text('لا توجد بيانات', style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold))),
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
