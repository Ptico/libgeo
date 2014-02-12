require 'spec_helper'

describe Libgeo::Coordinate do
  let(:instance) { described_class.new(hemi, degrees, minutes, seconds) }

  let(:hemi)    { nil }
  let(:degrees) { 39 }
  let(:minutes) { 20 }
  let(:seconds) { 33.6444 }

end
