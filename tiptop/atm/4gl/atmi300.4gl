# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: atmi300.4gl
# Descriptions...: 訂單物返未達成記錄查詢維護作業
# Date & Author..: #FUN-820033 08/02/28 By xufeng
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.TQC-9B0016 09/11/04 By liuxqa 标准SQL修改
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No:FUN-BB0086 11/12/26 By tanxc 增加數量欄位小數取位 
# Modify.........: No:FUN-D30033 13/04/10 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_try           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)   #FUN-820033
        try01       LIKE try_file.try01,  
        try02       LIKE try_file.try02,
        try03       LIKE try_file.try03,
        ima02       LIKE ima_file.ima02,
        oeb12       LIKE oeb_file.oeb12,
        oeb12_1     LIKE oeb_file.oeb12,
        try04       LIKE try_file.try04,
        try10       LIKE try_file.try10,
        try05       LIKE try_file.try05,
        try07       LIKE try_file.try07,
        try08       LIKE try_file.try08,
        try09       LIKE try_file.try09,
        try06       LIKE try_file.try06 
                    END RECORD,
    g_try_t         RECORD   #程式變數(Program Variables)
        try01       LIKE try_file.try01,  
        try02       LIKE try_file.try02,
        try03       LIKE try_file.try03,
        ima02       LIKE ima_file.ima02,
        oeb12       LIKE oeb_file.oeb12,
        oeb12_1     LIKE oeb_file.oeb12,
        try04       LIKE try_file.try04,
        try10       LIKE try_file.try10,
        try05       LIKE try_file.try05,
        try07       LIKE try_file.try07,
        try08       LIKE try_file.try08,
        try09       LIKE try_file.try09,
        try06       LIKE try_file.try06 
                    END RECORD,
    g_wc2,g_sql     STRING, 
    g_wc            STRING, 
    g_rec_b         LIKE type_file.num5,       #單身筆數      
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT       
DEFINE p_row,p_col  LIKE type_file.num5     
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_i          LIKE type_file.num5        #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE l_table      STRING                             
DEFINE g_str        STRING                             
DEFINE g_before_input_done    LIKE type_file.num5      
DEFINE g_argv1      LIKE oea_file.oea01
 
MAIN
 
   OPTIONS                                     #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                             #擷取中斷鍵, 由程式處理
    
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   SELECT aza50 INTO g_aza.aza50 
     FROM aza_file
   IF g_aza.aza50 = 'N' THEN
      CALL cl_err('','axm-068',1)
      EXIT PROGRAM
   END IF
 
   LET p_row = 3 LET p_col = 16
   OPEN WINDOW i300_w AT p_row,p_col WITH FORM "atm/42f/atmi300"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()
   IF g_argv1 IS NULL THEN
      LET g_wc2 = '1=1' CALL i300_b_fill(g_wc2)
      CALL i300_menu()
   ELSE
      LET g_wc = " oea01='",g_argv1,"'"
      CALL i300_p()
      CALL i300_menu()
   END IF
   CLOSE WINDOW i300_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i300_menu()
 
   WHILE TRUE
      CALL i300_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i300_q()
            END IF
 
         WHEN "detail"  
            IF cl_chk_act_auth() THEN
               CALL i300_b() 
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_try),'','')
            END IF
 
         WHEN "complete"  
            IF cl_chk_act_auth() THEN
               CALL i300_c() 
            END IF
 
         WHEN "piliang"  
            IF cl_chk_act_auth() THEN
               CALL i300_p() 
            END IF
  
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i300_q()
   CALL i300_b_askkey()
END FUNCTION
 
FUNCTION i300_c()
   IF g_try[l_ac].try06 = 'Y' THEN
      CALL cl_err('','atm-903',0)
   ELSE
      UPDATE try_file SET try06='Y'
       WHERE try01=g_try[l_ac].try01
         AND try02=g_try[l_ac].try02
      LET g_try[l_ac].try06='Y'
   END IF
END FUNCTION
 
FUNCTION i300_p()
   DEFINE l_oeb RECORD LIKE oeb_file.*
   DEFINE l_try RECORD LIKE try_file.*
   DEFINE l_sql STRING
   DEFINE l_n   SMALLINT
   
   IF g_argv1 IS NULL THEN
      LET p_row=3 LET p_col=4
      OPEN WINDOW i300_w_1 AT p_row,p_col WITH FORM "atm/42f/atmi300_1"
           ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
      CALL cl_ui_init()
      
      CONSTRUCT BY NAME g_wc ON oea12,oea01,oea03,oeb04 
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP                                                       
            CASE                                                                  
               WHEN INFIELD(oea12)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_tqp02"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea12
               WHEN INFIELD(oea01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_oea03"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea01
               WHEN INFIELD(oea03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_occ"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea03
               WHEN INFIELD(oeb04)
#FUN-AA0059---------mod------------str-----------------
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form = "q_ima"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                    DISPLAY g_qryparam.multiret TO oeb04
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
      
         ON ACTION qbe_select
            CALL cl_qbe_select() 
         
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup') #FUN-980030
 
      CLOSE WINDOW i300_w_1
 
   END IF
 
   
   IF INT_FLAG THEN
      LET INT_FLAG =0
      RETURN
   ELSE
      LET l_sql ="SELECT oeb_file.* FROM oeb_file,oea_file ",
                 "WHERE oeb01=oea01 AND oeb1012='Y' AND oeb12-oeb24+oeb25-oeb26>0 ",
                 "  AND oeb1003='1' AND oeaconf='Y' AND ",g_wc CLIPPED
      PREPARE i300_pre FROM l_sql
      DECLARE i300_cs CURSOR FOR i300_pre
      
      LET l_ac = 1
      CALL g_try.clear()
      FOREACH i300_cs INTO l_oeb.*
         LET l_n=0
         SELECT COUNT(*) INTO l_n FROM try_file 
          WHERE try01=l_oeb.oeb01 
            AND try02=l_oeb.oeb03
         IF l_n > 0 THEN 
            CONTINUE FOREACH
         ELSE
            LET l_try.try01=l_oeb.oeb01
            LET l_try.try02=l_oeb.oeb03
            LET l_try.try03=l_oeb.oeb04
            LET l_try.try04=l_oeb.oeb12-l_oeb.oeb24+l_oeb.oeb25-l_oeb.oeb26
            LET l_try.try05=l_oeb.oeb05
            LET l_try.try06='N'
            LET l_try.try07=l_oeb.oeb935
            LET l_try.try08=l_oeb.oeb936
            LET l_try.try09=l_oeb.oeb1001
            LET l_try.try10=0
            LET l_try.tryplant = g_plant #FUN-980009
            LET l_try.trylegal = g_legal #FUN-980009
            INSERT INTO try_file values(l_try.*)
            LET g_try[l_ac].try01= l_try.try01
            LET g_try[l_ac].try02= l_try.try02
            LET g_try[l_ac].try03= l_try.try03
            LET g_try[l_ac].try04= l_try.try04
            LET g_try[l_ac].try05= l_try.try05
            LET g_try[l_ac].try06= l_try.try06
            LET g_try[l_ac].try07= l_try.try07
            LET g_try[l_ac].try08= l_try.try08
            LET g_try[l_ac].try09= l_try.try09
            LET g_try[l_ac].try10= l_try.try10
            LET l_ac = l_ac+1
         END IF
      END FOREACH
   END IF
   
   LET g_rec_b = l_ac-1
   CALL g_try.deleteElement(l_ac)
   LET l_ac = l_ac-1
   CALL i300_b()
 
END FUNCTION
 
FUNCTION i300_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       
   l_n             LIKE type_file.num5,                #檢查重複用    
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否    
   p_cmd           LIKE type_file.chr1,                #處理狀態      
   l_allow_insert  LIKE type_file.num5,                #可新增否      
   l_allow_delete  LIKE type_file.num5,                #可刪除否      
   l_try04         LIKE try_file.try04,                #
   l_oeaconf       LIKE oea_file.oeaconf,              #審核否
   l_oeb1012       LIKE oeb_file.oeb1012               #是否搭增
   
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT try01,try02,try03,try04,try05,try06,try07,try08,try09,try10",
                      "  FROM try_file WHERE try01=? AND try02=? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_try WITHOUT DEFAULTS FROM s_try.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'               #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_try_t.* = g_try[l_ac].*  #BACKUP
            LET g_before_input_done = FALSE   
            CALL i300_set_entry_b(p_cmd)                                                                                         
            CALL i300_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
 
            BEGIN WORK
 
            OPEN i300_bcl USING g_try[l_ac].try01,g_try[l_ac].try02
            IF STATUS THEN
               CALL cl_err("OPEN i300_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i300_bcl INTO g_try[l_ac].try01,g_try[l_ac].try02,g_try[l_ac].try03,
                                   g_try[l_ac].try04,g_try[l_ac].try05,g_try[l_ac].try06,
                                   g_try[l_ac].try07,g_try[l_ac].try08,g_try[l_ac].try09,
                                   g_try[l_ac].try10
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_try[l_ac].try01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT ima02 
                 INTO g_try[l_ac].ima02
                 FROM ima_file 
                WHERE ima01 = g_try[l_ac].try03 
 
               SELECT oeb12,(oeb24-oeb25)
                 INTO g_try[l_ac].oeb12,g_try[l_ac].oeb12_1
                 FROM oea_file,oeb_file 
                WHERE oea01=oeb01
                  AND oeb01 = g_try[l_ac].try01 
                  AND oeb02 = g_try[l_ac].try02
            END IF
            CALL cl_show_fld_cont()    
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE                                                                                      
         CALL i300_set_entry_b(p_cmd)                                                                                         
         CALL i300_set_no_entry_b(p_cmd)                                                                                      
         LET g_before_input_done = TRUE                                                                                       
         INITIALIZE g_try[l_ac].* TO NULL      
         LET g_try[l_ac].try10 = 0
         LET g_try[l_ac].try06 = 'N'
         LET g_try_t.* = g_try[l_ac].*         
         CALL cl_show_fld_cont()
         NEXT FIELD try01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO try_file(try01,try02,try03,try04,try05,
                              try06,try07,try08,try09,try10,
                              tryplant,trylegal) #FUN-980009
                       VALUES(g_try[l_ac].try01,g_try[l_ac].try02,
                              g_try[l_ac].try03,g_try[l_ac].try04,
                              g_try[l_ac].try05,g_try[l_ac].try06,
                              g_try[l_ac].try07,g_try[l_ac].try08,
                              g_try[l_ac].try09,g_try[l_ac].try10,
                              g_plant,g_legal) #FUN-980009
         IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","try_file",g_try[l_ac].try01,"",SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2 
         END IF
 
      AFTER FIELD try01       
         IF NOT cl_null(g_try[l_ac].try01) THEN 
            LET l_n = 0
            SELECT count(*) INTO l_n 
              FROM oea_file,oeb_file
             WHERE oea01 = oeb01 
               AND oeb01 = g_try[l_ac].try01
            IF l_n = 0 THEN
               CALL cl_err('','asf-959',0)
               NEXT FIELD try01
            END IF
            IF NOT cl_null(g_try[l_ac].try02) THEN
               LET l_n = 0
               SELECT count(*) INTO l_n 
                 FROM oea_file,oeb_file
                WHERE oea01 = oeb01 
                  AND oeb01 = g_try[l_ac].try01
                  AND oeb03 = g_try[l_ac].try02
               IF l_n = 0 THEN
                  CALL cl_err('','atm-901',0)
                  NEXT FIELD try01
               ELSE 
                  LET l_n = 0
                  SELECT count(*) INTO l_n 
                    FROM try_file
                   WHERE try01 = g_try[l_ac].try01
                     AND try02 = g_try[l_ac].try02
                  IF p_cmd = 'a' AND l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_try[l_ac].try01 = g_try_t.try01
                     NEXT FIELD try01
                  ELSE
                     #根據訂單單號和項次抓出 料號,品名,原應返數量,已返數量，
                     #                       默認需要補返數量,銷售單位,來源合同編號,
                     #                       來源合同項次
                     SELECT oeb04,oeb12,(oeb24-oeb25),(oeb12-oeb24+oeb25-oeb26),
                            oeb05,oeb935,oeb936,oeaconf,oeb1012
                       INTO g_try[l_ac].try03,g_try[l_ac].oeb12,g_try[l_ac].oeb12_1,
                            l_try04,g_try[l_ac].try05,g_try[l_ac].try07,
                            g_try[l_ac].try08,l_oeaconf,l_oeb1012
                       FROM oea_file,oeb_file
                      WHERE oea01=oeb01
                        AND oeb01=g_try[l_ac].try01
                        AND oeb03=g_try[l_ac].try02
 
                     SELECT ima02 INTO g_try[l_ac].ima02
                       FROM ima_file
                      WHERE ima01=g_try[l_ac].try03
                     
                     IF p_cmd = 'a' OR (p_cmd = 'u' AND g_try[l_ac].try01 != g_try_t.try01) THEN
                        LET g_try[l_ac].try04 = l_try04
                     END IF
                     
                     IF l_oeaconf = 'N' THEN
                        CALL cl_err('','9029',0)
                        NEXT FIELD try01
                     END IF
 
                     IF l_oeb1012 = 'N' THEN
                        CALL cl_err('','atm-889',0)
                        NEXT FIELD try01
                     END IF
 
                     IF l_try04 <=0  THEN
                        CALL cl_err('','atm-900',0)
                        NEXT FIELD try01
                     END IF
                  END IF
               END IF
            END IF
            IF cl_null(g_try[l_ac].try02) THEN
               NEXT FIELD try02
            END IF
         END IF
 
      AFTER FIELD try02
         IF NOT cl_null(g_try[l_ac].try02) THEN 
            IF NOT cl_null(g_try[l_ac].try01) THEN
               LET l_n = 0
               SELECT count(*) INTO l_n 
                 FROM oea_file,oeb_file
                WHERE oea01 = oeb01 
                  AND oeb01 = g_try[l_ac].try01
                  AND oeb03 = g_try[l_ac].try02
               IF l_n = 0 THEN
                  CALL cl_err('','asf-959',0)
                  NEXT FIELD try02
               ELSE 
                  LET l_n = 0
                  SELECT count(*) INTO l_n 
                    FROM try_file
                   WHERE try01 = g_try[l_ac].try01
                     AND try02 = g_try[l_ac].try02
                  IF p_cmd = 'a' AND l_n > 0 THEN
                     CALL cl_err('','atm-901',0)
                     NEXT FIELD try02
                  ELSE
                     #根據訂單單號和項次抓出 料號,品名,原應返數量,已返數量，
                     #                       默認需要補返數量,銷售單位,來源合同編號,
                     #                       來源合同項次
                     SELECT oeb04,oeb12,(oeb24-oeb25),(oeb12-oeb24+oeb25-oeb26),
                            oeb05,oeb935,oeb936,oeaconf,oeb1012
                       INTO g_try[l_ac].try03,g_try[l_ac].oeb12,g_try[l_ac].oeb12_1,
                            l_try04,g_try[l_ac].try05,g_try[l_ac].try07,
                            g_try[l_ac].try08,l_oeaconf,l_oeb1012
                       FROM oea_file,oeb_file
                      WHERE oea01=oeb01
                        AND oeb01=g_try[l_ac].try01
                        AND oeb03=g_try[l_ac].try02
 
                     SELECT ima02 INTO g_try[l_ac].ima02
                       FROM ima_file
                      WHERE ima01=g_try[l_ac].try03
                     
                     IF p_cmd = 'a' OR (p_cmd = 'u' AND g_try[l_ac].try02 != g_try_t.try02) THEN
                        LET g_try[l_ac].try04 = l_try04
                     END IF
 
                     IF l_oeaconf = 'N' THEN
                        CALL cl_err('','9029',0)
                        NEXT FIELD try01
                     END IF
 
                     IF l_oeb1012 = 'N' THEN
                        CALL cl_err('','atm-889',0)
                        NEXT FIELD try01
                     END IF
 
                     IF l_try04 <=0  THEN
                        CALL cl_err('','atm-900',0)
                        NEXT FIELD try01
                     END IF
 
                  END IF
               END IF
            END IF
 
            IF cl_null(g_try[l_ac].try01) THEN
               NEXT FIELD try01
            END IF
         END IF
 
      AFTER FIELD try04
         IF NOT cl_null(g_try[l_ac].try04) THEN
            #No.FUN-BB0086--add--begin--
            LET g_try[l_ac].try04 = s_digqty(g_try[l_ac].try04,g_try[l_ac].try05)
            DISPLAY BY NAME g_try[l_ac].try04
            #No.FUN-BB0086--add--begin--
            IF g_try[l_ac].try04 <0 OR g_try[l_ac].try04 < g_try[l_ac].try10 
               OR g_try[l_ac].try04 > l_try04  THEN
               CALL cl_err('','atm-902',0)
               NEXT FIELD try04
            END IF
         END IF
 
      AFTER FIELD try09
         IF NOT cl_null(g_try[l_ac].try09) THEN
            LET l_n =0
            SELECT COUNT(*) INTO l_n
              FROM azf_file
             WHERE azf01 = g_try[l_ac].try09
               AND azf09 ='2'
               AND azf10 = 'Y'
               AND azfacti = 'Y'
            IF l_n <1 THEN
               CALL cl_err('','atm-352',0)
               NEXT FIELD try09
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_try_t.try01 IS NOT NULL THEN
             LET l_n =0 
             SELECT COUNT(*) INTO l_n 
               FROM oea_file,oeb_file
              WHERE oea01=oeb01
                AND oeb935=g_try[l_ac].try01
                AND oeb936=g_try[l_ac].try02
             IF l_n > 0 THEN
                CALL cl_err('','atm-904',0)
                CANCEL DELETE 
             END IF
             IF g_try[l_ac].try10 >0 THEN
                CALL cl_err('','atm-906',0)
                CANCEL DELETE
             END IF
             IF g_try[l_ac].try06 ='Y' THEN
                CALL cl_err('','atm-905',0)
                CANCEL DELETE
             END IF
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             
             DELETE FROM try_file WHERE try01 = g_try_t.try01 AND try02 = g_try_t.try02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","try_file",g_try_t.try01,"",SQLCA.sqlcode,
                             "","",1)  
                ROLLBACK WORK
                CANCEL DELETE 
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2 
             MESSAGE "Delete OK"
             CLOSE i300_bcl
             COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_try[l_ac].* = g_try_t.*
            CLOSE i300_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_try[l_ac].try01,-263,1)
            LET g_try[l_ac].* = g_try_t.*
         ELSE
            UPDATE try_file SET try01   = g_try[l_ac].try01,
                                try02   = g_try[l_ac].try02,
                                try03   = g_try[l_ac].try03,
                                try04   = g_try[l_ac].try04,
                                try05   = g_try[l_ac].try05,
                                try06   = g_try[l_ac].try06,
                                try07   = g_try[l_ac].try07,
                                try08   = g_try[l_ac].try08,
                                try09   = g_try[l_ac].try09,
                                try10   = g_try[l_ac].try10  
              WHERE try01 = g_try_t.try01
                AND try02 = g_try_t.try02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","try_file",g_try[l_ac].try01,"",SQLCA.sqlcode,
                            "","",1) 
               LET g_try[l_ac].* = g_try_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               CLOSE i300_bcl
               COMMIT WORK
            END IF
         END IF
      
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30033 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_try[l_ac].* = g_try_t.*
            #FUN-D30033--add--begin--
            ELSE
               CALL g_try.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30033--add--end----
            END IF
            CLOSE i300_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac #FUN-D30033 add
         CLOSE i300_bcl
         COMMIT WORK
 
      ON ACTION CONTROLN
         CALL i300_b_askkey()
         EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(try01) AND l_ac > 1 THEN
            LET g_try[l_ac].* = g_try[l_ac-1].*
            NEXT FIELD try01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP                                                      
         CASE                                                                 
            WHEN INFIELD(try01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oea08"
                 LET g_qryparam.default1 = g_try[l_ac].try01
                 CALL cl_create_qry() RETURNING g_try[l_ac].try01,g_try[l_ac].try02
                 DISPLAY BY NAME g_try[l_ac].try01,g_try[l_ac].try02
            WHEN INFIELD(try09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azf05"
                 LET g_qryparam.arg1 = "2"
                 LET g_qryparam.default1 = g_try[l_ac].try09
                 CALL cl_create_qry() RETURNING g_try[l_ac].try09
                 DISPLAY BY NAME g_try[l_ac].try09
         END CASE  
 
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
 
   CLOSE i300_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i300_b_askkey()
   CLEAR FORM
   CALL g_try.clear()
   CONSTRUCT g_wc2 ON try01,try02,try03,ima02,oeb12,try04,try10,try05,try07,try08,try09,try06
                 FROM s_try[1].try01,s_try[1].try02,s_try[1].try03,s_try[1].ima02,
                      s_try[1].oeb12,s_try[1].try04,s_try[1].try10,
                      s_try[1].try05,s_try[1].try07,s_try[1].try08,s_try[1].try09,s_try[1].try06
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP                                                       
         CASE                                                                  
            WHEN INFIELD(try01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oea08"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_try[1].try01
            WHEN INFIELD(try03)
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima"
#                LET g_qryparam.state = "c"
#                LET g_qryparam.default1 = g_try[l_ac].try03
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima","",g_try[l_ac].try03,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO s_try[1].try03
            WHEN INFIELD(try05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_try[l_ac].try05
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_try[1].try05
            WHEN INFIELD(try09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = "2"
                 LET g_qryparam.form = "q_azf05"
                 LET g_qryparam.default1 = g_try[l_ac].try09
                 CALL cl_create_qry() RETURNING g_try[l_ac].try09
                 DISPLAY BY NAME g_try[l_ac].try09
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
   
      ON ACTION qbe_select
         CALL cl_qbe_select() 
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL i300_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i300_b_fill(p_wc2)       
   DEFINE 
      #p_wc2        LIKE type_file.chr1000   
       p_wc2        STRING       #NO.FUN-910082
       
   LET g_sql =
       "SELECT try01,try02,try03,ima02,oeb12,oeb24-oeb25,try04,try10,try05,try07,try08,try09,try06",
       "  FROM try_file,oeb_file LEFT OUTER JOIN ima_file ON oeb04 = ima01 ,oea_file ",    #TQC-9B0016 mod
       #" WHERE try01=oeb01 AND try02=oeb03 AND oea01=oeb01 AND oeb04=ima01(+) AND ", p_wc2 CLIPPED,  
       " WHERE try01=oeb01 AND try02=oeb03 AND oea01=oeb01 AND ", p_wc2 CLIPPED,           #TQC-9B0016 mod 
       " ORDER BY try01,try02 "
   PREPARE i300_pb FROM g_sql
   DECLARE try_curs CURSOR FOR i300_pb
 
   CALL g_try.clear()
   LET g_cnt = 1
 
   MESSAGE "Searching!" 
   FOREACH try_curs INTO g_try[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN 
          CALL cl_err('foreach:',STATUS,1) 
          EXIT FOREACH 
       END IF
 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_try.deleteElement(g_cnt)
 
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2 
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_try TO s_try.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()            
 
      ON ACTION query
         LET g_action_choice="query"
         LET l_ac = 1    #FUN-AA0059 add
         EXIT DISPLAY
 
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
   
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION complete
         LET g_action_choice="complete"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
         
      ON ACTION piliang
         LET g_action_choice="piliang"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i300_set_entry_b(p_cmd)                                                                                                    
   DEFINE p_cmd   LIKE type_file.chr1       
                                                                                                                                     
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
      CALL cl_set_comp_entry("try01",TRUE)                                                                                           
   END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
 
FUNCTION i300_set_no_entry_b(p_cmd)                                                                                                 
   DEFINE p_cmd   LIKE type_file.chr1      
   
   CALL cl_set_comp_entry("try03,ima02,oeb12,oeb12_1,try10,try05,try07,try08,try06",FALSE) 
                                                                                                                                     
END FUNCTION                                                                                                                        
