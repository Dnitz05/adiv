@echo off
echo Creating lunar_guide_templates table and seeding data...
echo.

REM Create the table first using SQL via PostgREST
curl -X POST "https://vanrixxzaawybszeuivb.supabase.co/rest/v1/rpc/exec" ^
  -H "apikey: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhbnJpeHh6YWF3eWJzemV1aXZiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyNzk3MDQ2NSwiZXhwIjoyMDQzNTQ2NDY1fQ.l4lwDL0cfG4LxJr-YH24EMNZ6T1FtWi-b5lPwWujVDw" ^
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhbnJpeHh6YWF3eWJzemV1aXZiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyNzk3MDQ2NSwiZXhwIjoyMDQzNTQ2NDY1fQ.l4lwDL0cfG4LxJr-YH24EMNZ6T1FtWi-b5lPwWujVDw" ^
  -H "Content-Type: application/json"

echo.
echo Done! Check the Supabase dashboard to verify.
pause
