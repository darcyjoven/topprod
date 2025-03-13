# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Modify.........: 新建立 FUN-8A0122 binbin
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A90024 10/11/30 By Jay 1.將_fetch()原本INTO wah02改成INTO wah01, wah02
#                                                2.調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   g_wah       RECORD LIKE wah_file.*,
   g_wah_t     RECORD LIKE wah_file.*,
   g_wah_o     RECORD LIKE wah_file.*,
   g_wah01_t   LIKE wah_file.wah01,
   g_wai         DYNAMIC ARRAY OF RECORD
       wai03     LIKE wai_file.wai03,
       wai04     LIKE wai_file.wai04,
       gaq03     LIKE gaq_file.gaq03,
       wai05     LIKE wai_file.wai05,
       wai06     LIKE wai_file.wai06,
       wai07     LIKE wai_file.wai07,
       wai08     LIKE wai_file.wai08,
       wai09     LIKE wai_file.wai09,
       wai10     LIKE wai_file.wai10,
       wai11     LIKE wai_file.wai11,
       wai12     LIKE wai_file.wai12,
       wai13     LIKE wai_file.wai13,
       wai14     LIKE wai_file.wai14
#       wai15     LIKE wai_file.wai15,
#       wai16     LIKE wai_file.wai16,
#       wai17     LIKE wai_file.wai17,
#       wai18     LIKE wai_file.wai18
                 END RECORD,
    g_wai_t      RECORD
#       wai02     LIKE wai_file.wai02,
       wai03     LIKE wai_file.wai03,
       wai04     LIKE wai_file.wai04,
       gaq03     LIKE gaq_file.gaq03,
       wai05     LIKE wai_file.wai05,
       wai06     LIKE wai_file.wai06,
       wai07     LIKE wai_file.wai07,
       wai08     LIKE wai_file.wai08,
       wai09     LIKE wai_file.wai09,
       wai10     LIKE wai_file.wai10,
       wai11     LIKE wai_file.wai11,
       wai12     LIKE wai_file.wai12,
       wai13     LIKE wai_file.wai13,
       wai14     LIKE wai_file.wai14
#       wai15     LIKE wai_file.wai15,
#       wai16     LIKE wai_file.wai16,
#       wai17     LIKE wai_file.wai17,
#       wai18     LIKE wai_file.wai18
                 END RECORD,
   g_wai_o       RECORD
#       wai02     LIKE wai_file.wai02,
       wai03     LIKE wai_file.wai03,
       wai04     LIKE wai_file.wai04,
       gaq03     LIKE gaq_file.gaq03,
       wai05     LIKE wai_file.wai05,
       wai06     LIKE wai_file.wai06,
       wai07     LIKE wai_file.wai07,
       wai08     LIKE wai_file.wai08,
       wai09     LIKE wai_file.wai09,
       wai10     LIKE wai_file.wai10,
       wai11     LIKE wai_file.wai11,
       wai12     LIKE wai_file.wai12,
       wai13     LIKE wai_file.wai13,
       wai14     LIKE wai_file.wai14
#       wai15     LIKE wai_file.wai15,
#       wai16     LIKE wai_file.wai16,
#       wai17     LIKE wai_file.wai17,
#       wai18     LIKE wai_file.wai18
                 END RECORD,
       tm        DYNAMIC ARRAY OF RECORD
                          a    LIKE type_file.chr1,
                          b    LIKE wah_file.wah02
                 END RECORD,
#       g_c       LIKE wah_file.wah01,    
    #g_wc,g_wc2,g_sql      LIKE type_file.chr300,
    g_wc,g_wc2,g_sql      STRING,       #NO.FUN-910082
    g_rec_b               LIKE type_file.num5,
    l_ac                  LIKE type_file.num5
DEFINE g_forupd_sql       STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr              LIKE type_file.chr1
DEFINE g_cnt              LIKE type_file.num5
DEFINE g_msg              LIKE type_file.chr100
DEFINE g_curs_index       LIKE type_file.num5
DEFINE g_row_count        LIKE type_file.num5
DEFINE g_jump             LIKE type_file.num5
DEFINE g_no_ask           LIKE type_file.num5
DEFINE g_cmd              STRING
 
MAIN
    OPTIONS 
       INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF 
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AWS")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    LET g_forupd_sql ="SELECT * FROM wah_file WHERE wah01 = ? AND wah02 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i007_c1 CURSOR FROM g_forupd_sql
 
    OPEN WINDOW i007_w WITH FORM "aws/42f/awsi007"
       ATTRIBUTE (STYLE =g_win_style CLIPPED)
    CALL cl_ui_init()
 
    CALL i007_menu()
    CLOSE WINDOW i007_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i007_bp(p_ud)
    DEFINE    p_ud       LIKE type_file.chr1
 
    IF p_ud<>"G" OR g_action_choice ="detail" THEN
       RETURN
    END IF
 
    LET g_action_choice =" "
 
    CALL cl_set_act_visible("accept,cancel",FALSE)
    DISPLAY ARRAY g_wai TO s_wai.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index,g_row_count )
       BEFORE ROW
          LET l_ac = ARR_CURR()
 
       ON ACTION insert
          LET g_action_choice ="insert"
          EXIT DISPLAY
       ON ACTION query
          LET g_action_choice ="query"
          EXIT DISPLAY
       ON ACTION delete
          LET g_action_choice ="delete"
          EXIT DISPLAY
       ON ACTION modify
          LET g_action_choice ="modify"
          EXIT DISPLAY
       ON ACTION first
          CALL i007_fetch('F')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)  
       ON ACTION previous
          CALL i007_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)  
       ON ACTION jump 
          CALL i007_fetch('/')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)  
       ON ACTION next
          CALL i007_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)  
       ON ACTION last
          CALL i007_fetch('L')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
       ON ACTION invalid
          LET g_action_choice ="invalid"
          EXIT DISPLAY
       ON ACTION reproduce
          LET g_action_choice ="reproduce"
          EXIT DISPLAY
       ON ACTION detail
          LET g_action_choice ="detail"
          LET l_ac =1
          EXIT DISPLAY
       ON ACTION output
          LET g_action_choice ="output"
          EXIT DISPLAY
       ON ACTION help
          LET g_action_choice ="help"
          EXIT DISPLAY
       ON ACTION locale
          CALL cl_dynamic_locale()
       ON ACTION exit
          LET g_action_choice ="exit"
          EXIT DISPLAY
       ON ACTION controlg
          LET g_action_choice ="controlg"
          EXIT DISPLAY
       ON ACTION accept
          LET g_action_choice ="detail"
          LET l_ac=ARR_CURR()
          EXIT DISPLAY
       ON ACTION set
          LET g_action_choice ="set"
          EXIT DISPLAY
#      ON ACTION object
#         LET g_action_choice ="object"
#         EXIT DISPLAY
       ON ACTION cancel
          LET g_action_choice= "exit"
          EXIT DISPLAY
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
 
END FUNCTION
 
FUNCTION i007_menu()
 
   WHILE TRUE
      CALL i007_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i007_a()
            END IF 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i007_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i007_r()
            END IF 
#         WHEN "invalid"
#            IF cl_chk_act_auth() THEN
#               CALL i007_x()
#            END IF 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i007_copy()
            END IF
         WHEN "modify"                                                                                                            
            IF cl_chk_act_auth() THEN                                                                                               
                 CALL i007_u()
            END IF
         WHEN "detail"
#            IF cl_chk_act_auth() THEN
               CALL i007_b()
#            ELSE
#               LET g_action_choice = "detail"
#            END IF 
#         WHEN "output"
#            IF cl_chk_act_auth() THEN
#               CALL i007_out()
#            END IF 
         WHEN "help"
            CALL SHOWHELP(1)
         WHEN "set" 
           IF g_wah.wah08 IS NULL THEN                                                                                                      
              CALL cl_err('','aws-104',1)                                                                                                        
              CALL i007_menu()
           ELSE                                                                                                                       
#                LET g_cmd = "awsi008"
#                CALL cl_cmdrun(g_cmd)
              LET g_cmd = "awsi008  '",g_wah.wah01,"' '",g_wah.wah02,"' '",g_wai[l_ac].wai05,"'"                              
              CALL cl_cmdrun(g_cmd) 
           END IF
#            EXIT DISPLAY
#        WHEN "object"
#           CALL i007_get_object()
            
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
    END WHILE
END FUNCTION
 
FUNCTION i007_cs()
    CLEAR FORM
    CALL g_wai.clear()
 
    CONSTRUCT BY NAME g_wc ON wah01,wah02,wah03,wah04,wah08,wah05,wah06,wah07,wah09
 
      ON ACTION controlp
         CASE 
            WHEN INFIELD(wah01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ='q_wag'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               IF NOT cl_null(g_qryparam.multiret) THEN
               DISPLAY g_qryparam.multiret TO wah01
               END IF
               NEXT FIELD wah01
            WHEN INFIELD(wah02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ='q_waa'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               IF NOT cl_null(g_qryparam.multiret) THEN
               DISPLAY g_qryparam.multiret TO wah02
               END IF
               NEXT FIELD wah02
            WHEN INFIELD(wah08)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ='q_wac'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               IF NOT cl_null(g_qryparam.multiret) THEN
               DISPLAY g_qryparam.multiret TO wah08
               END IF
               NEXT FIELD wah08
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN
       RETURN
    END IF
 
    #Begin:FUN-980030
    #    IF g_priv2 ='4' THEN
    #       LET g_wc = g_wc CLIPPED," AND pmwuser ='",g_user,"'"
    #    END IF 
 
    #    IF g_priv3 ='4' THEN
    #       LET g_wc = g_wc CLIPPED," AND wahgrup MATCHES'",g_grup CLIPPED,"*'"
    #    END IF 
 
    CONSTRUCT g_wc2 ON wai03,wai04,wai05,wai06,wai07,wai08,wai09,
                       wai10,wai11,wai12,wai13,wai14
                  FROM s_wai[1].wai03,s_wai[1].wai04,s_wai[1].wai05,s_wai[1].wai06,
                       s_wai[1].wai07,s_wai[1].wai08,s_wai[1].wai09,s_wai[1].wai10,s_wai[1].wai11,
                       s_wai[1].wai12,s_wai[1].wai13,s_wai[1].wai14
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
       ON ACTION controlp
          CASE
              WHEN INFIELD(wai04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ='q_wac3'
                 LET g_qryparam.arg1 = g_wah.wah02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 IF NOT cl_null(g_qryparam.multiret) THEN
                 DISPLAY g_qryparam.multiret TO wai04
                 END IF
                 NEXT FIELD wai04
          END CASE  
    END CONSTRUCT 
    
    IF INT_FLAG THEN
        RETURN
    END IF
 
    IF g_wc2 =" 1=1" THEN
       LET g_sql = "SELECT wah01, wah02 FROM wah_file ",   #FUN-A90024 add wah02
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY wah01"
    ELSE
       LET g_sql = "SELECT UNIQUE wah01, wah02 ",          #FUN-A90024 add wah02
                   " FROM wah_file,wai_file ",
                   " WHERE wah02 = wai03 ",
                   " AND wah01 = wai01 ",
                   " AND ",g_wc CLIPPED ," AND ",g_wc2 CLIPPED,
                   " ORDER BY wah01"
    END IF
 
    PREPARE i007_prepare FROM g_sql
    DECLARE i007_cs
        SCROLL CURSOR WITH HOLD FOR i007_prepare
 
    IF g_wc2 =" 1=1" THEN
       LET g_sql = "SELECT COUNT(*) FROM wah_file WHERE  ",g_wc CLIPPED
    ELSE
       LET g_sql = "SELECT COUNT(UNIQUE wah01) FROM wah_file,wai_file WHERE ",
                   " wah02 = wai03 AND wah01 = wai01 AND ",g_wc CLIPPED, " AND ", g_wc2 CLIPPED
    END IF 
    PREPARE i007_precount FROM g_sql
    DECLARE i007_count CURSOR FOR i007_precount
 
END FUNCTION
 
FUNCTION i007_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index,g_row_count )
   MESSAGE " "
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_wai.clear()
   DISPLAY ' ' TO FORMONLY.cnt
   
   CALL i007_cs()
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_wah.* TO NULL
   END IF 
 
   OPEN i007_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_wah.* TO NULL
   ELSE
      OPEN i007_count
      FETCH i007_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i007_fetch('F')
   END IF 
 
END FUNCTION
 
FUNCTION i007_fetch(p_flag)
   DEFINE   p_flag      LIKE type_file.chr1
   
   CASE p_flag
     WHEN 'N' FETCH NEXT      i007_cs INTO g_wah.wah01, g_wah.wah02   #FUN-A90024 add wah01
     WHEN 'P' FETCH PREVIOUS  i007_cs INTO g_wah.wah01, g_wah.wah02   #FUN-A90024 add wah01
     WHEN 'F' FETCH FIRST     i007_cs INTO g_wah.wah01, g_wah.wah02   #FUN-A90024 add wah01
     WHEN 'L' FETCH LAST      i007_cs INTO g_wah.wah01, g_wah.wah02   #FUN-A90024 add wah01
     WHEN '/' 
           IF (NOT g_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0
              PROMPT g_msg CLIPPED,':'FOR g_jump
                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()
              END PROMPT
              IF INT_FLAG THEN
                 LET INT_FLAG =0 
                 EXIT CASE
              END IF
              FETCH ABSOLUTE g_jump i007_cs INTO g_wah.wah01, g_wah.wah02   #FUN-A90024 add wah01
              LET g_no_ask = FALSE
            END IF 
   END CASE
   
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN
   ELSE
      CASE p_flag 
         WHEN 'F' LET g_curs_index =1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index,g_row_count )
   END IF
 
   SELECT * INTO g_wah.* FROM wah_file WHERE wah01 = g_wah.wah01 AND wah02 = g_wah.wah02
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_wah.wah01,SQLCA.sqlcode,0)
      INITIALIZE g_wah.* TO NULL
      RETURN
   END IF
 
   CALL i007_show()
 
END FUNCTION
 
FUNCTION i007_show()
   LET g_wah_t.* = g_wah.*
   LET g_wah_o.* = g_wah.*
   DISPLAY BY NAME g_wah.wah01,g_wah.wah08,g_wah.wah02,g_wah.wah03,g_wah.wah04,g_wah.wah05,g_wah.wah06,g_wah.wah07,g_wah.wah09 
 
   CALL i007_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i007_b_fill(p_wc2)
   DEFINE  
      # p_wc2       LIKE type_file.chr200
      p_wc2        STRING       #NO.FUN-910082
 
   LET g_sql = "SELECT wai03,wai04,gaq03,wai05,wai06,wai07,wai08,wai09,wai10,",
               " wai11,wai12,wai13,wai14 FROM wai_file,gaq_file ",
               " WHERE gaq01=wai04 AND gaq02='",g_lang,"' AND wai03 ='",g_wah.wah02,"'",
               " AND wai01 ='",g_wah.wah01,"'",
               " AND  ",p_wc2 CLIPPED,
               " ORDER BY wai04,wai03,wai09"
   PREPARE i007_pb FROM g_sql
   DECLARE wai_cs
       CURSOR FOR i007_pb
 
   CALL g_wai.clear()
   LET g_cnt = 1
 
   FOREACH wai_cs INTO g_wai[g_cnt].*
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF 
     LET g_cnt = g_cnt +1
     IF g_cnt > g_max_rec THEN
        CALL cl_err('',9035,0)
        EXIT FOREACH
     END IF 
   END FOREACH
   CALL g_wai.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i007_a()
 
   MESSAGE ""
   CLEAR FORM 
   CALL g_wai.clear()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_wah.* LIKE wah_file.*
   LET g_wah01_t = NULL
 
   LET g_wah_t.* = g_wah.*
   LET g_wah_o.* = g_wah.*
   LET g_wah.wah07 = "N" 
   LET g_wah.wah05 = "N"
   LET g_wah.wah06 = "N"
   LET g_wah.wah09 = "N"
   CALL cl_opmsg('a')
 
   WHILE TRUE
 
     CALL cl_set_comp_entry("wah03",FALSE )
     CALL i007_i('a')
 
     IF INT_FLAG THEN
        INITIALIZE g_wah.* TO NULL
        LET INT_FLAG = 0
        CALL cl_err('',9001,0)
        EXIT WHILE
     END IF
 
     IF cl_null(g_wah.wah01) THEN
        CONTINUE WHILE
     END IF
 
     BEGIN WORK
     
     INSERT INTO wah_file VALUES(g_wah.*)
 
     IF SQLCA.sqlcode THEN
        CALL cl_err(g_wah.wah01,SQLCA.sqlcode,1)      #FUN-B80064   ADD
        ROLLBACK WORK
       # CALL cl_err(g_wah.wah01,SQLCA.sqlcode,1)     #FUN-B80064   MARK
        CONTINUE WHILE
     ELSE
        COMMIT WORK
        CALL cl_flow_notify(g_wah.wah01,'I')
     END IF
 
     SELECT wah01 INTO g_wah.wah01 FROM wah_file
       WHERE wah01 = g_wah.wah01
          AND wah02 = g_wah.wah02
     LET g_wah01_t = g_wah.wah01
     LET g_wah_t.* = g_wah.*
     LET g_wah_o.* = g_wah.*
     CALL g_wai.clear()
     
     LET g_rec_b =0  
     CALL i007_b()
     EXIT WHILE
 
   END WHILE
END FUNCTION
 
FUNCTION i007_i(p_cmd)
   DEFINE  l_n       LIKE type_file.num5,
           p_cmd     LIKE type_file.chr1,
           l_count   LIKE type_file.num5,
           l_count1  LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_wah.wah01,g_wah.wah02,g_wah.wah03,g_wah.wah04,g_wah.wah08,g_wah.wah05,g_wah.wah06,g_wah.wah07,g_wah.wah09
 
   INPUT BY NAME g_wah.wah01,g_wah.wah02,g_wah.wah03,g_wah.wah04,g_wah.wah08,g_wah.wah05,g_wah.wah06,g_wah.wah07,g_wah.wah09
      WITHOUT DEFAULTS
    
     BEFORE INPUT
       LET g_before_input_done = FALSE
       CALL i007_set_entry(p_cmd)
       CALL i007_set_no_entry(p_cmd)
       LET g_before_input_done = TRUE
 
     AFTER FIELD wah01
        IF cl_null(g_wah.wah01) THEN                                                                                            
           CALL cl_err('','azz-310',0)
           NEXT FIELD wah01
        ELSE
           SELECT COUNT(*) INTO l_count FROM wag_file WHERE wag01 = g_wah.wah01 
           IF l_count = 0 THEN
              CALL cl_err(g_wah.wah01,'aws-189',0)
              NEXT FIELD wah01
           END IF
        END IF
 
     AFTER FIELD wah02
         IF NOT cl_null(g_wah.wah02) THEN
            SELECT COUNT(*) INTO l_count FROM waa_file WHERE waa01 = g_wah.wah02 
            IF l_count = 0 THEN
               CALL cl_err(g_wah.wah02,'aws-111',0)
               NEXT FIELD wah02
            END IF
            IF p_cmd='a' THEN
               LET g_wah.wah08=g_wah.wah02 
               SELECT waa03 INTO g_wah.wah03 FROM waa_file WHERE waa01=g_wah.wah02
               DISPLAY BY NAME g_wah.wah03                                                                                      
               DISPLAY BY NAME g_wah.wah08                                                                                      
               SELECT COUNT(*) INTO l_count FROM wah_file WHERE wah01 = g_wah.wah01 AND wah02 = g_wah.wah02
               IF l_count <> 0 THEN
                  CALL cl_err(g_wah.wah01,-239,0)
                  NEXT FIELD wah02
               END IF
            END IF
         ELSE 
            CALL cl_err('','azz-310',0)
            NEXT FIELD wah02
         END IF
 
     AFTER FIELD wah08
        IF cl_null(g_wah.wah08) THEN                                                                                            
           CALL cl_err('','azz-310',0)
           NEXT FIELD wah08
        ELSE 
           SELECT COUNT(*) INTO l_count1 FROM waa_file WHERE waa01 = g_wah.wah08 
           IF l_count1 = 0 THEN
              CALL cl_err(g_wah.wah08,'aws-111',0)
              NEXT FIELD wah08
           END IF  
        END IF 
 
     ON ACTION controlp
        CASE 
           WHEN INFIELD(wah01)
              CALL cl_init_qry_var()
              LET g_qryparam.state ='i'
              LET g_qryparam.form ="q_wag"
              LET g_qryparam.arg1 = g_lang CLIPPED
              CALL cl_create_qry() RETURNING g_wah.wah01
              IF NOT cl_null(g_wah.wah01) THEN
              DISPLAY BY NAME g_wah.wah01
              END IF
             #NEXT FIELD wah01
           WHEN INFIELD(wah02)
              CALL cl_init_qry_var()
              LET g_qryparam.state ='i'
              LET g_qryparam.form ="q_waa"
              LET g_qryparam.arg1 = g_lang CLIPPED
              CALL cl_create_qry() RETURNING g_wah.wah02
              IF NOT cl_null(g_wah.wah02) THEN
              DISPLAY BY NAME g_wah.wah02
              END IF
             #NEXT FIELD wah02
           WHEN INFIELD(wah08)
              CALL cl_init_qry_var()
              LET g_qryparam.state ='i'
              LET g_qryparam.form ="q_wac"
              LET g_qryparam.arg1 = g_lang CLIPPED
              CALL cl_create_qry() RETURNING g_wah.wah08
              IF NOT cl_null(g_wah.wah08) THEN
              DISPLAY BY NAME g_wah.wah08
              END IF
             #NEXT FIELD wah08
           OTHERWISE EXIT CASE
        END CASE
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
    
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
   END INPUT
 
END FUNCTION
 
FUNCTION i007_b()
   DEFINE    l_ac_t          LIKE type_file.num5,
             l_n             LIKE type_file.num5,
             l_cnt           LIKE type_file.num5,
             l_lock_sw       LIKE type_file.chr1,
             p_cmd           LIKE type_file.chr1,
             l_misc          LIKE type_file.chr4,
             l_allow_insert  LIKE type_file.num5,
             l_allow_delete  LIKE type_file.num5,
             i               LIKE type_file.num5,
             l_type          LIKE type_file.chr100, 
             l_len           LIKE type_file.num5,
             l_str           STRING,
             li_cnt2         STRING,
             li_bnt          STRING,
             l_str1          STRING,
             l_sql           STRING,
             l_col1          LIKE wai_file.wai04  
 
   LET g_action_choice =""
  
   IF s_shut(0) THEN
      RETURN
   END IF 
   
   IF g_wah.wah01 IS NULL THEN
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT wai03,wai04,gaq03,wai05,wai06,wai07,wai08,wai09,wai10,wai11,",
                      " wai12,wai13,wai14 FROM wai_file,gaq_file WHERE ",
                      " gaq01=wai04 AND gaq02='",g_lang,"'",
                      " AND wai01=? AND wai03 = ? AND wai05 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i007_bc1 CURSOR FROM g_forupd_sql
   
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   CALL cl_query_prt_temptable()     #No.FUN-A90024
 
   INPUT ARRAY g_wai WITHOUT DEFAULTS FROM s_wai.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW =l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
  
   BEFORE INPUT 
      IF g_rec_b !=0 THEN
         CALL fgl_set_arr_curr(l_ac)
      END IF 
      CALL cl_set_comp_entry("wai03",FALSE )
      CALL cl_set_comp_entry("wai08",FALSE )
 
   BEFORE ROW
      LET p_cmd = ''
      LET l_ac = ARR_CURR()
      LET l_lock_sw ='N'
      LET l_n = ARR_COUNT()
 
      BEGIN WORK
 
      OPEN i007_c1 USING g_wah.wah01,g_wah.wah02
      IF STATUS THEN
         CALL cl_err("OPEN i007_c1:",STATUS,1)
         CLOSE i007_c1
         ROLLBACK WORK
         RETURN
      END IF
 
      FETCH i007_c1 INTO g_wah.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_wah.wah01,SQLCA.sqlcode,0)
         CLOSE i007_c1
         ROLLBACK WORK
         RETURN
      END IF
 
      IF g_rec_b>=l_ac THEN
         LET p_cmd ='u'
         LET g_wai_t.* = g_wai[l_ac].*
         LET g_wai_o.* = g_wai[l_ac].*
       #  OPEN i007_bc1 USING g_wai_t.wai03,g_wai_t.wai04 
         OPEN i007_bc1 USING g_wah.wah01,g_wai_t.wai03,g_wai_t.wai05 
         IF STATUS THEN
            CALL cl_err("OPEN i007_bc1:",STATUS,1)
            LET l_lock_sw ="Y"
         ELSE
            FETCH i007_bc1 INTO g_wai[l_ac].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_wai_t.wai03,SQLCA.sqlcode,1)
               LET l_lock_sw ="Y"
            END IF
         END IF
      END IF
         
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_wai[l_ac].* TO NULL
         LET g_wai[l_ac].wai03 = g_wah.wah02
         LET g_wai[l_ac].wai07 = "C"
         LET g_wai[l_ac].wai09 = "N"
         LET g_wai[l_ac].wai10 = "N"
         NEXT FIELD wai04
         
      AFTER INSERT
         FOR i = 1 TO g_row_count
            IF g_wai[i].wai09 = "Y" AND cl_null(g_wai[i].wai04) THEN
               CALL cl_err("",'aws-105',0)
               RETURN g_wai[i].wai04
            END IF
         END FOR  
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG =0
            CANCEL INSERT
         END IF
         INSERT INTO wai_file
         VALUES(g_wah.wah01,g_wah.wah08,g_wai[l_ac].wai03,g_wai[l_ac].wai04,g_wai[l_ac].wai05,
                g_wai[l_ac].wai06,g_wai[l_ac].wai07,g_wai[l_ac].wai08,g_wai[l_ac].wai09,
                g_wai[l_ac].wai10,g_wai[l_ac].wai11,g_wai[l_ac].wai12,g_wai[l_ac].wai13,
                g_wai[l_ac].wai14)
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_wai[l_ac].wai03,SQLCA.sqlcode,0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF 
  
      AFTER FIELD wai04 
        IF NOT cl_null(g_wai[l_ac].wai04) THEN
          SELECT COUNT(*) INTO l_n FROM wac_file WHERE wac01 = g_wai[l_ac].wai03 AND wac03=g_wai[l_ac].wai04
          IF l_n = 0 THEN
             CALL cl_err(g_wai[l_ac].wai04,'aws-122',0)
             NEXT FIELD wai04
          END IF
          IF l_n > 1 THEN
             CALL cl_err("wac_file.wac03='"||g_wai[l_ac].wai04||"'",-239,0)
             NEXT FIELD wai04
          END IF
          IF l_n = 1 THEN
             IF p_cmd ='a' THEN
                SELECT wac04,wac05 INTO g_wai[l_ac].wai05,g_wai[l_ac].wai06 FROM wac_file WHERE wac01 = g_wai[l_ac].wai03 AND wac03=g_wai[l_ac].wai04
             END IF
             SELECT gaq03 INTO g_wai[l_ac].gaq03 FROM gaq_file WHERE gaq01 = g_wai[l_ac].wai04 AND gaq02=g_lang
          END IF
          LET l_str1 = g_wai[l_ac].wai04 
          #LET l_str1 = l_str1.toUpperCase()   #FUN-A90024 mark
          LET l_col1 = l_str1 
          #---FUN-A90024---start-----
          #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
          #目前統一用sch_file紀錄TIPTOP資料結構
          #SELECT data_type,data_length INTO l_type,l_len FROM user_tab_columns WHERE column_name=l_col1
          #IF l_type ="VARCHAR2" THEN
          #   LET g_wai[l_ac].wai07 = "C" 
          #   LET g_wai[l_ac].wai08 = l_len 
          #END IF   
          #IF l_type ="DATE"  THEN
          #   LET g_wai[l_ac].wai07 = "D" 
          #   LET g_wai[l_ac].wai08 = 8
          #END IF
          #IF l_type ="NUMBER" THEN
          #   LET g_wai[l_ac].wai07 = "N" 
          #   LET g_wai[l_ac].wai08 = l_len 
          #END IF
          
          CALL cl_query_prt_getlength(l_col1, 'N', 's', 0)
          SELECT xabc06, xabc04 INTO l_type, l_len FROM xabc 
            WHERE xabc02 = l_col1
          CASE 
               WHEN l_type = 'char' OR l_type = 'varchar' OR l_type = 'varchar2' 
                    LET g_wai[l_ac].wai07 = "C" 
                    LET g_wai[l_ac].wai08 = l_len 
                    
               WHEN l_type = 'nvarchar' OR l_type = 'nvarchar2'
                    LET g_wai[l_ac].wai07 = "C" 
                    LET g_wai[l_ac].wai08 = l_len 

               WHEN l_type = 'smallint' OR l_type = 'integer'
                    LET g_wai[l_ac].wai07 = "N" 
                    LET g_wai[l_ac].wai08 = l_len 

               WHEN l_type = 'number' OR l_type = 'decimal'
                    LET g_wai[l_ac].wai07 = "N" 
                    LET g_wai[l_ac].wai08 = l_len 

               WHEN l_type = 'date'
                    LET g_wai[l_ac].wai07 = "D" 
                    LET g_wai[l_ac].wai08 = 8
          END CASE
          #---FUN-A90024---end------- 
          DISPLAY BY NAME g_wai[l_ac].gaq03
          DISPLAY BY NAME g_wai[l_ac].wai05
          DISPLAY BY NAME g_wai[l_ac].wai06
          DISPLAY BY NAME g_wai[l_ac].wai07
          DISPLAY BY NAME g_wai[l_ac].wai08
        END IF   
 
      AFTER FIELD wai07
        IF g_wai[l_ac].wai07 = "D" THEN
           LET g_wai[l_ac].wai08 = "8"
        END IF 
 
      AFTER FIELD wai09 
        IF NOT cl_null(g_wai[l_ac].wai04) AND NOT cl_null(g_wai[l_ac].wai08) THEN
          #---FUN-A90024---start-----
          #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
          #目前統一用sch_file紀錄TIPTOP資料結構
          CALL cl_query_prt_getlength(l_col1, 'N', 's', 0)
          SELECT xabc06 INTO l_type FROM xabc 
            WHERE xabc02 = l_col1
          #---FUN-A90024---end-------  
          #IF l_type ="VARCHAR2" THEN   #FUN-A90024 mark
          IF l_type = 'char' OR l_type = 'varchar' OR l_type = 'varchar2' OR 
             l_type = 'nvarchar' OR l_type = 'nvarchar2' THEN                   #FUN-A90024
             IF g_wai[l_ac].wai07 <>"C" THEN
                CALL cl_err("",'aws-106',1)
             END IF 
          END IF   
          #IF l_type ="DATE"  THEN   #FUN-A90024 mark
          IF l_type ="date"  THEN   #FUN-A90024
             IF g_wai[l_ac].wai07 <> "D" THEN
                CALL cl_err("",'aws-106',1)
             END IF  
          END IF
          #IF l_type ="NUMBER" THEN   #FUN-A90024 mark
          IF l_type = 'smallint' OR l_type = 'integer' OR
             l_type = 'number' OR l_type = 'decimal' THEN                #FUN-A90024
             IF g_wai[l_ac].wai07<>"I" OR g_wai[l_ac].wai07 <>"N" THEN  
                CALL cl_err("",'aws-106',1)
             END IF
          END IF
          IF g_wai[l_ac].wai07="D" THEN
             IF l_len <> (g_wai[l_ac].wai08-1) THEN
                IF cl_null(l_str) THEN
                   LET l_str = g_wai[l_ac].wai04
                ELSE 
                   LET l_str = l_str,",",g_wai[l_ac].wai04
                END IF
             END IF 
          ELSE
             IF l_len <> g_wai[l_ac].wai08 THEN
                IF cl_null(l_str) THEN
                   LET l_str = g_wai[l_ac].wai04
                ELSE 
                   LET l_str = l_str,",",g_wai[l_ac].wai04
                END IF
             END IF 
          END IF   
        END IF   
  
      BEFORE DELETE 
        IF  g_wai_t.wai03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw ="Y" THEN
               CALL cl_err("",-236,1)
               CANCEL DELETE 
            END IF 
            DELETE FROM wai_file
             WHERE wai01 = g_wah.wah01
               AND wai03 = g_wai[l_ac].wai03
               AND wai05 = g_wai[l_ac].wai05
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_wai_t.wai03,SQLCA.sqlcode,0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            COMMIT WORK
         END IF 
 
      ON ROW CHANGE
#                      ON ACTION cancel                                                                                                    
#                         EXIT MENU                                                                                                           
#                      END MENU          
    
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG =0
            LET g_wai[l_ac].* = g_wai_t.*
            CLOSE i007_bc1
            ROLLBACK WORK
         END IF
         IF l_lock_sw='Y' THEN
            CALL cl_err(g_wai[l_ac].wai03,-263,1)
            LET g_wai[l_ac].* = g_wai_t.*
         ELSE
            UPDATE wai_file SET
                                wai03 = g_wai[l_ac].wai03,      
                                wai04 = g_wai[l_ac].wai04,      
                                wai05 = g_wai[l_ac].wai05,      
                                wai06 = g_wai[l_ac].wai06,      
                                wai07 = g_wai[l_ac].wai07,      
                                wai08 = g_wai[l_ac].wai08,      
                                wai09 = g_wai[l_ac].wai09,      
                                wai10 = g_wai[l_ac].wai10,      
                                wai11 = g_wai[l_ac].wai11,      
                                wai12 = g_wai[l_ac].wai12,      
                                wai13 = g_wai[l_ac].wai13,      
                                wai14 = g_wai[l_ac].wai14      
#                                wai15 = g_wai[l_ac].wai15,      
#                                wai16 = g_wai[l_ac].wai16,      
#                                wai17 = g_wai[l_ac].wai17,      
#                                wai18 = g_wai[l_ac].wai18      
              WHERE wai05 =g_wai_t.wai05
                AND wai01 =g_wah.wah01
                AND wai03 =g_wai_t.wai03
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err(g_wai[l_ac].wai03,SQLCA.sqlcode,0)
               LET g_wai[l_ac].* = g_wai_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
#               COMMIT WORK
            END IF
         END IF
  
      AFTER ROW
         LET l_ac =ARR_CURR()
         LET l_ac_t =l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd ='u' THEN
               LET g_wai[l_ac].* = g_wai_t.*
            END IF
            CLOSE i007_bc1
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i007_bc1
         COMMIT WORK
 
#      ON ACTION CONTROLN
#         CALL i007_b_askkey()
#         EXIT INPUT
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
     ON ACTION controlp
        CASE 
           WHEN INFIELD(wai04)
              CALL cl_init_qry_var()
              LET g_qryparam.state ='i'
              LET g_qryparam.form ="q_wac3"
              LET g_qryparam.arg1 = g_wah.wah02
              LET g_wai_t.wai04=g_wai[l_ac].wai04
              CALL cl_create_qry() RETURNING g_wai[l_ac].wai04
              IF NOT cl_null(g_wai[l_ac].wai04) THEN
                 DISPLAY BY NAME g_wai[l_ac].wai04
              ELSE
                 LET g_wai[l_ac].wai04=g_wai_t.wai04
                 DISPLAY BY NAME g_wai[l_ac].wai04
              END IF
              NEXT FIELD wai04
        
#           WHEN INFIELD(wai18)
#              CALL cl_init_qry_var()
#              LET g_qryparam.state ='i'
#              LET g_qryparam.form ="q_wac3"
#              LET g_qryparam.arg1 = g_wah.wah08
#              LET g_qryparam.arg2 = g_wai[l_ac].wai17
#              CALL cl_create_qry() RETURNING g_wai[l_ac].wai18
#              DISPLAY BY NAME g_wai[l_ac].wai18
#              NEXT FIELD wai18
 
           OTHERWISE EXIT CASE
        END CASE
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
   
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION CONTROLO
          IF INFIELD(wai04) AND l_ac > 1 THEN
             LET g_wai[l_ac].* = g_wai[l_ac-1].*
             NEXT FIELD wai04
          END IF
 
    
   END INPUT
#         FOR i =1 TO g_row_count  
#          IF g_wai[i].wai09 ="Y" AND cl_null(g_wai[i].wai04) THEN
#             CALL cl_err("",'aws-105',1)
#             NEXT FIELD wai04
#          END IF
#          LET i =i+1
#         END FOR  
      IF NOT cl_null(l_str) THEN    
         CALL cl_getmsg('aws-107',g_lang) RETURNING li_cnt2       
                    LET l_str = li_cnt2,l_str                                                          
                    MENU li_bnt ATTRIBUTE(STYLE ="dialog",COMMENT=l_str CLIPPED,IMAGE="information")                               
                      ON ACTION accept                                                                                              
                        EXIT MENU                                                                                                   
                      END MENU  
      END IF                                                                                                       
 
   CLOSE i007_bc1
#   COMMIT WORK
   CALL i007_delall()
 
END FUNCTION
 
FUNCTION i007_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM wai_file
    WHERE wai01 = g_wah.wah01
         AND wai03 = g_wah.wah02
 
   IF g_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM wah_file WHERE wah01 = g_wah.wah01
        AND wah02 = g_wah.wah02 
   END IF
 
END FUNCTION
 
FUNCTION i007_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_wah.wah01 IS NULL THEN
      CALL cl_err('',400,0)
      RETURN
   END IF
 
   SELECT * INTO g_wah.* FROM wah_file
    WHERE wah01=g_wah.wah01
      AND wah02=g_wah.wah02
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_wah01_t = g_wah.wah01
   BEGIN WORK
 
   OPEN i007_c1 USING g_wah.wah01,g_wah.wah02
   IF STATUS THEN
      CALL cl_err("OPEN i007_c1:",STATUS,1)
      CLOSE i007_c1
      ROLLBACK WORK
      RETURN
   END IF
  
   FETCH i007_c1 INTO g_wah.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_wah.wah01,SQLCA.sqlcode,0)
       CLOSE i007_c1
       ROLLBACK WORK
       RETURN
   END IF
   
   CALL i007_show()
 
   WHILE TRUE
     LET g_wah01_t = g_wah.wah01
     LET g_wah_o.* = g_wah.*
     CALL cl_set_comp_entry("wah02",FALSE )
     
     CALL i007_i("u")
 
     CALL cl_set_comp_entry("wah02",TRUE )
     IF INT_FLAG THEN        
        LET INT_FLAG = 0
        LET g_wah.* = g_wah_t.*
        CALL i007_show()
#        CALL cl_err('',900,0)
        EXIT WHILE
     END IF
 
     IF g_wah.wah01 != g_wah01_t THEN
        UPDATE wai_file SET wai01 = g_wah.wah01
         WHERE wai01 = g_wah01_t
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err('wai',SQLCA.sqlcode,0)
           CONTINUE WHILE
        END IF
     END IF
 
     UPDATE wah_file SET wah_file.* = g_wah.*
      WHERE wah01 = g_wah.wah01 AND wah02 = g_wah.wah02
 
     UPDATE wai_file SET wai02 = g_wah.wah08
      WHERE wai01 = g_wah.wah01
       AND  wai03 = g_wah.wah02 
 
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err(g_wah.wah01,SQLCA.sqlcode,0)
        CONTINUE WHILE
     END IF
     EXIT WHILE  
   END WHILE
  
   CLOSE i007_c1
   COMMIT WORK
   CALL cl_flow_notify(g_wah.wah01,'U')
 
END FUNCTION
 
FUNCTION i007_copy()
   DEFINE   l_newno     LIKE wah_file.wah01,
            l_newno2    LIKE wah_file.wah02,
            l_newno_t   LIKE wah_file.wah02,
            l_newno2_t  LIKE wah_file.wah02,
            l_n         LIKE type_file.num5,
            l_oldno     LIKE wah_file.wah01
 
   IF s_shut(0) THEN RETURN END IF
   IF g_wah.wah01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE 
   CALL i007_set_entry('a')
  
   INPUT l_newno,l_newno2 FROM wah01,wah02
 
      BEFORE INPUT
         LET l_newno =g_wah.wah01
         LET l_newno2=g_wah.wah02
         DISPLAY l_newno TO wah01
         DISPLAY l_newno2 TO wah02
 
      BEFORE FIELD wah01
         LET l_newno_t =l_newno
      BEFORE FIELD wah02
         LET l_newno2_t =l_newno2
 
      AFTER FIELD wah01
         LET l_n=0 
         SELECT count(*) INTO l_n FROM wag_file
          WHERE wag01 = l_newno 
         IF l_n = 0 THEN
            CALL cl_err(l_newno,'aws-189',0)
            NEXT FIELD wah01
         END IF
 
      AFTER FIELD wah02
         LET l_n=0 
         SELECT count(*) INTO l_n FROM waa_file
          WHERE waa01 = l_newno2
         IF l_n = 0 THEN
            CALL cl_err(l_newno2,'aws-111',0)
            NEXT FIELD wah02
         END IF
         LET l_n=0 
         SELECT count(*) INTO l_n FROM wah_file
          WHERE wah01 = l_newno AND wah02=l_newno2
         IF l_n > 0 THEN
            CALL cl_err('',-239,0)
            NEXT FIELD wah02
         END IF
 
      ON ACTION controlp
         CASE 
           WHEN INFIELD(wah01)
              CALL cl_init_qry_var()
              LET g_qryparam.state ='i'
              LET g_qryparam.form ="q_wag"
              LET g_qryparam.arg1 = g_lang CLIPPED
              CALL cl_create_qry() RETURNING l_newno
              IF NOT cl_null(l_newno) THEN
                 DISPLAY l_newno TO wah01
              ELSE
                 LET l_newno=l_newno_t
                 DISPLAY l_newno TO wah01
              END IF
              NEXT FIELD wah01
           WHEN INFIELD(wah02)
              CALL cl_init_qry_var()
              LET g_qryparam.state ='i'
              LET g_qryparam.form ="q_waa"
              LET g_qryparam.arg1 = g_lang CLIPPED
              CALL cl_create_qry() RETURNING l_newno2
              IF NOT cl_null(l_newno2) THEN
                 DISPLAY l_newno2 TO wah02
              ELSE
                 LET l_newno2=l_newno2_t
                 DISPLAY l_newno2 TO wah02
              END IF
              NEXT FIELD wah02
           OTHERWISE EXIT CASE
         END CASE
 
      BEGIN WORK
     
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_wah.wah01 TO wah01
      DISPLAY g_wah.wah02 TO wah02
      RETURN
   END IF
  
   DROP TABLE y
    
   SELECT * FROM wah_file
       WHERE wah01 = g_wah.wah01
         AND wah02 = g_wah.wah02
       INTO TEMP y
 
   UPDATE y 
       SET wah01 = l_newno,
           wah02 = l_newno2
 
   INSERT INTO wah_file
       SELECT * FROM y
 
   DROP TABLE x
   
   SELECT * FROM wai_file
       WHERE wai01 = g_wah.wah01
         AND wai02 = g_wah.wah08
         AND wai03 = g_wah.wah02
        INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_wah.wah01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   UPDATE x
       SET wai01 = l_newno,
           wai03 = l_newno2
 
   INSERT INTO wai_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
     
      CALL cl_err(g_wah.wah01,SQLCA.sqlcode,0)         #FUN-B80064    ADD
      ROLLBACK WORK
     # CALL cl_err(g_wah.wah01,SQLCA.sqlcode,0)        #FUN-B80064    MARK
      RETURN
   ELSE 
      COMMIT WORK
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',')ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_wah.wah01
   SELECT wah_file.* INTO g_wah.* FROM wah_file 
    WHERE wah01=l_newno AND wah02=l_newno2
   CALL i007_show()
   CALL i007_u()
   CALL i007_b()
 
   CALL i007_show()
 
END FUNCTION
 
FUNCTION i007_r()
 
  DEFINE mi_row_count     LIKE type_file.num5,
         mi_jump          LIKE type_file.num5,
         mi_curs_index    LIKE type_file.num5,
         mi_no_ask        LIKE type_file.num5
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_wah.wah01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
#   SELECT * INTO g_wah.* FROM wah_file
#    WHERE wah01 = g_wah.wah01
   BEGIN WORK
 
#   OPEN i007_c1 USING g_wah.wah01,g_wah.wah02
#   IF STATUS THEN
#      CALL cl_err("OPEN i007_c1:",STATUS,1)
#      CLOSE i007_c1
#      ROLLBACK WORK
#      RETURN
#   END IF
 
   CALL i007_show()
 
   IF cl_delh(0,0) THEN
      DELETE FROM wah_file WHERE wah01 = g_wah.wah01 AND wah02 =g_wah.wah02
      DELETE FROM wai_file WHERE wai01 = g_wah.wah01 AND wai03 =g_wah.wah02 
      CLEAR FORM 
      CALL g_wai.clear()
      OPEN i007_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i007_cs
         CLOSE i007_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i007_count INTO mi_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i007_cs
         CLOSE i007_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end--
      DISPLAY mi_row_count TO FORMONLY.cnt
      OPEN i007_cs
#      IF mi_curs_index = mi_row_count + 1 THEN
#         LET mi_jump = mi_row_count
         CALL i007_fetch('L')
#      ELSE
#         LET mi_jump = mi_curs_index
#         LET mi_no_ask = TRUE
#         CALL i007_fetch('/')
#      END IF
    END IF
    
    CLOSE i007_c1
    COMMIT WORK
    CALL cl_flow_notify(g_wah.wah01,'D')
END FUNCTION
 
FUNCTION i007_set_no_entry(p_cmd)
   DEFINE    p_cmd      LIKE type_file.chr10
 
   IF p_cmd ='u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("wah01,wah02",FALSE)
   END IF
 
END FUNCTION 
 
FUNCTION i007_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                        
                                                                                                                                    
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                             
      CALL cl_set_comp_entry("wah01,wah02",TRUE)                                                                                          
    END IF                                                                                                                          
                                                                                                                                    
END FUNCTION        
 
FUNCTION i007_get_object()
 
   DEFINE l_output          STRING,
          l_soapStatus      LIKE type_file.num5,
          l_array           ARRAY[11] OF LIKE type_file.chr300,
          l_v_d             ARRAY[2] OF LIKE type_file.chr200,
          l_str_buf         base.StringBuffer,
          l_str_buf1        base.StringBuffer,
          l_str_buf2        base.StringBuffer,
          l_start           LIKE type_file.num5,
          l_start1          LIKE type_file.num5,
          l_end             LIKE type_file.num5,
          lc_sub            STRING,
          lc_sub1,lc_sub2   STRING,
          l_last            LIKE type_file.num5,
          l_line,i,r,t,h,n,j,a LIKE type_file.num5,
          tok               base.StringTokenizer,
          l_tok             base.StringTokenizer,
          l_tok_value       base.StringTokenizer,
          l_tok_values      base.StringTokenizer,
          l_status          LIKE type_file.num5,
          l_channel         base.Channel,
          doc         om.DomDocument,
          nRoot       om.DomNode,
          LstNode     om.NodeList,
          l_Node      om.DomNode,
          l_Node1     om.DomNode,
          l_path      STRING,
          l_test      STRING,
          l_desc,l_ins,l_edit,l_del                  STRING,
          l_name1,l_desc1,l_type1,l_test8,l_id          STRING,
          l_sql,l_sql1,l_sql2,l_sql3                      STRING,
          l_count                 LIKE type_file.num5,
          li_bnt                  LIKE ze_file.ze03,
          l_i                     LIKE type_file.chr1,
          li_cnt                  STRING,
          li_cnt1,li_cnt2          STRING,
          l_c                     LIKE wah_file.wah01,
          l_name                  LIKE wah_file.wah03,
          l_child                 STRING,
          l_id1                   LIKE wah_file.wah02,
          l_value                 STRING,
          l_count1                LIKE type_file.num5,
          l_soapdesc              STRING,
          l_xml                   STRING
 
      OPEN WINDOW get_object  WITH FORM "aws/42f/aws_item"
      ATTRIBUTE(STYLE ='sm1')
    
      CALL cl_ui_locale("aws_item")
      INPUT l_c WITHOUT DEFAULTS FROM FORMONLY.c
      ON ACTION controlp
          CASE WHEN INFIELD(c)
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'i'
              LET g_qryparam.form = "q_wag"
              CALL cl_create_qry() RETURNING l_c
              NEXT FIELD FORMONLY.c
           END CASE         
         
      END INPUT
      LET l_xml ='<STD_IN Origin="TIPTOP"><Service Name="GetObjectList"/></STD_IN>'
#      CALL IntegrationExec(l_xml) RETURNING l_soapStatus,l_output   
#      CALL aws_GetObjectList(l_c) RETURNING l_soapStatus,l_output
 
      LET l_str_buf = base.StringBuffer.create()    
      CALL l_str_buf.append(l_output) 
   
      LET l_end = l_str_buf.getIndexOf('|',l_start+1)                                                                  
      LET lc_sub = l_str_buf.SubString(1,l_end-1)  
   
      LET l_str_buf1 = base.StringBuffer.create() 
      CALL l_str_buf1.append(lc_sub)
      LET l_start1 = l_str_buf1.getIndexOf('>',1)
 
      WHILE l_start1 <>"0" 
         LET l_start1 = l_str_buf1.getIndexOf('>',l_start1+1)
         IF l_start1<>"0" THEN
            LET lc_sub1 =l_str_buf.SubString(l_start1+1,l_end-1)
            LET l_last = l_str_buf.getIndexOf('<',l_start1+1)
         END IF
      END WHILE
  
      LET tm[1].a = "N" 
      LET tm[1].b = lc_sub1
 
      LET l_line = l_str_buf.getIndexOf('|',1) 
      LET lc_sub2 = l_str_buf.SubString(l_line,l_last-1)
      LET tok = base.StringTokenizer.create(lc_sub2,"|")
      LET l_ac = 2 
      WHILE tok.hasMoreTokens()
          LET tm[l_ac].b = tok.nextToken()
          LET tm[l_ac].a = "N"
          LET l_ac =l_ac+1
      END WHILE 
      CALL tm.deleteElement(l_ac)
   
      IF INT_FLAG THEN
         initialize tm[l_ac].* to null 
      END IF   
      INPUT ARRAY tm WITHOUT DEFAULTS FROM s_aws.*                                                                                  
         ATTRIBUTE(COUNT =g_rec_b,UNBUFFERED,                                                                                       
                   INSERT ROW = FALSE,                                                                                              
                   DELETE ROW = FALSE,                                                                                              
                   APPEND ROW = FALSE)  
      IF INT_FLAG THEN
         CLOSE WINDOW get_object 
         CALL tm.clear()  
         RETURN       
      END IF 
       FOR h = 1 TO l_ac
       IF  tm[h].a= "Y" THEN
          LET l_output = ""
      LET l_xml='<STD_IN Origin="TIPTOP"><Service Name="GetTemplate"><ObjectID>ItemRelation</ObjectID></Service></STD_IN>'              
#           CALL aws_GetTemplate(l_c,tm[h].b) RETURNING l_soapStatus,l_output
#       CALL IntegrationExec(l_xml) RETURNING l_soapStatus,l_output           
#    LET l_output ='<STD_OUT Origin="TIPTOP">',
#                    '<Service Name="GetTemplate">',
#                      '<Status>0</Status>',
#                 	'<Object ID="abc" Name="BOM" Desc="產品結構" Insert="Y" Edit="N" Delete="N" IsMultiChild="N">',
#	                  '<Property>Item No|主件編號|C|30|Y|BOM主料件編號|N|||Y:是,N:否,H:阿|</Property>',
#		          '<Property>Quantity|說明信息|N|5|Y|單位使用數量|Y||||</Property>',
#	                 '</Object>',
#	             '</Service>',
#                  '</STD_OUT>'
#        LET l_channel = base.Channel.create()
        LET l_path = FGL_GETENV("TEMPDIR"),"/template.xml"
#        CALL l_channel.openFile(l_path,"w")
#        CALL l_channel.write(l_output)
#        CALL l_channel.close()
 
         
        LET doc = om.DomDocument.createFromXmlFile(l_path)
        LET nRoot = doc.getDocumentElement()
 
        LET lstNode = nRoot.selectByTagName("Object")
        FOR i = 1 TO LstNode.getLength()
          LET l_Node = LstNode.item(1)
          LET l_id= l_Node.getAttribute("ID")
          LET l_test = l_Node.getAttribute("Name")
	  LET l_desc = l_Node.getAttribute("Desc")
          LET l_ins = l_Node.getAttribute("Insert")
          LET l_edit = l_Node.getAttribute("Edit")
          LET l_del = l_Node.getAttribute("Delete")
#          LET l_child = l_Node.getAttribute("IsMultiChild")
          LET l_id1 = l_id
          SELECT COUNT(*) INTO l_count FROM wah_file 
                WHERE wah02 =l_id1 
          #PREPARE l_cou FROM l_sql
          #EXECUTE l_cou
          IF l_count ="1" THEN
              CALL cl_getmsg('aws-100',g_lang) RETURNING li_cnt1
              LET l_i = FALSE
              LET li_cnt = l_id1,li_cnt1
              MENU li_bnt ATTRIBUTE (STYLE="dialog",COMMENT=li_cnt CLIPPED,IMAGE="information")
                ON ACTION accept
                   BEGIN WORK   
                    LET l_sql1 =" DELETE FROM wah_file WHERE wah02 ='",l_id1,"'" 
                    PREPARE l_delete FROM l_sql1
                    EXECUTE l_delete 
                    LET l_sql2 = " INSERT INTO wah_file(wah01,wah02,wah03,wah04,wah05,wah06,wah07,wah09) ",
                       " VALUES ('",l_c,"',","'",l_id,"',","'",l_name,"',","'",l_desc,"',",
                         "'",l_ins,"',","'",l_edit,"',","'",l_del,"','N')"
                    PREPARE l_ins  FROM l_sql2
                    EXECUTE l_ins
                    IF SQLCA.sqlcode THEN
                       CALL cl_err("",SQLCA.sqlcode,0)
                       ROLLBACK WORK
                    ELSE
                       COMMIT WORK
#                    CALL cl_getmsg('aws-105',g_lang) RETURNING li_cnt2
#                    LET li_cnt = l_id,li_cnt2
#                    MENU li_bnt ATTRIBUTE(STYLE ="dialog",COMMENT=li_cnt CLIPPED,IMAGE="information")
#                      ON ACTION accept
#                        EXIT MENU
#                    END MENU
#                    ELSE 
#                       COMMIT WORK
                    END IF
                EXIT MENU
                 
                ON ACTION cancel
                EXIT MENU
              END MENU
            ELSE
              LET l_sql2 = " INSERT INTO wah_file(wah01,wah02,wah03,wah04,wah05,wah06,wah07,wah09) ",                         
                       " VALUES ('",l_c,"',","'",l_id,"',","'",l_name,"',","'",l_desc,"',",                                     
                         "'",l_ins,"',","'",l_edit,"',","'",l_del,"','N')"  
              PREPARE l_ins2 FROM l_sql2
              EXECUTE l_ins2
            END IF   
        END FOR 
 
        LET lstNode = nRoot.selectByTagName("Object")
        FOR j = 1 TO LstNode.getLength()
           LET l_name1 = ""
           LET l_desc1 = ""
           LET l_type1 = ""
           LET l_Node = LstNode.item(j)
#           LET l_name1 = l_Node.getAttribute("Name")
#           LET l_desc1= l_Node.getAttribute("Desc")
#           LET l_type1= l_Node.getAttribute("Type")
           FOR r = 1 TO l_Node.getChildCount()
               LET l_Node1 =l_Node.getChildByIndex(r)
               LET l_Node1 =l_Node1.getFirstChild()
               LET l_test8 = l_Node1.getAttributeValue(1)
 
               LET l_tok = base.StringTokenizer.createExt(l_test8,"|","",TRUE)                                                                            
               LET t = 1  
               FOR n = 1 TO 11	                                                                                                               
                  LET l_array[n] = " "   
                  LET n=n+1
               END FOR                                                                                                  
               WHILE l_tok.hasMoreTokens() 
                  LET l_array[t] = l_tok.nextToken()
                  LET t =t+1                                                                                                          
               END WHILE
                FOR i = 1 TO 11 
                   IF cl_null(l_array[i]) THEN
                       LET l_array[i] = " "
                   END IF
                END FOR
 
                IF l_array[3] = "D" THEN
                   LET l_array[4] ="8"
                END IF 
 
                IF NOT cl_null(l_array[10]) THEN 
                   LET l_tok_value = base.StringTokenizer.create(l_array[10],",")
                   WHILE l_tok_value.hasMoreTokens()                                                                                                     
                      LET l_value = l_tok_value.nextToken()
                      LET l_tok_values = base.StringTokenizer.create(l_value,":")
                      LET a = 1
                      WHILE l_tok_values.hasMoreTokens()
                        LET l_v_d[a] = l_tok_values.nextToken()
                        LET a = a+1
                      END WHILE
                      SELECT COUNT(*) INTO l_count1 FROM waj_file where waj01 = l_c 
                        AND waj02 = l_id1 AND waj04 = l_array[2] AND waj05 =l_v_d[1]
                          AND waj06 = l_v_d[2]
                      IF l_count1 = 0 THEN 
                        LET l_sql3=" INSERT INTO waj_file(waj01,waj02,waj04,waj05,waj06,waj07) ", 
                                   " VALUES('",l_c,"','",l_id,"','",l_array[2],"','",l_v_d[1],"','",l_v_d[2],"','tiptop')"          
                        PREPARE l_insert FROM l_sql3
                        EXECUTE l_insert
                      END IF
#                       IF SQLCA.sqlcode THEN
#                          CONTIUE WHILE
#                       END IF                                                         
                    END WHILE 
                END IF
                   LET l_sql = " INSERT INTO wai_file(wai01,wai03,wai05,wai06,wai07,wai08, ",                        
                                " wai09,wai10,wai11,wai12,wai13,wai14) ",                                               
                                " VALUES ('",l_c,"','",l_id,"','",l_array[1],"','",l_array[2],"',",                                
                                "'",l_array[3],"','",l_array[4],"','",l_array[5],"','",l_array[7],"',",                             
                                "'",l_array[6],"','",l_array[8],"','",l_array[9],"','",l_array[11],"')"                             
                      PREPARE l_ins3 FROM l_sql                                                                                     
                      EXECUTE l_ins3
 #                 END IF
                  
            END FOR
         END FOR
        END IF
       END FOR
#      CALL tm.clear()  
      CLOSE WINDOW get_object 
      CALL tm.clear()  
 
END FUNCTION
#No.FUN-8A0122
