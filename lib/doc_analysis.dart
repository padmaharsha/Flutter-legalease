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
  bool _isLoading = false;
  PlatformFile? _selectedFile;
  String _analysisResult = "";

  // Function to pick a document
  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'txt'],
      withData: true, // Ensures bytes for web compatibility
    );

    if (result != null) {
      setState(() {
        _fileSelected = true;
        _fileName = result.files.single.name;
        _selectedFile = result.files.single;
      });
    }
  }

  // Function to send the document to the Flask backend
  Future<void> _analyzeDocument() async {
    if (_selectedFile == null || _selectedFile!.bytes == null) {
      _showError("No valid file selected.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:5000/analyze'), // Updated endpoint
      );

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        _selectedFile!.bytes!,
        filename: _selectedFile!.name,
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(await response.stream.bytesToString());
        setState(() {
          _analysisResult = jsonResponse['summary'] ?? "No summary available.";
        });
      } else {
        _showError('Failed to analyze document. Try again.');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to display errors
  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D4D4F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF18403F),
        title: const Text(
          'Document Analysis',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
            const Text(
              "Upload Legal Document",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
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
                    onPressed: _pickDocument,
                    icon: const Icon(Icons.upload),
                    label: const Text("Select File"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                    ),
                  ),
                  if (_fileSelected && !_isLoading)
                    ElevatedButton.icon(
                      onPressed: _analyzeDocument,
                      icon: const Icon(Icons.analytics),
                      label: const Text("Analyze Document"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF18403F),
                      ),
                    ),
                  if (_isLoading) const CircularProgressIndicator(),
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
                    child: Text(
                      _analysisResult,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
