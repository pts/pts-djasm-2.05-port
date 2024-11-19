/* Test libc calls for porting. */

#include <stdio.h>
#include <time.h>

/* DONE: scanf %[a-zA-Z0-9_$.@]
 * DONE: printf %#x
 * DONE: printf %.24s
 * DONE: printf (was good already): %lu
 */

int main(int argc, char **argv) {
  time_t ts = 1234567890;
  (void)argc; (void)argv;
  printf("A0(%#x)\n", 0);
  printf("A1(%#x)\n", 0x12ab);
  printf("BCU(%s)\n", ctime(&ts));
  printf("BCL(%.24s)\n", ctime(&ts));
  printf("B26(%.24s)\n", "ABCDEFGHIJKLMNOPQRSTUVWXYZ");
  printf("B25(%.24s)\n", "ABCDEFGHIJKLMNOPQRSTUVWXY");
  printf("B24(%.24s)\n", "ABCDEFGHIJKLMNOPQRSTUVWX");
  printf("B23(%.24s)\n", "ABCDEFGHIJKLMNOPQRSTUVW");
  printf("C(%lu)\n", 42L);
  return 0;
}
