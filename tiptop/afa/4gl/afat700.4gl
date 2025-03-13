# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afat700.4gl
# Descriptions...: 投資抵減申請作業
# Date & Author..: 96/05/08  BY Star
# Modify.........: 98/08/11  BY Carol
#                  t700_suren() 中update fcc20='1' 改為 fcc20='2'
#                  t700_putb() 中設定 fcc20='1' 改為 fcc20='2'
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-490229 04/09/13 By Nicola g_sql長度不足
# Modify.........: No.MOD-490344 04/09/20 By Kitty controlp 少display補入
# Modify.........: No.MOD-490227 04/09/27 By Kitty 執行國稅局核准復原,資料更新不成功
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-4A0133 04/10/08 By Kitty  無法自動產生單
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0008 04/12/02 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.MOD-530831 05/03/29 By Smapmin 單身原幣成本未自動帶出,
#                                                    管理局核准後回AFAT700單頭管理局核准及核准號碼未REFRESH
# Modify.........: No.FUN-540057 05/05/09 By ice 發票號碼加大到16位
# Modify.........: NO.FUN-550034 05/05/20 By jackie 單據編號加大
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-560146 05/06/21 By Nicola 不需套用單據編號規則
# Modify.........: No.MOD-560011 05/07/27 By Smapmin 管理局或國稅局其一核準即可
# Modify.........: No.FUN-570211 05/08/10 By Dido 增加設備或技術來源欄位維護
# Modify.........: No.MOD-580325 05/08/29 By day  將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.MOD-580380 05/10/07 By Smapmin 狀態回寫調整
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.MOD-670086 06/07/18 By Smapmin 用途開窗查詢有誤
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0001 06/10/11 By jamie FUNCTION t700_q() 一開始應清空g_fcb.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-710028 07/01/26 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-730115 07/03/30 By Judy 該作業可以抓取到未審核的資料
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760182 07/06/27 By chenl   自動產生QBE不可為空。
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-850068 08/05/14 By TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-940087 09/04/11 By Sarah 輸入單身時需檢查財產+附號不可存在fci_file
# Modify.........: No.FUN-980003 09/08/12 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980098 09/08/13 By mike 將l_sql里的fajconf拿掉   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-AB0268 10/11/29 By lixia 修改“語言”按鈕是灰的，不能切換語言別
# Modify.........: No.MOD-B30203 11/03/16 By lixia 財編是否存在faj_file的SQL請增加判斷faj42='1'條件
# Modify.........: No.MOD-B30360 11/03/16 By lixia 核准還原修改
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50118 11/06/14 By belle 自動產生鍵,增加QBE條件-族群編號

 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/08 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20035 13/02/22 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_fcb           RECORD LIKE fcb_file.*,       #投資抵減單 (假單頭)
    g_fcb_t         RECORD LIKE fcb_file.*,       #投資抵減單 (舊值)
    g_fcb_o         RECORD LIKE fcb_file.*,       #投資抵減單 (舊值)
    g_fcb01_t       LIKE fcb_file.fcb01,          #投資抵減單申請號碼 (舊值)
    g_feature       LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(01)
    g_fcc           DYNAMIC ARRAY OF RECORD               #程式變數(Program Variables)
                       fcc02       LIKE fcc_file.fcc02,   #項次
                       fcc03       LIKE fcc_file.fcc03,   #財產編號
                       fcc031      LIKE fcc_file.fcc031,  #附號
                       fcc05       LIKE fcc_file.fcc05,   #中文名稱
                       fcc06       LIKE fcc_file.fcc06,   #英文名稱
                       fcc07       LIKE fcc_file.fcc07,   #規格型號
                       fcc26       LIKE fcc_file.fcc26,   #設備或技術來源 #No.FUN-570211
                       fcc04       LIKE fcc_file.fcc04,   #合併碼
                       fcc08       LIKE fcc_file.fcc08,   #廠商名稱
                       fcc09       LIKE fcc_file.fcc09,   #數量
                       fcc10       LIKE fcc_file.fcc10,   #單位
                       fcc191      like fcc_file.fcc191,  #安裝日
                       faj49       LIKE faj_file.faj49,   #進口編號
                       faj51       LIKE faj_file.faj51,   #發票號碼
                       fcc11       LIKE fcc_file.fcc11,   #用途
                       fcc12       LIKE fcc_file.fcc12,   #備註
                       faj20       LIKE faj_file.faj20,   #保管部門
                       fcc13       LIKE fcc_file.fcc13,   #原幣成本
                       fcc14       LIKE fcc_file.fcc14,   #原幣幣別
                       fcc15       LIKE fcc_file.fcc15,   #抵減率
                       fcc16       LIKE fcc_file.fcc16,   #本幣成本
                       fcc17       LIKE fcc_file.fcc17,   #契約日期
                       fcc18       LIKE fcc_file.fcc18,   #I/L 日期
                       fcc19       LIKE fcc_file.fcc19,   #交貨日期
                       faj04       LIKE faj_file.faj04,   #資產類別
                       fcc20       LIKE fcc_file.fcc20,   #抵減狀態
                       #FUN-850068 --start---
                       fccud01     LIKE fcc_file.fccud01,
                       fccud02     LIKE fcc_file.fccud02,
                       fccud03     LIKE fcc_file.fccud03,
                       fccud04     LIKE fcc_file.fccud04,
                       fccud05     LIKE fcc_file.fccud05,
                       fccud06     LIKE fcc_file.fccud06,
                       fccud07     LIKE fcc_file.fccud07,
                       fccud08     LIKE fcc_file.fccud08,
                       fccud09     LIKE fcc_file.fccud09,
                       fccud10     LIKE fcc_file.fccud10,
                       fccud11     LIKE fcc_file.fccud11,
                       fccud12     LIKE fcc_file.fccud12,
                       fccud13     LIKE fcc_file.fccud13,
                       fccud14     LIKE fcc_file.fccud14,
                       fccud15     LIKE fcc_file.fccud15
                       #FUN-850068 --end--
                    END RECORD,
    g_fcc_t         RECORD                                #程式變數 (舊值)
                       fcc02       LIKE fcc_file.fcc02,   #項次
                       fcc03       LIKE fcc_file.fcc03,   #財產編號
                       fcc031      LIKE fcc_file.fcc031,  #附號
                       fcc05       LIKE fcc_file.fcc05,   #中文名稱
                       fcc06       LIKE fcc_file.fcc06,   #英文名稱
                       fcc07       LIKE fcc_file.fcc07,   #規格型號
                       fcc26       LIKE fcc_file.fcc26,   #設備或技術來源 #No.FUN-570211
                       fcc04       LIKE fcc_file.fcc04,   #合併碼
                       fcc08       LIKE fcc_file.fcc08,   #廠商名稱
                       fcc09       LIKE fcc_file.fcc09,   #數量
                       fcc10       LIKE fcc_file.fcc10,   #單位
                       fcc191      like fcc_file.fcc191,  #安裝日
                       faj49       LIKE faj_file.faj49,                  #進口編號
                       faj51       LIKE faj_file.faj51,                  #發票號碼
                       fcc11       LIKE fcc_file.fcc11,   #用途
                       fcc12       LIKE fcc_file.fcc12,   #備註
                       faj20       LIKE faj_file.faj20,   #保管部門
                       fcc13       LIKE fcc_file.fcc13,   #原幣成本
                       fcc14       LIKE fcc_file.fcc14,   #原幣幣別
                       fcc15       LIKE fcc_file.fcc15,   #抵減率
                       fcc16       LIKE fcc_file.fcc16,   #本幣成本
                       fcc17       LIKE fcc_file.fcc17,   #契約日期
                       fcc18       LIKE fcc_file.fcc18,   #I/L 日期
                       fcc19       LIKE fcc_file.fcc19,   #交貨日期
                       faj04       LIKE faj_file.faj04,   #資產類別
                       fcc20       LIKE fcc_file.fcc20,   #抵減狀態
                       #FUN-850068 --start---
                       fccud01     LIKE fcc_file.fccud01,
                       fccud02     LIKE fcc_file.fccud02,
                       fccud03     LIKE fcc_file.fccud03,
                       fccud04     LIKE fcc_file.fccud04,
                       fccud05     LIKE fcc_file.fccud05,
                       fccud06     LIKE fcc_file.fccud06,
                       fccud07     LIKE fcc_file.fccud07,
                       fccud08     LIKE fcc_file.fccud08,
                       fccud09     LIKE fcc_file.fccud09,
                       fccud10     LIKE fcc_file.fccud10,
                       fccud11     LIKE fcc_file.fccud11,
                       fccud12     LIKE fcc_file.fccud12,
                       fccud13     LIKE fcc_file.fccud13,
                       fccud14     LIKE fcc_file.fccud14,
                       fccud15     LIKE fcc_file.fccud15
                       #FUN-850068 --end--
                    END RECORD,
     g_wc,g_wc2,g_sql    STRING,     #No.MOD-490229
    g_rec_b         LIKE type_file.num5,                #單身筆數       #No.FUN-680070 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_cmd           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(200)
    l_faj           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                       fajyn       LIKE type_file.chr1,                 #是否要投入 fci_file       #No.FUN-680070 VARCHAR(1)
                       faj02       LIKE faj_file.faj02,   #財產編號
                       faj022      LIKE faj_file.faj022,  #附號
                       faj06       LIKE faj_file.faj06,   #中文名稱
                       faj07       LIKE faj_file.faj07,    #英文名稱
                       faj26       LIKE faj_file.faj26,   #入帳日期
                       faj51       LIKE faj_file.faj51,   #發票號碼
                       faj17       LIKE faj_file.faj17,   #數量
                       faj18       LIKE faj_file.faj18,   #單位
                       faj14       LIKE faj_file.faj14    #成本
                    END RECORD,
    l_faj_t         RECORD                 #程式變數(Program Variables)
                       fajyn       LIKE type_file.chr1,                 #是否要投入 fci_file       #No.FUN-680070 VARCHAR(1)
                       faj02       LIKE faj_file.faj02,   #財產編號
                       faj022      LIKE faj_file.faj022,  #附號
                       faj06       LIKE faj_file.faj06,   #中文名稱
                       faj07       LIKE faj_file.faj07,   #英文名稱
                       faj26       LIKE faj_file.faj26,   #入帳日期
                       faj51       LIKE faj_file.faj51,   #發票號碼
                       faj17       LIKE faj_file.faj17,   #數量
                       faj18       LIKE faj_file.faj18,   #單位
                       faj14       LIKE faj_file.faj14    #成本
                    END RECORD,
       g_faj17_faj58 LIKE faj_file.faj17   #未銷帳數量
 
   DEFINE   l_priv2         LIKE zy_file.zy04      #使用者資料權限
   DEFINE   l_priv3         LIKE zy_file.zy05      #使用部門資料權限
   DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
   DEFINE   g_before_input_done LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE   g_chr           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
   DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
   DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
   DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
   DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
   DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
   DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE l_msg LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(60)
   DEFINE l_msg1 LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(30)
   DEFINE l_msg2 LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(30)
   DEFINE l_msg3 LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(30)
 
#主程式開始
MAIN
#   DEFINE l_time           LIKE type_file.chr8                    #計算被使用時間       #No.FUN-680070 VARCHAR(8) #NO.FUN-6A0069
   DEFINE p_row,p_col   LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                                           #NO.FUN-6A0069      
 
    LET g_forupd_sql = " SELECT * FROM fcb_file WHERE fcb01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t700_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col =10
    OPEN WINDOW t700_w AT p_row,p_col              #顯示畫面
        WITH FORM "afa/42f/afat700"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL t700_menu()
    CLOSE WINDOW t700_w                 #結束畫面
      CALL cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                #NO.FUN-6A0069
END MAIN
 
#QBE 查詢資料
FUNCTION t700_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    CLEAR FORM                             #清除畫面
    CALL g_fcc.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_fcb.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
        fcb01,fcb02,fcb03,fcb04,fcb05,fcb06,
        fcbconf,fcbuser,fcbgrup,fcbmodu,fcbdate,
        #FUN-850068   ---start---
        fcbud01,fcbud02,fcbud03,fcbud04,fcbud05,
        fcbud06,fcbud07,fcbud08,fcbud09,fcbud10,
        fcbud11,fcbud12,fcbud13,fcbud14,fcbud15
        #FUN-850068    ----end----
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
  END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND fcbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND fcbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND fcbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fcbuser', 'fcbgrup')
    #End:FUN-980030
 
    #--->螢幕上取單身條件
# No.FUN-570211 新增 fcc26 欄位
    CONSTRUCT g_wc2 ON fcc02,fcc03,fcc031,fcc05,fcc06,fcc07,fcc26,fcc04,
                       fcc08,fcc09,fcc10,fcc191,fcc11,fcc12,
                       fcc13,fcc14,fcc15,fcc16,fcc17,fcc18,fcc19,fcc20
                       #No.FUN-850068 --start--
                       ,fccud01,fccud02,fccud03,fccud04,fccud05
                       ,fccud06,fccud07,fccud08,fccud09,fccud10
                       ,fccud11,fccud12,fccud13,fccud14,fccud15
                       #No.FUN-850068 ---end---
                 FROM  s_fcc[1].fcc02,
                       s_fcc[1].fcc03,s_fcc[1].fcc031,
                       s_fcc[1].fcc05,s_fcc[1].fcc06,
                       s_fcc[1].fcc07,s_fcc[1].fcc26,
                       s_fcc[1].fcc04,s_fcc[1].fcc08,
                       s_fcc[1].fcc09,s_fcc[1].fcc10,s_fcc[1].fcc191,
                       s_fcc[1].fcc11,s_fcc[1].fcc12,s_fcc[1].fcc13,
                       s_fcc[1].fcc14,s_fcc[1].fcc15,s_fcc[1].fcc16,
                       s_fcc[1].fcc17,s_fcc[1].fcc18,s_fcc[1].fcc19,
                       s_fcc[1].fcc20
                       #No.FUN-850068 --start--
                       ,s_fcc[1].fccud01,s_fcc[1].fccud02,s_fcc[1].fccud03
                       ,s_fcc[1].fccud04,s_fcc[1].fccud05,s_fcc[1].fccud06
                       ,s_fcc[1].fccud07,s_fcc[1].fccud08,s_fcc[1].fccud09
                       ,s_fcc[1].fccud10,s_fcc[1].fccud11,s_fcc[1].fccud12
                       ,s_fcc[1].fccud13,s_fcc[1].fccud14,s_fcc[1].fccud15
                       #No.FUN-850068 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
            WHEN INFIELD(fcc03)    #查詢資產資料
                 CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_faj1"   #TQC-730115
                 LET g_qryparam.form = "q_faj11"  #TQC-730115
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fcc03
                 NEXT FIELD fcc03
              WHEN INFIELD(fcc11)    #查詢用途資料
                 CALL q_fai(TRUE,TRUE,g_fcc[1].fcc11)
                 #RETURNING g_fcc[1].fcc11   #MOD-670086
                 #DISPLAY g_fcc[1].fcc11 TO fcc11   #MOD-670086
                 RETURNING g_qryparam.multiret   #MOD-670086
                 DISPLAY g_qryparam.multiret TO fcc11   #MOD-670086
                 NEXT FIELD fcc11
              WHEN INFIELD(fcc14)    #查詢幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_azi"
                 #LET g_qryparam.default1 = g_fcc[1].fcc14
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fcc14
                 NEXT FIELD fcc14
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
    IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
       LET g_sql = "SELECT fcb01 FROM fcb_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE                                       # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE fcb01 ",
                   "  FROM fcb_file, fcc_file",
                   " WHERE fcb01 = fcc01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE t700_prepare FROM g_sql
    DECLARE t700_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t700_prepare
 
    IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM fcb_file WHERE ",g_wc CLIPPED
    ELSE
       LET g_sql="SELECT COUNT(DISTINCT fcb01) FROM fcb_file,fcc_file WHERE ",
                 "fcc01=fcb01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t700_pre FROM g_sql
    DECLARE t700_count CURSOR WITH HOLD FOR t700_pre
END FUNCTION
 
FUNCTION t700_menu()
 
   WHILE TRUE
      CALL t700_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t700_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t700_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t700_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t700_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t700_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t700_x()             #FUN-D20035
               CALL t700_x(1)           #FUN-D20035
            END IF

          #FUN-D20035---add--str
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t700_x(2)
            END IF
         #FUN-D20035---add---end

         WHEN "auto_generate"
            IF cl_chk_act_auth() THEN
               CALL t700_g(3,5)
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t700_sure('Y')
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t700_sure('N')
            END IF
         WHEN "admin_appr"
             #IF cl_chk_act_auth()  AND cl_null(g_fcb.fcb05) AND cl_null(g_fcb.fcb06)  AND g_fcb.fcbconf != 'X' THEN   #MOD-560011
             #IF cl_chk_act_auth()  AND cl_null(g_fcb.fcb03) AND cl_null(g_fcb.fcb04)  AND g_fcb.fcbconf != 'X' THEN    #MOD-560011  #MOD-580380
             IF cl_chk_act_auth()  AND g_fcb.fcbconf != 'X' THEN     #MOD-580380
               LET l_cmd = 'afap700 ',g_fcb.fcb01
                #CALL cl_cmdrun(l_cmd)   #MOD-530831
                CALL cl_cmdrun_wait(l_cmd)   #MOD-530831 管理局核准後回AFAT700 REFRESH 單頭管理局核准及核准號碼
               CALL t700_re()
            END IF
         WHEN "ira_appr"
             #IF cl_chk_act_auth()  AND g_fcb.fcbconf != 'X'  THEN   #MOD-560011
             #IF cl_chk_act_auth()  AND cl_null(g_fcb.fcb05) AND cl_null(g_fcb.fcb06) AND g_fcb.fcbconf != 'X'  THEN    #MOD-560011   #MOD-580380
             IF cl_chk_act_auth()  AND g_fcb.fcbconf != 'X'  THEN   #MOD-580380
               LET l_cmd = 'afap710 ',g_fcb.fcb01
                #CALL cl_cmdrun(l_cmd)   #MOD-530831
                CALL cl_cmdrun_wait(l_cmd)   #MOD-530831 國稅局核准後回AFAT700 REFRESH 單頭國稅局核准及核准號碼
               CALL t700_re()
            END IF
         WHEN "undo_admin_appr"
            IF cl_chk_act_auth() THEN
               CALL t700_3()
               CALL t700_re()
            END IF
         WHEN "undo_ira_appr"
            IF cl_chk_act_auth() THEN
               CALL t700_4()
               CALL t700_re()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fcb.fcb01 IS NOT NULL THEN
                  LET g_doc.column1 = "fcb01"
                  LET g_doc.value1 = g_fcb.fcb01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fcc),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t700_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_fcc.clear()
    INITIALIZE g_fcb.* TO NULL
    LET g_fcb01_t = NULL
    LET g_fcb_o.* = g_fcb.*
    LET g_fcb_t.* = g_fcb.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fcb.fcb02  =g_today
        LET g_fcb.fcbconf='N'              #confirm碼無效
        LET g_fcb.fcbprsw=0
        LET g_fcb.fcbuser=g_user
        LET g_fcb.fcboriu = g_user #FUN-980030
        LET g_fcb.fcborig = g_grup #FUN-980030
        LET g_fcb.fcbgrup=g_grup
        LET g_fcb.fcbdate=g_today
        LET g_fcb.fcblegal= g_legal    #FUN-980003 add
        CALL t700_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            INITIALIZE g_fcb.* TO NULL
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_fcb.fcb01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO fcb_file VALUES (g_fcb.*)
        IF SQLCA.sqlcode THEN                           #置入資料庫不成功
#           CALL cl_err(g_fcb.fcb01,SQLCA.sqlcode,1)   #No.FUN-660136
            CALL cl_err3("ins","fcb_file",g_fcb.fcb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        SELECT fcb01 INTO g_fcb.fcb01 FROM fcb_file
         WHERE fcb01 = g_fcb.fcb01
        LET g_fcb_t.* = g_fcb.*
        LET g_rec_b = 0
        CALL t700_b()                   #輸入單身
        LET g_fcb01_t = g_fcb.fcb01        #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t700_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fcb.fcb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_fcb.fcbconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    SELECT * INTO g_fcb.* FROM fcb_file WHERE fcb01 = g_fcb.fcb01
    IF g_fcb.fcbconf = 'Y' THEN RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fcb01_t = g_fcb.fcb01
    LET g_fcb_o.* = g_fcb.*
    BEGIN WORK
 
    OPEN t700_cl USING g_fcb.fcb01
    IF STATUS THEN
       CALL cl_err("OPEN t700_cl:", STATUS, 1)
       CLOSE t700_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t700_cl INTO g_fcb.*              # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fcb.fcb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t700_cl ROLLBACK WORK RETURN
    END IF
    CALL t700_show()
    WHILE TRUE
        LET g_fcb01_t = g_fcb.fcb01
        LET g_fcb.fcbmodu=g_user
        LET g_fcb.fcbdate=g_today
        CALL t700_i("u")                      #欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_fcb.*=g_fcb_t.*
           CALL t700_show()
            CALL cl_err('','9001',0)
           EXIT WHILE
        END IF
        IF g_fcb.fcb01 != g_fcb01_t THEN            # 更改單號
            UPDATE fcc_file SET fcc01 = g_fcb.fcb01
                WHERE fcc01 = g_fcb01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('fcc',SQLCA.sqlcode,0)    #No.FUN-660136
                CALL cl_err3("upd","fcc_file",g_fcb01_t,"",SQLCA.sqlcode,"","fcc",1)  #No.FUN-660136
                CONTINUE WHILE
            END IF
        END IF
        UPDATE fcb_file SET fcb_file.* = g_fcb.*
            WHERE fcb01 = g_fcb.fcb01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_fcb.fcb01,SQLCA.sqlcode,0)   #No.FUN-660136
            CALL cl_err3("upd","fcb_file",g_fcb01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t700_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION t700_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
    l_n1            LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
 
    DISPLAY BY NAME g_fcb.fcb01,g_fcb.fcb02,g_fcb.fcb03,g_fcb.fcb04,
                    g_fcb.fcb05,g_fcb.fcb06,
                    g_fcb.fcbuser,g_fcb.fcbmodu,g_fcb.fcbgrup,
                    g_fcb.fcbdate,g_fcb.fcbconf
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
    INPUT BY NAME g_fcb.fcb01,g_fcb.fcb02, g_fcb.fcboriu,g_fcb.fcborig,
                  #FUN-850068     ---start---
                  g_fcb.fcbud01,g_fcb.fcbud02,g_fcb.fcbud03,g_fcb.fcbud04,
                  g_fcb.fcbud05,g_fcb.fcbud06,g_fcb.fcbud07,g_fcb.fcbud08,
                  g_fcb.fcbud09,g_fcb.fcbud10,g_fcb.fcbud11,g_fcb.fcbud12,
                  g_fcb.fcbud13,g_fcb.fcbud14,g_fcb.fcbud15 
                  #FUN-850068     ----end----
        WITHOUT DEFAULTS
       ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()   #FUN-550037(smin)
 
 
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t700_set_entry(p_cmd)
           CALL t700_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
#No.FUN-550034 --start--
        #CALL cl_set_docno_format("fcb01")   #No.FUN-560146 Mark
#No.FUN-550034 ---end---
 
        AFTER FIELD fcb01              #檔案名稱: 固定資產投資抵減單頭檔
           IF NOT cl_null(g_fcb.fcb01) THEN
              IF p_cmd='a' OR (p_cmd='u' AND g_fcb.fcb01!=g_fcb01_t) THEN
                 SELECT COUNT(*) INTO g_cnt FROM fcb_file
                  WHERE fcb01 = g_fcb.fcb01
                 IF g_cnt > 0 THEN   #資料重複
                    CALL cl_err(g_fcb.fcb01,-239,0)
                    LET g_fcb.fcb01 = g_fcb01_t
                    DISPLAY BY NAME g_fcb.fcb01
                    NEXT FIELD fcb01
                 END IF
              END IF
           END IF
           LET g_fcb_o.fcb01 = g_fcb.fcb01
 
        #FUN-850068     ---start---
        AFTER FIELD fcbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fcbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fcbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fcbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fcbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fcbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fcbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fcbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fcbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fcbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fcbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fcbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fcbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fcbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fcbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-850068     ----end----
 
        AFTER INPUT   #97/05/22 modify
           LET g_fcb.fcbuser = s_get_data_owner("fcb_file") #FUN-C10039
           LET g_fcb.fcbgrup = s_get_data_group("fcb_file") #FUN-C10039
          IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #MOD-650015 --start 
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(fcb01) THEN
       #         LET g_fcb.* = g_fcb_t.*
       #         DISPLAY BY NAME g_fcb.*
       #         NEXT FIELD fcb01
       #     END IF
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
 
FUNCTION t700_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fcb01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t700_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fcb01",FALSE)
    END IF
 
END FUNCTION
 
#Query 查詢
FUNCTION t700_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fcb.* TO NULL             #No.FUN-6A0001
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t700_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_fcb.* TO NULL
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t700_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_fcb.* TO NULL
    ELSE
       OPEN t700_count
       FETCH t700_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t700_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t700_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t700_cs INTO g_fcb.fcb01
        WHEN 'P' FETCH PREVIOUS t700_cs INTO g_fcb.fcb01
        WHEN 'F' FETCH FIRST    t700_cs INTO g_fcb.fcb01
        WHEN 'L' FETCH LAST     t700_cs INTO g_fcb.fcb01
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
            FETCH ABSOLUTE g_jump t700_cs INTO g_fcb.fcb01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fcb.fcb01,SQLCA.sqlcode,0)
        INITIALIZE g_fcb.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_fcb.* FROM fcb_file WHERE fcb01 = g_fcb.fcb01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fcb.fcb01,SQLCA.sqlcode,0)   #No.FUN-660136
        CALL cl_err3("sel","fcb_file",g_fcb.fcb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
        INITIALIZE g_fcb.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_fcb.fcbuser   #FUN-4C0059
    LET g_data_group = g_fcb.fcbgrup   #FUN-4C0059
    CALL t700_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t700_show()
    LET g_fcb_t.* = g_fcb.*                #保存單頭舊值
    DISPLAY BY NAME g_fcb.fcboriu,g_fcb.fcborig,                              # 顯示單頭值
 
        g_fcb.fcb01,g_fcb.fcb02,g_fcb.fcb03,
        g_fcb.fcb04,g_fcb.fcb05,g_fcb.fcb06,
        g_fcb.fcbuser,g_fcb.fcbgrup,g_fcb.fcbmodu,
        g_fcb.fcbdate,g_fcb.fcbconf,
        #FUN-850068     ---start---
        g_fcb.fcbud01,g_fcb.fcbud02,g_fcb.fcbud03,g_fcb.fcbud04,
        g_fcb.fcbud05,g_fcb.fcbud06,g_fcb.fcbud07,g_fcb.fcbud08,
        g_fcb.fcbud09,g_fcb.fcbud10,g_fcb.fcbud11,g_fcb.fcbud12,
        g_fcb.fcbud13,g_fcb.fcbud14,g_fcb.fcbud15 
        #FUN-850068     ----end----
 
    IF g_fcb.fcbconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_fcb.fcbconf,"","","",g_chr,"")
 
    CALL t700_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t700_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_fcb.fcb01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_fcb.fcbconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    SELECT * INTO g_fcb.* FROM fcb_file WHERE fcb01 = g_fcb.fcb01
    IF g_fcb.fcbconf='Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    BEGIN WORK
 
       OPEN t700_cl USING g_fcb.fcb01
       IF STATUS THEN
          CALL cl_err("OPEN t700_cl:", STATUS, 1)
          CLOSE t700_cl
          ROLLBACK WORK
          RETURN
       END IF
       FETCH t700_cl INTO g_fcb.*
       IF SQLCA.sqlcode THEN
         CALL cl_err(g_fcb.fcb01,SQLCA.sqlcode,0)
         CLOSE t700_cl ROLLBACK WORK RETURN
       END IF
       LET g_success ='Y'
       CALL t700_show()
       IF cl_delh(20,16)  THEN
           INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
           LET g_doc.column1 = "fcb01"         #No.FUN-9B0098 10/02/24
           LET g_doc.value1 = g_fcb.fcb01      #No.FUN-9B0098 10/02/24
           CALL cl_del_doc()                                                #No.FUN-9B0098 10/02/24
           MESSAGE "Delete fcb,fcc!"
           DELETE FROM fcb_file WHERE fcb01 = g_fcb.fcb01
           IF STATUS THEN
                #CALL cl_err('No fcb deleted','',0)   #No.+045 010403 by plum  
#             CALL cl_err('No fcb deleted',SQLCA.SQLCODE,0)   #No.FUN-660136
              CALL cl_err3("del","fcb_file",g_fcb.fcb01,"",SQLCA.sqlcode,"","No fcb deleted",1)  #No.FUN-660136
              LET g_success = 'N'
           ELSE
              DELETE FROM fcc_file WHERE fcc01 = g_fcb.fcb01
              IF STATUS THEN
                 LET g_success = 'N'
              END IF
              LET g_msg=TIME
              CLEAR FORM
              CALL g_fcc.clear()
              INITIALIZE g_fcb.* LIKE fcb_file.*
              OPEN t700_count
              #FUN-B50062-add-start--
              IF STATUS THEN
                 CLOSE t700_cs
                 CLOSE t700_count
                 COMMIT WORK
                 RETURN
              END IF
              #FUN-B50062-add-end--
              FETCH t700_count INTO g_row_count
              #FUN-B50062-add-start--
              IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
                 CLOSE t700_cs
                 CLOSE t700_count
                 COMMIT WORK
                 RETURN
              END IF
              #FUN-B50062-add-end--
              DISPLAY g_row_count TO FORMONLY.cnt
              OPEN t700_cs
              IF g_curs_index = g_row_count + 1 THEN
                 LET g_jump = g_row_count
                 CALL t700_fetch('L')
              ELSE
                 LET g_jump = g_curs_index
                 LET mi_no_ask = TRUE
                 CALL t700_fetch('/')
              END IF
 
           END IF
       END IF
       CLOSE t700_cl
       IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION
 
#單身
FUNCTION t700_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_row,l_col     LIKE type_file.num5,                #分段輸入之行,列數       #No.FUN-680070 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_i             LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_modIFy_flag   LIKE type_file.chr1,                 #單身更改否       #No.FUN-680070 VARCHAR(1)
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    g_cmd           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(100)
    l_chk           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
    l_flag          LIKE type_file.num10,        #No.FUN-680070 INTEGER
    l_cnt1          LIKE type_file.num10,        #No.FUN-680070 INTEGER
    g_cnt1          LIKE type_file.num10,        #No.FUN-680070 INTEGER
    g_cnt2          LIKE type_file.num10,        #No.FUN-680070 INTEGER
    tot_qty         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    tot_Amt         LIKE type_file.num20_6,                   #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
    ntd_tot_amt     LIKE type_file.num20_6,                   #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
    l_faj421,l_faj422 like faj_file.faj421,
    l_fcc           RECORD LIKE fcc_file.*,
    l_faj43         LIKE faj_file.faj43,
    l_faj42         LIKE faj_file.faj42,
    temp            LIKE type_file.dat,          #No.FUN-680070 DATE
    a               LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
     l_faj17         LIKE faj_file.faj17,          #MOD-530831
     l_faj14         LIKE faj_file.faj14,          #MOD-530831
     l_faj16         LIKE faj_file.faj16,          #MOD-530831
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
 
    LET g_action_choice = ""
    IF g_fcb.fcb01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_fcb.fcbconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    IF s_shut(0) OR g_fcb.fcbconf = 'Y' THEN RETURN END IF
    CALL cl_opmsg('b')
#No.FUN-570211 新增 fcc26 欄位
    LET g_forupd_sql = " SELECT fcc02,fcc03,fcc031,fcc05,fcc06,fcc07,fcc26,fcc04,fcc08, ",
                       " fcc09,fcc10,fcc191,'','',fcc11,fcc12,'', ",
                       " fcc13,fcc14,fcc15,fcc16,fcc17,fcc18,fcc19,'',fcc20, ",
                       #No.FUN-850068 --start--
                       " fccud01,fccud02,fccud03,fccud04,fccud05,",
                       " fccud06,fccud07,fccud08,fccud09,fccud10,",
                       " fccud11,fccud12,fccud13,fccud14,fccud15 ", 
                       #No.FUN-850068 ---end---
                       " FROM fcc_file ",
                       " WHERE fcc01=? ",
                       " AND fcc03=?  ",
                       " AND fcc031=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t700_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t =  0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
   #CKP2
   IF g_rec_b=0 THEN CALL g_fcc.clear() END IF
 
 
        INPUT ARRAY g_fcc WITHOUT DEFAULTS FROM s_fcc.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()       #目前筆數
            DISPLAY l_ac TO FORMONLY.cn3
           #LET g_fcc_t.* = g_fcc[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'                 #DEFAULT
            LET l_n  = ARR_COUNT()              #目前的array共有幾筆
            BEGIN WORK
 
            OPEN t700_cl USING g_fcb.fcb01
            IF STATUS THEN
               CALL cl_err("OPEN t700_cl:", STATUS, 1)
               CLOSE t700_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t700_cl INTO g_fcb.*              # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fcb.fcb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t700_cl ROLLBACK WORK RETURN
            END IF
            #IF g_fcc_t.fcc02 IS NOT NULL THEN
             IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_fcc_t.* = g_fcc[l_ac].*  #BACKUP
 
                OPEN t700_bcl USING g_fcb.fcb01, g_fcc_t.fcc03,g_fcc_t.fcc031
                IF STATUS THEN
                   CALL cl_err("OPEN t700_bcl:", STATUS, 1)
                   CLOSE t700_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t700_bcl INTO g_fcc[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_fcc_t.fcc02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                   IF cl_null(g_fcc[l_ac].fcc16) THEN
                      LET g_fcc[l_ac].fcc16 = '1'
                   END IF
                   #---- 進口編號,發票號碼及類別及保管部門 都會隨時從 --#
                   # --- faj_file 帶過來 -----#
                   CALL t700_faj()            # 將財產資料帶入單身
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            #NEXT FIELD fcc02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_fcc[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_fcc[l_ac].* TO s_fcc.*
              CALL g_fcc.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
# No.FUN-570211 新增 fcc26 欄位
             INSERT INTO fcc_file (fcc01,fcc02,fcc03,fcc031,fcc04,fcc05,  #No:BUG-470041 No.MOD-470563
                                  fcc06,fcc07,fcc08,fcc09,fcc10,fcc11,
                                  fcc12,fcc13,fcc14,fcc15,fcc16,fcc17,
                                  fcc18,fcc19,fcc191,fcc20,fcc21,fcc22,
                                  fcc23,fcc24,fcc25,fcc26,fcc27,
                                  #FUN-850068 --start--
                                  fccud01,fccud02,fccud03,fccud04,fccud05,
                                  fccud06,fccud07,fccud08,fccud09,fccud10,
                                  fccud11,fccud12,fccud13,fccud14,fccud15,
                                  #FUN-850068 --end--
                                  fcclegal) #FUN-980003 add
                 VALUES(g_fcb.fcb01,g_fcc[l_ac].fcc02,g_fcc[l_ac].fcc03,
                        g_fcc[l_ac].fcc031,g_fcc[l_ac].fcc04,g_fcc[l_ac].fcc05,
                        g_fcc[l_ac].fcc06,g_fcc[l_ac].fcc07,g_fcc[l_ac].fcc08,
                        g_fcc[l_ac].fcc09,g_fcc[l_ac].fcc10,g_fcc[l_ac].fcc11,
                        g_fcc[l_ac].fcc12,g_fcc[l_ac].fcc13,g_fcc[l_ac].fcc14,
                        g_fcc[l_ac].fcc15,g_fcc[l_ac].fcc16,g_fcc[l_ac].fcc17,
                        g_fcc[l_ac].fcc18,g_fcc[l_ac].fcc19,g_fcc[l_ac].fcc191,
                        g_fcc[l_ac].fcc20,g_fcc[l_ac].fcc09,g_fcc[l_ac].fcc10,
                        g_fcc[l_ac].fcc13,g_fcc[l_ac].fcc16,0,g_fcc[l_ac].fcc26,today,
                        #FUN-850068 --start--
                        g_fcc[l_ac].fccud01,g_fcc[l_ac].fccud02,
                        g_fcc[l_ac].fccud03,g_fcc[l_ac].fccud04,
                        g_fcc[l_ac].fccud05,g_fcc[l_ac].fccud06,
                        g_fcc[l_ac].fccud07,g_fcc[l_ac].fccud08,
                        g_fcc[l_ac].fccud09,g_fcc[l_ac].fccud10,
                        g_fcc[l_ac].fccud11,g_fcc[l_ac].fccud12,
                        g_fcc[l_ac].fccud13,g_fcc[l_ac].fccud14,
                        g_fcc[l_ac].fccud15,
                        #FUN-850068 --end--
                        g_legal) #FUN-980003 add
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fcc[l_ac].fcc02,SQLCA.sqlcode,0)   #No.FUN-660136
                CALL cl_err3("ins","fcc_file",g_fcb.fcb01,g_fcc[l_ac].fcc02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                #LET g_fcc[l_ac].* = g_fcc_t.*
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                LET g_feature = ' '
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
            #------ 如果新增投抵或修改交貨日,則更新faj491 ----#
            IF g_fcc[l_ac].fcc19 is null OR
               g_fcc[l_ac].fcc19 != g_fcc_t.fcc19
               THEN UPDATE faj_file set faj491 = g_fcc[l_ac].fcc19
                     WHERE faj02 = g_fcc[l_ac].fcc03
                     AND   faj022 = g_fcc[l_ac].fcc031
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_fcc[l_ac].* TO NULL      #900423
            LET g_fcc[l_ac].fcc20 = '2'
            LET g_fcc_t.* = g_fcc[l_ac].*             #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        BEFORE FIELD fcc02                            #default 序號
            IF g_fcc[l_ac].fcc02 IS NULL OR
               g_fcc[l_ac].fcc02 = 0 THEN
               SELECT max(fcc02)+1
                 INTO g_fcc[l_ac].fcc02
                 FROM fcc_file
                WHERE fcc01 = g_fcb.fcb01
                IF g_fcc[l_ac].fcc02 IS NULL THEN LET g_fcc[l_ac].fcc02 = 1
                END IF
            END IF
 
        AFTER FIELD fcc03                        #財產編號
            IF NOT cl_null(g_fcc[l_ac].fcc03) THEN
               IF g_fcc[l_ac].fcc03 != g_fcc_t.fcc03 OR
                  g_fcc_t.fcc03 IS NULL THEN
                  SELECT COUNT(*) INTO l_n FROM faj_file
                   WHERE faj02 = g_fcc[l_ac].fcc03
                     AND fajconf = 'Y'    #TQC-730115
                     AND faj42 ='1'       #MOD-B30203
#                 IF l_n < 0  THEN   #TQC-730115
                  IF l_n = 0  THEN   #TQC-730115
                     CALL cl_err(g_fcc[l_ac].fcc03,'afa-041',0)
                     LET g_fcc[l_ac].fcc03 = g_fcc_t.fcc03
                     NEXT FIELD fcc03
                  END IF
               END IF
            END IF
            NEXT FIELD fcc031
 
        AFTER FIELD fcc031                       #財產附號
            #---- 財產附號變更或原來財附號is null ---#
            IF g_fcc[l_ac].fcc031 != g_fcc_t.fcc031 OR
               g_fcc_t.fcc031 IS NULL OR
               g_fcc[l_ac].fcc03 != g_fcc_t.fcc03 THEN
               IF cl_null(g_fcc[l_ac].fcc031) THEN
                  LET g_fcc[l_ac].fcc031=' '
               END IF
               SELECT COUNT(*) INTO l_n FROM fcc_file
                WHERE fcc01 = g_fcb.fcb01
                  AND fcc03 = g_fcc[l_ac].fcc03
                  AND fcc031= g_fcc[l_ac].fcc031
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_fcc[l_ac].fcc031 = g_fcc_t.fcc031
                  NEXT FIELD fcc03
               END IF
              #str MOD-940087 add
              #該財產編號+附號須不存在投資免稅單身檔[fci_file]中。
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM fci_file
                WHERE fci03 = g_fcc[l_ac].fcc03
                  AND fci031= g_fcc[l_ac].fcc031
               IF l_n > 0 THEN
                  CALL cl_err('','afa-159',0)
                  LET g_fcc[l_ac].fcc031 = g_fcc_t.fcc031
                  NEXT FIELD fcc031
               END IF
              #end MOD-940087 add
               CALL t700_faj()         #將財產基本資料帶入單身
#TQC-730115.....begin
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD fcc031
               END IF
#TQC-730115.....end
               # 將財產資料中的預設幣別;數量;原幣值..等帶入單身
               # 並預設中文名稱、英文名稱、規格型號....
               SELECT faj06,faj07,faj08,faj11,faj17,faj18,
                      faj16,faj15,faj14, faj511,'2',
                      faj26,faj421,faj422,faj43,faj42
                 INTO g_fcc[l_ac].fcc05,g_fcc[l_ac].fcc06,
                      g_fcc[l_ac].fcc07,
                      g_fcc[l_ac].fcc08,g_fcc[l_ac].fcc09,
                      g_fcc[l_ac].fcc10,
                      g_fcc[l_ac].fcc13,
                      g_fcc[l_ac].fcc14,
                      g_fcc[l_ac].fcc16,
                      g_fcc[l_ac].fcc19,
                      g_fcc[l_ac].fcc20,g_fcc[l_ac].fcc191,
                      l_faj421,l_faj422,l_faj43,l_faj42
                 FROM faj_file
                WHERE faj02 = g_fcc[l_ac].fcc03
                  AND faj022= g_fcc[l_ac].fcc031
                  AND faj42 ='1'       #MOD-B30203
               IF sqlca.sqlcode<>0 THEN
                  CALL cl_err('',sqlca.sqlcode,0)
                  LET g_fcc[l_ac].fcc031 = g_fcc_t.fcc031
                  NEXT FIELD fcc03
               END IF
               IF l_faj43 MATCHES '[56]' THEN
                  CALL cl_err(g_fcc[l_ac].fcc03,'afa-333',0)
                  NEXT FIELD fcc03
               END IF
               IF l_faj42 MATCHES '[035]' THEN
                  CALL cl_err(g_fcc[l_ac].fcc03,'afa-327',0)
                  NEXT FIELD fcc03
               END IF
               #---- 廠商轉換-----#
               CALL t700_faj11(g_fcc[l_ac].fcc08) RETURNING g_fcc[l_ac].fcc08
               #--- 減定抵減率jeffery update----#
# 87/05/05 update  IF g_fcc[l_ac].fcc13=g_aza.aza17
               IF g_fcc[l_ac].fcc14=g_aza.aza17 THEN
                  LET g_fcc[l_ac].fcc15=l_faj421
               ELSE
                  LET g_fcc[l_ac].fcc15=l_faj422
               END IF
            END IF
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_fcc[l_ac].fcc05
            DISPLAY BY NAME g_fcc[l_ac].fcc06
            DISPLAY BY NAME g_fcc[l_ac].fcc07
            DISPLAY BY NAME g_fcc[l_ac].fcc08
            DISPLAY BY NAME g_fcc[l_ac].fcc09
            DISPLAY BY NAME g_fcc[l_ac].fcc10
            DISPLAY BY NAME g_fcc[l_ac].fcc13
            DISPLAY BY NAME g_fcc[l_ac].fcc14
            DISPLAY BY NAME g_fcc[l_ac].fcc16
            DISPLAY BY NAME g_fcc[l_ac].fcc19
            DISPLAY BY NAME g_fcc[l_ac].fcc20
            DISPLAY BY NAME g_fcc[l_ac].fcc191
            DISPLAY BY NAME g_fcc[l_ac].fcc15
            #------MOD-5A0095 END------------
 
        AFTER FIELD fcc04            #彙總碼
            IF NOT cl_null(g_fcc[l_ac].fcc04) THEN
               IF g_fcc[l_ac].fcc04 NOT MATCHES '[0-2]' THEN
                  NEXT FIELD fcc04
               END IF
#No.FUN-570211 增加抓取表身筆數
               SELECT COUNT(*) INTO l_cnt FROM fcc_file WHERE fcc01=g_fcb.fcb01
               IF l_cnt > 0 THEN
                  IF g_fcc[l_ac].fcc04 MATCHES '[12]' THEN
                    LET g_cnt = 0
                    FOR l_i = 1 TO l_cnt
                       IF l_i <> l_ac THEN
                          IF g_fcc[l_i].fcc04 MATCHES '[12]' AND
                             g_fcc[l_i].fcc02=g_fcc[l_ac].fcc02 THEN
                             LET g_cnt = g_cnt + 1
                             EXIT FOR
                          END IF
                       END IF
                    END FOR
                    IF g_cnt > 0 THEN
                       CALL cl_err(g_fcc[l_ac].fcc03,'axm-220',0)
                       NEXT FIELD fcc04
                    END IF
                  END IF
               END IF
            END IF
 
        AFTER FIELD fcc09
###Modify:2620
           IF NOT cl_null(g_fcc[l_ac].fcc09) THEN
              SELECT (faj17-faj58) INTO g_faj17_faj58    # 未銷帳數量
              FROM faj_file
              WHERE faj02 = g_fcc[l_ac].fcc03
                AND faj022= g_fcc[l_ac].fcc031
              IF g_fcc[l_ac].fcc09>g_faj17_faj58 THEN
                CALL cl_err(g_faj17_faj58,'afa-352',0)
                NEXT FIELD fcc09
              END IF
 #MOD-530831   自動帶出原幣本幣金額
              SELECT faj17,faj14,faj16 INTO l_faj17,l_faj14,l_faj16 FROM faj_file
                     WHERE faj02 = g_fcc[l_ac].fcc03 AND faj022 = g_fcc[l_ac].fcc031
              LET g_fcc[l_ac].fcc16 = cl_digcut(((l_faj14/l_faj17)*g_fcc[l_ac].fcc09),g_azi04)
              LET g_fcc[l_ac].fcc13 = cl_digcut(((l_faj16/l_faj17)*g_fcc[l_ac].fcc09),g_azi04)
              #------MOD-5A0095 START----------
              DISPLAY BY NAME g_fcc[l_ac].fcc16
              DISPLAY BY NAME g_fcc[l_ac].fcc13
              #------MOD-5A0095 END------------
 #END -MOD-530831
           END IF
 
        AFTER FIELD fcc11
           IF NOT cl_null(g_fcc[l_ac].fcc11) THEN
              LET g_fcc[l_ac].fcc11 = t700_get_fai(g_fcc[l_ac].fcc11)
              #------MOD-5A0095 START----------
              DISPLAY BY NAME g_fcc[l_ac].fcc11
              #------MOD-5A0095 END------------
           END IF
 
        AFTER FIELD fcc14            #幣別
            IF NOT cl_null(g_fcc[l_ac].fcc14) THEN
               SELECT COUNT(*) INTO l_cnt FROM azi_file
                WHERE azi01 = g_fcc[l_ac].fcc14 AND aziacti='Y'
               IF l_cnt=0 THEN
                  NEXT FIELD fcc14
               END IF
            END IF
 
        AFTER FIELD fcc15            #抵減率
           IF NOT cl_null(g_fcc[l_ac].fcc15) THEN
              IF g_fcc[l_ac].fcc15 <= 0 THEN
                 CALL cl_err(g_fcc[l_ac].fcc15,'afa-037',0)
                 NEXT FIELD fcc15
              END IF
           END IF
 
        AFTER FIELD fcc20
           IF NOT cl_null(g_fcc[l_ac].fcc20) THEN
              IF g_fcc[l_ac].fcc20 NOT MATCHES '[23456]' THEN
                 NEXT FIELD fcc20
              END IF
           END IF
 
        AFTER FIELD fcc12
           IF NOT cl_null(g_fcc[l_ac].fcc12) THEN
              LET g_fcc[l_ac].fcc12 = t700_get_fai(g_fcc[l_ac].fcc12)
              #------MOD-5A0095 START----------
              DISPLAY BY NAME g_fcc[l_ac].fcc12
              #------MOD-5A0095 END------------
           END IF
 
        AFTER FIELD fcc16            #本幣成本
           IF NOT cl_null(g_fcc[l_ac].fcc16) THEN
              IF g_fcc[l_ac].fcc16 <= 0 THEN
                 CALL cl_err(g_fcc[l_ac].fcc16,'afa-037',0)
                 NEXT FIELD fcc16
              END IF
           END IF
 
        #No.FUN-850068 --start--
        AFTER FIELD fccud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fccud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fccud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fccud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fccud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fccud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fccud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fccud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fccud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fccud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fccud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fccud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fccud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fccud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fccud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-850068 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_fcc_t.fcc02 > 0 AND
               g_fcc_t.fcc02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     ROLLBACK WORK
                     CANCEL DELETE
                END IF
##Modify:2638 ----98/10/27---------
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM fcc_file
                 WHERE fcc01 = g_fcb.fcb01
                   AND fcc03 = g_fcc_t.fcc03
                   AND fcc031= g_fcc_t.fcc031
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_fcc_t.fcc02,SQLCA.sqlcode,0)   #No.FUN-660136
                    CALL cl_err3("del","fcc_file",g_fcb.fcb01,g_fcc_t.fcc03,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fcc[l_ac].* = g_fcc_t.*
               CLOSE t700_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fcc[l_ac].fcc02,-263,1)
               LET g_fcc[l_ac].* = g_fcc_t.*
            ELSE
# No.FUN-570211 新增 fcc26 欄位
               UPDATE fcc_file SET
                    fcc02=g_fcc[l_ac].fcc02,fcc03=g_fcc[l_ac].fcc03,
                    fcc031=g_fcc[l_ac].fcc031,fcc04=g_fcc[l_ac].fcc04,
                    fcc05=g_fcc[l_ac].fcc05,fcc06=g_fcc[l_ac].fcc06,
                    fcc07=g_fcc[l_ac].fcc07,fcc08=g_fcc[l_ac].fcc08,
                    fcc09=g_fcc[l_ac].fcc09,fcc10=g_fcc[l_ac].fcc10,
                    fcc11=g_fcc[l_ac].fcc11,fcc12=g_fcc[l_ac].fcc12,
                    fcc13=g_fcc[l_ac].fcc13,fcc14=g_fcc[l_ac].fcc14,
                    fcc15=g_fcc[l_ac].fcc15,fcc16=g_fcc[l_ac].fcc16,
                    fcc17=g_fcc[l_ac].fcc17,fcc18=g_fcc[l_ac].fcc18,
                    fcc19=g_fcc[l_ac].fcc19,fcc191=g_fcc[l_ac].fcc191,
                    fcc20=g_fcc[l_ac].fcc20,fcc26=g_fcc[l_ac].fcc26,
                    #FUN-850068 --start--
                    fccud01 = g_fcc[l_ac].fccud01,fccud02 = g_fcc[l_ac].fccud02,
                    fccud03 = g_fcc[l_ac].fccud03,fccud04 = g_fcc[l_ac].fccud04,
                    fccud05 = g_fcc[l_ac].fccud05,fccud06 = g_fcc[l_ac].fccud06,
                    fccud07 = g_fcc[l_ac].fccud07,fccud08 = g_fcc[l_ac].fccud08,
                    fccud09 = g_fcc[l_ac].fccud09,fccud10 = g_fcc[l_ac].fccud10,
                    fccud11 = g_fcc[l_ac].fccud11,fccud12 = g_fcc[l_ac].fccud12,
                    fccud13 = g_fcc[l_ac].fccud13,fccud14 = g_fcc[l_ac].fccud14,
                    fccud15 = g_fcc[l_ac].fccud15
                    #FUN-850068 --end-- 
                WHERE fcc01=g_fcb.fcb01
                  AND fcc03=g_fcc_t.fcc03
                  AND fcc031=g_fcc_t.fcc031
               IF SQLCA.sqlcode THEN
#                CALL cl_err(g_fcc[l_ac].fcc02,SQLCA.sqlcode,0)   #No.FUN-660136
                 CALL cl_err3("upd","fcc_file",g_fcb.fcb01,g_fcc_t.fcc03,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                 LET g_fcc[l_ac].* = g_fcc_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                   #------ 如果新增投抵或修改交貨日,則更新faj491 ----#
                   IF g_fcc[l_ac].fcc19 is null OR
                      g_fcc[l_ac].fcc19 != g_fcc_t.fcc19
                      THEN UPDATE faj_file set faj491 = g_fcc[l_ac].fcc19
                            WHERE faj02 = g_fcc[l_ac].fcc03
                            AND   faj022 = g_fcc[l_ac].fcc031
                   END IF
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_fcc[l_ac].* = g_fcc_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_fcc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE t700_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add
           #LET g_fcc_t.* = g_fcc[l_ac].*  #FUN-D30032 mark
            CLOSE t700_bcl
            COMMIT WORK
            #CKP2
           #CALL g_fcc.deleteElement(g_rec_b+1) #FUN-D30032 mark
 
       ON ACTION sum_qty
             CALL get_sum_amt_qty(arr_curr()) RETURNING
                  tot_qty,tot_Amt,ntd_tot_Amt
#No.MOD-580325-begin
             CALL cl_getmsg('afa-331',g_lang) RETURNING l_msg1
             CALL cl_getmsg('afa-332',g_lang) RETURNING l_msg2
             CALL cl_getmsg('afa-341',g_lang) RETURNING l_msg3
             LET l_msg=l_msg1 CLIPPED,"[",tot_qty,"]",
                       l_msg2 CLIPPED,"[",tot_amt using "##########","]",
                       l_msg3 CLIPPED,"[",ntd_tot_Amt using "##########","]"
             ERROR l_msg
#             ERROR  "數量 [",tot_qty,"]原幣[", tot_amt
#                    using "##########","]台幣[",
#                    ntd_tot_Amt using "##########","]"
#No.MOD-580325-end
        ON ACTION maintain_fixed_asset
             CALL cl_cmdrun('afai100')
 
        ON ACTION auto_generate
                  CALL t700_g(3,5)
 
        ON ACTION controlp
           CASE
            WHEN INFIELD(fcc03)    #查詢資產資料
                 CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_faj1"   #TQC-730115
                 LET g_qryparam.form = "q_faj11"  #TQC-730115
                 LET g_qryparam.default1 = g_fcc[l_ac].fcc03
                 LET g_qryparam.default2 = g_fcc[l_ac].fcc031
                 CALL cl_create_qry() RETURNING g_fcc[l_ac].fcc03,g_fcc[l_ac].fcc031
                  DISPLAY g_fcc[l_ac].fcc03 TO fcc03                #No.MOD-490344
                  DISPLAY g_fcc[l_ac].fcc031 TO fcc031              #No.MOD-490344
#                 CALL FGL_DIALOG_SETBUFFER( g_fcc[l_ac].fcc03 )
#                 CALL FGL_DIALOG_SETBUFFER( g_fcc[l_ac].fcc031 )
                 NEXT FIELD fcc03
              WHEN INFIELD(fcc11)    #查詢用途資料
                 CALL q_fai(FALSE,TRUE,g_fcc[l_ac].fcc11)
                 RETURNING g_fcc[l_ac].fcc11
#                 CALL FGL_DIALOG_SETBUFFER( g_fcc[l_ac].fcc11 )
                  DISPLAY g_fcc[l_ac].fcc11 TO fcc11              #No.MOD-490344
                 NEXT FIELD fcc11
              WHEN INFIELD(fcc14)    #查詢幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_fcc[l_ac].fcc14
                 CALL cl_create_qry() RETURNING g_fcc[l_ac].fcc14
#                 CALL FGL_DIALOG_SETBUFFER( g_fcc[l_ac].fcc14)
                  DISPLAY g_fcc[l_ac].fcc14 TO fcc14              #No.MOD-490344
                 NEXT FIELD fcc14
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fcc02) AND l_ac > 1 THEN
                LET g_fcc[l_ac].* = g_fcc[l_ac-1].*
                LET G_fcc[l_ac].fcc02 = NULL   #TQC-620018
                NEXT FIELD fcc02
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION mntn_frequently_used_memo
            CALL cl_cmdrun('afai070')
 
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
 
  #start FUN-5A0029
   LET g_fcb.fcbmodu = g_user
   LET g_fcb.fcbdate = g_today
   UPDATE fcb_file SET fcbmodu = g_fcb.fcbmodu,fcbdate = g_fcb.fcbdate
    WHERE fcb01 = g_fcb.fcb01
   DISPLAY BY NAME g_fcb.fcbmodu,g_fcb.fcbdate
  #end FUN-5A0029
 
   #  將原幣成本[fcc13],本幣成本[fcc16],
   #    數量    [fcc09]累加至主件
   MESSAGE " WAITING......... ! "
   MESSAGE ''
   CLOSE t700_cl
   CLOSE t700_bcl
   COMMIT WORK
   CALL t700_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t700_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_fcb.fcb01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fcb_file ",
                  "  WHERE fcb01 LIKE '",l_slip,"%' ",
                  "    AND fcb01 > '",g_fcb.fcb01,"'"
      PREPARE t700_pb1 FROM l_sql 
      EXECUTE t700_pb1 INTO l_cnt 
      
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
        #CALL t700_x()       #FUN-D20035
         CALL t700_x(1)           #FUN-D20035
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM fcb_file WHERE fcb01 = g_fcb.fcb01
         INITIALIZE g_fcb.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t700_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON fcc02,fcc03,fcc031
                       #No.FUN-850068 --start--
                       ,fccud01,fccud02,fccud03,fccud04,fccud05
                       ,fccud06,fccud07,fccud08,fccud09,fccud10
                       ,fccud11,fccud12,fccud13,fccud14,fccud15
                       #No.FUN-850068 ---end---
            FROM s_fcc[1].fcc02,s_fcc[1].fcc03,s_fcc[1].fcc031
                 #No.FUN-850068 --start--
                 ,s_fcc[1].fccud01,s_fcc[1].fccud02,s_fcc[1].fccud03
                 ,s_fcc[1].fccud04,s_fcc[1].fccud05,s_fcc[1].fccud06
                 ,s_fcc[1].fccud07,s_fcc[1].fccud08,s_fcc[1].fccud09
                 ,s_fcc[1].fccud10,s_fcc[1].fccud11,s_fcc[1].fccud12
                 ,s_fcc[1].fccud13,s_fcc[1].fccud14,s_fcc[1].fccud15
                 #No.FUN-850068 ---end---
 
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
    CALL t700_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t700_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(300)
 
# No.FUN-570211 新增 fcc26 欄位
    LET g_sql =
       " SELECT fcc02,fcc03,fcc031,fcc05,fcc06,fcc07,fcc26,fcc04,fcc08, ",
       " fcc09,fcc10,fcc191,faj49,faj51,fcc11,fcc12,faj20, ",
       " fcc13,fcc14,fcc15,fcc16,fcc17,fcc18,fcc19,faj04,fcc20, ",
       #No.FUN-850068 --start--
       " fccud01,fccud02,fccud03,fccud04,fccud05,",
       " fccud06,fccud07,fccud08,fccud09,fccud10,",
       " fccud11,fccud12,fccud13,fccud14,fccud15 ", 
       #No.FUN-850068 ---end---
       " FROM fcc_file LEFT JOIN faj_file ON fcc03=faj02 AND fcc031=faj022",
       " WHERE fcc01 ='",g_fcb.fcb01,"'",           #單頭
       "   AND ",p_wc2 CLIPPED,                     #單身
       " ORDER BY 1,2,3"
 
    PREPARE t700_pb FROM g_sql
    DECLARE fcc_curs CURSOR FOR t700_pb
 
    CALL g_fcc.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fcc_curs INTO g_fcc[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL t700_faj11(g_fcc[g_cnt].fcc08) RETURNING g_fcc[g_cnt].fcc08
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_fcc.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fcc  TO s_fcc.* ATTRIBUTE(COUNT=g_rec_b)
 
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
          #No.MOD-470566
         CALL t700_fetch('P')
         EXIT DISPLAY
          #No.MOD-470566 (end)
 
      ON ACTION previous
         CALL t700_fetch('P')
         EXIT DISPLAY
      ON ACTION jump
         CALL t700_fetch('/')
      ON ACTION next
         CALL t700_fetch('N')
         LET g_action_choice="next"
         EXIT DISPLAY
      ON ACTION last
         CALL t700_fetch('L')
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION void
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #FUN-D20035---add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20035---add--end

      #@ON ACTION auto_generate
      ON ACTION auto_generate
         LET g_action_choice="auto_generate"
         EXIT DISPLAY
      #@ON ACTION confirm
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION undo_confirm
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #@ON ACTION 管理局核准
      ON ACTION admin_appr
         LET g_action_choice="admin_appr"
         EXIT DISPLAY
      #@ON ACTION 國稅局核准
      ON ACTION ira_appr
         LET g_action_choice="ira_appr"
         EXIT DISPLAY
      #@ON ACTION 管理局核准復原
      ON ACTION undo_admin_appr
         LET g_action_choice="undo_admin_appr"
         EXIT DISPLAY
      #@ON ACTION 國稅局核准復原
      ON ACTION undo_ira_appr
         LET g_action_choice="undo_ira_appr"
         EXIT DISPLAY
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
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

#TQC-AB0268--add--str---
     ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         EXIT DISPLAY
#TQC-AB0268--add--end--- 
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
      #FUN-810046
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t700_sure(l_chr)
DEFINE s_cnt     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_chr     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_cnt     LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    #bugno:7341 add......................................................
    IF l_chr='Y' THEN
        SELECT COUNT(*) INTO l_cnt FROM fcc_file WHERE fcc01=g_fcb.fcb01
        IF l_cnt = 0 THEN
           CALL cl_err('','mfg-009',0)
           RETURN
        END IF
    END IF
    #bugno:7341 end......................................................
    IF g_fcb.fcbconf = 'X' THEN
        CALL cl_err('','9024',0) RETURN
    END IF
    SELECT * INTO g_fcb.* FROM fcb_file WHERE fcb01 = g_fcb.fcb01
IF l_chr='Y' THEN  #---confirm動 ---#
    IF g_fcb.fcbconf='Y' THEN RETURN END IF
    IF cl_sure(0,0) THEN                   #confirm一下
#CHI-C30107 ---------- add -------------- begin
       SELECT * INTO g_fcb.* FROM fcb_file WHERE fcb01 = g_fcb.fcb01
       IF g_fcb.fcbconf = 'X' THEN
          CALL cl_err('','9024',0) RETURN
       END IF       
       IF g_fcb.fcbconf='Y' THEN RETURN END IF
#CHI-C30107 ---------- add -------------- end
       BEGIN WORK
       LET g_success = 'Y'
       CALL s_showmsg_init()    #No.FUN-710028
       CALL t700_surey()        #更新資產基本資料檔
       CALL t700_add()
       CALL s_showmsg()         #No.FUN-710028
       IF g_success = 'Y' THEN LET g_fcb.fcbconf='Y' COMMIT WORK
          DISPLAY BY NAME g_fcb.fcbconf
       ELSE LET g_fcb.fcbconf='N' ROLLBACK WORK
       END IF
    END IF
ELSE
    IF g_fcb.fcbconf='N' THEN RETURN END IF
    IF not cl_null(g_fcb.fcb04) THEN
       CALL cl_err(g_fcb.fcb01,'afa-325',0)
       RETURN
    END IF
    #------ 判斷如果某些item (財編) 已被核淮了,則不允許undo_confirm ----#
    SELECT COUNT(*) INTO s_cnt FROM fcc_file
     WHERE fcc20 != '2' AND fcc01 = g_fcb.fcb01
    IF s_cnt >0 THEN
       CALL cl_err(g_fcb.fcb01,'afa-322',0) RETURN
    END IF
    IF cl_sure(0,0) THEN                   #confirm一下
       BEGIN WORK LET g_success = 'Y'
       CALL s_showmsg_init()    #No.FUN-710028
       CALL t700_suren()        #更新資產基本資料檔
       CALL t700_add()
       CALL s_showmsg()         #No.FUN-710028
       IF g_success = 'Y' THEN LET g_fcb.fcbconf='N' COMMIT WORK
            DISPLAY BY NAME g_fcb.fcbconf
       ELSE LET g_fcb.fcbconf='Y' ROLLBACK WORK
       END IF
    END IF
END IF
  IF g_fcb.fcbconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  CALL cl_set_field_pic(g_fcb.fcbconf,"","","",g_chr,"")
END FUNCTION
 
FUNCTION t700_surey()
DEFINE s_cnt     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_faj81   LIKE faj_file.faj81,          #No.FUN-4C0008
       l_fcc03   LIKE fcc_file.fcc03,
       l_fcc031   LIKE fcc_file.fcc031,
       l_fcc04   LIKE fcc_file.fcc04,
       l_fcc15   LIKE fcc_file.fcc15,
       l_fcc16   LIKE fcc_file.fcc16
 
 
    DECLARE t700_surey CURSOR FOR
        SELECT fcc03,fcc031,fcc04,fcc15,fcc16
          FROM fcc_file WHERE fcc01 = g_fcb.fcb01
 
    FOREACH t700_surey INTO l_fcc03,l_fcc031,l_fcc04,l_fcc15,l_fcc16
#No.FUN-710028 --begin                                                                                                              
        IF g_success='N' THEN                                                                                                         
           LET g_totsuccess='N'                                                                                                       
           LET g_success="Y"                                                                                                          
        END IF                                                                                                                        
#No.FUN-710028 --end
 
        IF SQLCA.sqlcode THEN
#          CALL cl_err('t700_surey',SQLCA.sqlcode,0)                        #No.FUN-710028
           CALL s_errmsg('fcc01',g_fcb.fcb01,'t700_surey',SQLCA.sqlcode,1)  #No.FUN-710028
           LET g_success = 'N'
           EXIT FOREACH
        END IF
        UPDATE fcc_file SET fcc20 = '2' WHERE fcc01 = g_fcb.fcb01
                                          AND fcc03 = l_fcc03
                                          AND fcc031 = l_fcc031
         IF SQLCA.sqlcode THEN            #No.MOD-490227
            LET g_showmsg = g_fcb.fcb01,"/",l_fcc03,"/",l_fcc031  #No.FUN-710028
            CALL s_errmsg('fcc01,fcc03,fcc031',g_showmsg,'upd fcc_file:',SQLCA.sqlcode,1) #No.FUN-710028
#           LET g_success = 'N' RETURN             #No.FUN-710028
            LET g_success = 'N' CONTINUE FOREACH   #No.FUN-710028
        END IF
        LET l_faj81=(l_fcc15 * l_fcc16)/100
        UPDATE faj_file SET faj42 = '2',
                            faj80 = l_fcc15,
                            faj81 = l_faj81,
                            faj851= l_fcc04
                      WHERE faj02 = l_fcc03 AND faj022= l_fcc031
         IF SQLCA.sqlcode THEN                     #No.MOD-490227
            LET g_showmsg = l_fcc03,"/",l_fcc031   #No.FUN-710028
            CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj_file:',SQLCA.sqlcode,1) #No.FUN-710028
#           LET g_success = 'N' RETURN             #No.FUN-710028
            LET g_success = 'N' CONTINUE FOREACH   #No.FUN-710028
         END IF
    END FOREACH
#No.FUN-710028 --begin                                                                                                              
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
#No.FUN-710028 --end
 
    UPDATE fcb_file SET fcbconf='Y' WHERE fcb01=g_fcb.fcb01
     IF SQLCA.sqlcode THEN          #No.MOD-490227
        CALL s_errmsg('fcb01',g_fcb.fcb01,'upd fcb_file:',SQLCA.sqlcode,1)  #No.FUN-710028
        LET g_success = 'N'
    END IF
END FUNCTION
 
FUNCTION t700_suren()
DEFINE s_cnt     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_fcc03   LIKE fcc_file.fcc03,
       l_fcc031  LIKE fcc_file.fcc031
 
    DECLARE t700_suren CURSOR FOR
        SELECT fcc03,fcc031
          FROM fcc_file WHERE fcc01 = g_fcb.fcb01
    FOREACH t700_suren INTO l_fcc03,l_fcc031
#No.FUN-710028 --begin                                                                                                              
        IF g_success='N' THEN                                                                                                         
           LET g_totsuccess='N'                                                                                                       
           LET g_success="Y"                                                                                                          
        END IF                                                                                                                        
#No.FUN-710028 --end
 
        IF SQLCA.sqlcode THEN
#          CALL cl_err('t700_suren',SQLCA.sqlcode,0)                        #No.FUN-710028
           CALL s_errmsg('fcc01',g_fcb.fcb01,'t700_suren',SQLCA.sqlcode,1)  #No.FUN-710028
           LET g_success = 'N'
           EXIT FOREACH
        END IF
        UPDATE fcc_file SET fcc20 = '2'   WHERE fcc01 = g_fcb.fcb01
                                          AND fcc03 = l_fcc03
                                          AND fcc031 = l_fcc031
         IF SQLCA.sqlcode THEN            #No.MOD-490227
            LET g_showmsg = g_fcb.fcb01,"/",l_fcc03,"/",l_fcc031  #No.FUN-710028
            CALL s_errmsg('fcc01,fcc03,fcc031',g_showmsg,'upd fcc_file:',SQLCA.sqlcode,1) #No.FUN-710028
#           LET g_success = 'N' RETURN             #No.FUN-710028
            LET g_success = 'N' CONTINUE FOREACH   #No.FUN-710028
        END IF
        UPDATE faj_file SET faj42 = '1',
                            faj80 = 0,   faj81 = 0,
                            faj82 = NULL,faj83 = ' ',
                            faj84 =NULL, faj85 = ' ',
                            faj851= ' '
                      WHERE faj02 = l_fcc03 AND faj022= l_fcc031
         IF SQLCA.sqlcode THEN        #No.MOD-490227
            LET g_showmsg = l_fcc03,"/",l_fcc031   #No.FUN-710028
            CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj_file:',SQLCA.sqlcode,1) #No.FUN-710028
#           LET g_success = 'N' RETURN             #No.FUN-710028
            LET g_success = 'N' CONTINUE FOREACH   #No.FUN-710028
        END IF
    END FOREACH
#No.FUN-710028 --begin                                                                                                              
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
#No.FUN-710028 --end
 
    UPDATE fcb_file SET fcbconf='N' WHERE fcb01=g_fcb.fcb01
     IF SQLCA.sqlcode THEN             #No.MOD-490227
        CALL s_errmsg('fcb01',g_fcb.fcb01,'upd fcb_file:',SQLCA.sqlcode,1)  #No.FUN-710028
        LET g_success = 'N'
    END IF
END FUNCTION
 
FUNCTION t700_add()
DEFINE l_fcc02   LIKE fcc_file.fcc02,
       l_fcc03   LIKE fcc_file.fcc03,
       l_fcc031  LIKE fcc_file.fcc031,
       l_fcc04   LIKE fcc_file.fcc04,
       l_fcc09   LIKE fcc_file.fcc09,
       l_fcc21   LIKE fcc_file.fcc21,
       l_fcc22   LIKE fcc_file.fcc22,
       l_fcc23   LIKE fcc_file.fcc23,
       l_fcc24   LIKE fcc_file.fcc24
 
     DECLARE afat700_cursad CURSOR FOR
      SELECT unique fcc02,fcc03,fcc031,fcc04,fcc09
        FROM fcc_file
       WHERE fcc01 = g_fcb.fcb01 AND fcc04 IN ('1','2')
 
    FOREACH afat700_cursad INTO l_fcc02,l_fcc03,l_fcc031,l_fcc04,l_fcc09
#No.FUN-710028 --begin                                                                                                              
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        
#No.FUN-710028 --end
 
       IF SQLCA.sqlcode != 0 THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)          #No.FUN-710028
          CALL s_errmsg('','','foreach:',SQLCA.sqlcode,0)  #No.FUN-710028
          EXIT FOREACH
       END IF
       MESSAGE l_fcc02,' ',l_fcc03,' ',l_fcc031
       SELECT sum(fcc09),sum(fcc13),sum(fcc16)
         INTO l_fcc21,l_fcc23,l_fcc24
         FROM fcb_file,fcc_file
        WHERE fcc01 =g_fcb.fcb01 AND fcc02 = l_fcc02
          AND fcb01 = fcc01
          AND fcbconf = 'Y'
       IF SQLCA.sqlcode THEN
#         CALL cl_err('sum error',SQLCA.sqlcode,0)           #No.FUN-660136
#         CALL cl_err3("sel","fcb_file,fcc_file",g_fcb.fcb01,l_fcc02,SQLCA.sqlcode,"","sum error",1)  #No.FUN-660136 #No.FUN-710028
          LET g_showmsg = g_fcb.fcb01,"/",l_fcc02,"/",'Y'    #No.FUN-710028
          CALL s_errmsg('fcc01,fcc02,fcbconf',g_showmsg,'sum error',SQLCA.sqlcode,0)   #No.FUN-710028
#         EXIT FOREACH       #No.FUN-710028
          CONTINUE FOREACH   #No.FUN-710028
       END IF
       #--->不累加數量
       IF l_fcc04 = '2' THEN LET l_fcc21 = l_fcc09 END IF
       UPDATE fcc_file SET fcc23 = l_fcc23,  #原幣成本
                           fcc24 = l_fcc24,  #本幣成本
                           fcc21 = l_fcc21   #數量
                       WHERE fcc01 = g_fcb.fcb01 AND fcc03  = l_fcc03
                         AND fcc031 = l_fcc031
       IF SQLCA.sqlcode THEN
#         CALL cl_err('upd error',SQLCA.sqlcode,0)                 #No.FUN-660136
#         CALL cl_err3("upd","fcc_file",g_fcb.fcb01,l_fcc03,SQLCA.sqlcode,"","upd error",1)  #No.FUN-660136 #No.FUN-710028
          LET g_showmsg = g_fcb.fcb01,"/",l_fcc03,"/",l_fcc031     #No.FUN-710028
          CALL s_errmsg('fcc01,fcc03,fcc031',g_showmsg,'upd error',SQLCA.sqlcode,0)          #No.FUN-710028
#         EXIT FOREACH       #No.FUN-710028
          CONTINUE FOREACH   #No.FUN-710028
       END IF
    END FOREACH
#No.FUN-710028 --begin                                                                                                              
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
#No.FUN-710028 --end
 
END FUNCTION
 
FUNCTION t700_faj()   #將進口編號、發票號碼、保管部門放至單身
DEFINE  l_fajconf  LIKE faj_file.fajconf    #TQC-730115 
 
#TQC-730115.....begin
#  SELECT faj49,faj20,faj51,faj04
#        INTO g_fcc[l_ac].faj49,g_fcc[l_ac].faj20,
#             g_fcc[l_ac].faj51,g_fcc[l_ac].faj04
#        FROM faj_file
#       WHERE faj02 = g_fcc[l_ac].fcc03
#         AND faj022= g_fcc[l_ac].fcc031
  SELECT faj49,faj20,faj51,faj04,fajconf
        INTO g_fcc[l_ac].faj49,g_fcc[l_ac].faj20,
             g_fcc[l_ac].faj51,g_fcc[l_ac].faj04,l_fajconf
        FROM faj_file
       WHERE faj02 = g_fcc[l_ac].fcc03
         AND faj022= g_fcc[l_ac].fcc031
  CASE
     WHEN l_fajconf = 'N'      LET g_errno='afa-918'
     OTHERWISE
          LET g_errno =SQLCA.sqlcode USING '-----'
  END CASE
#TQC-730115.....end
  #------MOD-5A0095 START----------
  DISPLAY BY NAME g_fcc[l_ac].faj49
  DISPLAY BY NAME g_fcc[l_ac].faj20
  DISPLAY BY NAME g_fcc[l_ac].faj51
  DISPLAY BY NAME g_fcc[l_ac].faj04
  #------MOD-5A0095 END------------
END FUNCTION
 
FUNCTION t700_g(p_row,p_col)             # G. auto_generate..單身資料
 DEFINE p_row,p_col,l_ax,l_maxac        LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_wc            LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(200)
        l_sql           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(400)
        l_cnt           LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_num,i         LIKE type_file.num5         #No.FUN-680070 SMALLINT
 DEFINE ls_tmp STRING
 
   IF g_fcb.fcbconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
   END IF
   LET i = 0
   IF g_fcb.fcb01 IS NULL THEN RETURN END IF
##Modify:2625    #已confirm不可auto_generate
   IF g_fcb.fcbconf ='Y' THEN CALL cl_err('','afa-364',0) RETURN END IF
   LET l_ac = ARR_CURR()
   LET p_row = 5 LET p_col = 20
   OPEN WINDOW t700_g AT p_row,p_col
        WITH FORM "afa/42f/afat700s"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afat700s")
 
   IF INT_FLAG THEN CLOSE WINDOW t700_g RETURN END IF
     CALL cl_opmsg('q')
    #資料權限的檢查
    CONSTRUCT BY NAME l_wc ON    # 螢幕上取auto_generate條件
    #   faj04,faj05,faj02,faj01,faj26,faj14                  #No.FUN-B50118 mark
        faj93,faj04,faj05,faj02,faj01,faj26,faj14            #No.FUN-B50118 add
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
   #No.TQC-760182--begin--
    IF l_wc = " 1=1" THEN
       CALL cl_err('','abm-997',1)
       LET  INT_FLAG = 1
    END IF
   #No.TQC-760182--end--
    IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW t700_g RETURN END IF
 
    LET l_sql ="SELECT '',faj02,faj022,faj06,faj07,faj26,faj51,faj17,faj18," ,  #TQC-730115 add fajconf #TQC-980098 del fajconf 
               " faj14 ",
               "  FROM faj_file ",
               " WHERE faj42 = '1' ",
               "   AND (faj14+faj141-faj59) > 0   ",
               "   AND faj43 NOT IN ('5','6') ",
               "   AND fajconf = 'Y' ",       #TQC-730115
               "   AND ",l_wc CLIPPED,
               " ORDER BY faj02,faj022 "
 
     PREPARE t700_g FROM l_sql
     DECLARE t700_g_curs CURSOR WITH HOLD FOR t700_g
     MESSAGE " WAITING......... ! "
     CALL t700_create_temp1()   #建立一temp file 儲存預投入單身之資料
     FOREACH t700_g_curs INTO l_faj_t.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        message l_faj_t.faj02,' ',l_faj_t.faj022
        #--->存在於附加費用則不可再產生
        SELECT COUNT(*) INTO l_cnt FROM fcc_file
         WHERE fcc03=l_faj_t.faj02 AND fcc031=l_faj_t.faj022
        IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
        IF l_cnt > 0 THEN CONTINUE FOREACH END IF
        #No:7949
        #--->存在於申請單則不可再產生
       # SELECT fcc03,fcc031 FROM fcc_file
       #        WHERE fcc03=l_faj_t.faj02 AND fcc031=l_faj_t.faj022
        #--->存在於fcb_file.fcbconf='Y' 則不可再產生
        SELECT COUNT(*) INTO l_cnt FROM fcb_file,fcc_file
         WHERE fcc03=l_faj_t.faj02 AND fcc031=l_faj_t.faj022
           AND fcc01=fcb01 AND fcbconf='Y'
        IF l_cnt > 0 THEN CONTINUE FOREACH END IF
        #NO:7949
        #--->存在於申請單則不可再產生
        SELECT fcc03,fcc031 FROM fcc_file
               WHERE fcc03=l_faj_t.faj02 AND fcc031=l_faj_t.faj022
        CASE sqlca.sqlcode
             WHEN 0  continue foreach
             WHEN 100
                  INSERT INTO faj_temp
                        VALUES('Y',l_faj_t.faj02,l_faj_t.faj022,l_faj_t.faj06,            #No.MOD-4A0133
                              l_faj_t.faj07,l_faj_t.faj26,l_faj_t.faj51,
                              l_faj_t.faj17,l_faj_t.faj18,l_faj_t.faj14)
            OTHERWISE
                  CALL cl_err('sel fcc',SQLCA.sqlcode,1)
        END CASE
     END FOREACH
     MESSAGE ''
     IF INT_FLAG THEN LET INT_FLAG = 0 END IF
     CLOSE WINDOW t700_g
 
     LET p_row = 8 LET p_col = 10
     OPEN WINDOW t700_a AT p_row,p_col
          WITH FORM "afa/42f/afat700a"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afat700a")
 
   IF INT_FLAG THEN RETURN END IF
     CALL t700_b_fillx()       # 單身
     CALL t700_bpx("D")        # 顯示第一頁的資料
     CALL t700_bx()            # 讓user 選取欲新增至單身的資料
     MESSAGE " WAITING......... ! "
     CALL t700_putb()          # 將[Y] 者新增至單身中
     MESSAGE ''
    #資料權限的檢查
    CLOSE WINDOW t700_a
    CALL t700_b_fill('1=1')       # 單身
END FUNCTION
 
FUNCTION t700_create_temp1()
   DROP TABLE faj_temp
#No.FUN-680070  -- begin --
#   CREATE TEMP TABLE faj_temp(
#     fajyn  VARCHAR(1),
#     faj02  VARCHAR(10),
#     faj022 VARCHAR(4),
#     faj06  VARCHAR(40),                      #No.FUN-560011
#     faj07  VARCHAR(30),
#     faj26  DATE,                                                               
#     faj51  VARCHAR(16),                      #No.FUN-540057
#     faj17  SMALLINT,                                                           
#     faj18  VARCHAR(4),
#     faj14  DEC(20,6));                    #No.FUN-4C0008
   CREATE TEMP TABLE faj_temp(
     fajyn  LIKE type_file.chr1,  
     faj02  LIKE faj_file.faj02,
     faj022 LIKE faj_file.faj022,
     faj06  LIKE faj_file.faj06,
     faj07  LIKE faj_file.faj07,
     faj26  LIKE faj_file.faj26,
     faj51  LIKE faj_file.faj51,
     faj17  LIKE faj_file.faj17,
     faj18  LIKE faj_file.faj18,
     faj14  LIKE faj_file.faj14);
#No.FUN-680070  -- end --
END FUNCTION
 
FUNCTION t700_bx()
DEFINE
    l_ax            LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_row,l_col     LIKE type_file.num5,                #分段輸入之行,列數       #No.FUN-680070 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    g_cmd           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(100)
    l_flag          LIKE type_file.num10,        #No.FUN-680070 INTEGER
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
 
    LET g_action_choice = ""
    IF g_fcb.fcb01 IS NULL THEN RETURN END IF
 
    LET g_forupd_sql = " SELECT * FROM faj_temp ",
                       " WHERE faj02 =?  ",
                       "   AND faj022=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t700_bclx CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_row  = 12
        LET l_col  = 15
        LET l_ac_t =  0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY l_faj WITHOUT DEFAULTS FROM s_faj.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            CALL fgl_set_arr_curr(l_ac)
 
        BEFORE ROW
            LET l_ax = ARR_CURR()       #目前筆數
            LET l_faj_t.* = l_faj[l_ax].*  #BACKUP
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()                #目前的array共有幾筆
            BEGIN WORK
 
            OPEN t700_cl USING g_fcb.fcb01
            IF STATUS THEN
               CALL cl_err("OPEN t700_cl:", STATUS, 1)   
               CLOSE t700_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t700_cl INTO g_fcb.*              # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fcb.fcb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t700_cl ROLLBACK WORK RETURN
            END IF
           #IF l_faj_t.faj02 IS NOT NULL THEN
             IF g_rec_b>=l_ax THEN                   #No.MOD-4A0133
               LET p_cmd='u'
 
               OPEN t700_bclx USING l_faj_t.faj02,l_faj_t.faj022
               IF STATUS THEN
                  CALL cl_err("OPEN t700_bcl:", STATUS, 1)
                  CLOSE t700_bclx
                  LET l_lock_sw = "Y"
                  ROLLBACK WORK
                  RETURN
               ELSE
                  FETCH t700_bclx INTO l_faj[l_ax].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(l_faj[l_ax].faj02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
##Modify:2639
             NEXT FIELD fajyn
 
          ON ROW CHANGE
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 LET l_faj[l_ax].* = l_faj_t.*
                 CLOSE t700_bclx
                 ROLLBACK WORK
                 EXIT INPUT
              END IF
              IF l_lock_sw = 'Y' THEN
                 CALL cl_err(l_faj[l_ax].fajyn,-263,1)
                 LET l_faj[l_ax].* = l_faj_t.*
              ELSE
                 UPDATE faj_temp SET fajyn = l_faj[l_ax].fajyn
                  WHERE faj02 = l_faj[l_ax].faj02
                    AND faj022 = l_faj[l_ax].faj022
                 IF SQLCA.sqlcode THEN
#                    CALL cl_err(l_faj[l_ax].faj02,SQLCA.sqlcode,0)   #No.FUN-660136
                     CALL cl_err3("upd","faj_temp",l_faj[l_ax].faj02,l_faj[l_ax].faj022,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                     LET l_faj[l_ax].* = l_faj_t.*
                 ELSE
                     MESSAGE 'UPDATE O.K'
                     COMMIT WORK
                 END IF
              END IF
 
          AFTER ROW
              LET l_ax = ARR_CURR()
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                  LET l_faj[l_ax].* = l_faj_t.*         #No.MOD-4A0133
                 CLOSE t700_bclx
                 ROLLBACK WORK
                 EXIT INPUT
              END IF
               LET l_faj_t.* = l_faj[l_ax].*            #No.MOD-4A0133
              CLOSE t700_bclx
              COMMIT WORK
 
{Genero mark
          ON ACTION select_cancel
             IF l_faj[l_ax].fajyn = 'Y' THEN
                LET l_faj[l_ax].fajyn = 'N'
             ELSE
                LET l_faj[l_ax].fajyn = 'Y'
             END IF
             NEXT FIELD fajyn
}
 
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
    CLOSE t700_cl
    CLOSE t700_bclx
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t700_putb()                             # 將 faj_temp 中[Y] 者新增至單身檔中
DEFINE
    l_maxac         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    l_fcc           RECORD LIKE fcc_file.*,
    p_faj           RECORD                 #程式變數(Program Variables)
        faj02       LIKE faj_file.faj02,   #財產編號
        faj022      LIKE faj_file.faj022,  #附號
        faj26       LIKE faj_file.faj26,   #入帳日期
        faj51       LIKE faj_file.faj51,   #發票號碼
        faj17       LIKE faj_file.faj17,   #數量
        faj18       LIKE faj_file.faj18,   #單位
        faj14       LIKE faj_file.faj14,   #本幣成本
        faj06       LIKE faj_file.faj06,   #中文名稱
        faj07       LIKE faj_file.faj07,   #英文名稱
        faj08       LIKE faj_file.faj08,   #規格型規
        faj11       LIKE faj_file.faj11,   #製造廠商
        faj16       LIKE faj_file.faj16,   #原幣成本
        faj15       LIKE faj_file.faj15    #原幣幣別
                    END RECORD,
    p_faj0          RECORD                 #程式變數(Program Variables)
                       faj421      LIKE faj_file.faj421,
                       faj422      LIKE faj_file.faj422
                    END RECORD,
    l_rate LIKE faj_file.faj422
 
    DECLARE t700_putb CURSOR WITH HOLD FOR
     SELECT faj_temp.faj02,faj_temp.faj022,faj_temp.faj26,
            faj_temp.faj51,faj_temp.faj17,faj_temp.faj18,
            faj_temp.faj14,faj_temp.faj06,faj_temp.faj07,
            faj_file.faj08,faj_file.faj11,faj_file.faj16,faj_file.faj15
            ,faj_file.faj421,faj_file.faj422
       FROM faj_temp,faj_file
      WHERE faj_temp.fajyn  = 'Y'
        AND faj_temp.faj02  = faj_file.faj02
        AND faj_temp.faj022 = faj_file.faj022
    SELECT max(fcc02)+1 INTO l_ac FROM fcc_file WHERE fcc01 = g_fcb.fcb01
    IF l_ac IS NULL THEN LET l_ac = 1 END IF
    BEGIN WORK
    LET g_success = 'Y'
    CALL s_showmsg_init()    #No.FUN-710028
    FOREACH t700_putb INTO p_faj.*,p_faj0.*
#No.FUN-710028 --begin                                                                                                              
        IF g_success='N' THEN                                                                                                         
           LET g_totsuccess='N'                                                                                                       
           LET g_success="Y"                                                                                                          
        END IF                                                                                                                        
#No.FUN-710028 --end
 
        IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)                         #No.FUN-710028
            CALL s_errmsg('faj_temp.fajyn','Y','foreach:',SQLCA.sqlcode,0)  #No.FUN-710028
            EXIT FOREACH
        END IF
        message p_faj.faj02,' ',p_faj.faj022
        CALL t700_faj11(p_faj.faj11) RETURNING p_faj.faj11
        IF p_faj.faj17 IS NULL THEN LET p_faj.faj17 = 0 END IF
        IF p_faj.faj14 IS NULL THEN LET p_faj.faj14 = 0 END IF
        IF p_faj.faj16 IS NULL THEN LET p_faj.faj16 = 0 END IF
        IF p_faj.faj15 =g_aza.aza17
        THEN LET l_rate = p_faj0.faj421
        ELSE LET l_rate = p_faj0.faj422
        END IF
 
        LET l_fcc.fcc01 = g_fcb.fcb01
        LET l_fcc.fcc02 = l_ac
        LET l_fcc.fcc03 = p_faj.faj02
        LET l_fcc.fcc031= p_faj.faj022
        LET l_fcc.fcc09 = p_faj.faj17
        LET l_fcc.fcc10 = p_faj.faj18
        LET l_fcc.fcc24 = p_faj.faj14
        LET l_fcc.fcc05 = p_faj.faj06
        LET l_fcc.fcc06 = p_faj.faj07
        LET l_fcc.fcc07 = p_faj.faj08
        LET l_fcc.fcc08 = p_faj.faj11
        LET l_fcc.fcc23 = p_faj.faj16
        LET l_fcc.fcc14 = p_faj.faj15
        LET l_fcc.fcc21 = p_faj.faj17
        LET l_fcc.fcc22 = p_faj.faj18
        LET l_fcc.fcc23 = p_faj.faj16
        LET l_fcc.fcc24 = p_faj.faj14
        LET l_fcc.fcc04 = '1'
        LET l_fcc.fcc20 = '2'
        LET l_fcc.fcc15 = l_rate
        LET l_fcc.fcc191= p_faj.faj26
        #NO:7949
        LET l_fcc.fcc17 = NULL
        LET l_fcc.fcc18 = NULL
        LET l_fcc.fcc19 = NULL
        LET l_fcc.fcclegal = g_legal #FUN-980003 add
 
       INSERT INTO fcc_file VALUES(l_fcc.*)
       IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#         CALL cl_err('afa-',STATUS,0)   #No.FUN-660136
#         CALL cl_err3("ins","fcc_file",l_fcc.fcc01,l_fcc.fcc02,SQLCA.sqlcode,"","afa-",1)  #No.FUN-660136 #No.FUN-710028
          LET g_showmsg = l_fcc.fcc01,"/",l_fcc.fcc03,"/",l_fcc.fcc031    #No.FUN-710028
          CALL s_errmsg('fcc01,fcc03,fcc031',g_showmsg,'afa-',STATUS,1)   #No.FUN-710028
          LET g_success = 'N'
#         EXIT FOREACH      #No.FUN-710028
          CONTINUE FOREACH  #No.FUN-710028
       END IF
        IF STATUS = 0  THEN
           LET l_ac = l_ac + 1
        END IF
     END FOREACH
#No.FUN-710028 --begin                                                                                                              
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
#No.FUN-710028 --end
     CALL s_showmsg()  #No.FUN-710028
     IF g_success ='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
     LET l_maxac = l_ac - 1
     IF INT_FLAG THEN LET INT_FLAG = 0 END IF
END FUNCTION
 
FUNCTION t700_b_fillx()              #BODY FILL UP 將暫存檔中的資料顯示出來
    DECLARE faj_curs CURSOR WITH HOLD FOR
     SELECT * FROM faj_temp #SCROLL CURSOR
 
    CALL l_faj.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH faj_curs INTO l_faj[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) 
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
     CALL l_faj.deleteElement(g_cnt)       #No.MOD-4A0133
    LET g_rec_b = g_cnt -1
   error   "共選筆數[ ",g_rec_b,"]" sleep 2
END FUNCTION
 
FUNCTION t700_bpx(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY l_faj TO s_faj.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_ac = ARR_CURR()
 
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
         CALL t700_fetch('F')
         LET g_action_choice="first"
         EXIT DISPLAY
      ON ACTION previous
      ON ACTION jump
         LET g_action_choice="jump"
         EXIT DISPLAY
      ON ACTION next
      ON ACTION last
         LET g_action_choice="last"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t700_3()
    DEFINE  l_fcc01    LIKE    fcc_file.fcc01
    DEFINE  l_fcc03    LIKE    fcc_file.fcc03
    DEFINE  l_fcc031   LIKE    fcc_file.fcc031
    DEFINE  l_fcc20    LIKE    fcc_file.fcc20  #MOD-B30360 add
 
   IF g_fcb.fcb01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fcb.fcbconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
   END IF
 #MOD-530831 若管理局未核准,則不做復原動作
   IF cl_null(g_fcb.fcb04) THEN
      CALL cl_err(g_fcb.fcb01,'afa-357',0)
      RETURN
   END IF
 #END MOD-530831
 #MOD-560011
{
   IF NOT cl_null(g_fcb.fcb06) THEN
       CALL cl_err(g_fcb.fcb06,'afa-324',0) RETURN
    END IF
}
 #END MOD-560011
    MESSAGE ""
    IF NOT cl_sure(0,0) THEN RETURN END IF
    BEGIN WORK
    LET g_success = 'Y'
    # 管理局核准日期, 文號 清為空白
    UPDATE fcb_file SET fcb03 = NULL, fcb04 = NULL
                  WHERE fcb01 = g_fcb.fcb01
     IF STATUS THEN                   #No.MOD-490227
#      CALL cl_err('err upd fcb',STATUS,0)   #No.FUN-660136
       CALL cl_err3("upd","fcb_file",g_fcb.fcb01,"",SQLCA.sqlcode,"","err upd fcb",1)  #No.FUN-660136
       LET g_success = 'N'
    END IF
#MOD-580380
#    UPDATE fcc_file SET fcc20 = '2' WHERE fcc01 = g_fcb.fcb01
#                                      AND fcc20 IN ('3','4')
#     IF STATUS  THEN                   #No.MOD-490227
#       CALL cl_err('err upd fcc',STATUS,0)
#       LET g_success = 'N'
#    END IF
 
    IF g_fcb.fcb05 IS NULL AND g_fcb.fcb06 IS NULL THEN
       UPDATE fcc_file SET fcc20 = '2' WHERE fcc01 = g_fcb.fcb01
        IF STATUS  THEN
#         CALL cl_err('err upd fcc',STATUS,0)   #No.FUN-660136
          CALL cl_err3("upd","fcc_file",g_fcb.fcb01,"",SQLCA.sqlcode,"","err upd fcc",1)  #No.FUN-660136
          LET g_success = 'N'
        END IF
    ELSE
       UPDATE fcc_file SET fcc20 = '5' WHERE fcc01 = g_fcb.fcb01
        IF STATUS  THEN
#         CALL cl_err('err upd fcc',STATUS,0)   #No.FUN-660136
          CALL cl_err3("upd","fcc_file",g_fcb.fcb01,"",SQLCA.sqlcode,"","err upd fcc",1)  #No.FUN-660136
          LET g_success = 'N'
        END IF
    END IF
#END MOD-580380
 
    DECLARE t700_fcc_cur1 CURSOR FOR
    # SELECT fcc01,fcc03,fcc031 FROM fcc_file         #MOD-B30360 mark
     SELECT fcc01,fcc03,fcc031,fcc20 FROM fcc_file    #MOD-B30360 add fcc20
      WHERE fcc01 = g_fcb.fcb01
 #NO:8013 031009 modify
     #  AND fcc20 IN ('3','4')
     #  AND fcc20 = '2'   #MOD-B30360 mark
    CALL s_showmsg_init() #No.FUN-710028
    #FOREACH t700_fcc_cur1 INTO l_fcc01,l_fcc03,l_fcc031        #MOD-B30360 mark
    FOREACH t700_fcc_cur1 INTO l_fcc01,l_fcc03,l_fcc031,l_fcc20 #MOD-B30360 add
        IF STATUS THEN
#          CALL cl_err('foreach:fcc_cur1',STATUS,0)   #No.FUN-710028 
           LET g_showmsg = g_fcb.fcb01,"/",'2'        #No.FUN-710028
           CALL s_errmsg('fcc01,fcc20',g_showmsg,'foreach:fcc_cur1',STATUS,1)  #No.FUN-710028 
           LET g_success = 'N'
           EXIT FOREACH
        END IF
#No.FUN-710028 --begin                                                                                                              
        IF g_success='N' THEN                                                                                                         
           LET g_totsuccess='N'                                                                                                       
           LET g_success="Y"                                                                                                          
        END IF                                                                                                                        
#No.FUN-710028 --end
 
        #UPDATE faj_file SET faj42 = '2',     #MOD-B30360 mark
        UPDATE faj_file SET faj42 = l_fcc20,  #MOD-B30360 add
                            faj82 = NULL,
                            faj83 = NULL
         WHERE faj02 = l_fcc03 AND faj022 = l_fcc031
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err('err upd faj',STATUS,0)   #No.FUN-660136
#          CALL cl_err3("upd","faj_file",l_fcc03,l_fcc031,SQLCA.sqlcode,"","",1)  #No.FUN-660136 #No.FUN-710028
           LET g_showmsg = l_fcc03,"/",l_fcc031  #No.FUN-710028
           CALL s_errmsg('faj02,faj022',g_showmsg,'err upd faj',STATUS,1)         #No.FUN-710028
#          LET g_success = 'N' EXIT FOREACH     #No.FUN-710028
           LET g_success = 'N' CONTINUE FOREACH #No.FUN-710028
        END IF
    END FOREACH
#No.FUN-710028 --begin                                                                                                              
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
#No.FUN-710028 --end
    CALL s_showmsg()   #No.FUN-710028
    IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION
 
FUNCTION t700_4()
    DEFINE  l_fcc01    LIKE    fcc_file.fcc01
    DEFINE  l_fcc03    LIKE    fcc_file.fcc03
    DEFINE  l_fcc031   LIKE    fcc_file.fcc031
    DEFINE  l_fcc20    LIKE    fcc_file.fcc20  #MOD-B30360 add
 
    IF g_fcb.fcb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_fcb.fcbconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
# 98/07/04 加判斷當國稅局文號=null 時表示未核淮則不做復原
    IF cl_null(g_fcb.fcb06)  THEN
       CALL cl_err(g_fcb.fcb01,'afa-353',0) RETURN   END IF
 
    MESSAGE ""
    IF NOT cl_sure(0,0) THEN RETURN END IF
 
    BEGIN WORK
 
    OPEN t700_cl USING g_fcb.fcb01
    IF STATUS THEN
       CALL cl_err("OPEN t700_cl:", STATUS, 1)
       CLOSE t700_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t700_cl INTO g_fcb.*              # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fcb.fcb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t700_cl ROLLBACK WORK RETURN
    END IF
    LET g_success = 'Y'
    # 國稅局核准日期, 文號 清為空白
    UPDATE fcb_file SET fcb05 = NULL , fcb06 = NULL
                  WHERE fcb01 = g_fcb.fcb01
     IF STATUS THEN        #No.MOD-490227
#      CALL cl_err('err upd fcb',STATUS,0)   #No.FUN-660136
       CALL cl_err3("upd","fcb_file",g_fcb.fcb01,"",SQLCA.sqlcode,"","err upd fcb",1)  #No.FUN-660136
       LET g_success = 'N'
       CLOSE t700_cl ROLLBACK WORK RETURN
    END IF
#MOD-580380
#    UPDATE fcc_file SET fcc20 = '3' WHERE fcc01 = g_fcb.fcb01
#                                      AND fcc20 IN ('5','6')
#     IF STATUS THEN            #No.MOD-490227
#       CALL cl_err('err upd fcc',STATUS,0)
#       LET g_success = 'N'
#       CLOSE t700_cl ROLLBACK WORK RETURN
#    END IF
    IF g_fcb.fcb03 IS NULL AND g_fcb.fcb04 IS NULL THEN
       UPDATE fcc_file SET fcc20 = '2' WHERE fcc01 = g_fcb.fcb01
       IF STATUS THEN
#         CALL cl_err('err upd fcc',STATUS,0)   #No.FUN-660136
          CALL cl_err3("upd","fcc_file",g_fcb.fcb01,"",SQLCA.sqlcode,"","err upd fcc",1)  #No.FUN-660136
          LET g_success = 'N'
          CLOSE t700_cl ROLLBACK WORK RETURN
       END IF
    ELSE
       UPDATE fcc_file SET fcc20 = '3' WHERE fcc01 = g_fcb.fcb01
       IF STATUS THEN
#         CALL cl_err('err upd fcc',STATUS,0)   #No.FUN-660136
          CALL cl_err3("upd","fcc_file",g_fcb.fcb01,"",SQLCA.sqlcode,"","err upd fcc",1)  #No.FUN-660136
          LET g_success = 'N'
          CLOSE t700_cl ROLLBACK WORK RETURN
       END IF
    END IF
#END MOD-580380
 
##Modify:2634
    DECLARE t700_fcc_cur2 CURSOR FOR
    #SELECT fcc01,fcc03,fcc031 FROM fcc_file        #MOD-B30360 mark
     SELECT fcc01,fcc03,fcc031,fcc20 FROM fcc_file  #MOD-B30360 add fcc20
      WHERE fcc01 = g_fcb.fcb01
     #NO:8013 031009 modify
      # AND fcc20 IN ('5','6')
      # AND fcc20 = '3'   #MOD-B30360 mark
    CALL s_showmsg_init() #No.FUN-710028
    #FOREACH t700_fcc_cur2 INTO l_fcc01,l_fcc03,l_fcc031         #MOD-B30360 mark
    FOREACH t700_fcc_cur2 INTO l_fcc01,l_fcc03,l_fcc031,l_fcc20  #MOD-B30360 add fcc20
 
        IF STATUS THEN
#          CALL cl_err('foreach:fcc_cur2',STATUS,0)   #No.FUN-710028
           LET g_showmsg = g_fcb.fcb01,"/",'3'        #No.FUN-710028
           CALL s_errmsg('fcc01,fcc20',g_showmsg,'foreach:fcc_cur2',STATUS,1)   #No.FUN-710028
           LET g_success = 'N'
           EXIT FOREACH
        END IF
#No.FUN-710028 --begin                                                                                                              
        IF g_success='N' THEN                                                                                                         
           LET g_totsuccess='N'                                                                                                       
           LET g_success="Y"                                                                                                          
        END IF                                                                                                                        
#No.FUN-710028 --end
 
##Modify:2634
        #UPDATE faj_file SET faj42 = '3',     #MOD-B30360 mark
        UPDATE faj_file SET faj42 = l_fcc20,  #MOD-B30360 add
                            faj84 = NULL,
                            faj85 = NULL
         WHERE faj02 = l_fcc03 AND faj022 = l_fcc031
           AND faj42 IN ('5','6')
         IF STATUS  THEN            #No.MOD-490227
#          CALL cl_err('err upd faj',STATUS,0)   #No.FUN-660136
#          CALL cl_err3("upd","faj_file",l_fcc03,l_fcc031,SQLCA.sqlcode,"","err upd faj",1)  #No.FUN-660136 #No.FUN-710028
           LET g_showmsg = l_fcc03,"/",l_fcc031  #No.FUN-710028
           CALL s_errmsg('faj02,faj022',g_showmsg,'err upd faj',STATUS,1)   #No.FUN-710028
#          LET g_success = 'N' EXIT FOREACH     #No.FUN-710028
           LET g_success = 'N' CONTINUE FOREACH #No.FUN-710028
        END IF
    END FOREACH
#No.FUN-710028 --begin                                                                                                              
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
#No.FUN-710028 --end
 
    CLOSE t700_cl
    CALL s_showmsg()   #No.FUN-710028
    IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION
 
FUNCTION t700_get_fai(p_code)
  define p_code LIKE fai_file.fai01         #No.FUN-680070 VARCHAR(20)
  define aa LIKE fai_file.fai02             #No.FUN-680070 VARCHAR(30)
  select fai02 into aa from fai_file
         where fai01=p_code and
               faiacti="Y"
  IF sqlca.sqlcode <>0
     then let aa = p_code
  END IF
  return aa
END FUNCTION
 
FUNCTION get_sum_amt_qty(curr)
 define tot_qty,curr LIKE type_file.num5    #No.FUN-680070 smallint
 define tot_amt LIKE type_file.num20_6      #No.FUN-680070 dec(20,6)
 define ntd_tot_amt LIKE type_file.num20_6  #No.FUN-680070 dec(20,6)
 define l_fcc21 LIKE fcc_file.fcc21         #No.FUN-680070 smallint
 
 let tot_qty =0
 let tot_amt =0
 let ntd_tot_amt =0
 select sum(fcc21),sum(fcc23),sum(fcc24) into
        tot_qty,tot_amt,ntd_tot_amt from fcc_file
        where fcc01=g_fcb.fcb01 and
              fcc02 = g_fcc[curr].fcc02
 
 select (fcc21) into l_fcc21 from fcc_file
        where fcc01=g_fcb.fcb01 and
              fcc02 = g_fcc[curr].fcc02 and
              fcc04="2"
 IF sqlca.sqlcode =0 then let tot_qty =l_fcc21 END IF
 return  tot_qty,tot_amt,ntd_tot_Amt
END FUNCTION
 
FUNCTION t700_faj11(p_faj11)
  define p_faj11 like faj_file.faj11
  define l_pmc03 like pmc_file.pmc03
 
  select pmc03 into l_pmc03 from pmc_file
          where pmc01=p_faj11
  IF sqlca.sqlcode <>0 then let l_pmc03=p_faj11 END IF
  return l_pmc03
END FUNCTION
FUNCTION t700_re()
    IF g_fcb.fcbconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    SELECT * INTO g_fcb.* FROM fcb_file WHERE fcb01 = g_fcb.fcb01
    LET g_wc2 = ' 1=1'
    CALL t700_show()
END FUNCTION
 
#FUNCTION t700_x()                      #FUN-D20035
FUNCTION t700_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_fcb.* FROM fcb_file WHERE fcb01=g_fcb.fcb01
   IF g_fcb.fcb01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fcb.fcbconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
  
   #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_fcb.fcbconf ='X' THEN RETURN END IF
   ELSE
      IF g_fcb.fcbconf <>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   BEGIN WORK
   LET g_success='Y'
 
   OPEN t700_cl USING g_fcb.fcb01
   IF STATUS THEN
      CALL cl_err("OPEN t700_cl:", STATUS, 1)
      CLOSE t700_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t700_cl INTO g_fcb.*#鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fcb.fcb01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t700_cl ROLLBACK WORK RETURN
   END IF
  #-->void轉換01/08/02
  #IF cl_void(0,0,g_fcb.fcbconf)   THEN                                #FUN-D20035 
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #FUN-D20035
   IF cl_void(0,0,l_flag) THEN                                         #FUN-D20035
        LET g_chr=g_fcb.fcbconf
       #IF g_fcb.fcbconf ='N' THEN                                   #FUN-D20035
        IF p_type = 1 THEN                                           #FUN-D20035
            LET g_fcb.fcbconf='X'
        ELSE
            LET g_fcb.fcbconf='N'
        END IF
   UPDATE fcb_file SET fcbconf = g_fcb.fcbconf,fcbmodu=g_user,fcbdate=TODAY
          WHERE fcb01 = g_fcb.fcb01
   IF STATUS THEN 
#     CALL cl_err('upd fcbconf:',STATUS,1)   #No.FUN-660136
      CALL cl_err3("upd","fcb_file",g_fcb.fcb01,"",STATUS,"","upd fcbconf:",1)  #No.FUN-660136
      LET g_success='N' 
   END IF
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   SELECT fcbconf INTO g_fcb.fcbconf FROM fcb_file
    WHERE fcb01 = g_fcb.fcb01
   DISPLAY BY NAME g_fcb.fcbconf
  END IF
  IF g_fcb.fcbconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  CALL cl_set_field_pic(g_fcb.fcbconf,"","","",g_chr,"")
END FUNCTION
 
#Patch....NO.MOD-5A0095 <001,002,003,004,005> #

