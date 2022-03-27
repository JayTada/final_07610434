class QuizItem {
  final String answer;
  final String image;
  final List<String> choices;

  QuizItem({
    required this.answer,
    required this.image,
    required this.choices,
  });

  factory QuizItem.fromJson(Map<String, dynamic> json) {
    return QuizItem(
        answer: json['answer'],
        image: json['image'],
        choices: json['choices']
    );
  }
  QuizItem.fromJson2(Map<String, dynamic> json)
      :
        answer = json['answer'],
        image = json['image'],
        choices = json['choices'];
}