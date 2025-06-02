import { Component, OnInit } from '@angular/core';
import { AuthService } from '../auth.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  username = '';
  password = '';
  error = '';

  constructor(private authService: AuthService, private router: Router) { }

  login() {
    const ok = this.authService.login(this.username, this.password);
    if (ok) {
      this.router.navigate(['/clientes']);
    } else {
      this.error = 'Usuario o contraseña incorrectos';
    }
  }

  ngOnInit(): void {
  }

}
