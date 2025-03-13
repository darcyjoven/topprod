# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afat105.4gl
# Descriptions...: 固定資產改良作業
# Date & Author..: 96/06/04 By Sophia
# ModIFy.........: 97/04/14 By Danny 稅簽資料預設與財簽資料相同
# ModIFy.........: 02/10/15 BY Maggie   No.A032
# ModIFy.........: No:7837 03/08/19 By Wiky 呼叫自動取單號時應在 Transction中
# ModIFy.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# ModIFy.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# ModIFy.........: No.MOD-470515 04/07/30 By Nicola 加入"相關文件"功能
# ModIFy.........: No.MOD-460534 04/08/13 By Nicola 稅簽過帳預設為n
# ModIFy.........: No.MOD-490235 04/09/13 By Yuna 自動生成改成用confirm的方式
# ModIFy.........: No.MOD-490164 04/09/16 By Kitty 增加判斷,若稅簽已過帳,不可取消確認
# ModIFy.........: No.MOD-4A0248 04/10/25 By Yuna QBE開窗開不出來
# ModIFy.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# ModIFy.........: No.FUN-4C0008 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# ModIFy.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# ModIFy.........: No.MOD-530462 05/03/31 By Smapmin 輸出改良成本及異動後未用年限,
#                                                    系統應自動計算以未來的成本及年限自動重計異動後的殘值
# ModIFy.........: NO.FUN-550034 05/05/17 By jackie 單據編號加大
# ModIFy.........: NO.FUN-560002 05/06/02 By vivien 單據編號修改
# ModIFy.........: No.MOD-590215 05/09/14 By Smapmin 改良成本未依本國幣別取位.
#                                                    稅簽過帳後,不可再按稅簽修改.
# ModIFy.........: No.FUN-580109 05/10/21 By Sarah 以EF為backEND engine,由TIPTOP處理前端簽核動作
# ModIFy.........: No.FUN-5B0018 05/11/04 By Sarah 改良日期沒有判斷關帳日
# ModIFy.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應UPDATE
# ModIFy.........: No.MOD-5B0272 05/12/07 By Sarah (單身)帶出財編資料時,預設異動後預估殘值(faz10)=faz06
# ModIFy.........: NO.MOD-5C0016 05/12/06 BY yiting 輸入財編,附號帶出資料,再回頭選取另一資料,沒有重新帶資料
# MOdIFy.........: No.MOD-5C0133 05/12/23 By Smapmin 重選財編,附號.中文沒有重帶
# ModIFy.........: No.TQC-620120 06/03/02 By Smapmin 當附號為NULL時,LET 附號為空白
# ModIFy.........: No.TQC-630073 06/03/07 By Mandy 流程訊息通知功能
# ModIFy.........: No.FUN-630045 06/03/15 BY Alexstar 新增申請人(表單關係人)欄位
# ModIFy.........: No.FUN-640243 06/05/10 By Echo 自動執行確認功能
# ModIFy.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# ModIFy.........: No.TQC-670008 06/07/05 By rainy 權限修正
# ModIFy.........: No.FUN-670060 06/08/07 By Ray 新增"直接拋轉總帳"功能
# ModIFy.........: No.FUN-680028 06/08/22 By Ray 多帳套修改
# ModIFy.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# ModIFy.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION t105_q() 一開始應清空g_fay.*值
# ModIFy.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# ModIFy.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# ModIFy.........: No.MOD-690081 06/12/06 By Smapmin 已確認的單子不可再重新產生分錄
# ModIFy.........: No.FUN-710028 07/02/01 By hellen 錯誤訊息匯總顯示修改
# ModIFy.........: No.MOD-720074 07/03/01 By Smapmin 檢查資產盤點期間應不可做異動
# ModIFy.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# ModIFy.........: No.MOD-740022 07/04/10 By Smampin 修改異動後預估殘值算法
# ModIFy.........: No.FUN-740033 07/04/11 By Carrier 會計科目加帳套-財務
# ModIFy.........: No.TQC-740222 07/04/24 By Echo 從ERP簽核時，「拋轉傳票」、「傳票拋轉還原」action應隱藏
# ModIFy.........: No.MOD-740435 07/04/24 By Smapmin 修改單別檢核
# ModIFy.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# ModIFy.........: No.TQC-760182 07/07/27 By chenl   自動產生QBE條件不可為空。
# ModIFy.........: No.MOD-780232 07/08/23 By jamie已完全銷帳之資產，於單身【財產編號】開窗時，不應還可以看到。
# ModIFy.........: No.TQC-780089 07/09/21 By Smapmin 自動產生或單身輸入資產編號時,當月有折舊不可輸入
#                                                    已有折舊資料不可過帳還原或確認
# ModIFy.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# ModIFy.........: No.FUN-840111 08/04/23 By lilingyu 預設申請人登入帳號
# ModIFy.........: No.FUN-850068 08/05/14 by TSD.zeak 自訂欄位功能修改 
# ModIFy.........: No.TQC-860018 08/06/09 By Smapmin 增加ON IDLE控管
# ModIFy.........: No.MOD-860284 08/07/04 By Sarah 使用afap302拋轉程式,原先傳g_user改為fayuser
# ModIFy.........: No.CHI-860025 08/07/23 By Smapmin 根據TQC-780089的修改,需區分財簽與稅簽
# ModIFy.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# ModIFy.........: No.MOD-950166 09/05/18 By xiaofeizhu 增加對單身的管控
# ModIFy.........: No.MOD-970231 09/07/24 By Sarah 計算未折減額時,應抓faj33+faj331
# ModIFy.........: No.FUN-980003 09/08/12 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# ModIFy.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# ModIFy.........: No:TQC-9B0059 09/11/16 By wujie 残值栏位不能为负
# Modify.........: No:CHI-9B0032 09/11/30 By Sarah 寫入fap_file時,也應寫入fap77=faj43
# ModIFy.........: No:FUN-9C0077 10/01/06 By baofei 程序精簡
# ModIFy.........: No.FUN-9B0098 10/02/24 by tommas deLETe cl_doc
# ModIFy.........: No.TQC-A40041 10/04/09 By lilingyu 賬款單號fay03提供開窗功能
# ModIFy.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現 
# ModIFy.........: No:CHI-A60036 10/07/12 By Summer 過帳檢查改用s_azmm,增加aza63判斷
# ModIFy.........: No:MOD-A80137 10/08/19 By Dido 過帳與取消過帳應檢核關帳日 
# Modify.........: No:TQC-AB0257 10/11/30 By suncx 新增faz03欄位的控管
# Modify.........: No:MOD-AC0067 10/12/09 By Dido 單身刪除功能被抑制 
# Modify.........: No:TQC-B10268 01/01/27 By zhangll 將mofify改成modify
#                                                    此外统一写法l_allow_delete
# Modify.........: No.FUN-AB0088 11/04/07 By chenying 因固資拆出財二功能，原本寫入fap亦有新增欄位，增加對應處理
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.TQC-B30156 11/05/12 By Dido 預設 fap56 為 0
# Modify.........: No.FUN-B50090 11/06/01 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50118 11/06/13 By belle 自動產生鍵,增加QBE條件-族群編號
# Modify.........: No.FUN-B80054 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No:FUN-B60140 11/09/07 By minpp "財簽二二次改善" 追單
# Modify.........: No:FUN-BA0112 11/11/08 By Sakura 財簽二5.25與5.1程式比對不一致修改
# Modify.........: No:CHI-B80007 11/11/12 By johung 增加afa-309控卡 
# Modify.........: NO:FUN-B90004 11/11/17 By Belle 自動拋轉傳票單別一欄有值，即可進行傳票拋轉/傳票拋轉還原
# Modify.........: No:FUN-BC0004 11/12/01 By xuxz 處理相關財簽二無法存檔問題
# Modify.........: No:MOD-BC0025 11/12/10 By johung 調整afa-092控卡的判斷
# Modify.........: NO:FUN-BB0122 12/01/13 By Sakura 財二預設修改
# Modify.........: No:MOD-BC0125 12/01/13 By Sakura 產生分錄及分錄底稿Action加判斷
#                                                    產生分錄(財簽二)及分錄底稿(財簽二)加判斷

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20012 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:FUN-C30140 12/03/12 By Mandy (1)TP端簽核時,[分錄底稿二],[財簽二資料] ACTION要隱藏
#                                                  (2)送簽中,應不可執行"自動產生" ,"分錄底稿","分錄底稿二","產生分錄底稿","產生分錄底稿(財簽二）","財簽二資料","稅簽修改"ACTION
#                                                  (3)簽核時,自動確認失敗
#                                                  (4)TIPTOP端簽核時,無法寫簽核意見,Action按下後無反應
# Modify.........: No:MOD-C30746 12/03/16 By minpp 自動產生單身資料時，稅簽改良成本(faz17)預設為改良成本(faz08)
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 原使用fahdmy3判斷的程式，將財二部份拆分出來使用fahdmy32處理
# Modify.........: No:MOD-C50044 12/05/09 By Elise 按下確認時，會出現afai900內當月份有做調整的單被當成是已提列折舊的單
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.MOD-C50255 12/06/05 By Polly 增加控卡維護拋轉總帳單別
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C60010 12/06/15 By jinjj 財簽二欄位需依財簽二幣別做取位
# Modify.........: No.MOD-C30795 12/06/28 By Elise 調整afa-348控卡，排除來源為2調整的資產
# Modify.........: No.MOD-C70265 12/07/27 By Polly 資產不存在時,將 afa-093 改用訊息 afa-134
# Modify.........: No:CHI-C90051 12/09/08 By Polly 將拋轉還原程式移至更新確認碼/過帳碼前處理，並判斷傳票編號如不為null時，則RETURN
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-E80012 18/11/29 By lixwz 修改付款日期之後,tic現金流量明細重複

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fay    RECORD LIKE fay_file.*,
    g_fay_t  RECORD LIKE fay_file.*,
    g_fay_o  RECORD LIKE fay_file.*,
    g_fahconf       LIKE fah_file.fahconf,
    g_fahpost       LIKE fah_file.fahpost,
    g_fahapr        LIKE fah_file.fahapr,             #FUN-640243
    g_faz           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    faz02     LIKE faz_file.faz02,
                    faz03     LIKE faz_file.faz03,
                    faz031    LIKE faz_file.faz031,
                    faj06     LIKE faj_file.faj06,
                    faz04     LIKE faz_file.faz04,
                    faz08     LIKE faz_file.faz08,
                    faz05     LIKE faz_file.faz05,
                    faz09     LIKE faz_file.faz09,
                    faz06     LIKE faz_file.faz06,
                    faz10     LIKE faz_file.faz10,
                    faz12     LIKE faz_file.faz12
                    ,fazud01 LIKE faz_file.fazud01,
                    fazud02 LIKE faz_file.fazud02,
                    fazud03 LIKE faz_file.fazud03,
                    fazud04 LIKE faz_file.fazud04,
                    fazud05 LIKE faz_file.fazud05,
                    fazud06 LIKE faz_file.fazud06,
                    fazud07 LIKE faz_file.fazud07,
                    fazud08 LIKE faz_file.fazud08,
                    fazud09 LIKE faz_file.fazud09,
                    fazud10 LIKE faz_file.fazud10,
                    fazud11 LIKE faz_file.fazud11,
                    fazud12 LIKE faz_file.fazud12,
                    fazud13 LIKE faz_file.fazud13,
                    fazud14 LIKE faz_file.fazud14,
                    fazud15 LIKE faz_file.fazud15
                    END RECORD,
    g_faz_t         RECORD
                    faz02     LIKE faz_file.faz02,
                    faz03     LIKE faz_file.faz03,
                    faz031    LIKE faz_file.faz031,
                    faj06     LIKE faj_file.faj06,
                    faz04     LIKE faz_file.faz04,
                    faz08     LIKE faz_file.faz08,
                    faz05     LIKE faz_file.faz05,
                    faz09     LIKE faz_file.faz09,
                    faz06     LIKE faz_file.faz06,
                    faz10     LIKE faz_file.faz10,
                    faz12     LIKE faz_file.faz12
                    ,fazud01 LIKE faz_file.fazud01,
                    fazud02 LIKE faz_file.fazud02,
                    fazud03 LIKE faz_file.fazud03,
                    fazud04 LIKE faz_file.fazud04,
                    fazud05 LIKE faz_file.fazud05,
                    fazud06 LIKE faz_file.fazud06,
                    fazud07 LIKE faz_file.fazud07,
                    fazud08 LIKE faz_file.fazud08,
                    fazud09 LIKE faz_file.fazud09,
                    fazud10 LIKE faz_file.fazud10,
                    fazud11 LIKE faz_file.fazud11,
                    fazud12 LIKE faz_file.fazud12,
                    fazud13 LIKE faz_file.fazud13,
                    fazud14 LIKE faz_file.fazud14,
                    fazud15 LIKE faz_file.fazud15
                    END RECORD,
    g_e             DYNAMIC ARRAY OF RECORD           #稅簽資料維護
                    faz13     LIKE faz_file.faz13,
                    faz14     LIKE faz_file.faz14,
                    faz15     LIKE faz_file.faz15,
                    faz17     LIKE faz_file.faz17,
                    faz18     LIKE faz_file.faz18,
                    faz19     LIKE faz_file.faz19
                    END RECORD,
    g_fah           RECORD LIKE fah_file.*,
    g_fay01_t       LIKE fay_file.fay01,
    g_faj28         LIKE faj_file.faj28,
    l_modify_flag       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)  #No:TQC-B10268
    l_flag              LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    g_argv1             LIKE type_file.chr20,    #No.FUN-560002          #No.FUN-680070 VARCHAR(16)
    g_argv2             STRING,                # 指定執行功能:query or inser  #TQC-630073
    g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN
    g_t1                LIKE type_file.chr5,      #No.FUN-550034          #No.FUN-680070 VARCHAR(5)
    g_buf               LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
    g_rec_b             LIKE type_file.num5,               #單身筆數       #No.FUN-680070 SMALLINT
    l_ac                LIKE type_file.num5                #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
DEFINE g_laststage      LIKE type_file.chr1                 #FUN-580109       #No.FUN-680070 VARCHAR(1)
DEFINE p_row,p_col      LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_forupd_sql     STRING     #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_chr            LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE g_chr2           LIKE type_file.chr1      #FUN-580109       #No.FUN-680070 VARCHAR(1)
DEFINE g_cnt            LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_cnt1           LIKE type_file.num10        #FUN-AB0088
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE g_msg            LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE g_str            STRING     #No.FUN-670060
DEFINE g_wc_gl          STRING     #No.FUN-670060
DEFINE g_dbs_gl         LIKE type_file.chr21    #No.FUN-670060       #No.FUN-680070 VARCHAR(21)
DEFINE g_row_count      LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_curs_index     LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_jump           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE mi_no_ask        LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   g_bookno1      LIKE aza_file.aza81         #No.FUN-740033
DEFINE   g_bookno2      LIKE aza_file.aza82         #No.FUN-740033
DEFINE   g_flag         LIKE type_file.chr1         #No.FUN-740033
#FUN-AB0088---add---str---
DEFINE g_faz2       DYNAMIC ARRAY OF RECORD         #祘Α跑计(Program Variables)
                    faz02     LIKE faz_file.faz02,
                    faz03     LIKE faz_file.faz03,
                    faj06     LIKE faj_file.faj06,
                    faz031    LIKE faz_file.faz031,
                    faz042    LIKE faz_file.faz042,
                    faz082    LIKE faz_file.faz082,
                    faz052    LIKE faz_file.faz052,
                    faz092    LIKE faz_file.faz092,
                    faz062    LIKE faz_file.faz062,
                    faz102    LIKE faz_file.faz102,
                    faz12     LIKE faz_file.faz12
                    END RECORD,
    g_faz2_t        RECORD
                    faz02     LIKE faz_file.faz02,
                    faz03     LIKE faz_file.faz03,
                    faj06     LIKE faj_file.faj06,
                    faz031    LIKE faz_file.faz031,
                    faz042    LIKE faz_file.faz042,
                    faz082    LIKE faz_file.faz082,
                    faz052    LIKE faz_file.faz052,
                    faz092    LIKE faz_file.faz092,
                    faz062    LIKE faz_file.faz062,
                    faz102    LIKE faz_file.faz102,
                    faz12     LIKE faz_file.faz12
                    END RECORD
#FUN-AB0088---add---end---
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
 
    LET g_wc2 = ' 1=1'
    IF INT_FLAG THEN EXIT PROGRAM END IF
    CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818#NO.FUN-6A0069
         RETURNING g_time                 #NO.FUN-6A0069
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2) #TQC-630073
    LET g_forupd_sql = "SELECT * FROM fay_file WHERE fay01 =? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t105_cl CURSOR FROM g_forupd_sql
 
    IF g_bgjob='N' OR cl_null(g_bgjob) THEN
 
       LET p_row = 3 LET p_col = 15
       OPEN WINDOW t105_w AT p_row,p_col              #顯示畫面
             WITH FORM "afa/42f/afat105"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
       CALL cl_ui_init()
         
       #FUN-AB0088---add---str---
       IF g_faa.faa31 = 'Y' THEN  
          CALL cl_set_act_visible("fin_audit2,entry_sheet2",TRUE)
          CALL cl_set_act_visible("gen_entry2,post2,undo_post2",TRUE)  #No:FUN-B60140
          CALL cl_set_act_visible("carry_voucher2,undo_carry_voucher2",TRUE)  #No:FUN-B60140
          CALL cl_set_comp_visible("fay062,fay072,faypost1",TRUE)  #No:FUN-B60140 
       ELSE
          CALL cl_set_act_visible("fin_audit2,entry_sheet2",FALSE)
          CALL cl_set_act_visible("gen_entry2,post2,undo_post2",FALSE)  #No:FUN-B60140
          CALL cl_set_act_visible("carry_voucher2,undo_carry_voucher2",FALSE)  #No:FUN-B60140
          CALL cl_set_comp_visible("fay062,fay072,faypost1",FALSE)  #No:FUN-B60140      
       END IF
       #FUN-AB0088---add---end---
 
    END IF

    #CHI-C60010--add--str--
       SELECT aaa03 INTO g_faj143 FROM aaa_file
        WHERE aaa01 = g_faa.faa02c
       IF NOT cl_null(g_faj143) THEN
          SELECT azi04 INTO g_azi04_1 FROM azi_file
           WHERE azi01 = g_faj143
       END IF
    #CHI-C60010--add—end---
 
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
               CALL t105_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t105_a()
            END IF
         WHEN "efconfirm"
            CALL t105_q()
            LET l_ac = 1 #FUN-C30140 add
            CALL t105_y_chk()          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               LET l_ac = 1
               CALL t105_y_upd()       #CALL 原確認的 UPDATE 段
            END IF
            EXIT PROGRAM
         OTHERWISE
            CALL t105_q()
      END CASE
   END IF
 
    #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
    CALL aws_efapp_flowaction("insert, modify, DELETE, reproduce, detail, query, locale, void, undo_void,     #FUN-D20035 add--undo_void
                              confirm, undo_confirm, easyflow_approval, auto_generate, entry_sheet, 
                              gen_entry,gen_entry2, post,post2, undo_post,undo_post2,amend_depr_tax, 
                              post_depr_tax, undo_post_depr_tax,carry_voucher,
                              entry_sheet2,fin_audit2, 
                              undo_carry_voucher,carry_voucher2,undo_carry_voucher2") #TQC-740222 No:TQC-B10268 #No:FUN-B60140 #FUN-C30140
         RETURNING g_laststage
 
    CALL t105_menu() 
    CLOSE WINDOW t105_w                    #結束畫面
    CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #NO.FUN-6A0069
         RETURNING g_time                           #NO.FUN-6A0069
END MAIN
 
FUNCTION t105_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_faz.clear()
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " fay01 = '",g_argv1,"'"
       LET g_wc2 = " 1=1"
    ELSE
      CALL cl_set_head_visible("","YES")            #No.FUN-6B0029
 
   INITIALIZE g_fay.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
                fay01,fay02,fay03,fay031,fay09,fay06,fay07,#FUN-630045
                fay062,fay072,fayconf,faypost,faypost1,  #No:FUN-B60140
                faymksg,fay08,   #FUN-580109
                fayuser,faygrup,faymodu,faydate
                ,fayud01,fayud02,fayud03,fayud04,fayud05,
                fayud06,fayud07,fayud08,fayud09,fayud10,
                fayud11,fayud12,fayud13,fayud14,fayud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION controlp
           CASE
              WHEN INFIELD(fay01)    #查詢單據性質
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_fay"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fay01
                 NEXT FIELD fay01
#TQC-A40041 --begin--
             WHEN INFIELD(fay03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fay03"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fay03
                 NEXT FIELD fay03
#TQC-A40041 --end--                            
               WHEN INFIELD(fay09) #申請人
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fay09
                 NEXT FIELD fay09
             OTHERWISE
                 EXIT CASE
           END CASE
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
           CONTINUE CONSTRUCT
 
                 ON ACTION qbe_SELECT
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF

      CONSTRUCT g_wc2 ON faz02,faz03,faz031,faz04,faz08,faz05,faz09,
                         faz06,faz10,faz12
                         ,fazud01,fazud02,fazud03,fazud04,fazud05,
                         fazud06,fazud07,fazud08,fazud09,fazud10,
                         fazud11,fazud12,fazud13,fazud14,fazud15
            FROM s_faz[1].faz02, s_faz[1].faz03, s_faz[1].faz031,
                 s_faz[1].faz04, s_faz[1].faz08, s_faz[1].faz05,
                 s_faz[1].faz09, s_faz[1].faz06, s_faz[1].faz10,
                 s_faz[1].faz12
                 ,s_faz[1].fazud01,s_faz[1].fazud02,s_faz[1].fazud03,
                 s_faz[1].fazud04,s_faz[1].fazud05,s_faz[1].fazud06,
                 s_faz[1].fazud07,s_faz[1].fazud08,s_faz[1].fazud09,
                 s_faz[1].fazud10,s_faz[1].fazud11,s_faz[1].fazud12,
                 s_faz[1].fazud13,s_faz[1].fazud14,s_faz[1].fazud15
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION controlp
           CASE
              WHEN INFIELD(faz03)  #財產編號,財產附號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_faj4"   #MOD-780232 mod
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO faz03
                   NEXT FIELD faz03
              WHEN INFIELD(faz12)  #異動原因
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_fag"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.arg1 = "7"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO faz12
                   NEXT FIELD faz12
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
           CONTINUE CONSTRUCT
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
     END CONSTRUCT
     IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   END IF    #FUN-580109

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fayuser', 'faygrup')
 
 
    IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
       LET g_sql = "SELECT fay01 FROM fay_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
    ELSE                                        # 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT fay01 ",
                   "  FROM fay_file, faz_file",
                   " WHERE fay01 = faz01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE t105_PREPARE FROM g_sql
    DECLARE t105_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t105_prepare
 
    IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM fay_file WHERE ",g_wc CLIPPED
    ELSE
       LET g_sql="SELECT COUNT(DISTINCT fay01) FROM fay_file,faz_file",
                 " WHERE faz01 = fay01 ",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
    END IF
    PREPARE t105_prcount FROM g_sql
    DECLARE t105_count CURSOR WITH HOLD FOR t105_prcount
END FUNCTION
 
FUNCTION t105_menu()
   DEFINE l_creator    LIKE type_file.chr1           #「不准」時是否退回填表人 #FUN-580109       #No.FUN-680070 VARCHAR(1)
   DEFINE l_flowuser   LIKE type_file.chr1           # 是否有指定加簽人員      #FUN-580109       #No.FUN-680070 VARCHAR(1)
 
   LET l_flowuser = "N"   #FUN-580109
 
   WHILE TRUE
      CALL t105_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t105_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t105_q()
            END IF
        #WHEN "deLETe"                  #MOD-AC0067 mark
         WHEN "delete"                  #MOD-AC0067
            IF cl_chk_act_auth() THEN
               CALL t105_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t105_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t105_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "auto_generate"   #MOD-720074
            IF cl_chk_act_auth() THEN
              #FUN-C30140---add---str---
              IF NOT cl_null(g_fay.fay08) AND g_fay.fay08 matches '[Ss]' THEN     
                  CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
              ELSE
              #FUN-C30140---add---end---
                  CALL t105_g()
                  CALL t105_b()
              END IF #FUN-C30140 add
            END IF
         WHEN "entry_sheet"
            IF cl_chk_act_auth() AND NOT cl_null(g_fay.fay01) AND g_fah.fahfa1 = 'Y' THEN #MOD-BC0125 add fahfa1
              #FUN-C30140---add---str---
              IF NOT cl_null(g_fay.fay08) AND g_fay.fay08 matches '[Ss]' THEN     
                  CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
              ELSE
              #FUN-C30140---add---end---
                  CALL s_fsgl('FA',7,g_fay.fay01,0,g_faa.faa02b,1,g_fay.fayconf,'0',g_faa.faa02p)     #No.FUN-680028
                  CALL t105_npp02('0')  #No.+087 010503 by plum
              END IF #FUN-C30140 add
            END IF
         WHEN "entry_sheet2"
            IF cl_chk_act_auth() AND NOT cl_null(g_fay.fay01) AND g_fah.fahfa2 = 'Y' THEN #MOD-BC0125 add fahfa2
              #FUN-C30140---add---str---
              IF NOT cl_null(g_fay.fay08) AND g_fay.fay08 matches '[Ss]' THEN     
                  CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
              ELSE
              #FUN-C30140---add---end---
                  CALL s_fsgl('FA',7,g_fay.fay01,0,g_faa.faa02c,1,g_fay.fayconf,'1',g_faa.faa02p)     #No.FUN-680028
                  CALL t105_npp02('1')  #No.+087 010503 by plum
              END IF #FUN-C30140 add
            END IF
         WHEN "gen_entry"
            IF cl_chk_act_auth() AND g_fay.fayconf <> 'X' AND g_fah.fahfa1 = 'Y' THEN #MOD-BC0125 add fahfa1
              #FUN-C30140---add---str---
              IF NOT cl_null(g_fay.fay08) AND g_fay.fay08 matches '[Ss]' THEN     
                  CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
              ELSE
              #FUN-C30140---add---end---
                  IF g_fay.fayconf = 'N' THEN   #MOD-690081
                     LET g_success='Y' #no.5573
                     BEGIN WORK #No.FUN-710028
                     CALL s_showmsg_init()    #No.FUN-710028
                     CALL t105_gl(g_fay.fay01,g_fay.fay02,'0')
                    #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN  #FUN-AB0088 mark
                     ##-----No:FUN-B60140 Mark-----
                     #IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN  #FUN-AB0088 add 
                     #   CALL t105_gl(g_fay.fay01,g_fay.fay02,'1')
                     #END IF
                     ##-----No:FUN-B60140 Mark END-----
                     CALL s_showmsg() #No.FUN-710028
                     IF g_success='Y' THEN
                        COMMIT WORK
                     ELSE
                        ROLLBACK WORK
                     END IF #no.5573
                  ELSE   #MOD-690081
                     CALL cl_err(g_fay.fay01,'afa-350',0)   #MOD-690081
                  END IF   #MOD-690081
              END IF #FUN-C30140 add
            END IF
        #-----No:FUN-B60140-----
         WHEN "gen_entry2"
            IF cl_chk_act_auth() AND g_fay.fayconf <> 'X' AND g_fah.fahfa2 = 'Y' THEN #MOD-BC0125 add fahfa2
              #FUN-C30140---add---str---
              IF NOT cl_null(g_fay.fay08) AND g_fay.fay08 matches '[Ss]' THEN     
                  CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
              ELSE
              #FUN-C30140---add---end---
                  IF g_fay.fayconf = 'N' THEN
                     LET g_success='Y'
                     BEGIN WORK
                     CALL s_showmsg_init()
                     CALL t105_gl(g_fay.fay01,g_fay.fay02,'1')
                     CALL s_showmsg()
                     IF g_success='Y' THEN
                        COMMIT WORK
                     ELSE
                        ROLLBACK WORK
                     END IF
                  ELSE
                     CALL cl_err(g_fay.fay01,'afa-350',0)
                  END IF
              END IF #FUN-C30140 add
            END IF
        #-----No:FUN-B60140 END-----
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t105_x()            #FUN-D20035
               CALL t105_x(1)           #FUN-D20035
            END IF

         #FUN-D20035---add--str
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t105_x(2)
            END IF
         #FUN-D20035---add---end


         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t105_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t105_y_upd()       #CALL 原確認的 UPDATE 段
               END IF
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t105_z()
            END IF
         WHEN "carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_fay.faypost = 'Y' THEN      #No.FUN-680028
                  CALL t105_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-557',1)     #No.FUN-680028
               END IF
            END IF
         WHEN "undo_carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_fay.faypost = 'Y' THEN      #No.FUN-680028
                  CALL t105_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-558',1)     #No.FUN-680028
               END IF
            END IF
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t105_s()
            END IF
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t105_w()
            END IF
         #FUN-AB0088---add---str---
         WHEN "fin_audit2"
            IF cl_chk_act_auth() THEN
               CALL t105_fin_audit2()
            END IF
         #FUN-AB0088---add---end---
 
        #-----No:FUN-B60140-----
         WHEN "post2"
            IF cl_chk_act_auth() THEN
               CALL t105_s2()
            END iF
         WHEN "undo_post2"
            IF cl_chk_act_auth() THEN
               CALL t105_w2()
            END iF
         WHEN "carry_voucher2"
            IF cl_chk_act_auth() THEN
               IF g_fay.faypost1 = 'Y' THEN
                  CALL t105_carry_voucher2()
               ELSE
                  CALL cl_err('','atm-557',1)
               END IF
            END IF
         WHEN "undo_carry_voucher2"
            IF cl_chk_act_auth() THEN
               IF g_fay.faypost1 = 'Y' THEN
                  CALL t105_undo_carry_voucher2()
               ELSE
                  CALL cl_err('','atm-558',1)
               END IF
            END IF
        #-----No:FUN-B60140 END----- 
        WHEN "amend_depr_tax"
            IF cl_chk_act_auth() THEN
               CALL t105_k()
            END IF
         WHEN "post_depr_tax"
            IF cl_chk_act_auth() THEN
               CALL t105_6()
            END IF
         WHEN "undo_post_depr_tax"
            IF cl_chk_act_auth() THEN
               CALL t105_7()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fay.fay01 IS NOT NULL THEN
                  LET g_doc.column1 = "fay01"
                  LET g_doc.value1 = g_fay.fay01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_faz),'','')
            END IF
        #@WHEN "簽核狀況"
        WHEN "approval_STATUS"
             IF cl_chk_act_auth() THEN  #DISPLAY ONLY
                IF aws_condition2() THEN
                   CALL aws_efstat2()
                END IF
             END IF
        ##EasyFlow送簽
        WHEN "easyflow_approval"
             IF cl_chk_act_auth() THEN
               #FUN-C20012 add str---
                SELECT * INTO g_fay.* FROM fay_file
                 WHERE fay01 = g_fay.fay01
                CALL t105_show()
                CALL t105_b_fill(' 1=1')
               #FUN-C20012 add end---
                CALL t105_ef()
                CALL t105_show()  #FUN-C20012 add
             END IF
        #@WHEN "准"
        WHEN "agree"
             IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
                CALL t105_y_upd()      #CALL 原確認的 UPDATE 段
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
                         CALL t105_q()
                         #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                         CALL aws_efapp_flowaction("insert, modify, DELETE, reproduce, detail, query, locale, void, undo_void,   #FUN-D20035 add--undo_void
                                                    confirm, undo_confirm, easyflow_approval, auto_generate, entry_sheet, 
                                                    gen_entry,gen_entry2, post, undo_post,post2,undo_post2,amend_depr_tax, 
                                                    post_depr_tax, undo_post_depr_tax,carry_voucher,undo_carry_voucher,
                                                    entry_sheet2,fin_audit2, 
                                                    carry_voucher2,undo_carry_voucher2") #TQC-740222 #No:TQC-B10268  #No.FUN-B60140 #FUN-C30140 
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
                     LET g_fay.fay08 = 'R'
                     DISPLAY BY NAME g_fay.fay08
                  END IF
                  IF cl_confirm('aws-081') THEN
                     IF aws_efapp_getnextforminfo() THEN
                        LET l_flowuser = 'N'
                        LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                        IF NOT cl_null(g_argv1) THEN
                           CALL t105_q()
                           #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                           CALL aws_efapp_flowaction("insert, modify, DELETE, reproduce, detail, query, locale, void, undo_void,   #FUN-D20035 add--undo_void
                                                      confirm, undo_confirm, easyflow_approval, auto_generate, entry_sheet, 
                                                      gen_entry, gen_entry2,post, undo_post,post2,undo_post2,amend_depr_tax, 
                                                      post_depr_tax, undo_post_depr_tax,carry_voucher,undo_carry_voucher,
                                                      entry_sheet2,fin_audit2, 
                                                      carry_voucher2,undo_carry_voucher2 ") #TQC-740222 #No:TQC-B10268 #No:FUN-B60140 #FUN-C30140
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
        WHEN "modify_flow"  #No:TQC-B10268
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
 
FUNCTION t105_a()
 
DEFINE li_result   LIKE type_file.num5         #No.FUN-680070 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_faz.clear()
    CALL g_e.clear()
    INITIALIZE g_fay.* TO NULL
    LET g_fay01_t = NULL
    LET g_fay_o.* = g_fay.*
    LET g_fay_t.* = g_fay.*
 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fay.fay02  =g_today
        LET g_fay.fayconf='N'
        LET g_fay.faypost='N'
        LET g_fay.faypost1='N'  #No:FUN-B60140
        LET g_fay.faypost2='N'
        LET g_fay.fayprsw=0
        LET g_fay.fayuser=g_user
        LET g_fay.fayoriu = g_user #FUN-980030
        LET g_fay.fayorig = g_grup #FUN-980030
        LET g_fay.faygrup=g_grup
        LET g_fay.faydate=g_today
        LET g_fay.faymksg = "N"   #FUN-580109
        LET g_fay.fay08 = "0"     #FUN-580109
        LET g_fay.fay09=g_user                            
        LET g_fay.faylegal= g_legal    #FUN-980003 add
        CALL t105_fay09('d')

        CALL t105_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0
           INITIALIZE g_fay.* TO NULL
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        IF g_fay.fay01 IS NULL THEN       #KEY不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK  #No:7837
        CALL s_auto_assign_no("afa",g_fay.fay01,g_fay.fay02,"7","fay_file","fay01","","","")
             RETURNING li_result,g_fay.fay01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_fay.fay01

        INSERT INTO fay_file VALUES (g_fay.*)
        IF SQLCA.SQLCODE THEN
           CALL cl_err3("ins","fay_file",g_fay.fay01,"",SQLCA.SQLCODE,"","Ins:",1)  #No.FUN-660136  #No.FUN-B80054---調整至回滾事務前---
           ROLLBACK WORK  #No:7837
           CONTINUE WHILE
        ELSE
           COMMIT WORK   #No:7837
           CALL cl_flow_notIFy(g_fay.fay01,'I')
        END IF
        CALL g_faz.clear()
        LET g_rec_b=0
        LET g_fay_t.* = g_fay.*
        LET g_fay01_t = g_fay.fay01
        SELECT fay01 INTO g_fay.fay01
          FROM fay_file
         WHERE fay01 = g_fay.fay01
 
        CALL t105_g()
        CALL t105_b()
        #---判斷是否直接列印,確認,過帳---------
        LET g_t1 = s_get_doc_no(g_fay.fay01)  #No.FUN-550034
        SELECT fahconf,fahpost,fahapr INTO g_fahconf,g_fahpost,g_fahapr
          FROM fah_file
         WHERE fahslip = g_t1
 
        IF g_fahconf = 'Y' AND g_fahapr <> 'Y' THEN
           LET g_action_choice = "insert"

           CALL t105_y_chk()          #CALL 原確認的 check 段
           IF g_success = "Y" THEN
              CALL t105_y_upd()       #CALL 原確認的 UPDATE 段
           END IF
        END IF
        IF g_fahpost = 'Y' THEN
           CALL t105_s()
           CALL t105_s2()  #No:FUN-B60140
        END IF
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t105_u()
  DEFINE l_tic01     LIKE tic_file.tic01       #FUN-E80012 add
  DEFINE l_tic02     LIKE tic_file.tic02       #FUN-E80012 add
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fay.fay01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fay.* FROM fay_file WHERE fay01 = g_fay.fay01
   IF g_fay.fayconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_fay.fayconf = 'Y' THEN CALL cl_err(' ','afa-096',0) RETURN END IF
   IF g_fay.faypost = 'Y' THEN CALL cl_err(' ','afa-101',0) RETURN END IF
   IF g_fay.faypost1 = 'Y' THEN CALL cl_err(' ','afa-101',0) RETURN END IF  #No:FUN-B60140
   IF g_fay.faypost2 = 'Y' THEN CALL cl_err(' ','afa-101',0) RETURN END IF  #No:FUN-B60140
   IF g_fay.fay08 MATCHES '[Ss]' THEN
      CALL cl_err('','apm-030',0)
      RETURN
   END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fay01_t = g_fay.fay01
    LET g_fay_o.* = g_fay.*
    BEGIN WORK
 
    OPEN t105_cl USING g_fay.fay01
    IF STATUS theN
       CALL cl_err("OPEN t105_cl:", STATUS, 1)
       CLOSE t105_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t105_cl INTO g_fay.*          # 鎖住將被更改或取消的資料
    IF SQLCA.SQLCODE THEN
        CALL cl_err(g_fay.fay01,SQLCA.SQLCODE,0)     # 資料被他人LOCK
        CLOSE t105_cl ROLLBACK WORK RETURN
    END IF
    CALL t105_show()
    WHILE TRUE
        LET g_fay01_t = g_fay.fay01
        LET g_fay.faymodu=g_user
        LET g_fay.faydate=g_today
        CALL t105_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET iNT_FLAG = 0
            LET g_fay.*=g_fay_t.*
            CALL t105_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        LET g_fay.fay08 = '0'   #FUN-580109
        IF g_fay.fay01 != g_fay_t.fay01 THEN
           UPDATE faz_file SET faz01=g_fay.fay01 WHERE faz01=g_fay_t.fay01
           IF sqlCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("upd","faz_file",g_fay_t.fay01,"",SQLCA.SQLCODE,"","upd faz01",1)  #No.FUN-660136
              LET g_fay.*=g_fay_t.*
              CALL t105_show()
              CONTINUE WHILE
           END IF
        END IF
        UPDATE fay_file SET * = g_fay.*
         WHERE fay01 = g_fay.fay01
        IF SQLCA.SQLERRD[3] = 0 OR SQLCA.SQLCODE THEN
           CALL cl_err3("upd","fay_file",g_fay_t.fay01,"",SQLCA.SQLCODE,"","",1)  #No.FUN-660136
           CONTINUE WHILE
        END IF
        IF g_fay.fay02 != g_fay_t.fay02 THEN            # 更改單號
           UPDATE npp_file SET npp02=g_fay.fay02
            WHERE npp01=g_fay.fay01 AND npp00=7 AND npp011=1
              AND nppsys = 'FA'
           IF STATUS THEN 
              CALL cl_err3("upd","npp_file",g_fay.fay01,"",STATUS,"","upd npp02:",1)  #No.FUN-660136
           END IF
           #FUN-E80012---add---str---
           SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
           IF g_nmz.nmz70 = '3' THEN
              LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_fay.fay02,1)
              LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_fay.fay02,3)
              UPDATE tic_file SET tic01=l_tic01,
                                  tic02=l_tic02
              WHERE tic04=g_fay.fay01
              IF STATUS THEN
                 CALL cl_err3("upd","tic_file",g_fay.fay01,"",STATUS,"","upd tic01,tic02:",1)
              END IF
           END IF
           #FUN-E80012---add---end---
        END IF
        DISPLAY BY NAME g_fay.fay08
        IF g_fay.fayconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_fay.fay08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        CALL cl_set_field_pic(g_fay.fayconf,g_chr2,g_fay.faypost,"",g_chr,"")
        EXIT WHILE
    END WHILE
    CLOSE t105_cl
    COMMIT WORK
    CALL cl_flow_notIFy(g_fay.fay01,'U')
END FUNCTION
 
FUNCTION t105_npp02(p_npptype)     #No.FUN-680028
  DEFINE p_npptype   LIKE npp_file.npptype     #No.FUN-680028
  DEFINE l_tic01     LIKE tic_file.tic01       #FUN-E80012 add
  DEFINE l_tic02     LIKE tic_file.tic02       #FUN-E80012 add
 
  #-----No:FUN-B60140-----
  IF p_npptype = '0' THEN
     IF g_fay.fay06 IS NULL OR g_fay.fay06=' ' THEN
        UPDATE npp_file SET npp02=g_fay.fay02
         WHERE npp01=g_fay.fay01 AND npp00=7 AND npp011=1
           AND nppsys = 'FA'
           AND npptype = p_npptype     #No.FUN-680028
        IF STATUS thEN 
           CALL cl_err3("upd","npp_file",g_fay.fay01,"",STATUS,"","upd npp02:",1)  #No.FUN-660136
        END IF
        #FUN-E80012---add---str---
        SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
        IF g_nmz.nmz70 = '3' THEN
           LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_fay.fay02,1)
           LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_fay.fay02,3)
           UPDATE tic_file SET tic01=l_tic01,
                               tic02=l_tic02
           WHERE tic04=g_fay.fay01
           IF STATUS THEN 
              CALL cl_err3("upd","tic_file",g_fay.fay01,"",STATUS,"","upd tic01,tic02:",1)
           END IF
        END IF
        #FUN-E80012---add---end---
     END IF
   ELSE
      IF g_fay.fay062 IS NULL OR g_fay.fay062=' ' THEN
         UPDATE npp_file SET npp02=g_fay.fay02
          WHERE npp01=g_fay.fay01 AND npp00=7 AND npp011=1
            AND nppsys = 'FA'
            AND npptype = p_npptype
         IF STATUS THEN
            CALL cl_err3("upd","npp_file",g_fay.fay01,"",STATUS,"","upd npp02:",1)
         END IF
         #FUN-E80012---add---str---
         SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
         IF g_nmz.nmz70 = '3' THEN
            LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_fay.fay02,1)
            LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_fay.fay02,3)
            UPDATE tic_file SET tic01=l_tic01,
                                tic02=l_tic02
            WHERE tic04=g_fay.fay01
            IF STATUS THEN    
               CALL cl_err3("upd","tic_file",g_fay.fay01,"",STATUS,"","upd tic01,tic02:",1)
            END IF
         END IF
         #FUN-E80012---add---end---
      END IF
   END IF
    #-----No:FUN-B60140 END-----
END FUNCTION
 
#處理input
FUNCTION t105_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1,   #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
         l_flag          LIKE type_file.chr1,   #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
         l_bdate,l_edate LIKE type_file.dat,    #No.FUN-680070 DATE
         l_n1            LIKE type_file.num5    #No.FUN-680070 SMALLINT
 
DEFINE li_result   LIKE type_file.num5          #No.FUN-680070 SMALLINT
    CALL cl_set_head_visible("","YES")          #No.FUN-6B0029
 
   INPUT BY NAME  # g_fay.fayoriu,g_fay.fayorig,                  #TQC-A40041 mark
        g_fay.fay01,g_fay.fay02,g_fay.fay03,g_fay.fay031,g_fay.fay09,#FUN-630045
        g_fay.fay06,g_fay.fay07,g_fay.fay062,g_fay.fay072,  #No:FUN-B60140
        g_fay.fayconf,g_fay.faypost,g_fay.faypost1,g_fay.faypost2,   #No.MOD-460534 #No:FUN-B60140
        g_fay.faymksg,g_fay.fay08,   #FUN-580109
#       g_fay.fayuser,g_fay.faygrup,g_fay.faymodu,g_fay.faydate,   #TQC-A40041 mark
        g_fay.fayud01,g_fay.fayud02,g_fay.fayud03,g_fay.fayud04,
        g_fay.fayud05,g_fay.fayud06,g_fay.fayud07,g_fay.fayud08,
        g_fay.fayud09,g_fay.fayud10,g_fay.fayud11,g_fay.fayud12,
        g_fay.fayud13,g_fay.fayud14,g_fay.fayud15 
           WITHOUT DEFAULTS
 
        BEFORE INPUT 
          LET g_before_input_done = FALSE
          CALL t105_set_entry(p_cmd)
          CALL t105_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
         CALL cl_set_docno_format("fay01")
         CALL cl_set_docno_format("fay03")
         CALL cl_set_docno_format("fay06")
         CALL cl_set_docno_format("fay062")  #No:FUN-B60140

        AFTER FIELD fay01
            IF NOT cl_null(g_fay.fay01) AND (cl_null(g_fay01_t) OR (g_fay.fay01!=g_fay01_t)) THEN   #MOD-740435
             CALL s_check_no("afa",g_fay.fay01,g_fay01_t,"7","fay_file","fay01","")
                  RETURNING li_result,g_fay.fay01
             DISPLAY BY NAME g_fay.fay01
             IF (NOT li_result) THEN
                NEXT FIELD fay01
             END IF

 
              LET g_t1 = s_get_doc_no(g_fay.fay01)  #No.FUN-550034
               SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1

            END IF
            SELECT fahapr,'0' INTO g_fay.faymksg,g_fay.fay08
              FROM fah_file
             WHERE fahslip = g_t1
            IF cl_null(g_fay.faymksg) THEN            #FUN-640243
                 LET g_fay.faymksg = 'N'
            END IF
            DISPLAY BY NAME g_fay.faymksg,g_fay.fay08
            LET g_fay_o.fay01 = g_fay.fay01
 
         AFTER FIELD fay02
            IF NOT cl_null(g_fay.fay02) THEN
               CALL s_azn01(g_faa.faa07,g_faa.faa08) RETURNING l_bdate,l_edate
               IF g_fay.fay02 < l_bdate THEN
                  CALL cl_err(g_fay.fay02,'afa-130',0)
                  NEXT FIELD fay02
               END IF
            END IF
            IF NOT cl_null(g_fay.fay02) THEN
               IF g_fay.fay02 <= g_faa.faa09 THEN
                  CALL cl_err('','mfg9999',1)
                  NEXT FIELD fay02
               END IF
               CALL s_get_bookno(YEAR(g_fay.fay02))
                    RETURNING g_flag,g_bookno1,g_bookno2
               IF g_flag =  '1' THEN  #抓不到帳別
                  CALL cl_err(g_fay.fay02,'aoo-081',1)
                  NEXT FIELD fay02
               END IF
            END IF
        AFTER FIELD fay09
            IF NOT cl_null(g_fay.fay09) THEN
               CALL t105_fay09('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_fay.fay09 = g_fay_t.fay09
                  CALL cl_err(g_fay.fay09,g_errno,0)
                  DISPLAY BY NAME g_fay.fay09 #
                  NEXT FIELD fay09
               END IF
            ELSE
               DISPLAY '' TO FORMONLY.gen02
            END IF
        AFTER FIELD fayud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fayud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fayud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fayud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fayud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fayud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fayud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fayud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fayud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fayud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fayud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fayud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fayud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fayud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fayud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
         AFTER INPUT  #97/05/22 mofify
            LET g_fay.fayuser = s_get_data_owner("fay_file") #FUN-C10039
            LET g_fay.faygrup = s_get_data_group("fay_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(fay01)    #查詢單據性質
                 LET g_t1 = s_get_doc_no(g_fay.fay01)  #No.FUN-550034
                     CALL q_fah( FALSE, TRUE,g_t1,'7','AFA')   #TQC-670008
                          RETURNING g_t1
                 LET g_fay.fay01 = g_t1  #No.FUN-550034
                 DISPLAY BY NAME g_fay.fay01
                 NEXT FIELD fay01
#TQC-A40041 --begin--
             WHEN INFIELD(fay03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_apa9"
                LET g_qryparam.default1 = g_fay.fay03
                CALL cl_create_qry() RETURNING g_fay.fay03
                DISPLAY BY NAME g_fay.fay03
                NEXT FIELD fay03
#TQC-A40041 --end--                 
              WHEN INFIELD(fay09)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                LET g_qryparam.default1 = g_fay.fay09
                CALL cl_create_qry() RETURNING g_fay.fay09
                DISPLAY BY NAME g_fay.fay09
                NEXT FIELD fay09
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
          CONTINUE INPUT
 
    END INPUT
END FUNCTION
 
FUNCTION t105_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fay01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t105_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fay01",FALSE)
    END IF
 
END FUNCTION
 
 
FUNCTION t105_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fay.* TO NULL             #No.FUN-6A0001
    CALL cl_msg("")                              #FUN-640243
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t105_cs()
    IF INT_FLAG tHEN
       LET INT_FLAG = 0
       INITIALIZE g_fay.* TO NULL
       RETURN
    END IF
 
    CALL cl_msg(" SEARCHING ! ")                 #FUN-640243
 
    OPEN t105_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.SQLCODE THEN
        CALL cl_err('',SQLCA.SQLCODE,0)
        INITIALIZE g_fay.* TO NULL
    ELSE
        OPEN t105_count
        FETCH t105_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t105_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    CALL cl_msg("")                              #FUN-640243
 
 
END FUNCTION
 
FUNCTION t105_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t105_cs INTO g_fay.fay01
        WHEN 'P' FETCH PREVIOUS t105_cs INTO g_fay.fay01
        WHEN 'F' FETCH FIRST    t105_cs INTO g_fay.fay01
        WHEN 'L' FETCH LAST     t105_cs INTO g_fay.fay01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('FETCH',g_lang) RETURNING g_msg
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
            FETCH ABSOLUTE g_jump t105_cs INTO g_fay.fay01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.SQLCODE THEN
       CALL cl_err(g_fay.fay01,SQLCA.SQLCODE,0)
       INITIALIZE g_fay.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_fay.* FROM fay_file WHERE fay01 = g_fay.fay01
    IF SQLCA.SQLCODE THEN
       CALL cl_err3("sel","fay_file",g_fay.fay01,"",SQLCA.SQLCODE,"","",1)  #No.FUN-660136
       INITIALIZE g_fay.* TO NULL
       RETURN
    END IF
    LET g_data_owner = g_fay.fayuser   #FUN-4C0059
    LET g_data_group = g_fay.faygrup   #FUN-4C0059
    CALL s_get_bookno(YEAR(g_fay.fay02)) #TQC-740042
         RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag =  '1' THEN  #抓不到帳別
       CALL cl_err(g_fay.fay02,'aoo-081',1)
    END IF
    CALL t105_show()
END FUNCTION
 
FUNCTION t105_show()
    LET g_fay_t.* = g_fay.*                #保存單頭舊值
    DISPLAY BY NAME     #g_fay.fayoriu,g_fay.fayorig,         #TQC-A40041 mark
        g_fay.fay01,g_fay.fay02,g_fay.fay03,g_fay.fay031,g_fay.fay09,#FUN-630045
        g_fay.fay06,g_fay.fay07,g_fay.fay062,g_fay.fay072,  #No:FUN-B60140
        g_fay.fayconf,g_fay.faypost,g_fay.faypost1,g_fay.faypost2, #No:FUN-B60140
        g_fay.faymksg,g_fay.fay08,   #FUN-580109 增加簽核,狀況碼
        g_fay.fayuser,g_fay.faygrup,g_fay.faymodu,g_fay.faydate
        ,g_fay.fayud01,g_fay.fayud02,g_fay.fayud03,g_fay.fayud04,
        g_fay.fayud05,g_fay.fayud06,g_fay.fayud07,g_fay.fayud08,
        g_fay.fayud09,g_fay.fayud10,g_fay.fayud11,g_fay.fayud12,
        g_fay.fayud13,g_fay.fayud14,g_fay.fayud15 
    IF g_fay.fayconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_fay.fay08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_fay.fayconf,g_chr2,g_fay.faypost,"",g_chr,"")
    LET g_t1 = s_get_doc_no(g_fay.fay01)  #No.FUN-550034
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
    CALL t105_fay09('d')                      #FUN-630045  
    CALL t105_b_fill(g_wc2)
END FUNCTION
 
FUNCTION t105_r()
 DEFINE l_chr,l_sure LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fay.fay01 IS NULL THEN
       CALL cl_err('',-400,0) RETURN
    END IF
   SELECT * INTO g_fay.* FROM fay_file WHERE fay01 = g_fay.fay01
    #-->已拋轉票不可刪除
    IF NOT cl_null(g_fay.fay06) THEN
       CALL cl_err('','afa-311',0) RETURN
    END IF
    #-----No:FUN-B60140-----
    IF NOT cl_null(g_fay.fay062) THEN
       CALL cl_err('','afa-311',0) RETURN
    END IF
    #-----No:FUN-B60140 END-----
    IF g_fay.fayconf = 'X' THEN
       CALL cl_err(' ','9024',0) RETURN
    END IF
    IF g_fay.fayconf = 'Y' THEN
       CALL cl_err('','afa-096',0) RETURN
    END IF
    IF g_fay.faypost = 'Y' THEN
       CALL cl_err(' ','afa-101',0) RETURN
    END IF
    #-----No:FUN-B60140-----
    IF g_fay.faypost1= 'Y' THEN
       CALL cl_err(' ','afa-101',0) RETURN
    END IF
    IF g_fay.faypost2= 'Y' THEN
       CALL cl_err(' ','afa-101',0) RETURN
    END IF
    #-----No:FUN-B60140 END-----
    IF g_fay.fay08 MATCHES '[Ss1]' THEN
       CALL cl_err('','mfg3557',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN t105_cl USING g_fay.fay01
    IF STATUS theN
       CALL cl_err("OPEN t105_cl:", STATUS, 1)
       CLOSE t105_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t105_cl INTO g_fay.*
    IF SQLCA.SQLCODE THEN
       CALL cl_err(g_fay.fay01,SQLCA.SQLCODE,0)
       CLOSE t105_cl ROLLBACK WORK RETURN
    END IF
    CALL t105_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fay01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fay.fay01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "DeLETe fay,faz!"
        DELETE FROM fay_file WHERE fay01 = g_fay.fay01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","fay_file",g_fay.fay01,"",SQLCA.SQLCODE,"","",1)  #No.FUN-660136
        ELSE CLEAR FORM
           CALL g_faz.clear()
           CALL g_e.clear()
        END IF
        DELETE FROM faz_file WHERE faz01 = g_fay.fay01
        DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 7
                               AND npp01 = g_fay.fay01
                               AND npp011= 1
        DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 7
                               AND npq01 = g_fay.fay01
                               AND npq011= 1
        #FUN-B40056--add--str--
        DELETE FROM tic_file WHERE tic04 = g_fay.fay01
        #FUN-B40056--add--end--
        CLEAR FORM
        CALL g_faz.clear()
        CALL g_e.clear()
        CALL g_faz.clear()
        INITIALIZE g_fay.* LIKE fay_file.*
        OPEN t105_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE t105_cl
           CLOSE t105_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end-- 
        FETCH t105_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t105_cl
           CLOSE t105_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end-- 
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t105_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t105_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t105_fetch('/')
        END IF
 
    END IF
    CLOSE t105_cl
    COMMIT WORK
    CALL cl_flow_notIFy(g_fay.fay01,'D')
END FUNCTION
 
FUNCTION t105_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
       l_row,l_col     LIKE type_file.num5,  		   #分段輸入之行,列數       #No.FUN-680070 SMALLINT
       l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
       l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
       l_faj06         LIKE faj_file.faj06,
       l_faj100        LIKE faj_file.faj100,
       l_faz10         LIKE faz_file.faz10,   #No.FUN-4C0008
       l_faz19         LIKE faz_file.faz19,   #No.FUN-4C0008
       l_fab23         LIKE fab_file.fab23,   #殘值率 NO.A032
       l_str           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
       l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
      #l_allow_DELETE  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT #MOD-AC0067 mod
       l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT #MOD-AC0067 mod  #Mod No:TQC-B10268
DEFINE l_fay08         LIKE fay_file.fay08    #FUN-580109
DEFINE l_cnt1          LIKE type_file.num5    #FUN-AB0088 add
#FUN-BB0122--being add
   DEFINE l_faj332    LIKE faj_file.faj332,
          l_faj3312   LIKE faj_file.faj3312,
          l_faj302    LIKE faj_file.faj302,
          l_faj312    LIKE faj_file.faj312,
          l_faj432    LIKE faj_file.faj432,
          l_faj352    LIKE faj_file.faj352          
#FUN-BB0122--end add
 
    LET g_action_choice = ""
    LET l_fay08 = g_fay.fay08   #FUN-580109
    IF g_fay.fay01 IS NULL THEN RETURN END IF
    IF g_fay.fayconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
    IF g_fay.fayconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fay.faypost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
    IF g_fay.faypost1= 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF  #No:FUN-B60140
    IF g_fay.faypost2= 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF  #No:FUN-B60140
    IF g_fay.fay08 MATCHES '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT faz02,faz03,faz031,'',faz04,faz08,faz05,faz09,faz06, ",
                       "  faz10,faz12      ",
                       "   FROM faz_file  ",
                       "  WHERE faz01 = ?  ",
                       "    AND faz02  = ? ",
                       " FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t105_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
   #LET l_allow_deLETe = cl_detail_INPUT_auth("deLETe")   #MOD-AC0067 mark
   #LET l_allow_DELETE = cl_detail_INPUT_auth("delete")   #MOD-AC0067
    LET l_allow_delete = cl_detail_INPUT_auth("delete")   #MOD-AC0067  #Mod No:TQC-B10268
 
   IF g_rec_b=0 THEN CALL g_faz.clear() END IF
 
 
   INPUT ARRAY g_faz WITHOUT DEFAULTS FROM s_faz.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        AFTER FIELD fazud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fazud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fazud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fazud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fazud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fazud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fazud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fazud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fazud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fazud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fazud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fazud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fazud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fazud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fazud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
	    BEGIN WORK
 
            OPEN t105_cl USING g_fay.fay01
            IF stATUS THEN
               CALL cl_err("OPEN t105_cl:", STATUS, 1)
               CLOSE t105_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t105_cl INTO g_fay.*          # 鎖住將被更改或取消的資料
            IF SQLCA.SQLCODE THEN
               CALL cl_err(g_fay.fay01,SQLCA.SQLCODE,0)     # 資料被他人LOCK
               CLOSE t105_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_faz_t.* = g_faz[l_ac].*  #BACKUP
                LET l_flag = 'Y'
 
                OPEN t105_bcl USING g_fay.fay01,g_faz_t.faz02
                IF STATUS THEN
                   CALL cl_err("OPEN t105_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                   CLOSE t105_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t105_bcl INTO g_faz[l_ac].*
                   IF SQLCA.SQLCODE THEN
                       CALL cl_err('lock faz',SQLCA.SQLCODE,0)   
                       LET l_lock_sw = "Y"
                   END IF
                END IF
            ELSE
                LET l_flag = 'N'
            END IF
            IF l_ac <= l_n THEN                   #DISPLAY NEWEST
               SELECT faj06 INTO g_faz[l_ac].faj06
                 FROM faj_file
                WHERE faj02=g_faz[l_ac].faz03
                LET g_faz_t.faj06 =g_faz[l_ac].faj06
            END IF
 
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              INITIALIZE g_faz[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_faz[l_ac].* TO s_faz.*
              CALL g_faz.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
               CANCEL INSERT
            END IF
         IF cl_null(g_faz[l_ac].faz031) THEN
            LET g_faz[l_ac].faz031 = ' '
         END IF
         #FUN-BB0122--being add
         SELECT faj332,faj3312,faj302,faj312,faj432,faj352
          INTO l_faj332,l_faj3312,l_faj302,l_faj312,l_faj432,l_faj352
            FROM faj_file
            WHERE faj02 =g_faz[l_ac].faz03
            AND faj022 = g_faz[l_ac].faz031
          IF l_faj432 = '7' THEN    #折畢再提
             LET l_faj312 = l_faj352
          END IF
          IF cl_null(l_faj332) THEN LET l_faj332 = 0 END IF
          IF cl_null(l_faj3312) THEN LET l_faj3312 = 0 END IF
          IF cl_null(l_faj302) THEN LET l_faj302 = 0 END IF
          IF cl_null(l_faj312) THEN LET l_faj312 = 0 END IF
         #FUN-BB0122--end add
         #CHI-C60010---str---
          CALL cl_digcut(l_faj332,g_azi04_1) RETURNING l_faj332
          CALL cl_digcut(l_faj3312,g_azi04_1) RETURNING l_faj3312
          CALL cl_digcut(l_faj312,g_azi04_1) RETURNING l_faj312
         #CHI-C60010---end---
             INSERT INTO faz_file (faz01,faz02,faz03,faz031,faz04,faz05,  #No.MOD-470041
                                  faz06,faz07,faz08,faz09,faz10,faz11,
                                  faz12,faz13,faz14,faz15,faz16,faz17,
                                  faz18,faz19,faz20
                                  ,fazud01,fazud02,fazud03,fazud04,fazud05,
                                  fazud06,fazud07,fazud08,fazud09,fazud10,
                                  fazud11,fazud12,fazud13,fazud14,fazud15,
                                  faz042,faz052,faz062,faz082,faz092,faz102,  #FUN-AB0088 add
                                  fazlegal)      #FUN-980003 add
                VALUES(g_fay.fay01,g_faz[l_ac].faz02,g_faz[l_ac].faz03,
                       g_faz[l_ac].faz031,g_faz[l_ac].faz04,g_faz[l_ac].faz05,
                       g_faz[l_ac].faz06,0,g_faz[l_ac].faz08,g_faz[l_ac].faz09, #No.MOD-470565
                       g_faz[l_ac].faz10,0,g_faz[l_ac].faz12,g_e[l_ac].faz13,   #No.MOD-470565
                       g_e[l_ac].faz14,g_e[l_ac].faz15,0,g_e[l_ac].faz17,
                       g_e[l_ac].faz18,g_e[l_ac].faz19,0 #No.MOD-470565
                       ,g_faz[l_ac].fazud01,g_faz[l_ac].fazud02,g_faz[l_ac].fazud03,
                       g_faz[l_ac].fazud04,g_faz[l_ac].fazud05,g_faz[l_ac].fazud06,
                       g_faz[l_ac].fazud07,g_faz[l_ac].fazud08,g_faz[l_ac].fazud09,
                       g_faz[l_ac].fazud10,g_faz[l_ac].fazud11,g_faz[l_ac].fazud12,
                       g_faz[l_ac].fazud13,g_faz[l_ac].fazud14,g_faz[l_ac].fazud15
                       #0,0,0,0,0,0, #FUN-AB0088 add #FUN-BB0122 mark
					   ,l_faj332+l_faj3312,l_faj302,l_faj312,0,l_faj302,l_faj312,     #FUN-BB0122 add
                       g_legal)      #FUN-980003 add
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0  THEN
                CALL cl_err3("ins","faz_file",g_fay.fay01,g_faz[l_ac].faz02,SQLCA.SQLCODE,"","ins faz",1)  #No.FUN-660136
                CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET l_fay08 = '0'   #FUN-580109
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd = 'a'
            INITIALIZE g_faz[l_ac].* TO NULL      #900423
            LET g_faz[l_ac].faz08 = 0
            LET g_faz_t.* = g_faz[l_ac].*             #新輸入資料
            NEXT FIELD faz02
 
        BEFORE FIELD faz02                            #defaylt 序號
            IF p_cmd = 'a' OR p_cmd = 'u' THEN
               IF g_faz[l_ac].faz02 IS NULL OR g_faz[l_ac].faz02 = 0
               thEN SELECT max(faz02)+1 INTO g_faz[l_ac].faz02
                      FROM faz_file WHERE faz01 = g_fay.fay01
                    IF g_faz[l_ac].faz02 IS NULL THEN
                        LET g_faz[l_ac].faz02 = 1
                    END IF
               END IF
            END IF
 
        AFTER FIELD faz02                        #check 序號是否重複
            IF NOT cl_null(g_faz[l_ac].faz02) THEN
               IF g_faz[l_ac].faz02 != g_faz_t.faz02 OR
                  g_faz_t.faz02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM faz_file
                    WHERE faz01 = g_fay.fay01
                      AND faz02 = g_faz[l_ac].faz02
                   IF l_n > 0 THEN
                       LET g_faz[l_ac].faz02 = g_faz_t.faz02
                       CALL cl_err('',-239,0)
                       NEXT FIELD faz02
                   END IF
               END IF
            END IF

       #FUN-BC0004--mark--str
       ##TQC-AB0257 modify ---begin----------------------------
       #AFTER FIELD faz03
       #    IF g_faz[l_ac].faz03 != g_faz_t.faz03 OR
       #       g_faz_t.faz03 IS NULL THEN
       #        LET l_n = 0
       #        SELECT COUNT(*) INTO l_n FROM faj_file
       #         WHERE fajconf='Y'
       #           AND faj02 = g_faz[l_ac].faz03
       #        IF l_n = 0 THEN
       #            LET g_faz[l_ac].faz03 = g_faz_t.faz03
       #            CALL cl_err('','afa-911',0)
       #            NEXT FIELD faz03
       #        END IF
       #    END IF
       ##TQC-AB0257 modify ----end----------------------------- 
       #FUN-BC0004--mark--end
        #FUN-BC0004--add--str
        AFTER FIELD faz03
           IF g_faz[l_ac].faz031 IS NULL THEN
              LET g_faz[l_ac].faz031 = ' '
           END IF
           IF NOT cl_null(g_faz[l_ac].faz03) AND g_faz[l_ac].faz031 IS NOT NULL THEN
              SELECT count(*) INTO l_n FROM faj_file
               WHERE faj02 = g_faz[l_ac].faz03
              IF l_n > 0 THEN 
                 CALL t105_faz031('a')
                 IF NOT cl_null(g_errno) THEN 
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD faz031
                 ELSE
                    SELECT count(*) INTO l_n FROM faz_file
                     WHERE faz01  = g_fay.fay01
                       AND faz03  = g_faz[l_ac].faz03
                       AND faz031 = g_faz[l_ac].faz031
                       AND faz02 != g_faz[l_ac].faz02
                    IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       NEXT FIELD faz031
                    END IF
                    SELECT faj06 INTO g_faz[l_ac].faj06 FROM faj_file
                     WHERE faj02 = g_faz[l_ac].faz03 AND
                           (faj022 = g_faz[l_ac].faz031 OR faj022 IS NULL)
                    DISPLAY BY NAME g_faz[l_ac].faj06
                    SELECT COUNT(*) INTO l_cnt FROM fca_file
                     WHERE fca03  = g_faz[l_ac].faz03
                       AND fca031 = g_faz[l_ac].faz031
                       AND fca15  = 'N'
                    LET l_cnt1 = 0
                    IF g_faa.faa31 = 'Y' THEN
                       SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
                        WHERE fbn01 = g_faz[l_ac].faz03
                          AND fbn02 = g_faz[l_ac].faz031
                          AND ((fbn03 = YEAR(g_fay.fay02) AND fbn04 >= MONTH(g_fay.fay02))
                           OR fbn03 > YEAR(g_fay.fay02))
                          AND fbn041 = '1'   #MOD-BC0025 add
                    END IF
                    LET l_cnt = l_cnt + l_cnt1
                    IF l_cnt > 0 THEN
                       CALL cl_err(g_faz[l_ac].faz03,'afa-097',0)
                       NEXT FIELD faz03
                    END IF
                    SELECT COUNT(*) INTO l_cnt FROM fan_file
                     WHERE fan01 = g_faz[l_ac].faz03
                       AND fan02 = g_faz[l_ac].faz031
                       AND ((fan03 = YEAR(g_fay.fay02) AND fan04 >= MONTH(g_fay.fay02))
                        OR fan03 > YEAR(g_fay.fay02))
                       AND fan041 = '1'   #MOD-BC0025 add
                    IF l_cnt > 0 THEN
                       CALL cl_err(g_faz[l_ac].faz03,'afa-092',0)
                       NEXT FIELD faz03
                    END IF
                 END IF
              ELSE
                 CALL cl_err(g_faz[l_ac].faz03,'afa-093',0)     
                 LET g_faz[l_ac].faz03 = g_faz_t.faz03 
                 NEXT FIELD faz03
              END IF        
           END IF
           DISPLAY BY NAME g_faz[l_ac].faz03
            
        #FUN-BC0004--add--end
        AFTER FIELD faz031
           IF g_faz[l_ac].faz031 IS NULL THEN
              LET g_faz[l_ac].faz031 = ' '
           END IF
           #-->同張單據不可相同之財編資料
           SELECT count(*) INTO l_n FROM faz_file
           WHERE faz01  = g_fay.fay01
             AND faz03  = g_faz[l_ac].faz03
             AND faz031 = g_faz[l_ac].faz031
             AND faz02 != g_faz[l_ac].faz02
             IF l_n > 0 THEN
                 CALL cl_err('',-239,0)
                 NEXT FIELD faz03
             END IF
## ModIFy:2589     #若異動後年限已有值,則不再預設未用年限
            CALL t105_faz031('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_faz[l_ac].faz031,g_errno,0)
               LET g_faz[l_ac].faz03 = g_faz_t.faz03
               LET g_faz[l_ac].faz031 = g_faz_t.faz031
               neXT FIELD faz03
            END IF
        SELECT faj06 INTO g_faz[l_ac].faj06 FROM faj_file
         WHERE faj02 = g_faz[l_ac].faz03 AND
               (faj022 = g_faz[l_ac].faz031 OR faj022 IS NULL)
        DISPLAY BY NAME g_faz[l_ac].faj06
        SELECT COUNT(*) INTO l_cnt FROM fca_file
         WHERE fca03  = g_faz[l_ac].faz03
           AND fca031 = g_faz[l_ac].faz031
           AND fca15  = 'N'
        IF l_cnt > 0 THEN
           CALL cl_err(g_faz[l_ac].faz03,'afa-097',0)
           NEXT FIELD faz03
        END IF
        SELECT COUNT(*) INTO l_cnt FROM fan_file
         WHERE fan01 = g_faz[l_ac].faz03
           AND fan02 = g_faz[l_ac].faz031
           AND ((fan03 = YEAR(g_fay.fay02) AND fan04 >= MONTH(g_fay.fay02))
            OR fan03 > YEAR(g_fay.fay02))
           AND fan041 = '1'   #MOD-BC0025 add
        #FUN-AB0088---add---str---
        LET l_cnt1 = 0
        IF g_faa.faa31 = 'Y' THEN
           SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
            WHERE fbn01 = g_faz[l_ac].faz03
             AND fbn02 = g_faz[l_ac].faz031
             AND ((fbn03 = YEAR(g_fay.fay02) AND fbn04 >= MONTH(g_fay.fay02))
              OR fbn03 > YEAR(g_fay.fay02))
             AND fbn041 = '1'   #MOD-BC0025 add
        END IF
        LET l_cnt = l_cnt + l_cnt1
        #FUN-AB0088---add---end---
   
        IF l_cnt > 0 THEN
           CALL cl_err(g_faz[l_ac].faz03,'afa-092',0)
           NEXT FIELD faz03
        END IF
 
        AFTER FIELD faz08
            LET g_faz[l_ac].faz08 = cl_numfor(g_faz[l_ac].faz08,18,g_azi04)
            DISPLAY BY NAME g_faz[l_ac].faz08
            IF cl_null(g_e[l_ac].faz17) OR g_e[l_ac].faz17 = 0
            THEN LET g_e[l_ac].faz17 = g_faz[l_ac].faz08
            END IF
 
 
        AFTER FIELD faz09
            IF (cl_null(g_faz[l_ac].faz09) OR g_faz[l_ac].faz09 = 0)
              AND g_faz[l_ac].faz05 !=0 THEN
                  NEXT FIELD faz09
            END IF
            IF cl_null(g_e[l_ac].faz18) OR g_e[l_ac].faz18 = 0
            THEN LET g_e[l_ac].faz18 = g_faz[l_ac].faz09
            END IF
            IF g_aza.aza26 = '2' THEN
               SELECT DISTINCT(fab23) INTO l_fab23 FROM fab_file,faj_file
                WHERE fab01  = faj04
                  AND faj02  = g_faz[l_ac].faz03
                  AND faj022 = g_faz[l_ac].faz031
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("sel","fab_file,faj_file",g_faz[l_ac].faz03,g_faz[l_ac].faz031,SQLCA.SQLCODE,"","",1)  #No.FUN-660136
                  LET g_success = 'N' RETURN
               END IF
               IF g_faj28 MATCHES '[05]' THEN
                  LET l_faz10 = 0
                  LET l_faz19 = 0
               ELSE
                  LET l_faz10 = (g_faz[l_ac].faz04 + g_faz[l_ac].faz08) *
                                 l_fab23/100
                  #--->稅簽預留殘值
                  LET l_faz19 = (g_e[l_ac].faz13 + g_e[l_ac].faz17) *
                                 l_fab23/100
                  LET g_e[l_ac].faz19 = l_faz19
               END IF
               LET g_faz[l_ac].faz10 = l_faz10
               DISPLAY BY NAME g_faz[l_ac].faz10
               DISPLAY BY NAME g_e[l_ac].faz19
               DISPLAY BY NAME g_faz[l_ac].faz10
            ELSE
               CASE g_faj28
                 WHEN '0'
                   LET l_faz10 = g_faz[l_ac].faz06
                   LET l_faz10 = cl_digcut(l_faz10,g_azi04)
                   LET g_faz[l_ac].faz10 = l_faz10
                   LET l_faz19 = g_faz[l_ac].faz06
                   LET l_faz19 = cl_digcut(l_faz19,g_azi04)
                   LET g_e[l_ac].faz19 = l_faz19
                 WHEN '1'
                   LET l_faz10 = (g_faz[l_ac].faz04+g_faz[l_ac].faz08)
                                 /(g_faz[l_ac].faz09+12)*12 
                   LET l_faz10 = cl_digcut(l_faz10,g_azi04)
                   LET g_faz[l_ac].faz10 = l_faz10
                   LET l_faz19 = (g_e[l_ac].faz13+g_e[l_ac].faz17)
                                 /(g_e[l_ac].faz18+12)*12
                   LET l_faz19 = cl_digcut(l_faz19,g_azi04)
                   LET g_e[l_ac].faz19 = l_faz19
                 WHEN '2'
                   LET l_faz10 = 0
                   LET l_faz10 = cl_digcut(l_faz10,g_azi04)
                   LET g_faz[l_ac].faz10 = l_faz10
                   LET l_faz19 = 0
                   LET l_faz19 = cl_digcut(l_faz19,g_azi04)
                   LET g_e[l_ac].faz19 = l_faz19
                 WHEN '3'
                   LET l_faz10 = (g_faz[l_ac].faz04+g_faz[l_ac].faz08)/10
                   LET l_faz10 = cl_digcut(l_faz10,g_azi04)
                   LET g_faz[l_ac].faz10 = l_faz10
                   LET l_faz19 = (g_e[l_ac].faz13+g_e[l_ac].faz17)/10
                   LET l_faz19 = cl_digcut(l_faz19,g_azi04)
                   LET g_e[l_ac].faz19 = l_faz19
                 WHEN '4'
                   LET l_faz10 = g_faz[l_ac].faz06
                   LET l_faz10 = cl_digcut(l_faz10,g_azi04)
                   LET g_faz[l_ac].faz10 = l_faz10
                   LET l_faz19 = g_faz[l_ac].faz06
                   LET l_faz19 = cl_digcut(l_faz19,g_azi04)
                   LET g_e[l_ac].faz19 = l_faz19
                 WHEN '5'
                   LET l_faz10 = g_faz[l_ac].faz06
                   LET l_faz10 = cl_digcut(l_faz10,g_azi04)
                   LET g_faz[l_ac].faz10 = l_faz10
                   LET l_faz19 = g_faz[l_ac].faz06
                   LET l_faz19 = cl_digcut(l_faz19,g_azi04)
                   LET g_e[l_ac].faz19 = l_faz19
               END CASE
            END IF 
 
      AFTER FIELD faz10
         IF g_faz[l_ac].faz10 <0 THEN                                           
            CALL cl_err(g_faz[l_ac].faz10,'aim-391',1)                          
            LET g_faz[l_ac].faz10 = g_faz_t.faz10                               
            NEXT FIELD faz10                                                    
         END IF                                                                 
         LET g_faz[l_ac].faz10 = cl_digcut(g_faz[l_ac].faz10,g_azi04)
         DISPLAY BY NAME g_faz[l_ac].faz10
 
        BEFORE FIELD faz12
            IF p_cmd = 'a' AND l_ac > 1 THEN
               LET g_faz[l_ac].faz12 = g_faz[l_ac-1].faz12
               DISPLAY BY NAME g_faz[l_ac].faz12
            END IF 
 
        AFTER FIELD faz12
            IF NOT cl_null(g_faz[l_ac].faz12) THEN
               CALL t105_faz12('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_faz[l_ac].faz12 = g_faz_t.faz12
                  DISPLAY BY NAME g_faz[l_ac].faz12
                  CALL cl_err(g_faz[l_ac].faz12,g_errno,0)
                  NEXT FIELD faz12
               END IF
            END IF 
 
        BEFORE DELETE                            #是否取消單身
            IF g_faz_t.faz02 > 0 AND g_faz_t.faz02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM faz_file WHERE faz01 = g_fay.fay01
                                       AND faz02 = g_faz_t.faz02
                IF SQLCA.SQLCODE THEN
                    CALL cl_err3("del","faz_file",g_fay.fay01,g_faz_t.faz02,SQLCA.SQLCODE,"","",1)  #No.FUN-660136
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET l_fay08 = '0'   #FUN-580109
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_faz[l_ac].* = g_faz_t.*
               CLOSE t105_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_faz[l_ac].faz02,-263,1)
               LET g_faz[l_ac].* = g_faz_t.*
            ELSE
               IF cl_null(g_faz[l_ac].faz12) THEN
                  LET g_faz[l_ac].faz12 = ' '
               END IF
               UPDATE faz_file SET faz01=g_fay.fay01,
                                   faz02=g_faz[l_ac].faz02,
                                   faz03=g_faz[l_ac].faz03,
                                   faz031=g_faz[l_ac].faz031,
                                   faz04=g_faz[l_ac].faz04,
                                   faz05=g_faz[l_ac].faz05,
                                   faz06=g_faz[l_ac].faz06,
                                   faz08=g_faz[l_ac].faz08,
                                   faz09=g_faz[l_ac].faz09,
                                   faz10=g_faz[l_ac].faz10,
                                   faz12=g_faz[l_ac].faz12,  #NO.MOD-5C0016 ADD
                                   faz18=g_e[l_ac].faz18,
                                   faz19= g_e[l_ac].faz19
                                   ,fazud01 = g_faz[l_ac].fazud01,
                                   fazud02 = g_faz[l_ac].fazud02,
                                   fazud03 = g_faz[l_ac].fazud03,
                                   fazud04 = g_faz[l_ac].fazud04,
                                   fazud05 = g_faz[l_ac].fazud05,
                                   fazud06 = g_faz[l_ac].fazud06,
                                   fazud07 = g_faz[l_ac].fazud07,
                                   fazud08 = g_faz[l_ac].fazud08,
                                   fazud09 = g_faz[l_ac].fazud09,
                                   fazud10 = g_faz[l_ac].fazud10,
                                   fazud11 = g_faz[l_ac].fazud11,
                                   fazud12 = g_faz[l_ac].fazud12,
                                   fazud13 = g_faz[l_ac].fazud13,
                                   fazud14 = g_faz[l_ac].fazud14,
                                   fazud15 = g_faz[l_ac].fazud15
                WHERE faz01=g_fay.fay01 AND faz02=g_faz_t.faz02
 
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                  CALL cl_err3("upd","faz_file",g_fay.fay01,g_faz_t.faz02,SQLCA.SQLCODE,"","upd faz",1)  #No.FUN-660136
                  LET g_faz[l_ac].* = g_faz_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  LET l_fay08 = '0'   #FUN-580109
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_faz[l_ac].* = g_faz_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_faz.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE t105_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add
            CLOSE t105_bcl
            COMMIT WORK
           #CALL g_faz.deleteElement(g_rec_b+1) #FUN-D30032 mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(faz02) AND l_ac > 1 THEN
                LET g_faz[l_ac].* = g_faz[l_ac-1].*
                LET g_faz[l_ac].faz02 = NULL
                NEXT FIELD faz02
            END IF
 
        ON ACTION tax_data  #稅簽資料
            CASE WHEN INFIELD(faz08)
                      CALL t105_e(p_cmd)
                 WHEN INFIELD(faz09)
                      CALL t105_e(p_cmd)
                 WHEN INFIELD(faz10)
                      CALL t105_e(p_cmd)
                 WHEN INFIELD(faz02)
                      CALL t105_e(p_cmd)
                 WHEN INFIELD(faz03)
                      CALL t105_e(p_cmd)
                 WHEN INFIELD(faz031)
                      CALL t105_e(p_cmd)
            END CASE
        ON ACTION controlp
           CASE
              WHEN INFIELD(faz03)  #財產編號,財產附號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_faj4"  #MOD-780232 mod
                   LET g_qryparam.default1 = g_faz[l_ac].faz03
                   LET g_qryparam.default2 = g_faz[l_ac].faz031
                   CALL cl_create_qry() RETURNING
                           g_faz[l_ac].faz03,g_faz[l_ac].faz031
                   DISPLAY g_faz[l_ac].faz03 TO far03
                   DISPLAY g_faz[l_ac].faz031 TO far031
                   NEXT FIELD faz03
              WHEN INFIELD(faz12)  #異動原因
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_fag"
                   LET g_qryparam.arg1 = "7"
                   LET g_qryparam.default1 = g_faz[l_ac].faz12
                   CALL cl_create_qry() RETURNING g_faz[l_ac].faz12
                   DISPLAY 'faz12:',g_faz[l_ac].faz12
                   DISPLAY g_faz[l_ac].faz12 TO faz12
                   NEXT FIELD faz12
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
            CONTINUE INPUT
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
    END INPUT
 
    LET g_fay.faymodu = g_user
    LET g_fay.faydate = g_today
    UPDATE fay_file SET faymodu = g_fay.faymodu,faydate = g_fay.faydate
     WHERE fay01 = g_fay.fay01
    DISPLAY BY NAME g_fay.faymodu,g_fay.faydate
 
    UPDATE fay_file SET fay08=l_fay08 WHERE fay01 = g_fay.fay01
    LET g_fay.fay08 = l_fay08
    DISPLAY BY NAME g_fay.fay08
    IF g_fay.fayconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_fay.fay08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_fay.fayconf,g_chr2,g_fay.faypost,"",g_chr,"")
 
    CLOSE t105_bcl
    COMMIT WORK
    CALL t105_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t105_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_fay.fay01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fay_file ",
                  "  WHERE fay01 LIKE '",l_slip,"%' ",
                  "    AND fay01 > '",g_fay.fay01,"'"
      PREPARE t105_pb1 FROM l_sql 
      EXECUTE t105_pb1 INTO l_cnt 
      
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
        #CALL t105_x()            #FUN-D20035
         CALL t105_x(1)           #FUN-D20035
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 7
                                AND npp01 = g_fay.fay01
                                AND npp011= 1
         DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 7
                                AND npq01 = g_fay.fay01
                                AND npq011= 1
         DELETE FROM tic_file WHERE tic04 = g_fay.fay01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM fay_file WHERE fay01 = g_fay.fay01
         INITIALIZE g_fay.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t105_faz031(p_cmd)
DEFINE   p_cmd       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_n         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
         l_faj06     LIKE faj_file.faj06,
         l_faj33     LIKE faj_file.faj33,
         l_faj331    LIKE faj_file.faj331,        #MOD-970231 add
         l_faj30     LIKE faj_file.faj30,
         l_faj31     LIKE faj_file.faj31,
         l_faj35     LIKE faj_file.faj35,
         l_faj68     LIKE faj_file.faj68,
         l_faj65     LIKE faj_file.faj65,
         l_faj66     LIKE faj_file.faj66,
         l_faj72     LIKE faj_file.faj72,
         l_faj100    LIKE faj_file.faj100,
         l_faj43     LIKE faj_file.faj43,
         l_fajconf   LIKE faj_file.fajconf
 
   LET g_errno = ' '
   #CHI-B80007 -- begin --
   SELECT count(*) INTO l_n FROM faz_file,fay_file
     WHERE faz01 = fay01
      AND faz03  = g_faz[l_ac].faz03
      AND faz031 = g_faz[l_ac].faz031
      AND fay02 <= g_fay.fay02
      AND faypost = 'N'
      AND fay01 != g_fay.fay01
      AND fayconf <> 'X'
   IF l_n  > 0 THEN
       LET g_errno = 'afa-309'
       RETURN
   END IF
   #CHI-B80007 -- end --
   SELECT faj06,faj33,faj30,faj31,faj35,faj68,faj65,faj66,faj72,
          faj28,faj100,faj43,fajconf,faj331  #MOD-970231 add faj331
     INTO l_faj06,l_faj33,l_faj30,l_faj31,l_faj35,l_faj68,l_faj65,l_faj66,
          l_faj72,g_faj28,l_faj100,l_faj43,l_fajconf,l_faj331  #MOD-970231 add l_faj331
     FROM faj_file
    WHERE faj02  = g_faz[l_ac].faz03
      AND faj022 = g_faz[l_ac].faz031
   CASE
     #WHEN SQLCA.SQLCODE = 100        LET g_errno = 'afa-093'    #MOD-C70265 mark
      WHEN SQLCA.SQLCODE = 100        LET g_errno = 'afa-134'    #MOD-C70265 add
      WHEN l_fajconf  = 'N'           LET g_errno = 'afa-312'
      WHEN l_faj43  MATCHES '[056X]'  LET g_errno = 'afa-313'
      OTHERWISE                       LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF l_faj43 = '7' THEN    #折畢再提
      LET l_faj31 = l_faj35
      LET l_faj66 = l_faj72
   END IF
#  IF p_cmd = 'a' AND cl_null(g_errno) THEN                  #MOD-950166   #MOD-C30746 MARK
   IF cl_null(g_errno) THEN                      #MOD-C30746
      LET g_faz[l_ac].faz04 = l_faj33+l_faj331   #未折減額   #MOD-970231
      LET g_faz[l_ac].faz05 = l_faj30   #未用年限
      LET g_faz[l_ac].faz06 = l_faj31   #預估殘值
      LET g_faz[l_ac].faz09 = l_faj30
      LET g_faz[l_ac].faj06 = l_faj06
      LET g_faz[l_ac].faz10 = l_faj31   #異動後預估殘值   #MOD-5B0272
      LET g_e[l_ac].faz13   = l_faj68
      LET g_e[l_ac].faz14   = l_faj65
      LET g_e[l_ac].faz15   = l_faj66
      LET g_e[l_ac].faz17   = g_faz[l_ac].faz08
      LET g_e[l_ac].faz18   = l_faj65
   END IF
END FUNCTION
 
FUNCTION t105_faz12(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_fag01    LIKE fag_file.fag01,
       l_fagacti  LIKE fag_file.fagacti
 
    LET g_errno = ' '
    SELECT fag01,fagacti INTO l_fag01,l_fagacti FROM fag_file
     WHERE fag01 = g_faz[l_ac].faz12 AND fag02 = '7'
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-099'
                                LET l_fag01 = NULL
                                LET l_fagacti = NULL
       WHEN l_fagacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t105_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON faz02,faz03,faz031,faz04,faz05,faz06,faz08,
                       faz09,faz10,faz12
         FROM s_faz[1].faz02, s_faz[1].faz03,s_faz[1].faz031,s_faz[1].faz04,
              s_faz[1].faz05,s_faz[1].faz06,s_faz[1].faz08,
              s_faz[1].faz09,s_faz[1].faz10,s_faz[1].faz12
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
          CONTINUE CONSTRUCT
 
    END CONSTRUCT
    IF INT_FLAG tHEN
       LET INT_FLAG = 0
       RETURN
    END IF
    CALL t105_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t105_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    LET g_sql =
        "SELECT faz02,faz03,faz031,faj06,faz04,faz08,faz05,",
        " faz09,faz06,faz10,faz12",
        "       ,fazud01,fazud02,fazud03,fazud04,fazud05,",
        "       fazud06,fazud07,fazud08,fazud09,fazud10,",
        "       fazud11,fazud12,fazud13,fazud14,fazud15", 
        "  FROM faz_file LEFT OUTER JOIN faj_file ON faz03=faj02 AND faz031=faj022 ",
        " WHERE faz01  ='",g_fay.fay01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE t105_pb FROM g_sql
    DECLARE faz_curs                       #SCROLL CURSOR
        CURSOR FOR t105_pb
 
    CALL g_faz.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH faz_curs INTO g_faz[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,0) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_faz.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t105_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_faz TO s_faz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
        #IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
        #FUN-C30140--mark---str---
        #IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 add   
        #   CALL cl_set_act_visible("entry_sheet2",TRUE)
        #ELSE
        #   CALL cl_set_act_visible("entry_sheet2",FALSE)
        #END IF
        #FUN-C30140--mark---end---
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ##########################################################################
      # standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
     #ON ACTION deLETe                     #MOD-AC0067 mark
      ON ACTION delete                     #MOD-AC0067
        #LET g_action_choice="deLETe"      #MOD-AC0067 mark
         LET g_action_choice="delete"      #MOD-AC0067
         EXIT DISPLAY
      ON ACTION modify  #No:TQC-B10268
         LET g_action_choice="modify"  #No:TQC-B10268
         EXIT DISPLAY
      ON ACTION first
         CALL t105_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
 
      ON ACTION previous
         CALL t105_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
 
      ON ACTION jump
         CALL t105_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
 
      ON ACTION next
         CALL t105_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
 
      ON ACTION last
         CALL t105_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         IF g_fay.fayconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_fay.fay08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_fay.fayconf,g_chr2,g_fay.faypost,"",g_chr,"")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # special 4ad ACTION
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
      #@ON ACTION 會計分錄二產生
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
        EXIT DISPLAY#No.FUN-6B0029--begin                                             
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
      ON ACTION fin_audit2   #財簽二
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
      LET g_action_choice="exit"    
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
         CONTINUE DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
    ON ACTION easyflow_approval
       LET g_action_choice = 'easyflow_approval'
       EXIT DISPLAY
 
    ON ACTION approval_STATUS
       LET g_action_choice="approval_STATUS"
       EXIT DISPLAY
 
    ON ACTION agree
       LET g_action_choice = 'agree'
       EXIT DISPLAY
 
    ON ACTION deny
       LET g_action_choice = 'deny'
       EXIT DISPLAY
 
    ON ACTION modify_flow  #No:TQC-B10268
       LET g_action_choice = 'modify_flow'  #No:TQC-B10268
       EXIT DISPLAY
 
    ON ACTION withdraw
       LET g_action_choice = 'withdraw'
       EXIT DISPLAY
 
    ON ACTION org_withdraw
       LET g_action_choice = 'org_withdraw'
       EXIT DISPLAY
 
    ON ACTION phrase
       LET g_action_choice = 'phrase'
       EXIT DISPLAY #FUN-C30140 add
    ON ACTION controls                                        
       CALL cl_set_head_visible("","AUTO")                    
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t105_bp_refresh()
   DISPLAY ARRAY g_faz TO s_faz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         CONTINUE DISPLAY
 
   END DISPLAY
END FUNCTION
 
 
#---自動產生-------
FUNCTION t105_g()
 DEFINE ls_tmp STRING
 DEFINE  l_wc        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(300)
         l_sql       LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(600)
         l_faj       RECORD
                     faj02     LIKE faj_file.faj02,
                     faj022    LIKE faj_file.faj022,
                     faj06     LIKE faj_file.faj06,
                     faj33     LIKE faj_file.faj33,
                     faj331    LIKE faj_file.faj331,    #MOD-970231 add
                     faj30     LIKE faj_file.faj30,
                     faj31     LIKE faj_file.faj31,
                     faj68     LIKE faj_file.faj68,
                     faj65     LIKE faj_file.faj65,
                     faj66     LIKE faj_file.faj66
                     END RECORD,
         ans         LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_cnt       LIKE type_file.num5,        #CHI-B80007 add
         l_i         LIKE type_file.num5         #No.FUN-680070 SMALLINT
#FUN-BB0122--being add
   DEFINE l_faj332    LIKE faj_file.faj332,
          l_faj3312   LIKE faj_file.faj3312,
          l_faj302    LIKE faj_file.faj302,
          l_faj312    LIKE faj_file.faj312,
          l_faj432    LIKE faj_file.faj432,
          l_faj352    LIKE faj_file.faj352          
#FUN-BB0122--end add
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fay.fay01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fay.fayconf='Y' THEN CALL cl_err(g_fay.fay01,'afa-107',0) RETURN END IF
   IF g_fay.fayconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
    IF NOT cl_confirm('afa-103') THEN RETURN END IF     #No.MOD-490235
      LET INT_FLAG = 0

  #---------詢問是否自動新增單身--------------
      LET p_row = 10 LET p_col =22
      OPEN WINDOW t105_w2 AT p_row,p_col WITH FORM "afa/42f/afat105g"
      ATTRIBUTE (STYLE = g_win_style)
 
      CALL cl_ui_locale("afat105g")
 
     #CONSTRUCT bY NAME l_wc ON faj01,faj02,faj022,faj53         #No.FUN-B50118 mark
      CONSTRUCT bY NAME l_wc ON faj01,faj93,faj02,faj022,faj53   #No.FUN-B50118 add
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
            contiNUE CONSTRUCT
 
      END CONSTRUCT
      IF l_wc = " 1=1" THEN
         CALL cl_err('','abm-997',1)
         LET INT_FLAG = 1 
      END IF 
      IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t105_w2 RETURN END IF
 
      LET l_sql ="SELECT faj02,faj022,faj06,faj33,faj331,faj30,faj31,faj68,",   #MOD-970231 add faj331
                 "       faj65,faj66 ",
                 "  FROM faj_file",
                 " WHERE faj43 NOT IN ('0','5','6','X') AND fajconf = 'Y' ",
                 "   AND ",l_wc CLIPPED,
                 " ORDER BY 1"
      PREPARE t105_prepare_g FROM l_sql
      IF SQLCA.SQLCODE THEN
         CALL cl_err('prepare:',SQLCA.SQLCODE,0)
         RETURN
      END IF
      DECLARE t105_curs2 CURSOR FOR t105_prepare_g
 
      SELECT max(faz02)+1 INTO l_i FROM faz_file
       WHERE faz01 = g_fay.fay01
      IF SQLCA.SQLCODE THEN LET l_i = 1 END IF
      IF cl_null(l_i) THEN LET l_i = 1 END IF
      FOREACH t105_curs2 INTO l_faj.*
         IF SQLCA.SQLCODE != 0 THEN
            CALL cl_err('t105_curs2 foreach:',SQLCA.SQLCODE,0)
            EXIT foREACH
         END IF
         #no:4532檢查資產盤點期間應不可做異動
         SELECT COUNT(*) INTO g_cnt FROM fca_file
          WHERE fca03  = l_faj.faj02
            AND fca031 = l_faj.faj022
            AND fca15  = 'N'
         IF g_cnt > 0 THEN
            CALL cl_err(l_faj.faj02,'afa-097',0)
            CONTINUE FOREACH
         END IF
        SELECT COUNT(*) INTO g_cnt FROM fan_file
         WHERE fan01 = l_faj.faj02
           AND fan02 = l_faj.faj022
           AND ((fan03 = YEAR(g_fay.fay02) AND fan04 >= MONTH(g_fay.fay02))
            OR fan03 > YEAR(g_fay.fay02))
           AND fan041 = '1'   #MOD-BC0025 add
        #FUN-AB0088---add---str---
        LET g_cnt1 = 0
         IF g_faa.faa31 = 'Y' THEN
             SELECT COUNT(*) INTO g_cnt1 FROM fbn_file
              WHERE fbn01 = l_faj.faj02
                AND fbn02 = l_faj.faj022
                AND ((fbn03 = YEAR(g_fay.fay02) AND fbn04 >= MONTH(g_fay.fay02))
                 OR fbn03 > YEAR(g_fay.fay02))
                AND fbn041 = '1'   #MOD-BC0025 add
         END IF
         LET g_cnt = g_cnt + g_cnt1
        #FUN-AB0088---add---end---
        IF g_cnt > 0 THEN
           CALL cl_err(l_faj.faj02,'afa-092',0)
           CONTINUE FOREACH
        END IF
        #CHI-B80007 -- begin --
        SELECT count(*) INTO l_cnt FROM faz_file,fay_file
         WHERE faz01 = fay01
           AND faz03 = l_faj.faj02
           AND faz031= l_faj.faj022
           AND fay02 <= g_fay.fay02
           AND faypost = 'N'
           AND fay01 != g_fay.fay01
           AND fayconf <> 'X'
        IF l_cnt  > 0 THEN
           CONTINUE FOREACH
        END IF
        #CHI-B80007 -- end --
         #FUN-BB0122--being add
         SELECT faj332,faj3312,faj302,faj312,faj432,faj352
          INTO l_faj332,l_faj3312,l_faj302,l_faj312,l_faj432,l_faj352
            FROM faj_file
            WHERE faj02 =l_faj.faj02
            AND faj022 = l_faj.faj022
          IF l_faj432 = '7' THEN    #折畢再提
             LET l_faj312 = l_faj352
          END IF
          IF cl_null(l_faj332) THEN LET l_faj332 = 0 END IF
          IF cl_null(l_faj3312) THEN LET l_faj3312 = 0 END IF
          IF cl_null(l_faj302) THEN LET l_faj302 = 0 END IF
          IF cl_null(l_faj312) THEN LET l_faj312 = 0 END IF
         #FUN-BB0122--end add
         #CHI-C60010---str---
          CALL cl_digcut(l_faj332,g_azi04_1) RETURNING l_faj332
          CALL cl_digcut(l_faj3312,g_azi04_1) RETURNING l_faj3312
          CALL cl_digcut(l_faj312,g_azi04_1) RETURNING l_faj312
         #CHI-C60010---end---
        INSERT INTO faz_file (faz01,faz02,faz03,faz031,faz04,faz05,faz06,faz08,
                              faz09,faz10,faz13,faz14,faz15,faz17,faz18,faz19,fazlegal, #FUN-980003 add
                              faz042,faz052,faz062,faz082,faz092,faz102)   #No:FUN-BB0122 add
        VALUES (g_fay.fay01,l_i,l_faj.faj02,l_faj.faj022,l_faj.faj33+l_faj.faj331,   #MOD-970231
                l_faj.faj30,l_faj.faj31,0,l_faj.faj30,l_faj.faj31,
                l_faj.faj68,l_faj.faj65,l_faj.faj66,0,l_faj.faj65,
                l_faj.faj66,g_legal, #FUN-980003 add
				l_faj332+l_faj3312,l_faj302,l_faj312,0,l_faj302,l_faj312) #FUN-BB0122 add
       IF STATUS  THEN
          CALL cl_err3("ins","faz_file",g_fay.fay01,l_i,STATUS,"","ins faz",1)  #No.FUN-660136
          EXIT FOREACH
       END IF
       LET l_i = l_i + 1
     END FOREACH
     CLOSE window t105_w2
     CALL t105_b_fill(l_wc)
END FUNCTION 
 
FUNCTION t105_k()
   DEFINE g_faz     DYNAMIC ARRAY OF RECORD
                    faz02	LIKE faz_file.faz02,
                    faz03	LIKE faz_file.faz03,
                    faj06	LIKE faj_file.faj06,
                    faz031	LIKE faz_file.faz031,
                    faz04	LIKE faz_file.faz04,
                    faz08	LIKE faz_file.faz08,
                    faz05	LIKE faz_file.faz05,
                    faz09	LIKE faz_file.faz09,
                    faz06	LIKE faz_file.faz06,
                    faz10	LIKE faz_file.faz10,
                    faz12	LIKE faz_file.faz12,
                    faz13	LIKE faz_file.faz13,
                    faz14	LIKE faz_file.faz14,
                    faz15	LIKE faz_file.faz15,
                    faz17	LIKE faz_file.faz17,
                    faz18	LIKE faz_file.faz18,
                    faz19	LIKE faz_file.faz19
                    END RECORD
   DEFINE g_faz_t   RECORD
                    faz02	LIKE faz_file.faz02,
                    faz03	LIKE faz_file.faz03,
                    faj06	LIKE faj_file.faj06,
                    faz031	LIKE faz_file.faz031,
                    faz04	LIKE faz_file.faz04,
                    faz08	LIKE faz_file.faz08,
                    faz05	LIKE faz_file.faz05,
                    faz09	LIKE faz_file.faz09,
                    faz06	LIKE faz_file.faz06,
                    faz10	LIKE faz_file.faz10,
                    faz12	LIKE faz_file.faz12,
                    faz13	LIKE faz_file.faz13,
                    faz14	LIKE faz_file.faz14,
                    faz15	LIKE faz_file.faz15,
                    faz17	LIKE faz_file.faz17,
                    faz18	LIKE faz_file.faz18,
                    faz19	LIKE faz_file.faz19
                    END RECORD
   DEFINE l_faz19         LIKE faz_file.faz19  #No.FUN-4C0008
   DEFINE l_faj28         LIKE faj_file.faj28
   DEFINE l_lock_sw       LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE l_modify_flag   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)  #No:TQC-B10268
   DEFINE p_cmd           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE i,j,k           LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE ls_tmp          STRING
   DEFINE l_allow_insert  LIKE type_file.num5                #可新增否       #No.FUN-680070 SMALLINT
  #DEFINE l_allow_DELETE  LIKE type_file.num5                #可刪除否       #No.FUN-680070 SMALLINT #MOD-AC0067 mod
   DEFINE l_allow_delete  LIKE type_file.num5                #可刪除否       #No.FUN-680070 SMALLINT #MOD-AC0067 mod  #Mod No:TQC-B10268
   DEFINE l_fab23         LIKE fab_file.fab23     #No:A099
   DEFINE l_cnt           LIKE type_file.num5   #CHI-860025
 
   IF g_fay.fay01 IS NULL THEN RETURN END IF
   IF g_fay.fayconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_fay.faypost2 = 'Y' THEN CALL cl_err('','afa-138',0) RETURN END IF   #MOD-590215
   #FUN-C30140---add---str---
   IF NOT cl_null(g_fay.fay08) AND g_fay.fay08 matches '[Ss]' THEN     
       CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
       RETURN
   END IF 
   #FUN-C30140---add---end---
   LET p_row = 10 LET p_col = 17
   OPEN WINDOW t105_w5 AT p_row,p_col WITH FORM "afa/42f/afat1052"
   ATTRIBUTE (styLE = g_win_style)
 
    CALL cl_ui_locale("afat1052")
 
   DECLARE t105_kkk_c CURSOR FOR
         SELECT faz02, faz03, faj06,faz031, faz04, faz08,
                faz05, faz09, faz06, faz10, faz12,
                faz13, faz14, faz15, faz17, faz18, faz19
           FROM faz_file LEFT OUTER JOIN faj_file ON faz03 = faj02 AND faz031 = faj022
          WHERE faz01 = g_fay.fay01
          ORDER BY 1
   CALL g_faz.clear()
   LET k = 1
   FOREACH t105_kkk_c INTO g_faz[k].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('t106_kkk_c',SQLCA.SQLCODE,0)
         EXIT FOREACH
      END IF
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt FROM fao_file
       WHERE fao01 = g_faz[k].faz03
         AND fao02 = g_faz[k].faz031
         AND ((fao03 = YEAR(g_fay.fay02) AND fao04 >= MONTH(g_fay.fay02))
          OR fao03 > YEAR(g_fay.fay02))
         AND fao041 = '1'   #MOD-BC0025 add
      IF l_cnt > 0 THEN
         CALL cl_err(g_faz[k].faz03,'afa-092',0)
         CONTINUE FOREACH
      END IF
      LET k = k + 1
      IF k > 200 THEN EXIT FOREACH END IF
   END FOREACH 
   CALL g_faz.deLETeElement(k)   #CHI-860025
   LET k = k - 1
   CALL set_count(k)
   SELECT * FROM fay_file WHERE fay01 = g_fay.fay01
 
   DISPLAY BY NAME g_fay.fayconf, g_fay.faypost,g_fay.faypost1,g_fay.faypost2,  #No:FUN-B60140
                   g_fay.fayuser, g_fay.faygrup, g_fay.faymodu,g_fay.faydate
 
   LET l_allow_insert = cl_detail_input_auth("insert")
  #LET l_allow_deLETe = cl_detail_INPUT_auth("deLETe")     #MOD-AC0067 mark
  #LET l_allow_DELETE = cl_detail_INPUT_auth("delete")     #MOD-AC0067
   LET l_allow_delete = cl_detail_INPUT_auth("delete")     #MOD-AC0067  #Mod No:TQC-B10268
 
   INPUT ARRAY g_faz WITHOUT DEFAULTS FROM s_faz.*
         ATTRIBUTE(COUNT=k,MAXCOUNT=g_max_rec,UNBUFFERED,
                  #INSERT ROW=l_allow_insert,DELETE ROW=l_allow_deLETe,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,  #Mod No:TQC-B10268
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
          CALL fgl_set_arr_curr(l_ac)
 
      BEFORE ROW
         LET i = ARR_CURR() LET j = SCR_LINE()
         LET g_faz_t.* = g_faz[i].*
         LET l_lock_sw = 'N'
         IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_success = 'Y'
         ELSE
              LET g_success = 'Y'
              LET p_cmd='a'
              INITIALIZE g_faz[i].* TO NULL
         END IF
      BEFORE FIELD faz19
         SELECT faj61 INTO l_faj28 FROM faj_file      #No:A099
                      WHERE faj02 = g_faz[i].faz03
                        AND faj022= g_faz[i].faz031
         IF SQLCA.SQLCODE THEN LET l_faj28 = ' ' END IF
         IF g_aza.aza26 = '2' THEN
            SELECT DISTINCT(fab23) INTO l_fab23 FROM fab_file,faj_file
             WHERE fab01  = faj04
               AND faj02  = g_faz[i].faz03
               AND faj022 = g_faz[i].faz031
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("sel","fab_file,faj_file",g_faz[i].faz03,g_faz[i].faz031,SQLCA.SQLCODE,"","",1)  #No.FUN-660136
               LET g_success = 'N' RETURN
            END IF
            IF l_faj28 MATCHES '[05]' THEN
               LET l_faz19 = 0
            ELSE
               LET l_faz19=(g_faz[i].faz13 + g_faz[i].faz17) * l_fab23/100
            END IF
            LET g_faz[i].faz19 = l_faz19
            DISPLAY g_faz[i].faz19 TO s_faz[j].faz19
         ELSE
            CASE
              WHEN l_faj28 = '0'
                   LET g_faz[i].faz19 = 0
                   DISPLAY g_faz[i].faz19 TO s_faz[j].faz19
              WHEN l_faj28 = '1'
                   LET l_faz19=(g_faz[i].faz13 + g_faz[i].faz17 )
                               /(g_faz[i].faz18 + 12)*12
                   LET g_faz[i].faz19 = l_faz19
                   DISPLAY g_faz[i].faz19 TO s_faz[j].faz19
            END CASE
         END IF
 
      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_faz[i].* = g_faz_t.*
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_faz[i].faz02,-263,1)
             LET g_faz[i].* = g_faz_t.*
          ELSE
             IF g_faz[i].faz03 IS NULL THEN
                iNITIALIZE g_faz[i].* TO NULL
             END IF
             UPDATE faz_file SET faz17 = g_faz[i].faz17,
                                 faz18 = g_faz[i].faz18,
                                 faz19 = g_faz[i].faz19
                           WHERE faz01 = g_fay.fay01 AND faz02 = g_faz_t.faz02
             IF STATUS THEN
                  CALL cl_err3("upd","faz_file",g_fay.fay01,g_faz_t.faz02,STATUS,"","upd faz:",1)  #No.FUN-660136
                  LET g_success = 'N'
                  LET g_faz[i].* = g_faz_t.*
                  DISPLAY g_faz[i].* TO s_faz[j].*
             ELSE MESSAGE "UPDATE ok"
             END IF
          END IF
 
      AFTER ROW
         IF INT_FLAG THEN ROLLBACK WORK EXIT INPUT END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         CONTINUE INPUT
 
   END INPUT
   IF INT_FLAG thEN LET g_success='N' LET INT_FLAG = 0 END IF
   CLOSE WINDOW t105_w5
END FUNCTION 
 
FUNCTION t105_y() 	
DEFINE l_cnt LIKE type_file.num5         #No.FUN-680070 smalLINT
   IF s_shut(0) THEN RETURN END IF
   IF g_fay.fay01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fay.* FROM fay_file WHERE fay01 = g_fay.fay01
   IF g_fay.fayconf='Y' THEN RETURN END IF
   SELECT count(*) INTO l_cnt FROM faz_file
    WHERE faz01= g_fay.fay01
   IF l_cnt = 0 tHEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   IF g_fay.fayconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期小於關帳日期
   IF g_fay.fay02 < g_faa.faa09 THEN
      CALL cl_err(g_fay.fay01,'aap-176',1) RETURN
   END IF
   #----------------------------------- 檢查分錄底稿平衡正確否
    IF g_fah.fahdmy3 = 'Y' THEN
       IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125 
          CALL s_chknpq(g_fay.fay01,'FA',1,'0',g_bookno1)    #-->NO:0151 #No.FUN-740033
       END IF #MOD-BC0125
#FUN-C30313---mark---START
#     #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 mark
#      IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN    #FUN-AB0088 add #MOD-BC0125
#         CALL s_chknpq(g_fay.fay01,'FA',1,'1',g_bookno2)    #-->NO:0151 #No.FUN-740033
#      END IF
#FUN-C30313---mark---END
    END IF
#FUN-C30313---add---START-----
    IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN    #FUN-AB0088 add #MOD-BC0125
       IF g_fah.fahdmy32 = 'Y' THEN
          CALL s_chknpq(g_fay.fay01,'FA',1,'1',g_bookno2)    #-->NO:0151 #No.FUN-740033
       END IF
    END IF
#FUN-C30313---add---END-------
   IF g_success = 'N' THEN RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   BEGIN WORK
 
    OPEN t105_cl USING g_fay.fay01
    IF STATUS theN
       CALL cl_err("OPEN t105_cl:", STATUS, 1)
       CLOSE t105_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t105_cl INTO g_fay.*          # 鎖住將被更改或取消的資料
    IF SQLCA.SQLCODE THEN
        CALL cl_err(g_fay.fay01,SQLCA.SQLCODE,0)     # 資料被他人LOCK
        CLOSE t105_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   UPDATE fay_file SET fayconf = 'Y' WHERE fay01 = g_fay.fay01
   IF STATUS or sQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("upd","fay_file",g_fay.fay01,"",STATUS,"","upd fayconf",1)  #No.FUN-660136
      LET g_success = 'N'
   END IF
   CLOSE t105_cl
   IF g_success = 'Y' THEN
      LET g_fay.fayconf='Y'
      COMMIT WORK
      CALL cl_flow_notIFy(g_fay.fay01,'Y')
      DISPLAY by NAME g_fay.fayconf
   ELSE
      LET g_fay.fayconf='N'
      ROLLBACK WORK
   END IF
   IF g_fay.fayconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fay.fay08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fay.fayconf,g_chr2,g_fay.faypost,"",g_chr,"")
END FUNCTION 
 
FUNCTION t105_y_chk()
  DEFINE l_cnt LIKE type_file.num5         #No.FUN-680070 SMALLINT
  DEFINE l_faz RECORD LIKE faz_file.*   #TQC-780089
  DEFINE l_apa31      LIKE apa_file.apa31    #TQC-A40041 
  DEFINE l_sum        LIKE type_file.num5    #TQC-A40041 
  DEFINE l_cnt1 LIKE type_file.num5   #FUN-AB0088 
 
  LET g_success = 'Y'              #FUN-580109
 
  IF s_shut(0) THEN
     LET g_success = 'N'           #FUN-580109
     RETURN
  END IF
#CHI-C30107 ------------- add ------------- begin
  IF g_fay.fayconf='Y' THEN
     LET g_success = 'N'           
     CALL cl_err('','9023',0)   
     RETURN
  END IF
  IF g_fay.fayconf = 'X' THEN
     LET g_success = 'N'         
     CALL cl_err(' ','9024',0)
     RETURN
  END IF
  IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
     g_action_choice CLIPPED = "insert"     
  THEN
     IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN  END IF
  END IF
#CHI-C30107 ------------- add ------------- end
  IF g_fay.fay01 IS NULL THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('',-400,0)
     RETURN
  END IF
  SELECT * INTO g_fay.* FROM fay_file WHERE fay01 = g_fay.fay01
  IF g_fay.fayconf='Y' THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('','9023',0)      #FUN-580109
     RETURN
  END IF
  SELECT count(*) INTO l_cnt FROM faz_file
   WHERE faz01= g_fay.fay01
  IF l_cnt = 0 THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('','mfg-009',0)
     RETURN
  END IF
  IF g_fay.fayconf = 'X' THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err(' ','9024',0)
     RETURN
  END IF

#TQC-A40041 --begin--
  IF NOT cl_null(g_fay.fay03) THEN 
     SELECT apa31 INTO l_apa31 FROM apa_file
      WHERE apa01 = g_fay.fay03
     IF cl_null(l_apa31) THEN 
        LET l_apa31 = 0 
     END IF 
    
     SELECT SUM(faz08) INTO l_sum FROM faz_file
      WHERE faz01 = g_fay.fay01
     IF cl_null(l_sum) THEN 
        LET l_sum = 0 
     END IF 
     
     IF l_sum > l_apa31 THEN 
        LET g_success = 'N'
        CALL cl_err(g_fay.fay03,'afa-203',0)
        RETURN 
     END IF              
  END IF 
#TQC-A40041 --end--
  
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-->立帳日期小於關帳日期
  IF g_fay.fay02 < g_faa.faa09 THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err(g_fay.fay01,'aap-176',1)
     RETURN
  END IF
 
  DECLARE t105_cur6 CURSOR FOR
     SELECT * FROM faz_file WHERE faz01=g_fay.fay01
  FOREACH t105_cur6 INTO l_faz.*
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM fan_file
      WHERE fan01 = l_faz.faz03
        AND fan02 = l_faz.faz031
        AND fan041 <> '2'                 #MOD-C30795 add
        AND ((fan03 = YEAR(g_fay.fay02) AND fan04 >= MONTH(g_fay.fay02))
         OR fan03 > YEAR(g_fay.fay02))
        AND fan041 = '1'   #MOD-C50044 add
     #FUN-AB0088---add---str---
     LET l_cnt1 = 0
     IF g_faa.faa31 = 'Y' THEN
        SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
         WHERE fbn01 = g_faz[l_ac].faz03
           AND fbn02 = g_faz[l_ac].faz031 
           AND fbn041 <> '2'              #MOD-C30795 add 
           AND ((fbn03 = YEAR(g_fay.fay02) AND fbn04 >= MONTH(g_fay.fay02))
            OR fbn03 > YEAR(g_fay.fay02))
           AND fbn041 = '1'   #MOD-C50044 add
     END IF
     LET l_cnt = l_cnt + l_cnt1 
     #FUN-AB0088---add---end---
     IF l_cnt > 0 THEN
        LET g_success='N'
        CALL cl_err(l_faz.faz03,'afa-348',0)
        RETURN
     END IF
     LET l_cnt = 0 
     SELECT COUNT(*) INTO l_cnt FROM fao_file
      WHERE fao01 = l_faz.faz03
        AND fao02 = l_faz.faz031 
        AND fao041 <> '2'                 #MOD-C30795 add 
        AND ((fao03 = YEAR(g_fay.fay02) AND fao04 >= MONTH(g_fay.fay02))
         OR fao03 > YEAR(g_fay.fay02))
        AND fao041 = '1'   #MOD-C50044 add
     IF l_cnt > 0 THEN
        LET g_success='N'
        CALL cl_err(l_faz.faz03,'afa-348',0)
        RETURN
     END IF
  END FOREACH
  #----------------------------------- 檢查分錄底稿平衡正確否
  LET g_t1 = s_get_doc_no(g_fay.fay01)  #No.FUN-670060                                                                           
  SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1  #No.FUN-670060
  IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'N' THEN  #No.FUN-670060
     IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125 
        CALL s_chknpq(g_fay.fay01,'FA',1,'0',g_bookno1)    #-->NO:0151 #No.FUN-740033
     END IF #MOD-BC0125
#FUN-C30313---mark---START
#   #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 mark
#    IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN   #FUN-AB0088 add #MOD-BC0125
#       CALL s_chknpq(g_fay.fay01,'FA',1,'1',g_bookno2)    #-->NO:0151 #No.FUN-740033
#    END IF
#FUN-C30313---mark---END
  END IF
#FUN-C30313---add---START-----
  IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN   #FUN-AB0088 add #MOD-BC0125
     IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'N' THEN
        CALL s_chknpq(g_fay.fay01,'FA',1,'1',g_bookno2)    #-->NO:0151 #No.FUN-740033
     END IF
  END IF
#FUN-C30313---add---END-------
  IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t105_y_upd()
   DEFINE l_n    LIKE type_file.num10      #No.FUN-670060       #No.FUN-680070 INTEGER
   #CHI-B80007 -- begin --
   DEFINE l_faz     RECORD LIKE faz_file.*
   DEFINE l_msg     LIKE type_file.chr1000
   DEFINE l_cnt     LIKE type_file.num5
   #CHI-B80007 -- begin --
 
   LET g_success = 'Y'
   IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
      g_action_choice CLIPPED = "insert"     #FUN-640243
   THEN
  
      IF g_fay.faymksg='Y'   THEN
          IF g_fay.fay08 != '1' THEN
             CALL cl_err('','aws-078',1)
             LET g_success = 'N'
             RETURN
          END IF
      END IF
 #    IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   END IF
  
   BEGIN WORK
  
   OPEN t105_cl USING g_fay.fay01
   IF STATUS THEN
      CALL cl_err("OPEN t105_cl:", STATUS, 1)
      CLOSE t105_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t105_cl INTO g_fay.*          # 鎖住將被更改或取消的資料
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_fay.fay01,SQLCA.SQLCODE,0)     # 資料被他人LOCK
      CLOSE t105_cl ROLLBACK WORK RETURN
   END IF
  
   #CHI-B80007 -- begin --
   DECLARE t105_faz_cur CURSOR FOR
      SELECT * FROM faz_file WHERE faz01=g_fay.fay01
   FOREACH t105_faz_cur INTO l_faz.*
      SELECT count(*) INTO l_cnt FROM faz_file,fay_file
       WHERE faz01 = fay01
         AND faz03 = l_faz.faz03
         AND faz031= l_faz.faz031 AND fay02 <= g_fay.fay02
         AND faypost = 'N'
         AND fay01 != g_fay.fay01
         AND fayconf <> 'X'
      IF l_cnt  > 0 THEN
         LET l_msg = l_faz.faz01,' ',l_faz.faz02,' ',
                     l_faz.faz03,' ',l_faz.faz031
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
#       WHERE npq01 = g_fay.fay01
#         AND npq011 = 1
#         AND npqsys = 'FA'
#         AND npq00 = 7
#      IF l_n = 0 THEN
#         CALL t105_gen_glcr(g_fay.*,g_fah.*)
#      END IF
#      IF g_success = 'Y' THEN 
#         IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125 
#            CALL s_chknpq(g_fay.fay01,'FA',1,'0',g_bookno1)    #-->NO:0151 #No.FUN-740033
#         END IF #MOD-BC0125
#        #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN  #FUN-AB0088 mark
#         IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN  #FUN-AB0088 add #MOD-BC0125
#            CALL s_chknpq(g_fay.fay01,'FA',1,'1',g_bookno2)    #-->NO:0151 #No.FUN-740033
#         END IF
#      END IF
#      IF g_success = 'N' THEN RETURN END IF  #No.FUN-680028
#   END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
       SELECT count(*) INTO l_n FROM npq_file
        WHERE npq01 = g_fay.fay01
          AND npq011 = 1
          AND npqsys = 'FA'
          AND npq00 = 7
      #IF l_n = 0 THEN                                                                     #MOD-C50255 mark
       IF l_n = 0 AND                                                                      #MOD-C50255 add
          ((g_fah.fahdmy3 = 'Y') OR (g_faa.faa31 = 'Y' AND g_fah.fahdmy32 = 'Y' )) THEN    #MOD-C50255 add
          CALL t105_gen_glcr(g_fay.*,g_fah.*)
       END IF
       IF g_success = 'Y' THEN
          IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
             IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125
                CALL s_chknpq(g_fay.fay01,'FA',1,'0',g_bookno1)    #-->NO:0151 #No.FUN-740033
             END IF #MOD-BC0125
          END IF
          IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN  #FUN-AB0088 add #MOD-BC0125
             IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN
                CALL s_chknpq(g_fay.fay01,'FA',1,'1',g_bookno2)    #-->NO:0151 #No.FUN-740033
             END IF
          END IF
       END IF
       IF g_success = 'N' THEN RETURN END IF  #No.FUN-680028
#FUN-C30313---add---END-------
   UPDATE fay_file SET fayconf = 'Y' WHERE fay01 = g_fay.fay01
   IF STATUS or sQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('fay01',g_fay.fay01,'upd fayconf',STATUS,1)                #No.FUN-710028
      LET g_success = 'N'
   END IF
  
   #-----No:FUN-B60140-----
   IF g_faa.faa31 = "Y" THEN
      LET g_t1 = s_get_doc_no(g_fay.fay01)
      SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
      IF g_fah.fahfa1 = "N" THEN
         UPDATE fay_file SET faypost = 'X',faypost2='X' WHERE fay01 = g_fay.fay01
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('fay01',g_fay.fay01,'upd faypost',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
      IF g_fah.fahfa2 = "N" THEN
         UPDATE fay_file SET faypost1= 'X' WHERE fay01 = g_fay.fay01
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('fay01',g_fay.fay01,'upd faypost1',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
      SELECT faypost,faypost1,faypost2
        INTO g_fay.faypost,g_fay.faypost1,g_fay.faypost2
        FROM fay_file
       WHERE fay01 = g_fay.fay01
      DISPLAY BY NAME g_fay.faypost,g_fay.faypost1,g_fay.faypost2
   END IF
   #-----No:FUN-B60140 END-----
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'Y' THEN
      IF g_fay.faymksg = 'Y' THEN #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
             WHEN 0  #呼叫 EasyFlow 簽核失敗
                  LET g_fay.fayconf="N"
                  LET g_success = "N"
                  ROLLBACK WORK
                  RETURN
             WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                  LET g_fay.fayconf="N"
                  ROLLBACK WORK
                  RETURN
         END CASE
      END IF
      CLOSE t105_cl
      IF g_success = 'Y' THEN
         LET g_fay.fay08='1'      #執行成功, 狀態值顯示為 '1' 已核准
         UPDATE fay_file SET fay08 = g_fay.fay08 WHERE fay01=g_fay.fay01
         IF SQLCA.SQLERRD[3]=0 THEN
            LET g_success='N'
         END IF
         LET g_fay.fayconf='Y'
         COMMIT WORK
         CALL cl_flow_notIFy(g_fay.fay01,'Y')
         DISPLAY BY NAME g_fay.fayconf
         DISPLAY BY NAME g_fay.fay08   #FUN-580109
      ELSE
         LET g_fay.fayconf='N'
         LET g_success = 'N'   #FUN-580109
         ROLLBACK WORK
      END IF
   ELSE
      LET g_fay.fayconf='N'
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
 
   IF g_fay.fayconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fay.fay08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fay.fayconf,g_chr2,g_fay.faypost,"",g_chr,"")
  
END FUNCTION
 
FUNCTION t105_ef()
  CALL t105_y_chk()      #CALL 原確認的 check 段
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
 
  IF aws_efcli2(base.TypeInfo.create(g_fay),base.TypeInfo.create(g_faz),'','','','')
  THEN
     LET g_success='Y'
     LET g_fay.fay08='S'
     DISPLAY BY NAME g_fay.fay08
  ELSE
     LET g_success='N'
  END IF
END FUNCTION
 
FUNCTION t105_z() 	
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fay.fay01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fay.* FROM fay_file WHERE fay01 = g_fay.fay01
   IF g_fay.fay08  ='S' THEN CALL cl_err("","mfg3557",0) RETURN END IF   #FUN-580109
   IF g_fay.fayconf='N' THEN RETURN END IF
   IF g_fay.fayconf='X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_fay.faypost='Y' THEN
      CALL cl_err(g_fay.faypost,'afa-106',0)
      RETURN
   END IF
  #-----No:FUN-B60140-----
   IF g_faa.faa31 ="Y" THEN
      IF g_fay.faypost1='Y' THEN
         CALL cl_err(g_fay.faypost1,'afa-106',0)
         RETURN
      END IF
   END IF
  #-----No:FUN-B60140 END----- 
   IF g_fay.faypost2='Y' THEN
      CALL cl_err(g_fay.faypost2,'afa-106',0)
      RETURN
   END IF
   #-->已拋轉總帳, 不可取消確認
   IF NOT cl_null(g_fay.fay06) THEN
      CALL cl_err(g_fay.fay06,'aap-145',1)
      RETURN
   END IF
  
   #-----No:FUN-B60140-----
   IF g_faa.faa31 = "Y" THEN
      IF NOT cl_null(g_fay.fay062) THEN
         CALL cl_err(g_fay.fay062,'aap-145',1)
         RETURN
     END IF
   END IF
  #-----No:FUN-B60140 END-----  
 
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_fay.fay02 < g_faa.faa09 THEN
      CALL cl_err(g_fay.fay01,'aap-176',1) RETURN
   END IF

   #-----No:FUN-B60140-----
   IF g_faa.faa31="Y" THEN
      IF g_fay.fay02 < g_faa.faa092 THEN
         CALL cl_err(g_fay.fay01,'aap-176',1) RETURN
      END IF
   END IF
   #-----No:FUN-B60140 END-----

   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
    OPEN t105_cl USING g_fay.fay01
    IF STATUS theN
       CALL cl_err("OPEN t105_cl:", STATUS, 1)
       CLOSE t105_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t105_cl INTO g_fay.*          # 鎖住將被更改或取消的資料
    IF SQLCA.SQLCODE THEN
        CALL cl_err(g_fay.fay01,SQLCA.SQLCODE,0)     # 資料被他人LOCK
        CLOSE t105_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
   UPDATE fay_file SET fayconf = 'N', fay08 ='0'   #FUN-580109
    WHERE fay01 = g_fay.fay01
   IF STATUS or sQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("upd","fay_file",g_fay.fay01,"",STATUS,"","upd fayconf",1)  #No.FUN-660136
      LET g_success = 'N'
   END IF
   
   #-----No:FUN-B60140-----
   IF g_faa.faa31 = "Y" THEN
      LET g_t1 = s_get_doc_no(g_fay.fay01)
      SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
      IF g_fah.fahfa1 = "N" THEN
         UPDATE fay_file SET faypost = 'N',faypost2='N' WHERE fay01 = g_fay.fay01
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('fay01',g_fay.fay01,'upd faypost',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
      IF g_fah.fahfa2 = "N" THEN
         UPDATE fay_file SET faypost1= 'N' WHERE fay01 = g_fay.fay01
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('fay01',g_fay.fay01,'upd faypost1',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
      SELECT faypost,faypost1,faypost2
        INTO g_fay.faypost,g_fay.faypost1,g_fay.faypost2
        FROM fay_file
       WHERE fay01 = g_fay.fay01
      DISPLAY BY NAME g_fay.faypost,g_fay.faypost1,g_fay.faypost2
    END IF
    #-----No:FUN-B60140 END-----
   
   CLOSE t105_cl
   IF g_success = 'Y' THEN
      LET g_fay.fayconf='N'
      LET g_fay.fay08='0'   #FUN-580109
      COMMIT WORK
      DISPLAY BY NAME g_fay.fayconf
      DISPLAY BY NAME g_fay.fay08    #FUN-580109
   ELSE
      LET g_fay.fayconf='Y'
      ROLLBACK WORK
   END IF

   IF g_fay.fayconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fay.fay08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fay.fayconf,g_chr2,g_fay.faypost,"",g_chr,"")
END FUNCTION 
 
#----過帳--------
FUNCTION t105_s()
   DEFINE l_faz       RECORD LIKE faz_file.*,
          l_faj       RECORD LIKE faj_file.*,
          l_flag      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
          l_bdate,l_edate LIKE type_file.dat          #No.FUN-680070 DATE
   DEFINE l_cnt          LIKE type_file.num5     #No:FUN-B60140 
   
   IF s_shut(0) THEN RETURN END IF
   IF g_fay.fay01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fay.* FROM fay_file WHERE fay01 = g_fay.fay01
   IF g_fay.fayconf != 'Y' OR g_fay.faypost != 'N' THEN
      CALL cl_err(g_fay.fay01,'afa-100',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fay.fay02 < g_faa.faa09 THEN
      CALL cl_err(g_fay.fay01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-
   LET g_t1 = s_get_doc_no(g_fay.fay01)     #No.FUN-680028
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
  #IF g_aza.aza63 = 'Y' THEN #FUN-AB0088 mark
   IF g_faa.faa31 = 'Y' THEN #FUN-AB0088
      CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
   ELSE
      CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
   END IF
   #CHI-A60036 add --end--
   IF g_fay.fay02 < l_bdate OR g_fay.fay02 > l_edate THEN
      CALL cl_err(g_fay.fay02,'afa-308',0)
      RETURN
   END IF
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK  #No.FUN-710028
 
    OPEN t105_cl USING g_fay.fay01
    IF STATUS theN
       CALL cl_err("OPEN t105_cl:", STATUS, 1)
       CLOSE t105_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t105_cl INTO g_fay.*          # 鎖住將被更改或取消的資料
    IF SQLCA.SQLCODE THEN
        CALL cl_err(g_fay.fay01,SQLCA.SQLCODE,0)     # 資料被他人LOCK
        CLOSE t105_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
 
   DECLARE t105_cur2 CURSOR FOR
      SELECT * frOM faz_file WHERE faz01=g_fay.fay01
   CALL s_showmsg_init()     #No.FUN-710028
   FOREACH t105_cur2 INTO l_faz.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.SQLCODE != 0 THEN
         CALL s_errmsg('faz01',g_fay.fay01,'foreach:',SQLCA.SQLCODE,1) #No.FUN-710028
         EXIT FOREACH
         LET g_success='N'
      END IF
      #------- 先找出對應之 faj_file 資料
      SELECT * inTO l_faj.* FROM faj_file WHERE faj02=l_faz.faz03
                                            AND faj022=l_faz.faz031
      IF STATUS THEN #No.7926
         LET g_showmsg = l_faz.faz03,"/",l_faz.faz031   #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1) #No.FUN-710028
         LET g_success = 'N'
      END IF
      #------- 過帳(1)insert fap_file--------
      IF cl_null(l_faz.faz031) THEN
         LET l_faz.faz031 = ' '
      END IF

     #CHI-C60010---str---
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
      CALL cl_digcut(l_faz.faz102,g_azi04_1) RETURNING l_faz.faz102
      CALL cl_digcut(l_faz.faz082,g_azi04_1) RETURNING l_faz.faz082
      CALL cl_digcut(l_faj.faj3312,g_azi04_1) RETURNING l_faj.faj3312
     #CHI-C60010---end---
      #-----No:FUN-B60140-----
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM fap_file
      WHERE fap50  = l_faz.faz01
        AND fap501 = l_faz.faz02
        AND fap03  = '7'              ## 異動代號
      IF l_cnt = 0 THEN   #無fap_file資料
      INSERT INTO fap_file (fap01,fap02,fap021,fap03,fap04,fap05,fap06,fap07,
                            fap08,fap09,fap10,fap101,fap11,fap12,fap13,fap14,
                            fap15,fap16,fap17,fap18,fap19,fap20,fap201,fap21,
                            fap22,fap23,fap24,fap25,fap26,fap30,fap31,fap32,
                            fap33,fap34,fap341,fap35,fap36,fap37,fap38,fap39,
                            fap40,fap41,fap50,fap501,fap52,fap53,fap54,fap69,
                            fap70,fap71,
                            fap121,fap131,fap141,fap77,fap56, #CHI-9B0032 add fap77  #TQC-B30156 add fap56
                            #FUN-AB0088---add---str---
                            fap052,fap062,fap072,fap082,
                            fap092,fap103,fap1012,fap112,
                            fap152,fap162,fap212,fap222,
                            fap232,fap242,fap252,fap262,
                            fap522,fap532,fap542,   
                            #FUN-AB0088---add---end---
                            faplegal)     #No.FUN-680028 #FUN-980003 add
      VALUES (l_faj.faj01,l_faz.faz03,l_faz.faz031,'7',g_fay.fay02,
              l_faj.faj43,l_faj.faj28,l_faj.faj30,l_faj.faj31,
              l_faj.faj14,l_faj.faj141,l_faj.faj33+l_faj.faj331,l_faj.faj32,  #MOD-970231
              l_faj.faj53,l_faj.faj54,l_faj.faj55,l_faj.faj23,
              l_faj.faj24,l_faj.faj20,l_faj.faj19,l_faj.faj21,
              l_faj.faj17,l_faj.faj171,l_faj.faj58,l_faj.faj59,
              l_faj.faj60,l_faj.faj34,l_faj.faj35,l_faj.faj36,
              l_faj.faj61,l_faj.faj65,l_faj.faj66,l_faj.faj62,
              l_faj.faj63,l_faj.faj68,l_faj.faj67,l_faj.faj69,
              l_faj.faj70,l_faj.faj71,l_faj.faj72,l_faj.faj73,
              l_faj.faj100,l_faz.faz01,l_faz.faz02,l_faz.faz09,
              l_faz.faz10,l_faz.faz08,l_faz.faz18,l_faz.faz19,l_faz.faz17,
              l_faj.faj531,l_faj.faj541,l_faj.faj551,l_faj.faj43,0, #CHI-9B0032 add faj43  #TQC-B30156 add 0
              #FUN-AB0088---add---str---
              l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,
              l_faj.faj142,l_faj.faj1412,l_faj.faj332+l_faj.faj3312,l_faj.faj322,
              l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
              l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,
              l_faz.faz092,l_faz.faz102,l_faz.faz082,
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
                            fap77 = l_faj.faj43,
                            fap52 = l_faz.faz09,
                            fap53 = l_faz.faz10,
                            fap54 = l_faz.faz08,
                            fap56 = 0
                      WHERE fap50  = l_faz.faz01
                        AND fap501 = l_faz.faz02
                        AND fap03  = '7'              ## 異動代號
     END IF
     #-----No:FUN-B60140 END-----
      IF STATUS THEN                           #FUN-580109
         LET g_showmsg = l_faz.faz03,"/",l_faz.faz031,"/",'7',"/",g_fay.fay02          #No.FUN-710028
         CALL s_errmsg('fap02,fap021,fap03,fap04',g_showmsg,'ins fap',STATUS,1)        #No.FUN-710028
         LET g_success = 'N'
      END IF
      #--------- 過帳(3)UPDATE faj_file
      UPDATE faj_file set faj43  = '8',                  #資產狀態
                          faj141 = faj141+ l_faz.faz08,  #調整成本
                          faj33  = faj33 + l_faz.faz08,  #未折減額
                          faj30  = l_faz.faz09,          #未耐用年限
                          faj31  = l_faz.faz10,          #預留殘值
                          faj100 = g_fay.fay02          #    異動日期
                          #FUN-AB0088---add---str---
                         ###-----No:FUN-B60140 Mark-----
                         #faj432 = '8',
                         #faj1412 = faj1412 + l_faz.faz082,
                         #faj332 = faj332 + l_faz.faz082,
                         #faj302 = l_faz.faz092,
                         #faj312 = l_faz.faz102    
                          ##-----No:FUN-B60140 Mark END-----
                          #FUN-AB0088---add---end---
         WHERE faj02=l_faz.faz03 AND faj022=l_faz.faz031
         IF STATUS OR SQLCA.SQLERRD[3]= 0 THEN
            LET g_showmsg = l_faz.faz03,"/",l_faz.faz031                 #No.FUN-710028
            CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
            LET g_success = 'N'
         END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   #--------- 過帳(1)UPDATE faypost
   IF g_success = 'Y' THEN
      UPDATE fay_file SET faypost = 'Y' WHERE fay01 = g_fay.fay01
          IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
             CALL s_errmsg('fay01',g_fay.fay01,'upd faypost',STATUS,1)                #No.FUN-710028
             LET g_success = 'N'
          END IF
   END IF
   CLOSE t105_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      CALL cl_flow_notIFy(g_fay.fay01,'S')
      COMMIT WORK
      LET g_fay.faypost='Y'
      DISPLAY by NAME g_fay.faypost #
   END IF
   IF g_fay.fayconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fay.fay08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_fay.fay01,'" AND npp011 = 1'
      LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_fay.fayuser,"' '",g_fay.fayuser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_fay.fay02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"    #No.FUN-680028   #MOD-860284#FUN-860040
      CALL cl_cmdrun_wait(g_str)
      SELECT fay06,fay07 INTO g_fay.fay06,g_fay.fay07 FROM fay_file
       WHERE fay01 = g_fay.fay01
      DISPLAY BY NAME g_fay.fay06
      DISPLAY BY NAME g_fay.fay07
   END IF
   CALL cl_set_field_pic(g_fay.fayconf,g_chr2,g_fay.faypost,"",g_chr,"")
END FUNCTION 
 
FUNCTION t105_6()
   DEFINE l_faz       RECORD LIKE faz_file.*,
          l_faj63     LIKE faj_file.faj63,
          l_faj65     LIKE faj_file.faj65,
          l_faj66     LIKE faj_file.faj66,
          l_faj68     LIKE faj_file.faj68,
          l_faj201    LIKE faj_file.faj201,
          l_flag      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
          l_yy,l_mm   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_bdate,l_edate LIKE type_file.dat          #No.FUN-680070 DATE
   DEFINE l_faj       RECORD LIKE faj_file.*   #No:FUN-B60140
   DEFINE l_cnt       LIKE type_file.num5     #No:FUN-B60140      
       
   IF s_shut(0) THEN RETURN END IF
   IF g_fay.fay01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fay.* FROM fay_file WHERE fay01 = g_fay.fay01
   #IF g_fay.fayconf != 'Y' OR g_fay.faypost != 'Y' OR g_fay.faypost2!= 'N' THEN   #FUN-580109
    IF g_fay.fayconf != 'Y' OR g_fay.faypost2!= 'N' THEN   #FUN-580109  #No:FUN-B60140
      CALL cl_err(g_fay.fay01,'afa-100',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa13 INTO g_faa.faa13 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #--->折舊年月判斷
   IF g_fay.fay02 < g_faa.faa13 THEN
      CALL cl_err(g_fay.fay02,'afa-308',0)
      RETURN
   END IF
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK  #No.FUN-710028
 
    OPEN t105_cl USING g_fay.fay01
    IF STATUS theN
       CALL cl_err("OPEN t105_cl:", STATUS, 1)
       CLOSE t105_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t105_cl INTO g_fay.*          # 鎖住將被更改或取消的資料
    IF SQLCA.SQLCODE THEN
        CALL cl_err(g_fay.fay01,SQLCA.SQLCODE,0)     # 資料被他人LOCK
        CLOSE t105_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   DECLARE t105_cur21 CURSOR FOR
      SELECT * frOM faz_file WHERE faz01=g_fay.fay01
   CALL s_showmsg_init()     #No.FUN-710028
   FOREACH t105_cur21 INTO l_faz.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.SQLCODE != 0 THEN
         CALL s_errmsg('faz01',g_fay.fay01,'foreach:',SQLCA.SQLCODE,0)  #No.FUN-710028
         EXIT FOREACH
      END IF
     #-----No:FUN-B60140-----
     SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_faz.faz03
                                           AND faj022=l_faz.faz031 
    # SELECT faj63,faj65,faj66,faj68,faj201  INTO
    #        l_faj63,l_faj65,l_faj66,l_faj68,l_faj201
    #     FROM faj_file WHERE faj02 = l_faz.faz03
    #                     AND faj022= l_faz.faz031
    ##-----No:FUN-B60140 END-----
      IF STATUS THEN
         LET g_showmsg = l_faz.faz03,"/",l_faz.faz031                  #No.FUN-710028 
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)    #No.FUN-710028
         LET g_success = 'N'
         CONTINUE FOREACH  #No.FUN-710028
      END IF

     #CHI-C60010---str---
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
      CALL cl_digcut(l_faz.faz102,g_azi04_1) RETURNING l_faz.faz102
      CALL cl_digcut(l_faz.faz082,g_azi04_1) RETURNING l_faz.faz082
      CALL cl_digcut(l_faj.faj3312,g_azi04_1) RETURNING l_faj.faj3312
     #CHI-C60010---end---
      #-----No:FUN-B60140-----
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fap_file
       WHERE fap50  = l_faz.faz01
         AND fap501 = l_faz.faz02
         AND fap03  = '7'              ## 異動代號
      IF l_cnt = 0 THEN   #無fap_file資料      
         INSERT INTO fap_file (fap01,fap02,fap021,fap03,fap04,fap05,fap06,fap07,
                               fap08,fap09,fap10,fap101,fap11,fap12,fap13,fap14,
                               fap15,fap16,fap17,fap18,fap19,fap20,fap201,fap21,
                               fap22,fap23,fap24,fap25,fap26,fap30,fap31,fap32,
                               fap33,fap34,fap341,fap35,fap36,fap37,fap38,fap39,
                               fap40,fap41,fap50,fap501,fap52,fap53,fap54,fap69,
                               fap70,fap71,
                               fap121,fap131,fap141,fap77,
                               fap052,fap062,fap072,fap082,
                               fap092,fap103,fap1012,fap112,
                               fap152,fap162,fap212,fap222,
                               fap232,fap242,fap252,fap262,
                               fap522,fap532,fap542,fap56,fap562,fap42,fap772,faplegal)
         VALUES (l_faj.faj01,l_faz.faz03,l_faz.faz031,'7',g_fay.fay02,
                 l_faj.faj43,l_faj.faj28,l_faj.faj30,l_faj.faj31,
                 l_faj.faj14,l_faj.faj141,l_faj.faj33+l_faj.faj331,l_faj.faj32,
                 l_faj.faj53,l_faj.faj54,l_faj.faj55,l_faj.faj23,
                 l_faj.faj24,l_faj.faj20,l_faj.faj19,l_faj.faj21,
                 l_faj.faj17,l_faj.faj171,l_faj.faj58,l_faj.faj59,
                 l_faj.faj60,l_faj.faj34,l_faj.faj35,l_faj.faj36,
                 l_faj.faj61,l_faj.faj65,l_faj.faj66,l_faj.faj62,
                 l_faj.faj63,l_faj.faj68,l_faj.faj67,l_faj.faj69,
                 l_faj.faj70,l_faj.faj71,l_faj.faj72,l_faj.faj73,
                 l_faj.faj100,l_faz.faz01,l_faz.faz02,l_faz.faz09,
                 l_faz.faz10,l_faz.faz08,l_faz.faz18,l_faz.faz19,l_faz.faz17,
                 l_faj.faj531,l_faj.faj541,l_faj.faj551,l_faj.faj43,
                 l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,
                 l_faj.faj142,l_faj.faj1412,l_faj.faj332+l_faj.faj3312,l_faj.faj322,
                 l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
                 l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,
                 l_faz.faz092,l_faz.faz102,l_faz.faz082,0,0,l_faj.faj201,l_faj.faj432,g_legal)
    ELSE
      UPDATE fap_file SET fap71  = l_faz.faz17,           #稅簽改良成本
                          fap69  = l_faz.faz18,           #    未使用年限
                          fap70  = l_faz.faz19,           #    預留殘值
                         #   fap42  = l_faj201,              #稅簽資產狀態   #No:FUN-BA0112 mark
                         #   fap34  = l_faj63,               #稅簽調整成本   #No:FUN-BA0112 mark
                         #   fap341 = l_faj68,               #    未折減額   #No:FUN-BA0112 mark
                         #   fap31  = l_faj65,               #    未使用年限 #No:FUN-BA0112 mark
                         #   fap32  = l_faj66                #    預留殘值   #No:FUN-BA0112 mark
                             fap42  = l_faj.faj201,          #稅簽資產狀態 #No:FUN-BA0112 add
                             fap34  = l_faj.faj63,           #稅簽調整成本 #No:FUN-BA0112 add
                             fap341 = l_faj.faj68,           #未折減額    #No:FUN-BA0112 add
                             fap31  = l_faj.faj65,           #未使用年限  #No:FUN-BA0112 add 
                             fap32  = l_faj.faj66            #預留殘值    #No:FUN-BA0112 add
                    WHERE fap50  = l_faz.faz01
                      AND fap501 = l_faz.faz02
                      AND fap03='7'    ## 異動代號
      END IF
      #-----No:FUN-B60140 END-----    
 
      IF STATUS oR SQLCA.SQLERRD[3]= 0 THEN
         LET g_showmsg = l_faz.faz01,"/",l_faz.faz02,"/",'7'                 #No.FUN-710028
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'upd fap',STATUS,1)    #No.FUN-710028
         LET g_success = 'N'
      END IF
      #--------- 過帳(3)UPDATE faj_file
      UPDATE faj_file SET faj63  = faj63 + l_faz.faz17,  #稅簽改良成本
                           faj68  = faj68 + l_faz.faz17,  #    未折減額
                          faj201 = '8',
                          faj65  = l_faz.faz18,          #    未耐用年限
                          faj66  = l_faz.faz19           #    預留殘值
                    WHERE faj02=l_faz.faz03 AND faj022=l_faz.faz031
         IF STATUS OR SQLCA.SQLERRD[3]= 0 THEN
            LET g_showmsg = l_faz.faz03,"/",l_faz.faz031                   #No.FUN-710028
            CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)     #No.FUN-710028
            LET g_success = 'N'
         END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   #--------- 過帳(1)UPDATE faypost
   IF g_success = 'Y' THEN
      UPDATE fay_file SET faypost2 = 'Y' WHERE fay01 = g_fay.fay01
          IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
             CALL s_errmsg('fay01',g_fay.fay01,'upd faypost2',STATUS,1)     #No.FUN-710028
             LET g_success = 'N'
          END IF
   END IF
   CLOSE t105_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
      LET g_fay.faypost2='Y'
      DISPLAY by NAME g_fay.faypost2 #
   END IF
END FUNCTION 
 
FUNCTION t105_w()
   DEFINE l_aba19     LIKE aba_file.aba19     #No.FUN-680028
   DEFINE l_sql       LIKE type_file.chr1000             #No.FUN-680028       #No.FUN-680070 VARCHAR(1000)
   DEFINE l_dbs       STRING                  #No.FUN-680028
   DEFINE l_faz    RECORD LIKE faz_file.*,
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
          l_flag      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
          l_bdate,l_edate LIKE type_file.dat,          #No.FUN-680070 DATE
          l_cnt    LIKE type_file.num5     #TQC-780089
  #FUN-AB0088---add---str---
  DEFINE l_fap052   LIKE fap_file.fap052
  DEFINE l_fap103   LIKE fap_file.fap103
  DEFINE l_fap072   LIKE fap_file.fap072
  DEFINE l_fap082   LIKE fap_file.fap082
  DEFINE l_fap1012  LIKE fap_file.fap1012
  DEFINE l_cnt1     LIKE type_file.num5 
  #FUN-AB0088---add---end---

 
   IF s_shut(0) THEN RETURN END IF
   IF g_fay.fay01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fay.* FROM fay_file WHERE fay01 = g_fay.fay01
   IF g_fay.faypost != 'Y' THEN
      CALL cl_err3("sel","fay_file",g_fay.fay01,"","afa-108","","",1)  #No.FUN-660136
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fay.fay02 < g_faa.faa09 THEN
      CALL cl_err(g_fay.fay01,'aap-176',1) RETURN
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
  #IF g_aza.aza63 = 'Y' THEN  #FUN-AB0088 mark
   IF g_faa.faa31 = 'Y' THEN  #FUN-AB0088
      CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
   ELSE
      CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
   END IF
   #CHI-A60036 add --end--
   IF g_fay.fay02 < l_bdate OR g_fay.fay02 > l_edate THEN
      CALL cl_err(g_fay.fay02,'afa-308',0)
      RETURN
   END IF
   #-->已拋轉總帳, 不可取消確認
   IF NOT cl_null(g_fay.fay06) AND g_fah.fahglcr = 'N' THEN       #FUN-670060
      CALL cl_err(g_fay.fay06,'aap-145',1)
      RETURN
   END IF
   DECLARE t105_cur4 CURSOR FOR
      SELECT * FROM faz_file WHERE faz01=g_fay.fay01
   FOREACH t105_cur4 INTO l_faz.*
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fan_file
       WHERE fan01 = l_faz.faz03
         AND fan02 = l_faz.faz031
         AND fan041 <> '2'                      #MOD-C30795 add 
         AND ((fan03 = YEAR(g_fay.fay02) AND fan04 >= MONTH(g_fay.fay02))
          OR fan03 > YEAR(g_fay.fay02))
         AND fan041 = '1'   #MOD-C50044 add
      #FUN-AB0088---add---str---
      ##-----No:FUN-B60140 Mark-----
      #LET l_cnt1 = 0
      #IF g_faa.faa31 = 'Y' THEN
      #    SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
      #     WHERE fbn01 = l_faz.faz03
      #       AND fbn02 = l_faz.faz031
      #       AND ((fbn03 = YEAR(g_fay.fay02) AND fbn04 >= MONTH(g_fay.fay02))
      #        OR fbn03 > YEAR(g_fay.fay02))
      #END IF
      #LET l_cnt = l_cnt + l_cnt1
      ##-----No:FUN-B60140 Mark END-----
      #FUN-AB0088---add---end---
      IF l_cnt > 0 THEN
         CALL cl_err(l_faz.faz03,'afa-348',0)
         RETURN
      END IF
   END FOREACH
 
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_fay.fay01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
   IF NOT cl_null(g_fay.fay06) THEN
      IF NOT (g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y') THEN
         CALL cl_err(g_fay.fay01,'axr-370',0) RETURN
      END IF
   END IF
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
     #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",   #FUN-A50102
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                  "  WHERE aba00 = '",g_faa.faa02b,"'",
                  "    AND aba01 = '",g_fay.fay06,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
      PREPARE aba_pre1 FROM l_sql
      DECLARE aba_cs1 CURSOR FOR aba_pre1
      OPEN aba_cs1
      FETCH aba_cs1 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_fay.fay06,'axr-071',1)
         RETURN
      END IF
 
   END IF
   IF NOT cl_sure(18,20) THEN RETURN END IF
  #-----------------------------CHI-C90051----------------------------(S)
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fay.fay06,"' '7' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT fay06,fay07 INTO g_fay.fay06,g_fay.fay07 FROM fay_file
       WHERE fay01 = g_fay.fay01
      DISPLAY BY NAME g_fay.fay06
      DISPLAY BY NAME g_fay.fay07
      IF NOT cl_null(g_fay.fay06) THEN
         CALL cl_err('','aap-929',0)
         RETURN
      END IF
   END IF
  #-----------------------------CHI-C90051----------------------------(E)
   BEGIN WORK  #No.FUN-710028
 
    OPEN t105_cl USING g_fay.fay01
    IF STATUS theN
       CALL cl_err("OPEN t105_cl:", STATUS, 1)
       CLOSE t105_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t105_cl INTO g_fay.*          # 鎖住將被更改或取消的資料
    IF SQLCA.SQLCODE THEN
        CALL cl_err(g_fay.fay01,SQLCA.SQLCODE,0)     # 資料被他人LOCK
        CLOSE t105_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
   #--------- 還原過帳(2)UPDATE faj_file
   DECLARE t105_cur3 CURSOR FOR
      SELECT * frOM faz_file WHERE faz01=g_fay.fay01
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t105_cur3 INTO l_faz.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.SQLCODE != 0 THEN
         CALL s_errmsg('faz01',g_fay.fay01,'foreach:',SQLCA.SQLCODE,0) #No.FUN-710028
         EXIT FOREACH
      END IF
      #----- 找出 faj_file 中對應之財產編號+附號
      SELECT * inTO l_faj.* FROM faj_file WHERE faj02=l_faz.faz03
                                            AND faj022=l_faz.faz031
      IF STATUS THEN #No.7926
         LET g_showmsg = l_faz.faz03,"/",l_faz.faz031                  #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,0)    #No.FUN-710028
         CONTINUE FOREACH   #No.FUN-710028
      END IF
      #----- 找出 fap_file 之 fap05 以便 UPDATE faj_file.faj43
      SELECT fap05,fap10,fap101,fap07,fap08,fap34,fap341,fap31,fap32,fap41,
            #fap052,fap103,fap072,fap082  #FUN-AB0088 #TQC-B30156 mark
             fap052,fap103,fap1012,fap072,fap082      #TQC-B30156 add fap1012 
        INTO l_fap05,l_fap10,l_fap101,l_fap07,l_fap08,l_fap34,l_fap341,l_fap31,
             l_fap32,l_fap41,
             l_fap052,l_fap103,l_fap1012,l_fap072,l_fap082  #FUN-AB0088
        FROM fap_file
       WHERE fap50=l_faz.faz01 AND fap501=l_faz.faz02 AND fap03='7'
       IF STATUS THEN #No.7926
          LET g_showmsg = l_faz.faz01,"/",l_faz.faz02,"/",'7'                 #No.FUN-710028
          CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'sel fap',STATUS,1)    #No.FUN-710028
          LET g_success = 'N'
       END IF
       UPDATE faj_file set faj43  = l_fap05,   #資產狀態
                           faj141 = l_fap10,   #調整成本
                           faj33  = l_fap101,  #未折減額
                           faj30  = l_fap07,   #未耐用年限
                           faj31  = l_fap08,   #預留殘值
                           faj100 = l_fap41   #    最近異動日
                          ##-----No:FUN-B60140 Mark-----
                          #FUN-AB0088---add---str---
                          #faj432 = l_fap052,  
                          #fap302 = l_fap072,              #TQC-B30156 mark
                          #faj302 = l_fap072,              #TQC-B30156 
                          #faj312 = l_fap082,  
                          #faj1412 =l_fap103,  
                          #faj332 = l_fap1012  
                          ##FUN-AB0088---add---end---
                          ##-----No:FUN-B60140 Mark END-----
          WHERE faj02=l_faz.faz03 AND faj022=l_faz.faz031
          IF STATUS OR SQLCA.SQLERRD[3]= 0 THEN
             LET g_showmsg = l_faz.faz03,"/",l_faz.faz031                  #No.FUN-710028
             CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)    #No.FUN-710028
             LET g_success = 'N'
          END IF
       #財二與稅簽皆未過帳時，才可刪fap_file
       IF g_fay.faypost1<>'Y' AND g_fay.faypost2<>'Y' THEN   #No:FUN-B60140
       #--------- 還原過帳(3)deLETe fap_file
       DELETE FROM fap_file WHERE fap50=l_faz.faz01 AND fap501=l_faz.faz02
                              AND fap03 = '7'
        IF STATUS OR SQLCA.SQLERRD[3]= 0 THEN
           LET g_showmsg = l_faz.faz01,"/",l_faz.faz02,"/",'7'                  #No.FUN-710028
           CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'del fap',STATUS,1)     #No.FUN-710028
           LET g_success = 'N'
        END IF
       END IF  #No:FUN-B60140
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   #--------- 還原過帳(1)UPDATE fay_file
   IF g_success = 'Y' THEN
      UPDATE fay_file SET faypost = 'N' WHERE fay01 = g_fay.fay01
      IF STATUS oR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('fay01',g_fay.fay01,'upd faypost',STATUS,1)                #No.FUN-710028
         LET g_success = 'N'
      END IF
   END IF
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
      LET g_fay.faypost='N'
      DISPLAY by NAME g_fay.faypost #
   END IF
   IF g_fay.fayconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fay.fay08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  #-----------------------------CHI-C90051----------------------------mark
  #IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
  #   LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fay.fay06,"' '7' 'Y'"
  #   CALL cl_cmdrun_wait(g_str)
  #   SELECT fay06,fay07 INTO g_fay.fay06,g_fay.fay07 FROM fay_file
  #    WHERE fay01 = g_fay.fay01
  #   DISPLAY BY NAME g_fay.fay06
  #   DISPLAY BY NAME g_fay.fay07
  #END IF
  #-----------------------------CHI-C90051----------------------------mark
   CALL cl_set_field_pic(g_fay.fayconf,g_chr2,g_fay.faypost,"",g_chr,"")
END FUNCTION 
 
FUNCTION t105_7()
   DEFINE l_faz    RECORD LIKE faz_file.*,
          l_fap34  LIKE fap_file.fap34,
          l_fap341 LIKE fap_file.fap341,
          l_fap31  LIKE fap_file.fap31,
          l_fap32  LIKE fap_file.fap32,
          l_fap42  LIKE fap_file.fap42,
          l_bdate,l_edate  LIKE type_file.dat,          #No.FUN-680070 DATE
          l_yy,l_mm        LIKE type_file.num5,        #No.FUN-680070 SMALLINT
          l_cnt    LIKE type_file.num5   #TQC-780089
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fay.fay01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fay.* FROM fay_file WHERE fay01 = g_fay.fay01
   IF g_fay.faypost2 != 'Y' THEN
      CALL cl_err(g_fay.fay01,'afa-108',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa13 INTO g_faa.faa13 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #--->折舊年月判斷
   IF g_fay.fay02 < g_faa.faa13 THEN
      CALL cl_err(g_fay.fay02,'afa-308',0)
      RETURN
   END IF
   DECLARE t105_cur5 CURSOR FOR
      SELECT * FROM faz_file WHERE faz01=g_fay.fay01
   FOREACH t105_cur5 INTO l_faz.*
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fao_file
       WHERE fao01 = l_faz.faz03
         AND fao02 = l_faz.faz031
         AND fao041 <> '2'                      #MOD-C30795 add
         AND ((fao03 = YEAR(g_fay.fay02) AND fao04 >= MONTH(g_fay.fay02))
          OR fao03 > YEAR(g_fay.fay02))
         AND fao041 = '1'   #MOD-C50044 add
      IF l_cnt > 0 THEN
         CALL cl_err(l_faz.faz03,'afa-348',0)
         RETURN
      END IF
   END FOREACH
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK   #No.FUN-710028
 
    OPEN t105_cl USING g_fay.fay01
    IF STATUS theN
       CALL cl_err("OPEN t105_cl:", STATUS, 1)
       CLOSE t105_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t105_cl INTO g_fay.*          # 鎖住將被更改或取消的資料
    IF SQLCA.SQLCODE THEN
        CALL cl_err(g_fay.fay01,SQLCA.SQLCODE,0)     # 資料被他人LOCK
        CLOSE t105_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
   DECLARE t106_cur31 CURSOR FOR
      SELECT * frOM faz_file WHERE faz01=g_fay.fay01
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t106_cur31 INTO l_faz.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.SQLCODE != 0 THEN
         CALL s_errmsg('faz01',g_fay.fay01,'foreach:',SQLCA.SQLCODE,0) #No.FUN-710028
         EXIT FOREACH
      END IF
      SELECT fap34,fap341,fap31,fap32,fap42
        INTO l_fap34,l_fap341,l_fap31,l_fap32,l_fap42
        FROM fap_file
       WHERE fap50=l_faz.faz01
         AND fap501=l_faz.faz02
         AND fap03='7'    ## 異動代號
      IF STATUS THEN #No.7926
         LET g_showmsg = l_faz.faz01,"/",l_faz.faz02,"/",'7'               #No.FUN-710028
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'sel fap',STATUS,1)  #No.FUN-710028
         LET g_success = 'N'
      END IF
      #--->(1.1)更新資產主檔
      UPDATE faj_file SET faj63  = l_fap34,               #稅簽調整成本
                          faj68  = l_fap341,              #    未折減額
                          faj65  = l_fap31,               #    未使用年限
                          faj201 = l_fap42,
                          faj66  = l_fap32                #    預留殘值
         WHERE faj02=l_faz.faz03 AND faj022=l_faz.faz031
      IF STATUS oR SQLCA.SQLERRD[3]= 0 THEN
         LET g_showmsg = l_faz.faz03,"/",l_faz.faz031                  #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'del fap',STATUS,1)    #No.FUN-710028
         LET g_success = 'N'
      END IF
      #-----No:FUN-B60140-----
      #財一與財二皆未過帳時，才可刪fap_file
       IF g_fay.faypost <>'Y' AND g_fay.faypost1<>'Y' THEN
          #--------- 還原過帳(3)DELETE fap_file
          DELETE FROM fap_file WHERE fap50=l_faz.faz01 AND fap501=l_faz.faz02
                                 AND fap03 = '7'
          IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
             LET g_showmsg = l_faz.faz01,"/",l_faz.faz02,"/",'7'
             CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'del fap',STATUS,1)
             LET g_success = 'N'
          END IF
       END IF
       #-----No:FUN-B60140 END-----   
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   #--------- 還原過帳(1)UPDATE fay_file
   UPDATE fay_file SET faypost2 = 'N' WHERE fay01 = g_fay.fay01
   IF STATUS or sQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('fay01',g_fay.fay01,'upd faypost2',STATUS,1)  #No.FUN-710028
      LET g_fay.faypost2='Y'
      LET g_success = 'N'
   ELSE
      LET g_fay.faypost2='N'
      LET g_success = 'Y'
      DISPLAY by NAME g_fay.faypost2 #
   END IF
   CLOSE t105_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
END FUNCTION 
 
FUNCTION t105_e(p_cmd)
 DEFINE  p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_faz19         LIKE faz_file.faz19, #No.FUN-4C0008
         l_faj61    LIKE faj_file.faj61,
         l_faj28    LIKE faj_file.faj28
 DEFINE  l_fab23    LIKE fab_file.fab23        #No:A099
 DEFINE ls_tmp STRING
 
   LET p_row = 6 LET p_col = 14
   OPEN WINDOW t105_e1 AT p_row,p_col WITH FORM "afa/42f/afat1051"
   ATTRIBUTE (styLE = g_win_style)
 
    CALL cl_ui_locale("afat1051")
 
 
   SELECT faj61
     INTO l_faj61
     FROM faj_file
    WHERE faj02 = g_faz[l_ac].faz03
      AND faj022= g_faz[l_ac].faz031
   IF p_cmd = 'u' THEN
      SELECT faz13,faz14,faz15,faz17,faz18,faz19
        INTO g_e[l_ac].faz13,g_e[l_ac].faz14,g_e[l_ac].faz15,
             g_e[l_ac].faz17,g_e[l_ac].faz18,g_e[l_ac].faz19
        FROM faz_file
       WHERE faz01 = g_fay.fay01
         AND faz02 = g_faz[l_ac].faz02
      IF SQLCA.SQLCODE THEN
         LET g_e[l_ac].faz13 = 0   LET g_e[l_ac].faz14 = 0
         LET g_e[l_ac].faz15 = 0
         LET g_e[l_ac].faz17 = 0   LET g_e[l_ac].faz18 = 0
         LET g_e[l_ac].faz19 = 0
      END IF
   END IF
   Display g_e[l_ac].faz13 TO faz13 #
   Display g_e[l_ac].faz14 TO faz14 #
   Display g_e[l_ac].faz15 TO faz15 #
   Display g_e[l_ac].faz17 TO faz17 #
   Display g_e[l_ac].faz18 TO faz18 #
   Display g_e[l_ac].faz19 TO faz19 #
 
   Input g_e[l_ac].faz17,g_e[l_ac].faz18,g_e[l_ac].faz19
         without DEFAULTS
    FROM faz17,faz18,faz19
      after field faz18
         IF g_aza.aza26 = '2' THEN
            SELECT DISTINCT(fab23) INTO l_fab23 FROM fab_file,faj_file
             WHERE fab01  = faj04
               AND faj02  = g_faz[l_ac].faz03
               AND faj022 = g_faz[l_ac].faz031
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("sel","fab_file,faj_file",g_faz[l_ac].faz03,g_faz[l_ac].faz031,SQLCA.SQLCODE,"","",1)  #No.FUN-660136
               LET g_success = 'N' RETURN
            END IF
            IF l_faj61 MATCHES '[05]' THEN
               LET l_faz19 = 0
            ELSE
               LET l_faz19 = (g_e[l_ac].faz13 + g_e[l_ac].faz17) * l_fab23/100
            END IF
            LET g_e[l_ac].faz19 = l_faz19
         ELSE
            #--->稅簽預留殘值
            CASE l_faj61
              WHEN '0' LET l_faz19 = 0
              WHEN '1' LET l_faz19 = (g_e[l_ac].faz13 + g_e[l_ac].faz17)
                                     /(g_e[l_ac].faz18 + 12)*12
                       LET g_e[l_ac].faz19 = l_faz19
              WHEN '2' LET l_faz19 = 0
              OTHERWISE EXIT CASE
            END CASE
         END IF
         DISPLAY g_e[l_ac].faz19 TO faz19
      
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
        
        ON ACTION controlg      
           CALL cl_cmdask()     
    END INPUT
    IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t105_e1 RETURN END IF
          UPDATE faz_file SET
               faz13=g_e[l_ac].faz13,faz14=g_e[l_ac].faz14,
               faz15=g_e[l_ac].faz15,faz17=g_e[l_ac].faz17,
               faz18=g_e[l_ac].faz18,faz19=g_e[l_ac].faz19
          WHERE faz01 = g_fay.fay01 AND faz02 = g_faz[l_ac].faz02
          IF sqlcA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err3("upd","faz_file",g_fay.fay01,g_faz[l_ac].faz02,SQLCA.SQLCODE,"","",1)  #No.FUN-660136
          END IF
   CLOSE window t105_e1
END FUNCTION 
 
#FUNCTION t105_x()                    #FUN-D20035
FUNCTION t105_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_fay.* FROM fay_file WHERE fay01=g_fay.fay01
   IF g_fay.fay08 MATCHES '[Ss1]' THEN
      CALL cl_err("","mfg3557",0) RETURN
   END IF
   IF g_fay.fay01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fay.fayconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF

   #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_fay.fayconf='X' THEN RETURN END IF
   ELSE
      IF g_fay.fayconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   BEGIN WORK
   LET g_success='Y'
 
   Open t105_cl uSING g_fay.fay01
   IF STATUS then
      CALL cl_err("OPEN t105_cl:", STATUS, 1)
      CLOSE t105_cl
      ROLLBACK WORK
      RETURN
   END IF
   Fetch t105_cl INTO g_fay.*          #鎖住將被更改或取消的資料
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_fay.fay01,SQLCA.SQLCODE,0)      #資料被他人LOCK
      CLOSE t105_cl ROLLBACK WORK RETURN
   END IF
    #-->作廢轉換01/08/01
  #IF cl_void(0,0,g_fay.fayconf)   THEN       #FUN-D20035
  IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF     #FUN-D20035
  IF cl_void(0,0,l_flag) THEN                                          #FUN-D20035
     LET g_chr=g_fay.fayconf
    #IF g_fay.fayconf ='N' THEN                                      #FUN-D20035
     IF p_type = 1 THEN                                              #FUN-D20035
        LET g_fay.fayconf='X'
        LET g_fay.fay08='9'   #FUN-580109
     ELSE
        LET g_fay.fayconf='N'
        LET g_fay.fay08='0'   #FUN-580109
     END IF
 
     UPDATE fay_file SET fayconf = g_fay.fayconf,
                         fay08   = g_fay.fay08,   #FUN-580109
                         faymodu = g_user,
                         faydate = TODAY
      WHERE fay01 = g_fay.fay01
 
     IF STATUS THEN 
        CALL cl_err3("upd","fay_file",g_fay.fay01,"",SQLCA.SQLCODE,"","upd fayconf:",1)  #No.FUN-660136
        LET g_success='N' 
     END IF
     IF g_success='Y' THEN
        COMMIT WORK
        IF g_fay.fayconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_fay.fay08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        CALL cl_set_field_pic(g_fay.fayconf,g_chr2,g_fay.faypost,"",g_chr,"")
        CALL cl_flow_notIFy(g_fay.fay01,'V')
     ELSE
        ROLLBACK WORK
     END IF
     SELECT fayconf,fay08 INTO g_fay.fayconf,g_fay.fay08   #FUN-580109
       FROM fay_file
      WHERE fay01 = g_fay.fay01
     DISPLAY BY NAME g_fay.fayconf
     DISPLAY BY NAME g_fay.fay08   #FUN-580109
  END IF
END FUNCTION

FUNCTION t105_fay09(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_gen02    LIKE gen_file.gen02,
       l_gen03    LIKE gen_file.gen03,             #No:7381
       l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti    #No:7381
      FROM gen_file
     WHERE gen01 = g_fay.fay09
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
 
FUNCTION t105_gen_glcr(p_fay,p_fah)
  DEFINE p_fay     RECORD LIKE fay_file.*
  DEFINE p_fah     RECORD LIKE fah_file.*
 
    IF cl_null(p_fah.fahgslp) THEN
       CALL cl_err(p_fay.fay01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL s_showmsg_init()    #No.FUN-710028
    IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 add
       CALL t105_gl(g_fay.fay01,g_fay.fay02,'0')
    END IF #FUN-C30313 add
   #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 mark
    IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 add
       IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 add
          CALL t105_gl(g_fay.fay01,g_fay.fay02,'1')
       END IF #FUN-C30313 add
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t105_carry_voucher()
  DEFINE l_fahgslp    LIKE fah_file.fahgslp
  DEFINE li_result    LIKE type_file.num5          #No.FUN-680070 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF

  #FUN-B90004--Begin--
   IF NOT cl_null(g_fay.fay06)  THEN
      CALL cl_err(g_fay.fay06,'aap-618',1)
      RETURN
   END IF
  #FUN-B90004---End---
 
    CALL s_get_doc_no(g_fay.fay01) RETURNING g_t1
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
    IF g_fah.fahdmy3 = 'N' THEN RETURN END IF
   #IF g_fah.fahglcr = 'Y' THEN               #FUN-B90004
        IF g_fah.fahglcr = 'Y' OR ( g_fah.fahglcr = 'N' AND NOT cl_null(g_fah.fahgslp)) THEN   #FUN-B90004
       LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
      #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",  #FUN-A50102
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102
                   "  WHERE aba00 = '",g_faa.faa02b,"'",
                   "    AND aba01 = '",g_fay.fay06,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   #FUN-A50102
       PREPARE aba_pre2 FROM l_sql
       DECLARE aba_cs2 CURSOR FOR aba_pre2
       OPEN aba_cs2
       FETCH aba_cs2 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_fay.fay06,'aap-991',1)
          RETURN
       END IF
       LET l_fahgslp = g_fah.fahgslp
    ELSE
      #CALL cl_err('','aap-992',1)   #FUN-B90004 mark
       CALL cl_err('','aap-936',1)   #FUN-B90004
       RETURN

    END IF
    IF cl_null(l_fahgslp) THEN
       CALL cl_err(g_fay.fay01,'axr-070',1)
       RETURN
    END IF
  # IF g_aza.aza63 = 'Y' THEN    #FUN-AB0088 mark
  ##-----No:FUN-B60140 Mark-----
  # IF g_faa.faa31 = 'Y' THEN    #FUN-AB0088 add
  #    IF cl_null(g_fah.fahgslp1) THEN
  #       CALL cl_err(g_fay.fay01,'axr-070',1)
  #       RETURN
  #    END IF
  # END IF
  ##-----No:FUN-B60140 Mark END-----
    LET g_wc_gl = 'npp01 = "',g_fay.fay01,'" AND npp011 = 1'
    LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_fay.fayuser,"' '",g_fay.fayuser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_fay.fay02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"   #No.FUN-680028   #MOD-860284#FUN-860040
    CALL cl_cmdrun_wait(g_str)
    SELECT fay06,fay07 INTO g_fay.fay06,g_fay.fay07 FROM fay_file
     WHERE fay01 = g_fay.fay01
    DISPLAY BY NAME g_fay.fay06
    DISPLAY BY NAME g_fay.fay07
    
END FUNCTION
 
FUNCTION t105_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
  #FUN-B90004--Begin--
   IF cl_null(g_fay.fay06)  THEN
      CALL cl_err(g_fay.fay06,'aap-619',1)
      RETURN
   END IF
  #FUN-B90004---End---

    CALL s_get_doc_no(g_fay.fay01) RETURNING g_t1
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
   #IF g_fah.fahglcr = 'N' THEN     #FUN-B90004
   #   CALL cl_err('','aap-990',1)  #FUN-B90004
    IF g_fah.fahglcr = 'N' AND cl_null(g_fah.fahgslp) THEN    #FUN-B90004
       CALL cl_err('','aap-936',1)  #FUN-B90004
       RETURN
    END IF
    LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",  #FUN-A50102
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102  
                "  WHERE aba00 = '",g_faa.faa02b,"'",
                "    AND aba01 = '",g_fay.fay06,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_fay.fay06,'axr-071',1)
       RETURN
    END IF
 
    LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fay.fay06,"' '7' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT fay06,fay07 INTO g_fay.fay06,g_fay.fay07 FROM fay_file
     WHERE fay01 = g_fay.fay01
    DISPLAY BY NAME g_fay.fay06
    DISPLAY BY NAME g_fay.fay07
END FUNCTION

#FUN-AB0088---add---str---
FUNCTION t105_fin_audit2()
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_rec_b2   LIKE type_file.num5
   DEFINE l_faj28    LIKE faj_file.faj28 
   DEFINE l_faz102   LIKE faz_file.faz102
   DEFINE l_fab232   LIKE fab_file.fab232,
         l_faj332    LIKE faj_file.faj332,
         l_faj3312   LIKE faj_file.faj3312, 
         l_faj302    LIKE faj_file.faj302,
         l_faj312    LIKE faj_file.faj312,
         l_faj432    LIKE faj_file.faj432,
         l_faj352    LIKE faj_file.faj352

   #FUN-C30140---add---str---
   IF g_fay.fay01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF NOT cl_null(g_fay.fay08) AND g_fay.fay08 matches '[Ss]' THEN     
       CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
       RETURN
   END IF 
   #FUN-C30140---add---end---

   OPEN WINDOW t1059_w2 WITH FORM "afa/42f/afat1059"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("afat1059")

   #FUN-BC0004--mark--str
   #LET g_sql =
   #  "SELECT faz02, faz03, faj06,faz031, faz042, faz082,",
   #  "       faz052, faz092, faz062, faz102, faz12",
   #  "  FROM faz_file, OUTER faj_file",
   #  " WHERE faz03 = faj02 AND faz031 = faj022",
   #  "   AND faz01 = '",g_fay.fay01,"'",
   #  " ORDER BY 1"
   #FUN-BC0004--mark--end
   #FUN-BC0004--add--str
   LET g_sql =
      "SELECT faz02, faz03,'' ,faz031, faz042, faz082,",
      "       faz052, faz092, faz062, faz102, faz12",
      "  FROM faz_file ",
      " WHERE faz01 = '",g_fay.fay01,"'",
      " ORDER BY 1" 
   #FUN-BC0004--add--end

   PREPARE afat105_2_pre FROM g_sql

   DECLARE afat105_2_c CURSOR FOR afat105_2_pre

   CALL g_faz2.clear()

   LET l_cnt = 1

   FOREACH afat105_2_c INTO g_faz2[l_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach faz2',STATUS,0)
         EXIT FOREACH
      END IF

      #FUN-BC0004--add-str
      SELECT faj06 INTo g_faz2[l_cnt].faj06
        FROM faj_file
       WHERE faj02 = g_faz2[l_cnt].faz03
         AND faj022 = g_faz2[l_cnt].faz031
      #FUN-BC0004--add--end
      LET l_cnt = l_cnt + 1

   END FOREACH

   CALL g_faz2.deleteElement(l_cnt)

   LET l_rec_b2 = l_cnt - 1
   DISPLAY l_rec_b2 TO FORMONLY.cn2
   LET l_ac = 1

   CALL cl_set_act_visible("cancel", FALSE)

   IF g_fay.fayconf !="N" THEN   #已確認或已作廢單據只能查詢
      DISPLAY ARRAY g_faz2 TO s_faz2.* ATTRIBUTE(COUNT=l_rec_b2,UNBUFFERED)

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
      LET g_forupd_sql = "SELECT faz02, faz03, '',faz031, faz042, faz082,",
                         "       faz052, faz092, faz062, faz102, faz12 ",
                         "  FROM faz_file ",
                         " WHERE faz01 = ? ",
                         "   AND faz02 = ? ",
                         "   FOR UPDATE "

      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)   #FUN-AB0088
      DECLARE t105_2_bcl CURSOR FROM g_forupd_sql 
       
      INPUT ARRAY g_faz2 WITHOUT DEFAULTS FROM s_faz2.*
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
               LET g_faz2_t.* = g_faz2[l_ac].* 
               OPEN t105_2_bcl USING g_fay.fay01,g_faz2_t.faz02
               IF STATUS THEN
                  CALL cl_err("OPEN t105_2_bcl:", STATUS, 1)
               ELSE
                  FETCH t105_2_bcl INTO g_faz2[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_faz2_t.faz02,SQLCA.sqlcode,1)
                  ELSE
                     SELECT faj06 #,faj332,faj3312,faj302,faj312,faj432,faj352 #FUN-BB0122 mark
                       INTO g_faz2[l_ac].faj06 #,l_faj332,l_faj3312,l_faj302,l_faj312,l_faj432,l_faj352 #FUN-BB0122 mark
                       FROM faj_file
                      WHERE faj02 =g_faz2[l_ac].faz03
                        AND faj022 = g_faz2[l_ac].faz031
           #FUN-BB0122---being mark
           #          IF l_faj432 = '7' THEN    #折畢再提
           #             LET l_faj312 = l_faj352
           #          END IF
           #          IF cl_null(g_faz2[l_ac].faz042) OR g_faz2[l_ac].faz042 = 0 THEN
           #              LET g_faz2[l_ac].faz042 = l_faj332+l_faj3312   #未折減額   #MOD-970231
           #          END IF
           #          IF cl_null(g_faz2[l_ac].faz052) OR g_faz2[l_ac].faz052 = 0 THEN
           #              LET g_faz2[l_ac].faz052 = l_faj302            #未用年限
           #          END IF
           #          IF cl_null(g_faz2[l_ac].faz062) OR g_faz2[l_ac].faz062 = 0 THEN
           #              LET g_faz2[l_ac].faz062 = l_faj312           #預估殘值
           #          END IF
           #          IF cl_null(g_faz2[l_ac].faz092) OR g_faz2[l_ac].faz092 = 0 THEN
           #               LET g_faz2[l_ac].faz092 = l_faj302
           #          END IF
           #          IF cl_null(g_faz2[l_ac].faz102) OR g_faz2[l_ac].faz102 = 0 THEN
           #              LET g_faz2[l_ac].faz102 = l_faj312            #異動後預估殘值   #MOD-5B0272
           #          END IF
           #FUN-BB0122---end mark
                     DISPLAY BY NAME g_faz2[l_ac].faj06
                     #DISPLAY BY NAME g_faz2[l_ac].faz042 #FUN-BB0122 mark
                     #DISPLAY BY NAME g_faz2[l_ac].faz062 #FUN-BB0122 mark
                     #DISPLAY BY NAME g_faz2[l_ac].faz092 #FUN-BB0122 mark
                     #DISPLAY BY NAME g_faz2[l_ac].faz102 #FUN-BB0122 mark                    
                  END IF
               END IF
            END IF
         
         
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_faz2[l_ac].* = g_faz2_t.*
               CLOSE t105_2_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
       
           #CHI-C60010---str---
            CALL cl_digcut(g_faz2[l_ac].faz042,g_azi04_1) RETURNING g_faz2[l_ac].faz042
            CALL cl_digcut(g_faz2[l_ac].faz062,g_azi04_1) RETURNING g_faz2[l_ac].faz062
            CALL cl_digcut(g_faz2[l_ac].faz082,g_azi04_1) RETURNING g_faz2[l_ac].faz082
            CALL cl_digcut(g_faz2[l_ac].faz102,g_azi04_1) RETURNING g_faz2[l_ac].faz102
           #CHI-C60010---end--- 
            UPDATE faz_file SET faz042 = g_faz2[l_ac].faz042,
                                faz052 = g_faz2[l_ac].faz052,
                                faz062 = g_faz2[l_ac].faz062,
                                faz082 = g_faz2[l_ac].faz082, 
                                faz092 = g_faz2[l_ac].faz092,
                                faz102 = g_faz2[l_ac].faz102 
             WHERE faz01 = g_fay.fay01
               AND faz02 = g_faz2_t.faz02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","faz_file",g_fay.fay01,g_faz2_t.faz02,SQLCA.sqlcode,"","",1)  
               LET g_faz2[l_ac].* = g_faz2_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
      #FUN-BC0004--add-str
      BEFORE FIELD faz042
         SELECT faj06,faj332,faj3312,faj302,faj312,faj432,faj352
           INTO g_faz2[l_ac].faj06,l_faj332,l_faj3312,l_faj302,l_faj312,l_faj432,l_faj352
           FROM faj_file
          WHERE faj02 =g_faz2[l_ac].faz03
            AND faj022 = g_faz2[l_ac].faz031
         IF l_faj432 = '7' THEN    #折畢再提
            LET l_faj312 = l_faj352
         END IF
         IF cl_null(g_faz2[l_ac].faz042) OR g_faz2[l_ac].faz042 = 0 THEN 
            LET g_faz2[l_ac].faz042 = l_faj332+l_faj3312   #未折減額  
         END IF
         IF cl_null(g_faz2[l_ac].faz052) OR g_faz2[l_ac].faz052 = 0 THEN 
            LET g_faz2[l_ac].faz052 = l_faj302            #未用年限
         END IF
         IF cl_null(g_faz2[l_ac].faz062) OR g_faz2[l_ac].faz062 = 0 THEN 
            LET g_faz2[l_ac].faz062 = l_faj312           #預估殘值
         END IF
         IF cl_null(g_faz2[l_ac].faz092) OR g_faz2[l_ac].faz092 = 0 THEN 
            LET g_faz2[l_ac].faz092 = l_faj302
         END IF
         IF cl_null(g_faz2[l_ac].faz102) OR g_faz2[l_ac].faz102 = 0 THEN 
            LET g_faz2[l_ac].faz102 = l_faj312            #異動后預估殘值 
         END IF
        #CHI-C60010---str---
         CALL cl_digcut(g_faz2[l_ac].faz042,g_azi04_1) RETURNING g_faz2[l_ac].faz042
         CALL cl_digcut(g_faz2[l_ac].faz062,g_azi04_1) RETURNING g_faz2[l_ac].faz062
         CALL cl_digcut(g_faz2[l_ac].faz102,g_azi04_1) RETURNING g_faz2[l_ac].faz102
        #CHI-C60010---end---
         DISPLAY BY NAME g_faz2[l_ac].faj06
         DISPLAY BY NAME g_faz2[l_ac].faz042
         DISPLAY BY NAME g_faz2[l_ac].faz062
         DISPLAY BY NAME g_faz2[l_ac].faz092
         DISPLAY BY NAME g_faz2[l_ac].faz102
      #FUN-BC0004--add-end
      AFTER FIELD faz082
         #LET g_faz2[l_ac].faz082 = cl_numfor(g_faz2[l_ac].faz082,18,g_azi04)  #CHI-C60010 mark
         CALL cl_digcut(g_faz2[l_ac].faz082,g_azi04_1) RETURNING g_faz2[l_ac].faz082   #CHI-C60010
         DISPLAY BY NAME g_faz2[l_ac].faz082
         IF cl_null(g_e[l_ac].faz17) OR g_e[l_ac].faz17 = 0 THEN
            LET g_e[l_ac].faz17 = g_faz2[l_ac].faz082
         END IF

      AFTER FIELD faz092
         IF (cl_null(g_faz2[l_ac].faz092) OR g_faz2[l_ac].faz092 = 0)
           AND g_faz2[l_ac].faz052 !=0 THEN
               NEXT FIELD faz092
         END IF
         IF g_aza.aza26 = '2' THEN
            SELECT UNIQUE(fab232) INTO l_fab232 FROM fab_file,faj_file
             WHERE fab01  = faj04
               AND faj02  = g_faz2[l_ac].faz03
               AND faj022 = g_faz2[l_ac].faz031
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","fab_file,faj_file",g_faz2[l_ac].faz03,g_faz2[l_ac].faz031,SQLCA.sqlcode,"","",1)  #No.FUN-660136
               LET g_success = 'N' RETURN
            END IF
            IF g_faj28 MATCHES '[05]' THEN
               LET l_faz102 = 0
            ELSE
               LET l_faz102 = (g_faz2[l_ac].faz042 + g_faz2[l_ac].faz082) *
                              l_fab232/100
            END IF
            LET g_faz2[l_ac].faz102 = l_faz102
            CALL cl_digcut(g_faz2[l_ac].faz102,g_azi04_1) RETURNING g_faz2[l_ac].faz102  #CHI-C60010
            DISPLAY BY NAME g_faz2[l_ac].faz102
         ELSE
            CASE g_faj28
               WHEN '0'
                  LET l_faz102 = g_faz2[l_ac].faz062
                  #LET l_faz102 = cl_digcut(l_faz102,g_azi04)   #CHI-C60010 mark
                  LET l_faz102 = cl_digcut(l_faz102,g_azi04_1)  #CHI-C60010
                  LET g_faz2[l_ac].faz102 = l_faz102
               WHEN '1'
                  LET l_faz102 = (g_faz2[l_ac].faz042+g_faz2[l_ac].faz082)
                                /(g_faz2[l_ac].faz092+12)*12 
                  #LET l_faz102 = cl_digcut(l_faz102,g_azi04)  #CHI-C60010 mark
                  LET l_faz102 = cl_digcut(l_faz102,g_azi04_1)   #CHI-C60010
                  LET g_faz2[l_ac].faz102 = l_faz102
               WHEN '2'
                  LET l_faz102 = 0
                  #LET l_faz102 = cl_digcut(l_faz102,g_azi04)  #CHI-C60010 mark
                  LET l_faz102 = cl_digcut(l_faz102,g_azi04_1)   #CHI-C60010
                  LET g_faz2[l_ac].faz102 = l_faz102
               WHEN '3'
                  LET l_faz102 = (g_faz2[l_ac].faz042+g_faz2[l_ac].faz082)/10
                  #LET l_faz102 = cl_digcut(l_faz102,g_azi04)  #CHI-C60010 mark
                  LET l_faz102 = cl_digcut(l_faz102,g_azi04_1)   #CHI-C60010
                  LET g_faz2[l_ac].faz102 = l_faz102
               WHEN '4'
                  LET l_faz102 = g_faz2[l_ac].faz062
                  #LET l_faz102 = cl_digcut(l_faz102,g_azi04)  #CHI-C60010 mark
                  LET l_faz102 = cl_digcut(l_faz102,g_azi04_1)   #CHI-C60010
                  LET g_faz2[l_ac].faz102 = l_faz102
               WHEN '5'
                  LET l_faz102 = g_faz2[l_ac].faz062
                  LET l_faz102 = cl_digcut(l_faz102,g_azi04)  #CHI-C60010 mark
                  #LET l_faz102 = cl_digcut(l_faz102,g_azi04_1)   #CHI-C60010
                  LET g_faz2[l_ac].faz102 = l_faz102
            END CASE
         END IF 

      AFTER FIELD faz102
         IF g_faz2[l_ac].faz102 <0 THEN
            CALL cl_err(g_faz2[l_ac].faz102,'aim-391',1)
            LET g_faz2[l_ac].faz102 = g_faz2_t.faz102
            NEXT FIELD faz102
         END IF          
         #LET g_faz2[l_ac].faz102 = cl_digcut(g_faz2[l_ac].faz102,g_azi04)   #CHI-C60010 mark
         CALL cl_digcut(g_faz2[l_ac].faz102,g_azi04_1) RETURNING g_faz2[l_ac].faz102  #CHI-C60010
         DISPLAY BY NAME g_faz2[l_ac].faz102
      
         AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_faz2[l_ac].* = g_faz2_t.*
               CLOSE t105_2_bcl 
               ROLLBACK WORK 
               EXIT INPUT
            END IF
            CLOSE t105_2_bcl 
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
 
   CLOSE WINDOW t1059_w2

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

END FUNCTION
#FUN-AB0088---add---end---
#No.FUN-9C0077 程式精簡

#-----No:FUN-B60140-----

#----過帳--------
FUNCTION t105_s2()
   DEFINE l_faz       RECORD LIKE faz_file.*,
          l_faj       RECORD LIKE faj_file.*,
          l_flag      LIKE type_file.chr1,         #No.FUN-680070 CHAR(01)
          l_bdate,l_edate LIKE type_file.dat          #No.FUN-680070 DATE
   DEFINE l_cnt       LIKE type_file.num5     #No:FUN-B60140

   IF s_shut(0) THEN RETURN END IF

   IF g_faa.faa31 = "N" THEN RETURN END IF

   IF g_fay.fay01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

   SELECT * INTO g_fay.* FROM fay_file WHERE fay01 = g_fay.fay01
   IF g_fay.fayconf != 'Y' OR g_fay.faypost1 != 'N' THEN
      CALL cl_err(g_fay.fay01,'afa-100',0)
      RETURN
   END IF
   LET g_t1 = s_get_doc_no(g_fay.fay01)
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1     #No.FUN-680028

   #-->立帳日期小於關帳日期
   IF g_fay.fay02 < g_faa.faa092 THEN
      CALL cl_err(g_fay.fay01,'aap-176',1) RETURN
   END IF

   CALL s_get_bookno(g_faa.faa072) RETURNING g_flag,g_bookno1,g_bookno2

   #固資己不和二套掛勾，所以原本利用s_get_bookno取到帳別一及帳別二是用是否使用二套帳來判斷
   #此處取帳別二要重新處理，應取固資參數欄位財二帳套faa02c做為帳別二的帳套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF

   CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate

   IF g_fay.fay02 < l_bdate OR g_fay.fay02 > l_edate THEN
      CALL cl_err(g_fay.fay02,'afa-308',0)
      RETURN
   END IF

   IF NOT cl_sure(18,20) THEN RETURN END IF

   BEGIN WORK

   OPEN t105_cl USING g_fay.fay01
   IF STATUS theN
      CALL cl_err("OPEN t105_cl:", STATUS, 1)
      CLOSE t105_cl
      ROLLBACK wORK
      RETURN
   END IF

   FETCH t105_cl INTO g_fay.*          # 鎖住將被更改或取消的資料
   IF sqlca.sqlcode THEN
       CALL cl_err(g_fay.fay01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t105_cl ROLLBACK WORK RETURN
   END IF

   LET g_success = 'Y'

   DECLARE t105_cur22 CURSOR FOR
      SELECT * FROM faz_file WHERE faz01=g_fay.fay01

   CALL s_showmsg_init()
   FOREACH t105_cur22 INTO l_faz.*
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success="Y"
      END IF

      IF sqlca.sqlcode != 0 THEN
         CALL s_errmsg('faz01',g_fay.fay01,'foreach:',SQLCA.sqlcode,1)
         EXIT forEACH
         LET g_success='N'
      END IF

      #------- 先找出對應之 faj_file 資料
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_faz.faz03
                                            AND faj022=l_faz.faz031
      IF STATUS THEN
         LET g_showmsg = l_faz.faz03,"/",l_faz.faz031
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)
         LET g_success = 'N'
      END IF

      #------- 過帳(1)INSERT fap_file--------
      IF cl_null(l_faz.faz031) THEN
         LET l_faz.faz031 = ' '
      END IF

     #CHI-C60010---str---
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
      CALL cl_digcut(l_faz.faz102,g_azi04_1) RETURNING l_faz.faz102
      CALL cl_digcut(l_faz.faz082,g_azi04_1) RETURNING l_faz.faz082
      CALL cl_digcut(l_faj.faj3312,g_azi04_1) RETURNING l_faj.faj3312
     #CHI-C60010---end---

      #-----No:FUN-B60140-----
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fap_file
       WHERE fap50  = l_faz.faz01
         AND fap501 = l_faz.faz02
         AND fap03  = '7'              ## 異動代號
      IF l_cnt = 0 THEN   #無fap_file資料
         INSERT INTO fap_file (fap01,fap02,fap021,fap03,fap04,fap05,fap06,fap07,
                               fap08,fap09,fap10,fap101,fap11,fap12,fap13,fap14,
                               fap15,fap16,fap17,fap18,fap19,fap20,fap201,fap21,
                               fap22,fap23,fap24,fap25,fap26,fap30,fap31,fap32,
                               fap33,fap34,fap341,fap35,fap36,fap37,fap38,fap39,
                               fap40,fap41,fap50,fap501,fap52,fap53,fap54,fap69,
                               fap70,fap71,
                               fap121,fap131,fap141,fap77,
                               fap052,fap062,fap072,fap082,
                               fap092,fap103,fap1012,fap112,
                               fap152,fap162,fap212,fap222,
                               fap232,fap242,fap252,fap262,
                               fap522,fap532,fap542,fap56,fap562,fap772,faplegal)
         VALUES (l_faj.faj01,l_faz.faz03,l_faz.faz031,'7',g_fay.fay02,
                 l_faj.faj43,l_faj.faj28,l_faj.faj30,l_faj.faj31,
                 l_faj.faj14,l_faj.faj141,l_faj.faj33+l_faj.faj331,l_faj.faj32,
                 l_faj.faj53,l_faj.faj54,l_faj.faj55,l_faj.faj23,
                 l_faj.faj24,l_faj.faj20,l_faj.faj19,l_faj.faj21,
                 l_faj.faj17,l_faj.faj171,l_faj.faj58,l_faj.faj59,
                 l_faj.faj60,l_faj.faj34,l_faj.faj35,l_faj.faj36,
                 l_faj.faj61,l_faj.faj65,l_faj.faj66,l_faj.faj62,
                 l_faj.faj63,l_faj.faj68,l_faj.faj67,l_faj.faj69,
                 l_faj.faj70,l_faj.faj71,l_faj.faj72,l_faj.faj73,
                 l_faj.faj100,l_faz.faz01,l_faz.faz02,l_faz.faz09,
                 l_faz.faz10,l_faz.faz08,l_faz.faz18,l_faz.faz19,l_faz.faz17,
                 l_faj.faj531,l_faj.faj541,l_faj.faj551,l_faj.faj43,
                 l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,
                 l_faj.faj142,l_faj.faj1412,l_faj.faj332+l_faj.faj3312,l_faj.faj322,
                 l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
                 l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,
                 l_faz.faz092,l_faz.faz102,l_faz.faz082,0,0,l_faj.faj432,g_legal)
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
                             fap772 = l_faj.faj432,
                             fap522 = l_faz.faz092,
                             fap532 = l_faz.faz102,
                             fap542 = l_faz.faz082,
                             fap562 = 0
                       WHERE fap50  = l_faz.faz01
                         AND fap501 = l_faz.faz02
                         AND fap03  = '7'              ## 異動代號
      END IF
      #-----No:FUN-B60140 END-----

      IF STATUS THEN                           #FUN-580109
         LET g_showmsg = l_faz.faz03,"/",l_faz.faz031,"/",'7',"/",g_fay.fay02          #No.FUN-710028
         CALL s_errmsg('fap02,fap021,fap03,fap04',g_showmsg,'ins fap',STATUS,1)        #No.FUN-710028
         LET g_success = 'N'
      END IF

      #--------- 過帳(3)UPDATE faj_file
      UPDATE faj_file SET faj100 = g_fay.fay02,          #異動日期
                          faj432 = '8',
                          faj1412 = faj1412 + l_faz.faz082,
                          faj332 = faj332 + l_faz.faz082,
                          faj302 = l_faz.faz092,
                          faj312 = l_faz.faz102
       WHERE faj02=l_faz.faz03 AND faj022=l_faz.faz031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_faz.faz03,"/",l_Faz.faz031
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)
         LET g_success = 'N'
      END IF
   END FOREACH

   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF

   #--------- 過帳(1)UPDATE faypost
   IF g_success = 'Y' THEN
      UPDATE fay_file SET faypost1= 'Y' WHERE fay01 = g_fay.fay01
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('fay01',g_fay.fay01,'upd faypost',STATUS,1)
         LET g_success = 'N'
      END IF
   END IF

   CLOSE t105_cl
   CALL s_showmsg()
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
      LET g_fay.faypost1='Y'
      DISPLAY by NAME g_fay.faypost1
   END IF

   #IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN #FUN-C30313 mark
   IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN #FUN-C30313 add
      LET g_wc_gl = 'npp01 = "',g_fay.fay01,'" AND npp011 = 1'
      LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_fay.fayuser,"' '",g_fay.fayuser,"' '",g_faa.faa02p,"'
                '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_fay.fay02,"'
                'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"
      CALL cl_cmdrun_wait(g_str)
      SELECT fay062,fay072 INTO g_fay.fay062,g_fay.fay072 FROM fay_file
       WHERE fay01 = g_fay.fay01
      DISPLAY BY NAME g_fay.fay062
      DISPLAY BY NAME g_fay.fay072
   END IF

END FUNCTION

FUNCTION t105_w2()
   DEFINE l_aba19     LIKE aba_file.aba19     #No.FUN-680028
   DEFINE l_sql       LIKE type_file.chr1000             #No.FUN-680028       #No.FUN-680070 CHAR(1000)
   DEFINE l_dbs       STRING                  #No.FUN-680028
   DEFINE l_faz    RECORD LIKE faz_file.*,
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
          l_flag      LIKE type_file.chr1,         #No.FUN-680070 CHAR(01)
          l_bdate,l_edate LIKE type_file.dat,          #No.FUN-680070 DATE
          l_cnt    LIKE type_file.num5     #TQC-780089
   DEFINE l_fap052   LIKE fap_file.fap052
   DEFINE l_fap103   LIKE fap_file.fap103
   DEFINE l_fap072   LIKE fap_file.fap072
   DEFINE l_fap082   LIKE fap_file.fap082
   DEFINE l_fap1012  LIKE fap_file.fap1012
   DEFINE l_cnt1     LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF

   IF g_faa.faa31 = "N" THEN RETURN END IF

   IF g_fay.fay01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

   SELECT * INTO g_fay.* FROM fay_file WHERE fay01 = g_fay.fay01
   IF g_fay.faypost1 != 'Y' THEN
      CALL cl_err3("sel","fay_file",g_fay.fay01,"","afa-108","","",1)
      RETURN
   END IF

   #-->立帳日期小於關帳日期
   IF g_fay.fay02 < g_faa.faa092 THEN
      CALL cl_err(g_fay.fay01,'aap-176',1) RETURN
   END IF

   #--->折舊年月判斷
   CALL s_get_bookno(g_faa.faa072) RETURNING g_flag,g_bookno1,g_bookno2

   #固資己不和二套掛勾，所以原本利用s_get_bookno取到帳別一及帳別二是用是否使用二套帳來判斷
   #此處取帳別二要重新處理，應取固資參數欄位財二帳套faa02c做為帳別二的帳套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF

   CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate

   IF g_fay.fay02 < l_bdate OR g_fay.fay02 > l_edate THEN
      CALL cl_err(g_fay.fay02,'afa-308',0)
      RETURN
   END IF

   #-->已拋轉總帳, 不可取消確認
   IF NOT cl_null(g_fay.fay062) AND g_fah.fahglcr = 'N' THEN
      CALL cl_err(g_fay.fay062,'aap-145',1)
      RETURN
   END IF

   DECLARE t105_cur42 CURSOR FOR
      SELECT * FROM faz_file WHERE faz01=g_fay.fay01

   FOREACH t105_cur42 INTO l_faz.*
      LET l_cnt1 = 0
      SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
       WHERE fbn01 = l_faz.faz03
         AND fbn02 = l_faz.faz031
         AND fbn041 <> '2'                      #MOD-C30795 add 
         AND ((fbn03 = YEAR(g_fay.fay02) AND fbn04 >= MONTH(g_fay.fay02))
          OR fbn03 > YEAR(g_fay.fay02))
         AND fbn041 = '1'   #MOD-C50044 add
      IF l_cnt1> 0 THEN
         CALL cl_err(l_faz.faz03,'afa-348',0)
         RETURN
      END IF
   END FOREACH

   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_fay.fay01) RETURNING g_t1
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
#FUN-C30313---mark---START
#  IF NOT cl_null(g_fay.fay06) THEN
#     IF NOT (g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y') THEN
#        CALL cl_err(g_fay.fay01,'axr-370',0) RETURN
#     END IF
#  END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
   IF NOT cl_null(g_fay.fay062) THEN
      IF NOT (g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y') THEN
         CALL cl_err(g_fay.fay01,'axr-370',0) RETURN
      END IF
   END IF
#FUN-C30313---add---END-------

   #IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 mark
   IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 add
      LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
      LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
                  "  WHERE aba00 = '",g_faa.faa02c,"'",
                  "    AND aba01 = '",g_fay.fay062,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE aba_pre12 FROM l_sql
      DECLARE aba_cs12 CURSOR FOR aba_pre12
      OPEN aba_cs12
      FETCH aba_cs12 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_fay.fay06,'axr-071',1)
         RETURN
      END IF
   END IF


   IF NOT cl_sure(18,20) THEN RETURN END IF
  #--------------------------------CHI-C90051------------------------(S)
   IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fay.fay062,"' '7' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT fay062,fay072 INTO g_fay.fay062,g_fay.fay072 FROM fay_file
       WHERE fay01 = g_fay.fay01
      DISPLAY BY NAME g_fay.fay062
      DISPLAY BY NAME g_fay.fay072
      IF NOT cl_null(g_fay.fay062) THEN
         CALL cl_err('','aap-929',0)
         RETURN
      END IF
   END IF
  #--------------------------------CHI-C90051------------------------(E)

   BEGIN WORK

   OPEN t105_cl USING g_fay.fay01
   IF STATUS theN
      CALL cl_err("OPEN t105_cl:", STATUS, 1)
      CLOSE t105_cl
      ROLLBACK wORK
      RETURN
   END IF

   FETCH t105_cl INTO g_fay.*          # 鎖住將被更改或取消的資料
   IF sqlca.sqlcode THEN
      CALL cl_err(g_fay.fay01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t105_cl ROLLBACK WORK RETURN
   END IF

   LET g_success = 'Y'

   #--------- 還原過帳(2)UPDATE faj_file
   DECLARE t105_cur32 CURSOR FOR
      SELECT * FROM faz_file WHERE faz01=g_fay.fay01

   CALL s_showmsg_init()    #No.FUN-710028

   FOREACH t105_cur32 INTO l_faz.*
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success="Y"
      END IF

      IF sqlca.sqlcode != 0 THEN
         CALL s_errmsg('faz01',g_fay.fay01,'foreach:',SQLCA.sqlcode,0) #No.FUN-710028
         EXIT FOREACH
      END IF

      #----- 找出 faj_file 中對應之財產編號+附號
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_faz.faz03
                                            AND faj022=l_faz.faz031
      IF STATUS THEN
         LET g_showmsg = l_faz.faz03,"/",l_faz.faz031
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,0)
         CONTINUE FOREACH
      END IF

      #----- 找出 fap_file 之 fap05 以便 UPDATE faj_file.faj43
      SELECT fap05,fap10,fap101,fap07,fap08,fap34,fap341,fap31,fap32,fap41
             ,fap052,fap103,fap1012,fap072,fap082
        INTO l_fap05,l_fap10,l_fap101,l_fap07,l_fap08,l_fap34,l_fap341,l_fap31,
             l_fap32,l_fap41,l_fap052,l_fap103,l_fap1012,l_fap072,l_fap082
        FROM fap_file
       WHERE fap50=l_faz.faz01 AND fap501=l_faz.faz02 AND fap03='7'
      IF STATUS THEN
         LET g_showmsg = l_faz.faz01,"/",l_faz.faz02,"/",'7'
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'sel fap',STATUS,1)
         LET g_success = 'N'
      END IF

     #CHI-C60010---str---
      CALL cl_digcut(l_fap082,g_azi04_1) RETURNING l_fap082
      CALL cl_digcut(l_fap103,g_azi04_1) RETURNING l_fap103
      CALL cl_digcut(l_fap1012,g_azi04_1) RETURNING l_fap1012
     #CHI-C60010---end---
      UPDATE faj_file SET faj100 = l_fap41,   #最近異動日
                          faj432 = l_fap052,
                          faj302 = l_fap072,
                          faj312 = l_fap082,
                          faj1412 =l_fap103,
                          faj332 = l_fap1012
       WHERE faj02=l_faz.faz03 AND faj022=l_faz.faz031
      IF statUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_faz.faz03,"/",l_faz.faz031                  #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)    #No.FUN-710028
         LET g_success = 'N'
      END IF

      #財一與稅簽皆未過帳時，才可刪fap_file
      IF g_fay.faypost <>'Y' AND g_fay.faypost2<>'Y' THEN
         #--------- 還原過帳(3)DELETE fap_file
         DELETE FROM fap_file WHERE fap50=l_faz.faz01 AND fap501=l_faz.faz02
                                AND fap03 = '7'
         IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
            LET g_showmsg = l_faz.faz01,"/",l_faz.faz02,"/",'7'
            CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'del fap',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF

   #--------- 還原過帳(1)UPDATE fay_file
   IF g_success = 'Y' THEN
      UPDATE fay_file SET faypost1 = 'N' WHERE fay01 = g_fay.fay01
      IF STATUS oR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('fay01',g_fay.fay01,'upd faypost',STATUS,1)                #No.FUN-710028
         LET g_success = 'N'
      END IF
   END IF

   CALL s_showmsg()

   IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
      LET g_fay.faypost1='N'
      DISPLAY by NAME g_fay.faypost1
   END IF

  #-----------------------------CHI-C90051----------------------------mark
  ##IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN #FUN-C30313 mark
  #IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN #FUN-C30313 add
  #   LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fay.fay062,"' '7' 'Y'"
  #   CALL cl_cmdrun_wait(g_str)
  #   SELECT fay062,fay072 INTO g_fay.fay062,g_fay.fay072 FROM fay_file
  #    WHERE fay01 = g_fay.fay01
  #   DISPLAY BY NAME g_fay.fay062
  #   DISPLAY BY NAME g_fay.fay072
  #END IF
  #-----------------------------CHI-C90051----------------------------mark

END FUNCTION

FUNCTION t105_carry_voucher2()
   DEFINE l_fahgslp    LIKE fah_file.fahgslp
   DEFINE li_result    LIKE type_file.num5
   DEFINE l_dbs        STRING
   DEFINE l_sql        STRING
   DEFINE l_n          LIKE type_file.num5

   IF g_faa.faa31="N" THEN RETURN END IF

   IF NOT cl_confirm('aap-989') THEN RETURN END IF
  #FUN-B90004--Begin--
   IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
      IF NOT cl_null(g_fay.fay062)  THEN
         CALL cl_err(g_fay.fay062,'aap-618',1)
         RETURN
      END IF
   END IF #FUN-C30313 add
  #FUN-B90004---End---

   CALL s_get_doc_no(g_fay.fay01) RETURNING g_t1
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1

   #IF g_fah.fahdmy3 = 'N' THEN RETURN END IF #FUN-C30313 mark
   IF g_fah.fahdmy32 = 'N' THEN RETURN END IF #FUN-C30313 add

  #IF g_fah.fahglcr = 'Y' THEN               #FUN-B90004
   IF g_fah.fahglcr = 'Y' OR ( g_fah.fahglcr = 'N' AND NOT cl_null(g_fah.fahgslp1)) THEN   #FUN-B90004
      LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
      LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
                  "  WHERE aba00 = '",g_faa.faa02c,"'",
                  "    AND aba01 = '",g_fay.fay062,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE aba_pre22 FROM l_sql
      DECLARE aba_cs22 CURSOR FOR aba_pre22
      OPEN aba_cs22
      FETCH aba_cs22 INTO l_n
      IF l_n > 0 THEN
         CALL cl_err(g_fay.fay062,'aap-991',1)
         RETURN
      END IF

      LET l_fahgslp = g_fah.fahgslp
   ELSE
     #CALL cl_err('','aap-992',1)   #FUN-B90004 mark
      CALL cl_err('','aap-936',1)   #FUN-B90004
      RETURN
   END IF

   IF cl_null(g_fah.fahgslp1) THEN
      CALL cl_err(g_fay.fay01,'axr-070',1)
      RETURN
   END IF

   LET g_wc_gl = 'npp01 = "',g_fay.fay01,'" AND npp011 = 1'
   LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_fay.fayuser,"' '",g_fay.fayuser,"' '",g_faa.faa02p,"' 
             '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_fay.fay02,"' 'Y' '1' 'Y' 
             '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"   #No.FUN-680028   #MOD-860284#FUN-860040
   CALL cl_cmdrun_wait(g_str)
   SELECT fay062,fay072 INTO g_fay.fay062,g_fay.fay072 FROM fay_file
    WHERE fay01 = g_fay.fay01
   DISPLAY BY NAME g_fay.fay062
   DISPLAY BY NAME g_fay.fay072

END FUNCTION

FUNCTION t105_undo_carry_voucher2()
   DEFINE l_aba19    LIKE aba_file.aba19
   DEFINE l_sql      LIKE type_file.chr1000
   DEFINE l_dbs      STRING

   IF g_faa.faa31="N" THEN RETURN END IF

   IF NOT cl_confirm('aap-988') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF cl_null(g_fay.fay062)  THEN
       CALL cl_err(g_fay.fay062,'aap-619',1)
       RETURN
    END IF
   #FUN-B90004---End---

   CALL s_get_doc_no(g_fay.fay01) RETURNING g_t1
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
  #IF g_fah.fahglcr = 'N' THEN        #FUN-B90004 mark
  #   CALL cl_err('','aap-990',1)     #FUN-B90004 mark
   IF g_fah.fahglcr = 'N' AND cl_null(g_fah.fahgslp1) THEN    #FUN-B90004
      CALL cl_err('','aap-936',1)     #FUN-B90004
      RETURN
   END IF

   LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
   LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
               "  WHERE aba00 = '",g_faa.faa02c,"'",
               "    AND aba01 = '",g_fay.fay062,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   PREPARE aba_pre3 FROM l_sql
   DECLARE aba_cs3 CURSOR FOR aba_pre3
   OPEN aba_cs3
   FETCH aba_cs3 INTO l_aba19
   IF l_aba19 = 'Y' THEN
      CALL cl_err(g_fay.fay062,'axr-071',1)
      RETURN
   END IF

   LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fay.fay062,"' '7' 'Y'"
   CALL cl_cmdrun_wait(g_str)
   SELECT fay062,fay072 INTO g_fay.fay062,g_fay.fay072 FROM fay_file
    WHERE fay01 = g_fay.fay01
   DISPLAY BY NAME g_fay.fay062
   DISPLAY BY NAME g_fay.fay072

END FUNCTION
#-----No:FUN-B60140 END-----
                                                                    

