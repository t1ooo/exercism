// @ts-check

/**
 * Re-arranges the input array by moving an item from one position to another position.
 * Does not mutate the input array.
 *
 * @template T
 *
 * @param {T[]} array the input array
 * @param {number} from the position to move from
 * @param {number} to the position to move to
 *
 * @returns {T[]}
 */
export function arrange(array, from, to) {
  return rearrange(array.slice(), from, to);
}

/**
 * Re-arranges the input array by moving an item from one position to another position.
 * Mutates the input array.
 *
 * @template T
 *
 * @param {T[]} array the input array
 * @param {number} from the position to move from
 * @param {number} to the position to move to
 *
 * @returns {T[]}
 */
export function rearrange(array, from, to) {
	const item = array.splice(from, 1)[0];
	to < 0 && to++;
	array.splice(to, 0, item);
  return array;
}

