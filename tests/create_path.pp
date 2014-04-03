class mkdir_p {
  $test_path = '/tmp/create_path/testing123'
  notify { "Before create_path :: test_path: ${test_path}": }
  create_path($test_path)
  notify { "After create_path :: test_path: ${test_path}": }

  File['/tmp/create_path'] {
    owner => 'puppet',
  }
  File['/tmp/create_path/testing123'] {
    owner => 'puppet',
    group => 'puppet',
  }
}

class { 'mkdir_p': }
