class CarbonIntensity {
  final DateTime from;
  final DateTime to;
  final int forecastIntensity;
  final int? actualIntensity;

  CarbonIntensity({
    required this.from,
    required this.to,
    required this.forecastIntensity,
    required this.actualIntensity,
  });

  factory CarbonIntensity.fromJson(Map<String, dynamic> json) {
    return CarbonIntensity(
      from: DateTime.parse(json['from']),
      to: DateTime.parse(json['to']),
      forecastIntensity: json['intensity']['forecast'],
      actualIntensity: json['intensity']['actual'],
    );
  }
}
