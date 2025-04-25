import 'dart:convert';

class ShopDetailsModel {
  final String name;
  final String mobileNumber;
  final String address;
  final String? email;
  final String? gstNumber;
  final String? logoUrl;
  final String? slogan;

  ShopDetailsModel({
    required this.name,
    required this.mobileNumber,
    required this.address,
    this.email,
    this.gstNumber,
    this.logoUrl,
    this.slogan,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobileNumber': mobileNumber,
      'address': address,
      'email': email,
      'gstNumber': gstNumber,
      'logoUrl': logoUrl,
      'slogan': slogan,
    };
  }

  factory ShopDetailsModel.fromJson(Map<String, dynamic> json) {
    return ShopDetailsModel(
      name: json['name'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      address: json['address'] ?? '',
      email: json['email'],
      gstNumber: json['gstNumber'],
      logoUrl: json['logoUrl'],
      slogan: json['slogan'],
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory ShopDetailsModel.fromJsonString(String jsonString) {
    return ShopDetailsModel.fromJson(jsonDecode(jsonString));
  }

  ShopDetailsModel copyWith({
    String? name,
    String? mobileNumber,
    String? address,
    String? email,
    String? gstNumber,
    String? logoUrl,
    String? slogan,
  }) {
    return ShopDetailsModel(
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      address: address ?? this.address,
      email: email ?? this.email,
      gstNumber: gstNumber ?? this.gstNumber,
      logoUrl: logoUrl ?? this.logoUrl,
      slogan: slogan ?? this.slogan,
    );
  }
}
