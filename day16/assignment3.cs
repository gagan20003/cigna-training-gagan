namespace Assignmemts
{

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
        
        static void CalculateArea(double radius)
        {
            double area = Math.PI * radius * radius;
            Console.WriteLine("Area of the circle is " + MATH.Round(area, 2);
            Logger.LogInfo("INFO", "area of the circle calculated");
        }
        static void CalculateArea(double length, double breadth)
        {
            double area = length * breadth;
            Console.WriteLine("Area of the rectangle is " +  MATH.Round(area, 2));
        }
        static void CalculateArea(int side)
        {
            int area =  side*side;
            Console.WriteLine("Area of the square is " + area);
        }

        static void Main(string[] args)
        {
            Console.WriteLine("----------------------------------------------");
            Console.WriteLine("Enter Your Choice to calculate: ");

            bool loopFlow = true;


            while (loopFlow)
            {
                Console.WriteLine("1. area of circle");
                Console.WriteLine("2. area of square");
                Console.WriteLine("3. area of rectangle");
                Console.WriteLine("4. Exit");
                int choice = Convert.ToInt32(Console.ReadLine());

                switch (choice)
                {
                    case 1:
                        Console.Write("Enter radius of circle: ");
                        float radius = float.Parse(Console.ReadLine());
                        CalculateArea(radius);
                        break;
                    case 2:
                        Console.Write("Enter side of square: ");
                        int side = int.Parse(Console.ReadLine());
                        CalculateArea(side);
                        break;
                    case 3:
                        Console.Write("Enter length of rectangle: ");
                        float length = float.Parse(Console.ReadLine());
                        Console.WriteLine();
                        Console.Write("Enter breadth of rectangle: ");
                        float breadth = float.Parse(Console.ReadLine());
                        CalculateArea(length, breadth);
                        break;
                    default:
                        loopFlow = false;
                        break;
                }
            }
        }
    }
}
