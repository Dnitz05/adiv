// Supabase Edge Function: Generate Daily Lunar Insight
// Runs daily at 00:00 UTC to compose modular lunar guidance
// ZERO external API cost - uses pre-written seasonal content

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3';
import { calculateLunarPhase, getLunarPhaseId, getZodiacSign, getElementFromZodiac } from './lunar-calculator.ts';
import { composeGuide } from './content-composer.ts';

const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
const supabase = createClient(supabaseUrl, supabaseServiceKey);

interface LunarGuideTemplate {
  id: string;
  phase_id: string;
  element: string | null;
  zodiac_sign: string | null;
  headline: Record<string, string>;
  tagline: Record<string, string> | null;
  focus_areas: Record<string, string[]>;
  energy_description: Record<string, string>;
  recommended_actions: Record<string, string[]>;
  priority: number;
  active: boolean;
}

interface DailyLunarInsight {
  date: string;
  phase_id: string;
  zodiac_sign: string;
  element: string;
  lunar_age: number;
  illumination: number;
  template_id: string;
  composed_headline: Record<string, string>;
  composed_description: Record<string, string>;
  composed_guidance: Record<string, string>;
  focus_areas: Record<string, string[]>;
  recommended_actions: Record<string, string[]>;
  seasonal_overlay_id: string | null;
  weekday: string;
  special_event_ids: string[];
  composed_at: string;
  composition_version: string;
}

serve(async (req) => {
  try {
    // Allow manual trigger with date parameter, otherwise use today
    const url = new URL(req.url);
    const targetDateParam = url.searchParams.get('date');
    const targetDate = targetDateParam ? new Date(targetDateParam) : new Date();
    const dateString = targetDate.toISOString().split('T')[0];

    console.log(`Generating lunar insight for ${dateString}`);

    // Step 1: Calculate lunar data for the target date
    const lunarData = calculateLunarPhase(targetDate);
    const phaseId = getLunarPhaseId(lunarData.phase);
    const zodiacSign = getZodiacSign(targetDate);
    const element = getElementFromZodiac(zodiacSign);

    console.log(`Lunar data: phase=${phaseId}, zodiac=${zodiacSign}, element=${element}`);
    console.log(`Lunar age: ${lunarData.age.toFixed(2)} days, illumination: ${lunarData.illumination.toFixed(2)}%`);

    // Step 2: Find the most specific matching template
    // Priority: zodiac-specific (2) > element-specific (1) > generic (0)
    const { data: templates, error: templateError } = await supabase
      .from('lunar_guide_templates')
      .select('*')
      .eq('phase_id', phaseId)
      .eq('active', true)
      .order('priority', { ascending: false })
      .limit(10);

    if (templateError || !templates || templates.length === 0) {
      throw new Error(`No templates found for phase ${phaseId}: ${templateError?.message}`);
    }

    // Find best matching template: zodiac > element > generic
    let selectedTemplate: LunarGuideTemplate | null = null;

    // Try zodiac-specific first
    selectedTemplate = templates.find(t => t.zodiac_sign === zodiacSign) || null;

    // If not found, try element-specific
    if (!selectedTemplate) {
      selectedTemplate = templates.find(t => t.element === element && !t.zodiac_sign) || null;
    }

    // If still not found, use generic (no element, no zodiac)
    if (!selectedTemplate) {
      selectedTemplate = templates.find(t => !t.element && !t.zodiac_sign) || null;
    }

    if (!selectedTemplate) {
      throw new Error(`Could not find suitable template for ${phaseId}`);
    }

    console.log(`Using template: ${selectedTemplate.id} (priority: ${selectedTemplate.priority})`);

    // Step 3: Compose modular content (base + seasonal + weekday + events)
    const composedGuide = await composeGuide({
      date: targetDate,
      phaseId,
      zodiacSign,
      element,
      lunarAge: lunarData.age,
      illumination: lunarData.illumination,
      template: selectedTemplate,
    });

    console.log(`Composed guide with: season overlay=${!!composedGuide.seasonal_overlay_id}, weekday=${composedGuide.weekday}, events=${composedGuide.special_event_ids.length}`);

    // Step 4: Save to database
    const insightData: DailyLunarInsight = {
      date: dateString,
      phase_id: phaseId,
      zodiac_sign: zodiacSign,
      element: element,
      lunar_age: lunarData.age,
      illumination: lunarData.illumination,
      template_id: selectedTemplate.id,
      composed_headline: composedGuide.composed_headline,
      composed_description: composedGuide.composed_description,
      composed_guidance: composedGuide.composed_guidance,
      focus_areas: composedGuide.focus_areas,
      recommended_actions: composedGuide.recommended_actions,
      seasonal_overlay_id: composedGuide.seasonal_overlay_id,
      weekday: composedGuide.weekday,
      special_event_ids: composedGuide.special_event_ids,
      composed_at: new Date().toISOString(),
      composition_version: composedGuide.composition_version,
    };

    const { data: savedInsight, error: saveError } = await supabase
      .from('daily_lunar_insights')
      .upsert(insightData, { onConflict: 'date' })
      .select()
      .single();

    if (saveError) {
      throw new Error(`Failed to save insight: ${saveError.message}`);
    }

    console.log(`✅ Successfully composed and saved insight for ${dateString} (ZERO cost)`);

    return new Response(
      JSON.stringify({
        success: true,
        date: dateString,
        insight: savedInsight,
        composition: {
          version: composedGuide.composition_version,
          seasonal_overlay: !!composedGuide.seasonal_overlay_id,
          weekday: composedGuide.weekday,
          special_events: composedGuide.special_event_ids.length,
        },
        cost: 0, // ZERO external API cost!
      }),
      {
        headers: { 'Content-Type': 'application/json' },
        status: 200,
      }
    );

  } catch (error) {
    console.error('Error generating daily lunar insight:', error);
    return new Response(
      JSON.stringify({
        success: false,
        error: error.message,
      }),
      {
        headers: { 'Content-Type': 'application/json' },
        status: 500,
      }
    );
  }
});
