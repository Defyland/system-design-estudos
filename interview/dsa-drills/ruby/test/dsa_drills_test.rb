# frozen_string_literal: true

require "dsa_drills"

def assert_equal(expected, actual)
  return if expected == actual

  raise "Expected #{expected.inspect}, got #{actual.inspect}"
end

assert_equal [0, 1], DsaDrills.two_sum([2, 7, 11, 15], 9)
assert_equal [1, 2], DsaDrills.two_sum([3, 2, 4], 6)
assert_equal [], DsaDrills.two_sum([1, 2, 3], 10)

assert_equal 3, DsaDrills.length_of_longest_substring("abcabcbb")
assert_equal 1, DsaDrills.length_of_longest_substring("bbbbb")
assert_equal 3, DsaDrills.length_of_longest_substring("pwwkew")

assert_equal [24, 12, 8, 6], DsaDrills.product_except_self([1, 2, 3, 4])
assert_equal [0, 0, 9, 0, 0], DsaDrills.product_except_self([-1, 1, 0, -3, 3])

assert_equal 4, DsaDrills.search_rotated([4, 5, 6, 7, 0, 1, 2], 0)
assert_equal(-1, DsaDrills.search_rotated([4, 5, 6, 7, 0, 1, 2], 3))
assert_equal(-1, DsaDrills.search_rotated([], 3))

grid = [
  %w[1 1 0 0 0],
  %w[1 1 0 0 0],
  %w[0 0 1 0 0],
  %w[0 0 0 1 1]
]
assert_equal 3, DsaDrills.num_islands(grid)

assert_equal [1, 2], DsaDrills.top_k_frequent([1, 1, 1, 2, 2, 3], 2)
assert_equal [1], DsaDrills.top_k_frequent([1], 1)

cache = DsaDrills::LRUCache.new(2)
cache.put(1, 1)
cache.put(2, 2)
assert_equal 1, cache.get(1)
cache.put(3, 3)
assert_equal(-1, cache.get(2))
cache.put(4, 4)
assert_equal(-1, cache.get(1))
assert_equal 3, cache.get(3)
assert_equal 4, cache.get(4)

assert_equal 3, DsaDrills.coin_change([1, 2, 5], 11)
assert_equal(-1, DsaDrills.coin_change([2], 3))
assert_equal 0, DsaDrills.coin_change([1], 0)

puts "Ruby DSA drills passed"
