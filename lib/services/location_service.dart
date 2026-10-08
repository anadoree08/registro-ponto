import 'package:geolocator/geolocator.dart';

class LocationService {
  // COLOQUE AQUI AS COORDENADAS DO LOCAL DE TRABALHO
  static const double latitudeTrabalho = -22.000000;
  static const double longitudeTrabalho = -47.000000;

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('O GPS está desativado.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('A permissão de localização foi negada permanentemente.');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  double calcularDistancia(Position position) {
    return Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      latitudeTrabalho,
      longitudeTrabalho,
    );
  }

  bool estaDentroDoRaio(double distancia) {
    return distancia <= 100;
  }
}
