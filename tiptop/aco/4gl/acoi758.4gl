# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: acoi758.4gl
# Descriptions...: 海關商品大類維護作業
# Date & Author..: FUN-930151 09/04/01 BY rainy 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0102 09/12/21 By destiny 已使用的商品大类不能删除或无效
# Modify.........: No:FUN-D30034 13/04/17 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_cev           DYNAMIC ARRAY OF RECORD   
        cev01       LIKE cev_file.cev01, 
        cev02       LIKE cev_file.cev02,
        cevacti     LIKE cev_file.cevacti
                    END RECORD,
    g_cev_t         RECORD             
        cev01       LIKE cev_file.cev01, 
        cev02       LIKE cev_file.cev02,
        cevacti     LIKE cev_file.cevacti 
                    END RECORD,
    g_wc,g_sql     STRING,   
    g_rec_b         LIKE type_file.num5,         
    l_ac            LIKE type_file.num5         
DEFINE   g_before_input_done  LIKE type_file.num5
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt           LIKE type_file.num10  
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose #No.FUN-680136 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03  
 
 
MAIN
    OPTIONS                                
        INPUT NO WRAP,
        FIELD ORDER FORM 
    DEFER INTERRUPT                   
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW i758_w WITH FORM "aco/42f/acoi758"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   LET g_wc = '1=1' 
   CALL i758_b_fill(g_wc) 
   CALL i758_menu()
 
   CLOSE WINDOW i758_w               

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
FUNCTION i758_menu()
 
   WHILE TRUE
      CALL i758_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i758_q() 
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN 
               CALL i758_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cev),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i758_q()
   CALL i758_b_askkey()
END FUNCTION
 
FUNCTION i758_b()
DEFINE
    l_ac_t          LIKE type_file.num5,          
    l_n             LIKE type_file.num5,         
    l_lock_sw       LIKE type_file.chr1,        
    p_cmd           LIKE type_file.chr1,       
    l_allow_insert  LIKE type_file.num5,      
    l_allow_delete  LIKE type_file.num5,
    l_count         LIKE type_file.num5     #No.FUN-9C0102      
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT cev01,cev02,cevacti",
                       "  FROM cev_file WHERE cev01=? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i758_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_cev WITHOUT DEFAULTS FROM s_cev.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
           
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3  
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET g_cev_t.* = g_cev[l_ac].*  #BACKUP
               LET  g_before_input_done = FALSE                                                                                     
               CALL i758_set_entry(p_cmd)                                                                                           
               CALL i758_set_no_entry(p_cmd)                                                                                        
               LET  g_before_input_done = TRUE                                                                                      
               BEGIN WORK
               OPEN i758_bcl USING g_cev_t.cev01
               IF STATUS THEN
                  CALL cl_err("OPEN i758_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i758_bcl INTO g_cev[l_ac].* 
                  IF STATUS THEN
                     CALL cl_err(g_cev_t.cev01,STATUS,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()  
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO cev_file(cev01,cev02,
                                 cevacti,cevuser,cevgrup,cevdate,cevoriu,cevorig)
              VALUES(g_cev[l_ac].cev01,g_cev[l_ac].cev02,
                     g_cev[l_ac].cevacti,g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","cev_file",g_cev[l_ac].cev01,"",SQLCA.sqlcode,"","",1) 
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b = g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET  g_before_input_done = FALSE   
            CALL i758_set_entry(p_cmd) 
            CALL i758_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
 
            INITIALIZE g_cev[l_ac].* TO NULL     
            LET g_cev[l_ac].cevacti = 'Y'         #Body default
            LET g_cev_t.* = g_cev[l_ac].*       
            CALL cl_show_fld_cont() 
            NEXT FIELD cev01
 
        AFTER FIELD cev01                      
            IF g_cev[l_ac].cev01 IS NOT NULL THEN
               IF (p_cmd = 'a' OR
                   g_cev[l_ac].cev01 != g_cev_t.cev01) THEN 
 
                   SELECT count(*) INTO l_n FROM cev_file
                    WHERE cev01 = g_cev[l_ac].cev01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_cev[l_ac].cev01 = g_cev_t.cev01
                       NEXT FIELD cev01
                   END IF
               END IF
            END IF
        #No.FUN-9C0102--begin
        AFTER FIELD cevacti 
            IF NOT cl_null(g_cev[l_ac].cevacti) THEN                
               SELECT COUNT(*) INTO l_count FROM ceg_file
                WHERE ceg09=g_cev[l_ac].cev01 
                IF l_count>0 AND g_cev[l_ac].cevacti ='N' THEN 
                   CALL cl_err('','aco-239',1)
                   LET g_cev[l_ac].cevacti ='Y'
                   NEXT FIELD cevacti
                END IF
            END IF 
        #No.FUN-9C0102--end 
        
        BEFORE DELETE                            
            IF g_cev_t.cev01 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               #No.FUN-9C0102--begin
               SELECT COUNT(*) INTO l_count FROM ceg_file
                WHERE ceg09=g_cev[l_ac].cev01 
               IF l_count>0 THEN 
                  CALL cl_err('','aco-239',1)
                  CANCEL DELETE
               END IF 
               #No.FUN-9C0102--end 
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
               DELETE FROM cev_file WHERE cev01 = g_cev_t.cev01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","cev_file",g_cev_t.cev01,"", SQLCA.sqlcode,"","",1) 
                  ROLLBACK WORK
                  CANCEL DELETE 
               END IF
               LET g_rec_b = g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               MESSAGE "Delete OK"
               CLOSE i758_bcl
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_cev[l_ac].* = g_cev_t.*
               CLOSE i758_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cev[l_ac].cev01,-263,1)
               LET g_cev[l_ac].* = g_cev_t.*
            ELSE
               UPDATE cev_file 
                  SET cev01=g_cev[l_ac].cev01,
                      cev02=g_cev[l_ac].cev02,
                      cevacti=g_cev[l_ac].cevacti,
                      cevmodu=g_user,
                      cevdate=g_today
                WHERE cev01 = g_cev_t.cev01
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","cev_file",g_cev[l_ac].cev01,"",SQLCA.sqlcode,"","",1)  
                   LET g_cev[l_ac].* = g_cev_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   CLOSE i758_bcl
                   COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN 
                  LET g_cev[l_ac].* = g_cev_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_cev.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF 
               CLOSE i758_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D30034 Add
            CLOSE i758_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO           
            IF INFIELD(cev01) AND l_ac > 1 THEN
                LET g_cev[l_ac].* = g_cev[l_ac-1].*
                NEXT FIELD cev01
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
 
    CLOSE i758_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i758_b_askkey()
    CLEAR FORM
    CALL g_cev.clear()
    CALL cl_opmsg('q')
    CONSTRUCT g_wc ON cev01,cev02,cevacti
            FROM s_cev[1].cev01,s_cev[1].cev02,
                 s_cev[1].cevacti
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cevuser', 'cevgrup') #FUN-980030
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc = NULL
       RETURN
    END IF
    CALL i758_b_fill(g_wc)
END FUNCTION
 
FUNCTION i758_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000     
 
    LET g_sql =
        "SELECT cev01,cev02,cevacti",
        " FROM cev_file",
        " WHERE ", p_wc2 CLIPPED,             
        " ORDER BY cev01"
    PREPARE i758_pb FROM g_sql
    DECLARE cev_curs CURSOR FOR i758_pb
 
    CALL g_cev.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH cev_curs INTO g_cev[g_cnt].*   
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_cev.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    DISPLAY g_cnt   TO FORMONLY.cn3  
END FUNCTION
 
FUNCTION i758_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cev TO s_cev.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
FUNCTION i758_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1  
 
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("cev01",TRUE)                                                                                           
  END IF                                                                                                                            
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i758_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1  
 
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                               
     CALL cl_set_comp_entry("cev01",FALSE)                                                                                          
  END IF                                                                                                                            
END FUNCTION                                                                                                                        
 
#FUN-930151
