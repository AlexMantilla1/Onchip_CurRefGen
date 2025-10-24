from typing import Any
import numpy as np

def postprocess(results: dict[str, list], conditions: dict[str, Any]) -> dict[str, list]:
    # Variables que queremos procesar
    variables = ['char_n', 'char_p']
    
    # Extraemos las listas de multiplicadores y iteraciones
    mult_list = conditions.get('mult', [])
    iterations = conditions.get('iterations', [])
    
    n_mult = len(mult_list)
    n_iter = len(iterations)
    
    output = {}
    
    for var in variables:
        data = np.array(results.get(var, []))
        
        # Validar tamaño
        if data.size != n_mult * n_iter:
            raise Exception(f"Datos para {var} tienen tamaño incorrecto: esperado {n_mult*n_iter}, recibido {data.size}")
        
        # Reorganizar datos a matriz (multiplicadores x iteraciones)
        data_reshaped = data.reshape((n_mult, n_iter))
        
        # Calcular media y desviación estándar para cada multiplicador
        mean_vals = np.mean(data_reshaped, axis=1).tolist()
        std_vals = np.std(data_reshaped, axis=1).tolist()
        
        # Guardar resultados
        output[f"{var}_mean"] = mean_vals
        output[f"{var}_std"] = std_vals
    
    return output
