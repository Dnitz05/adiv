// Supabase Edge Function: Generate Daily Lunar Insight
// Runs daily at 00:00 UTC to generate AI-powered lunar guidance

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3';
import { calculateLunarPhase, getLunarPhaseId, getZodiacSign, getElementFromZodiac } from './lunar-calculator.ts';
import { generateInsightWithAI } from './openai-generator.ts';

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
  universal_insight: Record<string, string>;
  specific_insight: Record<string, string>;
  generation_model: string;
  generation_cost: number;
  is_special_event: boolean;
  special_event_type: string | null;
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

    // Step 3: Check for special astronomical events
    // (For now, just detect full/new moon, can expand later)
    const isSpecialEvent = phaseId === 'new_moon' || phaseId === 'full_moon';
    const specialEventType = isSpecialEvent ? `${phaseId} in ${zodiacSign}` : null;

    // Step 4: Generate AI insights
    const aiResult = await generateInsightWithAI({
      date: targetDate,
      phaseId,
      zodiacSign,
      element,
      lunarAge: lunarData.age,
      illumination: lunarData.illumination,
      template: selectedTemplate,
      isSpecialEvent,
      specialEventType,
    });

    // Step 5: Save to database
    const insightData: DailyLunarInsight = {
      date: dateString,
      phase_id: phaseId,
      zodiac_sign: zodiacSign,
      element: element,
      lunar_age: lunarData.age,
      illumination: lunarData.illumination,
      universal_insight: aiResult.universal_insight,
      specific_insight: aiResult.specific_insight,
      generation_model: aiResult.model,
      generation_cost: aiResult.cost,
      is_special_event: isSpecialEvent,
      special_event_type: specialEventType,
    };

    const { data: savedInsight, error: saveError } = await supabase
      .from('daily_lunar_insights')
      .upsert(insightData, { onConflict: 'date' })
      .select()
      .single();

    if (saveError) {
      throw new Error(`Failed to save insight: ${saveError.message}`);
    }

    console.log(`Successfully generated and saved insight for ${dateString}`);

    return new Response(
      JSON.stringify({
        success: true,
        date: dateString,
        insight: savedInsight,
        cost: aiResult.cost,
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
