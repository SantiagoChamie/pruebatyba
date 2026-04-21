import "package:equatable/equatable.dart";
import "../../domain/models/university.dart";

enum LayoutType { list, grid }

abstract class UniversityState extends Equatable {
  const UniversityState();

  @override
  List<Object> get props => [];
}

class UniversityInitial extends UniversityState {
  const UniversityInitial();
}

class UniversityLoading extends UniversityState {
  const UniversityLoading();
}

class UniversityLoaded extends UniversityState {
  final List<University> universities;
  final LayoutType layoutType;
  final bool isLoadingMore;
  final bool hasReachedEnd;

  const UniversityLoaded({
    required this.universities,
    this.layoutType = LayoutType.list,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
  });

  UniversityLoaded copyWith({
    List<University>? universities,
    LayoutType? layoutType,
    bool? isLoadingMore,
    bool? hasReachedEnd,
  }) {
    return UniversityLoaded(
      universities: universities ?? this.universities,
      layoutType: layoutType ?? this.layoutType,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object> get props => [
    universities,
    layoutType,
    isLoadingMore,
    hasReachedEnd,
  ];
}

class UniversityError extends UniversityState {
  final String message;

  const UniversityError(this.message);

  @override
  List<Object> get props => [message];
}