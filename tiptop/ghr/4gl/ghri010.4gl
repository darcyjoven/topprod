# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri010.4gl
# Descriptions...: 员工试用期管理-转正&转岗
# Date & Author..: 13/04/03 by liudong

DATABASE ds
 
GLOBALS "../../config/top.global"


DEFINE 
     g_hray         DYNAMIC ARRAY OF RECORD    
        sel         LIKE type_file.chr1,       #选择，默认'N'
        hrat01      LIKE hrat_file.hrat01,     #员工工号
        hrat02      LIKE hrat_file.hrat02,     #员工姓名
        hraa12      LIKE hraa_file.hraa12,     #公司名称
        hrao02      LIKE hrao_file.hrao02,     #部门名称
        hras04      LIKE hras_file.hras04,     #职位
        hrat25      LIKE hrat_file.hrat25,     #入司日期
        hrat02_1    LIKE hrat_file.hrat02,     #直接主管  
        hrat26      LIKE hrat_file.hrat26,     #预计转正日期
        hrat19      LIKE hrad_file.hrad03      #原员工状态   #add by zhangbo130905
                    END RECORD,
    g_hray_t        DYNAMIC ARRAY OF RECORD    
        sel         LIKE type_file.chr1,       #选择，默认'N'
        hrat01      LIKE hrat_file.hrat01,     #员工工号
        hrat02      LIKE hrat_file.hrat02,     #员工姓名
        hraa12      LIKE hraa_file.hraa12,     #公司名称
        hrao02      LIKE hrao_file.hrao02,     #部门名称
        hras04      LIKE hras_file.hras04,     #职位
        hrat25      LIKE hrat_file.hrat25,     #入司日期
        hrat02_1    LIKE hrat_file.hrat02,     #直接主管  hrat06
        hrat26      LIKE hrat_file.hrat26,     #预计转正日期
        hrat19      LIKE hrad_file.hrad03      #原员工状态   #add by zhangbo130905
                    END RECORD,
    b_hray          RECORD LIKE hray_file.*,   #准备试用期管理表变量
    g_hratid        DYNAMIC ARRAY OF LIKE hrat_file.hratid,     #员工表KEY值
    g_hratid_t      DYNAMIC ARRAY OF LIKE hrat_file.hratid,     #员工表KEY值
    g_wc2           STRING,
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
DEFINE l_sel_ac     LIKE  type_file.num5       #add by zhangbo130905


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
    OPEN WINDOW i010_w AT p_row,p_col WITH FORM "ghr/42f/ghri010"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()
    
   # CALL cl_set_label_justify("i010_w","Edit","center") 
    
    LET g_forupd_sql = "SELECT hratid ", 
                       "  FROM hrat_file WHERE hratid=?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   
    LET g_wc2 = '1=1'
    CALL i010_b_fill(g_wc2)
    CALL i010_menu()
    CLOSE WINDOW i010_w                 
      CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i010_menu()
 
   WHILE TRUE
      CALL i010_b()
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i010_q()
            END IF
         WHEN "ghri010_a"
            IF cl_chk_act_auth() THEN
               CALL i010_zz()
            END IF 
         WHEN "ghri010_b"
            IF cl_chk_act_auth() THEN
               CALL i010_zg()
            END IF         
         WHEN "ghri010_c"
            IF cl_chk_act_auth() THEN
               CALL open_i083()
            END IF         
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hray),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION

FUNCTION i010_q()
   CALL i010_b_askkey()
END FUNCTION
	
FUNCTION i010_b()
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
 
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
 
    INPUT ARRAY g_hray WITHOUT DEFAULTS FROM s_hray.*
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
      	  	
        	
    ON CHANGE sel              
        LET g_sel_b = 0      
        CALL g_hray_t.clear()    
        CALL g_hratid_t.clear()
        FOR l_i = 1 TO g_rec_b 
          IF g_hray[l_i].sel = 'Y' THEN
            LET g_sel_b = g_sel_b + 1
            LET g_hray_t[g_sel_b].*=g_hray[l_i].*
            LET g_hratid_t[g_sel_b]=g_hratid[l_i]
          END IF 
        END FOR 
        CALL g_hray.deleteElement(l_i)
        DISPLAY g_sel_b TO FORMONLY.cnt2 
 
     ON ACTION query
         LET g_action_choice="query"
         EXIT INPUT 
 
      ON ACTION ghri010_a
         LET g_action_choice="ghri010_a"
         EXIT INPUT 
      
      ON ACTION ghri010_b
         LET g_action_choice="ghri010_b"
         EXIT INPUT 
     
      ON ACTION ghri010_c
         LET g_action_choice="ghri010_c"
         EXIT INPUT 
         
   
 
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
         LET INT_FLAG=FALSE 		#MOD-570244	mars
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
    CALL g_hray.deleteElement(l_i)
 
END FUNCTION   
	
FUNCTION i010_b_askkey()
    CLEAR FORM
    CALL g_hray.clear()
    LET g_rec_b=0
    LET g_sel_b=0
 
    CONSTRUCT g_wc2 ON hrat01,hrat02,hraa12,hrao02,hras04,hrat25,hrat26                    
         FROM s_hray[1].hrat01,s_hray[1].hrat02,s_hray[1].hraa12,s_hray[1].hrao02,s_hray[1].hras04,s_hray[1].hrat25,s_hray[1].hrat26
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrat01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hray01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hray[1].hrat01
               NEXT FIELD hrat01
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup') #FUN-980030
    LET g_wc2 = "a.",g_wc2
    LET g_wc2 = cl_replace_str(g_wc2,"and ","and a.")
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i010_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION i010_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT 'N',a.hrat01,a.hrat02,hraa12,hrao02,hras04,a.hrat25,b.hrat02,a.hrat26,a.hrat19,a.hratid", #mod by zhangbo130905---add hrat19
                   " FROM hraa_file,hrao_file,hrat_file a,hras_file,hrat_file b",
                   " WHERE ", p_wc2 CLIPPED, 
                   " AND  a.hrat03=hraa01(+) ",
                   " AND a.hrat04=hrao01(+) AND a.hrat05=hras01(+) AND a.hrat06=b.hrat01(+) ",
                   " AND a.hrat19='1001' ",                            #取试用期员工
                   " AND a.hratconf='Y' ",
                   " AND a.hrat26 -15 <= '",g_today,"' ",
                   " ORDER BY 1" 
 
    PREPARE i010_pb FROM g_sql
    DECLARE hray_curs CURSOR FOR i010_pb
 
    CALL g_hray.clear()
    CALL g_hratid.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hray_curs INTO g_hray[g_cnt].*,g_hratid[g_cnt]  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        #add by zhangbo130905---begin
        SELECT hrad03 INTO g_hray[g_cnt].hrat19 FROM hrad_file 
         WHERE hrad02=g_hray[g_cnt].hrat19
        #add by zhangbo130905---end
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hray.deleteElement(g_cnt)
    CALL g_hratid.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    LET g_sel_b = 0
    DISPLAY g_rec_b TO FORMONLY.cnt1
    DISPLAY g_sel_b TO FORMONLY.cnt2   
    LET g_cnt = 0
 
END FUNCTION	
#转正功能相关逻辑
FUNCTION i010_zz()
  DEFINE l_hray02    LIKE hray_file.hray02         #转正日期
  DEFINE l_hrad03,l_hrad03_n    LIKE hrad_file.hrad03         #员工状态
  DEFINE l_hray24    LIKE hray_file.hray24         #转正考核分
  DEFINE l_hray12    LIKE hray_file.hray12         #直接主管意见
  DEFINE l_hray13    LIKE hray_file.hray13         #部门经理意见
  DEFINE l_hray14    LIKE hray_file.hray14         #总经理意见  
  DEFINE l_i,l_n         LIKE type_file.num5            
  
  #如果未选取任何资料则退出此函数
  IF g_sel_b = 0 THEN 
    CALL cl_err('','-400',1)
    RETURN 
  END IF 
  
  OPEN WINDOW i010_1_w  WITH FORM "ghr/42f/ghri010_1"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  
  CALL cl_ui_locale('ghri010_1')
  
  #add by zhangbo130905---begin
  DIALOG ATTRIBUTES(UNBUFFERED)
  DISPLAY ARRAY g_hray_t TO s_hray_1.*  ATTRIBUTE(COUNT=g_sel_b)
     BEFORE DISPLAY
         IF g_sel_b != 0 THEN
            CALL fgl_set_arr_curr(l_sel_ac)
         END IF

     BEFORE ROW
         LET l_sel_ac = ARR_CURR()
         CALL cl_show_fld_cont()
     ON ACTION EXIT
         LET INT_FLAG=TRUE
         EXIT DIALOG

     ON ACTION controlg
        CALL cl_cmdask()


    # ON ACTION cancel
    #     LET INT_FLAG=TRUE              #MOD-570244     mars
    #     EXIT DIALOG

     ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

     ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
  END DISPLAY 
  #add by zhangbo130905---end 

  INPUT l_hray02,l_hrad03,l_hray24,l_hray12,l_hray13,l_hray14 FROM 
    FORMONLY.zzdate,FORMONLY.zzstat,FORMONLY.hray24,FORMONLY.dirmemo,FORMONLY.depmemo,FORMONLY.genmemo
     
    BEFORE INPUT 
       LET l_hray02=g_today
       DISPLAY l_hray02 TO zzdate  
       NEXT FIELD zzdate
      
      AFTER FIELD zzdate
        IF cl_null(l_hray02) THEN 
           CALL cl_err('','ghr-019',0)
           NEXT FIELD zzdate
        ELSE
        	 NEXT FIELD zzstat   
        END IF 
      #add by zhuzw 20150128 start
      AFTER FIELD zzstat
         IF NOT cl_null(l_hrad03) THEN
            SELECT COUNT(*) INTO l_n FROM hrad_file
             WHERE hrad02= l_hrad03
            IF l_n= 0 THEN 
               CALL cl_err('状态不存在，请检查','!',0)
               NEXT FIELD zzstat
            ELSE 
               SELECT hrad03 INTO l_hrad03_n FROM hrad_file
                WHERE hrad02= l_hrad03   
               DISPLAY  l_hrad03_n TO z_n      	    
            END IF  
         END IF 
      #add by zhuzw 20150128 end   
#      AFTER FIELD hray24
#        IF cl_null(l_hray24) THEN 
#            CALL cl_err('转正考核分不可为空！','！',0)
#           # CALL cl_err('','ghr-019',0)
#           NEXT FIELD hray24
#        END IF  
      #add by zhuzw 20150128 start  
      ON ACTION controlp
         CASE
           WHEN INFIELD(zzstat)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrad02"
              LET g_qryparam.default1 = l_hrad03
              CALL cl_create_qry() RETURNING l_hrad03
              DISPLAY BY NAME l_hrad03
              NEXT FIELD zzstat            
           OTHERWISE EXIT CASE
         END CASE
      #add by zhuzw 20150128 end    
      ON ACTION EXIT
         LET INT_FLAG=TRUE
         #EXIT INPUT    #mark by zhangbo130905
         EXIT DIALOG    #add by zhangbo130905
 
      ON ACTION controlg 
        CALL cl_cmdask() 

      ON ACTION accept
         LET INT_FLAG=0
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=TRUE 		#MOD-570244	mars
         #EXIT INPUT        #mark by zhangbo130905
         EXIT DIALOG    #add by zhangbo130905
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         #CONTINUE INPUT    #mark by zhangbo130905
         CONTINUE DIALOG    #add by zhangbo130905
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
       
   END INPUT 
   
   END DIALOG            #add by zhangbo130905
 
   IF INT_FLAG THEN 
     LET INT_FLAG = FALSE
     CLOSE WINDOW i010_1_w 
     RETURN 
   END IF 
   #开始执行转正逻辑处理
   BEGIN WORK 
   LET g_success ='Y'
   FOR l_i=1 TO g_sel_b
      OPEN  i010_bcl USING g_hratid_t[l_i]       #锁住资料
      IF SQLCA.sqlcode THEN 
         CALL cl_err('lock hrat_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOR 
      END IF 
      INITIALIZE b_hray.* TO NULL                      #变量初始化
      CALL i010_def_hray(g_hratid_t[l_i])              #给默认值
      LET b_hray.hray01=g_hratid_t[l_i]                #员工ID
      LET b_hray.hray02=l_hray02                       #转正日期
      LET b_hray.hray02=l_hray02                       #转正日期
      LET b_hray.hray12=l_hray12                       #转正日期
      LET b_hray.hray13=l_hray13                       #转正日期
      LET b_hray.hray14=l_hray14                       #转正日期
      LET b_hray.hray24=l_hray24                       #转正日期
      LET b_hray.hray08 = l_hrad03 #add by zhuzw 20150128
      #Step1.插入/更新试用期转正记录表hray_file
      INSERT INTO hray_file VALUES(b_hray.*)
      IF SQLCA.sqlcode = '-268'  THEN 
          UPDATE hray_file SET hray_file.*=b_hray.*
          WHERE hray01=b_hray.hray01
          IF SQLCA.sqlcode THEN 
            CALL cl_err(b_hray.hray01,SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOR 
          END IF 
      ELSE 
      	IF SQLCA.sqlcode THEN   
        	CALL cl_err(b_hray.hray01,SQLCA.sqlcode,1)
        	LET g_success = 'N'
          EXIT FOR
        END IF   
      END IF 
      #Step2.更新员工基本资料档状态
      UPDATE hrat_file SET hrat19=b_hray.hray08,hrat26=b_hray.hray02,hrat27=b_hray.hray02
       WHERE hratid=b_hray.hray01
      IF SQLCA.sqlcode THEN 
        CALL cl_err('upd hrat19',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOR
      END IF 
      
      CLOSE i010_bcl                             #解锁资料
   END FOR 
   IF g_success = 'Y' THEN 
     COMMIT WORK 
     CLOSE WINDOW i010_1_w 
     CALL cl_err('','ghr-033',1)                   #show出执行结果
     CALL i010_b_fill("1=1")                       #执行成功刷新数据
   ELSE 
   	 ROLLBACK WORK
   	 CLOSE WINDOW i010_1_w 
   	 CALL cl_err('','ghr-034',1)                   #show出执行结果
   END IF        
   
   
     
END FUNCTION 
#转正并转岗功能相关逻辑
FUNCTION i010_zg()
  DEFINE l_hray02    LIKE hray_file.hray02         #转正日期
  DEFINE l_hrad03,l_hrad03_n    LIKE hrad_file.hrad03         #员工状态
  DEFINE l_hray03    LIKE hray_file.hray03         #转岗部门编码
  DEFINE l_hray04    LIKE hray_file.hray04         #转岗职位编码
  DEFINE l_hray12    LIKE hray_file.hray12         #直接主管意见
  DEFINE l_hray13    LIKE hray_file.hray13         #部门经理意见
  DEFINE l_hray14    LIKE hray_file.hray14         #总经理意见  
  DEFINE l_hray24    LIKE hray_file.hray24         #总经理意见  
  DEFINE l_zgpart    LIKE type_file.chr20          #转岗部门
  DEFINE l_zgpost    LIKE type_file.chr20          #转岗职位
  DEFINE l_i,l_n         LIKE type_file.num5  
  DEFINE l_hrat03    LIKE hrat_file.hrat03         #公司 
  DEFINE l_hrat04    LIKE hrat_file.hrat04         #原部门 
  DEFINE l_hrat05    LIKE hrat_file.hrat05         #原职位
  DEFINE l_check     LIKE type_file.chr1           #检查部门职位是否符合标识

  #如果未选取任何资料则退出此函数
  IF g_sel_b = 0 THEN 
    CALL cl_err('','-400',1)
    RETURN 
  END IF 
  
  OPEN WINDOW i010_2_w  WITH FORM "ghr/42f/ghri010_2"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  
  CALL cl_ui_locale('ghri010_2')
  
  
  INPUT l_hray02,l_hray24,l_hrad03,l_hray03,l_hray04,l_hray12,l_hray13,l_hray14 FROM 
    FORMONLY.zzdate,FORMONLY.hray24,FORMONLY.zzstat,FORMONLY.zgpart,FORMONLY.zgpost,FORMONLY.dirmemo,FORMONLY.depmemo,FORMONLY.genmemo
    
    BEFORE INPUT 
#       SELECT hrad03 INTO l_hrad03 FROM hrad_file
#        WHERE hrad02='2001'
       LET l_hray02=g_today
      
      AFTER FIELD zzdate
        IF cl_null(l_hray02) THEN 
           CALL cl_err('','ghr-019',0)
           NEXT FIELD zzdate
        END IF 
      
#       AFTER FIELD hray24
#        IF cl_null(l_hray24) THEN 
#            CALL cl_err('转正考核分不可为空！','！',0)
#           # CALL cl_err('','ghr-019',0)
#           NEXT FIELD hray24
#        END IF    
      #add by zhuzw 20150128 start
      AFTER FIELD zzstat
         IF NOT cl_null(l_hrad03) THEN
            SELECT COUNT(*) INTO l_n FROM hrad_file
             WHERE hrad02= l_hrad03
            IF l_n= 0 THEN 
               CALL cl_err('状态不存在，请检查','!',0)
               NEXT FIELD zzstat
            ELSE 
               SELECT hrad03 INTO l_hrad03_n FROM hrad_file
                WHERE hrad02= l_hrad03   
               DISPLAY  l_hrad03_n TO z_n      	    
            END IF  
         END IF 
      #add by zhuzw 20150128 end         
      AFTER FIELD zgpart 
        IF NOT cl_null(l_hray03) THEN 
          SELECT hrao02 INTO l_zgpart FROM hrao_file
           WHERE hrao01=l_hray03
          IF SQLCA.sqlcode THEN 
             CALL cl_err(l_hray03,'ghr-009',0)
             NEXT FIELD zgpart
          ELSE           	
             DISPLAY l_zgpart TO  partname
          END IF  
        ELSE 
        	NEXT FIELD zgpart
        END IF 
        
      AFTER FIELD zgpost 
        IF NOT cl_null(l_hray04) THEN 
          SELECT hrap06 INTO l_zgpost FROM hrap_file
           WHERE hrap05=l_hray04  AND hrap01=l_hray03
          IF SQLCA.sqlcode THEN 
             CALL cl_err(l_hray04,'ghr-010',0)
             NEXT FIELD zgpost
          ELSE           	
             DISPLAY l_zgpost TO  postname
          END IF           
          #检查变更部门&职位是否与原部门&职位相同
          LET l_check = 'Y'
          FOR l_i=1 TO g_sel_b
            LET l_hrat04=''
            LET l_hrat05=''
            SELECT hrat04,hrat05 INTO l_hrat04,l_hrat05  FROM hrat_file   #原部门编码，原部门职位编码
             WHERE hratid= g_hratid_t[l_i]
            IF SQLCA.sqlcode OR cl_null(l_hrat04) OR cl_null(l_hrat05) THEN
               CALL cl_err(g_hray_t[l_i].hrat01,'ghr-022',1)
               LET l_check ='N'
               EXIT FOR 
            END IF
            IF (l_hrat04 = l_hray03 ) AND (l_hrat05 = l_hray04 ) THEN 
               CALL cl_err(g_hray_t[l_i].hrat01,'ghr-045',1)
               LET l_check ='N'
               EXIT FOR
            END IF  
          END FOR
          IF l_check = 'N' THEN 
             NEXT FIELD zgpart
          END IF  
        END IF
        
      ON ACTION controlp
        CASE 
          WHEN INFIELD(zgpart)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrao02"
               CALL cl_create_qry() RETURNING l_hray03
               SELECT hrao02 INTO l_zgpart FROM hrao_file                 
                WHERE hrao01=l_hray03
               DISPLAY l_hray03 TO  zgpart
               DISPLAY l_zgpart TO  partname
               NEXT FIELD zgpart
          WHEN INFIELD(zgpost)
               IF cl_null(l_hray03) THEN 
                  CALL cl_err(l_hray03,'ghr-020',0)
                  NEXT FIELD zgpart
               END IF 
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrap01"
               LET g_qryparam.arg1  = l_hray03
               CALL cl_create_qry() RETURNING l_hray04
               SELECT hrap06 INTO l_zgpost FROM hrap_file
                WHERE hrap05=l_hray04  AND hrap01=l_hray03
               DISPLAY l_hray04 TO  zgpost
               DISPLAY l_zgpost TO  postname
               NEXT FIELD zgpost
           #add by zhuzw 20150129 start    
           WHEN INFIELD(zzstat)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrad02"
              LET g_qryparam.default1 = l_hrad03
              CALL cl_create_qry() RETURNING l_hrad03
              DISPLAY BY NAME l_hrad03
              NEXT FIELD zzstat   
          #add by zhuzw 20150129 end     
          OTHERWISE
               EXIT CASE
        END CASE
              
      ON ACTION EXIT
         LET INT_FLAG=TRUE
         EXIT INPUT 
 
      ON ACTION controlg 
         CALL cl_cmdask() 
 
 
      ON ACTION cancel
         LET INT_FLAG=TRUE 		#MOD-570244	mars
         EXIT INPUT 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
       
   END INPUT 
   
   IF INT_FLAG THEN 
     LET INT_FLAG = FALSE 
     CLOSE WINDOW i010_2_w 
     RETURN 
   END IF 
   #开始执行转岗逻辑处理
   BEGIN WORK 
   LET g_success ='Y'
   FOR l_i=1 TO g_sel_b
      
      OPEN i010_bcl USING g_hratid_t[l_i]             #锁住资料
      IF SQLCA.sqlcode THEN 
         CALL cl_err('lock hrat_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOR 
      END IF 
      INITIALIZE b_hray.* TO NULL                      #变量初始化
      CALL i010_def_hray(g_hratid_t[l_i])              #给默认值
      LET b_hray.hray01=g_hratid_t[l_i]                #员工ID
      LET b_hray.hray02=l_hray02                       #转正日期
      LET b_hray.hray03=l_hray03                       #转岗部门
      LET b_hray.hray04=l_hray04                       #转岗职位
      LET b_hray.hray12=l_hray12                       #转正日期
      LET b_hray.hray13=l_hray13                       #转正日期
      LET b_hray.hray14=l_hray14                       #转正日期
      LET b_hray.hray24=l_hray24                       #转正日期
      LET b_hray.hray08 = l_hrad03 #add by zhuzw 20150128
      #Step1.插入/更新试用期转正记录表hray_file
      INSERT INTO hray_file VALUES(b_hray.*)
      IF  SQLCA.sqlcode = '-268' THEN 
          UPDATE hray_file SET hray_file.*=b_hray.*
          WHERE hray01=b_hray.hray01
          IF SQLCA.sqlcode THEN 
            CALL cl_err(b_hray.hray01,SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOR 
          END IF 
      ELSE 
      	IF SQLCA.sqlcode THEN 
      	  CALL cl_err(b_hray.hray01,SQLCA.sqlcode,1)
        	LET g_success = 'N'
          EXIT FOR
        END IF   
      END IF 
      #Step2.更新员工基本资料档状态
      #取得部门对应的公司
      SELECT hrao00 INTO l_hrat03 FROM hrao_file
       WHERE hrao01 = b_hray.hray03   
      IF SQLCA.sqlcode OR cl_null(l_hrat03) THEN 
          CALL cl_err('sel hrao00',SQLCA.sqlcode,1)
          LET g_success ='N'
          EXIT FOR
      END IF          
      #更新员工表
      UPDATE hrat_file SET hrat19 = b_hray.hray08,          #员工状态
                           hrat03 = l_hrat03,               #员工所属公司
                           hrat04 = b_hray.hray03,          #员工所属部门
                           hrat05 = b_hray.hray04,           #员工职位
                           hrat26 = b_hray.hray02,           #员工职位
                           hrat27 = b_hray.hray02           #员工职位
       WHERE hratid = b_hray.hray01
      IF SQLCA.sqlcode THEN 
        CALL cl_err('upd hrat19',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOR
      END IF 
      CLOSE i010_bcl                                      #解锁资料
   END FOR 
   IF g_success = 'Y' THEN 
     COMMIT WORK 
     CLOSE WINDOW i010_2_w
     CALL cl_err('','ghr-033',1)                   #show出执行结果
     CALL i010_b_fill("1=1")                       #执行成功刷新数据
   ELSE 
   	 ROLLBACK WORK
   	 CLOSE WINDOW i010_2_w
   	 CALL cl_err('','ghr-034',1)                   #show出执行结果
   END IF        

END FUNCTION 

FUNCTION i010_def_hray(p_hray01)
  DEFINE p_hray01     LIKE hray_file.hray01
  LET b_hray.hray02=g_today                        #转正日期
  LET b_hray.hray03=''                             #转岗部门编码
  LET b_hray.hray04=''                             #转岗职位编码
  LET b_hray.hray05=g_user                         #审核人编号
  LET b_hray.hray06=g_today                        #审核日期
  LET b_hray.hray07='001'                          #审核结果编码
 # LET b_hray.hray08='2001'                         #员工状态码 mark by zhuzw 20150128
  LET b_hray.hray09='N'                            #EF标识
  LET b_hray.hray10='003'                          #状态编码
  LET b_hray.hray11=''                             #表单单号
  LET b_hray.hray12=''                             #直接主管意见
  LET b_hray.hray13=''                             #部门经理意见
  LET b_hray.hray14=''                             #总经理意见
  LET b_hray.hray24=0                             #总经理意见
  SELECT hrat04,hrat05 INTO b_hray.hray15,b_hray.hray16 FROM hrat_file   #原部门编码，原部门职位编码
   WHERE hratid=p_hray01 
  LET b_hray.hray17='N'                            #ESS标识
  LET b_hray.hray18=''                             #提交日期
  LET b_hray.hray19=''                             #提交人编码
  LET b_hray.hray20=''                             #归档日期
  LET b_hray.hray21=''                             #归档人编码
  LET b_hray.hray22=''                             #撤销日期
  LET b_hray.hray23=''                             #撤销人编码
  LET b_hray.hrayacti='Y'                          #资料有效码
  LET b_hray.hrayuser=g_user                       #资料所有者
  LET b_hray.hraygrup=g_grup                       #资料所属部门
  LET b_hray.hraymodu=''                           #资料更改者
  LET b_hray.hraydate=g_today                      #最近修改日
  LET b_hray.hrayoriu=g_user                       #资料建立者
  LET b_hray.hrayorig=g_grup                       #资料建立部门
  
END FUNCTION 

FUNcTION open_i083()
   DEFINE g_msg LIKE type_file.chr1000
   LET g_msg = "ghri083 '",g_hray[l_ac].hrat01,"' 'Y'  "
   CALL cl_cmdrun_wait(g_msg)   
END FUNCTION 
