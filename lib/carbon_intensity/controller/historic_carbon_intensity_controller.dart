import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tewke_test/carbon_intensity/domain/carbon_intensity_screen_state.dart';
import 'package:tewke_test/carbon_intensity/repostitory/carbon_intensity_repository.dart';

import '../domain/carbon_intensity.dart';

class HistoricCarbonIntensityController
    extends StateNotifier<CarbonIntensityScreenState> {
  final CarbonIntensityRepository carbonIntensityRepository;

  HistoricCarbonIntensityController(
      {required this.carbonIntensityRepository, required DateTime initialDate})
      : super(CarbonIntensityScreenState(
            data: const [],
            date: initialDate,
            isLoading: true,
            display: false,
            selectedData: null,
            error: null)) {
    getIntensityForDate(initialDate);
  }

  void getIntensityForDate(DateTime date) async {
    state = state.copyWith(isLoading: true, date: date);
    try {
      final intensity =
          await carbonIntensityRepository.getIntensityForDate(date);

      // If it is today, set selected data to be now, otherwise midday
      if (dateIsToday()) {
        state = state.copyWith(
            data: intensity,
            isLoading: false,
            selectedData: intensity
                .firstWhere((element) => element.to.isAfter(DateTime.now())));
      } else {
        state = state.copyWith(
            data: intensity,
            isLoading: false,
            selectedData: intensity.firstWhere((element) => element.to
                .isAfter(DateTime(date.year, date.month, date.day, 12))));
      }

      state = state.copyWith(data: intensity, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  bool dateIsToday() {
    final now = DateTime.now();
    return state.date.year == now.year &&
        state.date.month == now.month &&
        state.date.day == now.day;
  }

  void setSelectedData(CarbonIntensity? data) {
    state = state.copyWith(selectedData: data);
  }

  void loadPreviousDay() {
    final previousDay = state.date.subtract(const Duration(days: 1));
    getIntensityForDate(previousDay);
  }

  void loadNextDay() {
    final nextDay = state.date.add(const Duration(days: 1));
    getIntensityForDate(nextDay);
  }

  void toggleDisplay() {
    state = state.copyWith(display: !state.display);
  }
}
