require "spec_helper"

describe Ipsative::DIMENSIONS do
  it "should have 6 items" do
    expect(subject.size).to be(6)
  end

  described_class.each do |dimension|
    it "should have a name of the dimension" do
      expect(dimension).to respond_to(:name)
      expect(dimension.name).to respond_to(:empty?)
      expect(dimension.name.empty?).to be false
    end

    it "should have 10 answers in the #{dimension.name} dimension" do
      expect(dimension.answers.length).to be(10)
    end
  end
end
