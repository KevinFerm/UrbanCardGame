json.array!(@matches) do |match|
  json.extract! match, :id, :title, :active, :players, :max_players, :turn, :phase, :decks, :stats, :battlefield, :triggers
  json.url match_url(match, format: :json)
end
