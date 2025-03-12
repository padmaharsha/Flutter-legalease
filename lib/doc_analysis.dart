import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DocAnalysisScreen extends StatefulWidget {
  const DocAnalysisScreen({Key? key}) : super(key: key);

  @override
  _DocAnalysisScreenState createState() => _DocAnalysisScreenState();
}

class _DocAnalysisScreenState extends State<DocAnalysisScreen> {
  String _fileName = "No file selected";
  bool _fileSelected = false;
  File? _selectedFile;
  String _analysisResult = "";

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
        _fileSelected = true;
      });
    }
  }

  Future<void> _analyzeDocument() async {
    if (_selectedFile == null) return;

    var uri = Uri.parse("http://127.0.0.1:5000/analyze");
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', _selectedFile!.path));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);

        setState(() {
          _analysisResult = jsonResponse['summary'] ?? 'No summary available';
        });
      } else {
        setState(() {
          _analysisResult = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _analysisResult = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D4D4F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF18403F),
        title: const Text(
          'Document Analysis',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Upload Legal Document", style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2B3F45),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF6C63FF), width: 1),
              ),
              child: Column(
                children: [
                  Icon(
                    _fileSelected ? Icons.description : Icons.upload_file,
                    size: 50,
                    color: const Color(0xFF6C63FF),
                  ),
                  const SizedBox(height: 16),

                  Text(_fileName, style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 16),

                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.upload),
                    label: const Text("Select File"),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
                  ),

                  if (_fileSelected)
                    ElevatedButton.icon(
                      onPressed: _analyzeDocument,
                      icon: const Icon(Icons.analytics),
                      label: const Text("Analyze Document"),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF18403F)),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),
if (_analysisResult.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B3F45),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(_analysisResult, style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}