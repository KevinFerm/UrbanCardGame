json.array!(@cards) do |card|
  json.extract! card, :id, :title, :img, :desc, :cost, :type, :start, :upkeep, :downkeep, :main, :end
  json.url card_url(card, format: :json)
end
