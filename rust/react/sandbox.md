class Reactor:
    new():
        $.data = {}
        $.callbacks = {}
        $.prev_vals = {}

    create_input(val) -> id:
        id = gen_id()
        $.data[id] = () => val
        return id

    create_compute(ids, fn):
        for id in ids:
            must(id in $.data, Error("id not exists"))

        id = gen_id()
        $.data[id] = () => {
            values = ids.map(id => $.value(id))
            val = fn(values)
            if id in $.callbacks && $.prev_vals[id] != val:
                $.callbacks[id](val)
                prev_vals[id] = val;
            return val
        }
        return id

    value(id):
        must(id in $.data, Error("id not exists"))
        return $data[id]()

    set_value(id, val):
        must(id in $.data, Error("id not exists"))
        $.data[id] = () => val

    add_callback(id, fn):
        must(id in $.data, Error("id not exists"))
        $.callbacks[id].push(fn);
        return id

    remove_callback(id, fn):
        //must(id in $.callbacks, Error("id not exists"))
        //delete $.callbacks[id];
        for cb in $callback[id]:
            if cb == fn {
                remove cb from $callback[id]
                return
            }
        Error("callback not exists")

// --------------------------------------

class Item {
    calc_fn
    callbacks
    prev_value

    new(calc_fn):
        return Item {
            calc_fn: calc_fn
            callbacks: []
            prev_value: null
        }
}

class Reactor:
    new():
        $.data = {}

    create_input(val) -> id:
        id = gen_id()
        $.data[id] = new Item {() => val}
        return id

    create_compute(ids, fn):
        for id in ids:
            must(id in $.data, Error("id not exists"))

        id = gen_id()
        $.data[id] = new Item{() => {
            values = ids.map(id => $.value(id))
            val = fn(values)
            if $.data[id].prev_vals != val: 
                $.data[id].callbacks.forEach(x => cb(x))
                prev_vals[id] = val;
            return val
        })}
        return id

    value(id):
        must(id in $.data, Error("id not exists"))
        return $data[id].calc_fn()

    set_value(id, val):
        must(id in $.data, Error("id not exists"))
        $.data[id].calc_fn = () => val

    // todo: fn id
    add_callback(id, fn):
        must(id in $.data, Error("id not exists"))
        $.data[id].callbacks.push(fn);
        return id

    remove_callback(id, fn):
        if not $.data[id].callbacks.any(x => x == fn) {
            return Error("callback not exists")
        }
        $.data[id].callbacks = $.data[id].callbacks.filter(x => x == fn)

// --------------------------------------

class Item {
    calc_fn
    callbacks
    prev_value
    deps

    new(calc_fn, deps):
        return Item {
            calc_fn: calc_fn
            deps: deps
            callbacks: []
            prev_value: null
        }
    
    value(deps_vals):
        val = calc_fn(deps_vals)
        if $.prev_value != val: 
            $.callbacks.forEach(x => cb(x))
            $.prev_value = val;
        return val
}

class ReactorV2:
    new():
        $.data = {}

    create_input(val) -> id:
        id = gen_id()
        $.data[id] = new Item ((_) => val, [])
        return id

    create_compute(deps_ids, fn):
        for id in deps_ids:
            must(id in $.data, Error("id not exists"))

        id = gen_id()
        $.data[id] = new Item{fn, deps_ids}
        return id

    value(id):
        must(id in $.data, Error("id not exists"))
        return $data[id].value()

    set_value(id, val):
        must(id in $.data, Error("id not exists"))
        $.data[id].setFn(() => val)

    // todo: fn id
    add_callback(id, fn):
        must(id in $.data, Error("id not exists"))
        $.data[id].callbacks.push(fn);
        return id

    remove_callback(id, fn):
        if not $.data[id].callbacks.any(x => x == fn) {
            return Error("callback not exists")
        }
        $.data[id].callbacks = $.data[id].callbacks.filter(x => x == fn)
