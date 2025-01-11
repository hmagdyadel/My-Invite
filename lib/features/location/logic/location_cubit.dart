import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/city_response.dart';
import '../data/models/country_response.dart';
import '../data/repo/location_repo.dart';
import 'location_states.dart';

class LocationCubit extends Cubit<LocationStates<List<dynamic>>> {
  final LocationRepo _locationRepo;
  List<CountryResponse> _countries = [];
  List<CityResponse> _cities = [];
  CountryResponse? _selectedCountry;
  CityResponse? _selectedCity;

  LocationCubit(this._locationRepo) : super(const LocationStates.initial()) {
    fetchCountries();
  }

  List<CountryResponse> get countries => _countries;

  List<CityResponse> get cities => _cities;

  CountryResponse? get selectedCountry => _selectedCountry;

  CityResponse? get selectedCity => _selectedCity;

  void setSelectedCountry(CountryResponse country) {
    _selectedCountry = country;
    _selectedCity = null;
    _cities = [];
    fetchCities(country.id);
  }

  void setSelectedCity(CityResponse city) {
    emit(const LocationStates.loading());

    debugPrint("Setting selected city: ${city.cityName}");
    _selectedCity = city;
    // Emit success with current cities to trigger UI update
    emit(LocationStates.success(_cities));
  }

  Future<void> fetchCountries() async {
    emit(const LocationStates.loading());

    try {
      final result = await _locationRepo.getCountries();
      result.when(
        success: (countries) {
          _countries = countries;
          emit(LocationStates.success(countries));
        },
        failure: (error) {
          emit(LocationStates.error(message: error));
        },
      );
    } catch (e) {
      emit(LocationStates.error(message: e.toString()));
    }
  }

  Future<void> fetchCities(int countryId) async {
    emit(const LocationStates.loading());

    try {
      final result = await _locationRepo.getCities(countryId);
      result.when(
        success: (cities) {
          _cities = cities;
          emit(LocationStates.success(cities));
        },
        failure: (error) {
          emit(LocationStates.error(message: error));
        },
      );
    } catch (e) {
      emit(LocationStates.error(message: e.toString()));
    }
  }

  void reset() {
    _selectedCountry = null;
    _selectedCity = null;
    _cities = [];
    emit(LocationStates.success(_countries));
  }
}
