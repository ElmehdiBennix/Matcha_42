social media network for couples

## **List of Entities**

USERS
PREFRANCES
PROFILES
SWIPES
MATCHES
INTRESTS
PICTURES
MESSAGES
NOTIFICATIONS

## **Relation ships**



## **Entitys**

USERS:
    uuid            | INT {PK}
    email           | VARCHAR(20)
    phoneNumber     | INT
    username        | VARCHAR(10)
    password        | VARCHAR(50)
    <!-- tokens          | BIGINT -->
    updated_at      | DATETIME
    created_at      | TIMESTAMP

PROFILES:
    uuid            | INT {PK}
    USERS           | INT {FK} 1:1
    PICTURES        | INT {FK} N:1
    INTRESTS        | INT {FK} N:1
    SWIPES          | INT {FK} N:1
    MATCHES         | INT {FK} N:N
    firstname       | VARCHAR()
    lastname        | VARCHAR()
    gender          | VARCHAR() ===> ENUM
    bio             | TEXT
    birthday        | INT
    country         | VARCHAR()
    city            | VARCHAR()
    fameRate        | FLOAT
    gpsCoordinates  | GEOMETRY

PREFRANCES:
    uuid            | INT {PK}
    oriontation     | VARCHAR()
    distanceMax     | SMALLINT
    distanceMin     | SMALLINT

SWIPES:
    uuid            | INT {PK}
    profile_id      | INT {FK} 1:N
    status          | VARCHAR(20) ==> ENUM {liked, dislike}

MATCHES:
    uuid            | INT {PK}
    profile_id      | INT {FK}
    profile_id      | INT {FK}
    <!-- GIFTS           | INT {FK} -->
    MESSAGES        | INT {FK}

MESSAGES:
    uuid            | INT {PK}
    MESSAGES        | TEXT
    read            | BOOL
    sentAt          | TIMESTAMP

NOTIFICATIONS:
    uuid            | INT {PK}
    type            | VARCHAR() ===> ENUM
    title           | VARCHAR()
    description     | TEXT

INTRESTS:
    uuid            | INT {PK}
    title           | VARCHAR()
    description     | TEXT

PICTURES:
    uuid            | INT {PK}
    pictureUrl      | VARCHAR()

REPORTS:
    uuid            | INT {PK}
    reason          | VARCHAR() ===> ENUM
    description     | TEXT

<!-- GIFTS:
    uuid            | INT {PK}
    name            | VARCHAR()
    PICTURES        | INT {FK}
    tokensCoast     | INT -->

### BONUS FUTURES:

## IDEAS
    INTRESTS:
    will be like a subreddit where intrets are where people can post
