#nasm -f elf -F dwarf -g two_fer.asm
#ld -m elf_i386 -o demo two_fer.o
nasm -f elf64 -F dwarf -g two_fer.asm
ld -o demo two_fer.o
./demo
