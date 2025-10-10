import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/constants.dart';
import 'package:glovana_provider/core/design/custom_text_field.dart';

class SearchChatWidget extends StatefulWidget {
  final Function(String) onSearchChanged;

  const SearchChatWidget({super.key, required this.onSearchChanged});

  @override
  State<SearchChatWidget> createState() => _SearchChatWidgetState();
}

class _SearchChatWidgetState extends State<SearchChatWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTextField(
          controller: _searchController,
          width: Constants.getwidth(context) * 0.9,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          borderRadius: 8.r,
          hintText: "search_of_what_you_want".tr(),
          onChanged: (value) {
            widget.onSearchChanged(value);
          },
        ),
      ],
    );
  }
}
