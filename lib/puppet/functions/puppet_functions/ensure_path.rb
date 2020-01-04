# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# ensure_path.rb
#
require 'puppet/parser/functions'

# ---- original file header ----
#
# @summary
#       Emulates the linux mkdir -p command by parsing a string containing the full path
#    to a child directory and ensuring that each parent exists.args  The path is
#    converted into a set of files resources and added to the catalog.
#
#    This function takes one mandatory argument: a string containing the full path to the
#    directory.
#
#    mkdir_p("/storage/local/data1")
#
#    Note: This function will create the directories if needed, but not purge them.
#    Any special permissions must be overridden afterwards.
#
#
Puppet::Functions.create_function(:'puppet_functions::ensure_path') do
  # @param args
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :args
  end


  def default_impl(*args)
    

    raise ArgumentError, ("ensure_path(): wrong number of arguments (#{args.length}; must be 1)") if args.length != 1

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
