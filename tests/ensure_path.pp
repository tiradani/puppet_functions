class mkdir_p {
  $test_path = '/tmp/ensure_path/testing123'
  notify { "Before ensure_path :: test_path: ${test_path}": }
  ensure_path($test_path)
  notify { "After ensure_path :: test_path: ${test_path}": }

  File['/tmp/ensure_path'] {
    owner => 'puppet',
  }
  File['/tmp/ensure_path/testing123'] {
    owner => 'puppet',
    group => 'puppet',
  }
}

class { 'mkdir_p': }
