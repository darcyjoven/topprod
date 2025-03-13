# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asfq130.4gl
# Descriptions...: 工單排程查詢
# Date & Author..: 94/07/18 By Danny
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.MOD-530852 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: NO.FUN-560254 05/06/29 By Carol run shell 產生的問題
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-D70076 13/07/23 By qirl 增加部門名稱，部門、工單編號、料件編號欄位的開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
      g_wc             string,  #No.FUN-580092 HCN
    g_sort_flag      LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    g_sfb DYNAMIC ARRAY OF RECORD
            sfb82   LIKE  sfb_file.sfb82,
            gem02   LIKE  gem_file.gem02,   #TQC-D70076 add
            sfb01   LIKE  sfb_file.sfb01,
            sfb25   LIKE  sfb_file.sfb25,
            sfb13   LIKE  sfb_file.sfb13,
            sfb15   LIKE  sfb_file.sfb15,
            sfb05   LIKE  sfb_file.sfb05,
            ima02   LIKE  ima_file.ima02,
            ima021  LIKE  ima_file.ima021,
            sfb08   LIKE  sfb_file.sfb08
        END RECORD,
    g_query_flag    LIKE type_file.num5,          #No.FUN-680121 SMALLINT#第一次進入程式時即進入Query之後進入next
     g_sql          string, #WHERE CONDITION      #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,          #單身筆數               #FUN-560254        #No.FUN-680121 SMALLINT
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT    #FUN-560254        #No.FUN-680121 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
 
MAIN
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
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
   LET g_sort_flag='1'
   LET g_query_flag=1
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW q130_w AT p_row,p_col
       WITH FORM "asf/42f/asfq130"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q130_q()
#    END IF
    CALL q130_menu()
    CLOSE WINDOW q130_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
END MAIN
 
FUNCTION q130_menu()
 
   WHILE TRUE
      CALL q130_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q130_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "排序"
         WHEN "sort"
            CALL q130_sort()
#FUN-4B0011
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfb),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q130_q()
    CALL cl_opmsg('q')
    MESSAGE " "
    CALL q130_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE ' WAIT '
    CALL q130_show()
    MESSAGE " "
END FUNCTION
 
#QBE 查詢資料
FUNCTION q130_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680121 SMALLINT
           CLEAR FORM #清除畫面
           CALL g_sfb.clear()
           CALL cl_opmsg('q')
           LET g_wc=''
           CONSTRUCT g_wc ON sfb82,gem02,sfb01,sfb25,sfb13,sfb15,sfb05 FROM       #TQC-D70076--add gem02
                   s_sfb[1].sfb82,s_sfb[1].gem02,s_sfb[1].sfb01,s_sfb[1].sfb25,   #TQC-D70076--add gem02
	           s_sfb[1].sfb13,s_sfb[1].sfb15,s_sfb[1].sfb05
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE CONSTRUCT
 
          #TQC-D70076--add--star--
              ON ACTION CONTROLP
                 CASE
                   WHEN INFIELD(sfb82)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form     = "q_sfb82"
                        LET g_qryparam.state    = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO sfb82
                        NEXT FIELD sfb82
                   WHEN INFIELD(sfb01)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form     = "q_sfb01_1"
                        LET g_qryparam.state    = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO sfb01
                        NEXT FIELD sfb01
                   WHEN INFIELD(sfb05)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form     = "q_sfb050"
                        LET g_qryparam.state    = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO sfb05
                        NEXT FIELD sfb05
                 END CASE
          #TQC-D70076--add--star--
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
           END CONSTRUCT
           IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
END FUNCTION
 
FUNCTION q130_show()
   CALL q130_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q130_sort()
    OPEN WINDOW q1301_w AT 8,26
         WITH FORM "asf/42f/asfq1301"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("asfq1301")
 
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
    CLOSE WINDOW q1301_w
    CALL q130_show()
END FUNCTION
 
FUNCTION q130_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680121 CAHR(1000)
 
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
 
   LET l_sql =
        "SELECT sfb82,gem02,sfb01,sfb25,sfb13,sfb15,sfb05,ima02,ima021, ",   #TQC-D70076--add gem02
        " sfb08-(sfb09+sfb10+sfb11+sfb12) ",
        " FROM  gem_file,sfb_file,OUTER ima_file ",                            #TQC-D70076--add gem_file
        " WHERE sfb04 != '8' AND sfb87!='X' AND sfb82=gem01 AND ima_file.ima01 = sfb_file.sfb05  AND ", g_wc CLIPPED
 #TQC-D70076--add  sfb82=gem01
   CASE g_sort_flag
     WHEN '1'
       LET l_sql=l_sql CLIPPED," ORDER BY sfb01"
     WHEN '2'
       LET l_sql=l_sql CLIPPED," ORDER BY sfb25"
     WHEN '3'
       LET l_sql=l_sql CLIPPED," ORDER BY sfb13"
     WHEN '4'
       LET l_sql=l_sql CLIPPED," ORDER BY sfb15"
     WHEN '5'
       LET l_sql=l_sql CLIPPED," ORDER BY sfb05"
  END CASE
    DISPLAY l_sql
 
    PREPARE q130_pb FROM l_sql
    DECLARE q130_bcs                       #BODY CURSOR
        CURSOR FOR q130_pb
 
    FOR g_cnt = 1 TO g_sfb.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_sfb[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q130_bcs INTO g_sfb[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_sfb[g_cnt].sfb08 IS NULL THEN
  	       LET g_sfb[g_cnt].sfb08 = 0
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q130_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfb TO s_sfb.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 排序
#     ON ACTION sort
#        LET g_action_choice="sort"
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
#FUN-4B0011
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
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
