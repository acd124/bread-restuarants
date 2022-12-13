from flask import Blueprint, request, jsonify, make_response
import json
from src import db


customers = Blueprint("customers", __name__)

# Get a list of all Restaurants
@customers.route("/restaurants", methods=["GET"])
def get_restaurants():
    cursor = db.get_db().cursor()
    cursor.execute("SELECT RestaurantId, Name FROM Restaurant")
    row_headers = ["value", "label"]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = "application/json"
    return the_response


# Get a restaurant's menu
@customers.route("/menus/<restId>", methods=["GET"])
def get_menu(restId):
    cursor = db.get_db().cursor()
    cursor.execute(f"SELECT * FROM Dish WHERE RestaurantId={restId}")
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = "application/json"
    return the_response


# Get all customers from the DB
@customers.route("/customers", methods=["GET"])
def get_customers():
    cursor = db.get_db().cursor()
    cursor.execute(
        "select customerNumber, customerName,\
        creditLimit from customers"
    )
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = "application/json"
    return the_response


# Get customer detail for customer with particular userID
@customers.route("/customers/<userID>", methods=["GET"])
def get_customer(userID):
    cursor = db.get_db().cursor()
    cursor.execute("select * from customers where customerNumber = {0}".format(userID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = "application/json"
    return the_response
