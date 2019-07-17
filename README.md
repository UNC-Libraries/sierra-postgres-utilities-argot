# SierraPostgresUtilities::Argot

[sierra_postgres_utilities gem](https://github.com/UNC-Libraries/sierra-postgres-utilities) addon to allow programmatic access to [Argot](https://github.com/trln/marc-to-argot) for a Sierra
bib record (or TRLN Discovery bib).

## Installation

```bash
bundle install
bundle exec rake install
```

## Usage

```ruby
require 'sierra_postgres_utilities/argot'

bib = Sierra::Data::Bib.first
bib.argot
  #=> {"record_data_source"=>["ILSMARC"], "publication_year"=>[1976],
  #    "date_cataloged"=>["2004-10-01T04:00:00Z"], "language"=>["English"],
  #    "lang_code"=>["eng"], "publisher"=>[{"value"=>"Black Sparrow Press"}],
  #    "names"=>[{"name"=>"Kelly, Robert, 1935-", "type"=>"creator"}], ...

trln = bib.trln_discovery_record
trln.argot
  #=> same as above
```
