<h1>Dwarf Escape</h1>



// Setup for trenchbroom

1 \
get trenchbroom
https://github.com/TrenchBroom/TrenchBroom/releases

2 \
Open trenchbroom -> new map.. -> open preferences -> press little folder icon -> save the games location somewhere for now

Mine for example is ("/home/user/.TrenchBroom/games/")

3 \
Open godot and find a file named addons/func_godot/func_godot_local_config.tres \
double click it and you will see the config

in the trenchbroom game config folder field enter the location we got earlier.


4 \
find addons/func_godot/game_config/trenchbroom/func_godot_tb_game_config.tres and open it
Press the small checkbox next to the "export file".
(this adds the config for trenchbroom)

5 \
relaunch trenchbroom -> new map -> funcgodot \
entity browser -> press browse -> add funcgodot.fgd in the fgd folder. \
now you are able to add the entities

6 \

when saving map, save it in the trench_maps folder \
