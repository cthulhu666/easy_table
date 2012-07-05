require 'test_helper'

class TableHelperTest < ActionView::TestCase

  context "a table" do
    setup do
      @collection = ['foo', 'bar', 'buzz']
    end

    should "have 3 rows" do
      concat table_for(@collection) do |f|

      end

      rows = css_select 'table tbody tr'
      assert_equal 3, rows.size

    end
  end
end