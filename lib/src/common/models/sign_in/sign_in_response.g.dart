// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInResponse _$SignInResponseFromJson(Map<String, dynamic> json) =>
    SignInResponse(
      email: json['email'] as String?,
      photoURL: json['photo_u_r_l'] as String?,
      uid: json['uid'] as String?,
      displayName: json['display_name'] as String?,
    );

Map<String, dynamic> _$SignInResponseToJson(SignInResponse instance) =>
    <String, dynamic>{
      'email': instance.email,
      'photo_u_r_l': instance.photoURL,
      'uid': instance.uid,
      'display_name': instance.displayName,
    };
