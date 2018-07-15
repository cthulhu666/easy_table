module EasyTable
  module Components
    class Column
      include Base

      delegate :tag, :capture, :content_tag, to: :@template

      def initialize(node, title, label, opts, template, block)
        @node = node
        @title = title
        @label = label
        @template = template
        @block = block
        @opts = opts
        header_opts = @opts.select { |k, _v| k =~ /^header_.*/ }
        header_opts.each { |k, _v| @opts.delete(k) }
        @header_opts = header_opts.each_with_object({}) do |e, h|
          k, v = *e
          h[k[7..-1]] = v
        end
      end

      def head
        concat content_tag(:th, label, @header_opts)
      end

      def td(record)
        html = if @block.present?
                 capture { @block.call(record, self) }
               else
                 record.send(@title).to_s
               end
        concat(content_tag(:td, html, html_opts(record)))
      end

      private

      def label
        @label || translate(@title)
      end

      def concat(tag)
        @template.safe_concat(tag) unless tag.nil?
        ''
      end

      def html_opts(record)
        @opts.each_with_object({}) do |e, h|
          k, v = *e
          h[k] = case v
                 when Proc
                   v.call(record)
                 else
                   v
                 end
        end
      end
    end
  end
end
