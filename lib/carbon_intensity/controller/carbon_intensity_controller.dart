import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tewke_test/carbon_intensity/repostitory/carbon_intensity_repository.dart';

import '../domain/carbon_intensity.dart';

class CarbonIntensityController
    extends StateNotifier<AsyncValue<List<CarbonIntensity>>> {
  final CarbonIntensityRepository carbonIntensityRepository;

  CarbonIntensityController({required this.carbonIntensityRepository})
      : super(const AsyncValue.loading()) {
    getTodaysIntensity();
  }

  void getTodaysIntensity() async {
    state = const AsyncValue.loading();
    try {
      final intensity = await carbonIntensityRepository.getTodaysIntensity();
      state = AsyncValue.data(intensity);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
