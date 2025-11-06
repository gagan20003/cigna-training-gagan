using System;

namespace Assignmemts
{

    class Products
    {
        float _price;
        int _quantity;
        public int ProductId { get; set; }
        public string ProductName { get; set; }

        public float Price 
        {
            get { return _price; }
            set
            {
                if(value < 0)
                {
                    _price = 0;
                    Console.WriteLine("Price Should not be negative");
                }
                else
                {
                    _price = value;
                }
            }

        }
        public int Quantity 
        {
            get { return _quantity; }
            set
            {
                if(value < 0)
                {
                    _quantity = 0;
                    Console.WriteLine("Quantity Should not be negative");
                }
                else
                {
                    _quantity = value;
                }
            }

        }

    }



    internal class Program
    {
        static void Main(string[] args)
        {
            Products productObj = new Products();

            Console.Write("Enter product id: ");
            productObj.ProductId = Convert.ToInt32(Console.ReadLine());
            Console.WriteLine();
            Console.Write("Enter product name: ");
            productObj.ProductName = Console.ReadLine();
            Console.WriteLine();
            Console.Write("Enter product price: ");
            productObj.Price = float.Parse(Console.ReadLine());
            Console.WriteLine();
            Console.Write("Enter product Quantity: ");
            productObj.Quantity = Convert.ToInt32(Console.ReadLine());

            Console.WriteLine("-------------------------------------------");

            Console.WriteLine($"Details :: ProductId: {productObj.ProductId}, ProductName: {productObj.ProductName}, Price: {productObj.Price}, Quantity: {productObj.Quantity}.");
           

            Console.ReadLine();
        }
    }
}
