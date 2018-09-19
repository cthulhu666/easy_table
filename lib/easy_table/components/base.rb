module EasyTable
  module Components
    module Base
      def translate(key)
        @opts ||= {}
        controller = @template.controller_name
        I18n.t("easy_table.#{controller.singularize}.#{key}", default: (@opts[:_title_human_attribute_name] || key.to_s))
      end
    end
  end
end
