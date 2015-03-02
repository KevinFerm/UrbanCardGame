class HomeController < ApplicationController
  def index
    ###Delete this later, adds everyone as admin!!
    if current_user
      user = User.find(current_user.id)
      user.update({admin:true})
      user.save!
    end
  end
end
