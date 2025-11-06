using System;
using static System.Formats.Asn1.AsnWriter;

namespace Assignmemts
{
    class Customer
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string City { get; set; }

        public Customer() {
            Id = 0;
            Name = "";
            City = "";
        }
        public Customer(int id) {
            Id = id;
        }
        public Customer(int id, string name) {
            Id = id;
            Name = name;
        }
        public Customer(int id, string name, string city) {
            Id = id;
            Name = name;
            City = city;
        }

        public void ShowDetails()
        {
            Console.WriteLine($"Customer Details:: Id: {Id}, Name: {Name}, City: {City}");
        }

    }




    internal class Program
    {
        static void Main(string[] args)
        {
            Customer c1 = new Customer();
            Customer c2 = new Customer(10256);
            Customer c3 = new Customer(10256, "Scott");
            Customer c4 = new Customer(10256, "Scott", "HYD");

            c1.ShowDetails();
            c2.ShowDetails();
            c3.ShowDetails();
            c4.ShowDetails();

            Console.ReadLine();
        }
    }
}
