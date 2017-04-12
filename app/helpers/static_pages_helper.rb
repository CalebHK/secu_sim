module StaticPagesHelper
  
  def news_feed(url)
    # create news feed from scmp
    doc = Nokogiri::XML(open(url))
    results = doc.css('item')
    news = []
    (0..results.count-1).each do |i|
      new = {}
      new[:title] = results[i].at_css('title') ? results[i].at_css('title').content : "No Title"
      new[:description] = results[i].at_css('description') ? results[i].at_css('description').content : "No Description"
      new[:pubdate] = results[i].at_css('pubDate') ? results[i].at_css('pubDate').content : "No publish date"
      new[:link] = results[i].at_css('link') ? results[i].at_css('link').content : root_url
      new[:img] = results[i].at_css('media|content') ? results[i].at_css('media|content').attr('url') : "#"
      news << new
    end
    news
  end
end
