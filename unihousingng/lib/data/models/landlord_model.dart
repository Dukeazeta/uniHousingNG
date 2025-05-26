class LandlordModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? whatsappNumber;
  final String? profileImageUrl;
  final double? rating;
  final int? totalProperties;
  final int? totalReviews;
  final bool isVerified;
  final String? bio;
  final List<String>? languages;
  final String? preferredContactMethod; // 'phone', 'whatsapp', 'email'
  final Map<String, bool>? availability; // Days of week availability
  final String? businessHours;
  final DateTime? joinedDate;

  const LandlordModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.whatsappNumber,
    this.profileImageUrl,
    this.rating,
    this.totalProperties,
    this.totalReviews,
    this.isVerified = false,
    this.bio,
    this.languages,
    this.preferredContactMethod,
    this.availability,
    this.businessHours,
    this.joinedDate,
  });

  factory LandlordModel.fromMap(Map<String, dynamic> map) {
    return LandlordModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'],
      phone: map['phone'],
      whatsappNumber: map['whatsappNumber'],
      profileImageUrl: map['profileImageUrl'],
      rating: map['rating']?.toDouble(),
      totalProperties: map['totalProperties']?.toInt(),
      totalReviews: map['totalReviews']?.toInt(),
      isVerified: map['isVerified'] ?? false,
      bio: map['bio'],
      languages: map['languages'] != null ? List<String>.from(map['languages']) : null,
      preferredContactMethod: map['preferredContactMethod'],
      availability: map['availability'] != null 
          ? Map<String, bool>.from(map['availability']) 
          : null,
      businessHours: map['businessHours'],
      joinedDate: map['joinedDate'] != null 
          ? DateTime.parse(map['joinedDate']) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'whatsappNumber': whatsappNumber,
      'profileImageUrl': profileImageUrl,
      'rating': rating,
      'totalProperties': totalProperties,
      'totalReviews': totalReviews,
      'isVerified': isVerified,
      'bio': bio,
      'languages': languages,
      'preferredContactMethod': preferredContactMethod,
      'availability': availability,
      'businessHours': businessHours,
      'joinedDate': joinedDate?.toIso8601String(),
    };
  }

  LandlordModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? whatsappNumber,
    String? profileImageUrl,
    double? rating,
    int? totalProperties,
    int? totalReviews,
    bool? isVerified,
    String? bio,
    List<String>? languages,
    String? preferredContactMethod,
    Map<String, bool>? availability,
    String? businessHours,
    DateTime? joinedDate,
  }) {
    return LandlordModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      rating: rating ?? this.rating,
      totalProperties: totalProperties ?? this.totalProperties,
      totalReviews: totalReviews ?? this.totalReviews,
      isVerified: isVerified ?? this.isVerified,
      bio: bio ?? this.bio,
      languages: languages ?? this.languages,
      preferredContactMethod: preferredContactMethod ?? this.preferredContactMethod,
      availability: availability ?? this.availability,
      businessHours: businessHours ?? this.businessHours,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }

  // Helper methods
  bool get hasPhone => phone != null && phone!.isNotEmpty;
  bool get hasWhatsApp => whatsappNumber != null && whatsappNumber!.isNotEmpty;
  bool get hasEmail => email != null && email!.isNotEmpty;
  
  String get displayPhone => phone ?? '';
  String get displayWhatsApp => whatsappNumber ?? phone ?? '';
  String get displayEmail => email ?? '';
  
  String get ratingText => rating != null ? rating!.toStringAsFixed(1) : 'No rating';
  String get propertiesText => totalProperties != null ? '$totalProperties properties' : 'No properties';
  String get reviewsText => totalReviews != null ? '$totalReviews reviews' : 'No reviews';
  
  bool get isAvailableToday {
    if (availability == null) return true;
    final today = DateTime.now().weekday;
    final dayNames = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    final todayName = dayNames[today - 1];
    return availability![todayName] ?? true;
  }

  List<String> get availableContactMethods {
    final methods = <String>[];
    if (hasPhone) methods.add('phone');
    if (hasWhatsApp) methods.add('whatsapp');
    if (hasEmail) methods.add('email');
    return methods;
  }

  String get preferredContact {
    if (preferredContactMethod != null && availableContactMethods.contains(preferredContactMethod)) {
      return preferredContactMethod!;
    }
    if (hasWhatsApp) return 'whatsapp';
    if (hasPhone) return 'phone';
    if (hasEmail) return 'email';
    return 'none';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LandlordModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'LandlordModel(id: $id, name: $name, phone: $phone, email: $email, rating: $rating)';
  }
}
