// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get stayUpdated => 'Stay Updated';

  @override
  String get noNotificationsAvailable => 'No notifications available';

  @override
  String get latestUpdates => 'Here are your latest updates';

  @override
  String get recordNotFound => 'Record Not Found';

  @override
  String get unableToLoad => 'Unable to Load';

  @override
  String get notificationLoadError => 'We couldn’t load your notifications.\nPlease check your connection and try again.';

  @override
  String get productCategory => 'Product Category';

  @override
  String get noCategoriesFound => 'No categories found';

  @override
  String get searchProduct => 'Search product...';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get searchingProducts => 'Searching products...';

  @override
  String noProductForQuery(String query) {
    return 'No product found for \"$query\"';
  }

  @override
  String get viewProductDetails => 'View product details';

  @override
  String get categoryNotFound => 'Category Not Found';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get productNotFound => 'Product Not Found';

  @override
  String get productDetails => 'Product Details';

  @override
  String get recommendedDosage => 'Recommended Dosage';

  @override
  String get product => 'Product';

  @override
  String get productContents => 'Product Contents';

  @override
  String get diseaseInformation => 'Disease Information';

  @override
  String get share => 'Share';

  @override
  String get dosage => 'Dosage';

  @override
  String get unableToShareProduct => 'Unable to share product. Please try again.';

  @override
  String get close => 'Close';

  @override
  String productCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Products',
      one: '1 Product',
    );
    return '$_temp0';
  }

  @override
  String get quickReferenceChartReport => 'Quick Reference Chart Report';

  @override
  String get noQuickReferenceFound => 'No quick reference found';

  @override
  String availableReferences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Available References',
      one: 'Available Reference',
    );
    return '$_temp0';
  }

  @override
  String get pdfDocument => 'PDF Document';

  @override
  String get imageReference => 'Image Reference';

  @override
  String get referenceFile => 'Reference File';

  @override
  String get unableToShareImage => 'Unable to share image. Please try again.';

  @override
  String get shareImage => 'Share image';

  @override
  String get unableToLoadImage => 'Unable to load image';

  @override
  String get previousImage => 'Previous image';

  @override
  String get nextImage => 'Next image';

  @override
  String get zoomOut => 'Zoom out';

  @override
  String get resetZoom => 'Reset zoom';

  @override
  String get zoomIn => 'Zoom in';

  @override
  String get unableToOpenPhone => 'Unable to open phone dialer';

  @override
  String get unableToOpenEmail => 'Unable to open email application';

  @override
  String get unableToOpenWebsite => 'Unable to open website';

  @override
  String get getInTouch => 'Get In Touch';

  @override
  String get hereToHelp => 'We are here to help you';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get contactOpenHint => 'Tap phone, email or website to open';

  @override
  String get loadingContactInformation => 'Loading Contact Information...';

  @override
  String get unableToLoadContactUs => 'Unable to Load Contact Us';

  @override
  String get contactLoadError => 'Something went wrong while loading the contact information.';

  @override
  String get aboutOurOrganization => 'About Our Organization';

  @override
  String get learnMoreAboutUs => 'Learn more about us';

  @override
  String get loadingAboutUs => 'Loading About Us...';

  @override
  String get pleaseWaitAMoment => 'Please wait a moment';

  @override
  String get unableToLoadAboutUs => 'Unable to Load About Us';

  @override
  String get organizationLoadError => 'Something went wrong while loading the organization information.';

  @override
  String sharePlatform(String platform) {
    return 'Share $platform';
  }

  @override
  String get unableToShare => 'Unable to share. Please try again.';

  @override
  String socialShareSubject(String platform) {
    return 'Connect with Solufine on $platform';
  }

  @override
  String socialShareMessage(String platform, String link, String storeUrl) {
    return 'Grow together with Solufine! 🌱\n\nConnect with us on $platform for farming updates, inspiration, and the latest from Solufine:\n$link\n\nExplore more with the Solufine app. Download it on Google Play:\n$storeUrl';
  }

  @override
  String get socialLinkUnavailable => 'Social media link is not available';

  @override
  String get invalidSocialUrl => 'Invalid social media URL';

  @override
  String get unableToOpenLink => 'Unable to open this link';

  @override
  String get socialLinksUnavailable => 'Social media links not available';

  @override
  String get connectWithUs => 'Connect With Us';

  @override
  String followOrganization(String organization) {
    return 'Follow $organization';
  }

  @override
  String followUsOn(String platform) {
    return 'Follow us on $platform';
  }

  @override
  String get subscribeYoutube => 'Subscribe to our YouTube channel';

  @override
  String get connectLinkedin => 'Connect with us on LinkedIn';

  @override
  String get joinTelegram => 'Join us on Telegram';

  @override
  String get chatWhatsapp => 'Chat with us on WhatsApp';

  @override
  String get unableToLoadSocialMedia => 'Unable to load social media';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String get farmAtAGlance => 'Your farm, at a glance';

  @override
  String get todaysActivities => 'Today\'s Activities';

  @override
  String get cropSchedule => 'Crop Schedule';

  @override
  String get viewTodaysTasks => 'View today\'s tasks';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNewAlerts => 'No new alerts';

  @override
  String newAlerts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new alerts',
      one: '1 new alert',
    );
    return '$_temp0';
  }

  @override
  String get myPlots => 'My Plots';

  @override
  String get plots => 'Plots';

  @override
  String get products => 'Products';

  @override
  String get nearDealers => 'Near Dealers';

  @override
  String get quickReference => 'Quick Reference';

  @override
  String get weather => 'Weather';

  @override
  String get importantLinks => 'Important Links';

  @override
  String get cropAdvice => 'Crop Advice';

  @override
  String get gallery => 'Gallery';

  @override
  String get socialMedia => 'Social Media';

  @override
  String get aboutUs => 'About Us';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get quickAccess => 'Quick Access';

  @override
  String get aiPoweredFarming => 'AI POWERED FARMING';

  @override
  String get growSmarter => 'Grow smarter. Harvest better.';

  @override
  String get betterDecisions => 'Better decisions for every season.';

  @override
  String get logoutError => 'Unable to log out. Please try again.';

  @override
  String get languageHint => 'Choose the language you’re most comfortable with.';

  @override
  String get languageSaveError => 'Unable to save language. Please try again.';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get fullName => 'Full Name';

  @override
  String get state => 'State';

  @override
  String get taluka => 'Taluka';

  @override
  String get address => 'Address';

  @override
  String get notAvailable => 'Not available';

  @override
  String get appName => 'My Application';

  @override
  String get welcome => 'Welcome';

  @override
  String get home => 'Home';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get hindi => 'Hindi';

  @override
  String get marathi => 'Marathi';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get submit => 'Submit';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get update => 'Update';

  @override
  String get delete => 'Delete';

  @override
  String get search => 'Search';

  @override
  String get name => 'Name';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Loading...';

  @override
  String get noDataFound => 'No data found';

  @override
  String get getOtpError => 'Failed to get OTP';

  @override
  String get loginWithMobile => 'Login with your mobile number';

  @override
  String get enterMobileNumber => 'Enter mobile number';

  @override
  String get invalidMobileNumber => 'Please enter valid mobile number';

  @override
  String get sendingOtp => 'Sending OTP...';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get farmerConsultantBenefits => 'Benefits of Farmer Consultant';

  @override
  String get cropAdvisoryBenefit => 'Crop\nAdvisory';

  @override
  String get weatherUpdatesBenefit => 'Weather\nUpdates';

  @override
  String get pestDiseaseAlertsBenefit => 'Pest Disease\nAlerts';

  @override
  String get marketRateInfoBenefit => 'Market\nRate Info';

  @override
  String get dataPrivacyNotice => 'Your data is safe with us and will never be shared.';

  @override
  String get invalidOtp => 'Please enter valid 4-digit OTP';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get enterOtpHint => 'Enter the 4-digit OTP sent to your mobile';

  @override
  String get verifyingOtp => 'Verifying...';

  @override
  String get invalidLink => 'Invalid link';

  @override
  String get noImportantLinksFound => 'No important links found';

  @override
  String get importantLinksLoadError => 'Unable to load important links. Please try again.';

  @override
  String get images => 'Images';

  @override
  String get videos => 'Videos';

  @override
  String get certificates => 'Certificates';

  @override
  String get certificate => 'Certificate';

  @override
  String get noImagesAvailable => 'No images available';

  @override
  String get noVideosAvailable => 'No videos available';

  @override
  String get noCertificatesAvailable => 'No certificates available';

  @override
  String get refresh => 'Refresh';

  @override
  String get galleryLoadError => 'Unable to load gallery. Please try again.';

  @override
  String get unableToOpenYoutube => 'Unable to open YouTube. Please check your internet connection or browser.';

  @override
  String get unableToOpenPdf => 'Unable to open PDF';

  @override
  String get nearFertilizerShop => 'Near Fertilizer Shop';

  @override
  String get dealerSignInRequired => 'Please sign in again to load nearby dealers.';

  @override
  String get dealerLoadError => 'Unable to load nearby dealers. Please try again.';

  @override
  String get dealerLocationUnavailable => 'Dealer location is not available. Please update it first.';

  @override
  String get locationAccessError => 'Unable to get your location. Enable GPS and allow location access.';

  @override
  String get unableToOpenMaps => 'Unable to open Google Maps. Please try again.';

  @override
  String get unableToOpenDirections => 'Unable to open directions. Please try again.';

  @override
  String get locationUnavailable => 'Location unavailable';

  @override
  String get noNearbyDealers => 'No dealers found nearby';

  @override
  String get dealerMobileUnavailable => 'A valid dealer mobile number is not available.';

  @override
  String get unableToOpenWhatsApp => 'Unable to open WhatsApp. Please try again.';

  @override
  String get unknownDealer => 'Unknown dealer';

  @override
  String get addressUnavailable => 'Address not available';

  @override
  String get mobileNumberUnavailable => 'Mobile number not available';

  @override
  String get call => 'Call';

  @override
  String get directions => 'Directions';

  @override
  String get whatsApp => 'WhatsApp';

  @override
  String dealerDistanceAway(String distance) {
    return '$distance km';
  }

  @override
  String locationCoordinates(String latitude, String longitude) {
    return 'Lat $latitude   |   Long $longitude';
  }

  @override
  String get cropPlanning => 'Crop Planning';

  @override
  String get cropScheduleLoadError => 'Unable to load crop schedule. Please try again.';

  @override
  String get unableToLoadSchedules => 'Unable to load schedules';

  @override
  String get noCropSchedule => 'No Crop Schedule';

  @override
  String get noCropSchedulesAvailable => 'There are currently no crop schedules available.';

  @override
  String get hideDetails => 'Hide Details';

  @override
  String get viewDetails => 'View Details';

  @override
  String get closeScheduleInformation => 'Close schedule information';

  @override
  String get viewCompleteSchedule => 'View complete schedule';

  @override
  String get scheduleDetails => 'Schedule Details';

  @override
  String get cropActivityTimeline => 'Crop activity timeline';

  @override
  String get noScheduleDetailsAvailable => 'No schedule details available.';

  @override
  String get image => 'IMAGE';

  @override
  String get downloadingPdf => 'Downloading PDF...';

  @override
  String get tapToDownloadOrOpen => 'Tap to download / open';

  @override
  String get tapToViewImage => 'Tap to view image';

  @override
  String get preparingDownload => 'Preparing download...';

  @override
  String get imageUrlUnavailable => 'Image URL not available';

  @override
  String get pdfDownloadedSuccessfully => 'PDF downloaded successfully';

  @override
  String get pdfDownloadFailed => 'PDF download failed';

  @override
  String get pdfFileNotFound => 'PDF file not found';

  @override
  String get pdfViewerUnavailable => 'No PDF viewer available on this device';

  @override
  String availableCropScheduleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count crop schedules available',
      one: '1 crop schedule available',
    );
    return '$_temp0';
  }

  @override
  String scheduleStepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Steps',
      one: '1 Step',
    );
    return '$_temp0';
  }

  @override
  String get farmerLoginMissing => 'Farmer login information not found';

  @override
  String get unableToLoadPlots => 'Unable to load plots';

  @override
  String get plotsLoadError => 'Unable to load plots. Please try again.';

  @override
  String get noPlotsAvailable => 'No plots available';

  @override
  String get registeredFarmlandHint => 'Your registered farmland will appear here.';

  @override
  String get loadMorePlotsError => 'Unable to load more plots. Tap to retry';

  @override
  String get myRegisteredPlots => 'My Registered Plots';

  @override
  String get fieldsAndCropDetails => 'Your fields and crop details';

  @override
  String get unnamedPlot => 'Unnamed Plot';

  @override
  String get schedule => 'Schedule';

  @override
  String get cropName => 'CROP NAME';

  @override
  String get sowingDate => 'SOWING DATE';

  @override
  String get selectDate => 'Select date';

  @override
  String get invalidDateRange => 'From Date cannot be after To Date';

  @override
  String get status => 'Status';

  @override
  String get selectStatus => 'Select status';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get fromDate => 'From Date';

  @override
  String get toDate => 'To Date';

  @override
  String get clear => 'Clear';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get confirmProductsApplied => 'Confirm products applied';

  @override
  String get productsAppliedConfirmation => 'Have you applied all products in this schedule?';

  @override
  String get scheduleUpdatedSuccessfully => 'Schedule updated successfully';

  @override
  String get unableToUpdateSchedule => 'Unable to update schedule';

  @override
  String get plotIdMissing => 'Plot ID is missing';

  @override
  String get pleaseLoginAgain => 'Please login again';

  @override
  String get plotSchedules => 'Plot Schedules';

  @override
  String get noSchedulesFound => 'No schedules found';

  @override
  String get loadingMatchingSchedules => 'Loading matching schedules...';

  @override
  String get noSchedulesMatchFilters => 'No crop schedules match the selected filters.';

  @override
  String get scheduleTimelineHint => 'Today\'s schedules appear by default. Scroll down to load future schedules and up to load past schedules.';

  @override
  String get dosesFor200Liters => 'Note: Doses for 200 liters';

  @override
  String get loadMoreSchedulesError => 'Unable to load more schedules. Tap to retry';

  @override
  String get plotName => 'Plot Name';

  @override
  String get consultant => 'Consultant';

  @override
  String get noProductDetails => 'No product details';

  @override
  String get remarkLabel => 'Remark: ';

  @override
  String get productsApplied => 'Products applied?';

  @override
  String get quantity => 'Qty';

  @override
  String get water => 'Water';

  @override
  String get selectScheduleDateHint => 'Select a date to view schedules';

  @override
  String get today => 'Today';

  @override
  String get checkingAvailableSchedules => 'Checking available schedules...';

  @override
  String get scheduleDatesUnavailable => 'Schedule dates unavailable';

  @override
  String get scheduleAvailableLegend => 'Green dot = Schedule available';

  @override
  String get todaysSchedule => 'Today\'s Schedule';

  @override
  String get selectedDateSchedule => 'Selected Date Schedule';

  @override
  String get available => 'Available';

  @override
  String get schedules => 'Schedules';

  @override
  String get unnamedProduct => 'Unnamed Product';

  @override
  String plotCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Plots',
      one: '1 Plot',
    );
    return '$_temp0';
  }

  @override
  String scheduleDateCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dates',
      one: '1 Date',
    );
    return '$_temp0';
  }

  @override
  String totalProductCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count total products',
      one: '1 total product',
    );
    return '$_temp0';
  }

  @override
  String scheduleFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Found',
      one: '1 Found',
    );
    return '$_temp0';
  }

  @override
  String noSchedulesForDate(String date) {
    return 'No crop schedules available for $date.';
  }

  @override
  String plotNameValue(String name) {
    return 'Plot Name: $name';
  }

  @override
  String consultantName(String name) {
    return 'Consultant: $name';
  }

  @override
  String totalNotificationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count notifications',
      one: '1 notification',
    );
    return '$_temp0';
  }
}
