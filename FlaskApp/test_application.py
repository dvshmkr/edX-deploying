''' Unit testing file '''

import unittest
import json
from application import application

class TestFlaskApp(unittest.TestCase):
    """ Test Class """

    def setUp(self):
        """Set up test client and context."""
        self.app = application.test_client()
        self.app.testing = True

    # def tearDown(self):
    #     """Clean up after tests (if needed)."""
    #     pass

    def test_index_route(self):
        """Test the index route returns a 200 status code."""
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Welcome', response.data)

    def test_get_challenge_route_get(self):
        """Test the GET request to the /api/v1.0/get_challenge route."""
        response = self.app.get('/api/v1.0/get_challenge')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.content_type, 'application/json')
        data = json.loads(response.get_data(as_text=True))
        self.assertIsInstance(data, dict)
        self.assertIn('challenge', data)

    def test_get_route_miles_post_valid_routes(self):
        """Test a POST request to /api/v1.0/get_route_miles with valid routes."""
        valid_data = {"1": {"Route": "KLAX,KJFK"}, "2": {"Route": "KJFK,KLAX"}}
        response = self.app.post('/api/v1.0/get_route_miles',
            data=json.dumps(valid_data), content_type='application/json')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.content_type, 'application/json')
        data = json.loads(response.get_data(as_text=True))
        self.assertIn('1', data)
        self.assertIn('2', data)
        self.assertIn('Miles', data['1'])
        self.assertIn('Miles', data['2'])
        self.assertIsInstance(data['1']['Miles'], (int, float))
        self.assertIsInstance(data['2']['Miles'], (int, float))

    def test_get_route_miles_post_invalid_routes(self):
        """Test a POST request to /api/v1.0/get_route_miles with invalid routes."""
        invalid_data = {"1": {"Route": "INVALID"}, "2": {"Route": "ANOTHER_INVALID"}}
        response = self.app.post('/api/v1.0/get_route_miles',
            data=json.dumps(invalid_data), content_type='application/json')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.content_type, 'application/json')
        data = json.loads(response.get_data(as_text=True))
        self.assertIn('1', data)
        self.assertIn('2', data)
        self.assertIn('Miles', data['1'])
        self.assertIn('Miles', data['2'])
        # Depending on your logic, you might assert that the miles are 0 or
        # that a specific error is returned
        # Adjust the assertion below based on your application's behavior for invalid routes
        self.assertIsInstance(data['1']['Miles'], (int, float))
        self.assertIsInstance(data['2']['Miles'], (int, float))

    # Add more test methods for your other routes and functionalities

if __name__ == '__main__':
    unittest.main()
