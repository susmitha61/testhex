import pyodbc
from employee import Employee, Department

# Connect to the SQL Server database
conn = pyodbc.connect(
    'Driver={SQL Server};'
    'Server=HP-15EF2XXX;' 
    'Database=demo;' 
    'Trusted_Connection=yes;',
    autocommit=True
)

cursor = conn.cursor()

# Create Employees table if it doesn't exist
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

# Create Departments table if it doesn't exist
cursor.execute('''
    IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Departments' AND xtype='U')
    CREATE TABLE Departments (
        DepartmentID INT PRIMARY KEY,
        DepartmentName NVARCHAR(50),
        Location NVARCHAR(50)
    )
''')

# Add some employee and department records
emp = Employee(11, 'John', 'Doe', 'john.doe@example.com', '123-456-7890')
emp.add_employee(cursor)

dept = Department(12, 'HR', 'New York')
dept.add_department(cursor)

# Update an employee's details
emp.set_first_name('Jane')
emp.update_employee(cursor)

# Retrieve an employee by ID
emp_data = Employee.get_employee_by_id(cursor, 1)
print('Employee Details:', emp_data)

# Delete an employee
emp.delete_employee(cursor)

# Close the cursor and connection
cursor.close()
conn.close()

print('✅ CRUD operations completed successfully!')
