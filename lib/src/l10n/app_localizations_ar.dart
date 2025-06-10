// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تطبيق الطقس';

  @override
  String get searchCityHint => 'ابحث عن مدينة';

  @override
  String get currentWeather => 'الطقس الحالي';

  @override
  String get temperature => 'درجة الحرارة';

  @override
  String get feelsLike => 'إحساس الحرارة';

  @override
  String get humidity => 'الرطوبة';

  @override
  String get windSpeed => 'سرعة الرياح';

  @override
  String get forecast => 'توقعات لمدة 5 أيام';

  @override
  String get today => 'اليوم';

  @override
  String get errorFetchingWeather => 'خطأ في جلب بيانات الطقس';

  @override
  String get errorFetchingLocation => 'خطأ في جلب الموقع';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get noWeatherFound => 'لم يتم العثور على بيانات طقس لهذه المدينة.';

  @override
  String get enableLocationServices => 'يرجى تفعيل خدمات الموقع.';

  @override
  String get locationPermissionDenied =>
      'تم رفض إذن الموقع. يرجى تفعيله من الإعدادات.';

  @override
  String get locationPermissionPermanentlyDenied =>
      'تم رفض إذن الموقع بشكل دائم. يرجى تفعيله من إعدادات التطبيق.';

  @override
  String get gettingLocation => 'جاري تحديد موقعك...';

  @override
  String get fetchingWeather => 'جاري جلب الطقس...';

  @override
  String get settings => 'الإعدادات';

  @override
  String get theme => 'المظهر';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get systemMode => 'افتراضي النظام';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get weatherConditions => 'أحوال الطقس';

  @override
  String get sunrise => 'شروق الشمس';

  @override
  String get sunset => 'غروب الشمس';

  @override
  String get pressure => 'الضغط الجوي';

  @override
  String get visibility => 'الرؤية';

  @override
  String get updated => 'آخر تحديث';

  @override
  String get high => 'عظمى';

  @override
  String get low => 'صغرى';

  @override
  String get sunday => 'الأحد';

  @override
  String get monday => 'الاثنين';

  @override
  String get tuesday => 'الثلاثاء';

  @override
  String get wednesday => 'الأربعاء';

  @override
  String get thursday => 'الخميس';

  @override
  String get friday => 'الجمعة';

  @override
  String get saturday => 'السبت';

  @override
  String get unknown => 'غير معروف';
}
