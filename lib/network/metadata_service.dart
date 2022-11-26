import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:nautilus_wallet_flutter/network/model/base_request.dart';
import 'package:nautilus_wallet_flutter/network/model/payment/payment_ack.dart';
import 'package:nautilus_wallet_flutter/network/model/payment/payment_memo.dart';
import 'package:nautilus_wallet_flutter/network/model/payment/payment_message.dart';
import 'package:nautilus_wallet_flutter/network/model/payment/payment_request.dart';
import 'package:nautilus_wallet_flutter/network/model/response/error_response.dart';
import 'package:nautilus_wallet_flutter/service_locator.dart';

// MetadataService singleton
class MetadataService {
  // Constructor
  MetadataService() {}

  // meta:
  static String META_SERVER = "https://meta.perish.co";

  static String BASE_SERVER_ADDRESS = "nautilus.perish.co";
  static String HTTP_PROTO = "https://";
  static String WS_PROTO = "wss://";

  // ignore_for_file: non_constant_identifier_names
  static String SERVER_ADDRESS_HTTP = "$HTTP_PROTO$META_SERVER/api";
  static String SERVER_ADDRESS_ALERTS = "$META_SERVER/alerts";
  static String SERVER_ADDRESS_FUNDING = "$META_SERVER/funding";

  final Logger log = sl.get<Logger>();

  Future<void> initCommunication() async {}

  // HTTP API

  Future<dynamic> makeHttpRequest(BaseRequest request) async {
    final http.Response response = await http.post(Uri.parse(SERVER_ADDRESS_HTTP),
        headers: {'Content-type': 'application/json'}, body: json.encode(request.toJson()));

    if (response.statusCode != 200) {
      return null;
    }
    final Map decoded = json.decode(response.body) as Map<dynamic, dynamic>;
    if (decoded.containsKey("error")) {
      return ErrorResponse.fromJson(decoded as Map<String, dynamic>);
    }

    return decoded;
  }

  // request money from an account:
  Future<void> requestPayment(String? account, String? amountRaw, String? requestingAccount, String requestSignature,
      String requestNonce, String? memoEnc, String localUuid) async {
    final PaymentRequest request = PaymentRequest(
        account: account,
        amount_raw: amountRaw,
        requesting_account: requestingAccount,
        request_signature: requestSignature,
        request_nonce: requestNonce,
        memo_enc: memoEnc,
        local_uuid: localUuid);

    // queueRequest(request);
    final dynamic response = await makeHttpRequest(request);
    if (response is ErrorResponse) {
      throw Exception("Received error ${response.error}");
    }
  }

  // send payment record (memo) to an account:
  Future<void> sendTXMemo(String account, String requestingAccount, String? amountRaw, String requestSignature,
      String requestNonce, String memoEnc, String? block, String localUuid) async {
    final PaymentMemo request = PaymentMemo(
        account: account,
        requesting_account: requestingAccount,
        request_signature: requestSignature,
        request_nonce: requestNonce,
        memo_enc: memoEnc,
        block: block,
        local_uuid: localUuid);
    final dynamic response = await makeHttpRequest(request);
    if (response is ErrorResponse) {
      throw Exception("Received error ${response.error} ${response.details}");
    }
  }

  Future<void> sendTXMessage(String account, String requestingAccount, String requestSignature, String requestNonce,
      String memoEnc, String localUuid) async {
    final PaymentMessage request = PaymentMessage(
        account: account,
        requesting_account: requestingAccount,
        request_signature: requestSignature,
        request_nonce: requestNonce,
        memo_enc: memoEnc,
        local_uuid: localUuid);
    final dynamic response = await makeHttpRequest(request);
    if (response is ErrorResponse) {
      throw Exception("Received error ${response.error} ${response.details}");
    }
  }

  Future<void> requestACK(String? requestUuid, String? account, String? requestingAccount) async {
    final PaymentACK request = PaymentACK(uuid: requestUuid, account: account, requesting_account: requestingAccount);
    final dynamic response = await makeHttpRequest(request);
    if (response is ErrorResponse) {
      throw Exception("Received error ${response.error} ${response.details}");
    }
  }
}
