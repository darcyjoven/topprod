# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afat107.4gl
# Descriptions...: 固定資產調整作業
# Date & Author..: 96/06/05 By Sophia
# Modify.........: 97/04/14 By Danny 稅簽資料預設與財簽資料相同
# Modify.........: 02/10/15 BY Maggie   No.A032
# Modify.........: No:7837 03/08/19 By Wiky 呼叫自動取單號時應在 Transction中
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-470515 04/07/30 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-480098 04/08/13 By Nicola 調整稅簽修改單身輸入順序
# Modify.........: No.MOD-490235 04/09/13 By Yuna 自動生成改成用confirm的方式
# Modify.........: No.MOD-490164 04/09/16 By Kitty 增加判斷,若稅簽已過帳,不可取消確認
# Modify.........: No.MOD-490339 04/09/27 By Kitty 1.[稅簽過帳]欄位請default'N'
#                                                  2.沒做財簽過帳,不能做稅簽過帳,這時系統出現的訊息不正常
# Modify.........: No.MOD-490181 04/09/29 By Kitty 自動產生後,財產名稱顯示不正常
# Modify.........: No.MOD-4A0248 04/10/25 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: NO.FUN-550034 05/05/17 By jackie 單據編號加大
# Modify.........: No.FUN-580109 05/10/21 By Sarah 以EF為backend engine,由TIPTOP處理前端簽核動作
# Modify.........: No.FUN-5B0018 05/11/04 By Sarah 調整日期沒有判斷關帳日
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# MOdify.........: No.MOD-5C0135 05/12/23 By Smapmin 重選財編,附號.中文沒有重帶
# Modify.........: No.TQC-620120 06/03/02 By Smapmin 當附號為NULL時,LET 附號為空白
# Modify.........: No.TQC-630073 06/03/07 By Mandy 流程訊息通知功能
# Modify.........: No.FUN-630045 06/03/15 BY Alexstar 新增申請人(表單關係人)欄位
# Modify.........: No.FUN-640243 06/05/15 By Echo 自動執行確認功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670060 06/08/07 By Ray 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680028 06/08/22 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION t107_q() 一開始應清空g_fbc.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.MOD-690081 06/12/06 By Smapmin 已確認的單子不可再重新產生分錄
# Modify.........: No.MOD-710116 07/01/18 By Dido 調整成本與調整折舊金額須寫入 fan14/fan15 中
# Modify.........: No.FUN-710028 07/02/02 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-720074 07/03/01 By Smapmin 檢查資產盤點期間應不可做異動
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740033 07/04/11 By Carrier 會計科目加帳套-財務
# Modify.........: No.MOD-740373 07/04/24 By rainy 輸入無效的單據別無阻擋
# Modify.........: No.TQC-740222 07/04/24 By Echo 從ERP簽核時，「拋轉傳票」、「傳票拋轉還原」action應隱藏
# Modify.........: No.TQC-740055 07/04/30 By xufeng 單身中有多個欄位能輸入負數，比如：異動后未用年限、異動后累積折舊
# Modify.........: No.MOD-750051 07/05/11 By Smapmin 金額欄位以本國幣取位
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760182 07/06/27 By chenl   自動產生QBE不可為空。
# Modify.........: No.MOD-780022 07/08/23 By Smapmin 單身新增調整成本欄位
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.TQC-780089 07/09/21 By Smapmin 自動產生或單身輸入資產編號時,當月有折舊不可輸入
#                                                    已有折舊資料不可過帳還原或確認
# Modify.........: No.TQC-7B0060 07/11/13 By Rayven 在判斷已有折舊資料不可過帳還原時，應該再加上一個判斷條件：如果fan041為2調整時，是可以過帳還原的
# Modify.........: No.MOD-7C0096 07/12/17 By Smapmin 修正TQC-7B0060
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-840111 08/04/23 By lilignyu 預設申請人員登入帳號
# Modify.........: No.FUN-850068 08/05/14 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.MOD-860284 08/07/04 By Sarah 使用afap302拋轉程式,原先傳g_user改為fbcuser
# Modify.........: No.MOD-870165 08/07/21 By Smapmin 新增後馬上過帳就會失敗
# Modify.........: No.CHI-860025 08/07/23 By Smapmin 根據TQC-780089的修改,需區分財簽與稅簽
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.MOD-8B0200 08/11/20 By clover新增function t107_fbd031  p_cmd 條件 u
# Modify.........: No.MOD-8B0221 08/11/21 By Sarah t107_i()的AFTER FIELD fbc02段增加CALL s_yp()取得g_yy,g_mm
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.MOD-910240 09/01/22 By Sarah 稅簽過帳/還原時,應寫入/刪除fao_file
# Modify.........: No.MOD-930246 09/03/24 By Sarah 稅簽過帳/稅簽過帳還原增加回寫faj205
# Modify.........: No.MOD-950166 09/05/18 By xiaofeizhu 增加對單身的管控
# Modify.........: No.MOD-970231 09/07/24 By Sarah 計算未折減額時,應抓faj33+faj331
# Modify.........: No.FUN-980003 09/08/10 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9B0032 09/11/30 By Sarah 寫入fap_file時,也應寫入fap77=faj43
# Modify.........: No:FUN-9C0077 10/01/06 By baofei 程序精簡
# Modify.........: No:MOD-A10130 10/01/21 By Sarah 當出現afa-097訊息時,請將單身財產編號、附號清空
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-A30240 10/03/31 by sabrina 當fbd09-fbd04=0且fbd10-fbd05=0時，不需檢查分錄底稿是否平衡
# Modify.........: No.MOD-A40033 10/04/07 By lilingyu 如果是大陸版,則按調整后資產總成本*殘值率 來計算"調整后的預計殘值"
# Modify.........: No.MOD-A20122 10/04/08 by wujie  过帐时更新fap54  
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A60036 10/07/12 By Summer 過帳檢查改用s_azmm,增加aza63判斷
# ModIFy.........: No:MOD-A80137 10/08/19 By Dido 過帳與取消過帳應檢核關帳日 
# Modify.........: No:TQC-AB0257 10/11/30 By suncx 新增fbd03欄位的控管
# Modify.........: No:MOD-AC0055 10/12/07 By Carrier 大陆版时,当月有做过折旧后可以做调整
# Modify.........: No:TQC-B20043 11/02/17 By yinhy INSERT時增加兩個欄位fan20，fan201
# Modify.........: No:TQC-B20074 11/02/18 By yinhy INSERT時增加兩個欄位fao20，fao201
# Modify.........: No:MOD-B30201 11/03/16 By zhangwei  LET l_fbd.fbd031 = '   ' -->這邊應該是一個空白' ',誤寫成三個空白了,請調整
# Modify.........: No.FUN-AB0088 11/04/07 By chenying 因固資拆出財二功能，原本寫入fap亦有新增欄位，增加對應處理
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.TQC-B30156 11/05/12 By Dido 預設 fap56 為 0
# Modify.........: No.FUN-B50090 11/06/01 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50118 11/06/13 By belle 自動產生鍵增加QBE條件-族群編號
# Modify.........: No.FUN-B80054 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No:FUN-B60140 11/09/08 By minpp "財簽二二次改善" 追單
# Modify.........: No:TQC-BB0012 11/11/03 By Sarah UPDATE fap54與fap542的變數使用錯誤
# Modify.........: No:FUN-BA0112 11/11/08 By Sakura 財簽二5.25與5.1程式比對不一致修改
# Modify.........: No:CHI-B80007 11/11/12 By johung 增加afa-309控卡 
# Modify.........: NO:FUN-B90004 11/11/17 By Belle 自動拋轉傳票單別一欄有值，即可進行傳票拋轉/傳票拋轉還原
# Modify.........: No:FUN-BC0004 11/12/01 By xuxz 處理相關財簽二無法存檔問題
# Modify.........: No:MOD-BC0025 11/12/10 By johung 調整afa-092控卡的判斷
# Modify.........: NO:FUN-BB0122 12/01/13 By Sakura 財二預設修改
# Modify.........: No:MOD-BC0125 12/01/13 By Sakura 產生分錄及分錄底稿Action加判斷
#                                                    產生分錄(財簽二)及分錄底稿(財簽二)加判斷
# Modify.........: No.MOD-BC0131 12/01/13 By Sakura 寫入fbn_file時，多寫入fbn20=faj541

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20012 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:TQC-C20313 12/02/21 By minpp 修改t107_s2()段INSERT INTO fbn_file下面的報錯信息g_showmsg
# Modify.........: No:TQC-C20236 12/02/27 By zhangweib 財簽二參數開啟後，無法拋轉財簽二的傳票
# Modify.........: No:TQC-C30074 12/03/05 By zhangweib AFTER FIELD fbd03時,應該用l_n 但卻用g_cnt 來控制,造成程式一定會跑入ELSE
# Modify.........: No:FUN-C30140 12/03/12 By Mandy (1)TIPTOP端簽核時,以下ACTION應隱藏
#                                                     分錄底稿二,產生分錄底稿(財簽二),財簽二資料,拋轉傳票(財簽二),傳票拋轉還原(財簽二),過帳(財簽二),過帳還原(財簽二)
#                                                  (2)送簽中,應不可執行"自動產生" ,"分錄底稿","分錄底稿二","產生分錄底稿","產生分錄底稿(財簽二）","財簽二資料","稅簽修改"ACTION
# Modify.........: No.MOD-C30747 12/03/16 By minpp 財簽二5.3與5.25程式比對不一致修改
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 原使用fahdmy3判斷的程式，將財二部份拆分出來使用fahdmy32處理
# Modify.........: No:MOD-C50044 12/05/09 By Elise 按下確認時，會出現afai900內當月份有做調整的單被當成是已提列折舊的單
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.MOD-C50255 12/06/05 By Polly 增加控卡維護拋轉總帳單別
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C60010 12/06/15 By jinjj 財簽二欄位需依財簽二幣別做取位
# Modify.........: No.MOD-C70198 12/07/18 By Polly 固資調整單稅簽過帳後稅簽調整成本(faj63)資訊未更新
# Modify.........: No.MOD-C70265 12/07/27 By Polly 資產不存在時,將 afa-093 改用訊息 afa-134
# Modify.........: No:CHI-C90051 12/09/08 By Polly 將拋轉還原程式移至更新確認碼/過帳碼前處理，並判斷傳票編號如不為null時，則RETURN
# Modify.........: No:CHI-CA0063 12/10/29 By Belle 修改分攤計算方式
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# Modify.........: No:FUN-C90088 12/12/17 By Belle 增加固資耐用年限
# Modify.........: No:MOD-D10283 13/01/30 By apo 修改狀態經過財產附號(fbd031)不應該修改客戶的輸入資料,依照財產編號(fbd03)處理方式
# Modify.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D40098 13/04/16 By Lori 針對 afa-186 訊息,增加fan041/fao041/fbn041來源為1.折舊計算
# Modify.........: No:FUN-E80012 18/11/29 By lixwz 修改付款日期之後,tic現金流量明細重複

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fbc    RECORD LIKE fbc_file.*,
    g_fbc_t  RECORD LIKE fbc_file.*,
    g_fbc_o  RECORD LIKE fbc_file.*,
    g_fahconf       LIKE fah_file.fahconf,
    g_fahpost       LIKE fah_file.fahpost,
    g_fahapr        LIKE fah_file.fahapr,             #FUN-640243
    g_fbd           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    fbd02     LIKE fbd_file.fbd02,
                    fbd03     LIKE fbd_file.fbd03,
                    fbd031    LIKE fbd_file.fbd031,
                    faj06     LIKE faj_file.faj06,
                    fbd04     LIKE fbd_file.fbd04,
                    faj141    LIKE faj_file.faj141,   #MOD-780022
                    fbd09     LIKE fbd_file.fbd09,
                    fbd05     LIKE fbd_file.fbd05,
                    fbd10     LIKE fbd_file.fbd10,
                    fbd06     LIKE fbd_file.fbd06,
                    fbd11     LIKE fbd_file.fbd11,
                    fbd07     LIKE fbd_file.fbd07,
                    fbd12     LIKE fbd_file.fbd12
                    ,fbdud01 LIKE fbd_file.fbdud01,
                    fbdud02 LIKE fbd_file.fbdud02,
                    fbdud03 LIKE fbd_file.fbdud03,
                    fbdud04 LIKE fbd_file.fbdud04,
                    fbdud05 LIKE fbd_file.fbdud05,
                    fbdud06 LIKE fbd_file.fbdud06,
                    fbdud07 LIKE fbd_file.fbdud07,
                    fbdud08 LIKE fbd_file.fbdud08,
                    fbdud09 LIKE fbd_file.fbdud09,
                    fbdud10 LIKE fbd_file.fbdud10,
                    fbdud11 LIKE fbd_file.fbdud11,
                    fbdud12 LIKE fbd_file.fbdud12,
                    fbdud13 LIKE fbd_file.fbdud13,
                    fbdud14 LIKE fbd_file.fbdud14,
                    fbdud15 LIKE fbd_file.fbdud15
                    END RECORD,
    g_fbd_t         RECORD
                    fbd02     LIKE fbd_file.fbd02,
                    fbd03     LIKE fbd_file.fbd03,
                    fbd031    LIKE fbd_file.fbd031,
                    faj06     LIKE faj_file.faj06,
                    fbd04     LIKE fbd_file.fbd04,
                    faj141    LIKE faj_file.faj141,   #MOD-780022
                    fbd09     LIKE fbd_file.fbd09,
                    fbd05     LIKE fbd_file.fbd05,
                    fbd10     LIKE fbd_file.fbd10,
                    fbd06     LIKE fbd_file.fbd06,
                    fbd11     LIKE fbd_file.fbd11,
                    fbd07     LIKE fbd_file.fbd07,
                    fbd12     LIKE fbd_file.fbd12
                    ,fbdud01 LIKE fbd_file.fbdud01,
                    fbdud02 LIKE fbd_file.fbdud02,
                    fbdud03 LIKE fbd_file.fbdud03,
                    fbdud04 LIKE fbd_file.fbdud04,
                    fbdud05 LIKE fbd_file.fbdud05,
                    fbdud06 LIKE fbd_file.fbdud06,
                    fbdud07 LIKE fbd_file.fbdud07,
                    fbdud08 LIKE fbd_file.fbdud08,
                    fbdud09 LIKE fbd_file.fbdud09,
                    fbdud10 LIKE fbd_file.fbdud10,
                    fbdud11 LIKE fbd_file.fbdud11,
                    fbdud12 LIKE fbd_file.fbdud12,
                    fbdud13 LIKE fbd_file.fbdud13,
                    fbdud14 LIKE fbd_file.fbdud14,
                    fbdud15 LIKE fbd_file.fbdud15
                    END RECORD,
    g_fah           RECORD LIKE fah_file.*,
    g_fbc01_t       LIKE fbc_file.fbc01,
    g_e             DYNAMIC ARRAY OF RECORD        #稅簽資料維護
                    fbd14     LIKE fbd_file.fbd14,
                    fbd15     LIKE fbd_file.fbd15,
                    fbd16     LIKE fbd_file.fbd16,
                    fbd17     LIKE fbd_file.fbd17,
                    fbd19     LIKE fbd_file.fbd19,
                    fbd20     LIKE fbd_file.fbd20,
                    fbd21     LIKE fbd_file.fbd21,
                    fbd22     LIKE fbd_file.fbd22
                    END RECORD,
     g_wc,g_wc2,g_sql  STRING,  #No.FUN-580092 HCN
    l_modify_flag      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    g_faj28            LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    g_argv1            LIKE fbc_file.fbc01,   #FUN-580109
    g_argv2             STRING,                # 指定執行功能:query or inser  #TQC-630073
    g_faj141           LIKE faj_file.faj141,
    l_flag             LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    g_t1               LIKE type_file.chr5,     #No.FUN-550034          #No.FUN-680070 VARCHAR(5)
    g_buf              LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
    g_rec_b            LIKE type_file.num5,                #單身筆數       #No.FUN-680070 SMALLINT
    l_ac               LIKE type_file.num5                 #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
DEFINE g_bookno1       LIKE aza_file.aza81         #No.FUN-740033
DEFINE g_bookno2       LIKE aza_file.aza82         #No.FUN-740033
DEFINE g_flag          LIKE type_file.chr1         #No.FUN-740033
DEFINE g_laststage     LIKE type_file.chr1                  #FUN-580109       #No.FUN-680070 VARCHAR(1)
DEFINE p_row,p_col     LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_chr           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE g_chr2          LIKE type_file.chr1      #FUN-580109       #No.FUN-680070 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE g_str           STRING     #No.FUN-670060
DEFINE g_wc_gl         STRING     #No.FUN-670060
DEFINE g_dbs_gl        LIKE type_file.chr21    #No.FUN-670060       #No.FUN-680070 VARCHAR(21)
DEFINE g_row_count     LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_curs_index    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_jump          LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_yy            LIKE type_file.chr4         #No.TQC-7B0060
DEFINE g_mm            LIKE type_file.chr2         #No.TQC-7B0060
#FUN-AB0088---add---str---
DEFINE g_fbd2       DYNAMIC ARRAY OF RECORD    #祘Α跑计(Program Variables)
                    fbd02     LIKE fbd_file.fbd02,
                    fbd03     LIKE fbd_file.fbd03,
                    fbd031    LIKE fbd_file.fbd031,
                    faj06     LIKE faj_file.faj06,
                    fbd042    LIKE fbd_file.fbd042,
                    fbd092    LIKE fbd_file.fbd092,
                    fbd052    LIKE fbd_file.fbd052,
                    fbd102    LIKE fbd_file.fbd102,
                    fbd062    LIKE fbd_file.fbd062,
                    fbd112    LIKE fbd_file.fbd112,
                    fbd072    LIKE fbd_file.fbd072,
                    fbd122    LIKE fbd_file.fbd122
                    END RECORD,
    g_fbd2_t        RECORD
                    fbd02     LIKE fbd_file.fbd02,
                    fbd03     LIKE fbd_file.fbd03,
                    fbd031    LIKE fbd_file.fbd031,
                    faj06     LIKE faj_file.faj06,
                    fbd042    LIKE fbd_file.fbd042,
                    fbd092    LIKE fbd_file.fbd092,
                    fbd052    LIKE fbd_file.fbd052,
                    fbd102    LIKE fbd_file.fbd102,
                    fbd062    LIKE fbd_file.fbd062,
                    fbd112    LIKE fbd_file.fbd112,
                    fbd072    LIKE fbd_file.fbd072,
                    fbd122    LIKE fbd_file.fbd122
                    END RECORD
DEFINE g_faj282     LIKE faj_file.faj282
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
    CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #NO.FUN-6A0069
         RETURNING g_time                                         #NO.FUN-6A0069          
 
    LET g_forupd_sql = " SELECT * FROM fbc_file WHERE fbc01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t107_cl CURSOR FROM g_forupd_sql
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2) #TQC-630073

    #CHI-C60010--add--str--
       SELECT aaa03 INTO g_faj143 FROM aaa_file
        WHERE aaa01 = g_faa.faa02c
       IF NOT cl_null(g_faj143) THEN
          SELECT azi04 INTO g_azi04_1 FROM azi_file
           WHERE azi01 = g_faj143
       END IF
    #CHI-C60010--add—end---
 
    IF g_bgjob='N' OR cl_null(g_bgjob) THEN
 
       LET p_row = 3 LET p_col = 15
       OPEN WINDOW t107_w AT p_row,p_col              #顯示畫面
             WITH FORM "afa/42f/afat107"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
       CALL cl_ui_init()
       #FUN-AB0088---add---str---
       IF g_faa.faa31 = 'Y' THEN  
          CALL cl_set_act_visible("fin_audit2,entry_sheet2",TRUE)
          CALL cl_set_act_visible("gen_entry2,post2,undo_post2",TRUE)  #No:FUN-B60140
          CALL cl_set_act_visible("carry_voucher2,undo_carry_voucher2",TRUE)  #No:FUN-B60140
          CALL cl_set_comp_visible("fbc062,fbc072,fbcpost1",TRUE)  #No:FUN-B60140
       ELSE
          CALL cl_set_act_visible("fin_audit2,entry_sheet2",FALSE)
          CALL cl_set_act_visible("gen_entry2,post2,undo_post2",FALSE)  #No:FUN-B60140
          CALL cl_set_act_visible("carry_voucher2,undo_carry_voucher2",FALSE)  #No:FUN-B60140
          CALL cl_set_comp_visible("fbc062,fbc072,fbcpost1",FALSE)  #No:FUN-B60140
       END IF 
       #FUN-AB0088---add---end---
 
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
               CALL t107_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t107_a()
            END IF
         WHEN "efconfirm"
            CALL t107_q()
            CALL t107_y_chk()          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               LET l_ac = 1
               CALL t107_y_upd()       #CALL 原確認的 update 段
            END IF
            EXIT PROGRAM
         OTHERWISE
            CALL t107_q()
      END CASE
   END IF
 
    #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
    CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void,undo_void,    #FUN-D20035--add--undo_void 
                              confirm, undo_confirm, easyflow_approval, auto_generate, entry_sheet, 
                              gen_entry, post, undo_post, amend_depr_tax, post_depr_tax, undo_post_depr_tax, 
                              carry_voucher, undo_carry_voucher,gen_entry2,post2,undo_post2,carry_voucher2,
                              entry_sheet2,gen_entry2,fin_audit2,carry_voucher2,undo_carry_voucher2,post2,undo_post2, 
                              undo_carry_voucher2") #TQC-740222   #No:FUN-B60140 #FUN-C30140 
    RETURNING g_laststage
 
    CALL t107_menu()
    CLOSE WINDOW t107_w                    #結束畫面
    CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818   #NO.FUN-6A0069
         RETURNING g_time                                         #NO.FUN-6A0069
END MAIN
 
FUNCTION t107_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                             #清除畫面
   CALL g_fbd.clear()
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " fbc01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
   ELSE
      CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_fbc.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
        fbc01,fbc02,fbc03,fbc09,fbc06,fbc07,fbc062,fbc072, #FUN-630045  #No:FUN-B60140
        fbcmksg,fbc08,   #FUN-580109
        fbcconf,fbcpost,fbcpost1,fbcpost2,fbcuser,fbcgrup,fbcmodu,fbcdate   #No:FUN-B60140
        ,fbcud01,fbcud02,fbcud03,fbcud04,fbcud05,
        fbcud06,fbcud07,fbcud08,fbcud09,fbcud10,
        fbcud11,fbcud12,fbcud13,fbcud14,fbcud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION controlp
           CASE
              WHEN INFIELD(fbc01)    #查詢單據性質

                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_fbc"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fbc01
                 NEXT FIELD fbc01
              WHEN INFIELD(fbc03)    #查詢異動原因
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = "9"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fbc03
                 NEXT FIELD fbc03
              WHEN INFIELD(fbc09) #申請人
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fbc09
                 NEXT FIELD fbc09
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
 
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
  
      CONSTRUCT g_wc2 ON fbd02,fbd03,fbd031,faj06,fbd04,faj141,fbd09,fbd05,fbd10,fbd06,   #No.MOD-490181   #MOD-780022
                         fbd11,fbd07,fbd12
                         ,fbdud01,fbdud02,fbdud03,fbdud04,fbdud05,
                         fbdud06,fbdud07,fbdud08,fbdud09,fbdud10,
                         fbdud11,fbdud12,fbdud13,fbdud14,fbdud15
            FROM s_fbd[1].fbd02, s_fbd[1].fbd03, s_fbd[1].fbd031,  #No.MOD-490181
                 s_fbd[1].faj06, s_fbd[1].fbd04, s_fbd[1].faj141, s_fbd[1].fbd09,   #MOD-780022
                 s_fbd[1].fbd05, s_fbd[1].fbd10,
                 s_fbd[1].fbd06, s_fbd[1].fbd11, s_fbd[1].fbd07,s_fbd[1].fbd12
                 ,s_fbd[1].fbdud01,s_fbd[1].fbdud02,s_fbd[1].fbdud03,
                 s_fbd[1].fbdud04,s_fbd[1].fbdud05,s_fbd[1].fbdud06,
                 s_fbd[1].fbdud07,s_fbd[1].fbdud08,s_fbd[1].fbdud09,
                 s_fbd[1].fbdud10,s_fbd[1].fbdud11,s_fbd[1].fbdud12,
                 s_fbd[1].fbdud13,s_fbd[1].fbdud14,s_fbd[1].fbdud15
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION controlp
           CASE
              WHEN INFIELD(fbd03)  #財產編號,財產附號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fbd03
                 NEXT FIELD fbd03
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

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fbcuser', 'fbcgrup')
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT fbc01 FROM fbc_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT fbc01 ",
                   "  FROM fbc_file, fbd_file",
                   " WHERE fbc01 = fbd01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE t107_prepare FROM g_sql
    DECLARE t107_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t107_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM fbc_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT fbc01) FROM fbc_file,fbd_file",
                  " WHERE fbd01 = fbc01 ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED
    END IF
    PREPARE t107_prcount FROM g_sql
    DECLARE t107_count CURSOR WITH HOLD FOR t107_prcount
END FUNCTION
 
FUNCTION t107_menu()
   DEFINE l_creator    LIKE type_file.chr1           #「不准」時是否退回填表人 #FUN-580109       #No.FUN-680070 VARCHAR(1)
   DEFINe l_flowuser   LIKE type_file.chr1           # 是否有指定加簽人員      #FUN-580109       #No.FUN-680070 VARCHAR(1)
 
   LET l_flowuser = "N"   #FUN-580109
 
   WHILE TRUE
      CALL t107_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t107_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t107_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t107_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t107_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t107_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "auto_generate"
            IF cl_chk_act_auth() THEN
              #FUN-C30140---add---str---
              IF NOT cl_null(g_fbc.fbc08) AND g_fbc.fbc08 matches '[Ss]' THEN     
                  CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
              ELSE
              #FUN-C30140---add---end---
                  CALL t107_g()
                  CALL t107_b()
              END IF #FUN-C30140 add
            END IF
         WHEN "entry_sheet"
            IF cl_chk_act_auth() AND not cl_null(g_fbc.fbc01) AND g_fah.fahfa1 = 'Y' THEN #MOD-BC0125 add fahfa1
              #FUN-C30140---add---str---
              IF NOT cl_null(g_fbc.fbc08) AND g_fbc.fbc08 matches '[Ss]' THEN     
                  CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
              ELSE
              #FUN-C30140---add---end---
                  CALL s_fsgl('FA',9,g_fbc.fbc01,0,g_faa.faa02b,1,g_fbc.fbcconf,'0',g_faa.faa02p)     #No.FUN-680028
                  CALL t107_npp02('0')  #No.+087 010503 by plum     #No.FUN-680028
              END IF #FUN-C30140 add
            END IF
         WHEN "entry_sheet2"
            IF cl_chk_act_auth() AND not cl_null(g_fbc.fbc01) AND g_fah.fahfa2 = 'Y' THEN #MOD-BC0125 add fahfa2
              #FUN-C30140---add---str---
              IF NOT cl_null(g_fbc.fbc08) AND g_fbc.fbc08 matches '[Ss]' THEN     
                  CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
              ELSE
              #FUN-C30140---add---end---
                  CALL s_fsgl('FA',9,g_fbc.fbc01,0,g_faa.faa02c,1,g_fbc.fbcconf,'1',g_faa.faa02p)     #No.FUN-680028
                  CALL t107_npp02('1')  #No.+087 010503 by plum     #No.FUN-680028
              END IF #FUN-C30140 add
            END IF
         WHEN "gen_entry"
            IF cl_chk_act_auth() AND g_fbc.fbcconf <> 'X' AND g_fah.fahfa1 = 'Y' THEN #MOD-BC0125 add fahfa1
              #FUN-C30140---add---str---
              IF NOT cl_null(g_fbc.fbc08) AND g_fbc.fbc08 matches '[Ss]' THEN     
                  CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
              ELSE
              #FUN-C30140---add---end---
                  IF g_fbc.fbcconf = 'N' THEN  #MOD-690081
                     LET g_success='Y' #no.5573
                     BEGIN WORK #no.5573
                     CALL s_showmsg_init()    #No.FUN-710028
                     CALL t107_gl(g_fbc.fbc01,g_fbc.fbc02,'0')
                    #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 mark
                    ##-----No:FUN-B60140 Mark-----
                    #IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088  add
                    #   CALL t107_gl(g_fbc.fbc01,g_fbc.fbc02,'1')
                    #END IF
                    ##-----No:FUN-B60140 Mark END-----
                     CALL s_showmsg() #No.FUN-710028
                     IF g_success='Y' THEN
                        COMMIT WORK
                     ELSE
                        ROLLBACK WORK
                     END IF #no.5573
                  ELSE   #MOD-690081
                     CALL cl_err(g_fbc.fbc01,'afa-350',0)   #MOD-690081
                  END IF   #MOD-690081
              END IF #FUN-C30140 add
            END IF
        #-----No:FUN-B60140-----
         WHEN "gen_entry2"
            IF cl_chk_act_auth() AND g_fbc.fbcconf <> 'X' AND g_fah.fahfa2 = 'Y' THEN #MOD-BC0125 add fahfa2
              #FUN-C30140---add---str---
              IF NOT cl_null(g_fbc.fbc08) AND g_fbc.fbc08 matches '[Ss]' THEN     
                  CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
              ELSE
              #FUN-C30140---add---end---
                  IF g_fbc.fbcconf = 'N' THEN
                     LET g_success='Y'
                     BEGIN WORK
                     CALL s_showmsg_init()
                     CALL t107_gl(g_fbc.fbc01,g_fbc.fbc02,'1')
                     CALL s_showmsg()
                     IF g_success='Y' THEN
                        COMMIT WORK
                     ELSE
                        ROLLBACK WORK
                     END IF
                  ELSE
                     CALL cl_err(g_fbc.fbc01,'afa-350',0)
                  END IF
              END IF #FUN-C30140 add
            END IF
         #-----No:FUN-B60140 END----- 
        WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t107_x()           #FUN-D20035
               CALL t107_x(1)           #FUN-D20035
            END IF

         #FUN-D20035---add--str
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t107_x(2)
            END IF
         #FUN-D20035---add---end

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t107_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t107_y_upd()       #CALL 原確認的 update 段
               END IF
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t107_z()
            END IF
         WHEN "carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_fbc.fbcpost = 'Y' THEN     #No.FUN-680028
                  CALL t107_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-557',1)     #No.FUN-680028
               END IF
            END IF
         WHEN "undo_carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_fbc.fbcpost = 'Y' THEN     #No.FUN-680028
                  CALL t107_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-558',1)     #No.FUN-680028
               END IF
            END IF
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t107_s()
            END IF
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t107_w()
            END IF
         #FUN-AB0088---add---str---
         WHEN "fin_audit2"
            IF cl_chk_act_auth() THEN
               CALL t107_fin_audit2()
            END IF 
         #FUN-AB0088---add---end---
         #-----No:FUN-B60140-----
         WHEN "carry_voucher2"
            IF cl_chk_act_auth() THEN
               IF g_fbc.fbcpost1 = 'Y' THEN
                  CALL t107_carry_voucher2()
               ELSE
                  CALL cl_err('','atm-557',1)
               END IF
            END IF
         WHEN "undo_carry_voucher2"
            IF cl_chk_act_auth() THEN
               IF g_fbc.fbcpost1 = 'Y' THEN
                  CALL t107_undo_carry_voucher2()
               ELSE
                  CALL cl_err('','atm-558',1)
               END IF
            END IF
         WHEN "post2"
            IF cl_chk_act_auth() THEN
               CALL t107_s2()
            END IF
         WHEN "undo_post2"
            IF cl_chk_act_auth() THEN
               CALL t107_w2()
            END IF
         #-----No:FUN-B60140 END-----
         WHEN "amend_depr_tax"
            IF cl_chk_act_auth() THEN
               CALL t107_k()
            END IF
         WHEN "post_depr_tax"
            IF cl_chk_act_auth() THEN
               CALL t107_6()
            END IF
         WHEN "undo_post_depr_tax"
            IF cl_chk_act_auth() THEN
               CALL t107_7()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fbc.fbc01 IS NOT NULL THEN
                  LET g_doc.column1 = "fbc01"
                  LET g_doc.value1 = g_fbc.fbc01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fbd),'','')
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
                SELECT * INTO g_fbc.* FROM fbc_file
                 WHERE fbc01 = g_fbc.fbc01
                CALL t107_show()
                CALL t107_b_fill(' 1=1')
               #FUN-C20012 add end---
                CALL t107_ef()
                CALL t107_show()  #FUN-C20012 add
             END IF
        #@WHEN "准"
        WHEN "agree"
             IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
                CALL t107_y_upd()      #CALL 原確認的 update 段
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
                         CALL t107_q()
                         #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                          CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,   #FUN-D20035 add-undo_void
                                                   confirm, undo_confirm, easyflow_approval, auto_generate, entry_sheet,
                                                   gen_entry, post, undo_post, amend_depr_tax, post_depr_tax,
                                                   undo_post_depr_tax, carry_voucher, undo_carry_voucher,gen_entry2,
                                                   entry_sheet2,gen_entry2,fin_audit2,carry_voucher2,undo_carry_voucher2,post2,undo_post2, 
                                                   post2,undo_post2,carry_voucher2,undo_carry_voucher2") #TQC-740222  #No:FUN-B60140 #FUN-C30140 
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
                     LET g_fbc.fbc08 = 'R'
                     DISPLAY BY NAME g_fbc.fbc08
                  END IF
                  IF cl_confirm('aws-081') THEN
                     IF aws_efapp_getnextforminfo() THEN
                        LET l_flowuser = 'N'
                        LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                        IF NOT cl_null(g_argv1) THEN
                           CALL t107_q()
                           #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                           CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,  #FUN-D20035 add-undo_void
                                                      confirm, undo_confirm, easyflow_approval, auto_generate, entry_sheet, 
                                                      gen_entry, post, undo_post, amend_depr_tax, post_depr_tax, undo_post_depr_tax, 
                                                      carry_voucher, undo_carry_voucher,gen_entry2,post2,undo_post2,carry_voucher2,
                                                      entry_sheet2,gen_entry2,fin_audit2,carry_voucher2,undo_carry_voucher2,post2,undo_post2, 
                                                      undo_carry_voucher2") #TQC-740222  No:FUN-B60140 #FUN-C30140 
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
 
FUNCTION t107_a()
DEFINE li_result   LIKE type_file.num5         #No.FUN-680070 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_fbd.clear()
    CALL g_e.clear()
    INITIALIZE g_fbc.* TO NULL
    LET g_fbc01_t = NULL
    LET g_fbc_o.* = g_fbc.*
    LET g_fbc_t.* = g_fbc.*
 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fbc.fbc02  =g_today
        LET g_fbc.fbcconf='N'
        LET g_fbc.fbcpost='N' LET g_fbc.fbcpost2='N'
        LET g_fbc.fbcpost1='N'  #No:FUN-B60140
        LET g_fbc.fbcprsw=0
        LET g_fbc.fbcuser=g_user
        LET g_fbc.fbcoriu = g_user #FUN-980030
        LET g_fbc.fbcorig = g_grup #FUN-980030
        LET g_fbc.fbcgrup=g_grup
        LET g_fbc.fbcdate=g_today
        LET g_fbc.fbcmksg = "N"   #FUN-580109
        LET g_fbc.fbc08 = "0"     #FUN-580109
        LET g_fbc.fbclegal= g_legal       #FUN-980003 add
 
        LET g_fbc.fbc09=g_user                            
        CALL t107_fbc09('d')
        CALL t107_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0
           INITIALIZE g_fbc.* TO NULL
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        IF g_fbc.fbc01 IS NULL THEN       #KEY不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK  #No:7837
        CALL s_auto_assign_no("afa",g_fbc.fbc01,g_fbc.fbc02,"9","fbc_file","fbc01","","","")
             RETURNING li_result,g_fbc.fbc01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_fbc.fbc01

        INSERT INTO fbc_file VALUES (g_fbc.*)
        IF SQLCA.SQLCODE THEN
           CALL cl_err3("ins","fbc_file",g_fbc.fbc01,"",SQLCA.sqlcode,"","Ins:",1)  #No.FUN-660136   #No.FUN-B80054---調整至回滾事務前---
           ROLLBACK WORK  #No:7837
           CONTINUE WHILE
        ELSE
           COMMIT WORK   #No:7837
           CALL cl_flow_notify(g_fbc.fbc01,'I')
        END IF
        COMMIT WORK
        CALL g_fbd.clear()
        LET g_rec_b=0
        LET g_fbc_t.* = g_fbc.*
        LET g_fbc01_t = g_fbc.fbc01
        SELECT fbc01 INTO g_fbc.fbc01
          FROM fbc_file
         WHERE fbc01 = g_fbc.fbc01
 
        CALL t107_g()
        CALL t107_b()
        #---判斷是否直接列印,確認,過帳---------
        LET g_t1 = s_get_doc_no(g_fbc.fbc01)  #No.FUN-550034
        SELECT fahconf,fahpost,fahapr INTO g_fahconf,g_fahpost,g_fahapr
          FROM fah_file
         WHERE fahslip = g_t1
        IF g_fahconf = 'Y' AND g_fahapr <> 'Y' THEN
           LET g_action_choice = "insert"
           CALL t107_y_chk()          #CALL 原確認的 check 段
           IF g_success = "Y" THEN
              CALL t107_y_upd()       #CALL 原確認的 update 段
           END IF
        END IF
        IF g_fahpost = 'Y' THEN
           CALL t107_s()
           CALL t107_s2()  #No:FUN-B60140
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t107_u()
  DEFINE l_tic01      LIKE tic_file.tic01       #FUN-E80012 add
  DEFINE l_tic02      LIKE tic_file.tic02       #FUN-E80012 add
   IF s_shut(0) THEN RETURN END IF
 
    IF g_fbc.fbc01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_fbc.* FROM fbc_file WHERE fbc01 = g_fbc.fbc01
    IF g_fbc.fbcconf = 'X' THEN
       CALL cl_err(' ','9024',0)
       RETURN
    END IF
    IF g_fbc.fbcconf = 'Y' THEN
       CALL cl_err(' ','afa-096',0)
       RETURN
    END IF
    IF g_fbc.fbcpost = 'Y' THEN
       CALL cl_err(' ','afa-101',0)
       RETURN
    END IF
    #-----No:FUN-B60140-----
    IF g_faa.faa31 = "Y" THEN
       IF g_fbc.fbcpost1= 'Y' THEN
          CALL cl_err(' ','afa-101',0)
          RETURN
       END IF
    END IF
    #-----No:FUN-B60140 END-----
    IF g_fbc.fbc08 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fbc01_t = g_fbc.fbc01
    LET g_fbc_o.* = g_fbc.*
    BEGIN WORK
 
    OPEN t107_cl USING g_fbc.fbc01
    IF STATUS THEN
       CALL cl_err("OPEN t107_cl:", STATUS, 1)
       CLOSE t107_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t107_cl INTO g_fbc.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbc.fbc01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t107_cl ROLLBACK WORK RETURN
    END IF
    CALL t107_show()
    WHILE TRUE
        LET g_fbc01_t = g_fbc.fbc01
        LET g_fbc.fbcmodu=g_user
        LET g_fbc.fbcdate=g_today
        CALL t107_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fbc.*=g_fbc_t.*
            CALL t107_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        LET g_fbc.fbc08 = '0'   #FUN-580109
        IF g_fbc.fbc01 != g_fbc_t.fbc01 THEN
           UPDATE fbd_file SET fbd01=g_fbc.fbc01 WHERE fbd01=g_fbc_t.fbc01
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("upd","fbd_file",g_fbc_t.fbc01,"",SQLCA.sqlcode,"","upd fbd01",1)  #No.FUN-660136
              LET g_fbc.*=g_fbc_t.*
              CALL t107_show()
              CONTINUE WHILE
           END IF
        END IF
        UPDATE fbc_file SET * = g_fbc.*
         WHERE fbc01 = g_fbc.fbc01
        IF SQLCA.SQLERRD[3] = 0 OR SQLCA.SQLCODE THEN
           CALL cl_err3("upd","fbc_file",g_fbc_t.fbc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
           CONTINUE WHILE
        END IF
        IF g_fbc.fbc02 != g_fbc_t.fbc02 THEN            # 更改單號
           UPDATE npp_file SET npp02=g_fbc.fbc02
            WHERE npp01=g_fbc.fbc01 AND npp00=9 AND npp011=1
              AND nppsys = 'FA'
           IF STATUS THEN 
              CALL cl_err3("upd","npp_file",g_fbc.fbc01,"",SQLCA.sqlcode,"","upd npp02:",1)  #No.FUN-660136
           END IF
           #FUN-E80012---add---str---
           SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
           IF g_nmz.nmz70 = '3' THEN
              LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_fbc.fbc02,1)
              LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_fbc.fbc02,3)
              UPDATE tic_file SET tic01=l_tic01,
                                  tic02=l_tic02
              WHERE tic04=g_fbc.fbc01
              IF STATUS THEN
                 CALL cl_err3("upd","tic_file",g_fbc.fbc01,"",STATUS,"","upd tic01,tic02:",1)
              END IF
           END IF
           #FUN-E80012---add---end---
        END IF
        DISPLAY BY NAME g_fbc.fbc08
        IF g_fbc.fbcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_fbc.fbc08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        CALL cl_set_field_pic(g_fbc.fbcconf,g_chr2,g_fbc.fbcpost,"",g_chr,"")
        EXIT WHILE
    END WHILE
    CLOSE t107_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fbc.fbc01,'U')
END FUNCTION
 
FUNCTION t107_npp02(p_npptype)     #No.FUN-680028
  DEFINE p_npptype    LIKE npp_file.npptype     #No.FUN-680028
  DEFINE l_tic01      LIKE tic_file.tic01       #FUN-E80012 add
  DEFINE l_tic02      LIKE tic_file.tic02       #FUN-E80012 add
 
  #-----No:FUN-B60140-----
  IF p_npptype='0' THEN
  IF g_fbc.fbc06 IS NULL OR g_fbc.fbc06=' ' THEN
     UPDATE npp_file SET npp02=g_fbc.fbc02
        WHERE npp01=g_fbc.fbc01 AND npp00=9 AND npp011=1
        AND nppsys = 'FA'
        AND npptype = p_npptype     #No.FUN-680028
     #FUN-E80012---add---str---
     SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
     IF g_nmz.nmz70 = '3' THEN
        LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_fbc.fbc02,1)
        LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_fbc.fbc02,3)
        UPDATE tic_file SET tic01=l_tic01,
                            tic02=l_tic02
        WHERE tic04=g_fbc.fbc01
        IF STATUS THEN
           CALL cl_err3("upd","tic_file",g_fbc.fbc01,"",STATUS,"","upd tic01,tic02:",1)
        END IF
     END IF
     #FUN-E80012---add---end---
   ELSE
      IF g_fbc.fbc062 IS NULL OR g_fbc.fbc062=' ' THEN
         UPDATE npp_file SET npp02=g_fbc.fbc02
            WHERE npp01=g_fbc.fbc01 AND npp00=9 AND npp011=1
            AND nppsys = 'FA'
            AND npptype = p_npptype
         IF STATUS THEN
            CALL cl_err3("upd","npp_file",g_fbc.fbc01,"",SQLCA.sqlcode,"","upd npp02:",1)
         END IF
         #FUN-E80012---add---str---
         SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
         IF g_nmz.nmz70 = '3' THEN
            LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_fbc.fbc02,1)
            LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_fbc.fbc02,3)
            UPDATE tic_file SET tic01=l_tic01,
                                tic02=l_tic02
            WHERE tic04=g_fbc.fbc01
            IF STATUS THEN
               CALL cl_err3("upd","tic_file",g_fbc.fbc01,"",STATUS,"","upd tic01,tic02:",1)
            END IF
         END IF
         #FUN-E80012---add---end---
      END IF
   END IF
   #-----No:FUN-B60140 END-----
     IF STATUS THEN 
        CALL cl_err3("upd","npp_file",g_fbc.fbc01,"",SQLCA.sqlcode,"","upd npp02:",1)  #No.FUN-660136
     END IF
  END IF
END FUNCTION
 
#處理INPUT
FUNCTION t107_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
         l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
         l_bdate,l_edate LIKE type_file.dat,     #No.FUN-680070 DATE
         l_n1            LIKE type_file.num5     #No.FUN-680070 SMALLINT
  DEFINE li_result   LIKE type_file.num5         #No.FUN-680070 SMALLINT
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0029 
 
    INPUT BY NAME g_fbc.fbcoriu,g_fbc.fbcorig,
        g_fbc.fbc01,g_fbc.fbc02,g_fbc.fbc03,g_fbc.fbc09,g_fbc.fbc06,g_fbc.fbc07,#FUN-630045
        g_fbc.fbc062,g_fbc.fbc072,  #No:FUN-B60140
        g_fbc.fbcconf,g_fbc.fbcpost,g_fbc.fbcpost1,g_fbc.fbcpost2,                #kitty  #No:FUN-B60140
        g_fbc.fbcmksg,g_fbc.fbc08,   #FUN-580109
        g_fbc.fbcuser,g_fbc.fbcgrup,g_fbc.fbcmodu,g_fbc.fbcdate
        ,g_fbc.fbcud01,g_fbc.fbcud02,g_fbc.fbcud03,g_fbc.fbcud04,
        g_fbc.fbcud05,g_fbc.fbcud06,g_fbc.fbcud07,g_fbc.fbcud08,
        g_fbc.fbcud09,g_fbc.fbcud10,g_fbc.fbcud11,g_fbc.fbcud12,
        g_fbc.fbcud13,g_fbc.fbcud14,g_fbc.fbcud15 
         WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t107_set_entry(p_cmd)
            CALL t107_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         CALL cl_set_docno_format("fbc01")
         CALL cl_set_docno_format("fbc06")
         CALL cl_set_docno_format("fbc062")  #No:FUN-B60140         
 
        AFTER FIELD fbc01
            IF NOT cl_null(g_fbc.fbc01) AND (cl_null(g_fbc01_t) OR g_fbc.fbc01!=g_fbc01_t) THEN #MOD-740373
               CALL s_check_no("afa",g_fbc.fbc01,g_fbc01_t,"9","fbc_file","fbc01","")
                    RETURNING li_result,g_fbc.fbc01
               DISPLAY BY NAME g_fbc.fbc01
               IF (NOT li_result) THEN
                  LET g_fbc.fbc01 = g_fbc_o.fbc01
                  NEXT FIELD fbc01
               END IF

               LET g_t1 = s_get_doc_no(g_fbc.fbc01)  #No.FUN-550034
               SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1

            END IF
            SELECT fahapr,'0' INTO g_fbc.fbcmksg,g_fbc.fbc08
              FROM fah_file
             WHERE fahslip = g_t1
            IF cl_null(g_fbc.fbcmksg) THEN            #FUN-640243
                 LET g_fbc.fbcmksg = 'N'
            END IF
            DISPLAY BY NAME g_fbc.fbcmksg,g_fbc.fbc08
            LET g_fbc_o.fbc01 = g_fbc.fbc01
 
        AFTER FIELD fbc02
            IF NOT cl_null(g_fbc.fbc02) THEN
               CALL s_yp(g_fbc.fbc02) RETURNING g_yy,g_mm   #MOD-8B0221 add
               CALL s_azn01(g_faa.faa07,g_faa.faa08) RETURNING l_bdate,l_edate
               IF g_fbc.fbc02 < l_bdate
               THEN CALL cl_err(g_fbc.fbc02,'afa-130',0)
                    NEXT FIELD fbc02
               END IF
               IF g_fbc.fbc02 <= g_faa.faa09 THEN
                  CALL cl_err('','mfg9999',1)
                  NEXT FIELD fbc02
               END IF
               CALL s_get_bookno(g_yy)              #No.TQC-7B0060
                    RETURNING g_flag,g_bookno1,g_bookno2
               #FUN-AB0088---add---str---
               #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
               #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
               IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
               #FUN-AB0088---add---end--- 
               IF g_flag =  '1' THEN  #抓不到帳別
                  CALL cl_err(g_fbc.fbc02,'aoo-081',1)
                  NEXT FIELD fbc02
               END IF
            END IF
 
        AFTER FIELD fbc03
            IF NOT cl_null(g_fbc.fbc03) THEN
               CALL t107_fbc03('a')
                 IF NOT cl_null(g_errno) THEN
                    LET g_fbc.fbc03 = g_fbc_t.fbc03
                    CALL cl_err(g_fbc.fbc03,g_errno,0)
                    DISPLAY BY NAME g_fbc.fbc03 #
                    NEXT FIELD fbc03
                 END IF
            END IF
        AFTER FIELD fbc09
            IF NOT cl_null(g_fbc.fbc09) THEN
               CALL t107_fbc09('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_fbc.fbc09 = g_fbc_t.fbc09
                  CALL cl_err(g_fbc.fbc09,g_errno,0)
                  DISPLAY BY NAME g_fbc.fbc09 #
                  NEXT FIELD fbc09
               END IF
            ELSE
               DISPLAY '' TO FORMONLY.gen02
            END IF
        AFTER FIELD fbcud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbcud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbcud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbcud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbcud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbcud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbcud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbcud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbcud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbcud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbcud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbcud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbcud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbcud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbcud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER INPUT   #97/05/22 modify
            LET g_fbc.fbcuser = s_get_data_owner("fbc_file") #FUN-C10039
            LET g_fbc.fbcgrup = s_get_data_group("fbc_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
         ON ACTION controlp
           CASE
              WHEN INFIELD(fbc01)    #查詢單據性質
                 LET g_t1 = s_get_doc_no(g_fbc.fbc01)  #No.FUN-550034
                 CALL q_fah( FALSE, TRUE,g_t1,'9','AFA') RETURNING g_t1  #TQC-670008
                 LET g_fbc.fbc01 = g_t1  #No.FUN-550034
                 DISPLAY BY NAME g_fbc.fbc01
                 NEXT FIELD fbc01
              WHEN INFIELD(fbc03)    #查詢異動原因
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fag"
                 LET g_qryparam.arg1 = "9"
                 LET g_qryparam.default1 = g_fbc.fbc03
                 CALL cl_create_qry() RETURNING g_fbc.fbc03
                 DISPLAY BY NAME g_fbc.fbc03
                 NEXT FIELD fbc03
              WHEN INFIELD(fbc09)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.default1 = g_fbc.fbc09
                   CALL cl_create_qry() RETURNING g_fbc.fbc09
                   DISPLAY BY NAME g_fbc.fbc09
                   NEXT FIELD fbc09
              OTHERWISE EXIT CASE
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
 
FUNCTION t107_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fbc01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t107_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fbc01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t107_fbc03(p_cmd)
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_fag03    LIKE fag_file.fag03,
      l_fagacti  LIKE fag_file.fagacti
 
    LET g_errno = ' '
    SELECT fag03,fagacti INTO l_fag03,l_fagacti
      FROM fag_file
     WHERE fag01 = g_fbc.fbc03 AND fag02 = '9'
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-099'
                                LET l_fag03 = NULL
                                LET l_fagacti = NULL
       WHEN l_fagacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_fag03 TO FORMONLY.fag03 #
    END IF
END FUNCTION
 
FUNCTION t107_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fbc.* TO NULL                   #No.FUN-6A0001
    CALL cl_msg("")                              #FUN-640243
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t107_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_fbc.* TO NULL
       RETURN
    END IF
    CALL cl_msg(" SEARCHING ! ")                 #FUN-640243
 
    OPEN t107_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fbc.* TO NULL
    ELSE
        OPEN t107_count
        FETCH t107_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t107_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    CALL cl_msg("")                              #FUN-640243
END FUNCTION
 
FUNCTION t107_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t107_cs INTO g_fbc.fbc01
        WHEN 'P' FETCH PREVIOUS t107_cs INTO g_fbc.fbc01
        WHEN 'F' FETCH FIRST    t107_cs INTO g_fbc.fbc01
        WHEN 'L' FETCH LAST     t107_cs INTO g_fbc.fbc01
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
            FETCH ABSOLUTE g_jump t107_cs INTO g_fbc.fbc01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbc.fbc01,SQLCA.sqlcode,0)
        INITIALIZE g_fbc.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_fbc.* FROM fbc_file WHERE fbc01 = g_fbc.fbc01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","fbc_file",g_fbc.fbc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
        INITIALIZE g_fbc.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_fbc.fbcuser   #FUN-4C0059
    LET g_data_group = g_fbc.fbcgrup   #FUN-4C0059
    CALL s_get_bookno(g_yy)                          #No.TQC-7B0060
         RETURNING g_flag,g_bookno1,g_bookno2
    #FUN-AB0088---add---str---
    #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
    #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
    IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
    #FUN-AB0088---add---end--- 
    IF g_flag =  '1' THEN  #抓不到帳別
       CALL cl_err(g_fbc.fbc02,'aoo-081',1)
    END IF
    CALL t107_show()
END FUNCTION
 
FUNCTION t107_show()
    LET g_fbc_t.* = g_fbc.*                #保存單頭舊值
    DISPLAY BY NAME g_fbc.fbcoriu,g_fbc.fbcorig,
        g_fbc.fbc01,g_fbc.fbc02,g_fbc.fbc03,g_fbc.fbc09,g_fbc.fbc06,g_fbc.fbc07,#FUN-630045
        g_fbc.fbc062,g_fbc.fbc072,g_fbc.fbcpost1,  #No:FUN-B60140
        g_fbc.fbcconf,g_fbc.fbcpost,g_fbc.fbcpost2,
        g_fbc.fbcmksg,g_fbc.fbc08,   #FUN-580109 增加簽核,狀況碼
        g_fbc.fbcuser,g_fbc.fbcgrup,g_fbc.fbcmodu,g_fbc.fbcdate
        ,g_fbc.fbcud01,g_fbc.fbcud02,g_fbc.fbcud03,g_fbc.fbcud04,
        g_fbc.fbcud05,g_fbc.fbcud06,g_fbc.fbcud07,g_fbc.fbcud08,
        g_fbc.fbcud09,g_fbc.fbcud10,g_fbc.fbcud11,g_fbc.fbcud12,
        g_fbc.fbcud13,g_fbc.fbcud14,g_fbc.fbcud15 
    IF g_fbc.fbcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_fbc.fbc08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_fbc.fbcconf,g_chr2,g_fbc.fbcpost,"",g_chr,"")
    LET g_t1 = s_get_doc_no(g_fbc.fbc01)  #No.FUN-550034
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
    CALL t107_fbc03('d')
    CALL t107_fbc09('d')                      #FUN-630045  
    CALL t107_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
    CALL s_yp(g_fbc.fbc02) RETURNING g_yy,g_mm   #No.TQC-7B0060
END FUNCTION
 
FUNCTION t107_r()
 DEFINE l_chr,l_sure LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fbc.fbc01 IS NULL THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    SELECT * INTO g_fbc.* FROM fbc_file WHERE fbc01 = g_fbc.fbc01
    #-->已拋轉票不可刪除
    IF not cl_null(g_fbc.fbc06) THEN
       CALL cl_err('','afa-311',0) RETURN
    END IF
    IF g_fbc.fbcconf = 'X' THEN
       CALL cl_err(' ','9024',0)
       RETURN
    END IF
    IF g_fbc.fbcconf = 'Y' THEN
       CALL cl_err('','afa-096',0) RETURN
    END IF
    IF g_fbc.fbcpost = 'Y' THEN
       CALL cl_err(' ','afa-101',0) RETURN
    END IF
    
    #-----No:FUN-B60140-----
    IF g_faa.faa31 = "Y" THEN
       #-->已拋轉票不可刪除
       IF NOT cl_null(g_fbc.fbc062) THEN
          CALL cl_err('','afa-311',0)
          RETURN
       END IF
       IF g_fbc.fbcpost = 'Y' THEN
          CALL cl_err(' ','afa-101',0)
          RETURN
       END IF
    END IF
    #-----No:FUN-B60140 END-----
    IF g_fbc.fbc08 matches '[Ss1]' THEN
       CALL cl_err('','mfg3557',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN t107_cl USING g_fbc.fbc01
    IF STATUS THEN
       CALL cl_err("OPEN t107_cl:", STATUS, 1)
       CLOSE t107_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t107_cl INTO g_fbc.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fbc.fbc01,SQLCA.sqlcode,0)
       CLOSE t107_cl ROLLBACK WORK  RETURN
    END IF
    CALL t107_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fbc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fbc.fbc01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete fbc,fbd!"
        DELETE FROM fbc_file WHERE fbc01 = g_fbc.fbc01
        IF SQLCA.SQLERRD[3]=0 THEN
             CALL cl_err3("del","fbc_file",g_fbc.fbc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
           ELSE CLEAR FORM
   CALL g_fbd.clear()
   CALL g_e.clear()
        END IF
        DELETE FROM fbd_file WHERE fbd01 = g_fbc.fbc01
        DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 9
                               AND npp01 = g_fbc.fbc01
                               AND npp011= 1
        DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 9
                               AND npq01 = g_fbc.fbc01
                               AND npq011= 1
        #FUN-B40056--add--str--
        DELETE FROM tic_file WHERE tic04 = g_fbc.fbc01
        #FUN-B40056--add--end--
        CALL g_fbd.clear()
        OPEN t107_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE t107_cl
           CLOSE t107_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end-- 
        FETCH t107_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t107_cl
           CLOSE t107_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t107_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t107_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t107_fetch('/')
        END IF
 
    END IF
    CLOSE t107_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fbc.fbc01,'D')
END FUNCTION
 
FUNCTION t107_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
       l_row,l_col     LIKE type_file.num5,  		   #分段輸入之行,列數       #No.FUN-680070 SMALLINT
       l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
       l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
       l_faj06         LIKE faj_file.faj06,
       l_faj100        LIKE faj_file.faj100,
       l_fbd12         LIKE fbd_file.fbd12,      #No.MOD-490181
       l_fab23         LIKE fab_file.fab23,    #殘值率 NO.A032
       l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
       l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
DEFINE l_fbc08         LIKE fbc_file.fbc08    #FUN-580109
#FUN-BB0122--being add
   DEFINE l_faj142   LIKE faj_file.faj142
   DEFINE l_faj322   LIKE faj_file.faj322
   DEFINE l_faj302   LIKE faj_file.faj302
   DEFINE l_faj312   LIKE faj_file.faj312
#FUN-BB0122--end add 
   DEFINE l_faj29      LIKE faj_file.faj29     #FUN-C90088
   DEFINE l_faj292     LIKE faj_file.faj292    #FUN-C90088

    LET g_action_choice = ""
    LET l_fbc08 = g_fbc.fbc08   #FUN-580109
    IF g_fbc.fbc01 IS NULL THEN RETURN END IF
    IF g_fbc.fbcconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fbc.fbcpost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
    IF g_fbc.fbcconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
    
    #-----No:FUN-B60140-----
    IF g_faa.faa31 = "Y" THEN
       IF g_fbc.fbcpost1 = 'Y' THEN
          CALL cl_err('','afa-101',0)
          RETURN
       END IF
    END IF
    #-----No:FUN-B60140 END-----

    IF g_fbc.fbc08 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT fbd02,fbd03,fbd031,'',fbd04,'',fbd09,fbd05,fbd10,fbd06, ",   #MOD-780022
                       " fbd11,fbd07,fbd12 " ,
                       " FROM fbd_file ",
                       " WHERE fbd01 = ? ",
                       " AND fbd02   = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t107_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
      LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_fbd.clear() END IF
 
 
      INPUT ARRAY g_fbd WITHOUT DEFAULTS FROM s_fbd.*
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
 
            OPEN t107_cl USING g_fbc.fbc01
            IF STATUS THEN
               CALL cl_err("OPEN t107_cl:", STATUS, 1)
               CLOSE t107_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t107_cl INTO g_fbc.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fbc.fbc01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t107_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_fbd_t.* = g_fbd[l_ac].*  #BACKUP
                LET l_flag = 'Y'
 
                OPEN t107_bcl USING g_fbc.fbc01,g_fbd_t.fbd02
                IF STATUS THEN
                   CALL cl_err("OPEN t107_bcl:", STATUS, 1)
                   CLOSE t107_bcl
                   LET l_lock_sw = "Y"
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t107_bcl INTO g_fbd[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock fbd',SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                SELECT faj06,faj141 INTO g_fbd[l_ac].faj06,g_fbd[l_ac].faj141   #MOD-780022
                  FROM faj_file
                 WHERE faj02=g_fbd[l_ac].fbd03
                   AND faj022=g_fbd[l_ac].fbd031
                 LET g_fbd_t.faj06 =g_fbd[l_ac].faj06
                 LET g_fbd_t.faj141 =g_fbd[l_ac].faj141   #MOD-780022
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            ELSE
                LET l_flag = 'N'
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
           IF cl_null(g_fbd[l_ac].fbd031) THEN
              LET g_fbd[l_ac].fbd031 = ' '
           END IF
           #FUN-BB0122---being add
                     SELECT faj142,faj322,faj302,faj312
                       INTO l_faj142,l_faj322,l_faj302,l_faj312
                       FROM faj_file
                      WHERE faj02  = g_fbd[l_ac].fbd03
                        AND faj022 = g_fbd[l_ac].fbd031
                     IF cl_null(l_faj142) THEN LET l_faj142 = 0 END IF
                     IF cl_null(l_faj322) THEN LET l_faj322 = 0 END IF
                     IF cl_null(l_faj302) THEN LET l_faj302 = 0 END IF
                     IF cl_null(l_faj312) THEN LET l_faj312 = 0 END IF                    
           #FUN-BB0122---end add
         #CHI-C60010---str---
           CALL cl_digcut(l_faj142,g_azi04_1) RETURNING l_faj142
           CALL cl_digcut(l_faj322,g_azi04_1) RETURNING l_faj322
           CALL cl_digcut(l_faj312,g_azi04_1) RETURNING l_faj312
          #CHI-C60010---end---
             INSERT INTO fbd_file(fbd01,fbd02,fbd03,fbd031,fbd04, #No.MOD-470041
                                  fbd05,fbd06,fbd07,fbd08,fbd09,  #No.MOD-470565
                                 fbd10,fbd11,fbd12,fbd13,fbd14,
                                 fbd15,fbd16,fbd17,fbd18,fbd19,
                                 fbd20,fbd21,fbd22,fbd23,fbd24
                                 ,fbdud01,fbdud02,fbdud03,fbdud04,fbdud05,
                                 fbdud06,fbdud07,fbdud08,fbdud09,fbdud10,
                                 fbdud11,fbdud12,fbdud13,fbdud14,fbdud15,
                                 fbd042,fbd052,fbd062,fbd072,fbd092,fbd102,fbd112,fbd122,  #FUN-AB0088
                                 fbdlegal) #FUN-980003 add
             VALUES(g_fbc.fbc01,g_fbd[l_ac].fbd02,g_fbd[l_ac].fbd03,
                   g_fbd[l_ac].fbd031,g_fbd[l_ac].fbd04,g_fbd[l_ac].fbd05,
                   g_fbd[l_ac].fbd06,g_fbd[l_ac].fbd07,0,   #No.MOD-470565
                   g_fbd[l_ac].fbd09,g_fbd[l_ac].fbd10,
                   g_fbd[l_ac].fbd11,g_fbd[l_ac].fbd12,0,
                   g_e[l_ac].fbd14,g_e[l_ac].fbd15,
                   g_e[l_ac].fbd16,g_e[l_ac].fbd17,0,
                   g_e[l_ac].fbd19,g_e[l_ac].fbd20,
                   g_e[l_ac].fbd21,g_e[l_ac].fbd22,0,
                   g_fbc.fbc03
                   ,g_fbd[l_ac].fbdud01,g_fbd[l_ac].fbdud02,g_fbd[l_ac].fbdud03,
                   g_fbd[l_ac].fbdud04,g_fbd[l_ac].fbdud05,g_fbd[l_ac].fbdud06,
                   g_fbd[l_ac].fbdud07,g_fbd[l_ac].fbdud08,g_fbd[l_ac].fbdud09,
                   g_fbd[l_ac].fbdud10,g_fbd[l_ac].fbdud11,g_fbd[l_ac].fbdud12,
                   g_fbd[l_ac].fbdud13,g_fbd[l_ac].fbdud14,g_fbd[l_ac].fbdud15,
                   #0,0,0,0,0,0,0,0,    #FUN-AB0088 #FUN-BB0122 mark
                   #g_legal, #FUN-980003 add #FUN-BC0004 mark
		   l_faj142,l_faj322,l_faj302,l_faj312,l_faj142,l_faj322,l_faj302,l_faj312,g_legal)     #FUN-BB0122 add#FUN-BC0004 add g_legal
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0  THEN
                 CALL cl_err3("ins","fbd_file",g_fbc.fbc01,g_fbd[l_ac].fbd02,SQLCA.sqlcode,"","ins fbd",1)  #No.FUN-660136
                 CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET l_fbc08 = '0'   #FUN-580109
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd = 'a'
            INITIALIZE g_fbd[l_ac].* TO NULL      #900423
            SELECT faj06,faj141 INTO g_fbd[l_ac].faj06,g_fbd[l_ac].faj141   #MOD-780022
              FROM faj_file
             WHERE faj02=g_fbd[l_ac].fbd03
                AND faj022=g_fbd[l_ac].fbd031          #No.MOD-490181
            LET g_fbd_t.* = g_fbd[l_ac].*             #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fbd02
 
        BEFORE FIELD fbd02                            #defbclt 序號
            IF p_cmd = 'a' OR p_cmd = 'u' THEN
               IF g_fbd[l_ac].fbd02 IS NULL OR g_fbd[l_ac].fbd02 = 0 THEN
                   SELECT max(fbd02)+1 INTO g_fbd[l_ac].fbd02
                      FROM fbd_file WHERE fbd01 = g_fbc.fbc01
                   IF g_fbd[l_ac].fbd02 IS NULL THEN
                       LET g_fbd[l_ac].fbd02 = 1
                   END IF
               END IF
            END IF
 
        AFTER FIELD fbd02                        #check 序號是否重複
            IF NOT cl_null(g_fbd[l_ac].fbd02) THEN
               IF g_fbd[l_ac].fbd02 != g_fbd_t.fbd02 OR
                  g_fbd_t.fbd02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM fbd_file
                    WHERE fbd01 = g_fbc.fbc01
                      AND fbd02 = g_fbd[l_ac].fbd02
                   IF l_n > 0 THEN
                       LET g_fbd[l_ac].fbd02 = g_fbd_t.fbd02
                       CALL cl_err('',-239,0)
                       NEXT FIELD fbd02
                   END IF
               END IF
            END IF

       #FUN-BC0004--mark--str
       ##TQC-AB0257 modify ---begin----------------------------
       #AFTER FIELD fbd03
       #    IF g_fbd[l_ac].fbd03 != g_fbd_t.fbd03 OR
       #       g_fbd_t.fbd03 IS NULL THEN
       #        LET l_n = 0
       #        SELECT COUNT(*) INTO l_n FROM faj_file
       #         WHERE fajconf='Y'
       #           AND faj02 = g_fbd[l_ac].fbd03
       #        IF l_n = 0 THEN
       #            LET g_fbd[l_ac].fbd03 = g_fbd_t.fbd03
       #            CALL cl_err('','afa-911',0)
       #            NEXT FIELD fbd03
       #        END IF
       #    END IF
       ##TQC-AB0257 modify ----end-----------------------------
       #FUN-BC0004--mark--end
 
        #FUN-BC0004--add--str
        AFTER FIELD fbd03
           IF g_fbd[l_ac].fbd031 IS NULL THEN
              LET g_fbd[l_ac].fbd031 = ' '
           END IF
           IF NOT cl_null(g_fbd[l_ac].fbd03) AND g_fbd[l_ac].fbd031 IS NOT NULL THEN 
              IF p_cmd = 'a' OR
                (p_cmd = 'u' AND (g_fbd[l_ac].fbd03 != g_fbd_t.fbd03 OR
                                  g_fbd[l_ac].fbd031 != g_fbd_t.fbd031 )) THEN
                 CALL t107_fbd031(p_cmd)
                 SELECT COUNT(*) INTO l_n FROM faj_file
                  WHERE faj02 = g_fbd[l_ac].fbd03
                #IF g_cnt > 0 THEN      #No.TQC-C30074   Mark
                 IF l_n > 0 THEN        #No.TQC-C30074   Add
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_fbd[l_ac].fbd03,g_errno,0)
                        NEXT FIELD fbd03
                     ELSE
                        SELECT COUNT(*) INTO g_cnt FROM fbd_file
                         WHERE fbd01  = g_fbc.fbc01
                           AND fbd03  = g_fbd[l_ac].fbd03
                           AND fbd031 = g_fbd[l_ac].fbd031
                           AND fbd02 != g_fbd[l_ac].fbd02
                        IF g_cnt > 0 THEN
                            CALL cl_err('',-239,0)
                            NEXT FIELD fbd031
                        END IF 
                        IF g_faa.faa31 ='Y' THEN
                           IF g_aza.aza26 <> '2' THEN
                              SELECT COUNT(*) INTO l_cnt FROM fbn_file
                               WHERE fbn01 = g_fbd[l_ac].fbd03
                                 AND fbn02 = g_fbd[l_ac].fbd031
                                 AND (fbn03 = g_yy AND fbn04 >= g_mm OR fbn03 > g_yy)
                                 AND fbn041 = '1'   #MOD-BC0025 add
                              IF l_cnt > 0 THEN
                                 CALL cl_err(g_fbd[l_ac].fbd03,'afa-092',0)
                                 NEXT FIELD fbd03
                              END IF
                           ELSE
                              SELECT COUNT(*) INTO l_cnt FROM fbn_file
                               WHERE fbn01 = g_fbd[l_ac].fbd03
                                 AND fbn02 = g_fbd[l_ac].fbd031
                                 AND (fbn03 = g_yy AND fbn04 > g_mm OR fbn03 > g_yy)
                                 AND fbn041 = '1'   #MOD-BC0025 add
                              IF l_cnt > 0 THEN
                                 CALL cl_err(g_fbd[l_ac].fbd03,'afa-092',0)
                                 NEXT FIELD fbd03
                              END IF
                           END IF
                        END IF
                     END IF
                 ELSE
                    CALL cl_err(g_fbd[l_ac].fbd03,'afa-093',0)
                    LET g_fbd[l_ac].fbd03 = g_fbd_t.fbd03
                    NEXT FIELD fbd03
                END IF
              END IF
            END IF 
            DISPLAY BY NAME g_fbd[l_ac].fbd03  
        #FUN-BC0004--add-end 
        AFTER FIELD fbd031
           IF g_fbd[l_ac].fbd031 IS NULL THEN
              LET g_fbd[l_ac].fbd031 = ' '
           END IF

           SELECT COUNT(*) INTO g_cnt FROM fbd_file
            WHERE fbd01  = g_fbc.fbc01
              AND fbd03  = g_fbd[l_ac].fbd03
              AND fbd031 = g_fbd[l_ac].fbd031
              AND fbd02 != g_fbd[l_ac].fbd02
           IF g_cnt > 0 THEN
               CALL cl_err('',-239,0)
               NEXT FIELD fbd03
           END IF
          #MOD-D10283--str
           IF p_cmd = 'a' OR
             (p_cmd = 'u' AND (g_fbd[l_ac].fbd03 != g_fbd_t.fbd03 OR
                               g_fbd[l_ac].fbd031 != g_fbd_t.fbd031 )) THEN
          #MOD-D10283--end
              CALL t107_fbd031(p_cmd)
           END IF   #MOD-D10283
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_fbd[l_ac].fbd031,g_errno,1)
               LET g_fbd[l_ac].fbd03 = g_fbd_t.fbd03          #MOD-950166
               LET g_fbd[l_ac].fbd031 = g_fbd_t.fbd031        #MOD-950166               
               NEXT FIELD fbd03
            END IF
         SELECT faj06,faj141 INTO g_fbd[l_ac].faj06,g_fbd[l_ac].faj141 FROM faj_file   #MOD-780022
          WHERE   faj02 = g_fbd[l_ac].fbd03 AND
                (faj022 = g_fbd[l_ac].fbd031 OR faj022 IS NULL)
         DISPLAY BY NAME g_fbd[l_ac].faj06
         DISPLAY BY NAME g_fbd[l_ac].faj141   #MOD-780022

         SELECT COUNT(*) INTO l_cnt FROM fca_file
          WHERE fca03  = g_fbd[l_ac].fbd03
            AND fca031 = g_fbd[l_ac].fbd031
            AND fca15  = 'N'
         IF l_cnt > 0 THEN
            CALL cl_err(g_fbd[l_ac].fbd03,'afa-097',0)
            LET g_fbd[l_ac].fbd03 =g_fbd_t.fbd03    #MOD-A10130 add
            LET g_fbd[l_ac].fbd031=g_fbd_t.fbd031   #MOD-A10130 add
            NEXT FIELD fbd03
         END IF
         #No.MOD-AC0055  --Begin
         IF g_aza.aza26 <> '2' THEN
            #-----TQC-780089---------
            SELECT COUNT(*) INTO l_cnt FROM fan_file
             WHERE fan01 = g_fbd[l_ac].fbd03
               AND fan02 = g_fbd[l_ac].fbd031
               AND (fan03 = g_yy AND fan04 >= g_mm OR fan03 > g_yy)
               AND fan041 = '1'   #MOD-BC0025 add
            IF l_cnt > 0 THEN
               CALL cl_err(g_fbd[l_ac].fbd03,'afa-092',0)
               NEXT FIELD fbd03
            END IF
            #-----END TQC-780089-----
         ELSE
            SELECT COUNT(*) INTO l_cnt FROM fan_file
             WHERE fan01 = g_fbd[l_ac].fbd03
               AND fan02 = g_fbd[l_ac].fbd031
               AND (fan03 = g_yy AND fan04 > g_mm OR fan03 > g_yy)
               AND fan041 = '1'   #MOD-BC0025 add
            IF l_cnt > 0 THEN
               CALL cl_err(g_fbd[l_ac].fbd03,'afa-092',0)
               NEXT FIELD fbd03
            END IF
         END IF
         #No.MOD-AC0055  --End  

         #FUN-AB0088---add---str---
        IF g_faa.faa31 ='Y' THEN
             IF g_aza.aza26 <> '2' THEN
                SELECT COUNT(*) INTO l_cnt FROM fbn_file
                 WHERE fbn01 = g_fbd[l_ac].fbd03
                   AND fbn02 = g_fbd[l_ac].fbd031
                   AND (fbn03 = g_yy AND fbn04 >= g_mm OR fbn03 > g_yy)
                   AND fbn041 = '1'   #MOD-BC0025 add
                IF l_cnt > 0 THEN
                   CALL cl_err(g_fbd[l_ac].fbd03,'afa-092',0)
                   NEXT FIELD fbd03
                END IF
             ELSE
                SELECT COUNT(*) INTO l_cnt FROM fbn_file
                 WHERE fbn01 = g_fbd[l_ac].fbd03
                   AND fbn02 = g_fbd[l_ac].fbd031
                   AND (fbn03 = g_yy AND fbn04 > g_mm OR fbn03 > g_yy)
                   AND fbn041 = '1'   #MOD-BC0025 add
                IF l_cnt > 0 THEN
                   CALL cl_err(g_fbd[l_ac].fbd03,'afa-092',0)
                   NEXT FIELD fbd03
                END IF
             END IF
           END IF 
        #FUN-AB0088---add---end---
 
        AFTER FIELD fbd09
           LET g_fbd[l_ac].fbd09 = cl_digcut(g_fbd[l_ac].fbd09,g_azi04)   #MOD-750051
           IF cl_null(g_e[l_ac].fbd19) OR g_e[l_ac].fbd19 = 0
           THEN LET g_e[l_ac].fbd19 = g_fbd[l_ac].fbd09
           END IF
           IF g_fbd[l_ac].fbd09 <0 THEN 
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbd09
           END IF
 
        AFTER FIELD fbd10
           LET g_fbd[l_ac].fbd10 = cl_digcut(g_fbd[l_ac].fbd10,g_azi04)   #MOD-750051
           IF g_fbd[l_ac].fbd10 <0 THEN 
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbd10
           END IF
 
        AFTER FIELD fbd12
           LET g_fbd[l_ac].fbd12 = cl_digcut(g_fbd[l_ac].fbd12,g_azi04)   
           IF g_fbd[l_ac].fbd12 <0 THEN 
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbd12
           END IF
 
        #FUN-C90088--B--
        BEFORE FIELD fbd11
            SELECT faj29,faj292 INTO l_faj29,l_faj292
              FROM faj_file
             WHERE faj02  = g_fbd[l_ac].fbd03
               AND faj022 = g_fbd[l_ac].fbd031
        #FUN-C90088--E--

        AFTER FIELD fbd11
           IF g_aza.aza26 = '2' THEN
              SELECT DISTINCT(fab23) INTO l_fab23 FROM fab_file,faj_file
               WHERE fab01  = faj04
                 AND faj02  = g_fbd[l_ac].fbd03
                 AND faj022 = g_fbd[l_ac].fbd031
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","fab_file,faj_file",g_fbd[l_ac].fbd03,g_fbd[l_ac].fbd031,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                 LET g_success = 'N' RETURN
              END IF
              IF g_faj28 MATCHES '[05]' THEN
                 LET l_fbd12 = 0
              ELSE
#                 LET l_fbd12 = (g_fbd[l_ac].fbd09 -    #MOD-780022  #MOD-A40033 mark
#                                g_fbd[l_ac].fbd10)*l_fab23/100      #MOD-A40033 mark
                 LET l_fbd12 = g_fbd[l_ac].fbd09*l_fab23/100      #MOD-A40033 
              END IF
              LET g_fbd[l_ac].fbd12 = l_fbd12
           ELSE
              CASE g_faj28
                 WHEN '0'  LET l_fbd12 = 0
                           LET g_fbd[l_ac].fbd12 = 0
                 WHEN '1' LET l_fbd12 =(g_fbd[l_ac].fbd09-   #MOD-780022
                                g_fbd[l_ac].fbd10) /(g_fbd[l_ac].fbd11 + 12)*12
                          LET g_fbd[l_ac].fbd12 = l_fbd12
                 OTHERWISE EXIT CASE
              END CASE
              DISPLAY BY NAME g_fbd[l_ac].fbd12
            END IF
           IF g_fbd[l_ac].fbd11 <0 THEN 
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbd11
           END IF
           #FUN-C90088--B--
           IF (l_faj29+g_fbd[l_ac].fbd11 - g_fbd[l_ac].fbd06) <  0 THEN
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbd11
           END IF
           #FUN-C90088--E--
 
        BEFORE DELETE                            #是否取消單身
            IF g_fbd_t.fbd02 > 0 AND g_fbd_t.fbd02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM fbd_file
                 WHERE fbd01 = g_fbc.fbc01
                   AND fbd02 = g_fbd_t.fbd02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","fbd_file",g_fbc.fbc01,g_fbd_t.fbd02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET l_fbc08 = '0'   #FUN-580109
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fbd[l_ac].* = g_fbd_t.*
               CLOSE t107_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fbd[l_ac].fbd02,-263,1)
               LET g_fbd[l_ac].* = g_fbd_t.*
            ELSE
               UPDATE fbd_file SET
                     fbd01=g_fbc.fbc01,fbd02=g_fbd[l_ac].fbd02,
                     fbd03=g_fbd[l_ac].fbd03,fbd031=g_fbd[l_ac].fbd031,
                     fbd04=g_fbd[l_ac].fbd04,fbd05=g_fbd[l_ac].fbd05,
                     fbd06=g_fbd[l_ac].fbd06,fbd07=g_fbd[l_ac].fbd07,
                     fbd09=g_fbd[l_ac].fbd09,fbd10=g_fbd[l_ac].fbd10,
                     fbd11=g_fbd[l_ac].fbd11,fbd12=g_fbd[l_ac].fbd12
                     ,fbdud01 = g_fbd[l_ac].fbdud01,
                     fbdud02 = g_fbd[l_ac].fbdud02,
                     fbdud03 = g_fbd[l_ac].fbdud03,
                     fbdud04 = g_fbd[l_ac].fbdud04,
                     fbdud05 = g_fbd[l_ac].fbdud05,
                     fbdud06 = g_fbd[l_ac].fbdud06,
                     fbdud07 = g_fbd[l_ac].fbdud07,
                     fbdud08 = g_fbd[l_ac].fbdud08,
                     fbdud09 = g_fbd[l_ac].fbdud09,
                     fbdud10 = g_fbd[l_ac].fbdud10,
                     fbdud11 = g_fbd[l_ac].fbdud11,
                     fbdud12 = g_fbd[l_ac].fbdud12,
                     fbdud13 = g_fbd[l_ac].fbdud13,
                     fbdud14 = g_fbd[l_ac].fbdud14,
                     fbdud15 = g_fbd[l_ac].fbdud15
              WHERE fbd01=g_fbc.fbc01 AND fbd02=g_fbd_t.fbd02
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                  CALL cl_err3("upd","fbd_file",g_fbc.fbc01,g_fbd_t.fbd02,SQLCA.sqlcode,"","upd fbd",1)  #No.FUN-660136
                  LET g_fbd[l_ac].* = g_fbd_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  LET l_fbc08 = '0'   #FUN-580109
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
                  LET g_fbd[l_ac].* = g_fbd_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_fbd.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE t107_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add
            CLOSE t107_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fbd02) AND l_ac > 1 THEN
                LET g_fbd[l_ac].* = g_fbd[l_ac-1].*
                LET g_fbd[l_ac].fbd02 = NULL
                NEXT FIELD fbd02
            END IF
 
        ON ACTION tax_data  #稅簽資料
            CASE WHEN INFIELD(fbd09)  #異動後取得成本
                      CALL t107_e(p_cmd)
                 WHEN INFIELD(fbd10)  #異動後累計折舊
                      CALL t107_e(p_cmd)
                 WHEN INFIELD(fbd11)  #異動後未用年限
                      CALL t107_e(p_cmd)
                 WHEN INFIELD(fbd12)  #異動後預估殘值
                      CALL t107_e(p_cmd)
                 WHEN INFIELD(fbd02)  #異動後預估殘值
                      CALL t107_e(p_cmd)
                 WHEN INFIELD(fbd03)  #異動後預估殘值
                      CALL t107_e(p_cmd)
                 WHEN INFIELD(fbd031) #異動後預估殘值
                      CALL t107_e(p_cmd)
            END CASE
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(fbd03)  #財產編號,財產附號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.default1 = g_fbd[l_ac].fbd03
                 LET g_qryparam.default2 = g_fbd[l_ac].fbd031
                 CALL cl_create_qry() RETURNING
                      g_fbd[l_ac].fbd03,g_fbd[l_ac].fbd031
                 DISPLAY g_fbd[l_ac].fbd03  TO fbd03
                 DISPLAY g_fbd[l_ac].fbd031 TO fbd031
                 NEXT FIELD fbd03
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
 
     LET g_fbc.fbcmodu = g_user
     LET g_fbc.fbcdate = g_today
     UPDATE fbc_file SET fbcmodu = g_fbc.fbcmodu,fbcdate = g_fbc.fbcdate
      WHERE fbc01 = g_fbc.fbc01
     DISPLAY BY NAME g_fbc.fbcmodu,g_fbc.fbcdate
 
      UPDATE fbc_file SET fbc08=l_fbc08 WHERE fbc01 = g_fbc.fbc01
      LET g_fbc.fbc08 = l_fbc08
      DISPLAY BY NAME g_fbc.fbc08
      IF g_fbc.fbcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
      IF g_fbc.fbc08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
      CALL cl_set_field_pic(g_fbc.fbcconf,g_chr2,g_fbc.fbcpost,"",g_chr,"")
 
      CLOSE t107_bcl
      COMMIT WORK
      CALL t107_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t107_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_fbc.fbc01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fbc_file ",
                  "  WHERE fbc01 LIKE '",l_slip,"%' ",
                  "    AND fbc01 > '",g_fbc.fbc01,"'"
      PREPARE t107_pb1 FROM l_sql 
      EXECUTE t107_pb1 INTO l_cnt 
      
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
        #CALL t107_x()       #FUN-D20035
         CALL t107_x(1)           #FUN-D20035
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 9
                                AND npp01 = g_fbc.fbc01
                                AND npp011= 1
         DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 9
                                AND npq01 = g_fbc.fbc01
                                AND npq011= 1
         DELETE FROM tic_file WHERE tic04 = g_fbc.fbc01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM fbc_file WHERE fbc01 = g_fbc.fbc01
         INITIALIZE g_fbc.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t107_fbd031(p_cmd)
   DEFINE   p_cmd       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
            l_faj06     LIKE faj_file.faj06,
            l_faj14     LIKE faj_file.faj14,
            l_faj141    LIKE faj_file.faj141,   #MOD-780022
            l_faj32     LIKE faj_file.faj32,
            l_faj30     LIKE faj_file.faj30,
            l_faj31     LIKE faj_file.faj31,
            l_faj35     LIKE faj_file.faj35,
            l_fan07     LIKE fan_file.fan07,
            l_faj67     LIKE faj_file.faj67,
            l_faj62     LIKE faj_file.faj62,
            l_faj65     LIKE faj_file.faj65,
            l_faj66     LIKE faj_file.faj66,
            l_faj72     LIKE faj_file.faj72,
            l_faj43     LIKE faj_file.faj43,
            l_fajconf   LIKE faj_file.fajconf,
            l_faj100    LIKE faj_file.faj100
   DEFINE   l_n         LIKE type_file.num5    #CHI-B80007 add 

   LET g_errno = ' '
   #CHI-B80007 -- begin --
   SELECT count(*) INTO l_n FROM fbd_file,fbc_file
     WHERE fbd01 = fbc01
      AND fbd03  = g_fbd[l_ac].fbd03
      AND fbd031 = g_fbd[l_ac].fbd031
      AND fbc02 <= g_fbc.fbc02
      AND fbcpost = 'N'
      AND fbc01 != g_fbc.fbc01
      AND fbcconf <> 'X'
   IF l_n  > 0 THEN
      LET g_errno = 'afa-309'
      RETURN
   END IF
   #CHI-B80007 -- end --
   SELECT faj06,faj14,faj141,faj32,faj30,faj31,faj35,faj67,faj62,faj65,faj66,faj72,   #MOD-780022
          faj43,fajconf,faj100,faj28,faj141
     INTO l_faj06,l_faj14,l_faj141,l_faj32,l_faj30,l_faj31,l_faj35,l_faj67,   #MOD-780022
          l_faj62,l_faj65,
          l_faj66,l_faj72,l_faj43,l_fajconf,l_faj100,g_faj28,g_faj141
     FROM faj_file
    WHERE faj02  = g_fbd[l_ac].fbd03
      AND faj022 = g_fbd[l_ac].fbd031
   CASE
      #WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-093'    #MOD-C70265 mark
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-134'    #MOD-C70265 add
       WHEN l_faj100 > g_fbc.fbc02     LET g_errno = 'afa-113'
       WHEN l_fajconf  = 'N'           LET g_errno = 'afa-312'
       WHEN l_faj43  matches '[056X]'  LET g_errno = 'afa-313'
       OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF l_faj43 = '7' THEN    #折畢再提
      LET l_faj31 = l_faj35
      LET l_faj66 = l_faj72
   END IF
   IF ( p_cmd = 'a' OR p_cmd = 'u') AND cl_null(g_errno) THEN      #MOD-950166     
      LET g_fbd[l_ac].fbd04 = l_faj14     #取得成本
      LET g_fbd[l_ac].fbd05 = l_faj32     #累折
      LET g_fbd[l_ac].fbd06 = l_faj30     #未用年限
      LET g_fbd[l_ac].fbd07 = l_faj31     #預估殘值
      LET g_fbd[l_ac].fbd09 = l_faj14
      LET g_fbd[l_ac].fbd10 = l_faj32
      LET g_fbd[l_ac].fbd11 = l_faj30
      LET g_fbd[l_ac].fbd12 = l_faj31
      LET g_fbd[l_ac].faj06 = l_faj06
      LET g_e[l_ac].fbd14   = l_faj62     #成本
      LET g_fbd[l_ac].faj141= l_faj141    #MOD-780022
      LET g_e[l_ac].fbd15   = l_faj67     #累折
      LET g_e[l_ac].fbd16   = l_faj65     #未用年限
      LET g_e[l_ac].fbd17   = l_faj66     #預估殘值
      LET g_e[l_ac].fbd20   = l_faj67
      LET g_e[l_ac].fbd21   = l_faj65
   END IF
END FUNCTION
 
FUNCTION t107_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON fbd02,fbd03,fbd031,fbd04,fbd05,fbd06,fbd07,
                       fbd09,fbd10,fbd11,fbd12
         FROM s_fbd[1].fbd02, s_fbd[1].fbd03,s_fbd[1].fbd031,s_fbd[1].fbd04,
              s_fbd[1].fbd05,s_fbd[1].fbd06,s_fbd[1].fbd07,
              s_fbd[1].fbd09,s_fbd[1].fbd10,s_fbd[1].fbd11,s_fbd[1].fbd12
 
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
    CALL t107_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t107_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    LET g_sql =
        "SELECT fbd02,fbd03,fbd031,faj06,fbd04,faj141,fbd09,",   #MOD-780022
        " fbd05,fbd10,fbd06,fbd11,fbd07,fbd12 ",
        "       ,fbdud01,fbdud02,fbdud03,fbdud04,fbdud05,",
        "       fbdud06,fbdud07,fbdud08,fbdud09,fbdud10,",
        "       fbdud11,fbdud12,fbdud13,fbdud14,fbdud15", 
        "  FROM fbd_file LEFT OUTER JOIN faj_file ON fbd03=faj02 AND fbd031 = faj022 ",
        " WHERE fbd01  ='",g_fbc.fbc01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE t107_pb FROM g_sql
    DECLARE fbd_curs                       #SCROLL CURSOR
        CURSOR FOR t107_pb
    CALL g_fbd.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fbd_curs INTO g_fbd[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_fbd.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t107_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fbd TO s_fbd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
       #FUN-C30140--mark---str---
       ##IF g_aza.aza63 = 'Y' THEN    #FUN-AB0088 mark
       # IF g_faa.faa31 = 'Y' THEN    #FUN-AB0088 add
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
         CALL t107_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t107_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t107_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t107_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t107_fetch('L')
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
         IF g_fbc.fbcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_fbc.fbc08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_fbc.fbcconf,g_chr2,g_fbc.fbcpost,"",g_chr,"")
 
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
      #@ON ACTION 會計分錄產生
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
      ON ACTION fin_audit2  
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
 
FUNCTION t107_g()
 DEFINE ls_tmp STRING
 DEFINE  l_wc        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(300)
         l_sql       LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(600)
         l_faj       RECORD
               faj02     LIKE faj_file.faj02,
               faj022    LIKE faj_file.faj022,
               faj06     LIKE faj_file.faj06,
               faj14     LIKE faj_file.faj14,
               faj141    LIKE faj_file.faj141,   #MOD-780022
               faj32     LIKE faj_file.faj32,
               faj30     LIKE faj_file.faj30,
               faj31     LIKE faj_file.faj31,
               faj67     LIKE faj_file.faj67,
               faj62     LIKE faj_file.faj62,
               faj65     LIKE faj_file.faj65,
               faj66     LIKE faj_file.faj66
               END RECORD,
         ans         LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_cnt       LIKE type_file.num5,        #CHI-B80007 add
         l_i         LIKE type_file.num5         #No.FUN-680070 SMALLINT
#FUN-BB0122--being add
   DEFINE l_faj142   LIKE faj_file.faj142
   DEFINE l_faj322   LIKE faj_file.faj322
   DEFINE l_faj302   LIKE faj_file.faj302
   DEFINE l_faj312   LIKE faj_file.faj312
#FUN-BB0122--end add
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbc.fbc01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fbc.fbcconf='Y' THEN
      CALL cl_err(g_fbc.fbc01,'afa-107',0) RETURN
   END IF
    IF g_fbc.fbcconf = 'X' THEN
       CALL cl_err(' ','9024',0)
       RETURN
    END IF
   IF NOT cl_confirm('afa-103') THEN RETURN END IF     #No.MOD-490235
     LET INT_FLAG = 0
 
  #---------詢問是否自動新增單身--------------
      LET p_row = 8 LET p_col = 22
      OPEN WINDOW t107_w2 AT p_row,p_col WITH FORM "afa/42f/afat106g"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
      CALL cl_ui_locale("afat106g")
 
 
     #CONSTRUCT BY NAME l_wc ON faj01,faj02,faj022,faj53            #No.FUN-B50118 mark
      CONSTRUCT BY NAME l_wc ON faj01,faj93,faj02,faj022,faj53      #No.FUN-B50118 add
 
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
      IF l_wc =" 1=1" THEN
         CALL cl_err('','abm-997',1) 
         LET INT_FLAG = 1
      END IF 
      IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t107_w2 RETURN END IF
 
      BEGIN WORK
 
      OPEN t107_cl USING g_fbc.fbc01
      IF STATUS THEN
         CALL cl_err("OPEN t107_cl:", STATUS, 1)
         CLOSE t107_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH t107_cl INTO g_fbc.*          # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_fbc.fbc01,SQLCA.sqlcode,0)     # 資料被他人LOCK
         CLOSE t107_cl ROLLBACK WORK RETURN
      END IF
 
      LET l_sql ="SELECT faj02,faj022,faj06,faj14,faj141,faj32,faj30,faj31,faj67,",   #MOD-780022
                 "faj62,faj65,faj66",
                 "  FROM faj_file ",
                 " WHERE faj43 NOT IN ('0','5','6','X') AND fajconf = 'Y'",
                 "   AND ",l_wc CLIPPED,
                 " ORDER BY 1"
     PREPARE t107_prepare_g FROM l_sql
     DISPLAY 'l_sql:',l_sql
     IF SQLCA.SQLCODE != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0)
         CLOSE t107_cl ROLLBACK WORK RETURN
     END IF
     DECLARE t107_curs2 CURSOR FOR t107_prepare_g
 
     SELECT MAX(fbd02)+1 INTO l_i FROM fbd_file
      WHERE fbd01 = g_fbc.fbc01
     IF SQLCA.sqlcode THEN LET l_i = 1 END IF
     IF cl_null(l_i) THEN LET l_i = 1 END IF
     LET g_success = 'Y'      #No.FUN-8A0086
     CALL s_showmsg_init()    #No.FUN-710028
     FOREACH t107_curs2 INTO l_faj.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
     display l_i,l_faj.*
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('','','foreach:',SQLCA.sqlcode,0) #No.FUN-710028
          EXIT FOREACH
       END IF
       #no:4532檢查資產盤點期間應不可做異動
       SELECT COUNT(*) INTO g_cnt FROM fca_file
        WHERE fca03  = l_faj.faj02
          AND fca031 = l_faj.faj022
          AND fca15  = 'N'
           IF g_cnt > 0 THEN
              CONTINUE FOREACH
           END IF
       message l_faj.faj02,' ',l_faj.faj022
       IF cl_null(l_faj.faj022) THEN
          LET l_faj.faj022 = ' '
       END IF

       #No.MOD-AC0055  --Begin
       IF g_aza.aza26 <> '2' THEN
          #-----TQC-780089---------
          SELECT COUNT(*) INTO g_cnt FROM fan_file
           WHERE fan01 = l_faj.faj02
             AND fan02 = l_faj.faj022
             AND (fan03 = g_yy AND fan04 >= g_mm OR fan03 > g_yy)
             AND fan041 = '1'   #MOD-BC0025 add
          IF g_cnt > 0 THEN
             CALL cl_err(l_faj.faj02,'afa-092',0)
             CONTINUE FOREACH
          END IF
          #-----END TQC-780089-----
       ELSE
          SELECT COUNT(*) INTO g_cnt FROM fan_file
           WHERE fan01 = l_faj.faj02
             AND fan02 = l_faj.faj022
             AND (fan03 = g_yy AND fan04 > g_mm OR fan03 > g_yy)
             AND fan041 = '1'   #MOD-BC0025 add
          IF g_cnt > 0 THEN
             CALL cl_err(l_faj.faj02,'afa-092',0)
             CONTINUE FOREACH
          END IF
       END IF
       #No.MOD-AC0055  --End 

       #FUN-AB0088---add---str---
       IF g_faa.faa31 = 'Y' THEN
           IF g_aza.aza26 <> '2' THEN
              SELECT COUNT(*) INTO g_cnt FROM fbn_file
               WHERE fbn01 = l_faj.faj02
                 AND fbn02 = l_faj.faj022
                 AND (fbn03 = g_yy AND fbn04 >= g_mm OR fbn03 > g_yy)
                 AND fbn041 = '1'   #MOD-BC0025 add
              IF g_cnt > 0 THEN
                 CALL cl_err(l_faj.faj02,'afa-092',0)
                 CONTINUE FOREACH
              END IF
           ELSE
              SELECT COUNT(*) INTO g_cnt FROM fbn_file
               WHERE fbn01 = l_faj.faj02
                 AND fbn02 = l_faj.faj022
                 AND (fbn03 = g_yy AND fbn04 > g_mm OR fbn03 > g_yy)
                 AND fbn041 = '1'   #MOD-BC0025 add
              IF g_cnt > 0 THEN
                 CALL cl_err(l_faj.faj02,'afa-092',0)
                 CONTINUE FOREACH
              END IF
           END IF
       END IF
       #FUN-AB0088---add---end---
       #CHI-B80007 -- begin --
       SELECT count(*) INTO l_cnt FROM fbd_file,fbc_file
         WHERE fbd01 = fbc01
          AND fbd03  = l_faj.faj02
          AND fbd031 = l_faj.faj022
          AND fbc02 <= g_fbc.fbc02
          AND fbcpost = 'N'
          AND fbc01 != g_fbc.fbc01
          AND fbcconf <> 'X'
       IF l_cnt > 0 THEN
          CONTINUE FOREACH
       END IF
       #CHI-B80007 -- end --
           #FUN-BB0122---being add
                     SELECT faj142,faj322,faj302,faj312
                       INTO l_faj142,l_faj322,l_faj302,l_faj312
                       FROM faj_file
                      WHERE faj02  = l_faj.faj02
                        AND faj022 = l_faj.faj022
                     IF cl_null(l_faj142) THEN LET l_faj142 = 0 END IF
                     IF cl_null(l_faj322) THEN LET l_faj322 = 0 END IF
                     IF cl_null(l_faj302) THEN LET l_faj302 = 0 END IF
                     IF cl_null(l_faj312) THEN LET l_faj312 = 0 END IF        
           #FUN-BB0122---end add

          #CHI-C60010---str---
           CALL cl_digcut(l_faj142,g_azi04_1) RETURNING l_faj142
           CALL cl_digcut(l_faj322,g_azi04_1) RETURNING l_faj322
           CALL cl_digcut(l_faj312,g_azi04_1) RETURNING l_faj312
          #CHI-C60010---end--- 
       INSERT INTO fbd_file(fbd01,fbd02,fbd03,fbd031,fbd04,fbd05,fbd06,fbd07,
                            fbd09,fbd10,fbd11,fbd12,fbd14,fbd15,fbd16,fbd17,
                            fbd19,fbd20,fbd21,fbd22,
                            fbd042,fbd052,fbd062,fbd072,fbd092,fbd102,fbd112,fbd122,   #FUN-AB0088 add
                            fbdlegal) #FUN-980003 add
                    VALUES(g_fbc.fbc01,l_i,l_faj.faj02,l_faj.faj022,l_faj.faj14,
                           l_faj.faj32,l_faj.faj30,l_faj.faj31,
                           l_faj.faj14,l_faj.faj32,l_faj.faj30,l_faj.faj31,
                           l_faj.faj62,l_faj.faj67,l_faj.faj65,l_faj.faj66,
                           l_faj.faj62,l_faj.faj67,l_faj.faj65,l_faj.faj66,
                           #0,0,0,0,0,0,0,0,    #FUN-AB0088 add #FUN-BB0122 mark  
                           l_faj142,l_faj322,l_faj302,l_faj312,l_faj142,l_faj322,l_faj302,l_faj312, #FUN-BB0122 add
                           g_legal) #FUN-980003 add
       IF STATUS  THEN
          LET g_showmsg = g_fbc.fbc01,"/",l_i                         #No.FUN-710028 
          CALL s_errmsg('fbd01,fbd02',g_showmsg,'ins fbd',STATUS,0)   #No.FUN-710028
          CONTINUE FOREACH   #No.FUN-710028
       END IF
       LET l_i = l_i + 1
     END FOREACH
     IF g_totsuccess="N" THEN                                                                                                        
        LET g_success="N"                                                                                                            
     END IF                                                                                                                          
 
     CLOSE t107_cl
     CALL s_showmsg()   #No.FUN-710028
     COMMIT WORK
     CLOSE WINDOW t107_w2
     CALL t107_b_fill(l_wc)
END FUNCTION
 
FUNCTION t107_k()
   DEFINE g_fbd     DYNAMIC ARRAY OF RECORD
                     fbd02	LIKE fbd_file.fbd02,    #No.MOD-480098
                    fbd03	LIKE fbd_file.fbd03,
                     fbd031	LIKE fbd_file.fbd031,   #No.MOD-490181
                    faj06	LIKE faj_file.faj06,
                    fbd04	LIKE fbd_file.fbd04,
                    fbd09	LIKE fbd_file.fbd09,
                    fbd05	LIKE fbd_file.fbd05,
                    fbd10	LIKE fbd_file.fbd10,
                    fbd06	LIKE fbd_file.fbd06,
                    fbd11	LIKE fbd_file.fbd11,
                    fbd07	LIKE fbd_file.fbd07,
                    fbd12	LIKE fbd_file.fbd12,
                    fbd14	LIKE fbd_file.fbd14,
                    fbd15	LIKE fbd_file.fbd15,
                    fbd16	LIKE fbd_file.fbd16,
                    fbd17	LIKE fbd_file.fbd17,
                    fbd19	LIKE fbd_file.fbd19,
                    fbd20	LIKE fbd_file.fbd20,
                    fbd21	LIKE fbd_file.fbd21,
                    fbd22	LIKE fbd_file.fbd22
                    END RECORD
   DEFINE g_fbd_t   RECORD
                     fbd02	LIKE fbd_file.fbd02,    #No.MOD-480098
                    fbd03	LIKE fbd_file.fbd03,
                     fbd031	LIKE fbd_file.fbd031,   #No.MOD-490181
                    faj06	LIKE faj_file.faj06,
                    fbd04	LIKE fbd_file.fbd04,
                    fbd09	LIKE fbd_file.fbd09,
                    fbd05	LIKE fbd_file.fbd05,
                    fbd10	LIKE fbd_file.fbd10,
                    fbd06	LIKE fbd_file.fbd06,
                    fbd11	LIKE fbd_file.fbd11,
                    fbd07	LIKE fbd_file.fbd07,
                    fbd12	LIKE fbd_file.fbd12,
                    fbd14	LIKE fbd_file.fbd14,
                    fbd15	LIKE fbd_file.fbd15,
                    fbd16	LIKE fbd_file.fbd16,
                    fbd17	LIKE fbd_file.fbd17,
                    fbd19	LIKE fbd_file.fbd19,
                    fbd20	LIKE fbd_file.fbd20,
                    fbd21	LIKE fbd_file.fbd21,
                    fbd22	LIKE fbd_file.fbd22
                    END RECORD
   DEFINE l_fbd22   LIKE fbd_file.fbd22
   DEFINE l_lock_sw       LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE l_modify_flag   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE p_cmd           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE l_faj28   LIKE faj_file.faj28
   DEFINE i,j,k           LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE ls_tmp STRING
   DEFINE l_allow_insert  LIKE type_file.num5                 #可新增否       #No.FUN-680070 SMALLINT
   DEFINE l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
   DEFINE l_fab23   LIKE fab_file.fab23          #No:A099
   DEFINE l_cnt     LIKE type_file.num5   #CHI-860025
 
   IF g_fbc.fbc01 IS NULL THEN RETURN END IF
   IF g_fbc.fbcconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   #FUN-C30140---add---str---
   IF NOT cl_null(g_fbc.fbc08) AND g_fbc.fbc08 matches '[Ss]' THEN     
       CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
       RETURN
   END IF 
   #FUN-C30140---add---end---
   LET p_row = 10 LET p_col =16
   OPEN WINDOW t107_w5 AT p_row,p_col WITH FORM "afa/42f/afat1072"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afat1072")
 
 
   DECLARE t107_kkk_c CURSOR FOR
          SELECT fbd02, fbd03, fbd031, faj06, fbd04, fbd09, fbd05,   #No:BUG-480098,No.MOD-490181   #MOD-780022   #CHI-860025 取消mark
                fbd10, fbd06, fbd11, fbd07, fbd12, fbd14,
                fbd15, fbd16, fbd17, fbd19, fbd20, fbd21,
                fbd22
           FROM fbd_file LEFT OUTER JOIN faj_file ON fbd03 = faj02 AND fbd031 = faj022
            WHERE fbd01 = g_fbc.fbc01
          ORDER BY 1
   FOR k = 1 TO 200 INITIALIZE g_fbd[k].* TO NULL END FOR
   LET k = 1
   FOREACH t107_kkk_c INTO g_fbd[k].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('t107_kkk_c',SQLCA.sqlcode,0) 
         EXIT FOREACH
      END IF
      #No.MOD-AC0055  --Begin
      IF g_aza.aza26 <> '2' THEN
         #-----CHI-860025---------
         LET l_cnt = 0 
         SELECT COUNT(*) INTO l_cnt FROM fao_file
          WHERE fao01 = g_fbd[k].fbd03
            AND fao02 = g_fbd[k].fbd031
            AND (fao03 = g_yy AND fao04 >= g_mm OR fao03 > g_yy)
            AND fao041 = '1'   #MOD-BC0025 add
         IF l_cnt > 0 THEN
            CALL cl_err(g_fbd[k].fbd03,'afa-092',0)
            CONTINUE FOREACH
         END IF
         #-----END CHI-860025-----
      ELSE
         LET l_cnt = 0 
         SELECT COUNT(*) INTO l_cnt FROM fao_file
          WHERE fao01 = g_fbd[k].fbd03
            AND fao02 = g_fbd[k].fbd031
            AND (fao03 = g_yy AND fao04 > g_mm OR fao03 > g_yy)
            AND fao041 = '1'   #MOD-BC0025 add
         IF l_cnt > 0 THEN
            CALL cl_err(g_fbd[k].fbd03,'afa-092',0)
            CONTINUE FOREACH
         END IF
      END IF
      #No.MOD-AC0055  --End  
      LET k = k + 1
      IF k > 200 THEN EXIT FOREACH END IF
   END FOREACH
   CALL g_fbd.deleteElement(k)   #CHI-860025
   Let k = k - 1   #CHI-860025
   CALL SET_COUNT(k)   #CHI-860025
   SELECT * FROM fbc_file WHERE fbc01 = g_fbc.fbc01
   DISPLAY BY NAME g_fbc.fbcconf, g_fbc.fbcpost, g_fbc.fbcpost2,
                   g_fbc.fbcuser, g_fbc.fbcgrup, g_fbc.fbcmodu,g_fbc.fbcdate
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_fbd WITHOUT DEFAULTS FROM s_fbd.*
         ATTRIBUTE(COUNT=k,MAXCOUNT=g_max_rec,UNBUFFERED,   #CHI-860025
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INSERT
         LET i = ARR_CURR() LET j = SCR_LINE()
         LET p_cmd='a'
         INITIALIZE g_fbd[i].* TO NULL
         LET g_fbd_t.* = g_fbd[i].*
 
      BEFORE INPUT
          CALL fgl_set_arr_curr(l_ac)
 
      BEFORE ROW
         LET i = ARR_CURR() LET j = SCR_LINE()
         LET g_fbd_t.* = g_fbd[i].*
         LET l_lock_sw = 'N'
         IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_success = 'Y'
         ELSE
              LET g_success = 'Y'
              LET p_cmd='a'
              INITIALIZE g_fbd[i].* TO NULL
         END IF
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      BEFORE FIELD fbd22
         SELECT faj61 INTO l_faj28 FROM faj_file        #No:A099
                      WHERE faj02 = g_fbd[i].fbd03
                        AND faj022= g_fbd[i].fbd031
         IF SQLCA.sqlcode THEN LET l_faj28 = '' END IF
         IF g_aza.aza26 = '2' THEN
            SELECT DISTINCT(fab23) INTO l_fab23 FROM fab_file,faj_file
             WHERE fab01  = faj04
               AND faj02  = g_fbd[i].fbd03
               AND faj022 = g_fbd[i].fbd031
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","fab_file,faj_file",g_fbd[i].fbd03,g_fbd[i].fbd031,SQLCA.sqlcode,"","",1)  #No.FUN-660136
               LET g_success = 'N' RETURN
            END IF
            IF l_faj28 MATCHES '[05]' THEN
               LET l_fbd22 = 0
            ELSE
#               LET l_fbd22 = (g_fbd[i].fbd19 - g_fbd[i].fbd20) * l_fab23 /100  #MOD-A40033 mark
                LET l_fbd22 = g_fbd[i].fbd19*l_fab23 /100  #MOD-A40033 
            END IF
            LET g_fbd[i].fbd22 = l_fbd22
            DISPLAY g_fbd[i].fbd22 TO s_fbd[j].fbd22
         ELSE
            CASE
              WHEN l_faj28 = '0'
                   LET g_fbd[i].fbd22 = 0
                   DISPLAY g_fbd[i].fbd22 TO s_fbd[j].fbd22
              WHEN l_faj28 = '1'
                   LET l_fbd22 = (g_fbd[i].fbd19 - g_fbd[i].fbd20)
                                /(g_fbd[i].fbd21 + 12)*12
                   LET g_fbd[i].fbd22 = l_fbd22
                   DISPLAY g_fbd[i].fbd22 TO s_fbd[j].fbd22
            END CASE
         END IF

      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_fbd[l_ac].* = g_fbd_t.*
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_fbd[l_ac].fbd02,-263,1)
             LET g_fbd[l_ac].* = g_fbd_t.*
          ELSE
             UPDATE fbd_file SET fbd19 = g_fbd[i].fbd19,
                                 fbd20 = g_fbd[i].fbd20,
                                 fbd21 = g_fbd[i].fbd21,
                                 fbd22 = g_fbd[i].fbd22
                      WHERE fbd01 = g_fbc.fbc01 AND fbd02 = g_fbd_t.fbd02
             IF STATUS THEN
                  CALL cl_err3("upd","fbd_file",g_fbc.fbc01,g_fbd_t.fbd02,SQLCA.sqlcode,"","upd fbd:",1)  #No.FUN-660136
                  LET g_success = 'N'
                  LET g_fbd[i].* = g_fbd_t.*
                  DISPLAY g_fbd[i].* TO s_fbd[j].*
             ELSE MESSAGE "update ok"
             END IF
          END IF
 
      AFTER ROW
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            ROLLBACK WORK
            EXIT INPUT
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
   IF INT_FLAG THEN LET g_success='N' LET INT_FLAG = 0 END IF
   CLOSE WINDOW t107_w5
END FUNCTION
 
FUNCTION t107_y() 	
DEFINE l_cnt LIKE type_file.num5         #No.FUN-680070 SMALLINT
   SELECT * INTO g_fbc.* FROM fbc_file WHERE fbc01 = g_fbc.fbc01
   IF g_fbc.fbcconf='Y' THEN RETURN END IF
   IF g_fbc.fbcpost='Y' THEN
      CALL cl_err('fbcpost=Y:','afa-101',0)
      RETURN
   END IF
   #-----No:FUN-B60140-----
   IF g_faa.faa31 = "Y" THEN
      IF g_fbc.fbcpost1='Y' THEN
         CALL cl_err('fbcpost1=Y:','afa-101',0)
         RETURN
      END IF
   END IF
   #-----No:FUN-B60140 END-----
   IF g_fbc.fbcconf = 'X' THEN
       CALL cl_err(' ','9024',0)
       RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt FROM fbd_file
    WHERE fbd01= g_fbc.fbc01
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期小於關帳日期
   IF g_fbc.fbc02 < g_faa.faa09 THEN
      CALL cl_err(g_fbc.fbc01,'aap-176',1) RETURN
   END IF
    #-----No:FUN-B60140-----
   IF g_faa.faa31 = "Y" THEN
      #-->立帳日期小於關帳日期
      IF g_fbc.fbc02 < g_faa.faa092 THEN
         CALL cl_err(g_fbc.fbc01,'aap-176',1) RETURN
      END IF
   END IF
   #-----No:FUN-B60140 END-----
#FUN-C30313---mark---START
#   IF g_fah.fahdmy3 = 'Y' THEN
#      IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125 
#         CALL s_chknpq(g_fbc.fbc01,'FA',1,'0',g_bookno1)  #No.FUN-740033
#      END IF #MOD-BC0125
##     IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 mark
#      IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN    #FUN-AB0088 add #MOD-BC0125  
#        CALL s_chknpq(g_fbc.fbc01,'FA',1,'1',g_bookno2)  #No.FUN-740033
#      END IF
#   END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
    IF g_fah.fahdmy3 = 'Y' THEN
       IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125
          CALL s_chknpq(g_fbc.fbc01,'FA',1,'0',g_bookno1)  #No.FUN-740033
       END IF #MOD-BC0125
    END IF
    IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN    #FUN-AB0088 add #MOD-BC0125
       IF g_fah.fahdmy32 = 'Y' THEN
         CALL s_chknpq(g_fbc.fbc01,'FA',1,'1',g_bookno2)  #No.FUN-740033
       END IF
    END IF
#FUN-C30313---add---END-------
   IF g_success = 'N' THEN RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   BEGIN WORK
 
    OPEN t107_cl USING g_fbc.fbc01
    IF STATUS THEN
       CALL cl_err("OPEN t107_cl:", STATUS, 1)
       CLOSE t107_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t107_cl INTO g_fbc.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbc.fbc01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t107_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
   UPDATE fbc_file SET fbcconf = 'Y' WHERE fbc01 = g_fbc.fbc01
     IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","fbc_file",g_fbc.fbc01,"",SQLCA.sqlcode,"","upd fbcconf",1)  #No.FUN-660136
        LET g_success = 'N'
     END IF
   CLOSE t107_cl
   IF g_success = 'Y' THEN
      LET g_fbc.fbcconf='Y'
      COMMIT WORK
      DISPLAY BY NAME g_fbc.fbcconf
      CALL cl_flow_notify(g_fbc.fbc01,'Y')
   ELSE
      LET g_fbc.fbcconf='N'
      ROLLBACK WORK
   END IF
   IF g_fbc.fbcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fbc.fbc08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbc.fbcconf,g_chr2,g_fbc.fbcpost,"",g_chr,"")
END FUNCTION
 
FUNCTION t107_y_chk()
  DEFINE l_fbd RECORD LIKE fbd_file.*   #TQC-780089
  DEFINE l_cnt LIKE type_file.num5         #No.FUN-680070 SMALLINT
  DEFINE l_sql   STRING                    #MOD-A30240 add
  DEFINE l_fbd04 LIKE fbd_file.fbd04       #MOD-A30240 add   
  DEFINE l_fbd05 LIKE fbd_file.fbd05       #MOD-A30240 add   
  DEFINE l_fbd09 LIKE fbd_file.fbd09       #MOD-A30240 add   
  DEFINE l_fbd10 LIKE fbd_file.fbd10       #MOD-A30240 add   
#FUN-AB0088---add---str---
  DEFINE l_fbd042 LIKE fbd_file.fbd042 
  DEFINE l_fbd052 LIKE fbd_file.fbd052
  DEFINE l_fbd092 LIKE fbd_file.fbd092  
  DEFINE l_fbd102 LIKE fbd_file.fbd102  
  DEFINE l_cnt1   LIKE type_file.num5
#FUN-AB0088---add---end---

 
  LET g_success = 'Y'              #FUN-580109
#CHI-C30107 --------------- add ---------------- begin
  IF g_fbc.fbcconf='Y' THEN
     LET g_success = 'N'          
     CALL cl_err('','9023',0)    
     RETURN
  END IF
  IF g_fbc.fbcpost='Y' THEN
     LET g_success = 'N'         
     CALL cl_err('fbcpost=Y:','afa-101',0)
     RETURN
  END IF
  IF g_faa.faa31 = "Y" THEN
     IF g_fbc.fbcpost1='Y' THEN
        LET g_success = 'N'
        CALL cl_err('fbcpost1=Y:','afa-101',0)
        RETURN
     END IF
  END IF
  IF g_fbc.fbcconf = 'X' THEN
     LET g_success = 'N'          
     CALL cl_err(' ','9024',0)
     RETURN
  END IF
  IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
      g_action_choice CLIPPED = "insert"   
  THEN
     IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF 
  END IF
#CHI-C30107 --------------- add ---------------- end
  SELECT * INTO g_fbc.* FROM fbc_file WHERE fbc01 = g_fbc.fbc01
  IF g_fbc.fbcconf='Y' THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('','9023',0)      #FUN-580109
     RETURN
  END IF
  IF g_fbc.fbcpost='Y' THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('fbcpost=Y:','afa-101',0)
     RETURN
  END IF
  #-----No:FUN-B60140-----
  IF g_faa.faa31 = "Y" THEN
     IF g_fbc.fbcpost1='Y' THEN
        LET g_success = 'N'
        CALL cl_err('fbcpost1=Y:','afa-101',0)
        RETURN
     END IF
  END IF
  #-----No:FUN-B60140 END-----
  IF g_fbc.fbcconf = 'X' THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err(' ','9024',0)
     RETURN
  END IF
  SELECT COUNT(*) INTO l_cnt FROM fbd_file
   WHERE fbd01= g_fbc.fbc01
  IF l_cnt = 0 THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('','mfg-009',0)
     RETURN
  END IF
 
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-->立帳日期小於關帳日期
  IF g_fbc.fbc02 < g_faa.faa09 THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err(g_fbc.fbc01,'aap-176',1)
     RETURN
  END IF
  #-----No:FUN-B60140-----
  IF g_faa.faa31 = "Y" THEN
     #-->立帳日期小於關帳日期
     IF g_fbc.fbc02 < g_faa.faa092 THEN
        LET g_success = 'N'
        CALL cl_err(g_fbc.fbc01,'aap-176',1)
        RETURN
     END IF
  END IF
  #-----No:FUN-B60140 END-----
  DECLARE t107_cur6 CURSOR FOR
     SELECT * FROM fbd_file WHERE fbd01=g_fbc.fbc01
  FOREACH t107_cur6 INTO l_fbd.*
     LET l_cnt = 0
     #No.MOD-AC0055  --Begin
     IF g_aza.aza26 <> '2' THEN
        SELECT COUNT(*) INTO l_cnt FROM fan_file
         WHERE fan01 = l_fbd.fbd03
           AND fan02 = l_fbd.fbd031
           AND (fan03 = g_yy AND fan04 >= g_mm OR fan03 > g_yy)
           AND fan041 = '1'   #MOD-C50044 add
#FUN-AB0088---add---str---
        LET l_cnt1 = 0
        IF g_faa.faa31 = 'Y' THEN
            SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
             WHERE fbn01 = l_fbd.fbd03
               AND fbn02 = l_fbd.fbd031
               AND (fbn03 = g_yy AND fbn04 >= g_mm OR fbn03 > g_yy)
               AND fbn041 = '1'   #MOD-C50044 add
        END IF
        LET l_cnt = l_cnt + l_cnt1
#FUN-AB0088---add---end---

        IF l_cnt > 0 THEN
           LET g_success = 'N'
           CALL cl_err(l_fbd.fbd03,'afa-348',0)
           RETURN
        END IF
        #-----CHI-860025---------
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM fao_file
         WHERE fao01 = l_fbd.fbd03
           AND fao02 = l_fbd.fbd031
           AND (fao03 = g_yy AND fao04 >= g_mm OR fao03 > g_yy)
           AND fao041 = '1'   #MOD-C50044 add
        IF l_cnt > 0 THEN
           LET g_success = 'N'
           CALL cl_err(l_fbd.fbd03,'afa-348',0)
           RETURN
        END IF
        #-----END CHI-860025-----
     ELSE
        SELECT COUNT(*) INTO l_cnt FROM fan_file
         WHERE fan01 = l_fbd.fbd03
           AND fan02 = l_fbd.fbd031
           AND (fan03 = g_yy AND fan04 > g_mm OR fan03 > g_yy)
           AND fan041 = '1'   #MOD-C50044 add
#FUN-AB0088---add---str---
        LET l_cnt1 = 0
        IF g_faa.faa31 ='Y' THEN
            SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
             WHERE fbn01 = l_fbd.fbd03
               AND fbn02 = l_fbd.fbd031
               AND (fbn03 = g_yy AND fbn04 > g_mm OR fbn03 > g_yy)
               AND fbn041 = '1'   #MOD-C50044 add
        END IF
        LET l_cnt = l_cnt + l_cnt1
#FUN-AB0088---add---end---

        IF l_cnt > 0 THEN
           LET g_success = 'N'
           CALL cl_err(l_fbd.fbd03,'afa-348',0)
           RETURN
        END IF
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM fao_file
         WHERE fao01 = l_fbd.fbd03
           AND fao02 = l_fbd.fbd031
           AND (fao03 = g_yy AND fao04 > g_mm OR fao03 > g_yy)
           AND fao041 = '1'   #MOD-C50044 add
        IF l_cnt > 0 THEN
           LET g_success = 'N'
           CALL cl_err(l_fbd.fbd03,'afa-348',0)
           RETURN
        END IF
     END IF
     #No.MOD-AC0055  --End  
  END FOREACH
 
  #----------------------------------- 檢查分錄底稿平衡正確否
  LET g_t1 = s_get_doc_no(g_fbc.fbc01)  #No.FUN-670060                                                                           
  SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1  #No.FUN-670060
  IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'N' THEN  #No.FUN-670060
    #MOD-A30240---modify---start---
    #CALL s_chknpq(g_fbc.fbc01,'FA',1,'0',g_bookno1)  #No.FUN-740033
    #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
    #   CALL s_chknpq(g_fbc.fbc01,'FA',1,'1',g_bookno2)  #No.FUN-740033
    #END IF
    #DECLARE t107_c CURSOR FOR SELECT fbd04,fbd05,fbd09,fbd10 FROM fbd_file WHERE fbd01=g_fbc.fbc01           #FUN-AB0088  mark                 
     DECLARE t107_c CURSOR FOR SELECT fbd04,fbd05,fbd09,fbd10,fbd042,fbd052,fbd092,fbd102 FROM fbd_file WHERE fbd01=g_fbc.fbc01   #FUN-AB0088
     FOREACH t107_c INTO l_fbd04,l_fbd05,l_fbd09,l_fbd10
                        ,l_fbd042,l_fbd052,l_fbd092,l_fbd102   #FUN-AB0088

         IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125 
         IF (l_fbd09 - l_fbd04=0) AND (l_fbd10 - l_fbd05 = 0) THEN
            CONTINUE FOREACH  
         ELSE
            CALL s_chknpq(g_fbc.fbc01,'FA',1,'0',g_bookno1) 
         END IF
        END IF #MOD-BC0125
#FUN-C30313---mark---START
#       #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN  #FUN-AB0088 mark
#        IF g_faa.faa31= 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN   #FUN-AB0088 #MOD-BC0125
#          #IF (l_fbd09 - l_fbd04=0) AND (l_fbd10 - l_fbd05 = 0) THEN       #FUN-AB0088 mark
#           IF (l_fbd092 - l_fbd042=0) AND (l_fbd102 - l_fbd052 = 0) THEN   #FUN-AB0088  add
#              CONTINUE FOREACH  
#           ELSE
#              CALL s_chknpq(g_fbc.fbc01,'FA',1,'1',g_bookno2) 
#           END IF
#        END IF
#FUN-C30313---mark---END
     END FOREACH
    #MOD-A30240---modify---end---
  END IF
#FUN-C30313---add---START-----
  IF g_faa.faa31= 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN   #FUN-AB0088 #MOD-BC0125
     IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'N' THEN
        DECLARE t107_c2 CURSOR FOR SELECT fbd042,fbd052,fbd092,fbd102 FROM fbd_file WHERE fbd01=g_fbc.fbc01
        FOREACH t107_c2 INTO l_fbd042,l_fbd052,l_fbd092,l_fbd102
          IF (l_fbd092 - l_fbd042=0) AND (l_fbd102 - l_fbd052 = 0) THEN   #FUN-AB0088  add
             CONTINUE FOREACH
          ELSE
             CALL s_chknpq(g_fbc.fbc01,'FA',1,'1',g_bookno2)
          END IF
        END FOREACH
     END IF
  END IF
#FUN-C30313---add---END-------
 
  IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t107_y_upd()
   DEFINE l_n    LIKE type_file.num10      #No.FUN-670060       #No.FUN-680070 INTEGER
   #CHI-B80007 -- begin --
   DEFINE l_fbd     RECORD LIKE fbd_file.*
   DEFINE l_msg     LIKE type_file.chr1000
   DEFINE l_cnt     LIKE type_file.num5
   #CHI-B80007 -- begin --
  
   LET g_success = 'Y'
   IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
      g_action_choice CLIPPED = "insert"     #FUN-640243
   THEN
      IF g_fbc.fbcmksg='Y'   THEN
          IF g_fbc.fbc08 != '1' THEN
             CALL cl_err('','aws-078',1)
             LET g_success = 'N'
             RETURN
          END IF
      END IF
#     IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   END IF
  
   BEGIN WORK
  
   OPEN t107_cl USING g_fbc.fbc01
   IF STATUS THEN
      CALL cl_err("OPEN t107_cl:", STATUS, 1)
      CLOSE t107_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t107_cl INTO g_fbc.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_fbc.fbc01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t107_cl ROLLBACK WORK RETURN
   END IF

   #CHI-B80007 -- begin --
   DECLARE t107_fbd_cur CURSOR FOR
      SELECT * FROM fbd_file WHERE fbd01=g_fbc.fbc01
   FOREACH t107_fbd_cur INTO l_fbd.*
      SELECT count(*) INTO l_cnt FROM fbd_file,fbc_file
       WHERE fbd01 = fbc01
         AND fbd03 = l_fbd.fbd03
         AND fbd031= l_fbd.fbd031 AND fbc02 <= g_fbc.fbc02
         AND fbcpost = 'N'
         AND fbc01 != g_fbc.fbc01
         AND fbcconf <> 'X'
      IF l_cnt  > 0 THEN
         LET l_msg = l_fbd.fbd01,' ',l_fbd.fbd02,' ',
                     l_fbd.fbd03,' ',l_fbd.fbd031
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
#  IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
#     SELECT count(*) INTO l_n FROM npq_file
#      WHERE npq01 = g_fbc.fbc01
#        AND npq011 = 1
#        AND npqsys = 'FA'
#        AND npq00 = 9
#     IF l_n = 0 THEN
#        CALL t107_gen_glcr(g_fbc.*,g_fah.*)
#     END IF
#     IF g_success = 'Y' THEN 
#         IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125 
#            CALL s_chknpq(g_fbc.fbc01,'FA',1,'0',g_bookno1)  #No.FUN-740033
#         END IF #MOD-BC0125
##        IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088   mark
#        IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN   #FUN-AB0088 #MOD-BC0125
#           CALL s_chknpq(g_fbc.fbc01,'FA',1,'1',g_bookno2)  #No.FUN-740033
#        END IF
#     END IF
#     IF g_success = 'N' THEN RETURN END IF    #No.FUN-680028
#  END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
      SELECT count(*) INTO l_n FROM npq_file
       WHERE npq01 = g_fbc.fbc01
         AND npq011 = 1
         AND npqsys = 'FA'
         AND npq00 = 9
     #IF l_n = 0 THEN                                                                     #MOD-C50255 mark
      IF l_n = 0 AND                                                                      #MOD-C50255 add
         ((g_fah.fahdmy3 = 'Y') OR (g_faa.faa31 = 'Y' AND g_fah.fahdmy32 = 'Y' )) THEN    #MOD-C50255 add
         CALL t107_gen_glcr(g_fbc.*,g_fah.*)
      END IF
      IF g_success = 'Y' THEN
         IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
            IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125
               CALL s_chknpq(g_fbc.fbc01,'FA',1,'0',g_bookno1)  #No.FUN-740033
            END IF #MOD-BC0125
         END IF
         IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN   #FUN-AB0088 #MOD-BC0125
            IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN
               CALL s_chknpq(g_fbc.fbc01,'FA',1,'1',g_bookno2)  #No.FUN-740033
            END IF
         END IF
      END IF
      IF g_success = 'N' THEN RETURN END IF    #No.FUN-680028
#FUN-C30313---add---END-------
   UPDATE fbc_file SET fbcconf = 'Y' WHERE fbc01 = g_fbc.fbc01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('fbc01',g_fbc.fbc01,'upd fbcconf',STATUS,1)    #No.FUN-710028
      LET g_success = 'N'
   END IF
  
   #-----No:FUN-B60140-----
   IF g_faa.faa31 = "Y" THEN
      LET g_t1 = s_get_doc_no(g_fbc.fbc01)
      SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
      IF g_fah.fahfa1 = "N" THEN
         UPDATE fbc_file SET fbcpost = 'X',fbcpost2='X' WHERE fbc01 = g_fbc.fbc01
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('fbc01',g_fbc.fbc01,'upd fbcpost',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
      IF g_fah.fahfa2 = "N" THEN
         UPDATE fbc_file SET fbcpost1= 'X' WHERE fbc01 = g_fbc.fbc01
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('fbc01',g_fbc.fbc01,'upd fbcpost1',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
      SELECT fbcpost,fbcpost1,fbcpost2
        INTO g_fbc.fbcpost,g_fbc.fbcpost1,g_fbc.fbcpost2
        FROM fbc_file
       WHERE fbc01 = g_fbc.fbc01
      DISPLAY BY NAME g_fbc.fbcpost,g_fbc.fbcpost1,g_fbc.fbcpost2
   END IF
   #-----No:FUN-B60140 END-----
   IF g_success = 'Y' THEN
      IF g_fbc.fbcmksg = 'Y' THEN #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
             WHEN 0  #呼叫 EasyFlow 簽核失敗
                  LET g_fbc.fbcconf="N"
                  LET g_success = "N"
                  ROLLBACK WORK
                  RETURN
             WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                  LET g_fbc.fbcconf="N"
                  ROLLBACK WORK
                  RETURN
         END CASE
      END IF
      CLOSE t107_cl
      CALL s_showmsg()   #No.FUN-710028 
      IF g_success = 'Y' THEN
         LET g_fbc.fbc08='1'      #執行成功, 狀態值顯示為 '1' 已核准
         UPDATE fbc_file SET fbc08 = g_fbc.fbc08 WHERE fbc01=g_fbc.fbc01
         IF SQLCA.sqlerrd[3]=0 THEN
            LET g_success='N'
         END IF
         LET g_fbc.fbcconf='Y'    #執行成功, 確認碼顯示為 'Y' 已確認
         COMMIT WORK
         DISPLAY BY NAME g_fbc.fbcconf
         DISPLAY BY NAME g_fbc.fbc08   #FUN-580109
         CALL cl_flow_notify(g_fbc.fbc01,'Y')
      ELSE
         LET g_fbc.fbcconf='N'
         LET g_success = 'N'   #FUN-580109
         ROLLBACK WORK
      END IF
   ELSE
      LET g_fbc.fbcconf='N'
      LET g_success = 'N'
      ROLLBACK WORK
   END IF

   IF g_fbc.fbcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fbc.fbc08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbc.fbcconf,g_chr2,g_fbc.fbcpost,"",g_chr,"")
 
END FUNCTION
 
FUNCTION t107_ef()
 
  CALL t107_y_chk()      #CALL 原確認的 check 段
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
 
  IF aws_efcli2(base.TypeInfo.create(g_fbc),base.TypeInfo.create(g_fbd),'','','','')
  THEN
     LET g_success='Y'
     LET g_fbc.fbc08='S'
     DISPLAY BY NAME g_fbc.fbc08
  ELSE
     LET g_success='N'
  END IF
 
END FUNCTION
 
FUNCTION t107_z() 	
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbc.fbc01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fbc.* FROM fbc_file WHERE fbc01 = g_fbc.fbc01
   IF g_fbc.fbc08  ='S' THEN CALL cl_err("","mfg3557",0) RETURN END IF   #FUN-580109
   IF g_fbc.fbcconf='N' THEN RETURN END IF
   IF g_fbc.fbcpost='Y' THEN
      CALL cl_err('fbcpost=Y:','afa-101',0)
      RETURN
   END IF
   
   #-----No:FUN-B60140-----
   IF g_faa.faa31 = "Y" THEN
      IF g_fbc.fbcpost1='Y' THEN
         CALL cl_err('fbcpost1=Y:','afa-101',0)
         RETURN
      END IF
   END IF
   #-----No:FUN-B60140 END-----
  
   IF g_fbc.fbcpost2='Y' THEN
       CALL cl_err('fbcpost2=Y:','afa-106',0)     #No.MOD-490339
      RETURN
   END IF
   #-->已拋轉總帳, 不可取消確認
   IF NOT cl_null(g_fbc.fbc06) THEN
      CALL cl_err(g_fbc.fbc06,'aap-145',1)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_fbc.fbc02 < g_faa.faa09 THEN
      CALL cl_err(g_fbc.fbc01,'aap-176',1) RETURN
   END IF
   
   #-----No:FUN-B60140-----
   IF g_faa.faa31 = "Y" THEN
      #-->已拋轉總帳, 不可取消確認
      IF NOT cl_null(g_fbc.fbc062) THEN
         CALL cl_err(g_fbc.fbc062,'aap-145',1)
         RETURN
      END IF
      #-->立帳日期不可小於關帳日期
      IF g_fbc.fbc02 < g_faa.faa092 THEN
         CALL cl_err(g_fbc.fbc01,'aap-176',1)
         RETURN
      END IF
   END IF
   #-----No:FUN-B60140 END-----

   
   IF g_fbc.fbcconf = 'X' THEN
      CALL cl_err(' ','9024',0)
      RETURN
   END IF

   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
    OPEN t107_cl USING g_fbc.fbc01
    IF STATUS THEN
       CALL cl_err("OPEN t107_cl:", STATUS, 1)
       CLOSE t107_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t107_cl INTO g_fbc.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbc.fbc01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t107_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
   UPDATE fbc_file SET fbcconf = 'N', fbc08 ='0'   #FUN-580109
    WHERE fbc01 = g_fbc.fbc01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","fbc_file",g_fbc.fbc01,"",SQLCA.sqlcode,"","upd_z fbcconf",1)  #No.FUN-660136
      LET g_success = 'N'
   END IF
   
   
   #-----No:FUN-B60140-----
  IF g_faa.faa31 = "Y" THEN
     LET g_t1 = s_get_doc_no(g_fbc.fbc01)
     SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
     IF g_fah.fahfa1 = "N" THEN
        UPDATE fbc_file SET fbcpost = 'N',fbcpost2='N' WHERE fbc01 = g_fbc.fbc01
        IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
           CALL s_errmsg('fbc01',g_fbc.fbc01,'upd fbcpost',STATUS,1)
           LET g_success = 'N'
        END IF
     END IF
     IF g_fah.fahfa2 = "N" THEN
        UPDATE fbc_file SET fbcpost1= 'N' WHERE fbc01 = g_fbc.fbc01
        IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
           CALL s_errmsg('fbc01',g_fbc.fbc01,'upd fbcpost1',STATUS,1)
           LET g_success = 'N'
        END IF
     END IF
     SELECT fbcpost,fbcpost1,fbcpost2
       INTO g_fbc.fbcpost,g_fbc.fbcpost1,g_fbc.fbcpost2
       FROM fbc_file
      WHERE fbc01 = g_fbc.fbc01
     DISPLAY BY NAME g_fbc.fbcpost,g_fbc.fbcpost1,g_fbc.fbcpost2
  END IF
  #-----No:FUN-B60140 END-----

   CLOSE t107_cl
   IF g_success = 'Y' THEN
      LET g_fbc.fbcconf='N'
      LET g_fbc.fbc08='0'   #FUN-580109
      COMMIT WORK
      DISPLAY BY NAME g_fbc.fbcconf
      DISPLAY BY NAME g_fbc.fbc08   #FUN-580109
   ELSE
      LET g_fbc.fbcconf='Y'
      ROLLBACK WORK
   END IF

   IF g_fbc.fbcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fbc.fbc08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbc.fbcconf,g_chr2,g_fbc.fbcpost,"",g_chr,"")
END FUNCTION
 
FUNCTION t107_s()
   DEFINE l_fbd       RECORD LIKE fbd_file.*,
          l_faj       RECORD LIKE faj_file.*,
          l_fap661    LIKE fap_file.fap661,
          l_fap55     LIKE fap_file.fap55,
          l_fbc02     LIKE fbc_file.fbc02,
          l_bdate,l_edate  LIKE type_file.dat,          #No.FUN-680070 DATE
          m_cost      LIKE type_file.num20,        #No.FUN-680070 DEC(15,0)
          m_faj24     LIKE faj_file.faj24,
          l_yy,l_mm   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_flag      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
          m_chr       LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
   DEFINE l_n         LIKE type_file.num5         #No.TQC-7B0060
   DEFINE l_cnt       LIKE type_file.num5  #No:FUN-B60140
#FUN-AB0088---add---str---
   DEFINE m_faj242    LIKE faj_file.faj242  
   DEFINE l_fap552    LIKE fap_file.fap552  
   DEFINE l_fap6612   LIKE fap_file.fap6612
#FUN-AB0088---add---end---   
   #CHI-CA0063--Begin--
   DEFINE g_fan        RECORD LIKE fan_file.*
   DEFINE g_fae        RECORD LIKE fae_file.*
   DEFINE m_fad05      LIKE fad_file.fad05,
          m_fad031     LIKE fad_file.fad031,
          m_fan07      LIKE fan_file.fan07, 
          m_fan14      LIKE fan_file.fan14, 
          m_fan17      LIKE fan_file.fan17,
          mm_fan07     LIKE fan_file.fan07,
          mm_fan14     LIKE fan_file.fan14,
          mm_fan17     LIKE fan_file.fan17,
          m_tot_fan07  LIKE fan_file.fan07, 
          m_tot_fan14  LIKE fan_file.fan14, 
          m_tot_fan17  LIKE fan_file.fan17,
          m_fae06      LIKE fae_file.fae06,
          m_fae08      LIKE fae_file.fae08,
          mm_fae08     LIKE fae_file.fae08,
          m_faa02b     LIKE aaa_file.aaa01,
          m_max_fae06  LIKE fae_file.fae06,
          m_tot        LIKE type_file.num20_6,
          m_aao        LIKE type_file.num20_6,
          m_ratio      LIKE type_file.num26_10,
          mm_ratio     LIKE type_file.num26_10,
          m_max_ratio  LIKE type_file.num26_10,
          g_fan07_year LIKE fan_file.fan07,
          g_fan07_all  LIKE fan_file.fan07,
          p_yy,p_mm    LIKE type_file.num5,
          l_fan07      LIKE fan_file.fan07,
          l_diff       LIKE fan_file.fan07,
          l_diff2      LIKE fan_file.fan07
   DEFINE l_cnt1       LIKE type_file.num5
   DEFINE l_aag04      LIKE aag_file.aag04
   #CHI-CA0063---End---
   DEFINE l_faj29      LIKE faj_file.faj29     #FUN-C90088
   DEFINE l_faj292     LIKE faj_file.faj292    #FUN-C90088
   DEFINE l_faj64      LIKE faj_file.faj64     #FUN-C90088
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbc.fbc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_fbc.* FROM fbc_file WHERE fbc01 = g_fbc.fbc01
   IF g_fbc.fbcconf != 'Y' OR g_fbc.fbcpost != 'N' THEN
      CALL cl_err(g_fbc.fbc01,'afa-100',1)   #MOD-910240 mod
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fbc.fbc02 < g_faa.faa09 THEN
      CALL cl_err(g_fbc.fbc01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-
   LET g_t1 = s_get_doc_no(g_fbc.fbc01)     #No.FUN-680028
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1     #No.FUN-680028
   #--->折舊年月判斷
   #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036
   #CHI-A60036 add --start--
   CALL s_get_bookno(g_faa.faa07)   
       RETURNING g_flag,g_bookno1,g_bookno2
   #FUN-AB0088---add---str---
   #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
   #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
   #FUN-AB0088---add---end--- 
#  IF g_aza.aza63 = 'Y' THEN
   IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088
      CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
   ELSE
      CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
   END IF
   #CHI-A60036 add --end--
   IF g_fbc.fbc02 < l_bdate OR g_fbc.fbc02 > l_edate THEN
      CALL cl_err(g_fbc.fbc02,'afa-308',1)   #MOD-910240 mod
      RETURN
   END IF
   LET l_yy = YEAR(g_fbc.fbc02)
   LET l_mm = MONTH(g_fbc.fbc02)
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK
 
    CALL s_yp(g_fbc.fbc02) RETURNING g_yy,g_mm   #MOD-870165
 
    OPEN t107_cl USING g_fbc.fbc01
    IF STATUS THEN
       CALL cl_err("OPEN t107_cl:", STATUS, 1)
       CLOSE t107_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t107_cl INTO g_fbc.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbc.fbc01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t107_cl ROLLBACK WORK RETURN
    END IF
    LET g_success = 'Y'
   DECLARE t107_cur2 CURSOR FOR
      SELECT * FROM fbd_file WHERE fbd01=g_fbc.fbc01
   CALL s_showmsg_init()     #No.FUN-710028
   FOREACH t107_cur2 INTO l_fbd.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('fbd01',g_fbc.fbc01,'foreach:',SQLCA.sqlcode,0)   #No.FUN-710028
         EXIT FOREACH
      END IF
      #------- 先找出對應之 faj_file 資料
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fbd.fbd03
                                            AND faj022=l_fbd.fbd031
 
      IF STATUS THEN
         CALL cl_err('sel faj',STATUS,0)
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
      LET l_fap661 = l_fbd.fbd09 - l_fbd.fbd04  #本幣成本
      LET l_fap55  = l_fbd.fbd10 - l_fbd.fbd05  #累折
      LET l_fap552 = l_fbd.fbd102 - l_fbd.fbd052  #FUN-AB0088 
      LET l_fap6612 = l_fbd.fbd092 - l_fbd.fbd042 #FUN-AB0088
      IF cl_null(l_fbd.fbd031) THEN
         LET l_fbd.fbd031 = ' '
      END IF
  
#FUN-AB0088---add---str---
      IF cl_null(l_faj.faj432) THEN LET l_faj.faj432 = ' ' END IF
      IF cl_null(l_faj.faj282) THEN LET l_faj.faj282 = ' ' END IF
      IF cl_null(l_faj.faj312) THEN LET l_faj.faj312 = 0 END IF
      IF cl_null(l_faj.faj142) THEN LET l_faj.faj142 = 0 END IF
      IF cl_null(l_faj.faj1412) THEN LET l_faj.faj1412 = 0 END IF
      IF cl_null(l_faj.faj332) THEN LET l_faj.faj332 = 0 END IF
      IF cl_null(l_faj.faj322) THEN LET l_faj.faj322 = 0 END IF
      IF cl_null(l_faj.faj232) THEN LET l_faj.faj232 = ' ' END IF
      IF cl_null(l_faj.faj592) THEN LET l_faj.faj592 = 0 END IF
      IF cl_null(l_faj.faj602) THEN LET l_faj.faj602 = 0 END IF
      IF cl_null(l_faj.faj342) THEN LET l_faj.faj342 =' ' END IF
      IF cl_null(l_faj.faj352) THEN LET l_faj.faj352 = 0 END IF
      IF cl_null(l_faj.faj312) THEN LET l_faj.faj312 = 0 END IF
#FUN-AB0088---add---end---

     #CHI-C60010---str---
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
      CALL cl_digcut(l_faj.faj3312,g_azi04_1) RETURNING l_faj.faj3312
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
      CALL cl_digcut(l_fap552,g_azi04_1) RETURNING l_fap552
      CALL cl_digcut(l_fap6612,g_azi04_1) RETURNING l_fap6612
      CALL cl_digcut(l_fbd.fbd042,g_azi04_1) RETURNING l_fbd.fbd042
      CALL cl_digcut(l_fbd.fbd092,g_azi04_1) RETURNING l_fbd.fbd092
     #CHI-C60010---end---
      #-----No:FUN-B60140-----
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fap_file
       WHERE fap50  = l_fbd.fbd01
         AND fap501 = l_fbd.fbd02
         AND fap03  = '9'              ## 異動代號
      #FUN-C90088--B--
      LET l_faj29  = 0
      LET l_faj292 = 0
      LET l_faj64  = 0
      LET l_faj29  = l_faj.faj29  + l_fbd.fbd11  - l_fbd.fbd06
      LET l_faj292 = l_faj.faj292 + l_fbd.fbd112 - l_fbd.fbd062
      LET l_faj64  = l_faj.faj64  + l_fbd.fbd21  - l_fbd.fbd16
      IF l_faj29  < 0 THEN LET l_faj29  = 0 END IF
      IF l_faj292 < 0 THEN LET l_faj292 = 0 END IF
      IF l_faj64  < 0 THEN LET l_faj64  = 0 END IF
      #FUN-C90088--E--
      IF l_cnt = 0 THEN   #無fap_file資料
      INSERT INTO fap_file (fap01,fap02,fap021,fap03,fap04,fap05,fap06,fap07,
                            fap08,fap09,fap10,fap101,fap11,fap12,fap13,fap14,
                            fap15,fap16,fap17,fap18,fap19,fap20,fap201,fap21,
                            fap22,fap23,fap24,fap25,fap26,fap30,fap31,fap32,
                            fap33,fap34,fap341,fap35,fap36,fap37,fap38,fap39,
                            fap40,fap41,fap50,fap501,fap661,fap55,fap52,fap53,fap54,             #No.MOD-A20122 add fap54
                            fap711,fap72,fap69,fap70,
                            fap121,fap131,fap141,fap77,fap56,  #CHI-9B0032 add fap77  #TQC-B30156 add fap56
                            #FUN-AB0088----add----str-----------      
                            fap052,fap062,fap072,fap082,
                            fap092,fap103,fap1012,fap112,  
                            fap152,fap162,fap212,fap222,
                            fap232,fap242,fap252,fap262,
                            fap522,fap532,fap542,fap552,
                            fap6612,fap562,fap772,  #No:FUN-B60140  
                            #FUN-AB0088---add----end-------------
                            fap83,fap832,fap84,   #FUN-C90088
                            fap93,fap932,fap94,   #FUN-C90088
                            faplegal)     #No.FUN-680028 #FUN-980003 add
      VALUES (l_faj.faj01,l_fbd.fbd03,l_fbd.fbd031,'9',
              g_fbc.fbc02,l_faj.faj43,l_faj.faj28,l_faj.faj30,
              l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33+l_faj.faj331,  #MOD-970231
              l_faj.faj32,l_faj.faj53,l_faj.faj54,l_faj.faj55,
              l_faj.faj23,l_faj.faj24,l_faj.faj20,l_faj.faj19,
              l_faj.faj21,l_faj.faj17,l_faj.faj171,l_faj.faj58,
              l_faj.faj59,l_faj.faj60,l_faj.faj34,l_faj.faj35,
              l_faj.faj36,l_faj.faj61,l_faj.faj65,l_faj.faj66,
              l_faj.faj62,l_faj.faj63,l_faj.faj68,l_faj.faj67,
              l_faj.faj69,l_faj.faj70,l_faj.faj71,l_faj.faj72,
              l_faj.faj73,l_faj.faj100,l_fbd.fbd01,l_fbd.fbd02,
              l_fap661,l_fap55,l_fbd.fbd11,l_fbd.fbd12,
              l_fbd.fbd09-l_fbd.fbd04-l_faj.faj141,              #No.MOD-A20122 add fap54
              0,0,l_fbd.fbd21,l_fbd.fbd22,
              l_faj.faj531,l_faj.faj541,l_faj.faj551,l_faj.faj43,0, #CHI-9B0032 add faj43  #TQC-B30156 add 0
              #FUN-AB0088----add----str-----------
              l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,
              l_faj.faj142,l_faj.faj1412,l_faj.faj332+l_faj.faj3312,l_faj.faj322,
              l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
              l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,
            # l_faj.faj302,l_faj.faj312,l_fbd.fbd092-l_fbd.fbd042-l_faj.faj1412, #No:FUN-B60140 #No:FUN-BA0112 mark
			  l_fbd.fbd112,l_fbd.fbd122,l_fbd.fbd092-l_fbd.fbd042-l_faj.faj1412, #No:FUN-BA0112 add 
              l_fap552,l_fap6612,0,l_faj.faj432,   #No:FUN-B60140
              #FUN-AB0088----add----end-----------
                 #fap83,fap832,fap84,   #FUN-C90088
                 #fap93,fap932,fap94,   #FUN-C90088
                 l_faj.faj29,l_faj.faj292,l_faj.faj64,  #FUN-C90088
                 l_faj29,l_faj292,l_faj64,              #FUN-C90088
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
                             fap52 = l_fbd.fbd11,
                             fap53 = l_fbd.fbd12,
                             fap54 = l_fbd.fbd09-l_fbd.fbd04-l_faj.faj141,  #TQC-BB0012 mod fbd02->fbd04
                             fap55 = l_fap55,
                             fap661= l_fap661,
                             fap56 = 0
                       WHERE fap50  = l_fbd.fbd01
                         AND fap501 = l_fbd.fbd02
                         AND fap03  = '9'              ## 異動代號
      END IF
      #-----No:FUN-B60140 END-----
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031,"/",'9',"/",g_fbc.fbc02     #No.FUN-710028        
         CALL s_errmsg('fap02,fap021,fap03,fap04',g_showmsg,'ins fap',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
      #--------- 過帳(3)update faj_file
      IF l_faj.faj43 = '7' THEN     #折畢再提
        UPDATE faj_file SET
               faj141 = (l_fbd.fbd09-l_fbd.fbd04),        #No.MOD-490181   #MOD-780022
               faj203 = faj203+(l_fbd.fbd10-l_fbd.fbd05),        #No.MOD-490181
               faj32  = l_fbd.fbd10,                             #累折
                      #本幣成本+調整成本-銷帳成本-累折+銷帳累折 = 未折減額
               faj33  = l_fbd.fbd09 -faj59 - (l_fbd.fbd10 - faj60),   #MOD-780022
               faj30  = l_fbd.fbd11,                             #未使用年限
               faj29  = l_faj29,                                 #FUN-C90088 耐用年限
               faj35  = l_fbd.fbd12,                             #預留殘值
               faj100 = g_fbc.fbc02
         WHERE faj02  = l_fbd.fbd03 AND faj022=l_fbd.fbd031
      ELSE
        UPDATE faj_file SET
               faj141 = (l_fbd.fbd09-l_fbd.fbd04),        #本幣成本 No.MOD-490181   #MOD-780022
               faj203 = faj203+(l_fbd.fbd10-l_fbd.fbd05),        #No.MOD-490181
               faj32  = l_fbd.fbd10,                             #累折
                      #本幣成本+調整成本-銷帳成本-累折+銷帳累折 = 未折減額
               faj33  = l_fbd.fbd09 -faj59 - (l_fbd.fbd10 - faj60),   #MOD-780022
               faj30  = l_fbd.fbd11,                             #未使用年限
               faj29  = l_faj29,                                 #FUN-C90088 耐用年限
               faj31  = l_fbd.fbd12,                             #預留殘值
               faj100 = g_fbc.fbc02
         WHERE faj02  = l_fbd.fbd03 AND faj022=l_fbd.fbd031
      END IF
       IF STATUS THEN             #No.MOD-490339
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF

##-----No:FUN-B60140 Mark-----
#FUN-AB0088---add---str---
#      IF g_faa.faa31 ='Y' THEN
#         IF l_faj.faj432 = '7' THEN    
#           UPDATE faj_file SET
#                  faj1412 = (l_fbd.fbd092-l_fbd.fbd042),        
#                  faj2032 = faj2032+(l_fbd.fbd102-l_fbd.fbd052), 
#                  faj322  = l_fbd.fbd102, 
#                  faj332  = l_fbd.fbd092 -faj592 - (l_fbd.fbd102 - faj602), 
#                  faj302  = l_fbd.fbd112,      
#                  faj352  = l_fbd.fbd122      
#            WHERE faj02   = l_fbd.fbd03 AND faj022=l_fbd.fbd031
#         ELSE
#           UPDATE faj_file SET
#                  faj1412 = (l_fbd.fbd092-l_fbd.fbd042),        
#                  faj2032 = faj2032+(l_fbd.fbd102-l_fbd.fbd052),       
#                  faj322  = l_fbd.fbd102,                       
#                  faj332  = l_fbd.fbd092 -faj592 - (l_fbd.fbd102 - faj602),
#                  faj302  = l_fbd.fbd112,          
#                  faj312  = l_fbd.fbd122          
#            WHERE faj02  = l_fbd.fbd03 AND faj022=l_fbd.fbd031
#         END IF
#         IF STATUS THEN            
#            LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031                 
#            CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)  
#            LET g_success = 'N'
#         END IF
#     END IF
#FUN-AB0088---add---end---     
##-----No:FUN-B60140 Mark END-----

      #No.MOD-AC0055  --Begin
      IF g_aza.aza26 <> '2' THEN
         #No.TQC-7B0060 --start--
         SELECT COUNT(*) INTO l_n FROM fan_file
          WHERE fan01 = l_fbd.fbd03
            AND fan02 = l_fbd.fbd031
            AND (fan03 = g_yy   #No.TQC-7B0060 l_yy -> g_yy
            AND fan04 >= g_mm   #No.TQC-7B0060 l_mm -> g_mm
             OR fan03 > g_yy )  #No.TQC-7B0060 l_yy -> g_yy
            AND fan041 = '1'    #MOD-D40098 add
         IF l_n > 0 THEN
            LET g_success = 'N'
            CALL cl_err('','afa-186',1)
         END IF
         #No.TQC-7B0060 --end--
      ELSE
         SELECT COUNT(*) INTO l_n FROM fan_file
          WHERE fan01 = l_fbd.fbd03
            AND fan02 = l_fbd.fbd031
            AND (fan03 = g_yy  AND fan04 > g_mm  OR fan03 > g_yy )
            AND fan041 = '1'    #MOD-D40098 add
         IF l_n > 0 THEN
            LET g_success = 'N'
            CALL cl_err('','afa-186',1)
         END IF
      END IF
      #No.MOD-AC0055  --End  

##-----No:FUN-B60140 Mark-----
#FUN-AB0088---add---str---
#     IF g_faa.faa31 = 'Y' THEN
#         IF g_aza.aza26 <> '2' THEN
#            SELECT COUNT(*) INTO l_n FROM fbn_file
#             WHERE fbn01 = l_fbd.fbd03
#               AND fbn02 = l_fbd.fbd031
#               AND (fbn03 = g_yy   #No.TQC-7B0060 l_yy -> g_yy
#               AND fbn04 >= g_mm  #No.TQC-7B0060 l_mm -> g_mm
#                OR fbn03 > g_yy )  #No.TQC-7B0060 l_yy -> g_yy
#            IF l_n > 0 THEN
#               LET g_success = 'N'
#               CALL cl_err('','afa-186',1)
#            END IF
#         ELSE
#            SELECT COUNT(*) INTO l_n FROM fbn_file
#             WHERE fbn01 = l_fbd.fbd03
#               AND fbn02 = l_fbd.fbd031
#               AND (fbn03 = g_yy  AND fbn04 > g_mm  OR fbn03 > g_yy )
#            IF l_n > 0 THEN
#               LET g_success = 'N'
#               CALL cl_err('','afa-186',1)
#            END IF
#         END IF
#         IF l_faj.faj232 = '1' THEN
#            LET m_faj242 = l_faj.faj242
#         ELSE
#            LET m_faj242 = l_faj.faj20
#         END IF
#         IF cl_null(l_fbd.fbd031) THEN
#            LET l_fbd.fbd031 = ' '
#         END IF
#         IF cl_null(m_faj242) THEN
#            LET m_faj242=' '
#         END IF
#     END IF
#FUN-AB0088---add---end---
##-----No:FUN-B60140 Mark END----- 
      IF l_faj.faj23 = '1' THEN
         LET m_faj24 = l_faj.faj24
      ELSE
         LET m_faj24 = l_faj.faj20
      END IF
      IF cl_null(l_fbd.fbd031) THEN
#        LET l_fbd.fbd031 = '   '        #No. MOD-B30201  Mark
         LET l_fbd.fbd031 = ' '        #No. MOD-B30201  add
      END IF
       IF cl_null(m_faj24) THEN
          LET m_faj24=' '
       END IF
       INSERT INTO fan_file(fan01,fan02,fan03,fan04,fan041,fan05,fan06, #No:BUG-470041 #No.MOD-470565
                           fan07,fan08,fan09,fan10,fan11,fan12,fan13,
                           fan14,fan15,fan16,fan17,fan18,
                           fan111,fan121,fan20,fan201,fanlegal)     #No.FUN-680028 #FUN-980003 add  #TQC-B20043 add fan20,fan201
           VALUES (l_fbd.fbd03,l_fbd.fbd031,g_yy,g_mm,'2',l_faj.faj23,  #No.TQC-7B0060 l_yy->g_yy l_mm->g_mm
                   m_faj24,l_fap55,0,' ',l_faj.faj43,l_faj.faj53,       #MOD-710116
                   l_faj.faj55,l_faj.faj24,0,0,1,l_faj.faj101,0,        #No.MOD-470565 
                   l_faj.faj531,l_faj.faj551,l_faj.faj54,l_faj.faj541,g_legal)     #No.FUN-680028 #FUN-980003 add  #TQC-B20043 add faj54,faj541
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031,"/",g_yy,"/",g_mm,"/",'2',"/",l_faj.faj23,"/",l_faj.faj55  #No.FUN-710028 #No.7B0060 l_yy->g_yy l_mm->g_mm
         CALL s_errmsg('fan01,fan02,fan03,fan04,fan041,fan05,fan06',g_showmsg,'ins fan',STATUS,1)                #No.FUN-710028
         LET g_success = 'N'
      END IF
     #CHI-CA0063--Begin--
      IF l_faj.faj23 = '2' THEN
         SELECT faa02b INTO m_faa02b FROM faa_file WHERE faa00='0'
         #-------- 折舊明細檔 SQL (針對多部門分攤折舊金額) ---------------
         LET g_sql="SELECT * FROM fan_file WHERE fan03='",g_yy,"'",
                 "                         AND fan04='",g_mm,"'",
                 "                         AND fan05='2' AND fan041 = '2' ",
                 "                         AND fan01='",l_fbd.fbd03,"'", 
                 "                         AND fan02='",l_fbd.fbd031,"'"
         PREPARE t107_pre1 FROM g_sql
         DECLARE t107_cur1 CURSOR WITH HOLD FOR t107_pre1
         FOREACH t107_cur1 INTO g_fan.*
            IF STATUS THEN
               LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031,"/",g_yy,"/",g_mm,"/",'2',"/",'2'
               CALL s_errmsg('fan01,fan02,fan03,fan04,fan041,fan05',g_showmsg,'foreach t107_cur1',STATUS,1)
               LET g_success = 'N'
               CONTINUE FOREACH
            END IF
            #-->讀取分攤方式
            SELECT fad05,fad03 INTO m_fad05,m_fad031 FROM fad_file
             WHERE fad01=g_fan.fan03 AND fad02=g_fan.fan04
               AND fad03=g_fan.fan11 AND fad04=g_fan.fan13
               AND fad07 = "1" 
            IF SQLCA.sqlcode THEN
               LET g_showmsg = g_fan.fan03,"/",g_fan.fan04,"/",g_fan.fan11,"/",g_fan.fan13
               CALL s_errmsg('fad01,fad02,fad03,fad04',g_showmsg,'','afa-152',1)  
               LET g_success='N'
               CONTINUE FOREACH
            END IF
            #-->讀取分母
            IF m_fad05='1' THEN
               SELECT SUM(fae08) INTO m_fae08 FROM fae_file
                 WHERE fae01=g_fan.fan03 AND fae02=g_fan.fan04
                   AND fae03=g_fan.fan11 AND fae04=g_fan.fan13
                   AND fae10 = "1"
               IF SQLCA.sqlcode OR cl_null(m_fae08) THEN 
                  LET g_showmsg = g_fan.fan03,"/",g_fan.fan04,"/",g_fan.fan11,"/",g_fan.fan13
                  CALL s_errmsg('fae01,fae02,fae03,fae04',g_showmsg,'','afa-152',1)  
                  LET g_success='N'
                  CONTINUE FOREACH 
               END IF
               LET mm_fae08 = m_fae08            # 分攤比率合計
            END IF
            #-->保留金額以便處理尾差
            LET mm_fan07=g_fan.fan07          # 被分攤金額
            LET mm_fan14=g_fan.fan14          # 被分攤成本
            LET mm_fan17=g_fan.fan17          # 被分攤減值 
            #------- 找 fae_file 分攤單身檔 ---------------
            LET m_tot=0  
            DECLARE t107_cur7 CURSOR WITH HOLD FOR
            SELECT * FROM fae_file
             WHERE fae01=g_fan.fan03 AND fae02=g_fan.fan04
               AND fae03=g_fan.fan11 AND fae04=g_fan.fan13
               AND fae10 = "1"
            FOREACH t107_cur7 INTO g_fae.*
               IF SQLCA.sqlcode OR (cl_null(m_fae08) AND m_fad05='1') THEN
                  LET g_showmsg = g_fan.fan03,"/",g_fan.fan04,"/",g_fan.fan11,"/",g_fan.fan13
                  CALL s_errmsg('fae01,fae02,fae03,fae04',g_showmsg,'','afa-152',1)
                  LET g_success='N'
                  CONTINUE FOREACH 
               END IF
               CASE m_fad05
                  WHEN '1'
                     LET l_cnt1 = 0
                     SELECT COUNT(*) INTO l_cnt1
                       FROM fan_file
                      WHERE fan01=g_fan.fan01 AND fan02=g_fan.fan02
                        AND fan03=g_fan.fan03 AND fan04=g_fan.fan04
                        AND fan06=g_fae.fae06 AND fan05='3'
                        AND fan041 = '2' 
                     LET mm_ratio=g_fae.fae08/mm_fae08*100     # 分攤比率(存入fan16用)
                     LET m_ratio=g_fae.fae08/m_fae08*100       # 分攤比率
                     LET m_fan07=mm_fan07*m_ratio/100          # 分攤金額
                     LET m_fan14=mm_fan14*m_ratio/100          # 分攤成本
                     LET m_fan17=mm_fan17*m_ratio/100          # 分攤減值 
                     LET m_fae08 = m_fae08 - g_fae.fae08       # 總分攤比率減少
                     LET m_fan07 = cl_digcut(m_fan07,g_azi04)
                     LET mm_fan07 = mm_fan07 - m_fan07         # 被分攤總數減少
                     LET m_fan14 = cl_digcut(m_fan14,g_azi04)
                     LET mm_fan14 = mm_fan14 - m_fan14         # 被分攤總數減少
                     LET m_fan17  = cl_digcut(m_fan17,g_azi04)  
                     LET mm_fan17 = mm_fan17 - m_fan17         # 被分攤總數減少
                     IF l_cnt1 > 0 THEN
                        UPDATE fan_file SET fan07 = m_fan07,
                                            fan09 = g_fan.fan06,
                                            fan12 = g_fae.fae07,
                                            fan14 = m_fan14,
                                            fan16 = mm_ratio,
                                            fan17 = m_fan17
                                      WHERE fan01 = g_fan.fan01 
                                        AND fan02 = g_fan.fan02 
                                        AND fan03 = g_fan.fan03 
                                        AND fan04 = g_fan.fan04 
                                        AND fan05 = '3'
                                        AND fan06 = g_fan.fan06 
                                        AND fan041 = '2'
                        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                           LET g_showmsg = g_fan.fan03,"/",g_fan.fan04,"/",g_fan.fan11,"/",g_fan.fan13
                           CALL s_errmsg('fae01,fae02,fae03,fae04',g_showmsg,'upd fan_file',STATUS,1)
                           LET g_success='N'
                           CONTINUE FOREACH 
                        END IF
                     ELSE
                        IF cl_null(g_fae.fae06) THEN LET g_fae.fae06=' ' END IF
                        INSERT INTO fan_file(fan01,fan02,fan03,fan04,fan041,   
                                             fan05,fan06,fan07,fan08,fan09,    
                                             fan10,fan11,fan12,fan13,fan14,    
                                             fan15,fan16,fan17,fan20,fan201,fanlegal)
                                      VALUES(g_fan.fan01,g_fan.fan02,          
                                             g_fan.fan03,g_fan.fan04,'2','3',  
                                             g_fae.fae06,m_fan07,0,       
                                             g_fan.fan06,l_faj.faj43,g_fan.fan11,   
                                             g_fae.fae07,g_fan.fan13,m_fan14,  
                                             0,mm_ratio,m_fan17,
                                             g_fan.fan20,g_fan.fan201,
                                             g_legal)
                        IF STATUS THEN
                           LET g_showmsg = g_fan.fan03,"/",g_fan.fan04,"/",g_fan.fan11,"/",g_fan.fan13
                           CALL s_errmsg('fae01,fae02,fae03,fae04',g_showmsg,'ins fan_file',STATUS,1)
                           LET g_success='N'
                           CONTINUE FOREACH 
                        END IF
                     END IF
                  WHEN '2'
                     LET l_aag04 = ''
                     SELECT aag04 INTO l_aag04 FROM aag_file
                      WHERE aag01=g_fae.fae09 AND aag00=g_bookno1
                     IF l_aag04='1' THEN
                        SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
                         WHERE aao00 =m_faa02b AND aao01=g_fae.fae09
                           AND aao02 =g_fae.fae06 AND aao03=g_yy
                           AND aao04<=g_mm
                     ELSE
                        SELECT aao05-aao06 INTO m_aao FROM aao_file
                         WHERE aao00=m_faa02b AND aao01=g_fae.fae09
                           AND aao02=g_fae.fae06 AND aao03=g_yy
                           AND aao04=g_mm
                     END IF
                     IF STATUS=100 OR m_aao IS NULL THEN LET m_aao=0 END IF
                     LET m_tot=m_tot+m_aao          ## 累加變動比率分母金額
               END CASE
            END FOREACH
           #----- 若為變動比率, 重新 foreach 一次 insert into fan_file -----------
            IF m_fad05='2' THEN
               LET m_max_ratio = 0
               LET m_max_fae06 =''
               FOREACH t107_cur7 INTO g_fae.*
                  LET l_aag04 = ''
                  SELECT aag04 INTO l_aag04 FROM aag_file
                   WHERE aag01=g_fae.fae09 AND aag00=g_bookno1
                  IF l_aag04='1' THEN
                     SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
                      WHERE aao00=m_faa02b AND aao01=g_fae.fae09
                        AND aao02=g_fae.fae06 AND aao03=g_yy AND aao04<=g_mm
                  ELSE
                     SELECT aao05-aao06 INTO m_aao FROM aao_file
                      WHERE aao00=m_faa02b AND aao01=g_fae.fae09
                        AND aao02=g_fae.fae06 AND aao03=g_yy AND aao04=g_mm
                  END IF
                  IF STATUS=100 OR m_aao IS NULL THEN
                     LET m_aao=0 
                  END IF
                  LET m_ratio = m_aao/m_tot*100
                  IF m_ratio > m_max_ratio THEN
                     LET m_max_fae06 = g_fae.fae06
                     LET m_max_ratio = m_ratio
                  END IF
                  LET m_fan07=g_fan.fan07*m_ratio/100
                  LET m_fan14=g_fan.fan14*m_ratio/100
                  LET m_fan17=g_fan.fan17*m_ratio/100   
                  LET m_fan07 = cl_digcut(m_fan07,g_azi04)
                  LET m_fan14 = cl_digcut(m_fan14,g_azi04)
                  LET m_fan17 = cl_digcut(m_fan17,g_azi04)
                  LET m_tot_fan07=m_tot_fan07+m_fan07
                  LET m_tot_fan14=m_tot_fan14+m_fan14
                  LET m_tot_fan17=m_tot_fan17+m_fan17  
                  SELECT COUNT(*) INTO g_cnt FROM fan_file
                   WHERE fan01=g_fan.fan01 AND fan02=g_fan.fan02
                     AND fan03=g_fan.fan03 AND fan04=g_fan.fan04
                     AND fan06=g_fae.fae06 AND fan05='3' AND fan041 = '2'
                  IF g_cnt>0 THEN
                     UPDATE fan_file SET fan07 = m_fan07,
                                         fan09 = g_fan.fan06,
                                         fan12 = g_fae.fae07,
                                         fan16 = m_ratio,
                                         fan17 = m_fan17
                      WHERE fan01=g_fan.fan01 AND fan02=g_fan.fan02
                        AND fan03=g_fan.fan03 AND fan04=g_fan.fan04
                        AND fan06=g_fae.fae06 AND fan05='3' AND fan041 = '2'
                     IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN  
                        LET g_showmsg = g_fan.fan03,"/",g_fan.fan04,"/",g_fan.fan11,"/",g_fan.fan13
                        CALL s_errmsg('fae01,fae02,fae03,fae04',g_showmsg,'upd fan_file',STATUS,1)
                        LET g_success='N'
                        CONTINUE FOREACH 
                     END IF
                  ELSE
                     IF cl_null(g_fae.fae06) THEN
                        LET g_fae.fae06=' '
                     END IF
                     INSERT INTO fan_file(fan01,fan02,fan03,fan04,fan041,fan05,      
                                          fan06,fan07,fan08,fan09,fan10,fan11,       
                                          fan12,fan13,fan14,fan15,fan16,fan17,
                                          fan20,fan201,fanlegal)
                                VALUES(g_fan.fan01,g_fan.fan02,g_fan.fan03,       
                                       g_fan.fan04,'2','3',g_fae.fae06,m_fan07,   
                                       0,g_fan.fan06,l_faj.faj43,g_fan.fan11,       
                                       g_fae.fae07,g_fan.fan13,m_fan14,0,   
                                       m_ratio,m_fan17,
                                       g_fan.fan20,g_fan.fan201,
                                       g_legal)
                     IF STATUS THEN
                        LET g_showmsg = g_fan.fan03,"/",g_fan.fan04,"/",g_fan.fan11,"/",g_fan.fan13
                        CALL s_errmsg('fae01,fae02,fae03,fae04',g_showmsg,'ins fan_file',STATUS,1)
                        LET g_success='N'
                        CONTINUE FOREACH 
                     END IF
                  END IF
               END FOREACH
               IF cl_null(m_max_fae06) THEN LET m_max_fae06=g_fae.fae06 END IF
            END IF
            IF m_fad05 = '2' THEN
               IF m_tot_fan07!=mm_fan07 OR m_tot_fan14!=mm_fan14 THEN          
                  LET m_fae06 = m_max_fae06
                  SELECT fan07 INTO l_fan07 from fan_file
                   WHERE fan01=g_fan.fan01 AND fan02=g_fan.fan02
                     AND fan03=tm.yy AND fan04=tm.mm AND fan06=m_fae06
                     AND fan05='3' 
                  LET l_diff = mm_fan07 - m_tot_fan07
                  IF l_diff < 0 THEN 
                     LET l_diff = l_diff * -1 
                     IF l_fan07 < l_diff THEN
                        LET l_diff = 0
	                 ELSE 
	                    LET l_diff = l_diff * -1 
	                 END IF
                  END IF 
     	          UPDATE fan_file SET fan07=fan07+l_diff,
	                	      fan14=fan14+mm_fan14-m_tot_fan14,
	                	      fan17=fan17+mm_fan17-m_tot_fan17 
                   WHERE fan01=g_fan.fan01 AND fan02=g_fan.fan02
                     AND fan03=g_yy AND fan04=g_mm AND fan06=m_fae06
                     AND fan05='3' 
	              IF STATUS OR SQLCA.sqlerrd[3]=0  THEN
	                 LET g_success='N' 
	                 CALL cl_err3("upd","fan_file",g_fan.fan01,g_fan.fan02,STATUS,"","upd fan",1)   
	                 EXIT FOREACH
	              END IF
	       END IF
	       LET m_tot_fan07=0
	       LET m_tot_fan14=0
	       LET m_tot_fan17=0        
	       LET m_tot=0
	    END IF
         END FOREACH
      END IF
     #CHI-CA0063---End---
     ##-----No:FUN-B60140 Mark-----
     #FUN-AB0088---add---str---
     #IF g_faa.faa31 = 'Y' THEN
     #    INSERT INTO fbn_file(fbn01,fbn02,fbn03,fbn04,fbn041,fbn05,fbn06, 
     #                         fbn07,fbn08,fbn09,fbn10,fbn11,fbn12,fbn13,
     #                         fbn14,fbn15,fbn16,fbn17)
     #         VALUES (l_fbd.fbd03,l_fbd.fbd031,g_yy,g_mm,'2',l_faj.faj232, 
     #                 m_faj242,l_fap552,0,' ',l_faj.faj432,l_faj.faj53,     
     #                 l_faj.faj55,l_faj.faj242,0,0,1,l_faj.faj1012)    
     #    IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
     #       LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031,"/",g_yy,"/",g_mm,"/",'2',"/",l_faj.faj23,"/",l_faj.faj55  #No.FUN-710028 #No.7B0060 l_yy->g_yy l_mm->g_mm
     #       CALL s_errmsg('fbn01,fbn02,fbn03,fbn04,fbn041,fbn05,fbn06',g_showmsg,'ins fbn',STATUS,1)                #No.FUN-710028
     #       LET g_success = 'N'
     #    END IF
     #END IF
      #FUN-AB0088---add---end---
      ##-----No:FUN-B60140 Mark-----

  
      IF g_success = 'Y' THEN
         UPDATE fbc_file SET fbcpost = 'Y' WHERE fbc01 = g_fbc.fbc01
          IF STATUS THEN                         #No.MOD-490181
            CALL s_errmsg('fbc01',g_fbc.fbc01,'upd post',STATUS,1)   #No.FUN-710028
            LET g_fbc.fbcpost='N'
            LET g_success = 'N'
         ELSE
            LET g_fbc.fbcpost='Y'
            LET g_success = 'Y'
            DISPLAY BY NAME g_fbc.fbcpost #
         END IF
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   CLOSE t107_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
      CALL cl_flow_notify(g_fbc.fbc01,'S')
   END IF
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_fbc.fbc01,'" AND npp011 = 1'
      LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_fbc.fbcuser,"' '",g_fbc.fbcuser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_fbc.fbc02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"   #No.FUN-680028   #MOD-860284
      CALL cl_cmdrun_wait(g_str)
      SELECT fbc06,fbc07 INTO g_fbc.fbc06,g_fbc.fbc07 FROM fbc_file
       WHERE fbc01 = g_fbc.fbc01
      DISPLAY BY NAME g_fbc.fbc06
      DISPLAY BY NAME g_fbc.fbc07
   END IF
   IF g_fbc.fbcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fbc.fbc08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbc.fbcconf,g_chr2,g_fbc.fbcpost,"",g_chr,"")
END FUNCTION
 
FUNCTION t107_6()
   DEFINE l_fbd       RECORD LIKE fbd_file.*,
          l_faj       RECORD LIKE faj_file.*,
       #  l_fap552    LIKE fap_file.fap552,    #FUN-B60140   Add #No:FUN-BA0112 mark 
       #  l_fap6612   LIKE fap_file.fap6612,   #FUN-B60140   Add #No:FUN-BA0112 mark
          l_fap661    LIKE fap_file.fap661,
          l_fap55     LIKE fap_file.fap55,
          l_fap711    LIKE fap_file.fap711,
          l_fap72     LIKE fap_file.fap72,
          l_fbc02     LIKE fbc_file.fbc02,
          l_faj67     LIKE faj_file.faj67,
          l_faj68     LIKE faj_file.faj68,
          l_faj62     LIKE faj_file.faj62,
          l_faj65     LIKE faj_file.faj65,
          l_faj66     LIKE faj_file.faj66,
          l_faj43     LIKE faj_file.faj43,
          l_bdate,l_edate  LIKE type_file.dat,    #No.FUN-680070 DATE
          l_flag      LIKE type_file.chr1,        #No.FUN-680070 VARCHAR(01)
          l_yy,l_mm   LIKE type_file.num5,        #No.FUN-680070 SMALLINT
          m_chr       LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
   DEFINE l_n         LIKE type_file.num5,        #MOD-910240 add
          m_faj24     LIKE faj_file.faj24         #MOD-910240 add
   DEFINE l_cnt       LIKE type_file.num5  #No:FUN-B60140
   DEFINE l_faj29     LIKE faj_file.faj29         #FUN-C90088
   DEFINE l_faj292    LIKE faj_file.faj292        #FUN-C90088
   DEFINE l_faj64     LIKE faj_file.faj64         #FUN-C90088
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbc.fbc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_fbc.* FROM fbc_file WHERE fbc01 = g_fbc.fbc01
  # IF g_fbc.fbcconf != 'Y' OR g_fbc.fbcpost != 'Y' OR g_fbc.fbcpost2!= 'N' THEN   #FUN-580109
    IF g_fbc.fbcconf != 'Y' OR g_fbc.fbcpost2!= 'N' THEN   #FUN-580109  #No:FUN-B60140
       CALL cl_err(g_fbc.fbc01,'afa-028',1)   #No.MOD-490339   #MOD-910240 mod
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa13 INTO g_faa.faa13 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #--->折舊年月判斷
   IF g_fbc.fbc02 < g_faa.faa13 THEN
      CALL cl_err(g_fbc.fbc02,'afa-308',1)   #MOD-910240 mod
      RETURN
   END IF
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK
 
    OPEN t107_cl USING g_fbc.fbc01
    IF STATUS THEN
       CALL cl_err("OPEN t107_cl:", STATUS, 1)
       CLOSE t107_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t107_cl INTO g_fbc.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbc.fbc01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t107_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
   DECLARE t107_cur21 CURSOR FOR
      SELECT * FROM fbd_file WHERE fbd01=g_fbc.fbc01
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t107_cur21 INTO l_fbd.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('fbd01',g_fbc.fbc01,'foreach:',SQLCA.sqlcode,0)  #No.FUN-710028
         EXIT FOREACH
      END IF
      LET l_fap711 = l_fbd.fbd19 - l_fbd.fbd14  #稅簽本幣成本
      LET l_fap72  = l_fbd.fbd20 - l_fbd.fbd15  #    累折
      
      #-----No:FUN-B60140-----
      #------- 先找出對應之 faj_file 資料
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fbd.fbd03
                                            AND faj022=l_fbd.fbd031
      #SELECT faj43,faj67,faj68,faj65,faj66,faj62
      #  INTO l_faj43,l_faj67,l_faj68,l_faj65,l_faj66,l_faj62
      #  FROM faj_file
      #  WHERE faj02 = l_fbd.fbd03 AND faj022 = l_fbd.fbd031
      ##-----No:FUN-B60140 END-----
      
      IF SQLCA.sqlcode THEN
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
         CONTINUE FOREACH  #No.FUN-710028
      END IF
     
  #   LET l_fap552 = l_fbd.fbd102 - l_fbd.fbd052     #FUN-B60140    Add #No:FUN-BA0112 mark
  #   LET l_fap6612 = l_fbd.fbd092 - l_fbd.fbd042    #FUN-B60140    Add	#No:FUN-BA0112 mark

     #CHI-C60010---str---
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
      CALL cl_digcut(l_fbd.fbd122,g_azi04_1) RETURNING l_fbd.fbd122
      CALL cl_digcut(l_fbd.fbd092,g_azi04_1) RETURNING l_fbd.fbd092
      CALL cl_digcut(l_fbd.fbd042,g_azi04_1) RETURNING l_fbd.fbd042
     #CHI-C60010---end---
      #-----No:FUN-B60140-----
      #--->(1.1)更新稅簽異動檔
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fap_file
       WHERE fap50  = l_fbd.fbd01
         AND fap501 = l_fbd.fbd02
         AND fap03  = '9'              ## 異動代號
      #FUN-C90088--B--
      LET l_faj29  = 0
      LET l_faj292 = 0
      LET l_faj64  = 0
      LET l_faj29  = l_faj.faj29  + l_fbd.fbd11  - l_fbd.fbd06
      LET l_faj292 = l_faj.faj292 + l_fbd.fbd112 - l_fbd.fbd062
      LET l_faj64  = l_faj.faj64  + l_fbd.fbd21  - l_fbd.fbd16
      IF l_faj29  < 0 THEN LET l_faj29  = 0 END IF
      IF l_faj292 < 0 THEN LET l_faj292 = 0 END IF
      IF l_faj64  < 0 THEN LET l_faj64  = 0 END IF
      #FUN-C90088--E--
      IF l_cnt = 0 THEN   #無fap_file資料
        #-----------------------------------MOD-C70198-----------------------------(S)
        #--MOD-C70198--mark
        #INSERT INTO fap_file (fap01,fap02,fap021,fap03,fap04,fap05,fap06,fap07,
        #                      fap08,fap09,fap10,fap101,fap11,fap12,fap13,fap14,
        #                      fap15,fap16,fap17,fap18,fap19,fap20,fap201,fap21,
        #                      fap22,fap23,fap24,fap25,fap26,fap30,fap31,fap32,
        #                      fap33,fap34,fap341,fap35,fap36,fap37,fap38,fap39,
        #                      fap40,fap41,fap50,fap501,fap661,fap55,fap52,fap53,fap54,    #No.MO
        #                      fap711,fap72,fap69,fap70,fap71,                             #CHI-9B0015 add fap71
        #                      fap121,fap131,fap141,fap77,                                 #No.FUN-680028  #CHI-9B0032 add fap77
        #                      
        #                      fap052,fap062,fap072,fap082,
        #                     #fap092,fap102,fap1012,fap112,
        #                      fap092,fap103,fap1012,fap112,   #No:FUN-B30036
        #                      fap152,fap162,fap212,fap222,
        #                      fap232,fap242,fap252,fap262,
        #                      fap522,fap532,fap542,fap552,
        #                      fap6612,fap56,fap562,fap772,faplegal)  #No:FUN-B60140
        #                     
        #VALUES (l_faj.faj01,l_fbd.fbd03,l_fbd.fbd031,'9',
        #        g_fbc.fbc02,l_faj.faj43,l_faj.faj28,l_faj.faj30,
        #        l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33,               #MOD-970231 mark
        #        l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33+l_faj.faj331,  #MOD-970231
        #        l_faj.faj32,l_faj.faj53,l_faj.faj54,l_faj.faj55,
        #        l_faj.faj23,l_faj.faj24,l_faj.faj20,l_faj.faj19,
        #        l_faj.faj21,l_faj.faj17,l_faj.faj171,l_faj.faj58,
        #        l_faj.faj59,l_faj.faj60,l_faj.faj34,l_faj.faj35,
        #        l_faj.faj36,l_faj.faj61,l_faj.faj65,l_faj.faj66,
        #        l_faj.faj62,l_faj.faj63,l_faj.faj68,l_faj.faj67,
        #        l_faj.faj69,l_faj.faj70,l_faj.faj71,l_faj.faj72,
        #        l_faj.faj73,l_faj.faj100,l_fbd.fbd01,l_fbd.fbd02,
        #        l_fap661,l_fap55,l_fbd.fbd11,l_fbd.fbd12,
        #        l_fbd.fbd09-l_fbd.fbd04-l_faj.faj141,               #No.MOD-A20122 add fap54
        #        0,0,l_fbd.fbd21,l_fbd.fbd22,l_fbd.fbd19,   #CHI-9B0015 add l_fbd.fbd19
        #        l_faj.faj531,l_faj.faj541,l_faj.faj551,l_faj.faj43  #No.FUN-680028  #CHI-9B0032
        #        
        #       ,l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,
        #        l_faj.faj142,l_faj.faj1412,l_faj.faj332+l_faj.faj3312,l_faj.faj322,
        #        l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
        #        l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,
        #        l_fbd.fbd112,l_fbd.fbd122,l_fbd.fbd092-l_fbd.fbd042-l_faj.faj1412,  #No:FUN-B60140
        #   #    l_fap552,l_fap6612,0,0,l_faj.faj432,g_legal)  #No:FUN-B60140      #TQC-B30156 add 0   #MOD-C30747 MARK
        #        0,0,0,0,l_faj.faj432,g_legal)   #MOD-C30747 add
        #--MOD-C70198--mark
         INSERT INTO fap_file (fap01,fap02,fap021,fap03,fap04,
                               fap05,fap06,fap07,fap08,fap09,
                               fap10,fap101,fap11,fap12,fap13,
                               fap14,fap15,fap16,fap17,fap18,
                               fap19,fap20,fap201,fap21,fap22,
                               fap23,fap24,fap25,fap26,fap30,
                               fap31,fap32,fap33,fap34,fap341,
                               fap35,fap36,fap37,fap38,fap39,
                               fap40,fap41,fap50,fap501,fap661,
                               fap55,fap52,fap53,fap54,fap711,
                               fap72,fap69,fap70,fap71,fap121,
                               fap131,fap141,fap77,fap052,fap062,
                               fap072,fap082,fap092,fap103,fap1012,
                               fap112,fap152,fap162,fap212,fap222,
                               fap232,fap242,fap252,fap262,fap522,
                               fap532,fap542,fap552,fap6612,fap56,
                               fap562,fap772,faplegal
                              ,fap83,fap832,fap84,   #FUN-C90088
                               fap93,fap932,fap94    #FUN-C90088
                               )                  
         VALUES (l_faj.faj01,l_fbd.fbd03,l_fbd.fbd031,'9',g_fbc.fbc02,
                 l_faj.faj43,l_faj.faj28,l_faj.faj30,l_faj.faj31,l_faj.faj14,
                 l_faj.faj141,l_faj.faj33+l_faj.faj331,l_faj.faj32,l_faj.faj53,l_faj.faj54,
                 l_faj.faj55,l_faj.faj23,l_faj.faj24,l_faj.faj20,l_faj.faj19,
                 l_faj.faj21,l_faj.faj17,l_faj.faj171,l_faj.faj58,l_faj.faj59,
                 l_faj.faj60,l_faj.faj34,l_faj.faj35,l_faj.faj36,l_faj.faj61,
                 l_faj.faj65,l_faj.faj66,l_faj.faj62,l_faj.faj63,l_faj.faj68,
                 l_faj.faj67,l_faj.faj69,l_faj.faj70,l_faj.faj71,l_faj.faj72,
                 l_faj.faj73,l_faj.faj100,l_fbd.fbd01,l_fbd.fbd02,l_fap661,
                 l_fap55,l_fbd.fbd11,l_fbd.fbd12,l_fbd.fbd09-l_fbd.fbd04-l_faj.faj141,l_fap711,   #MOD-C70198 0 mod l_fap711
                 0,l_fbd.fbd21,l_fbd.fbd22,l_fbd.fbd19,l_faj.faj531,
                 l_faj.faj541,l_faj.faj551,l_faj.faj43,l_faj.faj432,l_faj.faj282,
                 l_faj.faj302,l_faj.faj312,l_faj.faj142,l_faj.faj1412,l_faj.faj332+l_faj.faj3312,
                 l_faj.faj322,l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
                 l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,l_fbd.fbd112,
                 l_fbd.fbd122,l_fbd.fbd092-l_fbd.fbd042-l_faj.faj1412,0,0,0,
                 0,l_faj.faj432,g_legal
                ,l_faj.faj29,l_faj.faj292,l_faj.faj64,  #FUN-C90088
                 l_faj29,l_faj292,l_faj64               #FUN-C90088
                 )                             
        #-----------------------------------MOD-C70198-----------------------------(E)
                 
    ELSE
      UPDATE fap_file SET fap711 = l_fap711,
                          fap72  = l_fap72,
                          #  fap33  = l_faj62,                  #稅簽成本 #No:FUN-B60140 #No:FUN-BA0112 mark
                          #  fap35  = l_faj67,                  #累折     #No:FUN-B60140 #No:FUN-BA0112 mark
                          #  fap341 = l_faj68,                  #未折減額 #No:FUN-B60140 #No:FUN-BA0112 mark
                          #  fap31  = l_faj65,                  #未使用年限 #No:FUN-B60140 #No:FUN-BA0112 mark
                          #  fap32  = l_faj66                   #預留殘值   #No:FUN-B60140 #No:FUN-BA0112 mark
                             fap33  = l_faj.faj62,              #稅簽成本   #No:FUN-BA0112 add
                             fap35  = l_faj.faj67,              #累折       #No:FUN-BA0112 add
                             fap341 = l_faj.faj68,              #未折減額    #No:FUN-BA0112 add
                             fap31  = l_faj.faj65,              #未使用年限  #No:FUN-BA0112 add
                             fap32  = l_faj.faj66               #預留殘值    #No:FUN-BA0112 add
                         WHERE fap50 = g_fbc.fbc01
                           AND fap501= l_fbd.fbd02
                           AND fap03 = '9'
      END IF
      #-----No:FUN-B60140 END-----
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = g_fbc.fbc01,"/",l_fbd.fbd02,"/",'9'               #No.FUN-710028
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'upd fap',STATUS,1)  #No.FUN-710028
         LET g_success = 'N'
         CONTINUE FOREACH  #No.FUN-710028
      END IF
      #--->(1.2)更新資產主檔
      IF l_faj43 = '7' THEN    #折畢再提
         UPDATE faj_file SET
               #faj62  = l_fbd.fbd19,                       #稅簽成本 #MOD-C70198 mark
                faj205 = faj205+(l_fbd.fbd20-l_fbd.fbd15),  #本期累折  #MOD-930246 add
                faj67  = l_fbd.fbd20,                       #累折
               #faj68  = l_fbd.fbd19 + faj63 - faj69 -      #未折減額 #MOD-C70198 mark
                faj68  = l_fbd.fbd19 - faj69 -              #未折減額 #MOD-C70198 add
                         (l_fbd.fbd20 - faj70),
                faj65  = l_fbd.fbd21,                       #未使用年限
                faj64  = l_faj64,                           #耐用年限 #FUN-C90088
                faj72  = l_fbd.fbd22,                       #預留殘值
                faj63  = l_fap711                           #MOD-C70198 add
          WHERE faj02  = l_fbd.fbd03 AND faj022=l_fbd.fbd031
      ELSE
         UPDATE faj_file SET
               #faj62  = l_fbd.fbd19,                       #稅簽成本 #MOD-C70198 mark
                faj205 = faj205+(l_fbd.fbd20-l_fbd.fbd15),  #本期累折  #MOD-930246 add
                faj67  = l_fbd.fbd20,                       #累折
               #faj68  = l_fbd.fbd19 + faj63 - faj69 -      #未折減額 #MOD-C70198 mark
                faj68  = l_fbd.fbd19 - faj69 -              #未折減額 #MOD-C70198 add
                         (l_fbd.fbd20 - faj70),
                faj65  = l_fbd.fbd21,                       #未使用年限
                faj64  = l_faj64,                           #耐用年限 #FUN-C90088
                faj66  = l_fbd.fbd22,                       #預留殘值
                faj63  = l_fap711                           #MOD-C70198 add
          WHERE faj02  = l_fbd.fbd03 AND faj022=l_fbd.fbd031
      END IF
       IF STATUS THEN            #No.MOD-490181  
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
      #------- 先找出對應之 faj_file 資料
      SELECT * INTO l_faj.*  FROM faj_file WHERE faj02=l_fbd.fbd03
                                             AND faj022=l_fbd.fbd031
      IF STATUS THEN
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)
         LET g_success = 'N'
      END IF
      #No.MOD-AC0055  --Begin
      IF g_aza.aza26 <> '2' THEN
         SELECT COUNT(*) INTO l_n FROM fao_file
          WHERE fao01 = l_fbd.fbd03
            AND fao02 = l_fbd.fbd031
            AND (fao03 = g_yy
            AND fao04 >= g_mm
             OR fao03 > g_yy)
            AND fao041 = '1'    #MOD-D40098 add
         IF l_n > 0 THEN
            LET g_success = 'N'
            CALL cl_err('','afa-186',1)
         END IF
      ELSE
         SELECT COUNT(*) INTO l_n FROM fao_file
          WHERE fao01 = l_fbd.fbd03
            AND fao02 = l_fbd.fbd031
            AND (fao03 = g_yy AND fao04 > g_mm OR fao03 > g_yy)
            AND fao041 = '1'    #MOD-D40098 add
         IF l_n > 0 THEN
            LET g_success = 'N'
            CALL cl_err('','afa-186',1)
         END IF
      END IF
      #No.MOD-AC0055  --End  

      IF l_faj.faj23 = '1' THEN
         LET m_faj24 = l_faj.faj24
      ELSE
         LET m_faj24 = l_faj.faj20
      END IF
      IF cl_null(l_fbd.fbd031) THEN
         LET l_fbd.fbd031 = ' '
      END IF
      IF cl_null(m_faj24) THEN
         LET m_faj24=' '
      END IF
      LET l_fap72  = l_fbd.fbd20 - l_fbd.fbd15  #    累折
      INSERT INTO fao_file(fao01,fao02,fao03,fao04,fao041,fao05,fao06,
                           fao07,fao08,fao09,fao10,fao11,fao12,fao20,fao13,   #TQC-B20074 add fao20
                           fao14,fao15,fao16,fao17,fao18,
                           fao111,fao121,fao201,faolegal)   #FUN-980003 add   #TQC-B20074 add fao201
          VALUES (l_fbd.fbd03,l_fbd.fbd031,g_yy,g_mm,'2',l_faj.faj23,
                  m_faj24,l_fap72,0,' ',l_faj.faj43,l_faj.faj53,
                  l_faj.faj55,l_faj.faj54,l_faj.faj24,0,0,1,l_faj.faj101,0,   #TQC-B20074 add faj54
                  l_faj.faj531,l_faj.faj551,l_faj.faj541,g_legal) #FUN-980003 add  #TQC-B20074 add faj541
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031,"/",g_yy,"/",g_mm,"/",'2',"/",l_faj.faj23,"/",l_faj.faj55
         CALL s_errmsg('fao01,fao02,fao03,fao04,fao041,fao05,fao06',g_showmsg,'ins fao',STATUS,1)
         LET g_success = 'N'
      END IF
      IF g_success = 'Y' THEN
         UPDATE fbc_file SET fbcpost2 = 'Y' WHERE fbc01 = g_fbc.fbc01
          IF STATUS THEN            #No.MOD-490181
            CALL s_errmsg('fbc01',g_fbc.fbc01,'upd post2',STATUS,1)   #No.FUN-710028
            LET g_fbc.fbcpost2='N'
            LET g_success = 'N'
         ELSE
            LET g_fbc.fbcpost2='Y'
            LET g_success = 'Y'
            DISPLAY BY NAME g_fbc.fbcpost2 #
         END IF
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   CLOSE t107_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
END FUNCTION
 
FUNCTION t107_w()
   DEFINE l_fbd    RECORD LIKE fbd_file.*,
          l_faj    RECORD LIKE faj_file.*,
          l_fap    RECORD LIKE fap_file.*,
          l_fap10  LIKE fap_file.fap10,           #No.MOD-490181
          l_fap11  LIKE fap_file.fap11,
          l_fap101 LIKE fap_file.fap101,
          l_fap07  LIKE fap_file.fap07,
          l_fap08  LIKE fap_file.fap08,
          l_fap41  LIKE fap_file.fap41,
          l_bdate,l_edate  LIKE type_file.dat,          #No.FUN-680070 DATE
          l_cnt    LIKE type_file.num5   #TQC-780089
   DEFINE l_aba19  LIKE aba_file.aba19     #No.FUN-680028
   DEFINE l_sql    LIKE type_file.chr1000             #No.FUN-680028       #No.FUN-680070 VARCHAR(1000)
   DEFINE l_dbs    STRING                  #No.FUN-680028
   DEFINE l_fan041 LIKE fan_file.fan041    #No.TQC-7B0060
#FUN-AB0088---add---str---
   DEFINE l_fap103 LIKE fap_file.fap103 
   DEFINE l_fap112 LIKE fap_file.fap112
   DEFINE l_fap1012 LIKE fap_file.fap1012
   DEFINE l_fap072 LIKE fap_file.fap072
   DEFINE l_fap082 LIKE fap_file.fap082
   DEFINE l_cnt1   LIKE type_file.num5
   DEFINE l_fbn041 LIKE fbn_file.fbn041
#FUN-AB0088---add---end---
   DEFINE l_fap83  LIKE fap_file.fap83     #FUN-C90088
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbc.fbc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_fbc.* FROM fbc_file WHERE fbc01 = g_fbc.fbc01
   IF g_fbc.fbcpost != 'Y' THEN
      CALL cl_err(g_fbc.fbc01,'afa-108',1)   #MOD-910240 mod
      RETURN
   END IF
   #-->已拋轉總帳, 不可取消確認
   IF NOT cl_null(g_fbc.fbc06) AND g_fah.fahglcr = 'N' THEN     #No.FUN-680028
      CALL cl_err(g_fbc.fbc06,'aap-145',1)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fbc.fbc02 < g_faa.faa09 THEN
      CALL cl_err(g_fbc.fbc01,'aap-176',1) RETURN
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
   IF g_faa.faa31 = 'Y' THEN   #FUN-AB0088 add
      CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
   ELSE
      CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
   END IF
   #CHI-A60036 add --end--
   IF g_fbc.fbc02 < l_bdate OR g_fbc.fbc02 > l_edate THEN
      CALL cl_err(g_fbc.fbc02,'afa-308',1)   #MOD-910240 mod
      RETURN
   END IF
   DECLARE t107_cur4 CURSOR FOR
      SELECT * FROM fbd_file WHERE fbd01=g_fbc.fbc01
   FOREACH t107_cur4 INTO l_fbd.*
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fan_file
       WHERE fan01 = l_fbd.fbd03
         AND fan02 = l_fbd.fbd031
         AND (fan03 = g_yy AND fan04 > g_mm OR fan03 > g_yy)  #No.MOD-AC0055
         AND fan041 = '1'   #MOD-C50044 add
   ##-----No:FUN-B60140 Mark-----
   #FUN-AB0088---add---str---
   #  IF g_faa.faa31 = 'Y' THEN
   #      LET l_cnt1 = 0
   #      SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
   #       WHERE fbn01 = l_fbd.fbd03
   #         AND fbn02 = l_fbd.fbd031
   #         AND (fan03 = g_yy AND fan04 > g_mm OR fan03 > g_yy)   #No.MOD-AC0055
   #  END IF
   #  LET l_cnt = l_cnt + l_cnt1
   #FUN-AB0088---add---end---
   ##-----No:FUN-B60140 Mark-----
      IF l_cnt > 0 THEN
         CALL cl_err(l_fbd.fbd03,'afa-348',1)   #MOD-910240 mod
         RETURN
      END IF
      IF g_aza.aza26 <> '2' THEN                #No.MOD-AC0055
         SELECT COUNT(*) INTO l_cnt FROM fan_file
          WHERE fan01 = l_fbd.fbd03
            AND fan02 = l_fbd.fbd031
            AND fan03 = g_yy AND fan04 = g_mm
            AND fan041 = '1'   #MOD-C50044 add      
     ##-----No:FUN-B60140 Mark-----
     #FUN-AB0088---add---str---
     #   IF g_faa.faa31 = 'Y' THEN
     #       LET l_cnt1 = 0
     #       SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
     #        WHERE fbn01 = l_fbd.fbd03
     #          AND fbn02 = l_fbd.fbd031
     #          AND fbn03 = g_yy AND fbn04 = g_mm
     #   END IF
     #   LET l_cnt = l_cnt + l_cnt1
     #FUN-AB0088---add---end---   
     ##-----No:FUN-B60140 Mark END-----
            IF l_cnt > 0 THEN
               SELECT fan041 INTO l_fan041 FROM fan_file
                WHERE fan01 = l_fbd.fbd03
                  AND fan02 = l_fbd.fbd031
                  AND fan03 = g_yy AND fan04 = g_mm
                  AND fan041 = '1'   #MOD-C50044 add
               IF l_fan041 <> '2' THEN
                  CALL cl_err(l_fbd.fbd03,'afa-348',1)   #MOD-910240 mod
                  RETURN
               END IF
              ##-----No:FUN-B60140 Mark----- 
             ##FUN-AB0088---add---str---
             # IF g_faa.faa31 = 'Y' THEN
             #     SELECT fbn041 INTO l_fbn041 FROM fbn_file
             #      WHERE fbn01 = l_fbd.fbd03
             #        AND fbn02 = l_fbd.fbd031
             #        AND fbn03 = g_yy AND fbn04 = g_mm
             #     IF l_fbn041 <> '2' THEN
             #        CALL cl_err(l_fbd.fbd03,'afa-348',1)   
             #        RETURN
             #     END IF
             # END IF  
             # #FUN-AB0088---add---end---
              ##-----No:FUN-B60140 Mark END-----
           END IF
        END IF                                    #No.MOD-AC0055
   END FOREACH
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_fbc.fbc01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
   IF NOT cl_null(g_fbc.fbc06) THEN
      IF NOT (g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y') THEN
         CALL cl_err(g_fbc.fbc01,'axr-370',1)   #MOD-910240 mod
         RETURN
      END IF
   END IF
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
     #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",   #FUN-A50102 
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                  "  WHERE aba00 = '",g_faa.faa02b,"'",
                  "    AND aba01 = '",g_fbc.fbc06,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
      PREPARE aba_pre1 FROM l_sql
      DECLARE aba_cs1 CURSOR FOR aba_pre1
      OPEN aba_cs1
      FETCH aba_cs1 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_fbc.fbc06,'axr-071',1)
         RETURN
      END IF
 
   END IF
   IF NOT cl_sure(18,20) THEN RETURN END IF
  #---------------------------CHI-C90051--------------------(S)
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fbc.fbc06,"' '9' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT fbc06,fbc07 INTO g_fbc.fbc06,g_fbc.fbc07 FROM fbc_file
       WHERE fbc01 = g_fbc.fbc01
      DISPLAY BY NAME g_fbc.fbc06
      DISPLAY BY NAME g_fbc.fbc07
      IF NOT cl_null(g_fbc.fbc06) THEN
         CALL cl_err('','aap-929',0)
         RETURN
      END IF
   END IF
  #---------------------------CHI-C90051--------------------(E)
   BEGIN WORK
 
    OPEN t107_cl USING g_fbc.fbc01
    IF STATUS THEN
       CALL cl_err("OPEN t107_cl:", STATUS, 1)
       CLOSE t107_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t107_cl INTO g_fbc.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbc.fbc01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t107_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   DECLARE t107_cur3 CURSOR FOR
      SELECT * FROM fbd_file WHERE fbd01=g_fbc.fbc01
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t107_cur3 INTO l_fbd.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('fbd01',g_fbc.fbc01,'foreach:',SQLCA.sqlcode,0)   #No.FUN-710028
         EXIT FOREACH
      END IF
      #----- 找出 faj_file 中對應之財產編號+附號
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fbd.fbd03
                                            AND faj022=l_fbd.fbd031
      IF STATUS THEN
         CALL cl_err('sel faj',STATUS,0)
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,0)   #No.FUN-710028
         CONTINUE FOREACH  #No.FUN-710028
      END IF
      #----- 找出 fap_file 之 fap05 以便 update faj_file.faj43
       SELECT fap10,fap11,fap101,fap07,fap08,fap41                #No.MOD-490181 改fap10
             ,fap83                                               #FUN-C90088
        INTO l_fap10,l_fap11,l_fap101,l_fap07,l_fap08,l_fap41
             ,l_fap83                                             #FUN-C90088
        FROM fap_file
       WHERE fap50=l_fbd.fbd01  AND fap501=l_fbd.fbd02 AND fap03='9'
      IF STATUS THEN #No.7926
         LET g_showmsg = l_fbd.fbd01,"/",l_fbd.fbd02,"/",'9'               #No.FUN-710028
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'sel fap',STATUS,1)  #No.FUN-710028
         LET g_success = 'N'
      END IF
      IF l_faj.faj43 = '7' THEN    #折畢再提
         UPDATE faj_file SET
                faj141 = l_fap10,    #調整成本          #No.MOD-490181
                faj203 = l_faj.faj203-(l_fbd.fbd10-l_fbd.fbd05),  #No.MOD-490181
                faj32  = l_fap11,    #累折
                faj33  = l_fap101,   #未折減額
                faj30  = l_fap07,    #未使用年限
                faj35  = l_fap08,    #預估殘值
                faj29  = l_fap83,    #FUN-C90088 耐用年限
                faj100 = l_fap41
          WHERE faj02  = l_fbd.fbd03 AND faj022=l_fbd.fbd031
      ELSE
         UPDATE faj_file SET
                faj141 = l_fap10,    #調整成本         #No.MOD-490181
                faj203 = l_faj.faj203-(l_fbd.fbd10-l_fbd.fbd05),  #No.MOD-490181
                faj32  = l_fap11,    #累折
                faj33  = l_fap101,   #未折減額
                faj30  = l_fap07,    #未使用年限
                faj31  = l_fap08,    #預估殘值
                faj29  = l_fap83,    #FUN-C90088 耐用年限
                faj100 = l_fap41
          WHERE faj02  = l_fbd.fbd03 AND faj022=l_fbd.fbd031
      END IF
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN  
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF

     ###-----No:FUN-B60140 Mark-----
     ##FUN-AB0088---add---str---
     #IF g_faa.faa31 = 'Y' THEN
     #   SELECT fap103,fap112,fap1012,fap072,fap082   #No:FUN-B30036
     #     INTO l_fap103,l_fap112,l_fap1012,l_fap072,l_fap082   #No:FUN-B30036
     #     FROM fap_file
     #    WHERE fap50=l_fbd.fbd01  AND fap501=l_fbd.fbd02 AND fap03='9'
     #    IF STATUS THEN 
     #       LET g_showmsg = l_fbd.fbd01,"/",l_fbd.fbd02,"/",'9'               
     #       CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'sel fap',STATUS,1) 
     #       LET g_success = 'N'
     #    END IF
     #    IF l_faj.faj432 = '7' THEN   
     #       UPDATE faj_file SET
     #             #faj1412 = l_fap102, 
     #              faj1412 = l_fap103, 
     #              faj2032 = l_faj.faj2032-(l_fbd.fbd102-l_fbd.fbd052),
     #              faj322  = l_fap112,  
     #              faj332  = l_fap1012, 
     #              faj302  = l_fap072,  
     #              faj352  = l_fap082   
     #        WHERE faj02  = l_fbd.fbd03 AND faj022=l_fbd.fbd031
     #    ELSE
     #       UPDATE faj_file SET
     #             #faj1412 = l_fap102, 
     #              faj1412 = l_fap103,  
     #              faj2032 = l_faj.faj2032-(l_fbd.fbd102-l_fbd.fbd052), 
     #              faj322  = l_fap112,  
     #              faj332  = l_fap1012, 
     #              faj302  = l_fap072, 
     #              faj312  = l_fap082 
     #        WHERE faj02  = l_fbd.fbd03 AND faj022=l_fbd.fbd031
     #    END IF
     #    IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN  
     #       LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031               
     #       CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1) 
     #       LET g_success = 'N'
     #    END IF
     #END IF
     ##FUN-AB0088---add---end---
     ##-----No:FUN-B60140 Mark-----  
    
      #--------- 還原過帳(3)delete fap_file
      IF g_fbc.fbcpost1<>'Y' AND g_fbc.fbcpost2<>'Y' THEN   #No:FUN-B60140
      DELETE FROM fap_file WHERE fap50=l_fbd.fbd01
                             AND fap501=l_fbd.fbd02
                             AND fap03 = '9'
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         CALL cl_err3("del","fap_file",l_fbd.fbd01,l_fbd.fbd02,SQLCA.sqlcode,"","del fap",1)  #No.FUN-660136
         LET g_showmsg = l_fbd.fbd01,"/",l_fbd.fbd02,"/",'9'               #No.FUN-710028
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'del fap',STATUS,1)  #No.FUN-710028
         LET g_success = 'N'
      END IF
   END IF  #No:FUN-B60140
      DELETE FROM fan_file WHERE fan01 = l_fbd.fbd03
                             AND fan02 = l_fbd.fbd031
                             AND fan03 = g_yy
                             AND fan04 = g_mm
                             AND fan041 = '2'
       IF STATUS THEN          #No.MOD-490181
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031,"/",'2'               #No.FUN-710028
         CALL s_errmsg('fan01,fan02,fan041',g_showmsg,'del fan',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
      
     ##-----No:FUN-B60140 Mark-----    
     ##FUN-AB0088---add---str---
     #IF g_faa.faa31 ='Y' THEN
     #    DELETE FROM fbn_file WHERE fbn01 = l_fbd.fbd03
     #                           AND fbn02 = l_fbd.fbd031
     #                           AND fbn03 = g_yy
     #                           AND fbn04 = g_mm
     #                           AND fbn041 = '2'
     #     IF STATUS THEN          #No:MOD-490181
     #       LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031,"/",'2'               #No.FUN-710028
     #       CALL s_errmsg('fbn01,fbn02,fbn041',g_showmsg,'del fbn',STATUS,1)   #No.FUN-710028
     #       LET g_success = 'N'
     #    END IF
     # END IF
     ##FUN-AB0088---add---end---
     ##-----No:FUN-B60140 Mark END -----
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   IF g_success = 'Y' THEN
      UPDATE fbc_file SET fbcpost = 'N' WHERE fbc01 = g_fbc.fbc01
       IF STATUS THEN                #No.MOD-490181
         CALL s_errmsg('fbc01',g_fbc.fbc01,'upd post',STATUS,1)   #No.FUN-710028
         LET g_fbc.fbcpost='Y'
         LET g_success = 'N'
      END IF
   END IF
   CLOSE t107_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
      LET g_fbc.fbcpost='N'
      DISPLAY BY NAME g_fbc.fbcpost #
   END IF
  #---------------------------CHI-C90051--------------------mark
  #IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
  #   LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fbc.fbc06,"' '9' 'Y'"
  #   CALL cl_cmdrun_wait(g_str)
  #   SELECT fbc06,fbc07 INTO g_fbc.fbc06,g_fbc.fbc07 FROM fbc_file
  #    WHERE fbc01 = g_fbc.fbc01
  #   DISPLAY BY NAME g_fbc.fbc06
  #   DISPLAY BY NAME g_fbc.fbc07
  #END IF
  #---------------------------CHI-C90051--------------------mark
   IF g_fbc.fbcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fbc.fbc08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbc.fbcconf,g_chr2,g_fbc.fbcpost,"",g_chr,"")
END FUNCTION
 
FUNCTION t107_7()
   DEFINE l_fbd     RECORD LIKE fbd_file.*,
          l_faj     RECORD LIKE faj_file.*,
          l_fap33   LIKE fap_file.fap33,
          l_fap35   LIKE fap_file.fap35,
          l_fap341  LIKE fap_file.fap341,
          l_fap31   LIKE fap_file.fap31,
          l_fap32   LIKE fap_file.fap32,
          l_yy,l_mm         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_bdate,l_edate   LIKE type_file.dat,          #No.FUN-680070 DATE
          l_cnt     LIKE type_file.num5   #TQC-780089
   DEFINE l_fap711  LIKE fap_file.fap711                 #MOD-C70198 add
   DEFINE l_fap84   LIKE fap_file.fap84                  #FUN-C90088
   IF s_shut(0) THEN RETURN END IF
   IF g_fbc.fbc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_fbc.* FROM fbc_file WHERE fbc01 = g_fbc.fbc01
   IF g_fbc.fbcpost2 != 'Y' THEN
      CALL cl_err(g_fbc.fbc01,'afa-108',1)   #MOD-910240 mod
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa13 INTO g_faa.faa13 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #--->折舊年月判斷
   IF g_fbc.fbc02 < g_faa.faa13 THEN
      CALL cl_err(g_fbc.fbc02,'afa-308',1)   #MOD-910240 mod
      RETURN
   END IF
   DECLARE t107_cur5 CURSOR FOR
      SELECT * FROM fbd_file WHERE fbd01=g_fbc.fbc01
   FOREACH t107_cur5 INTO l_fbd.*
      #No.MOD-AC0055  --Begin
      IF g_aza.aza26 <> '2' THEN
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM fao_file
          WHERE fao01 = l_fbd.fbd03
            AND fao02 = l_fbd.fbd031
            AND ((fao03 = g_yy AND fao04 > g_mm)
             OR fao03 > g_yy 
             OR (fao03 = g_yy AND fao04 = g_mm 
                 AND fao041 <> '2')) 
            AND fao041 = '1'   #MOD-C50044 add
      ELSE
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM fao_file
          WHERE fao01 = l_fbd.fbd03
            AND fao02 = l_fbd.fbd031
            AND ((fao03 = g_yy AND fao04 > g_mm) OR fao03 > g_yy ) 
            AND fao041 = '1'   #MOD-C50044 add
      END IF
      #No.MOD-AC0055  --End  
      IF l_cnt > 0 THEN
         CALL cl_err(l_fbd.fbd03,'afa-348',1)   #MOD-910240 mod
         RETURN
      END IF
   END FOREACH
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK
 
    OPEN t107_cl USING g_fbc.fbc01
    IF STATUS THEN
       CALL cl_err("OPEN t107_cl:", STATUS, 1)
       CLOSE t107_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t107_cl INTO g_fbc.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbc.fbc01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t107_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
 
   DECLARE t107_cur31 CURSOR FOR
      SELECT * FROM fbd_file WHERE fbd01=g_fbc.fbc01
   CALL s_showmsg_init()     #No.FUN-710028
   FOREACH t107_cur31 INTO l_fbd.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('fbd01',g_fbc.fbc01,'foreach:',SQLCA.sqlcode,0)   #No.FUN-710028
         EXIT FOREACH
      END IF
      #----- 找出 faj_file 中對應之財產編號+附號
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fbd.fbd03
                                            AND faj022=l_fbd.fbd031
      #----- 找出 fap_file 異動前值------
     #SELECT fap33,fap35,fap341,fap31,fap32                      #MOD-C70198 mark
     #  INTO l_fap33,l_fap35,l_fap341,l_fap31,l_fap32            #MOD-C70198 mark
      SELECT fap33,fap35,fap341,fap31,fap32,fap711               #MOD-C70198 add
            ,fap84                                               #FUN-C90088
        INTO l_fap33,l_fap35,l_fap341,l_fap31,l_fap32,l_fap711   #MOD-C70198 add
            ,l_fap84                                             #FUN-C90088
        FROM fap_file
       WHERE fap50=l_fbd.fbd01
         AND fap501=l_fbd.fbd02
         AND fap03='9'    ## 異動代號
      IF STATUS THEN #No.7926
         LET g_showmsg = l_fbd.fbd01,"/",l_fbd.fbd02,"/",'9'                #No.FUN-710028
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'sel fap',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
      #--->(1.1)更新資產主檔
      IF l_faj.faj43 = '7' THEN   #折畢再提
         UPDATE faj_file SET
                faj205 = l_faj.faj205-(l_fbd.fbd20-l_fbd.fbd15),  #MOD-930246 add
                faj67  = l_fap35,                                 #累折
                faj68  = l_fap341,                                #未折減額
                faj65  = l_fap31,                                 #未使用年限
                faj64  = l_fap84,                                 #耐用年限    #FUN-C90088
                faj72  = l_fap32,                                 #預估殘值
                faj63  = l_fap711                                 #MOD-C70198 add
          WHERE faj02  = l_fbd.fbd03 AND faj022=l_fbd.fbd031
      ELSE
         UPDATE faj_file SET
               #faj62  = l_fap33,    #稅簽成本                    #MOD-C70198 mark
                faj205 = l_faj.faj205-(l_fbd.fbd20-l_fbd.fbd15),  #MOD-930246 add
                faj67  = l_fap35,                                 #累折
                faj68  = l_fap341,                                #未折減額
                faj65  = l_fap31,                                 #未使用年限
                faj64  = l_fap84,                                 #耐用年限    #FUN-C90088
                faj66  = l_fap32,                                 #預估殘值
                faj63  = l_fap711                                 #MOD-C70198 add
          WHERE faj02  = l_fbd.fbd03 AND faj022=l_fbd.fbd031
      END IF
      IF STATUS  THEN
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)  #No.FUN-66
         LET g_success = 'N'
      END IF
      
      #-----No:FUN-B60140-----
      #--------- 還原過帳(3)delete fap_file
      #財一與財二皆未過帳時，才可刪fap_file
      IF g_fbc.fbcpost <>'Y' AND g_fbc.fbcpost1<>'Y' THEN
         DELETE FROM fap_file WHERE fap50=l_fbd.fbd01
                                AND fap501=l_fbd.fbd02
                                AND fap03 = '9'
         IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
            CALL cl_err3("del","fap_file",l_fbd.fbd01,l_fbd.fbd02,SQLCA.sqlcode,"","del fap",1)
            LET g_showmsg = l_fbd.fbd01,"/",l_fbd.fbd02,"/",'9'
            CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'del fap',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
      #-----No:FUN-B60140 END-----
      
      DELETE FROM fao_file WHERE fao01 = l_fbd.fbd03
                             AND fao02 = l_fbd.fbd031
                             AND fao03 = g_yy
                             AND fao04 = g_mm
                             AND fao041 = '2'
      IF STATUS THEN
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031,"/",'2'
         CALL s_errmsg('fao01,fao02,fao041',g_showmsg,'del fao',STATUS,1)
         LET g_success = 'N'
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   IF g_success = 'Y' THEN
      UPDATE fbc_file SET fbcpost2 = 'N' WHERE fbc01 = g_fbc.fbc01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('fbc01',g_fbc.fbc01,'upd post2',STATUS,1)   #No.FUN-710028
         LET g_fbc.fbcpost2='Y'
         LET g_success = 'N'
      END IF
   END IF
   CLOSE t107_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
      LET g_fbc.fbcpost2='N'
      LET g_fbc.fbcpost='N'
      DISPLAY BY NAME g_fbc.fbcpost2 #
   END IF
END FUNCTION
 
FUNCTION t107_e(p_cmd)        #維護稅簽資料
 DEFINE  p_cmd       LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 DEFINE ls_tmp STRING
   LET p_row = 6  LET p_col  =15
   OPEN WINDOW t107_e1 AT p_row,p_col WITH FORM "afa/42f/afat1071"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afat1071")
 
 
      SELECT fbd14,fbd15,fbd16,fbd17,fbd19,fbd20,fbd21,fbd22
        INTO g_e[l_ac].fbd14,g_e[l_ac].fbd15,g_e[l_ac].fbd16,
             g_e[l_ac].fbd17,g_e[l_ac].fbd19,g_e[l_ac].fbd20,
             g_e[l_ac].fbd21,g_e[l_ac].fbd22
        FROM fbd_file
       WHERE fbd01 = g_fbc.fbc01
         AND fbd02 = g_fbd[l_ac].fbd02
      IF SQLCA.sqlcode THEN
         LET g_e[l_ac].fbd14 = 0   LET g_e[l_ac].fbd21 = 0
         LET g_e[l_ac].fbd15 = 0   LET g_e[l_ac].fbd16 = 0
         LET g_e[l_ac].fbd17 = 0   LET g_e[l_ac].fbd19 = 0
         LET g_e[l_ac].fbd20 = 0   LET g_e[l_ac].fbd22 = 0
      END IF
 
   DISPLAY g_e[l_ac].fbd14 TO fbd14 #
   DISPLAY g_e[l_ac].fbd15 TO fbd15 #
   DISPLAY g_e[l_ac].fbd16 TO fbd16 #
   DISPLAY g_e[l_ac].fbd17 TO fbd17 #
   DISPLAY g_e[l_ac].fbd19 TO fbd19 #
   DISPLAY g_e[l_ac].fbd20 TO fbd20 #
   DISPLAY g_e[l_ac].fbd21 TO fbd21 #
   DISPLAY g_e[l_ac].fbd22 TO fbd22 #
 
   INPUT g_e[l_ac].fbd19,g_e[l_ac].fbd20,g_e[l_ac].fbd21,g_e[l_ac].fbd22
          WITHOUT DEFAULTS
    FROM fbd19,fbd20,fbd21,fbd22
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t107_e1 RETURN END IF
 
      UPDATE fbd_file SET
                  fbd14=g_e[l_ac].fbd14,fbd15=g_e[l_ac].fbd15,
                  fbd16=g_e[l_ac].fbd16,fbd17=g_e[l_ac].fbd17,
                  fbd19=g_e[l_ac].fbd19,fbd20=g_e[l_ac].fbd20,
                  fbd21=g_e[l_ac].fbd21,fbd22=g_e[l_ac].fbd22
       WHERE fbd01 = g_fbc.fbc01 AND fbd02 = g_fbd[l_ac].fbd02
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","fbd_file",g_fbc.fbc01,g_fbd[l_ac].fbd02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
          END IF
   CLOSE WINDOW t107_e1
END FUNCTION
 
#FUNCTION t107_x()             #FUN-D20035
FUNCTION t107_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_fbc.* FROM fbc_file WHERE fbc01=g_fbc.fbc01
   IF g_fbc.fbc08 MATCHES '[Ss1]' THEN
      CALL cl_err("","mfg3557",0) RETURN
   END IF
   IF g_fbc.fbc01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fbc.fbcconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF

   #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_fbc.fbcconf='X' THEN RETURN END IF
   ELSE
      IF g_fbc.fbcconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   BEGIN WORK
   LET g_success='Y'
 
   OPEN t107_cl USING g_fbc.fbc01
   IF STATUS THEN
      CALL cl_err("OPEN t107_cl:", STATUS, 1)
      CLOSE t107_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t107_cl INTO g_fbc.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fbc.fbc01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t107_cl ROLLBACK WORK RETURN
   END IF
  #-->作廢轉換01/08/01
 #IF cl_void(0,0,g_fbc.fbcconf)   THEN        #FUN-D20035
  IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF     #FUN-D20035
  IF cl_void(0,0,l_flag) THEN                                          #FUN-D20035
     LET g_chr=g_fbc.fbcconf
    #IF g_fbc.fbcconf ='N' THEN                                      #FUN-D20035
     IF p_type = 1 THEN                                              #FUN-D20035
        LET g_fbc.fbcconf='X'
        LET g_fbc.fbc08='9'   #FUN-580109
     ELSE
        LET g_fbc.fbcconf='N'
        LET g_fbc.fbc08='0'   #FUN-580109
     END IF
 
     UPDATE fbc_file SET fbcconf =g_fbc.fbcconf,
                         fbc08   =g_fbc.fbc08,   #FUN-580109
                         fbcmodu =g_user,
                         fbcdate =TODAY
            WHERE fbc01 = g_fbc.fbc01
     IF STATUS THEN 
        CALL cl_err3("upd","fbd_file",g_fbc.fbc01,"",SQLCA.sqlcode,"","upd fbcconf:",1)  #No.FUN-660136
        LET g_success='N' 
     END IF
     IF g_success='Y' THEN
         COMMIT WORK
         IF g_fbc.fbcconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_fbc.fbc08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_fbc.fbcconf,g_chr2,g_fbc.fbcpost,"",g_chr,"")
         CALL cl_flow_notify(g_fbc.fbc01,'V')
     ELSE
         ROLLBACK WORK
     END IF
     SELECT fbcconf,fbc08 INTO g_fbc.fbcconf,g_fbc.fbc08   #FUN-580109
       FROM fbc_file
      WHERE fbc01 = g_fbc.fbc01
     DISPLAY BY NAME g_fbc.fbcconf
     DISPLAY BY NAME g_fbc.fbc08   #FUN-580109
  END IF
END FUNCTION
FUNCTION t107_fbc09(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_gen02    LIKE gen_file.gen02,
       l_gen03    LIKE gen_file.gen03,             #No:7381
       l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti    #No:7381
      FROM gen_file
     WHERE gen01 = g_fbc.fbc09
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
 
FUNCTION t107_gen_glcr(p_fbc,p_fah)
  DEFINE p_fbc     RECORD LIKE fbc_file.*
  DEFINE p_fah     RECORD LIKE fah_file.*
 
    IF cl_null(p_fah.fahgslp) THEN
       CALL cl_err(p_fbc.fbc01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL s_showmsg_init()    #No.FUN-710028
    IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 add
       CALL t107_gl(g_fbc.fbc01,g_fbc.fbc02,'0')
    END IF #FUN-C30313 add
#   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 mark
    IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN    #FUN-AB0088 add
       IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 add
          CALL t107_gl(g_fbc.fbc01,g_fbc.fbc02,'1')
       END IF #FUN-C30313 add
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t107_carry_voucher()
  DEFINE l_fahgslp    LIKE fah_file.fahgslp
  DEFINE li_result    LIKE type_file.num5          #No.FUN-680070 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF NOT cl_null(g_fbc.fbc06)  THEN
       CALL cl_err(g_fbc.fbc06,'aap-618',1)
       RETURN
    END IF
   #FUN-B90004---End---
 
    CALL s_get_doc_no(g_fbc.fbc01) RETURNING g_t1
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
    IF g_fah.fahdmy3 = 'N' THEN RETURN END IF
   #IF g_fah.fahglcr = 'Y' THEN         #FUN-B90004
    IF g_fah.fahglcr = 'Y' OR ( g_fah.fahglcr = 'N' AND NOT cl_null(g_fah.fahgslp)) THEN   #FUN-B90004
       LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
      #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",  #FUN-A50102
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102 
                   "  WHERE aba00 = '",g_faa.faa02b,"'",
                   "    AND aba01 = '",g_fbc.fbc06,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
       PREPARE aba_pre2 FROM l_sql
       DECLARE aba_cs2 CURSOR FOR aba_pre2
       OPEN aba_cs2
       FETCH aba_cs2 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_fbc.fbc06,'aap-991',1)
          RETURN
       END IF
 
       LET l_fahgslp = g_fah.fahgslp
    ELSE
      #CALL cl_err('','aap-992',1)   #FUN-B90004 mark
       CALL cl_err('','aap-936',1)   #FUN-B90004
       RETURN

    END IF
    IF cl_null(l_fahgslp) THEN
       CALL cl_err(g_fbc.fbc01,'axr-070',1)
       RETURN
    END IF
  
   ##-----No:FUN-B60140 Mark-----
   #IF g_aza.aza63 = 'Y' THEN    #FUN-AB0088 mark
    #IF g_faa.faa31 = 'Y' THEN    #FUN-AB0088 add
    #   IF cl_null(g_fah.fahgslp1) THEN
    #      CALL cl_err(g_fbc.fbc01,'axr-070',1)
    #      RETURN
    #   END IF
    #END IF
    ##-----No:FUN-B60140 Mark END-----
    LET g_wc_gl = 'npp01 = "',g_fbc.fbc01,'" AND npp011 = 1'
    LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_fbc.fbcuser,"' '",g_fbc.fbcuser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_fbc.fbc02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"  #No.FUN-680028   #MOD-860284#FUN-860040
    CALL cl_cmdrun_wait(g_str)
    SELECT fbc06,fbc07 INTO g_fbc.fbc06,g_fbc.fbc07 FROM fbc_file
     WHERE fbc01 = g_fbc.fbc01
    DISPLAY BY NAME g_fbc.fbc06
    DISPLAY BY NAME g_fbc.fbc07
    
END FUNCTION
 
FUNCTION t107_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF cl_null(g_fbc.fbc06)  THEN
       CALL cl_err(g_fbc.fbc06,'aap-619',1)
       RETURN
    END IF
   #FUN-B90004---End---
 
    CALL s_get_doc_no(g_fbc.fbc01) RETURNING g_t1
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
   #IF g_fah.fahglcr = 'N' THEN        #FUN-B90004
   #   CALL cl_err('','aap-990',1)     #FUN-B90004
    IF g_fah.fahglcr = 'N' AND cl_null(g_fah.fahgslp) THEN    #FUN-B90004
       CALL cl_err('','aap-936',1)  #FUN-B90004
       RETURN
    END IF
    LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",  #FUN-A50102
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                "  WHERE aba00 = '",g_faa.faa02b,"'",
                "    AND aba01 = '",g_fbc.fbc06,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_fbc.fbc06,'axr-071',1)
       RETURN
    END IF
 
    LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fbc.fbc06,"' '9' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT fbc06,fbc07 INTO g_fbc.fbc06,g_fbc.fbc07 FROM fbc_file
     WHERE fbc01 = g_fbc.fbc01
    DISPLAY BY NAME g_fbc.fbc06
    DISPLAY BY NAME g_fbc.fbc07
END FUNCTION

#FUN-AB0088---add---str---
FUNCTION t107_fin_audit2()
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_rec_b2   LIKE type_file.num5
   DEFINE l_fbd102   LIKE fbd_file.fbd102
   DEFINE l_faj322   LIKE faj_file.faj322
   DEFINE l_faj3312  LIKE faj_file.faj3312
   DEFINE l_faj302   LIKE faj_file.faj302
   DEFINE l_faj312   LIKE faj_file.faj312
   DEFINE l_fab232   LIKE fab_file.fab232
   DEFINE l_faj142   LIKE faj_file.faj142  
   DEFINE l_fbd122   LIKE fbd_file.fbd122   

   #FUN-C30140---add---str---
   IF g_fbc.fbc01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF NOT cl_null(g_fbc.fbc08) AND g_fbc.fbc08 matches '[Ss]' THEN     
       CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
       RETURN
   END IF 
   #FUN-C30140---add---end---

   OPEN WINDOW t1079_w2 WITH FORM "afa/42f/afat1079"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("afat1079")

   #FUN-BC0004--mark--str
   #LET g_sql =
   #    "SELECT fbd02,fbd03,fbd031,faj06,fbd042,fbd092,fbd052,fbd102,",
   #    "       fbd062,fbd112,fbd072,fbd122 ",
   #    "  FROM fbd_file,OUTER faj_file ",
   #    " WHERE fbd01  ='",g_fbc.fbc01,"'",   
   #    "   AND fbd03  = faj02",
   #    "   AND fbd031 = faj022",
   #    " ORDER BY 1"
   #FUN-BC0004--mark--end
   #FUN-BC0004--add--str
   LET g_sql =
        "SELECT fbd02,fbd03,fbd031,'',fbd042,fbd092,fbd052,fbd102,",
        "       fbd062,fbd112,fbd072,fbd122 ",
        "  FROM fbd_file ",
        " WHERE fbd01  ='",g_fbc.fbc01,"'",
        " ORDER BY 1"   
   #FUN-BC0004--add--end

   PREPARE afat107_2_pre FROM g_sql

   DECLARE afat107_2_c CURSOR FOR afat107_2_pre

   CALL g_fbd2.clear()

   LET l_cnt = 1

   FOREACH afat107_2_c INTO g_fbd2[l_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach fbd2',STATUS,0)
         EXIT FOREACH
      END IF
     
      #FUN-BC0004--add--str
      SELECT faj06 INTO g_fbd2[l_cnt].faj06
        FROM faj_file
       WHERE faj02 = g_fbd2[l_cnt].fbd03
         AND faj022 = g_fbd2[l_cnt].fbd031
      #FUN-BC0004--add--end
      LET l_cnt = l_cnt + 1

   END FOREACH

   CALL g_fbd2.deleteElement(l_cnt)

   LET l_rec_b2 = l_cnt - 1
   DISPLAY l_rec_b2 TO FORMONLY.cn2

   LET l_ac = 1

   CALL cl_set_act_visible("cancel", FALSE)

   IF g_fbc.fbcconf !="N" THEN   
      DISPLAY ARRAY g_fbd2 TO s_fbd2.* ATTRIBUTE(COUNT=l_rec_b2,UNBUFFERED)

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
    LET g_forupd_sql = " SELECT fbd02,fbd03,fbd031,' ',fbd042,fbd092,fbd052,fbd102,",
                       "       fbd062,fbd112,fbd072,fbd122 ",
                       " FROM fbd_file   ",
                       " WHERE fbd01 = ? ",
                       " AND fbd02   = ? ",
                       " FOR UPDATE "

      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) 
      DECLARE t107_2_bcl CURSOR FROM g_forupd_sql 
       
      INPUT ARRAY g_fbd2 WITHOUT DEFAULTS FROM s_fbd2.*
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
               LET g_fbd2_t.* = g_fbd2[l_ac].* 
               OPEN t107_2_bcl USING g_fbc.fbc01,g_fbd2_t.fbd02
               IF STATUS THEN
                  CALL cl_err("OPEN t107_2_bcl:", STATUS, 1)
               ELSE
                  FETCH t107_2_bcl INTO g_fbd2[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_fbd2_t.fbd02,SQLCA.sqlcode,1)
                  ELSE
                     SELECT faj06 #,faj142,faj322,faj302,faj312 #FUN-BB0122 mark
                       INTO g_fbd2[l_ac].faj06 #,l_faj142,l_faj322,l_faj302,l_faj312 #FUN-BB0122 mark
                       FROM faj_file
                      WHERE faj02  = g_fbd2[l_ac].fbd03
                        AND faj022 = g_fbd2[l_ac].fbd031
               #FUN-BB0122----being--mark
               #      IF cl_null(g_fbd2[l_ac].fbd042) OR g_fbd2[l_ac].fbd042 = 0 THEN
               #          LET g_fbd2[l_ac].fbd042 = l_faj142     
               #      END IF
               #      IF cl_null(g_fbd2[l_ac].fbd052) OR g_fbd2[l_ac].fbd052 = 0 THEN
               #          LET g_fbd2[l_ac].fbd052 = l_faj322    
               #      END IF
               #      IF cl_null(g_fbd2[l_ac].fbd062) OR g_fbd2[l_ac].fbd062 = 0 THEN
               #          LET g_fbd2[l_ac].fbd062 = l_faj302
               #      END IF
               #      IF cl_null(g_fbd2[l_ac].fbd072) OR g_fbd2[l_ac].fbd072 = 0 THEN
               #          LET g_fbd2[l_ac].fbd072 = l_faj312      
               #      END IF
               #      IF cl_null(g_fbd2[l_ac].fbd092) OR g_fbd2[l_ac].fbd092 = 0 THEN
               #          LET g_fbd2[l_ac].fbd092 = l_faj142
               #      END IF
               #      IF cl_null(g_fbd2[l_ac].fbd102) OR g_fbd2[l_ac].fbd102 = 0 THEN
               #          LET g_fbd2[l_ac].fbd102 = l_faj322
               #      END IF 
               #      IF cl_null(g_fbd2[l_ac].fbd112) OR g_fbd2[l_ac].fbd112 = 0 THEN
               #          LET g_fbd2[l_ac].fbd112 = l_faj302
               #      END IF
               #      IF cl_null(g_fbd2[l_ac].fbd122) OR g_fbd2[l_ac].fbd122 = 0 THEN
               #          LET g_fbd2[l_ac].fbd122 = l_faj312
               #      END IF
               #      DISPLAY BY NAME g_fbd2[l_ac].fbd042
               #      DISPLAY BY NAME g_fbd2[l_ac].fbd052
               #      DISPLAY BY NAME g_fbd2[l_ac].fbd062
               #      DISPLAY BY NAME g_fbd2[l_ac].fbd072
               #      DISPLAY BY NAME g_fbd2[l_ac].fbd092
               #      DISPLAY BY NAME g_fbd2[l_ac].fbd102
               #     DISPLAY BY NAME g_fbd2[l_ac].fbd112
               #      DISPLAY BY NAME g_fbd2[l_ac].fbd122
               #FUN-BB0122----being--mark
                  END IF
               END IF
            END IF
        #FUN-BC0004--add-str
        BEFORE FIELD fbd042
           SELECT faj06,faj142,faj322,faj302,faj312
             INTO g_fbd2[l_ac].faj06,l_faj142,l_faj322,l_faj302,l_faj312
             FROM faj_file
            WHERE faj02  = g_fbd2[l_ac].fbd03
              AND faj022 = g_fbd2[l_ac].fbd031
           IF cl_null(g_fbd2[l_ac].fbd042) OR g_fbd2[l_ac].fbd042 = 0 THEN
              LET g_fbd2[l_ac].fbd042 = l_faj142     
           END IF
           IF cl_null(g_fbd2[l_ac].fbd052) OR g_fbd2[l_ac].fbd052 = 0 THEN
              LET g_fbd2[l_ac].fbd052 = l_faj322    
           END IF
           IF cl_null(g_fbd2[l_ac].fbd062) OR g_fbd2[l_ac].fbd062 = 0 THEN
              LET g_fbd2[l_ac].fbd062 = l_faj302
           END IF
           IF cl_null(g_fbd2[l_ac].fbd072) OR g_fbd2[l_ac].fbd072 = 0 THEN
              LET g_fbd2[l_ac].fbd072 = l_faj312      
           END IF
           IF cl_null(g_fbd2[l_ac].fbd092) OR g_fbd2[l_ac].fbd092 = 0 THEN
              LET g_fbd2[l_ac].fbd092 = l_faj142
           END IF
           IF cl_null(g_fbd2[l_ac].fbd102) OR g_fbd2[l_ac].fbd102 = 0 THEN
              LET g_fbd2[l_ac].fbd102 = l_faj322
           END IF 
           IF cl_null(g_fbd2[l_ac].fbd112) OR g_fbd2[l_ac].fbd112 = 0 THEN
              LET g_fbd2[l_ac].fbd112 = l_faj302
           END IF
           IF cl_null(g_fbd2[l_ac].fbd122) OR g_fbd2[l_ac].fbd122 = 0 THEN
              LET g_fbd2[l_ac].fbd122 = l_faj312
           END IF
          #CHI-C60010---str---
           CALL cl_digcut(g_fbd2[l_ac].fbd042,g_azi04_1) RETURNING g_fbd2[l_ac].fbd042
           CALL cl_digcut(g_fbd2[l_ac].fbd052,g_azi04_1) RETURNING g_fbd2[l_ac].fbd052
           CALL cl_digcut(g_fbd2[l_ac].fbd072,g_azi04_1) RETURNING g_fbd2[l_ac].fbd072
           CALL cl_digcut(g_fbd2[l_ac].fbd092,g_azi04_1) RETURNING g_fbd2[l_ac].fbd092
           CALL cl_digcut(g_fbd2[l_ac].fbd102,g_azi04_1) RETURNING g_fbd2[l_ac].fbd102
           CALL cl_digcut(g_fbd2[l_ac].fbd122,g_azi04_1) RETURNING g_fbd2[l_ac].fbd122
          #CHI-C60010---end---
           DISPLAY BY NAME g_fbd2[l_ac].fbd042
           DISPLAY BY NAME g_fbd2[l_ac].fbd052
           DISPLAY BY NAME g_fbd2[l_ac].fbd062
           DISPLAY BY NAME g_fbd2[l_ac].fbd072
           DISPLAY BY NAME g_fbd2[l_ac].fbd092
           DISPLAY BY NAME g_fbd2[l_ac].fbd102
           DISPLAY BY NAME g_fbd2[l_ac].fbd112
           DISPLAY BY NAME g_fbd2[l_ac].fbd122
        #FUN-BC0004--add-end
        AFTER FIELD fbd092
           #LET g_fbd2[l_ac].fbd092 = cl_digcut(g_fbd2[l_ac].fbd092,g_azi04)    #CHI-C60010 mark
           LET g_fbd2[l_ac].fbd092 = cl_digcut(g_fbd2[l_ac].fbd092,g_azi04_1)   #CHI-C60010   
           IF g_fbd2[l_ac].fbd092 <0 THEN 
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbd092
           END IF

        AFTER FIELD fbd102
           #LET g_fbd2[l_ac].fbd102 = cl_digcut(g_fbd2[l_ac].fbd102,g_azi04)   #CHI-C60010 mark
           LET g_fbd2[l_ac].fbd102 = cl_digcut(g_fbd2[l_ac].fbd102,g_azi04_1)   #CHI-C60010  
           IF g_fbd2[l_ac].fbd102 <0 THEN 
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbd102
           END IF

        AFTER FIELD fbd122
           #LET g_fbd2[l_ac].fbd122 = cl_digcut(g_fbd2[l_ac].fbd122,g_azi04)   #CHI-C60010 mark
           LET g_fbd2[l_ac].fbd122 = cl_digcut(g_fbd2[l_ac].fbd122,g_azi04_1)   #CHI-C60010   
           IF g_fbd2[l_ac].fbd122 <0 THEN 
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbd122
           END IF

        AFTER FIELD fbd112
           IF g_aza.aza26 = '2' THEN
              SELECT UNIQUE(fab232) INTO l_fab232 FROM fab_file,faj_file
               WHERE fab01  = faj04
                 AND faj02  = g_fbd2[l_ac].fbd03
                 AND faj022 = g_fbd2[l_ac].fbd031
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","fab_file,faj_file",g_fbd2[l_ac].fbd03,g_fbd2[l_ac].fbd031,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                 LET g_success = 'N' RETURN
              END IF
              IF g_faj282 MATCHES '[05]' THEN
                 LET l_fbd122 = 0
              ELSE
                 LET l_fbd122 =  g_fbd2[l_ac].fbd092 *l_fab232/100        #MOD-A40033 
              END IF
              LET g_fbd2[l_ac].fbd122 = l_fbd122
           ELSE
              CASE g_faj282
                 WHEN '0'  LET l_fbd122 = 0
                           LET g_fbd2[l_ac].fbd122 = 0
                 WHEN '1' LET l_fbd122 =(g_fbd2[l_ac].fbd092 - 
                                g_fbd2[l_ac].fbd102) /(g_fbd2[l_ac].fbd112 + 12)*12
                          LET g_fbd2[l_ac].fbd122 = l_fbd122
                 OTHERWISE EXIT CASE
              END CASE
              LET g_fbd2[l_ac].fbd122 = cl_digcut(g_fbd2[l_ac].fbd122,g_azi04_1)   #CHI-C60010
              DISPLAY BY NAME g_fbd2[l_ac].fbd122
           END IF
           IF g_fbd2[l_ac].fbd112 <0 THEN 
              CALL cl_err('','mfg4012',0)
              NEXT FIELD fbd112
           END IF
         
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fbd2[l_ac].* = g_fbd2_t.*
               CLOSE t107_2_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
       

          #CHI-C60010---str---
           CALL cl_digcut(g_fbd2[l_ac].fbd042,g_azi04_1) RETURNING g_fbd2[l_ac].fbd042
           CALL cl_digcut(g_fbd2[l_ac].fbd052,g_azi04_1) RETURNING g_fbd2[l_ac].fbd052
           CALL cl_digcut(g_fbd2[l_ac].fbd072,g_azi04_1) RETURNING g_fbd2[l_ac].fbd072
           CALL cl_digcut(g_fbd2[l_ac].fbd092,g_azi04_1) RETURNING g_fbd2[l_ac].fbd092
           CALL cl_digcut(g_fbd2[l_ac].fbd102,g_azi04_1) RETURNING g_fbd2[l_ac].fbd102
           CALL cl_digcut(g_fbd2[l_ac].fbd122,g_azi04_1) RETURNING g_fbd2[l_ac].fbd122
          #CHI-C60010---end--- 
           UPDATE fbd_file SET fbd042 = g_fbd2[l_ac].fbd042,
                               fbd052 = g_fbd2[l_ac].fbd052,
                               fbd062 = g_fbd2[l_ac].fbd062,
                               fbd072 = g_fbd2[l_ac].fbd072,
                               fbd092 = g_fbd2[l_ac].fbd092,
                               fbd102 = g_fbd2[l_ac].fbd102,
                               fbd112 = g_fbd2[l_ac].fbd112,
                               fbd122 = g_fbd2[l_ac].fbd122
             WHERE fbd01 = g_fbc.fbc01
               AND fbd02 = g_fbd2_t.fbd02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","fbd_file",g_fbc.fbc01,g_fbd2_t.fbd02,SQLCA.sqlcode,"","",1)  
               LET g_fbd2[l_ac].* = g_fbd2_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF

         AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fbd2[l_ac].* = g_fbd2_t.*
               CLOSE t107_2_bcl 
               ROLLBACK WORK 
               EXIT INPUT
            END IF
            CLOSE t107_2_bcl 
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
 
   CLOSE WINDOW t1079_w2

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

END FUNCTION
#FUN-AB0088---add---end---

#No.FUN-9C0077 程式精簡

#-----No:FUN-B60140-----
FUNCTION t107_s2()
   DEFINE l_fbd       RECORD LIKE fbd_file.*,
          l_faj       RECORD LIKE faj_file.*,
          l_fap661    LIKE fap_file.fap661,
          l_fap55     LIKE fap_file.fap55,
          l_fbc02     LIKE fbc_file.fbc02,
          l_bdate,l_edate  LIKE type_file.dat,          #No.FUN-680070 DATE
          m_cost      LIKE type_file.num20,        #No.FUN-680070 DEC(15,0)
          m_faj24     LIKE faj_file.faj24,
          l_yy,l_mm   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_flag      LIKE type_file.chr1,         #No.FUN-680070 CHAR(01)
          m_chr       LIKE type_file.chr1         #No.FUN-680070 CHAR(1)
   DEFINE l_n         LIKE type_file.num5         #No.TQC-7B0060
   DEFINE m_faj242    LIKE faj_file.faj242        
   DEFINE l_fap552    LIKE fap_file.fap552       
   DEFINE l_fap6612   LIKE fap_file.fap6612     
   DEFINE l_cnt       LIKE type_file.num5  #No:FUN-B60140
   DEFINE l_faj29      LIKE faj_file.faj29     #FUN-C90088
   DEFINE l_faj292     LIKE faj_file.faj292    #FUN-C90088
   DEFINE l_faj64      LIKE faj_file.faj64     #FUN-C90088

   IF s_shut(0) THEN RETURN END IF

   IF g_faa.faa31 = "N" THEN RETURN END IF

   IF g_fbc.fbc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_fbc.* FROM fbc_file WHERE fbc01 = g_fbc.fbc01
   IF g_fbc.fbcconf != 'Y' OR g_fbc.fbcpost1!= 'N' THEN
      CALL cl_err(g_fbc.fbc01,'afa-100',1)
      RETURN
   END IF

   #-->立帳日期小於關帳日期
   IF g_fbc.fbc02 < g_faa.faa092 THEN
      CALL cl_err(g_fbc.fbc01,'aap-176',1) RETURN
   END IF

   LET g_t1 = s_get_doc_no(g_fbc.fbc01)
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1

   #--->折舊年月判斷
   CALL s_get_bookno(g_faa.faa072) RETURNING g_flag,g_bookno1,g_bookno2

   #固資己不和二套掛勾，所以原本利用s_get_bookno取到帳別一及帳別二是用是否使用二套帳來判>
   #此處取帳別二要重新處理，應取固資參數欄位財二帳套faa02c做為帳別二的帳套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF

   CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate

   IF g_fbc.fbc02 < l_bdate OR g_fbc.fbc02 > l_edate THEN
      CALL cl_err(g_fbc.fbc02,'afa-308',1)
      RETURN
   END IF

   LET l_yy = YEAR(g_fbc.fbc02)
   LET l_mm = MONTH(g_fbc.fbc02)

   IF NOT cl_sure(18,20) THEN RETURN END IF

   BEGIN WORK

   CALL s_yp(g_fbc.fbc02) RETURNING g_yy,g_mm

   #OPEN t107_cl USING g_fbc_rowid   #No:FUN-B60140  mark
   OPEN t107_cl USING g_fbc.fbc01   #No:FUN-B60140 add
   IF STATUS THEN
      CALL cl_err("OPEN t107_cl:", STATUS, 1)
      CLOSE t107_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t107_cl INTO g_fbc.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_fbc.fbc01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t107_cl ROLLBACK WORK RETURN
   END IF

   LET g_success = 'Y'

   DECLARE t107_cur22 CURSOR FOR
      SELECT * FROM fbd_file WHERE fbd01=g_fbc.fbc01

   CALL s_showmsg_init()

   FOREACH t107_cur22 INTO l_fbd.*
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success="Y"
      END IF

      IF SQLCA.sqlcode THEN
         CALL s_errmsg('fbd01',g_fbc.fbc01,'foreach:',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF

      #------- 先找出對應之 faj_file 資料
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fbd.fbd03
                                            AND faj022=l_fbd.fbd031
      IF STATUS THEN
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)
         LET g_success = 'N'
      END IF

      LET l_fap661 = l_fbd.fbd09 - l_fbd.fbd04  #本幣成本
      LET l_fap55  = l_fbd.fbd10 - l_fbd.fbd05  #累折
      LET l_fap552 = l_fbd.fbd102 - l_fbd.fbd052   
      LET l_fap6612 = l_fbd.fbd092 - l_fbd.fbd042 

      IF cl_null(l_fbd.fbd031) THEN
         LET l_fbd.fbd031 = ' '
      END IF

      IF cl_null(l_faj.faj432) THEN LET l_faj.faj432 = ' ' END IF
      IF cl_null(l_faj.faj282) THEN LET l_faj.faj282 = ' ' END IF
      IF cl_null(l_faj.faj312) THEN LET l_faj.faj312 = 0 END IF
      IF cl_null(l_faj.faj142) THEN LET l_faj.faj142 = 0 END IF
      IF cl_null(l_faj.faj1412) THEN LET l_faj.faj1412 = 0 END IF
      IF cl_null(l_faj.faj332) THEN LET l_faj.faj332 = 0 END IF
      IF cl_null(l_faj.faj322) THEN LET l_faj.faj322 = 0 END IF
      IF cl_null(l_faj.faj232) THEN LET l_faj.faj232 = ' ' END IF
      IF cl_null(l_faj.faj592) THEN LET l_faj.faj592 = 0 END IF
      IF cl_null(l_faj.faj602) THEN LET l_faj.faj602 = 0 END IF
      IF cl_null(l_faj.faj342) THEN LET l_faj.faj342 =' ' END IF
      IF cl_null(l_faj.faj352) THEN LET l_faj.faj352 = 0 END IF
      IF cl_null(l_faj.faj312) THEN LET l_faj.faj312 = 0 END IF
     #CHI-C60010---str---
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj3312,g_azi04_1) RETURNING l_faj.faj3312
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
      CALL cl_digcut(l_faj.faj1012,g_azi04_1) RETURNING l_faj.faj1012
      CALL cl_digcut(l_fbd.fbd092,g_azi04_1) RETURNING l_fbd.fbd092
      CALL cl_digcut(l_fbd.fbd042,g_azi04_1) RETURNING l_fbd.fbd042
      CALL cl_digcut(l_fbd.fbd052,g_azi04_1) RETURNING l_fbd.fbd052
      CALL cl_digcut(l_fbd.fbd102,g_azi04_1) RETURNING l_fbd.fbd102
      CALL cl_digcut(l_fbd.fbd122,g_azi04_1) RETURNING l_fbd.fbd122
      CALL cl_digcut(l_fap552,g_azi04_1) RETURNING l_fap552
      CALL cl_digcut(l_fap6612,g_azi04_1) RETURNING l_fap6612
     #CHI-C60010---end---

      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fap_file
       WHERE fap50  = l_fbd.fbd01
         AND fap501 = l_fbd.fbd02
         AND fap03  = '9'              ## 異動代號
      #FUN-C90088--B--
      LET l_faj29  = 0
      LET l_faj292 = 0
      LET l_faj64  = 0
      LET l_faj29  = l_faj.faj29  + l_fbd.fbd11  - l_fbd.fbd06
      LET l_faj292 = l_faj.faj292 + l_fbd.fbd112 - l_fbd.fbd062
      LET l_faj64  = l_faj.faj64  + l_fbd.fbd21  - l_fbd.fbd16
      IF l_faj29  < 0 THEN LET l_faj29  = 0 END IF
      IF l_faj292 < 0 THEN LET l_faj292 = 0 END IF
      IF l_faj64  < 0 THEN LET l_faj64  = 0 END IF
      #FUN-C90088--E--
      IF l_cnt = 0 THEN   #無fap_file資料
         INSERT INTO fap_file (fap01,fap02,fap021,fap03,fap04,fap05,fap06,fap07,
                               fap08,fap09,fap10,fap101,fap11,fap12,fap13,fap14,
                               fap15,fap16,fap17,fap18,fap19,fap20,fap201,fap21,
                               fap22,fap23,fap24,fap25,fap26,fap30,fap31,fap32,
                               fap33,fap34,fap341,fap35,fap36,fap37,fap38,fap39,
                               fap40,fap41,fap50,fap501,fap661,fap55,fap52,fap53,fap54,
                               fap711,fap72,fap69,fap70,fap71,
                               fap121,fap131,fap141,fap77,
                               fap052,fap062,fap072,fap082,
                               fap092,fap103,fap1012,fap112,
                               fap152,fap162,fap212,fap222,
                               fap232,fap242,fap252,fap262,
                               fap522,fap532,fap542,fap552,
                               fap6612,fap56,fap562,fap772,faplegal
                              ,fap83,fap832,fap84,   #FUN-C90088
                               fap93,fap932,fap94    #FUN-C90088
                              )
         VALUES (l_faj.faj01,l_fbd.fbd03,l_fbd.fbd031,'9',
                 g_fbc.fbc02,l_faj.faj43,l_faj.faj28,l_faj.faj30,
                 l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33+l_faj.faj331,
                 l_faj.faj32,l_faj.faj53,l_faj.faj54,l_faj.faj55,
                 l_faj.faj23,l_faj.faj24,l_faj.faj20,l_faj.faj19,
                 l_faj.faj21,l_faj.faj17,l_faj.faj171,l_faj.faj58,
                 l_faj.faj59,l_faj.faj60,l_faj.faj34,l_faj.faj35,
                 l_faj.faj36,l_faj.faj61,l_faj.faj65,l_faj.faj66,
                 l_faj.faj62,l_faj.faj63,l_faj.faj68,l_faj.faj67,
                 l_faj.faj69,l_faj.faj70,l_faj.faj71,l_faj.faj72,
                 l_faj.faj73,l_faj.faj100,l_fbd.fbd01,l_fbd.fbd02,
                 l_fap661,l_fap55,l_fbd.fbd11,l_fbd.fbd12,
                 l_fbd.fbd09-l_fbd.fbd04-l_faj.faj141,
                 0,0,l_fbd.fbd21,l_fbd.fbd22,l_fbd.fbd19,
                 l_faj.faj531,l_faj.faj541,l_faj.faj551,l_faj.faj43
                ,l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,
                 l_faj.faj142,l_faj.faj1412,l_faj.faj332+l_faj.faj3312,l_faj.faj322,
                 l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
                 l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,
                 l_fbd.fbd112,l_fbd.fbd122,l_fbd.fbd092-l_fbd.fbd042-l_faj.faj1412,
                 l_fap552,l_fap6612,0,0,l_faj.faj432,g_legal
                ,l_faj.faj29,l_faj.faj292,l_faj.faj64,  #FUN-C90088
                 l_faj29,l_faj292,l_faj64               #FUN-C90088
                 )
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
                             fap522 = l_fbd.fbd112,
                             fap532 = l_fbd.fbd122,
                             fap542 = l_fbd.fbd092-l_fbd.fbd042-l_faj.faj1412,  #TQC-BB0012 mod fbd02->fbd042
                             fap552 = l_fap552,
                             fap6612= l_fap6612,
                             fap562 = 0
                       WHERE fap50  = l_fbd.fbd01
                         AND fap501 = l_fbd.fbd02
                         AND fap03  = '9'              ## 異動代號
      END IF

      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031,"/",'9',"/",g_fbc.fbc02     #No.FUN
         CALL s_errmsg('fap02,fap021,fap03,fap04',g_showmsg,'ins fap',STATUS,1)   #No.FUN
         LET g_success = 'N'
      END IF

      #--------- 過帳(3)update faj_file
      IF l_faj.faj432 = '7' THEN     #折畢再提
        UPDATE faj_file SET
               faj1412 = (l_fbd.fbd092-l_fbd.fbd042),
               faj2032 = faj2032+(l_fbd.fbd102-l_fbd.fbd052),
               faj322  = l_fbd.fbd102,                             #累折
                      #本幣成本+調整成本-銷帳成本-累折+銷帳累折 = 未折減額
               faj332  = l_fbd.fbd092 -faj592 - (l_fbd.fbd102 - faj602),
               faj302  = l_fbd.fbd112,                             #未使用年限
               faj292  = l_faj292,                                #FUN-C90088 耐用年限
               faj352  = l_fbd.fbd122                             #預留殘值
         WHERE faj02   = l_fbd.fbd03 AND faj022=l_fbd.fbd031
      ELSE
        UPDATE faj_file SET
               faj1412 = (l_fbd.fbd092-l_fbd.fbd042),        #本幣成本
               faj2032 = faj2032+(l_fbd.fbd102-l_fbd.fbd052),
               faj322  = l_fbd.fbd102,                             #累折
                      #本幣成本+調整成本-銷帳成本-累折+銷帳累折 = 未折減額
               faj332  = l_fbd.fbd092 -faj592 - (l_fbd.fbd102 - faj602),
               faj302  = l_fbd.fbd112,                             #未使用年限
               faj292  = l_faj292,                                #FUN-C90088 耐用年限
               faj312  = l_fbd.fbd122                             #預留殘值
         WHERE faj02  = l_fbd.fbd03 AND faj022=l_fbd.fbd031
      END IF
      IF STATUS THEN
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)
         LET g_success = 'N'
      END IF

      IF g_aza.aza26 <> '2' THEN
         SELECT COUNT(*) INTO l_n FROM fbn_file
          WHERE fbn01 = l_fbd.fbd03
            AND fbn02 = l_fbd.fbd031
            AND (fbn03 = g_yy
            AND fbn04 >= g_mm
             OR fbn03 > g_yy )
            AND fbn041 = '1'     #MOD-D40098 add
         IF l_n > 0 THEN
            LET g_success = 'N'
            CALL cl_err('','afa-186',1)
         END IF
      ELSE
         SELECT COUNT(*) INTO l_n FROM fbn_file
          WHERE fbn01 = l_fbd.fbd03
            AND fbn02 = l_fbd.fbd031
            AND (fbn03 = g_yy  AND fbn04 > g_mm  OR fbn03 > g_yy )
            AND fbn041 = '1'     #MOD-D40098 add
         IF l_n > 0 THEN
            LET g_success = 'N'
            CALL cl_err('','afa-186',1)
         END IF
      END IF
      IF l_faj.faj232 = '1' THEN
         LET m_faj242 = l_faj.faj242
      ELSE
         LET m_faj242 = l_faj.faj20
      END IF
      IF cl_null(l_fbd.fbd031) THEN
         LET l_fbd.fbd031 = ' '
      END IF
      IF cl_null(m_faj242) THEN
         LET m_faj242=' '
      END IF

      INSERT INTO fbn_file(fbn01,fbn02,fbn03,fbn04,fbn041,fbn05,fbn06,
                           fbn07,fbn08,fbn09,fbn10,fbn11,fbn12,fbn13,
                           fbn14,fbn15,fbn16,fbn17,fbn20) #MOD-BC0131 add fbn20
           VALUES (l_fbd.fbd03,l_fbd.fbd031,g_yy,g_mm,'2',l_faj.faj232,
                   m_faj242,l_fap552,0,' ',l_faj.faj432,l_faj.faj53,
                   l_faj.faj55,l_faj.faj242,0,0,1,l_faj.faj1012,l_faj.faj541) #MOD-BC0131 add faj541
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
        #LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031,"/",g_yy,"/",g_mm,"/",'2',"/",l_faj  #TQC-C20313 MARK
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031,"/",g_yy,"/",g_mm,"/",'2',"/",l_faj.faj23,"/",l_faj.faj55 #TQC-C20313  add
         CALL s_errmsg('fbn01,fbn02,fbn03,fbn04,fbn041,fbn05,fbn06',g_showmsg,'ins fbn',STATUS,1)  
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031,"/",g_yy,"/",g_mm,"/",'2',"/",l_faj.faj23,"/",l_faj.faj55
         LET g_success = 'N'
      END IF

      IF g_success = 'Y' THEN
         UPDATE fbc_file SET fbcpost1= 'Y' WHERE fbc01 = g_fbc.fbc01
          IF STATUS THEN
            CALL s_errmsg('fbc01',g_fbc.fbc01,'upd post',STATUS,1)
            LET g_fbc.fbcpost1='N'
            LET g_success = 'N'
         ELSE
            LET g_fbc.fbcpost1='Y'
            LET g_success = 'Y'
            DISPLAY BY NAME g_fbc.fbcpost1
         END IF
      END IF

   END FOREACH

   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF

   CLOSE t107_cl
   CALL s_showmsg()
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF

   #IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN #FUN-C30313 mark
   IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN #FUN-C30313 add
      LET g_wc_gl = 'npp01 = "',g_fbc.fbc01,'" AND npp011 = 1'
      LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_fbc.fbcuser,"' '",g_fbc.fbcuser,"' '"
      CALL cl_cmdrun_wait(g_str)
      SELECT fbc062,fbc072 INTO g_fbc.fbc062,g_fbc.fbc072 FROM fbc_file
       WHERE fbc01 = g_fbc.fbc01
      DISPLAY BY NAME g_fbc.fbc062
      DISPLAY BY NAME g_fbc.fbc072
   END IF

END FUNCTION

FUNCTION t107_w2()
   DEFINE l_fbd    RECORD LIKE fbd_file.*,
          l_faj    RECORD LIKE faj_file.*,
          l_fap    RECORD LIKE fap_file.*,
          l_fap10  LIKE fap_file.fap10,
          l_fap11  LIKE fap_file.fap11,
          l_fap101 LIKE fap_file.fap101,
          l_fap07  LIKE fap_file.fap07,
          l_fap08  LIKE fap_file.fap08,
          l_fap41  LIKE fap_file.fap41,
          l_bdate,l_edate  LIKE type_file.dat,
          l_cnt    LIKE type_file.num5
   DEFINE l_aba19  LIKE aba_file.aba19
   DEFINE l_sql    LIKE type_file.chr1000
   DEFINE l_dbs    STRING
   DEFINE l_fan041 LIKE fan_file.fan041
   DEFINE l_fap103 LIKE fap_file.fap103
   DEFINE l_fap112 LIKE fap_file.fap112
   DEFINE l_fap1012 LIKE fap_file.fap1012
   DEFINE l_fap072 LIKE fap_file.fap072
   DEFINE l_fap082 LIKE fap_file.fap082
   DEFINE l_cnt1   LIKE type_file.num5
   DEFINE l_fbn041 LIKE fbn_file.fbn041
   DEFINE l_fap832 LIKE fap_file.fap832    #FUN-C90088

   IF s_shut(0) THEN RETURN END IF

   IF g_faa.faa31 = "N" THEN RETURN END IF

   IF g_fbc.fbc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_fbc.* FROM fbc_file WHERE fbc01 = g_fbc.fbc01
   IF g_fbc.fbcpost1 != 'Y' THEN
      CALL cl_err(g_fbc.fbc01,'afa-108',1)
      RETURN
   END IF

   #-->已拋轉總帳, 不可取消確認
   IF NOT cl_null(g_fbc.fbc062) AND g_fah.fahglcr = 'N' THEN
      CALL cl_err(g_fbc.fbc062,'aap-145',1)
      RETURN
   END IF

   #-->立帳日期小於關帳日期
   IF g_fbc.fbc02 < g_faa.faa092 THEN
      CALL cl_err(g_fbc.fbc01,'aap-176',1) RETURN
   END IF

   #--->折舊年月判斷
   CALL s_get_bookno(g_faa.faa072) RETURNING g_flag,g_bookno1,g_bookno2

   #固資己不和二套掛勾，所以原本利用s_get_bookno取到帳別一及帳別二是用是否使用二套帳來判>
   #此處取帳別二要重新處理，應取固資參數欄位財二帳套faa02c做為帳別二的帳套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF

   CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate

   IF g_fbc.fbc02 < l_bdate OR g_fbc.fbc02 > l_edate THEN
      CALL cl_err(g_fbc.fbc02,'afa-308',1)
      RETURN
   END IF

   DECLARE t107_cur42 CURSOR FOR
      SELECT * FROM fbd_file WHERE fbd01=g_fbc.fbc01
   FOREACH t107_cur42 INTO l_fbd.*
      LET l_cnt1 = 0
      SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
       WHERE fbn01 = l_fbd.fbd03
         AND fbn02 = l_fbd.fbd031
         AND (fan03 = g_yy AND fan04 > g_mm OR fan03 > g_yy)   #No.MOD-AC0055
         AND fbn041 = '1'   #MOD-C50044 add

      IF l_cnt1 > 0 THEN
         CALL cl_err(l_fbd.fbd03,'afa-348',1)
         RETURN
      END IF

      IF g_aza.aza26 <> '2' THEN
         LET l_cnt1 = 0
         SELECT COUNT(*) INTO l_cnt1 FROM fbn_file
          WHERE fbn01 = l_fbd.fbd03
            AND fbn02 = l_fbd.fbd031
            AND fbn03 = g_yy AND fbn04 = g_mm
            AND fbn041 = '1'   #MOD-C50044 add
         IF l_cnt1 > 0 THEN
            SELECT fbn041 INTO l_fbn041 FROM fbn_file
             WHERE fbn01 = l_fbd.fbd03
               AND fbn02 = l_fbd.fbd031
               AND fbn03 = g_yy AND fbn04 = g_mm
               AND fbn041 = '1'   #MOD-C50044 add
            IF l_fbn041 <> '2' THEN
               CALL cl_err(l_fbd.fbd03,'afa-348',1)
               RETURN
            END IF
         END IF
      END IF
   END FOREACH

   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_fbc.fbc01) RETURNING g_t1
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
   IF NOT cl_null(g_fbc.fbc062) THEN
      #IF NOT (g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y') THEN  #FUN-C30313 mark
      IF NOT (g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y') THEN #FUN-C30313 add
         CALL cl_err(g_fbc.fbc01,'axr-370',1)
         RETURN
      END IF
   END IF

   #IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 mark
   IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 add
      LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
      LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
                  "  WHERE aba00 = '",g_faa.faa02c,"'",
                  "    AND aba01 = '",g_fbc.fbc062,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE aba_pre12 FROM l_sql
      DECLARE aba_cs12 CURSOR FOR aba_pre12
      OPEN aba_cs12
      FETCH aba_cs12 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_fbc.fbc062,'axr-071',1)
         RETURN
      END IF
   END IF

   IF NOT cl_sure(18,20) THEN RETURN END IF
  #---------------------------CHI-C90051--------------------(S)
   IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fbc.fbc062,"' '9' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT fbc062,fbc072 INTO g_fbc.fbc062,g_fbc.fbc072 FROM fbc_file
       WHERE fbc01 = g_fbc.fbc01
      DISPLAY BY NAME g_fbc.fbc062
      DISPLAY BY NAME g_fbc.fbc072
      IF NOT cl_null(g_fbc.fbc062) THEN
         CALL cl_err('','aap-929',0)
         RETURN
      END IF
   END IF
  #---------------------------CHI-C90051--------------------(E)

   BEGIN WORK

   #OPEN t107_cl USING g_fbc_rowid #No:FUN-B60140 mark
   OPEN t107_cl USING g_fbc.fbc01  #No:FUN-B60140 add
   IF STATUS THEN
      CALL cl_err("OPEN t107_cl:", STATUS, 1)
      CLOSE t107_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t107_cl INTO g_fbc.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fbc.fbc01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t107_cl ROLLBACK WORK RETURN
   END IF

   LET g_success = 'Y'

   DECLARE t107_cur32 CURSOR FOR
      SELECT * FROM fbd_file WHERE fbd01=g_fbc.fbc01

   CALL s_showmsg_init()

   FOREACH t107_cur32 INTO l_fbd.*
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success="Y"
      END IF

      IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('fbd01',g_fbc.fbc01,'foreach:',SQLCA.sqlcode,0)   #No.FUN-710028
         EXIT FOREACH
      END IF

      #----- 找出 faj_file 中對應之財產編號+附號
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fbd.fbd03
                                            AND faj022=l_fbd.fbd031

      IF STATUS THEN
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,0)
         CONTINUE FOREACH
      END IF

      #----- 找出 fap_file 之 fap05 以便 update faj_file.faj43
       SELECT fap103,fap112,fap1012,fap072,fap082   #No:FUN-B30036
             ,fap832                                         #FUN-C90088
        INTO l_fap103,l_fap112,l_fap1012,l_fap072,l_fap082   #No:FUN-B30036
            ,l_fap832                                        #FUN-C90088
        FROM fap_file
       WHERE fap50=l_fbd.fbd01  AND fap501=l_fbd.fbd02 AND fap03='9'
      IF STATUS THEN
         LET g_showmsg = l_fbd.fbd01,"/",l_fbd.fbd02,"/",'9'
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'sel fap',STATUS,1)
         LET g_success = 'N'
      END IF
     #CHI-C60010---str---
      CALL cl_digcut(l_fap082,g_azi04_1) RETURNING l_fap082
      CALL cl_digcut(l_fap103,g_azi04_1) RETURNING l_fap103
      CALL cl_digcut(l_fap112,g_azi04_1) RETURNING l_fap112
      CALL cl_digcut(l_fap1012,g_azi04_1) RETURNING l_fap1012
      CALL cl_digcut(l_faj.faj2032,g_azi04_1) RETURNING l_faj.faj2032
      CALL cl_digcut(l_fbd.fbd102,g_azi04_1) RETURNING l_fbd.fbd102
      CALL cl_digcut(l_fbd.fbd052,g_azi04_1) RETURNING l_fbd.fbd052
     #CHI-C60010---end--
      IF l_faj.faj432 = '7' THEN    #折畢再提
         UPDATE faj_file SET
                faj1412 = l_fap103,    #調整成本
                faj2032 = l_faj.faj2032-(l_fbd.fbd102-l_fbd.fbd052),
                faj322  = l_fap112,    #累折
                faj332  = l_fap1012,   #未折減額
                faj302  = l_fap072,    #未使用年限
                faj352  = l_fap082    #預估殘值
               ,faj292  = l_fap832     #FUN-C90088 耐用年限
          WHERE faj02  = l_fbd.fbd03 AND faj022=l_fbd.fbd031
      ELSE
         UPDATE faj_file SET
                faj1412 = l_fap103,    #調整成本
                faj2032 = l_faj.faj2032-(l_fbd.fbd102-l_fbd.fbd052),
                faj322  = l_fap112,    #累折
                faj332  = l_fap1012,   #未折減額
                faj302  = l_fap072,    #未使用年限
                faj312  = l_fap082    #預估殘值
               ,faj292  = l_fap832     #FUN-C90088 耐用年限
          WHERE faj02  = l_fbd.fbd03 AND faj022=l_fbd.fbd031
      END IF
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)
         LET g_success = 'N'
      END IF

      #--------- 還原過帳(3)delete fap_file
      #財一與稅簽皆未過帳時，才可刪fap_file
      IF g_fbc.fbcpost <>'Y' AND g_fbc.fbcpost2<>'Y' THEN
         DELETE FROM fap_file WHERE fap50=l_fbd.fbd01
                                AND fap501=l_fbd.fbd02
                                AND fap03 = '9'
         IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
            CALL cl_err3("del","fap_file",l_fbd.fbd01,l_fbd.fbd02,SQLCA.sqlcode,"","del fap",1)
            LET g_showmsg = l_fbd.fbd01,"/",l_fbd.fbd02,"/",'9'
            CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'del fap',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF

      DELETE FROM fbn_file WHERE fbn01 = l_fbd.fbd03
                             AND fbn02 = l_fbd.fbd031
                             AND fbn03 = g_yy
                             AND fbn04 = g_mm
                             AND fbn041 = '2'
      IF STATUS THEN
         LET g_showmsg = l_fbd.fbd03,"/",l_fbd.fbd031,"/",'2'
         CALL s_errmsg('fbn01,fbn02,fbn041',g_showmsg,'del fbn',STATUS,1)
         LET g_success = 'N'
      END IF
   END FOREACH

   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF

   IF g_success = 'Y' THEN
      UPDATE fbc_file SET fbcpost1= 'N' WHERE fbc01 = g_fbc.fbc01
      IF STATUS THEN
         CALL s_errmsg('fbc01',g_fbc.fbc01,'upd post',STATUS,1)
         LET g_fbc.fbcpost1='Y'
         LET g_success = 'N'
      END IF
   END IF

   CLOSE t107_cl

   CALL s_showmsg()

   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
      LET g_fbc.fbcpost1='N'
      DISPLAY BY NAME g_fbc.fbcpost1
   END IF

  #---------------------------CHI-C90051--------------------mark
  ##IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN #FUN-C30313 mark
  #IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN #FUN-C30313 add
  #   LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fbc.fbc062,"' '9' 'Y'"
  #   CALL cl_cmdrun_wait(g_str)
  #   SELECT fbc062,fbc072 INTO g_fbc.fbc062,g_fbc.fbc072 FROM fbc_file
  #    WHERE fbc01 = g_fbc.fbc01
  #   DISPLAY BY NAME g_fbc.fbc062
  #   DISPLAY BY NAME g_fbc.fbc072
  #END IF
  #---------------------------CHI-C90051--------------------mark

END FUNCTION

FUNCTION t107_carry_voucher2()
   DEFINE l_fahgslp    LIKE fah_file.fahgslp
   DEFINE li_result    LIKE type_file.num5
   DEFINE l_dbs        STRING
   DEFINE l_sql        STRING
   DEFINE l_n          LIKE type_file.num5

   IF g_faa.faa31 = "N" THEN RETURN END IF

   IF NOT cl_confirm('aap-989') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF NOT cl_null(g_fbc.fbc062)  THEN
       CALL cl_err(g_fbc.fbc062,'aap-618',1)
       RETURN
    END IF
   #FUN-B90004---End---

   CALL s_get_doc_no(g_fbc.fbc01) RETURNING g_t1
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1

   #IF g_fah.fahdmy3 = 'N' THEN RETURN END IF #FUN-C30313 mark
   IF g_fah.fahdmy32 = 'N' THEN RETURN END IF #FUN-C30313 add

  #IF g_fah.fahglcr = 'Y' THEN   #FUN-B90004
   IF g_fah.fahglcr = 'Y' OR ( g_fah.fahglcr = 'N' AND NOT cl_null(g_fah.fahgslp1)) THEN   #FUN-B90004
      LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
      LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
                  "  WHERE aba00 = '",g_faa.faa02c,"'",
                  "    AND aba01 = '",g_fbc.fbc062,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE aba_pre22 FROM l_sql
      DECLARE aba_cs22 CURSOR FOR aba_pre22
      OPEN aba_cs22
      FETCH aba_cs22 INTO l_n
      IF l_n > 0 THEN
         CALL cl_err(g_fbc.fbc062,'aap-991',1)
         RETURN
      END IF
      LET l_fahgslp = g_fah.fahgslp
   ELSE
     #CALL cl_err('','aap-992',1)   #FUN-B90004 mark
      CALL cl_err('','aap-936',1)   #FUN-B90004
      RETURN
   END IF

   IF cl_null(g_fah.fahgslp1) THEN
      CALL cl_err(g_fbc.fbc01,'axr-070',1)
      RETURN
   END IF

   LET g_wc_gl = 'npp01 = "',g_fbc.fbc01,'" AND npp011 = 1'
   LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_fbc.fbcuser,"' '",g_fbc.fbcuser,"'",
            #'",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_fbc.fbc02,"' 'Y' '1' 'Y' '",g_fah.fahgslp1,"'"   #TQC-C20236   Mark
             " '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_fbc.fbc02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"   #TQC-C20236   Add
   CALL cl_cmdrun_wait(g_str)
   SELECT fbc062,fbc072 INTO g_fbc.fbc062,g_fbc.fbc072 FROM fbc_file
    WHERE fbc01 = g_fbc.fbc01
   DISPLAY BY NAME g_fbc.fbc062
   DISPLAY BY NAME g_fbc.fbc072

END FUNCTION

FUNCTION t107_undo_carry_voucher2()
   DEFINE l_aba19    LIKE aba_file.aba19
   DEFINE l_sql      LIKE type_file.chr1000
   DEFINE l_dbs      STRING

   IF g_faa.faa31 = "N" THEN RETURN END IF

   IF NOT cl_confirm('aap-988') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF cl_null(g_fbc.fbc062)  THEN
       CALL cl_err(g_fbc.fbc062,'aap-619',1)
       RETURN
    END IF
   #FUN-B90004---End---

   CALL s_get_doc_no(g_fbc.fbc01) RETURNING g_t1
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
  #IF g_fah.fahglcr = 'N' THEN        #FUN-B90004
  #   CALL cl_err('','aap-990',1)     #FUN-B90004
   IF g_fah.fahglcr = 'N' AND cl_null(g_fah.fahgslp1) THEN    #FUN-B90004
      CALL cl_err('','aap-936',1)  #FUN-B90004
      RETURN
   END IF

   LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
   LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
               "  WHERE aba00 = '",g_faa.faa02c,"'",
               "    AND aba01 = '",g_fbc.fbc062,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   PREPARE aba_pre23 FROM l_sql
   DECLARE aba_cs23 CURSOR FOR aba_pre23
   OPEN aba_cs23
   FETCH aba_cs23 INTO l_aba19
   IF l_aba19 = 'Y' THEN
      CALL cl_err(g_fbc.fbc062,'axr-071',1)
      RETURN
   END IF

   LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fbc.fbc062,"' '9' 'Y'"
   CALL cl_cmdrun_wait(g_str)
   SELECT fbc062,fbc072 INTO g_fbc.fbc062,g_fbc.fbc072 FROM fbc_file
    WHERE fbc01 = g_fbc.fbc01
   DISPLAY BY NAME g_fbc.fbc062
   DISPLAY BY NAME g_fbc.fbc072

END FUNCTION
#-----No:FUN-B60140 END-----
                                                                                                                     

