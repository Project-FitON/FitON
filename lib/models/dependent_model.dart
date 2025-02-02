class Dependant {
  final String dependentId;
  final String buyerId;
  final String nickname;
  final DateTime dateOfBirth;
  final String gender;
  final Map<String, dynamic> sizeMeasurements;
  final bool recommendationOptOut;
  final DateTime createdAt;
  final DateTime updatedAt;

  Dependant({
    required this.dependentId,
    required this.buyerId,
    required this.nickname,
    required this.dateOfBirth,
    required this.gender,
    required this.sizeMeasurements,
    required this.recommendationOptOut,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Dependant.fromMap(Map<String, dynamic> data) {
    return Dependant(
      dependentId: data['dependent_id'],
      buyerId: data['buyer_id'],
      nickname: data['nickname'],
      dateOfBirth: DateTime.parse(data['date_of_birth']),
      gender: data['gender'],
      sizeMeasurements: data['size_measurements'],
      recommendationOptOut: data['recommendation_opt_out'],
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dependent_id': dependentId,
      'buyer_id': buyerId,
      'nickname': nickname,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'size_measurements': sizeMeasurements,
      'recommendation_opt_out': recommendationOptOut,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
