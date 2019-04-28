# AnalisisDeSentimientos

# Descripción
El análisis de sentimientos es un problema de Big Data que busca determinar la actitud general de un escritor dado un texto que ha escrito. Por ejemplo, se desea tener un programa que tome el texto "La película fue un soplo de aire fresco ." e indique que se trata de una afirmación positiva; mientras que para "Me dieron ganas de sacarme los ojos ." indique que es negativa.
Un algoritmo para realizar lo anterior consiste en asignar un valor numérico a cada palabra de un comentario en función cuán positiva o negativa sea esa palabra; para luego puntuar el comentario completo en función de los valores de sus palabras. Pero, ¿cómo se puede asignar ese valor numérico a las palabras en primer lugar?
Ese es el problema que se busca resolver en esta tarea. Se dispone de un archivo que contiene reseñas de películas del sitio web de Rotten Tomatoes. Cada reseña ocupa una línea. Dicha línea empieza con un puntaje numérico que evalúa la película. Luego, en la misma línea, se incluye a continuación el texto de la reseña. El archivo de datos se ve así:

El valor numérico de evaluación tiene el siguiente significado:
    • 0: negativo
    • 1: algo negativo
    • 2: neutral
    • 3: algo positivo
    • 4: positivo

# Comandos
El programa se debe implementar como un ciclo interactivo en el que el usuario emite comandos para realizar las diferentes acciones. Se les proveerá de un programa base que muestra como hacer esto en Haskell basándose en el monad IO. A continuación se describen los comandos y sus formatos.

cce archivoEntrenamiento
Cargar colección de entrenamiento: calcula y almacena el valor de cada palabra que aparece en las reseñas. Si se ejecuta de nuevo, elimina los valores anteriormente almacenados.

ar reseña
analizar la reseña dada en el comando y mostrar su puntaje y la evaluación asignada

acp archivoPrueba salida
Analizar cada una de las reseñas de colección de prueba y producir un archivo de salida en que se incluya al inicio de cada reseña el puntaje obtenido.

ecp archivoPrueba
Evaluar la colección de pruebas. Calcula para la colección de prueba la tasa de acierto como fue descrita arriba.

csw archivoStopwords
Cargar archivo stopwords: guardar una lista de palabras que no serán tomadas en cuenta de ahí en adelante. Si se ejecuta de nuevo, elimina la lista anterior antes de agregar la nueva.

fin
Termina la ejecución.
