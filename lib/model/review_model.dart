class ReviewsModel {
  int? statusCode;
  String? status;
  String? message;
  DataReview? data;

  ReviewsModel({this.statusCode, this.status, this.message, this.data});

  ReviewsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new DataReview.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DataReview {
  MerchantInformation? merchantInformation;
  MenuInformation? menuInformation;
  Reviews? reviews;

  DataReview({this.merchantInformation, this.reviews, this.menuInformation});

  DataReview.fromJson(Map<String, dynamic> json) {
    merchantInformation = json['merchantInformation'] != null
        ? new MerchantInformation.fromJson(json['merchantInformation'])
        : null;
    menuInformation = json['menuInformation'] != null
        ? new MenuInformation.fromJson(json['menuInformation'])
        : null;
    reviews =
        json['reviews'] != null ? new Reviews.fromJson(json['reviews']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.merchantInformation != null) {
      data['merchantInformation'] = this.merchantInformation!.toJson();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.toJson();
    }
    return data;
  }
}

class MerchantInformation {
  int? merchantId;
  String? merchantName;
  String? merchantPhoto;
  String? merchantType;
  int? merchantFollowers;
  double? merchantRating;
  int? totalMerchantReviews;

  MerchantInformation(
      {this.merchantId,
      this.merchantName,
      this.merchantPhoto,
      this.merchantType,
      this.merchantFollowers,
      this.merchantRating,
      this.totalMerchantReviews});

  MerchantInformation.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    merchantName = json['merchantName'];
    merchantPhoto = json['merchantPhoto'];
    merchantType = json['merchantType'];
    merchantFollowers = json['merchantFollowers'];
    merchantRating = json['merchantRating'];
    totalMerchantReviews = json['totalMerchantReviews'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['merchantId'] = this.merchantId;
    data['merchantName'] = this.merchantName;
    data['merchantPhoto'] = this.merchantPhoto;
    data['merchantType'] = this.merchantType;
    data['merchantFollowers'] = this.merchantFollowers;
    data['merchantRating'] = this.merchantRating;
    data['totalMerchantReviews'] = this.totalMerchantReviews;
    return data;
  }
}

class MenuInformation {
  int? menuId;
  String? menuName;
  String? menuPhoto;
  int? menuLikes;
  double? menuRating;
  int? menuSolds;
  int? totalMenuReviews;
  int? menuPrice;

  MenuInformation(
      {this.menuId,
      this.menuName,
      this.menuPhoto,
      this.menuLikes,
      this.menuRating,
      this.menuSolds,
      this.totalMenuReviews,
      this.menuPrice});

  MenuInformation.fromJson(Map<String, dynamic> json) {
    menuId = json['menuId'];
    menuName = json['menuName'];
    menuPhoto = json['menuPhoto'];
    menuLikes = json['menuLikes'];
    menuRating = json['menuRating'];
    menuSolds = json['menuSolds'];
    totalMenuReviews = json['totalMenuReviews'];
    menuPrice = json['menuPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuId'] = this.menuId;
    data['menuName'] = this.menuName;
    data['menuPhoto'] = this.menuPhoto;
    data['menuLikes'] = this.menuLikes;
    data['menuRating'] = this.menuRating;
    data['menuSolds'] = this.menuSolds;
    data['totalMenuReviews'] = this.totalMenuReviews;
    data['menuPrice'] = this.menuPrice;
    return data;
  }
}


class Reviews {
  ReviewsList? all;
  ReviewsList? five;
  ReviewsList? four;
  ReviewsList? three;
  ReviewsList? two;
  ReviewsList? one;

  Reviews({this.all, this.five, this.four, this.three, this.two, this.one});

  Reviews.fromJson(Map<String, dynamic> json) {
    all = json['all'] != null ? new ReviewsList.fromJson(json['all']) : null;
    five = json['five'] != null ? new ReviewsList.fromJson(json['five']) : null;
    four = json['four'] != null ? new ReviewsList.fromJson(json['four']) : null;
    three = json['three'] != null ? new ReviewsList.fromJson(json['three']) : null;
    two = json['two'] != null ? new ReviewsList.fromJson(json['two']) : null;
    one = json['one'] != null ? new ReviewsList.fromJson(json['one']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.all != null) {
      data['all'] = this.all!.toJson();
    }
    if (this.five != null) {
      data['five'] = this.five!.toJson();
    }
    if (this.four != null) {
      data['four'] = this.four!.toJson();
    }
    if (this.three != null) {
      data['three'] = this.three!.toJson();
    }
    if (this.two != null) {
      data['two'] = this.two!.toJson();
    }
    if (this.one != null) {
      data['one'] = this.one!.toJson();
    }
    return data;
  }
}

class ReviewsList {
  int? total;
  List<ReviewItem>? list;

  ReviewsList({this.total, this.list});

  ReviewsList.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['list'] != null) {
      list = <ReviewItem>[];
      json['list'].forEach((v) {
        list!.add(new ReviewItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReviewItem {
  int? reviewId;
  String? userName;
  String? userPhoto;
  int? rating;
  String? reviewText;
  String? reviewCreated;
  String? responseText;
  String? responseCreated;
  String? menus;

  ReviewItem(
      {this.reviewId,
      this.userName,
      this.userPhoto,
      this.rating,
      this.reviewText,
      this.reviewCreated,
      this.responseText,
      this.responseCreated,
      this.menus});

  ReviewItem.fromJson(Map<String, dynamic> json) {
    reviewId = json['reviewId'];
    userName = json['userName'];
    userPhoto = json['userPhoto'];
    rating = json['rating'];
    reviewText = json['reviewText'];
    reviewCreated = json['reviewCreated'];
    responseText = json['responseText'];
    responseCreated = json['responseCreated'];
    menus = json['menus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reviewId'] = this.reviewId;
    data['rating'] = this.rating;
    data['reviewText'] = this.reviewText;
    data['reviewCreated'] = this.reviewCreated;
    data['responseText'] = this.responseText;
    data['responseCreated'] = this.responseCreated;
    data['menus'] = this.menus;
    return data;
  }
}


