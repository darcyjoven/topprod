# Prog. Version..: '5.25.01-10.05.01(00010)'     #
# Pattern name...: ghri088.4gl
# Descriptions...:
# Date & Author..: 13/6/28 By zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE  g_hrdta   DYNAMIC ARRAY OF RECORD
          hrdta02     LIKE    hrdta_file.hrdta02,
          hrds02      LIKE    hrds_file.hrds02,
          hrdta03     LIKE    hrdta_file.hrdta03,
          hrdta04     LIKE    hrdta_file.hrdta04,
          hrdta05     LIKE    hrdta_file.hrdta05,
          hrdk03      LIKE    hrdk_file.hrdk03,
          hrdta06     LIKE    hrdta_file.hrdta06,
          hrdta07     LIKE    hrdta_file.hrdta07,
          hrdta08     LIKE    hrdta_file.hrdta08,
          hrdta09     LIKE    hrdta_file.hrdta09,
          hrdta10     LIKE    hrdta_file.hrdta10,     
          hrdta11     LIKE    hrdta_file.hrdta11,
          hrdta12     LIKE    hrdta_file.hrdta12,
          hrdta13     LIKE    hrdta_file.hrdta13,
          #add by zhuzw 20140924 start
          ta_hrdta01  LIKE    hrdta_file.ta_hrdta01
          #add by zhuzw 20140924 end 
                   END RECORD
DEFINE  g_hrdta_t    RECORD
          hrdta02     LIKE    hrdta_file.hrdta02,
          hrds02      LIKE    hrds_file.hrds02,
          hrdta03     LIKE    hrdta_file.hrdta03,
          hrdta04     LIKE    hrdta_file.hrdta04,
          hrdta05     LIKE    hrdta_file.hrdta05,
          hrdk03      LIKE    hrdk_file.hrdk03,
          hrdta06     LIKE    hrdta_file.hrdta06,
          hrdta07     LIKE    hrdta_file.hrdta07,
          hrdta08     LIKE    hrdta_file.hrdta08,
          hrdta09     LIKE    hrdta_file.hrdta09,
          hrdta10     LIKE    hrdta_file.hrdta10,     
          hrdta11     LIKE    hrdta_file.hrdta11,
          hrdta12     LIKE    hrdta_file.hrdta12,
          hrdta13     LIKE    hrdta_file.hrdta13,
          #add by zhuzw 20140924 start
          ta_hrdta01  LIKE    hrdta_file.ta_hrdta01
          #add by zhuzw 20140924 end           
                   END RECORD 
DEFINE   g_rec_b         LIKE type_file.num5
DEFINE   l_ac            LIKE type_file.num5
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680102 INTEGER   
DEFINE   g_i             LIKE type_file.num5      #No.FUN-680102 SMALLINT   #count/index for any purpose
DEFINE   l_table         STRING                   #No.FUN-850016                                                                    
DEFINE   g_str           STRING                   #No.FUN-850016   
DEFINE   g_msg                 STRING
DEFINE   g_curs_index          LIKE type_file.num10
DEFINE   g_row_count           LIKE type_file.num10        #總筆數     
DEFINE   g_jump                LIKE type_file.num10        #查詢指定的筆數 
DEFINE   g_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗    
DEFINE   g_flag                LIKE type_file.chr10
DEFINE   g_tree DYNAMIC ARRAY OF RECORD
          name           LIKE type_file.chr1000,                 
          pid            LIKE type_file.chr1000, 
          id             LIKE hrdta_file.hrdta02,  
          has_children   BOOLEAN,                
          expanded       BOOLEAN,                
          level          LIKE type_file.num5,    
          treekey1       VARCHAR(1000),
          treekey2       VARCHAR(1000)
          END RECORD
DEFINE   l_tree_ac       LIKE type_file.num5
DEFINE   g_idx           LIKE type_file.num5          
DEFINE   g_curr_idx      INTEGER
DEFINE   gs_wc           STRING
DEFINE   g_before_input_done LIKE type_file.num5
DEFINE   g_sql          STRING


MAIN
DEFINE l_name   STRING
DEFINE l_items  STRING

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
   OPEN WINDOW i088_w WITH FORM "ghr/42f/ghri088"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   
   CALL cl_set_combo_items("hrdta03",NULL,NULL)
   CALL cl_set_combo_items("hrdta06",NULL,NULL)
   #统筹类型
   CALL i088_get_items('612') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdta03",l_name,l_items)
   #保留方式
   CALL i088_get_items('603') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdta06",l_name,l_items) 
   
   LET g_flag ='N'
 
   CALL i088_menu()
 
   CLOSE WINDOW i088_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN   

FUNCTION i088_get_items(p_hrag01)
DEFINE p_hrag01   LIKE  hrag_file.hrag01
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrag06 LIKE  hrag_file.hrag06
DEFINE l_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING

       LET l_sql=" SELECT hrag06,hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"'",
                 "  ORDER BY hrag06"
       PREPARE i088_get_items_pre FROM l_sql
       DECLARE i088_get_items CURSOR FOR i088_get_items_pre
       
       LET l_name=''
       LET l_items=''
       
       FOREACH i088_get_items INTO l_hrag06,l_hrag07
          IF cl_null(l_name) AND cl_null(l_items) THEN
            LET l_name=l_hrag06
            LET l_items=l_hrag07
          ELSE
            LET l_name=l_name CLIPPED,",",l_hrag06 CLIPPED
            LET l_items=l_items CLIPPED,",",l_hrag07 CLIPPED
          END IF
       END FOREACH
       
       RETURN l_name,l_items
END FUNCTION 
	
FUNCTION i088_menu()
DEFINE l_n   LIKE  type_file.num5
 
   WHILE TRUE
      CALL g_tree.clear()
      CALL g_hrdta.clear()
      SELECT COUNT(DISTINCT hrdt01) INTO l_n FROM hrdt_file 
      IF l_n>0 THEN 
         CALL i088_tree_fill()          
      END IF 
      	
      CALL i088_bp("G")   #包含第二页签的DISPLAY
 
      CASE g_action_choice
            	
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i088_b()
            ELSE
               LET g_action_choice = NULL
            END IF
            	   	  	
         WHEN "xinzeng"
            IF cl_chk_act_auth() THEN
               CALL cl_cmdrun_wait("ghri087")
               CALL i088_tree_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
          WHEN "ghri088_a"
            LET g_action_choice="ghri088_a"
            IF cl_chk_act_auth() THEN
               CALL ghri088_a(g_tree[l_tree_ac].id)
            ELSE
               LET g_action_choice = NULL
            END IF                                                                                                                                                                                                                         
         WHEN "help" 
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            	
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
                 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdta),'','')	    
            END IF
      END CASE
   END WHILE
 
END FUNCTION	
	
FUNCTION i088_tree_fill()
DEFINE l_sql    STRING
             
         LET l_sql=" SELECT DISTINCT hrdt01,hrdt02 FROM hrdt_file ORDER BY hrdt01,hrdt02"
         
         PREPARE i088_tree_pre FROM l_sql
         DECLARE i088_tree_cs CURSOR FOR i088_tree_pre
         
         LET g_idx=1
         
         FOREACH i088_tree_cs INTO g_tree[g_idx].id,g_tree[g_idx].name
            LET g_tree[g_idx].pid=NULL
            LET g_tree[g_idx].expanded=0
            LET g_tree[g_idx].has_children=FALSE
            LET g_tree[g_idx].level=0
            
            LET g_idx=g_idx+1
         
         END FOREACH
         
         CALL g_tree.deleteelement(g_idx)  #刪除FOREACH最後新增的空白列
         LET g_idx=g_idx-1   
             
END FUNCTION 
	
FUNCTION i088_b()
   DEFINE l_ac_t          LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #檢查重複用
          l_lock_sw       LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),               #單身鎖住否
          p_cmd           LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),               #處理狀態
          l_allow_insert  LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #可新增否
          l_allow_delete  LIKE type_file.num5      #No.FUN-680102 SMALLINT               #可刪除否
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_action_choice = ""
 
                      #FUN-510041 add hrdta05
   LET g_forupd_sql = " SELECT hrdta02,'',hrdta03,hrdta04,hrdta05,'',hrdta06,",
                      "        hrdta07,hrdta08,hrdta09,hrdta10,hrdta11,hrdta12,hrdta13,ta_hrdta01 ",
                      "   FROM hrdta_file ",  
                      "  WHERE  hrdta01= ? AND hrdta02= ? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i088_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_hrdta WITHOUT DEFAULTS FROM s_hrdta.*
         ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=TRUE,DELETE ROW=TRUE,
                   APPEND ROW=TRUE)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac      = ARR_CURR()
         LET l_n       = ARR_COUNT()
         LET l_lock_sw = 'N'            #DEFAULT
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_hrdta_t.* = g_hrdta[l_ac].*  #BACKUP
            OPEN i088_bcl USING g_tree[l_tree_ac].id,g_hrdta_t.hrdta02
            IF STATUS THEN
               CALL cl_err("OPEN i088_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i088_bcl INTO g_hrdta[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrdta_t.hrdta05,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
               END IF
            END IF
            	
            SELECT hrds02 INTO g_hrdta[l_ac].hrds02 FROM hrds_file
             WHERE hrds01=g_hrdta[l_ac].hrdta02
            SELECT hrdk03 INTO g_hrdta[l_ac].hrdk03 FROM hrdk_file
             WHERE hrdk01=g_hrdta[l_ac].hrdta05
             
            CALL cl_set_comp_entry("hrdta02",FALSE) 
              	
            IF cl_null(g_hrdta[l_ac].hrdta03) THEN
            	 LET g_hrdta[l_ac].hrdta04=NULL
            	 LET g_hrdta[l_ac].hrdta05=NULL
            	 LET g_hrdta[l_ac].hrdk03=NULL 
            	 CALL cl_set_comp_entry("hrdta04,hrdta05",FALSE)
            	 CALL cl_set_comp_required("hrdta04,hrdta05",FALSE)
            ELSE
            	 CALL cl_set_comp_entry("hrdta04,hrdta05",TRUE)
            	 CALL cl_set_comp_required("hrdta04,hrdta05",TRUE)	 
            END IF
            
            IF g_hrdta[l_ac].hrdta03='001' THEN
            	 CALL cl_set_comp_entry("hrdta04",TRUE)
            	 CALL cl_set_comp_required("hrdta04",TRUE)
            	 LET g_hrdta[l_ac].hrdta05=NULL
            	 LET g_hrdta[l_ac].hrdk03=NULL
            	 CALL cl_set_comp_entry("hrdta05",FALSE)
            	 CALL cl_set_comp_required("hrdta05",FALSE)
            END IF
            	
            IF g_hrdta[l_ac].hrdta03='002' THEN
            	 CALL cl_set_comp_entry("hrdta04",FALSE)
            	 CALL cl_set_comp_required("hrdta04",FALSE)
            	 LET g_hrdta[l_ac].hrdta04=NULL
            	 CALL cl_set_comp_entry("hrdta05",TRUE)
            	 CALL cl_set_comp_required("hrdta05",TRUE)
            END IF 		 		 
            	
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         ELSE
         	  CALL cl_set_comp_entry("hrdta02",TRUE)  
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_hrdta[l_ac].* TO NULL      #900423
         LET g_hrdta_t.* = g_hrdta[l_ac].*         #新輸入資料
         IF cl_null(g_hrdta[l_ac].hrdta03) THEN
            LET g_hrdta[l_ac].hrdta04=NULL
            LET g_hrdta[l_ac].hrdta05=NULL
            LET g_hrdta[l_ac].hrdk03=NULL 
            CALL cl_set_comp_entry("hrdta04,hrdta05",FALSE)
            CALL cl_set_comp_required("hrdta04,hrdta05",FALSE)
         ELSE
            CALL cl_set_comp_entry("hrdta04,hrdta05",TRUE)
            CALL cl_set_comp_required("hrdta04,hrdta05",TRUE)	 
         END IF
            
         IF g_hrdta[l_ac].hrdta03='001' THEN
         	 CALL cl_set_comp_entry("hrdta04",TRUE)
         	 CALL cl_set_comp_required("hrdta04",TRUE)
         	 LET g_hrdta[l_ac].hrdta05=NULL
         	 LET g_hrdta[l_ac].hrdk03=NULL
         	 CALL cl_set_comp_entry("hrdta05",FALSE)
         	 CALL cl_set_comp_required("hrdta05",FALSE)
         END IF
         	
         IF g_hrdta[l_ac].hrdta03='002' THEN
         	 CALL cl_set_comp_entry("hrdta04",FALSE)
         	 CALL cl_set_comp_required("hrdta04",FALSE)
         	 LET g_hrdta[l_ac].hrdta04=NULL
         	 CALL cl_set_comp_entry("hrdta05",TRUE)
         	 CALL cl_set_comp_required("hrdta05",TRUE)
         END IF 		
         	
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrdta02
         
      AFTER FIELD hrdta02
         IF NOT cl_null(g_hrdta[l_ac].hrdta02) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrds_file WHERE hrds01=g_hrdta[l_ac].hrdta02
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此社会统筹参数分类','!',0)
         	  	 NEXT FIELD hrdta02
         	  END IF
         	  
         	  IF g_hrdta[l_ac].hrdta02 != g_hrdta_t.hrdta02
         	  	 OR g_hrdta_t.hrdta02 IS NULL THEN
         	  	 LET l_n=0 
         	  	 SELECT COUNT(*) INTO l_n FROM hrdta_file
         	  	  WHERE hrdta01=g_tree[l_tree_ac].id
         	  	    AND hrdta02=g_hrdta[l_ac].hrdta02
         	  	 IF l_n>0 THEN
         	  	 	  CALL cl_err('已维护此统筹分类,不可重复维护','!',0)
         	  	 	  NEXT FIELD hrdta02
         	  	 END IF
         	  END IF
         	  
         	  SELECT hrds02 INTO g_hrdta[l_ac].hrds02 FROM hrds_file
         	   WHERE hrds01=g_hrdta[l_ac].hrdta02 		 		       		 
         	  	 
         END IF 
      
      AFTER FIELD hrdta03
         IF cl_null(g_hrdta[l_ac].hrdta03) THEN
            LET g_hrdta[l_ac].hrdta04=NULL
            LET g_hrdta[l_ac].hrdta05=NULL
            LET g_hrdta[l_ac].hrdk03=NULL 
            CALL cl_set_comp_entry("hrdta04,hrdta05",FALSE)
            CALL cl_set_comp_required("hrdta04,hrdta05",FALSE)
         ELSE
            CALL cl_set_comp_entry("hrdta04,hrdta05",TRUE)
            CALL cl_set_comp_required("hrdta04,hrdta05",TRUE)	 
         END IF
            
         IF g_hrdta[l_ac].hrdta03='001' THEN
         	  CALL cl_set_comp_entry("hrdta04",TRUE)
         	  CALL cl_set_comp_required("hrdta04",TRUE)
         	  LET g_hrdta[l_ac].hrdta05=NULL
         	  LET g_hrdta[l_ac].hrdk03=NULL
         	  CALL cl_set_comp_entry("hrdta05",FALSE)
         	  CALL cl_set_comp_required("hrdta05",FALSE)
         END IF
         	
         IF g_hrdta[l_ac].hrdta03='002' THEN
         	  CALL cl_set_comp_entry("hrdta04",FALSE)
         	  CALL cl_set_comp_required("hrdta04",FALSE)
         	  LET g_hrdta[l_ac].hrdta04=NULL
         	  CALL cl_set_comp_entry("hrdta05",TRUE)
         	  CALL cl_set_comp_required("hrdta05",TRUE)
         END IF 
         	
      AFTER FIELD hrdta05
         IF NOT cl_null(g_hrdta[l_ac].hrdta05) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrdk_file 
         	   WHERE hrdk01=g_hrdta[l_ac].hrdta05
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此薪资项','!',0)
         	  	 NEXT FIELD hrdta05
         	  END IF
         	  
         	  SELECT hrdk03 INTO g_hrdta[l_ac].hrdk03 FROM hrdk_file
         	   WHERE hrdk01=g_hrdta[l_ac].hrdta05
         
         END IF	     		  
            			 		 
         
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO hrdta_file(hrdta01,hrdta02,hrdta03,hrdta04,hrdta05,hrdta06,hrdta07,
                                hrdta08,hrdta09,hrdta10,hrdta11,hrdta12,hrdta13,
                                hrdtauser,hrdtagrup,hrdtaoriu,hrdtaorig,hrdtadate,hrdtaacti,ta_hrdta01)
                       VALUES(g_tree[l_tree_ac].id,g_hrdta[l_ac].hrdta02,
                              g_hrdta[l_ac].hrdta03,g_hrdta[l_ac].hrdta04,
                              g_hrdta[l_ac].hrdta05,g_hrdta[l_ac].hrdta06,
                              g_hrdta[l_ac].hrdta07,g_hrdta[l_ac].hrdta08,
                              g_hrdta[l_ac].hrdta09,g_hrdta[l_ac].hrdta10,
                              g_hrdta[l_ac].hrdta11,g_hrdta[l_ac].hrdta12,
                              g_hrdta[l_ac].hrdta13,     
                              g_user,g_grup,g_user,g_grup,g_today,'Y',g_hrdta[l_ac].ta_hrdta01)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrdta_file",g_hrdta[l_ac].hrdta02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            #DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_hrdta_t.hrdta02 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM hrdta_file WHERE hrdta01 = g_tree[l_tree_ac].id
                                     AND hrdta02 = g_hrdta_t.hrdta02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrdta_file",g_hrdta_t.hrdta02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            #DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_hrdta[l_ac].* = g_hrdta_t.*
            CLOSE i088_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_hrdta[l_ac].hrdta05,-263,1)
            LET g_hrdta[l_ac].* = g_hrdta_t.*
         ELSE
            UPDATE hrdta_file SET hrdta03=g_hrdta[l_ac].hrdta03,
                                  hrdta04=g_hrdta[l_ac].hrdta04,
                                  hrdta05=g_hrdta[l_ac].hrdta05,
                                  hrdta06=g_hrdta[l_ac].hrdta06,
                                  hrdta07=g_hrdta[l_ac].hrdta07,
                                  hrdta08=g_hrdta[l_ac].hrdta08,
                                  hrdta09=g_hrdta[l_ac].hrdta09,   
                                  hrdta10=g_hrdta[l_ac].hrdta10,
                                  hrdta11=g_hrdta[l_ac].hrdta11,
                                  hrdta12=g_hrdta[l_ac].hrdta12,
                                  hrdta13=g_hrdta[l_ac].hrdta13,
                                  ta_hrdta01 = g_hrdta[l_ac].ta_hrdta01
                            WHERE hrdta01 = g_tree[l_tree_ac].id
                              AND hrdta02 = g_hrdta_t.hrdta02 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hrdta_file",g_tree[l_tree_ac].id,g_hrdta_t.hrdta02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
               LET g_hrdta[l_ac].* = g_hrdta_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_hrdta[l_ac].* = g_hrdta_t.*
            END IF
            CLOSE i088_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i088_bcl
         COMMIT WORK
         
      ON ACTION controlp
          CASE 
              WHEN INFIELD(hrdta02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrds01"
                  LET g_qryparam.default1 = g_hrdta[l_ac].hrdta02
                  CALL cl_create_qry() RETURNING g_hrdta[l_ac].hrdta02
                  DISPLAY BY NAME g_hrdta[l_ac].hrdta02
                  NEXT FIELD hrdta02
                  
              WHEN INFIELD(hrdta05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrdk01"
                  LET g_qryparam.default1 = g_hrdta[l_ac].hrdta05
                  CALL cl_create_qry() RETURNING g_hrdta[l_ac].hrdta05
                  DISPLAY BY NAME g_hrdta[l_ac].hrdta05
                  NEXT FIELD hrdta05
          END CASE   
    
 
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
 
      #No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
      #No.FUN-6B0030-----End------------------     
 
   END INPUT
 
   CLOSE i088_bcl
 
   COMMIT WORK
 
END FUNCTION
	
FUNCTION i088_b_fill()  
   DEFINE p_wc   LIKE type_file.chr1000  #No.FUN-680102 VARCHAR(200)
 
   LET g_sql = "SELECT hrdta02,'',hrdta03,hrdta04,hrdta05,'',hrdta06,hrdta07,",
               "       hrdta08,hrdta09,hrdta10,hrdta11,hrdta12,hrdta13,ta_hrdta01 ",
               "  FROM hrdta_file ",                                         #FUN-B80058 add hrdta071,hrdta141
               " WHERE hrdta01 = '",g_tree[l_tree_ac].id,"' ",     
               " ORDER BY hrdta02"
   PREPARE i088_pb FROM g_sql
   DECLARE hrdta_curs CURSOR FOR i088_pb
 
   CALL g_hrdta.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH hrdta_curs INTO g_hrdta[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      
      SELECT hrds02 INTO g_hrdta[g_cnt].hrds02 FROM hrds_file
       WHERE hrds01=g_hrdta[g_cnt].hrdta02
      SELECT hrdk03 INTO g_hrdta[g_cnt].hrdk03 FROM hrdk_file
       WHERE hrdk01=g_hrdta[g_cnt].hrdta05	
      	                 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_hrdta.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
   #DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i088_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
   DEFINE   l_wc   LIKE type_file.chr1000
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
    DIALOG ATTRIBUTES(UNBUFFERED)
   
       DISPLAY ARRAY g_tree TO tree.* 
         BEFORE DISPLAY 
            CALL cl_navigator_setting( g_curs_index, g_row_count )
             
         BEFORE ROW
            #LET l_ac = ARR_CURR()
            LET l_tree_ac = ARR_CURR()            
            LET g_curr_idx = ARR_CURR()
            CALL i088_b_fill()    
            
                                       
       END DISPLAY 
            
        DISPLAY ARRAY g_hrdta TO s_hrdta.*  ATTRIBUTE(COUNT=g_rec_b)

        BEFORE DISPLAY
           CALL cl_navigator_setting( g_curs_index, g_row_count )

        BEFORE ROW
           LET l_ac = ARR_CURR()
           CALL cl_show_fld_cont()  
         
        ON ACTION accept
           LET l_ac=ARR_CURR()
           LET g_action_choice="detail"
           EXIT DIALOG
           
        ON ACTION detail
           LET l_ac=1
           LET g_action_choice="detail"
           EXIT DIALOG   
 
        ON ACTION exporttoexcel
           LET g_action_choice = 'exporttoexcel'
           EXIT DIALOG
            
        END DISPLAY      
                          
        ON ACTION xinzeng
           LET g_action_choice="xinzeng"
           EXIT DIALOG        
                    
        ON ACTION ghri088_a 
            LET g_action_choice="ghri088_a"
            IF cl_chk_act_auth() THEN
               CALL ghri088_a(g_tree[l_tree_ac].id)
            END IF
        ON ACTION help
           LET g_action_choice="help"
           CALL cl_show_help()               
           EXIT DIALOG
 
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()          
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
 
        ON ACTION cancel
           LET INT_FLAG=FALSE 		
           LET g_action_choice="exit"
           EXIT DIALOG
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DIALOG
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION				                                  
