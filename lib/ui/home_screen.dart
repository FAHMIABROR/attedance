import 'package:absensi/ui/reports%20history/report_histori_screen.dart';
import 'package:absensi/ui/reports/reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:absensi/ui/absent/absent_screen.dart';
import 'package:absensi/ui/attedance%20history/attedance_history.dart';
import 'package:absensi/ui/attend/attend_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          SizedBox(
            height: 50,
            child: AppBar(
              backgroundColor: Colors.blueAccent,
              centerTitle: true,
              title: const Text(
                "Attendance - Flutter App Admin",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuButton(
                    context,
                    "Attendance Record",
                    "assets/images/ic_absent.png",
                    const AttendScreen(),
                  ),
                  _buildMenuButton(
                    context,
                    "Permission",
                    "assets/images/ic_leave.png",
                    const AbsentScreen(),
                  ),
                  _buildMenuButton(
                    context,
                    "Attendance History",
                    "assets/images/ic_history.png",
                    const AttendanceHistoryScreen(),
                  ),
                  _buildMenuButton(
                    context,
                    "Reports",
                    Icons.bar_chart,
                    const ReportInputScreen(),
                    isIcon: true,
                  ),
                  _buildMenuButton(
                    context,
                    "Reports History",
                    Icons.history, // Menggunakan icon default untuk history
                    const ReportsHistoryScreen(), // Halaman untuk history reports
                    isIcon: true,
                  ),
                ],
              ),
            ),
          ),

          // Footer
          SizedBox(
            height: 50,
            child: AppBar(
              backgroundColor: Colors.blueAccent,
              centerTitle: true,
              title: const Text(
                "IDN Boarding School Solo",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Fungsi untuk membangun tombol menu dengan gambar atau ikon
  Widget _buildMenuButton(
      BuildContext context, String title, dynamic image, Widget targetScreen,
      {bool isIcon = false}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isIcon
                  ? Icon(image, size: 60, color: Colors.blueAccent)
                  : Image.asset(image, height: 60, width: 60),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
