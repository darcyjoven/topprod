# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: aski013.4gl
# Descriptions...: 裁減拉布登記表維護作業
# Date & Author..: No.FUN-870117 08/08/13 by ve007  
# Modify.........: No.FUN-8A0145 08/10/30 by hongmei 欄位類型修改
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-940111 09/05/08 By mike SELECT agd03回傳值不唯一  
# Modify.........: No.FUN-980008 09/08/17 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管 
# Modify.........: No.FUN-AB0025 10/11/11 By huangtao 新增料號管控
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80030 11/08/03 By minpp 模组程序撰写规范修改
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_value     ARRAY[20] OF RECORD
     fname    LIKE type_file.chr5,    #VARCHAR(5),      
     imandx   LIKE type_file.chr8,    #VARCHAR(8),      
     visible  LIKE type_file.chr1,    #VARCHAR(1),      
     nvalue   LIKE type_file.chr20,   #VARCHAR(20),      
     value    DYNAMIC ARRAY OF LIKE type_file.num20_6  #DEC(15,3)   
     END RECORD
DEFINE 
    g_skc   RECORD      LIKE skc_file.*,
    g_skc_t RECORD      LIKE skc_file.*,
    g_skc_o RECORD      LIKE skc_file.*,
    b_ski   RECORD      LIKE ski_file.*,
    g_ima02             LIKE ima_file.ima02,
    g_agd03             LIKE agd_file.agd03,
    g_skv08             LIKE skv_file.skv08, 
    g_yy,g_mm           LIKE type_file.num5,              
    g_ski        DYNAMIC ARRAY OF RECORD    #(Prinram Variables)
	                ski04     LIKE ski_file.ski04,
                  ski13     LIKE ski_file.ski13,
                  c         LIKE skv_file.skv08,
	                ski05     LIKE ski_file.ski05,
                  ski12     LIKE ski_file.ski12,
	                ski06     LIKE ski_file.ski06,
                  agd03_1   LIKE agd_file.agd03,
                  ski07     LIKE ski_file.ski07,
                  ski08     LIKE ski_file.ski08,
	                ski09     LIKE ski_file.ski09,
	                ski10     LIKE ski_file.ski10,
                  b         LIKE type_file.num20,
	                ski11     LIKE ski_file.ski11
                  END RECORD,
    g_ski_t             RECORD
	                 ski04     LIKE ski_file.ski04,
                   ski13     LIKE ski_file.ski13,
                   c         LIKE skv_file.skv08,
	                 ski05     LIKE ski_file.ski05,
                   ski12     LIKE ski_file.ski12,
                   ski06     LIKE ski_file.ski06,
                   agd03_1   LIKE agd_file.agd03,
                   ski07     LIKE ski_file.ski07,
                   ski08     LIKE ski_file.ski08,
	                 ski09     LIKE ski_file.ski09,
	                 ski10     LIKE ski_file.ski10,
                   b         LIKE type_file.num20, 
	                 ski11     LIKE ski_file.ski11
                   END RECORD
 
 DEFINE   g_sw          LIKE type_file.num10,
    g_flag              LIKE type_file.chr1,
#   g_x                 ARRAY[25] OF VARCHAR(40),   #No.FUN-8A0145
    g_wc,g_wc2,g_wc3,g_sql    string,  
    h_qty		            LIKE ima_file.ima271,
    g_t1                LIKE type_file.chr5,
    g_buf               LIKE type_file.chr50, 
    sn1,sn2             LIKE type_file.num10,
    g_j                 LIKE type_file.num10,
    l_ac_t              LIKE type_file.num5,
    l_code              LIKE type_file.num5,
    g_rec_b,g_rec_d     LIKE type_file.num5,             
    g_void              LIKE type_file.chr1,
    l_ac                LIKE type_file.num5,             
    l_acd               LIKE type_file.num5,
    g_argv1             STRING,
    g_cmd               STRING
 
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done  LIKE type_file.num5
 
DEFINE g_chr          LIKE type_file.chr1
DEFINE g_cnt          LIKE type_file.num10  
DEFINE g_i            LIKE type_file.num5
DEFINE g_msg          LIKE ze_file.ze03
 
DEFINE g_row_count    LIKE type_file.num10
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_jump         LIKE type_file.num10
DEFINE mi_no_ask      LIKE type_file.num5
DEFINE g_sla03    LIKE sla_file.sla03
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("ASK")) THEN
       EXIT PROGRAM
    END IF
 
    LET g_argv1=ARG_VAL(1)
    LET g_wc2=' 1=1'
 
    LET g_forupd_sql = "SELECT * FROM skc_file WHERE skc01=? AND skc02=? AND skc03=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i013_cl CURSOR FROM g_forupd_sql 
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    INITIALIZE g_skc.* TO NULL
    INITIALIZE g_skc_t.* TO NULL
    INITIALIZE g_skc_o.* TO NULL
 
    OPEN WINDOW i013_w  WITH FORM "ask/42f/aski013"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    CALL i013_menu()
 
    CLOSE WINDOW i013_w
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i013_cs()
 
       CLEAR FORM
 
       CALL g_ski.clear()
 
       CONSTRUCT BY NAME g_wc ON
                    skc01,skc02,skc03,skc04,skc08,skc06,skcuser,skcgrup,skcmodu,skcdate
       
        BEFORE CONSTRUCT
               INITIALIZE g_skc.* TO NULL
 
    ON ACTION controlp                  
     CASE 
	    WHEN INFIELD(skc01)
           CALL cl_init_qry_var()
           LET g_qryparam.state= "c"
  	       LET g_qryparam.form = "q_oea99"
 	         CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret to skc01
           NEXT FIELD skc01
 
	    WHEN INFIELD(skc02)
#FUN-AA0059---------mod------------str-----------------
#          CALL cl_init_qry_var()
#          LET g_qryparam.state= "c"
# 	       LET g_qryparam.form = "q_ima30"
#	         CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_sel_ima(TRUE, "q_ima30","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

           DISPLAY g_qryparam.multiret to skc02
           NEXT FIELD skc02
 
      WHEN INFIELD(skc08)
#FUN-AA0059---------mod------------str-----------------
#          CALL cl_init_qry_var()
#          LET g_qryparam.form = "q_ima00"
#          LET g_qryparam.default1 = g_skc.skc08
#          CALL cl_create_qry() RETURNING g_skc.skc08
           CALL q_sel_ima(FALSE, "q_ima00","",g_skc.skc08,"","","","","",'' ) 
              RETURNING g_skc.skc08  
#FUN-AA0059---------mod------------end-----------------
           NEXT FIELD skc08 
     
      OTHERWISE EXIT CASE
     END CASE
     
      ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help        
         CALL cl_show_help() 
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
       
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('skcuser', 'skcgrup') #FUN-980030
      IF INT_FLAG THEN RETURN END IF
 
 
       CONSTRUCT g_wc3 ON ski04,ski13,ski05,ski12,ski06,
                          ski07,ski08,ski09,ski10,ski11
            FROM  s_ski[1].ski04,s_ski[1].ski13,s_ski[1].ski05,
	          s_ski[1].ski12,s_ski[1].ski06,s_ski[1].ski07,
	          s_ski[1].ski08,s_ski[1].ski09,
	          s_ski[1].ski10,s_ski[1].ski11
 
       BEFORE CONSTRUCT
         CALL g_ski.clear()
 
 
         ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
         ON ACTION about        
            CALL cl_about()     
 
         ON ACTION help         
            CALL cl_show_help()  
 
         ON ACTION controlg      
            CALL cl_cmdask()     
 
       
       END CONSTRUCT
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN
    #        LET g_wc = g_wc clipped," AND skcuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN
    #        LET g_wc = g_wc clipped," AND skcgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
       IF g_wc3 = " 1=1" THEN LET g_sql = "SELECT skc01,skc02,skc03 FROM skc_file", 
                  " WHERE  ", g_wc CLIPPED, " ORDER BY skc01,skc02,skc03 " 
       ELSE
         LET  g_sql = "SELECT UNIQUE skc01,skc02,skc03 ", 
                      " FROM     skc_file, ski_file", " WHERE skc01 = ski01", "   AND skc02 = ski02",
                      "   AND      skc03 = ski03", "   AND ", g_wc CLIPPED, 
                      " AND ",g_wc3 CLIPPED,
                      " ORDER BY skc01,skc02,skc03" 
       END IF
 
    PREPARE i013_prepare FROM g_sql
    DECLARE i013_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i013_prepare
 
    IF g_wc3 = " 1=1" THEN 
       LET g_sql="SELECT COUNT(*) FROM skc_file ",
                  "WHERE  ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT skc01||skc02||skc03)) FROM skc_file,ski_file ",
                  " WHERE skc01=ski01 AND skc02=ski02 AND skc03=ski03 AND ",g_wc CLIPPED,    
		              " AND ",g_wc2 CLIPPED
    END IF
    
    PREPARE i013_precount FROM g_sql
    DECLARE i013_count CURSOR FOR i013_precount
END FUNCTION
 
FUNCTION i013_menu()
 
   WHILE TRUE
      CALL i013_bp("G")
      CASE g_action_choice
         WHEN "insert"  
            IF cl_chk_act_auth() THEN
               CALL i013_a() 
            END IF
         WHEN "query"  
            IF cl_chk_act_auth() THEN 
               CALL i013_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i013_r() 
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN 
               CALL i013_u() 
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               IF g_skc.skcconf ='N' THEN
                 CALL i013_b() 
               ELSE
                 IF g_skc.skcconf ='Y' THEN
                 CALL cl_err(' ',9022,0)
                 END IF
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF
	          LET g_action_choice = ""
 
         WHEN "confirm"
           IF cl_chk_act_auth() AND NOT cl_null(g_skc.skc01) THEN
             CALL i013_y()
           END IF
 
         WHEN "undo_confirm"
           IF cl_chk_act_auth() AND NOT cl_null(g_skc.skc01) THEN
             CALL i013_z()
           END IF
 
         WHEN "help"  
            CALL cl_show_help()
            
         WHEN "exit" 
            EXIT WHILE
            
         WHEN "controlg"  
            CALL cl_cmdask()
            
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ski),'','') 
            END IF
            
      END CASE
      
   END WHILE
   
END FUNCTION
 
 
FUNCTION i013_a()
    DEFINE  li_result  LIKE type_file.num5
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_ski.clear()
    INITIALIZE g_skc.* TO NULL
    LET g_skc_o.* = g_skc.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_skc.skc04  =g_today
        LET g_skc.skcuser=g_user
        LET g_skc.skcgrup=g_grup
        LET g_skc.skcdate=g_today
        LET g_skc.skcconf='N'
        LET g_skc.skcplant=g_plant  #FUN-980008 add
        LET g_skc.skclegal=g_legal  #FUN-980008 add
        DISPLAY BY NAME g_skc.skcconf
        BEGIN WORK
        CALL i013_i("a")
        IF INT_FLAG THEN
           INITIALIZE g_skc.* TO NULL
           LET INT_FLAG=0
           CALL cl_err('',9001,0) 
           ROLLBACK WORK 
           RETURN
        END IF
        IF g_skc.skc01 IS NULL THEN CONTINUE WHILE END IF
        IF g_skc.skc02 IS NULL THEN CONTINUE WHILE END IF
        IF g_skc.skc03 IS NULL THEN CONTINUE WHILE END IF
 
        DISPLAY BY NAME g_skc.skc01,g_skc.skc02,g_skc.skc03
 
        LET g_skc.skcoriu = g_user      #No.FUN-980030 10/01/04
        LET g_skc.skcorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO skc_file VALUES (g_skc.*) 
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
           CALL cl_err('ins skc: ',SQLCA.SQLCODE,1)  #FUN-B80030      ADD
           ROLLBACK WORK
          # CALL cl_err('ins skc: ',SQLCA.SQLCODE,1) #FUN-B80030   MARK
           CONTINUE WHILE 
        ELSE
            COMMIT WORK
            CALL cl_flow_notify(g_skc.skc01,'I')
        END IF
      
 
        SELECT skc01,skc02,skc03
         INTO g_skc.skc01,g_skc.skc02,g_skc.skc03
	        FROM skc_file 
         WHERE skc01 = g_skc.skc01
	   AND skc02 = g_skc.skc02
	   AND skc03 = g_skc.skc03
 
          LET g_skc_t.* = g_skc.*
 
          CALL g_ski.clear()   
	  LET g_rec_d = 0 
 
          CALL i013_b()
 
        EXIT WHILE
 
    END WHILE
 
END FUNCTION
 
FUNCTION i013_u()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_skc.skc01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_skc.skcconf ='Y' THEN
      CALL cl_err(' ',9022,0) 
      RETURN
    END IF
    SELECT * 
      INTO g_skc.* 
      FROM skc_file 
     WHERE skc01=g_skc.skc01
       AND skc02=g_skc.skc02
       AND skc03=g_skc.skc03
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_skc_o.* = g_skc.*
    BEGIN WORK
    OPEN i013_cl USING g_skc.skc01,g_skc.skc02,g_skc.skc03
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_skc.skc01,SQLCA.sqlcode,0)
       CLOSE i013_cl
       ROLLBACK WORK
       RETURN
    ELSE 
       FETCH i013_cl INTO g_skc.*
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_skc.skc01,SQLCA.sqlcode,0)
          CLOSE i013_cl 
          ROLLBACK WORK 
          RETURN
       END IF
    END IF
    CALL i013_show()
    WHILE TRUE
        LET g_skc.skcmodu=g_user
        LET g_skc.skcdate=g_today
        CALL i013_i("u")
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_skc.*=g_skc_t.*
            CALL i013_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE skc_file SET *=g_skc.* WHERE skc01=g_skc_t.skc01 AND skc02=g_skc_t.skc02 AND skc03=g_skc_t.skc03
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('up skc: ',SQLCA.SQLCODE,1)
           CONTINUE WHILE
        END IF
        IF g_skc.skc01 != g_skc_t.skc01 
         OR g_skc.skc02 != g_skc_t.skc02 
         OR g_skc.skc03 != g_skc_t.skc03 THEN 
           CALL i013_chkkey() 
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i013_cl
    COMMIT WORK
    CALL cl_flow_notify(g_skc.skc01,'U')
END FUNCTION
 
 
FUNCTION i013_chkkey()
      UPDATE ski_file 
         SET ski01=g_skc.skc01,
             ski02=g_skc.skc02,
             ski03=g_skc.skc03 
       WHERE ski01=g_skc_t.skc01
         AND ski02=g_skc_t.skc02
         AND ski03=g_skc_t.skc03
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd ski01: ',SQLCA.SQLCODE,1)
         LET g_skc.*=g_skc_t.* 
         CALL i013_show() 
         ROLLBACK WORK 
         RETURN
     END IF
END FUNCTION
 
FUNCTION i013_i(p_cmd)
  DEFINE p_cmd            LIKE type_file.chr1
  DEFINE l_flag           LIKE type_file.chr1
  DEFINE li_result,l_cnt  LIKE type_file.num5
 
    INPUT BY NAME
	  g_skc.skc01,g_skc.skc02,
          g_skc.skc03,g_skc.skc04,
	  g_skc.skc06,g_skc.skc08,
	  g_skc.skcuser,g_skc.skcgrup,
	  g_skc.skcmodu,g_skc.skcdate
           WITHOUT DEFAULTS 
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i013_set_entry(p_cmd)
            CALL i013_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE 
 
        SELECT sla03 INTO g_sla03 FROM sla_file
 
        AFTER FIELD skc01  
         IF NOT cl_null(g_skc.skc01) THEN 
	    LET l_cnt = 0
            SELECT count(*) INTO l_cnt FROM oea_file,sfc_file,sfci_file,oeb_file,oebi_FILE
	     WHERE sfcislk01 = oebislk01 
               AND sfc01 = sfci01
               AND oebi01=oeb01
               AND oea01 =oeb01
               AND sfc01 = g_skc.skc01
            IF l_cnt <=0 THEN
	        CALL cl_err('','asf-886',1)
                NEXT FIELD skc01
            END IF
            IF NOT cl_null(g_skc.skc02) THEN
	       LET l_cnt = 0 
	       SELECT COUNT(*) INTO l_cnt 
                  FROM slg_file,sfc_file,sfci_file 
                 WHERE sfcislk01 = slg01 
                   AND sfc01 = sfci01
                   AND sfc01 = g_skc.skc01
	          AND slg02 = g_skc.skc02
	       IF l_cnt <=0 THEN
	          CALL cl_err('','mfg3382',1)
                  NEXT FIELD skc01
	        END IF
            END IF
	    DISPLAY BY NAME g_skc.skc01
          END IF
 
	AFTER FIELD skc02
	   IF NOT cl_null(g_skc.skc02) THEN
#FUN-AB0025 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_skc.skc02,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_skc.skc02=g_skc_t.skc02 
                 NEXT FIELD skc02
              END IF
#FUN-AB0025 ---------------------end-------------------------------
	      LET l_cnt = 0
	      SELECT COUNT(*) INTO l_cnt FROM ima_file
	       WHERE ( ima130 IS NULL OR ima130 <>'2') 
	         AND imaacti = 'Y' 
	         AND (imaag IS NOT NULL AND imaag <> '@CHILD')
	         AND ima01 = g_skc.skc02	      
             IF l_cnt <= 0 THEN
	        CALL cl_err('','ask-100',1)
	        NEXT FIELD skc02
	     END IF
        IF NOT cl_null(g_skc.skc01) THEN
	        LET l_cnt = 0 
	        SELECT COUNT(*) INTO l_cnt 
                  FROM slg_file,sfc_file,sfci_file 
                 WHERE sfcislk01 = slg01 
                   AND sfc01 = sfci01
                   AND sfc01 = g_skc.skc01
	                 AND slg02 = g_skc.skc02
	        IF l_cnt <=0 THEN
	           CALL cl_err('','mfg3382',1)
                   NEXT FIELD skc02
	          END IF
            END IF
            SELECT ima02 INTO g_ima02 FROM ima_file WHERE ima01=g_skc.skc02
            DISPLAY g_ima02 TO ima02
          END IF
 
        AFTER FIELD skc03
           IF NOT cl_null(g_skc.skc03) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM skc_file
                WHERE skc01 = g_skc.skc01
                  AND skc02 = g_skc.skc02
                  AND skc03 = g_skc.skc03
              IF l_cnt > 0 THEN
                 CALL cl_err('','-239',1)
                 NEXT FIELD skc03
              END IF
           END IF
 
        AFTER FIELD skc04
          IF NOT cl_null(g_skc.skc04) THEN 
	        IF g_sma.sma53 IS NOT NULL AND g_skc.skc04 <= g_sma.sma53 THEN
	           CALL cl_err('','mfg9999',0) NEXT FIELD skc04
	        END IF
             CALL s_yp(g_skc.skc04) RETURNING g_yy,g_mm
             IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52)THEN
                 CALL cl_err('','mfg6091',0) 
             END IF
          END IF
 
        AFTER FIELD skc06
          IF NOT cl_null(g_skc.skc06) THEN
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM agd_file
              WHERE agd02=g_skc.skc06
            IF l_cnt <= 0 THEN
               CALL cl_err(' ','agd-001',0)
               NEXT FIELD skc06
            END IF
            SELECT  agd03 INTO g_agd03 FROM agd_file
             WHERE agd02=g_skc.skc06
               AND agd01=g_sla03 #TQC-940111   
            DISPLAY g_agd03 TO agd03
          END IF
 
        AFTER FIELD skc08
          IF NOT cl_null(g_skc.skc08) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_skc.skc08,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_skc.skc08= g_skc_t.skc08
               NEXT FIELD skc08
            END IF
#FUN-AA0059 ---------------------end-------------------------------
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM ima_file
              WHERE ima01 = g_skc.skc08
             IF l_cnt = 0 THEN
                CALL cl_err('','mfg0002',1)
                NEXT FIELD skc08
             END IF
             SELECT ima02 INTO g_ima02 FROM ima_file WHERE ima01=g_skc.skc08
             DISPLAY g_ima02 TO ima02_1
          END IF
 
        ON ACTION controlp                  
          CASE 
	          WHEN INFIELD(skc01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oea99"
                 LET g_qryparam.default1 = g_skc.skc01
                 CALL cl_create_qry() RETURNING g_skc.skc01 
                 DISPLAY g_skc.skc01 TO skc01
 
	          WHEN INFIELD(skc02)
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima30"
#                LET g_qryparam.default1 = g_skc.skc02
#                CALL cl_create_qry() RETURNING g_skc.skc02 
                 CALL q_sel_ima(FALSE, "q_ima30","",g_skc.skc02,"","","","","",'' ) 
                  RETURNING g_skc.skc02  
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_skc.skc02 TO skc02
 
            WHEN INFIELD(skc06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_agd1"
                 LET g_qryparam.arg1     = g_sla03
                 LET g_qryparam.default1 = g_skc.skc06
                 CALL cl_create_qry() RETURNING g_skc.skc06
                 NEXT FIELD skc06
                 
           WHEN INFIELD(skc08)
#FUN-AA0059---------mod------------str-----------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ima00"
#               LET g_qryparam.default1 = g_skc.skc08
#               CALL cl_create_qry() RETURNING g_skc.skc08
                 CALL q_sel_ima(FALSE, "q_ima00","",g_skc.skc08,"","","","","",'' )
                  RETURNING g_skc.skc08
#FUN-AA0059---------mod------------end-----------------

                NEXT FIELD skc08  
                
           OTHERWISE EXIT CASE
           
          END CASE
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
 
        ON ACTION CONTROLO
           IF INFIELD(skc01) THEN
               LET g_skc.* = g_skc_t.*
               CALL i013_show()
               NEXT FIELD skc01
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
        
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about        
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
    
    END INPUT
END FUNCTION
 
FUNCTION i013_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("skc01,skc02,skc03",TRUE)
    END IF 
 
END FUNCTION
 
FUNCTION i013_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("skc01,skc02,skc03",FALSE) 
    END IF 
 
END FUNCTION
 
FUNCTION i013_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i013_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_skc.* TO NULL
       RETURN
    END IF
    MESSAGE " SEARCHING ! " 
    OPEN i013_cs
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_skc.* TO NULL
    ELSE
        OPEN i013_count
        FETCH i013_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i013_fetch('F')
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i013_fetch(p_flag)
DEFINE
    p_flag    LIKE type_file.chr1
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i013_cs INTO g_skc.skc01,g_skc.skc02,g_skc.skc03
        WHEN 'P' FETCH PREVIOUS i013_cs INTO g_skc.skc01,g_skc.skc02,g_skc.skc03
        WHEN 'F' FETCH FIRST    i013_cs INTO g_skc.skc01,g_skc.skc02,g_skc.skc03
        WHEN 'L' FETCH LAST     i013_cs INTO g_skc.skc01,g_skc.skc02,g_skc.skc03
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0 
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
 
                     ON ACTION about        
                        CALL cl_about()     
 
                     ON ACTION help         
                        CALL cl_show_help()  
 
                     ON ACTION controlg     
                        CALL cl_cmdask()    
                                         
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i013_cs INTO g_skc.skc01,g_skc.skc02,g_skc.skc03
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_skc.skc01,SQLCA.sqlcode,0)
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_skc.* FROM skc_file WHERE skc01=g_skc.skc01 AND skc02=g_skc.skc02 AND skc03=g_skc.skc03
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_skc.skc01,SQLCA.sqlcode,0)
        INITIALIZE g_skc.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_skc.skcuser 
        LET g_data_group = g_skc.skcgrup 
    END IF
    CALL i013_show()
END FUNCTION
 
FUNCTION i013_show()
    LET g_skc_t.* = g_skc.*
    DISPLAY BY NAME
	      g_skc.skc01,g_skc.skc02,
	      g_skc.skc03,g_skc.skc04,
              g_skc.skc08,g_skc.skc06,g_skc.skcconf,
              g_skc.skcuser,g_skc.skcgrup,
	      g_skc.skcmodu,g_skc.skcdate
    SELECT ima02 INTO g_ima02 FROM ima_file
     WHERE ima01 = g_skc.skc02
    DISPLAY g_ima02 TO ima02
    SELECT ima02 INTO g_ima02 FROM ima_file
     WHERE ima01 = g_skc.skc08
    DISPLAY g_ima02 TO ima02_1
    SELECT  agd03 INTO g_agd03 FROM agd_file
     WHERE  agd02=g_skc.skc06
       AND  agd01=g_sla03 #TQC-940111  
    DISPLAY g_agd03 TO agd03
    CALL i013_b_fill(g_wc3) 
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i013_r()
    DEFINE l_chr,l_sure  LIKE type_file.chr1
    IF s_shut(0) THEN RETURN END IF
    IF g_skc.skc01 IS NULL OR g_skc.skc02 IS NULL OR g_skc.skc03 IS NULL THEN 
       CALL cl_err('',-400,0) 
       RETURN 
    END IF
    SELECT * INTO g_skc.* 
      FROM skc_file 
     WHERE skc01=g_skc.skc01
       AND skc02=g_skc.skc02
       AND skc03=g_skc.skc03
 
    BEGIN WORK
 
    OPEN i013_cl USING g_skc.skc01,g_skc.skc02,g_skc.skc03
    IF SQLCA.sqlcode THEN 
       CALL cl_err(g_skc.skc01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN 
    ELSE 
       FETCH i013_cl INTO g_skc.*
       IF SQLCA.sqlcode THEN 
          CALL cl_err(g_skc.skc01,SQLCA.sqlcode,0)
          ROLLBACK WORK
          RETURN 
       END IF
    END IF
    CALL i013_show()
    IF cl_delh(20,16) THEN
        MESSAGE "Delete skc,ski!"
        DELETE FROM skc_file 
	      WHERE skc01 = g_skc.skc01
	        AND skc02 = g_skc.skc02
	        AND skc03 = g_skc.skc03
        IF SQLCA.SQLERRD[3]=0 THEN 
	   CALL cl_err('No skc deleted',SQLCA.SQLCODE,0)
           ROLLBACK WORK 
	   RETURN
        END IF
 
        DELETE FROM ski_file 
	       WHERE ski01 = g_skc.skc01
	         AND ski02 = g_skc.skc02
	         AND ski03 = g_skc.skc03
        IF SQLCA.SQLCODE  THEN 
           CALL cl_err('No ski deleted',SQLCA.SQLCODE,0)
           ROLLBACK WORK 
           RETURN
        END IF
 
        LET g_msg=TIME
        INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980008 add azoplant,azolegal
           VALUES ('aski013',g_user,g_today,g_msg,g_skc.skc01,'delete',g_plant,g_legal) #FUN-980008 add g_plant,g_legal
           CLEAR FORM
           INITIALIZE g_skc.* TO NULL
           CALL g_ski.clear() 
           MESSAGE ""
           OPEN i013_count
           #FUN-B50064-add-start--
           IF STATUS THEN
              CLOSE i013_cs
              CLOSE i013_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50064-add-end-- 
           FETCH i013_count INTO g_row_count
           #FUN-B50064-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i013_cs
              CLOSE i013_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50064-add-end-- 
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i013_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i013_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL i013_fetch('/')
           END IF
    END IF
    CLOSE i013_cl
    COMMIT WORK
    CALL cl_flow_notify(g_skc.skc01,'D')
     
END FUNCTION
 
 
#{
#FUNCTION i013_c()
# DEFINE l_msg       STRING,
#        l_sql       VARCHAR(400),
#        i           SMALLINT,
#	l_slg004 LIKE slg_file.slg004
#
#     CALL cl_set_comp_visible('tc_sagf004',TRUE)
#     CALL cl_set_comp_visible('tc_sagf005',TRUE)
#     CALL cl_set_comp_visible('tc_sagf008',TRUE)
#
#     FOR i = 1 TO 20
#        LET l_msg = 's',i USING '&&'
#        CALL cl_set_comp_visible(l_msg,FALSE)
#     END FOR
#
#          LET l_sql=" SELECT slg004 ",
#               "   FROM slg_file ",
#               "  WHERE slg001 = '",g_tc_saff.tc_saff001,"'",
#	       "    AND slg02 = '",g_tc_saff.tc_saff002,"'",
#	       " ORDER BY slg003 "
#
#     PREPARE i100f_tmp1 FROM l_sql
#     DECLARE tmp1_cur1 CURSOR FOR i100f_tmp1
#   
#     LET i=1
#     LET g_j = 1
#     CALL g_value.clear()
#     FOREACH tmp1_cur1 INTO l_slg004
#        IF STATUS THEN 
#           CALL cl_err('foreach inbf003',STATUS,0)   
#           EXIT FOREACH                         
#        END IF        
#       
#        LET l_msg = 's',i USING '&&'
#        CALL cl_set_comp_att_text(l_msg ,l_slg004)
#        CALL cl_set_comp_visible(l_msg,TRUE)
#        LET g_value[i].fname = l_msg
#        LET g_value[i].visible = 'Y' 
#        LET g_value[i].imandx = 'imandx',i USING '&&'
#        LET g_value[i].nvalue = l_slg004
#       
#        LET i = i + 1
#        IF i = 21 THEN EXIT FOREACH END IF  #
#     END FOREACH
#     LET g_j = i-1
#     FOR i = i TO 20
#        LET l_msg = 's',i USING '&&'
#        CALL cl_set_comp_visible(l_msg,FALSE)
#        LET g_value[i].fname = l_msg 
#        LET g_value[i].visible = 'N'
#        LET g_value[i].imandx = 'imandx',i USING '&&'
#        LET g_value[i].nvalue = ''
#     END FOR
#
#END FUNCTION}
 
 
FUNCTION i013_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n,l_cnt       LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE TYPE_FILE.CHR1,
    l_ima02         LIKE ima_file.ima02,
    l_oeb12         LIKE oeb_file.oeb12,
    l_ski04         LIKE ski_file.ski04,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
 
    LET g_action_choice = ""
    IF cl_null(g_skc.skc01) THEN RETURN END IF
    IF cl_null(g_skc.skc02) THEN RETURN END IF
    IF cl_null(g_skc.skc03) THEN RETURN END IF
 
    SELECT * INTO g_skc.* 
      FROM skc_file 
     WHERE skc01=g_skc.skc01
       AND skc02=g_skc.skc02
       AND skc03=g_skc.skc03
 
    IF g_skc.skc03 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    
    CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT * FROM ski_file ",
                       " WHERE ski01= ? AND ski02= ? AND ski03= ? AND ski04= ? FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i013_bcl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ski WITHOUT DEFAULTS FROM s_ski.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR() 
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN i013_cl USING g_skc.skc01,g_skc.skc02,g_skc.skc03
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_skc.skc01,SQLCA.sqlcode,0)
               CLOSE i013_cl 
               ROLLBACK WORK 
               RETURN
            ELSE 
               FETCH i013_cl INTO g_skc.*  
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_skc.skc01,SQLCA.sqlcode,0)
                  CLOSE i013_cl 
                  ROLLBACK WORK 
                  RETURN
               END IF
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_ski_t.* = g_ski[l_ac].*  #BACKUP
                OPEN i013_bcl 
	              USING g_skc.skc01,
	                    g_skc.skc02,
                            g_skc.skc03,
                            g_ski_t.ski04
 
                FETCH i013_bcl INTO b_ski.* 
                IF SQLCA.sqlcode AND SQLCA.sqlcode <>100 THEN
                   CALL cl_err('lock ski',SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                ELSE
                   CALL i013_b_move_to()
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_ski[l_ac].* TO NULL      #900423
           INITIALIZE g_ski_t.* TO NULL  
           LET b_ski.ski01=g_skc.skc01
           LET b_ski.ski02=g_skc.skc02
           LET b_ski.ski03=g_skc.skc03
           LET b_ski.skiplant=g_plant #FUN-980008 add
           LET b_ski.skilegal=g_legal #FUN-980008 add
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD ski04
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           CALL i013_b_move_back()
           INSERT INTO ski_file VALUES(b_ski.*)
           IF SQLCA.sqlcode THEN
              CALL cl_err('ins ski',SQLCA.sqlcode,1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn3
           END IF
 
        BEFORE FIELD ski04
        IF g_ski[l_ac].ski04 IS NULL OR g_ski[l_ac].ski04 = 0 THEN
           LET g_ski[l_ac].ski04 = 0
            SELECT max(ski04)+1 INTO g_ski[l_ac].ski04
             FROM ski_file 
             WHERE ski01 = g_skc.skc01
               AND ski02 = g_skc.skc02
               AND ski03 = g_skc.skc03
             IF cl_null(g_ski[l_ac].ski04)  THEN
                LET g_ski[l_ac].ski04 = 1
                NEXT FIELD ski04
             END IF
         END IF
 
        AFTER FIELD ski04
            IF cl_null(g_ski[l_ac].ski04) THEN
               LET g_ski[l_ac].ski04 = 1
            ELSE
               IF g_ski[l_ac].ski04 != g_ski_t.ski04 OR
                  g_ski_t.ski04 IS NULL THEN
                  LET l_n = 0
                 SELECT count(*) INTO l_n FROM ski_file
                  WHERE ski01 = g_skc.skc01
	            AND ski02 = g_skc.skc02
	            AND ski03 = g_skc.skc03
	            AND ski04 = g_ski[l_ac].ski04
                  IF l_n > 0 THEN
                     LET g_ski[l_ac].ski04 = g_ski_t.ski04
                     CALL cl_err('',-239,0) 
		     NEXT FIELD ski04
                  END IF
               END IF
            END IF
 
       AFTER FIELD ski13 
         IF cl_null(g_ski[l_ac].ski13) THEN
	          CALL cl_err('','aap-099',0)
	          NEXT FIELD ski13
         ELSE
             LET l_n = 0
             SELECT COUNT(*) INTO l_n FROM skv_file 
              WHERE skv01 = g_skc.skc01
                AND skv02 = g_skc.skc02
                AND skv04 = g_ski[l_ac].ski13
             IF l_n > 0 THEN
                SELECT skv08 INTO  g_ski[l_ac].c FROM skv_file 
                 WHERE skv01 = g_skc.skc01
                   AND skv02 = g_skc.skc02
                   AND skv04 = g_ski[l_ac].ski13
                 DISPLAY g_ski[l_ac].c TO c
              ELSE
                 CALL cl_err(' ','asf-981',0)
                 NEXT FIELD ski13
              END IF
          END IF
 
 
       AFTER FIELD ski06
          IF NOT cl_null(g_ski[l_ac].ski06) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM agd_file
                WHERE agd02=g_ski[l_ac].ski06
              IF l_cnt <= 0 THEN
                CALL cl_err(' ','agd-001',0)
                NEXT FIELD ski06
              END IF
              SELECT  agd03 INTO g_ski[l_ac].agd03_1 FROM agd_file
               WHERE agd02=g_ski[l_ac].ski06
                 AND agd01=g_sla03 #TQC-940111    
               DISPLAY BY NAME g_ski[l_ac].agd03_1 
           END IF
 
       AFTER FIELD ski07
         IF NOT cl_null(g_ski[l_ac].ski07) THEN
            IF g_ski[l_ac].ski07 < 0 THEN
               CALL cl_err(g_ski[l_ac].ski07,'-32406',0)
                NEXT FIELD ski07
             END IF
	  END IF
 
       AFTER FIELD ski08
         IF NOT cl_null(g_ski[l_ac].ski08) THEN
            IF g_ski[l_ac].ski08 < 0 THEN
               CALL cl_err(g_ski[l_ac].ski08,'-32406',0)
               NEXT FIELD ski08
            END IF
            LET g_ski[l_ac].ski09=g_ski[l_ac].ski08*g_ski[l_ac].c
            DISPLAY g_ski[l_ac].ski09 TO ski09
	        END IF
 
       AFTER FIELD ski09
         IF cl_null(g_ski[l_ac].ski09) THEN
            NEXT FIELD ski09
	       ELSE
             IF g_ski[l_ac].ski09 < 0 THEN
                CALL cl_err(g_ski[l_ac].ski09,'-32406',0)
	        NEXT FIELD ski09
             END IF
         END IF
 
       AFTER FIELD ski10
         IF NOT cl_null(g_ski[l_ac].ski10) THEN
            IF g_ski[l_ac].ski10 < 0 THEN
               CALL cl_err(g_ski[l_ac].ski10,'-32406',0)
               NEXT FIELD ski10
	       END IF
            LET g_ski[l_ac].b=g_ski[l_ac].ski09
                                  +g_ski[l_ac].ski10-g_ski[l_ac].ski07
            DISPLAY g_ski[l_ac].b TO b 
         END IF
 
        BEFORE DELETE                            
            IF g_ski_t.ski04 > 0 AND g_ski_t.ski04 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM ski_file
                 WHERE ski01 = g_skc.skc01
	           AND ski02 = g_skc.skc02
	           AND ski03 = g_skc.skc03
	           AND ski04 = g_ski_t.ski04
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_ski_t.ski04,SQLCA.sqlcode,0)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn3
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ski[l_ac].* = g_ski_t.*
              CLOSE i013_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ski[l_ac].ski04,-263,1)
               LET g_ski[l_ac].* = g_ski_t.*
            END IF            
            CALL i013_b_move_back()
            UPDATE ski_file 
	       SET * = b_ski.*
             WHERE ski01=g_skc.skc01
	       AND ski02=g_skc.skc02
	       AND ski03=g_skc.skc03
	       AND ski04=g_ski_t.ski04
             IF SQLCA.sqlcode THEN
                CALL cl_err('upd ski',SQLCA.sqlcode,0)
                LET g_ski[l_ac].* = g_ski_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()        
#          LET l_ac_t = l_ac        #FUN-D40030 mark
 
           IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_ski[l_ac].* = g_ski_t.*
               #FUN-D40030---add---str---
               ELSE
                  CALL g_ski.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030---add---end---
               END IF
               CLOSE i013_bcl
               ROLLBACK WORK
               EXIT INPUT
           END IF
           LET l_ac_t = l_ac       #FUN-D40030 add
           CLOSE i013_bcl
           COMMIT WORK
 
 
 
        ON ACTION CONTROLO                       
           IF INFIELD(ski04) AND l_ac > 1 THEN
              LET g_ski[l_ac].* = g_ski[l_ac-1].*
              LET g_ski[l_ac].ski04 = NULL
              NEXT FIELD ski04
           END IF
 
        ON ACTION controlp
           CASE 
                WHEN INFIELD(ski06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_agd1"
                     SELECT sla03 INTO g_sla03 FROM sla_file
                     LET g_qryparam.arg1     = g_sla03
                     LET g_qryparam.default1 = g_ski[l_ac].ski06
                     CALL cl_create_qry() RETURNING g_ski[l_ac].ski06 
                     NEXT FIELD ski06
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()  
 
    END INPUT
 
    LET g_skc.skcmodu = g_user
    LET g_skc.skcdate = g_today
    UPDATE skc_file 
       SET skcmodu=g_skc.skcmodu,
           skcdate=g_skc.skcdate
     WHERE skc01=g_skc.skc01
       AND skc02=g_skc.skc02
       AND skc03=g_skc.skc03
 
    DISPLAY BY NAME g_skc.skcmodu,g_skc.skcdate
 
    SELECT COUNT(*) INTO g_cnt FROM ski_file WHERE ski01=g_skc.skc01
 
    CLOSE i013_bcl
    COMMIT WORK
    CALL i013_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i013_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM skc_file WHERE skc01=g_skc.skc01
                                AND skc02=g_skc.skc02
                                AND skc03=g_skc.skc03
         INITIALIZE g_skc.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
FUNCTION i013_b_move_to()
     LET g_ski[l_ac].ski04=b_ski.ski04
     LET g_ski[l_ac].ski05=b_ski.ski05
     LET g_ski[l_ac].ski06=b_ski.ski06
     LET g_ski[l_ac].ski07=b_ski.ski07
     LET g_ski[l_ac].ski08=b_ski.ski08
     LET g_ski[l_ac].ski09=b_ski.ski09
     LET g_ski[l_ac].ski10=b_ski.ski10
     LET g_ski[l_ac].ski11=b_ski.ski11
     LET g_ski[l_ac].ski12=b_ski.ski12
     LET g_ski[l_ac].ski13=b_ski.ski13
END FUNCTION
   
FUNCTION i013_b_move_back()
     LET b_ski.ski04=g_ski[l_ac].ski04
     LET b_ski.ski05=g_ski[l_ac].ski05
     LET b_ski.ski06=g_ski[l_ac].ski06
     LET b_ski.ski07=g_ski[l_ac].ski07
     LET b_ski.ski08=g_ski[l_ac].ski08
     LET b_ski.ski09=g_ski[l_ac].ski09
     LET b_ski.ski10=g_ski[l_ac].ski10
     LET b_ski.ski11=g_ski[l_ac].ski11
     LET b_ski.ski12=g_ski[l_ac].ski12
     LET b_ski.ski13=g_ski[l_ac].ski13
END FUNCTION
 
FUNCTION i013_b_fill(p_wc3)              #BODY FILL UP
DEFINE p_wc3          STRING
 
    LET g_sql =
        "SELECT ski04,ski13,' ',ski05,ski12,ski06,' ',",
        "       ski07,ski08,ski09,ski10,' ',ski11  ", 
        " FROM ski_file  ",
        " WHERE ski01 ='",g_skc.skc01,"'",  
        "   AND ski02 ='",g_skc.skc02,"'",
        "   AND ski03 ='",g_skc.skc03,"'",
        "   AND ",p_wc3 CLIPPED,                    
        " ORDER BY ski04"
 
    PREPARE i013_pb FROM g_sql
    DECLARE ski_curs CURSOR FOR i013_pb
 
    CALL g_ski.clear()
 
    LET g_cnt = 1
    FOREACH ski_curs INTO g_ski[g_cnt].*   
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
        SELECT DISTINCT skv08 INTO g_ski[g_cnt].c FROM skv_file
         WHERE skv01 = g_skc.skc01
           AND skv02 = g_skc.skc02
           AND skv04 = g_ski[g_cnt].ski13
 
        SELECT  agd03 INTO g_agd03 FROM agd_file
         WHERE agd02=g_ski[g_cnt].ski06
           AND agd01=g_sla03 #TQC-940111 
        LET g_ski[g_cnt].agd03_1 = g_agd03
        LET g_ski[g_cnt].b = g_ski[g_cnt].ski09
                                 +g_ski[g_cnt].ski10-g_ski[g_cnt].ski07 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ski.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn3
END FUNCTION
 
FUNCTION i013_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_ski TO s_ski.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET  l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i013_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                  
                              
      ON ACTION previous
         CALL i013_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                   
                              
      ON ACTION jump
         CALL i013_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 
      ON ACTION next
         CALL i013_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
                              
      ON ACTION last
         CALL i013_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   
      ON ACTION cancel
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i013_y()
  DEFINE l_cnt  LIKE type_file.num5
#CHI-C30107 -------------- add --------------- begin
  IF g_skc.skcconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM ski_file
    WHERE ski01=g_skc.skc01
      AND ski02=g_skc.skc02
      AND ski03=g_skc.skc03
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF 
  IF NOT cl_confirm('axm-108') THEN RETURN END IF
   SELECT * INTO g_skc.* FROM skc_file WHERE skc01 = g_skc.skc01
                                         AND skc02 = g_skc.skc02
                                         AND skc03 = g_skc.skc03
#CHI-C30107 -------------- add --------------- end
  IF g_skc.skcconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM ski_file
    WHERE ski01=g_skc.skc01
      AND ski02=g_skc.skc02
      AND ski03=g_skc.skc03
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   
# IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
 
  IF g_skc.skcconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
 
  BEGIN WORK
   OPEN i013_cl USING g_skc.skc01,g_skc.skc02,g_skc.skc03
   IF STATUS THEN
      CALL cl_err("OPEN i013_cl:", STATUS, 1)
      CLOSE i013_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i013_cl INTO g_skc.*
   IF SQLCA.sqlcode THEN
     CALL cl_err(g_skc.skc01,SQLCA.sqlcode,0)
     CLOSE i013_cl
     ROLLBACK WORK
     RETURN
   END IF
 
   UPDATE skc_file SET skcconf = 'Y' WHERE skc01=g_skc.skc01 AND skc02=g_skc.skc02 AND skc03=g_skc.skc03
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      LET g_success = 'N'
   ELSE
      LET g_success = 'Y'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_skc.skcconf = 'Y'
      COMMIT WORK
      CALL cl_cmmsg(4)
   ELSE
      LET g_skc.skcconf = 'N'
      ROLLBACK WORK
      CALL cl_rbmsg(4)
   END IF
   DISPLAY BY NAME g_skc.skcconf
 
END FUNCTION
 
FUNCTION i013_z()
  IF NOT cl_confirm('axm-109') THEN RETURN END IF
  IF g_skc.skcconf = 'N' THEN CALL cl_err('',9002,0) RETURN END IF
  BEGIN WORK
   OPEN i013_cl USING g_skc.skc01,g_skc.skc02,g_skc.skc03
   IF STATUS THEN
      CALL cl_err("OPEN i013_cl:", STATUS, 1)
      CLOSE i013_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i013_cl INTO g_skc.*
   IF SQLCA.sqlcode THEN
     CALL cl_err(g_skc.skc01,SQLCA.sqlcode,0)
     CLOSE i013_cl
     ROLLBACK WORK
     RETURN
   END IF
 
   UPDATE skc_file SET skcconf = 'N' WHERE skc01=g_skc.skc01 AND skc02=g_skc.skc02 AND skc03=g_skc.skc03
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      LET g_success = 'N'
   ELSE
     LET g_success = 'Y'
   END IF
 
   IF g_success = 'Y' THEN
     LET g_skc.skcconf = 'N'
      COMMIT WORK
      CALL cl_cmmsg(4)
   ELSE
      LET g_skc.skcconf = 'Y'
      ROLLBACK WORK
      CALL cl_rbmsg(4)
   END IF
   DISPLAY BY NAME g_skc.skcconf
END FUNCTION
 
#No.FUN-870117
