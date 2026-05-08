enum WorkoutType {
  pushDay(
    displayName: "Push Day",
    emoji: "💪",
  ),

  pullDay(
    displayName: "Pull Day",
    emoji: "🏋️",
  ),

  legDay(
    displayName: "Leg Day",
    emoji: "🦵",
  ),

  hiit(
    displayName: "HIIT Cardio",
    emoji: "🔥",
  ),

  running(
    displayName: "Running",
    emoji: "🏃",
  ),

  cycling(
    displayName: "Cycling",
    emoji: "🚴",
  ),

  yoga(
    displayName: "Yoga Flow",
    emoji: "🧘",
  ),

  swimming(
    displayName: "Swimming",
    emoji: "🏊",
  ),

  boxing(
    displayName: "Boxing",
    emoji: "🥊",
  ),

  trekking(
    displayName: "Trekking",
    emoji: "🥾",
  ),

  stretching(
    displayName: "Stretching",
    emoji: "🤸",
  ),

  football(
    displayName: "Football Practice",
    emoji: "⚽",
  ),

  basketball(
    displayName: "Basketball Training",
    emoji: "🏀",
  );

  final String displayName;
  final String emoji;

  const WorkoutType({
    required this.displayName,
    required this.emoji,
  });
}