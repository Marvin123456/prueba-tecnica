import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private isLoggedIn = false;
  constructor() { }

  login(username: string, password: string): boolean {
    if (username === 'admin' && password === 'admin') {
      this.isLoggedIn = true;
      localStorage.setItem('usuario', username);
      return true;
    }
    return false;
  }

  logout(): void {
    this.isLoggedIn = false;
    localStorage.removeItem('usuario');
  }

  isAuthenticated(): boolean {
    return this.isLoggedIn || !!localStorage.getItem('usuario');
  }
}
