import pandas as pd

def agrupar_y_calcular_media(df, tamano_grupo):
    # Agrupar el DataFrame en bloques de tamaño 'tamano_grupo' y calcular la media
    df_agrupado = df.groupby(df.index // tamano_grupo).mean()

    return df_agrupado

def eliminar_filas_redundantes(df):
    # Ordenar el DataFrame por 'n' y 'm' en orden descendente
    df.sort_values(['n', 'm'], ascending=[True, False], inplace=True)

    # Eliminar filas duplicadas basadas en la columna 'n', manteniendo solo la primera aparición (la de mayor 'm')
    df.drop_duplicates('n', keep='first', inplace=True)

    # Restablecer el índice después de la eliminación
    df.reset_index(drop=True, inplace=True)

def calcular_variacion_absoluta(df):
    # Calcular la variación absoluta entre los datos siguientes y anteriores en la columna 'm'
    df['variacion_absoluta'] = df['m'].diff().abs()

if __name__ == "__main__":
    # Reemplaza 'tu_archivo.csv' con el nombre real de tu archivo CSV
    archivo_entrada = 'E:/GitHub/SIM_LAB/P2Particulas/doc/data/GRAFICA3.csv'
    archivo_salida = 'E:/GitHub/SIM_LAB/P2Particulas/doc/data/GRAFICA3_P2.csv'

    tamano_grupo = 10

    # Leer el archivo CSV en un DataFrame
    df = pd.read_csv(archivo_entrada)

    # Llamar a la función para eliminar filas redundantes y actualizar 'm'
    eliminar_filas_redundantes(df)

    # Llamar a la función para calcular la variación absoluta
    calcular_variacion_absoluta(df)

    # Llamar a la función para agrupar y calcular la media
    df_agrupado = agrupar_y_calcular_media(df, tamano_grupo)

    # Guardar el DataFrame agrupado en un nuevo archivo CSV
    df_agrupado.to_csv(archivo_salida, index=False)

    print(f"Se ha creado el archivo '{archivo_salida}' con las filas eliminadas, valores actualizados, variación absoluta calculada y datos agrupados con media cada {tamano_grupo} líneas.")