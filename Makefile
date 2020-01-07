.PHONY : all clean

all: clean
	sh ./make.sh

clean:
	rm -rf obj/*
