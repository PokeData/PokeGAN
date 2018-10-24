require 'byebug'
require 'csv'
require 'down'
require 'nokogiri'
require 'open-uri'
require 'parallel'
require 'ruby-progressbar'

Dir.mkdir './pokemon_full_images' unless File.directory?('./pokemon_full_images')
Dir.mkdir './pokemon_mini_images' unless File.directory?('./pokemon_mini_images')

pokemon_numbers = []
(1..807).each{ |n| pokemon_numbers << n }

# Downloads the images
Parallel.each(pokemon_numbers, in_threads: 100, progress: 'Downloading Pokémon images') do |n|
  begin
    number = n.to_s.rjust(3, '0')
    temp_file = Down.open("https://assets.pokemon.com/assets/cms2/img/pokedex/full/#{number}.png")
    i = 1
    while temp_file.data[:status].to_i != 404
      if i == 1
        File.open("./pokemon_full_images/#{number}.png", 'w') {|f| f.write(temp_file.read) }
      else
        File.open("./pokemon_full_images/#{number}_f#{i}.png", 'w') {|f| f.write(temp_file.read) }
      end
      i += 1
      temp_file = Down.open("https://assets.pokemon.com/assets/cms2/img/pokedex/full/#{number}_f#{i}.png")
    end
  rescue StandardError
  end
end

# Scrape Pokémon data, resulting in Pokémon typing and breeding class
# After generated once, manual revision is needed, to fix some Pokémon
# particularities.
csv_exists = File.file?('poke_data.csv')
# This URL contains all we need.
html = open('https://veekun.com/dex/pokemon/search?sort=id&introduced_in=1&introduced_in=2&introduced_in=3&introduced_in=4&introduced_in=5&introduced_in=6&introduced_in=7&format=%24icon%24id%7C%24name%7C%24type1%7C%24type2%7C%24egg_group1%7C%24egg_group2%7C%24color&column=id&column=icon&column=name&column=type&column=egg_group&column=color&display=custom-list')
div = Nokogiri::HTML(html, nil, Encoding::UTF_8.to_s).xpath('//*[@id="content"]/div')
poke_div_list = div.search('a')
CSV.open("poke_data.csv", "wb", encoding: 'UTF-8') do |csv|
  csv << ['number', 'name', 'type_1', 'type_2', 'egg_group_1', 'egg_group_2', 'color', 'big_image', 'miniature'] unless csv_exists
  Parallel.each(poke_div_list, in_threads: 100, progress: 'Downloading Pokémon miniatures') do |entry|
    data = entry.text.split('|')
    img_url = entry.search('img')[0].attr('src')
    data << "#{data[0].to_s.rjust(3, '0')}.png"
    data << img_url[/(\d.*)\.png/]
    csv << data.map{|i| i == '' ? nil : i} unless csv_exists
    Down.download("https://veekun.com#{img_url}", destination: "./pokemon_mini_images/#{data[-1]}")
  end
end
