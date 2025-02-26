import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportsHistoryScreen extends StatefulWidget {
  const ReportsHistoryScreen({super.key});

  @override
  _ReportsHistoryScreenState createState() => _ReportsHistoryScreenState();
}

class _ReportsHistoryScreenState extends State<ReportsHistoryScreen> {
  // Map untuk menyimpan controller field input
  Map<String, TextEditingController> _controllers = {};

  // Fungsi untuk Edit Data
  void _editData(String docId, String currentCategory) {
    TextEditingController categoryController =
        TextEditingController(text: currentCategory);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Category"),
        content: TextField(
          controller: categoryController,
          decoration: const InputDecoration(
            labelText: "Category",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Update category in Firestore
              await FirebaseFirestore.instance
                  .collection('reports_history')
                  .doc(docId)
                  .update({
                'category': categoryController.text, // Use the updated value
              });
              Navigator.pop(context);
            },
            child: const Text("Save", style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Reports History"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('reports_history').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No reports available."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var report = snapshot.data!.docs[index];

              // Menginisialisasi controller untuk setiap field laporan hanya jika belum ada
              if (!_controllers.containsKey(report.id)) {
                _controllers[report.id] = TextEditingController(text: report['category']);
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(
                    "${report['category']} - ${report['status']}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date: ${report['date']}", style: const TextStyle(fontSize: 14)),
                      Text("Location: ${report['location']}", style: const TextStyle(fontSize: 14)),
                      Text("Department: ${report['department']}", style: const TextStyle(fontSize: 14)),
                      Text("Remarks: ${report['remarks']}", style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon Edit (Pensil)
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editData(report.id, report['category']), // Call the edit function
                      ),
                      // Icon Delete (Remove)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('reports_history')
                              .doc(report.id)
                              .delete();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
