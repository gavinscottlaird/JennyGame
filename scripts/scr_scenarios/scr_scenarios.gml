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
        toaster  : "Make toast"
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
