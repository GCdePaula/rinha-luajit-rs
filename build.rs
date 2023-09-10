use std::process::Command;

fn main() {
    let _ = Command::new("git")
        .arg("apply")
        .arg("luajit_patch.patch")
        .arg("--directory=luajit/")
        .status();

    // Compile source
    assert!(Command::new("make")
        .current_dir("luajit")
        .env("MACOSX_DEPLOYMENT_TARGET", "13.5")
        .status()
        .expect("Failed to build luajit")
        .success());

    // Add source to OUT_DIR
    let out = std::env::var_os("OUT_DIR").expect("OUT_DIR not set");

    assert!(Command::new("cp")
        .arg("luajit/src/libluajit.a")
        .arg(out.clone())
        .status()
        .expect("Failed to build luajit")
        .success());

    println!(
        "cargo:rustc-link-search=native={}",
        out.into_string()
            .expect("failed to convert OUT_DIR to string")
    );
    println!("cargo:rustc-link-lib=static=luajit");
    println!("cargo:rerun-if-changed=luajit/");
}
