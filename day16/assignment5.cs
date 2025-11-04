using System;

namespace Assignmemts
{

    public class NegativeNumberException : ApplicationException
    {
        public NegativeNumberException(string message) : base(message) { }
    }

    public class Logger
    {

        public static void LogInfo(string level, string message, Exception ex = null)
        {
            WriteLog(level, message, ex); //level : "INFO", "ERROR", "WARNING"
        }


        private static void WriteLog(string level, string message, Exception exception)
        {
            string logEntry = $"{DateTime.Now:yyyy-MM-dd HH:mm:ss} [{level}] - {message}";

            if (exception != null)
            {
                logEntry += Environment.NewLine + exception.ToString();
            }

            Console.WriteLine(logEntry);
        }
    }


    internal class Program
    {
        
        

        static void Main(string[] args)
        {
           List<int> numList = new List<int>();

            Console.Write("Enter number of elements in array: ");
            int n = Convert.ToInt32(Console.ReadLine());

            for(int i = 0; i < n; i++)
            {
                try
                {
                    Console.Write("Enter number to add in the array: ");
                    int num = Convert.ToInt32(Console.ReadLine());
                    if(num < 0)
                    {
                        throw new NegativeNumberException("You should not add negative numbers.");
                    }
                    numList.Add(num);
                }
                catch (FormatException ex)
                {
                    Logger.LogInfo("ERROR", ex.Message, ex);
                }
                catch (Exception ex) {
                    Logger.LogInfo("ERROR", ex.Message, ex);
                }

            }

            foreach (int item in numList) {
                Console.WriteLine(item);
            }
        }
    }
}
