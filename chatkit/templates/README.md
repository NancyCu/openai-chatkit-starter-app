# Rent Workbook Template

Place your finalized Excel template at `templates/.xlProperty_Rents_Received_Templatesx` so the API route can load it with `path.join(process.cwd(), 'templates', 'Property_Rents_Received_Template.xlsx')`. The template stays in the repository (not the vector store) so the server can access it without extra downloads.

Keep the same layout that the API expects:

- Sheets named `KN01` through `KN10` (or whichever property IDs you plan to export).
- Cells `B2`, `B4`, `H4`, and `H5` should be the year, property address, tenant name, and period, respectively.
- The monthly table should start at row 9 with columns `A` through `I` matching `month`, `rent`, `housing`, etc.

If the template changes, replace the XLSX file directly in this folder so the endpoint continues to build the workbooks with the correct styling.