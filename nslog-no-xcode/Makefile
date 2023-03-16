run: a.out
	./a.out
.PHONY: run

a.out: main.m
	gcc -Wall -framework Foundation -mmacosx-version-min=10.4 -mcpu=750 main.m

clean:
	rm -f a.out
.PHONY: clean
