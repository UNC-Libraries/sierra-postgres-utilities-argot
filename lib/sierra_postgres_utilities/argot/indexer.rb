module Sierra
  module Argot
    module TrajectLoader
      # This module taken almost exactly from spec files of:
      #   https://github.com/trln/marc-to-argot
      # under the following license:
      #
      # The MIT License (MIT)
      #
      # Copyright (c) 2017 Luke Aeschleman
      #
      # Permission is hereby granted, free of charge, to any person obtaining a copy
      # of this software and associated documentation files (the "Software"), to deal
      # in the Software without restriction, including without limitation the rights
      # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
      # copies of the Software, and to permit persons to whom the Software is
      # furnished to do so, subject to the following conditions:
      #
      # The above copyright notice and this permission notice shall be included in
      # all copies or substantial portions of the Software.
      #
      # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
      # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
      # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
      # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
      # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
      # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
      # THE SOFTWARE.

      def create_settings(collection, data_dir, extension)
        spec = MarcToArgot::SpecGenerator.new(collection)
        marc_source_type = extension == 'mrc' ? 'binary' : 'xml'
        flatten_attributes = YAML.load_file("#{data_dir}/flatten_attributes.yml")
        override = File.exist?("#{data_dir}/#{collection}/overrides.yml") ? YAML.load_file("#{data_dir}/#{collection}/overrides.yml") : []

        {
          'argot_writer.flatten_attributes' => flatten_attributes,
          'argot_writer.pretty_print' => false,
          'writer_class_name' => 'Traject::ArgotWriter',
          'specs' => spec.generate_spec,
          'processing_thread_pool' => 1,
          'marc_source.type' => marc_source_type,
          'marc_source.encoding' => 'utf-8',
          'override' => override,
          'log_level' => :error
        }
      end

      def load_indexer(collection = 'argot', extension = 'xml')
        data_dir = MTA_DATA_DIR
        conf_files = ["#{data_dir}/extensions.rb", "#{data_dir}/argot/traject_config.rb", "#{data_dir}/#{collection}/traject_config.rb"]
        indexer_class = MarcToArgot::Indexers.find(collection.to_sym)
        traject_indexer = indexer_class.new create_settings(collection, data_dir, extension)
        conf_files.each do |conf_path|
          begin
            traject_indexer.load_config_file(conf_path)
          rescue Errno::ENOENT, Errno::EACCES => e
            raise "Could not read configuration file '#{conf_path}', exiting..."
          rescue Traject::Indexer::ConfigLoadError => e
            raise e
          rescue StandardError => e
            raise e
          end
        end
        traject_indexer
      end
    end

    # A Traject Indexer to transform MARC into Argot
    class Indexer
      include TrajectLoader

      def indexer
        @indexer ||= load_indexer(COLLECTION, 'mrc')
      end
    end
  end
end
