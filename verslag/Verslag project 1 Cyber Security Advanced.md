
_Door Niels Van De Ginste en Tom Goedemé_

## Inleiding

In dit verslag wordt een gedetailleerde beschrijving gegeven over het eerste project voor het vak Cyber Security Advanced. Voor dit project hebben we een secure pipeline project opgesteld dat verscheidene veiligheidsscans uitvoert op de code van een open source project. Uiteraard gaan wij ook de nodige best practices uitvoeren om onze eigen pipeline zo veilig mogelijk te gebruiken.

Het project waar wij voor hebben gekozen heet [Bepasty](https://github.com/bepasty/bepasty-server). Dit is een pastebin geschreven in Python. Op deze code gaan dus verschillende checks uitgevoerd wo

## Threat model

### Beschrijving

![](Threat%20model.png)

Hierboven zit u het threat model van onze pipeline. De pipeline bevat de verschillende stappen beginnend bij de developer die code pusht naar de repositoery tot aan het continue draaien van ons programma. Bij de verschillende fasen en hun overgangen kunnen eventueel één of meerdere zwakheden dreiging aanwezig zijn. Deze staan hieronder beschrijven, maar eerst wordt elke fase kort toegelicht:

- Source: de source repository met de code van het open source project en onze pipeline.yml.
- Build:  de fase waar de code wordt gebouwd tot een werkend product.
- Test: Het werkend product wordt getest op eventuele zwakheden of onverwacht gedrag.
- Release: Een definitieve versie wordt gepusht naar de officiële python repository pypi.
- operate: Het product blijft voor langere tijd actief. Al dan niet gebruikt door een klant of een developer.

### Toelichting zwakheden

Nu elk onderdeel is besproken, worden de verschillende zwakheden ook even kort toegelicht, opgesplitst volgens de fase waarin deze kunnen voorkomen. De zwakheden die in het **vetgedrukt** staan, proberen wij op een bepaalde manier op te lossen. Dit kan zijn met behulp van veiligheidsscans in onze pipeline of algemene best practices.

#### Developer ==> Source

- **T01**: Tijdens een push zou de mogelijkheid bestaan dat een aanvaller de code van de developer onderschept en wijzigt, waardoor er (malafide) aangepaste code staat in de source repo.
- **T02**: De developer kan per ongeluk zelf zwakheden introduceren, doordat slechte code wordt toegevoegd aan de repo.
- T03: _geen idee_

#### Source

- **T04**: De kans bestaat dan een gebruiker toegang krijgt tot de repository met de code. Dit kan bijvoorbeeld gebeuren door nalatig gebruik van credentials.

#### Source ==> Build

- T05: Een aanvaller zou juist voorde built van de code de buildsource veranderen. Op deze manier worden anders bestanden gebruikt tijdens de bouw, wat kan leiden tot zwakheden.
- T06: Wanneer de code eerder werd veranderd in de source repo, betekent dit dat er zwakheden kunnen optreden wanneer de aangepaste code wordt uitgevoerd.
- T07: Github maakt gebruik van caching om performanter te zijn tijdens herhaaldeijke builds.

#### Build

- T08: Een aanvaller kan ongeautoriseerde builds uitvoeren mocht hij toegang gekregen hebben tot de build.
- **T09**: Wanneer er tijdens de build libraries worden gebruikt met zwakheden in, dan is het gebouwde product zelf ook kwetsbaar.

#### Test

- **T10**: Testen van code is een belangrijke taak die grondig uitgevoerd moet worden. Wanneer er niet me aandacht wordt getest, kunnen fouten onder de rader blijven en verder in de release fase geraken.
- **T11**: Vaak worden ook geautomatiseerde tests uitgevoerd zoals in een pipeline. Echter kan men vergeten om een blockade te starten wanneer fouten worden gevonden. Indien dit niet wordt gedaan, geraken bugs of sensitieve data alsnog in productieomgevingen ook al zijn deze wel gedetecteerd geweest.

### Test ==> Release

- T12: Het risico bestaat dat tijdens de upload van een bepaalde package naar pypi, deze package wordt opgevangen en aangepast.

#### Release

- **T13**: Wanneer tijdens de development nalatig is omgegaan met credentials in de source code, worden deze credentials publiek beschikbaar gemaakt door de release.
- T14: Wanneer een aanvaller toegang heeft tot de repository van het project, kunnen er ongeautoriseerde releases uitgebracht worden met malafide code.

#### Release ==> Operate

- T15: Wanneer de release repository (pypi) wordt gecompromised, kunnen hier  malafide versies van pakketten in terecht komen.

#### Operate

- T16: Wanneer onze tool draait voor een langere tijd, kunnen de libraries die worden gebruikt out of date geraken. Daarnaast kunnen zwakheden ontdekt worden die tijdens de release nog niet gekend waren.
