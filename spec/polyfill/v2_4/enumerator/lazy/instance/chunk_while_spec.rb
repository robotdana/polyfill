RSpec.describe 'Enumerator::Lazy#chunk_while' do
  using Polyfill(:'Enumerator::Lazy' => %w[#chunk_while], version: '2.4')

  it 'will chunk based on the block' do
    expect(
      [1, 2, 3, 5, 8, 13, 21]
        .lazy
        .chunk_while { |a, b| a.even? == b.even? }
        .force
    ).to eql [[1], [2], [3, 5], [8], [13, 21]]
    expect(
      (1..Float::INFINITY)
        .lazy
        .chunk_while { |a, b| a.even? == b.even? }
        .first(2)
    ).to eql [[1], [2]]
  end
end
