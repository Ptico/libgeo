shared_examples_for 'Coordinate#degrees' do
  subject { instance.degrees }

  context 'when int' do
    let(:degrees) { 48 }

    it { expect(subject).to eql(48) }
    it { expect(subject).to be_an(Integer) }
  end

  context 'when float' do
    let(:degrees) { 48.0 }

    it { expect(subject).to eql(48) }
    it { expect(subject).to be_an(Integer) }
  end

  context 'when string' do
    let(:degrees) { '48' }

    it { expect(subject).to eql(48) }
    it { expect(subject).to be_an(Integer) }
  end
end

shared_examples_for 'Coordinate#minutes' do
  subject { instance.minutes }

  context 'when int' do
    let(:minutes) { 4 }

    it { expect(subject).to eql(4) }
    it { expect(subject).to be_an(Integer) }
  end

  context 'when float' do
    let(:minutes) { 4.0 }

    it { expect(subject).to eql(4) }
    it { expect(subject).to be_an(Integer) }
  end

  context 'when string' do
    let(:minutes) { '4' }

    it { expect(subject).to eql(4) }
    it { expect(subject).to be_an(Integer) }
  end
end

shared_examples_for 'Coordinate#seconds' do
  subject { instance.seconds }

  context 'when int' do
    let(:seconds) { 15 }

    it { expect(subject).to eql(15.0) }
    it { expect(subject).to be_a(Float) }
  end

  context 'when float' do
    let(:seconds) { 15.7836 }

    it { expect(subject).to eql(15.7836) }
    it { expect(subject).to be_a(Float) }
  end

  context 'when string' do
    let(:seconds) { '15.7836' }

    it { expect(subject).to eql(15.7836) }
    it { expect(subject).to be_a(Float) }
  end
end
