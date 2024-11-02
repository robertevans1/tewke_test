import '../domain/carbon_intensity.dart';

abstract class CarbonIntensityRepository {
  Future<List<CarbonIntensity>> getTodaysIntensity();
}
