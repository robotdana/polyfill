RSpec.describe 'IO#lines' do
  using Polyfill(IO: %w[#lines], version: '2.4')

  around(:all) do |example|
    ignore_warnings do
      example.run
    end
  end

  def fixture(file_name)
    File.join(File.dirname(__FILE__), '..', 'fixtures', file_name)
  end

  let(:file_name) { fixture('file.txt') }
  let(:io) { IO.new(IO.sysopen(file_name)) }
  let(:acc) { [] }

  context 'existing behavior' do
    it 'works' do
      expect(io.lines { |line| acc << line }).to be io
      expect(acc).to eql ["line 1\n", "line 2\n"]
    end

    it 'works without a block' do
      expect(io.lines).to be_an Enumerator
      io.lines.with_index { |line, i| acc << "#{i} #{line}" }
      expect(acc).to eql ["0 line 1\n", "1 line 2\n"]
    end
  end

  context '2.4' do
    context 'chomp flag' do
      it 'returns an Enumerator when no block is given' do
        expect(io.lines(chomp: true)).to be_an Enumerator
        io.lines(chomp: true).with_index { |line, i| acc << "#{i} #{line}" }
        expect(acc).to eql ['0 line 1', '1 line 2']
      end

      it 'chomps the lines when true' do
        expect(io.lines(chomp: true) { |line| acc << line }).to be io
        expect(acc).to eql ['line 1', 'line 2']
      end

      it 'chomps when the limit is set and chomp is true' do
        io.lines(7, chomp: true) { |line| acc << line }
        expect(acc).to eql ['line 1', 'line 2']
      end

      it 'chomps when the separator is changed and chomp is true' do
        io.lines(' ', chomp: true) { |line| acc << line }
        expect(acc).to eql %W[line 1\nline 2\n]
      end

      it 'accepts implicit strings' do
        obj = double('string')
        allow(obj).to receive(:to_str).and_return(' ')
        io.lines(obj, chomp: true) { |line| acc << line }
        expect(acc).to eql %W[line 1\nline 2\n]
      end

      it 'chomps when the separator is changed and the limit is set and chomp is true' do
        io.lines(' ', 5, chomp: true) { |line| acc << line }
        expect(acc).to eql %W[line 1\nlin e 2\n]
      end

      it 'does not chomp the lines when false' do
        io.lines(chomp: false) { |line| acc << line }
        expect(acc).to eql ["line 1\n", "line 2\n"]
      end

      it 'does not chomp when the limit is set and chomp is false' do
        io.lines(7, chomp: false) { |line| acc << line }
        expect(acc).to eql ["line 1\n", "line 2\n"]
      end

      it 'does not chomp when the separator is changed and chomp is false' do
        io.lines(' ', chomp: false) { |line| acc << line }
        expect(acc).to eql ['line ', "1\nline ", "2\n"]
      end

      it 'does not chomp when the separator is changed and the limit is set and chomp is false' do
        io.lines(' ', 5, chomp: false) { |line| acc << line }
        expect(acc).to eql ['line ', "1\nlin", 'e ', "2\n"]
      end
    end
  end
end
