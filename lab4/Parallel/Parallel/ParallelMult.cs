using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using System.Diagnostics;
using System.IO;


namespace Parallel
{
    class ParallelMultiplication
    {
        
        static Random rand = new Random();


        public static void Main(string[] args)
        {
            for (int mtr = 0; mtr < 5; mtr++)
            {
                int[] dim1 = EnterDimension();
                int[] dim2 = EnterDimension();
                int n1 = dim1[0];
                int m1 = dim1[1];
                int n2 = dim2[0];
                int m2 = dim2[1];

                if (m1 != n2)
                    return;
                //Инициализация матриц
                int[][] mtr1 = RandomMatrix(n1, m1);
                int[][] mtr2 = RandomMatrix(n2, m2);

                if (mtr1 == null || mtr2 == null)
                    return;

                //PrintMatrix(mtr1);
                //PrintMatrix(mtr2);

                int[][] res_mtr = new int[n1][];
                for (int i = 0; i < n1; i++)
                    res_mtr[i] = new int[m2];

                //Количество потоков при 4 * M, где M - это количество лгических ядер ЭВМ (8)
                int tc = 32;  

                for (int i = 1; i < tc + 1; i *= 2)
                {

                    Stopwatch stopWatch = new Stopwatch();
                    stopWatch.Start();
                    for (int rep = 0; rep < 10; rep++)
                    {
                        ParallelMultFirst(res_mtr, mtr1, mtr2, n1, m1, n2, m2, i);
                        //ParallelMultSecond(res_mtr, mtr1, mtr2, n1, m1, n2, m2, i);

                    }
                    stopWatch.Stop();
                    TimeSpan ts = stopWatch.Elapsed;
                    Console.WriteLine(ts.Seconds + "." + ts.Milliseconds);

                    string elapsedTime = String.Format("{0:00}:{1:00}:{2:00}.{3:00}",
                    ts.Hours, ts.Minutes, ts.Seconds,
                    ts.Milliseconds);
                    Console.WriteLine("RunTime " + elapsedTime); 
                }
            }
        }

        public static void ParallelMultFirst(int[][] res_mtr, int[][] mtr1, int[][] mtr2, int n1, int m1, int n2, int m2, int tc)
        {
            //Первая реализация (строки)

            List<Thread> listThread = new List<Thread>();
            int d = n1 / tc;
            int j = 0;
            
            for (int i = 0; i < n1; i += d)
            {
                //Console.WriteLine("Main thread:");
                Param p = new Param(res_mtr, mtr1, mtr2, i, i + d, n1, m1, n2, m2);
                       
                //Создаем новый поток

                listThread.Add(new Thread(new ParameterizedThreadStart(ParallelMultRow)));
                listThread[j].Start(p); // запускаем поток
                j += 1;
             }

            // Join — Это метод синхронизации, который блокирует вызывающий поток (то есть поток, который вызывает метод).
            // Используйте этот метод, чтобы убедиться, что поток был завершен.
            // То есть мы не пойдем далее по коду, пока не выполнятся потоки, вызванные ранее 
            // (то есть те потоки, которые мы джоиним).

            foreach (var elem in listThread)
            {

                if (elem.IsAlive)
                    elem.Join();
            }

            //PrintMatrix(res_mtr);
            //Console.WriteLine();  
        }

        public static void ParallelMultSecond(int[][] res_mtr, int[][] mtr1, int[][] mtr2, int n1, int m1, int n2, int m2, int tc)
        {
            //Вторая реализация(столбцы)
            int d = m2 / tc;
            int j = 0;

            List<Thread> listThread = new List<Thread>();


            for (int i = 0; i < m2; i += d)
            {
                //Параметры
                Param p = new Param(res_mtr, mtr1, mtr2, i, i + d, n1, m1, n2, m2);
                //Создаем новый поток 
                listThread.Add(new Thread(new ParameterizedThreadStart(ParallelMultCol)));
                listThread[j].Start(p); // запускаем поток
                j += 1;
            }
            //Console.WriteLine("Main thread:");

            foreach (var elem in listThread)
            {
                if (elem.IsAlive)
                    elem.Join();
            }

            //PrintMatrix(res_mtr);
            //Console.WriteLine();

        }

        public static void ParallelMultRow(object obj)
        {
            Param p = (Param)obj;
            int s = 0;

            for (int row = p.start; row < p.end; row++)
            {
                for (int i = 0; i < p.m2; i++)
                {

                    //Console.WriteLine("Work thread " + p.current);
                    s = 0;
                    for (int j = 0; j < p.m1; j++)
                    {
                        s += p.mtr1[row][j] * p.mtr2[j][i];
                    }
                    p.res_mtr[row][i] = s;
                }
            }
        }

        public static void ParallelMultCol(object obj)
        {
            Param p = (Param)obj;
            int s = 0;

            for (int col = p.start; col < p.end; col++)
            {
                for (int i = 0; i < p.n1; i++)
                {
                    //Console.WriteLine("Work thread " + p.current);
                    s = 0;
                    for (int j = 0; j < p.m1; j++)
                    {
                        s += p.mtr1[i][j] * p.mtr2[j][col];
                    }
                    p.res_mtr[i][col] = s;
                }
            }
        }

        public static int[] EnterDimension()
        {
            Console.WriteLine("Enter the rows number: ");
            int n = Convert.ToInt32(Console.ReadLine());

            Console.WriteLine("Enter the columns number: ");
            int m = Convert.ToInt32(Console.ReadLine());

            int[] dim = new int[2];
            dim[0] = n;
            dim[1] = m;

            return dim;
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

            Console.WriteLine("Enter the matrix: ");
            for (int i = 0; i < n; i++)
            {
                for (int j = 0; j < m; j++)
                {
                    mtr[i][j] = Convert.ToInt32(Console.ReadLine());
                }
            }
            return mtr;
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
    }
    class Param
    {
        public int[][] res_mtr, mtr1, mtr2;
        public int n1, m1, n2, m2;
        public int start, end;

        public Param(int[][] res_mtr, int[][] mtr1, int[][] mtr2, int start, int end, int n1, int m1, int n2, int m2)
        {
            this.res_mtr = res_mtr;
            this.mtr1 = mtr1;
            this.mtr2 = mtr2;
            this.n1 = n1;
            this.m1 = m1;
            this.n2 = n2;
            this.m2 = m2;
            this.start = start;
            this.end = end;
        }
    }
    //public class Matrix
    //{
    //    static Random rand = new Random();

    //    private int[,] mtr = null;

    //    public int n { get; private set; }
    //    public int m { get; private set; }

    //    public Matrix(int x = 1, int y = 1)
    //    {
    //        mtr = new int[x, y];

    //        n = x;
    //        m = y;
    //    }


    //    //Теперь к экземпляру класса Matrix можно обращаться как к двумерному массиву.
    //    public int this[int x, int y]
    //    {
    //        get { return mtr[x, y]; }
    //        set { mtr[x, y] = value; }
    //    }

    //    public void InitMatrix()
    //    {
    //        Console.WriteLine("Enter the matrix: ");
    //        for (int i = 0; i < n; i++)
    //        {
    //            for (int j = 0; j < m; j++)
    //            {
    //                mtr[i, j] = Convert.ToInt32(Console.ReadLine());
    //            }
    //        }
    //    }

    //    public void RandomMatrix()
    //    {
    //        for (int i = 0; i < n; i++)
    //        {
    //            for (int j = 0; j < m; j++)
    //            {
    //                mtr[i, j] = rand.Next(1, 1000);
    //            }
    //        }
    //    }

    //    public void PrintMatrix()
    //    {
    //        if (mtr == null)
    //            return;

    //        for (int i = 0; i < n; i++)
    //        {
    //            for (int j = 0; j < m; j++)
    //            {
    //                Console.Write("{0} ", mtr[i, j]);
    //            }
    //            Console.WriteLine();
    //        }
    //    }
    //}

    //class Param
    //{
    //    public Matrix res_mtr, mtr1, mtr2;
    //    public int row;

    //    public Param(Matrix res_mtr, Matrix mtr1, Matrix mtr2, int i)
    //    {
    //        this.res_mtr = res_mtr;
    //        this.mtr1 = mtr1;
    //        this.mtr2 = mtr2;
    //        this.row = i; 
    //    }
    //}
}