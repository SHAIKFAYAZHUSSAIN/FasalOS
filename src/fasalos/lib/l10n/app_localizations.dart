import 'package:flutter/material.dart';

enum AppLanguage {
  english('en', 'English'),
  telugu('te', 'తెలుగు'),
  hindi('hi', 'हिन्दी'),
  tamil('ta', 'தமிழ்'),
  kannada('kn', 'ಕನ್ನಡ');

  final String code;
  final String displayName;
  const AppLanguage(this.code, this.displayName);
}

class AppLocalizations {
  final AppLanguage language;
  AppLocalizations(this.language);

  static AppLocalizations of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<_AppLocalizationsScope>();
    return provider?.localizations ?? AppLocalizations(AppLanguage.english);
  }

  static const Map<String, Map<AppLanguage, String>> _strings = {
    // App & Shell
    'app_title': {
      AppLanguage.english: 'FasalOS — Agricultural Operating System',
      AppLanguage.telugu: 'ఫసల్ ఓఎస్ — వ్యవసాయ ఆపరేటింగ్ సిస్టమ్',
      AppLanguage.hindi: 'फसल ओएस — कृषि ऑपरेटिंग सिस्टम',
      AppLanguage.tamil: 'பசல் ஓஎஸ் — வேளாண் செயல்பாட்டு அமைப்பு',
      AppLanguage.kannada: 'ಫಸಲ್ ಓಎಸ್ — ಕೃಷಿ ಕಾರ್ಯಾಚರಣಾ ವ್ಯವಸ್ಥೆ',
    },
    'hub_name': {
      AppLanguage.english: 'Kurnool Agro-Solar Cold Hub #12',
      AppLanguage.telugu: 'కర్నూలు అగ్రో-సోలార్ కోల్డ్ హబ్ #12',
      AppLanguage.hindi: 'कुरनूल एग्रो-सोलर कोल्ड हब #12',
      AppLanguage.tamil: 'கர்னூல் வேளாண்-சூரிய குளிர் மையம் #12',
      AppLanguage.kannada: 'ಕರ್ನೂಲ್ ಕೃಷಿ-ಸೌರ ಕೋಲ್ಡ್ ಹಬ್ #12',
    },
    'tab_hub': {
      AppLanguage.english: 'Hub Lots',
      AppLanguage.telugu: 'హబ్ లాట్లు',
      AppLanguage.hindi: 'हब लॉट्स',
      AppLanguage.tamil: 'மையக் குவியல்கள்',
      AppLanguage.kannada: 'ಹಬ್ ಲಾಟ್‌ಗಳು',
    },
    'tab_solar': {
      AppLanguage.english: 'Solar Cold Room',
      AppLanguage.telugu: 'సోలార్ కోల్డ్ రూమ్',
      AppLanguage.hindi: 'सोलर कोल्ड रूम',
      AppLanguage.tamil: 'சூரிய குளிர் அறை',
      AppLanguage.kannada: 'ಸೌರ ಕೋಲ್ಡ್ ರೂಮ್',
    },
    'tab_markets': {
      AppLanguage.english: 'Market Match',
      AppLanguage.telugu: 'మార్కెట్ మ్యాచ్',
      AppLanguage.hindi: 'बाजार मिलान',
      AppLanguage.tamil: 'சந்தை பொருத்தம்',
      AppLanguage.kannada: 'ಮಾರುಕಟ್ಟೆ ಹೊಂದಾಣಿಕೆ',
    },
    'tab_aggregation': {
      AppLanguage.english: 'Aggregation',
      AppLanguage.telugu: 'సమీకరణ (అగ్రిగేషన్)',
      AppLanguage.hindi: 'एकत्रीकरण',
      AppLanguage.tamil: 'ஒருங்கிணைப்பு',
      AppLanguage.kannada: 'ಒಗ್ಗೂಡುವಿಕೆ',
    },
    'tab_buyer': {
      AppLanguage.english: 'Buyer Portal',
      AppLanguage.telugu: 'కొనుగోలుదారుల వేదిక',
      AppLanguage.hindi: 'क्रेता पोर्टल',
      AppLanguage.tamil: 'வாங்குபவர் தளம்',
      AppLanguage.kannada: 'ಖರೀದಿದಾರರ ಪೋರ್ಟಲ್',
    },
    'tab_settlement': {
      AppLanguage.english: 'Settlement',
      AppLanguage.telugu: 'చెల్లింపుల లెక్క',
      AppLanguage.hindi: 'भुगतान निपटान',
      AppLanguage.tamil: 'பட்டுவாடா தீர்வு',
      AppLanguage.kannada: 'ಪಾವತಿ ಇತ್ಯರ್ಥ',
    },

    // Offline & Sync
    'sync_online': {
      AppLanguage.english: 'Connected • Real-time Sync',
      AppLanguage.telugu: 'ఆన్‌లైన్ • ప్రత్యక్ష సమకాలీకరణ',
      AppLanguage.hindi: 'कनेक्टेड • रीयल-टाइम सिंक',
      AppLanguage.tamil: 'இணைக்கப்பட்டது • நேரலை ஒத்திசைவு',
      AppLanguage.kannada: 'ಸಂಪರ್ಕಗೊಂಡಿದೆ • ನೈಜ-ಸಮಯ ಸಿಂಕ್',
    },
    'sync_offline': {
      AppLanguage.english: 'Offline Mode • Local Queue Active',
      AppLanguage.telugu: 'ఆఫ్‌లైన్ మోడ్ • స్థానిక వరుస సక్రియం',
      AppLanguage.hindi: 'ऑफ़लाइन मोड • स्थानीय कतार सक्रिय',
      AppLanguage.tamil: 'ஆஃப்லைன் பயன்முறை • உள்ளூர் வரிசை செயலில்',
      AppLanguage.kannada: 'ಆಫ್‌ಲೈನ್ ಮೋಡ್ • ಸ್ಥಳೀಯ ಕ್ಯೂ ಸಕ್ರಿಯ',
    },
    'sync_pending': {
      AppLanguage.english: 'pending sync',
      AppLanguage.telugu: 'సమకాలీకరణ వేచి ఉంది',
      AppLanguage.hindi: 'सिंक लंबित',
      AppLanguage.tamil: 'ஒத்திசைவு நிலுவையில்',
      AppLanguage.kannada: 'ಸಿಂಕ್ ಬಾಕಿ ಇದೆ',
    },
    'sync_now': {
      AppLanguage.english: 'Sync Now',
      AppLanguage.telugu: 'ఇప్పుడే సమకాలీకరించు',
      AppLanguage.hindi: 'अभी सिंक करें',
      AppLanguage.tamil: 'இப்போதே ஒத்திசை',
      AppLanguage.kannada: 'ಈಗಲೇ ಸಿಂಕ್ ಮಾಡಿ',
    },
    'toggle_offline': {
      AppLanguage.english: 'Toggle Network Mode',
      AppLanguage.telugu: 'నెట్‌వర్క్ మోడ్ మార్చండి',
      AppLanguage.hindi: 'नेटवर्क मोड बदलें',
      AppLanguage.tamil: 'நெட்வொர்க் பயன்முறையை மாற்று',
      AppLanguage.kannada: 'ನೆಟ್‌ವರ್ಕ್ ಮೋಡ್ ಬದಲಾಯಿಸಿ',
    },

    // Produce Intake
    'btn_add_produce': {
      AppLanguage.english: '+ Add Produce Intake',
      AppLanguage.telugu: '+ పంట సేకరణ నమోదు',
      AppLanguage.hindi: '+ नई फसल आवक दर्ज करें',
      AppLanguage.tamil: '+ புதிய விளைபொருள் சேர்',
      AppLanguage.kannada: '+ ಹೊಸ ಬೆಳೆ ಒಳಬರುವಿಕೆ ಸೇರಿಸಿ',
    },
    'intake_title': {
      AppLanguage.english: 'Farmer Produce Intake',
      AppLanguage.telugu: 'రైతు పంట సేకరణ నమోదు',
      AppLanguage.hindi: 'किसान उत्पाद आवक पंजीकरण',
      AppLanguage.tamil: 'விவசாயி விளைபொருள் சேர்க்கை',
      AppLanguage.kannada: 'ರೈತರ ಬೆಳೆ ನೋಂದಣಿ',
    },
    'intake_step_1': {
      AppLanguage.english: '1. Crop & Farmer Details',
      AppLanguage.telugu: '1. పంట మరియు రైతు వివరాలు',
      AppLanguage.hindi: '1. फसल और किसान विवरण',
      AppLanguage.tamil: '1. பயிர் மற்றும் விவசாயி விவரம்',
      AppLanguage.kannada: '1. ಬೆಳೆ ಮತ್ತು ರೈತರ ವಿವರಗಳು',
    },
    'intake_step_2': {
      AppLanguage.english: '2. Crate Photo & Visual AI',
      AppLanguage.telugu: '2. క్రేట్ ఫోటో & దృశ్య AI నిర్ధారణ',
      AppLanguage.hindi: '2. क्रेट फोटो एवं एआई गुणवत्ता जांच',
      AppLanguage.tamil: '2. பெட்டி புகைப்படம் & ஏஐ தர மதிப்பீடு',
      AppLanguage.kannada: '2. ಕ್ರೇಟ್ ಫೋಟೋ ಮತ್ತು ಎಐ ಗುಣಮಟ್ಟ ಮೌಲ್ಯಮಾಪನ',
    },
    'intake_step_3': {
      AppLanguage.english: '3. Quality Factors & Lot Creation',
      AppLanguage.telugu: '3. నాణ్యత సూచికలు & లాట్ సృష్టి',
      AppLanguage.hindi: '3. गुणवत्ता कारक एवं लॉट सृजन',
      AppLanguage.tamil: '3. தரக் காரணிகள் & லாட் உருவாக்கம்',
      AppLanguage.kannada: '3. ಗುಣಮಟ್ಟದ ಅಂಶಗಳು ಮತ್ತು ಲಾಟ್ ರಚನೆ',
    },
    'farmer_name': {
      AppLanguage.english: 'Farmer Name',
      AppLanguage.telugu: 'రైతు పేరు',
      AppLanguage.hindi: 'किसान का नाम',
      AppLanguage.tamil: 'விவசாயியின் பெயர்',
      AppLanguage.kannada: 'ರೈತರ ಹೆಸರು',
    },
    'select_crop': {
      AppLanguage.english: 'Crop Variety',
      AppLanguage.telugu: 'పంట రకం',
      AppLanguage.hindi: 'फसल की किस्म',
      AppLanguage.tamil: 'பயிர் ரகம்',
      AppLanguage.kannada: 'ಬೆಳೆ ತಳಿ',
    },
    'quantity_kg': {
      AppLanguage.english: 'Quantity (kg)',
      AppLanguage.telugu: 'పరిమాణం (కిలోలు)',
      AppLanguage.hindi: 'मात्रा (किग्रा)',
      AppLanguage.tamil: 'அளவு (கிலோ)',
      AppLanguage.kannada: 'ಪ್ರಮಾಣ (ಕೆಜಿ)',
    },
    'village_location': {
      AppLanguage.english: 'Village / Farm Location',
      AppLanguage.telugu: 'గ్రామం / పొలం ప్రాంతం',
      AppLanguage.hindi: 'गांव / खेत का स्थान',
      AppLanguage.tamil: 'கிராமம் / பண்ணை இடம்',
      AppLanguage.kannada: 'ಗ್ರಾಮ / ತೋಟದ ಸ್ಥಳ',
    },
    'run_ai_assessment': {
      AppLanguage.english: 'Analyze Produce with Computer Vision',
      AppLanguage.telugu: 'కంప్యూటర్ విజన్‌తో పంట నాణ్యతను విశ్లేషించండి',
      AppLanguage.hindi: 'कंप्यूटर विजन से गुणवत्ता का विश्लेषण करें',
      AppLanguage.tamil: 'கணினி பார்வை மூலம் தரத்தை பகுப்பாய்வு செய்க',
      AppLanguage.kannada: 'ಕಂಪ್ಯೂಟರ್ ದೃಷ್ಟಿಯೊಂದಿಗೆ ಗುಣಮಟ್ಟ ವಿಶ್ಲೇಷಿಸಿ',
    },
    'operator_confirm': {
      AppLanguage.english: 'Operator Confirm & Create Lot',
      AppLanguage.telugu: 'ఆపరేటర్ నిర్ధారించి లాట్ సృష్టించండి',
      AppLanguage.hindi: 'ऑपरेटर पुष्टि करें एवं लॉट बनाएं',
      AppLanguage.tamil: 'ஆபரேட்டர் உறுதி செய்து லாட் உருவாக்கவும்',
      AppLanguage.kannada: 'ಆಪರೇಟರ್ ದೃಢೀಕರಿಸಿ ಮತ್ತು ಲಾಟ್ ರಚಿಸಿ',
    },
    'lot_created_success': {
      AppLanguage.english: 'Lot created successfully! Transitioned to Stored.',
      AppLanguage.telugu: 'లాట్ విజయవంతంగా సృష్టించబడింది! కోల్డ్ రూమ్‌కు చేరింది.',
      AppLanguage.hindi: 'लॉट सफलतापूर्वक बनाया गया! कोल्ड रूम में भंडारित।',
      AppLanguage.tamil: 'லாட் வெற்றிகரமாக உருவாக்கப்பட்டது! குளிர் சேமிப்பில் வைக்கப்பட்டது.',
      AppLanguage.kannada: 'ಲಾಟ್ ಯಶಸ್ವಿಯಾಗಿ ರಚಿಸಲಾಗಿದೆ! ಶೀತಲ ಸಂಗ್ರಹಕ್ಕೆ ಸೇರಿಸಲಾಗಿದೆ.',
    },

    // Quality Factors
    'quality_grade': {
      AppLanguage.english: 'Grade Assessment',
      AppLanguage.telugu: 'గ్రేడ్ నిర్ధారణ',
      AppLanguage.hindi: 'ग्रेड निर्धारण',
      AppLanguage.tamil: 'தர மதிப்பீடு',
      AppLanguage.kannada: 'ಗ್ರೇಡ್ ನಿರ್ಧಾರ',
    },
    'color_maturity': {
      AppLanguage.english: 'Color Maturity',
      AppLanguage.telugu: 'రంగు పక్వత',
      AppLanguage.hindi: 'रंग परिपक्वता',
      AppLanguage.tamil: 'நிற முதிர்ச்சி',
      AppLanguage.kannada: 'ಬಣ್ಣದ ಪಕ್ವತೆ',
    },
    'sizing_uniformity': {
      AppLanguage.english: 'Size Uniformity',
      AppLanguage.telugu: 'పరిమాణ ఏకరూపత',
      AppLanguage.hindi: 'आकार एकरूपता',
      AppLanguage.tamil: 'அளவு சீரான தன்மை',
      AppLanguage.kannada: 'ಗಾತ್ರದ ಏಕರೂಪತೆ',
    },
    'blemish_rate': {
      AppLanguage.english: 'Blemish / Defect Rate',
      AppLanguage.telugu: 'మచ్చలు / లోపాల శాతం',
      AppLanguage.hindi: 'दाग / दोष दर',
      AppLanguage.tamil: 'கறை / குறைபாடு விகிதம்',
      AppLanguage.kannada: 'ಕಲೆ / ದೋಷ ದರ',
    },
    'firmness_index': {
      AppLanguage.english: 'Firmness Index',
      AppLanguage.telugu: 'గట్టిదనం సూచిక',
      AppLanguage.hindi: 'कठोरता सूचकांक',
      AppLanguage.tamil: 'உறுதி குறியீடு',
      AppLanguage.kannada: 'ದೃಢತೆ ಸೂಚ್ಯಂಕ',
    },
    'ai_confidence': {
      AppLanguage.english: 'Model Confidence',
      AppLanguage.telugu: 'మోడల్ విశ్వసనీయత',
      AppLanguage.hindi: 'मॉडल विश्वसनीयता',
      AppLanguage.tamil: 'மாதிரி நம்பிக்கை',
      AppLanguage.kannada: 'ಮಾದರಿ ವಿಶ್ವಾಸಾರ್ಹತೆ',
    },

    // Freshness & Cold Chain
    'freshness_title': {
      AppLanguage.english: 'Cold-Chain Freshness Diagnostics',
      AppLanguage.telugu: 'కోల్డ్-చైన్ తాజాదనం విశ్లేషణ',
      AppLanguage.hindi: 'कोल्ड-चेन ताजगी विश्लेषण',
      AppLanguage.tamil: 'குளிர் சங்கிலி புத்துணர்ச்சி பகுப்பாய்வு',
      AppLanguage.kannada: 'ಶೀತಲ ಸರಪಳಿ ತಾಜಾತನದ ವಿಶ್ಲೇಷಣೆ',
    },
    'freshness_score': {
      AppLanguage.english: 'Freshness Index',
      AppLanguage.telugu: 'తాజాదన సూచిక',
      AppLanguage.hindi: 'ताजगी सूचकांक',
      AppLanguage.tamil: 'புத்துணர்ச்சி குறியீடு',
      AppLanguage.kannada: 'ತಾಜಾತನದ ಸೂಚ್ಯಂಕ',
    },
    'temperature': {
      AppLanguage.english: 'Chamber Temp',
      AppLanguage.telugu: 'గది ఉష్ణోగ్రత',
      AppLanguage.hindi: 'कक्ष तापमान',
      AppLanguage.tamil: 'அறை வெப்பநிலை',
      AppLanguage.kannada: 'ಕೋಣೆಯ ಉಷ್ಣಾಂಶ',
    },
    'humidity': {
      AppLanguage.english: 'Relative Humidity',
      AppLanguage.telugu: 'సాపేక్ష తేమ',
      AppLanguage.hindi: 'सापेक्ष आर्द्रता',
      AppLanguage.tamil: 'ஒப்பீட்டு ஈரப்பதம்',
      AppLanguage.kannada: 'ಸಾಪೇಕ್ಷ ತೇವಾಂಶ',
    },
    'storage_duration': {
      AppLanguage.english: 'Time in Cold Room',
      AppLanguage.telugu: 'కోల్డ్ రూమ్‌లో గడిపిన సమయం',
      AppLanguage.hindi: 'शीत कक्ष में बिताया समय',
      AppLanguage.tamil: 'குளிர் அறையில் இருந்த நேரம்',
      AppLanguage.kannada: 'ಶೀತಲ ಕೋಣೆಯಲ್ಲಿ ಕಳೆದ ಸಮಯ',
    },
    'freshness_window': {
      AppLanguage.english: 'Estimated Freshness Window',
      AppLanguage.telugu: 'అంచనా వేసిన నాణ్యత వ్యవధి',
      AppLanguage.hindi: 'अनुमानित ताजगी अवधि',
      AppLanguage.tamil: 'மதிப்பிடப்பட்ட புத்துணர்ச்சி காலம்',
      AppLanguage.kannada: 'ಅಂದಾಜು ತಾಜಾತನದ ಅವಧಿ',
    },
    'freshness_disclaimer': {
      AppLanguage.english:
          'Science Note: Predictions depend on crop variety, harvest maturity, temperature stability, humidity, ventilation, and handling. Not a universal shelf-life guarantee.',
      AppLanguage.telugu:
          'శాస్త్రీయ గమనిక: అంచనాలు పంట రకం, కోత పక్వత, ఉష్ణోగ్రత స్థిరత్వం, తేమ మరియు నిర్వహణపై ఆధారపడి ఉంటాయి. ఇది సార్వత్రిక నిల్వ హామీ కాదు.',
      AppLanguage.hindi:
          'वैज्ञानिक नोट: भविष्यवाणियां फसल की किस्म, कटाई परिपक्वता, तापमान स्थिरता, आर्द्रता और प्रबंधन पर निर्भर करती हैं। यह सार्वभौमिक गारंटी नहीं है।',
      AppLanguage.tamil:
          'அறிவியல் குறிப்பு: கணிப்புகள் பயிர் ரகம், அறுவடை முதிர்ச்சி, வெப்பநிலை நிலைத்தன்மை மற்றும் கையாளுதலைப் பொறுத்தது.',
      AppLanguage.kannada:
          'ವೈಜ್ಞಾನಿಕ ಟಿಪ್ಪಣಿ: ಮುನ್ನೋಟಗಳು ಬೆಳೆ ತಳಿ, ಕೊಯ್ಲಿನ ಪಕ್ವತೆ, ತಾಪಮಾನ ಸ್ಥಿರತೆ ಮತ್ತು ನಿರ್ವಹಣೆಯ ಮೇಲೆ ಅವಲಂಬಿತವಾಗಿವೆ.',
    },

    // Solar Energy
    'solar_title': {
      AppLanguage.english: 'Photovoltaic Solar Cold-Chain Flow',
      AppLanguage.telugu: 'సౌర శక్తి కోల్డ్-చైన్ ప్రవాహం',
      AppLanguage.hindi: 'सौर ऊर्जा कोल्ड-चेन प्रवाह',
      AppLanguage.tamil: 'சூரிய சக்தி குளிர் சங்கிலி ஓட்டம்',
      AppLanguage.kannada: 'ಸೌರ ಶಕ್ತಿ ಶೀತಲ ಸರಪಳಿ ಹರಿವು',
    },
    'solar_generated': {
      AppLanguage.english: 'Generated (Solar)',
      AppLanguage.telugu: 'ఉత్పత్తి (సోలార్)',
      AppLanguage.hindi: 'उत्पादित (सोलर)',
      AppLanguage.tamil: 'உற்பத்தி (சூரிய சக்தி)',
      AppLanguage.kannada: 'ಉತ್ಪಾದನೆ (ಸೌರ)',
    },
    'energy_consumed': {
      AppLanguage.english: 'Total Consumption',
      AppLanguage.telugu: 'మొత్తం వినియోగం',
      AppLanguage.hindi: 'कुल खपत',
      AppLanguage.tamil: 'மொத்த நுகர்வு',
      AppLanguage.kannada: 'ಒಟ್ಟು ಬಳಕೆ',
    },
    'solar_contribution': {
      AppLanguage.english: 'Solar Contribution',
      AppLanguage.telugu: 'సౌర విద్యుత్ భాగస్వామ్యం',
      AppLanguage.hindi: 'सौर ऊर्जा योगदान',
      AppLanguage.tamil: 'சூரிய சக்தி பங்களிப்பு',
      AppLanguage.kannada: 'ಸೌರ ಶಕ್ತಿಯ ಕೊಡುಗೆ',
    },
    'cold_consumption': {
      AppLanguage.english: 'Cold-Chain Load',
      AppLanguage.telugu: 'కోల్డ్-చైన్ వినియోగం',
      AppLanguage.hindi: 'कोल्ड-चेन लोड',
      AppLanguage.tamil: 'குளிர் சங்கிலி சுமை',
      AppLanguage.kannada: 'ಕೋಲ್ಡ್ ಚೈನ್ ಲೋಡ್',
    },
    'battery_reserve': {
      AppLanguage.english: 'Battery Thermal Reserve',
      AppLanguage.telugu: 'బ్యాటరీ రిజర్వ్',
      AppLanguage.hindi: 'बैटरी थर्मल बैकअप',
      AppLanguage.tamil: 'மின்கல இருப்பு',
      AppLanguage.kannada: 'ಬ್ಯಾಟರಿ ಮೀಸಲು',
    },
    'demo_data_badge': {
      AppLanguage.english: 'SIMULATED DEMO TELEMETRY',
      AppLanguage.telugu: 'అనుకరణ ప్రదర్శన సమాచారం',
      AppLanguage.hindi: 'सिम्युलेटेड डेमो डेटा',
      AppLanguage.tamil: 'மாதிரி செயல்விளக்கத் தரவு',
      AppLanguage.kannada: 'ಸಿಮ್ಯುಲೇಟೆಡ್ ಡೆಮೊ ಡೇಟಾ',
    },

    // Aggregation
    'aggregation_title': {
      AppLanguage.english: 'Multi-Farmer Lot Aggregation',
      AppLanguage.telugu: 'రైతుల పంట సమగ్ర సమీకరణ',
      AppLanguage.hindi: 'बहु-किसान लॉट एकत्रीकरण',
      AppLanguage.tamil: 'பல விவசாயிகளின் விளைபொருள் திரட்டு',
      AppLanguage.kannada: 'ಬಹು-ರೈತರ ಲಾಟ್ ಒಗ್ಗೂಡುವಿಕೆ',
    },
    'aggregation_desc': {
      AppLanguage.english:
          'Select smallholder lots of compatible crop and grade to aggregate into high-value buyer-ready truckload batches.',
      AppLanguage.telugu:
          'చిన్నకారు రైతుల నాణ్యమైన పంట లాట్లను ఎంచుకుని, సంస్థాగత కొనుగోలుదారుల కోసం భారీ బ్యాచ్‌గా సమీకరించండి.',
      AppLanguage.hindi:
          'संगठित खरीदारों के लिए संगत फसल एवं ग्रेड के छोटे लॉट्स का चयन कर बड़ा बैच तैयार करें।',
      AppLanguage.tamil:
          'மொத்தக் கொள்முதல் வாங்குபவர்களுக்காக சிறு விவசாயிகளின் பயிர் குவியல்களைத் திரட்டி பெரிய தொகுப்பாக மாற்றவும்.',
      AppLanguage.kannada:
          'ಸಂಸ್ಥೆಯ ಖರೀದಿದಾರರಿಗೆ ಸೂಕ್ತವಾದ ಬೆಳೆ ಮತ್ತು ಗ್ರೇಡ್ ಲಾಟ್‌ಗಳನ್ನು ದೊಡ್ಡ ಬ್ಯಾಚ್ ಆಗಿ ಒಗ್ಗೂಡಿಸಿ.',
    },
    'aggregate_action': {
      AppLanguage.english: 'Combine Selected Lots',
      AppLanguage.telugu: 'ఎంచుకున్న లాట్లను కలపండి',
      AppLanguage.hindi: 'चयनित लॉट्स को मिलाएं',
      AppLanguage.tamil: 'தேர்ந்தெடுத்த குவியல்களை இணைக்கவும்',
      AppLanguage.kannada: 'ಆಯ್ಕೆಮಾಡಿದ ಲಾಟ್‌ಗಳನ್ನು ಒಗ್ಗೂಡಿಸಿ',
    },
    'batch_ready': {
      AppLanguage.english: 'Buyer-Ready Consolidated Batch',
      AppLanguage.telugu: 'కొనుగోలుదారుకు సిద్ధంగా ఉన్న సమీకృత బ్యాచ్',
      AppLanguage.hindi: 'क्रेता-तैयार समेकित बैच',
      AppLanguage.tamil: 'வாங்குபவருக்குத் தயாரான ஒருங்கிணைந்த தொகுதி',
      AppLanguage.kannada: 'ಖರೀದಿದಾರರಿಗೆ ಸಿದ್ಧವಾದ ಒಗ್ಗೂಡಿಸಿದ ಬ್ಯಾಚ್',
    },

    // Market Matching
    'market_title': {
      AppLanguage.english: 'Demand-Driven Market Matching',
      AppLanguage.telugu: 'డిమాండ్ ఆధారిత మార్కెట్ సిఫార్సులు',
      AppLanguage.hindi: 'मांग-आधारित बाजार मिलान',
      AppLanguage.tamil: 'தேவை சார்ந்த சந்தை பொருத்தம்',
      AppLanguage.kannada: 'ಬೇಡಿಕೆ ಆಧಾರಿತ ಮಾರುಕಟ್ಟೆ ಹೊಂದಾಣಿಕೆ',
    },
    'channel_local': {
      AppLanguage.english: 'Local APMC Mandi',
      AppLanguage.telugu: 'స్థానిక వ్యవసాయ మార్కెట్ (మండి)',
      AppLanguage.hindi: 'स्थानीय मंडी (एपीएमसी)',
      AppLanguage.tamil: 'உள்ளூர் உழவர் சந்தை',
      AppLanguage.kannada: 'ಸ್ಥಳೀಯ ಎಪಿಎಂಸಿ ಮಂಡಿ',
    },
    'channel_buyer': {
      AppLanguage.english: 'Organized Retail Buyer Order',
      AppLanguage.telugu: 'ఆర్గనైజ్డ్ రిటైల్ కొనుగోలు ఆర్డర్',
      AppLanguage.hindi: 'संगठित खुदरा खरीदार अनुबंध',
      AppLanguage.tamil: 'சில்லறை விற்பனை சங்கிலி ஒப்பந்தம்',
      AppLanguage.kannada: 'ಸಂಘಟಿತ ಚಿಲ್ಲರೆ ಖರೀದಿದಾರರ ಆದೇಶ',
    },
    'channel_processing': {
      AppLanguage.english: 'Food Processing Unit',
      AppLanguage.telugu: 'ఆహార శుద్ధి కర్మాగారం (ప్రాసెసింగ్)',
      AppLanguage.hindi: 'खाद्य प्रसंस्करण इकाई',
      AppLanguage.tamil: 'உணவு பதப்படுத்தும் தொழிற்சாலை',
      AppLanguage.kannada: 'ಆಹಾರ ಸಂಸ್ಕರಣಾ ಘಟಕ',
    },

    // Lot Journey Stages
    'stage_received': {
      AppLanguage.english: 'Received',
      AppLanguage.telugu: 'స్వీకరించబడింది',
      AppLanguage.hindi: 'प्राप्त हुआ',
      AppLanguage.tamil: 'பெறப்பட்டது',
      AppLanguage.kannada: 'ಸ್ವೀಕರಿಸಲಾಗಿದೆ',
    },
    'stage_graded': {
      AppLanguage.english: 'Graded',
      AppLanguage.telugu: 'గ్రేడింగ్ పూర్తయింది',
      AppLanguage.hindi: 'ग्रेडिंग संपन्न',
      AppLanguage.tamil: 'தரம் பிரிக்கப்பட்டது',
      AppLanguage.kannada: 'ಗ್ರೇಡ್ ಮಾಡಲಾಗಿದೆ',
    },
    'stage_stored': {
      AppLanguage.english: 'Stored',
      AppLanguage.telugu: 'కోల్డ్ రూమ్‌లో నిల్వ',
      AppLanguage.hindi: 'शीत भंडारित',
      AppLanguage.tamil: 'குளிரூட்டப்பட்டது',
      AppLanguage.kannada: 'ಶೀತಲ ಸಂಗ್ರಹಣೆಯಲ್ಲಿ',
    },
    'stage_matched': {
      AppLanguage.english: 'Matched',
      AppLanguage.telugu: 'ఆర్డర్ లభించింది',
      AppLanguage.hindi: 'मांग से मेल खाया',
      AppLanguage.tamil: 'பொருந்தியது',
      AppLanguage.kannada: 'ಹೊಂದಿಕೆಯಾಗಿದೆ',
    },
    'stage_aggregating': {
      AppLanguage.english: 'Aggregated',
      AppLanguage.telugu: 'సమీకరించబడింది',
      AppLanguage.hindi: 'समेकित',
      AppLanguage.tamil: 'திரட்டப்பட்டது',
      AppLanguage.kannada: 'ಒಗ್ಗೂಡಿಸಲಾಗಿದೆ',
    },
    'stage_dispatched': {
      AppLanguage.english: 'Dispatched',
      AppLanguage.telugu: 'రవాణాలో ఉంది',
      AppLanguage.hindi: 'भेज दिया गया',
      AppLanguage.tamil: 'அனுப்பப்பட்டது',
      AppLanguage.kannada: 'ರವಾನಿಸಲಾಗಿದೆ',
    },
    'stage_delivered': {
      AppLanguage.english: 'Delivered',
      AppLanguage.telugu: 'చేరింది',
      AppLanguage.hindi: 'वितरित हुआ',
      AppLanguage.tamil: 'டெலிவரி செய்யப்பட்டது',
      AppLanguage.kannada: 'ವಿತರಿಸಲಾಗಿದೆ',
    },
    'stage_paid': {
      AppLanguage.english: 'Settled & Paid',
      AppLanguage.telugu: 'చెల్లింపు పూర్తయింది',
      AppLanguage.hindi: 'भुगतान संपन्न',
      AppLanguage.tamil: 'செலுத்தப்பட்டது',
      AppLanguage.kannada: 'ಪಾವತಿಸಲಾಗಿದೆ',
    },

    // Buyer Flow
    'buyer_catalogue': {
      AppLanguage.english: 'Available Fresh Farm Lots',
      AppLanguage.telugu: 'లభ్యతలో ఉన్న తాజా పంట లాట్లు',
      AppLanguage.hindi: 'उपलब्ध ताजे कृषि लॉट्स',
      AppLanguage.tamil: 'கிடைக்கக்கூடிய புதிய விளைபொருட்கள்',
      AppLanguage.kannada: 'ಲಭ್ಯವಿರುವ ತಾಜಾ ಕೃಷಿ ಲಾಟ್‌ಗಳು',
    },
    'order_quantity': {
      AppLanguage.english: 'Request Quantity (kg)',
      AppLanguage.telugu: 'కావలసిన పరిమాణం (కిలోలు)',
      AppLanguage.hindi: 'वांछित मात्रा (किग्रा)',
      AppLanguage.tamil: 'தேவைப்படும் அளவு (கிலோ)',
      AppLanguage.kannada: 'ಬೇಕಾದ ಪ್ರಮಾಣ (ಕೆಜಿ)',
    },
    'place_order': {
      AppLanguage.english: 'Confirm & Place Buyer Order',
      AppLanguage.telugu: 'ఆర్డర్ ఖరారు చేయండి',
      AppLanguage.hindi: 'खरीद आदेश की पुष्टि करें',
      AppLanguage.tamil: 'ஆர்டரை உறுதிப்படுத்துக',
      AppLanguage.kannada: 'ಆದೇಶವನ್ನು ದೃಢೀಕರಿಸಿ',
    },
    'track_delivery': {
      AppLanguage.english: 'Track Refrigerated Dispatch',
      AppLanguage.telugu: 'శీతలీకృత రవాణా ట్రాకింగ్',
      AppLanguage.hindi: 'प्रशीतित प्रेषण ट्रैक करें',
      AppLanguage.tamil: 'குளிரூட்டப்பட்ட சரக்கு கண்காணிப்பு',
      AppLanguage.kannada: 'ಶೀತಲ ವಾಹನ ರವಾನೆ ಟ್ರ್ಯಾಕಿಂಗ್',
    },

    // Settlement
    'settlement_title': {
      AppLanguage.english: 'Transparent Farmer Settlement',
      AppLanguage.telugu: 'పారదర్శక రైతు చెల్లింపుల లెక్క',
      AppLanguage.hindi: 'पारदर्शी किसान भुगतान विवरण',
      AppLanguage.tamil: 'வெளிப்படையான விவசாயி தீர்வு',
      AppLanguage.kannada: 'ಪಾರದರ್ಶಕ ರೈತರ ಪಾವತಿ ವಿವರ',
    },
    'gross_proceeds': {
      AppLanguage.english: 'Gross Produce Sale Value',
      AppLanguage.telugu: 'స్థూల విక్రయ విలువ',
      AppLanguage.hindi: 'सकल बिक्री मूल्य',
      AppLanguage.tamil: 'மொத்த விற்பனை மதிப்பு',
      AppLanguage.kannada: 'ಒಟ್ಟು ಮಾರಾಟ ಮೌಲ್ಯ',
    },
    'cold_rebate': {
      AppLanguage.english: 'Solar Cold-Chain Quality Premium',
      AppLanguage.telugu: 'సౌర నిల్వ నాణ్యతా బోనస్',
      AppLanguage.hindi: 'सोलर शीतगृह गुणवत्ता बोनस',
      AppLanguage.tamil: 'சூரிய குளிர்பதன தர போனஸ்',
      AppLanguage.kannada: 'ಸೌರ ಶೀತಲ ಗುಣಮಟ್ಟದ ಪ್ರೀಮಿಯಂ',
    },
    'hub_fee': {
      AppLanguage.english: 'FPO Hub Handling & Intake Fee',
      AppLanguage.telugu: 'FPO హబ్ నిర్వహణ రుసుము',
      AppLanguage.hindi: 'एफपीओ हब हैंडलिंग शुल्क',
      AppLanguage.tamil: 'FPO மையக் கட்டணம்',
      AppLanguage.kannada: 'ಎಫ್‌ಪಿಒ ಹಬ್ ನಿರ್ವಹಣಾ ಶುಲ್ಕ',
    },
    'net_farmer_payout': {
      AppLanguage.english: 'Net Direct Bank Payout to Farmer',
      AppLanguage.telugu: 'రైతు ఖాతాకు జమ అయ్యే నికర మొత్తం',
      AppLanguage.hindi: 'किसान के खाते में शुद्ध देय राशि',
      AppLanguage.tamil: 'விவசாயிக்கு நேரடி வங்கி பட்டுவாடா',
      AppLanguage.kannada: 'ರೈತರ ಖಾತೆಗೆ ನೇರ ನಿವ್ವಳ ಪಾವತಿ',
    },
    'settlement_complete_badge': {
      AppLanguage.english: 'DISBURSED VIA NPCI DBT',
      AppLanguage.telugu: 'NPCI DBT ద్వారా చెల్లించబడింది',
      AppLanguage.hindi: 'एनपीसीआई डीबीटी द्वारा प्रेषित',
      AppLanguage.tamil: 'வங்கி கணக்கில் செலுத்தப்பட்டது',
      AppLanguage.kannada: 'ಬ್ಯಾಂಕ್ ಖಾತೆಗೆ ಜಮೆ ಮಾಡಲಾಗಿದೆ',
    },
  };

  String get(String key) {
    final entry = _strings[key];
    if (entry == null) return key;
    return entry[language] ?? entry[AppLanguage.english] ?? key;
  }
}

class _AppLocalizationsScope extends InheritedWidget {
  final AppLocalizations localizations;

  const _AppLocalizationsScope({
    required this.localizations,
    required super.child,
  });

  @override
  bool updateShouldNotify(_AppLocalizationsScope oldWidget) {
    return localizations.language != oldWidget.localizations.language;
  }
}

class LocalizationProvider extends StatefulWidget {
  final Widget child;
  const LocalizationProvider({super.key, required this.child});

  static LocalizationProviderState? of(BuildContext context) {
    return context.findAncestorStateOfType<LocalizationProviderState>();
  }

  @override
  State<LocalizationProvider> createState() => LocalizationProviderState();
}

class LocalizationProviderState extends State<LocalizationProvider> {
  AppLanguage _currentLanguage = AppLanguage.english;

  AppLanguage get currentLanguage => _currentLanguage;

  void setLanguage(AppLanguage language) {
    if (_currentLanguage != language) {
      setState(() {
        _currentLanguage = language;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AppLocalizationsScope(
      localizations: AppLocalizations(_currentLanguage),
      child: widget.child,
    );
  }
}
