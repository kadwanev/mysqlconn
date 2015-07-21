# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'mysqlconn'
  s.version     = '0.0.6'
  s.summary     = "mysql command line configuration assistant"
  s.description = "Save your various database credentials to a configuration file and zip around easily"
  s.authors     = ["Neville Kadwa"]
  s.email       = ["neville@kadwa.com"]
  s.files       = Dir['lib/**/*.rb'] + Dir['bin/*'] + Dir['[A-Z]*']
  s.test_files  = Dir['test/**/*']
  s.executables = Dir['bin/**/*'].map{|f| File.basename(f)}
  s.homepage    = 'http://github.com/kadwanev/mysqlconn'
  s.licenses    = ['Apache-2.0']
end
