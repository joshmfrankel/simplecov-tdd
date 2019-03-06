require "simplecov"
require "simplecov/tdd/version"

module SimpleCov
  module Formatter

    # A SimpleCov formatter for generating single file results while using
    # test driven development principles
    class Tdd
      attr_reader :result

      # Hook into SimpleCov format by defining specific implementation
      # of #format for the TDD formatter
      def format(coverage_results)
        @result = single_result(coverage_results)

        # Is there a matching result?
        if result.nil?
          raise StandardError, "Could not find #{current_filename} as part of the SimpleCov::FileList results" if debug_mode
          return # Early return silently dies outside of debug mode
        end

        puts format_filename_for_output
        puts coverage_overview_text
        puts missed_line_numbers_message
      end

      # Class level attr_writer
      # @param style [Symbol] the symbol representation of the output_style
      #   accepted values are: [:simple, :verbose]
      def self.output_style=(style)
        @output_style = style
      end

      # Class level attr_reader
      def self.output_style
        @output_style
      end

      # Instance level method that defers to class_level variable when
      # set via configuration. The default output_style is :simple
      def output_style
        self.class.output_style || :simple
      end

      # Class level attr_writer
      # @param flag [Boolean] the current status (true/false) of debug mode
      def self.debug_mode=(flag)
        @debug_mode = flag
      end

      # Class level attr_reader
      def self.debug_mode
        @debug_mode
      end

      # Instance level method that defers to class_level variable when
      # set via configuration. The default debug_mode is false
      def debug_mode
        self.class.debug_mode || false
      end

      private

      # Match the current file against the SimpleCov::FileList results to determine
      # a matching test
      # @param coverage_results [SimpleCov::Result] the incoming results from running
      #   SimpleCov after tests
      def single_result(coverage_results)
        coverage_results.files.detect { |file| file.filename == current_filename }
      end

      # Infer the current_filename based on incoming ARGV command line
      # arguments and a matching spec type file
      def current_filename
        @_current_filename ||= begin
          # @TODO support for minitest
          argument_index = ARGV.find_index { |arg| arg.match(/_spec.rb/) }

          if argument_index
            Dir.pwd + "/" + ARGV[argument_index].sub("spec/", "app/").sub("_spec.rb", ".rb")
          end
        end
      end

      # Format the currently matched filename to be more human readable
      def format_filename_for_output
        "app/" + current_filename.split("/app/")[1]
      end

      # @todo tty support for colors
      def coverage_overview_text
        covered_percent = result.covered_percent.round(2)
        overview_text = "#{covered_percent}% coverage, #{result.lines_of_code} total lines"
        colorized_overview_text = overview_text

        if STDOUT.tty?
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
        end

        colorized_overview_text
      end

      # Display the missing line numbers in a summary message
      def missed_line_numbers_message
        return if result.covered_percent == 100

        "\nThe following #{missed_line_numbers.size} lines have missing coverage: \n\e[31m#{missed_line_numbers}\e[0m".tap do |output|
          output << missed_line_numbers_verbose_message
        end
      end

      # When output_style == :verbose, display a table that includes the
      # line number missing converage as well as the related code
      def missed_line_numbers_verbose_message
        return "" if output_style != :verbose

        "\nline | source code\n-------------------\n".tap do |output|
          result.missed_lines.each do |missed_line|
            output << missed_line.line_number.to_s + " => " + missed_line.src.strip + "\n"
          end
        end
      end

      def missed_line_numbers
        result.missed_lines.map(&:line_number)
      end
    end
  end
end
