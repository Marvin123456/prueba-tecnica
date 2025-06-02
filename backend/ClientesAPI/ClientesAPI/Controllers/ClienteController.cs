using ClientesAPI.Data;
using ClientesAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Data;

namespace ClientesAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ClienteController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public ClienteController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet("listar")]
        public IActionResult ListarClientes()
        {
            try
            {
                string connectionString = _configuration.GetConnectionString("ConexionBase");
                var dataTable = SqlHelper.ExecuteQuery(connectionString, "sp_listar_clientes_activos");

                var listaClientes = new List<ClienteDTO>();

                foreach (DataRow row in dataTable.Rows)
                {
                    var cliente = new ClienteDTO
                    {
                        id = Convert.ToInt32(row["id"]),
                        nombre = row["nombre"].ToString(),
                        correo = row["correo"]?.ToString(),
                        telefono = row["telefono"]?.ToString(),
                        direccion = row["direccion"]?.ToString(),
                        creadoPor = Convert.ToInt32(row["creado_por"]),
                        fechaCreacion = Convert.ToDateTime(row["fecha_creacion"]),
                        estado = Convert.ToByte(row["estado"]),
                        creado_por_nombre = row["creado_por_nombre"].ToString()
                    };

                    listaClientes.Add(cliente);
                }

                return Ok(listaClientes);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error: {ex.Message}");
            }
        }

        [HttpGet("listarNoActivos")]
        public IActionResult ListarClientesNoActivos()
        {
            try
            {
                string connectionString = _configuration.GetConnectionString("ConexionBase");
                var dataTable = SqlHelper.ExecuteQuery(connectionString, "sp_listar_clientes_inactivos");

                var listaClientes = new List<ClienteDTO>();

                foreach (DataRow row in dataTable.Rows)
                {
                    var cliente = new ClienteDTO
                    {
                        id = Convert.ToInt32(row["id"]),
                        nombre = row["nombre"].ToString(),
                        correo = row["correo"]?.ToString(),
                        telefono = row["telefono"]?.ToString(),
                        direccion = row["direccion"]?.ToString(),
                        creadoPor = Convert.ToInt32(row["creado_por"]),
                        fechaCreacion = Convert.ToDateTime(row["fecha_creacion"]),
                        estado = Convert.ToByte(row["estado"]),
                        creado_por_nombre = row["creado_por_nombre"].ToString()
                    };

                    listaClientes.Add(cliente);
                }

                return Ok(listaClientes);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error: {ex.Message}");
            }
        }

        [HttpPost("insertar")]
        public IActionResult InsertarCliente([FromBody] ClienteInsertarDTO cliente)
        {
            try
            {
                string connectionString = _configuration.GetConnectionString("ConexionBase");

                var parametros = new List<SqlParameter>
        {
            new SqlParameter("@nombre", cliente.nombre),
            new SqlParameter("@correo", cliente.correo ?? (object)DBNull.Value),
            new SqlParameter("@telefono", cliente.telefono ?? (object)DBNull.Value),
            new SqlParameter("@direccion", cliente.direccion ?? (object)DBNull.Value),
            new SqlParameter("@creado_por", cliente.creadoPor),
            new SqlParameter
            {
                ParameterName = "@nuevo_id",
                SqlDbType = SqlDbType.Int,
                Direction = ParameterDirection.Output
            }
        };

                SqlHelper.ExecuteNonQuery(connectionString, "sp_insertar_cliente", parametros);

                int nuevoId = (int)parametros.First(p => p.ParameterName == "@nuevo_id").Value;

                return Ok(new { mensaje = "Cliente insertado correctamente.", clienteId = nuevoId });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error: {ex.Message}");
            }
        }

        [HttpPut("actualizar")]
        public IActionResult ActualizarCliente([FromBody] ClienteActualizarDTO cliente)
        {
            try
            {
                string connectionString = _configuration.GetConnectionString("ConexionBase");

                var parametros = new List<SqlParameter>
                {
                    new SqlParameter("@id", cliente.id),
                    new SqlParameter("@nombre", cliente.nombre),
                    new SqlParameter("@correo", cliente.correo ?? (object)DBNull.Value),
                    new SqlParameter("@telefono", cliente.telefono ?? (object)DBNull.Value),
                    new SqlParameter("@direccion", cliente.direccion ?? (object)DBNull.Value),
                    new SqlParameter("@modificado_por", cliente.modificadoPor)
                };

                SqlHelper.ExecuteNonQuery(connectionString, "sp_actualizar_cliente", parametros);

                return Ok(new { mensaje = "Cliente actualizado correctamente." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error: {ex.Message}");
            }
        }

        [HttpPut("eliminar")]
        public IActionResult EliminarCliente([FromBody] ClienteEliminarDTO cliente)
        {
            try
            {
                string connectionString = _configuration.GetConnectionString("ConexionBase");

                var parametros = new List<SqlParameter>
                {
                    new SqlParameter("@id", cliente.id),
                    new SqlParameter("@usuario_id", cliente.usuarioId)
                };

                SqlHelper.ExecuteNonQuery(connectionString, "sp_eliminar_cliente", parametros);

                return Ok(new { mensaje = "Cliente eliminado correctamente (deshabilitado)." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error: {ex.Message}");
            }
        }
    }
}
