import 'package:flutter/material.dart';
// لإضافة الصورة من الأصول
import 'officer.dart';

class OfficerDetailsPage extends StatelessWidget {
  final Officer officer;

  const OfficerDetailsPage({super.key, required this.officer});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تفاصيل الضابط',
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
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {
                // إضافة وظيفة للمشاركة
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                // إضافة وظيفة لعرض مزيد من الخيارات
              },
            ),
          ],
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
                    _buildDetailCard('الاسم:', officer.name),
                    _buildDetailCard('الرتبة:', officer.rank),
                    _buildDetailCard('الأقدمية:', officer.seniority),
                    _buildDetailCard('العنوان:', officer.address),
                    _buildDetailCard('رقم الهاتف:', officer.phoneNumber),
                    _buildDetailCard('الجهة:', officer.employer),
                    _buildDetailCard('العمل المكلف به:', officer.assignedWork),
                    _buildDetailCard('الحالة الاجتماعية:', officer.maritalStatus),
                    _buildDetailCard('رقم السلاح:', officer.weaponNumber),
                    _buildDetailCard('الفرق التدريبية:', officer.trainingBand),
                    _buildDetailCard('الجهة السابقة:', officer.previousEmployer),
                    _buildDetailCard('الدرجة العلمية:', officer.degree),
                    _buildDetailCard('الماموريات الخارجية:', officer.missions),
                    _buildDetailCard('الرقم القومي:', officer.nationalId),
                    _buildDetailCard('تاريخ الميلاد:', officer.birthDate),
                    _buildDetailCard('الجزاءات:', officer.penalties),
                    _buildDetailCard('الوقائع:', officer.facts),
                    _buildDetailCard('الحالة الصحية:', officer.healthStatus),
                    _buildDetailCard('السلوك:', officer.behaviour),
                    _buildDetailCard('اسم الشهرة:', officer.publicName),
                    if (officer.imagePath.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset(
                            'assets/images/${officer.imagePath}',
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
