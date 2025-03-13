# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cxcp800.4gl
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
   DECLARE p800_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW p800_w WITH FORM "cxc/42f/cxcp800"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊

   LET g_action_choice = ""
   CALL p800_curs()
   
   CLOSE WINDOW p800_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN

FUNCTION p800_curs()
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
       CLOSE WINDOW p800_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
    ELSE
       CALL p800_pro()
       IF cl_confirm('cxc-007') THEN
          CLOSE WINDOW p800_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
       ELSE
          CALL p800_curs()
       END IF
    END IF
END FUNCTION 

FUNCTION p800_pro()
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
  CALL p800_pre() #期别计算

  BEGIN WORK 
  CALL p800_del() #删除已存在的记录

  CALL p800_p()   #BOM计算

  IF g_success = 'Y' THEN
     CALL cl_end2(1) RETURNING l_flag
     COMMIT WORK
  ELSE 
     CALL cl_end2(2) RETURNING l_flag
     ROLLBACK WORK
  END IF 
END FUNCTION
#期别资料设置
FUNCTION p800_pre()  
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

FUNCTION p800_del()

  
END FUNCTION

FUNCTION p800_p()
  
  CALL p800_p_1()   #ex_bom_result
  CALL p800_p_2()   #ex_bom_CP;
  CALL p800_p_3()   #EX_BOM_GS;

END FUNCTION

FUNCTION p800_p_1()  #
  DEFINE l_n    LIKE type_file.num10
  DEFINE i      LIKE type_file.num10

  DELETE FROM ex_bom_result
  DELETE FROM ex_bom_2
  DELETE FROM ex_bom_3

  INSERT INTO ex_bom_result
  SELECT DISTINCT 0,BMA01,'00' bmb02,bma01,bma01,bma05 bmb04,'' bmb05,1 bmb06,1 bmb07 FROM bma_file
   WHERE substr(BMA01,7,1) IN('A','F','R','G') AND INSTR(BMA01,'-')=0
     AND bmaacti='Y' AND BMA10='2'

  INSERT INTO ex_bom_3
  SELECT DISTINCT  0,BMA01,'00' bmb02,BMA01,BMA01,bma05 bmb04,'' bmb05,1 bmb06,1 bmb07 FROM bma_file
   WHERE substr(BMA01,7,1) IN('A','F','R','G') AND INSTR(BMA01,'-')=0
     AND bmaacti='Y' AND BMA10='2'

  FOR i = 1 TO 30

    DELETE FROM ex_bom_2
    LET g_sql = " INSERT INTO ex_bom_2 ",
                " SELECT ",i,",cplh,xh,bmb01,bmb03,bmb04,bmb05,bmb06,ljyl FROM ",
                "       (SELECT cplh,xh||bmb02 xh,bmb01,bmb03, ",
                "               CASE WHEN bmb04 IS NULL THEN bma05 ELSE bmb04 END bmb04, ",
                "               bmb05,bmb06/bmb07 bmb06,BMB10_FAC*ljyl*bmb06/bmb07 ljyl,rank() over(partition by bmb01,bmb03 order by CASE WHEN bmb04 IS NULL THEN bma05 ELSE bmb04 END desc,bmb05 desc) rank ",   
                "          FROM ex_bom_3,bmb_file,BMA_FILE ",
                "         WHERE yjlh=bmb01 AND bmb01=bma01 AND bmAacti='Y' AND BMA10='2') ",
                "  WHERE rank=1 "
    PREPARE p800_p1 FROM g_sql
    EXECUTE p800_p1

    LET g_sql = " INSERT INTO ex_bom_result ",
                " SELECT ",i,",cplh,xh,bmb01,bmb03,bmb04,bmb05,bmb06,ljyl FROM ",
                "        (SELECT cplh,xh||bmb02 xh,bmb01,bmb03,CASE WHEN bmb04 IS NULL THEN bma05 ELSE bmb04 END bmb04, ",
                "                bmb05,bmb06/bmb07 bmb06,BMB10_FAC*ljyl*bmb06/bmb07 ljyl,rank() over(partition by bmb01,bmb03 order by CASE WHEN bmb04 IS NULL THEN bma05 ELSE bmb04 END desc,bmb05 desc) rank ",   
                "           FROM ex_bom_3,bmb_file,BMA_FILE ",
                "          WHERE yjlh=bmb01 AND bmb01=bma01 AND bmAacti='Y' AND BMA10='2') ",
                "  WHERE rank=1 "
    PREPARE p800_p2 FROM g_sql
    EXECUTE p800_p2
    
    DELETE FROM ex_bom_3

    INSERT INTO ex_bom_3
    SELECT DISTINCT * FROM ex_bom_2
     WHERE yjlh IN (SELECT bmb01 FROM bmb_file,bma_file WHERE bmb01=bma01 AND bmaacti='Y' AND BMA10='2')

    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM ex_bom_3
    IF l_n>0 THEN
       CONTINUE FOR
    ELSE 
       EXIT FOR
    END IF
 END FOR 
END FUNCTION

FUNCTION p800_p_2()  #
  DEFINE l_n    LIKE type_file.num10
  DEFINE i      LIKE type_file.num10

  DELETE FROM ex_bom_cp
  DELETE FROM ex_bom_2
  DELETE FROM ex_bom_3

  INSERT INTO ex_bom_cp
  SELECT DISTINCT 0,BMA01,'00' bmb02,BMA01,BMA01,bma05 bmb04,'' bmb05,1 bmb06,1 bmb07 FROM bma_file
   WHERE bmaacti='Y' AND BMA10='2';

  INSERT INTO ex_bom_3
  SELECT DISTINCT 0,BMA01,'00' bmb02,BMA01,BMA01,bma05 bmb04,'' bmb05,1 bmb06,1 bmb07 FROM bma_file
   WHERE bmaacti='Y' AND BMA10='2';

  FOR i = 1 TO 30
  
    DELETE FROM ex_bom_2
    INSERT INTO ex_bom_2
    SELECT DISTINCT i,cplh,xh||bmb02,bmb01,bmb03,CASE WHEN bmb04 IS NULL THEN bma05 ELSE bmb04 END bmb04,
           bmb05,bmb06/bmb07,BMB10_FAC*ljyl*bmb06/bmb07
      FROM ex_bom_3,bmb_file,BMA_FILE
     WHERE yjlh=bmb01 AND bmb01=bma01 AND bmAacti='Y' AND BMA10='2'

    INSERT INTO ex_bom_cp
    SELECT DISTINCT i,cplh,xh||bmb02,bmb01,bmb03,CASE WHEN bmb04 IS NULL THEN bma05 ELSE bmb04 END bmb04,bmb05,bmb06/bmb07,BMB10_FAC*ljyl*bmb06/bmb07
      FROM ex_bom_3,bmb_file,BMA_FILE
     WHERE yjlh=bmb01 AND bmb01=bma01 AND bmAacti='Y' AND BMA10='2'
  
    DELETE FROM ex_bom_3
    INSERT INTO ex_bom_3
    SELECT DISTINCT * FROM ex_bom_2
     WHERE yjlh IN (SELECT bmb01 FROM bmb_file,bma_file WHERE bmb01=bma01 AND bmAacti='Y' AND BMA10='2' )

    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM ex_bom_3
    IF l_n > 0 THEN
       CONTINUE FOR
    ELSE 
       EXIT FOR
    END IF
  END FOR 
END FUNCTION

FUNCTION p800_p_3()  #
  DEFINE l_n    LIKE type_file.num10
  DEFINE i      LIKE type_file.num10

  DELETE FROM ex_bom_gs
  DELETE FROM ex_bom_2
  DELETE FROM ex_bom_3

  INSERT INTO ex_bom_gs
  SELECT DISTINCT 0,BMA01,'00' bmb02,BMA01,BMA01,bma05 bmb04,'' bmb05,1 bmb06,1 bmb07 FROM bma_file
   WHERE substr(BMA01,7,1) IN ('A','F','R','G') AND INSTR(BMA01,'-')=0
     AND bmaacti='Y' AND BMA10='2'

  INSERT INTO ex_bom_3
  SELECT DISTINCT  0,BMA01,'00' bmb02,BMA01,BMA01,bma05 bmb04,'' bmb05,1 bmb06,1 bmb07 FROM bma_file
   WHERE substr(BMA01,7,1) IN ('A','F','R','G') AND INSTR(BMA01,'-')=0
     AND bmaacti='Y' AND BMA10='2'

  FOR i = 1 TO 30
  
    DELETE FROM ex_bom_2
    LET g_sql = "INSERT INTO ex_bom_2 ",
                "SELECT ",i,",cplh,xh,bmb01,bmb03,bmb04,bmb05,bmb06,ljyl FROM ",
                "       (SELECT cplh,xh||bmb02 xh,bmb01,bmb03,CASE WHEN bmb04 IS NULL THEN bma05 ELSE bmb04 END bmb04, ",
                "               bmb05,bmb06/bmb07 bmb06,BMB10_FAC*ljyl*bmb06/bmb07 ljyl,rank() over(partition by bmb01,bmb03 order by CASE WHEN bmb04 IS NULL THEN bma05 ELSE bmb04 END desc,bmb05 desc) rank ",
                "          FROM ex_bom_3,bmb_file,BMA_FILE ",
                "         WHERE yjlh=bmb01 AND bmb01=bma01 AND bmAacti='Y' AND BMA10='2' AND (instr(bmb03,'-')>0 OR instr(bmb03,'.')>0)) ",
                " WHERE rank=1 "
    PREPARE p800_p3 FROM g_sql
    EXECUTE p800_p3

    LET g_sql = " INSERT INTO ex_bom_gs ",
                " SELECT ",i,",cplh,xh,bmb01,bmb03,bmb04,bmb05,bmb06,ljyl FROM ",
                "        (SELECT cplh,xh||bmb02 xh,bmb01,bmb03,CASE WHEN bmb04 IS NULL THEN bma05 ELSE bmb04 END bmb04, ",
                "                bmb05,bmb06/bmb07 bmb06,BMB10_FAC*ljyl*bmb06/bmb07 ljyl,rank() over(partition by bmb01,bmb03 order by CASE WHEN bmb04 IS NULL THEN bma05 ELSE bmb04 END desc,bmb05 desc) rank ",
                "           FROM ex_bom_3,bmb_file,BMA_FILE ",
                "          WHERE yjlh=bmb01 AND bmb01=bma01 AND bmAacti='Y' AND BMA10='2') ",
                "  WHERE rank=1 "
    PREPARE p800_p4 FROM g_sql
    EXECUTE p800_p4
    
    DELETE FROM ex_bom_3

    INSERT INTO ex_bom_3
    SELECT DISTINCT * FROM ex_bom_2
     WHERE yjlh IN (SELECT bmb01 FROM bmb_file,bma_file WHERE bmb01=bma01 AND bmAacti='Y' AND BMA10='2') AND instr(yjlh,'-')>0

    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM ex_bom_3
    IF l_n>0 THEN
       CONTINUE FOR
    ELSE 
       EXIT FOR 
    END IF
  END FOR 
END FUNCTION