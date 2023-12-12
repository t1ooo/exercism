clear
echo TEST
cargo +nightly test
echo ------------------------------------------------
echo CLIPPY
cargo +nightly clippy --all-targets