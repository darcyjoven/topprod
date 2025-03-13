# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cxcp820.4gl
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
   DECLARE p820_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW p820_w WITH FORM "cxc/42f/cxcp820"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊

   LET g_action_choice = ""
   CALL p820_curs()
   
   CLOSE WINDOW p820_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN

FUNCTION p820_curs()
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
       CLOSE WINDOW p820_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
    ELSE
       CALL p820_pro()
       IF cl_confirm('cxc-007') THEN
          CLOSE WINDOW p820_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
       ELSE
          CALL p820_curs()
       END IF
    END IF
END FUNCTION 

FUNCTION p820_pro()
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
  CALL p820_pre() #期别计算

  BEGIN WORK 
  CALL p820_del() #删除已存在的记录

  CALL p820_p()   #BOM计算

  IF g_success = 'Y' THEN
     CALL cl_end2(1) RETURNING l_flag
     COMMIT WORK
  ELSE 
     CALL cl_end2(2) RETURNING l_flag
     ROLLBACK WORK
  END IF 
END FUNCTION
#期别资料设置
FUNCTION p820_pre()  
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

FUNCTION p820_del()

  
END FUNCTION

FUNCTION p820_p()
  
  CALL p820_p_1()   #ex_imk

END FUNCTION

FUNCTION p820_p_1()  #ex_imk
  DEFINE l_n    LIKE type_file.num10
  DEFINE i,k    LIKE type_file.num10
  DEFINE l_date LIKE type_file.dat

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
           WHERE ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03
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
           WHERE ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 AND sfb01=ccg01
             AND ccg02=",tm.yy," AND ccg03=",tm.mm," AND a.sfa01=b1.sfa01 AND a.sfa27=b1.sfa27 AND b1.sfa16<>0
             AND a.sfa26 NOT in('0','1','2') AND substr(ccg04,7,1) IN('A') AND ccg01=a.sfa01 AND cch04=a.sfa03
             AND ccg04<>cch04 AND INSTR(ccg04,'-')=0 AND INSTR(cch04,'-')=0 AND cch31<>0
             AND cch04<>ccg04) a12
   WHERE bzxh<>0
   UNION ALL
  SELECT ",tm.yy,",",tm.mm,",ccg04,sfa27,cch04,cch31,sfa28,sfa16a,'N',bzxh,ccg01,'','f' 
    FROM (SELECT ccg04,sfa27,cch04,cch31,sfa28,(sfa13*CASE WHEN sfa16<=sfa161 THEN sfa16 ELSE sfa161 END) sfa16a,
                 (sfa13*ccg31*CASE WHEN sfa16<=sfa161 THEN sfa16 ELSE sfa161 END) AS bzxh,ccg01 FROM ccg_file,cch_file,sfa_file,sfb_file
           WHERE ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 AND sfb01=ccg01
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
           WHERE ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 AND sfb01=ccg01
             AND ccg02=",tm.yy," AND ccg03=",tm.mm," AND a.sfa01=b1.sfa01 AND a.sfa27=b1.sfa27 AND b1.sfa16<>0
             AND a.sfa26 NOT in('0','1','2') AND substr(ccg04,7,1) IN('F','R','G') AND ccg01=a.sfa01 AND cch04=a.sfa03
             AND ccg04<>cch04 AND INSTR(ccg04,'-')=0 AND INSTR(cch04,'-')=0 AND cch31<>0
             AND cch04<>ccg04) a12
   WHERE bzxh<>0"
  PREPARE p810_p1 FROM g_sql
  EXECUTE p810_p1

  LET g_sql = 
  "INSERT INTO ex_ccg_3
  SELECT ccg04,sfa27,cch04,CASE WHEN cch31<bzxh THEN bzxh ELSE cch31 END cch31,sfa28,sfa16a,'N',bzxh,ccg01,'' 
    FROM (SELECT ccg04,sfa27,cch04,cch31,sfa28,(sfa13*CASE WHEN sfa16<=sfa161 THEN sfa16 ELSE sfa161 END) sfa16a,
                 (sfa13*ccg31*CASE WHEN sfa16<=sfa161 THEN sfa16 ELSE sfa161 END) AS bzxh,ccg01 FROM ccg_file,cch_file,sfa_file,sfb_file
           WHERE ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 AND sfb01=ccg01
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
           WHERE ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 AND sfb01=ccg01
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
           WHERE ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 AND sfb01=ccg01
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
           WHERE ccg01=cch01 AND ccg02=cch02 AND ccg03=cch03 AND sfb01=ccg01
             AND ccg02=",tm.yy," AND ccg03=",tm.mm," AND a.sfa01=b1.sfa01 AND a.sfa27=b1.sfa27 AND b1.sfa16<>0
             AND a.sfa26 NOT in('0','1','2') AND substr(ccg04,7,1) IN('F','R','G') AND ccg01=a.sfa01 AND cch04=a.sfa03
             AND ccg04<>cch04 AND INSTR(ccg04,'-')=0 AND INSTR(cch04,'-')=0 AND cch31<>0
             AND cch04<>ccg04) a12
   WHERE bzxh<>0"
  PREPARE p810_p2 FROM g_sql
  EXECUTE p810_p2

  DELETE FROM ta_cca_file
  LET g_sql = 
  "INSERT INTO ta_cca_file
  SELECT imk01,SUM(imk09) 
    FROM (SELECT imk01,imk09 FROM imk_file WHERE imk05=",e_yy," AND imk06=",e_mm,"
           UNION
          SELECT cch04,cch91 FROM cch_file,sfb_file 
           WHERE cch02=",e_yy," AND cch03=",e_mm,"
             AND sfb01=cch01
             AND ((sfb38 is null AND '",g_today,"' > '",e_date,"') OR
                  (sfb38 is not null AND sfb38 > '",e_date,"'))) a
   GROUP BY imk01"
  PREPARE p810_p3 FROM g_sql
  EXECUTE p810_p3

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
      PREPARE p810_p4 FROM g_sql
      EXECUTE p810_p4

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
    PREPARE p810_p5 FROM g_sql
    EXECUTE p810_p5
             
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