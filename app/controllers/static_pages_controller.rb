class StaticPagesController < ApplicationController
  
  def home
    @account = current_user.accounts.build if logged_in?
    doc = Nokogiri::XML(open("http://feeds.bbci.co.uk/news/video_and_audio/business/rss.xml#"))
    results = doc.css('item')
    @news = []
    (0..results.count-1).each do |i|
      new = { 'title': results[i].at_css('title').content,
              'description': results[i].at_css('description').content,
              'pubdate': results[i].at_css('pubDate').content,
              'link': results[i].at_css('link').content,
              'img': results.xpath("//media:thumbnail")[i].attr('url')}
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
