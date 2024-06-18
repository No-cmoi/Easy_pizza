import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
  class Discount {

    final String id;
    final String rule;
    final DateTime start;
    final DateTime end;
    final String code;

  Discount({
    required this.id, 
    required this.rule, 
    required this.start, 
    required this.end, 
    required this.code});
  
  
  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      id :json["id"],
      rule: json["rule"],
      start: DateTime.parse(json["start"]),
      end: DateTime.parse(json["end"]),
      code: json["code"],
    );
  }
}