# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: sabmp603.4gl
# Descriptions...: 展BOM新邏輯作業
# Date & Author..: 2009/09/02 arman , 重寫算法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0015 09/11/04 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-9B0071 09/11/10 By wujie   5.2SQL转标准语法
 
IMPORT os

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm RECORD
             a   VARCHAR(1),
             max_level  SMALLINT,
             yy         INT,           #add by zv 080610
             mm         INT,           #add by zv 080610
             sw         VARCHAR(01)    #No.FUN-5B0085 add
          END RECORD  
 
DEFINE   infor                    STRING
DEFINE   g_logdate,g_logfile      LIKE type_file.chr100 
DEFINE   g_db_type                LIKE type_file.chr3  
DEFINE   g_log                    LIKE type_file.chr10 
 
FUNCTION p603_log(l_input)
DEFINE l_cmd,l_input  STRING
 
   #如果當前是有界面，則將執行過程顯示在界面上
   LET infor = infor,l_input
   IF g_bgjob = 'N' THEN
    IF g_log = 'Y' THEN
      DISPLAY BY NAME infor
    END IF
      CALL ui.Interface.refresh()
   END IF
   #寫日志文件
   LET l_cmd = "echo '",infor,"' > ",g_logfile
   RUN l_cmd
END FUNCTION  
 
FUNCTION p603(p_name,p_log)
DEFINE 
  p_name                                  LIKE type_file.chr10,
  p_log                                   LIKE type_file.chr10,
  l_time                                  VARCHAR(8),
  l_sql                                   VARCHAR(2000),            
  l_cnt,l_cnt2,l_cnt_remain,l_max_level   INTEGER, 
  l_level,l_unlock_time                   SMALLINT,
  l_start,l_end                           DATE,
  l_begin,l_tot_begin                     DATETIME HOUR TO SECOND,
  l_cmd                                   STRING,
  l_base_parent,l_base_child              LIKE ima_file.ima01,
  l_yy,l_mm                               INTEGER,
  l_curdate                               STRING,
  l_ty                                    VARCHAR(4),
  l_tm                                    VARCHAR(2)
DEFINE    l_str                           VARCHAR(50)
DEFINE    l_tmp                           VARCHAR(21)
#No.TQC-9B0015  --Begin
DEFINE l_yy1     LIKE type_file.num5
DEFINE l_mm1     LIKE type_file.num5
#No.TQC-9B0015  --End
 
     WHENEVER ERROR CALL cl_err_msg_log

     LET g_logdate = YEAR(CURRENT) USING "####",MONTH(CURRENT) USING "&&",DAY(CURRENT) USING "&&","-",TIME(CURRENT)

     LET g_logfile = g_user CLIPPED,"-",g_dbs CLIPPED,"-",g_logdate CLIPPED,'.log'
     LET g_logfile = os.Path.join(FGL_GETENV("TEMPDIR"),g_logfile CLIPPED)

     LET infor = ''
     LET g_log = p_log
 
     LET g_db_type=cl_db_get_database_type()    

     #抓取要計算的年月
     SELECT ccz01,ccz02 INTO  l_yy,l_mm
       FROM ccz_file WHERE ccz00='0'
     LET l_ty = l_yy
     LET l_tm = l_mm USING '&&'
     LET l_curdate = l_ty CLIPPED, l_tm CLIPPED, '01'
     
     #取該年月第一天和最后一天
     #No.TQC-9B0015  --Begin
     #LET l_sql = "SELECT ADD_MONTHS(LAST_DAY(to_date('",l_curdate,"','yyyymmdd'))+1,-1), ",
     #            "LAST_DAY(to_date('",l_curdate,"','yyyymmdd')) FROM DUAL"
     #PREPARE p603_date FROM l_sql
     #EXECUTE p603_date INTO l_start, l_end
     IF l_mm = 12 THEN
        LET l_mm1 = 1
        LET l_yy1 = l_yy + 1
     ELSE
        LET l_yy1 = l_yy
        LET l_mm1 = l_mm + 1
     END IF
     LET l_start = MDY(l_mm,1,l_yy)
     LET l_end = MDY(l_mm1,1,l_yy1) - 1
    
     #No.TQC-9B0015  --End  
 
     #顯示執行過程
     LET l_tot_begin = TIME(CURRENT)
     LET l_str = cl_getmsg('abm-044',g_lang),l_tot_begin,'\n',cl_getmsg('abm-045',g_lang)
     CALL p603_log(l_str)
     LET l_str = ''
   
     #創建臨時表
     DROP TABLE tmp_ima
#    CREATE TEMP TABLE tmp_ima(t_ima01 VARCHAR(40));
     CREATE TEMP TABLE tmp_ima(
            t_ima01 LIKE type_file.chr50);  #No.FUN-9B0071
     CREATE UNIQUE INDEX tmp_ima_01 ON tmp_ima(t_ima01);
     DROP TABLE tmp_child
#    CREATE TEMP TABLE tmp_child(parent VARCHAR(40), child VARCHAR(40), origin VARCHAR(3))
     CREATE TEMP TABLE tmp_child(
            parent LIKE type_file.chr50, 
            child LIKE type_file.chr50, 
            origin LIKE type_file.chr3)   #No.FUN-9B0071
     CREATE UNIQUE INDEX tmp_child_01 ON tmp_child(parent,child)
     CREATE INDEX tmp_child_02 ON tmp_child(child)
     DROP TABLE sub_ima
#    CREATE TEMP TABLE sub_ima(s_ima01 VARCHAR(40))
     CREATE TEMP TABLE sub_ima(
            s_ima01 LIKE type_file.chr50)    #No.FUN-9B0071
     CREATE UNIQUE INDEX sub_ima_01 ON sub_ima(s_ima01)
 
     #顯示執行過程
     LET l_begin = TIME(CURRENT)
     LET l_str = cl_getmsg('abm-046',g_lang),l_begin,'-',l_tot_begin,'\n',cl_getmsg('abm-047',g_lang)
     CALL p603_log(l_str)
     LET l_str = ''
 
     BEGIN WORK
 
     #填充單頭臨時表
     INSERT INTO tmp_ima SELECT ima01 FROM ima_file
     IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
        CALL cl_err('IMA_FILE -> TMP_IMA :',SQLCA.sqlcode,1) 
     END IF
  
     COMMIT WORK
 
     BEGIN WORK
 
     #計算筆數并顯示執行過程
     SELECT COUNT(*) INTO l_cnt FROM tmp_ima
     LET l_str = l_cnt,cl_getmsg('abm-048',g_lang),TIME(CURRENT),'-',l_begin,'\n',cl_getmsg('abm-049',g_lang)
     CALL p603_log(l_str)
     LET l_str = ''
     LET l_begin = TIME(CURRENT)
   IF p_name ='abmp603' THEN
     #從bmb_file中取資料填充父子關系表
     LET l_sql = "INSERT INTO tmp_child ",
                 "  SELECT DISTINCT bmb01 parent, bmb03 child, 'BMB' origin FROM bmb_file, bma_file ",
                 "WHERE bmb01 = bma01 AND bmaacti = 'Y' AND bma05 <= '",l_end,"' AND ",
                 "  bmb04 <='",l_end,"' AND ( bmb05 > '",l_end,"' OR bmb05 IS NULL) AND bmb01 <> bmb03 "
     PREPARE p603_bmb FROM l_sql
     EXECUTE p603_bmb 
     IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
        CALL cl_err('BMB_FILE -> TMP_CHILD :',SQLCA.sqlcode,1) 
     END IF
 
     COMMIT WORK
 
     SELECT COUNT(*) INTO l_cnt FROM tmp_child
     LET l_str = l_cnt,cl_getmsg('abm-048',g_lang),TIME(CURRENT),'-',l_begin,'\n',cl_getmsg('abm-050',g_lang)
     CALL p603_log(l_str)
     LET l_str = ''
     LET l_begin = TIME(CURRENT)
 
     BEGIN WORK
 
     #從bmd_file中取資料填充父子關系表
     LET l_sql = "INSERT INTO tmp_child ",
                 "  SELECT DISTINCT bmd08 parent, bmd04 child, 'BMD' origin FROM bmd_file ",
                 "  WHERE bmd05 <= '",l_end,"' AND ( bmd06 > '",l_end,"' OR bmd06 IS NULL ) AND bmd08 <> bmd04",
                 "    AND NOT EXISTS ( SELECT 1 FROM tmp_child WHERE bmd08 = parent AND bmd04 =child ) "
     PREPARE p603_bmd FROM l_sql
     EXECUTE p603_bmd 
     IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
        CALL cl_err('BMD_FILE -> TMP_CHILD :',SQLCA.sqlcode,1) 
     END IF
 
     COMMIT WORK
 
     #計算筆數并提示執行過程
     SELECT COUNT(*) INTO l_cnt2 FROM tmp_child
     LET l_str = l_cnt2-l_cnt,cl_getmsg('abm-048',g_lang),TIME(CURRENT),'-',l_begin,'\n',cl_getmsg('abm-051',g_lang)
     CALL p603_log(l_str)
     LET l_str = ''
     LET l_begin = TIME(CURRENT)
   ELSE
    IF p_name = 'abmp604' THEN   
     BEGIN WORK
 
     LET l_sql = "INSERT INTO tmp_child SELECT DISTINCT sfb05 parent, sfe07 child, 'SFE' origin FROM sfe_file, sfb_file ",
                 "WHERE sfe01 = sfb01 AND sfe04 BETWEEN '",l_start,"' AND '",l_end,"' ",
                 "  AND sfbacti = 'Y' AND sfb87 = 'Y' AND sfb81 <= '",l_end,"' ",
                 "  AND (sfb38>= '",l_start,"' OR sfb38 IS NULL ) AND sfb05 <> sfe07 ",
                 "  AND NOT EXISTS ( SELECT 1 FROM tmp_child WHERE sfb05 = parent AND sfe07 = child )"
     PREPARE p603_sfe FROM l_sql
     EXECUTE p603_sfe 
     IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
        CALL cl_err('SFE_FILE -> TMP_CHILD :',SQLCA.sqlcode,1) 
     END IF
 
     COMMIT WORK
 
     #計算筆數并提示執行過程
     SELECT COUNT(*) INTO l_cnt FROM tmp_child
     LET l_str = l_cnt-l_cnt2,cl_getmsg('abm-048',g_lang),TIME(CURRENT),'-',l_begin,'\n',cl_getmsg('abm-052',g_lang)
     CALL p603_log(l_str)
     LET l_str = ''
     LET l_begin = TIME(CURRENT)
 
     BEGIN WORK
 
     #從sfa_file中取資料填充父子關系表
     LET l_sql = "INSERT INTO tmp_child SELECT DISTINCT sfb05 parent, sfa03 child, 'SFA' origin FROM sfa_file, sfb_file ",
                 "WHERE sfa01 = sfb01 AND (sfb38 >= '",l_start,"' OR sfb38 IS NULL) ",
                 "  AND sfbacti = 'Y' AND sfb87 = 'Y' AND sfb81 <= '",l_end,"' AND sfb05 <> sfa03 ",
                 "  AND NOT EXISTS ( SELECT 1 FROM tmp_child WHERE sfb05 = parent AND sfa03 = child )"
     PREPARE p603_sfa FROM l_sql
     EXECUTE p603_sfa 
     IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
        CALL cl_err('SFA_FILE -> TMP_CHILD :',SQLCA.sqlcode,1) 
     END IF
 
     COMMIT WORK
 
     #從0階料開始展
     LET l_level = 0
     #計算筆數并提示執行過程
     SELECT COUNT(*) INTO l_cnt2 FROM tmp_child
     LET l_str = l_cnt2-l_cnt,cl_getmsg('abm-048',g_lang),TIME(CURRENT),'-',l_begin,'\n',cl_getmsg('abm-053',g_lang),l_level,cl_getmsg('abm-054',g_lang)
     CALL p603_log(l_str)
     LET l_str = ''
     LET l_begin = TIME(CURRENT)
    END IF
   END IF
     BEGIN WORK
 
     #這一步是安全性防范措施
     #因為雖然理論上不會出現在BOM或工單中存在IMA中不存在的料，但如果萬一數據中有紊亂，這種狀況可能會造成死循環，所以要提前剔除
     DELETE FROM tmp_child WHERE NOT EXISTS
       ( SELECT 1 FROM tmp_ima WHERE t_ima01 = parent )
     LET l_cnt = SQLCA.SQLERRD[3]
     LET l_str = '/n',cl_getmsg('abm-055',g_lang),TIME(CURRENT),l_cnt,cl_getmsg('abm-056',g_lang)
     CALL p603_log(l_str)
     LET l_str = ''
 
     COMMIT WORK
 
#-----------------------------------------------------
#ADD BY HUJIE 20090627  --Start--  將死循環先剔除
 
#LET l_sql=		"SELECT DISTINCT X1||Y1||Z1 FROM  ",
#							"( ",
#							"  SELECT * FROM " ,
#							"  (SELECT PARENT x1,CHILD y1,origin z1 FROM Debug_Child ), ",
#							"  (SELECT PARENT x2,CHILD y2,origin z2 FROM Debug_Child ) ",
#							"  WHERE x1=y2 AND y1=x2  ",
#							"  AND (Z1<>'BMB' OR Z2<>'BMB') ",
#							") ",
#							"WHERE Z1<>'BMB' ",
#							"UNION ",
#							"SELECT DISTINCT X2||Y2||Z2 FROM  ",
#							"( ",
#							"  SELECT * FROM ",
#							"  (SELECT PARENT x1,CHILD y1,origin z1 FROM Debug_Child ), ",
#							"  (SELECT PARENT x2,CHILD y2,origin z2 FROM Debug_Child ) ",
#							"  WHERE x1=y2 AND y1=x2  ",
#							"  AND (Z1<>'BMB' OR Z2<>'BMB') ",
#							") ",
#							"WHERE Z2<>'BMB' " 
#LET l_sql="DELETE FROM tmp_child WHERE parent||child||origin IN ( ",l_sql," ) "
 
#add by yf2002 090702 begin Debug_Child ===>tmp_child
LET l_sql=		"SELECT DISTINCT X1||Y1||Z1 FROM  ",                                
							"( ",                                                               
							"  SELECT * FROM " ,                                                
							"  (SELECT PARENT x1,CHILD y1,origin z1 FROM tmp_child ), ",      
							"  (SELECT PARENT x2,CHILD y2,origin z2 FROM tmp_child ) ",       
							"  WHERE x1=y2 AND y1=x2  ",                                        
							"  AND (Z1<>'BMB' OR Z2<>'BMB') ",                                  
							") ",                                                               
							"WHERE Z1<>'BMB' ",                                                 
							"UNION ",                                                           
							"SELECT DISTINCT X2||Y2||Z2 FROM  ",                                
							"( ",                                                               
							"  SELECT * FROM ",                                                 
							"  (SELECT PARENT x1,CHILD y1,origin z1 FROM tmp_child ), ",      
							"  (SELECT PARENT x2,CHILD y2,origin z2 FROM tmp_child ) ",       
							"  WHERE x1=y2 AND y1=x2  ",                                        
							"  AND (Z1<>'BMB' OR Z2<>'BMB') ",                                  
							") ",                                                               
							"WHERE Z2<>'BMB' "                                                  
LET l_sql="DELETE FROM tmp_child WHERE parent||child||origin IN ( ",l_sql," ) "  
#add by yf2002 090702 end
 
 
     PREPARE del_tmp_child_1 FROM l_sql
     EXECUTE del_tmp_child_1
     LET l_cnt = SQLCA.SQLERRD[3]
     LET l_str = '/n',cl_getmsg('abm-055',g_lang),TIME(CURRENT),l_cnt,cl_getmsg('abm-057',g_lang)
     CALL p603_log(l_str)     
     LET l_str = ''
#ADD BY HUJIE 20090627  --End--
 
#-----------------------------------------------------
 
     #-----------FOR DEBUG----------------------------------------------
     IF g_db_type = 'ORA'  THEN
      LET l_sql= "TRUNCATE TABLE debug_ima" 
      PREPARE del_debug_ima FROM l_sql
      EXECUTE del_debug_ima
 
      LET l_sql= "TRUNCATE TABLE debug_sub" 
      PREPARE del_debug_sub FROM l_sql
      EXECUTE del_debug_sub
 
      LET l_sql= "TRUNCATE TABLE debug_child" 
      PREPARE del_debug_child FROM l_sql
      EXECUTE del_debug_child
     END IF
     INSERT INTO debug_ima SELECT -1,t_ima01 FROM tmp_ima
     INSERT INTO debug_child SELECT -1,parent,child,origin FROM tmp_child
 
     #------------------------------------------------------------------  
 
     #開始主循環
     #循環內容，剝離頂層料件（即只存在于單頭而不存在于單身的料件）
     #被剝離出來的料件被暫存與sub_ima中，并會被從tmp_ima,tmp_bma,tmp_child中刪除
     #當某次剝離出來發現結果集為空時，說明已經沒有頂層料件，此時如果tmp_ima中為空，則表示低階碼運算結束
     #否則說明有循環存在，tmp_ima中為涉及循環的料件
   
     LET l_unlock_time = 0    #如果當下面l_cnt = 0 但 tmp_ima數量 <> 0的時候，如果l_unlock_time = 0，表示正常展階，>0均表示在解套
     WHILE TRUE
  
        BEGIN WORK
 
        #找出有單頭無單身的料件
        INSERT INTO sub_ima SELECT t_ima01 AS s_ima01 FROM tmp_ima
          WHERE NOT EXISTS ( SELECT 1 FROM tmp_child WHERE child = t_ima01 )
        IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
           CALL cl_err('INSERT INTO sub_ima:',SQLCA.sqlcode,1) 
        END IF
 
        COMMIT WORK
  
        SELECT COUNT(*) INTO l_cnt FROM sub_ima
        LET l_str = l_cnt,cl_getmsg('abm-058',g_lang)
        CALL p603_log(l_str)
        LET l_str = ''
        
        #如果當前沒有了則要判斷是出現循環還是全部執行完畢
        LET l_cnt_remain = 1
         WHILE l_cnt = 0
          #看看在臨時料件表中還有沒有沒展完的料件
          SELECT COUNT(*) INTO l_cnt_remain FROM tmp_ima
 
          #如果有則說明要解鎖
          IF l_cnt_remain > 0 THEN
             #如果是第一次遇到
             IF l_unlock_time = 0 THEN
 
                #-----FOR DEBUG----------------------------
                INSERT INTO debug_child SELECT 99,parent,child,origin FROM tmp_child WHERE origin <> 'BMB'
                #------------------------------------------ 
 
                #從當前關系中刪除非BOM的關系，這樣做的結果是排除所有因工單產生的循環，另外，如果某個循環
                #純粹只由工單產生的關系組成，那么循環中的所有料都會被置同階
                DELETE FROM tmp_child WHERE origin <> 'BMB'
                LET l_cnt2 = SQLCA.SQLERRD[3]
                LET infor = infor,'\n',cl_getmsg('abm-055',g_lang),l_cnt2,cl_getmsg('abm-059',g_lang)
 
                #剔除關系后重新找一次有單頭無單身的料，如果能找到，則接下去走，如果仍然找不到，則說明在BOM本身存在環
                #如果那樣的話就只能強制破環了
                INSERT INTO sub_ima SELECT t_ima01 AS s_ima01 FROM tmp_ima
                  WHERE NOT EXISTS ( SELECT 1 FROM tmp_child WHERE child = t_ima01 )
                
                #如果此時sub_ima中能有資料，則退出當前解鎖循環，先按原有的展階邏輯繼續下去
                SELECT COUNT(*) INTO l_cnt FROM sub_ima
                IF l_cnt > 0 THEN 
                   EXIT WHILE 
                END IF
                
                #-----------------------------------------------------------
                #下面的邏輯是涉及到破環的了
 
                #當第一次解鎖時，記錄當前的最大階數作為解鎖料件的基准階數
                LET l_max_level = l_level      
  
                #要先剔除即不在單頭，也不再單身，即從來沒有創建過BOM及發生過領料的的料件
                #這部分料件的低階碼設為0
              IF p_name = 'abmp603' THEN
                UPDATE ima_file SET ima16 = 0 
                WHERE ima01 IN ( SELECT t_ima01 FROM tmp_ima WHERE
                  NOT EXISTS ( SELECT 1 FROM tmp_child WHERE t_ima01 = parent) AND
                  NOT EXISTS ( SELECT 1 FROM tmp_child WHERE t_ima01 = child))
              ELSE 
               IF p_name = 'abmp604' THEN
                UPDATE ima_file SET ima80 = 0 
                WHERE ima01 IN ( SELECT t_ima01 FROM tmp_ima WHERE
                  NOT EXISTS ( SELECT 1 FROM tmp_child WHERE t_ima01 = parent) AND
                  NOT EXISTS ( SELECT 1 FROM tmp_child WHERE t_ima01 = child))
               END IF
              END IF
                #從料件臨時表中刪除
                DELETE FROM tmp_ima WHERE 
                  NOT EXISTS ( SELECT 1 FROM tmp_child WHERE t_ima01 = parent) AND
                  NOT EXISTS ( SELECT 1 FROM tmp_child WHERE t_ima01 = child)
                LET l_cnt2 = SQLCA.SQLERRD[3]
 
                #再剔除由自身領用（單頭和單身是一筆料）造成的循環
                DELETE FROM tmp_child WHERE parent = child
                LET l_cnt = SQLCA.SQLERRD[3]
 
                #再看看在臨時料件表中還有沒有沒展完的料件
                SELECT COUNT(*) INTO l_cnt_remain FROM tmp_ima
                IF l_cnt_remain = 0 THEN
                   LET l_str ='\n',cl_getmsg('abm-055',g_lang),l_cnt2,cl_getmsg('abm-060',g_lang),l_cnt,cl_getmsg('abm-061',g_lang)
                   CALL p603_log(l_str)
                   LET l_str = ''
                   EXIT WHILE
                ELSE
                   LET infor = infor,'\n',cl_getmsg('abm-055',g_lang),l_cnt2,cl_getmsg('abm-060',g_lang),l_cnt,cl_getmsg('abm-061',g_lang),
                                     cl_getmsg('abm-064',g_lang),l_cnt_remain,cl_getmsg('abm-058',g_lang)
                END IF
 
             ELSE 
                LET infor = infor,'\n',cl_getmsg('abm-064',g_lang),l_cnt_remain,cl_getmsg('abm-058',g_lang)
             END IF
 
             LET l_unlock_time = l_unlock_time + 1
 
             #一次只摘一組父子關系
             SELECT parent,child INTO l_base_parent,l_base_child FROM tmp_child 
               WHERE rownum = 1
             LET l_str = '\n',cl_getmsg('abm-065',g_lang),l_unlock_time,cl_getmsg('abm-066',g_lang) ,(l_base_parent CLIPPED),
                         cl_getmsg('abm-067',g_lang),(l_base_child),cl_getmsg('abm-068',g_lang)
             CALL p603_log(l_str)
             LET l_str = ''
             LET l_begin = TIME(CURRENT)
 
             #從關系表中刪除這一筆記錄
             DELETE FROM tmp_child WHERE parent = l_base_parent AND child = l_base_child
 
             #重新執行剛剛的INSERT語句
 
             #為防止北斗星類的循環造成低階碼運算錯誤，凡是涉及到解鎖的料件低階碼一律從非循環料件的最大階數起算
             LET l_level = l_max_level     
             #找出有單頭無單身的料件
             INSERT INTO sub_ima SELECT t_ima01 AS s_ima01 FROM tmp_ima
                WHERE NOT EXISTS ( SELECT 1 FROM tmp_child WHERE child = t_ima01 )
             IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
                CALL cl_err('INSERT INTO sub_ima:',SQLCA.sqlcode,1) 
             END IF
 
             SELECT COUNT(*) INTO l_cnt FROM sub_ima
             LET l_str = '\n',cl_getmsg('abm-069',g_lang),l_level,cl_getmsg('abm-054',g_lang),l_cnt,cl_getmsg('abm-058',g_lang)
             CALL p603_log(l_str)
             LET l_str = ''
          ELSE 
             EXIT WHILE
          END IF
       END WHILE
    
       #如果最后tmp_ima中沒有剩余料件，則表示所有料件低階碼已經全部計算完畢
       IF l_cnt_remain = 0 THEN
          EXIT WHILE
       END IF
    
        BEGIN WORK
 
        #更新這些料號的低階碼
      IF p_name = 'abmp603' THEN
        UPDATE ima_file set ima16 = l_level
          WHERE EXISTS ( SELECT 1 FROM sub_ima WHERE ima01 = s_ima01 ) 
        IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
           CALL cl_err('update_ima:',SQLCA.sqlcode,1) 
        END IF
      ELSE 
       IF p_name = 'abmp604' THEN
        UPDATE ima_file set ima80 = l_level
          WHERE EXISTS ( SELECT 1 FROM sub_ima WHERE ima01 = s_ima01 ) 
        IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
           CALL cl_err('update_ima:',SQLCA.sqlcode,1) 
        END IF
       END IF
      END IF
 
        COMMIT WORK
   
        BEGIN WORK
 
        #-----FOR DEBUG------------------------
        INSERT INTO debug_child SELECT l_level,parent,child,origin FROM tmp_child
        INSERT INTO debug_sub SELECT l_level,s_ima01 FROM sub_ima
        INSERT INTO debug_ima SELECT l_level,t_ima01 FROM tmp_ima
        #--------------------------------------  
 
        #把這些料號從基准表中剔除掉，同時從關系表中剔除掉以其為父料件的關系記錄
        DELETE FROM tmp_ima WHERE EXISTS (SELECT 1 FROM sub_ima WHERE s_ima01 = t_ima01)
        DELETE FROM tmp_child WHERE EXISTS ( SELECT 1 FROM sub_ima WHERE s_ima01 = parent )
 
        COMMIT WORK
  
        #清空sub_ima
        IF g_db_type = 'ORA'  THEN
         LET l_sql= "TRUNCATE TABLE sub_ima" 
         PREPARE del_sub_ima FROM l_sql
         EXECUTE del_sub_ima
        END IF
        #低階碼循環累加
        LET l_level=l_level+1 
 
        LET l_str = cl_getmsg('abm-054',g_lang),TIME(CURRENT)-l_begin,'\n',cl_getmsg('abm-070',g_lang),l_level,cl_getmsg('abm-054',g_lang)
        CALL p603_log(l_str)
        LET l_str = ''
        LET l_begin = TIME(CURRENT)
 
     END WHILE
     LET l_str = cl_getmsg('abm-046',g_lang),TIME(CURRENT)-l_begin,'\n',cl_getmsg('abm-071',g_lang)
     CALL p603_log(l_str)
     LET l_str = ''
     LET l_begin = TIME(CURRENT)
     #清空并刪除臨時表，先TRUNCATE再DROP比直接DROP要更快
     IF g_db_type = 'ORA'  THEN
      LET l_sql= "TRUNCATE TABLE sub_ima" 
      PREPARE del_sub_ima1 FROM l_sql
      EXECUTE del_sub_ima1
     END IF
     DROP TABLE sub_ima1
 
     IF g_db_type = 'ORA' THEN
      LET l_sql= "TRUNCATE TABLE tmp_ima" 
      PREPARE del_tmp_ima FROM l_sql
      EXECUTE del_tmp_ima
     END IF
     DROP TABLE tmp_ima
 
     IF g_db_type = 'ORA' THEN
      LET l_sql= "TRUNCATE TABLE tmp_child" 
      PREPARE del_tmp_child FROM l_sql
      EXECUTE del_tmp_child
     END IF
     DROP TABLE tmp_child
  
     LET l_str = cl_getmsg('abm-046',g_lang),TIME(CURRENT) - l_begin,'\n',cl_getmsg('abm-072',g_lang),TIME(CURRENT) - l_tot_begin
     CALL p603_log(l_str)
     LET l_str =''
 
     IF g_bgjob <> 'Y' THEN
        CALL cl_err('','abm-073',1)
     END IF   
 
END FUNCTION
 
