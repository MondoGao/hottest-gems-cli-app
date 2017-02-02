class HottestGems::Gem
  attr_reader :name, :version, :stars, :total_downloads, :version_downloads

  def initialize(name, url)
    @name = name
    @url = url
    @@all << self
  end

  def self.all
    @@all ||= scrape_list
  end

  def self.total_gems
    scrape_now_data(0)
  end

  def self.total_users
    scrape_now_data(1)
  end

  def self.total_downloads
    scrape_now_data(2)
  end

  def self.gem_at(index)
    self.all[index]
  end

  def version
    @version ||= scrape_data(".page__subheading")
  end

  def stars
    @stars ||= scrape_data(".gh-count")
  end

  def total_downloads
    @total_downloads ||= scrape_data(".gh-count")
  end

  def version_downloads
    @version_downloads ||= scrape_data(".gem__downloads")
  end

  private
  def self.scrape_list
    doc = Nokogiri::HTML(open('https://rubygems.org/stats'))
    doc.css(".stats__graph__gem__name a").each do |a|
      new(a.text.strip, "https://rubygems.org" + a.attribute("href").strip)
    end
    @@all
  end

  def self.scrape_now_data(index)
    Nokogiri::HTML(open('https://rubygems.org/stats')).css(".stat .stat__count")[index].text.strip
  end

  def scrape_data(css_selector)
    Nokogiri::HTML(open(@url)).css(css_selector)[0].text.strip
  end

end