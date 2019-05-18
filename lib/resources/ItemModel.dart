class ItemModel {
  final int id;
  final int score;
  final String title;
  final int descendants;

  ItemModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        score = parsedJson['score'] ?? 0,
        title = parsedJson['title'],
        descendants = parsedJson['descendants'] ?? 0;

}