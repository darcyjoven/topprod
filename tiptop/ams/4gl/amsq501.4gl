# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amsq501.4gl
# Descriptions...: MRP 供需彙總查詢
# Date & Author..: 97/10/24 By Melody
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: No.MOD-530852 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-660118 06/07/07 By kim 變數改用LIKE
# Modify.........: No.FUN-680101 06/08/30 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.CHI-690028 06/11/16 By pengu 查詢結果與amsq500不一致
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6C0182 06/12/27 By Elva 營運中心切換后明細單身未切換
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.TQC-AB0400 10/11/30 By vealxu 版本：kim-1，時距日顯示"星號"
# Modify.........: No.FUN-B10030 11/01/19 By vealxu 拿掉"營運中心切換"ACTION
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1     LIKE mps_file.mps_v,    #NO.FUN-680101 VARCHAR(2)     # 版本
    g_argv2	LIKE mps_file.mps01,	# 料號 No.MOD-490217
    g_msr	RECORD LIKE msr_file.*,
    h_mps   RECORD
            mps_v	LIKE mps_file.mps_v,
            mps01	LIKE mps_file.mps01
            END RECORD,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_mxno               LIKE type_file.num5,         #NO.FUN-680101 SMALLINT
    g_mps                DYNAMIC ARRAY OF RECORD      #程式變數(Program Variables)
		        mps00  LIKE mps_file.mps00 , #SMALLINT,#FUN-660118
         	#	mps03  LIKE type_file.chr8,  #CHAR(8), #FUN-660118 #NO.FUN-680101 VARCHAR(8)    #TQC-AB0400
                        mps03  LIKE mps_file.mps03,  #TQC-AB0400
			mps039 LIKE mps_file.mps039, #INTEGER, #FUN-660118
			mps041 LIKE mps_file.mps041, #INTEGER, #FUN-660118
			mps043 LIKE mps_file.mps043, #INTEGER, #FUN-660118
			mps051 LIKE mps_file.mps051, #INTEGER, #FUN-660118
			bal    LIKE mps_file.mps039, #INTEGER, #FUN-660118
			mps07  LIKE mps_file.mps071, #INTEGER, #FUN-660118
			mps08  LIKE mps_file.mps08 , #INTEGER, #FUN-660118
			mps09  LIKE mps_file.mps09   #INTEGER  #FUN-660118
                    END RECORD,
    g_buf           LIKE type_file.chr1000, #NO.FUN-680101 VARCHAR(78)
    l_ima25         LIKE ima_file.ima25,
    g_rec_b         LIKE type_file.num5,    #NO.FUN-680101 SMALLINT  #單身筆數
    l_ac            LIKE type_file.num5,    #NO.FUN-680101 SMALLINT  #目前處理的ARRAY CNT
    l_sl            LIKE type_file.num5     #NO.FUN-680101 SMALLINT  #目前處理的SCREEN LINE
 
DEFINE   g_cnt          LIKE type_file.num10    #NO.FUN-680101 INTEGER   
DEFINE   g_msg          LIKE type_file.chr1000  #NO.FUN-680101 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10    #NO.FUN-680101 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #NO.FUN-680101 INTEGER
DEFINE   g_jump         LIKE type_file.num10    #NO.FUN-680101 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5     #NO.FUN-680101 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0081
    DEFINE p_row,p_col  LIKE type_file.num5     #NO.FUN-680101 SMALLINT
 
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
    INITIALIZE h_mps.* TO NULL
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
    LET p_row = 4 LET p_col = 2 
    OPEN WINDOW q501_w AT p_row,p_col
        WITH FORM "ams/42f/amsq501" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
 
    IF NOT cl_null(g_argv1) THEN CALL q501_q() END IF
    CALL q501()
    CLOSE WINDOW q501_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN
 
FUNCTION q501()
    CALL q501_menu()
END FUNCTION
 
FUNCTION q501_cs()
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    IF cl_null(g_argv1) THEN
       CLEAR FORM
   CALL g_mps.clear()
   INITIALIZE h_mps.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON mps_v, mps01 
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
       LET g_wc="mps_v='",g_argv1,"' AND mps01='",g_argv2,"'"
    END IF
    LET g_sql="SELECT DISTINCT mps_v,mps01 FROM mps_file ",
              " WHERE ",g_wc CLIPPED," ORDER BY 1,2"
    PREPARE q501_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE q501_cs SCROLL CURSOR WITH HOLD FOR q501_prepare
    #----->modi:2842
    DROP TABLE x
     SELECT mps01,mps_v FROM mps_file GROUP BY mps01,mps_v INTO TEMP x
    LET g_sql= "SELECT COUNT(*) FROM x WHERE ",g_wc CLIPPED
    #----->(end)
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
        #   LET g_msg="amsq510 '",h_mps.mps_v,"' '",h_mps.mps01,"' " #TQC-6C0182
            LET g_msg="amsq510 '",h_mps.mps_v,"' '",h_mps.mps01,"' '",g_dbs,"' " #TQC-6C0182
            CALL cl_cmdrun(g_msg)
        #@WHEN "工廠切換"
        #WHEN "switch_plant"      #FUN-B10030
        #   CALL q501_d()         #FUN-B10030
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
   CALL g_mps.clear()
   MESSAGE " SEARCHING ! " 
   OPEN q501_count
   FETCH q501_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN q501_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
       CALL cl_err(h_mps.mps01,SQLCA.sqlcode,0)
       INITIALIZE h_mps.* TO NULL
   ELSE
       CALL q501_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION q501_fetch(p_flmps)
    DEFINE
        p_flmps         LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1) 
        l_abso          LIKE type_file.num10    #NO.FUN-680101 INTEGER
 
    CASE p_flmps
        WHEN 'N' FETCH NEXT     q501_cs INTO h_mps.*
        WHEN 'P' FETCH PREVIOUS q501_cs INTO h_mps.*
        WHEN 'F' FETCH FIRST    q501_cs INTO h_mps.*
        WHEN 'L' FETCH LAST     q501_cs INTO h_mps.*
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
            FETCH ABSOLUTE g_jump q501_cs INTO h_mps.*
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(h_mps.mps01,SQLCA.sqlcode,0)
        INITIALIZE h_mps.* TO NULL  #TQC-6B0105
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
 
 
    CALL q501_show()                      # 重新顯示
END FUNCTION
 
FUNCTION q501_show()
    DEFINE l_ima	RECORD LIKE ima_file.*
    DEFINE l_pmc	RECORD LIKE pmc_file.*
    DISPLAY BY NAME h_mps.mps_v, h_mps.mps01
    INITIALIZE g_msr.* TO NULL
    SELECT * INTO g_msr.* FROM msr_file WHERE msr_v=h_mps.mps_v
    INITIALIZE l_ima.* TO NULL
    SELECT * INTO l_ima.* FROM ima_file WHERE ima01=h_mps.mps01
    DISPLAY BY NAME l_ima.ima02
    CALL q501_b_fill(' 1=1') 
    CALL q501_b_tot('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#FUN-B10030 -----------mark start------------
#FUNCTION q501_d()
#  DEFINE l_plant,l_dbs	  LIKE type_file.chr21    #NO.FUN-680101 VARCHAR(21)
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
#FUN-B10030 -------------mark end--------------
 
FUNCTION q501_b_tot(p_cmd)
   DEFINE p_cmd		LIKE type_file.chr1      #NO.FUN-680101 VARCHAR(1)
END FUNCTION
 
FUNCTION q501_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2            STRING 
#DEFINE last_qty        LIKE type_file.num10         #FUN-660118
 DEFINE last_qty        LIKE mps_file.mps08          #FUN-660118
 
    LET g_sql =
        "SELECT mps00,mpk_d,mps039,mps041,(mps043+mps044),",
        "      (mps051+mps052+mps053+mps061+mps062+mps063+mps064+mps065),",#
        "      0, mps072-mps071, mps08, mps09",
        " FROM mpk_file LEFT OUTER JOIN mps_file ON mpk_v=mps_v AND mpk_d=mps03 AND mps_file.mps01 ='",h_mps.mps01,"'",
        " WHERE mpk_v ='",h_mps.mps_v,"'",
        " ORDER BY 2,1"
    PREPARE q501_pb FROM g_sql
    DECLARE mps_curs CURSOR FOR q501_pb
 
    CALL g_mps.clear() 
    LET g_mps[31].mps039=0
    LET g_mps[31].mps041=0
    LET g_mps[31].mps043=0
    LET g_mps[31].mps051=0
    LET g_mps[31].mps09 =0
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH mps_curs INTO g_mps[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        IF g_mps[g_cnt].mps041 IS NULL THEN
           IF g_cnt = 1
              THEN LET g_mps[g_cnt].mps08=0
              ELSE LET g_mps[g_cnt].mps08=g_mps[g_cnt-1].mps08+
                                          g_mps[g_cnt-1].mps09
           END IF
           LET g_mps[g_cnt].mps09 = 0
        END IF
        IF g_cnt = 1
           THEN LET last_qty=0
           ELSE LET last_qty=g_mps[g_cnt-1].mps08+g_mps[g_cnt-1].mps09
        END IF
        IF g_mps[g_cnt].mps041 IS NULL
           THEN LET g_mps[g_cnt].bal=last_qty
          #------------No.CHI-690028 modify
          #ELSE LET g_mps[g_cnt].bal=last_qty
          #                          +g_mps[g_cnt].mps051-g_mps[g_cnt].mps041
           ELSE LET g_mps[g_cnt].bal=last_qty
                                     +g_mps[g_cnt].mps051-g_mps[g_cnt].mps041
                                     -g_mps[g_cnt].mps039-g_mps[g_cnt].mps043
          #------------No.CHI-690028 end
                LET g_mps[31].mps039=g_mps[31].mps039+g_mps[g_cnt].mps039
                LET g_mps[31].mps041=g_mps[31].mps041+g_mps[g_cnt].mps041
                LET g_mps[31].mps043=g_mps[31].mps043+g_mps[g_cnt].mps043   #No.CHI-690028 add
                LET g_mps[31].mps051=g_mps[31].mps051+g_mps[g_cnt].mps051
                LET g_mps[31].mps09 =g_mps[31].mps09 +g_mps[g_cnt].mps09 
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    LET g_mps[g_cnt].*=g_mps[31].*
    LET g_mps[g_cnt].mps03='  合  計'
    LET g_mps[g_cnt].bal  =NULL
    LET g_mps[g_cnt].mps07=NULL
    LET g_mps[g_cnt].mps08=NULL
    INITIALIZE g_mps[31] TO NULL    #genero 會多一筆
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
END FUNCTION
 
FUNCTION q501_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #NO.FUN-680101 
 
 
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mps TO s_mps.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
    # ON ACTION switch_plant                       #FUN-B10030
    #    LET g_action_choice="switch_plant"        #FUN-B10030
    #    EXIT DISPLAY                              #FUN-B10030
 
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
 
