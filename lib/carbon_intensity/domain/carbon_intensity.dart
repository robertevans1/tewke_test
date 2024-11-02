import 'package:intl/intl.dart';

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

  String get date {
    return DateFormat('dd/MM/yyyy').format(from);
  }

  String get fromTime {
    return DateFormat('HH:mm').format(from);
  }

  String get toTime {
    return DateFormat('HH:mm').format(to);
  }
}
