import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tewke_test/carbon_intensity/repostitory/carbon_intensity_repository.dart';
import 'package:tewke_test/carbon_intensity/repostitory/neso_carbon_intensity_repository.dart';

import 'controller/carbon_intensity_controller.dart';
import 'domain/carbon_intensity.dart';

final _carbonIntensityRepositoryProvider = Provider<CarbonIntensityRepository>(
    (ref) => NesoCarbonIntensityRepository());

final carbonIntensityControllerProvider = StateNotifierProvider<
        CarbonIntensityController, AsyncValue<List<CarbonIntensity>>>(
    (ref) => CarbonIntensityController(
        carbonIntensityRepository:
            ref.watch(_carbonIntensityRepositoryProvider)));
