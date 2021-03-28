/*
mysql procedures to execute processes in database
*/

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

--Remove the formerly created procedures
DROP PROCEDURE addFriend;
DROP PROCEDURE getFriends;
DROP PROCEDURE deleteRequest;
DROP PROCEDURE getRequests;

--Gets logged in user's friends requests from database where person is the logged in user
DELIMITER //
CREATE PROCEDURE getRequests(person VARCHAR(25))
BEGIN
    SELECT sender as request FROM requeststable WHERE receiver=person;
END//

--Gets the friends of a user(person).
DELIMITER //
CREATE PROCEDURE getFriends(person VARCHAR(25))
BEGIN
/*
Create a temporary table to not to interact with real database each time. 
Collect all messages where person is either sender or receiver.
*/
    CREATE TEMPORARY TABLE temp_temporary AS 
    (
        SELECT id, sender, receiver, msg, IFNULL(history, NOW()) as history FROM 
        (
            SELECT id, sender, receiver, msg, history from messagetable 
                WHERE messagetable.receiver = person
            UNION
            SELECT id, receiver as sender, sender as receiver, msg, history from messagetable 
                WHERE messagetable.sender = person 
        ) AS `tmp`
    );

    --Returns friend,   notification count,     last message and    last chat date      from the temp_s that created below.
    SELECT temp_friends.friend, IFNULL(temp_notif.counts, 0) as counts, IFNULL(temp_messages.msg, "no message") as lastmsg, IFNULL(TIMEDIFF(NOW(), temp_messages.history), "no date") as lastdate
    
    FROM --Gets friends of the person from friends table and stores them as temp_friends
    (
        SELECT person2 as friend  FROM friends WHERE person1=person
        UNION
        SELECT person1 as friend FROM friends WHERE person2=person
    ) AS `temp_friends`
    LEFT JOIN --Gets notification count to the person when the sender is one of his friends and stores it as temp_notif.
    (
        SELECT sender, counts FROM notiftable WHERE receiver = person
    ) AS `temp_notif`
    ON temp_notif.sender = temp_friends.friend
    LEFT JOIN --Gets a message's sender,receiver,content and date from the temporary table temp_temporary when the sender is a friend.
    ( 
        SELECT * FROM (
            SELECT DISTINCT sender, receiver, msg, history FROM 
            `temp_temporary`
            ORDER BY id DESC LIMIT 18446744073709551615  
        ) AS `tmp`
        GROUP BY
        sender, receiver
    ) AS `temp_messages`
    ON temp_messages.sender = temp_friends.friend
    ORDER BY lastdate;
END//

--Adds the users as friends into the friends table. Happens when one accepts the other's friend request. 
DELIMITER //
CREATE PROCEDURE addFriend(adder VARCHAR(25), added VARCHAR(25))
BEGIN
    call deleteRequest(adder,added);
    INSERT INTO friends (person1, person2) VALUES(adder, added);
END//

--Removes the users from friend request table when they become friends. 
DELIMITER //
CREATE PROCEDURE deleteRequest(person1 VARCHAR(25), person2 VARCHAR(25))
BEGIN
    DELETE FROM requeststable WHERE (receiver=person1 AND sender=person2) OR (sender=person2 AND receiver=person1);
END//

--Adds user to the blacklist if his friend request is rejected by the receiver and removes both from friend request table.
DELIMITER //
CREATE PROCEDURE rejectUser(blocker VARCHAR(25), blocked VARCHAR(25)) 
BEGIN
    DELETE FROM requeststable WHERE receiver=blocker AND sender=blocked;
    INSERT INTO blacklist(blocker, blocked) VALUES(blocker, blocked);
END//

--Gets the other users blocked by the user.  
DELIMITER //
CREATE PROCEDURE getRejected(blockerUser VARCHAR(25), blockedUser VARCHAR(25))
BEGIN
    SELECT blocker as rejectuser FROM blacklist WHERE blocker = blockerUser AND blocked = blockedUser;
END//

--Adds typed message to the message table with a sender,receiver,message and date. 
DELIMITER //
CREATE PROCEDURE sendMessage(sender VARCHAR(25), receiver VARCHAR(25), msg VARCHAR(255))
BEGIN
    INSERT INTO messagetable(sender,receiver,msg,history) VALUES(sender, receiver, msg, NOW());
    CALL addNotification(sender, receiver, 1);
END//

--Gets the all messages between to users.
DELIMITER //
CREATE PROCEDURE getMessage(sender VARCHAR(25), receiver VARCHAR(25))
BEGIN
    SELECT * FROM messagetable WHERE messagetable.sender = sender AND messagetable.receiver = receiver
    UNION
    SELECT * FROM messagetable WHERE messagetable.sender = receiver AND messagetable.receiver = sender
    ORDER BY id
    DESC LIMIT 125
    ORDER BY id;
END//

--Adds a new notification to notification table.
DELIMITER //
CREATE PROCEDURE addNotification(sender VARCHAR(25), receiver VARCHAR(25), counts INT)
BEGIN
    --Check if it has been a notification situation between to users already. If yes, increase the notification count by 'counts'.
    IF (EXISTS (SELECT * FROM notiftable WHERE notiftable.sender = sender AND notiftable.receiver = receiver))
    THEN
        UPDATE notiftable SET notiftable.counts = notiftable.counts + counts WHERE notiftable.sender = sender AND notiftable.receiver = receiver;
    --If no, create a new row and put the sender,receiver and notification count values in it.
    ELSE
        INSERT INTO notiftable(sender, receiver, counts) VALUES(sender, receiver, counts);
    END IF;
END//

/*Returns the notification counts from a user(sender) to the receiver. 
Returns 0 if no notification status occured before between to users.*/
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

--Set notification count between to users.
DELIMITER //
CREATE PROCEDURE setNotification(receiver VARCHAR(25), sender VARCHAR(25), sayi INTEGER)
BEGIN
    UPDATE notiftable SET notiftable.counts = sayi WHERE notiftable.sender = sender AND notiftable.receiver = receiver;
END //

/* çöp
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


*/