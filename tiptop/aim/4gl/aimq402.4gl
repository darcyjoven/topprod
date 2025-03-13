# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aimq402
# Descriptions...: 料件數量查詢
# Date & Author..: 91/11/08 By Carol
#                  By Melody    'OM 備製量'欄位拿掉
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: 05/03/29 No.FUN-530065 By Will 增加料件的開窗
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/23 By vealxu ima26x 調整
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-D10015 13/01/05 By zhangll 開啟時不自動查詢數據
# Modify.........: No.MOD-DA0062 13/10/11 By fengmy 料件開窗當掉 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
        g_ima       DYNAMIC ARRAY OF RECORD
                    ima01   LIKE ima_file.ima01,
                    ima02   LIKE ima_file.ima02,
                    ima021  LIKE ima_file.ima021,
                    ima25   LIKE ima_file.ima25,
#                   ima262  LIKE ima_file.ima262,   #FUN-A20044
#                   avli    LIKE ima_file.ima262,   #FUN-A20044
                    avl_stk LIKE type_file.num15_3, #FUN-A20044
                    avli    LIKE type_file.num15_3, #FUN-A20044  
                    ima05   LIKE ima_file.ima05,
                    ima08   LIKE ima_file.ima08,
                    ima06   LIKE ima_file.ima06,
                    ima07   LIKE ima_file.ima07
                    END RECORD,
        g_argv1     LIKE ima_file.ima01,    # INPUT ARGUMENT - 1
        g_ima01     LIKE ima_file.ima01,    # 所要查詢的key
        g_wc        string,                 #No.FUN-580092 HCN
        g_sql       string,                 #No.FUN-580092 HCN
        l_ac        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        g_rec_b     LIKE type_file.num5     #No.FUN-690026 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5     #No.FUN-690026 SMALLINT
DEFINE g_cnt        LIKE type_file.num10    #No.FUN-690026 INTEGER
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0074
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
 
    IF g_sma.sma12 ='N' THEN
       CALL cl_err('','mfg1319',0)
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
    LET g_argv1      = ARG_VAL(1)          #參數值(1)
    LET p_row = 4 LET p_col = 2
 
    OPEN WINDOW q402_w AT p_row,p_col
         WITH FORM "aim/42f/aimq402"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    LET g_wc = ' 1=1'
    CLEAR FORM				# 清除原欄位資料
    CALL g_ima.clear()
    IF NOT cl_null(g_argv1) THEN   #FUN-D10015 add
       CALL q402_bf()
    END IF    #FUN-D10015 add
    IF cl_null(g_argv1) THEN
        CALL q402_menu()
    ELSE
        CALL q402_q()
        CALL q402_bp("G")
    END IF
    CLOSE WINDOW q402_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
FUNCTION q402_bf()              #BODY FILL UP
   DEFINE l_avl_stk_mpsmrp   LIKE type_file.num15_3,      #FUN-A2004
          l_unavl_stk        LIKE type_file.num15_3,      #FUN-A2004
          l_avl_stk          LIKE type_file.num15_3       #FUN-A2004
 
    LET g_sql =
#       "SELECT ima01, ima02, ima021, ima25, ima262, 0, ima05, ima08,",   #FUN-A20044
        "SELECT ima01, ima02, ima021, ima25,'', 0, ima05, ima08,",        #FUN-A20044
        "       ima06, ima07 ",
        " FROM  ima_file",
        " WHERE ",g_wc CLIPPED
    IF NOT cl_null(g_argv1) THEN
        LET g_sql = g_sql CLIPPED," AND ima01 ='",g_ima01,"'"
    END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY ima01"
    PREPARE q402_pb FROM g_sql
    DECLARE ima_curs                      #SCROLL CURSOR
        CURSOR FOR q402_pb
 
    FOR g_cnt = 1 TO g_ima.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_ima[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH ima_curs INTO g_ima[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#{@}計算 可用量
#No.FUN-A20044 ---start---
        IF NOT cl_null(g_argv1) THEN
           CALL s_getstock(g_ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk
        ELSE
           CALL s_getstock(g_ima[g_cnt].ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk
        END IF 
        LET g_ima[g_cnt].avl_stk = l_avl_stk
#No.FUN-A20044---end---
#       LET g_ima[g_cnt].avli = g_ima[g_cnt].ima262       #FUN-A20044
        LET g_ima[g_cnt].avli = g_ima[g_cnt].avl_stk      #FUN-A20044
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
END FUNCTION
 
FUNCTION q402_bp(p_ud)
 
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ima TO s_ima.*  ATTRIBUTE(COUNT=g_rec_b)
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
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
 
FUNCTION q402_menu()
   WHILE TRUE
      CALL q402_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q402_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ima),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
FUNCTION q402_q()
       LET g_ima01 = ' '
       IF cl_null(g_argv1) THEN
           CLEAR FORM
           CALL g_ima.clear()
           CALL cl_opmsg('q')
           MESSAGE ""
	   CONSTRUCT g_wc ON ima01,ima02,ima021
                FROM s_ima[1].ima01,s_ima[1].ima02,s_ima[1].ima021
 
               #FUN-530065
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
                ON ACTION CONTROLP
                   CASE
                       WHEN INFIELD(ima01)
                            CALL cl_init_qry_var()
                            LET g_qryparam.form = "q_ima"
                            LET g_qryparam.state = "c"
                           #LET g_qryparam.default1 = g_ima[l_ac].ima01         #MOD-DA0062 mark
                            CALL cl_create_qry() RETURNING g_qryparam.multiret
                           #DISPLAY g_qryparam.multiret TO s_ima[l_ac].ima01    #MOD-DA0062 mark
                            DISPLAY g_qryparam.multiret TO s_ima[1].ima01       #MOD-DA0062
                            NEXT FIELD ima01
                  OTHERWISE
                       EXIT CASE
                  END CASE
               #FUN-530065
 
               ON ACTION locale
                   CALL cl_dynamic_locale()
                   CALL cl_show_fld_cont()   #FUN-550037(smin)
               ON ACTION exit
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
                  EXIT PROGRAM
 
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
       ELSE
           LET g_ima01 = g_argv1
           DISPLAY g_ima01 TO ima01
       END IF
       IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
       CALL q402_bf()
END FUNCTION
