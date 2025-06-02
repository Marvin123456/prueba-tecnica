import { Component, OnInit } from '@angular/core';
import { Cliente, ClienteService } from 'src/app/services/cliente.service';

@Component({
  selector: 'app-clientes-no-activos',
  templateUrl: './clientesNoActivos.component.html',
  styleUrls: ['./clientesNoActivos.component.css']
})
export class ClientesNoActivosComponent implements OnInit {

  clientes: Cliente[] = [];
  clienteForm: Partial<Cliente> = {};
  modoEdicion = false;
  idEditando: number | null = null;

  constructor(private clienteService: ClienteService) { }

  ngOnInit(): void {
    this.obtenerClientes();
  }

  obtenerClientes() {
    this.clienteService.listarClientesNoActivos().subscribe(data => {
      this.clientes = data;
    });
  }

   guardarCliente() {
    if (this.modoEdicion && this.idEditando !== null) {
      const clienteEditado = { ...this.clienteForm, id: this.idEditando };
      this.clienteService.actualizarCliente(clienteEditado).subscribe(() => {
        this.resetFormulario();
        this.obtenerClientes();
      });
    } else {
      const clienteNuevo = { ...this.clienteForm, creado_por: 1 }; // ID fijo temporal
      this.clienteService.insertarCliente(clienteNuevo).subscribe(() => {
        this.resetFormulario();
        this.obtenerClientes();
      });
    }
  }

  editarCliente(cliente: Cliente) {
    this.modoEdicion = true;
    this.idEditando = cliente.id;
    this.clienteForm = { ...cliente };
  }

  eliminarCliente(id: number) {
  const usuarioId = 1; // ID de usuario que realiza la acción, puedes obtenerlo dinámicamente si ya tienes login
  if (confirm('¿Desea eliminar este cliente?')) {
    const solicitudEliminacion = {
      id: id,
      usuarioId: usuarioId
    };

    this.clienteService.eliminarCliente(solicitudEliminacion).subscribe(() => {
      this.obtenerClientes();
    });
  }
}


  resetFormulario() {
    this.clienteForm = {};
    this.modoEdicion = false;
    this.idEditando = null;
  }

}
