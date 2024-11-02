import 'dart:convert';

import 'package:http/http.dart';

import '../domain/carbon_intensity.dart';
import 'carbon_intensity_repository.dart';

const String baseUrl = 'https://api.carbonintensity.org.uk';
const String todaysIntensityUrl = '$baseUrl/intensity/date';

class NesoCarbonIntensityRepository extends CarbonIntensityRepository {
  NesoCarbonIntensityRepository();

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
}
