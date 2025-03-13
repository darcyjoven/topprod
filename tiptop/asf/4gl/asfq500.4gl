# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asfq500.4gl
# Descriptions...: 工單挪料記錄查詢
# Date & Author..: 02/09/02 By Snow
# Modify.........: 03/03/27 By Mandy
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.MOD-530170 05/03/21 By Carol 直接執行此程式時,用滑鼠無法打X離開
# Modify.........: No.MOD-550166 05/05/17 By Carol 不用prompt 輸入->直接畫面選取後顯示
# Modify.........: NO.FUN-560254 05/06/29 By Carol run shell 產生的問題
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/30 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A80035 10/08/06 By sabrina 將畫面type移除
# Modify.........: No:TQC-B60038 11/06/09 By 查詢后資料欄位顯示不正確
# Modify.........: No:MOD-C30239 12/03/15 By lixh1 修改prompt提示信息
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_wc   string,                             #No.FUN-580092 HCN
    g_sort_flag  LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    g_sfm DYNAMIC ARRAY OF RECORD
            sfm00 LIKE sfm_file.sfm00,
            sfm03 LIKE sfm_file.sfm03,
            sfm01 LIKE sfm_file.sfm01,
            sfm07 LIKE sfm_file.sfm07,
            a     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
            sfm10 LIKE sfm_file.sfm10,
           # Prog. Version..: '5.30.06-13.03.12(04)   #MOD-A80035 mark
            sfm08 LIKE sfm_file.sfm08,
            sfm09 LIKE sfm_file.sfm09,
            b     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
            sfm16 LIKE sfm_file.sfm16
        END RECORD,
    g_query_flag    LIKE type_file.num5,        #No.FUN-680121 SMALLINT#第一次進入程式時即進入Query之後進入next料件
     g_sql          string, #WHERE CONDITION    #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,        #單身筆數        #No.FUN-680121 SMALLINT
    l_ac            LIKE type_file.num5,        #目前處理的ARRAY CNT    #FUN-560254        #No.FUN-680121 SMALLINT
    g_za05          LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(40)
DEFINE   p_row,p_col  LIKE type_file.num5       #No.FUN-680121 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(72)
 
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8     #No.FUN-6A0090
 
   OPTIONS                                      #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                             #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)            #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
    LET g_sort_flag='4'
    LET g_query_flag=1
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 6
   ELSE
      LET p_row = 4 LET p_col = 3
   END IF
 OPEN WINDOW q500_w AT p_row,p_col
        WITH FORM "/asf/42f/asfq500"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_ui_locale("frm")
 
 
 
 
 
    #IF cl_chk_act_auth() THEN
    #   CALL q500_q()
    #END IF
    CALL q500_menu()
    CLOSE WINDOW q500_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
END MAIN
 
FUNCTION q500_menu()
 
   WHILE TRUE
      CALL q500_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q500_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "挪料明細"
         WHEN "w_o_item_shifting_list"
            CALL q500_t()
#FUN-4B0011
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfm),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q500_q()
    CALL cl_opmsg('q')
    MESSAGE " "
    CALL q500_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE ' WAIT '
    CALL q500_show()
    MESSAGE " "
END FUNCTION
 
#QBE 查詢資料
FUNCTION q500_cs()
  DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680121 SMALLINT
           CLEAR FORM #清除畫面
   CALL g_sfm.clear()
           CALL cl_opmsg('q')
           LET g_wc=''
  CONSTRUCT g_wc ON sfm00,sfm03,sfm01,sfm07,sfm10,
            sfm08,sfm09,sfm16
       FROM s_sfm[1].sfm00,s_sfm[1].sfm03,s_sfm[1].sfm01,s_sfm[1].sfm07,s_sfm[1].sfm10,
            s_sfm[1].sfm08,s_sfm[1].sfm09,s_sfm[1].sfm16
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
  END CONSTRUCT
  IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
END FUNCTION
 
FUNCTION q500_show()
   CALL q500_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q500_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(800)
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND sfbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
    #End:FUN-980030
 
    LET l_sql =" SELECT sfm00,sfm03,sfm01,sfm07,'',",
#               "        sfm10,'',sfm08,sfm09,'',sfm16",
               "        sfm10,sfm08,sfm09,'',sfm16",  #TQC-B60038
               "   FROM sfm_file",
               "  WHERE ", g_wc CLIPPED,
               "  ORDER BY 1 "
 
    PREPARE q500_pb FROM l_sql
    DECLARE q500_bcs                       #BODY CURSOR
        CURSOR FOR q500_pb
 
    FOR g_cnt = 1 TO g_sfm.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_sfm[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q500_bcs INTO g_sfm[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
     #MOD-A80035---mark---start---
     #CASE g_sfm[g_cnt].sfm10  #工單型態
     #  WHEN '1' LET g_sfm[g_cnt].typ  =g_x[2] CLIPPED #'整批'
     #  WHEN '2' LET g_sfm[g_cnt].typ  =g_x[3] CLIPPED #'單料'
     #  WHEN '3' LET g_sfm[g_cnt].typ  =g_x[4] CLIPPED #'工單'
     #END CASE
     #MOD-A80035---mark---end---
      #來源工單過帳否
      SELECT sfp04 INTO g_sfm[g_cnt].a FROM sfp_file
       WHERE sfp01=g_sfm[g_cnt].sfm07
      #目的工單過帳否
      SELECT sfp04 INTO g_sfm[g_cnt].b FROM sfp_file
       WHERE sfp01=g_sfm[g_cnt].sfm09
 
      #過帳否選擇
      CASE g_sort_flag
        WHEN '1' #過帳
          IF (g_sfm[g_cnt].a='N' OR g_sfm[g_cnt].b='N') OR
             (g_sfm[g_cnt].a='N' AND cl_null(g_sfm[g_cnt].b)) OR
             (cl_null(g_sfm[g_cnt].a) AND g_sfm[g_cnt].b='N') OR
             (g_sfm[g_cnt].a='X' OR g_sfm[g_cnt].b='X') OR
             (g_sfm[g_cnt].a='X' AND cl_null(g_sfm[g_cnt].b)) OR
             (cl_null(g_sfm[g_cnt].a) AND g_sfm[g_cnt].b='X') THEN
             CONTINUE FOREACH
          END IF
        WHEN '2' #未過帳
          IF (g_sfm[g_cnt].a='Y' OR g_sfm[g_cnt].b='Y') OR
             (g_sfm[g_cnt].a='Y' AND cl_null(g_sfm[g_cnt].b)) OR
             (cl_null(g_sfm[g_cnt].a) AND g_sfm[g_cnt].b='Y') OR
             (g_sfm[g_cnt].a='X' OR g_sfm[g_cnt].b='X') OR
             (g_sfm[g_cnt].a='X' AND cl_null(g_sfm[g_cnt].b)) OR
             (cl_null(g_sfm[g_cnt].a) AND g_sfm[g_cnt].b='X') THEN
             CONTINUE FOREACH
          END IF
        WHEN '3' #作廢
          IF (g_sfm[g_cnt].a='Y' OR g_sfm[g_cnt].b='Y') OR
             (g_sfm[g_cnt].a='Y' AND cl_null(g_sfm[g_cnt].b)) OR
             (cl_null(g_sfm[g_cnt].a) AND g_sfm[g_cnt].b='Y') OR
             (g_sfm[g_cnt].a='N' OR g_sfm[g_cnt].b='N') OR
             (g_sfm[g_cnt].a='N' AND cl_null(g_sfm[g_cnt].b)) OR
             (cl_null(g_sfm[g_cnt].a) AND g_sfm[g_cnt].b='N') THEN
             CONTINUE FOREACH
          END IF
 
      END CASE
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfm TO s_sfm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
#FUN-560254-modify
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#FUN-560254-end
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
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
 
 #MOD-530170
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
##
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 挪料明細
      ON ACTION w_o_item_shifting_list
         LET g_action_choice="w_o_item_shifting_list"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
#FUN-4B0011
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q500_t()
  DEFINE l_a LIKE type_file.chr8        # Prog. Version..: '5.30.06-13.03.12(08) # TQC-6A0079
  DEFINE l_msg    STRING                #MOD-C30239  
 
            LET INT_FLAG = 0  ######add for prompt bug
# PROMPT g_x[1] CLIPPED FOR l_a   #MOD-C30239 mark
  CALL cl_getmsg('asf-275',g_lang) RETURNING l_msg   #MOD-C30239
  PROMPT l_msg CLIPPED,': ' FOR l_a                  #MOD-C30239
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
#        CONTINUE PROMPT
 
  END PROMPT
  IF NOT cl_null(l_a) THEN
     LET g_msg='asfq501 "',l_a,'"'
     CALL cl_cmdrun(g_msg)
  END IF
 
END FUNCTION
 
 
