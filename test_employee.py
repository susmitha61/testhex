# test_employee.py

import pytest
from employee import Employee, Department
from unittest.mock import MagicMock

@pytest.fixture
def mock_cursor():
    return MagicMock()

@pytest.fixture
def sample_employee():
    return Employee(1, "John", "Doe", "john.doe@example.com", "123-456-7890")

@pytest.fixture
def sample_department():
    return Department(1, "HR", "New York")

# Test Employee Class
def test_add_employee(sample_employee, mock_cursor):
    sample_employee.add_employee(mock_cursor)
    mock_cursor.execute.assert_called_once()

def test_update_employee(sample_employee, mock_cursor):
    sample_employee.update_employee(mock_cursor)
    mock_cursor.execute.assert_called_once()

def test_delete_employee(sample_employee, mock_cursor):
    sample_employee.delete_employee(mock_cursor)
    mock_cursor.execute.assert_called_once()

def test_get_employee_by_id(mock_cursor):
    mock_cursor.fetchone.return_value = (1, "John", "Doe", "john.doe@example.com", "123-456-7890")
    result = Employee.get_employee_by_id(mock_cursor, 1)
    mock_cursor.execute.assert_called_once()
    assert result[0] == 1
    assert result[1] == "John"

# Test Department Class
def test_add_department(sample_department, mock_cursor):
    sample_department.add_department(mock_cursor)
    mock_cursor.execute.assert_called_once()

def test_update_department(sample_department, mock_cursor):
    sample_department.update_department(mock_cursor)
    mock_cursor.execute.assert_called_once()

def test_delete_department(sample_department, mock_cursor):
    sample_department.delete_department(mock_cursor)
    mock_cursor.execute.assert_called_once()

def test_get_department_by_id(mock_cursor):
    mock_cursor.fetchone.return_value = (1, "HR", "New York")
    result = Department.get_department_by_id(mock_cursor, 1)
    mock_cursor.execute.assert_called_once()
    assert result[1] == "HR"
