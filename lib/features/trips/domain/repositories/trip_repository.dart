import 'package:dartz/dartz.dart';
import 'package:final_project_demo/core/error/failures.dart';

import '../entitites/trip.dart';

abstract class TripRepository{
  Future<Either<Failure, List<Trip>>> getTrips();
  Future<void> addTrip(Trip trip);
  Future<void> deleteTrip(int index);
}