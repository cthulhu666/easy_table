module EasyTable
  module Components
    module Spans
      def span(title, label_or_opts = nil, opts = {}, &block)
        if label_or_opts.is_a?(Hash) && label_or_opts.extractable_options?
          label, opts = nil, label_or_opts
        else
          label, opts = label_or_opts, opts
        end
        child = node << Tree::TreeNode.new(title)
        span = Span.new(child, title, label, opts, @template, block)
        child.content = span
      end

      private

      def node
        @node
      end
    end
  end
end