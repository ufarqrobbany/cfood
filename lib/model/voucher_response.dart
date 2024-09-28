class VoucherResponse {
  final int statusCode;
  final String status;
  final String message;
  final VoucherData data;

  VoucherResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
  });

  factory VoucherResponse.fromJson(Map<String, dynamic> json) {
    return VoucherResponse(
      statusCode: json['statusCode'],
      status: json['status'],
      message: json['message'],
      data: VoucherData.fromJson(json['data']),
    );
  }
}

class VoucherData {
  final List<Voucher> cashback;
  final List<Voucher> discount;
  final List<Voucher> freeShipping;

  VoucherData({
    required this.cashback,
    required this.discount,
    required this.freeShipping,
  });

  factory VoucherData.fromJson(Map<String, dynamic> json) {
    return VoucherData(
      cashback: (json['cashback'] as List)
          .map((e) => Voucher.fromJson(e))
          .toList(),
      discount: (json['discount'] as List)
          .map((e) => Voucher.fromJson(e))
          .toList(),
      freeShipping: (json['freeShipping'] as List)
          .map((e) => Voucher.fromJson(e))
          .toList(),
    );
  }
}

class Voucher {
  final int voucherId;
  final String voucherCode;
  final String voucherName;
  final String voucherDescription;
  final String voucherType;
  final String voucherPriceType;
  final int voucherPrice;
  final int voucherMinimumPurchasePrice;
  final int voucherQuantity;
  final DateTime expiryDate;

  Voucher({
    required this.voucherId,
    required this.voucherCode,
    required this.voucherName,
    required this.voucherDescription,
    required this.voucherType,
    required this.voucherPriceType,
    required this.voucherPrice,
    required this.voucherMinimumPurchasePrice,
    required this.voucherQuantity,
    required this.expiryDate,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      voucherId: json['voucherId'],
      voucherCode: json['voucherCode'],
      voucherName: json['voucherName'],
      voucherDescription: json['voucherDescription'],
      voucherType: json['voucherType'],
      voucherPriceType: json['voucherPriceType'],
      voucherPrice: json['voucherPrice'],
      voucherMinimumPurchasePrice: json['voucherMinimumPurchasePrice'],
      voucherQuantity: json['voucherQuantity'],
      expiryDate: DateTime.parse(json['expiryDate']),
    );
  }
}
