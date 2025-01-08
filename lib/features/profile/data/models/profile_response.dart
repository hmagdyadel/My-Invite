import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_response.g.dart';

@JsonSerializable()
class ProfileResponse {
  int? cityId;
  int? userId;
  String? userName;
  String? password;
  String? email;
  String? gender;
  String? firstName;
  String? lastName;
  String? address;
  String? primaryContactNo;
  String? createdOn;
  int? createdBy;
  bool? isActive;
  int? role;

  ProfileResponse(
      {this.firstName,
      this.lastName,
      this.address,
      this.cityId,
      this.createdBy,
      this.createdOn,
      this.email,
      this.gender,
      this.isActive,
      this.password,
      this.primaryContactNo,
      this.role,
      this.userName,
      this.userId});

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);
}
