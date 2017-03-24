require 'spec_helper'
require 'lib_guides/api'

describe LibGuides::API::V1_2::Base do
  let(:base){ described_class.new }

  describe "execute" do
    subject{ base.execute verb, path }
    let(:verb){ :put }
    let(:path){ "/some/path" }
    let(:token){ "abcd" }
    let(:connection){ instance_double Faraday::Connection, public_send: response }
    let(:request){ instance_double Faraday::Request, url: true, headers: headers, :body= => true }
    let(:headers){ instance_double Faraday::Utils::Headers, :[]= => true }
    let(:response){ instance_double Faraday::Response, body: json.to_json, success?: success }
    before do
      allow(base).to receive(:connection).and_return connection
      allow(connection).to receive(:public_send).and_yield(request).and_return response
      allow(base).to receive(:token).and_return token
    end

    context "with valid, successful response" do
      let(:success){ true }
      let(:json){ {"data" => "some_data"} }

      it { is_expected.to eq json }
      it "should call verb on connection" do
        expect(connection).to receive(:public_send).with(verb)
        subject
      end
      it "should set url on request" do
        expect(request).to receive(:url).with("/1.2/some/path")
        subject
      end
      it "should set headers on request" do
        expect(headers).to receive(:[]=).with("Authorization", "Bearer abcd")
        subject
      end
      it "should not set body on request" do
        expect(request).to_not receive(:body=)
        subject
      end

      context "with params in request" do
        subject{ base.execute verb, path, params }
        let(:params){ {"my" => "data"} }

        it { is_expected.to eq json }
        it "should call verb on connection" do
          expect(connection).to receive(:public_send).with(verb)
          subject
        end
        it "should set url on request" do
          expect(request).to receive(:url).with("/1.2/some/path")
          subject
        end
        it "should set headers on request" do
          expect(headers).to receive(:[]=).with("Authorization", "Bearer abcd")
          subject
        end
        it "should set body on request" do
          expect(request).to receive(:body=).with(params)
          subject
        end
      end
    end

    context "with invalid, successful response" do
      let(:success){ true }
      let(:json){ {"error" => "some_error"} }

      it "should raise custom error" do
        expect{ subject }.to raise_error LibGuides::API::V1_2::Error
      end

      it "should initialize custom error" do
        expect(LibGuides::API::V1_2::Error).to receive(:new).with(response)
        expect{ subject }.to raise_error TypeError
      end
    end

    context "with unsuccessful response" do
      let(:success){ false }
      let(:json){ {"data" => "some_data"} }

      it "should raise custom error" do
        expect{ subject }.to raise_error LibGuides::API::V1_2::Error
      end

      it "should initialize custom error" do
        expect(LibGuides::API::V1_2::Error).to receive(:new).with(response)
        expect{ subject }.to raise_error TypeError
      end
    end
  end

  describe "token" do
    subject{ base.token }
    let(:current_token){ "abcd" }
    let(:new_token){ "wxyz" }
    before do
      base.instance_variable_set("@current_token", current_token)
      allow(base).to receive(:token_expired?).and_return token_expired
      allow(base).to receive(:get_token).and_return new_token
    end

    context "if token unexpired" do
      let(:token_expired){ false }

      it { is_expected.to eq current_token }
      it "should retain current_token" do
        subject
        expect(base.current_token).to eq current_token
      end
    end

    context "if token expired" do
      let(:token_expired){ true }

      it { is_expected.to eq new_token }
      it "should persist new token" do
        subject
        expect(base.current_token).to eq new_token
      end
    end
  end

  describe "token_expired?" do
    subject{ base.token_expired? }
    before { allow(base).to receive(:current_token).and_return current_token }

    context "with current token" do
      let(:current_token){ "abcd" }
      before { allow(base).to receive(:token_expires_at).and_return token_expires_at }

      context "expiring in future" do
        let(:token_expires_at){ Time.now + 60 }

        it { is_expected.to be_falsy }
      end

      context "expiring in past" do
        let(:token_expires_at){ Time.now - 60 }

        it { is_expected.to be_truthy }
      end

      context "expiring immediately" do
        let(:token_expires_at){ Time.now }

        it { is_expected.to be_truthy }
      end
    end

    context "without current token" do
      let(:current_token){ nil }

      it { is_expected.to be_truthy }
    end
  end

  describe "get_token" do
    subject{ base.get_token }
    let(:connection){ instance_double Faraday::Connection }
    let(:response){ instance_double Faraday::Response }
    before do
      allow(base).to receive(:connection).and_return connection
      allow(connection).to receive(:post).and_return response
      allow(response).to receive(:body).and_return json.to_json
      allow(response).to receive(:success?).and_return success
    end

    context "with valid, successful json response" do
      let(:success){ true }
      let(:json){ {"expires_in" => expires_in, "access_token" => token} }
      let(:token){ "abcd" }
      let(:expires_in){ "60" }
      let(:time){ Time.new(2016,1,1) }
      before { allow(Time).to receive(:now).and_return time }

      it { is_expected.to eq token }
      it "should set token_expires_at" do
        subject
        expect(base.token_expires_at).to eq time + 60
      end
    end

    context "with invalid, successful json response" do
      let(:success){ true }
      let(:json){ {"error" => "Some error"} }

      it "should raise custom error" do
        expect{ subject }.to raise_error LibGuides::API::V1_2::Error
      end

      it "should initialize custom error" do
        expect(LibGuides::API::V1_2::Error).to receive(:new).with(response)
        expect{ subject }.to raise_error TypeError
      end
    end

    context "with unsuccessful response" do
      let(:success){ false }
      let(:json){ {"error" => "Some error"} }

      it "should raise custom error" do
        expect{ subject }.to raise_error LibGuides::API::V1_2::Error
      end

      it "should initialize custom error" do
        expect(LibGuides::API::V1_2::Error).to receive(:new).with(response)
        expect{ subject }.to raise_error TypeError
      end
    end
  end

  describe "connection" do
    subject{ base.connection }
    let(:faraday){ instance_double Faraday::Connection }
    before do
      allow(Faraday).to receive(:new).and_return faraday
    end

    it { is_expected.to eq faraday }
    it "should initialize faraday correctly" do
      expect(Faraday).to receive(:new).with(url: 'http://lgapi-us.libapps.com')
      subject
    end
  end
end
