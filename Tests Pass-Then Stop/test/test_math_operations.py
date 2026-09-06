import unittest
from math_operations import add, subtract

class TestMathOperations(unittest.TestCase):
    def test_add(self):
        self.assertEqual(add(1, 2), 3)

    def test_subtract(self):
        self.assertEqual(subtract(5, 3), 2)

    def test_add_negative(self):
        self.assertEqual(add(-1, -1), -2)

