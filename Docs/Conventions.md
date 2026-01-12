The Coding Standards

ECHNICAL TIPS (Must Know / Must Do)

    SQL Geography:
    Since you might not be allowed to use PostGIS extensions (check subject), use the Haversine Formula inside your SQL query to calculate distance.
    code SQL


-- Example snippet for your raw query
(6371 * acos(cos(radians($lat)) * cos(radians(latitude)) * cos(radians(longitude) - radians($lon)) + sin(radians($lat)) * sin(radians(latitude)))) AS distance



The "Repository Pattern":
Do not write SQL inside your Routes.

    Bad: app.get('/users', (req, res) => db.query('SELECT...'))

    Good: app.get('/users', UserController.getAll) -> calls UserModel.findAll() -> calls DB.query().

Handling "Mobile Friendly":
The subject requires the layout to be acceptable on small screens.

    Use CSS Grid or Flexbox.

    In Chrome DevTools, constantly test with the "iPhone SE" preset.

    Hamburger menu for the header is practically mandatory.

Handling "No ORM":
Your biggest pain point will be Joins. When you fetch a user and their tags, you will get multiple rows (one per tag).

    Tip: Use array_agg in Postgres to collapse tags into a single row.

    SELECT u.*, array_agg(t.tag_name) as tags FROM users u JOIN ... GROUP BY u.id
