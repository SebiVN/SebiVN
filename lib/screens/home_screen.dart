import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/country_retirement.dart';
import '../services/retirement_service.dart';
import '../widgets/countdown_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RetirementService _service = RetirementService();

  DateTime? _birthDate;
  String? _countryCode;
  bool _isMale = true;
  CountdownType _countdownType = CountdownType.days;
  RetirementCalculation? _calculation;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final birthDate = await _service.getBirthDate();
    final countryCode = await _service.getCountryCode();
    final isMale = await _service.getIsMale();
    final countdownType = await _service.getCountdownType();

    setState(() {
      _birthDate = birthDate;
      _countryCode = countryCode ?? 'RO';
      _isMale = isMale;
      _countdownType = countdownType;
    });

    _calculateRetirement();
  }

  void _calculateRetirement() {
    if (_birthDate == null || _countryCode == null) return;

    final country = RetirementData.getCountryByCode(_countryCode!);
    if (country == null) return;

    final retirementAge = country.getRetirementAge(_isMale);
    final calc = _service.calculateTimeToRetirement(_birthDate!, retirementAge);

    setState(() {
      _calculation = calc;
    });
  }

  Future<void> _selectBirthDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(1990, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      locale: const Locale('ro', 'RO'),
    );

    if (date != null) {
      await _service.saveBirthDate(date);
      setState(() {
        _birthDate = date;
      });
      _calculateRetirement();
    }
  }

  Future<void> _selectCountry() async {
    final country = await showDialog<CountryRetirement>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selectează țara'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: RetirementData.countries.length,
            itemBuilder: (context, index) {
              final country = RetirementData.countries[index];
              return ListTile(
                title: Text(country.name),
                subtitle: Text(
                  'Bărbați: ${country.retirementAgeMale} ani, '
                  'Femei: ${country.retirementAgeFemale} ani',
                ),
                onTap: () => Navigator.pop(context, country),
              );
            },
          ),
        ),
      ),
    );

    if (country != null) {
      await _service.saveCountryCode(country.code);
      setState(() {
        _countryCode = country.code;
      });
      _calculateRetirement();
    }
  }

  @override
  Widget build(BuildContext context) {
    final country = _countryCode != null
        ? RetirementData.getCountryByCode(_countryCode!)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator Pensionare'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date personale',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Data nașterii'),
                      subtitle: Text(
                        _birthDate != null
                            ? DateFormat('dd MMMM yyyy', 'ro_RO')
                                .format(_birthDate!)
                            : 'Neselectată',
                      ),
                      onTap: _selectBirthDate,
                    ),
                    ListTile(
                      leading: const Icon(Icons.public),
                      title: const Text('Țara'),
                      subtitle: Text(country?.name ?? 'Neselectată'),
                      onTap: _selectCountry,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Icon(Icons.person),
                        ),
                        const SizedBox(width: 32),
                        const Text('Sex:'),
                        const SizedBox(width: 16),
                        ChoiceChip(
                          label: const Text('Bărbat'),
                          selected: _isMale,
                          onSelected: (selected) async {
                            if (selected) {
                              await _service.saveIsMale(true);
                              setState(() {
                                _isMale = true;
                              });
                              _calculateRetirement();
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Femeie'),
                          selected: !_isMale,
                          onSelected: (selected) async {
                            if (selected) {
                              await _service.saveIsMale(false);
                              setState(() {
                                _isMale = false;
                              });
                              _calculateRetirement();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_calculation != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Timp rămas până la pensionare',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: CountdownWidget(
                          calculation: _calculation!,
                          countdownType: _countdownType,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          _service.formatDetailedCountdown(_calculation!),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Data pensionării: ${DateFormat('dd MMMM yyyy', 'ro_RO').format(_calculation!.retirementDate)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tip countdown',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Zile'),
                            selected: _countdownType == CountdownType.days,
                            onSelected: (selected) async {
                              if (selected) {
                                await _service
                                    .saveCountdownType(CountdownType.days);
                                setState(() {
                                  _countdownType = CountdownType.days;
                                });
                              }
                            },
                          ),
                          ChoiceChip(
                            label: const Text('Luni'),
                            selected: _countdownType == CountdownType.months,
                            onSelected: (selected) async {
                              if (selected) {
                                await _service
                                    .saveCountdownType(CountdownType.months);
                                setState(() {
                                  _countdownType = CountdownType.months;
                                });
                              }
                            },
                          ),
                          ChoiceChip(
                            label: const Text('Ani'),
                            selected: _countdownType == CountdownType.years,
                            onSelected: (selected) async {
                              if (selected) {
                                await _service
                                    .saveCountdownType(CountdownType.years);
                                setState(() {
                                  _countdownType = CountdownType.years;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (_birthDate != null && _countryCode != null)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Felicitări! Ești deja pensionat(ă)! 🎉',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Completează data nașterii și țara pentru a vedea countdown-ul',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
