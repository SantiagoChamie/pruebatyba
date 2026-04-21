import "../models/university.dart";

abstract class IUniversityRepository {
  Future<List<University>> getUniversities();
}