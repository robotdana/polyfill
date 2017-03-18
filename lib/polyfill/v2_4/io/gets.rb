module Polyfill
  module V2_4
    module IO
      module Gets
        module Method
          def gets(*args)
            hash, others = args.partition { |arg| arg.is_a?(::Hash) }

            input = super(*others)

            if !input.nil? && hash[0] && hash[0][:chomp]
              separator = others.find { |other| other.respond_to?(:to_str) }
              if separator
                input.chomp!(separator)
              else
                input.chomp!
              end
            end

            input
          end if RUBY_VERSION < '2.4.0'
        end

        if RUBY_VERSION < '2.4.0'
          refine ::IO do
            include Method
          end
        end
      end
    end
  end
end