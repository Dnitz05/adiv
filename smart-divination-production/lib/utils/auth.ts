// Shared authentication utilities (temporary in-memory implementation)

export interface User {
  id: string;
  email: string;
  password: string;
  name: string;
  isPremium: boolean;
  createdAt: Date;
  provider?: 'email' | 'google' | 'apple';
  providerId?: string;
}

// In-memory user storage (replace with database in production)
export const users: User[] = [];

export const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key-change-this-in-production';

// Helper function to generate unique user ID
export function generateUserId(): string {
  return 'user_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
}

// Helper function to validate email format
export function isValidEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

// Helper function to find user by email
export function findUserByEmail(email: string): User | undefined {
  return users.find(user => user.email.toLowerCase() === email.toLowerCase());
}

// Helper function to find user by ID
export function findUserById(id: string): User | undefined {
  return users.find(user => user.id === id);
}

// Helper function to create user without password
export function userWithoutPassword(user: User): Omit<User, 'password'> {
  const { password, ...userWithoutPass } = user;
  return userWithoutPass;
}

