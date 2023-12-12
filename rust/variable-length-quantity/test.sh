clear
RUST_BACKTRACE=1
echo TEST
cargo test
echo ------------------------------------------------
echo CLIPPY
cargo clippy --all-targets