class StaticPagesController < ApplicationController
  
  def home
    @account = current_user.accounts.build if logged_in?
    doc = Nokogiri::XML(open("http://feeds.bbci.co.uk/news/video_and_audio/business/rss.xml#"))
    results = doc.css('item')
    @news = []
    results.each do |result|
      new = { 'title': result.at_css('title').content,
              'description': result.at_css('description').content,
              'pubdate': result.at_css('pubDate').content,
              'link': result.at_css('link').content}
      @news << new
    end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
