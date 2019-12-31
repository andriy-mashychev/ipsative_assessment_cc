require "json"
require "ostruct"

module Ipsative
  class Dimension < OpenStruct
  end

  DIMENSIONS = JSON.parse(
    File.read(File.join(__dir__, '../../data/dimensions.json')),
    object_class: Dimension
  ).map! { |dimension_obj| dimension_obj.freeze }.freeze
end
