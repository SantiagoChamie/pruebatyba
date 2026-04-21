import "package:flutter/material.dart";
import "dart:io";
import "../../domain/models/university.dart";

class UniversityCard extends StatelessWidget {
  final University university;
  final VoidCallback? onTap;

  const UniversityCard({Key? key, required this.university, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const darkGrey = Color(0xFF54565A);
    const lightGrey = Color(0xFFE8E8E8);
    const detailBlue = Color(0xFF7BA8FF);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (university.imagePath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(
                    File(university.imagePath!),
                    height: 165,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 14),
              ],
              Text(
                university.name,
                style: theme.textTheme.titleLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: detailBlue),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "${university.country}${university.stateProvince != null ? ", ${university.stateProvince!}" : ""}",
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: lightGrey.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  "Code: ${university.alphaTwoCode}",
                  style: theme.textTheme.labelSmall?.copyWith(color: darkGrey),
                ),
              ),
              if (university.numberOfStudents != null) ...[
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    text: "Estudiantes: ",
                    style: theme.textTheme.bodySmall,
                    children: [
                      TextSpan(
                        text: "${university.numberOfStudents}",
                        style: theme.textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (var domain in university.domains)
                    Chip(
                      label: Text(domain),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              if (university.webPages.isNotEmpty)
                Text(
                  "Website: ${university.webPages.first}",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: detailBlue,
                    decoration: TextDecoration.underline,
                    decorationColor: detailBlue,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
