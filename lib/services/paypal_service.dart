// import 'package:flutter/material.dart';
// import '../models/cart_items_model.dart';
// import 'dart:convert';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:html' if (dart.library.io) 'dart:io' show window;
// import 'dart:js' as js;
// import 'dart:ui' as ui;
// import 'dart:html' show IFrameElement;

// class PayPalService {
//   static const String clientId =
//       'ATITiABFGDshKRw6nJ04PhIn1R-rg8roBbMtsXHIFbDqN8uKjH3O_7CqjX-b_6MvWHq1c8dxe1cTGhlE';
//   static const bool sandbox = true;

//   static String _generateHtml(String amount, String itemsJson) {
//     return '''
// <!DOCTYPE html>
// <html>
// <head>
//     <meta name="viewport" content="width=device-width, initial-scale=1">
//     <meta http-equiv="Content-Security-Policy" content="default-src * gap:; script-src * 'unsafe-inline' 'unsafe-eval'; connect-src *; img-src * data: blob: android-webview-video-poster:; style-src * 'unsafe-inline';">
//     <title>PayPal Payment</title>
//     <style>
//         body { margin: 0; padding: 16px; font-family: Arial, sans-serif; }
//         #paypal-button-container { width: 100%; min-height: 200px; }
//     </style>
// </head>
// <body>
//     <div id="paypal-button-container"></div>
//     <script src="https://www.paypal.com/sdk/js?client-id=$clientId&currency=USD"></script>
//     <script>
//         const amount = "$amount";
//         const items = JSON.parse(decodeURIComponent("$itemsJson"));

//         paypal.Buttons({
//             createOrder: function(data, actions) {
//                 return actions.order.create({
//                     purchase_units: [{
//                         amount: {
//                             currency_code: "USD",
//                             value: amount,
//                             breakdown: {
//                                 item_total: {
//                                     currency_code: "USD",
//                                     value: amount
//                                 }
//                             }
//                         },
//                         items: items.map(item => ({
//                             name: item.name,
//                             quantity: item.quantity,
//                             unit_amount: {
//                                 currency_code: "USD",
//                                 value: item.price
//                             }
//                         }))
//                     }]
//                 });
//             },
//             onApprove: function(data, actions) {
//                 return actions.order.capture().then(function(details) {
//                     window.parent.postMessage('success', '*');
//                 });
//             },
//             onCancel: function(data) {
//                 window.parent.postMessage('cancel', '*');
//             },
//             onError: function(err) {
//                 window.parent.postMessage('error:' + err.message, '*');
//             }
//         }).render('#paypal-button-container');
//     </script>
// </body>
// </html>
// ''';
//   }

//   static void initPlatformState() {
//     if (!kIsWeb) {
//       final WebViewPlatform platform = AndroidWebViewPlatform();
//       WebViewPlatform.instance = platform;
//     }
//   }

//   static Future<void> makePayment({
//     required BuildContext context,
//     required List<CartItems> items,
//     required double total,
//     required Function onSuccess,
//     required Function onError,
//     required Function onCancel,
//   }) async {
//     try {
//       if (kIsWeb) {
//         // Web-specific implementation
//         final itemsData =
//             items
//                 .map(
//                   (item) => {
//                     'name': item.productName,
//                     'quantity': item.quantity,
//                     'price': item.productPrice.toStringAsFixed(2),
//                   },
//                 )
//                 .toList();

//         final String itemsJson = Uri.encodeComponent(jsonEncode(itemsData));
//         final String amount = total.toStringAsFixed(2);
//         final String htmlContent = _generateHtml(amount, itemsJson);

//         // Create an iframe element
//         final iframeElement = '''
//           <iframe 
//             id="paypal-iframe" 
//             style="width: 100%; height: 600px; border: none;"
//             srcdoc='${htmlContent.replaceAll("'", "\\'")}'
//           ></iframe>
//         ''';

//         // Show the iframe in a dialog
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return Dialog(
//               child: Container(
//                 height: MediaQuery.of(context).size.height * 0.8,
//                 width: MediaQuery.of(context).size.width * 0.9,
//                 child: Column(
//                   children: [
//                     AppBar(
//                       title: Text('PayPal Checkout'),
//                       leading: IconButton(
//                         icon: Icon(Icons.close),
//                         onPressed: () {
//                           Navigator.pop(context);
//                           onCancel();
//                         },
//                       ),
//                     ),
//                     Expanded(
//                       child: HtmlElementView(
//                         viewType: 'paypal-iframe',
//                         onPlatformViewCreated: (int id) {
//                           // Register message handler
//                           js.context['handlePayPalMessage'] = (dynamic event) {
//                             final String message = event.data.toString();
//                             if (message == 'success') {
//                               Navigator.pop(context);
//                               onSuccess();
//                             } else if (message == 'cancel') {
//                               Navigator.pop(context);
//                               onCancel();
//                             } else if (message.startsWith('error:')) {
//                               Navigator.pop(context);
//                               onError(message.substring(6));
//                             }
//                           };

//                           // Add message listener
//                           js.context.callMethod('addEventListener', [
//                             'message',
//                             js.allowInterop(js.context['handlePayPalMessage']),
//                           ]);
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );

//         // Register the iframe view
//         // ignore: undefined_prefixed_name
//         ui.platformViewRegistry.registerViewFactory('paypal-iframe', (
//           int viewId,
//         ) {
//           final element =
//               IFrameElement()
//                 ..srcdoc = htmlContent
//                 ..style.border = 'none'
//                 ..style.width = '100%'
//                 ..style.height = '100%';
//           return element;
//         });
//       } else {
//         // Mobile implementation (existing code)
//         initPlatformState();
//         final webViewController = WebViewController();

//         final itemsData =
//             items
//                 .map(
//                   (item) => {
//                     'name': item.productName,
//                     'quantity': item.quantity,
//                     'price': item.productPrice.toStringAsFixed(2),
//                   },
//                 )
//                 .toList();

//         final String itemsJson = Uri.encodeComponent(jsonEncode(itemsData));
//         final String amount = total.toStringAsFixed(2);
//         final String htmlContent = _generateHtml(amount, itemsJson);

//         webViewController
//           ..setJavaScriptMode(JavaScriptMode.unrestricted)
//           ..setBackgroundColor(Colors.white)
//           ..setNavigationDelegate(
//             NavigationDelegate(
//               onNavigationRequest: (NavigationRequest request) {
//                 if (request.url.startsWith('fiton://payment/')) {
//                   if (request.url.contains('success')) {
//                     Navigator.pop(context);
//                     onSuccess();
//                     return NavigationDecision.prevent;
//                   } else if (request.url.contains('cancel')) {
//                     Navigator.pop(context);
//                     onCancel();
//                     return NavigationDecision.prevent;
//                   } else if (request.url.contains('error')) {
//                     Navigator.pop(context);
//                     final uri = Uri.parse(request.url);
//                     final errorMessage = uri.queryParameters['message'];
//                     onError(errorMessage ?? 'Payment failed');
//                     return NavigationDecision.prevent;
//                   }
//                 }
//                 return NavigationDecision.navigate;
//               },
//               onPageStarted: (String url) {
//                 debugPrint('Page started loading: $url');
//               },
//               onPageFinished: (String url) {
//                 debugPrint('Page finished loading: $url');
//               },
//               onWebResourceError: (WebResourceError error) {
//                 debugPrint('Web resource error: ${error.description}');
//                 onError(error.description);
//               },
//             ),
//           )
//           ..loadHtmlString(
//             htmlContent,
//             baseUrl:
//                 sandbox
//                     ? 'https://www.sandbox.paypal.com'
//                     : 'https://www.paypal.com',
//           );

//         await showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return Dialog(
//               child: Container(
//                 height: MediaQuery.of(context).size.height * 0.8,
//                 width: MediaQuery.of(context).size.width * 0.9,
//                 child: Column(
//                   children: [
//                     AppBar(
//                       title: Text('PayPal Checkout'),
//                       leading: IconButton(
//                         icon: Icon(Icons.close),
//                         onPressed: () {
//                           Navigator.pop(context);
//                           onCancel();
//                         },
//                       ),
//                     ),
//                     Expanded(
//                       child: WebViewWidget(controller: webViewController),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }
//     } catch (e) {
//       debugPrint('Error in PayPal payment: $e');
//       onError(e.toString());
//     }
//   }
// }
