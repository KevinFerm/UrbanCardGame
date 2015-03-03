/**
 * Created by Dennis on 2015-03-02.
 */
var io = require('socket.io')(1337);
var orm = require('orm');
var db = orm.connect('sqlite://../../../db/development.sqlite3');

var User = db.define('users', {
    email    : String,
    admin : String
});

User.get(4, function(err, user) {
    console.log( user.email );
})

io.on('connection', function(socket){
    console.log("User connected");

    // Join the battle Room
    socket.on('create', function(room) {
        console.log("User joined room " + room);
        socket.join(room);
        io.emit('join', "Joined Match");
    });

});

// Play card
function play(match){
    // Check card in hand
    // Check cost
    // Play card effect
    // Return success or fail
    io.to(match).emit('Play Card', {
        msg: 'Invalid target or attack'
    });
}

// Draw x Cards
function draw(match,x){
    x = typeof x !== 'undefined' ? x : 1; // Default value of draw a card is 1
    for(var i = 0; i < x; i++){
        // draw card
        // Return success or fail
        io.to(match).emit('Draw Card', {
            msg: 'Draw a card'
        });
    }
}

function shuffle(deck){
    for (i = 0; i < deck.length; i++) {
        k = Math.floor(Math.random() * deck.length);
        temp = deck[i];
        deck[i] = deck[k];
        deck[k] = temp;
    }
}