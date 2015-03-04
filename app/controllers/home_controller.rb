class HomeController < ApplicationController
  def index
    ###Delete this later, adds everyone as admin!!
    if current_user
      user = User.find(current_user.id)
      user.update({admin:true})
      user.save!
    end
  end

  def decks
    if current_user
      @user = User.find(current_user.id)
      gon.decks = @user.decks
      @cards = Card.all
    else
      redirect_to new_user_session_path
    end
  end

  def newdeck
    if current_user
      @user = User.find(current_user.id)
      deck = deck_params[:deck].split(',')
      decks = JSON.parse(@user.decks)
      if not decks
        decks = {}
      end
      decks[deck_params[:title]] = deck[0]
      if @user.update({decks:decks.to_json})
        render nothing:true
        puts "Updated shizz plxxxxx"
      end



    end
  end

  private
  def deck_params
    params.require(:newdeck).permit!
  end

end
