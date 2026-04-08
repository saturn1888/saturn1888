import '../models/hunt.dart';
import '../models/clue.dart';
import '../models/hunt_theme.dart';

/// Pre-made hunts that work without any setup — riddles about everyday objects
class PremadeHunts {
  static List<Hunt> get all => [
        _houseHunt,
        _gardenHunt,
        _parkHunt,
        _birthdayHunt,
        _indoorAdventure,
      ];

  static final _houseHunt = Hunt(
    id: 'premade_house',
    name: 'House Explorer',
    themeType: HuntThemeType.pirate,
    timerMinutes: null,
    victoryMessage: 'Arr! Ye explored every corner of the house! 🏴‍☠️💰',
    clues: [
      Clue(
        text: 'I\'m cold inside but warm to see,\nI keep your snacks safe — come find me!\nOpen my door and feel the chill,\nI\'m in the kitchen, standing still.',
        wrongAnswerHint: 'It keeps food cold',
        answer: 'The Fridge!',
        order: 0,
      ),
      Clue(
        text: 'I have hands but cannot clap,\nI have a face but wear no cap.\nI tick and tock throughout the day,\nFind me now — don\'t delay!',
        wrongAnswerHint: 'It tells the time',
        answer: 'The Clock!',
        order: 1,
      ),
      Clue(
        text: 'Soft and squishy, full of fluff,\nI sit on beds — I\'m soft enough!\nRest your head on me at night,\nI\'ll keep you comfy till it\'s light.',
        wrongAnswerHint: 'You sleep on it',
        answer: 'A Pillow!',
        order: 2,
      ),
      Clue(
        text: 'I spin and spin to get things clean,\nThe noisiest helper you\'ve ever seen.\nPut clothes inside and shut my door,\nI\'ll wash them well — that\'s what I\'m for!',
        wrongAnswerHint: 'It washes your clothes',
        answer: 'The Washing Machine!',
        order: 3,
      ),
      Clue(
        text: 'I\'m flat and square and glow so bright,\nI show you cartoons day and night.\nPress my buttons, change the show,\nThe next clue\'s hidden down below!',
        wrongAnswerHint: 'You watch shows on it',
        answer: 'The TV!',
        order: 4,
      ),
    ],
  );

  static final _gardenHunt = Hunt(
    id: 'premade_garden',
    name: 'Garden Quest',
    themeType: HuntThemeType.jungle,
    timerMinutes: 15,
    victoryMessage: 'What an explorer! You conquered the garden! 🌿🦁',
    clues: [
      Clue(
        text: 'I\'m full of dirt but I\'m not a mess,\nFlowers grow in me — can you guess?\nI sit outside and hold the blooms,\nCheck near me for treasure rooms!',
        wrongAnswerHint: 'Flowers grow in it',
        answer: 'A Flower Pot!',
        order: 0,
      ),
      Clue(
        text: 'I\'m tall and green and love the sun,\nMy leaves wave when the breeze has begun.\nBirds call me home — I\'m strong and wide,\nYour next clue waits at my trunk side!',
        wrongAnswerHint: 'It has branches and leaves',
        answer: 'A Tree!',
        order: 1,
      ),
      Clue(
        text: 'Back and forth and up so high,\nI help you feel like you can fly!\nHold on tight with both your hands,\nThe clue is near where this thing stands.',
        wrongAnswerHint: 'You sit on it and go back and forth',
        answer: 'The Swing!',
        order: 2,
      ),
      Clue(
        text: 'I stand outside in sun and rain,\nTurn me on and off again.\nWater sprays from me with glee,\nCome outside and look for me!',
        wrongAnswerHint: 'It sprays water',
        answer: 'The Garden Tap!',
        order: 3,
      ),
      Clue(
        text: 'I\'m green and flat and freshly mowed,\nA carpet where the games are showed.\nRun across me, roll and play,\nThe clue is hidden here today!',
        wrongAnswerHint: 'You walk on it outside',
        answer: 'The Lawn!',
        order: 4,
      ),
    ],
  );

  static final _parkHunt = Hunt(
    id: 'premade_park',
    name: 'Park Adventure',
    themeType: HuntThemeType.custom,
    timerMinutes: 20,
    victoryMessage: 'You explored the whole park! Amazing adventurers! 🎯⭐',
    clues: [
      Clue(
        text: 'I go down fast but climb up slow,\nSit at the top and down you go!\nShiny, steep, and full of fun,\nThe clue awaits when sliding\'s done!',
        wrongAnswerHint: 'You slide down it',
        answer: 'The Slide!',
        order: 0,
      ),
      Clue(
        text: 'Sit on me to take a rest,\nI\'m the park\'s most comfy nest.\nMade of wood or maybe steel,\nCheck beneath — a clue to reveal!',
        wrongAnswerHint: 'You sit on it to rest',
        answer: 'A Park Bench!',
        order: 1,
      ),
      Clue(
        text: 'I spin you round and round so fast,\nHold on tight — it\'s quite a blast!\nDizzy, dizzy, what a ride,\nThe clue is somewhere by my side!',
        wrongAnswerHint: 'It spins you around in the playground',
        answer: 'The Roundabout!',
        order: 2,
      ),
      Clue(
        text: 'One goes up and one comes down,\nThe best invention in the town!\nTwo can ride me — what a pair,\nCheck my seat — the clue is there!',
        wrongAnswerHint: 'Two people go up and down on it',
        answer: 'The Seesaw!',
        order: 3,
      ),
      Clue(
        text: 'Climb my rungs up to the sky,\nMonkey bars — give them a try!\nSwing across from bar to bar,\nThe next clue isn\'t very far!',
        wrongAnswerHint: 'You climb and swing on it',
        answer: 'The Monkey Bars!',
        order: 4,
      ),
      Clue(
        text: 'I\'m full of sand but not the beach,\nBuckets and spades within your reach.\nDig around and have some fun,\nThe buried clue waits everyone!',
        wrongAnswerHint: 'You can build sandcastles in it',
        answer: 'The Sandpit!',
        order: 5,
      ),
    ],
  );

  static final _birthdayHunt = Hunt(
    id: 'premade_birthday',
    name: 'Birthday Surprise',
    themeType: HuntThemeType.birthday,
    timerMinutes: 10,
    victoryMessage: 'Happy birthday! You found all the party surprises! 🎂🎉🎁',
    clues: [
      Clue(
        text: 'I\'m full of air and float up high,\nIn every colour to the sky.\nPop me not — I\'m here for fun,\nThe clue is tied where I have hung!',
        wrongAnswerHint: 'They float and come in many colours',
        answer: 'Balloons!',
        order: 0,
      ),
      Clue(
        text: 'Sweet and creamy, piled up high,\nWith candles burning to the sky.\nMake a wish and blow them out,\nThe next clue\'s near without a doubt!',
        wrongAnswerHint: 'You blow out candles on it',
        answer: 'The Birthday Cake!',
        order: 1,
      ),
      Clue(
        text: 'I\'m wrapped in paper, bright and neat,\nI\'m the birthday\'s biggest treat!\nTear me open, what\'s inside?\nYour next clue is along for the ride!',
        wrongAnswerHint: 'You unwrap it',
        answer: 'A Present!',
        order: 2,
      ),
      Clue(
        text: 'I\'m made of paper, pointy top,\nWear me on your head — don\'t stop!\nEvery guest gets one of me,\nCheck inside for clue number three!',
        wrongAnswerHint: 'You wear it on your head at parties',
        answer: 'A Party Hat!',
        order: 3,
      ),
      Clue(
        text: 'I play the tunes that make you dance,\nPress my buttons — take the chance!\nI\'m louder than a whisper small,\nThe clue is near the music hall!',
        wrongAnswerHint: 'It plays music',
        answer: 'The Speaker!',
        order: 4,
      ),
    ],
  );

  static final _indoorAdventure = Hunt(
    id: 'premade_indoor',
    name: 'Indoor Adventure',
    themeType: HuntThemeType.space,
    timerMinutes: null,
    victoryMessage: 'Houston, we have a winner! All missions complete! 🚀⭐',
    clues: [
      Clue(
        text: 'Look at me to see your face,\nI copy you all over the place.\nI hang on walls or sit on shelves,\nCome find me and check yourselves!',
        wrongAnswerHint: 'You see your reflection in it',
        answer: 'A Mirror!',
        order: 0,
      ),
      Clue(
        text: 'I have teeth but do not bite,\nI keep your hair all neat and right.\nBrush and comb throughout the day,\nThe clue is where I like to stay!',
        wrongAnswerHint: 'You use it on your hair',
        answer: 'A Hairbrush!',
        order: 1,
      ),
      Clue(
        text: 'I have legs but cannot run,\nYou sit on me when day is done.\nAt dinner time you pull me near,\nYour next clue\'s hiding right round here!',
        wrongAnswerHint: 'You sit on it at the table',
        answer: 'A Chair!',
        order: 2,
      ),
      Clue(
        text: 'A tiny cave of warming light,\nI cook your food and do it right.\nI spin your plate round and round,\nBeep beep — your next clue can be found!',
        wrongAnswerHint: 'It heats food quickly',
        answer: 'The Microwave!',
        order: 3,
      ),
      Clue(
        text: 'I hold your treasures row by row,\nBooks and toys all in a show.\nI stand against the bedroom wall,\nCheck every shelf — don\'t miss them all!',
        wrongAnswerHint: 'Books and toys sit on it',
        answer: 'The Bookshelf!',
        order: 4,
      ),
      Clue(
        text: 'I\'m not a river but I have a bed,\nI\'m not alive but have a head.\nYou tuck yourself beneath my sheet,\nSearch underneath — a clue to meet!',
        wrongAnswerHint: 'You sleep in it every night',
        answer: 'The Bed!',
        order: 5,
      ),
    ],
  );
}
