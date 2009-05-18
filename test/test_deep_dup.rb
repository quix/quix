require File.dirname(__FILE__) + "/common"

require "quix/ext/object/deep_dup"

class TestDeepDup < Test::Unit::TestCase
  def test_deep_dup
    [
      :x,
      3,
      "a",
      %w[b c d],
      { :t => 99 },
    ].each { |object|
      assert_equal object, object.deep_dup
    }

    data = {
      :x => 33,
      :y => 44,
      :z => 55,
      :t => %w[a b c],
      :u => [
        {
          :a => 1,
          :b => "zz",
        },
        %w[g h i]
      ],
    }
    copy = data.deep_dup
    assert_equal data, copy
    assert_equal data[:u][0], copy[:u][0]
    assert_equal data[:u][1], copy[:u][1]
  end
end
