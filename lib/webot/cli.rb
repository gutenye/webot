require "thor"

module Webot
  class CLI < Thor
    class_option "no-color",               banner: "Disable colorization in output", type: :boolean
    class_option "verbose", aliases: "-V", banner: "Enable verbose output mode", type: :boolean

    def initialize(*)
      super
      self.options = self.options.dup
      the_shell = (options["no-color"] ? Thor::Shell::Basic.new : shell)
      Webot.ui = UI::Shell.new(the_shell)
      Webot.ui.debug! if options["verbose"]
    end

    desc "bonus [site ..]", "bonus"
    def bonus(*sites)
      sites = sites.empty? ? Rc.sites : sites
      agent = Site.init_agent

      sites.each {|name|
        unless Site.has_site?(name)
          Webot.ui.error "SKIP: can't find site -- #{name}"
          next
        end

        Webot.ui.say "Performing #{name} ..."
        site = Site[name].new(agent)
        site.bonus
      }
    end
  end
end