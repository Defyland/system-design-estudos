import test from "node:test";
import assert from "node:assert/strict";

import {
  LRUCache,
  coinChange,
  lengthOfLongestSubstring,
  numIslands,
  productExceptSelf,
  searchRotated,
  topKFrequent,
  twoSum
} from "../src/dsaDrills";

test("twoSum", () => {
  assert.deepEqual(twoSum([2, 7, 11, 15], 9), [0, 1]);
  assert.deepEqual(twoSum([3, 2, 4], 6), [1, 2]);
  assert.deepEqual(twoSum([1, 2, 3], 10), []);
});

test("lengthOfLongestSubstring", () => {
  assert.equal(lengthOfLongestSubstring("abcabcbb"), 3);
  assert.equal(lengthOfLongestSubstring("bbbbb"), 1);
  assert.equal(lengthOfLongestSubstring("pwwkew"), 3);
});

test("productExceptSelf", () => {
  assert.deepEqual(productExceptSelf([1, 2, 3, 4]), [24, 12, 8, 6]);
  assert.deepEqual(productExceptSelf([-1, 1, 0, -3, 3]), [0, 0, 9, 0, 0]);
});

test("searchRotated", () => {
  assert.equal(searchRotated([4, 5, 6, 7, 0, 1, 2], 0), 4);
  assert.equal(searchRotated([4, 5, 6, 7, 0, 1, 2], 3), -1);
  assert.equal(searchRotated([], 3), -1);
});

test("numIslands", () => {
  const grid = [
    ["1", "1", "0", "0", "0"],
    ["1", "1", "0", "0", "0"],
    ["0", "0", "1", "0", "0"],
    ["0", "0", "0", "1", "1"]
  ];

  assert.equal(numIslands(grid), 3);
});

test("topKFrequent", () => {
  assert.deepEqual(topKFrequent([1, 1, 1, 2, 2, 3], 2), [1, 2]);
  assert.deepEqual(topKFrequent([1], 1), [1]);
});

test("LRUCache", () => {
  const cache = new LRUCache(2);

  cache.put(1, 1);
  cache.put(2, 2);
  assert.equal(cache.get(1), 1);

  cache.put(3, 3);
  assert.equal(cache.get(2), -1);

  cache.put(4, 4);
  assert.equal(cache.get(1), -1);
  assert.equal(cache.get(3), 3);
  assert.equal(cache.get(4), 4);
});

test("coinChange", () => {
  assert.equal(coinChange([1, 2, 5], 11), 3);
  assert.equal(coinChange([2], 3), -1);
  assert.equal(coinChange([1], 0), 0);
});
