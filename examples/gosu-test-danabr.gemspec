# Ruby 2.4.4

Gem::Specification.new do |s|
  s.name        = 'gosu-test-danabr'
  s.version     = '0.0.10'
  s.date        = '2018-05-24'
  s.summary     = "Hola!"
  s.description = "A simple gosu test"
  s.authors     = ["Ben Dana"]
  s.email       = 'benrdana@gmail.com'
  s.executables   = ["gosu-test.sh"]
  s.files       = Dir['gosu-test/lib/**/*'] + Dir['gosu-test/media/**/*'] + Dir['gosu-test/*']
  s.homepage    =
    'http://rubygems.org/gems/hola'
  s.license       = 'MIT'
  # s.add_development_dependency 'gosu', '0.13.3'
  # s.add_development_dependency 'opengl', '0.10.0'
  s.add_development_dependency 'ocra', '1.3.10'
  s.add_runtime_dependency 'gosu', '0.13.3'
  s.add_runtime_dependency 'opengl', '0.10.0'
end