# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri0223.4gl
# Descriptions...: 本月末待签合同 
# Date & Author..: 13/04/24 By yangjian
# Modify.........: by zhuzw 20141117 调整生效失效日期取值逻辑
#xie150509  
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_hrbf           RECORD LIKE hrbf_file.*,
     g_hrat           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        chk          LIKE type_file.chr1,       #选择
        hratid       LIKE hrat_file.hratid,     #员工ID
        hrat03       LIKE type_file.chr100,     #所属公司
        hrat01       LIKE type_file.chr100,     #工号
        hrat02       LIKE type_file.chr100,     #姓名
        hrat17       LIKE type_file.chr100,     #性别
        hrat04       LIKE type_file.chr100,     #部门
        hrat05       LIKE type_file.chr100,     #职位
        hrat25       LIKE type_file.dat,        #入职日期
        hrat19       LIKE type_file.chr100,     #状态 
        hrat22       LIKE type_file.chr100,     #学历
        hrat42       LIKE type_file.chr100      #成本中心
                    END RECORD,
    g_hrat_t         DYNAMIC ARRAY OF RECORD  #程式變數 (舊值)
        chk          LIKE type_file.chr1,       #选择
        hratid       LIKE hrat_file.hratid,     #员工ID
        hrat03       LIKE type_file.chr100,     #所属公司
        hrat01       LIKE type_file.chr100,     #工号
        hrat02       LIKE type_file.chr100,     #姓名
        hrat17       LIKE type_file.chr100,     #性别
        hrat04       LIKE type_file.chr100,     #部门
        hrat05       LIKE type_file.chr100,     #职位
        hrat25       LIKE type_file.dat,        #入职日期
        hrat19       LIKE type_file.chr100,     #状态 
        hrat22       LIKE type_file.chr100,     #学历
        hrat42       LIKE type_file.chr100      #成本中心
                    END RECORD,
     g_wc2,g_sql    STRING,  #No.FUN-580092 HCN       
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680102 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110          #No.FUN-680102 SMALLINT
DEFINE   g_str               STRING                     #No.FUN-760083
# add by shenran start
DEFINE   g_sum           LIKE type_file.num10
DEFINE   g_jump1         LIKE type_file.num10
DEFINE   g_jump2         LIKE type_file.num10
DEFINE   g_turn          LIKE type_file.num10
DEFINE   g_turn_t        LIKE type_file.num10
DEFINE   g_record        LIKE type_file.num10
DEFINE   g_j    LIKE type_file.num5 
# add by shenran end 

MAIN
DEFINE p_row,p_col   LIKE type_file.num5         #No.FUN-680102 SMALLINT
     
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
 
    LET p_row = 4 LET p_col = 25
    OPEN WINDOW i0223_w AT p_row,p_col WITH FORM "ghr/42f/ghri022_a"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL cl_set_comp_visible("hratid",FALSE)
    
    LET g_wc2 = '1=1' CALL i0223_b_fill(g_wc2,'')
    CALL i0223_menu()
    CLOSE WINDOW i0223_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i0223_menu()
 
   WHILE TRUE
      CALL i0223_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i0223_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i0223_b()
            ELSE
               LET g_action_choice = NULL
            END IF   
         WHEN "assign"
            IF cl_chk_act_auth() THEN 
            	 CALL i0223_assign()
            END IF                                        
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrat),'','')
            END IF
         # add by shenran start
         WHEN "fi"
            IF cl_chk_act_auth() THEN
            	LET g_jump1 = 1 
            	DISPLAY g_jump1 TO FORMONLY.jump1
            	LET g_cnt = 0           	
             CALL i0223_b_fill(g_wc2,g_cnt)
            END IF            	 
         WHEN "pr"
            IF cl_chk_act_auth() THEN
            	IF g_jump1 > 1 THEN 
            	   LET g_jump1 = g_jump1 - 1
            	ELSE 
            	 	 LET g_jump1 = 1
            	END IF  
            	DISPLAY g_jump1 TO FORMONLY.jump1
            	    LET g_cnt = (g_jump1-1) * g_turn           	          	
              CALL i0223_b_fill(g_wc2,g_cnt)
            END IF 
         WHEN "ne"
            IF cl_chk_act_auth() THEN
            	IF g_jump1 < g_jump2 THEN 
            	   LET g_jump1 = g_jump1 + 1
            	ELSE
            		 LET g_jump1 = g_jump2
            	END IF  
            	DISPLAY g_jump1 TO FORMONLY.jump1
            	    LET g_cnt = (g_jump1-1) * g_turn            	
              CALL i0223_b_fill(g_wc2,g_cnt)
            END IF 
         WHEN "la"
            IF cl_chk_act_auth() THEN
                  DISPLAY g_jump2 TO FORMONLY.jump1
                      LET g_jump1 = g_jump2
                      LET g_cnt = g_turn * (g_jump2-1)             	
              CALL i0223_b_fill(g_wc2,g_cnt)
            END IF  
         WHEN "shaixuan"
            IF cl_chk_act_auth() THEN
            	CALL i0223_tz()
            END IF 
# add by shenran end 
      END CASE
   END WHILE
END FUNCTION

FUNCTION i0223_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102             #可新增否
    l_allow_delete  LIKE type_file.chr1           #No.FUN-680102               #可刪除否
   
DEFINE l_flag       LIKE type_file.chr1           #No.FUN-810016    
DEFINE l_hrag       RECORD LIKE hrag_file.*
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    INPUT ARRAY g_hrat WITHOUT DEFAULTS FROM s_hrat.*
      ATTRIBUTE (COUNT=g_turn,MAXCOUNT=g_sum,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE) 
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            CALL cl_show_fld_cont() 
                
        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
           LET l_ac_t = l_ac             # 新增
 
           IF INT_FLAG THEN 
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              EXIT INPUT
           END IF

        ON ACTION sel_all
           FOR l_n = 1 TO g_rec_b
              LET g_hrat[l_n].chk = 'Y'
           END FOR
           
        ON ACTION sel_no
           FOR l_n = 1 TO g_rec_b
              LET g_hrat[l_n].chk = 'N'
           END FOR           
 
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
 
END FUNCTION
 
FUNCTION i0223_q()
   CALL i0223_b_askkey()
END FUNCTION
 
 
FUNCTION i0223_b_askkey()
    CLEAR FORM
   CALL g_hrat.clear()
    CONSTRUCT g_wc2 ON hrat03,hrat01,hrat02,hrat17,hrat04,hrat05,hrat25,hrat19,
                       hrat22,hrat42
         FROM s_hrat[1].hrat03,s_hrat[1].hrat01,s_hrat[1].hrat02,s_hrat[1].hrat17,
              s_hrat[1].hrat04,s_hrat[1].hrat05,s_hrat[1].hrat25,s_hrat[1].hrat19,
              s_hrat[1].hrat22,s_hrat[1].hrat42
              
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
                 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121


      ON ACTION controlp
         CASE
              WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.state = "c"  
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat01
                 NEXT FIELD hrat01
              WHEN INFIELD(hrat03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat03
                 NEXT FIELD hrat03
              WHEN INFIELD(hrat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat04
                 NEXT FIELD hrat04
              WHEN INFIELD(hrat05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrap01"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat05
                 NEXT FIELD hrat05  
              WHEN INFIELD(hrat17)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '333'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat17
                 NEXT FIELD hrat17
              WHEN INFIELD(hrat19)
                 CALL cl_init_qry_var() 
                 LET g_qryparam.form = "q_hrad02"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat19
                 NEXT FIELD hrat19  
              WHEN INFIELD(hrat22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '317'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat22
                 NEXT FIELD hrat22
              WHEN INFIELD(hrat42)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrai031"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat42
                 NEXT FIELD hrat42      
         END CASE 
    
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup') #FUN-980030
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
    CALL i0223_b_fill(g_wc2,'')
END FUNCTION
 
FUNCTION i0223_b_fill(p_wc2,p_start)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000,       #No.FUN-680102 VARCHAR(200)
    l_hrag          RECORD LIKE hrag_file.*,
    l_hrat          RECORD LIKE hrat_file.*,
    p_start         LIKE type_file.num5 ,
    l_jump2         LIKE type_file.num10   
 
 IF cl_null(p_start) THEN 
    LET g_sql =
        "SELECT 'N',hratid,hrat03,hrat01,hrat02,hrat17,hrat04,hrat05,hrat25, ",
        "       hrat19,hrat22,hrat42 ",
        "  FROM hrat_file,hrad_file,",
        "       (SELECT hrbf02,MAX(hrbf09) hrbf09 FROM hrbf_file ",
        "         GROUP BY hrbf02 ",
        "         HAVING MAX(hrbf09) <= LAST_DAY(SYSDATE)",
        "        ) file1 ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        "   AND hratconf = 'Y' ",
        "   AND hratacti = 'Y' AND hrad02=hrat19 AND hrad01<>'003'",
        "   AND hratid = file1.hrbf02 ",
        " ORDER BY hrat01 "
        
    PREPARE i0223_pb FROM g_sql
    DECLARE hrat_curs CURSOR FOR i0223_pb
 
    CALL g_hrat_t.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrat_curs INTO g_hrat_t[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        
        LET g_cnt = g_cnt + 1
       
    END FOREACH
    CALL g_hrat_t.deleteElement(g_cnt)
    
    # add by shenran 	start      
       	LET g_turn = 100
        LET g_jump1 = 1  
        DISPLAY g_jump1 TO FORMONLY.jump1
        LET g_sum = g_cnt-1
        DISPLAY g_sum TO FORMONLY.cnt
        LET g_jump2 = g_sum/g_turn
        LET l_jump2 = g_jump2 * g_turn 
        IF l_jump2 < g_sum THEN 
        	LET g_jump2 = g_jump2 + 1 
        END IF 
          DISPLAY g_jump2 TO FORMONLY.jump2
          CALL i0223_set_data(0,g_turn)
          DISPLAY g_rec_b TO cnt1
          DISPLAY g_turn TO cnt1 
      ELSE 
          CALL i0223_set_data(p_start,g_turn)
          DISPLAY g_turn TO cnt1 
  END IF 
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i0223_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrat TO s_hrat.* ATTRIBUTE(COUNT=g_turn)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
        # add by shenran start
      ON ACTION fi         #130703
         LET g_action_choice="fi"
         EXIT DISPLAY   

      ON ACTION pr
         LET g_action_choice="pr"
         EXIT DISPLAY   

      ON ACTION ne
         LET g_action_choice="ne"
         EXIT DISPLAY   

      ON ACTION la
         LET g_action_choice="la"
         EXIT DISPLAY   

      ON ACTION shaixuan   #modified  NO.130709 yeap
         IF g_j = 1 THEN 
            CALL cl_err('',"ghr-126",0)
            LET g_j = 0
         ELSE 
         	  LET g_action_choice="shaixuan"
         END IF 
         EXIT DISPLAY
      # add by shenran end 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
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
         
      ON ACTION assign
         LET g_action_choice = 'assign'
         EXIT DISPLAY
                                    
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 

FUNCTION i0223_assign()
 DEFINE l_go    LIKE  type_file.chr1
 DEFINE l_n     LIKE  type_file.num5
 DEFINE l_chk   LIKE  type_file.chr1
 DEFINE l_des   LIKE  type_file.chr100
 DEFINE l_str   STRING
 DEFINE l_hrag  RECORD LIKE hrag_file.*
 DEFINE l_hrbf  RECORD LIKE hrbf_file.*
 DEFINE l_hrat  RECORD LIKE hrat_file.*
 DEFINE l_infor STRING
 DEFINE l_hrbf08 LIKE hrbf_file.hrbf08
 DEFINE l_hrbf09 LIKE hrbf_file.hrbf09
 DEFINE l_err    LIKE  type_file.chr1000

   IF g_rec_b = 0 THEN RETURN END IF 

   LET l_go = 'N'
   FOR l_n = 1 TO g_turn 
      IF g_hrat[l_n].chk = 'Y' THEN 
      	 LET l_go = 'Y'
      	 EXIT FOR
      ELSE 
         CONTINUE FOR
      END IF 
   END FOR 
   
   IF l_go = 'N' THEN 
   	 CALL cl_err( '请勾选人员','!', 1 )
   	RETURN END IF 
   INITIALIZE g_hrbf.* TO NULL
   
   IF NOT cl_confirm('abx-080') THEN RETURN END IF 
   OPEN WINDOW i0223_w1 WITH FORM "ghr/42f/ghri0221"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()  
   
   LET g_hrbf.hrbf03 = '2'
   LET g_hrbf.hrbf05 = ''
   LET g_hrbf.hrbf07 = 'N'
  # LET g_hrbf.hrbf10 = g_today
   LET g_hrbf.hrbfacti = 'Y'
   LET g_hrbf.hrbfuser = g_user
   LET g_hrbf.hrbfgrup = g_grup
   LET g_hrbf.hrbfmodu = g_user
   LET g_hrbf.hrbfdate = g_today
   LET g_hrbf.hrbforiu = g_user
   LET g_hrbf.hrbforig = g_grup
   WHILE TRUE
      DISPLAY BY NAME g_hrbf.hrbf03,g_hrbf.hrbf04,g_hrbf.hrbf05,
                    g_hrbf.hrbf08,g_hrbf.hrbf09,g_hrbf.hrbf10,
                    g_hrbf.hrbf11,g_hrbf.hrbf07,g_hrbf.hrbf12
                    
      INPUT BY NAME g_hrbf.hrbf03,g_hrbf.hrbf04,g_hrbf.hrbf05,
                    g_hrbf.hrbf08,g_hrbf.hrbf09,g_hrbf.hrbf10,
                    g_hrbf.hrbf11,g_hrbf.hrbf07,g_hrbf.hrbf12
                    WITHOUT DEFAULTS
                    
        BEFORE INPUT                                    #預設查詢條件

        ON ACTION controlp
           CASE
              WHEN INFIELD(hrbf04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_hrbe01"
                 LET g_qryparam.construct='N'
                 CALL cl_create_qry() RETURNING g_hrbf.hrbf04
                 DISPLAY g_hrbf.hrbf04 TO hrbf04   
                 NEXT FIELD hrbf04  
              WHEN INFIELD(hrbf11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrag06"
                  LET g_qryparam.arg1 = '339'
                  LET g_qryparam.construct='N'
                 CALL cl_create_qry() RETURNING g_hrbf.hrbf11
                 DISPLAY g_hrbf.hrbf11 TO hrbf11   
                 NEXT FIELD hrbf11   
            END CASE 
            
        AFTER FIELD hrbf04
           IF NOT cl_null(g_hrbf.hrbf04) THEN
           	  CALL i0223_hrbf04() RETURNING l_des
           	  IF NOT cl_null(g_errno) THEN 
           	     CALL cl_err('',g_errno,0)
           	     NEXT FIELD hrbf04
           	  END IF 
           END IF 
#xie150509        
       { AFTER FIELD hrbf05
           IF NOT cl_null(g_hrbf.hrbf05) THEN 
           #	  LET g_hrbf.hrbf09 = '9999-12-31'
           	#  DISPLAY BY NAME g_hrbf.hrbf09
           	  CALL cl_set_comp_required("hrbf09",FALSE)
           	  CALL cl_set_comp_entry("hrbf09",FALSE)
           ELSE 
              CALL cl_set_comp_entry("hrbf09",TRUE)
           	  CALL cl_set_comp_required("hrbf09",TRUE)
           END IF }
                         
        AFTER FIELD hrbf08
           IF NOT cl_null(g_hrbf.hrbf08) AND NOT cl_null(g_hrbf.hrbf09) THEN
           	  IF g_hrbf.hrbf08 > g_hrbf.hrbf09 THEN
           	  	 CALL cl_err('',-9913,0)
           	  	 NEXT FIELD hrbf08
           	  END IF
           #	  SELECT COUNT(*) INTO l_n FROM hrbf_file WHERE hrbf08<g_hrbf.hrbf09 AND hrbf09>g_hrbf.hrbf08 AND hrbf04=g_hrbf.hrbf04
           #	  IF l_n > 0 THEN 
           #	   SELECT hrbf08,hrbf09 INTO l_hrbf08,l_hrbf09 FROM hrbf_file WHERE hrbf08<g_hrbf.hrbf09 AND hrbf09>g_hrbf.hrbf08 AND hrbf04=g_hrbf.hrbf04 AND rownum=1
           #	   LET l_err = '与已经签订的 ',l_hrbf08,' ~ ',l_hrbf09,' 合同重复'
           #	   CALL cl_err(l_err,'!',1)
           #        LET g_hrbf.hrbf08 = NULL
           #        DISPLAY BY NAME g_hrbf.hrbf08
           #	   NEXT FIELD hrbf08
           #	  END IF  
           END IF 
        
        AFTER FIELD hrbf09
           IF NOT cl_null(g_hrbf.hrbf08) AND NOT cl_null(g_hrbf.hrbf09) THEN
           	  IF g_hrbf.hrbf08 > g_hrbf.hrbf09 THEN
           	  	 CALL cl_err('',-9913,0)
           	  	 NEXT FIELD hrbf09
           	  END IF
         #  	  SELECT COUNT(*) INTO l_n FROM hrbf_file WHERE hrbf08<g_hrbf.hrbf09 AND hrbf09>g_hrbf.hrbf08 AND hrbf04=g_hrbf.hrbf04
         #  	  IF l_n > 0 THEN 
         #  	   SELECT hrbf08,hrbf09 INTO l_hrbf08,l_hrbf09 FROM hrbf_file WHERE hrbf08<g_hrbf.hrbf09 AND hrbf09>g_hrbf.hrbf08 AND hrbf04=g_hrbf.hrbf04 AND rownum=1
         #  	   LET l_err = '与已经签订的 ',l_hrbf08,' ~ ',l_hrbf09,' 合同重复'
         #  	   CALL cl_err(l_err,'!',1)
         #          LET g_hrbf.hrbf09 = NULL
         #          DISPLAY BY NAME g_hrbf.hrbf09
         #  	   NEXT FIELD hrbf09
         #  	  END IF  
           END IF 
        #add by zhuzw 20141117 start   
        AFTER FIELD hrbf10
           IF NOT cl_null(g_hrbf.hrbf08)  AND cl_null(g_hrbf.hrbf10) THEN
              LET g_hrbf.hrbf10 = g_hrbf.hrbf08
              DISPLAY BY NAME g_hrbf.hrbf10
           END IF 
        #add by zhuzw 20141117 end                        
        AFTER FIELD hrbf11
           IF NOT cl_null(g_hrbf.hrbf11) THEN
           	  CALL s_code('339',g_hrbf.hrbf11) RETURNING l_hrag.*
           	  IF NOT cl_null(g_errno) THEN 
           	  	 CALL cl_err(g_hrbf.hrbf11,g_errno,0)
           	  	 NEXT FIELD hrbf11
           	  ELSE 
           	     DISPLAY l_hrag.hrag07 TO hrbf11_name
           	  END IF 
           END IF 
            
        ON ACTION locale
              #CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           LET g_action_choice = "locale"
           EXIT INPUT
       
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
       
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
       
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
       
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
       
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT
      END INPUT  
      IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW i0223_w1 
         RETURN
      END IF  
      EXIT WHILE  
   END WHILE

   SELECT COUNT(*) INTO l_n FROM hrbe_file
    WHERE hrbe03 = '001' 
      AND hrbe01 = g_hrbf.hrbf04
      AND hrbe06 = 'Y'
   IF l_n >0 THEN LET l_chk = 'Y' 
   ELSE LET l_chk = 'N'
   END IF 
   
   LET l_infor = 'Result:\n'
   FOR l_n=1 TO g_turn 
      IF g_hrat[l_n].chk = 'Y' THEN 
#move by zhuzw 20141117 逻辑下移      
#      	 IF l_chk = 'Y' THEN 
#      	    SELECT hrbf_file.* INTO l_hrbf.* FROM hrbf_file
#      	     WHERE hrbf02 = g_hrat[l_n].hratid
#      	     ORDER BY hrbf09 DESC 
#      	  #新劳动合同的生效日期不能小于原劳动合同的失效日期
#      	    IF g_hrbf.hrbf08 < l_hrbf.hrbf09 THEN
#      	    	 SELECT hrat_file.* INTO l_hrat.* FROM hrat_file
#      	    	  WHERE hratid = g_hrat[l_n].hratid
#      	    	 LET l_str = cl_getmsg('ghr-051',g_lang)
#      	    	 LET l_des = cl_getmsg('ghr-053',g_lang)||l_hrat.hrat01||' '||l_hrat.hrat02
#      	 	     LET l_infor = l_infor||'[Error]'||l_des||l_str||'\n'   
#      	 	     CONTINUE FOR
#      	    END IF 
#      	 END IF 
      	 LET g_hrbf.hrbf02 = g_hrat[l_n].hratid
      	 SELECT TO_CHAR(MAX(to_number(hrbf01))+1,'fm0000000000') INTO g_hrbf.hrbf01 
      	   FROM hrbf_file WHERE 1=1
      	 IF cl_null(g_hrbf.hrbf01) THEN LET g_hrbf.hrbf01 = '0000000001' END IF 
         #add by zhuzw 20141117 start
         #move by zhuzw 20141117 逻辑下移至此  start
      	 IF l_chk = 'Y' THEN 
      	   SELECT * INTO l_hrbf.* FROM ( SELECT hrbf_file.*  FROM hrbf_file
      	     WHERE hrbf02 = g_hrat[l_n].hratid
      	     ORDER BY hrbf09 DESC )
      	     WHERE rownum = 1
            IF cl_null(g_hrbf.hrbf08) THEN
               LET  g_hrbf.hrbf08 = l_hrbf.hrbf09 + 1
            END IF 
      	  #新劳动合同的生效日期不能小于原劳动合同的失效日期
      	    IF g_hrbf.hrbf08 < l_hrbf.hrbf09 THEN
      	    	 SELECT hrat_file.* INTO l_hrat.* FROM hrat_file
      	    	  WHERE hratid = g_hrat[l_n].hratid
      	    	 LET l_str = cl_getmsg('ghr-051',g_lang)
      	    	 LET l_des = cl_getmsg('ghr-053',g_lang)||l_hrat.hrat01||' '||l_hrat.hrat02
      	 	     LET l_infor = l_infor||'[Error]'||l_des||l_str||'\n'   
      	 	     CONTINUE FOR
      	    END IF 
      	 END IF
      	 #move by zhuzw 20141117 逻辑下移至此   end 
         IF NOT cl_null(g_hrbf.hrbf05) THEN
            IF g_hrbf.hrbf05 = '1' THEN
               LET g_hrbf.hrbf09 = g_hrbf.hrbf08  + 365
            END IF  
            IF g_hrbf.hrbf05 = '2' THEN
               LET g_hrbf.hrbf09 = g_hrbf.hrbf08  + 365*3
            END IF
            IF g_hrbf.hrbf05 = '3' THEN
               LET g_hrbf.hrbf09 = g_hrbf.hrbf08  + 365*5
            END IF            
            IF g_hrbf.hrbf05 = '4' THEN
               LET g_hrbf.hrbf09 = '9999-12-31'
            END IF   
         END IF  
         IF cl_null(g_hrbf.hrbf10) THEN
            LET g_hrbf.hrbf10 = g_hrbf.hrbf08
         END IF 
         #add by zhuzw 20141117 end 
      	 INSERT INTO hrbf_file VALUES(g_hrbf.*)
      	 MESSAGE "Insert "||g_hrbf.hrbf01
      	 CALL ui.Interface.refresh()
      	 IF SQLCA.sqlcode THEN
      	 	  LET l_str = cl_getmsg('ghr-052',g_lang)
            LET l_infor = l_infor||'[Error]'||l_str||g_hrbf.hrbf01||'  ins error'||'\n'
            CONTINUE FOR
         ELSE 
            LET l_str = cl_getmsg('ghr-052',g_lang)
            LET l_infor = l_infor||'[Success]'||l_str||g_hrbf.hrbf01||'\n'
            CONTINUE FOR
         END IF
      END IF 
   END FOR   
   CALL s_infor(l_infor,'s')
   CLOSE WINDOW i0223_w1
   CALL i0223_b_fill(g_wc2,'')
END FUNCTION


FUNCTION i0223_hrbf04()
   DEFINE p_hrbe01    LIKE hrbe_file.hrbe01 
   DEFINE l_hrbe02    LIKE hrbe_file.hrbe02 
   DEFINE l_hrbeacti  LIKE hrbe_file.hrbeacti 

   WHENEVER ERROR CONTINUE  
   LET g_errno=''
   SELECT hrbe02,hrbeacti INTO l_hrbe02,l_hrbeacti FROM hrbe_file
    WHERE hrbe01=g_hrbf.hrbf04
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-050'
                                LET l_hrbe02=NULL
       WHEN l_hrbeacti='N'      LET g_errno='9028'
                                LET l_hrbe02=NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF g_bgjob = 'N' OR g_bgjob IS NULL THEN 
      DISPLAY l_hrbe02 TO hrbf04_name
   END IF 
   RETURN l_hrbe02
END FUNCTION
FUNCTION i0223_set_data(l_cnt,l_turn)
  DEFINE l_cnt, l_turn LIKE type_file.num10          #No.FUN-690005 INTEGER
  DEFINE li_i,li_j LIKE type_file.num10          #No.FUN-690005 INTEGER
  DEFINE l_hrat    RECORD LIKE hrat_file.*
  DEFINE l_hrag    RECORD LIKE hrag_file.*
  CALL g_hrat.clear()
   LET li_j= 1
  LET g_rec_b = l_cnt + l_turn  
  
  FOR li_i = l_cnt+1 TO g_rec_b 
      
      LET g_hrat[li_j].* = g_hrat_t[li_i].*
      
      LET l_hrat.hrat03 = g_hrat_t[li_i].hrat03
        CALL i006_hrat03(l_hrat.*) RETURNING g_hrat[li_j].hrat03
        
        LET l_hrat.hrat04 = g_hrat_t[li_i].hrat04
        CALL i006_hrat04(l_hrat.*) RETURNING g_hrat[li_j].hrat04
        
        LET l_hrat.hrat05 = g_hrat_t[li_i].hrat05
        CALL i006_hrat05(l_hrat.*) RETURNING g_hrat[li_j].hrat05
        
        CALL s_code('333',g_hrat_t[li_i].hrat17) RETURNING l_hrag.*
        LET g_hrat[li_j].hrat17 = l_hrag.hrag07
        
        LET l_hrat.hrat19 = g_hrat_t[li_i].hrat19
        CALL i006_hrat19(l_hrat.*) RETURNING g_hrat[li_j].hrat19
        
        CALL s_code('317',g_hrat_t[li_i].hrat22) RETURNING l_hrag.*
        LET g_hrat[li_j].hrat22 = l_hrag.hrag07
        
        LET l_hrat.hrat42 = g_hrat_t[li_i].hrat42
        CALL i006_hrat42(l_hrat.*)  RETURNING g_hrat[li_j].hrat42
      
      LET li_j = li_j + 1
  END FOR
 
END FUNCTION
	
FUNCTION i0223_tz()  #add by shenran NO.130707
	DEFINE l_jump1    LIKE type_file.num10
	DEFINE l_jump2    LIKE type_file.num10
	DEFINE l_turn   LIKE type_file.num10
	DEFINE l_cnt      LIKE type_file.num10
	DEFINE l_input    LIKE type_file.chr1
	DEFINE l_j        LIKE type_file.num10
	                                  
	                                  
	  INPUT g_jump1 WITHOUT DEFAULTS FROM jump1
	                                  
	  BEFORE INPUT                    
          LET l_input='N'                 
          LET g_before_input_done = FALSE 
              CALL cl_set_comp_entry("jump1",TRUE)
          LET g_before_input_done = TRUE  
          #LET g_turn_t = g_turn                                      
	  CALL cl_set_comp_visible("accept,cancel",FALSE)
                                          
     AFTER FIELD jump1
        IF NOT cl_null(g_jump1) THEN
        	IF NOT (g_jump1 > g_jump2) THEN 
        	   LET l_cnt = (g_jump1 - 1) * g_turn
      	  ELSE                          
      	     CALL cl_err('所录页数大于最大页数，请重新录入', '!', 1 )
      	     NEXT FIELD jump1
      	  END IF                        
        ELSE                                
      	  NEXT FIELD jump1 
      	END IF 
 
      ON ACTION HELP
         CALL cl_show_help()    
         CONTINUE INPUT
         
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()    
         CONTINUE INPUT
 
      ON ACTION close
         LET g_i = 1
         EXIT INPUT   

      ON ACTION EXIT
         LET g_i = 1
         EXIT INPUT   
     
      ON ACTION controlg 
         CALL cl_cmdask()
         CONTINUE INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
        ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")  
                                                                                                 
   END INPUT
    
   	CALL cl_set_comp_visible("accept,cancel",TRUE)
    CALL i0223_b_fill(g_wc2,l_cnt)
END FUNCTION

            
