clear
# export RUST_BACKTRACE=1
# export RUSTFLAGS=-Zsanitizer=address RUSTDOCFLAGS=-Zsanitizer=address
# export RUSTFLAGS=-Zsanitizer=memory RUSTDOCFLAGS=-Zsanitizer=memory
export RUSTFLAGS=-Zsanitizer=leak RUSTDOCFLAGS=-Zsanitizer=leak
# export RUSTFLAGS=-Zsanitizer=thread RUSTDOCFLAGS=-Zsanitizer=thread
echo TEST
cargo +nightly test
echo ------------------------------------------------
echo CLIPPY
cargo +nightly clippy --all-targets --all-features
# cargo +nightly clippy --all-targets -- -W clippy::pedantic