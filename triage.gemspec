# encoding: utf-8

Gem::Specification.new do |gem|
  gem.name        = 'triage'
  gem.version     = '0.0.2'
  gem.authors     = [ 'Markus Schirp' ]
  gem.email       = [ 'mbj@schirp-dso.com' ]
  gem.description = 'A metagem for ROM-style development'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/rom-rb/triage'
  gem.license     = 'MIT'

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files`.split($/)
  gem.executables      = %w[triage]
  gem.test_files       = `git ls-files -- spec`.split($/)
  gem.extra_rdoc_files = %w[README.md TODO]

  # development
  gem.add_development_dependency 'triage-deps',  '~> 0.0.2'
end