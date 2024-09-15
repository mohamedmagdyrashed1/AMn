import 'package:flutter/material.dart';
import 'recruits.dart';

class RecruitDetailsPage extends StatelessWidget {
  final Recruits recruit;

  const RecruitDetailsPage({super.key, required this.recruit});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // تغيير الاتجاه إلى اليمين للشمال
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تفاصيل المجند',
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
                    _buildDetailCard('الاسم:', recruit.name),
                    _buildDetailCard('رقم الشرطة:', recruit.policeNumber),
                    _buildDetailCard('تاريخ التجنيد:', recruit.recruitmentDate),
                    _buildDetailCard('العنوان:', recruit.address),
                    _buildDetailCard('الدرجة:', recruit.degree),
                    _buildDetailCard('الرقم القومي:', recruit.nationalId),
                    _buildDetailCard('تاريخ الميلاد:', recruit.birthDate),
                    _buildDetailCard('العقوبات:', recruit.penalities),
                    _buildDetailCard('الجهة:', recruit.employer),

                    // بطاقة التحريات السياسية
                    _buildDetailCardGroup(
                      title: 'التحريات السياسية',
                      details: [
                        _buildDetail('رقم الرد:', recruit.politicalInvestigationsNumber),
                        _buildDetail('تاريخ الرد :', recruit.politicalInvestigationsDate),
                        _buildDetail('نتيجة  :', recruit.politicalInvestigationsResult),
                      ],
                    ),

                    // بطاقة التحريات الجنائية
                    _buildDetailCardGroup(
                      title: 'التحريات الجنائية',
                      details: [
                        _buildDetail('رقم الرد :', recruit.criminalInvestigationsNumber),
                        _buildDetail('تاريخ الرد :', recruit.criminalInvestigationsDate),
                        _buildDetail('نتيجة  :', recruit.criminalInvestigationsResult),
                      ],
                    ),

                    _buildDetailCard('الحقائق:', recruit.facts),
                    _buildDetailCard('السلوك:', recruit.behaviour),
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

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800], // لون النص
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.teal[800], // لون النص
              ),
              textAlign: TextAlign.end, // محاذاة النص إلى اليمين
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCardGroup({
    required String title,
    required List<Widget> details,
  }) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.teal.shade900,
                ),
              ),
              const SizedBox(height: 8),
              ...details,
            ],
          ),
        ),
      ),
    );
  }
}
