getDeckJSON = (deckname) ->
  return $.parseJSON(gon.decks)

$ ->
  $(document).on "click", "#startMatchMake", ->
    deckname = $(document).find("#deck_user").val()
    deck = getDeckJSON(deckname)
    deck = $.parseJSON(deck)
    console.log deck[deckname]
    array = {}
    array[deckname] = deck[deckname]
    $.ajax(
      type: 'POST'
      url: '/matches/matchmake'
      dataType: 'json'
      data: { match: {deck:array } }
    )
    console.log array