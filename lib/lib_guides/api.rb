require 'faraday'
require 'json'
require 'lib_guides/version'
require 'lib_guides/api/base'
require 'lib_guides/api/error'
require 'lib_guides/api/az/list'
require 'lib_guides/api/az/asset'

module LibGuides
  module API
    API_VERSION = "1.2"
  end
end
