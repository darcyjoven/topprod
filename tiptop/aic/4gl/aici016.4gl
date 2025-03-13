# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: aici016.4gl
# Descriptions...: ICD廠商WAFER SITE維護作業
# Date & Author..: 07/11/15 By #No.FUN-7B0016 ve007 #No.FUN-830130
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B80083 11/08/08 By minpp程序撰寫規範修改
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_icq           DYNAMIC ARRAY OF RECORD #程序變數
        icq01        LIKE icq_file.icq01,   #廠商編號
        pmc03        LIKE pmc_file.pmc03,   #廠商簡稱
        icq02        LIKE icq_file.icq02,   #Wafer Site
        icq03        LIKE icq_file.icq03,   #Wafer Site 說明
        icq04        LIKE icq_file.icq04    #標准碼
                    END RECORD,
     g_icq_t         RECORD   
        icq01        LIKE icq_file.icq01,   #廠商編號
        pmc03        LIKE pmc_file.pmc03,   #廠商簡稱
        icq02        LIKE icq_file.icq02,   #Wafer Site
        icq03        LIKE icq_file.icq03,   #Wafer Site 說明
        icq04        LIKE icq_file.icq04    #標准碼
                    END RECORD,
    g_wc2,g_sql     string, 
    g_rec_b         LIKE type_file.num5,    #單身筆數
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt              LIKE type_file.num5   
DEFINE   g_i                LIKE type_file.num5   #count/index for any purpose
DEFINE   l_cmd              STRING
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT 
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("aic")) THEN
       EXIT PROGRAM
    END IF
    
    IF NOT s_industry('icd') THEN                                                                                                    
     CALL cl_err('','aic-999',1)                                                                                                    
     EXIT PROGRAM                                                                                                                   
    END IF 
 
   # CALL cl_used(g_prog,g_time,1) RETURNING g_time    # FUN-B80083 mark
     CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80083    ADD
 
    OPEN WINDOW i016_w WITH FORM "aic/42f/aici016"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
        
    LET g_wc2 = ' 1=1' 
    CALL i016_b_fill(g_wc2)
    CALL i016_menu()
    CLOSE WINDOW i016_w             #結束畫面

   # CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80083 MARK
     CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
END MAIN
 
FUNCTION i016_menu()
 
   WHILE TRUE
      CALL i016_bp("G")
      CASE g_action_choice
 
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i016_q() 
            END IF
            
         WHEN "detail" 
            IF cl_chk_act_auth() THEN 
               CALL i016_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
            
         WHEN "help"  
            CALL cl_show_help()
            
         WHEN "output"                                                        
            IF cl_chk_act_auth() THEN
              IF cl_null(g_wc2) THEN                                            
                  LET g_wc2=" 1=1"                                             
               END IF                                                
               LET l_cmd='p_query ""aici016 "',g_wc2 CLIPPED,'"'
               CALL cl_cmdrun(l_cmd)
            END IF
               
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"   
            CALL cl_cmdask()
            
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN  
               IF g_icq[l_ac].icq01 IS NOT NULL THEN
                  LET g_doc.column1 = "icq01"
                  LET g_doc.value1 = g_icq[l_ac].icq01
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_icq),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i016_q()
   CALL i016_b_askkey()
END FUNCTION
 
FUNCTION i016_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,         #檢查重復用
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否
    p_cmd           LIKE type_file.chr1,         #處理狀態
    l_allow_insert  LIKE type_file.num5,         #可新增否
    l_allow_delete  LIKE type_file.num5          #可刪除否
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT icq01,pmc03,icq02,icq03,icq04",
                       "  FROM icq_file,OUTER pmc_file ",
                       "  WHERE icq01=? AND icq02 = ? ",
                       "   AND icq01 = pmc_file.pmc01 ",
                       "   FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i016_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_icq WITHOUT DEFAULTS FROM s_icq.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
           # DISPLAY l_ac TO FORMONLY.cnt  #No.FUN-830130
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET g_icq_t.* = g_icq[l_ac].*  #BACKUP
               LET  g_before_input_done = FALSE                                                                                     
               CALL i016_set_entry(p_cmd)                                                                                           
               CALL i016_set_no_entry(p_cmd)                                                                                        
               LET  g_before_input_done = TRUE                                                                                      
               BEGIN WORK
               OPEN i016_bcl USING g_icq_t.icq01,g_icq_t.icq02
               IF STATUS THEN
                  CALL cl_err("OPEN i016_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE   
                  FETCH i016_bcl INTO g_icq[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_icq_t.icq01,SQLCA.sqlcode,1)
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
 
            INSERT INTO icq_file(icq01,icq02,icq03,icq04)
                          VALUES(g_icq[l_ac].icq01,g_icq[l_ac].icq02,
                                 g_icq[l_ac].icq03,g_icq[l_ac].icq04)
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_icq[l_ac].icq01,SQLCA.sqlcode,0)
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET  g_before_input_done = FALSE 
            CALL i016_set_entry(p_cmd) 
            CALL i016_set_no_entry(p_cmd) 
            LET  g_before_input_done = TRUE 
            INITIALIZE g_icq[l_ac].* TO NULL  
            LET g_icq_t.* = g_icq[l_ac].*       #新輸入資料
            CALL cl_show_fld_cont()    
            NEXT FIELD icq01
 
        AFTER FIELD icq01                     
            IF NOT cl_null(g_icq[l_ac].icq01) THEN
               IF p_cmd = 'a' OR 
                  (p_cmd='u' AND g_icq[l_ac].icq01 != g_icq_t.icq01) THEN
                  LET l_n = 0 
                  SELECT COUNT(*) INTO l_n FROM pmc_file
                   WHERE pmc01= g_icq[l_ac].icq01
                     AND pmcacti='Y'
                     AND pmc30 IN('1','3')
                  IF l_n = 0 THEN
                     CALL cl_err(g_icq[l_ac].icq01,'mfg3014',1)
                     NEXT FIELD icq01
                  END IF 
               END IF
            END IF
            LET g_icq[l_ac].pmc03 = ''
            SELECT pmc03 INTO g_icq[l_ac].pmc03 FROM pmc_file
            WHERE pmc01 = g_icq[l_ac].icq01
            DISPLAY BY NAME g_icq[l_ac].pmc03
 
        AFTER FIELD icq02 
            IF NOT cl_null(g_icq[l_ac].icq02) THEN
               IF p_cmd = 'a' OR 
                  (p_cmd='u' AND g_icq[l_ac].icq02 != g_icq_t.icq02) THEN
                  IF NOT cl_null(g_icq[l_ac].icq01) THEN
                     LET l_n = 0
                     SELECT COUNT(*) INTO l_n FROM icq_file
                      WHERE icq01 = g_icq[l_ac].icq01
                        AND icq02 = g_icq[l_ac].icq02
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,1)
                        NEXT FIELD icq02
                     END IF
                  END IF
               END IF
            END IF
 
        AFTER FIELD icq04 
            IF NOT cl_null(g_icq[l_ac].icq04) THEN
               IF p_cmd = 'a' OR 
                  (p_cmd='u' AND g_icq[l_ac].icq04 != g_icq_t.icq04) THEN
                  IF NOT cl_null(g_icq[l_ac].icq01) THEN
                     LET l_n = 0
                     SELECT COUNT(*) INTO l_n FROM icq_file
                      WHERE icq01 = g_icq[l_ac].icq01
                        AND icq04 = g_icq[l_ac].icq04
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,1)
                        NEXT FIELD icq04
                     END IF
                  END IF
               END IF
            END IF
 
        BEFORE DELETE                   #是否取消單身
            IF g_icq_t.icq01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "icq01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_icq[l_ac].icq01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM icq_file WHERE icq01 = g_icq_t.icq01
                                       AND icq02 = g_icq_t.icq02
                IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                   CALL cl_err(g_icq_t.icq01,SQLCA.sqlcode,0)
                   ROLLBACK WORK 
                   CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"
                CLOSE i016_bcl
                COMMIT WORK 
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_icq[l_ac].* = g_icq_t.*
               CLOSE i016_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_icq[l_ac].icq01,-263,1)
               LET g_icq[l_ac].* = g_icq_t.*
            ELSE
               UPDATE icq_file 
                  SET icq01=g_icq[l_ac].icq01,
                      icq02=g_icq[l_ac].icq02,
                      icq03=g_icq[l_ac].icq03,
                      icq04=g_icq[l_ac].icq04
                WHERE icq01= g_icq_t.icq01
                  AND icq02= g_icq_t.icq02
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                   CALL cl_err(g_icq[l_ac].icq01,SQLCA.sqlcode,0)
                   LET g_icq[l_ac].* = g_icq_t.*
                   ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
                   CLOSE i016_bcl
                   COMMIT WORK 
               END IF
            END IF
 
        #--New AFTER ROW block
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac#FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN 
                  LET g_icq[l_ac].* = g_icq_t.*
              #FUN-D40030--add--str
               ELSE
                  CALL g_icq.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
              #FUN-D40030--add--end
               END IF 
               CLOSE i016_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac#FUN-D40030  add
            CLOSE i016_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(icq01)     #查供應商
                CALL cl_init_qry_var() 
                LET g_qryparam.form = "q_pmc1"
                LET g_qryparam.default1 = g_icq[l_ac].icq01 
                CALL cl_create_qry() RETURNING g_icq[l_ac].icq01
                DISPLAY BY NAME g_icq[l_ac].icq01
                NEXT FIELD icq01      
           END CASE
 
        ON ACTION CONTROLO               #沿用所有欄位
            IF INFIELD(icq01) AND l_ac > 1 THEN
               LET g_icq[l_ac].* = g_icq[l_ac-1].*
               DISPLAY BY NAME g_icq[l_ac].*
               NEXT FIELD icq01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about        
           CALL cl_about()    
 
        ON ACTION help       
           CALL cl_show_help()
        
      END INPUT
 
    CLOSE i016_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i016_b_askkey()
    CLEAR FORM
    CALL g_icq.clear()
    LET g_rec_b = 0
    CONSTRUCT g_wc2 ON icq01,icq02,icq03,icq04
                  FROM s_icq[1].icq01,s_icq[1].icq02, 
                       s_icq[1].icq03,s_icq[1].icq04
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(icq01)
                  CALL cl_init_qry_var() 
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pmc1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret 
                  DISPLAY g_qryparam.multiret TO icq01 
                  NEXT FIELD icq01       
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
         CALL cl_qbe_select() 
      ON ACTION qbe_save
	   CALL cl_qbe_save()
	
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i016_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i016_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2          STRING
   
 
    LET g_sql =
        "SELECT icq01,pmc03,icq02,icq03,icq04",
        " FROM icq_file LEFT OUTER JOIN pmc_file ON icq01 = pmc01 ",
        " WHERE ", p_wc2 CLIPPED,
        " ORDER BY icq01,icq02,icq04"
    PREPARE i016_pb FROM g_sql
    DECLARE icq_curs CURSOR FOR i016_pb
 
    CALL g_icq.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH icq_curs INTO g_icq[g_cnt].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_icq.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt 
END FUNCTION
 
FUNCTION i016_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_icq TO s_icq.* ATTRIBUTE(COUNT=g_rec_b)
 
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
   
     ON ACTION output   
        LET g_action_choice="output" 
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
 
   
     ON ACTION related_document
        LET g_action_choice="related_document"
        EXIT DISPLAY
 
     ON ACTION exporttoexcel   
        LET g_action_choice = 'exporttoexcel'
        EXIT DISPLAY
   
     AFTER DISPLAY
        CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i016_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
     CALL cl_set_comp_entry("icq01,icq02",TRUE)
  END IF  
END FUNCTION
   
FUNCTION i016_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("icq01,icq02",FALSE)  
  END IF   
END FUNCTION
#No.FUN-7B0016
