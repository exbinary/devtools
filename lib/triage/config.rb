# encoding: utf-8

module Triage
  MASTER_BRANCH = 'master'.freeze

  # Abstract base class of tool configuration
  class Config
    # Represent no configuration
    DEFAULT_CONFIG = {}.freeze

    # Declare an attribute
    #
    # @param [Symbol] name
    #
    # @yieldreturn [Object]
    #   the default value to use
    #
    # @api private
    #
    # @return [self]
    #
    def self.attribute(name, *default)
      define_method(name) do
        raw.fetch(name.to_s, *default)
      end
    end
    private_class_method :attribute

    # Return project
    #
    # @return [Project]
    #
    # @api private
    #
    attr_reader :project

    # Initialize object
    #
    # @return [Project]
    #
    # @api private
    #
    def initialize(project)
      @project = project
    end

    # Return config path
    #
    # @return [String]
    #
    # @api private
    #
    def config_file
      @config_file ||= project.config_dir.join(self.class::FILE).freeze
    end

    # Test if the task is enabled
    #
    # If there is no config file, and no sensible defaults, then the rake task
    # should become disabled.
    #
    # @return [Boolean]
    #
    # @api private
    #
    def enabled?
      !raw.equal?(DEFAULT_CONFIG)
    end

    private

    # Return raw data
    #
    # @return [Hash]
    #
    # @api private
    #
    def raw
      @raw ||= yaml_config || DEFAULT_CONFIG
    end

    # Return the raw config data from a yaml file
    #
    # @return [Hash]
    #   returned if the yaml file is found
    # @return [nil]
    #   returned if the yaml file is not found
    #
    # @api private
    #
    def yaml_config
      config_file = self.config_file
      YAML.load_file(config_file).freeze if config_file.file?
    end

    # Rubocop configuration
    class Rubocop < self
      FILE = 'rubocop.yml'.freeze
    end # Rubocop

    # Reek configuration
    class Reek < self
      FILE = 'reek.yml'.freeze
    end # Reek

    # Flay configuration
    class Flay < self
      FILE = 'flay.yml'.freeze

      attribute :total_score
      attribute :threshold
    end # Flay

    # Yardstick configuration
    class Yardstick < self
      FILE    = 'yardstick.yml'.freeze
      OPTIONS = %w[
        threshold
        rules
        verbose
        path
        require_exact_threshold
      ].freeze

      # Options hash that Yardstick understands
      #
      # @return [Hash]
      #
      # @api private
      def options
        OPTIONS.each_with_object({}) { |name, hash|
          hash[name] = raw.fetch(name, nil)
        }
      end
    end # Yardstick

    # Flog configuration
    class Flog < self
      FILE = 'flog.yml'.freeze

      attribute :total_score
      attribute :threshold
    end # Flog

    # Mutant configuration
    class Mutant < self
      FILE             = 'mutant.yml'.freeze
      DEFAULT_NAME     = ''.freeze
      DEFAULT_STRATEGY = '--rspec'.freeze

      attribute :name, DEFAULT_NAME
      attribute :namespace
      attribute :strategy, DEFAULT_STRATEGY
    end # Mutant

    # Triage configuration
    class Triage < self
      FILE = 'triage.yml'.freeze
      DEFAULT_UNIT_TEST_TIMEOUT = 0.1  # 100ms
      DEFAULT_BRANCHES_TO_FAIL_ON = [MASTER_BRANCH]

      attribute :unit_test_timeout, DEFAULT_UNIT_TEST_TIMEOUT
      attribute :fail_on_branch, DEFAULT_BRANCHES_TO_FAIL_ON
    end # Triage

  end # Config
end # Triage