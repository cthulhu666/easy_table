module EasyTable
  class TableBuilder

    include EasyTable::Components::Columns
    include EasyTable::Components::Spans

    delegate :tag, :content_tag, :to => :@template

    def initialize(collection, template, options)
      @collection = collection
      @options = options
      @template = template
      @node = Tree::TreeNode.new('root')
    end

    def build
      content_tag(:table, @options) do
        concat(content_tag(:thead) do
          thead
        end)
        concat(content_tag(:tbody) do
          @collection.each do |record|
            concat(content_tag(:tr, tr_opts(record)) do
              node.each_leaf do |leaf|
                leaf.content.td(record)
              end
            end)
          end
        end)
      end
    end

    private

    def thead
      rows = node.inject([]) do |arr, n|
        arr[n.level] ||= []
        arr[n.level] << n
        arr
      end
      rows.shift
      rows.each do |row|
        concat(
            content_tag(:tr) do
              row.map { |node| node.content }.each do |span_or_column|
                span_or_column.head
              end
            end
        )
      end
    end

    def tr_opts(record)
      record.respond_to?(:id) ?
          {id: "#{record.class.name.parameterize}-#{record.id}"} : {}
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