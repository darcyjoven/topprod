# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfq311.4gl
# Descriptions...: RUN CARD 製程調整查詢作業
# Date & Author..: 06/05/18 By Sarah
# Modify.........: No.FUN-650111 06/05/18 Sarah 新增"RUN CARD 製程調整查詢作業"
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: Mo.FUN-6A0071 06/10/24 By xumin g_no_ask改g_no_ask    
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-930105 09/03/27 By lilingyu 1.當sho01有值sho03沒有值的時候,此筆數據應在asfq312中體現 2.關聯條件錯誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960001 09/10/12 By jan 畫面新增sho52,sho53,sho54欄位
# Modify.........: No:FUN-9A0063 09/11/16 By jan sho06新增 "4:新增製程"選項
# Modify.........: No:FUN-A60092 10/07/06 By lilingyu 平行工藝
# Modify.........: No:FUN-A70137 10/07/29 By lilingyu 畫面增加"組成用量 底數"等欄位
# Modify.........: No:TQC-D70079 13/07/23 By lujh 查询的时候不要显示出非runcard的工艺调整资料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_sho              RECORD LIKE sho_file.*,
    g_sho_t            RECORD LIKE sho_file.*,
    g_sho01_t          LIKE sho_file.sho01,
    g_z07,g_s07,g_f07  LIKE sho_file.sho07,
    g_z08,g_s08,g_f08  LIKE sho_file.sho08,
    g_s09,g_f09        LIKE sho_file.sho09,
    g_f10              LIKE sho_file.sho09,   #FUN-A70137
    g_wc,g_wc2         STRING,  #No.FUN-580092 HCN
    g_sql              STRING,  #No.FUN-580092 HCN
    g_sgm              DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sgm03           LIKE sgm_file.sgm03,      #製程序號
        sgm04           LIKE sgm_file.sgm04       #作業編號
                       END RECORD,
    g_sgm_t            RECORD                     #程式變數 (舊值)
        sgm03           LIKE sgm_file.sgm03,      #製程序號
        sgm04           LIKE sgm_file.sgm04       #作業編號
                       END RECORD,
    g_sgm59            LIKE sgm_file.sgm59,
    g_rec_b            LIKE type_file.num5,                    #單身筆數        #No.FUN-680121 SMALLINT
    l_ac               LIKE type_file.num5,                    #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_sl               LIKE type_file.num5,                    #目前處理的SCREEN LINE      #No.FUN-680121 SMALLINT
    g_argv1            LIKE sho_file.sho01 
DEFINE g_chr        LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_msg        LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_curs_index LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_jump       LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_no_ask    LIKE type_file.num5          #No.FUN-680121 SMALLINT   #No.FUN-6A0071
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818
 
   LET g_argv1 = ARG_VAL(1)  #Run Card
 
   INITIALIZE g_sho.* TO NULL
   INITIALIZE g_sho_t.* TO NULL
 
   OPEN WINDOW q311_w WITH FORM "asf/42f/asfq311"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()

#FUN-A60092 --begin--
  IF g_sma.sma541 = 'Y' THEN 
     CALL cl_set_comp_visible("sho012,g_f10",TRUE)   #FUN-A70137 add g_f10
  ELSE
     CALL cl_set_comp_visible("sho012,g_f10",FALSE)  #FUN-A70137 add g_f10
  END IF 	 
#FUN-A60092 --end--
 
   IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
      CALL q311_q()
   END IF
   CALL q311_menu()
   CLOSE WINDOW q311_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION q311_cs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   LET  g_wc2=' 1=1'
   CLEAR FORM
   IF cl_null(g_argv1) THEN
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031  
   INITIALIZE g_sho.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON sho01,sho02,sho03,
                                sho012,   #FUN-A60092 add
                                sho06,
                                g_z07,g_z08,g_s07,g_s08,g_s09,g_f07,g_f08,g_f09,
                                g_f10,   #FUN-A70137 add
                                sho12,
                                sho52,sho53,sho54,  #CHI-960001 add
                                sho10,sho11
                               ,sho62,sho63,sho64,sho16,sho17   #FUN-A70137 ad 
 
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 --end--       HCN
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(sho01)   #調整單號
                  CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_sho"    #TQC-D70079 mark
                  LET g_qryparam.form = "q_sho_1"   #TQC-D70079 add
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.default1 = g_sho.sho01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sho01
                  NEXT FIELD sho01
               WHEN INFIELD(sho03)   #RUN CARD
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_shm"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.default1 = g_sho.sho03
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sho03
                  NEXT FIELD sho03
#FUN-A60092 --begin--
               WHEN INFIELD(sho012)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sho012"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.default1 = g_sho.sho012
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sho012
                  NEXT FIELD sho012
#FUN-A60092 --end--
               WHEN INFIELD(g_s09)   #作業編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ecd3"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.default1 = g_s09
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO g_s09
                  NEXT FIELD g_s09
               WHEN INFIELD(g_f09)   #製程編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ecu"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.default1 = g_f09
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO g_f09
                  NEXT FIELD g_f09
               WHEN INFIELD(sho10)   #作業員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gen"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.default1 = g_sho.sho10
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sho10
                  NEXT FIELD sho10
            END CASE
 
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
           CALL cl_qbe_list() RETURNING lc_qbe_sn
           CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 --end--       HCN
 
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
 
      CONSTRUCT g_wc2 ON sgm03,sgm04
                    FROM s_sgm[1].sgm03,s_sgm[1].sgm04
 
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
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc ="sho01 ='",g_argv1,"'"
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                            # 只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND shouser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                            # 只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND shogrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND shogrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('shouser', 'shogrup')
   #End:FUN-980030
 
   IF g_wc2=' 1=1' OR g_wc2 IS NULL THEN
      LET g_sql="SELECT sho01 FROM sho_file ",
                " WHERE ",g_wc CLIPPED, 
                "   AND sho01 IS NOT NULL ",   #TQC-D70079 add
                "   AND sho03 IS NOT NULL ",   #TQC-D70079 add
                " ORDER BY sho01"
   ELSE
      LET g_sql="SELECT sho01",
                "  FROM sho_file,sgm_file ",
            #    " WHERE sho01=sgm01 ",       #NO.FUN-930105
                 " where sho03 = sgm01",      #NO.FUN-930105
                 "   and sho012= sgm012",     #FUN-A60092 add
                 "   AND sho07 = sgm03",      #FUN-A70137 
                 "   AND sho01 IS NOT NULL ",   #TQC-D70079 add
                 "   AND sho03 IS NOT NULL ",   #TQC-D70079 add
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " ORDER BY sho01"
   END IF
 
   PREPARE q311_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE q311_cs SCROLL CURSOR WITH HOLD FOR q311_prepare
 
   IF g_wc2=' 1=1' OR g_wc2 IS NULL THEN
      LET g_sql= "SELECT COUNT(*) FROM sho_file ",
                 " WHERE ",g_wc CLIPPED,
                 "   AND sho01 IS NOT NULL ",   #TQC-D70079 add
                 "   AND sho03 IS NOT NULL "    #TQC-D70079 add
   ELSE
      LET g_sql= "SELECT COUNT(DISTINCT sho01) FROM sho_file,sgm_file ",
#                 " WHERE sho01=sgm01 ",  #NO.FUN-930105
                  " where sho03 = sgm01", #NO.FUN-930105 
                  "   and sho012= sgm012",  #FUN-A60092 add
                  "   AND sho07 = sgm03",  #FUN-A70137
                  "   AND sho01 IS NOT NULL ",   #TQC-D70079 add
                  "   AND sho03 IS NOT NULL ",   #TQC-D70079 add
                  "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE q311_precount FROM g_sql
   DECLARE q311_count CURSOR FOR q311_precount
END FUNCTION
 
FUNCTION q311_menu()
 
   WHILE TRUE
      CALL q311_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q311_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sgm),'','')
            END IF
      END CASE
   END WHILE
   CLOSE q311_cs
END FUNCTION
 
FUNCTION q311_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL q311_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN q311_count
    FETCH q311_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q311_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_sho.sho01,SQLCA.sqlcode,0)
       INITIALIZE g_sho.* TO NULL
    ELSE
       CALL q311_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q311_fetch(p_flsho)
    DEFINE p_flsho          LIKE type_file.chr1,         #No.FUN-680121 VARCHAR(1)
           l_abso           LIKE type_file.num10         #No.FUN-680121 INTEGER
 
    CASE p_flsho
        WHEN 'N' FETCH NEXT     q311_cs INTO g_sho.sho01
        WHEN 'P' FETCH PREVIOUS q311_cs INTO g_sho.sho01
        WHEN 'F' FETCH FIRST    q311_cs INTO g_sho.sho01
        WHEN 'L' FETCH LAST     q311_cs INTO g_sho.sho01
        WHEN '/'
            IF (NOT g_no_ask) THEN  #No.FUN-6A0071
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR  g_jump
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
            FETCH ABSOLUTE  g_jump q311_cs INTO g_sho.sho01
            LET g_no_ask = FALSE    #No.FUN-6A0071
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sho.sho01,SQLCA.sqlcode,0)
        INITIALIZE g_sho.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flsho
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_sho.* FROM sho_file       # 重讀DB,因TEMP有不被更新特性
     WHERE sho01 = g_sho.sho01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_sho.sho01,SQLCA.sqlcode,1)   #No.FUN-660128
       CALL cl_err3("sel","sho_file",g_sho.sho01,"",SQLCA.sqlcode,"","",1)    #No.FUN-660128
       INITIALIZE g_sho.* TO NULL            #FUN-4C0034
    ELSE
       LET g_data_owner = g_sho.shouser      #FUN-4C0034
       LET g_data_group = g_sho.shogrup      #FUN-4C0034
       CALL q311_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION q311_show()
    DEFINE l_gen02   LIKE gen_file.gen02
 
    LET g_sho_t.* = g_sho.*
 
    DISPLAY BY NAME g_sho.sho01, g_sho.sho02, g_sho.sho03, g_sho.sho06,
                    g_sho.sho12, g_sho.sho10, g_sho.sho11,
                    g_sho.sho52, g_sho.sho53, g_sho.sho54   #CHI-960001
                   ,g_sho.sho012  #FUN-A60092 add 
                   ,g_sho.sho62,g_sho.sho63,g_sho.sho64,g_sho.sho16,g_sho.sho17  #FUN-A70137 add
                   
    DISPLAY '' TO FORMONLY.g_z07
    DISPLAY '' TO FORMONLY.g_z08
    DISPLAY '' TO FORMONLY.g_z09
    DISPLAY '' TO FORMONLY.g_s07
    DISPLAY '' TO FORMONLY.g_s08
    DISPLAY '' TO FORMONLY.g_s09
    DISPLAY '' TO FORMONLY.g_f07
    DISPLAY '' TO FORMONLY.g_f08
    DISPLAY '' TO FORMONLY.g_f09
    DISPLAY g_sho.sho112 TO FORMONLY.g_f10  #FUN-A70137 add
    
    CASE g_sho.sho06
         WHEN '1'   
            DISPLAY g_sho.sho07 TO FORMONLY.g_z07
            DISPLAY g_sho.sho08 TO FORMONLY.g_z08
            DISPLAY '' TO FORMONLY.g_z09
         WHEN '2'   
            DISPLAY g_sho.sho07 TO FORMONLY.g_s07
            DISPLAY g_sho.sho08 TO FORMONLY.g_s08
            DISPLAY g_sho.sho09 TO FORMONLY.g_s09
         WHEN '3'   
            DISPLAY g_sho.sho07 TO FORMONLY.g_f07
            DISPLAY g_sho.sho08 TO FORMONLY.g_f08
            DISPLAY g_sho.sho09 TO FORMONLY.g_f09
         WHEN '4'                                    #FUN-9A0063
            DISPLAY g_sho.sho09 TO FORMONLY.g_f09    #FUN-9A0063
         OTHERWISE  
            DISPLAY g_sho.sho07 TO FORMONLY.g_z07
            DISPLAY g_sho.sho08 TO FORMONLY.g_z08
            DISPLAY '' TO FORMONLY.g_z09
    END CASE
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_sho.sho10
    IF STATUS THEN
       LET l_gen02 = ' '
    END IF
    DISPLAY l_gen02 TO FORMONLY.gen02
    CALL q311_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
  #NO.FUN-930105  --begin    
   IF g_sho.sho01 IS NOT NULL AND g_sho.sho03 IS NULL THEN 
      CALL cl_err('','asf-044',1)
   END IF 
  #NO.FUN-930105 --end        
END FUNCTION
 
FUNCTION q311_b_askkey()
 
    CONSTRUCT g_wc2 ON sgm03,sgm04
                  FROM s_sgm[1].sgm03,s_sgm[1].sgm04
 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL q311_b_fill(g_wc2)
END FUNCTION
 
FUNCTION q311_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sgm TO s_sgm.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL q311_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q311_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL q311_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL q311_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q311_fetch('L')
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      #No.MOD-530852  --begin
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      #No.MOD-530852  --end
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q311_b_fill(p_wc2)              #BODY FILL UP
    DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(600)
 
    LET g_sql ="SELECT sgm03,sgm04 ",
               "  FROM sgm_file",
               " WHERE sgm01 = '",g_sho.sho03, "'",
               "   AND sgm012= '",g_sho.sho012,"'",   #FUN-A60092 add
               "   AND sgm03 ='",g_sho.sho07,"'",  #FUN-A70137
               "   AND ",g_wc2 CLIPPED,
               " ORDER BY sgm03,sgm04 "
    PREPARE q311_pb FROM g_sql
    DECLARE sgm_curs CURSOR FOR q311_pb
 
    CALL g_sgm.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH sgm_curs  INTO g_sgm[g_cnt].*     #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '',9035,1)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_sgm.deleteElement(g_cnt)
    LET g_rec_b= g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
