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
      fmt(history, goal) === "moves: 4, goalBucket: one, otherBucket: 5"
    );
  }

  {
    const sizes = [3, 5];
    const goal = 1;
    const start_bucket = TWO;

    const history = solve(sizes, goal, start_bucket);
    print(sizes, goal, start_bucket, history);
    console.assert(
      fmt(history, goal) === "moves: 8, goalBucket: two, otherBucket: 3"
    );
  }

  {
    const sizes = [7, 11];
    const goal = 2;
    const start_bucket = ONE;

    const history = solve(sizes, goal, start_bucket);
    print(sizes, goal, start_bucket, history);
    console.assert(
      fmt(history, goal) === "moves: 14, goalBucket: one, otherBucket: 11"
    );
  }

  {
    const sizes = [7, 11];
    const goal = 2;
    const start_bucket = TWO;

    const history = solve(sizes, goal, start_bucket);
    print(sizes, goal, start_bucket, history);
    console.assert(
      fmt(history, goal) === "moves: 18, goalBucket: two, otherBucket: 7"
    );
  }

  {
    const sizes = [1, 3];
    const goal = 3;
    const start_bucket = TWO;

    const history = solve(sizes, goal, start_bucket);
    print(sizes, goal, start_bucket, history);
    console.assert(
      fmt(history, goal) === "moves: 1, goalBucket: two, otherBucket: 0"
    );
  }

  {
    const sizes = [2, 3];
    const goal = 3;
    const start_bucket = ONE;

    const history = solve(sizes, goal, start_bucket);
    print(sizes, goal, start_bucket, history);
    console.assert(
      fmt(history, goal) === "moves: 2, goalBucket: two, otherBucket: 2"
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
      fmt(history, goal) === "moves: 10, goalBucket: two, otherBucket: 0"
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
  console.log(`sizes ${sizes}`);
  console.log(`goal ${goal}`);
  console.log(`start_bucket ${start_bucket}`);
  if (history === null) {
    console.log(history);
  } else {
    const str_states = history[0].map((x) =>
      x.map((s, i) => (s === 0 ? "empty" : s === sizes[i] ? "full" : "not_empty"))
    );
    history[0].forEach((_, i) =>
      console.log(
        `${i}: ${history[1][i]} : ${history[0][i]} : if ${str_states[i]} -> ${history[1][i+1]}`
      )
    );
  }
  console.log("---------------");
}

function fmt(history, goal) {
  const state_history = history[0];
  const moves = state_history.length - 1;
  const last = state_history[state_history.length - 1];
  const goal_bucket = last[0] == goal ? "one" : "two";
  const other_bucket = last[0] == goal ? last[1] : last[0];

  return `moves: ${moves}, goalBucket: ${goal_bucket}, otherBucket: ${other_bucket}`;
}

function solve(sizes, goal, start_bucket) {
  const other_bucket = start_bucket === ONE ? TWO : ONE;
  // if (start_bucket === TWO) {
  //   sizes = sizes.reverse();
  //   start_bucket = ONE;
  // }
  // const other_bucket = TWO;

  const actions = [fill_1, pour_1to2, empty_1, fill_2, pour_2to1, empty_2];
  const opposite_actions = [
    ["fill_1", "empty_1"],
    ["fill_2", "empty_2"],
    ["pour_1to2", "pour_2to1"],
  ];
  const queue = [];
  let state = [0, 0];
  let state_history = [state];
  let action_history = ["init"];

  // first step
  state = fill(sizes, state, start_bucket);

  // other steps
  queue.push([
    state,
    `fill_${start_bucket + 1}`,
    state_history,
    action_history,
  ]);

  while (queue.length > 0) {
    let [
      curr_state,
      prev_action,
      state_history,
      action_history,
    ] = queue.shift();

    // if state already contains in history, we're in dead loop
    // so do not continue searching on this branch
    if (contains(state_history, curr_state)) {
      continue;
    }

    state_history = [...state_history, curr_state];
    action_history = [...action_history, prev_action];

    // return if state contains goal
    if (curr_state.some((x) => x === goal)) {
      return [state_history, action_history];
    }

    // avoid doing the action twice
    // or doing opposite actions after previos
    const actions_filtered = actions.filter((action) => {
      const name = action.name;
      if (name === prev_action) {
        return false;
      }

      for (let c of opposite_actions) {
        if (name === c[0] && prev_action === c[1]) {
          return false;
        }
        if (name === c[1] && prev_action === c[0]) {
          return false;
        }
      }

      return true;
    });

    const nexts = actions_filtered
      .map((action) => [action(sizes, curr_state), action.name])

      // filter not changed states
      .filter((x) => !is_equal(x[0], curr_state))

      // when starting with the larger bucket full,
      // you are NOT allowed at any point to have the smaller bucket full
      // and the larger bucket empty
      .filter(
        (x) =>
          !is_empty(sizes, x[0], start_bucket) ||
          !is_full(sizes, x[0], other_bucket)
      )
      .map((x) => [x[0], x[1], state_history, action_history]);

    queue.push(...nexts);
  }

  return null;
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
function empty_1(sizes, state) {
  return empty(sizes, state, 0);
}

function fill_2(sizes, state) {
  return fill(sizes, state, 1);
}
function pour_2to1(sizes, state) {
  return pour(sizes, state, 1, 0);
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
