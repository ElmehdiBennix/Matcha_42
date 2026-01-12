🛣 IMPLEMENTATION ROADMAP
Phase 1: Infrastructure & Core Libs

    Docker Setup:

        docker-compose.yml: Postgres service, Node service, React service, Nginx service.

        Nginx config: Route /api to Node container, / to React container.

    The Custom DB Library:

        Create a class Database.

        Implement methods: find(table, criteria), insert(table, data), update(table, data, where), query(rawSql, params).

        Constraint Check: Ensure it uses pg pool and parameterized queries strictly.

Phase 2: User Accounts (Auth)

    User Model: Schema creation (raw SQL migration script).

    Registration: Zod validation -> Argone2id Hashing -> SQL Insert -> Send Email (Nodemailer).

    Auth Middleware: Verify JWT from HTTPOnly Cookie. If valid, attach user_id to req.

Phase 3: Profile Management

    Image Upload:

        Frontend: Crop image (use react-easy-crop).

        Backend: Save base64 or file stream to local Docker volume (e.g., /app/uploads).

    Profile API: Update Bio, Gender, Sexual Pref, Tags.

    GPS: Receive lat/lon from frontend. Fallback: Use ipinfo API on backend if user denies GPS.

Phase 4: Browsing & Research (The Hard Part)

    The Monster Query: Write the advanced SQL query handling the filtering and sorting.

    Pagination: Implement OFFSET and LIMIT in your custom library to handle 500+ users smoothly.

Phase 5: Interactions & Chat

    Likes: Toggle logic. Check for mutual like -> Create "Match".

    Socket.io:

        Server: io.on('connection'), socket.join(userId).

        Chat: Emit event private_message -> Save to DB -> Relay to receiver's socket room.

Phase 6: Seeding & Testing

    The Seeder: Write a script using Faker.js.

        Generate 500 users.

        Crucial: Ensure coordinates are generated clustered around a specific city (e.g., Casablanca), otherwise, your "Distance" filter will return 0 results during the defense.
