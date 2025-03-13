# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aws_mdmcfg.4gl
# Descriptions...: MDM整合設定作業
# Date & Author..: 08/07/30 By kevin FUN-870166
# Modify.........: 08/09/24 By kevin FUN-890113 多筆傳送
# Modify.........: 09/01/14 By kevin TQC-910029 顯示確認按鍵
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A70082 10/07/19 by jay 調整使用gat_file來判斷table是否存在，需要改成用zta_file來判斷
 
IMPORT com
IMPORT util
 
DATABASE ds
 
GLOBALS "../4gl/aws_mdmgw.inc"
GLOBALS "../../config/top.global"
 
DEFINE g_wsv          DYNAMIC ARRAY OF RECORD
                           wsv01 LIKE wsv_file.wsv01,
                           gaz03 LIKE gaz_file.gaz03,   # 程序名稱
                           wsv03 LIKE wsv_file.wsv03,
                           wsv02 LIKE wsv_file.wsv02,
                           gat03 LIKE gat_file.gat03,   # 檔案名稱                           
                           wsv04 LIKE wsv_file.wsv04,
                           wsv05 LIKE wsv_file.wsv05,
                           wsv06 LIKE wsv_file.wsv06
                        END RECORD
 
DEFINE g_wsv_t         RECORD
                           wsv01 LIKE wsv_file.wsv01,
                           gaz03 LIKE gaz_file.gaz03,   # 程序名稱
                           wsv03 LIKE wsv_file.wsv03,
                           wsv02 LIKE wsv_file.wsv02,
                           gat03 LIKE gat_file.gat03,   # 檔案名稱                           
                           wsv04 LIKE wsv_file.wsv04,
                           wsv05 LIKE wsv_file.wsv05,
                           wsv06 LIKE wsv_file.wsv06
                        END RECORD
DEFINE g_wsv1         DYNAMIC ARRAY OF RECORD
	                         chk1  LIKE type_file.chr1,
                           wsv01 LIKE wsv_file.wsv01,
                           gaz03 LIKE gaz_file.gaz03   # 程序名稱                        
                        END RECORD
DEFINE g_cnt          LIKE type_file.num10,
       g_sql          STRING,
       g_rec_b        LIKE type_file.num5,
       l_ac           LIKE type_file.num5,
       g_curs_index   LIKE type_file.num10,
       g_row_count    LIKE type_file.num10,
       g_wc2          STRING,
       g_argv1        STRING
       

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   
   LET g_argv1 = ARG_VAL(1)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AWS")) THEN
      EXIT PROGRAM
   END IF
     
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0069
    
   IF g_argv1="Y" THEN
      LET g_bgjob = "Y"
      CALL aws_mdm_bgjob()
   ELSE
      LET g_bgjob = "N"

      OPEN WINDOW aws_mdmcfg_w WITH FORM "aws/42f/aws_mdmcfg"
           ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
      CALL cl_ui_init()       
       
      CALL aws_mdmcfg_menu()
       
      CLOSE WINDOW aws_mdmcfg_w   #結束畫面
   END IF

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0069
END MAIN      
 
FUNCTION aws_mdmcfg_menu()
   DEFINE l_cnt      LIKE type_file.num10
   
      CALL mdmcfg_b_fill()
   	  WHILE TRUE
   	  	 IF g_action_choice = "exit" THEN
   	            EXIT WHILE
   	  	 END IF   	  	 
   	  	 #CALL aws_mdmcfg_show("G")     
   	  	 LET g_action_choice = " "
   	  	 CALL aws_mdmcfg_i()
         CASE g_action_choice      	 
           WHEN "mdm_relation"
                CALL mdmcfg_relation_menu()
                CALL mdmcfg_b_fill()
         END CASE
      END WHILE
   
END FUNCTION
 
FUNCTION aws_mdmcfg_i()        
   DEFINE i  LIKE type_file.num5
   
   INPUT ARRAY g_wsv1 WITHOUT DEFAULTS FROM s_wsv1.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
      BEFORE INPUT
         CALL cl_set_act_visible("accept,cancel", FALSE)
         IF (g_rec_b=0) THEN
             CALL cl_set_act_visible("mdm_transfer", FALSE)
         ELSE
             CALL cl_set_act_visible("mdm_transfer", TRUE)
         END IF
        
      	
      ON ACTION mdm_transfer
         IF g_aza.aza85 matches '[ Nn]' OR cl_null(g_aza.aza85) THEN
            CALL cl_err('aza85','mfg3562',0)            
            RETURN
         END IF
         CALL aws_mdm_showmsg_init()
         FOR i = 1 TO ARR_COUNT()  
             IF g_wsv1[i].chk1 = "Y" THEN  #FUN-890113
                CALL aws_mdmcli(g_wsv1[i].wsv01)
             END IF              
         END FOR
         CALL aws_mdm_showmsg()
         CALL cl_set_act_visible("accept,cancel", FALSE) 
         
      ON ACTION mdm_relation         
         LET g_action_choice = "mdm_relation"
         EXIT INPUT
         	 
      ON ACTION mdm_deletion
         CALL mdmcfg_option()        
       
      ON ACTION controlg
          CALL cl_cmdask()
 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()       
 
      ON ACTION HELP
         CALL cl_show_help()          
 
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT INPUT
         	
      ON ACTION CANCEL         	
         LET g_action_choice = "exit"
         EXIT INPUT
           	
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      	
   END INPUT
   
END FUNCTION 
 
 
FUNCTION mdmcfg_b_fill()  
     
    LET g_sql = "SELECT UNIQUE 'Y',wsv01,'' ",
                " FROM wsv_file ORDER BY wsv01 "
        
    PREPARE wsv1_sql FROM g_sql
    DECLARE wsv1_cs CURSOR FOR wsv1_sql
    	
    CALL g_wsv1.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    
    FOREACH wsv1_cs INTO g_wsv1[g_cnt].*   #單身 ARRAY 填充
    	LET g_wsv1[g_cnt].gaz03=mdmcfg_progdesc(g_wsv1[g_cnt].wsv01,g_lang)
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,0)
         EXIT FOREACH
      END IF     
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
    END FOREACH
    
    CALL g_wsv1.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    LET g_cnt = 0
    
END FUNCTION
 
FUNCTION aws_mdmcfg_show(p_ud)
    DEFINE p_ud            VARCHAR(1)
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_wsv1 TO s_wsv1.* ATTRIBUTE (COUNT = 0, UNBUFFERED)
   
       BEFORE ROW
          LET l_ac = ARR_CURR()
       
       ON ACTION detail
          LET g_action_choice="detail"
          LET l_ac = 1
          EXIT DISPLAY
   
       ON ACTION mdm_relation
          CALL mdmcfg_relation_menu()
          
       ON ACTION mdm_deletion
       
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()       
 
       ON ACTION exit
          LET g_action_choice = "exit"
          EXIT DISPLAY
 
       ON ACTION CANCEL
          LET g_action_choice = "exit"
          EXIT DISPLAY          
          
       AFTER DISPLAY
          CONTINUE DISPLAY
           
       
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   
END FUNCTION
 
 
FUNCTION mdmcfg_relation_menu()
   
   OPEN WINDOW mdmcfg_relation_w WITH FORM "aws/42f/aws_mdmcfg_relation"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)   
   
   CALL cl_ui_locale("aws_mdmcfg_relation")
   
   CALL mdmcfg_relation_fill(" 1=1 ")
   
   WHILE TRUE
      CALL mdmcfg_relation_bp("G")
      CASE g_action_choice
      	 WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL mdmcfg_relation_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL mdmcfg_relation_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
   
   LET g_action_choice = ""
   CLOSE WINDOW mdmcfg_relation_w 
   
END FUNCTION
 
FUNCTION mdmcfg_relation_q()
   CLEAR FORM
   CALL g_wsv.clear()
   CONSTRUCT g_wc2 ON wsv01,wsv03,wsv02,wsv04,wsv05,wsv06                       
            FROM s_wsv[1].wsv01,s_wsv[1].wsv03,s_wsv[1].wsv02,
                 s_wsv[1].wsv04,s_wsv[1].wsv05,s_wsv[1].wsv06
                 
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
       
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
      ON ACTION controlp
         CASE
            WHEN INFIELD(wsv01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gaz"
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO wsv01
               
            WHEN INFIELD(wsv02)
            	 CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gat"
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO wsv02
         END CASE
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF  
    CALL mdmcfg_relation_fill(g_wc2)
END FUNCTION
 
FUNCTION mdmcfg_relation_bp(p_ud)
    DEFINE p_ud            VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_wsv TO s_wsv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
        BEFORE DISPLAY
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
 
        ON ACTION query
           LET g_action_choice="query"     
           EXIT DISPLAY
 
        ON ACTION detail
           LET g_action_choice="detail"    
           LET l_ac = 1
           EXIT DISPLAY
 
        ON ACTION help
           LET g_action_choice="help"           
           CALL cl_show_help()
           EXIT DISPLAY
 
        ON ACTION locale
           CALL cl_dynamic_locale()
           EXIT DISPLAY
 
        ON ACTION exit
           LET g_action_choice="exit" 
           EXIT DISPLAY
 
        ON ACTION accept
           LET g_action_choice="detail"
           LET l_ac = ARR_CURR()
           EXIT DISPLAY
     
        ON ACTION cancel
           LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice="exit"
           EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION mdmcfg_relation_fill(p_wc2)
    DEFINE  
         # p_wc2 LIKE type_file.chr1000 
         p_wc2         STRING       #NO.FUN-910082
    
    LET g_sql =   "SELECT wsv01,'',wsv03,wsv02,'',wsv04,wsv05,wsv06 FROM wsv_file",
                  " WHERE ", p_wc2 CLIPPED,
                  " ORDER BY wsv01,wsv02"
        
    PREPARE wsv_sql FROM g_sql
    DECLARE wsv_cs CURSOR FOR wsv_sql
    	
    CALL g_wsv.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    
    FOREACH wsv_cs INTO g_wsv[g_cnt].*   #單身 ARRAY 填充    	
      IF STATUS THEN      	 
         CALL cl_err('foreach:',STATUS,0)
         EXIT FOREACH
      END IF     
      LET g_wsv[g_cnt].gaz03 = mdmcfg_progdesc(g_wsv[g_cnt].wsv01,g_lang)
      LET g_wsv[g_cnt].gat03 = mdmcfg_tabledesc(g_wsv[g_cnt].wsv02,g_lang)
      
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
    END FOREACH    
    
    CALL g_wsv.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    LET g_cnt = 0
END FUNCTION
 
FUNCTION mdmcfg_relation_b()
DEFINE
   l_ac_t          SMALLINT,             #未取消的ARRAY CNT
   l_n             SMALLINT,             #檢查重複用
   l_lock_sw       VARCHAR(1),              #單身鎖住否
   p_cmd           VARCHAR(1),               #處理狀態
   l_sql           STRING,
   l_cnt           LIKE type_file.num10,
   l_allow_insert  LIKE type_file.num5,             #可新增否          #FUN-680135
   l_allow_delete  LIKE type_file.num5              #可刪除否          #FUN-680135
   
   
   
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF  
   
   LET l_sql ="SELECT wsv01,'',wsv03,wsv02,'',wsv04,wsv05,wsv06 FROM wsv_file",
              " where wsv01=? and wsv02=? FOR UPDATE"
   LET l_sql=cl_forupd_sql(l_sql)
   
   PREPARE wsv_pre FROM l_sql
   DECLARE wsv_curs CURSOR FOR wsv_pre
   	
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   
   INPUT ARRAY g_wsv WITHOUT DEFAULTS FROM s_wsv.*
      ATTRIBUTE (COUNT=g_rec_b, MAXCOUNT=g_max_rec, UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                  APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
            CALL cl_set_comp_required("wsv04,wsv05",TRUE)
         END IF     
         
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN         	
            BEGIN WORK
            LET g_wsv_t.* = g_wsv[l_ac].*      #BACKUP
            LET p_cmd='u'
            
            OPEN wsv_curs USING g_wsv_t.wsv01,g_wsv_t.wsv02
            IF STATUS THEN
               CALL cl_err("OPEN wsv_curs:", STATUS, 0)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH wsv_curs INTO g_wsv[l_ac].*              
               LET g_wsv[l_ac].gaz03 = g_wsv_t.gaz03
               LET g_wsv[l_ac].gat03 = g_wsv_t.gat03
               
               IF SQLCA.sqlcode THEN  
                  CALL cl_err(g_wsv_t.wsv01,SQLCA.sqlcode,0)
                  LET l_lock_sw = "Y"
               END IF
            END IF
         END IF
         
      AFTER FIELD wsv01
      	  IF NOT cl_null(g_wsv[l_ac].wsv01) THEN
      	  	 IF (g_wsv[l_ac].wsv01 != g_wsv_t.wsv01) OR p_cmd='a' THEN #check key是否重複
               SELECT COUNT(*) INTO l_cnt
                 FROM wsv_file
                WHERE wsv01 = g_wsv[l_ac].wsv01
                  AND wsv02 = g_wsv[l_ac].wsv02
             
               IF l_cnt >=1 THEN
                  CALL cl_err('',-239,0)
                  NEXT FIELD wsv01
               END IF
            END IF
      	  	
             SELECT COUNT(*) INTO l_cnt
               FROM gaz_file
              WHERE gaz01 = g_wsv[l_ac].wsv01
                AND gaz02 = g_lang
             
             IF l_cnt = 0 THEN
                CALL cl_err('','azz-127',0)
                NEXT FIELD wsv01
             END IF
            
      	     LET g_wsv[l_ac].gaz03=mdmcfg_progdesc(g_wsv[l_ac].wsv01,g_lang)
             DISPLAY BY NAME g_wsv[l_ac].gaz03
          END IF
          
      AFTER FIELD wsv02
      	  IF NOT cl_null(g_wsv[l_ac].wsv02) THEN
             #FUN-A70082-----start----
             #SELECT COUNT(*) INTO l_cnt
             #  FROM gat_file
             # WHERE gat01 = g_wsv[l_ac].wsv02
             #   AND gat02 = g_lang
             SELECT COUNT(*) INTO l_cnt
               FROM zta_file
              WHERE zta01 = g_wsv[l_ac].wsv02 AND zta02 = 'ds'
             #FUN-A70082-----end-----
            IF l_cnt = 0 THEN
               CALL cl_err('','mdm-003',0)
               NEXT FIELD wsv02
            END IF
            
            IF (g_wsv[l_ac].wsv02 != g_wsv_t.wsv02) OR p_cmd='a' THEN #check key是否重複
               SELECT COUNT(*) INTO l_cnt
                 FROM wsv_file
                WHERE wsv01 = g_wsv[l_ac].wsv01
                  AND wsv02 = g_wsv[l_ac].wsv02
             
               IF l_cnt >=1 THEN
                  CALL cl_err('',-239,0)
                  NEXT FIELD wsv02
               END IF
            END IF
                   
      	    LET g_wsv[l_ac].gat03 = mdmcfg_tabledesc(g_wsv[l_ac].wsv02,g_lang)
            DISPLAY BY NAME g_wsv[l_ac].gat03
          END IF    
     
      AFTER FIELD wsv03
      	
         
         {IF (p_cmd='a' OR g_wsv[l_ac].wsv03 != g_wsv_t.wsv03) AND g_wsv[l_ac].wsv03='D' THEN
          	SELECT COUNT(*) INTO l_cnt
              FROM wsv_file
             WHERE wsv01 = g_wsv[l_ac].wsv01
               AND wsv02 = g_wsv[l_ac].wsv02
               AND wsv03='H'
             
            IF l_cnt = 0 THEN             	  
               CALL cl_err('','mdm-002',1)
               NEXT FIELD wsv03
            END IF
         END IF     }
      	       
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_wsv[l_ac].* TO NULL      #900423
         LET g_wsv[l_ac].wsv06 = 1000
         LET g_wsv_t.* = g_wsv[l_ac].*         #新輸入資料
         NEXT FIELD wsv01
            
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         
         INSERT INTO wsv_file VALUES(
                              g_wsv[l_ac].wsv01,g_wsv[l_ac].wsv02,
                              g_wsv[l_ac].wsv03,g_wsv[l_ac].wsv04,
                              g_wsv[l_ac].wsv05,g_wsv[l_ac].wsv06)
         IF SQLCA.sqlcode THEN 
            CALL cl_err3("ins","wsv_file", g_wsv[l_ac].wsv01,g_wsv[l_ac].wsv02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1           
            COMMIT WORK
         END IF
         
      BEFORE DELETE
      	 IF g_wsv_t.wsv01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            
            DELETE FROM wsv_file WHERE wsv01 = g_wsv_t.wsv01 AND wsv02 = g_wsv_t.wsv02
            
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","wsv_file",g_wsv_t.wsv01,g_wsv_t.wsv02,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            
            LET g_rec_b=g_rec_b-1            
            MESSAGE "Delete OK"
            CLOSE wsv_curs
            COMMIT WORK
         END IF
      	
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_wsv[l_ac].* = g_wsv_t.*
            CLOSE wsv_curs
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
      	                   
         {IF g_wsv[l_ac].wsv03 != g_wsv_t.wsv03 AND g_wsv[l_ac].wsv03='D' THEN
          	SELECT COUNT(*) INTO l_cnt
              FROM wsv_file
             WHERE wsv01 = g_wsv[l_ac].wsv01
               AND wsv02 = g_wsv[l_ac].wsv02
               AND wsv03='H'
             
            IF l_cnt = 0 THEN             	  
               CALL cl_err('','mdm-002',1)
               NEXT FIELD wsv03
            END IF
         END IF}
         
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_wsv[l_ac].wsv01,-266,0)
            LET g_wsv[l_ac].* = g_wsv_t.*
         ELSE
            UPDATE wsv_file SET wsv01 = g_wsv[l_ac].wsv01,
                                wsv02 = g_wsv[l_ac].wsv02,
                                wsv03 = g_wsv[l_ac].wsv03,
                                wsv04 = g_wsv[l_ac].wsv04,
                                wsv05 = g_wsv[l_ac].wsv05,
                                wsv06 = g_wsv[l_ac].wsv06                                
                  WHERE wsv01 = g_wsv_t.wsv01 AND wsv02 = g_wsv_t.wsv02
                  
            IF SQLCA.sqlcode THEN 
               CALL cl_err3("upd","wsv_file",g_wsv_t.wsv01,g_wsv_t.wsv02,SQLCA.sqlcode,"","",1)  #No.FUN-660081
               LET g_wsv[l_ac].* = g_wsv_t.*
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
            IF p_cmd = 'u' THEN
               LET g_wsv[l_ac].* = g_wsv_t.*
            END IF
            CLOSE wsv_curs
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac
         CLOSE wsv_curs
         COMMIT WORK
      	   
      ON ACTION controlp
         CASE
            WHEN INFIELD(wsv01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gaz"
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.default1 = g_wsv[l_ac].wsv01
               CALL cl_create_qry() RETURNING g_wsv[l_ac].wsv01
               DISPLAY g_wsv[l_ac].wsv01 TO wsv01
              
               LET g_wsv[l_ac].gaz03=mdmcfg_progdesc(g_wsv[l_ac].wsv01,g_lang)
               DISPLAY BY NAME g_wsv[l_ac].gaz03   
               
            WHEN INFIELD(wsv02)
            	 CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gat"
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.default1 = g_wsv[l_ac].wsv02
               CALL cl_create_qry() RETURNING g_wsv[l_ac].wsv02
               DISPLAY g_wsv[l_ac].wsv02 TO wsv02
               
               LET g_wsv[l_ac].gat03 = mdmcfg_tabledesc(g_wsv[l_ac].wsv02,g_lang)
               DISPLAY BY NAME g_wsv[l_ac].gat03 
         END CASE                  
   END INPUT
 
   CLOSE wsv_curs
   COMMIT WORK
          
END FUNCTION
 
 
FUNCTION mdmcfg_progdesc(p_gaz01,p_lang)
  DEFINE  p_gaz01     LIKE gaz_file.gaz01,
          p_lang      LIKE gaz_file.gaz02,
          l_gaz03,l_result     LIKE gaz_file.gaz03,
          l_gaz05     LIKE gaz_file.gaz05,
          l_sql       STRING
 
  WHENEVER ERROR CALL cl_err_msg_log
  LET l_gaz03=''
  LET l_result=''
  LET l_sql="SELECT gaz03,gaz05 FROM gaz_file",
                             " WHERE gaz01='",p_gaz01,"'",
                             "   AND gaz02='",p_lang,"'"
  DECLARE get_progname_c CURSOR FROM l_sql
  FOREACH get_progname_c INTO l_gaz03,l_gaz05  #可能會有多筆,所以用Foreach
     CASE
        WHEN (l_gaz05 MATCHES '[Yy]') AND (NOT cl_null(l_gaz03))
           LET l_result=l_gaz03
           EXIT FOREACH
     END CASE
  END FOREACH
  IF cl_null(l_result) THEN  #沒有客製碼='Y'的情況,而且有設定程式名稱
     LET l_result=l_gaz03
  END IF
  RETURN l_result
END FUNCTION
 
FUNCTION mdmcfg_tabledesc(p_gat01,p_lang)
  DEFINE  p_gat01     LIKE gat_file.gat01,
          p_lang      LIKE gat_file.gat02,
          l_gat03,l_result     LIKE gat_file.gat03,
          l_sql       STRING
 
  WHENEVER ERROR CALL cl_err_msg_log
  LET l_gat03=''
  LET l_result=''          
  
  LET l_sql="SELECT gat03 FROM gat_file",
            " WHERE gat01='",p_gat01,"'",
            "   AND gat02='",p_lang,"'"
            
  DECLARE table_name_cs CURSOR FROM l_sql  
  FOREACH table_name_cs INTO l_result
  	 IF SQLCA.sqlcode THEN
        CALL cl_err('table_name_cs',STATUS,0) 
        EXIT FOREACH
     END IF
  END FOREACH
 
  RETURN l_result
END FUNCTION
 
 
FUNCTION mdmcfg_option()
   DEFINE   wsw06_d    LIKE type_file.dat,
            l_flag     LIKE type_file.chr1,
            l_cnt     LIKE type_file.num10
            
   OPEN WINDOW mdmcfg_option_w WITH FORM "aws/42f/aws_mdmcfg_option"         
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("aws_mdmcfg_option")
   
   LET wsw06_d = g_today  
 
   CALL cl_set_act_visible("accept,cancel", TRUE) #TQC-910029
   INPUT BY NAME wsw06_d WITHOUT DEFAULTS     
      AFTER FIELD wsw06_d
      	 LET g_success = 'Y'
      	 IF cl_sure(18,20) THEN
      		 SELECT COUNT(*) INTO l_cnt
      		   FROM wsw_file WHERE wsw06 <= wsw06_d  AND wsw09='1' 
      		   
      	      IF l_cnt > 0 THEN   
      	          DELETE FROM wsw_file WHERE wsw06 <= wsw06_d  AND wsw09='1'       
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","wsw_file",wsw06_d,"",SQLCA.sqlcode,"","",0)
                  LET g_success = 'N'              
              END IF
              
              IF g_success = 'Y' THEN
              	 MESSAGE "Delete OK"
                 COMMIT WORK
                 IF cl_confirm("mdm-001") THEN 
          	     NEXT FIELD wsw06_d
          	  ELSE
          	     EXIT INPUT	  	 
          	  END IF
              ELSE
              	  ROLLBACK WORK     
               	  CALL cl_end2(2) RETURNING l_flag
              END IF
           ELSE
          	  IF cl_confirm("mdm-004") THEN 
          	  	 NEXT FIELD wsw06_d
          	  ELSE
          	     EXIT INPUT	  	 
          	  END IF 
           END IF
           
           IF l_flag THEN
           	  NEXT FIELD wsw06_d
           ELSE
           	  EXIT INPUT
           END IF       
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
   CALL cl_set_act_visible("accept,cancel", FALSE) #TQC-910029
   
   CLOSE WINDOW mdmcfg_option_w    	
      	
END FUNCTION
 
