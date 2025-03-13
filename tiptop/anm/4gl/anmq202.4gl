# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmq202.4gl
# Descriptions...: 應收票據異動錄查詢
# Date & Author..: 92/06/10 by yen
# Modify.........: 93/12/28 By Wenni : 單身賦予條件功能
# Modify.........: 95/06/13 By Danny (CALL s_gl entry_sheet維護)
# Modify.........: 96/06/26 By Lynn   接收參數
#                : 96/08/27 By Lynn  :將call s_gl entry_sheet維護 改call s_fsgl
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-550037 05/05/13 By saki  欄位comment顯示
# Modify.........: No.FUN-550057 05/06/01 By wujie 單據編號加大
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
#
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770013 07/07/02 By Judy 匯出EXCEL的值多一空白行
# Modify.........: No.TQC-960142 09/06/12 By sabrina 做查詢時單身下條件所查出的資料不正確，在組sql時少判斷了單身的條件
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0155 09/10/28 By liuxqa order修改。
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
        g_nmh RECORD
             nmh01  LIKE nmh_file.nmh01,
             nmh31  LIKE nmh_file.nmh31,
             nmh03  LIKE nmh_file.nmh03,
             nmh02  LIKE nmh_file.nmh02,
             nmh04  LIKE nmh_file.nmh04,
             nmh05  LIKE nmh_file.nmh05,
             nmh21  LIKE nmh_file.nmh21,
             nmh10  LIKE nmh_file.nmh10,
             nmh11  LIKE nmh_file.nmh11,
             nmh30  LIKE nmh_file.nmh30,
             nmh17  LIKE nmh_file.nmh17,
             nmh171 LIKE nmh_file.nmh171,
             nmh24  LIKE nmh_file.nmh24,
             nmh28  LIKE nmh_file.nmh28,
             nmh35  LIKE nmh_file.nmh35,
             nmh33  LIKE nmh_file.nmh33,
             nmh34  LIKE nmh_file.nmh34
             END RECORD,
       g_nmi DYNAMIC ARRAY OF RECORD
            nmi03   LIKE type_file.num5,
            nmi02   LIKE nmi_file.nmi02,
            nmi05   LIKE nmi_file.nmi05,
            nmi06   LIKE nmi_file.nmi06,
            nmi08   LIKE nmi_file.nmi08,
            nmi09   LIKE nmi_file.nmi09,
            remark  like type_file.chr1000, #darcy:2024/08/22 add
            nmi10   LIKE nmi_file.nmi10,
            nmi11   LIKE nmi_file.nmi11
       END RECORD,
        g_wc            STRING,                      #No.FUN-580092 HCN  
        g_wc2           STRING,                      #No.FUN-580092 HCN  
        g_sql           STRING,                      #No.FUN-580092 HCN  
        l_ac            LIKE type_file.num5,         #No.FUN-680107 SMALLINT
        g_rec_b         LIKE type_file.num5,  	     #單身筆數 #No.FUN-680107 SMALLINT
#      g_argv1          VARCHAR(10)
       g_argv1          LIKE nmh_file.nmh01          #No.FUN-550057
 
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680107 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0082
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
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
    OPEN WINDOW q202_w AT p_row,p_col
         WITH FORM "anm/42f/anmq202"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
 #96-06-26 Modify By Lynn
    LET g_argv1 = ARG_VAL(1)
    IF NOT cl_null(g_argv1)
       THEN CALL q202_q()
    END IF
 
    CALL q202_menu()
    CLOSE WINDOW q202_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION q202_cs()
    CLEAR FORM
   CALL g_nmi.clear()
 #96-06-26 Modify By Lynn
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    IF NOT cl_null(g_argv1)  THEN
       LET g_sql="SELECT nmh01 FROM nmh_file ", # 組合出 SQL 指令
          " WHERE nmh01 ='",g_argv1, "' ORDER BY nmh01"
    ELSE
   INITIALIZE g_nmh.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON nmh01,nmh31,nmh21,nmh04,nmh10,nmh29,
                                 nmh03,nmh28,nmh02,nmh17,nmh05,nmh24,
                                 nmh11,nmh30,nmh35
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
       IF INT_FLAG THEN RETURN END IF
       CALL q202_b_askkey()
       #資料權限的檢查
       #Begin:FUN-980030
       #       IF g_priv2='4' THEN                           #只能使用自己的資料
       #           LET g_wc = g_wc clipped," AND nmhuser = '",g_user,"'"
       #       END IF
       #       IF g_priv3='4' THEN                           #只能使用相同群的資料
       #           LET g_wc = g_wc clipped," AND nmhgrup MATCHES '",g_grup CLIPPED,"*'"
       #       END IF
 
       #       IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       #           LET g_wc = g_wc clipped," AND nmhgrup IN ",cl_chk_tgrup_list()
       #       END IF
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmhuser', 'nmhgrup')
       #End:FUN-980030
 
       IF g_wc2 =  " 1=1" THEN           #TQC-960142
          LET g_sql="SELECT nmh01 FROM nmh_file ", # 組合出 SQL 指令
                    " WHERE ",g_wc CLIPPED, " ORDER BY nmh01"
     #TQC-960142---add---
       ELSE
          LET g_sql="SELECT UNIQUE nmh_file.nmh01 ",
                    "  FROM nmh_file, nmi_file ",
                    " WHERE nmh01 = nmi01 ",
                    "   AND ", g_wc CLIPPED,
                    "   AND ", g_wc2 CLIPPED,
                    " ORDER BY nmh01"
       END IF
     #TQC-960142---add---
    END IF
 
    PREPARE q202_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE q202_cs                         # SCROLL CURSOR
        SCROLL CURSOR FOR q202_prepare
 #96-06-26 Modify By Lynn
    IF NOT cl_null(g_argv1) THEN
        LET g_sql = "SELECT COUNT(*) FROM nmh_file WHERE nmh01 ='",g_argv1,"'"
    ELSE
    #TQC-960142---modify---      #計算筆數時要加入單身條件式
      #LET g_sql= "SELECT COUNT(*) FROM nmh_file WHERE ",g_wc CLIPPED
       IF g_wc2 = " 1=1" THEN
          LET g_sql= "SELECT COUNT(*) FROM nmh_file WHERE ",g_wc CLIPPED
       ELSE
          LET g_sql= "SELECT COUNT(UNIQUE nmh01) FROM nmh_file, nmi_file ",
                     " WHERE nmh01 = nmi01 ",
                     "   AND ", g_wc CLIPPED,
                     "   AND ", g_wc2 CLIPPED
       END IF
    #TQC-960142---modify---
    END IF
    PREPARE q202_precount FROM g_sql
    DECLARE q202_count CURSOR FOR q202_precount
END FUNCTION
 
FUNCTION q202_b_askkey()
    CONSTRUCT g_wc2 ON nmi02,nmi05,nmi06,nmi08,nmi09,nmi10,nmi11
	 FROM s_nmi[1].nmi02,s_nmi[1].nmi05,s_nmi[1].nmi06,
	      s_nmi[1].nmi08,s_nmi[1].nmi09,s_nmi[1].nmi10,
	      s_nmi[1].nmi11
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
    IF INT_FLAG THEN RETURN END IF
END FUNCTION
 
 
FUNCTION q202_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(100)
 
 
 
   WHILE TRUE
      CALL q202_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q202_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#        WHEN "分錄產生"
#           LET l_cmd = "anmp650 '",g_nmh.nmh01,"'"
#           CALL cl_cmdrun(l_cmd CLIPPED)
#        WHEN "entry_sheet"
#           IF cl_chk_act_auth() THEN
#              #系統別、類別、單號、票面金額
#              CALL s_fsgl('NM',2,g_nmh.nmh01,g_nmh.nmh02,g_nmz.nmz02b)
#           END IF
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nmi),'','')
            END IF
      END CASE
   END WHILE
    CLOSE q202_cs
END FUNCTION
 
FUNCTION q202_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q202_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       CALL g_nmi.clear()
       RETURN
    END IF
    OPEN q202_count
    FETCH q202_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q202_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmh.nmh01,SQLCA.sqlcode,0)
        INITIALIZE g_nmh.* TO NULL
    ELSE
        CALL q202_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q202_fetch(p_flnmh)
    DEFINE
        p_flnmh         LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680107 INTEGER
 
    CASE p_flnmh
        WHEN 'N' FETCH NEXT     q202_cs INTO g_nmh.nmh01
        WHEN 'P' FETCH PREVIOUS q202_cs INTO g_nmh.nmh01
        WHEN 'F' FETCH FIRST    q202_cs INTO g_nmh.nmh01
        WHEN 'L' FETCH LAST     q202_cs INTO g_nmh.nmh01
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
            FETCH ABSOLUTE g_jump q202_cs INTO g_nmh.nmh01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmh.nmh01,SQLCA.sqlcode,0)
        INITIALIZE g_nmh.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flnmh
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT nmh01,nmh31,nmh03,nmh02,nmh04,nmh05,nmh21,nmh10,nmh11,nmh30,
           nmh17,nmh171,nmh24,nmh28,nmh35,nmh33,nmh34
           INTO g_nmh.* FROM nmh_file
           # 重讀DB,因TEMP有不被更新特性
       WHERE nmh01 = g_nmh.nmh01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_nmh.nmh01,SQLCA.sqlcode,0)   #No.FUN-660148
        CALL cl_err3("sel","nmh_file",g_nmh.nmh01,"",SQLCA.sqlcode,"","",0) #No.FUN-660148
    ELSE
 
        CALL q202_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION q202_show()
DEFINE   l_sta   LIKE ze_file.ze03       #No.FUN-680107 VARCHAR(4)
  DISPLAY BY NAME g_nmh.nmh01,g_nmh.nmh31,g_nmh.nmh03,g_nmh.nmh02,g_nmh.nmh11,
                  g_nmh.nmh30,
                  g_nmh.nmh21,g_nmh.nmh05,g_nmh.nmh04,g_nmh.nmh17,
                  g_nmh.nmh10,g_nmh.nmh24,g_nmh.nmh28,g_nmh.nmh35
   CALL q202_nmh21('d')
   CALL q202_b_fill() #單身
    CALL cl_show_fld_cont()              #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q202_nmh21(p_cmd)  #銀行代號
DEFINE p_cmd	 LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
       l_nma02   LIKE nma_file.nma02,
       l_nmaacti LIKE nma_file.nmaacti
 
    LET g_errno = ' '
    SELECT nma02,nmaacti
           INTO l_nma02,l_nmaacti
           FROM nma_file WHERE nma01 = g_nmh.nmh21
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-013'
                            LET l_nma02 = NULL
         WHEN l_nmaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_nma02 TO FORMONLY.nma02
    END IF
END FUNCTION
 
FUNCTION q202_b_fill()                         #BODY FILL UP
   DEFINE l_t1        LIKE nmh_file.nmh01      #No.FUN-680107 VARCHAR(3)
   DEFINE l_nmydmy3   LIKE nmy_file.nmydmy3
   #darcy:2024/08/22 add s---
   define   l_npo04     like npo_file.npo04,
            l_npo05     like npo_file.npo05
   #darcy:2024/08/22 add e---
 
#96-06-26 Modify By Lynn
    IF NOT cl_null(g_argv1) THEN
       LET g_sql =
           "SELECT nmi03,nmi02,nmi05,nmi06,nmi08,nmi09,'',nmi10,nmi11", #darcy:2024/08/22 add ''
           " FROM  nmi_file",
           " WHERE nmi01 = '",g_nmh.nmh01,"'" ,
           #" ORDER BY 2,1"     #No.TQC-9A0155 mark
           " ORDER BY nmi03"    #No.TQC-9A0155 mod
    ELSE
       LET g_sql =
           "SELECT nmi03,nmi02,nmi05,nmi06,nmi08,nmi09,'',nmi10,nmi11", #darcy:2024/08/22 add ''
           " FROM  nmi_file",
           " WHERE nmi01 = '",g_nmh.nmh01,"'" ,
           " AND ",g_wc2 CLIPPED,
           #" ORDER BY 2,1"     #No.TQC-9A0155 mark
           " ORDER BY nmi03"    #No.TQC-9A0155 mod
    END IF
    PREPARE q202_pb FROM g_sql
    DECLARE nmi_curs                      #SCROLL CURSOR
        CURSOR FOR q202_pb
 
    CALL g_nmi.clear()
    LET g_cnt = 1
    FOREACH nmi_curs INTO g_nmi[g_cnt].*           #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
	      IF g_nmi[g_cnt].nmi05 = '0' AND g_nmi[g_cnt].nmi06 = '1' THEN
           LET l_t1=g_nmh.nmh01
           SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip = l_t1
           IF cl_null(l_nmydmy3) THEN LET l_nmydmy3='N' END IF
           IF l_nmydmy3 = 'N' THEN   #是否拋轉傳票
	      LET g_nmi[g_cnt].nmi10 = g_nmh.nmh33
     	      LET g_nmi[g_cnt].nmi11 = g_nmh.nmh34
           END IF
        END IF
         #darcy:2024/08/22 add s---
         # 转付,需要标记转付金额明细
         if g_nmi[g_cnt].nmi06 = '5' then
            select sum(npo04),sum(npo05) into l_npo04,l_npo05 from npo_file,npn_file
             where npo01 = npn01 and npn01 = g_nmi[g_cnt].nmi10 and npo03 = g_nmh.nmh01
            if not cl_null(l_npo04) and not cl_null(l_npo05) then
               let g_nmi[g_cnt].remark = sfmt("转付,原币金额:%1,本币金额:%2",l_npo04 using '<<<<<<<<<<<<<<.##',l_npo05 using '<<<<<<<<<<<<<<.##')
            end if
         end if
         #darcy:2024/08/22 add e---
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_nmi.deleteElement(g_cnt)  #TQC-770013
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION q202_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nmi TO s_nmi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL q202_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q202_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q202_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q202_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q202_fetch('L')
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
       #No.MOD-530853  --end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
