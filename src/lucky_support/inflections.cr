module LuckySupport
  module Inflector
    extend self

    # TODO: this class needs work to better support adding inflections at runtime, many methods are still missin here.
    # TODO: this needs a propoer spec
    class Inflections
      getter :plurals, :singulars, :uncountables, :humans, :acronyms, :acronym_regex
      @regex_array : Array(Regex)

      def initialize
        @plurals = {
          # irregulars
          /(z)ombies$/i => "\\1ombies",
          /(z)ombie$/i => "\\1ombies",
          /(m)oves$/i => "\\1oves",
          /(m)ove$/i => "\\1oves",
          /(s)exes$/i => "\\1exes",
          /(s)ex$/i => "\\1exes",
          /(c)hildren$/i => "\\1hildren",
          /(c)hild$/i => "\\1hildren",
          /(m)en$/i => "\\1en",
          /(m)an$/i => "\\1en",
          /(p)eople$/i => "\\1eople",
          /(p)erson$/i => "\\1eople",

          # plurals
          /(quiz)$/i => "\\1zes",
          /^(oxen)$/i => "\\1",
          /^(ox)$/i => "\\1en",
          /^(m|l)ice$/i => "\\1ice",
          /^(m|l)ouse$/i => "\\1ice",
          /(matr|vert|ind)(?:ix|ex)$/i => "\\1ices",
          /(x|ch|ss|sh)$/i => "\\1es",
          /([^aeiouy]|qu)y$/i => "\\1ies",
          /(hive)$/i => "\\1s",
          /(?:([^f])fe|([lr])f)$/i => "\\1\\2ves",
          /sis$/i => "ses",
          /([ti])a$/i => "\\1a",
          /([ti])um$/i => "\\1a",
          /(buffal|tomat)o$/i => "\\1oes",
          /(bu)s$/i => "\\1ses",
          /(alias|status)$/i => "\\1es",
          /(octop|vir)i$/i => "\\1i",
          /(octop|vir)us$/i => "\\1i",
          /^(ax|test)is$/i => "\\1es",
          /s$/i => "s",
          /$/ => "s"
        }

        @singulars = {
          # irregulars
          /(z)ombies$/i => "\\1ombie",
          /(z)ombie$/i => "\\1ombie",
          /(m)oves$/i => "\\1ove",
          /(m)ove$/i => "\\1ove",
          /(s)exes$/i => "\\1ex",
          /(s)ex$/i => "\\1ex",
          /(c)hildren$/i => "\\1hild",
          /(c)hild$/i => "\\1hild",
          /(m)en$/i => "\\1an",
          /(m)an$/i => "\\1an",
          /(p)eople$/i => "\\1erson",
          /(p)erson$/i => "\\1erson",
          /(database)s$/i => "\\1",

          #singulars
          /(database)s$/i => "\\1",
          /(quiz)zes$/i => "\\1",
          /(matr)ices$/i => "\\1ix",
          /(vert|ind)ices$/i => "\\1ex",
          /^(ox)en/i => "\\1",
          /(alias|status)(es)?$/i => "\\1",
          /(octop|vir)(us|i)$/i => "\\1us",
          /^(a)x[ie]s$/i => "\\1xis",
          /(cris|test)(is|es)$/i => "\\1is",
          /(shoe)s$/i => "\\1",
          /(o)es$/i => "\\1",
          /(bus)(es)?$/i => "\\1",
          /^(m|l)ice$/i => "\\1ouse",
          /(x|ch|ss|sh)es$/i => "\\1",
          /(m)ovies$/i => "\\1ovie",
          /(s)eries$/i => "\\1eries",
          /([^aeiouy]|qu)ies$/i => "\\1y",
          /([lr])ves$/i => "\\1f",
          /(tive)s$/i => "\\1",
          /(hive)s$/i => "\\1",
          /([^f])ves$/i => "\\1fe",
          /(^analy)(sis|ses)$/i => "\\1sis",
          /((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)(sis|ses)$/i => "\\1sis",
          /([ti])a$/i => "\\1um",
          /(n)ews$/i => "\\1ews",
          /(ss)$/i => "\\1",
          /s$/i => ""
        }

        @uncountables = %w(equipment information rice money species series fish sheep jeans police)
        @regex_array = @uncountables.flatten.map{ |word| to_regex(word.downcase) }

        @humans = Array(String).new
        @acronyms = Hash(String, String).new
        @acronym_regex = /(?=a)b/
      end

      def uncountable?(str)
        @regex_array.any? { |regex| regex.match(str) }
      end

      private def to_regex(string)
        /\b#{::Regex.escape(string)}\Z/i
      end

      def acronym(word)
        @acronyms[word.downcase] = word
        @acronym_regex = /#{acronyms.values.join("|")}/
      end
    end

    @@inflections = Inflections.new
    def inflections
      @@inflections
    end
  end
end