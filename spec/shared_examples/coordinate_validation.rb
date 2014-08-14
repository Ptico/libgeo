shared_examples_for 'Coordinate#validation' do
  describe '.nmea' do
    let(:instance) { described_class.nmea(input) }

    context 'degrees out of range' do
      let(:input) { "#{max_degrees + 1}.2343242" }

      it 'should fail' do
        expect { instance }.to raise_error
      end
    end

    context 'wrong hemisphere' do
      let(:input) { "32.43 A" }

      it 'should fail' do
        expect { instance }.to raise_error
      end
    end
  end

  describe '.dms' do
    let(:instance) { described_class.dms(input) }

    context 'degrees out of range' do
      let(:input) { "#{max_degrees + 1}'43'32" }

      it 'should fail' do
        expect { instance }.to raise_error
      end
    end

    context 'minutes out of range' do
      let(:input) { "10'90'32" }

      it 'should fail' do
        expect { instance }.to raise_error
      end
    end

    context 'seconds out of range' do
      let(:input) { "10'43'90" }

      it 'should fail' do
        expect { instance }.to raise_error
      end
    end

    context 'wrong hemisphere' do
      let(:input) { "10'43'32, A" }

      it 'should fail' do
        expect { instance }.to raise_error
      end
    end
  end

  describe '.decimal' do
    let(:instance) { described_class.decimal(input) }

    context 'degrees out of range' do
      let(:input) { max_degrees + 1 }

      it 'should fail' do
        expect { instance }.to raise_error
      end
    end
  end

  describe '.degrees_minutes' do
    let(:instance) { described_class.degrees_minutes(*input) }

    context 'degrees out of range' do
      let(:input) { [max_degrees + 1, 59] }

      it 'should fail' do
        expect { instance }.to raise_error
      end
    end

    context 'minutes out of range' do
      let(:input) { [max_degrees - 1, 61] }

      it 'should fail' do
        expect { instance }.to raise_error
      end
    end
  end
end