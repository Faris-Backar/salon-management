// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmployeeImpl _$$EmployeeImplFromJson(Map<String, dynamic> json) =>
    _$EmployeeImpl(
      uid: json['uid'] as String,
      fullname: json['fullname'] as String,
      mobile: json['mobile'] as String,
      contactAddress: json['contactAddress'] as String,
      permenentAddress: json['permenentAddress'] as String,
      specialisation: json['specialisation'] as String,
    );

Map<String, dynamic> _$$EmployeeImplToJson(_$EmployeeImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'fullname': instance.fullname,
      'mobile': instance.mobile,
      'contactAddress': instance.contactAddress,
      'permenentAddress': instance.permenentAddress,
      'specialisation': instance.specialisation,
    };
