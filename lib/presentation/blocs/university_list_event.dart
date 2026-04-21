import "package:equatable/equatable.dart";
import "../../domain/models/university.dart";

abstract class UniversityEvent extends Equatable {
  const UniversityEvent();

  @override
  List<Object> get props => [];
}

class FetchUniversitiesEvent extends UniversityEvent {
  const FetchUniversitiesEvent();
}

class LoadMoreUniversitiesEvent extends UniversityEvent {
  const LoadMoreUniversitiesEvent();
}

class ToggleLayoutEvent extends UniversityEvent {
  const ToggleLayoutEvent();
}

class UpdateUniversityEvent extends UniversityEvent {
  final int index;
  final University university;

  const UpdateUniversityEvent({
    required this.index,
    required this.university,
  });

  @override
  List<Object> get props => [index, university];
}