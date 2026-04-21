import "../../domain/models/university.dart";
import "../../domain/repositories/i_university_repository.dart";
import "../datasources/university_remote_data_source.dart";

class UniversityRepositoryImpl implements IUniversityRepository {
  final UniversityRemoteDataSource remoteDataSource;

  UniversityRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<University>> getUniversities() {
    return remoteDataSource.getUniversities();
  }
}