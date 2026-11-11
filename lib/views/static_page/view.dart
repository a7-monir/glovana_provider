import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:glovana_provider/core/design/app_empty.dart';
import 'package:glovana_provider/core/design/app_failed.dart';
import 'package:glovana_provider/core/design/app_loading.dart';
import 'package:glovana_provider/generated/locale_keys.g.dart';
import 'package:kiwi/kiwi.dart';

import '../../core/design/app_bar.dart';
import '../../features/static_page/bloc.dart';

class StaticPageView extends StatefulWidget {
  final int id;
  final String title;

  const StaticPageView({super.key, required this.id, required this.title});

  @override
  State<StaticPageView> createState() => _StaticPageViewState();
}

class _StaticPageViewState extends State<StaticPageView> {
  final bloc = KiwiContainer().resolve<GetStaticPageBloc>();

  @override
  void initState() {
    super.initState();
    bloc.add(GetStaticPageEvent(id: widget.id));
  }

  Future<void> _refresh() async {
    bloc.add(GetStaticPageEvent(id: widget.id));
    await bloc.stream.firstWhere(
      (state) =>
          state is GetStaticPageSuccessState ||
          state is GetStaticPageFailedState,
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      // Use easy_localization's date formatting
      return DateFormat('dd/MM/yyyy', context.locale.languageCode).format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: widget.title),
      body: BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          if (state is GetStaticPageLoadingState) {
            return AppLoading();
          } else if (state is GetStaticPageFailedState) {
            return AppFailed(
              response: state.response,
              onPress: () => bloc.add(GetStaticPageEvent(id: widget.id)),
            );
          } else if (state is GetStaticPageSuccessState) {
            if (state.model == null) return AppEmpty(title: widget.title);
            return RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(state.model!.title),
                    const SizedBox(height: 16),
                    // Content
                    Html(data: state.model!.content),

                    const SizedBox(height: 32),

                    // Last updated info
                    Row(
                      children: [
                        Icon(Icons.update, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          LocaleKeys.lastUpdated.tr(
                            namedArgs: {
                              'date': _formatDate(state.model!.updatedAt),
                            },
                          ),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return AppLoading();
        },
      ),
    );
  }
}

class ApiResponse {
  final bool status;
  final String message;
  final PageData data;

  ApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      message: json['message'],
      data: PageData.fromJson(json['data']),
    );
  }
}
