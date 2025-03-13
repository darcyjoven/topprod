# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amrq500.4gl
# Descriptions...: MRP 供需彙總查詢
# Date & Author..: 96/05/06 By Roger
# Modify.........: NO.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: No.MOD-4C0087 04/12/16 By DAY  加入用"*"關閉窗口
# Modify.........: No.MOD-540164 05/04/22 By Carol 查詢時資料如果大於31筆時,則第31筆的資料會異常
# Modify.........: No.TQC-5A0134 05/10/31 By Rosayu VARCHAR-> CHAR
# Modify.........: No.MOD-620062 06/02/22 By Carol mss00 type設定改為 like mss_file
# Modify.........: No.FUN-660118 06/07/07 By kim 變數改用LIKE
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE 
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-850096 08/08/13 By sherry 增加刪除歷史資料
# Modify.........: No.MOD-8B0082 08/11/14 By Pengu 程式在做檔案碼別轉換時不應考慮資料庫型態
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING  
# Modify.........: No.FUN-920183 09/03/20 By shiwuying MRP功能改善
# Modify.........: No.FUN-980004 09/08/12 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.TQC-9B0012 09/11/03 BY liuxqa 修改SQL语法。
# Modify.........: No.FUN-A30038 09/03/09 By lutingting windows改用zhcode方式來進行轉碼
# Modify.........: No.FUN-A80150 10/09/07 By sabrina 新增"計畫批號"(lot_no1)欄位
# Modify.........: No.FUN-A90057 10/09/27 By kim GP5.25號機管理
# Modify.........: No:FUN-B10030 11/01/19 By Mengxw Remove "switch_plant"action
# Modify.........: No:TQC-B30055 11/03/07 By destiny 过单                           
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.MOD-C30272 12/03/11 By fengrui 重組下載m_file路徑

IMPORT os    #FUN-A30038
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1	LIKE mss_file.mss_v,        # 版本  #NO.FUN-680082 VARCHAR(2)
    g_argv2	LIKE mss_file.mss01,	    # 料號  NO.MOD-490217
    g_msr	RECORD LIKE msr_file.*,
    h_mss   RECORD
            mss_v	LIKE mss_file.mss_v,
            mss02	LIKE mss_file.mss02,
            mss01	LIKE mss_file.mss01
            END RECORD,
    g_wc,g_wc2      STRING,  #No.FUN-580092 HCN
    g_sql           STRING,  #No.FUN-580092 HCN  
    g_mxno          LIKE type_file.num5,    #NO FUN-680082 SMALLINT
    g_mss           DYNAMIC ARRAY OF RECORD            #程式變數(Program Variables)
#                       mss00   SMALLINT,              #MOD-620062 mark
                        mss00   LIKE mss_file.mss00,   #MOD-620062 modify
			mss03  	LIKE mss_file.mss03,  #CHAR(10), #FUN-660118
			mss041  LIKE mss_file.mss041, #INTEGER #FUN-660118
			mss043  LIKE mss_file.mss043, #INTEGER #FUN-660118
			mss044  LIKE mss_file.mss044, #INTEGER #FUN-660118
			mss051  LIKE mss_file.mss051, #INTEGER #FUN-660118
			mss052  LIKE mss_file.mss052, #INTEGER #FUN-660118
			mss053  LIKE mss_file.mss053, #INTEGER #FUN-660118
			mss061  LIKE mss_file.mss061, #INTEGER #FUN-660118
			mss062  LIKE mss_file.mss062, #INTEGER #FUN-660118
			mss063  LIKE mss_file.mss063, #INTEGER #FUN-660118
			mss064  LIKE mss_file.mss064, #INTEGER #FUN-660118
			mss065  LIKE mss_file.mss065, #INTEGER #FUN-660118
			bal     LIKE mss_file.mss041, #INTEGER #FUN-660118
			mss07   LIKE mss_file.mss071, #INTEGER #FUN-660118
			mss08   LIKE mss_file.mss08, #INTEGER #FUN-660118
			mss09   LIKE mss_file.mss09  #INTEGER #FUN-660118
                    END RECORD,
 #MOD-540164
    g_mss_t         RECORD                             #程式變數(Program Variables)
#                       mss00   SMALLINT,              #MOD-620062 mark
                        mss00   LIKE mss_file.mss00,   #MOD-620062 modify
			mss03  	LIKE mss_file.mss03,  #CHAR(10), #FUN-660118
			mss041  LIKE mss_file.mss041, #INTEGER #FUN-660118
			mss043  LIKE mss_file.mss043, #INTEGER #FUN-660118
			mss044  LIKE mss_file.mss044, #INTEGER #FUN-660118
			mss051  LIKE mss_file.mss051, #INTEGER #FUN-660118
			mss052  LIKE mss_file.mss052, #INTEGER #FUN-660118
			mss053  LIKE mss_file.mss053, #INTEGER #FUN-660118
			mss061  LIKE mss_file.mss061, #INTEGER #FUN-660118
			mss062  LIKE mss_file.mss062, #INTEGER #FUN-660118
			mss063  LIKE mss_file.mss063, #INTEGER #FUN-660118
			mss064  LIKE mss_file.mss064, #INTEGER #FUN-660118
			mss065  LIKE mss_file.mss065, #INTEGER #FUN-660118
			bal     LIKE mss_file.mss041, #INTEGER #FUN-660118
			mss07   LIKE mss_file.mss071, #INTEGER #FUN-660118
			mss08   LIKE mss_file.mss08, #INTEGER #FUN-660118
			mss09   LIKE mss_file.mss09  #INTEGER #FUN-660118
                    END RECORD,
##
    g_buf           LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(78) 
    g_rec_b         LIKE type_file.num5,    #單身筆數              #NO.FUN-680082 SMALLINT
    l_ac            LIKE type_file.num5,    #目前處理的ARRAY CNT   #NO.FUN-680082 SMALLINT
    l_sl            LIKE type_file.num5,    #目前處理的SCREEN LINE #NO FUN-680082 SMALLINT 
    l_ima25         like ima_file.ima25
DEFINE   g_cnt           LIKE type_file.num10   #NO.FUN-680082 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #NO.FUN-680082 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10   #NO.FUN-680082 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10   #NO.FUN-680082 INTEGER
DEFINE   g_jump          LIKE type_file.num10   #NO.FUN-680082 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5    #NO.FUN-680082 SMALLINT
DEFINE   g_ver           LIKE mss_file.mss_v     #FUN-850096
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
    LET g_argv1= ARG_VAL(1)
    LET g_argv2= ARG_VAL(2)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076

    INITIALIZE h_mss.* TO NULL

    OPEN WINDOW q500_w WITH FORM "amr/42f/amrq500" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
    CALL cl_set_comp_visible("msr919",g_sma.sma1421='Y')     #FUN-A80150 add  #FUN-A90057

    IF NOT cl_null(g_argv1) THEN CALL q500_q() END IF
    CALL q500()
    CLOSE WINDOW q500_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
 
FUNCTION q500()
    CALL q500_menu()
END FUNCTION
 
FUNCTION q500_cs()
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
    LET g_sql="SELECT UNIQUE mss_v,mss02,mss01 FROM mss_file ",
              " WHERE ",g_wc CLIPPED," ORDER BY mss_v,mss01"
    PREPARE q500_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE q500_cs SCROLL CURSOR WITH HOLD FOR q500_prepare
 
     #MOD-490267
    DROP TABLE count_tmp                                                        
    LET g_sql = "SELECT mss01,mss02,mss_v FROM mss_file WHERE ",g_wc CLIPPED,   
                " GROUP BY mss01,mss02,mss_v ",                                             
                "  INTO TEMP count_tmp"                                                 
    PREPARE q500_precount1 FROM g_sql                                           
    EXECUTE q500_precount1                                                  
    DECLARE q500_count CURSOR FOR select count(*) FROM count_tmp
    #--
 
END FUNCTION
 
FUNCTION q500_menu()
 
   WHILE TRUE
      CALL q500_bp("G")
      CASE g_action_choice
         WHEN "query"
            CALL q500_q() 
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
          #--FUN-B10030--start--
        # WHEN "switch_plant"
        #    CALL q500_d()
        #--FUN-B10030--end--  
 
         WHEN "delete_old"           #FUN-850096
            CALL q500_delete_old()   #FUN-850096
      END CASE
   END WHILE
      CLOSE q500_cs
END FUNCTION
 
FUNCTION q500_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q500_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN LET INT_FLAG = 0 CLEAR FORM RETURN END IF
   CALL g_mss.clear()
   MESSAGE " SEARCHING ! " 
   OPEN q500_count
   FETCH q500_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN q500_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
       CALL cl_err(h_mss.mss01,SQLCA.sqlcode,0)
       INITIALIZE h_mss.* TO NULL
   ELSE
       CALL q500_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION q500_fetch(p_flmss)
    DEFINE
        p_flmss         LIKE type_file.chr1,    #NO FUN-680082 VARCHAR(1)
        l_abso          LIKE type_file.num10    #NO.FUN-680082 INTEGER
 
    CASE p_flmss
        WHEN 'N' FETCH NEXT     q500_cs INTO h_mss.*
        WHEN 'P' FETCH PREVIOUS q500_cs INTO h_mss.*
        WHEN 'F' FETCH FIRST    q500_cs INTO h_mss.*
        WHEN 'L' FETCH LAST     q500_cs INTO h_mss.*
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump q500_cs INTO h_mss.*
            LET g_no_ask = FALSE
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
 
 
    CALL q500_show()                      # 重新顯示
END FUNCTION
 
FUNCTION q500_show()
    DEFINE l_ima	RECORD LIKE ima_file.*
    DEFINE l_pmc	RECORD LIKE pmc_file.*
    DISPLAY BY NAME h_mss.mss_v, h_mss.mss01, h_mss.mss02
    INITIALIZE g_msr.* TO NULL
    SELECT * INTO g_msr.* FROM msr_file WHERE msr_v=h_mss.mss_v
    DISPLAY BY NAME g_msr.msr919         #FUN-A80150 add  #FUN-A90057
    INITIALIZE l_ima.* TO NULL
    SELECT * INTO l_ima.* FROM ima_file WHERE ima01=h_mss.mss01
    DISPLAY BY NAME l_ima.ima02
    DISPLAY BY NAME l_ima.ima45   #add by guanyao160615
    INITIALIZE l_pmc.* TO NULL
    SELECT * INTO l_pmc.* FROM pmc_file WHERE pmc01=h_mss.mss02
    DISPLAY BY NAME l_pmc.pmc03
    CALL q500_b_fill(' 1=1') 
    CALL q500_b_tot('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q500_out(p_cmd)
   DEFINE p_cmd	     LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
          l_cmd	     LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(400)
          l_wc       LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(200)
 
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
#--FUN-B10030--start-- 
#FUNCTION q500_d()
#   DEFINE l_plant,l_dbs	     LIKE type_file.chr21     #NO FUN-680082 VARCHAR(21)
 
#   LET INT_FLAG = 0  ######add for prompt bug
#   PROMPT 'PLANT CODE:' FOR l_plant
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE PROMPT
 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
 
   
#   END PROMPT
#   IF l_plant IS NULL THEN RETURN END IF
#   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant
#   IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
#   DATABASE l_dbs
#   CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
#   CALL cl_ins_del_sid(1,l_plant) #FUN-980030  #FUN-990069
#   IF STATUS THEN ERROR 'open database error!' RETURN END IF
#   LET g_plant = l_plant
#   LET g_dbs   = l_dbs
#END FUNCTION
#--FUN-B10030--end-- 
FUNCTION q500_b_tot(p_cmd)
   DEFINE p_cmd		LIKE type_file.chr1       #NO.FUN-680082 VARCHAR(1)
END FUNCTION
 
FUNCTION q500_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2            LIKE type_file.chr1000    #NO.FUN-680082 VARCHAR(100)
#DEFINE last_qty        INTEGER #FUN-660118
DEFINE last_qty         LIKE mss_file.mss08 #FUN-660118
    LET g_sql =
        #"SELECT mss00, convert(char(10),msk_d,111), mss041, mss043, mss044, mss051, mss052, mss053,",    #No.TQC-9B0012 mod
        "SELECT mss00,cast(msk_d AS char(10)),mss041, mss043, mss044, mss051, mss052, mss053,",    #No.TQC-9B0012 mod
        "       mss061, mss062, mss063, mss064, mss065, 0,",
        "       mss072-mss071, mss08, mss09",
        " FROM msk_file LEFT OUTER JOIN mss_file ON msk_file.msk_v=mss_file.mss_v AND msk_file.msk_d=mss_file.mss03",
        " WHERE msk_v ='",h_mss.mss_v,"'",
        "   AND mss_file.mss01 ='",h_mss.mss01,"' AND mss_file.mss02 ='",h_mss.mss02,"'",
        " ORDER BY 2,1"
    PREPARE q500_pb FROM g_sql
    DECLARE mss_curs CURSOR FOR q500_pb
 
 #MOD-540164
    CALL g_mss.clear()
 
    INITIALIZE g_mss_t.* TO NULL
    LET g_mss_t.mss041=0
    LET g_mss_t.mss043=0
    LET g_mss_t.mss044=0
    LET g_mss_t.mss051=0
    LET g_mss_t.mss052=0
    LET g_mss_t.mss053=0
    LET g_mss_t.mss061=0
    LET g_mss_t.mss062=0
    LET g_mss_t.mss063=0
    LET g_mss_t.mss064=0
    LET g_mss_t.mss065=0
    LET g_mss_t.mss09 =0
##
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH mss_curs INTO g_mss[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
        #IF g_mss[g_cnt].mss03<g_msr.bdate THEN
        #   LET g_mss[g_cnt].mss03='PAST DUE'
        #END IF
        IF g_mss[g_cnt].mss041 IS NULL THEN
           IF g_cnt = 1
              THEN LET g_mss[g_cnt].mss08=0
              ELSE LET g_mss[g_cnt].mss08=g_mss[g_cnt-1].mss08+
                                          g_mss[g_cnt-1].mss09
           END IF
           LET g_mss[g_cnt].mss09 = 0
        END IF
        IF g_cnt = 1 THEN 
           LET last_qty=0
        ELSE 
           LET last_qty=g_mss[g_cnt-1].mss08+g_mss[g_cnt-1].mss09
        END IF
 
        IF g_mss[g_cnt].mss041 IS NULL THEN
           LET g_mss[g_cnt].bal=last_qty
        ELSE
           LET g_mss[g_cnt].bal=
               last_qty
              +g_mss[g_cnt].mss051+g_mss[g_cnt].mss052+g_mss[g_cnt].mss053
              +g_mss[g_cnt].mss061+g_mss[g_cnt].mss062+g_mss[g_cnt].mss063
              +g_mss[g_cnt].mss064+g_mss[g_cnt].mss065
              -g_mss[g_cnt].mss041-g_mss[g_cnt].mss043-g_mss[g_cnt].mss044
 
 #MOD-540164
           LET g_mss_t.mss041=g_mss_t.mss041+g_mss[g_cnt].mss041
           LET g_mss_t.mss043=g_mss_t.mss043+g_mss[g_cnt].mss043
           LET g_mss_t.mss044=g_mss_t.mss044+g_mss[g_cnt].mss044
           LET g_mss_t.mss051=g_mss_t.mss051+g_mss[g_cnt].mss051
           LET g_mss_t.mss052=g_mss_t.mss052+g_mss[g_cnt].mss052
           LET g_mss_t.mss053=g_mss_t.mss053+g_mss[g_cnt].mss053
           LET g_mss_t.mss061=g_mss_t.mss061+g_mss[g_cnt].mss061
           LET g_mss_t.mss062=g_mss_t.mss062+g_mss[g_cnt].mss062
           LET g_mss_t.mss063=g_mss_t.mss063+g_mss[g_cnt].mss063
           LET g_mss_t.mss064=g_mss_t.mss064+g_mss[g_cnt].mss064
           LET g_mss_t.mss065=g_mss_t.mss065+g_mss[g_cnt].mss065
           LET g_mss_t.mss09 =g_mss_t.mss09 +g_mss[g_cnt].mss09
##
 
        END IF
    #No.FUN-920183 start -----
        IF (g_mss[g_cnt].mss041 = 0 OR cl_null(g_mss[g_cnt].mss041)) AND
           (g_mss[g_cnt].mss043 = 0 OR cl_null(g_mss[g_cnt].mss043)) AND
           (g_mss[g_cnt].mss044 = 0 OR cl_null(g_mss[g_cnt].mss044)) AND
           (g_mss[g_cnt].mss051 = 0 OR cl_null(g_mss[g_cnt].mss051)) AND
           (g_mss[g_cnt].mss052 = 0 OR cl_null(g_mss[g_cnt].mss052)) AND
           (g_mss[g_cnt].mss053 = 0 OR cl_null(g_mss[g_cnt].mss053)) AND
           (g_mss[g_cnt].mss061 = 0 OR cl_null(g_mss[g_cnt].mss061)) AND
           (g_mss[g_cnt].mss062 = 0 OR cl_null(g_mss[g_cnt].mss062)) AND
           (g_mss[g_cnt].mss063 = 0 OR cl_null(g_mss[g_cnt].mss063)) AND
           (g_mss[g_cnt].mss064 = 0 OR cl_null(g_mss[g_cnt].mss064)) AND
           (g_mss[g_cnt].mss065 = 0 OR cl_null(g_mss[g_cnt].mss065)) AND
           (g_mss[g_cnt].mss07  = 0 OR cl_null(g_mss[g_cnt].mss07 )) AND
           (g_mss[g_cnt].mss08  = 0 OR cl_null(g_mss[g_cnt].mss08 )) AND
           (g_mss[g_cnt].mss09  = 0 OR cl_null(g_mss[g_cnt].mss09))  THEN
           CONTINUE FOREACH
        END IF
    #No.FUN-920183 end -------
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
 
 #MOD-540164
    LET g_mss[g_cnt].*=g_mss_t.*
    LET g_mss[g_cnt].mss03=cl_getmsg('amr-003',g_lang)  #合計 message
    LET g_mss[g_cnt].bal  =NULL
    LET g_mss[g_cnt].mss07=NULL
    LET g_mss[g_cnt].mss08=NULL
    LET g_rec_b=g_cnt - 1
##
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION q500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       #NO.FUN-680082 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mss TO s_mss.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q500_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q500_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL q500_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q500_fetch('N') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL q500_fetch('L')
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
 #MOD-4C0087--begin
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 #MOD-4C0087--end
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
   
      ON ACTION contents #明細單身
         LET g_action_choice="contents"
         EXIT DISPLAY
      #--FUN-B10030--start-- 
      # ON ACTION switch_plant #工廠切換
      #   LET g_action_choice="switch_plant"
      #   EXIT DISPLAY
      #--FUN-B10030--end--
      ON ACTION delete_old   #  #FUN-850096
         LET g_action_choice="delete_old"  #FUN-850096
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#FUN-850096---Begin
FUNCTION q500_delete_old()    #
   DEFINE msl     RECORD LIKE msl_file.*
   DEFINE l_ver   LIKE mss_file.mss_v
   DEFINE l_disk  LIKE type_file.chr1
   DEFINE l_time  LIKE type_file.chr8 
   DEFINE l_msg   LIKE ze_file.ze01 
   DEFINE err_code LIKE ze_file.ze03
   OPEN WINDOW q500_d_w AT 0,0
     WITH FORM "amr/42f/amrq500_d" ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("amrq500_d")
 
   CLEAR FORM
   ERROR ''
   LET l_disk = "N"   #No.MOD-540062
 
   INPUT l_ver,l_disk WITHOUT DEFAULTS FROM FORMONLY.ver,FORMONLY.a
 
      AFTER FIELD ver
         IF NOT  cl_null(l_ver) THEN 
            SELECT COUNT(*) INTO g_cnt FROM mss_file
             WHERE mss_v=l_ver
            IF g_cnt=0 THEN
               CALL cl_err(l_ver,'amr-305',0) 
               NEXT FIELD ver
            END IF
         END IF
         
      ON ACTION locale                    #genero
         LET g_action_choice = "locale"
         CALL cl_show_fld_cont()          #No.FUN-550037 hmf
         EXIT INPUT
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()     # Command execution
 
      ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW q500_d_w
      RETURN
   END IF
 
   IF cl_sure(0,0) THEN
      LET g_success='Y'
      BEGIN WORK                               #NO.FUN-710023 
    
      IF l_disk='Y' AND g_success='Y' THEN
         LET g_ver=l_ver
         CALL q500_download()
         IF g_success='Y' THEN
            CALL cl_err('','amd-020',1)
         END IF
      END IF
      
      DELETE FROM mss_file WHERE mss_v=l_ver
      IF STATUS THEN
         CALL cl_err('del mss',STATUS,1)
         LET g_success='N'
      END IF
      DELETE FROM mst_file WHERE mst_v=l_ver
      IF STATUS THEN
         CALL cl_err('del mst',STATUS,1)
         LET g_success='N'
      END IF
 
      IF g_success = 'Y' THEN
         COMMIT WORK
         LET msl.msl_v=g_ver
         LET msl.msl01=TODAY
         LET l_time = TIME
         LET msl.msl02=l_time
         LET l_msg = 'amr-006'
         SELECT ze03 INTO err_code FROM ze_file 
          WHERE ze01 = l_msg AND ze02 = g_lang
         LET msl.msl03= g_ver CLIPPED,' ',err_code
         LET msl.mslplant=g_plant #FUN-980004 add
         LET msl.msllegal=g_legal #FUN-980004 add
         INSERT INTO msl_file VALUES(msl.*)
         IF STATUS THEN CALL cl_err('ins msl',STATUS,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM END IF
      ELSE
         ROLLBACK WORK
      END IF
      CALL cl_end(0,0)
      CLOSE WINDOW q500_d_w
   END IF
END FUNCTION
 
FUNCTION q500_download()
 
  DEFINE  #l_sql       LIKE type_file.chr1000
          l_sql       STRING    #No.FUN-910082
  DEFINE  l_name      LIKE type_file.chr1000
  DEFINE  m_tempdir   LIKE type_file.chr1000
  DEFINE  m_file      LIKE type_file.chr1000
  DEFINE  l_n         LIKE type_file.num5
  DEFINE  l_ret       LIKE type_file.num5    
 
 
  LET m_tempdir=FGL_GETENV("TEMPDIR")
  LET l_n=LENGTH(m_tempdir)
  IF l_n>0 THEN
     IF m_tempdir[l_n,l_n]='/' THEN
        LET m_tempdir[l_n,l_n]=' '
     END IF
  END IF
 
  MESSAGE ' UNLOAD mss_file...... ' 
  CALL ui.Interface.refresh() #CKP 
  LET l_name=g_prog CLIPPED,'_mss_file_',g_today USING 'YYYYMMDD'
  #LET m_file=m_tempdir CLIPPED,'\\',l_name CLIPPED              #MOD-C30272  mark
  LET m_file=os.Path.join(FGL_GETENV("TEMPDIR"),l_name CLIPPED)  #MOD-C30272  add
  LET l_sql = " SELECT * FROM mss_file WHERE mss_v='",g_ver CLIPPED,"' "
  UNLOAD TO l_name l_sql
  
  CALL q500_chk_lang() RETURNING l_ret
  IF l_ret= 2  THEN    #UNICODE
     LET l_sql="mv ",m_file CLIPPED," ",m_file CLIPPED,".utf8"
     RUN l_sql 
     LET l_sql="cd ",m_tempdir
     RUN l_sql 
     IF os.Path.separator() = "/" THEN        #Unix 環境    #FUN-A30038
        LET l_sql="iconv -f utf8 -t big5 -o ",m_file CLIPPED," ",m_file CLIPPED,".utf8 "
     #FUN-A30038--add--str--FOR WINDOWS
     ELSE
        LET l_sql = "java -cp zhcode.jar zhcode -8b ",m_file CLIPPED," ",m_file CLIPPED,".utf8 "
     END IF
     #FUN-A30038--add--end
     RUN l_sql 
  END IF 

  IF NOT cl_download_file(m_file CLIPPED||'.utf8',"c:/tiptop/"||l_name CLIPPED||'.txt') THEN  
     CALL cl_err('download mss_file error','!',0)      
     LET g_success = 'N'                    
     RETURN
  END IF
 
  MESSAGE ' UNLOAD mst_file...... ' 
  CALL ui.Interface.refresh() #CKP 
  LET l_name=g_prog CLIPPED,'_mst_file.',g_today USING 'YYYYMMDD'
  LET l_sql = " SELECT * FROM mst_file WHERE mst_v='",g_ver CLIPPED,"' "
  UNLOAD TO l_name l_sql
 
  #LET m_file=m_tempdir CLIPPED,'\\',l_name CLIPPED              #MOD-C30272  mark 
  LET m_file=os.Path.join(FGL_GETENV("TEMPDIR"),l_name CLIPPED)  #MOD-C30272  add
  CALL q500_chk_lang() RETURNING l_ret
  IF l_ret= 2  THEN    #UNICODE
     LET l_sql="mv ",m_file CLIPPED," ",m_file CLIPPED,".utf8"
     RUN l_sql 
     LET l_sql="cd ",m_tempdir
     RUN l_sql 
     IF os.Path.separator() = "/" THEN        #Unix 環境    #FUN-A30038
        LET l_sql="iconv -f utf8 -t big5 -o ",m_file CLIPPED," ",m_file CLIPPED,".utf8 "
     #FUN-A30038--add--str--FOR WINDOWS
     ELSE
        LET l_sql = "java -cp zhcode.jar zhcode -8b ",m_file CLIPPED," ",m_file CLIPPED,".utf8 "
     END IF
     #FUN-A30038--add--end
     RUN l_sql 
  END IF 
 
  IF NOT cl_download_file(m_file CLIPPED||'.utf8',"c:/tiptop/"||l_name CLIPPED||'.txt') THEN
     CALL cl_err('download mst_file error','!',0)      
     LET g_success = 'N'                    
     RETURN
  END IF
END FUNCTION
 
FUNCTION q500_chk_lang()
 
   DEFINE l_dbtype   LIKE type_file.chr3          #No.FUN-690005  VARCHAR(3)
   DEFINE l_langtype STRING
   DEFINE l_ret      LIKE type_file.num5          #No.FUN-690005  SMALLINT
 
  #-------------No.MOD-8B0082 modify
  #LET l_dbtype=cl_db_get_database_type()
 
  #CASE l_dbtype
  #   WHEN "ORA" 
  #      LET l_langtype=DOWNSHIFT(FGL_GETENV("LANG"))
  #      CASE
  #         WHEN l_langtype.getIndexOf("big5",1) 
  #            LET l_ret=1
  #         WHEN l_langtype.getIndexOf("utf8",1) 
  #            LET l_ret=2
  #         OTHERWISE
  #            LET l_ret=0
  #      END CASE
  #   WHEN "IFX" 
  #      LET l_ret=1
  #   OTHERWISE
  #      LET l_ret=0
  #END CASE
   LET l_langtype=DOWNSHIFT(FGL_GETENV("LANG"))
   IF l_langtype.getIndexOf("utf8",1) THEN
      LET l_ret = 2
   ELSE
      LET l_ret = 1
   END IF
  #-------------No.MOD-8B0082 end
   RETURN l_ret
 
END FUNCTION
#TQC-B30055
#FUN-850096---End
