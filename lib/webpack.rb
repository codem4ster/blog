require 'json'

# Get the asset URLs from the manifest file created by the webpack.
#   File name gives the path to the file when queried.
class Webpack
  MANIFEST_PATH = Rails.root.join('config', 'webpack_manifest.json')

  # read manifest file and cache the manifest hash data.
  def initialize
    json_string = File.read(MANIFEST_PATH)
    @manifest = JSON.parse json_string
  end

  # gives the asset path of the required file
  # @param [string] file_path relative path
  # @return [string] if manifest includes file path it returns asset_path
  #   else it returns file_path without warning
  def asset_path(file_path)
    @manifest.fetch(file_path, file_path)
  end
end

