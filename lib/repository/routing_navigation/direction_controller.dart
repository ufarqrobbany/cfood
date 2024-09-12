

import 'package:cfood/repository/routing_navigation/direction_layer.dart';

class DirectionController {
  late DirectionsLayerState _state;

  set state(DirectionsLayerState state) {
    _state = state;
  }

  void updateDirection(List<DirectionCoordinate> coordinates) {
    _state.updateCoordinates(coordinates);
  }
}

class DirectionCoordinate {
  final double latitude;
  final double longitude;
  
  DirectionCoordinate(this.latitude, this.longitude);
}