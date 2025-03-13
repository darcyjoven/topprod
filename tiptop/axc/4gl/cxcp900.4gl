# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cxcp900.4gl
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
       mm                    LIKE type_file.num5,
       imk                   LIKE type_file.chr1,
       bom                   LIKE type_file.chr1
       END RECORD
DEFINE e_yy,e_mm             LIKE type_file.num5
DEFINE g_p1                  LIKE type_file.num5
DEFINE g_p2                  STRING
       
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
   DECLARE p900_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW p900_w WITH FORM "cxc/42f/cxcp900"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊

   LET g_action_choice = ""
   CALL p900_curs()
   
   CLOSE WINDOW p900_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN

FUNCTION p900_curs()
    CLEAR FORM
    INITIALIZE tm.* TO NULL   
    SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00 = '0'
    LET tm.yy = g_ccz.ccz01
    LET tm.mm = g_ccz.ccz02
    LET tm.imk = 'N'
    LET tm.bom = 'N'
    INPUT BY NAME tm.yy,tm.mm,tm.imk,tm.bom WITHOUT DEFAULTS         #螢幕上取條件
       BEFORE INPUT                                    #預設查詢條件
           CALL cl_qbe_init()                          #讀回使用者存檔的預設條件 

       AFTER FIELD yy 
         IF tm.yy < 2017 THEN
            CALL cl_err('无法计算2017年之前资料,请重新输入','!',1)
            NEXT FIELD yy
         END IF 

       ON CHANGE imk
         IF tm.imk = 'Y' THEN
            
         ELSE
         
         END IF 

       ON CHANGE bom
         IF tm.bom = 'Y' THEN
            CALL cl_set_comp_entry("imk",FALSE)
            LET tm.imk = 'Y'
            DISPLAY BY NAME tm.imk
         ELSE
            CALL cl_set_comp_entry("imk",TRUE)
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
 
      ON ACTION HELP                                        #程式說明（每一交談指令皆要加入）
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
       CLOSE WINDOW p900_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
    ELSE
       CALL p900_pro()
       IF cl_confirm('cxc-007') THEN
          CLOSE WINDOW p900_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
       ELSE
          CALL p900_curs()
       END IF
    END IF
END FUNCTION 

FUNCTION p900_pro()
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
  CALL p900_pre() #期别计算

  BEGIN WORK 
  CALL p900_del() #删除已存在的记录

  CALL p900_p0()   #前置处理

  CALL p900_p()   #成本计算

  IF g_success = 'Y' THEN
     COMMIT WORK
     CALL cl_end2(1) RETURNING l_flag
  ELSE 
     ROLLBACK WORK
     CALL cl_end2(2) RETURNING l_flag
  END IF 
END FUNCTION
#期别资料设置
FUNCTION p900_pre()  
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

FUNCTION p900_del()

  DELETE FROM ta_ccp_file WHERE ta_ccc02 = tm.yy AND ta_ccc03 = tm.mm
  
END FUNCTION

FUNCTION p900_p0()
  DEFINE l_cnt     LIKE type_file.num10
  
  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM ex_bom_cp WHERE yy = tm.yy AND mm = tm.mm
  IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
  
  IF tm.bom = 'Y' OR l_cnt = 0 THEN 
     CALL p900_p0_1()   #BOM处理
  END IF 

  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM ex_imk_file WHERE ex_imk05=tm.yy AND ex_imk06=tm.mm
  IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
  
  IF tm.imk = 'Y' OR l_cnt = 0 THEN
     CALL p900_p0_2()   #期库存处理
  END IF 
  CALL p900_p0_3()   #工单用量处理

END FUNCTION

FUNCTION p900_p0_1() #BOM处理

  CALL p800_p_1()   #ex_bom_result
  CALL p800_p_2()   #ex_bom_CP;
  CALL p800_p_3()   #EX_BOM_GS;

END FUNCTION

FUNCTION p800_p_1()  #ex_bom_result
  DEFINE l_n    LIKE type_file.num10
  DEFINE i      LIKE type_file.num10

  IF g_bgjob = 'N' THEN
     LET g_p1 = g_p1 + 1
     LET g_p2 = "BOM处理 - ex_bom_result"
     DISPLAY g_p1,g_p2 TO p1,p2
     CALL ui.Interface.refresh()
  END IF
  DELETE FROM ex_bom_result WHERE yy = tm.yy AND mm = tm.mm
  DELETE FROM ex_bom_2
  DELETE FROM ex_bom_3

  INSERT INTO ex_bom_result
  SELECT DISTINCT 0,BMA01,'00' bmb02,bma01,bma01,bma05 bmb04,'' bmb05,1 bmb06,1 bmb07,tm.yy,tm.mm
    FROM bma_file
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
                " SELECT ",i,",cplh,xh,bmb01,bmb03,bmb04,bmb05,bmb06,ljyl,",tm.yy,",",tm.mm," FROM ",
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

FUNCTION p800_p_2()  #ex_bom_CP
  DEFINE l_n    LIKE type_file.num10
  DEFINE i      LIKE type_file.num10

  IF g_bgjob = 'N' THEN
     LET g_p1 = g_p1 + 1
     LET g_p2 = "BOM处理 - ex_bom_CP"
     DISPLAY g_p1,g_p2 TO p1,p2
     CALL ui.Interface.refresh()
  END IF  
  DELETE FROM ex_bom_cp WHERE yy = tm.yy AND mm = tm.mm
  DELETE FROM ex_bom_2
  DELETE FROM ex_bom_3

  INSERT INTO ex_bom_cp
  SELECT DISTINCT 0,BMA01,'00' bmb02,BMA01,BMA01,bma05 bmb04,'' bmb05,1 bmb06,1 bmb07,tm.yy,tm.mm
    FROM bma_file
   WHERE bmaacti='Y' AND BMA10='2'
#170805 luoyb str
     AND bma05 <= e_date
#    AND to_char(bma05,'yyyyMM')<=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
#170805 luoyb end

  INSERT INTO ex_bom_3
  SELECT DISTINCT 0,BMA01,'00' bmb02,BMA01,BMA01,bma05 bmb04,'' bmb05,1 bmb06,1 bmb07
    FROM bma_file
   WHERE bmaacti='Y' AND BMA10='2'
#170805 luoyb str
     AND bma05 <= e_date
#    AND to_char(bma05,'yyyyMM')<=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
#170805 luoyb end

  FOR i = 1 TO 30
  
    DELETE FROM ex_bom_2
    INSERT INTO ex_bom_2
    SELECT DISTINCT i,cplh,xh||bmb02,bmb01,bmb03,CASE WHEN bmb04 IS NULL THEN bma05 ELSE bmb04 END bmb04,
           bmb05,bmb06/bmb07,BMB10_FAC*ljyl*bmb06/bmb07
      FROM ex_bom_3,bmb_file,BMA_FILE
     WHERE yjlh=bmb01 AND bmb01=bma01 AND bmAacti='Y' AND BMA10='2'
#170805 luoyb str
       AND bmb04 <= e_date
       AND (bmb05 IS NULL OR bmb05 > e_date)
#       AND to_char(bmb04,'yyyyMM')<=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
#       AND (bmb05 IS NULL OR (to_char(bmb05,'yyyyMM') >= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')))
#170805 luoyb end

    INSERT INTO ex_bom_cp
    SELECT DISTINCT i,cplh,xh||bmb02,bmb01,bmb03,CASE WHEN bmb04 IS NULL THEN bma05 ELSE bmb04 END bmb04,bmb05,bmb06/bmb07,BMB10_FAC*ljyl*bmb06/bmb07
          ,tm.yy,tm.mm
      FROM ex_bom_3,bmb_file,BMA_FILE
     WHERE yjlh=bmb01 AND bmb01=bma01 AND bmAacti='Y' AND BMA10='2'
#170805 luoyb str
       AND bmb04 <= e_date
       AND (bmb05 IS NULL OR bmb05 > e_date)
#      AND to_char(bmb04,'yyyyMM')<=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
#      AND (bmb05 IS NULL OR (to_char(bmb05,'yyyyMM') >= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')))
#170805 luoyb end
  
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

FUNCTION p800_p_3()  #EX_BOM_GS
  DEFINE l_n    LIKE type_file.num10
  DEFINE i      LIKE type_file.num10

  IF g_bgjob = 'N' THEN
     LET g_p1 = g_p1 + 1
     LET g_p2 = "BOM处理 - EX_BOM_GS"
     DISPLAY g_p1,g_p2 TO p1,p2
     CALL ui.Interface.refresh()
  END IF    
  DELETE FROM ex_bom_gs WHERE yy = tm.yy AND mm = tm.mm
  DELETE FROM ex_bom_2
  DELETE FROM ex_bom_3

  INSERT INTO ex_bom_gs
  SELECT DISTINCT 0,BMA01,'00' bmb02,BMA01,BMA01,bma05 bmb04,'' bmb05,1 bmb06,1 bmb07,tm.yy,tm.mm
    FROM bma_file
   WHERE substr(BMA01,7,1) IN ('A','F','R','G') AND INSTR(BMA01,'-')=0
     AND bmaacti='Y' AND BMA10='2'

  INSERT INTO ex_bom_3
  SELECT DISTINCT  0,BMA01,'00' bmb02,BMA01,BMA01,bma05 bmb04,'' bmb05,1 bmb06,1 bmb07
    FROM bma_file
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
                " SELECT ",i,",cplh,xh,bmb01,bmb03,bmb04,bmb05,bmb06,ljyl,",tm.yy,",",tm.mm," FROM ",
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

FUNCTION p900_p0_2() #期库存处理

   CALL p810_p_1()   #ex_imk   #先MRK掉

END FUNCTION

FUNCTION p810_p_1()  #ex_imk
  DEFINE l_n    LIKE type_file.num10
  DEFINE i      LIKE type_file.num10
  DEFINE l_date LIKE type_file.dat

  IF g_bgjob = 'N' THEN
     LET g_p1 = g_p1 + 1
     LET g_p2 = "IMK处理 - ex_imk"
     DISPLAY g_p1,g_p2 TO p1,p2
     CALL ui.Interface.refresh()
  END IF    
  DELETE FROM ex_imk_file WHERE ex_imk05=tm.yy AND ex_imk06=tm.mm
  DELETE FROM ex_imk_2;
  DELETE FROM ex_imk_3;
  DELETE FROM ex_imk_4;
  DELETE FROM ex_imk_5;

  LET l_date = TODAY + 1
  #A产品使用材料
  INSERT INTO ex_imk_file
  SELECT IMK01,IMK01,IMK01,IMK01,tm.yy,tm.mm,
         SUM(IMK09) imk09,0,0
    FROM imk_file 
   WHERE EXISTS( SELECT TC_JCF02 FROM TC_JCF_FILE WHERE TC_JCFACTI='Y' AND IMK02=TC_JCF02) 
     AND IMK05=tm.yy AND IMK06=tm.mm AND INSTR(IMK01,'-')=0 AND IMK02 NOT IN (SELECT jce02 FROM jce_file) 
     AND imk09<>0
   GROUP BY IMK01
   
  INSERT INTO ex_imk_file
  SELECT cch04,cch04,cch04,cch04,tm.yy,tm.mm,sum(cch91) cch91,0,0 FROM cch_file,sfb_file
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
#  "           AND EXISTS(SELECT TC_JCF02 FROM TC_JCF_FILE WHERE TC_JCFACTI='Y' AND IMK02=TC_JCF02) ",   #mark by liuyya 170727
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
  SELECT yjlh,' ',' ',ex_imk01,tm.yy,tm.mm,ex_imk09*ljyl,ex_imk09,ljyl FROM ex_imk_3,ex_bom_cp
   WHERE ex_imk01 NOT IN (SELECT ex_imk04 FROM ex_imk_4 WHERE ex_imk02 = tm.yy AND ex_imk03 = tm.mm)
     AND ex_imk01=cplh AND INSTR(yjlh,'.')>0
     AND ex_bom_cp.yy = tm.yy AND ex_bom_cp.mm = tm.mm
     AND to_char(sxrq1,'yyyyMM')<=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
     AND ((sxrq2 IS NULL) OR (sxrq2 IS NOT NULL AND sxrq2 >= b_date))

  DELETE FROM ex_imk_3 WHERE ex_imk01 NOT IN (SELECT ex_imk04 FROM ex_imk_4 WHERE ex_imk02 = tm.yy AND ex_imk03 = tm.mm)

  FOR i = 1 TO 8
  #问题
    DELETE FROM ex_imk_2
    LET g_sql = 
    "INSERT INTO ex_imk_2 ",
    "SELECT ex_imk01,' ',",i,",ex_imk04,ex_imk09,ex_imkkc,ex_imk02,ex_imk03 ",
    "  FROM (SELECT a.ex_imk01,a.ex_imk04,a.ex_imk09,b.ex_imk09 ex_imkkc,a.ex_imk02,a.ex_imk03, ",
    "          row_number()over(partition by a.ex_imk04 order BY to_date(a.ex_imk02||a.ex_imk03,'yyyyMM') DESC,a.ex_imk01||a.ex_imk04 DESC) mm ", 
    "          from ex_imk_4 a,ex_imk_3 b ",
    "         WHERE a.ex_imk04=b.ex_imk01(+) AND NVL(b.ex_imk09,0)<>0) ",
    " WHERE mm=1 "
    PREPARE p810_p2 FROM g_sql
    EXECUTE p810_p2

    LET g_sql = "INSERT INTO ex_imk_file ",
     " SELECT cch04,ex_imk01,' ',ex_imk04,",tm.yy,",",tm.mm,", ",
     "      CASE WHEN ex_imk09<=ex_imk091 THEN -cch31 ELSE -cch31*ex_imk091/ex_imk09 END AS cch31 ",
     "      CASE WHEN ex_imk09<=ex_imk091 THEN -cch31 ELSE -cch31*ex_imk091/ex_imk09 END ",
     "      CASE WHEN ex_imk09<=ex_imk091 THEN 100    ELSE ex_imk091/ex_imk09 END ",
     " FROM ex_imk_2,cch_file ", 
     " WHERE ex_imk05=cch02 AND ex_imk06=cch03 AND ex_imk01=cch01 ",
     "   AND ex_imk091<>0 ",     #add by liuyya 170727
	 "   AND instr(cch04,'.') > 0 "
    PREPARE p810_p2_1 FROM g_sql
    EXECUTE p810_p2_1
    
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
      FROM ex_imk_2 WHERE ex_imk091-ex_imk09>0 

#mark by liuyya `170727  begin
#    INSERT INTO ex_imk_3
#    SELECT cch04,' ',' ',' ',
#           CASE WHEN ex_imk09<=ex_imk091 THEN -cch31 ELSE -cch31*ex_imk091/ex_imk09 END AS cch31
#      FROM ex_imk_2,cch_file
#     WHERE ex_imk05=cch02 AND ex_imk06=cch03 AND ex_imk01=cch01
#       AND instr(cch04,'-')>0
#mark by liuyya 170727  end

    INSERT INTO ex_imk_file
    SELECT yjlh,' ',' ',ex_imk01,tm.yy,tm.mm,ex_imk09*ljyl,ex_imk09,ljyl FROM ex_imk_3,ex_bom_cp
     WHERE ex_imk01 NOT IN (SELECT ex_imk04 FROM ex_imk_4)
       AND ex_imk01=cplh AND INSTR(yjlh,'.')>0
       AND ex_bom_cp.yy = tm.yy AND ex_bom_cp.mm = tm.mm
       AND to_char(sxrq1,'yyyyMM')<=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')  
       AND nvl(to_char(sxrq2,'yyyyMM'),TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM'))>=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
     
##mark by liuyya `170727  begin
#    INSERT INTO ex_imk_5
#    SELECT * FROM ex_imk_3 WHERE ex_imk01 NOT IN(SELECT ex_imk04 FROM ex_imk_4)
#mark by liuyya 170727  end
    
    DELETE FROM ex_imk_3 WHERE ex_imk01 NOT IN(SELECT ex_imk04 FROM ex_imk_4)

##mark by liuyya `170727  begin    
#    DELETE FROM ex_imk_2
#mark by liuyya 170727  end

    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM ex_imk_3;
    IF l_n>0 THEN
       CONTINUE FOR
    ELSE 
       EXIT FOR
    END IF
 END FOR 
END FUNCTION

FUNCTION p900_p0_3() #工单用量处理

  CALL p820_p_1()   #ex_ccgq

END FUNCTION

FUNCTION p820_p_1()  #ex_ccgq
  DEFINE l_n    LIKE type_file.num10
  DEFINE i,k    LIKE type_file.num10
  DEFINE l_date LIKE type_file.dat

  IF g_bgjob = 'N' THEN
     LET g_p1 = g_p1 + 1
     LET g_p2 = "工单用量计算 - ex_ccgq"
     DISPLAY g_p1,g_p2 TO p1,p2
     CALL ui.Interface.refresh()
  END IF    
  
  DELETE FROM ex_ccg_result WHERE yyM=tm.yy AND mmY=tm.mm
  DELETE FROM ex_ccg_2
  DELETE FROM ex_ccg_3
  DELETE FROM ex_ccg_4
  DELETE FROM ta_cca_file
  DELETE FROM ex_ccg_wgd WHERE yyM=tm.yy AND mmY=tm.mm

  #A产品使用材料
  LET g_sql = "
  INSERT INTO ex_ccg_result
  SELECT ",tm.yy,",",tm.mm,",ccg04,sfa27,cch04,cch31,sfa28,sfa16a,'N',bzxh,ccg01,'','f' 
    FROM (SELECT ccg04,sfa27,cch04,cch31,sfa28,(sfa13*CASE WHEN sfa16<=sfa161 THEN sfa16 ELSE sfa161 END) sfa16a,
                 (sfa13*ccg31*CASE WHEN sfa16<=sfa161 THEN sfa16 ELSE sfa161 END) AS bzxh,ccg01
            FROM ccg_file,cch_file,sfa_file,sfb_file 
           WHERE ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 AND SFB02 IN('1','7')
             AND sfa26 in('0','1','2') AND ccg02=",tm.yy," AND ccg03=",tm.mm,"
             AND substr(ccg04,7,1) IN('A') AND ccg01=sfa01 AND cch04=sfa03 AND sfb01=ccg01
             AND ccg04<>cch04 AND INSTR(ccg04,'-')=0 AND INSTR(cch04,'-')=0 AND cch31<>0 AND sfa27=sfa03
             AND cch04<>ccg04) a12
   WHERE bzxh<>0
   UNION ALL
  SELECT ",tm.yy,",",tm.mm,",ccg04,sfa27,cch04,cch31,sfa28,sfa16a,TDF,bzxh,ccg01,'','f' 
    FROM (SELECT ccg01,ccg04,a.sfa27,cch04,cch31,a.sfa28,(b1.sfa13*CASE WHEN b1.sfa16<=b1.sfa161 THEN b1.sfa16 ELSE b1.sfa161 END) sfa16a,
                 CASE WHEN (ccg31*((b1.sfa13*CASE WHEN b1.sfa16<=b1.sfa161 THEN b1.sfa16 ELSE b1.sfa161 END)))>cch31 THEN (ccg31*((b1.sfa13*CASE WHEN b1.sfa16<=b1.sfa161 THEN b1.sfa16 ELSE b1.sfa161 END))) ELSE cch31 END bzxh,
                 CASE WHEN a.sfa26 in('0','1','2') THEN 'N' WHEN a.sfa26 NOT IN('0','1','2') AND A.SFA27=A.SFA03 THEN 'N' ELSE 'Y' END TDF 
            FROM ccg_file,cch_file,sfa_file a,sfb_file,sfa_file b1
           WHERE ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 AND sfb01=ccg01 AND SFB02 IN('1','7')
             AND ccg02=",tm.yy," AND ccg03=",tm.mm," AND a.sfa01=b1.sfa01 AND a.sfa27=b1.sfa27 AND b1.sfa16<>0
             AND a.sfa26 NOT in('0','1','2') AND substr(ccg04,7,1) IN('A') AND ccg01=a.sfa01 AND cch04=a.sfa03
             AND ccg04<>cch04 AND INSTR(ccg04,'-')=0 AND INSTR(cch04,'-')=0 AND cch31<>0
             AND cch04<>ccg04) a12
   WHERE bzxh<>0
   UNION ALL
  SELECT ",tm.yy,",",tm.mm,",ccg04,sfa27,cch04,cch31,sfa28,sfa16a,'N',bzxh,ccg01,'','f' 
    FROM (SELECT ccg04,sfa27,cch04,cch31,sfa28,(sfa13*CASE WHEN sfa16<=sfa161 THEN sfa16 ELSE sfa161 END) sfa16a,
                 (sfa13*ccg31*CASE WHEN sfa16<=sfa161 THEN sfa16 ELSE sfa161 END) AS bzxh,ccg01 FROM ccg_file,cch_file,sfa_file,sfb_file
           WHERE ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 AND sfb01=ccg01 AND SFB02 IN('1','7')
             AND ccg02=",tm.yy," AND ccg03=",tm.mm," AND cch04<>ccg04
             AND substr(ccg04,7,1) IN('F','R','G') AND ccg01=sfa01 AND cch04=sfa03 AND sfa26 in('0','1','2')
             AND ccg04<>cch04 AND INSTR(ccg04,'-')=0 AND INSTR(cch04,'-')=0 AND cch31<>0) a12
   WHERE bzxh<>0
   UNION ALL
  SELECT ",tm.yy,",",tm.mm,",ccg04,sfa27,cch04,cch31,sfa28,sfa16a,TDF,bzxh,ccg01,'','f' 
    FROM (SELECT ccg01,ccg04,a.sfa27,cch04,cch31,a.sfa28,(b1.sfa13*CASE WHEN b1.sfa16<=b1.sfa161 THEN b1.sfa16 ELSE b1.sfa161 END) sfa16a,
                 CASE WHEN (ccg31*((b1.sfa13*CASE WHEN b1.sfa16<=b1.sfa161 THEN b1.sfa16 ELSE b1.sfa161 END)))>cch31 THEN (ccg31*((b1.sfa13*CASE WHEN b1.sfa16<=b1.sfa161 THEN b1.sfa16 ELSE b1.sfa161 END))) ELSE cch31 END bzxh,
                 CASE WHEN a.sfa26 in('0','1','2') THEN 'N' WHEN a.sfa26 NOT IN('0','1','2') AND A.SFA27=A.SFA03 THEN 'N' ELSE 'Y' END TDF 
            FROM ccg_file,cch_file,sfa_file a,sfb_file,sfa_file b1
           WHERE ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 AND sfb01=ccg01 AND SFB02 IN('1','7')
             AND ccg02=",tm.yy," AND ccg03=",tm.mm," AND a.sfa01=b1.sfa01 AND a.sfa27=b1.sfa27 AND b1.sfa16<>0
             AND a.sfa26 NOT in('0','1','2') AND substr(ccg04,7,1) IN('F','R','G') AND ccg01=a.sfa01 AND cch04=a.sfa03
             AND ccg04<>cch04 AND INSTR(ccg04,'-')=0 AND INSTR(cch04,'-')=0 AND cch31<>0
             AND cch04<>ccg04) a12
   WHERE bzxh<>0"
  PREPARE p820_p1 FROM g_sql
  EXECUTE p820_p1

  LET g_sql = 
  "INSERT INTO ex_ccg_3
  SELECT ccg04,sfa27,cch04,CASE WHEN cch31<bzxh THEN bzxh ELSE cch31 END cch31,sfa28,sfa16a,'N',bzxh,ccg01,'' 
    FROM (SELECT ccg04,sfa27,cch04,cch31,sfa28,(sfa13*CASE WHEN sfa16<=sfa161 THEN sfa16 ELSE sfa161 END) sfa16a,
                 (sfa13*ccg31*CASE WHEN sfa16<=sfa161 THEN sfa16 ELSE sfa161 END) AS bzxh,ccg01 FROM ccg_file,cch_file,sfa_file,sfb_file
           WHERE ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 AND sfb01=ccg01 AND SFB02 IN('1','7')
             AND ccg02=",tm.yy," AND ccg03=",tm.mm,"
             AND substr(ccg04,7,1) IN('A') AND ccg01=sfa01 AND cch04=sfa03 AND sfa26 in('0','1','2')
             AND ccg04<>cch04 AND INSTR(ccg04,'-')=0 AND INSTR(cch04,'-')<>0 AND cch31<>0 AND sfa27=sfa03
             AND cch04<>ccg04) a12
   WHERE bzxh<>0
   UNION ALL
  SELECT ccg04,sfa27,cch04,cch31,sfa28,sfa16a,'N',bzxh,ccg01,'' 
    FROM (SELECT ccg04,sfa27,cch04,cch31,sfa28,(sfa13*CASE WHEN sfa16<=sfa161 THEN sfa16 ELSE sfa161 END) sfa16a,
                 (sfa13*ccg31*CASE WHEN sfa16<=sfa161 THEN sfa16 ELSE sfa161 END) AS bzxh,ccg01 
            FROM ccg_file,cch_file,sfa_file,sfb_file
           WHERE ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 AND sfb01=ccg01 AND SFB02 IN('1','7')
             AND ccg02=",tm.yy," AND ccg03=",tm.mm,"
             AND substr(ccg04,7,1) IN('F','R','G') AND ccg01=sfa01 AND cch04=sfa03 AND sfa26 in('0','1','2')
             AND ccg04<>cch04 AND INSTR(ccg04,'-')=0 AND INSTR(cch04,'-')<>0 AND cch31<>0 AND sfa27=sfa03
             AND cch04<>ccg04) a12
   WHERE bzxh<>0
   UNION ALL
  SELECT ccg04,sfa27,cch04,cch31,sfa28,sfa16a,'Y',bzxh,ccg01,'' 
    FROM (SELECT ccg01,ccg04,a.sfa27,cch04,cch31,a.sfa28,(b1.sfa13*CASE WHEN b1.sfa16<=b1.sfa161 THEN b1.sfa16 ELSE b1.sfa161 END) sfa16a,
                 CASE WHEN (ccg31*((b1.sfa13*CASE WHEN b1.sfa16<=b1.sfa161 THEN b1.sfa16 ELSE b1.sfa161 END)))>cch31 THEN (ccg31*((b1.sfa13*CASE WHEN b1.sfa16<=b1.sfa161 THEN b1.sfa16 ELSE b1.sfa161 END))) ELSE cch31 END bzxh,
                 CASE WHEN a.sfa26 in('0','1','2') THEN 'N' WHEN a.sfa26 NOT IN('0','1','2') AND A.SFA27=A.SFA03 THEN 'N' ELSE 'Y' END TDF 
            FROM ccg_file,cch_file,sfa_file a,sfb_file,sfa_file b1
           WHERE ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 AND sfb01=ccg01 AND SFB02 IN('1','7')
             AND ccg02=",tm.yy," AND ccg03=",tm.mm," AND a.sfa01=b1.sfa01 AND a.sfa27=b1.sfa27 AND b1.sfa16<>0
             AND a.sfa26 NOT in('0','1','2') AND substr(ccg04,7,1) IN('A') AND ccg01=a.sfa01 AND cch04=a.sfa03
             AND ccg04<>cch04 AND INSTR(ccg04,'-')=0 AND INSTR(cch04,'-')=0 AND cch31<>0
             AND cch04<>ccg04) a12
   WHERE bzxh<>0
   UNION ALL
  SELECT ccg04,sfa27,cch04,cch31,sfa28,sfa16a,'Y',bzxh,ccg01,'' 
    FROM (SELECT ccg01,ccg04,a.sfa27,cch04,cch31,a.sfa28,(b1.sfa13*CASE WHEN b1.sfa16<=b1.sfa161 THEN b1.sfa16 ELSE b1.sfa161 END) sfa16a,
                 CASE WHEN (ccg31*((b1.sfa13*CASE WHEN b1.sfa16<=b1.sfa161 THEN b1.sfa16 ELSE b1.sfa161 END)))>cch31 THEN (ccg31*((b1.sfa13*CASE WHEN b1.sfa16<=b1.sfa161 THEN b1.sfa16 ELSE b1.sfa161 END))) ELSE cch31 END bzxh,
                 CASE WHEN a.sfa26 in('0','1','2') THEN 'N' WHEN a.sfa26 NOT IN('0','1','2') AND A.SFA27=A.SFA03 THEN 'N' ELSE 'Y' END TDF 
            FROM ccg_file,cch_file,sfa_file a,sfb_file,sfa_file b1
           WHERE ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 AND sfb01=ccg01 AND SFB02 IN('1','7')
             AND ccg02=",tm.yy," AND ccg03=",tm.mm," AND a.sfa01=b1.sfa01 AND a.sfa27=b1.sfa27 AND b1.sfa16<>0
             AND a.sfa26 NOT in('0','1','2') AND substr(ccg04,7,1) IN('F','R','G') AND ccg01=a.sfa01 AND cch04=a.sfa03
             AND ccg04<>cch04 AND INSTR(ccg04,'-')=0 AND INSTR(cch04,'-')=0 AND cch31<>0
             AND cch04<>ccg04) a12
   WHERE bzxh<>0"
  PREPARE p820_p2 FROM g_sql
  EXECUTE p820_p2

  DELETE FROM ta_cca_file
  LET g_sql = 
  "INSERT INTO ta_cca_file
  SELECT imk01,SUM(imk09) 
    FROM (SELECT imk01,imk09 FROM imk_file WHERE imk05=",e_yy," AND imk06=",e_mm,"
           UNION
          SELECT cch04,cch91 FROM cch_file,sfb_file 
           WHERE cch02=",e_yy," AND cch03=",e_mm," 
             AND sfb01=cch01 AND SFB02 IN('1','7')
             AND ((sfb38 is null AND '",g_today,"' > '",e_date,"') OR
                  (sfb38 is not null AND sfb38 > '",e_date,"'))) a
   GROUP BY imk01"
  PREPARE p820_p3 FROM g_sql
  EXECUTE p820_p3

  DELETE FROM ex_cch_2
  INSERT INTO ex_cch_2
  SELECT ccg01,ccg04,ccg31 FROM ccg_file WHERE ccg02=tm.yy AND ccg03=tm.mm AND ccg31<>0

  FOR i = 1 TO 50
   #无下阶工单
    INSERT INTO ex_ccg_wgd
    SELECT tm.yy,tm.mm,ccg04,sfa27,cch04,cch31,sfa28,sfa16a,tdf,bzxh,ccg01,'','f' FROM ex_ccg_3
     WHERE cch04 NOT IN (SELECT CCG04 FROM ex_cch_2 WHERE ex_cch_2.ccg31<>0)

     DELETE FROM ex_ccg_3
      WHERE cch04 NOT IN (SELECT ccg04 FROM ex_cch_2 WHERE ex_cch_2.ccg31<>0)
     DELETE FROM ex_ccg_2

   #第二一套循环 扣除上期结存
    FOR k = 1 TO 100
      DELETE FROM ex_ccg_4

      LET g_sql = 
      "INSERT INTO ex_ccg_4
      SELECT ccg04,sfa27,cch04,cch31,sfa28,sfa16a,tdf,bzxh,ccg01,sfa08,nvl(TA_CCA02,0) 
        FROM (SELECT ccg04,sfa27,cch04,cch31,sfa28,sfa16a,tdf,bzxh,ccg01,sfa08,NVL(TA_CCA02,0) TA_CCA02,
                     row_number()over(partition by CCH04 order by ccg01,CCG04 DESC,SFA27 DESC) mm from ex_ccg_3 LEFT JOIN TA_CCA_FILE ON cch04=ta_cca01)
       WHERE mm=1"
      PREPARE p820_p4 FROM g_sql
      EXECUTE p820_p4

      DELETE FROM ex_ccg_3
       WHERE CCG04||CCH04||SFA27||CCG01 IN (SELECT CCG04||CCH04||SFA27||CCG01 FROM ex_ccg_4)

      DELETE FROM TA_CCA_FILE WHERE TA_CCA01 IN (SELECT SFA03 FROM ex_ccg_4)

      INSERT INTO TA_CCA_FILE
      SELECT SFA03,CCH31+SQKC FROM ex_ccg_4 WHERE CCH31+NVL(SQKC,0)>0

      INSERT INTO ex_ccg_2
      SELECT ccg04,sfa27,SFA03,cch31+SQKC,sfa28,sfa16a,tdf,bzxh+SQKC,ccg01,sfa08 FROM ex_ccg_4
       WHERE CCH31+nvl(SQKC,0)<0

      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM ex_ccg_3
      IF l_n>0 THEN
         CONTINUE FOR
      ELSE 
         EXIT FOR
      END IF
    END FOR

    DELETE FROM ex_ccg_3
    INSERT INTO ex_ccg_3 SELECT * FROM ex_ccg_2
    DELETE FROM ex_ccg_2

   #第二二套循环 与当期工单尽心比较

    DELETE FROM ex_ccg_5
    LET g_sql = 
    "INSERT INTO ex_ccg_5
    SELECT DISTINCT a.ccg04,a.sfa27,a.cch04,a.cch31,a.sfa28,a.sfa16a,a.tdf,a.bzxh,a.ccg01,sfa08,b.ccg01,b.ccg04 ,b.ccg31 
      FROM (select ccg04,sfa27,cch04,cch31,sfa28,sfa16a,tdf,bzxh,ccg01,sfa08 
              from (select ccg04,sfa27,cch04,cch31,sfa28,sfa16a,tdf,bzxh,ccg01,sfa08,
                           row_number()over(partition by CCH04 order by ccg01,CCG04 DESC,SFA27 DESC) mm 
                      from ex_ccg_3) 
             where mm=1) a
      LEFT JOIN
           (select ccg01,ccg04,ccg31 
              from (select ccg01,ccg04,ccg31,
                           row_number()over(partition by CCg04 order by CCG01 DESC) mm 
                      from ex_cch_2 
                     WHERE ccg31<0) 
             where mm=1) b ON a.cch04=b.ccg04 "
    PREPARE p820_p5 FROM g_sql
    EXECUTE p820_p5
             
    DELETE FROM ex_ccg_3 WHERE EXISTS(SELECT 'a' FROM ex_ccg_5 b WHERE ex_ccg_3.ccg01=b.ccg01 AND ex_ccg_3.cch04=b.sfa03)

    DELETE FROM ex_cch_2 WHERE EXISTS(SELECT 'a' FROM ex_ccg_5 b WHERE ex_cch_2.ccg01=b.ccg01a AND ex_cch_2.ccg04=b.ccg04a)

    INSERT INTO ex_ccg_result
     SELECT DISTINCT tm.yy,tm.mm,a.ccg04,c.sfa27,c.sfa03,
            CASE WHEN a.cch31-a.ccg31<=0 THEN b.cch31 ELSE CASE WHEN a.cch31-a.ccg31<=0 THEN ccg31 ELSE a.cch31 END*CASE WHEN c1.sfa16<=c1.sfa161 THEN c1.sfa16 ELSE c1.sfa161 END*c.sfa13 END cch31,c.sfa28,
            CASE WHEN c1.sfa16<=c1.sfa161 THEN c1.sfa16 ELSE c1.sfa161 END,
            tdf||CASE WHEN c.sfa26 in('0','1','2') THEN 'N' WHEN c.sfa26 NOT IN('0','1','2') AND C.SFA27=C.SFA03 THEN 'N' ELSE 'Y' END TDF,
            CASE WHEN a.cch31-a.ccg31<=0 THEN ccg31 ELSE a.cch31 END*CASE WHEN c1.sfa16<=c1.sfa161 THEN c1.sfa16 ELSE c1.sfa161 END*c1.sfa13 AS bzxh,cch01,'','f'
       FROM ex_ccg_5 a ,cch_file b,sfa_file c,sfb_file d,sfa_file c1
      WHERE a.ccg01a=b.cch01 AND c.sfa01=sfb01
        AND cch02=tm.yy AND cch03=tm.mm AND c.sfa01=c1.sfa01 AND c.sfa27=c1.sfa27 AND c1.sfa16<>0
        AND c.sfa01=a.ccg01a AND b.cch04=c.sfa03 AND INSTR(b.cch04,'-')=0

--下阶工单量 小于当阶数量，插入继续循环
     INSERT INTO ex_ccg_3
     SELECT CCG04,SFA27,SFA03,a.cch31-a.ccg31,SFA28,SFA16A,TDF,BZXH-a.ccg31,CCG01,SFA08
       FROM ex_ccg_5 a 
      WHERE a.cch31-a.ccg31<0
        AND sfa03 IN (SELECT ccg04 FROM ex_cch_2 b)

--更新工单余额档
    INSERT INTO ex_cch_2
    SELECT ccg01a,ccg04a,-1*(cch31-ccg31) FROM ex_ccg_5
     WHERE cch31-ccg31>0

    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM ex_ccg_3
    IF l_n>0 THEN
       CONTINUE FOR
    ELSE 
       EXIT FOR 
    END IF
  END FOR
END FUNCTION

FUNCTION p900_p()
  
  CALL p900_p_1()   #将所有料件先插入成本表
  CALL p900_p_2()   #上期期末转本期期初
  CALL p900_p_3()   #更新委外与采购入库数量、金额
  CALL p900_p_4()   #更新库存杂项入库、样品入库数量、金额；杂项出库数量
  CALL p900_p_5()   #更新WIP杂项入库数量、金额
  CALL p900_p_6()   #更新工单入库数量
  CALL p900_p_7()   #人工/制费分摊
  CALL p900_p_8()   #工单领用/退料数量
  CALL p900_p_9()   #期末结存
  CALL p900_p_10()  #期初与当月转到WIP 的加权平均单价
  CALL p900_p_11()  #更新销货成本
  CALL p900_p_12()  #更新材料利用率/实际用量
  CALL p900_p_13()  #更新库存杂项异动入库材料、人工、制费金额
  CALL p900_p_14()  #加权单价计算
  CALL p900_p_15()  #返工计算

END FUNCTION

FUNCTION p900_p_1()  #将所有料件先插入成本表
  
  INSERT INTO ta_ccp_file
  SELECT ima01,tm.yy,tm.mm,ima16,
         0,0,'1',' ',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
         0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
         0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
         0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
         0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
         0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
         0,0,0,0,0,0,0
    FROM ima_file
   WHERE SUBSTR(ima01,0,1)<>'K'

  IF sqlca.sqlcode THEN 
     CALL cl_err('',sqlca.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF 
END FUNCTION

FUNCTION p900_p_2()  #上期期末转本期期初
  #2017年1月取开账资料
  IF tm.yy = 2017 AND tm.mm = 1 THEN
     #在制金额
     UPDATE ta_ccp_file 
        SET ta_ccc18 =(SELECT ta_imk09 FROM ta_imk_file WHERE ta_ccc01=ta_imk01 AND ta_imk05=e_yy AND ta_imk06=e_mm AND ta_imk089='zz'),
            ta_ccc19 =(SELECT ta_imk09*(ta_imk088+ta_imk087+ta_imk086) FROM ta_imk_file WHERE ta_ccc01=ta_imk01 AND ta_imk05=e_yy AND ta_imk06=e_mm AND ta_imk089='zz'),
            ta_ccc19a=(SELECT ta_imk09*(ta_imk088) FROM ta_imk_file WHERE ta_ccc01=ta_imk01 AND ta_imk05=e_yy AND ta_imk06=e_mm AND ta_imk089='zz' ),
            ta_ccc19b=(SELECT ta_imk09*(ta_imk087) FROM ta_imk_file WHERE ta_ccc01=ta_imk01 AND ta_imk05=e_yy AND ta_imk06=e_mm AND ta_imk089='zz' ),
            ta_ccc19c=(SELECT ta_imk09*(ta_imk086) FROM ta_imk_file WHERE ta_ccc01=ta_imk01 AND ta_imk05=e_yy AND ta_imk06=e_mm AND ta_imk089='zz' )
      WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
        AND ta_ccc01 IN (SELECT ta_imk01 FROM ta_imk_file WHERE ta_imk05=e_yy AND ta_imk06=e_mm AND ta_imk089='zz')
     #库存金额
     UPDATE ta_ccp_file
        SET ta_ccc11 =(SELECT ta_imk09 FROM ta_imk_file WHERE ta_ccc01=ta_imk01 AND ta_imk05=e_yy AND ta_imk06=e_mm AND ta_imk089='kc'),
            ta_ccc12 =(SELECT ta_imk09*(ta_imk088+ta_imk087+ta_imk086) FROM ta_imk_file WHERE ta_ccc01=ta_imk01 AND ta_imk05=e_yy AND ta_imk06=e_mm AND ta_imk089='kc'),
            ta_ccc12a=(SELECT ta_imk09*(ta_imk088) FROM ta_imk_file WHERE ta_ccc01=ta_imk01 AND ta_imk05=e_yy AND ta_imk06=e_mm AND ta_imk089='kc'),
            ta_ccc12b=(SELECT ta_imk09*(ta_imk087) FROM ta_imk_file WHERE ta_ccc01=ta_imk01 AND ta_imk05=e_yy AND ta_imk06=e_mm AND ta_imk089='kc'),
            ta_ccc12c=(SELECT ta_imk09*(ta_imk086) FROM ta_imk_file WHERE ta_ccc01=ta_imk01 AND ta_imk05=e_yy AND ta_imk06=e_mm AND ta_imk089='kc')
      WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
        AND ta_ccc01 IN (SELECT ta_imk01 FROM ta_imk_file WHERE ta_imk05=e_yy AND ta_imk06=e_mm AND ta_imk089='kc')
  ELSE
     #在制金额
     UPDATE ta_ccp_file
        SET ta_ccc18 =(SELECT ta_ccc98  FROM ta_ccp_file b WHERE ta_ccp_file.ta_ccc01=b.ta_ccc01 AND b.ta_ccc02=e_yy AND b.ta_ccc03=e_mm),
            ta_ccc19 =(SELECT ta_ccc99  FROM ta_ccp_file c WHERE ta_ccp_file.ta_ccc01=c.ta_ccc01 AND c.ta_ccc02=e_yy AND c.ta_ccc03=e_mm),
            ta_ccc19a=(SELECT ta_ccc99a FROM ta_ccp_file d WHERE ta_ccp_file.ta_ccc01=d.ta_ccc01 AND d.ta_ccc02=e_yy AND d.ta_ccc03=e_mm),
            ta_ccc19b=(SELECT ta_ccc99b FROM ta_ccp_file e WHERE ta_ccp_file.ta_ccc01=e.ta_ccc01 AND e.ta_ccc02=e_yy AND e.ta_ccc03=e_mm),
            ta_ccc19c=(SELECT ta_ccc99c FROM ta_ccp_file f WHERE ta_ccp_file.ta_ccc01=f.ta_ccc01 AND f.ta_ccc02=e_yy AND f.ta_ccc03=e_mm),
            ta_ccc19d=(SELECT ta_ccc99d FROM ta_ccp_file g WHERE ta_ccp_file.ta_ccc01=g.ta_ccc01 AND g.ta_ccc02=e_yy AND g.ta_ccc03=e_mm),
            ta_ccc19e=(SELECT ta_ccc99e FROM ta_ccp_file h WHERE ta_ccp_file.ta_ccc01=h.ta_ccc01 AND h.ta_ccc02=e_yy AND h.ta_ccc03=e_mm),
            ta_ccc19f=(SELECT ta_ccc99f FROM ta_ccp_file i WHERE ta_ccp_file.ta_ccc01=i.ta_ccc01 AND i.ta_ccc02=e_yy AND i.ta_ccc03=e_mm),
            ta_ccc19g=(SELECT ta_ccc99g FROM ta_ccp_file j WHERE ta_ccp_file.ta_ccc01=j.ta_ccc01 AND j.ta_ccc02=e_yy AND j.ta_ccc03=e_mm),
            ta_ccc19h=(SELECT ta_ccc99h FROM ta_ccp_file k WHERE ta_ccp_file.ta_ccc01=k.ta_ccc01 AND k.ta_ccc02=e_yy AND k.ta_ccc03=e_mm)
      WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
        AND ta_ccc01 IN (SELECT ta_ccc01 FROM ta_ccp_file k WHERE k.ta_ccc02=e_yy AND k.ta_ccc03=e_mm)

     #库存金额
     UPDATE ta_ccp_file
        SET ta_ccc11 =(SELECT ta_ccc91  FROM ta_ccp_file b WHERE ta_ccp_file.ta_ccc01=b.ta_ccc01 AND b.ta_ccc02=e_yy AND b.ta_ccc03=e_mm),
            ta_ccc12 =(SELECT ta_ccc92  FROM ta_ccp_file c WHERE ta_ccp_file.ta_ccc01=c.ta_ccc01 AND c.ta_ccc02=e_yy AND c.ta_ccc03=e_mm),
            ta_ccc12a=(SELECT ta_ccc92a FROM ta_ccp_file d WHERE ta_ccp_file.ta_ccc01=d.ta_ccc01 AND d.ta_ccc02=e_yy AND d.ta_ccc03=e_mm),
            ta_ccc12b=(SELECT ta_ccc92b FROM ta_ccp_file e WHERE ta_ccp_file.ta_ccc01=e.ta_ccc01 AND e.ta_ccc02=e_yy AND e.ta_ccc03=e_mm),
            ta_ccc12c=(SELECT ta_ccc92c FROM ta_ccp_file f WHERE ta_ccp_file.ta_ccc01=f.ta_ccc01 AND f.ta_ccc02=e_yy AND f.ta_ccc03=e_mm),
            ta_ccc12d=(SELECT ta_ccc92d FROM ta_ccp_file g WHERE ta_ccp_file.ta_ccc01=g.ta_ccc01 AND g.ta_ccc02=e_yy AND g.ta_ccc03=e_mm),
            ta_ccc12e=(SELECT ta_ccc92e FROM ta_ccp_file h WHERE ta_ccp_file.ta_ccc01=h.ta_ccc01 AND h.ta_ccc02=e_yy AND h.ta_ccc03=e_mm),
            ta_ccc12f=(SELECT ta_ccc92f FROM ta_ccp_file i WHERE ta_ccp_file.ta_ccc01=i.ta_ccc01 AND i.ta_ccc02=e_yy AND i.ta_ccc03=e_mm),
            ta_ccc12g=(SELECT ta_ccc92g FROM ta_ccp_file j WHERE ta_ccp_file.ta_ccc01=j.ta_ccc01 AND j.ta_ccc02=e_yy AND j.ta_ccc03=e_mm),
            ta_ccc12h=(SELECT ta_ccc92h FROM ta_ccp_file k WHERE ta_ccp_file.ta_ccc01=k.ta_ccc01 AND k.ta_ccc02=e_yy AND k.ta_ccc03=e_mm)
      WHERE ta_ccc02=tm.yy AND ta_CCC03=tm.mm
        AND ta_ccc01 IN(SELECT ta_ccc01 FROM ta_ccp_file k WHERE k.ta_ccc02=e_yy AND k.ta_ccc03=e_mm)
  END IF
END FUNCTION

FUNCTION p900_p_3()  #更新委外与采购入库数量、金额

LET g_sql = " UPDATE ta_ccp_file ", 
      " SET ta_ccc211 =(SELECT ccc211  FROM ccc_file WHERE ta_ccc01=ccc01 AND ta_ccc02=ccc02 AND ta_ccc03=ccc03), ",
      " ta_ccc212 =(SELECT ccc212  FROM ccc_file WHERE ta_ccc01=ccc01 AND ta_ccc02=ccc02 AND ta_ccc03=ccc03), ",
      " ta_ccc221 =(SELECT ccc221  FROM ccc_file WHERE ta_ccc01=ccc01 AND ta_ccc02=ccc02 AND ta_ccc03=ccc03), ",
      " ta_ccc222 =(SELECT ccc222  FROM ccc_file WHERE ta_ccc01=ccc01 AND ta_ccc02=ccc02 AND ta_ccc03=ccc03), ",
      " ta_ccc22a1=(SELECT ccc22a1+ccc22a5 FROM ccc_file WHERE ta_ccc01=ccc01 AND ta_ccc02=ccc02 AND ta_ccc03=ccc03), ",
      " ta_ccc22d2=(SELECT ccc22d2 FROM ccc_file WHERE ta_ccc01=ccc01 AND ta_ccc02=ccc02 AND ta_ccc03=ccc03), ",
      " ta_ccc216 =(SELECT ccc216  FROM ccc_file WHERE ta_ccc01=ccc01 AND ta_ccc02=ccc02 AND ta_ccc03=ccc03), ",
      " ta_ccc226 =(SELECT ccc226  FROM ccc_file WHERE ta_ccc01=ccc01 AND ta_ccc02=ccc02 AND ta_ccc03=ccc03), ",
      " ta_ccc61  =(SELECT ccc61   FROM ccc_file WHERE ta_ccc01=ccc01 AND ta_ccc02=ccc02 AND ta_ccc03=ccc03), ",
      " ta_ccc62  =(SELECT ccc62   FROM ccc_file WHERE ta_ccc01=ccc01 AND ta_ccc02=ccc02 AND ta_ccc03=ccc03), ",
      " ta_ccc64  =(SELECT ccc64   FROM ccc_file WHERE ta_ccc01=ccc01 AND ta_ccc02=ccc02 AND ta_ccc03=ccc03), ",
      " ta_ccc65  =(SELECT ccc65   FROM ccc_file WHERE ta_ccc01=ccc01 AND ta_ccc02=ccc02 AND ta_ccc03=ccc03)  ",
#     " ta_ccc213 =(SELECT ccc213  FROM ccc_file WHERE ta_ccc01=ccc01 AND ta_ccc02=ccc02 AND ta_ccc03=ccc03), ",
#     " ta_ccc22d3=NVL((SELECT ccc22d3 FROM ccc_file WHERE ta_ccc01=ccc01 AND ta_ccc02=ccc02 AND ta_ccc03=ccc03 and ccc213<>0),0) ",
   " WHERE ta_ccc01 IN (SELECT ccc01 FROM ccc_file WHERE ccc02 = ",tm.yy," AND ccc03 = ",tm.mm,") ",
   "   AND ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm," "
   
   PREPARE p900_p18 FROM g_sql
   EXECUTE p900_p18
END FUNCTION

FUNCTION p900_p_4()  #更新库存杂项入库、样品入库数量、金额；杂项出库数量

  #更新库存杂项入库数量
  UPDATE ta_ccp_file 
     SET ta_ccc214=(SELECT SUM(tlf10) FROM tlf_file 
                     WHERE tlf13 IN ('aimt302','aimt312') AND INSTR(tlf01,'-')=0
                       AND tlf06 BETWEEN b_date AND e_date
                       AND tlf902 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
                       AND tlf902 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y') AND ta_ccc01=tlf01)
   WHERE ta_ccc01 IN (SELECT tlf01 FROM tlf_file 
                       WHERE tlf13 IN ('aimt302','aimt312') AND INSTR(tlf01,'-')=0
                         AND tlf06 BETWEEN b_date AND e_date
                         AND tlf902 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
                         AND tlf902 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y'))
     AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm

  #更新样品仓库存杂项异动入库数量
    UPDATE ta_ccp_file SET ta_cccud11=(SELECT SUM(tlf10)
  FROM tlf_file  WHERE tlf13 IN('aimt324') AND INSTR(tlf01,'-')=0
  AND to_char(tlf06,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND tlf902 IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND tlf902 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=tlf01)
   WHERE ta_ccc01 IN(SELECT tlf01 FROM tlf_file WHERE tlf13 IN('aimt324') AND INSTR(tlf01,'-')=0
  AND to_char(tlf06,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND tlf902 IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND tlf902 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y'))
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 
     
--更新库存杂项异动入库金额
 UPDATE ta_ccp_file SET ta_ccc22a4=(CASE WHEN (ta_ccc11+ta_ccc211)=0 THEN 0 ELSE ta_ccc214*(ta_ccc12+ta_ccc22a1)/(ta_ccc11+ta_ccc211) END )
   WHERE ta_ccc214>0 AND ta_ccc22a4=0
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 
   
 UPDATE ta_ccp_file SET ta_ccc22a4=(SELECT SUM(inb09*inb13)
  FROM ina_file,inb_file WHERE ina01=inb01 
  AND to_char(ina02,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND inb05 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND inb05 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=inb04
  AND inapost='Y' AND INACONF='Y' AND ina00='3' )
   WHERE ta_ccc01 IN(SELECT inb04
  FROM ina_file,inb_file WHERE ina01=inb01 
  AND to_char(ina02,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND inb05 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND inb05 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=inb04
  AND inapost='Y' AND INACONF='Y' AND ina00='3') AND ta_ccc22a4=0
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 
   
  LET g_sql = " UPDATE ta_ccp_file SET ta_ccc22a4=(ta_ccc214*NVL((SELECT CCC23a from ",
              "  (select ccc01,ccc02||ccc03,ccc23a,row_number()over(partition by ccc01 order by to_char(to_date(ccc02||ccc03,'yyyyMM'),'yyyyMM') desc) mm from ccc_file ",
              "   WHERE to_date(ccc02||ccc03,'yyyyMM')<=to_date(",tm.yy,"||",tm.mm,",'yyyyMM') AND ccc23<>0 ",
              "   ) where mm=1  AND ta_ccc01=ccc01),0) ) ",
              "   WHERE ta_ccc214>0 AND ta_ccc22a4=0 ",
              "  AND ta_ccc02= ",tm.yy," AND ta_ccc03=",tm.mm," " 
  PREPARE p900_p1 FROM g_sql
  EXECUTE p900_p1 

  #更新库存杂项出库数量  ta_ccc41
 UPDATE ta_ccp_file SET ta_ccc41=(SELECT SUM(tlf10*TLF907)
  FROM tlf_file  WHERE tlf13 IN ('aimt301','aimt303','aimt311','aimt313') AND INSTR(tlf01,'-')=0
  AND to_char(tlf06,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND tlf902 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND tlf902 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=tlf01)
   WHERE ta_ccc01 IN(SELECT tlf01 FROM tlf_file WHERE tlf13 IN ('aimt301','aimt303','aimt311','aimt313') AND INSTR(tlf01,'-')=0
  AND to_char(tlf06,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND tlf902 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND tlf902 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y'))
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 

END FUNCTION

FUNCTION p900_p_5()  #更新WIP杂项入库数量、金额

--更新WIP杂项入库数量  ta_ccc217
 UPDATE ta_ccp_file SET ta_ccc217=(SELECT SUM(tlf10*TLF907)
  FROM tlf_file  WHERE tlf13 IN('aimt312','aimt302') AND INSTR(tlf01,'-')=0
  AND to_char(tlf06,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND tlf902 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND tlf902 IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=tlf01)
   WHERE ta_ccc01 IN(SELECT tlf01 FROM tlf_file WHERE tlf13 IN('aimt312','aimt302') AND INSTR(tlf01,'-')=0
  AND to_char(tlf06,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND tlf902 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND tlf902 IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y'))
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 

 UPDATE ta_ccp_file SET ta_ccc217=ta_ccc217+(SELECT nvl(SUM(tlf10*TLF907*ljyl),0)
  FROM tlf_file,ex_bom_cp  WHERE tlf01=cplh AND tlf13 IN('aimt312') AND INSTR(tlf01,'-')>0 AND INSTR(yjlh,'-')=0
    AND to_char(sxrq1,'yyyyMM')<=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
    AND ex_bom_cp.yy = tm.yy AND ex_bom_cp.mm = tm.mm
  AND nvl(to_char(sxrq2,'yyyyMM'),TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')) >=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND to_char(tlf06,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND tlf902 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')  AND tlf01=cplh
  AND tlf902 IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=yjlh  )
   WHERE ta_ccc01 IN(SELECT yjlh FROM tlf_file,ex_bom_cp WHERE tlf13 IN('aimt312') AND INSTR(tlf01,'-')>0
     AND to_char(sxrq1,'yyyyMM')<=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')  AND tlf01=cplh
     AND ex_bom_cp.yy = tm.yy AND ex_bom_cp.mm = tm.mm
  AND nvl(to_char(sxrq2,'yyyyMM'),TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')) >=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
   AND INSTR(yjlh,'-')=0  AND to_char(tlf06,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND tlf902 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND tlf902 IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y'))
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 
   
--入到非WIP带‘-’料号需要转下阶
 UPDATE ta_ccp_file SET ta_ccc217=ta_ccc217+(SELECT nvl(SUM(tlf10*TLF907*ljyl),0)
  FROM tlf_file,ex_bom_cp  WHERE tlf01=cplh AND tlf13 IN('aimt302') AND INSTR(tlf01,'-')>0 AND INSTR(yjlh,'-')=0
    AND to_char(sxrq1,'yyyyMM')<=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
    AND ex_bom_cp.yy = tm.yy AND ex_bom_cp.mm = tm.mm
  AND nvl(to_char(sxrq2,'yyyyMM'),to_char(SYSDATE+1,'yyyyMM')) >TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND to_char(tlf06,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND tlf902 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')  AND tlf01=cplh
  AND tlf902 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=yjlh  )
   WHERE ta_ccc01 IN(SELECT yjlh FROM tlf_file,ex_bom_cp WHERE tlf13 IN('aimt312') AND INSTR(tlf01,'-')>0
     AND to_char(sxrq1,'yyyyMM')<=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')  AND tlf01=cplh
     AND ex_bom_cp.yy = tm.yy AND ex_bom_cp.mm = tm.mm
  AND nvl(to_char(sxrq2,'yyyyMM'),TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')) >=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
   AND INSTR(yjlh,'-')=0  AND to_char(tlf06,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND tlf902 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND tlf902 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y'))
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 

--更新WIP杂项出库数量 ta_ccc81
 --正常出库
 UPDATE ta_ccp_file SET ta_ccc81=(SELECT NVL(SUM(tlf10*TLF907*tlf12),0)
  FROM tlf_file  WHERE tlf13 IN ('aimt301','aimt303','aimt311','aimt313') AND INSTR(tlf01,'-')=0
  AND to_char(tlf06,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND tlf902 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND tlf902 IN (SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y') AND ta_ccc01=tlf01)
   WHERE ta_ccc01 IN(SELECT tlf01 FROM tlf_file WHERE tlf13 IN ('aimt301','aimt303','aimt311','aimt313') AND INSTR(tlf01,'-')=0
  AND to_char(tlf06,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND tlf902 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND tlf902 IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y'))
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 

--带'-'的料号，要展尾阶 luoyb
  --领用带‘-’料号需要转下阶
 UPDATE ta_ccp_file SET ta_ccc81=ta_ccc81+(SELECT NVL(SUM(tlf10*TLF907*tlf12*ljyl),0)
  FROM tlf_file,ex_bom_cp WHERE tlf01=cplh AND tlf13 IN ('aimt301','aimt303','aimt311','aimt313') AND INSTR(tlf01,'-')>0 AND INSTR(yjlh,'-')=0
    AND to_char(sxrq1,'yyyyMM')<=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
    AND ex_bom_cp.yy = tm.yy AND ex_bom_cp.mm = tm.mm
  AND nvl(to_char(sxrq2,'yyyyMM'),TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')) >=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND to_char(tlf06,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND tlf902 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')  AND tlf01=cplh
  AND tlf902 IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=yjlh  )
   WHERE ta_ccc01 IN(SELECT yjlh FROM tlf_file,ex_bom_cp WHERE tlf13 IN ('aimt301','aimt303','aimt311','aimt313') AND INSTR(tlf01,'-')>0
     AND to_char(sxrq1,'yyyyMM')<=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')  AND tlf01=cplh
     AND ex_bom_cp.yy = tm.yy AND ex_bom_cp.mm = tm.mm
  AND nvl(to_char(sxrq2,'yyyyMM'),TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')) >=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
   AND INSTR(yjlh,'-')=0  AND to_char(tlf06,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND tlf902 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND tlf902 IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y'))
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 

 --从非WIP领用带‘-’料号需要转下阶
 UPDATE ta_ccp_file SET ta_ccc81=ta_ccc81+(SELECT NVL(SUM(tlf10*TLF907*tlf12*ljyl),0)
  FROM tlf_file,ex_bom_cp  WHERE tlf01=cplh AND tlf13 IN ('aimt301','aimt303','aimt311','aimt313') AND INSTR(tlf01,'-')>0 AND INSTR(yjlh,'-')=0
    AND to_char(sxrq1,'yyyyMM')<=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
    AND ex_bom_cp.yy = tm.yy AND ex_bom_cp.mm = tm.mm
  AND nvl(to_char(sxrq2,'yyyyMM'),to_char(SYSDATE+1,'yyyyMM')) >TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND to_char(tlf06,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND tlf902 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')  AND tlf01=cplh
  AND tlf902 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=yjlh  )
   WHERE ta_ccc01 IN(SELECT yjlh FROM tlf_file,ex_bom_cp WHERE tlf13 IN ('aimt301','aimt303','aimt311','aimt313') AND INSTR(tlf01,'-')>0
     AND to_char(sxrq1,'yyyyMM')<=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')  AND tlf01=cplh
     AND ex_bom_cp.yy = tm.yy AND ex_bom_cp.mm = tm.mm
  AND nvl(to_char(sxrq2,'yyyyMM'),to_char(SYSDATE+1,'yyyyMM')) >TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
   AND INSTR(yjlh,'-')=0  AND to_char(tlf06,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND tlf902 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND tlf902 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y'))
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 

END FUNCTION

FUNCTION p900_p_6()  #更新工单入库数量

  #更新工单入库数量
    UPDATE ta_ccp_file SET TA_CCC213=( SELECT SUM(CCG31*-1) FROM CCG_FILE,SFB_FILE
                                     WHERE CCG04=TA_CCC01 AND CCG02=tm.yy AND CCG03=tm.mm AND CCG31<>0
                                     AND SFB01=CCG01 AND sfb02 IN('1','7'))
  WHERE TA_CCC02=tm.yy AND TA_CCC03=tm.mm AND TA_CCC01 IN(SELECT CCG04 FROM CCG_FILE,SFB_FILE
                                     WHERE CCG02=tm.yy AND CCG03=tm.mm AND CCG31<>0 AND sfb02 IN('1','7')
                                     AND SFB01=CCG01 )
{  #还是需要认定为返工
  UPDATE ta_ccp_file SET TA_CCC213=TA_CCC213+( SELECT SUM(CCG31*-1) FROM CCG_FILE,SFB_FILE,cch_file
                                     WHERE CCG04=TA_CCC01 AND CCG02=tm.yy AND CCG03=tm.mm AND CCG31<>0
                                     AND ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 AND ccg04<>cch04
                                     AND SFB01=CCG01 AND sfb02 IN('5','8') )
  WHERE TA_CCC02=tm.yy AND TA_CCC03=tm.mm AND TA_CCC01 IN(SELECT CCG04 FROM CCG_FILE,SFB_FILE,cch_file
                                     WHERE CCG02=tm.yy AND CCG03=tm.mm AND CCG31<>0 AND sfb02 IN('5','8')
                                     AND ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 AND ccg04<>cch04
                                     AND ccg01 IN(SELECT cch01 FROM cch_file WHERE CCh02=2017 AND CCh03=1
                                     GROUP BY cch01 HAVING COUNT(cch01)=1)
                                     AND SFB01=CCG01 )
}

  LET g_sql = "
  UPDATE ta_ccp_file SET TA_CCC27=NVL((SELECT SUM(CCG31*-1) FROM CCG_FILE,SFB_FILE
                                     WHERE CCg04=TA_CCC01 AND CCG02=",tm.yy," AND CCG03=",tm.mm," AND CCG31<>0
                                     AND SFB01=CCG01 AND sfb02 IN('5','8')),0)
  WHERE TA_CCC02=",tm.yy," AND TA_CCC03=",tm.mm," AND TA_CCC01 IN(SELECT CCG04 FROM CCG_FILE,SFB_FILE
                                     WHERE CCG02=",tm.yy," AND CCG03=",tm.mm," AND CCG31<>0
                                     AND SFB01=CCG01 AND sfb02 IN('5','8')) "
  PREPARE p900_p1_1 FROM g_sql
  EXECUTE p900_p1_1 
  
{
  UPDATE ta_ccp_file SET TA_CCC25=( SELECT SUM(CCH31*-1) FROM CCG_FILE,SFB_FILE,CCH_FILE
                                     WHERE CCG04=TA_CCC01 AND CCG02=tm.yy AND CCG03=tm.mm AND CCG31<>0
                                     AND CCG01=CCH01 AND CCG02=CCH02 AND CCG03=CCH03
                                     AND ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 AND ccg04=cch04
                                     AND SFB01=CCG01 AND sfb02 IN('5','8') AND CCG04=CCH04)
  WHERE TA_CCC02=tm.yy AND TA_CCC03=tm.mm AND TA_CCC01 IN(SELECT CCG04 FROM CCG_FILE,SFB_FILE,CCH_FILE
                                     WHERE CCG02=tm.yy AND CCG03=tm.mm AND CCG31<>0 AND CCG04=CCH04
                                     AND CCG01=CCH01 AND CCG02=CCH02 AND CCG03=CCH03
                                     AND SFB01=CCG01 AND sfb02 IN('5','8'))
}

 --更新本阶加工                                    
   UPDATE ta_ccp_file SET ta_ccc22d3=( SELECT SUM(cch32d)*-1 FROM CCH_FILE,CCG_FILE,SFB_FILE
   WHERE CCG01=CCH01 AND CCG02=CCH02 AND CCG03=CCH03 AND CCG02=tm.yy AND CCG03=tm.mm AND CCG04=ta_ccc01 
   AND SFB01=CCG01 AND cch04 LIKE ' DL+OH+SUB' AND ccg31 <> 0
   )
   WHERE TA_CCC01 IN(SELECT CCG04 FROM CCH_FILE,CCG_FILE,SFB_FILE
   WHERE CCG01=CCH01 AND CCG02=CCH02 AND CCG03=CCH03 AND CCG02=tm.yy AND CCG03=tm.mm AND CCG04=ta_ccc01 
   AND SFB01=CCG01 AND cch04 LIKE ' DL+OH+SUB' AND ccg31 <> 0
   )
   AND TA_CCC02=tm.yy AND TA_CCC03=tm.mm
  
END FUNCTION

FUNCTION p900_p_7()  #人工/制费分摊

--开始汇集工费
DELETE FROM ta_ccj_file WHERE ta_ccj01=tm.yy AND ta_ccj02=tm.mm

DELETE FROM ta_cck_file WHERE ta_cck01=tm.yy AND ta_cck02=tm.mm

DELETE FROM tc_ecu01_file
INSERT INTO tc_ecu01_file
SELECT cplh,ECU02,'','',SUM(ECB19) ecb19,SUM(ECB21) ecb21,eca03
FROM ecu_file,ecb_file,eca_file LEFT JOIN gem_file ON eca03=gem01,ex_bom_GS
WHERE ecu01=ecb01 AND ecu02=ecb02 AND ecu10='Y' AND ecb08=eca01
  AND ex_bom_gs.yy = tm.yy AND ex_bom_gs.mm = tm.mm
AND to_char(sxrq1,'yyyyMM')<=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
AND nvl(to_char(sxrq2,'yyyyMM'),to_char(SYSDATE+1,'yyyyMM')) >TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
AND ecu01=yjlh AND (ecb19<>0 OR ECB21<>0) AND ecuud02='Y' 
AND EXISTS(SELECT sfv04 FROM sfu_file,sfv_file,SFB_FILE WHERE sfu01=sfv01 AND sfupost='Y'
AND to_CHAR(sfu02,'yyyy')=tm.yy AND to_CHAR(sfu02,'MM')=tm.mm AND CPLH=SFV04
 AND SFV11=SFB01 AND SFB02 IN('1','7') AND substr(sfv04,7,1) IN('A','F','R','G') AND INSTR(sfv04,'-')=0
) AND (cplh=yjlh OR instr(yjlh,'-')>0)
GROUP BY cplh,ECU02,eca03

--汇取部门工时费用抓取
INSERT INTO  ta_ccj_FILE
SELECT tm.yy,tm.mm,ECA03a,SUM(sfv09*ECB19a)/3600/1000 ecb19a,SUM(sfv09*ECB19a)/3600/1000 ecb21a,
nvl(d.aao05,0)/(SUM(sfv09*ECB19a)/3600/1000) ccj06,NVL(d.aao05,0) ccj06a,
CASE WHEN (SUM(sfv09*ECB19a)/3600/1000)=0 THEN 0 ELSE nvl(e.aao05,0)/(SUM(sfv09*ECB19a)/3600/1000) END ccj07,
  NVL(E.aao05,0) ccj07a,0,0 FROM
( SELECT SFV04,SUM(SFV09) SFV09,SFB06
FROM sfu_file,sfv_file,SFB_FILE WHERE sfu01=sfv01 AND sfupost='Y'
AND to_CHAR(sfu02,'yyyy')=tm.yy AND to_CHAR(sfu02,'MM')=tm.mm
 AND SFV11=SFB01 AND SFB02 IN('1','7') AND substr(sfv04,7,1) IN('A','F','R','G') AND INSTR(sfv04,'-')=0
 GROUP BY SFV04,SFB06
 ) A
 LEFT JOIN
 (  SELECT ECU02a,ECU01a,ecb06a,ecb19a,eca03a,gem02 FROM tc_ecu01_file LEFT JOIN gem_file ON eca03a=gem01) B ON  SFB06=ECU02a  AND SFV04=ECU01a
 LEFT JOIN
  ( SELECT aao02,SUM(aao05) aao05 FROM aao_file WHERE aao03=tm.yy AND aao04=tm.mm AND aao01='500102'
GROUP BY aao02 ) d ON eca03a=d.aao02
 LEFT JOIN
  ( SELECT aao02,SUM(aao05) aao05 FROM aao_file WHERE aao03=tm.yy AND aao04=tm.mm AND aao01='5101'
 GROUP BY aao02 ) E ON eca03a=E.aao02
 GROUP BY ECA03a,gem02,d.aao05,E.aao05

--杂项费用总额
  UPDATE ta_ccj_file SET ta_ccj08a=( SELECT SUM(aao05) aao05 FROM aao_file WHERE aao03=tm.yy AND aao04=tm.mm
  AND  aao01='5101'
  AND AAO02 NOT IN( SELECT eca03a FROM tc_ecu01_file LEFT JOIN gem_file ON eca03a=gem01) )
 WHERE ta_ccj01=tm.yy AND TA_CCJ02=tm.mm

 --单位杂项费用
 UPDATE ta_ccj_file SET ta_ccj08=( SELECT SUM(aao05) aao05 FROM aao_file WHERE aao03=tm.yy AND aao04=tm.mm AND aao01='5101'
  AND AAO02 NOT IN( SELECT eca03a FROM tc_ecu01_file LEFT JOIN gem_file ON eca03a=gem01) )/(SELECT SUM(TA_CCJ04) FROM TA_CCJ_FILE
  WHERE ta_ccj01=tm.yy AND TA_CCJ02=tm.mm)
 WHERE ta_ccj01=tm.yy AND TA_CCJ02=tm.mm

 --获取产品入库工时成本
INSERT INTO  ta_cck_FILE
SELECT ta_ccj01,ta_ccj02,SFV04,ECA03a ta_cck04,SUM(sfv09*ECB19a)/3600/1000 ta_cck05,
ta_ccj06 ta_cck06,ta_ccj06*SUM(sfv09*ECB19a)/3600/1000 ta_cck06a,
ta_ccj07 ta_cck07,(SUM(sfv09*ECB19a)/3600/1000)*ta_ccj07 ta_ccj07a,
ta_ccj08 ta_cck08,(SUM(sfv09*ECB19a)/3600/1000)*ta_ccj08 ta_ccj08a,sfv09,SUM(ECB19a)/3600/1000,ECU02a  FROM
( SELECT SFV04,SUM(SFV09) SFV09,SFB06
FROM sfu_file,sfv_file,SFB_FILE WHERE sfu01=sfv01 AND sfupost='Y'
AND to_CHAR(sfu02,'yyyy')=tm.yy AND to_CHAR(sfu02,'MM')=tm.mm
 AND SFV11=SFB01 AND SFB02 IN('1','7') AND substr(sfv04,7,1) IN('A','F','R','G') AND INSTR(sfv04,'-')=0
 GROUP BY SFV04,SFB06
 ) A
 LEFT JOIN
 (  SELECT ECU02a,ECU01a,ecb06a,ecb19a,ecb21a,eca03a,gem02 FROM tc_ecu01_file LEFT JOIN gem_file ON eca03a=gem01
) B ON  SFB06=ECU02a  AND SFV04=ECU01a
LEFT JOIN
(SELECT * FROM ta_ccj_file WHERE ta_ccj01=tm.yy AND ta_ccj02=tm.mm ) c ON eca03a=ta_ccj03
GROUP BY ta_ccj01,ta_ccj02,SFV04,ECA03a,ta_ccj06,ta_ccj07,ta_ccj08,sfv09,ECU02a

--更新工单 工费等

 UPDATE ta_ccp_file SET ta_ccc22b3=(SELECT SUM(ta_cck06a) FROM ta_cck_file WHERE ta_cck01=tm.yy AND ta_cck02=tm.mm AND ta_ccc01=ta_cck03)
 ,ta_ccc22c3=(SELECT SUM(ta_cck07a+ta_cck08a) FROM ta_cck_file WHERE ta_cck01=tm.yy AND ta_cck02=tm.mm AND ta_ccc01=ta_cck03)
   WHERE ta_ccc01 IN(SELECT ta_cck03 FROM ta_cck_file WHERE ta_cck01=tm.yy AND ta_cck02=tm.mm)
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 

END FUNCTION

FUNCTION p900_p_8()  #工单领用/退料数量

  --更新工单领用  ta_ccc31
DELETE FROM gdlyb
LET g_sql = "INSERT INTO gdlyb ",
 "SELECT tlf01,sum(tlf10) tlf10,lx FROM ",
 "(SELECT tlf01,sum(tlf10*tlf12*-TLF907) AS tlf10,'asfi51' lx ",
 " FROM tlf_file ",
 " WHERE tlf907<>0 AND tlf13 LIKE 'asfi51%' ",   #AND INSTR(TLF01,'-')=0 ",
 " AND to_char(tlf06,'yyyyMM')=TO_CHAR(to_date('",tm.yy,"'||'",tm.mm,"','yyyyMM'),'yyyyMM') ",
#" AND (TLF01||TLF62 NOT IN (SELECT SFA03||SFB01 FROM SFA_FILE,SFB_FILE WHERE SFA01=SFB01 AND SFB05=SFA03) ",
 " AND (EXISTS (select sfa03,sfb01 FROM sfa_file,sfb_file WHERE sfa03 = tlf01 AND sfb01 = tlf62 and sfa01 = sfb01 AND sfb02 IN ('1','7') AND sfb05 <> sfa03) OR ",
 "      EXISTS (select sfa03,sfb01 from sfa_file,sfb_file WHERE sfa03 = tlf01 AND sfb01 = tlf62 and sfa01 = sfb01 AND sfb02 IN ('5','8') AND (INSTR(sfa03,'-')<> 0 OR INSTR(sfa03,'.')<> 0) )) ",
 " AND NOT EXISTS( SELECT TC_JCF02 FROM TC_JCF_FILE WHERE TC_JCFACTI='Y' AND tlf902=TC_JCF02 ) ",
 "  GROUP BY tlf01 ",
 " UNION ALL ",
 " SELECT tlf01,sum(tlf10*tlf12*-TLF907) AS tlf10,'asfi52' ",
 "  FROM tlf_file",
 "  WHERE tlf907<>0 AND tlf13 LIKE 'asfi52%' ",    #AND INSTR(TLF01,'-')=0 ",
 " AND to_char(tlf06,'yyyyMM')=TO_CHAR(to_date('",tm.yy,"'||'",tm.mm,"','yyyyMM'),'yyyyMM') ",
#" AND TLF01||TLF62 NOT IN(SELECT SFA03||SFB01 FROM SFA_FILE,SFB_FILE WHERE SFA01=SFB01 AND SFB05=SFA03) ",
 " AND (EXISTS (select sfa03,sfb01 FROM sfa_file,sfb_file WHERE sfa03 = tlf01 AND sfb01 = tlf62 and sfa01 = sfb01 AND sfb02 IN ('1','7') AND sfb05 <> sfa03) OR ",
 "      EXISTS (select sfa03,sfb01 from sfa_file,sfb_file WHERE sfa03 = tlf01 AND sfb01 = tlf62 and sfa01 = sfb01 AND sfb02 IN ('5','8') AND (INSTR(sfa03,'-')<> 0 OR INSTR(sfa03,'.')<> 0) )) ",
 " AND NOT EXISTS( SELECT TC_JCF02 FROM TC_JCF_FILE WHERE TC_JCFACTI='Y' AND tlf902=TC_JCF02 ) ",
 " GROUP BY tlf01 ",
 " UNION ALL ",
 "SELECT tlf01,sum(tlf10*tlf12),'asfi51' ",
 " FROM tlf_file ",
 " WHERE tlf907<>0 AND tlf13 IN('aimt324','csft511' ) AND tlf907=1 ",
 " AND EXISTS( SELECT TC_JCF02 FROM TC_JCF_FILE WHERE TC_JCFACTI='Y' AND tlf902=TC_JCF02 ) ",
 " AND to_char(tlf06,'yyyyMM')=TO_CHAR(to_date('",tm.yy,"'||'",tm.mm,"','yyyyMM'),'yyyyMM')  AND INSTR(TLF01,'-')=0 ",
 " AND tlf902 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y') ",
 " AND EXISTS(SELECT 'A' FROM IMN_FILE ",
 " WHERE NOT EXISTS( SELECT TC_JCF02 FROM TC_JCF_FILE WHERE TC_JCFACTI='Y' AND imn04=TC_JCF02 ) ",
 " AND IMN01=TLF905 AND imn02=tlf906 ",
 " UNION ALL ",
 " SELECT 'A' FROM tc_imq_FILE ",
 " WHERE NOT EXISTS( SELECT TC_JCF02 FROM TC_JCF_FILE WHERE TC_JCFACTI='Y' AND tc_imq06=TC_JCF02 ) ",
 " AND tc_imq01=TLF905 AND tc_imq02=tlf906 ) ",
 " GROUP BY tlf01 ",
 " UNION ALL ",
 " SELECT tlf01,sum(tlf10*TLF907*tlf12),'asfi52' ",
 " FROM tlf_file ",
 " WHERE tlf907<>0 AND tlf13 IN('aimt324','csft511' ) AND tlf907=-1 ",
 " AND EXISTS( SELECT TC_JCF02 FROM TC_JCF_FILE WHERE TC_JCFACTI='Y' AND tlf902=TC_JCF02 ) ",
 " AND to_char(tlf06,'yyyyMM')=TO_CHAR(to_date('",tm.yy,"'||'",tm.mm,"','yyyyMM'),'yyyyMM') ",
 " AND tlf902 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y') ",
 " AND EXISTS(SELECT 'A' FROM IMN_FILE ",
 " WHERE NOT EXISTS( SELECT TC_JCF02 FROM TC_JCF_FILE WHERE TC_JCFACTI='Y' AND imn15=TC_JCF02 ) AND IMN01=TLF905 AND imn02=tlf906 ",
 " UNION ALL ", 
 " SELECT 'A' FROM tc_imq_FILE ",
 " WHERE NOT EXISTS( SELECT TC_JCF02 FROM TC_JCF_FILE WHERE TC_JCFACTI='Y' AND tc_imq10=TC_JCF02 ) ",
 "  AND tc_imq01=TLF905 AND tc_imq02=tlf906 ) ",
 " GROUP BY tlf01 ) a GROUP BY tlf01,lx "
 PREPARE p900_p2 FROM g_sql
 EXECUTE p900_p2

--更新工单领料数量
 UPDATE ta_ccp_file SET ta_ccc31=(SELECT SUM(tlf10) FROM gdlyb WHERE ta_ccc01=tlf01 AND lx='asfi51')
   WHERE ta_ccc01 IN(SELECT tlf01 FROM gdlyb WHERE lx='asfi51')
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm

--更新工单退料数量
 UPDATE ta_ccp_file SET ta_ccc43=(SELECT SUM(tlf10) FROM gdlyb WHERE ta_ccc01=tlf01 AND lx='asfi52')
   WHERE ta_ccc01 IN(SELECT tlf01 FROM gdlyb WHERE lx='asfi52' )
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 

#170725 luoyb str 增加返工领用数量、退料数量
DELETE FROM gdlyb
#返工线边仓领料量
LET g_sql = "INSERT INTO gdlyb ",
 "SELECT tlf01,sum(tlf10) tlf10,lx FROM ",
 "(SELECT tlf01,sum(tlf10*tlf12*-TLF907) AS tlf10,'asfi51' lx ",
 " FROM tlf_file ",
 " WHERE tlf907<>0 AND tlf13 LIKE 'asfi51%' ",    #AND INSTR(TLF01,'-')=0 ",
 " AND to_char(tlf06,'yyyyMM')=TO_CHAR(to_date('",tm.yy,"'||'",tm.mm,"','yyyyMM'),'yyyyMM') ",
 " AND (EXISTS (select sfa03,sfb01 FROM sfa_file,sfb_file WHERE sfa03 = tlf01 AND sfb01 = tlf62 and sfa01 = sfb01 AND sfb02 IN ('1','7') AND sfb05 = sfa03) OR ",
 "      EXISTS (select sfa03,sfb01 from sfa_file,sfb_file WHERE sfa03 = tlf01 AND sfb01 = tlf62 and sfa01 = sfb01 AND sfb02 IN ('5','8') AND (INSTR(sfa03,'-') = 0 AND INSTR(sfa03,'.') = 0) )) ",
 " AND EXISTS( SELECT TC_JCF02 FROM TC_JCF_FILE WHERE TC_JCFACTI='Y' AND tlf902=TC_JCF02 ) ",
 "  GROUP BY tlf01 ",
 " UNION ALL ",
 " SELECT tlf01,sum(tlf10*tlf12*-TLF907) AS tlf10,'asfi52' ",
 "  FROM tlf_file",
 "  WHERE tlf907<>0 AND tlf13 LIKE 'asfi52%' ",    #AND INSTR(TLF01,'-')=0 ",
 " AND to_char(tlf06,'yyyyMM')=TO_CHAR(to_date('",tm.yy,"'||'",tm.mm,"','yyyyMM'),'yyyyMM') ",
 " AND (EXISTS (select sfa03,sfb01 FROM sfa_file,sfb_file WHERE sfa03 = tlf01 AND sfb01 = tlf62 and sfa01 = sfb01 AND sfb02 IN ('1','7') AND sfb05 = sfa03) OR ",
 "      EXISTS (select sfa03,sfb01 from sfa_file,sfb_file WHERE sfa03 = tlf01 AND sfb01 = tlf62 and sfa01 = sfb01 AND sfb02 IN ('5','8') AND (INSTR(sfa03,'-') = 0 AND INSTR(sfa03,'.') = 0) )) ",
 " AND EXISTS( SELECT TC_JCF02 FROM TC_JCF_FILE WHERE TC_JCFACTI='Y' AND tlf902=TC_JCF02 ) ",
 " GROUP BY tlf01 ) a GROUP BY tlf01,lx "
 PREPARE p900_p2_1 FROM g_sql
 EXECUTE p900_p2_1

#一般工单领料量，应扣除返工线边仓领料量
 UPDATE ta_ccp_file SET ta_ccc31=ta_ccc31 - (SELECT SUM(tlf10) FROM gdlyb WHERE ta_ccc01=tlf01 AND lx='asfi51')
   WHERE ta_ccc01 IN(SELECT tlf01 FROM gdlyb WHERE lx='asfi51')
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 
 UPDATE ta_ccp_file SET ta_ccc43=ta_ccc43 - (SELECT SUM(tlf10) FROM gdlyb WHERE ta_ccc01=tlf01 AND lx='asfi52')
   WHERE ta_ccc01 IN(SELECT tlf01 FROM gdlyb WHERE lx='asfi52' )
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 
 
--更新工单返工领料数量 - 线边仓
 UPDATE ta_ccp_file SET ta_ccc25=(SELECT SUM(tlf10) FROM gdlyb WHERE ta_ccc01=tlf01 AND lx='asfi51')
  WHERE ta_ccc01 IN(SELECT tlf01 FROM gdlyb WHERE lx='asfi51')
    AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 

--工单返工领用需扣除退料量
 UPDATE ta_ccp_file SET ta_ccc25=ta_ccc25 + (SELECT SUM(tlf10) FROM gdlyb WHERE ta_ccc01=tlf01 AND lx='asfi52')
   WHERE ta_ccc01 IN(SELECT tlf01 FROM gdlyb WHERE lx='asfi52' )
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 

#返工非线边仓领料量
DELETE FROM gdlyb
LET g_sql = "INSERT INTO gdlyb ",
 "SELECT tlf01,sum(tlf10) tlf10,lx FROM ",
 "(SELECT tlf01,sum(tlf10*tlf12*-TLF907) AS tlf10,'asfi51' lx ",
 " FROM tlf_file ",
 " WHERE tlf907<>0 AND tlf13 LIKE 'asfi51%' ",    #AND INSTR(TLF01,'-')=0 ",
 " AND to_char(tlf06,'yyyyMM')=TO_CHAR(to_date('",tm.yy,"'||'",tm.mm,"','yyyyMM'),'yyyyMM') ",
 " AND (EXISTS (select sfa03,sfb01 FROM sfa_file,sfb_file WHERE sfa03 = tlf01 AND sfb01 = tlf62 and sfa01 = sfb01 AND sfb02 IN ('1','7') AND sfb05 = sfa03) OR ",
 "      EXISTS (select sfa03,sfb01 from sfa_file,sfb_file WHERE sfa03 = tlf01 AND sfb01 = tlf62 and sfa01 = sfb01 AND sfb02 IN ('5','8') AND (INSTR(sfa03,'-') = 0 AND INSTR(sfa03,'.') = 0) )) ",
 " AND NOT EXISTS( SELECT TC_JCF02 FROM TC_JCF_FILE WHERE TC_JCFACTI='Y' AND tlf902=TC_JCF02 ) ",
 "  GROUP BY tlf01 ",
 " UNION ALL ",
 " SELECT tlf01,sum(tlf10*tlf12*-TLF907) AS tlf10,'asfi52' ",
 "  FROM tlf_file",
 "  WHERE tlf907<>0 AND tlf13 LIKE 'asfi52%' ",    #AND INSTR(TLF01,'-')=0 ",
 " AND to_char(tlf06,'yyyyMM')=TO_CHAR(to_date('",tm.yy,"'||'",tm.mm,"','yyyyMM'),'yyyyMM') ",
 " AND (EXISTS (select sfa03,sfb01 FROM sfa_file,sfb_file WHERE sfa03 = tlf01 AND sfb01 = tlf62 and sfa01 = sfb01 AND sfb02 IN ('1','7') AND sfb05 = sfa03) OR ",
 "      EXISTS (select sfa03,sfb01 from sfa_file,sfb_file WHERE sfa03 = tlf01 AND sfb01 = tlf62 and sfa01 = sfb01 AND sfb02 IN ('5','8') AND (INSTR(sfa03,'-') = 0 AND INSTR(sfa03,'.') = 0) )) ",
 " AND NOT EXISTS( SELECT TC_JCF02 FROM TC_JCF_FILE WHERE TC_JCFACTI='Y' AND tlf902=TC_JCF02 ) ",
 " GROUP BY tlf01 ) a GROUP BY tlf01,lx "
 PREPARE p900_p2_2 FROM g_sql
 EXECUTE p900_p2_2

--更新工单返工领料数量 - 非线边仓
 UPDATE ta_ccp_file SET ta_ccc25=ta_ccc25 + (SELECT SUM(tlf10) FROM gdlyb WHERE ta_ccc01=tlf01 AND lx='asfi51')
  WHERE ta_ccc01 IN(SELECT tlf01 FROM gdlyb WHERE lx='asfi51')
    AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 

--工单返工领用需扣除退料量
 UPDATE ta_ccp_file SET ta_ccc25=ta_ccc25 + (SELECT SUM(tlf10) FROM gdlyb WHERE ta_ccc01=tlf01 AND lx='asfi52')
   WHERE ta_ccc01 IN(SELECT tlf01 FROM gdlyb WHERE lx='asfi52' )
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 
#170725 luoyb end
END FUNCTION

FUNCTION p900_p_9()  #期末结存

  DELETE FROM ta_imk_file WHERE ta_imk05=tm.yy AND ta_imk06=tm.mm

LET g_sql = "INSERT INTO ta_imk_file ",
   "SELECT IMK01,'",tm.yy,"','",tm.mm,"',SUM(IMK081) IMK081,SUM(IMK082) IMK082,SUM(IMK083) IMK083,SUM(IMK084) IMK084,SUM(IMK085) IMK085,0,0,0,imk089,SUM(IMK09) IMK09,0 FROM ",
   "( ",
   "SELECT IMK01,SUM(IMK081) IMK081,SUM(IMK082) IMK082,SUM(IMK083) IMK083,SUM(IMK084) IMK084,SUM(IMK085) IMK085,'kc' imk089, ",
   " SUM(IMK09) IMK09 FROM imk_file WHERE NOT EXISTS( SELECT TC_JCF02 FROM TC_JCF_FILE WHERE TC_JCFACTI='Y' AND IMK02=TC_JCF02 ) ",
   " AND IMK05='",tm.yy,"' AND IMK06='",tm.mm,"' AND INSTR(IMK01,'-')=0 AND IMK02 NOT IN (SELECT jce02 FROM jce_file) ",
   " AND imk09<>0 ",
   " GROUP BY IMK01 ",
   " UNION ALL ",
   " SELECT ex_imk01,0,0,0,0,0,'zz',sum(ex_imk09) FROM ex_imk_file",
   " WHERE ex_imk05='",tm.yy,"' AND ex_imk06='",tm.mm,"' GROUP BY ex_imk01 ",
   " ) a GROUP BY IMK01,imk089 "
PREPARE p900_p3 FROM g_sql
EXECUTE p900_p3

  UPDATE ta_ccp_file SET ta_ccc91=(SELECT ta_imk09 FROM ta_imk_file WHERE ta_ccc01=ta_imk01 AND ta_ccc02=ta_imk05 AND ta_ccc03=ta_imk06
 AND ta_imk089='kc')
 WHERE ta_ccc01 IN(SELECT ta_imk01 FROM ta_imk_file WHERE ta_imk05=tm.yy AND ta_imk06=tm.mm AND ta_imk089='kc')
 AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm

 UPDATE ta_ccp_file SET ta_ccc98=(SELECT ta_imk09 FROM ta_imk_file WHERE ta_ccc01=ta_imk01 AND ta_ccc02=ta_imk05 AND ta_ccc03=ta_imk06
 AND ta_imk089='zz')
 WHERE ta_ccc01 IN(SELECT ta_imk01 FROM ta_imk_file WHERE ta_imk05=tm.yy AND ta_imk06=tm.mm AND ta_imk089='zz')
 AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm

  UPDATE ta_ccp_file SET ta_ccc23=ROUND((CASE WHEN ta_ccc11+ta_ccc211+ta_ccc214=0 THEN 0 ELSE (ta_ccc12+ta_ccc22a1+ta_ccc22a4)/(ta_ccc11+ta_ccc211+ta_ccc214) END),6)
                        ,ta_ccc23a=ROUND((CASE WHEN ta_ccc11+ta_ccc211+ta_ccc214=0 THEN 0 ELSE (ta_ccc12+ta_ccc22a1+ta_ccc22a4)/(ta_ccc11+ta_ccc211+ta_ccc214) END),6)
    WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm 
    AND ((ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc214+ta_ccc215+ta_ccc216)>0 OR ta_ccc217<>0 OR ta_ccc18<>0 OR ta_ccc31<>0 OR ta_ccc25 <> 0 OR ta_ccc81<>0 OR ta_ccc98<>0)   #170725 ccc25
    AND instr(ta_ccc01,'.')>1

END FUNCTION

FUNCTION p900_p_10() #期初与当月转到WIP 的加权平均单价

  UPDATE ta_ccp_file SET TA_CCCUD07=(ROUND(CASE WHEN nvl(ta_ccc18+ta_ccc31+ta_ccc25-ta_ccc27,0)=0 THEN 0
 ELSE (ta_ccc19+ta_ccc31*ta_ccc23+(ta_ccc25-ta_ccc27)*ta_ccc23)/nvl(ta_ccc18+ta_ccc31+ta_ccc25-ta_ccc27,0) END,8) )
   WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm AND instr(ta_ccc01,'.')>0

UPDATE ta_ccp_file SET TA_CCCUD07=ta_ccc23
   WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm AND instr(ta_ccc01,'.')>0
   AND TA_CCCUD07=0 AND ( ta_ccc18<>0 OR ta_ccc31<>0 OR ta_ccc25 <> 0 OR ta_ccc27 <> 0 OR ta_ccc217<>0  OR ta_ccc98<>0 OR ta_ccc81<>0
   OR ta_ccc61<>0 OR ta_ccc43<>0 OR ta_ccc41<>0)

END FUNCTION

FUNCTION p900_p_11() #更新销货成本

    UPDATE ta_ccp_file SET ta_ccc26= CASE WHEN ta_ccc11+ta_ccc211+ta_ccc214-ta_ccc43<>0 THEN ROUND(((-ta_ccc43*ta_cccud07+ta_ccc22a1+ta_ccc12+ta_ccc22a4)/(ta_ccc11+ta_ccc211-ta_ccc43+ta_ccc214) ),6) ELSE 0 END
    WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
    AND ((ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc214+ta_ccc215+ta_ccc216)>0 OR ta_ccc217<>0 OR ta_ccc18<>0 OR ta_ccc31<>0 OR ta_ccc81<>0 OR ta_ccc98<>0 OR ta_ccc43<>0)
    AND instr(ta_ccc01,'.')>1 
    UPDATE ta_ccp_file SET ta_ccc26a= CASE WHEN ta_ccc11+ta_ccc211+ta_ccc214-ta_ccc43<>0 THEN ROUND(((-ta_ccc43*ta_cccud07+ta_ccc22a1+ta_ccc12+ta_ccc22a4)/(ta_ccc11+ta_ccc211-ta_ccc43+ta_ccc214) ),6) ELSE 0 END
    WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
    AND ((ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc214+ta_ccc215+ta_ccc216)>0 OR ta_ccc217<>0 OR ta_ccc18<>0 OR ta_ccc31<>0 OR ta_ccc81<>0 OR ta_ccc98<>0 OR ta_ccc43<>0)
    AND instr(ta_ccc01,'.')>1 

END FUNCTION

FUNCTION p900_p_12() #更新材料利用率/实际用量
  DEFINE ta_cccbzxh1    LIKE type_file.num20_6
  DEFINE ta_cccbzxh2    LIKE type_file.num20_6
  DEFINE ta_cccbzxh3    LIKE type_file.num20_6
  DEFINE l_date         LIKE type_file.dat
  
--更新材料利用率 
  UPDATE ta_ccp_file
     SET TA_CCCUD12=(SELECT CASE WHEN NVL(BZXH,0)+NVL(BZXH1,0)=0 THEN 0 ELSE ROUND(nvl(b.ta_ccc18+b.ta_ccc217+b.ta_ccc31+b.ta_ccc25+b.ta_ccc43+b.TA_CCC81-b.ta_ccc98,0)/(NVL(BZXH,0)+NVL(BZXH1,0)),10)*-1 END   #170725 ccc25
                       FROM ima_file,ta_ccp_file b LEFT JOIN (SELECT CCH04,SUM(BZXH) BZXH FROM ex_ccg_result
                                                               WHERE yym=tm.yy AND mmy=tm.mm AND INSTR(cch04,'.')>0 AND SUBSTR(cch04,1,1)<>'K' GROUP BY CCH04) HYB ON b.ta_ccc01=HYB.cch04
                                                   LEFT JOIN (SELECT YJLH,SUM(BZXH*LJYL) BZXH1 FROM ex_ccg_WGD,EX_BOM_CP
                                                               WHERE CCH04=CPLH AND yym=tm.yy AND mmy=tm.mm
                                                                 AND ex_bom_cp.yy = tm.yy AND ex_bom_cp.mm = tm.mm
                                                                 AND to_char(sxrq1,'yyyyMM')<=TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
                                                                 AND nvl(to_char(sxrq2,'yyyyMM'),TO_CHAR(SYSDATE+1,'yyyyMM')) >TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
                                                                 AND INSTR(YJLH,'.')>1 GROUP BY YJLH) HYC ON b.ta_ccc01=HYC.YJLH
                      WHERE ta_ccc01=ima01 AND INSTR(ta_ccc01,'.')>0 AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm
                        AND b.ta_ccc01=ta_ccp_file.ta_ccc01
                        AND (ta_ccc217<>0 OR ta_ccc18<>0 OR ta_ccc31<>0 OR ta_ccc25 <> 0 OR ta_ccc81<>0 OR ta_ccc98<>0))   #170725 ccc25
   WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm AND (ta_ccc217<>0 OR ta_ccc18<>0 OR ta_ccc31<>0 OR ta_ccc25 <> 0 OR ta_ccc81<>0 OR ta_ccc98<>0)  #170725 ccc25
     AND INSTR(ta_ccc01,'.')>0

--插入生产材料消耗明细
DELETE FROM ta_ccq_file WHERE TA_CCQ02=tm.yy AND TA_CCQ03=tm.mm

LET g_sql = "INSERT INTO ta_ccq_file ",
            " SELECT ccg04 ,'",tm.yy,"','",tm.mm,"',ta_ccc213,cch04 ,TDF ,cch31 ,nvl(bzxh,0) ,cch31j ,cch31j ,0,0,0,0,0,bzxhj,bzxhj,0,0,0,0,0,a.TA_CCCUD12 ,a.TA_CCCUD07 ,a.TA_CCCUD07 ,0,0,0,0,0,0,0,0 ", 
            "   FROM (SELECT ccg04,cch04,SUM(cch31) cch31,SUM(cch31j) cch31j,SUM(bzxh) bzxh,SUM(bzxhj) bzxhj,TDF,TA_CCCUD07,TA_CCCUD12 ", 
            "           FROM (SELECT ccg04,cch04,cch31*-1 cch31,cch31*-1*TA_CCCUD07 cch31j,bzxh*-1 bzxh,bzxh*-1*TA_CCCUD07 bzxhj,'N' TDF,TA_CCCUD07,TA_CCCUD12 FROM ex_ccg_result,ta_ccp_file ",
            "          WHERE yym='",tm.yy,"' AND mmy='",tm.mm,"' AND cch04=ta_ccc01(+) AND ta_ccc02(+)='",tm.yy,"' AND ta_ccc03(+)='",tm.mm,"' ",
            "            AND SUBSTR(cch04,1,1)<>'K' AND INSTR(cch04,'.')>0 ",
            "            AND (ta_ccc217<>0 OR ta_ccc18<>0 OR ta_ccc31<>0 OR ta_ccc25 <> 0 OR ta_ccc81<>0 OR ta_ccc98<>0) ",  #170725 ccc25
            "  UNION ALL ",
            " SELECT ccg04,YJLH,cch31*LJYL*-1,cch31*LJYL*-1*TA_CCCUD07,-1*BZXH*LJYL,-1*BZXH*LJYL*TA_CCCUD07,'N' TDF,TA_CCCUD07,TA_CCCUD12 FROM ex_ccg_WGD,EX_BOM_CP ,ta_ccp_file ",
            "  WHERE CCH04=CPLH AND yym='",tm.yy,"' AND mmy='",tm.mm,"' AND yjlh=ta_ccc01 AND ta_ccc02='",tm.yy,"' AND ta_ccc03='",tm.mm,"' ",
            "    AND ex_bom_cp.yy = ",tm.yy," AND ex_bom_cp.mm = ",tm.mm," ",
            "    AND (ta_ccc217<>0 OR ta_ccc18<>0 OR ta_ccc31<>0 OR ta_ccc25 <> 0 OR ta_ccc81<>0 OR ta_ccc98<>0) ",   #170725 ccc25
            "    AND to_char(sxrq1,'yyyyMM')<=TO_CHAR(to_date('",tm.yy,"'||'",tm.mm,"','yyyyMM'),'yyyyMM') AND INSTR(YJLH,'.')>1 ",
            "    AND nvl(to_char(sxrq2,'yyyyMM'),TO_CHAR(SYSDATE+1,'yyyyMM')) >TO_CHAR(to_date('",tm.yy,"'||'",tm.mm,"','yyyyMM'),'yyyyMM') ",
            " ) a GROUP BY ccg04,cch04,TDF,TA_CCCUD07,TA_CCCUD12 ) A,ta_ccp_file b ",
            " WHERE a.ccg04=b.ta_ccc01 AND ta_ccc02='",tm.yy,"' AND ta_ccc03='",tm.mm,"' "
PREPARE p900_p4 FROM g_sql
EXECUTE p900_p4

--更新实际用量
#实际用量差异摊销
UPDATE ta_ccq_file SET ta_ccq11=ta_ccq18*ta_ccq20,ta_ccq12=ta_ccq18*ta_ccq20*ta_ccq21
,ta_ccq12a=ta_ccq18*ta_ccq20*ta_ccq21a,ta_ccq12b=ta_ccq18*ta_ccq20*ta_ccq21b,ta_ccq12c=ta_ccq18*ta_ccq20*ta_ccq21c,ta_ccq12d=ta_ccq18*ta_ccq20*ta_ccq21d
WHERE ta_ccq02=tm.yy AND ta_ccq03=tm.mm
AND instr(ta_ccq05,'.')>0

LET ta_cccbzxh1 = 0
LET ta_cccbzxh2 = 0
LET ta_cccbzxh3 = 0

#有差异的金额
SELECT ROUND(SUM(ta_ccc12+ta_ccc22a1-(ta_ccc31+ta_ccc25)*ta_ccc23   #170725 ccc25
  -ta_ccc41*-1*ta_ccc23+ta_ccc22a4-ta_ccc61*-1*ta_ccc26a-(ta_ccc43)*ta_cccud07-ta_ccc91*ta_ccc26a),6)
  INTO ta_cccbzxh1
  FROM ta_ccp_file,ima_file WHERE 
  ta_ccc01=ima01 AND INSTR(ta_ccc01,'.')>1 AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm
AND ((ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc214+ta_ccc215+ta_ccc216+ta_ccc11)<>0
OR ta_ccc31<>0 OR ta_ccc25 <> 0 OR ta_ccc41<>0 OR ta_ccc43<>0 OR ta_ccc61<>0 OR ta_ccc91<>0)  #170725 ccc25

 LET l_date = TODAY + 1
 LET g_sql = " SELECT round(sum(ta_ccc19+nvl(ta_ccc217+ta_ccc43+ta_ccc81-ta_ccc98,0)*ta_cccud07+(ta_ccc31+ta_ccc25)*ta_ccc23),6) ",  #170725 ccc25
             "   FROM ta_ccp_file,ima_file,(SELECT CCH04,SUM(bzxh) bzxh FROM ex_ccg_result ",
             "                               WHERE yym=",tm.yy," AND mmy=",tm.mm," AND INSTR(cch04,'.')>0 AND SUBSTR(cch04,1,1)<>'K' GROUP BY cch04) hyb, ",
             "                             (SELECT yjlh,SUM(bzxh*ljyl) bzxh1 FROM ex_ccg_wgd,ex_bom_cp ",
             "                               WHERE cch04=cplh AND yym=",tm.yy," AND mmy=",tm.mm, 
             "                                 AND ex_bom_cp.yy = ",tm.yy," AND ex_bom_cp.mm = ",tm.mm," ", 
        #     "                                 AND sxrq1 between '",b_date,"' and '",e_date,"' ",
             "                                 AND ((sxrq2 IS NULL AND '",l_date,"' > '",e_date,"') OR ",
             "                                      (sxrq2 IS NOT NULL AND sxrq2 > '",e_date,"')) ",                                  
             "                                 AND INSTR(yjlh,'.')>1 GROUP BY yjlh ) hyc ",
             " WHERE ta_ccc01=ima01 AND INSTR(ta_ccc01,'.')>0  AND ta_ccc01=hyb.cch04(+) AND ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm," ",
             "   AND ta_ccc01=hyc.yjlh(+) AND round(NVL(bzxh,0)+NVL(bzxh1,0),8)*-1=0 ",
             "   AND (ta_ccc217<>0 OR ta_ccc18<>0 OR ta_ccc31<>0 OR ta_ccc25 <> 0 OR ta_ccc81<>0 OR ta_ccc98<>0 OR ta_ccc43<>0) "  #170725 ta_ccc25
PREPARE p900_p5 FROM g_sql
EXECUTE p900_p5 INTO ta_cccbzxh2

SELECT SUM(TA_CCQ12) INTO ta_cccbzxh3 FROM ta_ccq_file,IMA_FILE
WHERE TA_CCQ01=IMA01 AND TA_CCQ02=tm.yy AND TA_CCQ03=tm.mm
AND IMA06 IN('G01','G02') AND instr(ta_ccq05,'.')>0

UPDATE ta_ccQ_file SET ta_ccQ12f=ta_ccQ12*((ta_cccbzxh1+ta_cccbzxh2)/ta_cccbzxh3)
WHERE  ta_ccQ02=tm.yy AND ta_ccQ03=tm.mm
AND instr(ta_ccq05,'.')>0
AND ta_ccq01 IN(SELECT ima01 FROM ima_file WHERE IMA06 IN('G01','G02'))

--更新材料耗用到成本表
UPDATE ta_ccp_file SET ta_ccc22a3=(SELECT SUM(ta_ccq12a+ta_ccq12f) FROM ta_ccq_file
WHERE ta_ccq01=ta_ccc01 AND ta_ccQ02=tm.yy AND ta_ccQ03=tm.mm)
WHERE ta_ccc01 IN (SELECT ta_ccq01 FROM ta_ccq_file WHERE ta_ccQ02=tm.yy AND ta_ccQ03=tm.mm )
END FUNCTION

FUNCTION p900_p_13() #更新库存杂项异动入库材料、人工、制费金额
  --更新库存杂项异动入库材料金额
 UPDATE ta_ccp_file SET ta_ccc22a4=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc213=0 
 THEN 0 ELSE (ta_ccc214*(ta_ccc12a+ta_ccc22a1+ta_ccc22a3)/(ta_ccc11+ta_ccc211+ta_ccc213) ) END)
   WHERE ta_ccc214>0 AND ta_ccc22a4=0
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 
   
 UPDATE ta_ccp_file SET ta_ccc22a4=(SELECT SUM(inb09*inb132)
  FROM ina_file,inb_file WHERE ina01=inb01 
  AND to_char(ina02,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND inb05 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND inb05 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=inb04
  AND inapost='Y' AND INACONF='Y' AND ina00='3' )
   WHERE ta_ccc01 IN(SELECT inb04
  FROM ina_file,inb_file WHERE ina01=inb01 
  AND to_char(ina02,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND inb05 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND inb05 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=inb04
  AND inapost='Y' AND INACONF='Y' AND ina00='3') AND ta_ccc22a4=0
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 

  LET g_sql = "UPDATE ta_ccp_file SET ta_ccc22b4=(ta_ccc214*NVL((SELECT CCC23a from ",
              " (select ccc01,ccc02||ccc03,ccc23a,row_number()over(partition by ccc01 order by to_char(to_date(ccc02||ccc03,'yyyyMM'),'yyyyMM') desc) mm from ccc_file ",
              "   WHERE to_date(ccc02||ccc03,'yyyyMM')<=to_date(",tm.yy,"||",tm.mm,",'yyyyMM') AND ccc23<>0) where mm=1  AND ta_ccc01=ccc01),0) ) ",
              "   WHERE ta_ccc214>0 AND ta_ccc22a4=0 ",
              "     AND ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm," "
  PREPARE p900_p6 FROM g_sql
  EXECUTE p900_p6
   
--更新库存杂项异动入库人工金额
 UPDATE ta_ccp_file SET ta_ccc22b4=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc213=0 
 THEN 0 ELSE (ta_ccc214*(ta_ccc12b+ta_ccc22b1+ta_ccc22b3)/(ta_ccc11+ta_ccc211+ta_ccc213) ) END)
   WHERE ta_ccc214>0 AND ta_ccc22b4=0
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 
   
 UPDATE ta_ccp_file SET ta_ccc22b4=(SELECT SUM(inb09*inb132)
  FROM ina_file,inb_file WHERE ina01=inb01 
  AND to_char(ina02,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND inb05 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND inb05 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=inb04
  AND inapost='Y' AND INACONF='Y' AND ina00='3' )
   WHERE ta_ccc01 IN(SELECT inb04
  FROM ina_file,inb_file WHERE ina01=inb01 
  AND to_char(ina02,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND inb05 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND inb05 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=inb04
  AND inapost='Y' AND INACONF='Y' AND ina00='3') AND ta_ccc22b4=0
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 

  LET g_sql = " UPDATE ta_ccp_file SET ta_ccc22b4=(ta_ccc214*NVL((SELECT CCC23b from ",
              " (select ccc01,ccc02||ccc03,ccc23b,row_number()over(partition by ccc01 order by to_char(to_date(ccc02||ccc03,'yyyyMM'),'yyyyMM') desc) mm from ccc_file ",
              "   WHERE to_date(ccc02||ccc03,'yyyyMM')<=to_date(",tm.yy,"||",tm.mm,",'yyyyMM') AND ccc23<>0) where mm=1  AND ta_ccc01=ccc01),0) ) ",
              "   WHERE ta_ccc214>0 AND ta_ccc22a4=0 ",
              "     AND ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm," " 
  PREPARE p900_p7 FROM g_sql
  EXECUTE p900_p7
  
--更新库存杂项异动入库制费金额
 UPDATE ta_ccp_file SET ta_ccc22c4=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc213=0 
 THEN 0 ELSE (ta_ccc214*(ta_ccc12c+ta_ccc22c1+ta_ccc22c3)/(ta_ccc11+ta_ccc211+ta_ccc213) ) END )
   WHERE ta_ccc214>0 AND ta_ccc22c4=0
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 
   
 UPDATE ta_ccp_file SET ta_ccc22c4=(SELECT SUM(inb09*inb133)
  FROM ina_file,inb_file WHERE ina01=inb01 
  AND to_char(ina02,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND inb05 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND inb05 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=inb04
  AND inapost='Y' AND INACONF='Y' AND ina00='3' )
   WHERE ta_ccc01 IN(SELECT inb04
  FROM ina_file,inb_file WHERE ina01=inb01 
  AND to_char(ina02,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND inb05 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND inb05 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=inb04
  AND inapost='Y' AND INACONF='Y' AND ina00='3') AND ta_ccc22c4=0
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 

  LET g_sql = "UPDATE ta_ccp_file SET ta_ccc22c4=(ta_ccc214*NVL((SELECT CCC23c from ",
              " (select ccc01,ccc02||ccc03,ccc23c,row_number()over(partition by ccc01 order by to_char(to_date(ccc02||ccc03,'yyyyMM'),'yyyyMM') desc) mm from ccc_file ",
              "   WHERE to_date(ccc02||ccc03,'yyyyMM')<=to_date(",tm.yy,"||",tm.mm,",'yyyyMM') AND ccc23<>0) where mm=1  AND ta_ccc01=ccc01),0) ) ",
              "   WHERE ta_ccc214>0 AND ta_ccc22a4=0 ",
              "     AND ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm
  PREPARE p900_p8 FROM g_sql
  EXECUTE p900_p8
   
--更新库存杂项异动入库加工金额
 UPDATE ta_ccp_file SET ta_ccc22d4=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc213=0 
 THEN 0 ELSE (ta_ccc214*(ta_ccc12d+ta_ccc22d1+ta_ccc22d3)/(ta_ccc11+ta_ccc211+ta_ccc213) ) END )
   WHERE ta_ccc214>0 AND ta_ccc22d4=0
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 
   
 UPDATE ta_ccp_file SET ta_ccc22d4=(SELECT SUM(inb09*inb134)
  FROM ina_file,inb_file WHERE ina01=inb01 
  AND to_char(ina02,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND inb05 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND inb05 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=inb04
  AND inapost='Y' AND INACONF='Y' AND ina00='3' )
   WHERE ta_ccc01 IN(SELECT inb04
  FROM ina_file,inb_file WHERE ina01=inb01 
  AND to_char(ina02,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND inb05 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND inb05 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=inb04
  AND inapost='Y' AND INACONF='Y' AND ina00='3') AND ta_ccc22d4=0
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm 

  LET g_sql = " UPDATE ta_ccp_file SET ta_ccc22d4=(ta_ccc214*NVL((SELECT CCC23d from ",
              " (select ccc01,ccc02||ccc03,ccc23d,row_number()over(partition by ccc01 order by to_char(to_date(ccc02||ccc03,'yyyyMM'),'yyyyMM') desc) mm from ccc_file ",
              "   WHERE to_date(ccc02||ccc03,'yyyyMM')<=to_date(",tm.yy,"||",tm.mm,",'yyyyMM') AND ccc23<>0) where mm=1  AND ta_ccc01=ccc01),0) ) ",
              "   WHERE ta_ccc214>0 AND ta_ccc22d4=0 ",
              "     AND ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm 
  PREPARE p900_p9 FROM g_sql
  EXECUTE p900_p9
END FUNCTION

FUNCTION p900_p_14() #加权单价计算

  UPDATE ta_ccp_file SET
TA_CCC23A=ROUND((CASE WHEN ta_ccc11+ta_ccc211+ta_ccc213+ta_ccc214<>0 THEN (ta_ccc12a+ta_ccc22a1+ta_ccc22a3+ta_ccc22a4
)/(ta_ccc11+ta_ccc211+ta_ccc213+ta_ccc214) ELSE 0 END),6),
TA_CCC23B=ROUND((CASE WHEN ta_ccc11+ta_ccc211+ta_ccc213+ta_ccc214<>0 THEN (ta_ccc12b+ta_ccc22b1+ta_ccc22b3+ta_ccc22b4
)/(ta_ccc11+ta_ccc211+ta_ccc213+ta_ccc214) ELSE 0 END),6),
TA_CCC23C=ROUND((CASE WHEN ta_ccc11+ta_ccc211+ta_ccc213+ta_ccc214<>0 THEN (ta_ccc12C+ta_ccc22C1+ta_ccc22C3+ta_ccc22C4
)/(ta_ccc11+ta_ccc211+ta_ccc213+ta_ccc214) ELSE 0 END),6),
TA_CCC23D=ROUND((CASE WHEN ta_ccc11+ta_ccc211+ta_ccc213+ta_ccc214<>0 THEN (ta_ccc12D+ta_ccc22D1+ta_ccc22d3+ta_ccc22D4
)/(ta_ccc11+ta_ccc211+ta_ccc213+ta_ccc214) ELSE 0 END),6),
TA_CCC23E=0,
TA_CCC23F=0
WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
AND (ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc214<>0 )
AND INSTR(TA_CCC01,'.')=0

UPDATE  ta_ccp_file SET TA_CCC23=TA_CCC23A+TA_CCC23B+TA_CCC23C+TA_CCC23D
WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
AND INSTR(TA_CCC01,'.')=0


UPDATE  ta_ccp_file SET TA_CCC23=(CASE WHEN ta_ccc18<>0  THEN ta_ccc19/ta_ccc18 ELSE 0 END),
TA_CCC23a=(CASE WHEN ta_ccc18<>0  THEN ta_ccc19a/ta_ccc18 ELSE 0 END),
TA_CCC23b=(CASE WHEN ta_ccc18<>0  THEN ta_ccc19b/ta_ccc18 ELSE 0 END),
TA_CCC23c=(CASE WHEN ta_ccc18<>0  THEN ta_ccc19c/ta_ccc18 ELSE 0 END),
TA_CCC23d=(CASE WHEN ta_ccc18<>0  THEN ta_ccc19d/ta_ccc18 ELSE 0 END)
WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm  AND INSTR(TA_CCC01,'.')=0 AND ta_ccc23=0

END FUNCTION

FUNCTION p900_p_15() #返工计算
DEFINE ta_cccbzxh1    LIKE type_file.num20_6
DEFINE ta_cccbzxh2    LIKE type_file.num20_6
DEFINE ta_cccbzxh3    LIKE type_file.num20_6
DEFINE ta_cccbzxh4    LIKE type_file.num20_6
DEFINE ta_cccbzxh5    LIKE type_file.num20_6
DEFINE ta_cccbzxh6    LIKE type_file.num20_6

DEFINE ta_cccbzxh11    LIKE type_file.num20_6
DEFINE ta_cccbzxh12    LIKE type_file.num20_6
DEFINE ta_cccbzxh13    LIKE type_file.num20_6
DEFINE ta_cccbzxh14    LIKE type_file.num20_6
DEFINE ta_cccbzxh15    LIKE type_file.num20_6
DEFINE ta_cccbzxh16    LIKE type_file.num20_6
DEFINE l_ta_ccq01      LIKE ima_file.ima01

DEFINE l_ta_ccq22    LIKE type_file.num20_6
DEFINE l_ta_ccq22a    LIKE type_file.num20_6
DEFINE l_ta_ccq22b    LIKE type_file.num20_6
DEFINE l_ta_ccq22c    LIKE type_file.num20_6
DEFINE l_ta_ccq22d    LIKE type_file.num20_6

DEFINE l_cnt          LIKE type_file.num5
DEFINE l_ta_ccc01     LIKE ima_file.ima01
DEFINE l_ta_cccud12   LIKE type_file.num20_6
DEFINE l_bzxh,l_tot         LIKE type_file.num20_6

---处理返工造成的成本变动

--该处是否适合单据
--期初与当月转到WIP 的加权平均单价

--期初与当月转到WIP 的加权平均单价
UPDATE ta_ccp_file SET TA_CCCUD07=(ROUND(CASE WHEN nvl(ta_ccc18+ta_ccc31+ta_ccc25-ta_ccc27,0)=0 THEN 0
 ELSE (ta_ccc19a+ta_ccc31*ta_ccc23a+(ta_ccc25-ta_ccc27)*ta_ccc23a)/nvl(ta_ccc18+ta_ccc31+ta_ccc25-ta_ccc27,0) END,8) )
   ,TA_CCCUD08=(ROUND(CASE WHEN nvl(ta_ccc18+ta_ccc31+ta_ccc25-ta_ccc27,0)=0 THEN 0
 ELSE (ta_ccc19b+ta_ccc31*ta_ccc23b+(ta_ccc25-ta_ccc27)*ta_ccc23b)/nvl(ta_ccc18+ta_ccc31+ta_ccc25-ta_ccc27,0) END,8) )
   ,TA_CCCUD09=(ROUND(CASE WHEN nvl(ta_ccc18+ta_ccc31+TA_CCC81+ta_ccc25-ta_ccc27,0)=0 THEN 0
 ELSE (ta_ccc19c+ta_ccc31*ta_ccc23c+ta_ccc31*ta_ccc23e+(ta_ccc25-ta_ccc27)*(ta_ccc23c+ta_ccc23e))/nvl(ta_ccc18+ta_ccc31+TA_CCC81+ta_ccc25-ta_ccc27,0) END,8) )
   ,TA_CCCUD10=(ROUND(CASE WHEN nvl(ta_ccc18+ta_ccc31+TA_CCC81+ta_ccc25-ta_ccc27,0)=0 THEN 0
 ELSE (ta_ccc19d+ta_ccc31*ta_ccc23d+(ta_ccc25-ta_ccc27)*ta_ccc23d)/nvl(ta_ccc18+ta_ccc31+TA_CCC81+ta_ccc25-ta_ccc27,0) END,8) )
   WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm AND instr(ta_ccc01,'.')=0 AND instr(ta_ccc01,'-')=0 

--更新半成品损耗率
  LET l_cnt = 0
  LET g_sql = "SELECT ta_ccc01,NVL(ta_ccc18,0)+NVL(ta_ccc217,0)+NVL(ta_ccc31,0)+NVL(ta_ccc25,0)+NVL(ta_ccc43,0)+NVL(ta_ccc81,0)-NVL(ta_ccc98,0) FROM ta_ccp_file ",  #170725 ccc25
              " WHERE ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm," AND substr(ta_ccc01,7,1) IN('A','F','R','G') ",
              "   AND INSTR(ta_ccc01,'.')=0 AND INSTR(ta_ccc01,'-')=0 ",
              "   AND (ta_ccc217+ta_ccc18+ta_ccc31+ta_ccc25)<>0 "   #170725 ccc25

  PREPARE p900_p_ta_cccud12 FROM g_sql
  DECLARE p900_c_ta_cccud12 CURSOR FOR p900_p_ta_cccud12
  FOREACH p900_c_ta_cccud12 INTO l_ta_ccc01,l_tot

    LET l_bzxh = 0
    SELECT SUM(-1*bzxh) INTO l_bzxh FROM ex_ccg_result
     WHERE yym=tm.yy AND mmy=tm.mm
       AND cch04 = l_ta_ccc01
    IF cl_null(l_bzxh) THEN LET l_bzxh = 0 END IF 
    IF l_bzxh = 0 THEN 
       LET l_ta_cccud12 = 0
    ELSE
       LET l_ta_cccud12 = l_tot/l_bzxh
    END IF 
   
    UPDATE ta_ccp_file SET ta_cccud12 = l_ta_cccud12
     WHERE ta_ccc01 = l_ta_ccc01
       AND ta_ccc02 = tm.yy
       AND ta_ccc03 = tm.mm
     
    LET l_cnt = l_cnt + 1
  END FOREACH
 
--插入半成品消耗记录
    LET g_sql = "INSERT INTO ta_ccq_file
    SELECT ccg04,",tm.yy,",",tm.mm,",ta_ccc213,cch04,'N' TDF,
           SUM(cch31) cch31,SUM(bzxh) bzxh,SUM(cch31j) cch31j,SUM(cch31ja) cch31ja
          ,SUM(cch31jb) cch31jb,SUM(cch31jc) cch31jc,SUM(cch31jd) cch31jd,0,0
          ,SUM(bzxhj) bzxhj,SUM(bzxhja) bzxhja,SUM(bzxhjb) bzxhjb,SUM(bzxhjc) bzxhjc,SUM(bzxhjd) bzxhjd
          ,0,0,a.ta_cccud12,a.ta_ccc23,a.ta_ccc23a,a.ta_ccc23b,a.ta_ccc23c,a.ta_ccc23d,0,0,0,0,0 FROM
   (SELECT ccg04,cch04,bzxh*ta_cccud12*-1 cch31,
           CASE WHEN nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) = 0 THEN 0 ELSE bzxh*ta_cccud12*-1*(ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)+(ta_ccc31+ta_ccc25)*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d)-ta_ccc27*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d))/
 nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) END cch31j,
 CASE WHEN nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) = 0 THEN 0 ELSE bzxh*ta_cccud12*-1*(ta_ccc19a+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud07)+(ta_ccc31+ta_ccc25)*ta_ccc23a-ta_ccc27*ta_ccc23a)/
 nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) END cch31ja,
 CASE WHEN (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) = 0 THEN 0 ELSE bzxh*ta_cccud12*-1*(ta_ccc19b+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud08)+(ta_ccc31+ta_ccc25)*ta_ccc23b-ta_ccc27*ta_ccc23b)/
 (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END cch31jb,
 CASE WHEN (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) = 0 THEN 0 ELSE bzxh*ta_cccud12*-1*(ta_ccc19c+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud09)+(ta_ccc31+ta_ccc25)*ta_ccc23c-ta_ccc27*ta_ccc23c)/
 (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END cch31jc,
 CASE WHEN (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) = 0 THEN 0 ELSE bzxh*ta_cccud12*-1*(ta_ccc19d+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud10)+(ta_ccc31+ta_ccc25)*ta_ccc23d-ta_ccc27*ta_ccc23d)/
 (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END cch31jd,
 bzxh*-1 bzxh,
 CASE WHEN (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) = 0 THEN 0 ELSE bzxh*-1*(ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)+(ta_ccc31+ta_ccc25)*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d)-ta_ccc27*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d))/
 (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END bzxhj,
 CASE WHEN (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) = 0 THEN 0 ELSE bzxh*-1*(ta_ccc19a+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+(ta_ccc31+ta_ccc25)*ta_ccc23a-ta_ccc27*ta_ccc23a)/
 (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END bzxhja,
 CASE WHEN (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) = 0 THEN 0 ELSE bzxh*-1*(ta_ccc19b+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud08+bzxh*ta_ccc23b-ta_ccc27*ta_ccc23b)/
 (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END bzxhjb,
 CASE WHEN (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) = 0 THEN 0 ELSE bzxh*-1*(ta_ccc19c+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud09+bzxh*ta_ccc23c-ta_ccc27*ta_ccc23c)/
 (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END bzxhjc,
 CASE WHEN (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) = 0 THEN 0 ELSE bzxh*-1*(ta_ccc19d+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud10+bzxh*ta_ccc23d-ta_ccc27*ta_ccc23d)/
 (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END bzxhjd,
 CASE WHEN (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) = 0 THEN 0 ELSE (ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)+(ta_ccc31+ta_ccc25)*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d)-ta_ccc27*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d))/
 (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END ta_ccc23,
 CASE WHEN (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) = 0 THEN 0 ELSE (ta_ccc19a+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+(ta_ccc31+ta_ccc25)*ta_ccc23a-ta_ccc27*ta_ccc23a)/
 (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END ta_ccc23a,
 CASE WHEN (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) = 0 THEN 0 ELSE (ta_ccc19b+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud08+(ta_ccc31+ta_ccc25)*ta_ccc23b-ta_ccc27*ta_ccc23b)/
 (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END ta_ccc23b,
 CASE WHEN (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) = 0 THEN 0 ELSE (ta_ccc19c+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud09+(ta_ccc31+ta_ccc25)*ta_ccc23c-ta_ccc27*ta_ccc23c)/
 (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END ta_ccc23c,
 CASE WHEN (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) = 0 THEN 0 ELSE (ta_ccc19d+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud10+(ta_ccc31+ta_ccc25)*ta_ccc23d-ta_ccc27*ta_ccc23d)/
 (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END ta_ccc23d
  ,ta_cccud12
 FROM ex_ccg_result,ta_ccp_file a
 WHERE yym=",tm.yy," AND mmy=",tm.mm," AND cch04=a.ta_ccc01(+) AND a.ta_ccc02(+)=",tm.yy," AND a.ta_ccc03(+)=",tm.mm,"
   AND SUBSTR(cch04,1,1)<>'K' AND INSTR(cch04,'.')=0   AND INSTR(cch04,'-')=0
  AND (a.ta_ccc217<>0 OR a.ta_ccc213<>0 OR a.ta_ccc18<>0 OR a.ta_ccc31<>0 OR a.ta_ccc25 <> 0 OR a.ta_ccc81<>0 OR a.ta_ccc98<>0)
  ) a ,ta_ccp_file b
  WHERE ccg04=b.ta_ccc01 AND b.ta_ccc02(+)=",tm.yy," AND b.ta_ccc03(+)=",tm.mm,"
    AND cch04 NOT IN (SELECT ima01 FROM ima_file WHERE ima06 IN('G01','G02'))
  GROUP BY ccg04,cch04,a.ta_ccc23,b.ta_ccc213,a.ta_ccc23a,a.ta_ccc23b,a.ta_ccc23c,a.ta_ccc23d,a.ta_cccud12"

  PREPARE p900_p10_1 FROM g_sql
  EXECUTE p900_p10_1
  
--获取未返工的料号
DELETE FROM ta_ccpa_file WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
LET g_sql = "INSERT INTO ta_ccpa_file ",
            "SELECT DISTINCT ta_ccc01,ima02,ima021,ima39,ima25,",tm.yy,",",tm.mm,", ",
            "       ta_ccc18,ta_ccc19,ta_ccc19a,ta_ccc19b,ta_ccc19c+ta_ccc19e,ta_ccc19d ",
            "      ,ta_ccc31+ta_ccc43,ta_ccc31*ta_ccc23a+ta_ccc43*ta_cccud07 ",
            "      ,ta_ccc31*ta_ccc23b+ta_ccc43*ta_cccud08,ta_ccc31*ta_ccc23c+ta_ccc43*ta_cccud09 ",
            "      ,ta_ccc31*ta_ccc23d+ta_ccc43*ta_cccud10,ta_ccc43*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)+ta_ccc31*ta_ccc23 ",
            "      ,ta_ccc98,ta_ccc98*ta_cccud07,ta_ccc98*ta_cccud08,ta_ccc98*ta_cccud09,ta_ccc98*ta_cccud10 ",
            "      ,ta_ccc98*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10) ",
            "      ,nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) ",
            "      ,ta_ccc19a+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+ta_ccc31*ta_ccc23a-ta_ccc27*ta_ccc23a ",
            "      ,ta_ccc19b+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud08+ta_ccc31*ta_ccc23b-ta_ccc27*ta_ccc23b ",
            "      ,ta_ccc19c+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud09+ta_ccc31*ta_ccc23c-ta_ccc27*ta_ccc23c ",
            "      ,ta_ccc19d+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud10+ta_ccc31*ta_ccc23d-ta_ccc27*ta_ccc23d, ",
            "      ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10) ",
            "      +ta_ccc31*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d)-ta_ccc27*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d) ",
            "      ,ta_cccud07,ta_cccud08,ta_cccud09,ta_cccud10 ",
            "      ,(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10),NVL(BZXH,0),NVL(BZXH,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10) ",
            "      ,CASE WHEN NVL(BZXH,0)=0 THEN 0 ELSE ROUND(nvl(ta_ccc18+ta_ccc217+ta_ccc31+TA_CCC81-ta_ccc98,0)/NVL(BZXH,0),10) END , ",
            "      ta_ccc27,ta_ccc27*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d),ta_ccc27*(ta_ccc23a),ta_ccc27*(ta_ccc23b),ta_ccc27*(ta_ccc23c),ta_ccc27*(ta_ccc23d) ",
            "      ,ta_ccc217,ta_ccc217*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d),ta_ccc217*(ta_ccc23a),ta_ccc217*(ta_ccc23b),ta_ccc217*(ta_ccc23c),ta_ccc217*(ta_ccc23d) ",
            "      ,ta_ccc81,ta_ccc81*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d),ta_ccc81*(ta_ccc23a),ta_ccc81*(ta_ccc23b),ta_ccc81*(ta_ccc23c),ta_ccc81*(ta_ccc23d) ",
            "      ,ta_ccc25,ta_ccc25*ta_ccc23,ta_ccc25*ta_ccc23a,ta_ccc25*ta_ccc23b,ta_ccc25*ta_ccc23c,ta_ccc25*ta_ccc23d ",
            "      FROM ta_ccp_file,ima_file,gfe_file,(SELECT cch04,SUM(cch31)*-1 cch31,SUM(bzxh)*-1 bzxh FROM ex_ccg_result ",
            "      WHERE yym=",tm.yy," AND mmy=",tm.mm," GROUP BY CCH04) HYB ",
            "      WHERE ta_ccc01=ima01 AND IMA25=gfe01 ",    #AND INSTR(ta_ccc01,'.')=0 AND INSTR(ta_ccc01,'-')=0 ",
            "        AND ta_ccc25 = 0 ",   #170725 用返工数量为0判断是否返工
            "      AND ta_ccc01=HYB.cch04(+) AND ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm," ",
            "      AND substr(ta_ccc01,7,1) IN ('A','F','R','G') AND NVL(BZXH,0)=0 AND ima06 IN ('G01','G02') ", 
            "      AND ta_ccc31=0 AND ta_ccc43=0 AND ta_ccc213<>0 "
  PREPARE p900_p11 FROM g_sql
  EXECUTE p900_p11

LET ta_cccbzxh1 = 0
LET ta_cccbzxh3 = 0
LET ta_cccbzxh4 = 0
LET ta_cccbzxh5 = 0
LET ta_cccbzxh6 = 0
LET ta_cccbzxh2 = 0

LET ta_cccbzxh11 = 0
LET ta_cccbzxh13 = 0
LET ta_cccbzxh14 = 0
LET ta_cccbzxh15 = 0
LET ta_cccbzxh16 = 0
LET ta_cccbzxh12 = 0

 LET g_sql = "SELECT sum(ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)+(ta_ccc31+ta_ccc25)*ta_ccc23-ta_ccc27*ta_ccc23) ",
 " ,sum(ta_ccc19a+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+(ta_ccc31+ta_ccc25)*ta_ccc23a-ta_ccc27*ta_ccc23a) ",
 " ,sum(ta_ccc19b+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud08+(ta_ccc31+ta_ccc25)*ta_ccc23b-ta_ccc27*ta_ccc23b) ",
 " ,sum(ta_ccc19c+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud09+(ta_ccc31+ta_ccc25)*ta_ccc23c-ta_ccc27*ta_ccc23c) ",
 " ,sum(ta_ccc19d+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud10+(ta_ccc31+ta_ccc25)*ta_ccc23d-ta_ccc27*ta_ccc23d) ",
 " FROM ta_ccp_file,ima_file,(SELECT CCH04,SUM(-CCH31) CCH31,SUM(-BZXH) BZXH FROM ex_ccg_result ",
 " WHERE yym=",tm.yy," AND mmy=",tm.mm," GROUP BY CCH04 ) HYB ",
 " WHERE  ta_ccc01=ima01 AND INSTR(ta_ccc01,'.')=0 AND INSTR(ta_ccc01,'-')=0 ",
 "   AND ta_ccc01=HYB.cch04(+) AND ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm," ",
 "   AND substr(ta_ccc01,7,1) IN('A','F','R','G') AND ima06 NOT IN('G01','G02') ",
 "   AND (ta_ccc217<>0 OR ta_ccc18<>0 OR ta_ccc31<>0 OR ta_ccc25 <> 0 OR ta_ccc27 <> 0 OR ta_ccc43<>0 OR ta_ccc81<>0 OR ta_ccc98<>0) AND NVL(BZXH,0)=0 "
  PREPARE p900_p12 FROM g_sql
  EXECUTE p900_p12 INTO ta_cccbzxh1,ta_cccbzxh3,ta_cccbzxh4,ta_cccbzxh5,ta_cccbzxh6

  LET ta_cccbzxh11 = ta_cccbzxh11 + ta_cccbzxh1
  LET ta_cccbzxh13 = ta_cccbzxh13 + ta_cccbzxh3
  LET ta_cccbzxh14 = ta_cccbzxh14 + ta_cccbzxh4
  LET ta_cccbzxh15 = ta_cccbzxh15 + ta_cccbzxh5
  LET ta_cccbzxh16 = ta_cccbzxh16 + ta_cccbzxh6
  LET ta_cccbzxh12 = ta_cccbzxh12 + ta_cccbzxh2

SELECT SUM(TA_CCQ12) INTO ta_cccbzxh2 FROM ta_ccq_file,IMA_FILE
WHERE TA_CCQ01=IMA01 AND TA_CCQ02=tm.yy AND TA_CCQ03=tm.mm
AND IMA06 IN('G01','G02') AND instr(ta_ccq05,'.')=0 
AND ta_ccq01 IN(SELECT ta_ccc01 FROM ta_ccpa_file WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm)

UPDATE ta_ccQ_file SET ta_ccQ22=(TA_CCQ12*ta_cccbzxh1/ta_cccbzxh2)
,ta_ccQ22A=(TA_CCQ12*ta_cccbzxh3/ta_cccbzxh2)
,ta_ccQ22B=(TA_CCQ12*ta_cccbzxh4/ta_cccbzxh2)
,ta_ccQ22C=(TA_CCQ12*ta_cccbzxh5/ta_cccbzxh2)
,ta_ccQ22D=(TA_CCQ12*ta_cccbzxh6/ta_cccbzxh2)
WHERE ta_ccQ02=tm.yy AND ta_ccQ03=tm.mm 
AND instr(ta_ccq05,'.')=0
AND ta_ccq01 IN(SELECT ima01 FROM ima_file WHERE IMA06 IN('G01','G02'))
AND ta_ccq01 IN(SELECT ta_ccc01 FROM ta_ccpa_file WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm)

{
 --更新本阶加工    
   UPDATE ta_ccp_file SET ta_ccc22d3=(SELECT SUM(cch32d)*-1 FROM CCH_FILE,CCG_FILE,SFB_FILE
   WHERE CCG01=CCH01 AND CCG02=CCH02 AND CCG03=CCH03 AND CCG02=tm.yy AND CCG03=tm.mm AND CCG04=ta_ccc01 
   AND SFB01=CCG01 AND SFB02 IN('1','7') AND CCG31<>0 AND cch04 LIKE ' DL+OH+SUB'
    )
   WHERE TA_CCC01 IN (SELECT CCG04 FROM CCH_FILE,CCG_FILE,SFB_FILE
   WHERE CCG01=CCH01 AND CCG02=CCH02 AND CCG03=CCH03 AND CCG02=tm.yy AND CCG03=tm.mm AND CCG04=ta_ccc01 
   AND SFB01=CCG01 AND SFB02 IN('1','7') AND CCG31<>0 AND cch04 LIKE ' DL+OH+SUB'
   )
   AND TA_CCC02=tm.yy AND TA_CCC03=tm.mm
}

--插入成品成本表
DELETE FROM TA_CCT_FILE WHERE ta_cct02=tm.yy AND ta_cct03=tm.mm
 LET g_sql = " INSERT INTO TA_CCT_FILE ",
  " SELECT DISTINCT a.TA_CCQ01 入库产品,",tm.yy,",",tm.mm,",TA_CCQ04 入库数量 ,TO_CHAR(TA_CCQ05) 半成品,NVL(ta_ccq11,0) 投入数量,NVL(ta_ccq12,0)+nvl(TA_CCQ22,0) 投入金额 ",
  " ,NVL(ta_ccq12a,0)+nvl(TA_CCQ22a,0) 投入材料,NVL(ta_ccq12b,0)+nvl(TA_CCQ22b,0) 投入人工,NVL(ta_ccq12c,0)+nvl(TA_CCQ22c,0) 投入制费,NVL(ta_ccq12d,0)+nvl(TA_CCQ22d,0) 投入加工 ",
  " ,ta_ccc22a3 本阶材料,ta_ccc22b3 本阶人工, ta_ccc22c3 本阶制费,ta_ccc22d3 本阶加工,ta_ccc22a3+ta_ccc22b3+ta_ccc22c3+ta_ccc22d3 本阶金额 ",
  " ,nvl(ta_ccq12a,0)+nvl(TA_CCQ22a,0)+ta_ccc22a3 材料合计,nvl(ta_ccq12b,0)+nvl(TA_CCQ22b,0)+ta_ccc22b3 人工合计,nvl(ta_ccq12c,0)+nvl(TA_CCQ22c,0)+ta_ccc22c3 制费合计 ",
  " ,ta_ccc22d3+NVL(ta_ccq12d,0)+nvl(TA_CCQ22d,0) 加工合计, ",
  " nvl(ta_ccq12a,0)+nvl(TA_CCQ22a,0)+ta_ccc22a3+(nvl(ta_ccq12b,0)+nvl(TA_CCQ22b,0)+ta_ccc22b3)+(nvl(ta_ccq12c,0)+nvl(TA_CCQ22c,0)+ta_ccc22c3)+(nvl(ta_ccc22d3,0)+NVL(ta_ccq12d,0)+nvl(TA_CCQ22d,0) ) 金额合计,0,0 ",
  " FROM ",
  " ( SELECT DISTINCT TA_CCQ01,TA_CCQ04,sum(TA_CCQ22) TA_CCQ22,sum(TA_CCQ22a) TA_CCQ22a,sum(TA_CCQ22b) TA_CCQ22b,sum(TA_CCQ22c) TA_CCQ22c,sum(TA_CCQ22d) TA_CCQ22d ",
  " ,ta_ccc223,ta_ccc22a3 ta_ccc22a3 ,ta_ccc22b3,ta_ccc22c3 ta_ccc22c3,ta_ccc22d3 FROM ta_ccq_file a,ta_ccp_file a ",
  " WHERE ta_ccq01=ta_ccc01 AND ta_ccq02=ta_ccc02 AND ta_ccq03=ta_ccc03 AND ta_ccq02=",tm.yy," AND ta_ccq03=",tm.mm," ",
  " GROUP BY TA_CCQ01,TA_CCQ04,ta_ccc223,ta_ccc22a3,ta_ccc22b3,ta_ccc22c3 ,ta_ccc22d3 ) a ",
  " LEFT JOIN ",
  " ( SELECT TA_CCQ01,WM_CONCAT(TA_CCQ05) TA_CCQ05,SUM(ta_ccq11) ta_ccq11,SUM(ta_ccq12) ta_ccq12,SUM(ta_ccq12a) ta_ccq12a ",
  " ,SUM(ta_ccq12b) ta_ccq12b,SUM(ta_ccq12c) ta_ccq12c,SUM(ta_ccq12d) ta_ccq12d ",
  " FROM ta_ccq_file a  WHERE INSTR(TA_CCQ05,'.')=0 AND ta_ccq02=",tm.yy," AND ta_ccq03=",tm.mm," ", 
  " GROUP BY  TA_CCQ01  ) b ON a.ta_ccq01=b.TA_CCQ01 "
  PREPARE p900_p13 FROM g_sql
  EXECUTE p900_p13
   
 UPDATE ta_ccp_file SET ta_ccc28=ta_ccc223
                       ,ta_ccc28a=ta_ccc22a3
                       ,ta_ccc28b=ta_ccc22b3
                       ,ta_ccc28c=ta_ccc22c3
                       ,ta_ccc28d=ta_ccc22d3
 WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
  AND ta_ccc01 IN(SELECT ta_cct01 FROM ta_cct_file WHERE ta_cct02=tm.yy AND ta_cct03=tm.mm)
 
 UPDATE ta_ccp_file SET ta_ccc223=(SELECT ta_cct21 FROM ta_cct_file WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22a3=(SELECT ta_cct17 FROM ta_cct_file WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22b3=(SELECT ta_cct18 FROM ta_cct_file WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22c3=(SELECT ta_cct19 FROM ta_cct_file WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22d3=(SELECT ta_cct20 FROM ta_cct_file WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
  AND ta_ccc01 IN(SELECT ta_cct01 FROM ta_cct_file WHERE ta_cct02=tm.yy AND ta_cct03=tm.mm)

  UPDATE ta_ccp_file SET 
TA_CCC23A=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0
THEN ( ta_ccc12a+ta_ccc22a1+ta_ccc22a2+ta_ccc22a3+ta_ccc22a5+ta_ccc22a6 )
  /(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23B=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0 THEN (ta_ccc12b+ta_ccc22b1+ta_ccc22b2+ta_ccc22b3+ta_ccc22b5+ta_ccc22b6
)/(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23C=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0 THEN (ta_ccc12C+ta_ccc22C1+ta_ccc22C2+ta_ccc22C3+ta_ccc22C5+ta_ccc22C6
)/(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23D=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0 THEN (ta_ccc12D+ta_ccc22D1+ta_ccc22D2+ta_ccc22D3+ta_ccc22D5+ta_ccc22D6
)/(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23E=0,
TA_CCC23F=0
WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
AND ((ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216)<>0 )
AND INSTR(TA_CCC01,'.')=0 AND INSTR(TA_CCC01,'-')=0 

UPDATE  ta_ccp_file SET TA_CCC23=TA_CCC23A+TA_CCC23B+TA_CCC23C+TA_CCC23D
WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm AND INSTR(TA_CCC01,'.')=0 AND INSTR(TA_CCC01,'-')=0  

UPDATE ta_ccp_file 
   SET ta_cccud07 = (ROUND(CASE WHEN NVL(ta_ccc18+ta_ccc31+ta_ccc25-ta_ccc27,0) = 0 THEN 0 ELSE (ta_ccc19a+(ta_ccc31)*ta_ccc23a+(ta_ccc25-ta_ccc27)*ta_ccc23a)/NVL(ta_ccc18+ta_ccc31+ta_ccc25-ta_ccc27,0) END,8))
      ,ta_cccud08 = (ROUND(CASE WHEN NVL(ta_ccc18+ta_ccc31+ta_ccc25-ta_ccc27,0) = 0 THEN 0 ELSE (ta_ccc19b+(ta_ccc31)*ta_ccc23b+(ta_ccc25-ta_ccc27)*ta_ccc23b)/NVL(ta_ccc18+ta_ccc31+ta_ccc25-ta_ccc27,0) END,8))
      ,ta_cccud09 = (ROUND(CASE WHEN NVL(ta_ccc18+ta_ccc31+ta_ccc81+ta_ccc25-ta_ccc27,0) = 0 THEN 0 ELSE (ta_ccc19c+(ta_ccc31)*ta_ccc23c+ta_ccc31*ta_ccc23e+(ta_ccc25-ta_ccc27)*(ta_ccc23c+ta_ccc23e))/NVL(ta_ccc18+ta_ccc31+ta_ccc81+ta_ccc25-ta_ccc27,0) END,8))
      ,ta_cccud10 = (ROUND(CASE WHEN NVL(ta_ccc18+ta_ccc31+ta_ccc81+ta_ccc25-ta_ccc27,0) = 0 THEN 0 ELSE (ta_ccc19d+(ta_ccc31)*ta_ccc23d+(ta_ccc25-ta_ccc27)*ta_ccc23d)/NVL(ta_ccc18+ta_ccc31+ta_ccc81+ta_ccc25-ta_ccc27,0) END,8))
      ,ta_ccc66=ta_ccc23
      ,ta_ccc66a=ta_ccc23a
      ,ta_ccc66b=ta_ccc23b
      ,ta_ccc66c=ta_ccc23c
      ,ta_ccc66d=ta_ccc23d
 WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm AND instr(ta_ccc01,'.')=0 AND instr(ta_ccc01,'-')=0

--插入半成品消耗记录(成品转成品)
LET g_sql = "INSERT INTO ta_ccq_file
  SELECT ccg04,",tm.yy,",",tm.mm,",ta_ccc213,cch04,'N' TDF,SUM(cch31) cch31,SUM(bzxh) bzxh,SUM(cch31j) cch31j,SUM(cch31ja) cch31ja
  ,SUM(cch31jb) cch31jb,SUM(cch31jc) cch31jc,SUM(cch31jd) cch31jd,0,0
  ,SUM(bzxhj) bzxhj,SUM(bzxhja) bzxhja,SUM(bzxhjb) bzxhjb,SUM(bzxhjc) bzxhjc,SUM(bzxhjd) bzxhjd,0,0,a.ta_cccud12,a.ta_ccc23,a.ta_ccc23a,a.ta_ccc23b,a.ta_ccc23c,a.ta_ccc23d,0,0,0,0,0 FROM
  (SELECT ccg04,cch04,bzxh*ta_cccud12*-1 cch31,
  CASE WHEN nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) = 0 THEN 0 ELSE bzxh*ta_cccud12*-1*(ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)+(ta_ccc31+ta_ccc25)*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d)-ta_ccc27*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d))/
  (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END cch31j,
  CASE WHEN nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) = 0 THEN 0 ELSE bzxh*ta_cccud12*-1*(ta_ccc19a+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+(ta_ccc31+ta_ccc25)*ta_ccc23a-ta_ccc27*ta_ccc23a)/
  (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END cch31ja,
  CASE WHEN nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) = 0 THEN 0 ELSE bzxh*ta_cccud12*-1*(ta_ccc19b+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud08)+(ta_ccc31+ta_ccc25)*ta_ccc23b-ta_ccc27*ta_ccc23b)/
  (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END cch31jb,
  CASE WHEN nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) = 0 THEN 0 ELSE bzxh*ta_cccud12*-1*(ta_ccc19c+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud09)+(ta_ccc31+ta_ccc25)*ta_ccc23c-ta_ccc27*ta_ccc23c)/
  (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END cch31jc,
  CASE WHEN nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) = 0 THEN 0 ELSE bzxh*ta_cccud12*-1*(ta_ccc19d+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud10)+(ta_ccc31+ta_ccc25)*ta_ccc23d-ta_ccc27*ta_ccc23d)/
  (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END cch31jd,
  bzxh*-1 bzxh,
  CASE WHEN nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) = 0 THEN 0 ELSE bzxh*-1*(ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)+(ta_ccc31+ta_ccc25)*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d)-ta_ccc27*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d))/
  (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END bzxhj,
  CASE WHEN nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) = 0 THEN 0 ELSE bzxh*-1*(ta_ccc19a+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+(ta_ccc31+ta_ccc25)*ta_ccc23a-ta_ccc27*ta_ccc23a)/
  (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END bzxhja,
  CASE WHEN nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) = 0 THEN 0 ELSE bzxh*-1*(ta_ccc19b+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud08+bzxh*ta_ccc23b-ta_ccc27*ta_ccc23b)/
  (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END bzxhjb,
  CASE WHEN nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) = 0 THEN 0 ELSE bzxh*-1*(ta_ccc19c+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud09+bzxh*ta_ccc23c-ta_ccc27*ta_ccc23c)/
  (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END bzxhjc,
  CASE WHEN nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) = 0 THEN 0 ELSE bzxh*-1*(ta_ccc19d+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud10+bzxh*ta_ccc23d-ta_ccc27*ta_ccc23d)/
  (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END bzxhjd,
  CASE WHEN nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) = 0 THEN 0 ELSE (ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)+(ta_ccc31+ta_ccc25)*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d)-ta_ccc27*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d))/
  (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END ta_ccc23,
  CASE WHEN nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) = 0 THEN 0 ELSE (ta_ccc19a+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+(ta_ccc31+ta_ccc25)*ta_ccc23a-ta_ccc27*ta_ccc23a)/
  (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END ta_ccc23a,
  CASE WHEN nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) = 0 THEN 0 ELSE (ta_ccc19b+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud08+(ta_ccc31+ta_ccc25)*ta_ccc23b-ta_ccc27*ta_ccc23b)/
  (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END ta_ccc23b,
  CASE WHEN nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) = 0 THEN 0 ELSE (ta_ccc19c+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud09+(ta_ccc31+ta_ccc25)*ta_ccc23c-ta_ccc27*ta_ccc23c)/
  (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END ta_ccc23c,
  CASE WHEN nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) = 0 THEN 0 ELSE (ta_ccc19d+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud10+(ta_ccc31+ta_ccc25)*ta_ccc23d-ta_ccc27*ta_ccc23d)/
  (nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) END ta_ccc23d
  ,ta_cccud12
  FROM ex_ccg_result,ta_ccp_file a
  WHERE yym=",tm.yy," AND mmy=",tm.mm," AND cch04=a.ta_ccc01(+) AND a.ta_ccc02(+)=",tm.yy," AND a.ta_ccc03(+)=",tm.mm," 
  AND SUBSTR(cch04,1,1)<>'K' AND INSTR(cch04,'.')=0   AND INSTR(cch04,'-')=0
 AND (a.ta_ccc217<>0 OR a.ta_ccc213<>0 OR a.ta_ccc18<>0 OR a.ta_ccc31<>0 OR a.ta_ccc25 <> 0 OR a.ta_ccc81<>0 OR a.ta_ccc98<>0  OR a.ta_ccc43<>0)
 ) a ,ta_ccp_file b
 WHERE ccg04=b.ta_ccc01 AND b.ta_ccc02(+)=",tm.yy," AND b.ta_ccc03(+)=",tm.mm,"
 AND cch04 IN (SELECT ima01 FROM ima_file WHERE ima06 IN('G01','G02'))
 GROUP BY ccg04,cch04,a.ta_ccc23,b.ta_ccc213,a.ta_ccc23a,a.ta_ccc23b,a.ta_ccc23c,a.ta_ccc23d,a.ta_cccud12"

PREPARE p900_p13_1 FROM g_sql
EXECUTE p900_p13_1
   
 --返工成品损耗摊销
 LET g_sql = "SELECT sum(ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)+(ta_ccc31+ta_ccc25)*ta_ccc23 - NVL(ta_ccc27,0)*ta_ccc23) ",
 " ,sum(ta_ccc19a+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+(ta_ccc31+ta_ccc25)*ta_ccc23a - NVL(ta_ccc27,0)*ta_ccc23a) ",
 " ,sum(ta_ccc19b+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud08+(ta_ccc31+ta_ccc25)*ta_ccc23b - NVL(ta_ccc27,0)*ta_ccc23b) ",
 " ,sum(ta_ccc19c+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud09+(ta_ccc31+ta_ccc25)*ta_ccc23c - NVL(ta_ccc27,0)*ta_ccc23c) ",
 " ,sum(ta_ccc19d+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud10+(ta_ccc31+ta_ccc25)*ta_ccc23d - NVL(ta_ccc27,0)*ta_ccc23d) ",
 " FROM ta_ccp_file,ima_file,(SELECT CCH04,SUM(-CCH31) CCH31,SUM(-BZXH) BZXH FROM ex_ccg_result ",
 " WHERE yym=",tm.yy," AND mmy=",tm.mm," GROUP BY CCH04) HYB ",
 " WHERE ta_ccc01=ima01 AND INSTR(ta_ccc01,'.')=0 AND INSTR(ta_ccc01,'-')=0 ",
 " AND ta_ccc01=HYB.cch04(+) AND ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm," ",
 " AND substr(ta_ccc01,7,1) IN('A','F','R','G') AND ima06 IN('G01','G02') ",
 " AND (ta_ccc217<>0 OR ta_ccc18<>0 OR ta_ccc31<>0 OR ta_ccc25 <> 0 OR ta_ccc27 <> 0 OR ta_ccc43<>0 OR ta_ccc81<>0 OR ta_ccc98<>0) AND NVL(BZXH,0)=0 "
PREPARE p900_p14 FROM g_sql
EXECUTE p900_p14 INTO ta_cccbzxh1,ta_cccbzxh3,ta_cccbzxh4,ta_cccbzxh5,ta_cccbzxh6

SELECT SUM(TA_CCQ12) INTO ta_cccbzxh2 FROM ta_ccq_file,IMA_FILE
WHERE TA_CCQ01=IMA01 AND TA_CCQ02=tm.yy AND TA_CCQ03=tm.mm
AND IMA06 IN('G01','G02') AND instr(ta_ccq05,'.')=0 
AND ta_ccq01 IN(SELECT ta_ccc01 FROM ta_ccpa_file WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm)

UPDATE ta_ccq_file SET ta_ccQ22=ta_ccQ22+(TA_CCQ12*ta_cccbzxh1/ta_cccbzxh2)
,ta_ccQ22A=ta_ccQ22A+(TA_CCQ12*ta_cccbzxh3/ta_cccbzxh2)
,ta_ccQ22B=ta_ccQ22B+(TA_CCQ12*ta_cccbzxh4/ta_cccbzxh2)
,ta_ccQ22C=ta_ccQ22C+(TA_CCQ12*ta_cccbzxh5/ta_cccbzxh2)
,ta_ccQ22D=ta_ccQ22D+(TA_CCQ12*ta_cccbzxh6/ta_cccbzxh2)
WHERE ta_ccQ02=tm.yy AND ta_ccQ03=tm.mm 
AND instr(ta_ccq05,'.')=0
AND ta_ccq01 IN(SELECT ima01 FROM ima_file WHERE IMA06 IN('G01','G02'))
AND ta_ccq01 IN(SELECT ta_ccc01 FROM ta_ccpa_file WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm)

  LET ta_cccbzxh11 = ta_cccbzxh11 + ta_cccbzxh1
  LET ta_cccbzxh13 = ta_cccbzxh13 + ta_cccbzxh3
  LET ta_cccbzxh14 = ta_cccbzxh14 + ta_cccbzxh4
  LET ta_cccbzxh15 = ta_cccbzxh15 + ta_cccbzxh5
  LET ta_cccbzxh16 = ta_cccbzxh16 + ta_cccbzxh6
  LET ta_cccbzxh12 = ta_cccbzxh12 + ta_cccbzxh2

--重新形成成品成本表
DELETE FROM TA_CCT_FILE WHERE ta_cct02=tm.yy AND ta_cct03=tm.mm
LET g_sql = "INSERT INTO TA_CCT_FILE ",
 " SELECT DISTINCT a.TA_CCQ01 入库产品,",tm.yy,",",tm.mm,",TA_CCQ04 入库数量 ,TO_CHAR(TA_CCQ05) 半成品,NVL(ta_ccq11,0) 投入数量,NVL(ta_ccq12,0)+nvl(TA_CCQ22,0) 投入金额 ",
 " ,NVL(ta_ccq12a,0)+nvl(TA_CCQ22a,0) 投入材料,NVL(ta_ccq12b,0)+nvl(TA_CCQ22b,0) 投入人工,NVL(ta_ccq12c,0)+nvl(TA_CCQ22c,0) 投入制费,NVL(ta_ccq12d,0)+nvl(TA_CCQ22d,0) 投入加工 ",
 " ,ta_ccc22a3 本阶材料,ta_ccc22b3 本阶人工, ta_ccc22c3 本阶制费,ta_ccc22d3 本阶加工,ta_ccc22a3+ta_ccc22b3+ta_ccc22c3+ta_ccc22d3 本阶金额 ",
 " ,nvl(ta_ccq12a,0)+nvl(TA_CCQ22a,0)+ta_ccc22a3 材料合计,nvl(ta_ccq12b,0)+nvl(TA_CCQ22b,0)+ta_ccc22b3 人工合计,nvl(ta_ccq12c,0)+nvl(TA_CCQ22c,0)+ta_ccc22c3 制费合计 ",
 " ,ta_ccc22d3+NVL(ta_ccq12d,0)+nvl(TA_CCQ22d,0) 加工合计, ",
 " nvl(ta_ccq12a,0)+nvl(TA_CCQ22a,0)+ta_ccc22a3+(nvl(ta_ccq12b,0)+nvl(TA_CCQ22b,0)+ta_ccc22b3)+(nvl(ta_ccq12c,0)+nvl(TA_CCQ22c,0)+ta_ccc22c3)+(nvl(ta_ccc22d3,0)+NVL(ta_ccq12d,0)+nvl(TA_CCQ22d,0) ) 金额合计,0,0 ",
 " FROM ",
 " ( SELECT DISTINCT TA_CCQ01,TA_CCQ04,sum(TA_CCQ22) TA_CCQ22,sum(TA_CCQ22a) TA_CCQ22a,sum(TA_CCQ22b) TA_CCQ22b,sum(TA_CCQ22c) TA_CCQ22c,sum(TA_CCQ22d) TA_CCQ22d ",
 " ,ta_ccc28 ta_ccc223,ta_ccc28a ta_ccc22a3 ,ta_ccc28b ta_ccc22b3,ta_ccc28c ta_ccc22c3,ta_ccc28d ta_ccc22d3 FROM ta_ccq_file a,ta_ccp_file a ",
 " WHERE ta_ccq01=ta_ccc01 AND ta_ccq02=ta_ccc02 AND ta_ccq03=ta_ccc03 AND ta_ccq02=",tm.yy," AND ta_ccq03=",tm.mm," ",
 " GROUP BY TA_CCQ01,TA_CCQ04,ta_ccc28,ta_ccc28a,ta_ccc28b,ta_ccc28c ,ta_ccc28d ) a ",
 " LEFT JOIN ",
 " ( SELECT TA_CCQ01,WM_CONCAT(TA_CCQ05) TA_CCQ05,SUM(ta_ccq11) ta_ccq11,SUM(ta_ccq12) ta_ccq12,SUM(ta_ccq12a) ta_ccq12a ",
 " ,SUM(ta_ccq12b) ta_ccq12b,SUM(ta_ccq12c) ta_ccq12c,SUM(ta_ccq12d) ta_ccq12d ",
 "  FROM ta_ccq_file a  WHERE INSTR(TA_CCQ05,'.')=0 AND ta_ccq02=",tm.yy," AND ta_ccq03=",tm.mm," ",  
 "  GROUP BY TA_CCQ01 ) b ON a.ta_ccq01=b.TA_CCQ01 "  
PREPARE p900_p15 FROM g_sql
EXECUTE p900_p15 
  
 UPDATE ta_ccp_file SET ta_ccc223=(SELECT ta_cct21 FROM ta_cct_file WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22a3=(SELECT ta_cct17 FROM ta_cct_file WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22b3=(SELECT ta_cct18 FROM ta_cct_file WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22c3=(SELECT ta_cct19 FROM ta_cct_file WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22d3=(SELECT ta_cct20 FROM ta_cct_file WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
  AND ta_ccc01 IN(SELECT ta_cct01 FROM ta_cct_file WHERE ta_cct02=tm.yy AND ta_cct03=tm.mm) 

 UPDATE ta_ccp_file SET 
TA_CCC23A=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0
THEN ( ta_ccc12a+ta_ccc22a1+ta_ccc22a2+ta_ccc22a3+ta_ccc22a5+ta_ccc22a6 )
  /(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23B=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0 THEN (ta_ccc12b+ta_ccc22b1+ta_ccc22b2+ta_ccc22b3+ta_ccc22b5+ta_ccc22b6
)/(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23C=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0 THEN (ta_ccc12C+ta_ccc22C1+ta_ccc22C2+ta_ccc22C3+ta_ccc22C5+ta_ccc22C6
)/(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23D=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0 THEN (ta_ccc12D+ta_ccc22D1+ta_ccc22D2+ta_ccc22D3+ta_ccc22D5+ta_ccc22D6
)/(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23E=0,
TA_CCC23F=0
WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
AND ((ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216)<>0 )
AND INSTR(TA_CCC01,'.')=0 AND INSTR(TA_CCC01,'-')=0 

UPDATE  ta_ccP_file SET TA_CCC23=TA_CCC23A+TA_CCC23B+TA_CCC23C+TA_CCC23D--+TA_CCC23E+TA_CCC23F
WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm AND INSTR(TA_CCC01,'.')=0 AND INSTR(TA_CCC01,'-')=0  

UPDATE ta_ccp_file SET TA_CCCUD07=(ROUND(CASE WHEN nvl(ta_ccc18+ta_ccc31+ta_ccc25-ta_ccc27,0)=0 THEN 0
 ELSE (ta_ccc19a+ta_ccc31*ta_ccc23a+(ta_ccc25-ta_ccc27)*ta_ccc23a)/nvl(ta_ccc18+ta_ccc31+ta_ccc25-ta_ccc27,0) END,8) )
   ,TA_CCCUD08=(ROUND(CASE WHEN nvl(ta_ccc18+ta_ccc31+ta_ccc25-ta_ccc27,0)=0 THEN 0
 ELSE (ta_ccc19b+ta_ccc31*ta_ccc23b+(ta_ccc25-ta_ccc27)*ta_ccc23b)/nvl(ta_ccc18+ta_ccc31+ta_ccc25-ta_ccc27,0) END,8) )
   ,TA_CCCUD09=(ROUND(CASE WHEN nvl(ta_ccc18+ta_ccc31+TA_CCC81+ta_ccc25-ta_ccc27,0)=0 THEN 0
 ELSE (ta_ccc19c+ta_ccc31*ta_ccc23c+ta_ccc31*ta_ccc23e+(ta_ccc25-ta_ccc27)*(ta_ccc23c+ta_ccc23e))/nvl(ta_ccc18+ta_ccc31+TA_CCC81+ta_ccc25-ta_ccc27,0) END,8) )
   ,TA_CCCUD10=(ROUND(CASE WHEN nvl(ta_ccc18+ta_ccc31+TA_CCC81+ta_ccc25-ta_ccc27,0)=0 THEN 0
 ELSE (ta_ccc19d+ta_ccc31*ta_ccc23d+(ta_ccc25-ta_ccc27)*ta_ccc23d)/nvl(ta_ccc18+ta_ccc31+TA_CCC81+ta_ccc25-ta_ccc27,0) END,8) )
   ,TA_CCC66=ta_ccc23
   ,TA_CCC66A=ta_ccc23a
   ,TA_CCC66b=ta_ccc23b
   ,TA_CCC66c=ta_ccc23c
   ,TA_CCC66d=ta_ccc23d
   WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm AND instr(ta_ccc01,'.')=0 AND instr(ta_ccc01,'-')=0 

DELETE FROM ta_ccpa_file WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm 
LET g_sql = "INSERT INTO ta_ccpa_file ",
 " SELECT DISTINCT ta_ccc01 料号,ima02 品名,ima021 规格,ima39 科目别,ima25 单位,",tm.yy,",",tm.mm,", ",
 " ta_ccc18 上期数量,ta_ccc19 上期合计,ta_ccc19a 上期材料,ta_ccc19b 上期人工,ta_ccc19c+ta_ccc19e 上期制费,ta_ccc19d 上期加工 ",
 " ,ta_ccc31+ta_ccc43 领入数量,ta_ccc31*ta_ccc23a+ta_ccc43*ta_cccud07 领入材料 ",
 " ,ta_ccc31*ta_ccc23b+ta_ccc43*ta_cccud08 领入人工,ta_ccc31*ta_ccc23c+ta_ccc43*ta_cccud09 领入制费 ",
 " ,ta_ccc31*ta_ccc23d+ta_ccc43*ta_cccud10 领用加工,ta_ccc43*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)+ta_ccc31*ta_ccc23 领入合计 ",
 " ,ta_ccc98 期末数量,ta_ccc98*ta_cccud07 期末材料,ta_ccc98*ta_cccud08 期末人工,ta_ccc98*ta_cccud09 期末费用,ta_ccc98*ta_cccud10 期末加工 ",
 " ,ta_ccc98*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10) 期末合计 ",
 " ,nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc25+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) 实际耗用数量 ",
 " ,ta_ccc19a+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+(ta_ccc31+ta_ccc25)*ta_ccc23a-ta_ccc27*ta_ccc23a 实际耗用材料 ",
 " ,ta_ccc19b+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud08+(ta_ccc31+ta_ccc25)*ta_ccc23b-ta_ccc27*ta_ccc23b 实际耗用人工 ",
 " ,ta_ccc19c+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud09+(ta_ccc31+ta_ccc25)*ta_ccc23c-ta_ccc27*ta_ccc23c 实际耗用制费 ",
 " ,ta_ccc19d+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud10+(ta_ccc31+ta_ccc25)*ta_ccc23d-ta_ccc27*ta_ccc23d 实际耗用加工, ",
 " ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10) ",
 "  +(ta_ccc31+ta_ccc25)*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d)-ta_ccc27*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d)  实际耗用金额合计 ",
 " ,ta_cccud07 单价材料,ta_cccud08 单价人工,ta_cccud09 单价制费,ta_cccud10 单价加工 ",
 " ,(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10) 单价合计,NVL(BZXH,0) 标准耗用,NVL(BZXH,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10) 标准金额 ",
 " ,CASE WHEN NVL(BZXH,0)=0 THEN 0 ELSE ROUND(nvl(ta_ccc18+ta_ccc217+ta_ccc31+TA_CCC81-ta_ccc98,0)/NVL(BZXH,0),10) END 实际耗用率, ",
 " ta_ccc27 返工入库数量,ta_ccc27*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d) 返工入库金额,ta_ccc27*(ta_ccc23a) 返工入库材料,ta_ccc27*(ta_ccc23b) 返工入库人工,ta_ccc27*(ta_ccc23c) 返工入库制费,ta_ccc27*(ta_ccc23d) 返工入库加工 ",
 " ,ta_ccc217 WIP杂收,ta_ccc217*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10) WIP杂收金额,ta_ccc217*(ta_cccud07) WIP杂收材料,ta_ccc217*(ta_cccud08) WIP杂收人工,ta_ccc217*(ta_cccud09) WIP杂收制费,ta_ccc217*(ta_cccud10) WIP杂收加工 ",
 " ,ta_ccc81 WIP杂发,ta_ccc81*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10) WIP杂发金额,ta_ccc81*(ta_cccud07) WIP杂发材料,ta_ccc81*(ta_cccud08) WIP发收人工,ta_ccc81*(ta_cccud09) WIP发收制费,ta_ccc81*(ta_cccud10) WIP杂发加工 ",
 " ,ta_ccc25,ta_ccc25*ta_ccc23,ta_ccc25*ta_ccc23a,ta_ccc25*ta_ccc23b,ta_ccc25*ta_ccc23c,ta_ccc25*ta_ccc23d ",
 " FROM ta_ccp_file,ima_file,GFE_FILE,(SELECT CCH04,SUM(-CCH31) CCH31,SUM(-BZXH) BZXH FROM ex_ccg_result  ",
 "  WHERE yym=",tm.yy," AND mmy=",tm.mm," GROUP BY CCH04 ) HYB ", 
 "  WHERE  ta_ccc01=ima01 AND IMA25=GFE01  AND INSTR(ta_ccc01,'.')=0 AND INSTR(ta_ccc01,'-')=0 ",   
 "  AND ta_ccc01=HYB.cch04(+) AND ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm,"  ",
 "  AND substr(ta_ccc01,7,1) IN('A','F','R','G')  ",
 " AND (ta_ccc217<>0 OR ta_ccc18<>0 OR ta_ccc31<>0 OR ta_ccc25 <> 0 OR ta_ccc213<>0 OR ta_ccc43<>0 OR ta_ccc81<>0 OR ta_ccc98<>0) " 
PREPARE p900_p16 FROM g_sql
EXECUTE p900_p16 

#分摊差异处理
  LET l_ta_ccq22 = 0 LET l_ta_ccq22a = 0 LET l_ta_ccq22b = 0 LET l_ta_ccq22c = 0 LET l_ta_ccq22d = 0
  SELECT SUM(TA_CCCUD02),SUM(TA_CCCUD03),SUM(TA_CCCUD04),SUM(TA_CCCUD05),SUM(TA_CCCUD06)
    INTO l_ta_ccq22a,l_ta_ccq22b,l_ta_ccq22c,l_ta_ccq22d,l_ta_ccq22
    FROM ta_ccpa_file
   WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm 
     AND TA_CCCUD12 = 0
     AND instr(ta_ccc01,'.')=0

  LET ta_cccbzxh1 = ta_cccbzxh11 - l_ta_ccq22
  LET ta_cccbzxh3 = ta_cccbzxh13 - l_ta_ccq22a
  LET ta_cccbzxh4 = ta_cccbzxh14 - l_ta_ccq22b
  LET ta_cccbzxh5 = ta_cccbzxh15 - l_ta_ccq22c
  LET ta_cccbzxh6 = ta_cccbzxh16 - l_ta_ccq22d

  LET l_ta_ccq01 = NULL
  SELECT MAX(ta_ccq01) INTO l_ta_ccq01 FROM ta_ccq_file
   WHERE ta_ccq22 = (select MAX(ta_ccq22) from ta_ccq_file where ta_ccQ02=tm.yy AND ta_ccQ03=tm.mm
                        AND instr(ta_ccq05,'.')=0
                        AND ta_ccq01 IN (SELECT ima01 FROM ima_file WHERE IMA06 IN('G01','G02'))
                        AND ta_ccq01 IN (SELECT ta_ccc01 FROM ta_ccpa_file WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm))
     AND ta_ccQ02=tm.yy AND ta_ccQ03=tm.mm 
     AND instr(ta_ccq05,'.')=0
     AND ta_ccq01 IN (SELECT ima01 FROM ima_file WHERE IMA06 IN('G01','G02'))
     AND ta_ccq01 IN (SELECT ta_ccc01 FROM ta_ccpa_file WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm)
   
UPDATE ta_ccq_file SET ta_ccQ22=ta_ccQ22-ta_cccbzxh1
,ta_ccQ22A=ta_ccQ22A-ta_cccbzxh3
,ta_ccQ22B=ta_ccQ22B-ta_cccbzxh4
,ta_ccQ22C=ta_ccQ22C-ta_cccbzxh5
,ta_ccQ22D=ta_ccQ22D-ta_cccbzxh6
WHERE ta_ccQ02=tm.yy AND ta_ccQ03=tm.mm 
AND instr(ta_ccq05,'.')=0
AND ta_ccq01 IN (SELECT ima01 FROM ima_file WHERE IMA06 IN('G01','G02'))
AND ta_ccq01 IN (SELECT ta_ccc01 FROM ta_ccpa_file WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm)
AND ta_ccq01 = l_ta_ccq01

 UPDATE ta_ccp_file SET ta_ccc92=(CASE WHEN instr(ta_ccc01,'.')>0 THEN ta_ccc91*ta_ccc26 ELSE ta_ccc91*ta_ccc23 END)
                        ,ta_ccc92a=(CASE WHEN instr(ta_ccc01,'.')>0 THEN ta_ccc91*ta_ccc26a ELSE ta_ccc91*ta_ccc23a END)
                        ,ta_ccc92b=ta_ccc91*ta_ccc23b
                        ,ta_ccc92c=ta_ccc91*ta_ccc23c
                        ,ta_ccc92d=ta_ccc91*ta_ccc23d
                        ,ta_ccc92e=0
                        ,ta_ccc92f=0
                        ,ta_ccc99=ta_ccc98*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)
                        ,ta_ccc99a=ta_ccc98*ta_cccud07
                        ,ta_ccc99b=ta_ccc98*ta_cccud08
                        ,ta_ccc99c=ta_ccc98*ta_cccud09
                        ,ta_ccc99d=ta_ccc98*ta_cccud10
 WHERE ta_ccc01 IN(SELECT ta_imk01 FROM ta_imk_file WHERE ta_imk05=tm.yy AND ta_imk06=tm.mm)
 AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm

 LET g_sql = "UPDATE ta_ccp_file SET ta_cccud06='Y' ",
  " WHERE ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm," ",
  "  AND  TA_CCC01 IN ((SELECT CCH04 FROM EX_CCG_RESULT WHERE TDF LIKE '%Y%' AND YYM=",tm.yy," AND MMY=",tm.mm,") ",
  "  UNION ( SELECT YJLH FROM EX_CCG_WGD,EX_BOM_CP WHERE TDF LIKE '%Y%' AND YYM=",tm.yy," AND MMY=",tm.mm," AND ex_bom_cp.yy = ",tm.yy," AND ex_bom_cp.mm = ",tm.mm," ",
  "   AND to_char(sxrq1,'yyyyMM')<=TO_CHAR(to_date(",tm.yy,"||",tm.mm,",'yyyyMM'),'yyyyMM')   AND INSTR(YJLH,'.')>1 ",
  "  AND nvl(to_char(sxrq2,'yyyyMM'),TO_CHAR(SYSDATE+1,'yyyyMM')) >TO_CHAR(to_date(",tm.yy,"||",tm.mm,",'yyyyMM'),'yyyyMM') ",
  "  AND CCH04=CPLH)) "
PREPARE p900_p17 FROM g_sql
EXECUTE p900_p17 

--重新形成成品成本表第二次
DELETE FROM TA_CCT_FILE WHERE ta_cct02=tm.yy AND ta_cct03=tm.mm
LET g_sql = "INSERT INTO TA_CCT_FILE ",
 " SELECT DISTINCT a.TA_CCQ01 入库产品,",tm.yy,",",tm.mm,",TA_CCQ04 入库数量 ,TO_CHAR(TA_CCQ05) 半成品,NVL(ta_ccq11,0) 投入数量,NVL(ta_ccq12,0)+nvl(TA_CCQ22,0) 投入金额 ",
 " ,NVL(ta_ccq12a,0)+nvl(TA_CCQ22a,0) 投入材料,NVL(ta_ccq12b,0)+nvl(TA_CCQ22b,0) 投入人工,NVL(ta_ccq12c,0)+nvl(TA_CCQ22c,0) 投入制费,NVL(ta_ccq12d,0)+nvl(TA_CCQ22d,0) 投入加工 ",
 " ,ta_ccc22a3 本阶材料,ta_ccc22b3 本阶人工, ta_ccc22c3 本阶制费,ta_ccc22d3 本阶加工,ta_ccc22a3+ta_ccc22b3+ta_ccc22c3+ta_ccc22d3 本阶金额 ",
 " ,nvl(ta_ccq12a,0)+nvl(TA_CCQ22a,0)+ta_ccc22a3 材料合计,nvl(ta_ccq12b,0)+nvl(TA_CCQ22b,0)+ta_ccc22b3 人工合计,nvl(ta_ccq12c,0)+nvl(TA_CCQ22c,0)+ta_ccc22c3 制费合计 ",
 " ,ta_ccc22d3+NVL(ta_ccq12d,0)+nvl(TA_CCQ22d,0) 加工合计, ",
 " nvl(ta_ccq12a,0)+nvl(TA_CCQ22a,0)+ta_ccc22a3+(nvl(ta_ccq12b,0)+nvl(TA_CCQ22b,0)+ta_ccc22b3)+(nvl(ta_ccq12c,0)+nvl(TA_CCQ22c,0)+ta_ccc22c3)+(nvl(ta_ccc22d3,0)+NVL(ta_ccq12d,0)+nvl(TA_CCQ22d,0) ) 金额合计,0,0 ",
 " FROM ",
 " ( SELECT DISTINCT TA_CCQ01,TA_CCQ04,sum(TA_CCQ22) TA_CCQ22,sum(TA_CCQ22a) TA_CCQ22a,sum(TA_CCQ22b) TA_CCQ22b,sum(TA_CCQ22c) TA_CCQ22c,sum(TA_CCQ22d) TA_CCQ22d ",
 " ,ta_ccc28 ta_ccc223,ta_ccc28a ta_ccc22a3 ,ta_ccc28b ta_ccc22b3,ta_ccc28c ta_ccc22c3,ta_ccc28d ta_ccc22d3 FROM ta_ccq_file a,ta_ccp_file a ",
 " WHERE ta_ccq01=ta_ccc01 AND ta_ccq02=ta_ccc02 AND ta_ccq03=ta_ccc03 AND ta_ccq02=",tm.yy," AND ta_ccq03=",tm.mm," ",
 " GROUP BY TA_CCQ01,TA_CCQ04,ta_ccc28,ta_ccc28a,ta_ccc28b,ta_ccc28c ,ta_ccc28d ) a ",
 " LEFT JOIN ",
 " ( SELECT TA_CCQ01,WM_CONCAT(TA_CCQ05) TA_CCQ05,SUM(ta_ccq11) ta_ccq11,SUM(ta_ccq12) ta_ccq12,SUM(ta_ccq12a) ta_ccq12a ",
 " ,SUM(ta_ccq12b) ta_ccq12b,SUM(ta_ccq12c) ta_ccq12c,SUM(ta_ccq12d) ta_ccq12d ",
 "  FROM ta_ccq_file a  WHERE INSTR(TA_CCQ05,'.')=0 AND ta_ccq02=",tm.yy," AND ta_ccq03=",tm.mm," ",  
 "  GROUP BY TA_CCQ01 ) b ON a.ta_ccq01=b.TA_CCQ01 "  
PREPARE p900_p19 FROM g_sql
EXECUTE p900_p19 

  
 UPDATE ta_ccp_file SET ta_ccc223=(SELECT ta_cct21 FROM ta_cct_file WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22a3=(SELECT ta_cct17 FROM ta_cct_file WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22b3=(SELECT ta_cct18 FROM ta_cct_file WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22c3=(SELECT ta_cct19 FROM ta_cct_file WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22d3=(SELECT ta_cct20 FROM ta_cct_file WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
  AND ta_ccc01 IN(SELECT ta_cct01 FROM ta_cct_file WHERE ta_cct02=tm.yy AND ta_cct03=tm.mm) 

 UPDATE ta_ccp_file SET 
TA_CCC23A=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0
THEN ( ta_ccc12a+ta_ccc22a1+ta_ccc22a2+ta_ccc22a3+ta_ccc22a5+ta_ccc22a6 )
  /(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23B=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0 THEN (ta_ccc12b+ta_ccc22b1+ta_ccc22b2+ta_ccc22b3+ta_ccc22b5+ta_ccc22b6
)/(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23C=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0 THEN (ta_ccc12C+ta_ccc22C1+ta_ccc22C2+ta_ccc22C3+ta_ccc22C5+ta_ccc22C6
)/(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23D=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0 THEN (ta_ccc12D+ta_ccc22D1+ta_ccc22D2+ta_ccc22D3+ta_ccc22D5+ta_ccc22D6
)/(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23E=0,
TA_CCC23F=0
WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
AND ((ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216)<>0 )
AND INSTR(TA_CCC01,'.')=0 AND INSTR(TA_CCC01,'-')=0 

UPDATE  ta_ccP_file SET TA_CCC23=TA_CCC23A+TA_CCC23B+TA_CCC23C+TA_CCC23D--+TA_CCC23E+TA_CCC23F
WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm AND INSTR(TA_CCC01,'.')=0 AND INSTR(TA_CCC01,'-')=0  

UPDATE ta_ccp_file SET TA_CCCUD07=(ROUND(CASE WHEN nvl(ta_ccc18+ta_ccc31+ta_ccc25-ta_ccc27,0)=0 THEN 0
 ELSE (ta_ccc19a+ta_ccc31*ta_ccc23a+(ta_ccc25-ta_ccc27)*ta_ccc23a)/nvl(ta_ccc18+ta_ccc31+ta_ccc25-ta_ccc27,0) END,8) )
   ,TA_CCCUD08=(ROUND(CASE WHEN nvl(ta_ccc18+ta_ccc31+ta_ccc25-ta_ccc27,0)=0 THEN 0
 ELSE (ta_ccc19b+ta_ccc31*ta_ccc23b+(ta_ccc25-ta_ccc27)*ta_ccc23b)/nvl(ta_ccc18+ta_ccc31+ta_ccc25-ta_ccc27,0) END,8) )
   ,TA_CCCUD09=(ROUND(CASE WHEN nvl(ta_ccc18+ta_ccc31+TA_CCC81+ta_ccc25-ta_ccc27,0)=0 THEN 0
 ELSE (ta_ccc19c+ta_ccc31*ta_ccc23c+ta_ccc31*ta_ccc23e+(ta_ccc25-ta_ccc27)*(ta_ccc23c+ta_ccc23e))/nvl(ta_ccc18+ta_ccc31+TA_CCC81+ta_ccc25-ta_ccc27,0) END,8) )
   ,TA_CCCUD10=(ROUND(CASE WHEN nvl(ta_ccc18+ta_ccc31+TA_CCC81+ta_ccc25-ta_ccc27,0)=0 THEN 0
 ELSE (ta_ccc19d+ta_ccc31*ta_ccc23d+(ta_ccc25-ta_ccc27)*ta_ccc23d)/nvl(ta_ccc18+ta_ccc31+TA_CCC81+ta_ccc25-ta_ccc27,0) END,8) )
   ,TA_CCC66=ta_ccc23
   ,TA_CCC66A=ta_ccc23a
   ,TA_CCC66b=ta_ccc23b
   ,TA_CCC66c=ta_ccc23c
   ,TA_CCC66d=ta_ccc23d
   WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm AND instr(ta_ccc01,'.')=0 AND instr(ta_ccc01,'-')=0 

   UPDATE ta_ccp_file SET ta_ccc92=(CASE WHEN instr(ta_ccc01,'.')>0 THEN ta_ccc91*ta_ccc26 ELSE ta_ccc91*ta_ccc23 END)
                        ,ta_ccc92a=(CASE WHEN instr(ta_ccc01,'.')>0 THEN ta_ccc91*ta_ccc26a ELSE ta_ccc91*ta_ccc23a END)
                        ,ta_ccc92b=ta_ccc91*ta_ccc23b
                        ,ta_ccc92c=ta_ccc91*ta_ccc23c
                        ,ta_ccc92d=ta_ccc91*ta_ccc23d
                        ,ta_ccc92e=0
                        ,ta_ccc92f=0
                        ,ta_ccc99=ta_ccc98*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)
                        ,ta_ccc99a=ta_ccc98*ta_cccud07
                        ,ta_ccc99b=ta_ccc98*ta_cccud08
                        ,ta_ccc99c=ta_ccc98*ta_cccud09
                        ,ta_ccc99d=ta_ccc98*ta_cccud10
 WHERE ta_ccc01 IN(SELECT ta_imk01 FROM ta_imk_file WHERE ta_imk05=tm.yy AND ta_imk06=tm.mm)
 AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm

END FUNCTION