// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      address: json['address'] as String?,
      cityId: (json['cityId'] as num?)?.toInt(),
      createdBy: (json['createdBy'] as num?)?.toInt(),
      createdOn: json['createdOn'] as String?,
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      isActive: json['isActive'] as bool?,
      password: json['password'] as String?,
      primaryContactNo: json['primaryContactNo'] as String?,
      role: (json['role'] as num?)?.toInt(),
      userName: json['userName'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{
      'cityId': instance.cityId,
      'userId': instance.userId,
      'userName': instance.userName,
      'password': instance.password,
      'email': instance.email,
      'gender': instance.gender,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'address': instance.address,
      'primaryContactNo': instance.primaryContactNo,
      'createdOn': instance.createdOn,
      'createdBy': instance.createdBy,
      'isActive': instance.isActive,
      'role': instance.role,
    };
