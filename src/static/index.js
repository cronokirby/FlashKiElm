var Elm = require('../elm/Main');
var container = document.getElementById('container');
var app = Elm.Main.embed(container, {
    deckEdit: {
        previous: [],
        current: { front: "", back: "" },
        rest: [],
        saved: {
            name: "",
            language: "",
            cards: [] },
        deckValidation: "" },
    deckList: {
         list: [{name: "101",
                 language: "German",
                 cards: [
                  {front : "Bazinga", back : "1" },
                  { front : "2", back : "2" }] },
               {name : "102", language : "German", cards : [] }] }, study : { current : { front : "Katze", back : "Katze" }, rest : [{ front : "Hund", back : "Hund" }], failed : [], deck : { name : "Vocabulaire allemand", language : "German", cards : [{ front : "Katze", back : "Katze" },{ front : "Hund", back : "Hund" }] }, input : "", cardTest : "None", redoing : true, redoStatus : "PartMatch" }
});
