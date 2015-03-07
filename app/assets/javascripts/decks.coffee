deck = []

getCardNumber = (target) ->
  result = null
  for x,y in deck
    if x == target
      result++
  return result

getRemaining = ->
  len = 50
  count = deck.length
  left = len-count
  $(document).find("#count").html ''
  $(document).find("#count").append left.toString()




$ ->
  $(document).on "click", "#addCardToDeck", ->
    #alert $(this).attr("class")
    title = $(this).attr("class").split('_')
    deck.push(title[1])
    #console.log title[1]
    #console.log deck

    getRemaining()
    if deck.length <= 50
      if getCardNumber(title[1]) <= 4
        $(document).find("#deck").html ''
        $(document).find("#deck").append deck.toString()
        #console.log getCardNumber(title[1])
      else
        alert "Sorry, you can't have more than 4 of " + title[1]
    else
      alert "Sorry, you can only have max 40 cards in a deck"


$ ->
  $(document).on "click", "#submitDeck", ->
    ctitle = $(document).find("#deckTitle").val()
    cardlist = deck
    $.ajax(
      type: 'POST'
      url: '/newdeck'
      dataType: 'json'
      data: { newdeck: {title:ctitle, deck: cardlist } }
    )