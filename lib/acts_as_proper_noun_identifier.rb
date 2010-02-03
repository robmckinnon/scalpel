module Acts

  module ProperNounIdentifier

    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end

    module ClassMethods
      def clean_last_word list
        if noun = list.last
          if (first = noun.first)
            if first[/^\(/]
              noun[0] = first.sub('(','')
            end
            if starts_in_quote?(first)
              noun[0] = first.sub("'",'')
            end
          end
          if noun.join(' ')[/^(.+) (Annual|Awards|Networking) (Awards|Dinner|Conference|Lunch)$/]
            noun.pop
            noun.pop
          end
          if (noun == ['The'] || noun == ['Annual','Dinner'] || noun == ['Parliamentary'])
            list.pop
          elsif last = noun.pop
            if last[/^\((.+)\)/]
              list << [$1]
            elsif last[/^\((.+)/]
              list << [$1]
            else
              if last[/^(.+)(\.|,|'s|;|')$/]
                last = $1.chomp('.')
              end
              noun << last
            end
          end
        end
      end

      def add_word list, word
        proper_noun = list.pop
        if proper_noun
          proper_noun << word
          list << proper_noun
        end
      end

      def end_check list, word, state, last_state
        if word[/^(.+)(\;|\.):?$/]
          unless last_state == :not_proper
            proper_noun = list.last
            word = proper_noun.pop
            proper_noun << $1.chomp('.')
            state = :not_proper
          end
        end
        state
      end

      CONJUNCTIONS = ['on', 'for', 'and', '&', 'of'].inject({}) {|h,x| h[x]=true; h } unless defined?(CONJUNCTIONS)

      def capitalized? word
        word[/^(\(|')?[A-Z].+\)?$/] || word[/^(\(|')?[0-9][A-Z]+\)?$/]
      end

      def handle_number number, state, list, numbers, word, last_state
        case state
          when :proper
            add_word list, number
          else
            numbers << word
            state = :number
        end
        state = end_check(list, word, state, last_state)
      end

      def starts_in_quote? word
        word[/^'.+$/]
      end

      def ends_in_quote? word
        word[/^.+'$/]
      end

      def ends_in_comma? word
        word[/^.+,$/]
      end

      def ends_in_fullstop? word
        word[/^.+\.$/]
      end

      def ends_in_comma_or_fullstop? word
        ends_in_comma?(word) || ends_in_fullstop?(word)
      end

      def handle_proper_noun_start list, word
        clean_last_word list
        list << [word]
        state = ends_in_comma_or_fullstop?(word) ? :not_proper : :proper
      end

      def handle_capitalized state, list, numbers, word, last_state, conjunctions, ignore_list
        ignore_word = ignore_list.include?( (word.reverse.chomp('(')).reverse.chomp(',').chomp('.') )
        if ignore_word
          state = :not_proper
        else
          case state
            when :number
              list << [numbers.pop]
              state = :proper
              add_word list, word
            when :conjunction
              add_word list, conjunctions.pop
              state = :proper
              add_word list, word
            when :not_proper
              state = handle_proper_noun_start list, word
            when :proper
              if starts_in_quote?(word)
                state = handle_proper_noun_start list, word
              else
                add_word list, word
                state = :not_proper if ends_in_comma_or_fullstop?(word)
              end
          end
        end
        state = end_check(list, word, state, last_state)
      end

      def handle_conjunction state, word, conjunctions
        if state == :proper
          conjunctions << word
          state = :conjunction
        end
        state
      end

      def proper_nouns text, options={}
        ignore_list = options[:ignore] || []

        @ignore_in_quotes = options[:ignore_in_quotes]
        @in_quotes = false
        list = []
        conjunctions = []
        numbers = []
        state = :not_proper

        if options[:ignore_dates]
          months = %w[January February March April May June July August September October November December]
          text = text.gsub(/\d?\d\s+(#{months.join('|')})\s+\d\d\d\d/, '')
          text.gsub!(/(#{months.join('|')})\s+\d\d\d\d/, '')
        end

        text.split.each do |word|
          last_state = state

          if starts_in_quote?(word)
            @in_quotes = true
          end

          unless @ignore_in_quotes && @in_quotes
            if word[/^(\d+)(,|\))?$/]
              state = handle_number($1, state, list, numbers, word, last_state)
            elsif capitalized? word
              state = handle_capitalized(state, list, numbers, word, last_state, conjunctions, ignore_list)
            elsif CONJUNCTIONS[word]
              state = handle_conjunction state, word, conjunctions
            else
              state = :not_proper
            end
          end

          if ends_in_quote?(word) && @in_quotes
            @in_quotes = false
          end
          # puts "[#{last_state}] #{state}: #{word}#{list.last ? ' -> '+list.last.join(' ') : ''}"
        end
        clean_last_word list
        list.collect{|x| x.join(' ')}.uniq
      end

      # def acts_as_proper_noun_identifier(options={})
        # include Acts::ProperNounIdentifier::InstanceMethods
      # end
    end

    module InstanceMethods
      # def proper_nouns text
      # end
    end

  end
end

# ActiveRecord::Base.send(:include, Acts::ProperNounIdentifier)
