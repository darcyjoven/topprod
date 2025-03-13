# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: almi3701.4gl
# Descriptions...: 戰盟連鎖優惠設置作業
# Date & Author..: FUN-870015 08/07/08 By Shiwuying
# Date & Author..: FUN-960134 09/08/31 By Shiwuying 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: No.TQC-B60201 11/06/20 By yangxf mark掉查詢action 
# Modify.........: No.FUN-D30033 13/04/12 By minpp 單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lnp           DYNAMIC ARRAY OF RECORD
           lnp04       LIKE lnp_file.lnp04,
           lnp05       LIKE lnp_file.lnp05
                       END RECORD,
       g_lnp_t         RECORD             
           lnp04       LIKE lnp_file.lnp04,
           lnp05       LIKE lnp_file.lnp05
                       END RECORD,
       g_wc2,g_sql     STRING, 
       g_rec_b         LIKE type_file.num5,               
       l_ac            LIKE type_file.num5                
 
DEFINE g_argv1              LIKE lnn_file.lnnstore
DEFINE g_argv2              LIKE lnn_file.lnn02
DEFINE g_argv3              LIKE lnn_file.lnn03
DEFINE g_forupd_sql         STRING                  
DEFINE g_cnt                LIKE type_file.num10    
DEFINE g_msg                LIKE type_file.chr1000 
DEFINE g_before_input_done  LIKE type_file.num5     
DEFINE g_i                  LIKE type_file.num5     
 
MAIN     
    OPTIONS                              
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                    
 
    IF (NOT cl_user()) THEN
      EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
    END IF
      
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
 
    OPEN WINDOW i3701_w WITH FORM "alm/42f/almi3701"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
    SELECT count(*) INTO g_cnt FROM lnp_file
     WHERE lnpstore=g_argv1
       AND lnp02=g_argv2
       AND lnp03=g_argv3
    IF g_cnt = 0 THEN
    #  IF cl_chk_mach_auth(g_argv1,g_plant) THEN
          CALL i3701_b()
    #  END IF
    ELSE 
       LET g_wc2 = " lnpstore= '",g_argv1,"'",
                   " AND lnp02= '",g_argv2,"'",
                   " AND lnp03= '",g_argv3,"'"
       CALL i3701_b_fill(g_wc2)
    END IF  
 
    CALL i3701_menu()
    CLOSE WINDOW i3701_w               
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time   
END MAIN
 
FUNCTION i3701_menu()
 
   WHILE TRUE
      CALL i3701_bp("G")
      CASE g_action_choice
#TQC-B60201 -------------------start-------------------
#         WHEN "query" 
#            IF cl_chk_act_auth() THEN
#               CALL i3701_q()
#            END IF
#TQC-B60201 -------------------end---------------------
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
            #  IF cl_chk_mach_auth(g_argv1,g_plant) THEN
                  CALL i3701_b()
            #  END IF
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               Call i3701_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lnp),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i3701_q()
   CALL i3701_b_askkey()
END FUNCTION
 
FUNCTION i3701_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    
    l_n             LIKE type_file.num5,     
    l_lock_sw       LIKE type_file.chr1,  
    p_cmd           LIKE type_file.chr1,   
    l_allow_insert  LIKE type_file.chr1,   
    l_allow_delete  LIKE type_file.chr1,
    l_lnn07         LIKE lnn_file.lnn07,
    l_lnnacti       LIKE lnn_file.lnnacti,
    l_lnnlegal      LIKE lnn_file.lnnlegal,
    l_lnn04         LIKE lnn_file.lnn04,
    l_lnn05         LIKE lnn_file.lnn05,
    l_lnn06         LIKE lnn_file.lnn06,
    l_lno04         LIKE lno_file.lno04,
    l_lnq04         LIKE lnq_file.lnq04
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    SELECT lnn04,lnn05,lnn06,lnn07,lnnacti,lnnlegal 
      INTO l_lnn04,l_lnn05,l_lnn06,l_lnn07,l_lnnacti,l_lnnlegal
      FROM lnn_file
     WHERE lnnstore=g_argv1
       AND lnn02=g_argv2
       AND lnn03=g_argv3   
 
    IF l_lnnacti ='N' THEN 
       CALL cl_err('','mfg1000',0)
       RETURN
    END IF
 
   IF l_lnn07='Y' THEN            #已審核, 不可修改資料!
      CALL cl_err('','9003',0)
      RETURN
   END IF
 
   IF l_lnn07='X' THEN             #作廢, 不可修改資料!
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT lnp04,lnp05 ",
                       " FROM lnp_file WHERE lnpstore= '",g_argv1,"'",
                       " AND lnp02= '",g_argv2,"'",
                       " AND lnp03= '",g_argv3,"'",
                       " AND lnp04=? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i3701_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_lnp WITHOUT DEFAULTS FROM s_lnp.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
              INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac) 
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET  g_before_input_done = FALSE 
               CALL i3701_set_entry(p_cmd)
               CALL i3701_set_no_entry(p_cmd) 
               LET  g_before_input_done = TRUE 
 
               LET g_lnp_t.* = g_lnp[l_ac].*  #BACKUP
               OPEN i3701_bcl USING g_lnp[l_ac].lnp04
               IF STATUS THEN
                  CALL cl_err("OPEN i3701_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE   
                  FETCH i3701_bcl INTO g_lnp[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_lnp_t.lnp04,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()  
            END IF
 
        BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            LET  g_before_input_done = FALSE
            CALL i3701_set_entry(p_cmd)
            CALL i3701_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
            INITIALIZE g_lnp[l_ac].* TO NULL
            LET g_lnp_t.* = g_lnp[l_ac].*
            CALL cl_show_fld_cont()    
            NEXT FIELD lnp04
 
      AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO lnp_file(lnpstore,lnplegal,lnp02,lnp03,lnp04,lnp05)
                          VALUES(g_argv1,l_lnnlegal,g_argv2,g_argv3,
                                 g_lnp[l_ac].lnp04,g_lnp[l_ac].lnp05)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","lnp_file",g_lnp[l_ac].lnp04,"",SQLCA.sqlcode,"","",1) 
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        AFTER FIELD lnp04
           IF NOT cl_null(g_lnp[l_ac].lnp04) THEN
              IF g_lnp[l_ac].lnp04 != g_lnp_t.lnp04 
                 OR g_lnp_t.lnp04 IS NULL THEN
                 IF g_lnp[l_ac].lnp04 <0 THEN
                    CALL cl_err(g_lnp[l_ac].lnp04,'alm-061',0)
                    NEXT FIELD lnp04
                 END IF
                 SELECT count(*) INTO l_n FROM lnp_file
                  WHERE lnpstore = g_argv1
                    AND lnp02 = g_argv2
                    AND lnp03 = g_argv3
                    AND lnp04 = g_lnp[l_ac].lnp04
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_lnp[l_ac].lnp04 = g_lnp_t.lnp04
                    NEXT FIELD lnp04
                 END IF
              END IF
           END IF
 
        AFTER FIELD lnp05
           IF NOT cl_null(g_lnp[l_ac].lnp05) THEN
              IF g_lnp[l_ac].lnp05 < 0 OR g_lnp[l_ac].lnp05 >100 THEN
                 CALL cl_err('','mfg4013',0)
                 LET g_lnp[l_ac].lnp05 = g_lnp_t.lnp05
                 NEXT FIELD lnp05
              END IF
 
              SELECT MAX(lno04) INTO l_lno04 FROM lno_file
               WHERE lnostore = g_argv1
                 AND lno02 = g_argv2
 
              SELECT MAX(lnq04) INTO l_lnq04 FROM lnq_file 
               WHERE lnqstore = g_argv1
                 AND lnq02 = g_argv2
 
              IF cl_null(l_lno04) THEN LET l_lno04=0 END IF
              IF cl_null(l_lnq04) THEN LET l_lnq04=0 END IF
              IF ((l_lnn04/100)*(l_lno04/100) + (l_lnn05/100)*(g_lnp[l_ac].lnp05/100) + (l_lnn06/100)*(l_lnq04/100)) >1 THEN
                 CALL cl_err('','alm-163',1) 
                 NEXT FIELD lnp05
              END IF
           END IF
 
        BEFORE DELETE 
            IF g_lnp_t.lnp04 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
               END IF 
               DELETE FROM lnp_file WHERE lnp04 = g_lnp_t.lnp04
                                      AND lnpstore = g_argv1
                                      AND lnp02 = g_argv2
                                      AND lnp03 = g_argv3
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","lnp_file",g_lnp_t.lnp04,"",SQLCA.sqlcode,"","",1) 
                   EXIT INPUT
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               MESSAGE "Delete OK"
               CLOSE i3701_bcl 
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lnp[l_ac].* = g_lnp_t.*
              CLOSE i3701_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lnp[l_ac].lnp04,-263,1)
              LET g_lnp[l_ac].* = g_lnp_t.*
           ELSE
              UPDATE lnp_file SET lnpstore = g_argv1,
                                  lnp02 = g_argv2,
                                  lnp04 = g_lnp[l_ac].lnp04,
                                  lnp05 = g_lnp[l_ac].lnp05
                            WHERE lnp04 = g_lnp_t.lnp04 
                              AND lnpstore = g_argv1
                              AND lnp02 = g_argv2
                              AND lnp03 = g_argv3
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","lnp_file",g_lnp_t.lnp04,"",SQLCA.sqlcode,"","",1) 
                 LET g_lnp[l_ac].* = g_lnp_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i3701_bcl
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac        #FUN-D30033
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_lnp[l_ac].* = g_lnp_t.* 
               #FUN-D30033----add--str
               ELSE
                  CALL g_lnp.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30033---add--end
               END IF
               CLOSE i3701_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac        #FUN-D30033
            CLOSE i3701_bcl
            COMMIT WORK 
 
        ON ACTION CONTROLN
            CALL i3701_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO
            IF INFIELD(lnp04) AND l_ac > 1 THEN
               LET g_lnp[l_ac].* = g_lnp[l_ac-1].*
               LET g_lnp[l_ac].lnp04 = NULL
               NEXT FIELD lnpstore
            END IF
            
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) 
                 RETURNING g_fld_name,g_frm_name 
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
        ON ACTION about       
            CALL cl_about()     
 
        ON ACTION help         
            CALL cl_show_help()
         
    END INPUT
    CLOSE i3701_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i3701_b_askkey()
    CLEAR FORM
    CALL g_lnp.clear()
    CONSTRUCT g_wc2 ON lnp04,lnp05
            FROM s_lnp[1].lnp04,s_lnp[1].lnp05
 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    
    IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b = 0
      RETURN
    END IF
    CALL i3701_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i3701_b_fill(p_wc2)
    DEFINE p_wc2     LIKE type_file.chr1000  
    LET g_sql = "SELECT lnp04,lnp05",
                " FROM lnp_file",
                " WHERE ", p_wc2 CLIPPED,
                " AND lnpstore = '",g_argv1,"'",
                " AND lnp02 = '",g_argv2,"'",
                " AND lnp03 = '",g_argv3,"'",
                " ORDER BY lnp04 "
    PREPARE i3701_pb FROM g_sql
    DECLARE lnp_curs CURSOR FOR i3701_pb
 
    CALL g_lnp.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lnp_curs INTO g_lnp[g_cnt].*  
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
    CALL g_lnp.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i3701_bp(p_ud)
 
   DEFINE   p_ud   LIKE type_file.chr1    
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lnp TO s_lnp.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()
#TQC-B60201 -------------------start-------------------
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
#TQC-B60201 -------------------start-------------------
      ON ACTION detail
         LET g_action_choice="detail"
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
 
FUNCTION i3701_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
     CALL cl_set_comp_entry("lnp04",TRUE)
  END IF
END FUNCTION 
 
FUNCTION i3701_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN 
     CALL cl_set_comp_entry("lnp04",FALSE)
  END IF
END FUNCTION
 
FUNCTION i3701_out()
DEFINE l_cmd LIKE type_file.chr1000
 
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN
    END IF
#    LET l_cmd = 'p_query "almi3701" "',g_wc2 CLIPPED,'"'                                                                               
#    CALL cl_cmdrun(l_cmd) 
#    RETURN
END FUNCTION
#No.FUN-960134
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
