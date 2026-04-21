import "dart:io";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "../../domain/models/university.dart";

class UniversityDetailPage extends StatefulWidget {
  final University university;

  const UniversityDetailPage({Key? key, required this.university})
    : super(key: key);

  @override
  State<UniversityDetailPage> createState() => _UniversityDetailPageState();
}

class _UniversityDetailPageState extends State<UniversityDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _studentsController = TextEditingController();
  final _imagePicker = ImagePicker();

  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.university.imagePath;
    if (widget.university.numberOfStudents != null) {
      _studentsController.text = widget.university.numberOfStudents.toString();
    }
  }

  @override
  void dispose() {
    _studentsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (image == null) return;

    setState(() {
      _imagePath = image.path;
    });
  }

  Future<void> _showImageOptions() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Elegir de galeria"),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text("Tomar foto"),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) return;

    final studentsText = _studentsController.text.trim();
    final numberOfStudents =
        studentsText.isEmpty ? null : int.parse(studentsText);

    Navigator.of(context).pop(
      widget.university.copyWith(
        imagePath: _imagePath,
        numberOfStudents: numberOfStudents,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const darkGrey = Color(0xFF54565A);
    const lightGrey = Color(0xFFE8E8E8);
    const accentOrange = Color(0xFFCE6854);
    final invertOnPressButtonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.pressed) ? Colors.white : accentOrange;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.pressed) ? accentOrange : Colors.white;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        return BorderSide(
          color: accentOrange,
          width: states.contains(WidgetState.pressed) ? 1.4 : 0,
        );
      }),
    );

    return Scaffold(
      appBar: AppBar(title: Text(
                widget.university.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: darkGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_imagePath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(_imagePath!),
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: lightGrey.withValues(alpha: 0.6),
                    border: Border.all(color: lightGrey),
                  ),
                  child: Center(
                    child: Text(
                      "No image selected",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _showImageOptions,
                style: invertOnPressButtonStyle,
                icon: const Icon(Icons.add_a_photo),
                label: const Text("Subir imagen"),
              ),              
              const SizedBox(height: 24),
              TextFormField(
                controller: _studentsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Numero de estudiantes",
                  hintText: "Ej: 15000",
                ),
                validator: (value) {
                  final text = value?.trim() ?? "";
                  if (text.isEmpty) {
                    return null;
                  }

                  final number = int.tryParse(text);
                  if (number == null) {
                    return "Ingresa un numero valido";
                  }

                  if (number <= 0) {
                    return "El numero debe ser mayor a 0";
                  }

                  if (number > 1000000000) {
                    return "El numero es demasiado grande";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saveChanges,
                  style: invertOnPressButtonStyle,
                  child: const Text("Guardar cambios"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
