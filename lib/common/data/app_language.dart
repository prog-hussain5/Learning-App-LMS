import 'package:shared_preferences/shared_preferences.dart';

import '../../app/widgets/authentication_widget/country_code_widget/code_country.dart';
import '../../config/assets.dart';

class AppLanguage{
  
  late String currentLanguage;
  List<String> rtlLanguage = ['ar'];

  bool isRtl() => rtlLanguage.contains(currentLanguage.toLowerCase());

  List<CountryCode> appLanguagesData = [
    CountryCode(
      name: "English (US)",
      code: "EN",
      dialCode: '+1',
      flagUri: '${AppAssets.flags}${"en".toLowerCase()}.png',
    ),
    
    CountryCode(
      name: "Arabic",
      code: "AR",
      dialCode: '+964',
      flagUri: '${AppAssets.flags}${"iq".toLowerCase()}.png',
    ),
  ];

  Future saveLanguage(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', data);
    await getLanguage();
    return true;
  }

  Future getLanguage() async {    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // MODIFIED: Force Arabic language only (removed 'en' default)
    currentLanguage = prefs.getString('language') ?? 'ar';
    // Ensure Arabic is always set
    if (currentLanguage != 'ar') {
      currentLanguage = 'ar';
      await saveLanguage('ar');
    }
    return currentLanguage;
  }

}