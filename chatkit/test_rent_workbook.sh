#!/bin/bash
# Smoke test for the rent workbook API endpoint
# Generates a complete workbook with all 10 properties (KN01-KN10) and 12 months each

curl -X POST http://127.0.0.1:8000/api/rent-workbook \
  -H "Content-Type: application/json" \
  -d '{
    "template_version": "property_rents_received_v1",
    "year": 2025,
    "properties": [
      {
        "property_id": "KN01",
        "property_address": "123 Main St",
        "tenant_name": "John Doe",
        "period_months": 12,
        "rows": [
          {"month_number": 1, "month": "Jan", "rent_due": 1000, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1000, "total_received": 1000, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 2, "month": "Feb", "rent_due": 1000, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1000, "total_received": 1000, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 3, "month": "Mar", "rent_due": 1000, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1000, "total_received": 1000, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 4, "month": "Apr", "rent_due": 1000, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1000, "total_received": 1000, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 5, "month": "May", "rent_due": 1000, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1000, "total_received": 1000, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 6, "month": "Jun", "rent_due": 1000, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1000, "total_received": 1000, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 7, "month": "Jul", "rent_due": 1000, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1000, "total_received": 1000, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 8, "month": "Aug", "rent_due": 1000, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1000, "total_received": 1000, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 9, "month": "Sep", "rent_due": 1000, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1000, "total_received": 1000, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 10, "month": "Oct", "rent_due": 1000, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1000, "total_received": 1000, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 11, "month": "Nov", "rent_due": 1000, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1000, "total_received": 1000, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 12, "month": "Dec", "rent_due": 1000, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1000, "total_received": 1000, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""}
        ]
      },
      {
        "property_id": "KN02",
        "property_address": "456 Oak Ave",
        "tenant_name": "Jane Smith",
        "period_months": 12,
        "rows": [
          {"month_number": 1, "month": "Jan", "rent_due": 1200, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1200, "total_received": 1200, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 2, "month": "Feb", "rent_due": 1200, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1200, "total_received": 1200, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 3, "month": "Mar", "rent_due": 1200, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1200, "total_received": 1200, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 4, "month": "Apr", "rent_due": 1200, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1200, "total_received": 1200, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 5, "month": "May", "rent_due": 1200, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1200, "total_received": 1200, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 6, "month": "Jun", "rent_due": 1200, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1200, "total_received": 1200, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 7, "month": "Jul", "rent_due": 1200, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1200, "total_received": 1200, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 8, "month": "Aug", "rent_due": 1200, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1200, "total_received": 1200, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 9, "month": "Sep", "rent_due": 1200, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1200, "total_received": 1200, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 10, "month": "Oct", "rent_due": 1200, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1200, "total_received": 1200, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 11, "month": "Nov", "rent_due": 1200, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1200, "total_received": 1200, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 12, "month": "Dec", "rent_due": 1200, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1200, "total_received": 1200, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""}
        ]
      },
      {
        "property_id": "KN03",
        "property_address": "789 Pine Rd",
        "tenant_name": "Bob Johnson",
        "period_months": 12,
        "rows": [
          {"month_number": 1, "month": "Jan", "rent_due": 950, "housing_dept": null, "housing_paid": 0, "tenant_paid": 950, "total_received": 950, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 2, "month": "Feb", "rent_due": 950, "housing_dept": null, "housing_paid": 0, "tenant_paid": 950, "total_received": 950, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 3, "month": "Mar", "rent_due": 950, "housing_dept": null, "housing_paid": 0, "tenant_paid": 950, "total_received": 950, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 4, "month": "Apr", "rent_due": 950, "housing_dept": null, "housing_paid": 0, "tenant_paid": 950, "total_received": 950, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 5, "month": "May", "rent_due": 950, "housing_dept": null, "housing_paid": 0, "tenant_paid": 950, "total_received": 950, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 6, "month": "Jun", "rent_due": 950, "housing_dept": null, "housing_paid": 0, "tenant_paid": 950, "total_received": 950, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 7, "month": "Jul", "rent_due": 950, "housing_dept": null, "housing_paid": 0, "tenant_paid": 950, "total_received": 950, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 8, "month": "Aug", "rent_due": 950, "housing_dept": null, "housing_paid": 0, "tenant_paid": 950, "total_received": 950, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 9, "month": "Sep", "rent_due": 950, "housing_dept": null, "housing_paid": 0, "tenant_paid": 950, "total_received": 950, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 10, "month": "Oct", "rent_due": 950, "housing_dept": null, "housing_paid": 0, "tenant_paid": 950, "total_received": 950, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 11, "month": "Nov", "rent_due": 950, "housing_dept": null, "housing_paid": 0, "tenant_paid": 950, "total_received": 950, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 12, "month": "Dec", "rent_due": 950, "housing_dept": null, "housing_paid": 0, "tenant_paid": 950, "total_received": 950, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""}
        ]
      },
      {
        "property_id": "KN04",
        "property_address": "321 Elm St",
        "tenant_name": "Alice Brown",
        "period_months": 12,
        "rows": [
          {"month_number": 1, "month": "Jan", "rent_due": 1100, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1100, "total_received": 1100, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 2, "month": "Feb", "rent_due": 1100, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1100, "total_received": 1100, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 3, "month": "Mar", "rent_due": 1100, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1100, "total_received": 1100, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 4, "month": "Apr", "rent_due": 1100, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1100, "total_received": 1100, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 5, "month": "May", "rent_due": 1100, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1100, "total_received": 1100, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 6, "month": "Jun", "rent_due": 1100, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1100, "total_received": 1100, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 7, "month": "Jul", "rent_due": 1100, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1100, "total_received": 1100, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 8, "month": "Aug", "rent_due": 1100, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1100, "total_received": 1100, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 9, "month": "Sep", "rent_due": 1100, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1100, "total_received": 1100, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 10, "month": "Oct", "rent_due": 1100, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1100, "total_received": 1100, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 11, "month": "Nov", "rent_due": 1100, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1100, "total_received": 1100, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 12, "month": "Dec", "rent_due": 1100, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1100, "total_received": 1100, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""}
        ]
      },
      {
        "property_id": "KN05",
        "property_address": "654 Maple Dr",
        "tenant_name": "Charlie Davis",
        "period_months": 12,
        "rows": [
          {"month_number": 1, "month": "Jan", "rent_due": 1050, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1050, "total_received": 1050, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 2, "month": "Feb", "rent_due": 1050, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1050, "total_received": 1050, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 3, "month": "Mar", "rent_due": 1050, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1050, "total_received": 1050, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 4, "month": "Apr", "rent_due": 1050, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1050, "total_received": 1050, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 5, "month": "May", "rent_due": 1050, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1050, "total_received": 1050, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 6, "month": "Jun", "rent_due": 1050, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1050, "total_received": 1050, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 7, "month": "Jul", "rent_due": 1050, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1050, "total_received": 1050, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 8, "month": "Aug", "rent_due": 1050, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1050, "total_received": 1050, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 9, "month": "Sep", "rent_due": 1050, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1050, "total_received": 1050, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 10, "month": "Oct", "rent_due": 1050, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1050, "total_received": 1050, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 11, "month": "Nov", "rent_due": 1050, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1050, "total_received": 1050, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 12, "month": "Dec", "rent_due": 1050, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1050, "total_received": 1050, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""}
        ]
      },
      {
        "property_id": "KN06",
        "property_address": "987 Birch Ln",
        "tenant_name": "Diana Evans",
        "period_months": 12,
        "rows": [
          {"month_number": 1, "month": "Jan", "rent_due": 1150, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1150, "total_received": 1150, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 2, "month": "Feb", "rent_due": 1150, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1150, "total_received": 1150, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 3, "month": "Mar", "rent_due": 1150, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1150, "total_received": 1150, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 4, "month": "Apr", "rent_due": 1150, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1150, "total_received": 1150, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 5, "month": "May", "rent_due": 1150, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1150, "total_received": 1150, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 6, "month": "Jun", "rent_due": 1150, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1150, "total_received": 1150, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 7, "month": "Jul", "rent_due": 1150, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1150, "total_received": 1150, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 8, "month": "Aug", "rent_due": 1150, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1150, "total_received": 1150, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 9, "month": "Sep", "rent_due": 1150, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1150, "total_received": 1150, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 10, "month": "Oct", "rent_due": 1150, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1150, "total_received": 1150, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 11, "month": "Nov", "rent_due": 1150, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1150, "total_received": 1150, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 12, "month": "Dec", "rent_due": 1150, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1150, "total_received": 1150, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""}
        ]
      },
      {
        "property_id": "KN07",
        "property_address": "147 Cedar Ct",
        "tenant_name": "Edward Foster",
        "period_months": 12,
        "rows": [
          {"month_number": 1, "month": "Jan", "rent_due": 1250, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1250, "total_received": 1250, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 2, "month": "Feb", "rent_due": 1250, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1250, "total_received": 1250, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 3, "month": "Mar", "rent_due": 1250, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1250, "total_received": 1250, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 4, "month": "Apr", "rent_due": 1250, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1250, "total_received": 1250, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 5, "month": "May", "rent_due": 1250, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1250, "total_received": 1250, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 6, "month": "Jun", "rent_due": 1250, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1250, "total_received": 1250, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 7, "month": "Jul", "rent_due": 1250, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1250, "total_received": 1250, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 8, "month": "Aug", "rent_due": 1250, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1250, "total_received": 1250, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 9, "month": "Sep", "rent_due": 1250, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1250, "total_received": 1250, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 10, "month": "Oct", "rent_due": 1250, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1250, "total_received": 1250, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 11, "month": "Nov", "rent_due": 1250, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1250, "total_received": 1250, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 12, "month": "Dec", "rent_due": 1250, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1250, "total_received": 1250, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""}
        ]
      },
      {
        "property_id": "KN08",
        "property_address": "258 Spruce Way",
        "tenant_name": "Fiona Green",
        "period_months": 12,
        "rows": [
          {"month_number": 1, "month": "Jan", "rent_due": 900, "housing_dept": null, "housing_paid": 0, "tenant_paid": 900, "total_received": 900, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 2, "month": "Feb", "rent_due": 900, "housing_dept": null, "housing_paid": 0, "tenant_paid": 900, "total_received": 900, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 3, "month": "Mar", "rent_due": 900, "housing_dept": null, "housing_paid": 0, "tenant_paid": 900, "total_received": 900, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 4, "month": "Apr", "rent_due": 900, "housing_dept": null, "housing_paid": 0, "tenant_paid": 900, "total_received": 900, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 5, "month": "May", "rent_due": 900, "housing_dept": null, "housing_paid": 0, "tenant_paid": 900, "total_received": 900, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 6, "month": "Jun", "rent_due": 900, "housing_dept": null, "housing_paid": 0, "tenant_paid": 900, "total_received": 900, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 7, "month": "Jul", "rent_due": 900, "housing_dept": null, "housing_paid": 0, "tenant_paid": 900, "total_received": 900, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 8, "month": "Aug", "rent_due": 900, "housing_dept": null, "housing_paid": 0, "tenant_paid": 900, "total_received": 900, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 9, "month": "Sep", "rent_due": 900, "housing_dept": null, "housing_paid": 0, "tenant_paid": 900, "total_received": 900, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 10, "month": "Oct", "rent_due": 900, "housing_dept": null, "housing_paid": 0, "tenant_paid": 900, "total_received": 900, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 11, "month": "Nov", "rent_due": 900, "housing_dept": null, "housing_paid": 0, "tenant_paid": 900, "total_received": 900, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 12, "month": "Dec", "rent_due": 900, "housing_dept": null, "housing_paid": 0, "tenant_paid": 900, "total_received": 900, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""}
        ]
      },
      {
        "property_id": "KN09",
        "property_address": "369 Willow Pl",
        "tenant_name": "George Harris",
        "period_months": 12,
        "rows": [
          {"month_number": 1, "month": "Jan", "rent_due": 1300, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1300, "total_received": 1300, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 2, "month": "Feb", "rent_due": 1300, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1300, "total_received": 1300, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 3, "month": "Mar", "rent_due": 1300, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1300, "total_received": 1300, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 4, "month": "Apr", "rent_due": 1300, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1300, "total_received": 1300, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 5, "month": "May", "rent_due": 1300, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1300, "total_received": 1300, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 6, "month": "Jun", "rent_due": 1300, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1300, "total_received": 1300, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 7, "month": "Jul", "rent_due": 1300, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1300, "total_received": 1300, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 8, "month": "Aug", "rent_due": 1300, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1300, "total_received": 1300, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 9, "month": "Sep", "rent_due": 1300, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1300, "total_received": 1300, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 10, "month": "Oct", "rent_due": 1300, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1300, "total_received": 1300, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 11, "month": "Nov", "rent_due": 1300, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1300, "total_received": 1300, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 12, "month": "Dec", "rent_due": 1300, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1300, "total_received": 1300, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""}
        ]
      },
      {
        "property_id": "KN10",
        "property_address": "741 Aspen Blvd",
        "tenant_name": "Hannah Irving",
        "period_months": 12,
        "rows": [
          {"month_number": 1, "month": "Jan", "rent_due": 1400, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1400, "total_received": 1400, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 2, "month": "Feb", "rent_due": 1400, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1400, "total_received": 1400, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 3, "month": "Mar", "rent_due": 1400, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1400, "total_received": 1400, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 4, "month": "Apr", "rent_due": 1400, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1400, "total_received": 1400, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 5, "month": "May", "rent_due": 1400, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1400, "total_received": 1400, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 6, "month": "Jun", "rent_due": 1400, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1400, "total_received": 1400, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 7, "month": "Jul", "rent_due": 1400, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1400, "total_received": 1400, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 8, "month": "Aug", "rent_due": 1400, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1400, "total_received": 1400, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 9, "month": "Sep", "rent_due": 1400, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1400, "total_received": 1400, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 10, "month": "Oct", "rent_due": 1400, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1400, "total_received": 1400, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 11, "month": "Nov", "rent_due": 1400, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1400, "total_received": 1400, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""},
          {"month_number": 12, "month": "Dec", "rent_due": 1400, "housing_dept": null, "housing_paid": 0, "tenant_paid": 1400, "total_received": 1400, "month_balance_due": 0, "year_balance_due": 0, "remarks": ""}
        ]
      }
    ]
  }' \
  --output Rent_Workbook_2025.xlsx

echo ""
echo "✓ Downloaded Rent_Workbook_2025.xlsx"
echo "  Total: 10 properties × 12 months = 120 rows"
