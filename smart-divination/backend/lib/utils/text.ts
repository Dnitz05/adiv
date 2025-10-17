/**
 * Text Utilities - Shared text processing functions
 *
 * Provides common text manipulation utilities used across the backend API.
 */

/**
 * Extract keywords from a text source
 * @param source - The text to extract keywords from
 * @param maxKeywords - Maximum number of keywords to return (default: 10)
 * @returns Array of unique keywords (lowercase, 4+ chars)
 */
export function extractKeywords(source?: string | null, maxKeywords = 10): string[] {
  if (!source) {
    return [];
  }
  const words = source
    .toLowerCase()
    .replace(/[^a-z0-9\s]/g, ' ')
    .split(/\s+/)
    .filter((word) => word.length >= 4);
  const unique = Array.from(new Set(words));
  return unique.slice(0, maxKeywords);
}

/**
 * Sanitize user input by trimming and removing potentially dangerous characters
 * @param input - The text to sanitize
 * @param maxLength - Maximum length to allow (default: 1000)
 * @returns Sanitized string
 */
export function sanitizeText(input: string, maxLength = 1000): string {
  return input.trim().replace(/[<>]/g, '').slice(0, maxLength);
}

/**
 * Truncate text to a specific length, adding ellipsis if needed
 * @param text - The text to truncate
 * @param maxLength - Maximum length (default: 100)
 * @returns Truncated text with ellipsis if needed
 */
export function truncate(text: string, maxLength = 100): string {
  if (text.length <= maxLength) {
    return text;
  }
  return text.slice(0, maxLength - 3) + '...';
}

/**
 * Normalize whitespace in a string (collapse multiple spaces to single space)
 * @param text - The text to normalize
 * @returns Normalized text
 */
export function normalizeWhitespace(text: string): string {
  return text.replace(/\s+/g, ' ').trim();
}

/**
 * Convert a string to title case
 * @param text - The text to convert
 * @returns Title cased text
 */
export function toTitleCase(text: string): string {
  return text
    .toLowerCase()
    .split(' ')
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');
}
