-- Первое задание
-- Создание таблиц
create table reg_2021_11 (person_id number, asset_id number);
create table reg_2021_12 (person_id number, asset_id number);
-- Добавление данных reg_2021_11
insert into reg_2021_11 (person_id, asset_id) values(1, 1);
insert into reg_2021_11 (person_id, asset_id) values(2, 2);
insert into reg_2021_11 (person_id, asset_id) values(2, 2);
insert into reg_2021_11 (person_id, asset_id) values(3, 3);
insert into reg_2021_11 (person_id, asset_id) values(4, 4);
-- Добавление данных reg_2021_12
insert into reg_2021_12 (person_id, asset_id) values(1, 1);
insert into reg_2021_12 (person_id, asset_id) values(2, 2);
insert into reg_2021_12 (person_id, asset_id) values(3, 3);
insert into reg_2021_12 (person_id, asset_id) values(3, 3);
insert into reg_2021_12 (person_id, asset_id) values(4, 4);
commit;
-- Решение
select decode(count(*), 0, 'Идентичны', 'Не идентичны') text
from (select person_id, asset_id, count(*) cnt 
      from reg_2021_11
      group by person_id, asset_id
      minus  
      select person_id, asset_id, count(*) cnt
      from reg_2021_12
group by person_id, asset_id)

-- Второе задание
-- Создание таблиц
create table t (cl_id number, nm varchar2(20), dt date, summ number);
-- Добавление данных t
insert into t (cl_id, nm, dt, summ) values(1, 'Иванов', to_date('01.01.2022', 'DD.MM.YYYY'), 10.12);
insert into t (cl_id, nm, dt, summ) values(1, 'Иванов', to_date('12.02.2022', 'DD.MM.YYYY'), 120.21);
insert into t (cl_id, nm, dt, summ) values(1, 'Иванов', to_date('16.04.2021', 'DD.MM.YYYY'), 0.22);
insert into t (cl_id, nm, dt, summ) values(1, 'Иванов', to_date('15.04.2022', 'DD.MM.YYYY'), 356.1);
insert into t (cl_id, nm, dt, summ) values(1, 'Иванов', to_date('21.04.2021', 'DD.MM.YYYY'), 12.1);
insert into t (cl_id, nm, dt, summ) values(2, 'Петров', to_date('18.04.2020', 'DD.MM.YYYY'), 100);
insert into t (cl_id, nm, dt, summ) values(2, 'Петров', to_date('13.04.2019', 'DD.MM.YYYY'), 25512.12);
commit;
-- Решение
select t.nm,
       to_char(t.dt, 'IW') || ' неделя ' || to_char(t.dt, 'YYYY') week,
       to_char(t.summ, '99G990D99') sum_tran,
       to_char(t1.sm, '99G990D99') sum_tran_all
from t
inner join (select to_char(t.dt, 'IW') wk, sum(t.summ) sm
            from t
            group by to_char(t.dt, 'IW')) t1 on to_char(t.dt, 'IW') = t1.wk
where to_char(t.dt, 'IW') in (15, 16)

-- Третье задание
-- Создание таблицы
create table t3 (id number, pid number, nam varchar2(100));
-- Добавление данных в clients
insert into t3 (id, pid, nam) values(1, null, 'Банк');
insert into t3 (id, pid, nam) values(2, 1,    'Департамент IT');
insert into t3 (id, pid, nam) values(3, 1,    'Департамент безопасности');
insert into t3 (id, pid, nam) values(4, 2,    'Управление развития');
insert into t3 (id, pid, nam) values(5, 4,    'Отдел рекламы');
insert into t3 (id, pid, nam) values(6, 5,    'Группа баннеров');
insert into t3 (id, pid, nam) values(7, 4,    'Отдел развития');
commit;
-- Решение
select id, pid, nam, prior nam parent_nam
from t3 
where id not in (select id from t3 connect by prior id = pid start with id = 5)
connect by prior id = pid
start with id = 1
order siblings by nam;

-- Четвертное задание
-- Создание таблиц
create table clients (cl_id number, name varchar2(20));
create table products (cl_id number, prod_id number, status number, name varchar2(20));
-- Добавление данных в clients
insert into clients (cl_id, name) values(1, 'Иванов');
insert into clients (cl_id, name) values(2, 'Петров');
insert into clients (cl_id, name) values(3, 'Сидоров');
-- Добавление данных в products
insert into products (cl_id, prod_id, status, name) values(1, 1, 0, 'Кредит');
insert into products (cl_id, prod_id, status, name) values(1, 2, 1, 'Депозит');
insert into products (cl_id, prod_id, status, name) values(1, 3, 1, 'Акция');
insert into products (cl_id, prod_id, status, name) values(1, 4, 0, 'Облигация');
insert into products (cl_id, prod_id, status, name) values(2, 1, 1, 'Кредит');
insert into products (cl_id, prod_id, status, name) values(2, 2, 0, 'Депозит');
commit;
-- Решение
select xmlroot((select xmlelement("Client", xmlattributes(c.name "name"),
                       xmlagg(xmlelement("Product",
                       xmlattributes(p.name as "name"), p.status)))
                from clients c
                left join products p on p.cl_id = c.cl_id
                where c.cl_id = 1
                group by c.cl_id, c.name), 
                version '1.0').getStringVal() from dual;

-- Пятое задание
-- Создание таблиц
create table payments (id number, pay_type number, pay_type_label varchar2(100), pay_date date, pay_sum number);
-- Добавление данных t
insert into payments (id, pay_type, pay_type_label, pay_date, pay_sum) values(1,  2, 'Перевод денежных средств', to_date('01.01.2022', 'DD.MM.YYYY'), 600);
insert into payments (id, pay_type, pay_type_label, pay_date, pay_sum) values(2,  3, 'Оплата услуг',             to_date('10.01.2022', 'DD.MM.YYYY'), 1100);
insert into payments (id, pay_type, pay_type_label, pay_date, pay_sum) values(3,  1, 'Комиссия',                 to_date('01.01.2022', 'DD.MM.YYYY'), 100);
insert into payments (id, pay_type, pay_type_label, pay_date, pay_sum) values(4,  1, 'Комиссия',                 to_date('02.01.2022', 'DD.MM.YYYY'), 200);
insert into payments (id, pay_type, pay_type_label, pay_date, pay_sum) values(5,  3, 'Оплата услуг',             to_date('01.03.2022', 'DD.MM.YYYY'), 1200);
insert into payments (id, pay_type, pay_type_label, pay_date, pay_sum) values(6,  2, 'Перевод денежных средств', to_date('01.02.2022', 'DD.MM.YYYY'), 700);
insert into payments (id, pay_type, pay_type_label, pay_date, pay_sum) values(7,  1, 'Комиссия',                 to_date('03.01.2022', 'DD.MM.YYYY'), 300);
insert into payments (id, pay_type, pay_type_label, pay_date, pay_sum) values(8,  2, 'Перевод денежных средств', to_date('01.04.2022', 'DD.MM.YYYY'), 800);
insert into payments (id, pay_type, pay_type_label, pay_date, pay_sum) values(9,  3, 'Оплата услуг',             to_date('01.05.2022', 'DD.MM.YYYY'), 1300);
insert into payments (id, pay_type, pay_type_label, pay_date, pay_sum) values(10, 1, 'Комиссия',                 to_date('01.02.2022', 'DD.MM.YYYY'), 400);
insert into payments (id, pay_type, pay_type_label, pay_date, pay_sum) values(11, 2, 'Перевод денежных средств', to_date('01.05.2022', 'DD.MM.YYYY'), 900);
insert into payments (id, pay_type, pay_type_label, pay_date, pay_sum) values(12, 3, 'Оплата услуг',             to_date('05.05.2022', 'DD.MM.YYYY'), 1400);
insert into payments (id, pay_type, pay_type_label, pay_date, pay_sum) values(13, 3, 'Оплата услуг',             to_date('01.06.2022', 'DD.MM.YYYY'), 1500);
insert into payments (id, pay_type, pay_type_label, pay_date, pay_sum) values(14, 2, 'Перевод денежных средств', to_date('01.06.2022', 'DD.MM.YYYY'), 1000);
insert into payments (id, pay_type, pay_type_label, pay_date, pay_sum) values(15, 1, 'Комиссия',                 to_date('01.02.2022', 'DD.MM.YYYY'), 5500); -- в оригинальных данных было 500, сделал 5500, чтобы немного усложнить задачу
commit;
-- Решение
select t.id, t.pay_type, t.pay_type_label, t.pay_date, t.pay_sum,
       -- сделал сортировку еще и по id, на тот случай когда дата равны внутри одного pay_type_label
       sum(t.pay_sum) over(partition by t.pay_type order by t.pay_date, t.id range unbounded preceding) sm 
from payments t
where t.pay_type in (select t.pay_type
                     from (select t.pay_type, sum(t.pay_sum) pay_sum
                           from payments t
                           group by t.pay_type) t
                     where t.pay_sum = (select max(t.pay_sum) pay_sum
                                        from (select t.pay_type, sum(t.pay_sum) pay_sum
                                              from payments t
                                              group by t.pay_type) t))
order by t.pay_type, t.pay_date

-- Шестое задание
-- Создание таблиц
create table t_cl (id number, name varchar2(20), birth_day date);
-- Добавление данных t
insert into t_cl (id, name, birth_day) values(1, 'Клиент 1', to_date('05.01.1965', 'DD.MM.YYYY'));
insert into t_cl (id, name, birth_day) values(2, 'Клиент 2', to_date('25.01.1976', 'DD.MM.YYYY'));
insert into t_cl (id, name, birth_day) values(3, 'Клиент 3', to_date('07.02.1978', 'DD.MM.YYYY'));
insert into t_cl (id, name, birth_day) values(4, 'Клиент 4', to_date('17.03.1979', 'DD.MM.YYYY'));
insert into t_cl (id, name, birth_day) values(5, 'Клиент 5', to_date('26.08.1979', 'DD.MM.YYYY'));
insert into t_cl (id, name, birth_day) values(6, 'Клиент 6', to_date('05.12.1962', 'DD.MM.YYYY'));
commit;
-- Решение
-- Чтобы избежать случаев в високосными годами приведем все даты к виду некоего веса MM * 100 + DD
select t.id, t.name, t.birth_day
from (select t.*,
             extract(month from t.birth_day) * 100 + extract(day from t.birth_day) ves_dt, 
             extract(month from to_date('01.12.2021', 'DD.MM.YYYY')) * 100 + extract(day from to_date('01.12.2021', 'DD.MM.YYYY')) ves_dt_st,
             extract(month from to_date('01.12.2021', 'DD.MM.YYYY') + 50) * 100 + extract(day from to_date('01.12.2021', 'DD.MM.YYYY') + 50) ves_dt_end
      from t_cl t) t
where (t.ves_dt between t.ves_dt_st and t.ves_dt_end and t.ves_dt_st <= t.ves_dt_end) or
      ((t.ves_dt <= t.ves_dt_end or t.ves_dt >= t.ves_dt_st) and t.ves_dt_st > t.ves_dt_end)
      
-- Седьмое задание
-- Создание таблиц
create table tbl_order_row (stage_id number, order_id number, begin_date date, end_date date, stage_type_id number);
create table tmp_clob (time_log timestamp with time zone, stage_type_id number, text varchar2(100));
create unique index time_stage on tmp_clob(time_log, stage_type_id);
-- alter session set nls_timestamp_tz_format = 'YYYY-MM-DD HH24:MI:SS.FF6 TZR';
-- Добавление данных t
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437855, 77832,	to_date('25.11.2021 00:12:19', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 00:12:26', 'DD.MM.YYYY HH24:MI:SS'), 5571);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437856, 77832,	to_date('25.11.2021 00:12:26', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 00:12:27', 'DD.MM.YYYY HH24:MI:SS'), 5572);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437857, 77832,	to_date('25.11.2021 00:12:33', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 00:12:34', 'DD.MM.YYYY HH24:MI:SS'), 5573);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437864, 77833,	to_date('25.11.2021 00:14:49', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 00:14:56', 'DD.MM.YYYY HH24:MI:SS'), 5571);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437865, 77833, to_date('25.11.2021 00:14:56', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 00:14:56', 'DD.MM.YYYY HH24:MI:SS'), 5572);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437866, 77833, to_date('25.11.2021 00:15:04', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 00:15:04', 'DD.MM.YYYY HH24:MI:SS'), 5573);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437873, 77834, to_date('25.11.2021 00:24:33', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 00:24:41', 'DD.MM.YYYY HH24:MI:SS'), 5571);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437874, 77834, to_date('25.11.2021 00:24:41', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 00:24:41', 'DD.MM.YYYY HH24:MI:SS'), 5572);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437875, 77834, to_date('25.11.2021 00:24:49', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 00:24:49', 'DD.MM.YYYY HH24:MI:SS'), 5573);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437882, 77835, to_date('25.11.2021 00:25:22', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 00:25:22', 'DD.MM.YYYY HH24:MI:SS'), 5571);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437883, 77835, to_date('25.11.2021 00:25:22', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 00:25:22', 'DD.MM.YYYY HH24:MI:SS'), 5572);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437884, 77835, to_date('25.11.2021 00:25:22', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 00:25:23', 'DD.MM.YYYY HH24:MI:SS'), 5573);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437891, 77836, to_date('25.11.2021 00:44:04', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 00:44:11', 'DD.MM.YYYY HH24:MI:SS'), 5571);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437892, 77836, to_date('25.11.2021 00:44:11', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 00:44:11', 'DD.MM.YYYY HH24:MI:SS'), 5572);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437893, 77836, to_date('25.11.2021 00:44:18', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 00:44:19', 'DD.MM.YYYY HH24:MI:SS'), 5573);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437900, 77837, to_date('25.11.2021 00:48:03', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 00:48:11', 'DD.MM.YYYY HH24:MI:SS'), 5571);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437901, 77837, to_date('25.11.2021 00:48:11', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 00:48:11', 'DD.MM.YYYY HH24:MI:SS'), 5572);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437902, 77837, to_date('25.11.2021 00:48:18', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 00:48:19', 'DD.MM.YYYY HH24:MI:SS'), 5573);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437911, 77840, to_date('25.11.2021 01:29:19', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 01:29:26', 'DD.MM.YYYY HH24:MI:SS'), 5571);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437912, 77840, to_date('25.11.2021 01:29:26', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 01:29:26', 'DD.MM.YYYY HH24:MI:SS'), 5572);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437913, 77840, to_date('25.11.2021 01:29:34', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 01:29:34', 'DD.MM.YYYY HH24:MI:SS'), 5573);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437920, 77841, to_date('25.11.2021 01:36:48', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 01:36:55', 'DD.MM.YYYY HH24:MI:SS'), 5571);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437921, 77841, to_date('25.11.2021 01:36:55', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 01:36:56', 'DD.MM.YYYY HH24:MI:SS'), 5572);
insert into tbl_order_row (stage_id, order_id, begin_date, end_date, stage_type_id)
values(437922, 77841, to_date('25.11.2021 01:37:04', 'DD.MM.YYYY HH24:MI:SS'), to_date('25.11.2021 01:37:04', 'DD.MM.YYYY HH24:MI:SS'), 5573);
commit;
-- Решение
-- 1. Запустить скрипт "AddLog.sql" для создания процедуры
-- 2. Запустить "Run task 7.tst" для отображения результат
