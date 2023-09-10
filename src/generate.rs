use crate::ast::{Binary, BinaryOp, First, Kind, Second, Term};
use std::{error::Error, fmt::Write};

const PRELUDE: &str = r#"
-- Prelude
local bit = require "bit"
local __to_bit = bit.tobit

local __buffer = require "string.buffer".new(1024)

getmetatable('').__add = function(lhs, rhs) return tostring(lhs) .. tostring(rhs) end

local __print = function(x)
    __buffer:put(x)
    __buffer:put "\n"
    return x
end

local __assert = assert

local __floor = math.floor

setfenv(1, {})

local __ret

-- Prelude end

-- code start
do
"#;

const POSTLUDE: &str = r#"
end
-- end code

return __buffer:tostring()
"#;

fn anotate(term: &mut Term, last: bool) -> bool {
    term.last = last;
    let kind = &mut term.kind;
    match kind {
        Kind::Call(ref mut c) => {
            term.binds = term.binds || anotate(&mut c.callee, false);

            for mut a in &mut c.arguments {
                term.binds = term.binds || anotate(&mut a, false);
            }
        }

        Kind::Binary(ref mut b) => {
            term.binds = term.binds || anotate(&mut b.lhs, false);
            term.binds = term.binds || anotate(&mut b.rhs, false);
        }

        Kind::Print(ref mut p) => {
            term.binds = term.binds || anotate(&mut p.value, false);
        }

        Kind::First(First { ref mut value, .. }) | Kind::Second(Second { ref mut value, .. }) => {
            term.binds = term.binds || anotate(&mut *value, false);
        }

        Kind::Tuple(ref mut t) => {
            term.binds = term.binds || anotate(&mut t.first, false);
            term.binds = term.binds || anotate(&mut t.second, false);
        }

        Kind::Error(_) | Kind::Int(_) | Kind::Str(_) | Kind::Bool(_) | Kind::Var(_) => {
            term.binds = false
        }

        Kind::Function(f) => {
            anotate(&mut f.value, true);
            term.binds = false
        }

        Kind::If(ref mut i) => {
            anotate(&mut i.condition, false);
            anotate(&mut i.then, last);
            anotate(&mut i.otherwise, last);
            term.binds = true;
        }

        Kind::Let(l) => {
            term.last = false;
            anotate(&mut l.value, false);
            anotate(&mut l.next, last);
            term.binds = true;
        }
    }

    term.binds
}

fn generate_scope(code: &mut String) -> Result<(), Box<dyn Error>> {
    writeln!(code, "do")?;
    Ok(())
}

fn close_scope(code: &mut String) -> Result<(), Box<dyn Error>> {
    writeln!(code, "end")?;
    Ok(())
}

fn generate_bindings(
    code: &mut String,
    temps: usize,
    num: usize,
) -> Result<Vec<String>, Box<dyn Error>> {
    generate_scope(code)?;
    let mut ret = Vec::with_capacity(num);

    for i in 0..num {
        let binding = format!("__temp_{}", temps + i);
        writeln!(code, "local {}", binding)?;
        ret.push(binding);
    }

    Ok(ret)
}

fn generate_binding(code: &mut String, temps: usize) -> Result<String, Box<dyn Error>> {
    generate_scope(code)?;
    let binding = format!("__temp_{}", temps);
    writeln!(code, "local {}", binding)?;
    Ok(binding)
}

fn generate_free_infix(
    code: &mut String,
    token: &str,
    bin_op: &Binary,
) -> Result<(), Box<dyn Error>> {
    generate_free_term(code, &bin_op.lhs)?;
    write!(code, " {} ", token)?;
    generate_free_term(code, &bin_op.rhs)?;
    Ok(())
}

fn generate_infix(
    code: &mut String,
    token: &str,
    bin_op: &Binary,
    temps: usize,
    bind: String,
) -> Result<(), Box<dyn Error>> {
    let lhs = generate_binding(code, temps)?;
    generate_term(code, &bin_op.lhs, temps + 1, lhs.clone())?;

    if bin_op.rhs.binds {
        let rhs = generate_binding(code, temps)?;
        generate_term(code, &bin_op.rhs, temps + 1, rhs.clone())?;
        writeln!(code, "{} = {} {} {} ", bind, lhs, token, rhs)?;
        close_scope(code)?;
    } else {
        write!(code, "{} = {} {} ", bind, lhs, token)?;
        generate_free_term(code, &bin_op.rhs)?;
    }
    close_scope(code)?;

    Ok(())
}

fn generate_free_bin_op(code: &mut String, bin_op: &Binary) -> Result<(), Box<dyn Error>> {
    match bin_op.op {
        BinaryOp::Add => {
            write!(code, "__to_bit(")?;
            generate_free_term(code, &bin_op.lhs)?;
            write!(code, " + ")?;
            generate_free_term(code, &bin_op.rhs)?;
            write!(code, ") ")?;

            Ok(())
        }

        BinaryOp::Sub => {
            write!(code, "__to_bit(")?;
            generate_free_term(code, &bin_op.lhs)?;
            write!(code, " - ")?;
            generate_free_term(code, &bin_op.rhs)?;
            write!(code, ") ")?;

            Ok(())
        }

        BinaryOp::Mul => {
            write!(code, "__to_bit(")?;
            generate_free_term(code, &bin_op.lhs)?;
            write!(code, " * ")?;
            generate_free_term(code, &bin_op.rhs)?;
            write!(code, ") ")?;
            Ok(())
        }

        BinaryOp::Div => {
            write!(code, "__to_bit(__floor(")?;
            generate_free_term(code, &bin_op.lhs)?;
            write!(code, ",")?;
            generate_free_term(code, &bin_op.rhs)?;
            write!(code, ")) ")?;
            Ok(())
        }

        BinaryOp::Rem => {
            generate_free_infix(code, " % ", bin_op)?;
            Ok(())
        }

        BinaryOp::Eq => {
            generate_free_infix(code, " == ", bin_op)?;
            Ok(())
        }

        BinaryOp::Neq => {
            generate_free_infix(code, " ~= ", bin_op)?;
            Ok(())
        }

        BinaryOp::Lt => {
            generate_free_infix(code, " < ", bin_op)?;
            Ok(())
        }

        BinaryOp::Gt => {
            generate_free_infix(code, " > ", bin_op)?;
            Ok(())
        }

        BinaryOp::Lte => {
            generate_free_infix(code, " <= ", bin_op)?;
            Ok(())
        }

        BinaryOp::Gte => {
            generate_free_infix(code, " >= ", bin_op)?;
            Ok(())
        }

        BinaryOp::And => {
            write!(code, "not not (")?;
            generate_free_infix(code, " and ", bin_op)?;
            write!(code, ")")?;
            Ok(())
        }

        BinaryOp::Or => {
            write!(code, "not not (")?;
            generate_free_infix(code, " or ", bin_op)?;
            write!(code, ")")?;
            Ok(())
        }
    }
}

fn generate_bin_op(
    code: &mut String,
    bin_op: &Binary,
    temps: usize,
    bind: String,
) -> Result<(), Box<dyn Error>> {
    match bin_op.op {
        BinaryOp::Add => {
            let lhs = generate_binding(code, temps)?;
            generate_term(code, &bin_op.lhs, temps + 1, lhs.clone())?;

            if bin_op.rhs.binds {
                let rhs = generate_binding(code, temps)?;
                generate_term(code, &bin_op.rhs, temps + 1, rhs.clone())?;
                writeln!(code, "{} = __to_bit({} + {})", bind, lhs, rhs)?;
                close_scope(code)?;
            } else {
                write!(code, "{} = __to_bit({} + ", bind, lhs)?;
                generate_free_term(code, &bin_op.rhs)?;
                writeln!(code, ")")?;
            }

            close_scope(code)?;

            Ok(())
        }

        BinaryOp::Sub => {
            let lhs = generate_binding(code, temps)?;
            generate_term(code, &bin_op.lhs, temps + 1, lhs.clone())?;

            if bin_op.rhs.binds {
                let rhs = generate_binding(code, temps)?;
                generate_term(code, &bin_op.rhs, temps + 1, rhs.clone())?;
                writeln!(code, "{} = __to_bit({} - {})", bind, lhs, rhs)?;
                close_scope(code)?;
            } else {
                write!(code, "{} = __to_bit({} - ", bind, lhs)?;
                generate_free_term(code, &bin_op.rhs)?;
                writeln!(code, ")")?;
            }

            close_scope(code)?;

            Ok(())
        }

        BinaryOp::Mul => {
            let lhs = generate_binding(code, temps)?;
            generate_term(code, &bin_op.lhs, temps + 1, lhs.clone())?;

            if bin_op.rhs.binds {
                let rhs = generate_binding(code, temps)?;
                generate_term(code, &bin_op.rhs, temps + 1, rhs.clone())?;
                writeln!(code, "{} = __to_bit({} * {})", bind, lhs, rhs)?;
                close_scope(code)?;
            } else {
                write!(code, "{} = __to_bit({} * ", bind, lhs)?;
                generate_free_term(code, &bin_op.rhs)?;
                writeln!(code, ")")?;
            }

            close_scope(code)?;

            Ok(())
        }

        BinaryOp::Div => {
            let lhs = generate_binding(code, temps)?;
            generate_term(code, &bin_op.lhs, temps + 1, lhs.clone())?;

            if bin_op.rhs.binds {
                let rhs = generate_binding(code, temps)?;
                generate_term(code, &bin_op.rhs, temps + 1, rhs.clone())?;
                writeln!(code, "{} = __to_bit(__floor({} / {}))", bind, lhs, rhs)?;
                close_scope(code)?;
            } else {
                write!(code, "{} = __to_bit(__floor({} / ", bind, lhs)?;
                generate_free_term(code, &bin_op.rhs)?;
                writeln!(code, "))")?;
            }

            close_scope(code)?;
            Ok(())
        }

        BinaryOp::Rem => {
            generate_infix(code, " % ", bin_op, temps, bind)?;
            Ok(())
        }

        BinaryOp::Eq => {
            generate_infix(code, " == ", bin_op, temps, bind)?;
            Ok(())
        }

        BinaryOp::Neq => {
            generate_infix(code, " ~= ", bin_op, temps, bind)?;
            Ok(())
        }

        BinaryOp::Lt => {
            generate_infix(code, " < ", bin_op, temps, bind)?;
            Ok(())
        }

        BinaryOp::Gt => {
            generate_infix(code, " > ", bin_op, temps, bind)?;
            Ok(())
        }

        BinaryOp::Lte => {
            generate_infix(code, " <= ", bin_op, temps, bind)?;
            Ok(())
        }

        BinaryOp::Gte => {
            generate_infix(code, " >= ", bin_op, temps, bind)?;
            Ok(())
        }

        BinaryOp::And => {
            write!(code, "not not (")?;
            generate_infix(code, " and ", bin_op, temps, bind)?;
            write!(code, ")")?;
            Ok(())
        }

        BinaryOp::Or => {
            write!(code, "not not (")?;
            generate_infix(code, " or ", bin_op, temps, bind)?;
            write!(code, ")")?;
            Ok(())
        }
    }
}

fn generate_free_term(code: &mut String, term: &Term) -> Result<(), Box<dyn Error>> {
    assert!(!term.binds);

    match &term.kind {
        Kind::Error(e) => Err(e.message.clone().into()),

        Kind::Int(i) => {
            write!(code, " {} ", &i.value.to_string())?;
            Ok(())
        }

        Kind::Str(s) => {
            write!(code, " \"{}\" ", &s.value.to_string())?;
            Ok(())
        }

        Kind::Call(c) => {
            generate_free_term(code, &c.callee)?;
            write!(code, "(")?;
            let l = c.arguments.len();
            for (i, a) in c.arguments.iter().enumerate() {
                generate_free_term(code, &a)?;

                if i != l - 1 {
                    write!(code, ",")?;
                }
            }
            write!(code, ")")?;

            Ok(())
        }

        Kind::Binary(bin_op) => {
            generate_free_bin_op(code, bin_op)?;
            Ok(())
        }

        Kind::Function(f) => {
            write!(code, "function(")?;
            for a in f.parameters.iter() {
                write!(code, "var_{}, ", a.text)?;
            }
            writeln!(code, "__sentinel)")?;

            if let Some(last) = f.parameters.last() {
                writeln!(
                    code,
                    "__assert(var_{} and not __sentinel, 'wrong argument count')",
                    last.text
                )?;
            }
            let ret = generate_binding(code, 0)?;

            generate_term(code, &f.value, 1, ret.clone())?;

            writeln!(code, "return {} end", ret)?;
            close_scope(code)?;
            Ok(())
        }

        Kind::Let(_) => {
            unreachable!("let in always binds")
        }

        Kind::If(_) => {
            unreachable!("if always binds")
        }

        Kind::Print(p) => {
            write!(code, "__print(")?;
            generate_free_term(code, &p.value)?;
            writeln!(code, ")")?;
            Ok(())
        }

        Kind::First(f) => {
            generate_free_term(code, &f.value)?;
            writeln!(code, "[1]")?;
            Ok(())
        }

        Kind::Second(s) => {
            generate_free_term(code, &s.value)?;
            writeln!(code, "[2]")?;
            Ok(())
        }

        Kind::Bool(b) => {
            match b.value {
                true => write!(code, "true")?,
                false => write!(code, "false")?,
            }

            Ok(())
        }

        Kind::Tuple(t) => {
            write!(code, "{{")?;
            generate_free_term(code, &t.first)?;
            write!(code, ",")?;
            generate_free_term(code, &t.second)?;
            write!(code, "}}")?;

            Ok(())
        }

        Kind::Var(v) => {
            write!(code, " var_{} ", v.text)?;
            Ok(())
        }
    }
}

fn generate_term(
    code: &mut String,
    term: &Term,
    temps: usize,
    bind: String,
) -> Result<(), Box<dyn Error>> {
    if !term.binds {
        if !term.last {
            writeln!(code, "{} = ", bind)?;
            return generate_free_term(code, term);
        } else {
            write!(code, "do return ")?;
            generate_free_term(code, term)?;
            writeln!(code, "end ")?;
            return Ok(());
        }
    }

    match &term.kind {
        Kind::Error(ref e) => Err(e.message.clone().into()),

        Kind::Int(i) => {
            writeln!(code, "{} = {}", bind, &i.value.to_string())?;
            Ok(())
        }

        Kind::Str(s) => {
            writeln!(code, "{} = {}", bind, &s.value.to_string())?;
            Ok(())
        }

        Kind::Call(c) => {
            if c.callee.binds {
                let callee = generate_binding(code, temps + 1)?;
                let temps = temps + 1;
                generate_term(code, &c.callee, temps, callee.clone())?;

                if c.arguments.is_empty() {
                    if !term.last {
                        writeln!(code, "{} = {}()", bind, callee)?;
                    } else {
                        writeln!(code, "return {}()", callee)?;
                    }
                } else {
                    let mut last_binds = c.arguments.len() - 1;
                    for (i, a) in c.arguments.iter().enumerate().rev() {
                        if !a.binds {
                            last_binds = i;
                        } else {
                            break;
                        }
                    }

                    let binds = generate_bindings(code, temps, last_binds)?;
                    for b in binds.iter() {
                        generate_term(code, term, temps + last_binds, b.clone())?;
                    }

                    if !term.last {
                        write!(code, "{} = {}(", bind, callee)?;
                    } else {
                        write!(code, "return {}(", callee)?;
                    }

                    for (i, b) in binds.into_iter().enumerate() {
                        write!(code, "{}", b)?;
                        if i != last_binds - 1 {
                            write!(code, ",")?;
                        }
                    }

                    let frees = &c.arguments[last_binds..];
                    for (i, b) in frees.into_iter().enumerate() {
                        generate_free_term(code, b)?;
                        if i != frees.len() - 1 {
                            write!(code, ",")?;
                        }
                    }

                    write!(code, ")")?;
                }
                close_scope(code)?;
            } else {
                if c.arguments.is_empty() {
                    write!(code, "{} = ", bind)?;
                    generate_free_term(code, &c.callee)?;
                    writeln!(code, "()")?;
                } else {
                    let mut last_binds = c.arguments.len() - 1;
                    for (i, a) in c.arguments.iter().enumerate().rev() {
                        if !a.binds {
                            last_binds = i;
                        } else {
                            break;
                        }
                    }

                    let binds = generate_bindings(code, temps, last_binds)?;
                    for b in binds.iter() {
                        generate_term(code, term, temps + last_binds, b.clone())?;
                    }

                    write!(code, "{} = ", bind)?;
                    generate_free_term(code, &c.callee)?;
                    write!(code, "(")?;

                    for (i, b) in binds.into_iter().enumerate() {
                        write!(code, "{}", b)?;
                        if i != last_binds - 1 {
                            write!(code, ",")?;
                        }
                    }

                    let frees = &c.arguments[last_binds..];
                    for (i, b) in frees.into_iter().enumerate() {
                        generate_free_term(code, b)?;
                        if i != frees.len() - 1 {
                            write!(code, ",")?;
                        }
                    }

                    write!(code, ")")?;
                }
            }

            Ok(())
        }

        Kind::Binary(ref bin_op) => {
            generate_bin_op(code, bin_op, temps, bind)?;
            Ok(())
        }

        Kind::Function(f) => {
            write!(code, "{} = function(", bind)?;
            let l = f.parameters.len();
            for (i, a) in f.parameters.iter().enumerate() {
                write!(code, "var_{}", a.text)?;
                if i != l - 1 {
                    write!(code, ",")?;
                }
            }
            writeln!(code, ")")?;

            let ret = generate_binding(code, 0)?;
            generate_term(code, &f.value, 1, ret.clone())?;
            writeln!(code, "return {} end", ret)?;
            close_scope(code)?;
            Ok(())
        }

        Kind::Let(l) => {
            let name = format!("var_{}", l.name.text);
            writeln!(code, "local {}", &name)?;
            generate_term(code, &l.value, temps + 1, name)?;
            generate_term(code, &l.next, temps + 1, bind)?;
            Ok(())
        }

        Kind::If(c) => {
            if c.condition.binds {
                let cond = generate_binding(code, temps)?;
                generate_term(code, &c.condition, temps + 1, cond.clone())?;
                writeln!(code, "if {} then", cond)?;
                close_scope(code)?;
            } else {
                write!(code, "if ")?;
                generate_free_term(code, &c.condition)?;
                writeln!(code, " then")?;
            }

            // if !c.last {
            generate_term(code, &c.then, temps + 1, bind.clone())?;
            writeln!(code, " else")?;
            generate_term(code, &c.otherwise, temps + 1, bind)?;
            writeln!(code, " end")?;
            // } else {
            //     if !c.then.binds {
            //         write!(code, " return ")?;
            //         generate_free_term(code, &c.then)?;
            //     } else {
            //         generate_term(code, &c.then, temps + 1, bind.clone())?;
            //     }

            //     writeln!(code, " else")?;

            //     if !c.otherwise.binds {
            //         write!(code, " return ")?;
            //         generate_free_term(code, &c.otherwise)?;
            //     } else {
            //         generate_term(code, &c.otherwise, temps + 1, bind)?;
            //     }

            //     writeln!(code, " end")?;
            // }
            Ok(())
        }

        Kind::Print(p) => {
            let arg = generate_binding(code, temps)?;
            generate_term(code, &p.value, temps + 1, arg.clone())?;
            writeln!(code, "__print({})", arg)?;
            close_scope(code)?;
            Ok(())
        }

        Kind::First(f) => {
            let arg = generate_binding(code, temps)?;
            generate_term(code, &f.value, temps + 1, arg.clone())?;
            writeln!(code, "{} = {}[1]", bind, arg)?;
            close_scope(code)?;
            Ok(())
        }

        Kind::Second(s) => {
            let arg = generate_binding(code, temps)?;
            generate_term(code, &s.value, temps + 1, arg.clone())?;
            writeln!(code, "{} = {}[2]", bind, arg)?;
            close_scope(code)?;
            Ok(())
        }

        Kind::Bool(b) => {
            match b.value {
                true => writeln!(code, "{} = true", bind)?,
                false => writeln!(code, "{} = false", bind)?,
            }
            Ok(())
        }

        Kind::Tuple(t) => {
            let f = generate_binding(code, temps)?;
            generate_term(code, &t.first, temps + 1, f.clone())?;

            if t.second.binds {
                let s = generate_binding(code, temps)?;
                generate_term(code, &t.second, temps + 1, s.clone())?;
                writeln!(code, "{{ {}, {} }}", f, s)?;
                close_scope(code)?;
            } else {
                write!(code, "{} = {{ {}, ", bind, f)?;
                generate_free_term(code, &t.second)?;
                writeln!(code, " }}")?;
            }

            close_scope(code)?;
            Ok(())
        }

        Kind::Var(v) => {
            writeln!(code, "{} = var_{} ", bind, v.text)?;
            Ok(())
        }
    }
}

pub fn generate(path: &str) -> Result<String, Box<dyn Error>> {
    let data = std::fs::read_to_string(path).expect("Unable to read file");
    let mut ast: crate::ast::File = serde_json::from_str(&data)?;
    anotate(&mut ast.expression, false);

    let mut code = String::with_capacity(8192);
    write!(code, "{}", PRELUDE)?;

    generate_term(&mut code, &ast.expression, 0, "__ret".to_owned())?;

    write!(code, "{}", POSTLUDE)?;
    Ok(code)
}
