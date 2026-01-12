🔒 SECURITY (Enterprise Grade)

This is the most critical section for passing. A single breach = Score 0.
1. SQL Injection (SQLi)

    The Threat: User enters ' OR 1=1 -- in the login field.

    The Defense: Parameterized Queries ONLY.

        Never do this: query(SELECT * FROM users WHERE name = '${name}')

        Always do this: query('SELECT * FROM users WHERE name = $1', [name])

        Your Custom DB Library must enforce this. If a method accepts a string without parameters, it should throw a warning or error.

2. Cross-Site Scripting (XSS)

    The Threat: User puts <script>alert('hacked')</script> in their bio.

    The Defense:

        Frontend: React automatically escapes content in {variable}. Never use dangerouslySetInnerHTML.

        Backend: Sanitize inputs before saving specific text fields. Use a library like dompurify or xss on the backend for bio/messages.

        Headers: Configure Helmet.js in Express to set strict Content-Security-Policy (CSP).

3. Authentication Security

    Password Storage: NEVER store plain text. Use Argon2id (newer/better than Bcrypt).

    Session Hijacking: Do not store JWT in localStorage. Store it in an HttpOnly, Secure, SameSite=Strict Cookie. This prevents XSS from reading your token.

    CSRF: If using Cookies, you need CSRF protection. Implement a Double Submit Cookie pattern or use a CSRF middleware.

4. File Upload Security

    The Threat: User uploads shell.php.jpg.

    The Defense:

        Check file extension.

        Check Magic Numbers: Read the first few bytes of the buffer to confirm it is actually a JPEG/PNG.

        Rename the file on server (e.g., uuid-v4.jpg) so the original filename is lost.

5. Information Disclosure

    Error Handling: In production mode, never send stack traces to the client. Send 500 Internal Server Error with a generic message.

    ID Enumeration: Use UUIDs (v4) for User IDs instead of auto-increment integers (1, 2, 3). This prevents people from guessing how many users you have or scraping profiles by iterating IDs.

6. Input Validation (The First Line of Defense)

    Use Zod for every single POST/PUT route.

    Validate email format, password complexity (Regex), max length of bio, valid date of birth (must be 18+).

    If validation fails, return 400 Bad Request immediately. Don't even touch the DB.
