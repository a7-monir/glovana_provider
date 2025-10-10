import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../app_theme.dart';

enum FailedImageType { normal, male, female,person }

class AppImage extends StatefulWidget {
  final FailedImageType failedImageType;
  final bool isClickable,withBaseImageUrl;
  final String url;
  final double? height, width;
  final Color? color;
  final BoxFit fit;

  const AppImage(
    this.url, {
    super.key,
    this.height,
    this.isClickable = false,
    this.width,
    this.color,
    this.fit = BoxFit.scaleDown,
    this.failedImageType = FailedImageType.normal,  this.withBaseImageUrl=false,
  });

  @override
  State<AppImage> createState() => _AppImageState();
}

class _AppImageState extends State<AppImage> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(widget.withBaseImageUrl){
      return Image.network(
        "${AppTheme.imageUrl}${widget.url}",
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        errorBuilder: (context, error, stackTrace) => errWidget,
      );
    }else{
      if ((widget.url.startsWith('https')||widget.url.startsWith('http')||widget.url.startsWith("Https")) && !widget.url.endsWith("svg")) {
        return Image.network(
          widget.url,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          errorBuilder: (context, error, stackTrace) => errWidget,
        );
      }  else if (widget.url.endsWith("json")) {
        return Lottie.asset(
          "assets/lottie/${widget.url}",
          height: widget.height,
          width: widget.width,
          fit: widget.fit,
        );
      }else if (widget.url.endsWith("svg")) {
        if (widget.url.startsWith('https')||widget.url.startsWith("Https")) {
          return SvgPicture.network(
            widget.url,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
          );
        }
        return SvgPicture.asset(
          "assets/svg/${widget.url}",
          height: widget.height,
          width: widget.width,
          colorFilter: widget.color!=null?ColorFilter.mode(widget.color!, BlendMode.srcATop):null,
          // color: color,
          fit: widget.fit,
        );
      } else if (widget.url.startsWith("/") && widget.url.length > 300) {
        return AbsorbPointer(
          absorbing: !widget.isClickable,
          child: GestureDetector(
            onTap: () {
              showImage(context);
            },
            child: Image.memory(
              base64Decode(widget.url),
              height: widget.height,
              width: widget.width,
              color: widget.color,
              fit: widget.fit,
            ),
          ),
        );
      } else if (widget.url.contains("com.")&&widget.url.contains("cache")) {
        return Image.file(
          File(widget.url),
          color: widget.color,
          errorBuilder: (context, error, stackTrace) => errWidget,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );
      } else {
        if (widget.url.isEmpty) {
          return errWidget;
        }
        return Image.asset(
          "assets/images/${widget.url}",
          color: widget.color,
          errorBuilder: (context, error, stackTrace) => errWidget,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );
      }
    }

  }

  void showImage(context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        titlePadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        contentPadding: EdgeInsets.zero,
        children: [
          Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Image.memory(
                base64Decode(widget.url),
              ),
              PositionedDirectional(
                top: 16.h,
                end: 16.w,
                child: const CloseButton(),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget get errWidget => Image.asset(
        "assets/images/$_errorImage",
        height: widget.height ?? 20,
        width: widget.width ?? 20,
        fit: BoxFit.scaleDown,
      );

  String get _errorImage {
    switch (widget.failedImageType) {
      case FailedImageType.male:
        return "male_failed.png";
      case FailedImageType.female:
        return "female_failed.png";
      default:
        return "normal_failed.png";
    }
  }
}
