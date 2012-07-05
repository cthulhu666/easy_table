module EasyTable
  class TableBuilder
    include EasyTable::Components::Columns

    delegate :tag, :content_tag, :to => :@template

    def initialize(collection, template, options)
      @collection = collection
      @options = options
      @template = template
    end

    def build
      content_tag(:table, @options) do
        concat(content_tag(:thead) do
          concat(content_tag(:tr) do
            spans.each do |span|
              span.head
            end
            columns.each do |col|
              col.head
            end
          end)
          if spans.any?
            concat(content_tag(:tr) do
              spans.each do |span|
                span.subhead
              end
            end)
          end
        end)
        concat(content_tag(:tbody) do
          @collection.each do |record|
            concat(content_tag(:tr, tr_opts(record)) do
              spans.each do |span|
                span.td(record)
              end
              columns.each do |col|
                col.dup.td(record)
              end
            end)
          end
        end)
      end
    end

    def span(title = nil, opts = {}, &block)
      spans << Span.new(title, opts, @template, block)
    end

    def spans
      @spans ||= []
    end

    private

    def tr_opts(record)
      {}
      # TODO {id: "#{record.class.name.downcase}_#{record.id}"}
    end

    def concat(tag)
      @template.safe_concat(tag)
      ""
    end

    def options_from_hash(args)
      args.last.is_a?(Hash) ? args.pop : {}
    end
  end
end