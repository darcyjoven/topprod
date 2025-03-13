# Prog. Version..: '5.20.01-10.05.01(00000)'     #
#
# Pattern name...: ghri088_a.4gl
# Descriptions...: 兵役状况 
# Date & Author..: 14/03/11 wy
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
     g_sch         DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables) 
        X      LIKE type_file.chr1,
        hrat01 LIKE hrat_file.hrat01, #工号,
        hrat02 LIKE hrat_file.hrat02, #姓名,
        hrao02 LIKE hrao_file.hrao02, #部门,
        hras04 LIKE hras_file.hras04, #职位,
        hrat25 LIKE hrat_file.hrat25, #入司日期,
        hrdu04 LIKE hrdu_file.hrdu04, #开始薪资月,
        hratid LIKE hrat_file.hratid  #
                    END RECORD,
    g_sch_t        RECORD                 #程式變數 (舊值)
        X      LIKE type_file.chr1,
        hrat01 LIKE hrat_file.hrat01, #工号,
        hrat02 LIKE hrat_file.hrat02, #姓名,
        hrao02 LIKE hrao_file.hrao02, #部门,
        hras04 LIKE hras_file.hras04, #职位,
        hrat25 LIKE hrat_file.hrat25, #入司日期,
        hrdu04 LIKE hrdu_file.hrdu04, #开始薪资月,
        hratid LIKE hrat_file.hratid  #
                    END RECORD,
    g_wc2,g_sql_h    LIKE type_file.chr1000,       
    g_rec_b_h         LIKE type_file.num5,                #單身筆數        
    l_ac_h            LIKE type_file.num5                 #目前處理的ARRAY CNT        
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_cnt_h           LIKE type_file.num10     
DEFINE g_hrdta     RECORD LIKE hrdta_file.* 
DEFINE p_hrdu02      LIKE hrdu_file.hrdu02
DEFINE p_hrdu03      LIKE hrdu_file.hrdu03,
       g_hrdta04  LIKE hrdta_file.hrdta04, 
       g_hrdta04_007  LIKE hrdta_file.hrdta04
                    
                    
FUNCTION ghri088_a(l_hrdu02)
DEFINE p_row,p_col   LIKE type_file.num5   
DEFINE l_hrdu02      LIKE hrdu_file.hrdu02
DEFINE l_hrdu03      LIKE hrdu_file.hrdu03 
DEFINE l_hrdt02      LIKE hrdt_file.hrdt02 
      

   IF cl_null(l_hrdu02)  THEN
   	  RETURN
   END IF	 
   
   LET p_hrdu02=l_hrdu02
   #LET p_hrdu03=l_hrdu03
   
   LET g_forupd_sql = " select * from hrdta_file WHERE hrdta01=?     ", 
                      " FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i088_a_cl CURSOR FROM g_forupd_sql 
  
   LET p_row = 4 LET p_col = 15
   OPEN WINDOW i088_a_w AT p_row,p_col WITH FORM "ghr/42f/ghri088_a"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   WHENEVER ERROR CALL cl_err_msg_log 
   CALL cl_set_comp_visible("hrati01",false)
   CALL cl_set_comp_entry('hratid',false) 
   CALL cl_set_comp_entry("chkhrdta04,chkhrdta04_007",TRUE)
    
   LET g_wc2 = " hrdu02='",p_hrdu02,"'"
   
   SELECT hrdt02 INTO l_hrdt02 FROM hrdt_file WHERE hrdt01=p_hrdu02
   DISPLAY p_hrdu02 TO hrdu02
   DISPLAY l_hrdt02 TO hrdu02_name
   DISPLAY 'N' TO chkhrdta04
   DISPLAY 'N' TO chkhrdta04_007
   
   CALL i088_a_b_fill(g_wc2)
   CALL i088_a_menu()
   #CALL i088_a_i('u')
   
   CLOSE WINDOW i088_a_w                   
END FUNCTION

FUNCTION i088_a_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_hrat04      LIKE hrat_file.hrat04
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5 , 
          l_hrfta02_name like hrag_file.hrag07, 
          l_hrat01  LIKE hrat_file.hrat01,
          l_hrdta04  LIKE hrdta_file.hrdta04, 
          l_hrdta04_007  LIKE hrdta_file.hrdta04,
          l_chkhrdta04 LIKE type_file.chr1,
          l_chkhrdta04_007 LIKE type_file.chr1 
    
   INPUT l_chkhrdta04,l_hrdta04,l_chkhrdta04_007,l_hrdta04_007 
   FROM  chkhrdta04,hrdta04,chkhrdta04_007,hrdta04_007      #WITHOUT DEFAULTS
 
      BEFORE INPUT
         #CALL i130_1_set_no_entry(p_cmd)
         LET l_chkhrdta04='N'
         LET l_chkhrdta04_007='N'
         DISPLAY 'N' TO chkhrdta04  
         DISPLAY 'N' TO chkhrdta04_007
       
      AFTER INPUT
        IF INT_FLAG THEN
           EXIT INPUT
        END IF 
       
      #AFTER FIELD chkhrdta04
      #   IF l_chkhrdta04='Y' THEN 
      #      CALL cl_set_comp_entry("hrdta04",TRUE)
      #      SELECT hrdta04 INTO g_hrdta04 
      #      FROM hrdta_file WHERE hrdta01=p_hrdu02  and hrdta02='001'
      #       DISPLAY g_hrdta04 TO hrdta04
      #   ELSE
      #      CALL cl_set_comp_entry("hrdta04",FALSE)
      #      LET g_hrdta04=''
      #      DISPLAY g_hrdta04 TO hrdta04
      #  END IF
       AFTER FIELD hrdta04
         IF NOT cl_null(l_hrdta04) THEN
           LET  g_hrdta04=l_hrdta04
         END IF
        # IF l_chkhrdta04='Y' THEN  
        #    SELECT hrdta04 INTO g_hrdta04
        #    FROM hrdta_file WHERE hrdta01=p_hrdu02  and hrdta02='001'
        #     DISPLAY g_hrdta04 TO hrdta04 
        # ELSE 
        #    LET g_hrdta04=''
        #    DISPLAY g_hrdta04 TO hrdta04
        #END IF
       
       AFTER FIELD hrdta04_007
         IF NOT cl_null(l_hrdta04_007) THEN
           LET  g_hrdta04_007=l_hrdta04_007
         END IF
      #   IF l_chkhrdta04_007='Y' THEN 
      #      CALL cl_set_comp_entry("hrdta04_007",TRUE)
      #      SELECT hrdta04 INTO g_hrdta04_007 
      #      FROM hrdta_file WHERE hrdta01=p_hrdu02  and hrdta02='007'
      #       DISPLAY g_hrdta04_007 TO hrdta04_007
      #   ELSE
      #      LET g_hrdta04_007=''
      #      DISPLAY g_hrdta04_007 TO hrdta04_007
      #  END IF
        
      
        
       ON CHANGE  chkhrdta04
         LET g_hrdta04 = ''
         IF l_chkhrdta04='Y' THEN 
            CALL cl_set_comp_entry("hrdta04",TRUE)
            SELECT hrdta04 INTO g_hrdta04 
            FROM hrdta_file WHERE hrdta01=p_hrdu02  and hrdta02='001'
            DISPLAY g_hrdta04 TO hrdta04
         ELSE
            CALL cl_set_comp_entry("hrdta04",FALSE)
            LET g_hrdta04=''
            DISPLAY g_hrdta04 TO hrdta04
        END IF
        
       ON CHANGE  chkhrdta04_007
         IF l_chkhrdta04_007='Y' THEN 
            CALL cl_set_comp_entry("hrdta04_007",TRUE)
            SELECT hrdta04 INTO g_hrdta04_007 
            FROM hrdta_file WHERE hrdta01=p_hrdu02  and hrdta02='007'
             DISPLAY g_hrdta04_007 TO hrdta04_007
         ELSE
            CALL cl_set_comp_entry("hrdta04_007",FALSE)
            LET g_hrdta04_007=''
            DISPLAY g_hrdta04_007 TO hrdta04_007
        END IF
    
      
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION help   
         CALL cl_show_help()  
 
   END INPUT
   CALL i088_a_b()
END FUNCTION
 
FUNCTION i088_a_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   
   WHILE TRUE
      CALL i088_a_bp("G")
      CASE g_action_choice 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i088_a_b()
            ELSE
               LET g_action_choice = NULL
            END IF 
         WHEN "select_all"    #全部選取
            CALL i088_a_sel_all('Y')
         WHEN "modify"    # 
           CALL i088_a_i('u')
          
         WHEN "select_non"    #全部不選
            CALL i088_a_sel_all('N')
         
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask() 
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sch),'','')
            END IF 
 
      END CASE
   END WHILE
  
END FUNCTION
 
FUNCTION i088_a_sel_all(p_flag) #全选和取消
  DEFINE  p_flag   LIKE type_file.chr1 
  DEFINE  l_i      LIKE type_file.num5
  FOR l_i = 1 TO g_rec_b_h 
    LET g_sch[l_i].X = p_flag
     
    DISPLAY BY NAME g_sch[l_i].X
  END FOR
END FUNCTION   
 
FUNCTION i088_a_b()
DEFINE
   l_ac_h_t,l_x_n        LIKE type_file.num5,                #未取消的ARRAY CNT        
   l_n             LIKE type_file.num5,                #檢查重複用       
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        
   p_cmd           LIKE type_file.chr1,                #處理狀態        
   l_allow_insert  LIKE type_file.chr1,                #可新增否
   l_allow_delete  LIKE type_file.chr1,                #可刪除否
   l_aaaacti       LIKE aaa_file.aaaacti,
   l_x string,
   l_sql string
   
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
   
   DISPLAY g_hrdta04 TO hrdta04
   DISPLAY g_hrdta04_007 TO hrdta04_007
   
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = " SELECT *
                            FROM hrdu_file 
                            where hrdu02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i088_a_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_sch WITHOUT DEFAULTS FROM s_sch.*
     ATTRIBUTE (COUNT=g_rec_b_h,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = false,DELETE ROW=FALSE,APPEND ROW=false) 
 
       BEFORE INPUT
          IF g_rec_b_h != 0 THEN
             CALL fgl_set_arr_curr(l_ac_h)
          END IF
          
       AFTER FIELD X
         IF g_sch[l_ac_h].X='Y' and g_sch_t.X!=g_sch[l_ac_h].X THEN
         	 LET l_x="'",g_sch[l_ac_h].hrat01,"',",l_x
         END IF 
         
         
       BEFORE ROW
          LET p_cmd=''
          LET l_ac_h = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()

          IF g_rec_b_h>=l_ac_h THEN 
             BEGIN WORK
             LET p_cmd='u'                                                                 
             LET g_sch_t.* = g_sch[l_ac_h].*  #BACKUP
             OPEN i088_a_bcl USING p_hrdu02
             IF STATUS THEN
                CALL cl_err("OPEN i088_a_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             END IF 
             CALL cl_show_fld_cont()      
          END IF 	 
        
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_sch[l_ac_h].* = g_sch_t.*
             CLOSE i088_a_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
           
 
       AFTER ROW
          LET l_ac_h = ARR_CURR()            
          LET l_ac_h_t = l_ac_h             
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_sch[l_ac_h].* = g_sch_t.*
             END IF
             CLOSE i088_a_bcl            
             ROLLBACK WORK         
             EXIT INPUT
          END IF
 
          CLOSE i088_a_bcl           
          COMMIT WORK 
       
 
       ON ACTION CONTROLZ
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
         
      ON ACTION select_all
         CALL i088_a_sel_all('Y')
      
      ON ACTION select_non
         CALL i088_a_sel_all('N') 
            
      AFTER INPUT
        CALL i088_update()
        
   END INPUT
 
   CLOSE i088_a_bcl
   COMMIT WORK 
END FUNCTION

FUNCTION i088_update()
DEFINE  l_i,l_x_n      LIKE type_file.num5,
        l_x,l_sql_001,l_sql_002,l_sql_003,l_sql_004,l_sql_005,l_sql_007 STRING ,
        l_hrdta08_001 LIKE hrdta_file.hrdta08,
        l_hrdta09_001 LIKE hrdta_file.hrdta09,
        l_hrdta08_002 LIKE hrdta_file.hrdta08,
        l_hrdta09_002 LIKE hrdta_file.hrdta09,
        l_hrdta08_003 LIKE hrdta_file.hrdta08,
        l_hrdta09_003 LIKE hrdta_file.hrdta09,
        l_hrdta08_004 LIKE hrdta_file.hrdta08,
        l_hrdta09_004 LIKE hrdta_file.hrdta09,
        l_hrdta08_005 LIKE hrdta_file.hrdta08,
        l_hrdta09_005 LIKE hrdta_file.hrdta09,
        l_hrdta08_007 LIKE hrdta_file.hrdta08,
        l_hrdta09_007 LIKE hrdta_file.hrdta09,
        l_success LIKE type_file.chr1
  
  LET l_x=''  
  LET l_sql_001=''
  LET l_sql_002=''
  LET l_sql_003=''
  LET l_sql_004=''
  LET l_sql_005=''
  LET l_sql_007=''
  LET l_success='Y'
     
  FOR l_i = 1 TO g_rec_b_h 
    IF g_sch[l_i].X='Y' THEN
        LET l_x="'",g_sch[l_i].hratid,"',",l_x
    END IF  
  END FOR
  
  IF l_x!='' OR NOT cl_null(l_x) THEN 
    LET l_x_n=l_x.getlength()-1
    LET l_x=l_x.substring(1,l_x_n)  #  l_x[1,l_x_n]
    
    LET l_sql_001= 
                  " MERGE INTO HRDU_FILE TAB1",
                  " USING HRDTA_FILE TAB2",
                  " ON (HRDTA02 = HRDU05 AND HRDTA01 = HRDU02)",
                  " WHEN MATCHED THEN",
                  "  UPDATE SET HRDU08 = HRDTA08, HRDU10 = HRDTA09", 
                  "  WHERE HRDU01 IN (",l_x ,")"

    LET l_sql_002=" UPDATE HRDU_FILE SET HRDU07 = ",g_hrdta04,",HRDU09 = ",g_hrdta04,
                  "  WHERE HRDU01 IN (",l_x ,")",
                  "    AND HRDU05 <> '007'",
                  "    AND EXISTS (SELECT 1",
                  "           FROM HRDTA_FILE",
                  "          WHERE HRDTA01 = '",p_hrdu02,"'",
                  "            AND HRDTA02 = HRDU05",
                  "            AND TA_HRDTA01 = 'N')"

    LET l_sql_007=" UPDATE HRDU_FILE SET HRDU07 = ",g_hrdta04_007,",HRDU09 = ",g_hrdta04_007,
                  "  WHERE HRDU01 IN (",l_x ,")",
                  "    AND HRDU05 = '007'",
                  "    AND EXISTS (SELECT 1",
                  "           FROM HRDTA_FILE",
                  "          WHERE HRDTA01 = '",p_hrdu02,"'",
                  "            AND HRDTA02 = HRDU05",
                  "            AND TA_HRDTA01 = 'N')"
    
    IF NOT cl_null(g_hrdta04_007) THEN  
       PREPARE i088_prep_007 FROM l_sql_007
       EXECUTE i088_prep_007
       IF SQLCA.sqlcode THEN
          LET l_success='N'
       END IF 
    END IF
    
    IF NOT cl_null(g_hrdta04) THEN
       PREPARE i088_prep_002 FROM l_sql_002
       EXECUTE i088_prep_002  
       IF SQLCA.sqlcode THEN
          LET l_success='N'
       END IF 
    END IF
	    
    PREPARE i088_prep_001 FROM l_sql_001
    EXECUTE i088_prep_001
    IF SQLCA.sqlcode THEN
      LET l_success='N'
    END IF 
    
    IF l_success='N' THEN
    	ROLLBACK WORK
    	CALL cl_err('更新失败','!',0)
    ELSE 
      COMMIT WORK
      CALL cl_err('更新成功','!',0)
    END IF
    
  ELSE
     CALL cl_err('没有选择任何员工','!',0)
     RETURN
  END IF   
  
   
end FUNCTION
 
 
 
FUNCTION i088_a_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      
 
    LET g_sql_h = 
       " SELECT distinct 'N',hrat01 ,hrat02 ,hrao02 ,hras04 ,hrat25 ,hrdu04 ,hratid",
      " FROM hrdu_file                        ",
      " LEFT JOIN hrat_file on hratid=hrdu01  ",
      " LEFT JOIN hrao_file on hrao01=hrat04  ",
      " LEFT JOIN hras_file on hras01=hrat05  ",
      " WHERE  " ,p_wc2 CLIPPED
    PREPARE i088_a_pb FROM g_sql_h
    DECLARE hrdu_curs CURSOR FOR i088_a_pb
 
    CALL g_sch.clear()
    LET g_cnt_h = 1
    MESSAGE "Searching!" 
    FOREACH hrdu_curs INTO g_sch[g_cnt_h].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        
        LET g_cnt_h = g_cnt_h + 1
        IF g_cnt_h > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_sch.deleteElement(g_cnt_h)
    MESSAGE ""
    LET g_rec_b_h = g_cnt_h-1
    DISPLAY g_rec_b_h TO FORMONLY.cn2  
    LET g_cnt_h = 0
 
END FUNCTION
 
FUNCTION i088_a_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sch TO s_sch.* ATTRIBUTE(COUNT=g_rec_b_h)
 
      BEFORE ROW
      LET l_ac_h = ARR_CURR()
      CALL cl_show_fld_cont() 
      
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac_h = 1
         LET l_ac_h = 1
         EXIT DISPLAY 
     
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY 
                   
      #ON ACTION select_all
      #   LET g_action_choice="select_all"
      #   EXIT DISPLAY
      #   
      #ON ACTION select_non
      #   LET g_action_choice="select_non"
      #   EXIT DISPLAY   
         
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac_h = ARR_CURR()
         EXIT DISPLAY
      
      ON ACTION CANCEL
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about         
         CALL cl_about()      
      
      #ON ACTION exporttoexcel   
      #   LET g_action_choice = 'exporttoexcel'
      #   EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 
 
