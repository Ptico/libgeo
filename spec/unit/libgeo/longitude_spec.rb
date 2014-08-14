# encoding: utf-8

require 'spec_helper'

describe Libgeo::Longitude do
  let(:instance) { described_class.new(hemi, degrees, minutes, seconds) }

  let(:hemi)    { Libgeo::EAST }
  let(:degrees) { 39 }
  let(:minutes) { 20 }
  let(:seconds) { 33.6444 }

  let(:decimal) { 39.342679 }

  describe '.decimal' do
    subject { described_class.decimal(decimal) }

    context 'when positive' do
      it { expect(subject.hemisphere).to eql(hemi) }
      it { expect(subject.degrees).to eql(degrees) }
      it { expect(subject.minutes).to eql(minutes) }
      it { expect(subject.seconds).to eql(seconds) }
    end

    context 'when negative' do
      let(:decimal) { -39.342679 }

      it { expect(subject.hemisphere).to eql(Libgeo::WEST) }
      it { expect(subject.degrees).to eql(degrees) }
      it { expect(subject.minutes).to eql(minutes) }
      it { expect(subject.seconds).to eql(seconds) }
    end
  end

  describe '.dms' do
    subject { described_class.dms(dms) }

    context 'with characters' do
      context 'when positive' do
        let(:dms) { '58°39′13.5 E' }

        it { expect(subject.hemisphere).to eql(Libgeo::EAST) }
        it { expect(subject.degrees).to eql(58) }
        it { expect(subject.minutes).to eql(39) }
        it { expect(subject.seconds).to eql(13.5) }
      end

      context 'when negative' do
        let(:dms) { '58°39′13.5 W' }

        it { expect(subject.hemisphere).to eql(Libgeo::WEST) }
        it { expect(subject.degrees).to eql(58) }
        it { expect(subject.minutes).to eql(39) }
        it { expect(subject.seconds).to eql(13.5) }
      end
    end

    context 'without characters' do
      context 'when positive' do
        let(:dms) { '58°39′13.5' }

        it { expect(subject.hemisphere).to eql(Libgeo::EAST) }
        it { expect(subject.degrees).to eql(58) }
        it { expect(subject.minutes).to eql(39) }
        it { expect(subject.seconds).to eql(13.5) }
      end

      context 'when negative' do
        let(:dms) { '-58°39′13.5' }

        it { expect(subject.hemisphere).to eql(Libgeo::WEST) }
        it { expect(subject.degrees).to eql(58) }
        it { expect(subject.minutes).to eql(39) }
        it { expect(subject.seconds).to eql(13.5) }
      end
    end
  end

  describe '.nmea' do
    subject { described_class.nmea(nmea) }

    context 'with characters' do
      context 'when positive' do
        let(:nmea) { '03920.56074,E' }

        it { expect(subject.hemisphere).to eql(Libgeo::EAST) }
        it { expect(subject.degrees).to eql(39) }
        it { expect(subject.minutes).to eql(20) }
        it { expect(subject.seconds).to eql(33.6444) }
      end

      context 'when negative' do
        let(:nmea) { '03920.56074,W' }

        it { expect(subject.hemisphere).to eql(Libgeo::WEST) }
        it { expect(subject.degrees).to eql(39) }
        it { expect(subject.minutes).to eql(20) }
        it { expect(subject.seconds).to eql(33.6444) }
      end
    end

    context 'without characters' do
      context 'when positive' do
        let(:nmea) { '+03920.56074' }

        it { expect(subject.hemisphere).to eql(Libgeo::EAST) }
        it { expect(subject.degrees).to eql(39) }
        it { expect(subject.minutes).to eql(20) }
        it { expect(subject.seconds).to eql(33.6444) }
      end

      context 'when negative' do
        let(:nmea) { '-03920.56074' }

        it { expect(subject.hemisphere).to eql(Libgeo::WEST) }
        it { expect(subject.degrees).to eql(39) }
        it { expect(subject.minutes).to eql(20) }
        it { expect(subject.seconds).to eql(33.6444) }
      end
    end
  end
  describe '.degrees_minutes' do
    subject { described_class.degrees_minutes(degrees, 20.56074) }

    context 'when positive' do
      it { expect(subject.hemisphere).to eql(hemi) }
      it { expect(subject.degrees).to eql(degrees) }
      it { expect(subject.minutes).to eql(minutes) }
      it { expect(subject.seconds).to eql(seconds) }
    end

    context 'when negative' do
      let(:degrees) { -39 }

      it { expect(subject.hemisphere).to eql(Libgeo::WEST) }
      it { expect(subject.degrees).to eql(39) }
      it { expect(subject.minutes).to eql(minutes) }
      it { expect(subject.seconds).to eql(seconds) }
    end
  end

  describe '#type' do
    subject { instance.type }

    it { expect(subject).to equal(:longitude) }
  end

  describe '#degrees' do
    it_behaves_like 'Coordinate#degrees'
  end

  describe '#minutes' do
    it_behaves_like 'Coordinate#minutes'
  end

  describe '#seconds' do
    it_behaves_like 'Coordinate#seconds'
  end

  describe 'different inputs' do
    it_behaves_like 'Coordinate#inputs' do
      let(:hemisphere) { :E }
    end
  end

  describe 'values validation' do
    it_behaves_like 'Coordinate#validation' do
      let(:max_degrees) { 180 }
    end
  end

  describe '#hemisphere' do
    subject { instance.hemisphere }

    describe 'Eastern' do
      context 'when symbol' do
        it { expect(subject).to eql(:E) }
      end

      context 'when string' do
        let(:hemi) { 'E' }

        it { expect(subject).to eql(:E) }
      end

      context 'when direction' do
        let(:hemi) { :> }

        it { expect(subject).to eql(:E) }
      end

      context 'when word' do
        let(:hemi) { 'east' }

        it { expect(subject).to eql(:E) }
      end
    end

    describe 'Western' do
      context 'when symbol' do
        let(:hemi) { Libgeo::WEST }

        it { expect(subject).to eql(:W) }
      end

      context 'when string' do
        let(:hemi) { 'W' }

        it { expect(subject).to eql(:W) }
      end

      context 'when direction' do
        let(:hemi) { :< }

        it { expect(subject).to eql(:W) }
      end

      context 'when word' do
        let(:hemi) { 'west' }

        it { expect(subject).to eql(:W) }
      end
    end
  end

  describe '#north!' do
    let(:hemi) { Libgeo::WEST }

    it { expect { instance.north! }.to_not change { instance.hemisphere } }
  end

  describe '#south!' do
    let(:hemi) { Libgeo::WEST }

    it { expect { instance.south! }.to_not change { instance.hemisphere } }
  end

  describe '#west!' do
    it { expect { instance.west! }.to change { instance.hemisphere }.from(:E).to(:W) }
  end

  describe '#east!' do
    let(:hemi) { Libgeo::WEST }

    it { expect { instance.east! }.to change { instance.hemisphere }.from(:W).to(:E) }
  end

  describe '#north?' do
    subject { instance.north? }

    context 'when east' do
      it { expect(subject).to be_falsy }
    end

    context 'when west' do
      let(:hemi) { Libgeo::WEST }

      it { expect(subject).to be_falsy }
    end
  end

  describe '#south?' do
    subject { instance.south? }

    context 'when east' do
      it { expect(subject).to be_falsy }
    end

    context 'when west' do
      let(:hemi) { Libgeo::WEST }

      it { expect(subject).to be_falsy }
    end
  end

  describe '#west?' do
    subject { instance.west? }

    context 'when east' do
      it { expect(subject).to be_falsy }
    end

    context 'when west' do
      let(:hemi) { Libgeo::WEST }

      it { expect(subject).to be_truthy }
    end
  end

  describe '#east?' do
    subject { instance.east? }

    context 'when east' do
      it { expect(subject).to be_truthy }
    end

    context 'when west' do
      let(:hemi) { Libgeo::WEST }

      it { expect(subject).to be_falsy }
    end
  end

  describe '#to_f' do
    subject { instance.to_f }

    context 'when east' do
      it { expect(subject).to eql(decimal) }
    end

    context 'when west' do
      let(:hemi) { Libgeo::WEST }

      it { expect(subject).to eql(-decimal) }
    end
  end

  describe '#to_hash' do
    it_behaves_like 'Coordinate#to_hash'
  end

  describe '#to_dms' do
    subject { instance.to_dms }

    context 'when east' do
      it { expect(subject).to eql(%[39°20′33.6444″E]) }
    end

    context 'when west' do
      let(:hemi) { Libgeo::WEST }

      it { expect(subject).to eql(%[39°20′33.6444″W]) }
    end
  end

  describe '#to_nmea' do
    subject { instance.to_nmea }

    context 'when east' do
      it { expect(subject).to eql('03920.56074,E') }
    end

    context 'when west' do
      let(:hemi) { Libgeo::WEST }

      it { expect(subject).to eql('03920.56074,W') }
    end
  end

  describe '#to_s' do
    context 'default format' do
      subject { instance.to_s }

      context 'when east' do
        it { expect(subject).to eql(%[39°20′33.6444″E]) }
      end

      context 'when west' do
        let(:hemi) { Libgeo::WEST }

        it { expect(subject).to eql(%[39°20′33.6444″W]) }
      end
    end
  end

  describe '#inspect' do
    subject { instance.inspect }
    let(:expected) { "#<Libgeo::Longitude hemisphere=E degrees=39 minutes=20 seconds=33.6444>" }

    it { expect(subject).to eql(expected) }
  end

  describe '#to_utm' do
    pending 'TODO'
  end

end
