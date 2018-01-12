require 'spec_helper'
require 'lib_guides/api'

describe LibGuides::API::Error do
  let(:error){ described_class.new faraday_response }
  let(:faraday_response){ instance_double Faraday::Response }

  describe "message" do
    subject{ error.message }

    before do
      allow_any_instance_of(described_class).to receive(:reason_phrase).and_return reason_phrase
      allow_any_instance_of(described_class).to receive(:generate_message).and_return generate_message
    end

    context "with reason_phrase" do
      let(:reason_phrase){ "Some reason" }
      let(:generate_message){ "Error message" }
      it { is_expected.to eq "Some reason" }
    end

    context "with no reason_phrase" do
      let(:reason_phrase){ nil }
      let(:generate_message){ "Error message" }
      it { is_expected.to eq "Error message" }
    end
  end

  describe "reason_phrase" do
    subject{ error.reason_phrase }
    let(:faraday_response){ instance_double Faraday::Response, reason_phrase: reason_phrase, body: nil }

    context "when nil" do
      let(:reason_phrase){ nil }
      it { is_expected.to be_nil }
    end

    context "when blank" do
      let(:reason_phrase){ "" }
      it { is_expected.to be_nil }
    end

    context "when present" do
      let(:reason_phrase){ "Some reason" }
      it { is_expected.to eq "Some reason" }
    end
  end

  describe "generate_message" do
    subject{ error.generate_message }
    let(:faraday_response){ instance_double Faraday::Response, body: body, reason_phrase: nil }

    context "with valid JSON body" do
      let(:body){ json.to_json }
      let(:json){ {"error" => "Some Error", "error_description" => "Description"} }

      it { is_expected.to eq "Some Error: Description" }
    end

    context "with invalid JSON body" do
      let(:body){ "Some body" }

      it { is_expected.to eq "Some body" }
    end
  end

  describe "json_response" do
    subject{ error.json_response }
    let(:faraday_response){ instance_double Faraday::Response, body: body, reason_phrase: nil }

    context "with valid JSON body" do
      let(:body){ json.to_json }
      let(:json){ {"error" => "Some Error", "error_description" => "Description"} }

      it { is_expected.to eq json }
    end

    context "with invalid JSON body" do
      let(:body){ "Some body" }

      it { is_expected.to eq nil }
    end
  end
end
