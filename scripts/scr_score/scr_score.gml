/// scr_score -- turns a click chain plus a typed prediction into XP.
///
/// THE RULES, IN ONE PLACE (this is the fix for the "partial credit" pitfall).
///
/// 1. Ordered steps
///    Compare the chain against the scenario's `correct` list position by
///    position, from the start. The run of steps that match from the front is
///    the "ordered run". A step out of position ends the run, so nothing after
///    a mistake can earn XP. Extra buttons are never in the run.
///
/// 2. One XP per predicted step
///    Each step in the ordered run earns 1 XP only if the written prediction
///    NAMES that step, using any word on that step's `step_words` list.
///    Different wording still counts, which is the partial credit the spec
///    asks for: "get dressed", "put on my shirt" and "wear clothes" all hit
///    the same step. Words not on any list are minor details and are ignored.
///
/// 3. Negation is respected
///    The prediction is cut into clauses at "and", "then", "but", commas and
///    full stops. If the clause that names a step also holds a negation word
///    ("not", "forgot", "never", "without"...), that step does NOT earn XP.
///
/// 4. Contradicting the outcome scores nothing
///    Only fires when the student actually wrote an ending:
///      - the scene ended WELL but the prediction used only bad-ending words
///        ("late", "mess", "nothing", "broke"), or
///      - the scene ended BADLY but the prediction used only good-ending words
///        ("works", "ready", "clean", "happy").
///    Then the whole attempt scores 0. A prediction that just lists the steps
///    without claiming an ending is never zeroed by this rule.
///
/// The returned struct carries a plain-words `why` line so a therapist can see
/// exactly which rule applied.

/// @desc Trim spaces from both ends.
function str_trim(s) {
    var a = 1, b = string_length(s);
    while (a <= b && string_char_at(s, a) == " ") a++;
    while (b >= a && string_char_at(s, b) == " ") b--;
    return (b < a) ? "" : string_copy(s, a, b - a + 1);
}

/// @desc Crude stem so "shoes" matches "shoe" and "washed" matches "wash".
function word_stem(w) {
    var n = string_length(w);
    if (n > 4 && string_copy(w, n - 2, 3) == "ing") return string_copy(w, 1, n - 3);
    if (n > 3 && string_copy(w, n - 1, 2) == "ed")  return string_copy(w, 1, n - 2);
    if (n > 3 && string_copy(w, n - 1, 2) == "es")  return string_copy(w, 1, n - 2);
    if (n > 3 && string_char_at(w, n) == "s")       return string_copy(w, 1, n - 1);
    return w;
}

#macro NEG_WORDS ["not","no","dont","didnt","doesnt","wont","cant","cannot","never","without","nothing","forgot","forget","skip","skipped","miss","missed","fail","failed"]
#macro BAD_END_WORDS ["late","mess","messy","nothing","wrong","bad","break","broke","broken","fall","fell","silly","crash","spill","spilled","stuck","sad","mad","angry","lost","hurt","trouble","yell","cry","dirty","boom","pop","explode"]
#macro GOOD_END_WORDS ["work","works","worked","good","great","nice","done","ready","clean","happy","fine","right","win","won","proud","perfect","ok","okay","yay","fun","fixed","help","helped","safe"]

/// @desc Breaks a typed prediction into the shape the matcher needs.
///       { text, words, stems, clauses } -- clauses are { text, words, stems, neg }
function pred_parse(txt) {
    // keep letters, numbers and spaces; turn everything else into a break mark
    var raw = string_lower(txt);
    var clean = "";
    for (var i = 1; i <= string_length(raw); i++) {
        var ch = string_char_at(raw, i);
        var ok = (ch >= "a" && ch <= "z") || (ch >= "0" && ch <= "9") || ch == " ";
        clean += ok ? ch : ((ch == "," || ch == "." || ch == "!" || ch == "?" || ch == ";") ? "|" : " ");
    }
    // clause breaks on joining words too
    clean = string_replace_all(clean, " and then ", "|");
    clean = string_replace_all(clean, " then ", "|");
    clean = string_replace_all(clean, " and ", "|");
    clean = string_replace_all(clean, " but ", "|");
    clean = string_replace_all(clean, " so ", "|");
    clean = string_replace_all(clean, " after ", "|");
    clean = string_replace_all(clean, " next ", "|");

    var whole_words = [], whole_stems = [];
    var clauses = [];
    var parts = string_split(clean, "|", true);
    for (var p = 0; p < array_length(parts); p++) {
        var ctext = str_trim(parts[p]);
        if (ctext == "") continue;
        var cw = [], cs = [];
        var toks = string_split(ctext, " ", true);
        for (var t = 0; t < array_length(toks); t++) {
            var w = str_trim(toks[t]);
            if (w == "") continue;
            array_push(cw, w);
            array_push(cs, word_stem(w));
            array_push(whole_words, w);
            array_push(whole_stems, word_stem(w));
        }
        var neg = false;
        var NW = NEG_WORDS;
        for (var i = 0; i < array_length(cw); i++) {
            for (var j = 0; j < array_length(NW); j++) {
                if (cw[i] == NW[j] || cs[i] == NW[j]) { neg = true; break; }
            }
            if (neg) break;
        }
        array_push(clauses, { text : ctext, words : cw, stems : cs, neg : neg });
    }

    return {
        text    : string_replace_all(clean, "|", " "),
        words   : whole_words,
        stems   : whole_stems,
        clauses : clauses
    };
}

/// @desc Does one clause use this term? Phrases are matched as text.
function clause_has_term(cl, term) {
    if (string_pos(" ", term) > 0) return (string_pos(term, cl.text) > 0);
    var st = word_stem(term);
    for (var i = 0; i < array_length(cl.words); i++) {
        if (cl.words[i] == term || cl.stems[i] == term || cl.stems[i] == st) return true;
    }
    return false;
}

/// @desc Is the step named anywhere in the prediction, in a clause with no "not"?
///       Returns: 1 named, 0 not named, -1 named but negated.
function pred_names_step(P, words) {
    var found_negated = false;
    for (var c = 0; c < array_length(P.clauses); c++) {
        var cl = P.clauses[c];
        for (var w = 0; w < array_length(words); w++) {
            if (clause_has_term(cl, words[w])) {
                if (!cl.neg) return 1;
                found_negated = true;
            }
        }
    }
    return found_negated ? -1 : 0;
}

/// @desc Counts words from a list that appear anywhere in the prediction.
function pred_count_any(P, list) {
    var n = 0;
    for (var i = 0; i < array_length(list); i++) {
        for (var c = 0; c < array_length(P.clauses); c++) {
            if (clause_has_term(P.clauses[c], list[i])) { n++; break; }
        }
    }
    return n;
}

/// @desc How many steps at the front of the chain sit in the correct position.
function ordered_run(chain, correct) {
    var n = min(array_length(chain), array_length(correct));
    var run = 0;
    for (var i = 0; i < n; i++) {
        if (chain[i] != correct[i]) break;
        run++;
    }
    return run;
}

/// @desc Scores one attempt.
/// @param {Struct} sc          the scenario
/// @param {Array} chain        the buttons the student pressed, in order
/// @param {String} prediction  what the student typed
/// @param {String} kind        outcome kind from classify_outcome (win / obsession / ...)
/// @returns {Struct} { xp, run, extra, credit, why, steps }
function score_attempt(sc, chain, prediction, kind) {
    var P       = pred_parse(prediction);
    var correct = sc.correct;
    var run     = ordered_run(chain, correct);
    var extra   = max(0, array_length(chain) - array_length(correct));

    // --- rule 2 + 3: one XP per ordered step the prediction names ---
    var xp = 0, named = 0, negated = 0;
    var steps = [];
    for (var i = 0; i < array_length(correct); i++) {
        var in_run = (i < run);
        var hit    = pred_names_step(P, sc.step_words[i]);
        var earned = (in_run && hit == 1) ? 1 : 0;
        xp += earned;
        if (hit ==  1) named++;
        if (hit == -1) negated++;
        array_push(steps, {
            step     : correct[i],
            in_order : in_run,
            told     : hit,
            xp       : earned
        });
    }

    // --- rule 4: an ending claim that fights what happened wipes the attempt ---
    var good_end = (kind == "win");
    var n_bad  = pred_count_any(P, BAD_END_WORDS);
    var n_good = pred_count_any(P, GOOD_END_WORDS);
    var contradicted = false;
    if (good_end  && n_bad  > 0 && n_good == 0) contradicted = true;
    if (!good_end && n_good > 0 && n_bad  == 0 && named >= array_length(correct)) contradicted = true;
    if (contradicted) xp = 0;

    // --- plain words for the log and the score screen ---
    var credit = "none";
    var why    = "";
    if (str_trim(prediction) == "") {
        credit = "none";
        why    = "No guess was typed, so no XP.";
    } else if (contradicted) {
        credit = "none";
        why    = good_end ? "The guess said it would go wrong, but it went right. No XP."
                          : "The guess said it would go right, but it went wrong. No XP.";
    } else if (xp > 0 && run == array_length(correct) && named >= array_length(correct)) {
        credit = "full";
        why    = "Right order and the guess told the whole plan. " + string(xp) + " XP.";
    } else if (xp > 0) {
        credit = "partial";
        why    = "Some steps were right and were in the guess. " + string(xp) + " XP.";
    } else if (run == 0) {
        credit = "none";
        why    = "The first step was not in the right spot, so no XP.";
    } else if (named == 0) {
        credit = "none";
        why    = "The steps were right, but the guess did not tell them. No XP.";
    } else {
        credit = "none";
        why    = "No step was both in the right spot and in the guess. No XP.";
    }
    if (extra > 0 && xp > 0) why += " Extra buttons earned nothing.";
    if (negated > 0 && xp == 0) why += " The guess said a step would NOT happen.";

    return {
        xp      : xp,
        run     : run,
        extra   : extra,
        credit  : credit,
        why     : why,
        steps   : steps,
        named   : named
    };
}

/// @desc Scores a "choice" level, where the guess is picked from a menu.
///       2 points: the guess is the ending that really happened.
///       1 point : wrong, but it was not the outlier.
///       0 points: the outlier (the ending that never fits).
/// @param {Struct} sc      the level
/// @param {Struct} ending  the ending that played (from sc.endings)
/// @param {Real} pick      index of the guess the student chose
/// @returns {Struct} { xp, credit, why, word }
function score_choice(sc, ending, pick) {
    if (pick == ending.pick) {
        return { xp : 2, credit : "full", word : "Guess matched",
                 why : "Your guess matched what happened. 2 points." };
    }
    if (pick == sc.outlier) {
        return { xp : 0, credit : "none", word : "Did not fit",
                 why : "That ending does not fit an EXTREME character. 0 points." };
    }
    return { xp : 1, credit : "partial", word : "Close",
             why : "Not what happened, but it could have. 1 point." };
}
