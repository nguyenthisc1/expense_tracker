class PinCredentialModel {
  final String pinHash;
  final String salt;

  PinCredentialModel({required this.pinHash, required this.salt});

  Map<String, dynamic> toJson() {
    return {'pinHash': pinHash, 'salt': salt};
  }

  factory PinCredentialModel.fromJson(Map<String, dynamic> json) {
    return PinCredentialModel(pinHash: json['pinHash'], salt: json['salt']);
  }
}
