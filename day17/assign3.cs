using System;

namespace Assignmemts
{

    class Employee
    {
        float _basic;
    
        public int Id { get; set; }
        public string Name { get; set; }
        public string Job { get; set; }

        public float Basic 
        {
            get { return _basic; }
            set
            {
                if(value < 0)
                {

                    throw new Exception(nameof(value));
                }
                else
                {
                    _basic = value;
                }
            }

        }
        
         float HRA
        {
            get { return Basic * 0.15f ; }
        }
        float DA
        {
            get { return Basic * 0.08f ; }
        }
         float IT
        {
            get { return Basic * 0.10f ; }
        }
        float PF
        {
            get { return Basic * 0.05f ; }
        }

        public double GrossSalary()
        {
            float Salary = Basic + HRA + DA - IT - PF;
            return Math.Round(Salary, 2);
        }
        public void PrintDetails() {
            Console.WriteLine("Details of the Employee are as folows:");
            Console.WriteLine($"Id : {Id}");
            Console.WriteLine($"Name : {Name}");
            Console.WriteLine($"Job : {Job}");
            Console.WriteLine($"Gross Salary : {GrossSalary()}");
        }

    }



    internal class Program
    {
        static void Main(string[] args)
        {
            Employee emp = new Employee();

            Console.Write("Enter employee id: ");
            emp.Id = Convert.ToInt32(Console.ReadLine());
            Console.WriteLine();
            Console.Write("Enter name: ");
            emp.Name = Console.ReadLine();
            Console.WriteLine();
            Console.Write("Enter Basic salary: ");
            emp.Basic = float.Parse(Console.ReadLine());
            Console.WriteLine();
            Console.Write("Enter Job: ");
            emp.Job = (Console.ReadLine());

            Console.WriteLine("-------------------------------------------");

            emp.PrintDetails();

            Console.ReadLine();
        }
    }
}
