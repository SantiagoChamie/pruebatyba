import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pruebatyba/domain/models/university.dart';
import 'package:pruebatyba/domain/repositories/i_university_repository.dart';
import 'package:pruebatyba/presentation/blocs/university_list_bloc.dart';
import 'package:pruebatyba/presentation/pages/university_list_page.dart';

class FakeUniversityRepository implements IUniversityRepository {
  FakeUniversityRepository({required this.response, this.shouldThrow = false});

  final List<University> response;
  final bool shouldThrow;

  @override
  Future<List<University>> getUniversities() async {
    if (shouldThrow) {
      throw Exception('Network error');
    }
    return response;
  }
}

Widget buildTestableWidget(IUniversityRepository repository) {
  return MaterialApp(
    home: BlocProvider(
      create: (_) => UniversityListBloc(repository: repository),
      child: const UniversityListPage(),
    ),
  );
}

void main() {
  testWidgets('shows loading then universities when fetch succeeds', (
    WidgetTester tester,
  ) async {
    final repository = FakeUniversityRepository(
      response: [
        University(
          alphaTwoCode: 'CO',
          domains: const ['uni.edu.co'],
          country: 'Colombia',
          webPages: const ['https://uni.edu.co'],
          name: 'Universidad TYBA',
        ),
      ],
    );

    await tester.pumpWidget(buildTestableWidget(repository));
    await tester.pumpAndSettle();

    expect(find.text('Universidad TYBA'), findsOneWidget);
  });

  testWidgets('shows empty message when repository returns no universities', (
    WidgetTester tester,
  ) async {
    final repository = FakeUniversityRepository(response: const []);

    await tester.pumpWidget(buildTestableWidget(repository));
    await tester.pumpAndSettle();

    expect(find.text('No universities found'), findsOneWidget);
  });

  testWidgets('shows retry action when fetch fails', (WidgetTester tester) async {
    final repository = FakeUniversityRepository(
      response: const [],
      shouldThrow: true,
    );

    await tester.pumpWidget(buildTestableWidget(repository));
    await tester.pumpAndSettle();

    expect(find.textContaining('Error:'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);
  });
}
