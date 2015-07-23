require 'yaml'
require 'fileutils'
require 'set'
require 'json'

# Copyright Neville Kadwa (2014)

class MysqlConn

  MODE_MYSQL = :MYSQL
  MODE_MYSQLDUMP = :MYSQLDUMP
  CONFIG_LOCATION=File.expand_path("~/.db_connection_alias.yml")

  attr_reader :mode
  attr_reader :config
  attr_reader :verbose
  attr_reader :db_key

  def initialize(mode)
    @mode = mode
    @verbose = false
  end

  def mode_command
    case mode
      when :MYSQL
        "mysql"
      when :MYSQLDUMP
        "mysqldump"
      else
        raise "Unknown mode: #{mode}"
    end
  end

  def mode_default_args(args)
    case mode
      when :MYSQL
        "--prompt=\"\\u@#{db_key} [\\d]> \" " <<
        if config['config'] && config['config']['default_arg'] && config['config']['default_arg']['mysql']
          config['config']['default_arg']['mysql']
        else
          ""
        end

      when :MYSQLDUMP
        if config['config'] && config['config']['default_arg'] && config['config']['default_arg']['mysqldump']
          config['config']['default_arg']['mysqldump']
        else
          ""
        end
      else
        raise "Unknown mode: #{mode}"
    end
  end

  def run(args)

    @db_key = args.shift || raise('no db key provided. Usage mysqlconn db_key [mysql opts]*')

    @config = begin
      File.open(CONFIG_LOCATION, 'r') do |f|
        YAML.load(f)
      end
    rescue Errno::ENOENT => e
      raise("No config found. Please follow instructions for creating #{CONFIG_LOCATION}")
    end
    raise("Config file is world readable. Exiting...") if File.stat(CONFIG_LOCATION).world_readable?

    if db_key == '-v'
      @verbose = true
      @db_key = args.shift
    end
    if db_key == '-l'
      filter = /.*#{args.shift||'.*'}.*/
      config.keys.each do |k|
        if k != 'config' && filter =~ k
          puts k
        end
      end
      exit(0)
    end
    # Leaving -c (configuration) option undocumented. Extract config hash for other applications to use.
    if db_key == '-c'
      @db_key = args.shift || raise('no db key provided. Usage for configuration: mysqlconn -c db_key')
      db = config[db_key] || raise("No #{db_key} found")
      puts JSON.pretty_generate(config[db_key])
      exit(0)
    end


    db = config[db_key] || raise("No #{db_key} found")

    db['host'] || raise("No #{db_key}.host found")

    command = ""

    command << "MYSQL_PWD=#{db['password']} " if db['password']

    command << "#{mode_command} -h #{db['host']} #{mode_default_args(args)}"

    command << " -P #{db['port']}" if db['port']
    command << " -u #{db['user']}" if db['user']
    if db['database'] && mode == :MYSQL
      case mode
        when :MYSQL
          command << " -D #{db['database']}"
        when :MYSQLDUMP
          command << " #{db['database']}"
      end
    end
    unless args.empty?
      command << " "
      command << args.map{|s| "'#{s}'"}.join(' ')
    end

    STDERR.puts command if verbose
    exec(command)

  end

end
