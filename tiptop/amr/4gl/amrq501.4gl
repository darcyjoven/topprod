# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: amrq501.4gl
# Descriptions...: MRP 供需彙總查詢
# Date & Author..: 97/10/24 By Melody
# Modify.........: NO.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: No.MOD-530852 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-660118 06/07/07 By kim 變數改用LIKE
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-920183 09/03/20 By shiwuying MRP功能改善
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.TQC-9B0018 09/11/04 BY xiaofeizhu 修改SQL语法。
# Modify.........: No.FUN-B10030 11/01/19 bY vealxu 拿掉"營運中心切換"ACTION
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1	LIKE mss_file.mss_v,     #NO.FUN-680082 VARCHAR(2)
    g_argv2	LIKE mss_file.mss01,	 # 料號  #NO.MOD-490217
    g_msr	RECORD LIKE msr_file.*,
    h_mss   RECORD
            mss_v	LIKE mss_file.mss_v,
            mss02	LIKE mss_file.mss02,
            mss01	LIKE mss_file.mss01 
            END RECORD,
     g_wc,g_wc2      STRING,     #No.FUN-580092 HCN    
     g_sql           STRING,     #No.FUN-580092 HCN   
     g_mxno          LIKE type_file.num5,       #NO.FUN-680082 SMALLINT
     g_mss           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
			mss00  LIKE mss_file.mss00 , #SMALLINT,#FUN-660118  
			mss03  LIKE mss_file.mss03 , #CHAR(10),#FUN-660118  
			mss041 LIKE mss_file.mss041, #INTEGER, #FUN-660118  
			mss051 LIKE mss_file.mss051, #INTEGER, #FUN-660118  
			bal    LIKE mss_file.mss041, #INTEGER, #FUN-660118  
			mss07  LIKE mss_file.mss071, #INTEGER, #FUN-660118  
			mss08  LIKE mss_file.mss08 , #INTEGER, #FUN-660118  
			mss09  LIKE mss_file.mss09   #INTEGER  #FUN-660118  
                    END RECORD,
    g_buf           LIKE type_file.chr1000,       #NO.FUN-680082 VARCHAR(78) 
    l_ima25         Like ima_file.ima25,
    g_rec_b         LIKE type_file.num5,          #單身筆數               #NO.FUN-680082 SMALLINT
    l_ac            LIKE type_file.num5,          #目前處理的ARRAY CNT    #NO.FUN-680082 SMALLINT
    l_sl            LIKE type_file.num5           #NO.FUN-680082 SMALLINT #目前處理的SCREEN LINE
 
DEFINE   g_cnt           LIKE type_file.num10     #NO.FUN-680082 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000   #NO.FUN-680082 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10     #NO.FUN-680082 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10     #NO.FUN-680082 INTEGER
DEFINE   g_jump          LIKE type_file.num10     #NO.FUN-680082 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5      #NO.FUN-680082 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0076
    DEFINE p_row,p_col   LIKE type_file.num5      #NO.FUN-680082 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1= ARG_VAL(1)
   LET g_argv2= ARG_VAL(2)
 
   INITIALIZE h_mss.* TO NULL
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
   LET p_row = 5 LET p_col = 2 
 
   OPEN WINDOW q501_w AT p_row,p_col WITH FORM "amr/42f/amrq501" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN CALL q501_q() END IF
   CALL q501()
   CLOSE WINDOW q501_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
 
FUNCTION q501()
    CALL q501_menu()
END FUNCTION
 
FUNCTION q501_cs()
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    IF cl_null(g_argv1) THEN
       CLEAR FORM
       CALL g_mss.clear()
   INITIALIZE h_mss.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON mss_v, mss01, mss02 
 
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
       IF INT_FLAG THEN RETURN END IF
     ELSE
       LET g_wc="mss_v='",g_argv1,"' AND mss01='",g_argv2,"'"
    END IF
    LET g_sql="SELECT DISTINCT mss_v,mss02,mss01 FROM mss_file ",
              " WHERE ",g_wc CLIPPED," ORDER BY mss_v,mss01"
    PREPARE q501_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE q501_cs SCROLL CURSOR WITH HOLD FOR q501_prepare
    #----->modi:2842
    DROP TABLE x
    SELECT mss01,mss02,mss_v FROM mss_file GROUP BY mss01,mss02,mss_v INTO TEMP x
    LET g_sql= "SELECT COUNT(*) FROM x WHERE ",g_wc CLIPPED
    #----->(end)
  # LET g_sql= "SELECT COUNT(DISTINCT mss01) FROM mss_file WHERE ",g_wc CLIPPED
    PREPARE q501_precount FROM g_sql
    DECLARE q501_count CURSOR FOR q501_precount
END FUNCTION
 
FUNCTION q501_menu()
 
   WHILE TRUE
      CALL q501_bp("G")
      CASE g_action_choice
         WHEN "query"
            CALL q501_q() 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "明細"
         WHEN "contents"
            LET g_msg="amrq510 '",h_mss.mss_v,"' '",h_mss.mss01,"' ","'",h_mss.mss02,"'"
            CALL cl_cmdrun(g_msg)
       #@WHEN "工廠切換"
       # WHEN "switch_plant"    #FUN-B10030 
       #    CALL q501_d()       #FUN-B10030 
      END CASE
   END WHILE
      CLOSE q501_cs
END FUNCTION
 
FUNCTION q501_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q501_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN LET INT_FLAG = 0 CLEAR FORM RETURN END IF
   CALL g_mss.clear()
   MESSAGE " SEARCHING ! " 
   OPEN q501_count
   FETCH q501_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN q501_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
       CALL cl_err(h_mss.mss01,SQLCA.sqlcode,0)
       INITIALIZE h_mss.* TO NULL
   ELSE
       CALL q501_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION q501_fetch(p_flmss)
    DEFINE
        p_flmss          LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
        l_abso           LIKE type_file.num10    #NO.FUN-680082 INTEGER
 
    CASE p_flmss
        WHEN 'N' FETCH NEXT     q501_cs INTO h_mss.*
        WHEN 'P' FETCH PREVIOUS q501_cs INTO h_mss.*
        WHEN 'F' FETCH FIRST    q501_cs INTO h_mss.*
        WHEN 'L' FETCH LAST     q501_cs INTO h_mss.*
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump q501_cs INTO h_mss.*
             LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(h_mss.mss01,SQLCA.sqlcode,0)
        INITIALIZE h_mss.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flmss
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
 
    CALL q501_show()                      # 重新顯示
END FUNCTION
 
FUNCTION q501_show()
    DEFINE l_ima	RECORD LIKE ima_file.*
    DEFINE l_pmc	RECORD LIKE pmc_file.*
    DISPLAY BY NAME h_mss.mss_v, h_mss.mss01, h_mss.mss02
    INITIALIZE g_msr.* TO NULL
    SELECT * INTO g_msr.* FROM msr_file WHERE msr_v=h_mss.mss_v
    INITIALIZE l_ima.* TO NULL
    SELECT * INTO l_ima.* FROM ima_file WHERE ima01=h_mss.mss01
    DISPLAY BY NAME l_ima.ima02
    INITIALIZE l_pmc.* TO NULL
    SELECT * INTO l_pmc.* FROM pmc_file WHERE pmc01=h_mss.mss02
    DISPLAY BY NAME l_pmc.pmc03
    CALL q501_b_fill(' 1=1')
    CALL q501_b_tot('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q501_out(p_cmd)
   DEFINE p_cmd	 LIKE type_file.chr1,   #NO.FUN-680082 VARCHAR(1)
          l_cmd	 LIKE type_file.chr1000,#NO.FUN-680082 VARCHAR(400)
          l_wc   LIKE type_file.chr1000 #NO.FUN-680082 VARCHAR(200)
 
   CALL cl_wait()
   IF p_cmd= 'a'
      THEN LET l_wc = 'mss01="',h_mss.mss01,'"' 		# "新增"則印單張
      ELSE LET l_wc = g_wc                     			# 其他則印多張
   END IF
   IF g_wc IS NULL THEN 
#     CALL cl_err('',-400,0) END IF
       CALL cl_err('','9057',0) RETURN END IF
   LET l_cmd = "amrr510",
               " '",g_today CLIPPED,"' ''",
               " '",g_lang CLIPPED,"' 'Y' '' '1' '",
               l_wc CLIPPED
   CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
 
#FUN-B10030 ----------mark start----------
#FUNCTION q501_d()
#  DEFINE l_plant,l_dbs	      LIKE type_file.chr21    #NO.FUN-680082 VARCHAR(21)
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
#FUN-B10030 ----------mark end-------------------
 
FUNCTION q501_b_tot(p_cmd)
   DEFINE p_cmd		LIKE type_file.chr1     #NO.FUN-680082 VARCHAR(1)
END FUNCTION
 
FUNCTION q501_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000   #NO.FUN-680082 VARCHAR(200)
#DEFINE last_qty        INTEGER #FUN-660118
 DEFINE last_qty        LIKE mss_file.mss08 #FUN-660118
 
    LET g_sql =
#       "SELECT mss00, convert(char(10),msk_d,111),(mss041+mss043+mss044),",                    #TQC-9B0018 Mark
        "SELECT mss00,cast(msk_d AS char(10)),(mss041+mss043+mss044),",                         #TQC-9B0018 Add
        "      (mss051+mss052+mss053+mss061+mss062+mss063+mss064+mss065),",#
        "      0, mss072-mss071, mss08, mss09",
        " FROM msk_file LEFT OUTER JOIN mss_file ON msk_file.msk_v=mss_file.mss_v AND msk_file.msk_d=mss_file.mss03",
        " WHERE msk_v ='",h_mss.mss_v,"'",
        "   AND mss_file.mss01 ='",h_mss.mss01,"' AND mss_file.mss02 ='",h_mss.mss02,"'",
        " ORDER BY 2,1"
    PREPARE q501_pb FROM g_sql
    DECLARE mss_curs CURSOR FOR q501_pb
 
    FOR g_cnt = 1 TO g_mss.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_mss[g_cnt].* TO NULL
    END FOR
                LET g_mss[31].mss041=0
                LET g_mss[31].mss051=0
                LET g_mss[31].mss09 =0
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH mss_curs INTO g_mss[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
        IF g_mss[g_cnt].mss041 IS NULL THEN
           IF g_cnt = 1
              THEN LET g_mss[g_cnt].mss08=0
              ELSE LET g_mss[g_cnt].mss08=g_mss[g_cnt-1].mss08+
                                          g_mss[g_cnt-1].mss09
           END IF
           LET g_mss[g_cnt].mss09 = 0
        END IF
        IF g_cnt = 1
           THEN LET last_qty=0
           ELSE LET last_qty=g_mss[g_cnt-1].mss08+g_mss[g_cnt-1].mss09
        END IF
        IF g_mss[g_cnt].mss041 IS NULL
           THEN LET g_mss[g_cnt].bal=last_qty
           ELSE LET g_mss[g_cnt].bal=last_qty
                                     +g_mss[g_cnt].mss051-g_mss[g_cnt].mss041
                LET g_mss[31].mss041=g_mss[31].mss041+g_mss[g_cnt].mss041
                LET g_mss[31].mss051=g_mss[31].mss051+g_mss[g_cnt].mss051
                LET g_mss[31].mss09 =g_mss[31].mss09 +g_mss[g_cnt].mss09 
        END IF
    #No.FUN-920183 start -----
        IF (g_mss[g_cnt].mss041 = 0 OR cl_null(g_mss[g_cnt].mss041)) AND
           (g_mss[g_cnt].mss051 = 0 OR cl_null(g_mss[g_cnt].mss051)) AND
           (g_mss[g_cnt].mss07  = 0 OR cl_null(g_mss[g_cnt].mss07)) AND
           (g_mss[g_cnt].mss08  = 0 OR cl_null(g_mss[g_cnt].mss08)) AND
           (g_mss[g_cnt].mss09  = 0 OR cl_null(g_mss[g_cnt].mss09)) THEN
           CONTINUE FOREACH
        END IF
    #No.FUN-920183 end -------
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    LET g_mss[g_cnt].*=g_mss[31].*
    LET g_mss[g_cnt].mss03='  合  計'
    LET g_mss[g_cnt].bal  =NULL
    LET g_mss[g_cnt].mss07=NULL
    LET g_mss[g_cnt].mss08=NULL
    INITIALIZE g_mss[31] TO NULL    #genero 會多一筆
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
END FUNCTION
 
FUNCTION q501_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       #NO.FUN-680082 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mss TO s_mss.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q501_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q501_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL q501_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q501_fetch('N') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL q501_fetch('L')
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
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 明細單身
      ON ACTION contents
         LET g_action_choice="contents"
         EXIT DISPLAY
    #@ON ACTION 工廠切換
    # ON ACTION switch_plant                         #FUN-B10030
    #    LET g_action_choice="switch_plant"          #FUN-B10030
    #    EXIT DISPLAY                                #FUN-B10030
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
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
 
 
