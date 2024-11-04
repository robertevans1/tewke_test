import 'carbon_intensity.dart';

class CarbonIntensityScreenState {
  final List<CarbonIntensity> data;
  final DateTime date;
  final CarbonIntensity? selectedData;
  final bool isLoading;
  final bool display;
  final String? error;

  const CarbonIntensityScreenState({
    required this.data,
    required this.isLoading,
    required this.date,
    required this.selectedData,
    required this.display,
    this.error,
  });

  CarbonIntensityScreenState copyWith({
    List<CarbonIntensity>? data,
    DateTime? date,
    CarbonIntensity? selectedData,
    bool? isLoading,
    bool? display,
    String? error,
  }) {
    return CarbonIntensityScreenState(
      data: data ?? this.data,
      date: date ?? this.date,
      selectedData: selectedData ?? this.selectedData,
      isLoading: isLoading ?? this.isLoading,
      display: display ?? this.display,
      error: error,
    );
  }
}
