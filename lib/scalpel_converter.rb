class ScalpelConverter

  class << self
    
    # options: :convert => [fields_to_convert]
    def convert_csv csv, options
      fields_to_convert = options[:convert]
      fields_to_convert = [fields_to_convert].compact unless fields_to_convert.is_a?(Array)

      items = Morph.from_csv csv, 'Item'
      keys = items.first.class.morph_attributes.select {|x| !x.to_s[/^t_/] }

      converter = ScalpelConverter.new
      items.each do |item|
        keys.each do |key|
          converter.convert_value(item, key) if fields_to_convert.include?(key)
        end
      end

      keys = keys.map do |key|
        if fields_to_convert.include?(key)
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
