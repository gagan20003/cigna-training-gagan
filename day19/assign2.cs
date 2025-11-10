using System;

namespace Assignmemts
{


    interface IPayment
    {
        void Pay(double amount);
    }

    class CreditCardPayment : IPayment
    {
        public void Pay(double amount)
        {
            Console.WriteLine($"The payment for $ {amount} is done via Credit card");
        }
    }
    class UPIPayment : IPayment
    {
        public void Pay(double amount)
        {
            Console.WriteLine($"The payment for $ {amount} is done via UPI");
        }
    }
    class PaypalPayment : IPayment
    {
        public void Pay(double amount)
        {
            Console.WriteLine($"The payment for $ {amount} is done via Paypal");
        }
    }


    internal class Program
    {
        static void Main(string[] args)
        {
            IPayment cc = new CreditCardPayment();
            IPayment upi = new UPIPayment();
            IPayment paypal = new PaypalPayment();

            cc.Pay(4321);
            paypal.Pay(321);
            upi.Pay(21);
           
           
        }
    }
}
