const DIRECTIONS: Array<[number, number]> = [
  [1, 0],
  [-1, 0],
  [0, 1],
  [0, -1]
];

export function twoSum(nums: number[], target: number): number[] {
  const indexByValue = new Map<number, number>();

  for (let index = 0; index < nums.length; index += 1) {
    const num = nums[index];
    const complement = target - num;
    const previousIndex = indexByValue.get(complement);

    if (previousIndex !== undefined) {
      return [previousIndex, index];
    }

    indexByValue.set(num, index);
  }

  return [];
}

export function lengthOfLongestSubstring(input: string): number {
  const lastSeen = new Map<string, number>();
  let left = 0;
  let best = 0;

  for (let right = 0; right < input.length; right += 1) {
    const char = input[right];
    const previous = lastSeen.get(char);

    if (previous !== undefined && previous >= left) {
      left = previous + 1;
    }

    lastSeen.set(char, right);
    best = Math.max(best, right - left + 1);
  }

  return best;
}

export function productExceptSelf(nums: number[]): number[] {
  const result = new Array<number>(nums.length).fill(1);
  let prefix = 1;

  for (let index = 0; index < nums.length; index += 1) {
    result[index] = prefix;
    prefix *= nums[index];
  }

  let suffix = 1;

  for (let index = nums.length - 1; index >= 0; index -= 1) {
    result[index] *= suffix;
    suffix *= nums[index];
  }

  return result.map((value) => (Object.is(value, -0) ? 0 : value));
}

export function searchRotated(nums: number[], target: number): number {
  let left = 0;
  let right = nums.length - 1;

  while (left <= right) {
    const middle = Math.floor((left + right) / 2);

    if (nums[middle] === target) {
      return middle;
    }

    if (nums[left] <= nums[middle]) {
      if (nums[left] <= target && target < nums[middle]) {
        right = middle - 1;
      } else {
        left = middle + 1;
      }
    } else if (nums[middle] < target && target <= nums[right]) {
      left = middle + 1;
    } else {
      right = middle - 1;
    }
  }

  return -1;
}

export function numIslands(grid: string[][]): number {
  if (grid.length === 0 || grid[0].length === 0) {
    return 0;
  }

  let islands = 0;

  for (let row = 0; row < grid.length; row += 1) {
    for (let col = 0; col < grid[row].length; col += 1) {
      if (grid[row][col] !== "1") {
        continue;
      }

      islands += 1;
      sinkIsland(grid, row, col);
    }
  }

  return islands;
}

export function topKFrequent(nums: number[], k: number): number[] {
  const frequency = new Map<number, number>();

  nums.forEach((num) => {
    frequency.set(num, (frequency.get(num) ?? 0) + 1);
  });

  const buckets: number[][] = Array.from({ length: nums.length + 1 }, () => []);

  frequency.forEach((count, num) => {
    buckets[count].push(num);
  });

  const result: number[] = [];

  for (let count = buckets.length - 1; count >= 0; count -= 1) {
    for (const num of buckets[count]) {
      result.push(num);

      if (result.length === k) {
        return result;
      }
    }
  }

  return result;
}

export function coinChange(coins: number[], amount: number): number {
  const dp = new Array<number>(amount + 1).fill(amount + 1);
  dp[0] = 0;

  for (let current = 1; current <= amount; current += 1) {
    for (const coin of coins) {
      if (coin > current) {
        continue;
      }

      dp[current] = Math.min(dp[current], dp[current - coin] + 1);
    }
  }

  return dp[amount] > amount ? -1 : dp[amount];
}

class ListNode {
  key: number;
  value: number;
  prev: ListNode | null;
  next: ListNode | null;

  constructor(key = 0, value = 0) {
    this.key = key;
    this.value = value;
    this.prev = null;
    this.next = null;
  }
}

export class LRUCache {
  private readonly capacity: number;
  private readonly nodes: Map<number, ListNode>;
  private readonly head: ListNode;
  private readonly tail: ListNode;

  constructor(capacity: number) {
    if (capacity <= 0) {
      throw new Error("capacity must be positive");
    }

    this.capacity = capacity;
    this.nodes = new Map<number, ListNode>();
    this.head = new ListNode();
    this.tail = new ListNode();
    this.head.next = this.tail;
    this.tail.prev = this.head;
  }

  get(key: number): number {
    const node = this.nodes.get(key);

    if (!node) {
      return -1;
    }

    this.moveToFront(node);
    return node.value;
  }

  put(key: number, value: number): void {
    const existingNode = this.nodes.get(key);

    if (existingNode) {
      existingNode.value = value;
      this.moveToFront(existingNode);
      return;
    }

    const node = new ListNode(key, value);
    this.nodes.set(key, node);
    this.addToFront(node);

    if (this.nodes.size <= this.capacity) {
      return;
    }

    const lru = this.detach(this.tail.prev as ListNode);
    this.nodes.delete(lru.key);
  }

  private moveToFront(node: ListNode): void {
    this.detach(node);
    this.addToFront(node);
  }

  private addToFront(node: ListNode): void {
    node.prev = this.head;
    node.next = this.head.next;
    this.head.next!.prev = node;
    this.head.next = node;
  }

  private detach(node: ListNode): ListNode {
    node.prev!.next = node.next;
    node.next!.prev = node.prev;
    node.prev = null;
    node.next = null;
    return node;
  }
}

function sinkIsland(grid: string[][], startRow: number, startCol: number): void {
  const queue: Array<[number, number]> = [[startRow, startCol]];
  let head = 0;
  grid[startRow][startCol] = "0";

  while (head < queue.length) {
    const [row, col] = queue[head];
    head += 1;

    for (const [dr, dc] of DIRECTIONS) {
      const nextRow = row + dr;
      const nextCol = col + dc;

      if (nextRow < 0 || nextCol < 0) {
        continue;
      }

      if (nextRow >= grid.length || nextCol >= grid[0].length) {
        continue;
      }

      if (grid[nextRow][nextCol] !== "1") {
        continue;
      }

      grid[nextRow][nextCol] = "0";
      queue.push([nextRow, nextCol]);
    }
  }
}
