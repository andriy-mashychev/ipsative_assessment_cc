# ipsative_assessment_cc

## Evaluates someone’s culture using a methodology developed at the Stanford GSB Institute for Organizational Behavior

This methodology measures 6 dimensions to understand an individual’s culture norms:

- Adaptability: Readily takes advantage of new opportunities
- Results-orientation: Gets things done
- Collaboration: Is a great team player
- Attention to detail: Values precision and accuracy
- Principles: Holds high ethical standards
- Customer-orientation: Always keeps the customer in mind

The assessment consists of 30 questions in total. The questions give two options to choose from. Each
of these options represents one of the provided answers (see `data/dimensions.json`). This is called [Ipsative testing](https://en.wikipedia.org/wiki/Ipsative).

Each combination of the dimensions appears twice during the assessment. Every time an answer is chosen, the score for the corresponding dimension is incremented. The questions appear in random order without repetitions.

The result of the cultural assessment is represented by the amount of times each dimension has been chosen.

### Installation

```bash
bundle install
```

### Running the tests (includes coverage)

```bash
bundle exec rspec
```

### Example of usage

```console
./main.rb
```
