import 'package:coiler_app/entities/ToroidTopload.dart';
import 'package:floor/floor.dart';

class ToroidToploadConverter extends TypeConverter<ToroidTopload?, String?> {
  @override
  ToroidTopload? decode(String? databaseValue) {
    return ToroidTopload.fromDatabase(databaseValue);
  }

  @override
  String? encode(ToroidTopload? value) {
    return ToroidTopload.toDatabaseString(value);
  }
}
