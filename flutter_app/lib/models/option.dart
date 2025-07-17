class Option {
  final int? id;
  final Type type;
  final double spot;
  final double strike;
  final double rateDomestic; //risk-free rate domestic
  final double rateForeign; // risk-free rate foreign
  final double volatility;
  final String maturity;
  final DayCounter dayCounter;
  double? price;
  final String? client;

  Option({
    this.id,
    required this.type,
    required this.spot,
    required this.strike,
    required this.rateDomestic,
    required this.rateForeign,
    required this.volatility,
    required this.maturity,
    required this.dayCounter,
    this.price,
    this.client
  });

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'type': type.toString(),
      'spot': spot,
      'strike': strike,
      'rateDomestic': rateDomestic,
      'rateForeign': rateForeign,
      'volatility': volatility,
      'maturity': maturity,
      'dayCounter': dayCounter.toString(),
      'price': price,
      'client': client
    };
  }

  factory Option.fromJSON(Map<dynamic, dynamic> json) => Option(
      id: json['id'],
      type: Type.fromString(json['type']),
      spot: json['spot'],
      strike: json['strike'],
      rateDomestic: json['rateDomestic'],
      rateForeign: json['rateForeign'],
      volatility: json['volatility'],
      maturity: json['maturity'],
      dayCounter: DayCounter.fromString(json['dayCounter']),
      price: json['price'] ?? null
    );
}

enum Type {
  Call,
  Put,
  None;

  static Type fromString(String value) {
    switch (value.toLowerCase()) {
      case "call":
        return Type.Call;
      case "put":
        return Type.Put;
      default:
        return Type.None;
    }
  }

  @override
  String toString() {
    switch (this) {
      case Type.Call:
        return "Call";
      case Type.Put:
        return "Put";
      default:
        return "";
    }
  }

}

enum DayCounter {
  ActualActual,
  Actual365,
  None;

  static fromString(String value) {
    switch (value.toLowerCase()) {
      case "actualactual":
        return DayCounter.ActualActual;
      case "actual365":
        return DayCounter.Actual365;
      default:
        return DayCounter.None;
    }
  }

  String toString() {
    switch (this) {
      case DayCounter.ActualActual:
        return "ActualActual";
      case DayCounter.Actual365:
        return "Actual365";
      default:
        return "";
    }
  }
}
