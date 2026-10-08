import '../models/point_model.dart';

class PointService {
  static final List<PointModel> registros = [];

  static void adicionarRegistro(PointModel registro) {
    registros.add(registro);
  }

  static List<PointModel> listarRegistros() {
    return List.from(registros.reversed);
  }
}
