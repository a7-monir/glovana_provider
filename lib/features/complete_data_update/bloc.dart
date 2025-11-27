import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/logic/dio_helper.dart';
import '../../../core/logic/helper_methods.dart';
import '../../core/logic/cache_helper.dart';
import '../../core/logic/firebase_notifications.dart';
import '../../generated/locale_keys.g.dart';

part 'events.dart';


part 'states.dart';

class CompleteDataUpdateBloc extends Bloc<CompleteDataUpdateEvents, CompleteDataUpdateStates> {
  final DioHelper _dio;
  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();

  CompleteDataUpdateBloc(this._dio) : super(CompleteDataUpdateStates()) {
    on<CompleteDataUpdateEvent>(_sendData);
  }


  void _sendData(CompleteDataUpdateEvent event, Emitter<CompleteDataUpdateStates> emit) async {
    emit(CompleteDataUpdateLoadingState());

    FormData formData = FormData();

    for (int i = 0; i < event.providerTypes.length; i++) {
      final provider = event.providerTypes[i];

      // Add basic fields
      formData.fields.addAll([
        MapEntry(
            'provider_types[$i][type_id]', provider.typeId?.toString() ?? ''),
        MapEntry('provider_types[$i][name]', provider.name),
        MapEntry('provider_types[$i][description]', provider.description),
        MapEntry('provider_types[$i][lat]', provider.lat.toString()),
        MapEntry('provider_types[$i][lng]', provider.lng.toString()),
        MapEntry('provider_types[$i][address]', provider.address),
        MapEntry(
            'provider_types[$i][price_per_hour]',
            provider.pricePerHour == null
                ? '0'
                : provider.pricePerHour.toString()),
        //    MapEntry('provider_types[$i][is_vip]', '0'),
      ]);

      if (provider.serviceIds != null) {
        // Add service IDs (keep for backward compatibility)
        for (int j = 0; j < provider.serviceIds!.length; j++) {
          formData.fields.add(
            MapEntry('provider_types[$i][service_ids][$j]',
                provider.serviceIds![j].toString()),
          );
        }
      }

      // Add services with prices (new field)
      if (provider.servicesWithPrices != null) {
        for (int j = 0; j < provider.servicesWithPrices!.length; j++) {
          final serviceWithPrice = provider.servicesWithPrices![j];
          formData.fields.addAll([
            MapEntry(
                'provider_types[$i][services_with_prices][$j][service_id]',
                serviceWithPrice['service_id'].toString()),
            MapEntry('provider_types[$i][services_with_prices][$j][price]',
                serviceWithPrice['price'].toString()),
            MapEntry(
                'provider_types[$i][services_with_prices][$j][is_active]',
                serviceWithPrice['is_active'].toString()),
          ]);
        }
      }

      // Add images
      if (provider.images != null) {
        formData.files.add(
          MapEntry(
            'provider_types[$i][images][0]',
            await MultipartFile.fromFile(provider.images!.path),
          ),
        );
      }
      if (provider.identityPhoto != null) {
        formData.files.add(
          MapEntry(
            'provider_types[$i][identity_photo]',
            await MultipartFile.fromFile(provider.identityPhoto!.path),
          ),
        );
      }

      // Add gallery images
      for (int j = 0; j < provider.gallery.length; j++) {
        formData.files.add(
          MapEntry(
            'provider_types[$i][galleries][$j]',
            await MultipartFile.fromFile(provider.gallery[j].path),
          ),
        );
      }

      // ADD NEW DOCUMENT FIELDS
      // Add identity photo
      if (provider.identityPhoto != null) {
        formData.files.add(
          MapEntry(
            'provider_types[$i][identity_photo]',
            await MultipartFile.fromFile(provider.identityPhoto!.path),
          ),
        );
      }

      // Add practice license
      if (provider.practicePhoto != null) {
        formData.files.add(
          MapEntry(
            'provider_types[$i][practice_license]',
            await MultipartFile.fromFile(provider.practicePhoto!.path),
          ),
        );
      }

      // Add availability
      for (int j = 0; j < provider.availability.length; j++) {
        final avail = provider.availability[j];
        formData.fields.addAll([
          MapEntry('provider_types[$i][availabilities][$j][day_of_week]',
              avail!.dayOfWeek ?? ""),
          MapEntry('provider_types[$i][availabilities][$j][start_time]',
              avail.startTime ?? ""),
          MapEntry('provider_types[$i][availabilities][$j][end_time]',
              avail.endTime ?? ""),
        ]);
      }
    }
    final response = await _dio.postData(
      url: "provider/types/${event.providerId}",
      withFiles: true,
      data:formData,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {

      emit(CompleteDataUpdateSuccessState(msg: response.data['message']));
    } else {
      emit(CompleteDataUpdateFailedState(msg:  response.data['message'] , statusCode: response.statusCode));
    }
  }
}
