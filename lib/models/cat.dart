// cat.dart
class Cat {
  final String id;
  final String imageUrl;
  final String breedName;
  final String breedDescription;
  final String temperament;
  final String origin;
  final String lifeSpan;

  /// Дата, когда пользователь лайкнул этого кота.
  /// В вашем случае хранится только в рантайме.
  final DateTime? likedAt;

  Cat({
    required this.id,
    required this.imageUrl,
    required this.breedName,
    required this.breedDescription,
    required this.temperament,
    required this.origin,
    required this.lifeSpan,
    this.likedAt,
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

  /// Метод, чтобы удобно копировать котика, добавляя/меняя likedAt.
  Cat copyWith({DateTime? likedAt}) {
    return Cat(
      id: id,
      imageUrl: imageUrl,
      breedName: breedName,
      breedDescription: breedDescription,
      temperament: temperament,
      origin: origin,
      lifeSpan: lifeSpan,
      likedAt: likedAt ?? this.likedAt,
    );
  }
}
