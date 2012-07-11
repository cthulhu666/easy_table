if __FILE__== $0
  require '../test_helper'
else
  require 'test_helper'
end

class TableHelperTest < ActionView::TestCase

  context "a table" do
    setup do
      @collection = ['foo', 'bar', 'buzz']
    end

    should "have 3 rows" do
      concat(table_for(@collection) do |t|

      end)

      rows = css_select 'table tbody tr'
      assert_equal 3, rows.size

    end

    should "have 2 columns" do
      concat(table_for(@collection) do |t|
        t.column :downcase
        t.column :upcase
      end)

      cols = css_select 'table tbody tr:first-child td'
      assert_equal 2, cols.size
    end
  end
end