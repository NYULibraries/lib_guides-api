require 'spec_helper'
require 'lib_guides/api'

describe LibGuides::API::Az::Asset do
  let(:asset){ described_class.new attributes }

  describe "initialize" do
    context "with attributes" do
      let(:attributes){ {url: "http://example.com", id: 123456, owner_id: 10, type_id: 100} }

      it "should populate all attributes" do
        expect(asset.url).to eq "http://example.com"
        expect(asset.id).to eq 123456
        expect(asset.owner_id).to eq 10
        expect(asset.type_id).to eq 100
      end
    end

    context "without attributes" do
      let(:asset){ described_class.new }

      it "should initialize all attributes to nil" do
        expect(asset.url).to eq nil
        expect(asset.id).to eq nil
        expect(asset.owner_id).to eq nil
        expect(asset.type_id).to eq nil
      end
    end
  end

  describe "save" do
    subject{ asset.save }
    let(:json_response){ attributes.map{|k,v| [k.to_s, v]}.to_h }
    before { allow(asset).to receive(:execute).and_return json_response }

    context "with id" do
      let(:attributes){ mutable_attributes.merge({id: 123456}) }
      let(:mutable_attributes){ {url: "http://example.com", owner_id: 10, type_id: 100} }

      it "should execute put request to update asset" do
        expect(asset).to receive(:execute).with(:put, "/az/123456", mutable_attributes)
        subject
      end
    end

    context "without id" do
      let(:attributes){ {url: "http://example.com", owner_id: 10, type_id: 100} }
      let(:json_response){ attributes.merge(id: 123).map{|k,v| [k.to_s, v]}.to_h }

      it "should execute post request to create new asset" do
        expect(asset).to receive(:execute).with(:post, "/az", attributes)
        subject
      end
      it "should assign id from response" do
        subject
        expect(asset.id).to eq 123
      end
    end
  end
end
