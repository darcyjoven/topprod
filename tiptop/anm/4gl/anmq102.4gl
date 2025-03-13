# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmq102.4gl
# Descriptions...: 應付票據異動記錄查詢
# Date & Author..: 92/06/09 BY MAY
# Modify.........: 93/12/28 By Wenni : 單身賦予條件功能
# Modify.........: 95/06/13 By Danny (CALL s_gl entry_sheet維護)
#                : 96/06/26 By Lynn  :接收參數
#                : 96/07/11 By Lynn  :將call s_gl entry_sheet維護 改call s_fsgl
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-550037 05/05/13 By saki  欄位comment顯示
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740058 07/04/13 By Judy 匯出EXCEL多一行空白列
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-960142 09/06/12 By sabrina 做查詢時單身下條件所查出的資料不正確，在組sql時少判斷了單身的條件
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
        g_nmd RECORD
             nmd01  LIKE nmd_file.nmd01,
             nmd02  LIKE nmd_file.nmd02,
             nmd03  LIKE nmd_file.nmd03,
             nmd21  LIKE nmd_file.nmd21,
             nmd04  LIKE nmd_file.nmd04,
             nmd07  LIKE nmd_file.nmd07,
             nmd05  LIKE nmd_file.nmd05,
             nmd08  LIKE nmd_file.nmd08,
             nmd10  LIKE nmd_file.nmd10,
             nmd101 LIKE nmd_file.nmd101,
             nmd06  LIKE nmd_file.nmd06,
             nmd12  LIKE nmd_file.nmd12,
             nmd19  LIKE nmd_file.nmd19,
             nmd24  LIKE nmd_file.nmd24,
             nmd29  LIKE nmd_file.nmd29
             END RECORD,
       g_nmf DYNAMIC ARRAY OF RECORD
            nmf02   LIKE nmf_file.nmf02,
            nmf05   LIKE nmf_file.nmf05,
            nmf06   LIKE nmf_file.nmf06,
            nmf08   LIKE nmf_file.nmf08,
            nmf09   LIKE nmf_file.nmf09,
            nmf11   LIKE nmf_file.nmf11,
            nmf13   LIKE nmf_file.nmf13,
            nmf12   LIKE nmf_file.nmf12
       END RECORD,
       g_wc         STRING,                            #No.FUN-580092 HCN      
       g_wc2        STRING,                            #No.FUN-580092 HCN      
       g_sql        STRING,                            #No.FUN-580092 HCN      
       l_ac         LIKE type_file.num5,               #No.FUN-680107 SMALLINT
#      g_argv1      VARCHAR(10),
       g_argv1      LIKE nmd_file.nmd01,               #No.FUN-550057
       g_rec_b      LIKE type_file.num5   	       #單身筆數 #No.FUN-680107 SMALLINT
 
DEFINE g_cnt        LIKE type_file.num10               #No.FUN-680107 INTEGER
DEFINE g_msg        LIKE type_file.chr1000             #No.FUN-680107 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10               #No.FUN-680107 INTEGER
DEFINE g_curs_index LIKE type_file.num10               #No.FUN-680107 INTEGER
DEFINE g_jump       LIKE type_file.num10               #No.FUN-680107 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5                #No.FUN-680107 SMALLINT
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01                #No.FUN-580031  HCN
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0082
DEFINE p_row,p_col  LIKE type_file.num5                #No.FUN-680107 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW q102_w AT p_row,p_col
         WITH FORM "anm/42f/anmq102"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
 #96-06-26 Modify By Lynn
    LET g_argv1 = ARG_VAL(1)
#    IF cl_chk_act_auth() THEN
#       CALL q102_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q102_q() END IF
    CALL q102_menu()
    CLOSE WINDOW q102_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION q102_cs()
    CLEAR FORM
   CALL g_nmf.clear()
 #96-06-26 Modify By Lynn
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    IF NOT cl_null(g_argv1)  THEN
       LET g_sql="SELECT nmd01 FROM nmd_file ", # 組合出 SQL 指令
          " WHERE nmd01 ='",g_argv1, "' ORDER BY nmd01"
    ELSE
   INITIALIZE g_nmd.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON nmd01,nmd03,nmd02,nmd29,nmd21,nmd04,
              nmd07,nmd05,nmd06,nmd19,nmd08,nmd24,nmd10,nmd101,nmd12
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
                   CALL cl_qbe_list() RETURNING lc_qbe_sn
                   CALL cl_qbe_display_condition(lc_qbe_sn)
                #No.FUN-580031 --end--       HCN
 
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
       CALL q102_b_askkey()
       #資料權限的檢查
       #Begin:FUN-980030
       #       IF g_priv2='4' THEN                           #只能使用自己的資料
       #          LET g_wc = g_wc clipped," AND nmduser = '",g_user,"'"
       #       END IF
       #       IF g_priv3='4' THEN                           #只能使用相同群的資料
       #          LET g_wc = g_wc clipped," AND nmdgrup MATCHES '",g_grup CLIPPED,"*'"
       #       END IF
 
       #       IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       #          LET g_wc = g_wc clipped," AND nmdgrup IN ",cl_chk_tgrup_list()
       #       END IF
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup')
       #End:FUN-980030
     
       IF g_wc2 = " 1=1" THEN            #TQC-960142 add
          LET g_sql="SELECT nmd01 FROM nmd_file ", # 組合出 SQL 指令
                    " WHERE ",g_wc CLIPPED, " ORDER BY nmd01"
     #TQC-960142---add
       ELSE
          LET g_sql="SELECT UNIQUE nmd_file. nmd01 ",
                    "  FROM nmd_file, nmf_file ",
                    " WHERE nmd01 = nmf01 ",
                    "   AND ", g_wc CLIPPED,
                    "   AND ", g_wc2 CLIPPED,
                    " ORDER BY nmd01"
       END IF
     #TQC-960142---add
    END IF
 
    PREPARE q102_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE q102_cs                         # SCROLL CURSOR
        SCROLL CURSOR FOR q102_prepare
 #96-06-26 Modify By Lynn
    IF NOT cl_null(g_argv1) THEN
        LET g_sql = "SELECT COUNT(*) FROM nmd_file WHERE nmd01 ='",g_argv1,"'"
    ELSE
      #TQC-960142---modify---    #計算筆數時也要加入單身條件式
      #LET g_sql= "SELECT COUNT(*) FROM nmd_file WHERE ",g_wc CLIPPED
       IF g_wc2 = " 1=1" THEN   
          LET g_sql= "SELECT COUNT(*) FROM nmd_file WHERE ",g_wc CLIPPED  
       ELSE
          LET g_sql= "SELECT COUNT(UNIQUE nmd01) FROM nmd_file, nmf_file ",  
                     " WHERE nmd01 = nmf01 ",
                     "   AND ", g_wc CLIPPED,
                     "   AND ", g_wc2 CLIPPED
       END IF
      #TQC-960142---modify---
    END IF
    PREPARE q102_precount FROM g_sql
    DECLARE q102_count CURSOR FOR q102_precount
 
END FUNCTION
 
FUNCTION q102_b_askkey()
#--->Modify by Wenni on 93/12/28 : 單身賦予條件功能
 
    CONSTRUCT g_wc2 ON nmf02,nmf05,nmf06,nmf08,nmf09,nmf11,nmf13
         FROM s_nmd[1].nmf02,s_nmd[1].nmf05,s_nmd[1].nmf06,
              s_nmd[1].nmf08,s_nmd[1].nmf09,s_nmd[1].nmf11,
              s_nmd[1].nmf13
 
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
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
                ON ACTION qbe_save
                   CALL cl_qbe_save()
                #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
END FUNCTION
 
FUNCTION q102_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(100)
 
 
   WHILE TRUE
      CALL q102_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q102_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#        WHEN "分錄產生"
#           LET l_cmd = "anmp640 '",g_nmd.nmd01,"'"
#           CALL cl_cmdrun(l_cmd CLIPPED)
#        WHEN "entry_sheet"
#           IF cl_chk_act_auth() THEN
#              #系統別、類別、單號、票面金額
#              CALL s_fsgl('NM',1,g_nmd.nmd01,g_nmd.nmd04,g_nmz.nmz02b)
#           END IF
        WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nmf),'','')
            END IF
 
      END CASE
   END WHILE
#   CLOSE q102_cs
END FUNCTION
 
FUNCTION q102_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q102_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
   CALL g_nmf.clear()
        RETURN
    END IF
    OPEN q102_count
    FETCH q102_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q102_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmd.nmd01,SQLCA.sqlcode,0)
        INITIALIZE g_nmd.* TO NULL
    ELSE
        CALL q102_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q102_fetch(p_flnmd)
    DEFINE
        p_flnmd         LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680107 INTEGER
 
    CASE p_flnmd
        WHEN 'N' FETCH NEXT     q102_cs INTO g_nmd.nmd01
        WHEN 'P' FETCH PREVIOUS q102_cs INTO g_nmd.nmd01
        WHEN 'F' FETCH FIRST    q102_cs INTO g_nmd.nmd01
        WHEN 'L' FETCH LAST     q102_cs INTO g_nmd.nmd01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
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
            FETCH ABSOLUTE g_jump q102_cs INTO g_nmd.nmd01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmd.nmd01,SQLCA.sqlcode,0)
        INITIALIZE g_nmd.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flnmd
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT nmd01,nmd02,nmd03,nmd21,nmd04,nmd07,nmd05,nmd08,
           nmd10,nmd101,nmd06,nmd12,nmd19,nmd24,nmd29
           INTO g_nmd.* FROM nmd_file
           # 重讀DB,因TEMP有不被更新特性
       WHERE nmd01 = g_nmd.nmd01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_nmd.nmd01,SQLCA.sqlcode,0)   #No.FUN-660148
        CALL cl_err3("sel","nmd_file",g_nmd.nmd01,"",SQLCA.sqlcode,"","",0) #No.FUN-660148
    ELSE
 
        CALL q102_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION q102_show()
DEFINE   l_sta   LIKE ze_file.ze03  #No.FUN-680107 VARCHAR(4)
    DISPLAY BY NAME g_nmd.nmd01,g_nmd.nmd02,g_nmd.nmd03,g_nmd.nmd21,g_nmd.nmd04,
                    g_nmd.nmd05,g_nmd.nmd07,g_nmd.nmd08,
                    g_nmd.nmd10,g_nmd.nmd101,
                    g_nmd.nmd06,g_nmd.nmd12,g_nmd.nmd19,g_nmd.nmd24,g_nmd.nmd29
   CALL q102_nmd03('d')
   CALL s_nmdsta(g_nmd.nmd12) RETURNING l_sta
   DISPLAY l_sta TO FORMONLY.nmd12_1
   CALL q102_b_fill() #單身
    CALL cl_show_fld_cont()                     #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q102_nmd03(p_cmd)  #銀行代號
    DEFINE p_cmd     LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)
           l_nma02   LIKE nma_file.nma02,
           l_nmaacti LIKE nma_file.nmaacti
 
    LET g_errno = ' '
    SELECT nma02,nmaacti
           INTO l_nma02,l_nmaacti
           FROM nma_file WHERE nma01 = g_nmd.nmd03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-013'
                            LET l_nma02 = NULL
         WHEN l_nmaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_nma02 TO FORMONLY.nma02
    END IF
END FUNCTION
 
FUNCTION q102_b_fill()              #BODY FILL UP
 
#96-06-26 Modify By Lynn
 IF NOT cl_null(g_argv1) THEN
#    IF cl_chk_act_auth() THEN
    LET g_sql =
        "SELECT nmf02,nmf05,nmf06,nmf08,nmf09,nmf11,nmf13,nmf12",
        " FROM  nmf_file",
        " WHERE nmf01 = '",g_nmd.nmd01,"'" ,
        " ORDER BY 2,1"
 ELSE
    LET g_sql =
        "SELECT nmf02,nmf05,nmf06,nmf08,nmf09,nmf11,nmf13,nmf12",
        " FROM  nmf_file",
        " WHERE nmf01 = '",g_nmd.nmd01,"'" ,
        " AND ",g_wc2 CLIPPED,
        " ORDER BY 2,1"
 END IF
    PREPARE q102_pb FROM g_sql
    DECLARE nmf_curs                      #SCROLL CURSOR
        CURSOR FOR q102_pb
 
    CALL g_nmf.clear()
 
    LET g_cnt = 1
    FOREACH nmf_curs INTO g_nmf[g_cnt].*           #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_nmf.deleteElement(g_cnt)  #TQC-740058
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION q102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nmf TO s_nmd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
        LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
        CALL cl_show_fld_cont()                   #No.FUN-550037
 
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
         CALL q102_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q102_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q102_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q102_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q102_fetch('L')
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
#     ON ACTION 分錄產生
#        LET g_action_choice="分錄產生"
#     ON ACTION entry_sheet
#        LET g_action_choice="entry_sheet"
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
       #No.MOD-530853  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
       #No.MOD-530853  --end
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
