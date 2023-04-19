import numpy as np
import pandas as pd

#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

'''Esta función ejecuta todo el programa y llama todas las funciones
que se implementarán'''
def main():
    v_nom = pd.read_excel("data_io.xlsx", "V_NOM")
    generation = pd.read_excel("data_io.xlsx", "GENERATION")
    load = pd.read_excel("data_io.xlsx", "LOAD")
    lines = pd.read_excel("data_io.xlsx", "LINES")
    lines = z_line(lines)
    generation = vz_gen(generation)
    ybus(lines, generation, load)

'''Esta función calcula el vector de corrientes para todas la
barras e impedancias de generador'''
def vz_gen(generation: pd.DataFrame):
    
    for i in range(len(generation["List Gen"]) - 1):
        #Comprobación de que no hay dos fuentes en paralelo
        for k in range(i + 1, len(generation["List Gen"])):
            if generation["Bus i"][i] == generation["Bus i"][k]:
                v_comp_a = np.complex_((generation["E ind(kV)"][i] * (10**3)) * np.cos(generation["Angle (degrees)"][i]) + generation["E ind(kV)"][i] * np.sin(generation["Angle (degrees)"][i]) * 1j)
                v_comp_b = np.complex_((generation["E ind(kV)"][k] * (10**3)) * np.cos(generation["Angle (degrees)"][k]) + generation["E ind(kV)"][k] * np.sin(generation["Angle (degrees)"][k]) * 1j)
                x_comp_a = np.complex_(generation["R gen (ohms)"][i] + generation["X gen (ohms)"][i] * 1j)
                x_comp_b = np.complex_(generation["R gen (ohms)"][k] + generation["X gen (ohms)"][k] * 1j)
                if v_comp_a/x_comp_a != v_comp_b/x_comp_b:
                    print("Hay una inconsistencia entre dos fuentes en paralelo")
                    generation["Warning"][k] = "WARNING!"
            else:
                generation["Warning"][k] = "OK"
        
    #Cálculo de la corriente
    corrientes = []
    for i in range(len(generation["List Gen"])):
        if generation["Warning"][i] != "WARNING!":
            v_comp = np.complex_(generation["E ind(kV)"][i] * np.cos(generation["Angle (degrees)"][i]) + generation["E ind(kV)"][i] * np.sin(generation["Angle (degrees)"][i]) * 1j)
            x_comp = np.complex_(generation["R gen (ohms)"][i] + generation["X gen (ohms)"][i] * 1j)
            corrientes.append(v_comp/x_comp)
        else:
            corrientes.append(0)
    generation["I (A)"] = corrientes
    return generation
        

'''Esta función calcula las impedancias de las líneas de
transmisión y escribe errores en las líneas donde corresponda'''
def z_line(lines: pd.DataFrame):
    #verificamos inconsistencias
    for i in range(len(lines["List Line"]) - 1):
        for j in range(i + 1, len(lines["List Line"])):
            if lines["Bus i"][int(i)] == lines["Bus i"][int(j)] and lines["Bus j"][int(i)] == lines["Bus j"][int(j)]:
                #print("There's a WARNING")
                lines["Warning"][j] = "WARNING!"
            else:
                if lines["Warning"][i] != "WARNING!":
                    lines["Warning"][i] = "OK" 

    #calculamos impedancias
    line_impedances = []
    for i in range(len(lines["List Line"])):
        if lines["Warning"][i] != "WARNING!":
            line_impedances.append(np.complex_(lines["l(km)"][int(i)] * lines["r line (ohms/km)"][int(i)] + lines["l(km)"][int(i)] * lines["x line (ohms/km)"][int(i)] * 1j))
        else:
            line_impedances.append("WARNING!")

    lines["IMPEDANCE"] = line_impedances
    return lines

'''Esta función calcula la impedancia equivalente de
impedancias en paralelo'''
def z_paral(impedances):
    z_eq_inv = 0
    for i in impedances:
        z_eq_inv += i**-1
    z_eq = z_eq_inv**-1
    return z_eq

'''Esta función calcula la impedancia equivalente de
impedancias en serie'''
def z_serie(impedances):
    z_eq = 0
    for i in impedances:
        z_eq += i
    return z_eq

'''Es el mismo método de nodos para resolver 
circuitos pero en alterna'''
def ybus(lines: pd.DataFrame, generation: pd.DataFrame, load: pd.DataFrame):
    
    #Calculamos la dimensión de nuestra matriz, que será de n x n
    #donde n es el número de nodos sin contar la referencia
    dim = 0
    for i in lines["Bus j"]:
        if dim < i:
            dim = i
    #Creación de la matriz
    ybus_array = np.zeros((dim, dim), dtype = "complex_")
    
    #Primero calculamos la impedancia equivalente en 
    #cada nodo y al invertir este resultado tendremos 
    #nuestra diagonal principal
    for i in range(dim):
        z_i = 0
        inv_sum = 0
        iter = 0
        #Primero sumamos la impedancia de las cargas
        for j in load["Bus i"]:
            if j == i + 1:
                inv_sum += (load["R load (ohms)"][iter])**-1
                if load["Type"][iter] == "IND":
                    inv_sum += (np.complex_(load["X load (ohms)"][iter] * 1j))**-1
                else:
                    inv_sum -= (np.complex_(load["X load (ohms)"][iter] * 1j))**-1
                z_i += inv_sum**-1
                iter += 1
        iter = 0
        
        #Luego añadimos la impedancia de línea
        for j in lines["Bus i"]:
            if j == i + 1:
                if lines["IMPEDANCE"][iter] != "WARNING!":
                    if lines["l(km)"][iter] >= 80:
                            z_i += ((np.complex_(lines["IMPEDANCE"][iter])**-1 + lines["b shunt (mhos/km)"][iter] * 1j))**-1
                    else:
                        z_i += lines["IMPEDANCE"][iter]
                iter += 1

        iter = 0
        for j in lines["Bus j"]:
            if j == i + 1:
                if lines["IMPEDANCE"][iter] != "WARNING!":
                    if lines["l(km)"][iter] >= 80:
                            z_i += ((np.complex_(lines["IMPEDANCE"][iter])**-1 + lines["b shunt (mhos/km)"][iter] * 1j))**-1
                    else:
                        z_i += lines["IMPEDANCE"][iter]
                iter += 1
        
        #Ahora asignamos el valor inverso de la impedancia z_ i al elemento ii de nuestra matriz
        ybus_array[i][i] = z_i**-1

    #Luego desarrollamos los elementos fuera de la diagonal principal que representarán las
    #impedancias de línea
    iter = 0
    for i in lines["Bus i"]:
        if lines["Warning"][iter] != "WARNING!":
            for j in range(dim):
                ybus_array[j][i] = -(lines["IMPEDANCE"][iter])**-1
                ybus_array[i][j] = -(lines["IMPEDANCE"][iter])**-1
        iter += 1
main()