clear
export RUSTFLAGS="-Z macro-backtrace"
echo TEST
cargo +nightly test
echo ------------------------------------------------
echo Bench
cargo +nightly bench
echo ------------------------------------------------
echo CLIPPY
cargo +nightly clippy --all-targets