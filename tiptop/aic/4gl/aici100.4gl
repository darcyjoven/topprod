# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: aici010.4gl                                                                                                      
# Descriptions...: ICD蹋璃FT峎誘釬珛                                                                                                
# Date & Author..: 07/11/15 By Sunyanchun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/28 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ickd       RECORD                      #等芛訧蹋垀勤茼腔曹講
          ick01       LIKE ick_file.ick01,         
          ick01_desc  LIKE ima_file.ima02,         
          ickuser     LIKE ick_file.ickuser,      
          ickgrup     LIKE ick_file.ickgrup,       
          ickmodu     LIKE ick_file.ickmodu,       
          ickdate     LIKE ick_file.ickdate,       
          ickacti     LIKE ick_file.ickacti        
                    END RECORD, 
       g_ick_lock    RECORD LIKE ick_file.*,
       g_ick01_t     LIKE ick_file.ick01,              
       g_wc          STRING,                         
       g_sql         STRING,                           
       g_rec_b       LIKE type_file.num5,
       g_ick         DYNAMIC ARRAY OF RECORD      #等旯
           ick02          LIKE ick_file.ick02,      
           ick02_desc     LIKE ima_file.ima02,      
           ick09          LIKE ick_file.ick09,      
           pmc03          LIKE pmc_file.pmc03,      
           ick03          LIKE ick_file.ick03,      
           ick05          LIKE ick_file.ick05,      
           ick06          LIKE ick_file.ick06,      
           ick07          LIKE ick_file.ick07,      
           ick08          LIKE ick_file.ick08,      
           ick10          LIKE ick_file.ick10,      
           ick04          LIKE ick_file.ick04       
                     END RECORD,
       g_ick_t       RECORD                      #等旯導硉   
           ick02          LIKE ick_file.ick01,      
           ick02_desc     LIKE ima_file.ima02,      
           ick09          LIKE ick_file.ick09,      
           pmc03          LIKE pmc_file.pmc03,     
           ick03          LIKE ick_file.ick03,     
           ick05          LIKE ick_file.ick05,
           ick06          LIKE ick_file.ick06,
           ick07          LIKE ick_file.ick07,
           ick08          LIKE ick_file.ick08,
           ick10          LIKE ick_file.ick10,
           ick04          LIKE ick_file.ick04
                     END RECORD,
       g_ick_o       RECORD                       #等旯導硉  
           ick02          LIKE ick_file.ick01,     
           ick02_desc     LIKE ima_file.ima02,      
           ick09          LIKE ick_file.ick09,      
           pmc03          LIKE pmc_file.pmc03,     
           ick03          LIKE ick_file.ick03,      
           ick05          LIKE ick_file.ick05,
           ick06          LIKE ick_file.ick06,
           ick07          LIKE ick_file.ick07,
           ick08          LIKE ick_file.ick08,
           ick10          LIKE ick_file.ick10,
           ick04          LIKE ick_file.ick04  
                     END RECORD
      
DEFINE g_cmd                 VARCHAR(100)
DEFINE g_forupd_sql          STRING                      
DEFINE g_before_input_done   LIKE type_file.num5          
DEFINE g_chr                 LIKE ick_file.ickacti        
DEFINE g_cnt                 LIKE type_file.num10         
DEFINE g_i                   LIKE type_file.num5          
DEFINE g_msg                 LIKE type_file.chr1000       
DEFINE g_curs_index          LIKE type_file.num10         
DEFINE g_row_count           LIKE type_file.num10        
DEFINE g_jump                LIKE type_file.num10        
DEFINE mi_no_ask             LIKE type_file.num5          
DEFINE l_ac                  LIKE type_file.num5         
DEFINE g_wc2                 STRING
DEFINE g_argv1               LIKE ick_file.ick01    
DEFINE g_argv2               STRING               
DEFINE g_argv3               LIKE ick_file.ick02
DEFINE g_str                 STRING  
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   LET p_row = ARG_VAL(1)
   LET p_col = ARG_VAL(2)
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   INITIALIZE g_ickd.* TO NULL
 
   LET g_forupd_sqL = "SELECT ick02,'',ick09,'',ick03,ick05,ick06,ick07,ick08,ick10,ick04 ",
                      " FROM ick_file WHERE ick01 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i010_cl CURSOR FROM g_forupd_sql                 
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW i010_w AT p_row,p_col WITH FORM "aic/42f/aici010"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   
   LET g_action_choice = ""
   CALL i010_menu()
 
   CLOSE WINDOW i010_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i010_curs()
   
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
   CLEAR FORM 
   IF NOT cl_null(g_argv1) THEN            
      LET g_wc = " ick01 = '",g_argv1,"'"  
   ELSE                                      
      CALL cl_set_head_visible("","YES")           
      INITIALIZE g_ickd.* TO NULL     
      CONSTRUCT g_wc ON ick01,ickuser,ickgrup,ickmodu,ickdate,ickacti,
                        ick02,ick09,ick03,ick05,ick06,ick07,ick08,ick10,ick04                               
                FROM ick01,ickuser,ickgrup,ickmodu,ickdate,ickacti,
                     s_ick[1].ick02,s_ick[1].ick09,s_ick[1].ick03,
                     s_ick[1].ick05,s_ick[1].ick06,s_ick[1].ick07,
                     s_ick[1].ick08,s_ick[1].ick10,s_ick[1].ick04
                     
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(ick01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ick"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ick01
                  NEXT FIELD ick01
               WHEN INFIELD(ick02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ick02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ick02
                  NEXT FIELD ick02
               WHEN INFIELD(ick09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ick09"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ick09
                  NEXT FIELD ick09
               OTHERWISE
                  EXIT CASE
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
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ickuser', 'ickgrup') #FUN-980030
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
   END IF
   LET g_sql = "SELECT DISTINCT ick01 FROM ick_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY ick01"
   PREPARE i010_prepare FROM g_sql
   DECLARE i010_cs                                             
       SCROLL CURSOR WITH HOLD FOR i010_prepare
       
   LET g_sql = "SELECT COUNT(DISTINCT ick01) FROM ick_file ",
               " WHERE ", g_wc CLIPPED
   PREPARE i1010_precount FROM g_sql
   DECLARE i010_count CURSOR FOR i1010_precount    #垀脤戙善腔等旯軞捩杅         
  
END FUNCTION
 
FUNCTION i010_menu()   
 
   WHILE TRUE
      CALL i010_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i010_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i010_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i010_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i010_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i010_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i010_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i010_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         
         WHEN "ass"
            IF cl_chk_act_auth() THEN
               LET g_cmd = "aici009 '",g_ickd.ick01,"'"
               CALL cl_cmdrun(g_cmd)
            END IF
            
         WHEN "pin_count"                       
   	    IF cl_chk_act_auth() THEN
               LET g_cmd = "aici011 '",g_ickd.ick01,"'"
               CALL cl_cmdrun(g_cmd)
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i010_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ick),'','')
            END IF
         WHEN "related_document" 
              IF cl_chk_act_auth() THEN
                 IF g_ickd.ick01 IS NOT NULL THEN
                     LET g_doc.column1 = "ick01"
                     LET g_doc.value1 = g_ickd.ick01
                     CALL cl_doc()
               END IF
             END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i010_bp(p_ud)    
   DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ick TO s_ick.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
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
 
      #ON ACTION modify
      #   LET g_action_choice="modify"
      #   EXIT DISPLAY
 
      ON ACTION first
         CALL i010_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL i010_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION jump
         CALL i010_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION next
         CALL i010_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION last
         CALL i010_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
         
      ON ACTION ass
         LET g_action_choice='ass'
         EXIT DISPLAY
 
      ON ACTION pin_count
         LET g_action_choice='pin_count'           
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                  
         CALL cl_set_head_visible("","AUTO")       
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i010_a()     
    MESSAGE ""
    CLEAR FORM                                  
    LET g_ick01_t = NULL
    LET g_wc = NULL
    LET g_row_count = 1
    CALL cl_opmsg('a')
    IF s_shut(0) THEN
       RETURN
    END IF
    INITIALIZE g_ickd.* TO NULL
    WHILE TRUE
        LET g_ickd.ickuser = g_user
        LET g_ickd.ickgrup = g_grup              
        LET g_ickd.ickdate = g_today
        LET g_ickd.ickacti = 'Y'
        CALL i010_i("a")                        
        IF INT_FLAG THEN                        
            INITIALIZE g_ickd.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ickd.ick01 IS NULL THEN              
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
    LET g_rec_b = 0
    CALL g_ick.clear()         #ь諾等旯
    CALL i010_b()
END FUNCTION
 
FUNCTION i010_b()
    DEFINE                                                                                                                              
          l_ac_t          LIKE type_file.num5,                                            
          l_n             LIKE type_file.num5,                                          
          l_cnt           LIKE type_file.num5,    
          l_cou           LIKE type_file.num5,                                                    
          l_lock_sw       LIKE type_file.chr1,                                      
          p_cmd           LIKE type_file.chr1,                                       
          l_misc          LIKE gfe_file.gfe01,                                                           
          l_cmd           LIKE type_file.chr1000,                                                       
          l_allow_insert  LIKE type_file.num5,                                                 
          l_allow_delete  LIKE type_file.num5,     
          l_gen02         LIKE gen_file.gen02,
          l_flag          LIKE type_file.num5,
          l_condition     STRING
            
    LET g_action_choice = ""                                                                                                        
    IF s_shut(0) THEN                                                                                                               
       RETURN                                                                                                                       
    END IF                                                                                                                          
                                                                                                                                    
    IF g_ickd.ick01 IS NULL THEN                                                                                                     
       RETURN                                                                                                                       
    END IF
    IF g_ickd.ickacti='N' THEN                                                                                                        
       CALL cl_err(g_ickd.ick01,'mfg1000',0)                                                                                           
       RETURN                                                                                                                        
    END IF
    LET g_sql= "SELECT ick02,'',ick09,'',ick03,ick05,ick06,ick07,ick08,ick10,ick04 ",
               " FROM ick_file WHERE ick01 = ? AND ick02 = ? AND ick03 = ?"
    DECLARE i010_clt CURSOR FROM g_sql  
    CALL cl_opmsg('b')      
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_ick WITHOUT DEFAULTS FROM s_ick.*                
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
          INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
          APPEND ROW=l_allow_insert)
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)     
       END IF
    BEFORE ROW
       LET p_cmd = ''
       LET l_ac = ARR_CURR()   #等旯絞ヶ俴
       LET l_lock_sw = 'N'
       LET l_n = ARR_COUNT()   #等旯軞俴
               
       IF g_rec_b>=l_ac THEN   #�彆岆党蜊腔①錶
          BEGIN WORK 
          LET p_cmd = 'u'
          LET g_ick_t.* = g_ick[l_ac].*    #導硉掘爺
          LET g_ick_o.* = g_ick[l_ac].*    #導硉掘爺 
          OPEN i010_clt USING g_ickd.ick01,g_ick_t.ick02,g_ick_t.ick03
          IF SQLCA.sqlcode THEN
             CALL cl_err("OPEN i010_clt:",SQLCA.sqlcode,1)
             ROLLBACK WORK
             RETURN
          END IF
          FETCH i010_clt INTO g_ick[l_ac].*
          CALL i010_ick02()
          CALL i010_ick09()
          CLOSE i010_clt
          CALL cl_show_fld_cont()       
       END IF
    BEFORE INSERT                        
       LET l_n = ARR_COUNT()
       LET p_cmd = 'a'
       INITIALIZE g_ick[l_ac].* TO NULL
       LET g_ick[l_ac].ick05 = 'N'
       LET g_ick[l_ac].ick07 = g_today
       LET g_ick_t.* = g_ick[l_ac].*
       LET g_ick_o.* = g_ick[l_ac].*
       CALL cl_show_fld_cont()
    AFTER INSERT
       IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CANCEL INSERT
       END IF
       
       INSERT INTO ick_file(ick01,ick02,ick03,ick04,ick05,ick06,
                 ick07,ick08,ick09,ick10,ickuser,ickgrup,ickmodu,ickdate,ickacti,ickoriu,ickorig)            
         VALUES(g_ickd.ick01,g_ick[l_ac].ick02,g_ick[l_ac].ick03,
                g_ick[l_ac].ick04,g_ick[l_ac].ick05,g_ick[l_ac].ick06,
#               to_date(g_ick[l_ac].ick07,'yy-mm-dd'),g_ick[l_ac].ick08,g_ick[l_ac].ick09,  #mark
                g_ick[l_ac].ick07,g_ick[l_ac].ick08,g_ick[l_ac].ick09,  #modify
                g_ick[l_ac].ick10,
                g_ickd.ickuser,g_ickd.ickgrup,g_ickd.ickmodu,g_ickd.ickdate,g_ickd.ickacti, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
       IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","ick_file",g_ick[l_ac].ick02,g_ickd.ick01,SQLCA.sqlcode,"","",1)
           CANCEL INSERT
       ELSE
           MESSAGE 'INSERT OK'
           LET g_rec_b = g_rec_b + 1
           DISPLAY g_rec_b TO FORMONLY.cn2
       END IF
       
       AFTER FIELD ick02
           IF NOT cl_null(g_ick[l_ac].ick02) THEN
              #FUN-AA0059 ---------------------add start-------------------
               IF NOT s_chk_item_no(g_ick[l_ac].ick02,'') THEN
                  CALL cl_err('',g_errno,1)
                  LET g_ick[l_ac].ick02 = g_ick_t.ick02
                  NEXT FIELD ick02
               END IF
              #FUN-AA0059 ----------------add end-----------------------   
               IF  g_ick[l_ac].ick02 != g_ick_t.ick02 OR g_ick_t.ick02 IS NULL THEN
                   CALL check_exist("ima01",g_ick[l_ac].ick02,"ima_file","imaacti = 'Y'")
                          RETURNING l_flag                       
                   IF l_flag = 0 THEN
                      CALL cl_err('',10082,0)
                      LET g_ick[l_ac].ick02 = g_ick_t.ick02
                      NEXT FIELD ick02
                   ELSE
                      CALL i010_ick02()
                      LET l_condition = "ick02='",g_ick[l_ac].ick02, "' AND ick09='",g_ick[l_ac].ick09,"'"
                      CALL check_exist("ick01",g_ickd.ick01,"ick_file",l_condition) RETURNING l_flag 
                      IF l_flag > 0 THEN
                         CALL cl_err('',-239,0)
                         LET g_ick[l_ac].ick02 = g_ick_t.ick02
                         NEXT FIELD ick02
                      END IF
                   END IF
               END IF
           END IF
       AFTER FIELD ick09
           IF NOT cl_null(g_ick[l_ac].ick09) THEN
              IF g_ick[l_ac].ick09 != g_ick_t.ick09 OR g_ick_t.ick09 IS NULL THEN
                 CALL check_exist("pmc01",g_ick[l_ac].ick09,"pmc_file","pmcacti = 'Y'")
                             RETURNING l_flag                           
                 IF l_flag = 0 THEN
                    CALL cl_err('',10083,0)
                    LET g_ick[l_ac].ick09 = g_ick_t.ick09
                    NEXT FIELD ick09
                 ELSE
                    CALL i010_ick09()
                    LET l_condition = "ick02='",g_ick[l_ac].ick02, "' AND ick09='",g_ick[l_ac].ick09,"'"
                    CALL check_exist("ick01",g_ickd.ick01,"ick_file",l_condition) RETURNING l_flag 
                    IF l_flag > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_ick[l_ac].ick09 = g_ick_t.ick09
                       NEXT FIELD ick09
                    END IF
                 END IF
              END IF                                                                   
           END IF       
       BEFORE DELETE 
           IF g_ick_t.ick02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
               END IF
               IF l_lock_sw = 'Y' THEN 
                   CALL cl_err("",263,1)
                   CANCEL DELETE
               END IF
               DELETE FROM ick_file 
                 WHERE ick01 = g_ickd.ick01 AND ick02 = g_ick[l_ac].ick02 AND ick03 = g_ick[l_ac].ick03
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","ick_file",g_ickd.ick01,g_ick_t.ick02,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
               END IF
               LET g_rec_b = g_rec_b - 1
               DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
      ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ick[l_ac].ick02,-263,1)
              LET g_ick[l_ac].* = g_ick_t.*
           ELSE
              UPDATE ick_file                                                                                                      
                  SET ick02=g_ick[l_ac].ick02,                                                                                         
                      ick03=g_ick[l_ac].ick03,                                                                                         
                      ick04=g_ick[l_ac].ick04,                                                                                         
                      ick05=g_ick[l_ac].ick05,
                      ick06=g_ick[l_ac].ick06,
                      ick07=g_ick[l_ac].ick07,  
                      ick08=g_ick[l_ac].ick08,
                      ick09=g_ick[l_ac].ick09,
                      ick10=g_ick[l_ac].ick10
              WHERE ick02=g_ick_t.ick02 AND ick01=g_ickd.ick01 AND ick03=g_ick_t.ick03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err(g_ick[l_ac].ick02,SQLCA.sqlcode,0)
                 LET g_ick[l_ac].* = g_ick_t.*
                 ROLLBACK WORK
                 RETURN
              END IF
           END IF
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac#FUN-D40030 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_ick[l_ac].* = g_ick_t.*
           #FUN-D40030--add--str
            ELSE
               CALL g_ick.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
           #FUN-D40030--add--end
            END IF
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac#FUN-D40030 add
            
       ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
             CASE
               WHEN INFIELD(ick02)
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form ="q_ima"
                #  LET g_qryparam.default1 = g_ick[l_ac].ick02
                #  CALL cl_create_qry() RETURNING g_ick[l_ac].ick02
                  CALL q_sel_ima(FALSE, "q_ima", "", g_ick[l_ac].ick02, "", "", "", "" ,"",'' )  RETURNING g_ick[l_ac].ick02
#FUN-AA0059 --End--
                  DISPLAY BY NAME g_ick[l_ac].ick02
                  CALL i010_ick02()
                  NEXT FIELD ick02
               WHEN INFIELD(ick09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pmc13"
                  LET g_qryparam.default1 = g_ick[l_ac].ick09
                  CALL cl_create_qry() RETURNING g_ick[l_ac].ick09
                  DISPLAY BY NAME g_ick[l_ac].ick09
                  CALL i010_ick09()
                  NEXT FIELD ick09
               OTHERWISE
                  EXIT CASE
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
 
      ON ACTION controls                                       
         CALL cl_set_head_visible("","AUTO")
   END INPUT
   UPDATE ick_file SET ickmodu=g_user,ickdate=g_today                                                                    
       WHERE ick01=g_ickd.ick01                                                                                         
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                         
      CALL cl_err('',SQLCA.sqlcode,0)                                                                                    
      LET g_ick[l_ac].* = g_ick_t.*                                                                                      
      ROLLBACK WORK                                                                                                      
      RETURN                                                                                                             
   END IF
   MESSAGE 'UPDATE O.K'
   DISPLAY g_user,g_today TO ickmodu,ickdate 
   COMMIT WORK
   
END FUNCTION
 
FUNCTION i010_ick02()          #湍堤擊弇
 
   SELECT ima02 INTO g_ick[l_ac].ick02_desc 
     FROM ima_file
   WHERE ima01 = g_ick[l_ac].ick02
   DISPLAY BY NAME g_ick[l_ac].ick02_desc
   
END FUNCTION
FUNCTION i010_ick09()         #湍堤擊弇
 
   SELECT pmc03 INTO g_ick[l_ac].pmc03 
     FROM pmc_file
   WHERE pmc01 = g_ick[l_ac].ick09
   DISPLAY BY NAME g_ick[l_ac].pmc03
   
END FUNCTION
#潰脤珨跺硉岆瘁婓桶爵ㄛ殿隙腔l_count腔硉憩岆跦擂沭璃脤戙善腔賦彆
#p_field         潰脤腔擊弇
#p_value         絞ヶ擊弇腔硉
#p_table         脤戙腔桶
#p_condition     蜇樓沭璃
FUNCTION check_exist(p_field,p_value,p_table,p_condition)
   DEFINE  p_value         STRING,
           p_table         STRING,
           p_condition     STRING,
           p_field         STRING,
           l_count         LIKE type_file.num5,
           l_sql           STRING
           
   LET l_sql = "SELECT COUNT(*) FROM ",p_table," WHERE ",p_condition," AND ",p_field,"='",p_value,"'"
   PREPARE i010_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err(" ",SQLCA.sqlcode,1)
      RETURN 0
   END IF
   DECLARE i010_pcl CURSOR FOR i010_pre
   OPEN i010_pcl  
   FETCH i010_pcl INTO l_count
   
   RETURN l_count
END FUNCTION
 
FUNCTION i010_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,          
            l_gen02   LIKE gen_file.gen02,
            l_gem02   LIKE gem_file.gem02,
            l_input   LIKE type_file.chr1,           
            l_n       LIKE type_file.num5,            
            l_flag    LIKE type_file.num5
 
 
   DISPLAY BY NAME
      g_ickd.ick01,g_ickd.ickacti,g_ickd.ickuser, 
      g_ickd.ickgrup,g_ickd.ickmodu,g_ickd.ickdate    
   CALL cl_set_head_visible("","yes")
   INPUT BY NAME g_ickd.ick01 WITHOUT DEFAULTS
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i010_set_entry(p_cmd)
          CALL i010_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD ick01
         IF g_ickd.ick01 IS NULL THEN
            CALL cl_err('ick01','aap-099',0)
            NEXT FIELD ick01
         END IF
        #FUN-AA0059 -----------------add start---------------
         IF NOT cl_null(g_ickd.ick01) THEN
            IF NOT s_chk_item_no(g_ickd.ick01,'') THEN
               CALL cl_err('',g_errno,1)
               LET g_ickd.ick01 = g_ick01_t
               DISPLAY BY NAME g_ickd.ick01
               NEXT FIELD ick01
            END IF
         END IF
        #FUN-AA0059 -----------------add end----------------
         IF p_cmd = "a" OR                    
            (p_cmd = "u" AND g_ickd.ick01 != g_ick01_t) THEN
            SELECT count(*) INTO l_n FROM ick_file WHERE ick01 = g_ickd.ick01
            IF l_n > 0 THEN                  
               CALL cl_err(g_ickd.ick01,-239,1)
               LET g_ickd.ick01 = g_ick01_t
               DISPLAY BY NAME g_ickd.ick01
               LET l_n = 0
               NEXT FIELD ick01
            END IF
            CALL check_exist("ima01",g_ickd.ick01,"ima_file","imaacti = 'Y'")
                             RETURNING l_flag                         
            IF l_flag = 0 THEN
               CALL cl_err('',100,0)
               LET g_ickd.ick01 = g_ick01_t
               NEXT FIELD ick01
            END IF
            CALL i010_ick01()          
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ickd.ick01,g_errno,1)
               LET g_ickd.ick01 = g_ick01_t
               DISPLAY BY NAME g_ickd.ick01
            END IF
         END IF
       
       AFTER INPUT
          LET g_ickd.ickuser = s_get_data_owner("ick_file") #FUN-C10039
          LET g_ickd.ickgrup = s_get_data_group("ick_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
            IF g_ickd.ick01 IS NULL THEN
               CALL cl_err('',101,0)
               NEXT FIELD ick01
            END IF    
                                                                                                        
      ON ACTION CONTROLO                       
         IF INFIELD(ick01) THEN
            CALL i010_show()
            NEXT FIELD ick01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(ick01)
#FUN-AA0059 --Begin--
            #  CALL cl_init_qry_var()
            #  LET g_qryparam.form = "q_ima"
            #  LET g_qryparam.default1 = g_ickd.ick01
            #  CALL cl_create_qry() RETURNING g_ickd.ick01
              CALL q_sel_ima(FALSE, "q_ima", "", g_ickd.ick01, "", "", "", "" ,"",'' )  RETURNING g_ickd.ick01
#FUN-AA0059 --End--
              DISPLAY BY NAME g_ickd.ick01
	      CALL i010_ick01() 
           OTHERWISE
              EXIT CASE
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
 
END FUNCTION
 
FUNCTION i010_ick01()
DEFINE          
   l_gen03    LIKE gen_file.gen03,
   l_ickacti  LIKE ick_file.ickacti,
   l_gem02    LIKE gem_file.gem02
 
   LET g_errno=''
   SELECT ima02
     INTO g_ickd.ick01_desc
     FROM ima_file
   WHERE ima01=g_ickd.ick01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ick-070'
       WHEN l_ickacti='N'       LET g_errno='9028'
       WHEN SQLCA.sqlcode=0     DISPLAY BY NAME g_ickd.ick01_desc
       OTHERWISE                LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
END FUNCTION
FUNCTION check()
   CALL s_icdpost(0,'001','002','tlf','007','T',50,'0724','ttt','2007/07/04','Y','555','55','') 
END FUNCTION
FUNCTION i010_q()
    CALL check()
{    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_ickd.* TO NULL  
    CALL g_ick.clear()           
    MESSAGE ""
    CALL cl_opmsg('q')
    
    CALL i010_curs()                      
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i010_cs                         
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ickd.ick01,SQLCA.sqlcode,0)
        INITIALIZE g_ickd.* TO NULL
    ELSE
        OPEN i010_count
        FETCH i010_count INTO g_row_count                      
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i010_fetch('F')                                  
    END IF
}   
END FUNCTION
 
FUNCTION i010_fetch(p_flick)
    DEFINE
        p_flick         LIKE type_file.chr1            
    CASE p_flick
        WHEN 'N' FETCH NEXT     i010_cs INTO g_ickd.ick01
        WHEN 'P' FETCH PREVIOUS i010_cs INTO g_ickd.ick01
        WHEN 'F' FETCH FIRST    i010_cs INTO g_ickd.ick01
        WHEN 'L' FETCH LAST     i010_cs INTO g_ickd.ick01
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
        FETCH ABSOLUTE g_jump i010_cs INTO g_ickd.ick01
        LET mi_no_ask = FALSE         
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ickd.ick01,SQLCA.sqlcode,0)
        INITIALIZE g_ickd.* TO NULL   
        #LET g_ick_rowid = NULL        #mark by liuxqa 091020
        RETURN
    ELSE
      CASE p_flick       
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT DISTINCT ick01,'',ickuser,ickgrup,ickmodu,ickdate,ickacti
       INTO g_ickd.* FROM ick_file 
    WHERE ick01 = g_ickd.ick01
 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ick_file",g_ickd.ick01,"",SQLCA.sqlcode,"","",0)   
    ELSE
        LET g_data_owner=g_ickd.ickuser            
        LET g_data_group=g_ickd.ickgrup
        CALL i010_show()                   
    END IF
END FUNCTION
 
FUNCTION i010_show()
    DISPLAY BY NAME g_ickd.*
    CALL i010_ick01()
    CALL i010_b_fill(g_wc)
    CALL cl_show_fld_cont()                  
END FUNCTION
 
FUNCTION i010_b_fill(p_wc)  
   DEFINE p_wc   STRING
 
   LET g_sql = "SELECT ick02,'',ick09,'',ick03,ick05,ick06,ick07,ick08,ick10,ick04", 
               " FROM ick_file ",  
               " WHERE ick01='",g_ickd.ick01,"' AND "   
 
   IF NOT cl_null(p_wc) THEN
      LET g_sql=g_sql,p_wc CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY ick02 "  
 
   PREPARE i010_pb FROM g_sql
   DECLARE ick_cs CURSOR FOR i010_pb
 
   CALL g_ick.clear()
   LET g_cnt = 1
 
   FOREACH ick_cs INTO g_ick[g_cnt].*  
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT ima02 INTO g_ick[g_cnt].ick02_desc 
         FROM ima_file
       WHERE ima01 = g_ick[g_cnt].ick02
       
       SELECT pmc03 INTO g_ick[g_cnt].pmc03 
         FROM pmc_file
       WHERE pmc01 = g_ick[g_cnt].ick09
       DISPLAY BY NAME g_ick[g_cnt].ick02_desc
       DISPLAY BY NAME g_ick[g_cnt].pmc03
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ick.deleteElement(g_cnt)
  
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
   CLOSE ick_cs
END FUNCTION
 
FUNCTION i010_u()
    IF g_ickd.ick01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_chkey = 'N' THEN
       CALL cl_err('ick01','ick9008',0)
       RETURN
    END IF
    SELECT DISTINCT ick01,'',ickuser,ickgrup,ickmodu,ickdate,ickacti
       INTO g_ickd.* FROM ick_file 
    WHERE ick01=g_ickd.ick01
    CALL i010_show()
    IF g_ickd.ickacti = 'N' THEN
        CALL cl_err('',9027,1) 
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    LET g_ickd.ickmodu=g_user                 
    LET g_ickd.ickdate = g_today             
    CALL i010_show()                         
    OPEN i010_cl USING g_ickd.ick01
    WHILE TRUE
        LET g_ick01_t = g_ickd.ick01
        LET g_ickd.ickdate = g_today
        LET g_ickd.ickmodu = g_user
        CALL i010_i("u")                    
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL i010_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE ick_file SET ick01 = g_ickd.ick01, 
                            ickuser = g_ickd.ickuser,
                            ickgrup = g_ickd.ickgrup,
                            ickmodu = g_ickd.ickmodu,
                            ickdate = g_ickd.ickdate,
                            ickacti = g_ickd.ickacti
            WHERE ick01 = g_ick01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ick_file",g_ickd.ick01,"",SQLCA.sqlcode,"","",0)   
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i010_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i010_x()
    IF g_ickd.ick01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    BEGIN WORK
 
    SELECT DISTINCT ick01,'',ickuser,ickgrup,ickmodu,ickdate,ickacti
       INTO g_ickd.* FROM ick_file 
    WHERE ick01=g_ickd.ick01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ickd.ick01,SQLCA.sqlcode,1)
       ROLLBACK WORK
       RETURN
    END IF
    LET g_wc =" 1=1"
    CALL i010_show()
    OPEN i010_cl USING g_ickd.ick01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ickd.ick01,SQLCA.sqlcode,1)
       ROLLBACK WORK
       RETURN
    END IF  
    IF cl_exp(0,0,g_ickd.ickacti) THEN
        LET g_chr=g_ickd.ickacti
        IF g_ickd.ickacti='Y' THEN
            LET g_ickd.ickacti='N'
        ELSE
            LET g_ickd.ickacti='Y'
        END IF
        UPDATE ick_file
            SET ickacti=g_ickd.ickacti
            WHERE ick01=g_ickd.ick01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_ickd.ick01,SQLCA.sqlcode,0)
            LET g_ickd.ickacti=g_chr
        END IF
        DISPLAY BY NAME g_ickd.ickacti
    END IF
    CLOSE i010_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i010_r()
 
    IF s_shut(0) THEN
      RETURN
    END IF
    IF g_ickd.ick01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    SELECT DISTINCT ick01,'',ickuser,ickgrup,ickmodu,ickdate,ickacti
       INTO g_ickd.* FROM ick_file 
    WHERE ick01=g_ickd.ick01
    CALL i010_show()
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ickd.ick01,SQLCA.sqlcode,1)
       RETURN
    END IF
    IF g_ickd.ickacti ='N' THEN   
        CALL cl_err(g_ickd.ick01,'mfg1000',1)
        RETURN
    END IF
    BEGIN WORK
    OPEN i010_cl USING g_ickd.ick01
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ick01"          #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ickd.ick01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
       DELETE FROM ick_file WHERE ick01 = g_ickd.ick01
       CLEAR FORM
       CALL g_ick.clear();
       OPEN i010_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i010_cs
          CLOSE i010_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i010_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i010_cs
          CLOSE i010_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i010_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i010_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE                  
          CALL i010_fetch('/')
       END IF
    END IF
    CLOSE i010_cs
    CLOSE i010_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i010_copy()
    DEFINE
           l_newno         LIKE ick_file.ick01,
           l_oldno         LIKE ick_file.ick01,
           p_cmd           LIKE type_file.chr1,           
           l_input         LIKE type_file.chr1,
           l_n             LIKE type_file.num5,
           l_flag          LIKE type_file.num5      
 
    IF g_ickd.ick01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    LET g_ick01_t = g_ickd.ick01
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i010_set_entry('a')
    LET g_before_input_done = TRUE
    BEGIN WORK
    INPUT l_newno FROM ick01
 
        AFTER FIELD ick01
           IF g_ickd.ick01 IS NULL THEN
              CALL cl_err('ick01','aap-099',0)
              NEXT FIELD ick01
           END IF
          #FUN-AA0059 ---------------add start----------
           IF NOT s_chk_item_no(g_ickd.ick01,'') THEN
              CALL cl_err('',g_errno,1)
              LET g_ickd.ick01 = g_ick01_t
              DISPLAY BY NAME g_ickd.ick01
              NEXT FIELD ick01
           END IF
          #FUN-AA0059 ---------------add end--------------- 
           SELECT count(*) INTO l_n FROM ick_file WHERE ick01 = l_newno
           IF l_n > 0 THEN                  
              CALL cl_err(g_ickd.ick01,-239,1)
              LET g_ickd.ick01 = g_ick01_t
              DISPLAY BY NAME g_ickd.ick01
              LET l_n = 0
              NEXT FIELD ick01
           END IF
           CALL check_exist("ima01",l_newno,"ima_file","imaacti = 'Y'")
                             RETURNING l_flag                         
           IF l_flag = 0 THEN
              CALL cl_err('',100,0)
              LET g_ickd.ick01 = g_ick01_t
              NEXT FIELD ick01
           END IF
           CALL i010_ick01()          
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_ickd.ick01,g_errno,1)
              LET g_ickd.ick01 = g_ick01_t
              DISPLAY BY NAME g_ickd.ick01
           END IF
 
        ON ACTION controlp                      
           IF INFIELD(ick01) THEN
#FUN-AA0059 --Begin--
            #  CALL cl_init_qry_var()
            #  LET g_qryparam.form = "q_ima"
            #  LET g_qryparam.default1 = g_ickd.ick01
            #  CALL cl_create_qry() RETURNING l_newno
              CALL q_sel_ima(FALSE, "q_ima", "", g_ickd.ick01, "", "", "", "" ,"",'' )  RETURNING l_newno
#FUN-AA0059 --End--  
              DISPLAY l_newno TO ick01                 
              CALL i010_ick01()
              NEXT FIELD ick01
           END IF
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
        DISPLAY BY NAME g_ickd.ick01
        RETURN
    END IF
    DROP TABLE x
    SELECT *
       FROM ick_file
    WHERE ick01=g_ickd.ick01
    INTO TEMP x
    UPDATE x
        SET ick01=l_newno,    
            ickacti='Y',     
            ickuser=g_user,  
            ickgrup=g_grup,  
            ickmodu=NULL,    
            ickdate=g_today  
    INSERT INTO ick_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","ick_file",g_ickd.ick01,"",SQLCA.sqlcode,"","",0)  
        ROLLBACK WORK
        RETURN
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_ickd.ick01
        #LET g_ickd.ick01 = l_newno
        SELECT DISTINCT g_ickd.ick01,g_ickd.ickuser,g_ickd.ickgrup,g_ickd.ickmodu,g_ickd.ickdate,g_ickd.ickacti 
           INTO g_ickd.* FROM ick_file
        WHERE ick01 = l_newno 
    END IF
    COMMIT WORK
   # CALL i010_u()
    CALL i010_b()
    CALL i010_show()
END FUNCTION
 
FUNCTION i010_out()
 
   IF g_ickd.ick01 IS NULL THEN
      RETURN
   END IF
   IF cl_null(g_wc) THEN
      LET g_wc = " ick01='",g_ickd.ick01,"'"
   END IF
   CALL cl_wait()
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   LET g_sql="SELECT distinct ick01,ick02,ick03,ick04,ick05,ick06,ick07,ick08,",
             " ick09,ick10,A.ima02 ick01_desc,B.ima02 ick02_desc,pmc03 ", 
             " FROM ick_file,ima_file A,ima_file B,pmc_file ",  
             " WHERE ick01=A.ima01 and ick02=B.ima01 and ick09=pmc01 AND ",g_wc CLIPPED,
             " ORDER BY ick01,ick02,ick03 "                                                                                                            
   IF g_zz05 = 'Y' THEN                                                                                                           
      CALL cl_wcchp(g_wc,'ick01,ick02,ick03')                                                                              
      RETURNING g_wc                                                                                                             
      LET g_str = g_wc                                                                                                           
   END IF 
   LET g_str =g_str,";",g_azi07                                                                                    
   CALL cl_prt_cs1('aici010','aici010',g_sql,g_str)
END FUNCTION  
FUNCTION i010_set_entry(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1     
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ick01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i010_set_no_entry(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1     
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ick01",FALSE)
    END IF
 
END FUNCTION                                                 

