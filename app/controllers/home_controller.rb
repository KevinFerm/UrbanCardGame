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
    else
      redirect_to new_user_session_path
    end
  end

end
