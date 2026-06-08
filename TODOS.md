# TODOs / FIXMEs

## `lib/features/dashboard/widgets/amounts_section.dart:36`
- **Type:** TODO
- **Description:** `"18d"` está hardcodeado como subtítulo de "REMAINING". Debería calcular los días restantes reales del forecast.

## `lib/features/dashboard/widgets/accumulated_section.dart:89`
- **Type:** TODO
- **Description:** Faltan animaciones de carga en la sección de progreso acumulado. El `LinearProgressIndicator` en estado `loading` no tiene transición.

## `lib/features/dashboard/widgets/day_editor_panel.dart:135`
- **Type:** FIX
- **Description:** `signed: true` en el `TextInputType.numberWithOptions` permite valores negativos, pero el `validator` chequea `n < 0`. Se dejó como fix rápido, hay que quitarlo.
