import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoaderDialog {
  static Future<void> showLoader(
      BuildContext context,
      GlobalKey key, {
        String? message,
      }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitThreeBounce(
                color: Colors.cyan[900],
                size: 50.0,
              ),
              if (message != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.cyan[900],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}