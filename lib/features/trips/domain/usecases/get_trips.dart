import 'package:dartz/dartz.dart';
import 'package:final_project_demo/core/error/failures.dart';

import '../entitites/trip.dart';
import '../repositories/trip_repository.dart';

class GetTrips {
  final TripRepository repository;

  GetTrips(this.repository);

  Future<Either<Failure, List<Trip>>> call() {
    return repository.getTrips();
  }
}