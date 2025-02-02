import 'dart:convert';

class TryOnModel {
  final String tryonId;
  final String buyerId;
  final String dependentId;
  final String productId;
  final String inputImageId;
  final List<String> generatedImages;
  final DateTime createdAt;

  TryOnModel({
    required this.tryonId,
    required this.buyerId,
    required this.dependentId,
    required this.productId,
    required this.inputImageId,
    required this.generatedImages,
    required this.createdAt,
  });

  factory TryOnModel.fromJson(Map<String, dynamic> json) {
    return TryOnModel(
      tryonId: json['tryon_id'],
      buyerId: json['buyer_id'],
      dependentId: json['dependent_id'],
      productId: json['product_id'],
      inputImageId: json['input_image_id'],
      generatedImages: List<String>.from(json['generated_images'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tryon_id': tryonId,
      'buyer_id': buyerId,
      'dependent_id': dependentId,
      'product_id': productId,
      'input_image_id': inputImageId,
      'generated_images': generatedImages,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}