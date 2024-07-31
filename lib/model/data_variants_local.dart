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
        variantOption!.add(new VariantOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['variantName'] = this.variantName;
    data['isRequired'] = this.isRequired;
    data['minimal'] = this.minimal;
    data['maximal'] = this.maximal;
    if (this.variantOption != null) {
      data['variantOption'] =
          this.variantOption!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['variantOptionName'] = this.variantOptionName;
    data['variantOptionPrice'] = this.variantOptionPrice;
    return data;
  }
}
