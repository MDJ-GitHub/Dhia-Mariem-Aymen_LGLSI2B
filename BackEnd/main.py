from typing import Optional
from fastapi import FastAPI, Request
import mysql.connector
import json
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

origins = [
    
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/gestionemployes/backend_connecter_bd")
def chercher(eid: int , motdepasse: str):
    db = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    cursor = db.cursor() 
    cursor.execute(f"SELECT `nom`, `admin` FROM personne , compte WHERE `eid`= {eid} and `mdp` = '{motdepasse}' and `compte`.`cin` = `personne`.`cin`;")
    row_headers=[x[0] for x in cursor.description]
    cf = cursor.fetchall()
    json_data=[]
    for result in cf:
        json_data.append(dict(zip(row_headers,result)))
    return json_data


@app.post("/gestionemployes/backend_ajouter_personne_bd")
async def ajouter(req: Request):
    mydb = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    mycursor = mydb.cursor() 
    body = json.loads(await req.body())
    mycursor.execute(f"INSERT INTO `personne`(`cin`, `prenom`, `nom`, `datenaissance`, `ville`, `email`, `numtel` , `photo`) VALUES ( {body['cin']}, '{body['prenom']}' , '{body['nom']}' , '{body['datenaissance']}', '{body['ville']}' , '{body['email']}' , {body['numtel']} , '{body['photo']}');")
    mydb.commit()   
    return {"done"}

@app.post("/gestionemployes/backend_annuler_ajouter_personne_bd")
async def ajouter(req: Request):
    mydb = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    mycursor = mydb.cursor() 
    body = json.loads(await req.body())
    mycursor.execute(f"DELETE FROM `personne` WHERE {body['cin']} = `cin` ;")
    mydb.commit()   
    return {"done"}    

@app.post("/gestionemployes/backend_ajouter_compte_bd")
async def ajouter(req: Request):
    mydb = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    mycursor = mydb.cursor() 
    body = json.loads(await req.body())
    mycursor.execute(f"INSERT INTO `compte`(`eid`, `mdp`, `admin`, `dateinscription`, `salaire`, `cin`) VALUES  ( {body['eid']}, '{body['motdepasse']}' , {body['ad']} , '{body['dateinscription']}', {body['salaire']} , {body['cin']});")
    mydb.commit()   
    return {"done"}

@app.post("/gestionemployes/backend_ajouter_tache_bd")
async def ajouter(req: Request):
    mydb = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    mycursor = mydb.cursor() 
    body = json.loads(await req.body())
    mycursor.execute(f"INSERT INTO `tache`(`tachenom`, `directeureid`, `eid`) VALUES  (  '{body['tnom']}' , {body['deid']} , {body['eid']});")
    mydb.commit()   
    return {"done"}

@app.get("/gestionemployes/backend_ajouter_chercher_tache_bd")
def ajouter():
    db = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    cursor = db.cursor() 
    cursor.execute(f"SELECT `eid` FROM compte WHERE 1;")
    row_headers=[x[0] for x in cursor.description]
    cf = cursor.fetchall()
    json_data=[]
    for result in cf:
        json_data.append(dict(zip(row_headers,result)))
    return json_data

@app.get("/gestionemployes/backend_modifier_chercher_bd")
def chercher(eid: int):
    db = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    cursor = db.cursor() 
    cursor.execute(f"SELECT `compte`.`cin`, `mdp`, `admin`, `prenom`, `nom`, `datenaissance`, `ville`, `email`,  `numtel`, `salaire` ,  `photo` FROM personne , compte WHERE compte.`eid`= '{eid}' and compte.`cin` = personne.`cin` ;")
    row_headers=[x[0] for x in cursor.description]
    cf = cursor.fetchall()
    json_data=[]
    for result in cf:
        json_data.append(dict(zip(row_headers,result)))
    return json_data

@app.get("/gestionemployes/backend_modifier_chercher_tache_bd")
def modifier(eid: int):
    db = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    cursor = db.cursor() 
    cursor.execute(f"SELECT `tachenom` ,`directeureid` FROM tache WHERE `eid`= '{eid}' ;")
    row_headers=[x[0] for x in cursor.description]
    cf = cursor.fetchall()
    json_data=[]
    for result in cf:
        json_data.append(dict(zip(row_headers,result)))
    return json_data

@app.post("/gestionemployes/backend_modifier_personne_bd")
async def ajouter(req: Request):
    mydb = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    mycursor = mydb.cursor() 
    body = json.loads(await req.body())
    mycursor.execute(f" UPDATE `personne` SET `cin`={body['cin']} ,`prenom`='{body['prenom']}',`nom`='{body['nom']}',`datenaissance`='{body['datenaissance']}',`ville`='{body['ville']}',`email`='{body['email']}',`numtel`='{body['numtel']}',`photo` = '{body['photo']}' WHERE  `cin`={body['cinx']} ;")
    mydb.commit()   
    return {"done"}

@app.post("/gestionemployes/backend_modifier_comptep_bd")
async def ajouter(req: Request):
    mydb = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    mycursor = mydb.cursor() 
    body = json.loads(await req.body())
    mycursor.execute(f" UPDATE `compte` SET `cin`= 0 WHERE  `eid`={body['eid']} ;")
    mydb.commit()   
    return {"done"}

@app.post("/gestionemployes/backend_modifier_compte_bd")
async def ajouter(req: Request):
    mydb = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    mycursor = mydb.cursor() 
    body = json.loads(await req.body())
    mycursor.execute(f" UPDATE `compte` SET `cin`={body['cin']},`salaire`={body['salaire']} ,`mdp`='{body['motdepasse']}',`admin`={body['admin']},`admin`={body['admin']}  WHERE  `eid`={body['eid']} ;")
    mydb.commit()   
    return {"done"}

@app.post("/gestionemployes/backend_init_modifier_tache_bd")
async def ajouter(req: Request):
    mydb = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    mycursor = mydb.cursor() 
    body = json.loads(await req.body())
    mycursor.execute(f"DELETE FROM `tache` WHERE {body['eid']} = `eid` ;")
    mydb.commit()   
    return {"done"}     

@app.post("/gestionemployes/backend_modifier_tache_bd")
async def ajouter(req: Request):
    mydb = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    mycursor = mydb.cursor() 
    body = json.loads(await req.body())
    mycursor.execute(f"INSERT INTO `tache`(`tachenom`, `directeureid`, `eid`) VALUES  (  '{body['tnom']}' , {body['deid']} , {body['eid']});")
    mydb.commit()   
    return {"done"}

@app.post("/gestionemployes/backend_supprimer_compte_bd")
async def ajouter(req: Request):
    mydb = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    mycursor = mydb.cursor() 
    body = json.loads(await req.body())
    mycursor.execute(f"DELETE FROM `compte` WHERE {body['eid']} = `eid` ;")
    mydb.commit()   
    return {"done"}    

@app.post("/gestionemployes/backend_supprimer_personne_bd")
async def ajouter(req: Request):
    mydb = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    mycursor = mydb.cursor() 
    body = json.loads(await req.body())
    mycursor.execute(f"DELETE FROM `personne` WHERE {body['cin']} = `cin` ;")
    mydb.commit()   
    return {"done"}    

@app.post("/gestionemployes/backend_supprimer_tache_bd")
async def ajouter(req: Request):
    mydb = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    mycursor = mydb.cursor() 
    body = json.loads(await req.body())
    mycursor.execute(f"DELETE FROM `tache` WHERE {body['eid']} = `eid` ;")
    mydb.commit()   
    return {"done"}   

@app.get("/gestionemployes/backend_chercher_bd")
def chercher(eid: int):
    db = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    cursor = db.cursor() 
    cursor.execute(f"SELECT `compte`.`cin`, `mdp`, `admin`, `prenom`, `nom`, `datenaissance`, `ville`, `email`,  `numtel`, `photo`, `salaire` , `dateinscription`  FROM personne , compte WHERE `eid`= '{eid}' and compte.`cin` = personne.`cin` ;")
    row_headers=[x[0] for x in cursor.description]
    cf = cursor.fetchall()
    json_data=[]
    for result in cf:
        json_data.append(dict(zip(row_headers,result)))
    return json_data

@app.get("/gestionemployes/backend_chercher_tache_bd")
def chercher(eid: int):
    db = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    cursor = db.cursor() 
    cursor.execute(f"SELECT `tachenom` ,`directeureid` FROM tache WHERE `eid`= '{eid}' ;")
    row_headers=[x[0] for x in cursor.description]
    cf = cursor.fetchall()
    json_data=[]
    for result in cf:
        json_data.append(dict(zip(row_headers,result)))
    return json_data

@app.get("/gestionemployes/backend_consulter_bd")
def consulter():
    db = mysql.connector.connect(host = "localhost" , user = "root" , password = "" , database = "gestionemployes")
    cursor = db.cursor() 
    cursor.execute(f"SELECT DISTINCT `eid`, `compte`.`cin`, `prenom`, `nom`, `ville`, `numtel`, `email`, `salaire` , `photo` FROM personne , compte WHERE compte.`cin` = personne.`cin` ;")
    row_headers=[x[0] for x in cursor.description]
    cf = cursor.fetchall()
    json_data=[]
    for result in cf:
        json_data.append(dict(zip(row_headers,result)))
    return json_data