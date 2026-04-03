enum ClueCategory { home, garden, park, birthday, any }

enum ClueDifficulty { easy, medium, hard }

class LibraryClue {
  final String riddle;
  final String answer;
  final ClueCategory category;
  final ClueDifficulty difficulty;

  const LibraryClue({
    required this.riddle,
    required this.answer,
    required this.category,
    required this.difficulty,
  });

  String get difficultyEmoji {
    switch (difficulty) {
      case ClueDifficulty.easy:
        return '🟢';
      case ClueDifficulty.medium:
        return '🟡';
      case ClueDifficulty.hard:
        return '🔴';
    }
  }

  String get categoryName {
    switch (category) {
      case ClueCategory.home:
        return 'Home';
      case ClueCategory.garden:
        return 'Garden';
      case ClueCategory.park:
        return 'Park';
      case ClueCategory.birthday:
        return 'Birthday';
      case ClueCategory.any:
        return 'Any';
    }
  }
}

class ClueLibrary {
  static const List<LibraryClue> clues = [
    // ===== HOME — Easy (4) =====
    LibraryClue(
      riddle: 'I have hands but cannot clap,\nI have a face but wear no cap.\nI tick and tock throughout the day,\nFind me now — don\'t delay!',
      answer: 'Clock',
      category: ClueCategory.home,
      difficulty: ClueDifficulty.easy,
    ),
    LibraryClue(
      riddle: 'I\'m cold inside but warm to see,\nI keep your snacks safe — come find me!\nOpen my door and feel the chill,\nI\'m in the kitchen, standing still.',
      answer: 'Fridge',
      category: ClueCategory.home,
      difficulty: ClueDifficulty.easy,
    ),
    LibraryClue(
      riddle: 'Soft and squishy, full of fluff,\nI sit on beds — I\'m soft enough!\nRest your head on me at night,\nI\'ll keep you comfy till it\'s light.',
      answer: 'Pillow',
      category: ClueCategory.home,
      difficulty: ClueDifficulty.easy,
    ),
    LibraryClue(
      riddle: 'I have legs but cannot run,\nYou sit on me when day is done.\nAt dinner time you pull me near,\nYour next clue\'s hiding right round here!',
      answer: 'Chair',
      category: ClueCategory.home,
      difficulty: ClueDifficulty.easy,
    ),

    // ===== HOME — Medium (4) =====
    LibraryClue(
      riddle: 'I spin and spin to get things clean,\nThe noisiest helper you\'ve ever seen.\nPut clothes inside and shut my door,\nI\'ll wash them well — that\'s what I\'m for!',
      answer: 'Washing machine',
      category: ClueCategory.home,
      difficulty: ClueDifficulty.medium,
    ),
    LibraryClue(
      riddle: 'I hold your treasures row by row,\nBooks and toys all in a show.\nI stand against the bedroom wall,\nCheck every shelf — don\'t miss them all!',
      answer: 'Bookshelf',
      category: ClueCategory.home,
      difficulty: ClueDifficulty.medium,
    ),
    LibraryClue(
      riddle: 'You step inside me every day,\nTo wash the mud and grime away.\nI rain indoors but that\'s okay,\nThe next clue\'s near — hip hooray!',
      answer: 'Shower',
      category: ClueCategory.home,
      difficulty: ClueDifficulty.medium,
    ),
    LibraryClue(
      riddle: 'I have a tongue but cannot speak,\nI come in pairs upon your feet.\nLook where I live beside the door,\nYour clue is waiting on the floor!',
      answer: 'Shoes / shoe rack',
      category: ClueCategory.home,
      difficulty: ClueDifficulty.medium,
    ),

    // ===== HOME — Hard (4) =====
    LibraryClue(
      riddle: 'I swallow crumbs from every meal,\nI roar and rumble — hear me squeal!\nI have a bag but carry no gold,\nPush me around as you are told.',
      answer: 'Vacuum cleaner',
      category: ClueCategory.home,
      difficulty: ClueDifficulty.hard,
    ),
    LibraryClue(
      riddle: 'A tiny cave of warming light,\nI cook your food and do it right.\nI spin your plate round and round,\nBeep beep — your next clue can be found!',
      answer: 'Microwave',
      category: ClueCategory.home,
      difficulty: ClueDifficulty.hard,
    ),
    LibraryClue(
      riddle: 'I\'m not a river but I have a bed,\nI\'m not alive but have a head.\nYou tuck yourself beneath my sheet,\nSearch underneath — a clue to meet!',
      answer: 'Bed',
      category: ClueCategory.home,
      difficulty: ClueDifficulty.hard,
    ),
    LibraryClue(
      riddle: 'I guard the house but have no sword,\nI open wide at just one word.\nKnock knock knock upon my face,\nBehind me hides the treasure place!',
      answer: 'Front door',
      category: ClueCategory.home,
      difficulty: ClueDifficulty.hard,
    ),

    // ===== GARDEN — Easy (4) =====
    LibraryClue(
      riddle: 'I stand outside in sun and rain,\nTurn me on and off again.\nWater sprays from me with glee,\nCome outside and look for me!',
      answer: 'Garden tap / hose',
      category: ClueCategory.garden,
      difficulty: ClueDifficulty.easy,
    ),
    LibraryClue(
      riddle: 'I\'m full of dirt but I\'m not a mess,\nFlowers grow in me — can you guess?\nI sit outside and hold the blooms,\nCheck near me for treasure rooms!',
      answer: 'Flower pot',
      category: ClueCategory.garden,
      difficulty: ClueDifficulty.easy,
    ),
    LibraryClue(
      riddle: 'I\'m tall and green and love the sun,\nMy leaves wave when the breeze has begun.\nBirds call me home — I\'m strong and wide,\nYour next clue waits at my trunk side!',
      answer: 'Tree',
      category: ClueCategory.garden,
      difficulty: ClueDifficulty.easy,
    ),
    LibraryClue(
      riddle: 'Back and forth and up so high,\nI help you feel like you can fly!\nHold on tight with both your hands,\nThe clue is near where this thing stands.',
      answer: 'Swing',
      category: ClueCategory.garden,
      difficulty: ClueDifficulty.easy,
    ),

    // ===== GARDEN — Medium (4) =====
    LibraryClue(
      riddle: 'I\'m home to birds but have no door,\nI hang up high — they tweet and soar.\nLook up above among the trees,\nThe next clue\'s floating in the breeze!',
      answer: 'Bird house / feeder',
      category: ClueCategory.garden,
      difficulty: ClueDifficulty.medium,
    ),
    LibraryClue(
      riddle: 'I eat your rubbish, what a treat!\nBanana peels and veggie meat.\nI turn your scraps to garden gold,\nSearch near me — be brave and bold!',
      answer: 'Compost bin',
      category: ClueCategory.garden,
      difficulty: ClueDifficulty.medium,
    ),
    LibraryClue(
      riddle: 'I\'m green and flat and freshly mowed,\nA carpet where the games are showed.\nRun across me, roll and play,\nThe clue is hidden here today!',
      answer: 'Lawn',
      category: ClueCategory.garden,
      difficulty: ClueDifficulty.medium,
    ),
    LibraryClue(
      riddle: 'I carry tools for garden chores,\nSpades and rakes behind my doors.\nA little house of wood or tin,\nPeek inside — the clue\'s within!',
      answer: 'Garden shed',
      category: ClueCategory.garden,
      difficulty: ClueDifficulty.medium,
    ),

    // ===== GARDEN — Hard (4) =====
    LibraryClue(
      riddle: 'I\'m round and rubber, bouncy too,\nI fly through air when kicked by you.\nI rest outside when games are done,\nThe clue is near me — start to run!',
      answer: 'Ball / football',
      category: ClueCategory.garden,
      difficulty: ClueDifficulty.hard,
    ),
    LibraryClue(
      riddle: 'I\'m made of wire and stand up tall,\nI keep the neighbours from your ball.\nI stretch from left to right so far,\nThe clue is where my posts are!',
      answer: 'Fence',
      category: ClueCategory.garden,
      difficulty: ClueDifficulty.hard,
    ),
    LibraryClue(
      riddle: 'Not a bath but full of water,\nFishes swim — both son and daughter.\nLily pads and maybe a frog,\nSearch near me, behind the log!',
      answer: 'Garden pond',
      category: ClueCategory.garden,
      difficulty: ClueDifficulty.hard,
    ),
    LibraryClue(
      riddle: 'I twirl and spin when breezes blow,\nPut me in sun and watch me glow.\nA garden spinner, bright and fun,\nFind the clue before I\'m done!',
      answer: 'Windmill / wind spinner',
      category: ClueCategory.garden,
      difficulty: ClueDifficulty.hard,
    ),

    // ===== PARK — Easy (4) =====
    LibraryClue(
      riddle: 'I go down fast but climb up slow,\nSit at the top and down you go!\nShiny, steep, and full of fun,\nThe clue awaits when sliding\'s done!',
      answer: 'Slide',
      category: ClueCategory.park,
      difficulty: ClueDifficulty.easy,
    ),
    LibraryClue(
      riddle: 'Sit on me to take a rest,\nI\'m the park\'s most comfy nest.\nMade of wood or maybe steel,\nCheck beneath — a clue to reveal!',
      answer: 'Park bench',
      category: ClueCategory.park,
      difficulty: ClueDifficulty.easy,
    ),
    LibraryClue(
      riddle: 'I\'m full of sand but not the beach,\nBuckets and spades within your reach.\nDig around and have some fun,\nThe buried clue waits everyone!',
      answer: 'Sandpit',
      category: ClueCategory.park,
      difficulty: ClueDifficulty.easy,
    ),
    LibraryClue(
      riddle: 'I\'m where you put your rubbish in,\nA great big belly made of tin.\nAfter snacks just look inside,\nThat\'s where the next clue likes to hide!',
      answer: 'Rubbish bin',
      category: ClueCategory.park,
      difficulty: ClueDifficulty.easy,
    ),

    // ===== PARK — Medium (4) =====
    LibraryClue(
      riddle: 'I spin you round and round so fast,\nHold on tight — it\'s quite a blast!\nDizzy, dizzy, what a ride,\nThe clue is somewhere by my side!',
      answer: 'Roundabout / merry-go-round',
      category: ClueCategory.park,
      difficulty: ClueDifficulty.medium,
    ),
    LibraryClue(
      riddle: 'Climb my rungs up to the sky,\nMonkey bars — give them a try!\nSwing across from bar to bar,\nThe next clue isn\'t very far!',
      answer: 'Monkey bars / climbing frame',
      category: ClueCategory.park,
      difficulty: ClueDifficulty.medium,
    ),
    LibraryClue(
      riddle: 'I bubble and I flow all day,\nBirds and dogs come here to play.\nListen for my splashing sound,\nThat\'s where the treasure can be found!',
      answer: 'Water fountain / drinking fountain',
      category: ClueCategory.park,
      difficulty: ClueDifficulty.medium,
    ),
    LibraryClue(
      riddle: 'I point the way with arrows clear,\nWhich path to take to get from here.\nI stand up tall for all to see,\nThe clue is posted right on me!',
      answer: 'Signpost',
      category: ClueCategory.park,
      difficulty: ClueDifficulty.medium,
    ),

    // ===== PARK — Hard (4) =====
    LibraryClue(
      riddle: 'One goes up and one comes down,\nThe best invention in the town!\nTwo can ride me — what a pair,\nCheck my seat — the clue is there!',
      answer: 'Seesaw',
      category: ClueCategory.park,
      difficulty: ClueDifficulty.hard,
    ),
    LibraryClue(
      riddle: 'I\'m drawn in white upon the ground,\nA field of play where goals are found.\nKick a ball from end to end,\nSearch the goal post, round the bend!',
      answer: 'Sports field / goal post',
      category: ClueCategory.park,
      difficulty: ClueDifficulty.hard,
    ),
    LibraryClue(
      riddle: 'I\'m wooden, old, and bridges go,\nOver puddles down below.\nCreak and creak beneath your feet,\nThe clue awaits — now that\'s a treat!',
      answer: 'Wooden bridge / boardwalk',
      category: ClueCategory.park,
      difficulty: ClueDifficulty.hard,
    ),
    LibraryClue(
      riddle: 'A map of paths for all to read,\nI show you where the trails will lead.\nBehind my board of glass and wood,\nThe hidden clue\'s where I have stood!',
      answer: 'Park information board / map',
      category: ClueCategory.park,
      difficulty: ClueDifficulty.hard,
    ),

    // ===== BIRTHDAY — Easy (4) =====
    LibraryClue(
      riddle: 'I\'m full of air and float up high,\nIn every colour to the sky.\nPop me not — I\'m here for fun,\nThe clue is tied where I have hung!',
      answer: 'Balloon',
      category: ClueCategory.birthday,
      difficulty: ClueDifficulty.easy,
    ),
    LibraryClue(
      riddle: 'I\'m wrapped in paper, bright and neat,\nI\'m the birthday\'s biggest treat!\nTear me open, what\'s inside?\nYour next clue is along for the ride!',
      answer: 'Present / gift',
      category: ClueCategory.birthday,
      difficulty: ClueDifficulty.easy,
    ),
    LibraryClue(
      riddle: 'Sweet and creamy, piled up high,\nWith candles burning to the sky.\nMake a wish and blow them out,\nThe next clue\'s near without a doubt!',
      answer: 'Birthday cake',
      category: ClueCategory.birthday,
      difficulty: ClueDifficulty.easy,
    ),
    LibraryClue(
      riddle: 'I hang from walls in coloured streams,\nI\'m part of every birthday dream.\nTwisted paper, long and bright,\nThe clue is dangling in plain sight!',
      answer: 'Streamers / party decorations',
      category: ClueCategory.birthday,
      difficulty: ClueDifficulty.easy,
    ),

    // ===== BIRTHDAY — Medium (4) =====
    LibraryClue(
      riddle: 'I play the tunes that make you dance,\nPress my buttons — take the chance!\nI\'m louder than a whisper small,\nThe clue is near the music hall!',
      answer: 'Speaker / music player',
      category: ClueCategory.birthday,
      difficulty: ClueDifficulty.medium,
    ),
    LibraryClue(
      riddle: 'Fill me up with sweets and treats,\nHit me hard for party eats!\nI\'m a donkey, star, or ball,\nSmash me open for them all!',
      answer: 'Piñata',
      category: ClueCategory.birthday,
      difficulty: ClueDifficulty.medium,
    ),
    LibraryClue(
      riddle: 'I\'m made of paper, pointy top,\nWear me on your head — don\'t stop!\nEvery guest gets one of me,\nCheck inside for clue number three!',
      answer: 'Party hat',
      category: ClueCategory.birthday,
      difficulty: ClueDifficulty.medium,
    ),
    LibraryClue(
      riddle: 'Plates and cups and forks galore,\nI\'m the table at the party\'s core.\nCovered in a cloth so bright,\nLook beneath me — left or right!',
      answer: 'Party table',
      category: ClueCategory.birthday,
      difficulty: ClueDifficulty.medium,
    ),

    // ===== BIRTHDAY — Hard (4) =====
    LibraryClue(
      riddle: 'I capture smiles and silly faces,\nI freeze the fun in all the places.\nSay cheese and flash — now count to three,\nThe clue is hiding close to me!',
      answer: 'Camera / photo booth',
      category: ClueCategory.birthday,
      difficulty: ClueDifficulty.hard,
    ),
    LibraryClue(
      riddle: 'I\'m full of chips and dip and more,\nA bowl of treats you can\'t ignore.\nCrunchy, salty, sweet delight,\nThe treasure\'s near — you\'re almost right!',
      answer: 'Snack bowl / party food table',
      category: ClueCategory.birthday,
      difficulty: ClueDifficulty.hard,
    ),
    LibraryClue(
      riddle: 'Tiny bags of joy for all,\nTake me home when curtains fall.\nFilled with treats and trinkets small,\nThe clue is in the best one — call!',
      answer: 'Party favour / loot bag',
      category: ClueCategory.birthday,
      difficulty: ClueDifficulty.hard,
    ),
    LibraryClue(
      riddle: 'I tell the world whose day it is,\nWith letters big and full of fizz.\nHang me up for all to see,\nBehind my words the clue will be!',
      answer: 'Birthday banner / sign',
      category: ClueCategory.birthday,
      difficulty: ClueDifficulty.hard,
    ),

    // ===== ANY — Easy (4) =====
    LibraryClue(
      riddle: 'I have four legs but cannot walk,\nI cannot hear and cannot talk.\nPut things on me — that\'s my game,\nEvery house has one the same!',
      answer: 'Table',
      category: ClueCategory.any,
      difficulty: ClueDifficulty.easy,
    ),
    LibraryClue(
      riddle: 'Look at me to see your face,\nI copy you all over the place.\nI hang on walls or sit on shelves,\nCome find me and check yourselves!',
      answer: 'Mirror',
      category: ClueCategory.any,
      difficulty: ClueDifficulty.easy,
    ),
    LibraryClue(
      riddle: 'I have teeth but do not bite,\nI keep your hair all neat and right.\nBrush and comb throughout the day,\nThe clue is where I like to stay!',
      answer: 'Comb / hairbrush',
      category: ClueCategory.any,
      difficulty: ClueDifficulty.easy,
    ),
    LibraryClue(
      riddle: 'I\'m flat and square and glow so bright,\nI show you cartoons day and night.\nPress my buttons, change the show,\nThe clue is hidden down below!',
      answer: 'TV / television',
      category: ClueCategory.any,
      difficulty: ClueDifficulty.easy,
    ),

    // ===== ANY — Medium (4) =====
    LibraryClue(
      riddle: 'I\'m not alive but I have keys,\nI make sweet music if you please.\nBlack and white from left to right,\nThe clue is hiding out of sight!',
      answer: 'Piano / keyboard',
      category: ClueCategory.any,
      difficulty: ClueDifficulty.medium,
    ),
    LibraryClue(
      riddle: 'I keep your secrets under lock,\nA little diary round the clock.\nOpen me up with key or code,\nInside I keep the treasure trode!',
      answer: 'Locked box / diary',
      category: ClueCategory.any,
      difficulty: ClueDifficulty.medium,
    ),
    LibraryClue(
      riddle: 'Wheels and pedals, handlebars too,\nRide me fast — I\'m fun for you!\nI lean against the wall or gate,\nHurry up — the clue can\'t wait!',
      answer: 'Bicycle',
      category: ClueCategory.any,
      difficulty: ClueDifficulty.medium,
    ),
    LibraryClue(
      riddle: 'I\'m full of pages, tales, and more,\nAdventures through an open door.\nPick me up and read a line,\nThe clue inside is really fine!',
      answer: 'Book',
      category: ClueCategory.any,
      difficulty: ClueDifficulty.medium,
    ),

    // ===== ANY — Hard (4) =====
    LibraryClue(
      riddle: 'I tick but I\'m not a clock,\nI\'m on your wrist around the block.\nCheck the time then look below,\nThe hidden clue will steal the show!',
      answer: 'Watch / wristwatch',
      category: ClueCategory.any,
      difficulty: ClueDifficulty.hard,
    ),
    LibraryClue(
      riddle: 'I\'m always running, never still,\nThrough pipes and drains against my will.\nTurn me on with just a twist,\nThe clue is near — don\'t let it be missed!',
      answer: 'Tap / faucet',
      category: ClueCategory.any,
      difficulty: ClueDifficulty.hard,
    ),
    LibraryClue(
      riddle: 'I have cities but no houses stand,\nI have forests but no trees are planned.\nI have water but no fish inside,\nUnfold me flat — the clue won\'t hide!',
      answer: 'Map',
      category: ClueCategory.any,
      difficulty: ClueDifficulty.hard,
    ),
    LibraryClue(
      riddle: 'I\'m made of glass but I\'m not a window,\nI help you see the things below.\nScientists love me, that\'s no riddle,\nThe clue is hidden in my middle!',
      answer: 'Magnifying glass',
      category: ClueCategory.any,
      difficulty: ClueDifficulty.hard,
    ),
  ];
}
