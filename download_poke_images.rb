require 'parallel'
require 'down'

Dir.mkdir './pokemon_images' unless File.directory?('./pokemon_images')

pokemon_numbers = []
(1..806).each{ |n| pokemon_numbers << n }

Parallel.each(pokemon_numbers, in_threads: 100, progress: 'Downloading Pokémon images') do |n|
  number = n.to_s.rjust(3, '0')
  temp_file = Down.open("https://assets.pokemon.com/assets/cms2/img/pokedex/full/#{number}.png")
  i = 1
  while temp_file.data[:status].to_i != 404
    if i == 1
      File.open("./pokemon_images/#{number}.png", 'w') {|f| f.write(temp_file.read) }
    else
      File.open("./pokemon_images/#{number}_f#{i}.png", 'w') {|f| f.write(temp_file.read) }
    end
    i += 1
    temp_file = Down.open("https://assets.pokemon.com/assets/cms2/img/pokedex/full/#{number}_f#{i}.png")
  end
rescue StandardError
end
