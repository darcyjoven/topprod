# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aimt380.4gl
# Descriptions...: 料件多單位庫存調整單維護
# Date & Author..: 05/04/27 by ice
# Modify.........: No.FUN-560132 05/06/20 By ice 單身修改不可修改單位
# Modify.........: No.FUN-560183 05/06/23 By kim 移除ima86成本單位
# Modify.........: No.FUN-570036 05/07/18 By Carrier 修改tlff13為aimt3801/aimt3802
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-630052 06/03/07 By Claire 流程訊息通知傳參數
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660080 06/06/14 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3 
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/27 By jamie 新增action"相關文件"
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/10 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-710025 07/01/26 By bnlent  錯誤信息匯整
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-790058 07/09/10 By judy  打印多處一空白頁
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840019 08/04/28 By lutingting報表轉為使用CR輸出
# Modify.........: No.MOD-880009 08/08/01 By claire 刪除時會發生-404的錯誤
# Modify.........: No.CHI-880023 08/08/19 By claire 參數不使用多單位不何使用本支作業
# Modify.........: No.FUN-8A0086 08/10/17 By zhaijie添加錯誤匯總函數s_showmsg()
# Modify.........: No.TQC-930155 09/04/14 By Zhangyajun Lock imgg_file失敗時添加g_success賦值
# Modify.........: No.FUN-980004 09/08/25 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0062 10/10/24 By 倉庫權限使用控管修改
# Modify.........: No.FUN-AA0059 10/10/29 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-AB0067 10/11/16 by destiny  增加倉庫的權限控管
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80070 11/08/08 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No.MOD-B80003 11/08/18 By Vampire 在 delete from tlff_file 的 where 加上 tlff036=g_imh.imh01
# Modify.........: No.FUN-BB0084 11/12/01 By 增加數量欄位小數取位 
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No.CHI-C30107 12/06/08 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80107 12/09/18 By suncx 新增可按倉庫進行負庫存判斷
# Modify.........: No.CHI-C70017 12/10/29 By bart 關帳日管控
# Modify.........: No:CHI-C80041 12/12/18 By bart 刪除單頭
# Modify.........: No:CHI-D20010 13/02/20 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30024 13/03/12 By qiull 負庫存依據imd23判斷
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查 
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
   g_imh       RECORD LIKE imh_file.*,           #庫存調撥調整(單頭)
   g_imh_t     RECORD LIKE imh_file.*,           #庫存調撥調整(舊值)
   g_imh_o     RECORD LIKE imh_file.*,           #庫存調撥調整(舊值)
   g_imh01_t   LIKE imh_file.imh01,              #單號(舊值)
   g_ima02     LIKE ima_file.ima02,              #品名
   g_ima021    LIKE ima_file.ima021,             #規格
   g_ima906    LIKE ima_file.ima906,             #單位使用方法:
                                                 #一.單一單位
                                                 #二.母子單位
                                                 #三.參考單位
  #g_ima86     LIKE ima_file.ima86,              #成本單位 #FUN-560183
   g_smydesc   LIKE smy_file.smydesc,            #單據名稱
   g_img09     LIKE img_file.img09,              #庫存單位
   g_img10     LIKE img_file.img10,              #庫存總計
   g_yy,g_mm   LIKE type_file.num5,              #用于計算年度、期別  #No.FUN-690026 SMALLINT
   g_date1     LIKE type_file.dat,               #上一期別起始日期  #No.FUN-690026 DATE
   g_date2     LIKE type_file.dat,               #上一期別結束日期  #No.FUN-690026 DATE
   g_yy1       LIKE type_file.num5,              #上一期別所在年份  #No.FUN-690026 SMALLINT
   g_mm1       LIKE type_file.num5,              #上一期別所在月份  #No.FUN-690026 SMALLINT
   g_imi       DYNAMIC ARRAY OF RECORD           #程式變數(Prinram Variables)
	       imi02    LIKE imi_file.imi02,
               imi03    LIKE imi_file.imi03,
               imi04    LIKE imi_file.imi04,
               imi07    LIKE imi_file.imi07,
               imi08    LIKE imi_file.imi08,
               imi07_d  LIKE imi_file.imi07,
               imi05    LIKE imi_file.imi05,
               imi06    LIKE imi_file.imi06
               END RECORD,
   g_imi_t     RECORD
               imi02    LIKE imi_file.imi02,
               imi03    LIKE imi_file.imi03,
               imi04    LIKE imi_file.imi04,
               imi07    LIKE imi_file.imi07,
               imi08    LIKE imi_file.imi08,
               imi07_d  LIKE imi_file.imi07,
               imi05    LIKE imi_file.imi05,
               imi06    LIKE imi_file.imi06
               END RECORD,
   b_imi       RECORD LIKE imi_file.*,           #庫存調撥調整單身檔
   g_t1               LIKE smy_file.smyslip,     #單別ima01(1-5碼)(用于判斷) #No.FUN-690026 VARCHAR(05)
   g_sheet            LIKE smy_file.smyslip,     #單別ima01(1-5碼)(沿用)     #No.FUN-690026 VARCHAR(05)
   g_wc,g_wc2         string,  #No.FUN-580092 HCN
   g_sql              string,  #No.FUN-580092 HCN
   g_rec_b            LIKE type_file.num5,       #單身筆數 #No.FUN-690026 SMALLINT
   g_void             LIKE type_file.chr1,       #有效否   #No.FUN-690026 VARCHAR(1)
   l_ac               LIKE type_file.num5,       #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
   g_imgg09           LIKE imgg_file.imgg09,     #庫存單位
   g_imgg10_t         LIKE imgg_file.imgg10,     #庫存總計 #No.FUN-690026 DEC(15,3)
   g_imgg10_t1        LIKE imgg_file.imgg10,     #庫存總計 #No.FUN-690026 DEC(15,3)
   g_imgg10_t2        LIKE imgg_file.imgg10,     #庫存總計 #No.FUN-690026 DEC(15,3)
   g_argv1	      LIKE imh_file.imh01        #單號     #TQC-630052
DEFINE g_argv2        STRING                     # 指定執行的功能   #TQC-630052
DEFINE p_row,p_col    LIKE type_file.num5        #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql   STRING                     #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5        #No.FUN-690026 SMALLINT
DEFINE g_factor              LIKE ima_file.ima31_fac,   #目的、來源單位轉換率  #No.FUN-690026 DECIMAL(16,8)
       g_tot                 LIKE img_file.img10,       #庫存數量
       g_flag                LIKE type_file.chr1        #No.FUN-690026 VARCHAR(1)
DEFINE g_chr                 LIKE type_file.chr1        #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10       #單身筆數  #No.FUN-690026 INTEGER
DEFINE g_i                   LIKE type_file.num5        #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000     #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count           LIKE type_file.num10       #總筆數  #No.FUN-690026 INTEGER
DEFINE g_curs_index          LIKE type_file.num10       #單頭當前筆  #No.FUN-690026 INTEGER
DEFINE g_jump                LIKE type_file.num10       #查詢指定的筆數  #No.FUN-690026 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5        #是否開啟指定筆窗口  #No.FUN-690026 SMALLINT
DEFINE g_cnt1                LIKE type_file.num10       #轉換率是否存在  #No.FUN-690026 INTEGER
DEFINE l_sql                 STRING                     #No.FUN-840019
DEFINE g_str                 STRING                     #No.FUN-840019
DEFINE l_table               STRING                     #No.FUN-840019
DEFINE g_imi03_t             LIKE imi_file.imi03        #FUN-BB0084
 
MAIN
#DEFINE
#       l_time   LIKE type_file.chr8                 #No.FUN-6A0074
 
   OPTIONS                                       #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                               #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)           #TQC-630052
   LET g_wc2=' 1=1'
 
  #MOD-880009-begin-mark
  # LET g_forupd_sql = "SELECT * FROM imh_file WHERE imh01 = ? FOR UPDATE"
  # DECLARE t380_cl CURSOR FROM g_forupd_sql
  #MOD-880009-end-mark
 
   #CHI-880023-begin-add
   IF g_sma.sma115 !='Y' THEN #不使用多單位 
      #參數設定不使用多單位,所以無法執行此支程式!
      CALL cl_err('','asm-383',1)
      EXIT PROGRAM
   END IF 
   #CHI-880023-end-add
 
     CALL  cl_used(g_prog,g_time,1)              #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
 
     #No.FUN-840019----start--
     LET l_sql = "imh01.imh_file.imh01,",   
                 "imh05.imh_file.imh05,",   
                 "imh02.imh_file.imh02,",   
                 "imh06.imh_file.imh06,",   
                 "imh04.imh_file.imh04,",   
                 "imh07.imh_file.imh07,",   
                 "ima02.ima_file.ima02,",   
                 "imh09.imh_file.imh09,",   
                 "img09.img_file.img09,",   
                 "ima021.ima_file.ima021,", 
                 "imh08.imh_file.imh08,",   
                 "imi02.imi_file.imi02,",   
                 "imi03.imi_file.imi03,",   
                 "imi04.imi_file.imi04,",   
                 "imi07.imi_file.imi07,",   
                 "imi08.imi_file.imi08,",   
                 "imi05.imi_file.imi05,",   
                 "imi06.imi_file.imi06"     
     LET l_table = cl_prt_temptable('aimt380',l_sql) CLIPPED
     IF l_table=-1 THEN EXIT PROGRAM END IF
     
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?)"
     PREPARE insert_prep FROM l_sql
     IF STATUS THEN 
        CALL cl_err('insert_prep:',STATUS,1)  EXIT PROGRAM 
     END IF
     #No.FUN-840019----end
  #MOD-880009-begin-add
   LET g_forupd_sql = "SELECT * FROM imh_file WHERE imh01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t380_cl CURSOR FROM g_forupd_sql
  #MOD-880009-end-add
 
   INITIALIZE g_imh.* TO NULL
   INITIALIZE g_imh_t.* TO NULL
   INITIALIZE g_imh_o.* TO NULL
 
   LET p_row = 2 LET p_col = 6
   OPEN WINDOW t380_w AT p_row,p_col             #顯示畫面
        WITH FORM "aim/42f/aimt380"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
  #TQC-630052-begin
  #IF NOT cl_null(g_argv1) THEN CALL t380_q() END IF
  # 先以g_argv2判斷直接執行哪種功能，執行Q時，g_argv1是單號(imm01)
  # 執行I時，g_argv1是單號(imm01)
  IF NOT cl_null(g_argv1) THEN
     CASE g_argv2
        WHEN "query"
           LET g_action_choice = "query"
           IF cl_chk_act_auth() THEN
              CALL t380_q()
           END IF
        WHEN "insert"
           LET g_action_choice = "insert"
           IF cl_chk_act_auth() THEN
              CALL t380_a()
           END IF
        OTHERWISE
              CALL t380_q()
     END CASE
  END IF
  #TQC-630052-end
 
   LET g_sheet  = NULL
   CALL t380_menu()
 
   CLOSE WINDOW t380_w                           #結束畫面
     CALL  cl_used(g_prog,g_time,2)              #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
FUNCTION t380_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM
 
   IF cl_null(g_argv1) THEN
      CLEAR FORM                                 #清除畫面
      CALL g_imi.clear()
   END IF
 
   IF cl_null(g_argv1) THEN  #TQC-630052
   INITIALIZE g_imh.* TO NULL   #FUN-640213 add 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   CONSTRUCT BY NAME g_wc ON imh01,imh03,imh02,  # 螢幕上取單頭條件
                             imh04,imh05,imh06,imh07,imh08,imhconf,imhpost, #FUN-660080
                             imhuser,imhgrup,imhmodu,imhdate
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
      ON ACTION controlp
         CASE
            WHEN INFIELD(imh01)                  #查詢單据
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
  	       LET g_qryparam.form = "q_imh"
               LET g_qryparam.default1 = g_imh.imh01
 	       CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret to imh01
               NEXT FIELD imh01
 
            WHEN INFIELD(imh04)                  #料號 据
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
  	       LET g_qryparam.form = "q_imh1"
               LET g_qryparam.default1 = g_imh.imh04
 	       CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret to imh04
               NEXT FIELD imh04
 
            WHEN INFIELD(imh05)                  #倉庫 据
               #No.FUN-AB0067--begin 
               #CALL cl_init_qry_var()
               #LET g_qryparam.state= "c"
               #LET g_qryparam.form = "q_imh2"
               #LET g_qryparam.default1 = g_imh.imh05
               #CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret 
 	             #No.FUN-AB0067--end
               DISPLAY g_qryparam.multiret to imh05
               NEXT FIELD imh05
 
            WHEN INFIELD(imh06)                  #儲位 据
               #No.FUN-AB0067--begin  
               #CALL cl_init_qry_var()
               #LET g_qryparam.state= "c"
               #LET g_qryparam.form = "q_imh3"
               #LET g_qryparam.default1 = g_imh.imh06
               #CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","") RETURNING g_qryparam.multiret
               #No.FUN-AB0067--end
               DISPLAY g_qryparam.multiret to imh06
               NEXT FIELD imh06
 
            WHEN INFIELD(imh07)                  #批號 据
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
  	       LET g_qryparam.form = "q_imh4"
               LET g_qryparam.default1 = g_imh.imh07
 	       CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret to imh07
               NEXT FIELD imh07
 
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   CONSTRUCT g_wc2 ON imi02,imi03,imi04,imi07,imi08,imi05,imi06
        FROM s_imi[1].imi02,s_imi[1].imi03,s_imi[1].imi04,s_imi[1].imi07,
             s_imi[1].imi08,s_imi[1].imi05,s_imi[1].imi06
 
      BEFORE CONSTRUCT
         CALL g_imi.clear()
		#No.FUN-580031 --start--     HCN
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(imi03)                  #單位
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_imi"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imi03
               NEXT FIELD imi03
 
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
 
  #TQC-630052-begin
   ELSE
      LET g_wc =" imh01 = '",g_argv1,"'"  
      LET g_wc2 =" 1=1"  
   END IF
  #TQC-630052-end
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND imhuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND imhgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND imhgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imhuser', 'imhgrup')
   #End:FUN-980030
 
   IF g_wc2 = " 1=1" THEN			 # 若單身未輸入條件
      LET g_sql = "SELECT imh01 FROM imh_file",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY imh01"
   ELSE					         # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE imh_file.imh01 ",
                  "  FROM imh_file,imi_file",
                  " WHERE ", g_wc CLIPPED,
                  "   AND imh01 IN (SELECT UNIQUE imh01 ",
                  "  FROM imh_file,imi_file ",
                  " WHERE imh01 = imi01 ",
                  "   AND ",g_wc2 CLIPPED," ) ",
                  " ORDER BY imh01"
   END IF
 
   PREPARE t380_prepare FROM g_sql
   DECLARE t380_cs                               #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t380_prepare
 
   IF g_wc2 = " 1=1" THEN		         # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM imh_file ",
                " WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT imh01) FROM imh_file,imi_file ",
                " WHERE imh01 = imi01  ",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t380_precount FROM g_sql
   DECLARE t380_count CURSOR FOR t380_precount
END FUNCTION
 
FUNCTION t380_menu()
 
   WHILE TRUE
      CALL t380_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t380_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t380_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t380_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t380_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t380_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t380_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #FUN-660080...............begin
       #@WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t380_y_chk()
               IF g_success = "Y" THEN
                  CALL t380_y_upd()
               END IF
            END IF
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t380_z()
            END IF
         #FUN-660080...............end
         WHEN "post"	
            IF cl_chk_act_auth() THEN
               CALL t380_s()
               CALL s_showmsg()            #FUN-8A0086
               IF g_imh.imhconf = 'X' THEN #FUN-660080
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_imh.imhconf,"",g_imh.imhpost,"",g_void,"") #FUN-660080
               DISPLAY g_imh.imhpost TO imhpost
            END IF
         WHEN "undo_post"	
            IF cl_chk_act_auth() THEN
               CALL t380_t()
               IF g_imh.imhconf = 'X' THEN #FUN-660080
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_imh.imhconf,"",g_imh.imhpost,"",g_void,"") #FUN-660080
               DISPLAY g_imh.imhpost TO imhpost
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t380_x()     #CHI-D20010
               CALL t380_x(1)    #CHI-D20010
               IF g_imh.imhconf = 'X' THEN #FUN-660080
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_imh.imhconf,"",g_imh.imhpost,"",g_void,"") #FUN-660080
               DISPLAY g_imh.imhconf TO imhconf #FUN-660080
            END IF
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t380_x(2)
               IF g_imh.imhconf = 'X' THEN #FUN-660080
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_imh.imhconf,"",g_imh.imhpost,"",g_void,"") #FUN-660080
               DISPLAY g_imh.imhconf TO imhconf #FUN-660080
             END IF
       #CHI-D20010---end
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imi),'','')
            END IF
    
         #No.FUN-680046-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
              IF g_imh.imh01 IS NOT NULL THEN
                LET g_doc.column1 = "imh01"
                LET g_doc.value1 = g_imh.imh01
                CALL cl_doc()
              END IF
          END IF
         #No.FUN-680046-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t380_a()
   DEFINE   li_result   LIKE type_file.num5    #No.FUN-690026 SMALLINT
   DEFINE   l_wc2       LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
   MESSAGE ""
   CLEAR FORM
   CALL g_imi.clear()
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_imh.* LIKE imh_file.*
   LET g_imh01_t = NULL
   IF (g_sheet IS NULL) THEN
      LET g_imh.imh01 = NULL
   ELSE
      LET g_imh.imh01 = g_sheet
   END IF
   LET g_imh.imh03 = g_today
   LET g_imh.imh02 = g_today
   LET g_imh.imhplant = g_plant #FUN-980004 add
   LET g_imh.imhlegal = g_legal #FUN-980004 add
 
   LET g_imh_t.* = g_imh.*
   LET g_imh_o.* = g_imh.*
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_imh.imhuser = g_user
      LET g_data_plant = g_plant #FUN-980030
      LET g_imh.imhgrup = g_grup
      LET g_imh.imhdate = g_today
      LET g_imh.imhpost = 'N'
      LET g_imh.imhconf='N' #FUN-660080
      CALL t380_i("a")                           #輸入單頭
      IF INT_FLAG THEN
         INITIALIZE g_imh.* TO NULL
         LET INT_FLAG=0
         CALL cl_err('',9001,0)
         RETURN
      END IF
      IF g_imh.imh01 IS NULL THEN
         CONTINUE WHILE
      END IF
      #輸入後, 若該單據需自動編號, 并且其單號為空白, 則自動賦予單號
      BEGIN WORK
      CALL s_auto_assign_no("aim",g_imh.imh01,g_imh.imh02,"","imh_file","imh01","","","")
         RETURNING li_result,g_imh.imh01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
 
      DISPLAY BY NAME g_imh.imh01
      LET g_imh.imhoriu = g_user      #No.FUN-980030 10/01/04
      LET g_imh.imhorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO imh_file VALUES (g_imh.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      #   ROLLBACK WORK       #FUN-B80070---回滾放在報錯後---
#        CALL cl_err('ins imh: ',SQLCA.SQLCODE,1)
         CALL cl_err3("ins","imh_file",g_imh.imh01,"",SQLCA.sqlcode,"",
                      "ins imh",1)   #NO.FUN-640266 #No.FUN-660156
         ROLLBACK WORK          #FUN-B80070--add--
         CONTINUE WHILE
      ELSE
         CALL s_get_doc_no(g_imh.imh01) RETURNING g_sheet
         COMMIT WORK
         CALL cl_flow_notify(g_imh.imh01,'I')
      END IF
 
      SELECT imh01 INTO g_imh.imh01 FROM imh_file
       WHERE imh01 = g_imh.imh01
      LET g_imh01_t = g_imh.imh01
      LET g_imh_t.* = g_imh.*
      LET g_imh_o.* = g_imh.*
      CALL g_imi.clear()
      LET g_rec_b = 0                    #No.FUN-680064
      IF g_ima906 = '2' THEN
         LET l_wc2=' 1=1'
         CALL t380_b_fill(l_wc2)
         CALL t380_b()                              #輸入單身
      ELSE
         MESSAGE 'INSERT OK'
      END IF
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t380_b_bring()                           #自動產生單身資料
DEFINE l_wc2   LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
DEFINE l_imi02 LIKE imi_file.imi02    #項次  #No.FUN-690026 INTEGER
 
   DECLARE t380_b2_b CURSOR FOR
     SELECT '',0,imgg09,1,0,'',imgg10,imgg10,'',''
       FROM imgg_file
      WHERE imgg01 = g_imh.imh04
        AND imgg02 = g_imh.imh05
        AND imgg03 = g_imh.imh06
        AND imgg04 = g_imh.imh07
   BEGIN WORK
   LET g_success = 'Y'
   LET l_imi02 = 1
   FOREACH t380_b2_b INTO b_imi.*
      IF STATUS THEN EXIT FOREACH END IF
      IF NOT cl_null(b_imi.imi03) THEN
         MESSAGE 's_ read parts:',b_imi.imi03
         CALL s_umfchk(g_imh.imh04,b_imi.imi03,g_img09)
             RETURNING g_cnt1,b_imi.imi04
         IF g_cnt1 THEN
            CALL cl_err('','mfg3075',0)
         END IF
         INSERT INTO imi_file (imi01,imi02,imi03,imi04,imi07,imi08,imi05,imi06,imiplant,imilegal) #FUN-980004 add imiplant,imilegal
                       VALUES (g_imh.imh01,l_imi02,b_imi.imi03,b_imi.imi04,
                               b_imi.imi07,b_imi.imi08,b_imi.imi05,b_imi.imi06,g_plant,g_legal) #FUN-980004 add g_plant,g_legal
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('insert imi01: ',SQLCA.SQLCODE,1)
            CALL cl_err3("ins","imi_file",g_imh.imh01,"",SQLCA.sqlcode,"",
                         "insert imi01",1)   #NO.FUN-640266  #No.FUN-660156
         END IF
         LET l_imi02 = l_imi02 + 1
      END IF
   END FOREACH
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   LET l_wc2=' 1=1'
   CALL t380_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t380_u()
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_imh.imh01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_imh.* FROM imh_file WHERE imh01 = g_imh.imh01
   IF g_imh.imhconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF #FUN-660080
   IF g_imh.imhpost = 'Y' THEN CALL cl_err('','asf-812',0) RETURN END IF
   IF g_imh.imhconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF #FUN-660080
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_imh_o.* = g_imh.*
   BEGIN WORK
 
   OPEN t380_cl USING g_imh.imh01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_imh.imh01,SQLCA.sqlcode,0)    # 資料被他人LOCK
      CLOSE t380_cl
      ROLLBACK WORK
      RETURN
   ELSE
      FETCH t380_cl INTO g_imh.*                  # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_imh.imh01,SQLCA.sqlcode,0) # 資料被他人LOCK
         CLOSE t380_cl
         ROLLBACK WORK
         RETURN
      END IF
   END IF
   CALL t380_show()
   WHILE TRUE
      LET g_imh01_t = g_imh.imh01
      LET g_imh_o.* = g_imh.*
      LET g_imh.imhmodu = g_user
      LET g_imh.imhdate = g_today
      CALL t380_i("u")                           #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_imh.*=g_imh_t.*
         CALL t380_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_imh.imh01 != g_imh_t.imh01 THEN
         UPDATE imi_file SET imi01 = g_imh.imh01 WHERE imi01 = g_imh01_t
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('upd imi01: ',SQLCA.SQLCODE,1)
            CALL cl_err3("upd","imi_file",g_imh01_t,"",SQLCA.sqlcode,"",
                         "upd imi01",1)   #NO.FUN-640266  #No.FUN-660156
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE imh_file SET imh02 = g_imh.imh02,
                          imh04 = g_imh.imh04,
                          imh05 = g_imh.imh05,
                          imh06 = g_imh.imh06,
                          imh07 = g_imh.imh07,
                          imh08 = g_imh.imh08,
                          imh09 = g_imh.imh09,
                          #imhpost = g_imh.imhpost, #mark by FUN-660080
                          imhuser = g_imh.imhuser,
                          imhgrup = g_imh.imhgrup,
                          imhmodu = g_imh.imhmodu,
                          imhdate = g_imh.imhdate
                    WHERE imh01 = g_imh01_t
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('up imh: ',SQLCA.SQLCODE,1)
         CALL cl_err3("upd","imh_file",g_imh_t.imh01,"",SQLCA.sqlcode,"",
                      "up imh",1)   #NO.FUN-640266  #No.FUN-660156
         CONTINUE WHILE
      END IF
 
      #修改主擋資料的料、倉、儲，刪除對應的單身資料
      IF (g_imh.imh04 != g_imh_o.imh04) OR
         (g_imh.imh05 != g_imh_o.imh05) OR
         (g_imh.imh06 != g_imh_o.imh06) OR
         (g_imh.imh07 != g_imh_o.imh07) THEN
         DELETE FROM imi_file WHERE imi01 = g_imh.imh01
         IF SQLCA.SQLCODE THEN
#           CALL cl_err('del imi01: ',SQLCA.SQLCODE,1)
            CALL cl_err3("del","imi_file",g_imh.imh01,"",SQLCA.sqlcode,"",
                         "del imi01",1)   #NO.FUN-640266  #No.FUN-660156
            CONTINUE WHILE
         END IF
         CALL t380_imh04('d')
         CALL t380_imh07('d')
         IF g_ima906 = '2' THEN
            CALL t380_b()
         ELSE
            CALL t380_show()
         END IF
         EXIT WHILE
      END IF
 
      EXIT WHILE
   END WHILE
   CLOSE t380_cl
   COMMIT WORK
   CALL cl_flow_notify(g_imh.imh01,'U')
 
END FUNCTION
 
FUNCTION t380_i(p_cmd)
   DEFINE p_cmd         LIKE type_file.chr1    #a:輸入 u:更改  #No.FUN-690026 VARCHAR(1)
   DEFINE li_result     LIKE type_file.num5    #No.FUN-690026 SMALLINT
   DEFINE l_n           LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   #FUN-660080...............begin
   DISPLAY BY NAME
         g_imh.imh01,g_imh.imh02,g_imh.imh03,g_imh.imhpost,
         g_imh.imhconf,g_imh.imhuser,g_imh.imhgrup,g_imh.imhdate
   #FUN-660080...............end
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INPUT BY NAME
         g_imh.imh01,g_imh.imh03,g_imh.imh02,g_imh.imh04,
         g_imh.imh05,g_imh.imh06,g_imh.imh07,g_imh.imh08
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t380_set_entry(p_cmd)
         CALL t380_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("imh01")
 
      AFTER FIELD imh01
         #單號處理方式:
         #在輸入單別後, 至單據性質檔中讀取該單別資料;
         #若該單別不需自動編號, 則讓使用者自行輸入單號, 并檢查其是否重復
         #若要自動編號, 則單號不用輸入, 直到單頭輸入完成後, 再行自動指定單號
         IF NOT cl_null(g_imh.imh01) THEN
            CALL s_check_no("aim",g_imh.imh01,g_imh01_t,"D","imh_file","imh01","")
               RETURNING li_result,g_imh.imh01
            DISPLAY BY NAME g_imh.imh01
            IF (NOT li_result) THEN
               LET g_imh.imh01 = g_imh_o.imh01
               NEXT FIELD imh01
            END IF
            DISPLAY g_smy.smydesc TO smydesc
         END IF
 
      AFTER FIELD imh02
         IF NOT cl_null(g_imh.imh02) THEN
	    IF g_sma.sma53 IS NOT NULL AND g_imh.imh02 <= g_sma.sma53 THEN
	       CALL cl_err('','mfg9999',0)
               NEXT FIELD imh02
	    END IF
            CALL s_yp(g_imh.imh02) RETURNING g_yy,g_mm
            IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52) THEN #不可大於現行年月
               CALL cl_err('','mfg6091',0)
               NEXT FIELD imh02
            END IF
         END IF
 
      AFTER FIELD imh04
         IF NOT cl_null(g_imh.imh04) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_imh.imh04,"") THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD imh04
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            SELECT COUNT(*) INTO l_n
              FROM ima_file
             WHERE ima01 = g_imh.imh04
               AND  ima906 IN ('1','2','3')
            IF l_n = 0 THEN
               CALL cl_err('','apm-247',0)
               NEXT FIELD imh04
            END IF
         END IF
         CALL t380_imh04('d')
         IF (g_imh.imh04 != g_imh_o.imh04) AND p_cmd = 'u' THEN
            CALL t380_imh07('d')
            LET g_imh.imh09 = g_img10
            LET g_imgg10_t = 0
            LET g_imgg10_t1 = g_img10
            DISPLAY BY NAME g_imh.imh09
            DISPLAY g_imgg10_t TO FORMONLY.imgg10_t
            DISPLAY g_imgg10_t1 TO FORMONLY.imgg10_t1
         END IF
 
      AFTER FIELD imh05
         IF NOT cl_null(g_imh.imh05) THEN
            SELECT COUNT(*) INTO l_n
              FROM imd_file
             WHERE imd01 = g_imh.imh05
            IF l_n = 0 THEN
               CALL cl_err('','mfg1100',0)
               NEXT FIELD imh05
            END IF
#No.FUN-AA0062  --start--           
            IF NOT s_chk_ware(g_imh.imh05) THEN
              NEXT FIELD imh05
            END IF
         END IF
#No.FUN-AA0062  --end--  
         IF (g_imh.imh05 != g_imh_o.imh05) AND p_cmd = 'u' THEN
            CALL t380_imh07('d')
            LET g_imh.imh09 = g_img10
            LET g_imgg10_t = 0
            LET g_imgg10_t1 = g_img10
            DISPLAY BY NAME g_imh.imh09
            DISPLAY g_imgg10_t TO FORMONLY.imgg10_t
            DISPLAY g_imgg10_t1 TO FORMONLY.imgg10_t1
         END IF
	 IF NOT s_imechk(g_imh.imh05,g_imh.imh06) THEN NEXT FIELD imh06 END IF    #FUN-D40103 add 
 
      AFTER FIELD imh06
	#FUN-D40103--mark--str--
        # IF NOT cl_null(g_imh.imh06) THEN
        #    SELECT COUNT(*) INTO l_n
        #      FROM ime_file
         #    WHERE ime01 = g_imh.imh05
         #      AND ime02 = g_imh.imh06
         #   IF l_n = 0 THEN
         #      CALL cl_err('','mfg6081',0)
         #      NEXT FIELD imh06
         #   END IF
         # END IF
	#FUN-D40103--mark--end--
         IF cl_null(g_imh.imh06) THEN LET g_imh.imh06 = ' ' END IF                #FUN-D40103 add
         IF NOT s_imechk(g_imh.imh05,g_imh.imh06) THEN NEXT FIELD imn06 END IF    #FUN-D40103 add 
         IF (g_imh.imh06 != g_imh_o.imh06) AND p_cmd = 'u' THEN
            CALL t380_imh07('d')
            LET g_imh.imh09 = g_img10
            LET g_imgg10_t = 0
            LET g_imgg10_t1 = g_img10
            DISPLAY BY NAME g_imh.imh09
            DISPLAY g_imgg10_t TO FORMONLY.imgg10_t
            DISPLAY g_imgg10_t1 TO FORMONLY.imgg10_t1
         END IF
 
      AFTER FIELD imh07
         CALL t380_imh07('d')
         IF p_cmd = 'a' OR ((g_imh.imh06 != g_imh_o.imh06) AND p_cmd = 'u') THEN
            LET g_imh.imh09 = g_img10
            LET g_imgg10_t = 0
            LET g_imgg10_t1 = g_img10
            DISPLAY BY NAME g_imh.imh09
            DISPLAY g_imgg10_t TO FORMONLY.imgg10_t
            DISPLAY g_imgg10_t1 TO FORMONLY.imgg10_t1
         END IF
 
      AFTER INPUT
         IF cl_null(g_imh.imh06) THEN LET g_imh.imh06 = ' ' END IF
         IF cl_null(g_imh.imh07) THEN LET g_imh.imh07 = ' ' END IF
         CALL t380_imh07('d')
         IF p_cmd = 'a' THEN
            LET g_imh.imh09 = g_img10
            LET g_imgg10_t = 0
            LET g_imgg10_t1 = g_img10
            DISPLAY BY NAME g_imh.imh09
            DISPLAY g_imgg10_t TO FORMONLY.imgg10_t
            DISPLAY g_imgg10_t1 TO FORMONLY.imgg10_t1
         END IF
         IF INT_FLAG THEN RETURN END IF
         SELECT COUNT(*) INTO l_n FROM imh_file
          WHERE imh04 = g_imh.imh04
            AND imh05 = g_imh.imh05
            AND imh06 = g_imh.imh06
            AND imh07 = g_imh.imh07
            AND imh02 > g_imh.imh02
            AND imh01 != g_imh.imh01
         IF l_n > 0 THEN
            CALL cl_err('','aim-903',1)
            NEXT FIELD imh02
         END IF
         SELECT COUNT(*) INTO l_n FROM imh_file
          WHERE imh04 = g_imh.imh04
            AND imh05 = g_imh.imh05
            AND imh06 = g_imh.imh06
            AND imh07 = g_imh.imh07
            AND imh02 = g_imh.imh02
            AND imh01 != g_imh.imh01
         IF l_n > 0 THEN
            IF NOT cl_confirm('aim-901') THEN
               NEXT FIELD imh02
            END IF
         END IF
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(imh01)                  #查詢單据
               LET g_t1=s_get_doc_no(g_imh.imh01)
               CALL q_smy(FALSE,FALSE,g_t1,'AIM','D') RETURNING g_t1 #TQC-670008
               LET g_imh.imh01 = g_t1
               DISPLAY BY NAME g_imh.imh01
               CALL t380_imh01('d')
               NEXT FIELD imh01
 
            WHEN INFIELD(imh04)                  #料號 据
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  LET g_qryparam.form = "q_ima"
             #  LET g_qryparam.where = "  ima906 IN ('1','2','3') "
             #  CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_sel_ima(FALSE, "q_ima", "ima906 IN ('1','2','3')", "" , "", "", "", "" ,"",'' )  RETURNING g_qryparam.multiret
#FUN-AA0059 --End--
               DISPLAY BY NAME g_qryparam.multiret
               LET g_imh.imh04 = g_qryparam.multiret
               NEXT FIELD imh04
 
            WHEN INFIELD(imh05) OR INFIELD(imh06) OR INFIELD(imh07)    #倉庫、儲位、批號 据
               #FUN-C30300---begin
               LET g_ima906 = NULL
               SELECT ima906 INTO g_ima906 FROM ima_file
                WHERE ima01 = g_imh.imh04
               #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
               IF s_industry("icd") THEN  #TQC-C60028
                  CALL q_idc(FALSE,FALSE,g_imh.imh04,'','','')
                RETURNING g_imh.imh05,g_imh.imh06,g_imh.imh07
               ELSE
               #FUN-C30300---end
                  CALL q_img4(FALSE,FALSE,g_imh.imh04,'','','','A')
                      RETURNING g_imh.imh05,g_imh.imh06,g_imh.imh07
               END IF  #FUN-C30300
               DISPLAY g_imh.imh05 TO imh05
               DISPLAY g_imh.imh06 TO imh06
               DISPLAY g_imh.imh07 TO imh07
               IF INFIELD(imh05) THEN NEXT FIELD imh05 END IF
               IF INFIELD(imh06) THEN NEXT FIELD imh06 END IF
               IF INFIELD(imh07) THEN NEXT FIELD imh07 END IF
 
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF                         #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      #MOD-650040  --start 
      #ON ACTION CONTROLO                         # 沿用所有欄位
      #   IF INFIELD(imh01) THEN
      #      LET g_imh.* = g_imh_t.*
      #      CALL t380_show()
      #      NEXT FIELD imh01
      #   END IF
      #MOD-650040  --end
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
END FUNCTION
 
FUNCTION t380_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("imh01",TRUE)
   END IF
END FUNCTION
 
FUNCTION t380_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("imh01",FALSE)
   END IF
END FUNCTION
 
FUNCTION t380_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_imi.clear()
   DISPLAY ' ' TO FORMONLY.cnt
   CALL t380_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_imh.* TO NULL
      RETURN
   END IF
 
   OPEN t380_cs                                  # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_imh.* TO NULL
      RETURN
   END IF
 
   OPEN t380_count
   FETCH t380_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   CALL t380_fetch('F')                          # 讀出TEMP第一筆並顯示
 
END FUNCTION
 
FUNCTION t380_fetch(p_flag)
DEFINE
   p_flag           LIKE type_file.chr1                        #處理方式  #No.FUN-690026 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t380_cs INTO g_imh.imh01
      WHEN 'P' FETCH PREVIOUS t380_cs INTO g_imh.imh01
      WHEN 'F' FETCH FIRST    t380_cs INTO g_imh.imh01
      WHEN 'L' FETCH LAST     t380_cs INTO g_imh.imh01
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
               ON ACTION about
                  CALL cl_about()
               ON ACTION help
                  CALL cl_show_help()
               ON ACTION controlg
                  CALL cl_cmdask()
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump t380_cs INTO g_imh.imh01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_imh.imh01,SQLCA.sqlcode,0)
      INITIALIZE g_imh.* TO NULL  #TQC-6B0105
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
 
   SELECT * INTO g_imh.* FROM imh_file WHERE imh01 = g_imh.imh01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_imh.imh01,SQLCA.sqlcode,0)  #No.FUN-660156
      CALL cl_err3("sel","imh_file",g_imh.imh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156 
      INITIALIZE g_imh.* TO NULL
      RETURN
   END IF
   CALL t380_show()
 
END FUNCTION
 
FUNCTION t380_show()
DEFINE l_wc2   LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
   LET g_imh_t.* = g_imh.*                       #保存單頭舊值
   LET g_imh_o.* = g_imh.*                       #保存單頭舊值
   DISPLAY BY NAME
	g_imh.imh01,g_imh.imh03,g_imh.imh02,g_imh.imh04,g_imh.imh05,
	g_imh.imh06,g_imh.imh07,g_imh.imh09,g_imh.imh08,g_imh.imhconf, #FUN-660080
	g_imh.imhpost,g_imh.imhuser,g_imh.imhgrup,g_imh.imhmodu,g_imh.imhdate
   CALL s_get_doc_no(g_imh.imh01) RETURNING g_sheet
   CALL t380_imh01('d')
   CALL t380_imh04('d')
   CALL t380_imh07('d')
   IF g_imh.imhconf = 'X' THEN #FUN-660080
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_imh.imhconf,"",g_imh.imhpost,"",g_void,"") #FUN-660080
   LET l_wc2 = 'g_wc2'
   LET l_wc2 =' 1=1'
   CALL t380_b_fill(l_wc2)
 
   CALL cl_show_fld_cont()            #設定p_per內有特殊格式設定的欄位
END FUNCTION
 
FUNCTION t380_imh01(p_cmd)
   DEFINE l_smydesc LIKE smy_file.smydesc,
          l_smyacti LIKE smy_file.smyacti,
          l_t1      LIKE smy_file.smyslip, #No.FUN-690026 VARCHAR(05)
          p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   LET g_errno = ""
   LET l_t1 = s_get_doc_no(g_imh.imh01)
   IF g_imh.imh01 IS NULL THEN
      LET g_errno = 'E'
      LET l_smydesc = NULL
   ELSE
      SELECT smydesc,smyacti INTO l_smydesc,l_smyacti
        FROM smy_file
       WHERE smyslip = l_t1
      IF SQLCA.sqlcode THEN
         LET g_errno = 'E'
         LET l_smydesc = NULL
      ELSE
         IF l_smyacti matches '[nN]' THEN
            LET g_errno = 'E'
         END IF
      END IF
   END IF
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_smydesc TO FORMONLY.smydesc
   END IF
 
END FUNCTION
 
FUNCTION t380_imh04(p_cmd)
   DEFINE l_ima02  LIKE ima_file.ima02,
          l_ima021 LIKE ima_file.ima021,
          l_ima906 LIKE ima_file.ima906,
          p_cmd    LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   LET g_errno = ""
   IF cl_null(g_imh.imh04) THEN LET g_imh.imh04 = ' ' END IF
   SELECT ima02,ima021,ima906 INTO l_ima02,l_ima021,l_ima906
     FROM ima_file
    WHERE ima01 = g_imh.imh04
      AND  ima906 IN ('1','2','3')
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg6031'
                                 LET l_ima02 = ''
                                 LET l_ima021 = ''
                                 LET l_ima906 = ''
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_ima02  TO FORMONLY.ima02
      DISPLAY l_ima021 TO FORMONLY.ima021
      DISPLAY l_ima906 TO FORMONLY.ima906
   END IF
   LET g_ima906 = l_ima906
 
END FUNCTION
 
FUNCTION t380_imh07(p_cmd)
   DEFINE l_img09 LIKE img_file.img09,
          l_img10 LIKE img_file.img10,
          p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   LET g_errno = ""
   IF cl_null(g_imh.imh06) THEN LET g_imh.imh06 = ' ' END IF
   IF cl_null(g_imh.imh07) THEN LET g_imh.imh07 = ' ' END IF
   SELECT img09,img10 INTO l_img09,l_img10
     FROM img_file
    WHERE img01 = g_imh.imh04
      AND img02 = g_imh.imh05
      AND img03 = g_imh.imh06
      AND img04 = g_imh.imh07
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'axm-244'
                                 LET l_img09 = ''
                                 LET l_img10 = 0
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_img09 TO FORMONLY.img09
   END IF
   LET g_img09 = l_img09
   LET g_img10 = l_img10
 
END FUNCTION
 
FUNCTION t380_r()
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_imh.imh01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_imh.* FROM imh_file WHERE imh01 = g_imh.imh01
   IF g_imh.imhconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF #FUN-660080
   IF g_imh.imhpost = 'Y' THEN CALL cl_err('','asf-812',0) RETURN END IF
   IF g_imh.imhconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF #FUN-660080
   BEGIN WORK
 
   OPEN t380_cl USING g_imh.imh01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_imh.imh01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   ELSE
      FETCH t380_cl INTO g_imh.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_imh.imh01,SQLCA.sqlcode,0)
         ROLLBACK WORK
         RETURN
      END IF
   END IF
   CALL t380_show()
   IF cl_delh(20,16) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "imh01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_imh.imh01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
      MESSAGE "Delete imh,imi!"
      DELETE FROM imh_file WHERE imh01 = g_imh.imh01
      IF SQLCA.SQLERRD[3]=0
         THEN 
         #CALL cl_err('No imh deleted',SQLCA.SQLCODE,0)
         CALL cl_err3("del","imh_file",g_imh.imh01,"",SQLCA.sqlcode,"",
                      "No imh deleted",1)   #NO.FUN-640266  #No.FUN-660156
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM imi_file WHERE imi01 = g_imh.imh01
      LET g_rec_b = 0
      LET g_msg=TIME
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980004 add azoplant,azolegal
                   VALUES ('aimt380',g_user,g_today,g_msg,g_imh.imh01,'delete',g_plant,g_legal) #FUN-980004 add g_plant,g_legal
      CLEAR FORM
      LET g_imh.imh01 = NULL
      CALL g_imi.clear()
      OPEN t380_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE t380_cs
         CLOSE t380_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH t380_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t380_cs
         CLOSE t380_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t380_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t380_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t380_fetch('/')
      END IF
   END IF
   CLOSE t380_cl
   COMMIT WORK
   CALL cl_flow_notify(g_imh.imh01,'D')
 
END FUNCTION
 
FUNCTION t380_b()
DEFINE
   l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
   l_n,l_cnt       LIKE type_file.num5,      #檢查重複用  #No.FUN-690026 SMALLINT
   l_lock_sw       LIKE type_file.chr1,      #單身鎖住否  #No.FUN-690026 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,      #處理狀態  #No.FUN-690026 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,      #可新增否  #No.FUN-690026 SMALLINT
   l_allow_delete  LIKE type_file.num5       #可刪除否  #No.FUN-690026 SMALLINT
 
   LET g_action_choice = ""
   IF cl_null(g_imh.imh01) THEN RETURN END IF
 
   SELECT * INTO g_imh.* FROM imh_file WHERE imh01=g_imh.imh01
   IF g_imh.imhconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF #FUN-660080
   IF g_imh.imhpost = 'Y' THEN CALL cl_err('','asf-812',0) RETURN END IF
   IF g_imh.imhconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF #FUN-660080
   IF g_ima906 MATCHES "[13]" THEN
      CALL cl_err('',9032,0)
      RETURN
   END IF
   IF g_ima906 = '2' THEN
      SELECT COUNT(*) INTO g_cnt FROM imi_file
       WHERE imi01 = g_imh.imh01
      IF g_cnt = 0 THEN
         IF cl_confirm('aim-904') THEN
            CALL t380_b_bring()                  #自動產生單身資料
         END IF
      END IF
   END IF
 
   CALL cl_opmsg('b')
   LET g_forupd_sql = "SELECT imi02,imi03,imi04,imi07,imi08,imi07-imi08,imi05,imi06 ",
                      "  FROM imi_file ",
                      " WHERE imi01= ? AND imi02= ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t380_bcl CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   IF cl_null(g_imgg10_t) THEN LET g_imgg10_t = 0 END IF
 
   INPUT ARRAY g_imi WITHOUT DEFAULTS FROM s_imi.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'                     #DEFAULT
         LET l_n  = ARR_COUNT()
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      BEGIN WORK
         OPEN t380_cl USING g_imh.imh01
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_imh.imh01,SQLCA.sqlcode,0) # 資料被他人LOCK
               CLOSE t380_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t380_cl INTO g_imh.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_imh.imh01,SQLCA.sqlcode,0) # 資料被他人LOCK
                  CLOSE t380_cl
                  ROLLBACK WORK
                  RETURN
               END IF
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_imi_t.* = g_imi[l_ac].*                 #BACKUP
               LET g_imi03_t = g_imi[l_ac].imi03             #FUN-BB0084  
               OPEN t380_bcl USING g_imh.imh01,g_imi_t.imi02 #表示更改狀態
               IF SQLCA.sqlcode THEN
                  CALL cl_err('OPEN t380_bcl:',STATUS,1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t380_bcl INTO g_imi[l_ac].*
                     IF SQLCA.sqlcode THEN
                        CALL cl_err('lock imi',SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                     END IF
                     LET g_imi[l_ac].imi07 = g_imi_t.imi07
               END IF
            END IF
 
         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_imi[l_ac].* TO NULL
            LET g_imi[l_ac].imi05 = 0
            LET g_imi_t.* = g_imi[l_ac].*
            LET g_imi03_t = NULL        #FUN-BB0084
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD imi02
 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO imi_file (imi01,imi02,imi03,imi04,imi07,imi08,imi05,imi06,imiplant,imilegal) #FUN-980004 add imiplant,imilegal
                           VALUES(g_imh.imh01,g_imi[l_ac].imi02,g_imi[l_ac].imi03,
                                  g_imi[l_ac].imi04,g_imi[l_ac].imi07,g_imi[l_ac].imi08,
                                  g_imi[l_ac].imi05,g_imi[l_ac].imi06,g_plant,g_legal) #FUN-980004 add g_plant,g_legal
            IF SQLCA.sqlcode THEN
#              CALL cl_err('ins imi',SQLCA.sqlcode,1)
               CALL cl_err3("ins","imi_file",g_imh.imh01,"",SQLCA.sqlcode,"",
                            "ins imi",1)   #NO.FUN-640266  #No.FUN-660156
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
         BEFORE FIELD imi02                      #default 序號
            IF g_imi[l_ac].imi02 IS NULL THEN
               SELECT max(imi02)+1 INTO g_imi[l_ac].imi02
                 FROM imi_file WHERE imi01 = g_imh.imh01
               IF g_imi[l_ac].imi02 IS NULL THEN
                  LET g_imi[l_ac].imi02 = 1
               END IF
            END IF
 
         AFTER FIELD imi02                       #check 序號是否重複
            IF NOT cl_null(g_imi[l_ac].imi02) THEN
               IF g_imi[l_ac].imi02 != g_imi_t.imi02 OR
                  g_imi_t.imi02 IS NULL THEN
                  SELECT count(*) INTO l_n FROM imi_file
                   WHERE imi01 = g_imh.imh01 AND imi02 = g_imi[l_ac].imi02
                  IF l_n > 0 THEN
                     LET g_imi[l_ac].imi02 = g_imi_t.imi02
                     CALL cl_err('',-239,0) NEXT FIELD imi02
                     NEXT FIELD imi02
                  END IF
               END IF
               IF g_imi[l_ac].imi02 < 1 THEN
                  NEXT FIELD imi02
               END IF
            END IF
            #FUN.560132 --start--
            CALL t380_set_entry_b(p_cmd)
            CALL t380_set_no_entry_b(p_cmd)
            #FUN.560132 --end--
 
         BEFORE FIELD imi03
            #FUN.560132 --start--
            CALL t380_set_entry_b(p_cmd)
            CALL t380_set_no_entry_b(p_cmd)
            #FUN.560132 --end--
 
         AFTER FIELD imi03
            IF NOT cl_null(g_imi[l_ac].imi03) THEN
               SELECT COUNT(*) INTO l_n FROM gfe_file
                WHERE gfe01 = g_imi[l_ac].imi03
               IF l_n = 0 THEN
                  CALL cl_err(g_imi[l_ac].imi03,'mfg2605',0)
                  NEXT FIELD imi03
               END IF
               IF p_cmd = 'a' THEN
                  SELECT COUNT(imi03) INTO l_n FROM imi_file
                   WHERE imi01 = g_imh.imh01
                     AND imi03 = g_imi[l_ac].imi03
                  IF l_n <> 0 THEN
                     CALL cl_err(g_imi[l_ac].imi03,'-239',0)
                     NEXT FIELD imi03
                  END IF
               END IF
               CALL s_du_umfchk(g_imh.imh04,'','','',
                                g_img09,g_imi[l_ac].imi03,g_ima906)
                      RETURNING g_errno,g_factor
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_imi[l_ac].imi03,g_errno,0)
                  NEXT FIELD imi03
               END IF
               LET g_imi[l_ac].imi04 = g_factor
               CALL s_chk_imgg(g_imh.imh04,g_imh.imh05,g_imh.imh06,
                               g_imh.imh07,g_imi[l_ac].imi03)
                     RETURNING g_flag
               IF g_flag = 1 THEN
                  IF g_sma.sma892[3,3] = 'Y' THEN
                     IF NOT cl_confirm('aim-995') THEN
                        NEXT FIELD imi03
                     END IF
                  END IF
                  CALL s_add_imgg(g_imh.imh04,g_imh.imh05,g_imh.imh06,
                                  g_imh.imh07,g_imi[l_ac].imi03,
                                  g_imi[l_ac].imi04,g_imh.imh01,
                                  g_imi[l_ac].imi02,0)
                        RETURNING g_flag
                  IF g_flag = 1 THEN
                     NEXT FIELD imi03
                  END IF
               END IF
           #FUN-BB0084 ---------------Begin---------------
               IF NOT cl_null(g_imi[l_ac].imi05) AND g_imi[l_ac].imi05<>0 THEN
                  CALL t380_imi05_chk(p_cmd)
               END IF
               IF NOT cl_null(g_imi[l_ac].imi08) AND g_imi[l_ac].imi08<>0 THEN
                  CALL t380_imi08_chk()  
               END IF
               LET g_imi03_t = g_imi[l_ac].imi03
           #FUN-BB0084 ---------------End----------------- 
            END IF
 
         BEFORE FIELD imi08                       #調整數量
            IF cl_null(g_imi[l_ac].imi04) THEN
               LET g_imi[l_ac].imi04 = 0
            END IF
            IF p_cmd = 'a' THEN
               SELECT imgg10 INTO g_imi[l_ac].imi07
                 FROM imgg_file
                WHERE imgg01 = g_imh.imh04
                  AND imgg02 = g_imh.imh05
                  AND imgg03 = g_imh.imh06
                  AND imgg04 = g_imh.imh07
                  AND imgg09 = g_imi[l_ac].imi03
               IF cl_null(g_imi[l_ac].imi07) THEN
                  LET g_imi[l_ac].imi07 = 0
               END IF
               LET g_imi[l_ac].imi08 = g_imi[l_ac].imi07
               LET g_imi[l_ac].imi07_d = g_imi[l_ac].imi07 - g_imi[l_ac].imi08
               LET g_imi[l_ac].imi05 = -g_imi[l_ac].imi07_d
            END IF
 
         AFTER FIELD imi08
         #FUN-BB0084 -------Begin---------
            CALL t380_imi08_chk() 
            NEXT FIELD imi05
         #FUN-BB0084 -------End-----------
         #FUN-BB0084 -------Begin---------
         #  IF cl_null(g_imi[l_ac].imi08) THEN
         #     LET g_imi[l_ac].imi08 = 0
         #  END IF
         #  LET g_imi[l_ac].imi07_d = g_imi[l_ac].imi07 - g_imi[l_ac].imi08
         #  LET g_imi[l_ac].imi05 = -g_imi[l_ac].imi07_d
         #  NEXT FIELD imi05
         #FUN-BB0084 -------End-----------
 
         AFTER FIELD imi05                       #調整數量
            CALL t380_imi05_chk(p_cmd)   #FUN-BB0084 add
         #FUN-BB0084 ----------Begin------------
         #  LET g_imi[l_ac].imi08 = g_imi[l_ac].imi07+g_imi[l_ac].imi05
         #  LET g_imi[l_ac].imi07_d = -g_imi[l_ac].imi05
         #  CALL t380_imgg10_t(p_cmd)            #取得調整后的多單位庫存數量
         #FUN-BB0084 ----------End-------------
         BEFORE DELETE                           #是否取消單身
            IF g_imi_t.imi02 > 0 AND g_imi_t.imi02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               LET g_imgg10_t = g_imgg10_t - (g_imi_t.imi07 + g_imi_t.imi05)*g_imi_t.imi04
               LET g_imgg10_t1 = g_imgg10_t1 + g_imi_t.imi07*g_imi_t.imi04
               DISPLAY g_imgg10_t TO FORMONLY.imgg10_t
               DISPLAY g_imgg10_t1 TO FORMONLY.imgg10_t1
               DELETE FROM imi_file
                   WHERE imi01 = g_imh.imh01 AND imi02 = g_imi_t.imi02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_imi_t.imi02,SQLCA.sqlcode,0)  #No.FUN-660156
                  CALL cl_err3("del","imi_file",g_imh.imh01,g_imi_t.imi02,
                                SQLCA.sqlcode,"","ins imi",1)  #No.FUN-660156
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b = g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_imi[l_ac].* = g_imi_t.*
               CLOSE t380_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_imi[l_ac].imi02,-263,1)
               LET g_imi[l_ac].* = g_imi_t.*
            ELSE
               UPDATE imi_file SET imi02 = g_imi[l_ac].imi02,
                                   imi03 = g_imi[l_ac].imi03,
                                   imi04 = g_imi[l_ac].imi04,
                                   imi07 = g_imi[l_ac].imi07,
                                   imi08 = g_imi[l_ac].imi08,
                                   imi05 = g_imi[l_ac].imi05,
                                   imi06 = g_imi[l_ac].imi06
                             WHERE imi01 = g_imh.imh01
                               AND imi02 = g_imi_t.imi02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('upd imi',SQLCA.sqlcode,0)
                  CALL cl_err3("upd","imi_file",g_imh.imh01,g_imi_t.imi02,SQLCA.sqlcode,"",
                               "upd imi",1)   #NO.FUN-640266   #No.FUN-660156
                  LET g_imi[l_ac].* = g_imi_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
         AFTER ROW
            LET l_ac = ARR_CURR()             # 新增
           #LET l_ac_t = l_ac                 #FUN-D40030 Mark          
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_imi[l_ac].* = g_imi_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_imi.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t380_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac                 #FUN-D40030 Add
            CLOSE t380_bcl
            COMMIT WORK
 
         ON ACTION CONTROLN
            CALL t380_b_askkey()
            EXIT INPUT
 
         ON ACTION CONTROLO                      #沿用所有欄位
            IF INFIELD(imi02) AND l_ac > 1 THEN
               LET g_imi[l_ac].* = g_imi[l_ac-1].*
               LET g_imi[l_ac].imi02 = g_rec_b + 1
               NEXT FIELD imi02
            END IF
 
         ON ACTION controlp
            CASE WHEN INFIELD(imi03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe"
               LET g_qryparam.default1 = g_imi[l_ac].imi03
               CALL cl_create_qry() RETURNING g_imi[l_ac].imi03
                DISPLAY BY NAME g_imi[l_ac].imi03  #No.MOD-490371
               NEXT FIELD imi03
            OTHERWISE EXIT CASE
         END CASE
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------  
 
   END INPUT
   CLOSE t380_bcl
   COMMIT WORK
 
   IF ((g_imgg10_t + g_imgg10_t1) != g_imh.imh09) THEN
      IF cl_confirm('aim-905') THEN
         CALL t380_b()
      END IF
   END IF
   CALL t380_del_b()                      #未有調整，刪除對應單身資料
   CALL t380_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t380_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041

   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_imh.imh01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM imh_file ",
                  "  WHERE imh01 LIKE '",l_slip,"%' ",
                  "    AND imh01 > '",g_imh.imh01,"'"
      PREPARE t380_pb1 FROM l_sql 
      EXECUTE t380_pb1 INTO l_cnt       
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
        #CALL t380_x()    #CHI-D20010
         CALL t380_x(1)   #CHI-D20010
         IF g_imh.imhconf = 'X' THEN 
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_imh.imhconf,"",g_imh.imhpost,"",g_void,"") 
         DISPLAY g_imh.imhconf TO imhconf
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM imh_file WHERE imh01 = g_imh.imh01
         INITIALIZE g_imh.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#FUN-BB0084 ------------------Begin-----------------
FUNCTION t380_imi05_chk(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1 
  IF NOT cl_null(g_imi[l_ac].imi05) AND NOT cl_null(g_imi[l_ac].imi03) THEN
     IF cl_null(g_imi_t.imi05) OR cl_null(g_imi03_t) OR 
         g_imi_t.imi05! = g_imi[l_ac].imi05 OR g_imi03_t! = g_imi[l_ac].imi03 THEN
        LET g_imi[l_ac].imi05 = s_digqty(g_imi[l_ac].imi05,g_imi[l_ac].imi03)
        DISPLAY BY NAME g_imi[l_ac].imi05
     END IF
  END IF
  LET g_imi[l_ac].imi08 = g_imi[l_ac].imi07+g_imi[l_ac].imi05
  LET g_imi[l_ac].imi07_d = -g_imi[l_ac].imi05
  CALL t380_imgg10_t(p_cmd)            #取得調整后的多單位庫存數量
END FUNCTION 

FUNCTION t380_imi08_chk()
   IF cl_null(g_imi[l_ac].imi08) THEN 
      LET g_imi[l_ac].imi08 = 0
   END IF
   IF NOT cl_null(g_imi[l_ac].imi08) AND NOT cl_null(g_imi[l_ac].imi03) THEN
      IF cl_null(g_imi_t.imi08) OR cl_null(g_imi03_t) OR 
         g_imi_t.imi08! = g_imi[l_ac].imi08 OR g_imi03_t! = g_imi[l_ac].imi03 THEN
         LET g_imi[l_ac].imi08 = s_digqty(g_imi[l_ac].imi08,g_imi[l_ac].imi03)
         DISPLAY BY NAME g_imi[l_ac].imi08
      END IF
   END IF 
   LET g_imi[l_ac].imi07_d = g_imi[l_ac].imi07 - g_imi[l_ac].imi08
   LET g_imi[l_ac].imi05 = -g_imi[l_ac].imi07_d
END FUNCTION
#FUN-BB0084 ------------------End-------------------

#FUN.560132 --start--
FUNCTION t380_set_entry_b(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   IF p_cmd = "a" THEN
      CALL cl_set_comp_entry("imi03",TRUE)
   END IF
END FUNCTION
 
FUNCTION t380_set_no_entry_b(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   IF p_cmd <> "a" THEN
      CALL cl_set_comp_entry("imi03",FALSE)
   END IF
END FUNCTION
#FUN.560132 --end--
 
FUNCTION t380_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
   CONSTRUCT l_wc2 ON imi02,imi03,imi04,imi05,imi06
        FROM s_imi[1].imi02,s_imi[1].imi03,s_imi[1].imi04,
             s_imi[1].imi05,s_imi[1].imi06
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   CALL t380_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t380_b_fill(p_wc2)                      #BODY FILL UP
DEFINE p_wc2         LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
   LET g_sql = "SELECT imi02,imi03,imi04,imi07,imi08,imi07-imi08,imi05,imi06 ",
               "  FROM imi_file ",
               " WHERE imi01 = '",g_imh.imh01,"' ",
               "   AND ",p_wc2 CLIPPED,          #單身
               " ORDER BY imi02 "
 
   PREPARE t380_pb FROM g_sql
   DECLARE imi_curs CURSOR FOR t380_pb           #CURSOR
   CALL g_imi.clear()
   LET g_cnt = 1
 
   FOREACH imi_curs INTO g_imi[g_cnt].*          #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_imi.deleteElement(g_cnt)
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_imgg10_t = 0
   LET g_imgg10_t2 = 0
   FOR g_i = 1 TO g_rec_b                                  #產生調整后數量總計
      LET g_imgg10_t = g_imgg10_t + (g_imi[g_i].imi07 + g_imi[g_i].imi05)*g_imi[g_i].imi04
      LET g_imgg10_t2 = g_imgg10_t2 + g_imi[g_i].imi07*g_imi[g_i].imi04
   END FOR
   DISPLAY g_imgg10_t TO FORMONLY.imgg10_t
   LET g_cnt = 0
 
   LET g_imgg10_t1 = g_imh.imh09 - g_imgg10_t2
   DISPLAY g_imgg10_t1 TO FORMONLY.imgg10_t1
END FUNCTION
 
FUNCTION t380_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_imi TO s_imi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()
 
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
         CALL t380_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t380_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t380_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t380_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t380_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
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
         CALL cl_show_fld_cont()
         IF g_imh.imhconf = 'X' THEN #FUN-660080
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_imh.imhconf,"",g_imh.imhpost,"",g_void,"") #FUN-660080
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
    #FUN-660080...............begin
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
    #FUN-660080...............end
 
      # 過帳
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
 
      # 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
 
      # 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
  
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
      
      ON ACTION related_document                #No.FUN-680046  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY   
      
      AFTER DISPLAY
         CONTINUE DISPLAY
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------  
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION t380_out()
   DEFINE l_i        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          sr         RECORD
              imh01  LIKE imh_file.imh01,        #庫存調整單
              imh02  LIKE imh_file.imh02,        #扣帳日期
              imh08  LIKE imh_file.imh08,        #備注
              imh04  LIKE imh_file.imh04,        #料件編號
              ima02  LIKE ima_file.ima02,        #品名
              ima021 LIKE ima_file.ima021,       #規格
              imh05  LIKE imh_file.imh05,        #倉庫
              imh06  LIKE imh_file.imh06,        #儲位
              imh07  LIKE imh_file.imh07,        #批號
              ima906 LIKE ima_file.ima906,       #單位使用方法
              img09  LIKE img_file.img09,        #庫存單位
              imh09  LIKE imh_file.imh09,        #庫存數量
              imi02  LIKE imi_file.imi02,        #項次
              imi03  LIKE imi_file.imi03,        #單位
              imi04  LIKE imi_file.imi04,        #轉換率
              imi07  LIKE imi_file.imi07,        #現有庫存
              imi08  LIKE imi_file.imi08,        #實際庫存
              imi05  LIKE imi_file.imi05,        #調整數量
              imi06  LIKE imi_file.imi06         #備注
                 END RECORD,
          l_name     LIKE type_file.chr20                     #Exteranl(Disk) file name  #No.FUN-690026 VARCHAR(20)
  
   CALL cl_del_data(l_table)     #No.FUN-840019
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimt380'  #No.FUN-840019   
   IF g_imh.imh01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   IF cl_null(g_wc) THEN                         #新增后立即打印
      LET g_wc = " imh01 = '",g_imh.imh01,"' "
   END IF
   IF g_wc2 = " 1=1" OR cl_null(g_wc2) THEN
      LET g_sql = "SELECT imh01,imh02,imh08,imh04,ima02,ima021,imh05,imh06,imh07, ",
                  "       ima906,img09,imh09,imi02,imi03,imi04,imi07,imi08, ",
                  "       imi05,imi06  ",
                  "  FROM imh_file,ima_file,  ",
                  " OUTER img_file,",
                  " OUTER imi_file ",
                  " WHERE imh_file.imh04=ima_file.ima01 ",
                  "   AND imh_file.imh04=img_file.img01 ",
                  "   AND imh_file.imh05=img_file.img02 ",
                  "   AND imh_file.imh06=img_file.img03 ",
                  "   AND imh_file.imh07=img_file.img04 ",
                  "   AND imh_file.imh01=imi_file.imi01 ",
                  "   AND ",g_wc CLIPPED,
                  " ORDER BY imh01 "
   ELSE
      LET g_sql = "SELECT imh01,imh02,imh08,imh04,ima02,ima021,imh05,imh06,imh07, ",
                  "       ima906,img09,imh09,imi02,imi03,imi04,imi07,imi08, ",
                  "       imi05,imi06  ",
                  "  FROM imh_file,ima_file,  ",
                  " OUTER img_file,",
                  " OUTER imi_file ",
                  " WHERE imh_file.imh04=ima_file.ima01 ",
                  "   AND imh_file.imh04=img_file.img01 ",
                  "   AND imh_file.imh05=img_file.img02 ",
                  "   AND imh_file.imh06=img_file.img03 ",
                  "   AND imh_file.imh07=img_file.img04 ",
                  "   AND imh_file.imh01=imi_file.imi01 ",
                  "   AND ",g_wc CLIPPED,
                  "   AND imh01 IN (SELECT UNIQUE imh01 ",
                  "  FROM imh_file,imi_file ",
                  " WHERE imh01 = imi01 ",
                  "   AND ",g_wc2 CLIPPED," ) ",
                  " ORDER BY imh01 "
   END IF
   PREPARE t380_p1 FROM g_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM END IF
   DECLARE t380_curs1
      CURSOR FOR t380_p1
   #CALL cl_outnam('aimt380') RETURNING l_name   #No.FUN-840019
   #START REPORT t380_rep TO l_name               #No.FUN-840019
   FOREACH t380_curs1 INTO sr.*                   #將需打印的數據全部找出
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #No.FUN-840019-----start--
      EXECUTE insert_prep USING
          sr.imh01,sr.imh05,sr.imh02,sr.imh06,sr.imh04,sr.imh07,sr.ima02,
          sr.imh09,sr.img09,sr.ima021,sr.imh08,sr.imi02,sr.imi03,sr.imi04,
          sr.imi07,sr.imi08,sr.imi05,sr.imi06
      #OUTPUT TO REPORT t380_rep(sr.*)             #准備打印
      #No.FUN-840019-----end 
   END FOREACH
   
   #No.FUN-840019----start--
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   
   IF g_zz05 ='Y' THEN 
      CALL cl_wcchp(g_wc,'imh01,imh03,imh02,imh04,imh05,imh06,imh07,imh08,
                    imhconf,imhpost,imhuser,imhgrup,imhmodu,imhdate,imi02,
                    imi03,imi04,imi07,imi08,imi05,imi06')
           RETURNING g_str
   END IF
   CALL cl_prt_cs3('aimt380','aimt380',l_sql,g_str)   
   #FINISH REPORT t380_rep
   #CALL cl_prt(l_name,' ','1',g_len)              #詢問使用者以何種方式打印報表
   #No.FUN-840019----end
   CLOSE t380_curs1
 
END FUNCTION
 
#No.FUN-840019-----start-- 
#REPORT t380_rep(sr)
#   DEFINE l_i        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#          l_last_sw  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#          sr         RECORD
#              imh01  LIKE imh_file.imh01,        #庫存調整單
#              imh02  LIKE imh_file.imh02,        #扣帳日期
#              imh08  LIKE imh_file.imh08,        #備注
#              imh04  LIKE imh_file.imh04,        #料件編號
#              ima02  LIKE ima_file.ima02,        #品名
#              ima021 LIKE ima_file.ima021,       #規格
#              imh05  LIKE imh_file.imh05,        #倉庫
#              imh06  LIKE imh_file.imh06,        #儲位
#              imh07  LIKE imh_file.imh07,        #批號
#              ima906 LIKE ima_file.ima906,       #單位使用方法
#              img09  LIKE img_file.img09,        #庫存單位
#              imh09  LIKE imh_file.imh09,        #庫存數量
#              imi02  LIKE imi_file.imi02,        #項次
#              imi03  LIKE imi_file.imi03,        #單位
#              imi04  LIKE imi_file.imi04,        #轉換率
#              imi07  LIKE imi_file.imi07,        #現有庫存
#              imi08  LIKE imi_file.imi08,        #實際庫存
#              imi05  LIKE imi_file.imi05,        #調整數量
#              imi06  LIKE imi_file.imi06         #備注
#                 END RECORD
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH 66
#   ORDER BY sr.imh01,sr.imi02
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#         PRINT COLUMN g_len-11,'FROM:',g_user CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#         PRINT
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_x[2] CLIPPED,g_today ,' ',TIME,
#               COLUMN g_len-11,g_x[4] CLIPPED,PAGENO USING '<<<',"/pageno"
#         PRINT g_dash[1,g_len]
#         PRINT g_x[5] CLIPPED,sr.imh01 CLIPPED,
#               COLUMN g_len/2+15,g_x[9] CLIPPED,sr.imh05 CLIPPED
#         PRINT g_x[8] CLIPPED,sr.imh02 CLIPPED,
#               COLUMN g_len/2+15,g_x[12]CLIPPED,sr.imh06 CLIPPED
#         PRINT g_x[6] CLIPPED,sr.imh04 CLIPPED,
#               COLUMN g_len/2+15,g_x[14] CLIPPED,sr.imh07 CLIPPED
#         PRINT g_x[7] CLIPPED,sr.ima02 CLIPPED,
#               COLUMN g_len/2+15,g_x[13] CLIPPED,sr.imh09 CLIPPED,'(',sr.img09 CLIPPED,')'
#         PRINT g_x[10] CLIPPED,sr.ima021 CLIPPED,
#               COLUMN g_len/2+15,g_x[11] CLIPPED,sr.imh08 CLIPPED
#         PRINT g_dash2[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],
#               g_x[35],g_x[36],g_x[37]
#         PRINT g_dash1
#         LET l_last_sw = 'n'
# 
##     BEFORE GROUP OF sr.imh01  #TQC-790058
##        SKIP TO TOP OF PAGE    #TQC-790058
#      ON EVERY ROW
#         PRINT COLUMN g_c[31],sr.imi02 USING '###&', #FUN-590118
#               COLUMN g_c[32],sr.imi03 CLIPPED,
#               COLUMN g_c[33],sr.imi04 USING '------&.&&&&&&&&',
#               COLUMN g_c[34],sr.imi07 USING '----------&.&&&',
#               COLUMN g_c[35],sr.imi08 USING '----------&.&&&',
#               COLUMN g_c[36],sr.imi05 USING '----------&.&&&',
#               COLUMN g_c[37],sr.imi06 CLIPPED
# 
#      ON LAST ROW
#         LET l_last_sw = 'y'
#         PRINT g_dash[1,g_len]
#         PRINT COLUMN 1,g_x[15] CLIPPED,
#               COLUMN (g_len-9),g_x[16] CLIPPED
#         PRINT g_x[18] CLIPPED,
#               COLUMN ((g_len-FGL_WIDTH(g_x[19]))/2-2),g_x[19] CLIPPED,
#               COLUMN (g_len-13),g_x[20] CLIPPED
# 
#      PAGE TRAILER
#         IF l_last_sw = 'n' THEN
#            PRINT g_dash[1,g_len]
#            PRINT g_x[15] CLIPPED,
#                  COLUMN (g_len-9),g_x[17] CLIPPED
#            PRINT g_x[18] CLIPPED,
#                  COLUMN ((g_len-FGL_WIDTH(g_x[19]))/2-2),g_x[19] CLIPPED,
#                  COLUMN (g_len-13),g_x[20] CLIPPED
#         ELSE
#            SKIP 3 LINE
#         END IF
# 
#END REPORT
#No.FUN-840019----end
 
FUNCTION t380_s()
DEFINE l_cnt      LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_flag     LIKE type_file.chr1    #FUN-C80107 add
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   SELECT * INTO g_imh.* FROM imh_file WHERE imh01=g_imh.imh01
   IF g_imh.imh01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_imh.imhconf = 'N' THEN CALL cl_err('','aba-100',0) RETURN END IF #FUN-660080
   IF g_imh.imhpost = 'Y' THEN CALL cl_err('','asf-812',0) RETURN END IF
   IF g_imh.imhconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF #FUN-660080
   IF ((g_imgg10_t + g_imgg10_t1) != g_imh.imh09) THEN
      CALL cl_err('','aim-907',1)
      RETURN
   END IF

   IF g_sma.sma53 IS NOT NULL AND g_imh.imh02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0) RETURN
   END IF
   CALL s_yp(g_imh.imh02) RETURNING g_yy,g_mm
   IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52) THEN #不可大於現行年月
       CALL cl_err('','mfg6091',0)
       RETURN
   END IF
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM imi_file
    WHERE imi01=g_imh.imh01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('mfg0176') THEN RETURN END IF
 
   DECLARE t380_s1_c CURSOR FOR
     SELECT * FROM imi_file WHERE imi01=g_imh.imh01
   BEGIN WORK
 
   OPEN t380_cl USING g_imh.imh01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_imh.imh01,SQLCA.sqlcode,0)   # 資料被他人LOCK
      CLOSE t380_cl
      ROLLBACK WORK
      RETURN
   ELSE
      FETCH t380_cl INTO g_imh.*                 # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_imh.imh01,SQLCA.sqlcode,0)     # 資料被他人LOCK
         CLOSE t380_cl
         ROLLBACK WORK
         RETURN
      END IF
   END IF
 
   LET g_success = 'Y'
   CALL s_showmsg_init()    #No.FUN-710025
   FOREACH t380_s1_c INTO b_imi.*
      IF STATUS THEN
         LET g_success ='N'     #FUN-8A0086
         EXIT FOREACH END IF
      #No.FUN-710025--Begin--                                                                                                      
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
      #No.FUN-710025--End-
 
      IF (b_imi.imi05 <> 0) THEN
         IF (b_imi.imi07+b_imi.imi05)*b_imi.imi04 > g_imh.imh09 THEN
            #IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN  #FUN-C80107 mark
             LET l_flag = NULL    #FUN-C80107 add
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imh.imh05) RETURNING l_flag   #FUN-C80107 add  #FUN-D30024--mark
             CALL s_inv_shrt_by_warehouse(g_imh.imh05,g_plant) RETURNING l_flag                   #FUN-D30024--add  #TQC-D40078 g_plant
             IF l_flag = 'N' OR l_flag IS NULL THEN           #FUN-C80107 add
             #No.FUN-710025--Begin--
             #  CALL cl_err(g_imi[l_ac].imi05,'mfg3471',0)
                CALL s_errmsg('','',g_imi[l_ac].imi05,'mfg3471',1)
                LET g_success='N'
             #  RETURN
                CONTINUE FOREACH
             #No.FUN-710025--End--
             END IF
         END IF
         IF NOT s_stkminus(g_imh.imh04,g_imh.imh05,g_imh.imh06,g_imh.imh07,
                          #b_imi.imi07+b_imi.imi05,b_imi.imi04,g_imh.imh02,g_sma.sma894[4,4]) THEN  #FUN-D30024--mark
                           b_imi.imi07+b_imi.imi05,b_imi.imi04,g_imh.imh02) THEN                     #FUN-D30024--add
            LET g_success='N'
         #  RETURN           #No.FUN-710025
            CONTINUE FOREACH #No.FUN-710025
         END IF
         CALL t380_s1(b_imi.*,'1')                     #更新庫存資料，產生異動記錄
         #FUN-560183................begin
        #SELECT ima86 INTO g_ima86 FROM ima_file WHERE ima01 = g_imh.imh04
        #IF SQLCA.sqlcode THEN
        #   CALL cl_err(g_ima86,SQLCA.sqlcode,0)       # 資料被他人LOCK
        #END IF
         #FUN-560183................end
         INITIALIZE g_tlff.* TO NULL
         LET g_tlff.tlff01  = g_imh.imh04              #異動料件編號
         IF b_imi.imi05 > 0 THEN
            LET g_tlff.tlff02  = 0                     #來源狀況
            LET g_tlff.tlff03  = 50                    #目的狀況
            LET g_tlff.tlff907 = 1                     #出入庫
            LET g_tlff.tlff10  = b_imi.imi05           #異動數量
            LET g_tlff.tlff030 = g_plant               #工廠別
            LET g_tlff.tlff031 = g_imh.imh05           #倉庫
            LET g_tlff.tlff032 = g_imh.imh06           #儲位
            LET g_tlff.tlff033 = g_imh.imh07           #批號
            LET g_tlff.tlff034 = b_imi.imi07+b_imi.imi05  #異動後數量
            LET g_tlff.tlff035 = b_imi.imi03           #庫存單位
            LET g_tlff.tlff036 = g_imh.imh01           #發票編號
            LET g_tlff.tlff037 = b_imi.imi02           #雜收項次
            LET g_tlff.tlff026 = ' '                   #發票編號
            LET g_tlff.tlff027 = ' '                   #雜收項次
            #No.FUN-570036  --begin
            LET g_tlff.tlff13  = 'aimt3801'            #異動命令代號
            #No.FUN-570036  --end
         ELSE
            LET g_tlff.tlff02  = 50                    #來源狀況
            LET g_tlff.tlff03  = 0                     #目的狀況
            LET g_tlff.tlff907 = -1
            LET g_tlff.tlff10  = -1*b_imi.imi05        #異動數量
            LET g_tlff.tlff020 = g_plant               #工廠別
            LET g_tlff.tlff021 = g_imh.imh05           #倉庫
            LET g_tlff.tlff022 = g_imh.imh06           #儲位
            LET g_tlff.tlff023 = g_imh.imh07           #批號
            LET g_tlff.tlff024 = b_imi.imi07+b_imi.imi05  #異動後數量
            LET g_tlff.tlff025 = b_imi.imi03           #庫存單位
            LET g_tlff.tlff026 = g_imh.imh01           #發票編號
            LET g_tlff.tlff027 = b_imi.imi02           #雜收項次
            LET g_tlff.tlff036 = ' '                   #發票編號
            LET g_tlff.tlff037 = ' '                   #雜收項次
            #No.FUN-570036  --begin
            LET g_tlff.tlff13  = 'aimt3802'            #異動命令代號
            #No.FUN-570036  --end
         END IF
         LET g_tlff.tlff906 = b_imi.imi02              #項次
         LET g_tlff.tlff04  = ' '                      #工作站
         LET g_tlff.tlff05  = ' '                      #作業序號
         LET g_tlff.tlff06  = g_imh.imh02              #發料日期
         LET g_tlff.tlff07  = g_today                  #異動資料產生日期
         LET g_tlff.tlff08  = TIME                     #異動資料產生時:分:秒
         LET g_tlff.tlff09  = g_user                   #產生人
         LET g_tlff.tlff11  = b_imi.imi03              #發料單位
         LET g_tlff.tlff12  = b_imi.imi04              #發料/庫存 換算率
         LET g_tlff.tlff14  = NULL                     #異動原因
         LET g_tlff.tlff17  = b_imi.imi06              #Remark
        #LET g_tlff.tlff61  = g_ima86                  #成本單位 #FUN-560183
         CALL s_tlff('2','')
      ELSE
         CONTINUE FOREACH
      END IF
 
   END FOREACH
 
   #No.FUN-710025--Begin--                                                                                                             
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
   #No.FUN-710025--End--
 
 
   UPDATE imh_file SET imhpost = 'Y'
                 WHERE imh01 = g_imh.imh01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#        CALL cl_err('up imh_file',SQLCA.sqlcode,0)
         CALL cl_err3("upd","imh_file",g_imh.imh01,"",SQLCA.sqlcode,"",
                      "up imh_file",1)   #NO.FUN-640266   #No.FUN-660156
         LET g_success = 'N'
      END IF
      CALL s_showmsg()   #No.FUN-710025
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_imh.imh01,'S')
      CALL cl_cmmsg(4)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(4)
   END IF
   SELECT imhpost INTO g_imh.imhpost
     FROM imh_file WHERE imh01 = g_imh.imh01
   DISPLAY BY NAME g_imh.imhpost 
END FUNCTION
 
FUNCTION t380_t()
   DEFINE l_cnt         LIKE type_file.num10   #No.FUN-690026 INTEGER
   DEFINE l_imh01       LIKE imh_file.imh01
 
   IF s_shut(0) THEN
      RETURN
   END IF
   SELECT * INTO g_imh.* FROM imh_file WHERE imh01 = g_imh.imh01
   IF g_imh.imh01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT imh01 INTO l_imh01 FROM imh_file
    WHERE imh02 > g_imh.imh02
      AND imh04 = g_imh.imh04
      AND imh05 = g_imh.imh05
      AND imh06 = g_imh.imh06
      AND imh07 = g_imh.imh07
      AND imhpost = 'Y'
   IF NOT cl_null(l_imh01) THEN
      CALL cl_err(l_imh01,'aim-902',0)
      RETURN
    END IF
   #CHI-C70017---begin
   IF g_sma.sma53 IS NOT NULL AND g_imh.imh02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0) RETURN
   END IF
   CALL s_yp(g_imh.imh02) RETURNING g_yy,g_mm
   IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52) THEN #不可大於現行年月
       CALL cl_err('','mfg6091',0)
       RETURN
   END IF
   #CHI-C70017---end
   IF g_imh.imhpost = 'N' THEN CALL cl_err('','aim-307',0) RETURN END IF
   IF g_imh.imhconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF #FUN-660080
   IF NOT cl_confirm('asf-663') THEN RETURN END IF
   DECLARE t380_s2_c CURSOR FOR
     SELECT * FROM imi_file WHERE imi01=g_imh.imh01
   BEGIN WORK
   OPEN t380_cl USING g_imh.imh01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_imh.imh01,SQLCA.sqlcode,0)   # 資料被他人LOCK
      CLOSE t380_cl
      ROLLBACK WORK
      RETURN
   ELSE
      FETCH t380_cl INTO g_imh.*                 # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_imh.imh01,SQLCA.sqlcode,0)     # 資料被他人LOCK
         CLOSE t380_cl
         ROLLBACK WORK
         RETURN
      END IF
   END IF
   LET g_success = 'Y'
   CALL s_showmsg_init()    #No.FUN-710025
   FOREACH t380_s2_c INTO b_imi.*
      IF STATUS THEN EXIT FOREACH END IF
      #No.FUN-710025--Begin--                                                                                                      
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
      #No.FUN-710025--End-
 
      MESSAGE 's_ read parts:',b_imi.imi03
      IF (b_imi.imi05 <> 0) THEN
         CALL t380_s1(b_imi.*,'0')                     #更新庫存資料，產生異動記錄
         INITIALIZE g_tlff.* TO NULL
         IF b_imi.imi05 > 0 THEN
            DELETE FROM tlff_file
             WHERE tlff01  = g_imh.imh04              #異動料件編號
               AND tlff02  = 0                        #來源狀況
               AND tlff03  = 50                       #目的狀況
               AND tlff906 = b_imi.imi02              #項次
               AND tlff036 = g_imh.imh01              #單據編號      #MOD-B80003 add
         ELSE
            DELETE FROM tlff_file
             WHERE tlff01  = g_imh.imh04              #異動料件編號
               AND tlff02  = 50                       #來源狀況
               AND tlff03  = 0                        #目的狀況
               AND tlff906 = b_imi.imi02              #項次
               AND tlff036 = g_imh.imh01              #單據編號      #MOD-B80003 add
         END IF
         IF SQLCA.sqlcode THEN
#           CALL cl_err('delete tlff_file fault',SQLCA.sqlcode,0)    # 資料被他人LOCK
         #No.FUN-710025--Begin--
         #  CALL cl_err3("del","tlff_file",g_imh.imh04,"",SQLCA.sqlcode,"",
         #               "delete tlff_file fault",1)   #NO.FUN-640266  #No.FUN-660156
            LET g_showmsg = g_imh.imh04,"/",50,"/",0,"/",b_imi.imi02
            CALL s_errmsg('tlff01,tlff02,tlff03,tlff906',g_showmsg,'delete tlff_file fault',SQLCA.sqlcode,0)
         #No.FUN-710025--End--
         LET g_success = 'N' #No.TQC-930155
         END IF
      ELSE
         CONTINUE FOREACH
      END IF
   END FOREACH
 
   #No.FUN-710025--Begin--                                                                                                             
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
   #No.FUN-710025--End--
 
   UPDATE imh_file SET imhpost = 'N'
                 WHERE imh01 = g_imh.imh01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#        CALL cl_err('up imh_file',SQLCA.sqlcode,0)
      #No.FUN-710025--Begin--
      #  CALL cl_err3("upd","imh_file",g_imh.imh01,"",SQLCA.sqlcode,"",
      #               "up imh_file",1)   #NO.FUN-640266  #No.FUN-660156
         CALL s_errmsg('imh01',g_imh.imh01,'up imh_file',SQLCA.sqlcode,1)
      #No.FUN-710025--End--
         LET g_success = 'N'
      END IF
      CALL s_showmsg()           #No.FUN-710025
   IF g_success = 'Y' THEN 
      COMMIT WORK
      CALL cl_flow_notify(g_imh.imh01,'T')
      CALL cl_cmmsg(4)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(4)
   END IF
   SELECT imhpost INTO g_imh.imhpost
     FROM imh_file WHERE imh01 = g_imh.imh01
   DISPLAY BY NAME g_imh.imhpost 
END FUNCTION
 
#FUNCTION t380_x()       #CHI-D20010
FUNCTION t380_x(p_type)  #CHI-D20010
DEFINE l_flag LIKE type_file.chr1  #CHI-D20010
DEFINE p_type LIKE type_file.chr1  #CHI-D20010
   IF s_shut(0) THEN
      RETURN
   END IF
 
   SELECT * INTO g_imh.* FROM imh_file WHERE imh01 = g_imh.imh01
   IF g_imh.imh01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_imh.imhconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660080
   IF g_imh.imhpost = 'Y' THEN CALL cl_err('','asf-812',0) RETURN END IF
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_imh.imhconf ='X' THEN RETURN END IF
   ELSE
      IF g_imh.imhconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
   BEGIN WORK
 
   OPEN t380_cl USING g_imh.imh01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_imh.imh01,SQLCA.sqlcode,0)
      CLOSE t380_cl
      ROLLBACK WORK
      RETURN
   ELSE
      FETCH t380_cl INTO g_imh.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_imh.imh01,SQLCA.sqlcode,0)
         CLOSE t380_cl
         ROLLBACK WORK
         RETURN
      END IF
   END IF
   IF g_imh.imhconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_imh.imhconf) THEN #FUN-660080  #CHI-D20010
   IF cl_void(0,0,l_flag) THEN #FUN-660080         #CHI-D20010
      #FUN-660080...............begin
      LET g_chr=g_imh.imhconf 
     #IF g_imh.imhconf = 'N' THEN    #CHI-D20010
      IF p_type = 1 THEN           #CHI-D20010
         LET g_imh.imhconf = 'X'
      ELSE
         LET g_imh.imhconf = 'N'
      END IF
      UPDATE imh_file
         SET imhconf = g_imh.imhconf, #FUN-660080
             imhmodu = g_user,
             imhdate = g_today
       WHERE imh01 = g_imh.imh01
      #FUN-660080...............end
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('up imhpost:',SQLCA.sqlcode,0)
         CALL cl_err3("upd","imh_file",g_imh.imh01,"",SQLCA.sqlcode,"",
                      "up imhpost",1)   #NO.FUN-640266  #No.FUN-660156
         LET g_imh.imhconf = g_chr #FUN-660080
      END IF
   END IF
   CLOSE t380_cl
   COMMIT WORK
   CALL cl_flow_notify(g_imh.imh01,'V')
END FUNCTION
 
FUNCTION t380_imgg10_t(l_cmd)             #取得調整后的多單位庫存數量
   DEFINE l_cmd         LIKE type_file.chr1             #a:輸入 u:更改  #No.FUN-690026 VARCHAR(1)
   IF (g_imi[l_ac].imi05 != g_imi_t.imi05) OR cl_null(g_imi_t.imi07) THEN
      IF (l_cmd = 'a' AND (g_imi_t.imi07 != g_imi[l_ac].imi07
                        OR cl_null(g_imi_t.imi07))) THEN
         LET g_imgg10_t1 = g_imgg10_t1 -
                          g_imi[l_ac].imi07*g_imi[l_ac].imi04
         LET g_imgg10_t = g_imgg10_t + g_imi[l_ac].imi07*g_imi[l_ac].imi04
      END IF
      IF l_cmd = 'a' THEN
         LET g_imgg10_t = g_imgg10_t +
                         (g_imi[l_ac].imi05 - g_imi_t.imi05)*g_imi[l_ac].imi04
      END IF
      IF l_cmd = 'u' THEN
         LET g_imgg10_t = g_imgg10_t -
                         (g_imi[l_ac].imi07 + g_imi_t.imi05)*g_imi[l_ac].imi04
      END IF
      IF cl_null(g_imi[l_ac].imi05) THEN LET g_imi[l_ac].imi05 = 0 END IF
      IF cl_null(g_imgg10_t) THEN LET g_imgg10_t = 0 END IF
      IF (g_imi[l_ac].imi05 != g_imi_t.imi05) AND l_cmd = 'u' THEN
         LET g_imgg10_t = g_imgg10_t + (g_imi[l_ac].imi07 + g_imi[l_ac].imi05)*g_imi[l_ac].imi04
      END IF
      LET g_imgg10_t = s_digqty(g_imgg10_t,g_imi[l_ac].imi03)   #FUN-BB0084
      LET g_imgg10_t1 = s_digqty(g_imgg10_t1,g_imi[l_ac].imi03) #FUN-BB0084
      DISPLAY g_imgg10_t TO FORMONLY.imgg10_t
      DISPLAY g_imgg10_t1 TO FORMONLY.imgg10_t1
      LET g_imi_t.imi02 = g_imi[l_ac].imi02
      LET g_imi_t.imi05 = g_imi[l_ac].imi05
      LET g_imi_t.* = g_imi[l_ac].*
   END IF
END FUNCTION
 
FUNCTION t380_del_b()                           #未有調整，刪除對應單身資料
DEFINE l_imi05 RECORD
               imi02 LIKE imi_file.imi02,
               imi05 LIKE imi_file.imi05
               END RECORD,
       l_min_imi02   LIKE imi_file.imi02,       #時時最小項次
       l1_min_imi02  LIKE imi_file.imi02        #最小項次
 
   LET l_min_imi02 = 1
   SELECT MIN(imi02) INTO l1_min_imi02 FROM imi_file
    WHERE imi01 = g_imh.imh01
   DECLARE t380_b3_b CURSOR FOR
      SELECT imi02,imi05 FROM imi_file
       WHERE imi01 = g_imh.imh01
        ORDER BY imi02
   FOREACH t380_b3_b INTO l_imi05.imi02,l_imi05.imi05
      IF STATUS THEN EXIT FOREACH END IF
      LET l1_min_imi02 = l_imi05.imi02
      IF l_imi05.imi05 <> 0 THEN
         IF l_min_imi02 <> l1_min_imi02 THEN
            UPDATE imi_file SET imi02 = l_min_imi02
             WHERE imi01 = g_imh.imh01
               AND imi02 = l_imi05.imi02
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#              CALL cl_err('upd imi01: ',SQLCA.SQLCODE,1)
               CALL cl_err3("upd","imi_file",g_imh.imh01,l_imi05.imi02,SQLCA.sqlcode,"",
                            "upd imi01",1)   #NO.FUN-640266 #No.FUN-660156
            END IF
         END IF
         LET l_min_imi02 = l_min_imi02 + 1
         CONTINUE FOREACH
      ELSE
         DELETE FROM imi_file WHERE imi01 = g_imh.imh01
                                AND imi02 = l_imi05.imi02
            IF SQLCA.SQLCODE THEN
#              CALL cl_err('del imi01: ',SQLCA.SQLCODE,1)
               CALL cl_err3("del","imi_file",g_imh.imh01,"",SQLCA.sqlcode,"",
                            "del imi01",1)   #NO.FUN-640266  #No.FUN-660156
            END IF
      END IF
   END FOREACH
   CALL t380_b_fill('1=1')
 
END FUNCTION
 
FUNCTION t380_s1(p_imi,l_postflag)            #更新庫存資料，產生異動記錄
DEFINE p_imi          RECORD LIKE imi_file.*, #庫存調撥調整單身檔
       l_postflag     LIKE type_file.chr1     #過帳標志位  #No.FUN-690026 VARCHAR(1)
 
   IF l_postflag = '1' OR l_postflag = '0' THEN
      MESSAGE "update imgg_file ..."
      LET g_forupd_sql = "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file  ",
                         " WHERE imgg01 = ? AND imgg02 = ? AND imgg03= ? ",
                         "   AND imgg04=  ? AND imgg09 = ? FOR UPDATE "
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE imgg_lock CURSOR FROM g_forupd_sql
 
      OPEN imgg_lock USING g_imh.imh04,g_imh.imh05,g_imh.imh06,
                           g_imh.imh07,p_imi.imi03
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','','open imgg_lock',SQLCA.sqlcode,1) #No.TQC-930155
            LET g_success = 'N'
            RETURN 1
         ELSE
            FETCH imgg_lock INTO g_imh.imh04,g_imh.imh05,g_imh.imh06,g_imh.imh07,p_imi.imi03
#No.TQC-930155-start-
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('','','fetch imgg_lock',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN 1
            END IF
#No.TQC-930155--end--
            IF l_postflag = '1' THEN
               UPDATE imgg_file SET imgg10 = imgg10 + p_imi.imi05
                WHERE imgg01 = g_imh.imh04 AND imgg02 = g_imh.imh05 AND imgg03 = g_imh.imh06 AND imgg04 = g_imh.imh07 AND imgg09 = p_imi.imi03
            ELSE
               UPDATE imgg_file SET imgg10 = imgg10 - p_imi.imi05
                WHERE imgg01 = g_imh.imh04 AND imgg02 = g_imh.imh05 AND imgg03 = g_imh.imh06 AND imgg04 = g_imh.imh07 AND imgg09 = p_imi.imi03
            END IF
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               RETURN 1
            END IF
         END IF
      CLOSE imgg_lock
   ELSE
      LET g_success = 'N'
      RETURN 1
   END IF
END FUNCTION
 
FUNCTION t380_imh03(p_date)                   #依單據日期推出計算日期
   DEFINE p_date      LIKE type_file.dat      #輸入日期  #No.FUN-690026 DATE
   LET g_yy = YEAR(p_date)
   LET g_mm = MONTH(p_date)
   IF g_mm = 1 THEN
      LET g_yy1 = g_yy - 1
      LET g_mm1 = 12
   ELSE
      LET g_yy1 = g_yy
      LET g_mm1 = g_mm - 1
   END IF
   CALL s_azm(g_yy1,g_mm1) RETURNING g_chr,g_date1,g_date2
END FUNCTION
 
#FUN-660080
FUNCTION t380_y_chk()
DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
   LET g_success = 'Y'
#CHI-C30107 ---------------- add --------------------- begin
   IF cl_null(g_imh.imh01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_imh.imhconf='Y' THEN
      LET g_success = 'N'
      CALL cl_err('','9023',0)
      RETURN
   END IF

   IF g_imh.imhconf = 'X' THEN
      LET g_success = 'N'
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
   IF NOT s_chk_ware(g_imh.imh05) THEN
      LET g_success='N'
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF
#CHI-C30107 ---------------- add --------------------- end
   IF cl_null(g_imh.imh01) THEN 
      CALL cl_err('',-400,0) 
      LET g_success = 'N'
      RETURN 
   END IF
   SELECT * INTO g_imh.* FROM imh_file WHERE imh01 = g_imh.imh01
   IF g_imh.imhconf='Y' THEN
      LET g_success = 'N'           
      CALL cl_err('','9023',0)      
      RETURN
   END IF
 
   IF g_imh.imhconf = 'X' THEN
      LET g_success = 'N'   
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
#No.FUN-AB0067--begin  
   IF NOT s_chk_ware(g_imh.imh05) THEN
      LET g_success='N'
      RETURN 
   END IF   
#No.FUN-AB0067--end
   SELECT COUNT(*) INTO l_cnt FROM imh_file
      WHERE imh01= g_imh.imh01
   IF l_cnt = 0 THEN
      LET g_success = 'N'
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION
 
#FUN-660080
FUNCTION t380_y_upd()
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN t380_cl USING g_imh.imh01
   IF STATUS THEN
      CALL cl_err("OPEN t380_cl:", STATUS, 1)
      CLOSE t380_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t380_cl INTO g_imh.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_imh.imh01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t380_cl 
       ROLLBACK WORK 
       RETURN
   END IF
   CLOSE t380_cl
   UPDATE imh_file SET imhconf = 'Y' WHERE imh01 = g_imh.imh01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd imhconf',STATUS,0)  #No.FUN-660156
      CALL cl_err3("upd","imh_file",g_imh.imh01,"",SQLCA.sqlcode,"",
                   "upd imhconf",1)  #No.FUN-660156
      LET g_success = 'N'
   END IF
 
   IF g_success='Y' THEN
      COMMIT WORK
      LET g_imh.imhconf='Y'
      CALL cl_flow_notify(g_imh.imh01,'Y')
   ELSE
      ROLLBACK WORK
      LET g_imh.imhconf='N'
   END IF
   DISPLAY BY NAME g_imh.imhconf
   IF g_imh.imhconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_imh.imhconf,"",g_imh.imhpost,"",g_chr,"")
END FUNCTION
 
#FUN-660080
FUNCTION t380_z()
   IF cl_null(g_imh.imh01) THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_imh.* FROM imh_file WHERE imh01 = g_imh.imh01
   IF g_imh.imhconf='N' THEN RETURN END IF
   IF g_imh.imhconf='X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_imh.imhpost='Y' THEN
      CALL cl_err('imh03=Y:','afa-101',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
   OPEN t380_cl USING g_imh.imh01
   IF STATUS THEN
      CALL cl_err("OPEN t380_cl:", STATUS, 1)
      CLOSE t380_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t380_cl INTO g_imh.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_imh.imh01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t380_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   CLOSE t380_cl
   LET g_success = 'Y'
   UPDATE imh_file SET imhconf = 'N' WHERE imh01 = g_imh.imh01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
      LET g_success = 'N' 
   END IF
   IF g_success = 'Y' THEN
      LET g_imh.imhconf='N'
      COMMIT WORK
      DISPLAY BY NAME g_imh.imhconf
   ELSE
      LET g_imh.imhconf='Y'
      ROLLBACK WORK
   END IF
   IF g_imh.imhconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_imh.imhconf,"",g_imh.imhpost,"",g_chr,"")
END FUNCTION
