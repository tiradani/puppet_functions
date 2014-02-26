#! /usr/bin/env ruby

require 'spec_helper'
require 'rspec-puppet'

describe 'create_path' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  describe 'argument handling' do
    it 'fails with no arguments' do
      should run.with_params().and_raise_error(Puppet::ParseError)
    end
    it 'requires an string' do
      should run.with_params('/tmp/foo').should_not raise_error
    end
  end
end
