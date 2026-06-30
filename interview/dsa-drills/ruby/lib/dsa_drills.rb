# frozen_string_literal: true

require "set"

module DsaDrills
  module_function

  DIRECTIONS = [
    [1, 0],
    [-1, 0],
    [0, 1],
    [0, -1]
  ].freeze

  def two_sum(nums, target)
    index_by_value = {}

    nums.each_with_index do |num, index|
      complement = target - num
      return [index_by_value[complement], index] if index_by_value.key?(complement)

      index_by_value[num] = index
    end

    []
  end

  def length_of_longest_substring(input)
    last_seen = {}
    left = 0
    best = 0

    input.each_char.with_index do |char, right|
      previous = last_seen[char]
      left = previous + 1 if previous && previous >= left

      last_seen[char] = right
      best = [best, right - left + 1].max
    end

    best
  end

  def product_except_self(nums)
    result = Array.new(nums.length, 1)
    prefix = 1

    nums.each_index do |index|
      result[index] = prefix
      prefix *= nums[index]
    end

    suffix = 1
    (nums.length - 1).downto(0) do |index|
      result[index] *= suffix
      suffix *= nums[index]
    end

    result
  end

  def search_rotated(nums, target)
    left = 0
    right = nums.length - 1

    while left <= right
      middle = (left + right) / 2
      return middle if nums[middle] == target

      if nums[left] <= nums[middle]
        if nums[left] <= target && target < nums[middle]
          right = middle - 1
        else
          left = middle + 1
        end
      elsif nums[middle] < target && target <= nums[right]
        left = middle + 1
      else
        right = middle - 1
      end
    end

    -1
  end

  def num_islands(grid)
    return 0 if grid.empty? || grid.first.empty?

    islands = 0

    grid.each_index do |row|
      grid[row].each_index do |col|
        next unless grid[row][col] == "1"

        islands += 1
        sink_island(grid, row, col)
      end
    end

    islands
  end

  def top_k_frequent(nums, k)
    frequency = Hash.new(0)
    nums.each { |num| frequency[num] += 1 }

    buckets = Array.new(nums.length + 1) { [] }
    frequency.each { |num, count| buckets[count] << num }

    result = []

    (buckets.length - 1).downto(0) do |count|
      buckets[count].each do |num|
        result << num
        return result if result.length == k
      end
    end

    result
  end

  def coin_change(coins, amount)
    dp = Array.new(amount + 1, amount + 1)
    dp[0] = 0

    (1..amount).each do |current|
      coins.each do |coin|
        next if coin > current

        dp[current] = [dp[current], dp[current - coin] + 1].min
      end
    end

    dp[amount] > amount ? -1 : dp[amount]
  end

  class LRUCache
    def initialize(capacity)
      raise ArgumentError, "capacity must be positive" unless capacity.positive?

      @capacity = capacity
      @nodes = {}
      @head = Node.new
      @tail = Node.new
      @head.next = @tail
      @tail.prev = @head
    end

    def get(key)
      node = @nodes[key]
      return -1 unless node

      move_to_front(node)
      node.value
    end

    def put(key, value)
      if @nodes.key?(key)
        node = @nodes[key]
        node.value = value
        move_to_front(node)
        return
      end

      node = Node.new(key, value)
      @nodes[key] = node
      add_to_front(node)

      return unless @nodes.length > @capacity

      lru = detach(@tail.prev)
      @nodes.delete(lru.key)
    end

    private

    Node = Struct.new(:key, :value, :prev, :next)

    def move_to_front(node)
      detach(node)
      add_to_front(node)
    end

    def add_to_front(node)
      node.prev = @head
      node.next = @head.next
      @head.next.prev = node
      @head.next = node
    end

    def detach(node)
      node.prev.next = node.next
      node.next.prev = node.prev
      node.prev = nil
      node.next = nil
      node
    end
  end

  def sink_island(grid, start_row, start_col)
    queue = [[start_row, start_col]]
    head = 0
    grid[start_row][start_col] = "0"

    while head < queue.length
      row, col = queue[head]
      head += 1

      DIRECTIONS.each do |dr, dc|
        next_row = row + dr
        next_col = col + dc

        next if next_row.negative? || next_col.negative?
        next if next_row >= grid.length || next_col >= grid[0].length
        next unless grid[next_row][next_col] == "1"

        grid[next_row][next_col] = "0"
        queue << [next_row, next_col]
      end
    end
  end
  private_class_method :sink_island
end
