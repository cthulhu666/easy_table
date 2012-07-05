module EasyTable
  module Components
    class Span
      include Columns

      def initialize(title, html_opts, template, block)
        @title, @template, @block, @html_opts = title, template, block, html_opts
        block.call(self)
      end

      delegate :tag, :content_tag, :to => :@template

      def head
        opts = @html_opts.merge(colspan: columns.size, scope: 'col')
        concat content_tag(:th, @title, opts)
      end

      def subhead
        columns.each do |col|
          col.head
        end
      end

      def td(record)
        columns.each do |col|
          col.dup.td(record)
        end
      end

      private

      def concat(tag)
        @template.safe_concat(tag)
        ""
      end

    end
  end
end