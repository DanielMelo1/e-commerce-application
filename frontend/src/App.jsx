import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import { ShoppingCart } from 'lucide-react';
import { CartProvider } from "./contexts/CartContext";
import Home from './pages/Home';
import Products from './pages/Products';
import Cart from './pages/Cart';

function App() {
  return (
    <Router>
      <CartProvider>
        <div>
          <header className="bg-blue-600 text-white p-4">
            <div className="container mx-auto flex justify-between items-center">
              <Link to="/" className="text-2xl font-bold">Loja Online</Link>
              <nav className="space-x-4">
                <Link to="/" className="hover:underline">Início</Link>
                <Link to="/products" className="hover:underline">Produtos</Link>
                <Link to="/cart" className="flex items-center">
                  <ShoppingCart className="mr-2" />
                  Carrinho
                </Link>
              </nav>
            </div>
          </header>

          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/products" element={<Products />} />
            <Route path="/cart" element={<Cart />} />
          </Routes>
        </div>
      </CartProvider>
    </Router>
  );
}

export default App;