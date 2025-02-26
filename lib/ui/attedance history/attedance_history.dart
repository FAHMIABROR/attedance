import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('attendance');

  // Fungsi untuk Edit Data
  void _editData(String docId, String currentName, String currentAddress,
      String currentDescription, String currentDatetime) {
    TextEditingController nameController =
        TextEditingController(text: currentName);
    TextEditingController addressController =
        TextEditingController(text: currentAddress);
    TextEditingController descriptionController =
        TextEditingController(text: currentDescription);
    TextEditingController datetimeController =
        TextEditingController(text: currentDatetime);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Edit Data"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Name")),
                TextField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: "Address")),
                TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: "Description")),
                TextField(
                    controller: datetimeController,
                    decoration: const InputDecoration(labelText: "Datetime")),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await dataCollection.doc(docId).update({
                    'name': nameController.text,
                    'address': addressController.text,
                    'description': descriptionController.text,
                    'datetime': datetimeController.text,
                  });
                  Navigator.pop(context);
                },
                child: const Text("Save", style: TextStyle(color: Colors.blueAccent)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel", style: TextStyle(color: Colors.black)),
              ),
            ],
          );
        },
      ),
    );
  }

  // Fungsi untuk Hapus Data
  void _deleteData(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Data"),
        content: const Text("Are you sure want to delete this data?"),
        actions: [
          TextButton(
            onPressed: () async {
              await dataCollection.doc(docId).delete();
              Navigator.pop(context);
            },
            child: const Text("Yes", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk format timestamp ke format tanggal
  String formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime date = timestamp.toDate();
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    }
    return timestamp.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 26, 0, 143),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          "Attendance History",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: dataCollection.orderBy('datetime', descending: true).snapshots(), // Urutkan data dari yang terbaru
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!.docs;
            return data.isNotEmpty
                ? ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var docId = data[index].id;
                      var name = data[index]['name'];
                      var address = data[index]['address'];
                      var description = data[index]['description'];
                      var datetime = formatTimestamp(data[index]['datetime']); // Format tanggal

                      return Card(
                        margin: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Avatar dengan Warna Acak
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    name[0].toUpperCase(),
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 19),

                              // Data yang Ditampilkan
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Name: $name", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                    Text("Address: $address", style: const TextStyle(fontSize: 14)),
                                    Text("Description: $description", style: const TextStyle(fontSize: 14)),
                                    Text("Timestamp: $datetime", style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),

                              // Tombol Edit & Delete
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                    onPressed: () => _editData(docId, name, address, description, datetime),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteData(docId),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text("No attendance records found!", style: TextStyle(fontSize: 18)),
                  );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
