use rinha_luajit_rs::generate_meta;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = std::env::args().collect();
    assert!(args.len() > 1, "Missing AST json path");
    let path = &args[1];

    let program = generate_meta::generate(path)?;
    println!("{}", program);

    Ok(())
}
