# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cxcp810.4gl
# Descriptions...: 客制成本推算过程
# Date & Author..: 17/03/20 By donghy


DATABASE ds                         #建立與資料庫的連線
 
GLOBALS "../../../tiptop/config/top.global"              #存放的為TIPTOP GP系統整體全域變數定義

DEFINE g_tc_ccc              RECORD LIKE tc_ccc_file.*
DEFINE g_azb_t               RECORD LIKE azb_file.*      #備份舊值
DEFINE g_azb01_t             LIKE azb_file.azb01         #Key值備份
DEFINE g_wc                  STRING                      #儲存 user 的查詢條件  #No.FUN-580092 HCN        #No.FUN-680102
DEFINE g_sql                 STRING                      #組 sql 用 
DEFINE g_forupd_sql          STRING                      #SELECT ... FOR UPDATE  SQL    
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令 
DEFINE g_chr                 LIKE azb_file.azbacti
DEFINE g_cnt                 LIKE type_file.num10       
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose 
DEFINE g_msg                 STRING
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10        #總筆數     
DEFINE g_jump                LIKE type_file.num10        #查詢指定的筆數 
DEFINE g_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗
DEFINE b_date                DATE
DEFINE e_date                DATE
DEFINE g_all                 SMALLINT
DEFINE g_ima01               LIKE ima_file.ima01
DEFINE tm                    RECORD
       yy                    LIKE type_file.num5,
       mm                    LIKE type_file.num5
       END RECORD
DEFINE e_yy,e_mm             LIKE type_file.num5
       
MAIN
    OPTIONS
        INPUT NO WRAP                          #輸入的方式: 不打轉
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN                     #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                             #切換成使用者預設的營運中心
   END IF

   WHENEVER ERROR CALL cl_err_msg_log          #遇錯則記錄log檔
 
   IF (NOT cl_setup("CXC")) THEN               #預設模組參數(g_aza.*,...)、權限參數
      EXIT PROGRAM                             #判斷使用者程式執行權限
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #程式進入時間
   INITIALIZE tm.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM tc_ccp_file WHERE ta_ccc02 = ? AND ta_ccc03 = ? FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE p810_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW p810_w WITH FORM "cxc/42f/cxcp810"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊

   LET g_action_choice = ""
   CALL p810_curs()
   
   CLOSE WINDOW p810_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN

FUNCTION p810_curs()
    CLEAR FORM
    INITIALIZE tm.* TO NULL   
    SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00 = '0'
    LET tm.yy = g_ccz.ccz01
    LET tm.mm = g_ccz.ccz02
    INPUT BY NAME tm.yy,tm.mm WITHOUT DEFAULTS         #螢幕上取條件
       BEFORE INPUT                                    #預設查詢條件
           CALL cl_qbe_init()                          #讀回使用者存檔的預設條件 

       AFTER FIELD yy 
         IF tm.yy < 2017 THEN
            CALL cl_err('无法计算2017年之前资料,请重新输入','!',1)
            NEXT FIELD yy
         END IF 
         
        ON ACTION controlp

        AFTER INPUT
          IF cl_null(tm.yy) OR cl_null(tm.mm) THEN
             CALL cl_err('','cxc-008',0)
             CONTINUE INPUT      
          END IF
 
      ON IDLE g_idle_seconds                                #Idle控管（每一交談指令皆要加入）
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about                                       #程式資訊（每一交談指令皆要加入）
         CALL cl_about()  

      ON ACTION generate_link
         CALL cl_generate_shortcut()
 
      ON ACTION help                                        #程式說明（每一交談指令皆要加入）
         CALL cl_show_help()  
 
      ON ACTION controlg                                    #開啟其他作業（每一交談指令皆要加入）
         CALL cl_cmdask()  
 
      ON ACTION qbe_select                                  #選擇儲存的查詢條件
         CALL cl_qbe_select()

      ON ACTION qbe_save                                    #儲存畫面上欄位條件
         CALL cl_qbe_save()
         
      ON ACTION EXIT
         LET INT_FLAG = 1
         EXIT INPUT
      ON ACTION CANCEL
         LET INT_FLAG = 1
         EXIT INPUT
    END INPUT
    
    IF INT_FLAG THEN
       CLOSE WINDOW p810_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
    ELSE
       CALL p810_pro()
       IF cl_confirm('cxc-007') THEN
          CLOSE WINDOW p810_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
       ELSE
          CALL p810_curs()
       END IF
    END IF
END FUNCTION 

FUNCTION p810_pro()
  DEFINE l_cnt       LIKE type_file.num10
  DEFINE l_flag              LIKE type_file.chr1
  
  IF cl_null(tm.yy) OR cl_null(tm.mm) THEN RETURN END IF
  
  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM tc_ccp_file 
   WHERE ta_ccc02 = tm.yy AND ta_ccc03 = tm.mm
  IF l_cnt > 0 THEN
     IF NOT cl_confirm('cxc-009') THEN
        RETURN
     END IF 
  END IF 

  LET g_success = 'Y'
  CALL p810_pre() #期别计算

  BEGIN WORK 
  CALL p810_del() #删除已存在的记录

  CALL p810_p()   #BOM计算

  IF g_success = 'Y' THEN
     CALL cl_end2(1) RETURNING l_flag
     COMMIT WORK
  ELSE 
     CALL cl_end2(2) RETURNING l_flag
     ROLLBACK WORK
  END IF 
END FUNCTION
#期别资料设置
FUNCTION p810_pre()  
  DEFINE l_c   CHAR(1)
  
  IF tm.mm = '1' THEN 
     LET e_mm = '12'
     LET e_yy = tm.yy - 1
  ELSE
     LET e_yy = tm.yy
     LET e_mm = tm.mm - 1
  END IF
   CALL s_azm(tm.yy,tm.mm)                     #得出期間的起始日與截止日
        RETURNING l_c,b_date,e_date
END FUNCTION

FUNCTION p810_del()

  
END FUNCTION

FUNCTION p810_p()
  
  CALL p810_p_1()   #ex_imk

END FUNCTION

FUNCTION p810_p_1()  #ex_imk
  DEFINE l_n    LIKE type_file.num10
  DEFINE i      LIKE type_file.num10
  DEFINE l_date LIKE type_file.dat

  DELETE FROM ex_imk_file WHERE ex_imk05=tm.yy AND ex_imk06=tm.mm
  DELETE FROM ex_imk_2;
  DELETE FROM ex_imk_3;
  DELETE FROM ex_imk_4;
  DELETE FROM ex_imk_5;

  LET l_date = TODAY + 1
  #A产品使用材料
  INSERT INTO ex_imk_file
  SELECT IMK01,IMK01,IMK01,IMK01,tm.yy,tm.mm,
         SUM(IMK09) imk09
    FROM imk_file 
   WHERE EXISTS( SELECT TC_JCF02 FROM TC_JCF_FILE WHERE TC_JCFACTI='Y' AND IMK02=TC_JCF02) 
     AND IMK05=tm.yy AND IMK06=tm.mm AND INSTR(IMK01,'-')=0 AND IMK02 NOT IN (SELECT jce02 FROM jce_file) 
     AND imk09<>0
   GROUP BY IMK01
   
  INSERT INTO ex_imk_file
  SELECT cch04,cch04,cch04,cch04,tm.yy,tm.mm,sum(cch91) cch91 FROM cch_file,sfb_file
   WHERE cch02=tm.yy AND cch03=tm.mm AND sfb01=cch01
     AND ((sfb38 IS NULL AND l_date > e_date) OR (sfb38 IS NOT NULL AND sfb38 > e_date))
     AND INSTR(cch04,'-')=0  GROUP BY cch04

  LET g_sql = 
  "INSERT INTO ex_imk_3 ",
  "SELECT imk01,' ',' ',' ',sum(IMK09) imk09 ", 
  "  FROM (SELECT imk01,imk09 FROM IMK_file ",
  "         WHERE IMK05=",tm.yy," AND IMK06=",tm.mm," AND INSTR(IMK01,'-')<>0 ", 
  "           AND IMK02 NOT IN (SELECT jce02 FROM jce_file) ", 
  "           AND imk09<>0 ", 
  "           AND EXISTS(SELECT TC_JCF02 FROM TC_JCF_FILE WHERE TC_JCFACTI='Y' AND IMK02=TC_JCF02) ",
  "        UNION ALL ", 
  "        SELECT cch04 imk01,cch91 imk09 FROM cch_file,sfb_file ",
  "         WHERE cch02=",tm.yy," AND cch03=",tm.mm," AND sfb01=cch01 ", 
  "           AND ((sfb38 IS NULL AND '",l_date,"' > '",e_date,"') OR (sfb38 IS NOT NULL AND sfb38 > '",e_date,"')) ",
  "           AND INSTR(cch04,'-')<>0 AND cch91<>0) ",
  " GROUP BY imk01 "
  PREPARE p810_p1 FROM g_sql
  EXECUTE p810_p1
  
  INSERT INTO ex_imk_4
  SELECT ccg01,ccg04,-ccg31,ccg02,ccg03 FROM ccg_file,sfb_file
   WHERE instr(ccg04,'-')>0 
     AND to_date(ccg02||ccg03,'yyyyMM')<=to_date(tm.yy||tm.mm,'yyyyMM')
     AND ccg01=sfb01 AND sfb02 IN('1','7')

  INSERT INTO ex_imk_file
  SELECT yjlh,' ',' ',ex_imk01,tm.yy,tm.mm,ex_imk09*ljyl FROM ex_imk_3,ex_bom_cp
   WHERE ex_imk01 NOT IN (SELECT ex_imk04 FROM ex_imk_4)
     AND ex_imk01=cplh AND INSTR(yjlh,'.')>0
     AND to_char(sxrq1,'yyyyMM')<=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')  
     AND ((sxrq2 IS NULL) OR (sxrq2 IS NOT NULL AND sxrq2 >= b_date))
    
  DELETE FROM ex_imk_3 WHERE ex_imk01 NOT IN (SELECT ex_imk04 FROM ex_imk_4)

  FOR i = 1 TO 20
  #问题
    DELETE FROM ex_imk_2
    LET g_sql = 
    "INSERT INTO ex_imk_2 ",
    "SELECT ex_imk01,' ',' ',ex_imk04,ex_imk09,ex_imkkc,ex_imk02,ex_imk03 ",
    "  FROM (SELECT ex_imk_4.ex_imk01,ex_imk_4.ex_imk04,ex_imk_4.ex_imk09,ex_imk_3.ex_imk09 ex_imkkc,ex_imk_4.ex_imk02,ex_imk_4.ex_imk03, ",
    "               row_number()over(partition by ex_imk_4.ex_imk04 order BY to_date(ex_imk_4.ex_imk02||ex_imk_4.ex_imk03,'yyyyMM') DESC,ex_imk_4.ex_imk01 DESC) mm ", 
    "          from ex_imk_4,ex_imk_3 ",
    "         WHERE ex_imk_4.ex_imk04=ex_imk_3.ex_imk01) ", 
    " WHERE mm=1 "
    PREPARE p810_p2 FROM g_sql
    EXECUTE p810_p2

    INSERT INTO ex_imk_file
    SELECT cch04,ex_imk01,' ',ex_imk04,tm.yy,tm.mm,
           CASE WHEN ex_imk09<=ex_imk091 THEN -cch31 ELSE -cch31*ex_imk091/ex_imk09 END AS cch31
      FROM ex_imk_2,cch_file 
     WHERE ex_imk05=cch02 AND ex_imk06=cch03 AND ex_imk01=cch01
       AND instr(cch04,'.') > 0
    
    DELETE FROM ex_imk_4
     WHERE EXISTS(SELECT 'a' FROM ex_imk_2
                   WHERE ex_imk_4.ex_imk01=ex_imk_2.ex_imk01
                     AND ex_imk_4.ex_imk02=ex_imk_2.ex_imk05 AND ex_imk_4.ex_imk03=ex_imk_2.ex_imk06)
    
    INSERT INTO ex_imk_4
    SELECT ex_imk01,ex_imk04,ex_imk09-ex_imk091,ex_imk05,ex_imk06 FROM ex_imk_2
     WHERE ex_imk09>ex_imk091
    
    DELETE FROM ex_imk_3 WHERE EXISTS (SELECT 'a' FROM ex_imk_2 WHERE ex_imk_3.ex_imk01=ex_imk_2.ex_imk04)
    
    INSERT INTO ex_imk_3
    SELECT ex_imk04,' ',' ',' ',ex_imk091-ex_imk09
      FROM ex_imk_2 WHERE ex_imk09<ex_imk091

    INSERT INTO ex_imk_3
    SELECT cch04,' ',' ',' ',
           CASE WHEN ex_imk09<=ex_imk091 THEN -cch31 ELSE -cch31*ex_imk091/ex_imk09 END AS cch31
      FROM ex_imk_2,cch_file
     WHERE ex_imk05=cch02 AND ex_imk06=cch03 AND ex_imk01=cch01
       AND instr(cch04,'-')>0

    INSERT INTO ex_imk_file
    SELECT yjlh,' ',' ',ex_imk01,tm.yy,tm.mm,ex_imk09*ljyl FROM ex_imk_3,ex_bom_cp
     WHERE ex_imk01 NOT IN (SELECT ex_imk04 FROM ex_imk_4)
       AND ex_imk01=cplh AND INSTR(yjlh,'.')>0
       AND to_char(sxrq1,'yyyyMM')<=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')  
       AND nvl(to_char(sxrq2,'yyyyMM'),TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM'))>=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
     
    INSERT INTO ex_imk_5
    SELECT * FROM ex_imk_3 WHERE ex_imk01 NOT IN(SELECT ex_imk04 FROM ex_imk_4)
    
    DELETE FROM ex_imk_3 WHERE ex_imk01 NOT IN(SELECT ex_imk04 FROM ex_imk_4)
    
    DELETE FROM ex_imk_2

    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM ex_imk_3;
    IF l_n>0 THEN
       CONTINUE FOR
    ELSE 
       EXIT FOR
    END IF
 END FOR 
END FUNCTION