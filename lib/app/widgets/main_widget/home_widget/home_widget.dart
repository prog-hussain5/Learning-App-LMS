import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:webinar/app/models/course_model.dart';
import 'package:webinar/app/pages/main_page/home_page/notification_page.dart';
import 'package:webinar/app/pages/main_page/home_page/single_course_page/single_course_page.dart';
// import 'package:webinar/app/pages/main_page/home_page/search_page/suggested_search_page.dart'; // unused
import 'package:webinar/app/providers/user_provider.dart';
import 'package:webinar/app/services/authentication_service/authentication_service.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/data/api_public_data.dart';

import '../../../../common/common.dart';
import '../../../../common/utils/app_text.dart';
import '../../../../common/utils/object_instance.dart';
import '../../../../config/assets.dart';
import '../../../../config/colors.dart';
import '../../../../config/styles.dart';
// COMMENTED: Cart disabled
// import '../../../pages/main_page/home_page/cart_page/cart_page.dart';
import '../main_widget.dart';





class HomeWidget{

  // ponytail: branded welcome hero — greeting + a tip that rotates daily.
  static Widget welcomeHero(String name){
    final tips = [appText.homeTip1, appText.homeTip2, appText.homeTip3, appText.homeTip4];
    final tip = tips[DateTime.now().day % tips.length];
    final hasName = name.trim().isNotEmpty;
    return Container(
      width: getSize().width,
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 2),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: green77(),
        borderRadius: borderRadius(),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasName ? '${appText.welcomeBack}, $name 👋' : '${appText.welcomeBack} 👋',
                  style: style16Bold().copyWith(color: Colors.white),
                ),
                space(6),
                Text(
                  tip,
                  style: style12Regular().copyWith(color: Colors.white.withOpacity(0.9)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.school_rounded, color: Colors.white.withOpacity(0.9), size: 42),
        ],
      ),
    );
  }

  static Widget homeAppBar(AnimationController appBarController, Animation appBarAnimation,String token,TextEditingController searchController,FocusNode searchNode,String name){
    return AnimatedBuilder(
      animation: appBarAnimation,
      builder: (context, child) {

        return Consumer<UserProvider>(
          builder: (context,userProvider,_) {

            return Container(
              width: getSize().width,
              height: appBarAnimation.value,
              decoration: BoxDecoration(
                color: green77(),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(28)
                )
              ),

              child: Stack(
                children: [
                  
                  PositionedDirectional(
                    bottom: 0,
                    
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: SvgPicture.asset(
                        AppAssets.appbarLineSvg,
                        width: getSize().width,
                      ),
                    )
                  ),

                  Positioned.fill(
                    child: Padding(
                      padding: padding(),
                      child: Column(
                        children: [
                    
                          // app bar
                          Container(
                            width: getSize().width,
                            margin: EdgeInsets.only(top: (!kIsWeb && Platform.isIOS) ? MediaQuery.of(context).viewPadding.top + 16 : MediaQuery.of(context).viewPadding.top + 22),
                            child: Row(
                              children: [
                                // menu 
                                GestureDetector(
                                  onTap: () async {
                                    drawerController.showDrawer();
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(AppAssets.menuSvg),
                                  ),
                                ),
                                space(0,width: 4),
                                // title
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // username with logo
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          // Academy logo (PNG)
                                          Padding(
                                            padding: const EdgeInsetsDirectional.only(end: 8.0),
                                            child: Image.asset(
                                              AppAssets.balsamLogoColorWTransparent2xPng,
                                              height: 50,
                                            ),
                                          ),
                                          Container(                                       
                                            child: Text(
                                              token.isEmpty
                                              ? appText.webinar
                                              : '${appText.hi} $name ',
                                              style: style20Bold().copyWith(color: Colors.white),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if(token.isNotEmpty)...{
                                            SvgPicture.asset(AppAssets.hiSvg),
                                          }
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 40),
                                        child: Text(
                                          appText.letsStartLearning,
                                          style: style14Regular().copyWith(color: Colors.white, height: 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // COMMENTED: Removed basket icon - no cart functionality
                                // basket and notification
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // COMMENTED: Basket icon removed
                                    // MainWidget.menuButton(
                                    //   AppAssets.basketSvg, 
                                    //   userProvider.cartData?.items?.isNotEmpty ?? false, 
                                    //   Colors.white, 
                                    //   Colors.black.withOpacity(.2), 
                                    //   (){ 
                                    //     nextRoute(CartPage.pageName);
                                    //   }
                                    // ),
                                    space(0,width: 12),
                                    // notification
                                    MainWidget.menuButton(
                                      AppAssets.notificationSvg, 
                                      userProvider.notification.where((element) => element.status == 'unread').isNotEmpty,
                                      Colors.white, 
                                      Colors.black.withOpacity(.2), 
                                      (){
                                        nextRoute(NotificationPage.pageName);
                                      }
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                      
                          // COMMENTED: Search bar disabled
                          // AnimatedCrossFade(
                          //   firstChild: Column(
                          //     children: [
                          //       input(
                          //         searchController, searchNode, appText.searchInputDesc,
                          //         iconPathLeft: AppAssets.searchSvg,isReadOnly: true,
                          //         fillColor: whiteFF_26,
                          //         onTap: (){
                          //           nextRoute(SuggestedSearchPage.pageName);
                          //         }
                          //       ),
                          //       
                          //       space(16)
                          //     ],
                          //   ), 
                          //   secondChild: SizedBox(width: getSize().width), 
                          //    
                          //   crossFadeState: (appBarAnimation.value < (150 + MediaQuery.of(navigatorKey.currentContext!).viewPadding.top)) 
                          //     ? CrossFadeState.showSecond 
                          //     : CrossFadeState.showFirst,
                          //
                          //   duration: const Duration(milliseconds: 200), 
                          // )
                          SizedBox(width: getSize().width)
                        ],
                      ),
                    )
                  )
              ],
            ),
      
            );
          }
        );
      }
    );
  }


  static Widget titleAndMore(String title,{bool isViewAll=true,Function? onTapViewAll}){
    return Padding(
      padding: padding(vertical: 16),
      child: Row(
        children: [
          
          Text(
            title,
            style: style20Bold(),
          ),

          const Spacer(),

          if(isViewAll)...{
            GestureDetector(
              onTap: (){
                if(onTapViewAll != null){
                  onTapViewAll();
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Text(
                appText.viewAll,
                style: style14Regular().copyWith(color: greyB2),
              ),
            )
          }

        ],
      ),
    );
  }

  // ponytail: full-width "my courses" card for the home screen (Option A layout)
  static Widget myCourseCard(CourseModel course){
    double w = getSize().width - 32;
    return GestureDetector(
      onTap: (){
        nextRoute(SingleCoursePage.pageName, arguments: [course.id, course.type == 'bundle']);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: whiteFF_26,
          borderRadius: borderRadius(radius: 15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            fadeInImage(course.image ?? '', w, 170),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    course.title ?? '',
                    style: style16Bold(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  if((course.teacher?.fullName ?? '').isNotEmpty)...{
                    space(6),
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 15, color: greyA5),
                        space(0, width: 4),
                        Expanded(
                          child: Text(
                            course.teacher?.fullName ?? '',
                            style: style12Regular().copyWith(color: greyA5),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  },

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }


  static Future showFinalizeRegister(int userId) async {

    TextEditingController nameController = TextEditingController();
    FocusNode nameNode = FocusNode();

    TextEditingController referralController = TextEditingController();
    FocusNode referralNode = FocusNode();

    bool isLoading = false;

    return await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: navigatorKey.currentContext!, 
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {

            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  directionality(
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(navigatorKey.currentContext!).viewInsets.bottom
                      ),
                      width: getSize().width,
                      padding: padding(vertical: 21),
                      decoration: BoxDecoration(
                        color: whiteFF_26,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(30))
                      ),
                  
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Text(
                            appText.finalizeYourAccount,
                            style: style16Bold(),
                          ),
                  
                          space(16),
                  
                          input(nameController, nameNode, appText.yourName, iconPathLeft: AppAssets.profileSvg, leftIconSize: 14,isBorder: true),
                          
                          if(PublicData.apiConfigData?['referralSettings']['status'] ?? false)...{

                            space(16),
                    
                            input(referralController, referralNode, appText.refCode, iconPathLeft: AppAssets.ticketSvg, leftIconSize: 14,isBorder: true),
                            
                          },
                          space(24),
            
                          Center(
                            child: button(
                              onTap: () async {
                                if(nameController.text.length > 3){
                                  setState((){
                                    isLoading = true;
                                  });
                                  
                                  bool res = await AuthenticationService.registerStep3(
                                    userId, 
                                    nameController.text.trim(), 
                                    referralController.text.trim()
                                  );
            
                                  if(res){
                                    backRoute(arguments: res);
                                  }
                                  
                                  setState((){
                                    isLoading = false;
                                  });
                                }
                              }, 
                              width: getSize().width, 
                              height: 52, 
                              text: appText.continue_, 
                              bgColor: green77(), 
                              textColor: Colors.white, 
                              isLoading: isLoading
                            ),
                          ),
            
                          space(24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );

          },
        );
      },
    );
  }
}