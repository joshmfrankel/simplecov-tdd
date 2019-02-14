RSpec.describe Simplecov::Tdd do

  let(:formatter) { Simplecov::Formatter::Tdd.new }
  let(:matched_90_filename) { Dir.pwd + "/app/models/matched_90.rb" }
  let(:matched_90_spec) { "spec/models/matched_90_spec.rb" }
  let(:matched_file_90_coverage) do
    instance_double(
      SimpleCov::SourceFile,
      filename: matched_90_filename,
      covered_percent: 90.0,
      lines_of_code: 167,
      missed_lines: [
        instance_double(SimpleCov::SourceFile::Line, line_number: 5),
        instance_double(SimpleCov::SourceFile::Line, line_number: 25)
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
  let(:simple_cov_result_stub) do
    instance_double(
      SimpleCov::Result,
      files: [matched_file_90_coverage, unmatched_file, matched_file_100_coverage]
    )
  end

  it "has a version number" do
    expect(Simplecov::Tdd::VERSION).not_to be nil
  end

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

        expect {
          formatter.format(simple_cov_result_stub, debug: true)
        }.to raise_error(StandardError)
      end
    end
  end

  context "with a matched filename" do

    context "and without full coverage" do

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
    end

    context "and with full coverage" do
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
  end

  # @todo green coverage
  # @todo brown coverage
  # @todo red coverage
  # @todo tty color coverage
end
