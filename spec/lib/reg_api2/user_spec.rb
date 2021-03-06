# -*- encoding : utf-8 -*-

require 'blueprints/user'

describe RegApi2::User do

  include RegApi2
  FakeUser = RegApi2::Entity::User

  describe :nop do
    it "should raise nothing" do
      lambda { user.nop }.should_not raise_error
    end
    
    it "should return nil" do
      user.nop.should be_nil
    end
  end

  describe :create do
    it "should raise ContractError unless user_login provided." do
      lambda { user.create(FakeUser.make(:bad_login)) }.should raise_error RegApi2::ContractError
      lambda { user.create(FakeUser.make(:bad_login)) }.should raise_error /user_login/
    end

    it "should raise ContractError unless user_password provided." do
      lambda { user.create(FakeUser.make(:bad_password)) }.should raise_error RegApi2::ContractError
      lambda { user.create(FakeUser.make(:bad_password)) }.should raise_error /user_password/
    end

    it "should raise ContractError unless user_email provided." do
      lambda { user.create(FakeUser.make(:bad_email)) }.should raise_error RegApi2::ContractError
      lambda { user.create(FakeUser.make(:bad_email)) }.should raise_error /user_email/
    end
  
    it "should raise ContractError unless user_country_code provided." do
      lambda { user.create(FakeUser.make(:bad_country_code)) }.should raise_error RegApi2::ContractError
      lambda { user.create(FakeUser.make(:bad_country_code)) }.should raise_error /user_country_code/
    end

    it "should create user with valid data." do
      lambda { user.create(FakeUser.make(:good_user)) }.should_not raise_error
      user.create(FakeUser.make(:good_user)).should == "777"
    end
  end

  describe :get_statistics do
    it "should return user statistics" do
      user.get_statistics.keys.sort.should == %w[
        active_domains_cnt 
        active_domains_get_ctrl_cnt 
        balance_total 
        domain_folders_cnt 
        renew_domains_cnt 
        renew_domains_get_ctrl_cnt 
        undelegated_domains_cnt 
      ]
    end
  end

  describe :get_balance do
    it "should return user balance" do
      user.get_balance(currency: :USD).keys.sort.should == %w[
        currency
        prepay
      ]
    end
  end

  describe :refill_balance do
    it "should fill balance" do
      ans = user.refill_balance(
        pay_type: :WM, 
        wmid: 123456789012, 
        currency: :RUR,
        amount: 1000
      )
      ans.currency.should == 'RUR'
      ans.pay_type.should == 'WM'
      ans.payment.should == 1000
      ans.total_payment.should == 1000
      ans.should have_key :wm_invid
    end
  end
end
