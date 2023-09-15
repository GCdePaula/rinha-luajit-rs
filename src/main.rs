use rinha_luajit_rs::generate;
use rinha_luajit_rs::luajit;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = std::env::args().collect();
    assert!(args.len() > 1, "Missing AST json path");
    let path = &args[1];

    let program = generate::generate(path)?;
    // println!("{}", program);

    let ret = luajit::run(&program)?;
    print!("{}", ret);
    Ok(())
}
