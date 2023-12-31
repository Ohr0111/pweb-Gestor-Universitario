PGDMP                         {           Gestor Universitario Actual    14.2    15.2 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    35350    Gestor Universitario Actual    DATABASE     �   CREATE DATABASE "Gestor Universitario Actual" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Spain.1252';
 -   DROP DATABASE "Gestor Universitario Actual";
                postgres    false                        2615    35355    code    SCHEMA        CREATE SCHEMA code;
    DROP SCHEMA code;
                postgres    false                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            �           0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    8                        3079    35356    pgcrypto 	   EXTENSION     :   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA code;
    DROP EXTENSION pgcrypto;
                   false    7            �           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2                        3079    35393    unaccent 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;
    DROP EXTENSION unaccent;
                   false    8            �           0    0    EXTENSION unaccent    COMMENT     P   COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';
                        false    3            �           1247    35402    new_course_type    TYPE     c   CREATE TYPE public.new_course_type AS (
	cod integer,
	course character varying,
	years integer
);
 "   DROP TYPE public.new_course_type;
       public          postgres    false    8                       1255    35404    actual_user()    FUNCTION     �   CREATE FUNCTION public.actual_user() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$

DECLARE
actual refcursor := 'cursor';

BEGIN

open actual FOR
select * from actual_user;

return actual;

End;

$$;
 $   DROP FUNCTION public.actual_user();
       public          postgres    false    8                       1255    35405 7   authenticate_user(character varying, character varying)    FUNCTION     e  CREATE FUNCTION public.authenticate_user(user_name character varying, password character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$

DECLARE
authented boolean := false;

BEGIN

if $1 in (select users.user_name from users) and code.digest($2,'sha256') in (select users.password from users) THEN
    authented = true;
	truncate table actual_user;
	insert into actual_user(id, user_name, "name", "role") (
	
		select users.id, users.user_name, users.name, role.role 
		from users
		join role on role.cod_role = users.cod_role
		where users.user_name = $1
	
	);
	
end if;

return authented;

end;

$_$;
 a   DROP FUNCTION public.authenticate_user(user_name character varying, password character varying);
       public          postgres    false    8                       1255    35407 "   average_student(character varying)    FUNCTION       CREATE FUNCTION public.average_student(dni character varying) RETURNS double precision
    LANGUAGE plpgsql
    AS $_$
DECLARE
	val DOUBLE PRECISION;
BEGIN
select avg(subject_student.avg) into val
	from subject_student
	where subject_student.dni=$1;
	return val;
END;
$_$;
 =   DROP FUNCTION public.average_student(dni character varying);
       public          postgres    false    8                       1255    35408    average_year(integer, integer)    FUNCTION     l  CREATE FUNCTION public.average_year(year_id integer, course_id integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE
	std refcursor:='cursor';
BEGIN
	open std for
	select student.dni,student.full_name,student.sex,avg(subject_student.avg) as average,student.list_number,student.cod_group,student.cod_year, course.course_name
	from student
	join subject_student ON subject_student.dni = student.dni
	join course on course.cod_course = student.cod_course
	group by student.cod_group, student.dni, course.course_name
	HAVING cod_year=$1 and student.cod_course=$2
	order by average desc;
	
return std;
END;
$_$;
 G   DROP FUNCTION public.average_year(year_id integer, course_id integer);
       public          postgres    false    8            b           1255    35410    change_student_type()    FUNCTION       CREATE FUNCTION public.change_student_type() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
if upper(new.student_type) != upper(old.student_type) then
	
	if upper(old.student_type) = 'BAJA' then
		delete from withdraw_student where dni = old.dni;
	elsif upper(old.student_type) = 'REPITENTE' THEN
		delete from repeating_student where dni = old.dni;
	elsif upper(old.student_type) = 'PROMOVIDO' then
		delete from promoted_student where dni = old.dni;
	end if;
	
	if upper(new.student_type) = 'REPITENTE' THEN
		insert into repeating_student values(new.dni);
	elsif upper(new.student_type) = 'PROMOVIDO' then
		insert into promoted_student values(new.dni);
	elsif upper(new.student_type) = 'BAJA' then
		insert into withdraw_student values(new.dni,3);
	end if;
end if;
return new;
END;
$$;
 ,   DROP FUNCTION public.change_student_type();
       public          postgres    false    8            '           1255    35411    close_sesion()    FUNCTION     �   CREATE FUNCTION public.close_sesion() RETURNS void
    LANGUAGE plpgsql
    AS $$

BEGIN

truncate table actual_user;

end;

$$;
 %   DROP FUNCTION public.close_sesion();
       public          postgres    false    8            (           1255    35412    cod_role(character varying)    FUNCTION     �   CREATE FUNCTION public.cod_role(role character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
cod integer;

BEGIN

select cod_role into cod from role where upper(role.role) = upper($1);

return cod;

end;

$_$;
 7   DROP FUNCTION public.cod_role(role character varying);
       public          postgres    false    8            )           1255    35413 *   delete_average(character varying, integer)    FUNCTION     �   CREATE FUNCTION public.delete_average(student_dni character varying, subject_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$

BEGIN

delete from subject_student
where subject_student.dni = $1 and  subject_student.cod_subject= $2;

end;

$_$;
 X   DROP FUNCTION public.delete_average(student_dni character varying, subject_id integer);
       public          postgres    false    8            *           1255    35414    delete_course(integer)    FUNCTION     �   CREATE FUNCTION public.delete_course(cod_curso integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
delete from course
where cod_course=$1;
END;
$_$;
 7   DROP FUNCTION public.delete_course(cod_curso integer);
       public          postgres    false    8            +           1255    35415 '   delete_group(integer, integer, integer)    FUNCTION     �   CREATE FUNCTION public.delete_group(group_id integer, year_id integer, course_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
delete from "group"
where cod_group=$1 and cod_year=$2 and cod_course=$3;
END;
$_$;
 Y   DROP FUNCTION public.delete_group(group_id integer, year_id integer, course_id integer);
       public          postgres    false    8            ,           1255    35416    delete_municipality(integer)    FUNCTION     �   CREATE FUNCTION public.delete_municipality(cod integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$

BEGIN

delete from municipality where cod_municipality = $1;

end;

$_$;
 7   DROP FUNCTION public.delete_municipality(cod integer);
       public          postgres    false    8            -           1255    35417 !   delete_student(character varying)    FUNCTION       CREATE FUNCTION public.delete_student(dni character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$declare
	s_type character varying;
begin
select student_type into s_type
from student
where student.dni = $1;

delete from student
where student.dni = $1;

end;

$_$;
 <   DROP FUNCTION public.delete_student(dni character varying);
       public          postgres    false    8            .           1255    35418    delete_subject(integer)    FUNCTION     �   CREATE FUNCTION public.delete_subject(subject_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$

BEGIN

Delete from subject 
WHERE subject.cod_subject= $1;

END;

$_$;
 9   DROP FUNCTION public.delete_subject(subject_id integer);
       public          postgres    false    8            /           1255    35419    delete_user(character varying)    FUNCTION     j  CREATE FUNCTION public.delete_user(user_name character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
deleted boolean := false;

BEGIN

delete from users where users.user_name = $1 and $1 not in (select actual_user.user_name from actual_user);

deleted := $1 not in (select actual_user.user_name from actual_user);

return deleted;

end;

$_$;
 ?   DROP FUNCTION public.delete_user(user_name character varying);
       public          postgres    false    8            0           1255    35420    delete_withdraw_cause(integer)    FUNCTION     �   CREATE FUNCTION public.delete_withdraw_cause(cod integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
	BEGIN
		DELETE FROM withdraw_cause WHERE cod_cause = $1;
	END;
$_$;
 9   DROP FUNCTION public.delete_withdraw_cause(cod integer);
       public          postgres    false    8                       1255    35421    delete_year(integer, integer)    FUNCTION     �   CREATE FUNCTION public.delete_year(anno_id integer, curso_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
delete from "year"
where cod_year=$1 and cod_course=$2;
END;
$_$;
 E   DROP FUNCTION public.delete_year(anno_id integer, curso_id integer);
       public          postgres    false    8            c           1255    35680    exist_student()    FUNCTION        CREATE FUNCTION public.exist_student() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF NEW.dni NOT IN (SELECT dni FROM student) THEN
      RAISE EXCEPTION 'El estudiante no existe en la tabla student.';
    END IF;
    RETURN NEW;
  END;
$$;
 &   DROP FUNCTION public.exist_student();
       public          postgres    false    8            1           1255    35423    get_actual_course()    FUNCTION     p  CREATE FUNCTION public.get_actual_course() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$

DECLARE
list refcursor := 'cursor';

BEGIN

open list for
select course.cod_course, course_name, count(cod_year) as cant_years from course
join year on year.cod_course = course.cod_course
group by course.cod_course order by course_name desc limit 1;

return list;

end;

$$;
 *   DROP FUNCTION public.get_actual_course();
       public          postgres    false    8            2           1255    35424 !   get_course_cod(character varying)    FUNCTION     �   CREATE FUNCTION public.get_course_cod(course_name character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$

declare
cod integer;

BEGIN

select cod_course into cod from course where course.course_name = $1;

return cod;

END;

$_$;
 D   DROP FUNCTION public.get_course_cod(course_name character varying);
       public          postgres    false    8            3           1255    35425    get_courses()    FUNCTION     m  CREATE FUNCTION public.get_courses() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$

declare
list refcursor := 'cursor';

begin

open list FOR
select course.cod_course, course.course_name, count(cod_year) as cant_year from course
left join year on year.cod_course = course.cod_course
group by course.cod_course
order by course_name desc;

return list;

end;

$$;
 $   DROP FUNCTION public.get_courses();
       public          postgres    false    8            4           1255    35426    get_groups()    FUNCTION     0  CREATE FUNCTION public.get_groups() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$

DECLARE
list refcursor := 'cursor';

BEGIN

open list FOR
select "group".cod_group, count(student.dni) as cant_students, "group".cod_year, course.course_name from "group"
left join student on student.cod_group = "group".cod_group
join course on course.cod_course = "group".cod_course
group by "group".cod_group, "group".cod_year, "group".cod_course, course.course_name
order by "group".cod_course desc, "group".cod_year asc, "group".cod_group asc; 

return list;

end;

$$;
 #   DROP FUNCTION public.get_groups();
       public          postgres    false    8            5           1255    35427 $   get_groups_by_year(integer, integer)    FUNCTION     \  CREATE FUNCTION public.get_groups_by_year(year integer, course integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$

declare
list refcursor := 'cursor';

begin

open list for 
select "group".cod_group, count(student.dni) as cant_students, "group".cod_year, course.course_name from "group"
left join student on student.cod_group = "group".cod_group
join course on course.cod_course = "group".cod_course
group by "group".cod_group, "group".cod_year, "group".cod_course, course.course_name having "group".cod_year = $1 and "group".cod_course = $2
order by "group".cod_group;

return list;

end;

$_$;
 G   DROP FUNCTION public.get_groups_by_year(year integer, course integer);
       public          postgres    false    8            6           1255    35428 )   get_max_year_of_course(character varying)    FUNCTION     %  CREATE FUNCTION public.get_max_year_of_course(course character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$

DECLARE
max int;

BEGIN

select max(cod_year) into max from year
join course on course.cod_course = year.cod_course
where course.course_name = $1;

return max;

END;

$_$;
 G   DROP FUNCTION public.get_max_year_of_course(course character varying);
       public          postgres    false    8            7           1255    35429    get_roles()    FUNCTION     �  CREATE FUNCTION public.get_roles() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$

declare
list refcursor := 'cursor';
role character varying;

BEGIN

select actual_user.role into role from actual_user;

if  upper(role) = upper('Director') THEN
   
   open list for
   select role.role from "role";

elsif upper("role") = upper( 'Secretario') THEN

   open list for
   select role.role from "role" where "role".cod_role=3;

end if;

return list;

end;

$$;
 "   DROP FUNCTION public.get_roles();
       public          postgres    false    8            8           1255    35430 %   get_students_notes(character varying)    FUNCTION     l  CREATE FUNCTION public.get_students_notes(dni character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$

DECLARE
list refcursor := 'cursor';

BEGIN

open list for 
select student.dni, student.full_name, subject.subject_name, subject_student.avg, subject.cod_year, course.course_name
from subject_student
join subject on subject.cod_subject = subject_student.cod_subject
join student ON student.dni = subject_student.dni
join course on course.cod_course = subject.cod_course
where subject_student.dni = $1
order by subject.subject_name asc, subject.cod_year, course.course_name desc;

return list;

end;

$_$;
 @   DROP FUNCTION public.get_students_notes(dni character varying);
       public          postgres    false    8            9           1255    35431 5   get_subject_cod(character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.get_subject_cod(name character varying, course_name character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
cod int;
course int;

BEGIN
select get_course_cod($2) into course;
select cod_subject into cod from subject
where upper( unaccent(subject.subject_name) ) = upper( unaccent($1) ) and subject.cod_course = course;

return cod;

END;

$_$;
 ]   DROP FUNCTION public.get_subject_cod(name character varying, course_name character varying);
       public          postgres    false    8            :           1255    35432    get_users_by_role(integer)    FUNCTION     7  CREATE FUNCTION public.get_users_by_role(role integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$

DECLARE
list refcursor := 'cursor';

BEGIN

open list FOR
select id, user_name, name, role.role from users
join role on role.cod_role = users.cod_role
where users.cod_role = $1;

return list;

End;


$_$;
 6   DROP FUNCTION public.get_users_by_role(role integer);
       public          postgres    false    8            ;           1255    35433 $   get_users_by_role(character varying)    FUNCTION     F  CREATE FUNCTION public.get_users_by_role(role character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$

DECLARE
list refcursor := 'cursor';

BEGIN

open list FOR
select name, user_name, role.role from users
join role on role.cod_role = users.cod_role
where upper(role.role) = upper($1);

return list;

End;


$_$;
 @   DROP FUNCTION public.get_users_by_role(role character varying);
       public          postgres    false    8            <           1255    35434    get_years_of_actual_course()    FUNCTION     x  CREATE FUNCTION public.get_years_of_actual_course() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$

declare 
list refcursor := 'cursor';

BEGIN

open list FOR
select cod_year, course.course_name from year
join course on course.cod_course = year.cod_course
where year.cod_course = ( SELECT cod_course from course order by course_name desc limit 1 );

return list;

end;

$$;
 3   DROP FUNCTION public.get_years_of_actual_course();
       public          postgres    false    8            =           1255    35435 &   get_years_of_course(character varying)    FUNCTION     A  CREATE FUNCTION public.get_years_of_course(curso character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$

declare
list refcursor := 'mio';

begin

open list FOR
select cod_year, course_name from year
join course on course.cod_course = year.cod_course
where course.course_name = $1;

return list;

end;

$_$;
 C   DROP FUNCTION public.get_years_of_course(curso character varying);
       public          postgres    false    8                       1255    35437 3   insert_average(character varying, integer, integer)    FUNCTION       CREATE FUNCTION public.insert_average(dni_student character varying, subject_id integer, note integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

 BEGIN

 insert into subject_student (cod_subject,dni,avg)
 values(subject_id, dni_student, note);

 END;

$$;
 f   DROP FUNCTION public.insert_average(dni_student character varying, subject_id integer, note integer);
       public          postgres    false    8                       1255    35438     insert_course(character varying)    FUNCTION     �   CREATE FUNCTION public.insert_course(course character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
insert into course (course_name)
values (course);
END;
$$;
 >   DROP FUNCTION public.insert_course(course character varying);
       public          postgres    false    8            $           1255    35439 '   insert_group(integer, integer, integer)    FUNCTION     �   CREATE FUNCTION public.insert_group(year_id integer, course_id integer, group_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
insert into "group" (cod_year,cod_course,cod_group)
values (year_id,course_id,group_id);
END;
$$;
 Y   DROP FUNCTION public.insert_group(year_id integer, course_id integer, group_id integer);
       public          postgres    false    8            >           1255    35440 &   insert_municipality(character varying)    FUNCTION     �   CREATE FUNCTION public.insert_municipality(municipio character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

BEGIN

insert into municipality(municipality_name) values(municipio);

end;

$$;
 G   DROP FUNCTION public.insert_municipality(municipio character varying);
       public          postgres    false    8            ?           1255    35441 �   insert_student(character varying, character varying, character varying, integer, integer, integer, integer, character varying, integer)    FUNCTION       CREATE FUNCTION public.insert_student(st_dni character varying, st_name character varying, st_sex character varying, st_municipality integer, st_group integer, st_year integer, st_course integer, st_type character varying, st_cause integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

BEGIN

insert into student (dni,full_name,sex,cod_municipality,student_type,cod_group,cod_year,cod_course)
values(st_dni, st_name, upper(st_sex), st_municipality, st_type, st_group, st_year,st_course);

if upper(st_type) = 'PROMOVIDO' THEN
 insert into promoted_student
 values(st_dni);

elsif upper(st_type) = 'BAJA' THEN
 insert into withdraw_student
 values(st_dni, st_cause);
 
ELSif upper(st_type) = 'REPITENTE' then
 insert into repeating_student
 values(st_dni);

end if;

END;

$$;
 �   DROP FUNCTION public.insert_student(st_dni character varying, st_name character varying, st_sex character varying, st_municipality integer, st_group integer, st_year integer, st_course integer, st_type character varying, st_cause integer);
       public          postgres    false    8            @           1255    35442 <   insert_subject(character varying, integer, integer, integer)    FUNCTION     4  CREATE FUNCTION public.insert_subject(sub_name character varying, sub_hours integer, sub_year integer, sub_course integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

BEGIN
 
  INSERT INTO subject (subject_name,total_hours,cod_year,cod_course)
  VALUES(sub_name, sub_hours,sub_year, sub_course);

END;

$$;
 z   DROP FUNCTION public.insert_subject(sub_name character varying, sub_hours integer, sub_year integer, sub_course integer);
       public          postgres    false    8            A           1255    35443 M   insert_user(character varying, character varying, character varying, integer)    FUNCTION     *  CREATE FUNCTION public.insert_user(name character varying, "user" character varying, password character varying, cod_role integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$

BEGIN

insert into users(name, user_name, password, cod_role)
values($1, $2, code.digest($3, 'sha256'), $4);

end;

$_$;
 �   DROP FUNCTION public.insert_user(name character varying, "user" character varying, password character varying, cod_role integer);
       public          postgres    false    8            B           1255    35444 )   insert_whithdraw_cause(character varying)    FUNCTION     �   CREATE FUNCTION public.insert_whithdraw_cause(causa character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
	BEGIN
		INSERT INTO withdraw_cause(cause) VALUES($1);
	END;
$_$;
 F   DROP FUNCTION public.insert_whithdraw_cause(causa character varying);
       public          postgres    false    8            C           1255    35445    insert_year(integer, integer)    FUNCTION     �   CREATE FUNCTION public.insert_year(anno_id integer, curso_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
insert into year
values($1,$2);
END;
$_$;
 E   DROP FUNCTION public.insert_year(anno_id integer, curso_id integer);
       public          postgres    false    8            D           1255    35446    list_municipality()    FUNCTION     �   CREATE FUNCTION public.list_municipality() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$

DECLARE
list refcursor := 'cursor';

begin 

open list FOR
select * from municipality;

return list;

end;

$$;
 *   DROP FUNCTION public.list_municipality();
       public          postgres    false    8            E           1255    35447    list_student()    FUNCTION       CREATE FUNCTION public.list_student() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$

declare 
lista refcursor := 'cursor';

BEGIN

open lista for 
select student.dni, full_name, municipality_name, student.student_type, student.cod_group,student.cod_year, course.course_name
from student
join course on course.cod_course = student.cod_course
join municipality on municipality.cod_municipality = student.cod_municipality
order by student.cod_year asc, student.cod_group asc, student.full_name asc;

return lista;

end;

$$;
 %   DROP FUNCTION public.list_student();
       public          postgres    false    8            F           1255    35448 1   list_students_by_group(integer, integer, integer)    FUNCTION     &  CREATE FUNCTION public.list_students_by_group(num_grupo integer, anno integer, course integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
-- anlz
DECLARE
lista refcursor := 'cursor';

begin

open lista for 
select student.dni, full_name, municipality_name, student.student_type, student.cod_group, student.cod_year, course.course_name, withdraw_cause.cause, student.sex
from student
join course on course.cod_course = student.cod_course
join municipality on municipality.cod_municipality = student.cod_municipality
left join withdraw_student on withdraw_student.dni = student.dni
left join withdraw_cause on withdraw_cause.cod_cause = withdraw_student.cod_cause

where student.cod_group = $1 and student.cod_year=$2 and student.cod_course = $3
order by student.full_name;

return lista;

end;

$_$;
 ^   DROP FUNCTION public.list_students_by_group(num_grupo integer, anno integer, course integer);
       public          postgres    false    8            G           1255    35449 '   list_students_by_year(integer, integer)    FUNCTION       CREATE FUNCTION public.list_students_by_year(anno integer, course integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$

declare 
lista refcursor := 'cursor';

BEGIN

open lista for
select student.dni, full_name, municipality_name, student.student_type, student.cod_group, student.cod_year, course.course_name, withdraw_cause.cause, student.sex
from student
left join withdraw_student ON withdraw_student.dni = student.dni
left join withdraw_cause ON withdraw_cause.cod_cause = withdraw_student.cod_cause
join course on course.cod_course = student.cod_course
join municipality on municipality.cod_municipality = student.cod_municipality

where student.cod_year = $1 and course.cod_course=$2
order by student.cod_group asc, full_name asc;

return lista;

end;

$_$;
 J   DROP FUNCTION public.list_students_by_year(anno integer, course integer);
       public          postgres    false    8            H           1255    35450    list_subjects()    FUNCTION     �  CREATE FUNCTION public.list_subjects() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$

declare
lista refcursor := 'cursor';

BEGIN

open lista for 
select subject_name, total_hours, subject.cod_year, course.course_name
from subject 
join course on course.cod_course = subject.cod_course

order by  course.course_name desc, subject.cod_year asc, subject.subject_name asc;

return lista;

end;

$$;
 &   DROP FUNCTION public.list_subjects();
       public          postgres    false    8            I           1255    35451 '   list_subjects_by_year(integer, integer)    FUNCTION     �  CREATE FUNCTION public.list_subjects_by_year(anno integer, course integer) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$

declare
lista refcursor := 'cursor';

BEGIN

open lista for 
select subject_name, total_hours, subject.cod_year, course.course_name
from subject 
join course on course.cod_course = subject.cod_course
where subject.cod_year = $1 and subject.cod_course = $2
order by subject.cod_year asc, subject.subject_name asc;

return lista;

end;

$_$;
 J   DROP FUNCTION public.list_subjects_by_year(anno integer, course integer);
       public          postgres    false    8            J           1255    35452    list_withdraw_cause()    FUNCTION     �   CREATE FUNCTION public.list_withdraw_cause() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
declare
list refcursor := 'cursor';

begin 

open list for
select* from withdraw_cause;

return list;

end;

$$;
 ,   DROP FUNCTION public.list_withdraw_cause();
       public          postgres    false    8            K           1255    35453 #   municipality_cod(character varying)    FUNCTION     
  CREATE FUNCTION public.municipality_cod(municipality character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
cod int;

begin 

select cod_municipality into cod from municipality
where upper(municipality_name) = upper($1);

return cod;

end;

$_$;
 G   DROP FUNCTION public.municipality_cod(municipality character varying);
       public          postgres    false    8            L           1255    35462 3   update_average(character varying, integer, integer)    FUNCTION       CREATE FUNCTION public.update_average(dni character varying, subject_id integer, average integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$

BEGIN

update subject_student set avg = $3
where subject_student.dni = $1 and subject_student.cod_subject = $2;

end;

$_$;
 a   DROP FUNCTION public.update_average(dni character varying, subject_id integer, average integer);
       public          postgres    false    8            M           1255    35463 )   update_course(integer, character varying)    FUNCTION     �   CREATE FUNCTION public.update_course(cod integer, curso_nuevo character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
update course
set course_name=$2
where cod_course=$1;
END;
$_$;
 P   DROP FUNCTION public.update_course(cod integer, curso_nuevo character varying);
       public          postgres    false    8            N           1255    35464 B   update_group(integer, integer, integer, integer, integer, integer)    FUNCTION     R  CREATE FUNCTION public.update_group(old_code integer, old_year_id integer, old_course_id integer, new_code integer, new_year_id integer, new_course_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGiN
	update "group"
	set cod_year=$5, cod_course=$6, cod_group=$4
	where cod_year=$2 and cod_course=$3 and cod_group=$1;
end;
$_$;
 �   DROP FUNCTION public.update_group(old_code integer, old_year_id integer, old_course_id integer, new_code integer, new_year_id integer, new_course_id integer);
       public          postgres    false    8            a           1255    35679    update_list_number()    FUNCTION     �  CREATE FUNCTION public.update_list_number() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
if TG_OP='INSERT' THEN
	PERFORM update_order(new.cod_group, new.cod_year, new.cod_course);
	return new;
elsif TG_OP='UPDATE' THEN
	PERFORM update_order(old.cod_group, old.cod_year, old.cod_course);
	PERFORM update_order(new.cod_group, new.cod_year, new.cod_course);
	return new;
ELSE
	PERFORM update_order(old.cod_group, old.cod_year, old.cod_course);
	return old;
end if;
end;
$$;
 +   DROP FUNCTION public.update_list_number();
       public          postgres    false    8            O           1255    35465 /   update_municipality(integer, character varying)    FUNCTION     �   CREATE FUNCTION public.update_municipality(cod integer, mun_nue character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$

begin

update municipality set municipality_name = $2 WHERE municipality.cod_municipality = $1;

end;

$_$;
 R   DROP FUNCTION public.update_municipality(cod integer, mun_nue character varying);
       public          postgres    false    8            P           1255    35466    update_order(integer)    FUNCTION     `  CREATE FUNCTION public.update_order(group_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$--change
DECLARE
	fila record;
BEGIN
FOR fila IN (SELECT dni,ROW_NUMBER() OVER(order by full_name) FROM student where group_num=$1 order by full_name) loop
	update student
	set list_number=fila.row_number
	where student.dni=fila.dni;
end loop;
END;
$_$;
 5   DROP FUNCTION public.update_order(group_id integer);
       public          postgres    false    8            S           1255    35467 �   update_student(character varying, character varying, character varying, character varying, integer, integer, integer, integer, character varying, integer)    FUNCTION     �  CREATE FUNCTION public.update_student(old_dni character varying, new_dni character varying, st_name character varying, st_sex character varying, municipilaty integer, st_group integer, st_year integer, st_curse integer, st_type character varying, st_cause integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
	
BEGIN

update student set full_name = st_name, sex = upper(st_sex), cod_municipality = municipilaty, 
 student_type= st_type,cod_group= st_group,cod_year=st_year, cod_course=st_curse, dni = new_dni
where student.dni = $1;

if upper(st_type) = 'BAJA'  and st_cause is not null THEN
 	update withdraw_student set cod_cause=st_cause where id=new_dni;
end if;

end;

$_$;
   DROP FUNCTION public.update_student(old_dni character varying, new_dni character varying, st_name character varying, st_sex character varying, municipilaty integer, st_group integer, st_year integer, st_curse integer, st_type character varying, st_cause integer);
       public          postgres    false    8            Q           1255    35468 E   update_subject(integer, character varying, integer, integer, integer)    FUNCTION     B  CREATE FUNCTION public.update_subject(cod_subject integer, new_name character varying, new_time integer, new_year integer, new_course integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$

BEGIN

update subject SET subject_name = $2, total_hours = $3, cod_year= $4, cod_course=$5
WHERE subject.cod_subject=$1;

END;

$_$;
 �   DROP FUNCTION public.update_subject(cod_subject integer, new_name character varying, new_time integer, new_year integer, new_course integer);
       public          postgres    false    8            R           1255    35469 `   update_user(character varying, character varying, character varying, character varying, integer)    FUNCTION     Z  CREATE FUNCTION public.update_user(old_user character varying, name character varying, new_user character varying, password character varying, cod_role integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$

BEGIN

update users set name = $2, user_name = $3, "password" = code.digest($4, 'sha256'), cod_role = $5
where user_name = $1;

end;

$_$;
 �   DROP FUNCTION public.update_user(old_user character varying, name character varying, new_user character varying, password character varying, cod_role integer);
       public          postgres    false    8            T           1255    35470 1   update_withdraw_cause(integer, character varying)    FUNCTION     �   CREATE FUNCTION public.update_withdraw_cause(cod integer, nueva_causa character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
	BEGIN
		UPDATE withdraw_cause
		SET cause = nueva_causa
		WHERE cod_cause = cod;
	END;
$$;
 X   DROP FUNCTION public.update_withdraw_cause(cod integer, nueva_causa character varying);
       public          postgres    false    8            U           1255    35471 Y   update_withdraw_student(character varying, character varying, character varying, integer)    FUNCTION     &  CREATE FUNCTION public.update_withdraw_student(old_dni character varying, new_dni character varying, st_type character varying, st_cause integer) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE
	old_type CHARACTER VARYING;
BEGIN
if upper(st_type) = 'BAJA' THEN
	select student_type into old_type
	from student
	where dni=old_dni;
	if upper(st_type) != upper( old_type ) THEN
 		insert into withdraw_student values(new_dni, st_cause);
	else
		UPDATE withdraw_student set cod_cause = st_cause,dni=new_dni where dni=old_dni;
	end if;
end if;
end;$$;
 �   DROP FUNCTION public.update_withdraw_student(old_dni character varying, new_dni character varying, st_type character varying, st_cause integer);
       public          postgres    false    8            V           1255    35472 /   update_year(integer, integer, integer, integer)    FUNCTION       CREATE FUNCTION public.update_year(old_year integer, old_course integer, new_year integer, new_course integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
update "year"
set cod_course=new_course, cod_year=new_year
where cod_year=old_year and cod_course=old_course;
END;
$$;
 n   DROP FUNCTION public.update_year(old_year integer, old_course integer, new_year integer, new_course integer);
       public          postgres    false    8            W           1255    35473    validate_cause_entry()    FUNCTION     �  CREATE FUNCTION public.validate_cause_entry() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF NEW.cause = '' THEN
      RAISE EXCEPTION 'Be sure to fill in the cause fill';
	  
	 elsif upper(new.cause) in ( select upper(cause) from withdraw_cause ) THEN
	  raise exception 'The cause of the withdrawal % is already registered', upper(new.cause);
    END IF;
	return new;
  END;
  
$$;
 -   DROP FUNCTION public.validate_cause_entry();
       public          postgres    false    8            X           1255    35474    validate_course_entry()    FUNCTION     �  CREATE FUNCTION public.validate_course_entry() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	curs record;
BEGIN
	if new.course_name is null then
		raise exception 'Course name cannot be empty';
	end if;
	
	select * into curs
	from course
	where course.course_name=new.course_name;
	
	if curs is not null THEN
		raise EXCEPTion 'The course is already registered';
	end if;
	return new;
END;
$$;
 .   DROP FUNCTION public.validate_course_entry();
       public          postgres    false    8            Y           1255    35475    validate_evaluation_entry()    FUNCTION       CREATE FUNCTION public.validate_evaluation_entry() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN
if not new.avg BETWEEN 2 and 5 THEN
    raise exception 'The evaluation must be in the range of marks allowed at the university(2-5)';
 end if;

RETURN new;

end;

$$;
 2   DROP FUNCTION public.validate_evaluation_entry();
       public          postgres    false    8            Z           1255    35476 #   validate_letters(character varying)    FUNCTION       CREATE FUNCTION public.validate_letters(cadena character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$

declare 
paso boolean = false;

BEGIN

if regexp_matches(cadena, '^[A-Za-z\s]+$') is not null THEN
 paso = true;
end if;

return paso;

end;

$_$;
 A   DROP FUNCTION public.validate_letters(cadena character varying);
       public          postgres    false    8            [           1255    35477    validate_municipality_entry()    FUNCTION     �  CREATE FUNCTION public.validate_municipality_entry() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

if upper(new.municipality_name) in (  select upper(municipality_name) FROM municipality) then 
  raise exception 'The municipality % is alredy registred', upper(new.municipality_name);
elsif not validate_letters(new.municipality_name) then
  raise exception 'Yoy should not enter numbers in the name of the municipality';
end if;

return new;

end;

$$;
 4   DROP FUNCTION public.validate_municipality_entry();
       public          postgres    false    8            \           1255    35478 #   validate_numbers(character varying)    FUNCTION       CREATE FUNCTION public.validate_numbers(cadena character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$

declare 
paso boolean := false;

BEGIN
 
 if regexp_matches(cadena, '^\d+$') is not null THEN
  paso := true;
 end if;
 
 return paso;

end;

$_$;
 A   DROP FUNCTION public.validate_numbers(cadena character varying);
       public          postgres    false    8            ]           1255    35479    validate_student_entry()    FUNCTION     P  CREATE FUNCTION public.validate_student_entry() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

	if new.dni is null or  new.full_name is null or new.sex is null or new.cod_municipality is null or new.cod_year is null OR new.cod_group is null or new.student_type is null then
    	raise exception 'You must enter all student data';
		
	elsif not validate_numbers(new.dni) then
    	raise exception 'You must not enter letters on the DNI';
 
 	elsif not validate_letters(new.full_name) then
		raise exception 'You should not enter letters in the student´s name';

 	elsif upper(new.sex) != 'M' and upper(new.sex) != 'F' then
		raise exception 'You only have to enter [F in case of being feminine] or [M in case of being masculine]'; 

   elsif new.cod_year not BETWEEN 1 and (select max(cod_year) from year ) then
        raise exception 'El año tiene que estar en el rango de (1-%) ', (select max(cod_year) from year );
		
   elsif upper(new.student_type)<> 'NUEVO INGRESO' and upper(new.student_type)<> 'PROMOVIDO' and upper(new.student_type)<> 'REPITENTE' and upper(new.student_type)<> 'BAJA' then
    	raise exception 'The type of student must be [NUEVO INGRESO in case of being a first year], [PROMOVIDO in case of being promoted], [REPITENTE in case of being repeating] or [BAJA in case of being withdrawn]';
   end if;
   
return new;

END;

$$;
 /   DROP FUNCTION public.validate_student_entry();
       public          postgres    false    8            `           1255    35480    validate_subject_entry()    FUNCTION     �  CREATE FUNCTION public.validate_subject_entry() RETURNS trigger
    LANGUAGE plpgsql
    AS $$declare 
min_v integer;
max_v integer;

BEGIN
select MIN(cod_year) into min_v from "year";
select MAX(cod_year) into max_v from "year";

if new.cod_year is null or new.total_hours is null or new.subject_name is null then
raise exception 'You must enter all the data of the subject';

elsif new.total_hours <= 0 then
  raise Exception 'You must enter a number greater than 0 to define the number of hours';

elsif upper( unaccent(new.subject_name) ) in (  select upper( unaccent(subject_name) ) FROM subject where subject.cod_course = new.cod_course and subject.cod_subject != new.cod_subject) then 
  raise exception 'The % subject is already registered', new.subject_name;

elsif new.cod_year not BETWEEN min_v and max_v THEN
	raise exception 'The year of the subject must be in the range of years(%-%)',min_v, max_v;
end if;

return new;
end;

$$;
 /   DROP FUNCTION public.validate_subject_entry();
       public          postgres    false    8            ^           1255    35481    validate_user_entry()    FUNCTION     �  CREATE FUNCTION public.validate_user_entry() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

begin

   if new.user_name = null or new.name = null or new.password = null or new.cod_role = null THEN
      raise exception 'You must entered all data';
	  
   elsif not validate_letters(new.name) THEN
      raise exception 'The username must not contain numbers';
	  
   elsif length(new.password) < 8 THEN
      raise exception 'Password must be at least 8 characters';
	  
   end if;
   
  return new;

end;

$$;
 ,   DROP FUNCTION public.validate_user_entry();
       public          postgres    false    8            _           1255    35482    withdraw_cod(character varying)    FUNCTION       CREATE FUNCTION public.withdraw_cod(cause character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
cod int;

begin 

select withdraw_cause.cod_cause into cod from withdraw_cause
where upper(withdraw_cause.cause) = upper($1);

return cod;

end;

$_$;
 <   DROP FUNCTION public.withdraw_cod(cause character varying);
       public          postgres    false    8            �            1259    35483    actual_user    TABLE     �   CREATE TABLE public.actual_user (
    id integer NOT NULL,
    user_name character varying NOT NULL,
    name character varying NOT NULL,
    role character varying NOT NULL
);
    DROP TABLE public.actual_user;
       public         heap    postgres    false    8            �            1259    35488    withdraw_cause    TABLE     m   CREATE TABLE public.withdraw_cause (
    cod_cause integer NOT NULL,
    cause character varying NOT NULL
);
 "   DROP TABLE public.withdraw_cause;
       public         heap    postgres    false    8            �            1259    35493    causa_baja_cod_causa_seq    SEQUENCE     �   CREATE SEQUENCE public.causa_baja_cod_causa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.causa_baja_cod_causa_seq;
       public          postgres    false    214    8            �           0    0    causa_baja_cod_causa_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.causa_baja_cod_causa_seq OWNED BY public.withdraw_cause.cod_cause;
          public          postgres    false    215            �            1259    35497    course    TABLE     l   CREATE TABLE public.course (
    cod_course integer NOT NULL,
    course_name character varying NOT NULL
);
    DROP TABLE public.course;
       public         heap    postgres    false    8            �            1259    35502    curso_cod_curso_seq    SEQUENCE     �   CREATE SEQUENCE public.curso_cod_curso_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.curso_cod_curso_seq;
       public          postgres    false    216    8            �           0    0    curso_cod_curso_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.curso_cod_curso_seq OWNED BY public.course.cod_course;
          public          postgres    false    217            �            1259    35503    withdraw_student    TABLE     m   CREATE TABLE public.withdraw_student (
    dni character varying NOT NULL,
    cod_cause integer NOT NULL
);
 $   DROP TABLE public.withdraw_student;
       public         heap    postgres    false    8            �            1259    35508    estudiante_baja_cod_causa_seq    SEQUENCE     �   CREATE SEQUENCE public.estudiante_baja_cod_causa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.estudiante_baja_cod_causa_seq;
       public          postgres    false    218    8                        0    0    estudiante_baja_cod_causa_seq    SEQUENCE OWNED BY     `   ALTER SEQUENCE public.estudiante_baja_cod_causa_seq OWNED BY public.withdraw_student.cod_cause;
          public          postgres    false    219            �            1259    35509    group    TABLE     �   CREATE TABLE public."group" (
    cod_group integer NOT NULL,
    cod_year integer NOT NULL,
    cod_course integer NOT NULL
);
    DROP TABLE public."group";
       public         heap    postgres    false    8            �            1259    35512    group_cod_group_seq    SEQUENCE     �   CREATE SEQUENCE public.group_cod_group_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.group_cod_group_seq;
       public          postgres    false    220    8                       0    0    group_cod_group_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.group_cod_group_seq OWNED BY public."group".cod_group;
          public          postgres    false    221            �            1259    35513    municipality    TABLE     ~   CREATE TABLE public.municipality (
    cod_municipality integer NOT NULL,
    municipality_name character varying NOT NULL
);
     DROP TABLE public.municipality;
       public         heap    postgres    false    8            �            1259    35518    municipio_cod_municipio_seq    SEQUENCE     �   CREATE SEQUENCE public.municipio_cod_municipio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.municipio_cod_municipio_seq;
       public          postgres    false    222    8                       0    0    municipio_cod_municipio_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.municipio_cod_municipio_seq OWNED BY public.municipality.cod_municipality;
          public          postgres    false    223            �            1259    35519    promoted_student    TABLE     M   CREATE TABLE public.promoted_student (
    dni character varying NOT NULL
);
 $   DROP TABLE public.promoted_student;
       public         heap    postgres    false    8            �            1259    35524    repeating_student    TABLE     N   CREATE TABLE public.repeating_student (
    dni character varying NOT NULL
);
 %   DROP TABLE public.repeating_student;
       public         heap    postgres    false    8            �            1259    35529    role    TABLE     a   CREATE TABLE public.role (
    cod_role integer NOT NULL,
    role character varying NOT NULL
);
    DROP TABLE public.role;
       public         heap    postgres    false    8            �            1259    35534    role_cod_role_seq    SEQUENCE     �   CREATE SEQUENCE public.role_cod_role_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.role_cod_role_seq;
       public          postgres    false    8    226                       0    0    role_cod_role_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.role_cod_role_seq OWNED BY public.role.cod_role;
          public          postgres    false    227            �            1259    35535    student    TABLE     �  CREATE TABLE public.student (
    dni character varying(11) NOT NULL,
    full_name character varying NOT NULL,
    sex character varying(1) NOT NULL,
    list_number integer,
    student_type character varying DEFAULT 'Nuevo Ingreso'::character varying NOT NULL,
    cod_municipality integer NOT NULL,
    cod_group integer NOT NULL,
    cod_year integer NOT NULL,
    cod_course integer NOT NULL
);
    DROP TABLE public.student;
       public         heap    postgres    false    8            �            1259    35541    subject    TABLE     �   CREATE TABLE public.subject (
    cod_subject integer NOT NULL,
    subject_name character varying NOT NULL,
    total_hours integer NOT NULL,
    cod_year integer NOT NULL,
    cod_course integer NOT NULL
);
    DROP TABLE public.subject;
       public         heap    postgres    false    8            �            1259    35546    subject_cod_subject_seq    SEQUENCE     �   CREATE SEQUENCE public.subject_cod_subject_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.subject_cod_subject_seq;
       public          postgres    false    8    229                       0    0    subject_cod_subject_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.subject_cod_subject_seq OWNED BY public.subject.cod_subject;
          public          postgres    false    230            �            1259    35547    subject_student    TABLE     �   CREATE TABLE public.subject_student (
    cod_subject integer NOT NULL,
    dni character varying NOT NULL,
    avg integer NOT NULL
);
 #   DROP TABLE public.subject_student;
       public         heap    postgres    false    8            �            1259    35552    subject_student_cod_subject_seq    SEQUENCE     �   CREATE SEQUENCE public.subject_student_cod_subject_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.subject_student_cod_subject_seq;
       public          postgres    false    8    231                       0    0    subject_student_cod_subject_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.subject_student_cod_subject_seq OWNED BY public.subject_student.cod_subject;
          public          postgres    false    232            �            1259    35553    users    TABLE     �   CREATE TABLE public.users (
    id integer NOT NULL,
    user_name character varying NOT NULL,
    name character varying NOT NULL,
    cod_role integer NOT NULL,
    password bytea NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false    8            �            1259    35558    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    233    8                       0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    234            �            1259    35559    year    TABLE     ]   CREATE TABLE public.year (
    cod_year integer NOT NULL,
    cod_course integer NOT NULL
);
    DROP TABLE public.year;
       public         heap    postgres    false    8                       2604    35562    course cod_course    DEFAULT     t   ALTER TABLE ONLY public.course ALTER COLUMN cod_course SET DEFAULT nextval('public.curso_cod_curso_seq'::regclass);
 @   ALTER TABLE public.course ALTER COLUMN cod_course DROP DEFAULT;
       public          postgres    false    217    216                       2604    35563    group cod_group    DEFAULT     t   ALTER TABLE ONLY public."group" ALTER COLUMN cod_group SET DEFAULT nextval('public.group_cod_group_seq'::regclass);
 @   ALTER TABLE public."group" ALTER COLUMN cod_group DROP DEFAULT;
       public          postgres    false    221    220                       2604    35564    municipality cod_municipality    DEFAULT     �   ALTER TABLE ONLY public.municipality ALTER COLUMN cod_municipality SET DEFAULT nextval('public.municipio_cod_municipio_seq'::regclass);
 L   ALTER TABLE public.municipality ALTER COLUMN cod_municipality DROP DEFAULT;
       public          postgres    false    223    222                       2604    35565    role cod_role    DEFAULT     n   ALTER TABLE ONLY public.role ALTER COLUMN cod_role SET DEFAULT nextval('public.role_cod_role_seq'::regclass);
 <   ALTER TABLE public.role ALTER COLUMN cod_role DROP DEFAULT;
       public          postgres    false    227    226                       2604    35566    subject cod_subject    DEFAULT     z   ALTER TABLE ONLY public.subject ALTER COLUMN cod_subject SET DEFAULT nextval('public.subject_cod_subject_seq'::regclass);
 B   ALTER TABLE public.subject ALTER COLUMN cod_subject DROP DEFAULT;
       public          postgres    false    230    229                       2604    35567    subject_student cod_subject    DEFAULT     �   ALTER TABLE ONLY public.subject_student ALTER COLUMN cod_subject SET DEFAULT nextval('public.subject_student_cod_subject_seq'::regclass);
 J   ALTER TABLE public.subject_student ALTER COLUMN cod_subject DROP DEFAULT;
       public          postgres    false    232    231                       2604    35568    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    234    233                       2604    35569    withdraw_cause cod_cause    DEFAULT     �   ALTER TABLE ONLY public.withdraw_cause ALTER COLUMN cod_cause SET DEFAULT nextval('public.causa_baja_cod_causa_seq'::regclass);
 G   ALTER TABLE public.withdraw_cause ALTER COLUMN cod_cause DROP DEFAULT;
       public          postgres    false    215    214                       2604    35570    withdraw_student cod_cause    DEFAULT     �   ALTER TABLE ONLY public.withdraw_student ALTER COLUMN cod_cause SET DEFAULT nextval('public.estudiante_baja_cod_causa_seq'::regclass);
 I   ALTER TABLE public.withdraw_student ALTER COLUMN cod_cause DROP DEFAULT;
       public          postgres    false    219    218            �          0    35483    actual_user 
   TABLE DATA           @   COPY public.actual_user (id, user_name, name, role) FROM stdin;
    public          postgres    false    213   t6      �          0    35497    course 
   TABLE DATA           9   COPY public.course (cod_course, course_name) FROM stdin;
    public          postgres    false    216   �6      �          0    35509    group 
   TABLE DATA           B   COPY public."group" (cod_group, cod_year, cod_course) FROM stdin;
    public          postgres    false    220   �6      �          0    35513    municipality 
   TABLE DATA           K   COPY public.municipality (cod_municipality, municipality_name) FROM stdin;
    public          postgres    false    222   7      �          0    35519    promoted_student 
   TABLE DATA           /   COPY public.promoted_student (dni) FROM stdin;
    public          postgres    false    224   X7      �          0    35524    repeating_student 
   TABLE DATA           0   COPY public.repeating_student (dni) FROM stdin;
    public          postgres    false    225   �7      �          0    35529    role 
   TABLE DATA           .   COPY public.role (cod_role, role) FROM stdin;
    public          postgres    false    226   �7      �          0    35535    student 
   TABLE DATA           �   COPY public.student (dni, full_name, sex, list_number, student_type, cod_municipality, cod_group, cod_year, cod_course) FROM stdin;
    public          postgres    false    228   �7      �          0    35541    subject 
   TABLE DATA           _   COPY public.subject (cod_subject, subject_name, total_hours, cod_year, cod_course) FROM stdin;
    public          postgres    false    229   ,9      �          0    35547    subject_student 
   TABLE DATA           @   COPY public.subject_student (cod_subject, dni, avg) FROM stdin;
    public          postgres    false    231   �9      �          0    35553    users 
   TABLE DATA           H   COPY public.users (id, user_name, name, cod_role, password) FROM stdin;
    public          postgres    false    233   �9      �          0    35488    withdraw_cause 
   TABLE DATA           :   COPY public.withdraw_cause (cod_cause, cause) FROM stdin;
    public          postgres    false    214   0;      �          0    35503    withdraw_student 
   TABLE DATA           :   COPY public.withdraw_student (dni, cod_cause) FROM stdin;
    public          postgres    false    218   �;      �          0    35559    year 
   TABLE DATA           4   COPY public.year (cod_year, cod_course) FROM stdin;
    public          postgres    false    235   �;                 0    0    causa_baja_cod_causa_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.causa_baja_cod_causa_seq', 10, true);
          public          postgres    false    215                       0    0    curso_cod_curso_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.curso_cod_curso_seq', 40, true);
          public          postgres    false    217            	           0    0    estudiante_baja_cod_causa_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.estudiante_baja_cod_causa_seq', 1, false);
          public          postgres    false    219            
           0    0    group_cod_group_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.group_cod_group_seq', 11, true);
          public          postgres    false    221                       0    0    municipio_cod_municipio_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.municipio_cod_municipio_seq', 17, true);
          public          postgres    false    223                       0    0    role_cod_role_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.role_cod_role_seq', 1, false);
          public          postgres    false    227                       0    0    subject_cod_subject_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.subject_cod_subject_seq', 61, true);
          public          postgres    false    230                       0    0    subject_student_cod_subject_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.subject_student_cod_subject_seq', 1, false);
          public          postgres    false    232                       0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 23, true);
          public          postgres    false    234                       2606    35572    withdraw_cause causa_baja_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.withdraw_cause
    ADD CONSTRAINT causa_baja_pkey PRIMARY KEY (cod_cause);
 H   ALTER TABLE ONLY public.withdraw_cause DROP CONSTRAINT causa_baja_pkey;
       public            postgres    false    214                       2606    35574    course course_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_pkey PRIMARY KEY (cod_course);
 <   ALTER TABLE ONLY public.course DROP CONSTRAINT course_pkey;
       public            postgres    false    216            (           2606    35576 +   repeating_student estudiante_repitente_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.repeating_student
    ADD CONSTRAINT estudiante_repitente_pkey PRIMARY KEY (dni);
 U   ALTER TABLE ONLY public.repeating_student DROP CONSTRAINT estudiante_repitente_pkey;
       public            postgres    false    225            "           2606    35578    group group_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public."group"
    ADD CONSTRAINT group_pkey PRIMARY KEY (cod_course, cod_year, cod_group);
 <   ALTER TABLE ONLY public."group" DROP CONSTRAINT group_pkey;
       public            postgres    false    220    220    220            $           2606    35580    municipality municipio_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.municipality
    ADD CONSTRAINT municipio_pkey PRIMARY KEY (cod_municipality);
 E   ALTER TABLE ONLY public.municipality DROP CONSTRAINT municipio_pkey;
       public            postgres    false    222            &           2606    35582 &   promoted_student promoted_student_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.promoted_student
    ADD CONSTRAINT promoted_student_pkey PRIMARY KEY (dni);
 P   ALTER TABLE ONLY public.promoted_student DROP CONSTRAINT promoted_student_pkey;
       public            postgres    false    224            *           2606    35584    role role_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (cod_role);
 8   ALTER TABLE ONLY public.role DROP CONSTRAINT role_pkey;
       public            postgres    false    226            .           2606    35586    student student_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (dni);
 >   ALTER TABLE ONLY public.student DROP CONSTRAINT student_pkey;
       public            postgres    false    228            1           2606    35588    subject subject_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.subject
    ADD CONSTRAINT subject_pkey PRIMARY KEY (cod_subject);
 >   ALTER TABLE ONLY public.subject DROP CONSTRAINT subject_pkey;
       public            postgres    false    229            5           2606    35590 $   subject_student subject_student_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.subject_student
    ADD CONSTRAINT subject_student_pkey PRIMARY KEY (cod_subject, dni);
 N   ALTER TABLE ONLY public.subject_student DROP CONSTRAINT subject_student_pkey;
       public            postgres    false    231    231                       2606    35592    course unique_name 
   CONSTRAINT     T   ALTER TABLE ONLY public.course
    ADD CONSTRAINT unique_name UNIQUE (course_name);
 <   ALTER TABLE ONLY public.course DROP CONSTRAINT unique_name;
       public            postgres    false    216            8           2606    35594    users users_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_name);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    233                       2606    35668 &   withdraw_student withdraw_student_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.withdraw_student
    ADD CONSTRAINT withdraw_student_pkey PRIMARY KEY (dni);
 P   ALTER TABLE ONLY public.withdraw_student DROP CONSTRAINT withdraw_student_pkey;
       public            postgres    false    218            :           2606    35596    year year_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.year
    ADD CONSTRAINT year_pkey PRIMARY KEY (cod_year, cod_course);
 8   ALTER TABLE ONLY public.year DROP CONSTRAINT year_pkey;
       public            postgres    false    235    235            +           1259    35597 	   fki_group    INDEX     X   CREATE INDEX fki_group ON public.student USING btree (cod_group, cod_year, cod_course);
    DROP INDEX public.fki_group;
       public            postgres    false    228    228    228            ,           1259    35598    fki_municipality    INDEX     P   CREATE INDEX fki_municipality ON public.student USING btree (cod_municipality);
 $   DROP INDEX public.fki_municipality;
       public            postgres    false    228            6           1259    35599    fki_role    INDEX     >   CREATE INDEX fki_role ON public.users USING btree (cod_role);
    DROP INDEX public.fki_role;
       public            postgres    false    233            2           1259    35600    fki_student    INDEX     F   CREATE INDEX fki_student ON public.subject_student USING btree (dni);
    DROP INDEX public.fki_student;
       public            postgres    false    231            3           1259    35601    fki_subject    INDEX     N   CREATE INDEX fki_subject ON public.subject_student USING btree (cod_subject);
    DROP INDEX public.fki_subject;
       public            postgres    false    231                        1259    35602    fki_year    INDEX     L   CREATE INDEX fki_year ON public."group" USING btree (cod_year, cod_course);
    DROP INDEX public.fki_year;
       public            postgres    false    220    220            /           1259    35603    fki_year_course    INDEX     S   CREATE INDEX fki_year_course ON public.subject USING btree (cod_year, cod_course);
 #   DROP INDEX public.fki_year_course;
       public            postgres    false    229    229            M           2620    35685    student tg_change_student_type    TRIGGER     �   CREATE TRIGGER tg_change_student_type AFTER UPDATE ON public.student FOR EACH ROW EXECUTE FUNCTION public.change_student_type();
 7   DROP TRIGGER tg_change_student_type ON public.student;
       public          postgres    false    228    354            N           2620    35684    student tg_update_list_number    TRIGGER     �   CREATE TRIGGER tg_update_list_number AFTER INSERT OR DELETE OR UPDATE OF full_name, cod_group, cod_year, cod_course ON public.student FOR EACH ROW EXECUTE FUNCTION public.update_list_number();
 6   DROP TRIGGER tg_update_list_number ON public.student;
       public          postgres    false    228    353    228    228    228    228            G           2620    35683 &   withdraw_cause tg_validate_cause_entry    TRIGGER     �   CREATE TRIGGER tg_validate_cause_entry BEFORE INSERT OR UPDATE ON public.withdraw_cause FOR EACH ROW EXECUTE FUNCTION public.validate_cause_entry();
 ?   DROP TRIGGER tg_validate_cause_entry ON public.withdraw_cause;
       public          postgres    false    343    214            H           2620    35604 +   withdraw_cause validate_cause_entry_trigger    TRIGGER     �   CREATE TRIGGER validate_cause_entry_trigger BEFORE INSERT OR UPDATE ON public.withdraw_cause FOR EACH ROW EXECUTE FUNCTION public.validate_cause_entry();
 D   DROP TRIGGER validate_cause_entry_trigger ON public.withdraw_cause;
       public          postgres    false    214    343            I           2620    35605 $   course validate_course_entry_trigger    TRIGGER     �   CREATE TRIGGER validate_course_entry_trigger BEFORE INSERT OR UPDATE ON public.course FOR EACH ROW EXECUTE FUNCTION public.validate_course_entry();
 =   DROP TRIGGER validate_course_entry_trigger ON public.course;
       public          postgres    false    344    216            Q           2620    35606 1   subject_student validate_evaluation_entry_trigger    TRIGGER     �   CREATE TRIGGER validate_evaluation_entry_trigger BEFORE INSERT OR UPDATE ON public.subject_student FOR EACH ROW EXECUTE FUNCTION public.validate_evaluation_entry();
 J   DROP TRIGGER validate_evaluation_entry_trigger ON public.subject_student;
       public          postgres    false    231    345            J           2620    35607 0   municipality validate_municipality_entry_trigger    TRIGGER     �   CREATE TRIGGER validate_municipality_entry_trigger BEFORE INSERT OR UPDATE ON public.municipality FOR EACH ROW EXECUTE FUNCTION public.validate_municipality_entry();
 I   DROP TRIGGER validate_municipality_entry_trigger ON public.municipality;
       public          postgres    false    222    347            O           2620    35608 &   student validate_student_entry_trigger    TRIGGER     �   CREATE TRIGGER validate_student_entry_trigger BEFORE INSERT OR UPDATE ON public.student FOR EACH ROW EXECUTE FUNCTION public.validate_student_entry();
 ?   DROP TRIGGER validate_student_entry_trigger ON public.student;
       public          postgres    false    349    228            P           2620    35609 &   subject validate_subject_entry_trigger    TRIGGER     �   CREATE TRIGGER validate_subject_entry_trigger BEFORE INSERT OR UPDATE ON public.subject FOR EACH ROW EXECUTE FUNCTION public.validate_subject_entry();
 ?   DROP TRIGGER validate_subject_entry_trigger ON public.subject;
       public          postgres    false    229    352            R           2620    35610 !   users validate_user_entry_trigger    TRIGGER     �   CREATE TRIGGER validate_user_entry_trigger BEFORE INSERT OR UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.validate_user_entry();
 :   DROP TRIGGER validate_user_entry_trigger ON public.users;
       public          postgres    false    233    350            K           2620    35681 (   promoted_student veify_existence_student    TRIGGER     �   CREATE TRIGGER veify_existence_student BEFORE INSERT OR UPDATE ON public.promoted_student FOR EACH ROW EXECUTE FUNCTION public.exist_student();
 A   DROP TRIGGER veify_existence_student ON public.promoted_student;
       public          postgres    false    224    355            L           2620    35682 )   repeating_student veify_existence_student    TRIGGER     �   CREATE TRIGGER veify_existence_student BEFORE INSERT OR UPDATE ON public.repeating_student FOR EACH ROW EXECUTE FUNCTION public.exist_student();
 B   DROP TRIGGER veify_existence_student ON public.repeating_student;
       public          postgres    false    225    355            F           2606    35611    year course    FK CONSTRAINT     �   ALTER TABLE ONLY public.year
    ADD CONSTRAINT course FOREIGN KEY (cod_course) REFERENCES public.course(cod_course) ON UPDATE CASCADE ON DELETE CASCADE;
 5   ALTER TABLE ONLY public.year DROP CONSTRAINT course;
       public          postgres    false    235    3355    216            ?           2606    35657 )   repeating_student estudiante_repitente_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.repeating_student
    ADD CONSTRAINT estudiante_repitente_fk FOREIGN KEY (dni) REFERENCES public.student(dni) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 S   ALTER TABLE ONLY public.repeating_student DROP CONSTRAINT estudiante_repitente_fk;
       public          postgres    false    225    228    3374            @           2606    35616    student group    FK CONSTRAINT     �   ALTER TABLE ONLY public.student
    ADD CONSTRAINT "group" FOREIGN KEY (cod_group, cod_year, cod_course) REFERENCES public."group"(cod_group, cod_year, cod_course) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;
 9   ALTER TABLE ONLY public.student DROP CONSTRAINT "group";
       public          postgres    false    220    220    220    3362    228    228    228            A           2606    35621    student municipality    FK CONSTRAINT     �   ALTER TABLE ONLY public.student
    ADD CONSTRAINT municipality FOREIGN KEY (cod_municipality) REFERENCES public.municipality(cod_municipality) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;
 >   ALTER TABLE ONLY public.student DROP CONSTRAINT municipality;
       public          postgres    false    222    3364    228            >           2606    35674 $   promoted_student promoted_student_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.promoted_student
    ADD CONSTRAINT promoted_student_fk FOREIGN KEY (dni) REFERENCES public.student(dni) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 N   ALTER TABLE ONLY public.promoted_student DROP CONSTRAINT promoted_student_fk;
       public          postgres    false    3374    228    224            E           2606    35626 
   users role    FK CONSTRAINT     �   ALTER TABLE ONLY public.users
    ADD CONSTRAINT role FOREIGN KEY (cod_role) REFERENCES public.role(cod_role) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 4   ALTER TABLE ONLY public.users DROP CONSTRAINT role;
       public          postgres    false    226    3370    233            C           2606    35631    subject_student student    FK CONSTRAINT     �   ALTER TABLE ONLY public.subject_student
    ADD CONSTRAINT student FOREIGN KEY (dni) REFERENCES public.student(dni) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 A   ALTER TABLE ONLY public.subject_student DROP CONSTRAINT student;
       public          postgres    false    231    3374    228            D           2606    35636    subject_student subject    FK CONSTRAINT     �   ALTER TABLE ONLY public.subject_student
    ADD CONSTRAINT subject FOREIGN KEY (cod_subject) REFERENCES public.subject(cod_subject) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 A   ALTER TABLE ONLY public.subject_student DROP CONSTRAINT subject;
       public          postgres    false    229    231    3377            ;           2606    35641 /   withdraw_student withdraw_student_cod_causa_fke    FK CONSTRAINT     �   ALTER TABLE ONLY public.withdraw_student
    ADD CONSTRAINT withdraw_student_cod_causa_fke FOREIGN KEY (cod_cause) REFERENCES public.withdraw_cause(cod_cause) ON UPDATE CASCADE;
 Y   ALTER TABLE ONLY public.withdraw_student DROP CONSTRAINT withdraw_student_cod_causa_fke;
       public          postgres    false    214    3353    218            <           2606    35669 $   withdraw_student withdraw_student_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.withdraw_student
    ADD CONSTRAINT withdraw_student_fk FOREIGN KEY (dni) REFERENCES public.promoted_student(dni) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 N   ALTER TABLE ONLY public.withdraw_student DROP CONSTRAINT withdraw_student_fk;
       public          postgres    false    218    3366    224            =           2606    35646 
   group year    FK CONSTRAINT     �   ALTER TABLE ONLY public."group"
    ADD CONSTRAINT year FOREIGN KEY (cod_year, cod_course) REFERENCES public.year(cod_year, cod_course) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 6   ALTER TABLE ONLY public."group" DROP CONSTRAINT year;
       public          postgres    false    235    220    235    3386    220            B           2606    35651    subject year_course    FK CONSTRAINT     �   ALTER TABLE ONLY public.subject
    ADD CONSTRAINT year_course FOREIGN KEY (cod_year, cod_course) REFERENCES public.year(cod_year, cod_course) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 =   ALTER TABLE ONLY public.subject DROP CONSTRAINT year_course;
       public          postgres    false    235    229    229    3386    235            �   /   x�32��/�ItJ473�R�����Ss8]2�R�K�b���� &4      �      x�3�420��5202������ *�      �      x�3�4�4�27�Q�@*F��� +�=      �   C   x�3��I�L�24�t�/�/*��24��M,�L�K��9��|3�KSs�9}r2���b���� '8      �      x�302064���05�2@ �=... Q�      �      x�37033KK3.������ VOd      �   2   x�3�t�,JM.�/�2�NM.J-I,���2�t-.)M�L�+I�����  ��      �   +  x�}��n�0���S�	*�'9�ڊPę�,dl�<}�!J QF9��7���+%3�,Y@�΃�Bm�dF8Y�p��o� 2Ru� ��a�[Ni���5��i�0�zI)�%S�I9�(c4�EFm�d:�� ���83�IU��TЙ����v��K�_~m�lؑ(Mn��s�H?W�w
�����B�bO0]�]t���	�p�8Ir^��5������s����5Zu�r��Qde�m��Ri�S�^b�2�Qd�����'w��l��}`�c_�3��	�������|dY�7��X      �   T   x�34�tM)MNL�<�9O�������DcN#SN#Nc.3���ܤ�ĔDNCNC��)�GfqI~Qf�BJ��siR"�D&F��� �Y�      �   )   x�3�40403406��4�4�2���̌L@�=... x�      �   W  x�%��j#AE��_�_0�U-��b	���Q�T�ౡ�@��Oٳ� t�*��_�?����۟�/v�q�>�}?���r8�$�]�@��{MЍ#k�J]Eh�C��	��s�rG���.O���Ē�*��������s{��8]��A�"���&k�	Q�j��:$�#rA6̍J�A\�ӊ��q|�#�jɮ\��`.��ASxT��h(��3K8�l�4Õhy���l%?ĥ_�g��>��?�����\C�E@`��e ���E{!�Q8cme�I"��xy���H�ﶽ=�_����I��If�\Ld�&Z�}��PJ�U	�Ϊ]�Q��2t
Ly=�Z��>ϊe      �   K   x�3�L�KK-�MMIL�2�tI-N,(�OJ,�2�t��SHIUH-.)M��/�24�N��LI��($fs��qqq �M      �   '   x�37033SS3NC.S �L �3�C /F��� W�
�      �      x�3�4�2bc 6bS ����� (     