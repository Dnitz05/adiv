/**
 * Spread definitions for tarot readings
 * This is a simplified version for Phase 1 - will be moved to database in later phases
 */

export interface SpreadPosition {
  number: number;
  meaning: string;
  meaningCA: string;
  meaningES: string;
  coordinates: { x: number; y: number };
  rotation?: number;
  description?: string;
  descriptionCA?: string;
  descriptionES?: string;
}

export interface SpreadDefinition {
  id: string;
  name: string;
  nameCA: string;
  nameES: string;
  description: string;
  descriptionCA: string;
  descriptionES: string;
  cardCount: number;
  positions: SpreadPosition[];
  category: string;
  complexity: string;
  suitableFor: string[];
  layoutAspectRatio: number;
  requiresExtraInput: boolean;
  instructions?: string;
  instructionsCA?: string;
  instructionsES?: string;
  isFreemium: boolean;
  estimatedDurationMinutes: number;
}

/**
 * All available spreads
 */
export const SPREADS: SpreadDefinition[] = [
  // 1. Three Card Spread
  {
    id: 'three_card',
    name: 'Three Card Spread',
    nameCA: 'Tirada de Tres Cartes',
    nameES: 'Tirada de Tres Cartas',
    description: 'Simple and effective spread for quick insights',
    descriptionCA: 'Una tirada simple i efectiva per obtenir respostes ràpides',
    descriptionES: 'Una tirada simple y efectiva para obtener respuestas rápidas',
    cardCount: 3,
    category: 'general',
    complexity: 'simple',
    suitableFor: ['general', 'quick', 'overview', 'future', 'past'],
    layoutAspectRatio: 2.5,
    requiresExtraInput: false,
    isFreemium: true,
    estimatedDurationMinutes: 5,
    positions: [
      {
        number: 1,
        meaning: 'Past',
        meaningCA: 'Passat',
        meaningES: 'Pasado',
        coordinates: { x: 0.2, y: 0.5 },
        rotation: 0,
        description: 'What has led to the current situation',
        descriptionCA: 'Què ha portat a la situació actual',
        descriptionES: 'Qué ha llevado a la situación actual',
      },
      {
        number: 2,
        meaning: 'Present',
        meaningCA: 'Present',
        meaningES: 'Presente',
        coordinates: { x: 0.5, y: 0.5 },
        rotation: 0,
        description: 'The current situation and energies',
        descriptionCA: 'La situació i energies actuals',
        descriptionES: 'La situación y energías actuales',
      },
      {
        number: 3,
        meaning: 'Future',
        meaningCA: 'Futur',
        meaningES: 'Futuro',
        coordinates: { x: 0.8, y: 0.5 },
        rotation: 0,
        description: 'The likely outcome or direction',
        descriptionCA: 'El resultat o direcció probable',
        descriptionES: 'El resultado o dirección probable',
      },
    ],
  },

  // 2. Celtic Cross
  {
    id: 'celtic_cross',
    name: 'Celtic Cross',
    nameCA: 'Creu Celta',
    nameES: 'Cruz Celta',
    description: 'The classic comprehensive spread for deep insights',
    descriptionCA: 'La tirada clàssica i completa per obtenir insights profunds',
    descriptionES: 'La tirada clásica y completa para obtener insights profundos',
    cardCount: 10,
    category: 'general',
    complexity: 'complex',
    suitableFor: ['general', 'complex', 'detailed', 'career', 'life', 'situation'],
    layoutAspectRatio: 1.2,
    requiresExtraInput: false,
    isFreemium: false,
    estimatedDurationMinutes: 20,
    positions: [
      {
        number: 1,
        meaning: 'Present Situation',
        meaningCA: 'Situació Actual',
        meaningES: 'Situación Actual',
        coordinates: { x: 0.35, y: 0.4 },
        rotation: 0,
      },
      {
        number: 2,
        meaning: 'Challenge',
        meaningCA: 'Desafiament',
        meaningES: 'Desafío',
        coordinates: { x: 0.35, y: 0.4 },
        rotation: 90,
      },
      {
        number: 3,
        meaning: 'Foundation',
        meaningCA: 'Fonaments',
        meaningES: 'Fundamentos',
        coordinates: { x: 0.35, y: 0.65 },
        rotation: 0,
      },
      {
        number: 4,
        meaning: 'Recent Past',
        meaningCA: 'Passat Recent',
        meaningES: 'Pasado Reciente',
        coordinates: { x: 0.15, y: 0.4 },
        rotation: 0,
      },
      {
        number: 5,
        meaning: 'Crown',
        meaningCA: 'Corona',
        meaningES: 'Corona',
        coordinates: { x: 0.35, y: 0.15 },
        rotation: 0,
      },
      {
        number: 6,
        meaning: 'Near Future',
        meaningCA: 'Futur Proper',
        meaningES: 'Futuro Próximo',
        coordinates: { x: 0.55, y: 0.4 },
        rotation: 0,
      },
      {
        number: 7,
        meaning: 'Your Approach',
        meaningCA: 'La Teva Actitud',
        meaningES: 'Tu Actitud',
        coordinates: { x: 0.75, y: 0.7 },
        rotation: 0,
      },
      {
        number: 8,
        meaning: 'External Influences',
        meaningCA: 'Influències Externes',
        meaningES: 'Influencias Externas',
        coordinates: { x: 0.75, y: 0.55 },
        rotation: 0,
      },
      {
        number: 9,
        meaning: 'Hopes and Fears',
        meaningCA: 'Esperances i Pors',
        meaningES: 'Esperanzas y Miedos',
        coordinates: { x: 0.75, y: 0.4 },
        rotation: 0,
      },
      {
        number: 10,
        meaning: 'Outcome',
        meaningCA: 'Resultat',
        meaningES: 'Resultado',
        coordinates: { x: 0.75, y: 0.25 },
        rotation: 0,
      },
    ],
  },

  // 3. Decision Spread
  {
    id: 'decision',
    name: 'Decision Spread',
    nameCA: 'Tirada de Decisió',
    nameES: 'Tirada de Decisión',
    description: 'Compare two options to make an informed choice',
    descriptionCA: 'Compara dues opcions per prendre una decisió informada',
    descriptionES: 'Compara dos opciones para tomar una decisión informada',
    cardCount: 7,
    category: 'decision',
    complexity: 'medium',
    suitableFor: ['decision', 'choice', 'options', 'dilemma', 'crossroads'],
    layoutAspectRatio: 1.8,
    requiresExtraInput: true,
    isFreemium: true,
    estimatedDurationMinutes: 15,
    positions: [
      {
        number: 1,
        meaning: 'Current Situation',
        meaningCA: 'Situació Actual',
        meaningES: 'Situación Actual',
        coordinates: { x: 0.5, y: 0.2 },
        rotation: 0,
      },
      {
        number: 2,
        meaning: 'Option A - Nature',
        meaningCA: 'Opció A - Natura',
        meaningES: 'Opción A - Naturaleza',
        coordinates: { x: 0.25, y: 0.4 },
        rotation: 0,
      },
      {
        number: 3,
        meaning: 'Option A - Outcome',
        meaningCA: 'Opció A - Resultat',
        meaningES: 'Opción A - Resultado',
        coordinates: { x: 0.25, y: 0.7 },
        rotation: 0,
      },
      {
        number: 4,
        meaning: 'Option B - Nature',
        meaningCA: 'Opció B - Natura',
        meaningES: 'Opción B - Naturaleza',
        coordinates: { x: 0.75, y: 0.4 },
        rotation: 0,
      },
      {
        number: 5,
        meaning: 'Option B - Outcome',
        meaningCA: 'Opció B - Resultat',
        meaningES: 'Opción B - Resultado',
        coordinates: { x: 0.75, y: 0.7 },
        rotation: 0,
      },
      {
        number: 6,
        meaning: 'Hidden Factor',
        meaningCA: 'Factor Ocult',
        meaningES: 'Factor Oculto',
        coordinates: { x: 0.5, y: 0.5 },
        rotation: 0,
      },
      {
        number: 7,
        meaning: 'Best Course',
        meaningCA: 'Millor Camí',
        meaningES: 'Mejor Camino',
        coordinates: { x: 0.5, y: 0.85 },
        rotation: 0,
      },
    ],
  },

  // 4. Love Spread
  {
    id: 'love',
    name: 'Love Spread',
    nameCA: 'Tirada d\'Amor',
    nameES: 'Tirada de Amor',
    description: 'Explore relationship dynamics and romantic connections',
    descriptionCA: 'Explora les dinàmiques de la relació i les connexions romàntiques',
    descriptionES: 'Explora las dinámicas de la relación y las conexiones románticas',
    cardCount: 5,
    category: 'love',
    complexity: 'medium',
    suitableFor: ['love', 'romance', 'relationship', 'partner', 'connection'],
    layoutAspectRatio: 1.5,
    requiresExtraInput: false,
    isFreemium: true,
    estimatedDurationMinutes: 10,
    positions: [
      {
        number: 1,
        meaning: 'You',
        meaningCA: 'Tu',
        meaningES: 'Tú',
        coordinates: { x: 0.25, y: 0.3 },
        rotation: 0,
      },
      {
        number: 2,
        meaning: 'The Other Person',
        meaningCA: 'L\'Altra Persona',
        meaningES: 'La Otra Persona',
        coordinates: { x: 0.75, y: 0.3 },
        rotation: 0,
      },
      {
        number: 3,
        meaning: 'The Connection',
        meaningCA: 'La Connexió',
        meaningES: 'La Conexión',
        coordinates: { x: 0.5, y: 0.3 },
        rotation: 0,
      },
      {
        number: 4,
        meaning: 'Obstacles',
        meaningCA: 'Obstacles',
        meaningES: 'Obstáculos',
        coordinates: { x: 0.5, y: 0.6 },
        rotation: 0,
      },
      {
        number: 5,
        meaning: 'Potential',
        meaningCA: 'Potencial',
        meaningES: 'Potencial',
        coordinates: { x: 0.5, y: 0.85 },
        rotation: 0,
      },
    ],
  },

  // 5. The Path
  {
    id: 'the_path',
    name: 'The Path',
    nameCA: 'El Camí',
    nameES: 'El Camino',
    description: 'Follow your journey from where you are to where you want to be',
    descriptionCA: 'Segueix el teu viatge des d\'on estàs fins on vols arribar',
    descriptionES: 'Sigue tu viaje desde donde estás hasta donde quieres llegar',
    cardCount: 5,
    category: 'general',
    complexity: 'simple',
    suitableFor: ['general', 'journey', 'progress', 'growth', 'path', 'direction'],
    layoutAspectRatio: 2.5,
    requiresExtraInput: false,
    isFreemium: true,
    estimatedDurationMinutes: 10,
    positions: [
      {
        number: 1,
        meaning: 'Where You Are',
        meaningCA: 'On Estàs',
        meaningES: 'Dónde Estás',
        coordinates: { x: 0.1, y: 0.5 },
        rotation: 0,
      },
      {
        number: 2,
        meaning: 'First Step',
        meaningCA: 'Primer Pas',
        meaningES: 'Primer Paso',
        coordinates: { x: 0.3, y: 0.5 },
        rotation: 0,
      },
      {
        number: 3,
        meaning: 'Obstacles',
        meaningCA: 'Obstacles',
        meaningES: 'Obstáculos',
        coordinates: { x: 0.5, y: 0.3 },
        rotation: 0,
      },
      {
        number: 4,
        meaning: 'Help',
        meaningCA: 'Ajuda',
        meaningES: 'Ayuda',
        coordinates: { x: 0.7, y: 0.5 },
        rotation: 0,
      },
      {
        number: 5,
        meaning: 'Destination',
        meaningCA: 'Destinació',
        meaningES: 'Destino',
        coordinates: { x: 0.9, y: 0.5 },
        rotation: 0,
      },
    ],
  },
];

/**
 * Get a spread by ID
 */
export function getSpreadById(id: string): SpreadDefinition | undefined {
  return SPREADS.find((spread) => spread.id === id);
}

/**
 * Get spreads by category
 */
export function getSpreadsByCategory(category: string): SpreadDefinition[] {
  return SPREADS.filter((spread) => spread.category === category);
}

/**
 * Get spreads by complexity
 */
export function getSpreadsByComplexity(complexity: string): SpreadDefinition[] {
  return SPREADS.filter((spread) => spread.complexity === complexity);
}

/**
 * Calculate relevance score for a spread based on keywords
 */
export function calculateRelevanceScore(
  spread: SpreadDefinition,
  keywords: string[],
  targetCategory?: string,
  targetComplexity?: string
): number {
  let score = 0;

  // Category match (50 points)
  if (targetCategory && spread.category === targetCategory) {
    score += 50;
  }

  // Complexity match (30 points)
  if (targetComplexity && spread.complexity === targetComplexity) {
    score += 30;
  }

  // Keyword matches (20 points)
  if (keywords && keywords.length > 0) {
    const lowerKeywords = keywords.map((k) => k.toLowerCase());
    const matches = spread.suitableFor.filter((tag) =>
      lowerKeywords.some((keyword) => tag.includes(keyword) || keyword.includes(tag))
    );
    score += (matches.length / keywords.length) * 20;
  }

  return score;
}

/**
 * Find best spread for given criteria
 */
export function findBestSpread(
  keywords: string[],
  category?: string,
  complexity?: string
): SpreadDefinition {
  const scored = SPREADS.map((spread) => ({
    spread,
    score: calculateRelevanceScore(spread, keywords, category, complexity),
  }));

  scored.sort((a, b) => b.score - a.score);

  return scored[0].spread;
}
