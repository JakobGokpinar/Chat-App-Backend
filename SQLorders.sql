onCREATE TABLE users(
    username VARCHAR(25),
    password VARCHAR(25)
)
CREATE TABLE requeststable(
    id INT PRIMARY KEY,
    sender VARCHAR(25),
    receiver VARCHAR(25)
)

CREATE TABLE friends(
    person1 VARCHAR(25),
    person2 VARCHAR(25)
)

CREATE TABLE blacklist(
    blocker VARCHAR(25),
    blocked VARCHAR(25)
)

CREATE TABLE messagetable(
    sender VARCHAR(25),
    receiver VARCHAR(25),
    msg VARCHAR(255)

)

CREATE TABLE notiftable(


)


DROP PROCEDURE addFriend;
DROP PROCEDURE getFriends;
DROP PROCEDURE deleteRequest;
DROP PROCEDURE getRequests;

DELIMITER //
CREATE PROCEDURE getRequests(person VARCHAR(25))
BEGIN
    SELECT sender as request FROM requeststable WHERE receiver=person;
END//


DELIMITER //
CREATE PROCEDURE getFriends(person VARCHAR(25))
BEGIN
    CREATE TEMPORARY TABLE tmp2_erasmus_muharrem AS 
    (
        SELECT id, sender, receiver, msg, IFNULL(history, NOW()) as history FROM (
            SELECT id, sender, receiver, msg, history from messagetable WHERE
            messagetable.receiver = person
            UNION
            SELECT id, receiver as sender, sender as receiver, msg, history from messagetable WHERE 
            messagetable.sender = person 
        ) AS `mehmet_bahceli`
    );

    SELECT temp_friends.friend, IFNULL(temp_notif.counts, 0) as counts, IFNULL(temp_messages.msg, "no message") as lastmsg, IFNULL( TIMEDIFF(NOW(), temp_messages.history), "no date") as lastdate
    FROM 
    (
        SELECT person2 as friend  FROM friends WHERE person1= person
        UNION
        SELECT person1 as friend FROM friends WHERE person2=person
    ) AS `temp_friends`
    LEFT JOIN 
    (
        SELECT sender, counts FROM notiftable WHERE receiver = person
    ) AS `temp_notif`
    ON temp_notif.sender = temp_friends.friend
    LEFT JOIN
    ( 
        SELECT * FROM (
            SELECT DISTINCT sender, receiver, msg, history FROM 
            `tmp2_erasmus_muharrem`
            ORDER BY id DESC LIMIT 18446744073709551615  
        ) AS `mehmet_bacheli_2`
        GROUP BY
        sender, receiver
    ) AS `temp_messages`
    ON temp_messages.sender = temp_friends.friend;
END//

DELIMITER //
CREATE PROCEDURE addFriend(adder VARCHAR(25), added VARCHAR(25))
BEGIN
    call deleteRequest(adder,added);
    INSERT INTO friends (person1, person2) VALUES(adder, added);
END//

DELIMITER //
CREATE PROCEDURE deleteRequest(person1 VARCHAR(25), person2 VARCHAR(25))
BEGIN
    DELETE FROM requeststable WHERE (receiver=person1 AND sender=person2) OR (sender=person2 AND receiver=person1);
END//

DELIMITER //
CREATE PROCEDURE rejectUser(blocker VARCHAR(25), blocked VARCHAR(25)) 
BEGIN
    DELETE FROM requeststable WHERE receiver=blocker AND sender=blocked;
    INSERT INTO blacklist(blocker, blocked) VALUES(blocker, blocked);
END//
    
DELIMITER //
CREATE PROCEDURE getRejected(blockerUser VARCHAR(25), blockedUser VARCHAR(25))
BEGIN
    SELECT blocker as rejectuser FROM blacklist WHERE blocker = blockerUser AND blocked = blockedUser;
END//

DELIMITER //
CREATE PROCEDURE sendMessage(sender VARCHAR(25), receiver VARCHAR(25), msg VARCHAR(255))
BEGIN
    INSERT INTO messagetable(sender,receiver,msg,history) VALUES(sender, receiver, msg, NOW());
    CALL addNotification(sender, receiver, 1);
END//

DELIMITER //
CREATE PROCEDURE getMessage(sender VARCHAR(25), receiver VARCHAR(25))
BEGIN
    SELECT * FROM messagetable WHERE messagetable.sender = sender AND messagetable.receiver = receiver
    UNION
    SELECT * FROM messagetable WHERE messagetable.sender = receiver AND messagetable.receiver = sender
    ORDER BY id;
END//

DELIMITER //
CREATE PROCEDURE addNotification(sender VARCHAR(25), receiver VARCHAR(25), counts INT)
BEGIN
    IF (EXISTS (SELECT * FROM notiftable WHERE notiftable.sender = sender AND notiftable.receiver = receiver))
    THEN
        UPDATE notiftable SET notiftable.counts = notiftable.counts + counts WHERE notiftable.sender = sender AND notiftable.receiver = receiver;
    ELSE
        INSERT INTO notiftable(sender, receiver, counts) VALUES(sender, receiver, counts);
    END IF;
END//

DELIMITER //
CREATE PROCEDURE getNotification(receiver VARCHAR(25), sender VARCHAR(25))
BEGIN
    IF (EXISTS (SELECT * FROM notiftable WHERE notiftable.sender = sender AND notiftable.receiver = receiver))
    THEN
        SELECT (counts) FROM notiftable WHERE notiftable.sender = sender AND notiftable.receiver = receiver;
    ELSE
        SELECT 0 as counts;
    END IF;
END//

DELIMITER //
CREATE PROCEDURE setNotification(receiver VARCHAR(25), sender VARCHAR(25), sayi INTEGER)
BEGIN
    UPDATE notiftable SET notiftable.counts = sayi WHERE notiftable.sender = sender AND notiftable.receiver = receiver;
END //


// çöp
SELECT DISTINCT sender, receiver, msg FROM 
        (SELECT sender, receiver, msg from messagetable WHERE messagetable.sender = person OR messagetable.receiver = person)
        AS `tmp_tmp_msg`
        GROUP BY 
        sender, receiver


SELECT DISTINCT sender, receiver, msg FROM (
SELECT sender as receiver, receiver as sender, msg FROM (
SELECT DISTINCT sender, receiver, msg FROM 
(SELECT sender, receiver, msg from messagetable WHERE messagetable.sender = person OR messagetable.receiver = person)
AS `tmp_tmp_tmp_msg`
GROUP BY 
sender, receiver 
) WHERE sender = person AS `tmp_tmp_msg` 
UNION BY 
SELECT sender, receiver, msg
(SELECT DISTINCT sender, receiver, msg FROM 
(SELECT sender, receiver, msg from messagetable WHERE messagetable.sender = person OR messagetable.receiver = person)
AS `tmp_tmp_tmp_msg`
GROUP BY 
sender, receiver 
) WHERE receiver = person AS `tmp_tmp_msg2` 
)
GROUP BY sender, receiver




LEFT JOIN
    (
        SELECT DISTINCT sender, receiver, msg FROM 
        (SELECT sender, receiver, msg from messagetable WHERE messagetable.sender = person OR messagetable.receiver = person ORDER BY id DESC)
        AS `tmp_tmp_tmp_msg`
        GROUP BY 
        sender, receiver 
    )AS `temp_messages`
    ON temp_messages.sender = temp_friends.friend





    BEGIN
	SELECT temp_friends.friend, IFNULL(temp_notif.counts, 0) as counts, IFNULL(temp_messages.msg, "no message") as lastmsg, IFNULL( TIMEDIFF(NOW(), temp_messages.history), "no date") as lastdate
    FROM 
    (
        SELECT person2 as friend  FROM friends WHERE person1= person
        UNION
        SELECT person1 as friend FROM friends WHERE person2=person
    ) AS `temp_friends`
    LEFT JOIN 
    (
        SELECT sender, counts FROM notiftable WHERE receiver = person
    ) AS `temp_notif`
    ON temp_notif.sender = temp_friends.friend
    LEFT JOIN
    (
        SELECT DISTINCT sender, receiver, msg, history FROM 
        (
            SELECT sender, receiver, msg, history from messagetable WHERE messagetable.sender = person
            OR messagetable.receiver = person ORDER BY id DESC LIMIT 18446744073709551615
        )
        AS `tmp_erasmus_muharrem`
        GROUP BY 
        sender, receiver  
    )AS `temp_messages`
    ON temp_messages.sender = temp_friends.friend;
END