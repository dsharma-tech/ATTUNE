class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.date,
    this.description,
    this.isCompleted = false,
  });

  // CopyWith method for immutability updates if needed (though we might just mutate for simplicity in this MVP)
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
