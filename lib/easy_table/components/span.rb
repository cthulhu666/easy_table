module EasyTable
  module Components
    class Span
      include Columns
      include Spans

      def initialize(node, title, html_opts, template, block)
        @node, @title, @template, @block, @html_opts = node, title, template, block, html_opts
        block.call(self)
      end

      delegate :tag, :content_tag, :to => :@template

      def head
        opts = @html_opts.merge(colspan: colspan, scope: 'col')
        concat content_tag(:th, @title, opts)
      end

      def td(record)
        columns.each do |col|
          col.td(record)
        end
      end

      private

      def colspan
        node.inject(0) { |count, n| count += 1 if n.is_leaf?; count }
      end

      def concat(tag)
        @template.safe_concat(tag)
        ""
      end

    end
  end
end