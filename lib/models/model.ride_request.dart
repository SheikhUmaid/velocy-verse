class RideRequest {
  bool? status;
  String? message;
  List<Data>? data;

  RideRequest({this.status, this.message, this.data});

  RideRequest.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? toLocation;
  String? toLatitude;
  String? toLongitude;
  double? price;

  Data({
    this.id,
    this.toLocation,
    this.toLatitude,
    this.toLongitude,
    this.price,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toLocation = json['to_location'];
    toLatitude = json['to_latitude'];
    toLongitude = json['to_longitude'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['to_location'] = this.toLocation;
    data['to_latitude'] = this.toLatitude;
    data['to_longitude'] = this.toLongitude;
    data['price'] = this.price;
    return data;
  }
}
