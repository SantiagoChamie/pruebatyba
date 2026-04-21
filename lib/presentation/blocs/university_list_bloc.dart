import "package:flutter_bloc/flutter_bloc.dart";
import "../../domain/models/university.dart";
import "../../domain/repositories/i_university_repository.dart";
import "university_list_event.dart";
import "university_list_state.dart";

class UniversityListBloc extends Bloc<UniversityEvent, UniversityState> {
  final IUniversityRepository repository;
  static const int _pageSize = 20;
  List<University> _allUniversities = const [];

  UniversityListBloc({required this.repository})
    : super(const UniversityInitial()) {
    on<FetchUniversitiesEvent>(_onFetchUniversities);
    on<LoadMoreUniversitiesEvent>(_onLoadMoreUniversities);
    on<ToggleLayoutEvent>(_onToggleLayout);
    on<UpdateUniversityEvent>(_onUpdateUniversity);
  }

  Future<void> _onFetchUniversities(
    FetchUniversitiesEvent event,
    Emitter<UniversityState> emit,
  ) async {
    emit(const UniversityLoading());
    try {
      final universities = await repository.getUniversities();
      _allUniversities = universities;
      final initialItems =
          universities.length <= _pageSize
              ? universities
              : universities.sublist(0, _pageSize);
      emit(
        UniversityLoaded(
          universities: initialItems,
          hasReachedEnd: initialItems.length >= universities.length,
        ),
      );
    } catch (e) {
      emit(UniversityError(e.toString()));
    }
  }

  Future<void> _onLoadMoreUniversities(
    LoadMoreUniversitiesEvent event,
    Emitter<UniversityState> emit,
  ) async {
    if (state is! UniversityLoaded) return;

    final currentState = state as UniversityLoaded;
    if (currentState.hasReachedEnd || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final currentCount = currentState.universities.length;
    final nextCount = (currentCount + _pageSize).clamp(0, _allUniversities.length);
    final updatedItems = _allUniversities.sublist(0, nextCount);

    emit(
      currentState.copyWith(
        universities: updatedItems,
        isLoadingMore: false,
        hasReachedEnd: nextCount >= _allUniversities.length,
      ),
    );
  }

  Future<void> _onToggleLayout(
    ToggleLayoutEvent event,
    Emitter<UniversityState> emit,
  ) async {
    if (state is UniversityLoaded) {
      final currentState = state as UniversityLoaded;
      final newLayoutType =
          currentState.layoutType == LayoutType.list
              ? LayoutType.grid
              : LayoutType.list;
      emit(currentState.copyWith(layoutType: newLayoutType));
    }
  }

  Future<void> _onUpdateUniversity(
    UpdateUniversityEvent event,
    Emitter<UniversityState> emit,
  ) async {
    if (state is UniversityLoaded) {
      final currentState = state as UniversityLoaded;
      final updatedUniversities = List.of(currentState.universities);

      if (event.index < 0 || event.index >= updatedUniversities.length) {
        return;
      }

      updatedUniversities[event.index] = event.university;
      if (event.index < _allUniversities.length) {
        _allUniversities[event.index] = event.university;
      }
      emit(currentState.copyWith(universities: updatedUniversities));
    }
  }
}
