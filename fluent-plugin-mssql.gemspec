# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-mssql"
  spec.version       = "0.0.2"
  spec.authors       = ["Hidemasa Togashi"]
  spec.email         = ["togachiro@gmail.com"]
  spec.summary       = %q{Fluentd plugin to insert into Microsoft SQL Server.}
  spec.description   = %q{Fluentd plugin to insert into Microsoft SQL Server.}
  spec.homepage      = "http://github.com/htgc/fluent-plugin-mssql/fork"
  spec.license       = "Apache Lisence version 2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "dbi"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
