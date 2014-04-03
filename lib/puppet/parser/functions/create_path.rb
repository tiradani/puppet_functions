#
# create_parser.rb
#
require 'puppet/parser/functions'

module Puppet::Parser::Functions
  newfunction(:create_path, :doc => <<-EOS
    Emulates the linux mkdir -p command by parsing a string containing the full path
    to a child directory and ensuring that each parent exists.args  The path is
    converted into a set of files resources and added to the catalog.

    This function takes one mandatory argument: a string containing the full path to the
    directory.

    mkdir_p("/storage/local/data1")

    Note: This function will create the directories if needed, but not purge them.args
    Any special permissions must be overridden afterwards.
    EOS
  ) do |args|

    raise ArgumentError, ("create_path(): wrong number of arguments (#{args.length}; must be 1)") if args.length != 1

    # Make a "shallow copy" of the path.  If we don't, we actually modify the supposedly immutable variable
    # (if a variable is passed to this function)
    full_path = args[0].to_s.dup
    Puppet::Parser::Functions.function(:validate_absolute_path)
    function_validate_absolute_path([full_path])
    # Strip leading slash
    # http://stackoverflow.com/questions/3614389/what-is-the-easiest-way-to-remove-the-first-character-from-a-string
    if full_path.each_char.first == "/" then
      full_path.slice!(0)
    end

    # iterate through the full path to create an array of parent directories
    # Example:
    #   given:
    #     full_path = "/storage/local/data1"
    #   output:
    #     path_array = [ "/storage", "/storage/local", "/storage/local/data1"]
    path_array = []
    full_path.split("/").each.with_index() do | elem, i |
      if path_array.length == 0 then
        path_array << "/#{elem}"
      else
        path_array << "#{path_array[i -1]}/#{elem}"
      end
    end

    # iterate through the resources to create
    path_array.each do | directory |
      params = {'ensure' => 'directory' }
      Puppet::Parser::Functions.function(:defined_with_params)
      if !function_defined_with_params(["File[#{directory}]", params]) then
        # This directory resource has not already been added to the catalog, so add it
        Puppet::Parser::Functions.function(:create_resources)
        function_create_resources(["File", { directory => params }])
      end
    end
  end
end
