import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tewke_test/carbon_intensity/domain/carbon_intensity_screen_state.dart';
import 'package:tewke_test/carbon_intensity/repostitory/carbon_intensity_repository.dart';
import 'package:tewke_test/carbon_intensity/repostitory/neso_carbon_intensity_repository.dart';

import 'controller/current_carbon_intensity_controller.dart';
import 'controller/historic_carbon_intensity_controller.dart';
import 'domain/carbon_intensity.dart';

final _carbonIntensityRepositoryProvider = Provider<CarbonIntensityRepository>(
    (ref) => NesoCarbonIntensityRepository());

final currentCarbonIntensityControllerProvider = StateNotifierProvider<
        CurrentCarbonIntensityController, AsyncValue<CarbonIntensity>>(
    (ref) => CurrentCarbonIntensityController(
        carbonIntensityRepository:
            ref.watch(_carbonIntensityRepositoryProvider)));

final historicCarbonIntensityControllerProvider = StateNotifierProvider<
        HistoricCarbonIntensityController, CarbonIntensityScreenState>(
    (ref) => HistoricCarbonIntensityController(
        carbonIntensityRepository:
            ref.watch(_carbonIntensityRepositoryProvider),
        initialDate: DateTime.now()));
