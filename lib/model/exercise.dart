class Exercise {
  String? id; // Optional document ID from Firestore.
  final String name;
  final String gif;
  final String equipment;
  final String target;
  final String bodyPart;

  Exercise({
    this.id,
    required this.name,
    required this.gif,
    required this.equipment,
    required this.target,
    required this.bodyPart,
  });

  // Method to convert an Exercise instance into a Map.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gif': gif,
      'equipment': equipment,
      'target': target,
      'bodyPart': bodyPart,
    };
  }

  // Factory method to create an Exercise from Firestore data.
  factory Exercise.fromMap(Map<String, dynamic> data, String documentId) {
    return Exercise(
      id: documentId,
      name: data['name'] as String? ?? 'Unnamed',
      gif: data['gif'] as String? ?? '',
      equipment: data['equipment'] as String? ?? 'None',
      target: data['target'] as String? ?? 'Unknown',
      bodyPart: data['bodyPart'] as String? ?? 'Unknown',
    );
  }
}
