module Polyfill
  module V2_4
    module Integer
      module Instance
        module Round
          module Method
            def round(ndigits = 0, half: nil)
              unless [nil, :down, :even, :up, 'down', 'even', 'up'].include?(half)
                raise ArgumentError, "invalid rounding mode: #{half}"
              end
              ndigits = ndigits.to_int
              return super() if ndigits == 0
              return to_f if ndigits > 0

              place = 10**-ndigits
              (to_f / place).round * place
            end
          end

          refine ::Integer do
            include Method
          end

          def self.included(base)
            base.include Method
          end
        end
      end
    end
  end
end