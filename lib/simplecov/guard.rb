require "simplecov"
require "simplecov/guard/version"

module Simplecov
  module Formatter
    class Guard
      attr_reader :result

      def format(coverage_results)
        @result = single_result(coverage_results)

        puts current_filename
        coverage_overview_text
        missed_line_numbers_message
      end

      private

      def current_filename
        @_current_filename ||= begin
          # @todo ARGV.last is brittle. Is there a regex that could help here?
          Dir.pwd + "/" + ARGV.last.sub("spec", "app").sub("_spec", "")
        end
      end

      def missed_line_numbers
        result.missed_lines.map(&:line_number)
      end

      def missed_line_numbers_message
        return if result.covered_percent == 100

        puts "\nThe following #{missed_line_numbers.size} lines have missing coverage: \n#{missed_line_numbers}"
      end

      def single_result(coverage_results)
        coverage_results.files.select { |file| file.filename == current_filename }[0]
      end

      def coverage_overview_text
        covered_percent = result.covered_percent.round(2)
        overview_text = "#{covered_percent}% coverage, #{result.lines_of_code} total lines"

        colorized_overview_text = if covered_percent > 85
          "\e[32m#{overview_text}\e[0m"
        elsif covered_percent > 65
          "\e[33m#{overview_text}\e[0m"
        else
          "\e[31m#{overview_text}\e[0m"
        end

        puts colorized_overview_text
      end
    end
  end
end
