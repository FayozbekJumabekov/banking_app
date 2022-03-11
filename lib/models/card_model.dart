class CardModel {
  String? id;
  String name;
  String cardNumber;
  String data;
  String cvv;

  CardModel({
    this.id,
    required this.name,
    required this.cardNumber,
    required this.data,
    required this.cvv,
  });

  CardModel.fromJson(Map<String, dynamic> json)
      : id = (json['id'] != null) ? json['id'] : null,
        name = json['name'],
        cardNumber = json['cardNumber'],
        data = json['data'],
        cvv = json['cvv'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cardNumber': cardNumber,
        'data': data,
        'cvv': cvv,
      };
}
