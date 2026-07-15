from flask import Flask, request, redirect, render_template_string
from pymongo import MongoClient

app = Flask(__name__)

# MongoDB Connection
client = MongoClient("mongodb://localhost:27017/")
db = client["student_db"]
collection = db["students"]

collection.create_index("sid", unique=True, sparse=True)

# HTML Template
html = """
<!DOCTYPE html>
<html>
<head>
    <title>Student Management System</title>
    <style>
        body {
            font-family: Arial;
            margin: 40px;
            background: #f4f4f4;
        }
        h1 {
            color: #333;
        }
        form {
            background: white;
            padding: 20px;
            width: 350px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px gray;
        }
        input {
            width: 95%;
            padding: 8px;
            margin: 5px 0;
        }
        button {
            padding: 10px;
            background: green;
            color: white;
            border: none;
            cursor: pointer;
            width: 100%;
        }
        table {
            margin-top: 20px;
            border-collapse: collapse;
            width: 80%;
            background: white;
        }
        th, td {
            border: 1px solid black;
            padding: 10px;
            text-align: center;
        }
        a {
            text-decoration: none;
            color: red;
        }
    </style>
</head>
<body>

    <h1>Student Management System</h1>

    <form method="POST" action="/add">
        <input type="text" name="sid" placeholder="Student ID" required>
        <input type="text" name="name" placeholder="Name" required>
        <input type="number" name="age" placeholder="Age" required>
        <input type="text" name="dept" placeholder="Department" required>
        <input type="text" name="blood" placeholder="Blood Group" required>
        <button type="submit">Add Student</button>
    </form>

    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Age</th>
            <th>Dept</th>
            <th>Blood</th>
            <th>Action</th>
        </tr>

        {% for s in students %}
        <tr>
            <td>{{ s.sid }}</td>
            <td>{{ s.name }}</td>
            <td>{{ s.age }}</td>
            <td>{{ s.dept }}</td>
            <td>{{ s.blood }}</td>
            <td><a href="/delete/{{ s.sid }}">Delete</a></td>
        </tr>
        {% endfor %}
    </table>

</body>
</html>
"""

# Home page
@app.route("/")
def home():
    students = list(collection.find())
    return render_template_string(html, students=students)


# Add Student
@app.route("/add", methods=["POST"])
def add():
    student = {
        "sid": request.form["sid"],
        "name": request.form["name"],
        "age": int(request.form["age"]),
        "dept": request.form["dept"],
        "blood": request.form["blood"]
    }

    try:
        collection.insert_one(student)
    except Exception as e:
        print(e)

    return redirect("/")


# Delete Student
@app.route("/delete/<sid>")
def delete(sid):
    collection.delete_one({"sid": sid})
    return redirect("/")


if __name__ == "__main__":
    app.run(debug=True)