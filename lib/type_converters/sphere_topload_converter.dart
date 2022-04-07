import 'package:coiler_app/entities/SphereTopload.dart';
import 'package:floor/floor.dart';

class SphereToploadConverter extends TypeConverter<SphereTopload?, String?> {
  @override
  SphereTopload? decode(String? databaseValue) {
    return SphereTopload.fromDatabase(databaseValue);
  }

  @override
  String? encode(SphereTopload? value) {
    return SphereTopload.toDatabaseString(value);
  }
}
