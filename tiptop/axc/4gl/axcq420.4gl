# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcq420.4gl
# Descriptions...: 工單備料查詢作業
# Date & Author..: 96/06/24 By Roger
# Modify.........: No.FUN-4B0015 04/11/09 By Pengu 新增Array轉Excel檔功能
# Modify.........: No.MOD-530170 05/03/21 By Carol 直接執行此程式時,用滑鼠無法打X離開
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify..........:No.FUN-5A0127 05/10/20 By Rosayu DISPLAY AYYAR 加ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換
#
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770105 07/07/20 By Rayven 點擊右邊"營運中心切換"按鈕,錄入欲切換的營運中心,切庫后查不到任何資料
# Modify.........: No.TQC-780013 07/08/02 By wujie  點擊右邊"營運中心切換"按鈕,彈出的界面沒有進行中文維護"plant code"
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-A20037 10/03/16 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:MOD-A40171 10/04/29 By Sarah 排除作廢工單
# Modify.........: No.FUN-A70136 10/07/29 By destiny 平行工艺
# Modify.........: No.FUN-B10030 11/01/19 By vealxu 拿掉"營運中心切換"ACTION
# Modify.........: No.FUN-B10056 11/02/16 By vealxu 修改制程段號的管控
# Modify.........: No.TQC-B60251 11/06/21 By lixh1 修改SQL語句
# Modify.........: No.TQC-C90034 12/09/06 By lujh 将【工单编号】和【订单编号】改成开窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1 LIKE sfb_file.sfb01,  #No.FUN-550025
    g_sfb   RECORD LIKE sfb_file.*,
    g_sfb_t RECORD LIKE sfb_file.*,
    g_sfb_o RECORD LIKE sfb_file.*,
    g_sfb01_t LIKE sfb_file.sfb01,
    b_sfa   RECORD LIKE sfa_file.*,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_sfa           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
			sfa012          LIKE sfa_file.sfa012,         #No.FUN-A70136
			ecu014          LIKE ecu_file.ecu014,         #No.FUN-A70136
			sfa013          LIKE sfa_file.sfa013,         #No.FUN-A70136
			sfa27		LIKE sfa_file.sfa27,
			sfa26		LIKE sfa_file.sfa26,
			sfa03		LIKE sfa_file.sfa03,
			sfa161		LIKE sfa_file.sfa161,
			sfa05		LIKE type_file.num10,          #No.FUN-680122 INTEGER,
			sfa06		LIKE type_file.num10,          #No.FUN-680122 INTEGER,
			qty_out		LIKE type_file.num10,          #No.FUN-680122 INTEGER,
			qty_bal		LIKE type_file.num10           #No.FUN-680122 INTEGER
                    END RECORD,
    g_sfa_t         RECORD                 #程式變數 (舊值)
      sfa012  LIKE sfa_file.sfa012,         #No.FUN-A70136
			ecu014  LIKE ecu_file.ecu014,         #No.FUN-A70136
			sfa013  LIKE sfa_file.sfa013,         #No.FUN-A70136
			sfa27		LIKE sfa_file.sfa27,
			sfa26		LIKE sfa_file.sfa26,
			sfa03		LIKE sfa_file.sfa03,
			sfa161	LIKE sfa_file.sfa161,
			sfa05		LIKE type_file.num10,          #No.FUN-680122 INTEGER,
			sfa06		LIKE type_file.num10,          #No.FUN-680122 INTEGER,
			qty_out		LIKE type_file.num10,          #No.FUN-680122 INTEGER,
			qty_bal		LIKE type_file.num10           #No.FUN-680122 INTEGER
                    END RECORD,
    g_buf           LIKE type_file.chr1000,             #        #No.FUN-680122 VARCHAR(78),
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680122 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
    l_sl            LIKE type_file.num5           #No.FUN-680122 SMALLINT               #目前處理的SCREEN LINE
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10          #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680122 INTEGER
MAIN
#     DEFINE   l_time LIKE type_file.chr8              #No.FUN-6A0146
   DEFINE p_row,p_col   LIKE type_file.num5           #No.FUN-680122 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AXC")) THEN
       EXIT PROGRAM
    END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
 
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q420_w AT p_row,p_col
         WITH FORM "axc/42f/axcq420"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    #No.FUN-A70136--begin
    IF g_sma.sma541='N' THEN 
       CALL cl_set_comp_visible('sfa012,ecu014,sfa013',FALSE)
    END IF 
    #No.FUN-A70136--end
    CALL q420()
    CLOSE WINDOW q420_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION q420()
 
    INITIALIZE g_sfb.* TO NULL
    INITIALIZE g_sfb_t.* TO NULL
    INITIALIZE g_sfb_o.* TO NULL
#    DECLARE q420_cl CURSOR FOR              # LOCK CURSOR
#        SELECT * FROM sfb_file WHERE sfb01 = g_sfb.sfb01
#        FOR UPDATE
    LET g_argv1 = ARG_VAL(1)
    IF NOT cl_null(g_argv1) THEN CALL q420_q() END IF
    CALL q420_menu()
END FUNCTION
 
FUNCTION q420_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM
   CALL g_sfa.clear()
    IF NOT cl_null(g_argv1) THEN
       LET g_wc=" sfb01='",g_argv1,"'"
       LET g_wc2=" 1=1"
    ELSE
       CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
       INITIALIZE g_sfb.* TO NULL      #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
               sfb01, sfb05,sfb22,sfb221, sfb38, sfb071,sfb08,
               sfb081, sfb09,sfb04,sfb99
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      #MOD-530850
     ON ACTION CONTROLP
        CASE
          #TQC-C90034--add--str--
          WHEN INFIELD(sfb01)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_sfb_3"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_sfb.sfb01
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO sfb01
            NEXT FIELD sfb01
          #TQC-C90034--add--end--
          WHEN INFIELD(sfb05)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_bma2"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_sfb.sfb05
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO sfb05
            NEXT FIELD sfb05
          #TQC-C90034--add--str--
          WHEN INFIELD(sfb22)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_oea3"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_sfb.sfb22
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO sfb22
            NEXT FIELD sfb22
          #TQC-C90034--add--end--
         OTHERWISE
            EXIT CASE
       END CASE
    #--
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
		ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
 
       IF INT_FLAG THEN
          RETURN
       END IF
       CONSTRUCT g_wc2 ON sfa012,sfa013,sfa27,sfa03  #No.FUN-A70136
               FROM s_sfa[1].sfa012,s_sfa[1].sfa013,s_sfa[1].sfa27,s_sfa[1].sfa03
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
           ON IDLE g_idle_seconds            
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      #MOD-530850
     ON ACTION CONTROLP
        CASE
          #No.FUN-A70136--begin
          WHEN INFIELD(sfa012)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_sfa012"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_sfa[1].sfa012
            CALL cl_create_qry() RETURNING g_sfa[1].sfa012
            DISPLAY g_sfa[1].sfa012 TO sfa012
            NEXT FIELD sfa012          
          #No.FUN-A70136--end
          WHEN INFIELD(sfa27)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_sfa[1].sfa27
            CALL cl_create_qry() RETURNING g_sfa[1].sfa27
            DISPLAY g_sfa[1].sfa27 TO sfa27
            NEXT FIELD sfa27
         OTHERWISE
            EXIT CASE
       END CASE
    #--
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
		    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
       IF INT_FLAG THEN
          RETURN
       END IF
    END IF
    IF g_wc2=' 1=1' THEN
       LET g_sql="SELECT sfb01 FROM sfb_file ",
                 " WHERE ",g_wc CLIPPED,
                 "   AND sfb87 != 'X'",   #MOD-A40171 add
                 " ORDER BY sfb01"
    ELSE
       LET g_sql="SELECT DISTINCT sfb01 FROM sfb_file,sfa_file ",
                 " WHERE sfb01=sfa01",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 "   AND sfb87 != 'X'",   #MOD-A40171 add
                 " ORDER BY sfb01"
    END IF
    PREPARE q420_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE q420_cs SCROLL CURSOR WITH HOLD FOR q420_prepare
    IF g_wc2= ' 1=1' OR cl_null(g_wc2) THEN
       LET g_sql="SELECT COUNT(*) FROM sfb_file",
                 " WHERE ",g_wc CLIPPED,
                 "   AND sfb87 != 'X'"   #MOD-A40171 add
    ELSE
       LET g_sql="SELECT COUNT(DISTINCT sfb01) FROM sfb_file,sfa_file",
                 " WHERE sfb01=sfa01",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 "   AND sfb87 != 'X'"   #MOD-A40171 add
    END IF
    PREPARE q420_precount FROM g_sql
    DECLARE q420_count CURSOR FOR q420_precount
END FUNCTION
 
FUNCTION q420_menu()
 
   WHILE TRUE
      CALL q420_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q420_q()
            END IF
         WHEN "next"
            CALL q420_fetch('N')
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "工廠切換"
       # WHEN "switch_plant"      #FUN-B10030
       #    CALL q420_d()         #FUN-B10030 
         WHEN "exporttoexcel" #FUN-4B0015
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfa),'','')
      END CASE
   END WHILE
      CLOSE q420_cs
END FUNCTION
 
FUNCTION q420_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q420_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
   CALL g_sfa.clear()
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN q420_count
    FETCH q420_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q420_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfb.sfb01,SQLCA.sqlcode,0)
        INITIALIZE g_sfb.* TO NULL
    ELSE
        CALL q420_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q420_fetch(p_flsfb)
    DEFINE
        p_flsfb         LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680122 INTEGER
 
    CASE p_flsfb
        WHEN 'N' FETCH NEXT     q420_cs INTO g_sfb.sfb01
        WHEN 'P' FETCH PREVIOUS q420_cs INTO g_sfb.sfb01
        WHEN 'F' FETCH FIRST    q420_cs INTO g_sfb.sfb01
        WHEN 'L' FETCH LAST     q420_cs INTO g_sfb.sfb01
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
            END PROMPT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
            FETCH ABSOLUTE l_abso q420_cs INTO g_sfb.sfb01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfb.sfb01,SQLCA.sqlcode,0)
        INITIALIZE g_sfb.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flsfb
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_sfb.* FROM sfb_file       # 重讀DB,因TEMP有不被更新特性
       WHERE sfb01 = g_sfb.sfb01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_sfb.sfb01,SQLCA.sqlcode,0)   #No.FUN-660127
        CALL cl_err3("sel","sfb_file",g_sfb.sfb01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660127
    ELSE
 
        CALL q420_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION q420_show()
    DEFINE l_ima	RECORD LIKE ima_file.*
    LET g_sfb_t.* = g_sfb.*
    DISPLAY BY NAME
           g_sfb.sfb01, g_sfb.sfb04, g_sfb.sfb05, g_sfb.sfb38,
           g_sfb.sfb99, g_sfb.sfb08, g_sfb.sfb081, g_sfb.sfb09,
           g_sfb.sfb22, g_sfb.sfb221, g_sfb.sfb071
    CALL q420_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q420_out(p_cmd)
   DEFINE p_cmd		    LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_cmd		    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(400),
          l_wc              LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(200) 
 
   CALL cl_wait()
   IF p_cmd= 'a'
      THEN LET l_wc = 'sfb01="',g_sfb.sfb01,'"' 		# "新增"則印單張
      ELSE LET l_wc = g_wc                     			# 其他則印多張
   END IF
   IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
      #CALL cl_err('',-400,0) END IF
   LET l_cmd = "axcr510",
               " '",g_today CLIPPED,"' ''",
               " '",g_lang CLIPPED,"' 'Y' '' '1' '",
               l_wc CLIPPED
   CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
 
#FUN-B10030 ----------------mark start------------------
#FUNCTION q420_d()
#  DEFINE l_plant,l_dbs	LIKE type_file.chr21          #No.FUN-680122 VARCHAR(21)
#  DEFINE l_msg         LIKE type_file.chr1000        #No.TQC-780013
#
#  CALL cl_getmsg('axc-535',g_lang) RETURNING l_msg     #No.TQC-780013
#  LET INT_FLAG = 0  ######add for prompt bug
##  PROMPT 'PLANT CODE:' FOR l_plant
#  PROMPT l_msg FOR l_plant                           #No.TQC-780013
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
##         CONTINUE PROMPT
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#
#  END PROMPT
#  IF l_plant IS NULL THEN RETURN END IF
#  SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant
#  IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
##   CALL cl_ins_del_sid(2) #FUN-980030   #FUN-990069
#  CALL cl_ins_del_sid(2,'') #FUN-980030   #FUN-990069
#  CLOSE DATABASE #No.TQC-770105
#  DATABASE l_dbs
##   CALL cl_ins_del_sid(1) #FUN-980030   #FUN-990069
#  CALL cl_ins_del_sid(1,l_plant) #FUN-980030   #FUN-990069
#  IF STATUS THEN ERROR 'open database error!' RETURN END IF
#  LET g_plant = l_plant
#  LET g_dbs   = l_dbs
#END FUNCTION
#FUN-B10030 ------------mark end--------------
 
FUNCTION q420_b_askkey()
     CONSTRUCT g_wc2 ON sfa012,sfa013,sfa03,sfa27 #No.FUN-A70136
            FROM s_sfa[1].sfa012,s_sfa[1].sfa013,s_sfa[1].sfa03,s_sfa[1].sfa27 #No.FUN-A70136
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
		ON ACTION qbe_select
         	   CALL cl_qbe_select()
		ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
     END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    CALL q420_b_fill(g_wc2)
END FUNCTION
 
FUNCTION q420_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2         LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200)
   DEFINE tot_out	LIKE sfa_file.sfa06
   DEFINE l_sfb06 LIKE sfb_file.sfb06 #No.FUN-A70136
    LET g_sql =
        "SELECT sfa012,'',sfa013,sfa27,sfa26,sfa03,sfa161,sfa05,sfa06,0,0",
        " FROM sfa_file",
        " WHERE sfa01 ='",g_sfb.sfb01,"'",
        "   AND sfa26 IN ('0','1','2','3','4','5','6','7','8') ",          #bugno:7111 add '56'  #FUN-A20037 add '7,8'
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY sfa27,sfa26,sfa03"
    PREPARE q420_pb FROM g_sql
    DECLARE sfa_curs CURSOR FOR q420_pb
 
    FOR g_cnt = 1 TO g_sfa.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_sfa[g_cnt].* TO NULL
    END FOR
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH sfa_curs INTO g_sfa[g_cnt].*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        #No.FUN-A70136--begin
       #FUN-B10056 -------------mod start---------- 
       #SELECT sfb06 INTO l_sfb06 FROM sfb_file WHERE sfb01=g_sfb.sfb01
       #SELECT ecu014 INTO g_sfa[g_cnt].ecu014 FROM ecu_file   
       # WHERE ecu01=g_sfb.sfb05 AND ecu012 = g_sfa[g_cnt].sfa012      
       #   AND ecu02=l_sfb06       
        CALL s_schdat_ecm014(g_sfb.sfb01,g_sfa[g_cnt].sfa012) RETURNING g_sfa[g_cnt].ecu014 
       #FUN-B10056 ------------mod end------------
        #No.FUN-A70136--end
       LET tot_out = g_sfb.sfb09*g_sfa[g_cnt].sfa161
       IF tot_out>g_sfa[g_cnt].sfa06
          THEN LET g_sfa[g_cnt].qty_out=g_sfa[g_cnt].sfa06
               LET tot_out=tot_out-g_sfa[g_cnt].qty_out
          ELSE LET g_sfa[g_cnt].qty_out=tot_out
               LET tot_out=0
       END IF
       LET g_sfa[g_cnt].qty_bal = g_sfa[g_cnt].sfa06-g_sfa[g_cnt].qty_out
       IF g_sfa[g_cnt].sfa26 MATCHES '[3468]' THEN  #bugno:7111 add '6'   #FUN-A20037 add '8'
          DECLARE q420_c2 CURSOR FOR
          # SELECT sfa27,sfa26,sfa03,sfa161,sfa05,sfa06,0,0 FROM sfa_file                    #TQC-B60251
            SELECT sfa012,'',sfa013,sfa27,sfa26,sfa03,sfa161,sfa05,sfa06,0,0 FROM sfa_file   #TQC-B60251
                   WHERE sfa01 =g_sfb.sfb01
                     AND sfa27 =g_sfa[g_cnt].sfa27 AND sfa26 IN ('S','U','T','Z')  #FUN-A20037 add 'Z'
                   ORDER BY sfa27,sfa26,sfa03          #bugno:7111 add 'T'
          LET g_cnt = g_cnt + 1
          FOREACH q420_c2 INTO g_sfa[g_cnt].*
             IF tot_out>g_sfa[g_cnt].sfa06
                THEN LET g_sfa[g_cnt].qty_out=g_sfa[g_cnt].sfa06
                     LET tot_out=tot_out-g_sfa[g_cnt].qty_out
                ELSE LET g_sfa[g_cnt].qty_out=tot_out
                     LET tot_out=0
             END IF
             LET g_sfa[g_cnt].qty_bal = g_sfa[g_cnt].sfa06-g_sfa[g_cnt].qty_out
             CALL s_schdat_ecm014(g_sfb.sfb01,g_sfa[g_cnt].sfa012) RETURNING g_sfa[g_cnt].ecu014   #TQC-B60251
             LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
         END FOREACH
         LET g_cnt = g_cnt - 1
       END IF
       LET g_cnt = g_cnt + 1
    END FOREACH
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q420_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #DISPLAY ARRAY g_sfa TO s_sfa.* #FUN-5A0127 mark
   DISPLAY ARRAY g_sfa TO s_sfa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)#FUN-5A0127 add
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      #BEFORE ROW
      #   LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      #   LET l_sl = SCR_LINE()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q420_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q420_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q420_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q420_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q420_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
 #MOD-530170
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
##
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      #@ON ACTION 工廠切換
    # ON ACTION switch_plant                    #FUN-B10030
    #    LET g_action_choice="switch_plant"     #FUN-B10030
    #    EXIT DISPLAY                           #FUN-B10030
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel #FUN-4B0015
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #
