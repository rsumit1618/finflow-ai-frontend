import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class ApiConfig {
  static const String baseUrl = "http://localhost:3000";
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> callHealthApi() async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/api/health"),
    );

    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("AWS Learning App")),
        body: Center(
          child: FutureBuilder<String>(
            future: callHealthApi(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                debugPrint("Error: ${snapshot.error}");
                return Text("Error: ${snapshot.error}");
              }

              return Text(snapshot.data ?? "No data");
            },
          ),
        ),
      ),
    );
  }
}