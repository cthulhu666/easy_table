module EasyTable
  module Components
    module Columns
      def column(title, label_or_opts = nil, opts = {}, &block)
        if label_or_opts.is_a?(Hash) && label_or_opts.extractable_options?
          label = nil
          opts = label_or_opts
        else
          label = label_or_opts
          opts = opts
        end
        child = node << Tree::TreeNode.new(title)

        if @collection&.first&.class&.respond_to?(:human_attribute_name)
          opts[:_title_human_attribute_name] ||= @collection.first.class.human_attribute_name(title)
        end

        column = Column.new(child, title, label, opts, @template, block)
        child.content = column
      end

      private

      def node
        @node
      end
    end
  end
end
