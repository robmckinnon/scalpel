require 'google_translate'
require 'morph'

class TranslatorEntry
  include Morph
end

class Translator

  class << self
    def translate_csv csv, country_code, fields_to_translate, to='en'
      @translator = Google::Translator.new
      from = language(country(country_code))
      items = Morph.from_csv csv, 'Item'
      keys = items.first.class.morph_attributes

      items.each do |item|
        keys.each do |key|
          if fields_to_translate.include?(key)
            value = item.send(key)
            translated = @translator.translate(from.to_sym, to.to_sym, value)
            item.morph("t_#{key}".to_s, translated)
          end
        end
      end
      
      keys = keys.collect {|key| fields_to_translate.include?(key) ? ["t_#{key}", key] : key }.flatten
      output = FasterCSV.generate do |csv|
        csv << keys.collect(&:to_s)
        items.each do |item|
          csv << keys.collect { |key| item.send(key) }
        end
      end
    end
    
    def translate file, from, to='en'
      @translator = Google::Translator.new
      from = language(country(from))
      from_text = IO.read(file)
      from_text.each_line do |x|
        puts @translator.translate(from.to_sym, to.to_sym, x)
      end
    end

    def country country_code
      case country_code
      when 'at'
        'AUSTRIA'
      when 'be'
        'BELGIUM'
      when 'bg'
        'BULGARIA'
      when 'cy'
        'CYPRUS'
      when 'cz'
        'CZECH REPUBLIC'
      when 'dk'
        'DENMARK'
      when 'ee'
        'ESTONIA'
      when 'fi'
        'FINLAND'
      when 'fr'
        'FRANCE'
      when 'de'
        'GERMANY'
      when 'gr'
        'GREECE'
      when 'hu'
        'HUNGARY'
      when 'ie'
        'IRELAND'
      when 'it'
        'ITALY'
      when 'lv'
        'LATVIA'
      when 'lt'
        'LITHUANIA'
      when 'lu'
        'LUXEMBOURG'
      when 'mt'
        'MALTA'
      when 'nl'
        'NETHERLANDS'
      when 'pl'
        'POLAND'
      when 'pt'
        'PORTUGAL'
      when 'ro'
        'ROMANIA'
      when 'sk'
        'SLOVAKIA'
      when 'si'
        'SLOVENIA'
      when 'es'
        'SPAIN'
      when 'se'
        'SWEDEN'
      when 'uk'
        'UK'
      else
        raise "unknown country for: #{country_code}"
      end
    end
        
    def language country
      case country
      when 'AUSTRIA'
        'de'
      when 'BELGIUM'
        'fr'
      when 'BULGARIA'
        'bg'
      when 'CYPRUS'
        'el'
      when 'CZECH REPUBLIC'
        'cs'
      when 'DENMARK'
        'da'
      when 'ESTONIA'
        'et'
      when 'FINLAND'
        'fi'
      when 'FRANCE'
        'fr'
      when 'GERMANY'
        'de'
      when 'GREECE'
        'el'
      when 'HUNGARY'
        'hu'
      when 'IRELAND'
        'en'
      when 'ITALY'
        'it'
      when 'LATVIA'
        'lv'
      when 'LITHUANIA'
        'lt'
      when 'LUXEMBOURG'
        'fr'
      when 'MALTA'
        'en'
      when 'NETHERLANDS'
        'nl'
      when 'POLAND'
        'pl'
      when 'PORTUGAL'
        'pt'
      when 'ROMANIA'
        'ro'
      when 'SLOVAKIA'
        'sk'
      when 'SLOVENIA'
        'sl'
      when 'SPAIN'
        'es'
      when 'SWEDEN'
        'sv'
      when 'UK'
        'en'
      else
        raise "unknown language for: #{country}"
      end
    end
  end
end
