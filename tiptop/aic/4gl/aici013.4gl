# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: aici013.4gl
# Descriptions...: ICD蹋璃狟論秶最蹋瘍峎誘釬珛
# Date & Author..: 07/11/14 By xiaofeizhu
# Modify.........: No.FUN-830068 08/03/20 By xiaofeizhu 加入相關文件功能
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/28 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-C20544 12/02/29 By bart 恢復此程式
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_icm01   LIKE icm_file.icm01, 
         g_ima02_a     LIKE ima_file.ima02,
         g_icm01_t LIKE icm_file.icm01, 
         g_icm_lock RECORD LIKE icm_file.*,  # FOR LOCK CURSOR TOUCH
         g_icm_info RECORD 
            icmuser LIKE icm_file.icmuser,
            icmmodu LIKE icm_file.icmmodu,
            icmgrup LIKE icm_file.icmgrup,
            icmdate LIKE icm_file.icmdate,
            icmacti LIKE icm_file.icmacti
                       END RECORD,
         g_icm      DYNAMIC ARRAY of RECORD     
            icm02   LIKE icm_file.icm02,
            ima02_b LIKE ima_file.ima02,
            icm03   LIKE icm_file.icm03
                       END RECORD,
         g_icm_t    RECORD                    
            icm02   LIKE icm_file.icm02,
            ima02_b LIKE ima_file.ima02,
            icm03   LIKE icm_file.icm03
                       END RECORD,
         g_wc          string,  
         g_argv1       STRING,  
         g_sql         STRING,  
         g_rec_b       LIKE type_file.num5,                  
         l_ac          LIKE type_file.num5                    
DEFINE   g_cnt                 LIKE type_file.num10   
DEFINE   g_cnt2                LIKE type_file.num10
DEFINE   g_msg                 LIKE type_file.chr1000
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5
DEFINE   g_curs_index          LIKE type_file.num10     
DEFINE   g_row_count           LIKE type_file.num10    
DEFINE   g_jump                LIKE type_file.num10     
DEFINE   g_no_ask              LIKE type_file.num5
DEFINE   g_ss                  LIKE type_file.chr1
DEFINE   g_chr                 LIKE type_file.chr1
 
MAIN
   OPTIONS                                        
      INPUT NO WRAP
   DEFER INTERRUPT                               
 
   LET g_argv1=ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry("icd") THEN                                                                                                    
      CALL cl_err('','aic-999',1)
      EXIT PROGRAM                                                                                      
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * from icm_file ",
                      "  WHERE icm01 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i013_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i013_w WITH FORM "aic/42f/aici013"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN
      CALL i013_q()
   END IF
 
   CALL i013_menu() 
 
   CLOSE WINDOW i013_w                       

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i013_curs()                       
   CLEAR FORM                                   
   CALL g_icm.clear()
 
   IF cl_null(g_argv1) THEN
      CONSTRUCT BY NAME g_wc ON icm01,icm02,icm03
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(icm01)
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form = "q_ima"
                #  LET g_qryparam.state = "c"
                #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO icm01
                  CALL i013_icm01('d')
                  NEXT FIELD icm01
               WHEN INFIELD(icm02)
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.form = "q_ima"
               #   LET g_qryparam.state = "c"
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO icm02
                  NEXT FIELD icm02
                  OTHERWISE EXIT CASE
               END CASE
 
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
               CALL g_icm.clear()
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
            ON ACTION help
               CALL cl_show_help()
 
            ON ACTION CONTROLG
               CALL cl_cmdask()
 
            ON ACTION about
               CALL cl_about()
 
            ON ACTION qbe_select
               CALL cl_qbe_select()
 
            ON ACTION qbe_save
               CALL cl_qbe_save()
 
         END CONSTRUCT
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond('icmuser', 'icmgrup') #FUN-980030
   ELSE
      LET g_wc="icm01='",g_argv1,"'"
   END IF
 
   IF INT_FLAG THEN RETURN END IF
 
   LET g_sql= "SELECT UNIQUE icm01 ",
              "  FROM icm_file ",
              " WHERE ", g_wc CLIPPED
   PREPARE i013_prepare FROM g_sql         
   DECLARE i013_b_curs                      
      SCROLL CURSOR WITH HOLD FOR i013_prepare
 
END FUNCTION
 
 
FUNCTION i013_count()
   DEFINE la_icm    RECORD        
             icm01 LIKE icm_file.icm01
                       END RECORD
 
   DEFINE li_cnt       LIKE type_file.num10
   DEFINE li_rec_b     LIKE type_file.num10
 
   LET g_sql= "SELECT UNIQUE icm01 ",
              "  FROM icm_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY icm01"
 
   PREPARE i013_precount FROM g_sql
   DECLARE i013_count CURSOR FOR i013_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH i013_count INTO la_icm.*  
      LET li_rec_b = li_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         LET li_rec_b = li_rec_b - 1
         EXIT FOREACH
      END IF
      LET li_cnt = li_cnt + 1
   END FOREACH
   LET g_row_count=li_rec_b
 
END FUNCTION
 
FUNCTION i013_menu()
 
   WHILE TRUE
      CALL i013_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                        
            IF cl_chk_act_auth() THEN
               CALL i013_a()
            END IF
         WHEN "modify"                         
            IF cl_chk_act_auth() THEN
               CALL i013_u()
            END IF
 
         WHEN "invalid"                                                                                                             
            IF cl_chk_act_auth() THEN                                                                                               
               CALL i013_x()                                                                                                        
            END IF
 
         WHEN "reproduce"                     
            IF cl_chk_act_auth() THEN
               CALL i013_copy()
            END IF
         WHEN "delete"                      
            IF cl_chk_act_auth() THEN
               CALL i013_r()
            END IF
         
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i013_q()
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i013_out()
            END IF
 
         #No.FUN-830068-------add--------str----                                                                                    
         WHEN "related_document"  #相關文件                                                                                         
            IF cl_chk_act_auth() THEN                                                                                               
               IF g_icm01 IS NOT NULL THEN                                                                                      
                 LET g_doc.column1 = "icm01"                                                                                        
                 LET g_doc.value1 = g_icm01                                                                                     
                 CALL cl_doc()                                                                                                      
               END IF                                                                                                               
           END IF                                                                                                                   
        #No.FUN-830068-------add--------end---- 
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i013_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                       
            CALL cl_show_help()
         WHEN "exit"                      
            EXIT WHILE
         WHEN "controlg"                 
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_icm),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i013_a()                     
   MESSAGE ""
   CLEAR FORM
   CALL g_icm.clear()
 
   INITIALIZE g_icm01   LIKE icm_file.icm01  
   INITIALIZE g_icm01_t LIKE icm_file.icm01 
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_icm_info.icmuser=g_user                                                                                            
      LET g_icm_info.icmgrup=g_grup                                                                                            
      LET g_icm_info.icmdate=g_today                                                                                           
      LET g_icm_info.icmacti='Y'
      CALL i013_i("a")                   
 
      IF INT_FLAG THEN                     
         LET g_icm01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_icm01) THEN
         CONTINUE WHILE
      END IF
 
      LET g_rec_b = 0
 
      IF g_ss = 'N' THEN
         CALL g_icm.clear()
      ELSE
         CALL i013_b_fill(' 1=1')
      END IF
      LET g_icm01_t=g_icm01
      CALL i013_b()                        
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i013_i(p_cmd)                    
   DEFINE   p_cmd        LIKE type_file.chr1                 
   DEFINE   p_ima02      LIKE ima_file.ima02  
   DEFINE   l_n          LIKE type_file.num5
 
  
   LET g_ss = 'Y'
 
   INPUT g_icm01 WITHOUT DEFAULTS FROM icm01
 
      AFTER INPUT
         IF NOT cl_null(g_icm01) THEN
            IF g_icm01 != g_icm01_t OR cl_null(g_icm01_t) THEN
               LET g_cnt=0
               SELECT COUNT(*) INTO g_cnt FROM ima_file
                WHERE ima01 = g_icm01 AND imaacti='Y'
               IF g_cnt = 0 THEN
                  CALL cl_err(g_icm01,'mfg3403',0)
                  LET g_icm01 = g_icm01_t
                  NEXT FIELD icm01
               END IF
               LET g_cnt=0
               SELECT COUNT(UNIQUE icm01) INTO g_cnt FROM icm_file
                WHERE icm01 = g_icm01 
               IF g_cnt = 0 THEN
                  IF p_cmd = 'a' THEN
                     LET g_ss='N'
                  END IF
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_icm01,-239,0)
                     LET g_icm01 = g_icm01_t
                     NEXT FIELD icm01
                  END IF
               END IF
               IF p_cmd='u' THEN
                  FOR l_n =1 TO g_rec_b
                     IF g_icm[l_n].icm02 = g_icm01 THEN
                        CALL cl_err(g_icm01,'aic-801',1)
                        LET g_icm01 = g_icm01_t
                        NEXT FIELD icm01
                        EXIT FOR
                     END IF
                  END FOR
               END IF
            END IF
         END IF
         CALL i013_ima02(g_icm01) RETURNING p_ima02
         DISPLAY p_ima02 TO ima02_a
         CALL i013_show()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(icm01)
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  LET g_qryparam.form = "q_ima"
             #  LET g_qryparam.default1= g_icm01
             #  CALL cl_create_qry() RETURNING g_icm01
               CALL q_sel_ima(FALSE, "q_ima", "", g_icm01, "", "", "", "" ,"",'' )  RETURNING g_icm01
#FUN-AA0059 --End--
               CALL i013_icm01('d')
               NEXT FIELD icm01
 
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
END FUNCTION
 
 
FUNCTION i013_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_icm01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_chkey = 'N' THEN
      CALL cl_err(g_icm01,'aoo-085',1)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_icm01_t = g_icm01
 
   BEGIN WORK
   OPEN i013_cl USING g_icm01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)    
      CLOSE i013_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i013_cl INTO g_icm_lock.* 
   IF SQLCA.sqlcode THEN
      CALL cl_err("icm01 LOCK:",SQLCA.sqlcode,1)
      CLOSE i013_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL i013_i("u")
      IF INT_FLAG THEN
         LET g_icm01 = g_icm01_t
         LET g_icm_info.icmmodu=g_user                                                                                            
         LET g_icm_info.icmdate=g_today
         DISPLAY BY NAME g_icm01
         CALL i013_icm01('d')
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_icm01 != g_icm01_t THEN    
         UPDATE icm_file SET icm01 = g_icm01
          WHERE icm01 = g_icm01_t
                  
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err(g_icm01,SQLCA.sqlcode,0)
            CONTINUE WHILE
         END IF
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
   CLOSE i013_cl
END FUNCTION
 
FUNCTION i013_q()
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM
   CALL g_icm.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL i013_curs()                        
   IF INT_FLAG THEN                             
      LET INT_FLAG = 0
      INITIALIZE g_icm01 TO NULL
      CALL g_icm.clear()
      RETURN
   END IF
 
   OPEN i013_b_curs                         
   IF SQLCA.SQLCODE THEN                         
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_icm01 TO NULL
   ELSE
      CALL i013_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i013_fetch('F')              
    END IF
END FUNCTION
 
FUNCTION i013_fetch(p_flag)          
   DEFINE   p_flag   LIKE type_file.chr1           
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i013_b_curs INTO g_icm01
      WHEN 'P' FETCH PREVIOUS i013_b_curs INTO g_icm01
      WHEN 'F' FETCH FIRST    i013_b_curs INTO g_icm01
      WHEN 'L' FETCH LAST     i013_b_curs INTO g_icm01
      WHEN '/' 
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION controlg
                  CALL cl_cmdask()
 
               ON ACTION help
                  CALL cl_show_help()
 
               ON ACTION about
                  CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               CALL g_icm.clear()
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i013_b_curs INTO g_icm01
         LET g_no_ask = FALSE   
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_icm01,SQLCA.sqlcode,0)
      LET g_icm01 = NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump  
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      SELECT icmuser,icmmodu,icmgrup,icmdate,icmacti INTO g_icm_info.* 
      FROM icm_file WHERE icm01 = g_icm01
#     IF SQLCA.sqlcode THEN
#     INITIALIZE g_icm_info.* TO NULL
#     END IF
      CALL i013_show()
   END IF
END FUNCTION
 
FUNCTION i013_show()                        
   DEFINE p_ima02 LIKE ima_file.ima02
 
   LET g_icm01_t = g_icm01
#  CALL i013_ima02(g_icm01) RETURNING p_ima02
   DISPLAY g_icm01 TO icm01
      DISPLAY g_icm_info.icmuser TO icmuser
      DISPLAY g_icm_info.icmacti TO icmacti
      DISPLAY g_icm_info.icmdate TO icmdate
      DISPLAY g_icm_info.icmgrup TO icmgrup
      DISPLAY g_icm_info.icmmodu TO icmmodu
   CALL i013_icm01('d')
   CALL i013_b_fill(g_wc)                   
END FUNCTION
 
FUNCTION i013_x()                                                                                                                   
                                                                                                                                    
   IF s_shut(0) THEN                                                                                                                
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   IF g_icm01 IS NULL THEN                                                                                                      
      CALL cl_err("",-400,0)                                                                                                        
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   BEGIN WORK                                                                                                                       
                                                                                                                                    
   OPEN i013_cl USING g_icm01                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err("OPEN i013_cl:", STATUS, 1)                                                                                       
      CLOSE i013_cl                                                                                                                 
      ROLLBACK WORK                                                                                                                 
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   FETCH i013_cl INTO g_icm_lock.*               # 鎖住將被更改或取消的資料                                                              
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_icm01,SQLCA.sqlcode,0)          #資料被他人LOCK                                                             
      ROLLBACK WORK                                                                                                                 
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   LET g_success = 'Y'                                                                                                              
                                                                                                                                    
   CALL i013_show()                                                                                                                 
                                                                                                                                    
   IF cl_exp(0,0,g_icm_info.icmacti) THEN                   #確認一下                                                                    
      LET g_chr=g_icm_info.icmacti                                                                                                       
      IF g_icm_info.icmacti='Y' THEN                                                                                                     
         LET g_icm_info.icmacti='N'                                                                                                      
      ELSE                                                                                                                          
         LET g_icm_info.icmacti='Y'                                                                                                      
      END IF                                                                                                                        
                                                                                                                                    
      UPDATE icm_file SET icmacti=g_icm_info.icmacti,                                                                                    
                          icmmodu=g_user,                                                                                           
                          icmdate=g_today                                                                                           
       WHERE icm01=g_icm01                                                                                                      
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","icm_file",g_icm01,"",SQLCA.sqlcode,"","",1)                                         
         LET g_icm_info.icmacti=g_chr                                                                                                    
      END IF                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   CLOSE i013_cl                                                                                                                    
                                                                                                                                    
   IF g_success = 'Y' THEN                                                                                                          
      COMMIT WORK                                                                                                                   
      CALL cl_flow_notify(g_icm01,'V')                                                                                          
   ELSE                                                                                                                             
      ROLLBACK WORK                                                                                                                 
   END IF                                                                                                                           
                                                                                                                                    
   SELECT icmacti,icmmodu,icmdate                                                                                                   
     INTO g_icm_info.icmacti,g_icm_info.icmmodu,g_icm_info.icmdate FROM icm_file                                                                   
    WHERE icm01=g_icm01                                                                                                         
   DISPLAY BY NAME g_icm_info.icmacti,g_icm_info.icmmodu,g_icm_info.icmdate                                                                        
                                                                                                                                    
END FUNCTION
 
FUNCTION i013_r()        
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_icm01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
 
   OPEN i013_cl USING g_icm01
   IF STATUS THEN
      CALL cl_err('OPEN i013_cl:',STATUS,1)
      CLOSE i013_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i013_cl INTO g_icm_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_icm01,SQLCA.sqlcode,1)   
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i013_show()
 
   IF cl_delh(0,0) THEN                  
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "icm01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_icm01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                                        #No.FUN-9B0098 10/02/24
      DELETE FROM icm_file
       WHERE icm01 = g_icm01
      IF SQLCA.sqlcode THEN
         CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
      ELSE
         CLEAR FORM
         CALL g_icm.clear()
         CALL i013_count()
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i013_b_curs
             CLOSE i013_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i013_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i013_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i013_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION i013_b()                           
   DEFINE   l_n             LIKE type_file.num5,          
            l_lock_sw       LIKE type_file.chr1,      
            p_cmd           LIKE type_file.chr1,        
            l_allow_insert  LIKE type_file.num5,
            l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT#FUN-D40030 add
            l_allow_delete  LIKE type_file.num5
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_icm01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   IF g_icm_info.icmacti = 'N' THEN
      CALL cl_err(g_icm_info.icmacti,'mfg1000',0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql= "SELECT icm02,'',icm03 ",
                     "  FROM icm_file",
                     "  WHERE icm01 = ? ",
                     "   AND icm02 = ? ",
                     "   FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i013_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_icm WITHOUT DEFAULTS FROM s_icm.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,
                        DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_icm_t.* = g_icm[l_ac].*    #BACKUP
            OPEN i013_bcl USING g_icm01,g_icm[l_ac].icm02
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN i013_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i013_bcl INTO g_icm[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH i013_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL i013_ima02(g_icm[l_ac].icm02) 
                    RETURNING g_icm[l_ac].ima02_b
               DISPLAY BY NAME g_icm[l_ac].ima02_b
            END IF
         END IF
 
      BEFORE INSERT
         DISPLAY 'BEFORE INSERT!'
         LET p_cmd='a'
         INITIALIZE g_icm[l_ac].* TO NULL  
         LET g_icm_info.icmuser = g_user
         LET g_icm_info.icmgrup = g_grup
         LET g_icm_info.icmmodu = ''
         LET g_icm_info.icmdate = g_today
         LET g_icm_info.icmacti = 'Y'
         LET g_icm_t.* = g_icm[l_ac].*       
         NEXT FIELD icm02
 
      AFTER INSERT
         DISPLAY 'AFTER INSERT!'
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO icm_file(icm01,icm02,icm03,icmoriu,icmorig)
         VALUES (g_icm01,g_icm[l_ac].icm02,g_icm[l_ac].icm03, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err(g_icm01,SQLCA.sqlcode,0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1     
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD icm02
         IF NOT cl_null(g_icm[l_ac].icm02) THEN
           #FUN-AA0059 -------------------------add start---------------
            IF NOT s_chk_item_no(g_icm[l_ac].icm02,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD icm02
            END IF
           #FUN-AA0059 -------------------------add end------------------
            IF p_cmd='a' OR (p_cmd='u' AND g_icm[l_ac].icm02 !=
                                           g_icm_t.icm02) THEN
               IF g_icm[l_ac].icm02 = g_icm01 THEN
                  LET g_icm[l_ac].icm02 = g_icm_t.icm02
                  CALL cl_err(g_icm[l_ac].icm02,'aic-801',1)
                  NEXT FIELD icm02
               END IF
               LET l_n=0
               SELECT COUNT(*) INTO l_n
                 FROM ima_file
                WHERE ima01=g_icm[l_ac].icm02
                  AND imaacti='Y'
               IF l_n=0 THEN
                  LET g_icm[l_ac].icm02 = g_icm_t.icm02
                  CALL cl_err(g_icm[l_ac].icm02,'mfg3403',1)
                  NEXT FIELD icm02
               END IF
               LET l_n=0
               SELECT COUNT(*) INTO l_n
                 FROM icm_file
                WHERE icm01=g_icm01
                  AND icm02=g_icm[l_ac].icm02
               IF l_n>0 THEN
                  LET g_icm[l_ac].icm02 = g_icm_t.icm02
                  CALL cl_err(g_icm[l_ac].icm02,-239,1)
                  NEXT FIELD icm02
               END IF
            END IF
         END IF
         CALL i013_ima02(g_icm[l_ac].icm02) 
            RETURNING g_icm[l_ac].ima02_b
         DISPLAY BY NAME g_icm[l_ac].ima02_b
 
      BEFORE DELETE                         
         DISPLAY 'BEFORE DELETE!'
         IF NOT cl_null(g_icm_t.icm02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            
            DELETE FROM icm_file WHERE icm01 = g_icm01
                    AND icm02 = g_icm_t.icm02
 
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err(g_icm_t.icm02,SQLCA.sqlcode,0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_icm[l_ac].* = g_icm_t.*
            CLOSE i013_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_icm[l_ac].icm02,-263,1)
            LET g_icm[l_ac].* = g_icm_t.*
         ELSE
            UPDATE icm_file
               SET icm02 = g_icm[l_ac].icm02,
                   icm03 = g_icm[l_ac].icm03,
                   icmmodu= g_user,
                   icmdate= g_today
             WHERE icm01 = g_icm01
               AND icm02 = g_icm_t.icm02
 
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err(g_icm[l_ac].icm02,SQLCA.sqlcode,0)
               LET g_icm[l_ac].* = g_icm_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_icm[l_ac].* = g_icm_t.*
           #FUN-D40030--add--str
            ELSE
               CALL g_icm.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
           #FUN-D40030--add--end
            END IF
            CLOSE i013_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac #FUN-D40030 add
         CLOSE i013_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                      
         IF INFIELD(icm02) AND l_ac > 1 THEN
            DISPLAY BY NAME g_icm[l_ac-1].*
            LET g_icm[l_ac].* = g_icm[l_ac-1].*
            NEXT FIELD icm02
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(icm02)
#FUN-AA0059 --Begin--
            #   CALL cl_init_qry_var()
            #   LET g_qryparam.form = "q_icm01"
            #   LET g_qryparam.default1 = g_icm[l_ac].icm02
            #   LET g_qryparam.arg1=g_icm01
            #   CALL cl_create_qry() RETURNING g_icm[l_ac].icm02
               CALL q_sel_ima(FALSE, "q_icm01", "", g_icm[l_ac].icm02, g_icm01, "", "", "" ,"",'' )  RETURNING g_icm[l_ac].icm02
#FUN-AA0059 --End--
               DISPLAY g_icm[l_ac].icm02 TO s_icm[l_ac].icm02
               NEXT FIELD icm02
            OTHERWISE
               EXIT CASE
         END CASE
   
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
 
   END INPUT
 
   CLOSE i013_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i013_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc         STRING
   DEFINE p_ima02      LIKE ima_file.ima02
 
   LET g_sql = "SELECT icm02,'',icm03 ",
               "  FROM icm_file ",
               " WHERE icm01 = '",g_icm01 CLIPPED,"' "
   #No.FUN-8B0123---Begim
   #           "   AND ",p_wc CLIPPED,
   #           " ORDER BY icm02"
   IF NOT cl_null(p_wc) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc CLIPPED 
   END IF 
   LET g_sql=g_sql CLIPPED," ORDER BY icm02 " 
   DISPLAY g_sql
   #No.FUN-8B0123---End
 
   PREPARE i013_prepare2 FROM g_sql           
   DECLARE icm_curs CURSOR FOR i013_prepare2
 
   CALL g_icm.clear()
 
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH icm_curs INTO g_icm[g_cnt].*      
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL i013_ima02(g_icm[g_cnt].icm02) RETURNING p_ima02
      LET g_icm[g_cnt].ima02_b=p_ima02
      DISPLAY BY NAME g_icm[g_cnt].ima02_b
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_icm.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i013_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_icm TO s_icm.* 
           ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION insert                        
         LET g_action_choice='insert'
         EXIT DISPLAY
    
      ON ACTION query
         LET g_action_choice='query'
         EXIT DISPLAY
 
#     ON ACTION modify                          
#        LET g_action_choice='modify'
#        EXIT DISPLAY
 
      ON ACTION reproduce                       
         LET g_action_choice='reproduce'
         EXIT DISPLAY
 
      ON ACTION delete                          
         LET g_action_choice='delete'
         EXIT DISPLAY
 
      ON ACTION detail                           
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
         CALL i013_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         CALL fgl_set_arr_curr(1) 
 
      ON ACTION previous                         
         CALL i013_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION jump                            
         CALL i013_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1) 
 
      ON ACTION next                           
         CALL i013_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         CALL fgl_set_arr_curr(1) 
 
      ON ACTION last                            
         CALL i013_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         CALL fgl_set_arr_curr(1)
 
      ON ACTION invalid                                                                                                             
         LET g_action_choice="invalid"                                                                                              
         EXIT DISPLAY
 
      ON ACTION help                           
         LET g_action_choice='help'
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         EXIT DISPLAY
 
      ON ACTION output                                                                                                              
         LET g_action_choice='output'                                                                                                   
         EXIT DISPLAY
 
     #@ON ACTION 相關文件                         #FUN-830068                                                                       
      ON ACTION related_document                                                                                                    
         LET g_action_choice="related_document"                                                                                     
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
 
      ON ACTION exporttoexcel    
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i013_copy()
   DEFINE   l_n       LIKE type_file.num5,
            l_newno   LIKE icm_file.icm01,
            l_oldno   LIKE icm_file.icm01
 
   IF s_shut(0) THEN                          
      RETURN
   END IF
 
   IF cl_null(g_icm01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   INPUT l_newno WITHOUT DEFAULTS FROM icm01
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
         IF cl_null(l_newno) THEN
            NEXT FIELD icm01
         END IF
 
         LET l_n=0
         SELECT COUNT(*) INTO l_n FROM ima_file
          WHERE ima01 = l_newno
         IF l_n = 0 THEN
            CALL cl_err(l_newno,'mfg3403',1)
            NEXT FIELD icm01
         END IF
 
         LET l_n=0
         SELECT COUNT(*) INTO l_n FROM icm_file
          WHERE icm01 = l_newno
 
         IF l_n > 0 THEN
            CALL cl_err(l_newno,-239,0)
            NEXT FIELD icm01
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(icm01)
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  LET g_qryparam.form = "q_ima"
             #  LET g_qryparam.default1= l_newno
             #  CALL cl_create_qry() RETURNING l_newno
               CALL q_sel_ima(FALSE, "q_ima", "", l_newno, "", "", "", "" ,"",'' )  RETURNING l_newno
#FUN-AA0059 --End--
               CALL i013_icm01('d')
               NEXT FIELD icm01
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION about
         CALL cl_about()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_icm01
      CALL i013_icm01('d')
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM icm_file 
    WHERE icm01=g_icm01 
     INTO TEMP x
 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err(g_icm01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   UPDATE x
      SET icm01 = l_newno,      
          icmuser = g_user,       
          icmgrup = g_grup,        
          icmmodu = '',            
          icmdate = g_today,       
          icmacti = 'Y'           
 
   
   DELETE FROM x WHERE icm01 = icm02 
   INSERT INTO icm_file SELECT * FROM x
 
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err('icm:',SQLCA.SQLCODE,0)
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_icm01
   LET g_icm01 = l_newno
   CALL i013_b_fill(' 1=1')
   CALL i013_b()
   #LET g_icm01 = l_oldno  #FUN-C30027
   #CALL i013_show()       #FUN-C30027
END FUNCTION
 
FUNCTION i013_ima02(p_ima01)
   DEFINE p_ima01   LIKE ima_file.ima01
   DEFINE l_ima02   LIKE ima_file.ima02
 
   SELECT ima02 INTO l_ima02
     FROM ima_file
    WHERE ima01 = p_ima01
 
   RETURN l_ima02
END FUNCTION
 
FUNCTION i013_out()                                                                                                                 
  DEFINE  l_i               LIKE type_file.chr1,                                                                                         
          sr                RECORD                                                                                                       
               icm01        LIKE icm_file.icm01,                                                                                         
               icm02        LIKE icm_file.icm02,                                                                                         
               icm03        LIKE icm_file.icm03,                                                                                         
               ima02        LIKE ima_file.ima02                                                                                          
                       END RECORD,                                                                                                  
          l_name       LIKE type_file.chr20,                                                                                        
          l_za05       LIKE type_file.chr1000,                                                                                      
          l_str        STRING                                                                                                       
                                                                                                                                    
   IF g_wc IS NULL THEN                                                                                                             
       CALL cl_err('',-400,0)                                                                                                       
       RETURN                                                                                                                       
    END IF                                                                                                                          
    CALL cl_wait()                                                                                                                  
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang                                                                     
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aici012'                                                                     
                                                                                                                                    
    LET g_sql="SELECT icm01,icm02,icm03,a.ima02 ima02,b.ima02 ima02_1 ",
              " FROM icm_file,ima_file a,ima_file b",                                                                                           
              " WHERE icm01 = a.ima01 AND icm02 = b.ima01 AND ",g_wc CLIPPED                                                                              
                                                                                                                                    
    IF g_zz05 = 'Y' THEN                                                                                                            
        CALL cl_wcchp(g_wc,'icm01,icm02')                                                                         
        RETURNING g_wc                                                                                                              
     END IF                                                                                                                         
    LET l_str = g_wc                                                                                                                
    CALL cl_prt_cs1('aici013','aici013',g_sql,l_str)                                                                                
                                                                                                                                    
END FUNCTION
 
FUNCTION i013_icm01(p_cmd)                                                                                                          
DEFINE     p_cmd     LIKE type_file.chr1,                                                                                           
           l_ima02   LIKE ima_file.ima02,                                                                                           
           l_imaacti LIKE ima_file.imaacti                                                                                          
   LET g_errno=' '                                                                                                                  
   SELECT ima02,imaacti INTO l_ima02,l_imaacti  FROM ima_file                                                                       
         WHERE ima01=g_icm01                                                                                                        
                                                                                                                                    
   CASE WHEN SQLCA.sqlcode =100   LET g_errno='mfg3008'                                                                             
        WHEN l_imaacti='N'        LET g_errno='9028'                                                                                
        OTHERWISE                 LET g_errno= SQLCA.sqlcode USING '--------'                                                       
   END CASE                                                                                                                         
                                                                                                                                    
   IF cl_null(g_errno) OR p_cmd='d' THEN                                                                                            
      DISPLAY l_ima02 TO FORMONLY.ima02 
 #  LET g_ima02_a = l_ima02                                                                                           
   END IF                                                                                                                           
END FUNCTION        
# Modify FUN-7B0027 
#TQC-C20544                                                                                                                           
