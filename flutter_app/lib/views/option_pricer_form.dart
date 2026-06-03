import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pricer_app/models/Session.dart';
import 'package:pricer_app/models/option.dart';
import 'package:pricer_app/services/storage_service.dart';
import 'package:pricer_app/services/user_service.dart';
import 'package:pricer_app/views/option.dart';

class OptionPricerForm extends StatefulWidget {
  final Option? option;

  const OptionPricerForm({super.key, this.option});

  @override
  State<StatefulWidget> createState() {
    return OptionPricerFormState();
  }
}

class OptionPricerFormState extends State<OptionPricerForm> {
  final StorageService _storageService = StorageService.getInstance();

  static const apiHOST = String.fromEnvironment('API_HOST', defaultValue: 'localhost');
  static const apiPORT = String.fromEnvironment('API_PORT', defaultValue: '8080');

  final UserService _userService = UserService(
    baseURL: 'http://$apiHOST:$apiPORT/auth',
  );

  late GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late int _id;
  late TextEditingController _typeC;
  late TextEditingController _spotC;
  late TextEditingController _strikeC;
  late TextEditingController _rateDomesticC;
  late TextEditingController _rateForeignC;
  late TextEditingController _volatilityC;
  late TextEditingController _maturityC;
  late TextEditingController _dayCounterC;

  @override
  initState() {
    super.initState();
    setState(() {
      _id = widget.option?.id ?? 0;
      _typeC = TextEditingController(
        text: widget.option?.type.toString() ?? 'Call',
      );
      _spotC = TextEditingController(
        text: widget.option?.spot.toString() ?? "100",
      );
      _strikeC = TextEditingController(
        text: widget.option?.strike.toString() ?? "110",
      );
      _rateDomesticC = TextEditingController(
        text: widget.option?.rateDomestic.toString() ?? "0.04",
      );
      _rateForeignC = TextEditingController(
        text: widget.option?.rateForeign.toString() ?? "0.02",
      );
      _volatilityC = TextEditingController(
        text: widget.option?.volatility.toString() ?? "0.7",
      );
      _maturityC = TextEditingController(
        text:
            widget.option?.maturity.toString() ??
            DateTime.now().toString().split(' ')[0],
      );
      _dayCounterC = TextEditingController(
        text: widget.option?.dayCounter.toString() ?? "ActualActual",
      );
    });
  }

  String? validateRequiredString(String? val) {
    if (val == null || val.isEmpty) return "this field is mandatory";
    return null;
  }

  _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String? token = await _storageService.getToken();
      final Session session = await _userService.me(token!);
      final int id = _id;
      final type = Type.fromString(_typeC.text);
      final spot = double.parse(_spotC.text);
      final strike = double.parse(_strikeC.text);
      final double rateDomestic = double.parse(_rateDomesticC.text);
      final double rateForeign = double.parse(_rateForeignC.text);
      final double volatility = double.parse(_volatilityC.text);
      final maturity = _getStringDate(DateTime.parse(_maturityC.text));
      final dayCounter = DayCounter.fromString(_dayCounterC.text);
      final double price = widget.option?.price ?? 0.0;
      final Option option = Option(
        client: session.pseudo,
        id: id,
        type: type,
        spot: spot,
        strike: strike,
        rateDomestic: rateDomestic,
        rateForeign: rateForeign,
        volatility: volatility,
        maturity: maturity,
        dayCounter: dayCounter,
        price: price,
      );

      if (option.client == 'error') {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OptionWidget(option: option)),
      );
    }
  }

  String _getStringDate(DateTime date){
    return date.toString().split(' ')[0];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // default today
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      // 2025-07-08 00:00:00.000
      _maturityC.text = _getStringDate(picked);
    }
  }

  @override
  void dispose() {
    _typeC.dispose();
    _spotC.dispose();
    _strikeC.dispose();
    _rateDomesticC.dispose();
    _rateForeignC.dispose();
    _maturityC.dispose();
    _volatilityC.dispose();
    _dayCounterC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Option Pricer"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actionsPadding: EdgeInsetsGeometry.symmetric(horizontal: 50),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.orange.shade200;
                }
                return null;
              }),
              // padding: WidgetStateProperty.all(EdgeInsetsGeometry.all(5)),
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: Row(spacing: 5, children: [Icon(Icons.home), Text('Home')]),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.orange.shade200;
                }
                return null;
              }),

              // padding: WidgetStateProperty.all(EdgeInsetsGeometry.all(5)),
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/logout',
                (route) => false,
              );
            },
            child: Row(
              spacing: 5,
              children: [Icon(Icons.logout), Text('Logout')],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 350, right: 350, top: 90),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                TextFormField(
                  controller: _typeC,
                  validator: validateRequiredString,
                  decoration: InputDecoration(labelText: "Type"),
                ),
                TextFormField(
                  controller: _spotC,
                  validator: validateRequiredString,
                  decoration: InputDecoration(labelText: "Spot"),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                  ],
                ),
                TextFormField(
                  controller: _strikeC,
                  validator: validateRequiredString,
                  decoration: InputDecoration(labelText: "Strike"),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                  ],
                ),
                TextFormField(
                  controller: _rateDomesticC,
                  validator: validateRequiredString,
                  decoration: InputDecoration(
                    labelText: "Risk-Free Rate Domestic",
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                  ],
                ),
                TextFormField(
                  controller: _rateForeignC,
                  validator: validateRequiredString,
                  decoration: InputDecoration(
                    labelText: "Risk-Free Rate Foreign",
                  ),
                ),
                TextFormField(
                  controller: _volatilityC,
                  validator: validateRequiredString,
                  decoration: InputDecoration(labelText: "Volatility"),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                  ],
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _maturityC,
                      decoration: InputDecoration(
                        labelText: "Select Date",
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _dayCounterC,
                  validator: validateRequiredString,
                  decoration: InputDecoration(labelText: "Day Counter"),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize:  WidgetStateProperty.all(const Size(450, 50)), // width, height,
                    backgroundColor: WidgetStateProperty.resolveWith((states){
                      if (states.contains(WidgetState.hovered)) {
                        return Colors.cyan;
                      }
                      return null;
                    }),
                  ),
                  onPressed: _submitForm, 
                  child: Text("Compute", style: TextStyle(fontSize: 23))
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
