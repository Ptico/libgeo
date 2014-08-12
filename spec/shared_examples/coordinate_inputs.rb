shared_examples_for 'Coordinate#inputs' do

  describe '.dms different notations' do
    let(:instance) { described_class.dms(input) }

    context 'only degrees' do
      let(:input) { '58' }

      it { expect(instance.degrees).to eql(58) }
      it { expect(instance.minutes).to eql(0) }
    end

    context 'without seconds' do
      let(:input) { '58 45'}

      it { expect(instance.degrees).to eql(58) }
      it { expect(instance.minutes).to eql(45) }
      it { expect(instance.seconds).to eql(0.0) }

    end

    context 'different formats' do
      context '51 52 53' do
        let(:input) { '51 52 53' }

        it { expect(instance.degrees).to eql(51) }
        it { expect(instance.minutes).to eql(52) }
        it { expect(instance.seconds).to eql(53.0) }
      end

      context "51'52'53" do
        let(:input) { "51'52'53" }

        it { expect(instance.degrees).to eql(51) }
        it { expect(instance.minutes).to eql(52) }
        it { expect(instance.seconds).to eql(53.0) }
      end

      context '51 52 53 HEMI' do
        let(:input) { "51 52 53 #{hemisphere}" }

        it { expect(instance.degrees).to eql(51) }
        it { expect(instance.minutes).to eql(52) }
        it { expect(instance.seconds).to eql(53.0) }
        it { expect(instance.hemisphere).to eql(hemisphere) }
      end

      context '51 52 53, HEMI' do
        let(:input) { "51 52 53, #{hemisphere}" }

        it { expect(instance.degrees).to eql(51) }
        it { expect(instance.minutes).to eql(52) }
        it { expect(instance.seconds).to eql(53.0) }
        it { expect(instance.hemisphere).to eql(hemisphere) }
      end
    end

  end

  describe '.nmea different notations' do
    let(:instance) { described_class.nmea(input) }

    context 'only degrees and minutes' do
      let(:input) { '03920' }

      it { expect(instance.degrees).to eql(39) }
      it { expect(instance.minutes).to eql(20) }
      it { expect(instance.seconds).to eql(0.0) }
    end

    context 'only degrees and hemisphere' do
      let(:input) { "03920,#{hemisphere}" }

      it { expect(instance.degrees).to eql(39) }
      it { expect(instance.minutes).to eql(20) }
      it { expect(instance.seconds).to eql(0.0) }
      it { expect(instance.hemisphere).to eql(hemisphere) }

    end

    context 'different formats' do
      context '03920 HEMI' do
        let(:input) { "03920 #{hemisphere}" }

        it { expect(instance.degrees).to eql(39) }
        it { expect(instance.minutes).to eql(20) }
        it { expect(instance.seconds).to eql(0.0) }
        it { expect(instance.hemisphere).to eql(hemisphere) }
      end

      context '03920,HEMI' do
        let(:input) { "03920,#{hemisphere}" }

        it { expect(instance.degrees).to eql(39) }
        it { expect(instance.minutes).to eql(20) }
        it { expect(instance.seconds).to eql(0.0) }
        it { expect(instance.hemisphere).to eql(hemisphere) }
      end

      context '03920, HEMI' do
        let(:input) { "03920, #{hemisphere}" }

        it { expect(instance.degrees).to eql(39) }
        it { expect(instance.minutes).to eql(20) }
        it { expect(instance.seconds).to eql(0.0) }
        it { expect(instance.hemisphere).to eql(hemisphere) }
      end

      context '03920.56074 HEMI' do
        let(:input) { "03920.56074 #{hemisphere}" }

        it { expect(instance.degrees).to eql(39) }
        it { expect(instance.minutes).to eql(20) }
        it { expect(instance.seconds).to eql(33.6444) }
        it { expect(instance.hemisphere).to eql(hemisphere) }
      end

      context '03920' do
        let(:input) { '03920' }

        it { expect(instance.degrees).to eql(39) }
        it { expect(instance.minutes).to eql(20) }
        it { expect(instance.seconds).to eql(0.0) }
      end
    end
  end
end