# -*- encoding : utf-8 -*-
describe RegApi2::ResultContract::Default do

  let!(:contract) { RegApi2::ResultContract::Default.new(a: 1, b: 4) }

  describe :initialize do
    it "should assign opts" do
      contract.opts.should == { a: 1, b: 4 }
    end
  end
end
