import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  final String apiUrl = "https://legal-ai-api-6g2i.onrender.com/chatbot"; // Update with Render URL

Future<String> getAnswer(String question, String context) async {
  try {
    print("Sending request to API: $apiUrl");
    print("Request Body: ${jsonEncode({"question": question, "context": context})}");

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"question": question, "context": context}),
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["answer"];
    } else {
      return "Error: ${response.statusCode} - ${response.body}";
    }
  } catch (e) {
    print("Exception: $e");
    return "Error: Unable to fetch response";
  }
}


}
