# Prog Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri049.4gl
# Descriptions...: 待审核计件信息
# Date & Author..: 13/05/24 By lifang
# Date & Author..: 13/07/18 By yeap1
# 2015-03-12 增加汇出EXCEL功能
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_hrci    DYNAMIC ARRAY OF RECORD
                  sure   LIKE type_file.chr1,  
                  hrci01 LIKE hrci_file.hrci01, 
                  hrat01 LIKE hrat_file.hrat01, 
                  hrat02 LIKE hrat_file.hrat02, 
                  hrat04 LIKE hrat_file.hrat04, 
                  hrao02 LIKE hrao_file.hrao02, 
                  hrat05 LIKE hrat_file.hrat05, 
                  hras04 LIKE hras_file.hras04, 
                  hrci03 LIKE hrci_file.hrci03, 
                  hrci04 LIKE hrci_file.hrci04, 
                  hrci05 LIKE hrci_file.hrci05, 
                  hrci06 LIKE hrci_file.hrci06, 
                  hrci07 LIKE hrci_file.hrci07, 
                  hrci08 LIKE hrci_file.hrci08, 
                  hrci09 LIKE hrci_file.hrci09, 
                  hrci10 LIKE hrci_file.hrci10, 
                  hrci11 LIKE hrci_file.hrci11, 
                  hrciconf LIKE hrci_file.hrciconf               
               END RECORD,
 
       g_hrci_t RECORD
                  sure   LIKE type_file.chr1,   
                  hrci01 LIKE hrci_file.hrci01, 
                  hrat01 LIKE hrat_file.hrat01, 
                  hrat02 LIKE hrat_file.hrat02, 
                  hrat04 LIKE hrat_file.hrat04, 
                  hrao02 LIKE hrao_file.hrao02, 
                  hrat05 LIKE hrat_file.hrat05, 
                  hras04 LIKE hras_file.hras04, 
                  hrci03 LIKE hrci_file.hrci03, 
                  hrci04 LIKE hrci_file.hrci04, 
                  hrci05 LIKE hrci_file.hrci05, 
                  hrci06 LIKE hrci_file.hrci06, 
                  hrci07 LIKE hrci_file.hrci07, 
                  hrci08 LIKE hrci_file.hrci08, 
                  hrci09 LIKE hrci_file.hrci09, 
                  hrci10 LIKE hrci_file.hrci10, 
                  hrci11 LIKE hrci_file.hrci11, 
                  hrciconf LIKE hrci_file.hrciconf 
               END RECORD,
       g_hrcm    DYNAMIC ARRAY OF RECORD
                 sure       LIKE type_file.chr1,  
                 hrat01     LIKE hrat_file.hrat01, #added by yeap NO.130801
                 hrat02     LIKE hrat_file.hrat02, #added by yeap NO.130801
                 hrat04     LIKE hrat_file.hrat04, #added by yeap NO.130801
                 hrat05     LIKE hrat_file.hrat05, #added by yeap NO.130801 
                 hrcn02     LIKE hrcn_file.hrcn02,
                 hrci08     LIKE hrci_file.hrci08,
                 hrcm03     LIKE hrcm_file.hrcm03,
                 hrcn04     LIKE type_file.dat,
                 hrcn05     LIKE type_file.chr5,
                 hrcn06     LIKE type_file.dat,
                 hrcn07     LIKE type_file.chr5,
                 hrcn09     LIKE hrcn_file.hrcn09,
                 hrci05     LIKE hrci_file.hrci05,
                 t_time     LIKE hrci_file.hrci08,
                 hrci10     LIKE hrci_file.hrci10 
               END RECORD,
    g_hrci_ins     RECORD LIKE hrci_file.*,
    g_success      LIKE type_file.chr1,
    g_wc            STRING,
    g_wc1           STRING,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,
    g_rec_b_1       LIKE type_file.num5,    #added by yeap1 NO.130718
    g_ii            LIKE type_file.num5,    #added by yeap1 NO.130718                
    l_ac            LIKE type_file.num5,
    g_ss            LIKE type_file.chr1,
    g_flag          LIKE type_file.chr1,
	  g_hrcm02        LIKE hrcm_file.hrcm02,  #added by yeap1  NO.130718
    g_hrbm03        LIKE hrbm_file.hrbm03,  #added by yeap1  NO.130718
    g_hrbm04        LIKE hrbm_file.hrbm04,  #added by yeap1  NO.130718 
    g_h1,g_m1       LIKE type_file.num5,    #added by yeap1  NO.130718
    g_h2,g_m2       LIKE type_file.num5     #added by yeap1  NO.130718
DEFINE g_forupd_sql STRING    
DEFINE g_cnt        LIKE type_file.num10 
DEFINE g_cnt2       LIKE type_file.num10     
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5       
DEFINE g_str        STRING 
DEFINE p_row,p_col  LIKE type_file.num5 
DEFINE g_chus       LIKE type_file.num5
DEFINE g_max        LIKE type_file.num5

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
 
   OPEN WINDOW i049_w AT p_row,p_col WITH FORM "ghr/42f/ghri049"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init() 
    CALL cl_set_comp_visible("hrci01,sure",FALSE) 
	  CALL cl_set_comp_visible("hrat04,hrat05",FALSE)
    CALL i049_menu()
    CLOSE WINDOW i049_w 
 
   
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
 
END MAIN


FUNCTION i049_menu()
 
   WHILE TRUE
   #	IF g_ii = 1 THEN 
   #		LET g_action_choice = "paid"
   #		LET g_ii = 0
   #	ELSE 
      CALL i049_bp("G")
   # END IF 
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i049_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i049_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         
         WHEN "ghr_confirm"
             IF cl_chk_act_auth() THEN
            #    CALL i049_confirm('Y')  #marked by yeap NO.130801
                CALL i049_choose('Y')       #added by yeap NO.130801
             END IF

         WHEN "ghr_undo_confirm"
             IF cl_chk_act_auth() THEN
            #    CALL i049_confirm('N')  #marked by yeap NO.130801
                CALL i049_choose('N')       #added by yeap NO.130801
             END IF
                       
         WHEN "sel_all"
             IF cl_chk_act_auth() THEN
                CALL i049_sel_all('Y')
             END IF
          
         WHEN "can_all"
             IF cl_chk_act_auth() THEN
                CALL i049_sel_all('N')
             END IF  

       WHEN "exporttoexcel"                       #單身匯出最多可匯三個Table資料 2015-03-12
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrci),'','')
            END IF        
               
         WHEN "ghri049_a"
             IF cl_chk_act_auth() THEN
        #        IF g_hrci[1].hrci01 IS NOT NULL THEN
                 CALL i049_paid()
                 IF g_chus != 100 THEN 
                    CALL i049_b_fill_1()
                     LET g_chus = 0
                 END IF  
                 
        #        END IF
             END IF    
      END CASE
   END WHILE
END FUNCTION 
 
FUNCTION i049_q()
	 CALL cl_set_comp_visible("hrat04,hrat05",TRUE)
   CALL i049_b_askkey()
	 CALL cl_set_comp_visible("hrat04,hrat05",FALSE)
END FUNCTION 
 
FUNCTION i049_b()
DEFINE l_hrbm26     LIKE hrbm_file.hrbm26
DEFINE l_hrci07     LIKE hrci_file.hrci07
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1,
    l_c             LIKE type_file.num5
    
 
    IF s_shut(0) THEN RETURN END IF 
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
     
    LET g_forupd_sql="SELECT '',hrci01,'','','','','','',hrci03,hrci04,hrci05,hrci06,hrci07,hrci08,hrci09,hrci10,hrci11,hrciconf",
                     "  FROM hrci_file,hrat_file WHERE hrci01=?  FOR UPDATE   "
    
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) 
    DECLARE i049_bcl CURSOR FROM g_forupd_sql     
 
    INPUT ARRAY g_hrci WITHOUT DEFAULTS FROM s_hrci.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=FALSE,APPEND ROW=FALSE) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
       CALL cl_set_comp_entry("hrci06,hrci07,hrci10,hrci11",TRUE)
       CALL cl_set_comp_entry ("sure,hrat01,hrat02,hrat04,hrao02,hrat05,hras04,hrci03,hrci04,hrci05,hrci08,hrci09,hrciconf",FALSE)
       FOR l_n = 1 TO g_rec_b
           LET g_hrbm03 = g_hrci[l_n].hrci04
           SELECT hrbm04 INTO g_hrci[l_n].hrci04 FROM hrbm_file WHERE hrbm03 = g_hrbm03
           DISPLAY BY NAME g_hrci[l_n].hrci04
       END FOR 
       NEXT FIELD hrci06
       
        
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            
        LET l_n  = ARR_COUNT()
        
        
        IF g_rec_b>=l_ac THEN
        
            BEGIN WORK
            LET p_cmd='u'                                        
            LET g_hrci_t.* = g_hrci[l_ac].*    
                   
            OPEN i049_bcl USING g_hrci_t.hrci01   
            IF STATUS THEN
               CALL cl_err("OPEN i049_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i049_bcl INTO g_hrci[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrci_t.hrci01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
              
              IF cl_null(g_hrci[l_ac].sure) THEN LET g_hrci[l_ac].sure = 'N' END IF
              SELECT hrao02 INTO g_hrci[l_ac].hrao02 FROM hrao_file WHERE hrao01 = g_hrci[l_ac].hrat04        
              SELECT hrap06 INTO g_hrci[l_ac].hras04 FROM hrap_file WHERE hrap05 = g_hrci[l_ac].hrat05 AND hrap01 = g_hrci[l_ac].hrat04
              DISPLAY BY NAME g_hrci[l_ac].hrao02,g_hrci[l_ac].hras04 
            END IF
            CALL cl_show_fld_cont()  
        END IF  

    AFTER FIELD hrci06 
        IF NOT cl_null(g_hrci[l_ac].hrci06)  THEN
        	 IF g_hrci[l_ac].hrci06 < 0 THEN 
        	 	  CALL cl_err("","ghr-140",0)
        	 	  NEXT FIELD hrci06
        	 END IF 
        	 IF NOT cl_null(g_hrci[l_ac].hrci07) THEN 
        	    IF g_hrci[l_ac].hrci06 > g_hrci[l_ac].hrci05 - g_hrci[l_ac].hrci07 THEN 
        	 	     CALL cl_err("","ghr-137",0)
        	 	     LET g_hrci[l_ac].hrci06 = g_hrci[l_ac].hrci05 - g_hrci[l_ac].hrci07
        	 	  END IF 
        	 END IF
        ELSE 
           NEXT FIELD hrci06 
        END IF   

    AFTER FIELD hrci07
        IF NOT cl_null(g_hrci[l_ac].hrci07)  THEN
        	  IF g_hrci[l_ac].hrci07 < 0 THEN 
        	 	  CALL cl_err("","ghr-140",0)
        	 	  NEXT FIELD hrci06
        	 	END IF
        	 	IF g_hrci[l_ac].hrci07 > g_hrci[l_ac].hrci05 THEN 
        	 		 CALL cl_err("","ghr-140",0)
        	 		 LET g_hrci[l_ac].hrci07 = g_hrci[l_ac].hrci05
        	 		 DISPLAY BY NAME g_hrci[l_ac].hrci07
        	 	END IF  
        	 IF NOT cl_null(g_hrci[l_ac].hrci06) THEN 
        	    IF g_hrci[l_ac].hrci06 > g_hrci[l_ac].hrci05 - g_hrci[l_ac].hrci07 THEN 
        	 	     CALL cl_err("","ghr-137",0)
        	 	  END IF 
        	 	     LET g_hrci[l_ac].hrci06 = g_hrci[l_ac].hrci05 - g_hrci[l_ac].hrci07
        	 	      IF g_hrci[l_ac].hrci06 < 0 THEN 
        	 	      	 LET g_hrci[l_ac].hrci06 = 0
        	 	      END IF 
        	 END IF
        	 IF g_hrci[l_ac].hrci07 < g_hrci[l_ac].hrci08 THEN 
        	 	  CALL cl_err("","ghr-138",0)
        	 	   LET g_hrci[l_ac].hrci07 = g_hrci[l_ac].hrci08
        	 END IF 
        	 	   LET g_hrci[l_ac].hrci09 = g_hrci[l_ac].hrci07 - g_hrci[l_ac].hrci08
        	 DISPLAY BY NAME g_hrci[l_ac].hrci06,g_hrci[l_ac].hrci07,g_hrci[l_ac].hrci09
        ELSE 
           NEXT FIELD hrci07
        END IF 
           
    AFTER FIELD hrci10
        IF NOT cl_null(g_hrci[l_ac].hrci10)  THEN
        	 IF g_hrci[l_ac].hrci10 < g_hrci[l_ac].hrci03 THEN 
        	 	  LET g_hrci[l_ac].hrci09 = 0
        	 	  DISPLAY BY NAME g_hrci[l_ac].hrci09 
        	 ELSE 
        	 	  LET g_hrci[l_ac].hrci09 = g_hrci[l_ac].hrci07 - g_hrci[l_ac].hrci08
        	 	  DISPLAY BY NAME g_hrci[l_ac].hrci09 
        	 END IF 
        END IF
  
    ON ROW CHANGE
       IF INT_FLAG THEN                 
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hrci[l_ac].* = g_hrci_t.*
         CLOSE i049_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrci[l_ac].hrat01,-163,0)
          LET g_hrci[l_ac].* = g_hrci_t.*
       ELSE 
           
          UPDATE hrci_file SET hrci06=g_hrci[l_ac].hrci06,
                               hrci07=g_hrci[l_ac].hrci07,
                               hrci09=g_hrci[l_ac].hrci09,
                               hrci10=g_hrci[l_ac].hrci10,
                               hrci11=g_hrci[l_ac].hrci11, 
                               hrcimodu=g_user,
                               hrcidate=g_today
                WHERE hrci01 = g_hrci_t.hrci01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrci_file",g_hrci_t.hrci01,g_hrci_t.hrat02,SQLCA.sqlcode,"","",1)
             ROLLBACK WORK    
             LET g_hrci[l_ac].* = g_hrci_t.*
          END IF
       END IF   
       
                   
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrci[l_ac].* = g_hrci_t.*
          END IF
          CLOSE i049_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i049_bcl                
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
 
    CLOSE i049_bcl
    COMMIT WORK 
    CALL i049_b_fill(g_wc2)
END FUNCTION              
 
FUNCTION i049_b_askkey()
	
DEFINE     l_hrcm02        LIKE hrcm_file.hrcm02,  #added by yeap1  NO.130718
           l_hrcm03        LIKE hrcm_file.hrcm03,  #added by yeap1  NO.130718
           l_hrbm03        LIKE hrbm_file.hrbm03,  #added by yeap1  NO.130718
           l_hrbm04        LIKE hrbm_file.hrbm04   #added by yeap1  NO.130718
    CLEAR FORM
    CALL g_hrci.clear()
    LET g_rec_b=0
 
    CONSTRUCT g_wc2 ON hrat01,hrat02,hrat04,hrat05,hrci03,hrci04,hrci05,hrci06,hrci07,hrci08,hrci09,hrci10,hrci11,hrciconf   #del hrao02.hras04,s_hrci[1].hrao02,s_hrci[1].hras04        
         FROM s_hrci[1].hrat01,s_hrci[1].hrat02,s_hrci[1].hrat04,s_hrci[1].hrat05,
              s_hrci[1].hrci03,s_hrci[1].hrci04,s_hrci[1].hrci05,s_hrci[1].hrci06,s_hrci[1].hrci07,s_hrci[1].hrci08,
              s_hrci[1].hrci09,s_hrci[1].hrci10,s_hrci[1].hrci11,s_hrci[1].hrciconf
         
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 

              WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_hrat01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_hrci[1].hrat01
                 NEXT FIELD hrat01
              WHEN INFIELD(hrat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_hrci[1].hrat04
                 NEXT FIELD hrat04
              WHEN INFIELD(hrat05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrap01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_hrci[1].hrat05
                 NEXT FIELD hrat05
              WHEN INFIELD(hrci04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbm03"
                 LET g_qryparam.arg1 = "008"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_hrci[1].hrci04
             #    LET l_hrbm03 = g_qryparam.multiret
             #    SELECT hrbm04 INTO l_hrbm04 FROM hrbm_file WHERE hrbm03 = l_hrbm03
             #    DISPLAY l_hrbm04 TO s_hrci[1].hrci04      
                 NEXT FIELD hrci04
         OTHERWISE
              EXIT CASE
         END CASE
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about                         
         CALL cl_about()                      
                                              
      ON ACTION help                          
         CALL cl_show_help()                  
                                              
      ON ACTION controlg                      
         CALL cl_cmdask()                     
                                              
     
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save() 
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrciuser', 'hrcigrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF 
 
    CALL i049_b_fill(g_wc2)
 
END FUNCTION 
 
FUNCTION i049_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
    
    IF cl_null(p_wc2) THEN
      LET p_wc2 = " 1=1 "
    END IF   
    LET g_sql = "  SELECT 'N',hrci01,hrat01,hrat02,hrat04,hrao02,hrat05,hras04,hrci03,hrci04,hrci05,hrci06,hrci07,hrci08,hrci09,hrci10,hrci11,hrciconf ",
                "    FROM hrci_file left join hrat_file on hrci02 = hratid   ",
                "         left join hrao_file on hrat04 = hrao02   ",
                "         left join hras_file on hras01 = hrao05   ",
                "   WHERE  ", p_wc2 CLIPPED, 
                "   ORDER BY hrat01,hrci03" 
 
    PREPARE i049_pb FROM g_sql
    DECLARE hrci_curs CURSOR FOR i049_pb
 
    CALL g_hrci.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrci_curs INTO g_hrci[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF 
      
       # LET g_hrci[g_cnt].sure = 'Y'
        SELECT hrao02 INTO g_hrci[g_cnt].hrao02 FROM hrao_file WHERE hrao01 = g_hrci[g_cnt].hrat04        
        SELECT hrap06 INTO g_hrci[g_cnt].hras04 FROM hrap_file WHERE hrap05 = g_hrci[g_cnt].hrat05 AND hrap01 = g_hrci[g_cnt].hrat04       
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrci.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt2 = g_cnt-1
    LET g_cnt = 0
 
END FUNCTION 
 
FUNCTION i049_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
   DEFINE   l_n    LIKE type_file.num5
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrci TO s_hrci.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         FOR l_n = 1 TO g_rec_b + 1
           LET g_hrbm03 = g_hrci[l_n].hrci04
           SELECT hrbm04 INTO g_hrci[l_n].hrci04 FROM hrbm_file WHERE hrbm03 = g_hrbm03
           DISPLAY BY NAME g_hrci[l_n].hrci04
         END FOR 
        
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
         LET INT_FLAG=FALSE    
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()    
         
  #    ON ACTION sel_all
  #       LET g_action_choice="sel_all"
  #       EXIT DISPLAY
      
  #    ON ACTION can_all
  #       LET g_action_choice="can_all"
  #       EXIT DISPLAY   
   ON ACTION exporttoexcel                       #匯出Excel #2015-03-12     
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
                  
      ON ACTION ghr_confirm
         LET g_action_choice="ghr_confirm"
         EXIT DISPLAY

      ON ACTION ghr_undo_confirm
         LET g_action_choice="ghr_undo_confirm"
         EXIT DISPLAY      
         
      ON ACTION ghri049_a
         LET g_action_choice="ghri049_a"
         EXIT DISPLAY 
          
      AFTER DISPLAY
         CONTINUE DISPLAY 
 
 
   END DISPLAY
   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 
  
 
FUNCTION i049_sel_all(p_flag)
 DEFINE  p_flag  LIKE type_file.chr1 
  DEFINE  l_i     LIKE type_file.num5
  IF cl_null(g_rec_b) OR g_rec_b = 0 THEN
    RETURN
  END IF
  FOR l_i = 1 TO g_rec_b
    LET g_hrci[l_i].sure = p_flag
    DISPLAY BY NAME g_hrci[l_i].sure
  END FOR
 
  CALL g_hrci.deleteElement(l_i)
   
  CALL ui.Interface.refresh()

END FUNCTION  
 
FUNCTION i049_confirm(p_cmd) 
  DEFINE p_cmd           LIKE type_file.chr1
  DEFINE l_i,l_n         LIKE type_file.num5
  DEFINE l_count         LIKE type_file.num5
 
  IF g_rec_b = 0 OR cl_null(g_rec_b) THEN
    RETURN
  END IF 
  
  
IF p_cmd = 'Y' THEN 
   IF  cl_confirm('aap-222') THEN
       FOR l_i = 1 TO g_rec_b
        IF g_hrci[l_i].sure = 'Y' THEN   
           UPDATE hrci_file SET hrciconf = p_cmd WHERE hrci01 = g_hrci[l_i].hrci01
           LET g_hrci[l_i].hrciconf = p_cmd
           DISPLAY BY NAME g_hrci[l_i].hrciconf 
        END IF
       END FOR
   END IF
END IF 
IF p_cmd = 'N' THEN  
   IF  cl_confirm('aap-224') THEN
       FOR l_i = 1 TO g_rec_b
        IF g_hrci[l_i].sure = 'Y' THEN   
           UPDATE hrci_file SET hrciconf = p_cmd WHERE hrci01 = g_hrci[l_i].hrci01
           LET g_hrci[l_i].hrciconf = p_cmd
           DISPLAY BY NAME g_hrci[l_i].hrciconf 
        END IF
      END FOR
   END IF
END IF   
	
END FUNCTION 
 
 
FUNCTION i049_paid() 
  DEFINE l_str           STRING
  DEFINE l_i,l_n,l_j     LIKE type_file.num5
  DEFINE l_count         LIKE type_file.num5
  DEFINE l_hour          LIKE type_file.num5
  DEFINE l_numb          LIKE type_file.num5
  DEFINE l_numb1         LIKE type_file.num5
  DEFINE l_year          LIKE type_file.num5
  DEFINE l_year1         LIKE type_file.num5
  DEFINE l_month         LIKE type_file.num5
  DEFINE l_iac           LIKE type_file.num5
  DEFINE l_cnt           LIKE type_file.num5
  DEFINE l_hrci07        LIKE hrci_file.hrci07
  DEFINE l_hrci08        LIKE hrci_file.hrci08
  DEFINE l_hrci09        LIKE hrci_file.hrci09
  DEFINE l_date          LIKE type_file.dat
  DEFINE l_bdate         LIKE type_file.dat
  DEFINE l_hrci03        LIKE hrci_file.hrci03
  DEFINE l_flag          LIKE type_file.chr1
  DEFINE l_allow_insert  LIKE type_file.num5
  DEFINE l_hrcn03        LIKE hrcn_file.hrcn03
  DEFINE tm              RECORD 
         ac              LIKE type_file.chr1,
         bc              LIKE type_file.chr1,
         tt              LIKE hrci_file.hrci08,
         cc              LIKE type_file.chr1,#marked by yeap NO.130829
         dc              LIKE type_file.chr1, #added by yeap  NO.130719
         yt              LIKE hrbm_file.hrbm25,
         jt              LIKE type_file.dat
                     END RECORD
 
               
               
  LET l_flag = 'Y'
  OPEN WINDOW i049_w1  WITH FORM "ghr/42f/ghri049_1"
   ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  CALL cl_ui_locale("ghri049_1")
  CALL cl_set_label_justify("i049_w1","right") 
  CALL cl_set_comp_visible("hrcn02",FALSE)
   
  #初始化  
  LET tm.ac = 'Y'
  LET tm.bc = 'N'
  LET tm.cc = 'N' #marked by yeap NO.130829
  LET tm.dc = 'N'
  LET tm.yt = '001'
  LET tm.jt = g_today
  CALL cl_set_comp_entry("tt,yt,jt",FALSE)
   
  DISPLAY tm.ac TO ac
  DISPLAY tm.bc TO bc
  DISPLAY tm.cc TO cc#marked by yeap NO.130829
  DISPLAY tm.dc TO dc
  DISPLAY tm.yt TO yt
  DISPLAY tm.jt TO jt
  
  CALL i049_1_q()
  
  
  INPUT tm.ac,tm.bc,tm.tt,tm.cc,tm.dc,tm.yt,tm.jt  WITHOUT DEFAULTS FROM ac,bc,tt,cc,dc,yt,jt   #marked by yeap NO.130829
 # INPUT tm.ac,tm.bc,tm.tt,tm.dc,tm.yt,tm.jt  WITHOUT DEFAULTS FROM ac,bc,tt,cc,dc,yt,jt    #added by yeap NO.130829
        
        
        
        ON CHANGE ac
            IF tm.ac = 'Y' THEN
               CALL cl_set_comp_required("tt",FALSE)
               CALL cl_set_comp_entry("tt",FALSE)
               LET tm.bc = 'N'
               LET tm.tt = ''
            ELSE 
            	 CALL cl_set_comp_required("tt",TRUE)
               CALL cl_set_comp_entry("tt",TRUE)
                LET tm.bc = 'Y'
                NEXT FIELD tt 
            END IF
            DISPLAY BY NAME tm.ac,tm.bc,tm.tt
            	
        ON CHANGE bc
            IF tm.bc = 'Y' THEN
               CALL cl_set_comp_required("tt",TRUE)
               CALL cl_set_comp_entry("tt",TRUE)
                LET tm.ac = 'N' 
            ELSE 
            	  LET tm.bc = 'N'
            	  LET tm.tt = NULL
            	 CALL cl_set_comp_required("tt",FALSE)
               CALL cl_set_comp_entry("tt",FALSE)
                LET tm.ac = 'Y'
            END IF
            DISPLAY BY NAME tm.ac,tm.bc,tm.tt
            
       	
        ON CHANGE cc 
            IF tm.cc = 'Y' THEN 
            	 CALL cl_set_comp_entry("yt",TRUE)
            	 CALL cl_set_comp_entry("jt",FALSE)
            	 LET  tm.yt = '001'
            	 LET  tm.dc = 'N'
            	 LET  tm.jt = NULL
            ELSE 
            	  LET tm.cc = 'N'  
            	 CALL cl_set_comp_entry("yt",FALSE)
            	  LET tm.yt = NULL 
            	  LET tm.dc = 'Y'
            	 CALL cl_set_comp_entry("jt",TRUE)
            	 CALL cl_set_comp_entry("yt",FALSE)
            	  LET tm.jt = g_today 
            END IF 
            DISPLAY BY NAME tm.cc,tm.dc,tm.jt,tm.yt
            	
        ON CHANGE dc
            IF tm.dc = 'Y'  THEN
               CALL cl_set_comp_entry("jt",TRUE)
            	 CALL cl_set_comp_entry("yt",FALSE)
            	 LET  tm.jt = g_today
            	 LET  tm.cc = 'N'
            	 LET  tm.yt = NULL
            ELSE
            	  LET tm.dc = 'N'
            	 CALL cl_set_comp_entry("jt",FALSE)
            	  LET tm.jt = NULL 
            	 CALL cl_set_comp_entry("yt",TRUE)
            	 CALL cl_set_comp_entry("jt",FALSE)
            	 LET  tm.yt = '001' 
            END IF
            DISPLAY BY NAME tm.cc,tm.dc,tm.jt,tm.yt    
            
        AFTER FIELD ac
            IF tm.ac = 'Y' THEN 
            	 FOR l_n = 1 TO g_rec_b_1
                   LET g_hrcm[l_n].t_time = g_hrcm[l_n].hrci05
               END FOR 
            END IF
            IF tm.cc = 'N' AND tm.dc = 'N' THEN 
            	 LET tm.cc = 'Y' 
            	 CALL cl_set_comp_entry("yt",TRUE)
            	 CALL cl_set_comp_entry("jt",FALSE)
            	 LET  tm.yt = '001'
            	 LET  tm.dc = 'N'
            	 LET  tm.jt = NULL 
            	 DISPLAY BY NAME tm.cc,tm.dc,tm.jt,tm.yt 
            	 CALL cl_err('','ghr-180',0)
            	 NEXT FIELD cc
            END IF   
        
        AFTER FIELD tt
            FOR l_n = 1 TO g_rec_b_1
              IF NOT cl_null(tm.tt) THEN
                 LET g_hrcm[l_n].t_time = g_hrcm[l_n].hrci05 - g_hrcm[l_n].hrci08 - tm.tt
                  IF g_hrcm[l_n].t_time < 0 THEN 
                     LET g_hrcm[l_n].t_time = 0
                  END IF 
              ELSE
                 LET g_hrcm[l_n].t_time = g_hrcm[l_n].hrci05 - g_hrcm[l_n].hrci08
              END IF 
            END FOR
            IF tm.cc = 'N' AND tm.dc = 'N' THEN 
            	 LET tm.cc = 'Y' 
            	 CALL cl_set_comp_entry("yt",TRUE)
            	 CALL cl_set_comp_entry("jt",FALSE)
            	 LET  tm.yt = '001'
            	 LET  tm.dc = 'N'
            	 LET  tm.jt = NULL 
            	 DISPLAY BY NAME tm.cc,tm.dc,tm.jt,tm.yt 
            	 CALL cl_err('','ghr-180',0)
            	 NEXT FIELD cc
            END IF
            	
        AFTER FIELD jt
            IF cl_null(tm.jt) THEN 
            	FOR l_n = 1 TO g_rec_b_1
            	    LET g_hrcm[l_n].hrci10 = tm.jt
            	     IF g_hrcm[l_n].hrci10 < g_hrcm[l_n].hrcn06 THEN
            	     	  IF g_hrcm[l_n].hrci10 < g_hrcm[l_n].hrcn04 THEN 
            	     	  	 LET g_hrcm[l_n].t_time = 0
            	     	  ELSE 
            	     	  	 LET g_hrcm[l_n].t_time = (g_hrcm[l_n].hrci10 - g_hrcm[l_n].hrcn04)*24 - g_hrcm[l_n].hrcn05[1,2] - (g_hrcm[l_n].hrcn05[4,5]/60)
            	     	  END IF 
            	     ELSE 
            	     	  IF cl_null(g_hrcm[l_n].hrci08) THEN 
            	     	  	 LET  g_hrcm[l_n].hrci08 = 0
            	     	  END IF 
            	     END IF 
            	END FOR 
            END IF 
            	
        AFTER FIELD yt 
          IF cl_null(tm.yt) THEN 
        	   LET tm.yt = '001'
        	ELSE 
             IF tm.yt = '001' THEN LET l_numb = 1  END IF 
             IF tm.yt = '002' THEN LET l_numb = 2  END IF 
             IF tm.yt = '003' THEN LET l_numb = 3  END IF 
             IF tm.yt = '004' THEN LET l_numb = 6  END IF 
             IF tm.yt = '005' THEN LET l_numb = 12 END IF
             	
             FOR l_n = 1 TO g_rec_b_1
                 LET l_year  = YEAR(g_hrcm[l_n].hrcn06)
                 LET l_year1 = YEAR(g_hrcm[l_n].hrcn06)
                 LET l_month = MONTH(g_hrcm[l_n].hrcn06)
                 LET l_numb1 = l_month + l_numb
                  IF l_numb1 > 12 THEN 
                  	 LET l_year1 = l_year + 1 
                  	 LET l_numb1 = l_numb1 - 12 
                  END IF 
#                  CALL s_ymtodate(l_year,(l_month + 1),l_year1,l_numb1) RETURNING l_bdate,g_hrcm[l_n].hrci10  
                  SELECT hrct08 INTO  g_hrcm[l_n].hrci10 FROM hrct_file WHERE hrct03='0000' AND hrct04=l_year1 AND hrct05=l_numb1           
             END FOR
          END IF         	 

#        AFTER FIELD cc
#            IF tm.cc = 'N' AND tm.dc = 'N' THEN 
#            	 CALL cl_err('','ghr-180',0)   
#            	 NEXT FIELD cc
#            END IF
#            	
#        AFTER FIELD dc
#            IF tm.cc = 'N' AND tm.dc = 'N' THEN 
#            	 CALL cl_err('','ghr-180',0)   
#            	 NEXT FIELD dc
#            END IF
       
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
           
        ON ACTION CONTROLG
           CALL cl_cmdask()
            
        ON ACTION CONTROLF                        
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
   IF INT_FLAG THEN                        
      LET INT_FLAG = 0 
      CALL cl_err('',9001,0)
      CLOSE WINDOW i049_w1
      RETURN 
   END IF
   	
         
   
 #marked by yeap1-------NO.130718-------str----------  
 #  LET l_n = 0
 #  FOR l_i = 1 TO g_rec_b
 #     IF g_hrci[l_i].sure = 'Y' THEN
 #        LET l_n = l_n+1
 #        LET g_hrcm[l_n].sure = 'Y'
 #        LET g_hrcm[l_n].hrci01 = g_hrci[l_i].hrci01 
 #        LET g_hrcm[l_n].hrci08 = g_hrci[l_i].hrci08 
 #        LET g_hrcm[l_n].hrci04 = g_hrci[l_i].hrci04 
 #        LET g_hrcm[l_n].hrci05 = g_hrci[l_i].hrci05
 #        LET g_hrcm[l_n].hrci10 = g_hrci[l_i].hrci10  
 #        SELECT hrcn04,hrcn05,hrcn06,hrcn07 INTO g_hrcm[l_n].hrcn04,g_hrcm[l_n].hrcn05,g_hrcm[l_n].hrcn06,g_hrcm[l_n].hrcn07
 #          FROM hrcn_file
 #         WHERE hrcn01 = g_hrcm[l_n].hrci01 
 #        LET g_hrcm[l_n].t_time = 0
 #     END IF
 #  END FOR
 #  DISPLAY l_n TO cn22
 #marked by yeap1-------NO.130718-------end----------  
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
	
	 CALL i049_tmp()
   CALL cl_set_comp_entry("hrci08,hrcm03,hrcn04,hrcn05,hrcn06,hrcn07,hrcn09,hrci05,t_time,hrci10",FALSE)
   CALL cl_set_comp_entry("sure",TRUE)
	INPUT ARRAY g_hrcm WITHOUT DEFAULTS FROM s_hrcm.*
         ATTRIBUTE (COUNT=g_rec_b_1,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW = l_allow_insert,DELETE ROW=FALSE,APPEND ROW=FALSE) 
 
      BEFORE INPUT
         IF g_rec_b_1 != 0 THEN
            CALL fgl_set_arr_curr(l_iac)
         END IF
         FOR l_n = 1 TO g_rec_b_1 
             IF cl_null(g_hrcm[l_n].hrci08) THEN
         	      LET g_hrcm[l_n].hrci08 = 0
             END IF
         END FOR     
         	
     #  LET tm.ac = GET_FLDBUF(ac)
   	    IF tm.ac = 'Y' THEN
   	   	  FOR l_n = 1 TO g_rec_b_1
              LET g_hrcm[l_n].t_time = g_hrcm[l_n].hrci05
          END FOR 
   	   END IF 
   	   	
   	#  LET tm.bc = GET_FLDBUF(bc)
   	   IF tm.bc = 'Y' THEN
          FOR l_n = 1 TO g_rec_b_1
              IF NOT cl_null(tm.tt) THEN
                 LET g_hrcm[l_n].t_time = g_hrcm[l_n].hrci05 - g_hrcm[l_n].hrci08 - tm.tt
                  IF g_hrcm[l_n].t_time < 0 THEN 
                     LET g_hrcm[l_n].t_time = 0
                  END IF 
              ELSE
                 LET g_hrcm[l_n].t_time = g_hrcm[l_n].hrci05 - g_hrcm[l_n].hrci08
              END IF 
          END FOR 
   	   END IF  
   	   	
  # 	  LET tm.cc = GET_FLDBUF(cc)
  # 	  LET tm.dc = GET_FLDBUF(dc)
   	  
   	   IF tm.cc = 'N' AND tm.dc = 'N' THEN 
   	   	  FOR l_n = 1 TO g_rec_b_1
#   	   	      CALL s_ymtodate(YEAR(g_hrcm[l_n].hrcn06),MONTH(g_hrcm[l_n].hrcn06),YEAR(g_hrcm[l_n].hrcn06),MONTH(g_hrcm[l_n].hrcn06)) RETURNING l_bdate,g_hrcm[l_n].hrci10
   	   	      LET l_year1=YEAR(g_hrcm[l_n].hrcn06)
                  LET l_numb1=MONTH(g_hrcm[l_n].hrcn06)
                  SELECT hrct08 INTO  g_hrcm[l_n].hrci10 FROM hrct_file WHERE hrct03='0000' AND hrct04=l_year1 AND hrct05=l_numb1
            	 END FOR    
   	   ELSE 
   	   	IF tm.cc = 'Y' THEN 
   	   		IF cl_null(tm.yt) THEN 
        	   LET tm.yt = '001'
        	ELSE 
             IF tm.yt = '001' THEN LET l_numb = 1  END IF 
             IF tm.yt = '002' THEN LET l_numb = 2  END IF 
             IF tm.yt = '003' THEN LET l_numb = 3  END IF 
             IF tm.yt = '004' THEN LET l_numb = 6  END IF 
             IF tm.yt = '005' THEN LET l_numb = 12 END IF
             	
             FOR l_n = 1 TO g_rec_b_1
                 LET l_year  = YEAR(g_hrcm[l_n].hrcn06)
                 LET l_year1 = YEAR(g_hrcm[l_n].hrcn06)
                 LET l_month = MONTH(g_hrcm[l_n].hrcn06)
                 LET l_numb1 = l_month + l_numb
                  IF l_numb1 > 12 THEN 
                  	 LET l_year1 = l_year + 1 
                  	 LET l_numb1 = l_numb1 - 12 
                  END IF 
#                  CALL s_ymtodate(l_year,(l_month + 1),l_year1,l_numb1) RETURNING l_bdate,g_hrcm[l_n].hrci10            
                  SELECT hrct08 INTO  g_hrcm[l_n].hrci10 FROM hrct_file WHERE hrct03='0000' AND hrct04=l_year1 AND hrct05=l_numb1
             END FOR
          END IF
        END IF
        IF tm.dc = 'Y' THEN 
        	 FOR l_n = 1 TO g_rec_b_1
        	     IF NOT cl_null(tm.jt) THEN
            	    LET g_hrcm[l_n].hrci10 = tm.jt
            	     IF g_hrcm[l_n].hrci10 < g_hrcm[l_n].hrcn06 THEN
            	     	  IF g_hrcm[l_n].hrci10 < g_hrcm[l_n].hrcn04 THEN 
            	     	  	 LET g_hrcm[l_n].t_time = 0
            	     	  ELSE 
            	     	  	 LET g_hrcm[l_n].t_time = (g_hrcm[l_n].hrci10 - g_hrcm[l_n].hrcn04)*24 - g_hrcm[l_n].hrcn05[1,2] - (g_hrcm[l_n].hrcn05[4,5]/60)
            	     	  END IF 
            	     ELSE 
            	     	  IF cl_null(g_hrcm[l_n].hrci08) THEN 
            	     	  	 LET  g_hrcm[l_n].hrci08 = 0
            	     	  END IF 
            	     END IF
            	 ELSE 
#            	 	   CALL s_ymtodate(YEAR(g_hrcm[l_n].hrcn06),MONTH(g_hrcm[l_n].hrcn06),YEAR(g_hrcm[l_n].hrcn06),MONTH(g_hrcm[l_n].hrcn06)) RETURNING l_bdate,g_hrcm[l_n].hrci10  
                  LET l_year1=YEAR(g_hrcm[l_n].hrcn06)
                  LET l_numb1=MONTH(g_hrcm[l_n].hrcn06)
                  SELECT hrct08 INTO  g_hrcm[l_n].hrci10 FROM hrct_file WHERE hrct03='0000' AND hrct04=l_year1 AND hrct05=l_numb1
            	 END IF
           END FOR 
        END IF 
       END IF 
              
   	  
         
          
      BEFORE ROW
          LET l_iac = ARR_CURR()
          
          
          ON ACTION sel_all
             LET l_i = 0
             FOR l_i = 1 TO g_rec_b_1
                 LET g_hrcm[l_i].sure = 'Y'
             END FOR 
          
          ON ACTION sel_none
             LET l_i = 0
             FOR l_i = 1 TO g_rec_b_1
                 LET g_hrcm[l_i].sure = 'N'
             END FOR
                 	  
                 	  
       #marked by yeap1 -----NO.130718----str--------          	 
       #   BEGIN WORK
       #   IF l_n>=l_iac THEN 
       #      IF cl_null(g_hrcm[l_iac].sure) THEN LET g_hrcm[l_iac].sure = 'Y' END IF 
       #      LET l_hrci03 =''
       #      SELECT hrci03 INTO l_hrci03 FROM hrci_file
       #       WHERE hrci01 = g_hrcm[l_iac].hrci01
       #      AND rownum = 1
       #      IF tm.cc = 'Y' THEN
       #         SELECT lastday(l_hrci03)+1 INTO l_date FROM DUAL
       #      ELSE
       #         LET l_date = l_hrci03
       #      END IF
       #      LET l_hrci03 = l_date
       #      IF tm.yt = '001' THEN
       #         SELECT add_months(l_date,1) INTO l_date FROM DUAL
       #      END IF
       #      IF tm.yt = '002' THEN
       #         SELECT add_months(l_date,2) INTO l_date FROM DUAL
       #      END IF 
       #      IF tm.yt = '003' THEN
       #         SELECT add_months(l_date,3) INTO l_date FROM DUAL
       #      END IF 
       #      IF tm.yt = '004' THEN
       #         SELECT add_months(l_date,6) INTO l_date FROM DUAL
       #      END IF 
       #      IF tm.yt = '005' THEN
       #         SELECT add_months(l_date,12) INTO l_date FROM DUAL
       #      END IF   
       #      IF NOT cl_null(tm.jt) THEN
       #         IF tm.jt < l_date THEN
       #            LET l_date = tm.jt
       #         END IF
       #     END IF              
       #      CALL cl_show_fld_cont()     
    #   #   END IF
  
 
    #  ON CHANGE hrci10
    #     IF NOT cl_null(g_hrcm[l_iac].hrci10)  THEN
    #        IF l_date < g_hrcm[l_iac].hrci10 THEN 
    #           CALL cl_err("截止日期时间过长",'!',0)
    #           NEXT FIELD hrci10
    #        END IF 
    #        IF NOT cl_null(g_hrcm[l_iac].hrcn04) AND g_hrcm[l_iac].hrcn04 > g_hrcm[l_iac].hrci10 THEN 
    #           CALL cl_err("开始日期不能大于截止日期",'!',0)
    #           NEXT FIELD hrci10
    #        END IF   
    #        IF NOT cl_null(g_hrcm[l_iac].hrcn06) AND g_hrcm[l_iac].hrcn06 > g_hrcm[l_iac].hrci10 THEN 
    #           CALL cl_err("结束日期不能大于截止日期",'!',0)
    #           NEXT FIELD hrci10
    #        END IF                             
    #     END IF   

    # AFTER FIELD t_time
    #     IF g_hrcm[l_iac].t_time > tm.tt AND NOT cl_null(tm.tt) THEN
    #        CALL cl_err("不能大于部分调休时数","!",0)
    #        NEXT FIELD t_time
    #     END IF
    #     IF NOT cl_null(g_hrcm[l_iac].t_time) THEN
    #        LET l_hrci09 = ''
    #        SELECT hrci09 INTO l_hrci09 FROM hrci_file WHERE hrci01 = g_hrcm[l_iac].hrci01
    #        IF cl_null(l_hrci09) THEN
    #          LET l_hrci09 = 0
    #        END IF
    #        IF l_hrci09 > tm.tt AND NOT cl_null(tm.tt) THEN
    #          LET l_hrci09 = tm.tt
    #        END IF
    #        IF g_hrcm[l_iac].t_time >  l_hrci09 THEN
    #          LET l_str = "不可大于可调时数",l_hrci09
    #          CALL cl_err(l_str,'!',0)
    #          NEXT FIELD t_time
    #        END IF
    #     END IF              
    #   #marked by yeap1-------NO.130718-------end----------  
                                                       
      AFTER ROW
         LET l_iac = ARR_CURR()
         LET g_max = 0
                   
          IF INT_FLAG THEN              
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0 
             LET l_flag = 'N' 
             LET g_chus = 100     
             EXIT INPUT
          END IF 
          # else	
          AFTER INPUT 
          	 LET g_chus = 10
         	   LET l_i = 0
             LET l_j = 0
             LET g_rec_b = 0
             FOR l_i = 1 TO g_rec_b_1 
                 IF g_hrcm[l_i].sure = 'Y' THEN 
                  	LET l_j = l_j + 1
                  	
                  	LET g_hrbm04 = g_hrcm[l_i].hrcn09
                  	SELECT hrbm03 INTO g_hrcm[l_i].hrcn09 FROM hrbm_file WHERE hrbm04 = g_hrbm04 
                 	  
                 	  LET g_hrci[l_j].hrci01 = g_hrcm[l_i].hrcn02
                 	  LET g_hrci[l_j].hrci03 = g_hrcm[l_i].hrcn06
                 	  LET g_hrci[l_j].hrci04 = g_hrcm[l_i].hrcn09
                 	  LET g_hrci[l_j].hrci05 = g_hrcm[l_i].hrci05
                 	  LET g_hrci[l_j].hrci07 = g_hrcm[l_i].t_time
                 	  LET g_hrci[l_j].hrci08 = g_hrcm[l_i].hrci08
                # 	  LET g_hrci[l_j].hrci06 = g_hrci[l_i].hrci05-g_hrci[l_i].hrci07   #marked by yeap NO.130801  角标错了
                # 	  LET g_hrci[l_j].hrci09 = g_hrci[l_i].hrci07-g_hrci[l_i].hrci08
                 	  LET g_hrci[l_j].hrci06 = g_hrci[l_j].hrci05-g_hrci[l_j].hrci07   #modified by yeap NO.130801
                 	  LET g_hrci[l_j].hrci09 = g_hrci[l_j].hrci07-g_hrci[l_j].hrci08
                 	  LET g_hrci[l_j].hrci10 = g_hrcm[l_i].hrci10
                 	#  LET g_hrci[l_j].hrci11 = NULL
                 	  LET g_hrci[l_j].hrciconf = "N"
                 	  
                 	  SELECT hrcn03 INTO l_hrcn03 FROM hrcn_file WHERE hrcn02 = g_hrcm[l_i].hrcn02
                 	  SELECT COUNT(*) INTO l_cnt FROM hrci_file WHERE hrci01 = g_hrcm[l_i].hrcn02
                 	  IF l_cnt > 0 THEN 
                 	  	 UPDATE hrci_file
                 	  	    SET hrci02 = l_hrcn03,
                 	            hrci03 = g_hrcm[l_i].hrcn06,
                 	            hrci04 = g_hrcm[l_i].hrcn09,
                       	      hrci05 = g_hrcm[l_i].hrci05,
                       	      hrci07 = g_hrcm[l_i].t_time,
                       	      hrci08 = g_hrcm[l_i].hrci08,
                       	      hrci06 = g_hrci[l_j].hrci05-g_hrci[l_j].hrci07,
                       	      hrci09 = g_hrci[l_j].hrci07-g_hrci[l_j].hrci08,
                 	            hrci10 = g_hrcm[l_i].hrci10,
                 	            hrcimodu = g_user,
                 	            hrcidate = g_today
                        WHERE hrci01 = g_hrcm[l_i].hrcn02
                        
                       IF SQLCA.sqlcode THEN
                 	  	    CALL cl_err('g_hrci[l_j].hrci01',"ghr-135",0)  
                       ELSE 
                       	SELECT hrat01,hrat02,hrat04,hrao02,hrat05,hras04
                 	        INTO g_hrci[l_j].hrat01,g_hrci[l_j].hrat02,g_hrci[l_j].hrat04,g_hrci[l_j].hrat05,
                               g_hrci[l_j].hrao02,g_hrci[l_j].hras04
                          FROM hrci_file left join hrat_file on hrci02 = hratid   
                               left join hrao_file on hrat04 = hrao02   
                               left join hras_file on hras01 = hrao05
                         WHERE hrci02 = l_hrcn03 
                       #	SELECT hrat01,hrat02,hrat04,hrat05,hrao02,hras04
                       #	  INTO g_hrci[l_j].hrat01,g_hrci[l_j].hrat02,g_hrci[l_j].hrat04,g_hrci[l_j].hrat05,
                       #	       g_hrci[l_j].hrao02,g_hrci[l_j].hras04
                       #	  FROM hrat_file,hrao_file,hras_file
                       #	 WHERE hratid = l_hrcn03 AND hrat04 = hrao02 AND hras01 = hrao05       
                 	        INSERT INTO hrci_tmp 
                 	        VALUES('N',g_hrci[l_j].hrci01,g_hrci[l_j].hrat01,g_hrci[l_j].hrat02,g_hrci[l_j].hrat04,
                 	               g_hrci[l_j].hrat05,g_hrci[l_j].hrao02,g_hrci[l_j].hras04,g_hrci[l_j].hrci03,g_hrbm04,
                 	               g_hrci[l_j].hrci05,g_hrci[l_j].hrci06,g_hrci[l_j].hrci07,g_hrci[l_j].hrci08,
                 	               g_hrci[l_j].hrci09,g_hrci[l_j].hrci10,g_hrci[l_j].hrci11,g_hrci[l_j].hrciconf)
                 	           LET g_max = g_max + 1
                       END IF
                    ELSE 
                 	     INSERT INTO hrci_file 
                 	          VALUES (g_hrci[l_j].hrci01,l_hrcn03,g_hrci[l_j].hrci03,g_hrci[l_j].hrci04,
                 	                  g_hrci[l_j].hrci05,g_hrci[l_j].hrci06,g_hrci[l_j].hrci07,g_hrci[l_j].hrci08,
                 	                  g_hrci[l_j].hrci09,g_hrci[l_j].hrci10,g_hrci[l_j].hrci11,g_hrci[l_j].hrciconf,'Y','','','','',
                 	                  '','','','','','','','','','','',g_user,g_grup,'','',g_grup,g_user)
                 	                  
                 	     IF SQLCA.sqlcode THEN
                 	  	    CALL cl_err('g_hrci[l_j].hrci01',"ghr-135",0)  
                       ELSE          
                 	        SELECT hrat01,hrat02,hrat04,hrao02,hrat05,hras04
                 	          INTO g_hrci[l_j].hrat01,g_hrci[l_j].hrat02,g_hrci[l_j].hrat04,g_hrci[l_j].hrat05,
                        	       g_hrci[l_j].hrao02,g_hrci[l_j].hras04
                            FROM hrci_file left join hrat_file on hrci02 = hratid   
                                 left join hrao_file on hrat04 = hrao02   
                                 left join hras_file on hras01 = hrao05 
                           WHERE hrci02 = l_hrcn03
                       #	SELECT hrat01,hrat02,hrat04,hrat05,hrao02,hras04
                       #	  INTO g_hrci[l_j].hrat01,g_hrci[l_j].hrat02,g_hrci[l_j].hrat04,g_hrci[l_j].hrat05,
                       #	       g_hrci[l_j].hrao02,g_hrci[l_j].hras04
                       #	  FROM hrat_file,hrao_file,hras_file
                       #	 WHERE hratid = l_hrcn03 AND hrat04 = hrao02 AND hras01 = hrao05       
                 	        INSERT INTO hrci_tmp 
                 	        VALUES('N',g_hrci[l_j].hrci01,g_hrci[l_j].hrat01,g_hrci[l_j].hrat02,g_hrci[l_j].hrat04,
                 	               g_hrci[l_j].hrat05,g_hrci[l_j].hrao02,g_hrci[l_j].hras04,g_hrci[l_j].hrci03,g_hrbm04,
                 	               g_hrci[l_j].hrci05,g_hrci[l_j].hrci06,g_hrci[l_j].hrci07,g_hrci[l_j].hrci08,
                 	               g_hrci[l_j].hrci09,g_hrci[l_j].hrci10,g_hrci[l_j].hrci11,g_hrci[l_j].hrciconf)
                 	           LET g_max = g_max + 1
                       END IF 
                    END IF
                 END IF  
             END FOR 
       #   END IF  
      
      ON ACTION CONTROLR
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
 
   END INPUT          
  #marked by yeap1-------NO.130718-------str----------  
  # IF l_flag = 'Y' THEN
  #    FOR l_i = 1 TO l_n
  #        IF g_hrcm[l_iac].sure = 'Y' THEN
  #           LET l_hrci07=''
  #           LET l_hrci08=''
  #           LET l_hrci09=''
  #           SELECT hrci07,hrci08,hrci09 INTO l_hrci07,l_hrci08,l_hrci09
  #             FROM hrci_file
  #            WHERE hrci01 = g_hrcm[l_iac].hrci01
  #              AND rownum = 1
  #           IF cl_null(g_hrcm[l_iac].t_time) THEN
  #              LET g_hrcm[l_iac].t_time = 0
  #           END IF
  #           LET l_hrci08 = l_hrci08 + g_hrcm[l_iac].t_time
  #           LET l_hrci09 = l_hrci07 - l_hrci08
  #           UPDATE hrci_file SET hrci07 = l_hrci07,hrci08 = l_hrci08,hrci09 = l_hrci09,hrci10 = g_hrcm[l_iac].hrci10
  #            WHERE hrci01 = g_hrcm[l_iac].hrci01  
  #        END IF       
  #    END FOR       
  # END IF
  #marked by yeap1-------NO.130718-------end----------  
     CLOSE WINDOW i049_w1
  # CALL i049_b_fill(g_wc2)   marked by yeap1-------NO.130718    
END FUNCTION   



FUNCTION i049_1_q()
	DEFINE 
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5, 
    l_i             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1,
    l_hrcm02        LIKE hrcm_file.hrcm02,  #added by yeap1  NO.130718
    l_hrcm03        LIKE hrcm_file.hrcm03,  #added by yeap1  NO.130718
    l_hrbm03        LIKE hrbm_file.hrbm03,  #added by yeap1  NO.130718
    l_hrbm04        LIKE hrbm_file.hrbm04   #added by yeap1  NO.130718
    
    
    CLEAR FORM
    CALL g_hrcm.clear()
    
    CONSTRUCT g_wc ON hrat01,hrat02,hrat04,hrat05,   #added by yeap NO.130801
                      hrci08,hrcm03,hrcn04,hrcn05,hrcn06,hrcn07,hrcn09,hrci05,t_time,hrci10
                      
         FROM s_hrcm[1].hrat01,s_hrcm[1].hrat02,s_hrcm[1].hrat04,s_hrcm[1].hrat05,     #added by yeap NO.130801
              s_hrcm[1].hrci08,s_hrcm[1].hrcm03,s_hrcm[1].hrcn04,s_hrcm[1].hrcn05,
              s_hrcm[1].hrcn06,s_hrcm[1].hrcn07,s_hrcm[1].hrcn09,s_hrcm[1].hrci05,
              s_hrcm[1].t_time,s_hrcm[1].hrci10
              
              
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         
         
      ON ACTION controlp
         CASE 
         	  WHEN INFIELD(hrcm03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "g_hrcm02"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   LET l_hrcm02 = g_qryparam.multiret
                   SELECT hrcm03 INTO l_hrcm03 FROM hrcm_file WHERE hrcm02 = l_hrcm02
                   DISPLAY l_hrcm03 TO s_hrcm[1].hrcm03
                   
            WHEN INFIELD(hrcn09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbm03"
                 LET g_qryparam.arg1 = "008"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 LET l_hrbm03 = g_qryparam.multiret
                 SELECT hrbm04 INTO l_hrbm04 FROM hrbm_file WHERE hrbm03 = l_hrbm03
                 DISPLAY l_hrbm04 TO s_hrcm[1].hrcn09    
                 
#added by yeap NO.130801----------str----------------
            WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_hrat01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_hrcm[1].hrat01
                 NEXT FIELD hrat01
                 
            WHEN INFIELD(hrat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_hrcm[1].hrat04
                 NEXT FIELD hrat04
                 
            WHEN INFIELD(hrat05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrap01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_hrcm[1].hrat05
                 NEXT FIELD hrat05
                                                   
              OTHERWISE
                   EXIT CASE
         END CASE 
    
	
	    ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help() 
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save() 
         
	   END CONSTRUCT
	   CALL i049_1_b_fill(g_wc)
	   
	   IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_wc = NULL
        RETURN
     END IF 
END FUNCTION 
	
	
FUNCTION i049_1_b_fill(p_wc)
	DEFINE p_wc       STRING
	DEFINE l_hrat04       LIKE hrat_file.hrat04,  #added by yeap1  NO.130801
         l_hrat05       LIKE hrat_file.hrat05   #added by yeap1  NO.130801 
	IF cl_null(p_wc) THEN
           LET p_wc = '1=1'
        END IF     	
	LET g_sql = "  SELECT 'N',hrat01,hrat02,hrat04,hrat05,hrcn02,hrci08,hrcm03,hrcn04,hrcn05,hrcn06,hrcn07,hrcn09,hrci05,'',hrci10  ",
	            "    FROM  hrcn_file  left join hrci_file on hrcn02 = hrci01   ",
	            "     AND  hrciconf = 'N'  ",
	            "     AND  hrciacti = 'Y'  ",
	            "          left join hrcm_file on hrcn01 = hrcm02  ",
	            "    left join hrat_file on hrcn03 = hratid  ",    #added by yeap1  NO.130801
	            "   WHERE  hrcnconf = 'Y'  ",
	            "     AND  ",p_wc  CLIPPED ,
	            "   ORDER BY hrcn02   "
	PREPARE i049_1_pb FROM g_sql
  DECLARE i049_1_curs CURSOR FOR i049_1_pb 
  
   CALL g_hrcm.clear()
   LET g_cnt = 1 
   MESSAGE "Searching!" 
   FOREACH i049_1_curs INTO g_hrcm[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
      LET g_hrcm02 = g_hrcm[g_cnt].hrcm03
      LET g_hrbm03 = g_hrcm[g_cnt].hrcn09
      SELECT hrcm03 INTO g_hrcm[g_cnt].hrcm03 FROM hrcm_file WHERE hrcm02 = g_hrcm02
      SELECT hrbm04 INTO g_hrcm[g_cnt].hrcn09 FROM hrbm_file WHERE hrbm03 = g_hrbm03
      
      LET l_hrat04 = g_hrcm[g_cnt].hrat04
      LET l_hrat05 = g_hrcm[g_cnt].hrat05
      SELECT hrao02 INTO g_hrcm[g_cnt].hrat04 FROM hrao_file WHERE hrao01 = l_hrat04        
      SELECT hrap06 INTO g_hrcm[g_cnt].hrat05 FROM hrap_file WHERE hrap05 = l_hrat05 AND hrap01 = l_hrat04 
      DISPLAY BY NAME g_hrcm[g_cnt].hrcm03,g_hrcm[g_cnt].hrcn09,g_hrcm[g_cnt].hrat04, g_hrcm[g_cnt].hrat05
      
               LET  g_h1 = g_hrcm[g_cnt].hrcn05[1,2]
               LET  g_m1 = g_hrcm[g_cnt].hrcn05[4,5]
               LET  g_h2 = g_hrcm[g_cnt].hrcn07[1,2]
               LET  g_m2 = g_hrcm[g_cnt].hrcn07[4,5]
               LET g_hrcm[g_cnt].hrci05 = (g_hrcm[g_cnt].hrcn06-g_hrcm[g_cnt].hrcn04)*24 + (g_h2-g_h1) + (g_m2-g_m1)/60
      
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
   END FOREACH
   CALL g_hrcm.deleteElement(g_cnt)
   
   DISPLAY ARRAY g_hrcm TO s_hrcm.* ATTRIBUTE(COUNT=g_max_rec,UNBUFFERED)
   
        BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            EXIT DISPLAY 
            
   END DISPLAY 
   
   MESSAGE ""
   LET g_rec_b_1 = g_cnt-1
   DISPLAY g_rec_b_1 TO FORMONLY.cn22  
   LET g_cnt = 0
	          
END FUNCTION  
	
	
FUNCTION i049_b_fill_1()
	
	DECLARE i049_cl CURSOR FOR SELECT * FROM hrci_tmp
   
    LET g_cnt = 1
    MESSAGE "Searching!"
    CALL g_hrci.clear() 
    FOREACH i049_cl INTO g_hrci[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF 
      
        SELECT hrao02 INTO g_hrci[g_cnt].hrao02 FROM hrao_file WHERE hrao01 = g_hrci[g_cnt].hrat04        
        SELECT hrap06 INTO g_hrci[g_cnt].hras04 FROM hrap_file WHERE hrap05 = g_hrci[g_cnt].hrat05 AND hrap01 = g_hrci[g_cnt].hrat04       
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    DROP TABLE hrci_tmp
    CALL g_hrci.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt2 = g_cnt-1
    LET g_cnt = 0
      
END FUNCTION 
	
	
FUNCTION i049_tmp()
   CREATE TEMP TABLE hrci_tmp
   (
    sure        VARCHAR(1), 
    hrci01      VARCHAR(20), 
    hrat01      VARCHAR(50), 
    hrat02      VARCHAR(50), 
    hrat04      VARCHAR(20), 
    hrao02      VARCHAR(40), 
    hrat05      VARCHAR(50), 
    hras04      VARCHAR(100), 
    hrci03      DATE, 
    hrci04      VARCHAR(20), 
    hrci05      DEC(5,2), 
    hrci06      DEC(5,2), 
    hrci07      DEC(5,2), 
    hrci08      DEC(5,2), 
    hrci09      DEC(5,2), 
    hrci10      DATE, 
    hrci11      VARCHAR(255), 
    hrciconf    VARCHAR(1)    
    )
END FUNCTION 
	
FUNCTION i049_choose(p_cmd)  #added by yeap NO.130801
	DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5, 
    l_i             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1 
     
    IF g_rec_b <= 0 THEN 
       CALL cl_err('','ghr-121',1)
       RETURN 
    END IF    
 
    CALL  cl_set_comp_visible('sure',TRUE)
    CALL cl_set_comp_entry("hrci01,hrat01,hrat02,hrat04,hrao02,hrat05,hras04,hrci03,hrci04",FALSE)
    CALL cl_set_comp_entry("hrci05,hrci06,hrci07,hrci08,hrci09,hrci10,hrci11,hrciconf",FALSE)
    INPUT ARRAY g_hrci  WITHOUT DEFAULTS FROM s_hrci.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_rec_b,  UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
 
    BEFORE INPUT
        CALL cl_set_act_visible("accept,cancel",TRUE)		
       	
    BEFORE ROW
        LET l_ac = ARR_CURR()
        LET l_n  = ARR_COUNT()
        DISPLAY BY NAME g_hrci[l_ac].sure
    	
      ON ACTION sel_all
         LET g_action_choice="sel_all" 
         LET l_i = 0        	
         FOR l_i = 1 TO g_rec_b
             LET g_hrci[l_i].sure = 'Y'
             DISPLAY BY NAME g_hrci[l_i].sure
         END FOR  
      ON ACTION sel_none
         LET g_action_choice="sel_none"   
         LET l_i = 0     	
         FOR l_i = 1 TO g_rec_b
             LET g_hrci[l_i].sure = 'N'
             DISPLAY BY NAME g_hrci[l_i].sure
         END FOR
      ON ACTION accept
         CALL i049_confirm(p_cmd)
         EXIT INPUT 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         CALL cl_cmdask() 
         EXIT INPUT                          
     END INPUT 
     FOR l_i = 1 TO g_rec_b
             LET g_hrci[l_i].sure = 'N'
     END FOR   
     CALL cl_set_comp_visible('sure',FALSE)
     CALL cl_set_comp_entry("hrci01,hrat01,hrat02,hrat04,hrao02,hrat05,hras04,hrci03,hrci04",TRUE)
     CALL cl_set_comp_entry("hrci05,hrci06,hrci07,hrci08,hrci09,hrci10,hrci11,hrciconf",TRUE)    
END FUNCTION 
	 
	
