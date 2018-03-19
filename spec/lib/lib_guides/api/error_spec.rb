require 'spec_helper'
require 'lib_guides/api'

describe LibGuides::API::Error do
  let(:error){ described_class.new faraday_response }
  let(:faraday_response){ instance_double Faraday::Response, body: nil, reason_phrase: nil }

  describe "message" do
    subject{ error.message }
    let(:generate_message){ "Some message" }

    before do
      # allow_any_instance_of(described_class).to receive(:reason_phrase).and_return reason_phrase
      allow_any_instance_of(described_class).to receive(:generate_message).and_return generate_message
      # allow_any_instance_of(described_class).to receive(:response_body).and_return response_body
    end

    it { is_expected.to eq generate_message }

    # context "with reason_phrase" do
    #   let(:reason_phrase){ "Some reason" }
    #   let(:generate_message){ "Error message" }
    #   it { is_expected.to eq "Error message (Some reason)\n{'some' : 'body'}" }
    # end
    #
    # context "with no reason_phrase" do
    #   let(:reason_phrase){ nil }
    #   let(:generate_message){ "Error message" }
    #   it { is_expected.to eq "Error message\n{'some' : 'body'}" }
    # end
  end

  describe "generate_message" do
    subject{ error.generate_message }
    let(:parsed_message){ nil }
    let(:faraday_response){ instance_double Faraday::Response, body: body, reason_phrase: nil }
    before do
      allow(error).to receive(:parsed_message).and_return parsed_message
    end

    context "with parsed_message" do
      let(:parsed_message){ "Some reason" }

      context "with body" do
        let(:body){ "Some body" }

        it { is_expected.to eq "Some reason\nSome body"}
      end
    end

    context "with no parsed_message" do
      let(:parsed_message){ "" }

      context "with body" do
        let(:body){ "Some body" }

        it { is_expected.to eq "Some body"}
      end
    end
  end

  describe "parsed_message" do
    subject{ error.parsed_message }
    let(:json_message){ nil }
    let(:reason_phrase){ nil }
    before do
      allow(error).to receive(:json_message).and_return json_message
      allow(error).to receive(:reason_phrase).and_return reason_phrase
    end

    context "with json_message" do
      let(:json_message){ "Some message" }

      context "and reason_phrase" do
        let(:reason_phrase){ "Some reason" }
        it { is_expected.to eq "Some message (Some reason)"}
      end

      context "and no reason_phrase" do
        it { is_expected.to eq "Some message" }
      end
    end

    context "with no json_message" do
      context "and reason_phrase" do
        let(:reason_phrase){ "Some reason" }
        it { is_expected.to eq "(Some reason)"}
      end

      context "and no reason_phrase" do
        it { is_expected.to eq "" }
      end
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

  describe "json_message" do
    subject{ error.json_message }
    let(:faraday_response){ instance_double Faraday::Response, body: body, reason_phrase: nil }

    context "with valid JSON body" do
      let(:body){ json.to_json }
      let(:json){ {"error" => "Some Error", "error_description" => "Description"} }

      it { is_expected.to eq "Some Error: Description" }
    end

    context "with invalid JSON body" do
      let(:body){ "Some body" }

      it { is_expected.to eq nil }
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
