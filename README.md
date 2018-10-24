# PokeGAN
Generative adversarial network for creating new Pokémon

## Downloading the images
You need ruby to download the images.

Install the required gems with `bundle install`

Then, `ruby utils/download_poke_images.rb`

## Selecting Pkémon subcategories
After the Pokémon images were downloaded, we can select which Pokémon we wish to
use for training. Run `ruby utils/generate_filtered_dataset.rb` to choose
pokémons with specific color, types and egg groups. the files will be copied to
`./training_data`. 
