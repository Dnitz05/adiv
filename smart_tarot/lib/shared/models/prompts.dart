// Prompt templates for all three divination techniques

class PromptTemplates {
  // Common system prompt for all techniques
  static String getSystemPrompt(String locale) {
    final prompts = {
      'ca': '''Ets un conseller respectuós i sobri especialitzat en arts divinatòries. 
Guia l'usuari amb preguntes curtes i mantén el misticisme sense dogma. 
Usa els resultats de les eines tal qual sense inventar tirades.
Sigues concret, empàtic i amb to amable. Ofereix sempre un resum accionable al final.
No facis prediccions absolutes, ofereix orientació per a la reflexió i el creixement personal.''',
      
      'es': '''Eres un consejero respetuoso y sobrio especializado en artes adivinatorias.
Guía al usuario con preguntas cortas y mantén el misticismo sin dogma.
Usa los resultados de las herramientas tal cual sin inventar tiradas.
Sé concreto, empático y con tono amable. Ofrece siempre un resumen accionable al final.
No hagas predicciones absolutas, ofrece orientación para la reflexión y el crecimiento personal.''',
      
      'en': '''You are a respectful and thoughtful counselor specialized in divination arts.
Guide the user with short questions and maintain mysticism without dogma.
Use the tool results exactly as given without inventing readings.
Be concrete, empathetic and with a kind tone. Always offer an actionable summary at the end.
Don't make absolute predictions, offer guidance for reflection and personal growth.''',
    };
    
    return prompts[locale] ?? prompts['en']!;
  }

  // Tarot reading prompt
  static String getTarotPrompt(String locale, List<Map<String, dynamic>> cards, String? topic, String spreadName) {
    final basePrompts = {
      'ca': '''Tirada de Tarot: {{spread_name}}
Cartes obtingudes: {{cards_json}}
${topic != null ? 'Tema consultat: $topic' : 'Consulta general'}

Per a cada carta en la seva posició:
1. Símbol i significat principal
2. Lectura específica vinculada ${topic != null ? 'al tema' : 'a la situació actual'}
3. Risc o ombra a considerar
4. Acció concreta recomanada

Tanca amb:
- "Senyal fort": el missatge més important
- "Advertència": el que s'ha d'evitar
- "Pas següent en 48h": acció concreta i immediata''',

      'es': '''Tirada de Tarot: {{spread_name}}
Cartas obtenidas: {{cards_json}}
${topic != null ? 'Tema consultado: $topic' : 'Consulta general'}

Para cada carta en su posición:
1. Símbolo y significado principal
2. Lectura específica vinculada ${topic != null ? 'al tema' : 'a la situación actual'}
3. Riesgo o sombra a considerar
4. Acción concreta recomendada

Cierra con:
- "Señal fuerte": el mensaje más importante
- "Advertencia": lo que se debe evitar
- "Paso siguiente en 48h": acción concreta e inmediata''',

      'en': '''Tarot Reading: {{spread_name}}
Cards drawn: {{cards_json}}
${topic != null ? 'Topic consulted: $topic' : 'General consultation'}

For each card in its position:
1. Symbol and main meaning
2. Specific reading linked ${topic != null ? 'to the topic' : 'to the current situation'}
3. Risk or shadow to consider
4. Concrete recommended action

Close with:
- "Strong signal": the most important message
- "Warning": what should be avoided
- "Next step in 48h": concrete and immediate action''',
    };

    return basePrompts[locale]!
        .replaceAll('{{spread_name}}', spreadName)
        .replaceAll('{{cards_json}}', _formatCards(cards, locale));
  }

  // I Ching reading prompt
  static String getIChingPrompt(String locale, Map<String, dynamic> result, String? topic) {
    final lines = List<int>.from(result['lines']);
    final primaryHex = result['primary_hex'] as int;
    final changingLines = List<int>.from(result['changing_lines']);
    final resultHex = result['result_hex'] as int?;

    final basePrompts = {
      'ca': '''Consulta I Ching:
Línies obtingudes: $lines
Hexagrama Primari: $primaryHex (proporciona Judici + Imatge)
${changingLines.isNotEmpty ? 'Línies Mutables: $changingLines' : 'Sense línies mutables'}
${resultHex != null ? 'Hexagrama Resultant: $resultHex' : ''}
${topic != null ? 'Tema consultat: $topic' : 'Consulta general'}

Destil·la en 3 consells pràctics (no moralitzis):
1. Situació actual i les seves forces
2. Acció recomanada per al creixement
3. Resultat probable si segueixes el consell

${changingLines.isNotEmpty ? 'Explica el trànsit de transformació en una frase clara.' : ''}

Finalitza amb una pregunta que mogui l'usuari a l'acció.''',

      'es': '''Consulta I Ching:
Líneas obtenidas: $lines
Hexagrama Primario: $primaryHex (proporciona Juicio + Imagen)
${changingLines.isNotEmpty ? 'Líneas Mutables: $changingLines' : 'Sin líneas mutables'}
${resultHex != null ? 'Hexagrama Resultante: $resultHex' : ''}
${topic != null ? 'Tema consultado: $topic' : 'Consulta general'}

Destila en 3 consejos prácticos (no moralices):
1. Situación actual y sus fuerzas
2. Acción recomendada para el crecimiento
3. Resultado probable si sigues el consejo

${changingLines.isNotEmpty ? 'Explica el tránsito de transformación en una frase clara.' : ''}

Finaliza con una pregunta que mueva al usuario a la acción.''',

      'en': '''I Ching Consultation:
Lines obtained: $lines
Primary Hexagram: $primaryHex (provides Judgment + Image)
${changingLines.isNotEmpty ? 'Changing Lines: $changingLines' : 'No changing lines'}
${resultHex != null ? 'Resulting Hexagram: $resultHex' : ''}
${topic != null ? 'Topic consulted: $topic' : 'General consultation'}

Distill into 3 practical advice points (don't moralize):
1. Current situation and its forces
2. Recommended action for growth
3. Probable result if you follow the advice

${changingLines.isNotEmpty ? 'Explain the transformation transit in one clear sentence.' : ''}

End with a question that moves the user to action.''',
    };

    return basePrompts[locale] ?? basePrompts['en']!;
  }

  // Runes reading prompt
  static String getRunesPrompt(String locale, List<Map<String, dynamic>> runes, String? topic) {
    final basePrompts = {
      'ca': '''Tirada de Runes:
Runes obtingudes: {{runes_json}}
${topic != null ? 'Tema consultat: $topic' : 'Consulta general'}

Per a cada runa en el seu slot:
- **Situació**: Què revela sobre el moment actual
- **Repte**: Què s'ha de superar o entendre
- **Resultat**: Cap a on apunta l'energia

Si hi ha alguna runa invertida, explica:
- La **limitació** que representa
- Un **antídot** pràctic per superar-la

Tanca amb:
- Un consell ancestral en una frase
- Una acció per connectar amb aquesta saviesa avui''',

      'es': '''Tirada de Runas:
Runas obtenidas: {{runes_json}}
${topic != null ? 'Tema consultado: $topic' : 'Consulta general'}

Para cada runa en su slot:
- **Situación**: Qué revela sobre el momento actual
- **Desafío**: Qué se debe superar o entender
- **Resultado**: Hacia dónde apunta la energía

Si hay alguna runa invertida, explica:
- La **limitación** que representa
- Un **antídoto** práctico para superarla

Cierra con:
- Un consejo ancestral en una frase
- Una acción para conectar con esta sabiduría hoy''',

      'en': '''Runes Reading:
Runes drawn: {{runes_json}}
${topic != null ? 'Topic consulted: $topic' : 'General consultation'}

For each rune in its slot:
- **Situation**: What it reveals about the current moment
- **Challenge**: What must be overcome or understood
- **Result**: Where the energy is pointing

If there's any reversed rune, explain:
- The **limitation** it represents
- A practical **antidote** to overcome it

Close with:
- An ancestral advice in one sentence
- An action to connect with this wisdom today''',
    };

    return basePrompts[locale]!
        .replaceAll('{{runes_json}}', _formatRunes(runes, locale));
  }

  // Helper methods for formatting
  static String _formatCards(List<Map<String, dynamic>> cards, String locale) {
    return cards.map((card) {
      final upright = card['upright'] as bool;
      final orientation = {
        'ca': upright ? 'dreta' : 'invertida',
        'es': upright ? 'derecha' : 'invertida', 
        'en': upright ? 'upright' : 'reversed',
      };
      
      return '${card['position']}. ${card['id']} (${orientation[locale]})';
    }).join('\n');
  }

  static String _formatRunes(List<Map<String, dynamic>> runes, String locale) {
    return runes.map((rune) {
      final upright = rune['upright'] as bool;
      final orientation = {
        'ca': upright ? 'dreta' : 'invertida',
        'es': upright ? 'derecha' : 'invertida',
        'en': upright ? 'upright' : 'reversed',
      };
      
      return '${rune['slot']}: ${rune['id']} (${orientation[locale]})';
    }).join('\n');
  }

  // Follow-up question templates
  static String getFollowUpQuestion(String locale, String technique) {
    final questions = {
      'tarot': {
        'ca': 'Quina de aquestes cartes ressona més amb la teva situació actual?',
        'es': '¿Cuál de estas cartas resuena más con tu situación actual?',
        'en': 'Which of these cards resonates most with your current situation?',
      },
      'iching': {
        'ca': 'Com pots aplicar aquest consell en la teva vida quotidiana?',
        'es': '¿Cómo puedes aplicar este consejo en tu vida cotidiana?',
        'en': 'How can you apply this advice in your daily life?',
      },
      'runes': {
        'ca': 'Quina acció concreta faràs avui per honrar aquesta saviesa?',
        'es': '¿Qué acción concreta harás hoy para honrar esta sabiduría?',
        'en': 'What concrete action will you take today to honor this wisdom?',
      },
    };

    return questions[technique]?[locale] ?? questions[technique]?['en'] ?? '';
  }

  // Summary templates
  static String getSummaryTemplate(String locale) {
    final templates = {
      'ca': '''## Resum de la sessió

**Tècnica:** {{technique}}
**Tema:** {{topic}}
**Missatge clau:** {{key_message}}

**Accions recomanades:**
{{actions}}

**Recordatori:** Aquesta orientació és per a la reflexió personal. Confia en la teva intuïció per aplicar-la.''',

      'es': '''## Resumen de la sesión

**Técnica:** {{technique}}
**Tema:** {{topic}}
**Mensaje clave:** {{key_message}}

**Acciones recomendadas:**
{{actions}}

**Recordatorio:** Esta orientación es para la reflexión personal. Confía en tu intuición para aplicarla.''',

      'en': '''## Session Summary

**Technique:** {{technique}}
**Topic:** {{topic}}
**Key Message:** {{key_message}}

**Recommended Actions:**
{{actions}}

**Reminder:** This guidance is for personal reflection. Trust your intuition to apply it.''',
    };

    return templates[locale] ?? templates['en']!;
  }
}