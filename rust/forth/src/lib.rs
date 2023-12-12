use self::def::DefTable;
use self::interpreter::eval;
use self::parser::parse;
use self::tokenizer::tokenize;

pub type Value = isize;
pub type ForthResult = Result<(), Error>;

#[derive(Default)]
pub struct Forth {
    stack: Vec<Value>,
    dt: DefTable,
}

#[derive(Debug, PartialEq)]
pub enum Error {
    DivisionByZero,
    StackUnderflow,
    UnknownWord,
    InvalidWord,
    SyntaxError,
}

impl Forth {
    pub fn new() -> Forth {
        Self {
            stack: vec![],
            dt: DefTable::new(),
        }
    }

    pub fn stack(&self) -> Vec<Value> {
        self.stack.to_vec()
    }

    pub fn eval(&mut self, input: &str) -> ForthResult {
        let ast = parse(tokenize(input)?)?;
        eval(ast, &mut self.stack, &mut self.dt)
    }
}

mod tokenizer {
    use super::{Error, Value};

    #[derive(Debug, Clone, Copy, PartialEq)]
    pub enum Token {
        Number,
        StartDef,
        EndDef,
        Word,
    }

    pub fn tokenize(str: &str) -> Result<Vec<(Token, String)>, Error> {
        str.to_lowercase()
            .split_whitespace()
            .map(|x| {
                for (typ, func) in RULES.iter() {
                    if func(x) {
                        return Ok((*typ, x.to_string()));
                    }
                }
                Err(Error::SyntaxError)
            })
            .collect()
    }

    const RULES: [(Token, fn(&str) -> bool); 4] = [
        (Token::Number, is_number),
        (Token::StartDef, is_start_def),
        (Token::EndDef, is_end_def),
        (Token::Word, is_word),
    ];

    fn is_number(str: &str) -> bool {
        str.parse::<Value>().is_ok()
    }

    fn is_start_def(str: &str) -> bool {
        str == ":"
    }

    fn is_end_def(str: &str) -> bool {
        str == ";"
    }

    fn is_word(_str: &str) -> bool {
        true
    }
}

mod parser {
    use super::ast::{Ast, AstNode};
    use super::def::Def;
    use super::tokenizer::Token;
    use super::Error;

    macro_rules! unwrap_enum {
        ($v: expr, $t:path) => {
            match $v {
                $t(mv) => mv.clone(),
                _ => panic!("not a {}", stringify!($t)),
            }
        };
    }

    pub fn parse(tokens: Vec<(Token, String)>) -> Result<Ast, Error> {
        let mut ast = vec![];
        let mut buf = vec![];
        let mut is_def = false;

        for (token, literal) in tokens {
            match token {
                Token::StartDef => {
                    if is_def {
                        return Err(Error::InvalidWord);
                    }
                    ast.append(&mut buf);
                    buf.clear();
                    is_def = true;
                }
                Token::EndDef => {
                    if is_def && buf.len() > 1 && matches!(&buf[0], AstNode::Word(_)) {
                        ast.push(AstNode::Def(Def {
                            name: unwrap_enum!(&buf[0], AstNode::Word),
                            body: buf[1..].to_vec(),
                        }));
                        buf.clear();
                        is_def = false;
                    } else {
                        return Err(Error::InvalidWord);
                    }
                }
                Token::Number => {
                    buf.push(AstNode::Number(literal.parse().unwrap()));
                }
                Token::Word => {
                    buf.push(AstNode::Word(literal.clone()));
                }
            }
        }
        if is_def {
            return Err(Error::InvalidWord);
        }
        ast.append(&mut buf);
        Ok(ast)
    }
}

mod def {
    use super::ast::AstNode;

    #[derive(Debug, Clone)]
    pub struct Def {
        pub name: String,
        pub body: Vec<AstNode>,
    }

    #[derive(Default)]
    pub struct DefTable(Vec<Def>);

    impl DefTable {
        pub fn new() -> Self {
            Self(vec![])
        }

        fn from(data: Vec<Def>) -> Self {
            Self(data)
        }

        pub fn append(&mut self, value: Def) {
            self.0.push(value);
        }

        // return definition and def table with earlier definitions
        pub fn find(&self, name: &str) -> Option<(Def, Self)> {
            for (i, v) in self.0.iter().enumerate().rev() {
                if v.name == name {
                    return Some((self.0[i].clone(), DefTable::from(self.0[0..i].to_vec())));
                }
            }
            None
        }
    }
}

mod ast {
    use super::def::Def;
    use super::Value;

    #[derive(Debug, Clone)]
    pub enum AstNode {
        Number(Value),
        Def(Def),
        Word(String),
    }

    pub type Ast = Vec<AstNode>;
}

mod interpreter {
    use super::ast::{Ast, AstNode};
    use super::builtin::find;
    use super::def::DefTable;
    use super::{Error, Value};

    pub fn eval(ast: Ast, stack: &mut Vec<Value>, dt: &mut DefTable) -> Result<(), Error> {
        for node in ast {
            match node {
                AstNode::Def(def) => dt.append(def),
                AstNode::Number(num) => stack.push(num),
                AstNode::Word(word) => {
                    if let Some((def_node, mut def_scope)) = dt.find(&word) {
                        eval(def_node.body, stack, &mut def_scope)?;
                    } else {
                        let (arity, func) = find(&word).ok_or(Error::UnknownWord)?;
                        let args = pop_n(stack, arity)?;
                        let mut res = func(args)?;
                        stack.append(&mut res);
                    }
                }
            }
        }
        Ok(())
    }

    fn pop_n(stack: &mut Vec<Value>, n: usize) -> Result<Vec<Value>, Error> {
        if stack.len() < n {
            return Err(Error::StackUnderflow);
        }
        let tmp = stack.split_off(stack.len() - n);
        Ok(tmp)
    }
}

mod builtin {
    use super::{Error, Value};

    type Op = fn(OpArgs) -> OpResult;
    type OpArity = usize;
    type OpArgs = Vec<Value>;
    type OpResult = Result<Vec<Value>, Error>;

    pub fn find(name: &str) -> Option<(OpArity, Op)> {
        const BUILTINS: [(&str, OpArity, Op); 8] = [
            ("+", 2, add),
            ("-", 2, sub),
            ("*", 2, mul),
            ("/", 2, div),
            ("dup", 1, dup),
            ("drop", 1, drop),
            ("swap", 2, swap),
            ("over", 2, over),
        ];
        match BUILTINS.iter().find(|v| v.0 == name) {
            Some(f) => Some((f.1, f.2)),
            None => None,
        }
    }

    fn add(v: OpArgs) -> OpResult {
        Ok(vec![v[0] + v[1]])
    }

    fn sub(v: OpArgs) -> OpResult {
        Ok(vec![v[0] - v[1]])
    }

    fn mul(v: OpArgs) -> OpResult {
        Ok(vec![v[0] * v[1]])
    }

    fn div(v: OpArgs) -> OpResult {
        if v[1] != 0 {
            Ok(vec![v[0] / v[1]])
        } else {
            Err(Error::DivisionByZero)
        }
    }

    fn dup(v: OpArgs) -> OpResult {
        Ok(vec![v[0], v[0]])
    }

    fn drop(_v: OpArgs) -> OpResult {
        Ok(vec![])
    }

    fn swap(v: OpArgs) -> OpResult {
        Ok(vec![v[1], v[0]])
    }

    fn over(v: OpArgs) -> OpResult {
        Ok(vec![v[0], v[1], v[0]])
    }
}
