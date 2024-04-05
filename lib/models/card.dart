class CardModel {

  final int cvv; // never null, initialized on "add card"
  final String name; // never null, initialized on "add card"
  final String number; // never null, initialized on "add card"
  final String expirationDate; // never null, initialized on "add card"
  final String type; // never null, initialized on "add card"
  final double balance; // never null, initialized on "add card"

  CardModel({
    required this.cvv,
    required this.name,
    required this.number,
    required this.expirationDate,
    required this.type,
    required this.balance
  });

  Map<String, dynamic> toMap() {
    return {
      'cvv': cvv,
      'name': name,
      'number': number,
      'expirationDate': expirationDate,
      'type': type,
      'balance': balance
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> cardMap) {

    return CardModel(
      cvv: cardMap['cvv'],
      name: cardMap['name'],
      number: cardMap['number'],
      expirationDate: cardMap['expirationDate'],
      type: cardMap['type'],
      balance: cardMap['balance']
    );
  }
}