# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: atmi150.4gl
# Descriptions...: 費用代碼維護作業
# Date & Author..: 05/01/06 By Rayven
# Modify.........: NO.FUN-660104 06/06/15 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780056 07/07/13 By mike 報表格式修改為p_query
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_oaj           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        oaj01       LIKE oaj_file.oaj01,  
        oaj02       LIKE oaj_file.oaj02,
        oaj03       LIKE oaj_file.oaj03,
#       tqe02       LIKE tqe_file.tqe02,     #No.FUN-6B0065
        azf03       LIKE azf_file.azf03,     #No.FUN-6B0065
        oajacti     LIKE oaj_file.oajacti
                    END RECORD,
    g_oaj_t         RECORD                 #程式變數 (舊值)
        oaj01       LIKE oaj_file.oaj01,  
        oaj02       LIKE oaj_file.oaj02,
        oaj03       LIKE oaj_file.oaj03,
#       tqe02       LIKE tqe_file.tqe02,     #No.FUN-6B0065
        azf03       LIKE azf_file.azf03,     #No.FUN-6B0065
        oajacti     LIKE oaj_file.oajacti
                    END RECORD,
    g_wc2,g_sql     STRING, 
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680120 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
DEFINE   g_forupd_sql    STRING     #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680120 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5              #No.FUN-680120 SMALLINT
DEFINE   g_aza50         LIKE   aza_file.aza50                   #No.FUN-680120 VARCHAR(1)
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6B0014
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
    LET p_row = 3 LET p_col = 16
 
    OPEN WINDOW i150_w AT p_row,p_col WITH FORM "atm/42f/atmi150"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
    
    SELECT aza50 INTO g_aza50 FROM aza_file 
    IF g_aza50 NOT MATCHES '[yY]' THEN                                                                                                       
       CALL cl_set_comp_visible("oaj03,tqe02,oajacti",FALSE)
    END IF
 
    LET g_wc2 = '1=1' CALL i150_b_fill(g_wc2)
    CALL i150_menu()
    CLOSE WINDOW i150_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION i150_menu()
 DEFINE l_cmd    STRING                       #No.FUN-780056
   WHILE TRUE
      CALL i150_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i150_q()
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN
               CALL i150_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               #CALL i150_out()                                   #No.FUN-780056  
               IF cl_null(g_wc2) THEN LET g_wc2='1=1' END IF      #No.FUN-780056
               LET l_cmd='p_query "atmi150" "',g_wc2 CLIPPED,'"'  #No.FUN-780056 
               CALL cl_cmdrun(l_cmd)                              #No.FUN-780056  
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oaj),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i150_q()
   CALL i150_b_askkey()
END FUNCTION
 
FUNCTION i150_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680120 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680120 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT oaj01,oaj02,oaj03,'',oajacti",
                       "  FROM oaj_file WHERE oaj01=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i150_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_oaj WITHOUT DEFAULTS FROM s_oaj.*
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
               LET g_oaj_t.* = g_oaj[l_ac].*  #BACKUP
               LET g_before_input_done = FALSE                                                                                      
               CALL i150_set_entry_b(p_cmd)                                                                                         
               CALL i150_set_no_entry_b(p_cmd)                                                                                      
               LET g_before_input_done = TRUE                                                                                       
 
               BEGIN WORK
 
               OPEN i150_bcl USING g_oaj_t.oaj01
               IF STATUS THEN
                  CALL cl_err("OPEN i150_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i150_bcl INTO g_oaj[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_oaj_t.oaj01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
#No.FUN-6B0065 --begin                                                                                                          
#                 SELECT tqe02 INTO g_oaj[l_ac].tqe02
#                   FROM tqe_file WHERE tqe01 = g_oaj[l_ac].oaj03 
                  SELECT azf03 INTO g_oaj[l_ac].azf03
                    FROM azf_file WHERE azf01 = g_oaj[l_ac].oaj03 
#No.FUN-6B0065 --end
               END IF
               CALL cl_show_fld_cont()    
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO oaj_file(oaj01,oaj02,oaj03,oajacti)
            VALUES(g_oaj[l_ac].oaj01,g_oaj[l_ac].oaj02,g_oaj[l_ac].oaj03,g_oaj[l_ac].oajacti)
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_oaj[l_ac].oaj01,SQLCA.sqlcode,0)
                CALL cl_err3("ins","oaj_file",g_oaj[l_ac].oaj01,"",
                              SQLCA.sqlcode,"","",1)  #No.FUN-660104
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2 
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE                                                                                      
            CALL i150_set_entry_b(p_cmd)                                                                                         
            CALL i150_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
            INITIALIZE g_oaj[l_ac].* TO NULL      
            LET g_oaj_t.* = g_oaj[l_ac].*         
            LET g_oaj[l_ac].oajacti = 'Y'
            CALL cl_show_fld_cont()     
            NEXT FIELD oaj01
 
        AFTER FIELD oaj01                        #check 編號是否重複
            IF NOT cl_null(g_oaj[l_ac].oaj01) THEN 
               IF g_oaj[l_ac].oaj01 != g_oaj_t.oaj01 OR
                  (g_oaj[l_ac].oaj01 IS NOT NULL AND g_oaj_t.oaj01 IS NULL) THEN
                   SELECT count(*) INTO l_n FROM oaj_file
                       WHERE oaj01 = g_oaj[l_ac].oaj01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_oaj[l_ac].oaj01 = g_oaj_t.oaj01
                       NEXT FIELD oaj01
                   END IF
               END IF
            END IF
 
         AFTER FIELD oaj03                                                                                 
             IF NOT cl_null(g_oaj[l_ac].oaj03) THEN                                                                                       
                   CALL i150_oaj03('a')                                                                                          
                      IF NOT cl_null(g_errno) THEN                                                                                  
                         CALL cl_err(g_oaj[l_ac].oaj03,g_errno,0)                                                                   
                         NEXT FIELD oaj03                                                                                           
                      END IF                                                                                                        
             END IF  
 
        AFTER FIELD oajacti                                                         
            IF NOT cl_null(g_oaj[l_ac].oajacti) THEN                                   
               IF g_oaj[l_ac].oajacti NOT MATCHES'[yYnN]' THEN                         
                  NEXT FIELD oajacti                                                 
               END IF                                                                
            END IF   
 
        BEFORE DELETE                            #是否取消單身
            IF g_oaj_t.oaj01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM oaj_file WHERE oaj01 = g_oaj_t.oaj01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_oaj_t.oaj01,SQLCA.sqlcode,0)
                   CALL cl_err3("del","oaj_file",g_oaj_t.oaj01,"",
                                 SQLCA.sqlcode,"","",1)  #No.FUN-660104
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2 
                MESSAGE "Delete OK"
                CLOSE i150_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_oaj[l_ac].* = g_oaj_t.*
               CLOSE i150_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_oaj[l_ac].oaj01,-263,1)
               LET g_oaj[l_ac].* = g_oaj_t.*
            ELSE
               UPDATE oaj_file SET oaj01=g_oaj[l_ac].oaj01,
                                   oaj02=g_oaj[l_ac].oaj02,
                                   oaj03=g_oaj[l_ac].oaj03,
                                   oajacti=g_oaj[l_ac].oajacti
                 WHERE oaj01 = g_oaj_t.oaj01
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_oaj[l_ac].oaj01,SQLCA.sqlcode,0)
                  CALL cl_err3("upd","oaj_file",g_oaj[l_ac].oaj01,"",
                                SQLCA.sqlcode,"","",1)  #No.FUN-660104
                   LET g_oaj[l_ac].* = g_oaj_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   CLOSE i150_bcl
                   COMMIT WORK
               END IF
            
            END IF
 
        
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_oaj[l_ac].* = g_oaj_t.*
               END IF
               CLOSE i150_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i150_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i150_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(oaj01) AND l_ac > 1 THEN
                LET g_oaj[l_ac].* = g_oaj[l_ac-1].*
                NEXT FIELD oaj01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLP                                                      
           CASE                                                                 
               WHEN INFIELD(oaj03)                                              
               CALL cl_init_qry_var()                                           
#No.FUN-6B0065 --begin                                                                                                          
#              LET g_qryparam.form = "q_tqe1"                                    
               LET g_qryparam.form = "q_azf1"                                    
#No.FUN-6B0065 --end
               LET g_qryparam.default1 = g_oaj[l_ac].oaj03                      
               CALL cl_create_qry() RETURNING g_oaj[l_ac].oaj03                 
               DISPLAY BY NAME g_oaj[l_ac].oaj03                                
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
 
    CLOSE i150_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i150_oaj03(p_cmd)                                                                                                
    DEFINE p_cmd        LIKE type_file.chr1                                                                                                               #No.FUN-680120 VARCHAR(1)
                                                                                                                                    
    LET g_errno = ' '                                                                                                               
#No.FUN-6B0065 --begin                                                                                                          
#   SELECT tqe02                                                                                                            
#      INTO g_oaj[l_ac].tqe02                                                                                             
#      FROM tqe_file                                                                                                                
#      WHERE tqe01 = g_oaj[l_ac].oaj03                                                                                              
    SELECT azf03                                                                                                            
       INTO g_oaj[l_ac].azf03                                                                                             
       FROM azf_file                                                                                                                
       WHERE azf01 = g_oaj[l_ac].oaj03                                                                                              
#No.FUN-6B0065 --end
                                                                                                                                    
    CASE WHEN STATUS=100                                                                                                            
           LET g_errno = 'mfg3088'                                                                                                  
#No.FUN-6B0065 --begin                                                                                                          
#          LET  g_oaj[l_ac].tqe02 = NULL                                                                                            
           LET  g_oaj[l_ac].azf03 = NULL                                                                                            
#No.FUN-6B0065 --end
         OTHERWISE                                                                                                                  
           LET g_errno = SQLCA.sqlcode USING '-------'                                                                              
    END CASE                                                                                                                        
END FUNCTION 
 
FUNCTION i150_b_askkey()
    CLEAR FORM
    CALL g_oaj.clear()
    CONSTRUCT g_wc2 ON oaj01,oaj02,oaj03,oajacti
         FROM s_oaj[1].oaj01,s_oaj[1].oaj02,s_oaj[1].oaj03,s_oaj[1].oajacti
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION CONTROLP                                                       
         CASE                                                                  
            WHEN INFIELD(oaj03)                                                
            CALL cl_init_qry_var()                                             
#           LET g_qryparam.form = "q_tqe1"     #No.FUN-6B0065                                     
            LET g_qryparam.form = "q_azf1"     #No.FUN-6B0065                                     
            LET g_qryparam.state = "c"                                         
            LET g_qryparam.default1 = g_oaj[1].oaj03                           
            CALL cl_create_qry() RETURNING g_qryparam.multiret                 
            DISPLAY g_qryparam.multiret TO s_oaj[1].oaj03                      
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
 
    
      #No.FUN-580031 --start--     HCN
      ON ACTION qbe_select
          CALL cl_qbe_select() 
      ON ACTION qbe_save
          CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i150_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i150_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    LET g_sql =
#No.FUN-6B0065 --begin                                                                                                          
#       "SELECT oaj01,oaj02,oaj03,tqe02,oajacti",
#       " FROM oaj_file, OUTER tqe_file ",
#       " WHERE oaj03 = tqe_file.tqe01 AND ", p_wc2 CLIPPED,                     #單身
        "SELECT oaj01,oaj02,oaj03,azf03,oajacti",
        " FROM oaj_file, OUTER azf_file ",
        " WHERE oaj_file.oaj03=azf_file.azf01 AND ", p_wc2 CLIPPED,                     #單身
#No.FUN-6B0065 --end
        " ORDER BY oaj01"
    PREPARE i150_pb FROM g_sql
    DECLARE oaj_curs CURSOR FOR i150_pb
 
    CALL g_oaj.clear()
    LET g_cnt = 1
 
    MESSAGE "Searching!" 
    FOREACH oaj_curs INTO g_oaj[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
     
    END FOREACH
    CALL g_oaj.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2 
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i150_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oaj TO s_oaj.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()            
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-780056 -str
{
FUNCTION i150_out()
    DEFINE
        sr              RECORD
            oaj01       LIKE oaj_file.oaj01,
            oaj02       LIKE oaj_file.oaj02,
            oaj03       LIKE oaj_file.oaj03,
#           tqe02       LIKE tqe_file.tqe02,     #No.FUN-6B0065
            azf03       LIKE azf_file.azf03,     #No.FUN-6B0065
            oajacti     LIKE oaj_file.oajacti
                        END RECORD,
        l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
        l_name          LIKE type_file.chr20          #No.FUN-680120 VARCHAR(20)              
   
    IF g_wc2 IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
  #  FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
#No.FUN-6B0065 --begin                                                                                                          
#   LET g_sql="SELECT oaj01,oaj02,oaj03,tqe02,oajacti",
#             "  FROM oaj_file,OUTER tqe_file ",     
#             " WHERE oaj03 = tqe_file.tqe01 AND ",g_wc2 CLIPPED
    LET g_sql="SELECT oaj01,oaj02,oaj03,azf03,oajacti",
              "  FROM oaj_file,OUTER azf_file ",     
              " WHERE oaj_file.oaj03=azf_file.azf01 AND ",g_wc2 CLIPPED
#No.FUN-6B0065 --end
    PREPARE i150_p1 FROM g_sql            
    DECLARE i150_co                      
        CURSOR FOR i150_p1
 
    LET g_rlang = g_lang                      
    CALL cl_outnam('atmi150') RETURNING l_name
    START REPORT i150_rep TO l_name
 
    FOREACH i150_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i150_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i150_rep
 
    CLOSE i150_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i150_rep(sr)
    DEFINE
        sr              RECORD
            oaj01       LIKE oaj_file.oaj01,
            oaj02       LIKE oaj_file.oaj02,
            oaj03       LIKE oaj_file.oaj03,
#           tqe02       LIKE tqe_file.tqe02,     #No.FUN-6B0065
            azf03       LIKE azf_file.azf03,     #No.FUN-6B0065
            oajacti     LIKE oaj_file.oajacti
                        END RECORD,
        l_trailer_sw    LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.oaj01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<','/pageno'
            PRINT g_head CLIPPED, pageno_total
            PRINT ''
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35] 
            PRINT g_dash1                                
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.oaj01,
                  COLUMN g_c[32],sr.oaj02, 
                  COLUMN g_c[33],sr.oaj03, 
#                 COLUMN g_c[34],sr.tqe02,     #No.FUN-6B0065
                  COLUMN g_c[34],sr.azf03,     #No.FUN-6B0065
                  COLUMN g_c[35],sr.oajacti 
 
        ON LAST ROW                                                             
            PRINT g_dash[1,g_len]                                               
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED       
            LET l_trailer_sw = 'n'                                              
                                                                                
        PAGE TRAILER                                                            
            IF l_trailer_sw = 'y' THEN                                          
               PRINT g_dash[1,g_len]                                            
               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED    
            ELSE                                                                
               SKIP 2 LINE                                                      
            END IF                                                              
END REPORT          
}
#No.FUN-780056 -end
 
FUNCTION i150_set_entry_b(p_cmd)                                                                                                    
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680120 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("oaj01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i150_set_no_entry_b(p_cmd)                                                                                                 
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("oaj01",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
