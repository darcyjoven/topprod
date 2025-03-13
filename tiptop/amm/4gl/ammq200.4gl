# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: ammq200.4gl
# Descriptions...: 加工通知單查詢作業
# Date & Author..: 00/12/14 By Faith
# Modify.........: No.FUN-4B0036 04/11/09 By Smapmin ARRAY轉為EXCEL檔
 # Modify.........: No.MOD-530688 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-550054 05/05/17 By yoyo單據編號格式放大
# Modify.........: No.FUN-660094 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-930113 09/03/18 By mike 將oah_file-->pnz_file
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990132 09/10/13 By lilingu "通知單號"增加開窗功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_mme           RECORD LIKE mme_file.*,
    g_mme_t         RECORD LIKE mme_file.*,
    g_old_mme03     LIKE mme_file.mme03,
    g_old_mme01     LIKE mme_file.mme01,
    g_n_mme01       LIKE mme_file.mme01,
    g_mmf01         LIKE mmf_file.mmf01,
    g_mmf07         LIKE mmf_file.mmf07,
    g_mmf08         LIKE mmf_file.mmf08,
    g_mmf           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        mmf02       LIKE mmf_file.mmf02,   #項次
        mmf03       LIKE mmf_file.mmf03,   #料件編號
        mmf031      LIKE mmf_file.mmf031,  #單位
        mmf04       LIKE mmf_file.mmf04,   #圖號
        mmf05       LIKE mmf_file.mmf05,   #版本
        mmf06       LIKE mmf_file.mmf06,   #規格說明
        mmf09       LIKE mmf_file.mmf09,   #開始日期
        mmf091      LIKE mmf_file.mmf091,  #完成日期
        mmf10       LIKE mmf_file.mmf10,   #加工數量
        mmf11       LIKE mmf_file.mmf11,   #需求單號
        mmf111      LIKE mmf_file.mmf111,  #項次
        mmf12       LIKE mmf_file.mmf12,   #單價
        mmf13       LIKE mmf_file.mmf13,   #工時
        mmf14       LIKE mmf_file.mmf14,   #備註
        mmf15       LIKE mmf_file.mmf15,   #加工碼
        mmc02       LIKE mmc_file.mmc02    #加工說明
                    END RECORD,
    g_mmf_t         RECORD                 #程式變數 (舊值)
        mmf02       LIKE mmf_file.mmf02,   #項次
        mmf03       LIKE mmf_file.mmf03,   #料件編號
        mmf031      LIKE mmf_file.mmf031,  #單位
        mmf04       LIKE mmf_file.mmf04,   #圖號
        mmf05       LIKE mmf_file.mmf05,   #版本
        mmf06       LIKE mmf_file.mmf06,   #規格說明
        mmf09       LIKE mmf_file.mmf09,   #開始日期
        mmf091      LIKE mmf_file.mmf091,  #完成日期
        mmf10       LIKE mmf_file.mmf10,   #加工數量
        mmf11       LIKE mmf_file.mmf11,   #需求單號
        mmf111      LIKE mmf_file.mmf111,  #項次
        mmf12       LIKE mmf_file.mmf12,   #單價
        mmf13       LIKE mmf_file.mmf13,   #工時
        mmf14       LIKE mmf_file.mmf14,   #備註
        mmf15       LIKE mmf_file.mmf15,   #加工碼
        mmc02       LIKE mmc_file.mmc02    #加工說明
                    END RECORD,
    tm  RECORD			           # Print condition RECORD
          wc        LIKE type_file.chr1000,       #No.FUN-680100 VARCHAR(600)# Where Condition
          opdate    LIKE type_file.dat            #No.FUN-680100 DATE
       END RECORD,
    tm2_1  RECORD	
#           ano      VARCHAR(03)
           ano      LIKE oay_file.oayslip         # Prog. Version..: '5.30.06-13.03.12(05)#No.FUN-550054
       END RECORD,
#       g_t1              VARCHAR(3),
       g_t1              LIKE oay_file.oayslip,        #No.FUN-550054        #No.FUN-680100 VARCHAR(05)
       g_exit            LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
        g_wc,g_wc2,g_sql  STRING,                      #No.FUN-580092 HCN        #No.FUN-680100
       g_rec_b           LIKE type_file.num5,          #單身筆數        #No.FUN-680100 SMALLINT
       p_row,p_col       LIKE type_file.num5,          #No.FUN-680100 SMALLINT
       l_ac              LIKE type_file.num5,          #目前處理的ARRAY CNT        #No.FUN-680100 SMALLINT
       l_sl              LIKE type_file.num5           #No.FUN-680100 SMALLINT#目前處理的SCREEN LINE
 
#主程式開始
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680100 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680100 SMALLINT
DEFINE g_argv1     LIKE mmf_file.mmf01     #FUN-810046
DEFINE g_argv2     STRING                  #FUN-810046      #執行功能
 
MAIN
# DEFINE l_time    LIKE type_file.chr8            #No.FUN-6A0076
 
    OPTIONS                                    #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)           #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
 
   LET g_argv1=ARG_VAL(1)   #           #FUN-810046
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-810046
 
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW q200_w AT p_row,p_col   #顯示畫面
        WITH FORM "amm/42f/ammq200"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #FUN-810046
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL q200_q()
            END IF
         OTHERWISE        
            CALL q200_q() 
      END CASE
   END IF
   #--
 
 
    IF NOT cl_null(g_argv1) THEN CALL q200_q() END IF
    CALL q200_menu()
    CLOSE WINDOW q200_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
END MAIN
 
#QBE 查詢資料
FUNCTION q200_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    CLEAR FORM                                        #清除畫面
    CALL g_mmf.clear()
     CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_mme.* TO NULL    #No.FUN-750051
 
   IF g_argv1<>' ' THEN                     #FUN-810046
      LET g_wc=" mme01='",g_argv1,"'"       #FUN-810046
      LET g_wc2=" 1=1"                      #FUN-810046
   ELSE
      CONSTRUCT BY NAME g_wc ON mme01,mme02,mme03,
                                mme11,mme14,mme04,mme05,
                                mme06,mme07,mme10,mme12,
                                mme15,mme13
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
  #TQC-990132 --begin--
    ON ACTION controlp
      CASE
        WHEN INFIELD(mme01)
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_mme01"  
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO mme01
              NEXT FIELD mme01
       END CASE       
 #TQC-990132 --end--
 
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('mmeuser', 'mmegrup') #FUN-980030
      IF INT_FLAG THEN RETURN END IF
 
      CONSTRUCT g_wc2 ON mmf02,mmf03,mmf031,mmf04,mmf05,mmf06,
                         mmf09,mmf091,mmf10,mmf12,mmf13,mmf11,mmf111,
                         mmf15,mmc02,mmf14
                    FROM s_mmf[1].mmf02,s_mmf[1].mmf03,s_mmf[1].mmf031,
                         s_mmf[1].mmf04,s_mmf[1].mmf05,s_mmf[1].mmf06,
                         s_mmf[1].mmf09,s_mmf[1].mmf091,s_mmf[1].mmf10,
                         s_mmf[1].mmf12,s_mmf[1].mmf13,s_mmf[1].mmf11,
                         s_mmf[1].mmf111,s_mmf[1].mmf15,s_mmf[1].mmc02,
                         s_mmf[1].mmf14
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
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   #ELSE
   #   LET g_wc2 = " mmf11='",g_argv1,"' "
   #   LET g_wc =  " 1=1"
    END IF
 
      IF g_wc2 =" 1=1" THEN
      LET g_sql = "SELECT mme01 ",
                  "  FROM mme_file",
                  " WHERE mmeacti!='X' AND ", g_wc CLIPPED,
                  " ORDER BY mme01 "
      ELSE
      LET g_sql = "SELECT DISTINCT mme_file.mme01 ",
                  "  FROM mmf_file,mme_file",
                  " WHERE mmf01 = mme01 AND mmfacti !='X' AND ",
                    g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY mme01 "
      END IF
      PREPARE q200_prepare FROM g_sql
      DECLARE q200_cs                         #SCROLL CURSOR
          SCROLL CURSOR WITH HOLD FOR q200_prepare
 
#     LET g_forupd_sql = " SELECT * FROM mme_file WHERE mme01 = ? ", #
#                           " FOR UPDATE "
#     DECLARE q200_cl CURSOR FROM g_forupd_sql
 
      IF g_wc2 = " 1=1" THEN
         LET g_sql = "SELECT COUNT(*) FROM mme_file WHERE ", g_wc CLIPPED
      ELSE
         LET g_sql="SELECT COUNT(DISTINCT mme01) ",
                " FROM mmf_file,mme_file ",
                " WHERE mmf01=mme01  ",
                " AND mmeacti!='X' ",
                " AND ",g_wc CLIPPED,
                " AND ",g_wc2 CLIPPED
      END IF
    PREPARE q200_precount FROM g_sql
    DECLARE q200_count CURSOR FOR q200_precount
END FUNCTION
 
#中文的MENU
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
         WHEN "exporttoexcel"     #FUN-4B0036
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_mmf),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION q200_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
   CALL g_mmf.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q200_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN q200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_mme.* TO NULL
    ELSE
       OPEN q200_count
       FETCH q200_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q200_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION q200_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680100 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680100 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q200_cs INTO g_mme.mme01
        WHEN 'P' FETCH PREVIOUS q200_cs INTO g_mme.mme01
        WHEN 'F' FETCH FIRST    q200_cs INTO g_mme.mme01
        WHEN 'L' FETCH LAST     q200_cs INTO g_mme.mme01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump q200_cs INTO g_mme.mme01
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_mme.mme01,SQLCA.sqlcode,0)
        INITIALIZE g_mme.* TO NULL  #TQC-6B0105
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
 
    SELECT * INTO g_mme.* FROM mme_file WHERE mme01 = g_mme.mme01
    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_mme.mme01,SQLCA.sqlcode,0) #No.FUN-660094
         CALL cl_err3("sel","mme_file",g_mme.mme01,"",SQLCA.SQLCODE,"","",0)        #NO.FUN-660094
        INITIALIZE g_mme.* TO NULL
        RETURN
    END IF
 
    CALL q200_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION q200_show()
  DEFINE l_pnz02   LIKE pnz_file.pnz02, #FUN-930113  oah-->pnz
         l_pmc03   LIKE pmc_file.pmc03,
         l_pmc15   LIKE pmc_file.pmc15,
         l_pmc16   LIKE pmc_file.pmc16,
         l_gec02   LIKE gec_file.gec02,
         l_gecacti LIKE gec_file.gecacti,
         l_gen02   LIKE gen_file.gen02,
         l_genacti LIKE gen_file.genacti,
         l_gem02   LIKE gem_file.gem02,
         l_gemacti LIKE gem_file.gemacti
 
    LET g_mme_t.* = g_mme.*                #保存單頭舊值
    DISPLAY BY NAME g_mme.mme01, g_mme.mme02, g_mme.mme03, g_mme.mme11,
                    g_mme.mme14, g_mme.mme04, g_mme.mme05, g_mme.mme06,
                    g_mme.mme07,g_mme.mme10,g_mme.mme12,g_mme.mme15,
                    g_mme.mme13
    SELECT pmc03,pmc15,pmc16
      INTO l_pmc03,l_pmc15,l_pmc16
      FROM pmc_file
     WHERE pmc01 = g_mme.mme03
### tony 010110
    IF STATUS THEN
       SELECT gem02,'','' INTO l_pmc03,l_pmc15,l_pmc16 FROM gem_file
	WHERE gem01=g_mme.mme03
    END IF
###
    DISPLAY l_pmc03 TO FORMONLY.pmc03
    DISPLAY l_pmc15 TO FORMONLY.pmc15
    DISPLAY l_pmc16 TO FORMONLY.pmc16
 
    SELECT gec02,gecacti
      INTO l_gec02,l_gecacti
      FROM gec_file
     WHERE gec01 = g_mme.mme11
    DISPLAY l_gec02 TO FORMONLY.gec02
 
    SELECT gen02,genacti
      INTO l_gen02,l_genacti
      FROM gen_file
     WHERE gen01 = g_mme.mme06
    DISPLAY l_gen02 TO FORMONLY.gen02
 
    SELECT gem02,gemacti
      INTO l_gem02,l_gemacti
      FROM gem_file
     WHERE gem01 = g_mme.mme07
    DISPLAY l_gem02 TO FORMONLY.gem02
 
    SELECT pnz02 #FUN-930113  oah-->pnz 
      INTO l_pnz02 #FUN-930113  oah-->pnz 
      FROM pnz_file #FUN-930113  oah-->pnz 
     WHERE pnz01 = g_mme.mme14 #FUN-930113  oah-->pnz 
    DISPLAY l_pnz02 TO FORMONLY.pnz02 #FUN-930113  oah-->pnz 
 
    CALL q200_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q200_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000     #No.FUN-680100 VARCHAR(200)
 
      CONSTRUCT l_wc2 ON mmf02,mmf03,mmf031,mmf04,mmf05,mmf06,
                         mmf09,mmf091,mmf10,mmf12,mmf13,mmf11,mmf111,
                         mmf15,mmc02,mmf14
                    FROM s_mmf[1].mmf02,s_mmf[1].mmf03,s_mmf[1].mmf031,
                         s_mmf[1].mmf04,s_mmf[1].mmf05,s_mmf[1].mmf06,
                         s_mmf[1].mmf09,s_mmf[1].mmf091,s_mmf[1].mmf10,
                         s_mmf[1].mmf12,s_mmf[1].mmf13,s_mmf[1].mmf11,
                         s_mmf[1].mmf111,s_mmf[1].mmf15,s_mmf[1].mmc02,
                         s_mmf[1].mmf14
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL q200_b_fill(l_wc2)
END FUNCTION
 
FUNCTION q200_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2         LIKE type_file.chr1000       #No.FUN-680100 VARCHAR(600)
 
    LET g_sql =
        "SELECT mmf02,mmf03,mmf031,mmf04,mmf05,mmf06,",
        "  mmf09,mmf091,mmf10,mmf11,mmf111,mmf12,mmf13,mmf14,mmf15,mmc02",
        " FROM mmf_file LEFT OUTER JOIN mmc_file ON mmf15 = mmc_file.mmc01 ",
        " WHERE  ",
        " mmf01 ='",g_mme.mme01,"' AND mmfacti !='X' AND ",
        p_wc2 CLIPPED
 
    PREPARE q200_pb FROM g_sql
    DECLARE mmf_cl                       #SCROLL CURSOR
        CURSOR FOR q200_pb
    CALL g_mmf.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH mmf_cl INTO g_mmf[g_cnt].*   #單身 ARRAY 填充
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
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mmf TO s_mmf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      #BEFORE ROW
#        LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q200_fetch('L')
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel       #FUN-4B0036
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #No.MOD-530688  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
       #No.MOD-530688  --end
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#Patch....NO.TQC-610035 <001> #
