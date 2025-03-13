# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amsq510.4gl
# Descriptions...: MPS 供需明細查詢
# Date & Author..: 96/05/06 By Roger
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: No.FUN-4B0014 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.MOD-530852 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-680101 06/08/29 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6C0158 06/12/26 By day 單身匯出excel多一空白行
# Modify.........: No.TQC-6C0182 06/12/27 amsq500切換營運中心后明細單身未切換庫
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# MOdify.........: No.MOD-940414 09/04/30 By lutingting單身得類別說明欄位無法正常顯示
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-B10030 11/01/19 By vealxu 拿掉"營運中心切換"ACTION
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1		LIKE mps_file.mps_v,    # Prog. Version..: '5.30.06-13.03.12(02)  # 版本
    g_argv2		LIKE mps_file.mps01,	# 料號 No.MOD-490217
    g_argv3		LIKE azp_file.azp03,    #TQC-6C0182
    g_mps		RECORD LIKE mps_file.*,
    g_wc,g_wc2          string,  #No.FUN-580092 HCN
    g_sql               string,  #No.FUN-580092 HCN
    g_mpt           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
			mpt04  	 LIKE mpt_file.mpt04,
			mpt05  	 LIKE mpt_file.mpt05,
                        #t5_name  LIKE mpt_file.mpt05,  #NO.FUN-680101 VARCHAR(10)   #MOD-940414 
                        t5_name  LIKE type_file.chr30,   #No.MOD-940414 
			mpt06  	 LIKE mpt_file.mpt06,
			mpt061 	 LIKE mpt_file.mpt061,
			mpt06_fz LIKE mpt_file.mpt06_fz,
			mpt07    LIKE mpt_file.mpt07,
			mpt08  	 LIKE mpt_file.mpt08
                    END RECORD,
    g_buf           LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(78)
    l_ima25         LIKE ima_file.ima25,
    g_rec_b         LIKE type_file.num5,   #NO.FUN-680101 SMALLINT     #單身筆數
    l_ac            LIKE type_file.num5,   #NO.FUN-680101 SMALLINT     #目前處理的ARRAY CNT
    l_sl            LIKE type_file.num5    #NO.FUN-680101 SMALLINT     #目前處理的SCREEN LINE
 
DEFINE   g_cnt           LIKE type_file.num10    #NO.FUN-680101 INTEGER   
DEFINE   g_msg           LIKE type_file.chr1000  #NO.FUN-680101 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #NO.FUN-680101 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #NO.FUN-680101 INTEGER 
DEFINE   g_jump          LIKE type_file.num10    #NO.FUN-680101 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5     #NO.FUN-680101 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0081
    DEFINE p_row,p_col   LIKE type_file.chr8     #NO.FUN-680101 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
 
    LET g_argv1= ARG_VAL(1)
    LET g_argv2= ARG_VAL(2)
    #TQC-6C0182  --begin
    LET g_argv3= ARG_VAL(3) 
    IF NOT cl_null(g_argv3) THEN
       LET g_dbs = g_argv3
       DATABASE g_dbs
 #      CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
       CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
    END IF
    #TQC-6C0182  --end
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
    LET p_row = 2 LET p_col = 2 
    OPEN WINDOW q510_w AT p_row,p_col
        WITH FORM "ams/42f/amsq510" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
 
    IF NOT cl_null(g_argv1) THEN CALL q510_q() END IF
    CALL q510()
    CLOSE WINDOW q510_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN
 
FUNCTION q510()
    CALL q510_menu()
END FUNCTION
 
FUNCTION q510_cs()
    CLEAR FORM
   CALL g_mpt.clear()
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    IF cl_null(g_argv1) THEN
   INITIALIZE g_mps.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON
              mps_v, mps01, mps00, mps03, mps09,mps11,
              mps039, mps041,mps043,mps044, 
              mps051, mps052, mps053, 
              mps061, mps062, mps063, mps064, mps065, mps06_fz,
              mps071, mps072, mps08
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
     ELSE
       LET g_wc="mps_v='",g_argv1,"'"
       IF NOT cl_null(g_argv2) THEN
          LET g_wc=g_wc CLIPPED, " AND mps01='",g_argv2,"'"
       END IF
    END IF
    IF INT_FLAG THEN RETURN END IF
    LET g_sql="SELECT mps_file.* FROM mps_file ",
              " WHERE ",g_wc CLIPPED," ORDER BY mps_v,mps01,mps03"
    PREPARE q510_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE q510_cs SCROLL CURSOR WITH HOLD FOR q510_prepare
    LET g_sql= "SELECT COUNT(*) FROM mps_file WHERE ",g_wc CLIPPED
    PREPARE q510_precount FROM g_sql
    DECLARE q510_count CURSOR FOR q510_precount
END FUNCTION
 
FUNCTION q510_menu()
 
   WHILE TRUE
      CALL q510_bp("G")
      CASE g_action_choice
         WHEN "query" 
            CALL q510_q() 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
        #@WHEN "工廠切換"
        #WHEN "switch_plant"     #FUN-B10030
        #   CALL q510_d()        #FUN-B10030
#FUN-4B0014
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_mpt),'','')
            END IF
##
      END CASE
   END WHILE
      CLOSE q510_cs
END FUNCTION
 
FUNCTION q510_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q510_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN LET INT_FLAG = 0 CLEAR FORM RETURN END IF
   CALL g_mpt.clear()
   MESSAGE " SEARCHING ! " 
   OPEN q510_count
   FETCH q510_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN q510_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_mps.mps01,SQLCA.sqlcode,0)
       INITIALIZE g_mps.* TO NULL
   ELSE
       CALL q510_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION q510_fetch(p_flmps)
    DEFINE
        p_flmps         LIKE type_file.chr1,    #NO.FUN-680101  VARCHAR(1)
        l_abso          LIKE type_file.num10    #NO.FUN-680101 INTEGER
 
    CASE p_flmps
        WHEN 'N' FETCH NEXT     q510_cs INTO g_mps.*
        WHEN 'P' FETCH PREVIOUS q510_cs INTO g_mps.*
        WHEN 'F' FETCH FIRST    q510_cs INTO g_mps.*
        WHEN 'L' FETCH LAST     q510_cs INTO g_mps.*
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            END IF
            FETCH ABSOLUTE g_jump q510_cs INTO g_mps.*
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_mps.mps01,SQLCA.sqlcode,0)
        INITIALIZE g_mps.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flmps
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
 
    CALL q510_show()                      # 重新顯示
END FUNCTION
 
FUNCTION q510_show()
    DEFINE l_ima	RECORD LIKE ima_file.*
    DEFINE l_pmc	RECORD LIKE pmc_file.*
    DISPLAY BY NAME
              g_mps.mps_v, g_mps.mps01, g_mps.mps03, 
              g_mps.mps00,
              g_mps.mps039,g_mps.mps041,g_mps.mps043,g_mps.mps044, 
              g_mps.mps051,g_mps.mps052,g_mps.mps053,
              g_mps.mps06_fz,
              g_mps.mps061, g_mps.mps062, g_mps.mps063,
              g_mps.mps064, g_mps.mps065, g_mps.mps11,
              g_mps.mps071, g_mps.mps072, g_mps.mps08 , g_mps.mps09
    INITIALIZE l_ima.* TO NULL
    SELECT * INTO l_ima.* FROM ima_file WHERE ima01=g_mps.mps01
    DISPLAY BY NAME l_ima.ima02
    INITIALIZE l_pmc.* TO NULL
    CALL q510_b_fill(' 1=1') 
    CALL q510_b_tot('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q510_out(p_cmd)
   DEFINE p_cmd		    LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1) 
          l_cmd		    LIKE type_file.chr1000, #NO.FUN-680101 VARCHAR(400)
          l_wc              LIKE type_file.chr1000  #NO.FUN-680101 VARCHAR(200)
 
   CALL cl_wait()
   IF p_cmd= 'a'
      THEN LET l_wc = 'mps01="',g_mps.mps01,'"' 		# "新增"則印單張
      ELSE LET l_wc = g_wc                     			# 其他則印多張
   END IF
   IF g_wc IS NULL THEN 
#     CALL cl_err('',-400,0) END IF
       CALL cl_err('','9057',0) RETURN END IF
   LET l_cmd = "amsr510",
               " '",g_today CLIPPED,"' ''",
               " '",g_lang CLIPPED,"' 'Y' '' '1' '",
               l_wc CLIPPED
   CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
 
#FUN-B10030 ----------mark start-----------
#FUNCTION q510_d()  
#  DEFINE l_plant,l_dbs	     LIKE type_file.chr21      #NO.FUN-680101 VARCHAR(21)
#
#           LET INT_FLAG = 0  ######add for prompt bug
#  PROMPT 'PLANT CODE:' FOR l_plant
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
#  DATABASE l_dbs
##   CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
#  CALL cl_ins_del_sid(1,l_plant) #FUN-980030  #FUN-990069
#  IF STATUS THEN ERROR 'open database error!' RETURN END IF
#  LET g_plant = l_plant
#  LET g_dbs   = l_dbs
#END FUNCTION
#FUN-B10030 -----------mark end-----------------
 
FUNCTION q510_b_tot(p_cmd)
   DEFINE p_cmd		LIKE type_file.chr1     #NO.FUN-680101 VARCHAR(1)
END FUNCTION
 
FUNCTION q510_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2            LIKE type_file.chr1000  #NO.FUN-680101 VARCHAR(200)
DEFINE last_qty         LIKE type_file.num10    #NO.FUN-680101 INTEGER
 
    LET g_sql =
        "SELECT mpt04, mpt05,'', mpt06, mpt061, mpt06_fz, mpt07, mpt08", 
        " FROM mpt_file",
        " WHERE mpt_v ='",g_mps.mps_v,"'",
        "   AND mpt01 ='",g_mps.mps01,"'",
        "   AND mpt03 ='",g_mps.mps03,"'",
        " ORDER BY 1,2"
    PREPARE q510_pb FROM g_sql
    DECLARE mps_curs CURSOR FOR q510_pb
 
    CALL g_mpt.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH mps_curs INTO g_mpt[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_mpt[g_cnt].t5_name=s_mpt05(g_mpt[g_cnt].mpt05)
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_mpt.deleteElement(g_cnt)  #No.TQC-6C0158
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2 
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q510_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #NO.FUN-680101 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mpt TO s_mpt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
#        LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q510_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q510_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL q510_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q510_fetch('N') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL q510_fetch('L')
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 工廠切換
    # ON ACTION switch_plant                      #FUN-B10030
    #    LET g_action_choice="switch_plant"       #FUN-B10030
    #    EXIT DISPLAY                             #FUN-B10030
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#FUN-4B0014
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
        #No.MOD-530852  --begin                                                   
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
       #No.MOD-530852  --end          
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION s_mpt05(p1)
   DEFINE p1 STRING   #NO.FUN-680101 VARCHAR(2) 
   DEFINE p2 STRING   #NO.FUN-680101 VARCHAR(10)
        CASE WHEN p1='39' LET p2='預測量'
             WHEN p1='40' LET p2='安全庫存'
             WHEN p1='41' LET p2='獨立需求'
             WHEN p1='42' LET p2='受訂量'
             WHEN p1='43' LET p2='計劃備料'
             WHEN p1='44' LET p2='工單備料'
             WHEN p1='45' LET p2='PLM 備料'
             WHEN p1='51' LET p2='庫存量'
             WHEN p1='52' LET p2='在驗量'
             WHEN p1='53' LET p2='替代量'
             WHEN p1='61' LET p2='請購量'
             WHEN p1='62' LET p2='在採量'
             WHEN p1='63' LET p2='在外量'
             WHEN p1='64' LET p2='在製量'
             WHEN p1='65' LET p2='計劃產'
        END CASE
   RETURN p2
END FUNCTION
