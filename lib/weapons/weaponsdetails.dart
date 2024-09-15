import 'package:flutter/material.dart';
import 'package:flutteramndatabase/weapons/EditWeaponPage.dart';
import 'package:flutteramndatabase/weapons/weapons.dart';

class WeaponsDetailsPage extends StatelessWidget {
  final Weapons weapon;

  const WeaponsDetailsPage({super.key, required this.weapon});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تفاصيل السلاح',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.teal[700],
          elevation: 12,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  // الانتقال إلى صفحة تعديل البيانات
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditWeaponPage(weapon: weapon),
                    ),
                  ).then((updatedWeapon) {
                    if (updatedWeapon != null && updatedWeapon is Weapons) {
                      // تحديث البيانات في صفحة التفاصيل بعد العودة من صفحة التعديل
                      // يمكنك إعادة تحميل البيانات أو تحديث الواجهة حسب الحاجة
                    }
                  });
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('تعديل البيانات'),
                  ),
                ];
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
                  opacity: 0.3,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
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
                    _buildDetailCard('نوع السلاح:', weapon.weaponType ?? 'غير متوفر'),
                    _buildDetailCard('رقم السلاح:', weapon.weaponNumber ?? 'غير متوفر'),
                    _buildDetailCard('علامات السلاح:', weapon.weaponSigns ?? 'غير متوفر'),
                    _buildDetailCard('الإدارة:', weapon.directory ?? 'غير متوفر'),
                    _buildDetailCard('ملاحظات:', weapon.notes ?? 'غير متوفر'),
                    const SizedBox(height: 20),
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
                    border: Border.all(color: Colors.teal.shade200),
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
                    border: Border.all(color: Colors.teal.shade200),
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
