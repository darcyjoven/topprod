# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri077.4gl
# Descriptions...: 
# Date & Author..: 03/15/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"


DEFINE 
     g_hrdj           DYNAMIC ARRAY OF RECORD    
        hrdj01       LIKE hrdj_file.hrdj01,     
        hrdj02       LIKE hrdj_file.hrdj02,   
        hrdj03       LIKE hraa_file.hraa12,     
        hrdj04       LIKE hrdj_file.hrdj04,
        hrdj05       LIKE hrdj_file.hrdj05,     
        hrdj06       LIKE hrdj_file.hrdj06,
        hrdj07       LIKE hrdj_file.hrdj07
           
                    END RECORD,
    g_hrdj_t         RECORD                 
        hrdj01       LIKE hrdj_file.hrdj01,     
        hrdj02       LIKE hrdj_file.hrdj02,   
        hrdj03       LIKE hraa_file.hraa12,     
        hrdj04       LIKE hrdj_file.hrdj04,
        hrdj05       LIKE hrdj_file.hrdj05,     
        hrdj06       LIKE hrdj_file.hrdj06,
        hrdj07       LIKE hrdj_file.hrdj07
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                
    l_ac            LIKE type_file.num5                 
 
DEFINE g_forupd_sql STRING     
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5       
DEFINE g_str        STRING
DEFINE g_fno        LIKE gat_file.gat01
DEFINE g_fname      LIKE gat_file.gat03


MAIN

    DEFINE p_row,p_col   LIKE type_file.num5    
 
    OPTIONS                              
        INPUT NO WRAP
    DEFER INTERRUPT                      
 
  
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       
         RETURNING g_time    
 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i077_w AT p_row,p_col WITH FORM "ghr/42f/ghri077"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()
    
    CALL i077_b_fill()
    CALL i077_menu()
    CLOSE WINDOW i077_w                 
      CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i077_menu()
 
   WHILE TRUE
      CALL i077_bp("G")
      CASE g_action_choice
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i077_b()
            ELSE
               LET g_action_choice = NULL
            END IF
            	
         WHEN "data_import"
            IF cl_chk_act_auth() THEN
               IF cl_confirm("是否确认获取考勤项目?") THEN
                  CALL i077_import()
                  CALL i077_b_fill()
               END IF
            END IF

         #add by zhangbo130906---begin
         WHEN "kqcsll"
            IF cl_chk_act_auth() THEN
               CALL cl_cmdrun_wait("ghrq076")
            END IF
         #add by zhangbo130906---end
         
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdj),'','')
            END IF   
 
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i077_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1  
   
 
    IF s_shut(0) THEN RETURN END IF
    	
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hrdj01,hrdj02,hrdj03,hrdj04,hrdj05,hrdj06,hrdj07",
                       "  FROM hrdj_file WHERE hrdj01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i077_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_hrdj WITHOUT DEFAULTS FROM s_hrdj.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_rec_b,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF		
       	
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            
        LET l_n  = ARR_COUNT()
 
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'                                                         
           LET g_before_input_done = FALSE                                                                              
           LET g_before_input_done = TRUE                                                    
           LET g_hrdj_t.* = g_hrdj[l_ac].*  
           OPEN i077_bcl USING g_hrdj_t.hrdj01
           IF STATUS THEN
              CALL cl_err("OPEN i077_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i077_bcl INTO g_hrdj[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrdj_t.hrdj01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              	
              SELECT hraa12 INTO g_hrdj[l_ac].hrdj03 FROM hraa_file 
               WHERE hraa01=g_hrdj[l_ac].hrdj03
              DISPLAY BY NAME g_hrdj[l_ac].hrdj03 	
              
              #四个勾全部勾选后,不可再修改	
              IF g_hrdj[l_ac].hrdj04='Y' AND g_hrdj[l_ac].hrdj05='Y' 
              	 AND g_hrdj[l_ac].hrdj06='Y' AND g_hrdj[l_ac].hrdj07='Y'THEN
              	 EXIT INPUT
              END IF
              	
              #栏位勾选后不可更改
              IF g_hrdj[l_ac].hrdj04='Y' THEN
              	 CALL cl_set_comp_entry("hrdj04",FALSE)
              ELSE
              	 CALL cl_set_comp_entry("hrdj04",TRUE)
              END IF	
              	 	 
              IF g_hrdj[l_ac].hrdj05='Y' THEN
              	 CALL cl_set_comp_entry("hrdj05",FALSE)
              ELSE
              	 CALL cl_set_comp_entry("hrdj05",TRUE)
              END IF
              
              IF g_hrdj[l_ac].hrdj06='Y' THEN
              	 CALL cl_set_comp_entry("hrdj06",FALSE)
              ELSE
              	 CALL cl_set_comp_entry("hrdj06",TRUE)
              END IF
              	
              IF g_hrdj[l_ac].hrdj07='Y' THEN
              	 CALL cl_set_comp_entry("hrdj07",FALSE)
              ELSE
              	 CALL cl_set_comp_entry("hrdj07",TRUE)
              END IF			 	
              		 	
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF 
        	
    #BEFORE INSERT
    #     LET l_n = ARR_COUNT()
    #     LET p_cmd='a'                                                         
    #     LET g_before_input_done = FALSE                                                                                  
    #     LET g_before_input_done = TRUE                                         
    #     INITIALIZE g_hrdj[l_ac].* TO NULL      #900423  
    #     LET g_hrdj[l_ac].hrdjacti = 'Y'        #
    #     LET g_hrdj_t.* = g_hrdj[l_ac].*         
    #     CALL cl_show_fld_cont()     #FUN-550037(smin)
    #     NEXT FIELD hrdj01 
    #     
    #AFTER INSERT
    #    DISPLAY "AFTER INSERT" 
    #    IF INT_FLAG THEN
    #       CALL cl_err('',9001,0)
    #       LET INT_FLAG = 0
    #       CLOSE i077_bcl
    #       CANCEL INSERT
    #    END IF
    #
    #    BEGIN WORK                    #FUN-680010
    # 
    #    INSERT INTO hrdj_file(hrdj01,hrdj02,hrdj03,                          #FUN-A30097
    #                          hrdjacti,hrdjuser,hrdjdate,hrdjgrup,hrdjoriu,hrdjorig)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
    #           VALUES(g_hrdj[l_ac].hrdj01,g_hrdj[l_ac].hrdj02,
    #           g_hrdj[l_ac].hrdj03,
    #           g_hrdj[l_ac].hrdjacti,g_user,g_today,g_grup,g_user,g_grup) #FUN-A30030 ADD POS   #No.FUN-980030 10/01/04  insert columns oriu, orig
    #    IF SQLCA.sqlcode THEN
    #       CALL cl_err3("ins","hrdj_file",g_hrdj[l_ac].hrdj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
    #       ROLLBACK WORK              #FUN-680010
    #       CANCEL INSERT
    #    ELSE  
    #       LET g_rec_b=g_rec_b+1    
    #       DISPLAY g_rec_b TO FORMONLY.cn2     
    #       COMMIT WORK  
    #    END IF        	  	
        	
    AFTER FIELD hrdj04                        
       IF NOT cl_null(g_hrdj[l_ac].hrdj04) THEN       	 	  	                                            
          IF g_hrdj[l_ac].hrdj04 NOT MATCHES '[YN]' THEN 
             LET g_hrdj[l_ac].hrdj04 = g_hrdj_t.hrdj04
             NEXT FIELD hrdj04
          END IF                                              	
       END IF
    
    AFTER FIELD hrdj05                        
       IF NOT cl_null(g_hrdj[l_ac].hrdj05) THEN       	 	  	                                            
          IF g_hrdj[l_ac].hrdj05 NOT MATCHES '[YN]' THEN 
             LET g_hrdj[l_ac].hrdj05 = g_hrdj_t.hrdj05
             NEXT FIELD hrdj05
          END IF                                              	
       END IF
       	
    AFTER FIELD hrdj06                
       IF NOT cl_null(g_hrdj[l_ac].hrdj06) THEN       	 	  	                                            
          IF g_hrdj[l_ac].hrdj06 NOT MATCHES '[YN]' THEN 
             LET g_hrdj[l_ac].hrdj06 = g_hrdj_t.hrdj06
             NEXT FIELD hrdj06
          END IF                                              	
       END IF
       	
    AFTER FIELD hrdj07                        
       IF NOT cl_null(g_hrdj[l_ac].hrdj07) THEN       	 	  	                                            
          IF g_hrdj[l_ac].hrdj07 NOT MATCHES '[YN]' THEN 
             LET g_hrdj[l_ac].hrdj07 = g_hrdj_t.hrdj07
             NEXT FIELD hrdj07
          END IF                                              	
       END IF   	   	       	
    #BEFORE DELETE                           
    #   IF g_hrdj_t.hrdj01 IS NOT NULL THEN
    #      IF NOT cl_delete() THEN
    #         ROLLBACK WORK      #FUN-680010
    #         CANCEL DELETE
    #      END IF
    #      INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
    #      LET g_doc.column1 = "hrdj01"               #No.FUN-9B0098 10/02/24
    #      LET g_doc.value1 = g_hrdj[l_ac].hrdj01      #No.FUN-9B0098 10/02/24
    #      CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
    #      IF l_lock_sw = "Y" THEN 
    #         CALL cl_err("", -263, 1) 
    #         ROLLBACK WORK      #FUN-680010
    #         CANCEL DELETE 
    #      END IF 
    #     
    #      DELETE FROM hrdj_file WHERE hrdj01 = g_hrdj_t.hrdj01
    #                
    #      IF SQLCA.sqlcode THEN
    #          CALL cl_err3("del","hrdj_file",g_hrdj_t.hrdj01,g_hrdj_t.hrdj02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
    #          ROLLBACK WORK      #FUN-680010
    #          CANCEL DELETE
    #          EXIT INPUT
    #      ELSE
    #      	 LET g_rec_b=g_rec_b-1
    #      	 DISPLAY g_rec_b TO cn2    
    #      END IF
    #
    #   END IF
       	
    ON ROW CHANGE
       IF INT_FLAG THEN             
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hrdj[l_ac].* = g_hrdj_t.*
         CLOSE i077_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrdj[l_ac].hrdj01,-263,0)
          LET g_hrdj[l_ac].* = g_hrdj_t.*
       ELSE
          UPDATE hrdj_file SET hrdj04=g_hrdj[l_ac].hrdj04,
                               hrdj05=g_hrdj[l_ac].hrdj05,
                               hrdj06=g_hrdj[l_ac].hrdj06,
                               hrdj07=g_hrdj[l_ac].hrdj07,
                               hrdjmodu=g_user,
                               hrdjdate=g_today
          WHERE hrdj01 = g_hrdj_t.hrdj01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrdj_file",g_hrdj_t.hrdj01,g_hrdj_t.hrdj02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK
             LET g_hrdj[l_ac].* = g_hrdj_t.*
          ELSE
          	 IF g_hrdj[l_ac].hrdj04='Y' AND g_hrdj[l_ac].hrdj04 != g_hrdj_t.hrdj04 THEN
          	 	  CALL i077_ins_hrdh_LC(g_hrdj[l_ac].hrdj01)
          	 END IF
          	 IF g_hrdj[l_ac].hrdj05='Y' AND g_hrdj[l_ac].hrdj05 != g_hrdj_t.hrdj05 THEN
          	 	  CALL i077_ins_hrdh_LF(g_hrdj[l_ac].hrdj01)
          	 END IF	
          	 IF g_hrdj[l_ac].hrdj06='Y' AND g_hrdj[l_ac].hrdj06 != g_hrdj_t.hrdj06 THEN
          	 	  CALL i077_ins_hrdh_LS(g_hrdj[l_ac].hrdj01)
          	 END IF	
          	 IF g_hrdj[l_ac].hrdj07='Y' AND g_hrdj[l_ac].hrdj07 != g_hrdj_t.hrdj07 THEN
          	 	  CALL i077_ins_hrdh_LT(g_hrdj[l_ac].hrdj01)
          	 END IF	      
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrdj[l_ac].* = g_hrdj_t.*
          END IF
          CLOSE i077_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i077_bcl                
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
 
    END INPUT
 
    CLOSE i077_bcl
    COMMIT WORK
END FUNCTION
	
FUNCTION i077_b_fill()              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
    LET g_sql = "SELECT hrdj01,hrdj02,hrdj03,hrdj04,hrdj05,hrdj06,hrdj07",
                " FROM hrdj_file", 
                " ORDER BY 1" 
 
    PREPARE i077_pb FROM g_sql
    DECLARE hrdj_curs CURSOR FOR i077_pb
 
    CALL g_hrdj.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdj_curs INTO g_hrdj[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        	
        SELECT hraa12 INTO g_hrdj[g_cnt].hrdj03 FROM hraa_file
         WHERE hraa01=g_hrdj[g_cnt].hrdj03	
         
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdj.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2	   
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i077_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdj TO s_hrdj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
         DISPLAY l_ac TO FORMONLY.cnt
         
      ON ACTION data_import
         LET g_action_choice="data_import"
         EXIT DISPLAY   

      #add by zhangbo130906---begin
      ON ACTION kqcsll
         LET g_action_choice="kqcsll"
         EXIT DISPLAY
      #add by zhangbo130906---end
 
      ON ACTION detail
         LET g_action_choice="detail"
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION	
	
FUNCTION i077_import()
DEFINE l_hrdj    RECORD LIKE  hrdj_file.*
DEFINE l_sql     STRING
DEFINE l_length  LIKE type_file.num5
DEFINE l_length1     LIKE type_file.chr20
DEFINE l_scale       LIKE type_file.num5
DEFINE l_nullable    LIKE type_file.chr1
   #添加班次信息相关的假勤项目
   INSERT INTO hrbm_file (hrbm01,hrbm02,hrbm03,hrbm04,hrbm05,hrbm06,hrbm07,hrbm09,hrbm13,hrbm14,hrbm15,hrbm16,hrbm17,hrbm18,hrbm19,hrbm20,hrbm21,hrbm23,hrbm24,hrbm25,hrbm36,hrbmuser,hrbmgrup,hrbmmodu,hrbmdate,hrbmorig,hrbmoriu)
   SELECT '0000','999','9'||hrbo02,hrbo03,1,'003','Y','Y','N',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',hrbouser,hrbogrup,hrbomodu,hrbodate,hrboorig,hrbooriu FROM hrbo_file
   WHERE NOT EXISTS(SELECT 1 FROM hrbm_file WHERE hrbm03='9'||hrbo02)
   #添加日历节假日类型的假勤项目
   INSERT INTO hrbm_file (hrbm01,hrbm02,hrbm03,hrbm04,hrbm05,hrbm06,hrbm07,hrbm09,hrbm13,hrbm14,hrbm15,hrbm16,hrbm17,hrbm18,hrbm19,hrbm20,hrbm21,hrbm23,hrbm24,hrbm25,hrbm36,hrbmuser,hrbmgrup,hrbmmodu,hrbmdate,hrbmorig,hrbmoriu)
   SELECT '0000','999','8'||hrag06,hrag07,1,'003','Y','Y','N',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ','tiptop','0000','tiptop','2000/01/01','0000','tiptop' FROM hrag_file
   WHERE hrag01='105' AND NOT EXISTS(SELECT 1 FROM hrbm_file WHERE hrbm03='8'||hrag06)
       LET l_sql=" SELECT hrbm03,hrbm04,hrbm01,'N','N','N','N' ",
                 "  FROM hrbm_file ",
                 " WHERE hrbm03 NOT IN (SELECT hrdj01 FROM hrdj_file)",
                 "  ORDER BY hrbm03 "
                 
       PREPARE i077_im_pre FROM l_sql
       DECLARE i077_im_cs CURSOR FOR i077_im_pre
       
       
       FOREACH i077_im_cs INTO l_hrdj.hrdj01,l_hrdj.hrdj02,l_hrdj.hrdj03,
                               l_hrdj.hrdj04,l_hrdj.hrdj05,l_hrdj.hrdj06,
                               l_hrdj.hrdj07

          
          LET l_hrdj.hrdjacti='Y'
          LET l_hrdj.hrdjuser=g_user
          LET l_hrdj.hrdjgrup=g_grup
          LET l_hrdj.hrdjoriu=g_user
          LET l_hrdj.hrdjorig=g_grup
          LET l_hrdj.hrdjdate=g_today
         
          INSERT INTO hrdj_file VALUES (l_hrdj.*)
         
       END FOREACH 			 	                                
                   
END FUNCTION
	
FUNCTION i077_ins_hrdh_LC(p_hrdj01)
DEFINE p_hrdj01   LIKE  hrdj_file.hrdj01
DEFINE l_hrdj     RECORD LIKE   hrdj_file.*
DEFINE l_hrdh     RECORD LIKE   hrdh_file.*

       SELECT * INTO l_hrdj.* FROM hrdj_file WHERE hrdj01=p_hrdj01
       
       LET l_hrdh.hrdh02='003'
       LET l_hrdh.hrdh03='001'
       LET l_hrdh.hrdh07=l_hrdj.hrdj03
       LET l_hrdh.hrdh06=l_hrdj.hrdj02 CLIPPED,"_累计次数"
       #LET l_hrdh.hrdh12="@hrcjaLC" CLIPPED,l_hrdj.hrdj01    #mark by zhangbo130624---oracle存储过程参数不能包含@
       LET l_hrdh.hrdh12="hrcjaLC" CLIPPED,l_hrdj.hrdj01      #add by zhangbo130624
       
       SELECT MAX(hrdh01) INTO l_hrdh.hrdh01 FROM hrdh_file
       IF l_hrdh.hrdh01 IS NULL THEN
       	  LET l_hrdh.hrdh01=1
       ELSE
       	  LET l_hrdh.hrdh01=l_hrdh.hrdh01+1
       END IF
       
       LET l_hrdh.hrdh10='N'      	
       LET l_hrdh.hrdhacti='Y'
       LET l_hrdh.hrdhuser=g_user
       LET l_hrdh.hrdhgrup=g_grup
       LET l_hrdh.hrdhoriu=g_user
       LET l_hrdh.hrdhorig=g_grup
       LET l_hrdh.hrdhdate=g_today	

       SELECT F_TRANS_PINYIN_CAPITAL(l_hrdh.hrdh06) INTO l_hrdh.hrdh13 FROM DUAL    #add by zhangbo130821
       
       INSERT INTO hrdh_file VALUES (l_hrdh.*)
       
END FUNCTION  
	
FUNCTION i077_ins_hrdh_LF(p_hrdj01)
DEFINE p_hrdj01   LIKE  hrdj_file.hrdj01
DEFINE l_hrdj     RECORD LIKE   hrdj_file.*
DEFINE l_hrdh     RECORD LIKE   hrdh_file.*

       SELECT * INTO l_hrdj.* FROM hrdj_file WHERE hrdj01=p_hrdj01
       
       LET l_hrdh.hrdh02='003'
       LET l_hrdh.hrdh03='002'
       LET l_hrdh.hrdh07=l_hrdj.hrdj03
       LET l_hrdh.hrdh06=l_hrdj.hrdj02 CLIPPED,"_累计分钟"
       #LET l_hrdh.hrdh12="@hrcjaLF" CLIPPED,l_hrdj.hrdj01    #mark by zhangbo130624---oracle存储过程不能包含@
       LET l_hrdh.hrdh12="hrcjaLF" CLIPPED,l_hrdj.hrdj01      #add by zhangbo130624
       
       SELECT MAX(hrdh01) INTO l_hrdh.hrdh01 FROM hrdh_file
       IF l_hrdh.hrdh01 IS NULL THEN
       	  LET l_hrdh.hrdh01=1
       ELSE
       	  LET l_hrdh.hrdh01=l_hrdh.hrdh01+1
       END IF
       
       LET l_hrdh.hrdh10='N'      	
       LET l_hrdh.hrdhacti='Y'
       LET l_hrdh.hrdhuser=g_user
       LET l_hrdh.hrdhgrup=g_grup
       LET l_hrdh.hrdhoriu=g_user
       LET l_hrdh.hrdhorig=g_grup
       LET l_hrdh.hrdhdate=g_today	

       SELECT F_TRANS_PINYIN_CAPITAL(l_hrdh.hrdh06) INTO l_hrdh.hrdh13 FROM DUAL    #add by zhangbo130821
       
       INSERT INTO hrdh_file VALUES (l_hrdh.*)
       
END FUNCTION 
	
FUNCTION i077_ins_hrdh_LS(p_hrdj01)
DEFINE p_hrdj01   LIKE  hrdj_file.hrdj01
DEFINE l_hrdj     RECORD LIKE   hrdj_file.*
DEFINE l_hrdh     RECORD LIKE   hrdh_file.*

       SELECT * INTO l_hrdj.* FROM hrdj_file WHERE hrdj01=p_hrdj01
       
       LET l_hrdh.hrdh02='003'
       LET l_hrdh.hrdh03='003'
       LET l_hrdh.hrdh07=l_hrdj.hrdj03
       LET l_hrdh.hrdh06=l_hrdj.hrdj02 CLIPPED,"_累计小时"
       #LET l_hrdh.hrdh12="@hrcjaLS" CLIPPED,l_hrdj.hrdj01       #mark by zhangbo130624---oracle存储过程不能包含@
       LET l_hrdh.hrdh12="hrcjaLS" CLIPPED,l_hrdj.hrdj01         #add by zhangbo130624
       
       SELECT MAX(hrdh01) INTO l_hrdh.hrdh01 FROM hrdh_file
       IF l_hrdh.hrdh01 IS NULL THEN
       	  LET l_hrdh.hrdh01=1
       ELSE
       	  LET l_hrdh.hrdh01=l_hrdh.hrdh01+1
       END IF
       
       LET l_hrdh.hrdh10='N'      	
       LET l_hrdh.hrdhacti='Y'
       LET l_hrdh.hrdhuser=g_user
       LET l_hrdh.hrdhgrup=g_grup
       LET l_hrdh.hrdhoriu=g_user
       LET l_hrdh.hrdhorig=g_grup
       LET l_hrdh.hrdhdate=g_today	

       SELECT F_TRANS_PINYIN_CAPITAL(l_hrdh.hrdh06) INTO l_hrdh.hrdh13 FROM DUAL    #add by zhangbo130821
       
       INSERT INTO hrdh_file VALUES (l_hrdh.*)
       
END FUNCTION 
	
FUNCTION i077_ins_hrdh_LT(p_hrdj01)
DEFINE p_hrdj01   LIKE  hrdj_file.hrdj01
DEFINE l_hrdj     RECORD LIKE   hrdj_file.*
DEFINE l_hrdh     RECORD LIKE   hrdh_file.*

       SELECT * INTO l_hrdj.* FROM hrdj_file WHERE hrdj01=p_hrdj01
       
       LET l_hrdh.hrdh02='003'
       LET l_hrdh.hrdh03='004'
       LET l_hrdh.hrdh07=l_hrdj.hrdj03
       LET l_hrdh.hrdh06=l_hrdj.hrdj02 CLIPPED,"_累计天数"
       #LET l_hrdh.hrdh12="@hrcjaLT" CLIPPED,l_hrdj.hrdj01          #mark by zhangbo130624---oracle存储过程不能包含@
       LET l_hrdh.hrdh12="hrcjaLT" CLIPPED,l_hrdj.hrdj01            #add by zhangbo130624
       
       SELECT MAX(hrdh01) INTO l_hrdh.hrdh01 FROM hrdh_file
       IF l_hrdh.hrdh01 IS NULL THEN
       	  LET l_hrdh.hrdh01=1
       ELSE
       	  LET l_hrdh.hrdh01=l_hrdh.hrdh01+1
       END IF
       
       LET l_hrdh.hrdh10='N'      	
       LET l_hrdh.hrdhacti='Y'
       LET l_hrdh.hrdhuser=g_user
       LET l_hrdh.hrdhgrup=g_grup
       LET l_hrdh.hrdhoriu=g_user
       LET l_hrdh.hrdhorig=g_grup
       LET l_hrdh.hrdhdate=g_today	

       SELECT F_TRANS_PINYIN_CAPITAL(l_hrdh.hrdh06) INTO l_hrdh.hrdh13 FROM DUAL    #add by zhangbo130821
       
       INSERT INTO hrdh_file VALUES (l_hrdh.*)
       
END FUNCTION 			     
       	
       		  	  
       
        		                 

	
		
