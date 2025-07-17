import 'rates.dart';

class Forex {
  final int amount;
  final String base;
  final String date;
  final Rates rates;

  Forex({required this.amount, required this.base, required this.date, required this.rates});

  factory Forex.fromJSON(Map<dynamic, dynamic> json) {
    return Forex(
      amount: json['amount'],
      base: json['base'],
      date: json['date'],
      rates: Rates(
          AUD: json['rates']['AUD'] ?? 1,
          USD: json['rates']['USD'] ?? 1,
          BGN: json['rates']['BGN'] ?? 1,
          BRL: json['rates']['BRL'] ?? 1,
          CAD: json['rates']['CAD'] ?? 1,
          CHF: json['rates']['CHF'] ?? 1,
          CNY: json['rates']['CNY'] ?? 1,
          CZK: json['rates']['CZK'] ?? 1,
          DKK: json['rates']['DKK'] ?? 1,
          GBP: json['rates']['GBP'] ?? 1,
          HKD: json['rates']['HKD'] ?? 1,
          HUF: json['rates']['HUF'] ?? 1,
          IDR: json['rates']['IDR'] ?? 1,
          ILS: json['rates']['ILS'] ?? 1,
          INR: json['rates']['INR'] ?? 1,
          ISK: json['rates']['ISK'] ?? 1,
          JPY: json['rates']['JPY'] ?? 1,
          KRW: json['rates']['KRW'] ?? 1,
          MXN: json['rates']['MXN'] ?? 1,
          MYR: json['rates']['MYR'] ?? 1,
          NOK: json['rates']['NOK'] ?? 1,
          NZD: json['rates']['NZD'] ?? 1,
          PHP: json['rates']['PHP'] ?? 1,
          PLN: json['rates']['PLN'] ?? 1,
          RON: json['rates']['RON'] ?? 1,
          SEK: json['rates']['SEK'] ?? 1,
          SGD: json['rates']['SGD'] ?? 1,
          THB: json['rates']['THB'] ?? 1,
          TRY: json['rates']['TRY'] ?? 1,
          ZAR: json['rates']['ZAR'] ?? 1,
          EUR: json['rates']['EUR'] ?? 1
      )
    );
  }
}