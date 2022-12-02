from flask import Flask, jsonify, make_response
import os
import json
import pymongo
from flask_cors import CORS
import datetime



connection="mongodb+srv://Miken:Miken001@multi-region.ilmvkvm.mongodb.net/?retryWrites=true&w=majority"

# set a 5-second connection timeout
client = pymongo.MongoClient(connection, serverSelectionTimeoutMS=5000)

mydb =client["sample_airbnb"]
mycol = mydb["users"]




try:
    print(client.server_info())
except Exception:
    print("Unable to connect to the server.")

app = Flask(__name__)
CORS(app)
servertype = os.environ['AWS_REGION']


@app.route("/")
def hello_from_root():

    return "Hello There"

@app.route("/type")
def server_type():
    return f'Hello -{servertype}'

@app.route("/data")
def mongo():
    x = mycol.find_one()
    k=x['Name']
    return jsonify({"name":k})

@app.route("/database")
def database():
    a=[]
    for i in mycol.find({"region":servertype},sort=[( 'date', pymongo.DESCENDING )]).limit(50):
        a.append(i)
    return json.dumps(a,default=str)


@app.route("/insert",methods=["POST"])
def insert():
    mycol.insert_one({'Name':"Miken Patel","region":servertype, "date": datetime.datetime.utcnow()})
    return "Added"

if __name__=="__main__":
    app.run()