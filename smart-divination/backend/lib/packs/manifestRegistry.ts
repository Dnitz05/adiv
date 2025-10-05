import { createHash } from 'crypto';

import rawManifests from '../../data/packs/manifests.json';

export interface PackManifestDefinition {
  id: string;
  name: string;
  description: string;
  version: string;
  technique: 'tarot' | 'iching' | 'runes';
  author: string;
  license: string;
  created_at: string;
  updated_at: string;
  languages: string[];
  content: {
    cards: number;
    hexagrams: number;
    runes: number;
    spreads: string[];
  };
  assets: {
    images: {
      format: string;
      resolution: string;
      count: number;
    };
    audio?: {
      format: string;
      count: number;
    };
  };
  compatibility: {
    min_app_version: string;
    supported_platforms: string[];
  };
  premium_required: boolean;
  required_entitlements: string[];
  distribution: {
    uri: string;
    format: string;
    size: number;
  };
}

export interface PackManifest extends PackManifestDefinition {
  checksum: string;
}

export interface ManifestValidationIssue {
  packId: string;
  message: string;
  severity: 'error' | 'warn';
}

const manifests = rawManifests as PackManifestDefinition[];

function canonicalize(value: unknown): unknown {
  if (Array.isArray(value)) {
    return value.map((entry) => canonicalize(entry));
  }
  if (value && typeof value === 'object') {
    const entries = Object.entries(value as Record<string, unknown>).sort(([a], [b]) =>
      a.localeCompare(b)
    );
    return entries.reduce<Record<string, unknown>>((acc, [key, val]) => {
      acc[key] = canonicalize(val);
      return acc;
    }, {});
  }
  return value;
}

function computeChecksum(definition: PackManifestDefinition): string {
  const canonical = canonicalize(definition);
  const json = JSON.stringify(canonical);
  const hash = createHash('sha256').update(json).digest('hex');
  return `sha256:${hash}`;
}

function isSemverLike(version: string): boolean {
  return /^\d+\.\d+\.\d+$/.test(version);
}

function validateDefinition(definition: PackManifestDefinition): ManifestValidationIssue[] {
  const issues: ManifestValidationIssue[] = [];
  if (!isSemverLike(definition.version)) {
    issues.push({
      packId: definition.id,
      message: `version ${definition.version} is not semver`,
      severity: 'error',
    });
  }
  if (!definition.languages.length) {
    issues.push({ packId: definition.id, message: 'languages array is empty', severity: 'warn' });
  }
  if (!definition.distribution.uri.startsWith('https://')) {
    issues.push({
      packId: definition.id,
      message: 'distribution.uri must be https',
      severity: 'error',
    });
  }
  if (definition.premium_required && !definition.required_entitlements.includes('premium')) {
    issues.push({
      packId: definition.id,
      message: 'premium packs must include "premium" in required_entitlements',
      severity: 'error',
    });
  }
  if (!definition.premium_required && definition.required_entitlements.includes('premium')) {
    issues.push({
      packId: definition.id,
      message: 'non-premium packs cannot require the premium entitlement',
      severity: 'error',
    });
  }
  if (definition.required_entitlements.some((entitlement) => entitlement.includes(' '))) {
    issues.push({
      packId: definition.id,
      message: 'entitlements must not include whitespace',
      severity: 'error',
    });
  }
  return issues;
}

const manifestMap = new Map<string, PackManifest>();
const validationIssues: ManifestValidationIssue[] = [];

for (const definition of manifests) {
  if (manifestMap.has(definition.id)) {
    validationIssues.push({
      packId: definition.id,
      message: 'duplicate pack id detected',
      severity: 'error',
    });
    continue;
  }
  validationIssues.push(...validateDefinition(definition));
  const checksum = computeChecksum(definition);
  manifestMap.set(definition.id, { ...definition, checksum });
}

if (process.env.NODE_ENV !== 'production') {
  const errors = validationIssues.filter((issue) => issue.severity === 'error');
  if (errors.length > 0) {
    const messages = errors.map((issue) => `${issue.packId}: ${issue.message}`).join('\n');
    throw new Error(`Pack manifest validation failed:\n${messages}`);
  }
}

export function getPackManifest(packId: string): PackManifest | null {
  return manifestMap.get(packId) ?? null;
}

export function listPackManifests(): PackManifest[] {
  return Array.from(manifestMap.values());
}

export function verifyChecksum(manifest: PackManifest): boolean {
  const { checksum, ...rest } = manifest;
  return checksum === computeChecksum(rest as PackManifestDefinition);
}

export function collectManifestValidationIssues(): ManifestValidationIssue[] {
  return [...validationIssues];
}

export function requiresPremium(manifest: PackManifest): boolean {
  return manifest.premium_required;
}

export function requiredEntitlements(manifest: PackManifest): string[] {
  return manifest.required_entitlements.slice();
}
