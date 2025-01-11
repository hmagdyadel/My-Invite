import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../data/models/city_response.dart';
import '../data/models/country_response.dart';
import '../logic/location_cubit.dart';
import '../logic/location_states.dart';
import '../../../core/widgets/normal_text.dart';
import '../../../core/theming/colors.dart';

class GatekeeperLocationSelector extends StatelessWidget {
  final Function(CountryResponse) onCountryChange;
  final Function(CityResponse) onCityChange;

  const GatekeeperLocationSelector({
    super.key,
    required this.onCountryChange,
    required this.onCityChange,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationStates>(
      builder: (context, state) {
        final locationCubit = context.read<LocationCubit>();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildCountryDropdown(
                context,
                locationCubit.countries,
                locationCubit.selectedCountry,
                state,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _buildCityDropdown(
                context,
                locationCubit.cities,
                locationCubit.selectedCity,
                state,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCountryDropdown(
      BuildContext context,
      List<CountryResponse> countries,
      CountryResponse? selectedCountry,
      LocationStates state,
      ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: bgColorOverlay,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: state.maybeWhen(
        loading: () => const SizedBox(
          height: 48,
          child: Center(
            child: CupertinoActivityIndicator(color: Colors.white),
          ),
        ),
        error: (message) => Center(
          child: NormalText(
            text: message,
            color: Colors.red,
            fontSize: 12,
          ),
        ),
        orElse: () => DropdownButton<CountryResponse>(
          dropdownColor: bgColorOverlay,
          hint: NormalText(
            text: "select_country".tr(),
            color: Colors.white,
            fontSize: 12,
          ),
          isExpanded: true,
          underline: const SizedBox(),
          value: selectedCountry,
          items: [
            DropdownMenuItem<CountryResponse>(
              value: null,
              child: NormalText(
                text: "select_country".tr(),
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            ...countries.map((country) {
              return DropdownMenuItem<CountryResponse>(
                value: country,
                child: NormalText(
                  text: country.countryName,
                  color: Colors.white,
                  fontSize: 12,
                ),
              );
            }),
          ],
          onChanged: (CountryResponse? value) {
            if (value != null) {
              onCountryChange(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildCityDropdown(
      BuildContext context,
      List<CityResponse> cities,
      CityResponse? selectedCity,
      LocationStates state,
      ) {
    final locationCubit = context.read<LocationCubit>();

    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: locationCubit.selectedCountry == null
            ? bgColorOverlay.withAlpha(4)
            : bgColorOverlay,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: state.maybeWhen(
        loading: () => const Center(
          child: CupertinoActivityIndicator(color: Colors.white),
        ),
        error: (message) => Center(
          child: NormalText(
            text: message,
            color: Colors.red,
            fontSize: 12,
          ),
        ),
        orElse: () => DropdownButton<CityResponse>(
          dropdownColor: bgColorOverlay,
          hint: NormalText(
            text: "select_city".tr(),
            color: Colors.white,
            fontSize: 12,
          ),
          isExpanded: true,
          underline: const SizedBox(),
          value: selectedCity,
          items: [
            DropdownMenuItem<CityResponse>(
              value: null,
              child: NormalText(
                text: "select_city".tr(),
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            ...cities.map((city) {
              return DropdownMenuItem<CityResponse>(
                value: city,
                child: NormalText(
                  text: city.cityName,
                  color: Colors.white,
                  fontSize: 12,
                ),
              );
            }),
          ],
          onChanged: locationCubit.selectedCountry == null
              ? null
              : (CityResponse? value) {
            if (value != null) {
              onCityChange(value);
            }
          },
        ),
      ),
    );
  }
}
