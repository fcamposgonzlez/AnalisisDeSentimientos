# AnalisisDeSentimientos
El análisis de sentimientos es un problema de Big Data que busca determinar la actitud general de un escritor dado un texto que ha escrito. Por ejemplo, se desea tener un programa que tome el texto "La película fue un soplo de aire fresco ." e indique que se trata de una afirmación positiva; mientras que para "Me dieron ganas de sacarme los ojos ." indique que es negativa. 
Un algoritmo para realizar lo anterior consiste en asignar un valor numérico a cada palabra de un comentario en función cuán positiva o negativa sea esa palabra; para luego puntuar el comentario completo en función de los valores de sus palabras.
Ese es el problema que se busca resolver. Se dispone de un archivo que contiene reseñas de películas del sitio web de Rotten Tomatoes. Cada reseña ocupa una línea. Dicha línea empieza con un puntaje numérico que evalúa la película. Luego, en la misma línea, se incluye a continuación el texto de la reseña. El archivo de datos se ve así:

El valor numérico de evaluación tiene el siguiente significado:
    • 0: negativo
    • 1: algo negativo
    • 2: neutral
    • 3: algo positivo
    • 4: positivo
La información de ese archivo será usada para saber cuáles palabras son positivas y cuáles son negativas. El programa debe poder leer una reseña (solo el texto) y asignar un valor entre 0 y 4 tomando el promedio de los valores calculados para cada palabra de la reseña. Por ejemplo, la reseña: "a waste of time ugly  and inept", si los valores de sus palabras son:
a 2.0
waste 1.2
time 1.8
ugly 0.7
and 2.0
inept 0.9
el valor asignado a esa reseña sería el promedio del valor de sus palabras: 	(2.0+1.2+1.8+0.7+2.0+0.9)/6= 8.6/61.4
Nótese que si se excluyen las palabras comunes (stopwords) como "a" y "and", el promedio sería:
	(1.2+1.8+0.7+0.9)/4= 4.6/4 = 1.1
que parece un mejor indicador de lo negativa que es la reseña.

Se usarán los siguientes rangos para considerar si una reseña es negativa, neutra o positiva (dependiendo de su valor estimado):
    • valor estimado <= 1.5 = negativa
    • valor estimado >= 2.5 =  positiva
    • 1.5 < valor estimado < 2.5 = neutra
Con el fin de evaluar sistemáticamente cuán buenos son los estimados calculados, se usará un archivo adicional con el mismo formato del archivo anterior. Esto es, contiene líneas nuevas reseñas junto con sus evaluaciones correctas. Por ejemplo:

4 There is simply no doubt that this film asks the right questions at the right time .
0 A dreary movie .
1 Sadly , though many of the actors throw off a spark or two when they first appear .
3 What begins as a conventional thriller evolves into a gorgeously atmospheric meditation .
2 A mildly enjoyable if toothless adaptation of a much better book .	
1 It never rises to its clever what-if concept .

Finalmente, el programa puede leer un archivo con palabras no significativas (stopwords) para que no sean tomadas en cuenta en el puntaje estimado. Se debe poder decidir si se usan stopwords o no.

# Comandos
El programa se debe implementar como un ciclo interactivo en el que el usuario emite comandos para realizar las diferentes acciones. Se les proveerá de un programa base que muestra como hacer esto en Haskell basándose en el monad IO. A continuación se describen los comandos y sus formatos.

cce archivoEntrenamiento -> Cargar colección de entrenamiento: calcula y almacena el valor de cada palabra que aparece en las reseñas. Si se ejecuta de nuevo, elimina los valores anteriormente almacenados.

ar reseña -> analizar la reseña dada en el comando y mostrar su puntaje y la evaluación asignada

acp archivoPrueba salida -> Analizar cada una de las reseñas de colección de prueba y producir un archivo de salida en que se incluya al inicio de cada reseña el puntaje obtenido.

ecp archivoPrueba -> Evaluar la colección de pruebas. Calcula para la colección de prueba la tasa de acierto como fue descrita arriba.

csw archivoStopwords -> Cargar archivo stopwords: guardar una lista de palabras que no serán tomadas en cuenta de ahí en adelante. Si se ejecuta de nuevo, elimina la lista anterior antes de agregar la nueva.

fin -> Termina la ejecución.
