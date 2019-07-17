module Sierra
  module Argot
    module TDArgot
      def argot
        @argot ||= TDArgot.argot(self)
      end

      # Transforms TRLN Discovery record's MARC into Argot
      def self.argot(trln_rec)
        indexer.map_record(trln_rec.altmarc)
      end

      def self.indexer
        @indexer ||= Indexer.new.indexer
      end
    end
  end

  module Derivatives
    class TRLNDiscoveryRecord
      include Sierra::Argot::TDArgot
    end
  end

  module Data
    class Bib
      def argot
        @argot ||= trln_discovery_record.argot
      end
    end
  end
end
