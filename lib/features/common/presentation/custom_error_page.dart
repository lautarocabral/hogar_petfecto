import 'package:flutter/material.dart';
import 'package:hogar_petfecto/core/app_dimens.dart';
import 'package:hogar_petfecto/core/widgets/custom_app_bar_widget.dart';
import 'package:hogar_petfecto/core/widgets/custom_button_widget.dart';

class CustomErrorPage extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const CustomErrorPage({super.key, required this.errorMessage, this.onRetry});

  static const String route = '/custom_error_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Error'),
      body: Padding(
        padding: const EdgeInsets.all(Margins.largeMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 100,
            ),
            const SizedBox(height: Margins.largeMargin),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Margins.largeMargin),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: 'Reintentar',
                  onPressed: () {
                    if (onRetry != null) {
                      onRetry!();
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
