# on..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri009.4gl

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_hrax    DYNAMIC ARRAY OF RECORD
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
    g_hrax_ins     RECORD LIKE hrax_file.*,
    g_success      LIKE type_file.chr1,
    g_hraa02       LIKE hraa_file.hraa02,
    g_wc2           STRING,
    g_wc            STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                
    l_ac            LIKE type_file.num5,
    g_flag          LIKE type_file.chr1,
    g_hrax21        LIKE hrax_file.hrax21,
    g_hrat         RECORD LIKE hrat_file.*
 
DEFINE g_forupd_sql STRING   
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5       
DEFINE g_str        STRING 
DEFINE p_row,p_col   LIKE type_file.num5 

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
 
   OPEN WINDOW i009_w AT p_row,p_col WITH FORM "ghr/42f/ghrq009"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
    LET g_wc = '1=1'
    CALL i009_b_fill(g_wc)
    CALL i009_menu()
    CLOSE WINDOW i009_w 
 
   
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
 
END MAIN


FUNCTION i009_menu()
 
   WHILE TRUE
      CALL i009_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i009_q()
            END IF
       
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrax),'','')
            END IF
         WHEN "controlg"
            CALL cl_cmdask()

         #130508test
          WHEN "read_txt"
            IF cl_chk_act_auth() THEN
               CALL q009_read_txt()
            END IF
 
      END CASE
   END WHILE
END FUNCTION 
	
FUNCTION i009_q()
   CALL i009_b_askkey()
END FUNCTION	
	
FUNCTION i009_b_askkey()
    CLEAR FORM
    CALL g_hrax.clear()
    LET g_rec_b=0
 
    CONSTRUCT g_wc2 ON hrax01,hrax02,hrax03,hrax04,hrax05,hrax06,hrax07,
                       hrax08,hrax09,hrax11,hrax14,hrax16,hrax17,hrax18,hrax19,hrax20                      
         FROM s_hrax[1].hrax01,s_hrax[1].hrax02,s_hrax[1].hrax03,                                  
              s_hrax[1].hrax04,s_hrax[1].hrax05,s_hrax[1].hrax06,
              s_hrax[1].hrax07,s_hrax[1].hrax08,s_hrax[1].hrax09,
              s_hrax[1].hrax11,s_hrax[1].hrax14,s_hrax[1].hrax16,
              s_hrax[1].hrax17,s_hrax[1].hrax18,s_hrax[1].hrax19,
              s_hrax[1].hrax20
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrax03)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hraa10"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrax[1].hrax03
               NEXT FIELD hrax03
           WHEN INFIELD(hrax04)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrao01"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_hrax[l_ac].hrax04
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO g_hrax[l_ac].hrax04
             NEXT FIELD hrax04
           WHEN INFIELD(hrax05)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hras01"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_hrax[l_ac].hrax05
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO g_hrax[l_ac].hrax05
             NEXT FIELD hrax05
           WHEN INFIELD(hrax07)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrat01"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_hrax[l_ac].hrax07
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO g_hrax[l_ac].hrax07
             NEXT FIELD hrax07
           WHEN INFIELD(hrax19)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrag06"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_hrax[l_ac].hrax19
             LET g_qryparam.arg1='314'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO g_hrax[l_ac].hrax19
             NEXT FIELD hrax19
          WHEN INFIELD(hrax19)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrag06"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_hrax[l_ac].hrax19
             LET g_qryparam.arg1='317'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO g_hrax[l_ac].hrax19
             NEXT FIELD hrax19
          WHEN INFIELD(hrax20)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_hrag06"
             LET g_qryparam.default1 = g_hrax[l_ac].hrax20
             LET g_qryparam.arg1='337'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO g_hrax[l_ac].hrax20
             NEXT FIELD hrax20

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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hraxuser', 'hraxgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i009_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION i009_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hrax01,hrax02,hrax03,'',hrax04,'',hrax05,'',hrax11,",
                   "hrax06,hrax07,'',hrax09,hrax08,hrax14,'',hrax16,hrax17,hrax18,hrax19,'',hrax20,'',''",
                   " FROM hrax_file ",
                   " WHERE ", p_wc2 CLIPPED, 
                   "   AND hrax11 in ('3001') ",
                   " ORDER BY hrax01" 
 
    PREPARE i009_pb FROM g_sql
    DECLARE hrax_curs CURSOR FOR i009_pb
 
    CALL g_hrax.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrax_curs INTO g_hrax[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
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
       WHERE hras01 = g_hrax[g_cnt].hrax05   
     #直接主管
      SELECT hrat02 INTO g_hrax[g_cnt].hrat02 FROM hrat_file
       WHERE hrat01 = g_hrax[g_cnt].hrax07
     #员工状态
     SELECT hrad03 INTO g_hrax[g_cnt].hrax11 FROM hrad_file
      WHERE hrad02 = '3001'
     #证件类型
     SELECT hrag07 INTO g_hrax[g_cnt].hrag07 FROM hrag_file
      WHERE hrag06 = g_hrax[g_cnt].hrax14 AND hrag01 = '314'
     #最高学历名称
      SELECT hrag07 INTO g_hrax[g_cnt].hrag07a FROM hrag_file
       WHERE hrag06 = g_hrax[g_cnt].hrax19 AND hrag01 = '317'
     #直接/简介名称
      SELECT hrag07 INTO g_hrax[g_cnt].hrag07b FROM hrag_file
       WHERE hrag06 = g_hrax[g_cnt].hrax20 AND hrag01 = '337'
      
     
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrax.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt 
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i009_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrax TO s_hrax.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
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
         
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY

      #130508test
      ON ACTION read_txt
         LET g_action_choice="read_txt"
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION	


FUNCTION q009_read_txt()
DEFINE ls_file   STRING
DEFINE ls_loc    STRING
DEFINE ch        base.Channel
DEFINE l_channel     base.Channel
DEFINE s         STRING
DEFINE day_now  DATETIME YEAR TO DAY
DEFINE time_now DATETIME HOUR TO FRACTION(5)

       LET ls_file = cl_browse_file()
       IF cl_null(ls_file) THEN
       	  RETURN
       END IF
       	
       LET day_now = CURRENT YEAR TO DAY
       LET time_now = CURRENT HOUR TO FRACTION(5)
       LET ls_loc="/u1/topprod/tiptop/ghr/ghri038_",day_now,".",time_now,".txt"
       
       IF NOT cl_upload_file(ls_file,ls_loc) THEN
          CALL cl_err(NULL,"lib-212", 1)
          RETURN
       END IF
       
       LET l_channel=base.channel.create()
       CALL l_channel.openfile(ls_loc , "r" ) 
       IF STATUS THEN
          CALL l_channel.close()
          CALL cl_err(ls_loc,'!','1')
          RETURN 
       END IF 	
       
       WHILE TRUE
          LET s = l_channel.readLine()
          IF l_channel.isEof() THEN EXIT WHILE END IF
           
       END WHILE 	
       	
       	
END FUNCTION		
