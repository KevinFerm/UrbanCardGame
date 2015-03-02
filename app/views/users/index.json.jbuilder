json.array!(@users) do |user|
  json.extract! user, :id, :admin, :wins, :losses, :decks, :coins
  json.url user_url(user, format: :json)
end
