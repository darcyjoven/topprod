# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: apci051.4gl
# Descriptions...: POS门店参数設定作業
# Date & Author..: No.FUN-CA0074 12/10/11 By xumm
# Modify.........: No.FUN-CC0064 12/12/20 By xumm 单身参数值栏位可以为null
# Modify.........: No.FUN-D10016 13/01/04 By xumm 增加日期时间输入格式的判断
# Modify.........: No.FUN-D30036 13/03/14 By xumm 查询时将apci050中已设置的门店参数/机号参数资料新增到此作业中
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_rze01          LIKE rze_file.rze01,
         g_rze01_t        LIKE rze_file.rze01,
         g_rze01_desc     LIKE azp_file.azp02,
         g_rze02          LIKE rze_file.rze02,
         g_rze02_t        LIKE rze_file.rze02,
         g_rze02_desc     LIKE ryc_file.ryc03,
         g_rze    DYNAMIC ARRAY of RECORD
            rze03          LIKE rze_file.rze03,
            rze03_desc     LIKE ryx_file.ryx05,
            rze04          LIKE rze_file.rze04,
            rze04_desc     LIKE ryx_file.ryx05,
            rzeacti        LIKE rze_file.rzeacti,
            rzepos         LIKE rze_file.rzepos
                      END RECORD,
         g_rze_t           RECORD 
            rze03          LIKE rze_file.rze03,
            rze03_desc     LIKE ryx_file.ryx05,
            rze04          LIKE rze_file.rze04,
            rze04_desc     LIKE ryx_file.ryx05,
            rzeacti        LIKE rze_file.rzeacti,
            rzepos         LIKE rze_file.rzepos
                      END RECORD, 
         g_wc                  STRING, 
         g_sql                 STRING, 
         g_rec_b               LIKE type_file.num5, 
         l_ac                  LIKE type_file.num5  
DEFINE   g_cnt                 LIKE type_file.num10  
DEFINE   g_msg                 LIKE type_file.chr1000 
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5 
DEFINE   g_curs_index          LIKE type_file.num10 
DEFINE   g_row_count           LIKE type_file.num10
DEFINE   g_jump                LIKE type_file.num10
DEFINE   g_no_ask              LIKE type_file.num5   
DEFINE   g_argv1               LIKE rzc_file.rzc01
DEFINE   g_multi_rze03         STRING

 
MAIN
 
   OPTIONS                 
      INPUT NO WRAP
   DEFER INTERRUPT 

   LET g_argv1 = ARG_VAL(1)

   IF cl_null(g_argv1) THEN 
      LET g_argv1 = '1'
   END IF
   IF g_argv1 = '1' THEN
      LET g_prog = "apci051"
   END IF
   IF g_argv1 = '2' THEN
      LET g_prog = "apci052"
   END IF
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APC")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   OPEN WINDOW i051_w WITH FORM "apc/42f/apci051"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
   IF g_argv1 = '1' THEN
      CALL cl_set_comp_visible("rze02",FALSE)
   END IF
   IF g_aza.aza88 = 'N' THEN
      CALL cl_set_comp_visible('rzepos',FALSE)
   END IF
   CALL i051_menu() 

   CLOSE WINDOW i051_w 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
FUNCTION i051_curs()                         # QBE 查詢資料
   CLEAR FORM                                # 清除畫面
   CALL g_rze.clear()
 
   CALL cl_set_head_visible("","YES") 
   INITIALIZE g_rze01 TO NULL 

   CONSTRUCT g_wc ON rze01,rze02,rze03,rze04,rzeacti,rzepos
                FROM rze01,rze02,s_rze[1].rze03,s_rze[1].rze04,
                     s_rze[1].rzeacti,s_rze[1].rzepos

      BEFORE CONSTRUCT                                                         
         CALL cl_qbe_init() 
          
      ON ACTION controlp
         CASE
            WHEN INFIELD(rze01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rze01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rze01
               NEXT FIELD rze01

            WHEN INFIELD(rze02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rze02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rze02
               NEXT FIELD rze02

            WHEN INFIELD(rze03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rze03"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rze03
               NEXT FIELD rze03

            WHEN INFIELD(rze04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rze04"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rze04
               NEXT FIELD rze04
               
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION HELP
         CALL cl_show_help()
         
      ON ACTION controlg
         CALL cl_cmdask()
         
      ON ACTION about
         CALL cl_about()
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) 
 
   IF INT_FLAG THEN 
      RETURN 
   END IF

   IF cl_null(g_wc) THEN
      LET g_wc="1=1"
   END IF
   
   IF g_argv1 = '1' THEN 
      LET g_sql=" SELECT UNIQUE rze01,rze02 FROM rze_file ",
                "  WHERE rze02 = ' '",
                "    AND ",g_wc CLIPPED,
                "  ORDER BY rze01"
   END IF
   IF g_argv1 = '2' THEN
      LET g_sql=" SELECT UNIQUE rze01,rze02 FROM rze_file ",
                "  WHERE rze02 <> ' '",
                "    AND ", g_wc CLIPPED,
                "  ORDER BY rze01"
   END IF

   PREPARE i051_prepare FROM g_sql  
   DECLARE i051_b_curs 
      SCROLL CURSOR WITH HOLD FOR i051_prepare
 
   IF g_argv1 = '1' THEN
      LET g_sql = "SELECT COUNT(UNIQUE rze01) FROM rze_file WHERE rze02 = ' ' AND ",g_wc CLIPPED
   END IF
   IF g_argv1 = '2' THEN
      LET g_sql = "SELECT COUNT(UNIQUE rze01) FROM rze_file WHERE rze02 <> ' ' AND ",g_wc CLIPPED
   END IF
   PREPARE i051_precount FROM g_sql    
   DECLARE i051_count CURSOR FOR i051_precount
 
   CALL i051_show()
  
END FUNCTION
 
FUNCTION i051_menu()
 
   WHILE TRUE
      CALL i051_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL i051_a()
            END IF
         WHEN "delete"                          # R.刪除
            IF cl_chk_act_auth() THEN
               CALL i051_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL i051_q()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i051_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i051_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
         WHEN "related_document"           
            IF cl_chk_act_auth() THEN
               IF g_rze01 IS NOT NULL THEN
                  LET g_doc.column1 = "rze01"
                  LET g_doc.value1 = g_rze01
                  CALL cl_doc()
               END IF 
            END IF  
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i051_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_rze.clear()
 
   IF s_shut(0) THEN RETURN END IF 
   LET g_rze01 = NULL                                                           
   LET g_rze01_t = NULL
   IF g_argv1 = '1' THEN
      LET g_rze02 = ' '
      LET g_rze02_t = ' '
   END IF
   IF g_argv1 = '2' THEN
      LET g_rze02 = NULL
      LET g_rze02_t = NULL
   END IF
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i051_i("a")  
 
      IF INT_FLAG THEN 
         LET g_rze01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF g_argv1 = '2' THEN
         IF cl_null(g_rze01) OR cl_null(g_rze02) THEN                                                 
            CONTINUE WHILE                                                        
         END IF
      ELSE
        IF cl_null(g_rze01) THEN
           CONTINUE WHILE
        END IF               
      END IF 
      LET g_rec_b = 0
      DISPLAY g_rec_b TO FORMONLY.cn2

      #FUN-D30036----Add----Str
      IF NOT cl_null(g_rze01) THEN
         CALL i051_b_fill( "1=1")
      END IF
      #FUN-D30036----Add----End 
      CALL i051_b() 
      LET g_rze01_t=g_rze01
      LET g_rze02_t=g_rze02
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i051_desc()
   INITIALIZE g_rze01_desc TO NULL 
   INITIALIZE g_rze02_desc TO NULL
   SELECT azp02 INTO g_rze01_desc 
     FROM azp_file 
    WHERE azp01 = g_rze01
   SELECT ryc03 INTO g_rze02_desc
     FROM ryc_file
    WHERE ryc01 = g_rze01
      AND ryc02 = g_rze02
   DISPLAY g_rze01_desc TO rze01_desc
   DISPLAY g_rze02_desc TO rze02_desc
END FUNCTION

FUNCTION i051_chk_rze01()
   DEFINE   l_n          LIKE type_file.num10
   DEFINE   l_rygacti    LIKE ryg_file.rygacti

   LET g_errno ='' 
   SELECT COUNT(*) INTO l_n
     FROM ryg_file
    WHERE ryg01 = g_rze01
   IF l_n = 0 THEN LET g_errno = 'alm-001' END IF
   SELECT rygacti INTO l_rygacti
     FROM ryg_file
    WHERE ryg01 = g_rze01 
   IF l_rygacti = 'N' THEN LET g_errno = 'aap-223' END IF
END FUNCTION

FUNCTION i051_chk_rze02()
   DEFINE   l_n          LIKE type_file.num10
   DEFINE   l_rycacti    LIKE ryc_file.rycacti

   LET g_errno ='' 
   SELECT COUNT(*) INTO l_n
     FROM ryc_file
    WHERE ryc01 = g_rze01
      AND ryc02 = g_rze02
   IF l_n = 0 THEN LET g_errno = 'apc1044' END IF
   SELECT rycacti INTO l_rycacti
     FROM ryc_file
    WHERE ryc01 = g_rze01 
      AND ryc02 = g_rze02
   IF l_rycacti = 'N' THEN LET g_errno = 'apc1045' END IF
END FUNCTION

FUNCTION i051_chk_rze03()
   DEFINE   l_n          LIKE type_file.num10
   DEFINE   l_rzcacti    LIKE rzc_file.rzcacti
   DEFINE   l_rzc04      LIKE rzc_file.rzc04

   LET g_errno ='' 
   SELECT rzc04,rzcacti INTO l_rzc04,l_rzcacti FROM rzc_file WHERE rzc01 = g_rze[l_ac].rze03
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'apc1042'
      WHEN l_rzcacti = 'N'     LET g_errno = 'apc1043'
      WHEN g_argv1 = '1' AND (l_rzc04 = '2' OR l_rzc04 = '4') LET g_errno = 'apc1056'
      WHEN g_argv1 = '2' AND (l_rzc04 = '1' OR l_rzc04 = '3') LET g_errno = 'apc1055'
   END CASE
END FUNCTION


FUNCTION i051_chk_rze04()
   DEFINE   l_n          LIKE type_file.num10
   DEFINE   l_rzdacti    LIKE rzd_file.rzdacti
   LET g_errno =''
   SELECT COUNT(*) INTO l_n
     FROM rzd_file
    WHERE rzd01 = g_rze[l_ac].rze03
   IF l_n > 0 THEN
      LET l_n = 0
      SELECT COUNT(*) INTO l_n
        FROM rzd_file
       WHERE rzd01 = g_rze[l_ac].rze03
         AND rzd02 = g_rze[l_ac].rze04
      IF l_n = 0 THEN LET g_errno = 'apc1047' END IF
      SELECT rzdacti INTO l_rzdacti
        FROM rzd_file
       WHERE rzd01 = g_rze[l_ac].rze03
         AND rzd02 = g_rze[l_ac].rze04
      IF l_rzdacti = 'N' THEN LET g_errno = 'apc1048' END IF
   END IF
END FUNCTION 

FUNCTION i051_i(p_cmd) 
 
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改

   DISPLAY g_rze01 TO rze01 
   DISPLAY g_rze02 TO rze02
   CALL i051_desc()
 
   CALL cl_set_head_visible("","YES") 
   INPUT g_rze01,g_rze02 WITHOUT DEFAULTS FROM rze01,rze02
 
      AFTER FIELD rze01
         IF NOT cl_null(g_rze01)THEN
            IF g_rze01 != g_rze01_t OR cl_null(g_rze01_t) THEN
               CALL i051_chk_rze01()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rze01,g_errno,0)
                  LET g_rze01 = g_rze01_t
                  NEXT FIELD rze01
               END IF
               IF g_rze02 IS NOT NULL THEN
                  SELECT COUNT(*) INTO g_cnt FROM rze_file
                   WHERE rze01 = g_rze01 
                     AND rze02 = g_rze02
                  IF p_cmd = 'a' AND g_cnt > 0 THEN
                     CALL i051_show()
                     EXIT INPUT
                  END IF
                  IF p_cmd = 'u' THEN
                     IF g_cnt > 0 THEN
                        CALL cl_err(g_rze01,'-239',0)
                        LET g_rze01 = g_rze01_t
                        NEXT FIELD rze01
                     ELSE
                        LET g_success = 'Y'
                     END IF
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rze01,g_errno,0)
                  NEXT FIELD rze01
               END IF
               CALL i051_desc()
            END IF
         END IF
         
      BEFORE FIELD rze02
         IF cl_null(g_rze01) THEN
            CALL cl_err(g_rze01,'alm-550',0)
            NEXT FIELD rze01
         END IF
     
      AFTER FIELD rze02
         IF NOT cl_null(g_rze02) THEN
            IF g_rze02 != g_rze02_t OR cl_null(g_rze02_t) THEN
               CALL i051_chk_rze02()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rze02,g_errno,0)
                  LET g_rze02 = g_rze02_t
                  NEXT FIELD rze02
               END IF
               IF NOT cl_null(g_rze01) THEN
                  SELECT COUNT(*) INTO g_cnt FROM rze_file
                   WHERE rze01 = g_rze01 
                     AND rze02 = g_rze02
                  IF p_cmd = 'a' AND g_cnt > 0 THEN
                     CALL i051_show()
                     EXIT INPUT
                  END IF
                  IF p_cmd = 'u' THEN
                     IF g_cnt > 0 THEN
                        CALL cl_err(g_rze02,'-239',0)
                        LET g_rze02 = g_rze02_t
                        NEXT FIELD rze02
                     ELSE
                        LET g_success = 'Y'
                     END IF
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rze02,g_errno,0)
                  NEXT FIELD rze02
               END IF
               CALL i051_desc()
            END IF
         END IF

      AFTER INPUT          
          IF INT_FLAG THEN
             EXIT INPUT
          END IF                                                    
          IF g_rze01 IS NULL OR g_rze02 IS NULL THEN               
             NEXT FIELD rze01                  
          END IF 
          
      ON ACTION controlp
         CASE
            WHEN INFIELD(rze01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rze01i"
               LET g_qryparam.default1= g_rze01
               CALL cl_create_qry() RETURNING g_rze01
               DISPLAY g_rze01 TO rze01
               NEXT FIELD rze01

            WHEN INFIELD(rze02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rze02i"
               LET g_qryparam.default1= g_rze02
               LET g_qryparam.where = " ryc01 = '",g_rze01,"'"
               CALL cl_create_qry() RETURNING g_rze02
               DISPLAY g_rze02 TO rze02
               NEXT FIELD rze02
               
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION controlf              
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END INPUT
END FUNCTION
 
FUNCTION i051_q()
   LET g_rze01 = ''                                                     
   INITIALIZE g_rze01 TO NULL                            
   INITIALIZE g_rze02 TO NULL
   IF g_argv1 = '1' THEN
      LET g_rze02 = ' '
   END IF
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM 
   CALL g_rze.clear()
   DISPLAY '' TO FORMONLY.cnt
   
   CALL i051_curs()   
   
   IF INT_FLAG THEN  
      LET INT_FLAG = 0
      INITIALIZE g_rze01 TO NULL
      INITIALIZE g_rze02 TO NULL
      RETURN
   END IF

   OPEN i051_b_curs  
   IF SQLCA.SQLCODE THEN   
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_rze01 TO NULL
      INITIALIZE g_rze02 TO NULL
   ELSE
      OPEN i051_count
      FETCH i051_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i051_fetch('F')  
    END IF
END FUNCTION
 
FUNCTION i051_fetch(p_flag) 
   DEFINE   p_flag   LIKE type_file.chr1
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i051_b_curs INTO g_rze01,g_rze02
      WHEN 'P' FETCH PREVIOUS i051_b_curs INTO g_rze01,g_rze02
      WHEN 'F' FETCH FIRST    i051_b_curs INTO g_rze01,g_rze02
      WHEN 'L' FETCH LAST     i051_b_curs INTO g_rze01,g_rze02
      WHEN '/' 
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0 
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION controlp
                   CALL cl_cmdask()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i051_b_curs INTO g_rze01,g_rze02
         LET g_no_ask = FALSE    
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rze01,SQLCA.sqlcode,0)
      INITIALIZE g_rze01,g_rze02 TO NULL
   ELSE
      CALL i051_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index, g_row_count)
   END IF
END FUNCTION

 
FUNCTION i051_show() 
   DISPLAY g_rze01 TO rze01
   DISPLAY g_rze02 TO rze02
   CALL i051_desc()
   CALL i051_b_fill(g_wc) 
   CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION i051_r()   
   DEFINE   l_cnt   LIKE type_file.num5,  
            l_rze   RECORD LIKE rze_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_rze01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   LET l_cnt = 0
  
   IF g_rze02 IS NULL THEN LET g_rze02 = ' ' END IF 
   BEGIN WORK
   IF cl_delh(0,0) THEN 
      IF g_aza.aza88='Y' THEN
         SELECT COUNT(*) INTO l_cnt
           FROM rze_file
          WHERE rze01 = g_rze01
            AND rze02 = g_rze02
            AND (rzepos =  '2' OR (rzepos = '3' AND rzeacti = 'Y'))
         IF l_cnt > 0 THEN
            CALL cl_err('','apc-139',0)
            ROLLBACK WORK
            RETURN
         END IF
      END IF
      DELETE FROM rze_file
       WHERE rze01 = g_rze01
         AND rze02 = g_rze02 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","rze_file",g_rze01,g_rze02,SQLCA.sqlcode,"","",0)
         ROLLBACK WORK
         RETURN
      ELSE
         COMMIT WORK
         CLEAR FORM
         OPEN i051_count
         FETCH i051_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i051_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i051_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i051_fetch('/')
         END IF
         CALL i051_show()
      END IF
   END IF
END FUNCTION

FUNCTION i051_copy()
 DEFINE l_n       LIKE type_file.num5,
        l_newno   STRING, 
        l_oldno   LIKE rze_file.rze01,
        l_newno1  STRING,
        l_oldno1  LIKE rze_file.rze02
 DEFINE tok       base.StringTokenizer
 DEFINE tok1      base.StringTokenizer
 DEFINE l_rze01   LIKE rze_file.rze01
 DEFINE l_rze02   LIKE rze_file.rze02
 DEFINE l_success LIKE type_file.chr1
    IF s_shut(0) THEN
       RETURN
    END IF
  
    IF g_rze01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

    IF g_argv1 = '1' THEN
       LET g_rze02 = ' '
    END IF
    LET l_oldno = g_rze01
    LET l_oldno1 = g_rze02
    LET g_before_input_done = FALSE
    CALL cl_set_head_visible("","YES")     
    INITIALIZE g_rze01_desc TO NULL
    INITIALIZE g_rze02_desc TO NULL
    DISPLAY g_rze01_desc TO rze01_desc
    DISPLAY g_rze02_desc TO rze02_desc
    INPUT  l_newno,l_newno1 FROM rze01,rze02

     ON ACTION controlp
         CASE
            WHEN INFIELD(rze01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rze01i"
               LET g_qryparam.state = "c" 
               CALL cl_create_qry() RETURNING l_newno
               DISPLAY l_newno TO rze01

            WHEN INFIELD(rze02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rze02i"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING l_newno1
               DISPLAY l_newno1 TO rze02

            OTHERWISE
               EXIT CASE
          END CASE 
     ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about         
        CALL cl_about()      
 
     ON ACTION help          
        CALL cl_show_help()  
 
     ON ACTION controlg      
        CALL cl_cmdask()     
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CALL i051_show()
      ROLLBACK WORK
      RETURN
   END IF

   ###################################################
   #以下功能为整批复制功能，
   #如果成功则INSERT INTO lrz_file,
   #否则将没INSERT的资料报错 
   BEGIN WORK
   LET l_success = 'Y'
   LET l_n = 0
   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(l_newno,"|")
   WHILE tok.hasMoreTokens()
      LET l_rze01 = tok.nextToken()
      LET g_rze01 = l_rze01
      CALL i051_chk_rze01()
      IF NOT cl_null(g_errno) THEN
         CALL s_errmsg('',l_rze01,'',g_errno,1)
         LET l_success = 'N'
         CONTINUE WHILE
      END IF
      IF g_argv1 = '1' THEN
         SELECT count(*) INTO l_n FROM rze_file
          WHERE rze01 = l_rze01
            AND rze02 = ' '
         IF l_n > 0 THEN
            CALL s_errmsg('',l_rze01,'',-239,1)
            LET l_success = 'N'
            CONTINUE WHILE
         END IF
         DROP TABLE x
         SELECT * FROM rze_file
          WHERE rze01 = l_oldno
            AND rze02 = l_oldno1
           INTO TEMP x
         UPDATE x
            SET rze01 = l_rze01,
                rze02 = ' ',
                rzepos = '1'
         INSERT INTO rze_file SELECT * FROM x
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('',l_rze01,'Ins rze_file',SQLCA.sqlcode,1)
            LET l_success = 'N'
         ELSE
            COMMIT WORK
         END IF
      END IF
      IF g_argv1 = '2' THEN
         LET tok1 = base.StringTokenizer.create(l_newno1,"|")
         WHILE tok1.hasMoreTokens()
            LET l_rze02 = tok1.nextToken()
            LET g_rze02 = l_rze02
            CALL i051_chk_rze02()
            IF NOT cl_null(g_errno) THEN
               CALL s_errmsg('',l_rze02,'',g_errno,1)   
               LET l_success = 'N'
               CONTINUE WHILE
            END IF 
            DROP TABLE x
            SELECT * FROM rze_file
             WHERE rze01 = l_oldno
               AND rze02 = l_oldno1
              INTO TEMP x
            UPDATE x
               SET rze01 = l_rze01,
                   rze02 = l_rze02,
                   rzepos = '1'
            INSERT INTO rze_file SELECT * FROM x
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('',l_rze02,'Ins rze_file',SQLCA.sqlcode,1)
               LET l_success = 'N'
            ELSE
               COMMIT WORK
            END IF
          END WHILE
      END IF
   END WHILE
   IF l_success <> 'Y' THEN
      CALL s_showmsg()
   END IF 
   ###################################################
   LET g_rze01 = l_oldno
   LET g_rze02 = l_oldno1
   CALL i051_show() 
END FUNCTION

FUNCTION i051_b()                           
DEFINE   l_ac_t          LIKE type_file.num5
DEFINE   l_n             LIKE type_file.num5
DEFINE   l_cnt           LIKE type_file.num5
DEFINE   l_cnt1          LIKE type_file.num5
DEFINE   l_lock_sw       LIKE type_file.chr1
DEFINE   p_cmd           LIKE type_file.chr1
DEFINE   l_rzepos        LIKE rze_file.rzepos
DEFINE   l_allow_insert  LIKE type_file.num5
DEFINE   l_allow_delete  LIKE type_file.num5  
DEFINE   l_rzc02         LIKE rzc_file.rzc02     #FUN-D10016 
DEFINE   l_rzc05         LIKE rzc_file.rzc05     #FUN-D10016
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_rze01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 

   IF cl_null(g_rze02) THEN
      LET g_rze02 = ' '
   END IF
   CALL cl_opmsg('b')

   LET g_forupd_sql= "SELECT rze03,'',rze04,'',rzeacti,rzepos ",
                     "  FROM rze_file ",
                     "  WHERE rze01 = ? AND rze02 = ? AND rze03 = ?",  
                     " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i051_bcl CURSOR FROM g_forupd_sql 
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   INPUT ARRAY g_rze WITHOUT DEFAULTS FROM s_rze.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'  
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_rze_t.* = g_rze[l_ac].*  
            ##############################################################
            #已傳POS否處理段
            IF g_aza.aza88 = 'Y' THEN
               BEGIN WORK
               OPEN i051_bcl USING g_rze01,g_rze02,g_rze_t.rze03
               IF SQLCA.sqlcode THEN
                  CALL cl_err("OPEN i051_bcl:", STATUS, 1)
                  EXIT INPUT
                  LET l_lock_sw = 'Y'
               ELSE
                  FETCH i051_bcl INTO g_rze[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('FETCH i051_bcl:',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     SELECT rzepos INTO l_rzepos  
                       FROM rze_file 
                      WHERE rze01 = g_rze01 AND rze02 = g_rze02 AND rze03 = g_rze[l_ac].rze03
                     UPDATE rze_file SET rzepos = '4'
                      WHERE rze01 = g_rze01
                        AND rze02 = g_rze02
                        AND rze03 = g_rze[l_ac].rze03
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("upd","rze_file",g_rze_t.rze03,"",SQLCA.sqlcode,"","",1)
                        RETURN
                     END IF
                     LET g_rze[l_ac].rzepos = '4'
                     DISPLAY BY NAME g_rze[l_ac].rzepos
                  END IF
               END IF
               COMMIT WORK
            END IF
            ##############################################################
            BEGIN WORK
            OPEN i051_bcl USING g_rze01,g_rze02,g_rze_t.rze03
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN i051_bcl:", STATUS, 1)
               EXIT INPUT
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i051_bcl INTO g_rze[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH i051_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF    
               SELECT ryx05 INTO g_rze[l_ac].rze03_desc
                 FROM ryx_file
                WHERE ryx01 = 'rzc_file'
                  AND ryx02 = 'rzc01'
                  AND ryx03 = g_rze[l_ac].rze03
                  AND ryx04 = g_lang
               SELECT ryx05 INTO g_rze[l_ac].rze04_desc
                 FROM ryx_file
                WHERE ryx01 = 'rzd_file'
                  AND ryx02 = 'rzd02'
                  AND ryx03 = g_rze[l_ac].rze03||"|"||g_rze[l_ac].rze04
                  AND ryx04 = g_lang
            END IF
            CALL cl_show_fld_cont()   
         END IF
         
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE
         INITIALIZE g_rze[l_ac].* TO NULL 
         LET g_before_input_done = TRUE
         LET g_rze_t.* = g_rze[l_ac].*   
         LET g_rze[l_ac].rzeacti = 'Y'
         IF g_aza.aza88 = 'Y' THEN
            LET g_rze[l_ac].rzepos = '1'
            LET l_rzepos = '1'
         END IF
         CALL cl_show_fld_cont()
         NEXT FIELD rze03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO rze_file(rze01,rze02,rze03,rze04,rzeacti,rzepos)
                       VALUES(g_rze01,g_rze02,g_rze[l_ac].rze03,g_rze[l_ac].rze04,g_rze[l_ac].rzeacti,g_rze[l_ac].rzepos)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rze_file",g_rze01,g_rze[l_ac].rze03,SQLCA.sqlcode,"","",0) 
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      AFTER FIELD rze03
         IF NOT cl_null(g_rze[l_ac].rze03) THEN
            IF g_rze[l_ac].rze03 != g_rze_t.rze03 OR
                g_rze_t.rze03 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM rze_file 
                WHERE rze01 = g_rze01 
                  AND rze02 = g_rze02
                  AND rze03 =  g_rze[l_ac].rze03
               IF l_n> 0 THEN
                  CALL cl_err(g_rze[l_ac].rze03,'-239',1)
                  LET g_rze[l_ac].rze03=g_rze_t.rze03
                  NEXT FIELD rze03
               END IF
               CALL i051_chk_rze03()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rze[l_ac].rze03,g_errno,0)
                  LET g_rze[l_ac].rze03 = g_rze_t.rze03
                  NEXT FIELD rze03
               END IF
               IF NOT cl_null(g_rze[l_ac].rze04) THEN
                  CALL i051_chk_rze04()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rze[l_ac].rze03,g_errno,0)
                     LET g_rze[l_ac].rze03 = g_rze_t.rze03
                     NEXT FIELD rze03
                  END IF
               END IF
               INITIALIZE g_rze[l_ac].rze03_desc TO NULL 
               SELECT ryx05 INTO g_rze[l_ac].rze03_desc
                 FROM ryx_file
                WHERE ryx01 = 'rzc_file'
                  AND ryx02 = 'rzc01'
                  AND ryx03 = g_rze[l_ac].rze03
                  AND ryx04 = g_lang
            END IF
          END IF

      AFTER FIELD rze04
          IF NOT cl_null(g_rze[l_ac].rze04) THEN
             IF NOT cl_null(g_rze[l_ac].rze03) THEN
                CALL i051_chk_rze04()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_rze[l_ac].rze04,g_errno,0)
                   LET g_rze[l_ac].rze04 = g_rze_t.rze04
                   NEXT FIELD rze04
                END IF
                #FUN-D10016------add-----str
                SELECT rzc02,rzc05 INTO l_rzc02,l_rzc05
                  FROM rzc_file 
                 WHERE rzc01 = g_rze[l_ac].rze03
                IF l_rzc02 = '3' THEN
                   CALL i051_chk_date(g_rze[l_ac].rze04,l_rzc05)
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rze[l_ac].rze04,g_errno,0)
                      LET g_rze[l_ac].rze04 = g_rze_t.rze04
                      NEXT FIELD rze04
                   END IF 
                END IF
                #FUN-D10016------add-----end
             END IF
             INITIALIZE g_rze[l_ac].rze04_desc TO NULL
             SELECT ryx05 INTO g_rze[l_ac].rze04_desc
               FROM ryx_file
              WHERE ryx01 = 'rzd_file'
                AND ryx02 = 'rzd02'
                AND ryx03 = g_rze[l_ac].rze03||"|"||g_rze[l_ac].rze04
                AND ryx04 = g_lang
          END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_rze_t.rze03) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", '-263', 1) 
               CANCEL DELETE 
            END IF
            IF g_aza.aza88='Y' THEN
               IF NOT ((l_rzepos='3' AND g_rze_t.rzeacti='N') OR (l_rzepos='1'))  THEN
                  CALL cl_err('','apc-139',0)
                  CANCEL DELETE
               END IF
            END IF
            DELETE  FROM rze_file
             WHERE rze01 = g_rze01
               AND rze02 = g_rze02
               AND rze03 = g_rze_t.rze03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","rze_file",g_rze_t.rze03,SQLCA.sqlcode,"","","",1)  
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
        END IF
        COMMIT WORK
        SELECT rze01,rze02 INTO g_rze01,g_rze02
          FROM rze_file
         WHERE rze01 = g_rze01
           AND rze02 = g_rze02
           AND rze03 = g_rze_t.rze03
        MESSAGE 'DELETE O.K'
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30033 mark
 
         IF INT_FLAG THEN
            ROLLBACK WORK
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               IF g_aza.aza88 = 'Y' THEN
                  UPDATE rze_file SET rzepos = l_rzepos
                   WHERE rze01 = g_rze01
                     AND rze02 = g_rze02
                     AND rze03 = g_rze_t.rze03
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","rze_file",g_rze_t.rze03,"",SQLCA.sqlcode,"","",1)
                  END IF
                  LET g_rze[l_ac].rzepos = l_rzepos
                  DISPLAY BY NAME g_rze[l_ac].rzepos
               END IF
            #FUN-D30033--add--begin--
            ELSE
               CALL g_rze.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30033--add--end----
            END IF
            CLOSE i051_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30033 add
         CLOSE i051_bcl
         COMMIT WORK

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_rze[l_ac].* = g_rze_t.*
            CLOSE i051_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_rze[l_ac].rze03,-263,1)
            LET g_rze[l_ac].* = g_rze_t.*
         ELSE
            LET g_rze[l_ac].rzeacti = 'Y'
            IF g_aza.aza88='Y' THEN
              IF l_rzepos <> '1' THEN
                 LET g_rze[l_ac].rzepos='2'
              ELSE
                 LET g_rze[l_ac].rzepos='1'
              END IF
            END IF
            UPDATE rze_file SET rze03 = g_rze[l_ac].rze03,
                                rze04 = g_rze[l_ac].rze04,
                                rzeacti = g_rze[l_ac].rzeacti,
                                rzepos = g_rze[l_ac].rzepos
             WHERE rze01 = g_rze01
               AND rze02 = g_rze02
               AND rze03 = g_rze_t.rze03
            IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","rze_file",g_rze[l_ac].rze03,SQLCA.sqlcode,"","","",1)
              ROLLBACK WORK  
              LET g_rze[l_ac].* = g_rze_t.*
            ELSE  
              SELECT ryx05 INTO g_rze[l_ac].rze03_desc
                FROM ryx_file
               WHERE ryx01 = 'rzc_file'
                 AND ryx02 = 'rzc01'
                 AND ryx03 = g_rze[l_ac].rze03
                 AND ryx04 = g_lang
              SELECT ryx05 INTO g_rze[l_ac].rze04_desc
                FROM ryx_file
               WHERE ryx01 = 'rzd_file'
                 AND ryx02 = 'rzd02'
                 AND ryx03 = g_rze[l_ac].rze03||"|"||g_rze[l_ac].rze04
                 AND ryx04 = g_lang
              MESSAGE 'UPDATE O.K'
              COMMIT WORK
            END IF
         END IF

      ON ACTION CONTROLO                      
         IF INFIELD(rze01) AND l_ac > 1 THEN
            LET g_rze[l_ac].* = g_rze[l_ac-1].*
            LET g_rze[l_ac].rze03=null
            NEXT FIELD rze01
         END IF
         
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(rze03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rze03i"
               IF g_argv1 = '1' THEN
                  LET g_qryparam.where = "rzc04 = '1' OR rzc04 = '3'"
               END IF
               IF g_argv1 = '2' THEN
                  LET g_qryparam.where = "rzc04 = '2' OR rzc04 = '4'"
               END IF
               LET g_qryparam.default1= g_rze[l_ac].rze03
               IF p_cmd = 'a' THEN
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_multi_rze03
                  IF NOT cl_null(g_multi_rze03) THEN
                      CALL i051_rze03_m()
                      CALL i051_b_fill( "1=1")
                      CALL i051_b()
                      LET p_cmd = 'u'
                      EXIT INPUT
                  END IF
               ELSE
                  CALL cl_create_qry() RETURNING g_rze[l_ac].rze03
                  DISPLAY BY NAME g_rze[l_ac].rze03
               END IF
               NEXT FIELD rze03

            WHEN INFIELD(rze04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rze04i"
               LET g_qryparam.default1= g_rze[l_ac].rze04
               IF NOT cl_null(g_rze[l_ac].rze03) THEN
                  LET g_qryparam.where = "rzd01 = '",g_rze[l_ac].rze03,"'"
               END IF
               CALL cl_create_qry() RETURNING g_rze[l_ac].rze04
               DISPLAY BY NAME g_rze[l_ac].rze04
               NEXT FIELD rze04
            OTHERWISE
               EXIT CASE
         END CASE
   
      ON ACTION CONTROLF
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        

      AFTER INPUT
   END INPUT
  
   CLOSE i051_bcl
   COMMIT WORK

  #FUN-CC0064------mark----str
  #LET l_cnt = 0
  #LET l_cnt1 = 0
  #SELECT COUNT(*) INTO l_cnt FROM rze_file WHERE rze01 = g_rze01 AND rze02 = g_rze02
  #SELECT COUNT(*) INTO l_cnt1 FROM rze_file WHERE rze01 = g_rze01 AND rze02 = g_rze02 AND rze04 = ' '
  #IF l_cnt > 0 AND l_cnt1 > 0 THEN
  #   CALL cl_err('','apc1046',0)
  #   CALL i051_b()
  #END IF
  #FUN-CC0064------mark----end

END FUNCTION
 
FUNCTION i051_b_fill(p_wc)   
DEFINE p_wc         STRING 

    IF cl_null(p_wc) THEN
       LET p_wc = " 1=1"
    END IF
    #FUN-D30036----Add----Str 
    IF NOT cl_null(g_rze01) THEN
       CALL i051_ins()
    END IF
    #FUN-D30036----Add----End
    LET g_sql = "SELECT rze03,'',rze04,'',rzeacti,rzepos",
                "  FROM rze_file ",
                " WHERE rze01 = '",g_rze01,"'",
                "   AND rze02 = '",g_rze02,"'",
                "   AND ",p_wc CLIPPED,
                " ORDER BY rze01"
    PREPARE i051_prepare2 FROM g_sql  
    DECLARE rze_curs CURSOR FOR i051_prepare2
 
    CALL g_rze.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH rze_curs INTO g_rze[g_cnt].*  
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT ryx05 INTO g_rze[g_cnt].rze03_desc
         FROM ryx_file
        WHERE ryx01 = 'rzc_file'
          AND ryx02 = 'rzc01'
          AND ryx03 = g_rze[g_cnt].rze03
          AND ryx04 = g_lang
       SELECT ryx05 INTO g_rze[g_cnt].rze04_desc
         FROM ryx_file
        WHERE ryx01 = 'rzd_file'
          AND ryx02 = 'rzd02'
          AND ryx03 = g_rze[g_cnt].rze03||"|"||g_rze[g_cnt].rze04
          AND ryx04 = g_lang
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_rze.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    LET g_rze_t.rze03 = g_rze[1].rze03
END FUNCTION
 
FUNCTION i051_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_rze TO s_rze.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()    
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice='insert'
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice='query'
         EXIT DISPLAY
         
      ON ACTION delete                           # D.删除
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY

      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first            
         CALL i051_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
           ACCEPT DISPLAY              
 
      ON ACTION previous                 
         CALL i051_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY             
 
      ON ACTION jump            
         CALL i051_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
         END IF
	     ACCEPT DISPLAY                  
 
      ON ACTION next                          
         CALL i051_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION last                            
         CALL i051_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
 
       ON ACTION help                           
          LET g_action_choice='help'
          EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()    
         CALL i051_b_fill(g_wc) 
         EXIT DISPLAY
 
      ON ACTION exit      
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()

      AFTER DISPLAY
         CONTINUE DISPLAY

                                                                                           
      ON ACTION controls                                                                                                              
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION i051_rze03_m()
DEFINE   tok         base.StringTokenizer
DEFINE   l_sql       STRING
DEFINE   l_n         LIKE type_file.num5
DEFINE   l_rze       RECORD LIKE rze_file.*
DEFINE   l_success   LIKE type_file.chr1
   BEGIN WORK
   LET l_success = 'Y'
   LET l_n = 0
   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_multi_rze03,"|")
   WHILE tok.hasMoreTokens()
      INITIALIZE l_rze.* TO NULL
      LET l_rze.rze03 = tok.nextToken()
      SELECT count(*) INTO l_n FROM rze_file
       WHERE rze01 = g_rze01
         AND rze02 = g_rze02
         AND rze03 = l_rze.rze03
      IF l_n > 0 THEN
         CALL s_errmsg('',l_rze.rze03,'',-239,1)
         CONTINUE WHILE
      ELSE
         IF g_argv1 = '1' THEN
            SELECT rzc05 INTO l_rze.rze04
              FROM rzc_file
             WHERE rzc01 = l_rze.rze03
               AND (rzc04 = '1' OR rzc04 = '3')
         END IF
         IF g_argv1 = '2' THEN
            SELECT rzc05 INTO l_rze.rze04
              FROM rzc_file
             WHERE rzc01 = l_rze.rze03
               AND (rzc04 = '2' OR rzc04 = '4')
         END IF  
         IF cl_null(l_rze.rze04) THEN
            LET l_rze.rze04 = ' '
         END IF
         LET l_rze.rze01 = g_rze01
         LET l_rze.rze02 = g_rze02
         LET l_rze.rzeacti = 'Y'
         LET l_rze.rzepos = '1'
         INSERT INTO rze_file VALUES(l_rze.*)
         IF SQLCA.sqlcode THEN
            LET l_success = 'N'
            CALL s_errmsg('',l_rze.rze01,'Ins rze_file',SQLCA.sqlcode,1)
            CONTINUE WHILE
         END IF
      END IF
   END WHILE
   IF l_success <> 'Y' THEN
      CALL s_showmsg()
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
END FUNCTION
#FUN-CA0074
#FUN-D10016------add----str
FUNCTION i051_chk_date(p_rzc05,p_rzd02)
DEFINE p_rzc05       LIKE rzc_file.rzc05
DEFINE p_rzd02       LIKE rzd_file.rzd02
DEFINE l_str         STRING
DEFINE l_str1        STRING
DEFINE l_date        LIKE type_file.chr10
DEFINE l_time        LIKE type_file.chr8
DEFINE l_days        LIKE type_file.num5

   LET g_errno = ''

   LET l_str1 = p_rzd02
   LET l_str = p_rzc05
   IF l_str.getindexof('-',1) > 0 THEN
      LET l_date = p_rzc05
      IF l_str.getLength() !=10 THEN
         LET g_errno = 'apc1059'
      END IF
      IF l_date[1,1] MATCHES '[0123456789]' AND
         l_date[2,2] MATCHES '[0123456789]' AND
         l_date[3,3] MATCHES '[0123456789]' AND
         l_date[4,4] MATCHES '[0123456789]' AND
         l_date[5,5] = '-' AND
         l_date[6,6] MATCHES '[012]' AND
         l_date[7,7] MATCHES '[0123456789]' AND
         l_date[8,8] = '-' AND
         l_date[9,9] MATCHES '[0123]' AND
         l_date[10,10] MATCHES '[0123456789]' THEN
         IF l_date[1,4] <'0001' OR l_date[6,7] <'01' OR l_date[6,7] >'12' OR
            l_date[9,10] <'01' THEN
            LET g_errno = 'apc1059'
         ELSE
            LET l_days = cl_days(l_date[1,4],l_date[6,7])
            IF l_date[9,10] > l_days THEN
               LET g_errno = 'apc1059'
            END IF
         END IF
      ELSE
         LET g_errno = 'apc1059'
      END IF
   ELSE
      IF l_str.getindexof(':',1) > 0 THEN
         LET l_time = p_rzc05
         IF l_str.getLength() != 8 THEN
            LET g_errno = 'apc1059'
         END IF
         IF l_time[1,1] MATCHES '[012]' AND
            l_time[2,2] MATCHES '[0123456789]' AND
            l_time[3,3] =':' AND
            l_time[4,4] MATCHES '[012345]' AND
            l_time[5,5] MATCHES '[0123456789]' AND
            l_time[6,6] =':' AND
            l_time[7,7] MATCHES '[012345]' AND
            l_time[8,8] MATCHES '[0123456789]' THEN
            IF l_time[1,2]<'00' OR l_time[1,2]>='24' OR
               l_time[4,5]<'00' OR l_time[4,5]>='60' OR
               l_time[7,8]<'00' OR l_time[7,8]>='60' THEN
               LET g_errno='apc1059'
            END IF
         ELSE
            LET g_errno='apc1059'
         END IF
      ELSE
         LET g_errno = 'apc1059'
      END IF
   END IF
   IF l_str1.getindexof('-',1) > 0 AND l_str.getindexof('-',1) = 0 THEN
      LET g_errno = 'apc1061'
   END IF
   IF l_str1.getindexof(':',1) > 0 AND l_str.getindexof(':',1) = 0 THEN
      LET g_errno = 'apc1061'
   END IF
END FUNCTION
#FUN-D10016------add----end
#FUN-D30036------Add----Str
FUNCTION i051_ins()

   IF g_rze02 = ' ' THEN
      LET g_sql = " INSERT INTO rze_file(rze01,rze02,rze03,rze04,rzeacti,rzepos)",
                  " SELECT '",g_rze01,"','",g_rze02,"',rzc01,rzc05,'Y','1'",
                  "   FROM rzc_file",
                  "  WHERE rzcacti = 'Y'", 
                  "    AND rzc04 = '1'",
                  "    AND NOT EXISTS(SELECT 1 FROM rze_file",
                  "                    WHERE rze01 = '",g_rze01,"'",
                  "                      AND rze02 = '",g_rze02,"'",
                  "                      AND rze03 = rzc01)"
   ELSE
      LET g_sql = " INSERT INTO rze_file(rze01,rze02,rze03,rze04,rzeacti,rzepos)",
                  " SELECT '",g_rze01,"','",g_rze02,"',rzc01,rzc05,'Y','1'",
                  "   FROM rzc_file",
                  "  WHERE rzcacti = 'Y'",
                  "    AND rzc04 = '2'",
                  "    AND NOT EXISTS(SELECT 1 FROM rze_file",
                  "                    WHERE rze01 = '",g_rze01,"'",
                  "                      AND rze02 = '",g_rze02,"'",
                  "                      AND rze03 = rzc01)"
   END IF
   PREPARE i051_sel_rzc_per FROM g_sql
   EXECUTE i051_sel_rzc_per 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rze_file",g_rze01,'',SQLCA.sqlcode,"","",0)
   END IF
END FUNCTION
#FUN-D30036------Add----End
