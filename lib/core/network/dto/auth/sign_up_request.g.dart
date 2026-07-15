// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SignUpRequest _$SignUpRequestFromJson(Map<String, dynamic> json) =>
    _SignUpRequest(
      provider: json['provider'] as String,
      accessToken: json['accessToken'] as String,
      termsAgreed: json['termsAgreed'] as bool,
    );

Map<String, dynamic> _$SignUpRequestToJson(_SignUpRequest instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'accessToken': instance.accessToken,
      'termsAgreed': instance.termsAgreed,
    };
