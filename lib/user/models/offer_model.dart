class OfferModel {
  List<Offer>? offer;

  OfferModel({
    this.offer,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        offer: json["offer"] == null
            ? []
            : List<Offer>.from(json["offer"]!.map((x) => Offer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "offer": offer == null
            ? []
            : List<dynamic>.from(offer!.map((x) => x.toJson())),
      };
}

class Offer {
  String? id;
  String? title;
  String? description;
  int? discountPercentage;
  DateTime? validFrom;
  DateTime? validTo;
  bool? isActive;
  String? offerImageUrl;
  String? publicId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Offer({
    this.id,
    this.title,
    this.description,
    this.discountPercentage,
    this.validFrom,
    this.validTo,
    this.isActive,
    this.offerImageUrl,
    this.publicId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        discountPercentage: json["discountPercentage"],
        validFrom: json["validFrom"] == null
            ? null
            : DateTime.parse(json["validFrom"]),
        validTo:
            json["validTo"] == null ? null : DateTime.parse(json["validTo"]),
        isActive: json["isActive"],
        offerImageUrl: json["offerImageUrl"],
        publicId: json["public_id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "discountPercentage": discountPercentage,
        "validFrom": validFrom?.toIso8601String(),
        "validTo": validTo?.toIso8601String(),
        "isActive": isActive,
        "offerImageUrl": offerImageUrl,
        "public_id": publicId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
