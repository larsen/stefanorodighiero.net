---
title: Pocket Perl - Strutture complesse e subroutine
---

## Approfondimenti

## Errata corrige

Mi è stato fatto notare che l'iilustrazione di pag. 69 non rispetta le
convenzioni grafiche usate fino a quel punto per rappresentare
strutture dati. Dalla figura pubblicata nel libro sembra che i valori
associati alle chiavi ``nome`` e ``cognome`` siano riferimenti a valori
scalari. Una rappresentazione più chiara e corretta avrebbe dovuto
essere quella di seguito:

![](/images/pocketperl/aoa.png)

**Pag. 71**

Alla fine del suggerimento: *"[...] HASH per i riferimenti ad
hash e CODE i riferimenti a subroutine."* dovrebbe essere: *"[...]
HASH per i riferimenti ad hash e CODE per i riferimenti a
subroutine."*

**Pag. 74**

In mezzo alla pagina: *"[...] ``$bar`` invece ha invece mantenuto
le modifiche avvenute all'interno del blocco [...]"* dovrebbe essere:
*"[...] ``$bar`` ha invece mantenuto le modifiche avvenute all'interno del
blocco [...]"*

**Pag. 75**

Nell'esempio in fondo alla pagina viene dichiarata la
subroutine ``double()`` per poi essere utilizzata con il nome di
``raddoppia()``, l'ultima riga dovrebbe quindi essere: 

````perl
say double( 10 );
````

**Pag. 76**

Verso il fondo della pagina *"il comma operator
documentazione"* dovrebbe essere *"il comma operator nella
documentazione"*

**Pag. 77**

Nell'esempio di codice riportato il nome della subroutine
implementata non coincide con quello della subroutine chiamata. Le
ultime due righe di codice dovrebbero pertanto essere:

````perl
my @lista  = applause( ‘Clap’, 2 ); 
my $string = applause( ‘Clap’, 2 );
````

**Pag. 79**

Nel codice dell'esempio a fondo pagina, la seconda riga della
subroutine load_user_profile dovrebbe essere:

````perl
my $username = $params{username};
````