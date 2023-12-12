#include <stdio.h>
#include <string.h>
#include <assert.h>

int str_isalpha(char* str) {
  if (0 == strlen(str)) {
    return 0;
  }
  while (*str) {
    //printf("%c:%d\n", str[0], (int)str[0]);
    int char_code = (int)str[0];
    //int isalpha = 
    //    (65 <= char_code && char_code <= 90)  || 
    //    (97 <= char_code && char_code <= 122);

    int a = (65 <= char_code);
    int b = (char_code <= 90);
    
    int c = (97 <= char_code);
    int d = (char_code <= 122);

    int ab = a && b;
    int cd = c && d;

    int isalpha = ab || cd;

    if (!isalpha) {
      return 0;
    }
    str++;
  }
  return 1;
}

int main(void) {
  assert(1 == str_isalpha("HelloWorld"));
  assert(1 == str_isalpha("helloworld"));
  assert(1 == str_isalpha("HELLOWORLD"));
  
  assert(0 == str_isalpha("Hello World"));
  assert(0 == str_isalpha("HelloWorld7"));
  assert(0 == str_isalpha(" "));
  assert(0 == str_isalpha(""));

  return 0;
}
