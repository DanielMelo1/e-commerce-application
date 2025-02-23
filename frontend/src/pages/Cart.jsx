import React from 'react';
import { useCart } from "../contexts/CartContext"; 

function Cart() {
  const { cartItems, removeFromCart, updateQuantity, cartTotal } = useCart();

  return (
    <div className="container mx-auto p-4">
      <h1 className="text-2xl font-bold mb-4">Seu Carrinho</h1>
      
      {cartItems.length === 0 ? (
        <p className="text-center text-gray-600">Seu carrinho está vazio</p>
      ) : (
        <div>
          {cartItems.map(item => (
            <div 
              key={item.id} 
              className="flex items-center justify-between border-b py-4"
            >
              <div>
                <h2 className="text-xl font-semibold">{item.name}</h2>
                <p className="text-gray-600">R$ {Number(item.price).toFixed(2)}</p>
              </div>
              
              <div className="flex items-center space-x-4">
                <button 
                  onClick={() => updateQuantity(item.id, item.quantity - 1)}
                  className="bg-gray-200 px-3 py-1 rounded"
                >
                  -
                </button>
                
                <span>{item.quantity}</span>
                
                <button 
                  onClick={() => updateQuantity(item.id, item.quantity + 1)}
                  className="bg-gray-200 px-3 py-1 rounded"
                >
                  +
                </button>
                
                <button 
                  onClick={() => removeFromCart(item.id)}
                  className="bg-red-500 text-white px-3 py-1 rounded"
                >
                  Remover
                </button>
              </div>
            </div>
          ))}
          
          <div className="mt-6 text-right">
            <p className="text-xl font-bold">
              Total: R$ {cartTotal.toFixed(2)}
            </p>
            <button 
              className="mt-4 bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700"
            >
              Finalizar Compra
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

export default Cart;