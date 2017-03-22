module Polyfill
  module V2_4
    module Pathname
      module Instance
        module EmptyQ
          module Method
            def empty?
              if directory?
                children.empty?
              else
                zero?
              end
            end
          end

          refine ::Pathname do
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
