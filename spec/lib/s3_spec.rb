require 'rails_helper'
require 'aws/s3'

RSpec.describe S3 do
  describe '#put_object' do
    subject(:put_object) do
      described_class.new(bucket).put_object(key: key, body: body)
    end

    before do
      allow(Aws::S3::Client).to receive(:new).and_return(mock_s3_client)
      allow(mock_s3_client).to receive(:put_object)
    end

    let(:mock_s3_client) do
      Aws::S3::Client.new(stub_responses: true)
    end

    let(:bucket) { 'bucket' }
    let(:key) { 'key' }
    let(:body) { 'body' }

    it { expect(put_object[:success]).to eq(true) }

    it 'invokes the SWS S3 client' do
      put_object
      expect(mock_s3_client).to have_received(:put_object)
    end
  end

  describe '#delete_object' do
    subject(:delete_object) do
      described_class.new(bucket).delete_object(key: key)
    end

    before do
      allow(Aws::S3::Client).to receive(:new).and_return(mock_s3_client)
      allow(mock_s3_client).to receive(:delete_object)
    end

    let(:mock_s3_client) do
      Aws::S3::Client.new(stub_responses: true)
    end

    let(:bucket) { 'bucket' }
    let(:key) { 'key' }

    it { expect(delete_object[:success]).to eq(true) }

    it 'invokes the SWS S3 client' do
      delete_object
      expect(mock_s3_client).to have_received(:delete_object)
    end
  end
end
