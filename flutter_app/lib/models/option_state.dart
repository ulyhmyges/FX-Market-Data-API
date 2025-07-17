enum OptionState {
  Stored,
  Unstored,
  None;

  static OptionState fromString(String value) {
    switch (value.toLowerCase()) {
      case "stored":
        return OptionState.Stored;
      case "unstored":
        return OptionState.Unstored;
      default:
        return OptionState.None;
    }
  }

  @override
  String toString() {
    switch (this){
      case OptionState.Stored:
        return "Stored";
      case OptionState.Unstored:
        return "Unstored";
      default:
        return "";
    }
  }

  static OptionState fromJSON(Map<dynamic, dynamic> json) {
    return fromString(json['state']);
  }

  Map<String, dynamic> toJSON() {
    return {
      'state': toString()
    };
  }
}