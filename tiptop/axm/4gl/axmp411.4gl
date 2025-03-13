# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmp411.4gl
# Descriptions...: 訂單排定交期修改作業
# Date & Author..: 95/01/23 By Roger
# Modify.........: No:7576 03/09/01 Carol 廠/倉輸入後無檢查正確性
#                                         --> add check 廠/倉/儲 資料正確性
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530688 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.MOD-570236 05/07/27 By Nicola CONSTRUCT順序修改
# Modify.........: NO.MOD-570259 05/07/22 By Yiting g_sql 條件應再加上 tm.wc2
# Modify.........: No.MOD-570253 05/08/12 By Rosayu oeb08=>no use
# Modify.........: No.MOD-590132 05/09/09 By kim 修正MOD-570253的錯誤
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-690103 06/11/15 By pengu 已結案S/O應不可修改交貨日期
# Modify.........: No.FUN-6A0092 06/11/27 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0075 06/12/13 By pengu 第一項結案後，第二項就無法排交日修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-730118 07/03/26 By wujie 報不存在的倉儲位，但按退出鍵仍能保存
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-AA0048 10/10/26 By Carrier GP5.2架构下仓库权限修改
# Modify.........: No:TQC-C60075 12/06/07 By zhuhao 增加規格欄位
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    tm  RECORD
     	wc  	LIKE type_file.chr1000,		# Head Where condition   #No.FUN-680137 VARCHAR(300)
       	wc2  	LIKE type_file.chr1000		# Body Where condition   #No.FUN-680137 VARCHAR(300)
        END RECORD,
    g_oea   RECORD
            oea01   LIKE oea_file.oea01,  
            oea02   LIKE oea_file.oea02,  
            oea03   LIKE oea_file.oea03,  
            oea04   LIKE oea_file.oea04,  
            oea032  LIKE oea_file.oea032,  
            occ02   LIKE occ_file.occ02,  
            oea14   LIKE oea_file.oea14,  
            oea15   LIKE oea_file.oea15,  
            oeaconf LIKE oea_file.oeaconf,  
            oeahold LIKE oea_file.oeahold
        END RECORD,
    g_oeb DYNAMIC ARRAY OF RECORD
            oeb03   LIKE oeb_file.oeb03,
            oeb04   LIKE oeb_file.oeb04,
            oeb06   LIKE oeb_file.oeb06,
            ima021  LIKE ima_file.ima021,     #No.TQC-C60075
            oeb092  LIKE oeb_file.oeb092,
            oeb05   LIKE oeb_file.oeb05,
            oeb12   LIKE type_file.num10,     #No.FUN-680137 INTEGER
            oeb24   LIKE type_file.num10,     #No.FUN-680137 INTEGER
            oeb25   LIKE type_file.num10,     #No.FUN-680137 INTEGER
            unqty   LIKE type_file.num10,     #No.FUN-680137 INTEGER
            oeb15   LIKE oeb_file.oeb15,
            oeb70   LIKE oeb_file.oeb70,
            #oeb08   LIKE oeb_file.oeb08,     #MOD-570253
            oeb09   LIKE oeb_file.oeb09,
            oeb091  LIKE oeb_file.oeb091,
            oeb16   LIKE oeb_file.oeb16
        END RECORD,
    g_argv1              LIKE oea_file.oea01,
    g_before_input_done  LIKE type_file.num5,    #No.FUN-680137 SMALLINT
    g_query_flag         LIKE type_file.num5,    #第一次進入程式時即進入Query之後進入next  #No.FUN-680137 SMALLINT
     g_wc,g_wc2,g_sql    STRING,  #WHERE CONDITION  #No.FUN-580092 HCN  
    g_rec_b              LIKE type_file.num10    #單身筆數  #No.FUN-680137 INTEGER
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE   l_ac            LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time  

    LET g_query_flag=1
 
    OPEN WINDOW p411_w WITH FORM "axm/42f/axmp411" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL p411_q() END IF
    WHILE TRUE
      LET g_action_choice = ""
      CALL p411_menu()
      IF g_action_choice = 'exit' THEN EXIT WHILE END IF
    END WHILE

    CLOSE WINDOW p411_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION p411_cs()
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
   IF NOT cl_null(g_argv1)
      THEN LET tm.wc = "oea01 = '",g_argv1,"'"
		   LET tm.wc2=" 1=1 "
      ELSE CLEAR FORM #清除畫面
   CALL g_oeb.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_oea.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oea04, 
                                      oea14,oea15,oeaconf,oeahold
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
           
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
           END CONSTRUCT
           LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup') #FUN-980030
           IF INT_FLAG THEN RETURN END IF
           CALL p411_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT ' 
    #MOD-570259-start
   IF tm.wc2=" 1=1 " THEN   #單身無輸入值
       LET g_sql=" SELECT oea01 FROM oea_file ",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND oeaconf != 'X' ", #01/08/16 mandy
                 " ORDER BY oea01"
   ELSE
       LET g_sql=" SELECT  UNIQUE oea01 FROM oea_file,oeb_file ",
                 " WHERE oea01 = oeb01",
                 "   AND ",tm.wc CLIPPED, " AND ",tm.wc2 CLIPPED,
                 "   AND oeaconf != 'X' ", #01/08/16 mandy
                 " ORDER BY oea01"
   END IF
 
   PREPARE p411_prepare FROM g_sql
   DECLARE p411_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR p411_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
    IF tm.wc2=" 1=1 " THEN                      # 取合乎條件筆數
        LET g_sql=" SELECT COUNT(*) FROM oea_file ",
                  " WHERE ",tm.wc CLIPPED,
                  "   AND oeaconf != 'X' "  #01/08/16 mandy
    ELSE
        LET g_sql=" SELECT COUNT(DISTINCT oea01) FROM oea_file,oeb_file ",
                  "  WHERE oea01 = oeb01",
                  "    AND ",tm.wc CLIPPED ,
                  "    AND ",tm.wc2 CLIPPED,
                  "   AND oeaconf != 'X' "  #01/08/16 mandy
    END IF
    #MOD-570259-end
 
#   LET g_sql=" SELECT oea01 FROM oea_file ",
#             " WHERE ",tm.wc CLIPPED,
#             "   AND oeaconf != 'X' ", #01/08/16 mandy
#             " ORDER BY oea01"
#   PREPARE p411_prepare FROM g_sql
#   DECLARE p411_cs                         #SCROLL CURSOR
#           SCROLL CURSOR FOR p411_prepare
#
#   # 取合乎條件筆數
#   #若使用組合鍵值, 則可以使用本方法去得到筆數值
#   LET g_sql=" SELECT COUNT(*) FROM oea_file ",
#             " WHERE ",tm.wc CLIPPED,
#             "   AND oeaconf != 'X' "  #01/08/16 mandy
 
   PREPARE p411_pp  FROM g_sql
   DECLARE p411_cnt   CURSOR FOR p411_pp
END FUNCTION
 
FUNCTION p411_b_askkey()
   CONSTRUCT tm.wc2 ON oeb03,oeb04,oeb06,oeb092,oeb05,oeb12,oeb24,oeb25,unqty,
                        #oeb15,oeb70,oeb08,oeb09,oeb091,oeb16  # MOD-570253
                        oeb15,oeb70,      oeb09,oeb091,oeb16 #MOD-570253
                  FROM s_oeb[1].oeb03,s_oeb[1].oeb04,s_oeb[1].oeb06,
                        s_oeb[1].oeb092,s_oeb[1].oeb05,           #No.MOD-570236
                       s_oeb[1].oeb12,s_oeb[1].oeb24,s_oeb[1].oeb25,
                       s_oeb[1].unqty,s_oeb[1].oeb15,s_oeb[1].oeb70,
                        # s_oeb[1].oeb08,s_oeb[1].oeb09,   # MOD-570253
                                         s_oeb[1].oeb09, #MOD-570253
                       s_oeb[1].oeb091,s_oeb[1].oeb16
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
END FUNCTION
 
#中文的MENU
FUNCTION p411_menu()
   WHILE TRUE
      CALL p411_bp("G")
      CASE g_action_choice
           WHEN "query" 
            IF cl_chk_act_auth() THEN
                CALL p411_q()
            END IF
           WHEN "modify_schedule" 
                 IF cl_chk_act_auth() THEN 
                    CALL p411_b() 
                 END IF
           WHEN "next" 
            CALL p411_fetch('N')
           WHEN "previous" 
            CALL p411_fetch('P')
           WHEN "help" 
            CALL cl_show_help()
           WHEN "exit"
            EXIT WHILE
           WHEN "jump"
            CALL p411_fetch('/')
           WHEN "controlg"  #KEY(CONTROL-G)
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p411_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL p411_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN p411_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN p411_cnt
       FETCH p411_cnt INTO g_row_count
       DISPLAY g_row_count TO cnt  
       CALL p411_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION p411_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680137 VARCHAR(1)
    l_oeauser       LIKE oea_file.oeauser, #FUN-4C0057 add
    l_oeagrup       LIKE oea_file.oeagrup  #FUN-4C0057 add
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     p411_cs INTO g_oea.oea01
        WHEN 'P' FETCH PREVIOUS p411_cs INTO g_oea.oea01
        WHEN 'F' FETCH FIRST    p411_cs INTO g_oea.oea01
        WHEN 'L' FETCH LAST     p411_cs INTO g_oea.oea01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump p411_cs INTO g_oea.oea01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)
        INITIALIZE g_oea.* TO NULL  #TQC-6B0105
        LET g_oea.oea01 = NULL      #TQC-6B0105
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
    SELECT oea01,oea02,oea03,oea04,oea032,'',oea14,oea15,oeaconf,oeahold,
           oeauser,oeagrup                           #FUN-4C0057 modify
      INTO g_oea.*,l_oeauser,l_oeagrup               #FUN-4C0057 modify
      FROM oea_file
     WHERE oea01 = g_oea.oea01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_oea.oea01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","oea_file",g_oea.oea01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660167
       INITIALIZE g_oea.* TO NULL     #FUN-4C0057 add
       RETURN
    END IF
    LET g_data_owner = l_oeauser      #FUN-4C0057 add
    LET g_data_group = l_oeagrup      #FUN-4C0057 add
    CALL p411_show()
END FUNCTION
 
FUNCTION p411_show()
   SELECT occ02 INTO g_oea.occ02 FROM occ_file WHERE occ01=g_oea.oea04
   IF SQLCA.SQLCODE THEN LET g_oea.occ02=' ' END IF
   DISPLAY BY NAME g_oea.*   # 顯示單頭值
   CALL p411_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p411_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(400)
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
        "SELECT oeb03,oeb04,oeb06,ima021,oeb092,oeb05,oeb12,oeb24,oeb25,",    #TQC-C60075 add ima021
        "      (oeb12-oeb24+oeb25-oeb26),oeb15,oeb70,",
         #"       oeb08,oeb09,oeb091,oeb16,' ' ",  #MOD-570253
         "             oeb09,oeb091,oeb16,' ' ", #MOD-570253
        "  FROM oeb_file LEFT OUTER JOIN  ima_file ON oeb04 = ima01",         #TQC-C60075 add
        " WHERE oeb01 = '",g_oea.oea01,"'"," AND ", tm.wc2 CLIPPED,
        " ORDER BY 1"
    PREPARE p411_pb FROM l_sql
    DECLARE p411_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR p411_pb
 
    FOR g_cnt = 1 TO g_oeb.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_oeb[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH p411_bcs INTO g_oeb[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_oeb[g_cnt].oeb12 IS NULL THEN
  	       LET g_oeb[g_cnt].oeb12 = 0 
        END IF
        IF g_oeb[g_cnt].oeb24 IS NULL THEN
  	       LET g_oeb[g_cnt].oeb24 = 0 
        END IF
        IF g_oeb[g_cnt].oeb25 IS NULL THEN
  	       LET g_oeb[g_cnt].oeb25 = 0 
        END IF
        IF g_oeb[g_cnt].unqty IS NULL THEN
  	       LET g_oeb[g_cnt].unqty = 0 
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_oeb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
END FUNCTION
 
FUNCTION p411_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF p_ud <> "G" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION modify_schedule
           LET g_action_choice="modify_schedule" 
           EXIT DISPLAY
 
        ON ACTION query       
           LET g_action_choice="query" 
           EXIT DISPLAY
 
        ON ACTION next
           CALL p411_fetch('N')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        ON ACTION previous
           CALL p411_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        ON ACTION first
           CALL p411_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        ON ACTION last
           CALL p411_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
        ON ACTION jump
           CALL p411_fetch('/')
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
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
      #No.MOD-530688  --begin                                                   
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
      #No.MOD-530688  --end          
       ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
    
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p411_b()
    DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
    DEFINE l_ac,l_sl	   LIKE type_file.num5,      #No.FUN-680137 SMALLINT
           l_sn1,l_sn2     LIKE type_file.num5,      #No.FUN-680137      #No:7576 add  SMALLINT
           l_cnt           LIKE type_file.num5
 
    CALL cl_opmsg('b')
    CALL SET_COUNT(g_rec_b)   #告訴I.單身筆數
    INPUT ARRAY g_oeb WITHOUT DEFAULTS FROM s_oeb.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL p411_set_entry()
            CALL p411_set_no_entry()
            LET g_before_input_done = TRUE
        BEFORE ROW
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3
            LET l_sl = SCR_LINE()
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
        BEFORE FIELD oeb09
           IF g_oeb[l_ac].oeb70= 'N' THEN
              CALL p411_set_entry()
           ELSE
              CALL p411_set_no_entry()
           END IF
 
        AFTER FIELD oeb09
           IF NOT cl_null(g_oeb[l_ac].oeb09) THEN
              IF g_oeb[l_ac].oeb09 = '　' THEN #全型空白
                 LET g_oeb[l_ac].oeb09 = ' '
                 NEXT FIELD oeb09
              END IF
              IF g_oeb[l_ac].oeb70='Y' THEN
                 CALL cl_err('','aap-730',0)
                 CONTINUE INPUT
              END IF
              LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt FROM imd_file
                  WHERE imd01 = g_oeb[l_ac].oeb09
                     AND imdacti = 'Y' 
              IF l_cnt=0 THEN
                 CALL cl_err(g_oeb[l_ac].oeb09,'mfg4020',0)
                 NEXT FIELD oeb09
              END IF
              #No.FUN-AA0048  --Begin
              IF NOT s_chk_ware(g_oeb[l_ac].oeb09) THEN
                 NEXT FIELD oeb09
              END IF
              #No.FUN-AA0048  --End  
              CALL s_swyn(g_oeb[l_ac].oeb09) RETURNING l_sn1,l_sn2
              IF l_sn1=1 THEN
                 CALL cl_err(g_oeb[l_ac].oeb09,'mfg6080',1)
                 NEXT FIELD oeb09
              ELSE
                 IF l_sn2=2 THEN
                    CALL cl_err(g_oeb[l_ac].oeb09,'mfg6085',0)
                    NEXT FIELD oeb09
                 END IF
              END IF
           ELSE
              IF g_oeb[l_ac].oeb09 IS NULL THEN
                 LET g_oeb[l_ac].oeb09=' '
              END IF
           END IF
        #FUN-D40103 ------Begin-------
           IF NOT s_imechk(g_oeb[l_ac].oeb09,g_oeb[l_ac].oeb091) THEN
              NEXT FIELD oeb091
           END IF
        #FUN-D40103 ------End---------
           DISPLAY BY NAME g_oeb[l_ac].oeb09              #No.MOD-730118
 
        AFTER FIELD oeb091
           IF NOT cl_null(g_oeb[l_ac].oeb091) THEN
              IF g_oeb[l_ac].oeb091 = '　' THEN #全型空白
                 LET g_oeb[l_ac].oeb091 = ' '
                 NEXT FIELD oeb091
              END IF
           #FUN-D40103 -----Begin------
            #  LET l_cnt = 0
            #     SELECT COUNT(*) INTO l_cnt FROM ime_file
            #      WHERE ime01 = g_oeb[l_ac].oeb09
            #        AND ime02 = g_oeb[l_ac].oeb091
            #  IF l_cnt=0 THEN
            #     CALL cl_err(g_oeb[l_ac].oeb091,'mfg0095',0)
            #     NEXT FIELD oeb091
            #  END IF
            #FUN-D40103 -----End--------
              CALL s_lwyn(g_oeb[l_ac].oeb09,g_oeb[l_ac].oeb091)
                   RETURNING l_sn1,l_sn2
              IF l_sn1=1 THEN
                 CALL cl_err(g_oeb[l_ac].oeb091,'mfg6081',0)
                 NEXT FIELD oeb091
              ELSE
                 IF l_sn2=2 THEN
                    CALL cl_err(g_oeb[l_ac].oeb091,'mfg6086',0)
                    NEXT FIELD oeb091
                 END IF
              END IF
              LET l_sn1=0 LET l_sn2=0
           ELSE
              IF g_oeb[l_ac].oeb091 IS NULL THEN
                 LET g_oeb[l_ac].oeb091=' '
              END IF
           END IF
          #FUN-D40103 ------Begin-------
           IF NOT s_imechk(g_oeb[l_ac].oeb09,g_oeb[l_ac].oeb091) THEN
              NEXT FIELD oeb091
           END IF
        #FUN-D40103 ------End---------
           DISPLAY BY NAME g_oeb[l_ac].oeb091              #No.MOD-730118
 
        AFTER FIELD oeb16  
           IF g_oeb[l_ac].oeb16 < g_oea.oea02 THEN   
              CALL cl_err('','axm-308',1) 
              NEXT FIELD oeb16 
           END IF 
           DISPLAY BY NAME g_oeb[l_ac].oeb16              #No.MOD-730118
 
        ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            EXIT INPUT
         END IF
         IF g_oeb[l_ac].oeb03 > 0 THEN 
             UPDATE oeb_file SET
                oeb09 =g_oeb[l_ac].oeb09,
                oeb091=g_oeb[l_ac].oeb091,
                oeb16 = g_oeb[l_ac].oeb16
                WHERE oeb01=g_oea.oea01 AND oeb03=g_oeb[l_ac].oeb03
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL cl_err('upd oeb:',SQLCA.SQLCODE,0)
            END IF
         END IF

        AFTER ROW
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            EXIT INPUT
         END IF
           IF g_oeb[l_ac].oeb70='Y' THEN 
               #LET g_oeb[l_ac].oeb08=l_oeb08  #MOD-570253
               #display g_oeb[l_ac].oeb08 to s_oeb[l_sl].oeb08 #MOD-570253
              CALL cl_err('','aap-730',0)
           END IF

        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
        ON ACTION CONTROLP
           CASE  
                WHEN INFIELD(oeb09) 
                       #No.FUN-AA0048  --Begin
                       #CALL cl_init_qry_var()
                       #LET g_qryparam.form = "q_imd"
                       #LET g_qryparam.construct = 'N'
                       #LET g_qryparam.default1 = g_oeb[l_ac].oeb09
                       #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                       #CALL cl_create_qry() RETURNING g_oeb[l_ac].oeb09
                       CALL q_imd_1(FALSE,TRUE,g_oeb[l_ac].oeb09,"","","","") RETURNING g_oeb[l_ac].oeb09
                       #No.FUN-AA0048  --End  
                       DISPLAY BY NAME g_oeb[l_ac].oeb09
           END CASE

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
    END INPUT
END FUNCTION
 
FUNCTION p411_set_entry()

    IF INFIELD(oeb09) OR (NOT g_before_input_done) THEN
       IF g_oaz.oaz102= 'Y' THEN
          CALL cl_set_comp_entry("oeb09",TRUE)
       END IF
    END IF
    IF INFIELD(oeb091) OR (NOT g_before_input_done) THEN
       IF g_oaz.oaz103= 'Y' THEN
          CALL cl_set_comp_entry("oeb091",TRUE)
       END IF
    END IF
 
  #----------No.TQC-690103 add
    IF INFIELD(oeb09) OR  g_before_input_done THEN
          CALL cl_set_comp_entry("oeb16",TRUE)
    END IF
  #----------No.TQC-690103 end
END FUNCTION
 
FUNCTION p411_set_no_entry()
     #MOD-570253
    #IF INFIELD(oeb08) OR (NOT g_before_input_done) THEN
    #   IF g_oaz.oaz101= 'N' THEN
    #      CALL cl_set_comp_entry("oeb08",FALSE)
    #   END IF
    #END IF
    IF INFIELD(oeb09) OR (NOT g_before_input_done) THEN
       IF g_oaz.oaz102= 'N' THEN
          CALL cl_set_comp_entry("oeb09",FALSE)
       END IF
    END IF
    IF INFIELD(oeb091) OR (NOT g_before_input_done) THEN
       IF g_oaz.oaz103= 'N' THEN
          CALL cl_set_comp_entry("oeb091",FALSE)
       END IF
    END IF
 
  #----------No.TQC-690103 add
    IF INFIELD(oeb09) AND  g_before_input_done THEN
          CALL cl_set_comp_entry("oeb16",FALSE)
    END IF
  #----------No.TQC-690103 end
END FUNCTION
