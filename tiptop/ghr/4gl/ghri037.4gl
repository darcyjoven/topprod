# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri037.4gl
# Descriptions...: 员工电子卡维护
# Date & Author..: 13/05/21 by liudong

DATABASE ds
 
GLOBALS "../../config/top.global" 


DEFINE 
     g_hrbw_a       DYNAMIC ARRAY OF RECORD    
        chk         LIKE type_file.chr1,
        hrbw01      LIKE hrbw_file.hrbw01,     #员工ID   
        hrbw01_n    LIKE hrat_file.hrat02,     #员工姓名
        hrat04      LIKE hrat_file.hrat04,     #部门编码
        hrat04_n    LIKE hrao_file.hrao02,     #部门名称
        hrat05      LIKE hrat_file.hrat05,     #职位编码
        hrat05_n    LIKE hras_file.hras04,     #职位名称
        hrbw02      LIKE hrbw_file.hrbw02,     #卡号
        hrbw05      LIKE hrbw_file.hrbw05,     #生效日期
        hrbw06      LIKE hrbw_file.hrbw06,     #失效日期
        hrbw03      LIKE hrbw_file.hrbw03,     #发卡日期
        hrbw04      LIKE hrbw_file.hrbw04,     #发卡人
        hrbw04_n    LIKE hrat_file.hrat02,     #发卡人姓名
        hrbw08      LIKE hrbw_file.hrbw08,     #验证类型
        hrbw09      LIKE hrbw_file.hrbw09,     #考勤机
        hrbw10      LIKE hrbw_file.hrbw10,     #验证密码
        hrbw07      LIKE hrbw_file.hrbw07      #备注        
                    END RECORD,
    g_hrbw_at       RECORD    
        chk         LIKE type_file.chr1,
        hrbw01      LIKE hrbw_file.hrbw01,     #员工ID   
        hrbw01_n    LIKE hrat_file.hrat02,     #员工姓名
        hrat04      LIKE hrat_file.hrat04,     #部门编码
        hrat04_n    LIKE hrao_file.hrao02,     #部门名称
        hrat05      LIKE hrat_file.hrat05,     #职位编码
        hrat05_n    LIKE hras_file.hras04,     #职位名称
        hrbw02      LIKE hrbw_file.hrbw02,     #卡号
        hrbw05      LIKE hrbw_file.hrbw05,     #生效日期
        hrbw06      LIKE hrbw_file.hrbw06,     #失效日期
        hrbw03      LIKE hrbw_file.hrbw03,     #发卡日期
        hrbw04      LIKE hrbw_file.hrbw04,     #发卡人
        hrbw04_n    LIKE hrat_file.hrat02,     #发卡人姓名
        hrbw08      LIKE hrbw_file.hrbw08,     #验证类型
        hrbw09      LIKE hrbw_file.hrbw09,     #考勤机
        hrbw10      LIKE hrbw_file.hrbw10,     #验证密码
        hrbw07      LIKE hrbw_file.hrbw07      #备注    
                    END RECORD,
    g_hrbw_b       DYNAMIC ARRAY OF RECORD    
        chk2        LIKE type_file.chr1,
        hrbw01      LIKE hrbw_file.hrbw01,     #员工ID   
        hrbw01_n1   LIKE hrat_file.hrat02,     #员工姓名
        hrat04      LIKE hrat_file.hrat04,     #部门编码
        hrat04_n1   LIKE hrao_file.hrao02,     #部门名称
        hrat05      LIKE hrat_file.hrat05,     #职位编码
        hrat05_n1   LIKE hras_file.hras04,     #职位名称
        hrbw02      LIKE hrbw_file.hrbw02,     #卡号
        hrbw05      LIKE hrbw_file.hrbw05,     #生效日期
        hrbw06      LIKE hrbw_file.hrbw06,     #失效日期
        hrbw03      LIKE hrbw_file.hrbw03,     #发卡日期
        hrbw04      LIKE hrbw_file.hrbw04,     #发卡人
        hrbw04_n1   LIKE hrat_file.hrat02,     #发卡人姓名
        hrbw07      LIKE hrbw_file.hrbw07      #备注        
                    END RECORD,
    g_hrbw_bt       RECORD    
        chk2        LIKE type_file.chr1,
        hrbw01      LIKE hrbw_file.hrbw01,     #员工ID   
        hrbw01_n1   LIKE hrat_file.hrat02,     #员工姓名
        hrat04      LIKE hrat_file.hrat04,     #部门编码
        hrat04_n1   LIKE hrao_file.hrao02,     #部门名称
        hrat05      LIKE hrat_file.hrat05,     #职位编码
        hrat05_n1   LIKE hras_file.hras04,     #职位名称
        hrbw02      LIKE hrbw_file.hrbw02,     #卡号
        hrbw05      LIKE hrbw_file.hrbw05,     #生效日期
        hrbw06      LIKE hrbw_file.hrbw06,     #失效日期
        hrbw03      LIKE hrbw_file.hrbw03,     #发卡日期
        hrbw04      LIKE hrbw_file.hrbw04,     #发卡人
        hrbw04_n1   LIKE hrat_file.hrat02,     #发卡人姓名
        hrbw07      LIKE hrbw_file.hrbw07      #备注    
                    END RECORD,
    g_wc2           STRING,
    g_wc            STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5, 
    g_rec_b2        LIKE type_file.num5,              
    l_ac            LIKE type_file.num5, 
    l_ac1           LIKE type_file.num5,
    l_ac2           LIKE type_file.num5      
DEFINE g_hrbw       RECORD LIKE hrbw_file.*          #hrbw_file变量组        
DEFINE g_forupd_sql STRING     
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5       
DEFINE g_str        STRING
DEFINE g_flag       LIKE type_file.chr1          #判断页签别
DEFINE g_sel        LIKE type_file.chr1          #判断是否单身更新 
DEFINE g_cancel     LIKE type_file.chr1          #判断是否取消


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
    OPEN WINDOW i037_w AT p_row,p_col WITH FORM "ghr/42f/ghri037"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()
    
    #LET g_forupd_sql = "SELECT hrbw01,hrbw02 ", 
    #                   "  FROM hrbw_file WHERE hrbw01=? AND hrbw02=?  FOR UPDATE"
    #LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    #DECLARE i037_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    
    #mark by liudong 程序开始不直接显示数据  
    #LET g_flag='1'
    #LET g_wc  = "1=1"
    #CALL i037_b_fill()
    #end  by liudong 
    CALL i037_menu()
    CLOSE WINDOW i037_w                 
      CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i037_menu()
 
   WHILE TRUE
      CALL i037_bp()
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               LET g_flag='1'                
               CALL i037_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "detail"
            IF cl_chk_act_auth() THEN                
               LET g_sel='N'
               CALL i037_b()
               CALL i037_b_fill()
            END IF 
         WHEN "ghri037_a"
            IF cl_chk_act_auth() THEN                
               CALL i037_opencard('1')
               CALL i037_b_fill()
            END IF 
         WHEN "ghri037_b"
            IF cl_chk_act_auth() THEN               
               CALL i037_opencard('2')
               CALL i037_b_fill()
            END IF
         WHEN "ghri037_c"
            IF cl_chk_act_auth() THEN               
               CALL i037_batch('1')   
               CALL i037_b_fill()
            END IF   
         WHEN "ghri037_d"
            IF cl_chk_act_auth() THEN               
               CALL i037_batch('2')   
               CALL i037_b_fill()
            END IF
          WHEN "ghri037_e"
            IF cl_chk_act_auth() THEN               
               CALL i037_tongbu()   
               CALL i037_b_fill()
            END IF

         WHEN "ghri037_f"
            IF cl_chk_act_auth() THEN
                 LET l_ac = ARR_CURR()
               CALL i037_fingerprint(g_hrbw_a[l_ac].hrbw01)
#               CALL i037_b_fill()
            END IF

         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CASE g_flag
                WHEN "1"   CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbw_a),'','')
                WHEN "2"   CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbw_b),'','')  
              END CASE 
            END IF
 
      END CASE
   END WHILE
END FUNCTION

FUNCTION i037_q()
   CALL i037_b_askkey()
END FUNCTION
	
FUNCTION i037_bp()
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
    
  DIALOG ATTRIBUTES(UNBUFFERED)
    #已发卡人员页签
    DISPLAY ARRAY g_hrbw_a  TO s_hrbw_a.*
          ATTRIBUTE (COUNT=g_rec_b)
 
    BEFORE DISPLAY
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF		
         	  	        	
    END DISPLAY 
    #已注销人员页签
    DISPLAY ARRAY g_hrbw_b TO s_hrbw_b.*
          ATTRIBUTE (COUNT=g_rec_b2)
 
    BEFORE DISPLAY
       IF g_rec_b2 != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF		
         	  	        	
    END DISPLAY
    
     ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG  
     ON ACTION detail
         LET g_action_choice="detail"
         EXIT DIALOG
 
      ON ACTION page1
         LET g_flag='1'
         DISPLAY g_rec_b  TO FORMONLY.cnt1  
               
      ON ACTION page2
         LET g_flag='2'
         DISPLAY g_rec_b2 TO FORMONLY.cnt1
         
      ON ACTION ghri037_a                       #开卡
         LET g_action_choice="ghri037_a"
         EXIT DIALOG           
      
      ON ACTION ghri037_b                          #重新开卡
         LET g_action_choice="ghri037_b"
         EXIT DIALOG 
         
      ON ACTION ghri037_c                          #批量注销
         LET g_action_choice="ghri037_c"
         EXIT DIALOG   
         
      ON ACTION ghri037_d                         #批量注销
         LET g_action_choice="ghri037_d"
         EXIT DIALOG
      ON ACTION ghri037_e                           #同步员工
         LET g_action_choice="ghri037_e"
         EXIT DIALOG
      ON ACTION ghri037_f
         LET g_action_choice="ghri037_f"
         EXIT DIALOG
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG  
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG 
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DIALOG 
 
 
      ON ACTION cancel
         LET INT_FLAG=TRUE  		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
  END DIALOG
    CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION   
	
FUNCTION i037_b_askkey()
    CLEAR FORM
    CALL g_hrbw_a.clear()
    CALL g_hrbw_b.clear()
    LET g_rec_b=0
    LET g_rec_b2=0
 
   DIALOG ATTRIBUTE(UNBUFFERED)
    #页签一
    CONSTRUCT g_wc ON hrbw01,hrbw02,hrbw03,hrbw04,hrbw05,hrbw06,hrbw08,hrbw09,hrbw07                    
         FROM s_hrbw_a[1].hrbw01,s_hrbw_a[1].hrbw02,s_hrbw_a[1].hrbw03,s_hrbw_a[1].hrbw04,
              s_hrbw_a[1].hrbw05,s_hrbw_a[1].hrbw06,s_hrbw_a[1].hrbw08,s_hrbw_a[1].hrbw09,
              s_hrbw_a[1].hrbw07
              
      BEFORE CONSTRUCT 
         CALL cl_set_act_visible("accept,cancel", TRUE)
 
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrbw01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrbw01"     #需新增
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrbw_a[1].hrbw01
               NEXT FIELD hrbw01
            WHEN INFIELD(hrbw04)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrbw03"     #需新增
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrbw_a[1].hrbw04
               NEXT FIELD hrbw04
            WHEN INFIELD(hrbw09)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrbv01"     #需新增
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrbw_a[1].hrbw09
               NEXT FIELD hrbw09
         OTHERWISE
              EXIT CASE
         END CASE
     END CONSTRUCT 
     {
     #页签二
     CONSTRUCT g_wc2 ON hrbw01,hrbw02,hrbw03,hrbw04,hrbw05,hrbw06,hrbw07                    
         FROM s_hrbw_b[1].hrbw01,s_hrbw_b[1].hrbw02,s_hrbw_b[1].hrbw03,s_hrbw_b[1].hrbw04,
              s_hrbw_b[1].hrbw05,s_hrbw_b[1].hrbw06,s_hrbw_b[1].hrbw07
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrbw01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrbw01"     #需新增
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrbw_b[1].hrbw01
               NEXT FIELD hrbw01
            WHEN INFIELD(hrbw04)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat04"     #需新增
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrbw_b[1].hrbw04
               NEXT FIELD hrbw04
         OTHERWISE
              EXIT CASE
         END CASE
     END CONSTRUCT
     }
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DIALOG
        
      ON ACTION page1
         LET g_flag='1'
         
      ON ACTION page2
         LET g_flag='2'
         
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION EXIT 
         LET INT_FLAG=1
         EXIT DIALOG
         
       ON ACTION accept
         LET INT_FLAG=0
         EXIT DIALOG
         
      ON ACTION cancel
         LET INT_FLAG=1
         EXIT DIALOG
         
       
    END DIALOG
    LET g_wc  = g_wc  CLIPPED,cl_get_extra_cond('hrbwuser', 'hrbwgrup') #FUN-980030
    #LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrbwuser', 'hrbwgrup')
     CALL cl_replace_str(g_wc,'hrbw01','a.hrat01') RETURNING g_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc  = "1=1"
      #LET g_wc2 = "1=1"
      RETURN
   END IF

    CALL i037_b_fill()
 
END FUNCTION	
	
FUNCTION i037_b_fill()              #BODY FILL UP
 
    DEFINE l_hratid      LIKE hrat_file.hratid
    DEFINE l_count       LIKE type_file.num10            #add by liudong 新增进度条
    DEFINE l_gcnt        LIKE type_file.num10
    DEFINE l_pbar        LIKE type_file.num10            #add by liudong 新增进度条
    
    LET l_count = 0
    LET g_sql = "SELECT count(*) ",   
                " FROM hrbw_file,hrat_file",
                " WHERE ", g_wc CLIPPED, 
                " AND hrbw01=hratid",
                " AND hrbwacti='Y' "
               # " AND hrat04=hrao01(+) AND hrat05=hras01(+)  ",
               # " ORDER BY 1" 
                
    PREPARE i037_c_pb FROM g_sql
    #DECLARE hrbw_c_curs CURSOR FOR i037_c_pb
    EXECUTE i037_c_pb INTO l_count
    IF cl_null(l_count) THEN LET l_count = 0 END IF 
    IF l_count > g_max_rec THEN 
      LET l_count = g_max_rec      
    END IF 
    CALL cl_set_comp_visible("pbar",TRUE)
    
    #已发卡人员   
    LET g_sql = "SELECT 'N',a.hrat01,a.hrat02,a.hrat04,hrao02,a.hrat05,hras04,hrbw02,hrbw05,hrbw06,hrbw03,hrbw04,b.hrat02,hrbw08,hrbw09,hrbw10,hrbw07 ",   
                " FROM hrbw_file,hrat_file a,hrao_file,hras_file,hrat_file b",
                " WHERE ", g_wc CLIPPED, 
                " AND hrbw01=a.hratid",
                " AND hrbwacti='Y' ",
                " AND a.hrat04=hrao01(+) AND a.hrat05=hras01(+)  ",
                " AND hrbw04=b.hrat01(+) ",
                " ORDER BY 2" 
 
    PREPARE i037_a_pb FROM g_sql
    DECLARE hrbw_a_curs CURSOR FOR i037_a_pb
 
    CALL g_hrbw_a.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrbw_a_curs INTO g_hrbw_a[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
       
        
        LET l_pbar = g_cnt*100 / l_count            #add by liudong 新增进度条
        DISPLAY l_pbar TO pbar
        DISPLAY l_pbar TO cnt1
        CALL ui.Interface.refresh()
        
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrbw_a.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    LET l_gcnt = g_cnt                        #add by liudong 新增进度条
    
    #已注销人员   
    LET g_sql = "SELECT 'N',a.hrat01,a.hrat02,a.hrat04,hrao02,a.hrat05,hras04,hrbw02,hrbw05,hrbw06,hrbw03,hrbw04,b.hrat02,hrbw07 ",   
                " FROM hrbw_file,hrat_file a,hrao_file,hras_file,hrat_file b",
                " WHERE ", g_wc CLIPPED, 
                " AND hrbw01=a.hratid",
                " AND hrbwacti='N' ",
                " AND a.hrat04=hrao01(+) AND a.hrat05=hras01(+)  ",
                " AND hrbw04=b.hrat01(+) ",
                " ORDER BY 2" 

 
    PREPARE i037_b_pb FROM g_sql
    DECLARE hrbw_b_curs CURSOR FOR i037_b_pb
 
    CALL g_hrbw_b.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrbw_b_curs INTO g_hrbw_b[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF

         
        LET l_pbar = (l_gcnt+g_cnt)*100/l_count   #add by liudong 新增进度条
        DISPLAY l_pbar TO pbar
        DISPLAY l_pbar TO cnt1
        CALL ui.Interface.refresh()
         
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrbw_b.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    
    CALL cl_set_comp_visible("pbar",FALSE)
   
    DISPLAY g_rec_b TO FORMONLY.cnt1 
 
END FUNCTION	
#开卡/重新开卡
FUNCTION i037_opencard(p_open)
   DEFINE   p_open       LIKE type_file.chr1      #1.开卡；2.重新开卡
   DEFINE   l_bno        LIKE hrbw_file.hrbw02    #起始卡号
   DEFINE   l_eno        LIKE hrbw_file.hrbw02    #截止卡号
   DEFINE   l_bdate      LIKE type_file.dat       #生效日期
   DEFINE   l_xno        LIKE hrbw_file.hrbw02    #递增中间卡号
   DEFINE   l_fno        LIKE type_file.num10     #递增流水号
   DEFINE   l_hrat01_c   LIKE hrat_file.hrat01    #工号
   DEFINE   l_wc         STRING                   
   DEFINE   l_str        STRING                   #解析卡号前缀与流水码
   DEFINE   l_str1       STRING                   #
   DEFINE   l_str2       STRING                   #
   DEFINE   ls_buff      base.StringBuffer        #解析卡号前缀与流水码
   DEFINE   l_sql        STRING
   DEFINE   ls_format    STRING
   DEFINE   l_i,l_n,l_k  LIKE type_file.num5      #计数变量-循环使用
   DEFINE   l_exno       LIKE type_file.num5      #前缀长度
   DEFINE   l_cnt1       LIKE type_file.num5      #左边单身数据长度
   DEFINE   l_cnt2       LIKE type_file.num5      #右边单身数组长度
   DEFINE   l_s1,l_s2    LIKE type_file.num5      #左右单身选取数量
   DEFINE   l_hratid     DYNAMIC ARRAY OF LIKE hrat_file.hratid #左边单身KEY值变量-员工ID 
   DEFINE   r_hratid     DYNAMIC ARRAY OF LIKE hrat_file.hratid #右边单身KEY值变量-员工ID
   DEFINE   l_hratid_o   DYNAMIC ARRAY OF LIKE hrat_file.hratid #左边单身选取KEY值变量
   DEFINE   r_hratid_o   DYNAMIC ARRAY OF LIKE hrat_file.hratid #右边单身选取KEY值变量 
   DEFINE   r_hratid_t   LIKE hrat_file.hratid                  #右边单身选取KEY值变量 -上下位移中间变量
   DEFINE   l_showerr    DYNAMIC ARRAY OF RECORD                #错误信息记录
                err01    LIKE hrat_file.hrat01,
                err02    LIKE hrat_file.hrat02,
                err03    LIKE hrbw_file.hrbw02,
                err04    LIKE type_file.chr20,
                err05    LIKE ze_file.ze03
                         END RECORD 
   DEFINE   r_hrat       DYNAMIC ARRAY OF RECORD  #左边单身数据变量组
              sel        LIKE type_file.chr1,
              hrbw02     LIKE hrbw_file.hrbw02,   #电子卡号
              hrat01     LIKE hrat_file.hrat01,   #工号
              hrat02     LIKE hrat_file.hrat02    #姓名
                         END RECORD 
   DEFINE   r_hrbw       DYNAMIC ARRAY OF RECORD  #左边单身数据变量组
              sel_1      LIKE type_file.chr1,
              hrbw02_1   LIKE hrbw_file.hrbw02,   #电子卡号
              hrat01_1   LIKE hrat_file.hrat01,   #工号
              hrat02_1   LIKE hrat_file.hrat02   #姓名
                         END RECORD         
   DEFINE   r_hrat_o     DYNAMIC ARRAY OF RECORD  #左边单身选取数据变量组-点选右移功能后清空
              sel        LIKE type_file.chr1,
              hrbw02     LIKE hrbw_file.hrbw02,   #电子卡号
              hrat01     LIKE hrat_file.hrat01,   #工号
              hrat02     LIKE hrat_file.hrat02    #姓名
                         END RECORD
   DEFINE   r_hrbw_o     DYNAMIC ARRAY OF RECORD  #右边单身选取数据变量组-点选左移功能后清空
              sel_1      LIKE type_file.chr1,
              hrbw02_1   LIKE hrbw_file.hrbw02,   #电子卡号
              hrat01_1   LIKE hrat_file.hrat01,   #工号
              hrat02_1   LIKE hrat_file.hrat02    #姓名
                         END RECORD
   DEFINE   r_hrbw_t     RECORD                   #上下位移中间数组
              sel_1      LIKE type_file.chr1,
              hrbw02_1   LIKE hrbw_file.hrbw02,   #电子卡号
              hrat01_1   LIKE hrat_file.hrat01,   #工号
              hrat02_1   LIKE hrat_file.hrat02    #姓名
                         END RECORD
                         
             IF p_open='2' AND g_rec_b=0 THEN   #如果已开卡人员为空,则不可执行重新开卡功能
                CALL cl_err('','ghr-083',1)  
                RETURN 
             END IF 
            
             OPEN WINDOW i037_w1  WITH FORM "ghr/42f/ghri037_1"
               ATTRIBUTE (STYLE = g_win_style CLIPPED)
               
             CALL cl_ui_locale("ghri037_1")
             
             CALL cl_set_label_justify("i037_w1","right")  
          
           #定义INSERT&UPDATE的SQL
           LET l_sql = " INSERT INTO hrbw_file ",
                       " VALUES(?,?,?,?,?,?,?,?,?",
                       "        ?,?,?,?,?,?,?,?,?,?,",
                       "        ?,?,?,?,?,?,?,?,?,?,  ",
                       "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?) "
           PREPARE i037_insert FROM l_sql
           
           


           DIALOG ATTRIBUTES(UNBUFFERED)  
             #输入起止卡号,查询
             INPUT l_bno,l_eno,l_bdate  FROM FORMONLY.bcardno,FORMONLY.ecardno,FORMONLY.bdate
              
                 BEFORE INPUT 
                    CALL cl_set_act_visible("accept,cancel", TRUE)
                    LET l_bdate = g_today 
                    NEXT FIELD bcardno
                              
                 AFTER FIELD bcardno
                      #检查改卡号是否已经匹配,若匹配则跳过。
                      IF p_open = '1' THEN 
              	         LET l_k = 0
              	         SELECT COUNT(*) INTO l_k FROM hrbw_file
              	          WHERE hrbw02=l_bno AND hrbwacti = 'Y'
              	         IF l_k > 0 THEN 
              	           CALL cl_err(l_bno,'ghr-084',0)               #如果开始卡号重复,则提示重新输入
              	           NEXT FIELD  bcardno
              	         END IF 
              	      END IF        
                 
                 BEFORE FIELD ecardno                    
                    IF NOT cl_null(l_bno) THEN 
                      #检查改卡号是否已经匹配,若匹配则跳过。
                      IF p_open = '1' THEN 
              	         LET l_k = 0
              	         SELECT COUNT(*) INTO l_k FROM hrbw_file
              	          WHERE hrbw02=l_xno AND hrbwacti = 'Y'
              	         IF l_k > 0 THEN 
              	           CALL cl_err(l_bno,'ghr-084',0)               #如果开始卡号重复,则提示重新输入
              	           NEXT FIELD  bcardno
              	         END IF 
              	      END IF 
                      LET l_exno = 0 
                      #开始解析前缀
                      LET ls_buff=base.StringBuffer.create()
                      CALL ls_buff.append(l_bno CLIPPED)
                      LET l_i = ls_buff.getLength()                #抓取开始卡号长度
                      FOR l_n = 0 TO l_i                         
                        LET l_str = ls_buff.getCharAt(l_i-l_n)     #从最后一位开始判断是否为流水码
                        IF l_str NOT MATCHES '[0123456789]' THEN   #是否为数字流水码
                           IF l_n < 3 THEN                         #如最后三码为非流水码-则报错提示-至少保留三位流水码
                             CALL cl_err(l_bno,'ghr-085',1)     
                             NEXT FIELD bcardno   
                           ELSE                                    #如果当前码为非流水码-则认为从此码起至第一码都为前缀
                           	 LET l_exno=l_i-l_n
                           	 EXIT FOR  
                           END IF 
                        END IF 
                      END FOR 
                      #根据前缀长度截取前缀
                      LET l_str = ls_buff.subString(1,l_exno)
                      LET l_eno = l_str CLIPPED
                      DISPLAY l_eno TO FORMONLY.ecardno
                    END IF               
                    
                 AFTER INPUT                  
                    #检查改卡号是否已经匹配,若匹配则跳过。
                      IF p_open = '1' THEN 
              	         LET l_k = 0
              	         SELECT COUNT(*) INTO l_k FROM hrbw_file
              	          WHERE hrbw02=l_bno AND hrbwacti = 'Y'
              	         IF l_k > 0 THEN 
              	           CALL cl_err(l_bno,'ghr-084',0)               #如果开始卡号重复,则提示重新输入
              	           NEXT FIELD  bcardno
              	         END IF 
              	      END IF                               
                    IF NOT cl_null(l_eno) THEN 
                       LET l_str1 =  l_eno
                       LET l_n = l_str1.getLength()   #抓取结束卡号长度
                       IF l_i <> l_n THEN             #如果起止卡号长度不一致则报错提示
                         CALL cl_err('','ghr-086',1)
                         NEXT FIELD ecardno
                       END IF      
                       IF l_eno < l_bno THEN          #如果结束卡号小于开始卡号则报错提示
                         CALL cl_err('','ghr-087',1)
                         NEXT FIELD ecardno
                       END IF 
                       LET l_str2=l_str1.subString(1,l_exno)
                       IF l_str <> l_str2 THEN        #判断开始和结束卡号的前缀是否一致
                         CALL cl_err('','ghr-088',1)
                         NEXT FIELD ecardno
                       END IF 
                       #判断流水码中是否有字母或特殊字符
                       CALL ls_buff.clear()
                       CALL ls_buff.append(l_eno CLIPPED)
                       FOR l_i = l_exno+1 TO ls_buff.getLength()
                         LET l_str1 = ls_buff.getCharAt(l_i)
                         IF l_str1 NOT MATCHES '[0123456789]' THEN 
                            CALL cl_err(l_eno,'ghr-089',1)
                            NEXT FIELD ecardno
                         END IF 
                       END FOR
                    END IF  
             
             END INPUT 
             
             #工号查询
             CONSTRUCT l_wc ON hrat01 FROM FORMONLY.hrat01_c
             
             END CONSTRUCT 
             
             ON ACTION controlp
               CASE 
                  WHEN INFIELD(hrat01_c)
                    CALL cl_init_qry_var()
                    IF p_open='1' THEN 
                      LET g_qryparam.form  = "q_hrat01"
                    ELSE 
                    	LET g_qryparam.form  = "q_hrbw01"
                    END IF 
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO hrat01_c                   
                    NEXT FIELD hrat01_c
               END CASE
             ON ACTION EXIT
               LET INT_FLAG=TRUE
               EXIT DIALOG 
           
             ON ACTION controlg 
                CALL cl_cmdask()
           
             ON ACTION accept
                IF cl_null(l_bno) OR cl_null(l_eno) THEN
                   CALL cl_err('','ghr-090',1)    #如果l_wc为空,则提示需录入条件
                   CONTINUE DIALOG 
                END IF
                IF cl_null(l_wc) THEN 
                   CALL cl_err('','ghr-090',1)    #如果l_wc为空,则提示需录入条件
                   CONTINUE DIALOG
                END IF
                LET INT_FLAG=FALSE   		#MOD-570244	mars
                EXIT DIALOG 
           
             ON ACTION cancel
                LET INT_FLAG=TRUE  		#MOD-570244	mars
                EXIT DIALOG 
           
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE DIALOG 
           
             ON ACTION about         #MOD-4C0121
                CALL cl_about()      #MOD-4C0121
                
             AFTER DIALOG
                IF cl_null(l_bno) OR cl_null(l_eno) THEN
                   CALL cl_err('','ghr-090',1)    #如果l_wc为空,则提示需录入条件
                   CONTINUE DIALOG 
                END IF
                IF cl_null(l_wc) THEN 
                   CALL cl_err('','ghr-090',1)    #如果l_wc为空,则提示需录入条件
                   CONTINUE DIALOG
                END IF 
           END DIALOG
           IF INT_FLAG THEN 
             LET INT_FLAG=FALSE
             LET l_bno=null
             LET l_eno=null
             LET l_hrat01_c=null
             CLOSE WINDOW i037_w1
             RETURN 
           END IF
           
           
           #开始填充左右单身数据
           #左边单身根据l_wc条件从hrat_file中查询,排除hrbw_file中已经有效开卡的员工资料
           IF p_open = '1' THEN 
             LET l_sql = " SELECT 'N','',hrat01,hrat02,hratid FROM hrat_file ",
                         " WHERE ",l_wc CLIPPED ,
                         " AND hratid not in (select hrbw01 from hrbw_file where hrbwacti='Y') ",
                         " AND hratacti = 'Y' ",
                         " ORDER BY hrat01 "
           ELSE 
           	 LET l_wc = cl_replace_str(l_wc,"hrat01","hrbw01")
           	 LET l_sql = " SELECT 'N',hrbw02,hrat01,hrat02,hrbw01 FROM hrbw_file,hrat_file ",
                         " WHERE ",l_wc CLIPPED ,
                         " AND hrbw01=hratid ",
                         " AND hratacti = 'Y' ",
                         " AND hrbwacti = 'Y' ",
                         " ORDER BY hrbw02 "
           END IF 
                       
           PREPARE i037_open_pre FROM l_sql
           DECLARE i037_open_cs CURSOR FOR i037_open_pre
           
           LET l_cnt1 = 1
           FOREACH i037_open_cs INTO r_hrat[l_cnt1].*,l_hratid[l_cnt1]
              IF SQLCA.sqlcode THEN 
                 CALL cl_err('i037_open_cs',SQLCA.sqlcode,1)
                 EXIT FOREACH 
              END IF 
              LET l_cnt1 = l_cnt1 + 1
           END FOREACH 
           CALL r_hrat.deleteElement(l_cnt1)
           LET l_cnt1 = l_cnt1 - 1
           #右边单身从开始卡号展开到结束卡号
           LET l_n = 1
           LET l_str  = l_bno 
           LET l_str1 = l_str.subString(1,l_exno)         #前缀
           LET l_str2 = l_str.subString(l_exno+1,l_str.getLength())  #流水
           #组format
           LET ls_format = ''
           FOR l_i = 1 TO l_str2.getLength()
              LET ls_format = ls_format,"&"
           END FOR 
           LET l_fno = l_str.subString(l_exno+1,l_str.getLength()) 
           WHILE TRUE 
                LET r_hrbw[l_n].sel_1   = 'N'
                LET r_hrbw[l_n].hrat01_1  = NULL 
                LET r_hrbw[l_n].hrat02_1  = NULL                 
              IF l_n = 1 THEN                                 #如果为1,则将起始卡号写入数组
                LET r_hrbw[l_n].hrbw02_1  = l_bno
              ELSE 
              	LET l_fno = l_fno+1 
                LET l_str2= l_fno USING ls_format
              	LET l_xno = l_str1,l_str2                     #累加卡号
              	#新开卡时检查改卡号是否已经匹配,若匹配则跳过。
                IF p_open = '1' THEN 
              	  LET l_k = 0
              	  SELECT COUNT(*) INTO l_k FROM hrbw_file
              	   WHERE hrbw02=l_xno AND hrbwacti = 'Y'
              	  IF l_k > 0 THEN CONTINUE WHILE END IF 
              	END IF   
              	IF l_xno < l_eno THEN                         #如果当前累加卡号小于结束卡号,则将累加卡号写入数组
              	  LET r_hrbw[l_n].hrbw02_1 = l_xno
              	ELSE                                          #如果当前累加卡号大于或等于结束卡号,则将结束卡号写入数组,同时结束循环 
              		LET r_hrbw[l_n].hrbw02_1 = l_eno
              		EXIT WHILE 
              	END IF 
              END IF 
              LET l_n = l_n + 1   
           END WHILE 
           LET l_cnt2 = l_n 
           
           
           
           #将左右两数组数据显示在单身
           DIALOG ATTRIBUTES(UNBUFFERED)
                
             INPUT ARRAY r_hrat  FROM s_hrat.*
                 ATTRIBUTE (COUNT=l_cnt1,MAXCOUNT=l_cnt1, 
                        INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
                        
                 BEFORE INPUT
                    CALL cl_set_act_visible("accept,cancel", FALSE)
                    IF l_ac1 != 0 THEN 
                      CALL fgl_set_arr_curr(l_ac1)
                    END IF	
                    
                    	
                 BEFORE ROW
                     LET l_ac1 = ARR_CURR()
                     CALL fgl_set_arr_curr(l_ac1)
                 
                 ON CHANGE sel              
                     LET l_s1 = 0          
                     FOR l_i = 1 TO l_cnt1 
                       IF r_hrat[l_i].sel = 'Y' THEN
                         LET l_s1 = l_s1 + 1
                         LET r_hrat_o[l_s1].* = r_hrat[l_i].*     #组选取数组存入r_hrat_o
                         LET l_hratid_o[l_s1] = l_hratid[l_i]     #key值存储
                       END IF 
                     END FOR 
                     CALL r_hrat.deleteElement(l_i)
                     #判断是否执行过右移,重新统计右边空余卡号数量
                     LET l_n = 0
                     FOR l_i = 1 TO l_cnt2
                       IF cl_null(r_hrbw[l_i].hrat01_1) THEN 
                          LET l_n = l_n + 1
                       END IF 
                     END FOR 
                     IF l_s1 > l_n THEN    #如果选择的员工大于了卡号数量,则提示不可匹配卡号
                        CALL cl_err(l_s1,'ghr-091',0)
                        LET r_hrat[l_ac1].sel = 'N'
                        LET l_s1 = l_s1 - 1
                        NEXT FIELD sel
                     END IF   	
                     DISPLAY l_s1 TO FORMONLY.cn1
             END INPUT              
             INPUT ARRAY r_hrbw  FROM s_hrbw.*
                 ATTRIBUTE (COUNT=l_cnt2,MAXCOUNT=l_cnt2, 
                        INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
                 BEFORE INPUT
                    CALL cl_set_act_visible("accept,cancel", FALSE)
                    IF l_ac2 != 0 THEN 
                      CALL fgl_set_arr_curr(l_ac2)
                    END IF 	

                    	
                 BEFORE ROW
                     LET l_ac2 = ARR_CURR()
                     CALL fgl_set_arr_curr(l_ac2)
                 
                 ON CHANGE sel_1   
                     IF cl_null(r_hrbw[l_ac2].hrat01_1) THEN
                          CALL cl_err('','ghr-092',0)          #没有匹配卡号的资料不能选取 
                          LET r_hrbw[l_ac2].sel_1 = 'N'
                          CONTINUE DIALOG
                     END IF            
                     LET l_s2 = 0          
                     FOR l_i = 1 TO l_cnt2                       
                       IF r_hrbw[l_i].sel_1 = 'Y' THEN
                         LET l_s2 = l_s2 + 1
                         LET r_hrbw_o[l_s2].* = r_hrbw[l_i].*        #记录左移数据
                         LET r_hratid_o[l_s2] = r_hratid[l_i]
                       END IF 
                     END FOR 
                     CALL r_hrbw.deleteElement(l_i)   
                     DISPLAY l_s2 TO FORMONLY.cn2                 
             END INPUT
             
             ON ACTION HELP
                CALL cl_show_help()
            
             ON ACTION locale
                CALL cl_dynamic_locale()
                CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            
             ON ACTION EXIT
                IF cl_confirm('ghr-093') THEN   #提示未完成匹配,是否要退出 
                  LET INT_FLAG=TRUE   
                  EXIT DIALOG
                ELSE 
                	CONTINUE DIALOG       
                END IF                            
            
             ON ACTION controlg 
                CALL cl_cmdask()
                        
             ON ACTION cancel
                IF cl_confirm('ghr-093') THEN   #提示未完成匹配,是否要退出 
                  LET INT_FLAG=TRUE   
                  EXIT DIALOG
                ELSE 
                	CONTINUE DIALOG       
                END IF  
             #数据右移
             ON ACTION moveright
                #处理前重新抓取选取数组
                LET l_s1 = 0          
                FOR l_i = 1 TO l_cnt1 
                  IF r_hrat[l_i].sel = 'Y' THEN
                    LET l_s1 = l_s1 + 1
                    LET r_hrat_o[l_s1].* = r_hrat[l_i].*     #组选取数组存入r_hrat_o
                    LET l_hratid_o[l_s1] = l_hratid[l_i]     #key值存储
                  END IF 
                END FOR 
                CALL r_hrat.deleteElement(l_i)
                #开始处理
                IF l_s1 = 0 THEN 
                  CALL cl_err('','ghr-094',0)   #未选取需右移的资料
                  CONTINUE DIALOG
                ELSE
                	#进行数据右移处理
                	FOR l_i = 1 TO l_s1           #
                	  FOR l_n = 1 TO l_cnt2 
                	    IF cl_null(r_hrbw[l_n].hrat01_1) THEN 
                	      LET r_hrbw[l_n].sel_1 = 'N'
                	      LET r_hrbw[l_n].hrat01_1 = r_hrat_o[l_i].hrat01
                	      LET r_hrbw[l_n].hrat02_1 = r_hrat_o[l_i].hrat02
                	      LET r_hratid[l_n] = l_hratid_o[l_i]
                	      EXIT FOR 
                	    END IF 
                	  END FOR 
                	END FOR 
                	LET l_s2 = 0
                	#从原数组中删除已右移数据
                	LET l_s1 = 0
                	CALL r_hrat_o.clear()
                	FOR l_i = 1 TO l_cnt1 
                	  IF r_hrat[l_i].sel = 'N' THEN
                	     LET l_s1 = l_s1 + 1
                	     LET r_hrat_o[l_s1].* = r_hrat[l_i].*
                	  END IF 
                	END FOR
                	CALL r_hrat.clear()
                	FOR l_i = 1 TO l_s1 
                	   LET r_hrat[l_i].* = r_hrat_o[l_i].*               	   
                	END FOR  
                	LET l_cnt1 = l_s1
                	LET l_s1 = 0
                	DISPLAY l_s1 TO cn1
                	DISPLAY l_s2 TO cn2
                	CALL ui.Interface.refresh() 
                	CONTINUE DIALOG
                END IF 
             #数据左移   
             ON ACTION moveleft
                #开始处理前重新选择数组
                LET l_s2 = 0          
                FOR l_i = 1 TO l_cnt2                       
                  IF r_hrbw[l_i].sel_1 = 'Y' THEN
                    LET l_s2 = l_s2 + 1
                    LET r_hrbw_o[l_s2].* = r_hrbw[l_i].*        #记录左移数据
                    LET r_hratid_o[l_s2] = r_hratid[l_i]
                  END IF 
                END FOR 
                CALL r_hrbw.deleteElement(l_i)   
                #开始处理
                IF l_s2 = 0 THEN                #未选择数据则不处理
                  CALL cl_err('','ghr-094',0)   
                  CONTINUE DIALOG
                ELSE
                	#进行数据左移处理
                	FOR l_i = 1 TO l_s2
                	  LET l_cnt1 = l_cnt1 + 1
                	  LET r_hrat[l_cnt1].* = r_hrbw_o[l_i].*
                	  LET r_hrat[l_cnt1].hrbw02 = ''
                	  LET r_hrat[l_cnt1].sel = 'N'
                	  LET r_hratid[l_cnt1]   = r_hratid_o[l_i]
                	  IF p_open = '2' THEN   #如果是重新发卡,则需还原旧卡号
                	    SELECT hrbw02 INTO r_hrat[l_cnt1].hrbw02 FROM hrbw_file
                	     WHERE  hrbw01=r_hratid[l_cnt1]
                	  END IF                	   
                	END FOR 
                	#清除左边选取的工号和姓名
                	FOR l_i = 1 TO l_cnt2
                	   IF r_hrbw[l_i].sel_1 = 'Y' THEN
                	      LET  r_hrbw[l_i].sel_1 = 'N'
                        LET  r_hrbw[l_i].hrat01_1 = ''
                        LET  r_hrbw[l_i].hrat02_1 = ''
                     END IF 
                  END FOR
                  LET l_s1 = 0
                  LET l_s2 = 0  
                  DISPLAY l_s1 TO cn1
                	DISPLAY l_s2 TO cn2
                	CALL ui.Interface.refresh() 
                	CONTINUE DIALOG 
                END IF 
                
             #数据上移-仅针对右侧匹配数据进行调整   
             ON ACTION moveup
                IF l_s2 = 0 THEN                #未选择数据则不处理
                  CALL cl_err('','ghr-095',0)   
                  CONTINUE DIALOG
                ELSE
                	 #根据选取的数组进行循环
                	 LET l_k = 2
                	 FOR l_i = 1 TO l_s2 
                	   FOR l_n = l_k TO l_cnt2
                	      IF r_hrbw_o[l_i].hrbw02_1 = l_bno  THEN    #如果第一笔也选择了,则不作处理
                	         EXIT FOR 
                	      ELSE       
                	      	IF r_hrbw[l_n].sel_1 = 'Y' THEN 
                	      	  IF r_hrbw[l_n-1].sel_1 = 'Y' THEN  #从第二笔开始,如果上一笔已经选择了,则也不进行处理
                	      	    LET l_k = l_k + 1
                	      	    EXIT FOR 
                	      	  ELSE
                	      	  	#清空中间变量
                	      	  	LET r_hrbw_t.sel_1    = NULL 
                	      	  	LET r_hrbw_t.hrat01_1 = NULL
                	      	  	LET r_hrbw_t.hrat02_1 = NULL
                	      	  	LET r_hratid_t        = NULL
                	      	  	#将当前笔员工信息记录到中间变量  
                	      	  	LET r_hrbw_t.sel_1    = r_hrbw[l_n].sel_1
                	      	  	LET r_hrbw_t.hrat01_1 = r_hrbw[l_n].hrat01_1
                	      	  	LET r_hrbw_t.hrat02_1 = r_hrbw[l_n].hrat02_1
                	      	  	LET r_hratid_t        = r_hratid[l_n]
                	      	    #将上一笔员工信息写入当前笔
                	      	    LET r_hrbw[l_n].sel_1    = r_hrbw[l_n-1].sel_1
                	      	    LET r_hrbw[l_n].hrat01_1 = r_hrbw[l_n-1].hrat01_1
                	      	    LET r_hrbw[l_n].hrat02_1 = r_hrbw[l_n-1].hrat02_1
                	      	    LET r_hratid[l_n]        = r_hratid[l_n-1]
                	      	    #将中间变量信息写入上一笔
                	      	    LET r_hrbw[l_n-1].sel_1    = r_hrbw_t.sel_1
                	      	    LET r_hrbw[l_n-1].hrat01_1 = r_hrbw_t.hrat01_1
                	      	    LET r_hrbw[l_n-1].hrat02_1 = r_hrbw_t.hrat02_1
                	      	    LET r_hratid[l_n-1]        = r_hratid_t
                	      	    #同时更改已选择变量组中的卡号信息
                	      	    LET r_hrbw_o[l_i].hrbw02_1 = r_hrbw[l_n-1].hrbw02_1               	      	      
                	      	    LET l_k = l_n + 1
                	      	    IF l_k > l_cnt2 THEN LET l_k = l_cnt2 END IF                 	      	    
                	      	    EXIT FOR
                	      	  END IF                 	      	     
                          END IF 
                        END IF 
                     END FOR 
                   END FOR 
                   DISPLAY l_s2 TO cn2
                 	 CALL ui.Interface.refresh() 
                	 CONTINUE DIALOG 
                END IF 
             #数据下移   
             ON ACTION movedown
                IF l_s2 = 0 THEN                #未选择数据则不处理
                  CALL cl_err('','ghr-095',0)   
                  CONTINUE DIALOG
                ELSE
                	 #根据选取的数组进行循环
                	 LET l_k =  l_cnt2 - 1
                	 FOR l_i = l_s2 TO 1 STEP -1
                	   FOR l_n = l_k TO 1 STEP -1
                	      IF r_hrbw_o[l_i].hrbw02_1 = l_eno  THEN    #如果第一笔也选择了,则不作处理
                	         EXIT FOR 
                	      ELSE       
                	      	IF r_hrbw[l_n].sel_1 = 'Y' THEN 
                	      	  IF r_hrbw[l_n+1].sel_1 = 'Y' THEN  #从第二笔开始,如果上一笔已经选择了,则也不进行处理
                	      	    LET l_k = l_k - 1
                	      	    EXIT FOR 
                	      	  ELSE
                	      	  	#清空中间变量
                	      	  	LET r_hrbw_t.sel_1    = NULL 
                	      	  	LET r_hrbw_t.hrat01_1 = NULL
                	      	  	LET r_hrbw_t.hrat02_1 = NULL
                	      	  	LET r_hratid_t        = NULL
                	      	  	#将当前笔员工信息记录到中间变量  
                	      	  	LET r_hrbw_t.sel_1    = r_hrbw[l_n].sel_1
                	      	  	LET r_hrbw_t.hrat01_1 = r_hrbw[l_n].hrat01_1
                	      	  	LET r_hrbw_t.hrat02_1 = r_hrbw[l_n].hrat02_1
                	      	  	LET r_hratid_t        = r_hratid[l_n]
                	      	    #将上一笔员工信息写入当前笔
                	      	    LET r_hrbw[l_n].sel_1    = r_hrbw[l_n+1].sel_1
                	      	    LET r_hrbw[l_n].hrat01_1 = r_hrbw[l_n+1].hrat01_1
                	      	    LET r_hrbw[l_n].hrat02_1 = r_hrbw[l_n+1].hrat02_1
                	      	    LET r_hratid[l_n]        = r_hratid[l_n+1]
                	      	    #将中间变量信息写入上一笔
                	      	    LET r_hrbw[l_n+1].sel_1    = r_hrbw_t.sel_1
                	      	    LET r_hrbw[l_n+1].hrat01_1 = r_hrbw_t.hrat01_1
                	      	    LET r_hrbw[l_n+1].hrat02_1 = r_hrbw_t.hrat02_1
                	      	    LET r_hratid[l_n+1]        = r_hratid_t
                	      	    #同时更改已选择变量组中的卡号信息
                	      	    LET r_hrbw_o[l_i].hrbw02_1 = r_hrbw[l_n+1].hrbw02_1 
                	      	    LET l_k = l_n
                	      	    IF l_k = 0  THEN LET l_k = 1 END IF 
                	      	    EXIT FOR
                	      	  END IF                 	      	     
                          END IF 
                        END IF 
                     END FOR 
                   END FOR 
                   DISPLAY l_s2 TO cn2
                 	 CALL ui.Interface.refresh() 
                	 CONTINUE DIALOG 
                END IF 
             #自动选取/取消左边资料
             ON ACTION ok2
               IF l_s1 = 0 THEN    
                  #判断是否执行过右移,重新统计右边空余卡号数量
                  LET l_n = 0
                  FOR l_i = 1 TO l_cnt2
                    IF cl_null(r_hrbw[l_i].hrat01_1) THEN 
                       LET l_n = l_n + 1
                    END IF 
                  END FOR      
                  #开始循环选择数据
                  FOR l_i = 1 TO l_cnt1 
                    IF l_i > l_n THEN EXIT FOR END IF 
                    LET r_hrat[l_i].sel = 'Y' 
                    LET l_s1 = l_s1 + 1
                    LET r_hrat_o[l_s1].* = r_hrat[l_i].*     #组选取数组存入r_hrat_o
                    LET l_hratid_o[l_s1] = l_hratid[l_i]     #key值存储
                  END FOR 
               ELSE 
               	  LET l_s1 = 0 
               	  CALL r_hrat_o.clear()
               	  CALL l_hratid_o.clear()
               	  FOR l_i = 1 TO l_cnt1 
                    LET r_hrat[l_i].sel = 'N' 
                  END FOR 
               END IF 
               DISPLAY l_s1 TO cn1
             
             #数据处理
             ON ACTION save
                IF NOT cl_confirm('ghr-096') THEN   #提示是否保存
                   CONTINUE DIALOG
                END IF 
                #整理右边单身的匹配情况
                BEGIN WORK 
                LET g_success ='Y'
                CALL l_showerr.clear()
                LET l_n = 1
                FOR l_i = 1 TO l_cnt2
                   IF NOT cl_null(r_hrbw[l_i].hrat01_1) THEN 
                      CALL i037_hrbw_def()
                      LET g_hrbw.hrbw01 = r_hratid[l_i]
                      LET g_hrbw.hrbw02 = r_hrbw[l_i].hrbw02_1
                      LET g_hrbw.hrbw05 = l_bdate       #生效日期
                      IF p_open = '1' THEN 
                         #新开卡直接新增,如遇重复或其他错误,则直接退出。
                         INSERT INTO hrbw_file VALUES(g_hrbw.*)
                         #EXECUTE i037_insert USING g_hrbw.*
                         IF SQLCA.sqlcode THEN 
                            LET l_showerr[l_n].err01 = r_hrbw[l_i].hrat01_1
                            LET l_showerr[l_n].err02 = r_hrbw[l_i].hrat02_1
                            LET l_showerr[l_n].err03 = g_hrbw.hrbw02
                            LET l_showerr[l_n].err04 = SQLCA.sqlcode 
                            LET l_showerr[l_n].err05 = cl_getmsg(SQLCA.sqlcode,g_lang)
                            LET l_n = l_n + 1
                            LET g_success = 'N'
                            CONTINUE FOR 
                         END IF
                      ELSE 
                      	 #重新开卡,先更新旧资料为失效状态,然后新增。
                      	 #EXECUTE i037_update USING g_hrbw.hrbw01,g_hrbw.hrbw02 
                      	 UPDATE hrbw_file SET hrbw06=g_today,
                      	                      hrbwacti='N'
                      	  WHERE (hrbw01=g_hrbw.hrbw01 OR hrbw02=g_hrbw.hrbw02)
                      	    AND hrbwacti = 'Y'
                      	 IF SQLCA.sqlcode THEN                       	     
                            LET l_showerr[l_n].err01 = r_hrbw[l_i].hrat01_1
                            LET l_showerr[l_n].err02 = r_hrbw[l_i].hrat02_1
                            LET l_showerr[l_n].err03 = g_hrbw.hrbw02
                            LET l_showerr[l_n].err04 = SQLCA.sqlcode 
                            LET l_showerr[l_n].err05 = cl_getmsg(SQLCA.sqlcode,g_lang)
                            LET l_n = l_n + 1
                            LET g_success = 'N'
                            CONTINUE FOR 
                         END IF
                         #EXECUTE i037_insert USING g_hrbw.*
                         INSERT INTO hrbw_file VALUES(g_hrbw.*)
                      	 IF SQLCA.sqlcode=-268 THEN
                      	    UPDATE hrbw_file SET hrbw_file.*=g_hrbw.*
                      	     WHERE hrbw01=g_hrbw.hrbw01
                      	       AND hrbw02=g_hrbw.hrbw02
                      	    IF SQLCA.sqlcode THEN 
                      	       LET l_showerr[l_n].err01 = r_hrbw[l_i].hrat01_1
                               LET l_showerr[l_n].err02 = r_hrbw[l_i].hrat02_1
                               LET l_showerr[l_n].err03 = g_hrbw.hrbw02
                               LET l_showerr[l_n].err04 = SQLCA.sqlcode 
                               LET l_showerr[l_n].err05 = cl_getmsg(SQLCA.sqlcode,g_lang)
                               LET l_n = l_n + 1
                               LET g_success = 'N'
                               CONTINUE  FOR  
                            END IF 
                         ELSE 
                         	  IF SQLCA.sqlcode THEN    
                               LET l_showerr[l_n].err01 = r_hrbw[l_i].hrat01_1
                               LET l_showerr[l_n].err02 = r_hrbw[l_i].hrat02_1
                               LET l_showerr[l_n].err03 = g_hrbw.hrbw02
                               LET l_showerr[l_n].err04 = SQLCA.sqlcode 
                               LET l_showerr[l_n].err05 = cl_getmsg(SQLCA.sqlcode,g_lang)
                               LET l_n = l_n + 1
                               LET g_success = 'N'
                               CONTINUE  FOR 
                            END IF 
                         END IF
                      END IF
                      #判断资料是否合法
                      #同一员工不可有两笔有效的电子卡资料
                      LET l_k = 0
                      SELECT COUNT(*) INTO l_k FROM hrbw_file WHERE hrbw01 = g_hrbw.hrbw01 AND hrbwacti='Y'
                      IF l_k >1 THEN 
                         LET l_showerr[l_n].err01 = r_hrbw[l_i].hrat01_1
                         LET l_showerr[l_n].err02 = r_hrbw[l_i].hrat02_1
                         LET l_showerr[l_n].err03 = g_hrbw.hrbw02
                         LET l_showerr[l_n].err04 = 'ghr-097'              #同一员工,不可同时有两笔有效的电子卡资料    
                         LET l_showerr[l_n].err05 = cl_getmsg(SQLCA.sqlcode,g_lang)
                         LET l_n = l_n + 1
                         LET g_success = 'N'
                         CONTINUE  FOR
                      END IF
                      #同一卡资料,不可同时有两笔有效的员工资料
                      LET l_k = 0 
                      SELECT COUNT(*) INTO l_k FROM hrbw_file WHERE hrbw02 = g_hrbw.hrbw02 AND hrbwacti = 'Y'
                      IF l_k >1 THEN 
                         LET l_showerr[l_n].err01 = r_hrbw[l_i].hrat01_1
                         LET l_showerr[l_n].err02 = r_hrbw[l_i].hrat02_1
                         LET l_showerr[l_n].err03 = g_hrbw.hrbw02
                         LET l_showerr[l_n].err04 = 'ghr-098'              #同一卡资料,不可同时有两笔有效的员工资料    
                         LET l_showerr[l_n].err05 = cl_getmsg(SQLCA.sqlcode,g_lang)
                         LET l_n = l_n + 1
                         LET g_success = 'N'
                         CONTINUE  FOR
                      END IF 
                   END IF 
                END FOR 
                                                
                IF g_success = 'Y' THEN 
                   COMMIT WORK
                   LET INT_FLAG = TRUE   #退出此窗口
                   EXIT DIALOG
                ELSE 
                	 CALL cl_show_array(base.TypeInfo.create(l_showerr),cl_getmsg('lib-314',g_lang),"员工号|员工姓名|卡号|SQLCODE|错误信息") 
                	 ROLLBACK WORK 
                	 CALL cl_set_act_visible("accept,cancel", FALSE)
                	 CONTINUE DIALOG
                END IF 
                          
                      
               
                
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE DIALOG 
            
             ON ACTION about         #MOD-4C0121
                CALL cl_about()      #MOD-4C0121
             
           END DIALOG
           IF INT_FLAG THEN 
             LET INT_FLAG=FALSE
             LET l_bno=null
             LET l_eno=null
             LET l_hrat01_c=null
             CALL r_hrat.clear()
             CALL r_hrbw.clear()
             CLOSE WINDOW i037_w1
             RETURN 
           END IF
END FUNCTION     
FUNCTION i037_hrbw_def()
   LET g_hrbw.hrbw03 = g_today       #发卡日期
   LET g_hrbw.hrbw04 = g_user        #发卡人
   LET g_hrbw.hrbw05 = g_today       #生效日期
   LET g_hrbw.hrbw06 = ''            #失效日期
   LET g_hrbw.hrbw07 = ''            #备注
   LET g_hrbw.hrbwacti = 'Y'         #资料有效否
   LET g_hrbw.hrbwud01 = ''
   LET g_hrbw.hrbwud02 = ''
   LET g_hrbw.hrbwud03 = ''
   LET g_hrbw.hrbwud04 = ''
   LET g_hrbw.hrbwud05 = ''
   LET g_hrbw.hrbwud06 = ''
   LET g_hrbw.hrbwud07 = ''
   LET g_hrbw.hrbwud08 = ''
   LET g_hrbw.hrbwud09 = ''
   LET g_hrbw.hrbwud10 = ''
   LET g_hrbw.hrbwud11 = ''
   LET g_hrbw.hrbwud12 = ''
   LET g_hrbw.hrbwud13 = ''
   LET g_hrbw.hrbwud14 = ''
   LET g_hrbw.hrbwud15 = ''
   LET g_hrbw.hrbwuser = g_user      #用户
   LET g_hrbw.hrbwgrup = g_grup      #群组
   LET g_hrbw.hrbwmodu = ''          #更改者
   LET g_hrbw.hrbwdate = ''          #最近修改日
   LET g_hrbw.hrbworig = g_grup      #资料建立部门
   LET g_hrbw.hrbworiu = g_user      #资料建立者
   
END FUNCTION 

#批量处理：注销/删除
FUNCTION i037_batch(p_batch)
   DEFINE   p_batch      LIKE type_file.chr1      #1.注销；2.删除
   DEFINE   l_bchno      LIKE hrbw_file.hrbw02    #起始卡号
   DEFINE   l_sql        STRING
   DEFINE   l_wc2        STRING
   DEFINE   i            LIKE type_file.num5   
   DEFINE   l_hratid     LIKE hrat_file.hratid
   DEFINE   path STRING, res INTEGER

        LET g_sel = 'Y'
        CALL i037_b()
        
      IF g_cancel ='N' THEN   
        BEGIN WORK
        LET g_success = 'Y'
        IF p_batch='1' THEN 
           LET l_sql = "UPDATE hrbw_file SET hrbw06='",g_today,"'",
                       "  , hrbwacti='N'  WHERE hrbwacti='Y' ",
                       "  AND hrbw01 = ?  AND hrbw02 = ? AND hrbw03 = ? "
           PREPARE i037_b_upd FROM l_sql
        ELSE 
           LET l_sql = " DELETE FROM hrbw_file WHERE hrbw01 = ? ",
                       "    AND hrbw02 = ? AND hrbw03 = ? "
           PREPARE i037_b_del FROM l_sql
        END IF 
        FOR i = 1 TO g_rec_b 
           IF g_hrbw_a[i].chk = 'Y' THEN 
              IF p_batch='1' THEN 
                 LET l_hratid=NULL 
                 SELECT hratid INTO l_hratid FROM hrat_file
                  WHERE hrat01= g_hrbw_a[i].hrbw01
                 EXECUTE i037_b_upd USING l_hratid,g_hrbw_a[i].hrbw02,g_hrbw_a[i].hrbw03
                 IF SQLCA.sqlcode THEN 
                    LET g_success = 'N'
                   #CALL cl_err("upd hrbwacti",SQLCA.sqlcode,1)
                    CALL cl_err3("upd","hrbw_file",g_hrbw_a[i].hrbw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                    EXIT FOR
                 END IF 
              ELSE 
                 LET l_hratid=NULL 
                 SELECT hratid INTO l_hratid FROM hrat_file
                  WHERE hrat01= g_hrbw_a[i].hrbw01
                 EXECUTE i037_b_del USING l_hratid,g_hrbw_a[i].hrbw02,g_hrbw_a[i].hrbw03
                 IF SQLCA.sqlcode THEN 
                    LET g_success = 'N'
                   #CALL cl_err("del hrbw_file",SQLCA.sqlcode,1)
                    CALL cl_err3("del","hrbw_file",g_hrbw_a[i].hrbw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                    EXIT FOR
                 END IF
              END IF 
           END IF  
        END FOR
        FOR i = 1 TO g_rec_b2
           IF g_hrbw_b[i].chk2 = 'Y' THEN 
              IF p_batch='2' THEN 
                 LET l_hratid=NULL 
                 SELECT hratid INTO l_hratid FROM hrat_file
                  WHERE hrat01= g_hrbw_b[i].hrbw01
                 EXECUTE i037_b_del USING l_hratid,g_hrbw_b[i].hrbw02,g_hrbw_b[i].hrbw03
                 IF SQLCA.sqlcode THEN 
                    LET g_success = 'N'
                   #CALL cl_err("del hrbw_file",SQLCA.sqlcode,1)
                    CALL cl_err3("del","hrbw_file",g_hrbw_b[i].hrbw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                    EXIT FOR
                 END IF
              END IF
           END IF 
        END FOR
        IF g_success = 'Y' THEN 
           COMMIT WORK 
           CALL cl_err('','abm-019',1)
        ELSE 
           ROLLBACK WORK
        END IF 
      END IF 
END FUNCTION 
        
          
#No:130909   Add   <<--yangjian--
FUNCTION i037_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102             #可新增否
    l_allow_delete  LIKE type_file.chr1,           #No.FUN-680102               #可刪除否
    l_hratid        LIKE hrat_file.hratid,
    l_hratid_o      LIKE hrat_file.hratid,
    l_sql           STRING,
    l_hrbw06        LIKE hrbw_file.hrbw06
   
DEFINE l_flag       LIKE type_file.chr1           #No.FUN-810016    
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    #LET l_allow_insert = FALSE
    #LET l_allow_delete = FALSE
 
   LET g_forupd_sql = "SELECT hrbw01,hrbw02,hrbw03 FROM hrbw_file",
                      " WHERE hrbw01=? AND hrbw02=? AND hrbw03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i037_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   
   LET g_cancel = 'N'
   
   DIALOG ATTRIBUTES(UNBUFFERED)
    
    INPUT ARRAY g_hrbw_a FROM s_hrbw_a.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           IF g_sel= 'N' THEN
             CALL cl_set_act_visible("sel_all,sel_none",FALSE)
           ELSE 
           	 CALL cl_set_act_visible("sel_all,sel_none",TRUE)
           END IF 
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            LET g_before_input_done = FALSE                                  
            CALL i037_set_entry(p_cmd)                                       
            CALL i037_set_no_entry(p_cmd)                                    
            LET g_before_input_done = TRUE                                                                                            

            IF g_rec_b>=l_ac AND g_sel ='N' THEN
               BEGIN WORK
               LET p_cmd='u'    

               CALL cl_set_comp_entry("hrbw01,hrbw03",FALSE)
              
               LET g_hrbw_at.* = g_hrbw_a[l_ac].*  #BACKUP             
               LET l_hratid=NULL  LET l_hratid_o=NULL 
               SELECT hratid INTO l_hratid FROM hrat_file
                WHERE hrat01=g_hrbw_at.hrbw01
               IF cl_null(l_hratid) THEN 
                 CALL cl_err(g_hrbw_at.hrbw01,'ghr-913',0)
               END IF 
              OPEN i037_bcl USING l_hratid,g_hrbw_at.hrbw02,g_hrbw_at.hrbw03
              IF STATUS THEN
                 CALL cl_err("OPEN i037_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i037_bcl INTO l_hratid_o,g_hrbw_a[l_ac].hrbw02,g_hrbw_a[l_ac].hrbw03
                 SELECT hrat01 INTO g_hrbw_a[l_ac].hrbw01 FROM hrat_file WHERE hratid=l_hratid_o
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_hrbw_at.hrbw01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                      
           CALL i037_set_entry(p_cmd)                                           
           CALL i037_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end            
           IF g_sel = 'N' THEN 
             INITIALIZE g_hrbw_a[l_ac].* TO NULL      #900423
             LET g_hrbw_a[l_ac].hrbw03=g_today
             LET g_hrbw_a[l_ac].hrbw05=g_today
             LET g_hrbw_a[l_ac].hrbw04=g_user
             LET g_hrbw_a[l_ac].hrbw08=0
             LET g_hrbw_at.* = g_hrbw_a[l_ac].*         #新輸入資料
             CALL cl_show_fld_cont()     #FUN-550037(smin)
             NEXT FIELD hrbw01
           END IF 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i037_bcl
              CANCEL INSERT
           END IF
           LET l_hratid=NULL 
           SELECT hratid INTO l_hratid FROM hrat_file
            WHERE hrat01= g_hrbw_a[l_ac].hrbw01
           IF cl_null(l_hratid) THEN 
              CALL cl_err(g_hrbw_a[l_ac].hrbw01,'ghr-913',0)
              CLOSE i037_bcl
              CANCEL INSERT
           END IF 
           INSERT INTO hrbw_file(hrbw01,hrbw02,hrbw03,hrbw04,hrbw05,hrbw06,hrbw07,hrbwacti,hrbw08,hrbw09,hrbw10)
                         VALUES(l_hratid,g_hrbw_a[l_ac].hrbw02,
                                g_hrbw_a[l_ac].hrbw03,g_hrbw_a[l_ac].hrbw04,g_hrbw_a[l_ac].hrbw05,
                                g_hrbw_a[l_ac].hrbw06,g_hrbw_a[l_ac].hrbw07,'Y',g_hrbw_a[l_ac].hrbw08,g_hrbw_a[l_ac].hrbw09,
                                g_hrbw_a[l_ac].hrbw10)  
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","hrbw_file",g_hrbw_a[l_ac].hrbw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
              COMMIT WORK
           END IF
     
 
        BEFORE DELETE                            #是否取消單身
            IF g_hrbw_at.hrbw01 IS NOT NULL THEN
               IF g_sel='Y' THEN 
                  CANCEL DELETE
               END IF 
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
               LET g_doc.column1 = "hrbw01"               #No.FUN-9B0098 10/02/24
               LET g_doc.value1 = g_hrbw_a[l_ac].hrbw01      #No.FUN-9B0098 10/02/24
               LET g_doc.column2 = "hrbw02"               #No.FUN-9B0098 10/02/24
               LET g_doc.value2 = g_hrbw_a[l_ac].hrbw02      #No.FUN-9B0098 10/02/24
               CALL cl_del_doc()                                             #No.FUN-9B0098 10/02/24
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
               LET l_hratid_o=NULL 
               SELECT hratid INTO l_hratid_o FROM hrat_file
                WHERE hrat01= g_hrbw_at.hrbw01
               IF cl_null(l_hratid_o) THEN 
                 CALL cl_err(g_hrbw_at.hrbw01,'ghr-913',0)
                 CANCEL DELETE 
               END IF 
               DELETE FROM hrbw_file WHERE hrbw01 = l_hratid_o
                                      AND hrbw02 = g_hrbw_at.hrbw02 
                                      AND hrbw03 = g_hrbw_at.hrbw03     #MOD-580199
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","hrbw_file",g_hrbw_at.hrbw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  EXIT DIALOG
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               COMMIT WORK 
            END IF

        AFTER FIELD chk
           IF g_sel='Y' AND ( g_hrbw_a[l_ac].chk NOT MATCHES '[YN]' )THEN 
              NEXT FIELD chk
           END IF 
        
        AFTER FIELD hrbw01
           IF NOT cl_null(g_hrbw_a[l_ac].hrbw01) THEN 
              SELECT hrat02,hrao02,hras04 INTO g_hrbw_a[l_ac].hrbw01_n,g_hrbw_a[l_ac].hrat04_n,g_hrbw_a[l_ac].hrat05_n
               FROM hrat_file,OUTER hrao_file,OUTER hras_file
              WHERE hrat01=g_hrbw_a[l_ac].hrbw01
                AND hrat04=hrao01
                AND hrat05=hras01
           END IF 
           
        AFTER FIELD hrbw04
           IF NOT cl_null(g_hrbw_a[l_ac].hrbw04) THEN 
              SELECT hrat02 INTO g_hrbw_a[l_ac].hrbw04_n
               FROM hrat_file
              WHERE hrat01=g_hrbw_a[l_ac].hrbw04

           END IF   
        AFTER FIELD hrbw05
           IF NOT cl_null(g_hrbw_a[l_ac].hrbw05) THEN 
           	  SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbw_a[l_ac].hrbw01
           	  LET l_sql= " select hrbw06 from hrbw_file ",
           	             " where hrbw01 = '",l_hratid,"' "
               PREPARE i037_sr_pb FROM l_sql
               DECLARE hrbw_sr_curs CURSOR FOR i037_sr_pb
                    
               FOREACH hrbw_sr_curs INTO l_hrbw06 
               IF STATUS THEN
                  CALL cl_err('foreach:',STATUS,1)
                  EXIT FOREACH
               END IF
               	IF l_hrbw06 > g_hrbw_a[l_ac].hrbw05 THEN 
               		CALL cl_err('区间重复请检查','!',0)
               		NEXT FIELD hrbw05
               	END IF 
               END FOREACH 
           END IF   
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrbw_a[l_ac].* = g_hrbw_at.*
              CLOSE i037_bcl
              ROLLBACK WORK
              EXIT DIALOG
           END IF
               
           IF g_sel= 'N' THEN 
             IF l_lock_sw="Y" THEN
                 CALL cl_err(g_hrbw_a[l_ac].hrbw01,-263,0)
                 LET g_hrbw_a[l_ac].* = g_hrbw_at.*
             ELSE 
             	 LET l_hratid=NULL
             	 LET l_hratid_o=NULL  
               SELECT hratid INTO l_hratid_o FROM hrat_file
                WHERE hrat01= g_hrbw_at.hrbw01
               SELECT hratid INTO l_hratid FROM hrat_file
                WHERE hrat01= g_hrbw_a[l_ac].hrbw01
             	 IF NOT cl_null(l_hratid_o) AND NOT cl_null(l_hratid) THEN  
                 UPDATE hrbw_file 
                    SET hrbw01=l_hratid,
                        hrbw02=g_hrbw_a[l_ac].hrbw02,
                        hrbw03=g_hrbw_a[l_ac].hrbw03,
                        hrbw04=g_hrbw_a[l_ac].hrbw04,
                        hrbw05=g_hrbw_a[l_ac].hrbw05,
                        hrbw06=g_hrbw_a[l_ac].hrbw06,
                        hrbw07=g_hrbw_a[l_ac].hrbw07,
                        hrbw08=g_hrbw_a[l_ac].hrbw08,
                        hrbw09=g_hrbw_a[l_ac].hrbw09,
                        hrbw10=g_hrbw_a[l_ac].hrbw10
                  WHERE hrbw01=l_hratid_o
                    AND hrbw02=g_hrbw_at.hrbw02
                    AND hrbw03=g_hrbw_at.hrbw03
                 IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","hrbw_file",g_hrbw_at.hrbw01,g_hrbw_at.hrbw02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                     LET g_hrbw_a[l_ac].* = g_hrbw_at.*
                 ELSE
                     MESSAGE 'UPDATE O.K'
                     COMMIT WORK
                 END IF
               END IF 
             END IF
           END IF 
 
        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
           LET l_ac_t = l_ac             # 新增
 
           IF INT_FLAG THEN 
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_hrbw_a[l_ac].* = g_hrbw_at.*
              END IF
              LET g_cancel = 'Y' 
              CLOSE i037_bcl            # 新增
              ROLLBACK WORK         # 新增
              EXIT DIALOG 
           END IF
           CLOSE i037_bcl            # 新增
           COMMIT WORK
     
     END INPUT       
           
     INPUT ARRAY g_hrbw_b  FROM s_hrbw_b.*
      ATTRIBUTE (COUNT=g_rec_b2,MAXCOUNT=g_rec_b2,
                 INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
        BEFORE INPUT
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
        
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            LET g_before_input_done = FALSE                                  
            CALL i037_set_entry(p_cmd)                                                                          
            LET g_before_input_done = TRUE                                                                                            
            CALL cl_show_fld_cont()     #FUN-550037(smin) 
     
      END INPUT 

        ON ACTION accept
          LET g_cancel ='N'
          ACCEPT DIALOG
           
         
        ON ACTION cancel
          LET g_cancel ='Y'
          EXIT DIALOG
          
        ON ACTION exit
          LET INT_FLAG = 1
          EXIT DIALOG

        ON ACTION page1
         LET g_flag='1'
         DISPLAY g_rec_b  TO FORMONLY.cnt1  
               
        ON ACTION page2
         LET g_flag='2'
         DISPLAY g_rec_b2 TO FORMONLY.cnt1
         
        ON ACTION sel_all 
          IF g_flag = '1' THEN 
            FOR l_n =1 TO g_rec_b              
               LET g_hrbw_a[l_n].chk = 'Y'
            END FOR 
          ELSE
          	FOR l_n =1 TO g_rec_b2 
             	 LET g_hrbw_b[l_n].chk2 = 'Y'  
            END FOR
          END IF 

        ON ACTION sel_none
          IF g_flag = '1' THEN 
            FOR l_n =1 TO g_rec_b              
               LET g_hrbw_a[l_n].chk = 'N'
            END FOR 
          ELSE
          	FOR l_n =1 TO g_rec_b2 
             	 LET g_hrbw_b[l_n].chk2 = 'N'  
            END FOR
          END IF
        
        ON ACTION CONTROLP
           CASE 
         	  WHEN INFIELD(hrbw01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat03_1"     #需新增
               #LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_hrbw_a[l_ac].hrbw01
               DISPLAY g_hrbw_a[l_ac].hrbw01 TO hrbw01
               NEXT FIELD hrbw01
            WHEN INFIELD(hrbw04)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat03_1"     #需新增
               #LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_hrbw_a[l_ac].hrbw04
               DISPLAY g_hrbw_a[l_ac].hrbw04 TO hrbw04
               NEXT FIELD hrbw04
           WHEN INFIELD(hrbw09)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrbv01"     #需新增
               #LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_hrbw_a[l_ac].hrbw09
               DISPLAY g_hrbw_a[l_ac].hrbw09 TO hrbw09
               NEXT FIELD hrbw09
            OTHERWISE
              EXIT CASE
            END CASE
            
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

        
    END DIALOG
    IF INT_FLAG THEN 
       CALL cl_err('',9001,0)
       LET INT_FLAG = 0
       LET g_cancel = 'Y' 
       CLOSE i037_bcl            # 新增
       ROLLBACK WORK         # 新增
    END IF
 
    CLOSE i037_bcl
    COMMIT WORK
END FUNCTION

# add by shenran 2014-02-18 10:02:45 start 同步员工（自动生成员工卡片）
FUNCTION i037_tongbu()
	DEFINE l_hrbt04  LIKE hrbt_file.hrbt04
	DEFINE l_sql     STRING
	DEFINE l_hrbw01  LIKE hrbw_file.hrbw01
	DEFINE l_hrbw02  LIKE hrbw_file.hrbw02
	DEFINE l_hrbw05  LIKE hrbw_file.hrbw05
	DEFINE l_hrbw06  LIKE hrbw_file.hrbw06
	DEFINE g_flay    LIKE type_file.chr1
	  
	LET g_flay='Y'
	SELECT hrbt04 INTO l_hrbt04 FROM hrbt_file
	IF l_hrbt04 = 'Y' THEN 
		BEGIN WORK
		LET l_hrbw01=''
		LET l_hrbw02=''
		LET l_hrbw05=''
		LET l_hrbw06=''
		LET l_sql= " select hratid,hrat01,hrat25,hrat77 ",
		           " from hrat_file ",
		           " where hratid not in ",
		           " ( select hrbw01 from hrbw_file where hrbwacti='Y' ) ",
		           " order by hratid "
	       PREPARE i037_sr_tb FROM l_sql
         DECLARE hrbw_tb_curs CURSOR FOR i037_sr_tb
         FOREACH hrbw_tb_curs INTO l_hrbw01,l_hrbw02,l_hrbw05,l_hrbw06 
         IF STATUS THEN
            CALL cl_err('foreach:',STATUS,1)
            EXIT FOREACH
         END IF     
         
         #select  to_char(FingerNo) into l_hrbw02 from (
         #                        select rownum as FingerNo from dual connect by rownum <= 99999) a 
         #where not exists(select 1 from hrbw_file where to_number(hrbw02) = FingerNo and  hrbwacti='Y' ) and rownum=1 
         #select to_char(nvl(max(to_number(hrbw02))+1,1)) into l_hrbw02 from hrbw_file  where hrbwacti='Y'
         
         INSERT INTO hrbw_file(hrbw01,hrbw02,hrbw03,hrbw04,hrbw05,hrbw06,hrbw07,hrbwacti,hrbw08)
                        VALUES(l_hrbw01,l_hrbw02,g_today,g_user,l_hrbw05,l_hrbw06,'','Y','0')   
         IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","hrbw_file",l_hrbw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              LET g_flay= 'N' 
              RETURN 
         END IF            
         END FOREACH
         IF g_flay= 'Y' THEN 
         	COMMIT WORK 
         	ELSE 
         	ROLLBACK WORK 
         END IF 
    ELSE 
    	CALL cl_err('工号与电子卡不一致','!',0)
    	RETURN 
	END IF 
END FUNCTION 
# add by shenran 2014-02-18 10:02:45 end 同步员工（自动生成员工卡片）
FUNCTION i037_set_entry(p_cmd)  
  DEFINE p_cmd  LIKE  type_file.chr1
  
    CALL cl_set_comp_entry("chk",TRUE)
    CALL cl_set_comp_entry("hrbw01,hrbw01_n,hrat04_n,hrat05_n,hrbw06,hrbw04_n,hrbw02,hrbw03,hrbw04,hrbw05,hrbw07",FALSE)
    
    CALL cl_set_comp_entry("chk2",TRUE)
   

END FUNCTION 

FUNCTION i037_set_no_entry(p_cmd)                                    
  DEFINE p_cmd  LIKE  type_file.chr1
  
  IF g_sel = 'N' THEN
    CALL cl_set_comp_entry("chk",FALSE)
    CALL cl_set_comp_entry("hrbw01,hrbw02,hrbw03,hrbw04,hrbw05,hrbw07",TRUE)
  END IF
  
   
END FUNCTION 

FUNCTION i037_fingerprint(p_hrbw01)
	DEFINE p_hrbw01   LIKE hrbw_file.hrbw01
        DEFINE li_status    SMALLINT
        DEFINE ls_cmd       STRING
        CALL ui.interface.frontCall('standard','cbset',[p_hrbw01],[li_status])
        LET ls_cmd="\"D:\\Integration\\Register\\ZKFinger.exe\""
        CALL ui.Interface.frontCall( "standard", "shellexec", [ls_cmd], [li_status])
        #CALL ui.interface.frontCall('standard','cbget',[],[ls_str])



#	DEFINE p_hrbw01   LIKE hrbw_file.hrbw01
#	DEFINE path STRING, res INTEGER
	
   #LET path = "\"f:\\Integration\\Integration.exe\""
#	LET path="\"D:\\CSharpSource\\ZKFinger\\ZKFinger\\bin\\Release\\ZKFinger.exe 100011\""
#   CALL ui.Interface.frontCall( "standard", "shellexec", [path], [res] )
  # CALL ui.Interface.frontCall( "standard", "execute", [path,1], [res] )   
#DISPLAY res
#  IF NOT res THEN
#    DISPLAY "ERROR"
#  END IF
END FUNCTION 
	
    
