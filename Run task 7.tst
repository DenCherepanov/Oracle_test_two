PL/SQL Developer Test script 3.0
23
declare
  cursor pCur is
    select t.time_log,
           t.stage_type_id,
           t.text from tmp_clob t
    order by t.stage_type_id;
  pGet pCur%rowtype; 
begin
  -- Запуск рассчета
  AddLog;
  -- Вывод информация по таблце "tmp_clob"
  dbms_output.put_line(''); 
  dbms_output.put_line('Таблица логов');
  dbms_output.put_line(lpad('TIME_LOG', 31) || lpad('STAGE_TYPE_ID', 15) || '  ' || rpad('TEXT', 35));
  --
  open pCur;  
    loop
      fetch pCur into pGet;
      exit when pCur%notfound;        
      dbms_output.put_line(lpad(to_char(pGet.time_log), 31) || lpad(to_char(pGet.stage_type_id), 15) || '  ' || rpad(to_char(pGet.text), 35));
    end loop;  
  close pCur; 
end;
0
7
i.tm
vCnt
vMinTime
vMaxTime
pCol(i)
vSumm
vCnt
