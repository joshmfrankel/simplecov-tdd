RSpec.describe Simplecov::Guard do

  let(:formatter) { Simplecov::Formatter::Guard.new }
  let(:matched_filename) { Dir.pwd + "/app/models/matched.rb" }
  let(:matched_spec) { "spec/models/matched_spec.rb" }
  let(:matched_file_90_coverage) do
    instance_double(
      SimpleCov::SourceFile,
      filename: matched_filename,
      covered_percent: 90.0,
      lines_of_code: 167,
      missed_lines: [
        instance_double(SimpleCov::SourceFile::Line, line_number: 5),
        instance_double(SimpleCov::SourceFile::Line, line_number: 25)
      ]
    )
  end
  let(:unmatched_file) { instance_double(SimpleCov::SourceFile, filename: "spec/models/narp_spec.rb") }
  let(:simple_cov_result_stub) do
    instance_double(
      SimpleCov::Result,
      files: [matched_file_90_coverage, unmatched_file]
    )
  end

  it "has a version number" do
    expect(Simplecov::Guard::VERSION).not_to be nil
  end

  it "displays the matched filename" do
    stub_const("ARGV", ["misc", "nope", "2", matched_spec])

    expect {
      formatter.format(simple_cov_result_stub)
    }.to output(/#{matched_filename}/).to_stdout
  end

  it "displays the coverage overview" do
    stub_const("ARGV", ["misc", "nope", "2", matched_spec])

    expect {
      formatter.format(simple_cov_result_stub)
    }.to output(/90.0% coverage, 167 total lines/).to_stdout
  end

  # @todo 100% coverage
  # @todo green coverage
  # @todo brown coverage
  # @todo red coverage
  # @todo missing file coverage
  # @todo unable to infer filename coverage
  # @todo lib file path coverage
  # @todo app subdirectory file path coverage
  # @todo tty color coverage
end
