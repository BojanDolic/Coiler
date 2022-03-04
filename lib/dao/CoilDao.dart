import 'package:coiler_app/entities/Coil.dart';
import 'package:floor/floor.dart';

@dao
abstract class CoilDao {
  @insert
  Future<void> insertCoil(Coil coil);

  @delete
  Future<void> deleteCoil(Coil coil);

  @Query("SELECT * FROM coil")
  Stream<List<Coil>> getCoils();
}
