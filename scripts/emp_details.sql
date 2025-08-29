DECLARE
  TYPE name_arr IS VARRAY(20) OF VARCHAR2(50);

  first_names name_arr := name_arr('Ravi','Sneha','Arjun','Priya','Rahul',
                                   'Neha','Vikram','Kiran','Amit','Meera',
                                   'Deepak','Pooja','Anil','Shweta','Nikhil',
                                   'Manoj','Divya','Suresh','Lakshmi','Ajay');

  last_names  name_arr := name_arr('Kumar','Patel','Mehta','Sharma','Verma',
                                   'Reddy','Nair','Iyer','Das','Chowdhury',
                                   'Mishra','Ghosh','Joshi','Rana','Yadav',
                                   'Kapoor','Bose','Malhotra','Gupta','Singh');
BEGIN
  FOR i IN 1..1000 LOOP
    INSERT INTO employees (emp_id, first_name, last_name, email, hire_date, salary, dept_id)
    VALUES (
      1000 + i,
      first_names(TRUNC(DBMS_RANDOM.VALUE(1, first_names.COUNT+1))),
      last_names(TRUNC(DBMS_RANDOM.VALUE(1, last_names.COUNT+1))),
      'user' || i || '@corp.com',
      SYSDATE - TRUNC(DBMS_RANDOM.VALUE(1, 1000)),
      TRUNC(DBMS_RANDOM.VALUE(40000, 120000)),
      CASE MOD(i,4)
        WHEN 0 THEN 10
        WHEN 1 THEN 20
        WHEN 2 THEN 30
        ELSE 40
      END
    );
  END LOOP;

  COMMIT;
END;
/