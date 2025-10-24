import os
import numpy as np
from typing import Any, Dict, List

# Nuevas claves para las variables que quieres procesar
NEW_KEYS = ['Iref_2n', 'Iref_20n', 'Iref_50n', 'Iref_2p', 'Iref_20p', 'Iref_50p']

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

def postprocess(results: Dict[str, List[float]], conditions: Dict[str, Any]):
    """
    Postprocess para las nuevas mediciones de referencia Iref.
    - Devuelve todas las variables de Iref procesadas.
    - Guarda CSV en cace/scripts/error_amplifier_Iref.csv
    - Genera histogramas separados en cace/scripts/error_amplifier_Iref_<nombre_variable>_hist.png
    """

    # Variables separadas para cada Iref
    Iref_2n_arr = []
    Iref_20n_arr = []
    Iref_50n_arr = []
    Iref_2p_arr = []
    Iref_20p_arr = []
    Iref_50p_arr = []

    # Iterar sobre cada variable de Iref
    for var_name in NEW_KEYS:
        if var_name in results:
            raw = results[var_name]
            
            # Convertir a float
            orig_arr = [float(x) for x in raw]

            # Filtrar outliers (robusto)
            filtered = _robust_filter(orig_arr, low_pct=0.5, high_pct=99.5)

            # Estadísticas
            s = _stats(filtered)

            # Guardar los resultados procesados en la variable correspondiente
            if var_name == "Iref_2n":
                Iref_2n_arr = filtered
            elif var_name == "Iref_20n":
                Iref_20n_arr = filtered
            elif var_name == "Iref_50n":
                Iref_50n_arr = filtered
            elif var_name == "Iref_2p":
                Iref_2p_arr = filtered
            elif var_name == "Iref_20p":
                Iref_20p_arr = filtered
            elif var_name == "Iref_50p":
                Iref_50p_arr = filtered

            # Guardar CSV (col1 = filtrado, col2 = original)
            out_dir = os.path.join('cace', 'scripts')
            os.makedirs(out_dir, exist_ok=True)
            out_csv = os.path.join(out_dir, 'Iref_mc.csv')

            maxlen = max(len(filtered), len(orig_arr))
            col_f = np.array(filtered + [np.nan] * (maxlen - len(filtered)))
            col_o = np.array(orig_arr + [np.nan] * (maxlen - len(orig_arr)))

            header = ("n={n},mean={mean},std={std},median={median},min={min},max={max}").format(
                n=s['n'], mean=s['mean'], std=s['std'], median=s['median'], min=s['min'], max=s['max']
            )

            np.savetxt(out_csv, np.column_stack((col_f, col_o)), comments="", header=header, delimiter=",")

            # Resumen compacto para logs
            print(f"postprocess: {var_name} -> n={s['n']} mean={s['mean']} std={s['std']} median={s['median']}")

            # Generar histograma por cada variable
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
                    plt.hist(filtered, bins='auto', edgecolor='none')
                    # Líneas de referencia para cada variable
                    plt.axvline(mean, linewidth=1.5, label=f"mean={mean:.3g}")
                    plt.axvline(sigma1_pos, linestyle='--', linewidth=1.0, label=f"+1σ={sigma1_pos:.3g}")
                    plt.axvline(sigma1_neg, linestyle='--', linewidth=1.0, label=f"-1σ={sigma1_neg:.3g}")
                    plt.axvline(sigma3_pos, linestyle=':', linewidth=1.0, label=f"+3σ={sigma3_pos:.3g}")
                    plt.axvline(sigma3_neg, linestyle=':', linewidth=1.0, label=f"-3σ={sigma3_neg:.3g}")

                    plt.xlabel(f"{var_name} values")
                    plt.ylabel("Counts")
                    plt.title(f"Distribution of {var_name}")
                    plt.legend()
                    plt.tight_layout()

                    # Guardar el histograma por cada variable
                    out_fig = os.path.join(out_dir, f'{var_name}_hist.png')
                    fig.savefig(out_fig, dpi=150)
                    plt.close(fig)
                    print(f"postprocess: histograma guardado en {out_fig}")
            except Exception as e:
                print(f"postprocess: matplotlib no disponible o error en la generación de la gráfica para {var_name}: {str(e)}")

    # Devolver las variables por separado
    return {
    "Iref_2n_dict": Iref_2n_arr,
    "Iref_20n_dict": Iref_20n_arr,
    "Iref_50n_dict": Iref_50n_arr,
    "Iref_2p_dict": Iref_2p_arr,
    "Iref_20p_dict": Iref_20p_arr,
    "Iref_50p_dict": Iref_50p_arr
}




