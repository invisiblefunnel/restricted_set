require File.expand_path("../../lib/restricted_set", __FILE__)
require "minitest/autorun"

class RestrictedSetTest < Minitest::Test
  def setup
    @enum = [-2, 3, -1, 1, -3, 2, 0]
    @arity_1_proc = Proc.new { |o| o > 0 }
    @arity_2_proc = Proc.new { |rs, o| rs.empty? ? true : o > rs.max }
  end

  def test_superclass
    assert RestrictedSet < Set
  end

  def test_new
    assert_raises(ArgumentError) { RestrictedSet.new }
    assert_raises(ArgumentError) { RestrictedSet.new(@enum) }

    s = RestrictedSet.new(@enum, &@arity_1_proc)
    assert_equal [1,2,3], s.sort

    s = RestrictedSet.new(@enum, &@arity_2_proc)
    assert_equal [-2,3], s.sort
  end

  def test_add
    s = RestrictedSet.new(&@arity_1_proc)
    s.add(-1)
    assert s.empty?

    s = RestrictedSet.new(@enum, &@arity_2_proc)
    s.add(4)
    assert_equal [-2,3,4], s.sort

    s = RestrictedSet.new(@enum, &@arity_1_proc)
    assert_equal s, s.add(42)
    assert_equal [1,2,3,42], s.sort

    s = RestrictedSet.new(@enum, &@arity_2_proc)
    assert_equal s, s.add(42)
    assert_equal [-2,3,42], s.sort
  end

  def test_shovel
    s = RestrictedSet.new(&@arity_1_proc)
    s << 2 << 1 << -1
    assert_equal [1, 2], s.sort
  end

  def test_add?
    s = RestrictedSet.new(@enum, &@arity_1_proc)
    assert_equal nil, s.add?(1)
    assert_equal s, s.add?(42)
    assert_equal [1,2,3,42], s.sort

    s = RestrictedSet.new(@enum, &@arity_2_proc)
    assert_equal nil, s.add?(1)
    assert_equal s, s.add?(42)
    assert_equal [-2,3,42], s.sort
  end

  def test_replace
    other = [4,6,-4,5,3,-1]

    s = RestrictedSet.new(@enum, &@arity_1_proc)
    assert_equal [1,2,3], s.sort
    s.replace(other)
    assert_equal [3,4,5,6], s.sort

    s = RestrictedSet.new(@enum, &@arity_2_proc)
    assert_equal [-2,3], s.sort
    s.replace(other)
    assert_equal [4,6], s.sort
  end

  def test_merge
    other = [4,6,-4,5,3,-1]

    s = RestrictedSet.new(@enum, &@arity_1_proc)
    assert_equal [1,2,3], s.sort
    s.merge(other)
    assert_equal [1,2,3,4,5,6], s.sort

    s = RestrictedSet.new(@enum, &@arity_2_proc)
    assert_equal [-2,3], s.sort
    s.merge(other)
    assert_equal [-2,3,4,6], s.sort
  end

  def test_restriction_proc
    s = RestrictedSet.new(&@arity_1_proc)
    f = s.restriction_proc

    assert_instance_of Proc, f
    assert f.call(1)
    refute f.call(0)
  end
end
