require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Parser do

  describe "when asked to split on bounds" do
    it 'should split correctly for unicode chars' do
      line = '   Περιφέρειας Κεντρικής Περιµετρική οδός Πολυγύρου, τµήµα Άγιος Βλάσης - προς Βράσταµα         2009                 8.650.000 €                                                 ΕΤΠΑ'
      line = line.mb_chars
      bounds = [[0,24],[25,94],[95,99],[116,170],176]
      values = Parser.values_from_bounds(line,bounds)
      values.first.should == 'Περιφέρειας Κεντρικής'.mb_chars
      values.second.should == 'Περιµετρική οδός Πολυγύρου, τµήµα Άγιος Βλάσης - προς Βράσταµα'
      values.third.should == '2009'
      values.fourth.should == '8.650.000 €'
      values.fifth.should == 'ΕΤΠΑ'
    end
  end
  
end
