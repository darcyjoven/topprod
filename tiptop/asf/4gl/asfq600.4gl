# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: asfq600.4gl
# Descriptions...: 工單完工查詢
# Date & Author..: 02/10/03 By nicola
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.MOD-530170 05/03/21 By Carol 直接執行此程式時,用滑鼠無法打X離開
# Modify.........: NO.FUN-560254 05/06/29 By Carol run shell 產生的問題
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-840234 08/07/29 By sherry 增加工單狀態
# Modify.........: No.FUN-860050 08/08/19 By sherry 增加報工量欄位
# Modify.........: No.FUN-910053 09/02/12 By jan sma74-->ima153
# Modify.........: No.MOD-940040 09/05/25 By Pengu 報工量應排除已報廢與未確認的數量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A60027 10/06/18 by sunchenxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:MOD-A60088 10/06/14 By Sarah 將l_sql裡sfb87='Y'條件改為sfb87!='X'
# Modify.........: No:MOD-9C0432 10/11/25 By sabrina 報工數量應考慮製程報工量
# Modify.........: No:MOD-B10221 11/02/08 By sabrina 將qi 改為LIKE sfb08
# Modify.........: No:FUN-C70037 12/08/16 By lixh1 CALL s_minp增加傳入日期參數
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
     g_wc             string,  #No.FUN-580092 HCN
   g_sort_flag      LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
   g_sfb DYNAMIC ARRAY OF RECORD
      sfb82         LIKE  sfb_file.sfb82,
      sfb01         LIKE  sfb_file.sfb01,
      sfb04         LIKE  sfb_file.sfb04, #FUN-840234
      sfb13         LIKE  sfb_file.sfb13,
      sfb15         LIKE  sfb_file.sfb15,
      sfb36         LIKE  sfb_file.sfb36, #FUN-840234
      sfb05         LIKE  sfb_file.sfb05,
      sfb08         LIKE  sfb_file.sfb08,
      sfb09         LIKE  sfb_file.sfb08,
      srg           LIKE  srg_file.srg05,   #No.FUN-860050
     #qi            LIKE type_file.num10,         #No.FUN-680121 INTEGER   #MOD-B10221 mark
      qi            LIKE sfb_file.sfb08,          #MOD-B10221 add 
      qp            LIKE type_file.num5,          #No.FUN-680121 SMALLINT
      s9p           LIKE type_file.num5           #No.FUN-680121 SMALLINT
   END RECORD,
    g_sql            string,                                 #WHERE CONDITION  #No.FUN-580092 HCN
   g_rec_b          LIKE type_file.num5,    #單身筆數        #No.FUN-680121 SMALLINT
   l_ac             LIKE type_file.num5     #目前處理的ARRAY CNT    #FUN-560254        #No.FUN-680121 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
 
 
MAIN
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
   OPTIONS                                    #改變一些系統預設值
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
   LET g_sort_flag='1'
 
   LET p_row = 2 LET p_col = 5
 
   OPEN WINDOW q600_w AT p_row,p_col
        WITH FORM "asf/42f/asfq600"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
 
 
#   IF cl_chk_act_auth() THEN
#      CALL q600_q()
#   END IF
 
   CALL q600_menu()
 
   CLOSE WINDOW q600_w
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
END MAIN
 
FUNCTION q600_menu()
 
   WHILE TRUE
      CALL q600_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q600_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "排序"
         #WHEN "sort"
         #   CALL q600_sort()
#FUN-4B0011
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfb),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
FUNCTION q600_q()
   CALL cl_opmsg('q')
   MESSAGE " "
   CALL q600_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   MESSAGE ' WAIT '
   CALL q600_show()
   MESSAGE " "
END FUNCTION
 
#QBE 查詢資料
FUNCTION q600_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_sfb.clear()
   CALL cl_opmsg('q')
   LET g_wc=''
   CONSTRUCT g_wc ON sfb82,sfb01,sfb04,sfb13,sfb15,sfb36,sfb05,sfb08,sfb09 FROM #FUN-840234
             s_sfb[1].sfb82,s_sfb[1].sfb01,s_sfb[1].sfb04,s_sfb[1].sfb13, #CHI-870025
             s_sfb[1].sfb15,s_sfb[1].sfb36,s_sfb[1].sfb05,s_sfb[1].sfb08,s_sfb[1].sfb09 #CHI-870025
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
 
FUNCTION q600_show()
   CALL q600_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q600_sort()
 
   OPEN WINDOW q6001_w AT 8,26 WITH FORM "asf/42f/asfq6001"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("asfq6001")
 
 
   INPUT g_sort_flag WITHOUT DEFAULTS FROM s
      AFTER FIELD s
      IF cl_null(g_sort_flag) OR (g_sort_flag NOT MATCHES '[1,2,3,4,5]')
         THEN NEXT FIELD s
      END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   CLOSE WINDOW q6001_w
   CALL q600_show()
END FUNCTION
 
FUNCTION q600_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,      #No.FUN-680121 VARCHAR(1000)
          l_cnt     LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DEFINE l_srg05   LIKE srg_file.srg05          #No.FUN-860050  
   DEFINE l_sfb93   LIKE sfb_file.sfb93          #No:MOD-9C0432 add
   DEFINE  l_ima153     LIKE ima_file.ima153   #FUN-910053 
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                            # 只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND sfbuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                            # 只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT sfb82,sfb01,sfb04,sfb13,sfb15,sfb36,sfb05,sfb08,sfb09,0,0,0,0,sfb93 ", #FUN-840234    #MOD-9C0432 add sfb93
               " FROM  sfb_file",
               " WHERE sfb04 IN ('1','2','3','4','5','6','7','8')",
               "   AND sfb87!='X'",   #MOD-A60088 mod ='Y'->!='X'
               "   AND ", g_wc CLIPPED #FUN-840234
   CASE g_sort_flag
      WHEN '1'
         LET l_sql=l_sql CLIPPED," ORDER BY sfb01"
      WHEN '2'
         LET l_sql=l_sql CLIPPED," ORDER BY sfb82"
      WHEN '3'
         LET l_sql=l_sql CLIPPED," ORDER BY sfb13"
      WHEN '4'
         LET l_sql=l_sql CLIPPED," ORDER BY sfb15"
      WHEN '5'
         LET l_sql=l_sql CLIPPED," ORDER BY sfb05"
   END CASE
 
   PREPARE q600_pb FROM l_sql
   DECLARE q600_bcs                       #BODY CURSOR
        CURSOR FOR q600_pb
 
   FOR g_cnt = 1 TO g_sfb.getLength()           #單身 ARRAY 乾洗
      INITIALIZE g_sfb[g_cnt].* TO NULL
   END FOR
   LET g_rec_b=0
   LET g_cnt = 1
   FOREACH q600_bcs INTO g_sfb[g_cnt].*,l_sfb93  #No:MOD-9C0432 add sfb93
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL s_get_ima153(g_sfb[g_cnt].sfb05) RETURNING l_ima153  #FUN-910053  
     #CALL s_minp(g_sfb[g_cnt].sfb01,g_sma.sma73,g_sma.sma74,'')#FUN-910053
      #CALL s_minp(g_sfb[g_cnt].sfb01,g_sma.sma73,l_ima153,'')   #FUN-910053
     #CALL s_minp(g_sfb[g_cnt].sfb01,g_sma.sma73,l_ima153,'','','')   #FUN-A60027 #FUN-C70037 mark
      CALL s_minp(g_sfb[g_cnt].sfb01,g_sma.sma73,l_ima153,'','','','')       #FUN-C70037 
           RETURNING l_cnt,g_sfb[g_cnt].qi
 
      IF g_sfb[g_cnt].qi = 0 THEN
         LET g_sfb[g_cnt].qp = 0
      ELSE
         LET g_sfb[g_cnt].qp = g_sfb[g_cnt].sfb09 / g_sfb[g_cnt].qi * 100
      END IF
      IF g_sfb[g_cnt].sfb08 = 0 THEN
         LET g_sfb[g_cnt].s9p = 0
      ELSE
         LET g_sfb[g_cnt].s9p = g_sfb[g_cnt].sfb09 / g_sfb[g_cnt].sfb08 * 100
      END IF
      #No.FUN-860050---Begin
      LET g_sfb[g_cnt].srg = 0
     #--------------No:MOD-9C0432 add
      IF l_sfb93 = 'Y' THEN
         SELECT SUM(ecm311+ecm315) INTO g_sfb[g_cnt].srg FROM ecm_file
                WHERE ecm01 = g_sfb[g_cnt].sfb01
                  AND ecm03 = (SELECT MAX(ecm03) FROM ecm_file 
                                  WHERE ecm01 = g_sfb[g_cnt].sfb01)
         IF cl_null(g_sfb[g_cnt].srg) THEN LET g_sfb[g_cnt].srg= 0 END IF
      ELSE
     #--------------No:MOD-9C0432 end
        #---------------No.MOD-940040 modify
        #LET g_sql= " SELECT srg05 FROM srg_file  ",
        #           "  WHERE srg16 = '",g_sfb[g_cnt].sfb01,"'"
         LET g_sql= " SELECT srg05 FROM srg_file,srf_file  ",
                    "  WHERE srg16 = '",g_sfb[g_cnt].sfb01,"'",
                    "    AND srg01 = srf01 ",
                    "    AND srfconf = 'Y' "
        #---------------No.MOD-940040 end
         PREPARE q600_srg FROM g_sql
         DECLARE q600_bcs1 CURSOR FOR q600_srg
         FOREACH q600_bcs1 INTO l_srg05
            IF SQLCA.sqlcode THEN
               CALL cl_err('Foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            IF cl_null(l_srg05) THEN
               LET l_srg05 = 0 
            END IF
            LET g_sfb[g_cnt].srg = g_sfb[g_cnt].srg + l_srg05
         END FOREACH
      END IF       #MOD-9C0432 add
      #No.FUN-860050---End
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
#FUN-560254-modify
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      #@ON ACTION 排序
      #ON ACTION sort
      #   LET g_action_choice="sort"
      #   EXIT DISPLAY
 
 
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
