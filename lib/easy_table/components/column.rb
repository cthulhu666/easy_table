module EasyTable
  module Components
    class Column

      delegate :tag, :capture, :content_tag, :to => :@template

      def initialize(title, opts, template, block)
        @title, @template, @block, @opts = title, template, block, opts
        header_opts = @opts.select { |k, v| k =~ /^header_.*/ }
        header_opts.each { |k, v| @opts.delete(k) }
        @header_opts = header_opts.inject({}) do |h, e|
          k, v = *e
          h[k[7..-1]] = v
          h
        end
      end

      def initialize_copy(source)
        super
        @opts = @opts.dup
      end

      def head
        concat content_tag(:th, @title, @header_opts)
      end

      def td(record)
        html = capture { @block.call(record, self) }
        concat(tag(:td, @opts))
        concat(html)
        concat('</td>')
      end

      def class=(klass)
        @opts[:class] = [klass, @opts[:class]].join ' '
      end

      private

      def concat(tag)
        @template.safe_concat(tag) unless tag.nil?
        ""
      end
    end
  end
end