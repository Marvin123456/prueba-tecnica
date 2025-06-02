import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { LoginComponent } from './auth/login/login.component';
import { ClientesComponent } from './pages/clientes/clientes.component';
import { ClientesNoActivosComponent } from './pages/clientesNoActivos/clientesNoActivos.component';


const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  { path: 'clientes', component: ClientesComponent },
  { path: 'clientesNoActivos', component: ClientesNoActivosComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
