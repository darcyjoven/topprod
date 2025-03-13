# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amrq510.4gl
# Descriptions...: MRP 供需明細查詢
# Date & Author..: 96/05/06 By Roger
# Modify.........: No.MOD-480592 04/08/31 By Carol mss11/mss09 field 對調 
# Modify.........: NO.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: No.FUN-4B0013 04/11/08 By ching add '轉Excel檔' action
# Modify.........: No.MOD-4C0087 04/12/16 By DAY  加入用"*"關閉窗口,單身翻頁顯示錯誤更正
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6B0064 06/11/14 By Carrier 長度為CHAR(21)的azp03定義改為type_file.chr21
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6C0158 06/12/26 By day 單身匯出excel多一空白行
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-830079 08/05/11 By Carol t5_name型態改用char(30)
# Modify.........: No.FUN-920183 09/03/20 By shiwuying MRP功能改善
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.TQC-A40037 10/04/07 By lilingyu 改正FUN-920183的BUG
# Modify.........: No.TQC-A40051 10/04/09 By destiny 查询报-217的错   
# Modify.........: No.TQC-A40055 10/04/09 By destiny 重新过单  
# Modify.........: No.FUN-A90057 10/09/27 By kim GP5.25號機管理
# Modify.........: No.TQC-AC0063 10/12/07 By Mengxw  GP5.25單身中mst08欄位的資料帶到mst07中 
# Modify.........: No.FUN-B10030 11/01/19 By vealxu 拿掉"營運中心切換"ACTION

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_argv1		LIKE mss_file.mss_v,     # Prog. Version..: '5.30.06-13.03.12(02)  # 版本
     g_argv2		LIKE mss_file.mss01,	 # 料號 NO.MOD-490217
     g_argv3		LIKE mss_file.mss02,     # 廠牌       #NO.FUN-680082 VARCHAR(20)
     g_mss		RECORD LIKE mss_file.*,
     g_wc                STRING,  #No.FUN-580092 HCN  
     g_sql               STRING,  #No.FUN-580092 HCN  
     g_mst               DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
			mst04  	 LIKE mst_file.mst04,
			mst05  	 LIKE mst_file.mst05,
			t5_name  LIKE type_file.chr30,  #MOD-830079-modify  #NO.FUN-680082 VARCHAR(10)
			mst06  	 LIKE mst_file.mst06,
			mst061 	 LIKE mst_file.mst061,
			lot_no 	 LIKE oeb_file.oeb919,  #FUN-A9007
			mst06_fz LIKE mst_file.mst06_fz,
			mst07  	 LIKE mst_file.mst07,
			mst08  	 LIKE mst_file.mst08
                    END RECORD,
    g_buf                  LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(78)
    l_ima25                like ima_file.ima25,
    g_rec_b                LIKE type_file.num5,    #單身筆數              #NO.FUN-680082 SMALLINT
    l_ac                   LIKE type_file.num5,    #目前處理的ARRAY CNT   #NO.FUN-680082 SMALLINT
    l_sl                   LIKE type_file.num5     #目前處理的SCREEN LINE #NO.FUN-680082 SMALLINT
 
DEFINE   g_cnt             LIKE type_file.num10     #NO.FUN-680082 INTEGER 
DEFINE   g_msg             LIKE type_file.chr1000   #NO.FUN-680082 VARCHAR(72)
DEFINE   g_row_count       LIKE type_file.num10     #NO.FUN-680082 INTEGER 
DEFINE   g_curs_index      LIKE type_file.num10     #NO.FUN-680082 INTEGER 
DEFINE   g_jump            LIKE type_file.num10     #NO.FUN-680082 INTEGER 
DEFINE   mi_no_ask         LIKE type_file.num5      #NO.FUN-680082 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0076
    DEFINE p_row,p_col     LIKE type_file.num5      #NO.FUN-680082 SMALLINT
 
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
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)              #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time                     #No.FUN-6A0076
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
 
    INITIALIZE g_mss.* TO NULL
    LET p_row = 2 LET p_col = 2 
 
    OPEN WINDOW q510_w AT p_row,p_col
         WITH FORM "amr/42f/amrq510"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    #FUN-A90057(S)
    IF g_sma.sma1421='Y' THEN
       CALL cl_set_comp_visible("lot_no",TRUE)   #FUN-A90057    
    ELSE
       CALL cl_set_comp_visible("lot_no",FALSE)  #FUN-A90057
    END IF
    #FUN-A90057(E)
    IF NOT cl_null(g_argv1) THEN CALL q510_q() END IF
    CALL q510_menu()
    CLOSE WINDOW q510_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
 
FUNCTION q510_cs()
    CLEAR FORM
   CALL g_mst.clear()
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    IF cl_null(g_argv1) THEN
   INITIALIZE g_mss.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON
               mss_v, mss01, mss02, mss00, mss03,mss11,mss09,  #MOD-480592
              mss041, mss043, mss044, 
              mss051, mss052, mss053,
              mss061, mss062, mss063, mss064, mss065, mss06_fz,
              mss071, mss072, mss08 
 
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
       LET g_wc="mss_v='",g_argv1,"'"
       IF NOT cl_null(g_argv2) THEN
          LET g_wc=g_wc CLIPPED, " AND mss01='",g_argv2,"'"
       END IF
       IF NOT cl_null(g_argv3) THEN
          LET g_wc=g_wc CLIPPED, " AND mss02='",g_argv3,"'"
       END IF
    END IF
 #No.FUN-920183 start -----
  # LET g_wc =g_wc CLIPPED, " AND NOT EXISTS(SELECT 1 FROM mss_file",  #TQC-A40037 MARK
    LET g_wc =g_wc CLIPPED, " MINUS SELECT * FROM mss_file",           #TQC-A40037
                            " WHERE ",g_wc CLIPPED,
                            " AND ((mss041 = 0 OR mss041 IS NULL) ",
                            " AND (mss043 = 0 OR mss043 IS NULL) ",
                            " AND (mss044 = 0 OR mss044 IS NULL) ",
                            " AND (mss051 = 0 OR mss051 IS NULL) ",
                            " AND (mss052 = 0 OR mss052 IS NULL) ",
                            " AND (mss053 = 0 OR mss053 IS NULL) ",
                            " AND (mss061 = 0 OR mss061 IS NULL) ",
                            " AND (mss062 = 0 OR mss062 IS NULL) ",
                            " AND (mss063 = 0 OR mss063 IS NULL) ",
                            " AND (mss064 = 0 OR mss064 IS NULL) ",
                            " AND (mss065 = 0 OR mss065 IS NULL) ",
                            " AND (mss071 = 0 OR mss071 IS NULL) ",
                            " AND (mss072 = 0 OR mss072 IS NULL) ",
                            " AND (mss08  = 0 OR mss08  IS NULL) ",
                          # " AND (mss09  = 0 OR mss09  IS NULL)))"  #TQC-A40037 MARK
                            " AND (mss09  = 0 OR mss09  IS NULL))"   #TQC-A40037 
 #No.FUN-920183 end -------
    IF INT_FLAG THEN RETURN END IF
    LET g_sql="SELECT mss_file.* FROM mss_file ",
#             " WHERE ",g_wc CLIPPED," ORDER BY mss_v,mss01,mss02,mss03"                #No.TQC-A40051
              " WHERE ",g_wc CLIPPED                                                    #No.TQC-A40051  
    PREPARE q510_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE q510_cs SCROLL CURSOR WITH HOLD FOR q510_prepare
   #LET g_sql= "SELECT COUNT(*) FROM mss_file WHERE ",g_wc CLIPPED                      #No.TQC-A40051
    LET g_sql= "SELECT COUNT(*) FROM (SELECT * FROM mss_file WHERE ",g_wc CLIPPED,")"   #No.TQC-A40051
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
 
         #FUN-4B0013
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_mst),'','')
             END IF
         #--
 
       #@WHEN "工廠切換"
       # WHEN "switch_plant"       #FUN-B10030
       #    CALL q510_d()          #FUN-B10030
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
   CALL g_mst.clear()
   MESSAGE " SEARCHING ! " 
   OPEN q510_count
   FETCH q510_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN q510_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_mss.mss01,SQLCA.sqlcode,0)
       INITIALIZE g_mss.* TO NULL
   ELSE
       CALL q510_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION q510_fetch(p_flmss)
    DEFINE
        p_flmss         LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
        l_abso          LIKE type_file.num10    #NO.FUN-680082 INTEGER
 
    CASE p_flmss
        WHEN 'N' FETCH NEXT     q510_cs INTO g_mss.*
        WHEN 'P' FETCH PREVIOUS q510_cs INTO g_mss.*
        WHEN 'F' FETCH FIRST    q510_cs INTO g_mss.*
        WHEN 'L' FETCH LAST     q510_cs INTO g_mss.*
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
            FETCH ABSOLUTE g_jump q510_cs INTO g_mss.*
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_mss.mss01,SQLCA.sqlcode,0)
        INITIALIZE g_mss.* TO NULL  #TQC-6B0105
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
 
 
    CALL q510_show()                      # 重新顯示
END FUNCTION
 
FUNCTION q510_show()
    DEFINE l_ima	RECORD LIKE ima_file.*
    DEFINE l_pmc	RECORD LIKE pmc_file.*
    DISPLAY BY NAME
              g_mss.mss_v, g_mss.mss01, g_mss.mss02, g_mss.mss03, 
              g_mss.mss00, g_mss.mss041, g_mss.mss043, g_mss.mss044, 
              g_mss.mss051, g_mss.mss052, g_mss.mss053,
              g_mss.mss06_fz,
              g_mss.mss061, g_mss.mss062, g_mss.mss063,
              g_mss.mss064, g_mss.mss065, g_mss.mss11,
              g_mss.mss071, g_mss.mss072, g_mss.mss08 , g_mss.mss09
    INITIALIZE l_ima.* TO NULL
    SELECT * INTO l_ima.* FROM ima_file WHERE ima01=g_mss.mss01
    DISPLAY BY NAME l_ima.ima02
    INITIALIZE l_pmc.* TO NULL
    SELECT * INTO l_pmc.* FROM pmc_file WHERE pmc01=g_mss.mss02
    DISPLAY BY NAME l_pmc.pmc03
    CALL q510_b_fill(' 1=1')
    CALL q510_b_tot('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q510_out(p_cmd)
   DEFINE p_cmd		    LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
          l_cmd		    LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(400)
          l_wc              LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(200)
 
   CALL cl_wait()
   IF p_cmd= 'a'
      THEN LET l_wc = 'mss01="',g_mss.mss01,'"' 		# "新增"則印單張
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
 
#FUN-B10030 ----------mark start------------
#FUNCTION q510_d()
#  DEFINE l_plant,l_dbs	  LIKE type_file.chr21     #NO.FUN-680082 VARCHAR(21) #No.TQC-6B0064
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
#FUN-B10030 -----------mark end----------------
 
FUNCTION q510_b_tot(p_cmd)
   DEFINE p_cmd		LIKE type_file.chr1      #NO.FUN-680082 VARCHAR(1)
END FUNCTION
 
FUNCTION q510_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000       #NO.FUN-680082 VARCHAR(200)
DEFINE last_qty        LIKE type_file.num10         #NO.FUN-680082 INTEGER
 
    LET g_sql =
       #"SELECT DISTINCT mst04, mst05, '',mst06, mst061,'', mst06_fz, mst07, mst08",  #No.TQC-A40051 add distinct  #FUN-A90057
        "SELECT mst04, mst05, '',mst06, mst061,'', mst06_fz, mst07, mst08",  #No.TQC-A40055 #TQC-AC0063 add '' between mst061 and mst06_fz
        " FROM mst_file",
        " WHERE mst_v ='",g_mss.mss_v,"'",
        "   AND mst01 ='",g_mss.mss01,"' AND mst02 ='",g_mss.mss02,"'",
        "   AND mst03 ='",g_mss.mss03,"'",
         " ORDER BY mst04,mst05" #MOD-4C0087
 #        " ORDER BY 1,2"  #MOD-4C0087
    PREPARE q510_pb FROM g_sql
    DECLARE mss_curs CURSOR FOR q510_pb
 
    CALL g_mst.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH mss_curs INTO g_mst[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_mst[g_cnt].t5_name=s_mst05(g_lang,g_mst[g_cnt].mst05)
        LET g_mst[g_cnt].lot_no=q510_get_lot_no(g_mst[g_cnt].mst05,g_mst[g_cnt].mst06,g_mst[g_cnt].mst061)  #FUN-A90057
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_mst.deleteElement(g_cnt)  #No.TQC-6C0158
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2 
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q510_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       #NO.FUN-680082 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_mst TO s_mst.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #MOD-520097
 
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
          EXIT DISPLAY  #MOD-4C0087                              
 
      ON ACTION previous
         CALL q510_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY  #MOD-4C0087                              
                              
 
      ON ACTION jump 
         CALL q510_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY  #MOD-4C0087                              
                              
 
      ON ACTION next
         CALL q510_fetch('N') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY  #MOD-4C0087                              
                              
 
      ON ACTION last 
         CALL q510_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY  #MOD-4C0087                              
                              
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 #MOD-4C0087--begin
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 #MOD-4C0087--end
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 工廠切換
    # ON ACTION switch_plant                #FUN-B10030
    #    LET g_action_choice="switch_plant" #FUN-B10030 
    #    EXIT DISPLAY                       #FUN-B10030
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0013
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#FUN-A90057(S)
FUNCTION q510_get_lot_no(p_mst05,p_mst06,p_mst061)
   DEFINE l_lot_no LIKE oeb_file.oeb919
   DEFINE p_mst05  LIKE mst_file.mst05 
   DEFINE p_mst06  LIKE mst_file.mst06 
   DEFINE p_mst061 LIKE mst_file.mst061
   
   IF (NOT g_sma.sma1421='Y') OR (g_sma.sma1421 IS NULL) THEN
      RETURN NULL
   END IF
   CASE p_mst05
      WHEN '42'  #受訂量
         SELECT oeb919 INTO l_lot_no FROM oeb_file
          WHERE oeb01 = p_mst06
            AND oeb03 = p_mst061
      WHEN '43'  #MPS
         SELECT msb919 INTO l_lot_no FROM msb_file
          WHERE msb01 = p_mst06
            AND msb02 = p_mst061   
      WHEN '44'  #備料量
         SELECT sfb919 INTO l_lot_no FROM sfb_file
          WHERE sfb01 = p_mst06
      OTHERWISE
         LET l_lot_no = NULL
   END CASE
   RETURN l_lot_no
END FUNCTION
#FUN-A90057(E)
