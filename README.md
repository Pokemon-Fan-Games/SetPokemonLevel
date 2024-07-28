# Set Pokemon Level

## Descripción

Este Plugin agrega una nueva opción al menú del equipo del Pokémon, se puede elegir el nivel a mano o elegir directamente que tome el nivel del pokémon mas alto en el equipo.

![Menu](images/main.png)

![sub menu](images/sub.png)

![level menu](images/choose.png)

> [!NOTE]
> Con el release 1.0.1 se agregó el flag `MAX_LEVEL_POSSIBLE` para limitar el nivel maximo del pokémon al máximo del equipo, si este flag no existe o tiene un valor distinto de `:party` el nivel maximo se limitará al valor `max_level` del GameData::GrowthRate.
> Si tienen algun Plugin de Level Caps como LevelCapsEX que modifica el `GameData::GrowthRate.max_level`, el nivel maximo estará regido por los cambios de ese Plugin.

## Instalación

Solo hay que descargar el [zip](https://github.com/Pokemon-Fan-Games/SetPokemonLevel/releases/download/v1.0.2/SetPokemonLevel.zip) del release y extraerlo en la carpeta de su juego.
