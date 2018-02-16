module Polyfill
  module V2_5
    module String
      def delete_prefix(prefix)
        sub(/\A#{prefix.to_str}/, ''.freeze)
      end
    end
  end
end
