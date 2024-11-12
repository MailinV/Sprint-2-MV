#-------------------------------- NIVEL 1 ------------------------
# ----------EJERCICIO 2-------------------------------------------

#Utilitzant JOIN realitzaràs les següents consultes:

# 1.Llistat dels països que estan fent compres.
SELECT DISTINCT country
FROM transaction
JOIN company
ON company.id = transaction.company_id;

# 2. Des de quants països es realitzen les compres.
SELECT COUNT(DISTINCT country)
FROM transaction
JOIN company
ON company.id = transaction.company_id;

# 3.Identifica la companyia amb la mitjana més gran de vendes.
SELECT company_name, ROUND(AVG(amount),2) as media
FROM transaction
LEFT JOIN company
ON company.id = transaction.company_id
WHERE declined = 0
GROUP BY company_name
ORDER BY media DESC
lIMIT 1;


#----------EJERCICIO 3 ---------------------------------------

# Utilitzant només subconsultes (sense utilitzar JOIN):

# 1. Mostra totes les transaccions realitzades per empreses d'Alemanya.
SELECT transaction.id 
FROM transaction
WHERE (company_id) IN (SELECT company.id
                                   FROM company
								   WHERE country = "Germany");


# 2. Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
SELECT company_name
FROM company
WHERE id IN (SELECT company_id
             FROM transaction
             WHERE amount > (SELECT AVG(amount)
				             FROM transaction)); # media de todas las transacciones 256.735520

# 3. Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.

SELECT id, company_name
FROM company
WHERE  id NOT IN (SELECT DISTINCT(company_id)
                 FROM transaction);
             
             
#--------------------------------- NIVEL 2 -------------------------------------------

# ---------------------EJERCICIO 1 ----------------------    
# Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes.
# Mostra la data de cada transacció juntament amb el total de les vendes.

SELECT DATE(timestamp) as fecha, SUM(amount) as total_ventas
FROM transaction
WHERE declined = 0
GROUP BY fecha
ORDER BY total_ventas DESC
LIMIT 5;

# ----------------EJERCICIO 2------------------------- 
# Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.
SELECT country as pais, ROUND(AVG(amount),2) as media_ventas
FROM transaction
JOIN company
ON company.id = transaction.company_id
WHERE declined = 0
GROUP BY country
ORDER BY media_ventas DESC;

#---------------- EJERCICIO 3------------------------
# En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer 
# competència a la companyia "Non Institute". Per a això, et demanen la llista de totes les transaccions realitzades 
# per empreses que estan situades en el mateix país que aquesta companyia.

# Mostra el llistat aplicant JOIN i subconsultes.

SELECT transaction.id, company_name, country
FROM transaction
JOIN company
ON company.id = transaction.company_id
WHERE country = (SELECT country
                  FROM company
                  WHERE company_name = "Non Institute");


#Mostra el llistat aplicant solament subconsultes.

SELECT transaction.id
FROM transaction
WHERE (company_id) IN (SELECT company.id
                                   FROM company
								   WHERE country = (SELECT country
                                                    FROM company
													WHERE company_name = "Non Institute"));
                  
# --------------------------------NIVEL 3 ------------------------------------------

# ----------------------EJERCICIO 1-----------------------------------------
# Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor 
# comprès entre 100 i 200 euros i en alguna d'aquestes dates: 29 d'abril del 2021, 20 de juliol del 2021 i 13 de 
# març del 2022. Ordena els resultats de major a menor quantitat.


SELECT company_name, phone, country, DATE(timestamp) as fecha, amount
FROM transaction
JOIN company
ON company.id = transaction.company_id 
WHERE amount BETWEEN 100 AND 200 AND
(DATE(timestamp) = '2021-04-29' or
DATE(timestamp) = '2021-07-20' or 
DATE(timestamp) = '2022-03-13')
ORDER BY amount DESC;


# ----------------------- EJERCICIO 2 ------------------------------------
# Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, per la 
# qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, però el 
# departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 4 
# transaccions o menys.

SELECT company_name, COUNT(transaction.id) as transacciones,
    CASE
        WHEN COUNT(transaction.id) >= 4 THEN 'Tiene 4 o más transacciones'
        ELSE 'Tiene menos de 4 transacciones'
    END as categoria_transacciones
FROM transaction
JOIN company
ON company.id = transaction.company_id 
GROUP BY company_name;


     