require 'spec_helper'

RSpec.describe Sierra do
  let(:bib) { Sierra::Data::Bib.first }
  let(:trln) { bib.trln_discovery_record }

  describe Sierra::Derivatives::TRLNDiscoveryRecord do
    describe '#argot' do
      it 'returns hash of Argot json' do
        expect(trln.argot['record_data_source']).to include 'ILSMARC'
      end
    end
  end

  describe Sierra::Data::Bib do
    describe '#argot' do
      it "returns hash of Argot json (for bib's TRLNDiscoveryRecord)" do
        expect(bib.argot).to equal trln.argot
      end
    end
  end
end
