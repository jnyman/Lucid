require 'gherkin/formatter/argument'

module Lucid
  module InterfaceRb
    class RegexpArgumentMatcher
      def self.arguments_from(regexp, step_name)
        match = regexp.match(step_name)
        if match
          n = 0
          match.captures.map do |val|
            n += 1
            offset = match.offset(n)[0]
            Gherkin::Formatter::Argument.new(offset, val)
          end
        else
          nil
        end
      end
    end
  end
end
