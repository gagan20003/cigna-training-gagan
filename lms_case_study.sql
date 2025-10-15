--1. List books with exactly one available copy
SELECT * FROM Books
WHERE Available_Copies=1;

--2. Name starts with specific letter
SELECT * FROM AUTHORS
WHERE Author_Name LIKE 'A%';

--3. Members with no address records
SELECT * FROM Members
WHERE Address IS NULL;

--4. List borrowing with specific borrow date
SELECT * FROM Borrowings
WHERE Borrow_Date-TO_DATE('2025-10-01','YYYY-MM-DD');

--5. List Books with publication year after 2000
SELECT * FROM Books
WHERE Publication_Year>2000;

--6. List borrowings with no fines
SELECT * FROM Borrowings
WHERE Fine=0;

--7. List members sorted by membership date in desc order
SELECT * FROM Members
ORDER BY Membership_Date DESC;

--8. Count total NO of Authors 
SELECT COUNT(Author_Name) FROM Authors;

--9. List book with tittles containing specific word
SELECT * FROM Books
WHERE CONTAINS(Title,'   ');

--10. List borrowings returned on specific date
SELECT * FROM Borrowings
WHERE Return_Date =TO_DATE();

--11. List members with specific area code 
SELECT * FROM Members
WHERE Phone LIKE'111%';

--12. List books sorted by title alphabetical order
SELECT * FROM Books
ORDER BY Title;

--13. Sum total available copies accross all books
SELECT SUM(Available_Copies) AS total_copies FROM Books

--14. List Borrowings with a due date in a specific month
SELECT * From Borrowings
WHERE TO_CHAR(Due_Date,'YYYY-MM')='2025-10';

--15. List Authors with names longer than 10 chars
SELECT * FROM Authors
WHERE LENGTH(Author_Name)>10;
