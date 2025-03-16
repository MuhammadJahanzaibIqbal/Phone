class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String profession;
  final String address;
  final String? photoUrl;

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.profession,
    required this.address,
    this.photoUrl,
  });

  factory Contact.fromMap(Map<String, dynamic> map, String id) {
    return Contact(
      id: id,
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      profession: map['profession'] ?? '',
      address: map['address'] ?? '',
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'profession': profession,
      'address': address,
      'photoUrl': photoUrl,
    };
  }
}