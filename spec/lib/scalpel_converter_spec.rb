require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ScalpelConverter do

  describe "when converting" do

    describe "from csv" do
      before do
        @fields_to_translate = [:payee_name, :project_title, :fund]
        @payee1 = %Q|Νοµαρχία Πρέβεζας |
        @project1 = %Q|"Βελτίωση - Κατασκευή 1ης Επ.Οδού, Χ.Θ.0+900,00 Ε Σ Χ.Θ. 0+3.200,00 κ "|
        @payee2 = %Q|∆ήµος Φαναρίου |
        @project2 = %Q|Σύνδεση Καναλλακίου µε ΕΟ Πρέβεζας|
        @fund = %Q|ΕΤΠΑ |

        @amount1 = '5.100.000 €'
        @amount2 = '8.661.908,61 €'
        @converted_amount1 = '5100000'
        @converted_amount2 = '8661908.61'

        @csv = %Q|payee_name,project_title,year_joined,public_expenditure_listing,fund,uri
#{@payee1},#{@project1},2009,"#{@amount1}",#{@fund},http://www.espa.gr/Shared/Download.aspx?cat=attachments&type=Documents&fileid=362
#{@payee1},#{@project1},2009,"0,00",#{@fund},http://www.espa.gr/Shared/Download.aspx?cat=attachments&type=Documents&fileid=362
#{@payee2},#{@project2},2009,"#{@amount2}",#{@fund},http://www.espa.gr/Shared/Download.aspx?cat=attachments&type=Documents&fileid=362|


@expected = %Q|payee_name,project_title,year_joined,public_expenditure_listing,t_public_expenditure_listing,fund,uri
#{@payee1},#{@project1},2009,#{@amount1},#{@converted_amount1},#{@fund},http://www.espa.gr/Shared/Download.aspx?cat=attachments&type=Documents&fileid=362
#{@payee1},#{@project1},2009,"0,00",0.00,#{@fund},http://www.espa.gr/Shared/Download.aspx?cat=attachments&type=Documents&fileid=362
#{@payee2},#{@project2},2009,"#{@amount2}",#{@converted_amount2},#{@fund},http://www.espa.gr/Shared/Download.aspx?cat=attachments&type=Documents&fileid=362
|
      end

      it "should convert specified fields" do
        options = { 
          :convert => :public_expenditure_listing
        }

        translated = ScalpelConverter.convert_csv(@csv, options)
        translated.should == @expected
      end
      
    end
  end
  
end
