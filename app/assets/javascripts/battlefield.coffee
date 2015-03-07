#socket = io('http://88.131.100.93:1337')
gameReady = true

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
    $('#draw-deck').click ->
      #socket.emit 'drawCard', 1
  socket.emit('create', { # Create set the game up for this player
    room: 'Denatons Battle',
    id: 1, #id of the battle
    playerid: 0 #id of the this player
  })

#socket.on 'readyGame', ->
#  gameReady = true
#  return
#
#socket.on 'drawCard', (card_id) ->
#  $('#hand').append '<img id="Card_' + card_id + '" src="http://placehold.it/200x270/aaaaaa&amp;text=[Card_' + card_id + ']" style="opacity: 0.9" draggable="true" ondragstart="drag(event)">'
#  return

#socket.on 'playCard', (data) ->
#  document.getElementById('battlefield').appendChild document.getElementById(data)
#  return



