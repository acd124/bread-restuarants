from flask import Blueprint, request, jsonify, make_response
import json
from src import db


customers = Blueprint("customers", __name__)

# Get customer information
@customers.route("/user_info/<userId>", methods=["GET"])
def get_customer(userId):
    cursor = db.get_db().cursor()
    cursor.execute(f"SELECT * FROM Customer WHERE CustomerId = {userId}")
    row_headers = [x[0] for x in cursor.description]
    theData = cursor.fetchone()
    json_data = dict(zip(row_headers, theData))
    name = json_data.pop("FirstName", "") + " " + json_data.pop("LastName", "")
    json_data = [{"name": "Name", "id": name}] + [
        {"name": key, "id": val}
        for key, val in json_data.items()
        if key not in ("CustomerId")
    ]
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = "application/json"
    return the_response


# Get a list of all Restaurants
@customers.route("/restaurants", methods=["GET"])
def get_restaurants():
    cursor = db.get_db().cursor()
    cursor.execute("SELECT RestaurantId, Name FROM Restaurant")
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    json_data = [
        {**x, "label": x["Name"], "value": x["RestaurantId"]} for x in json_data
    ]
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
    json_data = [{**x} for x in json_data]
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = "application/json"
    return the_response


# Get a restaurant's beverages
@customers.route("/beverages/<restId>", methods=["GET"])
def get_beverages(restId):
    cursor = db.get_db().cursor()
    cursor.execute(
        f"SELECT * FROM Beverage B JOIN RestaurantBeverage RB \
            ON B.DrinkId = RB.DrinkId\
            WHERE RB.RestaurantId={restId}"
    )
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    json_data = [
        {**x, "Alcoholic": True if x["Alcoholic"] else False} for x in json_data
    ]
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = "application/json"
    return the_response


# Get a user's current orders
@customers.route("/orders/<userId>", methods=["GET"])
def get_orders(userId):
    cursor = db.get_db().cursor()
    # fetch orders
    cursor.execute(
        f"SELECT * FROM Orders\
            WHERE CustomerId={userId} AND OrderStatus in ('cooking', 'ready', 'pending')"
    )
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))

    # json_data = [{**x} for x in json_data]
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = "application/json"
    return the_response


# Get a user's past orders
@customers.route("/past_orders/<userId>", methods=["GET"])
def get_past_orders(userId):
    cursor = db.get_db().cursor()
    # fetch orders
    cursor.execute(
        f"SELECT * FROM Orders\
            WHERE CustomerId={userId} AND OrderStatus in ('done', 'cancelled')"
    )
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))

    # json_data = [{**x} for x in json_data]
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = "application/json"
    return the_response
