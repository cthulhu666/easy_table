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
      @collection << person.new("Barack", "Obama", "bobama@polskieobozy.com", "501601701")
      concat(table_for(@collection) do |t|
        t.span(:names) do |s|
          s.column :name, class: 'name', header_class: 'name_head'
          s.column(:surname) { |person| content_tag(:span, person.surname.capitalize) }
        end
        t.span(:contact_data) do |s|
          s.column :email, class: lambda { |person| person.email =~ /gmail/ ? 'gmail' : '' }
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
      assert_select 'table tbody tr:first-child td:first-child', {count: 1, text: 'John'}
      assert_select 'table tbody tr:first-child td:nth-child(2) span', {count: 1, text: 'Doe'}
    end

    should "have proper td class in name column" do
      td = css_select('table tbody tr:first-child td:first-child').first
      assert_equal 'name', td.attributes['class']
    end

    should "have proper th class in name column" do
      td = css_select('table thead tr:nth-child(2) th:first-child').first
      assert_equal 'name_head', td.attributes['class']
    end

    should "have proper td class in first row in email column" do
      td = css_select('table tbody tr:nth-child(1) td:nth-child(3)').first
      assert_equal 'gmail', td.attributes['class']
    end

    should "have proper td class in second row in email column" do
      td = css_select('table tbody tr:nth-child(2) td:nth-child(3)').first
      assert_equal '', td.attributes['class']
    end
  end
end