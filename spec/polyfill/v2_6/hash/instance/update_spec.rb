RSpec.describe 'Hash#update' do
  using Polyfill(Hash: %w[#update], version: '2.6')

  it 'does not raise an exception if changing the value of an existing key during iteration' do
    hash = { 1 => 2, 3 => 4, 5 => 6 }
    hash2 = { 1 => :foo, 3 => :bar }
    hash.each { hash.update(hash2) }

    expect(hash).to eql(1 => :foo, 3 => :bar, 5 => 6)
  end
end
