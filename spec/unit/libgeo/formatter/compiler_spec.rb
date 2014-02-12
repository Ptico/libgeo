# encoding: utf-8

require 'spec_helper'

describe Libgeo::Formatter::Compiler do
  let(:instance) { described_class.new(pattern) }

  describe '#compile' do
    subject { instance.compile }

    context 'empty string' do
      let(:pattern) { '' }

      it { expect(subject).to eql('') }
    end

    context 'keyword string' do
      let(:pattern) { '%d' }

      it { expect(subject).to eql('c.deg.to_s') }
    end

    context 'keyword with pad' do
      let(:pattern) { '%3m' }

      it { expect(subject).to eql('pad(c.mins.to_s, 3)') }
    end

    context 'strings' do
      let(:pattern) { 'Hello world' }

      it { expect(subject).to eql("'Hello world'") }
    end

    context 'keywords and strings' do
      let(:pattern)  { 'Degs: %d, Mins: %m' }
      let(:expected) { %('Degs: ' << c.deg.to_s << ', Mins: ' << c.mins.to_s) }

      it { expect(subject).to eql(expected) }
    end

    describe 'keywords' do
      let(:pattern) { |ex| ex.description }

      it '%d' do
        expect(subject).to eql('c.deg.to_s')
      end

      it '%m' do
        expect(subject).to eql('c.mins.to_s')
      end

      it '%M' do
        expect(subject).to eql('c.minutes_only.to_s')
      end

      it '%s' do
        expect(subject).to eql('c.secs.to_i.to_s')
      end

      it '%S' do
        expect(subject).to eql('c.secs.to_s')
      end

      it '%h' do
        expect(subject).to eql('c.hemi.to_s.downcase.to_s')
      end

      it '%H' do
        expect(subject).to eql('c.hemi.to_s')
      end
    end

  end

end
