class Term {
  final int id;
  final String term;
  final String definition;
  final String example;

  Term({
    required this.id,
    required this.term,
    required this.definition,
    required this.example,
  });

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      id: json['id'],
      term: json['term'],
      definition: json['definition'],
      example: json['example'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'term': term,
      'definition': definition,
      'example': example,
    };
  }
}
