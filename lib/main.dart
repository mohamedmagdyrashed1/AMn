import 'package:flutter/material.dart';
import 'package:flutteramndatabase/individuals/indiviualspage.dart';
import 'package:flutteramndatabase/officers/Officerspage.dart';
import 'package:flutteramndatabase/recruits/recruitspage.dart';
import 'package:flutteramndatabase/vehicles/vehiclespage.dart';
import 'package:flutteramndatabase/weapons/WeaponsPage.dart'; // استيراد صفحة الأسلحة
import 'package:flutter_animate/flutter_animate.dart'; // استيراد مكتبة flutter_animate

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قاعدة بيانات إدارة الأمن'),
        centerTitle: true,
        backgroundColor: Colors.teal[800],
        elevation: 4.0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.grey.withOpacity(0.0),
                BlendMode.saturation,
              ),
              child: Image.asset(
                'assets/images/amn.png',
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: <Widget>[
                  _buildCustomButton(context, 'الضباط', const OfficersPage())
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 1.0, end: 0.0), // إضافة أنيميشن للزر
                  _buildCustomButton(context, 'الأفراد', const IndividualsPage())
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 1.0, end: 0.0), // إضافة أنيميشن للزر
                  _buildCustomButton(context, 'المجندين', const RecruitsPage())
                      .animate()
                      .fadeIn(duration: 700.ms)
                      .slideY(begin: 1.0, end: 0.0), // إضافة أنيميشن للزر
                  _buildCustomButton(context, 'السيارات', const VehiclesPage())
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .slideY(begin: 1.0, end: 0.0), // إضافة أنيميشن للزر
                  _buildCustomButton(context, 'الأسلحة', const WeaponsPage())
                      .animate()
                      .fadeIn(duration: 900.ms)
                      .slideY(begin: 1.0, end: 0.0), // إضافة أنيميشن للزر الجديد
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton(BuildContext context, String text, Widget page) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 8, // الظل تحت الأزرار
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {
          if (text == 'المجندين') {
            _showLoadingDialog(context, () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            });
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
          decoration: BoxDecoration(
            color: Colors.teal[600],
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18.0, // تكبير حجم الخط
                fontWeight: FontWeight.bold, // جعل الخط عريض
                color: Colors.white, // لون النص
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLoadingDialog(BuildContext context, Future<void> Function() onDone) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 16.0), // مسافة بين دائرة التحميل والنص
                Text(
                  'جاري تحميل البيانات...',
                  style: TextStyle(
                    fontSize: 16.0, // حجم الخط
                    fontWeight: FontWeight.bold, // جعل الخط عريض
                    color: Colors.white, // لون النص
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () async {
      Navigator.pop(context); // Close the loading dialog
      await onDone(); // Navigate to the page
    });
  }
}
