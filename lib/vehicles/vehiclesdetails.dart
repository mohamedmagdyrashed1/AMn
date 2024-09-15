import 'package:flutter/material.dart';
import 'vehicles.dart';

class VehicleDetailsPage extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetailsPage({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تفاصيل المركبة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.teal[700], // لون خلفية عصري
          elevation: 12, // زيادة الظل
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: 0.3, // تقليل التعتيم
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(
                      'assets/images/amn.png',
                      //fit: BoxFit.cover, // ملء الشاشة بالصورة بشكل صحيح
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildDetailCard('نوع المركبة:', vehicle.type),
                    _buildDetailCard('الموديل:', vehicle.model),
                    _buildDetailCard('الجهة:', vehicle.employer),
                    _buildDetailCard('رقم اللوحة:', vehicle.chasisNumber),
                    _buildDetailCard('الرقم السري:', vehicle.secretNumber),
                    _buildDetailCard('التشغيل:', vehicle.operation),
                    _buildDetailCard('اليومية:', vehicle.daily),
                    _buildDetailCard('الخدمة:', vehicle.service),
                    _buildDetailCard('الحالة الفنية:', vehicle.technicalCondition),
                    _buildDetailCard('سنة التصنيع:', vehicle.manufacturingYear),
                    if (vehicle.attachmentsPath.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset(
                            'assets/images/${vehicle.attachmentsPath}',
                            height: 200, // حجم الصورة
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
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

  Widget _buildDetailCard(String label, String value) {
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
                    border: Border.all(color: Colors.teal.shade200), // لون الحدود
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
                    border: Border.all(color: Colors.teal.shade200), // لون الحدود
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
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
