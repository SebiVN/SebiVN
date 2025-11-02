class CountryRetirement {
  final String code;
  final String name;
  final int retirementAgeMale;
  final int retirementAgeFemale;

  CountryRetirement({
    required this.code,
    required this.name,
    required this.retirementAgeMale,
    required this.retirementAgeFemale,
  });

  int getRetirementAge(bool isMale) {
    return isMale ? retirementAgeMale : retirementAgeFemale;
  }
}

class RetirementData {
  static final List<CountryRetirement> countries = [
    CountryRetirement(
      code: 'RO',
      name: 'România',
      retirementAgeMale: 65,
      retirementAgeFemale: 63,
    ),
    CountryRetirement(
      code: 'DE',
      name: 'Germania',
      retirementAgeMale: 67,
      retirementAgeFemale: 67,
    ),
    CountryRetirement(
      code: 'FR',
      name: 'Franța',
      retirementAgeMale: 64,
      retirementAgeFemale: 64,
    ),
    CountryRetirement(
      code: 'IT',
      name: 'Italia',
      retirementAgeMale: 67,
      retirementAgeFemale: 67,
    ),
    CountryRetirement(
      code: 'ES',
      name: 'Spania',
      retirementAgeMale: 66,
      retirementAgeFemale: 66,
    ),
    CountryRetirement(
      code: 'UK',
      name: 'Regatul Unit',
      retirementAgeMale: 66,
      retirementAgeFemale: 66,
    ),
    CountryRetirement(
      code: 'US',
      name: 'Statele Unite',
      retirementAgeMale: 67,
      retirementAgeFemale: 67,
    ),
    CountryRetirement(
      code: 'CA',
      name: 'Canada',
      retirementAgeMale: 65,
      retirementAgeFemale: 65,
    ),
    CountryRetirement(
      code: 'AU',
      name: 'Australia',
      retirementAgeMale: 67,
      retirementAgeFemale: 67,
    ),
    CountryRetirement(
      code: 'NL',
      name: 'Olanda',
      retirementAgeMale: 67,
      retirementAgeFemale: 67,
    ),
    CountryRetirement(
      code: 'BE',
      name: 'Belgia',
      retirementAgeMale: 66,
      retirementAgeFemale: 66,
    ),
    CountryRetirement(
      code: 'AT',
      name: 'Austria',
      retirementAgeMale: 65,
      retirementAgeFemale: 60,
    ),
    CountryRetirement(
      code: 'CH',
      name: 'Elveția',
      retirementAgeMale: 65,
      retirementAgeFemale: 64,
    ),
  ];

  static CountryRetirement? getCountryByCode(String code) {
    try {
      return countries.firstWhere((c) => c.code == code);
    } catch (e) {
      return null;
    }
  }
}
