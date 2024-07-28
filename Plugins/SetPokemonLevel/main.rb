# Fuerza el nivel máximo permitido
# si esta con el valor :party el nivel máximo es el del pokemon mas alto del equipo
# Si quieren que el nivel maximo este definido por el GameData::GrowthRate.max_level
# borren esta variable o modifiquen el valor
MAX_LEVEL_POSSIBLE = :party

module LevelSetter
  MenuHandlers.add(:set_level, :setter, {
    "name"      => _INTL("Elegir nivel"),
    "order"     => 10,
    "parent"    => :main,
    "effect"    => proc {  |level_setter|
      params = ChooseNumberParams.new
      party_max_level = level_setter.get_party_max_level
      if defined?(MAX_LEVEL_POSSIBLE) && MAX_LEVEL_POSSIBLE == :party
        max_range = party_max_level
      else
        max_range = GameData::GrowthRate.max_level
      end
      params.setRange(1, max_range)
      params.setDefaultValue(party_max_level)
      level = pbMessageChooseNumber(_INTL("Elige el nivel para {1} (máx. {2}).",
                                        level_setter.pokemon.name, params.maxNumber), params)
      level_setter.set_level(level)
    }
  })
  MenuHandlers.add(:set_level, :party_max_level, {
    "name"      => _INTL("Nivel máximo del equipo"),
    "order"     => 20,
    "parent"    => :main,
    "effect"    => proc {  |level_setter|
      level = level_setter.get_party_max_level
      level_setter.set_level(level)
    }
  })
  def pbLevelMenu(pokemon, screen)
    level_setter = Level.new(pokemon, screen)
    level_setter.show_submenus
  end

  class Level

    def initialize(pokemon, screen)
      @pokemon = pokemon
      @screen = screen
    end

    def show_submenus
      # Get all commands
      commands = CommandMenuList.new
      MenuHandlers.each_available(:set_level) do |option, hash, name|
        commands.add(option, hash, name)
      end
      # Main loop
      command = 0
      
      loop do
        command = @screen.scene.pbShowCommands(_INTL("¿Qué hacer con \n{1}?", @pokemon.name), commands.list, command)
        if command < 0
          parent = commands.getParent
          break if !parent
          echoln parent[0]
          commands.currentList = parent[0]
          command = parent[1]
        else
          cmd = commands.getCommand(command)
          if commands.hasSubMenu?(cmd)
            commands.currentList = cmd
            command = 0
          elsif MenuHandlers.call(:set_level, cmd, "effect", self)
            break
          end
        end
      end
    end

    def pokemon
      return @pokemon
    end
    def get_party_max_level
      max_level = 0
      $player.party.each do |pkmn|
        max_level = pkmn.level if pkmn.level > max_level
      end
      return max_level
    end

    def set_level(level)
      return if !level || level < 1
      if level > GameData::GrowthRate.max_level
        level = GameData::GrowthRate.max_level
      end
      pbChangeLevel(@pokemon, level, @screen)
    end
  end
end

MenuHandlers.add(:party_menu, :set_level, {
  "name"      => _INTL("Cambiar Nivel"),
  "order"     => 70,
  "condition" => proc { |screen, party, party_idx|
    next true if !party[party_idx].shadowPokemon?
  },
  "effect"    => proc { |screen, party, party_idx|
    pokemon = party[party_idx]
    screen.pbLevelMenu(pokemon, screen)
  }
})

class PokemonPartyScreen
  include LevelSetter
end