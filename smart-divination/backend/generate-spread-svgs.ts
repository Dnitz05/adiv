/**
 * Generate SVG visualizations for all tarot spreads
 *
 * This script creates compact SVG representations of spread layouts
 * using the position coordinates from spreads.ts
 */

import { SPREADS, type SpreadDefinition } from './lib/data/spreads';
import * as fs from 'fs';
import * as path from 'path';

interface CardRect {
  x: number;
  y: number;
  width: number;
  height: number;
  rotation: number;
  number: number;
  code: string;
}

/**
 * Generate SVG for a single spread layout
 */
function generateSpreadSVG(spread: SpreadDefinition): string {
  const viewBoxWidth = 400;
  const viewBoxHeight = viewBoxWidth / spread.layoutAspectRatio;

  // Card dimensions (in viewBox units)
  const cardWidth = 50;
  const cardHeight = 80;

  // Convert normalized coordinates to viewBox coordinates
  const cards: CardRect[] = spread.positions.map(pos => {
    // Normalize coordinates (0-1) to viewBox
    const centerX = pos.coordinates.x * viewBoxWidth;
    const centerY = pos.coordinates.y * viewBoxHeight;

    // Position card centered on coordinate
    const x = centerX - cardWidth / 2;
    const y = centerY - cardHeight / 2;

    return {
      x,
      y,
      width: cardWidth,
      height: cardHeight,
      rotation: pos.rotation || 0,
      number: pos.number,
      code: pos.code,
    };
  });

  // Generate SVG
  const svgCards = cards.map(card => {
    const transform = card.rotation !== 0
      ? `rotate(${card.rotation} ${card.x + card.width/2} ${card.y + card.height/2})`
      : '';

    return `
    <!-- Card ${card.number}: ${card.code} -->
    <g ${transform ? `transform="${transform}"` : ''}>
      <rect
        x="${card.x.toFixed(1)}"
        y="${card.y.toFixed(1)}"
        width="${card.width}"
        height="${card.height}"
        rx="4"
        fill="#1a1a2e"
        stroke="#7c3aed"
        stroke-width="2"
        opacity="0.9"
      />
      <text
        x="${(card.x + card.width / 2).toFixed(1)}"
        y="${(card.y + card.height / 2).toFixed(1)}"
        text-anchor="middle"
        dominant-baseline="middle"
        fill="#a78bfa"
        font-size="20"
        font-weight="600"
        font-family="system-ui, -apple-system, sans-serif"
      >${card.number}</text>
    </g>`;
  }).join('\n');

  return `<?xml version="1.0" encoding="UTF-8"?>
<svg
  viewBox="0 0 ${viewBoxWidth} ${viewBoxHeight}"
  xmlns="http://www.w3.org/2000/svg"
>
  <defs>
    <style>
      text { pointer-events: none; }
    </style>
  </defs>

  <!-- Background (transparent) -->
  <rect width="${viewBoxWidth}" height="${viewBoxHeight}" fill="transparent"/>

  <!-- Cards -->
  ${svgCards}
</svg>`;
}

/**
 * Generate optimized SVG (minified)
 */
function minifySVG(svg: string): string {
  return svg
    .replace(/\n\s+/g, '') // Remove newlines and indentation
    .replace(/<!--.*?-->/g, '') // Remove comments
    .replace(/\s{2,}/g, ' ') // Replace multiple spaces with single space
    .trim();
}

/**
 * Main execution
 */
async function main() {
  console.log('🎴 Generating SVG visualizations for all spreads...\n');

  const outputDir = path.join(__dirname, 'public', 'spreads');

  // Create output directory if it doesn't exist
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  // Generate SVG for each spread
  const results: Record<string, { svg: string; minified: string; size: number; minifiedSize: number }> = {};

  for (const spread of SPREADS) {
    const svg = generateSpreadSVG(spread);
    const minified = minifySVG(svg);

    // Save both versions
    const svgPath = path.join(outputDir, `${spread.id}.svg`);
    const minPath = path.join(outputDir, `${spread.id}.min.svg`);

    fs.writeFileSync(svgPath, svg);
    fs.writeFileSync(minPath, minified);

    results[spread.id] = {
      svg,
      minified,
      size: Buffer.byteLength(svg),
      minifiedSize: Buffer.byteLength(minified),
    };

    const reduction = ((1 - results[spread.id].minifiedSize / results[spread.id].size) * 100).toFixed(1);
    console.log(`✅ ${spread.id.padEnd(25)} | ${spread.cardCount} cards | ${results[spread.id].minifiedSize.toString().padStart(4)} bytes (${reduction}% smaller)`);
  }

  // Generate index/manifest
  const manifest = {
    generated: new Date().toISOString(),
    totalSpreads: SPREADS.length,
    spreads: SPREADS.map(s => ({
      id: s.id,
      name: s.name,
      cardCount: s.cardCount,
      aspectRatio: s.layoutAspectRatio,
      svgUrl: `/spreads/${s.id}.min.svg`,
    })),
  };

  fs.writeFileSync(
    path.join(outputDir, 'manifest.json'),
    JSON.stringify(manifest, null, 2)
  );

  console.log(`\n✨ Generated ${SPREADS.length} spread visualizations`);
  console.log(`📁 Output: ${outputDir}`);
  console.log(`📄 Manifest: ${path.join(outputDir, 'manifest.json')}`);
}

main().catch(console.error);
