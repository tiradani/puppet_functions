class mkdir_p {
  create_path('/tmp/create_path/testing123')

  File['/tmp/create_path'] {
    owner => 'puppet',
  }
  File['/tmp/create_path/testing123'] {
    owner => 'puppet',
    group => 'puppet',
  }
}

class { 'mkdir_p': }
