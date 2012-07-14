module EasyTable
  module Components
    module Spans
      def span(title, opts = {}, &block)
        child = node << Tree::TreeNode.new(title)
        span = Span.new(child, title, opts, @template, block)
        child.content = span
      end

      private

      def node
        @node
      end
    end
  end
end