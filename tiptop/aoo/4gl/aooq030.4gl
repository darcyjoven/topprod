# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aooq030.4gl
# Descriptions...: 系統重要資料修改記錄查詢
# Date & Author..: 94/02/23 By Roger
# Modify.........: No.FUN-4B0020 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.MOD-530852 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-920082 09/02/25 By zhaijie修改資料筆數顯示問題
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
	tm RECORD 
        a  LIKE type_file.chr1           #No.FUN-680102CHAR(01)
    END RECORD,
    g_azo DYNAMIC ARRAY OF RECORD
          azo01    LIKE azo_file.azo01,
          azo02    LIKE azo_file.azo02,
          azo03    LIKE azo_file.azo03,
          azo04    LIKE azo_file.azo04,
          azo05    LIKE azo_file.azo05,
          azo06    LIKE azo_file.azo06 
        END RECORD,
            #No.FUN-680102 INT # saki 20070821 rowid chr18 -> num10 
    g_wc,g_sql      STRING,                       #WHERE CONDITION      #No.FUN-580092 HCN  
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
DEFINE   g_cnt      LIKE type_file.num10            #No.FUN-680102 INTEGER
DEFINE   g_rec_b    LIKE type_file.num10            #No.TQC-920082
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0081
 
   OPEN WINDOW q030_w WITH FORM "aoo/42f/aooq030" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
 
   LET tm.a = '1'
   CALL q030_menu()
 
   CLOSE WINDOW q030_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0081
END MAIN
 
#QBE 查詢資料
FUNCTION q030_cs()
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680102 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_azo.clear()
   CALL cl_opmsg('q')
   CONSTRUCT g_wc ON azo01,azo02,azo03,azo04,azo05,azo06
       FROM  s_azo[1].azo01,s_azo[1].azo02,s_azo[1].azo03,
             s_azo[1].azo04,s_azo[1].azo05,s_azo[1].azo06 
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
 
   MESSAGE ' WAIT ' 
   LET g_sql=" SELECT azo_file.* FROM azo_file ",
             " WHERE ",g_wc CLIPPED 
   CASE tm.a 
	    WHEN '1' LET g_sql = g_sql CLIPPED, " ORDER BY azo03,azo04" 
		WHEN '2' LET g_sql = g_sql CLIPPED, " ORDER BY azo05,azo03,azo04"
	    WHEN '3' LET g_sql = g_sql CLIPPED, " ORDER BY azo01,azo03,azo04"
	    WHEN '4' LET g_sql = g_sql CLIPPED, " ORDER BY azo01,azo05"
   OTHERWISE EXIT CASE
   END CASE
   PREPARE q030_prepare FROM g_sql
   DECLARE q030_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR q030_prepare
 
END FUNCTION
 
#中文的MENU
 
FUNCTION q030_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       #No.FUN-680102CHAR(80)
 
 
 
   WHILE TRUE
      CALL q030_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q030_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
        #WHEN "設定排序" 
#        WHEN "sequence" 
#           IF cl_chk_act_auth() THEN
#             	   CALL q030_s()
#           END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_azo),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q030_q()
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL q030_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    END IF
	MESSAGE ''
    CALL q030_b_fill()
END FUNCTION
 
FUNCTION q030_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680102CHAR(1000)
 
    FOR g_cnt = 1 TO g_azo.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_azo[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    LET g_rec_b = 0                              #TQC-920082
 
    FOREACH q030_cs INTO g_azo[g_cnt].* 
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
        END IF
    END FOREACH
 
    LET g_rec_b = g_cnt-1                 #TQC-920082
    DISPLAY g_rec_b TO FORMONLY.cnt       #TQC-920082
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
END FUNCTION
 
FUNCTION q030_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_azo TO s_azo.*
 
      BEFORE ROW
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
       #No.MOD-530852  --begin                                                   
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
       #No.MOD-530852  --end         
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q030_s()
 
   OPEN WINDOW q030_w1 WITH FORM "aoo/42f/aooq0301" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aooq0301")
 
   INPUT BY NAME tm.a
      AFTER FIELD a
         IF tm.a NOT MATCHES '[1234]' OR cl_null(tm.a) THEN
            LET tm.a = '1'
            DISPLAY BY NAME tm.a
            NEXT FIELD a
         END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END INPUT
   CLOSE WINDOW q030_w1
   CALL q030_q()
END FUNCTION
 
