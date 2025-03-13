# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri012.4gl
# Descriptions...: 员工试用期管理-撤销转正&归档
# Date & Author..: 13/04/03 by liudong

DATABASE ds
 
GLOBALS "../../config/top.global"


DEFINE 
     g_hray         DYNAMIC ARRAY OF RECORD    
        sel         LIKE type_file.chr1,       #选择，默认'N'
        hray01      LIKE hray_file.hray01,     #试用期工号
        hrat02      LIKE hrat_file.hrat02,     #员工姓名
        hraa12      LIKE hraa_file.hraa12,     #公司名称
        hrao02      LIKE hrao_file.hrao02,     #部门名称
        hras04      LIKE hras_file.hras04,     #职位
        hray02      LIKE hray_file.hray02,     #转正日期
        hray03      LIKE hray_file.hray03,     #转岗部门编码
        zg_part     LIKE type_file.chr20,      #转岗部门名称
        hray04      LIKE hray_file.hray04,     #转岗职位编码
        zg_post     LIKE type_file.chr20,      #转岗职位名称
        hray05      LIKE hray_file.hray05,     #审核人编码
        cf_name     LIKE type_file.chr20,      #审核人姓名
        hray06      LIKE hray_file.hray06,     #审核日期
        hray07      LIKE hray_file.hray07,     #审核结果编码  
        result      LIKE type_file.chr20       #审核结果说明
                    END RECORD,
    g_hray_t        DYNAMIC ARRAY OF RECORD    
        sel         LIKE type_file.chr1,       #选择，默认'N'
        hray01      LIKE hray_file.hray01,     #试用期工号
        hrat02      LIKE hrat_file.hrat02,     #员工姓名
        hraa12      LIKE hraa_file.hraa12,     #公司名称
        hrao02      LIKE hrao_file.hrao02,     #部门名称
        hras04      LIKE hras_file.hras04,     #职位
        hray02      LIKE hray_file.hray02,     #转正日期
        hray03      LIKE hray_file.hray03,     #转岗部门编码
        zg_part     LIKE type_file.chr20,      #转岗部门名称
        hray04      LIKE hray_file.hray04,     #转岗职位编码
        zg_post     LIKE type_file.chr20,      #转岗职位名称
        hray05      LIKE hray_file.hray05,     #审核人编码
        cf_name     LIKE type_file.chr20,      #审核人姓名
        hray06      LIKE hray_file.hray06,     #审核日期
        hray07      LIKE hray_file.hray07,     #审核结果编码  
        result      LIKE type_file.chr20       #审核结果说明
                    END RECORD,
    g_hray01        DYNAMIC ARRAY OF LIKE hray_file.hray01,     #员工表KEY值
    g_hray01_t      DYNAMIC ARRAY OF LIKE hray_file.hray01,     #员工表KEY值
    g_wc2           STRING,
    g_wc            STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5, 
    g_sel_b         LIKE type_file.num5,               
    l_ac            LIKE type_file.num5                 
 
DEFINE g_forupd_sql STRING     
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5       
DEFINE g_str        STRING
DEFINE g_flag       LIKE type_file.chr10

#add by zhangbo130905---begin
DEFINE 
     g_hray_1         DYNAMIC ARRAY OF RECORD    
        sel         LIKE type_file.chr1,       #选择，默认'N'
        hray01      LIKE hray_file.hray01,     #试用期工号
        hrat02      LIKE hrat_file.hrat02,     #员工姓名
        hraa12      LIKE hraa_file.hraa12,     #公司名称
        hrao02      LIKE hrao_file.hrao02,     #部门名称
        hras04      LIKE hras_file.hras04,     #职位
        hray02      LIKE hray_file.hray02,     #转正日期
        hray03      LIKE hray_file.hray03,     #转岗部门编码
        zg_part     LIKE type_file.chr20,      #转岗部门名称
        hray04      LIKE hray_file.hray04,     #转岗职位编码
        zg_post     LIKE type_file.chr20,      #转岗职位名称
        hray05      LIKE hray_file.hray05,     #审核人编码
        cf_name     LIKE type_file.chr20,      #审核人姓名
        hray06      LIKE hray_file.hray06,     #审核日期
        hray07      LIKE hray_file.hray07,     #审核结果编码  
        result      LIKE type_file.chr20       #审核结果说明
                    END RECORD,
    g_hray_1_t        DYNAMIC ARRAY OF RECORD    
        sel         LIKE type_file.chr1,       #选择，默认'N'
        hray01      LIKE hray_file.hray01,     #试用期工号
        hrat02      LIKE hrat_file.hrat02,     #员工姓名
        hraa12      LIKE hraa_file.hraa12,     #公司名称
        hrao02      LIKE hrao_file.hrao02,     #部门名称
        hras04      LIKE hras_file.hras04,     #职位
        hray02      LIKE hray_file.hray02,     #转正日期
        hray03      LIKE hray_file.hray03,     #转岗部门编码
        zg_part     LIKE type_file.chr20,      #转岗部门名称
        hray04      LIKE hray_file.hray04,     #转岗职位编码
        zg_post     LIKE type_file.chr20,      #转岗职位名称
        hray05      LIKE hray_file.hray05,     #审核人编码
        cf_name     LIKE type_file.chr20,      #审核人姓名
        hray06      LIKE hray_file.hray06,     #审核日期
        hray07      LIKE hray_file.hray07,     #审核结果编码  
        result      LIKE type_file.chr20       #审核结果说明
                    END RECORD,
    g_hray01_1        DYNAMIC ARRAY OF LIKE hray_file.hray01,     #员工表KEY值
    g_hray01_1_t      DYNAMIC ARRAY OF LIKE hray_file.hray01,     #员工表KEY值
    g_wc2_1           STRING,
    g_wc_1            STRING, 
    g_rec_b_1         LIKE type_file.num5, 
    g_sel_b_1         LIKE type_file.num5,               
    l_ac_1            LIKE type_file.num5 
   
#add by zhangbo130905---end

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
    OPEN WINDOW i012_w AT p_row,p_col WITH FORM "ghr/42f/ghri012"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()
    
    LET g_forupd_sql = "SELECT hratid ", 
                       "  FROM hrat_file WHERE hratid=?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i012_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET g_wc2 = '1=1'
    LET g_wc2_1 = '1=1'      #add by zhangbo130905
    
    #LET g_flag='N'                           #查询归档资料开关-关  #mark by zhangbo130905
    LET g_flag='pg1'     #add by zhangbo130905
    CALL i012_b_fill(g_wc2,g_wc2_1)     #mod by zhangbo130905
    CALL i012_menu()
    CLOSE WINDOW i012_w                 
      CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i012_menu()
 
   WHILE TRUE
   #   IF cl_null(g_action_choice) THEN     #add by zhangbo130905
         IF g_flag='pg1' THEN              #add by zhangbo130905
            CALL i012_b()                 
         ELSE                              #add by zhangbo130905
            CALL i012_b1()                 #add by zhangbo130905
   #      END IF                            #add by zhangbo130905
      END IF                               #add by zhangbo130905
      CASE g_action_choice
      	 #add by zhangbo130905---begin 
      	 WHEN "pg1"
      	    IF cl_chk_act_auth() THEN
               CALL i012_b()
            END IF
            	
         WHEN "pg2"
      	    IF cl_chk_act_auth() THEN
               CALL i012_b1()
            END IF
         #add by zhangbo130905---end   	    	
         WHEN "query" 
            IF cl_chk_act_auth() THEN
            	 IF g_flag='pg1' THEN     #add by zhangbo130905
               #LET g_flag='N'                 #查询归档资料开关-关   #mark by zhangbo130905
                  CALL i012_q()
               ELSE                     #add by zhangbo130905
               	  CALL i012_q1()        #add by zhangbo130905
               END IF                   #add by zhangbo130905	     
            END IF
         WHEN "ghri012_a"
            IF cl_chk_act_auth() THEN
               CALL i012_undo_zz()
            END IF 

        
         WHEN "ghri012_b"
            IF cl_chk_act_auth() THEN
               CALL i012_guidang()
            END IF         
         WHEN "qry_gd"
            IF cl_chk_act_auth() THEN
               #LET g_flag = 'Y'              #查询归档资料开关-开
               CALL i012_q()
            END IF 

         #add by zhangbo130905---begin
         WHEN "ghri012_c"
            IF cl_chk_act_auth() THEN
               CALL i012_undo_guidang()
            END IF
         #add by zhangbo130905---end
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_action_choice=NULL 
            
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
            	 IF g_flag='pg1' THEN   #add by zhangbo130905
                  CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hray),'','')
               ELSE                   #add by zhangbo130905
              	  CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hray_1),'','')
               END IF	     
            END IF
 
      END CASE
   END WHILE
END FUNCTION

FUNCTION i012_q()
   CALL i012_b_askkey()
END FUNCTION

#add by zhangbo130905---begin
FUNCTION i012_q1()
   CALL i012_b1_askkey()
END FUNCTION
#add by zhangbo130905---end	
	
FUNCTION i012_b()
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
    #IF g_flag = 'Y' THEN                                 #mark by zhangbo130905 
    #  CALL cl_set_act_visible("undo_zhuanzheng", FALSE)  #mark by zhangbo130905
    #ELSE                                                 #mark by zhangbo130905 
    #	CALL cl_set_act_visible("undo_zhuanzheng", TRUE)    #mark by zhangbo130905
    #END IF                                               #mark by zhangbo130905
    
    INPUT ARRAY g_hray WITHOUT DEFAULTS FROM s_hray.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_rec_b,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF		
       DISPLAY g_rec_b TO FORMONLY.cnt1   #add by zhangbo130905
          	
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
      	  	
        	
    ON CHANGE sel              
        LET g_sel_b = 0          
        CALL g_hray_t.clear()
        CALL g_hray01_t.clear()
        FOR l_i = 1 TO g_rec_b 
          IF g_hray[l_i].sel = 'Y' THEN
            LET g_sel_b = g_sel_b + 1
            LET g_hray_t[g_sel_b].*=g_hray[l_i].*
            LET g_hray01_t[g_sel_b]=g_hray01[l_i]
          END IF 
        END FOR 
        DISPLAY g_sel_b TO FORMONLY.cnt2 
     
     #add by zhangbo130905---begin
     ON ACTION pg2
        LET g_flag="pg2"
        LET g_action_choice="pg2"
        EXIT INPUT
     #add by zhangbo130905---end      
 
     ON ACTION query
         LET g_action_choice="query"
         EXIT INPUT 
 
      ON ACTION ghri012_a
         LET g_action_choice="ghri012_a"
         EXIT INPUT 
      
      ON ACTION ghri012_b
         LET g_action_choice="ghri012_b"
         EXIT INPUT 

      #ON ACTION qry_gd                      #mark by zhangbo130905
      #   LET g_action_choice="qry_gd"       #mark by zhangbo130905
      #   EXIT INPUT                         #mark by zhangbo130905
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT INPUT 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT INPUT 
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT INPUT 
 
 
      ON ACTION cancel
         LET INT_FLAG=TRUE  		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT INPUT 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT INPUT
 
    END INPUT
    CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION 
	
#add by zhangbo130905---begin
FUNCTION i012_b1()
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
 
    INPUT ARRAY g_hray_1 WITHOUT DEFAULTS FROM s_hray_1.*
          ATTRIBUTE (COUNT=g_rec_b_1,MAXCOUNT=g_rec_b_1,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
 
    BEFORE INPUT
       IF g_rec_b_1 != 0 THEN
          CALL fgl_set_arr_curr(l_ac_1)
       END IF		
       DISPLAY g_rec_b_1 TO FORMONLY.cnt1     #add by zhangbo130905     
	
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac_1 = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
      	  	
        	
    ON CHANGE sel_1              
        LET g_sel_b_1 = 0          
        CALL g_hray_1_t.clear()
        CALL g_hray01_1_t.clear()
        FOR l_i = 1 TO g_rec_b_1 
          IF g_hray_1[l_i].sel = 'Y' THEN
            LET g_sel_b_1 = g_sel_b_1 + 1
            LET g_hray_1_t[g_sel_b_1].*=g_hray_1[l_i].*
            LET g_hray01_1_t[g_sel_b_1]=g_hray01_1[l_i]
          END IF 
        END FOR 
        DISPLAY g_sel_b_1 TO FORMONLY.cnt2 
      
      ON ACTION pg1
         LET g_flag="pg1"
         LET g_action_choice="pg1"
         EXIT INPUT  
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT INPUT
      
      ON ACTION ghri012_c
         LET g_action_choice="ghri012_c"
         EXIT INPUT    
 
      #ON ACTION undo_zhuanzheng
      #   LET g_action_choice="undo_zhuanzheng"
      #   EXIT INPUT 
      
      #ON ACTION gui_dang
      #   LET g_action_choice="gui_dang"
      #   EXIT INPUT 

      #ON ACTION qry_gd
      #   LET g_action_choice="qry_gd"
      #   EXIT INPUT         
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT INPUT 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT INPUT 
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT INPUT 
 
 
      ON ACTION cancel
         LET INT_FLAG=TRUE  		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT INPUT 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT INPUT
 
    END INPUT
    CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION
#add by zhangbo130905---end	  
	
FUNCTION i012_b_askkey()
    CLEAR FORM
    CALL g_hray.clear()
    LET g_rec_b=0
    LET g_sel_b=0
 
    cONSTRUCT g_wc2 ON hray01 # ,hray02,hray03,hray04,hray05,hray06,hray07                    
         FROM s_hray[1].hray01 # ,s_hray[1].hray02,s_hray[1].hray03,s_hray[1].hray04,
            #    s_hray[1].hray05,s_hray[1].hray06,s_hray[1].hray07
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hray01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hray01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hray[1].hray01
               NEXT FIELD hray01
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
         
      ON ACTION EXIT
         EXIT CONSTRUCT
      
      ON ACTION CLOSE 
         EXIT CONSTRUCT
         
      ON ACTION cancel 
         EXIT CONSTRUCT
 
    
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrayuser', 'hraygrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    #IF g_flag = 'N' THEN                              #mark by zhangbo130905    
    #  LET g_wc2 = g_wc2 CLIPPED," AND hray10='003'"   #mark by zhangbo130905
    #ELSE                                              #mark by zhangbo130905
    #	LET g_wc2 = g_wc2 CLIPPED," AND hray10='004'"    #mark by zhangbo130905
    #END IF   
    CALL i012_b_fill(g_wc2,g_wc2_1)                    #mod by zhangbo130905
 
END FUNCTION
	
#add by zhangbo130905----begin
FUNCTION i012_b1_askkey()
    CLEAR FORM
    CALL g_hray_1.clear()
    LET g_rec_b_1=0
    LET g_sel_b_1=0
 
   # CONSTRUCT g_wc2_1 ON hray01,hray02,hray03,hray04,hray05,hray06,hray07        
 CONSTRUCT g_wc2_1 ON hray01_1,hray02_1,hray03_1,hray04_1,hray05_1,hray06_1,hray07_1             
         FROM s_hray_1[1].hray01_1,s_hray_1[1].hray02_1,s_hray_1[1].hray03_1,
              s_hray_1[1].hray04_1,s_hray_1[1].hray05_1,s_hray_1[1].hray06_1,
              s_hray_1[1].hray07_1
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hray01_1)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hray01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hray_1[1].hray01_1
               NEXT FIELD hray01_1
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
    LET g_wc2_1 = g_wc2_1 CLIPPED,cl_get_extra_cond('hrayuser', 'hraygrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2_1 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    #IF g_flag = 'N' THEN                              #mark by zhangbo130905    
    #  LET g_wc2 = g_wc2 CLIPPED," AND hray10='003'"   #mark by zhangbo130905
    #ELSE                                              #mark by zhangbo130905
    #	LET g_wc2 = g_wc2 CLIPPED," AND hray10='004'"    #mark by zhangbo130905
    #END IF   
    CALL i012_b_fill(g_wc2,g_wc2_1)                    #mod by zhangbo130905
 
END FUNCTION
#add by zhangbo130905----end		
	
FUNCTION i012_b_fill(p_wc2,p_wc2_1)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
    DEFINE p_wc2_1         STRING             #add by zhangbo130905
      
    LET p_wc2 = cl_replace_str(p_wc2,"hray01","hrat01")
 
       #已转正人员
       LET g_sql = "SELECT 'N',hray01,hrat02,hraa12,hrao02,hras04,hray02,hray03,'',hray04,'',hray05,'',hray06,hray07,'' ",   
                   " FROM hray_file,hraa_file,hrao_file,hrat_file,hras_file",
                   " WHERE ", p_wc2 CLIPPED, 
                   " AND hray01=hratid",
                   #" AND hray10='003' ",
                   " AND hrat19='2001' ",
                   " AND  hrat03=hraa01(+) ",
                   " AND hrat04=hrao01(+) AND hrat05=hras01(+)  ",
                   " AND hray10='003' ",    #add by zhangbo130905
                   " ORDER BY 1" 
 
    PREPARE i012_pb FROM g_sql
    DECLARE hray_curs CURSOR FOR i012_pb
 
    CALL g_hray.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hray_curs INTO g_hray[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        #根据员工ID取员工号
        LET g_hray01[g_cnt]=g_hray[g_cnt].hray01
        SELECT hrat01 INTO g_hray[g_cnt].hray01 FROM hrat_file
         WHERE hratid=g_hray01[g_cnt]
        #转岗部门名称
        SELECT  hrao02 INTO g_hray[g_cnt].zg_part FROM hrao_file
         WHERE hrao01=g_hray[g_cnt].hray03
        #转岗职位名称
        SELECT hras04 INTO g_hray[g_cnt].zg_post FROM hras_file
         WHERE hras01=g_hray[g_cnt].hray04
        #审核人姓名
        SELECT hrat02 INTO g_hray[g_cnt].cf_name FROM hrat_file
         WHERE hrat01=g_hray[g_cnt].hray05
        #审核结果
        SELECT hrag07 INTO g_hray[g_cnt].result FROM hrag_file
         WHERE hrag06=g_hray[g_cnt].hray07
           AND hrag01='102' AND hrag03='01'           
         
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hray.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    LET g_sel_b = 0
    #DISPLAY g_rec_b TO FORMONLY.cnt1     #mark by zhangbo130905
    #DISPLAY g_sel_b TO FORMONLY.cnt2     #mark by zhangbo130905
    LET g_cnt = 0
    
    #add by zhangbo130905----begin
    #已归档人员
       LET g_sql = "SELECT 'N',hray01,hrat02,hraa12,hrao02,hras04,hray02,hray03,'',hray04,'',hray05,'',hray06,hray07,'' ",   
                   " FROM hray_file,hraa_file,hrao_file,hrat_file,hras_file",
                   " WHERE ", p_wc2_1 CLIPPED, 
                   " AND hray01=hratid",
                   #" AND hray10='003' ",
                   " AND hrat19='2001' ",
                   " AND  hrat03=hraa01(+) ",
                   " AND hrat04=hrao01(+) AND hrat05=hras01(+)  ",
                   " AND hray10='004' ",    #add by zhangbo130905
                   " ORDER BY 1" 
 
    PREPARE i012_pb1 FROM g_sql
    DECLARE hray_curs1 CURSOR FOR i012_pb1
 
    CALL g_hray_1.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hray_curs1 INTO g_hray_1[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        #根据员工ID取员工号
        LET g_hray01_1[g_cnt]=g_hray_1[g_cnt].hray01
        SELECT hrat01 INTO g_hray_1[g_cnt].hray01 FROM hrat_file
         WHERE hratid=g_hray01_1[g_cnt]
        #转岗部门名称
        SELECT  hrao02 INTO g_hray_1[g_cnt].zg_part FROM hrao_file
         WHERE hrao01=g_hray_1[g_cnt].hray03
        #转岗职位名称
        SELECT hras04 INTO g_hray_1[g_cnt].zg_post FROM hras_file
         WHERE hras01=g_hray_1[g_cnt].hray04
        #审核人姓名
        SELECT hrat02 INTO g_hray_1[g_cnt].cf_name FROM hrat_file
         WHERE hrat01=g_hray_1[g_cnt].hray05
        #审核结果
        SELECT hrag07 INTO g_hray_1[g_cnt].result FROM hrag_file
         WHERE hrag06=g_hray_1[g_cnt].hray07
           AND hrag01='102' AND hrag03='01'           
         
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hray_1.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b_1 = g_cnt-1
    LET g_sel_b_1 = 0
    #DISPLAY g_rec_b TO FORMONLY.cnt1     #mark by zhangbo130905
    #DISPLAY g_sel_b TO FORMONLY.cnt2     #mark by zhangbo130905
    LET g_cnt = 0
    #add by zhangbo130905----end 
 
END FUNCTION	
	
#撤销转正功能相关逻辑
FUNCTION i012_undo_zz()
   DEFINE  l_i            LIKE type_file.num5
   DEFINE  l_hray09       LIKE hray_file.hray09
   DEFINE  l_hray15       LIKE hray_file.hray15
   DEFINE  l_hray16       LIKE hray_file.hray16
   DEFINE  l_hrat03       LIKE hrat_file.hrat03
   
   LET g_action_choice=NULL    #add by zhangbo130905
   #如果未选取任何资料则退出此函数
   IF g_sel_b = 0 THEN 
    CALL cl_err('','-400',1)
    RETURN 
   END IF 
   IF cl_confirm('ghr-021') THEN
     BEGIN WORK  
     LET g_success = 'Y'
     FOR  l_i = 1 TO g_sel_b
        #取得EF标识
        SELECT hray09 INTO l_hray09 FROM hray_file 
         WHERE hray01=g_hray01_t[l_i]
        #取得原部门，原职位
        SELECT hray15,hray16 INTO l_hray15,l_hray16 FROM hray_file
         WHERE hray01=g_hray01_t[l_i]
        IF cl_null(l_hray15) OR cl_null(l_hray16) THEN 
          CALL cl_err('sel hray15,hray16','ghr-022',1)
          LET g_success = 'N'
          EXIT FOR
        END IF 
        #取得原部门对应的公司 
        SELECT hrao00 INTO l_hrat03 FROM hrao_file
         WHERE hrao01 = l_hray15
        IF cl_null(l_hrat03)  THEN 
          CALL cl_err('sel hrat03','ghr-022',1)
          LET g_success = 'N'
          EXIT FOR
        END IF
        UPDATE hrat_file SET hrat19='1001',            #员工状态-->'1001'
                             hrat03=l_hrat03,          #员工原所属公司
                             hrat04=l_hray15,          #员工原所属部门
                             hrat05=l_hray16           #员工原职位
         WHERE hratid= g_hray01_t[l_i]
        IF SQLCA.sqlcode THEN 
           CALL cl_err('upd hrat_file',SQLCA.sqlcode,1)
           LET g_success ='N'
           EXIT FOR
        END IF 
        #如果EF标识码是'N'，则删除hray_file该笔记录
        IF l_hray09 = 'N' THEN 
           DELETE FROM hray_file WHERE hray01=g_hray01_t[l_i]
           IF SQLCA.sqlcode THEN 
              CALL cl_err('del hray_file',SQLCA.sqlcode,1)
              LET g_success ='N'
              EXIT FOR 
           END IF 
        END IF 
        	  
     END FOR 
     IF g_success ='Y' THEN 
        COMMIT WORK
        #CALL i012_b_fill(" hray10='003'")    #mark by zhangbo130905
        CALL i012_b_fill(g_wc2,g_wc2_1)       #add by zhangbo130905
      ELSE
     	  ROLLBACK WORK
     END IF 
   END IF   
END FUNCTION 
	
#归档功能相关逻辑
FUNCTION i012_guidang()
   DEFINE  l_i            LIKE type_file.num5
   DEFINE  l_msg          LIKE type_file.chr10
   DEFINE  l_wc           STRING

   LET g_action_choice=NULL    #add by zhangbo130905
   #如果未选取任何资料则退出此函数
   IF g_sel_b = 0 THEN 
    CALL cl_err('','-400',1)
    RETURN 
   END IF 
   	
   #IF g_flag = 'N' THEN           #mark by zhangbo130905 
   #   LET l_msg='ghr-023'         #mark by zhangbo130905
   #   LET l_wc = "hray10='003'"   #mark by zhangbo130905
   #ELSE                           #mark by zhangbo130905
   #	  LET l_msg='ghr-035'        #mark by zhangbo130905
   #	  LET l_wc = "hray10='004'"  #mark by zhangbo130905
   #END IF                         #mark by zhangbo130905
   LET l_msg='ghr-023'
   IF cl_confirm(l_msg) THEN
     BEGIN WORK 
     LET g_success='Y'
     FOR l_i=1 TO g_sel_b
      #IF g_flag = 'N' THEN                        #mark by zhangbo130905                             
      #  UPDATE hray_file SET hray10='004'         #mark by zhangbo130905 
      #   WHERE hray01=g_hray01_t[l_i]             #mark by zhangbo130905 
      #ELSE                                        #mark by zhangbo130905 
      #	UPDATE hray_file SET hray10='003'          #mark by zhangbo130905 
      #   WHERE hray01=g_hray01_t[l_i]             #mark by zhangbo130905     
      #END IF                                      #mark by zhangbo130905 
      UPDATE hray_file SET hray10='004'            #add by zhangbo130905 
         WHERE hray01=g_hray01_t[l_i]              #add by zhangbo130905
       IF SQLCA.sqlcode THEN 
          CALL cl_err('upd hray_file',SQLCA.sqlcode,1)
          LET g_success ='N'
          EXIT FOR
       END IF 
     END FOR 
     IF g_success ='Y' THEN 
        COMMIT WORK       
        CALL i012_b_fill(g_wc2,g_wc2_1)
     ELSE
     	  ROLLBACK WORK
     END IF
   END IF 
   
END FUNCTION 
	
#add by zhangbo130905---begin
#归档功能相关逻辑
FUNCTION i012_undo_guidang()
   DEFINE  l_i            LIKE type_file.num5
   DEFINE  l_msg          LIKE type_file.chr10
   DEFINE  l_wc           STRING

   LET g_action_choice=NULL    #add by zhangbo130905
   #如果未选取任何资料则退出此函数
   IF g_sel_b_1 = 0 THEN 
    CALL cl_err('','-400',1)
    RETURN 
   END IF 
   	
   LET l_msg='ghr-035'
   IF cl_confirm(l_msg) THEN
     BEGIN WORK 
     LET g_success='Y'
     FOR l_i=1 TO g_sel_b_1 
      UPDATE hray_file SET hray10='003'           
       WHERE hray01=g_hray01_1_t[l_i]   
       IF SQLCA.sqlcode THEN 
          CALL cl_err('upd hray_file',SQLCA.sqlcode,1)
          LET g_success ='N'
          EXIT FOR
       END IF 
     END FOR 
     IF g_success ='Y' THEN 
        COMMIT WORK       
        CALL i012_b_fill(g_wc2,g_wc2_1)
     ELSE
     	  ROLLBACK WORK
     END IF
   END IF 
   
END FUNCTION
#add by zhangbo130905---end	
