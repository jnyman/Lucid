module Lucid
  module AST
    class Comment #:nodoc:
      def initialize(value)
        @value = value
      end

      def empty?
        @value.nil? || @value == ""
      end

      def accept(visitor)
        return if Lucid.wants_to_quit
        @value.strip.split("\n").each do |line|
          visitor.visit_comment_line(line.strip)
        end
      end

      def to_sexp
        (@value.nil? || @value == '') ? nil : [:comment, @value]
      end
    end
  end
end
