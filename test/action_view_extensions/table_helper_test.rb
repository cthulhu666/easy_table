if __FILE__== $0
  require '../test_helper'
else
  require 'test_helper'
end

class TableHelperTest < ActionView::TestCase

  context "a table" do
    setup do
      @collection = ['foo', 'bar', 'buzz']
      concat(table_for(@collection) do |t|
        t.column :downcase
        t.column(:upcase) { |t| t.upcase }
      end)
    end

    should "have 3 rows" do
      rows = css_select 'table tbody tr'
      assert_equal 3, rows.size
    end

    should "have 2 columns" do
      cols = css_select 'table tbody tr:first-child td'
      assert_equal 2, cols.size
    end

    should "have proper headers" do
      headers = css_select 'table thead tr th'
      assert_equal '<th>downcase</th>', headers[0].to_s
      assert_equal '<th>upcase</th>', headers[1].to_s
    end
  end

  context "a complex table" do
    setup do
      person = Struct.new(:name, :surname, :email, :phone)
      @collection = []
      @collection << person.new("John", "Doe", "jdoe@gmail.com", "500600700")
      concat(table_for(@collection) do |t|
        t.span(:names) do |s|
          s.column :name
          s.column :surname
        end
        t.span(:contact_data) do |s|
          s.column :email
          s.column :phone
        end
      end)
    end

    should "have 2 th-s in thead's first row'" do
      row = css_select 'table thead tr:first-child th'
      assert_equal 2, row.size
    end

    should "have 4 th-s in thead's second row'" do
      row = css_select 'table thead tr:nth-child(2) th'
      assert_equal 4, row.size
    end

    should "have proper body content" do
      row = css_select 'table tbody tr td'
      assert_equal 'John', row[0]
      assert_equal 'Doe', row[1]
    end
  end
end