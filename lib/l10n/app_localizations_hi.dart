// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get date => 'तारीख';

  @override
  String get time => 'समय';

  @override
  String get stayUpdated => 'अपडेट रहें';

  @override
  String get noNotificationsAvailable => 'कोई सूचना उपलब्ध नहीं है';

  @override
  String get latestUpdates => 'आपके लिए ताज़ा अपडेट';

  @override
  String get recordNotFound => 'रिकॉर्ड नहीं मिला';

  @override
  String get unableToLoad => 'लोड नहीं हो सका';

  @override
  String get notificationLoadError => 'आपकी सूचनाएँ लोड नहीं हो सकीं।\nकृपया इंटरनेट कनेक्शन जाँचें और फिर से कोशिश करें।';

  @override
  String get productCategory => 'उत्पाद श्रेणी';

  @override
  String get noCategoriesFound => 'कोई श्रेणी नहीं मिली';

  @override
  String get searchProduct => 'उत्पाद खोजें...';

  @override
  String get clearSearch => 'खोज साफ़ करें';

  @override
  String get searchingProducts => 'उत्पाद खोज रहे हैं...';

  @override
  String noProductForQuery(String query) {
    return '\"$query\" के लिए कोई उत्पाद नहीं मिला';
  }

  @override
  String get viewProductDetails => 'उत्पाद की जानकारी देखें';

  @override
  String get categoryNotFound => 'श्रेणी नहीं मिली';

  @override
  String get noProductsFound => 'कोई उत्पाद नहीं मिला';

  @override
  String get productNotFound => 'उत्पाद नहीं मिला';

  @override
  String get productDetails => 'उत्पाद की जानकारी';

  @override
  String get recommendedDosage => 'अनुशंसित मात्रा';

  @override
  String get product => 'उत्पाद';

  @override
  String get productContents => 'उत्पाद के घटक';

  @override
  String get diseaseInformation => 'रोग की जानकारी';

  @override
  String get share => 'शेयर करें';

  @override
  String get dosage => 'उपयोग की मात्रा';

  @override
  String get unableToShareProduct => 'उत्पाद शेयर नहीं किया जा सका। कृपया फिर से कोशिश करें।';

  @override
  String get close => 'बंद करें';

  @override
  String productCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count उत्पाद',
      one: '1 उत्पाद',
    );
    return '$_temp0';
  }

  @override
  String get quickReferenceChartReport => 'त्वरित संदर्भ चार्ट रिपोर्ट';

  @override
  String get noQuickReferenceFound => 'कोई त्वरित संदर्भ नहीं मिला';

  @override
  String availableReferences(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'उपलब्ध संदर्भ',
      one: 'उपलब्ध संदर्भ',
    );
    return '$_temp0';
  }

  @override
  String get pdfDocument => 'PDF दस्तावेज़';

  @override
  String get imageReference => 'चित्र संदर्भ';

  @override
  String get referenceFile => 'संदर्भ फ़ाइल';

  @override
  String get unableToShareImage => 'चित्र शेयर नहीं किया जा सका। कृपया फिर से कोशिश करें।';

  @override
  String get shareImage => 'चित्र शेयर करें';

  @override
  String get unableToLoadImage => 'चित्र लोड नहीं हो सका';

  @override
  String get previousImage => 'पिछला चित्र';

  @override
  String get nextImage => 'अगला चित्र';

  @override
  String get zoomOut => 'छोटा करें';

  @override
  String get resetZoom => 'मूल आकार';

  @override
  String get zoomIn => 'बड़ा करें';

  @override
  String get unableToOpenPhone => 'फ़ोन डायलर नहीं खोला जा सका';

  @override
  String get unableToOpenEmail => 'ईमेल ऐप नहीं खोला जा सका';

  @override
  String get unableToOpenWebsite => 'वेबसाइट नहीं खोली जा सकी';

  @override
  String get getInTouch => 'हमसे संपर्क करें';

  @override
  String get hereToHelp => 'हम आपकी मदद के लिए हैं';

  @override
  String get contactInformation => 'संपर्क जानकारी';

  @override
  String get contactOpenHint => 'फ़ोन, ईमेल या वेबसाइट खोलने के लिए टैप करें';

  @override
  String get loadingContactInformation => 'संपर्क जानकारी लोड हो रही है...';

  @override
  String get unableToLoadContactUs => 'संपर्क जानकारी लोड नहीं हो सकी';

  @override
  String get contactLoadError => 'संपर्क जानकारी लोड करते समय कुछ गड़बड़ हो गई।';

  @override
  String get aboutOurOrganization => 'हमारी संस्था के बारे में';

  @override
  String get learnMoreAboutUs => 'हमारे बारे में और जानें';

  @override
  String get loadingAboutUs => 'हमारे बारे में जानकारी लोड हो रही है...';

  @override
  String get pleaseWaitAMoment => 'कृपया थोड़ी देर प्रतीक्षा करें';

  @override
  String get unableToLoadAboutUs => 'हमारे बारे में जानकारी लोड नहीं हो सकी';

  @override
  String get organizationLoadError => 'संस्था की जानकारी लोड करते समय कुछ गड़बड़ हो गई।';

  @override
  String sharePlatform(String platform) {
    return '$platform शेयर करें';
  }

  @override
  String get unableToShare => 'शेयर नहीं किया जा सका। कृपया फिर से कोशिश करें।';

  @override
  String socialShareSubject(String platform) {
    return '$platform पर Solufine से जुड़ें';
  }

  @override
  String socialShareMessage(String platform, String link, String storeUrl) {
    return 'Solufine के साथ आगे बढ़ें! 🌱\n\nखेती की जानकारी, प्रेरणा और Solufine की ताज़ा खबरों के लिए $platform पर हमसे जुड़ें:\n$link\n\nSolufine ऐप पर और जानें। Google Play से डाउनलोड करें:\n$storeUrl';
  }

  @override
  String get socialLinkUnavailable => 'सोशल मीडिया लिंक उपलब्ध नहीं है';

  @override
  String get invalidSocialUrl => 'सोशल मीडिया लिंक मान्य नहीं है';

  @override
  String get unableToOpenLink => 'यह लिंक नहीं खोला जा सका';

  @override
  String get socialLinksUnavailable => 'सोशल मीडिया लिंक उपलब्ध नहीं हैं';

  @override
  String get connectWithUs => 'हमसे जुड़ें';

  @override
  String followOrganization(String organization) {
    return '$organization को फ़ॉलो करें';
  }

  @override
  String followUsOn(String platform) {
    return '$platform पर हमें फ़ॉलो करें';
  }

  @override
  String get subscribeYoutube => 'हमारे YouTube चैनल को सब्सक्राइब करें';

  @override
  String get connectLinkedin => 'LinkedIn पर हमसे जुड़ें';

  @override
  String get joinTelegram => 'Telegram पर हमसे जुड़ें';

  @override
  String get chatWhatsapp => 'WhatsApp पर हमसे बात करें';

  @override
  String get unableToLoadSocialMedia => 'सोशल मीडिया लोड नहीं हो सका';

  @override
  String get somethingWentWrong => 'कुछ गड़बड़ हो गई';

  @override
  String get retry => 'फिर से कोशिश करें';

  @override
  String get farmAtAGlance => 'आपकी खेती, एक नज़र में';

  @override
  String get todaysActivities => 'आज के काम';

  @override
  String get cropSchedule => 'फसल की समय-सारणी';

  @override
  String get viewTodaysTasks => 'आज के काम देखें';

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String get noNewAlerts => 'कोई नई सूचना नहीं';

  @override
  String newAlerts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count नई सूचनाएँ',
      one: '1 नई सूचना',
    );
    return '$_temp0';
  }

  @override
  String get myPlots => 'मेरे खेत';

  @override
  String get plots => 'खेत';

  @override
  String get products => 'उत्पाद';

  @override
  String get nearDealers => 'नज़दीकी विक्रेता';

  @override
  String get quickReference => 'त्वरित संदर्भ';

  @override
  String get weather => 'मौसम';

  @override
  String get importantLinks => 'महत्वपूर्ण लिंक';

  @override
  String get cropAdvice => 'फसल सलाह';

  @override
  String get gallery => 'तस्वीरें';

  @override
  String get socialMedia => 'सोशल मीडिया';

  @override
  String get aboutUs => 'हमारे बारे में';

  @override
  String get contactUs => 'संपर्क करें';

  @override
  String get quickAccess => 'त्वरित पहुँच';

  @override
  String get aiPoweredFarming => 'कृत्रिम बुद्धिमत्ता से खेती';

  @override
  String get growSmarter => 'स्मार्ट खेती करें. बेहतर उपज पाएँ.';

  @override
  String get betterDecisions => 'हर मौसम के लिए बेहतर निर्णय.';

  @override
  String get logoutError => 'लॉगआउट नहीं हो सका। कृपया फिर से कोशिश करें।';

  @override
  String get languageHint => 'अपनी पसंद की भाषा चुनें।';

  @override
  String get languageSaveError => 'भाषा सहेजी नहीं जा सकी। कृपया फिर से कोशिश करें।';

  @override
  String get personalInformation => 'व्यक्तिगत जानकारी';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get state => 'राज्य';

  @override
  String get taluka => 'तहसील';

  @override
  String get address => 'पता';

  @override
  String get notAvailable => 'उपलब्ध नहीं है';

  @override
  String get appName => 'मेरा एप्लिकेशन';

  @override
  String get welcome => 'स्वागत है';

  @override
  String get home => 'होम';

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get language => 'भाषा';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get marathi => 'मराठी';

  @override
  String get login => 'लॉगिन';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get submit => 'जमा करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सेव करें';

  @override
  String get update => 'अपडेट करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get search => 'खोजें';

  @override
  String get name => 'नाम';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get success => 'सफल';

  @override
  String get error => 'त्रुटि';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get noDataFound => 'कोई डेटा नहीं मिला';

  @override
  String get getOtpError => 'OTP प्राप्त नहीं हो सका';

  @override
  String get loginWithMobile => 'अपने मोबाइल नंबर से लॉगिन करें';

  @override
  String get enterMobileNumber => 'मोबाइल नंबर दर्ज करें';

  @override
  String get invalidMobileNumber => 'कृपया सही मोबाइल नंबर दर्ज करें';

  @override
  String get sendingOtp => 'OTP भेजा जा रहा है...';

  @override
  String get sendOtp => 'OTP भेजें';

  @override
  String get farmerConsultantBenefits => 'फार्मर कंसल्टेंट के लाभ';

  @override
  String get cropAdvisoryBenefit => 'फसल\nसलाह';

  @override
  String get weatherUpdatesBenefit => 'मौसम की\nजानकारी';

  @override
  String get pestDiseaseAlertsBenefit => 'कीट व रोग\nअलर्ट';

  @override
  String get marketRateInfoBenefit => 'बाजार भाव\nजानकारी';

  @override
  String get dataPrivacyNotice => 'आपका डेटा हमारे पास सुरक्षित है और कभी साझा नहीं किया जाएगा।';

  @override
  String get invalidOtp => 'कृपया सही 4 अंकों का OTP दर्ज करें';

  @override
  String get loginFailed => 'लॉगिन नहीं हो सका';

  @override
  String get verifyOtp => 'OTP सत्यापित करें';

  @override
  String get enterOtpHint => 'अपने मोबाइल पर भेजा गया 4 अंकों का OTP दर्ज करें';

  @override
  String get verifyingOtp => 'सत्यापित किया जा रहा है...';

  @override
  String get invalidLink => 'अमान्य लिंक';

  @override
  String get noImportantLinksFound => 'कोई महत्वपूर्ण लिंक नहीं मिला';

  @override
  String get importantLinksLoadError => 'महत्वपूर्ण लिंक लोड नहीं हो सके। कृपया फिर से कोशिश करें।';

  @override
  String get images => 'चित्र';

  @override
  String get videos => 'वीडियो';

  @override
  String get certificates => 'प्रमाणपत्र';

  @override
  String get certificate => 'प्रमाणपत्र';

  @override
  String get noImagesAvailable => 'कोई चित्र उपलब्ध नहीं है';

  @override
  String get noVideosAvailable => 'कोई वीडियो उपलब्ध नहीं है';

  @override
  String get noCertificatesAvailable => 'कोई प्रमाणपत्र उपलब्ध नहीं है';

  @override
  String get refresh => 'रिफ्रेश करें';

  @override
  String get galleryLoadError => 'गैलरी लोड नहीं हो सकी। कृपया फिर से कोशिश करें।';

  @override
  String get unableToOpenYoutube => 'YouTube नहीं खुल सका। कृपया अपना इंटरनेट कनेक्शन या ब्राउज़र जाँचें।';

  @override
  String get unableToOpenPdf => 'PDF नहीं खुल सका';

  @override
  String get nearFertilizerShop => 'नज़दीकी उर्वरक दुकान';

  @override
  String get dealerSignInRequired => 'नज़दीकी विक्रेताओं को देखने के लिए कृपया दोबारा लॉगिन करें।';

  @override
  String get dealerLoadError => 'नज़दीकी विक्रेताओं की जानकारी लोड नहीं हो सकी। कृपया फिर से कोशिश करें।';

  @override
  String get dealerLocationUnavailable => 'विक्रेता का स्थान उपलब्ध नहीं है। कृपया पहले इसे अपडेट करें।';

  @override
  String get locationAccessError => 'आपका स्थान प्राप्त नहीं हो सका। GPS चालू करें और स्थान की अनुमति दें।';

  @override
  String get unableToOpenMaps => 'Google Maps नहीं खुल सका। कृपया फिर से कोशिश करें।';

  @override
  String get unableToOpenDirections => 'रास्ता नहीं दिखाया जा सका। कृपया फिर से कोशिश करें।';

  @override
  String get locationUnavailable => 'स्थान उपलब्ध नहीं है';

  @override
  String get noNearbyDealers => 'आस-पास कोई विक्रेता नहीं मिला';

  @override
  String get dealerMobileUnavailable => 'विक्रेता का सही मोबाइल नंबर उपलब्ध नहीं है।';

  @override
  String get unableToOpenWhatsApp => 'WhatsApp नहीं खुल सका। कृपया फिर से कोशिश करें।';

  @override
  String get unknownDealer => 'अज्ञात विक्रेता';

  @override
  String get addressUnavailable => 'पता उपलब्ध नहीं है';

  @override
  String get mobileNumberUnavailable => 'मोबाइल नंबर उपलब्ध नहीं है';

  @override
  String get call => 'कॉल करें';

  @override
  String get directions => 'रास्ता देखें';

  @override
  String get whatsApp => 'WhatsApp';

  @override
  String dealerDistanceAway(String distance) {
    return '$distance किमी';
  }

  @override
  String locationCoordinates(String latitude, String longitude) {
    return 'अक्षांश $latitude   |   देशांतर $longitude';
  }

  @override
  String get cropPlanning => 'फसल योजना';

  @override
  String get cropScheduleLoadError => 'फसल कार्यक्रम लोड नहीं हो सका। कृपया फिर से कोशिश करें।';

  @override
  String get unableToLoadSchedules => 'कार्यक्रम लोड नहीं हो सके';

  @override
  String get noCropSchedule => 'कोई फसल कार्यक्रम नहीं है';

  @override
  String get noCropSchedulesAvailable => 'फ़िलहाल कोई फसल कार्यक्रम उपलब्ध नहीं है।';

  @override
  String get hideDetails => 'विवरण छिपाएँ';

  @override
  String get viewDetails => 'विवरण देखें';

  @override
  String get closeScheduleInformation => 'कार्यक्रम की जानकारी बंद करें';

  @override
  String get viewCompleteSchedule => 'पूरा कार्यक्रम देखें';

  @override
  String get scheduleDetails => 'कार्यक्रम का विवरण';

  @override
  String get cropActivityTimeline => 'फसल गतिविधियों की समयरेखा';

  @override
  String get noScheduleDetailsAvailable => 'कार्यक्रम का विवरण उपलब्ध नहीं है।';

  @override
  String get image => 'चित्र';

  @override
  String get downloadingPdf => 'PDF डाउनलोड हो रही है...';

  @override
  String get tapToDownloadOrOpen => 'डाउनलोड करने / खोलने के लिए टैप करें';

  @override
  String get tapToViewImage => 'चित्र देखने के लिए टैप करें';

  @override
  String get preparingDownload => 'डाउनलोड की तैयारी हो रही है...';

  @override
  String get imageUrlUnavailable => 'चित्र का URL उपलब्ध नहीं है';

  @override
  String get pdfDownloadedSuccessfully => 'PDF सफलतापूर्वक डाउनलोड हो गई';

  @override
  String get pdfDownloadFailed => 'PDF डाउनलोड नहीं हो सकी';

  @override
  String get pdfFileNotFound => 'PDF फ़ाइल नहीं मिली';

  @override
  String get pdfViewerUnavailable => 'इस डिवाइस पर PDF व्यूअर उपलब्ध नहीं है';

  @override
  String availableCropScheduleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फसल कार्यक्रम उपलब्ध हैं',
      one: '1 फसल कार्यक्रम उपलब्ध है',
    );
    return '$_temp0';
  }

  @override
  String scheduleStepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count चरण',
      one: '1 चरण',
    );
    return '$_temp0';
  }

  @override
  String get farmerLoginMissing => 'किसान की लॉगिन जानकारी नहीं मिली';

  @override
  String get unableToLoadPlots => 'खेत लोड नहीं हो सके';

  @override
  String get plotsLoadError => 'खेत लोड नहीं हो सके। कृपया फिर से कोशिश करें।';

  @override
  String get noPlotsAvailable => 'कोई खेत उपलब्ध नहीं है';

  @override
  String get registeredFarmlandHint => 'आपके पंजीकृत खेत यहाँ दिखाई देंगे।';

  @override
  String get loadMorePlotsError => 'और खेत लोड नहीं हो सके। फिर से कोशिश करने के लिए टैप करें';

  @override
  String get myRegisteredPlots => 'मेरे पंजीकृत खेत';

  @override
  String get fieldsAndCropDetails => 'आपके खेत और फसल का विवरण';

  @override
  String get unnamedPlot => 'बिना नाम का खेत';

  @override
  String get schedule => 'कार्यक्रम';

  @override
  String get cropName => 'फसल का नाम';

  @override
  String get sowingDate => 'बुवाई की तारीख';

  @override
  String get selectDate => 'तारीख चुनें';

  @override
  String get invalidDateRange => 'आरंभ तिथि अंतिम तिथि के बाद नहीं हो सकती';

  @override
  String get status => 'स्थिति';

  @override
  String get selectStatus => 'स्थिति चुनें';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get fromDate => 'आरंभ तिथि';

  @override
  String get toDate => 'अंतिम तिथि';

  @override
  String get clear => 'साफ़ करें';

  @override
  String get applyFilters => 'फ़िल्टर लागू करें';

  @override
  String get confirmProductsApplied => 'उत्पादों के उपयोग की पुष्टि करें';

  @override
  String get productsAppliedConfirmation => 'क्या आपने इस कार्यक्रम के सभी उत्पादों का उपयोग किया है?';

  @override
  String get scheduleUpdatedSuccessfully => 'कार्यक्रम सफलतापूर्वक अपडेट हुआ';

  @override
  String get unableToUpdateSchedule => 'कार्यक्रम अपडेट नहीं हो सका';

  @override
  String get plotIdMissing => 'खेत की आईडी उपलब्ध नहीं है';

  @override
  String get pleaseLoginAgain => 'कृपया दोबारा लॉगिन करें';

  @override
  String get plotSchedules => 'खेत के कार्यक्रम';

  @override
  String get noSchedulesFound => 'कोई कार्यक्रम नहीं मिला';

  @override
  String get loadingMatchingSchedules => 'मिलते-जुलते कार्यक्रम लोड हो रहे हैं...';

  @override
  String get noSchedulesMatchFilters => 'चुने गए फ़िल्टर से कोई फसल कार्यक्रम मेल नहीं खाता।';

  @override
  String get scheduleTimelineHint => 'आज के कार्यक्रम अपने आप दिखाई देते हैं। आगे के कार्यक्रम देखने के लिए नीचे और पिछले कार्यक्रमों के लिए ऊपर स्क्रॉल करें।';

  @override
  String get dosesFor200Liters => 'नोट: 200 लीटर के लिए मात्रा';

  @override
  String get loadMoreSchedulesError => 'और कार्यक्रम लोड नहीं हो सके। फिर से कोशिश करने के लिए टैप करें';

  @override
  String get plotName => 'खेत का नाम';

  @override
  String get consultant => 'सलाहकार';

  @override
  String get noProductDetails => 'उत्पाद का विवरण उपलब्ध नहीं है';

  @override
  String get remarkLabel => 'टिप्पणी: ';

  @override
  String get productsApplied => 'उत्पादों का उपयोग किया?';

  @override
  String get quantity => 'मात्रा';

  @override
  String get water => 'पानी';

  @override
  String get selectScheduleDateHint => 'कार्यक्रम देखने के लिए तारीख चुनें';

  @override
  String get today => 'आज';

  @override
  String get checkingAvailableSchedules => 'उपलब्ध कार्यक्रम जाँचे जा रहे हैं...';

  @override
  String get scheduleDatesUnavailable => 'कार्यक्रम की तारीखें उपलब्ध नहीं हैं';

  @override
  String get scheduleAvailableLegend => 'हरा बिंदु = कार्यक्रम उपलब्ध है';

  @override
  String get todaysSchedule => 'आज का कार्यक्रम';

  @override
  String get selectedDateSchedule => 'चुनी गई तारीख का कार्यक्रम';

  @override
  String get available => 'उपलब्ध';

  @override
  String get schedules => 'कार्यक्रम';

  @override
  String get unnamedProduct => 'बिना नाम का उत्पाद';

  @override
  String plotCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count खेत',
      one: '1 खेत',
    );
    return '$_temp0';
  }

  @override
  String scheduleDateCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count तारीखें',
      one: '1 तारीख',
    );
    return '$_temp0';
  }

  @override
  String totalProductCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'कुल $count उत्पाद',
      one: 'कुल 1 उत्पाद',
    );
    return '$_temp0';
  }

  @override
  String scheduleFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मिले',
      one: '1 मिला',
    );
    return '$_temp0';
  }

  @override
  String noSchedulesForDate(String date) {
    return '$date के लिए कोई फसल कार्यक्रम उपलब्ध नहीं है।';
  }

  @override
  String plotNameValue(String name) {
    return 'खेत का नाम: $name';
  }

  @override
  String consultantName(String name) {
    return 'सलाहकार: $name';
  }

  @override
  String totalNotificationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सूचनाएँ',
      one: '1 सूचना',
    );
    return '$_temp0';
  }
}
