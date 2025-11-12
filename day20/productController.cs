using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ProductsApplication.Models;

namespace ProductsApplication.Controllers
{
    [Route("api/[controller]")]
    [ApiController]

   

    public class ProductsController : ControllerBase
    {
        public static List<ProductsClass> productList { get; set; }

        static ProductsController()
        {

            productList = new List<ProductsClass>()
            {
                new ProductsClass() { Id = 1, Name = "Laptop", Quantity = 2, Price = 75000},
                new ProductsClass() { Id = 2, Name = "Phone", Quantity = 2, Price = 35000},
                new ProductsClass() { Id = 3, Name = "Charger", Quantity = 2, Price = 500},
            };
        }


        [HttpGet]

        public ActionResult<List<ProductsClass>> GetAllProducts()
        {
            return Ok(productList);
        }

        [HttpGet("{id}")]

        public ActionResult<ProductsClass> GetProductById(int id)
        {
            ProductsClass obj = productList.FirstOrDefault(product => product.Id == id);

            if(obj == null)
            {
                return NotFound(new {status = "failed", message = "The provided id does not exist."});
            }
            else
            {
                return Ok(obj);
            }
        }

        [HttpPost]

        public ActionResult Create(ProductsClass prodObj)
        {
            productList.Add(prodObj);
            return Ok(new { status = "success", message = "The new item has been added to database" });
        }

        [HttpDelete("{id}")]
        public ActionResult DeleteProductById(int id)
        {
            ProductsClass obj = productList.FirstOrDefault(product => product.Id == id);

            if (obj == null)
            {
                return NotFound(new { status = "failed", message = "The provided id does not exist." });
            }
            else
            {
               productList.Remove(obj);
                return Ok(new { status = "success", message = "Requested item deleted successfully" });
            }
        }
        [HttpPut("{id}")]
        public ActionResult updateProductById(int id, ProductsClass prodObj)
        {
            int index = productList.FindIndex(product => product.Id == id);

            if (index == -1)
            {
                return NotFound(new { status = "failed", message = "The provided id does not exist." });
            }
            else
            {
                productList[index] = prodObj;
                return Ok(new { status = "success", message = "Requested item updated successfully" });
            }
        }
    }
}
