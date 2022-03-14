import 'package:coiler_app/entities/SecondaryCoil.dart';
import 'package:floor/floor.dart';

class SecondaryCoilConverter extends TypeConverter<SecondaryCoil, String> {
  @override
  SecondaryCoil decode(String databaseValue) {
    return SecondaryCoil.fromDatabase(databaseValue);
  }

  @override
  String encode(SecondaryCoil value) {
    return value.toDatabaseString();
  }
}
