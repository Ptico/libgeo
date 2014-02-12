shared_examples_for 'Coordinate#to_hash' do
  subject { instance.to_hash }
  let(:result) do
    {
      type:       instance.type,
      degrees:    degrees,
      minutes:    minutes,
      seconds:    seconds,
      hemisphere: hemi
    }
  end

  it do
    expect(subject).to eq(result)
  end
end
