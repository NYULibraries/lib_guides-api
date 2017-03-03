require 'spec_helper'

describe LibGuides::API do
  describe "API_VERSION" do
    subject { described_class::API_VERSION }
    it { is_expected.to_not be_nil }
  end
end
