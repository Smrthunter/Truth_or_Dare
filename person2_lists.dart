import 'dart:math';

// PERSON 2: THE LISTS
// 15 truths, 15 dares, and a 5-line function that hands back a
// random prompt for whichever type the wheel landed on.

final List<String> truths = [
  "What's your most useless talent?",
  "If you could be an animal for a day, what would you do?",
  "What's the last lie you told?",
  "What's the weirdest thing you've Googled?",
  "What's a habit you have that you'd never admit to?",
  "What's the most embarrassing thing in your camera roll?",
  "Who's the last person you stalked on social media?",
  "What's a secret talent nobody knows about?",
  "What's the dumbest thing you've cried over?",
  "What's your most irrational fear?",
  "What's a rumor you started or spread?",
  "What's the weirdest dream you've ever had?",
  "What's the cringiest thing you did as a kid?",
  "What app do you spend the most time on you're embarrassed by?",
  "What's the worst gift you've ever received and pretended to like?",
];

final List<String> dares = [
  "Talk like a robot for the next 10 seconds.",
  "Compliment the person on your left.",
  "Do your best chicken dance.",
  "Speak in an accent for the next minute.",
  "Let someone else post a story on your account.",
  "Do 10 jumping jacks right now.",
  "Try to lick your elbow.",
  "Sing your next sentence instead of saying it.",
  "Let the group go through your camera roll for 10 seconds.",
  "Do your impression of someone in the room.",
  "Text a random contact 'I know what you did'.",
  "Hold a plank for 20 seconds.",
  "Speak only in questions for the next two minutes.",
  "Do your best runway walk across the room.",
  "Let someone draw on your hand with a pen.",
];

String getPrompt(String type) {
  final random = Random();
  final list = type == "Truth" ? truths : dares;
  return list[random.nextInt(list.length)];
}
