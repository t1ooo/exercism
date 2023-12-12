use std::collections::HashMap;

type ID = usize;
pub type InputCellID = ID;
pub type ComputeCellID = ID;
pub type CallbackID = ID;

#[derive(Clone, Copy, Debug, PartialEq)]
pub enum CellID {
    Input(InputCellID),
    Compute(ComputeCellID),
}

#[derive(Debug, PartialEq)]
pub enum RemoveCallbackError {
    NonexistentCell,
    NonexistentCallback,
}

struct Item<'a, T> {
    calc_fn: Box<dyn Fn(&[T]) -> T + 'a>,
    callbacks: HashMap<usize, Box<dyn FnMut(T) + 'a>>,
    prev_value: Option<T>,
    deps: Vec<ID>,
}

impl<'a, T: Copy + PartialEq> Item<'a, T> {
    fn new(calc_fn: Box<dyn Fn(&[T]) -> T + 'a>, deps: Vec<ID>) -> Self {
        Self {
            calc_fn,
            deps,
            callbacks: HashMap::new(),
            prev_value: None,
        }
    }

    fn has_callback(&self, callbackid: CallbackID) -> bool {
        self.callbacks.contains_key(&callbackid)
    }
}

pub struct Reactor<'a, T> {
    data: Vec<Item<'a, T>>,
}

impl<'a, T: 'a + Copy + PartialEq> Default for Reactor<'a, T> {
    fn default() -> Self {
        Self::new()
    }
}

impl<'a, T: 'a + Copy + PartialEq> Reactor<'a, T> {
    pub fn new() -> Self {
        Self { data: vec![] }
    }

    pub fn create_input(&mut self, initial: T) -> InputCellID {
        let id = self.data.len();
        let calc_fn: Box<dyn Fn(&[T]) -> T> = Box::new(move |_| initial);
        let item = Item::new(calc_fn, vec![]);
        self.data.push(item);
        id
    }

    pub fn create_compute<F: Fn(&[T]) -> T + 'a>(
        &mut self,
        dependencies: &[CellID],
        compute_func: F,
    ) -> Result<ComputeCellID, CellID> {
        for cellid in dependencies.iter() {
            let id = unwrap_id(*cellid);
            if !self.has_item(id) {
                return Err(*cellid);
            }
        }

        let deps = dependencies
            .iter()
            .map(|cellid| unwrap_id(*cellid))
            .collect::<Vec<ID>>();

        let calc_fn: Box<dyn Fn(&[T]) -> T> = Box::new(compute_func);
        let id = self.data.len();
        let item = Item::new(calc_fn, deps);
        self.data.push(item);
        self.data[id].prev_value = self.value(CellID::Input(id));
        Ok(id)
    }

    pub fn value(&mut self, cellid: CellID) -> Option<T> {
        let id = unwrap_id(cellid);
        if !self.has_item(id) {
            return None;
        }

        let mut deps_vals = vec![];
        for i in 0..self.data[id].deps.len() {
            let cellid = CellID::Compute(self.data[id].deps[i]);
            deps_vals.push(self.value(cellid).unwrap());
        }

        let val = (self.data[id].calc_fn)(&deps_vals);

        if let Some(v) = self.data[id].prev_value {
            if v != val {
                for cb in self.data[id].callbacks.values_mut() {
                    cb(val);
                }
            }
        }

        self.data[id].prev_value = Some(val);
        Some(val)
    }

    pub fn set_value(&mut self, id: InputCellID, new_value: T) -> bool {
        if !self.has_item(id) {
            return false;
        }
        let calc_fn: Box<dyn Fn(&[T]) -> T> = Box::new(move |_| new_value);
        self.data[id].calc_fn = calc_fn;
        for j in 0..self.data.len() {
            self.value(CellID::Input(j));
        }
        true
    }

    pub fn add_callback<F: Fn(T) + 'a>(
        &mut self,
        id: ComputeCellID,
        callback: F,
    ) -> Option<CallbackID> {
        if !self.has_item(id) {
            return None;
        }
        let cb_id = gen_id();
        let cb: Box<dyn FnMut(T)> = Box::new(callback);
        self.data[id].callbacks.insert(cb_id, cb);
        Some(cb_id)
    }

    pub fn remove_callback(
        &mut self,
        cellid: ComputeCellID,
        callbackid: CallbackID,
    ) -> Result<(), RemoveCallbackError> {
        if !self.has_item(cellid) {
            return Err(RemoveCallbackError::NonexistentCell);
        }
        if !self.data[cellid].has_callback(callbackid) {
            return Err(RemoveCallbackError::NonexistentCallback);
        }
        self.data[cellid].callbacks.remove(&callbackid);
        Ok(())
    }

    fn has_item(&self, id: ID) -> bool {
        id < self.data.len()
    }
}

fn unwrap_id(cellid: CellID) -> ID {
    match cellid {
        CellID::Input(v) => v,
        CellID::Compute(v) => v,
    }
}

fn gen_id() -> ID {
    rand::random::<usize>()
}
