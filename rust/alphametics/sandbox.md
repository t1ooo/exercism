    AND + 
      A + 
 STRONG + 
OFFENSE + 
     AS + 
      A + 
   GOOD 
== 
DEFENSE


  I +
 BB
 ==
ILL

1 + 99 = 100


I B L
[0,1,2,3,4,5,6,7,8,9]



=================================================================

  S E N D
  M O R E +
-----------
M O N E Y

is_uniq(List) :- is_uniq(List, 1).
is_uniq(List, Index) :-
    nth1(Index, List, Elem),
    nth1(Index, List, _, ListRemoved),
    not(member(Elem, ListRemoved)),
    Index2 is Index+1,
    length(List, Len),
    (Index2 =< Len -> is_uniq(List, Index2); true).

t(D, E, M, N, O, R, S, Y) :-
    between(0, 9, D),
    between(0, 9, E),
    %between(1, 9, M), % leading
    M = 1,
    between(0, 9, N),
    between(0, 9, O),
    between(0, 9, R),
    between(1, 9, S), % leading
    between(0, 9, Y),

    %D \= E, E \= M, M \= N, N \= O, O \= R, R \= S, S \= Y,

    % args is uniq
    %Args = [D, E, M, N, O, R, S, Y],
    %sort(Args, ArgsUniq),
    %length(Args, ArgsLen),
    %length(ArgsUniq, ArgsUniqLen),
    %ArgsLen =:= ArgsUniqLen,
    is_uniq([D, E, M, N, O, R, S, Y]),

    between(0, 1, Y2),
    between(0, 1, E2),
    between(0, 1, N2),

    Y is      (D + E) rem 10, Y2 is      (D + E)//10,
    E is (N + R + Y2) rem 10, E2 is (N + R + Y2)//10,
    N is (E + O + E2) rem 10, N2 is (E + O + E2)//10,
    O is (S + M + N2) rem 10, M  is (S + M + N2)//10.

=================================================================

/*function sum_nums(_nums) {
    const nums = _nums.map(x => [...x]);
    let res = [];
    let div = 0;
    while (true) {
        let buf = [];
        for (num of nums) {
            if (num.length !== 0) {
                buf.push(num.pop());
            }
        }
        if (buf.length === 0) {
            break;
        }
        let sum = buf.reduce((x,acc)=>x+acc, div);
        res.push(sum % 10);
        div = Math.trunc(sum / 10);
    }
    if (div !== 0) {
        res.push(div);
    }
    return res.reverse();
}*/

function sum_nums(_nums) {
    const nums = _nums.map(x => [...x]);
    let res = [];
    let carry = 0;
    let buf = [carry];
    while (true) {
        for (num of nums) {
            if (num.length !== 0) {
                buf.push(num.pop());
            }
        }
        if (buf.length === 0) {
            break;
        }

        let sum = buf.reduce((x,acc)=>x+acc, 0);
        res.push(sum % 10);
        carry = Math.trunc(sum / 10);
        
        buf = [];
        if (carry !== 0) {
            buf.push(carry)
        }
    }
    return res.reverse();
}

function num_to_array(num) {
    return num.toString(10).split("").map(x=>parseInt(x, 10));
}

function array_to_num(array) {
    return parseInt(array.join(""), 10);
}


/*function is_equal(a, b, c, dict) {
    let aa = a.map(x => dict[x]);
    let bb = b.map(x => dict[x]);
    let cc = c.map(x => dict[x]);
    //console.log(aa, bb, cc, sum_nums([aa, bb]));
    return sum_nums([aa, bb]).join("|") === cc.join("|");
}*/

/*function is_equal(_args, _res, dict) {
    let args = _args.map(arg => arg.map(x => dict[x]));
    let res = _res.map(x => dict[x]);
    //console.log(args, res, sum_nums(args));
    return sum_nums(args).join("|") === res.join("|");
}*/

function is_equal(args, res, dict) {
    let args_filled = args.map(arg => arg.map(x => dict[x]));
    let res_filled = res.map(x => dict[x]);
    
    for(let i=0; i<args_filled.length; i++) {
        if (args_filled[i][0] === 0) {
            return false;
        }
    }

    if (res_filled[0] === 0) {
        return false;
    }

    let args_num = args_filled.map(x=>parseInt(x.join(""), 10));
    let res_num = parseInt(res_filled.join(""), 10);
    //console.log(args_filled, res_filled)
    return args_num.reduce((x,acc)=>x+acc, 0) === res_num;
}

// "I + BB == ILL"
function parse_expr(expr) {
   let [args, res] = expr.split("==");
   args = args.split("+").map(x=>x.trim().split(""));
   res = res.trim().split("");
   /// let chars = [...new Set(([res, ...args].join("").split("")))];
   //let chars = [...new Set(expr.replace(/[^\w]/g, '').split(""))];
   //let chars = [...new Set(args.reduce((x,acc)=>[...x, ...acc], []).concat(res))];
   let chars = [...new Set([].concat(...args, res))];
   return [args, res, chars];
}

function remove(arr, i) {
    return [...arr.slice(0,i), ...arr.slice(i+1)];
}

function perms(arr) {
    if (arr.length === 1) {
        return [[...arr]];
    }
    const res = [];
    arr.forEach((_,i) => {
        const last = arr[i];
        const other = remove(arr, i);
        perms(other).forEach(p => {
            p.push(last);
            res.push(p);
        });
    });
    return res;
}

function* perms_gen(arr) {
    if (arr.length === 1) {
        yield [...arr];
        return false;
    }
    for(let i=0; i<arr.length; i++) {
        const last = arr[i];
        const other = remove(arr, i);
        for(let p of perms_gen(other)) {
            p.push(last);
            yield p;
        }
    }
}


function num_perms(limit) {
    const max = Math.pow(10, limit);
    const res = [];
    for(let i=0; i<max; i++) {
        let num = i
                    .toString(10)
                    .padStart(limit, "0")
                    .split("")
                    .map(x=>parseInt(x,10))
        res.push(num);
    }
    return res;
}

function* uniq_num_perms(limit) {
    const max = Math.pow(10, limit);
    //const res = [];
    for(let i=0; i<max; i++) {
        let num = i
                    .toString(10)
                    .padStart(limit, "0")
                    .split("")
                    .map(x=>parseInt(x,10))
        if (new Set(num).size === limit) {
            //res.push(num);
            yield num;
        }
    }
    //return res;
}

/*function* uniq_num_perms(limit) {
    //const res = [];
    const buf = Array(limit).fill(0);
    for(let i=1; i<buf.length; i++) {
        buf[i] = buf[i-1]+1;
    }
    while (true) {


        /*let uniq = true;
        for(let i=1; i<buf.length; i++) {
            if (buf[i] == buf[i-1]) {
                uniq = false;
                break;
            }
        }
        if (uniq) {
            //res.push([...buf]);    
            yield [...buf];
        }*/
        //if (new Set(buf).size === limit) {
        const is_uniq = !buf.some((x,i)=>buf.slice(i+1).includes(x));
        if (is_uniq) {
            yield [...buf];
        }

        for(let i=buf.length-1; i>=0; i--) {
            buf[i]++;
            if (buf[i] < 10) {
                break;
            } else {
                if (i !== 0) buf[i] = 0;
            }
        }
        
        /*if (buf[0] === 9 && buf.slice(1).every(x=> x===9)) {
            //console.log(buf)
            break;
        }*/

        if (buf[0] === 10) {
            break;
        }


        
        /*for(let i=1; i<buf.length; i++) {
            if (buf[i] <= buf[i-1]) {
                buf[i] = buf[i-1]+1;
            }
        }*/
        
        //if (buf[buf.length-1] == 10) break;

        //res.push([...buf]);
    }
    //return res;
}/*

function obj_from_keys_vals(keys, values) {
    if (keys.length !== values.length) {
        throw new Error("len not equal");
    }
    const obj = {};
    keys.forEach((k,i) => obj[k] = values[i]);
    return obj;
}

function solve(expr) {
    const [args, res, chars] = parse_expr(expr);
    //console.log("parse expr", args, res, chars);
    const perms = uniq_num_perms(chars.length);
    let dict = [];
    let iter = 0;
    console.log("start")
    for(let perm of perms) {
        process.stdout.write(iter + "             \r");
        iter++;
        try {
            dict = obj_from_keys_vals(chars, perm);
        } catch(e) {
            console.log(e.message)
            return false;
        }
        //console.log(args, res, dict);
        if ( is_equal(args, res, dict) ) {
            return dict;
        }
    }
    return false;
}

//var x = 02453; 
//var y = 96454; 
//array_to_num(sum_nums([num_to_array(x),num_to_array(y)])) === x + y;

//parse_expr("I + BB == ILL");
//is_equal(['I'], ['B','B'], ['I','L','L'], {I:1, B:9, L:0});


solve("I + BB == ILL");


is_equal([ 
  [ 'A' ],
  [ 'A' ],
  [ 'A' ],
  [ 'A' ],
  [ 'A' ],
  [ 'A' ],
  [ 'A' ],
  [ 'A' ],
  [ 'A' ],
  [ 'A' ],
  [ 'A' ],
  [ 'B' ] ], [ 'B', 'C', 'C' ], { A: 9, B: 1, C: 0 })

