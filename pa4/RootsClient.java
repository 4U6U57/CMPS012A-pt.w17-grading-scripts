

class RootsClient {
   public static void main (String args[]) {
      double C[] = {1, -2, 1};
      double D[] = {-2, 2};

      System.out.print("poly() test: ");
      if (Roots.poly(C, 1) == 0) {
         System.out.println("Passed");
      } else {
         System.out.println("Failed");
      }
      System.out.print("diff() test: ");
      double DIFF[] = Roots.diff(C);
      if (DIFF.length == D.length && DIFF[0] == D[0] && DIFF[1] == D[1]) {
         System.out.println("Passed");
      } else {
         System.out.println("Failed");
      }
      System.out.print("findRoot() test: ");
      double root = Roots.findRoot(C, 0, 2, Math.pow(10, -7));
      if (Math.abs(root - 1) < Math.pow(10, -3)) { // I subtract the expected root and see if the answer is close enough to zero
         System.out.println("Passed");
      } else {
         System.out.println("Failed");
      }
   }
}
