import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_response.g.dart';

@JsonSerializable()
class CountryResponse {
  final int id;
  final String countryName;

  CountryResponse({required this.id, required this.countryName});

  factory CountryResponse.fromJson(Map<String, dynamic> json) =>
      _$CountryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CountryResponseToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CountryResponse &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              countryName == other.countryName;

  @override
  int get hashCode => id.hashCode ^ countryName.hashCode;
}