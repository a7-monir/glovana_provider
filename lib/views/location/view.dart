import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glovana_provider/core/app_theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/design/app_button.dart';
import '../../core/logic/helper_methods.dart';
import '../../generated/locale_keys.g.dart';

class LocationView extends StatefulWidget {
  final LatLng? initialLocation;
  final bool withButton;

  const LocationView({
    super.key,
    this.initialLocation,
    this.withButton = false,
  });

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  late GoogleMapController googleMapController;
  final _controller = Completer<GoogleMapController>();

  LatLng currentCenter = const LatLng(31.963158, 35.930359);
  String? currentAddressText;
  double zoom = 14;

  @override
  void initState() {
    super.initState();

    // لو فيه موقع مبدأي
    if (widget.initialLocation != null) {
      currentCenter = widget.initialLocation!;
    }

    // متابعة حالة خدمة الـ GPS
    Geolocator.getServiceStatusStream().listen((event) {
      if (event == ServiceStatus.enabled) {
        goToMyLocation();
      }
    });
  }

  Future<void> goToMyLocation() async {
    googleMapController = await _controller.future;
    final pos = await getCurrentLocation();
    final location = pos.latLang ?? currentCenter;
    googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(location, zoom),
    );
    await updateAddress(location);
    setState(() {
      currentCenter = location;
    });
  }

  Future<void> updateAddress(LatLng location) async {
    try {
      final placeMarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placeMarks.isNotEmpty) {
        final place = placeMarks.first;
        setState(() {
          currentAddressText =
          "${place.locality ?? ''}${place.locality?.isNotEmpty == true ? " - " : ""}${place.subAdministrativeArea ?? ''}";
        });
      }
    } catch (e) {
      debugPrint("Error in get address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: currentCenter,
              zoom: zoom,
            ),
            onCameraMove: (position) {
              currentCenter = position.target;
            },
            onCameraIdle: () {
              updateAddress(currentCenter);
            },
            onMapCreated: (controller) {
              _controller.complete(controller);
              googleMapController = controller;
            },
          ),

          IgnorePointer(
            child: Icon(
              Icons.location_on,
              size: 50,
              color: AppTheme.primary,
            ),
          ),

          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4)
                ],
              ),
              child: Text(
                currentAddressText ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),


          Positioned(
            bottom: 110,
            right: 16,
            child: FloatingActionButton(
              heroTag: "goToMyLocation",
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
              onPressed: goToMyLocation,
              child: Icon(
                Icons.my_location,
                color: AppTheme.primary,
              ),
            ),
          ),

          if (widget.withButton)
            Positioned(
              bottom: 30,
              left: 24.w,
              right: 24.w,
              child: AppButton(
                onPress: currentCenter == null
                    ? null
                    : () {
                  Navigator.pop(
                    context,
                    MyAddressModel(
                      location: currentCenter,
                      description: currentAddressText ?? '',
                    ),
                  );
                },
                text: LocaleKeys.confirm.tr(),
              ),
            ),
        ],
      ),
    );
  }
}

class MyAddressModel {
  final LatLng location;
  final String? description;

  MyAddressModel({required this.location, this.description});
}