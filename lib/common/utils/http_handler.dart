import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:webinar/app/pages/introduction_page/ip_empty_state_page.dart';
import 'package:webinar/app/pages/introduction_page/maintenance_page.dart';
import 'package:webinar/common/data/app_language.dart';
import 'package:webinar/common/utils/constants.dart';

import '../../app/pages/authentication_page/login_page.dart';
import '../../locator.dart';
import '../common.dart';
import '../components.dart';
import '../data/app_data.dart';
import '../enums/error_enum.dart';
import 'app_text.dart';


// ponytail: one place to make transient network failures visible instead of letting
// each service silently swallow them into a blank screen. Debounced so a screen that
// fires several requests doesn't stack snackbars. Returns a non-throwing synthetic
// error response, so callers' jsonDecode succeeds and they take their success==false
// branch instead of throwing uncaught (which used to leave spinners stuck forever).
DateTime? _lastNetErrorAt;

void _notifyNetworkError() {
  final now = DateTime.now();
  if (_lastNetErrorAt == null || now.difference(_lastNetErrorAt!).inSeconds >= 4) {
    _lastNetErrorAt = now;
    try {
      showSnackBar(ErrorEnum.error, null, desc: appText.serverExceptionError);
    } catch (_) {}
  }
}

Future<http.Response> _safeSend(http.Request request) async {
  try {
    final streamed = await request.send().timeout(const Duration(seconds: 30));
    final body = await streamed.stream.bytesToString();
    return http.Response(body, streamed.statusCode, headers: streamed.headers);
  } catch (e) {
    _notifyNetworkError();
    return http.Response('{"success":false,"message":"network_error"}', 503);
  }
}


Future<Response> httpGet(String url,{Map<String, String> headers = const {},bool isRedirectingStatusCode=true, bool isMaintenance=false, bool isSendToken=false}) async {
  if(headers.isEmpty){

    String token = await AppData.getAccessToken();

    headers = {
      if(isSendToken)...{
        "Authorization": "Bearer $token",
      },
      "Content-Type" : "application/json", 
      'Accept' : 'application/json',
      'x-api-key' : Constants.apiKey,
      'x-locale' : locator<AppLanguage>().currentLanguage.toLowerCase(),
    };
  }
  var request = http.Request(
    'GET', 
    Uri.parse(url),
  );

  request.headers.addAll(headers);
  http.Response res = await _safeSend(request);


  // Check if response is HTML (possible server error or hack)
  if(res.body.trim().toLowerCase().startsWith('<!doctype') || 
     res.body.trim().toLowerCase().startsWith('<html')){
    print('❌ ERROR: Server returned HTML instead of JSON');
    print('Response preview: ${res.body.substring(0, res.body.length > 200 ? 200 : res.body.length)}...');
    return res;
  }

  // ip empty state
  try{
    var data = jsonDecode(res.body);
    if(data['status'] == 'restriction'){
      print(isNavigatedIpPage);
      if(!isNavigatedIpPage){
        nextRoute(IpEmptyStatePage.pageName, arguments: data['data'], isClearBackRoutes: true);
      }
      return res;
    }
  }catch(e){
    print('❌ JSON Decode Error: $e');
  }

  if (res.statusCode == 401) {
    // ponytail: honor isRedirectingStatusCode like the other verbs — a stray 401 on a
    // background/content GET should not force-logout and wipe the nav stack.
    if(isRedirectingStatusCode){
      nextRoute(
        LoginPage.pageName,
        isClearBackRoutes: true
      );
    }
    return res;
  } else {

    if(isMaintenance){
      // Maintenance
      try{ 
        if(jsonDecode(res.body)['status'] == 'maintenance'){
          nextRoute(MaintenancePage.pageName, isClearBackRoutes: true, arguments: jsonDecode(res.body)['data']);
        }
      }catch(_){}
    }

    return res;
  }
}

Future<Response> httpPost(String url, dynamic body,{Map<String, String> headers = const {},bool isRedirectingStatusCode=true}) async {
  
  var myBody = json.encode(body);
  
  if(headers.isEmpty){
    headers = {
      'x-api-key' : Constants.apiKey,
      'Content-Type' : 'application/json', 
      'Accept' : 'application/json',
      'x-locale' : locator<AppLanguage>().currentLanguage.toLowerCase(),
    };
  }

  var request = http.Request(
    'POST', 
    Uri.parse(url),
  );

  request.body = myBody;
  request.headers.addAll(headers);
  http.Response res = await _safeSend(request);

  if (res.statusCode == 401) {
    if(isRedirectingStatusCode){
      nextRoute(
        LoginPage.pageName,
        isClearBackRoutes: true
      );
    }
    return res;
  } else {
    return res;
  }
}

Future<Response> httpDelete(String url, dynamic body,{Map<String, String> headers = const {},bool isRedirectingStatusCode=true}) async {
  var myBody = json.encode(body);
  
  if(headers.isEmpty){
    headers = {
      'x-api-key' : Constants.apiKey,
      'Content-Type' : 'application/json', 
      'Accept' : 'application/json',
      'x-locale' : locator<AppLanguage>().currentLanguage.toLowerCase(),
    };
  }

  var request = http.Request(
    'DELETE', 
    Uri.parse(url),
  );

  request.body = myBody;
  request.headers.addAll(headers);
  http.Response res = await _safeSend(request);

  if (res.statusCode == 401) {
    if(isRedirectingStatusCode){
      nextRoute(
        LoginPage.pageName,
        isClearBackRoutes: true
      );
    }
    return res;
  } else {
    return res;
  }
}

Future<Response> httpPut(String url, dynamic body,{Map<String, String> headers = const {}, bool isRedirectingStatusCode=true}) async {
  var myBody;
  if (body.runtimeType != String) {
    myBody = json.encode(body);
  } else {
    myBody = body;
  }

  if(headers.isEmpty){
    headers = {"Content-Type" : "application/json",'Accept' : 'application/json','x-api-key' : Constants.apiKey, 'x-locale' : locator<AppLanguage>().currentLanguage.toLowerCase(),};
  }

  var request = http.Request(
    'PUT', 
    Uri.parse(url),
  );

  request.body = myBody;
  request.headers.addAll(headers);
  http.Response res = await _safeSend(request);

  if (res.statusCode == 401) {
    if(isRedirectingStatusCode){
      nextRoute(
        LoginPage.pageName,
        isClearBackRoutes: true
      );
    }
    return res;
  } else {
    return res;
  }
}

Future<Response> httpPostWithToken(dynamic url,dynamic body,{bool isRedirectingStatusCode=true}) async {
  String token = await AppData.getAccessToken();

  Map<String, String> headers = {
    "Authorization": "Bearer $token",
    "Content-Type" : "application/json", 
    'Accept' : 'application/json',
    'x-api-key' : Constants.apiKey,
    'x-locale' : locator<AppLanguage>().currentLanguage.toLowerCase(),
  };

  return httpPost(url, body, headers: headers, isRedirectingStatusCode: isRedirectingStatusCode);
}

Future<Response> httpDeleteWithToken(dynamic url,dynamic body,{bool isRedirectingStatusCode=true}) async {
  String token = await AppData.getAccessToken();

  Map<String, String> headers = {
    "Authorization": "Bearer $token",
    "Content-Type" : "application/json", 
    'Accept' : 'application/json',
    'x-api-key' : Constants.apiKey,
    'x-locale' : locator<AppLanguage>().currentLanguage.toLowerCase(),
  };

  return httpDelete(url, body, headers: headers, isRedirectingStatusCode: isRedirectingStatusCode);
}


Future<Response> httpPutWithToken(dynamic url, dynamic body,{bool isRedirectingStatusCode=true}) async {
  String token = await AppData.getAccessToken();

  Map<String, String> headers = {
    "Authorization": "Bearer $token",
    "content-type": "application/json",
    "Accept" : "application/json",
    'x-api-key' : Constants.apiKey,
    'x-locale' : locator<AppLanguage>().currentLanguage.toLowerCase(),
  };
  

  return httpPut(url, body, headers: headers, isRedirectingStatusCode: isRedirectingStatusCode);
}

Future<Response> httpGetWithToken(dynamic url,{bool isRedirectingStatusCode=true}) async {
  String token = await AppData.getAccessToken();
  print(token);
  Map<String, String> headers = {
    "Authorization": "Bearer $token",
    "Accept" : "application/json",
    'x-api-key' : Constants.apiKey,
    'x-locale' : locator<AppLanguage>().currentLanguage.toLowerCase(),
  };
  

  return httpGet(url, headers: headers,isRedirectingStatusCode: isRedirectingStatusCode);
}




Future<dio.Response> dioPost(String url, dynamic body,{Map<String, String> headers = const {},bool isRedirectingStatusCode=true}) async {
  
  // var myBody = body;
  // if(body.runtimeType is! dio.FormData){
  //   // try{
  //   //   myBody = json.encode(body);
  //   // }catch(e){}
  // }
  

  if(headers.isEmpty){
    headers = {
      "Content-Type" : "application/json", 
      'Accept' : 'application/json',
      'x-api-key' : Constants.apiKey,
      'x-locale' : locator<AppLanguage>().currentLanguage.toLowerCase(),
    };
  }
  
  var res = await locator<dio.Dio>().post(
    url, 
    data: body,
    options: dio.Options(
      headers: headers
    )
  ).timeout(const Duration(seconds: 30));

  // print(res.data.toString());
  // log(utf8.decode(res.bodyBytes));

  if (res.statusCode == 401) {
    if(isRedirectingStatusCode){
      nextRoute(
        LoginPage.pageName,
        isClearBackRoutes: true
      );
    }
    return res;
  } else {
    return res;
  }
}

Future<dio.Response> dioPostWithToken(dynamic url,dynamic body,{bool isRedirectingStatusCode=true}) async {
  String token = await AppData.getAccessToken();
  
  Map<String, String> headers = {
    "Authorization": "Bearer $token",
    "Content-Type" : "application/json", 
    'Accept' : 'application/json',
    'x-api-key' : Constants.apiKey,
    'x-locale' : locator<AppLanguage>().currentLanguage.toLowerCase(),
  };

  return dioPost(url, body, headers: headers, isRedirectingStatusCode: isRedirectingStatusCode);
}