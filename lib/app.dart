import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:get_it/get_it.dart";
import "package:google_fonts/google_fonts.dart";
import "data/datasources/university_remote_data_source.dart";
import "data/repositories/university_repository_impl.dart";
import "domain/repositories/i_university_repository.dart";
import "presentation/blocs/university_list_bloc.dart";
import "presentation/pages/university_list_page.dart";

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const darkGrey = Color(0xFF54565A);
    const lightGrey = Color(0xFFE8E8E8);
    const accentOrange = Color(0xFFCE6854);
    const detailBlue = Color(0xFF7BA8FF);

    final baseTextTheme = GoogleFonts.interTextTheme(
      ThemeData.light(useMaterial3: true).textTheme,
    ).apply(bodyColor: darkGrey, displayColor: darkGrey);

    return MaterialApp(
      title: "Aplicación universidades",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        colorScheme: const ColorScheme.light(
          primary: accentOrange,
          secondary: detailBlue,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: darkGrey,
        ),
        textTheme: baseTextTheme.copyWith(
          titleLarge: baseTextTheme.titleLarge?.copyWith(
            color: darkGrey,
            fontWeight: FontWeight.w700,
          ),
          titleMedium: baseTextTheme.titleMedium?.copyWith(
            color: darkGrey,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: baseTextTheme.titleSmall?.copyWith(
            color: darkGrey,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: baseTextTheme.bodyLarge?.copyWith(
            color: darkGrey,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: baseTextTheme.bodyMedium?.copyWith(
            color: darkGrey.withValues(alpha: 0.88),
            fontWeight: FontWeight.w500,
          ),
          bodySmall: baseTextTheme.bodySmall?.copyWith(
            color: darkGrey.withValues(alpha: 0.74),
            fontWeight: FontWeight.w400,
          ),
          labelMedium: baseTextTheme.labelMedium?.copyWith(
            color: detailBlue,
            fontWeight: FontWeight.w600,
          ),
          labelSmall: baseTextTheme.labelSmall?.copyWith(
            color: darkGrey.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: darkGrey,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          titleTextStyle: baseTextTheme.titleLarge?.copyWith(
            color: darkGrey,
            fontWeight: FontWeight.w700,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: lightGrey),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: lightGrey.withValues(alpha: 0.45),
          selectedColor: lightGrey,
          disabledColor: lightGrey.withValues(alpha: 0.35),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          labelStyle: baseTextTheme.labelSmall?.copyWith(
            color: darkGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: accentOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: baseTextTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hintStyle: baseTextTheme.bodyMedium?.copyWith(
            color: darkGrey.withValues(alpha: 0.55),
          ),
          labelStyle: baseTextTheme.bodyMedium?.copyWith(
            color: darkGrey.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: lightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: detailBlue, width: 1.4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: accentOrange),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: accentOrange, width: 1.4),
          ),
        ),
      ),
      home: BlocProvider(
        create: (context) => UniversityListBloc(
          repository: GetIt.instance<IUniversityRepository>(),
        ),
        child: const UniversityListPage(),
      ),
    );
  }
}

void setupServiceLocator() {
  final getIt = GetIt.instance;
  
  // Register data sources
  getIt.registerSingleton<UniversityRemoteDataSource>(
    UniversityRemoteDataSource(),
  );
  
  // Register repositories
  getIt.registerSingleton<IUniversityRepository>(
    UniversityRepositoryImpl(
      remoteDataSource: getIt<UniversityRemoteDataSource>(),
    ),
  );
}