import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/enums/error_enum.dart';
import 'package:webinar/locator.dart';

import '../data/app_data.dart';
import '../data/app_language.dart';
import 'constants.dart';

class DownloadManager{

  static List<FileSystemEntity> files = [];


  static Future<void> download(String url,Function(int progress) onDownlaod,{CancelToken? cancelToken,String? name,Function? onLoadAtLocal, bool isOpen=true}) async {

    // ponytail: no storage/photos permission needed — we write to the app's OWN
    // support directory. Requesting them auto-denies on Android 13+ and the old
    // `if(granted)` gate then aborted the download silently (nothing happened).
    {
      String directory = (await getApplicationSupportDirectory()).path;

      final String fileName = _safeName(name, url);

      if(! (await findFile(directory, fileName, onLoadAtLocal: onLoadAtLocal )) ){

        String token = await AppData.getAccessToken();

        Map<String, String> headers = {
          "Authorization": "Bearer $token",
          "Accept" : "application/json",
          'x-api-key' : Constants.apiKey,
          'x-locale' : locator<AppLanguage>().currentLanguage.toLowerCase(),
        };

        try{
          await locator<Dio>().download(
            url, 
            '$directory/$fileName',
            onReceiveProgress: (count, total) {
              onDownlaod((count / total * 100).toInt());
            },
            cancelToken: cancelToken,
            options: Options(
              followRedirects: true,
              headers: headers
            )
            
          ).then((value) {

            if(value.statusCode == 200){
              if(navigatorKey.currentContext!.mounted){
                backRoute(arguments: '$directory/$fileName');
              }

              if(isOpen){
                OpenFile.open('$directory/$fileName');
              }
            }

          });
        }on DioException catch (e) {
          showSnackBar(ErrorEnum.error, e.message);
        }


      } 
    }
    

  }

  // ponytail: never return an empty/degenerate file name — `path.contains('')` is
  // always true, which made findFile open an arbitrary cached file.
  static String _safeName(String? name, String url){
    final n = (name ?? '').trim();
    if(n.isNotEmpty && n != 'null' && n != 'null.null') return n;

    final fromUrl = Uri.tryParse(url)?.pathSegments.where((s) => s.isNotEmpty).lastOrNull ?? '';
    if(fromUrl.isNotEmpty) return fromUrl;

    return 'download_${url.hashCode.toUnsigned(32)}';
  }

  static Future<bool> findFile(String directory, String name,{Function? onLoadAtLocal, bool isOpen=true}) async {
    bool state=false;

    // ponytail: an empty name must never match everything
    if(name.trim().isEmpty) return false;

    files = Directory(directory).listSync().toList();

    for (var i = 0; i < files.length; i++) {
      // ponytail: exact file-name match (was `contains`, which matched partial/unrelated files)
      if(files[i].path.split(Platform.pathSeparator).last == name){

        if(onLoadAtLocal != null){
          onLoadAtLocal();
        }

        if(isOpen){
          OpenFile.open(files[i].path);
        }
        return true;
      }
    }

    return state;
  }
}