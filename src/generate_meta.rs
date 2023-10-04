use serde::Deserialize;

use crate::ast::{Binary, BinaryOp, Kind, Term};

const EVAL: &str = include_str!("meta-eval");
const POSTLUDE: &str = include_str!("meta-run");

fn gen_bin(exp: &str, bin: &Binary) -> String {
    let lhs = term(&bin.lhs);
    let rhs = term(&bin.rhs);
    format!("({exp}, ({lhs}, {rhs}))")
}

fn bin_op(bin: &Binary) -> String {
    match bin.op {
        BinaryOp::Add => gen_bin("ExpAdd", bin),
        BinaryOp::Sub => gen_bin("ExpSub", bin),
        BinaryOp::Mul => gen_bin("ExpMul", bin),
        BinaryOp::Div => gen_bin("ExpDiv", bin),
        BinaryOp::Rem => gen_bin("ExpRem", bin),
        BinaryOp::Eq => gen_bin("ExpEq", bin),
        BinaryOp::Neq => gen_bin("ExpNeq", bin),
        BinaryOp::Lt => gen_bin("ExpLt", bin),
        BinaryOp::Gt => gen_bin("ExpGt", bin),
        BinaryOp::Lte => gen_bin("ExpLte", bin),
        BinaryOp::Gte => gen_bin("ExpGte", bin),
        BinaryOp::And => gen_bin("ExpAns", bin),
        BinaryOp::Or => gen_bin("ExpOr", bin),
    }
}

fn term(t: &Term) -> String {
    match &t.kind {
        Kind::Error(ref e) => panic!("{}", e.message.clone()),

        Kind::Int(i) => format!("(ExpK, {})", &i.value.to_string()),

        Kind::Str(s) => format!("(ExpS, \"{}\")", &s.value.to_string()),

        Kind::Bool(b) => match b.value {
            true => "(ExpB, true)".to_string(),
            false => "(ExpB, false)".to_string(),
        },

        Kind::Var(v) => {
            let name = &v.text;
            format!("(ExpVar, \"{name}\")")
        }

        Kind::Binary(ref bin) => bin_op(bin),

        Kind::Call(c) => {
            let callee = term(&c.callee);
            let mut s = format!("(ExpApp, ({callee}, (ExpU, 0)))");
            for arg in &c.arguments {
                let a = term(&arg);
                s = format!("(ExpApp, ({s}, {a}))");
            }
            s
        }

        Kind::Function(f) => {
            let mut body = term(&f.value);
            for param in f.parameters.iter().rev() {
                let p = &param.text;
                body = format!("(ExpLambda, (\"{p}\", {body}))");
            }
            format!("(ExpLambda, (\"unit\", {body}))")
        }

        Kind::Let(l) => {
            let name = &l.name.text;
            let value = term(&l.value);
            let next = term(&l.next);
            format!("(ExpLet, (\"{name}\", ({value}, {next})))")
        }

        Kind::If(c) => {
            let cond = term(&c.condition);
            let then = term(&c.then);
            let otherwise = term(&c.otherwise);
            format!("(ExpIf, ({cond}, ({then}, {otherwise})))")
        }

        Kind::Print(p) => {
            let p = term(&p.value);
            format!("(ExpPrint, {p})")
        }

        Kind::First(f) => {
            let f = term(&f.value);
            format!("(ExpFirst, {f})")
        }

        Kind::Second(s) => {
            let s = term(&s.value);
            format!("(ExpSecond, {s})")
        }

        Kind::Tuple(t) => {
            let f = term(&t.first);
            let s = term(&t.second);
            format!("(ExpT, ({f}, {s}))")
        }
    }
}

pub fn generate(path: &str) -> Result<String, String> {
    let data = std::fs::read_to_string(path).expect("Unable to read file");

    let mut deserializer = serde_json::Deserializer::from_str(&data);
    deserializer.disable_recursion_limit();
    let deserializer = serde_stacker::Deserializer::new(&mut deserializer);
    let ast = crate::ast::File::deserialize(deserializer).map_err(|e| format!("{}", e))?;

    let prog = format!("{EVAL} {};\n {POSTLUDE}", term(&ast.expression));

    Ok(prog)
}
