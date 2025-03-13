# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmi500.4gl
# Descriptions...: 特賣產品價格維護作業
# Date & Author..: 02/08/05 By  Jack
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-4C0099 05/02/15 By kim 報表轉XML功能
# Modify.........: No.MOD-530334 05/03/28 By Mandy 1.價格條件開窗時會篩選出取價方式為4.依價格表取價的價格條件編號, 但直接輸入時未檢查取價方式是否符合.
# Modify.........: No.MOD-530334 05/03/28 By Mandy 2.幣別開窗時會篩選出有效的幣別代碼, 但直接輸入時未檢查幣別代碼是否有效.
# Modify.........: No.FUN-560193 05/06/28 By kim 單身 '單位' 改名為 '銷售單位', 並於其右邊增秀 '計價單位'
# Modify.........: No.MOD-560207 05/07/11 By kim 會有有單頭無單身資料產生
# Modify.........: No.FUN-5B0116 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.TQC-640058 06/04/08 By Mandy  _b()內 i500_bcl CURSOR 其SQL select 的順序和_b_fill() xmc_cs CURSOR 所SELECT的順序不一致
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-5A0060 06/06/15 By Sarah 增加列印ima021規格
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/21 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/13 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0129 06/11/22 By day 增加報錯信息
# Modify.........: No.FUN-6B0079 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-720019 07/03/02 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740088 07/04/13 By chenl   單身無資料，單頭不刪除。
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-840053 08/05/08 By dxfwo  CR報表
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-960130 09/08/06 By Sunyanchun GP5.2 oah03取價方式,不再用
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0016 09/10/31 By post no 
# Modify.........: No.FUN-9C0163 09/12/28 By Cockroach 增加xmb00字段區分axmi500/510單頭，并且取消本作業對xmd_file的資料處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管
# Modify.........: No.MOD-B30132 11/03/11 By Summer _b()不用再CALL _b_fill 
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B80193 11/08/26 By lixia 查詢欄位
# Modify.........: No.TQC-B80233 11/08/30 By Carrier 自动产生单身后,要即时把单身SHOW出来
# Modify.........: No.TQC-BA0011 11/10/08 By destiny xmc09报错信息有误             
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_xmb           RECORD LIKE xmb_file.*,
    g_xmb_t         RECORD LIKE xmb_file.*,   #NO.FUN-9B0016
    g_xmb_o         RECORD LIKE xmb_file.*,
    g_xmb01_t       LIKE xmb_file.xmb01,
    g_xmb02_t       LIKE xmb_file.xmb02,
    g_xmb03_t       LIKE xmb_file.xmb03,
    g_xmb04_t       LIKE xmb_file.xmb04,
    g_xmb05_t       LIKE xmb_file.xmb05,
    g_xmc           DYNAMIC ARRAY OF RECORD
        xmc06       LIKE xmc_file.xmc06,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        xmc07       LIKE xmc_file.xmc07,
        ima908      LIKE ima_file.ima908, #FUN-560193
        xmc08       LIKE xmc_file.xmc08,
        xmc09       LIKE xmc_file.xmc09
                    END RECORD,
    g_xmc_t         RECORD                 #程式變數 (舊值)
        xmc06       LIKE xmc_file.xmc06,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        xmc07       LIKE xmc_file.xmc07,
        ima908      LIKE ima_file.ima908, #FUN-560193
        xmc08       LIKE xmc_file.xmc08,
        xmc09       LIKE xmc_file.xmc09
                    END RECORD,
   #g_wc,g_wc2,g_sql    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(600)
    g_wc,g_wc2,g_sql    STRING,  #TQC-630166   
    g_rec_b         LIKE type_file.num5,              #單身筆數     #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5,              #目前處理的ARRAY CNT    #No.FUN-680137 SMALLINT
    p_row,p_col     LIKE type_file.num5               #No.FUN-680137 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5      #No.FUN-680137 SMALLINT
 
#主程式開始
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose   #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL    
DEFINE g_sql_tmp    STRING   #No.TQC-720019
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   l_table        STRING                       #No.FUN-840053                                                             
DEFINE   l_sql          STRING                       #No.FUN-840053                                                             
DEFINE   g_str          STRING                       #No.FUN-840053
 
MAIN
DEFINE
#       l_time    LIKE type_file.chr8              #No.FUN-6A0094
    p_row,p_col     LIKE type_file.num5              #No.FUN-680137 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
#No.FUN-840053---Begin 
   LET g_sql = " xmb01.xmb_file.xmb01,",
               " xmb02.xmb_file.xmb02,",
               " xmb03.xmb_file.xmb03,",
               " xmb04.xmb_file.xmb04,",
               " xmb05.xmb_file.xmb05,",
               " xmc06.xmc_file.xmc06,",
               " xmc08.xmc_file.xmc08,",
               " oah02.oah_file.oah02,",
               " xmb06.xmb_file.xmb06,",
               " occ02.occ_file.occ02,",
               " oag02.oag_file.oag02,",
               " ima02.ima_file.ima02,",
               " xmc09.xmc_file.xmc09,",
               " ima021.ima_file.ima021,",
               " azi03.azi_file.azi03 "
   LET l_table = cl_prt_temptable('axmi500',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?  )"  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF
            
#No.FUN-840053---End      
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
    LET g_forupd_sql =
        #"SELECT * FROM xmb_file WHERE xmb01=? AND xmb02=? AND xmb03=? AND xmb04=? AND xmb05=? FOR UPDATE"  #FUN-9C0163 MARK
         "SELECT * FROM xmb_file WHERE xmb00='1' AND xmb01=? AND xmb02=? AND xmb03=? AND xmb04=? AND xmb05=? FOR UPDATE" #FUN-9C0163 ADD
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i500_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW i500_w AT p_row,p_col              #顯示畫面
         WITH FORM "axm/42f/axmi500"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-560193................begin
    IF (g_sma.sma116 MATCHES '[01]') THEN    #No.FUN-610076
       CALL cl_set_comp_visible("ima908",FALSE)
    END IF
    #FUN-560193................end
 
    CALL i500_menu()
    CLOSE WINDOW i500_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION i500_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
  CLEAR FORM                             #清除畫面
  CALL g_xmc.clear()
  CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_xmb.* TO NULL    #No.FUN-750051
  CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
         xmb01,xmb03,xmb06,xmb04,xmb02,xmb05,xmb10,
         xmbuser,xmbgrup,xmbmodu,xmbdate,xmboriu,xmborig   #TQC-B80193
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
              WHEN INFIELD(xmb01)
#                    CALL q_oah1(10,3,g_xmb.xmb01) RETURNING g_xmb.xmb01
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_oah1"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO xmb01
                     NEXT FIELD xmb01
              WHEN INFIELD(xmb02)
#                    CALL q_azi(10,3,g_xmb.xmb02) RETURNING g_xmb.xmb02
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO xmb02
                     NEXT FIELD xmb02
              WHEN INFIELD(xmb04)
#                    CALL q_occ(10,3,g_xmb.xmb04) RETURNING g_xmb.xmb04
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_occ"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO xmb04
                     NEXT FIELD xmb04
              WHEN INFIELD(xmb05)
#                    CALL q_oag(10,3,g_xmb.xmb05) RETURNING g_xmb.xmb05
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_oag"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO xmb05
                     NEXT FIELD xmb05
              OTHERWISE EXIT CASE
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
 
  #資料權限的檢查
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN                           #只能使用自己的資料
  #     LET g_wc = g_wc clipped," AND xmbuser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                           #只能使用相同群的資料
  #     LET g_wc = g_wc clipped," AND xmbgrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #     LET g_wc = g_wc clipped," AND xmbgrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('xmbuser', 'xmbgrup')
  #End:FUN-980030
 
 
    CONSTRUCT g_wc2 ON xmc06,xmc07,xmc08,xmc09   #螢幕上取單身條件
            FROM s_xmc[1].xmc06,s_xmc[1].xmc07,s_xmc[1].xmc08,s_xmc[1].xmc09
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(xmc06) #料件編號
#                 CALL q_ima(10,3,g_xmc[1].xmc06) RETURNING g_xmc[1].xmc06
#FUN-AA0059---------mod------------str-----------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.state = 'c'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY g_qryparam.multiret TO xmc06
                  NEXT FIELD xmc06
               WHEN INFIELD(xmc07) #單位
#                 CALL q_gfe(10,3,g_xmc[1].xmc07) RETURNING g_xmc[1].xmc07
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO xmc07
                  NEXT FIELD xmc07
               OTHERWISE EXIT CASE
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT xmb01,xmb02,xmb03,xmb04,xmb05  ",
                   " FROM xmb_file ",
                  #" WHERE ", g_wc CLIPPED,                #FUN-9C0163 MARK
                   " WHERE xmb00='1' AND ", g_wc CLIPPED,  #FUN-9C0163 ADD
                  #" ORDER BY 1,2,3,4,5"                  #FUN-9C0163 MARK
                   " ORDER BY xmb01,xmb02,xmb03,xmb04,xmb05  "  #FUN-9C0163 ADD 
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT xmb01,xmb02,xmb03,xmb04,",
                   " xmb05 ",
                   " FROM xmb_file, xmc_file ",
                   " WHERE xmb01 = xmc01 AND xmb02=xmc02 AND xmb03=xmc03 ",
                   " AND xmc04=xmb04 AND xmc05=xmb05 ",
                   " AND xmb00 ='1' ",                      #FUN-9C0163 ADD
                   " AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  #" ORDER BY 1,2,3,4,5"                 #FUN-9C0163 MARK
                   " ORDER BY xmb01,xmb02,xmb03,xmb04,xmb05  "  #FUN-9C0163 ADD
    END IF
 
    PREPARE i500_prepare FROM g_sql
    DECLARE i500_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i500_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
#      LET g_sql="SELECT COUNT(*) FROM xmb_file WHERE ",g_wc CLIPPED      #No.TQC-720019
       LET g_sql_tmp="SELECT DISTINCT xmb01,xmb02,xmb03,xmb04,xmb05 FROM xmb_file WHERE xmb00='1' AND ",g_wc CLIPPED, #No.TQC-720019  #FUN-9C0163 ADD xmb00
                     "  INTO TEMP x "  #No.TQC-720019
    ELSE
#      LET g_sql="SELECT DISTINCT xmb01,xmb02,xmb03,xmb04,xmb05 ",      #No.TQC-720019
       LET g_sql_tmp="SELECT DISTINCT xmb01,xmb02,xmb03,xmb04,xmb05 ",  #No.TQC-720019
                 "  FROM xmb_file,xmc_file ",
                 " WHERE xmc01=xmb01 AND xmc02=xmb02 AND xmc03=xmb03 ",
                 "   AND xmc04=xmb04 AND xmc05=xmb05 ",
                 "   AND xmb00 ='1' ",                       #FUN-9C0163 ADD
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 "  INTO TEMP x "
    END IF
    #No.TQC-720019  --Begin
    #因主鍵值有多個故所抓出資料筆數有誤
    DROP TABLE x
#   PREPARE i500_precount_x  FROM g_sql      #No.TQC-720019
    PREPARE i500_precount_x  FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i500_precount_x
    LET g_sql="SELECT COUNT(*) FROM x "
    #No.TQC-720019  --End   
    PREPARE i500_precount FROM g_sql
    DECLARE i500_count CURSOR FOR i500_precount
END FUNCTION
 
FUNCTION i500_menu()
 
   WHILE TRUE
      CALL i500_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i500_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i500_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i500_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i500_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i500_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i500_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_xmc),'','')
            END IF
         #No.FUN-6B0079-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
                 IF g_xmb.xmb01 IS NOT NULL THEN            
                    LET g_doc.column1 = "xmb01"               
                    LET g_doc.column2 = "xmb02" 
                    LET g_doc.column3 = "xmb03"
                    LET g_doc.column4 = "xmb04"  
                    LET g_doc.column5 = "xmb05"
                    LET g_doc.value1 = g_xmb.xmb01            
                    LET g_doc.value2 = g_xmb.xmb02
                    LET g_doc.value3 = g_xmb.xmb03
                    LET g_doc.value4 = g_xmb.xmb04
                    LET g_doc.value5 = g_xmb.xmb05
                    CALL cl_doc() 
             END IF 
          END IF
         #No.FUN-6B0079-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i500_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_xmc.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_xmb.* LIKE xmb_file.*             #DEFAULT 設定
    LET g_xmb01_t = NULL
    LET g_xmb02_t = NULL
    LET g_xmb03_t = NULL
    LET g_xmb04_t = NULL
    LET g_xmb05_t = NULL
 
    #預設值及將數值類變數清成零
    LET g_xmb_t.* = g_xmb.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_xmb.xmbuser=g_user
        LET g_xmb.xmboriu = g_user #FUN-980030
        LET g_xmb.xmborig = g_grup #FUN-980030
        LET g_xmb.xmbgrup=g_grup
        LET g_xmb.xmbdate=g_today
        LET g_xmb.xmb00 = '1'      #FUN-9C0163
 
        LET g_xmb.xmb03=g_today          ##default key
        LET g_xmb.xmb06=g_today
 
        CALL i500_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_xmb.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF cl_null(g_xmb.xmb01) OR cl_null(g_xmb.xmb02) OR
           cl_null(g_xmb.xmb03) THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
        INSERT INTO xmb_file VALUES (g_xmb.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
#          CALL cl_err(g_xmb.xmb01,SQLCA.sqlcode,1)   #No.FUN-660167
           CALL cl_err3("ins","xmb_file",g_xmb.xmb01,g_xmb.xmb02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
           CONTINUE WHILE
        END IF
        SELECT xmb01,xmb02,xmb03,xmb04,xmb05 INTO g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,g_xmb.xmb04,g_xmb.xmb05 FROM xmb_file
         WHERE xmb01 = g_xmb.xmb01 AND xmb02 = g_xmb.xmb02
           AND xmb03 = g_xmb.xmb03 AND xmb04 = g_xmb.xmb04
           AND xmb05 = g_xmb.xmb05 AND xmb00 = g_xmb.xmb00    #FUN-9C0163 ADD XMB00
        LET g_xmb01_t = g_xmb.xmb01        #保留舊值
        LET g_xmb02_t = g_xmb.xmb02
        LET g_xmb03_t = g_xmb.xmb03
        LET g_xmb04_t = g_xmb.xmb04
        LET g_xmb05_t = g_xmb.xmb05
        LET g_xmb_t.* = g_xmb.*
        CALL g_xmc.clear()
        LET g_rec_b = 0
        CALL i500_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i500_g_b()
   DEFINE l_wc          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(300)
   DEFINE l_ima         RECORD LIKE ima_file.*
   DEFINE l_ima01       LIKE ima_file.ima01
   DEFINE l_sql         LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(300)
   DEFINE l_cnt         LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE l_obk         RECORD LIKE obk_file.*
   DEFINE l_occ02       LIKE occ_file.occ02
   DEFINE l_xmc         RECORD LIKE xmc_file.*
  #DEFINE l_xmd         RECORD LIKE xmd_file.*        #FUN-9C0163 MARK
 
   SELECT COUNT(*) INTO g_cnt FROM xmc_file
    WHERE xmc01=g_xmb.xmb01 AND xmc02=g_xmb.xmb02 AND xmc03=g_xmb.xmb03
      AND xmc04=g_xmb.xmb04 AND xmc05=g_xmb.xmb05
   IF g_cnt > 0 THEN            #已有單身則不可再產生
      RETURN
   ELSE
      IF NOT cl_confirm('axr-321') THEN RETURN END IF
   END IF
 
   LET p_row = 8 LET p_col = 18
   OPEN WINDOW i500_w1 AT p_row,p_col         #顯示畫面
        WITH FORM "axm/42f/axmi5001"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axmi5001")
 
 
   CALL cl_opmsg('q')
 
   CONSTRUCT BY NAME l_wc ON ima06,ima01
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

#FUN-9C0163 ADD START------------------------------------
      ON ACTION controlp
         CASE
           WHEN INFIELD(ima01)
#FUN-AA0059---------mod------------str-----------------           
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima02"
#                LET g_qryparam.state = 'c'
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_sel_ima(TRUE, "q_ima02","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

                DISPLAY g_qryparam.multiret TO ima01
                NEXT FIELD ima01              
         END CASE  
#FUN-9C0163 ADD END---------------------------------------- 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i500_w1
      RETURN
   END IF
 
   INITIALIZE l_xmc.* TO NULL
   LET l_xmc.xmc01 = g_xmb.xmb01
   LET l_xmc.xmc02 = g_xmb.xmb02
   LET l_xmc.xmc03 = g_xmb.xmb03
   LET l_xmc.xmc04 = g_xmb.xmb04
   LET l_xmc.xmc05 = g_xmb.xmb05
 
#No.FUN-9C0163 MARK START-------------------------------
# ------因用XMB00區分axmi500/510兩支作業，所以不再往xmd_file里插數據
#  INITIALIZE l_xmd.* TO NULL
#  LET l_xmd.xmd01 = g_xmb.xmb01
#  LET l_xmd.xmd02 = g_xmb.xmb02
#  LET l_xmd.xmd03 = g_xmb.xmb03
#  LET l_xmd.xmd04 = g_xmb.xmb04
#  LET l_xmd.xmd05 = g_xmb.xmb05
 
   IF l_wc =" 1=1" THEN        ###1,2未輸入
      LET l_sql = "SELECT * FROM obk_file ",
                  " WHERE obk02 ='",g_xmb.xmb04,"' AND obk05 ='",g_xmb.xmb02,"'"
      PREPARE i5001_prepare1 FROM l_sql
      IF STATUS THEN CALL cl_err('i5001_pre',STATUS,0) RETURN END IF
      DECLARE i5001_cs1 CURSOR FOR i5001_prepare1
      FOREACH i5001_cs1 INTO l_obk.*
          IF cl_null(l_obk.obk07) THEN LET l_obk.obk07=' ' END IF
          IF cl_null(l_obk.obk08) THEN LET l_obk.obk08=0 END IF
          LET l_xmc.xmc06 = l_obk.obk01
          LET l_xmc.xmc07 = l_obk.obk07
          LET l_xmc.xmc08 = l_obk.obk08
          LET l_xmc.xmc09 = 100
          INSERT INTO xmc_file VALUES(l_xmc.*)
          IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#            CALL cl_err('ins xmc',STATUS,0)  #No.FUN-660167
             CALL cl_err3("ins","xmc_file",l_xmc.xmc01,l_xmc.xmc02,STATUS,"","ins xmc",1)  #No.FUN-660167
             EXIT FOREACH  
          END IF
#         LET l_xmd.xmd06 = l_obk.obk01
#         LET l_xmd.xmd07 = l_obk.obk07
#         LET l_xmd.xmd08 = 0
#         LET l_xmd.xmd09 = 100
#         INSERT INTO xmd_file VALUES(l_xmd.*)
#         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
##           CALL cl_err('ins xmd',STATUS,0)  #No.FUN-660167
#            CALL cl_err3("ins","xmd_file",l_xmd.xmd01,l_xmd.xmd06,STATUS,"","ins xmd",1)  #No.FUN-660167
#            EXIT FOREACH  
#         END IF
      END FOREACH
   ELSE               #########1,2輸入條件
      LET l_sql = "SELECT * FROM ima_file WHERE ",l_wc CLIPPED
      PREPARE i5001_prepare FROM l_sql
      IF STATUS THEN CALL cl_err('i5001_pre2',STATUS,0) RETURN END IF
      DECLARE i5001_cs CURSOR FOR i5001_prepare
      FOREACH i5001_cs INTO l_ima.*
          IF cl_null(l_ima.ima31) THEN LET l_ima.ima31=' ' END IF
          IF cl_null(l_ima.ima33) THEN LET l_ima.ima33=0 END IF
          LET l_xmc.xmc06 = l_ima.ima01
          LET l_xmc.xmc07 = l_ima.ima31
          LET l_xmc.xmc08 = l_ima.ima33
          LET l_xmc.xmc09 = 100
          INSERT INTO xmc_file VALUES(l_xmc.*)
          IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#            CALL cl_err('ins xmc',STATUS,0)  #No.FUN-660167
             CALL cl_err3("ins","xmc_file",l_xmc.xmc01,l_xmc.xmc02,STATUS,"","ins xmc",1)  #No.FUN-660167
             EXIT FOREACH  
          END IF
#         LET l_xmd.xmd06 = l_ima.ima01
#         LET l_xmd.xmd07 = l_ima.ima31
#         LET l_xmd.xmd08 = 0
#         LET l_xmd.xmd09 = 100
#         INSERT INTO xmd_file VALUES(l_xmd.*)
#         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
##           CALL cl_err('ins xmd',STATUS,0)   #No.FUN-660167
#            CALL cl_err3("ins","xmd_file",l_xmd.xmd01,l_xmd.xmd06,STATUS,"","ins xmd",1)  #No.FUN-660167
#            EXIT FOREACH 
#         END IF
#No.FUN-9C0163 MARK END------------------------------------
      END FOREACH
   END IF
   CALL i500_b_fill('1=1') #TQC-B80233
   CLOSE WINDOW i500_w1
END FUNCTION
 
FUNCTION i500_u()
    IF s_shut(0) THEN RETURN END IF
 
    IF cl_null(g_xmb.xmb01) OR cl_null(g_xmb.xmb02) OR cl_null(g_xmb.xmb03) THEN
       CALL cl_err('',-400,0) RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_success = 'Y'
    BEGIN WORK
    OPEN i500_cl USING g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,g_xmb.xmb04,g_xmb.xmb05
    IF STATUS THEN
       CALL cl_err("OPEN i500_cl:", STATUS, 1)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i500_cl INTO g_xmb.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_xmb.xmb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i500_cl
        ROLLBACK WORK
        RETURN
    END IF
    CALL i500_show()
    WHILE TRUE
        LET g_xmb01_t = g_xmb.xmb01
        LET g_xmb02_t = g_xmb.xmb02
        LET g_xmb03_t = g_xmb.xmb03
        LET g_xmb04_t = g_xmb.xmb04
        LET g_xmb05_t = g_xmb.xmb05
        LET g_xmb_t.* = g_xmb.*
        LET g_xmb.xmbmodu=g_user
        LET g_xmb.xmbdate=g_today
        CALL i500_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_xmb.*=g_xmb_t.*
            CALL i500_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_xmb.xmb01 != g_xmb01_t OR g_xmb.xmb02 != g_xmb02_t OR
           g_xmb.xmb03 != g_xmb03_t OR g_xmb.xmb04 != g_xmb04_t OR
           g_xmb.xmb05 != g_xmb05_t  THEN            # 更改單號
           UPDATE xmc_file SET xmc01 = g_xmb.xmb01, xmc02 = g_xmb.xmb02,
                               xmc03 = g_xmb.xmb03, xmc04 = g_xmb.xmb04,
                               xmc05 = g_xmb.xmb05
            WHERE xmc01 = g_xmb01_t AND xmc02 = g_xmb02_t
              AND xmc03 = g_xmb03_t AND xmc04 = g_xmb04_t
              AND xmc05 = g_xmb05_t
           IF STATUS THEN
#             CALL cl_err('upd xmc',SQLCA.sqlcode,0) #No.FUN-660167
              CALL cl_err3("upd","xmc_file",g_xmb01_t,g_xmb02_t,SQLCA.sqlcode,"","upd xmc",1)  #No.FUN-660167
              CONTINUE WHILE   
           END IF

         #No.FUN-9C0163  MARK START---------------------------------------   
         # UPDATE xmd_file SET xmd01 = g_xmb.xmb01, xmd02 = g_xmb.xmb02,
         #                     xmd03 = g_xmb.xmb03, xmd04 = g_xmb.xmb04,
         #                     xmd05 = g_xmb.xmb05
         #  WHERE xmd01 = g_xmb01_t AND xmd02 = g_xmb02_t
         #    AND xmd03 = g_xmb03_t AND xmd04 = g_xmb04_t
         #    AND xmd05 = g_xmb05_t
         #No.FUN-9C0163 MARK END--------------------------------------
        END IF
         UPDATE xmb_file SET xmb_file.* = g_xmb.* WHERE xmb01 = g_xmb01_t AND xmb02=g_xmb02_t AND xmb03=g_xmb03_t AND xmb04=g_xmb04_t AND xmb05=g_xmb05_t 
                                                    AND xmb00 = '1'    #FUN-9C0163 ADD 
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err(g_xmb.xmb01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","xmb_file",g_xmb01_t,g_xmb02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i500_cl
    IF g_success = 'Y' THEN COMMIT WORK END IF
END FUNCTION
 
#處理INPUT
FUNCTION i500_i(p_cmd)
DEFINE
    l_oah02    LIKE oah_file.oah02,
    l_occ02    LIKE occ_file.occ02,
    l_oag02    LIKE oag_file.oag02,
    l_xmb06    LIKE xmb_file.xmb06,
    l_n		LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    p_cmd           LIKE type_file.chr1       #a:輸入 u:更改        #No.FUN-680137 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT BY NAME g_xmb.xmboriu,g_xmb.xmborig,
        g_xmb.xmb01,g_xmb.xmb03,g_xmb.xmb06,g_xmb.xmb04,g_xmb.xmb02,
        g_xmb.xmb05,g_xmb.xmb10,g_xmb.xmbuser,g_xmb.xmbmodu,
        g_xmb.xmbgrup,g_xmb.xmbdate WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i500_set_entry(p_cmd)
            CALL i500_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            LET g_xmb.xmb00 ='1'      #FUN-9C0163 ADD
 
        AFTER FIELD xmb01
            IF NOT cl_null(g_xmb.xmb01) THEN
                SELECT oah02 INTO l_oah02 FROM oah_file WHERE oah01=g_xmb.xmb01
                                                           #AND oah03='4' #MOD-530334   #NO.FUN-960130
                IF STATUS THEN
#                  CALL cl_err(g_xmb.xmb01,'mfg4101',0)   #No.FUN-660167
                   CALL cl_err3("sel","oah_file",g_xmb.xmb01,"","mfg4101","","",1)  #No.FUN-660167
                   NEXT FIELD xmb01 
                END IF
                DISPLAY l_oah02 TO FORMONLY.oah02
            END IF
 
        AFTER FIELD xmb02
            IF NOT cl_null(g_xmb.xmb02) THEN
                SELECT COUNT(*) INTO l_n FROM azi_file WHERE azi01=g_xmb.xmb02
                                                          AND aziacti='Y' #MOD-530334
                IF l_n <= 0 THEN
                   CALL cl_err(g_xmb.xmb02,'mfg3008',1) NEXT FIELD xmb02
                END IF
            END IF
 
        AFTER FIELD xmb06
            IF NOT cl_null(g_xmb.xmb06) THEN
                IF g_xmb.xmb06<g_xmb.xmb03 THEN
                   CALL cl_err(g_xmb.xmb06,'mfg3009',0) NEXT FIELD xmb06
                END IF
            END IF
 
        AFTER FIELD xmb04
            LET g_errno=' '
            IF NOT cl_null(g_xmb.xmb04) THEN
               CALL i500_xmb04(p_cmd)
               IF g_errno!=' ' THEN
                  CALL cl_err(g_xmb.xmb04,g_errno,0)
                  LET g_xmb.xmb04 = g_xmb_t.xmb04
                  DISPLAY BY NAME g_xmb.xmb04
                  NEXT FIELD xmb04
               END IF
            END IF
            IF g_xmb.xmb04 IS NULL THEN LET g_xmb.xmb04=' ' END IF
 
        AFTER FIELD xmb05
            LET g_errno=' '
            IF NOT cl_null(g_xmb.xmb05) THEN
               CALL i500_xmb05(p_cmd)
               IF g_errno!=' ' THEN
                  CALL cl_err(g_xmb.xmb05,g_errno,0)
                  LET g_xmb.xmb05=g_xmb_t.xmb05
                  DISPLAY BY NAME g_xmb.xmb05
                  NEXT FIELD xmb05
               END IF
            END IF
            IF g_xmb.xmb05 IS NULL THEN LET g_xmb.xmb05=' ' END IF
 
            IF p_cmd = "a" OR (p_cmd = "u" AND
               (g_xmb.xmb01 != g_xmb_t.xmb01 OR g_xmb.xmb02 != g_xmb_t.xmb02 OR
                g_xmb.xmb03 != g_xmb_t.xmb03 OR g_xmb.xmb04 != g_xmb_t.xmb04 OR
                g_xmb.xmb05 != g_xmb_t.xmb05)) THEN
               SELECT COUNT(*) INTO g_cnt FROM xmb_file
                WHERE xmb01=g_xmb.xmb01 AND xmb02=g_xmb.xmb02
                  AND xmb03=g_xmb.xmb03 AND xmb04=g_xmb.xmb04
                  AND xmb05=g_xmb.xmb05 AND xmb00='1'     #FUN-9C0163 ADD XMB00 
               IF g_cnt > 0 THEN                           # Duplicated
                  CALL cl_err(g_xmb.xmb05,-239,0) NEXT FIELD xmb05
               END IF
            END IF
             IF p_cmd = "a" OR (p_cmd = "u"
                                AND (g_xmb.xmb01 != g_xmb_t.xmb01
                                  OR g_xmb.xmb02 != g_xmb_t.xmb02
                                  OR g_xmb.xmb04 != g_xmb_t.xmb04
                                  OR g_xmb.xmb05 != g_xmb_t.xmb05)) THEN
                 #BugNo:6640
                 SELECT COUNT(*) INTO g_cnt FROM xmb_file
                     WHERE g_xmb.xmb03 BETWEEN xmb03 AND xmb06
                       AND xmb01=g_xmb.xmb01
                       AND xmb02=g_xmb.xmb02
                       AND xmb04=g_xmb.xmb04
                       AND xmb05=g_xmb.xmb05
                       AND xmb00=g_xmb.xmb00            #FUN-9C0163 ADD
 
                 IF g_cnt > 0 THEN                           # Duplicated
                     CALL cl_err('','-239',0)
                     LET g_xmb.xmb03 = g_xmb_t.xmb03
                     LET g_xmb.xmb06 = g_xmb_t.xmb06
                     DISPLAY BY NAME g_xmb.xmb03
                     DISPLAY BY NAME g_xmb.xmb06
                     NEXT FIELD xmb03
                  END IF
            END IF
 
         #MOD-560207................begin
        AFTER INPUT
           LET g_xmb.xmbuser = s_get_data_owner("xmb_file") #FUN-C10039
           LET g_xmb.xmbgrup = s_get_data_group("xmb_file") #FUN-C10039
            IF cl_null(g_xmb.xmb04) THEN LET g_xmb.xmb04=' ' END IF
            IF cl_null(g_xmb.xmb05) THEN LET g_xmb.xmb05=' ' END IF
         #MOD-560207................end
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
      #MOD-650015 --start
      #  ON ACTION CONTROLO                        # 沿用所有欄位
      #      IF INFIELD(xmb01) THEN
      #          LET g_xmb.* = g_xmb_t.*
      #          DISPLAY BY NAME g_xmb.*
      #          NEXT FIELD xmb01
      #      END IF
      #MOD-650015 --end
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
            CASE
              WHEN INFIELD(xmb01)
#                    CALL q_oah1(10,3,g_xmb.xmb01) RETURNING g_xmb.xmb01
#                    CALL FGL_DIALOG_SETBUFFER( g_xmb.xmb01 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_oah1"
                     LET g_qryparam.default1 = g_xmb.xmb01
                     CALL cl_create_qry() RETURNING g_xmb.xmb01
#                     CALL FGL_DIALOG_SETBUFFER( g_xmb.xmb01 )
                     DISPLAY BY NAME g_xmb.xmb01
              WHEN INFIELD(xmb02)
#                    CALL q_azi(10,3,g_xmb.xmb02) RETURNING g_xmb.xmb02
#                    CALL FGL_DIALOG_SETBUFFER( g_xmb.xmb02 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi"
                     LET g_qryparam.default1 = g_xmb.xmb02
                     CALL cl_create_qry() RETURNING g_xmb.xmb02
#                     CALL FGL_DIALOG_SETBUFFER( g_xmb.xmb02 )
                     DISPLAY BY NAME g_xmb.xmb02
              WHEN INFIELD(xmb04)
#                    CALL q_occ(10,3,g_xmb.xmb04) RETURNING g_xmb.xmb04
#                    CALL FGL_DIALOG_SETBUFFER( g_xmb.xmb04 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_occ"
                     LET g_qryparam.default1 = g_xmb.xmb04
                     CALL cl_create_qry() RETURNING g_xmb.xmb04
#                     CALL FGL_DIALOG_SETBUFFER( g_xmb.xmb04 )
                     DISPLAY BY NAME g_xmb.xmb04
              WHEN INFIELD(xmb05)
#                    CALL q_oag(10,3,g_xmb.xmb05) RETURNING g_xmb.xmb05
#                    CALL FGL_DIALOG_SETBUFFER( g_xmb.xmb05 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_oag"
                     LET g_qryparam.default1 = g_xmb.xmb05
                     CALL cl_create_qry() RETURNING g_xmb.xmb05
#                     CALL FGL_DIALOG_SETBUFFER( g_xmb.xmb05 )
                     DISPLAY BY NAME g_xmb.xmb05
              OTHERWISE EXIT CASE
            END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i500_xmb01(p_cmd)  #價格條件
    DEFINE
           l_oah02   LIKE oah_file.oah02,
           p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    LET g_chr = ' '
    IF g_xmb.xmb01 IS NULL THEN
       LET g_chr='E'
       LET l_oah02=NULL
    ELSE
       SELECT oah02 INTO l_oah02 FROM oah_file
        WHERE oah01=g_xmb.xmb01 #AND oah03 = '4'   #NO.FUN-960130
        IF SQLCA.sqlcode THEN
            LET g_chr = 'E'
            LET l_oah02 = NULL
        END IF
    END IF
    IF cl_null(g_chr) OR p_cmd = 'd' THEN
       DISPLAY l_oah02 TO FORMONLY.oah02
    END IF
END FUNCTION
 
FUNCTION i500_xmb04(p_cmd)
    DEFINE l_occ02    LIKE occ_file.occ02,
           p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
  LET g_errno = " "
  SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = g_xmb.xmb04
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-045'
                                 LET l_occ02 = NULL
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_occ02 TO FORMONLY.occ02
  END IF
END FUNCTION
 
 
FUNCTION i500_xmb05(p_cmd)
    DEFINE l_oag02   LIKE oag_file.oag02,
           p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT oag02 INTO l_oag02 FROM oag_file WHERE oag01 = g_xmb.xmb05
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9357'
                                   LET l_oag02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_oag02 TO FORMONLY.oag02
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION i500_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_xmb.* TO NULL               #No.FUN-6B0079 add
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_xmc.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i500_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_xmb.* TO NULL
        RETURN
    END IF
    OPEN i500_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_xmb.* TO NULL
    ELSE
        OPEN i500_count
        FETCH i500_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i500_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i500_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i500_cs INTO g_xmb.xmb01,
                                             g_xmb.xmb02,g_xmb.xmb03,
                                             g_xmb.xmb04,g_xmb.xmb05
        WHEN 'P' FETCH PREVIOUS i500_cs INTO g_xmb.xmb01,
                                             g_xmb.xmb02,g_xmb.xmb03,
                                             g_xmb.xmb04,g_xmb.xmb05
        WHEN 'F' FETCH FIRST    i500_cs INTO g_xmb.xmb01,
                                             g_xmb.xmb02,g_xmb.xmb03,
                                             g_xmb.xmb04,g_xmb.xmb05
        WHEN 'L' FETCH LAST     i500_cs INTO g_xmb.xmb01,
                                             g_xmb.xmb02,g_xmb.xmb03,
                                             g_xmb.xmb04,g_xmb.xmb05
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i500_cs INTO g_xmb.xmb01,
                                               g_xmb.xmb02,g_xmb.xmb03,
                                               g_xmb.xmb04,g_xmb.xmb05
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_xmb.xmb01,SQLCA.sqlcode,0)
        INITIALIZE g_xmb.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_xmb.* FROM xmb_file WHERE xmb01 = g_xmb.xmb01 AND xmb02=g_xmb.xmb02 AND xmb03=g_xmb.xmb03 AND xmb04=g_xmb.xmb04 AND xmb05=g_xmb.xmb05 
                                          AND xmb00 = '1'                        #FUN-9C0163 ADD
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_xmb.xmb01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","xmb_file",g_xmb.xmb01,g_xmb.xmb02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
       INITIALIZE g_xmb.* TO NULL
       RETURN
    END IF
    LET g_data_owner = g_xmb.xmbuser      #FUN-4C0057 add
    LET g_data_group = g_xmb.xmbgrup      #FUN-4C0057 add
    CALL i500_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i500_show()
    LET g_xmb_t.* = g_xmb.*                #保存單頭舊值
    DISPLAY BY NAME g_xmb.xmboriu,g_xmb.xmborig,                              # 顯示單頭值
        g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,g_xmb.xmb06,
        g_xmb.xmb04,g_xmb.xmb05,g_xmb.xmb10,
        g_xmb.xmbuser,g_xmb.xmbgrup,g_xmb.xmbmodu,g_xmb.xmbdate
 
    CALL i500_xmb01('d')
    CALL i500_xmb04('d')
    CALL i500_xmb05('d')
 
    CALL i500_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i500_r()
DEFINE l_chr LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_xmb.xmb01) OR cl_null(g_xmb.xmb02) OR cl_null(g_xmb.xmb03) THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    SELECT * INTO g_xmb.* FROM xmb_file
     WHERE xmb01=g_xmb.xmb01 AND xmb02=g_xmb.xmb02
       AND xmb03=g_xmb.xmb03 AND xmb04=g_xmb.xmb04
       AND xmb05=g_xmb.xmb05 AND xmb00=g_xmb.xmb00   #FUN-9C0163 ADD XMB00 
 
    LET g_success = 'Y'
    BEGIN WORK
    OPEN i500_cl USING g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,g_xmb.xmb04,g_xmb.xmb05
    IF STATUS THEN
       CALL cl_err("OPEN i500_cl:", STATUS, 1) 
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i500_cl INTO g_xmb.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_xmb.xmb01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i500_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "xmb01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "xmb02"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "xmb03"         #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "xmb04"         #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "xmb05"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_xmb.xmb01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_xmb.xmb02      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_xmb.xmb03      #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_xmb.xmb04      #No.FUN-9B0098 10/02/24
        LET g_doc.value5 = g_xmb.xmb05      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM xmb_file WHERE xmb01 = g_xmb.xmb01 AND xmb02 = g_xmb.xmb02
                              AND xmb03 = g_xmb.xmb03 AND xmb04 = g_xmb.xmb04
                              AND xmb05 = g_xmb.xmb05 AND xmb00=g_xmb.xmb00   #FUN-9C0163 ADD XMB00
       IF STATUS THEN 
#         CALL cl_err('del xmb',STATUS,0)   #No.FUN-660167
          CALL cl_err3("del","xmb_file",g_xmb.xmb01,g_xmb.xmb02,STATUS,"","del xmb",1)  #No.FUN-660167
          LET g_success='N' 
       END IF
       DELETE FROM xmc_file WHERE xmc01 = g_xmb.xmb01 AND xmc02 = g_xmb.xmb02
                              AND xmc03 = g_xmb.xmb03 AND xmc04 = g_xmb.xmb04
                              AND xmc05 = g_xmb.xmb05
       IF STATUS THEN 
#         CALL cl_err('del xmc',STATUS,0)   #No.FUN-660167
          CALL cl_err3("del","xmc_file",g_xmb.xmb01,g_xmb.xmb02,STATUS,"","del xmc",1)  #No.FUN-660167
          LET g_success='N' 
       END IF
#No.FUN-9C0163  MARK START--------------------------------------------
#      DELETE FROM xmd_file WHERE xmd01 = g_xmb.xmb01 AND xmd02 = g_xmb.xmb02
#                             AND xmd03 = g_xmb.xmb03 AND xmd04 = g_xmb.xmb04
#                             AND xmd05 = g_xmb.xmb05
#      IF STATUS THEN 
##        CALL cl_err('del xmd',STATUS,0)   #No.FUN-660167
#         CALL cl_err3("del","xmd_file",g_xmb.xmb01,g_xmb.xmb02,STATUS,"","del xmd",1)  #No.FUN-660167
#         LET g_success='N' 
#      END IF
#No.FUN-9C0163 MARK END------------------------------------------------
       CLEAR FORM
       CALL g_xmc.clear()
       INITIALIZE g_xmb.* TO NULL
       DROP TABLE x  #No.TQC-720019
       PREPARE i500_precount_x2 FROM g_sql_tmp  #No.TQC-720019
       EXECUTE i500_precount_x2                 #No.TQC-720019
       OPEN i500_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i500_cs
          CLOSE i500_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i500_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i500_cs
          CLOSE i500_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i500_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i500_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i500_fetch('/')
       END IF
    END IF
    CLOSE i500_cl
    IF g_success = 'Y' THEN COMMIT WORK END IF
END FUNCTION
 
#單身
FUNCTION i500_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680137 VARCHAR(1)
    l_sw            LIKE type_file.chr1,                #wip or storage  #No.FUN-680137 
    l_i             LIKE type_file.num5,                #No.FUN-680137 SMALLINT
    l_swl           LIKE type_file.num5,                #No.FUN-680137 SMALLINT
    l_s             LIKE type_file.num5,                #No.FUN-680137 SMALLINT
    l_xmc06         LIKE xmc_file.xmc06,
    l_xmc08         LIKE xmc_file.xmc08,
    l_xmc09         LIKE xmc_file.xmc09,
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    l_p             LIKE type_file.num5,                #No.FUN-680137 SMALLINT
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
#FUN-9C0163 ADD START--------------------
DEFINE 
    l_ima31         LIKE ima_file.ima31,
    l_flag          LIKE type_file.chr1,
    l_fac           LIKE type_file.num20_6,
    l_msg           LIKE type_file.chr1000
#FUN-9C0163 ADD END----------------------- 
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_xmb.xmb01) OR cl_null(g_xmb.xmb02) OR cl_null(g_xmb.xmb03) THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    SELECT * INTO g_xmb.* FROM xmb_file
     WHERE xmb01=g_xmb.xmb01
       AND xmb02=g_xmb.xmb02
       AND xmb03=g_xmb.xmb03
       AND xmb04=g_xmb.xmb04
       AND xmb05=g_xmb.xmb05
       AND xmb00=g_xmb.xmb00     #FUN-9C0163 ADD 
 
    CALL i500_g_b()                 #auto input body
   #CALL i500_b_fill('1=1') #MOD-B30132 mark
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
     #" SELECT xmc06,'','',xmc07,xmc08,xmc09 ",    #TQC-640058 mark
      " SELECT xmc06,'','',xmc07,'',xmc08,xmc09 ", #TQC-640058 add
      " FROM xmc_file ",
      "  WHERE xmc01= ? ",
      "   AND xmc02= ? ",
      "   AND xmc03= ? ",
      "   AND xmc04= ? ",
      "   AND xmc05= ? ",
      "   AND xmc06= ? ",
      "   AND xmc07= ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i500_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_xmc
              WITHOUT DEFAULTS
              FROM s_xmc.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_swl = 0
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            LET g_success = 'Y'
            BEGIN WORK
            OPEN i500_cl USING g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,g_xmb.xmb04,g_xmb.xmb05
            IF STATUS THEN
               CALL cl_err("OPEN i500_cl:", STATUS, 1)
               CLOSE i500_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i500_cl INTO g_xmb.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_xmb.xmb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i500_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_xmc_t.* = g_xmc[l_ac].*  #BACKUP
               OPEN i500_bcl USING g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,
                                   g_xmb.xmb04,g_xmb.xmb05,g_xmc_t.xmc06,
                                   g_xmc_t.xmc07
               IF STATUS THEN
                   CALL cl_err("OPEN i520_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
               ELSE
                   FETCH i500_bcl INTO g_xmc[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_xmc_t.xmc06,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   CALL i500_xmc06('d')             ##show occ02
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            LET g_before_input_done = FALSE
            CALL i500_set_entry_b(p_cmd)
            CALL i500_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_xmc[l_ac].* TO NULL      #900423
            LET g_xmc_t.* = g_xmc[l_ac].*         #新輸入資料
            LET g_before_input_done = FALSE
            CALL i500_set_entry_b(p_cmd)
            CALL i500_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
            LET g_xmc[l_ac].xmc08 =  0            #Body default
            LET g_xmc[l_ac].xmc09 =  100          #Body default
            LET g_xmc_t.* = g_xmc[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD xmc06
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO xmc_file(xmc01,xmc02,xmc03,xmc04,xmc05,xmc06,
                                 xmc07,xmc08,xmc09)
                          VALUES(g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,
                                 g_xmb.xmb04,g_xmb.xmb05,
                                 g_xmc[l_ac].xmc06,g_xmc[l_ac].xmc07,
                                 g_xmc[l_ac].xmc08,g_xmc[l_ac].xmc09)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_xmc[l_ac].xmc06,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("ins","xmc_file",g_xmb.xmb01,g_xmc[l_ac].xmc06,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               CANCEL INSERT
               LET g_success = 'N'
            ELSE
               MESSAGE 'INSERT O.K'
               IF g_success = 'Y' THEN
                   COMMIT WORK
               END IF
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
#No.FUN-9C0163  MARK START-----------------------------------------------
#           INSERT INTO xmd_file(xmd01,xmd02,xmd03,xmd04,xmd05,xmd06,
#                                xmd07,xmd08,xmd09)
#                         VALUES(g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,
#                                g_xmb.xmb04,g_xmb.xmb05,
#                                g_xmc[l_ac].xmc06,g_xmc[l_ac].xmc07,
#                                0,0)
#           IF SQLCA.sqlcode THEN
##             CALL cl_err('xmd',SQLCA.sqlcode,0)   #No.FUN-660167
#              CALL cl_err3("ins","xmd_file",g_xmb.xmb01,g_xmc[l_ac].xmc06,SQLCA.sqlcode,"","xmd",1)  #No.FUN-660167
#              LET g_success = 'N'
#           END IF
#No.FUN-9C0163 MARK END------------------------------------------------- 
        AFTER FIELD xmc06
            IF NOT cl_null(g_xmc[l_ac].xmc06) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_xmc[l_ac].xmc06,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_xmc[l_ac].xmc06= g_xmc_t.xmc06
                 NEXT FIELD xmc06
              END IF
#FUN-AA0059 ---------------------end-------------------------------
                IF p_cmd='a' OR (p_cmd='u' AND
                   g_xmc[l_ac].xmc06 != g_xmc_t.xmc06) THEN
                   CALL i500_xmc06('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_xmc[l_ac].xmc06,g_errno,0)
                      LET g_xmc[l_ac].xmc06 = g_xmc_t.xmc06
                      NEXT FIELD xmc06
                   END IF
                END IF
            END IF            
 
       BEFORE FIELD xmc07
            IF NOT cl_null(g_xmc[l_ac].xmc06) THEN
                IF p_cmd='a' OR (p_cmd='u' AND
                   g_xmc[l_ac].xmc06 != g_xmc_t.xmc06 ) THEN
                   CALL i500_xmc06('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_xmc[l_ac].xmc06,g_errno,0)
                      LET g_xmc[l_ac].xmc06 = g_xmc_t.xmc06
                      NEXT FIELD xmc06
                   END IF
                END IF
            END IF
 
        AFTER FIELD xmc07                  #詢價單位
            IF NOT cl_null(g_xmc[l_ac].xmc07) THEN
                IF p_cmd='a' OR (p_cmd='u' AND
                   g_xmc[l_ac].xmc07 != g_xmc_t.xmc07) THEN
                   CALL i500_xmc07()
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_xmc[l_ac].xmc07,g_errno,0)
                      LET g_xmc[l_ac].xmc07 = g_xmc_t.xmc07
                      NEXT FIELD xmc07
                   #FUN-9C0163 ADD START---------------------
                   ELSE 
                      IF NOT cl_null(g_xmc[l_ac].xmc06) THEN
                         SELECT ima31 INTO l_ima31 FROM ima_file
                          WHERE ima01 = g_xmc[l_ac].xmc06
                         CALL s_umfchk(g_xmc[l_ac].xmc06,g_xmc[l_ac].xmc07
                                       ,l_ima31)
                         RETURNING l_flag,l_fac
                         IF l_flag = 1 THEN 
                            LET l_msg = l_ima31 CLIPPED,'->',
                                        g_xmc[l_ac].xmc07 CLIPPED    
                            CALL cl_err(l_msg CLIPPED,'mfg2719',0)
                            NEXT FIELD xmc07
                         END IF
                      END IF
                  #FUN-9C0163 ADD END--------------------------       
                   END IF
                END IF
            END IF
 
        AFTER FIELD xmc08
            IF NOT cl_null(g_xmc[l_ac].xmc08) THEN
                IF g_xmc[l_ac].xmc08 < 0 THEN
                   CALL cl_err(g_xmc[l_ac].xmc08,'aom-557',0)  #No.TQC-6B0129
                    NEXT FIELD xmc08
                END IF
            END IF
 
        AFTER FIELD xmc09                 #折扣比率
            IF NOT cl_null(g_xmc[l_ac].xmc09) THEN
                IF g_xmc[l_ac].xmc09 < 0 OR g_xmc[l_ac].xmc09 > 100 THEN
                   #CALL cl_err(g_xmc[l_ac].xmc09,'mfg0013',0)    #TQC-BA0011
                    CALL cl_err(g_xmc[l_ac].xmc09,'aec-002',0)    #TQC-BA0011     
                    LET g_xmc[l_ac].xmc09 = g_xmc_t.xmc09
                    #------MOD-5A0095 START----------
                    DISPLAY BY NAME g_xmc[l_ac].xmc09
                    #------MOD-5A0095 END------------
                    NEXT FIELD xmc09
                END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_xmc_t.xmc06 IS NOT NULL AND g_xmc_t.xmc07 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM xmc_file
                    WHERE xmc01 = g_xmb.xmb01 AND xmc02 = g_xmb.xmb02 AND
                          xmc03 = g_xmb.xmb03 AND xmc04 = g_xmb.xmb04 AND
                          xmc05 = g_xmb.xmb05 AND xmc06 = g_xmc_t.xmc06 AND
                          xmc07 = g_xmc_t.xmc07
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_xmc_t.xmc06,SQLCA.sqlcode,0)   #No.FUN-660167
                    CALL cl_err3("del","xmc_file",g_xmb.xmb01,g_xmc_t.xmc06,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
#No.FUN-9C0163    MARK START------------------------------------------
#               DELETE FROM xmd_file
#                   WHERE xmd01 = g_xmb.xmb01 AND xmd02 = g_xmb.xmb02 AND
#                         xmd03 = g_xmb.xmb03 AND xmd04 = g_xmb.xmb04 AND
#                         xmd05 = g_xmb.xmb05 AND xmd06 = g_xmc_t.xmc06 AND
#                         xmd07 = g_xmc_t.xmc07
#               IF SQLCA.sqlcode THEN
##                  CALL cl_err(g_xmc_t.xmc06,SQLCA.sqlcode,0)   #No.FUN-660167
#                   CALL cl_err3("del","xmd_file",g_xmb.xmb01,g_xmc_t.xmc06,SQLCA.sqlcode,"","",1)  #No.FUN-660167
#                   ROLLBACK WORK
#                   CANCEL DELETE
#               END IF
#No.FUN-9C0163   MARK END-------------------------------------------------
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_xmc[l_ac].* = g_xmc_t.*
               CLOSE i500_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_xmc[l_ac].xmc06,-263,1)
                LET g_xmc[l_ac].* = g_xmc_t.*
            ELSE
                UPDATE xmc_file SET xmc06=g_xmc[l_ac].xmc06,
                                    xmc07=g_xmc[l_ac].xmc07,
                                    xmc08=g_xmc[l_ac].xmc08,
                                    xmc09=g_xmc[l_ac].xmc09
                 WHERE xmc01=g_xmb.xmb01
                   AND xmc02=g_xmb.xmb02
                   AND xmc03=g_xmb.xmb03
                   AND xmc04=g_xmb.xmb04
                   AND xmc05=g_xmb.xmb05
                   AND xmc06=g_xmc_t.xmc06
                   AND xmc07=g_xmc_t.xmc07
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                  CALL cl_err(g_xmc[l_ac].xmc06,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("upd","xmc_file",g_xmb.xmb01,g_xmc_t.xmc06,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   LET g_xmc[l_ac].* = g_xmc_t.*
                   LET g_success = 'N'
                ELSE
                   MESSAGE 'UPDATE O.K'
                   IF g_success = 'Y' THEN
                       COMMIT WORK
                   END IF
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_xmc[l_ac].* = g_xmc_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_xmc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i500_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i500_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL i500_b_askkey()
      #     EXIT INPUT
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION set_promotion_price #延用定價
               CALL i500_ctry_xmc08()
               NEXT FIELD xmc08
 
        ON ACTION set_discount  #延用定價
               CALL i500_ctry_xmc09()
               NEXT FIELD xmc09
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(xmc06) #料件編號
#                 CALL q_ima(10,3,g_xmc[l_ac].xmc06)
#                      RETURNING g_xmc[l_ac].xmc06
#FUN-AA0059---------mod------------str-----------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.default1 = g_xmc[l_ac].xmc06
#                  CALL cl_create_qry() RETURNING g_xmc[l_ac].xmc06
#                  CALL FGL_DIALOG_SETBUFFER( g_xmc[l_ac].xmc06 )
                   CALL q_sel_ima(FALSE, "q_ima","",g_xmc[l_ac].xmc06,"","","","","",'' ) 
                      RETURNING  g_xmc[l_ac].xmc06

#FUN-AA0059---------mod------------end-----------------
                   DISPLAY BY NAME g_xmc[l_ac].xmc06       #No.MOD-490371
                  NEXT FIELD xmc06
               WHEN INFIELD(xmc07) #單位
#                 CALL q_gfe(10,3,g_xmc[l_ac].xmc07)
#                      RETURNING g_xmc[l_ac].xmc07
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_xmc[l_ac].xmc07
                  CALL cl_create_qry() RETURNING g_xmc[l_ac].xmc07
#                  CALL FGL_DIALOG_SETBUFFER( g_xmc[l_ac].xmc07 )
                   DISPLAY BY NAME g_xmc[l_ac].xmc07       #No.MOD-490371
                  NEXT FIELD xmc07
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
        END INPUT
 
    #FUN-5B0116-begin
     LET g_xmb.xmbmodu = g_user
     LET g_xmb.xmbdate = g_today
     UPDATE xmb_file SET xmbmodu = g_xmb.xmbmodu,xmbdate = g_xmb.xmbdate
      WHERE xmb01 = g_xmb.xmb01
        AND xmb02 = g_xmb.xmb02
        AND xmb03 = g_xmb.xmb03
        AND xmb04 = g_xmb.xmb04
        AND xmb05 = g_xmb.xmb05
        AND xmb00 = g_xmb.xmb00          #FUN-9C0163 ADD
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#       CALL cl_err('upd xmb',SQLCA.SQLCODE,1)   #No.FUN-660167
        CALL cl_err3("upd","xmb_file",g_xmb.xmb01,g_xmb.xmb02,SQLCA.SQLCODE,"","upd xmb",1)  #No.FUN-660167
     END IF
     DISPLAY BY NAME g_xmb.xmbmodu,g_xmb.xmbdate
    #FUN-5B0116-end
 
    CLOSE i500_bcl
    IF g_success = 'Y' THEN
        COMMIT WORK
    ELSE
        ROLLBACK WORK
    END IF
   #CALL i500_delall()  #No.TQC-740088
    CALL i500_delHeader()     #CHI-C30002 add
    CALL i500_show()
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i500_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM xmb_file WHERE xmb01 = g_xmb.xmb01 AND xmb02 = g_xmb.xmb02
                              AND xmb03 = g_xmb.xmb03 AND xmb04 = g_xmb.xmb04
                              AND xmb05 = g_xmb.xmb05
                              AND xmb00 = g_xmb.xmb00   
         INITIALIZE g_xmb.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i500_delall()
    SELECT COUNT(*) INTO g_cnt FROM xmc_file
     WHERE xmc01 = g_xmb.xmb01 AND xmc02 = g_xmb.xmb02
       AND xmc03 = g_xmb.xmb03 AND xmc04 = g_xmb.xmb04
       AND xmc05 = g_xmb.xmb05
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM xmb_file WHERE xmb01 = g_xmb.xmb01 AND xmb02 = g_xmb.xmb02
                              AND xmb03 = g_xmb.xmb03 AND xmb04 = g_xmb.xmb04
                              AND xmb05 = g_xmb.xmb05 
                              AND xmb00 = g_xmb.xmb00   #FUN-9C0163 ADD
    END IF
END FUNCTION
 
FUNCTION i500_xmc06(p_cmd)  #料件編號
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_ima908   LIKE ima_file.ima908, #FUN-560193
           l_ima31    LIKE ima_file.ima31, #FUN-9C0163
           l_imaacti  LIKE ima_file.imaacti,
           l_cnt      LIKE type_file.num5,          #No.FUN-680137 SMALLINT
           p_cmd      LIKE type_file.chr1           #No.FUN-680137 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima31,imaacti,ima908 INTO l_ima02,l_ima021,l_ima31,l_imaacti,l_ima908 #FUN-560193 #FUN-9C0163 ADD ima31
      FROM ima_file WHERE ima01 = g_xmc[l_ac].xmc06
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                            LET l_ima02 = NULL
                            LET l_ima021= NULL
                            LET l_ima31 = NULL #FUN-9C0163
                            LET l_ima908= NULL #FUN-560193
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'   #No.FUN-690022 add
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_xmc[l_ac].ima02 = l_ima02
       LET g_xmc[l_ac].ima021= l_ima021
       LET g_xmc[l_ac].xmc07 = l_ima31  #FUN-9C0163 ADD
       LET g_xmc[l_ac].ima908= l_ima908 #FUN-560193
       DISPLAY BY NAME g_xmc[l_ac].ima02,g_xmc[l_ac].ima021,g_xmc[l_ac].ima908,g_xmc[l_ac].xmc07  #FUN-9C0163 ADD
    END IF
END FUNCTION
 
FUNCTION i500_xmc07()  #單位
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
                WHERE gfe01 = g_xmc[l_ac].xmc07
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                            LET l_gfeacti = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i500_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680137   VARCHAR(200)
 
    CONSTRUCT l_wc2 ON xmc06,xmc07,xmc08,xmc09 # 螢幕上取單身條件
         FROM s_xmc[1].xmc06,s_xmc[1].xmc07,s_xmc[1].xmc08,s_xmc[1].xmc09
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
    CALL i500_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i500_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    l_ima02         LIKE ima_file.ima02,
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    IF cl_null(p_wc2)  THEN LET p_wc2=' 1=1' END IF
    LET g_sql =
        "SELECT xmc06,ima02,ima021,xmc07,ima908,xmc08,xmc09 ", #FUN-560193
        "  FROM xmc_file LEFT OUTER JOIN ima_file ON xmc_file.xmc06=ima_file.ima01 ",
        " WHERE xmc01 ='",g_xmb.xmb01,"'",  #單頭
        "   AND xmc02 ='",g_xmb.xmb02,"'",
        "   AND xmc03 ='",g_xmb.xmb03,"'",
        "   AND xmc04 ='",g_xmb.xmb04,"'",
        "   AND xmc05 ='",g_xmb.xmb05,"'",
        "   AND ",p_wc2 CLIPPED, #單身
        " ORDER BY 1,2"
    PREPARE i500_pb FROM g_sql
    DECLARE xmc_cs                       #CURSOR
        CURSOR FOR i500_pb
 
    CALL g_xmc.clear()
    LET g_cnt = 1
    FOREACH xmc_cs INTO g_xmc[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_xmc.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_xmc TO s_xmc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i500_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i500_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i500_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i500_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i500_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i500_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    sr              RECORD
                    xmb01       LIKE xmb_file.xmb01,
                    xmb02       LIKE xmb_file.xmb02,
                    xmb03       LIKE xmb_file.xmb03,
                    xmb04       LIKE xmb_file.xmb04,
                    xmb05       LIKE xmb_file.xmb05,
                    oah02       LIKE oah_file.oah02,
                    xmb06       LIKE xmb_file.xmb06,
                    occ02       LIKE occ_file.occ02,
                    oag02       LIKE oag_file.oag02,
                    xmc06       LIKE xmc_file.xmc06,
                    xmc08       LIKE xmc_file.xmc08,
                    ima02       LIKE ima_file.ima02,
                    ima021      LIKE ima_file.ima021,   #FUN-5A0060 add
                    xmc09       LIKE xmc_file.xmc09,
                    azi03       LIKE azi_file.azi03
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680137 VARCHAR(20)
    l_za05          LIKE type_file.chr1000              #No.FUN-680137 VARCHAR(40)
 
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
 
    CALL cl_wait()
#   CALL cl_outnam('axmi500') RETURNING l_name          #No,FUN-840053
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT xmb01,xmb02,xmb03,xmb04,xmb05,oah02,xmb06,",
              " occ02,oag02,xmc06,xmc08,ima02,ima021,xmc09,azi03 ",   #FUN-5A0060 add ima021
              "  FROM xmc_file,ima_file,xmb_file LEFT OUTER JOIN oah_file ON xmb_file.xmb01=oah_file.oah01 ",
              " LEFT OUTER JOIN occ_file ON xmb_file.xmb04=occ_file.occ01 LEFT OUTER JOIN oag_file ON xmb_file.xmb05=occ_file.occ01 LEFT OUTER JOIN azi_file ON xmb_file.xmb02=azi_file.azi01 ",
              " WHERE xmc01 = xmb01 AND xmc02 = xmb02 ",
              "   AND xmc03 = xmb03 AND xmc04 = xmb04 ",
              "   AND xmc05 = xmb05 AND ima01 = xmc06 ",
              "   AND xmb00 = '1' ",                     #FUN-9C0163 ADD
              "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    PREPARE i500_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i500_co                         # CURSOR
        CURSOR FOR i500_p1
 
#   START REPORT i500_rep TO l_name                     #No,FUN-840053 
    CALL cl_del_data(l_table)                           #No,FUN-840053
     
    FOREACH i500_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
        END IF
#No.FUN-840053---Begin 
#       OUTPUT TO REPORT i500_rep(sr.*)
        EXECUTE insert_prep USING sr.xmb01, sr.xmb02, sr.xmb03, sr.xmb04, sr.xmb05, sr.xmc06, 
                                  sr.xmc08, sr.oah02, sr.xmb06, sr.occ02, sr.oag02, sr.ima02,
                                  sr.xmc09, sr.ima021,sr.azi03
                                   
    END FOREACH
 
#   FINISH REPORT i500_rep
 
#   CLOSE i500_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'xmb01,xmb03,xmb06,xmb04,xmb02,xmb05,xmb10,
                    xmbuser,xmbgrup,xmbmodu,xmbdate')         
            RETURNING g_wc                                                                                                           
    END IF                                                                                                                          
     LET g_str = g_wc                                                       
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
     CALL cl_prt_cs3('axmi500','axmi500',l_sql,g_str)   
#No.FUN-840053---End      
END FUNCTION
 
REPORT i500_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1) 
    l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    sr              RECORD
                    xmb01       LIKE xmb_file.xmb01,
                    xmb02       LIKE xmb_file.xmb02,
                    xmb03       LIKE xmb_file.xmb03,
                    xmb04       LIKE xmb_file.xmb04,
                    xmb05       LIKE xmb_file.xmb05,
                    oah02       LIKE oah_file.oah02,
                    xmb06       LIKE xmb_file.xmb06,
                    occ02       LIKE occ_file.occ02,
                    oag02       LIKE oag_file.oag02,
                    xmc06       LIKE xmc_file.xmc06,
                    xmc08       LIKE xmc_file.xmc08,
                    ima02       LIKE ima_file.ima02,
                    ima021      LIKE ima_file.ima021,   #FUN-5A0060 add
                    xmc09       LIKE xmc_file.xmc09,
                    azi03       LIKE azi_file.azi03
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
    ORDER BY sr.xmb01,sr.xmb02,sr.xmb03,sr.xmb04,sr.xmb05,sr.xmc06
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<','/pageno'
            PRINT g_head CLIPPED,pageno_total
            PRINT
            PRINT g_dash
            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                           g_x[36],g_x[37]
            PRINTX name=H2 g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],
                           g_x[43]
            PRINTX name=H3 g_x[44],g_x[45]   #FUN-5A0060 add
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.xmb05
           PRINTX name=D1 COLUMN g_c[31],sr.xmb01 CLIPPED,
                          COLUMN g_c[32],sr.xmb02 CLIPPED,
                          COLUMN g_c[33],sr.xmb03 CLIPPED,
                          COLUMN g_c[34],sr.xmb04 CLIPPED,
                          COLUMN g_c[35],sr.xmb05 CLIPPED;
           LET l_i = 0
 
        ON EVERY ROW
           PRINTX name=D1 COLUMN g_c[36],sr.xmc06,
                          COLUMN g_c[37],cl_numfor(sr.xmc08,37,sr.azi03)
           LET l_i = l_i + 1
           IF l_i = 1 THEN
              PRINTX name=D2 COLUMN g_c[38],sr.oah02[1,g_w[38]],
                             COLUMN g_c[39],sr.xmb06,
                             COLUMN g_c[40],sr.occ02,
                             COLUMN g_c[41],sr.oag02[1,g_w[41]];
           END IF
           PRINTX name=D2 COLUMN g_c[42],sr.ima02 CLIPPED, #MOD-4A0238
                          COLUMN g_c[43],cl_numfor(sr.xmc09,43,0)
           PRINTX name=D3 COLUMN g_c[45],sr.ima021 CLIPPED   #FUN-5A0060 add
 
        AFTER  GROUP OF sr.xmb05
           SKIP 1 LINE
 
        ON LAST ROW
           PRINT g_dash
           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
              THEN 
                 #TQC-630166
                 # IF g_wc[001,080] > ' ' THEN
	         #    PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                 # IF g_wc[071,140] > ' ' THEN
	         #    PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                 # IF g_wc[141,210] > ' ' THEN
	         #    PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                   CALL cl_prt_pos_wc(g_wc)
                 #END TQC-630166
                   PRINT g_dash
           END IF
           LET l_trailer_sw = 'n'
           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
        PAGE TRAILER
           IF l_trailer_sw = 'y' THEN
              PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
           ELSE
              SKIP 2 LINE
           END IF
END REPORT
FUNCTION i500_ctry_xmc08()
 DEFINE l_i LIKE type_file.num10,         #No.FUN-680137 INTEGER 
        l_xmc08 LIKE xmc_file.xmc08
    LET l_i = l_ac
    LET l_xmc08 = g_xmc[l_ac].xmc08
    IF cl_confirm('abx-080') THEN
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_xmc[l_i].xmc08,SQLCA.sqlcode,0)
            LET g_success='N'
            RETURN
        END IF
        WHILE l_i <= g_rec_b  #自本行至最后一行延用其上的值
              UPDATE xmc_file
                 SET xmc08 = l_xmc08
               WHERE xmc01 = g_xmb.xmb01
                 AND xmc02 = g_xmb.xmb02
                 AND xmc03 = g_xmb.xmb03
                 AND xmc04 = g_xmb.xmb04
                 AND xmc05 = g_xmb.xmb05
                 AND xmc06 = g_xmc[l_i].xmc06
                 AND xmc07 = g_xmc[l_i].xmc07
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_xmc[l_i].xmc07,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","xmc_file",g_xmb.xmb01,g_xmc[l_i].xmc06,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_success='N'
                  EXIT WHILE
              END IF
              LET l_i = l_i + 1
              IF g_cnt > g_max_rec THEN
                  CALL cl_err( '', 9035, 0 )
                  EXIT WHILE
              END IF
        END WHILE
    END IF
    CALL i500_show()
END FUNCTION
FUNCTION i500_ctry_xmc09()
 DEFINE l_i LIKE type_file.num10,         #No.FUN-680137 INTEGER
        l_xmc09 LIKE xmc_file.xmc09
    LET l_i = l_ac
    LET l_xmc09 = g_xmc[l_ac].xmc09
    IF cl_confirm('abx-080') THEN
        WHILE l_i <= g_rec_b  #自本行至最后一行延用其上的值
              UPDATE xmc_file SET xmc09 = l_xmc09
               WHERE xmc01 = g_xmb.xmb01
                 AND xmc02 = g_xmb.xmb02
                 AND xmc03 = g_xmb.xmb03
                 AND xmc04 = g_xmb.xmb04
                 AND xmc05 = g_xmb.xmb05
                 AND xmc06 = g_xmc[l_i].xmc06
                 AND xmc07 = g_xmc[l_i].xmc07
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_xmc[l_i].xmc07,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","xmc_file",g_xmb.xmb01,g_xmc[l_i].xmc06,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_success='N'
                  EXIT WHILE
              END IF
              LET l_i = l_i + 1
              IF g_cnt > g_max_rec THEN
                  CALL cl_err( '', 9035, 0 )
                  EXIT WHILE
              END IF
        END WHILE
    END IF
    CALL i500_show()
END FUNCTION
#genero
#單頭
FUNCTION i500_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("xmb01,xmb02,xmb03,xmb04,xmb05",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i500_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("xmb01,xmb02,xmb03,xmb04,xmb05",FALSE)
       END IF
   END IF
 
END FUNCTION
 
#單身
FUNCTION i500_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("xmc06,xmc07",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i500_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'u' THEN
       CALL cl_set_comp_entry("xmc06,xmc07",FALSE)
   END IF
 
END FUNCTION
#Patch....NO.MOD-5A0095 <001> #
#No.FUN-870144

