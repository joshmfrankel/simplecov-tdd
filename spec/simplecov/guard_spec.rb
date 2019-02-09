RSpec.describe Simplecov::Guard do
  it "has a version number" do
    expect(Simplecov::Guard::VERSION).not_to be nil
  end

  it "does something useful" do
    Simplecov::Formatter::Guard.send(:format, "hi")
    expect(false).to eq(true)
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
