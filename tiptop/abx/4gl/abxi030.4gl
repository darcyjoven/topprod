# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abxi030.4gl
# Descriptions...: 保稅產品結構資料維護作業
# Date & Author..: 95/08/21 By Star
# Modified.......: 04/23/97 By Elaine 若生效日為01/01/99,且有效否為'N'
#                  或 有失效日, 且有效否為'N', 則允許輸入option項次
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: No.FUN-570109 05/07/13 By day   修正建檔程式key值是否可更改
# Modify.........: No.FUN-570158 05/08/09 By Sarah 在複製裡增加set_entry段
# Modify.........: No.FUN-5B0023 05/12/09 By Nicola 增加實用數、損耗數欄位，組成用量改為應用數
# Modify.........: No.TQC-5C0040 05/12/09 By Nicola 修改狀態，判斷key值是否重覆修改
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660052 05/06/13 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換 
# Modify.........: No.FUN-6A0046 06/10/18 By jamie 1.FUNCTION i030()_q 一開始應清空g_bnd.*的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time		 
# Modify.........: No.FUN-6A0007 06/10/30 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6B0033 06/11/10 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-730122 07/04/02 By Ray 單身實用數欄位錄入數字，錄入后，換到下一欄位，此時實用數欄位值被還原，須再次錄入
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/09 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990126 09/10/12 By lilingyu 控管非保稅料件不可維護資料
# Modify.........: No:MOD-9C0154 09/12/16 By Smapmin 筆數計算錯誤
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/26 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:MOD-BA0145 11/10/22 By johung 還原TQC-990126
# Modify.........: No:MOD-BB0037 11/11/12 By johung 調整新增主件BOM時，若主件BOM資料存在，進單身程式會直接關閉問題
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:MOD-BC0146 12/06/15 By ck2yuan BOM編號無法自動編號 
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-B10023 13/04/16 By jt_chen 需考慮abmi600發料單位與庫存單位不同時要做單位轉換
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_bnd                RECORD LIKE bnd_file.*,
       g_bnd_o              RECORD LIKE bnd_file.*,
       g_bnd_t              RECORD LIKE bnd_file.*,
       g_bnd01              LIKE bnd_file.bnd01,   #主件料號
       g_bnd01_o            LIKE bnd_file.bnd01,   #
       g_bnd01_t            LIKE bnd_file.bnd01,   #
       g_bnd02              LIKE bnd_file.bnd02,   #生效日期
       g_bnd02_o            LIKE bnd_file.bnd02,   #
       g_bnd02_t            LIKE bnd_file.bnd02,   #
       g_bne                DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                               bne03   LIKE bne_file.bne03,   #項次
                               bne05   LIKE bne_file.bne05,
                               ima02   LIKE ima_file.ima02,
                               ima021  LIKE ima_file.ima021,#FUN-6A0007
                               bne06   LIKE bne_file.bne06,
                               bne07   LIKE bne_file.bne07,
                               bne10   LIKE bne_file.bne10,   #No.FUN-5B0023
                               bne11   LIKE bne_file.bne11,   #No.FUN-5B0023
                               bne08   LIKE bne_file.bne08,
                               ima1916b LIKE ima_file.ima1916,  #show元件之保稅代碼 #FUN-6A0007
                               bxe02 LIKE bxe_file.bxe02, #FUN-6A0007
                               bxe03 LIKE bxe_file.bxe03, #FUN-6A0007
                               bne09   LIKE bne_file.bne09
                               #FUN-840202 --start---
                              ,bneud01 LIKE bne_file.bneud01,
                               bneud02 LIKE bne_file.bneud02,
                               bneud03 LIKE bne_file.bneud03,
                               bneud04 LIKE bne_file.bneud04,
                               bneud05 LIKE bne_file.bneud05,
                               bneud06 LIKE bne_file.bneud06,
                               bneud07 LIKE bne_file.bneud07,
                               bneud08 LIKE bne_file.bneud08,
                               bneud09 LIKE bne_file.bneud09,
                               bneud10 LIKE bne_file.bneud10,
                               bneud11 LIKE bne_file.bneud11,
                               bneud12 LIKE bne_file.bneud12,
                               bneud13 LIKE bne_file.bneud13,
                               bneud14 LIKE bne_file.bneud14,
                               bneud15 LIKE bne_file.bneud15
                               #FUN-840202 --end--
                            END RECORD,
       g_bne_t              RECORD                 #程式變數 (舊值)
                               bne03   LIKE bne_file.bne03,   #項次
                               bne05   LIKE bne_file.bne05,
                               ima02   LIKE ima_file.ima02,
                               ima021  LIKE ima_file.ima021, #FUN-6A0007
                               bne06   LIKE bne_file.bne06,
                               bne07   LIKE bne_file.bne07,
                               bne10   LIKE bne_file.bne10,   #No.FUN-5B0023
                               bne11   LIKE bne_file.bne11,   #No.FUN-5B0023
                               bne08   LIKE bne_file.bne08,
                               ima1916b LIKE ima_file.ima1916,  #FUN-6A0007
                               bxe02 LIKE bxe_file.bxe02, #FUN-6A0007
                               bxe03 LIKE bxe_file.bxe03, #FUN-6A0007
                               bne09   LIKE bne_file.bne09
                             #FUN-840202 --start---
                              ,bneud01 LIKE bne_file.bneud01,
                               bneud02 LIKE bne_file.bneud02,
                               bneud03 LIKE bne_file.bneud03,
                               bneud04 LIKE bne_file.bneud04,
                               bneud05 LIKE bne_file.bneud05,
                               bneud06 LIKE bne_file.bneud06,
                               bneud07 LIKE bne_file.bneud07,
                               bneud08 LIKE bne_file.bneud08,
                               bneud09 LIKE bne_file.bneud09,
                               bneud10 LIKE bne_file.bneud10,
                               bneud11 LIKE bne_file.bneud11,
                               bneud12 LIKE bne_file.bneud12,
                               bneud13 LIKE bne_file.bneud13,
                               bneud14 LIKE bne_file.bneud14,
                               bneud15 LIKE bne_file.bneud15
                             #FUN-840202 --end--
                            END RECORD,
       #FUN-6A0007...............begin
       g_bne_o              RECORD                 #程式變數 (舊值)
                               bne03   LIKE bne_file.bne03,   #項次
                               bne05   LIKE bne_file.bne05,
                               ima02   LIKE ima_file.ima02,
                               ima021  LIKE ima_file.ima021, #FUN-6A0007
                               bne06   LIKE bne_file.bne06,
                               bne07   LIKE bne_file.bne07,
                               bne10   LIKE bne_file.bne10,   #No.FUN-5B0023
                               bne11   LIKE bne_file.bne11,   #No.FUN-5B0023
                               bne08   LIKE bne_file.bne08,
                               ima1916b LIKE ima_file.ima1916,  #FUN-6A0007
                               bxe02 LIKE bxe_file.bxe02, #FUN-6A0007
                               bxe03 LIKE bxe_file.bxe03, #FUN-6A0007
                               bne09   LIKE bne_file.bne09
                             #FUN-840202 --start---
                              ,bneud01 LIKE bne_file.bneud01,
                               bneud02 LIKE bne_file.bneud02,
                               bneud03 LIKE bne_file.bneud03,
                               bneud04 LIKE bne_file.bneud04,
                               bneud05 LIKE bne_file.bneud05,
                               bneud06 LIKE bne_file.bneud06,
                               bneud07 LIKE bne_file.bneud07,
                               bneud08 LIKE bne_file.bneud08,
                               bneud09 LIKE bne_file.bneud09,
                               bneud10 LIKE bne_file.bneud10,
                               bneud11 LIKE bne_file.bneud11,
                               bneud12 LIKE bne_file.bneud12,
                               bneud13 LIKE bne_file.bneud13,
                               bneud14 LIKE bne_file.bneud14,
                               bneud15 LIKE bne_file.bneud15
                             #FUN-840202 --end--
                            END RECORD,
       #FUN-6A0007...............end
       g_wc,g_wc2,g_sql     STRING,  #No.FUN-580092 HCN    
       g_bna06              LIKE bna_file.bna06,
#      g_rec_b              SMALLINT,            #單身筆數 #NO.FUN-680062  
       g_rec_b     LIKE type_file.num5,          #NO.FUN-680062   
#      l_ac                 SMALLINT,            #目前處理的ARRAY CNT
       l_ac        LIKE type_file.num5           #NO.FUN-680062   
#      l_time               VARCHAR(08)             #NO.FUN-680062   
#      l_time       LIKE type_file.chr8          #No.FUN-6A0062
  DEFINE g_forupd_sql         STRING             #SELECT ... FOR UPDATE SQL 
# DEFINE g_before_input_done  SMALLINT                               #NO.FUN-680062   
  DEFINE g_before_input_done LIKE type_file.num5                     #NO.FUN-680062   
  DEFINE g_cnt     LIKE  type_file.num10                             #NO.FUN-680062     
# DEFINE g_msg                VARCHAR(72)                               #NO.FUN-680062   
  DEFINE g_msg     LIKE type_file.chr1000                            #NO.FUN-680062   
# DEFINE g_row_count          INTEGER                                #NO.FUN-680062   
  DEFINE g_row_count  LIKE type_file.num10                           #NO.FUN-680062   
# DEFINE g_curs_index         INTEGER                                #NO.FUN-680062   
  DEFINE g_curs_index LIKE type_file.num10                           #NO.FUN-680062   
# DEFINE g_jump               INTEGER                                #NO.FUN-680062   
  DEFINE g_jump      LIKE  type_file.num10                           #NO.FUN-680062          
# DEFINE mi_no_ask            SMALLINT                               #NO.FUN-680062   
  DEFINE mi_no_ask   LIKE  type_file.num5                            #NO.FUN-680062   
DEFINE g_ima1916          LIKE ima_file.ima1916  #FUN-6A0007
 
MAIN
    DEFINE p_row LIKE type_file.num5                                 #NO.FUN-680062   
    DEFINE p_col LIKE type_file.num5                                 #NO.FUN-680062     
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM bnd_file WHERE bnd01 = ? AND bnd02 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i030_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   OPEN WINDOW i030_w WITH FORM "abx/42f/abxi030"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL i030_menu()
   CLOSE WINDOW i030_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
 
END MAIN
 
FUNCTION i030_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   CALL g_bne.clear()
 
   #FUN-6A0007...............begin
   #CONSTRUCT BY NAME  g_wc ON bnd01,bnd02,bnd03,bnd04
   INITIALIZE g_bnd.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME  g_wc ON bnd01,bnd02,bnd03,bnd04,ima1916a,bnd102
                              #FUN-840202   ---start---
                              ,bndud01,bndud02,bndud03,bndud04,bndud05,
                              bndud06,bndud07,bndud08,bndud09,bndud10,
                              bndud11,bndud12,bndud13,bndud14,bndud15
                              #FUN-840202    ----end----
   #FUN-6A0007...............end
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bnd01)
#              CALL q_ima(10,3,g_bnd.bnd01) RETURNING g_bnd.bnd01
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_ima"      #TQC-990126   #MOD-BA0145 remark
              #LET g_qryparam.form = "q_bnd01"    #TQC-990126   #MOD-BA0145 mark
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bnd01
               NEXT FIELD bnd01
            #FUN-6A0007...............begin
            WHEN INFIELD(ima1916a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_bxe01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima1916a
               NEXT FIELD ima1916a
            #FUN-6A0007...............end
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   CONSTRUCT g_wc2 ON bne03,bne05,bne06,bne07,bne10,bne11,bne08,ima1916b,bne09   #No.FUN-5B0023
                      #No.FUN-840202 --start--
                      ,bneud01,bneud02,bneud03,bneud04,bneud05
                      ,bneud06,bneud07,bneud08,bneud09,bneud10
                      ,bneud11,bneud12,bneud13,bneud14,bneud15
                      #No.FUN-840202 ---end---
                 FROM s_bne[1].bne03,s_bne[1].bne05,s_bne[1].bne06,
                      s_bne[1].bne07,s_bne[1].bne10,s_bne[1].bne11,  #No.FUN-5B0023
                      s_bne[1].bne08,s_bne[1].ima1916b,s_bne[1].bne09 #FUN-6A0007
                      #No.FUN-840202 --start--
                      ,s_bne[1].bneud01,s_bne[1].bneud02,s_bne[1].bneud03,s_bne[1].bneud04,s_bne[1].bneud05
                      ,s_bne[1].bneud06,s_bne[1].bneud07,s_bne[1].bneud08,s_bne[1].bneud09,s_bne[1].bneud10
                      ,s_bne[1].bneud11,s_bne[1].bneud12,s_bne[1].bneud13,s_bne[1].bneud14,s_bne[1].bneud15
                      #No.FUN-840202 ---end--- 
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bne05)
#              CALL q_ima(0,0,g_bne[1].bne05) RETURNING g_bne[1].bne05
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_ima"     #TQC-990126    #MOD-BA0145 remark
              #LET g_qryparam.form = "q_bne05"   #TQC-990126    #MOD-BA0145 mark
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bne05
               NEXT FIELD bne05
            #FUN-6A0007...............begin
            WHEN INFIELD(ima1916b)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_bxe01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima1916b
               NEXT FIELD ima1916b
            #FUN-6A0007...............end
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   #FUN-6A0007...............begin 做ima1916a,ima1916b字串替換
   CALL cl_replace_str(g_wc,'ima1916a','a.ima1916') RETURNING g_wc
   CALL cl_replace_str(g_wc2,'ima1916b','b.ima1916') RETURNING g_wc2
   #FUN-6A0007...............end   做ima1916a,ima1916b字串替換
 
   IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
      #FUN-6A0007...............begin 多join ima_file
      #LET g_sql = "SELECT  bnd01, bnd02 FROM bnd_file",
      #            " WHERE ", g_wc CLIPPED,
      #            " ORDER BY 2"
      LET g_sql = "SELECT UNIQUE bnd_file. bnd01, bnd02 ",
                  "  FROM bnd_file,ima_file a",
                  " WHERE ", g_wc CLIPPED,
                  "   AND bnd01 = a.ima01 ",
                  " ORDER BY bnd01"
      #FUN-6A0007...............begin 多join ima_file
   ELSE                                       # 若單身有輸入條件
      #FUN-6A0007...............begin 多join ima_file
      #LET g_sql = "SELECT UNIQUE bnd_file. bnd01,bnd02 ",
      #            "  FROM bnd_file, bne_file",
      #            " WHERE bnd01 = bne01",
      #            "   AND bnd02 = bne02",
      #            "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
      #            " ORDER BY bnd01"
      LET g_sql = "SELECT UNIQUE bnd_file. bnd01,bnd02 ",
                  "  FROM bnd_file, bne_file,ima_file a,ima_file b",
                  " WHERE bnd01 = bne01",
                  "   AND bnd02 = bne02",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  "   AND bnd01 = a.ima01 AND bne05 = b.ima01 ",
                  " ORDER BY bnd01"
      #FUN-6A0007...............end   多join ima_file
   END IF
 
   PREPARE i030_prepare FROM g_sql
   DECLARE i030_cs SCROLL CURSOR WITH HOLD FOR i030_prepare
 
   IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
      #FUN-6A0007...............begin 多join ima_file
      #LET g_sql = "SELECT COUNT(*) FROM bnd_file WHERE ",g_wc CLIPPED
      LET g_sql = "SELECT COUNT(*) FROM bnd_file,ima_file a",
                  " WHERE ",g_wc CLIPPED,
                  "   AND bnd01 = a.ima01 "
      #FUN-6A0007...............end   多join ima_file
   ELSE
      #FUN-6A0007...............begin 多join ima_file
      #LET g_sql = "SELECT COUNT(DISTINCT bnd01) FROM bnd_file,bne_file ",
      #            " WHERE bne01=bnd01 AND bne02=bnd02 AND ",g_wc CLIPPED,
      #            "   AND ",g_wc2 CLIPPED
      #LET g_sql = "SELECT COUNT(DISTINCT bnd01) ",   #MOD-9C0154
      LET g_sql = "SELECT COUNT(DISTINCT bnd01||bnd02) ",   #MOD-9C0154
                  "  FROM bnd_file,bne_file,ima_file a,ima_file b ",
                  " WHERE bne01=bnd01 AND bne02=bnd02 AND ",g_wc CLIPPED,
                  "   AND bnd01 = a.ima01 AND bne05 = b.ima01 ",
                  "   AND ",g_wc2 CLIPPED
      #FUN-6A0007...............end   多join ima_file
   END IF
   PREPARE i030_cntpre FROM g_sql
   DECLARE i030_count CURSOR FOR i030_cntpre
 
END FUNCTION
 
FUNCTION i030_menu()
 
   WHILE TRUE
      CALL i030_bp("G")
 
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i030_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i030_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i030_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i030_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i030_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i030_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         #FUN-6A0007...............begin
         WHEN "abxp111_bom"
            IF cl_chk_act_auth() THEN
               LET g_msg="abxp111"
               CALL cl_cmdrun(g_msg)
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "abxp113"
            IF cl_chk_act_auth() THEN
               LET g_msg = "abxp113"
               CALL cl_cmdrun(g_msg)
            ELSE
               LET g_action_choice = NULL
            END IF
         #FUN-6A0007...............end
 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bne),'','')
            END IF
         #No.FUN-6A0046-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_bnd.bnd01 IS NOT NULL THEN
                LET g_doc.column1 = "bnd.bnd01"
                LET g_doc.column2 = "bnd.bnd02"
                LET g_doc.value1 = g_bnd.bnd01
                LET g_doc.value2 = g_bnd.bnd02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0046-------add--------end----
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i030_a()
   DEFINE l_bnd01    LIKE bnd_file.bnd01
   DEFINE l_bnd02    LIKE bnd_file.bnd02
   DEFINE l_bnd03    LIKE bnd_file.bnd03
   DEFINE l_bni      RECORD LIKE bni_file.*
 
   MESSAGE ""
   CLEAR FORM
   CALL g_bne.clear()
   INITIALIZE g_bnd.* TO NULL
   LET g_bnd.bnd01    = ' '
   LET g_bnd_t.bnd01  = ' '
   LET g_bnd.bnd02    = ' '
   LET g_bnd_t.bnd02  = ' '
   LET g_bnd.bnd102 = 'N'       #FUN-6A0007
   LET g_bnd_t.* = g_bnd.*        #FUN-6A0007
   LET g_bnd_o.* = g_bnd.*        #FUN-6A0007
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_bnd.bnd02 = g_today
 
      CALL i030_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_bnd.bnd01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #---->若已有相同主件料號存在於資料庫中, 且其失效日期並未輸入
      #---->則系統自動default 本筆資料的生效日期-1為其失效日期
      #----1. 找尋是否有其他的相同主件
      DECLARE i030_a_curs SCROLL CURSOR FOR
       SELECT bnd01,bnd03,bnd02 FROM bnd_file
        WHERE bnd01 = g_bnd.bnd01
        ORDER BY bnd02,bnd01
 
      OPEN i030_a_curs
      #----2. 找尋其最後一筆資料, 並將其失效日期default為新增的生效日期
      IF NOT STATUS THEN
         FETCH LAST i030_a_curs INTO l_bnd01,l_bnd03,l_bnd02
         IF cl_null(l_bnd03) OR l_bnd03=' ' THEN
            UPDATE bnd_file SET bnd03 = g_bnd.bnd02
             WHERE bnd01 = l_bnd01
               AND bnd02 = l_bnd02
            IF STATUS THEN
#              CALL cl_err('err bnd03',STATUS,0)    #No.FUN-660052
               CALL cl_err3("upd","bnd_file",l_bnd01,l_bnd02,STATUS,"","err bnd03",1)
            END IF
         END IF
      END IF
 
      #---->若其核備文號沒有輸入; 則由系統自動取保稅BOM 核備文號維護作業
      #---->所定義的字首;文號;字尾UPDATE  成本筆的核備文號
      #---->最後將文號流水號+1 UPDATE 回  保稅BOM 核備文號維護檔。
      #FUN-6A0007...............begin
      #IF cl_null(g_bnd.bnd04) THEN
      #   SELECT * INTO l_bni.* FROM bni_file
      #   LET g_bnd.bnd04 = l_bni.bni01 CLIPPED,
      #                     l_bni.bni02 CLIPPED,
      #                     l_bni.bni03 CLIPPED
      #   LET l_bni.bni02 = l_bni.bni02 + 1 USING '&&&&' CLIPPED
 
      #   UPDATE bni_file SET bni02 = l_bni.bni02
 
      #   DISPLAY BY NAME g_bnd.bnd04
      #END IF
      #FUN-6A0007...............end
 
      INSERT INTO bnd_file VALUES (g_bnd.*)
      IF SQLCA.sqlcode THEN                           #置入資料庫不成功
#        CALL cl_err(g_bnd.bnd01,SQLCA.sqlcode,1)     #No.FUN-660052
         CALL cl_err3("ins","bnd_file",g_bnd.bnd01,g_bnd.bnd02,SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
 
      SELECT bnd01,bnd02 INTO g_bnd.bnd01,g_bnd.bnd02 FROM bnd_file
       WHERE bnd01 = g_bnd.bnd01
         AND bnd02 = g_bnd.bnd02
 
      LET g_bnd_t.* = g_bnd.*
 
      LET g_rec_b = 0                    #No.FUN-680064
      CALL g_bne.clear()
 
      CALL i030_put()    # 以其主件到產品結構元件明細資料檔取其下一階的元料們
 
      CALL i030_b_fill(' 1=1')
 
      CALL i030_b()                      #輸入單身
 
      LET g_bnd01_t = g_bnd.bnd01        #保留舊值
      LET g_bnd02_t = g_bnd.bnd02        #保留舊值
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i030_u()
 
   IF s_abxshut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_bnd.bnd01) OR cl_null(g_bnd.bnd02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_bnd01_t = g_bnd.bnd01
   LET g_bnd02_t = g_bnd.bnd02
   LET g_bnd_o.* = g_bnd.*
   BEGIN WORK
 
   OPEN i030_cl USING g_bnd.bnd01,g_bnd.bnd02
   IF STATUS THEN
      CALL cl_err("OPEN i030_cl:", STATUS, 1)
      CLOSE i030_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i030_cl INTO g_bnd.*              # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bnd.bnd01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i030_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i030_show()
 
   WHILE TRUE
      LET g_bnd01_t = g_bnd.bnd01
      LET g_bnd02_t = g_bnd.bnd02
 
      CALL i030_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_bnd.*=g_bnd_t.*
         CALL i030_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_bnd.bnd01 != g_bnd01_t THEN            # 更改單號
         UPDATE bne_file
            SET bne01 = g_bnd.bnd01,
                bne02 = g_bnd.bnd02
          WHERE bne01 = g_bnd01_t
            AND bne02 = g_bnd02_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err('bne',SQLCA.sqlcode,0)    #No.FUN-660052
            CALL cl_err3("upd","bne_file",g_bnd01_t,g_bnd02_t,SQLCA.sqlcode,"","bne",1)
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE bnd_file SET bnd_file.* = g_bnd.*
       WHERE bnd01 = g_bnd01_t AND bnd02 = g_bnd02_t
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_bnd.bnd01,SQLCA.sqlcode,0) #No.FUN-660052
         CALL cl_err3("upd","bnd_file",g_bnd01_t,g_bnd02_t,SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE i030_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i030_i(p_cmd)
 DEFINE p_cmd LIKE type_file.chr1,                     #NO.FUN-680062 VARCHAR(1)     
        l_cmd LIKE type_file.chr1000,                  #NO.FUN-680062 VARCHAR(70)    
        l_n   LIKE type_file.num5,                     #NO.FUN-680062 smallint 
        l_str LIKE type_file.chr1000                   #NO.FUN-680062 VARCHAR(40) 
DEFINE l_bni   RECORD LIKE bni_file.*  #FUN-6A0007
 
   #FUN-6A0007...............begin
   #INPUT BY NAME g_bnd.bnd01,g_bnd.bnd02,g_bnd.bnd03,g_bnd.bnd04
 
 
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
   INPUT BY NAME g_bnd.bnd01,g_bnd.bnd02,g_bnd.bnd03,g_bnd.bnd04,
                 g_bnd.bnd102
                 #FUN-840202     ---start---
                ,g_bnd.bndud01,g_bnd.bndud02,g_bnd.bndud03,g_bnd.bndud04,
                 g_bnd.bndud05,g_bnd.bndud06,g_bnd.bndud07,g_bnd.bndud08,
                 g_bnd.bndud09,g_bnd.bndud10,g_bnd.bndud11,g_bnd.bndud12,
                 g_bnd.bndud13,g_bnd.bndud14,g_bnd.bndud15 
                 #FUN-840202     ----end----
   #FUN-6A0007...............end
                 WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i030_set_entry(p_cmd)
         CALL i030_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD bnd01
         IF NOT cl_null(g_bnd.bnd01) THEN
           #FUN-AA0059 --------------------------add start-----------------------
            IF NOT s_chk_item_no(g_bnd.bnd01,'') THEN
               CALL cl_err('',g_errno,1)
               LET g_bnd.bnd01 = g_bnd_t.bnd01
               DISPLAY BY NAME g_bnd.bnd01
               NEXT FIELD bnd01
            END IF 
           #FUN-AA0059 --------------------------add end---------------------------- 
            IF g_bnd_o.bnd01 IS NULL OR (g_bnd_o.bnd01 != g_bnd.bnd01) THEN
               CALL i030_bnd01(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_bnd.bnd01,g_errno,0)
                  LET g_bnd.bnd01 = g_bnd_t.bnd01
                  DISPLAY BY NAME g_bnd.bnd01
                  NEXT FIELD bnd01
               END IF
               #FUN-6A0007...............begin
               CALL i030_ima1916_h()
               DISPLAY g_ima1916 TO FORMONLY.ima1916a
               CALL i030_ima1916a(p_cmd)
               #FUN-6A0007...............end
            END IF
            #FUN-6A0007...............begin
            IF p_cmd = 'a' AND cl_null(g_bnd_o.bnd01) THEN
               INITIALIZE l_bni.* TO NULL
               SELECT * INTO l_bni.* FROM bni_file
               LET g_bnd.bnd04 = l_bni.bni01 CLIPPED,
                                 l_bni.bni02 CLIPPED,
                                 l_bni.bni03 CLIPPED
              #MOD-BC0146 -- begin --
               LET l_bni.bni02 = l_bni.bni02 + 1 USING '&&&&' CLIPPED
               UPDATE bni_file SET bni02 = l_bni.bni02
              #MOD-BC0146 -- end --
               DISPLAY BY NAME g_bnd.bnd04
         END IF
         ELSE 
            DISPLAY ' ' TO ima1916a
            DISPLAY ' ' TO bxe02h
            DISPLAY ' ' TO bxe03h
            #FUN-6A0007...............end
         END IF
         #LET g_bnd_t.bnd01 = g_bnd.bnd01   #FUN-6A0007
         LET g_bnd_o.bnd01 = g_bnd.bnd01    #FUN-6A0007
 
      AFTER FIELD bnd02
         IF NOT cl_null(g_bnd.bnd02) THEN
            IF g_bnd_o.bnd02 IS NULL OR (g_bnd_o.bnd02 != g_bnd.bnd02) THEN   #No.TQC-5C0040
               SELECT COUNT(*) INTO l_n FROM bnd_file
                WHERE bnd01 = g_bnd.bnd01
                  AND bnd02 = g_bnd.bnd02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_bnd.bnd01 = g_bnd_o.bnd01
                  LET g_bnd.bnd02 = g_bnd_o.bnd02
                  NEXT FIELD bnd01
               END IF
            END IF
            LET g_bnd_o.bnd02 = g_bnd.bnd02
         END IF
 
      #FUN-6A0007...............begin
      AFTER FIELD bnd102  #保稅BOM列印否
         IF NOT cl_null(g_bnd.bnd102) THEN
            IF g_bnd.bnd102 NOT MATCHES '[YN]' THEN
               CALL cl_err('Y/N ',STATUS,0)
               NEXT FIELD bnd102
            END IF
         END IF
      #FUN-6A0007...............end
 
        #FUN-840202     ---start---
        AFTER FIELD bndud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bndud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bndud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bndud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bndud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bndud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bndud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bndud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bndud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bndud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bndud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bndud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bndud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bndud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bndud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bnd01)
#              CALL q_ima(10,3,g_bnd.bnd01) RETURNING g_bnd.bnd01
#              CALL FGL_DIALOG_SETBUFFER( g_bnd.bnd01 )
#FUN-AA0059 --Begin--
            #   CALL cl_init_qry_var()
##               LET g_qryparam.form = "q_ima"      #TQC-990126
            #    LET g_qryparam.form = "q_ima991"   #TQC-990126
            #   LET g_qryparam.default1 = g_bnd.bnd01
            #   CALL cl_create_qry() RETURNING g_bnd.bnd01
              #CALL q_sel_ima(FALSE, "q_ima991", "", g_bnd.bnd01, "", "", "", "" ,"",'' )  RETURNING g_bnd.bnd01   #MOD-BA0145 mark
               CALL q_sel_ima(FALSE, "q_ima", "", g_bnd.bnd01, "", "", "", "" ,"",'' )  RETURNING g_bnd.bnd01      #MOD-BA0145
#FUN-AA0059 --End--
#              CALL FGL_DIALOG_SETBUFFER( g_bnd.bnd01 )
               DISPLAY BY NAME g_bnd.bnd01
               CALL i030_bnd01('d')
               NEXT FIELD bnd01
         END CASE
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       #MOD-650015 --start
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #  IF INFIELD(bnd01) THEN
       #     LET g_bnd.* = g_bnd_t.*
       #     DISPLAY BY NAME g_bnd.*
       #     NEXT FIELD bnd01
       #  END IF
       #MOD-650015 --end
 
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
 
END FUNCTION
 
FUNCTION i030_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_bnd.* TO NULL             #No.FUN-6A0046
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i030_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_bnd.* TO NULL
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
 
   OPEN i030_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_bnd.* TO NULL
   ELSE
      OPEN i030_count
      FETCH i030_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i030_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
   MESSAGE ""
 
END FUNCTION
 
FUNCTION i030_fetch(p_flag)
DEFINE p_flag  LIKE type_file.chr1,         #處理方式    #NO.FUN-680062 VARCHAR(1)
       l_abso  LIKE type_file.num10         #絕對的筆數  #NO.FUN-680062 INTEGERA
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i030_cs INTO g_bnd.bnd01,g_bnd.bnd02
      WHEN 'P' FETCH PREVIOUS i030_cs INTO g_bnd.bnd01,g_bnd.bnd02
      WHEN 'F' FETCH FIRST    i030_cs INTO g_bnd.bnd01,g_bnd.bnd02
      WHEN 'L' FETCH LAST     i030_cs INTO g_bnd.bnd01,g_bnd.bnd02
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
 
         FETCH ABSOLUTE g_jump i030_cs
         INTO g_bnd.bnd01,g_bnd.bnd02
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bnd.bnd01,SQLCA.sqlcode,0)
      INITIALIZE g_bnd.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index,g_row_count)
   END IF
 
   SELECT * INTO g_bnd.* FROM bnd_file WHERE bnd01 = g_bnd.bnd01 AND bnd02 = g_bnd.bnd02
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_bnd.bnd01,SQLCA.sqlcode,0)   #No.FUN-660052
      CALL cl_err3("sel","bnd_file",g_bnd.bnd01,g_bnd.bnd02,SQLCA.sqlcode,"","",1)
      INITIALIZE g_bnd.* TO NULL
      RETURN
   END IF
 
   CALL i030_show()
 
END FUNCTION
 
FUNCTION i030_show()
 
   LET g_bnd_t.* = g_bnd.*                #保存單頭舊值
   LET g_bnd_o.* = g_bnd.*                #保存單頭舊值 #FUN-6A0007
   DISPLAY BY NAME g_bnd.bnd01,g_bnd.bnd02,g_bnd.bnd03,g_bnd.bnd04
           #FUN-840202     ---start---
           ,g_bnd.bndud01,g_bnd.bndud02,g_bnd.bndud03,g_bnd.bndud04,
           g_bnd.bndud05,g_bnd.bndud06,g_bnd.bndud07,g_bnd.bndud08,
           g_bnd.bndud09,g_bnd.bndud10,g_bnd.bndud11,g_bnd.bndud12,
           g_bnd.bndud13,g_bnd.bndud14,g_bnd.bndud15 
           #FUN-840202     ----end----
 
   DISPLAY BY NAME g_bnd.bnd102 #FUN-6A0007
   CALL i030_ima1916_h() #FUN-6A0007
   CALL i030_ima1916a('d') #FUN-6A0007
 
   CALL i030_bnd01('d')
 
   CALL i030_b_fill(g_wc2)                 #單身
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION i030_r()
#   DEFINE l_chr,l_sure   VARCHAR(1)                      #NO.FUN-680062   
    DEFINE l_chr LIKE type_file.chr1,                #NO.FUN-680062    
           l_sure LIKE type_file.chr1                #NO.FUN-680062    VARCHAR(1)
 
   IF s_abxshut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_bnd.bnd01) OR cl_null(g_bnd.bnd02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i030_cl USING g_bnd.bnd01,g_bnd.bnd02
   IF STATUS THEN
      CALL cl_err("OPEN i030_cl:", STATUS, 1)
      CLOSE i030_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i030_cl INTO g_bnd.*
   IF SQLCA.sqlcode THEN
     CALL cl_err(g_bnd.bnd01,SQLCA.sqlcode,0)
     RETURN
   END IF
 
   CALL i030_show()
 
   IF cl_delh(20,16)  THEN
       INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "bnd.bnd01"      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "bnd.bnd02"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_bnd.bnd01       #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_bnd.bnd02       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                             #No.FUN-9B0098 10/02/24
      DELETE FROM bnd_file
       WHERE bnd01 = g_bnd.bnd01
         AND bnd02 = g_bnd.bnd02
 
      DELETE FROM bne_file
       WHERE bne01 = g_bnd.bnd01
         AND bne02 = g_bnd.bnd02
 
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err(g_bnd.bnd01,SQLCA.sqlcode,0)    #No.FUN-660052
         CALL cl_err3("del","bne_file",g_bnd.bnd01,g_bnd.bnd02,SQLCA.sqlcode,"","",1)
      ELSE
         CLEAR FORM
         CALL g_bne.clear()
 
         OPEN i030_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i030_cs
            CLOSE i030_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i030_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i030_cs
            CLOSE i030_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
 
         OPEN i030_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i030_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i030_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE i030_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i030_b()
DEFINE l_ac_t LIKE type_file.num5,            #未取消的ARRAY CNT   #NO.FUN-680062 smallint  
        l_n    LIKE type_file.num5,                                 #NO.FUN-680062smallint   
        l_lock_sw LIKE type_file.chr1,                              #NO.FUN-680062 VARCHAR(1)   
        p_cmd  LIKE type_file.chr1,                                 #NO.FUN-680062 VARCHAR(1) 
        l_cmd  LIKE type_file.chr1000,                              #NO.FUN-680062 VARCHAR(70)   
       l_bne05         LIKE bne_file.bne05,
       l_bne06         LIKE bne_file.bne06,
       l_bne07         LIKE bne_file.bne07,
       l_bne09         LIKE bne_file.bne09,
       l_ima08         LIKE ima_file.ima08,
       l_ima55         LIKE ima_file.ima55,
       l_acti          LIKE sfb_file.sfbacti,
       l_allow_insert  LIKE type_file.num5,                         #可新增否            #NO.FUN-680062   smallint
       l_allow_delete LIKE type_file.num5                           #NO.FUN-680062     smallint
DEFINE l_bmb06         LIKE bmb_file.bmb06 #FUN-6A0007
DEFINE l_bmb07         LIKE bmb_file.bmb07 #FUN-6A0007
DEFINE l_bmb08         LIKE bmb_file.bmb08 #FUN-6A0007
DEFINE l_flag          LIKE type_file.chr1 #FUN-6A0007
 
   IF cl_null(g_bnd.bnd01) OR cl_null(g_bnd.bnd02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF s_abxshut(0) THEN
      RETURN
   END IF
 
   LET g_action_choice = ""
   CALL cl_opmsg('b')
   #FUN-6A0007...............begin
   ##LET g_forupd_sql = "SELECT bne03,bne05,'',bne06,bne07,bne10,bne11,bne08,bne09 ",   #No.FUN-5B0023
   #                   "  WHERE bne01=? AND bne02=? AND bne03 =?",
   #                   "   AND bne05=? FOR UPDATE "
   LET g_forupd_sql = "SELECT bne03,bne05,'','',bne06,bne07,bne10,bne11,bne08, ",
                      "       '','','',bne09 ", 
                      ",bneud01,bneud02,bneud03,bneud04,bneud05,",
                      "bneud06,bneud07,bneud08,bneud09,bneud10,",
                      "bneud11,bneud12,bneud13,bneud14,bneud15",
                      "  FROM bne_file",
                      "  WHERE bne01=? AND bne02=? AND bne03 =?",
                      "   AND bne05=? FOR UPDATE"
   #FUN-6A0007...............end
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i030_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_bne WITHOUT DEFAULTS FROM s_bne.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         LET l_flag = 'N'               #FUN-6A0007
         BEGIN WORK
 
         OPEN i030_cl USING g_bnd.bnd01,g_bnd.bnd02
         IF STATUS THEN
            CALL cl_err("OPEN i030_cl:", STATUS, 1)
            CLOSE i030_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         FETCH i030_cl INTO g_bnd.*              # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_bnd.bnd01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            CLOSE i030_cl
            RETURN
         END IF
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_bne_t.* = g_bne[l_ac].*  #BACKUP
            LET g_bne_o.* = g_bne[l_ac].*  #BACKUP #FUN-6A0007
            OPEN i030_bcl USING g_bnd.bnd01,g_bnd.bnd02,g_bne_t.bne03,g_bne_t.bne05
            IF STATUS THEN  #MOD-4B0075
               CALL cl_err("OPEN i030_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i030_bcl INTO g_bne[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_bne_t.bne05,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL i030_bne05('d') #MOD-4B0075
            #FUN-6A0007...............begin
            CALL i030_ima1916_s()
            CALL i030_ima1916b('d')
            #FUN-6A0007...............end
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
#        NEXT FIELD bne03
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_bne[l_ac].* TO NULL      #900423
         LET g_bne[l_ac].bne06 = g_bnd.bnd02
         LET g_bne[l_ac].bne07 = g_bnd.bnd03
         LET g_bne[l_ac].bne08 = 0   #No.FUN-5B0023
         LET g_bne[l_ac].bne09 ='Y'  #FUN-6A0007
         LET g_bne[l_ac].bne10 = 0   #No.FUN-5B0023
         LET g_bne[l_ac].bne11 = 0   #No.FUN-5B0023
         LET g_bne_t.* = g_bne[l_ac].*         #新輸入資料
         LET g_bne_o.* = g_bne[l_ac].*         #FUN-6A0007
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD bne03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO bne_file (bne01,bne02,bne03,bne05,bne06,bne07,  #No.MOD-470041
                               bne10,bne11,bne08,bne09   #No.FUN-5B0023
                               #FUN-840202 --start--
                              ,bneud01,bneud02,bneud03,
                               bneud04,bneud05,bneud06,
                               bneud07,bneud08,bneud09,
                               bneud10,bneud11,bneud12,
                               bneud13,bneud14,bneud15)
                               #FUN-840202 --end--
                        VALUES(g_bnd.bnd01,g_bnd.bnd02,g_bne[l_ac].bne03,
                               g_bne[l_ac].bne05,g_bne[l_ac].bne06,
                               g_bne[l_ac].bne07,g_bne[l_ac].bne10,   #No.FUN-5B
                               g_bne[l_ac].bne11,g_bne[l_ac].bne08,   #No.FUN-5B
                               g_bne[l_ac].bne09,
                               #FUN-840202 --start--
                               g_bne[l_ac].bneud01, g_bne[l_ac].bneud02,
                               g_bne[l_ac].bneud03, g_bne[l_ac].bneud04,
                               g_bne[l_ac].bneud05, g_bne[l_ac].bneud06,
                               g_bne[l_ac].bneud07, g_bne[l_ac].bneud08,
                               g_bne[l_ac].bneud09, g_bne[l_ac].bneud10,
                               g_bne[l_ac].bneud11, g_bne[l_ac].bneud12,
                               g_bne[l_ac].bneud13, g_bne[l_ac].bneud14,
                               g_bne[l_ac].bneud15)
                               #FUN-840202 --end--
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_bne[l_ac].bne03,SQLCA.sqlcode,0)            #No.FUN-660052
            CALL cl_err3("ins","bne_file",g_bnd.bnd01,g_bne[l_ac].bne03,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      BEFORE FIELD bne03                        # dgeeault 序號
         IF cl_null(g_bne[l_ac].bne03) OR g_bne[l_ac].bne03 = 0 THEN
            SELECT max(bne03)+1 INTO g_bne[l_ac].bne03 FROM bne_file
             WHERE bne01 = g_bnd.bnd01
               AND bne02 = g_bnd.bnd02
            IF cl_null(g_bne[l_ac].bne03) THEN
               LET g_bne[l_ac].bne03 = 1
            END IF
         END IF
 
      AFTER FIELD bne03
         IF NOT cl_null(g_bne[l_ac].bne03) THEN
            IF g_bne[l_ac].bne03 = 0 THEN
               NEXT FIELD bne03
            END IF
            #FUN-6A0007...............begin
            #IF g_bne[l_ac].bne03 != g_bne_t.bne03 OR g_bne_t.bne03 IS NULL THEN
            IF g_bne[l_ac].bne03 != g_bne_o.bne03 OR cl_null(g_bne_o.bne03) THEN
            #FUN-6A0007...............end
               SELECT bne06,bne07,bne09,bne05
                 INTO l_bne06,l_bne07,l_bne09,l_bne05
                 FROM bne_file
                WHERE bne01 = g_bnd.bnd01
                  AND bne03 = g_bne[l_ac].bne03
                  AND bne02 = g_bnd.bnd02
 
               IF ((l_bne06 != '01/01/99' AND cl_null(l_bne07)) OR l_bne09 = 'Y') THEN
                  CALL cl_err('','abx-406',0)
                  LET g_bne[l_ac].bne03 = g_bne_t.bne03
                  NEXT FIELD bne03
               END IF
               LET l_flag = 'Y'                   #FUN-6A0007
            END IF
            LET g_bne_o.bne03 = g_bne[l_ac].bne03 #FUN-6A0007
         END IF
 
      AFTER FIELD bne05
         IF NOT cl_null(g_bne[l_ac].bne05) THEN
            #FUN-AA0059 -------------------------------add start---------------------------
            IF NOT s_chk_item_no(g_bne[l_ac].bne05,'') THEN
               CALL cl_err('',g_errno,1)
               LET g_bne[l_ac].bne05 = g_bne_t.bne05
               NEXT FIELD bne05
            END IF 
            #FUN-AA0059 -------------------------------add end---------------------------
            #FUN-6A0007...............begin
            #IF cl_null(g_bne_t.bne05) OR (g_bne_t.bne05 != g_bne[l_ac].bne05) THEN
            IF cl_null(g_bne_o.bne05) OR (g_bne_o.bne05 != g_bne[l_ac].bne05) THEN
            #FUN-6A0007...............end
               CALL i030_bne05(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_bne[l_ac].bne05,g_errno,0)
                  LET g_bne[l_ac].bne05 = g_bne_t.bne05
                  NEXT FIELD bne05
               END IF
               #FUN-6A0007...............begin
               CALL i030_ima1916_s()
               CALL i030_ima1916b(p_cmd)
               LET l_flag = 'Y'
               #FUN-6A0007...............end
            END IF
         ELSE 
            LET g_bne[l_ac].bxe02 = NULL
            LET g_bne[l_ac].bxe03 = NULL
            DISPLAY BY NAME g_bne[l_ac].bxe02,g_bne[l_ac].bxe03 
         END IF
         LET g_bne_o.bne05 = g_bne[l_ac].bne05 #FUN-6A0007
 
      #FUN-6A0007...............begin
      AFTER FIELD bne06
         IF NOT cl_null(g_bne[l_ac].bne06) THEN
            IF cl_null(g_bne_o.bne06) OR 
               (g_bne_o.bne06 != g_bne[l_ac].bne06) THEN 
                IF g_bne[l_ac].bne07 < g_bne[l_ac].bne06 THEN
                   NEXT FIELD bne06
                END IF
                LET l_flag = 'Y'
            END IF
            LET g_bne_o.bne06 = g_bne[l_ac].bne06
         END IF  
      #FUN-6A0007...............end
 
      AFTER FIELD bne07
         IF NOT cl_null(g_bne[l_ac].bne07)
            AND g_bne[l_ac].bne07 < g_bne[l_ac].bne06 THEN
            NEXT FIELD bne07
         END IF
 
      AFTER FIELD bne09
         IF NOT cl_null(g_bne[l_ac].bne09) THEN
            IF g_bne[l_ac].bne09 NOT MATCHES '[YN]' THEN
               NEXT FIELD bne09
            END IF
         END IF
 
      #-----No.FUN-5B0023-----
      #FUN-6A0007...............begin
      {
      AFTER FIELD bne10
         IF g_bne[l_ac].bne08 = 0 THEN
            LET g_bne[l_ac].bne08 = g_bne[l_ac].bne10 + g_bne[l_ac].bne11
         END IF
      }
      #FUN-6A0007...............end
 
      #FUN-6A0007...............begin
#     BEFORE FIELD bne11    #損耗數      #No.TQC-730122
      BEFORE FIELD bne10      #No.TQC-730122
         IF l_flag = 'Y' THEN 
            LET l_flag = 'N'
            LET l_bmb06 = 0
            LET l_bmb07 = 0
            LET l_bmb08 = 0
            SELECT bmb08,bmb06,bmb07 INTO l_bmb08,l_bmb06,l_bmb07 FROM bmb_file
             WHERE bmb01=g_bnd.bnd01
               AND bmb02=g_bne[l_ac].bne03
               AND bmb03=g_bne[l_ac].bne05
               AND bmb04=g_bne[l_ac].bne06
            
            IF cl_null(l_bmb06) THEN LET l_bmb06 = 0 END IF
#No.TQC-730122 --begin
#           IF cl_null(l_bmb07) THEN LET l_bmb06 = 0 END IF
#           IF cl_null(l_bmb08) THEN LET l_bmb06 = 0 END IF
            IF cl_null(l_bmb07) THEN LET l_bmb07 = 0 END IF
            IF cl_null(l_bmb08) THEN LET l_bmb08 = 0 END IF
#No.TQC-730122 --end
          
            LET g_bne[l_ac].bne10 = l_bmb06/l_bmb07
            LET g_bne[l_ac].bne11 = l_bmb08/100*l_bmb06/l_bmb07
            LET g_bne[l_ac].bne08 = g_bne[l_ac].bne10 +
                                    g_bne[l_ac].bne11
            LET g_bne_o.bne10 = g_bne[l_ac].bne10
            LET g_bne_o.bne11 = g_bne[l_ac].bne11
            DISPLAY BY NAME g_bne[l_ac].bne08
            DISPLAY BY NAME g_bne[l_ac].bne10
            DISPLAY BY NAME g_bne[l_ac].bne11
         END IF
 
      AFTER FIELD bne08   #應用數
         IF NOT cl_null(g_bne[l_ac].bne08) THEN
            IF g_bne[l_ac].bne08 < 0 THEN
               CALL cl_err('','aim-391',0)
               NEXT FIELD bne08
            END IF
         END IF
 
 
      AFTER FIELD bne10   #實用數
         IF NOT cl_null(g_bne[l_ac].bne10) THEN
            IF g_bne[l_ac].bne10 < 0 THEN
               CALL cl_err('','aim-391',0)
               NEXT FIELD bne10
            END IF
            IF cl_null(g_bne_o.bne10) OR
               (g_bne_o.bne10 != g_bne[l_ac].bne10) THEN
               LET g_bne[l_ac].bne08 = g_bne[l_ac].bne10 +
                                       g_bne[l_ac].bne11
               DISPLAY BY NAME g_bne[l_ac].bne08
            END IF
            LET g_bne_o.bne10 = g_bne[l_ac].bne10
         END IF
 
 
      AFTER FIELD bne11  #損耗數
         IF NOT cl_null(g_bne[l_ac].bne11) THEN
            IF g_bne[l_ac].bne11 < 0 THEN
               CALL cl_err('','aim-391',0)
               NEXT FIELD bne11
            END IF
            IF cl_null(g_bne_o.bne11) OR
               (g_bne_o.bne11 != g_bne[l_ac].bne11) THEN
               LET g_bne[l_ac].bne08 = g_bne[l_ac].bne10 +
                                       g_bne[l_ac].bne11
               DISPLAY BY NAME g_bne[l_ac].bne08
            END IF
            LET g_bne_o.bne11 = g_bne[l_ac].bne11
         END IF
      {
      AFTER FIELD bne11
         IF g_bne[l_ac].bne08 = 0 THEN
            LET g_bne[l_ac].bne08 = g_bne[l_ac].bne10 + g_bne[l_ac].bne11
         END IF
      #-----No.FUN-5B0023 END-----
      }
      #FUN-6A0007...............end
 
        #No.FUN-840202 --start--
        AFTER FIELD bneud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bneud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bneud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bneud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bneud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bneud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bneud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bneud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bneud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bneud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bneud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bneud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bneud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bneud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bneud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
      BEFORE DELETE                            #是否取消單身
         IF g_bne_t.bne03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
 
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
 
            DELETE FROM bne_file
             WHERE bne01 = g_bnd.bnd01
               AND bne02 = g_bnd.bnd02
               AND bne03 = g_bne_t.bne03
               AND bne05 = g_bne_t.bne05
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bne_t.bne03,SQLCA.sqlcode,0)   #No.FUN-660052
               CALL cl_err3("del","bne_file",g_bnd.bnd01,g_bne_t.bne03,SQLCA.sqlcode,"","",1)
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
            LET g_bne[l_ac].* = g_bne_t.*
            CLOSE i030_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_bne[l_ac].bne03,-263,1)
            LET g_bne[l_ac].* = g_bne_t.*
         ELSE
            UPDATE bne_file SET bne03=g_bne[l_ac].bne03,
                                bne05=g_bne[l_ac].bne05,
                                bne06=g_bne[l_ac].bne06,
                                bne07=g_bne[l_ac].bne07,
                                bne08=g_bne[l_ac].bne08,
                                bne09=g_bne[l_ac].bne09,
                                bne10 = g_bne[l_ac].bne10,   #No.FUN-5B0023
                                bne11 = g_bne[l_ac].bne11    #No.FUN-5B0023
                                #FUN-840202 --start--
                               ,bneud01 = g_bne[l_ac].bneud01,
                                bneud02 = g_bne[l_ac].bneud02,
                                bneud03 = g_bne[l_ac].bneud03,
                                bneud04 = g_bne[l_ac].bneud04,
                                bneud05 = g_bne[l_ac].bneud05,
                                bneud06 = g_bne[l_ac].bneud06,
                                bneud07 = g_bne[l_ac].bneud07,
                                bneud08 = g_bne[l_ac].bneud08,
                                bneud09 = g_bne[l_ac].bneud09,
                                bneud10 = g_bne[l_ac].bneud10,
                                bneud11 = g_bne[l_ac].bneud11,
                                bneud12 = g_bne[l_ac].bneud12,
                                bneud13 = g_bne[l_ac].bneud13,
                                bneud14 = g_bne[l_ac].bneud14,
                                bneud15 = g_bne[l_ac].bneud15
                                #FUN-840202 --end-- 
             WHERE bne01 = g_bnd.bnd01
               AND bne02 = g_bnd.bnd02
               AND bne03 = g_bne_t.bne03
               AND bne05 = g_bne_t.bne05
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bne[l_ac].bne03,SQLCA.sqlcode,0) #No.FUN-660052
               CALL cl_err3("upd","bne_file",g_bnd.bnd01,g_bne_t.bne03,SQLCA.sqlcode,"","",1)
               LET g_bne[l_ac].* = g_bne_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_bne[l_ac].* = g_bne_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_bne.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE i030_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE i030_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bne05)
#              CALL q_ima(0,0,g_bne[l_ac].bne05) RETURNING g_bne[l_ac].bne05
#              CALL FGL_DIALOG_SETBUFFER( g_bne[l_ac].bne05 )
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
#            #   LET g_qryparam.form = "q_ima"     #TQC-990126
             #   LET g_qryparam.form = "q_ima991"     #TQC-990126
             #  LET g_qryparam.default1 = g_bne[l_ac].bne05
             #  CALL cl_create_qry() RETURNING g_bne[l_ac].bne05
              #CALL q_sel_ima(FALSE, "q_ima991", "",g_bne[l_ac].bne05, "", "", "", "" ,"",'' )  RETURNING g_bne[l_ac].bne05    #MOD-BA0145 mark
               CALL q_sel_ima(FALSE, "q_ima", "",g_bne[l_ac].bne05, "", "", "", "" ,"",'' )  RETURNING g_bne[l_ac].bne05       #MOD-BA0145
#FUN-AA0059 --End--
#              CALL FGL_DIALOG_SETBUFFER( g_bne[l_ac].bne05 )
               DISPLAY BY NAME g_bne[l_ac].bne05          #No.MOD-490371
               CALL i030_bne05('d')
               NEXT FIELD bne05
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(bne03) AND l_ac > 1 THEN
            LET g_bne[l_ac].* = g_bne[l_ac-1].*
            NEXT FIELD bne03
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
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
 
#No.FUN-6B0033 --START
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
#No.FUN-6B0033 --END
 
   END INPUT
 
   CLOSE i030_bcl
   COMMIT WORK
   
   CALL i030_delHeader()     #CHI-C30002 add 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION  i030_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM bnd_file WHERE bnd01 = g_bnd.bnd01
                                AND bnd02 = g_bnd.bnd02
         INITIALIZE g_bnd.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i030_b_askkey()
 DEFINE l_wc  STRING #No.FUN-680062 VARCHAR(600)
 
   CONSTRUCT l_wc ON bne03,bne05,bne06,bne07,bne10,bne11,
                     bne08,ima1916b,bne09   #No.FUN-5B0023
                    #No.FUN-840202 --start--
                    ,bneud01,bneud02,bneud03,bneud04,bneud05
                    ,bneud06,bneud07,bneud08,bneud09,bneud10
                    ,bneud11,bneud12,bneud13,bneud14,bneud15
                    #No.FUN-840202 ---end---
                FROM s_bne[1].bne03,s_bne[1].bne05,s_bne[1].bne06,
                     s_bne[1].bne07,s_bne[1].bne10,s_bne[1].bne11,   #No.FUN-5B0023
                     s_bne[1].bne08,s_bne[1].ima1916b,s_bne[1].bne09 #FUN-6A0007
                    #No.FUN-840202 --start--
                    ,s_bne[1].bneud01,s_bne[1].bneud02,s_bne[1].bneud03
                    ,s_bne[1].bneud04,s_bne[1].bneud05,s_bne[1].bneud06
                    ,s_bne[1].bneud07,s_bne[1].bneud08,s_bne[1].bneud09
                    ,s_bne[1].bneud10,s_bne[1].bneud11,s_bne[1].bneud12
                    ,s_bne[1].bneud13,s_bne[1].bneud14,s_bne[1].bneud15
                    #No.FUN-840202 ---end---
 
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
      RETURN
   END IF
 
   CALL cl_replace_str(l_wc,'ima1916a','a.ima1916') RETURNING l_wc #FUN-6A0007
   CALL i030_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION i030_b_fill(p_wc2)              #BODY FILL UP
 DEFINE p_wc2    STRING,                 #NO.FUN-680062 VARCHAR(300)
        l_factor LIKE type_file.num26_10,                #NO.FUN-680062 decimal(16,8)  
        l_tot    LIKE bmb_file.bmb06, #FUN-560227
        l_cnt    LIKE type_file.num5         #NO.FUN-680062    SMALLINT
 
   #FUN-6A0007...............begin
   LET g_sql = "SELECT bne03,bne05,ima02,ima021,bne06,bne07,bne10,bne11, ",
               "       bne08,ima1916,'','',bne09 ",   #No.FUN-5B0023
               #No.FUN-840202 --start--
               ",bneud01,bneud02,bneud03,bneud04,bneud05,",
               "bneud06,bneud07,bneud08,bneud09,bneud10,",
               "bneud11,bneud12,bneud13,bneud14,bneud15", 
               #No.FUN-840202 ---end---
               "  FROM bne_file,ima_file b",
               " WHERE bne01 = '",g_bnd.bnd01,"'",
               "   AND bne02 = '",g_bnd.bnd02,"'",
               "   AND bne05 = b.ima01 ",
               "   AND ", p_wc2 CLIPPED ,
               " ORDER BY bne03,bne09 DESC"
   #FUN-6A0007...............end
 
   PREPARE i030_pb FROM g_sql
   DECLARE bne_curs CURSOR FOR i030_pb
 
   CALL g_bne.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
 
   FOREACH bne_curs INTO g_bne[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #FUN-6A0007...............begin
      IF NOT cl_null(g_bne[g_cnt].ima1916b) THEN
         SELECT bxe02,bxe03 
           INTO g_bne[g_cnt].bxe02,g_bne[g_cnt].bxe03
           FROM bxe_file
          WHERE bxe01 = g_bne[g_cnt].ima1916b
      END IF
      #FUN-6A0007...............end
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_bne.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i030_bp(p_ud)
    DEFINE   p_ud  LIKE  type_file.chr1                     #NO.FUN-680062 VARCHAR(1)   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bne TO s_bne.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
         CALL i030_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i030_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i030_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i030_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i030_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      #FUN-6A0007...............begin
      ON ACTION abxp113
         LET g_action_choice="abxp113"
         EXIT DISPLAY
      #FUN-6A0007...............end
 
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
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      #FUN-6A0007...............begin
      ON ACTION abxp111_bom 
         LET g_action_choice = 'abxp111_bom'
         EXIT DISPLAY
      #FUN-6A0007...............end
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6A0046  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                        #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")    #No.FUN-6B0033
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
#FUN-6A0007...............begin
FUNCTION i030_ima1916a(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1
   DEFINE l_bxe02  LIKE bxe_file.bxe02,
          l_bxe03  LIKE bxe_file.bxe03,
          l_bxeacti LIKE bxe_file.bxeacti 
 
   LET g_errno = ' '
   SELECT bxe02,bxe03,bxeacti 
     INTO l_bxe02,l_bxe03,l_bxeacti
     FROM bxe_file
    WHERE bxe01 = g_ima1916
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg0002'
                                 LET l_bxe02 = NULL
                                 LET l_bxe03 = NULL
                                 LET l_bxeacti = NULL
        WHEN l_bxeacti = 'N'  LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   DISPLAY g_ima1916 TO ima1916a
   DISPLAY l_bxe02 TO bxe02h
   DISPLAY l_bxe03 TO bxe03h
 
END FUNCTION
 
FUNCTION i030_ima1916b(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1
   DEFINE l_bxe02  LIKE bxe_file.bxe02,
          l_bxe03  LIKE bxe_file.bxe03,
          l_bxeacti LIKE bxe_file.bxeacti 
 
   LET g_errno = ' '
   SELECT bxe02,bxe03,bxeacti 
     INTO l_bxe02,l_bxe03,l_bxeacti
     FROM bxe_file
    WHERE bxe01 = g_bne[l_ac].ima1916b
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg0002'
                                 LET l_bxe02 = NULL
                                 LET l_bxe03 = NULL
                                 LET l_bxeacti = NULL
        WHEN l_bxeacti = 'N'  LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   LET g_bne[l_ac].bxe02 =  l_bxe02
   LET g_bne[l_ac].bxe03 =  l_bxe03
   DISPLAY BY NAME g_bne[l_ac].bxe02,g_bne[l_ac].bxe03 
 
END FUNCTION
 
FUNCTION i030_ima1916_h()
 
  LET g_ima1916 = NULL
 
  SELECT ima1916 INTO g_ima1916
    FROM ima_file
   WHERE ima01 = g_bnd.bnd01
 
END FUNCTION
 
FUNCTION i030_ima1916_s()
 
  LET g_ima1916 = NULL
 
  SELECT ima1916 INTO g_bne[l_ac].ima1916b
    FROM ima_file
  WHERE ima01 = g_bne[l_ac].bne05
 
END FUNCTION
#FUN-6A0007...............end
 
FUNCTION i030_bnd01(p_cmd)  #主件料號
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,  #FUN-6A0007
          l_ima05   LIKE ima_file.ima05,
          l_ima08   LIKE ima_file.ima08,
          p_cmd  LIKE type_file.chr1               #NO.FUN-680062  VARCHAR(1) 
  #DEFINE l_ima15   LIKE ima_file.ima15    #TQC-990126   #MOD-BA0145 mark
    
   LET g_errno = ' '
   #FUN-6A0007...............begin
   #SELECT ima02,ima05,ima08
   #  INTO l_ima02,l_ima05,l_ima08
   #  FROM ima_file
   # WHERE ima01 = g_bnd.bnd01
  #MOD-BA0145 -- mark begin --
  #SELECT ima02,ima021,ima05,ima08,ima15                   #TQC-990126 add ima15   
  #  INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima15         #TQC-990126 add l_ima15   
  #MOD-BA0145 -- mark end --
   #MOD-BA0145 -- begin --
   SELECT ima02,ima021,ima05,ima08
     INTO l_ima02,l_ima021,l_ima05,l_ima08
   #MOD-BA0145 -- end --
     FROM ima_file
    WHERE ima01 = g_bnd.bnd01
   #FUN-6A0007...............end
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                  LET l_ima02 = NULL
                                  LET l_ima021= NULL #FUN-6A0007
                                  LET l_ima05 = NULL
                                  LET l_ima08 = NULL
                                 #LET l_ima15 = NULL        #TQC-990126    #MOD-BA0145 mark
       #WHEN l_ima15 IS NULL OR l_ima15  = 'N'              #TQC-990126    #MOD-BA0145 mark
       #                          LET g_errno = 'abx-009'   #TQC-990126    #MOD-BA0145 mark 
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   DISPLAY l_ima02 TO FORMONLY.ima02h
   DISPLAY l_ima021 TO FORMONLY.ima021h #FUN-6A0007
   DISPLAY l_ima05 TO FORMONLY.ima05
   DISPLAY l_ima08 TO FORMONLY.ima08
 
END FUNCTION
 
FUNCTION i030_bne05(p_cmd)  #元件料號
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021, #FUN-6A0007
          p_cmd     LIKE  type_file.chr1  #NO.FUN-680062  VARCHAR(1)           
  #DEFINE l_ima15   LIKE ima_file.ima15    #TQC-990126    #MOD-BA0145 mark
    
   LET g_errno = ' '
   #FUN-6A0007...............begin
   #SELECT ima02 INTO l_ima02
  #SELECT ima02,ima021,ima15 INTO l_ima02,l_ima021,l_ima15   #TQC-990126   #MOD-BA0145 mark
   #FUN-6A0007...............end
   SELECT ima02,ima021 INTO l_ima02,l_ima021                 #MOD-BA0145
     FROM ima_file
    WHERE ima01 = g_bne[l_ac].bne05
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                           LET l_ima02 = NULL
                           LET l_ima021 = NULL #FUN-6A0007
                          #LET l_ima15 = NULL   #TQC-990126         #MOD-BA0145 mark 
        #WHEN l_ima15 IS NULL OR l_ima15 = 'N'                      #MOD-BA0145 mark
        #                  LET g_errno = 'abx-009'    #TQC-990126   #MOD-BA0145 mark
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   LET g_bne[l_ac].ima02 = l_ima02
 
   #FUN-6A0007...............begin
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_bne[l_ac].ima021 = l_ima021
      DISPLAY BY NAME g_bne[l_ac].ima02,g_bne[l_ac].ima021
   END IF
   #FUN-6A0007...............end
END FUNCTION
 
FUNCTION i030_put()
DEFINE l_bne09   LIKE bne_file.bne09,  #有效否
       l_maxac  LIKE  type_file.num5,                         #NO.FUN-680062        smallint                      
       l_bmb02   LIKE bmb_file.bmb02,  #元件料號
       l_bmb03   LIKE bmb_file.bmb03,  #元件料號
       l_bmb04   LIKE bmb_file.bmb04,  #生效日期
       l_bmb05   LIKE bmb_file.bmb05,  #失效日期
       l_bmb06   LIKE bmb_file.bmb06,  #組成用量(QPA)
       l_bmb07   LIKE bmb_file.bmb07,  #No.FUN-5B0023
       l_bne08   LIKE bne_file.bne08   #No.FUN-5B0023
DEFINE l_ima1916 LIKE ima_file.ima1916 #FUN-6A0007
DEFINE l_bmb10_fac LIKE bmb_file.bmb10_fac   #CHI-B10023 add 「發料」對「料件庫存單位」換算率
 
   DECLARE i030_put CURSOR FOR SELECT bmb02,bmb03,bmb04,bmb05,(bmb06/bmb07)*bmb10_fac,               #CHI-B10023 add ( )*bmb10_fac
                                      ((bmb06/bmb07)*bmb08/100)*bmb10_fac   #No.FUN-5B0023           #CHI-B10023 add ( )*bmb10_fac
                                 FROM bmb_file
                                WHERE bmb01 = g_bnd.bnd01
                                ORDER BY bmb02,bmb03,bmb04,bmb05
 
  #SELECT MAX(bne02) + 1 INTO l_ac   #MOD-BB0037 mark
   SELECT MAX(bne03) + 1 INTO l_ac   #MOD-BB0037
     FROM bne_file
    WHERE bne01 = g_bnd.bnd01
 
   IF cl_null(l_ac) THEN
      LET l_ac = 1
   END IF
 
   LET g_success = "Y"
   BEGIN WORK
 
   FOREACH i030_put INTO l_bmb02,l_bmb03,l_bmb04,l_bmb05,l_bmb06,l_bmb07   #No.FUN-5B0023   
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         LET g_success = "N"
         EXIT FOREACH
      END IF
 
      IF (l_bmb04 IS NOT NULL AND l_bmb04 <> MDY(1,1,1999)) AND
         ((l_bmb04 IS NOT NULL AND g_bnd.bnd02 < l_bmb04) OR (l_bmb05 IS NOT NULL AND g_bnd.bnd02 > l_bmb05)) THEN
         CONTINUE FOREACH
      END IF
 
      IF l_bmb04 = MDY(1,1,1999) THEN
         LET l_bne09 = 'N'
      ELSE
         LET l_bne09 = 'Y'
      END IF
 
      LET l_bne08 = l_bmb06 + l_bmb07   #No.FUN-5B0023
 
      #FUN-6A0007...............begin
      LET l_ima1916 = NULL
      SELECT ima1916 INTO l_ima1916 
        FROM ima_file
       WHERE ima01 = l_bmb03
      #FUN-6A0007...............end
 
      INSERT INTO bne_file (bne01,bne02,bne03,bne05,bne06,bne07,  #No.MOD-470041
                            bne10,bne11,bne08,bne09)   #No.FUN-5B0023
                     VALUES(g_bnd.bnd01,g_bnd.bnd02,l_bmb02,l_bmb03,l_bmb04,
                            l_bmb05,l_bmb06,l_bmb07,l_bne08,l_bne09)   #No.FUN-5B0023
 
      IF NOT STATUS THEN
         LET l_ac = l_ac + 1
      ELSE
         LET g_success = "N"
         EXIT FOREACH
      END IF
   END FOREACH
 
   IF g_success = "Y" THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION i030_copy()
   DEFINE l_bnd             RECORD LIKE bnd_file.*,
          l_oldno,l_newno   LIKE bnd_file.bnd01,
          l_oldno1          LIKE bnd_file.bnd02,
          l_ima02           LIKE ima_file.ima02,
          l_ima021          LIKE ima_file.ima021,   #FUN-6A0007
          l_ima05           LIKE ima_file.ima05,
          l_ima08           LIKE ima_file.ima08
   DEFINE l_bni             RECORD LIKE bni_file.*  #FUN-6A0007
  #DEFINE l_ima15           LIKE ima_file.ima15     #TQC-990126   #MOD-BA0145 mark
 
   IF s_abxshut(0) THEN
      RETURN
   END IF
 
   IF g_bnd.bnd01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET l_bnd.* = g_bnd.*
   LET l_bnd.bnd02  =g_today
   DISPLAY l_bnd.bnd02 TO bnd02
   LET g_before_input_done = FALSE   #FUN-570158
   CALL i030_set_entry('a')          #FUN-570158
   LET g_before_input_done = TRUE    #FUN-570158
   CALL cl_set_head_visible("","YES")#No.FUN-6B0033
   INPUT l_newno,l_bnd.bnd02 FROM bnd01,bnd02
 
      AFTER FIELD bnd01
         IF NOT cl_null(l_newno) THEN
           #FUN-AA0059 --------------------------add start-----------------------------
            IF NOT s_chk_item_no(l_newno,'') THEN 
               CALL cl_err('',g_errno,1)
               NEXT FIELD bnd01
            END IF 
           #FUN-A0059 ---------------------------add end------------------------------ 
           #MOD-BA0145 -- mark begin --
           #SELECT ima02,ima021,ima05,ima08,ima15 
           #  INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima15 #FUN-6A0007 add ima021   
           #                                                #TQC-990126 add ima15 
           #MOD-BA0145 -- mark end --
            #MOD-BA0145 -- begin --
            SELECT ima02,ima021,ima05,ima08
              INTO l_ima02,l_ima021,l_ima05,l_ima08
            #MOD-BA0145 -- end --
              FROM ima_file WHERE ima01 = l_newno
            IF STATUS THEN
               LET l_ima02 = NULL
               LET l_ima021= NULL #FUN-6A0007
               LET l_ima05 = NULL
               LET l_ima08 = NULL
              #LET l_ima15 = NULL    #TQC-990126   #MOD-BA0145 mark
#              CALL cl_err(l_newno,'mfg0002',0)   #No.FUN-660052
               CALL cl_err3("sel","ima_file",l_newno,"","mfg0002","","",1)
               NEXT FIELD bnd01
            ELSE
#MOD-BA0145 -- mark begin --
##TQC-990126 --begin--
#               IF l_ima15 IS NULL OR l_ima15 = 'N' THEN 
#                  CALL cl_err('','abx-009',0)
#                  NEXT FIELD bnd01
#               ELSE
##TQC-990126 --end-- 
#MOD-BA0145 -- mark end --
               DISPLAY l_ima02 TO FORMONLY.ima02h
               DISPLAY l_ima021 TO FORMONLY.ima021h
               DISPLAY l_ima05 TO FORMONLY.ima05
               DISPLAY l_ima08 TO FORMONLY.ima08
            END IF
          #END IF   #TQC-990126   #MOD-BA0145 mark
 
            CALL i030_ima1916a('a')
            INITIALIZE l_bni.* TO NULL
            SELECT * INTO l_bni.* FROM bni_file
            LET g_bnd.bnd04 = l_bni.bni01 CLIPPED,
                              l_bni.bni02 CLIPPED,
                              l_bni.bni03 CLIPPED
           #MOD-BC0146 -- begin --
            LET l_bni.bni02 = l_bni.bni02 + 1 USING '&&&&' CLIPPED
            UPDATE bni_file SET bni02 = l_bni.bni02
           #MOD-BC0146 -- end --
            DISPLAY BY NAME g_bnd.bnd04
         END IF
 
      AFTER FIELD bnd02
         IF NOT cl_null(l_bnd.bnd02) THEN
            SELECT COUNT(*) INTO g_cnt FROM bnd_file
             WHERE bnd01 = l_newno
               AND bnd02 = l_bnd.bnd02
            IF g_cnt>0 THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD bnd01
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bnd01)
#              CALL q_ima(10,3,l_newno) RETURNING l_newno
#              CALL FGL_DIALOG_SETBUFFER( l_newno )
#FUN-AA0059 --Begin--
            #   CALL cl_init_qry_var()
#           #    LET g_qryparam.form ="q_ima"       #TQC-990126
            #    LET g_qryparam.form ="q_ima991"    #TQC-990126
            #   LET g_qryparam.default1 = l_newno
            #   CALL cl_create_qry() RETURNING l_newno
              #CALL q_sel_ima(FALSE, "q_ima991", "", l_newno, "", "", "", "" ,"",'' )  RETURNING l_newno   #MOD-BA0145 mark
               CALL q_sel_ima(FALSE, "q_ima", "", l_newno, "", "", "", "" ,"",'' )  RETURNING l_newno      #MOD-BA0145
#FUN-AA0059 --End-- 
#              CALL FGL_DIALOG_SETBUFFER( l_newno )
               DISPLAY l_newno TO bnd01
               NEXT FIELD bnd01
         END CASE
 
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY l_newno TO bnd01
      RETURN
   END IF
 
   LET l_bnd.bnd01  =l_newno   #新的鍵值
 
   INSERT INTO bnd_file VALUES (l_bnd.*)
   IF SQLCA.sqlcode THEN
#     CALL cl_err('bnd:',SQLCA.sqlcode,0)  #No.FUN-660052
      CALL cl_err3("ins","bnd_file",l_bnd.bnd01,l_bnd.bnd02,SQLCA.sqlcode,"","bnd:",1)
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM bne_file         #單身複製
    WHERE bne01=g_bnd.bnd01 AND bne02=g_bnd.bnd02
     INTO TEMP x
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_bnd.bnd01,SQLCA.sqlcode,0)  #No.FUN-660052
      CALL cl_err3("sel","bne_file",g_bnd.bnd01,g_bnd.bnd02,SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x SET bne01=l_newno,bne02=l_bnd.bnd02
 
   INSERT INTO bne_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
#     CALL cl_err('bne:',SQLCA.sqlcode,0)   #No.FUN-660052
      CALL cl_err3("ins","bne_file","","",SQLCA.sqlcode,"","bne:",1)
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_bnd.bnd01
   LET l_oldno1= g_bnd.bnd02
 
   SELECT bnd_file.* INTO g_bnd.* FROM bnd_file
    WHERE bnd01 = l_newno
      AND bnd02 = l_bnd.bnd02
 
   CALL i030_u()
   CALL i030_b()
   #FUN-C30027---begin
   #SELECT bnd_file.* INTO g_bnd.* FROM bnd_file
   # WHERE bnd01 = l_oldno
   #   AND bnd02 = l_oldno1
   #
   #CALL i030_show()
   #FUN-C30027---end
 
END FUNCTION
 
FUNCTION i030_set_entry(p_cmd)
    DEFINE p_cmd  LIKE type_file.chr1                          #NO.FUN-680062 VARCHAR(1)  
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("bnd01,bnd02",TRUE) #MOD-4B0075
   END IF
 
END FUNCTION
 
FUNCTION i030_set_no_entry(p_cmd)
    DEFINE p_cmd LIKE type_file.chr1                            #NO.FUN-680062  VARCHAR(1) 
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N'  THEN  #MOD-4B0075
       CALL cl_set_comp_entry("bnd01,bnd02",FALSE) #MOD-4B0075
   END IF
 
END FUNCTION
#Patch....NO.TQC-610035 <> #
