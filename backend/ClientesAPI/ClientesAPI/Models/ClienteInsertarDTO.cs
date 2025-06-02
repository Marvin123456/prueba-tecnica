namespace ClientesAPI.Models
{
    public class ClienteInsertarDTO
    {
        public string nombre { get; set; }
        public string correo { get; set; }
        public string telefono { get; set; }
        public string direccion { get; set; }
        public int creadoPor { get; set; }
    }
}
