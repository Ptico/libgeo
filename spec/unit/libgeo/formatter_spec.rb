require 'spec_helper'

describe Libgeo::Formatter do
  let(:instance) { described_class.new(pattern) }
  let(:pattern)  { '%d°%2m′' }

  describe '#format' do
    subject { instance.format(coord) }

    let(:coord) { instance_double('Libgeo::Latitude') }

    before do
      allow(coord).to receive(:deg).and_return(48)
      allow(coord).to receive(:mins).and_return(4)
    end

    it { expect(subject).to eql('48°04′') }
  end

  describe '#pattern' do
    subject { instance.pattern }

    it { expect(subject).to eql(pattern) }
  end

  describe '#inspect' do
    subject { instance.inspect }

    it { expect(subject).to eql('#<Libgeo::Formatter pattern=(%d°%2m′)>') }
  end

end
