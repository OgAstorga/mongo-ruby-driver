$LOAD_PATH[0,0] = File.join(File.dirname(__FILE__), '..', 'lib')
require 'mongo'
require 'test/unit'

class ObjectIDTest < Test::Unit::TestCase

  include XGen::Mongo::Driver

  def setup
    @t = 42
    @o = ObjectID.new(nil, @t)
  end

  def test_index_for_time
    t = 99
    assert_equal 0, @o.index_for_time(t)
    assert_equal 1, @o.index_for_time(t)
    assert_equal 2, @o.index_for_time(t)
    t = 100
    assert_equal 0, @o.index_for_time(t)
  end

  def test_time_bytes
    a = @o.to_a
    assert_equal @t, a[0]
    3.times { |i| assert_equal 0, a[i+1] }

    t = 43
    o = ObjectID.new(nil, t)
    a = o.to_a
    assert_equal t, a[0]
    3.times { |i| assert_equal 0, a[i+1] }
    assert_equal 1, o.index_for_time(t) # 0 was used for o
  end

  def test_different
    o2 = ObjectID.new(nil, @t)
    assert @o.to_a != o2.to_a
  end

  def test_eql?
    o2 = ObjectID.new(@o.to_a)
    assert @o.eql?(o2)
    assert @o == o2
  end

  def test_to_s
    s = @o.to_s
    assert_equal 24, s.length
    s =~ /^([0-9a-f]+)$/
    assert_equal 24, $1.length
  end

end