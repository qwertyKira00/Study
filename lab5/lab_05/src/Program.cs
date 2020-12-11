using System;
using System.IO;
using System.Threading;
using System.Collections.Generic;

//Указатель на динамический массив
using intPtr = System.Collections.Generic.List<int>;

namespace src
{
	class Program
	{
		static object firstStage = new object();
		static object secondStage = new object();
		static object thirdStage = new object();

		public const double operationsCount = 5000;

		public static intPtr CreateRandomArray(int n)
		{
			intPtr array = new intPtr();
			var rand = new Random();

			for (int i = 0; i < n; i++)
				array.Add(rand.Next(0, 500));

			return array;
		}

		//Очередь массивов
		public static Queue<intPtr> CreateQueue(int lenQueue, int countElem)
		{
			Queue<intPtr> queue = new Queue<intPtr>();

			for (int i = 0; i < lenQueue; i++)
				queue.Enqueue(CreateRandomArray(countElem));

			return queue;
		}

		public static int FindMax(intPtr array)
		{
			int max = array[0];

			for (int i = 0; i < operationsCount; i++)
				foreach (var elem in array)
					if (elem > max)
						max = elem;

			return max;
		}

		public static int FindMin(intPtr array)
		{
			int min = array[0];

			for (int i = 0; i < operationsCount; i++)
				foreach (var elem in array)
					if (elem < min)
						min = elem;

			return min;
		}

		// Количество элементов
		public static int FindCount(intPtr array, int num)
		{
			int count = 0;

			for (int i = 0; i < operationsCount; i++)
				foreach (var elem in array)
					if (elem < num)
						count++;

			return count;
		}

		public static void PrintArray(intPtr array)
		{
			foreach (var elem in array)
				Console.Write("{0} ", elem);
			Console.WriteLine();
		}

		public static void PrintQueue(Queue<intPtr> queue)
		{
			if (queue.Count == 0)
			{
				Console.WriteLine("Queue is empty.\n");
				return;
			}

			foreach (var elem in queue)
				PrintArray(elem);
			Console.WriteLine();
		}


		static void Main(string[] args)
		{
			//Количество массивов
			Console.WriteLine("Input array count: ");
			int count = Convert.ToInt32(Console.ReadLine());

			//Количество элементов массива
			Console.WriteLine("Input array length: ");
			int n = Convert.ToInt32(Console.ReadLine());

			Queue<intPtr> queue = CreateQueue(count, n);

			MainTread(queue);
		}

		public static void Conveyor(object obj)
		{
			// Получили очереди.
			//arg - критическая зона для трех потоков
			//Нельзя, чтобы два потока одноверемнно обращались к одной очереди
			ThreadArgs args = (ThreadArgs)obj;
			int max, min, count;
			intPtr array;

			lock (args.firstQueue)
			{
				// Из первой очереди получили элемент.
				array = args.firstQueue.Dequeue();
			}

			lock (firstStage)
			{
				// Замеряем время начала работы на первой ленте.
				Console.WriteLine("Лента 1 start {0}    {1}", Thread.CurrentThread.Name, DateTime.Now.Ticks);
				// args.t1.Add(DateTime.Now.Ticks);

				// Работает первая лента.
				max = FindMax(array);

				// Замеряем время конца работы на первой ленте.
				Console.WriteLine("Лента 1 end  {0}    {1}", Thread.CurrentThread.Name, DateTime.Now.Ticks);
				// args.t2.Add(DateTime.Now.Ticks);
			}


			lock (args.secondQueue)
			{
				// Добавили во вторую очередь элемент.
				args.secondQueue.Enqueue(array);
			}

			// Console.WriteLine("Тут должна быть очередь.{0}\n", args.secondQueue.Count);

			lock (secondStage)
			{
				Console.WriteLine("Лента 2 start {0}    {1}", Thread.CurrentThread.Name, DateTime.Now.Ticks);
				// args.t3.Add(DateTime.Now.Ticks);

				// Работает вторая лента.
				lock (args.secondQueue)
				{
					// Получили из второй очереди элемент.
					array = args.secondQueue.Dequeue();
				}

				min = FindMin(array);

				Console.WriteLine("Лента 2 end  {0}    {1}", Thread.CurrentThread.Name, DateTime.Now.Ticks);
				// args.t4.Add(DateTime.Now.Ticks);
			}

			lock (args.thirdQueue)
			{
				// Добавили элемент в третью очередь.
				args.thirdQueue.Enqueue(array);
			}

			lock (thirdStage)
			{
				Console.WriteLine("Лента 3 start {0}    {1}", Thread.CurrentThread.Name, DateTime.Now.Ticks);
				// args.t5.Add(DateTime.Now.Ticks);

				// Работает третья лента.
				lock (args.thirdQueue)
				{
					// Получили из третьей очереди элемент.
					array = args.thirdQueue.Dequeue();
				}

				count = FindCount(array, (max - min) / 2);

				Console.WriteLine("Лента 3 end  {0}    {1}", Thread.CurrentThread.Name, DateTime.Now.Ticks);
				// args.t6.Add(DateTime.Now.Ticks);
			}
		}

		public static void log(ThreadArgs args) // Запись в файл.
		{
			StreamWriter writer = new StreamWriter("times.txt");
			// writer.WriteLine("TIMES:\n");
			// writer.WriteLine("TIMES:\n");

			for (int i = 0; i < args.t1.Count; i++)
			{
				writer.WriteLine("Time 1 (elem index: {0} ): {1}", i + 1, args.t1[i]);
				writer.WriteLine("Time 2 (elem index: {0} ): {1}", i + 1, args.t2[i]);
				writer.WriteLine("Time 3 (elem index: {0} ): {1}", i + 1, args.t3[i]);
				writer.WriteLine("Time 4 (elem index: {0} ): {1}", i + 1, args.t4[i]);
				writer.WriteLine("Time 5 (elem index: {0} ): {1}", i + 1, args.t5[i]);
				writer.WriteLine("Time 6 (elem index: {0} ): {1}", i + 1, args.t6[i]);
			}

			writer.Close();
		}

		public static void MainTread(Queue<intPtr> queue)
		{
			Int64 t1, t2;

			// t1 = DateTime.Now.Ticks;
			// int max, min, count;

			// foreach (var elem in queue)
			// {
			// 	max = FindMax(elem);
			// 	min = FindMin(elem);
			// 	count = FindCount(elem, (max - min) / 2);
			// }

			// t2 = DateTime.Now.Ticks;

			// Console.WriteLine("Простая реализация: {0}\n", t2 - t1);


			// Console.WriteLine("\nBegin:\n");
			// PrintQueue(queue);
			Console.WriteLine("Process:\n");

			t1 = DateTime.Now.Ticks;

			ThreadArgs args = new ThreadArgs(queue);

			//3 потока, которые будут обрабатывать ленту конвейера 
			Thread firstThread = new Thread(new ParameterizedThreadStart(Conveyor));
			firstThread.Name = "Thread 1";

			Thread secondThread = new Thread(new ParameterizedThreadStart(Conveyor));
			secondThread.Name = "Thread 2";

			Thread thirdThread = new Thread(new ParameterizedThreadStart(Conveyor));
			thirdThread.Name = "Thread 3";

			firstThread.Start(args);
			secondThread.Start(args);
			thirdThread.Start(args);


			while (args.firstQueue.Count != 0) // && args.secondQueue.Count != 0 && args.thirdQueue.Count != 0)
			{
				if (!firstThread.IsAlive)
				{
					firstThread = new Thread(new ParameterizedThreadStart(Conveyor));
					firstThread.Name = "Thread 1";
					firstThread.Start(args);
				}

				if (!secondThread.IsAlive)
				{
					secondThread = new Thread(new ParameterizedThreadStart(Conveyor));
					secondThread.Name = "Thread 2";
					secondThread.Start(args);
				}

				if (!thirdThread.IsAlive)
				{
					thirdThread = new Thread(new ParameterizedThreadStart(Conveyor));
					thirdThread.Name = "Thread 3";
					thirdThread.Start(args);
				}
			}

			// Console.WriteLine("STATUS: 1: {0}, 2: {1}, 3: {2}\n", firstThread.IsAlive, secondThread.IsAlive, thirdThread.IsAlive);
			firstThread.Join(); secondThread.Join(); thirdThread.Join();
			// Console.WriteLine("STATUS (после): 1: {0}, 2: {1}, 3: {2}\n", firstThread.IsAlive, secondThread.IsAlive, thirdThread.IsAlive);
			// log(args);

			t2 = DateTime.Now.Ticks;

			Console.WriteLine("Конвейер: {0}\n", t2 - t1);
		}
	}

	//Вспомогательный класс
	public class ThreadArgs
	{
		public Queue<intPtr> firstQueue = null;
		public Queue<intPtr> secondQueue = new Queue<intPtr>();
		public Queue<intPtr> thirdQueue = new Queue<intPtr>();

		public List<Int64> t1, t2, t3, t4, t5, t6;

		// Int64 t2 = DateTime.Now.Ticks;
		// Console.WriteLine("T1: {0}\nT2: {1}\nT2-T1: {2}", t1, t2, t2 - t1);

		public ThreadArgs(Queue<intPtr> queue)
		{
			firstQueue = queue;

			t1 = new List<Int64>();
			t2 = new List<Int64>();
			t3 = new List<Int64>();
			t4 = new List<Int64>();
			t5 = new List<Int64>();
			t6 = new List<Int64>();
		}
	}
}

// len = [5, 10, 25, 50, 100, 250, 500, 1000]
// simple = [270590, 314050, 514440, 728090, 1009860, 1977800, 4029610, 17623210]
// conveyor = [420310, 472230, 485870, 593570, 630730, 1160250, 2182050, 4552170]