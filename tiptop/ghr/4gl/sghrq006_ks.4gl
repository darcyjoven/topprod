# Prog. Version..: '5.30.03-12.09.18(00008)'     #
#
# Pattern name...: sghrq006_ks.4gl
# Descriptions...: 员工信息快速录入
# Date & Author..: 13/04/07 By yangjian 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1   LIKE type_file.chr100,
    g_wc,g_wc2,g_sql    STRING, 
    g_cott          LIKE type_file.num5,          
    b_hrat           DYNAMIC ARRAY OF RECORD 
      hrat03         LIKE hrat_file.hrat03,
      hrat04         LIKE hrat_file.hrat04,
      hrat05         LIKE hrat_file.hrat05, 
      hrat01         LIKE hrat_file.hrat01,
      hrat02         LIKE hrat_file.hrat02,             
      hrat08         LIKE hrat_file.hrat08,
      hrat12         LIKE hrat_file.hrat12,
      hrat13         LIKE hrat_file.hrat13,
      hrat15         LIKE hrat_file.hrat15,              
      hrat17         LIKE hrat_file.hrat17,
      hrat19         LIKE hrat_file.hrat19,
      hrat20         LIKE hrat_file.hrat20,
      hrat21         LIKE hrat_file.hrat21,
      hrat22         LIKE hrat_file.hrat22,
      hrat25         LIKE hrat_file.hrat25              
                     END RECORD,
    b_hrat_t         RECORD 
      hrat03         LIKE hrat_file.hrat03,
      hrat04         LIKE hrat_file.hrat04,
      hrat05         LIKE hrat_file.hrat05, 
      hrat01         LIKE hrat_file.hrat01,
      hrat02         LIKE hrat_file.hrat02,             
      hrat08         LIKE hrat_file.hrat08,
      hrat12         LIKE hrat_file.hrat12,
      hrat13         LIKE hrat_file.hrat13,
      hrat15         LIKE hrat_file.hrat15,              
      hrat17         LIKE hrat_file.hrat17,
      hrat19         LIKE hrat_file.hrat19,
      hrat20         LIKE hrat_file.hrat20,
      hrat21         LIKE hrat_file.hrat21,
      hrat22         LIKE hrat_file.hrat22,
      hrat25         LIKE hrat_file.hrat25  
                     END RECORD,  
   g_hrat           RECORD LIKE hrat_file.*,
    g_rec_b         LIKE type_file.num5,  
    l_ac            LIKE type_file.num5                
DEFINE g_forupd_sql      STRING                       
DEFINE   g_chr           LIKE type_file.chr1          
DEFINE   g_cnt           LIKE type_file.num10         
DEFINE   g_msg           LIKE type_file.chr1000       
DEFINE   g_row_count     LIKE type_file.num10         
DEFINE   g_curs_index    LIKE type_file.num10         
DEFINE   g_jump          LIKE type_file.num10         
DEFINE   mi_no_ask       LIKE type_file.num5          
DEFINE   g_before_input_done  BOOLEAN
DEFINE   p_row,p_col     LIKE type_file.num5

FUNCTION sghrq006_ks(p_argv1)
  DEFINE p_argv1 LIKE type_file.chr100

  WHENEVER ERROR CONTINUE

    LET g_argv1 = p_argv1
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW q006ks_w AT p_row,p_col WITH FORM "ghr/42f/ghrq006_ks"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()  
    
    CALL q006ks_b()
    CALL q006ks_menu()

    CLOSE WINDOW q006ks_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time
    
END FUNCTION 


FUNCTION q006ks_menu()
 
   WHILE TRUE
      CALL q006ks_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN 
            	CALL q006ks_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN 
            	CALL q006ks_b()
            END IF
         WHEN "help"
            IF cl_chk_act_auth() THEN        
              CALL cl_show_help()            
            END IF                           
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(b_hrat),'','')
            END IF
            	
         #add by zhangbo130924---begin
         WHEN "imp_excel"
            IF cl_chk_act_auth() THEN
            	 CALL q006_ks_excel()
            END IF 	 
         #add by zhangbo130924---end 
           	                     
      END CASE
   END WHILE 
END FUNCTION
	
FUNCTION q006ks_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
   DEFINE   l_wc   LIKE type_file.chr1000
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
    DIALOG ATTRIBUTES(UNBUFFERED)
      
      DISPLAY ARRAY b_hrat TO s_hrat.*  ATTRIBUTE(COUNT=g_rec_b)

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()  
     
      END DISPLAY 
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG                        
 
      ON ACTION help
         LET g_action_choice="help"
         CALL cl_show_help()               
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()          
         EXIT DIALOG
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DIALOG   

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG   
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION detail
         LET INT_FLAG=FALSE 		
         LET g_action_choice="detail"
         EXIT DIALOG

      ON ACTION accept
         LET INT_FLAG=FALSE 		
         LET g_action_choice="detail"
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
         
     #add by zhangbo130924----begin
     ON ACTION imp_excel
        LET g_action_choice = "imp_excel"
        EXIT DIALOG
     #add by zhangbo130924----end    
 
     ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION	

FUNCTION q006ks_q()
   IF g_argv1 IS NOT NULL THEN
      CALL cl_err('','ghr-049',1)
      RETURN 
   END IF 
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM  #NO.TQC-740075
   CALL b_hrat.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL q006ks_b_askkey()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

   CALL q006ks_b_fill(g_wc2)
END FUNCTION   
   	
   	
FUNCTION q006ks_b_askkey()
    CLEAR FORM
    CALL b_hrat.clear()
    CONSTRUCT g_wc2 ON hrat03,hrat04,hrat05,hrat01,hrat02,hrat08,hrat12,hrat13,hrat15,hrat17,hrat19,
                hrat20,hrat21,hrat22,hrat25
         FROM   s_hrat[1].hrat03,s_hrat[1].hrat04,s_hrat[1].hrat05,s_hrat[1].hrat01,s_hrat[1].hrat02,
                s_hrat[1].hrat08,s_hrat[1].hrat12,s_hrat[1].hrat13,s_hrat[1].hrat15,s_hrat[1].hrat17,
                s_hrat[1].hrat19,s_hrat[1].hrat20,s_hrat[1].hrat21,s_hrat[1].hrat22,s_hrat[1].hrat25

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


      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup') #FUN-980030
    IF INT_FLAG THEN LET g_wc2 = NULL RETURN END IF

END FUNCTION

      
FUNCTION q006ks_b_fill(p_wc2)              
DEFINE p_wc2    LIKE type_file.chr1000  
DEFINE l_color   LIKE type_file.chr100 
DEFINE l_cnt,l_cnt1     LIKE type_file.num5

   LET g_sql =  " SELECT hrat03,hrat04,hrat05,hrat01,hrat02, ",
                "        hrat08,hrat12,hrat13,hrat15,hrat17,",
                "        hrat19,hrat20,hrat21,hrat22,hrat25 ",
                "   FROM hrat_file ",
                "  WHERE ",p_wc2 CLIPPED,
                " ORDER BY hrat01 "            
    PREPARE q006ks_pb FROM g_sql
    DECLARE hrat_curs CURSOR FOR q006ks_pb
 
    CALL b_hrat.clear()
    LET g_cnt = 1

    FOREACH hrat_curs  INTO b_hrat[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF

        LET g_cnt = g_cnt + 1
        
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL b_hrat.deleteElement(g_cnt)
    LET g_rec_b =  g_cnt -1
    DISPLAY g_rec_b TO cnt

END FUNCTION	
 	
	
FUNCTION q006ks_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102             #可新增否
    l_allow_delete  LIKE type_file.chr1           #No.FUN-680102               #可刪除否
   
DEFINE l_flag       LIKE type_file.chr1           #No.FUN-810016    
DEFINE l_hrag07     LIKE hrag_file.hrag07         #add by zhangbo130924

 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT  hrat03,hrat04,hrat05,hrat01,hrat02,",
                       "        hrat08,hrat12,hrat13,hrat15,hrat17,",
                       "        hrat19,hrat20,hrat21,hrat22,hrat25 ",
                       "  FROM  hrat_file ",
                       " WHERE hrat03=? AND hrat04=? ",
                       "   AND hrat05=? AND hrat01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE q006ks_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY b_hrat WITHOUT DEFAULTS FROM s_hrat.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_insert,APPEND ROW=l_allow_insert) 
 
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
               BEGIN WORK
               LET p_cmd='u'
               LET g_before_input_done = FALSE                                  
               LET g_before_input_done = TRUE                                   
               LET b_hrat_t.* = b_hrat[l_ac].*  
               OPEN q006ks_bcl USING b_hrat_t.hrat03,b_hrat_t.hrat04,
                                     b_hrat_t.hrat05,b_hrat_t.hrat01
               IF STATUS THEN
                  CALL cl_err("OPEN q006ks_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH q006ks_bcl INTO b_hrat[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(b_hrat_t.hrat01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           LET g_before_input_done = TRUE                                       
           INITIALIZE b_hrat[l_ac].* TO NULL      #900423
           CALL i006_logic_default('A',g_hrat.*) RETURNING g_hrat.*
           LET b_hrat[l_ac].hrat08 = g_hrat.hrat08
           LET b_hrat[l_ac].hrat25 = g_hrat.hrat25
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD hrat03
 
        AFTER FIELD hrat03
           LET g_hrat.hrat03 = b_hrat[l_ac].hrat03
           CALL i006_logic_chk_hrat03(g_hrat.*) RETURNING g_hrat.*
           IF NOT cl_null(g_errno) THEN 
              CALL cl_err(g_hrat.hrat03,g_errno,0)
          	  NEXT FIELD hrat03
           ELSE 
          
           END IF 
        
        AFTER FIELD hrat04
           LET g_hrat.hrat04 = b_hrat[l_ac].hrat04
           CALL i006_logic_chk_hrat04(g_hrat.*) RETURNING g_hrat.*
           IF NOT cl_null(g_errno) THEN 
              CALL cl_err(g_hrat.hrat04,g_errno,1)
              NEXT FIELD hrat04
           END IF 
                 
        AFTER FIELD hrat05
           LET g_hrat.hrat05 = b_hrat[l_ac].hrat05
           CALL i006_logic_chk_hrat05(g_hrat.*) RETURNING g_hrat.*
           IF NOT cl_null(g_errno) THEN 
          	  CALL cl_err(g_hrat.hrat05,g_errno,1)
          	  NEXT FIELD hrat05
           ELSE 
           
           END IF 
                  
        AFTER FIELD hrat01
          IF b_hrat[l_ac].hrat01 IS NOT NULL THEN
             IF b_hrat[l_ac].hrat01 != b_hrat_t.hrat01 OR b_hrat_t.hrat01 IS NULL THEN
             	  LET g_hrat.hrat01 = b_hrat[l_ac].hrat01
             	  CALL i006_logic_chk_hrat01(g_hrat.*) RETURNING g_hrat.*
             	  IF NOT cl_null(g_errno) THEN 
                   CALL cl_err(g_hrat.hrat01,-239,1)
                   LET g_hrat.hrat01 = b_hrat_t.hrat01
                   DISPLAY BY NAME g_hrat.hrat01
                   NEXT FIELD hrat01
                ELSE 
                
                END IF
             END IF   
          END IF
                  
        AFTER FIELD hrat02
          LET g_hrat.hrat02 = b_hrat[l_ac].hrat02
        
        AFTER FIELD hrat08
           LET g_hrat.hrat08 = b_hrat[l_ac].hrat08
           CALL i006_logic_chk_hrat08(g_hrat.*,b_hrat_t.hrat01) RETURNING g_hrat.*
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_hrat.hrat08,g_errno,0)
              NEXT FIELD hrat08
           ELSE 
          
          END IF       
            
        AFTER FIELD hrat12
           LET g_hrat.hrat12 = b_hrat[l_ac].hrat12
           CALL i006_logic_chk_hrat12(g_hrat.*) RETURNING g_hrat.*
           IF NOT cl_null(g_errno) THEN 
           	 CALL cl_err(g_hrat.hrat12,g_errno,1)
           	 NEXT FIELD hrat12
           ELSE 
           
           END IF 
                  
        AFTER FIELD hrat13
           LET g_hrat.hrat13 = b_hrat[l_ac].hrat13
           CALL i006_logic_chk_hrat13(g_hrat.*,b_hrat_t.hrat01) RETURNING g_hrat.*,l_hrag07    #mod by zhangbo130924
           IF NOT cl_null(g_errno) THEN 
            	CALL cl_err(g_hrat.hrat13,g_errno,0)
          	  NEXT FIELD hrat13
           ELSE 
              LET b_hrat[l_ac].hrat15 = g_hrat.hrat15		  	  	 	
          	  LET b_hrat[l_ac].hrat17 = g_hrat.hrat17		
           END IF    
                
        AFTER FIELD hrat15
           LET g_hrat.hrat15 = b_hrat[l_ac].hrat15
           CALL i006_logic_chk_hrat15(g_hrat.*) RETURNING g_hrat.*
           IF NOT cl_null(g_errno) THEN 
          	  CALL cl_err(g_hrat.hrat15,g_errno,0)
          	  NEXT FIELD hrat15
           ELSE 
           
           END IF 
                  
        AFTER FIELD hrat17
           LET g_hrat.hrat17 = b_hrat[l_ac].hrat17
           CALL i006_logic_chk_hrat17(g_hrat.*) RETURNING g_hrat.*
           IF NOT cl_null(g_errno) THEN 
           	  CALL cl_err(g_hrat.hrat17,g_errno,1)
          	  NEXT FIELD hrat17
           ELSE 
          
          END IF     
              
        AFTER FIELD hrat19
           LET g_hrat.hrat19 = b_hrat[l_ac].hrat19
           CALL i006_logic_chk_hrat19(g_hrat.*) RETURNING g_hrat.*
           IF NOT cl_null(g_errno) THEN 
           	  CALL cl_err(g_hrat.hrat19,g_errno,1)
           	  NEXT FIELD hrat19
           ELSE 
           
           END IF 
                  
        AFTER FIELD hrat20
           LET g_hrat.hrat20 = b_hrat[l_ac].hrat20
           CALL i006_logic_chk_hrat20(g_hrat.*) RETURNING g_hrat.*
           IF NOT cl_null(g_errno) THEN 
          	  CALL cl_err(g_hrat.hrat20,g_errno,1)
          	  NEXT FIELD hrat20
           ELSE 
          
           END IF    
                  
        AFTER FIELD hrat21
           LET g_hrat.hrat21 = b_hrat[l_ac].hrat21
           CALL i006_logic_chk_hrat21(g_hrat.*) RETURNING g_hrat.*
           IF NOT cl_null(g_errno) THEN 
          	  CALL cl_err(g_hrat.hrat21,g_errno,1)
          	  NEXT FIELD hrat21
           ELSE 
          
           END IF    
                 
        AFTER FIELD hrat22
           LET g_hrat.hrat22 = b_hrat[l_ac].hrat22
           CALL i006_logic_chk_hrat22(g_hrat.*) RETURNING g_hrat.*
           IF NOT cl_null(g_errno) THEN 
            	CALL cl_err(g_hrat.hrat22,g_errno,1)
          	  NEXT FIELD hrat22
           ELSE 
          
           END IF 
                  
        AFTER FIELD hrat25
           LET g_hrat.hrat25 = b_hrat[l_ac].hrat25
           CALL i006_logic_chk_hrat25(g_hrat.*) RETURNING g_hrat.*
           IF NOT cl_null(g_errno) THEN
          	  CALL cl_err(g_hrat.hrat25,g_errno,0)
          	  NEXT FIELD hrat25
           ELSE 
              DISPLAY g_hrat.hrat66 TO hrat66
           END IF 
                  
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE q006ks_bcl
              CANCEL INSERT
           END IF         
           CALL i006_logic_default('B',g_hrat.*) RETURNING g_hrat.*
           INSERT INTO hrat_file VALUES (g_hrat.*) 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","hrat_file",b_hrat[l_ac].hrat01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
              COMMIT WORK
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF b_hrat_t.hrat01 IS NOT NULL AND
               b_hrat_t.hrat03 IS NOT NULL AND
               b_hrat_t.hrat04 IS NOT NULL AND
               b_hrat_t.hrat05 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               INITIALIZE g_doc.* TO NULL               
               LET g_doc.column1 = "hrat01"             
               LET g_doc.value1 = b_hrat[l_ac].hrat01   
               LET g_doc.column2 = "hrat03"             
               LET g_doc.value2 = b_hrat[l_ac].hrat03     
               LET g_doc.column3 = "hrat04"             
               LET g_doc.value3 = b_hrat[l_ac].hrat04     
               LET g_doc.column4 = "hrat05"             
               LET g_doc.value4 = b_hrat[l_ac].hrat05     
               CALL cl_del_doc()                                  
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
               DELETE FROM hrat_file WHERE hrat01 = b_hrat_t.hrat01
                                       AND hrat02 = b_hrat_t.hrat02 
                                       AND hrat03 = b_hrat_t.hrat03
                                       AND hrat04 = b_hrat_t.hrat04
                                       AND hrat05 = b_hrat_t.hrat05
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","hrat",b_hrat_t.hrat01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  EXIT INPUT
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET b_hrat[l_ac].* = b_hrat_t.*
              CLOSE q006ks_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(b_hrat[l_ac].hrat01,-263,0)
               LET b_hrat[l_ac].* = b_hrat_t.*
           ELSE
               UPDATE hrat_file 
                  SET hrat_file.* = g_hrat.*
                WHERE hrat01=b_hrat_t.hrat01
                  AND hrat02=b_hrat_t.hrat02
                  AND hrat03=b_hrat_t.hrat03
                  AND hrat04=b_hrat_t.hrat04
                  AND hrat05=b_hrat_t.hrat05
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","hrat_file",b_hrat_t.hrat01,b_hrat_t.hrat02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                   LET b_hrat[l_ac].* = b_hrat_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
           LET l_ac_t = l_ac             # 新增
 
           IF INT_FLAG THEN 
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET b_hrat[l_ac].* = b_hrat_t.*
              END IF
              CLOSE q006ks_bcl            # 新增
              ROLLBACK WORK         # 新增
              EXIT INPUT
           END IF
           CLOSE q006ks_bcl            # 新增
           COMMIT WORK

      ON ACTION controlp
        CASE
           WHEN INFIELD(hrat03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 = b_hrat[l_ac].hrat03
              CALL cl_create_qry() RETURNING b_hrat[l_ac].hrat03
              DISPLAY BY NAME b_hrat[l_ac].hrat03
              NEXT FIELD hrat03
           WHEN INFIELD(hrat04)
              CALL cl_init_qry_var()
              IF NOT cl_null(b_hrat[l_ac].hrat03) THEN
                 LET g_qryparam.form = "q_hrao01" 
                 LET g_qryparam.arg1 = b_hrat[l_ac].hrat03
              ELSE
              	 LET g_qryparam.form = "q_hrao01_1"  
              END IF
              LET g_qryparam.default1 = b_hrat[l_ac].hrat04
              CALL cl_create_qry() RETURNING b_hrat[l_ac].hrat04
              DISPLAY BY NAME b_hrat[l_ac].hrat04
              NEXT FIELD hrat04
           WHEN INFIELD(hrat05)
              CALL cl_init_qry_var()
              IF NOT cl_null(b_hrat[l_ac].hrat04) THEN
                 LET g_qryparam.form = "q_hrap01" 
                 LET g_qryparam.arg1 = b_hrat[l_ac].hrat04
              ELSE
              	 LET g_qryparam.form = "q_hrap01_1"  
              END IF
              LET g_qryparam.default1 = b_hrat[l_ac].hrat05
              CALL cl_create_qry() RETURNING b_hrat[l_ac].hrat05
              DISPLAY BY NAME b_hrat[l_ac].hrat05
              NEXT FIELD hrat05
           WHEN INFIELD(hrat12)   
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '314'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = b_hrat[l_ac].hrat12
              CALL cl_create_qry() RETURNING b_hrat[l_ac].hrat12
              DISPLAY BY NAME b_hrat[l_ac].hrat12
              NEXT FIELD hrat12
           WHEN INFIELD(hrat17)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '333'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = b_hrat[l_ac].hrat17
              CALL cl_create_qry() RETURNING b_hrat[l_ac].hrat17
              DISPLAY BY NAME b_hrat[l_ac].hrat17
              NEXT FIELD hrat17
           WHEN INFIELD(hrat19)
              CALL cl_init_qry_var() 
              LET g_qryparam.form = "q_hrad02"
              LET g_qryparam.default1 = b_hrat[l_ac].hrat19
              CALL cl_create_qry() RETURNING b_hrat[l_ac].hrat19
              DISPLAY BY NAME b_hrat[l_ac].hrat19
              NEXT FIELD hrat19              
           WHEN INFIELD(hrat20)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '313'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = b_hrat[l_ac].hrat20
              CALL cl_create_qry() RETURNING b_hrat[l_ac].hrat20
              DISPLAY BY NAME b_hrat[l_ac].hrat20
              NEXT FIELD hrat20
           WHEN INFIELD(hrat21)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '337'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = b_hrat[l_ac].hrat21
              CALL cl_create_qry() RETURNING b_hrat[l_ac].hrat21
              DISPLAY BY NAME b_hrat[l_ac].hrat21
              NEXT FIELD hrat21
           WHEN INFIELD(hrat22)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '317'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = b_hrat[l_ac].hrat22
              CALL cl_create_qry() RETURNING b_hrat[l_ac].hrat22
              DISPLAY BY NAME b_hrat[l_ac].hrat22
              NEXT FIELD hrat22
       END CASE                             
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(hrat03) AND l_ac > 1 THEN
                LET b_hrat[l_ac].* = b_hrat[l_ac-1].*
                NEXT FIELD hrat03
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
        
        END INPUT
 
 
    CLOSE q006ks_bcl
    COMMIT WORK
END FUNCTION

#add by zhangbo130924---begin	
FUNCTION q006_ks_excel()
DEFINE   l_file                  STRING
DEFINE   p_row,p_col,l_n         SMALLINT
DEFINE   xlapp,iRes,iRow,i,j     INTEGER
DEFINE   li_k                    LIKE type_file.num5
DEFINE   li_i_r                  LIKE type_file.num5
DEFINE   lr_err DYNAMIC ARRAY OF RECORD
           line    STRING,
           key1    STRING,
           err     STRING
                END RECORD
DEFINE   l_msg     LIKE    ze_file.ze03  
DEFINE   l_hrag07  LIKE    hrag_file.hrag07              
                
        LET l_file = cl_browse_file()
        LET l_file = l_file CLIPPED
        IF cl_null(l_file) THEN
           CALL cl_err("未选择excel文件","!",0)
           RETURN
        END IF
        	
        CALL ui.interface.frontCall('WinCOM','CreateInstance',['Excel.Application'],[xlApp])
        IF xlApp <> -1 THEN
        CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'WorkBooks.Open',l_file],[iRes])
        IF iRes <> -1 THEN
           CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
           IF iRow > 1 THEN
              LET li_k = 1
              FOR i = 2 TO iRow
                 INITIALIZE g_hrat.* TO NULL
                 CALL i006_logic_default('A',g_hrat.*) RETURNING g_hrat.*
                 CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[g_hrat.hrat03])
                 CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',2).Value'],[g_hrat.hrat04])
                 CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[g_hrat.hrat05])
                 CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[g_hrat.hrat01])
                 CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[g_hrat.hrat02])
                 CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',6).Value'],[g_hrat.hrat12])
                 CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',7).Value'],[g_hrat.hrat13])
                 CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[g_hrat.hrat15])
                 CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',9).Value'],[g_hrat.hrat17])
                 CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',10).Value'],[g_hrat.hrat19])
                 CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',11).Value'],[g_hrat.hrat20])
                 CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',12).Value'],[g_hrat.hrat21])
                 CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',13).Value'],[g_hrat.hrat22])
                 CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',14).Value'],[g_hrat.hrat25])
                 
                 #检查hrat03
                 IF cl_null(g_hrat.hrat03) THEN
                 	  LET lr_err[li_k].line = i
                    LET lr_err[li_k].key1 = "公司编号/",g_hrat.hrat03
                    LET lr_err[li_k].err  = "公司编号为空"
                    LET li_k = li_k + 1
                    CONTINUE FOR
                 ELSE   
                    CALL i006_logic_chk_hrat03(g_hrat.*) RETURNING g_hrat.*
                    IF NOT cl_null(g_errno) THEN
                 	     CALL cl_getmsg(g_errno,2) RETURNING l_msg
                 	     LET lr_err[li_k].line = i
                       LET lr_err[li_k].key1 = "公司编号/",g_hrat.hrat03
                       LET lr_err[li_k].err  = l_msg
                       LET li_k = li_k + 1
                       CONTINUE FOR
                    END IF
                 END IF
                 	
                 #检查hrat04
                 IF cl_null(g_hrat.hrat04) THEN
                 	  LET lr_err[li_k].line = i
                    LET lr_err[li_k].key1 = "部门编号/",g_hrat.hrat04
                    LET lr_err[li_k].err  = "部门编号为空"
                    LET li_k = li_k + 1
                    CONTINUE FOR
                 ELSE   
                    CALL i006_logic_chk_hrat04(g_hrat.*) RETURNING g_hrat.*
                    IF NOT cl_null(g_errno) THEN
                 	     CALL cl_getmsg(g_errno,2) RETURNING l_msg
                 	     LET lr_err[li_k].line = i
                       LET lr_err[li_k].key1 = "部门编号/",g_hrat.hrat04
                       LET lr_err[li_k].err  = l_msg
                       LET li_k = li_k + 1
                       CONTINUE FOR
                    END IF
                 END IF 	   	   	   
                 	  
                 #检查hrat05
                 IF cl_null(g_hrat.hrat05) THEN
                 	  LET lr_err[li_k].line = i
                    LET lr_err[li_k].key1 = "职位编号/",g_hrat.hrat05
                    LET lr_err[li_k].err  = "职位编号为空"
                    LET li_k = li_k + 1
                    CONTINUE FOR
                 ELSE   
                    CALL i006_logic_chk_hrat05(g_hrat.*) RETURNING g_hrat.*
                    IF NOT cl_null(g_errno) THEN
                 	     CALL cl_getmsg(g_errno,2) RETURNING l_msg
                 	     LET lr_err[li_k].line = i
                       LET lr_err[li_k].key1 = "职位编号/",g_hrat.hrat05
                       LET lr_err[li_k].err  = l_msg
                       LET li_k = li_k + 1
                       CONTINUE FOR
                    END IF
                 END IF
                 	
                 #检查hrat01
                 IF cl_null(g_hrat.hrat01) THEN
                 	  LET lr_err[li_k].line = i
                    LET lr_err[li_k].key1 = "员工编号/",g_hrat.hrat01
                    LET lr_err[li_k].err  = "员工编号为空"
                    LET li_k = li_k + 1
                    CONTINUE FOR
                 ELSE   
                    CALL i006_logic_chk_hrat01(g_hrat.*) RETURNING g_hrat.*
                    IF NOT cl_null(g_errno) THEN
                 	     CALL cl_getmsg(g_errno,2) RETURNING l_msg
                 	     LET lr_err[li_k].line = i
                       LET lr_err[li_k].key1 = "员工编号/",g_hrat.hrat01
                       LET lr_err[li_k].err  = l_msg
                       LET li_k = li_k + 1
                       CONTINUE FOR
                    END IF
                 END IF	
                 	
                 #检查hrat02
                 IF cl_null(g_hrat.hrat02) THEN
                 	  LET lr_err[li_k].line = i
                    LET lr_err[li_k].key1 = "员工姓名/",g_hrat.hrat02
                    LET lr_err[li_k].err  = "员工姓名为空"
                    LET li_k = li_k + 1
                    CONTINUE FOR
                 END IF
                 
                 #检查hrat12
                 IF cl_null(g_hrat.hrat12) THEN
                 	  LET lr_err[li_k].line = i
                    LET lr_err[li_k].key1 = "证件类型/",g_hrat.hrat12
                    LET lr_err[li_k].err  = "证件类型为空"
                    LET li_k = li_k + 1
                    CONTINUE FOR
                 ELSE   
                    CALL i006_logic_chk_hrat12(g_hrat.*) RETURNING g_hrat.*
                    IF NOT cl_null(g_errno) THEN
                 	     CALL cl_getmsg(g_errno,2) RETURNING l_msg
                 	     LET lr_err[li_k].line = i
                       LET lr_err[li_k].key1 = "证件类型/",g_hrat.hrat12
                       LET lr_err[li_k].err  = l_msg
                       LET li_k = li_k + 1
                       CONTINUE FOR
                    END IF
                 END IF	
                 
                 #检查hrat13
                 IF cl_null(g_hrat.hrat13) THEN
                 	  LET lr_err[li_k].line = i
                    LET lr_err[li_k].key1 = "证件号码/",g_hrat.hrat13
                    LET lr_err[li_k].err  = "证件号码为空"
                    LET li_k = li_k + 1
                    CONTINUE FOR
                 ELSE   
                    CALL i006_logic_chk_hrat13(g_hrat.*,'') RETURNING g_hrat.*,l_hrag07
                    IF NOT cl_null(g_errno) THEN
                 	     CALL cl_getmsg(g_errno,2) RETURNING l_msg
                 	     LET lr_err[li_k].line = i
                       LET lr_err[li_k].key1 = "证件号码/",g_hrat.hrat13
                       LET lr_err[li_k].err  = l_msg
                       LET li_k = li_k + 1
                       CONTINUE FOR
                    END IF
                 END IF
                 	
                 #检查hrat15
                 IF cl_null(g_hrat.hrat15) THEN
                 	  LET lr_err[li_k].line = i
                    LET lr_err[li_k].key1 = "出生日期/",g_hrat.hrat15
                    LET lr_err[li_k].err  = "出生日期为空"
                    LET li_k = li_k + 1
                    CONTINUE FOR
                 ELSE   
                    CALL i006_logic_chk_hrat15(g_hrat.*) RETURNING g_hrat.*
                    IF NOT cl_null(g_errno) THEN
                 	     CALL cl_getmsg(g_errno,2) RETURNING l_msg
                 	     LET lr_err[li_k].line = i
                       LET lr_err[li_k].key1 = "出生日期/",g_hrat.hrat15
                       LET lr_err[li_k].err  = l_msg
                       LET li_k = li_k + 1
                       CONTINUE FOR
                    END IF
                 END IF	
                 	
                 #检查hrat17
                 IF cl_null(g_hrat.hrat17) THEN
                 	  LET lr_err[li_k].line = i
                    LET lr_err[li_k].key1 = "性别/",g_hrat.hrat17
                    LET lr_err[li_k].err  = "性别为空"
                    LET li_k = li_k + 1
                    CONTINUE FOR
                 ELSE   
                    CALL i006_logic_chk_hrat17(g_hrat.*) RETURNING g_hrat.*
                    IF NOT cl_null(g_errno) THEN
                 	     CALL cl_getmsg(g_errno,2) RETURNING l_msg
                 	     LET lr_err[li_k].line = i
                       LET lr_err[li_k].key1 = "出生日期/",g_hrat.hrat17
                       LET lr_err[li_k].err  = l_msg
                       LET li_k = li_k + 1
                       CONTINUE FOR
                    END IF
                 END IF
                 	
                 #检查hrat19
                 IF cl_null(g_hrat.hrat19) THEN
                 	  LET lr_err[li_k].line = i
                    LET lr_err[li_k].key1 = "员工状态/",g_hrat.hrat19
                    LET lr_err[li_k].err  = "员工状态为空"
                    LET li_k = li_k + 1
                    CONTINUE FOR
                 ELSE   
                    CALL i006_logic_chk_hrat19(g_hrat.*) RETURNING g_hrat.*
                    IF NOT cl_null(g_errno) THEN
                 	     CALL cl_getmsg(g_errno,2) RETURNING l_msg
                 	     LET lr_err[li_k].line = i
                       LET lr_err[li_k].key1 = "员工状态/",g_hrat.hrat19
                       LET lr_err[li_k].err  = l_msg
                       LET li_k = li_k + 1
                       CONTINUE FOR
                    END IF
                 END IF	
                 
                 #检查hrat20
                 IF cl_null(g_hrat.hrat20) THEN
                 	  LET lr_err[li_k].line = i
                    LET lr_err[li_k].key1 = "员工属性/",g_hrat.hrat20
                    LET lr_err[li_k].err  = "员工属性为空"
                    LET li_k = li_k + 1
                    CONTINUE FOR
                 ELSE   
                    CALL i006_logic_chk_hrat20(g_hrat.*) RETURNING g_hrat.*
                    IF NOT cl_null(g_errno) THEN
                 	     CALL cl_getmsg(g_errno,2) RETURNING l_msg
                 	     LET lr_err[li_k].line = i
                       LET lr_err[li_k].key1 = "员工属性/",g_hrat.hrat20
                       LET lr_err[li_k].err  = l_msg
                       LET li_k = li_k + 1
                       CONTINUE FOR
                    END IF
                 END IF
                 
                 #检查hrat21
                 IF cl_null(g_hrat.hrat21) THEN
                 	  LET lr_err[li_k].line = i
                    LET lr_err[li_k].key1 = "直接&间接/",g_hrat.hrat21
                    LET lr_err[li_k].err  = "直接&间接为空"
                    LET li_k = li_k + 1
                    CONTINUE FOR
                 ELSE   
                    CALL i006_logic_chk_hrat21(g_hrat.*) RETURNING g_hrat.*
                    IF NOT cl_null(g_errno) THEN
                 	     CALL cl_getmsg(g_errno,2) RETURNING l_msg
                 	     LET lr_err[li_k].line = i
                       LET lr_err[li_k].key1 = "直接&间接/",g_hrat.hrat21
                       LET lr_err[li_k].err  = l_msg
                       LET li_k = li_k + 1
                       CONTINUE FOR
                    END IF
                 END IF
                 	
                 #检查hrat22
                 IF cl_null(g_hrat.hrat22) THEN
                 	  LET lr_err[li_k].line = i
                    LET lr_err[li_k].key1 = "学历/",g_hrat.hrat22
                    LET lr_err[li_k].err  = "学历为空"
                    LET li_k = li_k + 1
                    CONTINUE FOR
                 ELSE   
                    CALL i006_logic_chk_hrat22(g_hrat.*) RETURNING g_hrat.*
                    IF NOT cl_null(g_errno) THEN
                 	     CALL cl_getmsg(g_errno,2) RETURNING l_msg
                 	     LET lr_err[li_k].line = i
                       LET lr_err[li_k].key1 = "学历/",g_hrat.hrat22
                       LET lr_err[li_k].err  = l_msg
                       LET li_k = li_k + 1
                       CONTINUE FOR
                    END IF
                 END IF
                 	
                 #检查hrat25
                 IF cl_null(g_hrat.hrat25) THEN
                 	  LET lr_err[li_k].line = i
                    LET lr_err[li_k].key1 = "入司日期/",g_hrat.hrat25
                    LET lr_err[li_k].err  = "入司日期为空"
                    LET li_k = li_k + 1
                    CONTINUE FOR
                 ELSE   
                    CALL i006_logic_chk_hrat25(g_hrat.*) RETURNING g_hrat.*
                    IF NOT cl_null(g_errno) THEN
                 	     CALL cl_getmsg(g_errno,2) RETURNING l_msg
                 	     LET lr_err[li_k].line = i
                       LET lr_err[li_k].key1 = "入司日期/",g_hrat.hrat25
                       LET lr_err[li_k].err  = l_msg
                       LET li_k = li_k + 1
                       CONTINUE FOR
                    END IF
                 END IF			
                 		
                 CALL i006_logic_default('B',g_hrat.*) RETURNING g_hrat.*
                 INSERT INTO hrat_file VALUES (g_hrat.*)
                 
                 IF SQLCA.sqlcode THEN
                 	  LET g_errno=SQLCA.sqlcode
                 	  CALL cl_getmsg(g_errno,2) RETURNING l_msg
                 	  LET lr_err[li_k].line = i
                    LET lr_err[li_k].key1 = "插入员工数据"
                    LET lr_err[li_k].err  = l_msg
                    LET li_k = li_k + 1
                    CONTINUE FOR 	
                 END IF	
                 	   
              END FOR   	
           END IF
        END IF
        END IF        
	
        CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
        CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes])
        
        IF lr_err.getLength() > 0 THEN
           CALL cl_show_array(base.TypeInfo.create(lr_err),cl_getmsg("lib-314",g_lang),"行序|栏位/值|错误描述")
        END IF	  	   	    		        

END FUNCTION
#add by zhangbo130924---end		
    


