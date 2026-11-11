# Medición de corriente con amplificador de transimpedancia (ADA4505)

Este circuito convierte una corriente desconocida `I2` en una tensión `Vout`. El objetivo es recuperar `I2` a partir de una medición de `Vout`.

## Componentes

| Elemento | Función |
|---|---|
| `U1` (ADA4505) | Amplificador operacional rail-to-rail de micropotencia, configurado como amplificador de transimpedancia (TIA). |
| `R3 = 15 kΩ` | Resistencia de realimentación. Fija la ganancia de transimpedancia. |
| `V2 = 1,2 V` | Tensión de polarización (`Vbias`). Centra la salida dentro del rango de alimentación de 0 a 3,3 V, lo que permite medir corrientes de ambos signos con alimentación simple. |
| `R1 = 120 Ω` | Conecta `Vbias` a la entrada no inversora. Como la corriente de entrada del ADA4505 es del orden de pA, su caída de tensión es despreciable y `V(In+) ≈ Vbias`. |
| `I2` | Corriente a medir. Se inyecta en el nodo `i_probe`, que es la entrada inversora. |
| `C1 = 20 pF` | Carga capacitiva en la salida (modela, por ejemplo, la entrada de un ADC). |
| `V1` | Alimentación de 3,3 V con un rizado de 100 mV a 1 MHz, para evaluar el rechazo a la fuente (PSRR). |

## Derivación

```
        Vbias − Vout
I2  =  ──────────────
             R3
```

Con los valores nominales:

```
I2 = (1,2 V − Vout) / 15 kΩ
```

## Verificación con la simulación `.dc`

En el barrido de `I2` entre −50 µA y +50 µA se obtiene una recta con los siguientes parámetros:

| Parámetro | Teórico | Simulado |
|---|---|---|
| Pendiente `dVout/dI2` | −15 000 V/A | −14 999,97 V/A |
| Intercepto (`I2 = 0`) | 1,2000 V | 1,200493 V |
| `Vout` con `I2 = −50 µA` | 1,9500 V | 1,950491 V |
| `Vout` con `I2 = +50 µA` | 0,4500 V | 0,450494 V |

La ganancia coincide con `R3`. El intercepto difiere en unos 0,49 mV, lo que corresponde al offset de entrada del modelo del amplificador.

### Ecuación calibrada

Para cancelar el offset se usa el intercepto medido en lugar de `Vbias`:

```
I2 = (1,200493 V − Vout) / 14 999,97 Ω
```

Un error de 0,49 mV en `Vout` equivale a un error de unos 33 nA en `I2`. Por eso se recomienda medir el intercepto real (con `I2 = 0`) en cada placa, ya que el offset varía de un dispositivo a otro.

## Rango de operación

La salida está limitada aproximadamente por las alimentaciones (de 0 a 3,3 V, menos el margen de saturación del rail-to-rail). En teoría eso permite:

```
I2_max ≈ Vbias / R3          = 1,2 / 15k        ≈  +80 µA
I2_min ≈ (Vbias − VDD) / R3  = (1,2 − 3,3) / 15k ≈ −140 µA
```

En la práctica el rango es algo menor por la saturación de la salida. El barrido de ±50 µA queda holgadamente dentro de los límites, con `Vout` entre 0,45 V y 1,95 V.

Para ampliar el rango se puede reducir `R3`, a costa de menor sensibilidad. Para hacerlo simétrico se puede llevar `Vbias` a VDD/2 ≈ 1,65 V.

## Error esperado por la tolerancia de 1 % en `R3`

Supóngase que la resistencia real es `R3_real = R3 · (1 + ε)`, con |ε| ≤ 0,01, y que la corriente se calcula con el valor nominal de 15 kΩ. Entonces:

```
Vout        = Vbias − R3·(1 + ε)·I2
I2_calc     = (Vbias − Vout) / R3  =  I2 · (1 + ε)
Error       = I2_calc − I2         =  ε · I2
```

El error es **proporcional**: la tolerancia de `R3` produce un error relativo de **±1 % de la lectura**, sin importar el valor de la corriente. No genera error en `I2 = 0`.

### Error en el peor caso

Se suma el error proporcional de `R3` (±1 % de la lectura) y el error fijo por offset sin calibrar (≈ 0,49 mV / 15 kΩ ≈ 33 nA):

| `I2` real | Desviación de `Vout` por `R3` | Error por `R3` (±1 %) | Error por offset | Error total (peor caso) |
|---|---|---|---|---|
| 1 µA | ±0,15 mV | ±10 nA | 33 nA | ≈ 43 nA (4,3 %) |
| 10 µA | ±1,5 mV | ±100 nA | 33 nA | ≈ 133 nA (1,3 %) |
| 25 µA | ±3,75 mV | ±250 nA | 33 nA | ≈ 283 nA (1,1 %) |
| 50 µA | ±7,5 mV | ±500 nA | 33 nA | ≈ 533 nA (1,07 %) |

Dos conclusiones:

- **Corrientes pequeñas:** domina el offset, que es un error absoluto.
- **Corrientes grandes:** domina la tolerancia de `R3`, y el error total tiende a ±1 %.

Si se calibra el offset (midiendo `Vout` con `I2 = 0`), el error se reduce a ±1 % de la lectura.

### Error estadístico esperado

El ±1 % es una cota, no el error típico. Si el valor de `R3` se distribuye uniformemente dentro de la tolerancia, la desviación estándar del error de ganancia es:

```
σ = 1 % / √3 ≈ 0,58 %
```

En una placa típica, el error esperado ronda el ±0,6 % de la lectura (≈ ±0,29 µA a 50 µA).

## Ejemplo: lectura con `Vout = 1,8 V`

**1. Corriente con valores nominales**

```
I2 = (1,2 V − 1,8 V) / 15 kΩ = −0,6 V / 15 kΩ = −40,00 µA
```

**2. Corriente con la ecuación calibrada (offset corregido)**

```
I2 = (1,200493 V − 1,8 V) / 14 999,97 Ω = −39,97 µA
```

El signo negativo indica que la corriente sale del nodo `i_probe` (sentido opuesto a la flecha de `I2`). Esto concuerda con la simulación: con `I2 = −40 µA` se obtiene `Vout = 1,800492 V`.

**3. Error por la tolerancia de 1 % en `R3`**

```
Error por R3     = ±1 % · 40 µA = ±0,40 µA
```

| Caso | Error | Corriente real |
|---|---|---|
| Offset calibrado, peor caso | ±0,40 µA (±1 %) | −39,57 µA a −40,37 µA |
| Offset sin calibrar, peor caso | ±0,43 µA (±0,40 µA + 33 nA) | −39,57 µA a −40,43 µA |
| Típico (σ ≈ 0,58 %) | ±0,23 µA | −39,74 µA a −40,20 µA |

**Resultado**

```
I2 = −39,97 µA ± 0,40 µA   (peor caso, offset calibrado)
I2 = −39,97 µA ± 0,23 µA   (error típico)
```
