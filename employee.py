class Employee:
    def __init__(self, employee_id, first_name, last_name, email, phone):
        self.__employee_id = employee_id
        self.__first_name = first_name
        self.__last_name = last_name
        self.__email = email
        self.__phone = phone

    # Getters
    def get_employee_id(self):
        return self.__employee_id

    def get_first_name(self):
        return self.__first_name

    def get_last_name(self):
        return self.__last_name

    def get_email(self):
        return self.__email

    def get_phone(self):
        return self.__phone

    # Setters
    def set_employee_id(self, employee_id):
        self.__employee_id = employee_id

    def set_first_name(self, first_name):
        self.__first_name = first_name

    def set_last_name(self, last_name):
        self.__last_name = last_name

    def set_email(self, email):
        self.__email = email

    def set_phone(self, phone):
        self.__phone = phone

    # CRUD Operations for Employee
    def add_employee(self, cursor):
        cursor.execute('''
            INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Phone) 
            VALUES (?, ?, ?, ?, ?)
        ''', (self.__employee_id, self.__first_name, self.__last_name, self.__email, self.__phone))

    def update_employee(self, cursor):
        cursor.execute('''
            UPDATE Employees 
            SET FirstName = ?, LastName = ?, Email = ?, Phone = ? 
            WHERE EmployeeID = ?
        ''', (self.__first_name, self.__last_name, self.__email, self.__phone, self.__employee_id))

    def delete_employee(self, cursor):
        cursor.execute('''
            DELETE FROM Employees WHERE EmployeeID = ?
        ''', (self.__employee_id,))

    @staticmethod
    def get_employee_by_id(cursor, employee_id):
        cursor.execute('''
            SELECT * FROM Employees WHERE EmployeeID = ?
        ''', (employee_id,))
        return cursor.fetchone()

class Department:
    def __init__(self, department_id, department_name, location):
        self.__department_id = department_id
        self.__department_name = department_name
        self.__location = location

    # Getters
    def get_department_id(self):
        return self.__department_id

    def get_department_name(self):
        return self.__department_name

    def get_location(self):
        return self.__location

    # Setters
    def set_department_id(self, department_id):
        self.__department_id = department_id

    def set_department_name(self, department_name):
        self.__department_name = department_name

    def set_location(self, location):
        self.__location = location

    # CRUD Operations for Department
    def add_department(self, cursor):
        cursor.execute('''
            INSERT INTO Departments (DepartmentID, DepartmentName, Location) 
            VALUES (?, ?, ?)
        ''', (self.__department_id, self.__department_name, self.__location))

    def update_department(self, cursor):
        cursor.execute('''
            UPDATE Departments 
            SET DepartmentName = ?, Location = ? 
            WHERE DepartmentID = ?
        ''', (self.__department_name, self.__location, self.__department_id))

    def delete_department(self, cursor):
        cursor.execute('''
            DELETE FROM Departments WHERE DepartmentID = ?
        ''', (self.__department_id,))

    @staticmethod
    def get_department_by_id(cursor, department_id):
        cursor.execute('''
            SELECT * FROM Departments WHERE DepartmentID = ?
        ''', (department_id,))
        return cursor.fetchone()
