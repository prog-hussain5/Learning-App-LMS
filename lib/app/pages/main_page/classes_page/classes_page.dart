import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webinar/app/providers/drawer_provider.dart';
import 'package:webinar/app/providers/theme_provider.dart';
import 'package:webinar/app/services/guest_service/course_service.dart';
import 'package:webinar/app/widgets/main_widget/classes_widget/classes_widget.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/shimmer_component.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/common/utils/object_instance.dart';
import 'package:webinar/config/assets.dart';
import 'package:webinar/config/colors.dart';
import '../../../models/course_model.dart';
import '../../../providers/app_language_provider.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({super.key});

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  String? errorMessage;
  final ScrollController _scrollController = ScrollController();
  int _offset = 0;
  static const int _pageSize = 10;

  List<CourseModel> allCourses = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    getData();
  }

  Future<void> getData() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
      _offset = 0;
      hasMore = true;
    });

    final List<CourseModel> firstPage =
        await CourseService.getAll(offset: 0, sort: 'newest');

    allCourses = firstPage;
    _offset = allCourses.length;
    hasMore = firstPage.length >= _pageSize;

    // Fallback in case newest endpoint returns empty
    if (allCourses.isEmpty) {
      allCourses = await CourseService.featuredCourse();
      _offset = allCourses.length;
      hasMore = false;
    }

    if (allCourses.isEmpty) {
      errorMessage = appText.noCourseClassesDesc;
    }

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadMore() async {
    if (!mounted || isLoading || isLoadingMore || !hasMore) return;

    setState(() {
      isLoadingMore = true;
    });

    final List<CourseModel> nextPage =
        await CourseService.getAll(offset: _offset, sort: 'newest');

    if (!mounted) return;

    if (nextPage.isEmpty) {
      setState(() {
        hasMore = false;
        isLoadingMore = false;
      });
      return;
    }

    final existingIds = allCourses.map((e) => e.id).toSet();
    final filtered = nextPage.where((c) => !existingIds.contains(c.id)).toList();

    setState(() {
      allCourses.addAll(filtered);
      _offset = allCourses.length;
      hasMore = nextPage.length >= _pageSize;
      isLoadingMore = false;
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 180) {
      _loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLanguageProvider>(builder: (context, provider, _) {
      return directionality(child:
          Consumer<DrawerProvider>(builder: (context, drawerProvider, _) {
        context.watch<ThemeProvider>();

        return ClipRRect(
          borderRadius:
              borderRadius(radius: drawerProvider.isOpenDrawer ? 20 : 0),
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: appbar(
                title: appText.classes,
                leftIcon: AppAssets.menuSvg,
                onTapLeftIcon: () {
                  drawerController.showDrawer();
                }),
            body: RefreshIndicator(
              onRefresh: getData,
              child: !isLoading && allCourses.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      children: [
                        SizedBox(
                          height: getSize().height * .65,
                          child: Center(
                            child: emptyState(
                              AppAssets.noCourseEmptyStateSvg,
                              appText.noCourses,
                              errorMessage ?? appText.noCourseClassesDesc,
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: padding(),
                      itemCount: (isLoading ? 3 : allCourses.length) + 2,
                      itemBuilder: (context, index) {
                        if (isLoading) {
                          if (index < 3) return classesCourseItemShimmer();
                          return const SizedBox();
                        }

                        if (index < allCourses.length) {
                          return ClassessWidget.classesItem(allCourses[index]);
                        }

                        if (index == allCourses.length) {
                          if (isLoadingMore) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.6,
                                    color: green77(),
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        }

                        return space(110);
                      },
                    ),
            ),
          ),
        );
      }));
    });
  }
}
