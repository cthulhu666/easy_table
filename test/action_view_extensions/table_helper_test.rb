require 'test_helper'

class TableHelperTest < ActionView::TestCase
  context 'a table' do
    setup do
      @collection = %w[foo bar buzz]
      concat(table_for(@collection, class: 'easy', tr_class: 'fun',
                                    tr_foo: ->(e) { e.length > 3 }) do |t|
               t.column :downcase
               t.column(:upcase) { |e| e.upcase } # rubocop:disable Style/SymbolProc
             end)
    end

    should "have 'easy' class" do
      assert_select 'table.easy'
    end

    should 'have 3 rows' do
      rows = css_select 'table tbody tr'
      assert_equal 3, rows.size
    end

    should "have rows with 'fun' class" do
      rows = css_select 'table tbody tr.fun'
      assert_equal 3, rows.size
    end

    should 'have 2 columns' do
      cols = css_select 'table tbody tr:first-child td'
      assert_equal 2, cols.size
    end

    should 'have proper headers' do
      headers = css_select 'table thead tr th'
      assert_equal '<th>downcase</th>', headers[0].to_s.strip
      assert_equal '<th>upcase</th>', headers[1].to_s
    end
  end

  context 'a complex table' do
    setup do
      Person = Struct.new(:id, :name, :surname, :email, :phone) unless defined?(Person)
      @collection = []
      @collection << Person.new(1, 'John', 'Doe', 'jdoe@gmail.com', '500600700')
      @collection << Person.new(2, 'Barack', 'Obama', 'bobama@polskieobozy.com', '501601701')
      concat(table_for(@collection) do |t|
        t.span(:names) do |s|
          s.column :name, class: 'name', header_class: 'name_head'
          s.column(:surname) { |person| content_tag(:span, person.surname.capitalize) }
        end
        t.span(:contact_data) do |s|
          s.column :email, class: ->(person) { ['foo', 'bar', person.email =~ /gmail/ && 'gmail'].compact }
          s.column :phone
        end
      end)
    end

    should 'have rows with proper id attributes' do
      assert_select 'table tbody tr#tablehelpertest-person-1'
      assert_select 'table tbody tr#tablehelpertest-person-2'
    end

    should "have 2 th-s in thead's first row'" do
      row = css_select 'table thead tr:first-child th'
      assert_equal 2, row.size
    end

    should "have 4 th-s in thead's second row'" do
      row = css_select 'table thead tr:nth-child(2) th'
      assert_equal 4, row.size
    end

    should 'have proper body content' do
      assert_select 'table tbody tr:first-child td:first-child', count: 1, text: 'John'
      assert_select 'table tbody tr:first-child td:nth-child(2) span', count: 1, text: 'Doe'
    end

    should 'have proper td class in name column' do
      td = css_select('table tbody tr:first-child td:first-child').first
      assert_equal 'name', td.attributes['class'].value
    end

    should 'have proper th class in name column' do
      td = css_select('table thead tr:nth-child(2) th:first-child').first
      assert_equal 'name_head', td.attributes['class'].value
    end

    should 'have proper td class in first row in email column' do
      td = css_select('table tbody tr:nth-child(1) td:nth-child(3)').first
      assert_equal 'foo bar gmail', td.attributes['class'].value
    end

    should 'have proper td class in second row in email column' do
      td = css_select('table tbody tr:nth-child(2) td:nth-child(3)').first
      assert_equal 'foo bar', td.attributes['class'].value
    end
  end

  context 'table with nested spans' do
    setup do
      @collection = []
      concat(
        table_for(@collection) do |t|
          t.span :span1 do |s1|
            s1.span :span2 do |s2|
              s2.column :col1
              s2.column :col2
            end
            s1.span :span3 do |s3|
              s3.column :col3
              s3.column :col4
            end
          end
          t.span :span4 do |s4|
            s4.column :col5
            s4.column :col6
          end
          t.column :col7, header_rowspan: 3
        end
      )
    end

    should 'have 3 rows in thead' do
      assert_select 'table thead tr', 3
    end

    should 'have rowspan=3 in last th of first tr' do
      th = css_select('table thead tr:first-child th:last-child').first
      assert_equal '3', th.attributes['rowspan'].value
    end

    should 'have 11 th elements in thead' do
      assert_select 'table thead th', count: 11
    end
  end
end
