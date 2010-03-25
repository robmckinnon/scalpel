require 'google_translate'
require 'morph'

class ScalpelTranslator

  class << self
    
    # options: :translate => [fields_to_translate]
    def translate_csv_file file_name, options
      name = File.basename(file_name)
      name[/^(..)_/]
      country_code = $1
      csv = GitRepo.open_parsed(file_name)
      translated = translate_csv csv, options.merge(:from => country_code)
      path = file_name.sub(/#{name}$/,'')
      GitRepo.write_parsed "#{path}t_#{name}", translated
    end

    # options: :translate => [fields_to_translate]
    #          :from => 'gr'
    #          :to => 'en'
    #          :convert => [fields_to_convert]
    def translate_csv csv, options
      fields_to_translate = options[:translate]
      fields_to_translate = [fields_to_translate] unless fields_to_translate.is_a?(Array)
      fields_to_convert = options[:convert]
      fields_to_convert = [fields_to_convert] unless fields_to_convert.is_a?(Array)
      to = options[:to] || 'en'
      from_country_code = options[:from]
      from = language(country(from_country_code))
      
      translator = self.new(from, to)
      
      items = Morph.from_csv csv, 'Item'
      keys = items.first.class.morph_attributes.select {|x| !x.to_s[/^t_/] }
      items.each do |item|
        keys.each do |key|
          translator.translate_value(item, key) if fields_to_translate.include?(key)          
          translator.convert_value(item, key) if fields_to_convert.include?(key)
        end
      end

      keys = keys.map do |key|
        if fields_to_translate.include?(key) || fields_to_convert.include?(key)
          ["t_#{key}", key]
        else
          key
        end
      end.flatten

      output = FasterCSV.generate do |csv|
        csv << keys.collect(&:to_s)
        items.each do |item|
          csv << keys.collect { |key| item.respond_to?(key) ? item.send(key) : nil }
        end
      end
    end

    def translate file, from, to='en'
      translator = Google::Translator.new
      from = language(country(from))
      from_text = IO.read(file)
      from_text.each_line do |x|
        translator.translate(from.to_sym, to.to_sym, x)
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

  def initialize from, to
    @translator = Google::Translator.new
    @from, @to = from.to_sym, to.to_sym
  end

  def translate_value item, key
    value = item.send(key)
    unless value.blank?
      if value.size > 400
        value = value[0..400]+'...'
      end
      begin
        translated = @translator.translate(@from, @to, value)
        if translated
          translated.gsub!('&amp;','&')
          translated.gsub!('&quot;','"')
          translated.gsub!('&#39;',"'")
          item.morph("t_#{key}".to_s, translated)
        end
      rescue Exception => e
        puts "text: '#{value}'"
        raise e
      end
    end              
  end
  
  def convert_value item, key
    value = item.send(key)
    unless value.blank?
      case value.strip
      when /^((\d|\.)*\,\d\d)/
        number = $1.gsub('.','').sub(',','.')
        item.morph("t_#{key}",number)
      when /^((\d|\.)*\d\d\d)( |$)/
        number = $1.gsub('.','')
        item.morph("t_#{key}",number)
      end
    end
  end

end
