import 'package:flutter/material.dart';
import 'individual.dart';

class IndividualDetailsPage extends StatelessWidget {
  final Individual individual;

  const IndividualDetailsPage({super.key, required this.individual});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تفاصيل الفرد',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.teal[600], // تغيير لون الخلفية إلى لون عصري
          elevation: 10, // زيادة الظل
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
                  opacity: 0.4, // تقليل التعتيم
                  child: SizedBox(
                    width: 500,
                    height: 500,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildDetailRow('الاسم:', individual.name),
                    _buildDetailRow('الرتبة:', individual.rank),
                    _buildDetailRow('رقم الشرطة:', individual.policeNumber),
                    _buildDetailRow('رقم الهاتف:', individual.phoneNumber),
                    _buildDetailRow('تاريخ التعيين:', individual.hiringDate),
                    _buildDetailRow('الرقم القومي:', individual.nationalId),
                    _buildDetailRow('تاريخ الميلاد:', individual.birthDate),
                    _buildDetailRow('الجهة:', individual.employer),
                    _buildDetailRow('العمل المسند له:', individual.assignedWork),
                    _buildDetailRow('العنوان:', individual.address),
                    _buildDetailRow('الحالة الاجتماعية:', individual.maritalStatus),
                    _buildDetailRow('المؤهل:', individual.degree),

                    // قسم التحريات السياسية
                    _buildInvestigationSection(
                      'التحريات السياسية',
                      individual.politicalinvestnum,
                      individual.politicalinvesdate,
                      individual.politicalinvestres,
                    ),

                    // قسم التحريات الجنائية
                    _buildInvestigationSection(
                      'التحريات الجنائية',
                      individual.criminalinvestNum,
                      individual.criminalinvestdate,
                      individual.criminalinvestres,
                    ),

                    _buildDetailRow('ملاحظات سرية:', individual.secretNote),
                    _buildDetailRow('الوقائع:', individual.facts),
                    _buildDetailRow('الحالة الصحية:', individual.healthStatus),
                    _buildDetailRow('السلوك:', individual.behaviour),
                    _buildDetailRow('الجزاءات:', individual.penalities),

                    if (individual.imagePath.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.asset(
                              'assets/images/${individual.imagePath}',
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: _buildDetailCard(label, value),
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal[100]!, Colors.teal[200]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.teal), // لون الحدود
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.teal[800],
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey[200]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.teal), // لون الحدود
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.left,
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

  Widget _buildInvestigationSection(String title, String responseNumber, String responseDate, String responseResult) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.teal[800],
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 8),
              _buildDetailRow('رقم الرد:', responseNumber),
              _buildDetailRow('تاريخ الرد:', responseDate),
              _buildDetailRow('النتيجة:', responseResult),
            ],
          ),
        ),
      ),
    );
  }
}
