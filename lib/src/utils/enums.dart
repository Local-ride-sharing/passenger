enum ReservationStatus {
  pending,
  awaitingDriverConfirmation,
  driverConfirmed,
  active,
  completed,
  canceled,
}
enum RideStatus {
  accepted,
  rejected,
}
enum RideCurrentStatus { searching, accepted, meetingAtPickup, arrived, started, finished }
enum Gender { male, female, other }
enum RideType { instantRide, pointToPoint }

enum AddressType { Home, Work, Other }
enum RidePriority { female, femalePriority, male }
