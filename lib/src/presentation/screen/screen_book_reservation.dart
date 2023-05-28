import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tmoto_passenger/src/business_logic/dashboard/reservation_vehicle_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/reservation/create_reservation_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/ride/direction_cubit.dart';
import 'package:tmoto_passenger/src/business_logic/theme_cubit.dart';
import 'package:tmoto_passenger/src/data/model/address.dart';
import 'package:tmoto_passenger/src/data/model/direction.dart';
import 'package:tmoto_passenger/src/data/model/passenger.dart';
import 'package:tmoto_passenger/src/data/model/reservation.dart';
import 'package:tmoto_passenger/src/data/model/vehicle.dart';
import 'package:tmoto_passenger/src/data/provider/provider_profile.dart';
import 'package:tmoto_passenger/src/presentation/widget/instant_ride/widget_address_text_field_for_address_picker.dart';
import 'package:tmoto_passenger/src/presentation/widget/widget_vehicle_dropdown.dart';
import 'package:tmoto_passenger/src/utils/app_router.dart';
import 'package:tmoto_passenger/src/utils/enums.dart';
import 'package:tmoto_passenger/src/utils/networking_indicator.dart';
import 'package:tmoto_passenger/src/utils/text_styles.dart';
import 'package:tmoto_passenger/src/utils/theme_helper.dart';

class BookReservationScreen extends StatefulWidget {
  final bool? isAmbulance;

  const BookReservationScreen({Key? key, required this.isAmbulance}) : super(key: key);

  @override
  _ReservationBookingScreenState createState() => _ReservationBookingScreenState();
}

class _ReservationBookingScreenState extends State<BookReservationScreen> {
  Address? pickup;
  Address? destination;
  late DateTime deadlineDate;
  late TimeOfDay deadlineTime;
  late DateTime startDate;
  late TimeOfDay startTime;
  late DateTime endDate;
  late TimeOfDay endTime;
  late Passenger passenger;

  bool isRoundTrip = false;

  final DateFormat dateFormat = DateFormat("d MMM, yyyy");

  Vehicle? vehicle;

  @override
  void initState() {
    startDate = DateTime.now().add(Duration(days: (widget.isAmbulance ?? false) ? 0 : 7));
    startTime = TimeOfDay.now();
    endDate = startDate.add(Duration(days: 3));
    endTime = TimeOfDay.now();

    deadlineDate = startDate.subtract(Duration(days: 1));
    deadlineTime = TimeOfDay.now();

    BlocProvider.of<ReservationVehicleCubit>(context).monitorVehicles();

    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    passenger = profileProvider.profile!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, state) {
      final theme = ThemeHelper(state.value);
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Quick reservation",
              style: TextStyles.title(context: context, color: theme.textColor)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Vehicle", style: TextStyles.caption(context: context, color: theme.hintColor)),
              const SizedBox(height: 4),
              BlocConsumer<ReservationVehicleCubit, ReservationVehicleState>(
                listener: (_, state) {
                  if (state is ReservationVehicleSuccess && (widget.isAmbulance ?? false)) {
                    setState(() {
                      vehicle = state.data.firstWhere(
                          (element) => element.enName.toLowerCase().contains("ambulance"));
                    });
                  }
                },
                builder: (_, state) {
                  if (state is ReservationVehicleError) {
                    return Icon(Icons.error);
                  } else if (state is ReservationVehicleNetworking) {
                    return CircularProgressIndicator();
                  } else if (state is ReservationVehicleSuccess) {
                    return VehicleDropdown(
                      value: vehicle,
                      items: state.data,
                      shouldValidate: true,
                      validationFlag: vehicle != null,
                      onSelect: (selection) {
                        setState(() {
                          vehicle = selection;
                        });
                      },
                    );
                  } else {
                    return Icon(Icons.help);
                  }
                },
              ),
              const SizedBox(height: 16),
              Text("Pickup", style: TextStyles.caption(context: context, color: theme.hintColor)),
              const SizedBox(height: 4),
              AddressTextFieldForAddressPicker(
                icon: Icons.hail_rounded,
                address: pickup,
                hint: "from",
                onFinish: (address) {
                  setState(() {
                    pickup = address;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text("Destination",
                  style: TextStyles.caption(context: context, color: theme.hintColor)),
              const SizedBox(height: 4),
              AddressTextFieldForAddressPicker(
                icon: Icons.tour_rounded,
                address: destination,
                hint: "to",
                onFinish: (address) {
                  setState(() {
                    destination = address;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Departure",
                      style: TextStyles.body(context: context, color: theme.textColor)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          final TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: startTime,
                            initialEntryMode: TimePickerEntryMode.input,
                          );

                          if (time != null) {
                            setState(() {
                              startTime = time;
                            });
                          }
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            color: theme.secondaryColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(startTime.format(context),
                              style: TextStyles.body(context: context, color: theme.textColor)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () async {
                          final DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: startDate,
                            firstDate: DateTime.now()
                                .add(Duration(days: (widget.isAmbulance ?? false) ? 0 : 3)),
                            lastDate: DateTime.now().add(Duration(days: 60)),
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                          );

                          if (date != null) {
                            setState(() {
                              startDate = date;
                              if (startDate.isAfter(endDate)) {
                                setState(() {
                                  endDate = startDate.add(Duration(days: 3));
                                  endTime = startTime;
                                });
                              }
                              if (startDate.isBefore(deadlineDate)) {
                                setState(() {
                                  deadlineDate = startDate.subtract(Duration(days: 1));
                                  endTime = startTime;
                                });
                              }
                            });
                          }
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            color: theme.secondaryColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(dateFormat.format(startDate),
                              style: TextStyles.body(context: context, color: theme.textColor)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Visibility(visible: isRoundTrip, child: const SizedBox(height: 16)),
              Visibility(
                visible: isRoundTrip,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Return",
                        style: TextStyles.body(context: context, color: theme.textColor)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () async {
                            final TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: endTime,
                              initialEntryMode: TimePickerEntryMode.input,
                            );

                            if (time != null) {
                              setState(() {
                                endTime = time;
                              });
                            }
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              color: theme.secondaryColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(endTime.format(context),
                                style: TextStyles.body(context: context, color: theme.textColor)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () async {
                            final DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: endDate,
                              firstDate: startDate,
                              lastDate: DateTime.now().add(Duration(days: 60)),
                              initialEntryMode: DatePickerEntryMode.calendarOnly,
                            );

                            if (date != null) {
                              setState(() {
                                endDate = date;
                              });
                            }
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              color: theme.secondaryColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(dateFormat.format(endDate),
                                style: TextStyles.body(context: context, color: theme.textColor)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                dense: true,
                horizontalTitleGap: 0,
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                leading: Icon(
                    isRoundTrip ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                    color: theme.textColor),
                title: Text("Round trip ${!isRoundTrip ? "?" : ""}",
                    style: TextStyles.body(context: context, color: theme.textColor)),
                onTap: () {
                  setState(() {
                    isRoundTrip = !isRoundTrip;
                  });
                },
              ),
              const SizedBox(height: 8),
              Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Bidding deadline",
                      style: TextStyles.body(context: context, color: theme.textColor)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          final TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: deadlineTime,
                            initialEntryMode: TimePickerEntryMode.input,
                          );

                          if (time != null) {
                            setState(() {
                              deadlineTime = time;
                            });
                          }
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            color: theme.secondaryColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(deadlineTime.format(context),
                              style: TextStyles.body(context: context, color: theme.textColor)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () async {
                          final DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: deadlineDate,
                            firstDate: DateTime.now(),
                            lastDate: startDate,
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                          );

                          if (date != null) {
                            setState(() {
                              deadlineDate = date;
                              if (deadlineDate.isAfter(startDate)) {
                                startDate = deadlineDate.add(Duration(days: 1));
                              }
                            });
                          }
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            color: theme.secondaryColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(dateFormat.format(deadlineDate),
                              style: TextStyles.body(context: context, color: theme.textColor)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                width: MediaQuery.of(context).size.width,
                child: BlocConsumer<DirectionCubit, DirectionState>(
                  listener: (_, state) {
                    if (state is DirectionSuccess) {
                      final Direction direction = state.data;
                      final DateTime departureTime = DateTime(startDate.year, startDate.month,
                          startDate.day, startTime.hour, startTime.minute);
                      final DateTime returnTime = DateTime(
                          endDate.year, endDate.month, endDate.day, endTime.hour, endTime.minute);
                      final DateTime deadline = DateTime(deadlineDate.year, deadlineDate.month,
                          deadlineDate.day, deadlineTime.hour, deadlineTime.minute);
                      final Reservation reservation = Reservation(
                        reference: "",
                        vehicleReference: vehicle?.reference ?? "",
                        pickup: pickup!,
                        destination: destination!,
                        isRoundTrip: isRoundTrip,
                        departureTime: departureTime.millisecondsSinceEpoch,
                        direction: direction,
                        returnTime: returnTime.millisecondsSinceEpoch,
                        biddingDeadline: deadline.millisecondsSinceEpoch,
                        passengerReference: passenger.reference,
                        status: ReservationStatus.pending,
                        bids: [],
                        blackListed: [],
                        commission: 0,
                      );
                      BlocProvider.of<CreateReservationCubit>(context).create(reservation);
                    }
                  },
                  builder: (_, state) {
                    if (state is DirectionError) {
                      return ElevatedButton(
                        onPressed: () {
                          if (pickup != null && destination != null) {
                            BlocProvider.of<DirectionCubit>(context).findDirection(pickup!.latitude,
                                pickup!.longitude, destination!.latitude, destination!.longitude);
                          }
                        },
                        child: Text("Try again".toUpperCase(),
                            style: TextStyles.title(context: context, color: theme.textColor)),
                      );
                    } else if (state is DirectionNetworking) {
                      return ElevatedButton(
                        onPressed: () {},
                        child: NetworkingIndicator(dimension: 20, color: Colors.blue),
                      );
                    } else if (state is DirectionSuccess) {
                      final Direction direction = state.data;
                      return BlocConsumer<CreateReservationCubit, CreateReservationState>(
                        listener: (_, state) {
                          if (state is CreateReservationSuccess) {
                            Navigator.of(context).pushNamed(AppRouter.reservationHistory);
                          }
                        },
                        builder: (_, state) {
                          if (state is CreateReservationError) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: theme.accentColor,
                              ),
                              onPressed: () {
                                if (pickup != null && destination != null) {
                                  final DateTime departureTime = DateTime(
                                      startDate.year,
                                      startDate.month,
                                      startDate.day,
                                      startTime.hour,
                                      startTime.minute);
                                  final DateTime returnTime = DateTime(endDate.year, endDate.month,
                                      endDate.day, endTime.hour, endTime.minute);
                                  final DateTime deadline = DateTime(
                                      deadlineDate.year,
                                      deadlineDate.month,
                                      deadlineDate.day,
                                      deadlineTime.hour,
                                      deadlineTime.minute);
                                  final Reservation reservation = Reservation(
                                    reference: "",
                                    vehicleReference: vehicle?.reference ?? "",
                                    pickup: pickup!,
                                    destination: destination!,
                                    isRoundTrip: isRoundTrip,
                                    departureTime: departureTime.millisecondsSinceEpoch,
                                    direction: direction,
                                    returnTime: returnTime.millisecondsSinceEpoch,
                                    biddingDeadline: deadline.millisecondsSinceEpoch,
                                    passengerReference: passenger.reference,
                                    status: ReservationStatus.pending,
                                    bids: [],
                                    blackListed: [],
                                    commission: 0,
                                  );
                                  BlocProvider.of<CreateReservationCubit>(context)
                                      .create(reservation);
                                }
                              },
                              child: Text("Try again".toUpperCase(),
                                  style:
                                      TextStyles.title(context: context, color: theme.textColor)),
                            );
                          } else if (state is CreateReservationNetworking) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: theme.accentColor,
                              ),
                              onPressed: () {},
                              child: NetworkingIndicator(dimension: 20, color: Colors.white),
                            );
                          } else if (state is CreateReservationSuccess) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: theme.accentColor,
                              ),
                              onPressed: () {},
                              child: Icon(Icons.done_outline_rounded, color: theme.accentColor),
                            );
                          } else {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: theme.accentColor,
                              ),
                              onPressed: () {
                                if (pickup != null && destination != null) {
                                  final DateTime departureTime = DateTime(
                                      startDate.year,
                                      startDate.month,
                                      startDate.day,
                                      startTime.hour,
                                      startTime.minute);
                                  final DateTime returnTime = DateTime(endDate.year, endDate.month,
                                      endDate.day, endTime.hour, endTime.minute);
                                  final DateTime deadline = DateTime(
                                      deadlineDate.year,
                                      deadlineDate.month,
                                      deadlineDate.day,
                                      deadlineTime.hour,
                                      deadlineTime.minute);
                                  final Reservation reservation = Reservation(
                                    reference: "",
                                    vehicleReference: vehicle?.reference ?? "",
                                    pickup: pickup!,
                                    destination: destination!,
                                    isRoundTrip: isRoundTrip,
                                    departureTime: departureTime.millisecondsSinceEpoch,
                                    returnTime: returnTime.millisecondsSinceEpoch,
                                    biddingDeadline: deadline.millisecondsSinceEpoch,
                                    direction: direction,
                                    passengerReference: passenger.reference,
                                    status: ReservationStatus.pending,
                                    bids: [],
                                    blackListed: [],
                                    commission: 0,
                                  );
                                  BlocProvider.of<CreateReservationCubit>(context)
                                      .create(reservation);
                                  Navigator.of(context).pushNamed(AppRouter.reservationHistory);
                                }
                              },
                              child: Text("Book now".toUpperCase(),
                                  style:
                                      TextStyles.title(context: context, color: theme.textColor)),
                            );
                          }
                        },
                      );
                    } else {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: theme.accentColor,
                        ),
                        onPressed: () {
                          if (pickup != null && destination != null) {
                            BlocProvider.of<DirectionCubit>(context).findDirection(pickup!.latitude,
                                pickup!.longitude, destination!.latitude, destination!.longitude);
                          }
                        },
                        child: Text("Book now".toUpperCase(),
                            style:
                                TextStyles.title(context: context, color: theme.backgroundColor)),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
