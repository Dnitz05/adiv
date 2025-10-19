/**
 * Canonical Tarot Card Names
 * Single source of truth for card names in all supported languages
 */

export interface CardName {
  id: number;
  en: string; // English (canonical)
  es: string; // Spanish
  ca: string; // Catalan
  suit: string;
  number: number | null;
  arcana: 'major' | 'minor';
  image: string; // Flutter asset path
}

/**
 * Complete 78-card deck with canonical names in all languages
 * These EXACT names must be used by the AI and all clients
 */
export const CARD_NAMES: ReadonlyArray<CardName> = [
  // ========== Major Arcana (0-21) ==========
  { id: 0, en: 'The Fool', es: 'El Loco', ca: 'El Boig', suit: 'Major Arcana', number: 0, arcana: 'major', image: 'assets/cards/00-TheFool.jpg' },
  { id: 1, en: 'The Magician', es: 'El Mago', ca: 'El Mag', suit: 'Major Arcana', number: 1, arcana: 'major', image: 'assets/cards/01-TheMagician.jpg' },
  { id: 2, en: 'The High Priestess', es: 'La Sacerdotisa', ca: 'La Sacerdotessa', suit: 'Major Arcana', number: 2, arcana: 'major', image: 'assets/cards/02-TheHighPriestess.jpg' },
  { id: 3, en: 'The Empress', es: 'La Emperatriz', ca: "L'Emperadriu", suit: 'Major Arcana', number: 3, arcana: 'major', image: 'assets/cards/03-TheEmpress.jpg' },
  { id: 4, en: 'The Emperor', es: 'El Emperador', ca: "L'Emperador", suit: 'Major Arcana', number: 4, arcana: 'major', image: 'assets/cards/04-TheEmperor.jpg' },
  { id: 5, en: 'The Hierophant', es: 'El Hierofante', ca: 'El Hierofant', suit: 'Major Arcana', number: 5, arcana: 'major', image: 'assets/cards/05-TheHierophant.jpg' },
  { id: 6, en: 'The Lovers', es: 'Los Enamorados', ca: 'Els Enamorats', suit: 'Major Arcana', number: 6, arcana: 'major', image: 'assets/cards/06-TheLovers.jpg' },
  { id: 7, en: 'The Chariot', es: 'El Carro', ca: 'El Carro', suit: 'Major Arcana', number: 7, arcana: 'major', image: 'assets/cards/07-TheChariot.jpg' },
  { id: 8, en: 'Strength', es: 'La Fuerza', ca: 'La Força', suit: 'Major Arcana', number: 8, arcana: 'major', image: 'assets/cards/08-Strength.jpg' },
  { id: 9, en: 'The Hermit', es: 'El Ermitaño', ca: "L'Ermità", suit: 'Major Arcana', number: 9, arcana: 'major', image: 'assets/cards/09-TheHermit.jpg' },
  { id: 10, en: 'Wheel of Fortune', es: 'La Rueda de la Fortuna', ca: 'La Roda de la Fortuna', suit: 'Major Arcana', number: 10, arcana: 'major', image: 'assets/cards/10-WheelOfFortune.jpg' },
  { id: 11, en: 'Justice', es: 'La Justicia', ca: 'La Justícia', suit: 'Major Arcana', number: 11, arcana: 'major', image: 'assets/cards/11-Justice.jpg' },
  { id: 12, en: 'The Hanged Man', es: 'El Colgado', ca: 'El Penjat', suit: 'Major Arcana', number: 12, arcana: 'major', image: 'assets/cards/12-TheHangedMan.jpg' },
  { id: 13, en: 'Death', es: 'La Muerte', ca: 'La Mort', suit: 'Major Arcana', number: 13, arcana: 'major', image: 'assets/cards/13-Death.jpg' },
  { id: 14, en: 'Temperance', es: 'La Templanza', ca: 'La Temperància', suit: 'Major Arcana', number: 14, arcana: 'major', image: 'assets/cards/14-Temperance.jpg' },
  { id: 15, en: 'The Devil', es: 'El Diablo', ca: 'El Dimoni', suit: 'Major Arcana', number: 15, arcana: 'major', image: 'assets/cards/15-TheDevil.jpg' },
  { id: 16, en: 'The Tower', es: 'La Torre', ca: 'La Torre', suit: 'Major Arcana', number: 16, arcana: 'major', image: 'assets/cards/16-TheTower.jpg' },
  { id: 17, en: 'The Star', es: 'La Estrella', ca: "L'Estrella", suit: 'Major Arcana', number: 17, arcana: 'major', image: 'assets/cards/17-TheStar.jpg' },
  { id: 18, en: 'The Moon', es: 'La Luna', ca: 'La Lluna', suit: 'Major Arcana', number: 18, arcana: 'major', image: 'assets/cards/18-TheMoon.jpg' },
  { id: 19, en: 'The Sun', es: 'El Sol', ca: 'El Sol', suit: 'Major Arcana', number: 19, arcana: 'major', image: 'assets/cards/19-TheSun.jpg' },
  { id: 20, en: 'Judgement', es: 'El Juicio', ca: 'El Judici', suit: 'Major Arcana', number: 20, arcana: 'major', image: 'assets/cards/20-Judgement.jpg' },
  { id: 21, en: 'The World', es: 'El Mundo', ca: 'El Món', suit: 'Major Arcana', number: 21, arcana: 'major', image: 'assets/cards/21-TheWorld.jpg' },

  // ========== Minor Arcana - Wands (Fire) ==========
  { id: 22, en: 'Ace of Wands', es: 'As de Bastos', ca: 'As de Bastons', suit: 'Wands', number: 1, arcana: 'minor', image: 'assets/cards/Wands01.jpg' },
  { id: 23, en: 'Two of Wands', es: 'Dos de Bastos', ca: 'Dos de Bastons', suit: 'Wands', number: 2, arcana: 'minor', image: 'assets/cards/Wands02.jpg' },
  { id: 24, en: 'Three of Wands', es: 'Tres de Bastos', ca: 'Tres de Bastons', suit: 'Wands', number: 3, arcana: 'minor', image: 'assets/cards/Wands03.jpg' },
  { id: 25, en: 'Four of Wands', es: 'Cuatro de Bastos', ca: 'Quatre de Bastons', suit: 'Wands', number: 4, arcana: 'minor', image: 'assets/cards/Wands04.jpg' },
  { id: 26, en: 'Five of Wands', es: 'Cinco de Bastos', ca: 'Cinc de Bastons', suit: 'Wands', number: 5, arcana: 'minor', image: 'assets/cards/Wands05.jpg' },
  { id: 27, en: 'Six of Wands', es: 'Seis de Bastos', ca: 'Sis de Bastons', suit: 'Wands', number: 6, arcana: 'minor', image: 'assets/cards/Wands06.jpg' },
  { id: 28, en: 'Seven of Wands', es: 'Siete de Bastos', ca: 'Set de Bastons', suit: 'Wands', number: 7, arcana: 'minor', image: 'assets/cards/Wands07.jpg' },
  { id: 29, en: 'Eight of Wands', es: 'Ocho de Bastos', ca: 'Vuit de Bastons', suit: 'Wands', number: 8, arcana: 'minor', image: 'assets/cards/Wands08.jpg' },
  { id: 30, en: 'Nine of Wands', es: 'Nueve de Bastos', ca: 'Nou de Bastons', suit: 'Wands', number: 9, arcana: 'minor', image: 'assets/cards/Wands09.jpg' },
  { id: 31, en: 'Ten of Wands', es: 'Diez de Bastos', ca: 'Deu de Bastons', suit: 'Wands', number: 10, arcana: 'minor', image: 'assets/cards/Wands10.jpg' },
  { id: 32, en: 'Page of Wands', es: 'Sota de Bastos', ca: 'Sota de Bastons', suit: 'Wands', number: 11, arcana: 'minor', image: 'assets/cards/Wands11.jpg' },
  { id: 33, en: 'Knight of Wands', es: 'Caballero de Bastos', ca: 'Cavaller de Bastons', suit: 'Wands', number: 12, arcana: 'minor', image: 'assets/cards/Wands12.jpg' },
  { id: 34, en: 'Queen of Wands', es: 'Reina de Bastos', ca: 'Reina de Bastons', suit: 'Wands', number: 13, arcana: 'minor', image: 'assets/cards/Wands13.jpg' },
  { id: 35, en: 'King of Wands', es: 'Rey de Bastos', ca: 'Rei de Bastons', suit: 'Wands', number: 14, arcana: 'minor', image: 'assets/cards/Wands14.jpg' },

  // ========== Minor Arcana - Cups (Water) ==========
  { id: 36, en: 'Ace of Cups', es: 'As de Copas', ca: 'As de Copes', suit: 'Cups', number: 1, arcana: 'minor', image: 'assets/cards/Cups01.jpg' },
  { id: 37, en: 'Two of Cups', es: 'Dos de Copas', ca: 'Dos de Copes', suit: 'Cups', number: 2, arcana: 'minor', image: 'assets/cards/Cups02.jpg' },
  { id: 38, en: 'Three of Cups', es: 'Tres de Copas', ca: 'Tres de Copes', suit: 'Cups', number: 3, arcana: 'minor', image: 'assets/cards/Cups03.jpg' },
  { id: 39, en: 'Four of Cups', es: 'Cuatro de Copas', ca: 'Quatre de Copes', suit: 'Cups', number: 4, arcana: 'minor', image: 'assets/cards/Cups04.jpg' },
  { id: 40, en: 'Five of Cups', es: 'Cinco de Copas', ca: 'Cinc de Copes', suit: 'Cups', number: 5, arcana: 'minor', image: 'assets/cards/Cups05.jpg' },
  { id: 41, en: 'Six of Cups', es: 'Seis de Copas', ca: 'Sis de Copes', suit: 'Cups', number: 6, arcana: 'minor', image: 'assets/cards/Cups06.jpg' },
  { id: 42, en: 'Seven of Cups', es: 'Siete de Copas', ca: 'Set de Copes', suit: 'Cups', number: 7, arcana: 'minor', image: 'assets/cards/Cups07.jpg' },
  { id: 43, en: 'Eight of Cups', es: 'Ocho de Copas', ca: 'Vuit de Copes', suit: 'Cups', number: 8, arcana: 'minor', image: 'assets/cards/Cups08.jpg' },
  { id: 44, en: 'Nine of Cups', es: 'Nueve de Copas', ca: 'Nou de Copes', suit: 'Cups', number: 9, arcana: 'minor', image: 'assets/cards/Cups09.jpg' },
  { id: 45, en: 'Ten of Cups', es: 'Diez de Copas', ca: 'Deu de Copes', suit: 'Cups', number: 10, arcana: 'minor', image: 'assets/cards/Cups10.jpg' },
  { id: 46, en: 'Page of Cups', es: 'Sota de Copas', ca: 'Sota de Copes', suit: 'Cups', number: 11, arcana: 'minor', image: 'assets/cards/Cups11.jpg' },
  { id: 47, en: 'Knight of Cups', es: 'Caballero de Copas', ca: 'Cavaller de Copes', suit: 'Cups', number: 12, arcana: 'minor', image: 'assets/cards/Cups12.jpg' },
  { id: 48, en: 'Queen of Cups', es: 'Reina de Copas', ca: 'Reina de Copes', suit: 'Cups', number: 13, arcana: 'minor', image: 'assets/cards/Cups13.jpg' },
  { id: 49, en: 'King of Cups', es: 'Rey de Copas', ca: 'Rei de Copes', suit: 'Cups', number: 14, arcana: 'minor', image: 'assets/cards/Cups14.jpg' },

  // ========== Minor Arcana - Swords (Air) ==========
  { id: 50, en: 'Ace of Swords', es: 'As de Espadas', ca: 'As de Espases', suit: 'Swords', number: 1, arcana: 'minor', image: 'assets/cards/Swords01.jpg' },
  { id: 51, en: 'Two of Swords', es: 'Dos de Espadas', ca: 'Dos de Espases', suit: 'Swords', number: 2, arcana: 'minor', image: 'assets/cards/Swords02.jpg' },
  { id: 52, en: 'Three of Swords', es: 'Tres de Espadas', ca: 'Tres de Espases', suit: 'Swords', number: 3, arcana: 'minor', image: 'assets/cards/Swords03.jpg' },
  { id: 53, en: 'Four of Swords', es: 'Cuatro de Espadas', ca: 'Quatre de Espases', suit: 'Swords', number: 4, arcana: 'minor', image: 'assets/cards/Swords04.jpg' },
  { id: 54, en: 'Five of Swords', es: 'Cinco de Espadas', ca: 'Cinc de Espases', suit: 'Swords', number: 5, arcana: 'minor', image: 'assets/cards/Swords05.jpg' },
  { id: 55, en: 'Six of Swords', es: 'Seis de Espadas', ca: 'Sis de Espases', suit: 'Swords', number: 6, arcana: 'minor', image: 'assets/cards/Swords06.jpg' },
  { id: 56, en: 'Seven of Swords', es: 'Siete de Espadas', ca: 'Set de Espases', suit: 'Swords', number: 7, arcana: 'minor', image: 'assets/cards/Swords07.jpg' },
  { id: 57, en: 'Eight of Swords', es: 'Ocho de Espadas', ca: 'Vuit de Espases', suit: 'Swords', number: 8, arcana: 'minor', image: 'assets/cards/Swords08.jpg' },
  { id: 58, en: 'Nine of Swords', es: 'Nueve de Espadas', ca: 'Nou de Espases', suit: 'Swords', number: 9, arcana: 'minor', image: 'assets/cards/Swords09.jpg' },
  { id: 59, en: 'Ten of Swords', es: 'Diez de Espadas', ca: 'Deu de Espases', suit: 'Swords', number: 10, arcana: 'minor', image: 'assets/cards/Swords10.jpg' },
  { id: 60, en: 'Page of Swords', es: 'Sota de Espadas', ca: 'Sota de Espases', suit: 'Swords', number: 11, arcana: 'minor', image: 'assets/cards/Swords11.jpg' },
  { id: 61, en: 'Knight of Swords', es: 'Caballero de Espadas', ca: 'Cavaller de Espases', suit: 'Swords', number: 12, arcana: 'minor', image: 'assets/cards/Swords12.jpg' },
  { id: 62, en: 'Queen of Swords', es: 'Reina de Espadas', ca: 'Reina de Espases', suit: 'Swords', number: 13, arcana: 'minor', image: 'assets/cards/Swords13.jpg' },
  { id: 63, en: 'King of Swords', es: 'Rey de Espadas', ca: 'Rei de Espases', suit: 'Swords', number: 14, arcana: 'minor', image: 'assets/cards/Swords14.jpg' },

  // ========== Minor Arcana - Pentacles (Earth) ==========
  { id: 64, en: 'Ace of Pentacles', es: 'As de Oros', ca: 'As de Ors', suit: 'Pentacles', number: 1, arcana: 'minor', image: 'assets/cards/Pentacles01.jpg' },
  { id: 65, en: 'Two of Pentacles', es: 'Dos de Oros', ca: 'Dos de Ors', suit: 'Pentacles', number: 2, arcana: 'minor', image: 'assets/cards/Pentacles02.jpg' },
  { id: 66, en: 'Three of Pentacles', es: 'Tres de Oros', ca: 'Tres de Ors', suit: 'Pentacles', number: 3, arcana: 'minor', image: 'assets/cards/Pentacles03.jpg' },
  { id: 67, en: 'Four of Pentacles', es: 'Cuatro de Oros', ca: 'Quatre de Ors', suit: 'Pentacles', number: 4, arcana: 'minor', image: 'assets/cards/Pentacles04.jpg' },
  { id: 68, en: 'Five of Pentacles', es: 'Cinco de Oros', ca: 'Cinc de Ors', suit: 'Pentacles', number: 5, arcana: 'minor', image: 'assets/cards/Pentacles05.jpg' },
  { id: 69, en: 'Six of Pentacles', es: 'Seis de Oros', ca: 'Sis de Ors', suit: 'Pentacles', number: 6, arcana: 'minor', image: 'assets/cards/Pentacles06.jpg' },
  { id: 70, en: 'Seven of Pentacles', es: 'Siete de Oros', ca: 'Set de Ors', suit: 'Pentacles', number: 7, arcana: 'minor', image: 'assets/cards/Pentacles07.jpg' },
  { id: 71, en: 'Eight of Pentacles', es: 'Ocho de Oros', ca: 'Vuit de Ors', suit: 'Pentacles', number: 8, arcana: 'minor', image: 'assets/cards/Pentacles08.jpg' },
  { id: 72, en: 'Nine of Pentacles', es: 'Nueve de Oros', ca: 'Nou de Ors', suit: 'Pentacles', number: 9, arcana: 'minor', image: 'assets/cards/Pentacles09.jpg' },
  { id: 73, en: 'Ten of Pentacles', es: 'Diez de Oros', ca: 'Deu de Ors', suit: 'Pentacles', number: 10, arcana: 'minor', image: 'assets/cards/Pentacles10.jpg' },
  { id: 74, en: 'Page of Pentacles', es: 'Sota de Oros', ca: 'Sota de Ors', suit: 'Pentacles', number: 11, arcana: 'minor', image: 'assets/cards/Pentacles11.jpg' },
  { id: 75, en: 'Knight of Pentacles', es: 'Caballero de Oros', ca: 'Cavaller de Ors', suit: 'Pentacles', number: 12, arcana: 'minor', image: 'assets/cards/Pentacles12.jpg' },
  { id: 76, en: 'Queen of Pentacles', es: 'Reina de Oros', ca: 'Reina de Ors', suit: 'Pentacles', number: 13, arcana: 'minor', image: 'assets/cards/Pentacles13.jpg' },
  { id: 77, en: 'King of Pentacles', es: 'Rey de Oros', ca: 'Rei de Ors', suit: 'Pentacles', number: 14, arcana: 'minor', image: 'assets/cards/Pentacles14.jpg' },
] as const;

/**
 * Get card name by ID and locale
 */
export function getCardName(id: number, locale: 'en' | 'es' | 'ca' = 'en'): string | null {
  const card = CARD_NAMES.find((c) => c.id === id);
  return card ? card[locale] : null;
}

/**
 * Get card by English name (case-insensitive)
 */
export function getCardByEnglishName(name: string): CardName | null {
  const normalized = name.trim().toLowerCase();
  return CARD_NAMES.find((c) => c.en.toLowerCase() === normalized) || null;
}

/**
 * Get card by localized name (case-insensitive, searches all languages)
 */
export function getCardByLocalizedName(name: string): CardName | null {
  const normalized = name.trim().toLowerCase();
  return (
    CARD_NAMES.find(
      (c) =>
        c.en.toLowerCase() === normalized ||
        c.es.toLowerCase() === normalized ||
        c.ca.toLowerCase() === normalized
    ) || null
  );
}

/**
 * Get all card names for a specific locale
 * Useful for passing to AI prompts
 */
export function getAllCardNames(locale: 'en' | 'es' | 'ca' = 'en'): string[] {
  return CARD_NAMES.map((c) => c[locale]);
}

/**
 * Format card names list for AI prompt
 * Returns a compact reference list: "ID: EN|ES|CA"
 */
export function formatCardNamesForPrompt(): string {
  return CARD_NAMES.map((c) => `${c.id}: ${c.en}|${c.es}|${c.ca}`).join('\n');
}

/**
 * Get card name lookup map (English → all languages)
 * Useful for quick lookups
 */
export function getCardNameMap(): Map<string, { es: string; ca: string }> {
  const map = new Map<string, { es: string; ca: string }>();
  for (const card of CARD_NAMES) {
    map.set(card.en.toLowerCase(), { es: card.es, ca: card.ca });
  }
  return map;
}

/**
 * Reverse lookup: Get English name from any localized name
 */
export function getEnglishName(localizedName: string): string | null {
  const card = getCardByLocalizedName(localizedName);
  return card ? card.en : null;
}
