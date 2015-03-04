/**
 * Created by Dennis on 2015-03-02.
 */
var io = require('socket.io')(1337);
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database("../../../db/development.sqlite3");

db.get("SELECT * FROM users", function(err, user) {
    console.log(user.id);
});

io.on('connection', function(socket){
    console.log("User connected");

    // Join the battle Room
    socket.on('create', function(room) {
        console.log("User joined room " + room);
        socket.join(room);
        io.emit('join', "Joined Match");
    });

});


// Match you with an opponent
function MatchMaking(){

}

// Play card
function Play(match){
    // Check card in hand
    // Check cost
    // Play card effect
    // Return success or fail
    io.to(match).emit('Play Card', {
        msg: 'Card Played'
    });
}

// Draw x Cards
function Draw(match,deck,x){
    x = typeof x !== 'undefined' ? x : 1; // Default value of draw a card is 1
    var cards = [];
    for(var i = 0; i < x; i++){
        // draw card
        // Return success or fail
        cards.append(deck[0]);
        deck.shift();
    }
    // Update Deck in DB here
    // Update Hand with new cards
}

// Specify what card to draw
function stackDraw(deck,n) {
    var card;

    if (n >= 0 && n < deck.length) {
        card = deck[n];
        deck.splice(n, 1);
    }
    else
        card = null;

    // Update Deck in DB here
    // Update Hand with new cards
}

function Shuffle(deck){
    for (i = 0; i < deck.length; i++) {
        k = Math.floor(Math.random() * deck.length);
        temp = deck[i];
        deck[i] = deck[k];
        deck[k] = temp;
    }
}