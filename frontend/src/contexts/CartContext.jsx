import React, { createContext, useState, useContext } from 'react';

// Criando o contexto do carrinho
const CartContext = createContext();

// Provedor do contexto do carrinho
export function CartProvider({ children }) {
  const [cartItems, setCartItems] = useState([]);

  // Função para adicionar item ao carrinho (já implementada)
  const addToCart = (product) => {
    setCartItems(prevItems => {
      const existingItem = prevItems.find(item => item.id === product.id);
      
      if (existingItem) {
        return prevItems.map(item =>
          item.id === product.id
            ? { ...item, quantity: item.quantity + 1 }
            : item
        );
      }
      
      return [...prevItems, { ...product, quantity: 1 }];
    });
  };

  // Função para remover item do carrinho (já implementada)
  const removeFromCart = (productId) => {
    setCartItems(prevItems => prevItems.filter(item => item.id !== productId));
  };

  // Função para atualizar quantidade de um item
  const updateQuantity = (productId, quantity) => {
    setCartItems(prevItems =>
      prevItems.map(item =>
        item.id === productId
          ? { ...item, quantity: Math.max(0, quantity) }
          : item
      ).filter(item => item.quantity > 0)
    );
  };

  // Calcular total do carrinho
  const cartTotal = cartItems.reduce((total, item) => 
    total + (Number(item.price) * item.quantity), 0);

  return (
    <CartContext.Provider value={{
      cartItems,
      addToCart,
      removeFromCart,
      updateQuantity,
      cartTotal
    }}>
      {children}
    </CartContext.Provider>
  );
}

// Hook personalizado para usar o contexto do carrinho
export function useCart() {
  const context = useContext(CartContext);
  if (!context) {
    throw new Error('useCart must be used within a CartProvider');
  }
  return context;
}