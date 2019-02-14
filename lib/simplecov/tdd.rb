require "simplecov"
require "simplecov/tdd/version"

module Simplecov
  module Formatter
    class Tdd
      attr_reader :result

      def format(coverage_results, debug: false)
        @result = single_result(coverage_results)

        if result.nil?
          raise StandardError, "Could not find #{current_filename} as part of the SimpleCov::FileList results" if debug
          return
        end

        puts current_filename
        coverage_overview_text
        missed_line_numbers_message
      end

      private

      # From SimpleCov::FileList match the current_filename to a corresponding
      # coverage result
      def single_result(coverage_results)
        coverage_results.files.select { |file| file.filename == current_filename }[0]
      end

      # Infer the current_filename based on incoming ARGV command line
      # arguments and a matching spec type file
      def current_filename
        @_current_filename ||= begin
          # @todo Can we hook into Guard watched file? That would be more accurate
          # @TODO support for minitest

          argument_index = nil
          ARGV.each.with_index do |arg, index|
            if arg.match(/_spec.rb/)
              argument_index = index
              break
            end
          end

          if argument_index
            Dir.pwd + "/" + ARGV[argument_index].sub("spec", "app").sub("_spec", "")
          end
        end
      end

      # @todo tty support for colors
      def coverage_overview_text
        covered_percent = result.covered_percent.round(2)
        overview_text = "#{covered_percent}% coverage, #{result.lines_of_code} total lines"

        colorized_overview_text = if covered_percent > 85
          # Green
          "\e[32m#{overview_text}\e[0m"
        elsif covered_percent > 65
          # Orange
          "\e[33m#{overview_text}\e[0m"
        else
          # Red
          "\e[31m#{overview_text}\e[0m"
        end

        puts colorized_overview_text
      end

      def missed_line_numbers_message
        return if result.covered_percent == 100

        puts "\nThe following #{missed_line_numbers.size} lines have missing coverage: \n\e[31m#{missed_line_numbers}\e[0m"
      end

      def missed_line_numbers
        result.missed_lines.map(&:line_number)
      end
    end
  end
end
