# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: axci200.4gl
# Descriptions...: LCM 除外倉庫維護作業
# Date & Author..: 09/03/23 By jan
# Modify.........: No.FUN-930100 09/03/23 By jan
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_cmw          DYNAMIC ARRAY OF RECORD  
        cmw01       LIKE cmw_file.cmw01,   
        imd02       LIKE imd_file.imd02
                    END RECORD,
    g_cmw_t         RECORD               
        cmw01       LIKE cmw_file.cmw01,   
        imd02       LIKE imd_file.imd02
                    END RECORD,
    g_sql           string, 
    g_wc2           STRING, 
    g_rec_b         LIKE type_file.num5,
    l_ac            LIKE type_file.num5,
    g_account       LIKE type_file.num5
 
DEFINE p_row,p_col            LIKE type_file.num5  
DEFINE g_forupd_sql           STRING                
DEFINE g_chr                  LIKE type_file.chr1    
DEFINE g_cnt                  LIKE type_file.num10   
DEFINE g_i                    LIKE type_file.num5   
DEFINE g_msg                  LIKE type_file.chr1000 
DEFINE g_before_input_done    LIKE type_file.num5    
DEFINE g_cmd                  LIKE type_file.chr1000 
DEFINE g_flag                 LIKE type_file.chr1
 
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
 
   CALL  cl_used(g_prog,g_time,1)
         RETURNING g_time    
 
   LET p_row = 3 LET p_col = 6
 
   OPEN WINDOW i200_w AT p_row,p_col WITH FORM "axc/42f/axci200"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1' 
   CALL i200_b_fill(g_wc2)
   LET g_flag = 'N'  
   CALL i200_menu()
   CLOSE WINDOW i200_w          
   CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time    
END MAIN
 
FUNCTION i200_menu()
   WHILE TRUE
      CALL i200_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i200_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               LET g_account=FALSE 
               CALL i200_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"   
            CALL cl_cmdask()
         WHEN "exporttoexcel"      #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cmw),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i200_q()
   CALL i200_b_askkey()
END FUNCTION
 
FUNCTION i200_b()
DEFINE
    l_ac_t          LIKE type_file.num5,  
    l_n             LIKE type_file.num5, 
    l_n1            LIKE type_file.num5, 
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_possible      LIKE type_file.num5,
    l_dir1          LIKE type_file.chr1,    
    l_buf           LIKE ze_file.ze03,      
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1,
    l_cnt           LIKE type_file.num10,   
    l_imd           RECORD LIKE imd_file.*, 
    l_change        LIKE type_file.chr1     
 
    IF s_shut(0) THEN RETURN END IF
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET g_forupd_sql = " SELECT cmw01,'' ", 
                       "   FROM cmw_file ",
                       "  WHERE cmw01= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i200_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_cmw WITHOUT DEFAULTS FROM s_cmw.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           IF g_rec_b>=l_ac THEN
              LET p_cmd = 'u'
              #LET g_before_input_done = FALSE
              #CALL i200_set_entry(p_cmd)                                                                                           
              #CALL i200_set_no_entry(p_cmd)                                                                                        
              #LET g_before_input_done = TRUE                                                                                        
 
              BEGIN WORK
              LET p_cmd='u'
              LET g_cmw_t.* = g_cmw[l_ac].*  #BACKUP
 
              OPEN i200_bcl USING g_cmw_t.cmw01
              IF STATUS THEN
                 CALL cl_err("OPEN i200_bcl:", STATUS, 1)
                 LET l_lock_sw = 'Y' 
              ELSE  
                 FETCH i200_bcl INTO g_cmw[l_ac].* 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_cmw_t.cmw01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 ELSE
                    SELECT imd02 INTO g_cmw[l_ac].imd02 FROM imd_file WHERE imd01=g_cmw[l_ac].cmw01
                 END IF
              END IF
              CALL cl_show_fld_cont()     
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'                                                                                                         
           #LET g_before_input_done = FALSE                                                                                      
           #CALL i200_set_entry(p_cmd)                                                                                           
           #CALL i200_set_no_entry(p_cmd)                                                                                        
           #LET g_before_input_done = TRUE                                                                                       
           INITIALIZE g_cmw[l_ac].* TO NULL    
           LET g_cmw_t.* = g_cmw[l_ac].*
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD cmw01
 
        AFTER FIELD cmw01            
           IF g_cmw[l_ac].cmw01 != g_cmw_t.cmw01 OR
              (g_cmw[l_ac].cmw01 IS NOT NULL AND g_cmw_t.cmw01 IS NULL) THEN
               SELECT count(*) INTO l_n FROM cmw_file
                   WHERE cmw01 = g_cmw[l_ac].cmw01
               IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_cmw[l_ac].cmw01 = g_cmw_t.cmw01
                   NEXT FIELD cmw01
               END IF
               SELECT count(*) INTO l_n1 FROM imd_file
                WHERE imdacti = 'Y'
                  AND imd01 = g_cmw[l_ac].cmw01
               IF l_n1 = 0 THEN
                  CALL cl_err('','mfg4020',0)
                  NEXT FIELD cmw01
               END IF
               CALL i200_cmw01(g_cmw[l_ac].cmw01) RETURNING g_cmw[l_ac].imd02
               IF NOT cl_null(g_errno) THEN  
                  CALL cl_err('cmw01:',g_errno,1)
                  LET g_cmw[l_ac].cmw01 = g_cmw_t.cmw01
                  DISPLAY BY NAME g_cmw[l_ac].cmw01
                  NEXT FIELD cmw01
               END IF
               DISPLAY BY NAME g_cmw[l_ac].imd02
           END IF
 
        BEFORE DELETE
           IF g_cmw_t.cmw01 IS NOT NULL THEN
              IF NOT cl_delete() THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM cmw_file 
               WHERE cmw01 = g_cmw_t.cmw01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","cmw_file",g_cmw_t.cmw01,"",
                               SQLCA.sqlcode,"","",1) 
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
 
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2  
              COMMIT WORK
           END IF
 
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_cmw[l_ac].* = g_cmw_t.*
              CLOSE i200_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_cmw[l_ac].cmw01,-263,1)
              LET g_cmw[l_ac].* = g_cmw_t.*
           ELSE
              UPDATE cmw_file 
                   SET cmw01   = g_cmw[l_ac].cmw01,
                       imdmodu = g_user,
                       imddate = g_today
               WHERE cmw01= g_cmw_t.cmw01
              IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","cmw_file",g_cmw_t.cmw01,"",
                                SQLCA.sqlcode,"","",1) 
                  LET g_cmw[l_ac].* = g_cmw_t.*
                  ROLLBACK WORK
              ELSE
                  MESSAGE 'UPDATE O.K'
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_cmw[l_ac].* = g_cmw_t.*
              #FUN-D40030---add---str---
              ELSE
                 CALL g_cmw.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030---add---end---
              END IF
              CLOSE i200_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac
           CLOSE i200_bcl
           COMMIT WORK
 
        AFTER INSERT
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i200_bcl
              CANCEL INSERT
           END IF
           INSERT INTO cmw_file(cmw01,cmwuser,cmwdate,cmwgrup,cmworiu,cmworig)
             VALUES(g_cmw[l_ac].cmw01,g_user,g_today,g_grup, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","cmw_file",g_cmw[l_ac].cmw01,'',
                            SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b = g_rec_b + 1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
 
        ON ACTION CONTROLO 
           IF INFIELD(cmw01) AND l_ac > 1 THEN
              LET g_cmw[l_ac].* = g_cmw[l_ac-1].*
              NEXT FIELD cmw01
           END IF
            
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(cmw01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_imd1"
                 CALL cl_create_qry() RETURNING g_cmw[l_ac].cmw01
                 DISPLAY BY NAME g_cmw[l_ac].cmw01
                 NEXT FIELD cmw01
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
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
 
    CLOSE i200_bcl
    COMMIT WORK
    
END FUNCTION
 
FUNCTION i200_b_askkey()
    CLEAR FORM
    CALL g_cmw.clear()
    CONSTRUCT g_wc2 ON cmw01,imd02
            FROM s_cmw[1].cmw01,s_cmw[1].imd02
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(cmw01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_imd1"
               LET g_qryparam.state = "c"   
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO cmw01
               NEXT FIELD cmw01
         END CASE 
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('cmwuser', 'cmwgrup') #FUN-980030
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
    CALL i200_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i200_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    LET g_sql = "SELECT cmw01,imd02 ",
                "  FROM cmw_file,imd_file",
                " WHERE cmw01 = imd01 ",
                "   AND ", p_wc2 CLIPPED,  
                " ORDER BY 1"
    PREPARE i200_pb FROM g_sql
    DECLARE imd_curs CURSOR FOR i200_pb
 
    CALL g_cmw.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH imd_curs INTO g_cmw[g_cnt].* 
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    MESSAGE ""
    CALL g_cmw.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cmw TO s_cmw.* ATTRIBUTE(COUNT=g_rec_b)
 
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()              
 
      ON ACTION query
         LET g_action_choice="query"
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
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
                                                                                                     
#FUNCTION i200_set_entry(p_cmd)                                                                                                      
#  DEFINE p_cmd   LIKE type_file.chr1                                                                                                               #No.FUN-690026 VARCHAR(1)
                                                                                                                                    
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                              
#     CALL cl_set_comp_entry("cmw01",TRUE)                                                                                           
#   END IF                                                                                                                           
 
 
#END FUNCTION                                                                                                                        
                                                                                                                                    
#FUNCTION i200_set_no_entry(p_cmd)                                                                                                   
#  DEFINE p_cmd   LIKE type_file.chr1                                                                                                               #No.FUN-690026 VARCHAR(1)
                                                                                                                                    
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
#     CALL cl_set_comp_entry("cmw01",FALSE)                                                                                          
#   END IF                                                                                                                           
#END FUNCTION                                                                                                                        
 
FUNCTION i200_cmw01(p_cmw01)
DEFINE l_imd02 LIKE imd_file.imd02,
       l_imdacti LIKE imd_file.imdacti,
       p_cmw01   LIKE cmw_file.cmw01
 
   LET g_errno=''
   SELECT imd02,imdacti INTO l_imd02,l_imdacti FROM imd_file
                            WHERE imd01 = p_cmw01
   CASE
     WHEN SQLCA.sqlcode=100   LET g_errno='mfg4020' 
     WHEN l_imdacti='N'       LET g_errno='9028'
   OTHERWISE
     LET g_errno=SQLCA.sqlcode USING '------' 
   END CASE
   IF cl_null(g_errno)THEN
      #DISPLAY l_imd02 TO FORMONLY.cmd02
      RETURN l_imd02
   END IF
END FUNCTION
#FUN-930100
 
