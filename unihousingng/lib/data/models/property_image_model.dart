class PropertyImageModel {
  final String id;
  final String url;
  final String? thumbnailUrl;
  final String? caption;
  final String type; // 'exterior', 'interior', 'bedroom', 'bathroom', 'kitchen', 'living_room', 'other'
  final bool isPrimary;
  final int order;
  final Map<String, dynamic>? metadata;

  const PropertyImageModel({
    required this.id,
    required this.url,
    this.thumbnailUrl,
    this.caption,
    required this.type,
    this.isPrimary = false,
    required this.order,
    this.metadata,
  });

  factory PropertyImageModel.fromMap(Map<String, dynamic> map) {
    return PropertyImageModel(
      id: map['id'] ?? '',
      url: map['url'] ?? '',
      thumbnailUrl: map['thumbnailUrl'],
      caption: map['caption'],
      type: map['type'] ?? 'other',
      isPrimary: map['isPrimary'] ?? false,
      order: map['order'] ?? 0,
      metadata: map['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'caption': caption,
      'type': type,
      'isPrimary': isPrimary,
      'order': order,
      'metadata': metadata,
    };
  }

  PropertyImageModel copyWith({
    String? id,
    String? url,
    String? thumbnailUrl,
    String? caption,
    String? type,
    bool? isPrimary,
    int? order,
    Map<String, dynamic>? metadata,
  }) {
    return PropertyImageModel(
      id: id ?? this.id,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      caption: caption ?? this.caption,
      type: type ?? this.type,
      isPrimary: isPrimary ?? this.isPrimary,
      order: order ?? this.order,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PropertyImageModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PropertyImageModel(id: $id, url: $url, type: $type, isPrimary: $isPrimary, order: $order)';
  }

  // Helper methods
  bool get isExterior => type == 'exterior';
  bool get isInterior => type == 'interior';
  bool get isBedroom => type == 'bedroom';
  bool get isBathroom => type == 'bathroom';
  bool get isKitchen => type == 'kitchen';
  bool get isLivingRoom => type == 'living_room';

  String get displayUrl => thumbnailUrl ?? url;
  String get fullSizeUrl => url;

  static List<String> get imageTypes => [
    'exterior',
    'interior',
    'bedroom',
    'bathroom',
    'kitchen',
    'living_room',
    'other',
  ];

  static String getTypeDisplayName(String type) {
    switch (type) {
      case 'exterior':
        return 'Exterior';
      case 'interior':
        return 'Interior';
      case 'bedroom':
        return 'Bedroom';
      case 'bathroom':
        return 'Bathroom';
      case 'kitchen':
        return 'Kitchen';
      case 'living_room':
        return 'Living Room';
      case 'other':
        return 'Other';
      default:
        return 'Unknown';
    }
  }
}
