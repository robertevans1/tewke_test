import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tewke_test/carbon_intensity/repostitory/carbon_intensity_repository.dart';

import '../domain/carbon_intensity.dart';

class CurrentCarbonIntensityController
    extends StateNotifier<AsyncValue<CarbonIntensity>> {
  final CarbonIntensityRepository carbonIntensityRepository;

  CurrentCarbonIntensityController({required this.carbonIntensityRepository})
      : super(const AsyncValue.loading()) {
    getIntensity();

    // Refresh the data every 5 minutes
    Timer.periodic(const Duration(minutes: 5), (_) => getIntensity());
  }

  void getIntensity() async {
    state = const AsyncValue.loading();
    try {
      final intensity = await carbonIntensityRepository.getIntensity();
      state = AsyncValue.data(intensity);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
