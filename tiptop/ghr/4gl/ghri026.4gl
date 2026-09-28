# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri026.4gl
# Descriptions...: 
# Date & Author..: 04/23/13 by zhangbo
# Modify ........: by  hourf  13/05/16  增加15个自定义栏位

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE g_hrbi    RECORD LIKE hrbi_file.*
DEFINE g_hrbi_t  RECORD LIKE hrbi_file.*
DEFINE g_forupd_sql        STRING
DEFINE g_sql                  STRING                      #組 sql 用
DEFINE g_before_input_done    LIKE type_file.num5         #判斷是否已執行 Before Input指令
DEFINE g_flag                 LIKE type_file.chr1         #员工自动编号返回的一个值，判断是否可以手工修改
#DEFINE g_wx                   LIKE type_file.chr1         #标记查询
DEFINE g_chr                  LIKE hrat_file.hratacti
DEFINE g_cnt                  LIKE type_file.num10
DEFINE g_i                    LIKE type_file.num5         #count/index for any purpose
DEFINE g_wc                   STRING
DEFINE g_msg                  STRING
DEFINE g_curs_index           LIKE type_file.num10
DEFINE g_row_count            LIKE type_file.num10        #總筆數
DEFINE g_jump                 LIKE type_file.num10        #查詢指定的筆數
DEFINE g_no_ask               LIKE type_file.num5         #是否開啟指定筆視窗
DEFINE g_hratid               LIKE hrat_file.hratid  

#add by zhangbo130904---begin
DEFINE g_hrbi_1   DYNAMIC ARRAY OF RECORD
       hrbi01     LIKE   hrbi_file.hrbi01,
       hrbiud02   LIKE   hrbi_file.hrbiud02, #旧工号
       hrat02     LIKE   hrat_file.hrat02,   #姓名
       hrag07     LIKE   hrag_file.hrag07,   #旧员工属性
       hrbi04     LIKE   hrbi_file.hrbi04,
       hrao00     LIKE   hrao_file.hrao00,
       hraa12     LIKE   hraa_file.hraa12,
       hrbi06     LIKE   hrbi_file.hrbi06,
       hrao02     LIKE   hrao_file.hrao02,
       hrbi08     LIKE   hrbi_file.hrbi08,
       hras04     LIKE   hras_file.hras04,
       hrbi07     LIKE   hrbi_file.hrbi07,
       hrad03     LIKE   hrad_file.hrad03,
       hrbi09     LIKE   hrbi_file.hrbi09,
       hrai04     LIKE   hrai_file.hrai04,
       hrbiconf   LIKE   hrbi_file.hrbiconf,
       hrbi03     LIKE   hrbi_file.hrbi03,
       hrbi05     LIKE   hrbi_file.hrbi05,
       hrbi10     LIKE   hrbi_file.hrbi10,
       hrbi11     LIKE   hrbi_file.hrbi11,
       hrbi12     LIKE   hrbi_file.hrbi12,
       hrbi13     LIKE   hrbi_file.hrbi13,
       hrbi14     LIKE   hrbi_file.hrbi14,
       hrbi15     LIKE   hrbi_file.hrbi15,
       ta_hrbi05     LIKE   hrbi_file.ta_hrbi05,
       ta_hrbi05_1     LIKE   hrbi_file.ta_hrbi05,
       ta_hrbi06     LIKE   hrbi_file.ta_hrbi05,
       ta_hrbi06_1     LIKE  hrbi_file.ta_hrbi05      
                  END RECORD
DEFINE  g_rec_b,l_ac             LIKE type_file.num5
DEFINE  g_bp_flag           LIKE type_file.chr10
#add by zhangbo130904---end


MAIN
    DEFINE
    p_row,p_col         LIKE type_file.num5      #No.FUN-680123 SMALLINT
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
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
   INITIALIZE g_hrbi.* TO NULL

   LET g_forupd_sql = "SELECT * FROM hrbi_file WHERE hrbi01 = ? and hrbi05 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)        
   DECLARE i026_cl CURSOR FROM g_forupd_sql                 
   
   OPEN WINDOW i026_w AT p_row,p_col 
     WITH FORM "ghr/42f/ghri026"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
   CALL cl_set_label_justify("i026_w","right") 
   LET g_action_choice=""
   CALL i026_menu()

   CLOSE WINDOW i026_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN

FUNCTION i026_curs()
DEFINE l_hrbi01   LIKE hrbi_file.hrbi01
DEFINE l_xgh      LIKE hrat_file.hrat01

    CLEAR FORM
    INITIALIZE g_hrbi.* TO NULL
    #LET g_wx = 'N'
    CONSTRUCT BY NAME g_wc ON                              
        hrbi01,hrbi04,hrbi06,
        hrbi07,hrbi08,hrbi09,hrbi03,hrbi05,
        hrbi10,ta_hrbi01,hrbi11,
        hrbi12,hrbi13,hrbi14,hrbi15,hrbiconf,
        hrbiuser,hrbigrup,hrbimodu,hrbidate,hrbioriu,hrbiorig,
        hrbiud02, hrbiud03, hrbiud04, hrbiud05, hrbiud06, hrbiud07, hrbiud08,             #add by hourf   13/05/16
        hrbiud09, hrbiud10, hrbiud11, hrbiud12, hrbiud13, hrbiud14, hrbiud15, hrbiud01,ta_hrbi06    #add by hourf   13/05/16
        BEFORE CONSTRUCT                                                                  #add by hourf   13/05/16
           CALL cl_qbe_init()                               
#         AFTER FIELD hrbi01
#            LET l_hrbi01 = GET_FLDBUF(hrbi01)
#            IF NOT cl_null(l_hrbi01) THEN
#               #SELECT hratid INTO g_hrbi.hrbi01 FROM hrat_file WHERE hrat01 = l_hrbi01 OR hratid = l_hrbi01
#               SELECT hrbi04 INTO l_xgh FROM hrbi_file WHERE hrbiud02=l_hrbi01 #通过旧工号找到新工号
#               SELECT hratid INTO g_hrbi.hrbi01 FROM hrat_file WHERE hrat01=l_xgh #找到id
#               IF SQLCA.sqlcode THEN
#                 LET g_wx = 'Y'
#               END IF 
#               DISPLAY BY NAME g_hrbi.hrbi01
#            END IF 

        ON ACTION controlp
           CASE
              WHEN INFIELD(hrbi01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbh01_1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrbi.hrbi01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbi01
                 NEXT FIELD hrbi01
                 
              WHEN INFIELD(hrbi06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01_1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrbi.hrbi06
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbi06
                 NEXT FIELD hrbi06
                 
             WHEN INFIELD(hrbi07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrad02"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrbi.hrbi07
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbi07
                 NEXT FIELD hrbi07
                 
             WHEN INFIELD(hrbi08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrap01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrbi.hrbi08
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbi08
                 NEXT FIELD hrbi08
             WHEN INFIELD(ta_hrbi01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraf01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrbi.ta_hrbi01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ta_hrbi01
                 NEXT FIELD ta_hrbi01                 
             WHEN INFIELD(hrbi09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrai031"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrbi.hrbi09
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbi09
                 NEXT FIELD hrbi09
                 
             WHEN INFIELD(ta_hrbi06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrar03_zw"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrbi.ta_hrbi06
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ta_hrbi06
                 NEXT FIELD ta_hrbi06                 
              OTHERWISE
                 EXIT CASE
           END CASE

      ON IDLE g_idle_seconds                                #
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about                                       #
         CALL cl_about()

      ON ACTION help                                        #
         CALL cl_show_help()

      ON ACTION controlg                                    #
         CALL cl_cmdask()

      ON ACTION qbe_select                                  #
         CALL cl_qbe_select()

      ON ACTION qbe_save                                    #
         CALL cl_qbe_save()
    END CONSTRUCT

   # LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrbiuser', 'hrbigrup')  #     
    LET g_wc = cl_replace_str(g_wc,'hrbi01','hrbiud02')                                                               #
#    IF g_wx = 'Y' THEN #查询条件错误过滤
#      LET g_wc = " 1=0 "
#    END IF 
    LET g_sql = "SELECT hrbi01,hrbi05 FROM hrbi_file ",                       #
                " WHERE ",g_wc CLIPPED, 
                " ORDER BY hrbi01"
    PREPARE i026_prepare FROM g_sql
    DECLARE i026_cs                                                  # 
        SCROLL CURSOR WITH HOLD FOR i026_prepare

    LET g_sql = "SELECT COUNT( hrbi01||hrbi05) FROM hrbi_file WHERE ",g_wc CLIPPED
    PREPARE i026_precount FROM g_sql
    DECLARE i026_count CURSOR FOR i026_precount
END FUNCTION
	
FUNCTION i026_menu()
    DEFINE l_cmd    STRING

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           
        #add by zhangbo130904---begin
        ON ACTION item_list
           LET g_action_choice = ""  #MOD-8A0193 add
           CALL i026_b_menu()   #MOD-8A0193
           LET g_action_choice = ""  #MOD-8A0193 add
        #add by zhangbo130904---end    

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i026_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i026_q()
            END IF

        ON ACTION next
            CALL i026_fetch('N')

        ON ACTION previous
            CALL i026_fetch('P')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i026_u()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL i026_r()
            END IF
            	
        ON ACTION ghr_confirm
           LET g_action_choice="ghr_confirm"
           IF cl_chk_act_auth() THEN
              CALL i026_confirm()
           END IF
        
        ON ACTION ghr_undo_confirm
           LET g_action_choice="ghr_undo_confirm"
           IF cl_chk_act_auth() THEN
              CALL i026_undo_confirm()
           END IF    	
        
        #原离职基本信息    	
        ON ACTION ghri026_a
           LET g_action_choice="ghri026_a"
           IF cl_chk_act_auth() THEN
           	  LET g_hratid=''
           	  #SELECT hratid INTO g_hratid FROM hrat_file WHERE hrat01=g_hrbi.hrbi04
           	  IF g_hrbi.hrbiconf = 'Y' THEN 
                SELECT hrat01 INTO g_hratid FROM hrat_file WHERE hrat01=g_hrbi.hrbi04
              ELSE 
                SELECT hrat01 INTO g_hratid FROM hrat_file WHERE hrat01=g_hrbi.hrbi01
              END IF 
              LET g_msg="ghri025 '",g_hratid,"'"
              CALL cl_cmdrun_wait(g_msg)
           END IF
           
        
        #部门面谈信息
        ON ACTION ghri026_b
           LET g_action_choice="ghri026_b"
           IF cl_chk_act_auth() THEN
           	  LET g_hratid=''
           	  SELECT hratid INTO g_hratid FROM hrat_file WHERE hrat01=g_hrbi.hrbi04
              LET g_msg="ghri025_2 '",g_hratid,"'"
              CALL cl_cmdrun_wait(g_msg)
           END IF
           	
        #人资面谈信息
        ON ACTION ghri026_c
           LET g_action_choice="ghri026_c"
           IF cl_chk_act_auth() THEN
           	  LET g_hratid=''
           	  SELECT hratid INTO g_hratid FROM hrat_file WHERE hrat01=g_hrbi.hrbi04
              LET g_msg="ghri025_3 '",g_hratid,"'"
              CALL cl_cmdrun_wait(g_msg)
           END IF   		    	 	    	    	

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i026_fetch('/')

        ON ACTION first
            CALL i026_fetch('F')

        ON ACTION last
            CALL i026_fetch('L')

        ON ACTION controlg
            CALL cl_cmdask()

        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU

        ON ACTION about
           CALL cl_about()

        ON ACTION close
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU

        ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_hrbi.hrbi01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrbi01"
                 LET g_doc.value1 = g_hrbi.hrbi01
                 CALL cl_doc()
              END IF
           END IF
    END MENU
    
END FUNCTION	
	
FUNCTION i026_a()
DEFINE l_hrbi   RECORD LIKE hrbi_file.* 

    CLEAR FORM                                   #
    INITIALIZE g_hrbi.* LIKE hrbi_file.*
    INITIALIZE g_hrbi_t.* LIKE hrbi_file.*
    INITIALIZE l_hrbi.* LIKE hrbi_file.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
    	  LET g_hrbi.hrbi03 = g_today
    	  LET g_hrbi.hrbi05 = g_today
    	  LET g_hrbi.hrbi10 = g_today
        LET g_hrbi.hrbiuser = g_user
        LET g_hrbi.hrbioriu = g_user
        LET g_hrbi.hrbiorig = g_grup
        LET g_hrbi.hrbigrup = g_grup               #
        LET g_hrbi.hrbidate = g_today
        LET g_hrbi.hrbiconf = 'N'
        LET g_hrbi.ta_hrbi03 = 'N'
         
        CALL i026_i("a")                         #
        IF INT_FLAG THEN                         #
            INITIALIZE g_hrbi.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hrbi.hrbi01 IS NULL THEN              #
            CONTINUE WHILE
        END IF
        LET l_hrbi.* = g_hrbi.*
        LET l_hrbi.hrbiud02 = l_hrbi.hrbi01 #hrbiud02 存储 旧工号
        SELECT hratid INTO l_hrbi.hrbi01 FROM hrat_file 
         WHERE hrat01=g_hrbi.hrbi01
           AND hratacti='Y'	
           AND hratconf='Y'
        INSERT INTO hrbi_file VALUES(l_hrbi.*)     #
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrbi_file",g_hrbi.hrbi01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
        	  LET g_hrbi_t.*=g_hrbi.*
            CALL i026_b_fill(g_wc) 
        END IF
        
        EXIT WHILE
    END WHILE
END FUNCTION	
	
FUNCTION i026_i(p_cmd)
   DEFINE p_cmd            LIKE type_file.chr1
   DEFINE l_input          LIKE type_file.chr1
   DEFINE l_n              LIKE type_file.num5
   DEFINE l_hrat02         LIKE hrat_file.hrat02
   DEFINE l_hrat03         LIKE hrat_file.hrat03
   DEFINE l_hrat03_desc    LIKE hraa_file.hraa12
   DEFINE l_hrat04         LIKE hrat_file.hrat04
   DEFINE l_hrat04_desc    LIKE hrao_file.hrao02
   DEFINE l_hrat05         LIKE hrat_file.hrat05
   DEFINE l_hrat05_desc    LIKE hrap_file.hrap06
   DEFINE l_hrat13         LIKE hrat_file.hrat13
   DEFINE l_hrat17         LIKE hrat_file.hrat17
   DEFINE l_hrat17_desc    LIKE hrag_file.hrag07
   DEFINE l_hrat22         LIKE hrat_file.hrat22
   DEFINE l_hrat22_desc    LIKE hrag_file.hrag07
   DEFINE l_hrat42         LIKE hrat_file.hrat42
   DEFINE l_hrat42_desc    LIKE hrai_file.hrai04
   DEFINE l_hrat15         LIKE hrat_file.hrat15
   DEFINE l_hrat25         LIKE hrat_file.hrat25
   DEFINE l_hrbh04         LIKE hrbh_file.hrbh04
   DEFINE l_hrbi06_desc    LIKE hrao_file.hrao02
   DEFINE l_hrbi07_desc    LIKE hrad_file.hrad03
   DEFINE l_hrbi08_desc    LIKE hras_file.hras04
   DEFINE l_hrbi09_desc    LIKE hrai_file.hrai04
   DEFINE l_hrao00         LIKE hrao_file.hrao00
   DEFINE l_hrao00_desc    LIKE hraa_file.hraa12   
   DEFINE l_sql         STRING
   DEFINE l_ta_hrbi01_desc    LIKE hraf_file.hraf02
   DEFINE l_ta_hrbi02_n    LIKE hrat_file.hrat02 #add by zhuzw 20150319
   DEFINE l_hratid         LIKE hrat_file.hratid
   DEFINE l_hrbh03         LIKE hrbh_file.hrbh03
   DEFINE l_ta_hrbi06_n,l_ta_hrbi05_n    LIKE hrar_file.hrar04
   DISPLAY BY NAME
      g_hrbi.hrbi01,g_hrbi.hrbi03,g_hrbi.hrbi04,
      g_hrbi.hrbi05,g_hrbi.hrbi06,g_hrbi.hrbi07,g_hrbi.hrbi08,g_hrbi.hrbi09,
      g_hrbi.hrbi10,g_hrbi.ta_hrbi01,g_hrbi.hrbi11,g_hrbi.hrbi12,g_hrbi.hrbi13,g_hrbi.hrbi14,g_hrbi.hrbi15,
      g_hrbi.hrbiconf,g_hrbi.hrbioriu,g_hrbi.hrbiorig,
      g_hrbi.hrbiuser,g_hrbi.hrbigrup,g_hrbi.hrbimodu,g_hrbi.hrbidate,
      g_hrbi.hrbiud02, g_hrbi.hrbiud03, g_hrbi.hrbiud04, g_hrbi.hrbiud05, g_hrbi.hrbiud06, g_hrbi.hrbiud07, g_hrbi.hrbiud08,
      g_hrbi.hrbiud09, g_hrbi.hrbiud10, g_hrbi.hrbiud11, g_hrbi.hrbiud12, g_hrbi.hrbiud13, g_hrbi.hrbiud14, g_hrbi.hrbiud15,
      g_hrbi.hrbiud01,g_hrbi.ta_hrbi03                              #add by hourf   13/05/16

   INPUT BY NAME
      #g_hrbi.hrbi01,g_hrbi.hrbi06,
      g_hrbi.hrbi01,g_hrbi.hrbi04,g_hrbi.hrbi06,
      g_hrbi.hrbi07,g_hrbi.hrbi08,g_hrbi.ta_hrbi06,g_hrbi.hrbi09,g_hrbi.hrbi03,g_hrbi.hrbi05,g_hrbi.hrbi10,g_hrbi.ta_hrbi01,g_hrbi.ta_hrbi02,g_hrbi.ta_hrbi03,
      g_hrbi.hrbi11,g_hrbi.hrbi12,g_hrbi.hrbi13,g_hrbi.hrbi14,
      g_hrbi.hrbi15,g_hrbi.hrbiconf,
      g_hrbi.hrbiud02, g_hrbi.hrbiud03, g_hrbi.hrbiud04, g_hrbi.hrbiud05, g_hrbi.hrbiud06, g_hrbi.hrbiud07, g_hrbi.hrbiud08,
      g_hrbi.hrbiud09, g_hrbi.hrbiud10, g_hrbi.hrbiud11, g_hrbi.hrbiud12, g_hrbi.hrbiud13, g_hrbi.hrbiud14, g_hrbi.hrbiud15,
      g_hrbi.hrbiud01                             #add by hourf   13/05/16
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i026_set_entry(p_cmd)
          CALL i026_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
      
      AFTER FIELD hrbi01
         IF NOT cl_null(g_hrbi.hrbi01) THEN
            IF g_hrbi.hrbi01 != g_hrbi_t.hrbi01 OR g_hrbi_t.hrbi01 IS NULL THEN 
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrbh_file,hrat_file 
         	   WHERE hrat01=g_hrbi.hrbi01
         	     AND hrbh01=hratid
         	     AND hrbhconf != '1'
         	  IF l_n=0 THEN
         	  	 CALL cl_err('此离退员工不存在或还未审核','!',0)
         	  	 NEXT FIELD hrbi01
         	  END IF
         	  
#         	  LET l_n=0  
#         	   SELECT COUNT(*) INTO l_n FROM hrbi_file
#         	   WHERE hrbi01 =(SELECT hratid FROM hrat_file WHERE hrat01 = g_hrbi.hrbi01) 
#         	     AND hrbi05 = g_hrbi.hrbi05 
#         	  IF l_n>0 THEN
#         	  	 CALL cl_err(g_hrbi.hrbi01,-239,1)
#         	  	 NEXT FIELD hrbi01
#         	  END IF
         	  
         	  #回聘人员不在黑名单中
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrbj_file,hrat_file 
         	   WHERE hratid=hrbj02
         	     AND hrat01=g_hrbi.hrbi01
         	     AND hrbjacti='Y'
         	  IF l_n>0 THEN
         	  	 CALL cl_err('该人员存在于黑名单中,不可回聘录用','!',0)
         	  	 NEXT FIELD hrbi01
         	  END IF	   
         	  
         	  #人资面谈信息中回聘否为Y	
         	  LET l_n=0	
         	  SELECT COUNT(*) INTO l_n FROM hrbhc_file,hrat_file
         	   WHERE hratid=hrbhc02
         	     AND hrat01=g_hrbi.hrbi01
         	     AND hrbhc05='N'       #回聘否
         	  IF l_n>0 THEN
         	  	 CALL cl_err('人资面谈回聘否未全部勾选,不可回聘','!',0)
         	  	 NEXT FIELD hrbi01
         	  END IF 	 	
         	  
         	  #姓名,部门编号,职位编号,直接主管,性别,学历,员工状态,成本中心,入职日期
               SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrbi.hrbi01
               SELECT MAX(hrbh03) INTO l_hrbh03 FROM hrbh_file WHERE hrbh01 = l_hratid
               SELECT a.hrat02,a.hrat13,a.hrat15,a.hrat25,hrbhud02,hraa02,hrbhud03,b.hrao02,hrbhud04,c.hras04,a.hrat17,e.hrag07,a.hrat22,f.hrag07,hrat20,h.hrag07,hrbhud13
               INTO l_hrat02,l_hrat13,l_hrat15,l_hrat25,l_hrat03,l_hrat03_desc,l_hrat04,l_hrat04_desc,l_hrat05,l_hrat05_desc,l_hrat17,l_hrat17_desc,l_hrat22,l_hrat22_desc,l_hrat42,l_hrat42_desc,l_hrbh04
               FROM hrbh_file 
               LEFT join hraa_file ON hraa01 = hrbhud02
               LEFT join hrat_file a ON a.hratid = hrbh01
               LEFT JOIN hrao_file b ON hrao01=hrbhud03
               LEFT JOIN hras_file c ON hras01=hrbhud04
               LEFT JOIN hrag_file e ON e.hrag06=a.hrat17 AND e.hrag01='333'
               LEFT JOIN hrag_file f ON f.hrag06=a.hrat22 AND f.hrag01='317'
               #LEFT JOIN hrai_file h ON h.hrai03=hrbhud06               
               LEFT join hrag_file h ON h.hrag06=hrbhud06 AND h.hrag01='313'
               WHERE a.hratid=l_hratid AND hrbh03 = l_hrbh03
               SELECT hrat60,hrar04 INTO g_hrbi.ta_hrbi05,l_ta_hrbi05_n FROM hrat_file,hrar_file 
                WHERE hratid = l_hratid AND hrar03 = hrat60
              DISPLAY  BY NAME g_hrbi.ta_hrbi05
              DISPLAY l_ta_hrbi05_n TO ta_hrbi05_n 
         	  SELECT COUNT(*) + 1 INTO g_hrbi.ta_hrbi04 FROM hrbi_file,hrat_file 
         	   WHERE hrbi01=hratid
         	     AND hrat01=g_hrbi.hrbi01  
         	  #add end    
#         	  #自动生成工号
#         	  LET g_flag = 'Y'
#         	  CALL hr_gen_no('hrat_file','hrat01','009',l_hrat03,'0000') RETURNING g_hrbi.hrbi04,g_flag
#         	  DISPLAY g_hrbi.hrbi04 TO hrbi04
#         	  IF g_flag = 'Y' THEN
#               CALL cl_set_comp_entry("hrbi04",TRUE)
#            ELSE
#               CALL cl_set_comp_entry("hrbi04",FALSE)
#            END IF
#         	  #end
         	  DISPLAY BY NAME g_hrbi.ta_hrbi04
         	  DISPLAY l_hrat02 TO hrat02
         	  DISPLAY l_hrat04 TO hrat04
         	  DISPLAY l_hrat04_desc TO hrat04_desc
         	  DISPLAY l_hrat05 TO hrat05
         	  DISPLAY l_hrat05_desc TO hrat05_desc
         	  DISPLAY l_hrat03 TO hrat03
         	  DISPLAY l_hrat03_desc TO hrat03_desc
         	  DISPLAY l_hrat17 TO hrat17
         	  DISPLAY l_hrat17_desc TO hrat17_desc
         	  DISPLAY l_hrat22 TO hrat22
         	  DISPLAY l_hrat22_desc TO hrat22_desc
         	  DISPLAY l_hrat42 TO hrat42
         	  DISPLAY l_hrat42_desc TO hrat42_desc
         	  DISPLAY l_hrat15 TO hrat15
         	  DISPLAY l_hrat25 TO hrat25
         	  DISPLAY l_hrbh04 TO hrbh04 
         	  DISPLAY l_hrat13 TO hrat13
            END IF
         	                                                                  		 	  	
         END IF
     AFTER FIELD hrbi05 
       IF NOT cl_null(g_hrbi.hrbi05) THEN 
          LET l_n = 0
          IF p_cmd = 'a'  OR  g_hrbi.hrbi05 != g_hrbi_t.hrbi05 THEN 
             SELECT COUNT(*) INTO l_n FROM hrbi_file
             WHERE hrbi01 =(SELECT hratid FROM hrat_file WHERE hrat01 = g_hrbi.hrbi01) 
               AND hrbi05 = g_hrbi.hrbi05 
         END IF  	  
         IF l_n>0 THEN
         	 CALL cl_err(g_hrbi.hrbi01,-239,1)
         	 NEXT FIELD hrbi05
         END IF       
       END IF   	
       #add by zhuzw 20150219 str
      AFTER FIELD ta_hrbi02 
       IF NOT cl_null(g_hrbi.ta_hrbi02) THEN 
          SELECT COUNT(*) INTO l_n FROM hrat_file 
           WHERE hrat01 = g_hrbi.ta_hrbi02
             AND hrat07 ='Y'
          IF l_n = 0 THEN 
             CALL cl_err('该主管不存在，请检查','!',0)
             NEXT FIELD ta_hrbi02
          ELSE 
             SELECT hrat02  INTO l_ta_hrbi02_n FROM hrat_file 
              WHERE hrat01 = g_hrbi.ta_hrbi02 
             DISPLAY  l_ta_hrbi02_n TO ta_hrbi02_n        	 
          END IF  
       END IF    
       #add end     	  		                                           
      AFTER FIELD hrbi06
         IF g_hrbi.hrbi06 IS NOT NULL THEN 
         	  LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrao_file WHERE hrao01=g_hrbi.hrbi06
                                                      AND hraoacti='Y'
            IF l_n = 0 THEN                  
               CALL cl_err('无此部门编号','!',0)
               LET g_hrbi.hrbi06 = g_hrbi_t.hrbi06
               DISPLAY BY NAME g_hrbi.hrbi06
               NEXT FIELD hrbi06
            END IF
            
            SELECT hrao02 INTO l_hrbi06_desc FROM hrao_file
             WHERE hrao01=g_hrbi.hrbi06
               AND hraoacti='Y'
            DISPLAY l_hrbi06_desc TO hrbi06_desc  
            
            SELECT hrao00,hraa12 INTO l_hrao00,l_hrao00_desc FROM hrao_file,hraa_file
             WHERE hraa01=hrao00
               AND hrao01=g_hrbi.hrbi06
            DISPLAY l_hrao00 TO hrao00
            DISPLAY l_hrao00_desc TO hrao00_desc      	
         END IF
         	
      AFTER FIELD hrbi07         
         IF NOT cl_null(g_hrbi.hrbi07) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrad_file
         	   WHERE hrad02=g_hrbi.hrbi07
         	     AND hradacti='Y'
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此员工状态','!',0)
         	  	 NEXT FIELD hrbi07
         	  END IF
         	  SELECT hrad03 INTO l_hrbi07_desc FROM hrad_file
         	   WHERE hrad02=g_hrbi.hrbi07
         	  DISPLAY l_hrbi07_desc TO hrbi07_desc 	
         END IF
      AFTER FIELD ta_hrbi06         
         IF NOT cl_null(g_hrbi.ta_hrbi06) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrar_file
         	   WHERE hrar03=g_hrbi.ta_hrbi06
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此职务','!',0)
         	  	 NEXT FIELD ta_hrbi06
         	  END IF
         	  SELECT hrar04 INTO l_ta_hrbi06_n FROM hrar_file
         	   WHERE hrar03=g_hrbi.ta_hrbi06
         	  DISPLAY l_ta_hrbi06_n TO ta_hrbi06_n 	
         END IF         	
      BEFORE FIELD hrbi08
         IF cl_null(g_hrbi.hrbi06) THEN
         	  CALL cl_err('录入职位前须先录入部门','!',0)
         	  NEXT FIELD hrbi06
         END IF
      
      AFTER FIELD hrbi08
         IF NOT cl_null(g_hrbi.hrbi08) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrap_file 
         	   WHERE hrap01=g_hrbi.hrbi06
         	     AND hrap05=g_hrbi.hrbi08
         	     AND hrapacti='Y'
         	  IF l_n=0 THEN
         	  	 CALL cl_err('此职位还未配置到所选部门下,请检查','!',0)
         	  	 NEXT FIELD hrbi08
         	  END IF
         	  
         	  SELECT hras04 INTO l_hrbi08_desc FROM hras_file
         	   WHERE hras01=g_hrbi.hrbi08
         	  DISPLAY l_hrbi08_desc TO hrbi08_desc
         	
         END IF     	 	        		     	
      AFTER FIELD ta_hrbi01 
         IF NOT cl_null(g_hrbi.ta_hrbi01) THEN 
          	LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hraf_file 
         	   WHERE hraf01=g_hrbi.ta_hrbi01
         	  IF l_n=0 THEN
         	  	 CALL cl_err('工作城市不存在,请检查','!',0)
         	  	 NEXT FIELD ta_hrbi01
         	  END IF                 
            SELECT hraf02 INTO l_ta_hrbi01_desc FROM hraf_file
             WHERE hraf01=g_hrbi.ta_hrbi01
            DISPLAY l_ta_hrbi01_desc TO ta_hrbi01_desc  
         END IF      	
      AFTER FIELD hrbi09 
         IF NOT cl_null(g_hrbi.hrbi09) THEN
         	  LET l_n=0
#         	  SELECT COUNT(*) INTO l_n FROM hrai_file 
#         	   WHERE hrai03=g_hrbi.hrbi09
#         	     AND hraiacti='Y'
             SELECT COUNT(*) INTO l_n FROM hrag_file 
              WHERE hrag06=g_hrbi.hrbi09 AND hrag01='313' 
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此员工属性','!',0)
         	  	 NEXT FIELD hrbi09
         	  END IF
         	  	
         	  SELECT hrag07 INTO l_hrbi09_desc FROM hrag_file
         	   WHERE hrag06=g_hrbi.hrbi09 AND hrag01='313'
         	  DISPLAY l_hrbi09_desc TO hrbi09_desc
         END IF	     	 	      	             	  	   	 	                                             	    		  	      	

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         

      ON ACTION controlp
        CASE
           WHEN INFIELD(hrbi01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbh01"
              LET g_qryparam.default1 = g_hrbi.hrbi01
              CALL cl_create_qry() RETURNING g_hrbi.hrbi01
              DISPLAY BY NAME g_hrbi.hrbi01
              NEXT FIELD hrbi01
#add by zhuzw 20150319 str
          WHEN INFIELD(ta_hrbi02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat01"
              LET g_qryparam.where = "hrat07 = 'Y' "
              LET g_qryparam.default1 = g_hrbi.ta_hrbi02
              CALL cl_create_qry() RETURNING g_hrbi.ta_hrbi02
              DISPLAY BY NAME g_hrbi.ta_hrbi02
              NEXT FIELD ta_hrbi02
#add end            
           WHEN INFIELD(hrbi06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrao01_1"
              LET g_qryparam.default1 = g_hrbi.hrbi06
              CALL cl_create_qry() RETURNING g_hrbi.hrbi06
              DISPLAY BY NAME g_hrbi.hrbi06
              NEXT FIELD hrbi06
              
           WHEN INFIELD(hrbi07)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrad02"
              LET g_qryparam.default1 = g_hrbi.hrbi07
              CALL cl_create_qry() RETURNING g_hrbi.hrbi07
              DISPLAY BY NAME g_hrbi.hrbi07
              NEXT FIELD hrbi07
           
           WHEN INFIELD(hrbi08)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrap01"
              LET g_qryparam.arg1 = g_hrbi.hrbi06
              LET g_qryparam.default1 = g_hrbi.hrbi08
              CALL cl_create_qry() RETURNING g_hrbi.hrbi08
              DISPLAY BY NAME g_hrbi.hrbi08
              NEXT FIELD hrbi08
          WHEN INFIELD(ta_hrbi01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraf01"
              LET g_qryparam.default1 = g_hrbi.ta_hrbi01
              CALL cl_create_qry() RETURNING g_hrbi.ta_hrbi01
              DISPLAY BY NAME g_hrbi.ta_hrbi01
              NEXT FIELD ta_hrbi01              
          WHEN INFIELD(ta_hrbi06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrar03_zw"
              LET g_qryparam.default1 = g_hrbi.ta_hrbi06
              CALL cl_create_qry() RETURNING g_hrbi.ta_hrbi06
              DISPLAY BY NAME g_hrbi.ta_hrbi06
              NEXT FIELD ta_hrbi06 
           WHEN INFIELD(hrbi09)
              CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_hrai031"
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.arg1 = '313'
              LET g_qryparam.default1 = g_hrbi.hrbi09
              CALL cl_create_qry() RETURNING g_hrbi.hrbi09
              DISPLAY BY NAME g_hrbi.hrbi09
              NEXT FIELD hrbi09
           

           OTHERWISE
              EXIT CASE
           END CASE

      ON ACTION CONTROLZ
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
END FUNCTION

FUNCTION i026_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrbi.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i026_curs()                      
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i026_count
    FETCH i026_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i026_cs                           
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrbi.hrbi01,SQLCA.sqlcode,0)
        INITIALIZE g_hrbi.* TO NULL
    ELSE
        CALL i026_fetch('F')              # 讀出TEMP第一筆並顯示
        CALL i026_b_fill(g_wc)
    END IF
END FUNCTION	
	
FUNCTION i026_fetch(p_flhrbi)
    DEFINE p_flhrbi         LIKE type_file.chr1

    CASE p_flhrbi
        WHEN 'N' FETCH NEXT     i026_cs INTO g_hrbi.hrbi01,g_hrbi.hrbi05
        WHEN 'P' FETCH PREVIOUS i026_cs INTO g_hrbi.hrbi01,g_hrbi.hrbi05
        WHEN 'F' FETCH FIRST    i026_cs INTO g_hrbi.hrbi01,g_hrbi.hrbi05
        WHEN 'L' FETCH LAST     i026_cs INTO g_hrbi.hrbi01,g_hrbi.hrbi05
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()

                  ON ACTION about
                     CALL cl_about()

                  ON ACTION help
                     CALL cl_show_help()

                  ON ACTION controlg
                     CALL cl_cmdask()

               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i026_cs INTO g_hrbi.hrbi01,g_hrbi.hrbi05
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrbi.hrbi01,SQLCA.sqlcode,0)
        INITIALIZE g_hrbi.* TO NULL
        LET g_hrbi.hrbi01 = NULL
        RETURN
    ELSE
      CASE p_flhrbi
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hrbi.* FROM hrbi_file    
     WHERE hrbi01 = g_hrbi.hrbi01 AND hrbi05 =g_hrbi.hrbi05
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrbi_file",g_hrbi.hrbi01,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL i026_show()
    END IF
END FUNCTION
	
FUNCTION i026_show()
DEFINE l_hratid   LIKE    hrat_file.hratid
DEFINE l_hrat02         LIKE hrat_file.hrat02
DEFINE l_hrat03         LIKE hrat_file.hrat03
DEFINE l_hrat03_desc    LIKE hraa_file.hraa12
DEFINE l_hrat04         LIKE hrat_file.hrat04
DEFINE l_hrat04_desc    LIKE hrao_file.hrao02
DEFINE l_hrat05         LIKE hrat_file.hrat05
DEFINE l_hrat05_desc    LIKE hrap_file.hrap06
DEFINE l_hrat17         LIKE hrat_file.hrat17
DEFINE l_hrat17_desc    LIKE hrag_file.hrag07
DEFINE l_hrat22         LIKE hrat_file.hrat22
DEFINE l_hrat22_desc    LIKE hrag_file.hrag07
DEFINE l_hrat42         LIKE hrat_file.hrat42
DEFINE l_hrat42_desc    LIKE hrai_file.hrai04
DEFINE l_hrat15         LIKE hrat_file.hrat15
DEFINE l_hrat25         LIKE hrat_file.hrat25
DEFINE l_hrbh04         LIKE hrbh_file.hrbh04
DEFINE l_hrbi06_desc    LIKE hrao_file.hrao02
DEFINE l_hrbi07_desc    LIKE hrad_file.hrad03
DEFINE l_hrbi08_desc    LIKE hras_file.hras04
DEFINE l_ta_hrbi01_desc    LIKE hras_file.hras04
DEFINE l_hrbi09_desc    LIKE hrai_file.hrai04
DEFINE l_hrao00         LIKE hrao_file.hrao00
DEFINE l_hrao00_desc    LIKE hraa_file.hraa12
DEFINE l_ta_hrbi02_n    LIKE hrat_file.hrat02 #add by zhuzw 20150319
DEFINE l_hrbh03         LIKE hrbh_file.hrbh03
DEFINE l_hrat13         LIKE hrat_file.hrat13 #add by wangwy 20170209
DEFINE l_ta_hrbi06_n,l_ta_hrbi05_n    LIKE hrar_file.hrar04
    LET l_hratid = g_hrbi.hrbi01 #提前锁定id
    #SELECT hrat01 INTO g_hrbi.hrbi01 FROM hrat_file WHERE hratid=g_hrbi.hrbi01  #找到新工号
    LET g_hrbi.hrbi01 = g_hrbi.hrbiud02
   #  SELECT hrbiud02 INTO g_hrbi.hrbi01 FROM hrbi_file WHERE hrbi01 = g_hrbi.hrbi01 
    
    SELECT hrat01 INTO g_hrbi.ta_hrbi02 FROM hrat_file WHERE hratid=g_hrbi.ta_hrbi02  #add by zhuzw 20150319
    LET g_hrbi_t.* = g_hrbi.*
    DISPLAY BY NAME g_hrbi.hrbi01,g_hrbi.hrbi03,g_hrbi.hrbi04,g_hrbi.hrbi05,
                    g_hrbi.hrbi06,g_hrbi.hrbi07,g_hrbi.hrbi08,g_hrbi.hrbi09,
                    g_hrbi.hrbi10,g_hrbi.ta_hrbi01,g_hrbi.hrbi11,g_hrbi.hrbi12,g_hrbi.hrbi13,
                    g_hrbi.hrbi14,g_hrbi.hrbi15,g_hrbi.hrbiconf,
                    g_hrbi.hrbiuser,g_hrbi.hrbigrup,g_hrbi.hrbimodu,g_hrbi.ta_hrbi06,g_hrbi.ta_hrbi05,
                    g_hrbi.hrbidate,g_hrbi.hrbiorig,g_hrbi.hrbioriu,g_hrbi.ta_hrbi02,g_hrbi.ta_hrbi03,g_hrbi.ta_hrbi04,
                    g_hrbi.hrbiud02, g_hrbi.hrbiud03, g_hrbi.hrbiud04, g_hrbi.hrbiud05, g_hrbi.hrbiud06, g_hrbi.hrbiud07,
                    g_hrbi.hrbiud08, g_hrbi.hrbiud09, g_hrbi.hrbiud10, g_hrbi.hrbiud11, g_hrbi.hrbiud12, g_hrbi.hrbiud13,
                    g_hrbi.hrbiud14, g_hrbi.hrbiud15   #add by hourf  13/05/16
                    
   #姓名,部门编号,职位编号,直接主管,性别,学历,员工状态,成本中心,入职日期
   #SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrbi.hrbi01
   SELECT MAX(hrbh03) INTO l_hrbh03 FROM hrbh_file WHERE hrbh01 = l_hratid
   AND hrbh11 <= g_hrbi.hrbi05  # hui ping ri qi zhi qian zui da de li zhi ri qi --> add by wangwy 2017-02-09
   SELECT a.hrat02,hrbhud02,hraa02,hrbhud03,b.hrao02,hrbhud04,c.hras04,a.hrat17,e.hrag07,a.hrat22,f.hrag07,hrbhud06,h.hrag07,hrbhud13,hrbh11,hrat15,a.hrat13 #add ",a.hrat13" by wangwy 20170209
   INTO l_hrat02,l_hrat03,l_hrat03_desc,l_hrat04,l_hrat04_desc,l_hrat05,l_hrat05_desc,l_hrat17,l_hrat17_desc,l_hrat22,l_hrat22_desc,l_hrat42,l_hrat42_desc,l_hrat25,l_hrbh04,l_hrat15,l_hrat13 #add ",l_hrat13" by wangwy 20170209
   FROM hrbh_file 
   LEFT join hraa_file ON hraa01 = hrbhud02
   LEFT join hrat_file a ON a.hratid = hrbh01
   LEFT JOIN hrao_file b ON hrao01=hrbhud03
   LEFT JOIN hras_file c ON hras01=hrbhud04
   LEFT JOIN hrag_file e ON e.hrag06=a.hrat17 AND e.hrag01='333'
   LEFT JOIN hrag_file f ON f.hrag06=a.hrat22 AND f.hrag01='317'
   #LEFT JOIN hrai_file h ON h.hrai03=hrbhud06
   LEFT join hrag_file h ON h.hrag06=hrbhud06 AND h.hrag01='313'
   WHERE a.hratid=l_hratid AND hrbh03 = l_hrbh03
   SELECT hrar04 INTO l_ta_hrbi06_n FROM hrar_file
    WHERE hrar03=g_hrbi.ta_hrbi06
   SELECT hrar04 INTO l_ta_hrbi05_n FROM hrar_file
    WHERE hrar03=g_hrbi.ta_hrbi05
   DISPLAY l_ta_hrbi06_n TO ta_hrbi06_n   
   DISPLAY l_ta_hrbi05_n TO ta_hrbi05_n   
   DISPLAY l_hrat02 TO hrat02
   DISPLAY l_hrat04 TO hrat04
   DISPLAY l_hrat04_desc TO hrat04_desc
   DISPLAY l_hrat05 TO hrat05
   DISPLAY l_hrat05_desc TO hrat05_desc
   DISPLAY l_hrat03 TO hrat03
   DISPLAY l_hrat03_desc TO hrat03_desc
   DISPLAY l_hrat17 TO hrat17
   DISPLAY l_hrat17_desc TO hrat17_desc
   DISPLAY l_hrat22 TO hrat22
   DISPLAY l_hrat22_desc TO hrat22_desc
   DISPLAY l_hrat42 TO hrat42
   DISPLAY l_hrat42_desc TO hrat42_desc
   DISPLAY l_hrat15 TO hrat15
   DISPLAY l_hrat25 TO hrat25
   DISPLAY l_hrbh04 TO hrbh04 
   DISPLAY l_hrat13 TO hrat13 #add by wangwy 20170209
   
   SELECT hrao02 INTO l_hrbi06_desc FROM hrao_file
    WHERE hrao01=g_hrbi.hrbi06
      AND hraoacti='Y'
   DISPLAY l_hrbi06_desc TO hrbi06_desc  
   
   SELECT hrao00,hraa12 INTO l_hrao00,l_hrao00_desc FROM hrao_file,hraa_file
    WHERE hraa01=hrao00
      AND hrao01=g_hrbi.hrbi06
   DISPLAY l_hrao00 TO hrao00
   DISPLAY l_hrao00_desc TO hrao00_desc  
   
   SELECT hrad03 INTO l_hrbi07_desc FROM hrad_file
    WHERE hrad02=g_hrbi.hrbi07
   DISPLAY l_hrbi07_desc TO hrbi07_desc
   
   SELECT hras04 INTO l_hrbi08_desc FROM hras_file
    WHERE hras01=g_hrbi.hrbi08
   DISPLAY l_hrbi08_desc TO hrbi08_desc
   SELECT hraf02 INTO l_ta_hrbi01_desc FROM hraf_file
    WHERE hraf01=g_hrbi.ta_hrbi01
   DISPLAY l_ta_hrbi01_desc TO ta_hrbi01_desc   
#   SELECT hrai04 INTO l_hrbi09_desc FROM hrai_file
#    WHERE hrai03=g_hrbi.hrbi09
#      AND hraiacti='Y'
   SELECT hrag07 INTO l_hrbi09_desc FROM hrag_file 
    WHERE hrag06=g_hrbi.hrbi09 AND hrag01='313'
   DISPLAY l_hrbi09_desc TO hrbi09_desc
                    
   CALL cl_show_fld_cont()
END FUNCTION	
	
FUNCTION i026_u()
DEFINE  l_hratid    LIKE   hrat_file.hratid
    IF g_hrbi.hrbi01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #SELECT * INTO g_hrbi.* FROM hrbi_file WHERE hrbi01=g_hrbi.hrbi01
    IF g_hrbi.hrbiconf != 'N' THEN
        CALL cl_err('资料已审核,不可更改','!',0)
        RETURN
    END IF
    CALL cl_opmsg('u')
    BEGIN WORK
    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbi.hrbi01
    OPEN i026_cl USING l_hratid,g_hrbi_t.hrbi05
    IF STATUS THEN
       CALL cl_err("OPEN i026_cl:", STATUS, 1)
       CLOSE i026_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i026_cl INTO g_hrbi.*               #
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbi.hrbi01,SQLCA.sqlcode,1)
        RETURN
    END IF              
    CALL i026_show()                          
    WHILE TRUE
        CALL i026_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrbi.*=g_hrbi_t.*
            CALL i026_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_hrbi.hrbimodu=g_user
        LET g_hrbi.hrbidate=g_today	
        UPDATE hrbi_file SET hrbi03 = g_hrbi.hrbi03,
                             hrbi04 = g_hrbi.hrbi04,
                             hrbi05 = g_hrbi.hrbi05,
                             hrbi06 = g_hrbi.hrbi06,
                             hrbi07 = g_hrbi.hrbi07,
                             hrbi08 = g_hrbi.hrbi08,
                             hrbi09 = g_hrbi.hrbi09,
                             hrbi10 = g_hrbi.hrbi10,
                             ta_hrbi01 = g_hrbi.hrbi01,
                             hrbi11 = g_hrbi.hrbi11,
                             hrbi12 = g_hrbi.hrbi12,
                             hrbi13 = g_hrbi.hrbi13,
                             hrbi14 = g_hrbi.hrbi14,
                             hrbi15 = g_hrbi.hrbi15,
                             ta_hrbi06 = g_hrbi.ta_hrbi06,
                             hrbimodu = g_hrbi.hrbimodu,
                             hrbidate = g_hrbi.hrbidate    
         WHERE hrbi01 = l_hratid
           AND hrbi05 = g_hrbi_t.hrbi05
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrbi_file",g_hrbi.hrbi01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        CALL i026_show()	
        EXIT WHILE
    END WHILE
    CLOSE i026_cl
    COMMIT WORK
    CALL i026_b_fill(g_wc)    #add by zhangbo130904
END FUNCTION	
	
FUNCTION i026_r()
DEFINE l_hratid    LIKE   hrat_file.hratid	
    IF g_hrbi.hrbi01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    	
    IF g_hrbi.hrbiconf != 'N' THEN
        CALL cl_err('资料已审核,不可删除','!',0)
        RETURN
    END IF	
    BEGIN WORK
    
    IF g_hrbi.hrbiconf = 'Y' THEN 
      SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbi.hrbi04
    ELSE 
      SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbi.hrbi01
    END IF 

    OPEN i026_cl USING l_hratid,g_hrbi_t.hrbi05
    IF STATUS THEN
       CALL cl_err("OPEN i026_cl:", STATUS, 0)
       CLOSE i026_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i026_cl INTO g_hrbi.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbi.hrbi01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i026_show()
    IF cl_delete() THEN
       CALL cl_del_doc()
       DELETE FROM hrbi_file WHERE hrbi01 = l_hratid AND hrbi05 = g_hrbi_t.hrbi05
       CLEAR FORM
       OPEN i026_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i026_cl
          CLOSE i026_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i026_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i026_cl
          CLOSE i026_count
          COMMIT WORK
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i026_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i026_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i026_fetch('/')
       END IF
    END IF
    CLOSE i026_cl
    COMMIT WORK
    CALL i026_b_fill(g_wc)        #add by zhangbo130904
END FUNCTION
	
FUNCTION i026_confirm()
   DEFINE l_hrbiconf      LIKE hrbi_file.hrbiconf
   DEFINE l_msg           STRING
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_hratid        LIKE hrat_file.hratid
   DEFINE l_hrbimodu      LIKE hrbi_file.hrbimodu
   DEFINE l_hrbidate      LIKE hrbi_file.hrbidate 
   DEFINE l_hrat          RECORD LIKE hrat_file.* 
   DEFINE l_flag          LIKE type_file.chr1 
   DEFINE l_hraa10        LIKE hraa_file.hraa10
   #还原备份
   DEFINE l_jhrat01       LIKE hrat_file.hrat01
   DEFINE l_jhrat03       LIKE hrat_file.hrat03
   DEFINE l_jhrat04       LIKE hrat_file.hrat04
   DEFINE l_jhrat05       LIKE hrat_file.hrat05
   DEFINE l_jhrat19       LIKE hrat_file.hrat19
   DEFINE l_jhrat25       LIKE hrat_file.hrat25
   DEFINE l_jhrat20       LIKE hrat_file.hrat20
   DEFINE l_jhrat77       LIKE hrat_file.hrat77
   DEFINE l_jhrat40       LIKE hrat_file.hrat40
   DEFINE l_jhrat06       LIKE hrat_file.hrat06
   DEFINE l_jhrat09       LIKE hrat_file.hrat09
   #end

    IF cl_null(g_hrbi.hrbi01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
  
    IF g_hrbi.hrbiconf !='N' THEN
       CALL cl_err('资料已审核或者已归档,不可再次审核','!',1)
       LET g_success='N'
       RETURN
    END IF

    LET l_hrbimodu = g_hrbi.hrbimodu
    LET l_hrbidate = g_hrbi.hrbidate

    BEGIN WORK
    
    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbi.hrbi01
    OPEN i026_cl USING l_hratid,g_hrbi_t.hrbi05
    IF STATUS THEN
       CALL cl_err("open i026_cl:",STATUS,1)
       CLOSE i026_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH i026_cl INTO g_hrbi.*
    IF SQLCA.sqlcode  THEN
      CALL cl_err(l_hratid,SQLCA.sqlcode,0)
      CLOSE i026_cl
      ROLLBACK WORK
      RETURN
    END IF
   
   CALL i026_show()
   
   IF NOT cl_confirm("是否确定审核?") THEN
   ELSE
#      #存储还原数据add by wangwy 20170228 
      SELECT hrat01,hrat03,hrat04,hrat05,hrat19,hrat25,hrat20,hrat77,hrat40,hrat06,hrat09
       INTO l_jhrat01,l_jhrat03,l_jhrat04,l_jhrat05,l_jhrat19,l_jhrat25,l_jhrat20,l_jhrat77,l_jhrat40,l_jhrat06,l_jhrat09
        FROM hrat_file WHERE hrat01 = g_hrbi.hrbi01 #存储旧工号
      
      UPDATE hrbi_file SET hrbiud16 = l_jhrat03, #公司
                           hrbiud17 = l_jhrat04, #部门
                           hrbiud18 = l_jhrat05, #职位
                           hrbiud19 = l_jhrat19, #员工状态
                           hrbiud20 = l_jhrat25, #入司日期
                           hrbiud21 = l_jhrat20, #员工属性
                           hrbiud22 = l_jhrat77, #最后工作日
                           hrbiud23 = l_jhrat40, #工作地点
                           hrbiud24 = l_jhrat06, #直属主管
                           hrbiud25 = l_jhrat09  #编制否
         WHERE hrbi01 = l_hratid
           AND hrbi05 = g_hrbi_t.hrbi05
           
      
      #end
      LET l_hrat.hrat01=g_hrbi.hrbi04 #新工号
   	  #add by zhuzw 20150319 str
   	  LET l_hrat.hrat06=g_hrbi.ta_hrbi02
   	  LET l_hrat.hrat09=g_hrbi.ta_hrbi03
   	  #add end 
   	  LET l_hrat.hrat04=g_hrbi.hrbi06
   	  LET l_hrat.hrat05=g_hrbi.hrbi08
   	  LET l_hrat.hrat19=g_hrbi.hrbi07
   	  LET l_hrat.hrat25=g_hrbi.hrbi05
   	  LET l_hrat.hrat42=g_hrbi.hrbi09
   	  LET l_hrat.hrat40 = g_hrbi.ta_hrbi01
   	  SELECT to_date('20991231','yyyymmdd') INTO l_hrat.hrat77 FROM dual
   	    SELECT hrao00 INTO l_hrat.hrat03 FROM hrao_file
             WHERE hrao01=g_hrbi.hrbi06
#   	  SELECT hrat02,hrat12,hrat13,hrat14,hrat15,hrat17,hrat21,hrat22 
#   	    INTO l_hrat.hrat02,l_hrat.hrat12,l_hrat.hrat13,l_hrat.hrat14,
#   	         l_hrat.hrat15,l_hrat.hrat17,l_hrat.hrat21,l_hrat.hrat22 
#   	    FROM hrat_file 
#   	   WHERE hratid=l_hratid
#   	  CALL i006_logic_default('A',l_hrat.*) RETURNING l_hrat.*
#   	  CALL i006_logic_default('B',l_hrat.*) RETURNING l_hrat.*
#   	  SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01=l_hrat.hrat03
#   	  CALL hr_gen_no('hrat_file','hrat01','009',l_hrat.hrat03,l_hraa10)
#   	     RETURNING l_hrat.hrat01,l_flag
#   	  
#   	  INSERT INTO hrat_file VALUES (l_hrat.*)
         UPDATE hrat_file SET 
            hrat01=l_hrat.hrat01,
            hrat03=l_hrat.hrat03,
            hrat04=l_hrat.hrat04,
            hrat05=l_hrat.hrat05,
            hrat19=l_hrat.hrat19,
            hrat25=l_hrat.hrat25,
            hrat20=l_hrat.hrat42,
            hrat77=l_hrat.hrat77,
            hrat40 = l_hrat.hrat40,
            hrat06 = l_hrat.hrat06,
            hrat09 = l_hrat.hrat09,
            hrat60 = g_hrbi.ta_hrbi06
         WHERE hratid=l_hratid
   	  
   	  IF SQLCA.sqlcode THEN
   	  	 CALL cl_err('ins hrat',SQLCA.sqlcode,0)
   	  	 CLOSE i026_cl
         ROLLBACK WORK
         RETURN
      END IF      	  	    
   	  
   	  LET g_hrbi.hrbi02=l_hrat.hratid
   	  LET g_hrbi.hrbi04=l_hrat.hrat01
      LET g_hrbi.hrbiconf = 'Y'
      LET g_hrbi.hrbimodu = g_user
      LET g_hrbi.hrbidate = g_today

      UPDATE hrbi_file
         SET hrbi02 = g_hrbi.hrbi02,
             hrbi04 = g_hrbi.hrbi04,
             hrbiconf = g_hrbi.hrbiconf,
             hrbimodu = g_hrbi.hrbimodu,
             hrbidate = g_hrbi.hrbidate
       WHERE hrbi01 = l_hratid
         AND hrbi05= g_hrbi_t.hrbi05
       
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('upd hrbi:',SQLCA.SQLCODE,0)
          LET g_hrbi.hrbi02=''
          LET g_hrbi.hrbi04=''
          LET g_hrbi.hrbiconf = "N"
          LET g_hrbi.hrbimodu = l_hrbimodu
          LET g_hrbi.hrbidate = l_hrbidate
          DISPLAY BY NAME g_hrbi.hrbi04,g_hrbi.hrbiconf,g_hrbi.hrbimodu,g_hrbi.hrbidate
          CLOSE i026_cl
          ROLLBACK WORK
          RETURN
       ELSE
          DISPLAY BY NAME g_hrbi.hrbi04,g_hrbi.hrbiconf,g_hrbi.hrbimodu,g_hrbi.hrbidate
       END IF
   END IF
   CLOSE i026_cl
   COMMIT WORK
   CALL i026_b_fill(g_wc)       #add by zhangbo130904
END FUNCTION
	
FUNCTION i026_undo_confirm()
	 DEFINE l_hrbiconf      LIKE hrbi_file.hrbiconf
   DEFINE l_msg           STRING
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_hratid        LIKE hrat_file.hratid
   DEFINE l_hrbimodu      LIKE hrbi_file.hrbimodu
   DEFINE l_hrbidate      LIKE hrbi_file.hrbidate
   DEFINE l_hrbi02        LIKE hrbi_file.hrbi02
   DEFINE l_hrbi04        LIKE hrbi_file.hrbi04
   DEFINE l_hratconf      LIKE hrat_file.hratconf
   #还原备份
   DEFINE l_jhrat01       LIKE hrat_file.hrat01
   DEFINE l_jhrat03       LIKE hrat_file.hrat03
   DEFINE l_jhrat04       LIKE hrat_file.hrat04
   DEFINE l_jhrat05       LIKE hrat_file.hrat05
   DEFINE l_jhrat19       LIKE hrat_file.hrat19
   DEFINE l_jhrat25       LIKE hrat_file.hrat25
   DEFINE l_jhrat20       LIKE hrat_file.hrat20
   DEFINE l_jhrat77       LIKE hrat_file.hrat77
   DEFINE l_jhrat40       LIKE hrat_file.hrat40
   DEFINE l_jhrat06       LIKE hrat_file.hrat06
   DEFINE l_jhrat09       LIKE hrat_file.hrat09
   #end

    IF cl_null(g_hrbi.hrbi01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
  
    IF g_hrbi.hrbiconf !='Y' THEN
       CALL cl_err('资料还未审核,不可再次审核','!',1)
       LET g_success='N'
       RETURN
    ELSE
    	 IF NOT cl_null(g_hrbi.hrbi02) THEN
    	    SELECT hratconf INTO l_hratconf FROM hrat_file 
    	     WHERE hratid=g_hrbi.hrbi02
    	    IF l_hratconf='Y' THEN
    	    	 CALL cl_err('回聘的新员工已审核,回聘申请不可取消审核','!',0)
    	    	 LET g_success='N'
             RETURN 
          END IF
       END IF   	        
    END IF
    	
    	
    LET l_hrbi02 = g_hrbi.hrbi02
    LET l_hrbi04 = g_hrbi.hrbi04
    LET l_hrbimodu = g_hrbi.hrbimodu
    LET l_hrbidate = g_hrbi.hrbidate

    BEGIN WORK
    
    #SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbi.hrbi01
    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbi.hrbi04
    OPEN i026_cl USING l_hratid,g_hrbi_t.hrbi05
    IF STATUS THEN
       CALL cl_err("open i026_cl:",STATUS,1)
       CLOSE i026_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH i026_cl INTO g_hrbi.*
    IF SQLCA.sqlcode  THEN
      CALL cl_err(l_hratid,SQLCA.sqlcode,0)
      CLOSE i026_cl
      ROLLBACK WORK
      RETURN
    END IF
   
   CALL i026_show()
   
   IF NOT cl_confirm("是否确定取消审核?") THEN
   ELSE
      #抓取备份资料 add by wangwy 20170228
      SELECT hrbiud02,hrbiud16,hrbiud17,hrbiud18,hrbiud19,hrbiud20,hrbiud21,hrbiud22,hrbiud23,hrbiud24,hrbiud25 
       INTO l_jhrat01,l_jhrat03,l_jhrat04,l_jhrat05,l_jhrat19,l_jhrat25,l_jhrat20,l_jhrat77,l_jhrat40,l_jhrat06,l_jhrat09
       FROM hrbi_file
        WHERE hrbiud02 = g_hrbi.hrbi01
      #end
#   	  DELETE FROM hrat_file WHERE hratid=g_hrbi.hrbi02
      UPDATE hrat_file SET hrat01 = l_jhrat01,
                           hrat03 = l_jhrat03,
                           hrat04 = l_jhrat04,
                           hrat05 = l_jhrat05,
                           hrat19 = l_jhrat19,
                           hrat25 = l_jhrat25,
                           hrat20 = l_jhrat20,
                           hrat77 = l_jhrat77,
                           hrat40 = l_jhrat40,
                           hrat06 = l_jhrat06,
                           hrat09 = l_jhrat09,
                           hrat60 = g_hrbi.ta_hrbi04
        WHERE hrat01 = g_hrbi.hrbi04
   	  IF SQLCA.sqlcode THEN
   	  	 CALL cl_err('del hrat_file',SQLCA.sqlcode,0)
   	  	 CLOSE i026_cl
         ROLLBACK WORK
         RETURN
      END IF
      	
#      LET g_hrbi.hrbi02 = ''
#      LET g_hrbi.hrbi04 = ''	
      LET g_hrbi.hrbiconf = 'N'
      LET g_hrbi.hrbimodu = g_user
      LET g_hrbi.hrbidate = g_today

      UPDATE hrbi_file
         SET hrbi02 = g_hrbi.hrbi02,
             hrbi04 = g_hrbi.hrbi04,
             hrbiconf = g_hrbi.hrbiconf,
             hrbimodu = g_hrbi.hrbimodu,
             hrbidate = g_hrbi.hrbidate
       WHERE hrbi01 = l_hratid
         AND hrbi05 = g_hrbi_t.hrbi05
       
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('upd hrbi:',SQLCA.SQLCODE,0)
          LET g_hrbi.hrbiconf = "Y"
          LET g_hrbi.hrbi02 = l_hrbi02
          LET g_hrbi.hrbi04 = l_hrbi04
          LET g_hrbi.hrbimodu = l_hrbimodu
          LET g_hrbi.hrbidate = l_hrbidate
          DISPLAY BY NAME g_hrbi.hrbi04,g_hrbi.hrbiconf,g_hrbi.hrbimodu,g_hrbi.hrbidate
          CLOSE i026_cl
          ROLLBACK WORK
          RETURN
       ELSE
          DISPLAY BY NAME g_hrbi.hrbi04,g_hrbi.hrbiconf,g_hrbi.hrbimodu,g_hrbi.hrbidate
       END IF
   END IF
   CLOSE i026_cl
   COMMIT WORK
   CALL i026_b_fill(g_wc)       #add by zhangbo130904
END FUNCTION		
	
PRIVATE FUNCTION i026_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("hrbi01",TRUE)
   END IF
END FUNCTION


PRIVATE FUNCTION i026_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'u' THEN
      CALL cl_set_comp_entry("hrbi01",FALSE)
   END IF
END FUNCTION
	
FUNCTION i026_b_fill(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5

        CALL g_hrbi_1.clear()

#        LET l_sql=" SELECT hrbi01,hrbi04,'','',hrbi06,'',hrbi08,'', ",
#                  "        hrbi07,'',hrbi09,'',hrbiconf,hrbi03,hrbi05, ",
#                  "        hrbi10,hrbi11,hrbi12,hrbi13,hrbi14,hrbi15 ",  
#                  "   FROM hrbi_file WHERE ",p_wc CLIPPED,
#                  "  ORDER BY hrbi01 "
        LET l_sql=" SELECT distinct hrbi01,hrbiud02,hrat02,hrag07,hrbi04,'','',hrbi06,'',hrbi08,'', ",
                  "        hrbi07,'',hrbi09,'',hrbiconf,hrbi03,hrbi05, ",
                  "        hrbi10,hrbi11,hrbi12,hrbi13,hrbi14,hrbi15,ta_hrbi05,'',ta_hrbi06,'' ",  
                  "   FROM hrbi_file left join hrat_file on hratid=hrbi01 left join hrbh_file on hrbh01=hrbi01 left join hrag_file on hrag06=hrbhud06 and hrag01='313' WHERE ",p_wc CLIPPED,
                  "  ORDER BY hrbi01 "

        PREPARE i026_b_pre FROM l_sql
        DECLARE i026_b_cs CURSOR FOR i026_b_pre

        LET l_i=1

        FOREACH i026_b_cs INTO g_hrbi_1[l_i].*
           SELECT hrar04 INTO g_hrbi_1[l_i].ta_hrbi05_1 FROM hrar_file
            WHERE hrar03=g_hrbi_1[l_i].ta_hrbi05
           SELECT hrar04 INTO g_hrbi_1[l_i].ta_hrbi06_1 FROM hrar_file
            WHERE hrar03=g_hrbi_1[l_i].ta_hrbi06           
           SELECT hrao00 INTO g_hrbi_1[l_i].hrao00 FROM hrao_file 
            WHERE hrao01=g_hrbi_1[l_i].hrbi06
           SELECT hraa12 INTO g_hrbi_1[l_i].hraa12 FROM hraa_file
            WHERE hraa01=g_hrbi_1[l_i].hrao00
           SELECT hrao02 INTO g_hrbi_1[l_i].hrao02 FROM hrao_file 
            WHERE hrao01=g_hrbi_1[l_i].hrbi06
           SELECT hras04 INTO g_hrbi_1[l_i].hras04 FROM hras_file
            WHERE hras01=g_hrbi_1[l_i].hrbi08
           SELECT hrad03 INTO g_hrbi_1[l_i].hrad03 FROM hrad_file 
            WHERE hrad02=g_hrbi_1[l_i].hrbi07
#           SELECT hrai04 INTO g_hrbi_1[l_i].hrai04 FROM hrai_file
#            WHERE hrai03=g_hrbi_1[l_i].hrbi09    
           SELECT hrag07 INTO g_hrbi_1[l_i].hrai04 FROM hrag_file
            WHERE hrag06=g_hrbi_1[l_i].hrbi09 AND hrag01='313'

           LET l_i=l_i+1

           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrbi_1.deleteElement(l_i)
        LET g_rec_b = l_i - 1

END FUNCTION	
	
FUNCTION i026_b_menu()
   DEFINE   l_cmd     LIKE type_file.chr1000


   WHILE TRUE

      CALL i026_bp("G")

      IF NOT cl_null(g_action_choice) AND l_ac>0 THEN #將清單的資料回傳到主畫面
         SELECT hrar_file.*
           INTO g_hrbi.*
           FROM hrbi_file
          WHERE hrbi01=g_hrbi_1[l_ac].hrbi01
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'Page4'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i026_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page5", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page5", TRUE)
      END IF				
	    
	    CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN    #cl_prichk('A') THEN
               CALL i026_a()
            END IF
            EXIT WHILE

        WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i026_q()
            END IF
            EXIT WHILE

        WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i026_r()
            END IF

        WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i026_u()
            END IF
            EXIT WHILE
        
        WHEN "ghr_confirm"
           LET g_action_choice="ghr_confirm"
           IF cl_chk_act_auth() THEN
              CALL i026_confirm()
           END IF
        
        WHEN "ghr_undo_confirm"
           LET g_action_choice="ghr_undo_confirm"
           IF cl_chk_act_auth() THEN
              CALL i026_undo_confirm()
           END IF    	
        
        #原离职基本信息    	
        WHEN "ghri026_a"
           LET g_action_choice="ghri026_a"
           IF cl_chk_act_auth() THEN
           	  LET g_hratid=''
           	  SELECT hratid INTO g_hratid FROM hrat_file WHERE hrat01=g_hrbi.hrbi04
              LET g_msg="ghri025 '",g_hratid,"'"
              CALL cl_cmdrun_wait(g_msg)
           END IF
           
        
        #部门面谈信息
        WHEN "ghri026_b"
           LET g_action_choice="ghri026_b"
           IF cl_chk_act_auth() THEN
           	  LET g_hratid=''
           	  SELECT hratid INTO g_hratid FROM hrat_file WHERE hrat01=g_hrbi.hrbi04
              LET g_msg="ghri025_2 '",g_hratid,"'"
              CALL cl_cmdrun_wait(g_msg)
           END IF
           	
        #人资面谈信息
        WHEN "ghri026_c"
           LET g_action_choice="ghri026_c"
           IF cl_chk_act_auth() THEN
           	  LET g_hratid=''
           	  SELECT hratid INTO g_hratid FROM hrat_file WHERE hrat01=g_hrbi.hrbi04
              LET g_msg="ghri025_3 '",g_hratid,"'"
              CALL cl_cmdrun_wait(g_msg)
           END IF
                	

        WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_hrbi.hrbi01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrbi01"
                  LET g_doc.value1 = g_hrbi.hrbi01
                  CALL cl_doc()
               END IF
            END IF

        WHEN "exporttoexcel"
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbi_1),'','')
           END IF

        WHEN "help"
            CALL cl_show_help()

        WHEN "controlg"
            CALL cl_cmdask()

        WHEN "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

        WHEN "exit"
            EXIT WHILE

        WHEN "g_idle_seconds"
            CALL cl_on_idle()

        WHEN "about"
            CALL cl_about()

        OTHERWISE
            EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i026_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrbi_1 TO s_hrbi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION main
         LET g_bp_flag = 'Page4'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i026_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page5", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page5", TRUE)
         EXIT DISPLAY

      ON ACTION accept
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i026_fetch('/')
         CALL cl_set_comp_visible("Page5", FALSE)   #NO.FUN-840018 ADD
         CALL ui.interface.refresh()                  #NO.FUN-840018 ADD
         CALL cl_set_comp_visible("Page5", TRUE)
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"  #MOD-8A0193 add
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-8A0193
         LET g_action_choice="exit"  #MOD-8A0193 add
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about         #MOD-4C0121
         LET g_action_choice="about"  #MOD-8A0193 add
         EXIT DISPLAY                 #MOD-8A0193 add

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
         
      ON ACTION ghr_confirm
         LET g_action_choice="ghr_confirm"
         EXIT DISPLAY
         
      ON ACTION ghr_undo_confirm
         LET g_action_choice="ghr_undo_confirm"
         EXIT DISPLAY 
         
      #原离职基本信息    	
      ON ACTION ghri026_a
         LET g_action_choice="ghri026_a"
         EXIT DISPLAY
        
      #部门面谈信息
      ON ACTION ghri026_b
         LET g_action_choice="ghri026_b"
         EXIT DISPLAY
           	
      #人资面谈信息
      ON ACTION ghri026_c
         LET g_action_choice="ghri026_c"
         EXIT DISPLAY      

      #No.FUN-9C0089 add begin----------------
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY
      #No.FUN-9C0089 add -end-----------------

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      &include "qry_string.4gl"

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION	
	
