RSpec.describe SimpleCov::Tdd do

  let(:formatter) { SimpleCov::Formatter::Tdd.new }
  let(:matched_90_filename) { "app/models/matched_90.rb" }
  let(:matched_90_filepath) { Dir.pwd + "/" + matched_90_filename }
  let(:matched_90_spec) { "spec/models/matched_90_spec.rb" }
  let(:matched_file_90_coverage) do
    instance_double(
      SimpleCov::SourceFile,
      filename: matched_90_filepath,
      covered_percent: 90.0,
      lines_of_code: 167,
      missed_lines: [
        instance_double(SimpleCov::SourceFile::Line, line_number: 5, src: "    obj.is_a?(SomeClass)"),
        instance_double(SimpleCov::SourceFile::Line, line_number: 25, src: "    SomeClass.explode!")
      ]
    )
  end
  let(:matched_100_filename) { Dir.pwd + "/app/models/matched_100.rb" }
  let(:matched_100_spec) { "spec/models/matched_100_spec.rb" }
  let(:matched_file_100_coverage) do
    instance_double(
      SimpleCov::SourceFile,
      filename: matched_100_filename,
      covered_percent: 100.0,
      lines_of_code: 53,
      missed_lines: []
    )
  end
  let(:unmatched_file) { instance_double(SimpleCov::SourceFile, filename: "spec/models/narp_spec.rb") }
  let(:matched_file_with_intersecting_filename) { "app/models/anotherspec_with_spec.rb" }
  let(:matched_file_with_intersecting_filepath) { Dir.pwd + "/" + matched_file_with_intersecting_filename }
  let(:matched_file_with_intersecting_spec) { "spec/models/anotherspec_with_spec_spec.rb" }
  let(:matched_file_with_intersecting_name_source_file) do
    instance_double(
      SimpleCov::SourceFile,
      filename: matched_file_with_intersecting_filepath,
      covered_percent: 100.0,
      lines_of_code: 53,
      missed_lines: []
    )
  end
  let(:simple_cov_result_stub) do
    instance_double(
      SimpleCov::Result,
      files: [matched_file_90_coverage, unmatched_file, matched_file_100_coverage, matched_file_with_intersecting_name_source_file]
    )
  end

  it "has a version number" do
    expect(SimpleCov::Tdd::VERSION).not_to be nil
  end

  describe "#format" do

    context "with an unmatched filename" do
      it "silently fails" do
        stub_const("ARGV", ["misc", "nope", "2", "spec/unfound_spec.rb"])

        expect {
          formatter.format(simple_cov_result_stub)
        }.not_to raise_error
      end

      context "and debug mode is enabled" do

        it "raises an Exception" do
          stub_const("ARGV", ["misc", "nope", "2", "spec/unfound_spec.rb"])
          SimpleCov::Formatter::Tdd.debug_mode = true

          expect {
            formatter.format(simple_cov_result_stub)
          }.to raise_error(StandardError)
        end
      end
    end

    context "with a matched filename" do

      context "without full 100% coverage" do
        it "displays the coverage overview" do
          stub_const("ARGV", ["misc", "nope", "2", matched_90_spec])

          expect {
            formatter.format(simple_cov_result_stub)
          }.to output(/#{matched_file_90_coverage.covered_percent}% coverage, #{matched_file_90_coverage.lines_of_code} total lines/).to_stdout
        end

        it "displays the missing line number overview" do
          stub_const("ARGV", ["misc", "nope", "2", matched_90_spec])

          expect {
            formatter.format(simple_cov_result_stub)
          }.to output(/The following #{matched_file_90_coverage.missed_lines.size} lines have missing coverage/).to_stdout
        end

        it "displays the specific missing line numbers" do
          stub_const("ARGV", ["misc", "nope", "2", matched_90_spec])
          line_number_array = matched_file_90_coverage.missed_lines.map(&:line_number)

          expect {
            formatter.format(simple_cov_result_stub)
          }.to output(/#{line_number_array}/).to_stdout
        end

        context "and output_style is :verbose" do

          it "displays the line numbers along with matching code" do
            stub_const("ARGV", ["misc", "nope", "2", matched_90_spec])
            SimpleCov::Formatter::Tdd.output_style = :verbose

            expect {
              formatter.format(simple_cov_result_stub)
            }.to output(
              /line \| source code\n-------------------\n#{matched_file_90_coverage.missed_lines.first.line_number} => #{Regexp.quote(matched_file_90_coverage.missed_lines.first.src.strip)}\n#{matched_file_90_coverage.missed_lines[1].line_number} => #{Regexp.quote(matched_file_90_coverage.missed_lines[1].src.strip)}\n/
            ).to_stdout
          end
        end
      end

      context "with full 100% coverage" do
        it "displays the coverage overview" do
          stub_const("ARGV", ["misc", "nope", "2", matched_100_spec])

          expect {
            formatter.format(simple_cov_result_stub)
          }.to output(/#{matched_file_100_coverage.covered_percent}% coverage, #{matched_file_100_coverage.lines_of_code} total lines/).to_stdout
        end

        it "does not display the missing line number overview" do
          stub_const("ARGV", ["misc", "nope", "2", matched_100_spec])

          expect {
            formatter.format(simple_cov_result_stub)
          }.not_to output(/lines have missing coverage/).to_stdout
        end
      end

      context "with different command line argument orders" do
        it "displays the matched filename when first argument" do
          stub_const("ARGV", [matched_90_spec, "misc", "nope", "2"])

          expect {
            formatter.format(simple_cov_result_stub)
          }.to output(/#{matched_90_filename}/).to_stdout
        end

        it "displays the matched filename when middle argument" do
          stub_const("ARGV", ["misc", matched_90_spec, "nope", "2"])

          expect {
            formatter.format(simple_cov_result_stub)
          }.to output(/#{matched_90_filename}/).to_stdout
        end

        it "displays the matched filename when last argument" do
          stub_const("ARGV", ["misc", "nope", "2", matched_90_spec])

          expect {
            formatter.format(simple_cov_result_stub)
          }.to output(/#{matched_90_filename}/).to_stdout
        end
      end

      context "when filename contains the phrase 'spec'" do

        it "displays the matched filename" do
          stub_const("ARGV", [matched_file_with_intersecting_spec, "misc", "nope", "2"])

          expect {
            formatter.format(simple_cov_result_stub)
          }.to output(/#{matched_file_with_intersecting_filename}/).to_stdout
        end
      end
    end
  end
end
