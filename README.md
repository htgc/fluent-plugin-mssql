# Fluent::Plugin::Mssql

Fluentd plugin to insert into Microsoft SQL Server.

## Requirement

You should install and setup following packages;

- unixODBC [http://www.unixodbc.org/]
- freeTDS [http://www.freetds.org/]

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-mssql'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-mssql

## Usage

```
<match insert.into.mssql>
    type mssql
    odbc_label <OdbcLabel>
    username <username>
    password <password>
    key_names status,bytes,vhost,path,rhost,agent,referer
    sql INSERT INTO access_log (status,bytes,vhost,path,rhost,agent,referer) VALUES (?,?,?,?,?,?,?)
    flush_interval 5s
</match>
```

## LISENCE

- Apache License, Version 2.0

## Contributing

1. Fork it ( http://github.com/htgc/fluent-plugin-mssql/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
