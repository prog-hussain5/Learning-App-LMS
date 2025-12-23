import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webinar/app/pages/main_page/providers_page/providers_filter.dart';
import 'package:webinar/app/pages/main_page/providers_page/user_profile_page/user_profile_page.dart';
import 'package:webinar/app/providers/app_language_provider.dart';
import 'package:webinar/app/providers/theme_provider.dart';
import 'package:webinar/app/services/guest_service/providers_service.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/shimmer_component.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/config/assets.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/locator.dart';

import '../../../../common/utils/object_instance.dart';
import '../../../../common/utils/tablet_detector.dart';
import '../../../models/user_model.dart';
import '../../../providers/providers_provider.dart';

class ProvidersPage extends StatefulWidget {
  const ProvidersPage({super.key});

  @override
  State<ProvidersPage> createState() => _ProvidersPageState();
}

class _ProvidersPageState extends State<ProvidersPage> with SingleTickerProviderStateMixin{

  late TabController tabController;
  int currentTab=1;

  List<UserModel> instructorsData = [];
  // COMMENTED: Organizations and Consultants hidden - only showing Instructors
  // List<UserModel> organizationsData = [];
  // List<UserModel> consultantsData = [];


  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // MODIFIED: Changed from 3 tabs to 1 tab (only Instructors)
    tabController = TabController(length: 1, vsync: this);

    locator<ProvidersProvider>().clearFilter();

    getInstructors();
    // COMMENTED: Only loading instructors
    // getOrganizations();
    // getConsultants();
  }


  onChangeTab(int i){
    setState(() {
      currentTab = i;
    });
  }

  getInstructors() async {

    setState(() {
      isLoading = true;
    });

    instructorsData = await ProvidersService.getInstructors(
      availableForMeetings: locator<ProvidersProvider>().availableForMeeting,
      freeMeetings: locator<ProvidersProvider>().free,
      discount: locator<ProvidersProvider>().discount,
      downloadable: locator<ProvidersProvider>().downloadable,
      
      sort: locator<ProvidersProvider>().sort,

      categories: locator<ProvidersProvider>().categorySelected
    );

    setState(() {
      isLoading = false;
    });

  }
  
  // COMMENTED: Organizations function - not needed
  // getOrganizations() async {

  //   setState(() {
  //     isLoading = true;
  //   });

  //   organizationsData = await ProvidersService.getOrganizations(
  //     availableForMeetings: locator<ProvidersProvider>().availableForMeeting,
  //     freeMeetings: locator<ProvidersProvider>().free,
  //     discount: locator<ProvidersProvider>().discount,
  //     downloadable: locator<ProvidersProvider>().downloadable,
      
  //     sort: locator<ProvidersProvider>().sort,

  //     categories: locator<ProvidersProvider>().categorySelected
  //   );

  //   setState(() {
  //     isLoading = false;
  //   });

  // }
  
  // COMMENTED: Consultants function - not needed
  // getConsultants() async {

  //   setState(() {
  //     isLoading = true;
  //   });

  //   consultantsData = await ProvidersService.getConsultations(
  //     availableForMeetings: locator<ProvidersProvider>().availableForMeeting,
  //     freeMeetings: locator<ProvidersProvider>().free,
  //     discount: locator<ProvidersProvider>().discount,
  //     downloadable: locator<ProvidersProvider>().downloadable,
      
  //     sort: locator<ProvidersProvider>().sort,

  //     categories: locator<ProvidersProvider>().categorySelected
  //   );

  //   setState(() {
  //     isLoading = false;
  //   });

  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLanguageProvider>(
      builder: (context, appLanguageProvider, _) {
        context.watch<ThemeProvider>();
        return directionality(
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: appbar(
              title: appText.providers,
              leftIcon: AppAssets.menuSvg,
              onTapLeftIcon: () {
                drawerController.showDrawer();
              },
              rightWidth: 22,
            ),
            body: !isLoading && instructorsData.isEmpty
                ? emptyState(AppAssets.providersEmptyStateSvg, appText.noInstructor, appText.noInstructorDesc)
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: TabletDetector.isTablet() ? 3 : 2,
                      mainAxisSpacing: 22,
                      crossAxisSpacing: 22,
                      mainAxisExtent: 195,
                    ),
                    padding: const EdgeInsets.only(
                      right: 21,
                      left: 21,
                      bottom: 100,
                    ),
                    itemCount: isLoading ? 6 : instructorsData.length,
                    itemBuilder: (context, index) {
                      return isLoading
                          ? userProfileCardShimmer()
                          : userProfileCard(instructorsData[index], () {
                              nextRoute(UserProfilePage.pageName, arguments: instructorsData[index].id);
                            });
                    },
                  ),
          ),
        );
      },
    );
  }

}