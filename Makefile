objects = kernel.o

run: build
	qemu-system-x86_64 myos.iso 
	
build: $(objects)
	as --32 boot.s -o boot.o
	g++ -m32 -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib $(objects) boot.o -lgcc
	mkdir -p isodir/boot/grub
	cp myos.bin isodir/boot/myos.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o myos.iso isodir
	@echo "\ndone"

%.o: %.cpp
	g++ -c $< -o $@ -m32 -fno-use-cxa-atexit -Wno-write-strings -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore

clean:
	find . -name '*.o' -delete
	rm myos.iso
	rm -rf isodir