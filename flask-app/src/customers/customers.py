from flask import Blueprint, request, jsonify, make_response
import json
from src import db
from random import randint


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


# Get all customers from the DB
@customers.route("/place_order/<restId>/<userId>", methods=["POST"])
def place_order(restId, userId):
    data = request.json

    if not isinstance(data, list) or [
        1
        for x in data
        if not isinstance(x, dict)
        or not "type" in x
        or not "value" in x
        or x["type"] not in ("dish", "drink")
    ]:
        the_response = make_response(
            jsonify(
                {"error": "Must be a list of {type: 'dish' | 'drink', 'value': int}"}
            )
        )
        the_response.status_code = 400
        the_response.mimetype = "application/json"
        return the_response

    cursor = db.get_db().cursor()

    dishes = [x["value"] for x in data if x["type"] == "dish"]
    drinks = [x["value"] for x in data if x["type"] == "drink"]
    total_price = 0
    prep_time = 0

    cursor.execute(
        f"SELECT Price, PreparationTime FROM Dish\
        WHERE MenuId in ({','.join(str(x) for x in dishes + [0])})"
    )
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    for thing in json_data:
        total_price += thing["Price"]
        prep_time += thing["PreparationTime"]

    cursor.execute(
        f"SELECT Price FROM Beverage\
        WHERE DrinkId in ({','.join(str(x) for x in drinks + [0])})"
    )
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    for thing in json_data:
        total_price += thing["Price"]

    cursor.execute(
        f"INSERT INTO Orders (CustomerId, EmployeeId, RestaurantId, TotalPrice, PredictedTotalPrepTime, OrderStatus)\
            VALUES ({userId}, {randint(1,4)+(int(restId)-1)*5}, {restId}, {total_price}, {prep_time}, 'pending')"
    )
    orderId = cursor.lastrowid

    if dishes:
        cursor.execute(
            f"INSERT INTO OrderDish (OrderId, MenuId) VALUES {','.join(f'({orderId}, {id})' for id in dishes)}"
        )
    if drinks:
        cursor.execute(
            f"INSERT INTO OrderBeverage (OrderId, DrinkId) VALUES {','.join(f'({orderId}, {id})' for id in drinks)}"
        )

    cursor.execute("commit")

    the_response = make_response(jsonify({"orderId": orderId}))
    the_response.status_code = 200
    the_response.mimetype = "application/json"
    return the_response
