# Prog. Version..: '5.25.12-13.01.21(00000)'     #
# 
# Pattern name...: ghri008.4gl
# Descriptions...: 請購單整批處理作業


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE g_hrax    DYNAMIC ARRAY OF RECORD
                  sure      LIKE type_file.chr1,   #選擇
                  hrax01    LIKE hrax_file.hrax01,    
                  hrax02    LIKE hrax_file.hrax02,  
                  hrax03    LIKE hrax_file.hrax03,
                  hraa12    LIKE hraa_file.hraa12,
                  hrax04    LIKE hrax_file.hrax04,
                  hrao02    LIKE hrao_file.hrao02,
                  hrax05    LIKE hrax_file.hrax05,
                  hras04    LIKE hras_file.hras04,
                  hrax11    LIKE hrax_file.hrax11,
                  hrax06    LIKE hrax_file.hrax06,
                  hrax07    LIKE hrax_file.hrax07,
                  hrat02    LIKE hrat_file.hrat02, 
                  hrax09    LIKE hrax_file.hrax09,
                  hrax08    LIKE hrax_file.hrax08, 
                  hrax14    LIKE hrax_file.hrax14,
                  hrag07    LIKE hrag_file.hrag07,
                  hrax16    LIKE hrax_file.hrax16,
                  hrax17    LIKE hrax_file.hrax17,
                  hrax18    LIKE hrax_file.hrax18,
                  hrax19    LIKE hrax_file.hrax19,
                  hrag07a   LIKE hrag_file.hrag07,
                  hrax20    LIKE hrax_file.hrax20,
                  hrag07b   LIKE hrag_file.hrag07
               END RECORD,
 
       g_hrax_t RECORD
                  sure      LIKE type_file.chr1,   #選擇
                  hrax01    LIKE hrax_file.hrax01,    
                  hrax02    LIKE hrax_file.hrax02,  
                  hrax03    LIKE hrax_file.hrax03,
                  hraa12    LIKE hraa_file.hraa12,
                  hrax04    LIKE hrax_file.hrax04,
                  hrao02    LIKE hrao_file.hrao02,
                  hrax05    LIKE hrax_file.hrax05,
                  hras04    LIKE hras_file.hras04,
                  hrax11    LIKE hrax_file.hrax11,
                  hrax06    LIKE hrax_file.hrax06,
                  hrax07    LIKE hrax_file.hrax07,
                  hrat02    LIKE hrat_file.hrat02, 
                  hrax09    LIKE hrax_file.hrax09,
                  hrax08    LIKE hrax_file.hrax08, 
                  hrax14    LIKE hrax_file.hrax14,
                  hrag07    LIKE hrag_file.hrag07,
                  hrax16    LIKE hrax_file.hrax16,
                  hrax17    LIKE hrax_file.hrax17,
                  hrax18    LIKE hrax_file.hrax18,
                  hrax19    LIKE hrax_file.hrax19,
                  hrag07a   LIKE hrag_file.hrag07,
                  hrax20    LIKE hrax_file.hrax20,
                  hrag07b   LIKE hrag_file.hrag07
               END RECORD,
       g_wc,g_sql,g_ws1,g_ws2    STRING,
       g_wc_pmk       STRING,
       g_rec_b        LIKE type_file.num5,         
       g_rec_b1       LIKE type_file.num5,         
       l_ac1          LIKE type_file.num5,         
       l_ac1_t        LIKE type_file.num5,         
       l_ac           LIKE type_file.num5,
       g_hrax_ins     RECORD LIKE hrax_file.*,
       g_flag          LIKE type_file.chr1,
       g_hrax21        LIKE hrax_file.hrax21,
       g_hraa02       LIKE hraa_file.hraa02,
       g_hrat         RECORD LIKE hrat_file.*
DEFINE p_row,p_col    LIKE type_file.num5          
DEFINE g_cnt          LIKE type_file.num10         
DEFINE g_forupd_sql   STRING
DEFINE g_before_input_done STRING
DEFINE li_result      LIKE type_file.num5          
DEFINE g_msg          STRING                         #No.MOD-860242
DEFINE mi_need_cons     LIKE type_file.num5
DEFINE g_dbs2          LIKE type_file.chr30   #TQC-680074
DEFINE g_wc_pml       STRING                #CHI-880020
DEFINE g_success      LIKE type_file.chr1
DEFINE g_cnt2         LIKE type_file.num10

MAIN
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW i008_w AT p_row,p_col WITH FORM "ghr/42f/ghri008"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   LET g_wc = "1=1"
   CALL i008_b_fill(g_wc) 
   CALL i008()
 
   CLOSE WINDOW i008_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
 
END MAIN
 
FUNCTION i008()
 
   CLEAR FORM
   WHILE TRUE
   	CALL i008_b()
      CASE g_action_choice  
      	WHEN "select_all"  #全部選取
           CALL i008_sel_all('Y')
           
        WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i008_q()
            END IF
 
         WHEN "select_non"  
           CALL i008_sel_all('N')
 
         WHEN "ghri008_a"      #转试用期
           IF cl_chk_act_auth() THEN
             CALL i008_normal()
           END IF
 
         WHEN "ghri008_b"       #离职
           IF cl_chk_act_auth() THEN
             CALL i008_dimission()
           END IF
 
         WHEN "exporttoexcel" #匯出excel
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrax_t.hrax01),'','')
            END IF
     
         WHEN "exit"
           EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i008_q()
   CLEAR FORM
    CALL g_hrax.clear()
 
    CONSTRUCT g_wc ON hrax01                   
         FROM s_hray[1].hrax01
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrat01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrax01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hray[1].hrax01
               NEXT FIELD hrax01
         OTHERWISE
              EXIT CASE
         END CASE
 
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
 
    CALL i008_b_fill(g_wc)
END FUNCTION
 
FUNCTION i008_b_fill(p_wc)
DEFINE p_wc STRING
 
    LET g_sql = "SELECT '',hrax01,hrax02,hrax03,'',hrax04,'',hrax05,'',hrax11,",
               "hrax06,hrax07,'',hrax09,hrax08,hrax14,'',hrax16,hrax17,hrax18,hrax19,'',hrax20,'',''",
               " FROM hrax_file ",
               " WHERE ", p_wc CLIPPED, 
               "   AND hrax11 in ('4001','4002') ",
               " ORDER BY hrax01"
 
   PREPARE i008_pb FROM g_sql
   DECLARE hrax_curs CURSOR FOR i008_pb
  
   CALL g_hrax.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH hrax_curs INTO g_hrax[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
 
     #公司名称
      SELECT hraa12 INTO g_hrax[g_cnt].hraa12 FROM hraa_file 
       WHERE hraa01 = g_hrax[g_cnt].hrax03
     #部门名称
      SELECT hrao02 INTO g_hrax[g_cnt].hrao02 FROM hrao_file
       WHERE hrao01 = g_hrax[g_cnt].hrax04
     #职位名称
      SELECT hras04 INTO g_hrax[g_cnt].hras04 FROM hras_file
       WHERE hras03 = g_hrax[g_cnt].hrax05   
     #直接主管
      SELECT hrat06 INTO g_hrax[g_cnt].hrat02 FROM htat_file
       WHERE htat01 = g_hrax[g_cnt].hrax01
     #证件类型名称
      SELECT hrag07 INTO g_hrax[g_cnt].hrag07 FROM hrag_file
       WHERE hrag06 = '314'
     #最高学历名称
      SELECT hrag07 INTO g_hrax[g_cnt].hrag07a FROM hrag_file
       WHERE hrag06 = '317'
     #直接/简介名称
      SELECT hrag07 INTO g_hrax[g_cnt].hrag07b FROM hrag_file
       WHERE hrag06 = '337'                                                           
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_hrax.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   CALL ui.Interface.refresh()
   DISPLAY g_rec_b TO FORMONLY.cnt
   LET g_cnt2 = g_cnt
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i008_sel_all(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1 
  DEFINE  l_i      LIKE type_file.num5

  FOR l_i = 1 TO g_cnt2 
    LET g_hrax[l_i].sure = p_flag
    DISPLAY BY NAME g_hrax[l_i].sure
  END FOR

END FUNCTION
 
FUNCTION i008_normal()
		DEFINE tm1 RECORD
            hrax10   LIKE hrax_file.hrax10,
            hrax08   LIKE hrax_file.hrax08,
            hrax13   LIKE hrax_file.hrax13,
            a1       LIKE type_file.chr1 
          END RECORD
  DEFINE    l_i      LIKE type_file.num5      
  
  LET INT_FLAG = 0
  
  INPUT ARRAY g_hrax WITHOUT DEFAULTS FROM s_hrax.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
  BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
  
  BEFORE ROW
     LET l_ac = ARR_CURR()
      DISPLAY BY NAME g_hrax[l_ac].sure
      
  ON ACTION CONTROLG
        CALL cl_cmdask()
  
  ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
  
  END INPUT             

  IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
      RETURN
  END IF  
  	
  LET p_row = 2 LET p_col = 3
 
  OPEN WINDOW i008a_w AT p_row,p_col WITH FORM "ghr/42f/ghri008a"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
     
      CALL cl_ui_init()
     
      INPUT BY NAME tm1.hrax10,tm1.hrax08,tm1.hrax13,tm1.a1 WITHOUT DEFAULTS
      
      BEFORE INPUT
        LET tm1.hrax08 = g_today
        LET tm1.hrax10 = g_today
        DISPLAY tm1.hrax08 TO htax08
        DISPLAY tm1.hrax10 TO hrax10
        LET tm1.a1 = 'Y'
        DISPLAY tm1.a1 TO a1
        
      AFTER FIELD hrax08
        IF tm1.hrax08 < tm1.hrax10 THEN
        	 CALL cl_err('预计转正日期不可大于试用开始日期','!',0)
        	 NEXT FIELD hrax08
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
    # IF INT_FLAG THEN
    # LET INT_FLAG = 0
    #  LET g_success = 'N'
    #  CLOSE WINDOW i008a_w
    #  RETURN
    # END IF
    BEGIN WORK 
   IF NOT INT_FLAG THEN
   	LET g_success = 'Y'
    FOR l_i =1 TO g_rec_b
      IF g_hrax[l_i].sure = 'Y' THEN
      	  LET g_hrax21 = ''
      	  IF tm1.a1 = 'Y' THEN
      	  	 CALL hr_gen_no('hrat_file','hrat01','009',g_hrax[l_i].hrax03,'') 
                  RETURNING g_hrax21,g_flag
          END IF
      	 UPDATE hrax_file SET hrax21 = g_hrax21,
      	                      hrax11 = '2001'     #正式员工
      	  WHERE hrax01 = g_hrax[l_i].hrax01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('','',"update hrax_file",SQLCA.sqlcode,1)   
          LET g_success = 'N'
          RETURN
       END IF 
       SELECT max(hratid)+1 INTO g_hrat.hratid FROM hrat_file 
       IF cl_null(g_hrat.hratid) THEN
       	  LET g_hrat.hratid = 1 
       END IF
       IF tm1.a1 = 'Y' THEN
       	  LET g_hrat.hrat01 = g_hrax21
       	 ELSE
       	 	LET g_hrat.hrat01 = g_hrax[l_ac].hrax01
       END IF
       LET g_hrat.hrat02 = g_hrax[l_ac].hrax02
       LET g_hrat.hrat03 = g_hrax[l_ac].hrax03
       LET g_hrat.hrat04 = g_hrax[l_ac].hrax04
       LET g_hrat.hrat05 = g_hrax[l_ac].hrax05
       LET g_hrat.hrat06 = g_hrax[l_ac].hrax07
       LET g_hrat.hrat12 = g_hrax[l_ac].hrax14
       LET g_hrat.hrat15 = g_hrax[l_ac].hrax16
       LET g_hrat.hrat17 = g_hrax[l_ac].hrax17
       LET g_hrat.hrat20 = g_hrax[l_ac].hrax18
       LET g_hrat.hrat22 = g_hrax[l_ac].hrax19
       LET g_hrat.hrat26 = tm1.hrax08
       LET g_hrat.hrat66 = tm1.hrax10
       LET g_hrat.hratacti = 'Y'
       LET g_hrat.hratgrup = g_grup
       LET g_hrat.hratoriu = g_user
       INSERT INTO hrat_file VALUES (g_hrat.*)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('','',"insert hrax_file",SQLCA.sqlcode,1)   
          LET g_success = 'N'
       END IF
      END IF
     END FOR
    END IF
     IF g_success = 'Y' THEN
           COMMIT WORK
           CALL cl_err("运行成功","!",2)
     	 ELSE
     	   ROLLBACK WORK 
     	   CALL cl_err("运行失败","!",2) 
     END IF
  CLOSE WINDOW i008a_w
  IF cl_null(g_wc) THEN
  	 LET g_wc = '1=1'
  END IF
  CALL i008_b_fill(g_wc)
END FUNCTION
	
FUNCTION i008_dimission()
 DEFINE tm3 RECORD
            hrax12   LIKE hrax_file.hrax12,
            hrax13   LIKE hrax_file.hrax13
          END RECORD
  DEFINE    l_i      LIKE type_file.num5
  
  LET INT_FLAG = 0
	
	INPUT ARRAY g_hrax WITHOUT DEFAULTS FROM s_hrax.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
  BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
  
  BEFORE ROW
     LET l_ac = ARR_CURR()
  
  ON ACTION CONTROLG
        CALL cl_cmdask()
  
  ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
  
  END INPUT
  
  IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
      RETURN
  END IF 
  
  LET p_row = 2 LET p_col = 3
 
  OPEN WINDOW i008b_w AT p_row,p_col WITH FORM "ghr/42f/ghri008b"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
    CALL cl_ui_init()
     
      INPUT BY NAME tm3.hrax12,tm3.hrax13 WITHOUT DEFAULTS
   
      BEFORE INPUT
        LET tm3.hrax12 = g_today
        DISPLAY tm3.hrax12 TO hrax12
        
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
  IF NOT INT_FLAG THEN
    LET INT_FLAG = 0
    LET g_success = 'Y'
    BEGIN WORK 
    FOR l_i =1 TO g_rec_b
      IF g_hrax[l_i].sure = 'Y' THEN
      	 UPDATE hrax_file SET hrax12 = tm3.hrax12,
      	                      hrax13 = tm3.hrax13,
      	                      hrax11 = '3001'       #离职员工
      	  WHERE hrax01 = g_hrax[l_i].hrax01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('','',"update hrax_file",SQLCA.sqlcode,1)   
          LET g_success = 'N'
       END IF 
     END IF
     END FOR
  END IF
     IF g_success = 'Y' THEN
           COMMIT WORK
           CALL cl_err("运行成功","!",2)
     	 ELSE
     	   ROLLBACK WORK 
     	   CALL cl_err("运行失败","!",2) 
     END IF
  CLOSE WINDOW i008b_w
  IF cl_null(g_wc) THEN
  	 LET g_wc = '1=1'
  END IF
  CALL i008_b_fill(g_wc)

END FUNCTION
	
FUNCTION i008_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5, 
    l_i             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1  
   
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
 
    INPUT ARRAY g_hrax WITHOUT DEFAULTS FROM s_hrax.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_rec_b,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF		
       	
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
      	  	
 
     ON ACTION select_all  
           LET g_action_choice="select_all"
           EXIT INPUT
 
         ON ACTION select_non
           LET g_action_choice="select_non"
           EXIT INPUT
         
         ON ACTION ghri008_a
           LET g_action_choice="ghri008_a"
           EXIT INPUT
         
         ON ACTION ghri008_b
           LET g_action_choice="ghri008_b"
           EXIT INPUT
 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT INPUT 
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT INPUT 
 
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT INPUT 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT 
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT INPUT
 
    END INPUT
    CALL cl_set_act_visible("accept,cancel,insert", TRUE)

END FUNCTION 
