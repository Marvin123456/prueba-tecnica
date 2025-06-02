namespace ClientesAPI.Models
{
    public class ClienteActualizarDTO
    {
        public int id { get; set; }
        public string nombre { get; set; }
        public string correo { get; set; }
        public string telefono { get; set; }
        public string direccion { get; set; }
        public int modificadoPor { get; set; }
    }
}
