class VariantDatas {
  String? variantName;
  bool? isRequired;
  int? minimal;
  int? maximal;
  List<VariantOption>? variantOption;

  VariantDatas({this.variantName, this.isRequired, this.variantOption, this.minimal, this.maximal,});

  VariantDatas.fromJson(Map<String, dynamic> json) {
    variantName = json['variantName'];
    isRequired = json['isRequired'];
    minimal = json['minimal'];
    maximal = json['maximal'];
    if (json['variantOption'] != null) {
      variantOption = <VariantOption>[];
      json['variantOption'].forEach((v) {
        variantOption!.add(VariantOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variantName'] = variantName;
    data['isRequired'] = isRequired;
    data['minimal'] = minimal;
    data['maximal'] = maximal;
    if (variantOption != null) {
      data['variantOption'] =
          variantOption!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VariantOption {
  String? variantOptionName;
  int? variantOptionPrice;

  VariantOption({this.variantOptionName, this.variantOptionPrice});

  VariantOption.fromJson(Map<String, dynamic> json) {
    variantOptionName = json['variantOptionName'];
    variantOptionPrice = json['variantOptionPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variantOptionName'] = variantOptionName;
    data['variantOptionPrice'] = variantOptionPrice;
    return data;
  }
}
