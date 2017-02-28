# LibGuides::API

Ruby client for LibGuides API

## Installation

```
gem 'lib_guides-api', github: "NYULibraries/lib_guides-api"
require 'lib_guides/api'
```

You must set `LIB_GUIDES_CLIENT_ID` and `LIB_GUIDES_CLIENT_SECRET` environment variables.

## Usage

Get an A-Z list of all assets:

```
list = LibGuides::API::Az::List.new
list.load
list.each do |asset|
  puts asset.name
end
```

Update assets:

```
list.each do |asset|
  asset.name = "My Name: #{asset.name}"
  asset.save
end
```

Create an asset:

```
asset = LibGuides::API::Az::Asset.new name: "New Name", owner_id: 1, type_id: 1
asset.save
```
