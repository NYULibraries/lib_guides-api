require 'spec_helper'
require 'lib_guides/api'

describe LibGuides::API::V1_2::Az::List do
  let(:list){ described_class.new }

  describe "load" do
    subject{ list.load }
    let(:json_response){ [asset_attrs1, asset_attrs2, asset_attrs3] }
    let(:asset_attrs1){ {"id" => 1, "url" => "http://example.com"} }
    let(:asset_attrs2){ {"id" => 2, "url" => "http://example2.com"} }
    let(:asset_attrs3){ {"id" => 3, "url" => "http://example3.com"} }
    before { allow(list).to receive(:execute).and_return json_response }

    it { is_expected.to be_an Array }
    it "should execute get request correctly" do
      expect(list).to receive(:execute).with(:get, '/az')
      subject
    end
    it "should consist of correct number of assets" do
      subject
      expect(list.length).to eq 3
      expect(list[0]).to be_a LibGuides::API::V1_2::Az::Asset
      expect(list[1]).to be_a LibGuides::API::V1_2::Az::Asset
      expect(list[2]).to be_a LibGuides::API::V1_2::Az::Asset
      expect(list[3]).to be nil
    end
    it "should initialize assets correctly" do
      expect(LibGuides::API::V1_2::Az::Asset).to receive(:new).with(asset_attrs1)
      expect(LibGuides::API::V1_2::Az::Asset).to receive(:new).with(asset_attrs2)
      expect(LibGuides::API::V1_2::Az::Asset).to receive(:new).with(asset_attrs3)
      subject
    end
  end
end
