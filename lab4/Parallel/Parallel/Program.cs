using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;


namespace Parallel
{
    class Multiplication
    {
        static Random rand = new Random();

        public static void SMain(string[] args)
        {
            //First matrix
            Console.WriteLine("Enter the rows number for mtr1: ");
            int n1 = Convert.ToInt32(Console.ReadLine());

            Console.WriteLine("Enter the columns number for mtr1: ");
            int m1 = Convert.ToInt32(Console.ReadLine());

            int[][] mtr1 = RandomMatrix(n1, m1);

            //PrintMatrix(mtr1);

            //Second matrix
            Console.WriteLine("Enter the rows number for mtr2: ");
            int n2 = Convert.ToInt32(Console.ReadLine());

            Console.WriteLine("Enter the columns number for mtr2: ");
            int m2 = Convert.ToInt32(Console.ReadLine());

            int[][] mtr2 = RandomMatrix(n2, m2);

            //PrintMatrix(mtr2); 
 
            if (m1 != n2)
                return;

            int[][] res_mtr = new int[n1][];
            for (int i = 0; i < n1; i++)
                res_mtr[i] = new int[m2];

            Stopwatch stopWatch = new Stopwatch();
            stopWatch.Start();

            for (int i = 0; i < 10; i++)
            {
                res_mtr = StandMultCol(mtr1, mtr2, res_mtr, n1, m1, n2, m2);
            }
            

            stopWatch.Stop();
            TimeSpan ts = stopWatch.Elapsed;
            Console.WriteLine(ts.Seconds + "." + ts.Milliseconds);

            string elapsedTime = String.Format("{0:00}:{1:00}:{2:00}.{3:00}",
            ts.Hours, ts.Minutes, ts.Seconds,
            ts.Milliseconds / 10);
            Console.WriteLine("RunTime " + elapsedTime);
            //PrintMatrix(res_mtr);
        }

        public static int[][] StandMultRow(int[][] mtr1, int[][] mtr2, int[][] res_mtr, int n1, int m1, int n2, int m2)
        {
            for (int i = 0; i < n1; i++)
            {
                for (int j = 0; j < m2; j++)
                {
                    for (int q = 0; q < m1; q++)
                    {
                        res_mtr[i][j] = res_mtr[i][j] + mtr1[i][q] * mtr2[q][j];
                    }
                }
            }

            return res_mtr;
        }

        public static int[][] StandMultCol(int[][] mtr1, int[][] mtr2, int[][] res_mtr, int n1, int m1, int n2, int m2)
        {
            for (int i = 0; i < m2; i++)
            {
                for (int j = 0; j < n1; j++)
                {
                    for (int q = 0; q < m1; q++)
                    {
                        res_mtr[j][i] = res_mtr[j][i] + mtr1[j][q] * mtr2[q][i];
                    }
                }
            }

            return res_mtr;
        }

        public static void PrintMatrix(int[][] mtr)
        {
            if (mtr == null)
                return;

            int n = mtr.Length;
            int m = mtr[0].Length;

            Console.WriteLine("Matrix:");
            for (int i = 0; i < n; i++)
            {
                for (int j = 0; j < m; j++)
                {
                    Console.Write("{0} ", mtr[i][j]);
                }
                Console.WriteLine();
            }
        }

        public static int[][] RandomMatrix(int n, int m)
        {
            int[][] mtr = new int[n][];
            for (int i = 0; i < n; i++)
                mtr[i] = new int[m];

            for (int i = 0; i < n; i++)
            {
                for (int j = 0; j < m; j++)
                {
                    mtr[i][j] = rand.Next(1, 10);
                }
            }
            return mtr;
        }

        public static int[][] InitMatrix(int n, int m)
        {
            int[][] mtr = new int[n][];
            for (int i = 0; i < n; i++)
                mtr[i] = new int[m];

            for (int i = 0; i < n; i++)
            {
                for (int j = 0; j < m; j++)
                {
                    mtr[i][j] = Convert.ToInt32(Console.ReadLine());
                }
            }
            return mtr;
        }

    }
}