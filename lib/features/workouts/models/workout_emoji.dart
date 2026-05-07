enum WorkoutEmoji {
  // Strength Training
  weights('🏋️'),
  bodybuilding('💪'),
  powerlifting('⛓️'),
  pushups('🤸'),
  
  // Cardio
  running('🏃'),
  walking('🚶'),
  cycling('🚴'),
  swimming('🏊'),
  stairClimber('🧗'),
  
  // Flexibility & Mindset
  yoga('🧘'),
  stretching('🙆'),
  meditation('🕯️'),
  
  // Combat & Sports
  boxing('🥊'),
  basketball('🏀'),
  soccer('⚽'),
  tennis('🎾'),
  
  // Tools & Tracking
  timer('⏱️'),
  stopwatch('⏲️'),
  heartbeat('💓'),
  fire('🔥'),
  generic('⚡');

  final String value;
  const WorkoutEmoji(this.value);
}
