# Prog. Version..: '5.25.01-10.05.01(00010)'     #
# Pattern name...: ghri068.4gl
# Descriptions...:
# Date & Author..: 13/5/24 By zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE   g_tree DYNAMIC ARRAY OF RECORD
          name           LIKE type_file.chr1000,                 
          pid            LIKE type_file.chr1000, 
          id             LIKE hrcy_file.hrcy01,  
          has_children   BOOLEAN,                
          expanded       BOOLEAN,                
          level          LIKE type_file.num5,    
          treekey1       VARCHAR(1000),
          treekey2       VARCHAR(1000)
          END RECORD
DEFINE   l_tree_ac       LIKE type_file.num5
DEFINE   g_idx           LIKE type_file.num5          
DEFINE   g_curr_idx      INTEGER

DEFINE   g_hrcya    DYNAMIC ARRAY OF RECORD
           hrcya02       LIKE    hrcya_file.hrcya02,
           hrcya03       LIKE    hrcya_file.hrcya03,
           hrcyauser     LIKE    hrcya_file.hrcyauser,
           hrcyamodu     LIKE    hrcya_file.hrcyamodu,
           hrcyadate     LIKE    hrcya_file.hrcyadate
                    END RECORD
DEFINE   g_hrcya_t  RECORD
           hrcya02       LIKE    hrcya_file.hrcya02,
           hrcya03       LIKE    hrcya_file.hrcya03,
           hrcyauser     LIKE    hrcya_file.hrcyauser,
           hrcyamodu     LIKE    hrcya_file.hrcyamodu,
           hrcyadate     LIKE    hrcya_file.hrcyadate
                    END RECORD
DEFINE   g_hrcyb    DYNAMIC ARRAY OF RECORD
           hrcyb03       LIKE    hrcyb_file.hrcyb03,
           hrcyb04       LIKE    hrcyb_file.hrcyb04,
           hrcyb05       LIKE    hrcyb_file.hrcyb05,
           hrcyb06       LIKE    hrcyb_file.hrcyb06,
           hrcyb07       LIKE    hrcyb_file.hrcyb07,
           hrcyb08       LIKE    hrcyb_file.hrcyb08,
           hrcyb09       LIKE    hrcyb_file.hrcyb09
                    END RECORD
DEFINE   g_hrcyb_t  RECORD
           hrcyb03       LIKE    hrcyb_file.hrcyb03,
           hrcyb04       LIKE    hrcyb_file.hrcyb04,
           hrcyb05       LIKE    hrcyb_file.hrcyb05,
           hrcyb06       LIKE    hrcyb_file.hrcyb06,
           hrcyb07       LIKE    hrcyb_file.hrcyb07,
           hrcyb08       LIKE    hrcyb_file.hrcyb08,
           hrcyb09       LIKE    hrcyb_file.hrcyb09
                    END RECORD
DEFINE   g_wc,g_wc2,g_sql     STRING
DEFINE   g_rec_b         LIKE type_file.num5
DEFINE   g_rec_b1        LIKE type_file.num5
DEFINE   l_ac            LIKE type_file.num5
DEFINE   l_ac1           LIKE type_file.num5
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
DEFINE   g_before_input_done   LIKE type_file.num5 
DEFINE   g_hrcya02             LIKE hrcya_file.hrcya02

MAIN

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
 
   OPEN WINDOW i068_w WITH FORM "ghr/42f/ghri068"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
  
   CALL cl_set_comp_visible("hrcya02,hrcyb03",FALSE)
 
   CALL i068_menu()
 
   CLOSE WINDOW i068_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN 

FUNCTION i068_menu()
DEFINE l_n   LIKE  type_file.num5
 
   WHILE TRUE
      CALL i068_tree_fill()
      CALL i068_bp("G")    #包含第一页签DISPLAY
  
      CASE g_action_choice
            	
         WHEN "detail"
            IF cl_chk_act_auth() THEN
            	 IF g_flag='Y' THEN
                  CALL i068_b()
               ELSE
               	  CALL i068_b1()
               END IF	     
            ELSE
               LET g_action_choice = NULL
            END IF
         
         WHEN "xinzeng"
            IF cl_chk_act_auth() THEN
               CALL cl_cmdrun_wait("ghri067")
               CALL i068_tree_fill()
            END IF              	                                                                                                                                                                                                                 
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              IF g_flag ='Y' THEN
                 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcya),'','')
              ELSE
              	 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcyb),'','')
              END IF	    
            END IF
      END CASE
   END WHILE
 
END FUNCTION
	
FUNCTION i068_tree_fill()
DEFINE l_sql    STRING
             
         LET l_sql=" SELECT DISTINCT hrcy01,hrcy01||hrcy02 FROM hrcy_file ORDER BY hrcy01"
         
         PREPARE i068_tree_pre FROM l_sql
         DECLARE i068_tree_cs CURSOR FOR i068_tree_pre
         
         LET g_idx=1
         
         FOREACH i068_tree_cs INTO g_tree[g_idx].id,g_tree[g_idx].name
            LET g_tree[g_idx].pid=NULL
            LET g_tree[g_idx].expanded=0
            LET g_tree[g_idx].has_children=FALSE
            LET g_tree[g_idx].level=0
            
            LET g_idx=g_idx+1
         
         END FOREACH
         
         CALL g_tree.deleteelement(g_idx)  #刪除FOREACH最後新增的空白列
         LET g_idx=g_idx-1   
             
END FUNCTION
	
FUNCTION i068_b()
   DEFINE l_ac_t          LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #檢查重複用
          l_lock_sw       LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),               #單身鎖住否
          p_cmd           LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),               #處理狀態
          l_allow_insert  LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #可新增否
          l_allow_delete  LIKE type_file.num5      #No.FUN-680102 SMALLINT               #可刪除否
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   
   IF g_tree[l_tree_ac].id IS NULL THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
      
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_action_choice = ""
 
   LET g_forupd_sql = " SELECT hrcya02,hrcya03,hrcyauser,hrcyamodu,hrcyadate ",
                      "   FROM hrcya_file ",  
                      "  WHERE hrcya01= ? AND hrcya02= ?  FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i068_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_hrcya WITHOUT DEFAULTS FROM s_hrcya.*
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
            LET g_hrcya_t.* = g_hrcya[l_ac].*  #BACKUP
            OPEN i068_bcl USING g_tree[l_tree_ac].id,g_hrcya_t.hrcya02
            IF STATUS THEN
               CALL cl_err("OPEN i068_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i068_bcl INTO g_hrcya[l_ac].hrcya02,g_hrcya[l_ac].hrcya03,
                                   g_hrcya[l_ac].hrcyauser,
                                   g_hrcya[l_ac].hrcyamodu,
                                   g_hrcya[l_ac].hrcyadate 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrcya_t.hrcya02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM hrcyb_file 
                WHERE hrcyb01=g_tree[l_tree_ac].id
                  AND hrcyb02=g_hrcya[l_ac].hrcya02
               IF l_n>0 THEN
                  CALL cl_err('该薪资等级档已维护薪资等级栏,不可更改','!',1)
                  EXIT INPUT
               END IF   
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_hrcya[l_ac].* TO NULL      #900423
         LET g_hrcya[l_ac].hrcyauser=g_user
         LET g_hrcya_t.* = g_hrcya[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrcya03
         
      AFTER FIELD hrcya03
         IF NOT cl_null(g_hrcya[l_ac].hrcya03) THEN
         	  IF g_hrcya[l_ac].hrcya03 != g_hrcya_t.hrcya03 
         	     OR g_hrcya_t.hrcya03 IS NULL THEN
         	     LET l_n=0
         	     SELECT COUNT(*) INTO l_n FROM hrcya_file 
         	      #WHERE hrcya01=g_tree[l_tree_ac].id
         	      #  AND hrcya03=g_hrcya[l_ac].hrcya03
                      WHERE hrcya03=g_hrcya[l_ac].hrcya03
         	     IF l_n>0 THEN
         	        CALL cl_err('薪资等级档名称不可重复','!',0)
         	        NEXT FIELD hrcya03
         	     END IF
         	  END IF
         END IF           
          
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         
         SELECT MAX(hrcya02) INTO g_hrcya[l_ac].hrcya02 FROM hrcya_file
          WHERE hrcya01=g_tree[l_tree_ac].id
         IF cl_null(g_hrcya[l_ac].hrcya02) THEN
            LET g_hrcya[l_ac].hrcya02='0000000001'
         ELSE
            LET g_hrcya[l_ac].hrcya02=g_hrcya[l_ac].hrcya02+1 USING "&&&&&&&&&&" 
         END IF      
         
         INSERT INTO hrcya_file(hrcya01,hrcya02,hrcya03,
                               hrcyauser,hrcyagrup,hrcyaoriu,hrcyaorig,hrcyadate,hrcyaacti)
                       VALUES(g_tree[l_tree_ac].id,
                              g_hrcya[l_ac].hrcya02,   
                              g_hrcya[l_ac].hrcya03,     
                              g_user,g_grup,g_user,g_grup,g_today,'Y')
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrcya_file",g_hrcya[l_ac].hrcya03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1  
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_hrcya_t.hrcya02 IS NOT NULL THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrcyb_file 
             WHERE hrcyb01=g_tree[l_tree_ac].id
               AND hrcyb02=g_hrcya_t.hrcya02
            IF l_n>0 THEN
               CALL cl_err('该薪资等级档已维护薪资等级栏,不可删除','!',1)
               CANCEL DELETE
            END IF           
                                                         
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM hrcya_file WHERE hrcya01 = g_tree[l_tree_ac].id
                                     AND hrcya02 = g_hrcya_t.hrcya02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrcya_file",g_hrcya_t.hrcya02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1  
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_hrcya[l_ac].* = g_hrcya_t.*
            CLOSE i068_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_hrcya[l_ac].hrcya03,-263,1)
            LET g_hrcya[l_ac].* = g_hrcya_t.*
         ELSE
            LET g_hrcya[l_ac].hrcyamodu=g_user
            LET g_hrcya[l_ac].hrcyadate=g_today
            UPDATE hrcya_file SET hrcya03=g_hrcya[l_ac].hrcya03,
                                  hrcyamodu=g_hrcya[l_ac].hrcyamodu,
                                  hrcyadate=g_hrcya[l_ac].hrcyadate  
             WHERE hrcya01 = g_tree[l_tree_ac].id
               AND hrcya02 = g_hrcya_t.hrcya02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hrcya_file",g_tree[l_tree_ac].id,g_hrcya_t.hrcya02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
               LET g_hrcya[l_ac].* = g_hrcya_t.*
            ELSE
               DISPLAY BY NAME g_hrcya[l_ac].hrcyamodu,g_hrcya[l_ac].hrcyadate
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
               LET g_hrcya[l_ac].* = g_hrcya_t.*
            END IF
            CLOSE i068_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i068_bcl
         COMMIT WORK
 
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
 
   CLOSE i068_bcl
 
   COMMIT WORK
 
END FUNCTION
	
FUNCTION i068_b1()
   DEFINE l_ac1_t         LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #檢查重複用
          l_lock_sw       LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),               #單身鎖住否
          p_cmd           LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),               #處理狀態
          l_allow_insert  LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #可新增否
          l_allow_delete  LIKE type_file.num5      #No.FUN-680102 SMALLINT               #可刪除否
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   
   IF g_tree[l_tree_ac].id IS NULL  OR g_hrcya[l_ac].hrcya02 IS NULL THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   
      
      
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_action_choice = ""
 
   LET g_forupd_sql = " SELECT hrcyb03,hrcyb04,hrcyb05,hrcyb06,hrcyb07,hrcyb08,hrcyb09 ",
                      "   FROM hrcyb_file ",  
                      "  WHERE hrcyb01= ? AND hrcyb02= ?  AND hrcyb03=? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i068_bcl1 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac1_t = 0
 
   INPUT ARRAY g_hrcyb WITHOUT DEFAULTS FROM s_hrcyb.*
         ATTRIBUTE(COUNT=g_rec_b1, MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=TRUE,DELETE ROW=TRUE,
                   APPEND ROW=TRUE)
 
      BEFORE INPUT
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(l_ac1)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac1      = ARR_CURR()
         LET l_n       = ARR_COUNT()
         LET l_lock_sw = 'N'            #DEFAULT
         IF g_rec_b1 >= l_ac1 THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_hrcyb_t.* = g_hrcyb[l_ac1].*  #BACKUP
            OPEN i068_bcl1 USING g_tree[l_tree_ac].id,g_hrcya[l_ac].hrcya02,g_hrcyb_t.hrcyb03
            IF STATUS THEN
               CALL cl_err("OPEN i068_bcl1:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i068_bcl1 INTO g_hrcyb[l_ac1].hrcyb03,g_hrcyb[l_ac1].hrcyb04,
                                   g_hrcyb[l_ac1].hrcyb05,g_hrcyb[l_ac1].hrcyb06,
                                   g_hrcyb[l_ac1].hrcyb07,g_hrcyb[l_ac1].hrcyb08,
                                   g_hrcyb[l_ac1].hrcyb09
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrcyb_t.hrcyb03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_hrcyb[l_ac1].* TO NULL      #900423
         LET g_hrcyb_t.* = g_hrcyb[l_ac1].*         #新輸入資料
         LET g_hrcyb[l_ac1].hrcyb04=g_hrcya[l_ac].hrcya03
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrcyb05
         
      AFTER FIELD hrcyb05
         IF NOT cl_null(g_hrcyb[l_ac1].hrcyb05) THEN
         	  IF g_hrcyb[l_ac1].hrcyb05 != g_hrcyb_t.hrcyb05 
         	     OR g_hrcyb_t.hrcyb05 IS NULL THEN
         	     LET l_n=0
         	     SELECT COUNT(*) INTO l_n FROM hrcyb_file 
         	      #WHERE hrcyb01=g_tree[l_tree_ac].id
         	      #  AND hrcyb02=g_hrcya[l_ac].hrcya02
         	      #  AND hrcyb05=g_hrcyb[l_ac1].hrcyb05
                      WHERE hrcyb05=g_hrcyb[l_ac1].hrcyb05 
         	     IF l_n>0 THEN
         	        CALL cl_err('薪资等级栏名称不可重复','!',0)
         	        NEXT FIELD hrcyb05
         	     END IF
         	  END IF
         END IF 
         
      AFTER FIELD hrcyb06
         IF NOT cl_null(g_hrcyb[l_ac1].hrcyb06) THEN
            IF NOT cl_null(g_hrcyb[l_ac1].hrcyb07) THEN
               IF g_hrcyb[l_ac1].hrcyb06>g_hrcyb[l_ac1].hrcyb06 THEN
                  CALL cl_err('最小值不可比最大值大','!',0)
                  NEXT FIELD hrcyb06
               END IF
            END IF
          END IF
          
      AFTER FIELD hrcyb07
         IF NOT cl_null(g_hrcyb[l_ac1].hrcyb07) THEN
            IF NOT cl_null(g_hrcyb[l_ac1].hrcyb06) THEN
               IF g_hrcyb[l_ac1].hrcyb06>g_hrcyb[l_ac1].hrcyb07 THEN
                  CALL cl_err('最大值不可比最小值小','!',0)
                  NEXT FIELD hrcyb07
               END IF
            END IF
          END IF 
          
      AFTER FIELD hrcyb08
         IF NOT cl_null(g_hrcyb[l_ac1].hrcyb08) THEN
            IF NOT cl_null(g_hrcyb[l_ac1].hrcyb06) AND NOT cl_null(g_hrcyb[l_ac1].hrcyb07) THEN
               IF g_hrcyb[l_ac1].hrcyb08>g_hrcyb[l_ac1].hrcyb07 
                 OR g_hrcyb[l_ac1].hrcyb08<g_hrcyb[l_ac1].hrcyb06 THEN
                  CALL cl_err('标准值必须在最大值和最小值之间','!',0)
                  NEXT FIELD hrcyb08
               END IF
            END IF
         END IF                                
          
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         
         SELECT MAX(hrcyb03) INTO g_hrcyb[l_ac1].hrcyb03 FROM hrcyb_file
          WHERE hrcyb01=g_tree[l_tree_ac].id
            AND hrcyb02=g_hrcya[l_ac].hrcya02
         IF cl_null(g_hrcyb[l_ac1].hrcyb03) THEN
            LET g_hrcyb[l_ac1].hrcyb03=1
         ELSE
            LET g_hrcyb[l_ac1].hrcyb03=g_hrcyb[l_ac1].hrcyb03+1 
         END IF      
         
         INSERT INTO hrcyb_file(hrcyb01,hrcyb02,hrcyb03,hrcyb04,hrcyb05,
                                hrcyb06,hrcyb07,hrcyb08,hrcyb09,
                                hrcybuser,hrcybgrup,hrcyboriu,hrcyborig,hrcybdate,hrcybacti)
                       VALUES(g_tree[l_tree_ac].id,
                              g_hrcya[l_ac].hrcya02,   
                              g_hrcyb[l_ac1].hrcyb03,
                              g_hrcyb[l_ac1].hrcyb04,
                              g_hrcyb[l_ac1].hrcyb05,
                              g_hrcyb[l_ac1].hrcyb06,
                              g_hrcyb[l_ac1].hrcyb07,
                              g_hrcyb[l_ac1].hrcyb08,
                              g_hrcyb[l_ac1].hrcyb09,     
                              g_user,g_grup,g_user,g_grup,g_today,'Y')
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrcyb_file",g_hrcyb[l_ac1].hrcyb05,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b1=g_rec_b1+1 
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_hrcyb_t.hrcyb03 IS NOT NULL THEN      
                                                         
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM hrcyb_file WHERE hrcyb01 = g_tree[l_tree_ac].id
                                     AND hrcyb02 = g_hrcya[l_ac].hrcya02
                                     AND hrcyb03 = g_hrcyb_t.hrcyb03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrcyb_file",g_hrcyb_t.hrcyb03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b1=g_rec_b1-1  
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_hrcyb[l_ac1].* = g_hrcyb_t.*
            CLOSE i068_bcl1
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_hrcyb[l_ac1].hrcyb05,-263,1)
            LET g_hrcyb[l_ac1].* = g_hrcyb_t.*
         ELSE
            UPDATE hrcyb_file SET hrcyb05=g_hrcyb[l_ac1].hrcyb05,
                                  hrcyb06=g_hrcyb[l_ac1].hrcyb06,
                                  hrcyb07=g_hrcyb[l_ac1].hrcyb07,
                                  hrcyb08=g_hrcyb[l_ac1].hrcyb08,
                                  hrcyb09=g_hrcyb[l_ac1].hrcyb09,
                                  hrcybmodu=g_user,
                                  hrcybdate=g_today  
             WHERE hrcyb01 = g_tree[l_tree_ac].id
               AND hrcyb02 = g_hrcya[l_ac].hrcya02
               AND hrcyb03 = g_hrcyb_t.hrcyb03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hrcyb_file",g_hrcya[l_ac].hrcya02,g_hrcyb_t.hrcyb05,SQLCA.sqlcode,"","",1)  #No.FUN-660131
               LET g_hrcyb[l_ac1].* = g_hrcyb_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac1 = ARR_CURR()
         LET l_ac1_t = l_ac1
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_hrcyb[l_ac1].* = g_hrcyb_t.*
            END IF
            CLOSE i068_bcl1
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i068_bcl1
         COMMIT WORK
 
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
 
   CLOSE i068_bcl1
 
   COMMIT WORK
 
END FUNCTION
	
FUNCTION i068_b_fill()  
   DEFINE p_wc   LIKE type_file.chr1000  #No.FUN-680102 VARCHAR(200)
 
   LET g_sql = "SELECT hrcya02,hrcya03,hrcyauser,hrcyamodu,hrcyadate",
               "  FROM hrcya_file ",                                         #FUN-B80058 add hrcya071,hrcya141
               " WHERE hrcya01 = '",g_tree[l_tree_ac].id,"' ",     
               " ORDER BY hrcya02"
   PREPARE i068_pb FROM g_sql
   DECLARE hrcya_curs CURSOR FOR i068_pb
 
   CALL g_hrcya.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH hrcya_curs INTO g_hrcya[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_hrcya.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1  
   LET g_cnt = 0
 
END FUNCTION
	
FUNCTION i068_b1_fill()  
   DEFINE p_wc   LIKE type_file.chr1000  #No.FUN-680102 VARCHAR(200)
 
   LET g_sql = "SELECT hrcyb03,hrcyb04,hrcyb05,hrcyb06,hrcyb07,hrcyb08,hrcyb09",
               "  FROM hrcyb_file ",                                         #FUN-B80058 add hrcyb071,hrcyb141
               " WHERE hrcyb01 = '",g_tree[l_tree_ac].id,"' ",
               "   AND hrcyb02 = '",g_hrcya[l_ac].hrcya02,"' ",     
               " ORDER BY hrcyb03"
   PREPARE i068_pb1 FROM g_sql
   DECLARE hrcyb_curs CURSOR FOR i068_pb1
 
   CALL g_hrcyb.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH hrcyb_curs INTO g_hrcyb[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_hrcyb.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b1 = g_cnt-1  
   LET g_cnt = 0
 
END FUNCTION
	
FUNCTION i068_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
   DEFINE   l_wc   LIKE type_file.chr1000
   DEFINE   l_n    LIKE type_file.num5
 
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
            #LET l_ac=1
            LET l_tree_ac = ARR_CURR()            
            LET g_curr_idx = ARR_CURR()  
            CALL g_hrcya.clear()
            CALL g_hrcyb.clear()
            LET g_rec_b=0
            LET g_rec_b1=0
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrcya_file WHERE hrcya01=g_tree[l_tree_ac].id
            IF l_n>0 THEN
               CALL i068_b_fill()
               LET l_ac=1
               LET l_n=0 
               SELECT COUNT(*) INTO l_n FROM hrcyb_file WHERE hrcyb01=g_tree[l_tree_ac].id
                                                          AND hrcyb02=g_hrcya[l_ac].hrcya02
               IF l_n>0 THEN
                  CALL i068_b1_fill()
               END IF
            END IF 	                     
                                       
      END DISPLAY 
     
            
      DISPLAY ARRAY g_hrcya TO s_hrcya.*  ATTRIBUTE(COUNT=g_rec_b)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
         CALL i068_b1_fill()  
                                        
      ON ACTION detail
         LET g_flag = "Y"
         LET g_action_choice="detail"
         EXIT DIALOG
         
      ON ACTION accept
         LET g_flag = "Y"
         LET g_action_choice="detail"
         EXIT DIALOG   
      
      ON ACTION exporttoexcel
         LET g_flag = "Y"
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG      
     
      END DISPLAY
      
       
      DISPLAY ARRAY g_hrcyb TO s_hrcyb.*  ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont() 
                                        
      ON ACTION detail
         LET g_flag = "N"
         LET g_action_choice="detail"
         EXIT DIALOG
         
      ON ACTION accept
         LET g_flag = "N"
         LET g_action_choice="detail"
         EXIT DIALOG   
      
      ON ACTION exporttoexcel
         LET g_flag = "N"
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
           
      END DISPLAY   

      ON ACTION xinzeng
         LET g_action_choice="xinzeng"
         EXIT DIALOG                                      
 
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
 
                                                                                      
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION		


	
			
	
	
		
	
	 	
	
	                                                          
