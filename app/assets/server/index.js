/**
 * Created by Dennis on 2015-03-02.
 */
var io = require('socket.io')(1337);
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database("../../../db/development.sqlite3");

/*
* Alla Emit som man tar emot ska ha id av vilken match det är som den sickas ifrån.
* Data variablen är information ifrån Client
*
* */

io.on('connection', function(socket){
    console.log("User connected");
    // Join the battle Room
    socket.on('create', function(data) {
        console.log("User joined room " + data.room);
        socket.join(data.room);
        //io.emit('join', "Joined Match");
        Shuffle(data);
        Draw(data,5);
    });

    socket.on('start hand', function(data) {
        Draw(data,5);
    });

});


// Match you with an opponent
function MatchMaking(){

}

// Play card
function Play(data){
    db.get("SELECT * FROM matches WHERE id='"+data.id+"'", function(err, match) {
        // Get Cards
        var players = JSON.parse(match.players);
        // Get the battlefield
        var battlefield = JSON.parse(match.battlefield);

        // Check card in hand
        for(var i = 0; i < players[data.playerid]['hand'].length; i++){
            var card = players[data.playerid]['hand'][i];
            if(data.cardid == card.id){
                // Check cost
                if(players[data.playerid].score >= card.cost){
                    // Pay the cost of the card
                    players[data.playerid].score -= card.cost;

                    // Play card effect if its is an event card, or if its a person we should check target building
                    switch(card.type){
                        case 'Event':
                            eval(GetFCardEffect(card));
                            battlefield[data.playerid].discard.push(card);
                            break;
                        case 'Person':
                            battlefield[data.playerid].battlefield[data.targetid].worker.push(card);
                            break;
                        case 'Building':
                            // Add card to the battlefield on your side
                            battlefield[data.playerid].battlefield.push(card);
                            break;
                    }

                    // Remove the card in your hand
                    players[data.playerid]['hand'].splice(i, 1);

                    // Update Battlefield and Hand
                    db.run("UPDATE matches SET battlefield = '"+JSON.stringify(battlefield)+"', players = '"+JSON.stringify(players)+"' WHERE id = '"+data.id+"'");

                    // Return success or fail

                    io.to(match).emit('Play Card', {
                        msg: 'Card Played'
                    });
                }
            }
            break;
        }
    });
}

// Draw x Cards
function Draw(data,x){
    x = typeof x !== 'undefined' ? x : 1; // Default value of draw a card is 1

    var cards = [];
    db.get("SELECT * FROM matches WHERE id='"+data.id+"'", function(err, match) {
        var deck = JSON.parse(match.decks);
        var players = JSON.parse(match.players); // To add cards onto tire hands
        var cards = [];
        for(var i = 0; i < x; i++){
            // draw card and add it to the hand
            players[data.playerid]['hand'].push(deck[data.playerid][0]);
            cards.push(deck[data.playerid][0]);
            // Remove the drawn card from the deck
            deck[data.playerid].shift();
        }

        // Update Hand with new cards
        io.to(data.room).emit('draw', {
            'cards': cards,
            'msg': "Drew " + x + " cards."
        });

        // Update Deck in DB
        db.run("UPDATE matches SET decks = '"+JSON.stringify(deck)+"', players = '"+JSON.stringify(players)+"' WHERE id = '"+data.id+"'");
    });
}

// Specify what card to draw
function StackDraw(data,n) {
    var card;
    db.get("SELECT * FROM matches WHERE id='"+data.id+"'", function(err, match) {
        var deck = JSON.parse(match.decks);
        if (n >= 0 && n < deck[data.playerid].length) {
            card = deck[data.playerid][n];
            deck[data.playerid].splice(n, 1);
        }
        else
            card = null;

        // Update Deck in DB here
        // Update Hand with new cards
    });
}

function Shuffle(data){
    db.get("SELECT decks FROM matches WHERE id='"+data.id+"'", function(err, match) {
        var deck = JSON.parse(match.decks);
        for(var q = 0; q < 5; q++)
        for (var i = 0; i < deck[data.playerid].length; i++) {
            var k = Math.floor(Math.random() * deck[data.playerid].length);
            var temp = deck[data.playerid][i];
            deck[data.playerid][i] = deck[data.playerid][k];
            deck[data.playerid][k] = temp;
        }
        // Update Deck
        db.run("UPDATE matches SET decks = '"+JSON.stringify(deck)+"' WHERE id = '"+data.id+"'");
        console.log("Updated Deck with Shuffles");
    });
}

function GetFCardEffect(card){
    // Str is the eval we are running based on card arguments and effect;
    var str = '';
    // For each effect on the card
    for(effect in card.effect) {
        // Add function start
        str += effect + '(';
        // For each argument on effect
        for(var l = 0; l < effect.length; l++){
            if(effect.last != effect[i]){
                // Add the arguments in the card to the function
                str += effect[i] + ',';
            }
            else{
                // If itsd is the last argument add the end of the function
                str += effect[i] + ');/n';;
            }
        }
    }
}

function GainPoints(){
    //Update points
}

function DestroyCard(){
    // Destroy the given card on the battlefield
}

function Discard(){
    // Selected player has selected a card in his hand and now we discard it.
}