// lib/models/favorite_model.dart
class Favorite {
  final int id;
  final int termId;
  final String term;
  final String definition;

  Favorite({
    required this.id,
    required this.termId,
    required this.term,
    required this.definition,
  });

  factory Favorite.fromJson(Map json) {
    return Favorite(
      id: json['id'],
      termId: json['term_id'] ?? json['termId'],
      term: json['term'] ?? '',
      definition: json['definition'] ?? '',
    );
  }
}
