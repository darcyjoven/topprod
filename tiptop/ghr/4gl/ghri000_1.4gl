# Prog. Version..: '5.30.03-12.09.18(00009)'     #
#
# Pattern name...: ghri000_1.4gl
# Descriptions...: 联系信息
# Date & Author..: 2013-02-28  sr

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_hrab        DYNAMIC ARRAY OF RECORD
          hrab02     LIKE   hrab_file.hrab02,
          hrab03     LIKE   hrab_file.hrab03,
          hrab04     LIKE   hrab_file.hrab04,
          hrab05     LIKE   hrab_file.hrab05,
          hrab06     LIKE   hrab_file.hrab06,
          hrab07     LIKE   hrab_file.hrab07,
          hrab08     LIKE   hrab_file.hrab08,
          hrab09     LIKE   hrab_file.hrab09,
          hrab10     LIKE   hrab_file.hrab10,
          hrab11     LIKE   hrab_file.hrab11,
          hrab12     LIKE   hrab_file.hrab12,
          hrabacti   LIKE   hrab_file.hrabacti
                     END  RECORD,
       g_hrab_t      RECORD
          hrab02     LIKE   hrab_file.hrab02,
          hrab03     LIKE   hrab_file.hrab03,
          hrab04     LIKE   hrab_file.hrab04,
          hrab05     LIKE   hrab_file.hrab05,
          hrab06     LIKE   hrab_file.hrab06,
          hrab07     LIKE   hrab_file.hrab07,
          hrab08     LIKE   hrab_file.hrab08,
          hrab09     LIKE   hrab_file.hrab09,
          hrab10     LIKE   hrab_file.hrab10,
          hrab11     LIKE   hrab_file.hrab11,
          hrab12     LIKE   hrab_file.hrab12,
          hrabacti   LIKE   hrab_file.hrabacti
                     END  RECORD
DEFINE    l_ac_prt   LIKE   type_file.num5,
          l_cnt    LIKE   type_file.num5,
          l_rec_b  LIKE   type_file.num5,
          l_sql    STRING
DEFINE    g_hraa01  LIKE hraa_file.hraa01
DEFINE    g_forupd_sql  STRING

FUNCTION i000_feature_maintain(p_hraa01)
   DEFINE p_hraa01  LIKE hraa_file.hraa01
   
   LET g_hraa01=p_hraa01
   WHENEVER ERROR CALL cl_err_msg_log
   IF cl_null(g_hraa01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   OPEN WINDOW i000_w_prt WITH FORM "ghr/42f/ghri000_1"
   CALL cl_ui_init()
  
   LET l_sql = "SELECT hrab02,hrab03,hrab04,hrab05,hrab06,hrab07,hrab08,hrab09,hrab10,hrab11,hrab12,hrabacti ",
               "  FROM hrab_file",
               " WHERE hrab01 = '",g_hraa01,"'",
               " ORDER BY hrab02"
   PREPARE i000_prt_pre FROM l_sql
   DECLARE i000_prt_cs CURSOR FOR i000_prt_pre
   LET l_cnt = 1
   CALL g_hrab.clear()
   FOREACH i000_prt_cs INTO g_hrab[l_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
      IF l_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_hrab.deleteElement(l_cnt)
   LET l_rec_b = l_cnt - 1
   LET l_cnt  = 0
   CALL i000_prt_menu()
   CLOSE WINDOW i000_w_prt
END FUNCTION

FUNCTION i000_prt_menu()
   DEFINE  l_n     LIKE   type_file.num5
   DEFINE  l_num   LIKE   type_file.num5  #TQC-C20284 
   DEFINE  l_str        STRING
   WHILE TRUE
      CALL i000_prt_bp("G")
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
              CALL i000_prt_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
          # IF cl_confirm('确定退出') THEN
              EXIT WHILE
           #ELSE
          #    CONTINUE WHILE
          # END IF
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION i000_prt_bp(p_ud)
DEFINE   p_ud    LIKE  type_file.chr1
   IF p_ud<>"G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = ""
   CALL cl_set_act_visible("accept,cancel",FALSE)
   DISPLAY ARRAY g_hrab TO s_hrab.* ATTRIBUTE(COUNT = l_rec_b)
      BEFORE ROW
         LET l_ac_prt = ARR_CURR()
         CALL cl_show_fld_cont()
      ON ACTION detail
         LET g_action_choice = "detail"
         LET l_ac_prt        = 1
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
         LET l_ac_prt = ARR_CURR()
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

      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION

FUNCTION i000_prt_b()
   DEFINE  l_ac_t       LIKE type_file.num5,
           l_n          LIKE type_file.num5,
           l_lock_sw    LIKE type_file.chr1,
           p_cmd        LIKE type_file.chr1,
           l_allow_insert LIKE type_file.num5,
           l_allow_delete LIKE type_file.num5
   DEFINE  l_n1         LIKE type_file.num5,   #MOD-C30300 add
           l_n2         LIKE type_file.num5    #MOD-C30300 add
   LET g_action_choice = ""

   IF s_shut(0) THEN
      RETURN
   END IF

   CALL cl_opmsg('b')

   LET g_forupd_sql = " SELECT hrab02,hrab03,hrab04,hrab05,hrab06,hrab07,hrab08,hrab09,hrab10,hrab11,hrab12,hrabacti ",
                      "  FROM hrab_file",
                      " WHERE hrab01 = ? AND hrab02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i000_prt_bcl CURSOR FROM g_forupd_sql
   
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_hrab WITHOUT DEFAULTS FROM s_hrab.*
       ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF l_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac_prt)
         END IF

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac_prt  = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n   = ARR_COUNT()
        
         BEGIN WORK

         IF l_rec_b >= l_ac_prt THEN
            LET p_cmd = 'u'
            LET g_hrab_t.* = g_hrab[l_ac_prt].*
            OPEN i000_prt_bcl USING g_hraa01,g_hrab_t.hrab02
            IF STATUS THEN
               CALL cl_err("OPEN i000_prt_bcl:",STATUS,0)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i000_prt_bcl INTO g_hrab[l_ac_prt].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hraa01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
              
            END IF
           
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_hrab[l_ac_prt].* TO NULL
         LET g_hrab_t.* = g_hrab[l_ac_prt].*
         LET g_hrab[l_ac_prt].hrabacti='Y'
         CALL cl_show_fld_cont()
         NEXT FIELD hrab02
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE i000_prt_bcl
            CANCEL INSERT
         END IF
         INSERT INTO hrab_file(hrab01,hrab02,hrab03,hrab04,hrab05,hrab06,hrab07,hrab08,hrab09,hrab10,hrab11,hrab12,hrabacti,
                               hrabuser,hrabgrup,hraboriu,hraborig)
         VALUES(g_hraa01,g_hrab[l_ac_prt].hrab02,g_hrab[l_ac_prt].hrab03,
                g_hrab[l_ac_prt].hrab04,g_hrab[l_ac_prt].hrab05,g_hrab[l_ac_prt].hrab06,g_hrab[l_ac_prt].hrab07,
                g_hrab[l_ac_prt].hrab08,g_hrab[l_ac_prt].hrab09,g_hrab[l_ac_prt].hrab10,g_hrab[l_ac_prt].hrab11,
                g_hrab[l_ac_prt].hrab12,g_hrab[l_ac_prt].hrabacti,g_user,g_grup,g_user,g_grup)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrab_file",g_hraa01,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT OK'
            LET l_rec_b = l_rec_b + 1
            COMMIT WORK
         END IF
      BEFORE FIELD hrab02   #预设流水号
         IF g_hrab[l_ac_prt].hrab02 IS NULL 
            OR g_hrab[l_ac_prt].hrab02 = 0 THEN
            SELECT MAX(hrab02)+1 INTO g_hrab[l_ac_prt].hrab02
              FROM hrab_file
             WHERE hrab01 = g_hraa01
            IF g_hrab[l_ac_prt].hrab02 IS NULL THEN
               LET g_hrab[l_ac_prt].hrab02 = 1
            END IF
         END IF

      AFTER FIELD hrab02
         IF NOT cl_null(g_hrab[l_ac_prt].hrab02) THEN
            #TQC-C40023--add--str--
            IF g_hrab[l_ac_prt].hrab02 <= 0 THEN
               CALL cl_err('','aec-994',0)
               LET g_hrab[l_ac_prt].hrab02 = g_hrab_t.hrab02
               DISPLAY g_hrab[l_ac_prt].hrab02 TO hrab02
               NEXT FIELD hrab02
            END IF
            #TQC-C40023--add--end--
            IF g_hrab[l_ac_prt].hrab02 != g_hrab_t.hrab02
               OR g_hrab_t.hrab02 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM hrab_file
                WHERE hrab01 = g_hraa01
                  AND hrab02 = g_hrab[l_ac_prt].hrab02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_hrab[l_ac_prt].hrab02 = g_hrab_t.hrab02
                  DISPLAY g_hrab[l_ac_prt].hrab02 TO hrab02
                  NEXT FIELD hrab02
               END IF
            END IF
         END IF

     
      BEFORE DELETE
         IF g_hrab_t.hrab02 IS NOT NULL AND 
            g_hrab_t.hrab02 > 0 THEN
            IF NOT cl_delete() THEN
               CANCEL delete
            END IF
            IF l_lock_sw = "Y"  THEN
               CALL cl_err('',-263,1)
               CANCEL delete
            END IF
            DELETE FROM hrab_file
             WHERE hrab01 = g_hraa01
               AND hrab02 = g_hrab_t.hrab02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrab_file",g_hraa01,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET l_rec_b = l_rec_b - 1
         END IF
         COMMIT WORK
        
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_hrab[l_ac_prt].* = g_hrab_t.*
            CLOSE i000_prt_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF

         IF l_lock_sw = "Y" THEN
            CALL cl_err(g_hrab[l_ac_prt].hrab02,-263,1)
            LET g_hrab[l_ac_prt].* = g_hrab_t.*
         ELSE
            UPDATE hrab_file SET   hrab02  = g_hrab[l_ac_prt].hrab02,
                                   hrab03  = g_hrab[l_ac_prt].hrab03,
                                   hrab04  = g_hrab[l_ac_prt].hrab04,
                                   hrab05  = g_hrab[l_ac_prt].hrab05, 
                                   hrab06  = g_hrab[l_ac_prt].hrab06,
                                   hrab07  = g_hrab[l_ac_prt].hrab07,
                                   hrab08  = g_hrab[l_ac_prt].hrab08,
                                   hrab09  = g_hrab[l_ac_prt].hrab09,
                                   hrab10  = g_hrab[l_ac_prt].hrab10,
                                   hrab11  = g_hrab[l_ac_prt].hrab11,
                                   hrab12  = g_hrab[l_ac_prt].hrab12,
                                   hrabacti  = g_hrab[l_ac_prt].hrabacti,
                                   hrabmodu  = g_user,
                                   hrabdate  = g_today
             WHERE hrab01 = g_hraa01
               AND hrab02 = g_hrab_t.hrab02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hrab_file",g_hraa01,"",SQLCA.sqlcode,"","",1)
               LET g_hrab[l_ac_prt].* = g_hrab_t.*
            ELSE
               MESSAGE 'UPDATE OK'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac_prt = ARR_CURR()
         LET l_ac_t = l_ac_prt
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_hrab[l_ac_prt].* = g_hrab_t.*
            END IF
            CLOSE i000_prt_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         
         CLOSE i000_prt_bcl
         COMMIT WORK
     
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(hrab02) AND l_ac_prt > 1 THEN
            LET g_hrab[l_ac_prt].* = g_hrab[l_ac_prt-1].*
            LET g_hrab[l_ac_prt].hrab02 = NULL
            NEXT FIELD hrab02
         END IF
    
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

   CLOSE i000_prt_bcl
   COMMIT WORK
END FUNCTION


