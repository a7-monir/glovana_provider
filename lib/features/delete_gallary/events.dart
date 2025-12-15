part of 'bloc.dart';

class DeleteGallaryEvents {}

class DeleteGallaryEvent extends DeleteGallaryEvents {
  final int galleryId;


  DeleteGallaryEvent({required this.galleryId});

}
