# Mahjong Pets
An open, ad free Mahjong Solitaire game (also known as Mahjong Titans), written in flutter.
The twist? Instead of Chinese symbols or paintings of dragons, it will be real images of pets.

## Build notes

The project only contains svg versions of the tilesets. They need to be
converted PNGs to use. Run "make generate-tiles" to generate
them.

You can additionally compact the generated files using the
"optimizeTilesets.sh" script.
