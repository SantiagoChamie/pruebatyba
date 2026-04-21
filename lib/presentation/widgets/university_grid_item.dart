import "package:flutter/material.dart";
import "dart:io";
import "../../domain/models/university.dart";

class UniversityGridItem extends StatelessWidget {
  final University university;
  final VoidCallback? onTap;

  const UniversityGridItem({Key? key, required this.university, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const lightGrey = Color(0xFFE8E8E8);
    const detailBlue = Color(0xFF7BA8FF);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (university.imagePath != null) ...[
                Flexible(
                  fit: FlexFit.loose,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 100),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: double.infinity,
                        child: Image.file(
                          File(university.imagePath!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              Text(
                university.name,
                style: theme.textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                university.country,
                style: theme.textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: lightGrey.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  university.alphaTwoCode,
                  style: theme.textTheme.labelSmall,
                ),
              ),
              if (university.numberOfStudents != null) ...[
                const SizedBox(height: 8),
                Text(
                  "Estudiantes: ${university.numberOfStudents}",
                  style: theme.textTheme.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  for (var domain in university.domains.take(2))
                    Chip(
                      label: Text(domain),
                      labelStyle: theme.textTheme.labelSmall?.copyWith(
                        color: detailBlue.withValues(alpha: 0.95),
                      ),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
