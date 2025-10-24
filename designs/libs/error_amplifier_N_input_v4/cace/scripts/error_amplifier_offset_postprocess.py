# error_amplifier_offset_postprocess.py
import os
import numpy as np
from typing import Any, Dict, List

OFFSET_KEYS = ['Voffset', 'Voffset_mc', 'Voffset_arr', 'Voffset_mV', 'Voffset_mv']

def _pick_first(results: Dict[str, Any], keys: List[str]) -> List[float]:
    for k in keys:
        if k in results:
            return list(results[k])
    return []

def _robust_filter(arr: List[float], low_pct: float = 0.5, high_pct: float = 99.5) -> List[float]:
    if len(arr) == 0:
        return []
    a = np.array(arr, dtype=float)
    low = np.percentile(a, low_pct)
    high = np.percentile(a, high_pct)
    return a[(a >= low) & (a <= high)].tolist()

def _stats(arr: List[float]) -> Dict[str, float]:
    if len(arr) == 0:
        return {"n": 0, "mean": float('nan'), "std": float('nan'),
                "median": float('nan'), "min": float('nan'), "max": float('nan')}
    a = np.array(arr, dtype=float)
    return {"n": int(a.size), "mean": float(a.mean()), "std": float(a.std(ddof=0)),
            "median": float(np.median(a)), "min": float(a.min()), "max": float(a.max())}

def postprocess(results: Dict[str, List[float]], conditions: Dict[str, Any]) -> Dict[str, List[float]]:
    """
    Postprocess para la medición de offset.
    - Devuelve {"Voffset_arr": [...]}
    - Guarda CSV en cace/scripts/error_amplifier_offset.csv
    - Genera histograma en cace/scripts/error_amplifier_offset_hist.png con líneas de mean, ±1σ y ±3σ.
    """

    raw = _pick_first(results, OFFSET_KEYS)
    if not raw:
        print("postprocess: no se encontró ninguna clave de Voffset en results. Claves disponibles:", list(results.keys()))
        out_dir = os.path.join('cace', 'scripts')
        os.makedirs(out_dir, exist_ok=True)
        with open(os.path.join(out_dir, 'error_amplifier_offset.csv'), 'w') as f:
            f.write("info: no Voffset found\n")
        return {"Voffset_arr": []}

    # convertir a float
    orig_arr = [float(x) for x in raw]

    # filtrar outliers (robusto)
    filtered = _robust_filter(orig_arr, low_pct=0.5, high_pct=99.5)

    # estadísticas
    s = _stats(filtered)

    # guardar CSV (col1 = filtrado, col2 = original)
    out_dir = os.path.join('cace', 'scripts')
    os.makedirs(out_dir, exist_ok=True)
    out_csv = os.path.join(out_dir, 'error_amplifier_offset.csv')

    maxlen = max(len(filtered), len(orig_arr))
    col_f = np.array(filtered + [np.nan] * (maxlen - len(filtered)))
    col_o = np.array(orig_arr + [np.nan] * (maxlen - len(orig_arr)))

    header = ("n={n},mean={mean},std={std},median={median},min={min},max={max}").format(
        n=s['n'], mean=s['mean'], std=s['std'], median=s['median'], min=s['min'], max=s['max']
    )

    np.savetxt(out_csv, np.column_stack((col_f, col_o)), comments="", header=header, delimiter=",")

    # resumen compacto para logs
    print("postprocess: Voffset -> n={} mean={} std={} median={}".format(s['n'], s['mean'], s['std'], s['median']))

    # ---------- Parte gráfica mínima ----------
    # Genera histograma y plotea líneas de mean, ±1σ y ±3σ.
    # Si matplotlib no está disponible, no falla el postprocess; sólo lo informa.
    try:
        import matplotlib.pyplot as plt

        if len(filtered) > 0:
            mean = s['mean']
            std = s['std']
            sigma1_pos = mean + std
            sigma1_neg = mean - std
            sigma3_pos = mean + 3.0 * std
            sigma3_neg = mean - 3.0 * std

            fig = plt.figure(figsize=(6,4))
            # histograma (usa bins automáticos)
            plt.hist(filtered, bins='auto', edgecolor='none')
            # líneas de referencia: mean, ±1σ, ±3σ
            plt.axvline(mean, linewidth=1.5, label=f"mean={mean:.3g}")
            plt.axvline(sigma1_pos, linestyle='--', linewidth=1.0, label=f"+1σ={sigma1_pos:.3g}")
            plt.axvline(sigma1_neg, linestyle='--', linewidth=1.0, label=f"-1σ={sigma1_neg:.3g}")
            plt.axvline(sigma3_pos, linestyle=':', linewidth=1.0, label=f"+3σ={sigma3_pos:.3g}")
            plt.axvline(sigma3_neg, linestyle=':', linewidth=1.0, label=f"-3σ={sigma3_neg:.3g}")

            plt.xlabel("Voffset")
            plt.ylabel("Counts")
            plt.title("MC: Voffset distribution")
            plt.legend()
            plt.tight_layout()

            out_fig = os.path.join(out_dir, 'error_amplifier_offset_hist.png')
            fig.savefig(out_fig, dpi=150)
            plt.close(fig)
            print(f"postprocess: histograma guardado en {out_fig}")
        else:
            print("postprocess: no hay datos filtrados para graficar.")
    except Exception as e:
        print("postprocess: matplotlib no disponible o error en la generación de la gráfica:", str(e))
    # ---------- fin gráfica ----------

    # devolver con la clave requerida por tu proyecto
    return {"Voffset_arr": filtered}

