import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @webinar.
  ///
  /// In en, this message translates to:
  /// **'Balsam Medical Academy'**
  String get webinar;

  /// No description provided for @splashDesc.
  ///
  /// In en, this message translates to:
  /// **'The easiest way for learning...'**
  String get splashDesc;

  /// No description provided for @introTitle1.
  ///
  /// In en, this message translates to:
  /// **'Start learning now!'**
  String get introTitle1;

  /// No description provided for @introTitle2.
  ///
  /// In en, this message translates to:
  /// **'Book a meeting...'**
  String get introTitle2;

  /// No description provided for @introTitle3.
  ///
  /// In en, this message translates to:
  /// **'Teach your skills!'**
  String get introTitle3;

  /// No description provided for @introTitle4.
  ///
  /// In en, this message translates to:
  /// **'Start learning now'**
  String get introTitle4;

  /// No description provided for @introDesc1.
  ///
  /// In en, this message translates to:
  /// **'Interested in to learn from the best teachers around the world?'**
  String get introDesc1;

  /// No description provided for @introDesc2.
  ///
  /// In en, this message translates to:
  /// **'Looking for a private teacher? Book a private meeting now!'**
  String get introDesc2;

  /// No description provided for @introDesc3.
  ///
  /// In en, this message translates to:
  /// **'Start teaching right now and share your valuable knowledge.'**
  String get introDesc3;

  /// No description provided for @introDesc4.
  ///
  /// In en, this message translates to:
  /// **'Start learning from the best instructors in different topics.'**
  String get introDesc4;

  /// No description provided for @getStart.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStart;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// No description provided for @skipLogin.
  ///
  /// In en, this message translates to:
  /// **'Skip Login'**
  String get skipLogin;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an Account'**
  String get createAccount;

  /// No description provided for @createAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Join us now and start learning and teaching'**
  String get createAccountDesc;

  /// No description provided for @yourEmail.
  ///
  /// In en, this message translates to:
  /// **'Your Email'**
  String get yourEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @retypePassword.
  ///
  /// In en, this message translates to:
  /// **'Retype Password'**
  String get retypePassword;

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an Account'**
  String get createAnAccount;

  /// No description provided for @termsPoliciesDesc.
  ///
  /// In en, this message translates to:
  /// **'By using our services,  you are agreeing to our\nTerms & Policies. '**
  String get termsPoliciesDesc;

  /// No description provided for @haveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Have an account?'**
  String get haveAnAccount;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @welcomeBackDesc.
  ///
  /// In en, this message translates to:
  /// **'Login to your account and enjoy learning...'**
  String get welcomeBackDesc;

  /// No description provided for @emailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Email or Phone'**
  String get emailOrPhone;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forgetPassword;

  /// No description provided for @forgetPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Don\'t be worried, your password will reset.'**
  String get forgetPasswordDesc;

  /// No description provided for @haventReceiveTheCode.
  ///
  /// In en, this message translates to:
  /// **'Havent receive the code?'**
  String get haventReceiveTheCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend the Code'**
  String get resendCode;

  /// No description provided for @verifyMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Verify my Account'**
  String get verifyMyAccount;

  /// No description provided for @accountVerification.
  ///
  /// In en, this message translates to:
  /// **'Account Verification'**
  String get accountVerification;

  /// No description provided for @accountVerificationDesc.
  ///
  /// In en, this message translates to:
  /// **'Insert the verification code that sent to you...'**
  String get accountVerificationDesc;

  /// No description provided for @selectlanguage.
  ///
  /// In en, this message translates to:
  /// **'Select a Language'**
  String get selectlanguage;

  /// No description provided for @searchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search for a country or language'**
  String get searchCountry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @classes.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get classes;

  /// No description provided for @meetings.
  ///
  /// In en, this message translates to:
  /// **'Meetings'**
  String get meetings;

  /// No description provided for @assignments.
  ///
  /// In en, this message translates to:
  /// **'Assignments'**
  String get assignments;

  /// No description provided for @quizzes.
  ///
  /// In en, this message translates to:
  /// **'Quizzes'**
  String get quizzes;

  /// No description provided for @certificates.
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get certificates;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @financial.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get financial;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi, '**
  String get hi;

  /// No description provided for @letsStartLearning.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start learning!'**
  String get letsStartLearning;

  /// No description provided for @searchInputDesc.
  ///
  /// In en, this message translates to:
  /// **'What are you going to find?'**
  String get searchInputDesc;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @featuredClasses.
  ///
  /// In en, this message translates to:
  /// **'Featured Classes'**
  String get featuredClasses;

  /// No description provided for @newestClasses.
  ///
  /// In en, this message translates to:
  /// **'Newest Classes'**
  String get newestClasses;

  /// No description provided for @bestRated.
  ///
  /// In en, this message translates to:
  /// **'Best Rated'**
  String get bestRated;

  /// No description provided for @bestSelling.
  ///
  /// In en, this message translates to:
  /// **'Best Selling'**
  String get bestSelling;

  /// No description provided for @discountedClasses.
  ///
  /// In en, this message translates to:
  /// **'Discounted Classes'**
  String get discountedClasses;

  /// No description provided for @freeClasses.
  ///
  /// In en, this message translates to:
  /// **'Free Classes'**
  String get freeClasses;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// No description provided for @notConducted.
  ///
  /// In en, this message translates to:
  /// **'Not Conducted'**
  String get notConducted;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @liveClass.
  ///
  /// In en, this message translates to:
  /// **'Live Class'**
  String get liveClass;

  /// No description provided for @course.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get course;

  /// No description provided for @textClass.
  ///
  /// In en, this message translates to:
  /// **'Text Course'**
  String get textClass;

  /// No description provided for @featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @providers.
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get providers;

  /// No description provided for @blog.
  ///
  /// In en, this message translates to:
  /// **'Blog'**
  String get blog;

  /// No description provided for @myClassess.
  ///
  /// In en, this message translates to:
  /// **'My Classes'**
  String get myClassess;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @refCode.
  ///
  /// In en, this message translates to:
  /// **'Referral Code'**
  String get refCode;

  /// No description provided for @continue_.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// No description provided for @finalizeYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Finalize your account'**
  String get finalizeYourAccount;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trending;

  /// No description provided for @browseCategories.
  ///
  /// In en, this message translates to:
  /// **'Browse Categories'**
  String get browseCategories;

  /// No description provided for @courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @dataNotFound.
  ///
  /// In en, this message translates to:
  /// **'Data not found...'**
  String get dataNotFound;

  /// No description provided for @dataNotFoundDesc.
  ///
  /// In en, this message translates to:
  /// **'The page does not have any data to display'**
  String get dataNotFoundDesc;

  /// No description provided for @upcomingClasses.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Classes'**
  String get upcomingClasses;

  /// No description provided for @downloadableContent.
  ///
  /// In en, this message translates to:
  /// **'Downloadable Content'**
  String get downloadableContent;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @newest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newest;

  /// No description provided for @highestPrice.
  ///
  /// In en, this message translates to:
  /// **'Highest Price'**
  String get highestPrice;

  /// No description provided for @lowestPrice.
  ///
  /// In en, this message translates to:
  /// **'Lowest Price'**
  String get lowestPrice;

  /// No description provided for @bestSellers.
  ///
  /// In en, this message translates to:
  /// **'Best Sellers'**
  String get bestSellers;

  /// No description provided for @applyOptions.
  ///
  /// In en, this message translates to:
  /// **'Apply Options'**
  String get applyOptions;

  /// No description provided for @filterItems.
  ///
  /// In en, this message translates to:
  /// **'Filter Items'**
  String get filterItems;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchResultDesc.
  ///
  /// In en, this message translates to:
  /// **' Results found for '**
  String get searchResultDesc;

  /// No description provided for @suggestedRandom.
  ///
  /// In en, this message translates to:
  /// **'Suggested (Random)'**
  String get suggestedRandom;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @organizations.
  ///
  /// In en, this message translates to:
  /// **'Organizations'**
  String get organizations;

  /// No description provided for @resultNotFound.
  ///
  /// In en, this message translates to:
  /// **'Result not found...'**
  String get resultNotFound;

  /// No description provided for @tryMoreAccurateWordsToReachResults.
  ///
  /// In en, this message translates to:
  /// **'Please use clearer words for improved results'**
  String get tryMoreAccurateWordsToReachResults;

  /// No description provided for @instrcutors.
  ///
  /// In en, this message translates to:
  /// **'Instructors'**
  String get instrcutors;

  /// No description provided for @consultants.
  ///
  /// In en, this message translates to:
  /// **'Consultants'**
  String get consultants;

  /// No description provided for @noInstructor.
  ///
  /// In en, this message translates to:
  /// **'No Instructor'**
  String get noInstructor;

  /// No description provided for @noInstructorDesc.
  ///
  /// In en, this message translates to:
  /// **'There are no instructors available in this app'**
  String get noInstructorDesc;

  /// No description provided for @noOrganization.
  ///
  /// In en, this message translates to:
  /// **'No Organization'**
  String get noOrganization;

  /// No description provided for @noOrganizationDesc.
  ///
  /// In en, this message translates to:
  /// **'There are no organizations available in this app'**
  String get noOrganizationDesc;

  /// No description provided for @noConsultants.
  ///
  /// In en, this message translates to:
  /// **'No Consultants'**
  String get noConsultants;

  /// No description provided for @noConsultantsDesc.
  ///
  /// In en, this message translates to:
  /// **'There are no consultants available in this app'**
  String get noConsultantsDesc;

  /// No description provided for @availableForMeetings.
  ///
  /// In en, this message translates to:
  /// **'Available for meetings'**
  String get availableForMeetings;

  /// No description provided for @blogPost.
  ///
  /// In en, this message translates to:
  /// **'Blog Post'**
  String get blogPost;

  /// No description provided for @leaveAComment.
  ///
  /// In en, this message translates to:
  /// **'Leave a Comment'**
  String get leaveAComment;

  /// No description provided for @submitComment.
  ///
  /// In en, this message translates to:
  /// **'Submit Comment'**
  String get submitComment;

  /// No description provided for @submitCommentDesc.
  ///
  /// In en, this message translates to:
  /// **'Regarding to my experience, this mentor is one of the best mentors in the world.'**
  String get submitCommentDesc;

  /// No description provided for @commentOptions.
  ///
  /// In en, this message translates to:
  /// **'Comment Options'**
  String get commentOptions;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @replyToComment.
  ///
  /// In en, this message translates to:
  /// **'Reply to Comment'**
  String get replyToComment;

  /// No description provided for @selectReportReason.
  ///
  /// In en, this message translates to:
  /// **'Select a Reason'**
  String get selectReportReason;

  /// No description provided for @messageToReviewer.
  ///
  /// In en, this message translates to:
  /// **'Message to Reviewer'**
  String get messageToReviewer;

  /// No description provided for @in_.
  ///
  /// In en, this message translates to:
  /// **' in '**
  String get in_;

  /// No description provided for @blogCategories.
  ///
  /// In en, this message translates to:
  /// **'Blog Categories'**
  String get blogCategories;

  /// No description provided for @noComments.
  ///
  /// In en, this message translates to:
  /// **'No Comments!'**
  String get noComments;

  /// No description provided for @noCommentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Leave the first comment for this post'**
  String get noCommentsDesc;

  /// No description provided for @noBlogPosts.
  ///
  /// In en, this message translates to:
  /// **'No Blog Posts!'**
  String get noBlogPosts;

  /// No description provided for @noBlogPostsDesc.
  ///
  /// In en, this message translates to:
  /// **'There are no blog posts available in this app'**
  String get noBlogPostsDesc;

  /// No description provided for @selectACurrency.
  ///
  /// In en, this message translates to:
  /// **'Select a Currency'**
  String get selectACurrency;

  /// No description provided for @courseDetails.
  ///
  /// In en, this message translates to:
  /// **'Course Details'**
  String get courseDetails;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @enrollOnClass.
  ///
  /// In en, this message translates to:
  /// **'Enroll on Course'**
  String get enrollOnClass;

  /// No description provided for @certificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get certificate;

  /// No description provided for @included.
  ///
  /// In en, this message translates to:
  /// **'Included'**
  String get included;

  /// No description provided for @quiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quiz;

  /// No description provided for @supported.
  ///
  /// In en, this message translates to:
  /// **'Supported'**
  String get supported;

  /// No description provided for @class_.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get class_;

  /// No description provided for @specialOffer.
  ///
  /// In en, this message translates to:
  /// **'Special\nOffer'**
  String get specialOffer;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @hr.
  ///
  /// In en, this message translates to:
  /// **'Hr'**
  String get hr;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// No description provided for @sec.
  ///
  /// In en, this message translates to:
  /// **'Sec'**
  String get sec;

  /// No description provided for @students.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get students;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @prerequisties.
  ///
  /// In en, this message translates to:
  /// **'Prerequisties'**
  String get prerequisties;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @selectPricingPlan.
  ///
  /// In en, this message translates to:
  /// **'Select a pricing plan'**
  String get selectPricingPlan;

  /// No description provided for @classOptions.
  ///
  /// In en, this message translates to:
  /// **'Class Options'**
  String get classOptions;

  /// No description provided for @addToCalendar.
  ///
  /// In en, this message translates to:
  /// **'Add to Calendar'**
  String get addToCalendar;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @viewMore.
  ///
  /// In en, this message translates to:
  /// **'View More'**
  String get viewMore;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @downloadable.
  ///
  /// In en, this message translates to:
  /// **'Downloadable'**
  String get downloadable;

  /// No description provided for @questions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get questions;

  /// No description provided for @contentQuality.
  ///
  /// In en, this message translates to:
  /// **'Content Quality'**
  String get contentQuality;

  /// No description provided for @instructorSkills.
  ///
  /// In en, this message translates to:
  /// **'Instructor Skills'**
  String get instructorSkills;

  /// No description provided for @purchaseWorth.
  ///
  /// In en, this message translates to:
  /// **'Purchase Worth'**
  String get purchaseWorth;

  /// No description provided for @supportQuality.
  ///
  /// In en, this message translates to:
  /// **'Support Quality'**
  String get supportQuality;

  /// No description provided for @noReviews.
  ///
  /// In en, this message translates to:
  /// **'No Reviews!'**
  String get noReviews;

  /// No description provided for @noReviewsDesc.
  ///
  /// In en, this message translates to:
  /// **'There is no review for this course'**
  String get noReviewsDesc;

  /// No description provided for @noCommentsCourseDesc.
  ///
  /// In en, this message translates to:
  /// **'There is no comment for this course'**
  String get noCommentsCourseDesc;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @reviewTheCourse.
  ///
  /// In en, this message translates to:
  /// **'Review the Course'**
  String get reviewTheCourse;

  /// No description provided for @reviewTheCourseDesc.
  ///
  /// In en, this message translates to:
  /// **'Rate the course as stars then write your comment'**
  String get reviewTheCourseDesc;

  /// No description provided for @writeReview.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get writeReview;

  /// No description provided for @writeReviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Regarding to my experience, this mentor is one of the best mentors around the world.'**
  String get writeReviewDesc;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @goToLearningPage.
  ///
  /// In en, this message translates to:
  /// **'Go to learning page'**
  String get goToLearningPage;

  /// No description provided for @lessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessons;

  /// No description provided for @buyWithPoints.
  ///
  /// In en, this message translates to:
  /// **'Buy with Points'**
  String get buyWithPoints;

  /// No description provided for @youHave.
  ///
  /// In en, this message translates to:
  /// **'You have'**
  String get youHave;

  /// No description provided for @rewardPoints.
  ///
  /// In en, this message translates to:
  /// **'reward points'**
  String get rewardPoints;

  /// No description provided for @purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// No description provided for @bundleCourse.
  ///
  /// In en, this message translates to:
  /// **'Course Bundle'**
  String get bundleCourse;

  /// No description provided for @notices.
  ///
  /// In en, this message translates to:
  /// **'Notices'**
  String get notices;

  /// No description provided for @postedBy.
  ///
  /// In en, this message translates to:
  /// **'Posted by'**
  String get postedBy;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @forum.
  ///
  /// In en, this message translates to:
  /// **'Forum'**
  String get forum;

  /// No description provided for @resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// No description provided for @openQuestions.
  ///
  /// In en, this message translates to:
  /// **'Open Questions'**
  String get openQuestions;

  /// No description provided for @answers.
  ///
  /// In en, this message translates to:
  /// **'Answers'**
  String get answers;

  /// No description provided for @activeUsers.
  ///
  /// In en, this message translates to:
  /// **'Active Users'**
  String get activeUsers;

  /// No description provided for @lastActivity.
  ///
  /// In en, this message translates to:
  /// **'Last Activity'**
  String get lastActivity;

  /// No description provided for @searchInCourseForum.
  ///
  /// In en, this message translates to:
  /// **'Search in the course forum'**
  String get searchInCourseForum;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get pin;

  /// No description provided for @unpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get unpin;

  /// No description provided for @resultsFoundFor.
  ///
  /// In en, this message translates to:
  /// **'Results found for'**
  String get resultsFoundFor;

  /// No description provided for @newQuestion.
  ///
  /// In en, this message translates to:
  /// **'New Question'**
  String get newQuestion;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @markAsResolved.
  ///
  /// In en, this message translates to:
  /// **'Mark as Resolved'**
  String get markAsResolved;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @replyToCourseForum.
  ///
  /// In en, this message translates to:
  /// **'Reply to course forum'**
  String get replyToCourseForum;

  /// No description provided for @noQuestion.
  ///
  /// In en, this message translates to:
  /// **'No Question!'**
  String get noQuestion;

  /// No description provided for @noQuestionDesc.
  ///
  /// In en, this message translates to:
  /// **'Ask a new question and communicate with other students...'**
  String get noQuestionDesc;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @addCoupon.
  ///
  /// In en, this message translates to:
  /// **'Add Coupon'**
  String get addCoupon;

  /// No description provided for @validate.
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get validate;

  /// No description provided for @startPayment.
  ///
  /// In en, this message translates to:
  /// **'Start Payment'**
  String get startPayment;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @successfulPayment.
  ///
  /// In en, this message translates to:
  /// **'Successful Payment'**
  String get successfulPayment;

  /// No description provided for @successfulPaymentDesc.
  ///
  /// In en, this message translates to:
  /// **'The payment was successful'**
  String get successfulPaymentDesc;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get paymentFailed;

  /// No description provided for @paymentFailedDesc.
  ///
  /// In en, this message translates to:
  /// **'The payment was not successful'**
  String get paymentFailedDesc;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @accountCharge.
  ///
  /// In en, this message translates to:
  /// **'Account Charge'**
  String get accountCharge;

  /// No description provided for @offlinePayment.
  ///
  /// In en, this message translates to:
  /// **'Offline Payment'**
  String get offlinePayment;

  /// No description provided for @userGroupDiscount.
  ///
  /// In en, this message translates to:
  /// **'User Group Discount'**
  String get userGroupDiscount;

  /// No description provided for @courseMaterialDetails.
  ///
  /// In en, this message translates to:
  /// **'Course Details'**
  String get courseMaterialDetails;

  /// No description provided for @volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// No description provided for @publishDate.
  ///
  /// In en, this message translates to:
  /// **'Publish Date'**
  String get publishDate;

  /// No description provided for @text_lesson.
  ///
  /// In en, this message translates to:
  /// **'Text Lesson'**
  String get text_lesson;

  /// No description provided for @iHaveReadThisLesson.
  ///
  /// In en, this message translates to:
  /// **'I have read this lesson'**
  String get iHaveReadThisLesson;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @thisSessionConductedOn.
  ///
  /// In en, this message translates to:
  /// **'This session conducted on'**
  String get thisSessionConductedOn;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access Denied!'**
  String get accessDenied;

  /// No description provided for @accessDeniedDesc.
  ///
  /// In en, this message translates to:
  /// **'You need to pass the previous part to access this part.'**
  String get accessDeniedDesc;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @noContentForShow.
  ///
  /// In en, this message translates to:
  /// **'There is no content to display'**
  String get noContentForShow;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No Notifications!'**
  String get noNotifications;

  /// No description provided for @noNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'You have no notifications...'**
  String get noNotificationsDesc;

  /// No description provided for @cartIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty!'**
  String get cartIsEmpty;

  /// No description provided for @cartIsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Add your favorite courses to cart.'**
  String get cartIsEmptyDesc;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @successAddToCartDesc.
  ///
  /// In en, this message translates to:
  /// **'Go to your cart to complete the order'**
  String get successAddToCartDesc;

  /// No description provided for @notAccessContent.
  ///
  /// In en, this message translates to:
  /// **'You do not have access to this content'**
  String get notAccessContent;

  /// No description provided for @offlinePaymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Offline Payment Details'**
  String get offlinePaymentDetails;

  /// No description provided for @selectBank.
  ///
  /// In en, this message translates to:
  /// **'Select Bank'**
  String get selectBank;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get reference;

  /// No description provided for @banksInfo.
  ///
  /// In en, this message translates to:
  /// **'Banks Info'**
  String get banksInfo;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @bankAccount.
  ///
  /// In en, this message translates to:
  /// **'Bank Accounts'**
  String get bankAccount;

  /// No description provided for @successfulyRequest.
  ///
  /// In en, this message translates to:
  /// **'Your request has been successfully registered.'**
  String get successfulyRequest;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @meeting.
  ///
  /// In en, this message translates to:
  /// **'Meeting'**
  String get meeting;

  /// No description provided for @instructorIsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The instructor is unavailable'**
  String get instructorIsUnavailable;

  /// No description provided for @experiences.
  ///
  /// In en, this message translates to:
  /// **'Experiences'**
  String get experiences;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'Please activate your license!'**
  String get license;

  /// No description provided for @unFollow.
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get unFollow;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @reserveMeetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Reserve a live meeting with this user\nHourly charge:'**
  String get reserveMeetingDesc;

  /// No description provided for @reserveMeeting.
  ///
  /// In en, this message translates to:
  /// **'Reserve a Meeting'**
  String get reserveMeeting;

  /// No description provided for @hourlyCharge.
  ///
  /// In en, this message translates to:
  /// **'Hourly Charge'**
  String get hourlyCharge;

  /// No description provided for @noBiography.
  ///
  /// In en, this message translates to:
  /// **'No Biography!'**
  String get noBiography;

  /// No description provided for @noBiographyDesc.
  ///
  /// In en, this message translates to:
  /// **'The instructor did not define the biography.'**
  String get noBiographyDesc;

  /// No description provided for @noCourses.
  ///
  /// In en, this message translates to:
  /// **'No Courses!'**
  String get noCourses;

  /// No description provided for @noCoursesDesc.
  ///
  /// In en, this message translates to:
  /// **'This instructor doesn\'t have any courses.'**
  String get noCoursesDesc;

  /// No description provided for @noBadges.
  ///
  /// In en, this message translates to:
  /// **'No Badges!'**
  String get noBadges;

  /// No description provided for @noBadgesDesc.
  ///
  /// In en, this message translates to:
  /// **'This instructor doesn\'t have any badges.'**
  String get noBadgesDesc;

  /// No description provided for @noInstructorProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'The organization doesn\'t have any instructors.'**
  String get noInstructorProfileDesc;

  /// No description provided for @pickaDate.
  ///
  /// In en, this message translates to:
  /// **'Pick a Date'**
  String get pickaDate;

  /// No description provided for @meetingTimesAreAvailable.
  ///
  /// In en, this message translates to:
  /// **'Meeting times are available.'**
  String get meetingTimesAreAvailable;

  /// No description provided for @important.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get important;

  /// No description provided for @timeSlotsDisplayedIn.
  ///
  /// In en, this message translates to:
  /// **'Time slots displayed in'**
  String get timeSlotsDisplayedIn;

  /// No description provided for @timeZone.
  ///
  /// In en, this message translates to:
  /// **'Time Zone'**
  String get timeZone;

  /// No description provided for @pickaTime.
  ///
  /// In en, this message translates to:
  /// **'Pick a Time'**
  String get pickaTime;

  /// No description provided for @finalizeReservation.
  ///
  /// In en, this message translates to:
  /// **'Finalize Reservation'**
  String get finalizeReservation;

  /// No description provided for @reserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get reserved;

  /// No description provided for @selectedTime.
  ///
  /// In en, this message translates to:
  /// **'Selected Time:'**
  String get selectedTime;

  /// No description provided for @meetingDetails.
  ///
  /// In en, this message translates to:
  /// **'Meeting Details'**
  String get meetingDetails;

  /// No description provided for @onlineMeetingHourlyRate.
  ///
  /// In en, this message translates to:
  /// **'Online meeting hourly rate: '**
  String get onlineMeetingHourlyRate;

  /// No description provided for @inPersonMeetingHourlyRate.
  ///
  /// In en, this message translates to:
  /// **'In-person meeting hourly rate: '**
  String get inPersonMeetingHourlyRate;

  /// No description provided for @instructorConductsGroupMeetings.
  ///
  /// In en, this message translates to:
  /// **'Instructor conducts group meetings.'**
  String get instructorConductsGroupMeetings;

  /// No description provided for @conductionType.
  ///
  /// In en, this message translates to:
  /// **'Conduction Type'**
  String get conductionType;

  /// No description provided for @inPerson.
  ///
  /// In en, this message translates to:
  /// **'In-person'**
  String get inPerson;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @meetingType.
  ///
  /// In en, this message translates to:
  /// **'Meeting Type'**
  String get meetingType;

  /// No description provided for @individual.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get individual;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @participates.
  ///
  /// In en, this message translates to:
  /// **'Participates'**
  String get participates;

  /// No description provided for @groupMeetingDetails.
  ///
  /// In en, this message translates to:
  /// **'Group Meeting Details'**
  String get groupMeetingDetails;

  /// No description provided for @meetingHourlyRate.
  ///
  /// In en, this message translates to:
  /// **'Meeting hourly rate: '**
  String get meetingHourlyRate;

  /// No description provided for @groupLiveCapacity.
  ///
  /// In en, this message translates to:
  /// **'Group live capacity:'**
  String get groupLiveCapacity;

  /// No description provided for @successfullyRegisteredMeeting.
  ///
  /// In en, this message translates to:
  /// **'The meeting was successfully registered'**
  String get successfullyRegisteredMeeting;

  /// No description provided for @myAssignments.
  ///
  /// In en, this message translates to:
  /// **'My Assignments'**
  String get myAssignments;

  /// No description provided for @studentAssignmetns.
  ///
  /// In en, this message translates to:
  /// **'Student Assignments'**
  String get studentAssignmetns;

  /// No description provided for @lastSubmission.
  ///
  /// In en, this message translates to:
  /// **'Last Submission'**
  String get lastSubmission;

  /// No description provided for @firstSubmission.
  ///
  /// In en, this message translates to:
  /// **'First Submission'**
  String get firstSubmission;

  /// No description provided for @deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadline;

  /// No description provided for @grade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get grade;

  /// No description provided for @attempts.
  ///
  /// In en, this message translates to:
  /// **'Attempts'**
  String get attempts;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @passed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get passed;

  /// No description provided for @notSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Not Submitted'**
  String get notSubmitted;

  /// No description provided for @assignmentOverview.
  ///
  /// In en, this message translates to:
  /// **'Assignment Overview'**
  String get assignmentOverview;

  /// No description provided for @assignmentDetails.
  ///
  /// In en, this message translates to:
  /// **'Assignment Details'**
  String get assignmentDetails;

  /// No description provided for @passGrade.
  ///
  /// In en, this message translates to:
  /// **'Pass Grade'**
  String get passGrade;

  /// No description provided for @totalGrade.
  ///
  /// In en, this message translates to:
  /// **'Total Grade'**
  String get totalGrade;

  /// No description provided for @yourGrade.
  ///
  /// In en, this message translates to:
  /// **'Your Grade'**
  String get yourGrade;

  /// No description provided for @assignmentHistory.
  ///
  /// In en, this message translates to:
  /// **'Assignment History'**
  String get assignmentHistory;

  /// No description provided for @submitAssignment.
  ///
  /// In en, this message translates to:
  /// **'Submit Assignment'**
  String get submitAssignment;

  /// No description provided for @assignmentSubmission.
  ///
  /// In en, this message translates to:
  /// **'Assignment Submission'**
  String get assignmentSubmission;

  /// No description provided for @fileTileOptional.
  ///
  /// In en, this message translates to:
  /// **'File Tile (Optional)'**
  String get fileTileOptional;

  /// No description provided for @assignmentClosed.
  ///
  /// In en, this message translates to:
  /// **'Assignment Closed'**
  String get assignmentClosed;

  /// No description provided for @youCanNotSendFilesAnymMore.
  ///
  /// In en, this message translates to:
  /// **'You can not send files any more'**
  String get youCanNotSendFilesAnymMore;

  /// No description provided for @assignmentPassed.
  ///
  /// In en, this message translates to:
  /// **'Assignment Passed'**
  String get assignmentPassed;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @totalSubmissions.
  ///
  /// In en, this message translates to:
  /// **'Total Submissions'**
  String get totalSubmissions;

  /// No description provided for @averageGrade.
  ///
  /// In en, this message translates to:
  /// **'Average Grade'**
  String get averageGrade;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @submissions.
  ///
  /// In en, this message translates to:
  /// **'Submissions'**
  String get submissions;

  /// No description provided for @latestSubmissions.
  ///
  /// In en, this message translates to:
  /// **'Latest Submissions'**
  String get latestSubmissions;

  /// No description provided for @reviewSubmissions.
  ///
  /// In en, this message translates to:
  /// **'Review Submissions'**
  String get reviewSubmissions;

  /// No description provided for @viewAssignment.
  ///
  /// In en, this message translates to:
  /// **'View Assignment'**
  String get viewAssignment;

  /// No description provided for @allSubmissions.
  ///
  /// In en, this message translates to:
  /// **'All Submissions'**
  String get allSubmissions;

  /// No description provided for @noSubmissions.
  ///
  /// In en, this message translates to:
  /// **'No Submissions!'**
  String get noSubmissions;

  /// No description provided for @noSubmissionsDesc.
  ///
  /// In en, this message translates to:
  /// **'There is no student assignment to review'**
  String get noSubmissionsDesc;

  /// No description provided for @rateAssignment.
  ///
  /// In en, this message translates to:
  /// **'Rate Assignment'**
  String get rateAssignment;

  /// No description provided for @passGradeIis.
  ///
  /// In en, this message translates to:
  /// **'Pass grade is '**
  String get passGradeIis;

  /// No description provided for @assignmentPassedDesc.
  ///
  /// In en, this message translates to:
  /// **'You can not send files anymore'**
  String get assignmentPassedDesc;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @offlinePayments.
  ///
  /// In en, this message translates to:
  /// **'Offline Payments'**
  String get offlinePayments;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @payout.
  ///
  /// In en, this message translates to:
  /// **'Payout'**
  String get payout;

  /// No description provided for @accountBalance.
  ///
  /// In en, this message translates to:
  /// **'Account Balance'**
  String get accountBalance;

  /// No description provided for @charge.
  ///
  /// In en, this message translates to:
  /// **'Charge'**
  String get charge;

  /// No description provided for @balancesHistory.
  ///
  /// In en, this message translates to:
  /// **'Balances History'**
  String get balancesHistory;

  /// No description provided for @payoutHistory.
  ///
  /// In en, this message translates to:
  /// **'Payout History'**
  String get payoutHistory;

  /// No description provided for @salesHistory.
  ///
  /// In en, this message translates to:
  /// **'Sales History'**
  String get salesHistory;

  /// No description provided for @payoutRequest.
  ///
  /// In en, this message translates to:
  /// **'Payout Request'**
  String get payoutRequest;

  /// No description provided for @financialSettings.
  ///
  /// In en, this message translates to:
  /// **'Financial Settings'**
  String get financialSettings;

  /// No description provided for @classSales.
  ///
  /// In en, this message translates to:
  /// **'Class Sales'**
  String get classSales;

  /// No description provided for @meetingSales.
  ///
  /// In en, this message translates to:
  /// **'Meeting Sales'**
  String get meetingSales;

  /// No description provided for @totalSales.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get totalSales;

  /// No description provided for @ref.
  ///
  /// In en, this message translates to:
  /// **'Ref'**
  String get ref;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get waiting;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @noBalance.
  ///
  /// In en, this message translates to:
  /// **'No Balance!'**
  String get noBalance;

  /// No description provided for @noBalanceDesc.
  ///
  /// In en, this message translates to:
  /// **'There are no balances in your account.'**
  String get noBalanceDesc;

  /// No description provided for @noBankAccounts.
  ///
  /// In en, this message translates to:
  /// **'No Bank Accounts!'**
  String get noBankAccounts;

  /// No description provided for @noBankAccountsDesc.
  ///
  /// In en, this message translates to:
  /// **'There are no bank accounts for offline payment.'**
  String get noBankAccountsDesc;

  /// No description provided for @noOfflinePayments.
  ///
  /// In en, this message translates to:
  /// **'No offline payments!'**
  String get noOfflinePayments;

  /// No description provided for @noOfflinePaymentsDesc.
  ///
  /// In en, this message translates to:
  /// **'You do not have any offline payment requests.'**
  String get noOfflinePaymentsDesc;

  /// No description provided for @noPayout.
  ///
  /// In en, this message translates to:
  /// **'No Payout!'**
  String get noPayout;

  /// No description provided for @noPayoutDesc.
  ///
  /// In en, this message translates to:
  /// **'You do not have any payout history.'**
  String get noPayoutDesc;

  /// No description provided for @noSales.
  ///
  /// In en, this message translates to:
  /// **'No Sales!'**
  String get noSales;

  /// No description provided for @noSalesDesc.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t sold any items.'**
  String get noSalesDesc;

  /// No description provided for @readyToPayout.
  ///
  /// In en, this message translates to:
  /// **'Ready to Payout'**
  String get readyToPayout;

  /// No description provided for @requestPayout.
  ///
  /// In en, this message translates to:
  /// **'Request Payout'**
  String get requestPayout;

  /// No description provided for @requestPayoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Please verify your account information so we can send money to it'**
  String get requestPayoutDesc;

  /// No description provided for @cardID.
  ///
  /// In en, this message translates to:
  /// **'Card ID'**
  String get cardID;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @iban.
  ///
  /// In en, this message translates to:
  /// **'IBAN'**
  String get iban;

  /// No description provided for @purchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get purchased;

  /// No description provided for @invited.
  ///
  /// In en, this message translates to:
  /// **'Invited'**
  String get invited;

  /// No description provided for @organization.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get organization;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @accessExpiresOn.
  ///
  /// In en, this message translates to:
  /// **'Access expires on'**
  String get accessExpiresOn;

  /// No description provided for @courseOverview.
  ///
  /// In en, this message translates to:
  /// **'Course Overview'**
  String get courseOverview;

  /// No description provided for @classID.
  ///
  /// In en, this message translates to:
  /// **'Class ID'**
  String get classID;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @dateCreated.
  ///
  /// In en, this message translates to:
  /// **'Date Created'**
  String get dateCreated;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @startMeeting.
  ///
  /// In en, this message translates to:
  /// **'Start Meeting'**
  String get startMeeting;

  /// No description provided for @joinMeeting.
  ///
  /// In en, this message translates to:
  /// **'Join Meeting'**
  String get joinMeeting;

  /// No description provided for @finishmeeting.
  ///
  /// In en, this message translates to:
  /// **'Finish Meeting'**
  String get finishmeeting;

  /// No description provided for @meetingOptions.
  ///
  /// In en, this message translates to:
  /// **'Meeting Options'**
  String get meetingOptions;

  /// No description provided for @canceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get canceled;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @createJoinInfo.
  ///
  /// In en, this message translates to:
  /// **'Create Join Info'**
  String get createJoinInfo;

  /// No description provided for @joinURL.
  ///
  /// In en, this message translates to:
  /// **'Join URL'**
  String get joinURL;

  /// No description provided for @passwordOptional.
  ///
  /// In en, this message translates to:
  /// **'Password (Optional)'**
  String get passwordOptional;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @noMeetings.
  ///
  /// In en, this message translates to:
  /// **'No Meetings!'**
  String get noMeetings;

  /// No description provided for @noMeetingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Book a meeting with your favorite consultant.'**
  String get noMeetingsDesc;

  /// No description provided for @noCourseClassesDesc.
  ///
  /// In en, this message translates to:
  /// **'Start learning now by enrolling on courses.'**
  String get noCourseClassesDesc;

  /// No description provided for @consultant.
  ///
  /// In en, this message translates to:
  /// **'Consultant'**
  String get consultant;

  /// No description provided for @reservatore.
  ///
  /// In en, this message translates to:
  /// **'Reservatore'**
  String get reservatore;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @meetingJoinDetails.
  ///
  /// In en, this message translates to:
  /// **'Meeting Join Details'**
  String get meetingJoinDetails;

  /// No description provided for @myComments.
  ///
  /// In en, this message translates to:
  /// **'My Comments'**
  String get myComments;

  /// No description provided for @myClassComments.
  ///
  /// In en, this message translates to:
  /// **'My Class Comments'**
  String get myClassComments;

  /// No description provided for @commentDetails.
  ///
  /// In en, this message translates to:
  /// **'Comment Details'**
  String get commentDetails;

  /// No description provided for @thisCommentIsFor.
  ///
  /// In en, this message translates to:
  /// **'This comment is for'**
  String get thisCommentIsFor;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @editComment.
  ///
  /// In en, this message translates to:
  /// **'Edit Comment'**
  String get editComment;

  /// No description provided for @reportComment.
  ///
  /// In en, this message translates to:
  /// **'Report Comment'**
  String get reportComment;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @thereIsNoInformationToDisplay.
  ///
  /// In en, this message translates to:
  /// **'Sorry, there is no information available to display.'**
  String get thereIsNoInformationToDisplay;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @referralURL.
  ///
  /// In en, this message translates to:
  /// **'Referral URL'**
  String get referralURL;

  /// No description provided for @joinNewsletter.
  ///
  /// In en, this message translates to:
  /// **'Join Newsletter'**
  String get joinNewsletter;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountType;

  /// No description provided for @accountID.
  ///
  /// In en, this message translates to:
  /// **'Account ID'**
  String get accountID;

  /// No description provided for @identityScan.
  ///
  /// In en, this message translates to:
  /// **'Identity Scan'**
  String get identityScan;

  /// No description provided for @certificatesDocuments.
  ///
  /// In en, this message translates to:
  /// **'Certificates & Documents'**
  String get certificatesDocuments;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @financialApproval.
  ///
  /// In en, this message translates to:
  /// **'Financial Approved'**
  String get financialApproval;

  /// No description provided for @financialApprovalDesc.
  ///
  /// In en, this message translates to:
  /// **'Your financial information is not approved!'**
  String get financialApprovalDesc;

  /// No description provided for @localization.
  ///
  /// In en, this message translates to:
  /// **'Localization'**
  String get localization;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @province.
  ///
  /// In en, this message translates to:
  /// **'Province'**
  String get province;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @passwordUpdateDesc.
  ///
  /// In en, this message translates to:
  /// **'Your password has been updated successfully'**
  String get passwordUpdateDesc;

  /// No description provided for @sendDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Sending data... Please wait'**
  String get sendDataDesc;

  /// No description provided for @myResults.
  ///
  /// In en, this message translates to:
  /// **'My Results'**
  String get myResults;

  /// No description provided for @notParticipated.
  ///
  /// In en, this message translates to:
  /// **'Not Participated'**
  String get notParticipated;

  /// No description provided for @studentResults.
  ///
  /// In en, this message translates to:
  /// **'Student Results'**
  String get studentResults;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @quizInfomration.
  ///
  /// In en, this message translates to:
  /// **'Quiz Information'**
  String get quizInfomration;

  /// No description provided for @totalMark.
  ///
  /// In en, this message translates to:
  /// **'Total Mark'**
  String get totalMark;

  /// No description provided for @passMark.
  ///
  /// In en, this message translates to:
  /// **'Pass Mark'**
  String get passMark;

  /// No description provided for @passedStudents.
  ///
  /// In en, this message translates to:
  /// **'Passed Students'**
  String get passedStudents;

  /// No description provided for @backToQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Back to Quizzes'**
  String get backToQuizzes;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No Results!'**
  String get noResults;

  /// No description provided for @youHaveNoQuizResults.
  ///
  /// In en, this message translates to:
  /// **'You have no quiz results.'**
  String get youHaveNoQuizResults;

  /// No description provided for @noStudentResults.
  ///
  /// In en, this message translates to:
  /// **'No Student Results!'**
  String get noStudentResults;

  /// No description provided for @noStudentResultsDesc.
  ///
  /// In en, this message translates to:
  /// **'Your students don\'t have results.'**
  String get noStudentResultsDesc;

  /// No description provided for @youPassedTheQuiz.
  ///
  /// In en, this message translates to:
  /// **'You passed the quiz'**
  String get youPassedTheQuiz;

  /// No description provided for @youPassedTheQuizDesc.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You passed the quiz\nsuccessfully...'**
  String get youPassedTheQuizDesc;

  /// No description provided for @waitForFinalResult.
  ///
  /// In en, this message translates to:
  /// **'Wait for final result'**
  String get waitForFinalResult;

  /// No description provided for @waitForFinalResultDesc.
  ///
  /// In en, this message translates to:
  /// **'Your quiz includes descriptive questions\nPlease wait for instructor review.'**
  String get waitForFinalResultDesc;

  /// No description provided for @youFailedTheQuiz.
  ///
  /// In en, this message translates to:
  /// **'You failed the quiz'**
  String get youFailedTheQuiz;

  /// No description provided for @youFailedTheQuizDesc.
  ///
  /// In en, this message translates to:
  /// **'Sorry! You failed the quiz...\nYou can try again.'**
  String get youFailedTheQuizDesc;

  /// No description provided for @submitDate.
  ///
  /// In en, this message translates to:
  /// **'Submition Date'**
  String get submitDate;

  /// No description provided for @reviewQuiz.
  ///
  /// In en, this message translates to:
  /// **'Review Quiz'**
  String get reviewQuiz;

  /// No description provided for @reviewAnswers.
  ///
  /// In en, this message translates to:
  /// **'Review Answers'**
  String get reviewAnswers;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @quizResult.
  ///
  /// In en, this message translates to:
  /// **'Quiz Result'**
  String get quizResult;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct Answer'**
  String get correctAnswer;

  /// No description provided for @studentGrade.
  ///
  /// In en, this message translates to:
  /// **'Student Grade'**
  String get studentGrade;

  /// No description provided for @studentsAnswer.
  ///
  /// In en, this message translates to:
  /// **'Student\'s Answer'**
  String get studentsAnswer;

  /// No description provided for @quizReview.
  ///
  /// In en, this message translates to:
  /// **'Quiz Review'**
  String get quizReview;

  /// No description provided for @thisQuizIncludes.
  ///
  /// In en, this message translates to:
  /// **'This quiz includes'**
  String get thisQuizIncludes;

  /// No description provided for @questionsForReview.
  ///
  /// In en, this message translates to:
  /// **'questions for review.'**
  String get questionsForReview;

  /// No description provided for @typeYourAnswerHere.
  ///
  /// In en, this message translates to:
  /// **'Type your answer here'**
  String get typeYourAnswerHere;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// No description provided for @reviewTheResult.
  ///
  /// In en, this message translates to:
  /// **'Review the result'**
  String get reviewTheResult;

  /// No description provided for @reviewTheResultDesc.
  ///
  /// In en, this message translates to:
  /// **'Your quiz includes descriptive questions\nPlease review it.'**
  String get reviewTheResultDesc;

  /// No description provided for @quizCerts.
  ///
  /// In en, this message translates to:
  /// **'Quiz Certs.'**
  String get quizCerts;

  /// No description provided for @completionCerts.
  ///
  /// In en, this message translates to:
  /// **'Completion Certs.'**
  String get completionCerts;

  /// No description provided for @classCerts.
  ///
  /// In en, this message translates to:
  /// **'Class Certs.'**
  String get classCerts;

  /// No description provided for @certificateDetails.
  ///
  /// In en, this message translates to:
  /// **'Certificate Details'**
  String get certificateDetails;

  /// No description provided for @shareCertificate.
  ///
  /// In en, this message translates to:
  /// **'Share Certificate'**
  String get shareCertificate;

  /// No description provided for @shareCertificateDesc.
  ///
  /// In en, this message translates to:
  /// **'You can share this certificate using social networks\nand encourage others to learn.'**
  String get shareCertificateDesc;

  /// No description provided for @takenDate.
  ///
  /// In en, this message translates to:
  /// **'Taken Date'**
  String get takenDate;

  /// No description provided for @certificateID.
  ///
  /// In en, this message translates to:
  /// **'Certificate ID'**
  String get certificateID;

  /// No description provided for @totalStudents.
  ///
  /// In en, this message translates to:
  /// **'Total Students'**
  String get totalStudents;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @certificateOverview.
  ///
  /// In en, this message translates to:
  /// **'Certificate Overview'**
  String get certificateOverview;

  /// No description provided for @certificateOverviewDesc.
  ///
  /// In en, this message translates to:
  /// **'You can evaluate your students learning quality\nusing the following information'**
  String get certificateOverviewDesc;

  /// No description provided for @certificateStudents.
  ///
  /// In en, this message translates to:
  /// **'Certificate Students'**
  String get certificateStudents;

  /// No description provided for @youHaveNotAccess.
  ///
  /// In en, this message translates to:
  /// **'You do not have access to this section'**
  String get youHaveNotAccess;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @noCertificates.
  ///
  /// In en, this message translates to:
  /// **'No Certificates!'**
  String get noCertificates;

  /// No description provided for @noCertificatesDesc.
  ///
  /// In en, this message translates to:
  /// **'You have no certificates yet.'**
  String get noCertificatesDesc;

  /// No description provided for @activePlan.
  ///
  /// In en, this message translates to:
  /// **'Active\nPlan'**
  String get activePlan;

  /// No description provided for @remainedDownloads.
  ///
  /// In en, this message translates to:
  /// **'Remained\nDownloads'**
  String get remainedDownloads;

  /// No description provided for @remainedDays.
  ///
  /// In en, this message translates to:
  /// **'Remained\nDays'**
  String get remainedDays;

  /// No description provided for @selectAPlan.
  ///
  /// In en, this message translates to:
  /// **'Select a Plan'**
  String get selectAPlan;

  /// No description provided for @daysOfSubscription.
  ///
  /// In en, this message translates to:
  /// **'Days of subscription'**
  String get daysOfSubscription;

  /// No description provided for @classesSubscription.
  ///
  /// In en, this message translates to:
  /// **'Classes subscription'**
  String get classesSubscription;

  /// No description provided for @noActiveSubscriptionPlan.
  ///
  /// In en, this message translates to:
  /// **'No active subscription plan'**
  String get noActiveSubscriptionPlan;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No Favorites!'**
  String get noFavorites;

  /// No description provided for @noFavoritesDesc.
  ///
  /// In en, this message translates to:
  /// **'Add your favorite courses to wish list.'**
  String get noFavoritesDesc;

  /// No description provided for @newEvents.
  ///
  /// In en, this message translates to:
  /// **'new events'**
  String get newEvents;

  /// No description provided for @pendingMessages.
  ///
  /// In en, this message translates to:
  /// **'Pending\nMessages'**
  String get pendingMessages;

  /// No description provided for @pendingMeetings.
  ///
  /// In en, this message translates to:
  /// **'Pending\nMeetings'**
  String get pendingMeetings;

  /// No description provided for @supportMessages.
  ///
  /// In en, this message translates to:
  /// **'Support\nMessages'**
  String get supportMessages;

  /// No description provided for @monthlySales.
  ///
  /// In en, this message translates to:
  /// **'Monthly\nSales'**
  String get monthlySales;

  /// No description provided for @purchasedCourses.
  ///
  /// In en, this message translates to:
  /// **'Purchased\nCourses'**
  String get purchasedCourses;

  /// No description provided for @learningStatistics.
  ///
  /// In en, this message translates to:
  /// **'Learning Statistics'**
  String get learningStatistics;

  /// No description provided for @monthSales.
  ///
  /// In en, this message translates to:
  /// **'Month Sales'**
  String get monthSales;

  /// No description provided for @tickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get tickets;

  /// No description provided for @classesSupport.
  ///
  /// In en, this message translates to:
  /// **'Classes Support'**
  String get classesSupport;

  /// No description provided for @myClassesSupport.
  ///
  /// In en, this message translates to:
  /// **'My Classes Support'**
  String get myClassesSupport;

  /// No description provided for @replied.
  ///
  /// In en, this message translates to:
  /// **'Replied'**
  String get replied;

  /// No description provided for @newSupportMessage.
  ///
  /// In en, this message translates to:
  /// **'New Support Message'**
  String get newSupportMessage;

  /// No description provided for @selectDepartment.
  ///
  /// In en, this message translates to:
  /// **'Select Department'**
  String get selectDepartment;

  /// No description provided for @replyToSupport.
  ///
  /// In en, this message translates to:
  /// **'Reply to Support'**
  String get replyToSupport;

  /// No description provided for @replyToConversation.
  ///
  /// In en, this message translates to:
  /// **'Reply to Conversation'**
  String get replyToConversation;

  /// No description provided for @support_messages.
  ///
  /// In en, this message translates to:
  /// **'Support Messages'**
  String get support_messages;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @noTickets.
  ///
  /// In en, this message translates to:
  /// **'No Tickets!'**
  String get noTickets;

  /// No description provided for @noTicketsDesc.
  ///
  /// In en, this message translates to:
  /// **'Need help? Create new support request.'**
  String get noTicketsDesc;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFromFavorites;

  /// No description provided for @thisIsACourseSupportMessage.
  ///
  /// In en, this message translates to:
  /// **'This is a course support message'**
  String get thisIsACourseSupportMessage;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @passwordAndRetypePassNotMatch.
  ///
  /// In en, this message translates to:
  /// **'The new password does not match the new password'**
  String get passwordAndRetypePassNotMatch;

  /// No description provided for @nextBadges.
  ///
  /// In en, this message translates to:
  /// **'Next Badges'**
  String get nextBadges;

  /// No description provided for @remainedPoints.
  ///
  /// In en, this message translates to:
  /// **'Remained\nPoints'**
  String get remainedPoints;

  /// No description provided for @totalPoints.
  ///
  /// In en, this message translates to:
  /// **'Total\nPoints'**
  String get totalPoints;

  /// No description provided for @spentPoints.
  ///
  /// In en, this message translates to:
  /// **'Spent\nPoints'**
  String get spentPoints;

  /// No description provided for @pointsHistory.
  ///
  /// In en, this message translates to:
  /// **'Points History'**
  String get pointsHistory;

  /// No description provided for @loginDesc.
  ///
  /// In en, this message translates to:
  /// **'Please login to view this page information'**
  String get loginDesc;

  /// No description provided for @freeCourses.
  ///
  /// In en, this message translates to:
  /// **'Free Courses!'**
  String get freeCourses;

  /// No description provided for @bySpendingPoints.
  ///
  /// In en, this message translates to:
  /// **'By spending points'**
  String get bySpendingPoints;

  /// No description provided for @saaSPackages.
  ///
  /// In en, this message translates to:
  /// **'SaaS Packages'**
  String get saaSPackages;

  /// No description provided for @activationDate.
  ///
  /// In en, this message translates to:
  /// **'Activation\nDate'**
  String get activationDate;

  /// No description provided for @accountStatistics.
  ///
  /// In en, this message translates to:
  /// **'Account Statistics'**
  String get accountStatistics;

  /// No description provided for @newCourses.
  ///
  /// In en, this message translates to:
  /// **'New\nCourses'**
  String get newCourses;

  /// No description provided for @liveClassCapacity.
  ///
  /// In en, this message translates to:
  /// **'Live\nClass Capacity'**
  String get liveClassCapacity;

  /// No description provided for @meetingTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'Meeting\nTime Slots'**
  String get meetingTimeSlots;

  /// No description provided for @newStudents.
  ///
  /// In en, this message translates to:
  /// **'New\nStudents'**
  String get newStudents;

  /// No description provided for @newInstructors.
  ///
  /// In en, this message translates to:
  /// **'New\nInstructors'**
  String get newInstructors;

  /// No description provided for @getCashback.
  ///
  /// In en, this message translates to:
  /// **'Get Cashback'**
  String get getCashback;

  /// No description provided for @finalizeYourOrderAndGet.
  ///
  /// In en, this message translates to:
  /// **'Finalize your order and get'**
  String get finalizeYourOrderAndGet;

  /// No description provided for @cashback.
  ///
  /// In en, this message translates to:
  /// **'cashback!'**
  String get cashback;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'skip'**
  String get skip;

  /// No description provided for @purchaseThisCourseAndGet.
  ///
  /// In en, this message translates to:
  /// **'Purchase this course and get '**
  String get purchaseThisCourseAndGet;

  /// No description provided for @purchaseThisProductAndGet.
  ///
  /// In en, this message translates to:
  /// **'Purchase this product and get '**
  String get purchaseThisProductAndGet;

  /// No description provided for @instrcutor.
  ///
  /// In en, this message translates to:
  /// **'Instrcutor'**
  String get instrcutor;

  /// No description provided for @pleaseReview.
  ///
  /// In en, this message translates to:
  /// **'Please review'**
  String get pleaseReview;

  /// No description provided for @reserveAMeetingAndGet.
  ///
  /// In en, this message translates to:
  /// **'Reserve a meeting and get '**
  String get reserveAMeetingAndGet;

  /// No description provided for @createALiveSession.
  ///
  /// In en, this message translates to:
  /// **'Create a live session'**
  String get createALiveSession;

  /// No description provided for @inappSession.
  ///
  /// In en, this message translates to:
  /// **'In-app Session'**
  String get inappSession;

  /// No description provided for @customSession.
  ///
  /// In en, this message translates to:
  /// **'Custom Session'**
  String get customSession;

  /// No description provided for @newInappLiveSession.
  ///
  /// In en, this message translates to:
  /// **'New In-app Live Session'**
  String get newInappLiveSession;

  /// No description provided for @inappLiveSession.
  ///
  /// In en, this message translates to:
  /// **'In-app Live Session'**
  String get inappLiveSession;

  /// No description provided for @inappLiveSessionQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to create an in-app live session for this meeting?'**
  String get inappLiveSessionQuestion;

  /// No description provided for @theMeetingDateIs.
  ///
  /// In en, this message translates to:
  /// **'The meeting date is '**
  String get theMeetingDateIs;

  /// No description provided for @liveSessionCreated.
  ///
  /// In en, this message translates to:
  /// **'Live Session Created'**
  String get liveSessionCreated;

  /// No description provided for @youCanJoinItNow.
  ///
  /// In en, this message translates to:
  /// **'You can join it now'**
  String get youCanJoinItNow;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @latestBundles.
  ///
  /// In en, this message translates to:
  /// **'Latest Bundles'**
  String get latestBundles;

  /// No description provided for @chapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chapters;

  /// No description provided for @newMessage.
  ///
  /// In en, this message translates to:
  /// **'New Message'**
  String get newMessage;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @messageBody.
  ///
  /// In en, this message translates to:
  /// **'Message Body'**
  String get messageBody;

  /// No description provided for @privateContent.
  ///
  /// In en, this message translates to:
  /// **'Private Content!'**
  String get privateContent;

  /// No description provided for @privateContentDesc.
  ///
  /// In en, this message translates to:
  /// **'You need to log in to access the course content.'**
  String get privateContentDesc;

  /// No description provided for @pendingVerification.
  ///
  /// In en, this message translates to:
  /// **'Pending Verification!'**
  String get pendingVerification;

  /// No description provided for @pendingVerificationDesc.
  ///
  /// In en, this message translates to:
  /// **'Your account is under review and you will be able to access the content after approval'**
  String get pendingVerificationDesc;

  /// No description provided for @private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// No description provided for @noCourse.
  ///
  /// In en, this message translates to:
  /// **'No Course'**
  String get noCourse;

  /// No description provided for @searchACurrency.
  ///
  /// In en, this message translates to:
  /// **'Search a Currency'**
  String get searchACurrency;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @selectCountryDesc.
  ///
  /// In en, this message translates to:
  /// **'Search for a country or code'**
  String get selectCountryDesc;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @exitDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get exitDesc;

  /// No description provided for @loginHistory.
  ///
  /// In en, this message translates to:
  /// **'Login History'**
  String get loginHistory;

  /// No description provided for @loginHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Swipe and view your account login history'**
  String get loginHistoryDesc;

  /// No description provided for @os.
  ///
  /// In en, this message translates to:
  /// **'OS'**
  String get os;

  /// No description provided for @browser.
  ///
  /// In en, this message translates to:
  /// **'Browser'**
  String get browser;

  /// No description provided for @device.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// No description provided for @ip.
  ///
  /// In en, this message translates to:
  /// **'IP'**
  String get ip;

  /// No description provided for @addANote.
  ///
  /// In en, this message translates to:
  /// **'Add a Note'**
  String get addANote;

  /// No description provided for @courseNote.
  ///
  /// In en, this message translates to:
  /// **'Course Note'**
  String get courseNote;

  /// No description provided for @saveNote.
  ///
  /// In en, this message translates to:
  /// **'Save Note'**
  String get saveNote;

  /// No description provided for @viewNote.
  ///
  /// In en, this message translates to:
  /// **'View Note'**
  String get viewNote;

  /// No description provided for @attachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get attachment;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit Note'**
  String get editNote;

  /// No description provided for @networkProblem.
  ///
  /// In en, this message translates to:
  /// **'Network Problem...'**
  String get networkProblem;

  /// No description provided for @networkProblemDesc.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again...'**
  String get networkProblemDesc;

  /// No description provided for @myCourses.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get myCourses;

  /// No description provided for @studentPassedTheQuiz.
  ///
  /// In en, this message translates to:
  /// **'Student passed the quiz'**
  String get studentPassedTheQuiz;

  /// No description provided for @enterACouponCode.
  ///
  /// In en, this message translates to:
  /// **'Enter a Coupon Code'**
  String get enterACouponCode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @teacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacher;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to delete your account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Your account will be removed from the platform after admin approval. This process couldn\'t be reverted.'**
  String get deleteAccountDesc;

  /// No description provided for @serverExceptionError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while retrieving information from the server.'**
  String get serverExceptionError;

  /// No description provided for @authLimitAccount.
  ///
  /// In en, this message translates to:
  /// **'You cannot log in because your account is open on another device'**
  String get authLimitAccount;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
