require 'sierra_postgres_utilities'
require 'sierra_postgres_utilities/derivatives'

require 'marc_to_argot'

module Sierra
  # Allows programmatic access to Argot for a Sierra / TRLN Discovery bib.
  module Argot
    # marc_to_argot may appear differently (hyphens vs underscore) in the load
    # path depending on whether or not bundler is involved
    MTA_DATA_DIR =
      File.join($LOAD_PATH.select { |x| x.match 'marc[-_]to[-_]argot' }.first,
                'data')

    COLLECTION = 'unc'.freeze

    autoload :VERSION, 'sierra_postgres_utilities/argot/version'
    autoload :Indexer, 'sierra_postgres_utilities/argot/indexer'

    require 'sierra_postgres_utilities/argot/td_argot'
  end
end
