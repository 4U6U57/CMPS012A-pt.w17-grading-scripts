//-----------------------------------------------------------------------------
// PermutationTest.java
// 
// This program is a unit test of function nextPermutation() in the file 
// Queens.java from pa5. To use it, make sure Queens.java contains a function
// with the heading
//
//           static void nextPermutation(int[] P)
//
// that (you believe) meets the specifications in the pa5 project description.  
// Also create a helper function with the heading
//
//           static void printArray(int[] P)
//
// that prints the contents of P[1...n] to stdout according to the output
// format given in the pa5 project description. (Here n = P.length-1).
// Place this file in the same directory as Queens.java, then compile 
// PermutationTest.java and run it.  The output should be exactly that given 
// below. The algorithm for nextPermutation is given as a comment at the end 
// of this file.
//
// In general, static functions can be called from outside their class by
// doing: NameOfClass.NameOfFunction(..args..).
//
// Unit tests like this are a good example of "white box testing" as discussed
// in lab6. You should create a similar unit test module for function
// isPermutation(). Note that this is exactly what the program grader will be
// doing.
//
//-----------------------------------------------------------------------------

class PermutationTest{

   public static void main(String[] args){
      int[] A = {0,6,5,4,8,7,3,2,1};
      int[] B = {0,1,2,3,4};

      // test: 
      // advance A[] one step
      Queens.printArray(A);
      Queens.nextPermutation(A);
      Queens.printArray(A);
      /* Output:
      (6, 5, 4, 8, 7, 3, 2, 1)
      (6, 5, 7, 1, 2, 3, 4, 8)
      */
      
      System.out.println();
      
      // test: 
      // advance B[] over all permutations, then back to the beginning
      Queens.printArray(B);
      for(int i=0; i<24; i++){  // note that 4! = 24
         Queens.nextPermutation(B);
         Queens.printArray(B);
      }
      /* Output:
      (1, 2, 3, 4)
      (1, 2, 4, 3)
      (1, 3, 2, 4)
      (1, 3, 4, 2)
      (1, 4, 2, 3)
      (1, 4, 3, 2)
      (2, 1, 3, 4)
      (2, 1, 4, 3)
      (2, 3, 1, 4)
      (2, 3, 4, 1)
      (2, 4, 1, 3)
      (2, 4, 3, 1)
      (3, 1, 2, 4)
      (3, 1, 4, 2)
      (3, 2, 1, 4)
      (3, 2, 4, 1)
      (3, 4, 1, 2)
      (3, 4, 2, 1)
      (4, 1, 2, 3)
      (4, 1, 3, 2)
      (4, 2, 1, 3)
      (4, 2, 3, 1)
      (4, 3, 1, 2)
      (4, 3, 2, 1)
      (1, 2, 3, 4)
      */
   }
}

/* 
Algorithm for nextPermutation()
Input: an array A[1...n] representing a permutation
Result: A[1...n] is altered to represent the next permutation in alphabetic order

1.  scan the array from right-to-left
2.     if the current element is less than its right-hand neighbor
3.        call the current element the pivot
4.        stop scanning
5.  if the left end is reached without finding a pivot
6.     reverse the array (current permutation alphabetically last so start over)
7.     return
8.  scan the array from right-to-left
9.     if the current element is larger than the pivot
10.       call the current element the successor
11.       stop scanning
12. swap the pivot and the successor
13. reverse the portion of the array to the right of where the pivot was found
14. return
*/
