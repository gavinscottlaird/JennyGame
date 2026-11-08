/// scr_scenarios -- the game's content: focuses, scenarios, and the keyword
/// rules that decide XP.
///
/// HOW SCORING DATA WORKS (see scr_score for the code)
///   correct     : the steps in the order that solves the problem
///   step_words  : one synonym list PER step in `correct`.
///                 A step earns 1 XP only when
///                   (a) the student clicked it in the correct position, AND
///                   (b) the written prediction names that step using any word
///                       on its list (so different wording still earns credit).
///                 These lists ARE the "core lesson". Anything else the student
///                 writes is treated as a minor detail and ignored.
///   A word with a space in it (e.g. "put on") is matched as a phrase.

/// @desc The four focus tags plus the keywords a typed focus word can match.
function focus_list() {
    return [
        { key : "school", label : "School",
          words : ["school", "class", "teacher", "bus", "homework", "work", "learn", "reading", "desk", "morning"] },
        { key : "social", label : "Friends",
          words : ["social", "friend", "friends", "play", "share", "talk", "recess", "party", "kids", "playground"] },
        { key : "home",   label : "Home",
          words : ["home", "house", "room", "clean", "chores", "bed", "bath", "dog", "pet", "night"] },
        { key : "food",   label : "Food",
          words : ["food", "eat", "snack", "kitchen", "lunch", "dinner", "toast", "hungry", "cook", "drink"] }
    ];
}

/// @desc Short plain word for what the player does at an object.
function object_verb(key) {
    static V = {
        bed      : "Get up",
        clothes  : "Put on shirt",
        backpack : "Grab bag",
        door     : "Go out",
        clock    : "Check clock",
        desk     : "Sit at desk",
        paper    : "Do work",
        tv       : "Watch TV",
        lunchbox : "Take lunch",
        shoes    : "Put on shoes",
        friend   : "Say hi",
        teacher  : "Tell grown up",
        ball     : "Get ball",
        swing    : "Take turns",
        bench    : "Sit and talk",
        snack    : "Eat apple",
        cup      : "Get water",
        toys     : "Put toys away",
        laundry  : "Put clothes in",
        trash    : "Toss trash",
        dog      : "Call dog",
        bowl     : "Fill bowl",
        sack     : "Get dog food",
        tub      : "Take a bath",
        sink     : "Brush teeth",
        lamp     : "Turn off lamp",
        fridge   : "Open fridge",
        plate    : "Get a plate",
        table    : "Sit and eat",
        bread    : "Get bread",
        toaster  : "Make toast",
        river    : "Drink",
        bush     : "Eat berries",
        grass    : "Nap",
        thorns   : "Walk through",
        hill     : "Climb and call",
        cave     : "Hide",
        shy      : "Sit together",
        group    : "Walk over"
    };
    if (variable_struct_exists(V, key)) return V[$ key];
    return "Use it";
}

/// @desc Every scenario, grouped by focus and ordered by tier.
function scenario_list(focus_key) {
    var tbl = scenario_all();
    if (variable_struct_exists(tbl, focus_key)) return tbl[$ focus_key];
    return [];
}

function scenario_all() {
    if (variable_global_exists("scenario_cache")) return global.scenario_cache;

    // word lists that come up again and again
    var W_GO    = ["go", "out", "outside", "leave", "left", "door", "school", "bus", "walk", "went"];

    global.scenario_cache = {

    // ================= LEVELS (Jenny's prediction-menu levels) =================
    // Dot test run (2026-11-08): one level each for sets A, B, C and D.
    // A "choice" level: the student picks one or both objects, in either order.
    // That makes four plans. Each plan has its own ending, and the four
    // guesses in the menu are those four endings (cause and effect).
    //   goal      : the situation.
    //   reminder  : shown on the intro card and kept on screen.
    //   describe  : what each object does (shown under it and while acting).
    //   predict   : the four endings in the menu, in plan order.
    //   outlier   : -1 = no outlier. Every guess is a real ending.
    //   endings   : one entry per plan. The key is the objects in order joined
    //               with "_". pick = which predict[] entry really happens,
    //               text = what the outcome screen says, gag = the visual joke.
    // Points: 2 for the guess that matches what happened, 0 otherwise
    // (see score_choice in scr_score).
    // The old fridge/bed, test, picture, movie and muddy levels were removed
    // for this test run; they are still in Git history.
    levels : [
        {
            key : "dot_a", tier : 1, mode : "choice",
            tier_name : "Level A", tier_kid : "Level A",
            goal     : "Dot is very thirsty.",
            reminder : "Think: what will each action cause?",
            spots    : ["river", "bush"],
            describe : {
                river : "Drink from the river.",
                bush : "Eat the sour berries."
            },
            predict : [
                "Dot's thirst goes away.",
                "Dot's mouth gets dry, and she is still thirsty.",
                "Dot's thirst goes away, then her mouth gets dry again.",
                "Dot's mouth gets dry, then her thirst goes away."
            ],
            outlier : -1,
            endings : {
                river : { pick : 0, gag : "cheer",
                    text : "Dot drinks from the river. Her thirst goes away." },
                bush : { pick : 1, gag : "wobble",
                    text : "Dot eats the sour berries. Her mouth gets dry, and she is still thirsty." },
                river_bush : { pick : 2, gag : "spin",
                    text : "Dot's thirst goes away. Then the sour berries make her mouth dry again." },
                bush_river : { pick : 3, gag : "cheer",
                    text : "The sour berries make Dot's mouth dry. Then she drinks, and her thirst goes away." }
            },
            obsess : "river",
            correct : [], step_words : [], lesson : "", win : "",
            fail : { incomplete : "" }
        },
        {
            key : "dot_b", tier : 2, mode : "choice",
            tier_name : "Level B", tier_kid : "Level B",
            goal     : "Dot is tired. Her nap spot is past a thorny bush.",
            reminder : "Think: what will each action cause?",
            spots    : ["grass", "thorns"],
            describe : {
                grass : "Nap in the soft grass.",
                thorns : "Walk through the thorns."
            },
            predict : [
                "Dot wakes up rested.",
                "Dot gets scratched, and she is still tired.",
                "Dot wakes up rested, then gets scratched.",
                "Dot gets scratched, then wakes up rested."
            ],
            outlier : -1,
            endings : {
                grass : { pick : 0, gag : "cheer",
                    text : "Dot naps in the soft grass. She wakes up rested." },
                thorns : { pick : 1, gag : "wobble",
                    text : "Dot walks through the thorns. She gets scratched, and she is still tired." },
                grass_thorns : { pick : 2, gag : "spin",
                    text : "Dot wakes up rested. Then she walks through the thorns and gets scratched." },
                thorns_grass : { pick : 3, gag : "wobble",
                    text : "Dot gets scratched. Then she naps and wakes up rested, but still scratched." }
            },
            obsess : "grass",
            correct : [], step_words : [], lesson : "", win : "",
            fail : { incomplete : "" }
        },
        {
            key : "dot_c", tier : 3, mode : "choice",
            tier_name : "Level C", tier_kid : "Level C",
            goal     : "Dot is lonely. Her herd is far away.",
            reminder : "Think: what will each action cause?",
            spots    : ["hill", "cave"],
            describe : {
                hill : "Climb the hill and call out.",
                cave : "Hide in the cave."
            },
            predict : [
                "The herd calls back, and Dot feels better.",
                "No one hears Dot, and she feels lonelier.",
                "The herd calls back, but then they can't find Dot.",
                "Dot feels lonelier, then the herd calls back."
            ],
            outlier : -1,
            endings : {
                hill : { pick : 0, gag : "cheer",
                    text : "Dot climbs the hill and calls. The herd calls back, and she feels better." },
                cave : { pick : 1, gag : "wobble",
                    text : "Dot hides in the cave. No one can hear her, and she feels lonelier." },
                hill_cave : { pick : 2, gag : "spin",
                    text : "The herd calls back. Then Dot hides in the cave, so they can't find her, and she feels lonely again." },
                cave_hill : { pick : 3, gag : "cheer",
                    text : "Dot feels lonelier in the cave. Then she climbs the hill and calls, and the herd calls back." }
            },
            obsess : "hill",
            correct : [], step_words : [], lesson : "", win : "",
            fail : { incomplete : "" }
        },
        {
            key : "dot_d", tier : 4, mode : "choice",
            tier_name : "Level D", tier_kid : "Level D",
            goal     : "A shy dino is sitting alone. A group is playing a game.",
            reminder : "Think: what will each action cause?",
            spots    : ["shy", "group"],
            describe : {
                shy : "Sit next to the shy dino.",
                group : "Walk over to the group."
            },
            predict : [
                "The shy dino smiles and stays by Dot.",
                "The group asks Dot to play. The shy dino is left alone.",
                "The group asks Dot and the shy dino to play.",
                "The shy dino smiles, but the game goes on without them."
            ],
            outlier : -1,
            endings : {
                shy : { pick : 0, gag : "cheer",
                    text : "Dot sits next to the shy dino. He smiles and stays by her side." },
                group : { pick : 1, gag : "wobble",
                    text : "Dot walks over to the group. They ask her to play, and the shy dino is left alone." },
                shy_group : { pick : 2, gag : "cheer",
                    text : "The shy dino stays by Dot's side. Then the group asks them both to play." },
                group_shy : { pick : 3, gag : "spin",
                    text : "The group asks Dot to play, and the shy dino is left alone. Then she sits with him, and he smiles, but the game goes on without them." }
            },
            obsess : "shy",
            correct : [], step_words : [], lesson : "", win : "",
            fail : { incomplete : "" }
        }
    ],


    // ================= SCHOOL =================
    school : [
        {
            key : "school_t1", tier : 1,
            tier_name : "Single-Focus Obsession", tier_kid : "One thing at a time",
            goal    : "Get ready for school.",
            lesson  : "Get dressed, take your bag, then go.",
            spots   : ["bed", "clothes", "backpack", "clock", "door"],
            correct : ["clothes", "backpack", "door"],
            step_words : [
                ["shirt", "clothes", "cloth", "dress", "dressed", "wear", "wore", "put on", "outfit", "change"],
                ["bag", "backpack", "pack", "packed", "book bag"],
                W_GO
            ],
            obsess : "clothes",
            win  : "You got dressed. You took your bag. You walked to school. You did it!",
            fail : {
                obsession   : "You put on eight shirts! You are a big red ball. You roll to school and bump the bus.",
                wrong_order : "You ran out the door in your pajamas! The bus stops and everyone waves at your bunny slippers.",
                overload    : "You grab the bed, the clock, and the bag all at once. You tip over like a turtle and spin.",
                incomplete  : "You get to school with no bag. Your work is still on your bed, taking a nap."
            }
        },
        {
            key : "school_t2", tier : 2,
            tier_name : "Wrong Order", tier_kid : "First, then next",
            goal    : "Do your school work.",
            lesson  : "Sit down, do the work, then put it in your bag.",
            spots   : ["tv", "desk", "paper", "backpack"],
            correct : ["desk", "paper", "backpack"],
            step_words : [
                ["desk", "sit", "sat", "chair", "table", "sit down"],
                ["work", "homework", "paper", "write", "wrote", "do it", "math", "read"],
                ["bag", "backpack", "pack", "put it in", "away"]
            ],
            obsess : "tv",
            win  : "You sat down. You did your work. You put it in your bag. All done!",
            fail : {
                obsession   : "You watch one hundred shows! Your eyes turn into tiny TVs and play cartoons.",
                wrong_order : "You put the paper in your bag first. It is still blank! Your teacher sees a big white page.",
                overload    : "You do work on the TV, the desk, and your knee. The pencil gets dizzy and snaps.",
                incomplete  : "You stop too soon. The work sits on the desk and starts to snore."
            }
        },
        {
            key : "school_t3", tier : 3,
            tier_name : "Simultaneous Overload", tier_kid : "One step, then one more",
            goal    : "The bell rings soon!",
            lesson  : "Shoes, lunch, bag, then out the door.",
            spots   : ["shoes", "lunchbox", "backpack", "clock", "tv", "door"],
            correct : ["shoes", "lunchbox", "backpack", "door"],
            step_words : [
                ["shoe", "shoes", "sneaker", "feet", "put on"],
                ["lunch", "lunchbox", "food", "snack", "eat"],
                ["bag", "backpack", "pack"],
                W_GO
            ],
            obsess : "clock",
            win  : "Shoes on. Lunch in hand. Bag on your back. Out the door. You made it!",
            fail : {
                obsession   : "You stare at the clock so long the hands get tired and lie down for a rest.",
                wrong_order : "You put your shoes on last, on your hands. You clap your way to school.",
                overload    : "You do it all at once! Lunch on your head, shoes on your ears. You spin and land in a bush.",
                incomplete  : "The bell rings. You are still at home with one shoe on."
            }
        }
    ],

    // ================= FRIENDS =================
    social : [
        {
            key : "social_t1", tier : 1,
            tier_name : "Single-Focus Obsession", tier_kid : "One thing at a time",
            goal    : "Say hi to a friend.",
            lesson  : "Say hi, then share the ball, then sit and talk.",
            spots   : ["friend", "ball", "bench", "teacher"],
            correct : ["friend", "ball", "bench"],
            step_words : [
                ["hi", "hello", "say", "said", "greet", "friend", "wave", "talk to"],
                ["ball", "share", "shared", "pass", "play", "throw", "toss"],
                ["sit", "sat", "bench", "talk", "talked", "chat", "rest"]
            ],
            obsess : "ball",
            win  : "You said hi. You shared the ball. You sat and talked. That is a good friend!",
            fail : {
                obsession   : "You bounce the ball fifty times. Your friend goes home. The ball is tired and asks for a nap.",
                wrong_order : "You sit on the bench first and stare. Your friend thinks you are a statue and puts a hat on you.",
                overload    : "You say hi, throw the ball, and sit down all at once. You land on the ball and roll away.",
                incomplete  : "You said hi and then stopped. Your friend waits and waits with the ball."
            }
        },
        {
            key : "social_t2", tier : 2,
            tier_name : "Wrong Order", tier_kid : "First, then next",
            goal    : "Play with your friend.",
            lesson  : "Ask first, then get the ball, then take turns.",
            spots   : ["friend", "ball", "swing", "teacher"],
            correct : ["friend", "ball", "swing"],
            step_words : [
                ["ask", "asked", "hi", "say", "friend", "can i play", "talk"],
                ["ball", "get", "got", "grab", "take", "pick up"],
                ["turn", "turns", "take turns", "swing", "share", "shared", "wait", "both"]
            ],
            obsess : "swing",
            win  : "You asked first. You got the ball. You took turns. Everybody had fun!",
            fail : {
                obsession   : "You swing for nine hours. You go so high a bird asks you for directions.",
                wrong_order : "You grab the ball before you ask. Your friend says, hey! The ball hides in a tree.",
                overload    : "You ask, grab, and swing at the same time. The swing throws you and the ball into the sky.",
                incomplete  : "You asked to play, then walked away. Your friend holds the ball and waits."
            }
        },
        {
            key : "social_t3", tier : 3,
            tier_name : "Simultaneous Overload", tier_kid : "One step, then one more",
            goal    : "Your friend got hurt.",
            lesson  : "Check your friend, get water, then tell a grown up.",
            spots   : ["friend", "cup", "teacher", "snack", "bench"],
            correct : ["friend", "cup", "teacher"],
            step_words : [
                ["friend", "check", "ask", "help", "hurt", "ok", "okay", "see"],
                ["water", "cup", "drink", "get water"],
                ["grown up", "grownup", "teacher", "adult", "tell", "told", "help", "grown"]
            ],
            obsess : "snack",
            win  : "You checked on your friend. You got water. You told a grown up. You are a big helper!",
            fail : {
                obsession   : "You bring twenty apples. Your friend is under an apple hill and waves one hand.",
                wrong_order : "You run for a grown up first and trip over the cup. Now two of you need help.",
                overload    : "You give water, food, and a hug all at once. The water goes up your nose and you sneeze a rainbow.",
                incomplete  : "You checked on your friend, then stopped. Nobody knows they need help."
            }
        }
    ],

    // ================= HOME =================
    home : [
        {
            key : "home_t1", tier : 1,
            tier_name : "Single-Focus Obsession", tier_kid : "One thing at a time",
            goal    : "Clean your room.",
            lesson  : "Toys away, clothes in the basket, trash in the can.",
            spots   : ["toys", "laundry", "trash", "tv", "lamp"],
            correct : ["toys", "laundry", "trash"],
            step_words : [
                ["toy", "toys", "block", "blocks", "clean", "tidy", "neat", "put away", "away", "pick up"],
                ["clothes", "shirt", "basket", "laundry", "wash", "hamper"],
                ["trash", "junk", "garbage", "toss", "throw", "bin", "can"]
            ],
            obsess : "toys",
            win  : "Toys away. Clothes in. Trash gone. Your room looks great!",
            fail : {
                obsession   : "You line up your toys forty times. Now the toys line YOU up, by size.",
                wrong_order : "You put trash in the toy box and toys in the trash. A robot dinosaur waves goodbye from the bin.",
                overload    : "You hold toys, clothes, and trash all at once. You become a big wobbly pile with feet.",
                incomplete  : "You did some of it. Half the room is clean and half is a mountain."
            }
        },
        {
            key : "home_t2", tier : 2,
            tier_name : "Wrong Order", tier_kid : "First, then next",
            goal    : "Feed the dog.",
            lesson  : "Get the food, fill the bowl, then call the dog.",
            spots   : ["sack", "bowl", "dog", "trash"],
            correct : ["sack", "bowl", "dog"],
            step_words : [
                ["food", "bag", "sack", "dog food", "get food", "scoop"],
                ["bowl", "fill", "filled", "pour", "dish", "put food in"],
                ["dog", "call", "called", "pet", "puppy", "feed", "eat"]
            ],
            obsess : "dog",
            win  : "You got the food. You filled the bowl. You called the dog. Happy dog!",
            fail : {
                obsession   : "You call the dog again and again. He brings twelve friends. Now there is a dog party.",
                wrong_order : "You call the dog first. He licks an empty bowl and gives you a very sad look.",
                overload    : "You pour food, call the dog, and hold the bowl all at once. Food rains down like snow.",
                incomplete  : "The bowl is still empty. The dog taps your leg with one paw."
            }
        },
        {
            key : "home_t3", tier : 3,
            tier_name : "Simultaneous Overload", tier_kid : "One step, then one more",
            goal    : "Time for bed.",
            lesson  : "Bath, teeth, lamp off, then bed.",
            spots   : ["tub", "sink", "lamp", "bed", "tv", "toys"],
            correct : ["tub", "sink", "lamp", "bed"],
            step_words : [
                ["bath", "tub", "wash", "washed", "clean", "soap"],
                ["teeth", "tooth", "brush", "brushed", "sink"],
                ["lamp", "light", "off", "turn off", "dark"],
                ["bed", "sleep", "slept", "nap", "lie down", "night"]
            ],
            obsess : "tv",
            win  : "Bath. Teeth. Lamp off. Bed. Good night!",
            fail : {
                obsession   : "You watch TV all night. In the morning your hair is shaped like a TV.",
                wrong_order : "You get in bed first, then take a bath. Now your bed is a pond with ducks.",
                overload    : "You brush your teeth in the bath with the lamp on your head. Bubbles fill the whole house.",
                incomplete  : "You stopped part way. You fall asleep with one sock and a wet ear."
            }
        }
    ],

    // ================= FOOD =================
    food : [
        {
            key : "food_t1", tier : 1,
            tier_name : "Single-Focus Obsession", tier_kid : "One thing at a time",
            goal    : "Make a snack.",
            lesson  : "Open the fridge, get a plate, then sit and eat.",
            spots   : ["fridge", "plate", "table", "trash"],
            correct : ["fridge", "plate", "table"],
            step_words : [
                ["fridge", "open", "opened", "food", "get food", "snack"],
                ["plate", "dish", "put it on", "get a plate"],
                ["table", "sit", "sat", "eat", "ate", "sit down", "chair"]
            ],
            obsess : "fridge",
            win  : "You got food. You used a plate. You sat and ate. Yum!",
            fail : {
                obsession   : "You open the fridge twenty times. It gets warm and the milk yells, stop it!",
                wrong_order : "You sit at the table with no food. You chew air for ten minutes.",
                overload    : "You hold food, a plate, and a cup all at once. Lunch takes off and lands on the cat.",
                incomplete  : "You got the food but never sat down. Crumbs go all over the floor."
            }
        },
        {
            key : "food_t2", tier : 2,
            tier_name : "Wrong Order", tier_kid : "First, then next",
            goal    : "Make toast.",
            lesson  : "Get the bread, toast it, then put it on a plate.",
            spots   : ["bread", "toaster", "plate", "cup"],
            correct : ["bread", "toaster", "plate"],
            step_words : [
                ["bread", "get bread", "slice", "loaf"],
                ["toast", "toaster", "cook", "cooked", "warm", "heat", "pop"],
                ["plate", "dish", "put it on", "eat", "ate"]
            ],
            obsess : "toaster",
            win  : "You got the bread. You made toast. You put it on a plate. Crunch!",
            fail : {
                obsession   : "You push the toaster button ten times. It makes one very black brick of toast.",
                wrong_order : "You put the plate in the toaster! It goes POP and the plate sticks to the roof.",
                overload    : "You toast bread, a cup, and your sleeve at once. The kitchen fills with silly smoke.",
                incomplete  : "Your toast pops up and sits there. It gets cold and hard as a rock."
            }
        },
        {
            key : "food_t3", tier : 3,
            tier_name : "Simultaneous Overload", tier_kid : "One step, then one more",
            goal    : "Clean up after you eat.",
            lesson  : "Plate to the sink, cup to the sink, wash, then trash.",
            spots   : ["plate", "cup", "sink", "trash", "table", "fridge"],
            correct : ["plate", "cup", "sink", "trash"],
            step_words : [
                ["plate", "dish", "pick up", "take", "carry"],
                ["cup", "glass", "drink"],
                ["sink", "wash", "washed", "clean", "water", "soap", "rinse"],
                ["trash", "garbage", "junk", "toss", "throw", "bin", "can"]
            ],
            obsess : "fridge",
            win  : "Plate in. Cup in. All washed. Trash gone. The kitchen is clean!",
            fail : {
                obsession   : "You open the fridge over and over. A carrot rolls out and says, are you lost?",
                wrong_order : "You wash the sink before the dishes. The plate watches and waits, still dirty.",
                overload    : "You wash the plate, the cup, and the chair at the same time. The sink makes a big bubble bear.",
                incomplete  : "You put some things in the sink. The rest sit on the table making a sticky puddle."
            }
        }
    ]

    };
    return global.scenario_cache;
}

/// @desc Look a scenario up by its key.
function scenario_by_key(key) {
    var tbl = scenario_all();
    var fkeys = variable_struct_get_names(tbl);
    for (var i = 0; i < array_length(fkeys); i++) {
        var list = tbl[$ fkeys[i]];
        for (var j = 0; j < array_length(list); j++) {
            if (list[j].key == key) return list[j];
        }
    }
    return undefined;
}

/// @desc Matches a typed word to a focus key. Returns "" when nothing fits.
function focus_from_text(txt) {
    var t = string_lower(str_trim(txt));
    if (t == "") return "";
    var fl = focus_list();
    // whole-word or close-enough match against each focus word list
    for (var i = 0; i < array_length(fl); i++) {
        if (string_lower(fl[i].label) == t || fl[i].key == t) return fl[i].key;
        var w = fl[i].words;
        for (var j = 0; j < array_length(w); j++) {
            if (t == w[j]) return fl[i].key;
        }
    }
    // then allow a partial match, so "schoolwork" still finds School
    for (var i = 0; i < array_length(fl); i++) {
        var w = fl[i].words;
        for (var j = 0; j < array_length(w); j++) {
            if (string_pos(w[j], t) > 0 || string_pos(t, w[j]) > 0) return fl[i].key;
        }
    }
    return "";
}
