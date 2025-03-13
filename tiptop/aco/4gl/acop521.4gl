# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: acop521.4gl
# Descriptions...: 成品報關單沖帳作業
# Date & Author..: 05/03/28 By ELVA
# Modify.........: No.TQC-660045 06/06/12 By CZH cl_err-->cl_err3
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/16 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790090 07/09/14 By Melody 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.TQC-860021 08/06/11 By Sarah CONSTRUCT漏了ON IDLE控制
# Modify.........: No.TQC-930048 09/03/12 By mike 解決溢位問題
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-BB0086 12/01/06 By tanxc 增加數量欄位小數取位
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_cra           RECORD LIKE cra_file.*,
    g_cra_t         RECORD LIKE cra_file.*,
    g_crb           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
           crb05    LIKE crb_file.crb05,
           crb06    LIKE crb_file.crb06,
           crb07    LIKE crb_file.crb07,
           crb08    LIKE crb_file.crb08,
           crb09    LIKE crb_file.crb09,
           crb10    LIKE crb_file.crb10,
           crb11    LIKE crb_file.crb11,
           crb12    LIKE crb_file.crb12,
           crb13    LIKE crb_file.crb13
                    END RECORD,
    g_crb_t         RECORD    #程式變數(Program Variables)
           crb05    LIKE crb_file.crb05,
           crb06    LIKE crb_file.crb06,
           crb07    LIKE crb_file.crb07,
           crb08    LIKE crb_file.crb08,
           crb09    LIKE crb_file.crb09,
           crb10    LIKE crb_file.crb10,
           crb11    LIKE crb_file.crb11,
           crb12    LIKE crb_file.crb12,
           crb13    LIKE crb_file.crb13
                    END RECORD,
    g_crc           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
           crc05    LIKE crc_file.crc05,
           coc05    LIKE coc_file.coc05,
           crc06    LIKE crc_file.crc06,
           crc07    LIKE crc_file.crc07,
           crc08    LIKE crc_file.crc08,
           crc09    LIKE crc_file.crc09,
           crc11    LIKE crc_file.crc11,
           crc12    LIKE crc_file.crc12,
           cnm08    LIKE cnm_file.cnm08
                    END RECORD,
    g_crc_t         RECORD    #程式變數(Program Variables)
           crc05    LIKE crc_file.crc05,
           coc05    LIKE coc_file.coc05,
           crc06    LIKE crc_file.crc06,
           crc07    LIKE crc_file.crc07,
           crc08    LIKE crc_file.crc08,
           crc09    LIKE crc_file.crc09,
           crc11    LIKE crc_file.crc11,
           crc12    LIKE crc_file.crc12,
           cnm08    LIKE cnm_file.cnm08
                    END RECORD,
    g_wc,g_wc2,g_wc3,g_sql    STRING,         #No.FUN-580092 HCN        #No.FUN-680069
    l_za05          LIKE za_file.za05,
    g_rec_b         LIKE type_file.num5,      #單身筆數        #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5,      #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
    g_forupd_sql    STRING,                   #SELECT ... FOR UPDATE SQL        #No.FUN-680069
    g_gen           LIKE type_file.chr1,      #No.FUN-680069 VARCHAR(1)
    g_rec_b2        LIKE type_file.num5,      #單身筆數        #No.FUN-680069 SMALLINT
    l_ac2           LIKE type_file.num5       #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
DEFINE   l_wc       LIKE type_file.chr1000    #No.FUN-680069 VARCHAR(300)
DEFINE   l_wc3      LIKE type_file.chr1000    #No.FUN-680069 VARCHAR(300)
DEFINE   l_i        LIKE type_file.num5       #No.FUN-680069 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10  #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CONTINUE                #忽略一切錯誤
 
    IF (NOT cl_setup("ACO")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
    LET g_gen='N'
    LET g_forupd_sql = "SELECT * FROM cra_file WHERE cra00 = ? AND cra01 = ? AND cra02 = ? AND cra03 = ? AND cra04 = ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p521_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW p521_w WITH FORM "aco/42f/acop521"
       ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
    CALL p521_menu()
    #刪除資料
    DELETE FROM cra_file WHERE 1=1
    DELETE FROM crb_file WHERE 1=1
    DELETE FROM crc_file WHERE 1=1
    CLOSE WINDOW p521_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION p521_cs()
 DEFINE l_num     LIKE type_file.num5         #No.FUN-680069 SMALLINT
    CLEAR FORM                             #清除畫面
    #商品編號，海關代號，異動方式，HS Code,客戶編號
    CALL cl_set_head_visible("","YES")  #No.FUN-6B0033
   INITIALIZE g_cra.* TO NULL    #No.FUN-750051
    CONSTRUCT g_wc  ON cob01,cod04,coo10,cob09,coo05
                FROM cra01,cra02,cra04,cra05,cra03
       ON ACTION controlg       #TQC-860021
          CALL cl_cmdask()      #TQC-860021
 
       ON IDLE g_idle_seconds   #TQC-860021
          CALL cl_on_idle()     #TQC-860021
          CONTINUE CONSTRUCT    #TQC-860021
 
       ON ACTION about          #TQC-860021
          CALL cl_about()       #TQC-860021
 
       ON ACTION help           #TQC-860021
          CALL cl_show_help()   #TQC-860021
    END CONSTRUCT               #TQC-860021
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cobuser', 'cobgrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF
    CONSTRUCT g_wc2 ON coo01,coo02,coo03,coo04
                  FROM s_crb[1].crb05,s_crb[1].crb06,s_crb[1].crb07,
                       s_crb[1].crb08
       ON ACTION controlg       #TQC-860021
          CALL cl_cmdask()      #TQC-860021
 
       ON IDLE g_idle_seconds   #TQC-860021
          CALL cl_on_idle()     #TQC-860021
          CONTINUE CONSTRUCT    #TQC-860021
 
       ON ACTION about          #TQC-860021
          CALL cl_about()       #TQC-860021
 
       ON ACTION help           #TQC-860021
          CALL cl_show_help()   #TQC-860021
    END CONSTRUCT               #TQC-860021
    IF INT_FLAG THEN RETURN END IF
    CONSTRUCT g_wc3 ON cno10,cno06,cno07
                    FROM s_crc[1].crc05,s_crc[1].crc06,s_crc[1].crc07
       ON ACTION controlg       #TQC-860021
          CALL cl_cmdask()      #TQC-860021
 
       ON IDLE g_idle_seconds   #TQC-860021
          CALL cl_on_idle()     #TQC-860021
          CONTINUE CONSTRUCT    #TQC-860021
 
       ON ACTION about          #TQC-860021
          CALL cl_about()       #TQC-860021
 
       ON ACTION help           #TQC-860021
          CALL cl_show_help()   #TQC-860021
    END CONSTRUCT               #TQC-860021
    IF INT_FLAG THEN RETURN END IF
    IF g_gen='Y' THEN
       CALL p521_g()  #產生資料
    END IF
    LET g_gen='N'
 
    LET g_sql = "SELECT cra00,cra01,cra02,cra03,cra04 ",
                "  FROM cra_file ",
                " WHERE cra00= '1' ",  #FOR 成品
                " ORDER BY cra01,cra02,cra03,cra04"
    PREPARE p521_prepare FROM g_sql
    DECLARE p521_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR p521_prepare
    LET g_sql = "SELECT count(*) FROM cra_file ",
                " WHERE cra00= '1' "   #FOR 成品
    PREPARE p521_precount FROM g_sql
    DECLARE p521_count CURSOR FOR p521_precount
END FUNCTION
 
FUNCTION p521_menu()
   WHILE TRUE
      CALL p521_bp("G")
      CASE g_action_choice
        WHEN "gen_detail"
            IF cl_chk_act_auth() THEN
                LET g_gen='Y'
                CALL p521_q()
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
                CALL p521_y()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p521_q()
            DEFINE   l_cra00  LIKE cra_file.cra00,
          l_cra01  LIKE cra_file.cra01,
          l_cra02  LIKE cra_file.cra02,
          l_cra03  LIKE cra_file.cra03,
          l_cra04  LIKE cra_file.cra04
   DEFINE l_cnt    LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
    LET l_cnt=0
    SELECT COUNT(*) INTO l_cnt
      FROM cra_file
     WHERE 1=1
    IF l_cnt > 0 AND l_cnt IS NOT NULL THEN
       DELETE FROM cra_file WHERE 1=1
       DELETE FROM crb_file WHERE 1=1
       DELETE FROM crc_file WHERE 1=1
    END IF
    LET g_success='Y'
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL p521_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    IF g_success='N' THEN   #表示無符合條件資料
       RETURN
    END IF
    MESSAGE " SEARCHING ! " ATTRIBUTE(REVERSE)
    OPEN p521_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_cra.* TO NULL
    ELSE
       OPEN p521_count
       FETCH p521_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL p521_fetch('F')
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION p521_fetch(p_flag)
DEFINE
    p_flag   LIKE type_file.chr1     #處理方式  #No.FUN-680069 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     p521_cs INTO g_cra.cra00
                                             ,g_cra.cra01,g_cra.cra02
                                             ,g_cra.cra03,g_cra.cra04
        WHEN 'P' FETCH PREVIOUS p521_cs INTO g_cra.cra00
                                             ,g_cra.cra01,g_cra.cra02
                                             ,g_cra.cra03,g_cra.cra04
        WHEN 'F' FETCH FIRST    p521_cs INTO g_cra.cra00
                                             ,g_cra.cra01,g_cra.cra02
                                             ,g_cra.cra03,g_cra.cra04
        WHEN 'L' FETCH LAST     p521_cs INTO g_cra.cra00
                                             ,g_cra.cra01,g_cra.cra02
                                             ,g_cra.cra03,g_cra.cra04
 
        WHEN '/'
          IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
          END IF
          FETCH ABSOLUTE g_jump p521_cs INTO g_cra.cra00
                                             ,g_cra.cra01,g_cra.cra02
                                             ,g_cra.cra03,g_cra.cra04
 
          LET g_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_cra.cra01,SQLCA.sqlcode,0)
       INITIALIZE g_cra.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    END IF
    SELECT * INTO g_cra.* FROM cra_file WHERE cra00 = g_cra.cra00 AND cra01 = g_cra.cra01 AND cra02 = g_cra.cra02 AND cra03 = g_cra.cra03 AND cra04 = g_cra.cra04 
    IF SQLCA.SQLCODE THEN
#        CALL cl_err(g_cra.cra01,SQLCA.SQLCODE,0) #No.TQC-660045
         CALL cl_err3("sel","cra_file",g_cra.cra01,g_cra.cra02,SQLCA.SQLCODE,"","",0) #NO.TQC-660045
        INITIALIZE g_cra.* TO NULL
        RETURN
    END IF
    CALL p521_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION p521_show()
 
    DISPLAY BY NAME                              # 顯示單頭值
        g_cra.cra01,g_cra.cra02,g_cra.cra04,
        g_cra.cra05,g_cra.cra03,g_cra.craconf
    #異動單身
    CALL p521_b_fill()                 #單身
    CALL p521_bp("D")
    #合同單身
    CALL p521_b_fill2()                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p521_b_fill()              #BODY FILL UP
   DEFINE p_wc2   LIKE type_file.chr1000   #No.FUN-680069 VARCHAR(200)
 
    LET g_sql =
        "SELECT crb05,crb06,crb07,crb08,crb09,crb10,crb11,",
	" 	crb12,crb13 ",
        " FROM crb_file ",
        " WHERE crb01 ='",g_cra.cra01,"'",
        " AND   crb02 ='",g_cra.cra02,"' ",
        " AND   crb03 ='",g_cra.cra03,"' ",
        " AND   crb04 ='",g_cra.cra04,"' ",
        " AND   crb00 ='1' ",
        " ORDER BY crb05,crb06,crb07 "
    PREPARE p521_pb FROM g_sql
    DECLARE crb_curs                       #SCROLL CURSOR
        CURSOR FOR p521_pb
 
    CALL g_crb.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH crb_curs INTO g_crb[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.SQLCODE THEN
            CALL cl_err('foreach:',SQLCA.SQLCODE,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_crb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p521_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_crb TO s_crb.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
 
   DISPLAY ARRAY g_crc TO s_crc.* ATTRIBUTE(COUNT=g_rec_b2)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
#NO.FUN-6B0033--BEGIN                                                                                                               
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0033--END   
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION gen_detail
         LET g_action_choice="gen_detail"
         EXIT DISPLAY
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION first
         CALL p521_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
      ON ACTION previous
         CALL p521_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
      ON ACTION jump
         CALL p521_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
      ON ACTION next
         CALL p521_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
      ON ACTION last
         CALL p521_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
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
 
      ON ACTION accept
         LET g_action_choice="task_detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p521_y()    #確認
 DEFINE l_sum     LIKE type_file.num5         #No.FUN-680069 SMALLINT
 DEFINE l_sum1    LIKE type_file.num5         #No.FUN-680069 SMALLINT
 DEFINE l_qty     LIKE cod_file.cod09
 DEFINE l_tot     LIKE crb_file.crb10
 DEFINE l_cob08   LIKE cob_file.cob08
 DEFINE l_coc01   LIKE coc_file.coc01
 DEFINE l_cra     RECORD LIKE cra_file.*
 DEFINE l_crb     RECORD LIKE crb_file.*
 DEFINE cob08_x   ARRAY[10] OF LIKE qcs_file.qcs03, #No.FUN-680069 VARCHAR(10)
        l_flag    LIKE type_file.chr1         #No.FUN-680069 VARCHAR(1)
 DEFINE l_crb10   LIKE crb_file.crb10
 DEFINE l_crc_sum LIKE crc_file.crc09
 DEFINE l_crc05   LIKE crc_file.crc05
 DEFINE l_msg     LIKE zaa_file.zaa08         #No.FUN-680069 VARCHAR(80)
 DEFINE l_cnt     LIKE type_file.num5         #No.FUN-680069 SMALLINT
 DEFINE l_cob05   LIKE cob_file.cob05
 DEFINE l_coc05   LIKE coc_file.coc05
 DEFINE aco_qty   LIKE crc_file.crc08
 DEFINE l_crc     RECORD LIKE crc_file.*,
        l_crc2    RECORD LIKE crc_file.*
 
   IF g_cra.cra01 IS NULL OR g_cra.cra02 IS NULL OR
      g_cra.cra03 IS NULL OR g_cra.cra04 IS NULL THEN RETURN END IF
   IF g_cra.craconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   SELECT * INTO l_cra.* FROM cra_file
    WHERE cra01=g_cra.cra01 AND cra02 = g_cra.cra02
      AND cra03=g_cra.cra03 AND cra04=g_cra.cra04
      AND cra00='1'
   LET l_sum = 0
   LET g_success='Y'
   LET l_qty =0
   SELECT SUM(crc12) INTO l_crc_sum FROM crc_file  #扣銷量
    WHERE crc01 = g_cra.cra01
      AND crc02 = g_cra.cra02
      AND crc03 = g_cra.cra03
      AND crc04 = g_cra.cra04
      AND crc00 = '1'
 
   IF cl_null(l_crc_sum) THEN LET l_crc_sum=0 END IF
   BEGIN WORK
   CALL p521_sum_crb()   RETURNING l_tot     #匯總單身的對應合同量總和
   IF l_tot = 0 THEN
      CALL cl_err('body detail error',STATUS,0)
      ROLLBACK WORK
      RETURN
   END IF
   IF l_tot = l_crc_sum THEN        #報關單與未衝銷的量等于內部單據與未衝銷的量
      CALL p521_ins_coo2()
   ELSE
      IF l_tot < l_crc_sum THEN                #報關單的量大于內部單據的數量和
         CALL p521_ins_cre(l_tot) #將報關單未沖銷量寫入差異黨
      ELSE
         CALL p521_ins_crd(l_crc_sum)  #報關單的量小于內部單據的數量和
      END IF                                     #將生管單據尚未沖銷量寫入差異黨
   END IF
   IF g_success ='N' THEN ROLLBACK WORK RETURN END IF
   IF NOT cl_sure(16,09) THEN
      RETURN
   END IF
   CALL p521_b_fill()                 #單身
   CALL p521_bp("D")
  #合同單身
   CALL p521_b_fill2()                 #單身
   IF g_success ='N' THEN ROLLBACK WORK RETURN END IF
   OPEN p521_cl USING g_cra.cra00,g_cra.cra01,g_cra.cra02,g_cra.cra03,g_cra.cra04 
   IF STATUS THEN
      CALL cl_err("OPEN p521_cl:", STATUS, 1)
      CLOSE p521_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p521_cl INTO g_cra.*               # 對DB鎖定
   IF SQLCA.SQLCODE THEN
       CALL cl_err(g_cra.cra01,SQLCA.SQLCODE,0)
       CLOSE p521_cl
       ROLLBACK WORK
       RETURN
   END IF
   UPDATE cra_file SET craconf='Y'
        WHERE cra01 = g_cra.cra01
          AND cra02 = g_cra.cra02
          AND cra03 = g_cra.cra03
          AND cra04 = g_cra.cra04
          AND cra00 = '1'
   IF STATUS THEN
#      CALL cl_err('upd cofconf',STATUS,0) #No.TQC-660045
       CALL cl_err3("upd","cra_file",g_cra.cra01,g_cra.cra02,STATUS,"","upd cofconf",0) #NO.TQC-660045
      LET g_success='N'
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL ins_record()   #將此次的沖銷的數據紀錄到crg-file,crh-file
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT craconf INTO g_cra.craconf FROM cra_file
    WHERE cra01 = g_cra.cra01 AND cra02 = g_cra.cra02
      AND cra03=g_cra.cra03 AND cra04=g_cra.cra04
      AND cra00='1'
   DISPLAY BY NAME g_cra.craconf
END FUNCTION
 
FUNCTION p521_b_fill2()              #BODY FILL UP
DEFINE
    p_wc2        LIKE type_file.chr1000,   #No.FUN-680069 VARCHAR(200)
    l_cno031     LIKE cno_file.cno031,
    l_cno04      LIKE cno_file.cno04,
    l_cno05      LIKE cno_file.cno05
 
    LET g_sql =
        "SELECT crc05,'',crc06,crc07,crc08,crc09,crc11,crc12,'' ",
        " FROM crc_file ",
        " WHERE crc01 ='",g_cra.cra01,"'",
        " AND   crc02 ='",g_cra.cra02,"'",
        " AND   crc03 ='",g_cra.cra03,"'",
        " AND   crc04 ='",g_cra.cra04,"'",
        " AND   crc00 ='1'",
        " ORDER BY crc05 "
    PREPARE p521_pb2 FROM g_sql
    DECLARE crc_curs                       #SCROLL CURSOR
        CURSOR FOR p521_pb2
 
    CALL g_crc.clear()
    LET g_rec_b2 = 0
    LET g_cnt = 1
    FOREACH crc_curs INTO g_crc[g_cnt].*   #單身 ARRAY 填充
        LET g_rec_b2 = g_rec_b2 + 1
        IF SQLCA.SQLCODE THEN
            CALL cl_err('foreach:',SQLCA.SQLCODE,1)
            EXIT FOREACH
        END IF
        #讀取有效期限
           SELECT coc05
             INTO g_crc[g_cnt].coc05
             FROM coc_file
            WHERE coc03 = g_crc[g_cnt].crc05  #手冊編號
              AND coc10 = g_cra.cra02  #海關編號
 
        CALL p521_crc04(g_cra.cra04) RETURNING l_cno031,l_cno04
        SELECT cno05 INTO l_cno05 FROM cno_file,cnp_file
            WHERE cno06 = g_crc[g_cnt].crc06
              AND cno03 = '1'
              AND cno08 =g_cra.cra03
              AND cno10 =g_crc[g_cnt].crc05
              AND cno20 =g_cra.cra02
              AND cnp03 =g_cra.cra01
              AND cno031=l_cno031
              AND cno04 =l_cno04
              AND cnoconf <> 'X'  #CHI-C80041
 
          IF l_cno05 IS NOT NULL AND l_cno05 != ' ' AND l_cno031 ='1' THEN
             SELECT cnm08 INTO g_crc[g_cnt].cnm08 FROM cnm_file
               WHERE cnm01= l_cno05
          END IF
          IF l_cno05 IS NOT NULL AND l_cno05 != ' ' AND l_cno031 ='2' THEN
             SELECT cnm07 INTO g_crc[g_cnt].cnm08 FROM cnm_file
              WHERE cnm01= l_cno05
          END IF
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_crc.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    LET g_cnt = 0
    DISPLAY g_rec_b2 TO FORMONLY.cn4
END FUNCTION
 
#產生單身資料(含異動單,合同)
FUNCTION p521_g()
  DEFINE l_cmd     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(80)
         l_n,l_cnt LIKE type_file.num5          #No.FUN-680069 SMALLINT
  DEFINE l_cob01   LIKE cob_file.cob01,
         l_cob09   LIKE cob_file.cob09,
         l_coo05   LIKE coo_file.coo05,
         l_coo12   LIKE coo_file.coo12,
         l_coo10   LIKE coo_file.coo10,
         l_coo01   LIKE coo_file.coo01,
         l_coo02   LIKE coo_file.coo02,
         l_coo03   LIKE coo_file.coo03,
         l_coo04   LIKE coo_file.coo04,
         l_coo21   LIKE coo_file.coo21,
         l_coo14   LIKE coo_file.coo14,
         l_coo15   LIKE coo_file.coo15,
         l_coo16   LIKE coo_file.coo16,
         l_coo17   LIKE coo_file.coo17,
         l_cno10   LIKE cno_file.cno10,
         l_cno06   LIKE cno_file.cno06,
         l_cno07   LIKE cno_file.cno07,
         l_cno05   LIKE cno_file.cno05,
         l_cno031  LIKE cno_file.cno031,
         l_cno04   LIKE cno_file.cno04,
         l_crc09   LIKE crc_file.crc09,   #可用數量
         l_crc11   LIKE crc_file.crc11,   #已扣未報關
         l_crc12   LIKE crc_file.crc12,   #扣銷數量
         l_cnp05   LIKE cnp_file.cnp05,
         l_cnp06   LIKE cnp_file.cnp06,
         crb_qty   LIKE crb_file.crb10,
         crc_qty   LIKE crb_file.crb10,
         l_qty     LIKE crb_file.crb10
  DEFINE  l_cra    RECORD LIKE cra_file.*,
          l_cnp    RECORD LIKE cnp_file.*,
          l_cno    RECORD LIKE cno_file.*,
          l_crc    RECORD LIKE crc_file.*,
          l_in     LIKE cod_file.cod05,
          l_out    LIKE cod_file.cod05,
          l_flag   LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(50)
          l_flag1  LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(50)
          l_flag2  LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(50)
          l_wc     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(300)
          l_cod05  LIKE cod_file.cod05,
          l_coo216_sum LIKE coe_file.coe09      #No.FUN-680069 DEC(12,3)
  DEFINE l_sql,l_sql1   LIKE type_file.chr1000  #No.FUN-680069 VARCHAR(1200)
  DEFINE l_num          LIKE type_file.num5     #No.FUN-680069 SMALLINT
  DEFINE l_num1         LIKE type_file.num5     #No.FUN-680069 SMALLINT
  DEFINE l_num3         LIKE type_file.num5     #No.FUN-680069 SMALLINT
  DEFINE l_num4         LIKE type_file.num5     #No.FUN-680069 SMALLINT
 
    IF g_wc IS NULL THEN RETURN  END IF
    BEGIN WORK
    LET g_success='Y'
    LET l_num=0
 
    LET l_sql = " SELECT UNIQUE cob01,coo12,coo05,coo10,cob09 ",
                "  FROM coo_file,cob_file,cod_file,coc_file",
                "  WHERE coo11 = cob01  ",
                "  AND coc01 = cod01 ",
                "  AND (coc07 = '' OR coc07 IS NULL) ",
                "  AND cod03=cob01 ",
                "  AND cob03='1' ",
                "  AND coo12=coc10",
                "  AND coo16>0 ",
                "  AND coo10 IN ('0','1','2','5','6','7') ",
                "  AND cooconf='Y' ",
                "  AND ",g_wc CLIPPED,
                "  AND ",g_wc2 CLIPPED
    PREPARE p521_ccoa FROM l_sql
    DECLARE p521_pcoa CURSOR FOR p521_ccoa
    LET l_num = 0
    FOREACH p521_pcoa INTO l_cob01,l_coo12,l_coo05,l_coo10,l_cob09
         IF l_cob01 IS NULL OR l_coo12 IS NULL OR
            l_coo05 IS NULL OR l_coo10 IS NULL THEN
            CONTINUE FOREACH
         END IF
         IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
         LET l_num = l_num +1
         INSERT INTO cra_file VALUES('1',l_cob01,l_coo12,l_coo05,l_coo10,
                  l_cob09,'N',g_plant,g_legal) #FUN-980002 add g_plant,g_legal
         IF SQLCA.SQLCODE THEN
#            CALL cl_err('ins cra:',SQLCA.SQLCODE,0) #No.TQC-660045
             CALL cl_err3("ins","cra_file",l_cob01,l_coo12,SQLCA.SQLCODE,"","ins cra",0) #NO.TQC-660045
            LET g_success='N'
            EXIT FOREACH
         END IF
    END FOREACH
    IF g_success ='N' OR l_num = 0 THEN
       RETURN
    END IF
    LET l_wc =g_wc2
 
#TQC-930048  ---start
   #FOR l_i = 1 TO 298
   #    IF l_wc[l_i,l_i+2] = 'coo' THEN LET l_wc[l_i,l_i+2] = 'crd' END IF
   #END FOR
    LET l_wc = cl_replace_str(l_wc,"coo","crd")
#TQC-930048  ---end
 
    DECLARE cra_cus1 CURSOR FOR
         SELECT cra01,cra02,cra03,cra04 FROM cra_file
    FOREACH cra_cus1 INTO l_cob01,l_coo12,l_coo05,l_coo10
         #讀取異動檔的資料
         LET l_sql ="SELECT UNIQUE coo01,coo02,coo03,coo04,coo21,coo14, ",
                    "       coo15,coo16,coo17 ",
                    "  FROM coo_file",
                    " WHERE coo05='",l_coo05,"' ",  #客戶編號
                    "   AND coo11='",l_cob01,"'",  #商品編號
                    "   AND coo10='",l_coo10,"' ", #出口方式
                    "   AND coo12='",l_coo12,"' ", #海關代號
                    "   AND coo16>0 ",
                    "   AND coo22='N' ",
                    "   AND ",g_wc2 CLIPPED,
                    " UNION ",
                    "SELECT UNIQUE crd01,crd02,crd03,crd04,crd09,crd10, ",
                    "       crd11,crd12,crd13 ",
                    "  FROM crd_file",
                    " WHERE crd00='1' AND crd05='",l_coo05,"'",#客戶編號
                    "   AND crd06='",l_cob01,"'",  #商品編號
                    "   AND crd08='",l_coo10,"' ", #異動方式
                    "   AND crd07='",l_coo12,"' ", #海關代號
                    "   AND ",l_wc CLIPPED
 
         PREPARE p521_cco1 FROM l_sql
         DECLARE p521_pco1 CURSOR FOR p521_cco1
         LET l_num = 0
         LET l_qty=0
         FOREACH p521_pco1 INTO l_coo01,l_coo02,l_coo03,l_coo04,l_coo21,l_coo14,
                                l_coo15,l_coo16,l_coo17
            LET l_num = l_num + 1
            IF cl_null(l_coo16) THEN LET l_coo16=0 END IF
            INSERT INTO crb_file VALUES('1',l_cob01,l_coo12,l_coo05,l_coo10,
                   l_coo01,l_coo02,l_coo03,l_coo04,l_coo21,l_coo14,
                   l_coo15,l_coo16,l_coo17,g_plant,g_legal) #FUN-980002 add g_plant,g_legal
            IF SQLCA.SQLCODE THEN
#               CALL cl_err('ins crb:',SQLCA.SQLCODE,0) #No.TQC-660045
                CALL cl_err3("ins","crb_file",l_cob01,l_coo12,SQLCA.SQLCODE,"","ins crb:",0) #NO.TQC-660045
               LET g_success='N'
               EXIT FOREACH
            END IF
            IF l_coo21 <=0 OR cl_null(l_coo21)  THEN
               CALL cl_err('No Exchange Rate',SQLCA.SQLCODE,0)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
            LET l_qty = l_qty + l_coo16
         END FOREACH
         IF g_success = 'N' THEN
            EXIT FOREACH
         END IF
         IF l_num = 0 THEN
            CONTINUE FOREACH
         END IF
         IF l_qty <=0 THEN
            LET g_success='N'
            CALL cl_err(l_cob01,'aco-229',1)
            EXIT FOREACH
         END IF
         LET crb_qty=l_qty
         #查找可用於沖帳的報關單
         CALL p521_crc04(l_coo10) RETURNING l_cno031,l_cno04
         LET l_sql = " SELECT cno10,cno06,cno07,cnp05,cnp06 ",
                     "   FROM cno_file,cnp_file ",
                     "  WHERE cnoconf = 'Y' ",
                     "    AND cno21='N' ",
                     "    AND cno01=cnp01 ",
                     "    AND cno03='1' AND cnp03='",l_cob01,"'",
                     "    AND cno20='",l_coo12,"'",
                     "    AND cno08='",l_coo05,"'",
                     "    AND cno031='",l_cno031,"'",
                     "    AND cno04 ='",l_cno04,"'",
                     "    AND cnp05>0",
                     "    AND ",g_wc3
         LET l_wc3 =g_wc3
 
#TQC-930048  ---start
        #FOR l_i = 1 TO 298
        #    IF l_wc3[l_i,l_i+2] = 'cno' THEN LET l_wc3[l_i,l_i+2] = 'cre' END IF
        #END FOR
        LET l_wc3=cl_replace_str(l_wc3,"cno","cre")
#TQC-930048  ----end
 
         LET l_sql = l_sql CLIPPED,"  UNION ",
                     " SELECT cre10,cre06,cre07,crf05,crf06 ",
                     "   FROM cre_file,crf_file ",
                     "  WHERE cre01=crf01 ",
                     "    AND cre03='1' AND crf03='",l_cob01,"'",
                     "    AND cre20='",l_coo12,"'",
                     "    AND cre08='",l_coo05,"'",
                     "    AND cre031='",l_cno031,"'",
                     "    AND cre04 ='",l_cno04,"'",
                     "    AND ",l_wc3
         PREPARE cno_cus_prepare FROM l_sql
         DECLARE cno_cus CURSOR FOR cno_cus_prepare
 
         LET l_num1 = 0
         FOREACH cno_cus INTO l_cno10,l_cno06,l_cno07,l_cnp05,l_cnp06
            LET l_num1 = l_num1 +1
            IF l_cnp05 > 0 THEN
               SELECT cod05 INTO l_cod05 FROM cod_file,coc_file
                WHERE coc01=cod01 AND coc03=l_cno10 AND coc10=l_coo12
               INSERT INTO crc_file VALUES('1',l_cob01,l_coo12,l_coo05,l_coo10,
                   l_cno10,l_cno06,l_cno07,l_cod05,l_cnp05,l_cnp06,
                   0,l_cnp05,g_plant,g_legal) #FUN-980002 add g_plant,g_legal
               #TQC-790090
               #IF SQLCA.SQLCODE = -239 THEN
               IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
                  UPDATE crc_file set crc09=crc09+l_cnp05,
                                      crc12=crc12+l_cnp05
                   WHERE crc00='1'     AND crc01=l_cob01 AND crc02=l_coo12
                     AND crc03=l_coo05 AND crc04=l_coo10
               END IF
               #TQC-790090
               #IF SQLCA.SQLCODE AND SQLCA.SQLCODE != -239 THEN
               IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
                  LET g_success='N'
#                  CALL cl_err('ins crc_tmp:',SQLCA.SQLCODE,0) #No.TQC-660045
                   CALL cl_err3("upd","crc_file",l_cob01,l_coo12,SQLCA.SQLCODE,"","ins crc_tmp",0) #NO.TQC-660045
                  EXIT FOREACH
               END IF
            ELSE
               CONTINUE FOREACH
            END IF
         END FOREACH
         IF l_num1 = 0 THEN
            CONTINUE FOREACH
         END IF
         IF g_success = 'N'   THEN
            EXIT FOREACH
         ELSE
            CONTINUE FOREACH
         END IF
    END FOREACH
    IF g_success='Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
       CALL cl_err(g_cra.cra01,'agl-118',1)
       RETURN
    END IF
END FUNCTION
 
FUNCTION p521_sum_crb()
DEFINE   l_qty         LIKE crb_file.crb12
 
       SELECT  SUM(crb12) INTO l_qty FROM crb_file
         WHERE crb01 = g_cra.cra01
           AND crb02 = g_cra.cra02
           AND crb03 = g_cra.cra03
           AND crb04 = g_cra.cra04
           AND crb00 = '1'
           AND crb09 <> 0 AND crb09 IS NOT NULL
       #   ORDER BY crb07
    IF l_qty = ' ' OR l_qty IS NULL OR l_qty < 0 THEN LET l_qty = 0 END IF
    RETURN l_qty
END FUNCTION
 
FUNCTION p521_crc04(p_cra04)
DEFINE   p_cra04       LIKE cra_file.cra04
DEFINE   l_cno031      LIKE cno_file.cno031
DEFINE   l_cno04       LIKE cno_file.cno04
    CASE WHEN p_cra04='0'
              LET l_cno031='1' LET l_cno04='4'
         WHEN p_cra04='1'
              LET l_cno031='1' LET l_cno04='1'
         WHEN p_cra04='2'
              LET l_cno031='1' LET l_cno04='2'
         WHEN p_cra04='5'
              LET l_cno031='2' LET l_cno04='4'
         WHEN p_cra04='6'
              LET l_cno031='2' LET l_cno04='1'
         WHEN p_cra04='7'
              LET l_cno031='2' LET l_cno04='2'
    END CASE
    RETURN l_cno031,l_cno04
END FUNCTION
 
#如果異動與報關數量相等時
FUNCTION p521_ins_coo2()
  DEFINE l_crc       RECORD LIKE crc_file.*
  DEFINE l_coo       RECORD LIKE coo_file.*
  DEFINE l_cnp       RECORD LIKE cnp_file.*
  DEFINE l_cno       RECORD LIKE cno_file.*
  DEFINE l_coo22     LIKE coo_file.coo22
  DEFINE l_crb2      RECORD LIKE crb_file.* ,
         l_cno01     LIKE cno_file.cno01,
         l_cno21     LIKE cno_file.cno21,
         l_cno031    LIKE cno_file.cno031,
         l_cno04     LIKE cno_file.cno04,
         l_sum1      LIKE type_file.num5,         #No.FUN-680069 SMALLINT
         l_sum2      LIKE type_file.num5,         #No.FUN-680069 SMALLINT
         l_cnt       LIKE type_file.num5          #No.FUN-680069 SMALLINT
  DEFINE l_qty       LIKE cod_file.cod09
  DEFINE cob08_x     ARRAY[10] OF LIKE qcs_file.qcs03,       #No.FUN-680069 VARCHAR(10)
         l_sql       LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600)
         l_flag      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    DECLARE crc_cus_sum CURSOR FOR
    SELECT * FROM crc_file
       WHERE crc01 = g_cra.cra01
         AND crc02 = g_cra.cra02
         AND crc03 = g_cra.cra03
         AND crc04 = g_cra.cra04
         AND crc00 = '1'
         ORDER BY crc07         ##按時間排序
 
    DECLARE coo2_cus_sum CURSOR FOR
       SELECT * FROM crb_file
         WHERE crb01 = g_cra.cra01
           AND crb02 = g_cra.cra02
           AND crb03 = g_cra.cra03
           AND crb04 = g_cra.cra04
           AND crb00 = '1'
           ORDER BY crb07      #按時間排序
    #針對每一交易單據的數量,將異動數量轉換成合同單位
    FOREACH coo2_cus_sum INTO l_crb2.*
        SELECT coo22 INTO l_coo22 FROM coo_file  #是否是第一次衝帳
         WHERE coo01 = l_crb2.crb05
           AND coo02 = l_crb2.crb06
           AND cooconf = 'Y'
        IF SQLCA.SQLCODE THEN LET g_success = 'N' EXIT FOREACH END IF
        IF l_coo22 ='N' THEN
           UPDATE coo_file SET coo22='Y'
               WHERE coo01 = l_crb2.crb05
                 AND coo02 = l_crb2.crb06
           IF SQLCA.SQLCODE THEN
#              CALL cl_err('upd coo:',SQLCA.SQLCODE,0) #No.TQC-660045
               CALL cl_err3("upd","coo_file",l_crb2.crb05,l_crb2.crb06,SQLCA.SQLCODE,"","upd coo:",0) #NO.TQC-660045
              LET g_success='N'
              EXIT FOREACH
           END IF
        END IF
        SELECT COUNT(*) INTO l_sum2 FROM crd_file   #刪除可能存在的差異檔
         WHERE crd01 = l_crb2.crb05
           AND crd02 = l_crb2.crb06       #項次
           AND crd00 = '1'  #FOR 成品
        IF SQLCA.SQLCODE THEN
#           CALL cl_err('sel coo11:',SQLCA.SQLCODE,0) #No.TQC-660045
            CALL cl_err3("sel","crd_file",l_crb2.crb05,l_crb2.crb06,SQLCA.SQLCODE,"","sel coo11",0) #NO.TQC-660045
           LET g_success='N'
           EXIT FOREACH
        END IF
        IF l_sum2 > 0 THEN
           DELETE FROM crd_file
            WHERE crd01 = l_crb2.crb05
              AND crd02 = l_crb2.crb06       #項次
              AND crd00 = '1'  #FOR 成品
           IF SQLCA.SQLCODE THEN
#              CALL cl_err('del crd:',SQLCA.SQLCODE,0) #No.TQC-660045
               CALL cl_err3("del","crd_file",l_crb2.crb05,l_crb2.crb06,SQLCA.SQLCODE,"","del crd:",0) #NO.TQC-660045
              LET g_success='N'
              EXIT FOREACH
           END IF
        END IF
    END FOREACH #是否是第一次衝帳
    FOREACH crc_cus_sum INTO l_crc.*
       CALL p521_crc04(g_cra.cra04) RETURNING l_cno031,l_cno04
       LET l_sql = " SELECT UNIQUE cno01,cno21  FROM cno_file,cnp_file",
                   "  WHERE cnoconf = 'Y' ",
                   "    AND cno01=cnp01 ",
                   "    AND cno03='1' AND cnp03='",g_cra.cra01,"'",
                   "    AND cno20='",g_cra.cra02,"'",
                   "    AND cno08='",g_cra.cra03,"'",
                   "    AND cno031='",l_cno031,"'",
                   "    AND cno04='",l_cno04,"'",
                   "    AND cnp05>0",
                   "    AND cno06 ='", l_crc.crc06,"'",
                   "    AND ",g_wc3
       PREPARE crc_cus_prepare FROM l_sql
       DECLARE crc_cus CURSOR FOR crc_cus_prepare
       FOREACH crc_cus INTO l_cno01,l_cno21
          IF SQLCA.SQLCODE THEN LET g_success = 'N' EXIT FOREACH END IF
          IF l_cno21 ='N' THEN
              UPDATE cno_file SET cno21 = 'Y' #衝帳否
               WHERE cno01 = l_cno01
              IF SQLCA.SQLCODE THEN
#                 CALL cl_err('upd cno:',SQLCA.SQLCODE,0) #No.TQC-660045
                  CALL cl_err3("upd","cno_file",l_cno01,"",SQLCA.SQLCODE,"","upd cno:",0) #NO.TQC-660045
                 LET g_success='N'
                 EXIT FOREACH
              END IF
          END IF
          LET l_sum2 = 0
          SELECT COUNT(*) INTO l_sum2
             FROM cre_file,crf_file #刪除可能存在的差異檔
            WHERE  cre01  = crf01
              AND  cre01  = l_cno01
          IF SQLCA.SQLCODE THEN
#              CALL cl_err('sel cnp1:',SQLCA.SQLCODE,0) #No.TQC-660045
               CALL cl_err3("sel","cre_file,crf_file",l_cno01,"",SQLCA.SQLCODE,"","sel cnp1:",0) #NO.TQC-660045
              LET g_success='N'
          END IF
          IF l_sum2 > 0 THEN            #數據來源于差異檔cre_file,crf_file
              DELETE FROM crf_file WHERE crf00  = l_cno01
              DELETE FROM cre_file WHERE cre00 = l_cno01
              IF SQLCA.SQLCODE THEN
#                 CALL cl_err('del crf,cre:',SQLCA.SQLCODE,0) #No.TQC-660045
                  CALL cl_err3("del","cre_file",l_cno01,"",SQLCA.SQLCODE,"","del crf,cre",1) #NO.TQC-660045
                 LET g_success='N'
              END IF
          END IF
       END FOREACH
    END FOREACH
    IF g_success = 'N' THEN
      CALL cl_err('',STATUS,0)
      RETURN
    END IF
END FUNCTION
 
FUNCTION p521_ins_cre(p_sum2)   #將報關單未沖銷量寫入差異黨
   DEFINE p_sum2   LIKE cnp_file.cnp05,          #No.FUN-680069 DEC(12,3)
          l_sum    LIKE crc_file.crc09,
          l_crf01  LIKE crf_file.crf01,
          l_crf012 LIKE crf_file.crf012,
          l_flag   LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
          l_flag1  LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
          l_cno01  LIKE cno_file.cno01,
          l_sql    LIKE type_file.chr1000,       #No.FUN-680069 VARCHAR(800)
          l_cob05  LIKE cob_file.cob05
   DEFINE l_crc    RECORD LIKE crc_file.*
   DEFINE l_crb    RECORD LIKE crb_file.*
   DEFINE l_cno    RECORD LIKE  cno_file.*
   DEFINE l_cnp    RECORD LIKE  cnp_file.*
   DEFINE l_coo2   RECORD LIKE  coo_file.*
   DEFINE l_cno031 LIKE  cno_file.cno031
   DEFINE l_cno04  LIKE  cno_file.cno04
 
    DECLARE crc_cus_cre CURSOR FOR
     SELECT * FROM crc_file
      WHERE crc01 = g_cra.cra01
        AND crc02 = g_cra.cra02
        AND crc03 = g_cra.cra03
        AND crc04 = g_cra.cra04
        AND crc00 = '1'
        ORDER BY crc07
    LET l_flag='Y'
    LET l_flag1='Y'
 
    FOREACH crc_cus_cre INTO l_crc.*
       IF cl_null(l_crc.crc09) THEN LET l_crc.crc09=0 END IF
       LET l_sum=l_crc.crc09
       IF l_flag='Y'THEN
          IF l_sum-p_sum2<0 THEN
             LET p_sum2=-(l_sum-p_sum2)
             CALL p521_crc04(l_crc.crc04) RETURNING l_cno031,l_cno04
             LET l_sql = " SELECT crf01,crf012 FROM cre_file,crf_file",
                         "  WHERE cre01=crf01 ",
                         "    AND cre03='1' AND crf03='",l_crc.crc01,"'",
                         "    AND cre20='",l_crc.crc02,"'",
                         "    AND cre08='",l_crc.crc03,"'",
                         "    AND cre031='",l_cno031,"'",
                         "    AND cre04 ='",l_cno04,"'",
                         "    AND cre06 ='", l_crc.crc06,"'"
             PREPARE del_cre_prepare FROM l_sql
             DECLARE del_cus CURSOR FOR del_cre_prepare
             FOREACH del_cus INTO l_crf01,l_crf012
                IF l_flag1='Y' THEN
                   DELETE FROM crf_file WHERE crf01=l_crf01
                                          AND crf012=l_crf012
                   DELETE FROM cre_file WHERE cre01 NOT IN
                                      (SELECT crf01 FROM crf_file
                                        WHERE crf01=l_crf01
                                          AND crf012=l_crf012)
                END IF
             END FOREACH
             CONTINUE FOREACH
          ELSE
             LET l_flag='N'
             LET l_sum=l_sum-p_sum2
          END IF
       END IF
       IF l_flag='N' THEN
          CALL p521_crc04(l_crc.crc04) RETURNING l_cno031,l_cno04
          LET l_sql = " SELECT UNIQUE cno01,cno21 ",
                      "   FROM cno_file,cnp_file ",
                      "  WHERE cnoconf = 'Y' ",
                      "    AND cno01=cnp01 ",
                      "    AND cno03='1' AND cnp03='",l_crc.crc01,"'",
                      "    AND cno20='",l_crc.crc02,"'",
                      "    AND cno08='",l_crc.crc03,"'",
                      "    AND cno031='",l_cno031,"'",
                      "    AND cno04='",l_cno04,"'",
                      "    AND cnp05>0",
                      "    AND cno06 ='", l_crc.crc06,"'",
                      "    AND ",g_wc3
          PREPARE cno21_cus_prepare FROM l_sql
          DECLARE cno21_cus CURSOR FOR cno21_cus_prepare
          FOREACH cno21_cus INTO l_cno01,l_flag1
             IF l_flag1='N' THEN
                LET l_sql = "SELECT * FROM cno_file,cnp_file",
                            " WHERE cno01 = cnp01 ",
                            "   AND cno01 = '",l_cno01,"'",
                            "   AND cnp03 = '",l_crc.crc01,"'",
                            "   AND cnoconf <> 'X' ",  #CHI-C80041
                            "   AND ",g_wc3
             ELSE
                LET l_sql = "SELECT * FROM cre_file,crf_file",
                            " WHERE cre01 = crf01 ",
                            "   AND cre01 = '",l_cno01,"'",
                            "   AND crf03 = '",l_crc.crc01,"'",
                            "   AND ",l_wc3
             END IF
             PREPARE p520_ins_pre FROM l_sql
             DECLARE p520_ins_cno12 CURSOR FOR p520_ins_pre
             FOREACH p520_ins_cno12 INTO l_cno.*,l_cnp.*
               IF l_flag1 = 'N'  THEN
                  INSERT INTO cre_file VALUES(l_cno.cno01,l_cno.cno02,l_cno.cno03,
                      l_cno.cno031,l_cno.cno04,l_cno.cno05,l_cno.cno06,l_cno.cno07,
                      l_cno.cno08,l_cno.cno09,l_cno.cno10,l_cno.cno11,l_cno.cno12,
                      l_cno.cno13,l_cno.cno14,l_cno.cno15,l_cno.cno16,l_cno.cno17,
                      l_cno.cno18,l_cno.cno19,l_cno.cno20,l_cno.cnoconf,l_cno.cnoacti,
                      l_cno.cnouser,l_cno.cnogrup,l_cno.cnomodu,l_cno.cnodate,g_plant,g_legal, g_user, g_grup) #FUN-980002 add g_plant,g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
                  #TQC-790090
                  #IF SQLCA.SQLCODE AND SQLCA.SQLCODE != -239 THEN
                  IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
#                     CALL cl_err('ins_cre err',STATUS,0) #No.TQC-660045
                      CALL cl_err3("ins","cre_file",l_cno.cno01,"",STATUS,"","ins_cre err",0) #NO.TQC-660045
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
                  #若有2筆以上cnp_file，當第1筆的數量比coo_file(p_sum2)小
                  IF l_cnp.cnp05 > p_sum2 THEN
                     LET l_cnp.cnp05 = l_sum
                     LET l_cnp.cnp05 = s_digqty(l_cnp.cnp05,l_cnp.cnp06)   #No.FUN-BB0086
                     #FUN-980002 -- start --
                     ##INSERT INTO crf_file VALUES(l_cnp.*)
                     INSERT INTO crf_file(crf01,crf012,crf02,crf03,crf04,
                                          crf05,crf06, crf07,crf08,crf09, 
                                          crf10,crf11, crf12,crf13,crf14,
                                          crf15,crfplant,crflegal)
                                   VALUES(l_cnp.cnp01,l_cnp.cnp012,
                                          l_cnp.cnp02,l_cnp.cnp03,
                                          l_cnp.cnp04,l_cnp.cnp05,
                                          l_cnp.cnp06,l_cnp.cnp07,
                                          l_cnp.cnp08,l_cnp.cnp09,
                                          l_cnp.cnp10,l_cnp.cnp11,
                                          l_cnp.cnp12,l_cnp.cnp13,
                                          l_cnp.cnp14,l_cnp.cnp15,
                                          g_plant,g_legal)
                     #FUN-980002 -- end --
                     #TQC-790090
                     #IF SQLCA.SQLCODE AND SQLCA.SQLCODE != -239 THEN
                     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
#                        CALL cl_err('ins_crf err',STATUS,0) #No.TQC-660045
                         CALL cl_err3("ins","crf_file",l_cnp.cnp01,l_cnp.cnp012,STATUS,"","ins_crf err",0) #NO.TQC-660045
                        LET g_success = 'N'
                        EXIT FOREACH
                     END IF
                  ELSE
                     LET p_sum2 = p_sum2 - l_cnp.cnp05
                  END IF
                  UPDATE cno_file SET cno21 ='Y'
                   WHERE cno01 = l_cno.cno01
                  IF SQLCA.SQLCODE  THEN
#                     CALL cl_err('upd_cno21 err',STATUS,0) #No.TQC-660045
                      CALL cl_err3("upd","cno_file",l_cno.cno01,"",STATUS,"","upd_cno21 err",0) #NO.TQC-660045
                     LET g_success = 'N'
                     RETURN
                  END IF
               ELSE
                  LET l_sum = s_digqty(l_sum,l_cnp.cnp06)   #No.FUN-BB0086
                  UPDATE crf_file SET crf05=l_sum
                   WHERE crf01=l_cnp.cnp01
                     AND crf012=l_cnp.cnp012
                  IF SQLCA.SQLCODE THEN
#                     CALL cl_err('upd_crf err',STATUS,0) #No.TQC-660045
                      CALL cl_err3("upd","crf_file",l_cnp.cnp01,l_cnp.cnp012,STATUS,"","upd_crf",0) #NO.TQC-660045
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
               END IF
             END FOREACH
          END FOREACH
       END IF
    END FOREACH
    IF g_success = 'N' THEN RETURN END IF
    DECLARE crb_cus_cno CURSOR FOR
      SELECT * FROM crb_file
       WHERE crb01 = g_cra.cra01
         AND crb02 = g_cra.cra02
         AND crb03 = g_cra.cra03
         AND crb04 = g_cra.cra04
         AND crb00 = '1'
    FOREACH crb_cus_cno INTO l_crb.*
       DELETE FROM crd_file WHERE crd01=l_crb.crb05 AND crd02=l_crb.crb06
       IF SQLCA.SQLCODE  THEN
#          CALL cl_err('del_crd err',STATUS,0) #No.TQC-660045
           CALL cl_err3("del","crd_file",l_crb.crb05,l_crb.crb06,STATUS,"","del_crd err",0) #NO.TQC-660045
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       UPDATE coo_file SET coo22 = 'Y'
        WHERE coo01 = l_crb.crb05
          AND coo02 = l_crb.crb06
       IF SQLCA.SQLCODE THEN
#          CALL cl_err('upd coo err',STATUS,0) #No.TQC-660045
           CALL cl_err3("upd","coo_file",l_crb.crb05,l_crb.crb06,STATUS,"","upd coo err",0) #NO.TQC-660045
          LET g_success = 'N'
          EXIT FOREACH
       END IF
    END FOREACH
 
END FUNCTION
 
#將內部異動寫入異動差異檔
FUNCTION p521_ins_crd(p_sum2)
   DEFINE p_sum2   LIKE cnp_file.cnp05,       #No.FUN-680069 DEC(12,3)
          l_crb    RECORD LIKE crb_file.*,
          l_crb2   RECORD LIKE crb_file.*,
          l_coo    RECORD LIKE coo_file.*,
          l_coo1   RECORD LIKE coo_file.*,
          l_crc    RECORD LIKE crc_file.*,
          l_cno    RECORD LIKE cno_file.*  ,
          l_cnp    RECORD LIKE cnp_file.*,
          l_crb12  LIKE crb_file.crb09,        #No.FUN-680069 DEC(12,8)
          l_crb15  LIKE aba_file.aba18,        #No.FUN-680069 VARCHAR(2)
          l_sql     LIKE type_file.chr1000,    #No.FUN-680069 VARCHAR(300)
          l_cob05   LIKE cob_file.cob05,
          l_cob08   LIKE cob_file.cob08,
          l_sum     LIKE crb_file.crb12,       #No.FUN-680069 DEC(12,3)
          l_change  LIKE crb_file.crb12,       #No.FUN-680069 DEC(12,3)
          l_qty     LIKE coo_file.coo16,       #No.FUN-680069 DEC(12,3)
          l_cnt     LIKE type_file.num5,       #No.FUN-680069 SMALLINT
          l_flag1   LIKE type_file.chr1,       #No.FUN-680069 VARCHAR(1)
          l_flag    LIKE type_file.chr1,       #No.FUN-680069 VARCHAR(1)
          l_crf01   LIKE crf_file.crf01,
          l_crf012  LIKE crf_file.crf012,
          l_cno031  LIKE cno_file.cno031,
          l_cno04   LIKE cno_file.cno04,
          l_crd10   LIKE crd_file.crd10        #No.FUN-BB0086
 
 
    DECLARE crb_cus_cre CURSOR FOR
     SELECT * FROM crb_file
      WHERE crb01 = g_cra.cra01
        AND crb02 = g_cra.cra02
        AND crb03 = g_cra.cra03
        AND crb04 = g_cra.cra04
        AND crb00 = '1'
        ORDER BY crb07
    LET l_flag='Y'
 
    FOREACH crb_cus_cre INTO l_crb.*
       IF cl_null(l_crb.crb12) THEN LET l_crb.crb12=0 END IF
       LET l_sum=l_crb.crb12
       IF l_flag='Y'THEN
          IF l_sum-p_sum2<0 THEN
             LET p_sum2=-(l_sum-p_sum2)
             #若衝銷的是上次未衝完的差異量則刪除該記錄
             DELETE FROM crd_file WHERE crd01=l_crb.crb05
                                    AND crd02=l_crb.crb06
                                    AND crd00='1'
             #若衝銷的是未衝過的內部單據
             IF SQLCA.sqlerrd[3]=0  THEN
                UPDATE coo_file SET coo22 ='Y'
                 WHERE coo01 = l_crb.crb05
                   AND coo02 = l_crb.crb06
                IF SQLCA.SQLCODE  THEN
#                     CALL cl_err('upd_coo22 err',STATUS,0) #No.TQC-660045
                      CALL cl_err3("upd","coo_file",l_crb.crb05,l_crb.crb06,STATUS,"","upd_coo22 err",0) #NO.TQC-660045
                     LET g_success = 'N'
                     RETURN
                END IF
             END IF
             CONTINUE FOREACH
          ELSE
             LET l_flag='N'
             LET l_sum=l_sum-p_sum2
          END IF
       END IF
       IF l_flag='N' THEN
           SELECT coo22 INTO l_flag1 FROM coo_file
            WHERE coo01=l_crb.crb05
              AND coo02=l_crb.crb06
              AND cooacti='Y'
              AND cooconf='Y'
          IF l_flag1='N' THEN
             LET l_sql = "SELECT * FROM coo_file",
                         " WHERE coo01 = '",l_crb.crb05,"'",
                         "   AND coo02 = '",l_crb.crb06,"'",
                         "   AND ",g_wc2
             PREPARE p520_ins_pre1 FROM l_sql
             DECLARE p520_ins_coo22 CURSOR FOR p520_ins_pre1
             OPEN p520_ins_coo22
             FETCH p520_ins_coo22 INTO l_coo.*
               LET l_coo.coo16 = l_sum
               LET l_coo.coo14 = l_coo.coo16/l_coo.coo21  #轉換異動數量
 
               INSERT INTO crd_file
               VALUES('1',l_coo.coo01,l_coo.coo02,l_coo.coo03,l_coo.coo04,
                 l_coo.coo05,l_coo.coo11,l_coo.coo12,l_coo.coo10,l_coo.coo21,
                 l_coo.coo14,l_coo.coo15,l_coo.coo16,l_coo.coo17,g_plant,g_legal) #FUN-980002 add g_plant,g_legal
             #TQC-790090
             #IF SQLCA.SQLCODE AND SQLCA.SQLCODE != -239 THEN
             IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
#                CALL cl_err('ins_crd err',STATUS,0) #No.TQC-660045
                 CALL cl_err3("ins","crd_file",l_coo.coo01,l_coo.coo02,STATUS,"","ins_crd err",0) #NO.TQC-660045
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             UPDATE coo_file SET coo22 ='Y'
                WHERE coo01 = l_coo.coo01
             IF SQLCA.SQLCODE  THEN
#                  CALL cl_err('upd_coo err',STATUS,0) #No.TQC-660045
                   CALL cl_err3("upd","coo_file",l_coo.coo01,"",STATUS,"","upd_coo err",0) #NO.TQC-660045
                  LET g_success = 'N'
                  RETURN
             END IF
          ELSE
	       #No.FUN-BB0086--add--begin--
               LET l_sum = s_digqty(l_sum,l_crb.crb13)
               LET l_crd10 = s_digqty(l_sum/l_crb.crb09,l_crb.crb11)
	       #No.FUN-BB0086--add--end--
               UPDATE crd_file SET crd12=l_sum,crd10=l_crd10
                WHERE crd00='1'
                  AND crd01=l_crb.crb05
                  AND crd02=l_crb.crb06
               IF SQLCA.SQLCODE THEN
#                  CALL cl_err('upd_crd err',STATUS,0) #No.TQC-660045
                   CALL cl_err3("upd","crd_file",l_crb.crb05,l_crb.crb06,STATUS,"","upd_crd",0) #NO.TQC-660045
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
          END IF
       END IF
    END FOREACH
    IF g_success = 'N' THEN RETURN END IF
    DECLARE crc_cus_crd1 CURSOR FOR
    SELECT * FROM crc_file
     WHERE crc00='1' AND crc01=g_cra.cra01
      AND crc02=g_cra.cra02 AND crc03=g_cra.cra03
      AND crc04=g_cra.cra04
    CALL p521_crc04(g_cra.cra04) RETURNING l_cno031,l_cno04
    FOREACH crc_cus_crd1 INTO l_crc.*
    SELECT crf01,crf012 INTO l_crf01,l_crf012 FROM cre_file,crf_file
     WHERE cre01=crf01
       AND cre03='1' AND crf03=g_cra.cra01
       AND cre20=g_cra.cra02
       AND cre08=g_cra.cra03
       AND cre031=l_cno031
       AND cre04=l_cno04
       AND cre06=l_crc.crc06
       AND cre10=l_crc.crc05
       AND crf05>0
    IF SQLCA.SQLCODE = 100 THEN
       SELECT UNIQUE cnp01 INTO l_crf01 FROM cno_file,cnp_file
        WHERE cno01=cnp01
          AND cno03='1' AND cnp03=g_cra.cra01
          AND cno20=g_cra.cra02
          AND cno08=g_cra.cra03
          AND cno031=l_cno031
          AND cno04=l_cno04
          AND cno06=l_crc.crc06
          AND cno10=l_crc.crc05
          AND cnp05>0
          AND cnoconf <> 'X'  #CHI-C80041
    ELSE
       DELETE FROM crf_file WHERE crf01=l_crf01 AND crf012=l_crf012
       IF SQLCA.SQLCODE  THEN
#          CALL cl_err('del_crf err',STATUS,0) #No.TQC-660045
           CALL cl_err3("del","crf_file",l_crf01,l_crf012,STATUS,"","del_crf err",0) #NO.TQC-660045
          LET g_success = 'N'
          RETURN
       END IF
       DELETE FROM cre_file WHERE cre01 NOT IN
                          (SELECT crf01 FROM crf_file
                            WHERE crf01=l_crf01
                              AND crf012=l_crf012)
       IF SQLCA.SQLCODE  THEN
#          CALL cl_err('del_cre err',STATUS,0) #No.TQC-660045
           CALL cl_err3("del","cre_file",l_crf01,l_crf012,STATUS,"","del_cre err",0) #NO.TQC-660045
          LET g_success = 'N'
          RETURN
       END IF
    END IF
    UPDATE cno_file SET cno21 = 'Y'
     WHERE cno01 = l_crf01
    IF SQLCA.SQLCODE THEN
#       CALL cl_err('upd cno err',STATUS,0) #No.TQC-660045
        CALL cl_err3("upd","cno_file",l_crf01,"",STATUS,"","upd cno err",0) #NO.TQC-660045
       LET g_success = 'N'
       RETURN
    END IF
    END FOREACH
END FUNCTION
 
FUNCTION ins_record()
 DEFINE l_cra    RECORD LIKE cra_file.*
 DEFINE l_crb    RECORD LIKE crb_file.*
 DEFINE l_crc    RECORD LIKE crc_file.*,
        l_cnt    LIKE crg_file.crg01,
        l_cnt1   LIKE crh_file.crh01,
        l_crh02  LIKE crh_file.crh02,
        l_crh03  LIKE crh_file.crh03,
        l_crg01  LIKE crg_file.crg02,
        l_crg02  LIKE crg_file.crg03
 
   SELECT * INTO l_cra.* FROM cra_file
    WHERE cra01 = g_cra.cra01
      AND cra02 = g_cra.cra02
      AND cra03 = g_cra.cra03
      AND cra04 = g_cra.cra04
      AND cra00 = '1'
   IF SQLCA.SQLCODE AND SQLCA.SQLCODE != 100 THEN
      LET g_success ='N'
      RETURN
   END IF
 
   DECLARE p521_rec_crc CURSOR FOR
    SELECT * FROM crc_file
    WHERE crc01 = g_cra.cra01
      AND crc02 = g_cra.cra02
      AND crc03 = g_cra.cra03
      AND crc04 = g_cra.cra04
      AND crc00 = '1'
      ORDER BY crc07
 
   IF SQLCA.SQLCODE AND SQLCA.SQLCODE != 100 THEN
      LET g_success ='N'
      RETURN
   END IF
   LET l_cnt = 0
   SELECT MAX(crg01) INTO l_cnt FROM  crg_file
    IF SQLCA.SQLCODE AND SQLCA.SQLCODE != 100 THEN
       LET g_success ='N'
       RETURN
    END IF
    IF l_cnt = 0 OR l_cnt IS NULL THEN
       LET l_cnt =1
    ELSE
       LET l_cnt = l_cnt + 1
    END IF
    LET l_crg01 = TODAY
    LET l_crg02 = TIME
    FOREACH p521_rec_crc INTO l_crc.*
       INSERT INTO crg_file VALUES(l_cnt,l_crg01,l_crg02,l_cra.cra01,l_cra.cra02,
             l_cra.cra03,l_cra.cra04,l_crc.crc05,l_crc.crc06,l_crc.crc07,
             l_crc.crc08,l_crc.crc09,l_crc.crc10,l_crc.crc11,l_crc.crc12,g_plant,g_legal) #FUN-980002 add g_plant,g_legal
       IF SQLCA.SQLCODE THEN LET g_success ='N' EXIT FOREACH END IF
       LET l_cnt = l_cnt + 1
    END FOREACH
    IF SQLCA.SQLCODE THEN LET g_success ='N' RETURN END IF
    SELECT MAX(crh01) INTO l_cnt1 FROM  crh_file
    IF SQLCA.SQLCODE AND SQLCA.SQLCODE != 100 THEN
       LET g_success ='N'
       RETURN
    END IF
    IF l_cnt1 = 0 OR l_cnt1 IS NULL THEN
       LET l_cnt1 =1
    ELSE
       LET l_cnt1 = l_cnt1 + 1
    END IF
    LET l_crh02 = TODAY
    LET l_crh03 = TIME
    DECLARE p521_rec_crb CURSOR FOR
      SELECT * FROM crb_file
       WHERE crb01 = g_cra.cra01
         AND crb02 = g_cra.cra02
         AND crb03 = g_cra.cra03
         AND crb04 = g_cra.cra04
         AND crb00 = '1'
    FOREACH p521_rec_crb INTO l_crb.*
      INSERT INTO crh_file
         VALUES(l_cnt1,l_crh02,l_crh03,l_cra.cra01,l_cra.cra02,l_cra.cra03,
                l_cra.cra04,l_crb.crb05,l_crb.crb06,l_crb.crb07,l_crb.crb08,
                l_crb.crb09,l_crb.crb10,l_crb.crb11,l_crb.crb12,l_crb.crb13,g_plant,g_legal) #FUN-980002 add g_plant,g_legal
      IF SQLCA.SQLCODE THEN LET g_success ='N' EXIT FOREACH END IF
      LET l_cnt1 = l_cnt1 + 1
    END FOREACH
END FUNCTION
#Patch....NO.TQC-610035 <001> #
