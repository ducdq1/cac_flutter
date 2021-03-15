import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Geometry extends Equatable {
  final String type;
  final List<double> coordinates;

  Geometry({
    @required this.type,
    @required this.coordinates,
  });

  @override
  List<Object> get props => [
        type,
        coordinates,
      ];
}
