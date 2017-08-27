class MssqlOutput < Fluent::BufferedOutput
  Fluent::Plugin.register_output('mssql', self)

  include Fluent::SetTimeKeyMixin
  include Fluent::SetTagKeyMixin

  config_param :odbc_label, :string, :default => nil
  config_param :username, :string
  config_param :password, :string

  config_param :key_names, :string, :default => nil # nil allowed for json format
  config_param :sql, :string, :default => nil
  config_param :table, :string, :default => nil
  config_param :columns, :string, :default => nil

  config_param :format, :string, :default => 'raw' # raw or json

  attr_accessor :handler

  def initialize
    super
    require 'dbi'
  end

  def configure(conf)
    super

    if @format == 'json'
      @format_proc = Proc.new{|tag, time, record| record.to_json}
    else
      @key_names = @key_names.split(',')
      @format_proc = Proc.new{|tag, time, record| @key_names.map{|k| record[k]}}
    end

    if @columns.nil? and @sql.nil?
      raise Fluent::ConfigError, "columns or sql MUST be specified, but missing"
    end

    if @sql.nil?
      raise Fluent::ConfigError, "table missing" unless @table

      @columns = @columns.split(',').map(&:strip)
      cols = @columns.join(',')
      placeholders = if @format == 'json'
                       '?'
                     else
                       @key_names.map{|k| '?'}.join(',')
                     end
      @sql = "INSERT INTO #{@table} (#{cols}) VALUES (#{placeholders})"
    end
  end

  def start
    super
  end

  def shutdown
    super
  end

  def format(tag, time, record)
    tmp = [tag, time, @format_proc.call(tag, time, record)]
    mp = tmp.to_msgpack
    mp
  end

  def client
    if @odbc_label.nil?
      raise Fluent::ConfigError, "odbc_label MUST be specified, but missing"
    else
      begin
        dbh = DBI.connect("dbi:ODBC:#{@odbc_label}", @username, @password)
      rescue
        raise Fluent::ConfigError, "Cannot open database, check user or password"
      end
    end
    dbh
  end

  def write(chunk)
    handler = self.client
    chunk.msgpack_each { |tag, time, data|
      begin
        query = handler.prepare(@sql)
        num = 1
        data.each { |d|
          query.bind_param(num, d)
          num += 1
        }
        query.execute
      rescue
        raise Fluent::ConfigError, "SQL Execute Error #{@sql} - #{data}"
      end
    }
    handler.disconnect
  end
end
