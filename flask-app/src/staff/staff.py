from flask import Blueprint, request, jsonify, make_response
import json
from src import db


staff = Blueprint("staff", __name__)

# Get customer information
@staff.route("/staff_info/<userId>", methods=["GET"])
def get_staff(userId):
    cursor = db.get_db().cursor()
    cursor.execute(f"SELECT * FROM Employee WHERE EmployeeId = {userId}")
    row_headers = [x[0] for x in cursor.description]
    theData = cursor.fetchone()
    json_data = dict(zip(row_headers, theData))
    name = json_data.pop("FirstName", "") + " " + json_data.pop("LastName", "")
    json_data["Name"] = name
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = "application/json"
    return the_response


# Get a staff's current order dishes
@staff.route("/order_dishes/<userId>", methods=["GET"])
def get_dishes(userId):
    cursor = db.get_db().cursor()
    # fetch orders
    cursor.execute(
        f"SELECT * FROM Orders o JOIN OrderDish od JOIN Dish d\
            ON o.OrderId = od.OrderId AND od.MenuId = d.MenuId\
            WHERE EmployeeId={userId} AND OrderStatus in ('cooking', 'ready', 'pending')"
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


# Get a staff's current order drinks
@staff.route("/order_drinks/<userId>", methods=["GET"])
def get_drinks(userId):
    cursor = db.get_db().cursor()
    # fetch orders
    cursor.execute(
        f"SELECT * FROM Orders o JOIN OrderBeverage ob JOIN Beverage b\
            ON o.OrderId = ob.OrderId AND ob.DrinkId = b.DrinkId\
            WHERE EmployeeId={userId} AND OrderStatus in ('cooking', 'ready', 'pending')"
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


# update an order
@staff.route("/update_order/<orderId>/<status>", methods=["POST"])
def update_order(orderId, status):
    cursor = db.get_db().cursor()
    # fetch orders
    cursor.execute(
        f'UPDATE Orders SET OrderStatus = "{status}" WHERE OrderId = {orderId}'
    )
    cursor.execute("commit")

    # json_data = [{**x} for x in json_data]
    the_response = make_response(jsonify({"result": "Order updated"}))
    the_response.status_code = 200
    the_response.mimetype = "application/json"
    return the_response
