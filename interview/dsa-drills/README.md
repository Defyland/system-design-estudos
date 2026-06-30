# Backend Interview DSA Drill Pack

This pack turns the DSA side-track into code you can run, break, and defend.

## Scope

- `Ruby`: executable solutions plus assertions for the core backend interview patterns
- `TypeScript`: the same problem pack with runtime traps that matter in interviews
- `Pattern fire drill`: prompts you should answer out loud before opening the editor

## Problem Pack

The executable suites cover:

1. `Two Sum`
2. `Longest Substring Without Repeating Characters`
3. `Product of Array Except Self`
4. `Search in Rotated Sorted Array`
5. `Number of Islands`
6. `Top K Frequent Elements`
7. `LRU Cache`
8. `Coin Change`

## Pattern Fire Drill

Before you run the tests, force a spoken answer for these prompts:

- repeated membership or complement lookup -> `HashMap / Set`
- valid window that grows and shrinks -> `sliding window`
- sorted space that lets you discard half -> `binary search / two pointers`
- connected neighbors in tree, graph, or grid -> `DFS / BFS`
- repeated subproblem with a smaller reusable answer -> `DP`
- top `k` without sorting everything -> `heap` or `bucket`

If you cannot say the pattern, bottleneck, and complexity in one minute, rerun the chapter before touching code.

## Commands

From the repo root:

```sh
bundle exec rake drills:ruby
bundle exec rake drills:typescript
bundle exec rake drills
```

Initial TypeScript setup:

```sh
npm install --prefix interview/dsa-drills/typescript
```

## Suggested Loop

1. Read Chapter 01 and answer the pattern fire drill aloud.
2. Read Chapter 02 and predict the data structure before checking the code.
3. Run Ruby first to stay close to backend interview defaults.
4. Run TypeScript second to force runtime and typing discipline.
5. Change one test case on purpose and explain why the implementation still holds or fails.
