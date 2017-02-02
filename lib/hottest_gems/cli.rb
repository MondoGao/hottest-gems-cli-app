class HottestGems::CLI
  def call
    main
  end

  def main
    print_list
    input = nil
    until input == "exit"
      puts ""
      puts "Which hottest gem do you want to meet?"
      puts ""
      puts "Enter list to see the gems again."
      puts "Enter exit to end the program."
      puts ""
      input = gets.strip
      if input == "list"
        print_list
      elsif input.to_i > 0
        HottestGems::Gem.gem_at(input.to_i - 1).print_details
      end
    end
  end

  def print_list
    puts ""
    puts "ALL TIME MOST DOWNLOADED".red
    puts ""
    HottestGems::Gem.all.each_with_index do |gem, i|
      puts "  #{i + 1}. #{gem.name.capitalize}".blue
      puts "    Total Downloads: #{gem.total_downloads}".red
    end
    puts ""
  end
end