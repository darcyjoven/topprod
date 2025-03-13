# Prog. Version..: '5.10.00-08.01.04(00000)'     #
#
# Pattern name...: axdq200.4gl
# Descriptions...: 集團撥入單價查詢作業
# Date & Author..: 03/12/12 By Hawk
# Modify.........: No:FUN-4C0052 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: Mo.FUN-6A0078 06/10/24 By xumin g_no_ask改mi_no_ask
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_adh           RECORD LIKE adh_file.*,    #簽核等級 (假單頭)
    g_adh_t         RECORD LIKE adh_file.*,    #簽核等級 (舊值)
    g_adh01_t       LIKE adh_file.adh01,       #簽核等級 (舊值)
    g_adh_rowid     LIKE type_file.chr18,      #ROWID        #No.FUN-680108 INT
    g_adi           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
            adi02   LIKE adi_file.adi02,       #撥入單項次
            adi05   LIKE adi_file.adi05,       #料件編號
            adi08   LIKE adi_file.adi08,       #批號
            adi06   LIKE adi_file.adi06,       #倉庫代號
            adi07   LIKE adi_file.adi07,       #儲位
            adi03   LIKE adi_file.adi03,       #參考單號
            adi04   LIKE adi_file.adi04,       #參考項次
            adi09   LIKE adi_file.adi09,       #單位
            adi10   LIKE adi_file.adi10,       #撥入數量
            adi11   LIKE adi_file.adi11,       #轉撥計價方式
            adi12   LIKE adi_file.adi12,       #轉撥百分比
            adi13   LIKE adi_file.adi13,       #撥入單價
            adi14   LIKE adi_file.adi14        #撥入金額
                    END RECORD,
    g_argv1         LIKE adi_file.adi01,
    g_wc,g_wc2,g_sql    string,                #No:FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,       #單身筆數     #No.FUN-680108 SMALLINT
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT    #No.FUN-680108 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5        #No.FUN-680108 SMALLINT
DEFINE   g_cnt      LIKE type_file.num10       #No.FUN-680108 INTEGER
DEFINE   g_cn2      LIKE type_file.num10       #No.FUN-680108 INTEGER
DEFINE   g_msg      LIKE type_file.chr1000     #No.FUN-680108 VARCHAR(72)
DEFINE   g_forupd_sql   STRING                 #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680108 INTEGER
 
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-680108 SMALLINT   #No.FUN-6A0078

#主程式開始
MAIN
#DEFINE                                        #No.FUN-6A0091       
#       l_time    LIKE type_file.chr8          #No.FUN-6A0091

    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXD")) THEN
      EXIT PROGRAM
   END IF
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
    LET g_argv1 = ARG_VAL(1)
    LET g_forupd_sql = "SELECT * FROM adh_file WHERE ROWID = ? FOR UPDATE NOWAIT "
    DECLARE q200_cl CURSOR FROM g_forupd_sql

   #UI
       LET p_row = 3 LET p_col = 2

    OPEN WINDOW q200_w AT p_row,p_col
        WITH FORM "axd/42f/axdq200"
               ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()

#      IF cl_chk_act_auth() THEN
#       CALL q200_q()
#    END IF

    CALL q200_menu()    #中文
    CLOSE WINDOW q200_w
      CALL  cl_used(g_prog,g_time,2)      #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

#QBE 查詢資料
FUNCTION q200_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No:FUN-580031  HCN
    CLEAR FORM
   CALL g_adi.clear()

    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
       LET g_wc = " adh01 = '",g_argv1,"'"
    ELSE
       CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

   INITIALIZE g_adh.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON
            adh00,adh01,adh06,adhpost,adhuser,
            adhgrup,adhmodu,adhdate

           #No:FUN-580031 --start--     HCN
           BEFORE CONSTRUCT
               CALL cl_qbe_init()
           #No:FUN-580031 --end--       HCN

           ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT

           #No:FUN-580031 --start--     HCN
           ON ACTION qbe_select
               CALL cl_qbe_list() RETURNING lc_qbe_sn
               CALL cl_qbe_display_condition(lc_qbe_sn)
           #No:FUN-580031 --end--       HCN
 
           ON ACTION about         #MOD-4C0121
              CALL cl_about()      #MOD-4C0121
 
           ON ACTION help          #MOD-4C0121
              CALL cl_show_help()  #MOD-4C0121
 
           ON ACTION controlg      #MOD-4C0121
              CALL cl_cmdask()     #MOD-4C0121
 
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
    END IF
 
    IF g_priv2='4' THEN
       LET g_wc = g_wc clipped," AND adhuser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN
       LET g_wc = g_wc clipped," AND adhgrup MATCHES '",g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       LET g_wc = g_wc clipped," AND adhgrup IN ",cl_chk_tgrup_list()
    END IF


    CONSTRUCT g_wc2 ON adi02,adi05,adi08,adi06,
                       adi07,adi03,adi04,adi09,
                       adi10,adi11,adi12,adi13,adi14
         FROM s_adi[1].adi02,s_adi[1].adi05,s_adi[1].adi08,
              s_adi[1].adi06,s_adi[1].adi07,s_adi[1].adi03,
              s_adi[1].adi04,s_adi[1].adi09,s_adi[1].adi10,
              s_adi[1].adi11,s_adi[1].adi12,s_adi[1].adi13,
              s_adi[1].adi14

      #No:FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No:FUN-580031 --end--       HCN

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      #No:FUN-580031 --start--     HCN
          ON ACTION qbe_save
             CALL cl_qbe_save()
      #No:FUN-580031 --end--       HCN
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    IF g_wc2 = " 1=1" THEN
       LET g_sql = "SELECT ROWID, adh01 FROM adh_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY adh01"
    ELSE			
       LET g_sql = "SELECT UNIQUE adh_file.ROWID, adh01 ",
                   "  FROM adh_file, adi_file ",
                   " WHERE adh01 = adi01",
                   "   AND ", g_wc CLIPPED,
                   "   AND ",g_wc2 CLIPPED,
                   " ORDER BY adh01"
    END IF

    PREPARE q200_prepare FROM g_sql
    DECLARE q200_cs
        SCROLL CURSOR WITH HOLD FOR q200_prepare

    IF g_wc2 = " 1=1" THEN
        LET g_sql="SELECT COUNT(*) FROM adh_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT adh01) ",
                  "  FROM adh_file,adi_file ",
                  " WHERE adi01=adh01 ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED
    END IF
    PREPARE q200_precount FROM g_sql
    DECLARE q200_count CURSOR FOR q200_precount
--## 2004/02/06 by Hiko : 為了上下筆資料所做的設定.
   OPEN q200_count
   FETCH q200_count INTO g_row_count
   CLOSE q200_count
END FUNCTION

FUNCTION q200_menu()
   WHILE TRUE
      CALL q200_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q200_q()
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

FUNCTION q200_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q200_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_adh.* TO NULL
        RETURN
    END IF
        OPEN q200_count
        FETCH q200_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q200_cs
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_adh.* TO NULL
    ELSE
        CALL q200_fetch('F')
    END IF
END FUNCTION


FUNCTION q200_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(1)
    l_abso          LIKE type_file.num10         #No.FUN-680108 INTEGER

    CASE p_flag
        WHEN 'N' FETCH NEXT     q200_cs INTO g_adh_rowid,g_adh.adh01
        WHEN 'P' FETCH PREVIOUS q200_cs INTO g_adh_rowid,g_adh.adh01
        WHEN 'F' FETCH FIRST    q200_cs INTO g_adh_rowid,g_adh.adh01
        WHEN 'L' FETCH LAST     q200_cs INTO g_adh_rowid,g_adh.adh01
        WHEN '/'
            IF (NOT mi_no_ask) THEN   #No.FUN-6A0078
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump
#             PROMPT g_msg CLIPPED,': ' FOR l_abso
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
            END IF
            FETCH ABSOLUTE g_jump q200_cs INTO g_adh_rowid,g_adh.adh01
            LET mi_no_ask = FALSE   #No.FUN-6A0078
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adh.adh01,SQLCA.sqlcode,0)
        RETURN
    END IF
    SELECT * INTO g_adh.* FROM adh_file WHERE ROWID = g_adh_rowid
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adh.adh01,SQLCA.sqlcode,0)
        INITIALIZE g_adh.* TO NULL
        RETURN
    ELSE                                    #FUN-4C0052權限控管
       LET g_data_owner=g_adh.adhuser
       LET g_data_group=g_adh.adhgrup
    END IF
      CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL q200_show()
END FUNCTION


FUNCTION q200_show()
    LET g_adh_t.* = g_adh.*
    DISPLAY BY NAME
        g_adh.adh00,g_adh.adh01,g_adh.adh06,g_adh.adhpost,
        g_adh.adhuser,g_adh.adhgrup,g_adh.adhmodu,
        g_adh.adhdate
    CALL q200_adh00()
    CALL q200_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION


FUNCTION q200_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

    CONSTRUCT l_wc2 ON adi02,adi05,adi08,adi06,adi07,
                       adi03,adi04,adi09,adi10,adi11,
                       adi12,adi13,adi14
            FROM s_adi[1].adi02,s_adi[1].adi05,s_adi[1].adi08,
                 s_adi[1].adi06,s_adi[1].adi07,s_adi[1].adi03,
                 s_adi[1].adi04,s_adi[1].adi09,s_adi[1].adi10,
                 s_adi[1].adi11,s_adi[1].adi12,s_adi[1].adi13,
                 s_adi[1].adi14

       #No:FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No:FUN-580031 --end--       HCN

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       #No:FUN-580031 --start--     HCN
       ON ACTION qbe_select
          CALL cl_qbe_select()
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No:FUN-580031 --end--       HCN
     END CONSTRUCT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL q200_b_fill(l_wc2)
END FUNCTION

FUNCTION q200_b_fill(p_wc2)
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

    LET g_sql =
        "SELECT adi02,adi05,adi08,adi06,adi07,",
        "       adi03,adi04,adi09,adi10,adi11,",
        "       adi12,adi13,adi14",
        "  FROM adi_file",
        " WHERE adi01 ='",g_adh.adh01,"'",
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY adi02"
    PREPARE q200_pb FROM g_sql
    DECLARE adi_cs
        CURSOR FOR q200_pb

    LET g_cnt = 1
    FOREACH adi_cs INTO g_adi[g_cnt].*
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
    CALL g_adi.deleteElement(g_cnt)
    CALL SET_COUNT(g_cnt-1)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)


   IF p_ud <> "G" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adi TO s_adi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION previous
         CALL q200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION jump
         CALL q200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION next
         CALL q200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION last
         CALL q200_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST


      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

   ON ACTION accept
      LET l_ac = ARR_CURR()
      EXIT DISPLAY

   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY

   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION q200_adh00()
 DEFINE gmsg LIKE ze_file.ze03 #No.FUN-680108 VARCHAR(8)
 CASE g_adh.adh00
     WHEN '1' LET  gmsg = cl_getmsg('axd-082',g_lang)
     WHEN '2' LET  gmsg = cl_getmsg('axd-083',g_lang)
     WHEN '3' LET  gmsg = cl_getmsg('axd-084',g_lang)
 END CASE
DISPLAY gmsg TO FORMONLY.e
END FUNCTION
#Patch....NO:TQC-610037 <001> #
