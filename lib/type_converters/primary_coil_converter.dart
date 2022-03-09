import 'package:coiler_app/entities/PrimaryCoil.dart';
import 'package:floor/floor.dart';

class PrimaryCoilConverter extends TypeConverter<PrimaryCoil, String> {
  @override
  PrimaryCoil decode(String databaseValue) {
    return PrimaryCoil.fromDatabase(databaseValue);
  }

  @override
  String encode(PrimaryCoil value) {
    return value.toDatabaseString();
  }
}
