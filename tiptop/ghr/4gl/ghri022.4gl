# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri022.4gl
# Descriptions...: 合同管理
# Date & Author..: 13/04/24 By yangjian
# Modify.........: by zhuzw 20141117 增加变更逻辑

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
     g_hrbf           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        hrat03       LIKE type_file.chr100,     #所属公司
        hrat01       LIKE type_file.chr100,     #工号
        hrat02       LIKE type_file.chr100,     #姓名
        hrat17       LIKE type_file.chr100,     #性别
        hrat04       LIKE type_file.chr100,     #部门
        hrat05       LIKE type_file.chr100,     #职位
        hrat25       LIKE type_file.dat,        #入职日期
        hrat19       LIKE type_file.chr100,     #状态
        hrat22       LIKE type_file.chr100,     #学历
        hrat42       LIKE type_file.chr100,     #成本中心
        hrbf04       LIKE hrbf_file.hrbf04,     #合同类型
        hrbf10       LIKE hrbf_file.hrbf10,     #签订日期
        hrbf08       LIKE hrbf_file.hrbf08,     #合同生效日
        hrbf09       LIKE hrbf_file.hrbf09,     #合同终止日
        hrbf11       LIKE type_file.chr100      #签约用工单位
        ,hrbfud10    LIKE hrbf_file.hrbfud10    #签约次数   -- zhoumj 20160116 --
                    END RECORD,
     g_hrbf_t         DYNAMIC ARRAY OF RECORD    #程式變數 (舊值)
        hrat03       LIKE type_file.chr100,     #所属公司
        hrat01       LIKE type_file.chr100,     #工号
        hrat02       LIKE type_file.chr100,     #姓名
        hrat17       LIKE type_file.chr100,     #性别
        hrat04       LIKE type_file.chr100,     #部门
        hrat05       LIKE type_file.chr100,     #职位
        hrat25       LIKE type_file.dat,        #入职日期
        hrat19       LIKE type_file.chr100,     #状态
        hrat22       LIKE type_file.chr100,     #学历
        hrat42       LIKE type_file.chr100,     #成本中心
        hrbf04       LIKE hrbf_file.hrbf04,     #合同类型
        hrbf10       LIKE hrbf_file.hrbf10,     #签订日期
        hrbf08       LIKE hrbf_file.hrbf08,     #合同生效日
        hrbf09       LIKE hrbf_file.hrbf09,     #合同终止日
        hrbf11       LIKE type_file.chr100      #签约用工单位
        ,hrbfud10    LIKE hrbf_file.hrbfud10    #签约次数   -- zhoumj 20160116 --
                    END RECORD,
     g_hrbf_o        DYNAMIC ARRAY OF RECORD    #程式變數 (舊值)
        hrat03       LIKE type_file.chr100,     #所属公司
        hrat01       LIKE type_file.chr100,     #工号
        hrat02       LIKE type_file.chr100,     #姓名
        hrat17       LIKE type_file.chr100,     #性别
        hrat04       LIKE type_file.chr100,     #部门
        hrat05       LIKE type_file.chr100,     #职位
        hrat25       LIKE type_file.dat,        #入职日期
        hrat19       LIKE type_file.chr100,     #状态
        hrat22       LIKE type_file.chr100,     #学历
        hrat42       LIKE type_file.chr100,     #成本中心
        hrbf04       LIKE hrbf_file.hrbf04,     #合同类型
        hrbf10       LIKE hrbf_file.hrbf10,     #签订日期
        hrbf08       LIKE hrbf_file.hrbf08,     #合同生效日
        hrbf09       LIKE hrbf_file.hrbf09,     #合同终止日
        hrbf11       LIKE type_file.chr100      #签约用工单位
        ,hrbfud10    LIKE hrbf_file.hrbfud10    #签约次数   -- zhoumj 20160116 --
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
    OPEN WINDOW i022_w AT p_row,p_col WITH FORM "ghr/42f/ghri022"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()

   #LET g_wc2 = '1=1' CALL i022_b_fill(g_wc2,'')        #add by yinbq for 打开程序一开始不查询所有数据
    CALL i022_menu()
    CLOSE WINDOW i022_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i022_menu()

   WHILE TRUE
      CALL i022_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i022_q()
            END IF
         WHEN "ghri022_a"
            IF cl_chk_act_auth() THEN
            	 CALL i022_ghri0221()
            END IF
         WHEN "ghri022_b"
            IF cl_chk_act_auth() THEN
            	 CALL i022_ghri0222()
            END IF
         WHEN "ghri022_c"
            IF cl_chk_act_auth() THEN
            	 CALL i022_ghri0223()
            END IF
         WHEN "ghri022_d"
            IF cl_chk_act_auth() THEN
            	 CALL i022_ghri0224()
            END IF
#add by zhuzw 20141117 start
         WHEN "ghri022_e"
            IF cl_chk_act_auth() THEN
            	 CALL i022_ghri0225()
            END IF
#add by zhuzw 20141117 end
         WHEN "i022_import"
            IF cl_chk_act_auth() THEN
                 CALL i022_import()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i022_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbf),'','')
            END IF
         # add by shenran start

         WHEN "fi"
            IF cl_chk_act_auth() THEN
            	LET g_jump1 = 1
            	DISPLAY g_jump1 TO FORMONLY.jump1
            	LET g_cnt = 0
             CALL i022_b_fill(g_wc2,g_cnt)
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
              CALL i022_b_fill(g_wc2,g_cnt)
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
              CALL i022_b_fill(g_wc2,g_cnt)
            END IF
         WHEN "la"
            IF cl_chk_act_auth() THEN
                  DISPLAY g_jump2 TO FORMONLY.jump1
                      LET g_jump1 = g_jump2
                      LET g_cnt = g_turn * (g_jump2-1)
              CALL i022_b_fill(g_wc2,g_cnt)
            END IF
         WHEN "shaixuan"
            IF cl_chk_act_auth() THEN
            	CALL i022_tz()
            END IF
         # add by shenran end
      END CASE
   END WHILE
END FUNCTION

FUNCTION i022_q()
   CALL i022_b_askkey()
END FUNCTION


FUNCTION i022_b_askkey()
    CLEAR FORM
   CALL g_hrbf.clear()
    CONSTRUCT g_wc2 ON hrat03,hrat01,hrat02,hrat17,hrat04,hrat05,hrat25,hrat19,
                       hrat22,hrat42,hrbf04,hrbf10,hrbf08,hrbf09,hrbf11
         FROM s_hrbf[1].hrat03,s_hrbf[1].hrat01,s_hrbf[1].hrat02,s_hrbf[1].hrat17,
              s_hrbf[1].hrat04,s_hrbf[1].hrat05,s_hrbf[1].hrat25,s_hrbf[1].hrat19,
              s_hrbf[1].hrat22,s_hrbf[1].hrat42,s_hrbf[1].hrbf04,s_hrbf[1].hrbf10,
              s_hrbf[1].hrbf08,s_hrbf[1].hrbf09,s_hrbf[1].hrbf11

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
              WHEN INFIELD(hrat03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat03
                 NEXT FIELD hrat03
              WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat01
                 NEXT FIELD hrat01
              WHEN INFIELD(hrat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbf01"
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
              WHEN INFIELD(hrbf04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_hrbe01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbf04
                 NEXT FIELD hrbf04
              WHEN INFIELD(hrbf11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrag06"
                  LET g_qryparam.arg1 = '339'
                  LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbf11
                 NEXT FIELD hrbf11
         END CASE

        ON ACTION qbe_select
	        CALL cl_qbe_select()
        ON ACTION qbe_save
		     CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrbfuser', 'hrbfgrup') #FUN-980030
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
    CALL i022_b_fill(g_wc2,'')
END FUNCTION

FUNCTION i022_b_fill(p_wc2,p_start)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000,       #No.FUN-680102 VARCHAR(200)
    l_hrag          RECORD LIKE hrag_file.*,
    l_hrat          RECORD LIKE hrat_file.*,
    p_start         LIKE type_file.num5 ,
    l_jump2         LIKE type_file.num10

 IF cl_null(p_start) THEN
    LET g_sql =
      "SELECT hrat03,hrat01,hrat02,hrat17,hrat04,hrat05,hrat25,hrat19, ",
      #"       hrat22,hrat42,hrbf04,hrbf10,hrbf08,hrbf09,hrbf11    ",     -- zhoumj 20160116 --
      "       hrat22,hrat42,hrbf04,hrbf10,hrbf08,hrbf09,hrbf11,hrbfud10    ",      -- zhoumj 20160116 --
      "  FROM hrbf_file, hrat_file ",
      " WHERE ", p_wc2 CLIPPED,                     #單身
      "   AND hrbf02=hratid ",
      " ORDER BY hrat01,hrbf10 "

    PREPARE i022_pb FROM g_sql
    DECLARE hrbf_curs CURSOR FOR i022_pb

    CALL g_hrbf_t.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH hrbf_curs INTO g_hrbf_t[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       # add by shenran 	start
       LET g_turn = 100
       LET g_jump1 = 1
       DISPLAY g_jump1 TO FORMONLY.jump1
       # add by shenran end
       LET g_cnt = g_cnt + 1
    END FOREACH
    # add by shenran start
    LET g_sum = g_cnt-1
    DISPLAY g_sum TO FORMONLY.cnt
    LET g_jump2 = g_sum/g_turn
    LET l_jump2 = g_jump2 * g_turn
    IF l_jump2 < g_sum THEN
    LET g_jump2 = g_jump2 + 1
    END IF
    DISPLAY g_jump2 TO FORMONLY.jump2
    # add by shenran end
    CALL g_hrbf_t.deleteElement(g_cnt)
    #add by yinbq 20141110  begin……
    IF g_cnt < g_turn THEN
       CALL i022_set_data(0,g_sum)
    ELSE
       CALL i022_set_data(0,g_turn)
    END IF
    #CALL i022_set_data(0,g_cnt)
    #add by yinbq 20141110 end ……
    DISPLAY g_rec_b TO cnt1
    DISPLAY g_turn TO cnt1
 ELSE
    #add by yinbq 20141110  begin……
    IF g_cnt < g_turn THEN
       CALL i022_set_data(0,g_sum)
    ELSE
       CALL i022_set_data(0,g_turn)
    END IF
    #CALL i022_set_data(p_start,g_turn)
    #add by yinbq 20141110 end ……
    DISPLAY g_turn TO cnt1
 END IF

 LET g_cnt = 0

END FUNCTION

FUNCTION i022_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
#   CALL i022_b_fill(g_wc2,g_cnt)  #FUN-151225 WANGJYA
   DISPLAY ARRAY g_hrbf TO s_hrbf.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
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

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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
      ON ACTION controlg
         LET g_action_choice="controlg"
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

      ON ACTION ghri022_a
         LET g_action_choice = 'ghri022_a'
         EXIT DISPLAY

#      ON ACTION ghri022_b
#         LET g_action_choice = 'ghri022_b'
#         EXIT DISPLAY

#      ON ACTION ghri022_c
#         LET g_action_choice = 'ghri022_c'
#         EXIT DISPLAY
#
      ON ACTION ghri022_d
         LET g_action_choice = 'ghri022_d'
         EXIT DISPLAY
#      #add by zhuzw 20141117 start
#      ON ACTION ghri022_e
#         LET g_action_choice = 'ghri022_e'
#         EXIT DISPLAY
      ON ACTION i022_import
         LET g_action_choice = 'i022_import'
         EXIT DISPLAY
      #add by zhuzw 20141117 end
      # No.FUN-530227 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530227 ---end---


   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION i022_ghri0221()
   CALL cl_cmdrun_wait("ghri0221")
  #LET g_wc2 = '1=1' CALL i022_b_fill(g_wc2,'')      #add by yinbq for 取消默认查询所有记录
END FUNCTION

FUNCTION i022_ghri0222()
   CALL cl_cmdrun_wait("ghri0222")
  #LET g_wc2 = '1=1' CALL i022_b_fill(g_wc2,'')      #add by yinbq for 取消默认查询所有记录
END FUNCTION

FUNCTION i022_ghri0223()
   CALL cl_cmdrun_wait("ghri0223")
  # LET g_wc2 = '1=1' CALL i022_b_fill(g_wc2,'')     #add by yinbq for 取消默认查询所有记录
END FUNCTION

FUNCTION i022_ghri0224()
   CALL cl_cmdrun_wait("ghri0224")
  # LET g_wc2 = '1=1' CALL i022_b_fill(g_wc2,'')     #add by yinbq for 取消默认查询所有记录
END FUNCTION
#add by zhuzw 20141117 start
FUNCTION i022_ghri0225()
   CALL cl_cmdrun_wait("ghri0225")
END FUNCTION
#add by zhuzw 20141117 end
FUNCTION i022_hrbf04(p_hrbe01)
   DEFINE p_hrbe01    LIKE hrbe_file.hrbe01
   DEFINE l_hrbe02    LIKE hrbe_file.hrbe02
   DEFINE l_hrbeacti  LIKE hrbe_file.hrbeacti

   WHENEVER ERROR CONTINUE
   LET g_errno=''
   SELECT hrbe02,hrbeacti INTO l_hrbe02,l_hrbeacti FROM hrbe_file
    WHERE hrbe01=p_hrbe01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-050'
                                LET l_hrbe02=NULL
       WHEN l_hrbeacti='N'      LET g_errno='9028'
                                LET l_hrbe02=NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   RETURN l_hrbe02
END FUNCTION
FUNCTION i022_set_data(l_cnt,l_turn)
  DEFINE l_cnt, l_turn LIKE type_file.num10          #No.FUN-690005 INTEGER
  DEFINE li_i,li_j LIKE type_file.num10          #No.FUN-690005 INTEGER
  DEFINE l_hrat    RECORD LIKE hrat_file.*
  DEFINE l_hrag    RECORD LIKE hrag_file.*
  CALL g_hrbf.clear()
  LET g_rec_b = l_cnt + l_turn
  LET li_j= '0'
  FOR li_i = l_cnt+1 TO g_rec_b

      LET g_hrbf[li_j+1].* = g_hrbf_t[li_i].*

       LET l_hrat.hrat03 = g_hrbf_t[li_i].hrat03
        CALL i006_hrat03(l_hrat.*) RETURNING g_hrbf[li_j+1].hrat03

        LET l_hrat.hrat04 = g_hrbf_t[li_i].hrat04
        CALL i006_hrat04(l_hrat.*) RETURNING g_hrbf[li_j+1].hrat04

        LET l_hrat.hrat05 = g_hrbf_t[li_i].hrat05
        CALL i006_hrat05(l_hrat.*) RETURNING g_hrbf[li_j+1].hrat05

        CALL s_code('333',g_hrbf_t[li_i].hrat17) RETURNING l_hrag.*
        LET g_hrbf[li_j+1].hrat17 = l_hrag.hrag07

        LET l_hrat.hrat19 = g_hrbf_t[li_i].hrat19
        CALL i006_hrat19(l_hrat.*) RETURNING g_hrbf[li_j+1].hrat19

        CALL s_code('317',g_hrbf_t[li_i].hrat22) RETURNING l_hrag.*
        LET g_hrbf[li_j+1].hrat22 = l_hrag.hrag07

        LET l_hrat.hrat42 = g_hrbf_t[li_i].hrat42
        CALL i006_hrat42(l_hrat.*)  RETURNING g_hrbf[li_j+1].hrat42

        CALL i022_hrbf04(g_hrbf_t[li_i].hrbf04) RETURNING g_hrbf[li_j+1].hrbf04

        CALL s_code('339',g_hrbf_t[li_i].hrbf11) RETURNING l_hrag.*
        LET g_hrbf[li_j+1].hrbf11 = l_hrag.hrag07

      LET li_j = li_j + 1
  END FOR

END FUNCTION

FUNCTION i022_tz()  #add by shenran NO.130707
	DEFINE l_jump1    LIKE type_file.num10
	DEFINE l_jump2    LIKE type_file.num10
	DEFINE l_turn   LIKE type_file.num10
	DEFINE l_cnt      LIKE type_file.num10
	DEFINE l_input    LIKE type_file.chr1
	DEFINE l_j        LIKE type_file.num10


	  INPUT g_jump1,g_turn WITHOUT DEFAULTS FROM jump1,cnt1

	  BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
              CALL cl_set_comp_entry("jump1",TRUE)
          LET g_before_input_done = TRUE
          LET g_turn_t = g_turn
	  CALL cl_set_comp_visible("accept,cancel",FALSE)
    #add by zhuzw 20141110 start
     AFTER FIELD cnt1
        IF NOT cl_null(g_turn) THEN
        	LET g_jump2 = g_sum/g_turn
        	LET l_jump2 = g_turn * g_jump2
        	IF l_jump2 < g_sum THEN
        		 LET g_jump2 = g_jump2 + 1
        	END IF
        	DISPLAY g_jump2 TO FORMONLY.jump2
        		 IF NOT (g_jump1 > g_jump2) THEN
        		 	  LET g_jump1 = l_jump1
        	      LET l_cnt = (g_jump1 - 1) * g_turn
      	     ELSE
      	    	  LET g_jump1 = g_jump2
      	    	  LET l_cnt = (g_jump1 - 1) * g_turn
      	     END IF
      	     DISPLAY g_jump1 TO FORMONLY.jump1
        ELSE
        	LET g_turn = l_turn
        	DISPLAY g_turn TO FORMONLY.cnt1
        END IF
    #add by zhuzw 20141110 end
     AFTER FIELD jump1
        IF NOT cl_null(g_jump1) THEN
        	IF NOT (g_jump1 > g_jump2) THEN
        	   LET l_cnt = (g_jump1 - 1) * g_turn
      	  ELSE
      	     CALL cl_err( '所录页数大于最大页数，请重新录入', '!', 1 )
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
    CALL i022_b_fill(g_wc2,l_cnt)
END FUNCTION

FUNCTION i022_b()
DEFINE l_sql,l_sql2 STRING
DEFINE l_flag       LIKE type_file.chr1
DEFINE l_hrbf01     LIKE hrbf_file.hrbf01
DEFINE l_hratid     LIKE hrat_file.hratid
DEFINE l_hrbe01     LIKE hrbe_file.hrbe01
DEFINE l_hrbf11_n     LIKE hrag_file.hrag07
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
DEFINE  l_chk  LIKE type_file.num15_3   -- zhoumj 20160116 --

		LET g_action_choice = ""
		CALL cl_set_comp_entry("hrat03,hrat01,hrat02,hrat17,hrat04,hrat05,hrat25,hrat19,hrat22,hrat42",FALSE)
		CALL cl_opmsg('b')
		LET g_forupd_sql = "SELECT hrat03,hrat01,hrat02,hrat17,hrat04,hrat05,hrat25,hrat19,hrat22,hrat42,'','','','','' ",
		                   "FROM hrat_file WHERE hrat01 = ?  FOR UPDATE "
	  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i022_b_cur2 CURSOR FROM g_forupd_sql
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_hrbf WITHOUT DEFAULTS FROM s_hrbf.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
    BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_hrbf_o[l_ac].* = g_hrbf[l_ac].*
                OPEN i022_b_cur2 USING g_hrbf_t[l_ac].hrat01
                IF STATUS THEN
                   CALL cl_err("OPEN i022_b_cur2:", STATUS, 1)
                   CLOSE i022_b_cur2
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i022_b_cur2 INTO g_hrbf[l_ac].*
#                   SELECT hrbf04,hrbf10,hrbf08,hrbf09,hrbf11 INTO g_hrbf[l_ac].hrbf04,g_hrbf[l_ac].hrbf10,g_hrbf[l_ac].hrbf08,g_hrbf[l_ac].hrbf09,g_hrbf[l_ac].hrbf11
#                          FROM hrbf_file
#                          WHERE hrbf02 = g_hrbf[l_ac].hrat01
                   #LET g_hrbf[l_ac].* = g_hrbf_t[l_ac].*
                   LET g_hrbf[l_ac].hrbf04 = g_hrbf_o[l_ac].hrbf04
                   LET g_hrbf[l_ac].hrbf08 = g_hrbf_o[l_ac].hrbf08
                   LET g_hrbf[l_ac].hrbf09 = g_hrbf_o[l_ac].hrbf09
                   LET g_hrbf[l_ac].hrbf10 = g_hrbf_o[l_ac].hrbf10
                   LET g_hrbf[l_ac].hrbf11 = g_hrbf_o[l_ac].hrbf11
                   SELECT hrat02  INTO g_hrbf[l_ac].hrat02 FROM hrat_file
                      WHERE hrat01 = g_hrbf_t[l_ac].hrat01
#                   DISPLAY BY NAME g_hrbf[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_hrbf_t[l_ac].hrat03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       LET g_hrbf_o[l_ac].*=g_hrbf[l_ac].*
                   END IF
                END IF

            END IF

      BEFORE DELETE
             SELECT hratid INTO l_hratid FROM hrat_file
              WHERE hrat01 = g_hrbf_t[l_ac].hrat01
         SELECT hrbf01 INTO l_hrbf01 FROM hrbf_file
           WHERE hrbf10 = g_hrbf_t[l_ac].hrbf10 AND hrbf08 = g_hrbf_t[l_ac].hrbf08 AND hrbf09 = g_hrbf_t[l_ac].hrbf09 AND hrbf02 = l_hratid
         DELETE FROM hrbf_file WHERE hrbf01=l_hrbf01
      ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_hrbf[l_ac].* = g_hrbf_o[l_ac].*

               CLOSE i022_b_cur2
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_hrbf[l_ac].hrat03,-263,1)
               LET g_hrbf[l_ac].* = g_hrbf_o[l_ac].*
            ELSE
#               LET l_sql = "UPDATE hrbf_file SET hrbf04 = '",g_hrbf[l_ac].hrbf04,"',",
#                           " hrbf10 = '",g_hrbf[l_ac].hrbf10,"',",
#                           " hrbf08 = '",g_hrbf[l_ac].hrbf08,"',",
#                           " hrbf09 = '",g_hrbf[l_ac].hrbf09,"',",
#                           " hrbf11 = '",g_hrbf[l_ac].hrbf11,"' ",
#    #ADD BY YINBQ 20141122 for 更新脚本有问题，没有添加WHERE条件，先添加一个恒不等于的条件
#                           " WHERE hrbf01 = '",l_hrbf01,"' "
#    #ADD BY YINBQ 20141122 for 更新脚本有问题，没有添加WHERE条件，先添加一个恒不等于的条件
#            PREPARE hav_upd FROM l_sql
#            EXECUTE hav_upd
             SELECT hratid INTO l_hratid FROM hrat_file
              WHERE hrat01 = g_hrbf_t[l_ac].hrat01
             SELECT hrbf01 INTO l_hrbf01 FROM hrbf_file
              WHERE hrbf10 = g_hrbf_t[l_ac].hrbf10 AND hrbf08 = g_hrbf_t[l_ac].hrbf08 AND hrbf09 = g_hrbf_t[l_ac].hrbf09 AND hrbf02 = l_hratid
             IF NOT cl_null(l_hrbf11_n) THEN
             UPDATE hrbf_file SET
                                  hrbf08 = g_hrbf[l_ac].hrbf08,
                                  hrbf09 = g_hrbf[l_ac].hrbf09,
                                  hrbf10 = g_hrbf[l_ac].hrbf10,
                                  hrbf11 = l_hrbf11_n
                                  ,hrbfud10 = g_hrbf[l_ac].hrbfud10   -- zhoumj 20160116 --
              WHERE hrbf01 = l_hrbf01
             ELSE
             UPDATE hrbf_file SET
                                  hrbf08 = g_hrbf[l_ac].hrbf08,
                                  hrbf09 = g_hrbf[l_ac].hrbf09,
                                  hrbf10 = g_hrbf[l_ac].hrbf10
                                  ,hrbfud10 = g_hrbf[l_ac].hrbfud10   -- zhoumj 20160116 --
              WHERE hrbf01 = l_hrbf01
             END IF
             IF NOT cl_null(l_hrbe01) THEN
             UPDATE hrbf_file SET hrbf04 = l_hrbe01
              WHERE hrbf01 = l_hrbf01
             END IF
            IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","hrbf_file",g_hrbf_t[l_ac].hrat01,g_hrbf_t[l_ac].hrbf04,SQLCA.sqlcode,"","",1)
                   LET g_hrbf[l_ac].* = g_hrbf_t[l_ac].*
                ELSE
                   LET g_hrbf_o[l_ac].*=g_hrbf[l_ac].*
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
            END IF
      AFTER FIELD hrbf04
       IF NOT cl_null(g_hrbf[l_ac].hrbf04) THEN
          SELECT COUNT(*) INTO l_n FROM hrbe_file
           WHERE hrbe02 = g_hrbf[l_ac].hrbf04
          IF l_n = 0 THEN
             CALL cl_err('合同类型不存在，请检查','!',0)
             NEXT FIELD hrbf04
          ELSE
          	 IF cl_null(l_hrbe01) THEN
          	    SELECT hrbe01 INTO l_hrbe01 FROM hrbe_file
          	     WHERE hrbe02 = g_hrbf[l_ac].hrbf04
          	 END IF
          END IF
       END IF
      AFTER FIELD hrbf11
       IF NOT cl_null(g_hrbf[l_ac].hrbf11) THEN
          SELECT COUNT(*) INTO l_n FROM hrag_file
           WHERE hrag01 = '339'
             AND hrag07 = g_hrbf[l_ac].hrbf11
          IF l_n = 0 THEN
             CALL cl_err('用工单位不存在，请检查','!',0)
             NEXT FIELD hrbf11
          ELSE
          	 IF cl_null(l_hrbf11_n) THEN
          	    SELECT hrag06 INTO l_hrbf11_n FROM hrag_file
                 WHERE hrag01 = '339'
                   AND hrag07 = g_hrbf[l_ac].hrbf11
          	 END IF
          END IF
       END IF
       --* zhoumj 20160116 --
       AFTER FIELD hrbfud10
           IF NOT cl_null(g_hrbf[l_ac].hrbfud10) THEN
               IF g_hrbf[l_ac].hrbfud10 >=0 THEN
                   SELECT (g_hrbf[l_ac].hrbfud10 - TRUNC(g_hrbf[l_ac].hrbfud10)) INTO l_chk FROM DUAL
                   IF l_chk > 0 THEN
                       CALL cl_err('','alm-082',0)
                       LET g_hrbf[l_ac].hrbfud10 = 0
                       NEXT FIELD hrbfud10
                   END IF
               ELSE
                   CALL cl_err('','aic-005',0)
                   LET g_hrbf[l_ac].hrbfud10 = 0
                   NEXT FIELD hrbfud10
               END IF
           ELSE
               CALL cl_err('','aim-927',0)
               LET g_hrbf[l_ac].hrbfud10 = 0
               NEXT FIELD hrbfud10
           END IF
       -- zhoumj 20160116 *--
      AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_hrbf[l_ac].* = g_hrbf_t[l_ac].*
               END IF
               CLOSE i022_b_cur2
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i022_b_cur2
            COMMIT WORK
     ON ACTION controlp
            CASE
             WHEN INFIELD(hrbf04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_hrbe01"
                # LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrbf[l_ac].hrbf04
                 CALL cl_create_qry() RETURNING g_hrbf[l_ac].hrbf04
                 LET l_hrbe01 = g_hrbf[l_ac].hrbf04
                 SELECT hrbe02 INTO g_hrbf[l_ac].hrbf04 FROM hrbe_file
                  WHERE hrbe01 = g_hrbf[l_ac].hrbf04
                 DISPLAY BY NAME g_hrbf[l_ac].hrbf04
                 NEXT FIELD hrbf04
              WHEN INFIELD(hrbf11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrag06"
                  LET g_qryparam.arg1 = '339'
                  LET g_qryparam.default1 = g_hrbf[l_ac].hrbf11
                 # LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_hrbf[l_ac].hrbf11
                 LET l_hrbf11_n  =  g_hrbf[l_ac].hrbf11
                 SELECT hrag07 INTO g_hrbf[l_ac].hrbf11 FROM hrag_file
                  WHERE hrag01 = '339'
                    AND hrag06= g_hrbf[l_ac].hrbf11
                 DISPLAY BY NAME g_hrbf[l_ac].hrbf11
                 NEXT FIELD hrbf11
            END CASE

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

     ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

    END INPUT
    CALL i022_b_fill(g_wc2,'')
    CLOSE i022_b_cur2
    COMMIT WORK
END FUNCTION


#=================================================================#
# Function name...: i022_import()
# Descriptions...: 打开文件选择窗口允许用户打开本地TXT，EXCEL文件并
# ...............  导入数据到dateBase中
# Input parameter: p_argv1 文件类型 0-TXT 1-EXCEL
# RETURN code....: 'Y' FOR TRUE  : 数据操作成功
#                  'N' FOR FALSE : 数据操作失败
# Date & Author..: 131021 shenran
#=================================================================#
FUNCTION i022_import()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql    STRING,
       l_data   VARCHAR(300),
       p_argv1  LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD
         hrbf01  LIKE hrbf_file.hrbf01,
         hrbf02  LIKE hrbf_file.hrbf02,
         hrbf03  LIKE hrbf_file.hrbf03,
         hrbf04  LIKE hrbf_file.hrbf04,
         hrbf05  LIKE hrbf_file.hrbf05,
         hrbf07  LIKE hrbf_file.hrbf07,
         hrbf08  LIKE hrbf_file.hrbf08,
         hrbf09  LIKE hrbf_file.hrbf09,
         hrbf10  LIKE hrbf_file.hrbf10,
         hrbf11  LIKE hrbf_file.hrbf11
              END RECORD
DEFINE    l_tok       base.stringTokenizer
DEFINE xlapp,iRes,iRow,i,j     INTEGER
DEFINE li_k ,li_i_r   LIKE  type_file.num5
DEFINE l_n     LIKE type_file.num5
DEFINE l_racacti     LIKE rac_file.racacti
DEFINE    l_imaacti  LIKE ima_file.imaacti,
          l_ima02    LIKE ima_file.ima02,
          l_ima25    LIKE ima_file.ima25

DEFINE    l_obaacti  LIKE oba_file.obaacti,
          l_oba02    LIKE oba_file.oba02

DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06
DEFINE l_gfe02     LIKE gfe_file.gfe02
DEFINE l_gfeacti   LIKE gfe_file.gfeacti
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac

   LET g_errno = ' '
   LET l_n=0
   CALL s_showmsg_init() #初始化

   LET l_file = cl_browse_file()
   LET l_file = l_file CLIPPED
   MESSAGE l_file
   IF NOT cl_null(l_file) THEN
       LET l_count =  LENGTH(l_file)
          IF l_count = 0 THEN
             LET g_success = 'N'
             RETURN
          END IF
       INITIALIZE sr.* TO NULL
       LET li_k = 1
       LET li_i_r = 1
       LET g_cnt = 1
       LET l_sql = l_file

       CALL ui.interface.frontCall('WinCOM','CreateInstance',
                                   ['Excel.Application'],[xlApp])
       IF xlApp <> -1 THEN
          LET l_file = "C:\\Users\\dcms1\\Desktop\\import.xls"
          CALL ui.interface.frontCall('WinCOM','CallMethod',
                                      [xlApp,'WorkBooks.Open',l_sql],[iRes])
                                    # [xlApp,'WorkBooks.Open',"C:/Users/dcms1/Desktop/import.xls"],[iRes])

          IF iRes <> -1 THEN
             CALL ui.interface.frontCall('WinCOM','GetProperty',
                  [xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
             IF iRow > 0 THEN
                LET g_success = 'Y'
                BEGIN WORK
              # CALL s_errmsg_init()
                CALL s_showmsg_init()
                FOR i = 1 TO iRow

                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[sr.hrbf02])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[sr.hrbf03])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[sr.hrbf04])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',7).Value'],[sr.hrbf05])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[sr.hrbf07])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',9).Value'],[sr.hrbf08])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',10).Value'],[sr.hrbf09])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',11).Value'],[sr.hrbf10])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',12).Value'],[sr.hrbf11])
                IF NOT cl_null(sr.hrbf02) AND NOT cl_null(sr.hrbf08) AND NOT cl_null(sr.hrbf09)
                	 AND NOT cl_null(sr.hrbf04) THEN
                	 IF i > 1 THEN
                	  
                	   SELECT TO_CHAR(MAX(to_number(hrbf01))+1,'fm0000000000') INTO sr.hrbf01 FROM hrbf_file
                     IF cl_null(sr.hrbf01) THEN LET sr.hrbf01 = '0000000001' END IF
                     SELECT hratid INTO sr.hrbf02  FROM hrat_file WHERE hrat01=sr.hrbf02
                    INSERT INTO hrbf_file(hrbf01,hrbf02,hrbf03,hrbf04,hrbf05,hrbf07,hrbf08,hrbf09,hrbf10,hrbf11,hrbfacti,hrbfuser,hrbfgrup,hrbfdate,hrbforig,hrbforiu)
                      VALUES (sr.hrbf01,sr.hrbf02,sr.hrbf03,sr.hrbf04,sr.hrbf05,sr.hrbf07,sr.hrbf08,sr.hrbf09,sr.hrbf10,sr.hrbf11,'Y',g_user,g_grup,g_today,g_grup,g_user)
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("ins","hrbf_file",sr.hrbf01,'',SQLCA.sqlcode,"","",1)
                       LET g_success  = 'N'
                       CONTINUE FOR
                    END IF

                   END IF
                END IF
                  # LET i = i + 1
                  # LET l_ac = g_cnt

                END FOR
                IF g_success = 'N' THEN
                   ROLLBACK WORK
                   CALL s_showmsg()
                ELSE IF g_success = 'Y' THEN
                        COMMIT WORK
                        CALL cl_err( '导入成功','!', 1 )
                     END IF
                END IF
            END IF
          ELSE
              DISPLAY 'NO FILE'
          END IF
       ELSE
       	  DISPLAY 'NO EXCEL'
       END IF
       CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
       CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes])

#       SELECT * INTO g_hrbf.* FROM hrbf_file
#       WHERE hrbf01=sr.hrbf01
#       CALL i022_show()
   END IF

END FUNCTION
