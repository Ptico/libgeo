# encoding: utf-8

require 'spec_helper'

describe Libgeo::Latitude do
  let(:instance) { described_class.new(hemi, degrees, minutes, seconds) }

  let(:hemi)    { Libgeo::NORTH }
  let(:degrees) { 48 }
  let(:minutes) { 04 }
  let(:seconds) { 15.7836 }

  let(:decimal) { 48.071051 }

  describe '.decimal' do
    subject { described_class.decimal(decimal) }

    context 'when positive' do
      it { expect(subject.hemisphere).to eql(hemi) }
      it { expect(subject.degrees).to eql(degrees) }
      it { expect(subject.minutes).to eql(minutes) }
      it { expect(subject.seconds).to eql(seconds) }
    end

    context 'when negative' do
      let(:decimal) { -48.071051 }

      it { expect(subject.hemisphere).to eql(Libgeo::SOUTH) }
      it { expect(subject.degrees).to eql(degrees) }
      it { expect(subject.minutes).to eql(minutes) }
      it { expect(subject.seconds).to eql(seconds) }
    end
  end

  describe '.dms' do
    subject { described_class.dms(dms) }

    context 'with characters' do
      context 'when positive' do
        let(:dms) { '58°39′13.5 N' }

        it { expect(subject.hemisphere).to eql(Libgeo::NORTH) }
        it { expect(subject.degrees).to eql(58) }
        it { expect(subject.minutes).to eql(39) }
        it { expect(subject.seconds).to eql(13.5) }
      end

      context 'when negative' do
        let(:dms) { '58°39′13.5 S' }

        it { expect(subject.hemisphere).to eql(Libgeo::SOUTH) }
        it { expect(subject.degrees).to eql(58) }
        it { expect(subject.minutes).to eql(39) }
        it { expect(subject.seconds).to eql(13.5) }
      end
    end

    context 'without characters' do
      context 'when positive' do
        let(:dms) { '58°39′13.5' }

        it { expect(subject.hemisphere).to eql(Libgeo::NORTH) }
        it { expect(subject.degrees).to eql(58) }
        it { expect(subject.minutes).to eql(39) }
        it { expect(subject.seconds).to eql(13.5) }
      end

      context 'when negative' do
        let(:dms) { '-58°39′13.5' }

        it { expect(subject.hemisphere).to eql(Libgeo::SOUTH) }
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
        let(:nmea) { '03920.56074,N' }

        it { expect(subject.hemisphere).to eql(Libgeo::NORTH) }
        it { expect(subject.degrees).to eql(39) }
        it { expect(subject.minutes).to eql(20) }
        it { expect(subject.seconds).to eql(33.6444) }
      end

      context 'when negative' do
        let(:nmea) { '03920.56074,S' }

        it { expect(subject.hemisphere).to eql(Libgeo::SOUTH) }
        it { expect(subject.degrees).to eql(39) }
        it { expect(subject.minutes).to eql(20) }
        it { expect(subject.seconds).to eql(33.6444) }
      end
    end

    context 'without characters' do
      context 'when positive' do
        let(:nmea) { '+03920.56074' }

        it { expect(subject.hemisphere).to eql(Libgeo::NORTH) }
        it { expect(subject.degrees).to eql(39) }
        it { expect(subject.minutes).to eql(20) }
        it { expect(subject.seconds).to eql(33.6444) }
      end

      context 'when negative' do
        let(:nmea) { '-03920.56074' }

        it { expect(subject.hemisphere).to eql(Libgeo::SOUTH) }
        it { expect(subject.degrees).to eql(39) }
        it { expect(subject.minutes).to eql(20) }
        it { expect(subject.seconds).to eql(33.6444) }
      end
    end
  end

  describe '.degrees_minutes' do
    subject { described_class.degrees_minutes(degrees, 4.26306) }

    context 'when positive' do
      it { expect(subject.hemisphere).to eql(hemi) }
      it { expect(subject.degrees).to eql(degrees) }
      it { expect(subject.minutes).to eql(minutes) }
      it { expect(subject.seconds).to eql(seconds) }
    end

    context 'when negative' do
      let(:degrees) { -48 }

      it { expect(subject.hemisphere).to eql(Libgeo::SOUTH) }
      it { expect(subject.degrees).to eql(48) }
      it { expect(subject.minutes).to eql(minutes) }
      it { expect(subject.seconds).to eql(seconds) }
    end
  end

  describe '#type' do
    subject { instance.type }

    it { expect(subject).to equal(:latitude) }
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
      let(:hemisphere) { :S }
    end
  end

  describe 'values validation' do
    it_behaves_like 'Coordinate#validation' do
      let(:max_degrees) { 90 }
    end
  end

  describe '#hemisphere' do
    subject { instance.hemisphere }

    describe 'Northen' do
      context 'when symbol' do
        it { expect(subject).to eql(:N) }
      end

      context 'when string' do
        let(:hemi) { 'N' }

        it { expect(subject).to eql(:N) }
      end

      context 'when direction' do
        let(:hemi) { :> }

        it { expect(subject).to eql(:N) }
      end

      context 'when word' do
        let(:hemi) { 'north' }

        it { expect(subject).to eql(:N) }
      end
    end

    describe 'Southern' do
      context 'when symbol' do
        let(:hemi) { Libgeo::SOUTH }

        it { expect(subject).to eql(:S) }
      end

      context 'when string' do
        let(:hemi) { 'S' }

        it { expect(subject).to eql(:S) }
      end

      context 'when direction' do
        let(:hemi) { :< }

        it { expect(subject).to eql(:S) }
      end

      context 'when word' do
        let(:hemi) { 'south' }

        it { expect(subject).to eql(:S) }
      end
    end
  end

  describe '#north!' do
    let(:hemi) { Libgeo::SOUTH }

    it { expect { instance.north! }.to change { instance.hemisphere }.from(:S).to(:N) }
  end

  describe '#south!' do
    let(:hemi) { Libgeo::NORTH }

    it { expect { instance.south! }.to change { instance.hemisphere }.from(:N).to(:S) }
  end

  describe '#west!' do
    let(:hemi) { Libgeo::NORTH }

    it { expect { instance.west! }.to_not change { instance.hemisphere } }
  end

  describe '#east!' do
    it { expect { instance.east! }.to_not change { instance.hemisphere } }
  end

  describe '#north?' do
    subject { instance.north? }

    context 'when north' do
      it { expect(subject).to be_truthy }
    end

    context 'when south' do
      let(:hemi) { Libgeo::SOUTH }

      it { expect(subject).to be_falsy }
    end
  end

  describe '#south?' do
    subject { instance.south? }

    context 'when north' do
      it { expect(subject).to be_falsy }
    end

    context 'when south' do
      let(:hemi) { Libgeo::SOUTH }

      it { expect(subject).to be_truthy }
    end
  end

  describe '#west?' do
    subject { instance.west? }

    context 'when north' do
      it { expect(subject).to be_falsy }
    end

    context 'when south' do
      let(:hemi) { Libgeo::SOUTH }

      it { expect(subject).to be_falsy }
    end
  end

  describe '#east?' do
    subject { instance.east? }

    context 'when north' do
      it { expect(subject).to be_falsy }
    end

    context 'when south' do
      let(:hemi) { Libgeo::SOUTH }

      it { expect(subject).to be_falsy }
    end
  end

  describe '#to_f' do
    subject { instance.to_f }

    context 'when north' do
      it { expect(subject).to eql(decimal) }
    end

    context 'when south' do
      let(:hemi) { Libgeo::SOUTH }

      it { expect(subject).to eql(-1 * decimal) }
    end
  end

  describe '#to_hash' do
    it_behaves_like 'Coordinate#to_hash'
  end

  describe '#to_dms' do
    subject { instance.to_dms }

    context 'when north' do
      it { expect(subject).to eql(%[48°04′15.7836″N]) }
    end

    context 'when south' do
      let(:hemi) { Libgeo::SOUTH }

      it { expect(subject).to eql(%[48°04′15.7836″S]) }
    end
  end

  describe '#to_nmea' do
    subject { instance.to_nmea }

    context 'when north' do
      it { expect(subject).to eql('4804.26306,N') }
    end

    context 'when south' do
      let(:hemi) { Libgeo::SOUTH }

      it { expect(subject).to eql('4804.26306,S') }
    end
  end

  describe '#to_s' do
    context 'default format' do
      subject { instance.to_s }

      context 'when north' do
        it { expect(subject).to eql(%[48°04′15.7836″N]) }
      end

      context 'when south' do
        let(:hemi) { Libgeo::SOUTH }

        it { expect(subject).to eql(%[48°04′15.7836″S]) }
      end
    end
  end

  describe '#inspect' do
    subject { instance.inspect }
    let(:expected) { "#<Libgeo::Latitude hemisphere=N degrees=48 minutes=4 seconds=15.7836>" }

    it { expect(subject).to eql(expected) }
  end

  describe '#to_utm' do
    pending 'TODO'
  end

end
