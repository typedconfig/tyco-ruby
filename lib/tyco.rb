require 'json'
require_relative 'tyco/version'
ext_dir = File.expand_path('../ext/tyco_ext', __dir__)
$LOAD_PATH.unshift(ext_dir) unless $LOAD_PATH.include?(ext_dir)
require 'tyco_ext'

module Tyco
  module_function

  def load_file(path)
    raise ArgumentError, 'path is required' unless path
    json = TycoNative.load_file_json(path.to_s)
    JSON.parse(json)
  end

  def load_string(content, name = '<string>')
    raise ArgumentError, 'content is required' unless content
    json = TycoNative.load_string_json(content.to_s, name.to_s)
    JSON.parse(json)
  end
end
