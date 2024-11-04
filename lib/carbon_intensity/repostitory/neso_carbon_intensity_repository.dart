import 'dart:convert';

import 'package:http/http.dart';

import '../domain/carbon_intensity.dart';
import 'carbon_intensity_repository.dart';

const String baseUrl = 'https://api.carbonintensity.org.uk';
const String intensityUrl = '$baseUrl/intensity';
const String todaysIntensityUrl = '$baseUrl/intensity/date';

class NesoCarbonIntensityRepository extends CarbonIntensityRepository {
  NesoCarbonIntensityRepository();

  @override
  Future<CarbonIntensity> getIntensity() {
    return get(Uri.parse(intensityUrl)).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        return CarbonIntensity.fromJson(json['data'].first);
      } else {
        throw Exception('Failed to load carbon intensity');
      }
    });
  }

  @override
  Future<List<CarbonIntensity>> getTodaysIntensity() async {
    final response = await get(Uri.parse(todaysIntensityUrl));
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return List<CarbonIntensity>.from(
          json['data'].map((x) => CarbonIntensity.fromJson(x)));
    } else {
      throw Exception('Failed to load carbon intensity');
    }
  }

  @override
  Future<List<CarbonIntensity>> getIntensityForDate(DateTime date) {
    String formattedDate = date.toIso8601String().split('T')[0];
    final String request = '$todaysIntensityUrl/$formattedDate';
    return get(Uri.parse(request)).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        var unfilteredList = List<CarbonIntensity>.from(
            json['data'].map((x) => CarbonIntensity.fromJson(x)));

        // Filter out the data that is not for the requested date
        return unfilteredList
            .where((element) =>
                element.from.year == date.year &&
                element.from.month == date.month &&
                element.from.day == date.day)
            .toList();
      } else {
        throw Exception('Failed to load carbon intensity');
      }
    });
  }
}
