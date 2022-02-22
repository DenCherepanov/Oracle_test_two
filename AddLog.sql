create or replace procedure AddLog
is
  type numTbl is table of number index by pls_integer;
  vMinTime     number := 0; -- минимальное время обработки заявки на этапе
  vMaxTime     number := 0; -- максимальное время обработки заявки на этапе
  vStageTypeID number := 0; -- тип заявки
  vCnt         number := 0; -- количество заявок в одном типе этапа
  vColStage    numTbl;
  
  -- Для работы из с таблицей нас интересует только данные о типе этапа и времени обработки заявки в секундах, отсортированные по типу этапа
  cursor curTbl
  is
    select t.stage_type_id, (t.end_date - t.begin_date)*24*60*60 as tm
    from tbl_order_row t
    order by t.stage_type_id, (t.end_date - t.begin_date)*24*60*60;
    
  -- Функция, вычисляющая среднее значение времени обработки
  function fAvgTime (pCol in numTbl, pMimT in number, pMaxT in number) return varchar is
    vSumm number := 0;
    vCnt  number := 0;
  begin
    for i in 1..pCol.count
    loop
      if pCol(i) != pMimT and pCol(i) != pMaxT then
        vSumm := vSumm + pCol(i);
        vCnt := vCnt + 1;
      end if;  
    end loop;
    if vCnt = 0 then 
      return 'NO';
    else 
      return to_char(round(vSumm/vCnt, 1));
    end if;
  end;
  
  -- Процедура записи логов
  procedure pWriteLog(pCol in numTbl, pMimT in number, pMaxT in number) is
    vAvgTime varchar2(10);
  begin
    vAvgTime := fAvgTime(pCol, pMimT, pMaxT);
    insert into tmp_clob(time_log, stage_type_id, text) 
    values(systimestamp, vStageTypeID, 'MIN=' || to_char(pMimT) || '; MAX=' || to_char(pMaxT) || '; AVG=' || vAvgTime);
    commit;
  end;  
  
  -- Процедура очистки переменных
  procedure pClearVariable is
  begin
    vMinTime := 0; 
    vMaxTime := 0;
    vStageTypeID := 0;
    vCnt := 0;
    vColStage.delete(1, vColStage.Count);
  end;
  
begin
  for i in curTbl loop    
    if i.stage_type_id != vStageTypeID and vStageTypeID != 0 then
      -- Пишем лог
      pWriteLog(vColStage, vMinTime, vMaxTime);
      -- Очищаем переменные
      pClearVariable;
    end if;
    -- Запоминам тип заявки
    if i.stage_type_id != vStageTypeID then
      vStageTypeID := i.stage_type_id;
    end if;
    -- Переопределяем min и max, если требуется
    if i.tm < vMinTime then
      vMinTime := i.tm;
    end if;
    if i.tm > vMaxTime then
      vMaxTime := i.tm;
    end if;
    -- Добавляем элемент в массив относительно типа заявки
    vCnt := vCnt + 1;
    vColStage(vCnt) := i.tm;
  end loop;
  -- Пишем лог по последнему типу заявки
  pWriteLog(vColStage, vMinTime, vMaxTime);  
end;
