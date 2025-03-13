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
                  hrag07a   LIKE hrag_file.hrag07a,
                  hrax20    LIKE hrax_file.hrax20,
                  hrag07b   LIKE hrag_file.hrag07b
               END RECORD,
 
       g_hrax RECORD
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
                  hrag07a   LIKE hrag_file.hrag07a,
                  hrax20    LIKE hrax_file.hrax20,
                  hrag07b   LIKE hrag_file.hrag07b
               END RECORD,
       g_hrax RECORD       LIKE hrax_file.*,
       g_wc,g_sql,g_ws1,g_ws2    STRING,
       g_wc_pmk       STRING,
       g_rec_b        LIKE type_file.num5,         
       g_rec_b1       LIKE type_file.num5,         
       l_ac1          LIKE type_file.num5,         
       l_ac1_t        LIKE type_file.num5,         
       l_ac           LIKE type_file.num5
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
   CALL i008_b_fill() 
   CALL i008()
 
   CLOSE WINDOW i008_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
 
END MAIN
 
FUNCTION i008()
 
   CLEAR FORM
   WHILE TRUE
   	CALL i008_bp("G")
      IF INT_FLAG THEN EXIT WHILE END IF
      CASE g_action_choice  
      	WHEN "select_all"  #全部選取
           CALL i008_sel_all('Y')
 
         WHEN "select_non"  
           CALL i008_sel_all('N')
 
         WHEN "carry_date"      #转试用期
           IF cl_chk_act_auth() THEN
             CALL i008_carry_date()
           END IF
 
         WHEN "carry_out"       #离职
           IF cl_chk_act_auth() THEN
             CALL i008_carry_out()
           END IF
 
         WHEN "exporttoexcel" #匯出excel
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmk1),'','')
            END IF
     
         WHEN "exit"
           EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i008_b_fill()
 
    LET g_sql="SELECT hrax01,hrax02,hrax03,'',hrax04,'',hrax05,'',hrax11,",
               "hrax06,hrax07,hrax09,hrax08,hrax14,'',hrax16,hrax17,hrax18,hrax19,'',hrax20,'',''",
               " FROM hrax_file ",
               "WHERE ",g_wc
 
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
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i008_bp(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1
   
   DISPLAY ARRAY g_hrax TO s_hrax.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
      ON ACTION return
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help    
         CALL cl_show_help()
      
      ON ACTION controlg 
         CALL cl_cmdask()

   END DISPLAY
END FUNCTION
 
FUNCTION i008_sel_all(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1 
  DEFINE  l_i      LIKE type_file.num5

  FOR l_i = 1 TO g_cnt 
    LET g_hrax[l_i].sure = p_flag
    DISPLAY BY NAME g_hrax[l_i].sure
  END FOR

END FUNCTION
 
FUNCTION i008_carry_date()
  DEFINE tm1 RECORD
            hrax09   LIKE hrax_file.hrax09,
            hrax08   LIKE hrax_file.hrax08,
            hrax13   LIKE hrax_file.hrax13,
            a1       LIKE type_file.chr1 
          END RECORD
  DEFINE    l_i      LIKE type_file.num5           
  
  LET p_row = 2 LET p_col = 3
 
  OPEN WINDOW i008b_exp AT p_row,p_col WITH FORM "ghr/42f/ghri008a"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
     
       INPUT BY NAME tm1.hrax09,tm1.hrax08,tm1.hrax13,tm1.a1 WITHOUT DEFAULTS
      	
       #IF INT_FLAG THEN
       #   LET INT_FLAG = 0
       #   LET g_success = 'N'
       #   CLOSE WINDOW i008a_w
       #   RETURN
       #END IF


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
    IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
      ROLLBACK WORK      
      CLOSE WINDOW i008a_w
      RETURN
    END IF
    LET g_success = 'Y'
    BEGIN WORK 
    FOR l_i =1 TO g_rec_b
      IF g_hrax[l_i].hrax01 = 'Y' THEN
      	 UPDATE hrax_file SET hrax09 = tm1.hrax09,
      	                      hrax08 = tm1.hrax08,
      	                      hrax13 = tm1.hrax13
      	  WHERE hrax01 = g_hrax[l_i].hrax01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('','',"update hrax_file",SQLCA.sqlcode,1)   
          LET g_success = 'N'
          RETURN
       END IF 
     END IF
     END FOR
     IF g_success = 'Y' THEN
           COMMIT WORK
           CALL cl_err("运行成功","!",2)
     	 ELSE
     	   ROLLBACK WORK 
     	   CALL cl_err("运行失败","!",2) 
     END IF
  CLOSE WINDOW i008a_w
 
END FUNCTION
	
{FUNCTION i008_carry_out()
  DEFINE tm2 RECROD 
            hrax13   LIKE hrax_file.hrax13,
            hrax12   LIKE hrax_file.hrax12
          END RECORD,
         l_i         LIKE type_file.num5           
  
  LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW i008b_w AT p_row,p_col WITH FORM "ghr/4fd/ghri008b"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
     
      	INPUT BY NAME tm2.hrax12,tm2.hrax13
      	
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_success = 'N'
           CLOSE WINDOW i008b_w
           RETURN
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
    IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
      ROLLBACK WORK      
      CLOSE WINDOW i008b_w
      RETURN
    END IF
    LET g_success = 'Y'
    BEGIN WORK 
    FOR l_i =1 TO g_rec_b
      IF g_hrax[l_i].hrax01 = 'Y' THEN
      	 UPDATE hrax_file SET hrax12 = tm1.hrax13,
      	                      hrax13 = tm1.hrax13
      	  WHERE hrax01 = g_hrax[l_i].hrax01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('','',"update hrax_file",SQLCA.sqlcode,1)   
          LET g_success = 'N'
          RETURN
       END IF 
      END IF
     END FOR
     IF g_success = 'Y' THEN
         COMMIT WORK
         CALL cl_err("运行成功","!",2)
      ELSE
         ROLLBACK WORK 
        CALL cl_err("运行失败","!",2) 
     END IF
  CLOSE WINDOW i008b_w
 
END FUNCTION
}
