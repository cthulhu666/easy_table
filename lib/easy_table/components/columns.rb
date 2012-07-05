module EasyTable
  module Components
    module Columns
      def column(title, opts = {}, &block)
        columns << Column.new(title, opts, @template, block)
      end

      def columns
        @columns ||= []
      end
    end
  end
end