use rinha_de_compiler::generate;
use rinha_de_compiler::luajit;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // let args: Vec<String> = std::env::args().collect();
    // assert!(args.len() > 0, "Missing AST json path");
    // let path = &args[0];

    let path = "./test.json";
    let program = generate::generate(path)?;
    // println!("{}", program);

    let ret = luajit::run(&program)?;
    print!("{}", ret);
    Ok(())
}
