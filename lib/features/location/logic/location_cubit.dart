import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/city_response.dart';
import '../data/models/country_response.dart';
import '../data/repo/location_repo.dart';
import 'location_states.dart';

class LocationCubit extends Cubit<LocationStates> {
  final LocationRepo _locationRepo;

  LocationCubit(this._locationRepo)
      : super(const LocationStates()) {
    fetchCountries();
  }

  CountryResponse? get selectedCountry => state.selectedCountry;
  CityResponse? get selectedCity => state.selectedCity;

  Future<void> fetchCountries() async {
    try {
      final result = await _locationRepo.getCountries();
      result.when(
        success: (countries) {
          emit(state.copyWith(
            countries: countries,
            isCountryLoading: false,
          ));
        },
        failure: (error) {
          emit(state.copyWith(
            error: error,
            isCountryLoading: false,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isCountryLoading: false,
      ));
    }
  }

  Future<void> setSelectedCountry(CountryResponse country) async {
    emit(state.copyWith(
      selectedCountry: country,
      selectedCity: null,
      isCityLoading: true,
      cities: [],
    ));

    try {
      final result = await _locationRepo.getCities(country.id);
      result.when(
        success: (cities) {
          emit(state.copyWith(
            cities: cities,
            isCityLoading: false,
          ));
        },
        failure: (error) {
          emit(state.copyWith(
            error: error,
            isCityLoading: false,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isCityLoading: false,
      ));
    }
  }

  void setSelectedCity(CityResponse city) {
    emit(state.copyWith(
      selectedCity: city,
    ));
  }

  void reset() {
    emit(state.copyWith(
      selectedCountry: null,
      selectedCity: null,
      cities: [],
      error: null,
    ));
  }
}

