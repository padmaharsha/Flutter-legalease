import 'package:flutter/material.dart';

class DocAnalysisScreen extends StatefulWidget {
  const DocAnalysisScreen({Key? key}) : super(key: key);

  @override
  _DocAnalysisScreenState createState() => _DocAnalysisScreenState();
}

class _DocAnalysisScreenState extends State<DocAnalysisScreen> {
  String _fileName = "No file selected";
  bool _fileSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D4D4F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF18403F),
        elevation: 0,
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
            const Text(
              "Upload legal document",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                  Text(
                    _fileName,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // No action needed, just UI for now
                        },
                        icon: const Icon(Icons.upload),
                        label: const Text("Select File"),
                      ),
                      if (_fileSelected) ...[
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF18403F),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // Simply show a dialog to simulate PDF viewing
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Viewing $_fileName"),
                                content: const Text("PDF viewer would appear here."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Close"),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.visibility),
                          label: const Text("View"),
                        ),
                      ],
                    ],
                  ),
                  if (_fileSelected) ...[
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF18403F),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            title: Text("Analysis Results"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.check_circle, color: Colors.green),
                                  title: Text("Contract Type: Employment"),
                                ),
                                ListTile(
                                  leading: Icon(Icons.warning, color: Colors.orange),
                                  title: Text("Found 2 potential issues"),
                                ),
                                ListTile(
                                  leading: Icon(Icons.info, color: Colors.blue),
                                  title: Text("3 key clauses identified"),
                                ),
                              ],
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Chip(label: Text("Chat")),
                                  Chip(label: Text("Details")),
                                  Chip(label: Text("Export")),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.analytics),
                      label: const Text("Analyze Document"),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_fileSelected) ...[
              const Text(
                "Document Details",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B3F45),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Filename: $_fileName",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Size: 245.32 KB",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Ready for analysis. Click the Analyze Document button above.",
                        style: TextStyle(color: Color(0xFF8B9A9A)),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Chat History",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1D4D4F),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Column(
                            children: [
                              ChatBubble(
                                message: "I've analyzed your document. It appears to be an employment contract.",
                                isUser: false,
                              ),
                              SizedBox(height: 12),
                              ChatBubble(
                                message: "Can you highlight any potential issues?",
                                isUser: true,
                              ),
                              SizedBox(height: 12),
                              ChatBubble(
                                message: "I found a non-compete clause that may be overly restrictive. Section 8.2 has unclear termination terms.",
                                isUser: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Ask about your document...",
                                hintStyle: const TextStyle(color: Color(0xFF8B9A9A)),
                                filled: true,
                                fillColor: const Color(0xFF1D4D4F),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: const Color(0xFF6C63FF),
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.white),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser)
          const CircleAvatar(
            backgroundColor: Color(0xFF6C63FF),
            radius: 16,
            child: Icon(Icons.smart_toy, size: 16, color: Colors.white),
          ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF6C63FF) : const Color(0xFF2B3F45),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (isUser)
          const CircleAvatar(
            backgroundColor: Color(0xFF18403F),
            radius: 16,
            child: Icon(Icons.person, size: 16, color: Colors.white),
          ),
      ],
    );
  }
}