require 'spec_helper'
require 'lib_guides/api'

describe LibGuides do
  describe "VERSION" do
    subject { described_class::VERSION }
    it { is_expected.to_not be_nil }
  end
end
