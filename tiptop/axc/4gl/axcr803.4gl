# Prog. Version..: '5.30.06-13.03.29(00003)'     #
#
# Pattern name...: axcr803.4gl
# Descriptions...: 客戶發出商品進銷存表列印
# Date & Author..: No.FUN-C60036 12/06/20 By xuxz
# Modify.........: No.FUN-CA0084 12/10/31 By xuxz cfb--->occ01
# Modify.........: No:MOD-CB0110 12/11/12 By wujie 默认账套带ccz12,默认成本计算类型带ccz28，默认年月带ccz01，ccz02
# Modify.........: No:TQC-D20046 13/02/27 By qiull 修改發出商品相關問題

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE g_wc    STRING    #QBE條件
DEFINE g_wc2   STRING 
DEFINE tm      RECORD    #INPUT
         yy    LIKE type_file.chr4,
         mm    LIKE type_file.chr2,
         ccc07 LIKE ccc_file.ccc07,
         ccc08 LIKE ccc_file.ccc08,
         cb1   LIKE type_file.chr1,
         more  LIKE type_file.chr1
               END RECORD 
         
DEFINE g_sql   STRING 
DEFINE g_flag  LIKE type_file.chr1
DEFINE g_str   STRING 
DEFINE g_change_lang    LIKE type_file.chr1
DEFINE g_rec_b LIKE type_file.num10
DEFINE l_table STRING
DEFINE g_occ   RECORD 
         occ01 LIKE occ_file.occ01,
         occ02 LIKE occ_file.occ02,
         ima01 LIKE ima_file.ima01,
         ima02 LIKE ima_file.ima02,        #TQC-D20046---qiull---add---
         ima021 LIKE ima_file.ima021,      #TQC-D20046---qiull---add---
         n1    LIKE type_file.num20_6,
         m1    LIKE type_file.num20_6,
         n2    LIKE type_file.num20_6,
         m2    LIKE type_file.num20_6,
         n3    LIKE type_file.num20_6,
         m3    LIKE type_file.num20_6,
         n4    LIKE type_file.num20_6,
         m4    LIKE type_file.num20_6,
         n5    LIKE type_file.num20_6,
         m5    LIKE type_file.num20_6,
         n6    LIKE type_file.num20_6,
         m6    LIKE type_file.num20_6
               END RECORD 
DEFINE g_oaz93 LIKE oaz_file.oaz93
DEFINE g_oaz95 LIKE oaz_file.oaz95
MAIN 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF

   #判讀oaz93是否為Y，為Y才運行，不為Y則報錯：系統參數做發出商品管理，本作業不可以執行，請運行axcq802&axcr802
   SELECT oaz93,oaz95 INTO g_oaz93,g_oaz95 FROM oaz_file
   SELECT oaz95 INTO g_oaz.oaz95 FROM oaz_file
   IF g_oaz93 != 'Y' THEN 
      CALL cl_err('','axc-126',1)
      EXIT PROGRAM 
   END IF 
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   #"axcr803 '",g_wc,"' '",g_wc2,"' '",tm.yy,"' '",tm.mm,"' '",tm.ccc07,"' '",tm.ccc08,"' '",tm.cb1,"' '",tm.more
   LET g_wc = ARG_VAL(1)
   LET g_wc = cl_replace_str(g_wc,"\\\"","'")
   LET g_wc2 = ARG_VAL(2)
   LET g_wc2 = cl_replace_str(g_wc2,"\\\"","'")
   LET tm.yy = ARG_VAL(3)
   LET tm.mm = ARG_VAL(4)
   LET tm.ccc07 = ARG_VAL(5)
   LET tm.ccc08 = ARG_VAL(6)
   LET tm.cb1 = ARG_VAL(7)
   LET tm.more = ARG_VAL(8)
   LET g_bgjob = ARG_VAL(9)
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF 
   LET g_sql = " occ01.occ_file.occ01,",
               " occ02.occ_file.occ02,",
               " ima01.ima_file.ima01,",
               " ima02.ima_file.ima02,",     #TQC-D20046---add---
               " ima021.ima_file.ima021,",   #TQC-D20046---add---
               " n1.type_file.num20_6,",
               " m1.type_file.num20_6,",
               " n2.type_file.num20_6,",
               " m2.type_file.num20_6,",
               " n3.type_file.num20_6,",
               " m3.type_file.num20_6,",
               " n4.type_file.num20_6,",
               " m4.type_file.num20_6,",
               " n5.type_file.num20_6,",
               " m5.type_file.num20_6,",
               " n6.type_file.num20_6,",
               " m6.type_file.num20_6"
   LET l_table = cl_prt_temptable('axcr803',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,? ,?,?,?,?,? ,?,?,?,?,?, ?,?)"          #TQC-D20046---add>2個?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'N' THEN 
      CALL r803_tm()
   ELSE 
      CALL r803()
   END IF 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   
END MAIN

FUNCTION r803_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_pja01        LIKE pja_file.pja01,
          l_imd09        LIKE imd_file.imd09

   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE 
      LET p_row = 4 LET p_col = 12
   END IF

   #打開acxr803的畫面輸入查詢條件
   OPEN WINDOW r803_w1 AT p_row,p_col
        WITH FORM "axc/42f/axcr803"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL cl_set_comp_entry('ccc08',FALSE) 
   CALL cl_opmsg('q')

   
   #初始化
   INITIALIZE tm.* TO NULL
   WHILE TRUE
      DIALOG attributes(UNBUFFERED)
         CONSTRUCT BY NAME g_wc ON occ01
      
            BEFORE CONSTRUCT 
               LET tm.cb1 = 'N'
               LET tm.more = 'N'
               LET tm.ccc08 = ' '
               
         END CONSTRUCT 
         CONSTRUCT BY NAME g_wc2 ON ima01
      
            BEFORE CONSTRUCT 
               CALL cl_qbe_init()
         END CONSTRUCT 

      INPUT BY NAME tm.yy,tm.mm,tm.ccc07,tm.ccc08,tm.cb1,tm.more
#No.MOD-CB0110 --begin
         BEFORE INPUT 
            LET tm.yy = g_ccz.ccz01
            LET tm.mm = g_ccz.ccz02
            LET tm.ccc07 = g_ccz.ccz28
            DISPLAY BY NAME tm.yy,tm.mm,tm.ccc07
#No.MOD-CB0110 --end

         AFTER FIELD yy
            IF NOT cl_null(tm.yy) THEN 
               IF tm.yy  < 0 THEN 
                  CALL cl_err('','ask-003',0)
                  NEXT FIELD yy
               END IF 
               IF length(tm.yy) <>'4' THEN 
                  CALL cl_err('','ask-003',0)
                  NEXT FIELD yy
               END IF 
            END IF 
         AFTER FIELD mm
            IF NOT cl_null(tm.mm) THEN 
               IF tm.mm >13 THEN 
                  CALL cl_err('','agl-013',0)
                  NEXT FIELD mm
               END IF 
               IF tm.mm < 1 THEN
                  CALL cl_err('','agl-013',0)
                  NEXT FIELD mm 
               END IF 
            END IF 
            
         ON CHANGE ccc07
            IF tm.ccc07 MATCHES '[34]' THEN
               CALL cl_set_comp_entry('ccc08',TRUE) 
            ELSE
               CALL cl_set_comp_entry('ccc08',FALSE) 
            END IF 
            
         AFTER FIELD ccc08
            IF NOT cl_null(tm.ccc08) OR tm.ccc08 != ' '  THEN
               IF tm.ccc07='4'THEN
                  SELECT pja01 INTO l_pja01 FROM pja_file WHERE pja01=tm.ccc08
                                             AND pjaclose='N'     
                  IF STATUS THEN
                     CALL cl_err3("sel","pja_file",tm.ccc08,"",STATUS,"","sel pja:",1)
                     NEXT FIELD ccc08
                  END IF
               END IF
               IF tm.ccc07='5'THEN
                  SELECT UNIQUE imd09 INTO l_imd09 FROM imd_file WHERE imd09=tm.ccc08
                  IF STATUS THEN
                     CALL cl_err3("sel","imd_file",tm.ccc08,"",STATUS,"","sel imd:",1)   
                     NEXT FIELD ccc08
                  END IF
               END IF
            ELSE 
               LET tm.ccc08 = ' '
            END IF
            
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF

            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
      END INPUT

      ON ACTION controlp
         CASE 
            WHEN INFIELD(occ01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_occ"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO occ01
              #NEXT FIELD cfb07#FUN-cA0084 mark 20121031
               NEXT FIELD occ01#FUN-CA0084 add 20121031
            WHEN INFIELD(ima01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ima01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            WHEN INFIELD(ccc08)                                               
                 IF tm.ccc07 MATCHES '[45]' THEN                             
                    CALL cl_init_qry_var()       
                 CASE tm.ccc07                                               
                    WHEN '4'                                                    
                      LET g_qryparam.form = "q_pja"                             
                    WHEN '5'                                                    
                      LET g_qryparam.form = "q_gem4"                            
                    OTHERWISE EXIT CASE                                         
                 END CASE                                                       
                 LET g_qryparam.default1 = tm.ccc08   
                 CALL cl_create_qry() RETURNING tm.ccc08                     
                 DISPLAY BY NAME  tm.ccc08                                   
                 NEXT FIELD ccc08                                               
                 END IF
            OTHERWISE
               EXIT CASE
         END CASE
         
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
                
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG
                 
      ON ACTION about         
         CALL cl_about()      
                  
      ON ACTION help          
         CALL cl_show_help()  
                  
      ON ACTION controlg      
         CALL cl_cmdask()     
              
      ON ACTION ACCEPT
         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF 
         IF cl_null(tm.mm) THEN NEXT FIELD mm END IF
         IF cl_null(tm.ccc07) THEN NEXT FIELD ccc07 END IF
         EXIT DIALOG
         
      ON ACTION EXIT
         LET INT_FLAG = TRUE
         EXIT DIALOG
             
      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG

      ON ACTION locale 
         LET g_change_lang = TRUE
         CALL cl_dynamic_locale()    
         CALL cl_show_fld_cont()
            
      END DIALOG
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r803_w1
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT WHILE
      END IF
      CALL cl_wait()
      CALL r803()
      ERROR ""
      
   END WHILE
   CLOSE WINDOW r803_w1 

END FUNCTION 

FUNCTION r803()
   DEFINE l_occ01   LIKE occ_file.occ01,
          l_ima01   LIKE ima_file.ima01,
          l_mm      LIKE type_file.chr2,
          l_yy      LIKE type_file.chr4
   DEFINE l_sql     STRING, 
          l_wc      STRING,
          l_wc2     STRING,
          l_wc3     STRING,
          temp_ima01 STRING
   DEFINE l_name    LIKE type_file.chr20         
   DEFINE l_chr     LIKE type_file.chr1          
   DEFINE amt1      LIKE type_file.num20_6       
   DEFINE amt1_1    LIKE type_file.num20_6       
   DEFINE l_tmp     LIKE type_file.num20_6       

    CALL cl_del_data(l_table)
    
   #年度期別處理以及其他初始化
   LET g_rec_b = 0
   IF tm.mm = 1 THEN 
      LET l_mm = 1
      LET l_yy = tm.yy - 1
   ELSE 
      LET l_mm = tm.mm - 1
      LET l_yy = tm.yy
   END IF 
   
   LET l_wc = g_wc2
   LET l_wc2= cl_replace_str(l_wc,'ima01','imk01')
   LET l_wc3= cl_replace_str(l_wc,'ima01','tlfc01')
   #本作業主要sql
   IF tm.cb1 = 'Y' THEN 
      LET g_sql = " SELECT DISTINCT occ01,ima01 "
   ELSE    
      LET g_sql = " SELECT DISTINCT occ01,'' "
   END IF 
  #LET g_sql = g_sql, " FROM ima_file ,imk_file,occ_file,oga_file ",
  #            " WHERE ima01 = imk01 AND imk03 = occ01 ",
  #            "   AND occ01 = oga03 AND occacti = 'Y' AND ogapost = 'Y' ",
  #            "   AND imk05 = ",tm.yy," AND imk06 = ",tm.mm,
  #            "   AND ",g_wc,
  #            "   AND ",g_wc2
   LET g_sql = g_sql," FROM ima_file,occ_file,tlf_file ",
               " WHERE occacti = 'Y' ",
               "   AND ima01 = tlf01 AND occ01 = tlf19 ",
               "   AND  YEAR(tlf06)= '",tm.yy,"'",
               "   AND MONTH(tlf06)= '",tm.mm,"'",
               "   AND (tlf13 = 'aomt800' OR tlf13 like 'axmt6%') ",
               "   AND ",g_wc,
               "   AND ",g_wc2
   PREPARE q803_pre FROM g_sql
   DECLARE q803_cs  CURSOR FOR q803_pre
   IF NOT cl_null(tm.ccc08) THEN 
      FOREACH q803_cs INTO l_occ01,l_ima01
         IF tm.cb1 = 'Y' THEN
            LET temp_ima01 = l_ima01
            IF temp_ima01.substring(1,4) = "MISC" THEN
               CONTINUE FOREACH
            END IF
         END IF
         #g_rec_b賦值
         LET g_rec_b = g_rec_b + 1
         #occ01,occ02
         SELECT occ01,occ02 INTO g_occ.occ01,g_occ.occ02
           FROM oga_file,occ_file 
          WHERE occ01 = oga03 AND occacti='Y' 
            AND ogapost='Y'   AND occ01 = l_occ01
         LET g_occ.ima01 = l_ima01
         #TQC-D20046---qiull---add---str---
         SELECT ima02,ima021 INTO g_occ.ima02,g_occ.ima021
           FROM ima_file
          WHERE ima01 = g_occ.ima01
         #TQC-D20046---qiull---add---end---
         #期初數量，期初金額
      
         IF tm.cb1 = 'Y' THEN 
            #期初數量
            SELECT SUM(imk09) INTO g_occ.n1
              FROM imk_file,ccc_file 
             WHERE imf02 = g_oaz95  AND imk03 = g_occ.occ01 
               AND imk05 = l_yy     AND imk06 = l_mm 
               AND imk01 = l_ima01  AND imk01=ccc01
               AND ccc02 = l_yy     AND ccc03 = l_mm
               AND ccc07 = tm.ccc07 AND ccc08 = tm.ccc08
           #期初金額
           SELECT SUM(imk09*ccc23) INTO g_occ.m1
             FROM imk_file,ccc_file 
            WHERE imk02 = g_oaz95  AND imk03 = g_occ.occ01 
              AND imk01=ccc01      AND imk01 = l_ima01 
              AND imk05 = l_yy     AND imk06 = l_mm 
              AND ccc02 = l_yy     AND ccc03 = l_mm
              AND ccc07 = tm.ccc07 AND ccc08 = tm.ccc08
         ELSE
            #期初金額
            LET l_sql = " SELECT SUM(imk09*ccc23) ",
                     "   FROM imk_file,ccc_file ",
                     "  WHERE imk02 = '",g_oaz95 ,"'",
                     "    AND imk03 = '",g_occ.occ01 ,"'",
                     "    AND imk01=ccc01 ",     
                     "    AND ",l_wc2 ,
                     "    AND imk05 = '",l_yy ,"'",   
                     "    AND imk06 = '",l_mm ,"'",
                     "    AND ccc02 = '",l_yy ,"'",  
                     "    AND ccc03 = '",l_mm ,"'",
                     "    AND ccc07 = '",tm.ccc07 ,"'",
                     "    AND ccc08 = '",tm.ccc08 ,"'"
            PREPARE p803_imk09 FROM l_sql
            EXECUTE p803_imk09 INTO g_occ.m1
         END IF 
         #本月出貨轉入數量與金額，本月出貨轉出數量與金額，本月銷退轉入數量與金額，本月銷退轉出數量與金額
         IF tm.cb1 = 'Y' THEN 
            #本月出貨轉入數量與金額
            SELECT SUM (tlf10*tlf60) INTO g_occ.n2 FROM tlf_file 
             WHERE YEAR(tlf06)=tm.yy 
               AND MONTH(tlf06)=tm.mm 
               AND tlf13 like 'axmt6%' AND tlf13<>'axmt670'
               AND tlf19=g_occ.occ01
               AND tlf907=-1
               AND tlf01 = l_ima01
               AND tlf902<>g_oaz.oaz95
               AND tlfcost = tm.ccc08
            
            SELECT SUM(tlfc21) INTO g_occ.m2 FROM tlfc_file LEFT  OUTER  JOIN 
              tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
                       AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
                       AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
             WHERE YEAR(tlfc06)=tm.yy 
               AND MONTH(tlfc06)=tm.mm 
               AND tlfc13 like 'axmt6%' AND tlfc13<>'axmt670' 
               AND tlf19=g_occ.occ01
               AND tlfc907=-1 
               AND tlfctype=tm.ccc07
               AND tlfc902<>g_oaz.oaz95
               AND tlfc01 = l_ima01
               AND tlfccost = tm.ccc08
            
            #本月出貨轉出數量與金額
            SELECT SUM (tlf10*tlf60) INTO g_occ.n3 FROM tlf_file 
             WHERE YEAR(tlf06)=tm.yy 
               AND MONTH(tlf06)=tm.mm 
               AND tlf13='axmt670' 
               AND tlf19=g_occ.occ01
               AND tlf907=-1
               AND tlf01 = l_ima01
               AND tlfcost = tm.ccc08
            
            SELECT SUM(tlfc21) INTO g_occ.m3  FROM tlfc_file LEFT  OUTER  JOIN 
              tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
                       AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
                       AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
             WHERE YEAR(tlfc06)=tm.yy 
               AND MONTH(tlfc06)=tm.mm 
               AND tlfc13='axmt670' 
               AND tlf19=g_occ.occ01
               AND tlfc907=-1 
               AND tlfctype=tm.ccc07
               AND tlfc01 = l_ima01
               AND tlfccost = tm.ccc08

            #本月銷退轉入數量與金額
            SELECT SUM (tlf10*tlf60) INTO g_occ.n4 FROM tlf_file 
             WHERE YEAR(tlf06)=tm.yy 
               AND MONTH(tlf06)=tm.mm 
               AND tlf13='aomt800' 
               AND tlf907=1
               AND tlf19=g_occ.occ01
               AND tlf902<>g_oaz.oaz95
               AND tlf01 = l_ima01
               AND tlfcost = tm.ccc08
            
            SELECT SUM(tlfc21) INTO g_occ.m4 FROM tlfc_file LEFT  OUTER  JOIN 
              tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
                       AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
                       AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
             WHERE YEAR(tlfc06)=tm.yy 
               AND MONTH(tlfc06)=tm.mm 
               AND tlfc13='aomt800' 
               AND tlf19=g_occ.occ01
               AND tlf907=1
               AND tlfctype=tm.ccc07
               AND tlfc902<>g_oaz.oaz95
               AND tlfc01 = l_ima01
               AND tlfccost = tm.ccc08
            
            #本月銷退轉出數量與金額
            SELECT SUM (tlf10*tlf60) INTO g_occ.n5 FROM tlf_file 
             WHERE YEAR(tlf06)=tm.yy 
               AND MONTH(tlf06)=tm.mm 
               AND tlf13='axmt670' 
               AND tlf19=g_occ.occ01
               AND tlf907=1
               AND tlf01 = l_ima01
               AND tlfcost = tm.ccc08
            
            SELECT SUM(tlfc21) INTO g_occ.m5 FROM tlfc_file LEFT  OUTER  JOIN 
              tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
                       AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
                       AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
             WHERE YEAR(tlfc06)=tm.yy 
               AND MONTH(tlfc06)=tm.mm 
               AND tlfc13='axmt670' 
               AND tlf19=g_occ.occ01
               AND tlfc907=1 
               AND tlfctype=tm.ccc07
               AND tlfc01 = l_ima01
               AND tlfccost = tm.ccc08
         ELSE
            #本月出貨轉入金額
            LET l_sql = " SELECT SUM(tlfc21) FROM tlfc_file ",
                     " LEFT  OUTER  JOIN tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02 ",
                     "    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903 ",
                     "    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906 ",
                     "  WHERE YEAR(tlfc06)= '",tm.yy ,"'",
                     "    AND MONTH(tlfc06)='",tm.mm ,"'",
                     "    AND tlfc13 like 'axmt6%' AND tlfc13<>'axmt670' ",
                     "    AND tlf19= '",g_occ.occ01 ,"'",
                     "    AND tlfc907= -1 ",
                     "    AND tlfctype= '",tm.ccc07,"'",
                     "    AND tlfccost = '",tm.ccc08,"'",
                     "    AND tlfc902<>'",g_oaz.oaz95,"'",
                     "    AND ",l_wc3
            PREPARE p803_tlfc21_2 FROM l_sql
            EXECUTE p803_tlfc21_2 INTO g_occ.m2
         
            #本月出貨轉出金額
            LET l_sql = " SELECT SUM(tlfc21) FROM tlfc_file ",
                     " LEFT  OUTER  JOIN tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02 ",
                     "    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903 ",
                     "    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906 ",
                     "  WHERE YEAR(tlfc06)= '",tm.yy ,"'",
                     "    AND MONTH(tlfc06)='",tm.mm ,"'",
                     "    AND tlfc13='axmt670' ",
                     "    AND tlf19= '",g_occ.occ01 ,"'",
                     "    AND tlfc907= -1 ",
                     "    AND tlfctype= '",tm.ccc07,"'",
                     "    AND tlfccost = '",tm.ccc08,"'",
                     "    AND ",l_wc3
            PREPARE p803_tlfc21_3 FROM l_sql
            EXECUTE p803_tlfc21_3 INTO g_occ.m3

            #本月銷退轉入金額
            LET l_sql = " SELECT SUM(tlfc21) FROM tlfc_file " ,
                     " LEFT  OUTER  JOIN tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02 ",
                     "    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903 ",
                     "    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906 ",
                     "  WHERE YEAR(tlfc06)='",tm.yy ,"'",
                     "    AND MONTH(tlfc06)='",tm.mm ,"'",
                     "    AND tlfc13='aomt800' ",
                     "    AND tlf19='",g_occ.occ01,"'",
                     "    AND tlf907=1 ",
                     "    AND tlfctype='",tm.ccc07,"'",
                     "    AND tlfc902<>'",g_oaz.oaz95,"'",
                     "    AND tlfccost = '",tm.ccc08,"'",
                     "    AND ",l_wc3
            PREPARE p803_tlfc21_4 FROM l_sql
            EXECUTE p803_tlfc21_4 INTO g_occ.m4
            #本月銷退轉出金額
            LET l_sql = " SELECT SUM(tlfc21) FROM tlfc_file " ,
                     " LEFT  OUTER  JOIN tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02 ",
                     "    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903 ",
                     "    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906 ",
                     "  WHERE YEAR(tlfc06)='",tm.yy ,"'",
                     "    AND MONTH(tlfc06)='",tm.mm ,"'",
                     "    AND tlfc13='axmt670' ",
                     "    AND tlf19='",g_occ.occ01,"'",
                     "    AND tlf907=1 ",
                     "    AND tlfctype='",tm.ccc07,"'",
                     "    AND tlfccost = '",tm.ccc08,"'",
                     "    AND ",l_wc3
            PREPARE p803_tlfc21_5 FROM l_sql
            EXECUTE p803_tlfc21_5 INTO g_occ.m5
         END IF 
         #數值欄位如果為null給0
         IF tm.cb1 = 'Y' THEN 
            IF cl_null(g_occ.n1) THEN LET g_occ.n1 = 0 END IF 
            IF cl_null(g_occ.n2) THEN LET g_occ.n2 = 0 END IF
            IF cl_null(g_occ.n3) THEN LET g_occ.n3 = 0 END IF
            IF cl_null(g_occ.n4) THEN LET g_occ.n4 = 0 END IF
            IF cl_null(g_occ.n5) THEN LET g_occ.n5 = 0 END IF
            IF cl_null(g_occ.n6) THEN LET g_occ.n6 = 0 END IF
         END IF 
         IF cl_null(g_occ.m1) THEN LET g_occ.m1 = 0 END IF 
         IF cl_null(g_occ.m2) THEN LET g_occ.m2 = 0 END IF
         IF cl_null(g_occ.m3) THEN LET g_occ.m3 = 0 END IF
         IF cl_null(g_occ.m4) THEN LET g_occ.m4 = 0 END IF
         IF cl_null(g_occ.m5) THEN LET g_occ.m5 = 0 END IF
         IF cl_null(g_occ.m6) THEN LET g_occ.m6 = 0 END IF
         #期末數量，期末金額
         IF tm.cb1 = 'Y' THEN 
            LET g_occ.n6 = g_occ.n1 +g_occ.n2 -g_occ.n3 +g_occ.n4 -g_occ.n5
         END IF 
         LET g_occ.m6 = g_occ.m1 +g_occ.m2 -g_occ.m3 +g_occ.m4 -g_occ.m5
         EXECUTE insert_prep USING g_occ.*
      
      END FOREACH
   ELSE 
      FOREACH q803_cs INTO l_occ01,l_ima01
         IF tm.cb1 = 'Y' THEN
            LET temp_ima01 = l_ima01
            IF temp_ima01.substring(1,4) = "MISC" THEN
               CONTINUE FOREACH
            END IF
         END IF
         #g_rec_b賦值
         LET g_rec_b = g_rec_b + 1
         #occ01,occ02
         SELECT occ01,occ02 INTO g_occ.occ01,g_occ.occ02
           FROM oga_file,occ_file 
          WHERE occ01 = oga03 AND occacti='Y' 
            AND ogapost='Y'   AND occ01 = l_occ01
         LET g_occ.ima01 = l_ima01
         #TQC-D20046---qiull---add---str---
         SELECT ima02,ima021 INTO g_occ.ima02,g_occ.ima021
           FROM ima_file
          WHERE ima01 = g_occ.ima01
         #TQC-D20046---qiull---add---end---
         #期初數量，期初金額
      
         IF tm.cb1 = 'Y' THEN 
            #期初數量
            SELECT SUM(imk09) INTO g_occ.n1
              FROM imk_file,ccc_file 
             WHERE imf02 = g_oaz95  AND imk03 = g_occ.occ01 
               AND imk05 = l_yy     AND imk06 = l_mm 
               AND imk01 = l_ima01  AND imk01=ccc01
               AND ccc02 = l_yy     AND ccc03 = l_mm
               AND ccc07 = tm.ccc07 AND (ccc08 = tm.ccc08 OR ccc08 IS NULL )
           #期初金額
           SELECT SUM(imk09*ccc23) INTO g_occ.m1
             FROM imk_file,ccc_file 
            WHERE imk02 = g_oaz95  AND imk03 = g_occ.occ01 
              AND imk01=ccc01      AND imk01 = l_ima01 
              AND imk05 = l_yy     AND imk06 = l_mm 
              AND ccc02 = l_yy     AND ccc03 = l_mm
              AND ccc07 = tm.ccc07 AND (ccc08 = tm.ccc08 OR ccc08 IS NULL )
         ELSE
            #期初金額
            LET l_sql = " SELECT SUM(imk09*ccc23) ",
                     "   FROM imk_file,ccc_file ",
                     "  WHERE imk02 = '",g_oaz95 ,"'",
                     "    AND imk03 = '",g_occ.occ01 ,"'",
                     "    AND imk01=ccc01 ",     
                     "    AND ",l_wc2 ,
                     "    AND imk05 = '",l_yy ,"'",   
                     "    AND imk06 = '",l_mm ,"'",
                     "    AND ccc02 = '",l_yy ,"'",  
                     "    AND ccc03 = '",l_mm ,"'",
                     "    AND ccc07 = '",tm.ccc07 ,"'",
                     "    AND (ccc08 = '",tm.ccc08 ,"' OR ccc08 IS NULL )"
            PREPARE p803_imk09_1 FROM l_sql
            EXECUTE p803_imk09_1 INTO g_occ.m1
         END IF 
         #本月出貨轉入數量與金額，本月出貨轉出數量與金額，本月銷退轉入數量與金額，本月銷退轉出數量與金額
         IF tm.cb1 = 'Y' THEN 
            #本月出貨轉入數量與金額
            SELECT SUM (tlf10*tlf60) INTO g_occ.n2 FROM tlf_file 
             WHERE YEAR(tlf06)=tm.yy 
               AND MONTH(tlf06)=tm.mm 
               AND tlf13 like 'axmt6%' AND tlf13<>'axmt670'
               AND tlf19=g_occ.occ01
               AND tlf907=-1
               AND tlf01 = l_ima01
               AND tlf902<>g_oaz.oaz95
               AND (tlfcost = tm.ccc08 OR tlfcost IS NULL )
            
            SELECT SUM(tlfc21) INTO g_occ.m2 FROM tlfc_file LEFT  OUTER  JOIN 
              tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
                       AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
                       AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
             WHERE YEAR(tlfc06)=tm.yy 
               AND MONTH(tlfc06)=tm.mm 
               AND tlfc13 like 'axmt6%' AND tlfc13<>'axmt670' 
               AND tlf19=g_occ.occ01
               AND tlfc907=-1 
               AND tlfctype=tm.ccc07
               AND tlfc01 = l_ima01
               AND tlfc902<>g_oaz.oaz95
               AND (tlfccost = tm.ccc08 OR tlfccost IS NULL )
            
            #本月出貨轉出數量與金額
            SELECT SUM (tlf10*tlf60) INTO g_occ.n3 FROM tlf_file 
             WHERE YEAR(tlf06)=tm.yy 
               AND MONTH(tlf06)=tm.mm 
               AND tlf13='axmt670' 
               AND tlf19=g_occ.occ01
               AND tlf907=-1
               AND tlf01 = l_ima01
               AND (tlfcost = tm.ccc08 OR tlfcost IS NULL )
            
            SELECT SUM(tlfc21) INTO g_occ.m3  FROM tlfc_file LEFT  OUTER  JOIN 
              tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
                       AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
                       AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
             WHERE YEAR(tlfc06)=tm.yy 
               AND MONTH(tlfc06)=tm.mm 
               AND tlfc13='axmt670' 
               AND tlf19=g_occ.occ01
               AND tlfc907=-1 
               AND tlfctype=tm.ccc07
               AND tlfc01 = l_ima01
               AND (tlfccost = tm.ccc08 OR tlfccost IS NULL )

            #本月銷退轉入數量與金額
            SELECT SUM (tlf10*tlf60) INTO g_occ.n4 FROM tlf_file 
             WHERE YEAR(tlf06)=tm.yy 
               AND MONTH(tlf06)=tm.mm 
               AND tlf13='aomt800' 
               AND tlf907=1
               AND tlf19=g_occ.occ01
               AND tlf01 = l_ima01
               AND tlf902<>g_oaz.oaz95
               AND (tlfcost = tm.ccc08 OR tlfcost IS NULL )
            
            SELECT SUM(tlfc21) INTO g_occ.m4 FROM tlfc_file LEFT  OUTER  JOIN 
              tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
                       AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
                       AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
             WHERE YEAR(tlfc06)=tm.yy 
               AND MONTH(tlfc06)=tm.mm 
               AND tlfc13='aomt800' 
               AND tlf19=g_occ.occ01
               AND tlf907=1
               AND tlfctype=tm.ccc07
               AND tlfc01 = l_ima01
               AND (tlfccost = tm.ccc08 OR tlfccost IS NULL )
            
            #本月銷退轉出數量與金額
            SELECT SUM (tlf10*tlf60) INTO g_occ.n5 FROM tlf_file 
             WHERE YEAR(tlf06)=tm.yy 
               AND MONTH(tlf06)=tm.mm 
               AND tlf13='axmt670' 
               AND tlf19=g_occ.occ01
               AND tlf907=1
               AND tlf01 = l_ima01
               AND tlfc902<>g_oaz.oaz95
               AND (tlfcost = tm.ccc08 OR tlfcost IS NULL )
            
            SELECT SUM(tlfc21) INTO g_occ.m5 FROM tlfc_file LEFT  OUTER  JOIN 
              tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
                       AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
                       AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
             WHERE YEAR(tlfc06)=tm.yy 
               AND MONTH(tlfc06)=tm.mm 
               AND tlfc13='axmt670' 
               AND tlf19=g_occ.occ01
               AND tlfc907=1 
               AND tlfctype=tm.ccc07
               AND tlfc01 = l_ima01
               AND (tlfccost = tm.ccc08 OR tlfccost IS NULL )
         ELSE
            #本月出貨轉入金額
            LET l_sql = " SELECT SUM(tlfc21) FROM tlfc_file ",
                     " LEFT  OUTER  JOIN tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02 ",
                     "    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903 ",
                     "    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906 ",
                     "  WHERE YEAR(tlfc06)= '",tm.yy ,"'",
                     "    AND MONTH(tlfc06)='",tm.mm ,"'",
                     "    AND tlfc13 like 'axmt6%' AND tlfc13<>'axmt670' ",
                     "    AND tlf19= '",g_occ.occ01 ,"'",
                     "    AND tlfc907= -1 ",
                     "    AND tlfctype= '",tm.ccc07,"'",
                     "    AND tlfc902<>'",g_oaz.oaz95,"'",
                     "    AND (tlfccost = '",tm.ccc08,"' OR tlfccost IS NULL )",
                     "    AND ",l_wc3
            PREPARE p803_tlfc21_2_1 FROM l_sql
            EXECUTE p803_tlfc21_2_1 INTO g_occ.m2
         
            #本月出貨轉出金額
            LET l_sql = " SELECT SUM(tlfc21) FROM tlfc_file ",
                     " LEFT  OUTER  JOIN tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02 ",
                     "    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903 ",
                     "    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906 ",
                     "  WHERE YEAR(tlfc06)= '",tm.yy ,"'",
                     "    AND MONTH(tlfc06)='",tm.mm ,"'",
                     "    AND tlfc13='axmt670' ",
                     "    AND tlf19= '",g_occ.occ01 ,"'",
                     "    AND tlfc907= -1 ",
                     "    AND tlfctype= '",tm.ccc07,"'",
                     "    AND (tlfccost = '",tm.ccc08,"' OR tlfccost IS NULL )",
                     "    AND ",l_wc3
            PREPARE p803_tlfc21_3_1 FROM l_sql
            EXECUTE p803_tlfc21_3_1 INTO g_occ.m3

            #本月銷退轉入金額
            LET l_sql = " SELECT SUM(tlfc21) FROM tlfc_file " ,
                     " LEFT  OUTER  JOIN tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02 ",
                     "    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903 ",
                     "    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906 ",
                     "  WHERE YEAR(tlfc06)='",tm.yy ,"'",
                     "    AND MONTH(tlfc06)='",tm.mm ,"'",
                     "    AND tlfc13='aomt800' ",
                     "    AND tlf19='",g_occ.occ01,"'",
                     "    AND tlf907=1 ",
                     "    AND tlfctype='",tm.ccc07,"'",
                     "    AND tlfc902<>'",g_oaz.oaz95,"'",
                     "    AND (tlfccost = '",tm.ccc08,"' OR tlfccost IS NULL )",
                     "    AND ",l_wc3
            PREPARE p803_tlfc21_4_1 FROM l_sql
            EXECUTE p803_tlfc21_4_1 INTO g_occ.m4
            #本月銷退轉出金額
            LET l_sql = " SELECT SUM(tlfc21) FROM tlfc_file " ,
                     " LEFT  OUTER  JOIN tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02 ",
                     "    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903 ",
                     "    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906 ",
                     "  WHERE YEAR(tlfc06)='",tm.yy ,"'",
                     "    AND MONTH(tlfc06)='",tm.mm ,"'",
                     "    AND tlfc13='axmt670' ",
                     "    AND tlf19='",g_occ.occ01,"'",
                     "    AND tlf907=1 ",
                     "    AND tlfctype='",tm.ccc07,"'",
                     "    AND (tlfccost = '",tm.ccc08,"' OR tlfccost IS NULL )",
                     "    AND ",l_wc3
            PREPARE p803_tlfc21_5_1 FROM l_sql
            EXECUTE p803_tlfc21_5_1 INTO g_occ.m5
         END IF 
         #數值欄位如果為null給0
         IF tm.cb1 = 'Y' THEN 
            IF cl_null(g_occ.n1) THEN LET g_occ.n1 = 0 END IF 
            IF cl_null(g_occ.n2) THEN LET g_occ.n2 = 0 END IF
            IF cl_null(g_occ.n3) THEN LET g_occ.n3 = 0 END IF
            IF cl_null(g_occ.n4) THEN LET g_occ.n4 = 0 END IF
            IF cl_null(g_occ.n5) THEN LET g_occ.n5 = 0 END IF
            IF cl_null(g_occ.n6) THEN LET g_occ.n6 = 0 END IF
         END IF 
         IF cl_null(g_occ.m1) THEN LET g_occ.m1 = 0 END IF 
         IF cl_null(g_occ.m2) THEN LET g_occ.m2 = 0 END IF
         IF cl_null(g_occ.m3) THEN LET g_occ.m3 = 0 END IF
         IF cl_null(g_occ.m4) THEN LET g_occ.m4 = 0 END IF
         IF cl_null(g_occ.m5) THEN LET g_occ.m5 = 0 END IF
         IF cl_null(g_occ.m6) THEN LET g_occ.m6 = 0 END IF
         #期末數量，期末金額
         IF tm.cb1 = 'Y' THEN 
            LET g_occ.n6 = g_occ.n1 +g_occ.n2 -g_occ.n3 +g_occ.n4 -g_occ.n5
         END IF 
         LET g_occ.m6 = g_occ.m1 +g_occ.m2 -g_occ.m3 +g_occ.m4 -g_occ.m5
         EXECUTE insert_prep USING g_occ.*
      
      END FOREACH
   END IF 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY occ01"                     
   LET g_str = ''
   LET g_str = g_wc," AND ",g_wc2 
   CALL cl_wcchp(g_str,'occ01,ima01')                   
              RETURNING g_str
   LET g_str = g_str,";",tm.cb1
   IF tm.cb1 = 'N' THEN 
      CALL cl_prt_cs3('axcr803','axcr803',g_sql,g_str)
   ELSE
      CALL cl_prt_cs3('axcr803','axcr803_1',g_sql,g_str)
   END IF 
END FUNCTION 
#FUN-C60036
