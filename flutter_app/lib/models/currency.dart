class Currency {
  late String? name;
  final String symbol;

  Currency({this.name = "no name", required this.symbol}){
    switch (symbol) {
      case "AUD":
        name = "Australian Dollar";
        break;
      case "BGN":
        name = "Bulgarian Lev";
        break;
      case "BRL":
        name = "Brazilian Real";
        break;
      case "CAD":
        name = "Canadian Dollar";
        break;
      case "CHF":
        name = "Swiss Franc";
        break;
      case "CNY":
        name = "Chinese Renminbi Yuan";
        break;
      case "CZK":
        name = "Czech Koruna";
        break;
      case "DKK":
        name = "Danish Krone";
        break;
      case "EUR":
        name = "Euro";
        break;
      case "GBP":
        name = "British Pound";
        break;
      case "HKD":
        name = "Hong Kong Dollar";
        break;
      case "HUF":
        name = "Hungarian Forint";
        break;
      case "IDR":
        name = "Indonesian Rupiah";
        break;
      case "ILS":
        name = "Israeli New Sheqel";
        break;
      case "INR":
        name = "Indian Rupee";
        break;
      case "ISK":
        name = "Icelandic Króna";
        break;
      case "JPY":
        name = "Japanese Yen";
        break;
      case "KRW":
        name = "South Korean Won";
        break;
      case "MXN":
        name = "Mexican Peso";
        break;
      case "MYR":
        name = "Malaysian Ringgit";
        break;
      case "NOK":
        name = "Norwegian Krone";
        break;
      case "NZD":
        name = "New Zealand Dollar";
        break;
      case "PHP":
        name = "Philippine Peso";
        break;
      case "PLN":
        name = "Polish Złoty";
        break;
      case "RON":
        name = "Romanian Leu";
        break;
      case "SEK":
        name = "Swedish Krona";
        break;
      case "SGD":
        name = "Singapore Dollar";
        break;
      case "THB":
        name = "Thai Baht";
        break;
      case "TRY":
        name = "Turkish Lira";
        break;
      case "USD":
        name = "United States Dollar";
        break;
      case "ZAR":
        name = "South African Rand";
        break;
      default:
        name = name ?? "Unknown Currency";
    }
  }
}