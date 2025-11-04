namespace Assignmemts
{
    internal class Program
    {

        static void SendEmail(string senderEmail, string recipientEmail, string subject = "No Subject Body", string message = "Empty Message Body", bool isImportant = false) {

            string mailMessage = "";

       

            if (isImportant)
            {
                mailMessage += "!!!!!!!!!!!!!IMPORTANT MAIL!!!!!!!!!!!!! \n";
            }
            mailMessage += message;

            Console.WriteLine("---------------------------------------------------");
            Console.WriteLine("Mail From: " + senderEmail);
            Console.WriteLine("---------------------------------------------------");
            Console.WriteLine("Mail To: " + recipientEmail);
            Console.WriteLine("---------------------------------------------------");
            Console.WriteLine("Subject: " + subject);
            Console.WriteLine("---------------------------------------------------");
            Console.WriteLine();
            Console.WriteLine(mailMessage);

        }
        static void Main(string[] args)
        {
            SendEmail("abc@mail.com", "def@mail.com", "Test mail subject", "Test mail body", true);
            Console.WriteLine();
            Console.WriteLine();
            SendEmail("abc@mail.com", "def@mail.com", isImportant: true);
            Console.WriteLine();
            Console.WriteLine();
            SendEmail("abc@mail.com", "def@mail.com");
        }
    }
}
