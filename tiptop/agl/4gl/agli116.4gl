# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli116.4gl
# Descriptions...: 報表結構資料維護作業
# Date & Author..: 92/02/15  BY MAY
# Modify ........: 92/07/27  BY Nora
# Modify ........: 97/05/29  By Melody 執行 T.generate, 應 check mai01 NOT NULL
# Modified By Thomas 99/01/12 用maj09紀錄加減項 (aglr100g)
# Modify.........: No.MOD-460190 04/09/13 By Nicola 會計名稱開窗帶回會計名稱
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0048 04/12/08 By Nicola 權限控管修改
# Modify.........: No.FUN-510007 05/02/16 By Nicola 報表架構修改
# Modify.........: No.MOD-510153 05/03/21 By Nicola "產生"時，maj11預設為'N"產生"時，maj11預設為'N''
# Modify.........: No.FUN-570087 05/07/11 By will  新增公式維護 maj26,maj27,maj28
# Modify.........: No.FUN-580026 05/08/10 By Sarah 在複製裡增加set_entry段
# Modify.........: No.MOD-590002 05/09/12 By will 報表格式對齊
# Modify.........: No.FUN-590122 05/09/29 By Smapmin 額外說明從CHAR(30)放大到CHAR(50)
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: NO.FUN-630090 06/03/28 By Ray 新增金額來源的類型  4.科目借方之當期異動  5.科目貸方之當期異動
#                                06/04/11 By day 新增金額來源的類型  6.科目期初之借方 7.科目期初之貸方 8.科目期末之借方 9.科目期末之貸方
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.MOD-460192 06/06/09 By rainy 把maj23拆掉分成兩個欄位處理,只在畫面上區分為二個欄位,資料庫中依然為一個欄位
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6C0012 07/01/04 By Elva 額外說明可用ex:.1101方式帶出
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 新增action 使用者設限及部門設限
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730020 07/03/30 By Carrier 會計科目加帳套
# Modify.........: No.TQC-740332 07/04/30 By bnlent  顯示無效資料打印標示
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760085 07/08/02 By sherry  報表改由Crystal Report輸出
# Modify.........: No.MOD-840631 08/04/30 By Smapmin 修改程式段位置
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-950006 09/05/05 By wujie   無效資料不能刪除
# Modify.........: No.TQC-960117 09/06/11 By xiaofeizhu "截止科目"欄位應不允許錄入統制科目
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0021 09/11/05 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A70035 10/07/07 By Carrier construct时加oriu/orig
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.MOD-B30629 11/03/21 by Dido 科目開窗調整 
# Modify.........: No.MOD-B40063 11/04/12 by Dido XBRL 格式需求應可輸入統制科目 
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B60157 11/06/30 by belle 新增maj_file科目，以供IFRS 調節表對應科目使用
# Modify.........: No.MOD-B60266 11/06/30 by wujie maj22的检查移除
# Modify.........: No.FUN-B70009 11/07/05 by belle 增加報表差異調節表(IFRS)-B/S與I/S 
# Modify.........: No.FUN-B60077 11/07/14 by belle 增加XBRL科目
# Modify.........: No.FUN-B80138 11/08/22 by belle XBRL控制不必輸
# Modify.........: No.FUN-BC0120 12/01/17 by lori 報表性質為5/6 IFRS 1開帳調節表者,依aooi120會科對應關係產生對應資料
# Modify.........: No.TQC-BC0092 12/01/17 by lori XBRL(maj31)開窗不控卡aag07(1/2/3);AFTER FIELE不用驗證輸入科目是否存在aag_file
# Modify.........: No.CHI-C20023 12/03/12 By lori 增加tag06(使用時點)的判斷 
# Modify.........: No.TQC-C40190 12/04/20 By yinhy maj20開窗應返回科目編號
# Modify.........: No.MOD-C40164 12/04/20 By Elise 更改 單身"科目名稱"開窗挑選， 帶出的是"科目代號"
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.TQC-C50240 12/05/29 By lujh maj20欄位“科目名稱”，開窗挑選確認後，窗口直接down出
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-CA0097 12/10/16 By zhangweib agli116 金额来源增加四种取值方式(大陸版)
#                                                              a(当期子系统发生额之借减贷),b(当期子系统发生额之贷减借)
#                                                              c(当期核算项发生额之借减贷),d(当期核算项发生额之贷减借)
# Modify.........: No.MOD-CB0105 12/11/12 By Polly 調整單身無法自動帶出舊帳別資訊
# Modify.........: No:CHI-C80041 12/11/29 By bart 刪除單頭時，一併刪除相關table
# Modify.........: No:TQC-D10003 13/01/04 By zhangweib 起始科目(maj21)、截至科目(maj22)只能輸入明細、獨立科目
#                                                      FUNCTION i116_t()組出來的SQL,WHERE條件應加上aag07 IN ('2','3')
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D40104 13/04/16 by apo 在判斷aag07的時候，增加帳別欄位作為條件

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_mai           RECORD LIKE mai_file.*,       #報表編號 (假單頭)
    g_mai_t         RECORD LIKE mai_file.*,       #報表編號 (舊值)
    g_mai_o         RECORD LIKE mai_file.*,       #報表編號 (舊值)
    g_mai01_t       LIKE mai_file.mai01,   #報表編號 (舊值)
    g_mai00_t       LIKE mai_file.mai00,   #報表編號 (舊值)  #No.FUN-730020
    g_mai04_t       LIKE mai_file.mai04,   #報表編號 (舊值)  #No.FUN-B70009
    g_maj           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        maj02       LIKE maj_file.maj02,   # 項次
        maj03       LIKE maj_file.maj03,   #列印碼
        maj09       LIKE maj_file.maj09,   #
        maj06       LIKE maj_file.maj06,   #來源
        maj04       LIKE maj_file.maj04,   #空行數
        maj05       LIKE maj_file.maj05,   #空格數
        maj07       LIKE maj_file.maj07,   #餘額型態 (1.借餘/2.貸餘)
        maj26       LIKE maj_file.maj26,   #No.FUN-570087
        maj20       LIKE maj_file.maj20,   #Name
        maj20e      LIKE maj_file.maj20e,  #Name(Extra)
        maj31       LIKE maj_file.maj31,   # XBRL
        maj21       LIKE maj_file.maj21,   # From Acct code
        maj22       LIKE maj_file.maj22,   #  To  Acct code
        maj24       LIKE maj_file.maj24,   # From Dept code
        maj25       LIKE maj_file.maj25,   #  To  Dept code
        maj11       LIKE maj_file.maj11,   #百分比基準科目
        maj08       LIKE maj_file.maj08,   #合計階數
       #maj23       LIKE maj_file.maj23,   # 1.B/S  2.I/S #No.MOD-460192 remark
        maj23a      LIKE type_file.chr1,   # 1.B/S   #MOD-460192 add    #No.FUN-680098   VARCHAR(1)
        maj23b      LIKE type_file.chr1,   # 2.I/S   #MOD-460192 add    #No.FUN-680098   VARCHAR(1)
#No.FUN-570087--begin
        maj27       LIKE maj_file.maj27,
        maj28       LIKE maj_file.maj28,
#No.FUN-570087--end
#FUN-B60157---begin
        maj32       LIKE maj_file.maj32,
        maj33       LIKE maj_file.maj33,
        maj34       LIKE maj_file.maj34,
        maj35       LIKE maj_file.maj35
#FUN-B60157---end
                    END RECORD,
    g_maj_t         RECORD    #程式變數(Program Variables)
        maj02       LIKE maj_file.maj02,   # 項次
        maj03       LIKE maj_file.maj03,   #列印碼
        maj09       LIKE maj_file.maj09,   #列印碼
        maj06       LIKE maj_file.maj06,   #來源
        maj04       LIKE maj_file.maj04,   #空行數
        maj05       LIKE maj_file.maj05,   #空格數
        maj07       LIKE maj_file.maj07,   #餘額型態 (1.借餘/2.貸餘)
        maj26       LIKE maj_file.maj26,   #No.FUN-570087
        maj20       LIKE maj_file.maj20,   #Name
        maj20e      LIKE maj_file.maj20e,  #Name(Extra)
        maj31       LIKE maj_file.maj31,   # XBRL
        maj21       LIKE maj_file.maj21,   # From Acct code
        maj22       LIKE maj_file.maj22,   #  To  Acct code
        maj24       LIKE maj_file.maj24,   # From Dept code
        maj25       LIKE maj_file.maj25,   #  To  Dept code
        maj11       LIKE maj_file.maj11,   #百分比基準科目
        maj08       LIKE maj_file.maj08,   #合計階數
       #maj23       LIKE maj_file.maj23,   # 1.B/S  2.I/S #No.MOD-460192 remark
        maj23a      LIKE type_file.chr1,   # 1.B/S   #MOD-460192 add     #No.FUN-680098  VARCHAR(1) 
        maj23b      LIKE type_file.chr1,   # 2.I/S   #MOD-460192 add     #No.FUN-680098  VARCHAR(1) 
#No.FUN-570087--begin
        maj27       LIKE maj_file.maj27,
        maj28       LIKE maj_file.maj28,
#No.FUN-570087--end
#FUN-B60157---begin
        maj32       LIKE maj_file.maj32,
        maj33       LIKE maj_file.maj33,
        maj34       LIKE maj_file.maj34,
        maj35       LIKE maj_file.maj35
#FUN-B60157---end
                    END RECORD,
     g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN   
    t_sql1,t_sql2,t_sql3,t_sql4,t_sql5,t_sql6   LIKE type_file.chr1000,  #No.FUN-680098   VARCHAR(70)
    g_str           LIKE type_file.chr1,                                 #No.FUN-680098   VARCHAR(1)
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680098   SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT   #No.FUN-680098 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL    
DEFINE g_before_input_done  LIKE type_file.num5       #No.FUN-680098  SMALLINT
#DEFINE cb                   ui.Combobox            #NO.FUN-CA0097  Add
 
#主程式開始
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   g_i             LIKE type_file.num5           #count/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680098 SMALLINT
DEFINE   l_str           STRING                       #No.FUN-760085 
MAIN
DEFINE
#       l_time   LIKE type_file.chr8            #No.FUN-6A0073
   p_row,p_col   LIKE type_file.num5                  #No.FUN-680098         SMALLINT
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET p_row = 2 LET p_col = 2
 
   OPEN WINDOW i116_w AT p_row,p_col
     WITH FORM "agl/42f/agli116"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
#No.FUN-570087--begin
   IF g_aza.aza26 MATCHES '[01]' THEN
      CALL cl_set_comp_visible("maj26,maj27,maj28",FALSE)
   END IF
#No.FUN-570087--end
#NO.FUN-CA0097   ---start--- Add
#  IF g_aza.aza26 != '2' THEN
#     LET cb = ui.ComboBox.forName("maj06")
#     CALL cb.removeItem('a')
#     CALL cb.removeItem('b')
#     CALL cb.removeItem('c')
#     CALL cb.removeItem('d')
#  END IF
#NO.FUN-CA0097   ---end  --- Add
#No.FUN-B70009---begin
   IF cl_null(g_mai.mai03) THEN
      CALL cl_set_comp_visible("mai04,maj32,maj33,maj34,maj35",FALSE)
   END IF
#No.FUN-B70009--end
   LET g_forupd_sql = "SELECT * FROM mai_file WHERE mai01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i116_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   CALL i116_menu()
   CLOSE WINDOW i116_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION i116_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE  l_maj23         LIKE maj_file.maj23  #MOD-460192
DEFINE  g_mai03         LIKE mai_file.mai03  #FUN-B70009
 
    CLEAR FORM                             #清除畫面
    CALL g_maj.clear()
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0029 
 
   INITIALIZE g_mai.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON              # 螢幕上取單頭條件
       #mai01,mai02,mai00,mai03, maiuser,maigrup,      #FUN-B70009 mark
        mai01,mai02,mai00,mai03,mai04,maiuser,maigrup, #FUN-B70009 add
        maioriu,maiorig,         #No.TQC-A70035
        maimodu,maidate,maiacti  #No.FUN-730020
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN

         #FUN-B70009--begin--
         AFTER FIELD mai03
            CALL GET_FLDBUF(mai03) RETURNING g_mai03
            IF g_mai03 MATCHES '[1-4]' THEN
               CALL cl_set_comp_visible("mai04,maj32,maj33,maj34,maj35",FALSE)
            END IF
            IF g_mai03 MATCHES '[5-6]' THEN
               CALL cl_set_comp_visible("mai04,maj32,maj33,maj34,maj35",TRUE)
            END IF

         #FUN-B70009---end---

         #No.FUN-730020  --Begin
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(mai00)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aaa"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO mai00  

               WHEN INFIELD(mai04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aaa"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO mai04  

               OTHERWISE
                  EXIT CASE
            END CASE
         #No.FUN-730020  --End  
 
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
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #       LET g_wc = g_wc clipped," AND maiuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #       LET g_wc = g_wc clipped," AND maigrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #       LET g_wc = g_wc clipped," AND maigrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('maiuser', 'maigrup')
    #End:FUN-980030
 
 
    CONSTRUCT g_wc2 ON maj02,maj03,maj09,maj06,maj04,maj05,maj07,maj26,maj20,maj20e,
                      #maj21,maj22,maj24,maj25,maj11,maj08,maj23,maj27,maj28   #No.FUN-570087 -add maj26,27,28
                      #maj21,maj22,maj24,maj25,maj11,maj08,maj27,maj28,        #No.FUN-B60077 modify #No.FUN-570087 -add maj26,27,28 #MOD-460192 拿掉maj23
                       maj31,maj21,maj22,maj24,maj25,maj11,maj08,maj27,maj28,  #NO.FUN-B60077 -add maj31   
                       maj32,maj33,maj34,maj35                                 #No.FUN-B60157 -add maj32~35
            FROM s_maj[1].maj02,s_maj[1].maj03,s_maj[1].maj09,
                 s_maj[1].maj06,s_maj[1].maj04,s_maj[1].maj05,
                 s_maj[1].maj07,s_maj[1].maj26,s_maj[1].maj20,s_maj[1].maj20e,
                #s_maj[1].maj21,s_maj[1].maj22,                 #FUN-B60077 mark
                 s_maj[1].maj31,s_maj[1].maj21,s_maj[1].maj22,  #FUN-B60077 add -maj31
                 s_maj[1].maj24,s_maj[1].maj25,
                 #s_maj[1].maj11,s_maj[1].maj08,s_maj[1].maj23,
                 s_maj[1].maj11,s_maj[1].maj08,                               #MOD-460192 拿掉maj23
                 s_maj[1].maj27,s_maj[1].maj28,                               #No.FUN-570087  -add maj26,27,28
                 s_maj[1].maj32,s_maj[1].maj33,s_maj[1].maj34,s_maj[1].maj35  #No.FUN-B60157
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    ON ACTION controlp
       CASE
          WHEN INFIELD(maj20)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             #LET g_qryparam.form ="q_aag"     #No:MOD-460190 #MOD-B30629 mod q_aag01 -> q_aag
            #LET g_qryparam.form ="q_aag01"    #TQC-C40190  #MOD-C40164 mark
             #LET g_qryparam.form ="q_aag_r"   #MOD-C40164 ->q_aag_r    #TQC-C50240  mark
             LET g_qryparam.form ="q_aag_r_1"  #TQC-C50240  add
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO maj20
          WHEN INFIELD(maj21)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aag"     #MOD-B30629 mod q_aag -> q_aag01 #MOD-B40063 remod
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO maj21
          WHEN INFIELD(maj22)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aag"     #MOD-B30629 mod q_aag -> q_aag01 #MOD-B40063 remod
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO maj22
          WHEN INFIELD(maj24)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_gem"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO maj24
          WHEN INFIELD(maj25)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_gem"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO maj25
         #FUN-B60077--begin--
         WHEN INFIELD(maj31)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_aag"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO maj31
         #FUN-B60077---end---
         #FUN-B60157---begin---
          WHEN INFIELD(maj32)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aag"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO maj32
          WHEN INFIELD(maj34)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aag"     #MOD-B30629 mod q_aag -> q_aag01 #MOD-B40063 remod
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO maj34
          WHEN INFIELD(maj35)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aag"     #MOD-B30629 mod q_aag -> q_aag01 #MOD-B40063 remod
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO maj35
          #FUN-B60157----end----
          OTHERWISE
             EXIT CASE
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
 
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN   # 若單身未輸入條件
       LET g_sql = "SELECT  mai01 FROM mai_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY mai01"
     ELSE     # 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT  mai01 ",
                   "  FROM mai_file, maj_file ",
                   " WHERE mai01 = maj01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY mai01"
    END IF
 
    PREPARE i116_prepare FROM g_sql
    DECLARE i116_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i116_prepare
 
    IF g_wc2 = " 1=1" THEN   # 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM mai_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT mai01) FROM mai_file,maj_file WHERE ",
                  "maj01=mai01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i116_precount FROM g_sql
    DECLARE i116_count CURSOR FOR i116_precount
END FUNCTION
 
FUNCTION i116_menu()
 
   WHILE TRUE
      CALL i116_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i116_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i116_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i116_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i116_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i116_x()
               CALL cl_set_field_pic("","","","","",g_mai.maiacti)
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i116_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i116_b('u')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL i116_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "generate"
            IF cl_chk_act_auth() THEN
               CALL i116_t()
            END IF
         WHEN "re_sort"
            IF cl_chk_act_auth() THEN
               CALL i116_g()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_mai.mai01 IS NOT NULL THEN
                  LET g_doc.column1 = "mai01"
                  LET g_doc.value1 = g_mai.mai01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_maj),'','')
            END IF
    #FUN-6C0068--begin
         WHEN "authorization"    #使用者設限
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_mai.mai01) THEN
                 CALL s_smu(g_mai.mai01,"RGL")  
                 LET g_msg = s_smu_d(g_mai.mai01,"RGL") 
                 DISPLAY g_msg TO smu02_display
              END IF
           END IF
 
         WHEN "dept_authorization"
            IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_mai.mai01) THEN
                CALL s_smv(g_mai.mai01,"RGL")  
                LET g_msg = s_smv_d(g_mai.mai01,"RGL")   
                DISPLAY g_msg TO smv02_display
              END IF
            END IF
    #FUN-6C0068--end
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i116_a()
   IF s_aglshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
    CALL g_maj.clear()
   INITIALIZE g_mai.* LIKE mai_file.*             #DEFAULT 設定
   LET g_mai01_t = NULL
   LET g_mai00_t = NULL  #No.FUN-730020
   LET g_mai04_t = NULL  #No.FUN-B70009
   #預設值及將數值類變數清成零
   LET g_mai_o.* = g_mai.*
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_mai.maiuser=g_user
      LET g_mai.maioriu = g_user #FUN-980030
      LET g_mai.maiorig = g_grup #FUN-980030
      LET g_mai.maigrup=g_grup
      LET g_mai.maidate=g_today
      LET g_mai.maiacti='Y'              #資料有效
      CALL i116_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_mai.mai01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      INSERT INTO mai_file VALUES (g_mai.*)
      IF SQLCA.sqlcode THEN      #置入資料庫不成功
#        CALL cl_err(g_mai.mai01,SQLCA.sqlcode,1)   #No.FUN-660123
         CALL cl_err3("ins","mai_file",g_mai.mai01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
         CONTINUE WHILE
      END IF
      LET g_mai_t.* = g_mai.*
      SELECT mai01 INTO g_mai.mai01 FROM mai_file
       WHERE mai01 = g_mai.mai01
      CALL g_maj.clear()
      LET g_rec_b = 0
      CALL i116_b('a')                   #輸入單身
      LET g_mai01_t = g_mai.mai01        #保留舊值
      LET g_mai00_t = g_mai.mai00        #保留舊值  #No.FUN-730020
      LET g_mai04_t = g_mai.mai04        #保留舊值  #No.FUN-730020
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i116_u()
   IF s_aglshut(0) THEN RETURN END IF
   IF g_mai.mai01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_mai.* FROM mai_file WHERE mai01=g_mai.mai01
   IF g_mai.maiacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_mai.mai01,9027,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_mai01_t = g_mai.mai01
   LET g_mai00_t = g_mai.mai00
   LET g_mai04_t = g_mai.mai04
   LET g_mai_o.* = g_mai.*
   BEGIN WORK
   OPEN i116_cl USING g_mai.mai01
   FETCH i116_cl INTO g_mai.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mai.mai01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i116_cl ROLLBACK WORK RETURN
   END IF
   CALL i116_show()
   WHILE TRUE
      LET g_mai01_t = g_mai.mai01
      LET g_mai.maimodu=g_user
      LET g_mai.maidate=g_today
      CALL i116_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_mai.*=g_mai_t.*
         CALL i116_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_mai.mai01 != g_mai01_t THEN            # 更改單號
         UPDATE maj_file SET maj01 = g_mai.mai01
          WHERE maj01 = g_mai01_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err('maj',SQLCA.sqlcode,0)  #No.FUN-660123
            CALL cl_err3("upd","maj_file",g_mai01_t,"",SQLCA.sqlcode,"","maj",1)  #No.FUN-660123
            CONTINUE WHILE
         END IF
      END IF
      UPDATE mai_file SET mai_file.* = g_mai.*
       WHERE mai01 = g_mai01_t
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_mai.mai01,SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("upd","mai_file",g_mai01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i116_cl
   COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i116_i(p_cmd)
DEFINE
   l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-680098 VARCHAR(1)
   l_aaaacti       LIKE aaa_file.aaaacti,  #No.FUN-730020
   p_cmd           LIKE type_file.chr1     #a:輸入 u:更改           #No.FUN-680098 VARCHAR(1)
 
   DISPLAY BY NAME g_mai.maiuser,g_mai.maimodu,
       g_mai.maigrup,g_mai.maidate,g_mai.maiacti
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0029 
 
  #INPUT BY NAME g_mai.maioriu,g_mai.maiorig,g_mai.mai01,g_mai.mai02,g_mai.mai00,g_mai.mai03 WITHOUT DEFAULTS  #FUN-B70009 #No.FUN-730020
   INPUT BY NAME g_mai.maioriu,g_mai.maiorig,g_mai.mai01,g_mai.mai02,g_mai.mai00,g_mai.mai03,g_mai.mai04 WITHOUT DEFAULTS  #No.FUN-B70009
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i116_set_entry(p_cmd)
         CALL i116_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD mai01                  #報表編號
         IF NOT cl_null(g_mai.mai01) THEN
            IF g_mai.mai01 != g_mai01_t OR g_mai01_t IS NULL THEN
               SELECT count(*) INTO g_cnt FROM mai_file
               WHERE mai01 = g_mai.mai01
               IF g_cnt > 0 THEN   #資料重複
                  CALL cl_err(g_mai.mai01,-239,0)
                  LET g_mai.mai01 = g_mai01_t
                  DISPLAY BY NAME g_mai.mai01
                  NEXT FIELD mai01
               END IF
            END IF
         END IF
 
      #No.FUN-730020  --Begin
      AFTER FIELD mai00
         IF NOT cl_null(g_mai.mai00) THEN                                      
            SELECT aaaacti INTO l_aaaacti FROM aaa_file                          
             WHERE aaa01=g_mai.mai00                                           
            IF SQLCA.SQLCODE=100 THEN                                            
               CALL cl_err3("sel","aaa_file",g_mai.mai00,"",100,"","",1)            
               NEXT FIELD mai00                                                 
            END IF                                                               
            IF l_aaaacti='N' THEN                                                
               CALL cl_err(g_mai.mai00,"9028",1)                                    
               NEXT FIELD mai00                                                 
            END IF                                                               
         END IF
         IF g_mai.mai00 != g_mai00_t THEN
            CALL cl_err(g_mai.mai00,'agl-502',1)
         END IF
      #No.FUN-730020  --End  
 

      #No.FUN-B70009  --Begin
      AFTER FIELD mai04
         IF NOT cl_null(g_mai.mai04) THEN
            SELECT aaaacti INTO l_aaaacti FROM aaa_file
             WHERE aaa01=g_mai.mai04
            IF SQLCA.SQLCODE=100 THEN
               CALL cl_err3("sel","aaa_file",g_mai.mai04,"",100,"","",1)
               NEXT FIELD mai04
            END IF
            IF l_aaaacti='N' THEN
               CALL cl_err(g_mai.mai04,"9028",1)
               NEXT FIELD mai04
            END IF
         END IF
         IF g_mai.mai04 != g_mai04_t THEN
            CALL cl_err(g_mai.mai04,'agl-502',1)
         END IF
      #No.FUN-B70009  --End
      AFTER FIELD mai03
         IF NOT cl_null(g_mai.mai03) THEN
           #IF g_mai.mai03 NOT MATCHES '[1-4]' THEN   #No.FUN-B70009
            IF g_mai.mai03 NOT MATCHES '[1-6]' THEN   #No.FUN-B70009
               NEXT FIELD mai03
            END IF
         END IF

     #FUN-B70009--begin--
      ON CHANGE mai03
         IF g_mai.mai03 MATCHES '[1-4]' THEN
            CALL cl_set_comp_visible("mai04,maj32,maj33,maj34,maj35",FALSE)
            LET g_mai.mai04 = ''
         END IF
         IF g_mai.mai03 MATCHES '[5-6]' THEN
            CALL cl_set_comp_visible("mai04,maj32,maj33,maj34,maj35",TRUE)
         END IF
     #FUN-B70009---end---

      #No.FUN-730020  --Begin
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(mai00)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.default1 = g_mai.mai00
               CALL cl_create_qry() RETURNING g_mai.mai00
               DISPLAY BY NAME g_mai.mai00
               NEXT FIELD mai00  

            WHEN INFIELD(mai04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.default1 = g_mai.mai04
               CALL cl_create_qry() RETURNING g_mai.mai04
               DISPLAY BY NAME g_mai.mai04
               NEXT FIELD mai04
            OTHERWISE
               EXIT CASE
         END CASE
      #No.FUN-730020  --End  
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
     #MOD-650015 --start 
    # ON ACTION CONTROLO                        # 沿用所有欄位
    #    IF INFIELD(mai01) THEN
    #       LET g_mai.* = g_mai_t.*
    #       DISPLAY BY NAME g_mai.*
    #       NEXT FIELD mai01
    #    END IF
    #MOD-650015 --end
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
   END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i116_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_mai.* TO NULL               #No.FUN-6B0040
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_maj.clear()
   DISPLAY '   ' TO FORMONLY.cnt
#No.FUN-B70009---begin
   IF cl_null(g_mai.mai03) THEN
      CALL cl_set_comp_visible("mai04,maj32,maj33,maj34,maj35",FALSE)
   END IF
#No.FUN-B70009--end
   CALL i116_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i116_cs                             #從DBgenerate合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_mai.* TO NULL
   ELSE
      OPEN i116_count
      FETCH i116_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i116_fetch('F')                  #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i116_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,    #處理方式          #No.FUN-680098 VARCHAR(1)
   l_abso          LIKE type_file.num10    #絕對的筆數        #No.FUN-680098 INTEGER
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i116_cs INTO g_mai.mai01
      WHEN 'P' FETCH PREVIOUS i116_cs INTO g_mai.mai01
      WHEN 'F' FETCH FIRST    i116_cs INTO g_mai.mai01
      WHEN 'L' FETCH LAST     i116_cs INTO g_mai.mai01
      WHEN '/'
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
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
         FETCH ABSOLUTE g_jump i116_cs INTO g_mai.mai01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mai.mai01,SQLCA.sqlcode,0)
      INITIALIZE g_mai.* TO NULL  #TQC-6B0105
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
   SELECT * INTO g_mai.* FROM mai_file WHERE mai01 = g_mai.mai01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_mai.mai01,SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","mai_file",g_mai.mai01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
      INITIALIZE g_mai.* TO NULL
      RETURN
   ELSE
      LET g_data_owner = g_mai.maiuser     #No.FUN-4C0048
      LET g_data_group = g_mai.maigrup     #No.FUN-4C0048
      CALL i116_show()
   END IF
 
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i116_show()
   LET g_mai_t.* = g_mai.*                #保存單頭舊值
   DISPLAY BY NAME g_mai.maioriu,g_mai.maiorig,                              # 顯示單頭值
       g_mai.mai01,g_mai.mai02,g_mai.mai03,g_mai.mai00,   #No.FUN-730020
       g_mai.mai04,                                       #No.FUN-B70009
       g_mai.maiuser,g_mai.maigrup,g_mai.maimodu,
       g_mai.maidate,g_mai.maiacti
 
   LET g_msg = s_smu_d(g_mai.mai01,"RGL")  
   DISPLAY g_msg TO smu02_display
   LET g_msg = s_smv_d(g_mai.mai01,"RGL")             
   DISPLAY g_msg TO smv02_display
   #FUN-B70009--begin--
   IF g_mai.mai03 MATCHES '[1-4]' THEN
      CALL cl_set_comp_visible("mai04,maj32,maj33,maj34,maj35",FALSE)
   END IF
   IF g_mai.mai03 MATCHES '[5-6]' THEN
      CALL cl_set_comp_visible("mai04,maj32,maj33,maj34,maj35",TRUE)
   END IF
   #FUN-B70009---end---
   CALL i116_b_fill(g_wc2)                 #單身
   CALL cl_set_field_pic("","","","","",g_mai.maiacti)
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i116_x()
   IF s_aglshut(0) THEN RETURN END IF
   IF g_mai.mai01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   BEGIN WORK
   OPEN i116_cl USING g_mai.mai01
   FETCH i116_cl INTO g_mai.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mai.mai01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i116_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL i116_show()
   IF cl_exp(0,0,g_mai.maiacti) THEN           #確認一下
      LET g_chr=g_mai.maiacti
      IF g_mai.maiacti='Y' THEN
         LET g_mai.maiacti='N'
      ELSE
         LET g_mai.maiacti='Y'
      END IF
      UPDATE mai_file                    #更改有效碼
         SET maiacti=g_mai.maiacti
       WHERE mai01=g_mai.mai01
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err(g_mai.mai01,SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("upd","mai_file",g_mai.mai01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
         LET g_mai.maiacti=g_chr
      END IF
      DISPLAY BY NAME g_mai.maiacti
   END IF
   CLOSE i116_cl
   COMMIT WORK
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i116_r()
   IF s_aglshut(0) THEN RETURN END IF
   IF g_mai.mai01 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
   END IF
#No.TQC-950006 --begin                                                          
   IF g_mai.maiacti = 'N' THEN                                                  
      CALL cl_err('','abm-950',0)                                               
      RETURN                                                                    
   END IF                                                                       
#No.TQC-950006 --end 
   BEGIN WORK
   OPEN i116_cl USING g_mai.mai01
   FETCH i116_cl INTO g_mai.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mai.mai01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i116_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL i116_show()
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "mai01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_mai.mai01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM mai_file WHERE mai01 = g_mai.mai01
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err(g_mai.mai01,SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("del","mai_file",g_mai.mai01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
      END IF
      DELETE FROM maj_file WHERE maj01 = g_mai.mai01
      CLEAR FORM
      CALL g_maj.clear()
      OPEN i116_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE i116_cs
         CLOSE i116_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--

      FETCH i116_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i116_cs
         CLOSE i116_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i116_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i116_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i116_fetch('/')
      END IF
    #FUN-6C0068--begin
      DELETE FROM smv_file WHERE smv01 = g_mai.mai01 AND upper(smv03)='RGL'
      IF SQLCA.SQLCODE THEN
        CALL cl_err('smv_file',SQLCA.sqlcode,0)
      END IF
      DELETE FROM smu_file WHERE smu01 = g_mai.mai01 AND upper(smu03)='RGL'
      IF SQLCA.SQLCODE THEN
        CALL cl_err('smu_file',SQLCA.sqlcode,0)
      END IF
    #FUN-6C0068--end
   END IF
   CLOSE i116_cl
   COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i116_b(p_key)
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680098 SMALLINT
   p_key           LIKE type_file.chr1,                #為確定是在新增或更新態,  #No.FUN-680098 VARCHAR(1)  
                                          #以判斷是否可建立第150~200筆的資料
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680098 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680098 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680098 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680098 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680098 SMALLINT
 
DEFINE   l_maj23   LIKE  maj_file.maj23   #MOD-460192 add
DEFINE   l_aag07   LIKE aag_file.aag07    #No.TQC-D10003
  
   LET g_action_choice = ""
   IF s_aglshut(0) THEN RETURN END IF
   IF g_mai.mai01 IS NULL THEN
      RETURN
   END IF
   SELECT * INTO g_mai.* FROM mai_file WHERE mai01=g_mai.mai01
   IF g_mai.maiacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_mai.mai01,'aom-000',0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = " SELECT maj02,maj03,maj09,maj06,maj04,maj05,maj07,maj26,",
                     #"        maj20,maj20e,maj21,maj22,maj24,maj25,maj11,maj08,substring(maj23,1,1) maj23a,substring(maj23,2,1) maj23b,maj27,maj28,", #MOD-460192 將maj23 拆成23a 23b  #No.TQC-9B0021
                     #"        maj20,maj20e,maj21,maj22,maj24,maj25,maj11,maj08,maj23[1,1] maj23a,maj23[2,2] maj23b,maj27,maj28,",         #FUN-B60077 mark #MOD-460192 將maj23 拆成23a 23b  #No.TQC-9B0021
                      "        maj20,maj20e,maj31,maj21,maj22,maj24,maj25,maj11,maj08,maj23[1,1] maj23a,maj23[2,2] maj23b,maj27,maj28,",   #FUN-B60077 add  -maj31 
                      "        maj32,maj33,maj34,maj35",                         #No.FUN-B60157
                      "   FROM maj_file WHERE maj01=? AND maj02=? FOR UPDATE"    #No.FUN-570087  -add maj26,27,28
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i116_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   INPUT ARRAY g_maj WITHOUT DEFAULTS FROM s_maj.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         OPEN i116_cl USING g_mai.mai01
         FETCH i116_cl INTO g_mai.*            # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_mai.mai01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            LET l_lock_sw = "Y"
         END IF
         IF g_rec_b>=l_ac THEN
            LET p_cmd='u'
            LET g_maj_t.* = g_maj[l_ac].*  #BACKUP
            OPEN i116_bcl USING g_mai.mai01,g_maj_t.maj02
            FETCH i116_bcl INTO g_maj[l_ac].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_maj_t.maj02,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         IF p_key =  'a' AND l_ac >= 150   THEN
            CALL cl_err('','agl-016',0)
            SLEEP 1
         END IF
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_maj[l_ac].* TO NULL      #900423
         LET g_maj[l_ac].maj03 = '1'
         LET g_maj[l_ac].maj09 = '+'
         LET g_maj[l_ac].maj04 = 0
         LET g_maj[l_ac].maj05 = 0
         LET g_maj[l_ac].maj07 = '1'
         LET g_maj[l_ac].maj08 = 0
         LET g_maj[l_ac].maj06 = '3'
         LET g_maj[l_ac].maj11 = 'N'
         IF l_ac > 1 THEN
           #LET g_maj[l_ac].maj23 = g_maj[l_ac-1].maj23  #MOD-60192 remark
           LET g_maj[l_ac].maj23a = g_maj[l_ac-1].maj23a #MOD-60192 
           LET g_maj[l_ac].maj23b = g_maj[l_ac-1].maj23b #MOD-60192 
         END IF
#No.FUN-570087--begin
         LET g_maj[l_ac].maj27 = ''
         LET g_maj[l_ac].maj28 = ''
#No.FUN-570087--end
         LET g_maj_t.* = g_maj[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD maj02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err(g_maj[l_ac].maj02,9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
     
         #MOD-460192
         INITIALIZE l_maj23 TO NULL
         LET l_maj23 = g_maj[l_ac].maj23a CLIPPED,g_maj[l_ac].maj23b CLIPPED
 
         INSERT INTO maj_file(maj01,maj02,maj03,maj04,maj05,maj06,maj07,maj26,
                             #maj11,maj08,maj09,maj20,maj20e,maj21,maj22,         #FUN-B60077 mark
                              maj11,maj08,maj09,maj20,maj20e,maj31,maj21,maj22,   #FUN-B60077 add-maj31
                              maj23,maj27,maj28,maj24,maj25,
                              maj32,maj33,maj34,maj35)   #FUN-B60157
                       VALUES(g_mai.mai01,g_maj[l_ac].maj02,g_maj[l_ac].maj03,
                              g_maj[l_ac].maj04,g_maj[l_ac].maj05,
                              g_maj[l_ac].maj06,g_maj[l_ac].maj07,g_maj[l_ac].maj26,
                              g_maj[l_ac].maj11,g_maj[l_ac].maj08,
                              g_maj[l_ac].maj09,g_maj[l_ac].maj20,
                             #g_maj[l_ac].maj20e,g_maj[l_ac].maj21,                    #FUN-B60077 mark
                              g_maj[l_ac].maj20e,g_maj[l_ac].maj31,g_maj[l_ac].maj21,  #FUN-B60077 add-maj31
                              g_maj[l_ac].maj22,l_maj23,g_maj[l_ac].maj27,g_maj[l_ac].maj28,  #MOD-460192 將g_maj[l_ac].maj23改成l_maj23
                              g_maj[l_ac].maj24,g_maj[l_ac].maj25,                            #No.FUN-570087 --add maj26,27,28
                              g_maj[l_ac].maj32,g_maj[l_ac].maj33,g_maj[l_ac].maj34,g_maj[l_ac].maj35)   #No.FUN-B60157
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_maj[l_ac].maj02,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","maj_file",g_mai.mai01,g_maj[l_ac].maj02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
        BEFORE FIELD maj02                        #default 序號
           IF cl_null(g_maj[l_ac].maj02) OR
              g_maj[l_ac].maj02 = 0 THEN
                 SELECT max(maj02)+1 INTO g_maj[l_ac].maj02 FROM maj_file
                  WHERE maj02 > 0 AND maj01 = g_mai.mai01
                 IF g_maj[l_ac].maj02 IS NULL THEN
                    LET g_maj[l_ac].maj02 = 1
                 END IF
           END IF
 
        AFTER FIELD maj02                        #check 序號是否重複
           IF NOT cl_null(g_maj[l_ac].maj02) THEN
              IF g_maj[l_ac].maj02 != g_maj_t.maj02 OR g_maj_t.maj02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM maj_file
                  WHERE maj01 = g_mai.mai01 AND maj02 = g_maj[l_ac].maj02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_maj[l_ac].maj02 = g_maj_t.maj02
                    NEXT FIELD maj02
                 END IF
              END IF
           END IF
 
        AFTER FIELD maj03
           IF NOT cl_null(g_maj[l_ac].maj03) THEN
              IF g_maj[l_ac].maj03 NOT MATCHES '[0123459H%]' THEN
                 NEXT FIELD maj03
              ELSE
                 IF g_maj[l_ac].maj03 MATCHES "[012]" AND
                    (g_maj[l_ac].maj08 IS NULL OR g_maj[l_ac].maj08 = 0) THEN
                    LET g_maj[l_ac].maj08 = 1
                    #------MOD-5A0095 START----------
                    DISPLAY BY NAME g_maj[l_ac].maj08
                    #------MOD-5A0095 END------------
                 END IF
              END IF
           END IF
 
        AFTER FIELD maj04
           IF NOT cl_null(g_maj[l_ac].maj04) THEN
               IF g_maj[l_ac].maj04 < 0 THEN
                   #輸入值不可小於零!
                   CALL cl_err('','aim-391',0)
                   LET g_maj[l_ac].maj04 = g_maj_t.maj04
                   #------MOD-5A0095 START----------
                   DISPLAY BY NAME g_maj[l_ac].maj04
                   #------MOD-5A0095 END------------
                   NEXT FIELD maj04
               END IF
           END IF
 
        AFTER FIELD maj05
           IF NOT cl_null(g_maj[l_ac].maj05) THEN
               IF g_maj[l_ac].maj05 < 0 THEN
                   #輸入值不可小於零!
                   CALL cl_err('','aim-391',0)
                   LET g_maj[l_ac].maj05 = g_maj_t.maj05
                   #------MOD-5A0095 START----------
                   DISPLAY BY NAME g_maj[l_ac].maj05
                   #------MOD-5A0095 END------------
                   NEXT FIELD maj05
               END IF
           END IF
 
        AFTER FIELD maj09
           IF NOT cl_null(g_maj[l_ac].maj09) THEN
              IF g_maj[l_ac].maj09 NOT MATCHES '[+-]' THEN
               NEXT FIELD maj09
              END IF
           END IF
 
        AFTER FIELD maj06
           IF NOT cl_null(g_maj[l_ac].maj06) THEN
              IF g_maj[l_ac].maj06 NOT MATCHES '[123456789]' THEN      #FUN-630090   #No.FUN-CA0097 Mark
             #IF g_maj[l_ac].maj06 NOT MATCHES '[123456789abcd]' THEN                #No.FUN-CA0097 Add
                 NEXT FIELD maj06
              END IF
           END IF
 
        AFTER FIELD maj07
           IF NOT cl_null(g_maj[l_ac].maj07) THEN
              IF g_maj[l_ac].maj07 NOT MATCHES "[12]" THEN
                 NEXT FIELD maj07
              END IF
           END IF
 
        AFTER FIELD maj20
           IF NOT cl_null(g_maj[l_ac].maj20) THEN
              IF g_maj[l_ac].maj20[1,1]='.' THEN
                 LET g_msg=g_maj[l_ac].maj20[2,20]
                 CALL i116_maj20(g_msg)
              END IF
           END IF
 
        #FUN-6C0012 --begin
        AFTER FIELD maj20e
           IF NOT cl_null(g_maj[l_ac].maj20e) THEN
              IF g_maj[l_ac].maj20e[1,1]='.' THEN
                 LET g_msg=g_maj[l_ac].maj20e[2,20]
                 CALL i116_maj20e(g_msg)
              END IF
           END IF
        #FUN-6C0012 --end  

        #FUN-B60077--begin
        AFTER FIELD maj31
          #FUN-B80138
          #IF cl_null(g_maj[l_ac].maj31) AND
          #   g_maj[l_ac].maj03 matches'[025]' THEN
          #   NEXT FIELD maj31
          #END IF
          #FUN-B80138
           IF NOT cl_null(g_maj[l_ac].maj31) THEN
              CALL i116_maj31(g_maj[l_ac].maj31)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('sel aag:',g_errno,0)
                 NEXT FIELD maj31
              END IF
           END IF
        #FUN-B60077---end
 
        AFTER FIELD maj21
            IF cl_null(g_maj[l_ac].maj20) AND
               g_maj[l_ac].maj03 matches '[0125]' THEN
               CALL i116_maj20(g_maj[l_ac].maj21)
            END IF
            IF NOT cl_null(g_maj[l_ac].maj21) THEN
               CALL i116_maj20(g_maj[l_ac].maj21)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('sel aag:',g_errno,0)
                  #Add No.FUN-B10048
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"     #MOD-B30629 mod q_aag -> q_aag01 #MOD-B40063 remod
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = g_maj[l_ac].maj21
                  LET g_qryparam.arg1 = g_mai.mai00  #No.FUN-730020
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_maj[l_ac].maj21 CLIPPED,"%'" #MOD-B40063 mark#No.TQC-D10003   Unmark
                 #LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_maj[l_ac].maj21 CLIPPED,"%'"                        #MOD-B40063     #No.TQC-D10003   Mark
                  CALL cl_create_qry() RETURNING g_maj[l_ac].maj21
                  DISPLAY BY NAME g_maj[l_ac].maj21 
                  #End Add No.FUN-B10048
                  NEXT FIELD maj21
               ELSE
                 #No.TQC-D10003 ---start--- Add
                  SELECT aag07 INTO l_aag07 FROM aag_file
                   WHERE aag01 = g_maj[l_ac].maj21
                     AND aag00 = g_mai.mai00   #MOD-D40104
                  IF l_aag07 = '1' THEN
                     CALL cl_err('','agl-134',0)
                     NEXT FIELD maj21
                  END IF
                 #No.TQC-D10003 ---start--- Add
                  IF cl_null(g_maj[l_ac].maj22) THEN
                     LET g_maj[l_ac].maj22=g_maj[l_ac].maj21
                     #------MOD-5A0095 START----------
                     DISPLAY BY NAME g_maj[l_ac].maj22
                     #------MOD-5A0095 END------------
                  END IF
               END IF
            END IF
 
        AFTER FIELD maj22
           IF cl_null(g_maj[l_ac].maj22) AND
              g_maj[l_ac].maj03 matches'[025]' THEN
              NEXT FIELD maj22
          #No.TQC-D10003 ---start--- Add
           ELSE
              SELECT aag07 INTO l_aag07 FROM aag_file 
               WHERE aag01 = g_maj[l_ac].maj22
                 AND aag00 = g_mai.mai00   #MOD-D40104
              IF l_aag07 = '1' THEN
                 CALL cl_err('','agl-134',0)
                 NEXT FIELD maj22
              END IF
          #No.TQC-D10003 ---start--- Add
           END IF
#          IF NOT cl_null(g_maj[l_ac].maj22) THEN
#             CALL i116_maj20(g_maj[l_ac].maj22)
#             IF NOT cl_null(g_errno) THEN
#                CALL cl_err('sel aag:',g_errno,0)
#                NEXT FIELD maj22
#             END IF
#          END IF
#No.MOD-B60266 --begin
           #TQC-960117--Begin--#                                                                                                    
#           IF NOT cl_null(g_maj[l_ac].maj22) THEN                                                                                   
#              CALL i116_maj22(g_maj[l_ac].maj22)                                                                                    
#              IF NOT cl_null(g_errno) THEN                                                                                          
#                 CALL cl_err('sel aag:',g_errno,0)                                                                                  
#                 #Add No.FUN-B10048
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_aag"     #MOD-B30629 mod q_aag -> q_aag01 #MOD-B40063 remod
#                 LET g_qryparam.construct = 'N'
#                 LET g_qryparam.default1 = g_maj[l_ac].maj22
#                 LET g_qryparam.arg1 = g_mai.mai00 
#                #LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_maj[l_ac].maj21 CLIPPED,"%'" #MOD-B40063 mark
#                 LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_maj[l_ac].maj21 CLIPPED,"%'"                        #MOD-B40063
#                 CALL cl_create_qry() RETURNING g_maj[l_ac].maj22
#                 DISPLAY BY NAME g_maj[l_ac].maj22
#                 #End Add No.FUN-B10048
#                 NEXT FIELD maj22                                                                                                   
#              END IF                                                                                                                
#           END IF                                                                                                                   
           #TQC-960117--End--#
#No.MOD-B60266 --end
 
        AFTER FIELD maj24
            IF cl_null(g_maj[l_ac].maj25) THEN
               LET g_maj[l_ac].maj25=g_maj[l_ac].maj24
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_maj[l_ac].maj25
               #------MOD-5A0095 END------------
            END IF
 
        AFTER FIELD maj11
            IF NOT cl_null(g_maj[l_ac].maj11) THEN
               IF g_maj[l_ac].maj11 = 'Y' THEN
                  SELECT COUNT(*) INTO g_cnt FROM maj_file
                   WHERE maj01= g_mai.mai01 AND maj11 = 'Y'
                     AND maj02 != g_maj[l_ac].maj02
                  IF g_cnt > 0 THEN
                     CALL cl_err('','agl-130',0)
                     NEXT FIELD maj11
                  END IF
               END IF
            END IF
 
        AFTER FIELD maj08
            IF g_maj[l_ac].maj03  MATCHES "[012]" AND
               (g_maj[l_ac].maj08 IS NULL OR g_maj[l_ac].maj08 = 0) THEN
               LET g_maj[l_ac].maj08 = 1
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_maj[l_ac].maj08
               #------MOD-5A0095 END------------
               NEXT FIELD maj08
            END IF
            IF g_maj[l_ac].maj08 IS NULL THEN
               LET g_maj[l_ac].maj08 = 0
            END IF
 
        #MOD-460192 remark--start
        #AFTER FIELD maj23
        #   IF cl_null(g_maj[l_ac].maj23) AND g_maj[l_ac].maj03 matches'[0125]' THEN
        #      NEXT FIELD maj23
        #   END IF
        #MOD-460192 remark--end
 
        #MOD-460192 add --start
        AFTER FIELD maj23a
           IF cl_null(g_maj[l_ac].maj23a) AND g_maj[l_ac].maj03 matches'[0125]' THEN
              NEXT FIELD maj23a
           END IF
           IF NOT cl_null(g_maj[l_ac].maj23a) AND g_maj[l_ac].maj23a NOT  matches'[12]' THEN
              NEXT FIELD maj23a
           END IF
        
        AFTER FIELD maj23b
           IF NOT cl_null(g_maj[l_ac].maj23b) AND g_maj[l_ac].maj23b NOT matches'[12]' THEN
              NEXT FIELD maj23b
           END IF
        #MOD-460192 add --end
       #FUN-B60157---begin---
        AFTER FIELD maj32
           IF NOT cl_null(g_maj[l_ac].maj32) THEN
              IF g_maj[l_ac].maj32[1,1]='.' THEN
                 LET g_msg=g_maj[l_ac].maj32[2,20]
                 CALL i116_maj32(g_msg)
              END IF
           END IF
        AFTER FIELD maj33
           IF NOT cl_null(g_maj[l_ac].maj33) THEN
              IF g_maj[l_ac].maj33[1,1]='.' THEN
                 LET g_msg=g_maj[l_ac].maj33[2,20]
                 CALL i116_maj33(g_msg)
              END IF
           END IF
        AFTER FIELD maj34
            IF cl_null(g_maj[l_ac].maj32) AND
               g_maj[l_ac].maj03 matches '[0125]' THEN
               CALL i116_maj32(g_maj[l_ac].maj34)
            END IF
            IF NOT cl_null(g_maj[l_ac].maj34) THEN
               CALL i116_maj32(g_maj[l_ac].maj34)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('sel aag:',g_errno,0)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"     #MOD-B30629 mod q_aag -> q_aag01 #MOD-B40063 remod
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = g_maj[l_ac].maj34
                 #LET g_qryparam.arg1 = g_mai.mai00  #No.FUN-B70009
                  LET g_qryparam.arg1 = g_mai.mai04  #No.FUN-B70009
                  LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_maj[l_ac].maj34 CLIPPED,"%'"                        #MOD-B40063
                  CALL cl_create_qry() RETURNING g_maj[l_ac].maj34
                  DISPLAY BY NAME g_maj[l_ac].maj34 
                  NEXT FIELD maj34
               ELSE
                  IF cl_null(g_maj[l_ac].maj35) THEN
                     LET g_maj[l_ac].maj35=g_maj[l_ac].maj34
                     DISPLAY BY NAME g_maj[l_ac].maj35
                  END IF
               END IF
            END IF
 
        AFTER FIELD maj35
           IF cl_null(g_maj[l_ac].maj35) AND
              g_maj[l_ac].maj03 matches'[025]' THEN
              NEXT FIELD maj35
           END IF
           IF NOT cl_null(g_maj[l_ac].maj35) THEN                                                                                   
              CALL i116_maj35(g_maj[l_ac].maj35)                                                                                    
              IF NOT cl_null(g_errno) THEN                                                                                          
                 CALL cl_err('sel aag:',g_errno,0)                                                                                  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"     #MOD-B30629 mod q_aag -> q_aag01 #MOD-B40063 remod
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_maj[l_ac].maj35
                #LET g_qryparam.arg1 = g_mai.mai00  #No.FUN-B70009
                 LET g_qryparam.arg1 = g_mai.mai04  #No.FUN-B70009 
                 LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_maj[l_ac].maj34 CLIPPED,"%'"                        #MOD-B40063
                 CALL cl_create_qry() RETURNING g_maj[l_ac].maj35
                 DISPLAY BY NAME g_maj[l_ac].maj35
                 NEXT FIELD maj35                                                                                                   
              END IF
           END IF
       #FUN-B60157----end---- 
        BEFORE DELETE                            #是否取消單身
           IF g_maj_t.maj02 > 0 AND g_maj_t.maj02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
              DELETE FROM maj_file
               WHERE maj01 = g_mai.mai01 AND maj02 = g_maj_t.maj02
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_maj_t.maj02,SQLCA.sqlcode,0)   #No.FUN-660123
                 CALL cl_err3("del","maj_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660123
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              COMMIT WORK
           END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err(g_maj[l_ac].maj02,9001,0)
               LET INT_FLAG = 0
               LET g_maj[l_ac].* = g_maj_t.*
               CLOSE i116_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_maj[l_ac].maj02,-263,1)
               LET g_maj[l_ac].* = g_maj_t.*
            ELSE
               #MOD-460192 --start
               INITIALIZE l_maj23 TO NULL
               LET l_maj23 = g_maj[l_ac].maj23a CLIPPED,g_maj[l_ac].maj23b CLIPPED
               #MOD-460192 --end
               
               UPDATE maj_file SET maj02 = g_maj[l_ac].maj02,
                                   maj03 = g_maj[l_ac].maj03,
                                   maj04 = g_maj[l_ac].maj04,
                                   maj05 = g_maj[l_ac].maj05,
                                   maj06 = g_maj[l_ac].maj06,
                                   maj07 = g_maj[l_ac].maj07,
                                   maj26 = g_maj[l_ac].maj26,
                                   maj11 = g_maj[l_ac].maj11,
                                   maj08 = g_maj[l_ac].maj08,
                                   maj09 = g_maj[l_ac].maj09,
                                   maj20 = g_maj[l_ac].maj20,
                                   maj20e = g_maj[l_ac].maj20e,
                                   maj31 = g_maj[l_ac].maj31, #FUN-B60077
                                   maj21 = g_maj[l_ac].maj21,
                                   maj22 = g_maj[l_ac].maj22,
                                  #maj23 = g_maj[l_ac].maj23, #MOD-460192 remark
                                   maj23 = l_maj23,           #MOD-460192 add
                                   maj27 = g_maj[l_ac].maj27,
                                   maj28 = g_maj[l_ac].maj28,
                                   maj24 = g_maj[l_ac].maj24,
                                   maj25 = g_maj[l_ac].maj25,
                                   maj32 = g_maj[l_ac].maj32,   #FUN-B60157
                                   maj33 = g_maj[l_ac].maj33,   #FUN-B60157
                                   maj34 = g_maj[l_ac].maj34,   #FUN-B60157
                                   maj35 = g_maj[l_ac].maj35    #FUN-B60157
                WHERE maj01=g_mai.mai01 AND maj02=g_maj_t.maj02   #No.FUN-570087  --add maj26,27,28
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_maj[l_ac].maj02,SQLCA.sqlcode,0)   #No.FUN-660123
                  CALL cl_err3("upd","maj_file",g_mai.mai01,g_maj_t.maj02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                  LET g_maj[l_ac].* = g_maj_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac   #FUN-D30032 mark
           IF INT_FLAG THEN
              CALL cl_err(g_maj[l_ac].maj02,9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_maj[l_ac].* = g_maj_t.*
              #FUN-D30032--add--begin--
              ELSE
                 CALL g_maj.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30032--add--end----
              END IF
              CLOSE i116_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30032 add
           CLOSE i116_bcl
           COMMIT WORK
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(maj20)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_aag"     #No:MOD-460190    #MOD-B30629 mod q_aag01 -> q_aag
                #LET g_qryparam.form ="q_aag01"    #TQC-C40190 mod #MOD-C40164 mark
                 #LET g_qryparam.form ="q_aag_r"    #MOD-C40164 ->q_aag_r   #TQC-C50240  mark
                 LET g_qryparam.form ="q_aag_r_1"  #TQC-C50240  add
                 LET g_qryparam.default1 = g_maj[l_ac].maj20
                 LET g_qryparam.arg1 = g_mai.mai00  #No.FUN-730020
                 CALL cl_create_qry() RETURNING g_maj[l_ac].maj20,g_maj[l_ac].maj20e   #TQC-C40190
#                 CALL FGL_DIALOG_SETBUFFER( g_maj[l_ac].maj20 )
                  DISPLAY BY NAME g_maj[l_ac].maj20           #No.MOD-490344
                  DISPLAY BY NAME g_maj[l_ac].maj20e          #No.TQC-C40190
                 NEXT FIELD maj20
              WHEN INFIELD(maj21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"     #MOD-B30629 mod q_aag -> q_aag01 #MOD-B40063 remod
                 LET g_qryparam.default1 = g_maj[l_ac].maj21
                 LET g_qryparam.arg1 = g_mai.mai00  #No.FUN-730020
                 LET g_qryparam.where = " aag07 IN ( '2' , '3' )"   #No.TQC-D10003   Add
                 CALL cl_create_qry() RETURNING g_maj[l_ac].maj21
#                 CALL FGL_DIALOG_SETBUFFER( g_maj[l_ac].maj21 )
                  DISPLAY BY NAME g_maj[l_ac].maj21           #No.MOD-490344
                 NEXT FIELD maj21
              WHEN INFIELD(maj22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"     #MOD-B30629 mod q_aag -> q_aag01 #MOD-B40063 remod
                 LET g_qryparam.default1 = g_maj[l_ac].maj22
                 LET g_qryparam.arg1 = g_mai.mai00  #No.FUN-730020
                 LET g_qryparam.where = " aag07 IN ( '2' , '3' )"   #No.TQC-D10003   Add
                 CALL cl_create_qry() RETURNING g_maj[l_ac].maj22
#                 CALL FGL_DIALOG_SETBUFFER( g_maj[l_ac].maj22 )
                  DISPLAY BY NAME g_maj[l_ac].maj22           #No.MOD-490344
                 NEXT FIELD maj22
              WHEN INFIELD(maj24)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_maj[l_ac].maj24
                 CALL cl_create_qry() RETURNING g_maj[l_ac].maj24
#                 CALL FGL_DIALOG_SETBUFFER( g_maj[l_ac].maj24 )
                  DISPLAY BY NAME g_maj[l_ac].maj24           #No.MOD-490344
                 NEXT FIELD maj24
              WHEN INFIELD(maj25)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_maj[l_ac].maj25
                 CALL cl_create_qry() RETURNING g_maj[l_ac].maj25
#                 CALL FGL_DIALOG_SETBUFFER( g_maj[l_ac].maj25 )
                  DISPLAY BY NAME g_maj[l_ac].maj25           #No.MOD-490344
                 NEXT FIELD maj25

             #FUN-B60077--begin--
              WHEN INFIELD(maj31)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_maj[l_ac].maj31
                 LET g_qryparam.arg1 = g_mai.mai00
                 CALL cl_create_qry() RETURNING g_maj[l_ac].maj31
                 DISPLAY BY NAME g_maj[l_ac].maj31
                 NEXT FIELD maj31
              #FUN-B60077---end---

            #FUN-B60157---begin---
              WHEN INFIELD(maj32)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"     #No:MOD-460190    #MOD-B30629 mod q_aag01 -> q_aag
                 LET g_qryparam.default1 = g_maj[l_ac].maj32
                #LET g_qryparam.arg1 = g_mai.mai00  #No.FUN-B70009
                 LET g_qryparam.arg1 = g_mai.mai04  #No.FUN-B70009
                 CALL cl_create_qry() RETURNING g_maj[l_ac].maj32
                 DISPLAY BY NAME g_maj[l_ac].maj32           #No.MOD-490344
                 NEXT FIELD maj32
              WHEN INFIELD(maj34)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"     #MOD-B30629 mod q_aag -> q_aag01 #MOD-B40063 remod
                 LET g_qryparam.default1 = g_maj[l_ac].maj34
                #LET g_qryparam.arg1 = g_mai.mai00  #No.FUN-B70009
                 LET g_qryparam.arg1 = g_mai.mai04  #No.FUN-B70009
                 CALL cl_create_qry() RETURNING g_maj[l_ac].maj34
                 DISPLAY BY NAME g_maj[l_ac].maj34           #No.MOD-490344
                 NEXT FIELD maj34
              WHEN INFIELD(maj35)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"     #MOD-B30629 mod q_aag -> q_aag01 #MOD-B40063 remod
                 LET g_qryparam.default1 = g_maj[l_ac].maj35
                #LET g_qryparam.arg1 = g_mai.mai00  #No.FUN-B70009
                 LET g_qryparam.arg1 = g_mai.mai04  #No.FUN-B70009
                 CALL cl_create_qry() RETURNING g_maj[l_ac].maj35
                 DISPLAY BY NAME g_maj[l_ac].maj35           #No.MOD-490344
                 NEXT FIELD maj35
             #FUN-B60157----end----
              OTHERWISE
                 EXIT CASE
           END CASE
 
#       ON ACTION CONTROLN
#           CALL i116_b_askkey()
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(maj02) AND l_ac > 1 THEN
                LET g_maj[l_ac].* = g_maj[l_ac-1].*
                LET g_maj[l_ac].maj11 = 'N'
                LET g_maj[l_ac].maj02 = NULL
                NEXT FIELD maj02
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
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
        END INPUT
 
        UPDATE mai_file SET maimodu=g_user,maidate=g_today
         WHERE mai01=g_mai.mai01
 
    CLOSE i116_cl
    CLOSE i116_bcl
    COMMIT WORK
    CALL i116_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i116_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM smv_file WHERE smv01 = g_mai.mai01 AND upper(smv03)='RGL'  #CHI-C80041
         DELETE FROM smu_file WHERE smu01 = g_mai.mai01 AND upper(smu03)='RGL'  #CHI-C80041
         DELETE FROM mai_file WHERE mai01=g_mai.mai01
         INITIALIZE g_mai.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i116_maj20(p_code)
DEFINE p_code     LIKE aag_file.aag01,
       l_aag02    LIKE aag_file.aag02,
       l_aag07    LIKE aag_file.aag07,
       l_aag13    LIKE aag_file.aag13,
       l_aagacti  LIKE aag_file.aagacti,
       l_point    LIKE type_file.chr1           #No.FUN-680098   VARCHAR(1)
 
   SELECT aag02,aag07,aag13,aagacti INTO l_aag02,l_aag07,l_aag13,l_aagacti
     FROM aag_file WHERE aag01=p_code
                     AND aag00=g_mai.mai00  #No.FUN-730020
 
   CASE
      WHEN SQLCA.sqlcode   LET l_aag02  = NULL LET l_aag13  = NULL
                           LET g_errno = 'agl-001'
      WHEN l_aagacti = 'N' LET g_errno = '9028'
     #WHEN l_aag07 = '1'   LET g_errno = 'agl-134' #不可輸入統制科目! #MOD-B40063 mark
      OTHERWISE            LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE
   LET l_point = g_maj[l_ac].maj20[1,1]
   IF l_point = '.'  OR g_maj[l_ac].maj20 IS NULL OR g_maj[l_ac].maj20 = ' ' THEN
      LET g_maj[l_ac].maj20 = l_aag02
   END IF
   IF cl_null(g_maj[l_ac].maj20e) THEN
      LET g_maj[l_ac].maj20e = l_aag13
   END IF
   #------MOD-5A0095 START----------
   DISPLAY BY NAME g_maj[l_ac].maj20
   DISPLAY BY NAME g_maj[l_ac].maj20e
   #------MOD-5A0095 END------------
END FUNCTION

#FUN-B60077--Begin--
FUNCTION i116_maj31(p_code)
DEFINE p_code     LIKE aag_file.aag01,
       l_aag02    LIKE aag_file.aag02,
       l_aag07    LIKE aag_file.aag07,
       l_aag13    LIKE aag_file.aag13,
       l_aagacti  LIKE aag_file.aagacti,
       l_point    LIKE type_file.chr1           #No.FUN-680098   CHAR(1)

   SELECT aag02,aag07,aag13,aagacti INTO l_aag02,l_aag07,l_aag13,l_aagacti
     FROM aag_file WHERE aag01=p_code
                     AND aag00=g_mai.mai00  #No.FUN-730020

   CASE
      WHEN SQLCA.sqlcode   LET l_aag02  = NULL LET l_aag13  = NULL
                          #LET g_errno = 'agl-001'  #TQC-BC0092 mark
      WHEN l_aagacti = 'N' LET g_errno = '9028'
     #WHEN l_aag07 = '1'   LET g_errno = 'agl-134'  #TQC-BC0092  #不可輸入統制科目! #MOD-B40063 mark
      OTHERWISE            LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE
   LET l_point = g_maj[l_ac].maj31[1,1]
   IF l_point = '.'  OR g_maj[l_ac].maj31 IS NULL OR g_maj[l_ac].maj31 = ' ' THEN
      LET g_maj[l_ac].maj31 = l_aag02
   END IF
   DISPLAY BY NAME g_maj[l_ac].maj31
END FUNCTION
#FUN-B60077---End---
 
#No.MOD-B60266 --begin
#TQC-960117--Begin--#                                                                                                               
#FUNCTION i116_maj22(p_code)                                                                                                         
#DEFINE p_code     LIKE aag_file.aag01,                                                                                              
#       l_aag02    LIKE aag_file.aag02,                                                                                              
#       l_aag07    LIKE aag_file.aag07,                                                                                              
#       l_aag13    LIKE aag_file.aag13,                                                                                              
#       l_aagacti  LIKE aag_file.aagacti                                                                                             
#                                                                                                                                    
#   LET g_errno = ''                                                                                                                 
#                                                                                                                                    
#   SELECT aag02,aag07,aag13,aagacti INTO l_aag02,l_aag07,l_aag13,l_aagacti                                                          
#     FROM aag_file WHERE aag01=p_code                                                                                               
#                     AND aag00=g_mai.mai00                                                                                          
#                                                                                                                                    
#   CASE                                                                                                                             
#      WHEN SQLCA.sqlcode   LET l_aag02  = NULL LET l_aag13  = NULL                                                                  
#                           LET g_errno = 'agl-001'                                                                                  
#      WHEN l_aagacti = 'N' LET g_errno = '9028'                                                                                     
#     #WHEN l_aag07 = '1'   LET g_errno = 'agl-134' #不可輸入統制科目! #MOD-B40063 mark
#      OTHERWISE            LET g_errno = SQLCA.sqlcode USING '----------'                                                           
#   END CASE                                                                                                                         
#END FUNCTION                                                                                                                        
#TQC-960117--End--#
#No.MOD-B60266 --end
 
#FUN-6C0012 --begin
FUNCTION i116_maj20e(p_code)
DEFINE p_code     LIKE aag_file.aag01,
       l_aag07    LIKE aag_file.aag07,
       l_aag13    LIKE aag_file.aag13,
       l_aagacti  LIKE aag_file.aagacti,
       l_point    LIKE type_file.chr1
 
   SELECT aag07,aag13,aagacti INTO l_aag07,l_aag13,l_aagacti
     FROM aag_file WHERE aag01=p_code
                     AND aag00=g_mai.mai00  #No.FUN-730020
 
   CASE
      WHEN SQLCA.sqlcode   LET l_aag13  = NULL
                           LET g_errno = 'agl-001'
      WHEN l_aagacti = 'N' LET g_errno = '9028'
     #WHEN l_aag07 = '1'   LET g_errno = 'agl-134' #不可輸入統制科目! #MOD-B40063 mark
      OTHERWISE            LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE
   LET l_point = g_maj[l_ac].maj20e[1,1]
   LET g_maj[l_ac].maj20e = l_aag13
   DISPLAY BY NAME g_maj[l_ac].maj20e
END FUNCTION
#FUN-6C0012 --end   
#FUN-B60157---begin---
FUNCTION i116_maj32(p_code)
DEFINE p_code     LIKE aag_file.aag01,
       l_aag02    LIKE aag_file.aag02,
       l_aag07    LIKE aag_file.aag07,
       l_aag13    LIKE aag_file.aag13,
       l_aagacti  LIKE aag_file.aagacti,
       l_point    LIKE type_file.chr1           #No.FUN-680098   VARCHAR(1)
 
   SELECT aag02,aag07,aag13,aagacti INTO l_aag02,l_aag07,l_aag13,l_aagacti
     FROM aag_file WHERE aag01=p_code
                    #AND aag00=g_mai.mai00  #No.FUN-B70009
                     AND aag00=g_mai.mai04  #No.FUN-B70009
 
   CASE
      WHEN SQLCA.sqlcode   LET l_aag02  = NULL LET l_aag13  = NULL
                           LET g_errno = 'agl-001'
      WHEN l_aagacti = 'N' LET g_errno = '9028'
      OTHERWISE            LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE
   LET l_point = g_maj[l_ac].maj32[1,1]
   IF l_point = '.'  OR g_maj[l_ac].maj32 IS NULL OR g_maj[l_ac].maj32 = ' ' THEN
      LET g_maj[l_ac].maj32 = l_aag02
   END IF
   IF cl_null(g_maj[l_ac].maj33) THEN
      LET g_maj[l_ac].maj33 = l_aag13
   END IF
   DISPLAY BY NAME g_maj[l_ac].maj32
   DISPLAY BY NAME g_maj[l_ac].maj33
END FUNCTION
 
FUNCTION i116_maj35(p_code)                                                                                                         
DEFINE p_code     LIKE aag_file.aag01,                                                                                              
       l_aag02    LIKE aag_file.aag02,                                                                                              
       l_aag07    LIKE aag_file.aag07,                                                                                              
       l_aag13    LIKE aag_file.aag13,                                                                                              
       l_aagacti  LIKE aag_file.aagacti                                                                                             
                                                                                                                                    
   LET g_errno = ''                                                                                                                 
                                                                                                                                    
   SELECT aag02,aag07,aag13,aagacti INTO l_aag02,l_aag07,l_aag13,l_aagacti                                                          
     FROM aag_file WHERE aag01=p_code                                                                                               
                    #AND aag00=g_mai.mai00   #FUN-B70009                                                                                       
                     AND aag00=g_mai.mai04   #FUN-B70009 
                                                                                                                                    
   CASE                                                                                                                             
      WHEN SQLCA.sqlcode   LET l_aag02  = NULL LET l_aag13  = NULL                                                                  
                           LET g_errno = 'agl-001'                                                                                  
      WHEN l_aagacti = 'N' LET g_errno = '9028'                                                                                     
      OTHERWISE            LET g_errno = SQLCA.sqlcode USING '----------'                                                           
   END CASE                                                                                                                         
END FUNCTION                                                                                                                        
 
FUNCTION i116_maj33(p_code)
DEFINE p_code     LIKE aag_file.aag01,
       l_aag07    LIKE aag_file.aag07,
       l_aag13    LIKE aag_file.aag13,
       l_aagacti  LIKE aag_file.aagacti,
       l_point    LIKE type_file.chr1
 
   SELECT aag07,aag13,aagacti INTO l_aag07,l_aag13,l_aagacti
     FROM aag_file WHERE aag01=p_code
                    #AND aag00=g_mai.mai00  #No.FUN-B70009
                     AND aag00=g_mai.mai04  #No.FUN-B70009
 
   CASE
      WHEN SQLCA.sqlcode   LET l_aag13  = NULL
                           LET g_errno = 'agl-001'
      WHEN l_aagacti = 'N' LET g_errno = '9028'
      OTHERWISE            LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE
   LET l_point = g_maj[l_ac].maj33[1,1]
   LET g_maj[l_ac].maj33 = l_aag13
   DISPLAY BY NAME g_maj[l_ac].maj33
END FUNCTION
#FUN-B60157----end---- 

FUNCTION i116_g()
DEFINE  l_sql    LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(200)
        l_cnt    LIKE type_file.num5,          #No.FUN-680098 SMALLINT
        l_maj02  LIKE maj_file.maj02
 
   IF s_aglshut(0) THEN RETURN END IF
   CALL cl_wait()
   LET l_sql = " UPDATE maj_file SET maj02 = maj02 + 10000 ",
               " WHERE maj01 = '",g_mai.mai01,"'"
   PREPARE i116_pre1  FROM l_sql
   EXECUTE i116_pre1
   DECLARE i116_maj CURSOR FOR
           SELECT maj02 FROM maj_file
            WHERE maj02 > 0 AND maj01 = g_mai.mai01
            ORDER BY maj02
   LET l_cnt = 1
   FOREACH i116_maj INTO l_maj02
      UPDATE maj_file SET maj02 = l_cnt
       WHERE maj01 = g_mai.mai01 AND maj02 = l_maj02
      LET l_cnt  = l_cnt + 1
   END FOREACH
   CALL i116_show()
   ERROR 'O.K.'
END FUNCTION
 
FUNCTION i116_b_askkey()
DEFINE
   l_wc2    LIKE type_file.chr1000     #No.FUN-680098 VARCHAR(200)
 
   CONSTRUCT l_wc2 ON maj02,maj03
           FROM s_maj[1].maj02,s_maj[1].maj03
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
   CALL i116_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i116_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2    LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(200)
 
   LET g_sql = "SELECT maj02,maj03,maj09,maj06,maj04,maj05,maj07,maj26,",
              #"       maj20,maj20e,maj21,maj22,maj24,maj25,maj11,maj08,substring(maj23,1,1) maj23a,substring(maj23,2,1) maj23b,maj27,maj28", #MOD-460192 將maj23 拆成 maj23a及 maj23b  #No.TQC-9B0021
              #"       maj20,maj20e,maj21,maj22,maj24,maj25,maj11,maj08,maj23[1,1] maj23a,maj23[2,2] maj23b,maj27,maj28,", #FUN-B70039 mark #MOD-460192 將maj23 拆成 maj23a及 maj23b  #No.TQC-9B0021
               "       maj20,maj20e,maj31,maj21,maj22,maj24,maj25,maj11,maj08,maj23[1,1] maj23a,maj23[2,2] maj23b,maj27,maj28,", #FUN-B70039 add -maj31 
               "       maj32,maj33,maj34,maj35", #FUN-B60157
               " FROM maj_file",
               " WHERE maj02 > 0 AND maj01 ='",g_mai.mai01,"'"  #單頭
   #No.FUN-8B0123---Begin
   #           "   AND ",p_wc2 CLIPPED,                     #單身
   #           " ORDER BY 1"    #No.FUN-570087 --add maj26,27,28
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
   END IF 
   LET g_sql=g_sql CLIPPED," ORDER BY 1 " 
   DISPLAY g_sql
   #No.FUN-8B0123---End
 
   PREPARE i116_pb FROM g_sql
   DECLARE maj_curs                       #SCROLL CURSOR
       CURSOR FOR i116_pb
 
   CALL g_maj.clear()
   LET g_cnt = 1
   MESSAGE " Waiting "
   FOREACH maj_curs INTO g_maj[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_maj.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i116_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680098  VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_maj TO s_maj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i116_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i116_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i116_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i116_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i116_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
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
         CALL cl_set_field_pic("","","","","",g_mai.maiacti)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION generate
         LET g_action_choice="generate"
         EXIT DISPLAY
      ON ACTION re_sort
         LET g_action_choice="re_sort"
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
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
    #FUN-6C0068--begin
      ON ACTION authorization
         LET g_action_choice="authorization"
         EXIT DISPLAY
         
      ON ACTION dept_authorization
         LET g_action_choice="dept_authorization"
         EXIT DISPLAY        
    #FUN-6C0068--end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i116_t()
  DEFINE l_wc           LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(300)
  DEFINE l_aag01        LIKE aag_file.aag01          #No.FUN-680098 VARCHAR(24)  
  DEFINE l_aag02        LIKE aag_file.aag02          #No.FUN-680098 VARCHAR(30)  
#  DEFINE l_aag13           VARCHAR(30)   #FUN-590122
  DEFINE l_aag13        LIKE aag_file.aag13  #FUN-590122 #No.FUN-680098    VARCHAR(50)
  DEFINE l_aag04        LIKE aag_file.aag04            #No.FUN-680098   VARCHAR(01)  
  DEFINE l_aag06        LIKE aag_file.aag06            #No.FUN-680098   VARCHAR(01)
  DEFINE l_aag09        LIKE aag_file.aag09            #No.FUN-680098   VARCHAR(01)
  DEFINE l_success      LIKE type_file.chr1            #No.FUN-680098   VARCHAR(1)
  DEFINE a1,a2,a3,a4    LIKE type_file.chr20           #No.FUN-680098   VARCHAR(10)
  DEFINE s1,s2,s3,s4    LIKE type_file.chr20           #No.FUN-680098   VARCHAR(10)
  DEFINE ord1           LIKE type_file.chr4            #No.FUN-680098   VARCHAR(4)
  DEFINE seq,i          LIKE maj_file.maj02            #No.FUN-680098   DECIMAL(8,4)
  DEFINE j,sum_level,space_col LIKE type_file.num5     #No.FUN-680098   SMALLINT 

  #No.FUN-BC0120--Begin--
  DEFINE tm             RECORD
                        change  LIKE type_file.chr1,
                        year    LIKE tag_file.tag01
                        END RECORD
  DEFINE p_cmd          LIKE type_file.chr1            #CHAR(1)  #c:check
  DEFINE l_n_aag02      LIKE aag_file.aag02            #CHAR(30)
  DEFINE l_n_aag13      LIKE aag_file.aag13            #CHAR(50)
  DEFINE l_tag05        LIKE tag_file.tag05
  #No.FUN-BC0120--End--

    IF g_mai.mai01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
 
  OPEN WINDOW i116_w_t AT 6,3 WITH FORM "agl/42f/agli1062"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("agli1062")
 
  #No.FUN-BC0120--Begin--
  LET p_cmd = 'c'
  LET tm.change = 'N'
  LET tm.year = ''
  IF g_mai.mai03 = '5'
   OR g_mai.mai03 = '6' THEN
     CALL cl_set_comp_entry("change",TRUE)
  ELSE
     CALL cl_set_comp_entry("change",FALSE)
  END IF
  CALL i116_set_no_entry(p_cmd)
  #No.FUN-BC0120--End--

  SELECT MAX(maj02) INTO seq FROM maj_file WHERE maj01 = g_mai.mai01
  IF seq IS NULL THEN LET seq=0 END IF
  LET seq=seq+1
  LET i=1
  LET space_col=0

#No.FUN-BC0120--Mark Begin---
# CONSTRUCT BY NAME l_wc ON aag07,aag04,aag01,aag223,aag224,aag225,aag226
#    #No.FUN-580031 --start--     HCN
#    BEFORE CONSTRUCT
#       CALL cl_qbe_init()
#    #No.FUN-580031 --end--       HCN
#
#    ON IDLE g_idle_seconds   #MOD-840631
#       CALL cl_on_idle()
#       CONTINUE CONSTRUCT
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#
#       	#No.FUN-580031 --start--     HCN
#                ON ACTION qbe_select
#        	   CALL cl_qbe_select()
#                ON ACTION qbe_save
#       	   CALL cl_qbe_save()
#       	#No.FUN-580031 --end--       HCN
# END CONSTRUCT
# IF NOT INT_FLAG THEN
#     INPUT BY NAME s1,s2,s3,s4,seq,i,space_col WITHOUT DEFAULTS
#     AFTER INPUT
#        LET ord1 = s1[1,1],s2[1,1],s3[1,1],s4[1,1]
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#
#     END INPUT
# END IF
#No.FUN-BC0120--Mark End--
 
#No.Fun-BC0120--Begin--
  DIALOG ATTRIBUTES(unbuffered)
     CONSTRUCT BY NAME l_wc ON aag07,aag04,aag01,aag223,aag224,aag225,aag226
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
     END CONSTRUCT

     INPUT BY NAME s1,s2,s3,s4,seq,i,space_col ATTRIBUTE(WITHOUT DEFAULTS)
        AFTER INPUT
           LET ord1 = s1[1,1],s2[1,1],s3[1,1],s4[1,1]
     END INPUT

     INPUT BY NAME tm.change,tm.year ATTRIBUTE(WITHOUT DEFAULTS)
       BEFORE INPUT
         IF tm.change = 'Y' THEN
           IF g_mai.mai03 = '5'
            OR g_mai.mai03 = '6' THEN
               CALL i116_set_entry(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.year,g_errno,0)
                  NEXT FIELD tm.year
               END IF
           END IF
         ELSE
               CALL i116_set_no_entry(p_cmd)
         END IF
       ON CHANGE change
         IF tm.change = 'Y' THEN
           IF g_mai.mai03 = '5'
            OR g_mai.mai03 = '6' THEN
               CALL i116_set_entry(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.year,g_errno,0)
                  NEXT FIELD tm.year
               END IF
           END IF
         ELSE
               CALL i116_set_no_entry(p_cmd)
         END IF
     END INPUT

     ON ACTION locale
        CALL cl_show_fld_cont()
        EXIT DIALOG

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DIALOG

     ON ACTION about
        CALL cl_about()

     ON ACTION help
        CALL cl_show_help()

     ON ACTION controlg
        CALL cl_cmdask()

     ON ACTION CONTROLZ
        CALL cl_show_req_fields()

     ON ACTION exit
        LET INT_FLAG = 1
        EXIT DIALOG

     ON ACTION qbe_select
        CALL cl_qbe_select()

     ON ACTION qbe_save
        CALL cl_qbe_save()

     ON ACTION accept
        EXIT DIALOG

     ON ACTION cancel
        LET INT_FLAG=1
        EXIT DIALOG
  END DIALOG
#No.BC0120--End---
  CLOSE WINDOW i116_w_t
  IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
  LET g_sql="SELECT aag223,aag224,aag225,aag226,aag01,aag02,aag13,aag04,aag06",
            "  FROM aag_file WHERE aagacti <> 'N' AND ",l_wc CLIPPED,
            "   AND aag00 = '",g_mai.mai00,"'"  #No.FUN-730020
           ,"   AND aag07 IN ( '2' , '3' )"     #Mo.TQC-D10003   Add
  IF ord1 IS NOT NULL THEN
    LET g_sql = g_sql CLIPPED," ORDER BY"
    FOR j = 1 TO 4
      IF ord1[j,j] != ' ' THEN LET g_sql=g_sql CLIPPED," ",ord1[j,j],"," END IF
    END FOR
    LET g_sql = g_sql CLIPPED," 5"
  #No.B504 010517 add by linda
  ELSE
    LET g_sql = g_sql CLIPPED," ORDER BY  5"
  #No.B504 end---
  END IF
  PREPARE t116_t_p FROM g_sql
  IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) RETURN END IF
  DECLARE t116_t_c CURSOR FOR t116_t_p
  BEGIN WORK
  LET l_success = 'Y'
  FOREACH t116_t_c INTO a1,a2,a3,a4,l_aag01,l_aag02,l_aag13,l_aag04,l_aag06
     IF STATUS THEN
        CALL cl_err('foreach error:',STATUS,0)
        LET l_success = 'N'
        EXIT FOREACH
     END IF
     LET g_chr = NULL
     SELECT aag03,aag09 INTO g_chr,l_aag09 FROM aag_file WHERE aag01 = l_aag01
                                            AND aag00 = g_mai.mai00  #No.FUN-730020
     IF g_chr = '3' THEN LET sum_level=10 ELSE LET sum_level= 0 END IF
     IF l_aag09 = 'N' THEN CONTINUE FOREACH END IF #no.7098
     MESSAGE "SEQ:",seq," ",l_aag01

     #No.FUN-BC0120--Begin--
     LET l_tag05 = NULL
     LET l_n_aag02 = NULL
     LET l_n_aag13 = NULL
     IF g_mai.mai03 = '5' OR g_mai.mai03 = '6' THEN
        IF tm.change = 'Y' THEN
          #SELECT tag05,                      #MOD-CB0105 mark
           SELECT tag03,                      #MOD-CB0105 add
                  aag02,
                  aag13
             INTO l_tag05,          #對應科目編號
                  l_n_aag02,        #對應科目名稱
                  l_n_aag13         #對應科目額外名稱
             FROM tag_file,
                  aag_file
           #WHERE tag04 = aag00               #MOD-CB0105 mark
           #  AND tag05 = aag01               #MOD-CB0105 mark
            WHERE tag02 = aag00               #MOD-CB0105 add
              AND tag03 = aag01               #MOD-CB0105 add
              AND tag01 = tm.year
             #AND tag02 = g_mai.mai00         #舊帳別 #MOD-CB0105 mark
             #AND tag03 = l_aag01             #舊科目 #MOD-CB0105 mark
             #AND tag04 = g_mai.mai04         #對應帳別#MOD-CB0105 mark
              AND tag02 = g_mai.mai04         #MOD-CB0105 add
              AND tag05 = l_aag01             #MOD-CB0105 add
              AND tag04 = g_mai.mai00         #MOD-CB0105 add
              AND tagacti = 'Y'
              AND aagacti = 'Y'
              AND tag06 = '1'          #CHI-C20023

           IF SQLCA.sqlcode THEN
              LET l_tag05 = NULL
              LET l_n_aag02 = NULL
              LET l_n_aag13 = NULL
           END IF
        END IF
     END IF
     #No.FUN-BC0120--End--

     INSERT INTO maj_file(maj01,maj02,maj03,maj09,maj04,maj06,maj05,
                          maj07,maj08,maj20,maj20e,maj21,maj22, maj23,maj11   #No.MOD-510153
                         ,maj32,maj33,maj34,maj35)                            #No.FUN-BC0120
                   VALUES(g_mai.mai01,seq,'1','+',0,'3',space_col,
                          l_aag06,1,l_aag02,l_aag13,l_aag01,l_aag01,l_aag04,'N'    #No.MOD-510153
                         ,l_n_aag02,l_n_aag13,l_tag05,l_tag05)                     #No.FUN-BC0120
     IF SQLCA.sqlcode THEN
#       CALL cl_err('insert maj error:',STATUS,0)   #No.FUN-660123
        CALL cl_err3("ins","maj_file",g_mai.mai01,seq,STATUS,"","insert maj error:",1)  #No.FUN-660123
        LET l_success = 'N'
        EXIT FOREACH
     END IF
     LET seq = seq+i
  END FOREACH
  IF l_success = 'Y' THEN
     COMMIT WORK
  ELSE
     ROLLBACK WORK
   END IF
    CALL i116_b_fill('1=1')                 #單身
END FUNCTION
 
FUNCTION i116_copy()
DEFINE
    l_mai               RECORD LIKE mai_file.*,
    l_oldno,l_newno     LIKE mai_file.mai01,
    l_i,l_n             LIKE type_file.num5,          #No.FUN-680098  SMALLINT
    l_maj               RECORD LIKE maj_file.*
 
    IF s_aglshut(0) THEN RETURN END IF
    IF g_mai.mai01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE      #FUN-580026
    CALL i116_set_entry('a')             #FUN-580026
    LET g_before_input_done = TRUE       #FUN-580026
   #DISPLAY "" AT 1,1
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0029 
 
    INPUT l_newno FROM mai01
        AFTER FIELD mai01
            IF l_newno IS NULL THEN
                NEXT FIELD mai01
            END IF
            SELECT count(*) INTO g_cnt FROM mai_file
                WHERE mai01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD mai01
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_mai.mai01
        RETURN
    END IF
    LET l_mai.* = g_mai.*
    LET l_mai.mai01  =l_newno   #新的鍵值
    LET l_mai.maiuser=g_user    #資料所有者
    LET l_mai.maigrup=g_grup    #資料所有者所屬群
    LET l_mai.maimodu=NULL      #資料修改日期
    LET l_mai.maidate=g_today   #資料建立日期
    LET l_mai.maiacti='Y'       #有效資料
    LET l_mai.maioriu = g_user      #No.FUN-980030 10/01/04
    LET l_mai.maiorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO mai_file VALUES (l_mai.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err('mai:',SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("ins","mai_file",l_newno,"",SQLCA.sqlcode,"","mai:",1)  #No.FUN-660123
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM maj_file         #單身複製
        WHERE maj01=g_mai.mai01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_mai.mai01,SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("ins","x",g_mai.mai01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
        RETURN
    END IF
    UPDATE x
        SET maj01=l_newno
    LET g_sql = 'SELECT * FROM x'
    PREPARE i116_p2 FROM g_sql
    DECLARE i116_copy_c CURSOR FOR i116_p2
    LET g_cnt=0
    FOREACH i116_copy_c INTO l_maj.*
       MESSAGE l_maj.maj06
       LET g_cnt=g_cnt+1
       INSERT INTO maj_file VALUES (l_maj.*)
    END FOREACH
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_mai.mai01
     SELECT mai_file.* INTO g_mai.* FROM mai_file WHERE mai01 = l_newno
     CALL i116_u()
     CALL i116_b('a')
     #SELECT mai_file.* INTO g_mai.* FROM mai_file WHERE mai01 = l_oldno  #FUN-C30027
     #CALL i116_show()  #FUN-C30027
END FUNCTION
 
FUNCTION i116_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680098 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("maj01",TRUE)
    END IF
 
    #No.FUN-BC0120--Begin--
    IF p_cmd = 'c' THEN
       CALL cl_set_comp_entry("year",TRUE)
       CALL cl_set_comp_required("year",TRUE)
    END IF
    #No.FUN-BC0120--End--
END FUNCTION
 
FUNCTION i116_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("maj01",FALSE)
    END IF

    #No.FUN-BC0120--Begin--
    IF p_cmd = 'c' THEN
       CALL cl_set_comp_entry("year",FALSE)
       CALL cl_set_comp_required("year",FALSE)
    END IF
    #No.FUN-BC0120--End-- 
END FUNCTION
 
FUNCTION i116_out()
DEFINE l_i             LIKE type_file.num5,   #No.FUN-680098  SMALLIT
       mai             RECORD LIKE mai_file.*,
       maj             RECORD LIKE maj_file.*,
       l_name          LIKE type_file.chr20,  #External(Disk) file name   #No.FUN-680098 VARCHAR(20)
       l_msg           LIKE type_file.chr1000 #No.FUN-680098   VARCHAR(22)
 
   IF g_wc IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   #CALL cl_outnam('agli116') RETURNING l_name              #No.FUN-760085
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog #No.FUN-760085
   LET g_sql = "SELECT mai_file.*, maj_file.*",
               "  FROM mai_file,maj_file",
               " WHERE mai01 = maj01 AND ",g_wc CLIPPED,
               "   AND ",g_wc2 CLIPPED
   CALL cl_wait()
 
   #No.FUN-760085---Begin
   #PREPARE i116_p1 FROM g_sql                # RUNTIME 編譯
   #DECLARE i116_co CURSOR FOR i116_p1
 
   #START REPORT i116_rep TO l_name
 
   #FOREACH i116_co INTO mai.*, maj.*
   #   IF SQLCA.sqlcode THEN
   #      CALL cl_err('foreach:',SQLCA.sqlcode,1)   
   #      EXIT FOREACH
   #   END IF
 
   #   IF mai.mai01 IS NULL THEN
   #      LET mai.mai01 = ' '
   #   END IF
 
   #   OUTPUT TO REPORT i116_rep(mai.*, maj.*)
 
   #END FOREACH
 
   #FINISH REPORT i116_rep
 
   #CLOSE i116_co
   #CALL cl_prt(l_name,' ','1',g_len)
   #MESSAGE ""
   IF g_zz05 = 'Y' THEN                                                         
      CALL cl_wcchp(g_wc,'mai01,mai02,mai00,mai03')           
           RETURNING l_str                                                      
   END IF                                                                       
   CALL cl_prt_cs1('agli116','agli116',g_sql,l_str)
   #No.FUN-760085---End
END FUNCTION
 
#No.FUN-760085---Begin
{
REPORT i116_rep(mai, maj)
   DEFINE mai             RECORD LIKE mai_file.*,
          maj             RECORD LIKE maj_file.*,
          l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680098    VARCHAR(1)
          l_i             LIKE type_file.num5,          #No.FUN-680098    SMALLINT
          l_line          LIKE type_file.num5,          #No.FUN-680098    SMALLINT
          l_str           LIKE zaa_file.zaa08         #No.FUN-680098    VARCHAR(10) 
   DEFINE g_head1         STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY mai.mai01, maj.maj02
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT ' '
         PRINT g_dash[1,g_len]
         CASE
              WHEN mai.mai03 = '1' LET l_str =  g_x[12] CLIPPED
              WHEN mai.mai03 = '2' LET l_str =  g_x[13] CLIPPED
              WHEN mai.mai03 = '3' LET l_str =  g_x[14] CLIPPED
              WHEN mai.mai03 = '4' LET l_str =  g_x[15] CLIPPED
         END CASE
         LET g_head1 = g_x[9] CLIPPED,mai.mai01,'     ',
                       g_x[10] CLIPPED,mai.mai02,'     ',
                       g_x[16] CLIPPED,mai.mai00,'     ',  #No.FUN-730020
                       g_x[11] CLIPPED,mai.mai03,'     ',l_str
         PRINT g_head1
         SKIP 1 LINES
         PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
                          g_x[37],g_x[38],g_x[39],g_x[40]
         PRINTX name = H2 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
                          g_x[47],g_x[48]
         PRINT g_dash1
         LET l_trailer_sw = 'y'
 
      BEFORE GROUP OF mai.mai01
         SKIP TO TOP OF PAGE
 
      ON EVERY ROW
      #No.TQC-740332  --Begin
       IF g_mai.maiacti = 'N' THEN
          PRINTX name = D1 COLUMN g_c[31],'*',maj.maj02 USING '###&';
       ELSE  
          PRINTX name = D1 COLUMN g_c[31],maj.maj02 USING '###&'; #FUN-590118
       END IF
          PRINTX name = D1 COLUMN g_c[32],maj.maj03,
      #No.TQC-740332  --End
                          COLUMN g_c[33],maj.maj04 USING '#&',
                          COLUMN g_c[34],maj.maj05 USING '#&',
                          COLUMN g_c[35],maj.maj07,
                          COLUMN g_c[36],maj.maj20,
                          COLUMN g_c[37],maj.maj21,
                          COLUMN g_c[38],maj.maj24,
                          COLUMN g_c[39],maj.maj11,
                          COLUMN g_c[40],maj.maj08 USING '########' #No.MOD-590002
         PRINTX name = D2 COLUMN g_c[42],maj.maj06,
                          COLUMN g_c[44],maj.maj20e,
                          COLUMN g_c[45],maj.maj22,
                          COLUMN g_c[46],maj.maj25,
                          COLUMN g_c[48],maj.maj23
 
      ON LAST ROW
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
         LET l_trailer_sw = 'n'
 
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT}
#No.FUN-760085---End 
#Patch....NO.MOD-5A0095 <001,002,003,004,005,006,007> #
