import numpy as np
import pandas as pd
from openpyxl import load_workbook

'''Esta función ejecuta todo el programa y llama todas las funciones
que se implementarán'''
def main():
    v_nom = pd.read_excel("data_io.xlsx", "V_NOM")
    generation = pd.read_excel("data_io.xlsx", "GENERATION")
    load = pd.read_excel("data_io.xlsx", "LOAD")
    lines = pd.read_excel("data_io.xlsx", "LINES")
    print(z_line(lines))

'''Esta función calcula las impedancias de las líneas de
transmisión'''
def z_line(lines: pd.DataFrame):

    warn = []
    for i in range(len(lines["List Line"]) - 1):
        for j in range(i + 1, len(lines["List Line"])):
            if lines["Bus i"][int(i)] == lines["Bus i"][int(j)] and lines["Bus j"][int(i)] == lines["Bus j"][int(j)]:
                print("There's a WARNING")
                lines["Warning"][j] = "WARNING!"    

    line_impedances = []
    for i in range(len(lines["List Line"])):
        if lines["Warning"][i] != "WARNING!":
            line_impedances.append(np.complex_(lines["l(km)"][int(i)] * lines["r line (ohms/km)"][int(i)] + lines["l(km)"][int(i)] * lines["x line (ohms/km)"][int(i)] * 1j))
        else:
            line_impedances.append("WARNING!")

    lines["IMPEDANCE"] = line_impedances
    

    return lines["IMPEDANCE"]

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

main()