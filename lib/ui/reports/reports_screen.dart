import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportInputScreen extends StatefulWidget {
  const ReportInputScreen({super.key});

  @override
  State<ReportInputScreen> createState() => _ReportInputScreenState();
}

class _ReportInputScreenState extends State<ReportInputScreen> {
  final TextEditingController _field1Controller = TextEditingController();
  final TextEditingController _field2Controller = TextEditingController();
  final TextEditingController _field3Controller = TextEditingController();
  final TextEditingController _field4Controller = TextEditingController();
  final TextEditingController _field5Controller = TextEditingController();
  final TextEditingController _field6Controller = TextEditingController();
  final TextEditingController _field7Controller = TextEditingController();

  bool _isLoading = false;

  bool _areFieldsFilled() {
    return _field1Controller.text.isNotEmpty &&
        _field2Controller.text.isNotEmpty &&
        _field3Controller.text.isNotEmpty &&
        _field4Controller.text.isNotEmpty &&
        _field5Controller.text.isNotEmpty &&
        _field6Controller.text.isNotEmpty &&
        _field7Controller.text.isNotEmpty;
  }

  Future<void> _submitReport() async {
    if (_areFieldsFilled()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseFirestore.instance.collection('reports_history').add({
          'date': _field1Controller.text,
          'category': _field2Controller.text,
          'location': _field3Controller.text,
          'department': _field4Controller.text,
          'report_type': _field5Controller.text,
          'status': _field6Controller.text,
          'remarks': _field7Controller.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Berhasil! Report submitted."),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error submitting the report. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Report Input"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter Report Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 30),
              _buildTextField("Enter the date of the report", _field1Controller),
              _buildTextField("Select the category of the report", _field2Controller),
              _buildTextField("Specify the location of the incident", _field3Controller),
              _buildTextField("Enter the department responsible", _field4Controller),
              _buildTextField("Choose the type of report", _field5Controller),
              _buildTextField("State the current status", _field6Controller),
              _buildTextField("Add any additional remarks", _field7Controller),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading || !_areFieldsFilled() ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Submit Report", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }
}

