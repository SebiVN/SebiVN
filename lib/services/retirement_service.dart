import 'package:shared_preferences/shared_preferences.dart';

enum CountdownType { days, months, years }

class RetirementCalculation {
  final DateTime retirementDate;
  final int totalDays;
  final int totalMonths;
  final int totalYears;
  final int years;
  final int months;
  final int days;

  RetirementCalculation({
    required this.retirementDate,
    required this.totalDays,
    required this.totalMonths,
    required this.totalYears,
    required this.years,
    required this.months,
    required this.days,
  });
}

class RetirementService {
  static const String _keyBirthDate = 'birth_date';
  static const String _keyCountryCode = 'country_code';
  static const String _keyIsMale = 'is_male';
  static const String _keyCountdownType = 'countdown_type';

  Future<void> saveBirthDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBirthDate, date.toIso8601String());
  }

  Future<DateTime?> getBirthDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString(_keyBirthDate);
    if (dateStr == null) return null;
    return DateTime.parse(dateStr);
  }

  Future<void> saveCountryCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCountryCode, code);
  }

  Future<String?> getCountryCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCountryCode);
  }

  Future<void> saveIsMale(bool isMale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsMale, isMale);
  }

  Future<bool> getIsMale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsMale) ?? true;
  }

  Future<void> saveCountdownType(CountdownType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCountdownType, type.index);
  }

  Future<CountdownType> getCountdownType() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_keyCountdownType) ?? 0;
    return CountdownType.values[index];
  }

  RetirementCalculation? calculateTimeToRetirement(
    DateTime birthDate,
    int retirementAge,
  ) {
    final retirementDate = DateTime(
      birthDate.year + retirementAge,
      birthDate.month,
      birthDate.day,
    );

    final now = DateTime.now();

    if (now.isAfter(retirementDate)) {
      return null; // Deja pensionat
    }

    // Calcul total zile
    final totalDays = retirementDate.difference(now).inDays;

    // Calcul total luni (aproximativ)
    final totalMonths = (totalDays / 30.44).round();

    // Calcul total ani
    final totalYears = (totalDays / 365.25).round();

    // Calcul detaliat
    int years = 0;
    int months = 0;
    int days = 0;

    DateTime temp = now;

    // Calculăm anii
    while (temp.year < retirementDate.year - 1) {
      years++;
      temp = DateTime(temp.year + 1, temp.month, temp.day);
    }

    // Calculăm lunile
    while (temp.month < retirementDate.month ||
        (temp.month == retirementDate.month && temp.day < retirementDate.day)) {
      if (temp.year < retirementDate.year) {
        months++;
        temp = DateTime(temp.year, temp.month + 1, temp.day);
      } else {
        break;
      }
    }

    // Calculăm zilele
    days = retirementDate.difference(temp).inDays;

    // Ajustare finală
    if (temp.year < retirementDate.year) {
      years++;
      temp = DateTime(retirementDate.year, temp.month, temp.day);

      if (temp.month <= retirementDate.month) {
        months = retirementDate.month - temp.month;
        if (temp.day > retirementDate.day) {
          if (months > 0) {
            months--;
          } else {
            years--;
            months = 11;
          }
          days = DateTime(retirementDate.year, retirementDate.month + 1, 0).day -
              temp.day +
              retirementDate.day;
        } else {
          days = retirementDate.day - temp.day;
        }
      }
    }

    return RetirementCalculation(
      retirementDate: retirementDate,
      totalDays: totalDays,
      totalMonths: totalMonths,
      totalYears: totalYears,
      years: years,
      months: months,
      days: days,
    );
  }

  String formatCountdown(RetirementCalculation calc, CountdownType type) {
    switch (type) {
      case CountdownType.days:
        return '${calc.totalDays} zile';
      case CountdownType.months:
        return '${calc.totalMonths} luni';
      case CountdownType.years:
        return '${calc.totalYears} ani';
    }
  }

  String formatDetailedCountdown(RetirementCalculation calc) {
    return '${calc.years} ani, ${calc.months} luni, ${calc.days} zile';
  }
}
