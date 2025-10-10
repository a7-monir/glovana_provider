import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
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

  late Dio _dio;
  PageData? _pageData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // _initializeDio();
    // _fetchPageData();
    bloc.add(GetStaticPageEvent(id: widget.id));
  }

  void _initializeDio() {
    _dio = Dio();

    // Configure Dio with base options
    //_dio.options.baseUrlrl = widget.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // Add interceptors if needed (for authentication, logging, etc.)
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  Future<void> _fetchPageData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await _dio.get('user/pages/3');

      if (response.statusCode == 200) {
        final apiResponse = ApiResponse.fromJson(response.data);
        if (apiResponse.status) {
          setState(() {
            _pageData = apiResponse.data;
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = apiResponse.message;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'pages.errors.failed_to_load'.tr();
          _isLoading = false;
        });
      }
    } on DioException catch (e) {
      setState(() {
        _errorMessage = _handleDioError(e);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'pages.errors.unexpected_error'.tr();
        _isLoading = false;
      });
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'pages.errors.connection_timeout'.tr();
      case DioExceptionType.sendTimeout:
        return 'pages.errors.send_timeout'.tr();
      case DioExceptionType.receiveTimeout:
        return 'pages.errors.receive_timeout'.tr();
      case DioExceptionType.badResponse:
        return 'pages.errors.server_error'.tr(
          namedArgs: {
            'statusCode': e.response?.statusCode.toString() ?? 'Unknown',
          },
        );
      case DioExceptionType.cancel:
        return 'pages.errors.request_cancelled'.tr();
      case DioExceptionType.connectionError:
        return 'pages.errors.no_internet'.tr();
      default:
        return 'pages.errors.network_error'.tr();
    }
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
          } else if (state is GetStaticPageSuccessState) {
            return RefreshIndicator(
              onRefresh: _fetchPageData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(state.model.title),
                    const SizedBox(height: 16),

                    // Content
                    Html(data: state.model.content),

                    const SizedBox(height: 32),

                    // Last updated info
                    Row(
                      children: [
                        Icon(Icons.update, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          LocaleKeys.lastUpdated.tr(
                            namedArgs: {
                              'date': _formatDate(state.model.updatedAt),
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

  Widget _buildBody() {
    if (_isLoading) {
      return AppLoading();
    }

    if (_errorMessage != null) {
      return AppFailed(msg: _errorMessage!, onPress: _fetchPageData);
    }

    if (_pageData == null) {
      return Center(child: Text('no data'));
    }

    return RefreshIndicator(
      onRefresh: _fetchPageData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              _pageData!.title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Content
            Text(
              _pageData!.content,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.6),
            ),

            const SizedBox(height: 32),

            // Last updated info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.update, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'pages.last_updated'.tr(
                      namedArgs: {'date': _formatDate(_pageData!.updatedAt)},
                    ),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
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
