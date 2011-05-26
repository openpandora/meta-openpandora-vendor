OBJECTS=mem

CFLAGS=-g -O0 -Wall 
LIBS= -lm

all: $(OBJECTS)

%: %.c
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

clean:
	-rm $(OBJECTS)
