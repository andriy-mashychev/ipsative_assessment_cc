require_relative 'dimensions'
require 'io/console'

module Ipsative
  class Assessment
    attr_reader :result

    def conduct
      random_pairs_of_dimensions.each do |pair|
        print_question first_answer: take_random_answer(pair.first),
                       second_answer: take_random_answer(pair.last)
        break unless user_chose_an_answer? first_dimension: pair.first,
                                           second_dimension: pair.last
      end
      print_result_as_json
      result
    end

    def initialize
      @result = DIMENSIONS.to_h { |dimension| [ dimension.name, 0 ] }
      @remaining_answers = DIMENSIONS.to_h do |dimension|
        [ dimension.name, dimension.answers.dup ]
      end
      @prng = Random.new
    end

    def print_question first_answer:, second_answer:
      puts "Pick the answer that describes you best (press 1 or 2):"
      puts "1) #{first_answer}"
      puts "2) #{second_answer}"
    end

    def print_result_as_json
      puts "Below is your result of the ipsative assessment:"
      puts JSON.pretty_generate(result)
    end

    def random_pairs_of_dimensions
      @dimensions_combinations ||= DIMENSIONS.map { |dimension| dimension.name }.
        permutation(2).to_a.shuffle!(random: @prng)
    end

    protected

    def increment_dimension_score dimension_name
      @result[dimension_name] += 1
    end

    def user_chose_an_answer? first_dimension:, second_dimension:
      case STDIN.getch
      when "1" then puts "1"; !!increment_dimension_score(first_dimension)
      when "2" then puts "2"; !!increment_dimension_score(second_dimension)
      else puts "quit"; false
      end
    end
    
    def take_random_answer dimension_name
      answer_id = @prng.rand @remaining_answers[dimension_name].length
      @remaining_answers[dimension_name].delete_at(answer_id)
    end
  end
end
