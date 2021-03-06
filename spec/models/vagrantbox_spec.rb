require 'spec_helper'

describe Vagrantbox do
  it "should have a valid factory" do
    Fabricate.build(:vagrantbox).should be_valid
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :box }
  it { should validate_uniqueness_of :name }
  it { should have_many :bentoboxes }

end

