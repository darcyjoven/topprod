# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afat106.4gl
# Descriptions...: 固定資產重估作業
# Date & Author..: 96/06/04 By Sophia
# Modify.........: 97/04/14 By Danny 稅簽資料預設與財簽資料相同
# Modify.........: 02/10/15 BY Maggie   No.A032
# Modify.........: No:7837 03/08/19 By Wiky 呼叫自動取單號時應在 Transction中
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-470515 04/07/30 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-480099 04/08/13 By Nicola 調整稅簽修改單身輸入順序
# Modify.........: No.MOD-490163 04/09/10 By Nicola 稅簽過帳default 'N'
# Modify.........: No.MOD-490235 04/09/13 By Yuna 自動生成改成用confirm的方式
# Modify.........: No.MOD-490164 04/09/16 By Kitty 增加判斷,若稅簽已過帳,不可取消確認
# Modify.........: No.MOD-490344 04/09/20 By Kitty controlp 少display 補入
# Modify.........: No.MOD-4A0248 04/10/25 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0008 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.MOD-530473 05/03/31 By Smapmin 過帳時有INS ERRROR,但仍可過帳
# Modify.........: No.MOD-530464 05/04/11 By Smapmin B單身輸入qbe無法依qbe自動產生資料
# Modify.........: NO.FUN-550034 05/05/17 By jackie 單據編號加大
# Modify.........: NO.FUN-560002 05/06/06 By vivien 單據編號修改
# Modify.........: No.FUN-580109 05/09/20 By Sarah 以EF為backend engine,由TIPTOP處理前端簽核動作
# Modify.........: No.FUN-5B0018 05/11/04 By Sarah 重估日期沒有判斷關帳日
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-620120 06/03/02 By Smapmin 當附號為NULL時,LET 附號為空白
# Modify.........: No.TQC-630073 06/03/07 By Mandy 流程訊息通知功能
# Modify.........: No.FUN-630045 06/03/15 BY Alexstar 新增申請人(表單關係人)欄位
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-640243 06/05/15 By Echo 自動執行確認功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670060 06/08/07 By Ray 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680028 06/08/22 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION t106_q() 一開始應清空g_fba.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.MOD-690081 06/12/06 By Smapmin 已確認的單子不可再重新產生分錄
# Modify.........: No.FUN-710028 07/02/01 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740033 07/04/11 By Carrier 會計科目加帳套-財務
# Modify.........: No.TQC-740222 07/04/24 By Echo 從ERP簽核時，「拋轉傳票」、「傳票拋轉還原」action應隱藏
# Modify.........: No.MOD-740436 07/04/24 By Smapmin 修改單別檢核
# Modify.........: No.TQC-740055 07/04/30 By Xufeng 單身中“未用年月”、“調整成本”都能為負數 
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760182 07/06/27 By chenl  自動產生QBE條件不可為空。
# Modify.........: No.TQC-780089 07/09/21 By Smapmin 自動產生或單身輸入資產編號時,當月有折舊不可輸入
#                                                    已有折舊資料不可過帳還原或確認
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-840111 08/04/23 By lilingyu 預設申請人員登入帳號
# Modify.........: No.FUN-850068 08/05/14 By TSD.zeak 自訂欄位功能修改 
# Modify.........: No.MOD-860284 08/07/04 Sarah 使用afap302拋轉程式,原先傳g_user改為fbauser
# Modify.........: No.CHI-860025 08/07/23 By Smapmin 根據TQC-780089的修改,需區分財簽與稅簽
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.MOD-950166 09/05/18 By xiaofeizhu 增加對單身的管控
# Modify.........: No.MOD-970231 09/07/24 By Sarah 計算未折減額時,應抓faj33+faj331
# Modify.........: No.FUN-980003 09/08/10 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0077 10/01/06 By baofei 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A40043 10/04/08 by houlia 更改單據日期的控管
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No:CHI-A60036 10/07/12 By Summer 過帳檢查改用s_azmm,增加aza63判斷
# ModIFy.........: No:MOD-A80137 10/08/19 By Dido 過帳與取消過帳應檢核關帳日 
# Modify.........: No:TQC-AB0257 10/11/30 By suncx 新增fbb03欄位的控管
# Modify.........: No:MOD-B30291 11/03/14 By Dido fbb10 需取位 
# Modify.........: No.FUN-AB0088 11/04/07 By chenying 因固資拆出財二功能，原本寫入fap亦有新增欄位，增加對應處理
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.TQC-B30156 11/05/12 By Dido 預設 fap56 為 0
# Modify.........: No.FUN-B50090 11/06/01 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50118 11/06/13 By belle 自動產生鍵,增加QBE條件-族群編號
# Modify.........: No.FUN-B80054 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No:FUN-B60140 11/09/08 By minpp "財簽二二次改善" 追單
# Modify.........: No:FUN-BA0112 11/11/08 By Sakura 財簽二5.25與5.1程式比對不一致修改
# Modify.........: No:CHI-B80007 11/11/12 By johung 增加afa-309控卡 
# Modify.........: NO:FUN-B90004 11/11/17 By Belle 自動拋轉傳票單別一欄有值，即可進行傳票拋轉/傳票拋轉還原
# Modify.........: No:FUN-BC0004 11/12/01 By xuxz 處理相關財簽二無法存檔問題
# Modify.........: No:MOD-BC0025 11/12/10 By johung 調整afa-092控卡的判斷
# Modify.........: No:MOD-C10026 12/01/10 By wujie  审核时若需要自动抛转凭证则同步过帐码
# Modify.........: NO:FUN-BB0122 12/01/12 By Sakura 財二預設修改
# Modify.........: No:MOD-BC0125 12/01/12 By Sakura 產生分錄及分錄底稿Action加判斷
#                                                    產生分錄(財簽二)及分錄底稿(財簽二)加判斷
# Modify.........: No:MOD-BC0127 12/01/12 By Sakura 將t106_fbb031()中，select faj_file的條件式改與自動產生時同


# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20012 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:FUN-C30140 12/03/12 By Mandy (1)TIPTOP端簽核時,以下ACTION應隱藏
#                                                     分錄底稿二,產生分錄底稿(財簽二),財簽二資料,拋轉傳票(財簽二),傳票拋轉還原(財簽二),過帳(財簽二),過帳還原(財簽二)
#                                                  (2)送簽中,應不可執行"自動產生" ,"分錄底稿","分錄底稿二","產生分錄底稿","產生分錄底稿(財簽二）","財簽二資料","稅簽修改"ACTION
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 原使用fahdmy3判斷的程式，將財二部份拆分出來使用fahdmy32處理
# Modify.........: No:MOD-C50044 12/05/09 By Elise 按下確認時，會出現afai900內當月份有做調整的單被當成是已提列折舊的單
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.MOD-C50255 12/06/05 By Polly 增加控卡維護拋轉總帳單別
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C60010 12/06/15 By jinjj 財簽二欄位需依財簽二幣別做取位
# Modify.........: No.MOD-C70265 12/07/27 By Polly 資產不存在時,將 afa-093 改用訊息 afa-134
# Modify.........: No:CHI-C90051 12/09/08 By Polly 1.將拋轉還原程式移至更新確認碼/過帳碼前處理，並判斷傳票編號如不為null時，則RETURN
#                                                  2.確認段不需拋轉傳票故mark
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-E80012 18/11/29 By lixwz 修改付款日期之後,tic現金流量明細重複

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fba   RECORD LIKE fba_file.*,
    g_fba_t RECORD LIKE fba_file.*,
    g_fba_o RECORD LIKE fba_file.*,
    g_fahconf       LIKE fah_file.fahconf,
    g_fahpost       LIKE fah_file.fahpost,
    g_fahapr        LIKE fah_file.fahapr,             #FUN-640243
    g_fbb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    fbb02     LIKE fbb_file.fbb02,
                    fbb03     LIKE fbb_file.fbb03,
                    fbb031    LIKE fbb_file.fbb031,
                    faj06     LIKE faj_file.faj06,
                    fbb04     LIKE fbb_file.fbb04,
                    fbb08     LIKE fbb_file.fbb08,
                    fbb05     LIKE fbb_file.fbb05,
                    fbb09     LIKE fbb_file.fbb09,
                    fbb06     LIKE fbb_file.fbb06,
                    fbb10     LIKE fbb_file.fbb10,
                    fbb12     LIKE fbb_file.fbb12
                    ,fbbud01 LIKE fbb_file.fbbud01,
                    fbbud02 LIKE fbb_file.fbbud02,
                    fbbud03 LIKE fbb_file.fbbud03,
                    fbbud04 LIKE fbb_file.fbbud04,
                    fbbud05 LIKE fbb_file.fbbud05,
                    fbbud06 LIKE fbb_file.fbbud06,
                    fbbud07 LIKE fbb_file.fbbud07,
                    fbbud08 LIKE fbb_file.fbbud08,
                    fbbud09 LIKE fbb_file.fbbud09,
                    fbbud10 LIKE fbb_file.fbbud10,
                    fbbud11 LIKE fbb_file.fbbud11,
                    fbbud12 LIKE fbb_file.fbbud12,
                    fbbud13 LIKE fbb_file.fbbud13,
                    fbbud14 LIKE fbb_file.fbbud14,
                    fbbud15 LIKE fbb_file.fbbud15
                    END RECORD,
    g_fbb_t         RECORD
                    fbb02     LIKE fbb_file.fbb02,
                    fbb03     LIKE fbb_file.fbb03,
                    fbb031    LIKE fbb_file.fbb031,
                    faj06     LIKE faj_file.faj06,
                    fbb04     LIKE fbb_file.fbb04,
                    fbb08     LIKE fbb_file.fbb08,
                    fbb05     LIKE fbb_file.fbb05,
                    fbb09     LIKE fbb_file.fbb09,
                    fbb06     LIKE fbb_file.fbb06,
                    fbb10     LIKE fbb_file.fbb10,
                    fbb12     LIKE fbb_file.fbb12
                    ,fbbud01 LIKE fbb_file.fbbud01,
                    fbbud02 LIKE fbb_file.fbbud02,
                    fbbud03 LIKE fbb_file.fbbud03,
                    fbbud04 LIKE fbb_file.fbbud04,
                    fbbud05 LIKE fbb_file.fbbud05,
                    fbbud06 LIKE fbb_file.fbbud06,
                    fbbud07 LIKE fbb_file.fbbud07,
                    fbbud08 LIKE fbb_file.fbbud08,
                    fbbud09 LIKE fbb_file.fbbud09,
                    fbbud10 LIKE fbb_file.fbbud10,
                    fbbud11 LIKE fbb_file.fbbud11,
                    fbbud12 LIKE fbb_file.fbbud12,
                    fbbud13 LIKE fbb_file.fbbud13,
                    fbbud14 LIKE fbb_file.fbbud14,
                    fbbud15 LIKE fbb_file.fbbud15
                    END RECORD,
    g_e             DYNAMIC ARRAY OF RECORD
                    fbb13     LIKE fbb_file.fbb13,
                    fbb14     LIKE fbb_file.fbb14,
                    fbb15     LIKE fbb_file.fbb15,
                    fbb17     LIKE fbb_file.fbb17,
                    fbb18     LIKE fbb_file.fbb18,
                    fbb19     LIKE fbb_file.fbb19
                    END RECORD,
    g_fah           RECORD LIKE fah_file.*,
    g_fba01_t       LIKE fba_file.fba01,
    g_faj28         LIKE faj_file.faj28,
    g_argv1             LIKE type_file.chr20,           #No.FUN-560002          #No.FUN-680070 VARCHAR(16)
    g_argv2             STRING,             # 指定執行功能:query or inser  #TQC-630073
    l_modify_flag       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    l_flag              LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
     g_wc,g_wc2,g_sql   STRING,  #No.FUN-580092 HCN
    g_t1                LIKE type_file.chr5,     #No.FUN-550034          #No.FUN-680070 VARCHAR(5)
    g_buf               LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
    g_rec_b             LIKE type_file.num5,                #單身筆數       #No.FUN-680070 SMALLINT
    l_ac                LIKE type_file.num5                 #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
DEFINE g_bookno1        LIKE aza_file.aza81   #No.FUN-740033
DEFINE g_bookno2        LIKE aza_file.aza82   #No.FUN-740033
DEFINE g_flag           LIKE type_file.chr1   #No.FUN-740033
DEFINE g_laststage      LIKE type_file.chr1                  #FUN-580109       #No.FUN-680070 VARCHAR(1)
DEFINE p_row,p_col      LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_forupd_sql     STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_chr            LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE g_chr2           LIKE type_file.chr1      #FUN-580109       #No.FUN-680070 VARCHAR(1)
DEFINE g_cnt            LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE g_msg            LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE g_str            STRING     #No.FUN-670060
DEFINE g_wc_gl          STRING     #No.FUN-670060
DEFINE g_dbs_gl         LIKE type_file.chr21    #No.FUN-670060       #No.FUN-680070 VARCHAR(21)
DEFINE g_row_count      LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_curs_index     LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_jump           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE mi_no_ask        LIKE type_file.num5         #No.FUN-680070 SMALLINT
#FUN-AB0088---add---str---
DEFINE g_fbb2       DYNAMIC ARRAY OF RECORD    #祘Α跑计(Program Variables)
                    fbb02     LIKE fbb_file.fbb02,
                    fbb03     LIKE fbb_file.fbb03,
                    faj06     LIKE faj_file.faj06,
                    fbb031    LIKE fbb_file.fbb031,
                    fbb042    LIKE fbb_file.fbb042,
                    fbb082    LIKE fbb_file.fbb082,
                    fbb052    LIKE fbb_file.fbb052,
                    fbb092    LIKE fbb_file.fbb092,
                    fbb062    LIKE fbb_file.fbb062,
                    fbb102    LIKE fbb_file.fbb102,
                    fbb12     LIKE fbb_file.fbb12
                    END RECORD,
    g_fbb2_t        RECORD
                    fbb02     LIKE fbb_file.fbb02,
                    fbb03     LIKE fbb_file.fbb03,
                    faj06     LIKE faj_file.faj06,
                    fbb031    LIKE fbb_file.fbb031,
                    fbb042    LIKE fbb_file.fbb042,
                    fbb082    LIKE fbb_file.fbb082,
                    fbb052    LIKE fbb_file.fbb052,
                    fbb092    LIKE fbb_file.fbb092,
                    fbb062    LIKE fbb_file.fbb062,
                    fbb102    LIKE fbb_file.fbb102,
                    fbb12     LIKE fbb_file.fbb12
                    END RECORD

DEFINE g_cnt1       LIKE type_file.num10
#FUN-AB0088---add---end--
#CHI-C60010---str---
DEFINE g_azi04_1  LIKE azi_file.azi04,
       g_faj143   LIKE faj_file.faj143
#CHI-C60010---end---
 
MAIN
DEFINE
    l_sql         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP
    END IF
 
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
   IF INT_FLAG THEN EXIT PROGRAM END IF
     CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
       RETURNING g_time                                                                        #NO.FUN-6A0069
 
   LET g_forupd_sql = "SELECT * FROM fba_file WHERE fba01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t106_cl CURSOR FROM g_forupd_sql
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2) #TQC-630073
   LET g_wc2 = ' 1=1 '


   #CHI-C60010---str---
     SELECT aaa03 INTO g_faj143 FROM aaa_file
      WHERE aaa01 = g_faa.faa02c
     IF NOT cl_null(g_faj143) THEN
       SELECT azi04 INTO g_azi04_1 FROM azi_file
        WHERE azi01 = g_faj143
     END IF
    #CHI-C60010---end---
 
  IF g_bgjob='N' OR cl_null(g_bgjob) THEN
 
     LET p_row = 3 LET p_col = 15
     OPEN WINDOW t106_w AT p_row,p_col              #顯示畫面
           WITH FORM "afa/42f/afat106"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
     CALL cl_ui_init()
     #FUN-AB0088---add---str---
     IF g_faa.faa31 = 'Y' THEN  
      CALL cl_set_act_visible("fin_audit2,entry_sheet2",TRUE)
      CALL cl_set_act_visible("gen_entry2,post2,undo_post2",TRUE)  #No:FUN-B60140
      CALL cl_set_act_visible("carry_voucher2,undo_carry_voucher2",TRUE)  #No:FUN-B60140
      CALL cl_set_comp_visible("fba062,fba072,fbapost1",TRUE)  #No:FUN-B60140
     ELSE
      CALL cl_set_act_visible("fin_audit2,entry_sheet2",FALSE)
      CALL cl_set_act_visible("gen_entry2,post2,undo_post2",FALSE)  #No:FUN-B60140
      CALL cl_set_act_visible("carry_voucher2,undo_carry_voucher2",FALSE)  #No:FUN-B60140
      CALL cl_set_comp_visible("fba062,fba072,fbapost1",FALSE)  #No:FUN-B60140
     END IF
     #FUN-AB0088---add---end-- 
  END IF
 
   IF fgl_getenv('EASYFLOW') = "1" THEN
      LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
   END IF
 
   #建立簽核模式時的 toolbar icon
   CALL aws_efapp_toolbar()

  IF NOT cl_null(g_argv1) THEN
     CASE g_argv2
        WHEN "query"
           LET g_action_choice = "query"
           IF cl_chk_act_auth() THEN
              CALL t106_q()
           END IF
        WHEN "insert"
           LET g_action_choice = "insert"
           IF cl_chk_act_auth() THEN
              CALL t106_a()
           END IF
         WHEN "efconfirm"
            CALL t106_q()
            CALL t106_y_chk()          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               LET l_ac = 1
               CALL t106_y_upd()       #CALL 原確認的 update 段
            END IF
            EXIT PROGRAM
        OTHERWISE
           CALL t106_q()
     END CASE
  END IF
 
   #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
   CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm,   #FUN-D20035 add-undo_void
                              undo_confirm,easyflow_approval, auto_generate, entry_sheet, gen_entry, 
                              post, undo_post, amend_depr_tax, post_depr_tax, undo_post_depr_tax, 
                              carry_voucher, undo_carry_voucher,gen_entry2,post2,undo_post2,
                              entry_sheet2,gen_entry2,fin_audit2,carry_voucher2,undo_carry_voucher2,post2,undo_post2, 
                              carry_voucher2,undo_carry_voucher2")  #TQC-740222  #No:FUN-B60140     #FUN-C30140 
   RETURNING g_laststage
 
   CALL t106_menu()
   CLOSE WINDOW t106_w                    #結束畫面
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                                        #NO.FUN-6A0069 
END MAIN
 
FUNCTION t106_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                             #清除畫面
   CALL g_fbb.clear()
   CALL g_e.clear()
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " fba01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
   ELSE
      CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_fba.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
        fba01,fba02,fba09,fba06,fba07,fba062,fba072, #No:FUN-B60140 add fab062,fab072
        fbaconf,fbapost,fbapost1,fbapost2,#FUN-630045 #No:FUN-B60140  add fbapost1
        fbamksg,fba08,   #FUN-580109
        fbauser,fbagrup,fbamodu,fbadate
        ,fbaud01,fbaud02,fbaud03,fbaud04,fbaud05,
        fbaud06,fbaud07,fbaud08,fbaud09,fbaud10,
        fbaud11,fbaud12,fbaud13,fbaud14,fbaud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION controlp
           CASE
              WHEN INFIELD(fba01)    #查詢單據性質
 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_fba"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fba01
                 NEXT FIELD fba01
              WHEN INFIELD(fba09) #申請人
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fba09
                 NEXT FIELD fba09
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
 
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF

      CONSTRUCT g_wc2 ON fbb02,fbb03,fbb031,fbb04,fbb08,fbb05,
                         fbb09,fbb06,fbb10,fbb12
                         ,fbbud01,fbbud02,fbbud03,fbbud04,fbbud05,
                         fbbud06,fbbud07,fbbud08,fbbud09,fbbud10,
                         fbbud11,fbbud12,fbbud13,fbbud14,fbbud15
           FROM s_fbb[1].fbb02, s_fbb[1].fbb03, s_fbb[1].fbb031,
                s_fbb[1].fbb04, s_fbb[1].fbb08, s_fbb[1].fbb05,
                s_fbb[1].fbb09, s_fbb[1].fbb06,
                s_fbb[1].fbb10, s_fbb[1].fbb12
                ,s_fbb[1].fbbud01,s_fbb[1].fbbud02,s_fbb[1].fbbud03,
                s_fbb[1].fbbud04,s_fbb[1].fbbud05,s_fbb[1].fbbud06,
                s_fbb[1].fbbud07,s_fbb[1].fbbud08,s_fbb[1].fbbud09,
                s_fbb[1].fbbud10,s_fbb[1].fbbud11,s_fbb[1].fbbud12,
                s_fbb[1].fbbud13,s_fbb[1].fbbud14,s_fbb[1].fbbud15
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION controlp
           CASE
            WHEN INFIELD(fbb03)  #財產編號,財產附號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fbb03
                 NEXT FIELD fbb03
            WHEN INFIELD(fbb12)  #異動原因
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = "8"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fbb12
                 NEXT FIELD fbb12
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
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
      END CONSTRUCT
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    END IF

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fbauser', 'fbagrup')
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT fba01 FROM fba_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT fba01 ",
                   "  FROM fba_file, fbb_file",
                   " WHERE fba01 = fbb01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE t106_prepare FROM g_sql
    DECLARE t106_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t106_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM fba_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT fba01) FROM fba_file,fbb_file",
                  " WHERE fbb01 = fba01 ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED
    END IF
    PREPARE t106_prcount FROM g_sql
    DECLARE t106_count CURSOR WITH HOLD FOR t106_prcount
END FUNCTION
 
FUNCTION t106_menu()
   DEFINE l_creator    LIKE type_file.chr1           #「不准」時是否退回填表人 #FUN-580109       #No.FUN-680070 VARCHAR(1)
   DEFINe l_flowuser   LIKE type_file.chr1           # 是否有指定加簽人員      #FUN-580109       #No.FUN-680070 VARCHAR(1)
 
   LET l_flowuser = "N"   #FUN-580109
 
   WHILE TRUE
      CALL t106_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t106_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t106_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t106_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t106_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t106_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #FUN-AB0088---add---str---
         WHEN "fin_audit2"
            IF cl_chk_act_auth() THEN
               CALL t106_fin_audit2()
            END IF 
         #FUN-AB0088---add---end---
         WHEN "auto_generate"
            IF cl_chk_act_auth() THEN
              #FUN-C30140---add---str---
              IF NOT cl_null(g_fba.fba08) AND g_fba.fba08 matches '[Ss]' THEN     
                  CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
              ELSE
              #FUN-C30140---add---end---
                  CALL t106_g()
                  CALL t106_b()
              END IF #FUN-C30140 add
            END IF
         WHEN "entry_sheet"
            IF cl_chk_act_auth() AND not cl_null(g_fba.fba01) AND g_fah.fahfa1 = 'Y' THEN #MOD-BC0125 add fahfa1
              #FUN-C30140---add---str---
              IF NOT cl_null(g_fba.fba08) AND g_fba.fba08 matches '[Ss]' THEN     
                  CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
              ELSE
              #FUN-C30140---add---end---
                  CALL s_fsgl('FA',8,g_fba.fba01,0,g_faa.faa02b,1,g_fba.fbaconf,'0',g_faa.faa02p)     #No.FUN-680028
                  CALL t106_npp02('0')  #No.+087 010503 by plum     #No.FUN-680028
              END IF #FUN-C30140 add
            END IF
         WHEN "entry_sheet2"
            IF cl_chk_act_auth() AND not cl_null(g_fba.fba01) AND g_fah.fahfa2 = 'Y' THEN #MOD-BC0125 add fahfa2
              #FUN-C30140---add---str---
              IF NOT cl_null(g_fba.fba08) AND g_fba.fba08 matches '[Ss]' THEN     
                  CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
              ELSE
              #FUN-C30140---add---end---
                  CALL s_fsgl('FA',8,g_fba.fba01,0,g_faa.faa02c,1,g_fba.fbaconf,'1',g_faa.faa02p)     #No.FUN-680028
                  CALL t106_npp02('1')  #No.+087 010503 by plum     #No.FUN-680028
              END IF #FUN-C30140 add
            END IF
         WHEN "gen_entry"
            IF cl_chk_act_auth() AND g_fba.fbaconf <> 'X' AND g_fah.fahfa1 = 'Y' THEN #MOD-BC0125 add fahfa1
              #FUN-C30140---add---str---
              IF NOT cl_null(g_fba.fba08) AND g_fba.fba08 matches '[Ss]' THEN     
                  CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
              ELSE
              #FUN-C30140---add---end---
                  IF g_fba.fbaconf = 'N' THEN   #MOD-690081
                     LET g_success='Y' #no.5573
                     BEGIN WORK #no.5573
                     CALL s_showmsg_init()    #No.FUN-710028
                     CALL t106_gl(g_fba.fba01,g_fba.fba02,'0')
                    #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 mark
                    ##-----No:FUN-B60140 Mark-----
                     #IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088   
                     #   CALL t106_gl(g_fba.fba01,g_fba.fba02,'1')
                     #END IF
                     ##-----No:FUN-B60140 Mark END-----
                     CALL s_showmsg() #No.FUN-710028
                     IF g_success='Y' THEN
                        COMMIT WORK
                     ELSE
                        ROLLBACK WORK
                     END IF #no.5573
                  ELSE   #MOD-690081
                     CALL cl_err(g_fba.fba01,'afa-350',0)   #MOD-690081
                  END IF   #MOD-690081
              END IF #FUN-C30140 add
            END IF
         #-----No:FUN-B60140-----
         WHEN "gen_entry2"
            IF cl_chk_act_auth() AND g_fba.fbaconf <> 'X' AND g_fah.fahfa2 = 'Y' THEN #MOD-BC0125 add fahfa2
              #FUN-C30140---add---str---
              IF NOT cl_null(g_fba.fba08) AND g_fba.fba08 matches '[Ss]' THEN     
                  CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
              ELSE
              #FUN-C30140---add---end---
                  IF g_fba.fbaconf = 'N' THEN
                     LET g_success='Y'
                     BEGIN WORK
                     CALL s_showmsg_init()    #No.FUN-710028
                     CALL t106_gl(g_fba.fba01,g_fba.fba02,'1')
                     CALL s_showmsg()
                     IF g_success='Y' THEN
                        COMMIT WORK
                     ELSE
                        ROLLBACK WORK
                     END IF
                  ELSE
                     CALL cl_err(g_fba.fba01,'afa-350',0)
                  END IF
              END IF #FUN-C30140 add
            END IF
         #-----No:FUN-B60140 END-----
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t106_x()         #FUN-D20035
               CALL t106_x(1)           #FUN-D20035
            END IF

         #FUN-D20035---add--str
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t106_x(2)
            END IF
         #FUN-D20035---add---end

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t106_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t106_y_upd()       #CALL 原確認的 update 段
               END IF
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t106_z()
            END IF
         WHEN "carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_fba.fbapost = 'Y' THEN     #No.FUN-680028
                  CALL t106_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-557',1)     #No.FUN-680028
               END IF
            END IF
         WHEN "undo_carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_fba.fbapost = 'Y' THEN     #No.FUN-680028
                  CALL t106_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-558',1)     #No.FUN-680028
               END IF
            END IF
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t106_s()
            END IF
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t106_w()
            END IF
         #-----No:FUN-B60140-----
         WHEN "carry_voucher2"
            IF cl_chk_act_auth() THEN
               IF g_fba.fbapost1= 'Y' THEN
                  CALL t106_carry_voucher2()
               ELSE
                  CALL cl_err('','atm-557',1)
               END IF
            END IF
         WHEN "undo_carry_voucher2"
            IF cl_chk_act_auth() THEN
               IF g_fba.fbapost1= 'Y' THEN
                  CALL t106_undo_carry_voucher2()
               ELSE
                  CALL cl_err('','atm-558',1)
               END IF
            END IF
         WHEN "post2"
            IF cl_chk_act_auth() THEN
               CALL t106_s2()
            END IF
         WHEN "undo_post2"
            IF cl_chk_act_auth() THEN
               CALL t106_w2()
            END IF
         #-----No:FUN-B60140 END-----
         WHEN "amend_depr_tax"
            IF cl_chk_act_auth() THEN
               CALL t106_k()
            END IF
         WHEN "post_depr_tax"
            IF cl_chk_act_auth() THEN
               CALL t106_6()
            END IF
         WHEN "undo_post_depr_tax"
            IF cl_chk_act_auth() THEN
               CALL t106_7()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fba.fba01 IS NOT NULL THEN
                  LET g_doc.column1 = "fba01"
                  LET g_doc.value1 = g_fba.fba01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fbb),'','')
            END IF
        #@WHEN "簽核狀況"
        WHEN "approval_status"
             IF cl_chk_act_auth() THEN  #DISPLAY ONLY
                IF aws_condition2() THEN
                   CALL aws_efstat2()
                END IF
             END IF
        ##EasyFlow送簽
        WHEN "easyflow_approval"
             IF cl_chk_act_auth() THEN
               #FUN-C20012 add str---
                SELECT * INTO g_fba.* FROM fba_file
                 WHERE fba01 = g_fba.fba01
                CALL t106_show()
                CALL t106_b_fill(' 1=1')
               #FUN-C20012 add end---
                CALL t106_ef()
                CALL t106_show()  #FUN-C20012 add
             END IF
        #@WHEN "准"
        WHEN "agree"
             IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
                CALL t106_y_upd()      #CALL 原確認的 update 段
             ELSE
                LET g_success = "Y"
                IF NOT aws_efapp_formapproval() THEN
                   LET g_success = "N"
                END IF
             END IF
             IF g_success = 'Y' THEN
                IF cl_confirm('aws-081') THEN
                   IF aws_efapp_getnextforminfo() THEN
                      LET l_flowuser = 'N'
                      LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                      IF NOT cl_null(g_argv1) THEN
                         CALL t106_q()
                         #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                          CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm,  #FUN-D20035 add-undo_void
                                                   undo_confirm,easyflow_approval, auto_generate, entry_sheet, gen_entry,
                                                   post, undo_post, amend_depr_tax, post_depr_tax, undo_post_depr_tax,
                                                   carry_voucher, undo_carry_voucher,gen_entry2,post2,undo_post2,
                                                   entry_sheet2,gen_entry2,fin_audit2,carry_voucher2,undo_carry_voucher2,post2,undo_post2, 
                                                   carry_voucher2,undo_carry_voucher2")  #TQC-740222  #No:FUN-B60140    #FUN-C30140 
                          RETURNING g_laststage
                      ELSE
                         EXIT WHILE
                      END IF
                   ELSE
                      EXIT WHILE
                   END IF
                ELSE
                   EXIT WHILE
                END IF
             END IF
 
        #@WHEN "不准"
        WHEN "deny"
            IF ( l_creator := aws_efapp_backflow()) IS NOT NULL THEN
               IF aws_efapp_formapproval() THEN
                  IF l_creator = "Y" THEN
                     LET g_fba.fba08 = 'R'
                     DISPLAY BY NAME g_fba.fba08
                  END IF
                  IF cl_confirm('aws-081') THEN
                     IF aws_efapp_getnextforminfo() THEN
                        LET l_flowuser = 'N'
                        LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                        IF NOT cl_null(g_argv1) THEN
                           CALL t106_q()
                           #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                          CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm,   #FUN-D20035 add-undo_void
                                                      undo_confirm,easyflow_approval, auto_generate, entry_sheet, gen_entry, 
                                                      post, undo_post, amend_depr_tax, post_depr_tax, undo_post_depr_tax, 
                                                      carry_voucher, undo_carry_voucher,gen_entry2,post2,undo_post2,
                                                      entry_sheet2,gen_entry2,fin_audit2,carry_voucher2,undo_carry_voucher2,post2,undo_post2, 
                                                      carry_voucher2,undo_carry_voucher2")  #TQC-740222  #No:FUN-B60140 #FUN-C30140 
                           RETURNING g_laststage
                        ELSE
                           EXIT WHILE
                        END IF
                     ELSE
                        EXIT WHILE
                     END IF
                  ELSE
                     EXIT WHILE
                  END IF
               END IF
             END IF
 
        #@WHEN "加簽"
        WHEN "modify_flow"
             IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
                LET l_flowuser = 'Y'
             ELSE
                LET l_flowuser = 'N'
             END IF
 
        #@WHEN "撤簽"
        WHEN "withdraw"
             IF cl_confirm("aws-080") THEN
                IF aws_efapp_formapproval() THEN
                   EXIT WHILE
                END IF
             END IF
 
        #@WHEN "抽單"
        WHEN "org_withdraw"
             IF cl_confirm("aws-079") THEN
                IF aws_efapp_formapproval() THEN
                   EXIT WHILE
                END IF
             END IF
 
        #@WHEN "簽核意見"
        WHEN "phrase"
             CALL aws_efapp_phrase()
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t106_a()
 
DEFINE li_result   LIKE type_file.num5         #No.FUN-680070 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_fbb.clear()
    CALL g_e.clear()
    INITIALIZE g_fba.* TO NULL
    LET g_fba01_t = NULL
    LET g_fba_o.* = g_fba.*
    LET g_fba_t.* = g_fba.*
 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fba.fba02  =g_today
        LET g_fba.fbaconf='N'
        LET g_fba.fbapost='N'
        LET g_fba.fbapost1='N'  #No:FUN-B60140
        LET g_fba.fbapost2='N'
        LET g_fba.fbaprsw=0
        LET g_fba.fbauser=g_user
        LET g_fba.fbaoriu = g_user #FUN-980030
        LET g_fba.fbaorig = g_grup #FUN-980030
        LET g_fba.fbagrup=g_grup
        LET g_fba.fbadate=g_today
        LET g_fba.fbamksg = "N"   #FUN-580109
        LET g_fba.fba08 = "0"     #FUN-580109
        LET g_fba.fbalegal= g_legal    #FUN-980003 add
 
        LET g_fba.fba09=g_user                            
        CALL t106_fba09('d')

        CALL t106_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0
           INITIALIZE g_fba.* TO NULL
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        IF g_fba.fba01 IS NULL THEN       #KEY不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK  #No:7837
        CALL s_auto_assign_no("afa",g_fba.fba01,g_fba.fba02,"8","fba_file","fba01","","","")
             RETURNING li_result,g_fba.fba01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_fba.fba01

        INSERT INTO fba_file VALUES (g_fba.*)
        IF SQLCA.SQLCODE THEN
           CALL cl_err3("ins","fba_file",g_fba.fba01,"",SQLCA.sqlcode,"","Ins:",1)  #No.FUN-660136   #No.FUN-B80054---調整至回滾事務前---
           ROLLBACK WORK  #No:7837
           CONTINUE WHILE
        ELSE
           COMMIT WORK   #No:7837
           CALL cl_flow_notify(g_fba.fba01,'I')
        END IF
        CALL g_fbb.clear()
        LET g_rec_b=0
        LET g_fba_t.* = g_fba.*
        LET g_fba01_t = g_fba.fba01
        SELECT fba01 INTO g_fba.fba01
          FROM fba_file
         WHERE fba01 = g_fba.fba01
 
        CALL t106_g()
        CALL t106_b()
        #---判斷是否直接列印,確認,過帳---------
        LET g_t1 = s_get_doc_no(g_fba.fba01)  #No.FUN-550034
        SELECT fahconf,fahpost,fahapr INTO g_fahconf,g_fahpost,g_fahapr
          FROM fah_file
         WHERE fahslip = g_t1
 
        IF g_fahconf = 'Y' AND g_fahapr <> 'Y' THEN
           LET g_action_choice = "insert"
 
           CALL t106_y_chk()          #CALL 原確認的 check 段
           IF g_success = "Y" THEN
              CALL t106_y_upd()       #CALL 原確認的 update 段
           END IF
        END IF
        IF g_fahpost = 'Y' THEN
           CALL t106_s()
           CALL t106_s2()  #No:FUN-B60140
        END IF
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t106_u()
  DEFINE l_tic01      LIKE tic_file.tic01       #FUN-E80012 add
  DEFINE l_tic02      LIKE tic_file.tic02       #FUN-E80012 add
   IF s_shut(0) THEN RETURN END IF
 
    IF g_fba.fba01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_fba.* FROM fba_fiel WHERE fba01 = g_fba.fba01
    IF g_fba.fbaconf = 'Y' THEN
       CALL cl_err(' ','afa-096',0)
       RETURN
    END IF
    IF g_fba.fbaconf = 'X' THEN
       CALL cl_err(' ','9024',0)
       RETURN
    END IF
    IF g_fba.fbapost = 'Y' THEN
       CALL cl_err(' ','afa-101',0)
       RETURN
    END IF
    #-----No:FUN-B60140-----
    IF g_faa.faa31 = "Y" THEN
       IF g_fba.fbapost1= 'Y' THEN
          CALL cl_err(' ','afa-101',0)
          RETURN
       END IF
    END IF
    #-----No:FUN-B60140 END-----
    IF g_fba.fba08 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fba01_t = g_fba.fba01
    LET g_fba_o.* = g_fba.*
    BEGIN WORK
 
    OPEN t106_cl USING g_fba.fba01   #No:FUN-B60140
    IF STATUS THEN
       CALL cl_err("OPEN t106_cl:", STATUS, 1)
       CLOSE t106_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t106_cl INTO g_fba.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fba.fba01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t106_cl ROLLBACK WORK RETURN
    END IF
    CALL t106_show()
    WHILE TRUE
        LET g_fba01_t = g_fba.fba01
        LET g_fba.fbamodu=g_user
        LET g_fba.fbadate=g_today
        CALL t106_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fba.*=g_fba_t.*
            CALL t106_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        LET g_fba.fba08 = '0'   #FUN-580109
        IF g_fba.fba01 != g_fba_t.fba01 THEN
           UPDATE fbb_file SET fbb01=g_fba.fba01 WHERE fbb01=g_fba_t.fba01
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("upd","fbb_file",g_fba_t.fba01,"",SQLCA.sqlcode,"","upd fbb01",1)  #No.FUN-660136
              LET g_fba.*=g_fba_t.*
              CALL t106_show()
              CONTINUE WHILE
           END IF
        END IF
        UPDATE fba_file SET * = g_fba.*
         WHERE fba01 = g_fba.fba01
        IF SQLCA.SQLERRD[3] = 0 OR SQLCA.SQLCODE THEN
           CALL cl_err3("upd","fba_file",g_fba_t.fba01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
           CONTINUE WHILE
        END IF
        IF g_fba.fba02 != g_fba_t.fba02 THEN            # 更改單號
           UPDATE npp_file SET npp02=g_fba.fba02
            WHERE npp01=g_fba.fba01 AND npp00=8 AND npp011=1
              AND nppsys = 'FA'
           IF STATUS THEN 
              CALL cl_err3("upd","npp_file",g_fba_t.fba01,"",STATUS,"","upd npp02:",1)  #No.FUN-660136
           END IF
           #FUN-E80012---add---str---
           SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
           IF g_nmz.nmz70 = '3' THEN
              LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_fba.fba02,1)
              LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_fba.fba02,3)
              UPDATE tic_file SET tic01=l_tic01,
                                  tic02=l_tic02
              WHERE tic04=g_fba.fba01
              IF STATUS THEN
                 CALL cl_err3("upd","tic_file",g_fba.fba01,"",STATUS,"","upd tic01,tic02:",1)
              END IF
           END IF
           #FUN-E80012---add---end---
        END IF
        DISPLAY BY NAME g_fba.fba08
        IF g_fba.fbaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_fba.fba08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        CALL cl_set_field_pic(g_fba.fbaconf,g_chr2,g_fba.fbapost,"",g_chr,"")
        EXIT WHILE
    END WHILE
    CLOSE t106_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fba.fba01,'U')
END FUNCTION
 
FUNCTION t106_npp02(p_npptype)
  DEFINE p_npptype    LIKE npp_file.npptype     #No.FUN-680028
  DEFINE l_tic01      LIKE tic_file.tic01       #FUN-E80012 add
  DEFINE l_tic02      LIKE tic_file.tic02       #FUN-E80012 add
 
  IF g_fba.fba06 IS NULL OR g_fba.fba06=' ' THEN
     UPDATE npp_file SET npp02=g_fba.fba02
        WHERE npp01=g_fba.fba01 AND npp00=8 AND npp011=1
        AND nppsys = 'FA'
        AND npptype = p_npptype     #No.FUN-680028
     IF STATUS THEN 
        CALL cl_err3("upd","npp_file",g_fba.fba01,"",STATUS,"","upd npp02:",1)  #No.FUN-660136
     END IF
     #FUN-E80012---add---str---
     SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
     IF g_nmz.nmz70 = '3' THEN
        LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_fba.fba02,1)
        LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_fba.fba02,3)
        UPDATE tic_file SET tic01=l_tic01,
                            tic02=l_tic02
        WHERE tic04=g_fba.fba01 
        IF STATUS THEN 
           CALL cl_err3("upd","tic_file",g_fba.fba01,"",STATUS,"","upd tic01,tic02:",1)
        END IF
     END IF
     #FUN-E80012---add---end---
  END IF
END FUNCTION
 
#處理INPUT
FUNCTION t106_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1,   #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
         l_flag          LIKE type_file.chr1,   #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
         l_bdate,l_edate LIKE type_file.dat,    #No.FUN-680070 DATE
         l_n1            LIKE type_file.num5    #No.FUN-680070 SMALLINT
  DEFINE li_result   LIKE type_file.num5        #No.FUN-680070 SMALLINT
    CALL cl_set_head_visible("","YES")          #No.FUN-6B0029
 
    INPUT BY NAME g_fba.fbaoriu,g_fba.fbaorig,
        g_fba.fba01,g_fba.fba02,g_fba.fba09,g_fba.fba06,g_fba.fba07,#FUN-630045
        g_fba.fba062,g_fba.fba072,  #No:FUN-B60140
        g_fba.fbaconf,g_fba.fbapost,g_fba.fbapost1,g_fba.fbapost2,       #No.MOD-490163 #No:FUN-B60140
        g_fba.fbamksg,g_fba.fba08,   #FUN-580109
        g_fba.fbauser,g_fba.fbagrup,g_fba.fbamodu,g_fba.fbadate
        ,g_fba.fbaud01,g_fba.fbaud02,g_fba.fbaud03,g_fba.fbaud04,
        g_fba.fbaud05,g_fba.fbaud06,g_fba.fbaud07,g_fba.fbaud08,
        g_fba.fbaud09,g_fba.fbaud10,g_fba.fbaud11,g_fba.fbaud12,
        g_fba.fbaud13,g_fba.fbaud14,g_fba.fbaud15 
           WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t106_set_entry(p_cmd)
           CALL t106_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
         CALL cl_set_docno_format("fba01")
         CALL cl_set_docno_format("fba06")
         CALL cl_set_docno_format("fba062")  #No:FUN-B60140
 
        AFTER FIELD fba01
            IF NOT cl_null(g_fba.fba01) AND (cl_null(g_fba01_t) OR (g_fba.fba01!=g_fba01_t)) THEN   #MOD-740436
              CALL s_check_no("afa",g_fba.fba01,g_fba01_t,"8","fba_file","fba01","")
                   RETURNING li_result,g_fba.fba01
              DISPLAY BY NAME g_fba.fba01
              IF (NOT li_result) THEN
                 NEXT FIELD fba01
              END IF

               LET g_t1 = s_get_doc_no(g_fba.fba01)  #No.FUN-550034
               SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1

            END IF
           #start FUN-580109 帶出單據別設定的"簽核否"值,狀況碼預設為0
            SELECT fahapr,'0' INTO g_fba.fbamksg,g_fba.fba08
              FROM fah_file
             WHERE fahslip = g_t1
            IF cl_null(g_fba.fbamksg) THEN            #FUN-640243
                 LET g_fba.fbamksg = 'N'
            END IF
            DISPLAY BY NAME g_fba.fbamksg,g_fba.fba08
            LET g_fba_o.fba01 = g_fba.fba01
 
        AFTER FIELD fba02
            IF NOT cl_null(g_fba.fba02) THEN
               CALL s_azn01(g_faa.faa07,g_faa.faa08) RETURNING l_bdate,l_edate
               IF g_fba.fba02 < l_bdate
               THEN CALL cl_err(g_fba.fba02,'afa-130',0)
                    NEXT FIELD fba02
               END IF
            END IF
            IF NOT cl_null(g_fba.fba02) THEN
               IF g_fba.fba02 <= g_faa.faa09 THEN
                  CALL cl_err('','mfg9999',1)
                  NEXT FIELD fba02
               END IF
               CALL s_get_bookno(YEAR(g_fba.fba02))
                    RETURNING g_flag,g_bookno1,g_bookno2
               IF g_flag =  '1' THEN  #抓不到帳別
                  CALL cl_err(g_fba.fba02,'aoo-081',1)
                  NEXT FIELD fba02
               END IF
            END IF
        AFTER FIELD fba09
            IF NOT cl_null(g_fba.fba09) THEN
               CALL t106_fba09('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_fba.fba09 = g_fba_t.fba09
                  CALL cl_err(g_fba.fba09,g_errno,0)
                  DISPLAY BY NAME g_fba.fba09 #
                  NEXT FIELD fba09
               END IF
            ELSE
               DISPLAY '' TO FORMONLY.gen02
            END IF
        AFTER FIELD fbaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER INPUT  #97/05/22 modify
            LET g_fba.fbauser = s_get_data_owner("fba_file") #FUN-C10039
            LET g_fba.fbagrup = s_get_data_group("fba_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
         ON ACTION controlp
           CASE
              WHEN INFIELD(fba01)    #查詢單據性質
                 LET g_t1 = s_get_doc_no(g_fba.fba01)  #No.FUN-550034
                 CALL q_fah( FALSE, TRUE,g_t1,'8','AFA') RETURNING g_t1   #TQC-670008
                 LET g_fba.fba01 = g_t1      #No.FUN-550034
                 DISPLAY BY NAME g_fba.fba01
                 NEXT FIELD fba01
              WHEN INFIELD(fba09)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.default1 = g_fba.fba09
                   CALL cl_create_qry() RETURNING g_fba.fba09
                   DISPLAY BY NAME g_fba.fba09
                   NEXT FIELD fba09
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 

        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
FUNCTION t106_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fba01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t106_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fba01",FALSE)
    END IF
 
END FUNCTION
 
 
FUNCTION t106_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fba.* TO NULL                   #No.FUN-6A0001
    CALL cl_msg("")                              #FUN-640243
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t106_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_fba.* TO NULL
       RETURN
    END IF
    CALL cl_msg(" SEARCHING ! ")                 #FUN-640243
    OPEN t106_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fba.* TO NULL
    ELSE
        OPEN t106_count
        FETCH t106_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t106_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    CALL cl_msg("")                              #FUN-640243
END FUNCTION
 
FUNCTION t106_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t106_cs INTO g_fba.fba01
        WHEN 'P' FETCH PREVIOUS t106_cs INTO g_fba.fba01
        WHEN 'F' FETCH FIRST    t106_cs INTO g_fba.fba01
        WHEN 'L' FETCH LAST     t106_cs INTO g_fba.fba01
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
            FETCH ABSOLUTE g_jump t106_cs INTO g_fba.fba01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fba.fba01,SQLCA.sqlcode,0)
        INITIALIZE g_fba.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_fba.* FROM fba_file WHERE fba01 = g_fba.fba01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","fba_file",g_fba.fba01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
        INITIALIZE g_fba.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_fba.fbauser   #FUN-4C0059
    LET g_data_group = g_fba.fbagrup   #FUN-4C0059
    CALL s_get_bookno(YEAR(g_fba.fba02)) #TQC-740042
         RETURNING g_flag,g_bookno1,g_bookno2
    #FUN-AB0088---add---str---
    #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
    #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
    IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
    #FUN-AB0088---add---end--- 
    IF g_flag =  '1' THEN  #抓不到帳別
       CALL cl_err(g_fba.fba02,'aoo-081',1)
    END IF
    CALL t106_show()
END FUNCTION
 
FUNCTION t106_show()
    LET g_fba_t.* = g_fba.*                #保存單頭舊值
    DISPLAY BY NAME g_fba.fbaoriu,g_fba.fbaorig,
        g_fba.fba01,g_fba.fba02,g_fba.fba09,g_fba.fba06,g_fba.fba07,#FUN-630045
        g_fba.fba062,g_fba.fba072,g_fba.fbapost1,  #No:FUN-B60140
        g_fba.fbaconf,
        g_fba.fbapost,
        g_fba.fbapost2,
        g_fba.fbamksg,g_fba.fba08,   #FUN-580109 增加簽核,狀況碼
        g_fba.fbauser,g_fba.fbagrup,g_fba.fbamodu,g_fba.fbadate
        ,g_fba.fbaud01,g_fba.fbaud02,g_fba.fbaud03,g_fba.fbaud04,
        g_fba.fbaud05,g_fba.fbaud06,g_fba.fbaud07,g_fba.fbaud08,
        g_fba.fbaud09,g_fba.fbaud10,g_fba.fbaud11,g_fba.fbaud12,
        g_fba.fbaud13,g_fba.fbaud14,g_fba.fbaud15 
    IF g_fba.fbaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_fba.fba08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_fba.fbaconf,g_chr2,g_fba.fbapost,"",g_chr,"")
    LET g_t1 = s_get_doc_no(g_fba.fba01)  #No.FUN-550034
    CALL t106_fba09('d')                      #FUN-630045  
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
    CALL t106_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t106_r()
 DEFINE l_chr,l_sure LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fba.fba01 IS NULL THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    SELECT * INTO g_fba.* FROM fba_fiel WHERE fba01 = g_fba.fba01
    IF g_fba.fbaconf = 'Y' THEN
       CALL cl_err('','afa-096',0) RETURN
    END IF
    IF g_fba.fbaconf = 'X' THEN
       CALL cl_err(' ','9024',0)
       RETURN
    END IF
    IF g_fba.fbapost = 'Y' THEN
       CALL cl_err(' ','afa-101',0) RETURN
    END IF
    #-----No:FUN-B60140-----
    IF g_faa.faa31 = "Y" THEN
       IF g_fba.fbapost1= 'Y' THEN
          CALL cl_err(' ','afa-101',0) RETURN
       END IF
    END IF
    #-----No:FUN-B60140 END-----
    IF g_fba.fba08 matches '[Ss1]' THEN
       CALL cl_err('','mfg3557',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN t106_cl USING g_fba.fba01  #No:FUN-B60140
    IF STATUS THEN
       CALL cl_err("OPEN t106_cl:", STATUS, 1)
       CLOSE t106_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t106_cl INTO g_fba.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fba.fba01,SQLCA.sqlcode,0)
       CLOSE t106_cl ROLLBACK WORK RETURN
    END IF
    CALL t106_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fba01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fba.fba01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete fba,fbb!"
        DELETE FROM fba_file WHERE fba01 = g_fba.fba01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","fba_file",g_fba.fba01,"",SQLCA.sqlcode,"","No fba deleted",1)  #No.FUN-660136
        ELSE
           DELETE FROM fbb_file WHERE fbb01 = g_fba.fba01
           DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 8
                                  AND npp01 = g_fba.fba01
                                  AND npp011= 1
           DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 8
                                  AND npq01 = g_fba.fba01
                                  AND npq011= 1
           #FUN-B40056--add--str--
           DELETE FROM tic_file WHERE tic04 = g_fba.fba01
           #FUN-B40056--add--end--
           CLEAR FORM
           CALL g_fbb.clear()
           CALL g_e.clear()
           CALL g_fbb.clear()
           INITIALIZE g_fba.* LIKE fba_file.*
           OPEN t106_count
           #FUN-B50062-add-start--
           IF STATUS THEN
              CLOSE t106_cl
              CLOSE t106_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50062-add-end-- 
           FETCH t106_count INTO g_row_count
           #FUN-B50062-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE t106_cl
              CLOSE t106_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50062-add-end-- 
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN t106_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL t106_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL t106_fetch('/')
           END IF
 
        END IF
    END IF
    CLOSE t106_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fba.fba01,'D')
END FUNCTION
 
FUNCTION t106_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
       l_row,l_col     LIKE type_file.num5,  		   #分段輸入之行,列數       #No.FUN-680070 SMALLINT
       l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
       l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
       l_faj06         LIKE faj_file.faj06,
       l_faj100        LIKE faj_file.faj100,
       l_fbb10         LIKE fbb_file.fbb10,   #No.FUN-4C0008
       l_fbb19         LIKE fbb_file.fbb19,   #No.FUN-4C0008
       l_fab23         LIKE fab_file.fab23,    #殘值率 NO.A032
       l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
       l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
DEFINE l_fba08         LIKE fba_file.fba08    #FUN-580109
DEFINE l_cnt1          LIKE type_file.num5    #FUN-AB0088
DEFINE l_faj332   LIKE faj_file.faj332   #No:FUN-BB0122
DEFINE l_faj3312  LIKE faj_file.faj3312  #No:FUN-BB0122
DEFINE l_faj302   LIKE faj_file.faj302   #No:FUN-BB0122
DEFINE l_faj312   LIKE faj_file.faj312   #No:FUN-BB0122 
    LET g_action_choice = ""
    LET l_fba08 = g_fba.fba08   #FUN-580109
    IF g_fba.fba01 IS NULL THEN RETURN END IF
    IF g_fba.fbaconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fba.fbapost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
    #-----No:FUN-B60140-----
    IF g_faa.faa31 = "Y" THEN
       IF g_fba.fbapost1= 'Y' THEN
          CALL cl_err('','afa-101',0)
          RETURN
       END IF
    END IF
    #-----No:FUN-B60140 END-----
    IF g_fba.fbaconf = 'X' THEN
       CALL cl_err(' ','9024',0)
       RETURN
    END IF
    IF g_fba.fba08 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT fbb02,fbb03,fbb031,'',fbb04,fbb08,fbb05,fbb09,fbb06, ",
                       " fbb10,fbb12 ",
                       " FROM fbb_file  ",
                       " WHERE fbb01 = ? " ,
                       " AND fbb02 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t106_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
      LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_fbb.clear() END IF
 
 
      INPUT ARRAY g_fbb WITHOUT DEFAULTS FROM s_fbb.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
	    BEGIN WORK
 
            OPEN t106_cl USING g_fba.fba01
            IF STATUS THEN
               CALL cl_err("OPEN t106_cl:", STATUS, 1)
               CLOSE t106_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t106_cl INTO g_fba.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fba.fba01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t106_cl ROLLBACK WORK RETURN
            END IF
 
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_fbb_t.* = g_fbb[l_ac].*  #BACKUP
                LET l_flag = 'Y'
 
                OPEN t106_bcl USING g_fba.fba01,g_fbb_t.fbb02
                IF STATUS THEN
                   CALL cl_err("OPEN t106_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                   CLOSE t106_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t106_bcl INTO g_fbb[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock fbb',SQLCA.sqlcode,0)
                       LET l_lock_sw = "Y"
                   ELSE
                     SELECT faj06 INTO g_fbb[l_ac].faj06
                       FROM faj_file
                      WHERE faj02=g_fbb[l_ac].fbb03
                     LET g_fbb_t.faj06 =g_fbb[l_ac].faj06
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            ELSE
                CALL cl_show_fld_cont()     #FUN-550037(smin)
                LET l_flag = 'N'
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              INITIALIZE g_fbb[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_fbb[l_ac].* TO s_fbb.*
              CALL g_fbb.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
            END IF
            IF g_fbb[l_ac].fbb03 IS NOT NULL AND g_fbb[l_ac].fbb03 != ' ' THEN
               CALL t106_fbb031('d')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fbb[l_ac].fbb031,g_errno,0)
                    NEXT FIELD fbb02
                 END IF
            END IF
            IF cl_null(g_fbb[l_ac].fbb12) THEN
               LET g_fbb[l_ac].fbb12 = ' '
            END IF
          IF cl_null(g_fbb[l_ac].fbb031) THEN
             LET g_fbb[l_ac].fbb031 = ' '
          END IF
          #-----No:FUN-BB0122-----
          SELECT faj332,faj3312,faj302,faj312
            INTO l_faj332,l_faj3312,l_faj302,l_faj312
            FROM faj_file
           WHERE faj02  = g_fbb[l_ac].fbb03
             AND faj022 = g_fbb[l_ac].fbb031
          IF cl_null(l_faj332) THEN LET l_faj332=0 END IF
          IF cl_null(l_faj3312) THEN LET l_faj3312=0 END IF
          IF cl_null(l_faj302) THEN LET l_faj302=0 END IF
          IF cl_null(l_faj312) THEN LET l_faj312=0 END IF
          #-----No:FUN-BB0122 End-----
        #CHI-C60010---str---
         CALL cl_digcut(l_faj332,g_azi04_1) RETURNING l_faj332
         CALL cl_digcut(l_faj3312,g_azi04_1) RETURNING l_faj3312
         CALL cl_digcut(l_faj312,g_azi04_1) RETURNING l_faj312
        #CHI-C60010---end---
             INSERT INTO fbb_file(fbb01,fbb02,fbb03,fbb031,fbb04,fbb05, #No.MOD-470041
                                  fbb06,fbb07,fbb08,fbb09,fbb10,  #No.MOD-470565
                                  fbb11,fbb12,fbb13,fbb14,fbb15,  #No.MOD-470565
                                  fbb16,fbb17,fbb18,fbb19,fbb20  #No.MOD-470565
                                  ,fbbud01,fbbud02,fbbud03,fbbud04,fbbud05,
                                  fbbud06,fbbud07,fbbud08,fbbud09,fbbud10,
                                  fbbud11,fbbud12,fbbud13,fbbud14,fbbud15,
                                  fbb042,fbb052,fbb062,fbb082,fbb092,fbb102,    #FUN-AB0088
                                  fbblegal) #FUN-980003 add
              VALUES(g_fba.fba01,g_fbb[l_ac].fbb02,g_fbb[l_ac].fbb03,
                   g_fbb[l_ac].fbb031,g_fbb[l_ac].fbb04,g_fbb[l_ac].fbb05,
                   g_fbb[l_ac].fbb06,0,g_fbb[l_ac].fbb08,   #No.MOD-470565
                   g_fbb[l_ac].fbb09,g_fbb[l_ac].fbb10,0,   #No.MOD-470565
                   g_fbb[l_ac].fbb12,g_e[l_ac].fbb13,g_e[l_ac].fbb14,
                   g_e[l_ac].fbb15,0,g_e[l_ac].fbb17,       #No.MOD-470565
                   g_e[l_ac].fbb18,g_e[l_ac].fbb19,0       #No.MOD-470565
                   ,g_fbb[l_ac].fbbud01,g_fbb[l_ac].fbbud02,g_fbb[l_ac].fbbud03,
                   g_fbb[l_ac].fbbud04,g_fbb[l_ac].fbbud05,g_fbb[l_ac].fbbud06,
                   g_fbb[l_ac].fbbud07,g_fbb[l_ac].fbbud08,g_fbb[l_ac].fbbud09,
                   g_fbb[l_ac].fbbud10,g_fbb[l_ac].fbbud11,g_fbb[l_ac].fbbud12,
                   g_fbb[l_ac].fbbud13,g_fbb[l_ac].fbbud14,g_fbb[l_ac].fbbud15,
                   #0,0,0,0,0,0,   #FUN-AB0088 #No:FUN-BB0122 mark
                   (l_faj332+l_faj3312),l_faj302,l_faj312,0,l_faj302,l_faj312, #No:FUN-BB0122 add
                   g_legal) #FUN-980003 add
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0  THEN
                 CALL cl_err3("ins","fbb_file",g_fba.fba01,g_fbb[l_ac].fbb02,SQLCA.sqlcode,"","ins fbb",1)  #No.FUN-660136
                 CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET l_fba08 = '0'   #FUN-580109
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd = 'a'
            INITIALIZE g_fbb[l_ac].* TO NULL      #900423
            LET g_fbb_t.* = g_fbb[l_ac].*             #新輸入資料
            LET g_fbb[l_ac].fbb08 = 0
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fbb02
 
        BEFORE FIELD fbb02                            #defbalt 序號
            IF p_cmd = 'a' OR p_cmd = 'u' THEN
               IF g_fbb[l_ac].fbb02 IS NULL OR g_fbb[l_ac].fbb02 = 0
               THEN SELECT max(fbb02)+1 INTO g_fbb[l_ac].fbb02
                      FROM fbb_file WHERE fbb01 = g_fba.fba01
                     IF cl_null(g_fbb[l_ac].fbb02) THEN
                        LET g_fbb[l_ac].fbb02 = 1
                     END IF
               END IF
            END IF
 
        AFTER FIELD fbb02                        #check 序號是否重複
            IF NOT cl_null(g_fbb[l_ac].fbb02) THEN
               IF g_fbb[l_ac].fbb02 != g_fbb_t.fbb02 OR
                  g_fbb_t.fbb02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM fbb_file
                    WHERE fbb01 = g_fba.fba01
                      AND fbb02 = g_fbb[l_ac].fbb02
                   IF l_n > 0 THEN
                       LET g_fbb[l_ac].fbb02 = g_fbb_t.fbb02
                       CALL cl_err('',-239,0)
                       NEXT FIELD fbb02
                   END IF
               END IF
            END IF

       #FUN-BC0004--mark--str
       ##TQC-AB0257 modify ---begin----------------------------
       #AFTER FIELD fbb03
       #    IF g_fbb[l_ac].fbb03 != g_fbb_t.fbb03 OR
       #       g_fbb_t.fbb03 IS NULL THEN
       #        LET l_n = 0
       #        SELECT COUNT(*) INTO l_n FROM faj_file
       #         WHERE fajconf='Y'
       #           AND faj02 = g_fbb[l_ac].fbb03
       #        IF l_n = 0 THEN
       #            LET g_fbb[l_ac].fbb03 = g_fbb_t.fbb03
       #            CALL cl_err('','afa-911',0)
       #            NEXT FIELD fbb03
       #        END IF
       #    END IF
       ##TQC-AB0257 modify ----end----------------------------- 
       #FUN-BC0004--mark--end

        #FUN-BC0004--add--str
        AFTER FIELD fbb03
           IF g_fbb[l_ac].fbb031 IS NULL THEN
              LET g_fbb[l_ac].fbb031 = ' '
           END IF
           IF NOT cl_null(g_fbb[l_ac].fbb03) AND  g_fbb[l_ac].fbb031 IS NOT NULL THEN 
              SELECT COUNT(*) INTO l_n FROM faj_file
               WHERE faj02 = g_fbb[l_ac].fbb03
              IF l_n > 0 THEN 
                 CALL t106_fbb031('a') 
                 IF NOT cl_null(g_errno) THEN 
                    CALL cl_err(g_fbb[l_ac].fbb031,g_errno,0)
                    NEXT FIELD fbb031
                 ELSE
                    SELECT COUNT(*) INTO l_cnt FROM fan_file
                     WHERE fan01 = g_fbb[l_ac].fbb03
                       AND fan02 = g_fbb[l_ac].fbb031
                       AND ((fan03 = YEAR(g_fba.fba02) AND fan04 >= MONTH(g_fba.fba02))
                        OR fan03 > YEAR(g_fba.fba02))
                       AND fan041 = '1'   #MOD-BC0025 add
                    LET l_cnt1 = 0
                    IF g_faa.faa31 = 'Y' THEN
                        SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
                         WHERE fbn01 = g_fbb[l_ac].fbb03
                           AND fbn02 = g_fbb[l_ac].fbb031
                           AND ((fbn03 = YEAR(g_fba.fba02) AND fbn04 >= MONTH(g_fba.fba02))
                            OR fbn03 > YEAR(g_fba.fba02))
                           AND fbn041 = '1'   #MOD-BC0025 add
                    END IF
                    LET l_cnt = l_cnt + l_cnt1
                    IF l_cnt > 0 THEN
                       CALL cl_err(g_fbb[l_ac].fbb03,'afa-092',0)
                       NEXT FIELD fbb03
                    END IF
                 END IF
              ELSE
                 CALL cl_err(g_fbb[l_ac].fbb03,'afa-093',1)
                 LET g_fbb[l_ac].fbb03 = g_fbb_t.fbb03
                 NEXT FIELD fbb03
              END IF
           END IF 

        #FUN-BC0004--add--end
        AFTER FIELD fbb031
           IF g_fbb[l_ac].fbb031 IS NULL THEN
              LET g_fbb[l_ac].fbb031 = ' '
           END IF
           SELECT COUNT(*) INTO g_cnt FROM fca_file
            WHERE fca03  = g_fbb[l_ac].fbb03
              AND fca031 = g_fbb[l_ac].fbb031
              AND fca15  = 'N'
            IF g_cnt > 0 THEN
               CALL cl_err(g_fbb[l_ac].fbb03,'afa-097',0)
               NEXT FIELD fbb03
            END IF
           SELECT faj100 INTO l_faj100 FROM faj_file
            WHERE faj02  = g_fbb[l_ac].fbb03
              AND faj022 = g_fbb[l_ac].fbb031
       #   IF l_faj100 >= g_fba.fba02 THEN    #TQC-A40043
           IF l_faj100 > g_fba.fba02 THEN     #TQC-A40043
              CALL cl_err(g_fba.fba02,'afa-113',0)
              NEXT FIELD fbb03
           END IF
           SELECT COUNT(*) INTO l_cnt FROM fan_file
            WHERE fan01 = g_fbb[l_ac].fbb03
              AND fan02 = g_fbb[l_ac].fbb031
              AND ((fan03 = YEAR(g_fba.fba02) AND fan04 >= MONTH(g_fba.fba02))
               OR fan03 > YEAR(g_fba.fba02))
              AND fan041 = '1'   #MOD-BC0025 add
           #FUN-AB0088---add---str---
           LET l_cnt1 = 0
           IF g_faa.faa31 = 'Y' THEN
               SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
                WHERE fbn01 = g_fbb[l_ac].fbb03
                  AND fbn02 = g_fbb[l_ac].fbb031
                  AND ((fbn03 = YEAR(g_fba.fba02) AND fbn04 >= MONTH(g_fba.fba02))
                   OR fbn03 > YEAR(g_fba.fba02))
                  AND fbn041 = '1'   #MOD-BC0025 add
           END IF
           LET l_cnt = l_cnt + l_cnt1
           #FUN-AB0088---add---end---
           IF l_cnt > 0 THEN
              CALL cl_err(g_fbb[l_ac].fbb03,'afa-092',0)
              NEXT FIELD fbb03
           END IF
           CALL t106_fbb031('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_fbb[l_ac].fbb031,g_errno,0)
               LET g_fbb[l_ac].fbb03 = g_fbb_t.fbb03            #MOD-950166
               LET g_fbb[l_ac].fbb031 = g_fbb_t.fbb031          #MOD-950166               
               NEXT FIELD fbb03
            END IF
          # LET g_fbb_t.fbb03  = g_fbb[l_ac].fbb03 #FUN-BC0004--mark
          # LET g_fbb_t.fbb031 = g_fbb[l_ac].fbb031#FUN-BC0004--mark
 
        AFTER FIELD fbb08
           IF cl_null(g_e[l_ac].fbb17) OR g_e[l_ac].fbb17 = 0
           THEN LET g_e[l_ac].fbb17 = g_fbb[l_ac].fbb08
           DISPLAY BY NAME g_e[l_ac].fbb17
           END IF
           IF g_fbb[l_ac].fbb08<0 THEN
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbb08
           END IF
         
        AFTER FIELD fbb10
           IF g_fbb[l_ac].fbb10<0 THEN
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbb10
           END IF
           LET g_fbb[l_ac].fbb10 = cl_digcut(g_fbb[l_ac].fbb10,g_azi04)   #MOD-B30291
           DISPLAY BY NAME g_fbb[l_ac].fbb10                              #MOD-B30291
 
        AFTER FIELD fbb09
           IF cl_null(g_e[l_ac].fbb18) OR g_e[l_ac].fbb18 = 0
           THEN LET g_e[l_ac].fbb18 = g_fbb[l_ac].fbb09
           DISPLAY BY NAME g_e[l_ac].fbb18
           END IF
           IF g_aza.aza26 = '2' THEN
              SELECT DISTINCT(fab23) INTO l_fab23 FROM fab_file,faj_file
              WHERE fab01  = faj04
                AND faj02  = g_fbb[l_ac].fbb03
                AND faj022 = g_fbb[l_ac].fbb031
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","fab_file,faj_file",g_fbb[l_ac].fbb03,g_fbb[l_ac].fbb031,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                 LET g_success = 'N' RETURN
              END IF
              IF g_faj28 MATCHES '[05]' THEN
                 LET l_fbb10 = 0
                 LET l_fbb19 = 0
              ELSE
                 LET l_fbb10 = (g_fbb[l_ac].fbb04 + g_fbb[l_ac].fbb08)*
                               l_fab23/100
                 #--->稅簽預留殘值
                 LET l_fbb19 = (g_e[l_ac].fbb13 + g_e[l_ac].fbb17) *
                               l_fab23/100
                 LET g_e[l_ac].fbb19 = l_fbb19
              END IF
              LET g_fbb[l_ac].fbb10 = l_fbb10
              LET g_fbb[l_ac].fbb10 = cl_digcut(g_fbb[l_ac].fbb10,g_azi04)   #MOD-B30291
              DISPLAY BY NAME g_fbb[l_ac].fbb10
           ELSE
              CASE g_faj28
                WHEN '1' LET l_fbb10 = (g_fbb[l_ac].fbb04 + g_fbb[l_ac].fbb08)
                                      /(g_fbb[l_ac].fbb09 + 12)*12
                         LET g_fbb[l_ac].fbb10 = l_fbb10
                         LET g_fbb[l_ac].fbb10 = cl_digcut(g_fbb[l_ac].fbb10,g_azi04)   #MOD-B30291
                         #--->稅簽預留殘值
                         LET l_fbb19 = (g_e[l_ac].fbb13 + g_e[l_ac].fbb17)
                                      /(g_e[l_ac].fbb18 + 12)*12
                         LET g_e[l_ac].fbb19 = l_fbb19
                         LET g_e[l_ac].fbb19 = cl_digcut(g_e[l_ac].fbb19,g_azi04)   #MOD-B30291
                         DISPLAY BY NAME g_fbb[l_ac].fbb10
                OTHERWISE EXIT CASE
              END CASE
           END IF
           IF g_fbb[l_ac].fbb09<0 THEN
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbb09
           END IF
 
        BEFORE FIELD fbb12
            IF p_cmd = 'a' AND l_ac > 1 THEN
               LET g_fbb[l_ac].fbb12 = g_fbb[l_ac-1].fbb12
               DISPLAY BY NAME g_fbb[l_ac].fbb12
            END IF
 
        AFTER FIELD fbb12
            IF NOT cl_null(g_fbb[l_ac].fbb12) THEN
               CALL t106_fbb12('a')
                 IF NOT cl_null(g_errno) THEN
                    LET g_fbb[l_ac].fbb12 = g_fbb_t.fbb12
                    DISPLAY BY NAME g_fbb[l_ac].fbb12
                    CALL cl_err(g_fbb[l_ac].fbb12,g_errno,0)
                    NEXT FIELD fbb12
                 END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_fbb_t.fbb02 > 0 AND g_fbb_t.fbb02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM fbb_file
                 WHERE fbb01 = g_fba.fba01
                   AND fbb02 = g_fbb_t.fbb02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","fbb_file",g_fba.fba01,g_fbb_t.fbb02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET l_fba08 = '0'   #FUN-580109
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fbb[l_ac].* = g_fbb_t.*
               CLOSE t106_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fbb[l_ac].fbb02,-263,1)
               LET g_fbb[l_ac].* = g_fbb_t.*
            ELSE
               IF g_fbb[l_ac].fbb03 IS NOT NULL AND g_fbb[l_ac].fbb03 != ' ' THEN
                  CALL t106_fbb031('d')
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_fbb[l_ac].fbb031,g_errno,0)
                       NEXT FIELD fbb02
                    END IF
               END IF
               IF cl_null(g_fbb[l_ac].fbb12) THEN
                  LET g_fbb[l_ac].fbb12 = ' '
               END IF
               UPDATE fbb_file SET
                  fbb01=g_fba.fba01,       fbb02=g_fbb[l_ac].fbb02,
                  fbb03=g_fbb[l_ac].fbb03, fbb031=g_fbb[l_ac].fbb031,
                  fbb04=g_fbb[l_ac].fbb04, fbb05=g_fbb[l_ac].fbb05,
                  fbb06=g_fbb[l_ac].fbb06, fbb08=g_fbb[l_ac].fbb08,
                  fbb09=g_fbb[l_ac].fbb09, fbb10=g_fbb[l_ac].fbb10,
                  fbb12=g_fbb[l_ac].fbb12, fbb13=g_e[l_ac].fbb13,
                  fbb14=g_e[l_ac].fbb14,   fbb15=g_e[l_ac].fbb15,
                  fbb17=g_e[l_ac].fbb17,   fbb18=g_e[l_ac].fbb18,
                  fbb19=g_e[l_ac].fbb19
                  ,fbbud01 = g_fbb[l_ac].fbbud01,
                  fbbud02 = g_fbb[l_ac].fbbud02,
                  fbbud03 = g_fbb[l_ac].fbbud03,
                  fbbud04 = g_fbb[l_ac].fbbud04,
                  fbbud05 = g_fbb[l_ac].fbbud05,
                  fbbud06 = g_fbb[l_ac].fbbud06,
                  fbbud07 = g_fbb[l_ac].fbbud07,
                  fbbud08 = g_fbb[l_ac].fbbud08,
                  fbbud09 = g_fbb[l_ac].fbbud09,
                  fbbud10 = g_fbb[l_ac].fbbud10,
                  fbbud11 = g_fbb[l_ac].fbbud11,
                  fbbud12 = g_fbb[l_ac].fbbud12,
                  fbbud13 = g_fbb[l_ac].fbbud13,
                  fbbud14 = g_fbb[l_ac].fbbud14,
                  fbbud15 = g_fbb[l_ac].fbbud15
               WHERE fbb01=g_fba.fba01 AND fbb02=g_fbb_t.fbb02
 
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                  CALL cl_err3("upd","fbb_file",g_fba.fba01,g_fbb_t.fbb02,SQLCA.sqlcode,"","upd fbb",1)  #No.FUN-660136
                  LET g_fbb[l_ac].* = g_fbb_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  LET l_fba08 = '0'   #FUN-580109
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac     #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_fbb[l_ac].* = g_fbb_t.*
            #FUN-D30032--add--str--
               ELSE
                  CALL g_fbb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30032--add--end--
               END IF
               CLOSE t106_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add
            CLOSE t106_bcl
            COMMIT WORK
            CALL g_fbb.deleteElement(g_rec_b+1)
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fbb02) AND l_ac > 1 THEN
                LET g_fbb[l_ac].* = g_fbb[l_ac-1].*
                LET g_fbb[l_ac].fbb02 = NULL
                NEXT FIELD fbb02
            END IF
 
        ON ACTION tax_data  #稅簽資料
            CASE WHEN INFIELD(fbb08)  #調整成本
                      CALL t106_e(p_cmd)
                 WHEN INFIELD(fbb09)  #異動後未用年限
                      CALL t106_e(p_cmd)
                 WHEN INFIELD(fbb10)  #異動後預估殘值
                      CALL t106_e(p_cmd)
            END CASE
 
        ON ACTION controlp
           CASE
            WHEN INFIELD(fbb03)  #財產編號,財產附號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.default1 = g_fbb[l_ac].fbb03
                 LET g_qryparam.default2 = g_fbb[l_ac].fbb031
                 CALL cl_create_qry() RETURNING
                         g_fbb[l_ac].fbb03,g_fbb[l_ac].fbb031
                  DISPLAY g_fbb[l_ac].fbb03 TO fbb03                 #No.MOD-490344
                  DISPLAY g_fbb[l_ac].fbb031 TO fbb031               #No.MOD-490344
                 CALL t106_fbb031('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(' ',g_errno,0)
                    NEXT FIELD fbb03
                 END IF
                 NEXT FIELD fbb03
            WHEN INFIELD(fbb12)  #異動原因
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fag"
                 LET g_qryparam.arg1 = "8"
                 LET g_qryparam.default1 = g_fbb[l_ac].fbb12
                 CALL cl_create_qry() RETURNING g_fbb[l_ac].fbb12
                  DISPLAY g_fbb[l_ac].fbb12 TO fbb12                 #No.MOD-490344
                 NEXT FIELD fbb12
            OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END INPUT
 
   LET g_fba.fbamodu = g_user
   LET g_fba.fbadate = g_today
   UPDATE fba_file SET fbamodu = g_fba.fbamodu,fbadate = g_fba.fbadate
    WHERE fba01 = g_fba.fba01
   DISPLAY BY NAME g_fba.fbamodu,g_fba.fbadate
 
   UPDATE fba_file SET fba08=l_fba08 WHERE fba01 = g_fba.fba01
   LET g_fba.fba08 = l_fba08
   DISPLAY BY NAME g_fba.fba08
   IF g_fba.fbaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fba.fba08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fba.fbaconf,g_chr2,g_fba.fbapost,"",g_chr,"")
 
   CLOSE t106_bcl
   COMMIT WORK
   CALL t106_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t106_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_fba.fba01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fba_file ",
                  "  WHERE fba01 LIKE '",l_slip,"%' ",
                  "    AND fba01 > '",g_fba.fba01,"'"
      PREPARE t106_pb1 FROM l_sql 
      EXECUTE t106_pb1 INTO l_cnt 
      
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
        #CALL t106_x()            #FUN-D20035
         CALL t106_x(1)           #FUN-D20035
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 8
                                AND npp01 = g_fba.fba01
                                AND npp011= 1
         DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 8
                                AND npq01 = g_fba.fba01
                                AND npq011= 1
         DELETE FROM tic_file WHERE tic04 = g_fba.fba01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM fba_file WHERE fba01 = g_fba.fba01
         INITIALIZE g_fba.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t106_fbb031(p_cmd)
DEFINE   p_cmd       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_faj06     LIKE faj_file.faj06,
         l_faj33     LIKE faj_file.faj33,
         l_faj331    LIKE faj_file.faj331,        #MOD-970231 add
         l_faj30     LIKE faj_file.faj30,
         l_faj31     LIKE faj_file.faj31,
         l_faj35     LIKE faj_file.faj35,
         l_faj43     LIKE faj_file.faj43,
         l_faj68     LIKE faj_file.faj68,
         l_faj65     LIKE faj_file.faj65,
         l_faj66     LIKE faj_file.faj66,
         l_faj72     LIKE faj_file.faj72,
         l_n         LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
   LET g_errno = ' '
   IF l_flag = 'N' OR (l_flag = 'Y' AND   #檢查是否重複
                         (g_fbb[l_ac].fbb03 != g_fbb_t.fbb03 OR
                          g_fbb[l_ac].fbb031 != g_fbb_t.fbb031)) THEN
      SELECT count(*) INTO l_n FROM fbb_file
       WHERE fbb01  = g_fba.fba01
         AND fbb03  = g_fbb[l_ac].fbb03
         AND fbb031 = g_fbb[l_ac].fbb031
        IF l_n > 0 THEN
           LET g_errno = 'afa-105'
           RETURN
        END IF
      #CHI-B80007 -- begin --
      SELECT count(*) INTO l_n FROM fbb_file,fba_file
        WHERE fbb01 = fba01
         AND fbb03  = g_fbb[l_ac].fbb03
         AND fbb031 = g_fbb[l_ac].fbb031
         AND fba02 <= g_fba.fba02
         AND fbapost = 'N'
         AND fba01 != g_fba.fba01
         AND fbaconf <> 'X'
      IF l_n  > 0 THEN
         LET g_errno = 'afa-309'
         RETURN
      END IF
      #CHI-B80007 -- end --
      SELECT faj06,faj28,faj33,faj331,faj30,faj31,faj35,faj43,  #MOD-970231 add faj331
             faj68,faj65,faj66,faj72
        INTO l_faj06,g_faj28,l_faj33,l_faj331,l_faj30,l_faj31,l_faj35,l_faj43,   #MOD-970231 add l_faj331
             l_faj68,l_faj65,l_faj66,l_faj72
        FROM faj_file
       WHERE faj02  = g_fbb[l_ac].fbb03
         AND faj022 = g_fbb[l_ac].fbb031
         AND faj43  NOT IN ('0','5','6','X')
         AND fajconf = 'Y'
         #MOD-BC0127---being add         
         AND faj02 NOT IN (SELECT fca03 FROM fca_file
                           WHERE fca03  = g_fbb[l_ac].fbb03 AND fca031 = g_fbb[l_ac].fbb031
                           AND fca15  = 'N')
         AND faj100 < g_fba.fba02
         #MOD-BC0127---being end
     CASE
        #WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-093'    #MOD-C70265 mark
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-134'    #MOD-C70265 add
         OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     IF l_faj43 = '7' THEN   #折畢再提
        LET l_faj31 = l_faj35
        LET l_faj66 = l_faj72
     END IF
     IF cl_null(g_errno) AND (p_cmd = 'a' OR p_cmd = 'u') THEN
        LET g_fbb[l_ac].fbb04 = l_faj33+l_faj331  #MOD-970231 
        LET g_fbb[l_ac].fbb05 = l_faj30
        LET g_fbb[l_ac].fbb06 = l_faj31
        LET g_fbb[l_ac].faj06 = l_faj06
        LET g_fbb[l_ac].fbb08 = 0
        LET g_fbb[l_ac].fbb09 = g_fbb[l_ac].fbb05
        LET g_fbb[l_ac].fbb10 = g_fbb[l_ac].fbb06
        LET g_e[l_ac].fbb13   = l_faj68
        LET g_e[l_ac].fbb14   = l_faj65
        LET g_e[l_ac].fbb15   = l_faj66
    END IF
  END IF
END FUNCTION
 
FUNCTION t106_fbb12(p_cmd)
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_fag01    LIKE fag_file.fag01,
      l_fagacti  LIKE fag_file.fagacti
 
    LET g_errno = ' '
    SELECT fag01,fagacti INTO l_fag01,l_fagacti
      FROM fag_file
     WHERE fag01 = g_fbb[l_ac].fbb12
       AND fag02 = '8'
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-099'
                                LET l_fag01 = NULL
                                LET l_fagacti = NULL
       WHEN l_fagacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t106_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON fbb02,fbb03,fbb031,fbb04,fbb05,fbb06,fbb08,
                       fbb09,fbb10,fbb12,faj06
                       ,fbbud01,fbbud02,fbbud03,fbbud04,fbbud05,
                       fbbud06,fbbud07,fbbud08,fbbud09,fbbud10,
                       fbbud11,fbbud12,fbbud13,fbbud14,fbbud15
         FROM s_fbb[1].fbb02, s_fbb[1].fbb03,s_fbb[1].fbb031,s_fbb[1].fbb04,
              s_fbb[1].fbb05,s_fbb[1].fbb06,s_fbb[1].fbb08,
              s_fbb[1].fbb09,s_fbb[1].fbb10,s_fbb[1].fbb12,
              s_fbb[1].faj06
              ,s_fbb[1].fbbud01,s_fbb[1].fbbud02,s_fbb[1].fbbud03,
              s_fbb[1].fbbud04,s_fbb[1].fbbud05,s_fbb[1].fbbud06,
              s_fbb[1].fbbud07,s_fbb[1].fbbud08,s_fbb[1].fbbud09,
              s_fbb[1].fbbud10,s_fbb[1].fbbud11,s_fbb[1].fbbud12,
              s_fbb[1].fbbud13,s_fbb[1].fbbud14,s_fbb[1].fbbud15
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    CALL t106_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t106_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    LET g_sql =
        "SELECT fbb02,fbb03,fbb031,faj06,fbb04,fbb08, ",
        " fbb05,fbb09,fbb06,fbb10,fbb12 ",
        "       ,fbbud01,fbbud02,fbbud03,fbbud04,fbbud05,",
        "       fbbud06,fbbud07,fbbud08,fbbud09,fbbud10,",
        "       fbbud11,fbbud12,fbbud13,fbbud14,fbbud15", 
        "  FROM fbb_file, faj_file ",
        " WHERE fbb01  ='",g_fba.fba01,"'",  #單頭
        "   AND fbb03  = faj02",
        "   AND fbb031 = faj022",
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE t106_pb FROM g_sql
    DECLARE fbb_curs                       #SCROLL CURSOR
        CURSOR FOR t106_pb
 
    CALL g_fbb.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fbb_curs INTO g_fbb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,0) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_fbb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t106_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fbb  TO s_fbb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
       #FUN-C30140--mark---str---
       ##IF g_aza.aza63 = 'Y' THEN    #FUN-AB0088 mark
       # IF g_faa.faa31 = 'Y' THEN    #FUN-AB0088 
       #    CALL cl_set_act_visible("entry_sheet2",TRUE)
       #    CALL cl_set_act_visible("gen_entry2,post2,undo_post2",TRUE)  #No:FUN-B60140
       #    CALL cl_set_act_visible("carry_voucher2,undo_carry_voucher2",TRUE)  #No:FUN-B60140
       # ELSE
       #    CALL cl_set_act_visible("entry_sheet2",FALSE)
       #    CALL cl_set_act_visible("gen_entry2,post2,undo_post2",FALSE)  #No:FUN-B60140
       #    CALL cl_set_act_visible("carry_voucher2,undo_carry_voucher2",FALSE)  #No:FUN-B60140
       # END IF
       #FUN-C30140--mark---end---
 
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
         CALL t106_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t106_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t106_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t106_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t106_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         IF g_fba.fbaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_fba.fba08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_fba.fbaconf,g_chr2,g_fba.fbapost,"",g_chr,"")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 自動產生
      ON ACTION auto_generate
         LET g_action_choice="auto_generate"
         EXIT DISPLAY
      #@ON ACTION 分錄底稿
      ON ACTION entry_sheet
         LET g_action_choice="entry_sheet"
         EXIT DISPLAY
      #@ON ACTION 分錄底稿2
      ON ACTION entry_sheet2
         LET g_action_choice="entry_sheet2"
         EXIT DISPLAY
      #@ON ACTION 會計分錄產生
      ON ACTION gen_entry
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
      #-----No:FUN-B60140-----
      #@ON ACTION 會計分錄產生財簽二
      ON ACTION gen_entry2
         LET g_action_choice="gen_entry2"
         EXIT DISPLAY
      #-----No:FUN-B60140 END-----
      #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #FUN-D20035---add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20035---add--end

      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION carry_voucher
         LET g_action_choice="carry_voucher"
         EXIT DISPLAY
      ON ACTION undo_carry_voucher
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY
      #@ON ACTION 過帳
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
      #@ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
      #FUN-AB0088---add---str---
      ON ACTION fin_audit2   #財簽二
         LET g_action_choice="fin_audit2"
         EXIT DISPLAY       
      #FUN-AB0088---add---end---
      #-----No:FUN-B60140-----
      ON ACTION carry_voucher2
         LET g_action_choice="carry_voucher2"
         EXIT DISPLAY
      ON ACTION undo_carry_voucher2
         LET g_action_choice="undo_carry_voucher2"
         EXIT DISPLAY
      #@ON ACTION 過帳
      ON ACTION post2
         LET g_action_choice="post2"
         EXIT DISPLAY
      #@ON ACTION 過帳還原
      ON ACTION undo_post2
         LET g_action_choice="undo_post2"
         EXIT DISPLAY
      #-----No:FUN-B60140 END-----
      #@ON ACTION 稅簽修改
      ON ACTION amend_depr_tax
         LET g_action_choice="amend_depr_tax"
         EXIT DISPLAY
      #@ON ACTION 稅簽過帳
      ON ACTION post_depr_tax
         LET g_action_choice="post_depr_tax"
         EXIT DISPLAY
      #@ON ACTION 稅簽還原
      ON ACTION undo_post_depr_tax
         LET g_action_choice="undo_post_depr_tax"
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
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
     ON ACTION easyflow_approval
        LET g_action_choice = 'easyflow_approval'
        EXIT DISPLAY
 
     ON ACTION approval_status
        LET g_action_choice="approval_status"
        EXIT DISPLAY
 
     ON ACTION agree
        LET g_action_choice = 'agree'
        EXIT DISPLAY
 
     ON ACTION deny
        LET g_action_choice = 'deny'
        EXIT DISPLAY
 
     ON ACTION modify_flow
        LET g_action_choice = 'modify_flow'
        EXIT DISPLAY
 
     ON ACTION withdraw
        LET g_action_choice = 'withdraw'
        EXIT DISPLAY
 
     ON ACTION org_withdraw
        LET g_action_choice = 'org_withdraw'
        EXIT DISPLAY
 
     ON ACTION phrase
        LET g_action_choice = 'phrase'
        EXIT DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#---自動產生-------
FUNCTION t106_g()
 DEFINE ls_tmp STRING
 DEFINE  l_wc        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(300)
         l_sql       LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(600)
         faj01       LIKE faj_file.faj01,
         faj02       LIKE faj_file.faj02,
         faj022      LIKE faj_file.faj022,
         faj53       LIKE faj_file.faj53,
         l_faj       RECORD
                     faj02     LIKE faj_file.faj02,
                     faj022    LIKE faj_file.faj022,
                     faj06     LIKE faj_file.faj06,
                     faj33     LIKE faj_file.faj33,
                     faj331    LIKE faj_file.faj331,   #MOD-970231 add
                     faj30     LIKE faj_file.faj30,
                     faj31     LIKE faj_file.faj31,
                     faj65     LIKE faj_file.faj65,
                     faj66     LIKE faj_file.faj66,
                     faj68     LIKE faj_file.faj68
                     END RECORD,
         ans             LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_cnt           LIKE type_file.num5,        #CHI-B80007 add
         i               LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE l_faj332   LIKE faj_file.faj332   #No:FUN-BB0122
   DEFINE l_faj3312  LIKE faj_file.faj3312  #No:FUN-BB0122
   DEFINE l_faj302   LIKE faj_file.faj302   #No:FUN-BB0122
   DEFINE l_faj312   LIKE faj_file.faj312   #No:FUN-BB0122
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fba.fba01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fba.fbaconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_fba.fbaconf='Y' THEN CALL cl_err(g_fba.fba01,'afa-107',0) RETURN END IF
    IF NOT cl_confirm('afa-103') THEN RETURN END IF     #No.MOD-490235
      LET INT_FLAG = 0
 

  #---------詢問是否自動新增單身--------------
      LET p_row = 8 LET p_col = 14
      OPEN WINDOW t106_w2 AT p_row,p_col WITH FORM "afa/42f/afat106g"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
      CALL cl_ui_locale("afat106g")
 
     #CONSTRUCT BY NAME l_wc ON faj01,faj02,faj022,faj53          #No.FUN-B50118 mark
      CONSTRUCT BY NAME l_wc ON faj01,faj93,faj02,faj022,faj53    #No.FUN-B50118 add
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
      END CONSTRUCT
      IF l_wc = " 1=1" THEN
         CALL cl_err('','abm-997',1)
         LET INT_FLAG = 1
      END IF
      IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t106_w2 RETURN END IF
      # ------自動產生------
      BEGIN WORK
 
      OPEN t106_cl USING g_fba.fba01
      IF STATUS THEN
         CALL cl_err("OPEN t106_cl:", STATUS, 1)
         CLOSE t106_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH t106_cl INTO g_fba.*          # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_fba.fba01,SQLCA.sqlcode,0)     # 資料被他人LOCK
         CLOSE t106_cl ROLLBACK WORK RETURN
      END IF
      LET g_success='Y'
      LET l_sql ="SELECT faj02,faj022,faj06,faj33,faj331,faj30,faj31,faj65,",   #MOD-970231 add faj331
                 "faj66,faj68",
                 "  FROM faj_file",
                 " WHERE faj43 NOT IN ('0','5','6','X')",
                 "   AND fajconf = 'Y'",
                 "   AND faj02 NOT IN (SELECT fca03 FROM fca_file",
                 " WHERE fca03  = faj02 AND fca031 = faj022 ",
                 "   AND fca15  = 'N')",
                 "   AND faj100 < '",g_fba.fba02,"'",
                 "   AND ",l_wc CLIPPED,
                 " ORDER BY 1"
     PREPARE t106_prepare_g FROM l_sql
     IF SQLCA.SQLCODE != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0)
        CLOSE t106_cl ROLLBACK WORK RETURN
     END IF
     DECLARE t106_curs2 CURSOR FOR t106_prepare_g
     SELECT MAX(fbb02)+1 INTO i FROM fbb_file
      WHERE fbb01 = g_fba.fba01
     IF STATUS THEN
        CALL cl_err3("sel","fbb_file",g_fba.fba01,"",STATUS,"","",1)  #No.FUN-660136
     END IF
     IF cl_null(i) THEN
        LET i = 1
     END IF
     MESSAGE "WAIT !!"
      INITIALIZE l_faj.* TO NULL   #MOD-530464
     CALL s_showmsg_init()         #No.FUN-710028
     FOREACH t106_curs2 INTO l_faj.*
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        
 
       IF SQLCA.sqlcode != 0 THEN
          CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)  #No.FUN-710028
          LET g_success='N'
          EXIT FOREACH
       END IF
       MESSAGE l_faj.faj02
       IF cl_null(l_faj.faj022) THEN
          LET l_faj.faj022 = ' '
       END IF
       SELECT COUNT(*) INTO g_cnt FROM fan_file
        WHERE fan01 = l_faj.faj02
          AND fan02 = l_faj.faj022
          AND ((fan03 = YEAR(g_fba.fba02) AND fan04 >= MONTH(g_fba.fba02))
           OR fan03 > YEAR(g_fba.fba02))
          AND fan041 = '1'   #MOD-BC0025 add
       #FUN-AB0088---add---str---
       LET g_cnt1 = 0
       IF g_faa.faa31 = 'Y' THEN
           SELECT COUNT(*) INTO g_cnt1 FROM fbn_file
            WHERE fbn01 = l_faj.faj02
              AND fbn02 = l_faj.faj022
              AND ((fbn03 = YEAR(g_fba.fba02) AND fbn04 >= MONTH(g_fba.fba02))
               OR fbn03 > YEAR(g_fba.fba02))
              AND fbn041 = '1'   #MOD-BC0025 add
       END IF
       LET g_cnt = g_cnt + g_cnt1  
       #FUN-AB0088---add---end---  
       IF g_cnt > 0 THEN
          CALL cl_err(l_faj.faj02,'afa-092',0)
          CONTINUE FOREACH
       END IF
       #CHI-B80007 -- begin --
       SELECT count(*) INTO l_cnt FROM fbb_file,fba_file
         WHERE fbb01 = fba01
          AND fbb03  = l_faj.faj02
          AND fbb031 = l_faj.faj022
          AND fba02 <= g_fba.fba02
          AND fbapost = 'N'
          AND fba01 != g_fba.fba01
          AND fbaconf <> 'X'
       IF l_cnt > 0 THEN
          CONTINUE FOREACH
       END IF
       #CHI-B80007 -- end --
       #-----No:FUN-BB0122-----

       LET l_sql = " SELECT faj332,faj3312,faj302,faj312 FROM faj_file ", 
                   "  WHERE faj02 = '",l_faj.faj02,"'",
                   "    AND faj022 = '",l_faj.faj022,"'"
       PREPARE faj_preg1 FROM l_sql
       DECLARE faj_csg1 CURSOR FOR faj_preg1
       OPEN faj_csg1
       FETCH faj_csg1 INTO l_faj332,l_faj3312,l_faj302,l_faj312

       IF cl_null(l_faj332) THEN LET l_faj332=0 END IF
       IF cl_null(l_faj3312) THEN LET l_faj3312=0 END IF
       IF cl_null(l_faj302) THEN LET l_faj302=0 END IF
       IF cl_null(l_faj312) THEN LET l_faj312=0 END IF
       #-----No:FUN-BB0122 End-----
      #CHI-C60010---str---
       CALL cl_digcut(l_faj332,g_azi04_1) RETURNING l_faj332
       CALL cl_digcut(l_faj3312,g_azi04_1) RETURNING l_faj3312
       CALL cl_digcut(l_faj312,g_azi04_1) RETURNING l_faj312
      #CHI-C60010---end---
       INSERT INTO fbb_file(fbb01,fbb02,fbb03,fbb031,fbb04,fbb05,fbb06,
                             fbb08,fbb09,fbb10,fbb13,fbb14,fbb15,
                             fbb17,fbb18,fbb19,fbblegal, #FUN-980003 add
                       	     fbb042,fbb052,fbb062,fbb082,fbb092,fbb102)   #No:FUN-BB0122
       VALUES(g_fba.fba01,i,l_faj.faj02,l_faj.faj022,l_faj.faj33+l_faj.faj331,  #MOD-970231
              l_faj.faj30,l_faj.faj31,0,
              l_faj.faj30,l_faj.faj31,l_faj.faj68,
              l_faj.faj65,l_faj.faj66,l_faj.faj68,
              l_faj.faj65,l_faj.faj66,g_legal, #FUN-980003 add
	      (l_faj332+l_faj3312),l_faj302,l_faj312,0,l_faj302,l_faj312)   #No:FUN-BB0122
       IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
          LET g_showmsg = g_fba.fba01,"/",i                           #No.FUN-710028
          CALL s_errmsg('fbb01,fbb02',g_showmsg,'ins fbb',STATUS,1)   #No.FUN-710028
          LET g_success='N'
          CONTINUE FOREACH   #No.FUN-710028
       END IF
       LET i = i + 1
     END FOREACH
     IF g_totsuccess="N" THEN                                                                                                        
        LET g_success="N"                                                                                                            
     END IF                                                                                                                          
 
     IF l_faj.faj02 IS NULL THEN
        CALL s_errmsg('','','','afa-119',0)  #No.FUN-710028
     END IF
     CLOSE t106_cl
     CALL s_showmsg()   #No.FUN-710028
     CLOSE WINDOW t106_w2
     IF g_success='Y' THEN
        COMMIT WORK
     ELSE
        ROLLBACK WORK
     END IF
     CALL t106_b_fill(l_wc)
END FUNCTION
 
FUNCTION t106_k()
   DEFINE ls_tmp STRING
   DEFINE g_fbb     DYNAMIC ARRAY OF RECORD
                     fbb02	LIKE fbb_file.fbb02,   #No.MOD-480099
                    fbb03	LIKE fbb_file.fbb03,
                    faj06	LIKE faj_file.faj06,
                    fbb031	LIKE fbb_file.fbb031,
                    fbb04	LIKE fbb_file.fbb04,
                    fbb08	LIKE fbb_file.fbb08,
                    fbb05	LIKE fbb_file.fbb05,
                    fbb09	LIKE fbb_file.fbb09,
                    fbb06	LIKE fbb_file.fbb06,
                    fbb10	LIKE fbb_file.fbb10,
                    fbb12	LIKE fbb_file.fbb12,
                    fbb13	LIKE fbb_file.fbb13,
                    fbb14	LIKE fbb_file.fbb14,
                    fbb15	LIKE fbb_file.fbb15,
                    fbb17	LIKE fbb_file.fbb17,
                    fbb18	LIKE fbb_file.fbb18,
                    fbb19	LIKE fbb_file.fbb19
                    END RECORD
   DEFINE g_fbb_t   RECORD
                     fbb02	LIKE fbb_file.fbb02,   #No.MOD-480099
                    fbb03	LIKE fbb_file.fbb03,
                    faj06	LIKE faj_file.faj06,
                    fbb031	LIKE fbb_file.fbb031,
                    fbb04	LIKE fbb_file.fbb04,
                    fbb08	LIKE fbb_file.fbb08,
                    fbb05	LIKE fbb_file.fbb05,
                    fbb09	LIKE fbb_file.fbb09,
                    fbb06	LIKE fbb_file.fbb06,
                    fbb10	LIKE fbb_file.fbb10,
                    fbb12	LIKE fbb_file.fbb12,
                    fbb13	LIKE fbb_file.fbb13,
                    fbb14	LIKE fbb_file.fbb14,
                    fbb15	LIKE fbb_file.fbb15,
                    fbb17	LIKE fbb_file.fbb17,
                    fbb18	LIKE fbb_file.fbb18,
                    fbb19	LIKE fbb_file.fbb19
                    END RECORD
   DEFINE l_lock_sw       LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE l_modify_flag   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE p_cmd           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE l_fbb19         LIKE fbb_file.fbb19    #No.FUN-4C0008
   DEFINE l_faj28         LIKE faj_file.faj28
   DEFINE i,j,k           LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE l_allow_insert  LIKE type_file.num5                #可新增否       #No.FUN-680070 SMALLINT
   DEFINE l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
   DEFINE l_fab23         LIKE fab_file.fab23    #No:A099
   DEFINE l_cnt           LIKE type_file.num5   #CHI-860025
 
   IF g_fba.fba01 IS NULL THEN RETURN END IF
   IF g_fba.fbaconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   #FUN-C30140---add---str---
   IF NOT cl_null(g_fba.fba08) AND g_fba.fba08 matches '[Ss]' THEN     
       CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
       RETURN
   END IF 
   #FUN-C30140---add---end---
   LET p_row = 10 LET p_col = 17
   OPEN WINDOW t106_w5 AT p_row,p_col WITH FORM "afa/42f/afat1062"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afat1062")
 
 
   DECLARE t106_kkk_c CURSOR FOR
          SELECT fbb02, fbb03, faj06, fbb031, fbb04, fbb08, fbb05,  #No.MOD-480099
                fbb09, fbb06, fbb10, fbb12,
                fbb13, fbb14, fbb15, fbb17, fbb18, fbb19
           FROM fbb_file LEFT OUTER JOIN faj_file ON fbb03 = faj02 AND fbb031 = faj022
            WHERE fbb01 = g_fba.fba01
          ORDER BY 1
   FOR k = 1 TO 200 INITIALIZE g_fbb[k].* TO NULL END FOR
   LET k = 1
   FOREACH t106_kkk_c INTO g_fbb[k].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('t106_kkk_c',SQLCA.sqlcode,0)   
         EXIT FOREACH
      END IF
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt FROM fao_file
       WHERE fao01 = g_fbb[k].fbb03
         AND fao02 = g_fbb[k].fbb031
         AND ((fao03 = YEAR(g_fba.fba02) AND fao04 >= MONTH(g_fba.fba02))
          OR fao03 > YEAR(g_fba.fba02))
         AND fao041 = '1'   #MOD-BC0025 add
      IF l_cnt > 0 THEN
         CALL cl_err(g_fbb[k].fbb03,'afa-092',0)
         CONTINUE FOREACH
      END IF
      LET k = k + 1
      IF k > 200 THEN EXIT FOREACH END IF
   END FOREACH
   CALL g_fbb.deleteElement(k)   #CHI-860025
   Let k = k - 1   #CHI-860025
   CALL SET_COUNT(k)   #CHI-860025
   SELECT * FROM fba_file WHERE fba01 = g_fba.fba01
 
   DISPLAY BY NAME g_fba.fbaconf, g_fba.fbapost, g_fba.fbapost2,
                   g_fba.fbauser, g_fba.fbagrup, g_fba.fbamodu,g_fba.fbadate
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_fbb WITHOUT DEFAULTS FROM s_fbb.*
         ATTRIBUTE(COUNT=k,MAXCOUNT=g_max_rec,UNBUFFERED,   #CHI-860025
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INSERT
         LET i = ARR_CURR() LET j = SCR_LINE()
         LET p_cmd='a'
         INITIALIZE g_fbb[i].* TO NULL
         LET g_fbb_t.* = g_fbb[i].*
 
      BEFORE INPUT
          CALL fgl_set_arr_curr(l_ac)
 
      BEFORE ROW
         LET i = ARR_CURR() LET j = SCR_LINE()
         LET g_fbb_t.* = g_fbb[i].*
         LET l_lock_sw = 'N'
         LET g_success = 'Y'
         IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
         ELSE
              LET p_cmd='a'
              INITIALIZE g_fbb[i].* TO NULL
         END IF
 
      BEFORE FIELD fbb19
         SELECT faj61 INTO l_faj28 FROM faj_file       #No:A099
                      WHERE faj02 = g_fbb[i].fbb03
                        AND faj022= g_fbb[i].fbb031
         IF SQLCA.sqlcode THEN LET l_faj28 = '' END IF
         IF g_aza.aza26 = '2' THEN
            SELECT DISTINCT(fab23) INTO l_fab23 FROM fab_file,faj_file
             WHERE fab01  = faj04
               AND faj02  = g_fbb[i].fbb03
               AND faj022 = g_fbb[i].fbb031
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","fab_file,faj_file",g_fbb[i].fbb03,g_fbb[i].fbb031,SQLCA.sqlcode,"","",1)  #No.FUN-660136
               LET g_success = 'N' RETURN
            END IF
            IF l_faj28 MATCHES '[05]' THEN
               LET l_fbb19 = 0
            ELSE
               LET l_fbb19=(g_fbb[i].fbb13 + g_fbb[i].fbb17) *
                            l_fab23/100
            END IF
            LET g_fbb[i].fbb19 = l_fbb19
            DISPLAY g_fbb[i].fbb19 TO s_fbb[j].fbb19
         ELSE
            CASE
              WHEN l_faj28 = '0'
                   LET g_fbb[i].fbb19 = 0
                   DISPLAY g_fbb[i].fbb19 TO s_fbb[j].fbb19
              WHEN l_faj28 = '1'
                   LET l_fbb19=(g_fbb[i].fbb13 + g_fbb[i].fbb17 )
                                  /(g_fbb[i].fbb18 + 12)*12
                   LET g_fbb[i].fbb19 = l_fbb19
                   DISPLAY g_fbb[i].fbb19 TO s_fbb[j].fbb19
            END CASE
         END IF

      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_fbb[i].* = g_fbb_t.*
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_fbb[i].fbb02,-263,1)
             LET g_fbb[i].* = g_fbb_t.*
          ELSE
             UPDATE fbb_file SET fbb17 = g_fbb[i].fbb17,
                                 fbb18 = g_fbb[i].fbb18,
                                 fbb19 = g_fbb[i].fbb19
                           WHERE fbb01 = g_fba.fba01
                             AND fbb02 = g_fbb_t.fbb02
             IF STATUS THEN
                  CALL cl_err3("upd","fbb_file",g_fba.fba01,g_fbb_t.fbb02,STATUS,"","upd fbb:",1)  #No.FUN-660136
                  LET g_success = 'N' 
                  LET g_fbb[i].* = g_fbb_t.*
                  DISPLAY g_fbb[i].* TO s_fbb[j].*
             ELSE MESSAGE "update ok"
             END IF
          END IF
 
      AFTER ROW
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_fbb[i].* = g_fbb_t.*
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET g_fbb_t.* = g_fbb[i].*
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
   IF INT_FLAG THEN LET g_success='N' LET INT_FLAG = 0 END IF
   CLOSE WINDOW t106_w5
END FUNCTION
 
FUNCTION t106_y() 	# 確認 when g_fba.fbaconf='N' (Turn to 'Y')
DEFINE l_cnt LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE l_cnt1 LIKE type_file.num5   #FUN-AB0088 
  IF s_shut(0) THEN RETURN END IF
  IF g_fba.fba01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fba.* FROM fba_fiel WHERE fba01 = g_fba.fba01
  IF g_fba.fbaconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
  SELECT COUNT(*) INTO l_cnt FROM fbb_file
   WHERE fbb01= g_fba.fba01
  IF l_cnt = 0 THEN
     CALL cl_err('','mfg-009',0)
     RETURN
  END IF
  IF g_fba.fbaconf='Y' THEN RETURN END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-->立帳日期小於關帳日期
  IF g_fba.fba02 < g_faa.faa09 THEN
     CALL cl_err(g_fba.fba01,'aap-176',1) RETURN
  END IF
  #-----No:FUN-B60140-----
  #-->立帳日期小於關帳日期
  IF g_faa.faa31 = "Y" THEN
     IF g_fba.fba02 < g_faa.faa092 THEN
        CALL cl_err(g_fba.fba01,'aap-176',1) RETURN
     END IF
  END IF
  #-----No:FUN-B60140 END-----
  #----------------------------------- 檢查分錄底稿平衡正確否
#FUN-C30313---mark---START
# IF g_fah.fahdmy3 = 'Y' THEN
#        IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125
#       CALL s_chknpq(g_fba.fba01,'FA',1,'0',g_bookno1)  #No.FUN-740033
#        END IF #MOD-BC0125
#   #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 mark
#    IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN    #FUN-AB0088 #MOD-BC0125 
#       CALL s_chknpq(g_fba.fba01,'FA',1,'1',g_bookno2)  #No.FUN-740033
#    END IF
# END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
  IF g_fah.fahdmy3 = 'Y' THEN
     IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125
        CALL s_chknpq(g_fba.fba01,'FA',1,'0',g_bookno1)  #No.FUN-740033
     END IF #MOD-BC0125
  END IF
  IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN    #FUN-AB0088 #MOD-BC0125
     IF g_fah.fahdmy32 = 'Y' THEN
        CALL s_chknpq(g_fba.fba01,'FA',1,'1',g_bookno2)  #No.FUN-740033
     END IF
  END IF
#FUN-C30313---add---END-------
  IF g_success = 'N' THEN RETURN END IF
  IF NOT cl_confirm('axm-108') THEN RETURN END IF
  BEGIN WORK
 
  OPEN t106_cl USING g_fba.fba01
  IF STATUS THEN
     CALL cl_err("OPEN t106_cl:", STATUS, 1)
     CLOSE t106_cl
     ROLLBACK WORK
     RETURN
  END IF
  FETCH t106_cl INTO g_fba.*          # 鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
      CALL cl_err(g_fba.fba01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t106_cl ROLLBACK WORK RETURN
  END IF
 
  LET g_success = 'Y'
  UPDATE fba_file SET fbaconf = 'Y'
   WHERE fba01 = g_fba.fba01
  IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
     CALL cl_err3("upd","fba_file",g_fba.fba01,"",SQLCA.sqlcode,"","upd fbaconf",1)  #No.FUN-660136
     LET g_success = 'N'
  END IF
  CLOSE t106_cl
  IF g_success = 'Y' THEN
     LET g_fba.fbaconf='Y'
     COMMIT WORK
     CALL cl_flow_notify(g_fba.fba01,'Y')
     DISPLAY BY NAME g_fba.fbaconf
  ELSE
     LET g_fba.fbaconf='N'
     ROLLBACK WORK
  END IF
  IF g_fba.fbaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fba.fba08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fba.fbaconf,g_chr2,g_fba.fbapost,"",g_chr,"")
END FUNCTION
 
FUNCTION t106_y_chk()
  DEFINE l_fbb RECORD LIKE fbb_file.*   #TQC-780089
  DEFINE l_cnt LIKE type_file.num5         #No.FUN-680070 SMALLINT
  DEFINE l_cnt1 LIKE type_file.num5        #FUN-AB0088 
  LET g_success = 'Y'              #FUN-580109
 
  IF s_shut(0) THEN
     LET g_success = 'N'           #FUN-580109
     RETURN
  END IF
#CHI-C30107 ------------- add -------------- begin
  IF g_fba.fbaconf = 'X' THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err(' ','9024',0)
     RETURN
  END IF
  IF g_fba.fbaconf = 'Y' THEN
     LET g_success = 'N'
     CALL cl_err(' ','9023',0)
     RETURN
  END IF
  IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
      g_action_choice CLIPPED = "insert"     #FUN-640243
  THEN
     IF NOT cl_confirm('axm-108') THEN  LET g_success = 'N' RETURN END IF 
  END IF
#CHI-C30107 ------------- add -------------- end
  IF g_fba.fba01 IS NULL THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('',-400,0)
     RETURN
  END IF
  #SELECT * INTO g_fba.* FROM fba_fiel WHERE fba01 = g_fba.fba01
  SELECT * INTO g_fba.* FROM fba_file WHERE fba01 = g_fba.fba01  #No:FUN-B60140
  IF g_fba.fbaconf = 'X' THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err(' ','9024',0)
     RETURN
  END IF
  IF g_fba.fbaconf = 'Y' THEN
     LET g_success = 'N'
     CALL cl_err(' ','9023',0)
     RETURN
  END IF
 
  SELECT COUNT(*) INTO l_cnt FROM fbb_file
   WHERE fbb01= g_fba.fba01
  IF l_cnt = 0 THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('','mfg-009',0)
     RETURN
  END IF
  IF g_fba.fbaconf='Y' THEN
     LET g_success = 'N'           #FUN-580109
     RETURN
  END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-->立帳日期小於關帳日期
  IF g_fba.fba02 < g_faa.faa09 THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err(g_fba.fba01,'aap-176',1)
     RETURN
  END IF
  #-----No:FUN-B60140-----
  #-->立帳日期小於關帳日期
  IF g_faa.faa31 = "Y" THEN
     IF g_fba.fba02 < g_faa.faa092 THEN
        LET g_success = 'N'           #FUN-580109
        CALL cl_err(g_fba.fba01,'aap-176',1)
        RETURN
     END IF
  END IF
  #-----No:FUN-B60140 END-----
  DECLARE t106_cur6 CURSOR FOR
     SELECT * FROM fbb_file WHERE fbb01=g_fba.fba01
  FOREACH t106_cur6 INTO l_fbb.*
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM fan_file
      WHERE fan01 = l_fbb.fbb03
        AND fan02 = l_fbb.fbb031
        AND ((fan03 = YEAR(g_fba.fba02) AND fan04 >= MONTH(g_fba.fba02))
         OR fan03 > YEAR(g_fba.fba02))
        AND fan041 = '1'   #MOD-C50044 add
     #FUN-AB0088---add---str---
     LET l_cnt1 = 0
     IF g_faa.faa31 = 'Y' THEN
         SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
          WHERE fbn01 = l_fbb.fbb03
            AND fbn02 = l_fbb.fbb031
            AND ((fbn03 = YEAR(g_fba.fba02) AND fbn04 >= MONTH(g_fba.fba02))
             OR fbn03 > YEAR(g_fba.fba02))
            AND fbn041 = '1'   #MOD-C50044 add
     END IF 
     LET l_cnt = l_cnt + l_cnt1
     #FUN-AB0088---add---end---
     IF l_cnt > 0 THEN
        LET g_success='N'
        CALL cl_err(l_fbb.fbb03,'afa-348',0)
        RETURN
     END IF
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM fao_file
      WHERE fao01 = l_fbb.fbb03
        AND fao02 = l_fbb.fbb031
        AND ((fao03 = YEAR(g_fba.fba02) AND fao04 >= MONTH(g_fba.fba02))
         OR fao03 > YEAR(g_fba.fba02))
        AND fao041 = '1'   #MOD-C50044 add
     IF l_cnt > 0 THEN
        LET g_success='N'
        CALL cl_err(l_fbb.fbb03,'afa-348',0)
        RETURN
     END IF
  END FOREACH
 
  #----------------------------------- 檢查分錄底稿平衡正確否
  LET g_t1 = s_get_doc_no(g_fba.fba01)  #No.FUN-670060                                                                           
  SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1  #No.FUN-670060
#FUN-C30313---mark---START
# IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'N' THEN  #No.FUN-670060
#        IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125
#       CALL s_chknpq(g_fba.fba01,'FA',1,'0',g_bookno1)  #No.FUN-740033
#        END IF #MOD-BC0125
##    IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN  #FUN-AB0088 mark
#    IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN  #FUN-AB0088 #MOD-BC0125
#       CALL s_chknpq(g_fba.fba01,'FA',1,'1',g_bookno2)  #No.FUN-740033
#    END IF
# END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
  IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'N' THEN  #No.FUN-670060
     IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125
        CALL s_chknpq(g_fba.fba01,'FA',1,'0',g_bookno1)  #No.FUN-740033
     END IF #MOD-BC0125
  END IF
  IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN  #FUN-AB0088 #MOD-BC0125
     IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'N' THEN
        CALL s_chknpq(g_fba.fba01,'FA',1,'1',g_bookno2)  #No.FUN-740033
     END IF
  END IF
#FUN-C30313---add---END-------
 
  IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t106_y_upd()
   DEFINE l_n    LIKE type_file.num10      #No.FUN-670060       #No.FUN-680070 INTEGER
   #CHI-B80007 -- begin --
   DEFINE l_fbb     RECORD LIKE fbb_file.*
   DEFINE l_msg     LIKE type_file.chr1000
   DEFINE l_cnt     LIKE type_file.num5
   #CHI-B80007 -- begin --
  
   LET g_success = 'Y'
   IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
      g_action_choice CLIPPED = "insert"     #FUN-640243
   THEN
      IF g_fba.fbamksg='Y'   THEN
          IF g_fba.fba08 != '1' THEN
             CALL cl_err('','aws-078',1)
             LET g_success = 'N'
             RETURN
          END IF
      END IF
#     IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
   END IF
  
   BEGIN WORK
  
   OPEN t106_cl USING g_fba.fba01
   IF STATUS THEN
      CALL cl_err("OPEN t106_cl:", STATUS, 1)
      CLOSE t106_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t106_cl INTO g_fba.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_fba.fba01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t106_cl ROLLBACK WORK RETURN
   END IF
  
   #CHI-B80007 -- begin --
   DECLARE t106_fbb_cur CURSOR FOR
      SELECT * FROM fbb_file WHERE fbb01=g_fba.fba01
   FOREACH t106_fbb_cur INTO l_fbb.*
      SELECT count(*) INTO l_cnt FROM fbb_file,fba_file
       WHERE fbb01 = fba01
         AND fbb03 = l_fbb.fbb03
         AND fbb031= l_fbb.fbb031 AND fba02 <= g_fba.fba02
         AND fbapost = 'N'
         AND fba01 != g_fba.fba01
         AND fbaconf <> 'X'
      IF l_cnt  > 0 THEN
         LET l_msg = l_fbb.fbb01,' ',l_fbb.fbb02,' ',
                     l_fbb.fbb03,' ',l_fbb.fbb031
         CALL s_errmsg('','',l_msg,'afa-309',1)
         LET g_success = 'N'
      END IF
   END FOREACH
   IF g_success = 'N' THEN
      CALL s_showmsg()
      RETURN
   END IF
   #CHI-B80007 -- end --

   LET g_success = 'Y'
#FUN-C30313---mark---START
#   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
#      SELECT count(*) INTO l_n FROM npq_file
#       WHERE npq01 = g_fba.fba01
#         AND npq011 = 1
#         AND npqsys = 'FA'
#         AND npq00 = 8
#      IF l_n = 0 THEN
#         CALL t106_gen_glcr(g_fba.*,g_fah.*)
#      END IF
#      IF g_success = 'Y' THEN 
#       	  IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125
#            CALL s_chknpq(g_fba.fba01,'FA',1,'0',g_bookno1)  #No.FUN-740033
#       	  END IF #MOD-BC0125
#        #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN  #FUN-AB0088
#         IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN  #FUN-AB0088 #MOD-BC0125
#            CALL s_chknpq(g_fba.fba01,'FA',1,'1',g_bookno2)  #No.FUN-740033
#         END IF
#      END IF
#      IF g_success = 'N' THEN RETURN END IF #No.FUN-680028
#   END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
       SELECT count(*) INTO l_n FROM npq_file
        WHERE npq01 = g_fba.fba01
          AND npq011 = 1
          AND npqsys = 'FA'
          AND npq00 = 8
      #IF l_n = 0 THEN                                                                     #MOD-C50255 mark
       IF l_n = 0 AND                                                                      #MOD-C50255 add
          ((g_fah.fahdmy3 = 'Y') OR (g_faa.faa31 = 'Y' AND g_fah.fahdmy32 = 'Y' )) THEN    #MOD-C50255 add
          CALL t106_gen_glcr(g_fba.*,g_fah.*)
       END IF
       IF g_success = 'Y' THEN
          IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
             IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125
                CALL s_chknpq(g_fba.fba01,'FA',1,'0',g_bookno1)  #No.FUN-740033
             END IF #MOD-BC0125
          END IF
          IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN  #FUN-AB0088 #MOD-BC0125
             IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN
                CALL s_chknpq(g_fba.fba01,'FA',1,'1',g_bookno2)  #No.FUN-740033
             END IF
          END IF
       END IF
       IF g_success = 'N' THEN RETURN END IF #No.FUN-680028
#FUN-C30313---add---END-------
   UPDATE fba_file SET fbaconf = 'Y'
    WHERE fba01 = g_fba.fba01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('fba01',g_fba.fba01,'upd fbaconf',STATUS,1)   #No.FUN-710028
      LET g_success = 'N'
   END IF
  
   #-----No:FUN-B60140-----
   IF g_faa.faa31 = "Y" THEN
      LET g_t1 = s_get_doc_no(g_fba.fba01)
      SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
      IF g_fah.fahfa1 = "N" THEN
         UPDATE fba_file SET fbapost = 'X',fbapost2='X' WHERE fba01 = g_fba.fba01
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('fba01',g_fba.fba01,'upd fbapost',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
      IF g_fah.fahfa2 = "N" THEN
         UPDATE fba_file SET fbapost1= 'X' WHERE fba01 = g_fba.fba01
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('fba01',g_fba.fba01,'upd fbapost1',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
      SELECT fbapost,fbapost1,fbapost2
        INTO g_fba.fbapost,g_fba.fbapost1,g_fba.fbapost2
        FROM fba_file
       WHERE fba01 = g_fba.fba01
      DISPLAY BY NAME g_fba.fbapost,g_fba.fbapost1,g_fba.fbapost2
   END IF
   #-----No:FUN-B60140 END-----
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'Y' THEN
      IF g_fba.fbamksg = 'Y' THEN #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
             WHEN 0  #呼叫 EasyFlow 簽核失敗
                  LET g_fba.fbaconf="N"
                  LET g_success = "N"
                  ROLLBACK WORK
                  RETURN
             WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                  LET g_fba.fbaconf="N"
                  ROLLBACK WORK
                  RETURN
         END CASE
      END IF
      CLOSE t106_cl
      IF g_success = 'Y' THEN
#No.MOD-C10026 --begin
         IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
            UPDATE fba_file SET fbapost = 'Y' WHERE fba01 = g_fba.fba01
            IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err(g_fba.fba01,STATUS,1)    #No.FUN-710028
               LET g_success = 'N'
               ROLLBACK WORK 
               RETURN 
            END IF
         END IF 
#No.MOD-C10026 --end
         LET g_fba.fba08='1'      #執行成功, 狀態值顯示為 '1' 已核准
         UPDATE fba_file SET fba08 = g_fba.fba08 WHERE fba01=g_fba.fba01
         IF SQLCA.sqlerrd[3]=0 THEN
            LET g_success='N'
         END IF
         LET g_fba.fbaconf='Y'    #執行成功, 確認碼顯示為 'Y' 已確認
         COMMIT WORK
         CALL cl_flow_notify(g_fba.fba01,'Y')
         DISPLAY BY NAME g_fba.fbaconf
         DISPLAY BY NAME g_fba.fba08   #FUN-580109
      ELSE
         LET g_fba.fbaconf='N'
         LET g_success = 'N'   #FUN-580109
         ROLLBACK WORK
      END IF
   ELSE
      LET g_fba.fbaconf='N'
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
  #----------------------------------CHI-C90051----------------------------------------mark
  #IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
  #   LET g_wc_gl = 'npp01 = "',g_fba.fba01,'" AND npp011 = 1'
  #   LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_fba.fbauser,"' '",g_fba.fbauser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_fba.fba02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"   #No.FUN-680028   #MOD-860284#FUN-860040
  #   CALL cl_cmdrun_wait(g_str)
  #  #FUN-C30313---mark---START
  #  ##-----No:FUN-B60140-----
  #  #IF g_faa.faa31 = "Y" THEN
  #  #   LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_fba.fbauser,"' '",g_fba.fbauser,"'
  #  #             '",g_faa.faa02p,"''",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_fba.fba02,"'
  #  #              'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"
  #  #   CALL cl_cmdrun_wait(g_str)
  #  #END IF
  #  ##-----No:FUN-B60140 END-----
  #  #SELECT fba06,fba07,fba062,fba072  #No:FUN-B60140 
  #  #  INTO g_fba.fba06,g_fba.fba07,g_fba.fba062,g_fba.fba072  #No:FUN-B60140 
  #  #FUN-C30313---mark---END
  #   SELECT fba06,fba07             #FUN-C30313 add
  #     INTO g_fba.fba06,g_fba.fba07 #FUN-C30313 add
  #     FROM fba_file
  #    WHERE fba01 = g_fba.fba01
  #   DISPLAY BY NAME g_fba.fba06
  #   DISPLAY BY NAME g_fba.fba07
  #   #DISPLAY BY NAME g_fba.fba062  #No:FUN-B60140 #FUN-C30313 mark
  #   #DISPLAY BY NAME g_fba.fba072  #No:FUN-B60140 #FUN-C30313 mark
  #  #No.MOD-C10026 --begin
  #   IF cl_null(g_fba.fba06) THEN 
  #      UPDATE fba_file SET fbapost = 'N' WHERE fba01 = g_fba.fba01
  #   END IF 
  #  #No.MOD-C10026 --end
  #END IF
  ##FUN-C30313---add---START-----
  #IF g_faa.faa31 = "Y" THEN
  #   IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
  #      LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_fba.fbauser,"' '",g_fba.fbauser,"'
  #                '",g_faa.faa02p,"''",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_fba.fba02,"'
  #                 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"
  #      CALL cl_cmdrun_wait(g_str)
  #      SELECT fba062,fba072
  #        INTO g_fba.fba062,g_fba.fba072
  #         FROM fba_file
  #       WHERE fba01 = g_fba.fba01
  #      DISPLAY BY NAME g_fba.fba062
  #      DISPLAY BY NAME g_fba.fba072          
  #   END IF
  #END IF
  ##FUN-C30313---add---END-------
  #----------------------------------CHI-C90051----------------------------------------mark
  
   IF g_fba.fbaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fba.fba08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fba.fbaconf,g_chr2,g_fba.fbapost,"",g_chr,"")
 
END FUNCTION
 
FUNCTION t106_ef()
 
  CALL t106_y_chk()      #CALL 原確認的 check 段
  IF g_success = "N" THEN
     RETURN
  END IF
 
  CALL aws_condition()   #判斷送簽資料
  IF g_success = 'N' THEN
     RETURN
  END IF
 
######################################
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
######################################
 
  IF aws_efcli2(base.TypeInfo.create(g_fba),base.TypeInfo.create(g_fbb),'','','','')
  THEN
     LET g_success='Y'
     LET g_fba.fba08='S'
     DISPLAY BY NAME g_fba.fba08
  ELSE
     LET g_success='N'
  END IF
 
END FUNCTION
 
FUNCTION t106_z() 	# 確認取消 when g_fba.fbaconf='Y' (Turn to 'N')
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fba.fba01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fba.* FROM fba_fiel WHERE fba01 = g_fba.fba01
   IF g_fba.fba08  ='S' THEN CALL cl_err("","mfg3557",0) RETURN END IF   #FUN-580109
   IF g_fba.fbaconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_fba.fbaconf='N' THEN RETURN END IF
   IF g_fba.fbapost='Y' THEN
      CALL cl_err(g_fba.fbapost,'afa-106',0)
      RETURN
   END IF
  #-----No:FUN-B60140-----
   IF g_faa.faa31 = "Y" THEN
      IF g_fba.fbapost1='Y' THEN
         CALL cl_err(g_fba.fbapost,'afa-106',0)
         RETURN
      END IF
   END IF
   #-----No:FUN-B60140 END----- 
  IF g_fba.fbapost2='Y' THEN
      CALL cl_err(g_fba.fbapost2,'afa-106',0)
      RETURN
   END IF
   #-->已拋轉總帳, 不可取消確認
   IF NOT cl_null(g_fba.fba06) THEN
      CALL cl_err(g_fba.fba06,'aap-145',1)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_fba.fba02 < g_faa.faa09 THEN
      CALL cl_err(g_fba.fba01,'aap-176',1) RETURN
   END IF

   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
    OPEN t106_cl USING g_fba.fba01
    IF STATUS THEN
       CALL cl_err("OPEN t106_cl:", STATUS, 1)
       CLOSE t106_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t106_cl INTO g_fba.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fba.fba01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t106_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
   UPDATE fba_file SET fbaconf = 'N', fba08 = '0'  #FUN-580109
    WHERE fba01 = g_fba.fba01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","fba_file",g_fba.fba01,"",SQLCA.sqlcode,"","upd_z fbaconf",1)  #No.FUN-660136
      LET g_success = 'N'
   END IF
   
   #-----No:FUN-B60140-----
   IF g_faa.faa31 = "Y" THEN
      LET g_t1 = s_get_doc_no(g_fba.fba01)
      SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
      IF g_fah.fahfa1 = "N" THEN
         UPDATE fba_file SET fbapost = 'N',fbapost2='N' WHERE fba01 = g_fba.fba01
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('fba01',g_fba.fba01,'upd fbapost',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
      IF g_fah.fahfa2 = "N" THEN
         UPDATE fba_file SET fbapost1= 'N' WHERE fba01 = g_fba.fba01
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('fba01',g_fba.fba01,'upd fbapost1',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
      SELECT fbapost,fbapost1,fbapost2
        INTO g_fba.fbapost,g_fba.fbapost1,g_fba.fbapost2
        FROM fba_file
       WHERE fba01 = g_fba.fba01
      DISPLAY BY NAME g_fba.fbapost,g_fba.fbapost1,g_fba.fbapost2
   END IF
   #-----No:FUN-B60140 END-----
   CLOSE t106_cl
   IF g_success = 'Y' THEN
      LET g_fba.fbaconf='N'
      LET g_fba.fba08='0'   #FUN-580109
      COMMIT WORK
      DISPLAY BY NAME g_fba.fbaconf
      DISPLAY BY NAME g_fba.fba08   #FUN-580109
   ELSE
      LET g_fba.fbaconf='Y'
      ROLLBACK WORK
   END IF

   IF g_fba.fbaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fba.fba08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fba.fbaconf,g_chr2,g_fba.fbapost,"",g_chr,"")
 
END FUNCTION
 
#----過帳--------
FUNCTION t106_s()
   DEFINE l_fbb       RECORD LIKE fbb_file.*,
          l_faj       RECORD LIKE faj_file.*,
          sql         LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(400)
          l_bdate,l_edate LIKE type_file.dat          #No.FUN-680070 DATE
   DEFINE l_cnt       LIKE type_file.num5   #No:FUN-B60140
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fba.fba01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fba.* FROM fba_fiel WHERE fba01 = g_fba.fba01
   IF g_fba.fbaconf != 'Y' OR g_fba.fbapost != 'N' THEN
      CALL cl_err(g_fba.fba01,'afa-100',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fba.fba02 < g_faa.faa09 THEN
      CALL cl_err(g_fba.fba01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-
   LET g_t1 = s_get_doc_no(g_fba.fba01)     #No.FUN-680028
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1     #No.FUN-680028
   #--->折舊年月判斷
   #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
   #CHI-A60036 add --start--
   CALL s_get_bookno(g_faa.faa07)   
       RETURNING g_flag,g_bookno1,g_bookno2
   #FUN-AB0088---add---str---
   #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
   #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
   #FUN-AB0088---add---end---
 # IF g_aza.aza63 = 'Y' THEN #FUN-AB0088 mark
   IF g_faa.faa31= 'Y' THEN  #FUN-AB0088
      CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
   ELSE
      CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
   END IF
   #CHI-A60036 add --end--
   IF g_fba.fba02 < l_bdate OR g_fba.fba02 > l_edate THEN
      CALL cl_err(g_fba.fba02,'afa-308',0)
      RETURN
   END IF
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK
 
    OPEN t106_cl USING g_fba.fba01
    IF STATUS THEN
       CALL cl_err("OPEN t106_cl:", STATUS, 1)
       CLOSE t106_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t106_cl INTO g_fba.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fba.fba01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t106_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
   #--------- 過帳(2)insert fap_file
   DECLARE t106_cur2 CURSOR FOR
      SELECT * FROM fbb_file WHERE fbb01=g_fba.fba01
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t106_cur2 INTO l_fbb.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('fbb01',g_fba.fba01,'foreach:',SQLCA.sqlcode,0)   #No.FUN-710028
         EXIT FOREACH
      END IF
      #------- 先找出對應之 faj_file 資料
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fbb.fbb03
                                            AND faj022=l_fbb.fbb031
      IF STATUS THEN
         CALL cl_err('sel faj',STATUS,0)
         LET g_showmsg = l_fbb.fbb03,"/",l_fbb.fbb031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
      IF cl_null(l_fbb.fbb031) THEN
         LET l_fbb.fbb031 = ' '
      END IF
      #FUN-AB0088---add---str---
      IF cl_null(l_faj.faj432) THEN LET l_faj.faj432 = ' ' END IF
      IF cl_null(l_faj.faj282) THEN LET l_faj.faj282 = ' ' END IF
      IF cl_null(l_faj.faj312) THEN LET l_faj.faj312 = 0 END IF
      IF cl_null(l_faj.faj142) THEN LET l_faj.faj142 = 0 END IF
      IF cl_null(l_faj.faj1412) THEN LET l_faj.faj1412 = 0 END IF
      IF cl_null(l_faj.faj332) THEN LET l_faj.faj332 = 0 END IF
      IF cl_null(l_faj.faj3312) THEN LET l_faj.faj3312 = 0 END IF
      IF cl_null(l_faj.faj322) THEN LET l_faj.faj322 = 0 END IF
      IF cl_null(l_faj.faj232) THEN LET l_faj.faj232 = ' ' END IF
      IF cl_null(l_faj.faj592) THEN LET l_faj.faj592 = 0 END IF
      IF cl_null(l_faj.faj602) THEN LET l_faj.faj602 = 0 END IF
      IF cl_null(l_faj.faj342) THEN LET l_faj.faj342 =' ' END IF
      IF cl_null(l_faj.faj352) THEN LET l_faj.faj352 = 0 END IF
      IF cl_null(l_faj.faj312) THEN LET l_faj.faj312 = 0 END IF
      IF cl_null(l_fbb.fbb082) THEN LET l_fbb.fbb082 = 0 END IF
      #FUN-AB0088---add---end---
     #CHI-C60010---str---
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj3312,g_azi04_1) RETURNING l_faj.faj3312
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
      CALL cl_digcut(l_fbb.fbb102,g_azi04_1) RETURNING l_fbb.fbb102
      CALL cl_digcut(l_fbb.fbb082,g_azi04_1) RETURNING l_fbb.fbb082
     #CHI-C60010---end---

      #-----No:FUN-B60140-----
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fap_file
       WHERE fap50  = l_fbb.fbb01
         AND fap501 = l_fbb.fbb02
         AND fap03  = '8'              ## 異動代號
      IF l_cnt = 0 THEN   #無fap_file資料
      INSERT INTO fap_file (fap01,fap02,fap021,fap03,fap04,fap05,fap06,fap07,
                            fap08,fap09,fap10,fap101,fap11,fap12,fap13,fap14,
                            fap15,fap16,fap17,fap18,fap19,fap20,fap201,fap21,
                            fap22,fap23,fap24,fap25,fap26,fap30,fap31,fap32,
                            fap33,fap34,fap341,fap35,fap36,fap37,fap38,fap39,
                            fap40,fap41,fap50,fap501,fap52,fap53,fap54,fap69,
                            fap70,fap71,fap77,
                            fap121,fap131,fap141,fap56,           #TQC-B30156 add fap56
                            #FUN-AB0088---add---str---
                            fap052,fap062,fap072,fap082,fap092,fap103, 
                            fap1012,fap112,fap152,fap162,fap212,fap222,
                            fap232,fap242,fap252,fap262,fap522,fap532,
                            fap542,fap772,   
                            #FUN-AB0088---add---end---
                            faplegal)     #No.FUN-680028 #FUN-980003 add
      VALUES (l_faj.faj01,l_fbb.fbb03,l_fbb.fbb031,'8',
              g_fba.fba02,l_faj.faj43,l_faj.faj28,l_faj.faj30,
              l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33+l_faj.faj331,  #MOD-970231
              l_faj.faj32,l_faj.faj53,l_faj.faj54,l_faj.faj55,
              l_faj.faj23,l_faj.faj24,l_faj.faj20,l_faj.faj19,
              l_faj.faj21,l_faj.faj17,l_faj.faj171,l_faj.faj58,
              l_faj.faj59,l_faj.faj60,l_faj.faj34,l_faj.faj35,
              l_faj.faj36,l_faj.faj61,l_faj.faj65,l_faj.faj66,
              l_faj.faj62,l_faj.faj63,l_faj.faj68,l_faj.faj67,
              l_faj.faj69,l_faj.faj70,l_faj.faj71,l_faj.faj72,
              l_faj.faj73,l_faj.faj100,l_fbb.fbb01,l_fbb.fbb02,
              l_fbb.fbb09,l_fbb.fbb10,l_fbb.fbb08,l_fbb.fbb18,
              l_fbb.fbb19,l_fbb.fbb17,'9',
              l_faj.faj531,l_faj.faj541,l_faj.faj551,0,      #TQC-B30156 add 0
              #FUN-AB0088---add---str---
              l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,l_faj.faj142,l_faj.faj1412,
              l_faj.faj332+l_faj.faj3312,l_faj.faj322,l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
              #l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,l_faj.faj302,l_faj.faj312,
              l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,l_fbb.fbb092,l_fbb.fbb102,  #No:FUN-B60140
              l_fbb.fbb082,'0',
              #FUN-AB0088---add---end--- 
              g_legal)     #No.FUN-680028 #FUN-980003 add
       ELSE
         UPDATE fap_file SET fap05 = l_faj.faj43,
                             fap06 = l_faj.faj28,
                             fap07 = l_faj.faj30,
                             fap08 = l_faj.faj31,
                             fap09 = l_faj.faj14,
                             fap10 = l_faj.faj141,
                             fap101= l_faj.faj33+l_faj.faj331,
                             fap11 = l_faj.faj32,
                             fap15 = l_faj.faj23,
                             fap16 = l_faj.faj24,
                             fap21 = l_faj.faj58,
                             fap22 = l_faj.faj59,
                             fap23 = l_faj.faj60,
                             fap24 = l_faj.faj34,
                             fap25 = l_faj.faj35,
                             fap26 = l_faj.faj36,
                             fap77 = '9',
                             fap52 = l_fbb.fbb09,
                             fap53 = l_fbb.fbb10,
                             fap54 = l_fbb.fbb08,
                             fap56 = 0
                       WHERE fap50  = l_fbb.fbb01
                         AND fap501 = l_fbb.fbb02
                         AND fap03='8'
      END IF
      #-----No:FUN-B60140 END-----
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbb.fbb03,"/",l_fbb.fbb031,"/",'8',"/",g_fba.fba02     #No.FUN-710028
         CALL s_errmsg('fap02,fap021,fap03,fap04',g_showmsg,'ins fap',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
 
      #--------- 過帳(3)update faj_file
      UPDATE faj_file set faj43  = '9',
                          faj141 = faj141+ l_fbb.fbb08,
                          faj33  = faj33 + l_fbb.fbb08,
                          faj30  = l_fbb.fbb09,
                          faj31  = l_fbb.fbb10,
                          faj63  = faj63 + l_fbb.fbb17,
                          faj68  = faj68 + l_fbb.fbb17,
                          faj65  = l_fbb.fbb18,
                          faj66  = l_fbb.fbb19,
                          faj100 = g_fba.fba02
         WHERE faj02=l_fbb.fbb03 AND faj022=l_fbb.fbb031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbb.fbb03,"/",l_fbb.fbb031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
      ##-----No:FUN-B60140 Mark-----
     ##FUN-AB0088---add---str---
     #IF g_faa.faa31 = 'Y' THEN 
     #   UPDATE faj_file SET faj432  = '9',
     #                        faj1412 = faj1412+ l_fbb.fbb082,
     #                        faj332  = faj332 + l_fbb.fbb082,
     #                        faj302  = l_fbb.fbb092,
     #                        faj312  = l_fbb.fbb102
     #     WHERE faj02=l_fbb.fbb03 AND faj022=l_fbb.fbb031
     #    IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
     #       LET g_showmsg = l_fbb.fbb03,"/",l_fbb.fbb031    
     #       CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)
     #       LET g_success = 'N'
     #    END IF
     #END IF
      #FUN-AB0088---add---end-----  
      ##-----No:FUN-B60140 Mark END-----   
   END FOREACH
   #--------- 過帳(1)update fbapost
   UPDATE fba_file SET fbapost = 'Y' WHERE fba01 = g_fba.fba01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('fba01',g_fba.fba01,'upd fbapost',STATUS,1)    #No.FUN-710028
      LET g_success = 'N'
   END IF
   CLOSE t106_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'N' THEN
      ROLLBACK WORK
       CALL cl_rbmsg(4)   #MOD-530473
   ELSE
      COMMIT WORK
      CALL cl_flow_notify(g_fba.fba01,'S')
       CALL cl_cmmsg(4)   #MOD-530473
   END IF
   SELECT fbapost INTO g_fba.fbapost FROM fba_file WHERE fba01 = g_fba.fba01   #MOD-530473
   DISPLAY BY NAME g_fba.fbapost   #MOD-530473
   IF g_fba.fbaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fba.fba08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_fba.fba01,'" AND npp011 = 1'
      LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_fba.fbauser,"' '",g_fba.fbauser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_fba.fba02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"   #No.FUN-680028   #MOD-860284#FUN-860040
      CALL cl_cmdrun_wait(g_str)
      SELECT fba06,fba07 INTO g_fba.fba06,g_fba.fba07 FROM fba_file
       WHERE fba01 = g_fba.fba01
      DISPLAY BY NAME g_fba.fba06
      DISPLAY BY NAME g_fba.fba07
   END IF
   CALL cl_set_field_pic(g_fba.fbaconf,g_chr2,g_fba.fbapost,"",g_chr,"")
END FUNCTION
 
FUNCTION t106_6()
   DEFINE l_fbb       RECORD LIKE fbb_file.*,
          l_faj       RECORD LIKE faj_file.*,
          l_bdate,l_edate   LIKE type_file.dat,          #No.FUN-680070 DATE
          l_faj63     LIKE faj_file.faj63,
          l_faj65     LIKE faj_file.faj65,
          l_faj66     LIKE faj_file.faj66,
          l_faj201    LIKE faj_file.faj201,
          l_faj68     LIKE faj_file.faj68,
          sql         LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(400)
          l_yy,l_mm   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          m_chr       LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
   DEFINE l_cnt       LIKE type_file.num5   #No:FUN-B60140  
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fba.fba01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fba.* FROM fba_fiel WHERE fba01 = g_fba.fba01
#   IF g_fba.fbaconf != 'Y' OR g_fba.fbapost != 'Y' OR g_fba.fbapost2 != 'N' THEN   #FUN-580109
   IF g_fba.fbaconf != 'Y' OR g_fba.fbapost2 != 'N' THEN   #FUN-580109  #No:FUN-B60140  
      CALL cl_err(g_fba.fba01,'afa-100',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa13 INTO g_faa.faa13 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #--->折舊年月判斷
   IF g_fba.fba02 < g_faa.faa13 THEN
      CALL cl_err(g_fba.fba02,'afa-308',0)
      RETURN
   END IF
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK
 
    OPEN t106_cl USING g_fba.fba01
    IF STATUS THEN
       CALL cl_err("OPEN t106_cl:", STATUS, 1)
       CLOSE t106_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t106_cl INTO g_fba.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fba.fba01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t106_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
 
   DECLARE t106_cur21 CURSOR FOR
      SELECT * FROM fbb_file WHERE fbb01=g_fba.fba01
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t106_cur21 INTO l_fbb.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('fbb01',g_fba.fba01,'foreach:',SQLCA.sqlcode,0)   #No.FUN-710028
         EXIT FOREACH
      END IF
       #-----No:FUN-B60140-----
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fbb.fbb03
                                            AND faj022=l_fbb.fbb031
     # SELECT faj63,faj65,faj66,faj68,faj201 INTO
     #       l_faj63,l_faj65,l_faj66,l_faj68,l_faj201 FROM faj_file
     #       WHERE faj02 = l_fbb.fbb03 AND faj022 = l_fbb.fbb031
     ##-----No:FUN-B60140 END----- 
      IF STATUS THEN
         LET g_showmsg = l_fbb.fbb03,"/",l_fbb.fbb031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
         CONTINUE FOREACH     #No.FUN-710028
      END IF
      #-----No:FUN-B60140-----
     #CHI-C60010---str---
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj3312,g_azi04_1) RETURNING l_faj.faj3312
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
      CALL cl_digcut(l_fbb.fbb102,g_azi04_1) RETURNING l_fbb.fbb102
      CALL cl_digcut(l_fbb.fbb082,g_azi04_1) RETURNING l_fbb.fbb082
     #CHI-C60010---end---
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fap_file
       WHERE fap50  = l_fbb.fbb01
         AND fap501 = l_fbb.fbb02
         AND fap03  = '8'              ## 異動代號
      IF l_cnt = 0 THEN   #無fap_file資料
         INSERT INTO fap_file (fap01,fap02,fap021,fap03,fap04,fap05,fap06,fap07,
                               fap08,fap09,fap10,fap101,fap11,fap12,fap13,fap14,
                               fap15,fap16,fap17,fap18,fap19,fap20,fap201,fap21,
                               fap22,fap23,fap24,fap25,fap26,fap30,fap31,fap32,
                               fap33,fap34,fap341,fap35,fap36,fap37,fap38,fap39,
                               fap40,fap41,fap50,fap501,fap52,fap53,fap54,fap69,
                               fap70,fap71,fap77,fap56,
                               fap121,fap131,fap141,
                               fap052,fap062,fap072,fap082,fap092,fap103,
                               fap1012,fap112,fap152,fap162,fap212,fap222,
                               fap232,fap242,fap252,fap262,fap522,fap532,
                               fap542,fap772,fap562,fap42,faplegal)
         VALUES (l_faj.faj01,l_fbb.fbb03,l_fbb.fbb031,'8',
                 g_fba.fba02,l_faj.faj43,l_faj.faj28,l_faj.faj30,
                 l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33+l_faj.faj331,
                 l_faj.faj32,l_faj.faj53,l_faj.faj54,l_faj.faj55,
                 l_faj.faj23,l_faj.faj24,l_faj.faj20,l_faj.faj19,
                 l_faj.faj21,l_faj.faj17,l_faj.faj171,l_faj.faj58,
                 l_faj.faj59,l_faj.faj60,l_faj.faj34,l_faj.faj35,
                 l_faj.faj36,l_faj.faj61,l_faj.faj65,l_faj.faj66,
                 l_faj.faj62,l_faj.faj63,l_faj.faj68,l_faj.faj67,
                 l_faj.faj69,l_faj.faj70,l_faj.faj71,l_faj.faj72,
                 l_faj.faj73,l_faj.faj100,l_fbb.fbb01,l_fbb.fbb02,
                 l_fbb.fbb09,l_fbb.fbb10,l_fbb.fbb08,l_fbb.fbb18,
                 l_fbb.fbb19,l_fbb.fbb17,'9',0,
                 l_faj.faj531,l_faj.faj541,l_faj.faj551
                ,l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,l_faj.faj142,l_faj.faj1412,
                 l_faj.faj332+l_faj.faj3312,l_faj.faj322,l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
                 l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,l_fbb.fbb092,l_fbb.fbb102,
                 l_fbb.fbb082, '0',0,l_faj.faj201,g_legal) #No:FUN-BA0112 fap562:'0'-->0 
      ELSE
         UPDATE fap_file SET fap71 = l_fbb.fbb17,           #稅簽調整成本
                             fap69 = l_fbb.fbb18,           #    未使用年限
                             fap70 = l_fbb.fbb19,           #    預留殘值
                          #  fap34 = l_faj63,               #稅簽調整成本  #No:FUN-B60140 #No:FUN-BA0112 mark
                          #  fap341= l_faj68,               #    未折減額  #No:FUN-B60140 #No:FUN-BA0112 mark
                          #  fap31 = l_faj65,               #    未使用年限 #No:FUN-B60140 #No:FUN-BA0112 mark
                          #  fap42 = l_faj201,               #No:FUN-B60140 #No:FUN-BA0112 mark
                          #  fap32 = l_faj66                #預留殘值 #No:FUN-B60140 #No:FUN-BA0112 mark
                             fap34 = l_faj.faj63,           #稅簽調整成本 #No:FUN-BA0112 add
                             fap341= l_faj.faj68,           #未折減額    #No:FUN-BA0112 add 
                             fap31 = l_faj.faj65,           #未使用年限  #No:FUN-BA0112 add
                             fap42 = l_faj.faj201,          #No:FUN-BA0112 add             
                             fap32 = l_faj.faj66            #預留殘值    #No:FUN-BA0112 add
                       WHERE fap50=l_fbb.fbb01 AND fap501=l_fbb.fbb02
                         AND fap03='8'
      END IF
     #-----No:FUN-B60140 END-----
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbb.fbb01,"/",l_fbb.fbb02,"/",'8'               #No.FUN-710028
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'upd fap',STATUS,1)  #No.FUN-710028
         LET g_success = 'N'
         CONTINUE FOREACH  #No.FUN-710028
      END IF
      UPDATE faj_file SET faj63 = faj63 + l_fbb.fbb17,   #稅簽調整成本
                          faj68 = faj68 + l_fbb.fbb17,   #    未折減額
                          faj201 = '9',
                          faj65 = l_fbb.fbb18,           #    未使用年限
                          faj66 = l_fbb.fbb19            #    預留殘值
                    WHERE faj02=l_fbb.fbb03 AND faj022=l_fbb.fbb031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbb.fbb03,"/",l_fbb.fbb031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
         CONTINUE FOREACH  #No.FUN-710028
      END IF
   END FOREACH
   #--------- 過帳(1)update fbapost
   UPDATE fba_file SET fbapost2 = 'Y' WHERE fba01 = g_fba.fba01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('fba01',g_fba.fba01,'upd fbapost2',STATUS,1)   #No.FUN-710028
      LET g_fba.fbapost2='N'
      LET g_success = 'N'
   ELSE
      LET g_fba.fbapost2='Y'
      LET g_success = 'Y'
      DISPLAY BY NAME g_fba.fbapost2 #
   END IF
   CLOSE t106_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
END FUNCTION
 
FUNCTION t106_w()
   DEFINE l_aba19     LIKE aba_file.aba19   #No.FUN-670060
   DEFINE l_sql       LIKE type_file.chr1000           #No.FUN-670060       #No.FUN-680070 VARCHAR(1000)
   DEFINE l_dbs       STRING                #No.FUN-670060
   DEFINE l_fbb    RECORD LIKE fbb_file.*,
          l_faj    RECORD LIKE faj_file.*,
          l_fap    RECORD LIKE fap_file.*,
          l_fap05  LIKE fap_file.fap05,
          l_fap10  LIKE fap_file.fap10,
          l_fap101 LIKE fap_file.fap101,
          l_fap07  LIKE fap_file.fap07,
          l_fap08  LIKE fap_file.fap08,
          l_fap34  LIKE fap_file.fap34,
          l_fap341 LIKE fap_file.fap341,
          l_fap31  LIKE fap_file.fap31,
          l_fap32  LIKE fap_file.fap32,
          l_fap41  LIKE fap_file.fap41,
          l_bdate,l_edate LIKE type_file.dat,          #No.FUN-680070 DATE
          l_cnt    LIKE type_file.num5   #TQC-780089

  #FUN-AB0088---add---str---
  DEFINE l_fap052 LIKE fap_file.fap052
  DEFINE l_fap103 LIKE fap_file.fap103   
  DEFINE l_fap1012 LIKE fap_file.fap1012
  DEFINE l_fap072  LIKE fap_file.fap072
  DEFINE l_fap082  LIKE fap_file.fap082
  DEFINE l_cnt1    LIKE type_file.num5
  #FUN-AB0088---add---end---
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fba.fba01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fba.* FROM fba_fiel WHERE fba01 = g_fba.fba01
   IF g_fba.fbapost != 'Y' THEN
      CALL cl_err(g_fba.fba01,'afa-108',0)
      RETURN
   END IF
   #-->已拋轉總帳, 不可取消還原
   IF NOT cl_null(g_fba.fba06) AND g_fah.fahglcr = 'N' THEN     #No.FUN-680028
      CALL cl_err(g_fba.fba06,'aap-145',1)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fba.fba02 < g_faa.faa09 THEN
      CALL cl_err(g_fba.fba01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-
   #--->折舊年月判斷
   #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
   #CHI-A60036 add --start--
   CALL s_get_bookno(g_faa.faa07)   
       RETURNING g_flag,g_bookno1,g_bookno2
   #FUN-AB0088---add---str---
   #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
   #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
   #FUN-AB0088---add---end--- 
#  IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
   IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088  
      CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
   ELSE
      CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
   END IF
   #CHI-A60036 add --end--
   IF g_fba.fba02 < l_bdate OR g_fba.fba02 > l_edate THEN
      CALL cl_err(g_fba.fba02,'afa-308',0)
      RETURN
   END IF
   DECLARE t106_cur4 CURSOR FOR
      SELECT * FROM fbb_file WHERE fbb01=g_fba.fba01
   FOREACH t106_cur4 INTO l_fbb.*
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fan_file
       WHERE fan01 = l_fbb.fbb03
         AND fan02 = l_fbb.fbb031
         AND ((fan03 = YEAR(g_fba.fba02) AND fan04 >= MONTH(g_fba.fba02))
          OR fan03 > YEAR(g_fba.fba02))
         AND fan041 = '1'   #MOD-C50044 add
     ###-----No:FUN-B60140 Mark-----
     ##FUN-AB0088---add---str---
     #LET l_cnt1 = 0
     #IF g_faa.faa31 = 'Y' THEN
     #   SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
     #    WHERE fbn01 = l_fbb.fbb03
     #      AND fbn02 = l_fbb.fbb031
     #      AND ((fbn03 = YEAR(g_fba.fba02) AND fbn04 >= MONTH(g_fba.fba02))
     #       OR fbn03 > YEAR(g_fba.fba02))
     #END IF
     #LET l_cnt = l_cnt + l_cnt1
     ##FUN-AB0088---add---end---
     ###-----No:FUN-B60140 Mark END-----
      IF l_cnt > 0 THEN
         CALL cl_err(l_fbb.fbb03,'afa-348',0)
         RETURN
      END IF
   END FOREACH
 
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_fba.fba01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
   IF NOT cl_null(g_fba.fba06) THEN
      IF NOT (g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y') THEN
         CALL cl_err(g_fba.fba01,'axr-370',0) RETURN
      END IF
   END IF
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
     #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",  #FUN-A50102
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102 
                  "  WHERE aba00 = '",g_faa.faa02b,"'",
                  "    AND aba01 = '",g_fba.fba06,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
      PREPARE aba_pre1 FROM l_sql
      DECLARE aba_cs1 CURSOR FOR aba_pre1
      OPEN aba_cs1
      FETCH aba_cs1 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_fba.fba06,'axr-071',1)
         RETURN
      END IF
 
   END IF
   IF NOT cl_sure(18,20) THEN RETURN END IF
  #----------------------------------CHI-C90051-----------------------(S)
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fba.fba06,"' '8' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT fba06,fba07 INTO g_fba.fba06,g_fba.fba07 FROM fba_file
       WHERE fba01 = g_fba.fba01
      DISPLAY BY NAME g_fba.fba06
      DISPLAY BY NAME g_fba.fba07
      IF NOT cl_null(g_fba.fba06) THEN
         CALL cl_err('','aap-929',0)
         RETURN
      END IF
   END IF
  #----------------------------------CHI-C90051-----------------------(E)
  BEGIN WORK
 
    OPEN t106_cl USING g_fba.fba01
    IF STATUS THEN
       CALL cl_err("OPEN t106_cl:", STATUS, 1)
       CLOSE t106_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t106_cl INTO g_fba.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fba.fba01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t106_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
   #--------- 還原過帳(1)update fba_file
   UPDATE fba_file SET fbapost = 'N' WHERE fba01 = g_fba.fba01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","fba_file",g_fba.fba01,"",SQLCA.sqlcode,"","upd fbapost",1)  #No.FUN-660136
      LET g_fba.fbapost='Y'
      LET g_success = 'N'
   ELSE
      LET g_fba.fbapost='N'
      LET g_success = 'Y'
      DISPLAY BY NAME g_fba.fbapost #
   END IF
 
   #--------- 還原過帳(2)update faj_file
   DECLARE t106_cur3 CURSOR FOR
      SELECT * FROM fbb_file WHERE fbb01=g_fba.fba01
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t106_cur3 INTO l_fbb.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('fbb01',g_fba.fba01,'foreach:',SQLCA.sqlcode,0)  #No.FUN-710028
         EXIT FOREACH
      END IF
      #----- 找出 faj_file 中對應之財產編號+附號
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fbb.fbb03
                                            AND faj022=l_fbb.fbb031
      IF STATUS THEN
         CALL cl_err('sel faj',STATUS,0)
         LET g_showmsg = l_fbb.fbb03,"/",l_fbb.fbb031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)   #No.FUN-710028
         LET g_success='N'
      END IF
      #----- 找出 fap_file 之 fap05 以便 update faj_file.faj43
      SELECT fap05,fap10,fap101,fap07,fap08,fap34,fap341,fap31,fap32,fap41
        INTO l_fap05,l_fap10,l_fap101,l_fap07,l_fap08,l_fap34,l_fap341,l_fap31,
             l_fap32,l_fap41
        FROM fap_file
       WHERE fap50=l_fbb.fbb01
         AND fap501=l_fbb.fbb02
         AND fap03='8'    ## 異動代號
      IF STATUS THEN #No.7926
         LET g_showmsg = l_fbb.fbb01,"/",l_fbb.fbb02,"/",'7'               #No.FUN-710028
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'sel fap',STATUS,1)  #No.FUN-710028
         LET g_success = 'N'
      END IF
     
      UPDATE faj_file set faj43  = l_fap05,
                          faj141 = l_fap10,
                          faj33  = l_fap101,
                          faj30  = l_fap07,
                          faj31  = l_fap08,
                          faj63  = l_fap34,
                          faj68  = l_fap341,
                          faj65  = l_fap31,
                          faj66  = l_fap32,
                          faj100 = l_fap41
         WHERE faj02=l_fbb.fbb03 AND faj022=l_fbb.fbb031
      IF STATUS  THEN
         LET g_showmsg = l_fbb.fbb03,"/",l_fbb.fbb031                  #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg ,'upd faj',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
     ##-----No:FUN-B60140 Mark-----
     ##FUN-AB0088---add---str---
     #IF g_faa.faa31 = 'Y' THEN
     #   SELECT fap052,fap103,fap1012,fap072,fap082   #No:FUN-B30036
     #      INTO l_fap052,l_fap103,l_fap1012,l_fap072,l_fap082   #No:FUN-B30036
     #      FROM fap_file
     #     WHERE fap50=l_fbb.fbb01
     #       AND fap501=l_fbb.fbb02
     #       AND fap03='8'
     #    IF STATUS THEN 
     #       LET g_showmsg = l_fbb.fbb01,"/",l_fbb.fbb02,"/",'7'               
     #       CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'sel fap',STATUS,1) 
     #       LET g_success = 'N'
     #    END IF
     #    UPDATE faj_file set faj432  = l_fap052,
     #                       #faj1412 = l_fap102,
     #                        faj1412 = l_fap103,   #No:FUN-B30036
     #                        faj332  = l_fap1012,
     #                        faj302  = l_fap072,
     #                        faj312  = l_fap082
     #       WHERE faj02=l_fbb.fbb03 AND faj022=l_fbb.fbb031
     #    IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
     #       LET g_showmsg = l_fbb.fbb03,"/",l_fbb.fbb031                 
     #       CALL s_errmsg('faj02,faj022',g_showmsg ,'upd faj',STATUS,1) 
     #       LET g_success = 'N'
     #    END IF
     #END IF
     ##FUN-AB0088---add---end---
     ##-----No:FUN-B60140 Mark-----
      #--------- 還原過帳(3)delete fap_file
      #財二與稅簽皆未過帳時，才可刪fap_file
      IF g_fba.fbapost1<>'Y' AND g_fba.fbapost2<>'Y' THEN   #No:FUN-B60140
         DELETE FROM fap_file WHERE fap50=l_fbb.fbb01
                                AND fap501=l_fbb.fbb02
                               AND fap03 = '8'
         IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
            LET g_showmsg = l_fbb.fbb01,"/",l_fbb.fbb02,"/",'8'                #No.FUN-710028
            CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'del fap',STATUS,1)   #No.FUN-710028
            LET g_success = 'N'
         END IF
      END IF  #No:FUN-B60140 
  END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   CLOSE t106_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
   IF g_fba.fbaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fba.fba08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  #----------------------------------CHI-C90051-----------------------mark
  #IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
  #   LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fba.fba06,"' '8' 'Y'"
  #   CALL cl_cmdrun_wait(g_str)
  #   SELECT fba06,fba07 INTO g_fba.fba06,g_fba.fba07 FROM fba_file
  #    WHERE fba01 = g_fba.fba01
  #   DISPLAY BY NAME g_fba.fba06
  #   DISPLAY BY NAME g_fba.fba07
  #END IF
  #----------------------------------CHI-C90051-----------------------mark
   CALL cl_set_field_pic(g_fba.fbaconf,g_chr2,g_fba.fbapost,"",g_chr,"")
END FUNCTION
 
FUNCTION t106_7()
   DEFINE l_fbb    RECORD LIKE fbb_file.*,
          l_fap34  LIKE fap_file.fap34,
          l_fap341 LIKE fap_file.fap341,
          l_fap31  LIKE fap_file.fap31,
          l_fap32  LIKE fap_file.fap32,
          l_fap42  LIKE fap_file.fap42,
          l_bdate,l_edate   LIKE type_file.dat,          #No.FUN-680070 DATE
          l_yy,l_mm         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_cnt             LIKE type_file.num5          #TQC-780089
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fba.fba01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fba.* FROM fba_fiel WHERE fba01 = g_fba.fba01
   IF g_fba.fbapost2 != 'Y' THEN
      CALL cl_err(g_fba.fba01,'afa-108',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa13 INTO g_faa.faa13 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #--->折舊年月判斷
   IF g_fba.fba02 < g_faa.faa13 THEN
      CALL cl_err(g_fba.fba02,'afa-308',0)
      RETURN
   END IF
   DECLARE t106_cur5 CURSOR FOR
      SELECT * FROM fbb_file WHERE fbb01=g_fba.fba01
   FOREACH t106_cur5 INTO l_fbb.*
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fao_file
       WHERE fao01 = l_fbb.fbb03
         AND fao02 = l_fbb.fbb031
         AND ((fao03 = YEAR(g_fba.fba02) AND fao04 >= MONTH(g_fba.fba02))
          OR fao03 > YEAR(g_fba.fba02))
         AND fao041 = '1'   #MOD-C50044 add
      IF l_cnt > 0 THEN
         CALL cl_err(l_fbb.fbb03,'afa-348',0)
         RETURN
      END IF
   END FOREACH
   IF NOT cl_sure(18,20) THEN RETURN END IF
  BEGIN WORK
 
    OPEN t106_cl USING g_fba.fba01
    IF STATUS THEN
       CALL cl_err("OPEN t106_cl:", STATUS, 1)
       CLOSE t106_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t106_cl INTO g_fba.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fba.fba01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t106_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
 
   DECLARE t106_cur31 CURSOR FOR
      SELECT * FROM fbb_file WHERE fbb01=g_fba.fba01
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t106_cur31 INTO l_fbb.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('fbb01',g_fba.fba01,'foreach:',SQLCA.sqlcode,0)   #No.FUN-710028
         EXIT FOREACH
      END IF
      SELECT fap34,fap341,fap31,fap32,fap42
        INTO l_fap34,l_fap341,l_fap31,l_fap32,l_fap42
        FROM fap_file
       WHERE fap50=l_fbb.fbb01
         AND fap501=l_fbb.fbb02
         AND fap03='8'    ## 異動代號
      IF STATUS THEN #No.7926
         LET g_showmsg = l_fbb.fbb01,"/",l_fbb.fbb02,"/",'8'               #No.FUN-710028
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'sel fap',STATUS,1)  #No.FUN-710028
         LET g_success = 'N'
      END IF
      #--->(1.1)更新資產主檔
      UPDATE faj_file SET faj63  = l_fap34,               #稅簽調整成本
                          faj68  = l_fap341,              #    未折減額
                          faj201 = l_fap42,
                          faj65  = l_fap31,               #    未使用年限
                          faj66  = l_fap32                #    預留殘值
         WHERE faj02=l_fbb.fbb03 AND faj022=l_fbb.fbb031
      IF STATUS  THEN
         LET g_showmsg = l_fbb.fbb03,"/",l_fbb.fbb031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'del fap',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   #--------- 還原過帳(1)update fba_file
   UPDATE fba_file SET fbapost2 = 'N' WHERE fba01 = g_fba.fba01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('fba01',g_fba.fba01,'upd fbapost2',STATUS,1)   #No.FUN-710028
      LET g_fba.fbapost2='Y'
      LET g_success = 'N'
   ELSE
      LET g_fba.fbapost2='N'
      LET g_success = 'Y'
      DISPLAY BY NAME g_fba.fbapost2 #
   END IF
   
   #-----No:FUN-B60140-----
   #--------- 還原過帳(3)delete fap_file
   #財一與財二皆未過帳時，才可刪fap_file
   IF g_fba.fbapost <>'Y' AND g_fba.fbapost1<>'Y' THEN
      DELETE FROM fap_file WHERE fap50=l_fbb.fbb01
                             AND fap501=l_fbb.fbb02
                             AND fap03 = '8'
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbb.fbb01,"/",l_fbb.fbb02,"/",'8'
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'del fap',STATUS,1)
         LET g_success = 'N'
      END IF
   END IF
   #-----No:FUN-B60140 END-----
   CLOSE t106_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
END FUNCTION
 
FUNCTION t106_e(p_cmd)         #維護稅簽資料
DEFINE   p_cmd       LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE ls_tmp STRING
 
   LET p_row = 8  LET p_col = 15
   OPEN WINDOW t106_e1 AT p_row,p_col WITH FORM "afa/42f/afat1061"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afat1061")
 
 
   IF p_cmd = 'u' THEN
      SELECT fbb13,fbb14,fbb15,fbb17,fbb18,fbb19
        INTO g_e[l_ac].fbb13,g_e[l_ac].fbb14,g_e[l_ac].fbb15,
             g_e[l_ac].fbb17,g_e[l_ac].fbb18,g_e[l_ac].fbb19
        FROM fbb_file
       WHERE fbb01 = g_fba.fba01
         AND fbb02 = g_fbb[l_ac].fbb02
      IF STATUS = 100 THEN
         LET g_e[l_ac].fbb13 = 0   LET g_e[l_ac].fbb14 = 0
         LET g_e[l_ac].fbb15 = 0
         LET g_e[l_ac].fbb17 = 0   LET g_e[l_ac].fbb18 = 0
         LET g_e[l_ac].fbb19 = 0
      END IF
   END IF
   DISPLAY g_e[l_ac].fbb13 TO fbb13 #
   DISPLAY g_e[l_ac].fbb14 TO fbb14 #
   DISPLAY g_e[l_ac].fbb15 TO fbb15 #
   DISPLAY g_e[l_ac].fbb17 TO fbb17 #
   DISPLAY g_e[l_ac].fbb18 TO fbb18 #
   DISPLAY g_e[l_ac].fbb19 TO fbb19 #
   INPUT g_e[l_ac].fbb17,g_e[l_ac].fbb18,g_e[l_ac].fbb19
          WITHOUT DEFAULTS
    FROM fbb17,fbb18,fbb19
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t106_e1 RETURN END IF
   IF p_cmd = 'u' THEN
       UPDATE fbb_file SET
                     fbb13=g_e[l_ac].fbb13,fbb14=g_e[l_ac].fbb14,
                     fbb15=g_e[l_ac].fbb15,fbb17=g_e[l_ac].fbb17,
                     fbb18=g_e[l_ac].fbb18,fbb19=g_e[l_ac].fbb19
       WHERE fbb01 = g_fba.fba01
         AND fbb02 = g_fbb[l_ac].fbb02
   END IF
   CLOSE WINDOW t106_e1
END FUNCTION
 
#FUNCTION t106_x()                       #FUN-D20035
FUNCTION t106_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_fba.* FROM fba_file WHERE fba01=g_fba.fba01
   IF g_fba.fba08 MATCHES '[Ss1]' THEN
      CALL cl_err("","mfg3557",0) RETURN
   END IF
   IF g_fba.fba01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fba.fbaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF

   #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_fba.fbaconf='X' THEN RETURN END IF
   ELSE
      IF g_fba.fbaconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end
   BEGIN WORK
   LET g_success='Y'
 
   OPEN t106_cl USING g_fba.fba01
   IF STATUS THEN
      CALL cl_err("OPEN t106_cl:", STATUS, 1)
      CLOSE t106_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t106_cl INTO g_fba.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fba.fba01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t106_cl ROLLBACK WORK RETURN
   END IF
  #-->作廢轉換01/08/01
 #IF cl_void(0,0,g_fba.fbaconf)   THEN                                 #FUN-D20035
  IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF     #FUN-D20035
  IF cl_void(0,0,l_flag) THEN                                          #FUN-D20035
    LET g_chr=g_fba.fbaconf
   #IF g_fba.fbaconf ='N' THEN                                         #FUN-D20035
    IF p_type = 1 THEN                                                 #FUN-D20035
       LET g_fba.fbaconf='X'
       LET g_fba.fba08='9'   #FUN-580109
    ELSE
       LET g_fba.fbaconf='N'
       LET g_fba.fba08='0'   #FUN-580109
    END IF
 
    UPDATE fba_file SET fbaconf =g_fba.fbaconf,
                        fba08   =g_fba.fba08,   #FUN-580109
                        fbamodu =g_user,
                        fbadate =TODAY
           WHERE fba01 = g_fba.fba01
    IF STATUS THEN CALL cl_err('upd fbaconf:',STATUS,1) LET g_success='N' END IF
    IF g_success='Y' THEN
       COMMIT WORK
       IF g_fba.fbaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
       IF g_fba.fba08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
       CALL cl_set_field_pic(g_fba.fbaconf,g_chr2,g_fba.fbapost,"",g_chr,"")
       CALL cl_flow_notify(g_fba.fba01,'V')
    ELSE
       ROLLBACK WORK
    END IF
    SELECT fbaconf,fba08 INTO g_fba.fbaconf,g_fba.fba08   #FUN-580109
      FROM fba_file
     WHERE fba01 = g_fba.fba01
    DISPLAY BY NAME g_fba.fbaconf
    DISPLAY BY NAME g_fba.fba08   #FUN-580109
  END IF
END FUNCTION
FUNCTION t106_fba09(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_gen02    LIKE gen_file.gen02,
       l_gen03    LIKE gen_file.gen03,             #No:7381
       l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti    #No:7381
      FROM gen_file
     WHERE gen01 = g_fba.fba09
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312'
                                LET l_gen02 = NULL
                                LET l_genacti = NULL
       WHEN l_genacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
END FUNCTION
 
FUNCTION t106_gen_glcr(p_fba,p_fah)
  DEFINE p_fba     RECORD LIKE fba_file.*
  DEFINE p_fah     RECORD LIKE fah_file.*
 
    IF cl_null(p_fah.fahgslp) THEN
       CALL cl_err(p_fba.fba01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL s_showmsg_init()    #No.FUN-710028
    IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 add
       CALL t106_gl(g_fba.fba01,g_fba.fba02,'0')
    END IF #FUN-C30313 add
#   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 mark
    IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088  add
       IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 add
          CALL t106_gl(g_fba.fba01,g_fba.fba02,'1')
       END IF #FUN-C30313 add
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t106_carry_voucher()
  DEFINE l_fahgslp    LIKE fah_file.fahgslp
  DEFINE li_result    LIKE type_file.num5          #No.FUN-680070 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF NOT cl_null(g_fba.fba06)  THEN
       CALL cl_err(g_fba.fba06,'aap-618',1)
       RETURN
    END IF
   #FUN-B90004---End---

    CALL s_get_doc_no(g_fba.fba01) RETURNING g_t1
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
    IF g_fah.fahdmy3 = 'N' THEN RETURN END IF
   #IF g_fah.fahglcr = 'Y' THEN               #FUN-B90004
    IF g_fah.fahglcr = 'Y' OR ( g_fah.fahglcr = 'N' AND NOT cl_null(g_fah.fahgslp)) THEN   #FUN-B90004
       LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
      #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",   #FUN-A50102
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                   "  WHERE aba00 = '",g_faa.faa02b,"'",
                   "    AND aba01 = '",g_fba.fba06,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   #FUN-A50102
       PREPARE aba_pre2 FROM l_sql
       DECLARE aba_cs2 CURSOR FOR aba_pre2
       OPEN aba_cs2
       FETCH aba_cs2 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_fba.fba06,'aap-991',1)
          RETURN
       END IF
 
       LET l_fahgslp = g_fah.fahgslp
    ELSE
      #CALL cl_err('','aap-992',1)   #FUN-B90004 mark
       CALL cl_err('','aap-936',1)   #FUN-B90004
       RETURN

    END IF
    IF cl_null(l_fahgslp) THEN
       CALL cl_err(g_fba.fba01,'axr-070',1)
       RETURN
    END IF
   #IF g_aza.aza63 = 'Y' THEN   #FUN-AB008 mark
   ##-----No:FUN-B60140 Mark-----
   #IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088  add
   #   IF cl_null(g_fah.fahgslp1) THEN
   #      CALL cl_err(g_fba.fba01,'axr-070',1)
   #      RETURN
   #   END IF
   #END IF
    ##-----No:FUN-B60140 Mark END-----
    LET g_wc_gl = 'npp01 = "',g_fba.fba01,'" AND npp011 = 1'
    LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_fba.fbauser,"' '",g_fba.fbauser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_fba.fba02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"   #No.FUN-680028   #MOD-860284#FUN-860040
    CALL cl_cmdrun_wait(g_str)
    SELECT fba06,fba07 INTO g_fba.fba06,g_fba.fba07 FROM fba_file
     WHERE fba01 = g_fba.fba01
    DISPLAY BY NAME g_fba.fba06
    DISPLAY BY NAME g_fba.fba07
    
END FUNCTION
 
FUNCTION t106_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF cl_null(g_fba.fba06)  THEN
       CALL cl_err(g_fba.fba06,'aap-619',1)
       RETURN
    END IF
   #FUN-B90004---End---
 
    CALL s_get_doc_no(g_fba.fba01) RETURNING g_t1
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
   #IF g_fah.fahglcr = 'N' THEN     #FUN-B90004 mark
   #   CALL cl_err('','aap-990',1)  #FUN-B90004 mark
    IF g_fah.fahglcr = 'N' AND cl_null(g_fah.fahgslp) THEN    #FUN-B90004
       CALL cl_err('','aap-936',1)  #FUN-B90004
       RETURN
    END IF
    LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",   #FUN-A50102
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102 
                "  WHERE aba00 = '",g_faa.faa02b,"'",
                "    AND aba01 = '",g_fba.fba06,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_fba.fba06,'axr-071',1)
       RETURN
    END IF
 
    LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fba.fba06,"' '8' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT fba06,fba07 INTO g_fba.fba06,g_fba.fba07 FROM fba_file
     WHERE fba01 = g_fba.fba01
    DISPLAY BY NAME g_fba.fba06
    DISPLAY BY NAME g_fba.fba07
END FUNCTION

#FUN-AB0088---add---str---
FUNCTION t106_fin_audit2()
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_rec_b2   LIKE type_file.num5
   DEFINE l_faj28    LIKE faj_file.faj28 
   DEFINE l_fbb102   LIKE fbb_file.fbb102
   DEFINE l_faj332   LIKE faj_file.faj332
   DEFINE l_faj3312  LIKE faj_file.faj3312
   DEFINE l_faj302   LIKE faj_file.faj302
   DEFINE l_faj312   LIKE faj_file.faj312
   DEFINE l_fab232   LIKE fab_file.fab232

   #FUN-C30140---add---str---
   IF g_fba.fba01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF NOT cl_null(g_fba.fba08) AND g_fba.fba08 matches '[Ss]' THEN     
       CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
       RETURN
   END IF 
   #FUN-C30140---add---end---

   OPEN WINDOW t1069_w2 WITH FORM "afa/42f/afat1069"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("afat1069")

   #FUN-BC0004--mark--str
   #LET g_sql =
   #    "SELECT fbb02,fbb03,faj06,fbb031,fbb042,fbb082,fbb052,fbb092,fbb062,fbb102,fbb12",
   #    "  FROM fbb_file,OUTER faj_file ",
   #    " WHERE fbb01  ='",g_fba.fba01,"'",  #虫繷
   #    "   AND fbb03  = faj02",
   #    "   AND fbb031 = faj022",
   #    " ORDER BY 1"
   #FUN-BC0004--mark--end
   #FUN-BC0004--add-str
   LET g_sql =
        "SELECT fbb02,fbb03,'',fbb031,fbb042,fbb082,fbb052,fbb092,fbb062,fbb102,fbb12",
        "  FROM fbb_file ",
        " WHERE fbb01  ='",g_fba.fba01,"'",  #單頭
        " ORDER BY 1"
   #FUN-BC0004--add--end

   PREPARE afat106_2_pre FROM g_sql

   DECLARE afat106_2_c CURSOR FOR afat106_2_pre

   CALL g_fbb2.clear()

   LET l_cnt = 1

   FOREACH afat106_2_c INTO g_fbb2[l_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach fbb2',STATUS,0)
         EXIT FOREACH
      END IF

      #FUN-BC0004--add--str
      SELECT faj06 INTO g_fbb2[l_cnt].faj06
        FROM faj_file
       WHERE faj02 = g_fbb2[l_cnt].fbb03
         AND faj022 = g_fbb2[l_cnt].fbb031
      #FUN-BC0004--add--end
      LET l_cnt = l_cnt + 1

   END FOREACH

   CALL g_fbb2.deleteElement(l_cnt)

   LET l_rec_b2 = l_cnt - 1
   DISPLAY l_rec_b2 TO FORMONLY.cn2
   LET l_ac = 1

   CALL cl_set_act_visible("cancel", FALSE)

   IF g_fba.fbaconf !="N" THEN   #已確認或作廢的單據只能查詢
      DISPLAY ARRAY g_fbb2 TO s_fbb2.* ATTRIBUTE(COUNT=l_rec_b2,UNBUFFERED)

         ON ACTION CONTROLG
            CALL cl_cmdask()
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
         
         ON ACTION about
            CALL cl_about()
         
         ON ACTION help
            CALL cl_show_help()

      END DISPLAY
   ELSE
    LET g_forupd_sql = " SELECT fbb02,fbb03,' ',fbb031,fbb042,fbb082,fbb052,fbb092,fbb062,fbb102,fbb12",
                       " FROM fbb_file   ",
                       " WHERE fbb01 = ? " ,
                       " AND fbb02 = ? ",
                       " FOR UPDATE "

      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)   #FUN-AB0088 add
      DECLARE t106_2_bcl CURSOR FROM g_forupd_sql 
       
      INPUT ARRAY g_fbb2 WITHOUT DEFAULTS FROM s_fbb2.*
            ATTRIBUTE(COUNT=l_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
      
         BEFORE INPUT     
            IF l_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            
         BEFORE ROW            
            LET l_ac = ARR_CURR()
            BEGIN WORK
            IF l_rec_b2 >= l_ac THEN 
               LET g_fbb2_t.* = g_fbb2[l_ac].* 
               OPEN t106_2_bcl USING g_fba.fba01,g_fbb2_t.fbb02
               IF STATUS THEN
                  CALL cl_err("OPEN t106_2_bcl:", STATUS, 1)
               ELSE
                  FETCH t106_2_bcl INTO g_fbb2[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_fbb2_t.fbb02,SQLCA.sqlcode,1)
                  ELSE
                      SELECT faj06 #,faj33,faj331,faj30,faj312 No:FUN-BB0122 mark
                        INTO g_fbb2[l_ac].faj06 #,l_faj332,l_faj3312,l_faj302,l_faj312 No:FUN-BB0122 mark
                        FROM faj_file
                       WHERE faj02  = g_fbb2[l_ac].fbb03
                         AND faj022 = g_fbb2[l_ac].fbb031
                         #AND faj43  NOT MATCHES '[056X]' No:FUN-BB0122 mark
                         #AND fajconf = 'Y' No:FUN-BB0122 mark
                      DISPLAY BY NAME g_fbb2[l_ac].faj06
           	      ##-----No:FUN-BB0122-----being mark													
                      #IF cl_null(g_fbb2[l_ac].fbb042) OR g_fbb2[l_ac].fbb042 = 0 THEN
                      #    LET g_fbb2[l_ac].fbb042 = l_faj332+l_faj3312 
                      #END IF
                      #IF cl_null(g_fbb2[l_ac].fbb052) OR g_fbb2[l_ac].fbb052 = 0 THEN
                      #    LET g_fbb2[l_ac].fbb052 = l_faj302
                      #END IF
                      #IF cl_null(g_fbb2[l_ac].fbb062) OR g_fbb2[l_ac].fbb062 = 0 THEN
                      #    LET g_fbb2[l_ac].fbb062 = l_faj312
                      #END IF
                      #LET g_fbb2[l_ac].fbb092 = g_fbb2[l_ac].fbb052
                      #LET g_fbb2[l_ac].fbb102 = g_fbb2[l_ac].fbb062
                      #DISPLAY BY NAME g_fbb2[l_ac].fbb042
                      #DISPLAY BY NAME g_fbb2[l_ac].fbb052
                      #DISPLAY BY NAME g_fbb2[l_ac].fbb062
                      #DISPLAY BY NAME g_fbb2[l_ac].fbb092
                      #DISPLAY BY NAME g_fbb2[l_ac].fbb102
	              ##-----No:FUN-BB0122-----end mark
                  END IF
               END IF
            END IF
        #FUN-BC0004--add-str
        BEFORE FIELD fbb042
           SELECT faj06,faj33,faj331,faj30,faj312
             INTO g_fbb2[l_ac].faj06,l_faj332,l_faj3312,l_faj302,l_faj312
             FROM faj_file
            WHERE faj02  = g_fbb2[l_ac].fbb03
              AND faj022 = g_fbb2[l_ac].fbb031
              AND faj43  NOT MATCHES '[056X]'
              AND fajconf = 'Y'
           DISPLAY BY NAME g_fbb2[l_ac].faj06
           IF cl_null(g_fbb2[l_ac].fbb042) OR g_fbb2[l_ac].fbb042 = 0 THEN
              LET g_fbb2[l_ac].fbb042 = l_faj332+l_faj3312 
           END IF
           IF cl_null(g_fbb2[l_ac].fbb052) OR g_fbb2[l_ac].fbb052 = 0 THEN
              LET g_fbb2[l_ac].fbb052 = l_faj302
           END IF
           IF cl_null(g_fbb2[l_ac].fbb062) OR g_fbb2[l_ac].fbb062 = 0 THEN
              LET g_fbb2[l_ac].fbb062 = l_faj312
           END IF
           LET g_fbb2[l_ac].fbb092 = g_fbb2[l_ac].fbb052
           LET g_fbb2[l_ac].fbb102 = g_fbb2[l_ac].fbb062
           DISPLAY BY NAME g_fbb2[l_ac].fbb042
           DISPLAY BY NAME g_fbb2[l_ac].fbb052
           DISPLAY BY NAME g_fbb2[l_ac].fbb062
           DISPLAY BY NAME g_fbb2[l_ac].fbb092
           DISPLAY BY NAME g_fbb2[l_ac].fbb102
        #FUN-BC0004--add-end
        AFTER FIELD fbb082
           IF g_fbb2[l_ac].fbb082<0 THEN
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbb082
           END IF
           CALL cl_digcut(g_fbb2[l_ac].fbb082,g_azi04_1) RETURNING g_fbb2[l_ac].fbb082  #CHI-C60010
         
        AFTER FIELD fbb102
           IF g_fbb2[l_ac].fbb102<0 THEN
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbb102
           END IF
           CALL cl_digcut(g_fbb2[l_ac].fbb102,g_azi04_1) RETURNING g_fbb2[l_ac].fbb102  #CHI-C60010           

        AFTER FIELD fbb092
           IF g_aza.aza26 = '2' THEN
              SELECT UNIQUE(fab232) INTO l_fab232 FROM fab_file,faj_file
              WHERE fab01  = faj04
                AND faj02  = g_fbb2[l_ac].fbb03
                AND faj022 = g_fbb2[l_ac].fbb031
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","fab_file,faj_file",g_fbb2[l_ac].fbb03,g_fbb2[l_ac].fbb031,SQLCA.sqlcode,"","",1)  
                 LET g_success = 'N' RETURN
              END IF
              IF g_faj28 MATCHES '[05]' THEN
                 LET l_fbb102 = 0
              ELSE
                 LET l_fbb102 = (g_fbb2[l_ac].fbb042 + g_fbb2[l_ac].fbb082)*
                               l_fab232/100
              END IF
              LET g_fbb2[l_ac].fbb102 = l_fbb102
              CALL cl_digcut(g_fbb2[l_ac].fbb102,g_azi04_1) RETURNING g_fbb2[l_ac].fbb102  #CHI-C60010
              DISPLAY BY NAME g_fbb2[l_ac].fbb102
           ELSE
              CASE g_faj28
                WHEN '1' LET l_fbb102 = (g_fbb2[l_ac].fbb042 + g_fbb2[l_ac].fbb082)
                                      /(g_fbb2[l_ac].fbb092 + 12)*12
                         LET g_fbb2[l_ac].fbb102 = l_fbb102
                         CALL cl_digcut(g_fbb2[l_ac].fbb102,g_azi04_1) RETURNING g_fbb2[l_ac].fbb102  #CHI-C60010
                         DISPLAY BY NAME g_fbb2[l_ac].fbb102
                OTHERWISE EXIT CASE
              END CASE
           END IF
           IF g_fbb2[l_ac].fbb092<0 THEN
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbb092
           END IF
         
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fbb2[l_ac].* = g_fbb2_t.*
               CLOSE t106_2_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
        

           #CHI-C60010---str---
            CALL cl_digcut(g_fbb2[l_ac].fbb042,g_azi04_1) RETURNING g_fbb2[l_ac].fbb042
            CALL cl_digcut(g_fbb2[l_ac].fbb062,g_azi04_1) RETURNING g_fbb2[l_ac].fbb062
            CALL cl_digcut(g_fbb2[l_ac].fbb082,g_azi04_1) RETURNING g_fbb2[l_ac].fbb082
            CALL cl_digcut(g_fbb2[l_ac].fbb102,g_azi04_1) RETURNING g_fbb2[l_ac].fbb102
           #CHI-C60010---end---
           UPDATE fbb_file SET fbb042 = g_fbb2[l_ac].fbb042,
                               fbb082 = g_fbb2[l_ac].fbb082,
                               fbb052 = g_fbb2[l_ac].fbb052,
                               fbb062 = g_fbb2[l_ac].fbb062,
                               fbb092 = g_fbb2[l_ac].fbb092,
                               fbb102 = g_fbb2[l_ac].fbb102
             WHERE fbb01 = g_fba.fba01
               AND fbb02 = g_fbb2_t.fbb02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","fbb_file",g_fba.fba01,g_fbb2_t.fbb02,SQLCA.sqlcode,"","",1)  
               LET g_fbb2[l_ac].* = g_fbb2_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF

         AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fbb2[l_ac].* = g_fbb2_t.*
               CLOSE t106_2_bcl 
               ROLLBACK WORK 
               EXIT INPUT
            END IF
            CLOSE t106_2_bcl 
            COMMIT WORK

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()    
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
         ON ACTION controlg 
            CALL cl_cmdask()
      
         ON ACTION about 
            CALL cl_about()
      
         ON ACTION help
            CALL cl_show_help()
      
         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
      
         ON ACTION CONTROLR 
            CALL cl_show_req_fields() 
      
         ON ACTION exit
            EXIT INPUT
      
      END INPUT
      
   END IF
 
   CLOSE WINDOW t1069_w2

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

END FUNCTION
#FUN-AB0088---add---end---
#No.FUN-9C0077 程式精簡

#-----No:FUN-B60140-----
#----過帳--------
FUNCTION t106_s2()
   DEFINE l_fbb       RECORD LIKE fbb_file.*,
          l_faj       RECORD LIKE faj_file.*,
          sql         LIKE type_file.chr1000,
          l_bdate,l_edate LIKE type_file.dat
   DEFINE l_cnt       LIKE type_file.num5   #No:FUN-B60140

   IF s_shut(0) THEN RETURN END IF

   IF g_faa.faa31 = "N" THEN RETURN END IF

   IF g_fba.fba01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

   SELECT * INTO g_fba.* FROM fba_fiel WHERE fba01 = g_fba.fba01

   IF g_fba.fbaconf != 'Y' OR g_fba.fbapost1!= 'N' THEN
      CALL cl_err(g_fba.fba01,'afa-100',0)
      RETURN
   END IF

   #-->立帳日期小於關帳日期
   IF g_fba.fba02 < g_faa.faa092 THEN
      CALL cl_err(g_fba.fba01,'aap-176',1) RETURN
   END IF

   LET g_t1 = s_get_doc_no(g_fba.fba01)
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
   #--->折舊年月判斷
   CALL s_get_bookno(g_faa.faa072) RETURNING g_flag,g_bookno1,g_bookno2

   #固資己不和二套掛勾，所以原本利用s_get_bookno取到帳別一及帳別二是用是否使用二套帳來判斷
   #此處取帳別二要重新處理，應取固資參數欄位財二帳套faa02c做為帳別二的帳套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF

   CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate

   IF g_fba.fba02 < l_bdate OR g_fba.fba02 > l_edate THEN
      CALL cl_err(g_fba.fba02,'afa-308',0)
      RETURN
   END IF

   IF NOT cl_sure(18,20) THEN RETURN END IF

   BEGIN WORK

   OPEN t106_cl USING g_fba.fba01
   IF STATUS THEN
      CALL cl_err("OPEN t106_cl:", STATUS, 1)
      CLOSE t106_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t106_cl INTO g_fba.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fba.fba01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t106_cl
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'

   #--------- 過帳(2)insert fap_file
   DECLARE t106_cur22 CURSOR FOR
      SELECT * FROM fbb_file WHERE fbb01=g_fba.fba01

   CALL s_showmsg_init()

   FOREACH t106_cur22 INTO l_fbb.*
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success="Y"
      END IF

      IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('fbb01',g_fba.fba01,'foreach:',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF

      #------- 先找出對應之 faj_file 資料
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fbb.fbb03
                                            AND faj022=l_fbb.fbb031
      IF STATUS THEN #No.7926
         LET g_showmsg = l_fbb.fbb03,"/",l_fbb.fbb031
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)
         LET g_success = 'N'
      END IF

      IF cl_null(l_fbb.fbb031) THEN
         LET l_fbb.fbb031 = ' '
      END IF

      IF cl_null(l_faj.faj432) THEN LET l_faj.faj432 = ' ' END IF
      IF cl_null(l_faj.faj282) THEN LET l_faj.faj282 = ' ' END IF
      IF cl_null(l_faj.faj312) THEN LET l_faj.faj312 = 0 END IF
      IF cl_null(l_faj.faj142) THEN LET l_faj.faj142 = 0 END IF
      IF cl_null(l_faj.faj1412) THEN LET l_faj.faj1412 = 0 END IF
      IF cl_null(l_faj.faj332) THEN LET l_faj.faj332 = 0 END IF
      IF cl_null(l_faj.faj3312) THEN LET l_faj.faj3312 = 0 END IF
      IF cl_null(l_faj.faj322) THEN LET l_faj.faj322 = 0 END IF
      IF cl_null(l_faj.faj232) THEN LET l_faj.faj232 = ' ' END IF
      IF cl_null(l_faj.faj592) THEN LET l_faj.faj592 = 0 END IF
      IF cl_null(l_faj.faj602) THEN LET l_faj.faj602 = 0 END IF
      IF cl_null(l_faj.faj342) THEN LET l_faj.faj342 =' ' END IF
      IF cl_null(l_faj.faj352) THEN LET l_faj.faj352 = 0 END IF
      IF cl_null(l_faj.faj312) THEN LET l_faj.faj312 = 0 END IF
      IF cl_null(l_fbb.fbb082) THEN LET l_fbb.fbb082 = 0 END IF

      #-----No:FUN-B60140-----
     #CHI-C60010---str---
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj3312,g_azi04_1) RETURNING l_faj.faj3312
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
      CALL cl_digcut(l_fbb.fbb102,g_azi04_1) RETURNING l_fbb.fbb102
      CALL cl_digcut(l_fbb.fbb082,g_azi04_1) RETURNING l_fbb.fbb082
     #CHI-C60010---end---
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fap_file
       WHERE fap50  = l_fbb.fbb01
         AND fap501 = l_fbb.fbb02
         AND fap03  = '8'              ## 異動代號
      IF l_cnt = 0 THEN   #無fap_file資料
         INSERT INTO fap_file (fap01,fap02,fap021,fap03,fap04,fap05,fap06,fap07,
                               fap08,fap09,fap10,fap101,fap11,fap12,fap13,fap14,
                               fap15,fap16,fap17,fap18,fap19,fap20,fap201,fap21,
                               fap22,fap23,fap24,fap25,fap26,fap30,fap31,fap32,
                               fap33,fap34,fap341,fap35,fap36,fap37,fap38,fap39,
                               fap40,fap41,fap50,fap501,fap52,fap53,fap54,fap69,
                               fap70,fap71,fap77,fap56,
                               fap121,fap131,fap141,
                               fap052,fap062,fap072,fap082,fap092,fap103,
                               fap1012,fap112,fap152,fap162,fap212,fap222,
                               fap232,fap242,fap252,fap262,fap522,fap532,
                               fap542,fap772,fap562,faplegal)
         VALUES (l_faj.faj01,l_fbb.fbb03,l_fbb.fbb031,'8',
                 g_fba.fba02,l_faj.faj43,l_faj.faj28,l_faj.faj30,
                 l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33+l_faj.faj331,
                 l_faj.faj32,l_faj.faj53,l_faj.faj54,l_faj.faj55,
                 l_faj.faj23,l_faj.faj24,l_faj.faj20,l_faj.faj19,
                 l_faj.faj21,l_faj.faj17,l_faj.faj171,l_faj.faj58,
                 l_faj.faj59,l_faj.faj60,l_faj.faj34,l_faj.faj35,
                 l_faj.faj36,l_faj.faj61,l_faj.faj65,l_faj.faj66,
                 l_faj.faj62,l_faj.faj63,l_faj.faj68,l_faj.faj67,
                 l_faj.faj69,l_faj.faj70,l_faj.faj71,l_faj.faj72,
                 l_faj.faj73,l_faj.faj100,l_fbb.fbb01,l_fbb.fbb02,
                 l_fbb.fbb09,l_fbb.fbb10,l_fbb.fbb08,l_fbb.fbb18,
                 l_fbb.fbb19,l_fbb.fbb17,'9',0,
                 l_faj.faj531,l_faj.faj541,l_faj.faj551
                ,l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,l_faj.faj142,l_faj.faj1412,
                 l_faj.faj332+l_faj.faj3312,l_faj.faj322,l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
                 l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,l_fbb.fbb092,l_fbb.fbb102,
                 l_fbb.fbb082, '0',0,g_legal)
      ELSE
         UPDATE fap_file SET fap052 = l_faj.faj432,
                             fap062 = l_faj.faj282,
                             fap072 = l_faj.faj302,
                             fap082 = l_faj.faj312,
                             fap092 = l_faj.faj142,
                             fap103 = l_faj.faj1412,
                             fap1012= l_faj.faj332+l_faj.faj3312,
                             fap112 = l_faj.faj322,
                             fap152 = l_faj.faj232,
                             fap162 = l_faj.faj242,
                             fap212 = l_faj.faj582,
                             fap222 = l_faj.faj592,
                             fap232 = l_faj.faj602,
                             fap242 = l_faj.faj342,
                             fap252 = l_faj.faj352,
                             fap262 = l_faj.faj362,
                             fap772 = '9',
                             fap522 = l_fbb.fbb092,
                             fap532 = l_fbb.fbb102,
                             fap542 = l_fbb.fbb082,
                             fap562 = 0
                       WHERE fap50  = l_fbb.fbb01
                         AND fap501 = l_fbb.fbb02
                         AND fap03='8'
      END IF
      #-----No:FUN-B60140 END-----
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbb.fbb03,"/",l_fbb.fbb031,"/",'8',"/",g_fba.fba02
         CALL s_errmsg('fap02,fap021,fap03,fap04',g_showmsg,'ins fap',STATUS,1)
         LET g_success = 'N'
      END IF

      #--------- 過帳(3)update faj_file
      UPDATE faj_file SET faj432  = '9',
                          faj1412 = faj1412+ l_fbb.fbb082,
                          faj332  = faj332 + l_fbb.fbb082,
                          faj302  = l_fbb.fbb092,
                          faj312  = l_fbb.fbb102
       WHERE faj02=l_fbb.fbb03 AND faj022=l_fbb.fbb031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbb.fbb03,"/",l_fbb.fbb031
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)
         LET g_success = 'N'
      END IF

   END FOREACH

   #--------- 過帳(1)update fbapost
   UPDATE fba_file SET fbapost1= 'Y' WHERE fba01 = g_fba.fba01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('fba01',g_fba.fba01,'upd fbapost',STATUS,1)
      LET g_success = 'N'
   END IF

   CLOSE t106_cl
   CALL s_showmsg()
   IF g_success = 'N' THEN
      ROLLBACK WORK
      CALL cl_rbmsg(4)
   ELSE
      COMMIT WORK
      CALL cl_cmmsg(4)
   END IF

   SELECT fbapost1 INTO g_fba.fbapost1 FROM fba_file WHERE fba01 = g_fba.fba01

   DISPLAY BY NAME g_fba.fbapost1

   #IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN #FUN-C30313 mark
   IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN #FUN-C30313 add
      LET g_wc_gl = 'npp01 = "',g_fba.fba01,'" AND npp011 = 1'
      LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_fba.fbauser,"' '",g_fba.fbauser,"' 
               '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_fba.fba02,"' 
               'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"
      CALL cl_cmdrun_wait(g_str)
      SELECT fba062,fba072 INTO g_fba.fba062,g_fba.fba072 FROM fba_file
       WHERE fba01 = g_fba.fba01
      DISPLAY BY NAME g_fba.fba062
      DISPLAY BY NAME g_fba.fba072
   END IF

END FUNCTION

FUNCTION t106_w2()
   DEFINE l_aba19     LIKE aba_file.aba19   #No.FUN-670060
   DEFINE l_sql       LIKE type_file.chr1000           #No.FUN-670060       #No.FUN-680070 CHAR(1000)
   DEFINE l_dbs       STRING                #No.FUN-670060
   DEFINE l_fbb    RECORD LIKE fbb_file.*,
          l_faj    RECORD LIKE faj_file.*,
          l_fap    RECORD LIKE fap_file.*,
          l_fap05  LIKE fap_file.fap05,
          l_fap10  LIKE fap_file.fap10,
          l_fap101 LIKE fap_file.fap101,
          l_fap07  LIKE fap_file.fap07,
          l_fap08  LIKE fap_file.fap08,
          l_fap34  LIKE fap_file.fap34,
          l_fap341 LIKE fap_file.fap341,
          l_fap31  LIKE fap_file.fap31,
          l_fap32  LIKE fap_file.fap32,
          l_fap41  LIKE fap_file.fap41,
          l_bdate,l_edate LIKE type_file.dat,          #No.FUN-680070 DATE
          l_cnt    LIKE type_file.num5   #TQC-780089
   DEFINE l_fap052 LIKE fap_file.fap052
   DEFINE l_fap103 LIKE fap_file.fap103   #No:FUN-B30036
   DEFINE l_fap1012 LIKE fap_file.fap1012
   DEFINE l_fap072  LIKE fap_file.fap072
   DEFINE l_fap082  LIKE fap_file.fap082
   DEFINE l_cnt1    LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF

   IF g_faa.faa31 = "N" THEN RETURN END IF

   IF g_fba.fba01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fba.* FROM fba_fiel WHERE fba01 = g_fba.fba01

   IF g_fba.fbapost1 != 'Y' THEN
      CALL cl_err(g_fba.fba01,'afa-108',0)
      RETURN
   END IF

   #-->已拋轉總帳, 不可取消還原
   IF NOT cl_null(g_fba.fba062) AND g_fah.fahglcr = 'N' THEN
      CALL cl_err(g_fba.fba062,'aap-145',1)
      RETURN
   END IF

   #-->立帳日期小於關帳日期
   IF g_fba.fba02 < g_faa.faa092 THEN
      CALL cl_err(g_fba.fba01,'aap-176',1)
      RETURN
   END IF

   #--->折舊年月判斷
   CALL s_get_bookno(g_faa.faa072) RETURNING g_flag,g_bookno1,g_bookno2

   #固資己不和二套掛勾，所以原本利用s_get_bookno取到帳別一及帳別二是用是否使用二套帳來判斷
   #此處取帳別二要重新處理，應取固資參數欄位財二帳套faa02c做為帳別二的帳套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF

   CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate

   IF g_fba.fba02 < l_bdate OR g_fba.fba02 > l_edate THEN
      CALL cl_err(g_fba.fba02,'afa-308',0)
      RETURN
   END IF

   DECLARE t106_cur42 CURSOR FOR
      SELECT * FROM fbb_file WHERE fbb01=g_fba.fba01

   FOREACH t106_cur42 INTO l_fbb.*
      LET l_cnt1 = 0
      SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
       WHERE fbn01 = l_fbb.fbb03
         AND fbn02 = l_fbb.fbb031
         AND ((fbn03 = YEAR(g_fba.fba02) AND fbn04 >= MONTH(g_fba.fba02))
          OR fbn03 > YEAR(g_fba.fba02))
         AND fbn041 = '1'   #MOD-C50044 add
      IF l_cnt1 > 0 THEN
         CALL cl_err(l_fbb.fbb03,'afa-348',0)
         RETURN
      END IF
   END FOREACH

   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_fba.fba01) RETURNING g_t1

   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1

   IF NOT cl_null(g_fba.fba062) THEN
      #IF NOT (g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y') THEN #FUN-C30313 mark
      IF NOT (g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y') THEN #FUN-C30313 add
         CALL cl_err(g_fba.fba01,'axr-370',0) RETURN
      END IF
   END IF

   #IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 mark
   IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 add
      LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
      LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
                  "  WHERE aba00 = '",g_faa.faa02c,"'",
                  "    AND aba01 = '",g_fba.fba062,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE aba_pre12 FROM l_sql
      DECLARE aba_cs12 CURSOR FOR aba_pre12
      OPEN aba_cs12
      FETCH aba_cs12 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_fba.fba062,'axr-071',1)
         RETURN
      END IF
   END IF

   IF NOT cl_sure(18,20) THEN RETURN END IF
  #----------------------------------CHI-C90051----------------------------------------(S)
   IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y'  THEN
      LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fba.fba062,"' '8' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT fba062,fba072 INTO g_fba.fba062,g_fba.fba072 FROM fba_file
       WHERE fba01 = g_fba.fba01
      DISPLAY BY NAME g_fba.fba062
      DISPLAY BY NAME g_fba.fba072
      IF NOT cl_null(g_fba.fba062) THEN
         CALL cl_err('','aap-929',0)
         RETURN
      END IF
   END IF
  #----------------------------------CHI-C90051----------------------------------------(E)

   BEGIN WORK

   OPEN t106_cl USING g_fba.fba01
   IF STATUS THEN
      CALL cl_err("OPEN t106_cl:", STATUS, 1)
      CLOSE t106_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t106_cl INTO g_fba.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fba.fba01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t106_cl
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'

   #--------- 還原過帳(1)update fba_file
   UPDATE fba_file SET fbapost1= 'N' WHERE fba01 = g_fba.fba01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","fba_file",g_fba.fba01,"",SQLCA.sqlcode,"","upd fbapost1",1)
      LET g_fba.fbapost1='Y'
      LET g_success = 'N'
   ELSE
      LET g_fba.fbapost1='N'
      LET g_success = 'Y'
      DISPLAY BY NAME g_fba.fbapost1
   END IF

   #--------- 還原過帳(2)update faj_file
   DECLARE t106_cur32 CURSOR FOR
      SELECT * FROM fbb_file WHERE fbb01=g_fba.fba01
   CALL s_showmsg_init()

   FOREACH t106_cur32 INTO l_fbb.*
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success="Y"
      END IF

      IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('fbb01',g_fba.fba01,'foreach:',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF

      #----- 找出 faj_file 中對應之財產編號+附號
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fbb.fbb03
                                            AND faj022=l_fbb.fbb031
      IF STATUS THEN
         LET g_showmsg = l_fbb.fbb03,"/",l_fbb.fbb031
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)
         LET g_success='N'
      END IF

      #----- 找出 fap_file 之 fap05 以便 update faj_file.faj43
      SELECT fap052,fap103,fap1012,fap072,fap082
        INTO l_fap052,l_fap103,l_fap1012,l_fap072,l_fap082
        FROM fap_file
       WHERE fap50=l_fbb.fbb01
         AND fap03='8'

      IF STATUS THEN
         LET g_showmsg = l_fbb.fbb01,"/",l_fbb.fbb02,"/",'7'
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'sel fap',STATUS,1)
         LET g_success = 'N'
      END IF


     #CHI-C60010---str---
      CALL cl_digcut(l_fap082,g_azi04_1) RETURNING l_fap082
      CALL cl_digcut(l_fap103,g_azi04_1) RETURNING l_fap103
      CALL cl_digcut(l_fap1012,g_azi04_1) RETURNING l_fap1012
     #CHI-C60010---end---
      UPDATE faj_file SET faj432  = l_fap052,
                          faj1412 = l_fap103,
                          faj332  = l_fap1012,
                          faj302  = l_fap072,
                          faj312  = l_fap082
         WHERE faj02=l_fbb.fbb03 AND faj022=l_fbb.fbb031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbb.fbb03,"/",l_fbb.fbb031
         CALL s_errmsg('faj02,faj022',g_showmsg ,'upd faj',STATUS,1)
         LET g_success = 'N'
      END IF

      #-----No:FUN-B60140-----
      #--------- 還原過帳(3)delete fap_file
      #財一與稅簽皆未過帳時，才可刪fap_file
      IF g_fba.fbapost <>'Y' AND g_fba.fbapost2<>'Y' THEN
         DELETE FROM fap_file WHERE fap50=l_fbb.fbb01
                                AND fap501=l_fbb.fbb02
                                AND fap03 = '8'
         IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
            LET g_showmsg = l_fbb.fbb01,"/",l_fbb.fbb02,"/",'8'
            CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'del fap',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
      #-----No:FUN-B60140 END-----
   END FOREACH

   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF

   CLOSE t106_cl

   CALL s_showmsg()

   IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF

  #----------------------------------CHI-C90051----------------------------------------mark
  ##IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN #FUN-C30313 mark 
  #IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN #FUN-C30313 add
  #   LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fba.fba062,"' '8' 'Y'"
  #   CALL cl_cmdrun_wait(g_str)
  #   SELECT fba062,fba072 INTO g_fba.fba062,g_fba.fba072 FROM fba_file
  #    WHERE fba01 = g_fba.fba01
  #   DISPLAY BY NAME g_fba.fba062
  #   DISPLAY BY NAME g_fba.fba072
  #END IF
  #----------------------------------CHI-C90051----------------------------------------mark

END FUNCTION

FUNCTION t106_carry_voucher2()
   DEFINE l_fahgslp    LIKE fah_file.fahgslp
   DEFINE li_result    LIKE type_file.num5          #No.FUN-680070 SMALLINT
   DEFINE l_dbs        STRING
   DEFINE l_sql        STRING
   DEFINE l_n          LIKE type_file.num5         #No.FUN-680070 SMALLINT

   IF g_faa.faa31 = "N" THEN RETURN END IF

   IF NOT cl_confirm('aap-989') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF NOT cl_null(g_fba.fba062)  THEN
       CALL cl_err(g_fba.fba062,'aap-618',1)
       RETURN
    END IF
   #FUN-B90004---End---

   CALL s_get_doc_no(g_fba.fba01) RETURNING g_t1
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1

   #IF g_fah.fahdmy3 = 'N' THEN RETURN END IF #FUN-C30313 mark
   IF g_fah.fahdmy32 = 'N' THEN RETURN END IF #FUN-C30313 add

  #IF g_fah.fahglcr = 'Y' THEN    #FUN-B90004
   IF g_fah.fahglcr = 'Y' OR ( g_fah.fahglcr = 'N' AND NOT cl_null(g_fah.fahgslp1)) THEN   #FUN-B90004
      LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
      LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
                  "  WHERE aba00 = '",g_faa.faa02c,"'",
                  "    AND aba01 = '",g_fba.fba062,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE aba_pre22 FROM l_sql
      DECLARE aba_cs22 CURSOR FOR aba_pre22
      OPEN aba_cs22
      FETCH aba_cs22 INTO l_n
      IF l_n > 0 THEN
         CALL cl_err(g_fba.fba062,'aap-991',1)
         RETURN
      END IF

      LET l_fahgslp = g_fah.fahgslp
   ELSE
     #CALL cl_err('','aap-992',1)   #FUN-B90004 mark
      CALL cl_err('','aap-936',1)   #FUN-B90004
      RETURN
   END IF

   IF cl_null(g_fah.fahgslp1) THEN
      CALL cl_err(g_fba.fba01,'axr-070',1)
      RETURN
   END IF

   LET g_wc_gl = 'npp01 = "',g_fba.fba01,'" AND npp011 = 1'
   LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_fba.fbauser,"' '",g_fba.fbauser,"' 
             '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' 
             '",g_fba.fba02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"
   CALL cl_cmdrun_wait(g_str)
   SELECT fba062,fba072 INTO g_fba.fba062,g_fba.fba072 FROM fba_file
    WHERE fba01 = g_fba.fba01
   DISPLAY BY NAME g_fba.fba062
   DISPLAY BY NAME g_fba.fba072

END FUNCTION

FUNCTION t106_undo_carry_voucher2()
   DEFINE l_aba19    LIKE aba_file.aba19
   DEFINE l_sql      LIKE type_file.chr1000
   DEFINE l_dbs      STRING

   IF g_faa.faa31 = "N" THEN RETURN END IF

   IF NOT cl_confirm('aap-988') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF cl_null(g_fba.fba062)  THEN
       CALL cl_err(g_fba.fba062,'aap-619',1)
       RETURN
    END IF
   #FUN-B90004---End---

   CALL s_get_doc_no(g_fba.fba01) RETURNING g_t1
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
  #IF g_fah.fahglcr = 'N' THEN
  #   CALL cl_err('','aap-990',1)
   IF g_fah.fahglcr = 'N' AND cl_null(g_fah.fahgslp1) THEN    #FUN-B90004
      CALL cl_err('','aap-936',1)  #FUN-B90004
      RETURN
   END IF

   LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
   LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
               "  WHERE aba00 = '",g_faa.faa02c,"'",
               "    AND aba01 = '",g_fba.fba062,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   PREPARE aba_pre23 FROM l_sql
   DECLARE aba_cs23 CURSOR FOR aba_pre23
   OPEN aba_cs23
   FETCH aba_cs23 INTO l_aba19
   IF l_aba19 = 'Y' THEN
      CALL cl_err(g_fba.fba06,'axr-071',1)
      RETURN
   END IF

   LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fba.fba062,"' '8' 'Y'"
   CALL cl_cmdrun_wait(g_str)
   SELECT fba062,fba072 INTO g_fba.fba062,g_fba.fba072 FROM fba_file
    WHERE fba01 = g_fba.fba01
   DISPLAY BY NAME g_fba.fba062
   DISPLAY BY NAME g_fba.fba072
END FUNCTION
#-----No:FUN-B60140 END-----
                                        

