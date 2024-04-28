import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:http/http.dart';
import 'package:passenger/src/data/model/address.dart';
import 'package:passenger/src/data/model/driver.dart';
import 'package:passenger/src/data/model/ride.dart';
import 'package:passenger/src/utils/enums.dart';
import 'package:passenger/src/utils/text_styles.dart';

import 'constants.dart';

SnackBar getErrorSnackBar(BuildContext context, String message) {
  return SnackBar(
    content: Text(message, style: TextStyles.body(context: context, color: Colors.red)),
    backgroundColor: Colors.red.shade100,
    duration: Duration(milliseconds: 1500),
  );
}

String parseAddressType(AddressType addressType) {
  switch (addressType) {
    case AddressType.Home:
      return "Home";
    case AddressType.Work:
      return "Work";
    case AddressType.Other:
      return "Other";
  }
}

class Helper {
  static String get greetings {
    final DateTime dateTime = DateTime.now();
    if (dateTime.hour <= 12) {
      return "Good morning";
    } else if (dateTime.hour > 12 && dateTime.hour <= 15) {
      return "Good noon";
    } else if (dateTime.hour > 15 && dateTime.hour <= 17) {
      return "Good afternoon";
    } else {
      return "Good evening";
    }
  }

  static int totalRides(List<Ride> items) {
    return items
        .where((ride) => !(ride.isCanceled ?? false) && (ride.rejectionReason ?? "").isEmpty && ride.endAt != null)
        .length;
  }

  static double totalRatings(List<Ride> items) {
    final List<Ride> ratings = items.where((ride) => ride.rating != null).toList();
    return items.isEmpty ? 0 : ratings.fold<int>(0, (prev, ride) => prev + (ride.rating ?? 0)) / ratings.length;
  }

  void publishRideRequestNotification(Ride ride, Driver driver) async {
    final Map<String, String> notification = {
      "title": "New ride request",
      "body": "'${ride.pickup.label}' to '${ride.destination.label}'",
    };
    final Map<String, String> data = {
      "category": "ride-request",
      "reference": ride.reference,
    };
    _publishNotification(driver.token, notification, data);
  }

  void publishRideCancellationNotification(Ride ride, Driver driver) async {
    final Map<String, String> notification = {
      "title": "Ride cancelled",
      "body": "Passenger has called the ride request.",
    };
    final Map<String, String> data = {
      "category": "ride-cancelled",
      "reference": ride.reference,
    };
    _publishNotification(driver.token, notification, data);
  }

  void publishDriverReservationConfirmationRequestNotification(
      String reservationReference, String driverToken, String route) async {
    final Map<String, String> notification = {
      "title": "Reservation confirmation request",
      "body": "Awaiting for your confirmation of \"$route\" reservation",
    };
    final Map<String, String> data = {
      "category": "reservation-awaiting-driver-confirmation",
      "reference": reservationReference,
    };
    _publishNotification(driverToken, notification, data);
  }

  void _publishNotification(String token, Map<String, String> notification, Map<String, String> data) async {
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization":
          "key=AAAAJa5utSY:APA91bHpr0P84-3xnfo6qpZq250fholOPSd-vx8M-RuVexsku982cSoDsXqdb3mXBUSnfnYi33qMf8A5InyY0Ycjm8kpzGpAzMqcydftNQhuxLmMZTVVI5r3jyqwnH5HOWsjaCnxH80d",
    };
    final Map<String, dynamic> body = {
      "to": token,
      "notification": notification,
      "data": data,
    };
    final Response response =
        await post(Uri.parse("https://fcm.googleapis.com/fcm/send"), headers: headers, body: json.encode(body));
    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  static Future<Address?> findAddress(double lat, double lng) async {
    final GoogleGeocoding geoCoder = GoogleGeocoding(MAP_API_WEB_KEY);
    final response = await geoCoder.geocoding.getReverse(LatLon(lat, lng));
    if (response?.results?.isNotEmpty ?? false) {
      return Address(label: response?.results?.first.formattedAddress ?? "", latitude: lat, longitude: lng);
    } else {
      return null;
    }
  }
}
