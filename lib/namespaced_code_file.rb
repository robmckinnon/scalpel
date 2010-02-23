module Acts

  module NamespacedCodeFile
    
    def self.included(base) # :nodoc:
      base.extend ClassMethods
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def code_instance
        code_file = send("#{self.class.name.downcase}_file".to_sym)
        require code_file
        code_module = namespace.camelize
        code_class = File.basename(code_file.chomp('.rb')).camelize
        code_type = "#{code_module}::#{code_class}".constantize
        code_type.new
      end
    end

    module ClassMethods
      def run path
        code = find_by_file "#{code_dir}#{path}"
        code.run
      end
        
      def find_by_file file
        send("find_by_#{self.name.downcase}_file".to_sym, file)
      end
    
      def code_dir
        "#{RAILS_ROOT}/lib/#{self.name.downcase.pluralize}"
      end

      def code_by_namespace
        Dir.glob("#{code_dir}/*").collect do |directory|
          namespace = directory.split('/').last
          
          codes = Dir.glob("#{directory}/*#{code_suffix}.rb").collect do |file|
            code = find_by_file(file)
            unless code
              name = File.basename(file, '.rb').humanize
              code = self.new("#{self.name.downcase}_file".to_sym => file, :namespace => namespace, :name => name)
              code.save!
            end
            code
          end
          [namespace, codes]
        end
      end
    end
  end
end
