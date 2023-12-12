Static single assignment form
    https://en.wikipedia.org/wiki/Static_single_assignment_form

https://github.com/SkylerLipthay/string_to_expr
    string_to_expr!("fn times_three(n: i32) -> i32 { n * 3 }");

------------------------------
struct AstNode {
    typ: AstType,
    name: String,
    child: Vec<AstNode>,
}

const builtins = hashmap!(
    "+" => (2, |v| vec![v[0]+v[1]])
);

------------------------------
"1 2 + : addone 1 + ; addone" = 4

(val, 1)
(val, 2)
(word, +)
(def, (addone, [(val, 1), (op, +)])
(word, addone)

// v2
match(token) {
    val => stack.push(token.body),
    word => 
        (fn, arity) = defs[token.name]
        args = stack.popN(arity)
        res = fn(args.reverce())
        stack.push(res)
    uword =>
        //body = defs[token.name]
        //stack.pushAll(body)
        tok = tree.find(token.name)
        tokens.insert(curr_position, tok.body);
    def =>
        /*nothing*/

------------------------------
": one 1 ; : two 2 ; one two +" = 3

(def, (one, [(val, 1)]))
(def, (two, [(val, 2)]))
(word, one)
(word, two)
(word, +)


------------------------------
": foo 10 ;"
": foo foo 1 + ;"
"foo"
=11

(def, (foo, [(val,10)]))
(def, (foo, [(word, foo), (val, 1), (word, +)]))
(word, foo)

// v1
match(token) {
    val => stack.push(token.body),
    word => 
        (fn, arity) = defs[token.name]
        args = stack.popN(arity)
        res = fn(args.reverce())
        stack.push(res)
    uword =>
        body = defs[token.name]
        stack.pushAll(body)
    def =>
        defs[token.name] = token.body;
}


(def, (foo, [(val,10)]))
(def, (foo, [(uword, foo), (val, 1), (word, +)]))
(uword, foo)

------------------------------
"1 2 +"

(val, 1)
(val, 2)
(word, +)


------------------------------
": SWAP DUP Dup dup ;"
"1 swap"
= 1, 1, 1, 1

(def, (swap, [(word, dup), (word, dup), (word, dup)]))
(val, 1)
(word, swap)


(def, (swap, [(word, dup), (word, dup), (word, dup), (ret)]))
(val, 1)
(word, swap)

------------------------------
": + - ;"
": add + ;"
"add 1 2"

// v3
while token = ast.next() {
    match() {
        val => stack.push(token.body),
        word =>
            addr = tree.find(token.name)
            if (addr) {
                stack.push(curr_addr);
                tree.goto(addr);
            } else {
                (fn, arity) = builtin[token.name]
                //ret_addr = stack.pop(1)
                args = stack.popN(arity)
                res = fn(args.reverce())
                stack.push(res)
                //tree.goto(ret_addr)
            }
    }
}

function eval(ast, stack) {
    for(let node of ast) {
        switch(node.type) {
            case value: 
                stack.push(node.value);
                break;
            case word:
                let word_node = ast_find_before(ast, node);
                if (word_node) {
                    eval(word_node.body, stack);
                }
                else {
                    let fn = builtin[node.name];
                    if (fn) {
                        args = stack.popN(arity);
                        res = fn(args.reverce());
                        stack.push(res);
                    } 
                    else {
                        throw new Error("undefined word ${node.name}");
                    }
                }
        }
    }
}

// find def body
function ast_find_before(ast, node_last) {
    const ast_slice = ast.slice(0, node_last.position).reverse();
    for(let node of ast_slice) {
        if node.type === def {
            return node;
        }
    }
    return null;
}


------------------------------

": foo 5 ;"
": bar foo ;"
": foo 6 ;"
"bar foo"

defs = [
    pos:0 (foo, [(val, 5)])
    pos:1 (bar, [(word, foo)])
    pos:2 (foo, [(val, 6)])
]

def = {
    (foo, [(val, 5)])
    next: {
        (bar, [(word, foo)])
        next: {
            (foo, [(val, 6)])
            next: null
        }
    }
}


function eval(ast, stack) {
    for(let node of ast) {
        switch(node.type) {
            case def:
                defs.push(node);
                break;
            case value: 
                stack.push(node.value);
                break;
            case word:
                let word_node = defs.find_before(node);
                if (word_node) {
                    eval(word_node.body, stack, defs);
                }
                else {
                    let fn = builtin[node.name];
                    if (fn) {
                        args = stack.popN(arity);
                        res = fn(args.reverce());
                        stack.push(res);
                    } 
                    else {
                        throw new Error("undefined word ${node.name}");
                    }
                }
        }
    }
}

-------------------------------------

function eval(ast, stack, defs) {
    for(let node of ast) {
        switch(node.type) {
            case def:
                defs = {node:node, next:defs};
                break;
            case value: 
                stack.push(node.value);
                break;
            case word:
                let f = find(defs, node);
                if (f) {
                    eval(f.node.body, stack, f.defs.next);
                }
                else {
                    let fn = builtin[node.name];
                    if (fn) {
                        args = stack.popN(arity);
                        res = fn(args.reverce());
                        stack.push(res);
                    } 
                    else {
                        throw new Error("undefined word ${node.name}");
                    }
                }
        }
    }
}

find(defs, node) {
    let v = defs.next;
    while(v) {
        if (v.name === node.name) {
            return v;
        }
        v = defs.next;
    }
    return false;
}