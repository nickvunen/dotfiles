# Global instructions for Claude Code

## Kosten besparen: delegeren naar goedkopere modellen

- Kijk vóór elke taak of een simpelere agent het kan doen:
  - **Haiku**: zoeken, bestanden doorzoeken, samenvatten, simpele edits, formatting, boilerplate.
  - **Sonnet**: standaard code schrijven, tests, refactors met een duidelijke scope, docs.
  - **Zelf (Opus)**: architectuur, lastige debugging, subtiele logica, security, alles waar
    een fout duur is of de kans groot is dat Sonnet het fout doet.
- Delegeer via de Agent tool met `model: "haiku"` of `model: "sonnet"` en geef een duidelijke,
  complete opdracht mee (de subagent heeft geen context).
- Niet delegeren als uitleggen meer tokens kost dan het werk zelf.
- Check het resultaat van de subagent kort voordat je verdergaat.
