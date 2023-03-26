# Proyecto_EC1251
Proyecto evaluado de Análisis de Circuitos Eléctricos 1 (EC1251)

Este proyecto fue asignado por el profesor Luis Andrade.

Se trata de una serie de scripts para analizar sistemas eléctricos de potencia mediante el método de matriz de admitancia nodal.

Los scripts requeridos son:

1. main() para ejecutar todo el programa, este es el que lee el archivo xlsx y gestiona los diferentes scripts para aplicarlos sobre los datos.

2. VZ_gen() para calcular el vector de corrientes para todas la
barras e impedancias de generador.

3. z_line() calculará las impedancias de línea.

4. z_comp() calculará impedancias de compensación.

5. ybus() calculará la matriz de admitancia nodal y la matriz, calculará los voltajes en cada barra y la impedancia equivalente de Thevenin en dicha barra

6. lineflow() calculará los flujos por todas la líneas
