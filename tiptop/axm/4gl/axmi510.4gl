# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmi510.4gl
# Descriptions...: 特賣產品數量價格折扣維護作業
# Date & Author..: 02/08/05 By  Maggie
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-4C0099 05/02/15 By kim 報表轉XML功能
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-560193 05/06/28 By kim 單身 '單位' 改名為 '銷售單位', 並於其右邊增秀 '計價單位'
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-5A0060 06/06/15 By Sarah 增加列印ima021規格
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0020 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值000000000000
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0139 06/11/17 By Ray 1.料號，品名，規格在zaa中寬度為30，但程序中未截位，可能會導致數據超出
#                                                2.進單身后只能用邊上的“預設上筆資料”來新增？應該是可以自由新增
#                                                3.新增單身時，料號可開窗查詢xmc_file的資料，并帶出相應的品名，單位等，只讓用戶維護最低數量和折扣率
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740088 07/04/13 By CHENL  單身無資料，單頭不再刪除。
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750116 07/05/22 By chenl  修改單身資料判斷。
# Modify.........: No.FUN-840053 08/05/09 By dxfwo  CR報表
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.TQC-920106 09/03/09 By chenyu AFTER FIELD xmd06后面，where條件要把全部key值都列出來
# Modfiy.........: No.TQC-950019 09/05/07 By chenyu TQC-920106修改的問題。導致新增單身時出錯
# Modfiy.........: No.TQC-960123 09/06/11 By Carrier 最低數量若為0,則折扣一定為100%
# Modify.........: No.FUN-870100 09/08/10 By Cockroach 1.axmi510單頭原與axmi510單頭共用同一table，axmi510單頭引用axmi510資料無法維護；
#                                                      2.現axmi510可單獨與指定基礎價搭配使用，因此修改axmi510單頭可開放維護，仍與axmi510共用同一table。
# Modify.........: No.TQC-970056 09/07/08 By destiny xmd06欄位 要判斷是否為新增才可以next field xmd06 , 不然一但xmc_file 沒資料且xmd06被設成noentry會造成無窮回圈 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0033 09/11/09 By Carrier 新增后,单身资料没有show出来
# Modify.........: No.FUN-9C0163 09/12/28 By Cockroach 增加xmb00字段區分axmi500/510單頭
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.TQC-AB0077 10/12/01 By houlia 帶出料件主檔的銷售單位作為默認值
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B80197 11/08/26 By lixia 查詢欄位
# Modify.........: No:FUN-BB0086 11/11/17 By tanxc 增加數量欄位小數取位
# Modify.........: No.TQC-BC0060 11/12/09 By SunLM 增加<>0的情況
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20068 12/02/14 By fengrui 數量欄位小數取位處理
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_xmb           RECORD LIKE xmb_file.*,       #
    g_xmb_t         RECORD LIKE xmb_file.*,       #
    g_xmb_o         RECORD LIKE xmb_file.*,       #
    g_xmb01_t       LIKE xmb_file.xmb01,          #
    g_xmb02_t       LIKE xmb_file.xmb02,
    g_xmb03_t       LIKE xmb_file.xmb03,
    g_xmb04_t       LIKE xmb_file.xmb04,
    g_xmb05_t       LIKE xmb_file.xmb05,
    g_oah02         LIKE oah_file.oah02,          #價格條件說明
    g_occ02         LIKE occ_file.occ02,          #客戶簡稱
    g_oag02         LIKE oag_file.oag02,          #收款條件說明
    g_t1            LIKE faj_file.faj02,          #No.FUN-680137 
    g_xmd           DYNAMIC ARRAY OF RECORD           #程式變數(Program Variables)
        xmd06       LIKE xmd_file.xmd06,
        ima02       LIKE ima_file.ima02,
        xmd07       LIKE xmd_file.xmd07,
        ima908      LIKE ima_file.ima908, #FUN-560193
        xmd08       LIKE xmd_file.xmd08,
        xmd09       LIKE xmd_file.xmd09
                    END RECORD,
    g_xmd_t         RECORD                        #程式變數 (舊值)
        xmd06       LIKE xmd_file.xmd06,
        ima02       LIKE ima_file.ima02,
        xmd07       LIKE xmd_file.xmd07,
        ima908      LIKE ima_file.ima908, #FUN-560193
        xmd08       LIKE xmd_file.xmd08,
        xmd09       LIKE xmd_file.xmd09
                    END RECORD,
    g_xmd_o         RECORD                        #程式變數 (舊值)最原始
        xmd06       LIKE xmd_file.xmd06,
        ima02       LIKE ima_file.ima02,
        xmd07       LIKE xmd_file.xmd07,
        ima908      LIKE ima_file.ima908, #FUN-560193
        xmd08       LIKE xmd_file.xmd08,
        xmd09       LIKE xmd_file.xmd09
                    END RECORD,
   #g_wc,g_wc2,g_sql    LIKE type_file.chr1000,#No.FUN-680137 VARCHAR(600)
    g_wc,g_wc2,g_sql    STRING, #TQC-630166    
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
    g_ydate         LIKE type_file.dat,                 #No.FUN-680137 
    l_ac            LIKE type_file.num5
DEFINE     p_row,p_col     LIKE type_file.num5      #FUN-9C0163 ADD
DEFINE   g_chr           LIKE type_file.chr1         #FUN-870100 ADD
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL   
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE   l_table         STRING                       #No.FUN-840053                                                             
DEFINE   l_sql           STRING                       #No.FUN-840053                                                             
DEFINE   g_str           STRING                       #No.FUN-840053
DEFINE   g_xmd07_t       LIKE xmd_file.xmd07          #No:FUN-BB0086 

MAIN
DEFINE     p_row,p_col     LIKE type_file.num5    #FUN-9C0163 ADD

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_sql = " xmb01.xmb_file.xmb01,",
               " xmb02.xmb_file.xmb02,",
               " xmb03.xmb_file.xmb03,",
               " xmb04.xmb_file.xmb04,",
               " xmb05.xmb_file.xmb05,",
               " xmd06.xmd_file.xmd06,",
               " xmd08.xmd_file.xmd08,",
               " oah02.oah_file.oah02,",
               " xmb06.xmb_file.xmb06,",
               " occ02.occ_file.occ02,",
               " oag02.oag_file.oag02,",
               " ima02.ima_file.ima02,",
               " xmd09.xmd_file.xmd09,",
               " ima021.ima_file.ima021 "
   LET l_table = cl_prt_temptable('axmi510',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?  )"  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF
            
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0094
 
    LET g_forupd_sql =
        #"SELECT * FROM xmb_file WHERE xmb01=? AND xmb02=? AND xmb03=? AND xmb04=? AND xmb05=?  FOR UPDATE" #FUN-9C0163 MARK
         "SELECT * FROM xmb_file WHERE xmb00='2' AND xmb01=? AND xmb02=? AND xmb03=? AND xmb04=? AND xmb05=?  FOR UPDATE" #FUN-9C0163 ADD
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i510_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW i510_w WITH FORM "axm/42f/axmi510"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF (g_sma.sma116 MATCHES '[01]') THEN    #No.FUN-610076
       CALL cl_set_comp_visible("ima908",FALSE)
    END IF
 
    LET g_ydate = NULL
    CALL i510_menu()
    CLOSE WINDOW i510_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0094
END MAIN
 
FUNCTION i510_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                             #清除畫面
   CALL g_xmd.clear()
 
   INITIALIZE g_xmb.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        xmb01,xmb03,xmb06,xmb04,xmb02,xmb05,xmb10,    #FUN-870100 ADD xmb10
        xmbuser,xmbgrup,xmbmodu,xmbdate,xmboriu,xmborig #TQC-B80197
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
#FUN-870100 ADD --------------------------------------
        ON ACTION CONTROLP
            CASE
              WHEN INFIELD(xmb01) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_oah1"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO xmb01
                     NEXT FIELD xmb01
              WHEN INFIELD(xmb02) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO xmb02
                     NEXT FIELD xmb02
              WHEN INFIELD(xmb04) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_occ"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO xmb04
                     NEXT FIELD xmb04
              WHEN INFIELD(xmb05) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_oag"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO xmb05
                     NEXT FIELD xmb05
              OTHERWISE EXIT CASE
            END CASE
#FUN-870100 END-----------------------------------------------------------
 
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
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND xmbuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND xmbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND xmbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('xmbuser', 'xmbgrup')
   #End:FUN-980030
 
 
   CONSTRUCT g_wc2 ON xmd06,xmd07,xmd08,xmd09    #螢幕上取單身條件
             FROM s_xmd[1].xmd06,s_xmd[1].xmd07,s_xmd[1].xmd08,
                  s_xmd[1].xmd09
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
    #FUN-530065
 
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(xmd06)
#FUN-AA0059---------mod------------str-----------------          
#            CALL cl_init_qry_var()
#            LET g_qryparam.form = "q_ima"
#            LET g_qryparam.state = "c"
#            LET g_qryparam.default1 = g_xmd[1].xmd06
#            CALL cl_create_qry() RETURNING g_qryparam.multiret
            CALL q_sel_ima(TRUE, "q_ima","",g_xmd[1].xmd06,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
            DISPLAY g_qryparam.multiret TO s_xmd[1].xmd06
            NEXT FIELD xmd06
          WHEN INFIELD(xmd07)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gfe"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_xmd[1].xmd07
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO s_xmd[1].xmd07
            NEXT FIELD xmd07
         OTHERWISE
            EXIT CASE
       END CASE
    #FUN-530065
 
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
         LET g_sql = "SELECT  xmb01,xmb02,xmb03,xmb04,xmb05 FROM xmb_file ", #FUN-870100  #liuxqa 091021
                     " WHERE xmb00='2' AND ", g_wc CLIPPED,                #FUN-9C0163 ADD xmb00
                     " ORDER BY xmb01,xmb02,xmb03,xmb04,xmb05"       #FUN-870100 ADD
      ELSE					# 若單身有輸入條件
         LET g_sql = "SELECT DISTINCT xmb01,xmb02,xmb03,xmb04,xmb05 ", #FUN-870100 add
                     "  FROM xmb_file, xmd_file ",
                     " WHERE xmb01 = xmd01",
                     "   AND xmb02 = xmd02",
                     "   AND xmb03 = xmd03",
                     "   AND xmb04 = xmd04",
                     "   AND xmb05 = xmd05",
                     "   AND xmb00 = '2'  ",                       #FUN-9C0163 ADD xmb00
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     " ORDER BY xmb01,xmb02,xmb03,xmb04,xmb05"       #FUN-870100 ADD
      END IF
 
   PREPARE i510_prepare FROM g_sql
   DECLARE i510_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i510_prepare
 
   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM xmb_file WHERE xmb00='2' AND ",g_wc CLIPPED  #FUN-9C0163 ADD XMB00
 
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT xmb01||xmb02||xmb03||xmb04||xmb05 ) FROM xmb_file,xmd_file ",
                " WHERE xmb01 = xmd01",
                "   AND xmb02 = xmd02",
                "   AND xmb03 = xmd03",
                "   AND xmb04 = xmd04",
                "   AND xmb05 = xmd05",
                "   AND xmb00 = '2'  ",                         #FUN-9C0163 ADD xmb00
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
 
   END IF
 
   PREPARE i510_precount FROM g_sql
   DECLARE i510_count CURSOR FOR i510_precount
END FUNCTION
 
FUNCTION i510_menu()
 
   WHILE TRUE
      CALL i510_bp("G")
      CASE g_action_choice
        #FUN-870100 ADD--------
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i510_a()
            END IF
        #FUN-870100 END---------   
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i510_q()
            END IF
 
        #FUN-870100 ADD--------  
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i510_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i510_u()
            END IF
        #FUN-870100 END---------  
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i510_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i510_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_xmd),'','')
            END IF
         #No.FUN-6A0020-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_xmb.xmb01 IS NOT NULL THEN
                 LET g_doc.column1 = "xmb01"
                #FUN-870100 ADD-------------- 
                 LET g_doc.column2 = "xmb02" 
                 LET g_doc.column3 = "xmb03"
                 LET g_doc.column4 = "xmb04"  
                 LET g_doc.column5 = "xmb05"
                #FUN-870100 END--------------
                 LET g_doc.value1 = g_xmb.xmb01
                #FUN-870100 ADD--------------             
                 LET g_doc.value2 = g_xmb.xmb02
                 LET g_doc.value3 = g_xmb.xmb03
                 LET g_doc.value4 = g_xmb.xmb04
                 LET g_doc.value5 = g_xmb.xmb05
                #FUN-870100 END--------------            
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0020-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#No.FUN-870100 ADD---------------------------------
#Add  輸入                          
FUNCTION i510_a()                                                                                                                   
    MESSAGE ""                                                                                                                      
    CLEAR FORM                                                                                                                      
    CALL g_xmd.clear()                                                                                                              
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
        LET g_xmb.xmb00 = '2'      #FUN-9C0163 ADD
 
        LET g_xmb.xmb03=g_today          ##default key                                                                              
        LET g_xmb.xmb06=g_today                                                                                                     
                                                                                                                                    
        CALL i510_i("a")                #輸入單頭                                                                                   
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
        IF SQLCA.sqlcode THEN                           #置入資料庫不成功                                                           
           CALL cl_err3("ins","xmb_file",g_xmb.xmb01,g_xmb.xmb02,SQLCA.sqlcode,"","",1)                              
           CONTINUE WHILE                                                                                                           
        END IF                                                                                                                      

        LET g_xmb01_t = g_xmb.xmb01        #保留舊值    
        LET g_xmb02_t = g_xmb.xmb02 
        LET g_xmb03_t = g_xmb.xmb03                                                                                                 
        LET g_xmb04_t = g_xmb.xmb04                                                                                                 
        LET g_xmb05_t = g_xmb.xmb05                                                                                                 
        LET g_xmb_t.* = g_xmb.*                                                                                                     
        CALL g_xmd.clear()                                                                                                          
        LET g_rec_b = 0                                                                                                             
        CALL i510_b()                   #輸入單身                                                                                   
        EXIT WHILE                                                                                                                  
    END WHILE                                                                                                                       
END FUNCTION                                             
 
FUNCTION i510_u()                                                                                                                   
    IF s_shut(0) THEN RETURN END IF                                                                                                 
                                                                                                                                    
    IF cl_null(g_xmb.xmb01) OR cl_null(g_xmb.xmb02) OR cl_null(g_xmb.xmb03) THEN                                                    
       CALL cl_err('',-400,0) RETURN                                                                                                
    END IF                     
 
    MESSAGE ""                                                                                                                      
    CALL cl_opmsg('u')                                                                                                              
    LET g_success = 'Y'                                                                                                             
    BEGIN WORK                                                                                                                      
    OPEN i510_cl USING g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,g_xmb.xmb04,g_xmb.xmb05                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err("OPEN i510_cl:", STATUS, 1)  
       CLOSE i510_cl                                                                                                                
       ROLLBACK WORK                                                                                                                
       RETURN                                                                                                                       
    END IF                                                                                                                          
    FETCH i510_cl INTO g_xmb.*            # 鎖住將被更改或取消的資料                                                                
    IF SQLCA.sqlcode THEN                                                                                                           
        CALL cl_err(g_xmb.xmb01,SQLCA.sqlcode,0)      # 資料被他人LOCK                                                              
        CLOSE i510_cl                              
        ROLLBACK WORK                                                                                                               
        RETURN                                                                                                                      
    END IF                                                                                                                          
    CALL i510_show()                                                                                                                
    WHILE TRUE                                                                                                                      
        LET g_xmb01_t = g_xmb.xmb01                                                                                                 
        LET g_xmb02_t = g_xmb.xmb02                                                                                                 
        LET g_xmb03_t = g_xmb.xmb03                                                                                                 
        LET g_xmb04_t = g_xmb.xmb04                                                                                                 
        LET g_xmb05_t = g_xmb.xmb05  
        LET g_xmb_t.* = g_xmb.*                                                                                                     
        LET g_xmb.xmbmodu=g_user                                                                                                    
        LET g_xmb.xmbdate=g_today                                                                                                   
        LET g_xmb.xmb00 = '2'      #FUN-9C0163 ADD
        CALL i510_i("u")                      #欄位更改                                                                             
        IF INT_FLAG THEN                                                                                                            
            LET INT_FLAG = 0                                                                                                        
            LET g_xmb.*=g_xmb_t.*              
            CALL i510_show()                                                                                                        
            CALL cl_err('','9001',0)                                                                                                
            EXIT WHILE                                                                                                              
        END IF                                                                                                                      
        IF g_xmb.xmb01 != g_xmb01_t OR g_xmb.xmb02 != g_xmb02_t OR                                                                  
           g_xmb.xmb03 != g_xmb03_t OR g_xmb.xmb04 != g_xmb04_t OR                                                                  
           g_xmb.xmb05 != g_xmb05_t  THEN            # 更改單號 
          #FUN-9C0163 MARK START------------------------------------ 
          #UPDATE xmc_file SET xmc01 = g_xmb.xmb01, xmc02 = g_xmb.xmb02,                                                            
          #                    xmc03 = g_xmb.xmb03, xmc04 = g_xmb.xmb04,                                                            
          #                    xmc05 = g_xmb.xmb05                                                                                  
          # WHERE xmc01 = g_xmb01_t AND xmc02 = g_xmb02_t                                                                           
          #   AND xmc03 = g_xmb03_t AND xmc04 = g_xmb04_t                                                                           
          #   AND xmc05 = g_xmb05_t                                                                                                 
          #IF STATUS THEN                                           
          #   CALL cl_err3("upd","xmc_file",g_xmb01_t,g_xmb02_t,SQLCA.sqlcode,"","upd xmc",1)
          #   CONTINUE WHILE                                                                                                        
          #END IF                                                                                                                   
          #FUN-9C0163 MARK END------------------------------------                                                                                                                          
           UPDATE xmd_file SET xmd01 = g_xmb.xmb01, xmd02 = g_xmb.xmb02,                                                            
                               xmd03 = g_xmb.xmb03, xmd04 = g_xmb.xmb04,                                                            
                               xmd05 = g_xmb.xmb05                                                                                  
            WHERE xmd01 = g_xmb01_t AND xmd02 = g_xmb02_t                                                                           
              AND xmd03 = g_xmb03_t AND xmd04 = g_xmb04_t                                                                           
              AND xmd05 = g_xmb05_t                                                                                                 
        END IF                                            
        UPDATE xmb_file SET xmb_file.* = g_xmb.* WHERE xmb01 = g_xmb.xmb01 AND xmb02=g_xmb.xmb02 AND xmb03=g_xmb.xmb03 AND xmb04=g_xmb.xmb04 AND xmb05=g_xmb.xmb05                                                           
                                                   AND xmb00 = '2'    #FUN-9C0163 ADD 
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   
            CALL cl_err3("upd","xmb_file",g_xmb01_t,g_xmb02_t,SQLCA.sqlcode,"","",1)
            CONTINUE WHILE                                                                                                          
        END IF                                                                                                                      
        EXIT WHILE                                                                                                                  
    END WHILE                                                                                                                       
    CLOSE i510_cl                                                                                                                   
    IF g_success = 'Y' THEN COMMIT WORK END IF                                                                                      
END FUNCTION                                     
 
#處理INPUT                           
FUNCTION i510_i(p_cmd)                                                                                                              
DEFINE                                                                                                                              
    l_oah02    LIKE oah_file.oah02,                                                                                                 
    l_occ02    LIKE occ_file.occ02,                                                                                                 
    l_oag02    LIKE oag_file.oag02,                                                                                                 
    l_xmb06    LIKE xmb_file.xmb06,                                                                                                 
    l_n        LIKE type_file.num5, 
    p_cmd      LIKE type_file.chr1 
 
    IF s_shut(0) THEN RETURN END IF                                                                                                 
    CALL cl_set_head_visible("","YES") 
 
    INPUT BY NAME                                                                                                                    g_xmb.xmboriu,g_xmb.xmborig,
        g_xmb.xmb01,g_xmb.xmb03,g_xmb.xmb06,g_xmb.xmb04,g_xmb.xmb02,                                                                
        g_xmb.xmb05,g_xmb.xmb10,g_xmb.xmbuser,g_xmb.xmbmodu,                                                                        
        g_xmb.xmbgrup,g_xmb.xmbdate WITHOUT DEFAULTS                                                                                
                                                                                                                                    
        BEFORE INPUT                                                                                                                
            LET g_before_input_done = FALSE                                                                                         
            CALL i510_set_entry(p_cmd)                                                                                              
            CALL i510_set_no_entry(p_cmd)                                                                                           
            LET g_before_input_done = TRUE       
           #FUN-9C0163 ADD------- 
            IF cl_null(g_xmb.xmb00) THEN
               LET g_xmb.xmb00 ='2'
            END IF
           #FUN-9C0163 END--------
        AFTER FIELD xmb01                                                                                                           
            IF NOT cl_null(g_xmb.xmb01) THEN                                                                                        
                SELECT oah02 INTO l_oah02 FROM oah_file WHERE oah01=g_xmb.xmb01                                                     
                                                           #AND oah03='4' #MOD-530334   #NO.FUN-960130                              
                IF STATUS THEN                                                                                                      
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
               CALL i510_xmb04(p_cmd)                                                                                               
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
               CALL i510_xmb05(p_cmd)                                                                                               
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
                  AND xmb05=g_xmb.xmb05  
                  AND xmb00='2'                #FUN-9C0163 ADD                                                                                           
               IF g_cnt > 0 THEN                           # Duplicated                                                             
                  CALL cl_err(g_xmb.xmb05,-239,0) NEXT FIELD xmb05                                                                  
               END IF                                                                                                               
            END IF                                        
             IF p_cmd = "a" OR (p_cmd = "u"                                                                                         
                                AND (g_xmb.xmb01 != g_xmb_t.xmb01                                                                   
                                  OR g_xmb.xmb02 != g_xmb_t.xmb02                                                                   
                                  OR g_xmb.xmb04 != g_xmb_t.xmb04                                                                   
                                  OR g_xmb.xmb05 != g_xmb_t.xmb05)) THEN   
                 SELECT COUNT(*) INTO g_cnt FROM xmb_file                                                                           
                     WHERE g_xmb.xmb03 BETWEEN xmb03 AND xmb06                                                                      
                       AND xmb01=g_xmb.xmb01                                                                                        
                       AND xmb02=g_xmb.xmb02                                                                                        
                       AND xmb04=g_xmb.xmb04                                                                                        
                       AND xmb05=g_xmb.xmb05                  
                       AND xmb00='2'                #FUN-9C0163 ADD                                                                      
                                                                                                                                    
                 IF g_cnt > 0 THEN                           # Duplicated   
                     CALL cl_err('','-239',0)                                                                                       
                     LET g_xmb.xmb03 = g_xmb_t.xmb03                                                                                
                     LET g_xmb.xmb06 = g_xmb_t.xmb06                                                                                
                     DISPLAY BY NAME g_xmb.xmb03                                                                                    
                     DISPLAY BY NAME g_xmb.xmb06                                                                                    
                     NEXT FIELD xmb03                                                                                               
                  END IF                                                                                                            
            END IF                                  
 
        AFTER INPUT                                                                                                                 
           LET g_xmb.xmbuser = s_get_data_owner("xmb_file") #FUN-C10039
           LET g_xmb.xmbgrup = s_get_data_group("xmb_file") #FUN-C10039
            IF cl_null(g_xmb.xmb04) THEN LET g_xmb.xmb04=' ' END IF                                                                 
            IF cl_null(g_xmb.xmb05) THEN LET g_xmb.xmb05=' ' END IF 
 
        ON ACTION CONTROLR                                                                                                          
           CALL cl_show_req_fields()                                                                                                
                                                                                                                                    
        ON ACTION CONTROLG                                                                                                          
            CALL cl_cmdask()              
 
        ON ACTION CONTROLF                  #欄位說明                                                                               
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913                          
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION CONTROLP                                                                                                          
            CASE                                                                                                                    
              WHEN INFIELD(xmb01)       
                     CALL cl_init_qry_var()                                                                                         
                     LET g_qryparam.form = "q_oah1"                                                                                 
                     LET g_qryparam.default1 = g_xmb.xmb01                                                                          
                     CALL cl_create_qry() RETURNING g_xmb.xmb01 
                     DISPLAY BY NAME g_xmb.xmb01                                                                                    
              WHEN INFIELD(xmb02)                      
                     CALL cl_init_qry_var()                                                                                         
                     LET g_qryparam.form = "q_azi"                                                                                  
                     LET g_qryparam.default1 = g_xmb.xmb02                                                                          
                     CALL cl_create_qry() RETURNING g_xmb.xmb02                                                                     
                     DISPLAY BY NAME g_xmb.xmb02                                                                                    
              WHEN INFIELD(xmb04)                 
                     CALL cl_init_qry_var()                                                                                         
                     LET g_qryparam.form = "q_occ"                                                                                  
                     LET g_qryparam.default1 = g_xmb.xmb04                                                                          
                     CALL cl_create_qry() RETURNING g_xmb.xmb04                                                                     
                     DISPLAY BY NAME g_xmb.xmb04                                                                                    
              WHEN INFIELD(xmb05)                          
                     CALL cl_init_qry_var()                                                                                         
                     LET g_qryparam.form = "q_oag"                                                                                  
                     LET g_qryparam.default1 = g_xmb.xmb05                                                                          
                     CALL cl_create_qry() RETURNING g_xmb.xmb05                                                                     
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
 
FUNCTION i510_xmb01(p_cmd)  #價格條件                                                                                               
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
 
FUNCTION i510_xmb04(p_cmd)
    DEFINE l_occ02    LIKE occ_file.occ02,
           p_cmd   LIKE type_file.chr1          
 
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
 
FUNCTION i510_xmb05(p_cmd)
    DEFINE l_oag02   LIKE oag_file.oag02,
           p_cmd     LIKE type_file.chr1         
 
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
 
#取消整筆 (所有合乎單頭的資料)  
FUNCTION i510_r()
DEFINE l_chr LIKE type_file.chr1         
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_xmb.xmb01) OR cl_null(g_xmb.xmb02) OR cl_null(g_xmb.xmb03) THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    SELECT * INTO g_xmb.* FROM xmb_file
     WHERE xmb01=g_xmb.xmb01 AND xmb02=g_xmb.xmb02
       AND xmb03=g_xmb.xmb03 AND xmb04=g_xmb.xmb04
       AND xmb05=g_xmb.xmb05
       AND xmb00='2'                #FUN-9C0163 ADD
    LET g_success = 'Y'
    BEGIN WORK
    OPEN i510_cl USING g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,g_xmb.xmb04,g_xmb.xmb05
    IF STATUS THEN
       CALL cl_err("OPEN i510_cl:", STATUS, 1) 
       CLOSE i510_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i510_cl INTO g_xmb.*     
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_xmb.xmb01,SQLCA.sqlcode,0)    
        ROLLBACK WORK
        RETURN
    END IF
    CALL i510_show()
    IF cl_delh(0,0) THEN              
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
        CALL cl_del_doc()                                                        #No.FUN-9B0098 10/02/24
       DELETE FROM xmb_file WHERE xmb01 = g_xmb.xmb01 AND xmb02 = g_xmb.xmb02
                              AND xmb03 = g_xmb.xmb03 AND xmb04 = g_xmb.xmb04
                              AND xmb05 = g_xmb.xmb05
                              AND xmb00 ='2'                #FUN-9C0163 ADD
       IF STATUS THEN  
          CALL cl_err3("del","xmb_file",g_xmb.xmb01,g_xmb.xmb02,STATUS,"","del xmb",1)   
          LET g_success='N' 
       END IF
      #FUN-9C0163 MARK START----------------------------------------- 
      #DELETE FROM xmc_file WHERE xmc01 = g_xmb.xmb01 AND xmc02 = g_xmb.xmb02
      #                       AND xmc03 = g_xmb.xmb03 AND xmc04 = g_xmb.xmb04
      #                       AND xmc05 = g_xmb.xmb05
      #IF STATUS THEN  
      #   CALL cl_err3("del","xmc_file",g_xmb.xmb01,g_xmb.xmb02,STATUS,"","del xmc",1)  
      #   LET g_success='N' 
      #END IF
      #FUN-9C0163 MARK END------------------------------------------
       DELETE FROM xmd_file WHERE xmd01 = g_xmb.xmb01 AND xmd02 = g_xmb.xmb02
                              AND xmd03 = g_xmb.xmb03 AND xmd04 = g_xmb.xmb04
                              AND xmd05 = g_xmb.xmb05
       IF STATUS THEN  
          CALL cl_err3("del","xmd_file",g_xmb.xmb01,g_xmb.xmb02,STATUS,"","del xmd",1)   
          LET g_success='N' 
       END IF
       CLEAR FORM
       CALL g_xmd.clear()
       INITIALIZE g_xmb.* TO NULL
             
       OPEN i510_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i510_cs
          CLOSE i510_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i510_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i510_cs
          CLOSE i510_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i510_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i510_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i510_fetch('/')
       END IF
    END IF
    CLOSE i510_cl
    IF g_success = 'Y' THEN COMMIT WORK END IF
END FUNCTION
 
 
 
#Query 查詢
FUNCTION i510_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_xmb.* TO NULL             #No.FUN-6A0020
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_xmd.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i510_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_xmb.* TO NULL
       RETURN
    END IF
    OPEN i510_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_xmb.* TO NULL
    ELSE
        OPEN i510_count
        FETCH i510_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i510_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i510_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i510_cs INTO g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,g_xmb.xmb04,g_xmb.xmb05,
                                             g_xmb.xmb02,g_xmb.xmb03,
                                             g_xmb.xmb04,g_xmb.xmb05
        WHEN 'P' FETCH PREVIOUS i510_cs INTO g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,g_xmb.xmb04,g_xmb.xmb05,
                                             g_xmb.xmb02,g_xmb.xmb03,
                                             g_xmb.xmb04,g_xmb.xmb05
        WHEN 'F' FETCH FIRST    i510_cs INTO g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,g_xmb.xmb04,g_xmb.xmb05,
                                             g_xmb.xmb02,g_xmb.xmb03,
                                             g_xmb.xmb04,g_xmb.xmb05
        WHEN 'L' FETCH LAST     i510_cs INTO g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,g_xmb.xmb04,g_xmb.xmb05,
                                             g_xmb.xmb02,g_xmb.xmb03,
                                             g_xmb.xmb04,g_xmb.xmb05
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i510_cs INTO g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,g_xmb.xmb04,g_xmb.xmb05,
                                               g_xmb.xmb02,g_xmb.xmb03,
                                               g_xmb.xmb04,g_xmb.xmb05
            LET g_no_ask = FALSE
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
                                          AND xmb00 = '2'           #FUN-9C0163 ADD
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_xmb.xmb01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","xmb_file",g_xmb.xmb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       INITIALIZE g_xmb.* TO NULL
       RETURN
    END IF
    LET g_data_owner = g_xmb.xmbuser      #FUN-4C0057 add
    LET g_data_group = g_xmb.xmbgrup      #FUN-4C0057 add
    CALL i510_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i510_show()
    LET g_xmb_t.* = g_xmb.*                #保存單頭舊值
    DISPLAY BY NAME g_xmb.xmboriu,g_xmb.xmborig,                        # 顯示單頭值
        g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,g_xmb.xmb06,
        g_xmb.xmb04,g_xmb.xmb05,g_xmb.xmb10,g_xmb.xmbuser,g_xmb.xmbgrup,g_xmb.xmbmodu,  #FUN-870100 ADD
        g_xmb.xmbdate
#   SELECT oah02 INTO g_oah02 FROM oah_file WHERE oah01 = g_xmb.xmb01
#   SELECT occ02 INTO g_occ02 FROM occ_file WHERE occ01 = g_xmb.xmb04
#   SELECT oag02 INTO g_oag02 FROM oag_file WHERE oag01 = g_xmb.xmb05
   #FUN-870100 ADD-----
    CALL i510_xmb01('d')
    CALL i510_xmb04('d')
    CALL i510_xmb05('d')
   #FUN-870100 END----
#   DISPLAY g_oah02 TO FORMONLY.oah02
#   DISPLAY g_occ02 TO FORMONLY.occ02
#   DISPLAY g_oag02 TO FORMONLY.oag02
 
    INITIALIZE g_oah02 TO NULL
    INITIALIZE g_occ02 TO NULL
    INITIALIZE g_oag02 TO NULL
 
    CALL i510_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i510_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680137 VARCHAR(1)
    l_i             LIKE type_file.num5,                #No.FUN-680137 SMALLINT
    l_s             LIKE type_file.num5,                #No.FUN-680137 SMALLINT
    l_xmd08         LIKE xmd_file.xmd08,
    l_xmd09         LIKE xmd_file.xmd09,
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
    IF g_xmb.xmb01 IS NULL THEN RETURN END IF
    SELECT * INTO g_xmb.* FROM xmb_file
     WHERE xmb01=g_xmb.xmb01 AND xmb02=g_xmb.xmb02
       AND xmb03=g_xmb.xmb03 AND xmb04=g_xmb.xmb04
       AND xmb05=g_xmb.xmb05
       AND xmb00=g_xmb.xmb00              #FUN-9C0163 ADD

#FUN-9C0163 ADD-------------------------------------
    CALL i510_g_b()                 #auto input body
    CALL i510_b_fill('1=1')
#FUN-9C0163 END-------------------------------------
    CALL cl_opmsg('b')
 
 
    LET g_forupd_sql =
     "SELECT xmd06,'',xmd07,'',xmd08,xmd09 ", #FUN-560193
     "  FROM xmd_file ",
     "  WHERE xmd01= ? ",
     "   AND xmd02= ? ",
     "   AND xmd03= ? ",
     "   AND xmd04= ? ",
     "   AND xmd05= ? ",
     "   AND xmd06= ? ",
     "   AND xmd07= ? ",
     "   AND xmd08= ? ",
     "   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i510_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_xmd WITHOUT DEFAULTS FROM s_xmd.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            LET g_success = 'Y'
            BEGIN WORK
 
            OPEN i510_cl USING g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,g_xmb.xmb04,g_xmb.xmb05
            IF STATUS THEN
               CALL cl_err("OPEN i510_cl:", STATUS, 1)
               CLOSE i510_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i510_cl INTO g_xmb.*     # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_xmb.xmb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i510_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET g_xmd_t.* = g_xmd[l_ac].*  #BACKUP
               LET g_xmd_o.* = g_xmd[l_ac].*  #BACKUP
               LET p_cmd='u'
               LET g_xmd07_t = g_xmd[l_ac].xmd07   #FUN-BB0086 add 
 
               OPEN i510_bcl USING g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,
                                   g_xmb.xmb04,g_xmb.xmb05,g_xmd_t.xmd06,
                                   g_xmd_t.xmd07,g_xmd_t.xmd08
               IF STATUS THEN
                   CALL cl_err("OPEN i510_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
               ELSE
                   FETCH i510_bcl INTO g_xmd[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_xmd_t.xmd06,SQLCA.sqlcode,1)
                      CLOSE i510_bcl
                      ROLLBACK WORK
                   END IF
                   SELECT ima02 INTO g_xmd[l_ac].ima02 FROM ima_file
                    WHERE ima01=g_xmd[l_ac].xmd06
                   SELECT ima908 INTO g_xmd[l_ac].ima908 FROM ima_file  #FUN-560193
                    WHERE ima01=g_xmd[l_ac].xmd06                       #FUN-560193
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            LET g_before_input_done = FALSE
            CALL i510_set_entry_b(p_cmd)
            CALL i510_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO xmd_file(xmd01,xmd02,xmd03,xmd04,xmd05,xmd06,
                                 xmd07,xmd08,xmd09)
                          VALUES(g_xmb.xmb01,g_xmb.xmb02,g_xmb.xmb03,
                                 g_xmb.xmb04,g_xmb.xmb05,
                                 g_xmd[l_ac].xmd06,g_xmd[l_ac].xmd07,
                                 g_xmd[l_ac].xmd08,g_xmd[l_ac].xmd09)
            IF SQLCA.sqlcode THEN
                LET g_success = 'N'
#               CALL cl_err(g_xmd[l_ac].xmd06,SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("ins","xmd_file",g_xmb.xmb01,g_xmd[l_ac].xmd06,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                IF g_success = 'Y' THEN
                    COMMIT WORK
                END IF
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_xmd[l_ac].* TO NULL
            LET g_xmd07_t = NULL   #FUN-BB0086 add 
            LET g_xmd_t.* = g_xmd[l_ac].*
            LET g_xmd_o.* = g_xmd[l_ac].*
            LET g_xmd[l_ac].xmd08 = 0
            LET g_xmd[l_ac].xmd09 = 100
            SELECT ima02 INTO g_xmd[l_ac].ima02 FROM ima_file
             WHERE ima01=g_xmd[l_ac].xmd06
            SELECT ima908 INTO g_xmd[l_ac].ima908 FROM ima_file  #FUN-560193
             WHERE ima01=g_xmd[l_ac].xmd06
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            #No.TQC-6B0139 --begin
            LET g_before_input_done = FALSE
            CALL i510_set_entry_b(p_cmd)
            CALL i510_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
            #No.TQC-6B0139 --end
            NEXT FIELD xmd06
 
#       BEFORE FIELD xmd07     #No.TQC-6B0139
        AFTER FIELD xmd06      #No.TQC-6B0139
         #IF NOT cl_null(g_xmd[l_ac].xmd06) THEN   #No.TQC-920106 mark
#         IF NOT cl_null(g_xmd[l_ac].xmd06) AND NOT cl_null(g_xmd[l_ac].xmd07) THEN   #No.TQC-920106 add                  #No.TQC-970056  
#FUN-9C0163  MARK START----------------------------------------------------------------------------------------------
#         IF p_cmd='a' AND NOT cl_null(g_xmd[l_ac].xmd06) AND NOT cl_null(g_xmd[l_ac].xmd07) THEN   #No.TQC-920106 add    #No.TQC-970056    
#            #No.TQC-6B0139 --begin
#            SELECT * FROM xmc_file
#             WHERE xmc01 = g_xmb.xmb01
#               AND xmc02 = g_xmb.xmb02
#               AND xmc03 = g_xmb.xmb03
#               AND xmc04 = g_xmb.xmb04
#               AND xmc05 = g_xmb.xmb05
#               AND xmc06 = g_xmd[l_ac].xmd06
#               AND xmc07 = g_xmd[l_ac].xmd07   #No.TQC-920106 add
#            IF STATUS THEN
#               CALL cl_err3("sel","xmc_file",g_xmb.xmb01,g_xmd[l_ac].xmd06,"axm-090","","",1)  #No.FUN-660167
#               NEXT FIELD xmd06 
#            END IF
#         END IF       #No.TQC-950019 add
#           #No.TQC-6B0139 --end
#FUN-9C0163  MARK END----------------------------------------------------------------------------------------------
#FUN-AA0059 ---------------------start----------------------------
          IF NOT cl_null(g_xmd[l_ac].xmd06) THEN
            IF NOT s_chk_item_no(g_xmd[l_ac].xmd06,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_xmd[l_ac].xmd06= g_xmd_t.xmd06
               NEXT FIELD xmd06
            END IF
#FUN-AA0059 ---------------------end-------------------------------

             IF g_xmd[l_ac].xmd06 != g_xmd_t.xmd06 OR
               g_xmd_t.xmd06 IS NULL THEN
               SELECT ima02 INTO g_xmd[l_ac].ima02 FROM ima_file
                WHERE ima01=g_xmd[l_ac].xmd06
               IF STATUS THEN
#                 CALL cl_err(g_xmd[l_ac].xmd06,'mfg3006',0)   #No.FUN-660167
                  CALL cl_err3("sel","ima_file",g_xmd[l_ac].xmd06,"","mfg3006","","",1)  #No.FUN-660167
                  NEXT FIELD xmd06 
               END IF
               SELECT ima908 INTO g_xmd[l_ac].ima908 FROM ima_file
                WHERE ima01=g_xmd[l_ac].xmd06   #FUN-560193
#FUN-9C0163  MARK START-----------------------------------------------
#              #No.TQC-6B0139 --begin
#              SELECT xmc07 INTO g_xmd[l_ac].xmd07 FROM xmc_file
#               WHERE xmc01 = g_xmb.xmb01
#                 AND xmc02 = g_xmb.xmb02
#                 AND xmc03 = g_xmb.xmb03
#                 AND xmc04 = g_xmb.xmb04
#                 AND xmc05 = g_xmb.xmb05
#                 AND xmc06 = g_xmd[l_ac].xmd06
#              #No.TQC-6B0139 --end
#FUN-9C0163  MARK END--------------------------------------------------
#TQC-AB0077 --houlia add
               SELECT ima31 INTO g_xmd[l_ac].xmd07 FROM ima_file
                WHERE ima01=g_xmd[l_ac].xmd06
#TQC-AB0077 --houlia edd

               DISPLAY g_xmd[l_ac].ima02 TO s_xmd[l_ac].ima02
               DISPLAY g_xmd[l_ac].ima908 TO s_xmd[l_ac].ima908  #FUN-560193
               DISPLAY g_xmd[l_ac].xmd07 TO s_xmd[l_ac].xmd07     #No.TQC-6B0139
               #FUN-BB0086---add--start--
               IF NOT cl_null(g_xmd[l_ac].xmd08) AND g_xmd[l_ac].xmd08<>0 THEN  #FUN-C20068
                  IF NOT i510_xmd08_check(p_cmd) THEN 
                     LET g_xmd07_t = g_xmd[l_ac].xmd07
                     NEXT FIELD xmd08
                  END IF 
               END IF                                                           #FUN-C20068
               LET g_xmd07_t = g_xmd[l_ac].xmd07
               #FUN-BB0086--add--end--
            END IF
           END IF                                          #FUN-AA0059
         #END IF       #No.TQC-950019 mark

 
#No.TQC-6B0139 --begin
#       AFTER FIELD xmd07
#          IF NOT cl_null(g_xmd[l_ac].xmd07) THEN
#             SELECT * FROM xmc_file
#              WHERE xmc01 = g_xmb.xmb01
#                AND xmc02 = g_xmb.xmb02
#                AND xmc03 = g_xmb.xmb03
#                AND xmc04 = g_xmb.xmb04
#                AND xmc05 = g_xmb.xmb05
#                AND xmc06 = g_xmd[l_ac].xmd06
#                AND xmc07 = g_xmd[l_ac].xmd07
#             IF STATUS THEN
#                CALL cl_err('','axm-090',0)   #No.FUN-660167
#                CALL cl_err3("sel","xmc_file",g_xmb.xmb01,g_xmd[l_ac].xmd06,"axm-090","","",1)  #No.FUN-660167
#                NEXT FIELD xmd07 
#             END IF
#          END IF
#No.TQC-6B0139 --end

#FUN-9C0163 ADD START---------------------------------------
       BEFORE FIELD xmd07
            IF NOT cl_null(g_xmd[l_ac].xmd06) THEN
                IF p_cmd='a' OR (p_cmd='u' AND
                   g_xmd[l_ac].xmd06 != g_xmd_t.xmd06 ) THEN
                   CALL i510_xmd06('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_xmd[l_ac].xmd06,g_errno,0)
                      LET g_xmd[l_ac].xmd06 = g_xmd_t.xmd06
                      NEXT FIELD xmd06
                   END IF
                END IF
            END IF
 
        AFTER FIELD xmd07 
            IF NOT cl_null(g_xmd[l_ac].xmd07) THEN
                IF p_cmd='a' OR (p_cmd='u' AND
                   g_xmd[l_ac].xmd07 != g_xmd_t.xmd07) THEN
                   CALL i510_xmd07()
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_xmd[l_ac].xmd07,g_errno,0)
                      LET g_xmd[l_ac].xmd07 = g_xmd_t.xmd07
                      NEXT FIELD xmd07
                   ELSE
                      IF NOT cl_null(g_xmd[l_ac].xmd06) THEN
                         SELECT ima31 INTO l_ima31 FROM ima_file
                          WHERE ima01 = g_xmd[l_ac].xmd06
                         CALL s_umfchk(g_xmd[l_ac].xmd06,g_xmd[l_ac].xmd07
                                       ,l_ima31)
                         RETURNING l_flag,l_fac
                         IF l_flag = 1 THEN
                            LET l_msg = l_ima31 CLIPPED,'->',
                                        g_xmd[l_ac].xmd07 CLIPPED
                            CALL cl_err(l_msg CLIPPED,'mfg2719',0)
                            NEXT FIELD xmd07
                         END IF
                      END IF
                   END IF
                END IF
            END IF
           #FUN-BB0086--add--start--
           IF NOT cl_null(g_xmd[l_ac].xmd08) AND g_xmd[l_ac].xmd08<>0 THEN  #FUN-C20068
              IF NOT i510_xmd08_check(p_cmd) THEN 
                   LET g_xmd07_t = g_xmd[l_ac].xmd07
                   NEXT FIELD xmd08
              END IF 
           END IF                                                           #FUN-C20068
           LET g_xmd07_t = g_xmd[l_ac].xmd07
           #FUN-BB0086--add--end--
#FUN-9C0163 ADD END--------------------------------------- 
 
        AFTER FIELD xmd08
           IF NOT i510_xmd08_check(p_cmd)  THEN NEXT FIELD xmd08 END IF  #FUN-BB0086  add
           #No.FUN-BB0086---start---mark---
           #IF NOT cl_null(g_xmd[l_ac].xmd08) THEN
           #    IF g_xmd[l_ac].xmd08 < 0 THEN
           #        CALL cl_err(g_xmd[l_ac].xmd08,'mfg1322',0)
           #        NEXT FIELD xmd08
           #    END IF
           #END IF
           #IF p_cmd = 'a' OR (p_cmd = 'u' AND
           #   (g_xmd[l_ac].xmd06 != g_xmd_t.xmd06 OR
           #    g_xmd[l_ac].xmd07 != g_xmd_t.xmd07 OR
           #    g_xmd[l_ac].xmd08 != g_xmd_t.xmd08)) THEN
           #   SELECT COUNT(*) INTO l_cnt FROM xmd_file
           #    WHERE xmd01 = g_xmb.xmb01 AND xmd02 = g_xmb.xmb02
           #      AND xmd03 = g_xmb.xmb03 AND xmd04 = g_xmb.xmb04
           #      AND xmd05 = g_xmb.xmb05 AND xmd06 = g_xmd[l_ac].xmd06
           #      AND xmd07 = g_xmd[l_ac].xmd07 AND xmd08 = g_xmd[l_ac].xmd08
           #   IF l_cnt > 0 THEN
           #      CALL cl_err('',-239,0) NEXT FIELD xmd08
           #   END IF
           #END IF
           ##No.TQC-960123  --Begin
           #IF NOT cl_null(g_xmd[l_ac].xmd08) THEN
           #  IF g_xmd[l_ac].xmd08 = 0 THEN
           #     LET g_xmd[l_ac].xmd09 = 100
           #  END IF
           #END IF
           ##No.TQC-960123  --End
           #No.FUN-BB0086---end---mark---

 
        AFTER FIELD xmd09
           IF NOT cl_null(g_xmd[l_ac].xmd09) THEN
               IF g_xmd[l_ac].xmd09 < 0 OR g_xmd[l_ac].xmd09 > 100 THEN
                   CALL cl_err(g_xmd[l_ac].xmd09,'mfg1332',0)
                   NEXT FIELD xmd09
               END IF
               #No.TQC-960123  --Begin
               IF NOT cl_null(g_xmd[l_ac].xmd08) AND g_xmd[l_ac].xmd08 = 0 THEN
                 IF g_xmd[l_ac].xmd09 <> 100 THEN
                    CALL cl_err(g_xmd[l_ac].xmd09,'axm-711',0)
                    NEXT FIELD xmd09
                 END IF
               END IF
               #No.TQC-960123  --End
               IF g_xmd[l_ac].xmd08 > 0 AND g_xmd[l_ac].xmd09 <> 100 THEN
                 #IF g_xmd[l_ac].xmd09 != g_xmd_t.xmd09 OR          #No.TQC-750116 mark
                 #   g_xmd_t.xmd09 IS NULL THEN                     #No.TQC-750116 mark
                  IF g_xmd_t.xmd09 IS NULL THEN                     #No.TQC-750116
                     SELECT COUNT(*) INTO l_cnt
                       FROM xmd_file
                      WHERE xmd01 = g_xmb.xmb01 AND xmd02 = g_xmb.xmb02
                        AND xmd03 = g_xmb.xmb03 AND xmd04 = g_xmb.xmb04
                        AND xmd05 = g_xmb.xmb05
                        AND xmd06 = g_xmd[l_ac].xmd06
                        AND xmd07 = g_xmd[l_ac].xmd07
                        AND ((xmd08 > g_xmd[l_ac].xmd08
                        AND xmd09 >= g_xmd[l_ac].xmd09)
                         OR (xmd08 < g_xmd[l_ac].xmd08
                        AND xmd09 <= g_xmd[l_ac].xmd09))
                     IF l_cnt >0 THEN
                        CALL cl_err('','axm-521',0) NEXT FIELD xmd09
                     END IF
                  END IF
                  #No.TQC-750116--begin--                             
                  IF g_xmd[l_ac].xmd09 != g_xmd_t.xmd09 OR             
                     g_xmd_t.xmd09 IS NOT NULL THEN                     
                     SELECT COUNT(*) INTO l_cnt                          
                       FROM xmd_file                                      
                      WHERE xmd01 = g_xmb.xmb01 AND xmd02 = g_xmb.xmb02    
                        AND xmd03 = g_xmb.xmb03 AND xmd04 = g_xmb.xmb04     
                        AND xmd05 = g_xmb.xmb05                              
                        AND xmd06 = g_xmd[l_ac].xmd06                         
                        AND xmd07 = g_xmd[l_ac].xmd07                          
                        AND (((xmd08 >  g_xmd[l_ac].xmd08 AND xmd08!=g_xmd_t.xmd08)
                        AND   (xmd09 >= g_xmd[l_ac].xmd09 AND xmd09!=g_xmd_t.xmd09))
                         OR  ((xmd08 <  g_xmd[l_ac].xmd08 AND xmd08!=g_xmd_t.xmd08)
                        AND   (xmd09 <= g_xmd[l_ac].xmd09 AND xmd09!=g_xmd_t.xmd09)))
                     IF l_cnt >0 THEN                                                                                               
                        CALL cl_err('','axm-521',0) NEXT FIELD xmd09              
                     END IF                                                                                                         
                  END IF                                      
                  #No.TQC-750116--end--
               END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_xmd_t.xmd06 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM xmd_file
                WHERE xmd01 = g_xmb.xmb01 AND xmd02 = g_xmb.xmb02
                  AND xmd03 = g_xmb.xmb03 AND xmd04 = g_xmb.xmb04
                  AND xmd05 = g_xmb.xmb05 AND xmd06 = g_xmd_t.xmd06
                  AND xmd07 = g_xmd_t.xmd07 AND xmd08 = g_xmd_t.xmd08
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_xmd_t.xmd06,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("del","xmd_file",g_xmb.xmb01,g_xmd_t.xmd06,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_xmd[l_ac].* = g_xmd_t.*
               CLOSE i510_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_xmd[l_ac].xmd06,-263,1)
                LET g_xmd[l_ac].* = g_xmd_t.*
            ELSE
                UPDATE xmd_file SET xmd06=g_xmd[l_ac].xmd06,
                                    xmd07=g_xmd[l_ac].xmd07,
                                    xmd08=g_xmd[l_ac].xmd08,
                                    xmd09=g_xmd[l_ac].xmd09
                 WHERE xmd01=g_xmb.xmb01 AND xmd02=g_xmb.xmb02
                   AND xmd03=g_xmb.xmb03 AND xmd04=g_xmb.xmb04
                   AND xmd05=g_xmb.xmb05
                   AND xmd06=g_xmd_t.xmd06
                   AND xmd07=g_xmd_t.xmd07
                   AND xmd08=g_xmd_t.xmd08
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   LET g_success = 'N'
#                  CALL cl_err(g_xmd[l_ac].xmd06,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("upd","xmd_file",g_xmb.xmb01,g_xmd_t.xmd06,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   LET g_xmd[l_ac].* = g_xmd_t.*
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
                  LET g_xmd[l_ac].* = g_xmd_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_xmd.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i510_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i510_bcl
            COMMIT WORK
 
        #BugNo:6596
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(xmd06) AND l_ac > 1 THEN
                LET g_xmd[l_ac].* = g_xmd[l_ac-1].*
                NEXT FIELD xmd06
            END IF
 
       #ON ACTION CONTROLN
       #    CALL i510_b_askkey()
       #    EXIT INPUT
 
        ON ACTION set_qty
                  CALL i510_ctry_xmd08()
                       NEXT FIELD xmd08
 
        ON ACTION set_discount
                  CALL i510_ctry_xmd09()
                       NEXT FIELD xmd09
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(xmd06)
#FUN-AA0059---------mod------------str-----------------          
#            CALL cl_init_qry_var()
#           #LET g_qryparam.form = "q_xmc"       #FUN-9C0163 MARK
#            LET g_qryparam.form = "q_ima"       #FUN-9C0163 ADD
#            LET g_qryparam.default1 = g_xmd[l_ac].xmd06
#           #FUN-9C0163 MARK START---------------
#           #LET g_qryparam.arg1  = g_xmb.xmb01
#           #LET g_qryparam.arg2  = g_xmb.xmb02
#           #LET g_qryparam.arg3  = g_xmb.xmb03
#           #LET g_qryparam.arg4  = g_xmb.xmb04
#           #LET g_qryparam.arg5  = g_xmb.xmb05
#           #FUN-9C0163 MARK END---------------
#            CALL cl_create_qry() RETURNING  g_xmd[l_ac].xmd06
            CALL q_sel_ima(FALSE, "q_ima","",g_xmd[l_ac].xmd06,"","","","","",'' ) 
              RETURNING  g_xmd[l_ac].xmd06
#FUN-AA0059---------mod------------end-----------------
            DISPLAY BY NAME g_xmd[l_ac].xmd06
            NEXT FIELD xmd06
#FUN-9C0163 ADD START-------------------------------
          WHEN INFIELD(xmd07)         
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gfe"
            LET g_qryparam.default1 = g_xmd[l_ac].xmd07
            CALL cl_create_qry() RETURNING  g_xmd[l_ac].xmd07
            DISPLAY BY NAME g_xmd[l_ac].xmd07
            NEXT FIELD xmd07
         OTHERWISE
            EXIT CASE
       END CASE
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
        END INPUT
 
    CLOSE i510_bcl
    IF g_success= 'Y' THEN
        COMMIT WORK
    ELSE
        ROLLBACK WORK
    END IF
#   CALL i510_delall()         #No.TQC-740088
    CALL i510_delHeader()     #CHI-C30002 add
    CALL i510_show()
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i510_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM xmb_file WHERE xmb01 = g_xmb.xmb01
                              AND xmb02 = g_xmb.xmb02
                              AND xmb03 = g_xmb.xmb03
                              AND xmb04 = g_xmb.xmb04
                              AND xmb05 = g_xmb.xmb05
                              AND xmb00 = g_xmb.xmb00  
         INITIALIZE g_xmb.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i510_delall()
    SELECT COUNT(*) INTO g_cnt FROM xmd_file
        WHERE xmd01 = g_xmb.xmb01
          AND xmd02 = g_xmb.xmb02
          AND xmd03 = g_xmb.xmb03
          AND xmd04 = g_xmb.xmb04
          AND xmd05 = g_xmb.xmb05
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM xmb_file WHERE xmb01 = g_xmb.xmb01
                              AND xmb02 = g_xmb.xmb02
                              AND xmb03 = g_xmb.xmb03
                              AND xmb04 = g_xmb.xmb04
                              AND xmb05 = g_xmb.xmb05
                              AND xmb00 = g_xmb.xmb00      #FUN-9C0163 ADD
    END IF
END FUNCTION
 
FUNCTION i510_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(200)
 
 CONSTRUCT l_wc2 ON xmd06,xmd07,xmd08,xmd09      # 螢幕上取單身條件
            FROM s_xmd[1].xmd06,s_xmd[1].xmd07,
                 s_xmd[1].xmd08,s_xmd[1].xmd09
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
    CALL i510_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i510_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    #No.TQC-9B0033  --Begin
    IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF
    #No.TQC-9B0033  --End  
    LET g_sql =
        "SELECT xmd06,ima02,xmd07,ima908,xmd08,xmd09 ",  #FUN-560193
        "  FROM xmd_file LEFT OUTER JOIN ima_file ON xmd_file.xmd06=ima_file.ima01",
        " WHERE xmd01 ='",g_xmb.xmb01,"'",     #單頭
        "   AND xmd02 ='",g_xmb.xmb02,"'",     #單頭
        "   AND xmd03 ='",g_xmb.xmb03,"'",     #單頭
        "   AND xmd04 ='",g_xmb.xmb04,"'",     #單頭
        "   AND xmd05 ='",g_xmb.xmb05,"'",     #單頭
        "   AND ",p_wc2 CLIPPED, #單身
        " ORDER BY xmd06,xmd07"
    PREPARE i510_pb FROM g_sql
    DECLARE xmd_cs                       #CURSOR
        CURSOR FOR i510_pb
 
    CALL g_xmd.clear()
    LET g_cnt = 1
    FOREACH xmd_cs INTO g_xmd[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_xmd.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

#FUN-9C0163 ADD START----------------------------------------------------------
FUNCTION i510_g_b()
   DEFINE l_wc          LIKE type_file.chr1000       
   DEFINE l_ima         RECORD LIKE ima_file.*
   DEFINE l_ima01       LIKE ima_file.ima01
   DEFINE l_sql         LIKE type_file.chr1000      
   DEFINE l_cnt         LIKE type_file.num5          
   DEFINE l_obk         RECORD LIKE obk_file.*
   DEFINE l_occ02       LIKE occ_file.occ02 
   DEFINE l_xmd         RECORD LIKE xmd_file.*
 
   SELECT COUNT(*) INTO g_cnt FROM xmd_file
    WHERE xmd01=g_xmb.xmb01 AND xmd02=g_xmb.xmb02 AND xmd03=g_xmb.xmb03
      AND xmd04=g_xmb.xmb04 AND xmd05=g_xmb.xmb05
   IF g_cnt > 0 THEN           
      RETURN
   ELSE
      IF NOT cl_confirm('axr-321') THEN RETURN END IF
   END IF
 
   LET p_row = 8 LET p_col = 18
   OPEN WINDOW i510_w1 AT p_row,p_col         
        WITH FORM "axm/42f/axmi5001"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)  
 
    CALL cl_ui_locale("axmi5001")
 
 
   CALL cl_opmsg('q')
 
   CONSTRUCT BY NAME l_wc ON ima06,ima01 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init() 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about       
         CALL cl_about()    
 
      ON ACTION help         
         CALL cl_show_help()  
 
      ON ACTION controlg     
         CALL cl_cmdask()   
 
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
  
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save() 
   END CONSTRUCT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i500_w1
      RETURN
   END IF
  
 
   INITIALIZE l_xmd.* TO NULL
   LET l_xmd.xmd01 = g_xmb.xmb01
   LET l_xmd.xmd02 = g_xmb.xmb02
   LET l_xmd.xmd03 = g_xmb.xmb03
   LET l_xmd.xmd04 = g_xmb.xmb04
   LET l_xmd.xmd05 = g_xmb.xmb05
 
   IF l_wc =" 1=1" THEN       
      LET l_sql = "SELECT * FROM obk_file ",
                  " WHERE obk02 ='",g_xmb.xmb04,"' AND obk05 ='",g_xmb.xmb02,"'"
      PREPARE i5101_prepare1 FROM l_sql
      IF STATUS THEN CALL cl_err('i5101_pre',STATUS,0) RETURN END IF
      DECLARE i5101_cs1 CURSOR FOR i5101_prepare1
      FOREACH i5101_cs1 INTO l_obk.*
          IF cl_null(l_obk.obk07) THEN LET l_obk.obk07=' ' END IF
          IF cl_null(l_obk.obk08) THEN LET l_obk.obk08=0 END IF

          LET l_xmd.xmd06 = l_obk.obk01
          LET l_xmd.xmd07 = l_obk.obk07
          LET l_xmd.xmd08 = 0
          LET l_xmd.xmd09 = 100
          INSERT INTO xmd_file VALUES(l_xmd.*)
          IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN 
             CALL cl_err3("ins","xmd_file",l_xmd.xmd01,l_xmd.xmd06,STATUS,"","ins xmd",1)   
             EXIT FOREACH  
          END IF
      END FOREACH
   ELSE             
      LET l_sql = "SELECT * FROM ima_file WHERE ",l_wc CLIPPED
      PREPARE i5101_prepare FROM l_sql
      IF STATUS THEN CALL cl_err('i5101_pre2',STATUS,0) RETURN END IF
      DECLARE i5101_cs CURSOR FOR i5101_prepare
      FOREACH i5101_cs INTO l_ima.*
#FUN-AA0059 ---------------------start----------------------------
          IF NOT s_chk_item_no(l_ima.ima01,"") THEN
             CONTINUE FOREACH
          END IF
#FUN-AA0059 ---------------------end-------------------------------
          IF cl_null(l_ima.ima31) THEN LET l_ima.ima31=' ' END IF
          IF cl_null(l_ima.ima33) THEN LET l_ima.ima33=0 END IF
 
          LET l_xmd.xmd06 = l_ima.ima01
          LET l_xmd.xmd07 = l_ima.ima31
          LET l_xmd.xmd08 = 0
          LET l_xmd.xmd09 = 100
          INSERT INTO xmd_file VALUES(l_xmd.*)
          IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN 
             CALL cl_err3("ins","xmd_file",l_xmd.xmd01,l_xmd.xmd06,STATUS,"","ins xmd",1)  
             EXIT FOREACH 
          END IF
      END FOREACH
   END IF
   CLOSE WINDOW i510_w1
END FUNCTION
#FUN-9C0163 ADD END----------------------------------------------------------
 
FUNCTION i510_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_xmd TO s_xmd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
     #FUN-870100 ADD--------------------
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete                                                                                                              
         LET g_action_choice="delete"                                                                                               
         EXIT DISPLAY                                                                                                               
      ON ACTION modify                                                                                                              
         LET g_action_choice="modify"                                                                                               
         EXIT DISPLAY                  
     #FUN-870100 END---------------------
      ON ACTION first
         CALL i510_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i510_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i510_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i510_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i510_fetch('L')
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
 
      ON ACTION related_document                #No.FUN-6A0020  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i510_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    sr              RECORD
        xmb01       LIKE xmb_file.xmb01,
        xmb02       LIKE xmb_file.xmb02,
        xmb03       LIKE xmb_file.xmb03,
        xmb04       LIKE xmb_file.xmb04,
        xmb05       LIKE xmb_file.xmb05,
        xmb06       LIKE xmb_file.xmb06,
        azi03       LIKE azi_file.azi03,
        xmd06       LIKE xmd_file.xmd06,
        xmd08       LIKE xmd_file.xmd08,
        xmd09       LIKE xmd_file.xmd09,
        oah02       LIKE oah_file.oah02,
        occ02       LIKE occ_file.occ02,
        oag02       LIKE oag_file.oag02,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021   #FUN-5A0060 add
       END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name  #No.FUN-680137 VARCHAR(20)
    l_za05          LIKE type_file.chr1000              #No.FUN-680137 VARCHAR(40)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
    CALL cl_wait()
#   CALL cl_outnam('axmi510') RETURNING l_name                       #No,FUN-840053
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT xmb01,xmb02,xmb03,xmb04,xmb05,xmb06,azi03,",
              " xmd06,xmd08,xmd09,oah02,occ02,oag02,ima02,ima021",   #FUN-5A0060 add ima021
              "  FROM xmd_file LEFT OUTER JOIN ima_file ON xmd_file.xmd06=ima_file.ima01,xmb_file LEFT OUTER JOIN azi_file ON xmb_file.xmb02=azi_file.azi01 ",
              " LEFT OUTER JOIN oah_file ON xmb_file.xmb01=oah_file.oah01  LEFT OUTER JOIN occ_file ON xmb_file.xmb04=occ_file.occ01 LEFT OUTER JOIN oag_file ON xmb_file.xmb05=oag_file.oag01 ",
              " WHERE xmd01 = xmb01",
              "   AND xmd02 = xmb02",
              "   AND xmd03 = xmb03",
              "   AND xmd04 = xmb04",
              "   AND xmd05 = xmb05",
              "   AND xmb00 = '2'  ",            #FUN-9C0163 ADD
              "   AND ",g_wc CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " ORDER BY 1,6,8"
    PREPARE i510_p1 FROM g_sql              # RUNTIME 編譯
    DECLARE i510_co                         # CURSOR
        CURSOR FOR i510_p1
 
#   START REPORT i510_rep TO l_name         #No,FUN-840053
    CALL cl_del_data(l_table)               #No,FUN-840053
 
    FOREACH i510_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) 
           EXIT FOREACH
        END IF
#No.FUN-840053---Begin 
#       OUTPUT TO REPORT i510_rep(sr.*)
        EXECUTE insert_prep USING sr.xmb01, sr.xmb02, sr.xmb03, sr.xmb04, sr.xmb05, sr.xmd06, 
                                  sr.xmd08, sr.oah02, sr.xmb06, sr.occ02, sr.oag02, sr.ima02,
                                  sr.xmd09, sr.ima021
    END FOREACH
 
#   FINISH REPORT i510_rep
 
    CLOSE i510_co
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'xmb01,xmb03,xmb06,xmb04,xmb02,xmb05,
                           xmbuser,xmbgrup,xmbmodu,xmbdate')         
            RETURNING g_wc                                                                                                           
    END IF                                                                                                                          
     LET g_str = g_wc                                                       
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
     CALL cl_prt_cs3('axmi510','axmi510',l_sql,g_str)   
#No.FUN-840053---End 
END FUNCTION
 
REPORT i510_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
    l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    sr              RECORD
        xmb01       LIKE xmb_file.xmb01,
        xmb02       LIKE xmb_file.xmb02,
        xmb03       LIKE xmb_file.xmb03,
        xmb04       LIKE xmb_file.xmb04,
        xmb05       LIKE xmb_file.xmb05,
        xmb06       LIKE xmb_file.xmb06,
        azi03       LIKE azi_file.azi03,
        xmd06       LIKE xmd_file.xmd06,
        xmd08       LIKE xmd_file.xmd08,
        xmd09       LIKE xmd_file.xmd09,
        oah02       LIKE oah_file.oah02,
        occ02       LIKE occ_file.occ02,
        oag02       LIKE oag_file.oag02,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021   #FUN-5A0060 add
                    END RECORD
   OUTPUT
       TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
    ORDER BY sr.xmb01,sr.xmb02,sr.xmb03,sr.xmb04,sr.xmb05,sr.xmd06,sr.xmd08
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
           PRINTX name=D1 COLUMN g_c[31],sr.xmb01,
                          COLUMN g_c[32],sr.xmb02,
                          COLUMN g_c[33],sr.xmb03,
                          COLUMN g_c[34],sr.xmb04,
                          COLUMN g_c[35],sr.xmb05;
           LET l_i = 0
 
        ON EVERY ROW
#          PRINTX name=D1 COLUMN g_c[36],sr.xmd06,     #TQC-6B0139
           PRINTX name=D1 COLUMN g_c[36],sr.xmd06[1,30],     #TQC-6B0139
                          COLUMN g_c[37],cl_numfor(sr.xmd08,37,0)
           LET l_i = l_i + 1
           IF l_i = 1 THEN
              PRINTX name=D2 COLUMN g_c[38],sr.oah02[1,g_w[38]],
                             COLUMN g_c[39],sr.xmb06,
                             COLUMN g_c[40],sr.occ02,
                             COLUMN g_c[41],sr.oag02[1,g_w[41]];
           END IF
#          PRINTX name=D2 COLUMN g_c[42],sr.ima02 CLIPPED,  #MOD-4A0238 #TQC-6B0139
           PRINTX name=D2 COLUMN g_c[42],sr.ima02[1,30],  #TQC-6B0139
                          COLUMN g_c[43],cl_numfor(sr.xmd09,43,0)
#          PRINTX name=D3 COLUMN g_c[45],sr.ima021 CLIPPED   #FUN-5A0060 add #TQC-6B0139
           PRINTX name=D3 COLUMN g_c[45],sr.ima021[1,30]   #FUN-5A0060 add #TQC-6B0139
 
        AFTER GROUP OF sr.xmb05
           SKIP 1 LINE
 
        ON LAST ROW
            PRINT g_dash
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN 
                 #TQC-630166
                 #  IF g_wc[001,080] > ' ' THEN
		 #     PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                 #  IF g_wc[071,140] > ' ' THEN
		 #     PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                 #  IF g_wc[141,210] > ' ' THEN
		 #     PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
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
#BugNo:mandy
FUNCTION i510_ctry_xmd08()
 DEFINE l_i LIKE type_file.num10,   #No.FUN-680137 INTEGER 
        l_xmd08 LIKE xmd_file.xmd08
    LET l_i = l_ac
    LET l_xmd08 = g_xmd[l_ac].xmd08
    IF cl_confirm('abx-080') THEN
        #先update 本筆的資料
        UPDATE xmd_file
           SET xmd08 = l_xmd08
         WHERE xmd01 = g_xmb.xmb01
           AND xmd02 = g_xmb.xmb02
           AND xmd03 = g_xmb.xmb03
           AND xmd04 = g_xmb.xmb04
           AND xmd05 = g_xmb.xmb05
           AND xmd06 = g_xmd[l_i].xmd06
           AND xmd07 = g_xmd[l_i].xmd07
           AND xmd08 = g_xmd_t.xmd08 #***************注意
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_xmd[l_i].xmd08,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","xmd_file",g_xmb.xmb01,g_xmd[l_i].xmd06,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            LET g_success='N'
            RETURN
        END IF
        LET g_xmd_o.xmd08 = g_xmd_t.xmd08
        LET g_xmd_t.xmd08 = l_xmd08
        WHILE l_i <= g_rec_b  #自本行至最後一行延用此值
              UPDATE xmd_file
                 SET xmd08 = l_xmd08
               WHERE xmd01 = g_xmb.xmb01
                 AND xmd02 = g_xmb.xmb02
                 AND xmd03 = g_xmb.xmb03
                 AND xmd04 = g_xmb.xmb04
                 AND xmd05 = g_xmb.xmb05
                 AND xmd06 = g_xmd[l_i].xmd06
                 AND xmd07 = g_xmd[l_i].xmd07
                 AND xmd08 = g_xmd[l_i].xmd08 #***************注意
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_xmd[l_i].xmd08,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","xmd_file",g_xmb.xmb01,g_xmd[l_i].xmd06,SQLCA.sqlcode,"","",1)  #No.FUN-660167
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
    CALL i510_show()
END FUNCTION
FUNCTION i510_ctry_xmd09()
 DEFINE l_i  LIKE type_file.num10,   #No.FUN-680137  INTEGER
        l_xmd09 LIKE xmd_file.xmd09
    LET l_i = l_ac
    LET l_xmd09 = g_xmd[l_ac].xmd09
    IF cl_confirm('abx-080') THEN
        WHILE l_i <= g_rec_b  #自本行至最後一行延用此值
              UPDATE xmd_file
                 SET xmd09 = l_xmd09
               WHERE xmd01 = g_xmb.xmb01
                 AND xmd02 = g_xmb.xmb02
                 AND xmd03 = g_xmb.xmb03
                 AND xmd04 = g_xmb.xmb04
                 AND xmd05 = g_xmb.xmb05
                 AND xmd06 = g_xmd[l_i].xmd06
                 AND xmd07 = g_xmd[l_i].xmd07
                 AND xmd08 = g_xmd[l_i].xmd08
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_xmd[l_i].xmd09,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","xmd_file",g_xmb.xmb01,g_xmd[l_i].xmd06,SQLCA.sqlcode,"","",1)  #No.FUN-660167
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
    CALL i510_show()
END FUNCTION
 
#FUN-870100 ADD-------------------------------
#單頭                                                                                                                               
FUNCTION i510_set_entry(p_cmd)                                                                                                      
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)                                                              
                                                                                                                                    
   IF (NOT g_before_input_done) THEN                                                                                                
       CALL cl_set_comp_entry("xmb01,xmb02,xmb03,xmb04,xmb05",TRUE)                                                                 
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                            
 
FUNCTION i510_set_no_entry(p_cmd)                                                                                                   
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)                                                              
                                                                                                                                    
   IF (NOT g_before_input_done) THEN                                                                                                
       IF p_cmd = 'u' AND g_chkey = 'N' THEN                                                                                        
           CALL cl_set_comp_entry("xmb01,xmb02,xmb03,xmb04,xmb05",FALSE)                                                            
       END IF                                                                                                                       
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION              
#FUN-870100  END-------------------------------
 
FUNCTION i510_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
#      CALL cl_set_comp_entry("xmd06,xmd07",TRUE)     #No.TQC-6B0139
 #     CALL cl_set_comp_entry("xmd06",TRUE)     #No.TQC-6B0139  #FUN-C90163 MARK
       CALL cl_set_comp_entry("xmd06,xmd07",TRUE)   #FUN-C90163 ADD
   END IF
 
END FUNCTION
 
FUNCTION i510_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_before_input_done = FALSE THEN
#      CALL cl_set_comp_entry("xmd06,xmd07",FALSE)     #No.TQC-6B0139
      #CALL cl_set_comp_entry("xmd06",FALSE)     #No.TQC-6B0139 #FUN-9C0163 MARK
       CALL cl_set_comp_entry("xmd06,xmd07",FALSE)      #FUN-9C0163 ADD
   END IF
 
END FUNCTION
#No.FUN-870144

#FUN-9C0163 ADD START-----------------------------------------------------
FUNCTION i510_xmd06(p_cmd)   
    DEFINE l_ima02    LIKE ima_file.ima02, 
           l_ima908   LIKE ima_file.ima908,  
           l_imaacti  LIKE ima_file.imaacti,
           l_cnt      LIKE type_file.num5,          
           p_cmd      LIKE type_file.chr1          
 
    LET g_errno = ' '
    SELECT ima02,imaacti,ima908 INTO l_ima02,l_imaacti,l_ima908  
      FROM ima_file WHERE ima01 = g_xmd[l_ac].xmd06
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                            LET l_ima02 = NULL 
                            LET l_ima908= NULL  
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'    
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_xmd[l_ac].ima02 = l_ima02 
       LET g_xmd[l_ac].ima908= l_ima908 
    END IF
END FUNCTION
 
FUNCTION i510_xmd07()  
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
                WHERE gfe01 = g_xmd[l_ac].xmd07
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                            LET l_gfeacti = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
#FUN-9C0163 ADD END-----------------------------------------------------

#No.FUN-BB0086---start---add---
FUNCTION i510_xmd08_check(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1
DEFINE l_cnt      LIKE type_file.num5

   IF NOT cl_null(g_xmd[l_ac].xmd07) AND NOT cl_null(g_xmd[l_ac].xmd08) THEN
      IF cl_null(g_xmd_t.xmd08) OR cl_null(g_xmd07_t) OR g_xmd_t.xmd08 != g_xmd[l_ac].xmd08 OR g_xmd07_t != g_xmd[l_ac].xmd07 THEN
         LET g_xmd[l_ac].xmd08=s_digqty(g_xmd[l_ac].xmd08, g_xmd[l_ac].xmd07)
         DISPLAY BY NAME g_xmd[l_ac].xmd08
      END IF
   END IF
   
   IF NOT cl_null(g_xmd[l_ac].xmd08) THEN
      IF g_xmd[l_ac].xmd08 <= 0 THEN #TQC-BC0060
      CALL cl_err(g_xmd[l_ac].xmd08,'mfg1322',0)
      RETURN FALSE 
      END IF
   END IF
   IF p_cmd = 'a' OR (p_cmd = 'u' AND
      (g_xmd[l_ac].xmd06 != g_xmd_t.xmd06 OR
      g_xmd[l_ac].xmd07 != g_xmd_t.xmd07 OR
      g_xmd[l_ac].xmd08 != g_xmd_t.xmd08)) THEN
      SELECT COUNT(*) INTO l_cnt FROM xmd_file
       WHERE xmd01 = g_xmb.xmb01 AND xmd02 = g_xmb.xmb02
         AND xmd03 = g_xmb.xmb03 AND xmd04 = g_xmb.xmb04
         AND xmd05 = g_xmb.xmb05 AND xmd06 = g_xmd[l_ac].xmd06
         AND xmd07 = g_xmd[l_ac].xmd07 AND xmd08 = g_xmd[l_ac].xmd08
      IF l_cnt > 0 THEN
         CALL cl_err('',-239,0) 
         RETURN FALSE 
      END IF
   END IF
   IF NOT cl_null(g_xmd[l_ac].xmd08) THEN
      IF g_xmd[l_ac].xmd08 = 0 THEN
      LET g_xmd[l_ac].xmd09 = 100
      END IF
   END IF
   RETURN TRUE 
END FUNCTION
#No.FUN-BB0086---end---add---

