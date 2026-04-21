import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../blocs/university_list_bloc.dart";
import "../blocs/university_list_event.dart";
import "../blocs/university_list_state.dart";
import "../../domain/models/university.dart";
import "university_detail_page.dart";
import "../widgets/university_card.dart";
import "../widgets/university_grid_item.dart";

class UniversityListPage extends StatefulWidget {
  const UniversityListPage({Key? key}) : super(key: key);

  @override
  State<UniversityListPage> createState() => _UniversityListPageState();
}

class _UniversityListPageState extends State<UniversityListPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<UniversityListBloc>().add(const FetchUniversitiesEvent());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final triggerFetchMore =
        _scrollController.position.pixels >=
        (_scrollController.position.maxScrollExtent * 0.9);

    if (triggerFetchMore) {
      context.read<UniversityListBloc>().add(const LoadMoreUniversitiesEvent());
    }
  }

  Future<void> _openDetailPage({
    required University university,
    required int index,
  }) async {
    final updatedUniversity = await Navigator.of(context).push<University>(
      MaterialPageRoute(
        builder: (_) => UniversityDetailPage(university: university),
      ),
    );

    if (updatedUniversity != null && mounted) {
      context.read<UniversityListBloc>().add(
        UpdateUniversityEvent(index: index, university: updatedUniversity),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const detailBlue = Color(0xFF7BA8FF);
    const darkGrey = Color(0xFF54565A);

    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        actions: [
          BlocBuilder<UniversityListBloc, UniversityState>(
            builder: (context, state) {
              if (state is UniversityLoaded) {
                return IconButton(
                  icon: Icon(
                    state.layoutType == LayoutType.list
                        ? Icons.grid_view
                        : Icons.view_list,
                    color: detailBlue,
                  ),
                  onPressed: () {
                    context.read<UniversityListBloc>().add(
                      const ToggleLayoutEvent(),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<UniversityListBloc, UniversityState>(
        builder: (context, state) {
          if (state is UniversityLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UniversityLoaded) {
            if (state.universities.isEmpty) {
              return Center(
                child: Text(
                  "No universities found",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }

            if (state.layoutType == LayoutType.list) {
              final itemCount =
                  state.universities.length + (state.hasReachedEnd ? 0 : 1);
              return ListView.builder(
                controller: _scrollController,
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  if (index >= state.universities.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return UniversityCard(
                    university: state.universities[index],
                    onTap:
                        () => _openDetailPage(
                          university: state.universities[index],
                          index: index,
                        ),
                  );
                },
              );
            } else {
              final itemCount =
                  state.universities.length + (state.hasReachedEnd ? 0 : 1);
              return GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.78,
                ),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  if (index >= state.universities.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return UniversityGridItem(
                    university: state.universities[index],
                    onTap:
                        () => _openDetailPage(
                          university: state.universities[index],
                          index: index,
                        ),
                  );
                },
              );
            }
          } else if (state is UniversityError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: darkGrey.withValues(alpha: 0.7),
                    size: 28,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Error: ${state.message}",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UniversityListBloc>().add(
                        const FetchUniversitiesEvent(),
                      );
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text("Unknown state"));
        },
      ),
    );
  }
}
