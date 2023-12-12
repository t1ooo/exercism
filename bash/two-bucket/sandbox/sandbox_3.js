const ONE = 0;
const TWO = 1;

main();
// play();

function main() {
  {
    const sizes = [3, 5];
    const goal = 1;
    const start_bucket = ONE;

    const history = solve(sizes, goal, start_bucket);
    print(sizes, goal, start_bucket, history);
    console.assert(
      fmt(history, goal) === "moves: 4, goalBucket: one, otherBucket: 5",
      fmt(history, goal)
    );
  }

  {
    const sizes = [3, 5];
    const goal = 1;
    const start_bucket = TWO;

    const history = solve(sizes, goal, start_bucket);
    print(sizes, goal, start_bucket, history);
    console.assert(
      fmt(history, goal) === "moves: 8, goalBucket: two, otherBucket: 3",
      fmt(history, goal)
    );
  }

  {
    const sizes = [7, 11];
    const goal = 2;
    const start_bucket = ONE;

    const history = solve(sizes, goal, start_bucket);
    print(sizes, goal, start_bucket, history);
    console.assert(
      fmt(history, goal) === "moves: 14, goalBucket: one, otherBucket: 11",
      fmt(history, goal)
    );
  }

  {
    const sizes = [7, 11];
    const goal = 2;
    const start_bucket = TWO;

    const history = solve(sizes, goal, start_bucket);
    print(sizes, goal, start_bucket, history);
    console.assert(
      fmt(history, goal) === "moves: 18, goalBucket: two, otherBucket: 7",
      fmt(history, goal)
    );
  }

  {
    const sizes = [1, 3];
    const goal = 3;
    const start_bucket = TWO;

    const history = solve(sizes, goal, start_bucket);
    print(sizes, goal, start_bucket, history);
    console.assert(
      fmt(history, goal) === "moves: 1, goalBucket: two, otherBucket: 0",
      fmt(history, goal)
    );
  }

  {
    const sizes = [2, 3];
    const goal = 3;
    const start_bucket = ONE;

    const history = solve(sizes, goal, start_bucket);
    print(sizes, goal, start_bucket, history);
    console.assert(
      fmt(history, goal) === "moves: 2, goalBucket: two, otherBucket: 2",
      fmt(history, goal)
    );
  }

  {
    const sizes = [6, 15];
    const goal = 5;
    const start_bucket = ONE;

    const history = solve(sizes, goal, start_bucket);
    print(sizes, goal, start_bucket, history);
    console.assert(history === null);
  }

  {
    const sizes = [6, 15];
    const goal = 9;
    const start_bucket = ONE;

    const history = solve(sizes, goal, start_bucket);
    print(sizes, goal, start_bucket, history);
    console.assert(
      fmt(history, goal) === "moves: 10, goalBucket: two, otherBucket: 0",
      fmt(history, goal)
    );
  }

  {
    const sizes = [5, 7];
    const goal = 8;
    const start_bucket = ONE;

    const history = solve(sizes, goal, start_bucket);
    print(sizes, goal, start_bucket, history);
    console.assert(history === null);
  }
}

function print(sizes, goal, start_bucket, history) {
  // console.log(history); return;
  console.log("---------------");
  console.log(`sizes ${sizes}`);
  console.log(`goal ${goal}`);
  console.log(`start_bucket ${start_bucket}`);
  if (history === null) {
    console.log(history);
  } else {
    const str_states = history[0].map((x) =>
      x.map((s, i) =>
        s === 0 ? "empty" : s === sizes[i] ? "full" : "not_empty"
      )
    );
    history[0].forEach((_, i) =>
      console.log(
        `${i}: ${history[1][i]} : ${history[0][i]} : if ${str_states[i]} -> ${
          history[1][i + 1]
        }`
      )
    );
  }
}

function fmt(history, goal) {
  const state_history = history[0];
  const moves = state_history.length - 1;
  const last = state_history[state_history.length - 1];
  const goal_bucket = last[0] == goal ? "one" : "two";
  const other_bucket = last[0] == goal ? last[1] : last[0];

  return `moves: ${moves}, goalBucket: ${goal_bucket}, otherBucket: ${other_bucket}`;
}

function solve(_sizes, goal, start_bucket) {
  const rev = (x) => (start_bucket === TWO ? x.slice().reverse() : x.slice());
  const sizes = rev(_sizes);

  if (goal % gcd(sizes[0], sizes[1]) !== 0) {
    return null;
  }
  if (!sizes.some((x) => x >= goal)) {
    return null;
  }

  let state = [0, 0];
  let state_history = [];
  let action_history = ["init"];

  const some_size_eq_goal = sizes.some((x) => x === goal);

  while (true) {
    state_history = [...state_history, state];
    if (state.some((x) => x === goal)) {
      return [state_history.map(rev), action_history];
    }

    let status1 = status(sizes, state, 0);
    let status2 = status(sizes, state, 1);
    let fn = null;

    if (status1 === "empty") {
      fn = fill_1;
    } else if (some_size_eq_goal) {
      fn = fill_2;
    } else if (status2 === "full") {
      fn = empty_2;
    } else {
      fn = pour_1to2;
    }

    state = fn(sizes, state);
    action_history = [...action_history, fn.name];
  }
}

function gcd(x, y) {
  x = Math.abs(x);
  y = Math.abs(y);
  let rem = 0;
  while (y != 0) {
    rem = x % y;
    x = y;
    y = rem;
  }
  return x;
}

function play() {
  const sizes = [3, 5];
  const state = [0, 0];
  console.log(state);

  fill_1(sizes, state);
  console.log(state);

  pour_1to2(sizes, state);
  console.log(state);

  pour_2to1(sizes, state);
  console.log(state);
}

function contains(arr_arr, arr) {
  for (let i = 0; i < arr_arr.length; i++) {
    if (is_equal(arr_arr[i], arr)) {
      return true;
    }
  }
  return false;
}

function is_equal(a, b) {
  return JSON.stringify(a) === JSON.stringify(b);
}

function fill_1(sizes, state) {
  return fill(sizes, state, 0);
}
function pour_1to2(sizes, state) {
  return pour(sizes, state, 0, 1);
}
function fill_2(sizes, state) {
  return fill(sizes, state, 1);
}
function empty_2(sizes, state) {
  return empty(sizes, state, 1);
}

function is_full(sizes, state, idx) {
  return state[idx] === sizes[idx];
}
function is_empty(sizes, state, idx) {
  return state[idx] === 0;
}
function status(sizes, state, idx) {
  if (is_full(sizes, state, idx)) {
    return "full";
  }
  if (is_empty(sizes, state, idx)) {
    return "empty";
  }
  return "not_empty";
}

function fill(sizes, _state, idx) {
  const state = _state.slice();

  if (is_full(sizes, state, idx)) {
    return state;
  }

  state[idx] = sizes[idx];
  return state;
}

function pour(sizes, _state, idxFrom, idxTo) {
  const state = _state.slice();

  if (is_empty(sizes, state, idxFrom)) {
    return state;
  }

  if (is_full(sizes, state, idxTo)) {
    return state;
  }

  const volume1 = state[idxFrom];
  const volume2 = sizes[idxTo] - state[idxTo];
  const volume = Math.min(volume1, volume2);

  state[idxFrom] -= volume;
  state[idxTo] += volume;
  return state;
}

function empty(sizes, _state, idx) {
  const state = _state.slice();

  if (is_empty(sizes, state, idx)) {
    return state;
  }

  state[idx] = 0;
  return state;
}
