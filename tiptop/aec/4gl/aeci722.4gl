# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aeci722.4gl
# Descriptions...: 
# Date & Author..: 080602 by hongmei 
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980002 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0036 09/11/05 By wujie 5.2SQL转标准语法
# Modify.........: No.FUN-A60081 10/06/25 By vealxu MAX(ecm03)相關
# Modify.........: No.FUN-A60092 10/06/29 By lilingyu 平行工藝
# Modify.........: No.FUN-A70131 10/07/29 By destiny 平行工藝
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B10056 11/02/12 By vealxu 拿掉檢查存在工單備料的邏輯
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B80022 11/08/02 By jason INSERT INTO ecm_file給ecm66預設值'Y'
# Modify.........: No.FUN-B80046 11/08/03 By minpp 程序撰写规范修改 
# Modify.........: No.CHI-C30002 12/05/16 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.TQC-C50194 12/05/22 By fengrui 欄位跳轉時,考慮欄位的隱藏與關閉,作廢工單不可變更,程式修正
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.CHI-C80041 13/02/05 By bart 無單身刪除單頭
# Modify.........: No:CHI-D20010 13/02/19 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_sgh   RECORD LIKE sgh_file.*,
    g_sgh_t RECORD LIKE sgh_file.*,
    g_sgh_o RECORD LIKE sgh_file.*,
    g_sgi   DYNAMIC ARRAY OF RECORD
            sgi02    LIKE sgi_file.sgi02,
            sgi03    LIKE sgi_file.sgi03,
            sgi012a  LIKE sgi_file.sgi012a,   #FUN-A60092 
            sgi012b  LIKE sgi_file.sgi012b,   #FUN-A60092             
            sgi04a   LIKE sgi_file.sgi04a,
            sgi04b   LIKE sgi_file.sgi04b,
            sgi05a   LIKE sgi_file.sgi05a,
            ecm45a   LIKE ecm_file.ecm45,
            sgi05b   LIKE sgi_file.sgi05b,
            ecm45b   LIKE ecm_file.ecm45,
            sgi06a   LIKE sgi_file.sgi06a, 
            eca02a   LIKE eca_file.eca02,
            sgi06b   LIKE sgi_file.sgi06b,
            eca02b   LIKE eca_file.eca02,
            sgi07a   LIKE sgi_file.sgi07a,
            sgi07b   LIKE sgi_file.sgi07b,
            sgi09a   LIKE sgi_file.sgi09a,
            sgi09b   LIKE sgi_file.sgi09b,
            sgi11a   LIKE sgi_file.sgi11a,
            sgi11b   LIKE sgi_file.sgi11b,
            sgi12a   LIKE sgi_file.sgi12a,
            sgi12b   LIKE sgi_file.sgi12b,
            sgi08a   LIKE sgi_file.sgi08a,
            sgi08b   LIKE sgi_file.sgi08b,
            sgi10a   LIKE sgi_file.sgi10a,
            sgi10b   LIKE sgi_file.sgi10b,
            sgi13a   LIKE sgi_file.sgi13a,
            sgi13b   LIKE sgi_file.sgi13b,
            sgi14a   LIKE sgi_file.sgi14a,
            sgi14b   LIKE sgi_file.sgi14b 
            END RECORD,
    g_sgi_t         RECORD
            sgi02    LIKE sgi_file.sgi02,
            sgi03    LIKE sgi_file.sgi03,
            sgi012a  LIKE sgi_file.sgi012a,   #FUN-A60092 
            sgi012b  LIKE sgi_file.sgi012b,   #FUN-A60092             
            sgi04a   LIKE sgi_file.sgi04a,
            sgi04b   LIKE sgi_file.sgi04b,
            sgi05a   LIKE sgi_file.sgi05a,
            ecm45a   LIKE ecm_file.ecm45,
            sgi05b   LIKE sgi_file.sgi05b,
            ecm45b   LIKE ecm_file.ecm45,
            sgi06a   LIKE sgi_file.sgi06a,
            eca02a   LIKE eca_file.eca02,
            sgi06b   LIKE sgi_file.sgi06b,
            eca02b   LIKE eca_file.eca02,
            sgi07a   LIKE sgi_file.sgi07a,
            sgi07b   LIKE sgi_file.sgi07b,
            sgi09a   LIKE sgi_file.sgi09a,
            sgi09b   LIKE sgi_file.sgi09b,
            sgi11a   LIKE sgi_file.sgi11a,
            sgi11b   LIKE sgi_file.sgi11b,
            sgi12a   LIKE sgi_file.sgi12a,
            sgi12b   LIKE sgi_file.sgi12b,
            sgi08a   LIKE sgi_file.sgi08a,
            sgi08b   LIKE sgi_file.sgi08b,
            sgi10a   LIKE sgi_file.sgi10a,
            sgi10b   LIKE sgi_file.sgi10b,
            sgi13a   LIKE sgi_file.sgi13a,
            sgi13b   LIKE sgi_file.sgi13b,
            sgi14a   LIKE sgi_file.sgi14a,
            sgi14b   LIKE sgi_file.sgi14b
                    END RECORD,
    b_sgi       RECORD  LIKE sgi_file.*,
    l_sgi       RECORD  LIKE sgi_file.*,
    g_wc,g_wc3,g_sql  STRING,
    g_t1            LIKE type_file.chr5, 
    g_sw            LIKE type_file.chr1,
    g_buf           LIKE type_file.chr20,
    g_rec_b         LIKE type_file.num5,
    g_void          LIKE type_file.chr1,
    g_approve       LIKE type_file.chr1,
    g_confirm       LIKE type_file.chr1,
    g_rec_t         LIKE type_file.num5,
    l_ac            LIKE type_file.num5,
    l_sl            LIKE type_file.num5,
    g_argv1         LIKE sgh_file.sgh01,
    g_before_input_done  LIKE type_file.num5
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   g_msg           LIKE type_file.chr1000
DEFINE   g_row_count     LIKE type_file.num10
DEFINE   g_curs_index    LIKE type_file.num10
DEFINE   g_jump          LIKE type_file.num10
DEFINE   g_no_ask       LIKE type_file.num10
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_argv1 = ARG_VAL(1)			# ECN No.

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    OPEN WINDOW i722_w WITH FORM "aec/42f/aeci722" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    LET g_forupd_sql = "SELECT * FROM sgh_file WHERE sgh01 = ? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i722_cl CURSOR FROM g_forupd_sql

#FUN-A60092 --begin--
   IF g_sma.sma541 = 'Y' THEN 
      CALL cl_set_comp_visible("sgi012a,sgi012b",TRUE)
   ELSE
      CALL cl_set_comp_visible("sgi012a,sgi012b",FALSE)
   END IF 	
#FUN-A60092 --end--

    CALL i722_menu()
    CLOSE WINDOW i722_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i722_cs()
    CLEAR FORM
    CALL g_sgi.clear()
 
    CONSTRUCT BY NAME g_wc ON
        sgh01,sgh02,sgh03,sgh04,
        sgh05,sgh07,sgh09,sgh10,
        sgh06,sgh08,sghconf,sghuser,sghmodu,
        sghgrup,sghdate
 
        ON ACTION controlp                  
          CASE WHEN INFIELD(sgh01)    #查詢單據
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_sgh"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sgh01
                    NEXT FIELD sgh01
               WHEN INFIELD(sgh07)   #查詢責任人
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sgh07
                    NEXT FIELD sgh07
               WHEN INFIELD(sgh02)
#FUN-AA0059 --Begin--
               #     CALL cl_init_qry_var()
               #     LET g_qryparam.form ="q_ima"
               #     LET g_qryparam.state = "c"
               #     CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                    DISPLAY g_qryparam.multiret TO sgh02
                    NEXT FIELD sgh02
               WHEN INFIELD(sgh03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_ecb1"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sgh03
                    NEXT FIELD sgh03
               WHEN INFIELD(sgh06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_azf"
                    LET g_qryparam.arg1 = '2'
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sgh06
                    NEXT FIELD sgh06
               WHEN INFIELD(sgh09)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_sfb08"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sgh09
                    NEXT FIELD sgh09
               WHEN INFIELD(sgh10)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_sfc"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sgh10
                    NEXT FIELD sgh10
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
LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sghuser', 'sghgrup') #FUN-980030
 
       IF INT_FLAG THEN RETURN END IF
       CONSTRUCT g_wc3 ON sgi02,sgi03,sgi012a,sgi012b,sgi04a,sgi04b,   #FUN-A60092 add sgi012a,sgi012b
                          sgi05a,sgi05b,sgi06a,sgi06b,
                          sgi07a,sgi07b,sgi09a,sgi09b,
                          sgi11a,sgi11b,sgi12a,sgi12b,
                          sgi08a,sgi08b,sgi10a,sgi10b,
                          sgi13a,sgi13b,sgi14a,sgi14b 
            FROM s_sgi[1].sgi02,s_sgi[1].sgi03,
                 s_sgi[1].sgi012a,s_sgi[1].sgi012b,   #FUN-A60092 add
                 s_sgi[1].sgi04a,s_sgi[1].sgi04b,
                 s_sgi[1].sgi05a,s_sgi[1].sgi05b,
                 s_sgi[1].sgi06a,s_sgi[1].sgi06b,
                 s_sgi[1].sgi07a,s_sgi[1].sgi07b,
                 s_sgi[1].sgi09a,s_sgi[1].sgi09b,
                 s_sgi[1].sgi11a,s_sgi[1].sgi11b,
                 s_sgi[1].sgi12a,s_sgi[1].sgi12b,
                 s_sgi[1].sgi08a,s_sgi[1].sgi08b,
                 s_sgi[1].sgi10a,s_sgi[1].sgi10b,
                 s_sgi[1].sgi13a,s_sgi[1].sgi13b,
                 s_sgi[1].sgi14a,s_sgi[1].sgi14b
               
        ON ACTION controlp
           CASE 
#FUN-A60092 --begin--
               WHEN INFIELD(sgi012a) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_sgi012a"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sgi012a
                     NEXT FIELD sgi012a
                     
               WHEN INFIELD(sgi012b) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_sgi012b"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sgi012b
                     NEXT FIELD sgi012b                     
#FUN-A60092 --end--
           
               WHEN INFIELD(sgi05a) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ecd3"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sgi05a
                     NEXT FIELD sgi05a
               WHEN INFIELD(sgi06a) 
#No.FUN-jan--begin--
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form = "q_eca"
#                     LET g_qryparam.state = "c"
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
#No.FUN-jan-end--
                     CALL q_eca(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sgi06a 
                     NEXT FIELD sgi06a 
               WHEN INFIELD(sgi05b)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ecd3"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sgi05b
                     NEXT FIELD sgi05b
               WHEN INFIELD(sgi06b)
#No.FUN-jan--BEGIN--
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form = "q_eca"
#                     LET g_qryparam.state = "c"
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_eca(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sgi06b
                     NEXT FIELD sgi06b 
                OTHERWISE EXIT CASE
#No.FUN-jan--END--
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
       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN
    #        LET g_wc = g_wc clipped," AND sghuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN
    #        LET g_wc = g_wc clipped," AND sghgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
    IF g_wc3 = " 1=1" THEN
              LET g_sql = "SELECT sgh01 FROM sgh_file",          #mod by liuxqa 091019 
                          " WHERE ", g_wc CLIPPED,
                          " ORDER BY sgh01"                     #mod by liuxqa 091019
    ELSE
              LET g_sql = "SELECT UNIQUE sgh01 ",                    #mod by liuxqa 091019
                          "  FROM sgh_file, sgi_file",
                          " WHERE sgh01 = sgi01",
                          "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                          " ORDER BY sgh01"                          #mod by liuxqa 091019
    END IF  
 
    PREPARE i722_prepare FROM g_sql
    DECLARE i722_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i722_prepare
 
    IF g_wc3 = " 1=1" THEN      #取合乎條件的筆數
        LET g_sql="SELECT COUNT(*) FROM sgh_file WHERE ",g_wc CLIPPED
                                                  
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT sgh01) FROM sgh_file,sgi_file WHERE ",
                  "sgi01=sgh01 AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED
    END IF
    PREPARE i722_precount FROM g_sql
    DECLARE i722_count CURSOR FOR i722_precount
END FUNCTION
 
 
FUNCTION i722_menu()
DEFINE l_creator     LIKE type_file.chr1 
DEFINE l_flowuser    LIKE type_file.chr1  #是否指定加簽人員
 
   WHILE TRUE
      CALL i722_bp("G")
      
      CASE g_action_choice
         WHEN "insert"  
            IF cl_chk_act_auth() THEN
               CALL i722_a()
            END IF
            
         WHEN "modify" 
            IF cl_chk_act_auth() THEN 
               CALL i722_u() 
            END IF
                              
         WHEN "query"  
            IF cl_chk_act_auth() THEN 
               CALL i722_q() 
            END IF
                  
         WHEN "delete" 
            IF cl_chk_act_auth() THEN 
               CALL i722_r() 
            END IF      
            
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i722_y()
            END IF           
            
         WHEN "un_confirm"
            IF cl_chk_act_auth() THEN
               CALL i722_z()
            END IF            

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i722_b() 
            ELSE
               LET g_action_choice = NULL
            END IF       
                                    
         WHEN "p" #批次產生變更單
            IF cl_chk_act_auth() THEN
               CALL i722_p()
            END IF

         WHEN "change_release"  #變更發出
            IF cl_chk_act_auth()THEN
               CALL i722_g('Y') RETURNING g_success
            END IF

         #批次變更發出
         WHEN "batch_change_release"
            IF cl_chk_act_auth()THEN
               CALL i722_b_g()
            END IF
                                    
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"   
            CALL cl_cmdask()            
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sgi),'','')
            END IF                                          
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL i722_v()   #CHI-D20010
               CALL i722_v(1)   #CHI-D20010
            END IF
         #CHI-C80041---end
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL i722_v(2)   #CHI-D20010
            END IF
       #CHI-D20010---end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i722_a()
    DEFINE li_result  LIKE type_file.num5   
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_sgi.clear()
    INITIALIZE g_sgh.* TO NULL
    LET g_sgh_o.* = g_sgh.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_sgh.sgh04  = TODAY
        LET g_sgh.sghconf = 'N'
        LET g_sgh.sghuser = g_user
        LET g_sgh.sghgrup = g_grup
        LET g_sgh.sghmodu = NULL
        LET g_sgh.sghdate = TODAY
        DISPLAY BY NAME g_sgh.sgh04,g_sgh.sghconf,
                        g_sgh.sghuser,
                        g_sgh.sghgrup,g_sgh.sghmodu,
                        g_sgh.sghdate
        CALL i722_i("a")
        IF INT_FLAG THEN
           INITIALIZE g_sgh.* TO NULL
           LET INT_FLAG=0 CALL cl_err('',9001,0) ROLLBACK WORK EXIT WHILE
        END IF
        IF g_sgh.sgh01 IS NULL THEN CONTINUE WHILE END IF
        BEGIN WORK
        CALL s_auto_assign_no("asf",g_sgh.sgh01,g_sgh.sgh04,"I","sgh_file","sgh01","","","")
        RETURNING li_result,g_sgh.sgh01
        IF (NOT li_result) THEN                                      
           CONTINUE WHILE                                        
        END IF  
        DISPLAY BY NAME g_sgh.sgh01
        LET g_sgh.sghplant = g_plant #FUN-980002
        LET g_sgh.sghlegal = g_legal #FUN-980002
        LET g_sgh.sghoriu = g_user      #No.FUN-980030 10/01/04
        LET g_sgh.sghorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO sgh_file VALUES (g_sgh.*)
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('ins sgh: ',SQLCA.SQLCODE,1)   #FUN-B80046
            ROLLBACK WORK
        #   CALL cl_err('ins sgh: ',SQLCA.SQLCODE,1)  #FUN-B80046
           CONTINUE WHILE
        ELSE
           COMMIT WORK
        END IF
        LET g_sgh_t.* = g_sgh.*
        CALL g_sgi.clear()
        LET g_rec_b = 0
        CALL i722_b()
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i722_u()
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_sgh.* FROM sgh_file WHERE sgh01 = g_sgh.sgh01     #mod by liuxqa 091019
    IF g_sgh.sgh01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_sgh.sghconf = 'Y' THEN 
       CALL cl_err('','aap-086',0) RETURN 
    END IF
    IF g_sgh.sghconf = 'X' THEN RETURN END IF  #CHI-C80041
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_sgh_o.* = g_sgh.*
    BEGIN WORK
 
    OPEN i722_cl USING g_sgh.sgh01    #mod by liuxqa 091019
    IF STATUS THEN
       CALL cl_err("OPEN i722_cl:", STATUS, 1)
       CLOSE i722_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i722_cl INTO g_sgh.*
    IF STATUS THEN
        CALL cl_err('lock sgh:',SQLCA.sqlcode,0)
        CLOSE i722_cl ROLLBACK WORK RETURN
    END IF
    CALL i722_show()
    WHILE TRUE
        CALL i722_i("u")
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_sgh.*=g_sgh_t.*
            CALL i722_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE sgh_file SET * = g_sgh.* WHERE sgh01 = g_sgh_o.sgh01  #mod by liuxqa 091019
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err('upd sgh: ',SQLCA.SQLCODE,0)
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i722_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i722_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1
  DEFINE l_flag          LIKE type_file.chr1
  DEFINE li_result       LIKE type_file.num5,
         l_azf03         LIKE azf_file.azf03,
         l_gen02         LIKE gen_file.gen02,
         g_buf           LIKE azf_file.azf03,
         l_cnt           LIKE type_file.num5
  DEFINE l_ima02         LIKE ima_file.ima02,
         l_ima021        LIKE ima_file.ima021
 
    INPUT BY NAME
        g_sgh.sgh01,g_sgh.sgh09,
        g_sgh.sgh04,g_sgh.sgh05,g_sgh.sgh07,
        g_sgh.sgh06,
        g_sgh.sgh08
           WITHOUT DEFAULTS 
 
        BEFORE INPUT                                                          
            LET g_before_input_done = FALSE                         
            CALL i722_set_entry(p_cmd)                  
            CALL i722_set_no_entry(p_cmd)                        
            LET g_before_input_done = TRUE                      
 
        AFTER FIELD sgh06
          IF NOT cl_null(g_sgh.sgh06) THEN
             SELECT azf03 INTO l_azf03 FROM azf_file
              WHERE azf01 = g_sgh.sgh06
                AND azf02 = '2'
             DISPLAY l_azf03 TO FORMONLY.azf03
          END IF
        AFTER FIELD sgh01  
          IF NOT cl_null(g_sgh.sgh01) THEN
            CALL s_check_no("asf",g_sgh.sgh01,g_sgh_t.sgh01,"T","sgh_file","sgh01","")
            RETURNING li_result,g_sgh.sgh01
            IF(NOT li_result) THEN
               LET g_sgh.sgh01=g_sgh_o.sgh01 
                DISPLAY BY NAME g_sgh.sgh01
                 IF p_cmd='u' THEN
                    EXIT INPUT
                 ELSE
                    NEXT FIELD sgh01
                 END IF
            END IF   
          END IF
  
        AFTER FIELD sgh09
          IF NOT cl_null(g_sgh.sgh09) THEN
                LET l_cnt = 0
                SELECT COUNT(*) INTO l_cnt FROM sfb_file
                  WHERE sfb01 = g_sgh.sgh09
                IF l_cnt <= 0 THEN
                   CALL cl_err('','aec-087',1)
                   NEXT FIELD sgh09
                ELSE
                   #TQC-C50194--add--str--
                   LET l_cnt = 0
                   SELECT COUNT(*) INTO l_cnt FROM sfb_file
                    WHERE sfb01 = g_sgh.sgh09
                      AND (sfb87='X' OR sfb43='9')
                   IF l_cnt > 0 THEN
                      CALL cl_err('','asf-947',1)
                      NEXT FIELD sgh09 
                   END IF
                   #TQC-C50194--add--end--
                  #工單已存在未發出的變更單不能重復產生
                   LET l_cnt = 0
                   SELECT COUNT(*) INTO l_cnt
                     FROM sgh_file
                    WHERE sgh09 = g_sgh.sgh09
                 #    AND sgh01 <> g_sgh.sgh01   #mark by chenyu --08/07/09
#                     AND substr(sgh01,1,4) <> g_sgh.sgh01   #add by chenyu --08/07/09
                      AND sgh01[1,4] <> g_sgh.sgh01          #No.FUN-9B0036
                      AND (sgh05 is null OR length(sgh05) = 0 )    #FUN-A60092 unmark
                      AND sghconf <> 'X'  #CHI-C80041
                   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
                   IF l_cnt > 0 THEN
      	              CALL cl_err(g_sgh.sgh09,'aec-088',1)
      	              NEXT FIELD sgh09
                   END IF 
                   SELECT sfb06,sfb05,sfb85 
                     INTO g_sgh.sgh03,g_sgh.sgh02,
                          g_sgh.sgh10
                     FROM sfb_file
                    WHERE sfb01 = g_sgh.sgh09
                   IF cl_null(g_sgh.sgh03) THEN
                      CALL cl_err('','aec-091',1)
                      NEXT FIELD sgh09
                   ELSE
                      SELECT ima02,ima021 INTO l_ima02,l_ima021
                        FROM ima_file
                       WHERE ima01 = g_sgh.sgh02
                         AND imaacti = 'Y'
                      DISPLAY BY NAME g_sgh.sgh03,g_sgh.sgh02,
                                      g_sgh.sgh10
                      DISPLAY l_ima02 TO FORMONLY.ima02
                      DISPLAY l_ima021 TO FORMONLY.ima021
                   END IF
             END IF
          END IF
   
        AFTER FIELD sgh07
          IF NOT cl_null(g_sgh.sgh07) THEN
             SELECT gen02 INTO l_gen02 FROM gen_file
                WHERE gen01 = g_sgh.sgh07
             IF STATUS THEN
                CALL cl_err('select gen',STATUS,0)
                NEXT FIELD sgh07
             END IF
             IF cl_null(l_gen02) THEN
                LET l_gen02 = ' '
             END IF
             DISPLAY l_gen02 TO gen02
          END IF
 
        ON ACTION CONTROLP                  
          CASE 
              WHEN INFIELD(sgh01)  #查詢單據
                   LET g_t1=s_get_doc_no(g_sgh.sgh01)
                   CALL q_smy(FALSE,FALSE,g_t1,'asf','T') RETURNING g_t1 
                   LET g_sgh.sgh01=g_t1 
                   DISPLAY BY NAME g_sgh.sgh01 
                   NEXT FIELD sgh01
              WHEN INFIELD(sgh07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.default1 = g_sgh.sgh07
                   CALL cl_create_qry() RETURNING g_sgh.sgh07
                   DISPLAY BY NAME g_sgh.sgh07
                   NEXT FIELD sgh07
              WHEN INFIELD(sgh09)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sfb08"
                   LET g_qryparam.default1 = g_sgh.sgh09
                   CALL cl_create_qry() RETURNING g_sgh.sgh09
                   DISPLAY BY NAME g_sgh.sgh09
                   NEXT FIELD sgh09
              WHEN INFIELD(sgh06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_azf"
                    LET g_qryparam.default1 = g_sgh.sgh06
                    LET g_qryparam.arg1 = "2"
                    CALL cl_create_qry() RETURNING g_sgh.sgh06
                    DISPLAY BY NAME g_sgh.sgh06 
                    NEXT FIELD sgh06
          END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
       ON ACTION CONTROLG CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()    
 
      ON ACTION help          
         CALL cl_show_help() 
    
    END INPUT
END FUNCTION
 
FUNCTION i722_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_sgi.clear()
    DISPLAY ' ' TO FORMONLY.cnt
    CALL i722_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_sgh.* TO NULL RETURN END IF
    MESSAGE " SEARCHING ! " 
    OPEN i722_cs
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_sgh.* TO NULL
    ELSE
       OPEN i722_count
       FETCH i722_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL i722_fetch('F')
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i722_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i722_cs INTO g_sgh.sgh01      #mod by liuxqa 091019
        WHEN 'P' FETCH PREVIOUS i722_cs INTO g_sgh.sgh01      #mod by liuxqa 091019
        WHEN 'F' FETCH FIRST    i722_cs INTO g_sgh.sgh01      #mod by liuxqa 091019
        WHEN 'L' FETCH LAST     i722_cs INTO g_sgh.sgh01      #mod by liuxqa 091019
        WHEN '/'
      IF (NOT g_no_ask) THEN
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
      LET g_no_ask = FALSE
      FETCH ABSOLUTE g_jump i722_cs INTO g_sgh.sgh01   #mod by liuxqa 091019
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sgh.sgh01,SQLCA.sqlcode,0)
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
    
    SELECT * INTO g_sgh.* FROM sgh_file WHERE sgh01=g_sgh.sgh01   #mod by liuxqa  
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sgh.sgh01,SQLCA.sqlcode,0)
        INITIALIZE g_sgh.* TO NULL
        RETURN
    END IF
    
    CALL i722_show()
    
END FUNCTION
 
FUNCTION i722_show()
 DEFINE  l_gen02    LIKE  gen_file.gen02,
         l_azf03    LIKE  azf_file.azf03,
         l_ima02    LIKE  ima_file.ima02,
         l_ima021   LIKE  ima_file.ima021
 
    LET g_sgh_t.* = g_sgh.*
    DISPLAY BY NAME
        g_sgh.sgh01,g_sgh.sgh02,g_sgh.sgh03,
        g_sgh.sgh04,g_sgh.sgh05,g_sgh.sgh06,
        g_sgh.sgh07,g_sgh.sgh08,g_sgh.sgh09,
        g_sgh.sgh10,g_sgh.sghconf,
        g_sgh.sghuser,g_sgh.sghgrup,
        g_sgh.sghmodu,g_sgh.sghdate
 
    SELECT gen02 INTO l_gen02 FROM gen_file
       WHERE gen01 = g_sgh.sgh07
    IF cl_null(l_gen02) THEN
       LET l_gen02 = ' '
    END IF
    DISPLAY l_gen02 TO gen02
    SELECT azf03 INTO l_azf03 FROM azf_file
              WHERE azf01 = g_sgh.sgh06
                AND azf02 = '2'
    DISPLAY l_azf03 TO FORMONLY.azf03
    SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
      WHERE ima01 = g_sgh.sgh02
    IF cl_null(l_ima02) THEN LET l_ima02 = ' ' END IF
    IF cl_null(l_ima021) THEN LET l_ima021 = ' ' END IF
    DISPLAY l_ima02 TO ima02
    DISPLAY l_ima021 TO ima021
    IF cl_null(g_wc3) THEN LET g_wc3 = "1=1" END IF
    CALL i722_b_fill(g_wc3)
 
    CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION i722_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_row,l_col     LIKE type_file.num5,
    l_n,l_cnt,l_k   LIKE type_file.num5,
    p_cmd           LIKE type_file.chr1,
    l_b2      	    LIKE type_file.chr30,
    l_ima35         LIKE ima_file.ima35,
    l_ima36         LIKE ima_file.ima36,
#    l_sgi04a        LIKE sgi_file.sgi04a,   #TQC-C50194 mark
#    l_sgi04b        LIKE sgi_file.sgi04b,   #TQC-C50194 mark
#    l_shy06         LIKE shy_file.shy06,    #TQC-C50194 mark
#    l_pmn43         LIKE pmn_file.pmn43,    #TQC-C50194 mark
    l_lock_sw       LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5,
    l_chkinsitm     LIKE type_file.num5
#DEFINE  l_ecm301    LIKE ecm_file.ecm301     #add by chenyu --08/07/10  #TQC-C50194 mark
#DEFINE  l_ecm302    LIKE ecm_file.ecm302     #add by chenyu --08/07/10  #TQC-C50194 mark
#DEFINE  l_ecm303    LIKE ecm_file.ecm303     #add by chenyu --08/07/10  #TQC-C50194 mark
 
    LET g_action_choice = ""
    SELECT * INTO g_sgh.* FROM sgh_file WHERE sgh01=g_sgh.sgh01   #mod by liuxqa  
    IF cl_null(g_sgh.sgh01) THEN RETURN END IF
    IF g_sgh.sghconf = 'Y' THEN 
       CALL cl_err('','aap-086',0) RETURN 
    END IF
    IF g_sgh.sghconf = 'X' THEN RETURN END IF  #CHI-C80041
    
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
     "  SELECT * FROM sgi_file ",
     "   WHERE sgi01= ? ",
     "     AND sgi02= ? ",
     "  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i722_bcl CURSOR FROM g_forupd_sql 
    LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
      INPUT ARRAY g_sgi WITHOUT DEFAULTS FROM s_sgi.* 
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            LET g_before_input_done = FALSE
            #TQC-C50194--mark--str--
            #CALL i722_set_entry(p_cmd)
            #CALL i722_set_no_entry(p_cmd)
            #TQC-C50194--mark--end--
            LET g_before_input_done = TRUE
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR() 
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
	          
	          BEGIN WORK
            OPEN i722_cl USING g_sgh.sgh01   #mod by liuxqa 091019 
            IF STATUS THEN
               CALL cl_err("OPEN i722_cl:", STATUS, 1)
               CLOSE i722_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i722_cl INTO g_sgh.*
            IF STATUS THEN
               CALL cl_err('lock sgh:',SQLCA.sqlcode,0)
               CLOSE i722_cl 
               ROLLBACK WORK 
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_sgi_t.* = g_sgi[l_ac].*  #BACKUP
               OPEN i722_bcl USING g_sgh.sgh01,g_sgi_t.sgi02
               IF STATUS THEN
                   CALL cl_err("OPEN i722_bcl:", STATUS, 1)
               ELSE
                   FETCH i722_bcl INTO b_sgi.* 
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock sgi',SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       CALL i722_b_move_to()
                   END IF 
               END IF
               LET g_sgi_t.* = g_sgi[l_ac].*
               CALL cl_show_fld_cont() 
               #TQC-C50194--add--str--
               CALL i722_set_entry_b()
               CALL i722_set_no_entry_b()      
               CALL i722_set_no_required()   
               CALL i722_set_required()     
               #TQC-C50194--add--end--
               NEXT FIELD sgi02
            END IF
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            
            INSERT INTO sgi_file
                 VALUES(g_sgh.sgh01,g_sgi[l_ac].sgi02,
                        g_sgi[l_ac].sgi03,g_sgi[l_ac].sgi04a,
                        g_sgi[l_ac].sgi04b,g_sgi[l_ac].sgi05a,
                        g_sgi[l_ac].sgi05b,g_sgi[l_ac].sgi06a,
                        g_sgi[l_ac].sgi06b,g_sgi[l_ac].sgi07a,
                        g_sgi[l_ac].sgi07b,g_sgi[l_ac].sgi08a,
                        g_sgi[l_ac].sgi08b,g_sgi[l_ac].sgi09a,
                        g_sgi[l_ac].sgi09b,g_sgi[l_ac].sgi10a,
                        g_sgi[l_ac].sgi10b,g_sgi[l_ac].sgi11a,
                        g_sgi[l_ac].sgi11b,g_sgi[l_ac].sgi12a,
                        g_sgi[l_ac].sgi12b,g_sgi[l_ac].sgi13a,
                        g_sgi[l_ac].sgi13b,g_sgi[l_ac].sgi14a,
			                  g_sgi[l_ac].sgi14b,
                        g_plant,g_legal,     #FUN-980002
                        g_sgi[l_ac].sgi012a,g_sgi[l_ac].sgi012b)    #FUN-A60092 add 
            IF SQLCA.sqlcode THEN
               CALL cl_err('ins sgi',SQLCA.sqlcode,0)
               ROLLBACK WORK
               CANCEL INSERT
            ELSE 
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE INSERT
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_sgi[l_ac].* TO NULL
            INITIALIZE g_sgi_t.* TO NULL
            CALL cl_show_fld_cont()
            #TQC-C50194--add--str--
            CALL i722_set_entry_b()
            CALL i722_set_no_entry_b()      
            CALL i722_set_no_required()   
            CALL i722_set_required()     
            #TQC-C50194--add--end--
            NEXT FIELD sgi02
 
        BEFORE FIELD sgi02
            IF cl_null(g_sgi[l_ac].sgi02) 
               OR g_sgi[l_ac].sgi02 = 0 THEN
                SELECT max(sgi02)+1 INTO g_sgi[l_ac].sgi02
                   FROM sgi_file WHERE sgi01 = g_sgh.sgh01
                IF g_sgi[l_ac].sgi02 IS NULL THEN
                    LET g_sgi[l_ac].sgi02 = 1
                END IF
            END IF
 
        AFTER FIELD sgi02               #check序號是否重復
            IF NOT cl_null(g_sgi[l_ac].sgi02) THEN 
                IF g_sgi[l_ac].sgi02 != g_sgi_t.sgi02 OR
                   cl_null(g_sgi_t.sgi02) THEN
                    SELECT count(*) INTO l_n FROM sgi_file
                        WHERE sgi01 = g_sgh.sgh01 
                          AND sgi02 = g_sgi[l_ac].sgi02
                    IF l_n > 0 THEN
                        LET g_sgi[l_ac].sgi02 = g_sgi_t.sgi02
                        CALL cl_err('',-239,0) NEXT FIELD sgi02
                    END IF
                END IF
            END IF

        BEFORE FIELD sgi03                                 #TQC-C50194 add
           CALL i722_set_entry_b()                         #TQC-C50194 add
           CALL i722_set_no_required()                     #TQC-C50194 add

        AFTER FIELD sgi03
            IF cl_null(g_sgi[l_ac].sgi03) THEN
               NEXT FIELD sgi03
            ELSE
               CALL i722_set_no_entry_b()                   #TQC-C50194 add
               CALL i722_set_required()                     #TQC-C50194 add
               IF g_sgi[l_ac].sgi03 MATCHES '[1]' THEN
                  #CALL i722_set_entry('1')                 #TQC-C50194 mark
                  #CALL i722_set_no_entry('1')              #TQC-C50194 mark
                  LET g_sgi[l_ac].sgi012a= NULL             #FUN-A60092 add  
                  LET g_sgi[l_ac].sgi04a = NULL
                  LET g_sgi[l_ac].sgi05a = NULL
                  LET g_sgi[l_ac].sgi06a = NULL
                  LET g_sgi[l_ac].sgi07a = NULL            
                  LET g_sgi[l_ac].sgi08a = NULL
                  LET g_sgi[l_ac].sgi09a = NULL          
                  LET g_sgi[l_ac].sgi10a = NULL
                  LET g_sgi[l_ac].sgi11a = NULL
                  LET g_sgi[l_ac].sgi12a = NULL
                  LET g_sgi[l_ac].sgi13a = NULL             
                  LET g_sgi[l_ac].sgi14a = NULL           
                  LET g_sgi[l_ac].ecm45a = NULL
                  LET g_sgi[l_ac].eca02a = NULL
                  LET g_sgi[l_ac].sgi07b = 0                 #TQC-C50194 add 
                  LET g_sgi[l_ac].sgi09b = 0                 #TQC-C50194 add
                  LET g_sgi[l_ac].sgi13b = 'N'               #TQC-C50194 add 
                  LET g_sgi[l_ac].sgi14b = 'N'               #TQC-C50194 add
                  IF g_sma.sma541 = 'N' THEN LET g_sgi[l_ac].sgi012b = ' ' END IF #TQC-C50194 add 
                  IF NOT i722_check_sgi04b() THEN NEXT FIELD sgi04b END IF        #TQC-C50194 add
               ELSE
                  #TQC-C50194--mark--str--
                  #IF g_sgi[l_ac].sgi03 MATCHES '[3]' THEN
                  #   CALL i722_set_entry('3')
                  #   CALL i722_set_no_entry('3')
                  #ELSE
                  #   CALL i722_set_entry('2')
                  #   CALL i722_set_no_entry('2')
                  #END IF
                  #TQC-C50194--mark--end--
                  IF g_sma.sma541 = 'N' THEN LET g_sgi[l_ac].sgi012a = ' ' END IF #TQC-C50194 add 
                  IF NOT i722_check_sgi04a() THEN NEXT FIELD sgi04a END IF        #TQC-C50194 add 
               END IF
            END IF

#FUN-A60092 --begin--
        AFTER FIELD sgi012a
          IF NOT cl_null(g_sgi[l_ac].sgi012a) THEN 
            #FUN-B10056 ------------mark start---------------
            #SELECT COUNT(*) INTO l_cnt FROM sfa_file,sfb_file
            # WHERE sfa01 = g_sgh.sgh09
            #   AND sfb01 = sfa01
            #   AND sfb87 = 'Y'
            #   AND sfa012= g_sgi[l_ac].sgi012a
            #IF l_cnt = 0 THEN 
            #   CALL cl_err('','abm-214',0)
            #   NEXT FIELD CURRENT 
            #ELSE
            #FUN-B10056 ------------mark end------------------- 
               SELECT COUNT(*) INTO l_cnt FROM ecm_file
                 WHERE ecm01 = g_sgh.sgh09
                   AND ecm012= g_sgi[l_ac].sgi012a   
               IF l_cnt <= 0 THEN
                  CALL cl_err('','aec-097',0)
                  NEXT FIELD CURRENT 
               END IF              	     
            #END IF       #FUN-B10056 mark 
             IF NOT i722_check_sgi04a() THEN NEXT FIELD sgi04a END IF        #TQC-C50194 add
          END IF 
         
        AFTER FIELD sgi012b 
          IF NOT cl_null(g_sgi[l_ac].sgi012b) THEN 
             IF NOT cl_null(g_sgi[l_ac].sgi012a) THEN 
                IF g_sgi[l_ac].sgi012b = g_sgi[l_ac].sgi012a THEN 
                   CALL cl_err('','aec-315',0)
                   NEXT FIELD CURRENT 
                END IF 
             END IF 
             #TQC-C50194--add--str--
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM ecr_file 
               WHERE ecr01 = g_sgi[l_ac].sgi012b 
                 AND ecracti = 'Y'
             IF l_cnt <= 0 THEN
                CALL cl_err('','aec-050',0)
                NEXT FIELD CURRENT
             END IF
             IF NOT i722_check_sgi04b() THEN NEXT FIELD sgi04b END IF     
             #TQC-C50194--add--end--
            #FUN-B10056 ---------------mark start------------- 
            #SELECT COUNT(*) INTO l_cnt FROM sfa_file,sfb_file
            # WHERE sfa01 = g_sgh.sgh09
            #   AND sfb01 = sfa01
            #   AND sfb87 = 'Y'              
            #   AND sfa012= g_sgi[l_ac].sgi012b
            #IF l_cnt = 0 THEN 
            #   CALL cl_err('','abm-214',0)
            #   NEXT FIELD CURRENT 
            #END IF    
            #FUN-B10056 --------------mark end---------------
          ELSE
             NEXT FIELD CURRENT    
          END IF  
#FUN-A60092 --end--

        AFTER FIELD sgi04a
            IF g_sma.sma541 = 'Y' AND g_sgi[l_ac].sgi03 MATCHES '[23]' THEN  #TQC-C50194 add
               #FUN-A60092 --begin--        
               IF cl_null(g_sgi[l_ac].sgi012a) THEN 
                  NEXT FIELD sgi012a
               END IF 
               #FUN-A60092 --end--            
            END IF
            IF NOT i722_check_sgi04a() THEN NEXT FIELD sgi04a END IF        #TQC-C50194 add
            #TQC-C50194--mark--str--
            #IF NOT cl_null(g_sgi[l_ac].sgi04a) THEN
            #   IF g_sgi[l_ac].sgi03 MATCHES '[23]' THEN
            #      LET l_pmn43 = NULL
            #      LET l_shy06 = NULL
            #      SELECT MAX(pmn43) INTO l_pmn43 FROM pmn_file
            #       WHERE pmn41 = g_sgh.sgh09
            #         AND pmn012= g_sgi[l_ac].sgi012a    #FUN-A60092 add
            #      SELECT MAX(shy06) INTO l_shy06 
            #        FROM shy_file,shx_file
            #       WHERE shx01 = shy01 
            #         AND shx07<>'Y' 
            #         AND shy03 = g_sgh.sgh09     
            #      IF cl_null(l_pmn43) THEN LET l_pmn43 = 0 END IF
            #      IF cl_null(l_shy06) THEN LET l_shy06 = 0 END IF
            #      IF l_pmn43 > l_shy06 THEN
            #         LET l_sgi04a = l_pmn43
            #      ELSE
            #         LET l_sgi04a = l_shy06
            #      END IF
            #      IF l_sgi04a >= g_sgi[l_ac].sgi04a THEN
            #         CALL cl_err('','aec-094',1)
            #         NEXT FIELD sgi04a
            #      END IF
            #   END IF
            #   LET l_k = 0
            #   SELECT COUNT(*) INTO l_k FROM ecm_file
            #     WHERE ecm01 = g_sgh.sgh09
            #       AND ecm03 = g_sgi[l_ac].sgi04a
            #       AND ecm012= g_sgi[l_ac].sgi012a   #FUN-A60092 add
            #   IF l_k <= 0 THEN
            #      CALL cl_err('','aec-097',1)
            #      NEXT FIELD sgi04a
            #   END IF 
            #   LET l_k = 0
            #   SELECT COUNT(*) INTO l_k FROM sgd_file
            #     WHERE sgd00 = g_sgh.sgh09
            #       AND sgd01 = g_sgh.sgh02
            #       AND sgd02 = g_sgh.sgh03
            #       AND sgd03 = g_sgi[l_ac].sgi04a
            #       AND sgd012= g_sgi[l_ac].sgi012a   #FUN-A60092 add
            #   IF l_k > 0 THEN   
            #      #add by chenyu --08/07/10----begin  #增加一個判斷
            #      SELECT ecm301,ecm302,ecm303 INTO l_ecm301,l_ecm302,l_ecm303 FROM ecm_file
            #       WHERE ecm01 = g_sgh.sgh09
            #         AND ecm03 = g_sgi[l_ac].sgi04a
            #         AND ecm012= g_sgi[l_ac].sgi012a   #FUN-A60092 add                     
            #      IF cl_null(l_ecm301) THEN  LET l_ecm301 = 0  END IF
            #      IF cl_null(l_ecm302) THEN  LET l_ecm302 = 0  END IF
            #      IF cl_null(l_ecm303) THEN  LET l_ecm303 = 0  END IF
            #      IF l_ecm301 != 0 OR l_ecm302 != 0 OR l_ecm303 != 0 THEN
            #         CALL cl_err('','aec-098',1)
            #         NEXT FIELD sgi04a
            #      END IF
            #      #add by chenyu --08/07/10----end
            #   END IF
            #   LET g_sgi[l_ac].sgi04b = g_sgi[l_ac].sgi04a
            #   LET g_sgi[l_ac].sgi012b= g_sgi[l_ac].sgi012a    #FUN-A60092 add
            #   SELECT ecm04,ecm06,ecm14,ecm50,ecm13,
            #          ecm51,ecm16,ecm15,ecm52,ecm53
            #     INTO g_sgi[l_ac].sgi05a,g_sgi[l_ac].sgi06a,
            #          g_sgi[l_ac].sgi07a,g_sgi[l_ac].sgi08a,
            #          g_sgi[l_ac].sgi09a,g_sgi[l_ac].sgi10a,
            #          g_sgi[l_ac].sgi11a,g_sgi[l_ac].sgi12a,
            #          g_sgi[l_ac].sgi13a,g_sgi[l_ac].sgi14a
            #     FROM ecm_file
            #    WHERE ecm01 = g_sgh.sgh09
            #      AND ecm03 = g_sgi[l_ac].sgi04a 
            #      AND ecm012= g_sgi[l_ac].sgi012a   #FUN-A60092 add                  
            #   SELECT eca02 INTO g_sgi[l_ac].eca02a FROM eca_file
            #    WHERE eca01 = g_sgi[l_ac].sgi06a
            #   SELECT ecd02 INTO g_sgi[l_ac].ecm45a FROM ecd_file
            #     WHERE ecd01 = g_sgi[l_ac].sgi05a
            #END IF
            #TQC-C50194--mark--end--
                        
        AFTER FIELD sgi04b
            IF g_sma.sma541 = 'Y' AND g_sgi[l_ac].sgi03 MATCHES '[1]' THEN  #TQC-C50194 add
               #FUN-A60092 --begin--        
               IF cl_null(g_sgi[l_ac].sgi012b) THEN 
                  NEXT FIELD sgi012b
               END IF 
               #FUN-A60092 --end--         
            END IF
            IF NOT i722_check_sgi04b() THEN NEXT FIELD sgi04b END IF        #TQC-C50194 add
            #TQC-C50194--mark--str--
            #IF NOT cl_null(g_sgi[l_ac].sgi04b) THEN
            #   IF g_sgi[l_ac].sgi03 MATCHES '[1]' THEN
            #   	  IF cl_null(g_sgi[l_ac].sgi04b) THEN
            #   	  	NEXT FIELD sgi04b
            #   	  END IF
            #      LET l_pmn43 = NULL
            #      LET l_shy06 = NULL
            #      SELECT MAX(pmn43) INTO l_pmn43 FROM pmn_file
            #       WHERE pmn41 = g_sgh.sgh09
            #         AND pmn012= g_sgi[l_ac].sgi012b   #FUN-A60092 add
            #      SELECT MAX(shy06) INTO l_shy06 
            #        FROM shy_file,shx_file
            #       WHERE shx01 = shy01 
            #         AND shx07<>'Y' 
            #         AND shy03 = g_sgh.sgh09  
            #      IF cl_null(l_pmn43) THEN LET l_pmn43 = 0 END IF
            #      IF cl_null(l_shy06) THEN LET l_shy06 = 0 END IF
            #      IF l_pmn43 > l_shy06 THEN
            #         LET l_sgi04b = l_pmn43
            #      ELSE
            #         LET l_sgi04b = l_shy06
            #      END IF
            #      IF l_sgi04b >= g_sgi[l_ac].sgi04b THEN
            #         CALL cl_err('','aec-092',1)
            #         NEXT FIELD sgi04b
            #      END IF
            #      LET l_k = 0
            #      SELECT COUNT(*) INTO l_k FROM ecm_file
            #        WHERE ecm01 = g_sgh.sgh09
            #          AND ecm03 = g_sgi[l_ac].sgi04b
            #          AND ecm012= g_sgi[l_ac].sgi012b   #FUN-A60092 add
            #      IF l_k > 0  THEN
            #         CALL cl_err('','aec-093',1)
            #         NEXT FIELD sgi04b
            #      END IF
            #   END IF 
            #ELSE
            #   NEXT FIELD sgi04b
            #END IF
            #TQC-C50194--mark--end--
 
     #TQC-C50194--mark--str--  #無需給預設值,會清空已有數據
     #   BEFORE FIELD sgi13b
     # #     LET g_sgi[l_ac].sgi13b = 'N'  #mark by chenyu --08/07/09
     #       LET g_sgi[l_ac].sgi13b = ''   #add by chenyu --08/07/09
     #   BEFORE FIELD sgi14b
     # #     LET g_sgi[l_ac].sgi14b = 'N'  #mark by chenyu --08/07/09
     #       LET g_sgi[l_ac].sgi14b = ''   #add by chenyu --08/07/09
     #TQC-C50194--mark--end--

        AFTER FIELD sgi10b
           #TQC-C50194--mark--str--
           #IF g_sgi[l_ac].sgi03 MATCHES '[1]' THEN
           #   IF cl_null(g_sgi[l_ac].sgi10b) THEN
           #      NEXT FIELD sgi10b
           #   END IF
           #END IF
           #IF NOT cl_null(g_sgi[l_ac].sgi10b) AND NOT cl_null(g_sgi[l_ac].sgi08b) THEN #TQC-C50194 add
           #   IF g_sgi[l_ac].sgi10b < g_sgi[l_ac].sgi08b THEN 
           #      CALL cl_err('','aec-993',0)
           #      NEXT FIELD sgi10b
           #   END IF      
           #END IF
           #TQC-C50194--mark--end--
           #TQC-C50194--add--str--
           IF NOT cl_null(g_sgi[l_ac].sgi10b) THEN 
              IF NOT cl_null(g_sgi[l_ac].sgi08b) THEN
                 IF g_sgi[l_ac].sgi10b < g_sgi[l_ac].sgi08b THEN
                    CALL cl_err('','aec-993',0)
                    NEXT FIELD sgi10b
                 END IF
              ELSE
                 IF NOT cl_null(g_sgi[l_ac].sgi08a) AND g_sgi[l_ac].sgi10b < g_sgi[l_ac].sgi08a THEN
                    CALL cl_err('','aec-993',0)
                 END IF
              END IF
           END IF
           #TQC-C50194--add--end--

        AFTER FIELD sgi08b
           #TQC-C50194--mark--str--
           # IF g_sgi[l_ac].sgi03 MATCHES '[1]' THEN
           #    IF cl_null(g_sgi[l_ac].sgi08b) THEN
           #       NEXT FIELD sgi08b
           #    END IF
           # END IF
           #TQC-C50194--mark--end--
           #TQC-C50194--add--str--
           IF NOT cl_null(g_sgi[l_ac].sgi08b) THEN 
              IF NOT cl_null(g_sgi[l_ac].sgi10b) THEN
                 IF g_sgi[l_ac].sgi10b < g_sgi[l_ac].sgi08b THEN
                    CALL cl_err('','aec-993',0)
                    NEXT FIELD sgi08b
                 END IF
              ELSE
                 IF NOT cl_null(g_sgi[l_ac].sgi10a) AND g_sgi[l_ac].sgi10a < g_sgi[l_ac].sgi08b THEN
                    CALL cl_err('','aec-993',0)
                 END IF
              END IF
           END IF
           #TQC-C50194--add--end--
 
        AFTER FIELD sgi13b
           #TQC-C50194--mark--str--
           # IF g_sgi[l_ac].sgi03 MATCHES '[1]' THEN
           #    IF cl_null(g_sgi[l_ac].sgi13b) THEN
           #       CALL cl_err('','agl-154',0)
           #       NEXT FIELD sgi13b
           #    END IF
           # END IF
           #TQC-C50194--mark--end--
 
        AFTER FIELD sgi14b
           #TQC-C50194--mark--str--
           # IF g_sgi[l_ac].sgi03 MATCHES '[1]' THEN
           #    IF cl_null(g_sgi[l_ac].sgi14b) THEN
           #       CALL cl_err('','agl-154',0)
           #       NEXT FIELD sgi14b
           #    END IF
           # END IF
           #TQC-C50194--mark--end--
        
        AFTER FIELD sgi05b
            IF NOT cl_null(g_sgi[l_ac].sgi05b) THEN
               LET l_n = 0
               SELECT count(*) INTO l_n FROM ecd_file
                 WHERE ecd01 = g_sgi[l_ac].sgi05b
                   AND ecdacti = 'Y'
               IF l_n <= 0 THEN
                  CALL cl_err(' ','aec-099',0)
                  NEXT FIELD sgi05b
               ELSE
                  SELECT ecd02,ecd07 
                    INTO g_sgi[l_ac].ecm45b,g_sgi[l_ac].sgi06b
                    FROM ecd_file
                   WHERE ecd01 = g_sgi[l_ac].sgi05b
               END IF
            #TQC-C50194--mark--str--  #刪除時,此欄位為noentry by free
            #ELSE
            #   IF g_sgi[l_ac].sgi03 != '2' THEN    #add by chenyu  --08/07/09
            #      NEXT FIELD sgi05b
            #   END IF
            #TQC-C50194--mark--end--
            END IF
       
        AFTER FIELD sgi06b
            IF NOT cl_null(g_sgi[l_ac].sgi06b) THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM eca_file
                 WHERE eca01 = g_sgi[l_ac].sgi06b
                   AND ecaacti = 'Y'
               IF l_n <= 0 THEN
                  CALL cl_err(' ','aec-100',0)
                  NEXT FIELD sgi06b
               ELSE
                  SELECT eca02 INTO g_sgi[l_ac].eca02b FROM eca_file
                    WHERE eca01 = g_sgi[l_ac].sgi06b
               END IF
            #TQC-C50194--mark--str--
            #ELSE
            #   IF g_sgi[l_ac].sgi03 != '2' THEN    #add by chenyu  --08/07/09
            #      NEXT FIELD sgi06b
            #   END IF
            #TQC-C50194--mark--end--
            END IF
 
        AFTER FIELD sgi07b
          IF NOT cl_null(g_sgi[l_ac].sgi07b) THEN
             IF g_sgi[l_ac].sgi07b < 0 THEN
                CALL cl_err('','aec-020',0)
                NEXT FIELD sgi07b
             END IF
          #TQC-C50194--mark--str--
          #ELSE
          #   IF g_sgi[l_ac].sgi03 != '2' THEN    #add by chenyu  --08/07/09
          #      NEXT FIELD sgi07b
          #   END IF
          #TQC-C50194--mark--end--
          END IF
 
        AFTER FIELD sgi09b
          IF NOT cl_null(g_sgi[l_ac].sgi09b) THEN
             IF g_sgi[l_ac].sgi09b < 0 THEN
                CALL cl_err('','aec-020',0)
                NEXT FIELD sgi09b
             END IF
          #TQC-C50194--mark--str--
          #ELSE 
          #   IF g_sgi[l_ac].sgi03 != '2' THEN    #add by chenyu  --08/07/09
          #      NEXT FIELD sgi09b
          #   END IF
          #TQC-C50194--mark--end--
          END IF
        
        AFTER FIELD sgi11b
          IF NOT cl_null(g_sgi[l_ac].sgi11b) THEN
             IF g_sgi[l_ac].sgi11b < 0 THEN
                CALL cl_err('','aec-020',0)
                NEXT FIELD sgi11b
             END IF
          #TQC-C50194--mark--str--
          #ELSE
          #   IF g_sgi[l_ac].sgi03 != '2' THEN    #add by chenyu  --08/07/09
          #      NEXT FIELD sgi11b
          #   END IF
          #TQC-C50194--mark--end--
          END IF
 
        AFTER FIELD sgi12b
          IF NOT cl_null(g_sgi[l_ac].sgi12b) THEN
             IF g_sgi[l_ac].sgi12b < 0 THEN
                CALL cl_err('','aec-020',0)
                NEXT FIELD sgi12b
             END IF
          #TQC-C50194--mark--str--
          #ELSE
          #   IF g_sgi[l_ac].sgi03 != '2' THEN    #add by chenyu  --08/07/09
          #      NEXT FIELD sgi12b
          #   END IF
          #TQC-C50194--mark--end--
          END IF
           
 
        BEFORE DELETE
            IF g_sgi_t.sgi02 > 0 
               AND g_sgi_t.sgi02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM sgi_file
                    WHERE sgi01 = g_sgh.sgh01 
                      AND sgi02 = g_sgi_t.sgi02
                IF SQLCA.sqlcode THEN
                    CALL cl_err('del sgi',SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
		COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_sgi[l_ac].* = g_sgi_t.*
               CLOSE i722_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CALL i722_b_move_back() 
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_sgi[l_ac].sgi02,-263,1)
                LET g_sgi[l_ac].* = g_sgi_t.*
            ELSE
                UPDATE sgi_file SET * = b_sgi.*
                 WHERE sgi01=g_sgh.sgh01 
                   AND sgi02=g_sgi_t.sgi02
                IF SQLCA.sqlcode THEN
                   CALL cl_err('upd sgi',SQLCA.sqlcode,0)
                   LET g_sgi[l_ac].* = g_sgi_t.*
                   DISPLAY g_sgi[l_ac].* TO s_sgi[l_sl].*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_sgi[l_ac].* = g_sgi_t.*   
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sgi.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i722_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
 
            CLOSE i722_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO
            IF INFIELD(sgi2) AND l_ac > 1 THEN
                LET g_sgi[l_ac].* = g_sgi[l_ac-1].*
                LET g_sgi[l_ac].sgi02 = NULL
                DISPLAY g_sgi[l_ac].* TO s_sgi[l_sl].*
                NEXT FIELD sgi02
            END IF
 
 
        ON ACTION CONTROLP
           CASE 

#FUN-A60092 --begin--
             WHEN INFIELD(sgi012a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sgi012a_1"   
                  LET g_qryparam.arg1 = g_sgh.sgh09
                  CALL cl_create_qry() RETURNING g_sgi[l_ac].sgi012a
                  DISPLAY BY NAME g_sgi[l_ac].sgi012a
                  NEXT FIELD sgi012a
                  
             WHEN INFIELD(sgi012b)
                  CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_sgi012a_1"    #TQC-C50194 mark
                  LET g_qryparam.form = "q_ecr"           #TQC-C50194 add 
                  #LET g_qryparam.arg1 = g_sgh.sgh09      #TQC-C50194 mark
                  CALL cl_create_qry() RETURNING g_sgi[l_ac].sgi012b
                  DISPLAY BY NAME g_sgi[l_ac].sgi012b
                  NEXT FIELD sgi012b             
#FUN-A60092 --end--     

             WHEN INFIELD(sgi05b)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ecd3"
                  CALL cl_create_qry() RETURNING g_sgi[l_ac].sgi05b
                  NEXT FIELD sgi05b
             WHEN INFIELD(sgi06b)
#No.FUN-jan--BEGIN--
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_eca"
#                  LET g_qryparam.state = "c"
#                  CALL cl_create_qry() RETURNING g_sgi[l_ac].sgi06b 
#                  NEXT FIELD sgi06b
                 CALL q_eca(FALSE,TRUE,g_sgi[l_ac].sgi06b) RETURNING g_sgi[l_ac].sgi06b                                               
                 DISPLAY BY NAME g_sgi[l_ac].sgi06b                                                                                  
                 NEXT FIELD sgi06b                                                                                                   
              OTHERWISE EXIT CASE
#No.FUN-jan--END--
           END CASE
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG 
           CALL cl_cmdask()
 
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
   
    CLOSE i722_bcl
    COMMIT WORK
#   CALL i722_delall()   #CHI-C30002 mark
    CALL i722_delHeader()     #CHI-C30002 add
 
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i722_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_sgh.sgh01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM sgh_file ",
                  "  WHERE sgh01 LIKE '",l_slip,"%' ",
                  "    AND sgh01 > '",g_sgh.sgh01,"'"
      PREPARE i722_pb1 FROM l_sql 
      EXECUTE i722_pb1 INTO l_cnt      
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
        #CALL i722_v()    #CHI-D20010
         CALL i722_v(1)   #CHI-D20010
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM sgh_file
          WHERE sgh01 = g_sgh.sgh01
         INITIALIZE  g_sgh.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i722_delall() #未輸入單身是否取消單頭資料
#   SELECT COUNT(*) INTO g_cnt FROM sgi_file
#    WHERE sgi01 = g_sgh.sgh01 
#                
#   IF g_cnt = 0 THEN
#      DISPLAY 'Del All Record'
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM sgh_file
#       WHERE sgh01 = g_sgh.sgh01 
#       CLEAR FORM      #FUN-A60092 add 
#   END IF
#END FUNCTION 
#CHI-C30002 -------- mark -------- end
 
FUNCTION i722_b_askkey()
DEFINE l_wc2    LIKE type_file.chr1000
 
    CONSTRUCT l_wc2 ON sgi2,sgi3,sgi4,sgi5,sgi6,sgi7,sgi8
         FROM s_sgi[1].sgi2,s_sgi[1].sgi3,s_sgi[1].sgi4,
              s_sgi[1].sgi5,s_sgi[1].sgi6,s_sgi[1].sgi7,
              s_sgi[1].sgi8            
 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i722_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i722_b_fill(p_wc3) 
DEFINE p_wc3    LIKE type_file.chr1000
 
    LET g_sql =
        " SELECT sgi02,sgi03,sgi012a,sgi012b,sgi04a,sgi04b,sgi05a,",  #FUN-A60092 add sgi012a,sgi012b
        "        '',sgi05b,'',sgi06a,'',sgi06b,'',",
        "        sgi07a,sgi07b,sgi09a,sgi09b,",
        "        sgi11a,sgi11b,sgi12a,sgi12b,sgi08a,",
        "        sgi08b,sgi10a,sgi10b,sgi13a,",
        "        sgi13b,sgi14a,sgi14b",
        " FROM sgi_file ",
        " WHERE sgi01 ='",g_sgh.sgh01,"'",
        "  AND ",p_wc3 CLIPPED, 
        " ORDER BY sgi02"
 
 
    PREPARE i722_pb FROM g_sql
    DECLARE sgi_curs CURSOR FOR i722_pb
 
    CALL g_sgi.clear()
    LET g_cnt = 1
    FOREACH sgi_curs INTO g_sgi[g_cnt].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT ecd02 INTO g_sgi[g_cnt].ecm45a FROM ecd_file
         WHERE ecd01 = g_sgi[g_cnt].sgi05a 
        SELECT ecd02 INTO g_sgi[g_cnt].ecm45b FROM ecd_file
         WHERE ecd01 = g_sgi[g_cnt].sgi05b
	      SELECT eca02 INTO g_sgi[g_cnt].eca02a FROM eca_file
	       WHERE eca01 = g_sgi[g_cnt].sgi06a
	      SELECT eca02 INTO g_sgi[g_cnt].eca02b FROM eca_file
	       WHERE eca01 = g_sgi[g_cnt].sgi06b
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	         EXIT FOREACH
        END IF
    END FOREACH 
    CALL g_sgi.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
 
FUNCTION i722_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sgi TO s_sgi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION un_confirm
         LET g_action_choice="un_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      #CHI-D20010---begin
        ON ACTION undo_void
           LET g_action_choice="undo_void"
           EXIT DISPLAY
      #CHI-D20010---end
      ON ACTION p 
         LET g_action_choice="p"
         EXIT DISPLAY
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
         CALL i722_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
           ACCEPT DISPLAY 
                              
      ON ACTION previous
         CALL i722_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	    ACCEPT DISPLAY 
                              
      ON ACTION jump
         CALL i722_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	    ACCEPT DISPLAY 
                              
      ON ACTION next
         CALL i722_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	    ACCEPT DISPLAY   
                              
      ON ACTION last
         CALL i722_fetch('L')
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
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont() 
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
{
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
}
      ON ACTION change_release
         LET g_action_choice="change_release"
         EXIT DISPLAY
 
      ON ACTION batch_change_release  
         LET g_action_choice="batch_change_release"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
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
    
                           
FUNCTION i722_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
     CALL cl_set_comp_entry("sgh01",TRUE)  
  END IF           
  #TQC-C50194--mark--str--
  #IF p_cmd = '1' THEN
  #   CALL cl_set_comp_entry("sgi012b,sgi04b,sgi05b,sgi06b,sgi07b,   #FUN-A60092 add sgi012b
  #                           sgi08b,sgi09b,sgi10b,sgi11b,
  #                           sgi12b,sgi13b,sgi14b",TRUE)
  #END IF
  #IF p_cmd = '3' THEN
  #   CALL cl_set_comp_entry("sgi012a,sgi04a",TRUE)    #FUN-A60092 add sgi012a
  #END IF
  #IF p_cmd = '2' THEN
  #   CALL cl_set_comp_entry("sgi012a,sgi04a,sgi05b,sgi06b,     #FUN-A60092 add sgi012a
  #                           sgi07b,sgi08b,sgi09b,sgi10b,
  #                           sgi11b,sgi12b,sgi13b,sgi14b",
  #                           TRUE)
  #END IF                                                                                                             
  #TQC-C50194--mark--end--
END FUNCTION                           
                                                                                             
FUNCTION i722_set_no_entry(p_cmd)                                        
  DEFINE p_cmd   LIKE type_file.chr1                                                     
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN            
     CALL cl_set_comp_entry("sgh01",FALSE)                                    
   END IF
   #TQC-C50194--mark--str--
   #IF p_cmd = '1' THEN
   #  CALL cl_set_comp_entry("sgi012a,sgi04a,sgi05a,sgi06a,sgi07a,    #FUN-A60092 add sgi012a
   #                          sgi08a,sgi09a,sgi10a,sgi11a,
   #                          sgi12a,sgi13a,sgi14a",FALSE)
   #END IF
   #IF p_cmd = '3' THEN
   #  CALL cl_set_comp_entry("sgi05a,sgi06a,sgi07a,
   #                          sgi08a,sgi09a,sgi10a,sgi11a,
   #                          sgi12a,sgi13a,sgi14a,
   #                          sgi012b,                    #FUN-A60092 add sgi012b
   #                          sgi04b,sgi05b,sgi06b,sgi07b,
   #                          sgi08b,sgi09b,sgi10b,sgi11b,
   #                          sgi12b,sgi13b,sgi14b",FALSE)
   #END IF
   #IF p_cmd = '2' THEN
   #  CALL cl_set_comp_entry("sgi012b,sgi04b,sgi05a,sgi06a,sgi07a,   #FUN-A60092 sgi012b
   #                          sgi08a,sgi09a,sgi10a,sgi11a,
   #                          sgi12a,sgi13a,sgi14a,",FALSE)
   #END IF                                                                       
   #TQC-C50194--mark--end--
END FUNCTION         
 
FUNCTION i722_r()
    DEFINE l_chr   LIKE type_file.chr1,
           l_cnt   LIKE type_file.num5
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_sgh.sgh01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_sgh.sghconf = 'Y' THEN
    	 CALL cl_err('','aap-019',1)
    	 RETURN
    END IF
    IF g_sgh.sghconf = 'X' THEN RETURN END IF  #CHI-C80041
    IF NOT cl_null(g_sgh.sgh05) THEN
       CALL cl_err('','aap-086',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i722_cl USING g_sgh.sgh01    #mod by liuxqa 091019
    IF STATUS THEN
       CALL cl_err("OPEN i722_cl:", STATUS, 1)
       CLOSE i722_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i722_cl INTO g_sgh.*
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock ecu:',SQLCA.sqlcode,0)
       CLOSE i722_cl ROLLBACK WORK RETURN
    END IF
 
    CALL i722_show()
 
    IF cl_delh(15,21) THEN
       DELETE FROM sgh_file WHERE sgh01=g_sgh.sgh01  #mod by liuxqa 091019 
        IF STATUS THEN
           CALL cl_err('del sgh:',STATUS,0)
           RETURN
        END IF
 
        DELETE FROM sgi_file 
          WHERE sgi01 = g_sgh.sgh01 
        IF STATUS THEN 
           CALL cl_err('del sgi:',STATUS,0)
           RETURN
        END IF
        
       INITIALIZE g_sgh.* TO NULL
        CLEAR FORM
        CALL g_sgi.clear()
        OPEN i722_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE i722_cs
           CLOSE i722_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        FETCH i722_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i722_cs
           CLOSE i722_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i722_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i722_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET g_no_ask = TRUE
           CALL i722_fetch('/')
        END IF
 
    END IF
    CLOSE i722_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i722_g(l_sign)    #變更發出
  DEFINE l_cmd    LIKE type_file.chr1000
  DEFINE l_sgi03  LIKE sgi_file.sgi03
  DEFINE l_sgi04a LIKE sgi_file.sgi04a
  DEFINE l_sign   LIKE type_file.chr1
 
 LET g_success = 'Y'
 IF l_sign = 'Y' THEN
   IF s_shut(0) THEN LET g_success = 'N' RETURN g_success END IF
   IF g_sgh.sgh01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_sgh.sghconf != 'Y' THEN
      CALL cl_err('','aec-101',0) LET g_success = 'N' RETURN g_success
   END IF
 END IF

 IF NOT cl_null(g_sgh.sgh05) THEN 
    CALL cl_err('','aec-102',0) LET g_success = 'N' RETURN g_success
 END IF
 
 IF l_sign = 'Y' THEN  
   IF NOT cl_confirm('aec-103') THEN LET g_success = 'N' RETURN g_success END IF
   BEGIN WORK
   LET g_success = 'Y'
   CALL i722_g1()
   IF g_success = 'Y' THEN
      COMMIT WORK
      UPDATE sgh_file SET sgh05 = g_today
         WHERE sgh01 = g_sgh.sgh01
      SELECT * INTO g_sgh.* FROM sgh_file
        WHERE sgh01=g_sgh.sgh01
      CALL i722_show()
   ELSE
      ROLLBACK WORK
   END IF
 ELSE
 	 CALL i722_g1()
 	 UPDATE sgh_file SET sgh05 = g_today
         WHERE sgh01 = g_sgh.sgh01
 END IF
 RETURN g_success
END FUNCTION
 
FUNCTION i722_g1()
  DEFINE
       l_sql     LIKE type_file.chr1000,
       l_t       LIKE type_file.num5,
       l_ecm012  LIKE ecm_file.ecm012,   #TQC-C50223 add
       l_sfb08   LIKE sfb_file.sfb08     #TQC-C50223 add
 
    DECLARE i722_cur2 CURSOR FOR 
    SELECT * FROM sgi_file WHERE sgi01 = g_sgh.sgh01
    FOREACH i722_cur2 INTO l_sgi.*
      IF SQLCA.SQLCODE THEN
         LET g_success = 'N'
         CALL cl_err('Foreach i722_cur2 :',SQLCA.SQLCODE,2)
         EXIT FOREACH
      END IF
      CASE
         WHEN l_sgi.sgi03 = '1' CALL i722_s1()    #新增 
         WHEN l_sgi.sgi03 = '2' CALL i722_s2()    #修改
         WHEN l_sgi.sgi03 = '3' CALL i722_s3()    #刪除
      END CASE
      IF g_success = 'N' THEN
         EXIT FOREACH
      END IF
    END FOREACH
    #TQC-C50194--add--str--
     IF g_success = 'Y' THEN
        IF g_sma.sma541 = 'Y' THEN
           CALL i700sub_chkbom(g_sgh.sgh09,'1')
           IF g_success = 'Y' THEN
              CALL i700sub_ecm011(g_sgh.sgh09)
           END IF
        END IF
     END IF
    IF g_success='Y' THEN
       LET l_ecm012= ' '
       LET l_sfb08 = ''
       SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = g_sgh.sgh09
       DECLARE ecm012_cs CURSOR FOR
        SELECT DISTINCT ecm012 FROM ecm_file WHERE ecm01 = g_sgh.sgh09 AND (ecm015 IS NULL OR ecm015=' ')
       FOREACH ecm012_cs INTO l_ecm012 EXIT FOREACH END FOREACH
       CALL s_schdat_output(l_ecm012,l_sfb08,g_sgh.sgh09)
    END IF
    #TQC-C50194--add--end--
END FUNCTION
 
FUNCTION i722_s1()
    DEFINE l_ecm           RECORD LIKE ecm_file.*,
           l_sgc           RECORD LIKE sgc_file.*,
           l_sgd           RECORD LIKE sgd_file.*,
           l_pmn43         LIKE pmn_file.pmn43,
           l_shy06         LIKE shy_file.shy06,
           l_ima55         LIKE ima_file.ima55,
           l_sgi04b        LIKE sgi_file.sgi04b,
           l_max_ecm03     LIKE ecm_file.ecm03,
           l_min_sgi04b    LIKE sgi_file.sgi04b,
           l_ecm301        LIKE ecm_file.ecm301,
           l_ecm311        LIKE ecm_file.ecm311,
           l_ecm312        LIKE ecm_file.ecm312,
           l_ecm313        LIKE ecm_file.ecm313,
           l_ecm314        LIKE ecm_file.ecm314,
           l_ecm315        LIKE ecm_file.ecm315,
           l_ecm316        LIKE ecm_file.ecm316,
           l_ecm322        LIKE ecm_file.ecm322,
           l_ecm52         LIKE ecm_file.ecm52,
           l_ima571        LIKE ima_file.ima571
 
    SELECT MAX(pmn43) INTO l_pmn43 FROM pmn_file
      WHERE pmn41 = g_sgh.sgh09
        AND pmn012= l_sgi.sgi012b        #FUN-A60092 
        
    IF cl_null(l_pmn43) THEN LET l_pmn43 = 0 END IF
    IF cl_null(l_shy06) THEN LET l_shy06 = 0 END IF
    IF l_pmn43 > l_shy06 THEN
       LET l_sgi04b = l_pmn43
    ELSE
       LET l_sgi04b = l_shy06
    END IF
    IF l_sgi04b >= l_sgi.sgi04b THEN
       CALL cl_err('','aec-094',1)
       LET g_success = 'N'
       RETURN
    END IF
    
    LET l_max_ecm03 = 0
    SELECT max(ecm03) INTO l_max_ecm03    #抓最大制程號
      FROM ecm_file
     WHERE ecm01 = g_sgh.sgh09
       AND ecm012= l_sgi.sgi012b                #FUN-A60092 
       
    LET l_min_sgi04b = 0
    SELECT min(sgi04b) INTO l_min_sgi04b
      FROM sgi_file
     WHERE sgi01 = g_sgh.sgh01
       AND sgi03 = '1'
       AND sgi012b = l_sgi.sgi012b            #FUN-A60092
           
    IF l_sgi.sgi04b > l_max_ecm03 
       AND l_sgi.sgi04b = l_min_sgi04b THEN   #判斷是否新增最后一站制程序
    	 LET l_ecm52 = ''
    	 LET l_ecm301 = 0
       LET l_ecm311 = 0
       LET l_ecm312 = 0
       LET l_ecm313 = 0
       LET l_ecm314 = 0
       LET l_ecm315 = 0
       LET l_ecm316 = 0
       LET l_ecm322 = 0
      #抓出前一站的轉出量等
       SELECT ecm52,ecm311,ecm312,ecm313,ecm314,ecm315,ecm316,ecm322
         INTO l_ecm52,l_ecm311,l_ecm312,l_ecm313,l_ecm314,l_ecm315,l_ecm316,l_ecm322
         FROM ecm_file
        WHERE ecm01 = g_sgh.sgh09 
          AND ecm03 = l_max_ecm03
          AND ecm012= l_sgi.sgi012b   #FUN-A60092 
       IF l_ecm52 = 'Y' THEN
       	  LET l_ecm301 = l_ecm322 + l_ecm315 + l_ecm316
       ELSE
       	  LET l_ecm301 = l_ecm311 + l_ecm312 + l_ecm315 + l_ecm316
       END IF
    END IF
    IF cl_null(l_ecm301) THEN LET l_ecm301 = 0 END IF
    
    LET l_ecm.ecm01 = g_sgh.sgh09 
    SELECT sfb02 INTO l_ecm.ecm02 FROM sfb_file
     WHERE sfb01 = g_sgh.sgh09
    LET l_ecm.ecm03 = l_sgi.sgi04b
    LET l_ecm.ecm03_par = g_sgh.sgh02
    LET l_ecm.ecm04 = l_sgi.sgi05b
    LET l_ecm.ecm05 = 0
    LET l_ecm.ecm06 = l_sgi.sgi06b
    LET l_ecm.ecm07 = 0
    LET l_ecm.ecm08 = 0
    LET l_ecm.ecm09 = 0
    LET l_ecm.ecm10 = 0
    LET l_ecm.ecm11 = g_sgh.sgh03
    LET l_ecm.ecm13 = l_sgi.sgi09b
    LET l_ecm.ecm14 = l_sgi.sgi07b
    LET l_ecm.ecm15 = l_sgi.sgi12b
    LET l_ecm.ecm16 = l_sgi.sgi11b
    SELECT ecd02 INTO l_ecm.ecm45 FROM ecd_file
      WHERE ecd01= l_sgi.sgi05b
    LET l_ecm.ecm49 = 0
    LET l_ecm.ecm50 = l_sgi.sgi08b
    LET l_ecm.ecm51 = l_sgi.sgi10b
    LET l_ecm.ecm52 = l_sgi.sgi13b
    LET l_ecm.ecm53 = l_sgi.sgi14b
    LET l_ecm.ecm54 = 'N'
    LET l_ecm.ecm55 = NULL
    LET l_ecm.ecm56 = NULL
    LET l_ecm.ecm291 = 0
    LET l_ecm.ecm292 = 0
    LET l_ecm.ecm301 = l_ecm301
    LET l_ecm.ecm302 = 0
    LET l_ecm.ecm303 = 0
    LET l_ecm.ecm311 = 0
    LET l_ecm.ecm312 = 0
    LET l_ecm.ecm313 = 0
    LET l_ecm.ecm314 = 0
    LET l_ecm.ecm315 = 0       
    LET l_ecm.ecm316 = 0          
    LET l_ecm.ecm321 = 0
    LET l_ecm.ecm322 = 0
    LET l_ecm.ecmacti = 'Y'
    LET l_ecm.ecmuser = g_user
    LET l_ecm.ecmgrup = g_grup
    LET l_ecm.ecmmodu = ''
    LET l_ecm.ecmdate = g_today
    LET l_ecm.ecmslk02 = 0
    LET l_ecm.ecmslk04 = 0
    SELECT ima55 INTO l_ima55 FROM ima_file
      WHERE ima01 = g_sgh.sgh02 
    LET l_ecm.ecm57 = l_ima55
    LET l_ecm.ecm58 = l_ima55
    LET l_ecm.ecm59 = 1
    LET l_ecm.ecm66 = 'Y'   #FUN-B10056 
    
    LET l_ecm.ecmplant = g_plant #FUN-980002
    LET l_ecm.ecmlegal = g_legal #FUN-980002
 
    LET l_ecm.ecmoriu = g_user      #No.FUN-980030 10/01/04
    LET l_ecm.ecmorig = g_grup      #No.FUN-980030 10/01/04
    
    LET l_ecm.ecm012  = l_sgi.sgi012b   #FUN-A60092 
#FUN-A60092 --begin--
    IF cl_null(l_ecm.ecm61) THEN 
       LET l_ecm.ecm61 = 'N'
    END IF 
    IF cl_null(l_ecm.ecm52) THEN 
       LET l_ecm.ecm52 = 'N'
    END IF 
    IF cl_null(l_ecm.ecm53) THEN 
       LET l_ecm.ecm53 = 'N'
    END IF         
    IF cl_null(l_ecm.ecm012) THEN 
      LET l_ecm.ecm012 = ' '
    END IF 
#FUN-A60092 --end--    
    #TQC-C50194--add--str--
    IF cl_null(l_ecm.ecm12) THEN
      LET l_ecm.ecm12 = 0 
    END IF
    IF cl_null(l_ecm.ecm34) THEN
      LET l_ecm.ecm34 = 0
    END IF
    IF cl_null(l_ecm.ecm62) THEN
      LET l_ecm.ecm62 = 1
    END IF
    IF cl_null(l_ecm.ecm63) THEN
      LET l_ecm.ecm63 = 1
    END IF
    IF cl_null(l_ecm.ecm64) THEN
      LET l_ecm.ecm64 = 1
    END IF
    IF g_sma.sma541 = 'Y' THEN
       CALL i722_ecm014(l_ecm.ecm01,l_ecm.ecm012) RETURNING l_ecm.ecm014
       CALL i722_ecm015(l_ecm.ecm01,l_ecm.ecm012) RETURNING l_ecm.ecm015
    END IF
    #TQC-C50194--add--end--
    IF cl_null(l_ecm.ecm66) THEN LET l_ecm.ecm66 = 'Y' END IF #TQC-B80022      
    INSERT INTO ecm_file VALUES(l_ecm.*)
    IF STATUS = -239 THEN
       CALL cl_err(l_ecm.ecm01,'aec-104',1)
       LET g_success = 'N'
       RETURN
    END IF
     
#add by chenyu --08/07/10----------------------------------begin
        #------>insert sgd_file
        #------>工單制程單元資料
        SELECT ima571 INTO l_ima571 FROM ima_file
         WHERE ima01 = g_sgh.sgh02
        DECLARE sgc_cur CURSOR FOR 
           SELECT * FROM sgc_file 
            WHERE  sgc01 = l_ima571
              AND  sgc02 = g_sgh.sgh03
              AND  sgc03 = l_sgi.sgi04b
              AND  sgc04 = l_sgi.sgi06b
              AND  sgc012= l_sgi.sgi012b   #FUN-A60092 add
        FOREACH sgc_cur INTO l_sgc.*
           IF SQLCA.sqlcode THEN EXIT FOREACH END IF
           INITIALIZE l_sgd.* TO NULL  
           LET l_sgd.sgd00 = g_sgh.sgh09
           IF s_industry('slk') THEN
              LET l_sgd.sgd01 = g_sgh.sgh02
           ELSE
              LET l_sgd.sgd01 = l_sgc.sgc01
           END IF
           LET l_sgd.sgd02 = l_sgc.sgc02
           LET l_sgd.sgd03 = l_sgc.sgc03
           LET l_sgd.sgd04 = l_sgc.sgc04
           LET l_sgd.sgd05 = l_sgc.sgc05
           LET l_sgd.sgd06 = l_sgc.sgc06
           LET l_sgd.sgd07 = l_sgc.sgc07
           LET l_sgd.sgd08 = l_sgc.sgc08
           LET l_sgd.sgd09 = l_sgc.sgc09
           LET l_sgd.sgd10 = l_sgc.sgc10                                                                        
           LET l_sgd.sgd11 = l_sgc.sgc11
 
      IF s_industry('slk') THEN
           LET l_sgd.sgd13 = l_sgc.sgc13
           LET l_sgd.sgd14 = l_sgc.sgc14
           LET l_sgd.sgdslk02 = l_sgc.sgcslk02
           LET l_sgd.sgdslk03 = l_sgc.sgcslk03
           LET l_sgd.sgdslk04 = l_sgc.sgcslk04
           LET l_sgd.sgdslk05 = l_sgc.sgcslk05
      END IF
 
           IF cl_null(l_sgd.sgd13) THEN
              LET l_sgd.sgd13='N'               
           END IF
           LET l_sgd.sgdplant = g_plant #FUN-980002
           LET l_sgd.sgdlegal = g_legal #FUN-980002
           
           LET l_sgd.sgd012   = l_sgc.sgc012    #FUN-A60092 add
            #No.FUN-A70131--begin
            IF cl_null(l_sgd.sgd012) THEN 
               LET l_sgd.sgd012=' '
            END IF 
            IF cl_null(l_sgd.sgd03) THEN 
               LET l_sgd.sgd03=0
            END IF 
            #No.FUN-A70131--end           
           INSERT INTO sgd_file VALUES(l_sgd.*)
           IF STATUS THEN 
              CALL cl_err('ins_sgd',STATUS,1)
              LET g_success= 'N'
           END IF 
        END FOREACH
#add by chenyu --08/07/10----------------------------------end
END FUNCTION

FUNCTION i722_s2()
    DEFINE l_ecm           RECORD LIKE ecm_file.*,
           l_pmn43         LIKE pmn_file.pmn43,
           l_shy06      LIKE shy_file.shy06,
           l_sgi04b        LIKE sgi_file.sgi04b
 
    SELECT MAX(pmn43) INTO l_pmn43 FROM pmn_file
     WHERE pmn41 = g_sgh.sgh09
       AND pmn012= l_sgi.sgi012a         #FUN-A60092 add 
       
    IF cl_null(l_pmn43) THEN LET l_pmn43 = 0 END IF
    IF cl_null(l_shy06) THEN LET l_shy06 = 0 END IF
    IF l_pmn43 > l_shy06 THEN
       LET l_sgi04b = l_pmn43
    ELSE
       LET l_sgi04b = l_shy06
    END IF
    IF l_sgi04b >= l_sgi.sgi04b THEN
       CALL cl_err('','aec-094',1)
       LET g_success = 'N'
       RETURN
    END IF
 
    SELECT * INTO l_ecm.* FROM ecm_file
     WHERE ecm01 = g_sgh.sgh09
       AND ecm03 = l_sgi.sgi04a
       AND ecm012= l_sgi.sgi012a     #FUN-A60092 add
          
    IF NOT cl_null(l_sgi.sgi05b) THEN 
       LET l_ecm.ecm04 = l_sgi.sgi05b
       SELECT ecd02 INTO l_ecm.ecm45 FROM ecd_file
        WHERE ecd01= l_sgi.sgi05b
    END IF
    IF NOT cl_null(l_sgi.sgi06b) THEN
       LET l_ecm.ecm06 = l_sgi.sgi06b
    END IF
    IF NOT cl_null(l_sgi.sgi07b) THEN
       LET l_ecm.ecm14 = l_sgi.sgi07b
    END IF
    IF NOT cl_null(l_sgi.sgi08b) THEN
       LET l_ecm.ecm50 = l_sgi.sgi08b
    END IF
    IF NOT cl_null(l_sgi.sgi09b) THEN
       LET l_ecm.ecm13 = l_sgi.sgi09b
    END IF
    IF NOT cl_null(l_sgi.sgi10b) THEN
       LET l_ecm.ecm51 = l_sgi.sgi10b
    END IF
    IF NOT cl_null(l_sgi.sgi11b) THEN
       LET l_ecm.ecm16 = l_sgi.sgi11b
    END IF
    IF NOT cl_null(l_sgi.sgi12b) THEN
       LET l_ecm.ecm15 = l_sgi.sgi12b
    END IF
    IF NOT cl_null(l_sgi.sgi13b) THEN
       LET l_ecm.ecm52 = l_sgi.sgi13b
    END IF
    IF NOT cl_null(l_sgi.sgi14b) THEN
       LET l_ecm.ecm53 = l_sgi.sgi14b
    END IF

    UPDATE ecm_file SET ecm53 = l_ecm.ecm53,ecm16 = l_ecm.ecm16,
                        ecm52 = l_ecm.ecm52,ecm51 = l_ecm.ecm51,
                        ecm15 = l_ecm.ecm15,ecm13 = l_ecm.ecm13,
                        ecm50 = l_ecm.ecm50,ecm14 = l_ecm.ecm14,
                        ecm06 = l_ecm.ecm06,ecm45 = l_ecm.ecm45,
                        ecm04 = l_ecm.ecm04
                  WHERE ecm01 = l_ecm.ecm01 
                    AND ecm03 = l_ecm.ecm03
                    AND ecm012= l_sgi.sgi012a        #FUN-A60092 
                    
    #add by grissom on 2007.0407
    UPDATE sgd_file SET sgd04 = l_ecm.ecm06
     WHERE sgd00 = l_ecm.ecm01 
       AND sgd02 = l_ecm.ecm11 
       AND sgd03 = l_ecm.ecm03
       AND sgd012= l_sgi.sgi012a    #FUN-A60092 
       
    IF SQLCA.SQLCODE THEN
       CALL cl_err('upd ecm: ',SQLCA.SQLCODE,1)
       LET g_success='N'
    END IF
END FUNCTION

FUNCTION i722_s3()
DEFINE l_ecm        RECORD LIKE ecm_file.*,
       l_pmn43      LIKE pmn_file.pmn43,
       l_shy06      LIKE shy_file.shy06,
       l_ecm03      LIKE ecm_file.ecm03,
       l_ecm301     LIKE ecm_file.ecm301,
       l_sgi04b     LIKE sgi_file.sgi04b
 
    SELECT MAX(pmn43) INTO l_pmn43 FROM pmn_file
     WHERE pmn41 = g_sgh.sgh09
       AND pmn012= l_sgi.sgi012a    #FUN-A60092 add
       
    SELECT MAX(shy06) INTO l_shy06 
      FROM shy_file,shx_file
     WHERE shx01 = shy01 
       AND shx07<>'Y' 
       AND shy03 = g_sgh.sgh09                               
       
    IF cl_null(l_pmn43) THEN LET l_pmn43 = 0 END IF
    IF cl_null(l_shy06) THEN LET l_shy06 = 0 END IF
    IF l_pmn43 > l_shy06 THEN
       LET l_sgi04b = l_pmn43
    ELSE
       LET l_sgi04b = l_shy06
    END IF
    IF l_sgi04b >= l_sgi.sgi04b THEN
       CALL cl_err('','aec-094',1)
       LET g_success = 'N'
       RETURN
    END IF
 
    SELECT MIN(ecm03) INTO l_ecm03 FROM ecm_file
     WHERE ecm01 = g_sgh.sgh09
       AND ecm012= l_sgi.sgi012a              #FUN-A60092 add 
     
    IF l_ecm03 = l_sgi.sgi04a THEN
       SELECT ecm301 INTO l_ecm301 FROM ecm_file
        WHERE ecm01 = g_sgh.sgh09
          AND ecm03 = l_sgi.sgi04a
          AND ecm012= l_sgi.sgi012a   #FUN-A60092 add
       SELECT MIN(ecm03) INTO l_ecm03 FROM ecm_file
         WHERE ecm01 = g_sgh.sgh09
           AND ecm03 <> l_sgi.sgi04a
           AND ecm012= l_sgi.sgi012a    #FUN-A60092 add
       UPDATE ecm_file SET ecm301=l_ecm301
        WHERE ecm01 = g_sgh.sgh09
          AND ecm03 = l_ecm03
          AND ecm012= l_sgi.sgi012a       #FUN-A60092 add
    END IF
    
     #刪除制程站資料移轉數量處理
    IF not i722_wipchk(g_sgh.sgh09,3,l_sgi.sgi04b,l_sgi.sgi012b) THEN  #FUN-A60092 add sgi012b
    	 CALL i722_ecm301(g_sgh.sgh09,l_sgi.sgi04b,l_sgi.sgi012b)   #FUN-A60092 add sgi012b
    END IF
    
    DELETE FROM ecm_file WHERE ecm01 = g_sgh.sgh09
                           AND ecm03 = l_sgi.sgi04a
                           AND ecm012= l_sgi.sgi012a   #FUN-A60092 add
    IF SQLCA.SQLCODE THEN
      CALL cl_err('del ecm: ',SQLCA.SQLCODE,1)
      LET g_success='N'
    END IF      
#add by chenyu --08/07/10---begin
    DELETE FROM sgd_file WHERE sgd00 = g_sgh.sgh09
                           AND sgd03 = l_sgi.sgi04a
                           AND sgd012= l_sgi.sgi012a   #FUN-A60092 add
    IF SQLCA.SQLCODE THEN
       CALL cl_err('del sgd_file:',SQLCA.SQLCODE,1)
       LET g_success = 'N'
    END IF
#add by chenyu --08/07/10---end
 
END FUNCTION

FUNCTION i722_b_move_to()
   LET g_sgi[l_ac].sgi02   = b_sgi.sgi02
   LET g_sgi[l_ac].sgi03   = b_sgi.sgi03
   LET g_sgi[l_ac].sgi012a = b_sgi.sgi012a           #FUN-A60092 add
   LET g_sgi[l_ac].sgi012b = b_sgi.sgi012b           #FUN-A60092 add   
   LET g_sgi[l_ac].sgi04a  = b_sgi.sgi04a
   LET g_sgi[l_ac].sgi04b  = b_sgi.sgi04b
   LET g_sgi[l_ac].sgi05a  = b_sgi.sgi05a
   LET g_sgi[l_ac].sgi05b  = b_sgi.sgi05b
   LET g_sgi[l_ac].sgi06a  = b_sgi.sgi06a
   LET g_sgi[l_ac].sgi06b  = b_sgi.sgi06b
   LET g_sgi[l_ac].sgi07a  = b_sgi.sgi07a
   LET g_sgi[l_ac].sgi07b  = b_sgi.sgi07b
   LET g_sgi[l_ac].sgi08a  = b_sgi.sgi08a
   LET g_sgi[l_ac].sgi08b  = b_sgi.sgi08b
   LET g_sgi[l_ac].sgi09a  = b_sgi.sgi09a
   LET g_sgi[l_ac].sgi09b  = b_sgi.sgi09b
   LET g_sgi[l_ac].sgi10a  = b_sgi.sgi10a
   LET g_sgi[l_ac].sgi10b  = b_sgi.sgi10b
   LET g_sgi[l_ac].sgi11a  = b_sgi.sgi11a
   LET g_sgi[l_ac].sgi11b  = b_sgi.sgi11b
   LET g_sgi[l_ac].sgi12a  = b_sgi.sgi12a
   LET g_sgi[l_ac].sgi12b  = b_sgi.sgi12b
   LET g_sgi[l_ac].sgi13a  = b_sgi.sgi13a
   LET g_sgi[l_ac].sgi13b  = b_sgi.sgi13b
   LET g_sgi[l_ac].sgi14a  = b_sgi.sgi14a
   LET g_sgi[l_ac].sgi14b  = b_sgi.sgi14b
END FUNCTION
 
FUNCTION i722_b_move_back()
   LET b_sgi.sgi02   = g_sgi[l_ac].sgi02
   LET b_sgi.sgi03   = g_sgi[l_ac].sgi03
   LET b_sgi.sgi012a = g_sgi[l_ac].sgi012a            #FUN-A60092 add
   LET b_sgi.sgi012b = g_sgi[l_ac].sgi012b            #FUN-A60092 add      
   LET b_sgi.sgi04a  = g_sgi[l_ac].sgi04a
   LET b_sgi.sgi04b  = g_sgi[l_ac].sgi04b
   LET b_sgi.sgi05a  = g_sgi[l_ac].sgi05a
   LET b_sgi.sgi05b  = g_sgi[l_ac].sgi05b
   LET b_sgi.sgi06a  = g_sgi[l_ac].sgi06a
   LET b_sgi.sgi06b  = g_sgi[l_ac].sgi06b
   LET b_sgi.sgi07a  = g_sgi[l_ac].sgi07a
   LET b_sgi.sgi07b  = g_sgi[l_ac].sgi07b
   LET b_sgi.sgi08a  = g_sgi[l_ac].sgi08a
   LET b_sgi.sgi08b  = g_sgi[l_ac].sgi08b
   LET b_sgi.sgi09a  = g_sgi[l_ac].sgi09a
   LET b_sgi.sgi09b  = g_sgi[l_ac].sgi09b
   LET b_sgi.sgi10a  = g_sgi[l_ac].sgi10a
   LET b_sgi.sgi10b  = g_sgi[l_ac].sgi10b
   LET b_sgi.sgi11a  = g_sgi[l_ac].sgi11a
   LET b_sgi.sgi11b  = g_sgi[l_ac].sgi11b
   LET b_sgi.sgi12a  = g_sgi[l_ac].sgi12a
   LET b_sgi.sgi12b  = g_sgi[l_ac].sgi12b
   LET b_sgi.sgi13a  = g_sgi[l_ac].sgi13a
   LET b_sgi.sgi13b  = g_sgi[l_ac].sgi13b
   LET b_sgi.sgi14a  = g_sgi[l_ac].sgi14a
   LET b_sgi.sgi14b  = g_sgi[l_ac].sgi14b
END FUNCTION
 
FUNCTION i722_p()   #批次產生變更單
DEFINE l_sfb      RECORD LIKE sfb_file.*,
       l_sgh      RECORD LIKE sgh_file.*,
       l_sgi      RECORD LIKE sgi_file.*,
       li_result  LIKE type_file.chr1,
       l_success  LIKE type_file.chr1,
       l_n        LIKE type_file.num5
     
  IF cl_null(g_sgh.sgh01) THEN RETURN END IF
  IF g_sgh.sghconf = 'N'  THEN
  	 CALL cl_err('','aec-095',1)
  	 RETURN
  END IF
  IF g_sgh.sghconf = 'X' THEN RETURN END IF  #CHI-C80041
  IF NOT cl_confirm('aec-109') THEN RETURN END IF
  SELECT * INTO l_sgh.* FROM sgh_file 
     WHERE sgh01 = g_sgh.sgh01
  LET l_success = 'Y'
  BEGIN WORK
  DECLARE t_p CURSOR FOR
     SELECT * FROM sfb_file
       WHERE sfb85 = g_sgh.sgh10
         AND sfb01 != g_sgh.sgh09
  FOREACH t_p INTO l_sfb.*
      LET l_sgh.sgh09 = l_sfb.sfb01
      LET l_sgh.sgh02 = l_sfb.sfb05
      LET l_sgh.sgh04 = g_today
      LET l_sgh.sgh07 = g_user
      LET l_sgh.sgh05 = NULL
      #工單已存在未發出的變更單不能重復產生
      LET l_n = 0
      SELECT COUNT(*) INTO l_n
        FROM sgh_file
       WHERE sgh09 = l_sfb.sfb01
         AND sghconf <> 'X'  #CHI-C80041
         AND (sgh05 is null OR length(sgh05) = 0 )
      IF cl_null(l_n) THEN LET l_n = 0 END IF
      IF l_n > 0 THEN
      	 CALL cl_err(l_sfb.sfb01,'aec-088',1)
      	 LET l_success = 'N'
      	 EXIT FOREACH
      END IF 
      
      CALL s_auto_assign_no("asf",l_sgh.sgh01[1,4],l_sgh.sgh04,"I","sgh_file","sgh01","","","")
      RETURNING li_result,l_sgh.sgh01
      IF (NOT li_result) THEN
         LET l_success = 'N' 
         EXIT FOREACH 
      END IF
      LET l_sgh.sghplant = g_plant #FUN-980002
      LET l_sgh.sghlegal = g_legal #FUN-980002
      LET l_sgh.sghoriu = g_user      #No.FUN-980030 10/01/04
      LET l_sgh.sghorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO sgh_file VALUES(l_sgh.*)
      IF STATUS THEN
         CALL cl_err('ins_sgh',STATUS,1)
         LET l_success = 'N'
         EXIT FOREACH
      END IF
      DECLARE t_p1 CURSOR FOR
        SELECT * FROM sgi_file
         WHERE sgi01 = g_sgh.sgh01
      FOREACH t_p1 INTO l_sgi.*
        LET l_sgi.sgi01 = l_sgh.sgh01 
        SELECT MAX(sgi02)+1 INTO l_sgi.sgi02
          FROM sgi_file
         WHERE sgi01 = l_sgi.sgi01
        IF cl_null(l_sgi.sgi02) THEN
           LET l_sgi.sgi02 = 1
        END IF
        LET l_sgi.sgiplant = g_plant #FUN-980002
        LET l_sgi.sgilegal = g_legal #FUN-980002
        INSERT INTO sgi_file VALUES(l_sgi.*)
        IF STATUS THEN
           CALL cl_err('ins_sgi',STATUS,1)
           LET l_success = 'N'
           EXIT FOREACH
        END IF
      END FOREACH
  END FOREACH
  IF l_success = 'Y' THEN
     COMMIT WORK
     MESSAGE 'Y'
  ELSE
     ROLLBACK WORK
     MESSAGE 'N'
  END IF
END FUNCTION
 
FUNCTION i722_y()#審核 
 
   IF s_shut(0) THEN RETURN END IF
   IF g_sgh.sgh01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#CHI-C30107 --------- add --------- begin
   IF g_sgh.sghconf = 'Y' THEN
      CALL cl_err('','aec-089',0) RETURN
   END IF
   IF g_sgh.sghconf = 'X' THEN
      CALL cl_err('','aec-090',0)
   END IF
   IF NOT cl_confirm('aap-222') THEN RETURN END IF
   SELECT * INTO g_sgh.* FROM sgh_file WHERE sgh01 = g_sgh.sgh01
#CHI-C30107 --------- add --------- end
   IF g_sgh.sghconf = 'Y' THEN
      CALL cl_err('','aec-089',0) RETURN
   END IF
   IF g_sgh.sghconf = 'X' THEN
      CALL cl_err('','aec-090',0)
   END IF
   IF NOT i722_check_date() THEN RETURN END IF  #TQC-C50194 add
#  IF NOT cl_confirm('aap-222') THEN RETURN END IF #CHI-C30107 mark
   UPDATE sgh_file SET sghconf = 'Y' 
                     WHERE sgh01 = g_sgh.sgh01
   SELECT * INTO g_sgh.* FROM sgh_file
        WHERE sgh01=g_sgh.sgh01
   CALL i722_show()
END FUNCTION
 
FUNCTION i722_z()  #取消審核
   IF s_shut(0) THEN RETURN END IF
   IF g_sgh.sgh01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_sgh.sghconf = 'N' THEN
      RETURN
   END IF
   IF g_sgh.sghconf = 'X' THEN
      CALL cl_err('','aec-090',0)
   END IF
   IF NOT cl_null(g_sgh.sgh05) THEN
      CALL cl_err('','aec-110',0) RETURN
   END IF
   IF NOT cl_confirm('aap-224') THEN RETURN END IF
   UPDATE sgh_file SET sghconf = 'N'
                     WHERE sgh01 = g_sgh.sgh01
   SELECT * INTO g_sgh.* FROM sgh_file
        WHERE sgh01=g_sgh.sgh01
   CALL i722_show()
END FUNCTION
 
#到轉移工藝序時，需WIP量轉到下一站
#為刪除狀態十，是否有未審核移轉資料
FUNCTION i722_wipchk(l_prono,l_type,l_workno,l_sgi012b)   #FUN-A60092 add l_sgi012b
   DEFINE l_prono     LIKE   sgh_file.sgh09   #工單號碼
   DEFINE l_type      LIKE   sgi_file.sgi03   #制程變更類型
   DEFINE l_workno    LIKE   sgi_file.sgi04a  #工藝序
   DEFINE l_count,l_count1     LIKE type_file.num5   
   DEFINE li_is_null  LIKE type_file.num5 
   DEFINE l_ecm03     LIKE ecm_file.ecm03   #FUN-A60081
   DEFINE l_ecm012    LIKE ecm_File.ecm012  #FUN-A60081
   DEFINE l_sgi012b   LIKE sgi_file.sgi012b  #FUN-A60092 add
   
   IF l_type = '3' THEN
	    SELECT count(*) INTO l_count FROM ecm_file
	     WHERE ecm01 = l_prono 
	       AND ecm03 = l_workno 
	       AND ecm311 = 0
	       AND ecm012 = l_sgi012b      #FUN-A60092 
	       
	    IF l_count >0 THEN
	    	 LET l_count = 0
         CALL s_schdat_max_ecm03(l_prono) RETURNING l_ecm012,l_ecm03    #FUN-A60081  
	    	 SELECT count(*) INTO l_count FROM ecm_file 
	    	    #WHERE ecm03 in (SELECT MAX(ecm03) FROM ecm_file                             #FUN-A60081  mark
	            #                 WHERE ecm01 = l_prono AND ecm03 < l_workno AND ecm311 = 0 )#FUN-A60081  mark
           WHERE ecm012 = l_ecm012  AND ecm03 = l_ecm03                                #FUN-A60081
	           AND ecm01 = l_prono 
	           AND ecm311 > 0
                                       
               #存在刪除移轉當站資料
	       IF l_count > 0 THEN 
	       	  LET li_is_null = TRUE
	       ELSE
	       	  LET li_is_null = FALSE	       	
	       END IF
	    END IF 
	 END IF
	 RETURN li_is_null
END FUNCTION 
  
#將刪除制程數量移到下一站
FUNCTION i722_ecm301(l_prono,l_workno,l_sgi012b)    #FUN-A60092 add l_sgi012b 
   DEFINE l_prono     LIKE sgh_file.sgh09   #工單號碼
   DEFINE l_workno    LIKE sgi_file.sgi04a  #工藝序
   DEFINE l_no,l_num  LIKE type_file.num5
   DEFINE l_sgi012b   LIKE sgi_file.sgi012b    #FUN-A60092 add
   
   SELECT MIN(ecm03) INTO l_no FROM ecm_file 
    WHERE ecm01 = l_prono 
      AND ecm03 > l_workno  
      AND ecm012= l_sgi012b    #FUN-A60092 add     
   
   SELECT ecm301 INTO l_num FROM ecm_file
    WHERE ecm03 = l_workno 
      AND ecm01 = l_prono
      AND ecm012= l_sgi012b    #FUN-A60092 add  
   
   UPDATE ecm_file
   SET ecm301 = l_num
   WHERE ecm01 = l_prono AND ecm03 = l_no
     AND ecm012= l_sgi012b    #FUN-A60092 add
     
   IF SQLCA.SQLCODE THEN
      CALL cl_err('',SQLCA.sqlcode,0)   	  
   END IF               
 
END FUNCTION 
 
#批次變更發出
FUNCTION i722_b_g()
   DEFINE tm      RECORD
                    sgh10    LIKE sgh_file.sgh10
                  END RECORD
   DEFINE l_sgh   RECORD LIKE sgh_file.*
   DEFINE l_sgi   RECORD LIKE sgi_file.*
   DEFINE l_sql       LIKE type_file.chr1000
   DEFINE l_saof001   LIKE sgh_file.sgh01,
          l_success   LIKE type_file.chr1,
          l_n         LIKE type_file.num5
 
   OPEN WINDOW i722_b_g_w WITH FORM "aec/42f/aeci722_b_g"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_locale("aeci722_b_g")

   LET g_success = 'Y'
   BEGIN WORK
   LET l_success = 'Y'
   WHILE TRUE
      CLEAR FORM
      ERROR ''
       LET tm.sgh10 = ''              
       INPUT BY NAME tm.sgh10 WITHOUT DEFAULTS  
       
       AFTER FIELD sgh10
           IF cl_null(tm.sgh10) THEN
           	  NEXT FIELD sgh10
           ELSE
           	  LET l_n = 0
           	  SELECT COUNT(*) INTO l_n
           	    FROM sgh_file
           	   WHERE sgh10 = tm.sgh10
           	     AND sghconf = 'N'
           	  IF cl_null(l_n) THEN LET l_n = 0 END IF
           	  IF l_n > 0 THEN
           	  	 CALL cl_err(tm.sgh10,'aec-096',1)
           	  	 NEXT FIELD sgh10
           	  END IF
           END IF
     
             ON ACTION CONTROLG
                CALL cl_cmdask()
      
             ON ACTION exit               
                LET INT_FLAG = 1 
      END INPUT
      
      IF INT_FLAG THEN 
         LET INT_FLAG=0 
         EXIT WHILE 
      END IF
      IF NOT cl_sure(5,5) THEN LET l_success = 'N' EXIT WHILE END IF
      LET l_sql = " SELECT * FROM sgh_file WHERE sgh10 = '",tm.sgh10,"'",
                  "    and sghconf = 'Y' " ,#已審核 
                  "    and (sgh05 IS NULL OR length(sgh05) = 0 ) "#未發出
      PREPARE i722_b_g_prepare FROM l_sql
      DECLARE i722_b_g_curs CURSOR FOR i722_b_g_prepare
      INITIALIZE g_sgh.* TO NULL
      FOREACH i722_b_g_curs INTO g_sgh.*   
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF  
         CALL i722_g('N') RETURNING l_success
         IF l_success = 'N' THEN
         	  EXIT FOREACH
         END IF              
      END FOREACH           
    EXIT WHILE
  END WHILE
  IF l_success = 'Y' THEN
  	 COMMIT WORK
  ELSE
  	 ROLLBACK WORK
  END IF 
  CLOSE WINDOW i722_b_g_w          
END FUNCTION

#TQC-C50194--add--str--

FUNCTION i722_check_sgi04a()
   DEFINE l_pmn43     LIKE pmn_file.pmn43
   DEFINE l_shy06     LIKE shy_file.shy06
   DEFINE l_sgi04a    LIKE sgi_file.sgi04a
   DEFINE l_k         LIKE type_file.num5
   DEFINE i           LIKE type_file.num5
   DEFINE  l_ecm301   LIKE ecm_file.ecm301   
   DEFINE  l_ecm302   LIKE ecm_file.ecm302   
   DEFINE  l_ecm303   LIKE ecm_file.ecm303   

   IF NOT cl_null(g_sgi[l_ac].sgi04a) THEN
      IF g_sgi[l_ac].sgi03 MATCHES '[23]' THEN
         LET l_pmn43 = NULL
         LET l_shy06 = NULL
         SELECT MAX(pmn43) INTO l_pmn43 FROM pmn_file
          WHERE pmn41 = g_sgh.sgh09
            AND pmn012= g_sgi[l_ac].sgi012a    #FUN-A60092 add
         SELECT MAX(shy06) INTO l_shy06 
           FROM shy_file,shx_file
          WHERE shx01 = shy01 
            AND shx07<>'Y' 
            AND shy03 = g_sgh.sgh09     
         IF cl_null(l_pmn43) THEN LET l_pmn43 = 0 END IF
         IF cl_null(l_shy06) THEN LET l_shy06 = 0 END IF
         IF l_pmn43 > l_shy06 THEN
            LET l_sgi04a = l_pmn43
         ELSE
            LET l_sgi04a = l_shy06
         END IF
         IF l_sgi04a >= g_sgi[l_ac].sgi04a THEN
            CALL cl_err('','aec-094',1)
            #NEXT FIELD sgi04a  #add return
            RETURN FALSE
         END IF
      END IF
      LET l_k = 0
      SELECT COUNT(*) INTO l_k FROM ecm_file
        WHERE ecm01 = g_sgh.sgh09
          AND ecm03 = g_sgi[l_ac].sgi04a
          AND ecm012= g_sgi[l_ac].sgi012a   #FUN-A60092 add
      IF l_k <= 0 THEN
         CALL cl_err('','aec-097',1)
         #NEXT FIELD sgi04a  #add return
         RETURN FALSE
      END IF 
      LET l_k = 0
      SELECT COUNT(*) INTO l_k FROM sgd_file
        WHERE sgd00 = g_sgh.sgh09
          AND sgd01 = g_sgh.sgh02
          AND sgd02 = g_sgh.sgh03
          AND sgd03 = g_sgi[l_ac].sgi04a
          AND sgd012= g_sgi[l_ac].sgi012a   #FUN-A60092 add
      IF l_k > 0 THEN   
         #add by chenyu --08/07/10----begin  #增加一個判斷
         SELECT ecm301,ecm302,ecm303 INTO l_ecm301,l_ecm302,l_ecm303 FROM ecm_file
          WHERE ecm01 = g_sgh.sgh09
            AND ecm03 = g_sgi[l_ac].sgi04a
            AND ecm012= g_sgi[l_ac].sgi012a   #FUN-A60092 add                     
         IF cl_null(l_ecm301) THEN  LET l_ecm301 = 0  END IF
         IF cl_null(l_ecm302) THEN  LET l_ecm302 = 0  END IF
         IF cl_null(l_ecm303) THEN  LET l_ecm303 = 0  END IF
         IF l_ecm301 != 0 OR l_ecm302 != 0 OR l_ecm303 != 0 THEN
            CALL cl_err('','aec-098',1)
            #NEXT FIELD sgi04a  #add return
            RETURN FALSE
         END IF
         #add by chenyu --08/07/10----end
      END IF
      LET g_sgi[l_ac].sgi04b = g_sgi[l_ac].sgi04a
      LET g_sgi[l_ac].sgi012b= g_sgi[l_ac].sgi012a    #FUN-A60092 add
      SELECT ecm04,ecm06,ecm14,ecm50,ecm13,
             ecm51,ecm16,ecm15,ecm52,ecm53
        INTO g_sgi[l_ac].sgi05a,g_sgi[l_ac].sgi06a,
             g_sgi[l_ac].sgi07a,g_sgi[l_ac].sgi08a,
             g_sgi[l_ac].sgi09a,g_sgi[l_ac].sgi10a,
             g_sgi[l_ac].sgi11a,g_sgi[l_ac].sgi12a,
             g_sgi[l_ac].sgi13a,g_sgi[l_ac].sgi14a
        FROM ecm_file
       WHERE ecm01 = g_sgh.sgh09
         AND ecm03 = g_sgi[l_ac].sgi04a 
         AND ecm012= g_sgi[l_ac].sgi012a   #FUN-A60092 add                  
      SELECT eca02 INTO g_sgi[l_ac].eca02a FROM eca_file
       WHERE eca01 = g_sgi[l_ac].sgi06a
      SELECT ecd02 INTO g_sgi[l_ac].ecm45a FROM ecd_file
        WHERE ecd01 = g_sgi[l_ac].sgi05a
      #TQC-C50194--add--str--
      FOR i=1 TO g_sgi.getlength()
         IF i <> l_ac THEN
            IF g_sgi[i].sgi04a = g_sgi[l_ac].sgi04a AND g_sgi[i].sgi012a = g_sgi[l_ac].sgi012a THEN
               IF g_sma.sma541 = 'Y' THEN
                  CALL cl_err('','aec-313',1)
               ELSE
                  CALL cl_err('','aec-093',1)
               END IF
               RETURN FALSE
            END IF
         END IF
      END FOR
      #add--end--
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i722_check_sgi04b()
   DEFINE l_pmn43     LIKE pmn_file.pmn43
   DEFINE l_shy06     LIKE shy_file.shy06
   DEFINE l_sgi04b    LIKE sgi_file.sgi04b
   DEFINE l_k         LIKE type_file.num5
   DEFINE i           LIKE type_file.num5

   IF NOT cl_null(g_sgi[l_ac].sgi04b) THEN
      IF g_sgi[l_ac].sgi03 MATCHES '[1]' THEN
   #      IF cl_null(g_sgi[l_ac].sgi04b) THEN
   #         NEXT FIELD sgi04b
   #      END IF
         LET l_pmn43 = NULL
         LET l_shy06 = NULL
         SELECT MAX(pmn43) INTO l_pmn43 FROM pmn_file
          WHERE pmn41 = g_sgh.sgh09
            AND pmn012= g_sgi[l_ac].sgi012b   #FUN-A60092 add
         SELECT MAX(shy06) INTO l_shy06 
           FROM shy_file,shx_file
          WHERE shx01 = shy01 
            AND shx07<>'Y' 
            AND shy03 = g_sgh.sgh09  
         IF cl_null(l_pmn43) THEN LET l_pmn43 = 0 END IF
         IF cl_null(l_shy06) THEN LET l_shy06 = 0 END IF
         IF l_pmn43 > l_shy06 THEN
            LET l_sgi04b = l_pmn43
         ELSE
            LET l_sgi04b = l_shy06
         END IF
         IF l_sgi04b >= g_sgi[l_ac].sgi04b THEN
            CALL cl_err('','aec-092',1)
         #   NEXT FIELD sgi04b  #add return
            RETURN FALSE
         END IF
         LET l_k = 0
         SELECT COUNT(*) INTO l_k FROM ecm_file
           WHERE ecm01 = g_sgh.sgh09
             AND ecm03 = g_sgi[l_ac].sgi04b
             AND ecm012= g_sgi[l_ac].sgi012b   #FUN-A60092 add
         IF l_k > 0  THEN
         #   CALL cl_err('','aec-093',1)       #TQC-C50194
             IF g_sma.sma541 = 'Y' THEN
                CALL cl_err('','aec-313',1)
             ELSE
                CALL cl_err('','aec-093',1)
             END IF
         #   NEXT FIELD sgi04b  #add return
            RETURN FALSE
         END IF
         #TQC-C50194--add--str--
         FOR i=1 TO g_sgi.getlength()
            IF i <> l_ac THEN 
               IF g_sgi[i].sgi04b = g_sgi[l_ac].sgi04b AND g_sgi[i].sgi012b = g_sgi[l_ac].sgi012b THEN
                  IF g_sma.sma541 = 'Y' THEN 
                     CALL cl_err('','aec-313',1)
                  ELSE
                     CALL cl_err('','aec-093',1)
                  END IF
                  RETURN FALSE 
               END IF
            END IF
         END FOR
         #add--end--
      END IF 
   #ELSE
   #   NEXT FIELD sgi04b
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i722_check_date()
   DEFINE i   LIKE type_file.num5
 
   FOR i=1 TO g_sgi.getLength()
      IF NOT cl_null(g_sgi[i].sgi10b) THEN 
         IF NOT cl_null(g_sgi[i].sgi08b) THEN
            IF g_sgi[i].sgi10b < g_sgi[i].sgi08b THEN
               CALL cl_err('','aec-993',1)
               RETURN FALSE
            END IF
         ELSE
            IF NOT cl_null(g_sgi[i].sgi08a) AND g_sgi[i].sgi10b < g_sgi[i].sgi08a THEN
              CALL cl_err('','aec-993',1)
              RETURN FALSE
            END IF
         END IF
      ELSE
         IF NOT cl_null(g_sgi[i].sgi08b) AND NOT cl_null(g_sgi[i].sgi10a) AND g_sgi[i].sgi10a < g_sgi[i].sgi08b THEN
            CALL cl_err('','aec-993',1)
            RETURN FALSE
         END IF 
      END IF
   END FOR
   RETURN TRUE
END FUNCTION 

FUNCTION i722_ecm014(p_ecm01,p_ecm012)
DEFINE   p_ecm01     LIKE ecm_file.ecm01
DEFINE   p_ecm012    LIKE ecm_file.ecm012
DEFINE   l_ecm014    LIKE ecm_file.ecm014

   DECLARE i722_ecm014_curs CURSOR FOR
    SELECT DISTINCT ecm014 FROM ecm_file
     WHERE ecm01  = p_ecm01 
       AND ecm012 = p_ecm012 
   FOREACH i722_ecm014_curs INTO l_ecm014
      IF NOT cl_null(l_ecm014) THEN
         EXIT FOREACH
      ELSE
         CONTINUE FOREACH
      END IF
   END FOREACH
   IF cl_null(l_ecm014) THEN
      SELECT ecr02 INTO l_ecm014 FROM ecr_file
       WHERE ecr01 = p_ecm012 
         AND ecracti = 'Y'
   END IF
   RETURN l_ecm014 
END FUNCTION

FUNCTION i722_ecm015(p_ecm01,p_ecm012)
DEFINE   p_ecm01     LIKE ecm_file.ecm01
DEFINE   p_ecm012    LIKE ecm_file.ecm012
DEFINE   l_ecm015    LIKE ecm_file.ecm015

   DECLARE i722_ecm015_curs CURSOR FOR
    SELECT DISTINCT ecm015 FROM ecm_file
     WHERE ecm01  = p_ecm01
       AND ecm012 = p_ecm012 
   FOREACH i722_ecm015_curs INTO l_ecm015
      IF NOT cl_null(l_ecm015) THEN
         EXIT FOREACH          
      ELSE
         CONTINUE FOREACH
      END IF
   END FOREACH 
   RETURN l_ecm015
END FUNCTION

FUNCTION i722_set_entry_b()                                                                                                      
   CALL cl_set_comp_entry("sgi012a,sgi04a",TRUE)    
   CALL cl_set_comp_entry("sgi012b,sgi04b,sgi05b,sgi06b,sgi07b,   
                           sgi08b,sgi09b,sgi10b,sgi11b,
                           sgi12b,sgi13b,sgi14b",TRUE)
END FUNCTION                           

FUNCTION i722_set_no_entry_b()                                        
   IF l_ac > 0 THEN
      IF g_sgi[l_ac].sgi03 = '1' THEN
        CALL cl_set_comp_entry("sgi012a,sgi04a,sgi05a,sgi06a,sgi07a,   
                                sgi08a,sgi09a,sgi10a,sgi11a,
                               sgi12a,sgi13a,sgi14a",FALSE)     #FUN-A60092 add sgi012a
      END IF
      IF g_sgi[l_ac].sgi03 = '3' THEN
         CALL cl_set_comp_entry("sgi05a,sgi06a,sgi07a,
                                 sgi08a,sgi09a,sgi10a,sgi11a,
                                 sgi12a,sgi13a,sgi14a,
                                 sgi012b,                    
                                 sgi04b,sgi05b,sgi06b,sgi07b,
                                 sgi08b,sgi09b,sgi10b,sgi11b,
                                 sgi12b,sgi13b,sgi14b",FALSE)   #FUN-A60092 add sgi012b
      END IF
      IF g_sgi[l_ac].sgi03 = '2' THEN
         CALL cl_set_comp_entry("sgi012b,sgi04b,sgi05a,sgi06a,sgi07a,  
                                 sgi08a,sgi09a,sgi10a,sgi11a,
                                 sgi12a,sgi13a,sgi14a,",FALSE)  #FUN-A60092 sgi012b
      END IF                                                                         
   END IF
END FUNCTION         

FUNCTION i722_set_no_required()
   CALL cl_set_comp_required("sgi04a,sgi012a",FALSE)
   CALL cl_set_comp_required("sgi04b,sgi012b,sgi05b,sgi06b,sgi08b,sgi10b,sgi13b,sgi14b",FALSE)
END FUNCTION

FUNCTION i722_set_required()
   IF l_ac > 0 THEN
      IF g_sgi[l_ac].sgi03 MATCHES '[1]' THEN
         IF g_sma.sma541 = 'Y' THEN 
            CALL cl_set_comp_required("sgi012b",TRUE)
         END IF
         CALL cl_set_comp_required("sgi04b,sgi05b,sgi06b,sgi08b,sgi10b,sgi13b,sgi14b",TRUE)
      END IF
      IF g_sgi[l_ac].sgi03 MATCHES '[2,3]' THEN
         IF g_sma.sma541 = 'Y' THEN 
            CALL cl_set_comp_required("sgi012a",TRUE)
         END IF
         CALL cl_set_comp_required("sgi04a",TRUE)
      END IF
   END IF
END FUNCTION

#TQC-C50194--add--end--
#CHI-C80041---begin
#FUNCTION i722_v()        #CHI-D20010
FUNCTION i722_v(p_type)   #CHI-D20010
DEFINE l_chr  LIKE type_file.chr1
DEFINE l_flag LIKE type_file.chr1  #CHI-D20010
DEFINE p_type LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_sgh.sgh01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   #CHI-D20010---begin
    IF p_type = 1 THEN
       IF g_sgh.sghconf ='X' THEN RETURN END IF
    ELSE
       IF g_sgh.sghconf <>'X' THEN RETURN END IF
    END IF
    #CHI-D20010---end
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN i722_cl USING g_sgh.sgh01
   IF STATUS THEN
      CALL cl_err("OPEN i722_cl:", STATUS, 1)
      CLOSE i722_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i722_cl INTO g_sgh.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_sgh.sgh01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE i722_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_sgh.sghconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF g_sgh.sghconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_sgh.sghconf) THEN   #CHI-D20010 
   IF cl_void(0,0,l_flag) THEN   #CHI-D20010
        LET l_chr=g_sgh.sghconf
       #IF g_sgh.sghconf='N' THEN  #CHI-D20010
        IF p_type = 1 THEN         #CHI-D20010
            LET g_sgh.sghconf='X' 
        ELSE
            LET g_sgh.sghconf='N'
        END IF
        UPDATE sgh_file
            SET sghconf=g_sgh.sghconf,  
                sghmodu=g_user,
                sghdate=g_today
            WHERE sgh01=g_sgh.sgh01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","sgh_file",g_sgh.sgh01,"",SQLCA.sqlcode,"","",1)  
            LET g_sgh.sghconf=l_chr 
        END IF
        DISPLAY BY NAME g_sgh.sghconf
   END IF
 
   CLOSE i722_cl
   COMMIT WORK
   CALL cl_flow_notify(g_sgh.sgh01,'V')
 
END FUNCTION
#CHI-C80041---end
