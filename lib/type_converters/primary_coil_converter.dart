import 'package:coiler_app/entities/HelicalCoil.dart';
import 'package:coiler_app/entities/Primary.dart';
import 'package:floor/floor.dart';

class PrimaryCoilConverter extends TypeConverter<Primary?, String?> {
  @override
  Primary? decode(String? databaseValue) {
    if (databaseValue == null) {
      return null;
    }

    return HelicalCoil();
  }

  @override
  String? encode(Primary? value) {
    // TODO: implement encode
    throw UnimplementedError();
  }

  /*@override
  PrimaryCoil decode(String databaseValue) {
    return PrimaryCoil.fromDatabase(databaseValue);
  }

  @override
  String encode(PrimaryCoil value) {
    return value.toDatabaseString();
  }*/
}
