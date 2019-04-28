import Prelude hiding (lookup)
import Data.Char
import System.IO
import Control.Monad
import GHC.IO.Encoding
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as HashMap
type Estado = Map [Char] (Float,Float)

main :: IO ()
main = do
       setLocaleEncoding utf8 
       mainloop HashMap.empty []

mainloop :: Estado -> [String] -> IO ()
mainloop estado stopwords = do
  putStr ">> "
  inpStr <- getLine
  let tokens  = words inpStr
  let comando = tokens!!0
  
  case comando of
    "cce" -> do
      let 
        nombreArchivo = tokens!!1 
      inh <- openFile nombreArchivo ReadMode
      nuevoestado <- cce inh HashMap.empty stopwords
      hClose inh
      putStrLn $ "Archivo " ++ nombreArchivo ++ " fue cargado"
      mainloop nuevoestado stopwords
    "ar" -> do
      let
        reseña = (tail tokens)
      reseñaAux <- ar reseña 0 0 estado
      print (reseñaAux)
      mainloop estado stopwords
    "acp" -> do
      let 
        nombreArchivoEntrada = tokens!!1 
      inh <- openFile nombreArchivoEntrada ReadMode
      let
        nombreArchivoSalida = tokens!!2
      writeFile nombreArchivoSalida ""
      salida <- (acp inh nombreArchivoSalida estado)
      putStrLn (">>>"++salida)  
      hClose inh
      mainloop estado stopwords
    "ecp" -> do
      let
        nombreArchivoEntrada = tokens!!1
      inh <- openFile nombreArchivoEntrada ReadMode
      acer <- ecp inh estado 0 0
      putStrLn ("Aciertos: "++(show (fst acer)))
      putStrLn ("Errados: "++(show (abs (snd acer))))
      putStrLn ("Promedio: "++(show (fst acer))++"/"++(show (abs (snd acer))))
      hClose inh
      mainloop estado stopwords
    "csw" -> do 
      let
        nombreArchivo = tokens!!1
      inh <- openFile nombreArchivo ReadMode
      stopwordsnew <- csw inh []
      hClose inh
      putStrLn $ "Archivo " ++ nombreArchivo ++ " fue cargado"
      mainloop estado stopwordsnew 
    "fin" -> do
      putStrLn "Saliendo..."
    _     -> do
      putStrLn $ "Comando desconocido ("++ comando ++"): '" ++ inpStr ++ "'" 
      mainloop estado stopwords

-----------------------------------------------------------------------------------------------------------------------------------------

--Funcion CCE
--Cargar colección de entrenamiento: 
--calcula y almacena el valor de cada palabra que aparece en las reseñas. 
--Si se ejecuta de nuevo, elimina los valores anteriormente almacenados.

cce :: Handle -> Estado -> [String] -> IO Estado

cce inh estado stopwords = 
  do 
    ineof <- hIsEOF inh
    if ineof 
      then
        do
          return estado 
    else 
      do 
        inpStr <- hGetLine inh
        nuevoestado <- cceAux estado (words inpStr) stopwords
        cce inh nuevoestado stopwords

cceAux:: Estado -> [String] -> [String] -> IO Estado
cceAux estado (x:xs) stopwords = 
  do
    cceAux2 (convertStringToFloat x) estado xs stopwords
    
cceAux2:: Float ->  Estado -> [String] -> [String] -> IO Estado
cceAux2 calif estado [] stopwords = 
  return estado
cceAux2 calif estado (x:xs) stopwords = 
  do
    if not (elem x stopwords)
      then
        if HashMap.member x estado 
          then
            do
              cceAux2 calif (HashMap.insertWith f x (calif,1) estado) xs stopwords
        else
          do
            cceAux2 calif (HashMap.insert x (calif,1) estado)  xs stopwords
    else
      cceAux2 calif estado xs stopwords
  where f new old = ((fst new + fst old),(snd new + snd old)) 

----------------------------------------------------------------------------------------------------------------------------------------

--Funcion AR
--analizar la reseña dada en el comando y 
--mostrar su puntaje y la evaluación asignada

ar :: [String] -> Float -> Float -> Estado -> IO String

ar [] puntuacion contador estado =
  do
    if (puntuacion <= 1.5)
      then
        return ("El puntaje de la resena es "++ (show (puntuacion/contador))++" y es de puntuacion negativa")
    else
      if (puntuacion > 1.5 && puntuacion <= 2.5)
        then
          return ("El puntaje de la resena es "++ (show (puntuacion/contador))++" y es de puntuacion neutra")
      else
        if (puntuacion > 2.5)
          then
            return ("El puntaje de la resena es "++ (show (puntuacion/contador))++" y es de puntuacion positiva")
        else
          return ("No se pudo :(")

ar (x:xs) puntuacion contador estado =
  do 
    if HashMap.member x estado
      then
        ar xs (puntuacion + (fst (deleteJust2 (HashMap.lookup x estado))) / (snd (deleteJust2 (HashMap.lookup x estado))) ) (contador +1) estado
    else
      ar xs puntuacion contador estado

---------------------------------------------------------------------------------------------------------------------------------------------------------

--Funcion ACP
--Analizar cada una de las reseñas de colección de prueba 
--y producir un archivo de salida en que se incluya al 
--inicio de cada reseña el puntaje obtenido.


acp:: Handle -> String -> Estado -> IO String

acp inh outh estado = 
  do 
    ineof <- hIsEOF inh
    if ineof 
      then
        do
          return "Archivo guardado exitosamente" 
    else 
      do 
        inpStr <- hGetLine inh
        puntuacion <- acpAux 0 0 estado (tail (words inpStr))
        appendFile outh ((show puntuacion)++" "++inpStr) 
        acp inh outh estado

acpAux:: Float -> Float -> Estado -> [String] -> IO Float

acpAux puntuacion contador estado [] =
    return (puntuacion/contador)

acpAux puntuacion contador estado (x:xs) =
  do 
    if HashMap.member x estado
      then
        acpAux (puntuacion + (fst (deleteJust2 (HashMap.lookup x estado))) / (snd (deleteJust2 (HashMap.lookup x estado)))) (contador+1) estado xs
    else
      acpAux puntuacion contador estado xs

--------------------------------------------------------------------------------------------------------------------------------------------------------

--Funcion ECP
--Evaluar la colección de pruebas. 
--Calcula para la colección de prueba la tasa de acierto como fue descrita arriba.

ecp:: Handle -> Estado -> Int -> Int -> IO (Int,Int)

ecp inh estado aciertos errados = 
  do 
    ineof <- hIsEOF inh
    if ineof 
      then
        do
          return (aciertos,errados)
    else 
      do 
        inpStr <- hGetLine inh
        puntuacion <- acpAux 0 0 estado (tail (words inpStr))
        if (puntuacion <= 1.5) && (convertStringToFloat(head (words inpStr)) <= 1.5) 
          then
            ecp inh estado (aciertos + 1) errados 
        else
          if (puntuacion > 1.5 && puntuacion <= 2.5) && ((convertStringToFloat (head (words inpStr)) > 1.5 && convertStringToFloat(head (words inpStr)) <= 2.5))
            then
              ecp inh estado (aciertos + 1) errados
          else
            if (puntuacion > 2.5) && (convertStringToFloat(head (words inpStr)) > 2.5)
              then
                ecp inh estado (aciertos +1) errados
            else
              ecp inh estado aciertos (errados-1)

---------------------------------------------------------------------------------------------------------------------------------------------------------

--Funcion CSW
--Cargar archivo stopwords: 
--guardar una lista de palabras que no serán tomadas en cuenta de ahí en adelante. 
--Si se ejecuta de nuevo, elimina la lista anterior antes de agregar la nueva.

csw :: Handle -> [String] -> IO [String]
csw inh stopwords = 
  do 
    ineof <- hIsEOF inh
    if ineof 
      then
        do
          return stopwords 
    else 
      do 
        inpStr <- hGetLine inh
        csw inh (stopwords ++ [inpStr])

----------------------------------------------------------------------------------------------------------------------------------------------------------------

--Funciones auxiliares

deleteJust :: Maybe String -> String
deleteJust (Just x) = x

deleteJust2 :: Maybe (Float,Float) -> (Float,Float) 
deleteJust2 (Just x) = x

filterNumberFromString :: String -> String
filterNumberFromString s =
  let 
    allowedString = ['0'..'9'] ++ ['.', ',']
    toPoint n
      | n == ',' = '.'
      | otherwise = n
    f = filter (`elem` allowedString) s
    d = map toPoint f
    in d
      
convertStringToFloat :: String -> Float
convertStringToFloat s =
  let 
    betterString = filterNumberFromString s
    asFloat = read betterString :: Float
  in asFloat


filterNumberFromMString :: String -> String
filterNumberFromMString s =
  let 
    allowedString = ['0'..'9'] ++ ['.', ',']
    toPoint n
      | n == ',' = '.'
      | otherwise = n
    f = filter (`elem` allowedString) s
    d = map toPoint f
    in d
        
convertMStringToFloat :: String -> Float
convertMStringToFloat s =
  let 
    betterString = filterNumberFromMString s
    asFloat = read betterString :: Float
  in asFloat