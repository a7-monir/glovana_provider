import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/core/design/app_input.dart';
import 'package:glovana_provider/core/design/constants.dart';
import 'package:glovana_provider/core/design/custom_text_field.dart';
import 'package:glovana_provider/generated/locale_keys.g.dart';

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
    return AppInput(
      controller: _searchController,

      prefix: const Icon(Icons.search, color: Colors.grey),

      hint: LocaleKeys.searchOfWhatYouWant.tr(),
      onChanged: (value) {
        widget.onSearchChanged(value);
      },
    );
  }
}
