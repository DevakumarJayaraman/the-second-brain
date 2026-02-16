---
title: "React.js: The Complete Guide"
sidebar_position: 1
displayed_sidebar: technologySidebar
tags:
  - react
  - typescript
  - frontend
  - web-development
---

# React.js: The Complete Guide

*A comprehensive journey from zero to hero in React development (with TypeScript)*

---

## 🎯 What is React?

React is a **JavaScript library** for building user interfaces, created by Facebook (now Meta) in 2013. Unlike full-fledged frameworks like Angular, React focuses on one thing and does it exceptionally well: **rendering UI components**.

Think of React like LEGO blocks. Each component is a self-contained brick, and you snap them together to build complex interfaces. Change one brick? The rest stays intact.

### Why React Became So Popular

| Feature | What It Means |
|---------|---------------|
| **Component-Based** | Build encapsulated pieces that manage their own state |
| **Declarative** | Describe *what* you want, not *how* to do it |
| **Virtual DOM** | Efficient updates without touching the real DOM |
| **One-Way Data Flow** | Predictable data management |
| **Rich Ecosystem** | Massive community, tons of libraries |

---

## 🚀 Getting Started

### Setting Up Your First React App

The easiest way to start is with **Vite** (recommended for TypeScript):

```bash
# Using Vite with TypeScript (recommended!)
npm create vite@latest my-app -- --template react-ts
cd my-app
npm install
npm run dev

# Or using Create React App with TypeScript
npx create-react-app my-app --template typescript
cd my-app
npm start
```

Your browser opens to `http://localhost:5173` (Vite) or `http://localhost:3000` (CRA), and you're ready to code!

---

## 🧱 Components: The Building Blocks

Everything in React is a **component**. There are two ways to create them:

### Functional Components (Modern Way ✅)

```tsx
// Simple component
function Welcome(): JSX.Element {
  return <h1>Hello, World!</h1>;
}

// Arrow function style with React.FC
import React from 'react';

const Welcome: React.FC = () => {
  return <h1>Hello, World!</h1>;
};

// Even shorter (implicit return)
const Welcome: React.FC = () => <h1>Hello, World!</h1>;
```

### Class Components (Legacy Way)

```tsx
import React, { Component } from 'react';

class Welcome extends Component {
  render(): JSX.Element {
    return <h1>Hello, World!</h1>;
  }
}
```

> 💡 **Pro Tip**: Use functional components with hooks. Class components are considered legacy since React 16.8.

---

## 📦 Props: Passing Data to Components

**Props** (properties) are how you pass data from parent to child components. They're **read-only** — a component should never modify its own props.

```tsx
// Define props interface
interface UserCardProps {
  name: string;
  role: string;
  avatar: string;
}

// Parent component
function App(): JSX.Element {
  return (
    <div>
      <UserCard name="Alice" role="Developer" avatar="👩‍💻" />
      <UserCard name="Bob" role="Designer" avatar="👨‍🎨" />
    </div>
  );
}

// Child component receiving props
function UserCard({ name, role, avatar }: UserCardProps): JSX.Element {
  return (
    <div className="card">
      <span className="avatar">{avatar}</span>
      <h2>{name}</h2>
      <p>{role}</p>
    </div>
  );
}
```

### Props with Default Values

```tsx
interface ButtonProps {
  text?: string;
  color?: string;
  onClick?: () => void;
}

function Button({ 
  text = "Click Me", 
  color = "blue", 
  onClick 
}: ButtonProps): JSX.Element {
  return (
    <button 
      style={{ backgroundColor: color }}
      onClick={onClick}
    >
      {text}
    </button>
  );
}

// Usage
<Button />                              // Uses defaults
<Button text="Submit" color="green" />  // Custom values
```

### The Special `children` Prop

```tsx
import { ReactNode } from 'react';

interface CardProps {
  title: string;
  children: ReactNode;
}

function Card({ children, title }: CardProps): JSX.Element {
  return (
    <div className="card">
      <h2>{title}</h2>
      <div className="card-body">
        {children}
      </div>
    </div>
  );
}

// Usage - anything between tags becomes children
<Card title="Welcome">
  <p>This is the card content!</p>
  <button>Click me</button>
</Card>
```

---

## 🔄 State: Making Components Dynamic

While props come from outside, **state** is internal data that a component manages itself. When state changes, React re-renders the component.

### The `useState` Hook

```tsx
import { useState } from 'react';

function Counter(): JSX.Element {
  // Declare state: [currentValue, setterFunction] = useState<Type>(initialValue)
  const [count, setCount] = useState<number>(0);

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>+1</button>
      <button onClick={() => setCount(count - 1)}>-1</button>
      <button onClick={() => setCount(0)}>Reset</button>
    </div>
  );
}
```

### State with Objects

```tsx
import { useState, ChangeEvent } from 'react';

interface User {
  name: string;
  email: string;
  age: number;
}

function UserForm(): JSX.Element {
  const [user, setUser] = useState<User>({
    name: '',
    email: '',
    age: 0
  });

  const handleChange = (e: ChangeEvent<HTMLInputElement>): void => {
    const { name, value } = e.target;
    // Always spread existing state, then override specific field
    setUser(prevUser => ({
      ...prevUser,
      [name]: name === 'age' ? Number(value) : value
    }));
  };

  return (
    <form>
      <input 
        name="name" 
        value={user.name} 
        onChange={handleChange}
        placeholder="Name"
      />
      <input 
        name="email" 
        value={user.email} 
        onChange={handleChange}
        placeholder="Email"
      />
      <input 
        name="age" 
        type="number"
        value={user.age} 
        onChange={handleChange}
        placeholder="Age"
      />
    </form>
  );
}
```

### State with Arrays - Todo List

```tsx
import { useState, KeyboardEvent } from 'react';

interface Todo {
  id: number;
  text: string;
  done: boolean;
}

function TodoList(): JSX.Element {
  const [todos, setTodos] = useState<Todo[]>([]);
  const [input, setInput] = useState<string>('');

  const addTodo = (): void => {
    if (input.trim()) {
      setTodos([...todos, { id: Date.now(), text: input, done: false }]);
      setInput('');
    }
  };

  const toggleTodo = (id: number): void => {
    setTodos(todos.map(todo => 
      todo.id === id ? { ...todo, done: !todo.done } : todo
    ));
  };

  const deleteTodo = (id: number): void => {
    setTodos(todos.filter(todo => todo.id !== id));
  };

  const handleKeyPress = (e: KeyboardEvent<HTMLInputElement>): void => {
    if (e.key === 'Enter') addTodo();
  };

  return (
    <div>
      <input 
        value={input} 
        onChange={(e) => setInput(e.target.value)}
        onKeyPress={handleKeyPress}
      />
      <button onClick={addTodo}>Add</button>
      
      <ul>
        {todos.map(todo => (
          <li key={todo.id}>
            <span 
              style={{ textDecoration: todo.done ? 'line-through' : 'none' }}
              onClick={() => toggleTodo(todo.id)}
            >
              {todo.text}
            </span>
            <button onClick={() => deleteTodo(todo.id)}>🗑️</button>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

---

## ⚡ useEffect: Side Effects & Lifecycle

The `useEffect` hook handles **side effects** — things that happen outside React's render cycle like API calls, subscriptions, or DOM manipulation.

### Basic Syntax

```tsx
import { useEffect, useState } from 'react';

function MyComponent(): JSX.Element {
  const [count, setCount] = useState<number>(0);

  useEffect(() => {
    // This runs after every render
    console.log('Component rendered!');
  });

  useEffect(() => {
    // This runs only once (on mount)
    console.log('Component mounted!');
  }, []); // Empty dependency array = run once

  useEffect(() => {
    // This runs when `count` changes
    console.log('Count changed to:', count);
  }, [count]); // Dependency array with values

  return <div>Count: {count}</div>;
}
```

### Fetching Data from an API

```tsx
import { useEffect, useState } from 'react';

interface User {
  id: number;
  name: string;
  email: string;
}

function UserList(): JSX.Element {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchUsers = async (): Promise<void> => {
      try {
        const response = await fetch('https://jsonplaceholder.typicode.com/users');
        if (!response.ok) throw new Error('Failed to fetch');
        const data: User[] = await response.json();
        setUsers(data);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Unknown error');
      } finally {
        setLoading(false);
      }
    };

    fetchUsers();
  }, []); // Empty array = fetch once on mount

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error: {error}</p>;

  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>{user.name} - {user.email}</li>
      ))}
    </ul>
  );
}
```

### Cleanup Function (Like componentWillUnmount)

```tsx
import { useEffect, useState } from 'react';

function Timer(): JSX.Element {
  const [seconds, setSeconds] = useState<number>(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setSeconds(s => s + 1);
    }, 1000);

    // Cleanup function - runs when component unmounts
    return () => {
      clearInterval(interval);
      console.log('Timer cleaned up!');
    };
  }, []);

  return <p>Elapsed: {seconds} seconds</p>;
}
```

---

## 📋 Event Handling

React events are named using camelCase and pass functions, not strings.

```tsx
import { MouseEvent, FormEvent, ChangeEvent, KeyboardEvent, FocusEvent } from 'react';

function EventExamples(): JSX.Element {
  // Click events
  const handleClick = (): void => alert('Clicked!');
  
  const handleClickWithEvent = (e: MouseEvent<HTMLButtonElement>): void => {
    console.log('Button:', e.currentTarget);
  };
  
  const handleClickWithArg = (message: string): void => alert(message);

  // Form events
  const handleSubmit = (e: FormEvent<HTMLFormElement>): void => {
    e.preventDefault(); // Prevent page reload
    console.log('Form submitted!');
  };

  const handleChange = (e: ChangeEvent<HTMLInputElement>): void => {
    console.log('Input value:', e.target.value);
  };

  const handleKeyDown = (e: KeyboardEvent<HTMLInputElement>): void => {
    if (e.key === 'Enter') console.log('Enter pressed!');
  };

  const handleFocus = (e: FocusEvent<HTMLInputElement>): void => {
    console.log('Focused');
  };

  return (
    <div>
      {/* Click handlers */}
      <button onClick={handleClick}>Simple Click</button>
      <button onClick={handleClickWithEvent}>Click with Event</button>
      <button onClick={() => handleClickWithArg('Hello!')}>
        Click with Argument
      </button>

      {/* Form handling */}
      <form onSubmit={handleSubmit}>
        <input onChange={handleChange} onKeyDown={handleKeyDown} />
        <button type="submit">Submit</button>
      </form>

      {/* Other events */}
      <input onFocus={handleFocus} />
      <div onMouseEnter={() => console.log('Mouse entered')} />
    </div>
  );
}
```

---

## 🎨 Conditional Rendering

React gives you multiple ways to render content conditionally.

```tsx
import { ReactNode } from 'react';

interface ConditionalProps {
  isLoggedIn: boolean;
  role: 'admin' | 'user' | 'guest';
  items: { id: number; name: string }[];
  error: string | null;
  user?: { name: string; isVerified: boolean } | null;
}

function ConditionalExamples({ 
  isLoggedIn, 
  role, 
  items, 
  error, 
  user 
}: ConditionalProps): JSX.Element {
  return (
    <div>
      {/* Method 1: Ternary operator */}
      {isLoggedIn ? <Dashboard /> : <LoginForm />}

      {/* Method 2: Logical AND (render if true) */}
      {isLoggedIn && <WelcomeMessage />}

      {/* Method 3: Logical OR (fallback) */}
      {error || 'No errors'}

      {/* Method 4: Multiple conditions */}
      {role === 'admin' && <AdminPanel />}
      {role === 'user' && <UserPanel />}
      {role === 'guest' && <GuestPanel />}

      {/* Method 5: Empty state handling */}
      {items.length === 0 ? (
        <p>No items found</p>
      ) : (
        <ul>
          {items.map(item => <li key={item.id}>{item.name}</li>)}
        </ul>
      )}

      {/* Method 6: Optional chaining + nullish coalescing */}
      <p>Username: {user?.name ?? 'Anonymous'}</p>
    </div>
  );
}

// Early return pattern in component body
interface ProtectedProps {
  user: { name: string; isVerified: boolean } | null;
}

function ProtectedContent({ user }: ProtectedProps): JSX.Element {
  if (!user) {
    return <p>Please log in to view this content.</p>;
  }

  if (!user.isVerified) {
    return <p>Please verify your email first.</p>;
  }

  return <SecretContent />;
}
```

---

## 🔁 Lists and Keys

When rendering lists, each item needs a unique `key` prop to help React track changes efficiently.

```tsx
interface Product {
  id: number;
  name: string;
  price: number;
}

function ProductList(): JSX.Element {
  const products: Product[] = [
    { id: 1, name: 'Laptop', price: 999 },
    { id: 2, name: 'Phone', price: 699 },
    { id: 3, name: 'Tablet', price: 499 },
  ];

  return (
    <div>
      {/* ✅ Good: Using unique ID as key */}
      {products.map(product => (
        <ProductCard key={product.id} product={product} />
      ))}

      {/* ⚠️ Okay: Using index (only if list never reorders) */}
      {products.map((product, index) => (
        <ProductCard key={index} product={product} />
      ))}
    </div>
  );
}

interface ProductCardProps {
  product: Product;
}

function ProductCard({ product }: ProductCardProps): JSX.Element {
  return (
    <div className="product">
      <h3>{product.name}</h3>
      <p>${product.price}</p>
    </div>
  );
}
```

---

## 🪝 Essential Hooks Deep Dive

### useRef: DOM Access & Persistent Values

```tsx
import { useRef, useEffect } from 'react';

function TextInput(): JSX.Element {
  const inputRef = useRef<HTMLInputElement>(null);
  const renderCount = useRef<number>(0);

  useEffect(() => {
    // Focus input on mount
    inputRef.current?.focus();
    
    // Track renders (doesn't cause re-render when changed)
    renderCount.current += 1;
    console.log('Render count:', renderCount.current);
  });

  return (
    <div>
      <input ref={inputRef} placeholder="I'm auto-focused!" />
      <button onClick={() => inputRef.current?.focus()}>
        Focus Input
      </button>
    </div>
  );
}
```

### useMemo: Expensive Calculations

```tsx
import { useMemo } from 'react';

interface Item {
  id: number;
  name: string;
}

interface ExpensiveListProps {
  items: Item[];
  filter: string;
}

function ExpensiveList({ items, filter }: ExpensiveListProps): JSX.Element {
  // Only recalculates when items or filter changes
  const filteredItems = useMemo<Item[]>(() => {
    console.log('Filtering items...');
    return items.filter(item => 
      item.name.toLowerCase().includes(filter.toLowerCase())
    );
  }, [items, filter]);

  return (
    <ul>
      {filteredItems.map(item => (
        <li key={item.id}>{item.name}</li>
      ))}
    </ul>
  );
}
```

### useCallback: Memoized Functions

```tsx
import { useCallback, useState, memo } from 'react';

interface ChildProps {
  onClick: () => void;
}

const ExpensiveChild = memo(function ExpensiveChild({ onClick }: ChildProps): JSX.Element {
  console.log('Child rendered');
  return <button onClick={onClick}>Child Button</button>;
});

function ParentComponent(): JSX.Element {
  const [count, setCount] = useState<number>(0);

  // Function is recreated only when dependencies change
  const handleClick = useCallback((): void => {
    console.log('Button clicked!');
  }, []); // Empty deps = function never changes

  const increment = useCallback((): void => {
    setCount(c => c + 1);
  }, []);

  return (
    <div>
      <p>Count: {count}</p>
      <ExpensiveChild onClick={handleClick} />
      <button onClick={increment}>Increment</button>
    </div>
  );
}
```

### useReducer: Complex State Logic

```tsx
import { useReducer, useState } from 'react';

interface Todo {
  id: number;
  text: string;
  done: boolean;
}

type TodoAction = 
  | { type: 'ADD'; payload: string }
  | { type: 'TOGGLE'; payload: number }
  | { type: 'DELETE'; payload: number }
  | { type: 'CLEAR_COMPLETED' };

// Reducer function (like Redux)
function todoReducer(state: Todo[], action: TodoAction): Todo[] {
  switch (action.type) {
    case 'ADD':
      return [...state, { id: Date.now(), text: action.payload, done: false }];
    case 'TOGGLE':
      return state.map(todo =>
        todo.id === action.payload ? { ...todo, done: !todo.done } : todo
      );
    case 'DELETE':
      return state.filter(todo => todo.id !== action.payload);
    case 'CLEAR_COMPLETED':
      return state.filter(todo => !todo.done);
    default:
      return state;
  }
}

function TodoApp(): JSX.Element {
  const [todos, dispatch] = useReducer(todoReducer, []);
  const [input, setInput] = useState<string>('');

  const addTodo = (): void => {
    if (input.trim()) {
      dispatch({ type: 'ADD', payload: input });
      setInput('');
    }
  };

  return (
    <div>
      <input value={input} onChange={(e) => setInput(e.target.value)} />
      <button onClick={addTodo}>Add</button>
      <button onClick={() => dispatch({ type: 'CLEAR_COMPLETED' })}>
        Clear Done
      </button>

      {todos.map(todo => (
        <div key={todo.id}>
          <span
            style={{ textDecoration: todo.done ? 'line-through' : 'none' }}
            onClick={() => dispatch({ type: 'TOGGLE', payload: todo.id })}
          >
            {todo.text}
          </span>
          <button onClick={() => dispatch({ type: 'DELETE', payload: todo.id })}>
            Delete
          </button>
        </div>
      ))}
    </div>
  );
}
```

---

## 🌍 Context API: Global State

Context lets you pass data through the component tree without prop drilling.

```tsx
import { createContext, useContext, useState, ReactNode } from 'react';

// 1. Define types
interface ThemeContextType {
  theme: 'light' | 'dark';
  toggleTheme: () => void;
}

// 2. Create the context
const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

// 3. Create a provider component
interface ThemeProviderProps {
  children: ReactNode;
}

function ThemeProvider({ children }: ThemeProviderProps): JSX.Element {
  const [theme, setTheme] = useState<'light' | 'dark'>('light');

  const toggleTheme = (): void => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light');
  };

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

// 4. Create a custom hook for easy access
function useTheme(): ThemeContextType {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider');
  }
  return context;
}

// 5. Use in components
function ThemedButton(): JSX.Element {
  const { theme, toggleTheme } = useTheme();

  return (
    <button
      onClick={toggleTheme}
      style={{
        background: theme === 'light' ? '#fff' : '#333',
        color: theme === 'light' ? '#333' : '#fff'
      }}
    >
      Current: {theme} (Click to toggle)
    </button>
  );
}

// 6. Wrap your app
function App(): JSX.Element {
  return (
    <ThemeProvider>
      <Header />
      <Main />
      <ThemedButton />
    </ThemeProvider>
  );
}
```

---

## 🛣️ React Router: Navigation

```bash
npm install react-router-dom
```

```tsx
import { 
  BrowserRouter, 
  Routes, 
  Route, 
  Link, 
  NavLink,
  useParams,
  useNavigate,
  useLocation
} from 'react-router-dom';

function App(): JSX.Element {
  return (
    <BrowserRouter>
      {/* Navigation */}
      <nav>
        <Link to="/">Home</Link>
        <Link to="/about">About</Link>
        <NavLink 
          to="/products"
          className={({ isActive }) => isActive ? 'active' : ''}
        >
          Products
        </NavLink>
      </nav>

      {/* Route definitions */}
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/about" element={<About />} />
        <Route path="/products" element={<Products />} />
        <Route path="/products/:id" element={<ProductDetail />} />
        <Route path="/dashboard/*" element={<Dashboard />} />
        <Route path="*" element={<NotFound />} />
      </Routes>
    </BrowserRouter>
  );
}

// Dynamic route with params
function ProductDetail(): JSX.Element {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const location = useLocation();

  return (
    <div>
      <h1>Product #{id}</h1>
      <p>Current path: {location.pathname}</p>
      <button onClick={() => navigate('/')}>Go Home</button>
      <button onClick={() => navigate(-1)}>Go Back</button>
    </div>
  );
}

// Nested routes
function Dashboard(): JSX.Element {
  return (
    <div>
      <h1>Dashboard</h1>
      <nav>
        <Link to="profile">Profile</Link>
        <Link to="settings">Settings</Link>
      </nav>
      <Routes>
        <Route path="profile" element={<Profile />} />
        <Route path="settings" element={<Settings />} />
      </Routes>
    </div>
  );
}
```

---

## 🎯 Custom Hooks: Reusable Logic

Extract common logic into reusable hooks.

### useLocalStorage

```tsx
import { useState, useEffect } from 'react';

function useLocalStorage<T>(key: string, initialValue: T): [T, (value: T) => void] {
  const [value, setValue] = useState<T>(() => {
    const stored = localStorage.getItem(key);
    return stored ? JSON.parse(stored) : initialValue;
  });

  useEffect(() => {
    localStorage.setItem(key, JSON.stringify(value));
  }, [key, value]);

  return [value, setValue];
}

// Usage
function Settings(): JSX.Element {
  const [theme, setTheme] = useLocalStorage<string>('theme', 'light');
  return <div>Theme: {theme}</div>;
}
```

### useFetch

```tsx
import { useState, useEffect } from 'react';

interface UseFetchResult<T> {
  data: T | null;
  loading: boolean;
  error: string | null;
}

function useFetch<T>(url: string): UseFetchResult<T> {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const controller = new AbortController();

    const fetchData = async (): Promise<void> => {
      try {
        setLoading(true);
        const response = await fetch(url, { signal: controller.signal });
        if (!response.ok) throw new Error('Failed to fetch');
        const json: T = await response.json();
        setData(json);
        setError(null);
      } catch (err) {
        if (err instanceof Error && err.name !== 'AbortError') {
          setError(err.message);
        }
      } finally {
        setLoading(false);
      }
    };

    fetchData();

    return () => controller.abort();
  }, [url]);

  return { data, loading, error };
}

// Usage
interface User {
  id: number;
  name: string;
}

function UserProfile({ userId }: { userId: number }): JSX.Element {
  const { data: user, loading, error } = useFetch<User>(`/api/users/${userId}`);

  if (loading) return <Spinner />;
  if (error) return <ErrorMsg message={error} />;
  return <Profile user={user!} />;
}
```

### useToggle

```tsx
import { useState, useCallback } from 'react';

function useToggle(initial: boolean = false): [boolean, () => void] {
  const [value, setValue] = useState<boolean>(initial);
  const toggle = useCallback(() => setValue(v => !v), []);
  return [value, toggle];
}

// Usage
function Modal(): JSX.Element {
  const [isOpen, toggleOpen] = useToggle(false);
  
  return (
    <>
      <button onClick={toggleOpen}>Open Modal</button>
      {isOpen && <div className="modal">Modal Content</div>}
    </>
  );
}
```

---

## 📝 Forms: Controlled vs Uncontrolled

### Controlled Components (Recommended)

```tsx
import { useState, ChangeEvent, FormEvent } from 'react';

interface FormData {
  username: string;
  email: string;
  password: string;
  subscribe: boolean;
}

function ControlledForm(): JSX.Element {
  const [formData, setFormData] = useState<FormData>({
    username: '',
    email: '',
    password: '',
    subscribe: false
  });

  const handleChange = (e: ChangeEvent<HTMLInputElement>): void => {
    const { name, value, type, checked } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value
    }));
  };

  const handleSubmit = (e: FormEvent<HTMLFormElement>): void => {
    e.preventDefault();
    console.log('Submitted:', formData);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        name="username"
        value={formData.username}
        onChange={handleChange}
        placeholder="Username"
      />
      <input
        name="email"
        type="email"
        value={formData.email}
        onChange={handleChange}
        placeholder="Email"
      />
      <input
        name="password"
        type="password"
        value={formData.password}
        onChange={handleChange}
        placeholder="Password"
      />
      <label>
        <input
          name="subscribe"
          type="checkbox"
          checked={formData.subscribe}
          onChange={handleChange}
        />
        Subscribe to newsletter
      </label>
      <button type="submit">Register</button>
    </form>
  );
}
```

### Uncontrolled Components (Using refs)

```tsx
import { useRef, FormEvent } from 'react';

function UncontrolledForm(): JSX.Element {
  const usernameRef = useRef<HTMLInputElement>(null);
  const emailRef = useRef<HTMLInputElement>(null);

  const handleSubmit = (e: FormEvent<HTMLFormElement>): void => {
    e.preventDefault();
    console.log({
      username: usernameRef.current?.value,
      email: emailRef.current?.value
    });
  };

  return (
    <form onSubmit={handleSubmit}>
      <input ref={usernameRef} placeholder="Username" />
      <input ref={emailRef} type="email" placeholder="Email" />
      <button type="submit">Submit</button>
    </form>
  );
}
```

---

## ⚠️ Error Boundaries

Catch JavaScript errors in component tree and display fallback UI.

```tsx
import { Component, ReactNode, ErrorInfo } from 'react';

interface Props {
  children: ReactNode;
}

interface State {
  hasError: boolean;
  error: Error | null;
}

class ErrorBoundary extends Component<Props, State> {
  state: State = { hasError: false, error: null };

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo): void {
    console.error('Error caught:', error, errorInfo);
    // Send to error reporting service
  }

  render(): ReactNode {
    if (this.state.hasError) {
      return (
        <div className="error-fallback">
          <h2>Something went wrong 😕</h2>
          <p>{this.state.error?.message}</p>
          <button onClick={() => this.setState({ hasError: false, error: null })}>
            Try Again
          </button>
        </div>
      );
    }

    return this.props.children;
  }
}

// Usage
<ErrorBoundary>
  <MyComponent />
</ErrorBoundary>
```

---

## 🎁 Quick Reference Cheatsheet

```tsx
// Component
const MyComponent: React.FC<Props> = ({ prop }) => <div>{prop}</div>;

// State
const [state, setState] = useState<Type>(initial);
setState(newValue);
setState(prev => prev + 1);

// Effect
useEffect(() => { /* run */ }, [deps]);
useEffect(() => { return () => { /* cleanup */ }; }, []);

// Ref
const ref = useRef<HTMLInputElement>(null);
<input ref={ref} />
ref.current?.focus();

// Context
const Context = createContext<Type | undefined>(undefined);
<Context.Provider value={value}>{children}</Context.Provider>
const value = useContext(Context);

// Reducer
const [state, dispatch] = useReducer(reducer, initial);
dispatch({ type: 'ACTION', payload: data });

// Memo
const memoized = useMemo<Type>(() => compute(a, b), [a, b]);
const callback = useCallback(() => fn(a), [a]);

// Conditional
{condition && <Component />}
{condition ? <A /> : <B />}

// List
{items.map(item => <Item key={item.id} {...item} />)}

// Event
<button onClick={handler}>Click</button>
<button onClick={() => handler(arg)}>Click</button>
<form onSubmit={(e: FormEvent) => { e.preventDefault(); }}>
```

---

## 🚀 What's Next?

Now that you've mastered the fundamentals, explore:

1. **State Management**: Redux, Zustand, Jotai, Recoil
2. **Server State**: React Query, SWR
3. **Styling**: Tailwind CSS, Styled Components, CSS Modules
4. **Testing**: Jest, React Testing Library, Cypress
5. **Frameworks**: Next.js (SSR/SSG), Remix, Gatsby
6. **TypeScript**: You're already using it! 🎉

---

## 📚 Resources

| Resource | Link |
|----------|------|
| Official Docs | [react.dev](https://react.dev) |
| TypeScript Cheatsheet | [react-typescript-cheatsheet.netlify.app](https://react-typescript-cheatsheet.netlify.app) |
| React Router | [reactrouter.com](https://reactrouter.com) |
| React Query | [tanstack.com/query](https://tanstack.com/query) |
| Next.js | [nextjs.org](https://nextjs.org) |

---

*Happy coding! React + TypeScript is a powerful combination that catches errors early and makes your code self-documenting.* 🚀

*Last updated: February 2026*