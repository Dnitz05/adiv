# AUTHENTICITY POLICY / POLÍTICA D'AUTENTICITAT

## PRINCIPI FONAMENTAL / FUNDAMENTAL PRINCIPLE

**ZERO INVENCIÓ PERSONAL / ZERO PERSONAL INVENTION**

Totes les afirmacions valoratives, interpretacions, rituals, tirades de tarot, i continguts astrològics que apareguin a Smart Divination han d'estar **basats directament en tradicions documentades, escoles establertes o pràctiques recollides**. Cap contingut pot ser inventat o creat personalment sense fonament tradicional.

Every evaluative statement, interpretation, ritual, tarot spread, and astrological content that appears on Smart Divination must be **directly based on documented traditions, established schools, or collected practices**. No content can be invented or personally created without traditional foundation.

---

## ÀREES D'APLICACIÓ / AREAS OF APPLICATION

### 1. TAROT

#### Tirades / Spreads
- **✅ CORRECTE**: Tirades recollides de fonts reconegudes (Biddy Tarot, The Numinous, Wayfinder Tarot, etc.)
- **❌ INCORRECTE**: Inventar posicions de cartes o crear "noves" tirades sense base tradicional

#### Interpretacions de Cartes / Card Interpretations
- **✅ CORRECTE**: Interpretacions basades en tradició Rider-Waite, Marseille, Crowley-Thoth, o altres sistemes documentats
- **❌ INCORRECTE**: Significats inventats o "intuïcions personals" sense referència a escola tradicional

**FONTS RECONEGUDES / RECOGNIZED SOURCES:**
- Biddy Tarot (Brigit Esselmont)
- Rachel Pollack
- Mary K. Greer
- Alejandro Jodorowsky (Marseille)
- Arthur Edward Waite
- Aleister Crowley

---

### 2. ASTROLOGIA / ASTROLOGY

#### Interpretacions Lunars / Lunar Interpretations
- **✅ CORRECTE**: Significats basats en astrologia hel·lenística, védica, o occidental moderna documentada
- **❌ INCORRECTE**: Assignar qualitats als signes lunars sense base astrològica

#### Trànsits i Cicles / Transits and Cycles
- **✅ CORRECTE**: Utilitzar efectes de trànsits documentats per astròlegs professionals
- **❌ INCORRECTE**: Inventar efectes de trànsits planetaris

**FONTS RECONEGUDES / RECOGNIZED SOURCES:**
- Astrologia Hel·lenística (Chris Brennan, Demetra George)
- Astrologia Védica/Jyotish (tradició índia)
- Steven Forrest (astrologia evolutiva)
- Liz Greene
- Robert Hand

---

### 3. RITUALS

#### Pràctiques Lunars / Lunar Practices
- **✅ CORRECTE**: Rituals recollits de Wicca, witchcraft tradicional, màgia lunar documentada
- **❌ INCORRECTE**: Inventar rituals sense base en tradició espiritual

**TRADICIONS RECONEGUDES / RECOGNIZED TRADITIONS:**
- Wicca (Gerald Gardner, Doreen Valiente, Scott Cunningham)
- Witchcraft tradicional / Traditional Witchcraft
- Màgia ceremonial / Ceremonial Magic (Golden Dawn, Thelema)
- Pràctiques indígenes documentades / Documented indigenous practices

**EXEMPLES DE RITUALS VÀLIDS / EXAMPLES OF VALID RITUALS:**
- Aigua lunar (moon water) - pràctica molt antiga i documentada
- Càrrega de cristalls sota lluna plena - tradició establerta
- Alliberament amb foc a lluna plena - ritual wicca tradicional
- Tall de cordons energètics - pràctica documentada en energia work
- Banys rituals de purificació - pràctiques ancestrals diverses tradicions

---

### 4. WIDGETS I CONTINGUTS / WIDGETS AND CONTENT

#### Descripcions de Fases Lunars / Lunar Phase Descriptions
- **✅ CORRECTE**: "La lluna nova és temps de nous començaments (tradició wicca/witchcraft)"
- **❌ INCORRECTE**: "La lluna nova et dóna superpoders psíquics"

#### Consells i Guies / Advice and Guidance
- **✅ CORRECTE**: "Segons l'astrologia tradicional, la lluna en Càncer afavoreix..."
- **❌ INCORRECTE**: Donar consells sense especificar la base tradicional

---

## IMPLEMENTACIÓ TÈCNICA / TECHNICAL IMPLEMENTATION

### Models de Dades / Data Models

Tots els models han d'incloure camps per a **atribució de font / source attribution**:

```dart
class LunarSpread {
  final String sourceEn; // Ex: "Source: Biddy Tarot (Brigit Esselmont)"
  final String sourceEs; // Ex: "Fuente: Biddy Tarot (Brigit Esselmont)"
  final String sourceCa; // Ex: "Font: Biddy Tarot (Brigit Esselmont)"
  final String sourceUrl; // Ex: "https://www.biddytarot.com/..."
}
```

### API Endpoints

Quan es generin interpretacions amb IA (Gemini, GPT), el prompt ha d'incloure:

```
"Base your interpretation ONLY on traditional tarot/astrological knowledge.
Reference specific schools or traditions (Rider-Waite, Hellenistic astrology, Wicca, etc.).
Never invent meanings or make unsupported claims."
```

---

## EXCEPCIONS / EXCEPTIONS

### Quan És Acceptable la Creativitat / When Creativity Is Acceptable

1. **Presentació visual / Visual presentation**: Colors, dissenys, UX
2. **Estructures de widget / Widget structures**: Com organitzem la informació
3. **Formulació de preguntes / Question phrasing**: Com preguntem, sempre que la base sigui tradicional

### Quan NO És Acceptable / When It Is NOT Acceptable

1. **Significats de cartes de tarot / Tarot card meanings**
2. **Efectes astrològics / Astrological effects**
3. **Propietats de rituals / Ritual properties**
4. **Interpretacions espirituals / Spiritual interpretations**

---

## VERIFICACIÓ I QUALITAT / VERIFICATION AND QUALITY

### Checklist Per a Nou Contingut / Checklist for New Content

Abans d'afegir qualsevol contingut, verificar:

- [ ] Té una font documentada?
- [ ] La font és reconeguda en la comunitat?
- [ ] Les afirmacions són consistents amb la tradició citada?
- [ ] S'ha atribuït correctament la font?
- [ ] Les traduccions mantenen la integritat del contingut original?

### Fonts a Consultar / Sources to Consult

**Tarot:**
- Biddy Tarot: https://www.biddytarot.com
- Labyrinthos: https://labyrinthos.co
- The Tarot Lady: https://www.thetarotlady.com

**Astrologia / Astrology:**
- Astro.com
- The Astrology Podcast (Chris Brennan)
- Astrology University

**Rituals / Rituals:**
- The Witch of Wonderlust
- The Numinous
- Scott Cunningham's books
- Silver RavenWolf's works

---

## MANTENIMENT / MAINTENANCE

Aquest document ha de ser revisat i actualitzat cada cop que:
- S'afegeixi un nou tipus de contingut
- Es descobreixin noves fonts autoritzades
- Es rebin comentaris d'usuaris sobre autenticitat

**Última actualització / Last updated:** 2025-11-07

**Responsabilitat / Responsibility:** Tot el equip de desenvolupament ha de conèixer i seguir aquesta política.

---

## CONTACTE / CONTACT

Si tens dubtes sobre l'autenticitat d'un contingut o vols suggerir noves fonts autoritzades, consulta amb l'equip de contingut abans de procedir.

**Principi rector / Guiding principle:**
> "Respectem les tradicions que portem milions d'anys evolucionant. La nostra creativitat està en com les presentem, no en modificar-les."
>
> "We respect traditions that have been evolving for millennia. Our creativity is in how we present them, not in modifying them."
