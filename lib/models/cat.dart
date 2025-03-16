class Cat {
  final String id;
  final String imageUrl;
  final String breedName;
  final String breedDescription;
  final String temperament;
  final String origin;
  final String lifeSpan;

  Cat({
    required this.id,
    required this.imageUrl,
    required this.breedName,
    required this.breedDescription,
    required this.temperament,
    required this.origin,
    required this.lifeSpan,
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      id: json['id'],
      imageUrl: json['url'],
      breedName: json['breeds'][0]['name'],
      breedDescription: json['breeds'][0]['description'] ?? 'No description',
      temperament: json['breeds'][0]['temperament'] ?? 'No description',
      origin: json['breeds'][0]['origin'] ?? 'No description',
      lifeSpan: json['breeds'][0]['life_span'] ?? 'No description',
    );
  }
}
