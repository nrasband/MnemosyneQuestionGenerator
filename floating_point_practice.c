#include <stdio.h>
#include <stdlib.h>
#include <float.h>

int main(int argc, char *argv[])
{
  // Try subtracting from FLT_MAX and see if it is still equal to FLT_MAX.
  float f = FLT_MAX;
  f -= 234589.23f;
  if (f == FLT_MAX)
  {
      puts("FLT_MAX is really big!");
  }
  else
  {
      puts("The cake is a lie.");
  }
}


