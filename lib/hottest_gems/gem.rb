class HottestGems::Gem
  attr_reader :name, :version, :total_downloads, :version_downloads

  def initialize(name, url)
    @name = name
    @url = url
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

  def print_details
    puts ""
    puts "Name: #{self.name}"
    puts "  Version: #{self.version}"
    puts "  Total Downloads: #{self.total_downloads}"
    puts "  Version Downloads: #{self.version_downloads}"
    puts ""
  end

  def version
    @version ||= scrape_data(".page__subheading")
  end

  def total_downloads
    @total_downloads ||= scrape_data(".gem__downloads")
  end

  def version_downloads
    @version_downloads ||= scrape_data(".gem__downloads", 1)
  end

  private
  def self.scrape_list
    doc = Nokogiri::HTML(open('https://rubygems.org/stats', ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
    doc.css(".stats__graph__gem__name a").collect do |a|
      new(a.text.strip, "https://rubygems.org" + a.attribute("href").value.strip)
    end
  end

  def self.scrape_now_data(index)
    Nokogiri::HTML(open('https://rubygems.org/stats', ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)).css(".stat .stat__count")[index].text.strip
  end

  def scrape_data(css_selector, index = 0)
    Nokogiri::HTML(open(@url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)).css(css_selector)[index].text.strip
  end

end