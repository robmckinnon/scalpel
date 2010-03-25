require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ScalpelTranslator do

  describe "when translating" do
    before do
      @translator = mock('translator')
      Google::Translator.stub!(:new).and_return @translator
      @text = 'text'
    end

    describe "from file" do
      it "should call translate" do
        file = 'gr.csv'
        from = 'gr'
        IO.should_receive(:read).with(file).and_return @text
        @translator.should_receive(:translate).with(:el, :en, @text)
        ScalpelTranslator.translate(file, from)
      end
    end

    describe "from csv" do
      before do
        @fields_to_translate = [:payee_name, :project_title, :fund]
        @payee1 = %Q|Νοµαρχία Πρέβεζας |
        @project1 = %Q|"Βελτίωση - Κατασκευή 1ης Επ.Οδού, Χ.Θ.0+900,00 Ε Σ Χ.Θ. 0+3.200,00 κ "|
        @payee2 = %Q|∆ήµος Φαναρίου |
        @project2 = %Q|Σύνδεση Καναλλακίου µε ΕΟ Πρέβεζας|
        @fund = %Q|ΕΤΠΑ |

        @t_payee1 = 'Preveza Prefecture '
        @t_project1 = 'Improvement - Construction 1st Ep.Odou, CH.TH.0 900.00 T KP R 0 3200.00 c '
        @t_payee2 = 'Municipality of Preveza'
        @t_project2 = 'Connect with SD Kanalaki Preveza '
        @t_fund = 'ERDF '

        @amount1 = '5.100.000 €'
        @amount2 = '8.661.908,61 €'
        @converted_amount1 = '5100000'
        @converted_amount2 = '8661908.61'

        @csv = %Q|payee_name,project_title,year_joined,public_expenditure_listing,fund,uri
#{@payee1},#{@project1},2009,"#{@amount1}",#{@fund},http://www.espa.gr/Shared/Download.aspx?cat=attachments&type=Documents&fileid=362
#{@payee2},#{@project2},2009,"#{@amount2}",#{@fund},http://www.espa.gr/Shared/Download.aspx?cat=attachments&type=Documents&fileid=362|


@expected = %Q|t_payee_name,payee_name,t_project_title,project_title,year_joined,t_public_expenditure_listing,public_expenditure_listing,t_fund,fund,uri
#{@t_payee1},#{@payee1},"#{@t_project1}",#{@project1},2009,#{@converted_amount1},#{@amount1},#{@t_fund},#{@fund},http://www.espa.gr/Shared/Download.aspx?cat=attachments&type=Documents&fileid=362
#{@t_payee2},#{@payee2},#{@t_project2},#{@project2},2009,#{@converted_amount2},"#{@amount2}",#{@t_fund},#{@fund},http://www.espa.gr/Shared/Download.aspx?cat=attachments&type=Documents&fileid=362
|
      end

      def check_translate text, translated
        @translator.should_receive(:translate).with(:el, :en, text).once.and_return translated
      end

      it "should translate specified fields" do
        check_translate @payee1, @t_payee1 
        check_translate 'Βελτίωση - Κατασκευή 1ης Επ.Οδού, Χ.Θ.0+900,00 Ε Σ Χ.Θ. 0+3.200,00 κ ', @t_project1 
        check_translate @payee2, @t_payee2 
        check_translate @project2, @t_project2 
        @translator.should_receive(:translate).with(:el, :en, @fund).twice.and_return @t_fund

        options = { 
          :from => 'gr',
          :translate => @fields_to_translate,
          :convert => :public_expenditure_listing
        }

        translated = ScalpelTranslator.translate_csv(@csv, options)
        translated.should == @expected
      end
      
      it 'should translate csv file' do
        file_name = 'data/gr_data.csv'
        csv = 'csv'
        GitRepo.should_receive(:open_parsed).with(file_name).and_return csv
        translated = 'translated'
        ScalpelTranslator.should_receive(:translate_csv).with(csv, :from => 'gr', :translate => @fields_to_translate).and_return translated
        GitRepo.should_receive(:write_parsed).with('data/t_gr_data.csv', translated)
        ScalpelTranslator.translate_csv_file(file_name, :translate => @fields_to_translate)
      end
    end
  end
  
end
