import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://127.0.0.1:5000";  // Change to your Flask server URL if different

  Future<String> getChatbotResponse(String question) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/chatbot"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"question": question}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data["answer"];
      } else {
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      return "Failed to connect to server: $e";
    }
  }
}
