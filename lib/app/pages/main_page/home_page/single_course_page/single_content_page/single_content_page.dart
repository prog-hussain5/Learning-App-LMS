

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:webinar/app/models/content_model.dart';
import 'package:webinar/app/models/note_model.dart';
import 'package:webinar/app/models/single_content_model.dart';
import 'package:webinar/app/pages/main_page/home_page/single_course_page/single_content_page/pdf_viewer_page.dart';
import 'package:webinar/app/pages/main_page/home_page/single_course_page/single_content_page/web_view_page.dart';
import 'package:webinar/app/services/guest_service/course_service.dart';
import 'package:webinar/app/services/user_service/personal_note_service.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/data/api_public_data.dart';
import 'package:webinar/common/data/app_data.dart';
import 'package:webinar/common/enums/error_enum.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/common/utils/constants.dart';
import 'package:webinar/config/colors.dart';import 'package:webinar/config/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../../common/utils/date_formater.dart';
import '../../../../../../config/assets.dart';
import '../../../../../widgets/main_widget/home_widget/single_course_widget/course_video_player.dart';
import '../../../../../widgets/main_widget/home_widget/single_course_widget/pod_video_player.dart';
import '../../../../../widgets/main_widget/home_widget/single_course_widget/single_course_widget.dart';

class SingleContentPage extends StatefulWidget {
  static const String pageName = '/single-content';
  const SingleContentPage({super.key});

  @override
  State<SingleContentPage> createState() => _SingleContentPageState();
}

class _SingleContentPageState extends State<SingleContentPage> {

  List<String> videoFormats = ['mp4', 'mkv', 'mov', 'wmv', 'avi', 'webm', 'video'];

  NoteModel? note;

  ContentItem? content;
  SingleContentModel? singleContentData; 
  int? courseId;

  bool isLoading = true;
  bool hasError = false;
  bool isSpeakLoading = false;
  bool isPlayingText = false;
  bool authHasBought = true;

  String? previousContentLink;
  SingleContentModel? previousContentData; 


  bool isDripContent = false;

  String token = '';

  @override
  void initState() {
    super.initState();

    AppData.getAccessToken().then((data){
      token = data;
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // ponytail: malformed/missing route args must show the retry state, not crash
      // into a permanent spinner.
      final rawArgs = ModalRoute.of(context)?.settings.arguments;
      if(rawArgs is! List || rawArgs.length < 2){
        setState(() {
          isLoading = false;
          hasError = true;
        });
        return;
      }

      content = rawArgs[0];
      courseId = rawArgs[1];

      try{
        previousContentLink = rawArgs[2];
      }catch(_){}

      try{
        authHasBought = rawArgs[3] ?? true;
      }catch(_){}

      _runLoad();

    });
  }

  void _runLoad(){
    Future.wait([getData(), getPreviousData()]).then((value){

      if(previousContentData != null){
        if(singleContentData?.checkPreviousParts == 1 && ( !(previousContentData?.authHasRead ?? true) || !(previousContentData?.passed ?? true) || (previousContentData?.assignmentStatus != 'passed') ) ){
          isDripContent = true;
        }
      }

      if(!mounted) return;
      setState(() {
        hasError = singleContentData == null;  // ponytail: content failed to load
        isLoading = false;
      });
    }).catchError((e){
      if(!mounted) return;
      setState(() {
        hasError = true;
        isLoading = false;  // ponytail: never leave the spinner stuck on a failure
      });
    });
  }

  void _retry(){
    setState(() {
      isLoading = true;
      hasError = false;
    });
    _runLoad();
  }

  Future getNote() async {
    // ponytail: content fetch may have failed (singleContentData == null). Force-unwrapping
    // here used to throw, which prevented isLoading from ever clearing -> spinner forever.
    if(content?.id == null || singleContentData?.contentType == null) return;

    note = await PersonalNoteService.getNote(content!.id!, singleContentData!.contentType!);

    if(mounted) setState(() {});

  }

  Future getData() async {
    
    setState(() {
      isLoading = true;
    });
    
    print(content?.link ?? '');
    singleContentData = await CourseService.getSingleContent(content?.link ?? '');

    await getNote();

  }

  Future getPreviousData() async {
    
    if(previousContentLink == null){
      return;
    }

    previousContentData = await CourseService.getSingleContent(previousContentLink!);
  }

  @override
  Widget build(BuildContext context) {

    // print(content?.storage ?? '');
    // print(content?.downloadable == 1 || ( content?.type == 'file' && ([ 'upload_archive', 'external_link', 'google_drive', 'iframe', 'secure_host', 'upload' ].contains(content?.storage ?? '')) ));
    return directionality(
      child: Scaffold(
        
        appBar: appbar(title: appText.courseDetails),

        body: isLoading
      ? loading()
      : hasError
      ? _errorRetry()
      : Stack(
          children: [
            
            // details
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: padding(),
          
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    space(20),
                    
          
                    Text(
                      singleContentData?.title ?? '',
                      style: style16Bold(),
                    ),

                    if(content?.type == 'text_lesson')...{

                      space(12),

                      AspectRatio(
                        aspectRatio: 16/10,
                        child: ClipRRect(
                          borderRadius: borderRadius(),
                          child: fadeInImage('${Constants.dommain}${singleContentData?.image}', getSize().width, getSize().width)
                        ),
                      ),

                    },

                    if(isDripContent)...{

                      space(20),

                      Container(
                        width: getSize().width,
                        padding: padding(vertical: 20,horizontal: 10),
                        
                        decoration: BoxDecoration(
                          borderRadius: borderRadius(),
                          border: Border.all(
                            color: greyE7
                          )
                        ),

                        child: Column(
                          children: [

                            SvgPicture.asset(
                              AppAssets.accessDeniedSvg
                            ),

                            Text(
                              appText.accessDenied,
                              style: style16Bold().copyWith(color: grey33),
                            ),

                            space(8),

                            Text(
                              appText.accessDeniedDesc,
                              style: style14Regular().copyWith(color: greyA5),
                              textAlign: TextAlign.center,
                            ),

                            
                          ],
                        ),
                      )

                    }else...{

                      if( (singleContentData?.storage == 'upload' || singleContentData?.storage == 'external_link' || singleContentData?.storage == 's3') && videoFormats.contains(singleContentData?.fileType?.toLowerCase()) )...{
                        space(20),
            
                        CourseVideoPlayer(singleContentData?.file ?? '', '', Constants.contentRouteObserver),
                      },

                      if( singleContentData?.storage == 'youtube' )...{

                        PodVideoPlayerDev(
                          singleContentData?.file ?? '',
                          singleContentData?.storage ?? '',
                          Constants.contentRouteObserver,
                          ValueKey(singleContentData?.id)
                        )
                      },

                      
            
                    },
          
                    
                    space(20),
          
                    // info   
                    Container(
                      padding: padding(),
                      width: getSize().width,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        
                        runSpacing: 21,
                        children: [
                    
                          SingleCourseWidget.courseStatus(
                            appText.type, 
                            content?.type == 'file'
                              ? singleContentData?.fileType?.toString().toUpperCase() ?? ''
                              : content?.type == 'session' 
                                ? singleContentData?.sessionApi?.toString() ?? ''
                                : appText.text_lesson, 
                            AppAssets.documentSvg,
                            width: getSize().width * .38
                          ),
                    
                          if(singleContentData?.date != null)...{
                            SingleCourseWidget.courseStatus(
                              appText.startDate, 
                              timeStampToDate((singleContentData?.date ?? 0) * 1000).toString(), 
                              AppAssets.calendarSvg,
                              width: getSize().width * .38
                            ),
                          },
                          
                    
                          if(singleContentData?.volume != null)...{
                            SingleCourseWidget.courseStatus(
                              appText.volume, 
                              singleContentData?.volume ?? '', 
                              AppAssets.paperDownloadSvg,
                              width: getSize().width * .38
                            ),
                          },
                          
                          if(singleContentData?.createdAt != null)...{
                            SingleCourseWidget.courseStatus(
                              appText.publishDate, 
                              timeStampToDate((singleContentData?.createdAt ?? 0) * 1000).toString(), 
                              AppAssets.calendarSvg,
                              width: getSize().width * .38
                            ),
                          },
                          
                          if(singleContentData?.duration != null)...{
                            SingleCourseWidget.courseStatus(
                              appText.duration, 
                              '${(singleContentData?.duration ?? 0)} ${appText.min}', 
                              AppAssets.timeSvg,
                              width: getSize().width * .38
                            ),
                          },
                          
                          SingleCourseWidget.courseStatus(
                            appText.downloadable, 
                            content?.downloadable == 1 ? appText.yes : appText.no, 
                            AppAssets.paperDownloadSvg,
                            width: getSize().width * .38
                          ),
                          
                          
                          // SingleCourseWidget.courseStatus(
                          //   appText.type, 
                          //   courseData.type ?? '', 
                          //   AppAssets.moreSvg,
                          //   width: getSize().width * .38
                          // ),
                          
                          // SingleCourseWidget.courseStatus(
                          //   appText.status, 
                          //   courseData.status ?? '', 
                          //   AppAssets.moreSvg,
                          //   width: getSize().width * .38
                          // ),
                    
                        ],  
                      ),
                    ),
          

                    if(content?.type == 'text_lesson')...{
                      
                      space(20),
          
                      HtmlWidget(
                        singleContentData?.content ?? '',
                        textStyle: style14Regular(),
                      ),
                    }else...{
                      
                      space(20),
                      
                      Text(
                        singleContentData?.description ?? '',
                        style: style14Regular(),
                      ),
                    },
          
                    space(20),

                    

                    if(authHasBought)...{
                      if(!isDripContent)...{
                        if(token.isNotEmpty)...{

                          // toggle 
                          SizedBox(
                            width: getSize().width,
                            child: switchButton(appText.iHaveReadThisLesson, content?.authHasRead ?? false, (value) {
                              
                              setState(() {
                                content?.authHasRead = value;  
                              });

                              CourseService.toggle(
                                courseId!, 
                                content!.type == 'text_lesson'
                                  ? 'text_lesson_id'
                                  : content!.type == 'file'
                                    ? 'file_id'
                                    : 'session_id', 
                                singleContentData!.id.toString(), 
                                value
                              );

                            }),
                          ),

                          space(20),
                        }

                      },
                      
                      if(PublicData.apiConfigData?['course_notes_status'] == '1')...{
                        // add note
                        Row(
                          children: [
                            
                            // add a note
                            Expanded(
                              child: button(
                                onTap: () async {
                                  
                                  if(note == null){
                                    bool? res = await SingleCourseWidget.showAddNoteDialog(
                                      courseId!, 
                                      singleContentData!.id!,
                                      singleContentData!.contentType!,
                                      text: note?.note
                                    );

                                    if(res ?? false){
                                      getNote();
                                    }
                                  }else{

                                    SingleCourseWidget.viewNoteDialog(
                                      courseId!, 
                                      singleContentData!.id!,
                                      note?.note ?? '',

                                      () async { // onTapEdit
                                        backRoute();

                                        bool? res = await SingleCourseWidget.showAddNoteDialog(
                                          courseId!, 
                                          singleContentData!.id!,
                                          singleContentData!.contentType!,
                                          text: note?.note
                                        );

                                        if(res ?? false){
                                          getNote();
                                        }

                                      }, 
                                      
                                      (){ // onTapAttachment
                                        backRoute();

                                        SingleCourseWidget.showNoteAttachmentDialog(
                                          (){ // onTapRemove
                                          }, 
                                          (){ // onTapDownload
                                            downloadSheet(note!.attachment!, note!.attachment!.split('/').last);
                                          }, 
                                          note?.attachment != null // hasFileForDownload
                                        );
                                        
                                      },

                                      note?.attachment != null,
                                    );
                                  }

                                }, 
                                width: getSize().width, 
                                height: 52, 
                                text: note == null ? appText.addANote : appText.viewNote, 
                                bgColor: whiteFF_26, 
                                textColor: green77(),
                                borderColor: green77(),
                                raduis: 15
                              )
                            ),

                            if(note != null)...{
                              space(0,width: 16),

                              button(
                                onTap: (){
                                  PersonalNoteService.delete(note!.id!);
                                  note = null;
                                  setState(() {});
                                }, 
                                width: 52, 
                                height: 52, 
                                text: '', 
                                bgColor: Colors.transparent, 
                                textColor: Colors.white,
                                borderColor: red49,
                                iconPath: AppAssets.delete2Svg,
                                iconColor: red49,
                                raduis: 20
                              )
                            }

                          ],
                        ),
                        
                      },
                    },

                    if( singleContentData?.storage == 'vimeo' && authHasBought )...{
                      
                      space(12),
                      
                      button(
                        onTap: (){
                          nextRoute(
                            WebViewPage.pageName, 
                            arguments: [
                              singleContentData?.webLink ?? '', 
                              singleContentData?.title ?? '',
                              true,
                              LoadRequestMethod.get
                            ]
                          );
                        }, 
                        width: getSize().width, 
                        height: 50, 
                        text: appText.view, 
                        bgColor: green77(), 
                        textColor: Colors.white,
                        raduis: 16
                      ),
                      
                    },

                    space(14),

                    // attachments
                    if(singleContentData?.attachments?.isNotEmpty ?? false)...{
                      
                      SizedBox(
                        width: getSize().width,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...List.generate(singleContentData?.attachments?.length ?? 0, (index) {
                                return horizontalChapterItem(
                                  green50,
                                  AppAssets.paperDownloadSvg,

                                  singleContentData?.attachments?[index].title ?? '', 

                                  singleContentData?.attachments?[index].volume ?? '',

                                  (){
                                    // ponytail: use the ATTACHMENT's own id (was content?.id, so
                                    // every attachment downloaded the same parent file), and give
                                    // the file a real name fallback instead of ''.
                                    final att = singleContentData?.attachments?[index];
                                    final attName = (att?.file?.split('/').last ?? '').trim();
                                    downloadSheet(
                                      '${Constants.baseUrl}files/${att?.id ?? content?.id}/download',
                                      attName.isNotEmpty
                                        ? attName
                                        : '${(att?.title ?? 'attachment').replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')}'
                                          '${(att?.fileType ?? '').isNotEmpty ? '.${att!.fileType}' : ''}'
                                    );
                                  },
                                );
                              })
                            ],
                          ),
                        ),
                      )

                    },
          
                    space(200),
          
                  ],
                ),
                
              ),
            ),


            // button
            if(!isDripContent)...{
              
              if(content?.fileType == 'pdf')...{
                pageButton(),

              }else if( content?.downloadable == 1 || ( content?.type == 'file' && ([ 'upload_archive', 'external_link', 'google_drive', 'iframe', 'secure_host',].contains(content?.storage ?? '')) ) ) ... {
                pageButton(
                  showViewButton: ([ 'upload_archive', 'external_link', 'google_drive', 'iframe', 'secure_host',].contains(content?.storage ?? ''))
                )
              
              }else if(content?.type != 'file') ...{
                pageButton(),
              }
            }

          ],
        ),
      )
    );
  }


  Widget _errorRetry(){
    return Center(
      child: Padding(
        padding: padding(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              appText.serverExceptionError,
              style: style14Regular().copyWith(color: greyA5),
              textAlign: TextAlign.center,
            ),
            space(16),
            button(
              onTap: _retry,
              width: 160,
              height: 48,
              text: appText.retry,
              bgColor: green77(),
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget pageButton({bool showViewButton=true}){

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      bottom: 0,
      child: Container(
        width: getSize().width,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 20
        ),

        decoration: BoxDecoration(
          color: whiteFF_26,
          boxShadow: [
            boxShadow(Colors.black.withOpacity(.1),blur: 15,y: -3)
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30))
        ),
        
        child: content?.type == 'file'
        
        ? Row(
            children: [
              
              // download
              if(content?.downloadable == 1)...{
                Expanded(
                  child: button(
                    onTap: (){

                      downloadSheet(
                        '${Constants.baseUrl}files/${content?.id}/download',
                        singleContentData?.file?.split('/').last ?? '${singleContentData?.title}.${singleContentData?.fileType}'
                      );

                    },
                    width: getSize().width, 
                    height: 52, 
                    text: appText.download, 
                    bgColor: green77(), 
                    textColor: Colors.white
                  ),
                ),

                if(showViewButton)...{
                  space(0,width: 16),
                }
              },

              // view
              if(showViewButton)...{
                  Expanded(
                    child: button(
                      onTap: (){
                  
                        // print(singleContentData?.storage);
                        // print(singleContentData?.fileType);
                        // print(singleContentData?.downloadLink);

                        if(singleContentData?.fileType == 'pdf'){
                          nextRoute(
                            PdfViewerPage.pageName, 
                            arguments: [
                              singleContentData?.file,
                              singleContentData?.title,
                            ]
                          );
                          return;
                        }

                        // String url = '${Constants.baseUrl}panel/files/${singleContentData?.id}';
                        // print('${Constants.baseUrl}panel/files/${singleContentData?.id}');

                        switch (singleContentData?.storage ?? '') {
                          case 'upload':
                          case 'upload_archive':
                          case 'external_link':
                          case 'google_drive':
                          case 'iframe':
                          case 'secure_host':
                            
                            nextRoute(
                              WebViewPage.pageName, 
                              arguments: [
                                singleContentData?.file, 
                                singleContentData?.title,
                                true,
                                LoadRequestMethod.get
                              ]
                            );
                            return;

                          case 's3': {
                            if(singleContentData?.fileType != 'video'){
                              nextRoute(
                                WebViewPage.pageName, 
                                arguments: [
                                  singleContentData?.file, 
                                  singleContentData?.title,
                                  singleContentData?.fileType == 'pdf' ? false : true, // if pdf file. Authorization token not be sent
                                  LoadRequestMethod.get
                                ]
                              );
                              return;
                            }
                          }
                            
                          default:
                        }

                        showSnackBar(ErrorEnum.alert, appText.noContentForShow);
                  
                      },
                      width: getSize().width, 
                      height: 52, 
                      text: buttonText(singleContentData?.storage ?? '', singleContentData?.fileType ?? ''), 
                      bgColor: green77(), 
                      textColor: Colors.white
                    ),
                  ),
            
              }
            
            ],
          )
        : content?.type == 'text_lesson'

          ? button(
              onTap: (){
                backRoute();
              }, 
              width: getSize().width, 
              height: 52, 
              text: appText.back, 
              bgColor: green77(), 
              textColor: Colors.white
            )
          
          : Row( // session
              children: [
                
                // join
                Expanded(
                  child: button(
                    onTap: () async {
                      if(!(singleContentData?.isFinished ?? false)){
                        
                        if(singleContentData?.sessionApi == 'agora'){

                          nextRoute(
                            WebViewPage.pageName, 
                            arguments: [ 
                              '${Constants.baseUrl}panel/webinars/session/agora/${singleContentData?.id ?? ''}' , 
                              singleContentData?.title ?? '',
                              true,
                              LoadRequestMethod.get
                            ]
                          );
                        }else{
                          
                          
                          nextRoute(
                            WebViewPage.pageName, 
                            arguments: [
                              singleContentData?.joinLink ?? '', 
                              '',
                              true,
                              LoadRequestMethod.get
                            ]
                          );
                        }

                      }
                    },
                    width: getSize().width, 
                    height: 52, 
                    text: appText.join, 
                    bgColor: (singleContentData?.isFinished ?? false) ? greyCF.withOpacity(.8) : green77(), 
                    textColor: Colors.white
                  )
                ),

                space(0,width: 16),
                
                // join
                Expanded(
                  child: button(
                    onTap: (){
                      try{
                        if(!(singleContentData?.isFinished ?? false)){

                          DateTime start = DateTime(
                            DateTime.fromMillisecondsSinceEpoch((singleContentData?.date ?? 0) * 1000, isUtc: true).year,
                            DateTime.fromMillisecondsSinceEpoch((singleContentData?.date ?? 0) * 1000, isUtc: true).month,
                            DateTime.fromMillisecondsSinceEpoch((singleContentData?.date ?? 0) * 1000, isUtc: true).day,
                            DateTime.fromMillisecondsSinceEpoch((singleContentData?.date ?? 0) * 1000, isUtc: true).hour,
                            DateTime.fromMillisecondsSinceEpoch((singleContentData?.date ?? 0) * 1000, isUtc: true).minute,
                          );
                          DateTime end = DateTime(
                            DateTime.fromMillisecondsSinceEpoch((singleContentData?.date ?? 0) * 1000, isUtc: true).year,
                            DateTime.fromMillisecondsSinceEpoch((singleContentData?.date ?? 0) * 1000, isUtc: true).month,
                            DateTime.fromMillisecondsSinceEpoch((singleContentData?.date ?? 0) * 1000, isUtc: true).day,
                            DateTime.fromMillisecondsSinceEpoch((singleContentData?.date ?? 0) * 1000, isUtc: true).hour,
                            (DateTime.fromMillisecondsSinceEpoch((singleContentData?.date ?? 0) * 1000, isUtc: true).minute + (singleContentData?.duration ?? 0)),
                          );

                          final Event event = Event(
                            title: singleContentData?.title ?? '',
                            description: appText.webinar,
                            startDate: start,
                            endDate: end,
                            iosParams: const IOSParams(),
                            androidParams: const AndroidParams(),
                          );

                          Add2Calendar.addEvent2Cal(event);
                        }

                      }catch(_){}
                    }, 
                    width: getSize().width, 
                    height: 52, 
                    text: appText.addToCalendar, 
                    bgColor: whiteFF_26,
                    textColor: (singleContentData?.isFinished ?? false) ? greyCF : green77(),
                    borderColor: (singleContentData?.isFinished ?? false) ? greyCF.withOpacity(.8) : green77(), 

                  )
                ),
                
              ],
            ),
      )
    );
  }



  String buttonText(String storage,String fileType){

    switch (storage) {
      case 'upload_archive':
        return appText.view;
      
      case 'upload':
        return appText.view;

      default:
        return appText.view;
    }
  }

}