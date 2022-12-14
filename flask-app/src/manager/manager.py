from flask import Blueprint, request, jsonify, make_response
import json
from src import db

manager = Blueprint("manager", __name__)

# Get a list of all Employees
@manager.route("/employees", methods=["GET"])
def get_employees():
    cursor = db.get_db().cursor()
    cursor.execute("SELECT * FROM Employee")
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    json_data = [
        {**x, "label": x["FirstName"] + " " + x["LastName"], "value": x["EmployeeId"]}
        for x in json_data
    ]
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = "application/json"
    return the_response


# Get info about an employee
@manager.route("/employee/<staffId>", methods=["GET"])
def get_employee(staffId):
    cursor = db.get_db().cursor()
    cursor.execute(f"SELECT * FROM Employee WHERE EmployeeId = {staffId}")
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchone()
    json_data = dict(zip(row_headers, theData))

    cursor.execute(f"SELECT * FROM EmployeeRole WHERE EmployeeId = {staffId}")
    row_headers = [x[0] for x in cursor.description]
    roles = []
    theData = cursor.fetchall()
    for row in theData:
        roles.append(dict(zip(row_headers, row)))

    json_data["roles"] = [x["title"] for x in roles]

    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = "application/json"
    return the_response


# Get a list of all Customers
@manager.route("/customers", methods=["GET"])
def get_customers():
    cursor = db.get_db().cursor()
    cursor.execute("SELECT * FROM Customer")
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    json_data = [
        {**x, "label": x["FirstName"] + " " + x["LastName"], "value": x["CustomerId"]}
        for x in json_data
    ]
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = "application/json"
    return the_response


# Get info about a customer
@manager.route("/customer/<userId>", methods=["GET"])
def get_customer(userId):
    cursor = db.get_db().cursor()
    cursor.execute(f"SELECT * FROM Customer WHERE CustomerId = {userId}")
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchone()
    json_data = dict(zip(row_headers, theData))

    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = "application/json"
    return the_response


# Fire an employee
@manager.route("/fire/<staffId>", methods=["POST"])
def fire(staffId):
    cursor = db.get_db().cursor()
    cursor.execute(
        f"UPDATE Employee SET ExitDate = CURRENT_TIMESTAMP, CurrentEmployee = FALSE WHERE EmployeeId = {staffId}"
    )
    cursor.execute("commit")
    the_response = make_response(jsonify({"success": "Fired the employee"}))
    the_response.status_code = 200
    the_response.mimetype = "application/json"
    return the_response
