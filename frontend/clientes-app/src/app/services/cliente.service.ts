import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

export interface Cliente {
  id: number;
  nombre: string;
  correo: string;
  telefono: string;
  direccion: string;
}

@Injectable({
  providedIn: 'root'
})
export class ClienteService {

  private apiUrl = '/api/Cliente'
  constructor(private http: HttpClient) { }

  listarClientes(): Observable<Cliente[]> {
    return this.http.get<Cliente[]>(`${this.apiUrl}/listar`);
  }

  listarClientesNoActivos(): Observable<Cliente[]> {
    return this.http.get<Cliente[]>(`${this.apiUrl}/listarNoActivos`);
  }

  insertarCliente(cliente: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/insertar`, cliente);
  }

  actualizarCliente(cliente: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/actualizar`, cliente);
  }

  eliminarCliente(cliente: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/eliminar`, cliente);
  }
}
