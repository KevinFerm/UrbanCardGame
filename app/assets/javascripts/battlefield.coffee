socket = io('http://88.131.100.124:1337')
gameReady = true
starthand = false

allowDrop = (ev) ->
  ev.preventDefault()
  return

drag = (ev) ->
  ev.dataTransfer.setData 'text', ev.target.id
  return

drop = (ev) ->
  ev.preventDefault()
  data = ev.dataTransfer.getData('text')
  console.log document.getElementById('battlefield')
  socket.emit 'playCard', data
  return

$ ->
  if gameReady
    if gon.match
      match = $.parseJSON(gon.match)
      matchvar = {room: "Denatons Battle", id: match.id, playerid: 0}

      socket.on "drawhand", (data) ->
        starthand = true
        console.log "You have already started your hand once, can't do it again!"
      socket.on "draw", (data) ->
        console.log(data)

        for card in data.cards
            console.log(card.title)
            $('#hand').append '<img id="Card_' + card.title + '" src="http://placehold.it/50x100/aaaaaa&amp;text=[Card_' + card.title + ']" style="opacity: 0.9" draggable="true" ondragstart="drag(event)">'

      $(document).on 'click', '#draw-deck', ->
        socket.emit 'drawCard', matchvar

      socket.emit('create', { # Create set the game up for this player
        room: 'Denatons Battle',
        id: match.id, #id of the battle
        playerid: gon.playerid #id of the this player
      })
      if not starthand
        socket.emit 'start hand', matchvar

socket.on 'readyGame', ->
  gameReady = true
  return

socket.on 'drawCard', (card_id) ->
  $('#hand').append '<img id="Card_' + card_id + '" src="http://placehold.it/200x270/aaaaaa&amp;text=[Card_' + card_id + ']" style="opacity: 0.9" draggable="true" ondragstart="drag(event)">'
  return

socket.on 'playCard', (data) ->
  document.getElementById('battlefield').appendChild document.getElementById(data)
  return

