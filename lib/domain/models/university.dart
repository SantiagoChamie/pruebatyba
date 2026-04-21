class University {
  final String alphaTwoCode;
  final List<String> domains;
  final String country;
  final String? stateProvince;
  final List<String> webPages;
  final String name;
  final String? imagePath;
  final int? numberOfStudents;

  University({
    required this.alphaTwoCode,
    required this.domains,
    required this.country,
    this.stateProvince,
    required this.webPages,
    required this.name,
    this.imagePath,
    this.numberOfStudents,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      alphaTwoCode: json['alpha_two_code'] as String,
      domains: List<String>.from(json['domains'] as List<dynamic>),
      country: json['country'] as String,
      stateProvince: json['state-province'] as String?,
      webPages: List<String>.from(json['web_pages'] as List<dynamic>),
      name: json['name'] as String,
      imagePath: json['imagePath'] as String?,
      numberOfStudents: json['numberOfStudents'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alpha_two_code': alphaTwoCode,
      'domains': domains,
      'country': country,
      'state-province': stateProvince,
      'web_pages': webPages,
      'name': name,
      'imagePath': imagePath,
      'numberOfStudents': numberOfStudents,
    };
  }

  University copyWith({
    String? alphaTwoCode,
    List<String>? domains,
    String? country,
    String? stateProvince,
    List<String>? webPages,
    String? name,
    String? imagePath,
    int? numberOfStudents,
  }) {
    return University(
      alphaTwoCode: alphaTwoCode ?? this.alphaTwoCode,
      domains: domains ?? this.domains,
      country: country ?? this.country,
      stateProvince: stateProvince ?? this.stateProvince,
      webPages: webPages ?? this.webPages,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      numberOfStudents: numberOfStudents ?? this.numberOfStudents,
    );
  }
}