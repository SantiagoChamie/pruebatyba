import "package:http/http.dart" as http;
import "dart:convert";
import "../../domain/models/university.dart";

class UniversityRemoteDataSource {
  static const String _url =
      "https://tyba-assets.s3.amazonaws.com/FE-Engineer-test/universities.json";

  Future<List<University>> getUniversities() async {
    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((json) => University.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            "Failed to load universities. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching universities: ${e.toString()}");
    }
  }
}