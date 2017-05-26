class StaticPagesController < ApplicationController
  
  def home
    @account = current_user.accounts.build if logged_in?
    @news = news_feed("http://www.scmp.com/rss/2/feed")
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
