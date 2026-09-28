# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri115.4gl
# Descriptions...: 
# Date & Author..: 03/15/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"


DEFINE 
     g_hrdi           DYNAMIC ARRAY OF RECORD    
        hrdi01       LIKE hrdi_file.hrdi01,     
        hrdi02       LIKE hrdi_file.hrdi02,   
        hrdi03       LIKE hrdi_file.hrdi03,     
        hrdi04       LIKE hrdi_file.hrdi04,
        hrdi05       LIKE hrdi_file.hrdi05,     
        hrdi06       LIKE hrdi_file.hrdi06,
        hrdi07       LIKE hrdi_file.hrdi07,
        hrdi08       LIKE hrdi_file.hrdi08   
                    END RECORD,
    g_hrdi_t         RECORD                 
        hrdi01       LIKE hrdi_file.hrdi01,     
        hrdi02       LIKE hrdi_file.hrdi02,   
        hrdi03       LIKE hrdi_file.hrdi03,     
        hrdi04       LIKE hrdi_file.hrdi04,
        hrdi05       LIKE hrdi_file.hrdi05,     
        hrdi06       LIKE hrdi_file.hrdi06,
        hrdi07       LIKE hrdi_file.hrdi07,
        hrdi08       LIKE hrdi_file.hrdi08 
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
    OPEN WINDOW i115_w AT p_row,p_col WITH FORM "ghr/42f/ghri115"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()
    
    #本作业只包含hrat_file资料
    SELECT gat01,gat03 INTO g_fno,g_fname FROM gat_file 
     WHERE gat01='hrat_file'
       AND gat02='2'          #简体中文                                                   

    CALL i115_b_fill()
    CALL i115_menu()
    CLOSE WINDOW i115_w                 
      CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i115_menu()
 
   WHILE TRUE
      CALL i115_bp("G")
      CASE g_action_choice
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i115_b()
            ELSE
               LET g_action_choice = NULL
            END IF
            	
         WHEN "data_import"
            IF cl_chk_act_auth() THEN
               IF cl_confirm("是否确认汇入员工表字段?") THEN
                  CALL i115_import()
                  CALL i115_b_fill()
               END IF
            END IF

         #add by zhangbo130906---begin
         WHEN "rscsll"
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdi),'','')
            END IF   
 
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i115_b()
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
 
    LET g_forupd_sql = "SELECT hrdi01,hrdi02,hrdi03,hrdi04,hrdi05,hrdi06,hrdi07,hrdi08",
                       "  FROM hrdi_file WHERE hrdi01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i115_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_hrdi WITHOUT DEFAULTS FROM s_hrdi.*
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
           LET g_hrdi_t.* = g_hrdi[l_ac].*  
           OPEN i115_bcl USING g_hrdi_t.hrdi01
           IF STATUS THEN
              CALL cl_err("OPEN i115_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i115_bcl INTO g_hrdi[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrdi_t.hrdi01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              
              #与薪资关联勾选后,不可再修改	
              IF g_hrdi[l_ac].hrdi06='Y' THEN
                 CALL cl_set_comp_entry("hrdi06",FALSE)
              	 CALL cl_set_comp_entry("hrdi07",TRUE)
              ELSE
                 CALL cl_set_comp_entry("hrdi06",TRUE)
                 CALL cl_set_comp_entry("hrdi07",FALSE)
              END IF

              IF g_hrdi[l_ac].hrdi07='Y' THEN
                 CALL cl_set_comp_required("hrdi08",TRUE)
                 CALL cl_set_comp_entry("hrdi08",TRUE)
              ELSE
                 CALL cl_set_comp_required("hrdi08",FALSE)
                 CALL cl_set_comp_entry("hrdi08",FALSE)
              END IF
              		 	
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF 
        	
    #BEFORE INSERT
    #     LET l_n = ARR_COUNT()
    #     LET p_cmd='a'                                                         
    #     LET g_before_input_done = FALSE                                                                                  
    #     LET g_before_input_done = TRUE                                         
    #     INITIALIZE g_hrdi[l_ac].* TO NULL      #900423  
    #     LET g_hrdi[l_ac].hrdiacti = 'Y'        #
    #     LET g_hrdi_t.* = g_hrdi[l_ac].*         
    #     CALL cl_show_fld_cont()     #FUN-550037(smin)
    #     NEXT FIELD hrdi01 
    #     
    #AFTER INSERT
    #    DISPLAY "AFTER INSERT" 
    #    IF INT_FLAG THEN
    #       CALL cl_err('',9001,0)
    #       LET INT_FLAG = 0
    #       CLOSE i115_bcl
    #       CANCEL INSERT
    #    END IF
    #
    #    BEGIN WORK                    #FUN-680010
    # 
    #    INSERT INTO hrdi_file(hrdi01,hrdi02,hrdi03,                          #FUN-A30097
    #                          hrdiacti,hrdiuser,hrdidate,hrdigrup,hrdioriu,hrdiorig)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
    #           VALUES(g_hrdi[l_ac].hrdi01,g_hrdi[l_ac].hrdi02,
    #           g_hrdi[l_ac].hrdi03,
    #           g_hrdi[l_ac].hrdiacti,g_user,g_today,g_grup,g_user,g_grup) #FUN-A30030 ADD POS   #No.FUN-980030 10/01/04  insert columns oriu, orig
    #    IF SQLCA.sqlcode THEN
    #       CALL cl_err3("ins","hrdi_file",g_hrdi[l_ac].hrdi01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
    #       ROLLBACK WORK              #FUN-680010
    #       CANCEL INSERT
    #    ELSE  
    #       LET g_rec_b=g_rec_b+1    
    #       DISPLAY g_rec_b TO FORMONLY.cn2     
    #       COMMIT WORK  
    #    END IF        	  	
        	
    #AFTER FIELD hrdi06  
    ON CHANGE hrdi06                      
       IF NOT cl_null(g_hrdi[l_ac].hrdi06) THEN       	 	  	                                            
          IF g_hrdi[l_ac].hrdi06 NOT MATCHES '[YN]' THEN 
             LET g_hrdi[l_ac].hrdi06 = g_hrdi_t.hrdi06
             NEXT FIELD hrdi06
          END IF    
          IF g_hrdi[l_ac].hrdi06='Y' THEN
             CALL cl_set_comp_entry("hrdi07",TRUE)
          ELSE
             CALL cl_set_comp_entry("hrdi07",FALSE)
          END IF                                          	
       END IF

    ON CHANGE hrdi07
       IF NOT cl_null(g_hrdi[l_ac].hrdi07) THEN
          IF g_hrdi[l_ac].hrdi07 NOT MATCHES '[YN]' THEN
             LET g_hrdi[l_ac].hrdi07 = g_hrdi_t.hrdi07
             NEXT FIELD hrdi07
          END IF
          IF g_hrdi[l_ac].hrdi07='Y' THEN
             CALL cl_set_comp_entry("hrdi08",TRUE)
             CALL cl_set_comp_required("hrdi08",TRUE)
          ELSE
             CALL cl_set_comp_entry("hrdi08",FALSE)
             CALL cl_set_comp_required("hrdi08",FALSE)
          END IF    
       END IF
       	
    #BEFORE DELETE                           
    #   IF g_hrdi_t.hrdi01 IS NOT NULL THEN
    #      IF NOT cl_delete() THEN
    #         ROLLBACK WORK      #FUN-680010
    #         CANCEL DELETE
    #      END IF
    #      INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
    #      LET g_doc.column1 = "hrdi01"               #No.FUN-9B0098 10/02/24
    #      LET g_doc.value1 = g_hrdi[l_ac].hrdi01      #No.FUN-9B0098 10/02/24
    #      CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
    #      IF l_lock_sw = "Y" THEN 
    #         CALL cl_err("", -263, 1) 
    #         ROLLBACK WORK      #FUN-680010
    #         CANCEL DELETE 
    #      END IF 
    #     
    #      DELETE FROM hrdi_file WHERE hrdi01 = g_hrdi_t.hrdi01
    #                
    #      IF SQLCA.sqlcode THEN
    #          CALL cl_err3("del","hrdi_file",g_hrdi_t.hrdi01,g_hrdi_t.hrdi02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
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
         LET g_hrdi[l_ac].* = g_hrdi_t.*
         CLOSE i115_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrdi[l_ac].hrdi01,-263,0)
          LET g_hrdi[l_ac].* = g_hrdi_t.*
       ELSE
          UPDATE hrdi_file SET hrdi06=g_hrdi[l_ac].hrdi06,
                               hrdi07=g_hrdi[l_ac].hrdi07,
                               hrdi08=g_hrdi[l_ac].hrdi08,
                               hrdimodu=g_user,
                               hrdidate=g_today
          WHERE hrdi01 = g_hrdi_t.hrdi01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrdi_file",g_hrdi_t.hrdi01,g_hrdi_t.hrdi02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK
             LET g_hrdi[l_ac].* = g_hrdi_t.*
          ELSE
             IF g_hrdi[l_ac].hrdi06='Y' THEN
                IF g_hrdi_t.hrdi06 IS NULL OR g_hrdi_t.hrdi06 != g_hrdi[l_ac].hrdi06 THEN
          	   CALL i115_ins_hrdh(g_hrdi[l_ac].hrdi01)
                END IF
             END IF

             CALL i115_upd_hrdh(g_hrdi[l_ac].hrdi01)	
      
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrdi[l_ac].* = g_hrdi_t.*
          END IF
          CLOSE i115_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i115_bcl                
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
 
    CLOSE i115_bcl
    COMMIT WORK
END FUNCTION
	
FUNCTION i115_b_fill()              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
    LET g_sql = "SELECT hrdi01,hrdi02,hrdi03,hrdi04,hrdi05,hrdi06,hrdi07,hrdi08",
                " FROM hrdi_file", 
                " ORDER BY 1" 
 
    PREPARE i115_pb FROM g_sql
    DECLARE hrdi_curs CURSOR FOR i115_pb
 
    CALL g_hrdi.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdi_curs INTO g_hrdi[g_cnt].*  
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
    CALL g_hrdi.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    IF g_rec_b>0 THEN
    	 DISPLAY g_fno TO fno
    	 DISPLAY g_fname TO fname
    END IF	   
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i115_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdi TO s_hrdi.* ATTRIBUTE(COUNT=g_rec_b)
 
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
      ON ACTION rscsll
         LET g_action_choice="rscsll"
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
	
FUNCTION i115_import()
DEFINE l_hrdi    RECORD LIKE  hrdi_file.*
DEFINE l_sql     STRING
DEFINE l_length  LIKE type_file.num5
DEFINE l_length1     LIKE type_file.chr20
DEFINE l_scale       LIKE type_file.num5
DEFINE l_nullable    LIKE type_file.chr1


{       
       LET l_sql="SELECT * FROM hrdi_file WHERE 1=1"
       PREPARE i115_hrdi_pre FROM l_sql
       DECLARE i115_hrdi_cs CURSOR FOR i115_hrdi_pre

       FOREACH i115_hrdi_cs INTO l_hrdi.*
          CASE l_hrdi.hrdi01
             WHEN 'hrat03'
                LET l_hrdi.hrdi08="SELECT UNIQUE hraa01,hraa12 FROM hraa_file WHERE  ( hraaacti = 'Y' ) AND  1=1 ORDER BY hraa01"
             WHEN 'hrat04'
                LET l_hrdi.hrdi08="SELECT hrao01,hrao02 FROM hrao_file WHERE 1=1 ORDER BY hrao01"
             WHEN 'hrat41'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='325' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat40'
                LET l_hrdi.hrdi08="SELECT hraf01,hraf02 FROM hraf_file WHERE  1=1 ORDER BY hraf01"
             WHEN 'hrat68'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='340' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat05'
                LET l_hrdi.hrdi08="SELECT UNIQUE hrap05,hrap06 FROM hrap_file WHERE  1=1 ORDER BY hrap05"
             WHEN 'hrat64'
                LET l_hrdi.hrdi08="SELECT UNIQUE hrar06,hrag07 FROM hrar_file,hrag_file WHERE  1=1 AND hrag01='204' AND hrar06=hrag06 ORDER BY hrar06 "
             WHEN 'hrat19'
                LET l_hrdi.hrdi08="SELECT UNIQUE hrad02,hrad03 FROM hrad_file WHERE  1=1 ORDER BY hrad02"
             WHEN 'hrat20'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='313' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat21'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='337' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat66'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='326' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat12'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='314' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat17'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='333' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat24'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='334' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat28'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='302' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat29'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='301' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat22'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='317' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat34'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='320' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat42'
                LET l_hrdi.hrdi08="SELECT hrai03,hrai04 FROM hrai_file WHERE  1=1 ORDER BY hrai03"
          END CASE

          UPDATE hrdi_file SET hrdi08=l_hrdi.hrdi08 WHERE hrdi01=l_hrdi.hrdi01

       END FOREACH
}



       IF cl_null(g_fno) THEN LET g_fno = 'hrat_file' END IF
       LET l_sql=" SELECT lower(column_name),lower(data_type),",       
                 " to_char(decode(data_precision,null,data_length,data_precision),'9999.99'),",       
                 " gaq03,data_scale,nullable ", 
                 " FROM (user_tab_columns LEFT OUTER JOIN gaq_file    ON lower(user_tab_columns.column_name)=gaq_file.gaq01 ",   
                 "  AND gaq_file.gaq02='",g_lang,"') ",
                 "  LEFT OUTER JOIN ztb_file ",    
                 " ON lower(user_tab_columns.column_name)=ztb_file.ztb03 ",
                 " WHERE lower(table_name)='",g_fno,"' ",
                 "   AND lower(column_name) NOT IN (SELECT hrdi01 from hrdi_file) ",
                 " ORDER BY column_id "
                 
       PREPARE i115_im_pre FROM l_sql
       DECLARE i115_im_cs CURSOR FOR i115_im_pre
       
       
       FOREACH i115_im_cs INTO l_hrdi.hrdi01,l_hrdi.hrdi02,l_length,
                               l_hrdi.hrdi05,l_scale,l_nullable

          LET l_hrdi.hrdi03=''
                               
          IF l_nullable='N' THEN
          	 LET l_nullable='Y'
          ELSE
          	 LET l_nullable='N'
          END IF
          	
          CASE WHEN l_hrdi.hrdi02 = 'varchar2'
                   LET l_length1=l_length CLIPPED
                   LET l_hrdi.hrdi03 = l_length1 CLIPPED
                   LET l_hrdi.hrdi04 = l_nullable
               WHEN l_hrdi.hrdi02 = 'char'
                   LET l_length1=l_length CLIPPED
                   LET l_hrdi.hrdi03 = l_length1 CLIPPED
                   LET l_hrdi.hrdi04 = l_nullable
              WHEN l_hrdi.hrdi02 = 'number'
                   LET l_length1=l_length
                   LET l_hrdi.hrdi03=l_length1 CLIPPED
                   LET l_length1=l_scale CLIPPED
                   IF l_length1<>'0' THEN
                      LET l_hrdi.hrdi03 = l_hrdi.hrdi03 CLIPPED,',',l_length1 CLIPPED
                   END IF
                   LET l_hrdi.hrdi04 = l_nullable
              OTHERWISE
                   LET l_hrdi.hrdi04 = l_nullable
          END CASE
         	
          LET l_hrdi.hrdi06='N'
          LET l_hrdi.hrdi07='N'

          LET l_hrdi.hrdi08 = ''
          CASE l_hrdi.hrdi01
             WHEN 'hrat03' 
                LET l_hrdi.hrdi08="SELECT UNIQUE hraa01,hraa12 FROM hraa_file WHERE  ( hraaacti = 'Y' ) AND  1=1 ORDER BY hraa01"
             WHEN 'hrat04'
                LET l_hrdi.hrdi08="SELECT hrao01,hrao02 FROM hrao_file WHERE 1=1 ORDER BY hrao01"
             WHEN 'hrat41'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='325' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat40'
                LET l_hrdi.hrdi08="SELECT hraf01,hraf02 FROM hraf_file WHERE  1=1 ORDER BY hraf01"
             WHEN 'hrat68' 
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='340' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat05'
                LET l_hrdi.hrdi08="SELECT UNIQUE hrap05,hrap06 FROM hrap_file WHERE  1=1 ORDER BY hrap05"
             WHEN 'hrat64'
                LET l_hrdi.hrdi08="SELECT UNIQUE hrar06,hrag07 FROM hrar_file,hrag_file WHERE  1=1 AND hrag01='204' AND hrar06=hrag06 ORDER BY hrar06 "
             WHEN 'hrat19'
                LET l_hrdi.hrdi08="SELECT UNIQUE hrad02,hrad03 FROM hrad_file WHERE  1=1 ORDER BY hrad02"
             WHEN 'hrat20'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='313' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat21'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='337' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat66'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='326' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat12'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='314' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat17'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='333' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat24'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='334' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat28'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='302' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat29'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='301' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat22'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='317' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat34'
                LET l_hrdi.hrdi08="SELECT hrag06,hrag07 FROM hrag_file WHERE  ( hrag01='320' ) AND  1=1 ORDER BY hrag06"
             WHEN 'hrat42'
                LET l_hrdi.hrdi08="SELECT hrai03,hrai04 FROM hrai_file WHERE  1=1 ORDER BY hrai03"    
          END CASE

          LET l_hrdi.hrdiacti='Y'
          LET l_hrdi.hrdiuser=g_user
          LET l_hrdi.hrdigrup=g_grup
          LET l_hrdi.hrdioriu=g_user
          LET l_hrdi.hrdiorig=g_grup
          LET l_hrdi.hrdidate=g_today
         
          INSERT INTO hrdi_file VALUES (l_hrdi.*)
         
       END FOREACH 			 	                                
                   
END FUNCTION
	
FUNCTION i115_ins_hrdh(p_hrdi01)
DEFINE p_hrdi01   LIKE  hrdi_file.hrdi01
DEFINE l_hrdi     RECORD LIKE   hrdi_file.*
DEFINE l_hrdh     RECORD LIKE   hrdh_file.*

       SELECT * INTO l_hrdi.* FROM hrdi_file WHERE hrdi01=p_hrdi01
       
       LET l_hrdh.hrdh02='001'
       SELECT hraa01 INTO l_hrdh.hrdh07 FROM hraa_file WHERE hraa10 IS NULL
       LET l_hrdh.hrdh06=l_hrdi.hrdi05
       LET l_hrdh.hrdh11=l_hrdi.hrdi02
       #LET l_hrdh.hrdh12="@" CLIPPED,l_hrdi.hrdi01         #mark by zhangbo130624---oracle存储过程不能包含@
       LET l_hrdh.hrdh12=l_hrdi.hrdi01                      #add by zhangbo130624
       
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

       LET l_hrdh.hrdh14=l_hrdi.hrdi07

       IF l_hrdh.hrdh14='Y' THEN
          LET l_hrdh.hrdh15=l_hrdi.hrdi08
       ELSE
          LET l_hrdh.hrdh15=''
       END IF
       
       INSERT INTO hrdh_file VALUES (l_hrdh.*)
       
END FUNCTION       
       	
FUNCTION i115_upd_hrdh(p_hrdi01)
DEFINE p_hrdi01   LIKE  hrdi_file.hrdi01
DEFINE l_hrdi     RECORD LIKE   hrdi_file.*
DEFINE l_hrdh     RECORD LIKE   hrdh_file.*

      SELECT * INTO l_hrdi.* FROM hrdi_file WHERE hrdi01=p_hrdi01

      IF l_hrdi.hrdi06='Y' THEN
         LET l_hrdh.hrdh14=l_hrdi.hrdi07
         IF l_hrdh.hrdh14='Y' THEN
            LET l_hrdh.hrdh15=l_hrdi.hrdi08
         ELSE
            LET l_hrdh.hrdh15=''
         END IF

         UPDATE hrdh_file SET hrdh14=l_hrdh.hrdh14,hrdh15=l_hrdh.hrdh15
          WHERE hrdh12=l_hrdi.hrdi01

      END IF
         
END FUNCTION       		  	  
       
        		                 

	
		
