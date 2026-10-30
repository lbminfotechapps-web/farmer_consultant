import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('mr')
  ];

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @stayUpdated.
  ///
  /// In en, this message translates to:
  /// **'Stay Updated'**
  String get stayUpdated;

  /// No description provided for @noNotificationsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No notifications available'**
  String get noNotificationsAvailable;

  /// No description provided for @latestUpdates.
  ///
  /// In en, this message translates to:
  /// **'Here are your latest updates'**
  String get latestUpdates;

  /// No description provided for @recordNotFound.
  ///
  /// In en, this message translates to:
  /// **'Record Not Found'**
  String get recordNotFound;

  /// No description provided for @unableToLoad.
  ///
  /// In en, this message translates to:
  /// **'Unable to Load'**
  String get unableToLoad;

  /// No description provided for @notificationLoadError.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t load your notifications.\nPlease check your connection and try again.'**
  String get notificationLoadError;

  /// No description provided for @productCategory.
  ///
  /// In en, this message translates to:
  /// **'Product Category'**
  String get productCategory;

  /// No description provided for @noCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get noCategoriesFound;

  /// No description provided for @searchProduct.
  ///
  /// In en, this message translates to:
  /// **'Search product...'**
  String get searchProduct;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @searchingProducts.
  ///
  /// In en, this message translates to:
  /// **'Searching products...'**
  String get searchingProducts;

  /// No description provided for @noProductForQuery.
  ///
  /// In en, this message translates to:
  /// **'No product found for \"{query}\"'**
  String noProductForQuery(String query);

  /// No description provided for @viewProductDetails.
  ///
  /// In en, this message translates to:
  /// **'View product details'**
  String get viewProductDetails;

  /// No description provided for @categoryNotFound.
  ///
  /// In en, this message translates to:
  /// **'Category Not Found'**
  String get categoryNotFound;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product Not Found'**
  String get productNotFound;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// No description provided for @recommendedDosage.
  ///
  /// In en, this message translates to:
  /// **'Recommended Dosage'**
  String get recommendedDosage;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @productContents.
  ///
  /// In en, this message translates to:
  /// **'Product Contents'**
  String get productContents;

  /// No description provided for @diseaseInformation.
  ///
  /// In en, this message translates to:
  /// **'Disease Information'**
  String get diseaseInformation;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosage;

  /// No description provided for @unableToShareProduct.
  ///
  /// In en, this message translates to:
  /// **'Unable to share product. Please try again.'**
  String get unableToShareProduct;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @productCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Product} other{{count} Products}}'**
  String productCount(int count);

  /// No description provided for @quickReferenceChartReport.
  ///
  /// In en, this message translates to:
  /// **'Quick Reference Chart Report'**
  String get quickReferenceChartReport;

  /// No description provided for @noQuickReferenceFound.
  ///
  /// In en, this message translates to:
  /// **'No quick reference found'**
  String get noQuickReferenceFound;

  /// No description provided for @availableReferences.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Available Reference} other{Available References}}'**
  String availableReferences(int count);

  /// No description provided for @pdfDocument.
  ///
  /// In en, this message translates to:
  /// **'PDF Document'**
  String get pdfDocument;

  /// No description provided for @imageReference.
  ///
  /// In en, this message translates to:
  /// **'Image Reference'**
  String get imageReference;

  /// No description provided for @referenceFile.
  ///
  /// In en, this message translates to:
  /// **'Reference File'**
  String get referenceFile;

  /// No description provided for @unableToShareImage.
  ///
  /// In en, this message translates to:
  /// **'Unable to share image. Please try again.'**
  String get unableToShareImage;

  /// No description provided for @shareImage.
  ///
  /// In en, this message translates to:
  /// **'Share image'**
  String get shareImage;

  /// No description provided for @unableToLoadImage.
  ///
  /// In en, this message translates to:
  /// **'Unable to load image'**
  String get unableToLoadImage;

  /// No description provided for @previousImage.
  ///
  /// In en, this message translates to:
  /// **'Previous image'**
  String get previousImage;

  /// No description provided for @nextImage.
  ///
  /// In en, this message translates to:
  /// **'Next image'**
  String get nextImage;

  /// No description provided for @zoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get zoomOut;

  /// No description provided for @resetZoom.
  ///
  /// In en, this message translates to:
  /// **'Reset zoom'**
  String get resetZoom;

  /// No description provided for @zoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get zoomIn;

  /// No description provided for @unableToOpenPhone.
  ///
  /// In en, this message translates to:
  /// **'Unable to open phone dialer'**
  String get unableToOpenPhone;

  /// No description provided for @unableToOpenEmail.
  ///
  /// In en, this message translates to:
  /// **'Unable to open email application'**
  String get unableToOpenEmail;

  /// No description provided for @unableToOpenWebsite.
  ///
  /// In en, this message translates to:
  /// **'Unable to open website'**
  String get unableToOpenWebsite;

  /// No description provided for @getInTouch.
  ///
  /// In en, this message translates to:
  /// **'Get In Touch'**
  String get getInTouch;

  /// No description provided for @hereToHelp.
  ///
  /// In en, this message translates to:
  /// **'We are here to help you'**
  String get hereToHelp;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @contactOpenHint.
  ///
  /// In en, this message translates to:
  /// **'Tap phone, email or website to open'**
  String get contactOpenHint;

  /// No description provided for @loadingContactInformation.
  ///
  /// In en, this message translates to:
  /// **'Loading Contact Information...'**
  String get loadingContactInformation;

  /// No description provided for @unableToLoadContactUs.
  ///
  /// In en, this message translates to:
  /// **'Unable to Load Contact Us'**
  String get unableToLoadContactUs;

  /// No description provided for @contactLoadError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while loading the contact information.'**
  String get contactLoadError;

  /// No description provided for @aboutOurOrganization.
  ///
  /// In en, this message translates to:
  /// **'About Our Organization'**
  String get aboutOurOrganization;

  /// No description provided for @learnMoreAboutUs.
  ///
  /// In en, this message translates to:
  /// **'Learn more about us'**
  String get learnMoreAboutUs;

  /// No description provided for @loadingAboutUs.
  ///
  /// In en, this message translates to:
  /// **'Loading About Us...'**
  String get loadingAboutUs;

  /// No description provided for @pleaseWaitAMoment.
  ///
  /// In en, this message translates to:
  /// **'Please wait a moment'**
  String get pleaseWaitAMoment;

  /// No description provided for @unableToLoadAboutUs.
  ///
  /// In en, this message translates to:
  /// **'Unable to Load About Us'**
  String get unableToLoadAboutUs;

  /// No description provided for @organizationLoadError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while loading the organization information.'**
  String get organizationLoadError;

  /// No description provided for @sharePlatform.
  ///
  /// In en, this message translates to:
  /// **'Share {platform}'**
  String sharePlatform(String platform);

  /// No description provided for @unableToShare.
  ///
  /// In en, this message translates to:
  /// **'Unable to share. Please try again.'**
  String get unableToShare;

  /// No description provided for @socialShareSubject.
  ///
  /// In en, this message translates to:
  /// **'Connect with Solufine on {platform}'**
  String socialShareSubject(String platform);

  /// No description provided for @socialShareMessage.
  ///
  /// In en, this message translates to:
  /// **'Grow together with Solufine! 🌱\n\nConnect with us on {platform} for farming updates, inspiration, and the latest from Solufine:\n{link}\n\nExplore more with the Solufine app. Download it on Google Play:\n{storeUrl}'**
  String socialShareMessage(String platform, String link, String storeUrl);

  /// No description provided for @socialLinkUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Social media link is not available'**
  String get socialLinkUnavailable;

  /// No description provided for @invalidSocialUrl.
  ///
  /// In en, this message translates to:
  /// **'Invalid social media URL'**
  String get invalidSocialUrl;

  /// No description provided for @unableToOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Unable to open this link'**
  String get unableToOpenLink;

  /// No description provided for @socialLinksUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Social media links not available'**
  String get socialLinksUnavailable;

  /// No description provided for @connectWithUs.
  ///
  /// In en, this message translates to:
  /// **'Connect With Us'**
  String get connectWithUs;

  /// No description provided for @followOrganization.
  ///
  /// In en, this message translates to:
  /// **'Follow {organization}'**
  String followOrganization(String organization);

  /// No description provided for @followUsOn.
  ///
  /// In en, this message translates to:
  /// **'Follow us on {platform}'**
  String followUsOn(String platform);

  /// No description provided for @subscribeYoutube.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to our YouTube channel'**
  String get subscribeYoutube;

  /// No description provided for @connectLinkedin.
  ///
  /// In en, this message translates to:
  /// **'Connect with us on LinkedIn'**
  String get connectLinkedin;

  /// No description provided for @joinTelegram.
  ///
  /// In en, this message translates to:
  /// **'Join us on Telegram'**
  String get joinTelegram;

  /// No description provided for @chatWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Chat with us on WhatsApp'**
  String get chatWhatsapp;

  /// No description provided for @unableToLoadSocialMedia.
  ///
  /// In en, this message translates to:
  /// **'Unable to load social media'**
  String get unableToLoadSocialMedia;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @farmAtAGlance.
  ///
  /// In en, this message translates to:
  /// **'Your farm, at a glance'**
  String get farmAtAGlance;

  /// No description provided for @todaysActivities.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Activities'**
  String get todaysActivities;

  /// No description provided for @cropSchedule.
  ///
  /// In en, this message translates to:
  /// **'Crop Schedule'**
  String get cropSchedule;

  /// No description provided for @viewTodaysTasks.
  ///
  /// In en, this message translates to:
  /// **'View today\'s tasks'**
  String get viewTodaysTasks;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNewAlerts.
  ///
  /// In en, this message translates to:
  /// **'No new alerts'**
  String get noNewAlerts;

  /// No description provided for @newAlerts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 new alert} other{{count} new alerts}}'**
  String newAlerts(int count);

  /// No description provided for @myPlots.
  ///
  /// In en, this message translates to:
  /// **'My Plots'**
  String get myPlots;

  /// No description provided for @plots.
  ///
  /// In en, this message translates to:
  /// **'Plots'**
  String get plots;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @nearDealers.
  ///
  /// In en, this message translates to:
  /// **'Near Dealers'**
  String get nearDealers;

  /// No description provided for @quickReference.
  ///
  /// In en, this message translates to:
  /// **'Quick Reference'**
  String get quickReference;

  /// No description provided for @weather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weather;

  /// No description provided for @importantLinks.
  ///
  /// In en, this message translates to:
  /// **'Important Links'**
  String get importantLinks;

  /// No description provided for @cropAdvice.
  ///
  /// In en, this message translates to:
  /// **'Crop Advice'**
  String get cropAdvice;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @socialMedia.
  ///
  /// In en, this message translates to:
  /// **'Social Media'**
  String get socialMedia;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @aiPoweredFarming.
  ///
  /// In en, this message translates to:
  /// **'AI POWERED FARMING'**
  String get aiPoweredFarming;

  /// No description provided for @growSmarter.
  ///
  /// In en, this message translates to:
  /// **'Grow smarter. Harvest better.'**
  String get growSmarter;

  /// No description provided for @betterDecisions.
  ///
  /// In en, this message translates to:
  /// **'Better decisions for every season.'**
  String get betterDecisions;

  /// No description provided for @logoutError.
  ///
  /// In en, this message translates to:
  /// **'Unable to log out. Please try again.'**
  String get logoutError;

  /// No description provided for @languageHint.
  ///
  /// In en, this message translates to:
  /// **'Choose the language you’re most comfortable with.'**
  String get languageHint;

  /// No description provided for @languageSaveError.
  ///
  /// In en, this message translates to:
  /// **'Unable to save language. Please try again.'**
  String get languageSaveError;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @taluka.
  ///
  /// In en, this message translates to:
  /// **'Taluka'**
  String get taluka;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'My Application'**
  String get appName;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

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

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @marathi.
  ///
  /// In en, this message translates to:
  /// **'Marathi'**
  String get marathi;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noDataFound;

  /// No description provided for @getOtpError.
  ///
  /// In en, this message translates to:
  /// **'Failed to get OTP'**
  String get getOtpError;

  /// No description provided for @loginWithMobile.
  ///
  /// In en, this message translates to:
  /// **'Login with your mobile number'**
  String get loginWithMobile;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number'**
  String get enterMobileNumber;

  /// No description provided for @invalidMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid mobile number'**
  String get invalidMobileNumber;

  /// No description provided for @sendingOtp.
  ///
  /// In en, this message translates to:
  /// **'Sending OTP...'**
  String get sendingOtp;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @farmerConsultantBenefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits of Farmer Consultant'**
  String get farmerConsultantBenefits;

  /// No description provided for @cropAdvisoryBenefit.
  ///
  /// In en, this message translates to:
  /// **'Crop\nAdvisory'**
  String get cropAdvisoryBenefit;

  /// No description provided for @weatherUpdatesBenefit.
  ///
  /// In en, this message translates to:
  /// **'Weather\nUpdates'**
  String get weatherUpdatesBenefit;

  /// No description provided for @pestDiseaseAlertsBenefit.
  ///
  /// In en, this message translates to:
  /// **'Pest Disease\nAlerts'**
  String get pestDiseaseAlertsBenefit;

  /// No description provided for @marketRateInfoBenefit.
  ///
  /// In en, this message translates to:
  /// **'Market\nRate Info'**
  String get marketRateInfoBenefit;

  /// No description provided for @dataPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Your data is safe with us and will never be shared.'**
  String get dataPrivacyNotice;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid 4-digit OTP'**
  String get invalidOtp;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @enterOtpHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-digit OTP sent to your mobile'**
  String get enterOtpHint;

  /// No description provided for @verifyingOtp.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get verifyingOtp;

  /// No description provided for @invalidLink.
  ///
  /// In en, this message translates to:
  /// **'Invalid link'**
  String get invalidLink;

  /// No description provided for @noImportantLinksFound.
  ///
  /// In en, this message translates to:
  /// **'No important links found'**
  String get noImportantLinksFound;

  /// No description provided for @importantLinksLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load important links. Please try again.'**
  String get importantLinksLoadError;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @videos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videos;

  /// No description provided for @certificates.
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get certificates;

  /// No description provided for @certificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get certificate;

  /// No description provided for @noImagesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No images available'**
  String get noImagesAvailable;

  /// No description provided for @noVideosAvailable.
  ///
  /// In en, this message translates to:
  /// **'No videos available'**
  String get noVideosAvailable;

  /// No description provided for @noCertificatesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No certificates available'**
  String get noCertificatesAvailable;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @galleryLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load gallery. Please try again.'**
  String get galleryLoadError;

  /// No description provided for @unableToOpenYoutube.
  ///
  /// In en, this message translates to:
  /// **'Unable to open YouTube. Please check your internet connection or browser.'**
  String get unableToOpenYoutube;

  /// No description provided for @unableToOpenPdf.
  ///
  /// In en, this message translates to:
  /// **'Unable to open PDF'**
  String get unableToOpenPdf;

  /// No description provided for @nearFertilizerShop.
  ///
  /// In en, this message translates to:
  /// **'Near Fertilizer Shop'**
  String get nearFertilizerShop;

  /// No description provided for @dealerSignInRequired.
  ///
  /// In en, this message translates to:
  /// **'Please sign in again to load nearby dealers.'**
  String get dealerSignInRequired;

  /// No description provided for @dealerLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load nearby dealers. Please try again.'**
  String get dealerLoadError;

  /// No description provided for @dealerLocationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Dealer location is not available. Please update it first.'**
  String get dealerLocationUnavailable;

  /// No description provided for @locationAccessError.
  ///
  /// In en, this message translates to:
  /// **'Unable to get your location. Enable GPS and allow location access.'**
  String get locationAccessError;

  /// No description provided for @unableToOpenMaps.
  ///
  /// In en, this message translates to:
  /// **'Unable to open Google Maps. Please try again.'**
  String get unableToOpenMaps;

  /// No description provided for @unableToOpenDirections.
  ///
  /// In en, this message translates to:
  /// **'Unable to open directions. Please try again.'**
  String get unableToOpenDirections;

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location unavailable'**
  String get locationUnavailable;

  /// No description provided for @noNearbyDealers.
  ///
  /// In en, this message translates to:
  /// **'No dealers found nearby'**
  String get noNearbyDealers;

  /// No description provided for @dealerMobileUnavailable.
  ///
  /// In en, this message translates to:
  /// **'A valid dealer mobile number is not available.'**
  String get dealerMobileUnavailable;

  /// No description provided for @unableToOpenWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Unable to open WhatsApp. Please try again.'**
  String get unableToOpenWhatsApp;

  /// No description provided for @unknownDealer.
  ///
  /// In en, this message translates to:
  /// **'Unknown dealer'**
  String get unknownDealer;

  /// No description provided for @addressUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Address not available'**
  String get addressUnavailable;

  /// No description provided for @mobileNumberUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Mobile number not available'**
  String get mobileNumberUnavailable;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @whatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsApp;

  /// No description provided for @dealerDistanceAway.
  ///
  /// In en, this message translates to:
  /// **'{distance} km'**
  String dealerDistanceAway(String distance);

  /// No description provided for @locationCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Lat {latitude}   |   Long {longitude}'**
  String locationCoordinates(String latitude, String longitude);

  /// No description provided for @cropPlanning.
  ///
  /// In en, this message translates to:
  /// **'Crop Planning'**
  String get cropPlanning;

  /// No description provided for @cropScheduleLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load crop schedule. Please try again.'**
  String get cropScheduleLoadError;

  /// No description provided for @unableToLoadSchedules.
  ///
  /// In en, this message translates to:
  /// **'No schedules have been added for this date.'**
  String get unableToLoadSchedules;

  /// No description provided for @noCropSchedule.
  ///
  /// In en, this message translates to:
  /// **'No Crop Schedule'**
  String get noCropSchedule;

  /// No description provided for @noCropSchedulesAvailable.
  ///
  /// In en, this message translates to:
  /// **'There are currently no crop schedules available.'**
  String get noCropSchedulesAvailable;

  /// No description provided for @hideDetails.
  ///
  /// In en, this message translates to:
  /// **'Hide Details'**
  String get hideDetails;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @closeScheduleInformation.
  ///
  /// In en, this message translates to:
  /// **'Close schedule information'**
  String get closeScheduleInformation;

  /// No description provided for @viewCompleteSchedule.
  ///
  /// In en, this message translates to:
  /// **'View complete schedule'**
  String get viewCompleteSchedule;

  /// No description provided for @scheduleDetails.
  ///
  /// In en, this message translates to:
  /// **'Schedule Details'**
  String get scheduleDetails;

  /// No description provided for @cropActivityTimeline.
  ///
  /// In en, this message translates to:
  /// **'Crop activity timeline'**
  String get cropActivityTimeline;

  /// No description provided for @noScheduleDetailsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No schedule details available.'**
  String get noScheduleDetailsAvailable;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'IMAGE'**
  String get image;

  /// No description provided for @downloadingPdf.
  ///
  /// In en, this message translates to:
  /// **'Downloading PDF...'**
  String get downloadingPdf;

  /// No description provided for @tapToDownloadOrOpen.
  ///
  /// In en, this message translates to:
  /// **'Tap to download / open'**
  String get tapToDownloadOrOpen;

  /// No description provided for @tapToViewImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to view image'**
  String get tapToViewImage;

  /// No description provided for @preparingDownload.
  ///
  /// In en, this message translates to:
  /// **'Preparing download...'**
  String get preparingDownload;

  /// No description provided for @imageUrlUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Image URL not available'**
  String get imageUrlUnavailable;

  /// No description provided for @pdfDownloadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'PDF downloaded successfully'**
  String get pdfDownloadedSuccessfully;

  /// No description provided for @pdfDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'PDF download failed'**
  String get pdfDownloadFailed;

  /// No description provided for @pdfFileNotFound.
  ///
  /// In en, this message translates to:
  /// **'PDF file not found'**
  String get pdfFileNotFound;

  /// No description provided for @pdfViewerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No PDF viewer available on this device'**
  String get pdfViewerUnavailable;

  /// No description provided for @availableCropScheduleCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 crop schedule available} other{{count} crop schedules available}}'**
  String availableCropScheduleCount(int count);

  /// No description provided for @scheduleStepCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Step} other{{count} Steps}}'**
  String scheduleStepCount(int count);

  /// No description provided for @farmerLoginMissing.
  ///
  /// In en, this message translates to:
  /// **'Farmer login information not found'**
  String get farmerLoginMissing;

  /// No description provided for @unableToLoadPlots.
  ///
  /// In en, this message translates to:
  /// **'Unable to load plots'**
  String get unableToLoadPlots;

  /// No description provided for @plotsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load plots. Please try again.'**
  String get plotsLoadError;

  /// No description provided for @noPlotsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No plots available'**
  String get noPlotsAvailable;

  /// No description provided for @registeredFarmlandHint.
  ///
  /// In en, this message translates to:
  /// **'Your registered farmland will appear here.'**
  String get registeredFarmlandHint;

  /// No description provided for @loadMorePlotsError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load more plots. Tap to retry'**
  String get loadMorePlotsError;

  /// No description provided for @myRegisteredPlots.
  ///
  /// In en, this message translates to:
  /// **'My Registered Plots'**
  String get myRegisteredPlots;

  /// No description provided for @fieldsAndCropDetails.
  ///
  /// In en, this message translates to:
  /// **'Your fields and crop details'**
  String get fieldsAndCropDetails;

  /// No description provided for @unnamedPlot.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Plot'**
  String get unnamedPlot;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @cropName.
  ///
  /// In en, this message translates to:
  /// **'CROP NAME'**
  String get cropName;

  /// No description provided for @sowingDate.
  ///
  /// In en, this message translates to:
  /// **'SOWING DATE'**
  String get sowingDate;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @invalidDateRange.
  ///
  /// In en, this message translates to:
  /// **'From Date cannot be after To Date'**
  String get invalidDateRange;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @selectStatus.
  ///
  /// In en, this message translates to:
  /// **'Select status'**
  String get selectStatus;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get fromDate;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get toDate;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @confirmProductsApplied.
  ///
  /// In en, this message translates to:
  /// **'Confirm products applied'**
  String get confirmProductsApplied;

  /// No description provided for @productsAppliedConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Have you applied all products in this schedule?'**
  String get productsAppliedConfirmation;

  /// No description provided for @scheduleUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Schedule updated successfully'**
  String get scheduleUpdatedSuccessfully;

  /// No description provided for @unableToUpdateSchedule.
  ///
  /// In en, this message translates to:
  /// **'Unable to update schedule'**
  String get unableToUpdateSchedule;

  /// No description provided for @plotIdMissing.
  ///
  /// In en, this message translates to:
  /// **'Plot ID is missing'**
  String get plotIdMissing;

  /// No description provided for @pleaseLoginAgain.
  ///
  /// In en, this message translates to:
  /// **'Please login again'**
  String get pleaseLoginAgain;

  /// No description provided for @plotSchedules.
  ///
  /// In en, this message translates to:
  /// **'Plot Schedules'**
  String get plotSchedules;

  /// No description provided for @noSchedulesFound.
  ///
  /// In en, this message translates to:
  /// **'No schedules found'**
  String get noSchedulesFound;

  /// No description provided for @loadingMatchingSchedules.
  ///
  /// In en, this message translates to:
  /// **'Loading matching schedules...'**
  String get loadingMatchingSchedules;

  /// No description provided for @noSchedulesMatchFilters.
  ///
  /// In en, this message translates to:
  /// **'No crop schedules match the selected filters.'**
  String get noSchedulesMatchFilters;

  /// No description provided for @scheduleTimelineHint.
  ///
  /// In en, this message translates to:
  /// **'Today\'s schedules appear by default. Scroll down to load future schedules and up to load past schedules.'**
  String get scheduleTimelineHint;

  /// No description provided for @dosesFor200Liters.
  ///
  /// In en, this message translates to:
  /// **'Note: Doses for 200 liters'**
  String get dosesFor200Liters;

  /// No description provided for @loadMoreSchedulesError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load more schedules. Tap to retry'**
  String get loadMoreSchedulesError;

  /// No description provided for @plotName.
  ///
  /// In en, this message translates to:
  /// **'Plot Name'**
  String get plotName;

  /// No description provided for @consultant.
  ///
  /// In en, this message translates to:
  /// **'Consultant'**
  String get consultant;

  /// No description provided for @noProductDetails.
  ///
  /// In en, this message translates to:
  /// **'No product details'**
  String get noProductDetails;

  /// No description provided for @remarkLabel.
  ///
  /// In en, this message translates to:
  /// **'Remark: '**
  String get remarkLabel;

  /// No description provided for @productsApplied.
  ///
  /// In en, this message translates to:
  /// **'Products applied?'**
  String get productsApplied;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get quantity;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @selectScheduleDateHint.
  ///
  /// In en, this message translates to:
  /// **'Select a date to view schedules'**
  String get selectScheduleDateHint;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @checkingAvailableSchedules.
  ///
  /// In en, this message translates to:
  /// **'Checking available schedules...'**
  String get checkingAvailableSchedules;

  /// No description provided for @scheduleDatesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Schedule dates unavailable'**
  String get scheduleDatesUnavailable;

  /// No description provided for @scheduleAvailableLegend.
  ///
  /// In en, this message translates to:
  /// **'Green dot = Schedule available'**
  String get scheduleAvailableLegend;

  /// No description provided for @todaysSchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get todaysSchedule;

  /// No description provided for @selectedDateSchedule.
  ///
  /// In en, this message translates to:
  /// **'Selected Date Schedule'**
  String get selectedDateSchedule;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @schedules.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get schedules;

  /// No description provided for @unnamedProduct.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Product'**
  String get unnamedProduct;

  /// No description provided for @plotCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Plot} other{{count} Plots}}'**
  String plotCount(int count);

  /// No description provided for @scheduleDateCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Date} other{{count} Dates}}'**
  String scheduleDateCount(int count);

  /// No description provided for @totalProductCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 total product} other{{count} total products}}'**
  String totalProductCount(int count);

  /// No description provided for @scheduleFoundCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Found} other{{count} Found}}'**
  String scheduleFoundCount(int count);

  /// No description provided for @noSchedulesForDate.
  ///
  /// In en, this message translates to:
  /// **'No crop schedules available for {date}.'**
  String noSchedulesForDate(String date);

  /// No description provided for @plotNameValue.
  ///
  /// In en, this message translates to:
  /// **'Plot Name: {name}'**
  String plotNameValue(String name);

  /// No description provided for @consultantName.
  ///
  /// In en, this message translates to:
  /// **'Consultant: {name}'**
  String consultantName(String name);

  /// No description provided for @totalNotificationCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 notification} other{{count} notifications}}'**
  String totalNotificationCount(int count);

  /// No description provided for @financeAddPlotRevenue.
  ///
  /// In en, this message translates to:
  /// **'Add Plot Revenue'**
  String get financeAddPlotRevenue;

  /// No description provided for @financeAddPlotExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Plot Expense'**
  String get financeAddPlotExpense;

  /// No description provided for @financeTransactionDate.
  ///
  /// In en, this message translates to:
  /// **'Transaction Date'**
  String get financeTransactionDate;

  /// No description provided for @financeAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount (₹)'**
  String get financeAmount;

  /// No description provided for @financeEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get financeEnterAmount;

  /// No description provided for @financeInvalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get financeInvalidAmount;

  /// No description provided for @financeRemark.
  ///
  /// In en, this message translates to:
  /// **'Remark'**
  String get financeRemark;

  /// No description provided for @financeRevenueHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Crop sale, Harvest income'**
  String get financeRevenueHint;

  /// No description provided for @financeExpenseHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Seeds, Labour, Fertilizer'**
  String get financeExpenseHint;

  /// No description provided for @financeEnterRemark.
  ///
  /// In en, this message translates to:
  /// **'Please enter remark'**
  String get financeEnterRemark;

  /// No description provided for @financeRevenueAdded.
  ///
  /// In en, this message translates to:
  /// **'Revenue added successfully'**
  String get financeRevenueAdded;

  /// No description provided for @financeExpenseAdded.
  ///
  /// In en, this message translates to:
  /// **'Expense added successfully'**
  String get financeExpenseAdded;

  /// No description provided for @financeDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Entry?'**
  String get financeDeleteTitle;

  /// No description provided for @financeEntryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Entry deleted'**
  String get financeEntryDeleted;

  /// No description provided for @financeUndo.
  ///
  /// In en, this message translates to:
  /// **'UNDO'**
  String get financeUndo;

  /// No description provided for @financeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track Expenses, Revenue & Profit'**
  String get financeSubtitle;

  /// No description provided for @financeTitle.
  ///
  /// In en, this message translates to:
  /// **'Plot Finace'**
  String get financeTitle;

  /// No description provided for @financeExpenseHistory.
  ///
  /// In en, this message translates to:
  /// **'Expense History'**
  String get financeExpenseHistory;

  /// No description provided for @financeRevenueHistory.
  ///
  /// In en, this message translates to:
  /// **'Revenue History'**
  String get financeRevenueHistory;

  /// No description provided for @financeDemoPlot.
  ///
  /// In en, this message translates to:
  /// **'Plot 1'**
  String get financeDemoPlot;

  /// No description provided for @financeDemoCrop.
  ///
  /// In en, this message translates to:
  /// **'Onion  •  1 Acre'**
  String get financeDemoCrop;

  /// No description provided for @financeRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get financeRevenue;

  /// No description provided for @financeExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get financeExpenses;

  /// No description provided for @financeProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get financeProfit;

  /// No description provided for @financeLoss.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get financeLoss;

  /// No description provided for @financeAddExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get financeAddExpense;

  /// No description provided for @financeRecordSpending.
  ///
  /// In en, this message translates to:
  /// **'Record spending'**
  String get financeRecordSpending;

  /// No description provided for @financeAddRevenue.
  ///
  /// In en, this message translates to:
  /// **'Add Revenue'**
  String get financeAddRevenue;

  /// No description provided for @financeRecordIncome.
  ///
  /// In en, this message translates to:
  /// **'Record income'**
  String get financeRecordIncome;

  /// No description provided for @financeNoRevenue.
  ///
  /// In en, this message translates to:
  /// **'No revenue added yet'**
  String get financeNoRevenue;

  /// No description provided for @financeNoExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses added yet'**
  String get financeNoExpenses;

  /// No description provided for @financeDeleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get financeDeleteEntry;

  /// No description provided for @financeProfitSummary.
  ///
  /// In en, this message translates to:
  /// **'Profit Summary'**
  String get financeProfitSummary;

  /// No description provided for @financeNetProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get financeNetProfit;

  /// No description provided for @financeNetLoss.
  ///
  /// In en, this message translates to:
  /// **'Net Loss'**
  String get financeNetLoss;

  /// No description provided for @financeSeeds.
  ///
  /// In en, this message translates to:
  /// **'Seeds'**
  String get financeSeeds;

  /// No description provided for @financeSpray.
  ///
  /// In en, this message translates to:
  /// **'Spray'**
  String get financeSpray;

  /// No description provided for @financeLabour.
  ///
  /// In en, this message translates to:
  /// **'Labour'**
  String get financeLabour;

  /// No description provided for @financeFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer'**
  String get financeFertilizer;

  /// No description provided for @financeFirstYield.
  ///
  /// In en, this message translates to:
  /// **'1st yielded'**
  String get financeFirstYield;

  /// No description provided for @financeSecondYield.
  ///
  /// In en, this message translates to:
  /// **'2nd yield'**
  String get financeSecondYield;

  /// No description provided for @financeEntryCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 entry} other{{count} entries}}'**
  String financeEntryCount(int count);

  /// No description provided for @financeDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete this entry of {amount}?'**
  String financeDeleteMessage(String amount);

  /// No description provided for @scheduleCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get scheduleCompleted;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'mr': return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
