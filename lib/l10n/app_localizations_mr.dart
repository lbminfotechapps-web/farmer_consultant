// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get date => 'तारीख';

  @override
  String get time => 'वेळ';

  @override
  String get stayUpdated => 'अद्ययावत रहा';

  @override
  String get noNotificationsAvailable => 'सूचना उपलब्ध नाहीत';

  @override
  String get latestUpdates => 'तुमच्यासाठी ताज्या घडामोडी';

  @override
  String get recordNotFound => 'नोंद सापडली नाही';

  @override
  String get unableToLoad => 'लोड करता आले नाही';

  @override
  String get notificationLoadError => 'तुमच्या सूचना लोड करता आल्या नाहीत.\nकृपया इंटरनेट कनेक्शन तपासा आणि पुन्हा प्रयत्न करा.';

  @override
  String get productCategory => 'उत्पादन प्रकार';

  @override
  String get noCategoriesFound => 'उत्पादन प्रकार सापडले नाहीत';

  @override
  String get searchProduct => 'उत्पादन शोधा...';

  @override
  String get clearSearch => 'शोध पुसा';

  @override
  String get searchingProducts => 'उत्पादने शोधत आहोत...';

  @override
  String noProductForQuery(String query) {
    return '\"$query\" साठी उत्पादन सापडले नाही';
  }

  @override
  String get viewProductDetails => 'उत्पादनाची माहिती पाहा';

  @override
  String get categoryNotFound => 'उत्पादन प्रकार सापडला नाही';

  @override
  String get noProductsFound => 'उत्पादने सापडली नाहीत';

  @override
  String get productNotFound => 'उत्पादन सापडले नाही';

  @override
  String get productDetails => 'उत्पादनाची माहिती';

  @override
  String get recommendedDosage => 'शिफारस केलेले प्रमाण';

  @override
  String get product => 'उत्पादन';

  @override
  String get productContents => 'उत्पादनातील घटक';

  @override
  String get diseaseInformation => 'रोगाविषयी माहिती';

  @override
  String get share => 'शेअर करा';

  @override
  String get dosage => 'वापरण्याचे प्रमाण';

  @override
  String get unableToShareProduct => 'उत्पादन शेअर करता आले नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get close => 'बंद करा';

  @override
  String productCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count उत्पादने',
      one: '1 उत्पादन',
    );
    return '$_temp0';
  }

  @override
  String get quickReferenceChartReport => 'झटपट संदर्भ तक्ता अहवाल';

  @override
  String get noQuickReferenceFound => 'झटपट संदर्भ सापडला नाही';

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
  String get pdfDocument => 'PDF दस्तऐवज';

  @override
  String get imageReference => 'चित्र संदर्भ';

  @override
  String get referenceFile => 'संदर्भ फाइल';

  @override
  String get unableToShareImage => 'चित्र शेअर करता आले नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get shareImage => 'चित्र शेअर करा';

  @override
  String get unableToLoadImage => 'चित्र लोड करता आले नाही';

  @override
  String get previousImage => 'मागील चित्र';

  @override
  String get nextImage => 'पुढील चित्र';

  @override
  String get zoomOut => 'लहान करा';

  @override
  String get resetZoom => 'मूळ आकार';

  @override
  String get zoomIn => 'मोठे करा';

  @override
  String get unableToOpenPhone => 'फोन डायलर उघडता आला नाही';

  @override
  String get unableToOpenEmail => 'ईमेल ॲप उघडता आले नाही';

  @override
  String get unableToOpenWebsite => 'वेबसाइट उघडता आली नाही';

  @override
  String get getInTouch => 'आमच्याशी संपर्क साधा';

  @override
  String get hereToHelp => 'आम्ही तुमच्या मदतीसाठी आहोत';

  @override
  String get contactInformation => 'संपर्क माहिती';

  @override
  String get contactOpenHint => 'फोन, ईमेल किंवा वेबसाइट उघडण्यासाठी टॅप करा';

  @override
  String get loadingContactInformation => 'संपर्क माहिती लोड होत आहे...';

  @override
  String get unableToLoadContactUs => 'संपर्क माहिती लोड करता आली नाही';

  @override
  String get contactLoadError => 'संपर्क माहिती लोड करताना काहीतरी चूक झाली.';

  @override
  String get aboutOurOrganization => 'आमच्या संस्थेबद्दल';

  @override
  String get learnMoreAboutUs => 'आमच्याबद्दल अधिक जाणून घ्या';

  @override
  String get loadingAboutUs => 'आमच्याबद्दलची माहिती लोड होत आहे...';

  @override
  String get pleaseWaitAMoment => 'कृपया थोडा वेळ थांबा';

  @override
  String get unableToLoadAboutUs => 'आमच्याबद्दलची माहिती लोड करता आली नाही';

  @override
  String get organizationLoadError => 'संस्थेची माहिती लोड करताना काहीतरी चूक झाली.';

  @override
  String sharePlatform(String platform) {
    return '$platform शेअर करा';
  }

  @override
  String get unableToShare => 'शेअर करता आले नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String socialShareSubject(String platform) {
    return '$platform वर Solufine सोबत जोडले जा';
  }

  @override
  String socialShareMessage(String platform, String link, String storeUrl) {
    return 'Solufine सोबत प्रगती करा! 🌱\n\nशेतीविषयक माहिती, प्रेरणा आणि Solufine च्या ताज्या घडामोडींसाठी $platform वर आमच्याशी जोडले जा:\n$link\n\nSolufine ॲपवर अधिक जाणून घ्या. Google Play वरून डाउनलोड करा:\n$storeUrl';
  }

  @override
  String get socialLinkUnavailable => 'सोशल मीडियाचा दुवा उपलब्ध नाही';

  @override
  String get invalidSocialUrl => 'सोशल मीडियाचा दुवा वैध नाही';

  @override
  String get unableToOpenLink => 'हा दुवा उघडता आला नाही';

  @override
  String get socialLinksUnavailable => 'सोशल मीडियाचे दुवे उपलब्ध नाहीत';

  @override
  String get connectWithUs => 'आमच्याशी जोडले जा';

  @override
  String followOrganization(String organization) {
    return '$organization यांना फॉलो करा';
  }

  @override
  String followUsOn(String platform) {
    return '$platform वर आम्हाला फॉलो करा';
  }

  @override
  String get subscribeYoutube => 'आमच्या YouTube चॅनेलचे सदस्य व्हा';

  @override
  String get connectLinkedin => 'LinkedIn वर आमच्याशी जोडले जा';

  @override
  String get joinTelegram => 'Telegram वर आमच्यात सहभागी व्हा';

  @override
  String get chatWhatsapp => 'WhatsApp वर आमच्याशी संवाद साधा';

  @override
  String get unableToLoadSocialMedia => 'सोशल मीडिया लोड करता आला नाही';

  @override
  String get somethingWentWrong => 'काहीतरी चूक झाली';

  @override
  String get retry => 'पुन्हा प्रयत्न करा';

  @override
  String get farmAtAGlance => 'तुमच्या शेतीचा एका नजरेत आढावा';

  @override
  String get todaysActivities => 'आजची कामे';

  @override
  String get cropSchedule => 'पीक वेळापत्रक';

  @override
  String get viewTodaysTasks => 'आजची कामे पाहा';

  @override
  String get notifications => 'सूचना';

  @override
  String get noNewAlerts => 'नवीन सूचना नाहीत';

  @override
  String newAlerts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count नवीन सूचना',
      one: '1 नवीन सूचना',
    );
    return '$_temp0';
  }

  @override
  String get myPlots => 'माझे शेत';

  @override
  String get plots => 'शेत';

  @override
  String get products => 'उत्पादने';

  @override
  String get nearDealers => 'जवळचे विक्रेते';

  @override
  String get quickReference => 'झटपट संदर्भ';

  @override
  String get weather => 'हवामान';

  @override
  String get importantLinks => 'महत्त्वाचे दुवे';

  @override
  String get cropAdvice => 'पीक सल्ला';

  @override
  String get gallery => 'छायाचित्रे';

  @override
  String get socialMedia => 'सोशल मीडिया';

  @override
  String get aboutUs => 'आमच्याबद्दल';

  @override
  String get contactUs => 'संपर्क साधा';

  @override
  String get quickAccess => 'झटपट प्रवेश';

  @override
  String get aiPoweredFarming => 'कृत्रिम बुद्धिमत्तेच्या मदतीने शेती';

  @override
  String get growSmarter => 'स्मार्ट शेती करा. भरघोस पीक मिळवा.';

  @override
  String get betterDecisions => 'प्रत्येक हंगामासाठी योग्य निर्णय.';

  @override
  String get logoutError => 'लॉगआउट करता आले नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get languageHint => 'तुमच्या सोयीची भाषा निवडा.';

  @override
  String get languageSaveError => 'भाषा जतन करता आली नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get personalInformation => 'वैयक्तिक माहिती';

  @override
  String get fullName => 'पूर्ण नाव';

  @override
  String get state => 'राज्य';

  @override
  String get taluka => 'तालुका';

  @override
  String get address => 'पत्ता';

  @override
  String get notAvailable => 'उपलब्ध नाही';

  @override
  String get appName => 'माझे ॲप्लिकेशन';

  @override
  String get welcome => 'स्वागत आहे';

  @override
  String get home => 'मुख्यपृष्ठ';

  @override
  String get dashboard => 'डॅशबोर्ड';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get language => 'भाषा';

  @override
  String get selectLanguage => 'भाषा निवडा';

  @override
  String get english => 'इंग्रजी';

  @override
  String get hindi => 'हिंदी';

  @override
  String get marathi => 'मराठी';

  @override
  String get login => 'लॉगिन';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get submit => 'सबमिट करा';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get save => 'जतन करा';

  @override
  String get update => 'अपडेट करा';

  @override
  String get delete => 'हटवा';

  @override
  String get search => 'शोधा';

  @override
  String get name => 'नाव';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get success => 'यशस्वी';

  @override
  String get error => 'त्रुटी';

  @override
  String get loading => 'लोड होत आहे...';

  @override
  String get noDataFound => 'कोणताही डेटा आढळला नाही';

  @override
  String get getOtpError => 'OTP मिळवता आला नाही';

  @override
  String get loginWithMobile => 'तुमच्या मोबाइल नंबरने लॉगिन करा';

  @override
  String get enterMobileNumber => 'मोबाइल नंबर टाका';

  @override
  String get invalidMobileNumber => 'कृपया वैध मोबाइल नंबर टाका';

  @override
  String get sendingOtp => 'OTP पाठवत आहे...';

  @override
  String get sendOtp => 'OTP पाठवा';

  @override
  String get farmerConsultantBenefits => 'फार्मर कन्सल्टंटचे फायदे';

  @override
  String get cropAdvisoryBenefit => 'पीक\nसल्ला';

  @override
  String get weatherUpdatesBenefit => 'हवामान\nअद्यतने';

  @override
  String get pestDiseaseAlertsBenefit => 'कीड व रोग\nसूचना';

  @override
  String get marketRateInfoBenefit => 'बाजारभाव\nमाहिती';

  @override
  String get dataPrivacyNotice => 'तुमचा डेटा आमच्याकडे सुरक्षित आहे आणि कधीही शेअर केला जाणार नाही.';

  @override
  String get invalidOtp => 'कृपया वैध 4 अंकी OTP टाका';

  @override
  String get loginFailed => 'लॉगिन अयशस्वी झाले';

  @override
  String get verifyOtp => 'OTP पडताळा';

  @override
  String get enterOtpHint => 'तुमच्या मोबाइलवर पाठवलेला 4 अंकी OTP टाका';

  @override
  String get verifyingOtp => 'पडताळत आहे...';

  @override
  String get invalidLink => 'अवैध लिंक';

  @override
  String get noImportantLinksFound => 'कोणतेही महत्त्वाचे दुवे आढळले नाहीत';

  @override
  String get importantLinksLoadError => 'महत्त्वाचे दुवे लोड करता आले नाहीत. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get images => 'प्रतिमा';

  @override
  String get videos => 'व्हिडिओ';

  @override
  String get certificates => 'प्रमाणपत्रे';

  @override
  String get certificate => 'प्रमाणपत्र';

  @override
  String get noImagesAvailable => 'कोणत्याही प्रतिमा उपलब्ध नाहीत';

  @override
  String get noVideosAvailable => 'कोणतेही व्हिडिओ उपलब्ध नाहीत';

  @override
  String get noCertificatesAvailable => 'कोणतीही प्रमाणपत्रे उपलब्ध नाहीत';

  @override
  String get refresh => 'रीफ्रेश करा';

  @override
  String get galleryLoadError => 'गॅलरी लोड करता आली नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get unableToOpenYoutube => 'YouTube उघडता आले नाही. कृपया तुमचे इंटरनेट कनेक्शन किंवा ब्राउझर तपासा.';

  @override
  String get unableToOpenPdf => 'PDF उघडता आली नाही';

  @override
  String get nearFertilizerShop => 'जवळचे खत दुकान';

  @override
  String get dealerSignInRequired => 'जवळचे विक्रेते पाहण्यासाठी कृपया पुन्हा लॉगिन करा.';

  @override
  String get dealerLoadError => 'जवळच्या विक्रेत्यांची माहिती लोड करता आली नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get dealerLocationUnavailable => 'विक्रेत्याचे स्थान उपलब्ध नाही. कृपया आधी ते अद्यतनित करा.';

  @override
  String get locationAccessError => 'तुमचे स्थान मिळवता आले नाही. GPS सुरू करा आणि स्थानाची परवानगी द्या.';

  @override
  String get unableToOpenMaps => 'Google Maps उघडता आले नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get unableToOpenDirections => 'मार्ग उघडता आला नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get locationUnavailable => 'स्थान उपलब्ध नाही';

  @override
  String get noNearbyDealers => 'जवळपास कोणतेही विक्रेते आढळले नाहीत';

  @override
  String get dealerMobileUnavailable => 'विक्रेत्याचा वैध मोबाइल नंबर उपलब्ध नाही.';

  @override
  String get unableToOpenWhatsApp => 'WhatsApp उघडता आले नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get unknownDealer => 'अज्ञात विक्रेता';

  @override
  String get addressUnavailable => 'पत्ता उपलब्ध नाही';

  @override
  String get mobileNumberUnavailable => 'मोबाइल नंबर उपलब्ध नाही';

  @override
  String get call => 'कॉल करा';

  @override
  String get directions => 'मार्ग पहा';

  @override
  String get whatsApp => 'WhatsApp';

  @override
  String dealerDistanceAway(String distance) {
    return '$distance किमी';
  }

  @override
  String locationCoordinates(String latitude, String longitude) {
    return 'अक्षांश $latitude   |   रेखांश $longitude';
  }

  @override
  String get cropPlanning => 'पीक नियोजन';

  @override
  String get cropScheduleLoadError => 'पीक वेळापत्रक लोड करता आले नाही. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get unableToLoadSchedules => 'वेळापत्रके लोड करता आली नाहीत';

  @override
  String get noCropSchedule => 'पीक वेळापत्रक नाही';

  @override
  String get noCropSchedulesAvailable => 'सध्या कोणतीही पीक वेळापत्रके उपलब्ध नाहीत.';

  @override
  String get hideDetails => 'तपशील लपवा';

  @override
  String get viewDetails => 'तपशील पहा';

  @override
  String get closeScheduleInformation => 'वेळापत्रकाची माहिती बंद करा';

  @override
  String get viewCompleteSchedule => 'संपूर्ण वेळापत्रक पहा';

  @override
  String get scheduleDetails => 'वेळापत्रकाचा तपशील';

  @override
  String get cropActivityTimeline => 'पीक कामांची कालरेषा';

  @override
  String get noScheduleDetailsAvailable => 'वेळापत्रकाचे तपशील उपलब्ध नाहीत.';

  @override
  String get image => 'प्रतिमा';

  @override
  String get downloadingPdf => 'PDF डाउनलोड होत आहे...';

  @override
  String get tapToDownloadOrOpen => 'डाउनलोड करण्यासाठी / उघडण्यासाठी टॅप करा';

  @override
  String get tapToViewImage => 'प्रतिमा पाहण्यासाठी टॅप करा';

  @override
  String get preparingDownload => 'डाउनलोडची तयारी करत आहे...';

  @override
  String get imageUrlUnavailable => 'प्रतिमेचा URL उपलब्ध नाही';

  @override
  String get pdfDownloadedSuccessfully => 'PDF यशस्वीपणे डाउनलोड झाली';

  @override
  String get pdfDownloadFailed => 'PDF डाउनलोड करता आली नाही';

  @override
  String get pdfFileNotFound => 'PDF फाइल सापडली नाही';

  @override
  String get pdfViewerUnavailable => 'या डिव्हाइसवर PDF पाहण्यासाठी ॲप उपलब्ध नाही';

  @override
  String availableCropScheduleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पीक वेळापत्रके उपलब्ध आहेत',
      one: '1 पीक वेळापत्रक उपलब्ध आहे',
    );
    return '$_temp0';
  }

  @override
  String scheduleStepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count टप्पे',
      one: '1 टप्पा',
    );
    return '$_temp0';
  }

  @override
  String get farmerLoginMissing => 'शेतकऱ्याची लॉगिन माहिती सापडली नाही';

  @override
  String get unableToLoadPlots => 'प्लॉट लोड करता आले नाहीत';

  @override
  String get plotsLoadError => 'प्लॉट लोड करता आले नाहीत. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get noPlotsAvailable => 'कोणतेही प्लॉट उपलब्ध नाहीत';

  @override
  String get registeredFarmlandHint => 'तुमचे नोंदणीकृत प्लॉट येथे दिसतील.';

  @override
  String get loadMorePlotsError => 'आणखी प्लॉट लोड करता आले नाहीत. पुन्हा प्रयत्न करण्यासाठी टॅप करा';

  @override
  String get myRegisteredPlots => 'माझे नोंदणीकृत प्लॉट';

  @override
  String get fieldsAndCropDetails => 'तुमचे प्लॉट आणि पिकांचे तपशील';

  @override
  String get unnamedPlot => 'नाव नसलेला प्लॉट';

  @override
  String get schedule => 'वेळापत्रक';

  @override
  String get cropName => 'पिकाचे नाव';

  @override
  String get sowingDate => 'पेरणीची तारीख';

  @override
  String get selectDate => 'तारीख निवडा';

  @override
  String get invalidDateRange => 'सुरुवातीची तारीख शेवटच्या तारखेनंतर असू शकत नाही';

  @override
  String get status => 'स्थिती';

  @override
  String get selectStatus => 'स्थिती निवडा';

  @override
  String get yes => 'होय';

  @override
  String get no => 'नाही';

  @override
  String get fromDate => 'सुरुवातीची तारीख';

  @override
  String get toDate => 'शेवटची तारीख';

  @override
  String get clear => 'साफ करा';

  @override
  String get applyFilters => 'फिल्टर लागू करा';

  @override
  String get confirmProductsApplied => 'उत्पादने वापरल्याची पुष्टी करा';

  @override
  String get productsAppliedConfirmation => 'तुम्ही या वेळापत्रकातील सर्व उत्पादने वापरली आहेत का?';

  @override
  String get scheduleUpdatedSuccessfully => 'वेळापत्रक यशस्वीपणे अद्यतनित झाले';

  @override
  String get unableToUpdateSchedule => 'वेळापत्रक अद्यतनित करता आले नाही';

  @override
  String get plotIdMissing => 'प्लॉटचा आयडी उपलब्ध नाही';

  @override
  String get pleaseLoginAgain => 'कृपया पुन्हा लॉगिन करा';

  @override
  String get plotSchedules => 'प्लॉटची वेळापत्रके';

  @override
  String get noSchedulesFound => 'कोणतीही वेळापत्रके आढळली नाहीत';

  @override
  String get loadingMatchingSchedules => 'जुळणारी वेळापत्रके लोड होत आहेत...';

  @override
  String get noSchedulesMatchFilters => 'निवडलेल्या फिल्टरशी कोणतेही पीक वेळापत्रक जुळत नाही.';

  @override
  String get scheduleTimelineHint => 'आजची वेळापत्रके सुरुवातीला दिसतात. पुढील वेळापत्रकांसाठी खाली आणि मागील वेळापत्रकांसाठी वर स्क्रोल करा.';

  @override
  String get dosesFor200Liters => 'टीप: 200 लिटरसाठी मात्रा';

  @override
  String get loadMoreSchedulesError => 'आणखी वेळापत्रके लोड करता आली नाहीत. पुन्हा प्रयत्न करण्यासाठी टॅप करा';

  @override
  String get plotName => 'प्लॉटचे नाव';

  @override
  String get consultant => 'सल्लागार';

  @override
  String get noProductDetails => 'उत्पादनाचे तपशील उपलब्ध नाहीत';

  @override
  String get remarkLabel => 'शेरा: ';

  @override
  String get productsApplied => 'उत्पादने वापरली का?';

  @override
  String get quantity => 'प्रमाण';

  @override
  String get water => 'पाणी';

  @override
  String get selectScheduleDateHint => 'वेळापत्रके पाहण्यासाठी तारीख निवडा';

  @override
  String get today => 'आज';

  @override
  String get checkingAvailableSchedules => 'उपलब्ध वेळापत्रके तपासत आहे...';

  @override
  String get scheduleDatesUnavailable => 'वेळापत्रकाच्या तारखा उपलब्ध नाहीत';

  @override
  String get scheduleAvailableLegend => 'हिरवा ठिपका = वेळापत्रक उपलब्ध आहे';

  @override
  String get todaysSchedule => 'आजचे वेळापत्रक';

  @override
  String get selectedDateSchedule => 'निवडलेल्या तारखेचे वेळापत्रक';

  @override
  String get available => 'उपलब्ध';

  @override
  String get schedules => 'वेळापत्रके';

  @override
  String get unnamedProduct => 'नाव नसलेले उत्पादन';

  @override
  String plotCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्लॉट',
      one: '1 प्लॉट',
    );
    return '$_temp0';
  }

  @override
  String scheduleDateCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count तारखा',
      one: '1 तारीख',
    );
    return '$_temp0';
  }

  @override
  String totalProductCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'एकूण $count उत्पादने',
      one: 'एकूण 1 उत्पादन',
    );
    return '$_temp0';
  }

  @override
  String scheduleFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आढळली',
      one: '1 आढळले',
    );
    return '$_temp0';
  }

  @override
  String noSchedulesForDate(String date) {
    return '$date साठी कोणतीही पीक वेळापत्रके उपलब्ध नाहीत.';
  }

  @override
  String plotNameValue(String name) {
    return 'प्लॉटचे नाव: $name';
  }

  @override
  String consultantName(String name) {
    return 'सल्लागार: $name';
  }

  @override
  String totalNotificationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सूचना',
      one: '1 सूचना',
    );
    return '$_temp0';
  }
}
