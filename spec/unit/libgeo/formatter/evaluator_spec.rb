# encoding: utf-8

require 'spec_helper'

describe Libgeo::Formatter::Evaluator do
  let(:instance)   { described_class.new(coordinate) }
  let(:coordinate) { double('Latitude') }

  describe '#pad' do
    subject { instance.pad(val, num) }

    describe 'Integers' do
      let(:num) { 3 }

      context 'as Fixnum' do
        let(:val) { 42 }

        it { expect(subject).to eql('042') }
      end

      context 'as String' do
        let(:val) { '42' }

        it { expect(subject).to eql('042') }
      end

      context 'when int length and num equals' do
        let(:val) { '142' }

        it { expect(subject).to eql(val) }
      end

      context 'when int length more than num' do
        let(:val) { '1986' }

        it { expect(subject).to eql(val) }
      end
    end

    describe 'Floats' do
      let(:num) { 2 }

      context 'as Float' do
        let(:val) { 3.14 }

        it { expect(subject).to eql('03.14') }
      end

      context 'as String' do
        let(:val) { '3.14' }

        it { expect(subject).to eql('03.14') }
      end

      context 'when int length and num equals' do
        let(:val) { '13.14' }

        it { expect(subject).to eql('13.14') }
      end

      context 'when int length more than num' do
        let(:val) { '133.14' }

        it { expect(subject).to eql(val) }
      end
    end
  end

end
