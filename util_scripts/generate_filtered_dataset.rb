require 'csv'
require 'fileutils'
require 'byebug'
def inserter_helper(hash, key, content)
  return if key.nil?
  hash[key] = [] unless hash.has_key?(key)
  hash[key] << content
end

data_hash = {
  'color' => {},
  'type_1' => {},
  'type_2' => {},
  'egg_group_1' => {},
  'egg_group_2' => {},
}
all_full = []
all_mini = []

CSV.foreach('./poke_data.csv', headers: true) do |row|
  pokemon = {
    'full' => row['big_image'],
    'mini' => row['miniature']
  }

  all_full << row['big_image']
  all_mini << row['miniature']

  inserter_helper(data_hash['type_1'], row['type_1'], pokemon)
  inserter_helper(data_hash['type_2'], row['type_2'], pokemon)
  inserter_helper(data_hash['egg_group_1'], row['egg_group_1'], pokemon)
  inserter_helper(data_hash['egg_group_2'], row['egg_group_2'], pokemon)
  inserter_helper(data_hash['color'], row['color'], pokemon)
end

puts 'Statistics:'
puts 'Color:'
data_hash['color'].keys.each do |color|
  puts "#{color} - #{data_hash['color'][color].size}"
end
puts

puts 'Type 1:'
data_hash['type_1'].keys.each do |type_1|
  puts "#{type_1} - #{data_hash['type_1'][type_1].size}"
end
puts

puts 'Type 2:'
data_hash['type_2'].keys.each do |type_2|
  puts "#{type_2} - #{data_hash['type_2'][type_2].size}"
end
puts

puts 'Egg Group 1:'
data_hash['egg_group_1'].keys.each do |egg_group_1|
  puts "#{egg_group_1} - #{data_hash['egg_group_1'][egg_group_1].size}"
end
puts

puts 'Egg Group 2:'
data_hash['egg_group_2'].keys.each do |egg_group_2|
  puts "#{egg_group_2} - #{data_hash['egg_group_2'][egg_group_2].size}"
end
puts
puts

puts 'Current data in training_data directory will be erased if you continue.'
puts
FileUtils.rm_rf('./training_data') if File.exist?('./training_data')
FileUtils.mkdir('./training_data')

puts 'Do you wish to use full-sized images or miniatures? (f/m)'
type = gets.chomp
type = 'full' if type == 'f'
type = 'mini' if type == 'm'

puts 'Type the colors you wish (blank for all)'
colors = gets.chomp.split(' ')

puts 'Type the type 1 you wish (blank for all)'
type_1 = gets.chomp.split(' ')

puts 'Type the type 2 you wish (blank for all)'
type_2 = gets.chomp.split(' ')

puts 'Type the egg group 1 you wish (blank for all)'
egg_group_1 = gets.chomp.split(' ')

puts 'Type the egg group 2 you wish (blank for all)'
egg_group_2 = gets.chomp.split(' ')


### REAL CODE

if colors.empty?
  color_images_list = all_full if type == 'full'
  color_images_list = all_mini if type == 'mini'
else
  color_images_list = []
  colors.each do |color|
    color_images_list.concat(data_hash['color'][color.capitalize].map{|h| h[type]})
  end
end

if type_1.empty?
  type_1_list = all_full if type == 'full'
  type_1_list = all_mini if type == 'mini'
else
  type_1_list = []
  type_1.each do |type_1|
    type_1_list.concat(data_hash['type_1'][type_1.capitalize].map{|h| h[type]})
  end
end

if type_2.empty?
  type_2_list = all_full if type == 'full'
  type_2_list = all_mini if type == 'mini'
else
  type_2_list = []
  type_2.each do |type_1|
    type_2_list.concat(data_hash['type_2'][type_2.capitalize].map{|h| h[type]})
  end
end

if egg_group_1.empty?
  egg_group_1_list = all_full if type == 'full'
  egg_group_1_list = all_mini if type == 'mini'
else
  egg_group_1_list = []
  egg_group_1.each do |type_1|
    egg_group_1_list.concat(data_hash['egg_group_1'][egg_group_1.capitalize].map{|h| h[type]})
  end
end

if egg_group_2.empty?
  egg_group_2_list = all_full if type == 'full'
  egg_group_2_list = all_mini if type == 'mini'
else
  egg_group_2_list = []
  egg_group_2.each do |type_1|
    egg_group_2_list.concat(data_hash['egg_group_2'][egg_group_2.capitalize].map{|h| h[type]})
  end
end

intersection = color_images_list & type_1_list & type_2_list & egg_group_1_list & egg_group_2_list

puts "#{intersection.size} images will be copied to /training_data"
intersection.each do |file|
  FileUtils.cp("./pokemon_#{type}_images/#{file}","./training_data/#{file}")
end
