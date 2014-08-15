# encoding: utf-8

require 'spec_helper'

describe Libgeo::Coordinate do
  let(:instance) do
    described_class.new(
      params[:hemi],
      params[:degrees],
      params[:minutes],
      params[:seconds]
    )
  end

  let(:second_instance) do
    described_class.new(
      second_params[:hemi],
      second_params[:degrees],
      second_params[:minutes],
      second_params[:seconds]
    )
  end

  let(:params) do
    {
      hemi:    :N,
      degrees: 10,
      minutes: 10,
      seconds: 5.6
    }
  end

  describe 'equality' do
    context 'when attributes same' do
      let(:second_params) { params }

      it 'coordinates should be same' do
        expect(instance.eql?(second_instance)).to eql(true)
        expect(instance == second_instance).to    eql(true)
      end
    end

    context 'when different' do
      context 'degrees' do
        let(:second_params) { params.merge(degrees: 20) }

        it 'should not be equal' do
          expect(instance.eql?(second_instance)).to eql(false)
          expect(instance == second_instance).to    eql(false)
        end
      end

      context 'minutes' do
        let(:second_params) { params.merge(minutes: 30) }

        it 'should not be equal' do
          expect(instance.eql?(second_instance)).to eql(false)
          expect(instance == second_instance).to    eql(false)
        end
      end

      context 'seconds' do
        let(:second_params) { params.merge(seconds: 6.6) }

        it 'should not be equal' do
          expect(instance.eql?(second_instance)).to eql(false)
          expect(instance == second_instance).to    eql(false)
        end
      end

      context 'hemisphere' do
        let(:second_params) { params.merge(hemi: :S) }

        it 'should not be equal' do
          expect(instance.eql?(second_instance)).to eql(false)
          expect(instance == second_instance).to    eql(false)
        end
      end
    end
  end

end
