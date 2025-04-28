import pyodbc
from employee import Employee  # Import the Employee class

# Connect with autocommit=True
conn = pyodbc.connect(
    'Driver={SQL Server};'
    'Server=HP-15EF2XXX;' 
    'Database=demo;' 
    'Trusted_Connection=yes;',
    autocommit=True
)

cursor = conn.cursor()

# Dynamically create the Employees table if it doesn't exist
cursor.execute('''
    IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Employees' AND xtype='U')
    CREATE TABLE Employees (
        EmployeeID INT PRIMARY KEY,
        FirstName NVARCHAR(50),
        LastName NVARCHAR(50),
        Email NVARCHAR(100),
        Phone NVARCHAR(15)
    )
''')
print("✅ Table 'Employees' created successfully, if it didn't already exist!")

# Ask how many records to insert
num_records = int(input("How many employees do you want to insert? "))

for _ in range(num_records):
    print("\nEnter Employee Details:")

    # Create an Employee object with user input
    employee_id = int(input("Employee ID: "))
    first_name = input("First Name: ")
    last_name = input("Last Name: ")
    email = input("Email: ")
    phone = input("Phone Number: ")

    # Create an Employee instance
    emp = Employee(employee_id, first_name, last_name, email, phone)

    # Insert into table using the Employee object data
    cursor.execute('''
        INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Phone)
        VALUES (?, ?, ?, ?, ?)
    ''', (emp.get_employee_id(), emp.get_first_name(), emp.get_last_name(), emp.get_email(), emp.get_phone()))

print(f"\n✅ {num_records} employee record(s) inserted successfully!")

# Optionally, fetch all inserted records for confirmation
cursor.execute("SELECT * FROM Employees")
rows = cursor.fetchall()

print("\nAll Employee Records:")
for row in rows:
    print(f"ID: {row.EmployeeID}, Name: {row.FirstName} {row.LastName}, Email: {row.Email}, Phone: {row.Phone}")

cursor.close()
conn.close()
