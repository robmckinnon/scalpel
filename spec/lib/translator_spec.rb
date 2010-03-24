require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Translator do

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
        Translator.translate(file, from)
      end
    end

    describe "from csv" do
      before do
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

        @csv = %Q|payee_name,project_title,year_joined,public_expenditure_listing,fund,uri
#{@payee1},#{@project1},2009,"5.100.000,00 €",#{@fund},http://www.espa.gr/Shared/Download.aspx?cat=attachments&type=Documents&fileid=362
#{@payee2},#{@project2},2009,"8.661.908,61 €",#{@fund},http://www.espa.gr/Shared/Download.aspx?cat=attachments&type=Documents&fileid=362|

@expected = %Q|t_payee_name,payee_name,t_project_title,project_title,year_joined,public_expenditure_listing,t_fund,fund,uri
#{@t_payee1},#{@payee1},"#{@t_project1}",#{@project1},2009,"5.100.000,00 €",#{@t_fund},#{@fund},http://www.espa.gr/Shared/Download.aspx?cat=attachments&type=Documents&fileid=362
#{@t_payee2},#{@payee2},#{@t_project2},#{@project2},2009,"8.661.908,61 €",#{@t_fund},#{@fund},http://www.espa.gr/Shared/Download.aspx?cat=attachments&type=Documents&fileid=362
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
        country_code = 'gr'
        fields_to_translate = [:payee_name, :project_title, :fund]
        translated = Translator.translate_csv(@csv, country_code, fields_to_translate)
        
        translated.should == @expected
      end
    end
  end
  
end
