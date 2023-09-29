use rinha_luajit_rs::{generate::generate, luajit};

#[test]
fn fib() {
    let path = "./tests/test-jsons/fib.json";
    let program = generate(path).expect("generation error");
    let ret = luajit::run(&program).expect("run error");
    assert_eq!("55\n", ret);
}

#[test]
fn combination() {
    let path = "./tests/test-jsons/combination.json";
    let program = generate(path).expect("generation error");
    let ret = luajit::run(&program).expect("run error");
    assert_eq!("45\n", ret);
}

#[test]
fn sum() {
    let path = "./tests/test-jsons/sum.json";
    let program = generate(path).expect("generation error");
    let ret = luajit::run(&program).expect("run error");
    assert_eq!("15\n", ret);
}

#[test]
fn loop_test() {
    let path = "./tests/test-jsons/loop.json";
    let program = generate(path).expect("generation error");
    let ret = luajit::run(&program).expect("run error");

    let mut v = Vec::with_capacity(4000001);
    for i in (0..=4000000).rev() {
        v.push(format!("{}\n", i));
    }

    assert_eq!(v.concat(), ret);
}

#[test]
fn arg_count() {
    let path = "./tests/test-jsons/func_args_count1.json";
    let program = generate(path).expect("generation error");
    let ret = luajit::run(&program).expect_err("too many arguments; should be an error");
    assert!(ret.contains("wrong argument count"));

    let path = "./tests/test-jsons/func_args_count2.json";
    let program = generate(path).expect("generation error");
    let ret = luajit::run(&program).expect_err("too few arguments; should be an error");
    assert!(ret.contains("wrong argument count"));
}

#[test]
fn tuple() {
    let path = "./tests/test-jsons/tuple.json";
    let program = generate(path).expect("generation error");
    let ret = luajit::run(&program).expect("run error");
    assert_eq!("1\n2\n", ret);
}

#[test]
fn tco() {
    let path = "./tests/test-jsons/tco.json";
    let program = generate(path).expect("generation error");
    let _ = luajit::run(&program).expect("run error");
}

#[test]
fn cps() {
    let path = "./tests/test-jsons/cps.json";
    let program = generate(path).expect("generation error");
    let ret = luajit::run(&program).expect("run error");
    assert_eq!("55\n", ret);
}

#[test]
fn cps2() {
    let path = "./tests/test-jsons/cps2.json";
    let program = generate(path).expect("generation error");
    let ret = luajit::run(&program).expect("run error");
    assert_eq!("500000500000\n50000005000000\n", ret);
}

#[test]
fn closure() {
    let path = "./tests/test-jsons/closure.rinha.json";
    let program = generate(path).expect("generation error");
    let ret = luajit::run(&program).expect("run error");
    assert_eq!("<#closure>\n", ret);
}

#[test]
fn concat() {
    let path = "./tests/test-jsons/concat.rinha.json";
    let program = generate(path).expect("generation error");
    let ret = luajit::run(&program).expect("run error");
    assert_eq!("ab\n109876543210\n", ret);
}

#[test]
fn arithm() {
    let path = "./tests/test-jsons/arithm.rinha.json";
    let program = generate(path).expect("generation error");
    let ret = luajit::run(&program).expect("run error");
    assert_eq!("2\n0\n100\n3\n1\nfalse\ntrue\ntrue\nfalse\nfalse\nfalse\ntrue\ntrue\ntrue\nfalse\ntrue\nfalse\ntrue\nfalse\nfalse\ntrue\ntrue\nfalse\nDONE\n", ret);
}

// #[test]
// fn crazy1() {
//     let path = "./tests/test-jsons/crazy1.rinha.json";
//     let program = generate(path).expect("generation error");
//     let _ret = luajit::run(&program).expect("run error");
// }
