module EasyTable
  class TableBuilder
    include EasyTable::Components::Columns
    include EasyTable::Components::Spans

    delegate :tag, :content_tag, to: :@template

    def initialize(collection, template, options)
      @collection = collection
      @options, @tr_opts = parse_options(options)
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

    def parse_options(options)
      tr_opts = options.select { |k, _v| k =~ /^tr_.*/ }
      return options.except(*tr_opts.keys), tr_opts.transform_keys { |k| k[3..-1] }
    end

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
            row.map(&:content).each(&:head)
          end
        )
      end
    end

    def tr_opts(record)
      tr_opts = @tr_opts.inject({}) do |h, e|
        k, v = *e
        h[k] = case v
               when Proc
                 v.call(record)
               else
                 v
               end
        h
      end

      id = "#{record.class.model_name.to_s.parameterize}-#{record.to_param}" if record.class.respond_to?(:model_name)
      id ||= "#{record.class.name.to_s.parameterize}-#{record.id}" if record.respond_to?(:id)

      id.present? ?
          tr_opts.merge(id: id) : tr_opts
    end

    def concat(tag)
      @template.safe_concat(tag)
      ''
    end
  end
end
