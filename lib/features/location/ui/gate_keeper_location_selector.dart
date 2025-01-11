
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
    return BlocBuilder<LocationCubit, LocationStates<List<dynamic>>>(
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
      LocationStates<List<dynamic>> state,
      ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: bgColorOverlay,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: state.when(
        initial: () => _buildDropdown(
          context: context,
          items: countries,
          selectedValue: selectedCountry,
          onChanged: (CountryResponse? value) {
            if (value != null) onCountryChange(value);
          },
          hintText: "select_country",
        ),
        loading: () => const SizedBox(
          height: 48,
          child: Center(
            child: CupertinoActivityIndicator(color: Colors.white),
          ),
        ),
        emptyInput: () => _buildDropdown(
          context: context,
          items: countries,
          selectedValue: selectedCountry,
          onChanged: (CountryResponse? value) {
            if (value != null) onCountryChange(value);
          },
          hintText: "select_country",
        ),
        success: (_) => _buildDropdown(
          context: context,
          items: countries,
          selectedValue: selectedCountry,
          onChanged: (CountryResponse? value) {
            if (value != null) onCountryChange(value);
          },
          hintText: "select_country",
        ),
        error: (message) => Center(
          child: NormalText(
            text: message,
            color: Colors.red,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCityDropdown(
      BuildContext context,
      List<CityResponse> cities,
      CityResponse? selectedCity,
      LocationStates<List<dynamic>> state,
      ) {
    final locationCubit = context.read<LocationCubit>();
    final bool isEnabled = locationCubit.selectedCountry != null;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isEnabled ? bgColorOverlay : bgColorOverlay.withAlpha(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: state.when(
        initial: () => _buildDropdown(
          context: context,
          items: cities,
          selectedValue: selectedCity,
          onChanged: isEnabled ? (CityResponse? value) {
            if (value != null) onCityChange(value);
          } : null,
          hintText: "select_city",
        ),
        loading: () => const Center(
          child: CupertinoActivityIndicator(color: Colors.white),
        ),
        emptyInput: () => _buildDropdown(
          context: context,
          items: cities,
          selectedValue: selectedCity,
          onChanged: isEnabled ? (CityResponse? value) {
            if (value != null) onCityChange(value);
          } : null,
          hintText: "select_city",
        ),
        success: (_) => _buildDropdown(
          context: context,
          items: cities,
          selectedValue: selectedCity,
          onChanged: isEnabled ? (CityResponse? value) {
            if (value != null) onCityChange(value);
          } : null,
          hintText: "select_city",
        ),
        error: (message) => Center(
          child: NormalText(
            text: message,
            color: Colors.red,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required BuildContext context,
    required List<T> items,
    required T? selectedValue,
    required Function(T?)? onChanged,
    required String hintText,
  }) {
    return DropdownButton<T>(
      dropdownColor: bgColorOverlay,
      hint: NormalText(
        text: hintText.tr(),
        color: Colors.white,
        fontSize: 12,
      ),
      isExpanded: true,
      underline: const SizedBox(),
      value: selectedValue,
      items: [
        DropdownMenuItem<T>(
          value: null,
          child: NormalText(
            text: hintText.tr(),
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        ...items.map((item) {
          final String displayText = item is CountryResponse
              ? item.countryName
              : (item as CityResponse).cityName;
          return DropdownMenuItem<T>(
            value: item,
            child: NormalText(
              text: displayText,
              color: Colors.white,
              fontSize: 12,
            ),
          );
        }),
      ],
      onChanged: onChanged,
    );
  }
}