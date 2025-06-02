namespace ClientesAPI.Models
{
    public class ClienteDTO
    {
        public int id { get; set; }
        public string nombre { get; set; }
        public string correo { get; set; }
        public string telefono { get; set; }
        public string direccion { get; set; }
        public int creadoPor { get; set; }
        public DateTime fechaCreacion { get; set; }
        public int estado { get; set; }
        public string creado_por_nombre { get; set; }

    }
}
