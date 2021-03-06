RSpec.describe 'StringIO#gets' do
  using Polyfill(StringIO: %w[#gets], version: '2.4')

  let(:io) { StringIO.new("line 1\nline 2\n") }

  context 'existing behavior' do
    it 'works' do
      expect(io.gets).to eql "line 1\n"
    end
  end

  context '2.4' do
    context 'chomp flag' do
      it 'chomps the line when true' do
        expect(io.gets(chomp: true)).to eql 'line 1'
      end

      it 'chomps when the limit is set and chomp is true' do
        expect(io.gets(7, chomp: true)).to eql 'line 1'
      end

      it 'chomps when the separator is changed and chomp is true' do
        expect(io.gets(' ', chomp: true)).to eql 'line'
      end

      it 'accepts implicit strings' do
        obj = double('string')
        allow(obj).to receive(:to_str).and_return(' ')
        expect(io.gets(obj, chomp: true)).to eql 'line'
      end

      it 'chomps when the separator is changed and the limit is set and chomp is true' do
        expect(io.gets(' ', 5, chomp: true)).to eql 'line'
      end

      it 'does not chomp the line when false' do
        expect(io.gets(chomp: false)).to eql "line 1\n"
      end

      it 'does not chomp when the limit is set and chomp is false' do
        expect(io.gets(7, chomp: false)).to eql "line 1\n"
      end

      it 'does not chomp when the separator is changed and chomp is false' do
        expect(io.gets(' ', chomp: false)).to eql 'line '
      end

      it 'does not chomp when the separator is changed and the limit is set and chomp is false' do
        expect(io.gets(' ', 5, chomp: false)).to eql 'line '
      end

      it 'returns nil to end the file' do
        io.gets(chomp: true)
        io.gets(chomp: true)
        expect(io.gets(chomp: true)).to be nil
      end
    end
  end
end
