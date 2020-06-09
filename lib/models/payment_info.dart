class BankingInfo {
  String accountHolderName;
  String routingNumber;
  String last4;
  String bankName;
  //bool verified;

  BankingInfo({
    this.accountHolderName,
    this.routingNumber,
    this.last4,
    this.bankName,
    //this.verified,
  });

  BankingInfo.fromMap(Map<String, dynamic> data)
      : this(
          accountHolderName: data['accountHolderName'],
          routingNumber: data['routingNumber'],
          last4: data['last4'],
          bankName: data['bankName'],
          //verified: data['verified'],
        );

  Map<String, dynamic> toMap() => {
        'accountHolderName': this.accountHolderName,
        'routingNumber': this.routingNumber,
        'last4': this.last4,
        'bankName': this.bankName,
        //'verified': this.verified
      };
}

class DebitCardInfo {
  String brand;
  String expMonth;
  String expYear;
  String last4;
  String funding;
  //String name;

  DebitCardInfo({
    this.brand,
    this.expMonth,
    this.expYear,
    this.last4,
    this.funding,
    //this.name,
  });

  DebitCardInfo.fromMap(Map<String, dynamic> data)
      : this(
          brand: data['brand'],
          expMonth: data['expMonth'],
          expYear: data['expYear'],
          last4: data['last4'],
          funding: data['funding'],
          //name: data['name'],
        );

  Map<String, dynamic> toMap() => {
        'brand': this.brand,
        'expMonth': this.expMonth,
        'expYear': this.expYear,
        'last4': this.last4,
        'funding': this.funding,
        //'name': this.name,
      };
}
