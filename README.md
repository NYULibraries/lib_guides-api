# LibGuides::API

[![NYU](https://github.com/NYULibraries/nyulibraries-assets/blob/master/lib/assets/images/nyu.png)](https://dev.library.nyu.edu)
[![Build Status](https://travis-ci.org/NYULibraries/lib_guides-api.svg)](https://travis-ci.org/NYULibraries/lib_guides-api)
[![Code Climate](https://codeclimate.com/github/NYULibraries/lib_guides-api/badges/gpa.svg)](https://codeclimate.com/github/NYULibraries/lib_guides-api)
[![Coverage Status](https://coveralls.io/repos/github/NYULibraries/lib_guides-api/badge.svg)](https://coveralls.io/github/NYULibraries/lib_guides-api)

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
