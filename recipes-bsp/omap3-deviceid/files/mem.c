/*
  Copyright (C) 2009 Mans Rullgard

  Permission is hereby granted, free of charge, to any person
  obtaining a copy of this software and associated documentation files
  (the "Software"), to deal in the Software without restriction,
  including without limitation the rights to use, copy, modify, merge,
  publish, distribute, sublicense, and/or sell copies of the Software,
  and to permit persons to whom the Software is furnished to do so,
  subject to the following conditions:

  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>
#include <fcntl.h>

static void die(void)
{
    fprintf(stderr, "usage: memdump {-b|-h|-w} addr count\n");
    exit(1);
}

static void dump_word(void *p, long count, unsigned long offset)
{
    unsigned *d = p;
    int i;

    while (count > 0) {
        printf("%08lx:", offset);
        for (i = 0; i < 4 && count--; i++)
            printf(" %08x", *d++);
        printf("\n");
        offset += 16;
    }
}

static void dump_half(void *p, long count, unsigned long offset)
{
    unsigned short *d = p;
    int i;

    while (count > 0) {
        printf("%08lx:", offset);
        for (i = 0; i < 8 && count--; i++)
            printf(" %04x", *d++);
        printf("\n");
        offset += 16;
    }
}

static void dump_byte(void *p, long count, unsigned long offset)
{
    unsigned char *d = p;
    int i;

    while (count > 0) {
        printf("%08lx:", offset);
        for (i = 0; i < 16 && count--; i++)
            printf(" %02x", *d++);
        printf("\n");
        offset += 16;
    }
}

int main(int argc, char **argv)
{
    void (*dump_fun)(void *p, long count, unsigned long offset) = NULL;
    unsigned long offset, map_offset, map_size;
    long count;
    long pagesize;
    void *mem, *data;
    int type = 4;
    int fd;

    if (argc < 3) {
        die();
    }

    if (*argv[1] == '-') {
        if (argv[1][1] && argv[1][2])
            die();

        switch (argv[1][1]) {
        case 'b': type = 1; dump_fun = dump_byte; break;
        case 'h': type = 2; dump_fun = dump_half; break;
        case 'w': type = 4; dump_fun = dump_word; break;
        default:  die();
        }

        argc--;
        argv++;
    }

    if (argc < 3) {
        die();
    }

    offset = strtoul(argv[1], NULL, 0);
    count  = strtoul(argv[2], NULL, 0);

    fd = open("/dev/mem", O_RDONLY);
    if (fd == -1) {
        perror("/dev/mem");
        return 1;
    }

    pagesize = sysconf(_SC_PAGESIZE);
    map_offset = offset & ~(pagesize - 1);
    map_size = count * type + (offset & (pagesize - 1));
    map_size = (map_size + pagesize - 1) & ~(pagesize - 1);

    mem = mmap(NULL, map_size, PROT_READ, MAP_SHARED, fd, map_offset);
    if (mem == MAP_FAILED) {
        perror("mmap");
        exit(1);
    }

    data = (char*)mem + (offset - map_offset);

    dump_fun(data, count, offset);

    munmap(mem, map_size);
    close(fd);

    return 0;
}

