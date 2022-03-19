all: bootloader

bootloader:
	mkdir boot/bin
	nasm boot/boot.asm -f bin -o boot/bin/boot.bin
	nasm boot/kernal_entry.asm -f elf -o boot/bin/kernel_entry.bin
	
	gcc -m32 -ffreestanding -c boot/main.c -o boot/bin/kernal.o
	ld -m elf_i386 -o boot/bin/kernal.img -Ttext 0x1000 boot/bin/kernel_entry.bin boot/bin/kernal.o

	objcopy -O binary -j .text boot/bin/kernal.img boot/bin/kernel.bin
	cat boot/bin/boot.bin boot/bin/kernel.bin > os.img

clear:
	rm -f boot/boot.img

run:
	qemu-system-x86_64 -L "/usr/share/doc/qemu-system-x86" -drive format=raw,file=os.img