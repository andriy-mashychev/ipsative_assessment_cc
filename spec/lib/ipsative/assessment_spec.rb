require "spec_helper"

describe Ipsative::Assessment do
  let(:all_answers) do
    Ipsative::DIMENSIONS.each_with_object([]) do |dimension, obj|
      dimension.answers.each { |dimension_answer| obj << dimension_answer }
    end
  end
  let(:answers_counter) { all_answers.to_h { |answer| [ answer, 0 ] } }

  before :each do
    allow(STDIN).to receive(:getch).and_return(
      *Array.new(30) { |index| index.odd? ? "1" : "2" }
    )
    allow(STDOUT).to receive(:puts)
  end

  it "should have 30 questions" do
    expect(subject).to receive(:print_question).exactly(30).times
    expect(STDIN).to receive(:getch).exactly(30).times

    subject.conduct
  end

  it "should not show the same answer twice" do
    allow(subject).to receive(:print_question) do | arguments |
      answers_counter[arguments.fetch(:first_answer)] += 1
      answers_counter[arguments.fetch(:second_answer)] += 1

      expect(answers_counter[arguments.fetch(:first_answer)]).to eql(1)
      expect(answers_counter[arguments.fetch(:second_answer)]).to eql(1)
    end.at_least(30).times

    subject.conduct
  end

  it "should match each dimension to the other dimensions exactly 2 times" do
    subject.random_pairs_of_dimensions.each do |dimensions_match|
      count_of_matches = subject.random_pairs_of_dimensions.count do |two_dimensions|
        two_dimensions.sort == dimensions_match.sort
      end
      expect(count_of_matches).to eql(2)
    end
  end

  it "randomizes the order in which the questions appear" do
    allow(Random).to receive(:new).and_return(Random.new(42))

    expect(subject).to receive(:print_question).with(
      first_answer: "I notice mistakes quickly",
      second_answer: "I am supportive"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I set clear goals",
      second_answer: "I am fast moving"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I highly value customer feedback",
      second_answer: "I am achievement oriented"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I can sometimes be aggresive",
      second_answer: "I work in collaboration with others"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I always tell the truth",
      second_answer: "I respond promptly to clients"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I always try to do the right thing",
      second_answer: "I am analytical"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I put emphasis on quality",
      second_answer: "I am ambitious"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I am customer oriented",
      second_answer: "I am careful"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I share responsibilities",
      second_answer: "I have high expectations for performance"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I am a curious person",
      second_answer: "I have high ethical standards"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I don't like to be constrained by rules",
      second_answer: "I am precise"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I am action oriented",
      second_answer: "I am fair"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I am trustworthy",
      second_answer: "I welcome change"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I am always happy to share knowledge",
      second_answer: "I work to satisfy our customers"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I avoid conflicts",
      second_answer: "I have a high sense of integrity"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I always put customer needs first",
      second_answer: "I am cooperative"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I am quick to take advantage of opportunities",
      second_answer: "I am a good communicator"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I take risks",
      second_answer: "I focus on the outcome, rather than the process"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I am accurate in my work",
      second_answer: "I am flexible"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I am willing to experiment",
      second_answer: "I watch the markets carefully"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I base my decisions on what our customers need & want",
      second_answer: "I respect individuals"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I focus on rules",
      second_answer: "I lead by example"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I reach my goals",
      second_answer: "I put the customer's requirements ahead of anything else"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I am good at understanding cause-and-effect relationships",
      second_answer: "I value our clients"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I listen to customers",
      second_answer: "I adjust easily to changing environments"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I am honest",
      second_answer: "I am good at identifying effective processes"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I am team oriented",
      second_answer: "I am innovative"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I am always available to help out a colleague in need",
      second_answer: "I see patterns in data"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I am results oriented",
      second_answer: "I pay attention to detail"
    ).ordered
    expect(subject).to receive(:print_question).with(
      first_answer: "I am not easily offended",
      second_answer: "I like working together with others"
    ).ordered

    subject.conduct
  end

  it "should provide ipsative questions (two possible answers)" do
    expect(subject).to receive(:print_question) do | arguments |
      expect(arguments[:first_answer]).not_to be_empty
      expect(arguments[:second_answer]).not_to be_empty
      expect(arguments[:first_answer]).not_to eq(arguments[:second_answer])
    end.exactly(30).times

    subject.conduct
  end

  context "when the entered character does not equal 1 or 2" do
    before :each do
      allow(STDIN).to receive(:getch).and_return("2", "1", "2", "q")
    end

    it "should stop increasing the scores" do
      expect(subject.conduct.sum { |dimension_name, score| score }).to eql(3)
    end

    it "should print the corresponding message prior to stopping the assessment" do
      expect(STDOUT).to receive(:puts).with("quit")

      subject.conduct
    end
  end

  describe "#print_question" do
    it "should print the question and two answers to choose from" do
      expect(STDOUT).to receive(:puts).
        with("Pick the answer that describes you best (press 1 or 2):").ordered
      expect(STDOUT).to receive(:puts).with("1) Okay").ordered
      expect(STDOUT).to receive(:puts).with("2) Exceptional").ordered

      subject.print_question first_answer: "Okay", second_answer: "Exceptional"
    end
  end

  describe "#print_result_as_json" do
    it "should print the result as a JSON document" do
      expect(STDOUT).to receive(:puts).with(
        "{\n  \"Adaptive\": 0,\n  \"Integrity\": 0,\n  \"Collaborative\": 0,\n  \"Result\": 0,\n"\
        "  \"Customer\": 0,\n  \"Detail\": 0\n}"
      )

      subject.print_result_as_json
    end
  end

  context "when completed" do
    let(:all_dimensions_names) { Ipsative::DIMENSIONS.map { |dimension| dimension.name } }
    let(:largest_dimension) { Ipsative::DIMENSIONS.max_by { |dimension| dimension.answers.size } }

    it "should provide the results as an object" do
      expect(subject.conduct).to be_an_instance_of(Hash)
      expect(subject.result).to be_an_instance_of(Hash)
    end

    it "should represent the result based on 6 dimensions" do
      expect(all_dimensions_names.size).to eql(6)
      expect(subject.conduct.keys).to match_array(all_dimensions_names)
      expect(subject.result.keys).to match_array(all_dimensions_names)
    end

    it "should have a score for each of 6 dimensions" do
      subject.conduct.each do |dimension_name, score|
        expect(score).to be >= 0
        expect(score).to be <= largest_dimension.answers.size
      end
      subject.result.each do |dimension_name, score|
        expect(score).to be >= 0
        expect(score).to be <= largest_dimension.answers.size
      end
    end
  end
end
