# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Descriptions...: 固定資產資本化作業
# Pattern Name...: afat101.4gl
# Date & Author..: 96/06/03 By Sophia
# Modify.........: 02/10/15 BY Maggie   No.A032
# Modify.........: No:7837 03/08/19 By Wiky 呼叫自動取單號時應在 Transction中
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-490235 04/09/13 By Yuna 自動生成改成用confirm的方式
# Modify.........: No.MOD-4A0196 04/10/12 By Kitty 自動產生完後不會show在螢幕上
# Modify.........: No.MOD-4A0248 04/10/25 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.FUN-550034 05/05/16 By jackie 單據編號加大
# Modify.........: No.FUN-5B0018 05/11/04 By Sarah 單據日期沒有判斷關帳日
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-620120 06/03/02 By Smapmin 當附號為NULL時,LET 附號為空白
# Modify.........: No.TQC-630073 06/03/07 By Mandy 流程訊息通知功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670060 06/08/04 By Rayven 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680028 06/08/22 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION t101_q() 一開始應清空g_faq.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-710028 07/02/01 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740033 07/04/11 By Carrier 會計科目加帳套-財務
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760182 07/06/27 By chenl   自動產生QBE，條件不可為空。
# Modify.........: No.TQC-770108 07/07/24 By Rayven 單身"分攤部門/類型"類型無法開窗
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-850068 08/05/13 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.MOD-860284 08/07/04 By Sarah 使用afap302拋轉程式,原先傳g_user改為faquser
# Modify.........: No.MOD-860290 08/07/04 By Sarah t101_y()段最後增加IF g_fahpost = 'Y' THEN CALL t101_s() END IF
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: NO.CHI-8A0021 08/12/10 BY yiting insert into faj_file時，如果做多次資本化時，9999附號會產生key重複，以9999->9998->9997依序類推產生
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.MOD-910207 09/01/17 By Sarah 過帳時未將入帳日期(far04)及開始提列(far27)欄位回寫faj26,faj27
# Modify.........: No.MOD-950043 09/05/08 By lilingyu 在INSERT INTO faj_file前,增加判斷faj02+faj022不可已存在資料庫,若已存在不可新增
# Modify.........: No.MOD-950185 09/05/19 By lilingyu DELETE FROM faj_file的SQL，都加上faj021 ='3'的條件
# Modify.........: No.FUN-980003 09/08/10 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0090 09/10/14 By mike AFTER FIELD faq02段IF NOT cl_null(g_faq.faq03) THEN应改为IF NOT cl_null(g_faq.faq0
# Modify.........: No:CHI-9B0032 09/11/30 By Sarah 寫入fap_file時,也應寫入fap77=faj43
# Modify.........: No:FUN-9C0077 10/01/06 By baofei 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-A40033 10/04/07 By lilingyu 如果是大陸版,則按調整后資產總成本*殘值率 來計算"調整后的預計殘值"
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A60036 10/07/12 By Summer 過帳檢查改用s_azmm,增加aza63判斷
# Modify.........: No:MOD-A80137 10/08/19 By Dido 過帳與取消過帳應檢核關帳日 
# Modify.........: No:TQC-AB0036 10/11/09 By suncx sybase第一階段測試BUG修改
# Modify.........: No:TQC-AB0257 10/11/30 By suncx 新增對far03的管控
# Modify.........: No.FUN-B10049 11/01/26 By destiny 科目查詢自動過濾
# Modify.........: No.TQC-B20051 11/02/14 By zhangll 修正faj021類型過賬與取消過賬不一致,導致過帳還原不了
# Modify.........: No:FUN-AB0088 11/04/07 By chenying 固定資產財簽二功能
#                                11/04/12 By chenying 過帳時更新財簽二的狀態                     
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.TQC-B30156 11/05/12 By Dido 預設 fap56 為 0
# Modify.........: No.FUN-B50090 11/06/01 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50118 11/06/13 By belle 自動產生鍵增加族群編號QBE條件
# Modify.........: No.TQC-B60061 11/06/15 By yinhy 自動產生單身時無法新增至單身
# Modify.........: No.FUN-B80054 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-B80147 11/08/23 By lilingyu 自動帶出單身時,增加INPUT科目欄位,
# Modify.........: No:FUN-B60140 11/08/23 By zhangweib "財簽二二次改善"追單
# Modify.........: NO:FUN-B90004 11/09/20 By Belle 自動拋轉傳票單別一欄有值，即可進行傳票拋轉/傳票拋轉還原
# Modify.........: NO:FUN-B80081 11/11/01 By Sakura faj105相關程式段Mark
# Modify.........: NO:FUN-B90096 11/11/03 By Sakura 將UPDATE faj_file拆分出財一、財二
# Modify.........: No:FUN-BC0004 11/12/01 By xuxz 處理相關財簽二無法存檔問題
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 原使用fahdmy3判斷的程式，將財二部份拆分出來使用fahdmy32處理
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.MOD-C50255 12/06/05 By Polly 增加控卡維護拋轉總帳單別
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C60010 12/06/15 By jinjj 財簽二欄位需依財簽二幣別做取位
# Modify.........: No:CHI-C90051 12/09/08 By Polly 將拋轉還原程式移至更新確認碼/過帳碼前處理，並判斷傳票編號如不為null時，則RETURN
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-E80012 18/11/29 By lixwz 修改付款日期之後,tic現金流量明細重複

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_faq   RECORD LIKE faq_file.*,
    g_faq_t RECORD LIKE faq_file.*,
    g_faq_o RECORD LIKE faq_file.*,
    g_fahconf       LIKE fah_file.fahconf,
    g_fahpost       LIKE fah_file.fahpost,
    g_far           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    far02     LIKE far_file.far02,
                    far03     LIKE far_file.far03,
                    far031    LIKE far_file.far031,
                    faj06     LIKE faj_file.faj06,
                    far12     LIKE far_file.far12,
                    far121    LIKE far_file.far121,
                    far04     LIKE far_file.far04,
                    far27     LIKE far_file.far27,
                    far05     LIKE far_file.far05,
                    far06     LIKE far_file.far06,
                    far07     LIKE far_file.far07,
                   #far071    LIKE far_file.far071,     #No.FUN-680028   #FUN-AB0088 mark
                    far08     LIKE far_file.far08,  
                   #far081    LIKE far_file.far081,     #No.FUN-680028   #FUN-AB0088 mark
                    far09     LIKE far_file.far09,
                    far10     LIKE far_file.far10,
                    far11     LIKE far_file.far11,     #No.FUN-680028
                   #far111    LIKE far_file.far111     #FUN-AB0088 mark
                    farud01   LIKE far_file.farud01,
                    farud02   LIKE far_file.farud02,
                    farud03   LIKE far_file.farud03,
                    farud04   LIKE far_file.farud04,
                    farud05   LIKE far_file.farud05,
                    farud06   LIKE far_file.farud06,
                    farud07   LIKE far_file.farud07,
                    farud08   LIKE far_file.farud08,
                    farud09   LIKE far_file.farud09,
                    farud10   LIKE far_file.farud10,
                    farud11   LIKE far_file.farud11,
                    farud12   LIKE far_file.farud12,
                    farud13   LIKE far_file.farud13,
                    farud14   LIKE far_file.farud14,
                    farud15   LIKE far_file.farud15
                    END RECORD,
    g_far_t         RECORD
                    far02     LIKE far_file.far02,
                    far03     LIKE far_file.far03,
                    far031    LIKE far_file.far031,
                    faj06     LIKE faj_file.faj06,
                    far12     LIKE far_file.far12,
                    far121    LIKE far_file.far121,
                    far04     LIKE far_file.far04,
                    far27     LIKE far_file.far27,
                    far05     LIKE far_file.far05,
                    far06     LIKE far_file.far06,
                    far07     LIKE far_file.far07,
                   #far071    LIKE far_file.far071,     #No.FUN-680028   #FUN-AB0088 mark
                    far08     LIKE far_file.far08,
                   #far081    LIKE far_file.far081,     #No.FUN-680028   #FUN-AB0088 mark
                    far09     LIKE far_file.far09,
                    far10     LIKE far_file.far10,
                    far11     LIKE far_file.far11,
                   #far111    LIKE far_file.far111     #No.FUN-680028    #FUN-AB0088 mark
                    farud01   LIKE far_file.farud01,
                    farud02   LIKE far_file.farud02,
                    farud03   LIKE far_file.farud03,
                    farud04   LIKE far_file.farud04,
                    farud05   LIKE far_file.farud05,
                    farud06   LIKE far_file.farud06,
                    farud07   LIKE far_file.farud07,
                    farud08   LIKE far_file.farud08,
                    farud09   LIKE far_file.farud09,
                    farud10   LIKE far_file.farud10,
                    farud11   LIKE far_file.farud11,
                    farud12   LIKE far_file.farud12,
                    farud13   LIKE far_file.farud13,
                    farud14   LIKE far_file.farud14,
                    farud15   LIKE far_file.farud15
                    END RECORD,
    g_fah           RECORD LIKE fah_file.*,
    g_faq01_t       LIKE faq_file.faq01,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_t1                LIKE type_file.chr5,           #No.FUN-550034          #No.FUN-680070 VARCHAR(5)
    g_argv1         LIKE type_file.chr20,            # 單據編號                    #TQC-630073          #No.FUN-680070 VARCHAR(16)
    g_argv2         STRING,             # 指定執行功能:query or inser  #TQC-630073
    l_modify_flag       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    l_flag              LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    g_rec_b             LIKE type_file.num5,                #單身筆數       #No.FUN-680070 SMALLINT
    l_ac                LIKE type_file.num5                 #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
 
DEFINE g_bookno1        LIKE aza_file.aza81   #No.FUN-740033
DEFINE g_bookno2        LIKE aza_file.aza82   #No.FUN-740033
DEFINE g_flag           LIKE type_file.chr1   #No.FUN-740033
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_chr                 LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_i                   LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE g_str          STRING            #No.FUN-670060
DEFINE g_wc_gl        STRING            #No.FUN-670060
DEFINE g_dbs_gl       LIKE type_file.chr21           #No.FUN-670060       #No.FUN-680070 VARCHAR(21)
DEFINE g_far05        LIKE far_file.far05
DEFINE g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5         #No.FUN-680070 SMALLINT
#-----FUN-AB0088--add---str-------------------
DEFINE g_far2   DYNAMIC ARRAY OF RECORD  
                   far02     LIKE far_file.far02,
                   far03     LIKE far_file.far03,
                   far031    LIKE far_file.far031,
                   faj06     LIKE faj_file.faj06,
                   far12     LIKE far_file.far12,
                   far121    LIKE far_file.far121,
                   far042    LIKE far_file.far042,
                   far272    LIKE far_file.far272,
                   far071    LIKE far_file.far071,
                   far081    LIKE far_file.far081,
                   far092    LIKE far_file.far092,
                   far102    LIKE far_file.far102,
                   far111    LIKE far_file.far111
                END RECORD,
       g_far2_t RECORD
                   far02     LIKE far_file.far02,
                   far03     LIKE far_file.far03,
                   far031    LIKE far_file.far031,
                   faj06     LIKE faj_file.faj06,
                   far12     LIKE far_file.far12,
                   far121    LIKE far_file.far121,
                   far042    LIKE far_file.far042,
                   far272    LIKE far_file.far272,
                   far071    LIKE far_file.far071,
                   far081    LIKE far_file.far081,
                   far092    LIKE far_file.far092,
                   far102    LIKE far_file.far102,
                   far111    LIKE far_file.far111
                END RECORD 
#-----FUN-AB0088---add---end---------------

#FUN-B80147 --begin--
DEFINE g_far07               LIKE far_file.far07
DEFINE g_far08               LIKE far_file.far08
DEFINE g_far11               LIKE far_file.far11
#FUN-B80147 --end--
#CHI-C60010---str---
DEFINE g_azi04_1  LIKE azi_file.azi04,
       g_faj143   LIKE faj_file.faj143
#CHI-C60010---end---
 
MAIN
DEFINE
    l_sql            LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
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
 
 
    IF INT_FLAG THEN EXIT PROGRAM END IF
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                     #NO.FUN-6A0069
 
    LET g_forupd_sql = "SELECT * FROM faq_file WHERE faq01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t101_cl CURSOR FROM g_forupd_sql
 
    LET g_argv1=ARG_VAL(1)
    LET g_argv2=ARG_VAL(2)  #TQC-630073
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW t101_w AT p_row,p_col              #顯示畫面
          WITH FORM "afa/42f/afat101"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
   #FUN-AB0088---mark---str---
   #IF g_aza.aza63 = 'Y' THEN
   #   CALL cl_set_comp_visible("far071,far081,far111",TRUE)
   #ELSE
   #   CALL cl_set_comp_visible("far071,far081,far111",FALSE)
   #END IF
   #FUN-AB0088---mark---end---

   #FUN-AB0088---add---str---
    IF g_faa.faa31 = 'Y' THEN  
       CALL cl_set_act_visible("fin_audit2",TRUE)
       CALL cl_set_comp_visible("faq062,faq072",TRUE)  #No:FUN-B60140
    ELSE
       CALL cl_set_act_visible("fin_audit2",FALSE)
       CALL cl_set_comp_visible("faq062,faq072",FALSE)  #No:FUN-B60140
    END IF
   #FUN-AB0088---add---end---

    #CHI-C60010--add--str--
       SELECT aaa03 INTO g_faj143 FROM aaa_file
        WHERE aaa01 = g_faa.faa02c
       IF NOT cl_null(g_faj143) THEN
          SELECT azi04 INTO g_azi04_1 FROM azi_file
           WHERE azi01 = g_faj143
       END IF
    #CHI-C60010--add--end
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t101_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t101_a()
            END IF
         OTHERWISE
            CALL t101_q()
      END CASE
   END IF
    CALL t101_menu()
    CLOSE WINDOW t101_w                    #結束畫面
      CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                                                      #NO.FUN-6A0069
END MAIN
 
FUNCTION t101_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_far.clear()
    IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INITIALIZE g_faq.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        faq01,faq02,faq03,faq06,faq07,faq062,faq072,  #No:FUN-B60140
        faqconf,faqpost,faquser,faqgrup,faqmodu,faqdate
        ,faqud01,faqud02,faqud03,faqud04,faqud05,
        faqud06,faqud07,faqud08,faqud09,faqud10,
        faqud11,faqud12,faqud13,faqud14,faqud15
 
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION controlp
           CASE
              WHEN INFIELD(faq01)    #查詢單據性質
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_faq"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faq01
                 NEXT FIELD faq01
 
              WHEN INFIELD(faq03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = '1'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faq03
                 NEXT FIELD faq03
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
    ELSE
      LET g_wc = " faq01='",g_argv1,"'"
    END IF

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('faquser', 'faqgrup')
 
    IF cl_null(g_argv1) THEN
    CONSTRUCT g_wc2 ON far02,far03,far031,faj06,far12,far121,
                      #far04,far27,far05,far06,far07,far071,far08,far081,     #No.FUN-680028  #FUN-AB0088 mark
                      #far09,far10,far11,far111     #No.FUN-680028            #FUN-AB0088 mark
                       far04,far27,far05,far06,far07,far08,     #No.FUN-680028   #FUN-AB0088 add 
                       far09,far10,far11     #No.FUN-680028     #FUN-AB0088 add
                      ,farud01,farud02,farud03,farud04,farud05
                      ,farud06,farud07,farud08,farud09,farud10
                      ,farud11,farud12,farud13,farud14,farud15
            FROM s_far[1].far02, s_far[1].far03,  s_far[1].far031,s_far[1].faj06,
                 s_far[1].far12, s_far[1].far121,s_far[1].far04,
                 s_far[1].far27,s_far[1].far05, s_far[1].far06,
                #s_far[1].far07,s_far[1].far071,s_far[1].far08,      #No.FUN-680028  #FUN-AB0088 mark
                 s_far[1].far07,s_far[1].far08,      #No.FUN-680028  #FUN-AB0088 add
                #s_far[1].far081,s_far[1].far09,     #No.FUN-680028  #FUN-AB0088 mark
                 s_far[1].far09,     #No.FUN-680028  #FUN-AB0088 adD
                #s_far[1].far10, s_far[1].far11,s_far[1].far111     #No.FUN-680028  #FUN-AB0088 mark
                 s_far[1].far10, s_far[1].far11     #No.FUN-680028  #FUN-AB0088 add
                 ,s_far[1].farud01,s_far[1].farud02,s_far[1].farud03
                 ,s_far[1].farud04,s_far[1].farud05,s_far[1].farud06
                 ,s_far[1].farud07,s_far[1].farud08,s_far[1].farud09
                 ,s_far[1].farud10,s_far[1].farud11,s_far[1].farud12
                 ,s_far[1].farud13,s_far[1].farud14,s_far[1].farud15
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION controlp    #ok
           CASE
              WHEN INFIELD(far03)  #財產編號,財產附號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO far03
                 NEXT FIELD far03
        WHEN INFIELD(far05)  #保管部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO far05
                 NEXT FIELD far05
        WHEN INFIELD(far06)  #存放位置
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faf"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO far06
                 NEXT FIELD far06
        WHEN INFIELD(far07)  #資產科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO far07
                 NEXT FIELD far07
       #FUN-AB0088---mark---str-------------------- 
       #WHEN INFIELD(far071)  #資產科目
       #         CALL cl_init_qry_var()
       #         LET g_qryparam.form = "q_aag"
       #         LET g_qryparam.state = "c"
       #         LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
       #         CALL cl_create_qry() RETURNING g_qryparam.multiret
       #         DISPLAY g_qryparam.multiret TO far071
       #         NEXT FIELD far071
       #FUN-AB0088---mark----end--------------  
        WHEN INFIELD(far08)  #累折科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO far08
                 NEXT FIELD far08
       #FUN-AB0088---mark---str---- 
       #WHEN INFIELD(far081)  #累折科目
       #         CALL cl_init_qry_var()
       #         LET g_qryparam.form = "q_aag"
       #         LET g_qryparam.state = "c"
       #         LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
       #         CALL cl_create_qry() RETURNING g_qryparam.multiret
       #         DISPLAY g_qryparam.multiret TO far081
       #         NEXT FIELD far081
       #FUN-AB0088---mark---end---
        WHEN INFIELD(far10)  #分攤部門
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO far10
                    NEXT FIELD far10
        WHEN INFIELD(far11)  #折舊科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO far11
                 NEXT FIELD far11
       #FUN-AB0088---mark---str--- 
       #WHEN INFIELD(far111)  #折舊科目
       #         CALL cl_init_qry_var()
       #         LET g_qryparam.form = "q_aag"
       #         LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
       #         LET g_qryparam.state = "c"
       #         CALL cl_create_qry() RETURNING g_qryparam.multiret
       #         DISPLAY g_qryparam.multiret TO far111
       #         NEXT FIELD far111 
       #FUN-AB0088---mark----end---------      
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
    ELSE
       LET g_wc2 = " 1=1"
    END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT faq01 FROM faq_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT faq_file.faq01 ",
                   "  FROM faq_file, far_file",
                   " WHERE faq01 = far01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
    PREPARE t101_prepare FROM g_sql
    DECLARE t101_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t101_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM faq_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT faq01) FROM faq_file,far_file",
                  " WHERE far01 = faq01 ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED
    END IF
    PREPARE t101_precount FROM g_sql
    DECLARE t101_count CURSOR WITH HOLD FOR t101_precount
END FUNCTION
 
FUNCTION t101_menu()
 
   WHILE TRUE
      CALL t101_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t101_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t101_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t101_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t101_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t101_b()
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
               CALL t101_g()
               CALL t101_b_fill('1=1 ')
               CALL t101_b()
            END IF
         WHEN "entry_sheet"
            IF cl_chk_act_auth() AND not cl_null(g_faq.faq01) THEN
               CALL s_fsgl('FA','1',g_faq.faq01,0,g_faa.faa02b,1,g_faq.faqconf,'0',g_faa.faa02p)
               CALL t101_npp02('0')  #No.+087 010502 by plum
            END IF
         WHEN "entry_sheet2"
            IF cl_chk_act_auth() AND not cl_null(g_faq.faq01) THEN
               CALL s_fsgl('FA','1',g_faq.faq01,0,g_faa.faa02c,1,g_faq.faqconf,'1',g_faa.faa02p)
               CALL t101_npp02('1')  #No.+087 010502 by plum
            END IF
 
         WHEN "gen_entry"
            IF cl_chk_act_auth() AND g_faq.faqconf <> 'X' THEN
               IF g_faq.faqconf='N' THEN
                  LET g_success='Y' #no.5573
                  BEGIN WORK #no.5573
                  CALL s_showmsg_init()    #No.FUN-710028
                  CALL t101_gl(g_faq.faq01,g_faq.faq02,'0')
                 #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN  #FUN-AB0088 mark
                  IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN  #FUN-AB0088 add
                     CALL t101_gl(g_faq.faq01,g_faq.faq02,'1')
                  END IF
                  CALL s_showmsg() #No.FUN-710028
                  IF g_success='Y' THEN
                     COMMIT WORK
                  ELSE
                     ROLLBACK WORK
                  END IF #no.5573
               ELSE
                  CALL cl_err(g_faq.faq01,'afa-350',0)
            END IF
          END IF
 
         WHEN "carry_voucher" 
            IF cl_chk_act_auth() THEN
               IF g_faq.faqpost = 'Y' THEN   #No.FUN-680028
                  CALL t101_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-557',1) #No.FUN-680028
               END IF 
            END IF 
 
         WHEN "undo_carry_voucher" 
            IF cl_chk_act_auth() THEN
               IF g_faq.faqpost = 'Y' THEN   #No.FUN-680028
                  CALL t101_undo_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-558',1) #No.FUN-680028
               END IF 
            END IF
         
         #FUN-AB0088---add---str---
         WHEN "fin_audit2"
            IF cl_chk_act_auth() THEN
               CALL t101_fin_audit2()
            END IF 
         #FUN-AB0088---add---end---
 
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t101_x()           #FUN-D20035
               CALL t101_x(1)           #FUN-D20035
            END IF

         #FUN-D20035---add--str
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t101_x(2) 
            END IF
         #FUN-D20035---add---end

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t101_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t101_z()
            END IF
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t101_s()
            END IF
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t101_w()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_faq.faq01 IS NOT NULL THEN
                  LET g_doc.column1 = "faq01"
                  LET g_doc.value1 = g_faq.faq01
                  CALL cl_doc()
               END IF
            END IF
 
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_far),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t101_a()
 
    DEFINE  li_result LIKE type_file.num5         #No.FUN-680070 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_far.clear()
    INITIALIZE g_faq.* TO NULL
    LET g_faq01_t = NULL
    LET g_faq_o.* = g_faq.*
    LET g_faq_t.* = g_faq.*
 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_faq.faq02  =g_today
        LET g_faq.faqconf='N'
        LET g_faq.faqpost='N'
        LET g_faq.faqprsw=0
        LET g_faq.faquser=g_user
        LET g_faq.faqoriu = g_user #FUN-980030
        LET g_faq.faqorig = g_grup #FUN-980030
        LET g_faq.faqgrup=g_grup
        LET g_faq.faqdate=g_today
        LET g_faq.faqlegal= g_legal    #FUN-980003 add
 
        CALL t101_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0
           INITIALIZE g_faq.* TO NULL
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        IF g_faq.faq01 IS NULL THEN       #KEY不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK  #No:7837
        CALL s_auto_assign_no("afa",g_faq.faq01,g_faq.faq02,"","faq_file","faq01","","","")
           RETURNING li_result,g_faq.faq01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_faq.faq01

        INSERT INTO faq_file VALUES (g_faq.*)
        IF SQLCA.SQLCODE THEN
           CALL cl_err3("ins","faq_file",g_faq.faq01,"",SQLCA.sqlcode,"","Ins:",1)  #No.FUN-660136   #No.FUN-B80054---調整至回滾事務前---
           ROLLBACK WORK  #No:7837
           CONTINUE WHILE
        ELSE
           COMMIT WORK   #No:7837
        END IF
        COMMIT WORK
        CALL cl_flow_notify(g_faq.faq01,'I')
        CALL g_far.clear()
        LET g_rec_b=0
        LET g_faq_t.* = g_faq.*
        LET g_faq01_t = g_faq.faq01
        SELECT faq01 INTO g_faq.faq01
          FROM faq_file
         WHERE faq01 = g_faq.faq01
        CALL t101_g()         #自動產生單身
         CALL t101_b_fill('1=1 ')        #No.MOD-4A0196
        CALL t101_b()
        CALL t101_gl(g_faq.faq01,g_faq.faq02,'0')
       #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 mark
        IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 add
           CALL t101_gl(g_faq.faq01,g_faq.faq02,'1')
        END IF
        #---判斷是否直接列印,確認,過帳---------
        LET g_t1 = s_get_doc_no(g_faq.faq01)  #No.FUN-550034
        SELECT fahconf,fahpost INTO g_fahconf,g_fahpost
          FROM fah_file
         WHERE fahslip = g_t1
        IF g_fahconf = 'Y' THEN CALL t101_y() END IF
        IF g_fahpost = 'Y' THEN CALL t101_s() END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t101_u()
  DEFINE l_tic01     LIKE tic_file.tic01       #FUN-E80012 add
  DEFINE l_tic02     LIKE tic_file.tic02       #FUN-E80012 add
   IF s_shut(0) THEN RETURN END IF
 
    IF g_faq.faq01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_faq.* FROM faq_file WHERE faq01 = g_faq.faq01
    IF g_faq.faqconf = 'Y' THEN
       CALL cl_err(' ','afa-096',0)
       RETURN
    END IF
    IF g_faq.faqconf = 'X' THEN
       CALL cl_err(' ','9024',0)
       RETURN
    END IF
    IF g_faq.faqpost = 'Y' THEN
       CALL cl_err(' ','afa-101',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_faq01_t = g_faq.faq01
    LET g_faq_o.* = g_faq.*
    BEGIN WORK
 
    OPEN t101_cl USING g_faq.faq01
    IF STATUS THEN
       CALL cl_err("OPEN t101_cl:", STATUS, 1)
       CLOSE t101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t101_cl INTO g_faq.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faq.faq01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t101_cl ROLLBACK WORK RETURN
    END IF
    CALL t101_show()
    WHILE TRUE
        LET g_faq01_t = g_faq.faq01
        LET g_faq.faqmodu=g_user
        LET g_faq.faqdate=g_today
        CALL t101_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_faq.*=g_faq_t.*
            CALL t101_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_faq.faq01 != g_faq_t.faq01 THEN
           UPDATE far_file SET far01=g_faq.faq01 WHERE far01=g_faq_t.faq01
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("upd","far_file",g_faq_t.faq01,"",SQLCA.sqlcode,"","upd far01",1)  #No.FUN-660136
              LET g_faq.*=g_faq_t.*
              CALL t101_show()
              CONTINUE WHILE
           END IF
        END IF
        UPDATE faq_file SET * = g_faq.*
         WHERE faq01 = g_faq.faq01
        IF SQLCA.SQLERRD[3] = 0 OR SQLCA.SQLCODE THEN
           CALL cl_err3("upd","faq_file",g_faq.faq01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
           CONTINUE WHILE
        END IF
        IF g_faq.faq02 != g_faq_t.faq02 THEN            # 更改單號
           UPDATE npp_file SET npp02=g_faq.faq02
            WHERE npp01=g_faq.faq01 AND npp00=1 AND npp011=1
              AND nppsys = 'FA'
           IF STATUS THEN 
              CALL cl_err3("upd","npp_file",g_faq.faq01,"",STATUS,"","upd npp02:",1)  #No.FUN-660136
           END IF
           #FUN-E80012---add---str---
           SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
           IF g_nmz.nmz70 = '3' THEN
              LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_faq.faq02,1)
              LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_faq.faq02,3)
              UPDATE tic_file SET tic01=l_tic01,
                                  tic02=l_tic02
              WHERE tic04=g_faq.faq01
              IF STATUS THEN
                 CALL cl_err3("upd","tic_file",g_faq.faq01,"",STATUS,"","upd tic01,tic02:",1)
              END IF
           END IF
           #FUN-E80012---add---end---
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t101_cl
    COMMIT WORK
    CALL cl_flow_notify(g_faq.faq01,'U')
END FUNCTION
 
FUNCTION t101_npp02(p_npptype)
  DEFINE p_npptype   LIKE npp_file.npptype     #No.FUN-680028
  DEFINE l_tic01     LIKE tic_file.tic01       #FUN-E80012 add
  DEFINE l_tic02     LIKE tic_file.tic02       #FUN-E80012 add
 
   IF p_npptype = '0' THEN    #FUN-B60140    Add
      IF g_faq.faq06 IS NULL OR g_faq.faq06=' ' THEN
         UPDATE npp_file SET npp02=g_faq.faq02
          WHERE npp01=g_faq.faq01 AND npp00=1 AND npp011=1
            AND nppsys = 'FA'
            AND npptype = p_npptype     #No.FUN-680028
         IF STATUS THEN 
            CALL cl_err3("upd","npp_file",g_faq.faq01,"",STATUS,"","upd npp02:",1)  #No.FUN-660136
         END IF
         #FUN-E80012---add---str---
         SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
         IF g_nmz.nmz70 = '3' THEN
            LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_faq.faq02,1)
            LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_faq.faq02,3)
            UPDATE tic_file SET tic01=l_tic01,
                                tic02=l_tic02
            WHERE tic04=g_faq.faq01
            IF STATUS THEN
               CALL cl_err3("upd","tic_file",g_faq.faq01,"",STATUS,"","upd tic01,tic02:",1)
            END IF
         END IF
      END IF
  #FUN-B60140   ---start   Add
   ELSE
      IF g_faq.faq062 IS NULL OR g_faq.faq062=' ' THEN
         UPDATE npp_file SET npp02=g_faq.faq02
          WHERE npp01=g_faq.faq01 AND npp00=1 AND npp011=1
            AND nppsys = 'FA'
            AND npptype = p_npptype
         IF STATUS THEN
            CALL cl_err3("upd","npp_file",g_faq.faq01,"",STATUS,"","upd npp02:",1)
         END IF
         #FUN-E80012---add---str---
         SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
         IF g_nmz.nmz70 = '3' THEN
            LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_faq.faq02,1)
            LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_faq.faq02,3)
            UPDATE tic_file SET tic01=l_tic01,
                                tic02=l_tic02
            WHERE tic04=g_faq.faq01
            IF STATUS THEN
               CALL cl_err3("upd","tic_file",g_faq.faq01,"",STATUS,"","upd tic01,tic02:",1)
            END IF
         END IF
         #FUN-E80012---add---end---
      END IF
   END IF
  #FUN-B60140   ---end     Add
END FUNCTION
 
#處理INPUT
FUNCTION t101_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1,   #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
         l_flag          LIKE type_file.chr1,   #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
         l_bdate,l_edate LIKE type_file.dat,    #No.FUN-680070 DATE
         l_n1            LIKE type_file.num5    #No.FUN-680070 SMALLINT
  DEFINE  li_result LIKE type_file.num5         #No.FUN-680070 SMALLINT
    CALL cl_set_head_visible("","YES")          #No.FUN-6B0029 
 
    INPUT BY NAME g_faq.faqoriu,g_faq.faqorig,
        g_faq.faq01,g_faq.faq02,g_faq.faq03,
        g_faq.faq06,g_faq.faq07,g_faq.faq062,g_faq.faq072,g_faq.faqconf,g_faq.faqpost,    #FUN-B60140   Add faq062 faq072
        g_faq.faquser,g_faq.faqgrup,g_faq.faqmodu,g_faq.faqdate
       ,g_faq.faqud01,g_faq.faqud02,g_faq.faqud03,g_faq.faqud04,
        g_faq.faqud05,g_faq.faqud06,g_faq.faqud07,g_faq.faqud08,
        g_faq.faqud09,g_faq.faqud10,g_faq.faqud11,g_faq.faqud12,
        g_faq.faqud13,g_faq.faqud14,g_faq.faqud15 
           WITHOUT DEFAULTS
 
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t101_set_entry(p_cmd)
          CALL t101_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("faq01")
 
 
        BEFORE FIELD faq01
          IF p_cmd = 'u' AND g_chkey = 'N' THEN
             NEXT FIELD faq02
          END IF
 
        AFTER FIELD faq01
            IF NOT cl_null(g_faq.faq01) THEN
            CALL s_check_no("afa",g_faq.faq01,g_faq01_t,"1","faq_file","faq01","")
                 RETURNING li_result,g_faq.faq01
            DISPLAY BY NAME g_faq.faq01
              IF (NOT li_result) THEN
                 NEXT FIELD faq01
              END IF
 

               SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1

            END IF
            LET g_faq_o.faq01 = g_faq.faq01
 
        AFTER FIELD faq02
            IF NOT cl_null(g_faq.faq02) THEN #MOD-9A0090   
               CALL s_azn01(g_faa.faa07,g_faa.faa08) RETURNING l_bdate,l_edate
               IF g_faq.faq02 < l_bdate
               THEN CALL cl_err(g_faq.faq02,'afa-130',0)
                    NEXT FIELD faq02
               END IF
              #FUN-B60140   ---start   Add
               IF g_faa.faa31 = "Y" THEN
                  CALL s_azn01(g_faa.faa072,g_faa.faa082) RETURNING l_bdate,l_edate
                  IF g_faq.faq02 < l_bdate THEN
                     CALL cl_err(g_faq.faq02,'afa-130',0)
                     NEXT FIELD faq02
                  END IF
               END IF
              #FUN-B60140   ---end     Add
            END IF
            IF NOT cl_null(g_faq.faq02) THEN
               #FUN-B50090 add begin-------------------------
               #重新抓取關帳日期
               SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
               #FUN-B50090 add -end--------------------------
               IF g_faq.faq02 <= g_faa.faa09 THEN
                  CALL cl_err('','mfg9999',1)
                  NEXT FIELD faq02
               END IF
              #FUN-B60140   ---start   Add
               IF g_faa.faa31 = "Y" THEN
                  IF g_faq.faq02 <= g_faa.faa092 THEN
                     CALL cl_err('','mfg9999',1)
                     NEXT FIELD faq02
                  END IF
               END IF
              #FUN-B60140   ---end     Add
               CALL s_get_bookno(YEAR(g_faq.faq02))
                    RETURNING g_flag,g_bookno1,g_bookno2
               IF g_flag =  '1' THEN  #抓不到帳別
                  CALL cl_err(g_faq.faq02,'aoo-081',1)
                  NEXT FIELD faq02
               END IF
            END IF
 
        AFTER FIELD faq03
            IF NOT cl_null(g_faq.faq03) THEN
               CALL t101_faq03('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_faq.faq03,g_errno,0)
                 LET g_faq.faq03 = g_faq_t.faq03
                 DISPLAY BY NAME g_faq.faq03
                 NEXT FIELD faq03
              END IF
            END IF
            LET g_faq_o.faq03 = g_faq.faq03
 
        AFTER FIELD faqud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faqud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faqud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faqud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faqud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faqud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faqud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faqud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faqud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faqud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faqud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faqud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faqud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faqud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faqud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
         AFTER INPUT
            LET g_faq.faquser = s_get_data_owner("faq_file") #FUN-C10039
            LET g_faq.faqgrup = s_get_data_group("faq_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
        ON ACTION controlp
           CASE
              WHEN INFIELD(faq01)    #查詢單據性質
                  LET g_t1 = s_get_doc_no(g_faq.faq01)   #No.FUN-550034
                 CALL q_fah( FALSE, TRUE,g_t1,'1','AFA') RETURNING g_t1  #TQC-670008
                 LET g_faq.faq01=g_t1   #No.FUN-550034
                 DISPLAY BY NAME g_faq.faq01
                 NEXT FIELD faq01
              WHEN INFIELD(faq03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fag"
                 LET g_qryparam.default1 = g_faq.faq03
                 LET g_qryparam.arg1 = '1'
                 CALL cl_create_qry() RETURNING g_faq.faq03
                 DISPLAY BY NAME g_faq.faq03
                 NEXT FIELD faq03
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
FUNCTION t101_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("faq01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t101_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("faq01",FALSE)
    END IF
 
END FUNCTION
 
 
FUNCTION t101_faq03(p_cmd)
 DEFINE   p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_fag03    LIKE fag_file.fag03,
          l_fagacti  LIKE fag_file.fagacti
 
    LET g_errno = ' '
    SELECT fag03,fagacti INTO l_fag03,l_fagacti FROM fag_file
     WHERE fag01 = g_faq.faq03 AND fag02 = '1'
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno ='afa-099'
                                 LET l_fag03 = NULL
                                 LET l_fagacti = NULL
        WHEN l_fagacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd'
   THEN DISPLAY l_fag03 TO FORMONLY.fag03
   END IF
END FUNCTION
 
FUNCTION t101_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_faq.* TO NULL             #No.FUN-6A0001
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t101_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_faq.* TO NULL
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t101_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_faq.* TO NULL
    ELSE
        OPEN t101_count
        FETCH t101_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t101_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t101_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t101_cs INTO g_faq.faq01
        WHEN 'P' FETCH PREVIOUS t101_cs INTO g_faq.faq01
        WHEN 'F' FETCH FIRST    t101_cs INTO g_faq.faq01
        WHEN 'L' FETCH LAST     t101_cs INTO g_faq.faq01
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
            FETCH ABSOLUTE g_jump t101_cs INTO g_faq.faq01
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faq.faq01,SQLCA.sqlcode,0)
        INITIALIZE g_faq.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_faq.* FROM faq_file WHERE faq01 = g_faq.faq01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","faq_file",g_faq.faq01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
        INITIALIZE g_faq.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_faq.faquser   #FUN-4C0059
    LET g_data_group = g_faq.faqgrup   #FUn-4C0059
    CALL s_get_bookno(YEAR(g_faq.faq02)) #TQC-740042
         RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag =  '1' THEN  #抓不到帳別
       CALL cl_err(g_faq.faq02,'aoo-081',1)
    END IF
    CALL t101_show()
END FUNCTION
 
FUNCTION t101_show()
    LET g_faq_t.* = g_faq.*                #保存單頭舊值
    DISPLAY BY NAME g_faq.faqoriu,g_faq.faqorig,
 
 
        g_faq.faq01,g_faq.faq02,g_faq.faq03,g_faq.faq06,g_faq.faq07,g_faq.faq062,g_faq.faq072,  #No:FUN-B60140
        g_faq.faqconf,g_faq.faqpost,
        g_faq.faquser,g_faq.faqgrup,g_faq.faqmodu,g_faq.faqdate
       ,g_faq.faqud01,g_faq.faqud02,g_faq.faqud03,g_faq.faqud04,
        g_faq.faqud05,g_faq.faqud06,g_faq.faqud07,g_faq.faqud08,
        g_faq.faqud09,g_faq.faqud10,g_faq.faqud11,g_faq.faqud12,
        g_faq.faqud13,g_faq.faqud14,g_faq.faqud15 
 
    IF g_faq.faqconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_faq.faqconf,"",g_faq.faqpost,"",g_chr,"")
     LET g_t1 = s_get_doc_no(g_faq.faq01)  #No.FUN-550034
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
    CALL t101_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t101_r()
 DEFINE l_chr,l_sure LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 DEFINE l_far        RECORD LIKE far_file.*
 
    IF s_shut(0) THEN RETURN END IF
    IF g_faq.faq01 IS NULL THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    SELECT * INTO g_faq.* FROM faq_file WHERE faq01 = g_faq.faq01
    IF g_faq.faqconf = 'Y' THEN
       CALL cl_err('','afa-096',0) RETURN
    END IF
    IF g_faq.faqconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    IF g_faq.faqpost = 'Y' THEN
       CALL cl_err(' ','afa-101',0) RETURN
    END IF
    BEGIN WORK
 
    OPEN t101_cl USING g_faq.faq01
    IF STATUS THEN
       CALL cl_err("OPEN t101_cl:", STATUS, 1)
       CLOSE t101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t101_cl INTO g_faq.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_faq.faq01,SQLCA.sqlcode,0)
       CLOSE t101_cl ROLLBACK WORK RETURN
    END IF
    CALL t101_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "faq01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_faq.faq01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete faq,far,npp,npq!"
        DELETE FROM faq_file WHERE faq01 = g_faq.faq01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","faq_file",g_faq.faq01,"",SQLCA.sqlcode,"","No faq deleted",1)  #No.FUN-660136
        ELSE
           CLEAR FORM
           CALL g_far.clear()
        END IF
        DECLARE del_cur CURSOR FOR
             SELECT * FROM far_file,faj_file 
              WHERE far01=g_faq.faq01 
                AND far03 = faj02     #財編
                AND far031= faj022    #附號
                AND faj021 = '3'      #型態:3.附加費用
        FOREACH del_cur INTO l_far.*
            DELETE FROM faj_file WHERE faj02=l_far.far03 AND faj022=l_far.far031  #CHI-8A0021 add
                                   AND faj021 = '3'   #MOD-950185
        END FOREACH
        DELETE FROM far_file WHERE far01 = g_faq.faq01
        DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 1
                               AND npp01 = g_faq.faq01
                               AND npp011= 1
        DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 1
                               AND npq01 = g_faq.faq01
                               AND npq011= 1
        #FUN-B40056--add--str--
        DELETE FROM tic_file WHERE tic04 = g_faq.faq01
        #FUN-B40056--add--end--
        LET g_msg = TIME
        INITIALIZE g_faq.* TO NULL
        MESSAGE ""
        CALL g_far.clear()
        OPEN t101_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE t101_cl
           CLOSE t101_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end-- 
        FETCH t101_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t101_cl
           CLOSE t101_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end-- 
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t101_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t101_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t101_fetch('/')
        END IF
 
    END IF
    CLOSE t101_cl
    COMMIT WORK
    CALL cl_flow_notify(g_faq.faq01,'D')
END FUNCTION
 
FUNCTION t101_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT #No.FUN-680070 SMALLINT
    l_row,l_col     LIKE type_file.num5,         #分段輸入之行,列數 #No.FUN-680070 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,         #檢查重複用        #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否        #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,         #處理狀態          #No.FUN-680070 VARCHAR(1)
    l_b2            LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
    l_faj06         LIKE faj_file.faj06,
    l_faj28         LIKE faj_file.faj28,
    l_qty           LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(15,3),
    l_allow_insert  LIKE type_file.num5,         #可新增否          #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5          #可刪除否          #No.FUN-680070 SMALLINT
 
    LET g_action_choice = ""
    IF g_faq.faq01 IS NULL THEN RETURN END IF
    IF g_faq.faqconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_faq.faqconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_faq.faqpost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT far02,far03,far031,' ',far12,far121,far04,far27,far05, ",
                      #" far06,far07,far071,far08,far081,far09,far10,far11,far111 ",     #No.FUN-680028   #FUN-AB0088 mark
                       " far06,far07,far08,far09,far10,far11 ",     #No.FUN-680028   #FUN-AB0088 add
                       ",farud01,farud02,farud03,farud04,farud05,",
                       "farud06,farud07,farud08,farud09,farud10,",
                       "farud11,farud12,farud13,farud14,farud15",
                       " FROM far_file  ",
                       " WHERE far01 = ?   ",
                       "   AND far02 = ?   ",
                       "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t101_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
      LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_far.clear() END IF
 
 
      INPUT ARRAY g_far WITHOUT DEFAULTS FROM s_far.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn2
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
	    BEGIN WORK
 
            OPEN t101_cl USING g_faq.faq01
            IF STATUS THEN
               CALL cl_err("OPEN t101_cl:", STATUS, 1)
               CLOSE t101_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t101_cl INTO g_faq.*  # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_faq.faq01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t101_cl ROLLBACK WORK RETURN
            END IF
             IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_far_t.* = g_far[l_ac].*  #BACKUP
                LET l_flag = 'Y'
 
                OPEN t101_bcl USING g_faq.faq01,g_far_t.far02
                IF STATUS THEN
                   CALL cl_err("OPEN t101_bcl:", STATUS, 1)
                   CLOSE t101_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t101_bcl INTO g_far[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock far',SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
             ELSE
                LET l_flag='N'
                CALL cl_show_fld_cont()     #FUN-550037(smin)
             END IF
                 SELECT faj06 INTO g_far[l_ac].faj06
                   FROM faj_file
                  WHERE faj02=g_far[l_ac].far03
                 LET g_far_t.faj06 =g_far[l_ac].faj06
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              INITIALIZE g_far[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_far[l_ac].* TO s_far.*
              CALL g_far.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
            END IF
            IF (g_far[l_ac].far03 != g_far[l_ac].far12
                  or g_far[l_ac].far031 != g_far[l_ac].far121)
                and  cl_null(g_far[l_ac].far27)
            THEN CALL cl_err(g_far[l_ac].far031,g_errno,1)
                 NEXT FIELD far02
            END IF
            IF g_far[l_ac].far09 = '1' THEN
               IF cl_null(g_far[l_ac].far11) THEN
                  CALL cl_err(g_far[l_ac].far11,'afa-361',0)
                  NEXT FIELD far02
               END IF
            END IF
            IF cl_null(g_far[l_ac].far031) THEN
               LET g_far[l_ac].far031 = ' '
            END IF

             INSERT INTO far_file (far01,far02,far03,far031,far04,far05,  #No.MOD-470041
                                 #far06,far07,far071,far08,far081,far09,far10,far11,far111,far12,     #No.FUN-680028  #FUN-AB0088 mark
                                  far06,far07,far08,far09,far10,far11,far12,     #No.FUN-680028  #FUN-AB0088 add
                                  far121,far13,far27
                                 ,farud01,farud02,farud03,
                                  farud04,farud05,farud06,
                                  farud07,farud08,farud09,
                                  farud10,farud11,farud12,
                                  farud13,farud14,farud15,
                                  farlegal)   #FUN-980003 add
                 VALUES(g_faq.faq01,g_far[l_ac].far02,g_far[l_ac].far03,
                        g_far[l_ac].far031,g_far[l_ac].far04,g_far[l_ac].far05,
                       #g_far[l_ac].far06,g_far[l_ac].far07,g_far[l_ac].far071,     #No.FUN-680028  #FUN-AB0088 mark
                        g_far[l_ac].far06,g_far[l_ac].far07,    #No.FUN-680028  #FUN-AB0088 add
                       #g_far[l_ac].far08,g_far[l_ac].far081,     #No.FUN-680028  #FUN-AB0088 mark
                        g_far[l_ac].far08,    #No.FUN-680028  #FUN-AB0088 add
                       #g_far[l_ac].far09,g_far[l_ac].far10,g_far[l_ac].far11,g_far[l_ac].far111,     #No.FUN-680028  #FUN-AB0088 mark
                        g_far[l_ac].far09,g_far[l_ac].far10,g_far[l_ac].far11,    #No.FUN-680028  #FUN-AB0088 add
                        g_far[l_ac].far12,g_far[l_ac].far121,g_faq.faq03,
                        g_far[l_ac].far27
                       ,g_far[l_ac].farud01, g_far[l_ac].farud02,
                        g_far[l_ac].farud03, g_far[l_ac].farud04,
                        g_far[l_ac].farud05, g_far[l_ac].farud06,
                        g_far[l_ac].farud07, g_far[l_ac].farud08,
                        g_far[l_ac].farud09, g_far[l_ac].farud10,
                        g_far[l_ac].farud11, g_far[l_ac].farud12,
                        g_far[l_ac].farud13, g_far[l_ac].farud14,
                        g_far[l_ac].farud15,
                        g_legal)   #FUN-980003 add
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0  THEN
                CALL cl_err3("ins","far_file",g_faq.faq01,g_far[l_ac].far02,SQLCA.sqlcode,"","ins far",1)  #No.FUN-660136
                CANCEL INSERT
            ELSE MESSAGE 'INSERT O.K'
                 LET g_rec_b=g_rec_b+1
                 DISPLAY g_rec_b TO FORMONLY.cn2
                 COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd = 'a'
            INITIALIZE g_far[l_ac].* TO NULL          #900423
            LET g_far_t.* = g_far[l_ac].*             #新輸入資料
            LET g_far[l_ac].far121=' '
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD far02
 
        BEFORE FIELD far02                            #defaqlt 序號
            IF p_cmd = 'a' OR p_cmd = 'u' THEN
               IF g_far[l_ac].far02 IS NULL OR g_far[l_ac].far02 = 0 THEN
                   SELECT max(far02)+1 INTO g_far[l_ac].far02
                      FROM far_file WHERE far01 = g_faq.faq01
                   IF g_far[l_ac].far02 IS NULL THEN
                       LET g_far[l_ac].far02 = 1
                   END IF
               END IF
            END IF
 
        AFTER FIELD far02                        #check 序號是否重複
            IF NOT cl_null(g_far[l_ac].far02) THEN
               IF g_far[l_ac].far02 != g_far_t.far02 OR
                  g_far_t.far02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM far_file
                    WHERE far01 = g_faq.faq01
                      AND far02 = g_far[l_ac].far02
                   IF l_n > 0 THEN
                       LET g_far[l_ac].far02 = g_far_t.far02
                       CALL cl_err('',-239,0)
                       NEXT FIELD far02
                   END IF
               END IF
            END IF

       #FUN-BC0004--mrak--str
       ##TQC-AB0257 modify ---begin-------------------
       #AFTER FIELD far03
       #   IF g_far[l_ac].far03 != g_far_t.far03 OR
       #      g_far_t.far03 IS NULL THEN
       #      SELECT COUNT(*) INTO l_n FROM faj_file
       #       WHERE fajconf='Y'
       #         AND faj02 = g_far[l_ac].far03
       #      IF l_n <= 0 THEN
       #         LET g_far[l_ac].far03 = g_far_t.far03
       #         CALL cl_err('','afa-911',0)
       #         NEXT FIELD far03
       #      END IF
       #   END IF
       ##TQC-AB0257 modify ----end--------------------
       #FUN-BC0004--mark--end
       #FUN-BC0004--add--str
       AFTER FIELD far03
           IF g_far[l_ac].far031 IS NULL THEN
              LET g_far[l_ac].far031 = ' '
           END IF
           IF NOT cl_null(g_far[l_ac].far03) AND g_far[l_ac].far031 IS NOT NULL THEN
              SELECT count(*) INTO l_n FROM faj_file
               WHERE faj02 = g_far[l_ac].far03
              IF l_n > 0 THEN 
                 CALL t101_far031('a')
                 IF NOT cl_null(g_errno) THEN 
                    CALL cl_err(g_far[l_ac].far031,g_errno,0)
                    NEXT FIELD far031
                 END IF
              ELSE 
                 CALL cl_err(g_far[l_ac].far03,'afa-134',0)
                 LET g_far[l_ac].far03 = g_far_t.far03
                 NEXT FIELD far03
              END IF
              SELECT MAX(faj28) INTO l_faj28 FROM faj_file
               WHERE faj02  = g_far[l_ac].far03
                 AND faj022 = g_far[l_ac].far031
                 AND fajconf = 'Y'
              IF STATUS THEN LET l_faj28=' ' END IF
           END IF 
       #FUN-BC0004--add--end
 
        AFTER FIELD far031
           IF g_far[l_ac].far031 IS NULL THEN
              LET g_far[l_ac].far031 = ' '
           END IF
           CALL t101_far031('a')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_far[l_ac].far031,g_errno,1)
              LET g_far[l_ac].far031 = g_far_t.far031#FUN-BC0004--add
              NEXT FIELD far03
           END IF
           #LET g_far_t.far03  = g_far[l_ac].far03#FUN-BC0004 mark
           #LET g_far_t.far031 = g_far[l_ac].far031#FUN-BC0004 mark
           SELECT MAX(faj28) INTO l_faj28 FROM faj_file
            WHERE faj02  = g_far[l_ac].far03
              AND faj022 = g_far[l_ac].far031
              AND fajconf = 'Y'
           IF STATUS THEN LET l_faj28=' ' END IF
 
        AFTER FIELD far04
           IF cl_null(g_far[l_ac].far05) THEN
              IF g_far[l_ac].far03 != g_far[l_ac].far12 OR
                 g_far[l_ac].far031 != g_far[l_ac].far121
              THEN CALL s_faj27(g_far[l_ac].far04,g_faa.faa15)
                        RETURNING g_far[l_ac].far27
                        DISPLAY BY NAME g_far[l_ac].far27
              END IF
           END IF
 
        AFTER FIELD far05
           IF NOT cl_null(g_far[l_ac].far05) THEN
              CALL t101_far05('a')
                IF NOT cl_null(g_errno) THEN
                   LET g_far[l_ac].far05 = g_far_t.far05
                   DISPLAY BY NAME g_far[l_ac].far05
                   CALL cl_err(g_far[l_ac].far05,g_errno,0)
                   NEXT FIELD far05
               END IF
           END IF
 
        AFTER FIELD far06
           IF NOT cl_null(g_far[l_ac].far06) THEN
              CALL t101_far06('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_far[l_ac].far06,g_errno,0)
                 NEXT FIELD far06
              END IF
           END IF
 
        AFTER FIELD far07
           IF cl_null(g_far[l_ac].far07) THEN
              IF l_faj28<>'0' THEN NEXT FIELD far07 END IF
           ELSE
              CALL t101_acct('a',g_far[l_ac].far07,g_bookno1)  #No.FUN-740033
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_far[l_ac].far07,g_errno,0)
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_far[l_ac].far07 
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_bookno1  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_far[l_ac].far07 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_far[l_ac].far07
                 DISPLAY BY NAME g_far[l_ac].far07
                 #FUN-B10049--end                    
                 NEXT FIELD far07
              END IF
           END IF

       #FUN-AB0088----mark-----str-------------       
       #AFTER FIELD far071
       #   IF cl_null(g_far[l_ac].far071) THEN
       #      IF l_faj28<>'0' THEN NEXT FIELD far071 END IF
       #   ELSE
       #      CALL t101_acct('a',g_far[l_ac].far071,g_bookno2)  #No.FUN-740033
       #      IF NOT cl_null(g_errno) THEN
       #         CALL cl_err(g_far[l_ac].far071,g_errno,0)
       #         #FUN-B10049--begin
       #         CALL cl_init_qry_var()                                         
       #         LET g_qryparam.form ="q_aag"                                   
       #         LET g_qryparam.default1 = g_far[l_ac].far071 
       #         LET g_qryparam.construct = 'N'                
       #         LET g_qryparam.arg1 = g_bookno2  
       #         LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_far[l_ac].far071 CLIPPED,"%' "                                                                        
       #         CALL cl_create_qry() RETURNING g_far[l_ac].far071
       #         DISPLAY BY NAME g_far[l_ac].far071
       #         #FUN-B10049--end                   
       #         NEXT FIELD far071
       #      END IF
       #   END IF
       #FUN-AB0088-----mark----------end----------------
  
        AFTER FIELD far08
           IF cl_null(g_far[l_ac].far08) THEN
              IF l_faj28<>'0' THEN NEXT FIELD far08 END IF
           ELSE
              CALL t101_acct('a',g_far[l_ac].far08,g_bookno1)  #No.FUN-740033
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_far[l_ac].far08,g_errno,0)
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_far[l_ac].far08
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_bookno1  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_far[l_ac].far08 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_far[l_ac].far08
                 DISPLAY BY NAME g_far[l_ac].far08
                 #FUN-B10049--end                     
                 NEXT FIELD far08
              END IF
           END IF

       #FUN-AB0088----mark----str---------- 
       #AFTER FIELD far081
       #   IF cl_null(g_far[l_ac].far081) THEN
       #      IF l_faj28<>'0' THEN NEXT FIELD far081 END IF
       #   ELSE
       #      CALL t101_acct('a',g_far[l_ac].far081,g_bookno2)  #No.FUN-740033
       #      IF NOT cl_null(g_errno) THEN
       #         CALL cl_err(g_far[l_ac].far081,g_errno,0)
       #         #FUN-B10049--begin
       #         CALL cl_init_qry_var()                                         
       #         LET g_qryparam.form ="q_aag"                                   
       #         LET g_qryparam.default1 = g_far[l_ac].far081
       #         LET g_qryparam.construct = 'N'                
       #         LET g_qryparam.arg1 = g_bookno2  
       #         LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_far[l_ac].far081 CLIPPED,"%' "                                                                        
       #         CALL cl_create_qry() RETURNING g_far[l_ac].far081
       #         DISPLAY BY NAME g_far[l_ac].far081
       #         #FUN-B10049--end                   
       #         NEXT FIELD far081
       #      END IF
       #   END IF
       #FUN-AB0088---mark-----end--------------
 
        AFTER FIELD far09
           IF NOT cl_null(g_far[l_ac].far09) THEN
              IF g_far[l_ac].far09 NOT MATCHES '[12]' THEN
                 NEXT FIELD far09
              END IF
           END IF
 
        BEFORE FIELD far10
              IF g_far[l_ac].far09 = '1' THEN
                 IF p_cmd = 'a' THEN
                    CALL cl_err(' ','afa-047',0)
                    LET g_far[l_ac].far10 = g_far[l_ac].far05
                    DISPLAY BY NAME g_far[l_ac].far10
                 END IF
              ELSE
                 CALL cl_err(' ','afa-048',0)
              END IF
 
        AFTER FIELD far10
           IF NOT cl_null(g_far[l_ac].far09) THEN
              IF g_far[l_ac].far09 = '1' THEN
                #CALL t101_far101('a')   #FUN-AB0088  mark
                 CALL t101_far101('a',g_far[l_ac].far10)   #FUN-AB0088 add  
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_far[l_ac].far10,g_errno,0)
                      LET g_far[l_ac].far10 = g_far_t.far10
                      DISPLAY BY NAME g_far[l_ac].far10
                      NEXT FIELD far10
                   END IF
              ELSE
               #CALL t101_far102('a')   #FUN-AB0088 mark
                CALL t101_far102('a','1')   #FUN-AB0088 add
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_far[l_ac].far10,g_errno,1)
                     LET g_far[l_ac].far10 = g_far_t.far10
                     DISPLAY BY NAME g_far[l_ac].far10
                     NEXT FIELD far10
                  END IF
                  IF p_cmd = 'a' THEN
                     LET g_far[l_ac].far11 = ' '
                  END IF
              END IF
            END IF
 
        AFTER FIELD far11
           IF g_far[l_ac].far09 = '1' THEN
              IF cl_null(g_far[l_ac].far11) THEN
                 NEXT FIELD far11
              ELSE
                 CALL t101_acct('a',g_far[l_ac].far11,g_bookno1)  #No.FUN-740033
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_far[l_ac].far11,g_errno,0)
                      #FUN-B10049--begin
                      CALL cl_init_qry_var()                                         
                      LET g_qryparam.form ="q_aag"                                   
                      LET g_qryparam.default1 = g_far[l_ac].far11
                      LET g_qryparam.construct = 'N'                
                      LET g_qryparam.arg1 = g_bookno1  
                      LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_far[l_ac].far11 CLIPPED,"%' "                                                                        
                      CALL cl_create_qry() RETURNING g_far[l_ac].far11
                      DISPLAY BY NAME g_far[l_ac].far11
                      #FUN-B10049--end                            
                      NEXT FIELD far11
                   END IF
              END IF
           ELSE
               LET g_far[l_ac].far11 = ' '
           END IF

       #FUN-AB0088 ----mark----str--------------  
       #AFTER FIELD far111
       #   IF g_far[l_ac].far09 = '1' THEN
       #      IF cl_null(g_far[l_ac].far111) THEN
       #         NEXT FIELD far111
       #      ELSE
       #         CALL t101_acct('a',g_far[l_ac].far111,g_bookno2)  #No.FUN-740033
       #           IF NOT cl_null(g_errno) THEN
       #              CALL cl_err(g_far[l_ac].far111,g_errno,0)
       #              #FUN-B10049--begin
       #              CALL cl_init_qry_var()                                         
       #              LET g_qryparam.form ="q_aag"                                   
       #              LET g_qryparam.default1 = g_far[l_ac].far111
       #              LET g_qryparam.construct = 'N'                
       #              LET g_qryparam.arg1 = g_bookno2  
       #              LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_far[l_ac].far111 CLIPPED,"%' "                                                                        
       #              CALL cl_create_qry() RETURNING g_far[l_ac].far111
       #              DISPLAY BY NAME g_far[l_ac].far111
       #              #FUN-B10049--end                                      
       #              NEXT FIELD far111
       #           END IF
       #      END IF
       #   ELSE
       #       LET g_far[l_ac].far111 = ' '
       #   END IF
       #FUN-AB0088---mark-----end----------------        

        AFTER FIELD far121
           IF cl_null(g_far[l_ac].far121) THEN LET g_far[l_ac].far121=' ' END IF
           IF NOT cl_null(g_far[l_ac].far121) THEN
              SELECT COUNT(*) INTO g_cnt FROM faj_file
               WHERE faj02 =g_far[l_ac].far12
                 AND faj022=g_far[l_ac].far121
                 AND faj43 <>'0'
              IF g_cnt>0 THEN
                 CALL cl_err('','afa-354',0)
                 NEXT FIELD far12
              END IF
           END IF
        AFTER FIELD farud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD farud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD farud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD farud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD farud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD farud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD farud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD farud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD farud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD farud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD farud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD farud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD farud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD farud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD farud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_far_t.far02 > 0 AND g_far_t.far02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM far_file WHERE far01 = g_faq.faq01
                                       AND far02 = g_far_t.far02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","far_file",g_faq.faq01,g_far_t.far02,SQLCA.sqlcode,"","",0)  #No.FUN-660136
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                DELETE FROM faj_file WHERE faj02=g_far[l_ac].far03
                                       AND faj022=g_far[l_ac].far031  #no.CHI-8A0021 mod
                                       AND faj021 = '3'   #MOD-950185 
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_far[l_ac].* = g_far_t.*
               CLOSE t101_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_far[l_ac].far02,-263,1)
               LET g_far[l_ac].* = g_far_t.*
            ELSE
               IF (g_far[l_ac].far03 != g_far[l_ac].far12
                     or g_far[l_ac].far031 != g_far[l_ac].far121)
                    AND cl_null(g_far[l_ac].far27)
               THEN CALL cl_err(g_far[l_ac].far031,g_errno,1)
                    NEXT FIELD far02
               END IF
               IF g_far[l_ac].far09 = '1' THEN
                  IF cl_null(g_far[l_ac].far11) THEN
                     CALL cl_err(g_far[l_ac].far11,'afa-361',0)
                     NEXT FIELD far02
                  END IF
               END IF
               UPDATE far_file SET
                      far01=g_faq.faq01,far02=g_far[l_ac].far02,
                      far03= g_far[l_ac].far03,far031=g_far[l_ac].far031,
                      far04=g_far[l_ac].far04,far05=g_far[l_ac].far05,
                      far06=g_far[l_ac].far06,far07=g_far[l_ac].far07,
                     #FUN-AB0088---mod----str-------------- 
                     #far071=g_far[l_ac].far071,far08=g_far[l_ac].far08,     #No.FUN-680028
                     #far081=g_far[l_ac].far081,far09=g_far[l_ac].far09,     #No.FUN-680028
                     #far10=g_far[l_ac].far10,far11=g_far[l_ac].far11,far111=g_far[l_ac].far111,     #No.FUN-680028
                      far08=g_far[l_ac].far08,     #No.FUN-680028
                      far09=g_far[l_ac].far09,     #No.FUN-680028
                      far10=g_far[l_ac].far10,far11=g_far[l_ac].far11,     #No.FUN-680028
                     #FUN-AB0088---mod----end---------------
                      far12=g_far[l_ac].far12,far121=g_far[l_ac].far121,
                      far13=g_faq.faq03,far27=g_far[l_ac].far27
                     ,farud01 = g_far[l_ac].farud01,
                      farud02 = g_far[l_ac].farud02,
                      farud03 = g_far[l_ac].farud03,
                      farud04 = g_far[l_ac].farud04,
                      farud05 = g_far[l_ac].farud05,
                      farud06 = g_far[l_ac].farud06,
                      farud07 = g_far[l_ac].farud07,
                      farud08 = g_far[l_ac].farud08,
                      farud09 = g_far[l_ac].farud09,
                      farud10 = g_far[l_ac].farud10,
                      farud11 = g_far[l_ac].farud11,
                      farud12 = g_far[l_ac].farud12,
                      farud13 = g_far[l_ac].farud13,
                      farud14 = g_far[l_ac].farud14,
                      farud15 = g_far[l_ac].farud15
                      WHERE far01=g_faq.faq01 AND far02=g_far_t.far02
 
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                  CALL cl_err3("upd","far_file",g_faq.faq01,g_far_t.far02,SQLCA.sqlcode,"","upd far",1)  #No.FUN-660136
                  LET g_far[l_ac].* = g_far_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
             LET l_ac = ARR_CURR()
       #     LET l_ac_t = l_ac                #FUN-D30032 mark
             IF INT_FLAG THEN                 #900423
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd='u' THEN
                   LET g_far[l_ac].* = g_far_t.*
            #FUN-D30032--add--str--
               ELSE
                  CALL g_far.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30032--add--end--
                END IF
                CLOSE t101_bcl
                ROLLBACK WORK
                EXIT INPUT
             END IF
             LET l_ac_t = l_ac                #FUN-D30032 add
             CLOSE t101_bcl
             COMMIT WORK
             CALL g_far.deleteElement(g_rec_b+1)
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(far02) AND l_ac > 1 THEN
                LET g_far[l_ac].* = g_far[l_ac-1].*
                LET g_far[l_ac].far02 = NULL
                NEXT FIELD far02
            END IF
        ON ACTION controlp    #ok
           CASE
              WHEN INFIELD(far03)  #財產編號,財產附號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.default1 = g_far[l_ac].far03
                 LET g_qryparam.default2 = g_far[l_ac].far031
                 CALL cl_create_qry() RETURNING
                      g_far[l_ac].far03,g_far[l_ac].far031
                 DISPLAY g_far[l_ac].far03  TO far03
                 DISPLAY g_far[l_ac].far031 TO far031
                 CALL t101_far031('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(' ',g_errno,0)
                    NEXT FIELD far03
                 END IF
                 NEXT FIELD far03
        WHEN INFIELD(far05)  #保管部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_far[l_ac].far05
                 CALL cl_create_qry() RETURNING g_far[l_ac].far05
                 DISPLAY g_far[l_ac].far05 TO far05
                 NEXT FIELD far05
        WHEN INFIELD(far06)  #存放位置
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faf"
                 LET g_qryparam.default1 = g_far[l_ac].far06
                 CALL cl_create_qry() RETURNING g_far[l_ac].far06
                 DISPLAY g_far[l_ac].far06 TO far06
                 NEXT FIELD far06
        WHEN INFIELD(far07)  #資產科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
                 LET g_qryparam.default1 = g_far[l_ac].far07
                 LET g_qryparam.arg1 = g_bookno1   #No.FUN-740033
                 CALL cl_create_qry() RETURNING g_far[l_ac].far07
                 DISPLAY g_far[l_ac].far07 TO far07
                 NEXT FIELD far07
#FUN-AB0088---mark-----str---------------
#       WHEN INFIELD(far071)  #資產科目
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_aag"
#                LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
#                LET g_qryparam.default1 = g_far[l_ac].far071
#                LET g_qryparam.arg1 = g_bookno2   #No.FUN-740033
#                CALL cl_create_qry() RETURNING g_far[l_ac].far071
#                DISPLAY g_far[l_ac].far071 TO far071
#                NEXT FIELD far071
#FUN-AB0088---mark----end--------------------
        WHEN INFIELD(far08)  #累折科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
                 LET g_qryparam.default1 = g_far[l_ac].far08
                 LET g_qryparam.arg1 = g_bookno1   #No.FUN-740033
                 CALL cl_create_qry() RETURNING g_far[l_ac].far08
                 DISPLAY g_far[l_ac].far08 TO far08
                 NEXT FIELD far08
#FUN-AB0088---mark-----str---------------
#       WHEN INFIELD(far081)  #累折科目
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_aag"
#                LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
#                LET g_qryparam.default1 = g_far[l_ac].far081
#                LET g_qryparam.arg1 = g_bookno2   #No.FUN-740033
#                CALL cl_create_qry() RETURNING g_far[l_ac].far081
#                DISPLAY g_far[l_ac].far081 TO far081
#                NEXT FIELD far081
#FUN-AB0088---mark----end--------------------
        WHEN INFIELD(far10)  #分攤部門
                 IF g_far[l_ac].far09 ='1' THEN   #單一部門
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.default1 = g_far[l_ac].far10
                    CALL cl_create_qry() RETURNING g_far[l_ac].far10
                    DISPLAY g_far[l_ac].far10 TO far10
                    NEXT FIELD far10
                 ELSE
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ='q_fad'
                    LET g_qryparam.default1 = g_far[l_ac].far10
                    CALL cl_create_qry() RETURNING g_far[l_ac].far07,g_far[l_ac].far10
                    DISPLAY BY NAME g_far[l_ac].far07
                    DISPLAY BY NAME g_far[l_ac].far10
                    NEXT FIELD far10
                 END IF
        WHEN INFIELD(far11)  #折舊科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
                 LET g_qryparam.default1 = g_far[l_ac].far11
                 LET g_qryparam.arg1 = g_bookno1   #No.FUN-740033
                 CALL cl_create_qry() RETURNING g_far[l_ac].far11
                 DISPLAY g_far[l_ac].far11 TO far11
                 NEXT FIELD far11
#FUN-AB0088---mark----str--------------------
#       WHEN INFIELD(far111)  #折舊科目
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_aag"
#                LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
#                LET g_qryparam.default1 = g_far[l_ac].far111
#                LET g_qryparam.arg1 = g_bookno2   #No.FUN-740033
#                CALL cl_create_qry() RETURNING g_far[l_ac].far111
#                DISPLAY g_far[l_ac].far111 TO far111
#                NEXT FIELD far111
#FUN-AB0088---mark----end--------------------
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION multi_dept_depr
              CALL cl_cmdrun('afai030' CLIPPED)
 
        ON ACTION multi_dept_depr_q
              CALL cl_init_qry_var()
              LET g_qryparam.form ='q_fad'
              LET g_qryparam.default1 =g_far[l_ac].far10
              CALL cl_create_qry() RETURNING
                   g_far[l_ac].far10,g_far[l_ac].far07
              DISPLAY g_far[l_ac].far10 TO far10
              DISPLAY g_far[l_ac].far07 TO far07
              NEXT FIELD far10
 
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
 
   LET g_faq.faqmodu = g_user
   LET g_faq.faqdate = g_today
   UPDATE faq_file SET faqmodu = g_faq.faqmodu,faqdate = g_faq.faqdate
    WHERE faq01 = g_faq.faq01
   DISPLAY BY NAME g_faq.faqmodu,g_faq.faqdate
 
   CLOSE t101_bcl
   COMMIT WORK
   CALL t101_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t101_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_faq.faq01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM faq_file ",
                  "  WHERE faq01 LIKE '",l_slip,"%' ",
                  "    AND faq01 > '",g_faq.faq01,"'"
      PREPARE t101_pb1 FROM l_sql 
      EXECUTE t101_pb1 INTO l_cnt  
      
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
        #CALL t101_x()           #FUN-D20035
         CALL t101_x(1)           #FUN-D20035
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 1
                                AND npp01 = g_faq.faq01
                                AND npp011= 1
         DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 1
                                AND npq01 = g_faq.faq01
                                AND npq011= 1
         DELETE FROM tic_file WHERE tic04 = g_faq.faq01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM faq_file WHERE faq01 = g_faq.faq01
         INITIALIZE g_faq.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
FUNCTION t101_far031(p_cmd)
DEFINE   p_cmd       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_cnt       LIKE type_file.num5,         #No.FUN-680070 SMALLINT
         l_faj06     LIKE faj_file.faj06,
         l_faj26     LIKE faj_file.faj26,
         l_faj20     LIKE faj_file.faj20,
         l_faj21     LIKE faj_file.faj21,
         l_faj53     LIKE faj_file.faj53,
         l_faj531    LIKE faj_file.faj531,     #No.FUN-680028
         l_faj54     LIKE faj_file.faj54,
         l_faj541    LIKE faj_file.faj541,     #No.FUN-680028
         l_faj23     LIKE faj_file.faj23,
         l_faj24     LIKE faj_file.faj24,
         l_faj55     LIKE faj_file.faj55,
         l_faj551    LIKE faj_file.faj551     #No.FUN-680028
 
    LET g_errno = ' '
    IF l_flag='N' OR (l_flag='Y' AND
                            (g_far[l_ac].far03!=g_far_t.far03 OR
                             g_far[l_ac].far031!=g_far_t.far031)) THEN
       SELECT COUNT(*) INTO l_cnt  FROM far_file
        WHERE far01=g_faq.faq01 AND far03=g_far[l_ac].far03
          AND far031=g_far[l_ac].far031
       IF l_cnt>0 THEN
          LET g_errno='afa-105'
          RETURN
       END IF
      SELECT faj06,faj26,faj20,faj21,faj23,faj24,faj53,faj54,faj55,faj531,faj541,faj551     #No.FUN-680028
        INTO l_faj06,l_faj26,l_faj20,l_faj21,l_faj23,l_faj24,l_faj53,
             l_faj54,l_faj55,l_faj531,l_faj541,l_faj551     #No.FUN-680028
        FROM faj_file
       WHERE faj02  = g_far[l_ac].far03 AND faj022 = g_far[l_ac].far031
         AND faj43  = '0'               AND fajconf = 'Y'
     CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-134'
         OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     IF cl_null(g_errno) AND (p_cmd = 'a' OR p_cmd = 'u') THEN
        LET g_far[l_ac].far04 = l_faj26
        LET g_far[l_ac].far05 = l_faj20
        LET g_far[l_ac].far06 = l_faj21
        LET g_far[l_ac].far07 = l_faj53
        LET g_far[l_ac].far08 = l_faj54
        LET g_far[l_ac].far09 = l_faj23
        LET g_far[l_ac].far10 = l_faj24
        LET g_far[l_ac].far11 = l_faj55
        LET g_far[l_ac].faj06 = l_faj06
        LET g_far[l_ac].far12 = g_far[l_ac].far03
        LET g_far[l_ac].far121 = g_far[l_ac].far031
#FUN-AB0088---mark----str--------------------
#       IF g_aza.aza63 = 'Y' THEN
#          LET g_far[l_ac].far071 = l_faj531
#          LET g_far[l_ac].far081 = l_faj541
#          LET g_far[l_ac].far111 = l_faj551
#       END IF
#FUN-AB0088---mark----end--------------------
    END IF
  END IF
END FUNCTION
 
FUNCTION t101_far05(p_cmd)
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_gem01    LIKE gem_file.gem01,
      l_gemacti  LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem01,gemacti INTO l_gem01,l_gemacti
      FROM gem_file
     WHERE gem01 = g_far[l_ac].far05
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'
                                LET l_gem01 = NULL
                                LET l_gemacti = NULL
       WHEN l_gemacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t101_far06(p_cmd)
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_faf01    LIKE faf_file.faf01,
      l_faf03    LIKE faf_file.faf03,
      l_fafacti  LIKE faf_file.fafacti
 
     LET g_errno = ' '
     SELECT faf01,faf03,fafacti INTO l_faf01,l_faf03,l_fafacti
       FROM faf_file
      WHERE faf01 = g_far[l_ac].far06
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-039'
                                LET l_faf01 = NULL
                                LET l_faf03 = NULL
                                LET l_fafacti = NULL
       WHEN l_fafacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t101_acct(p_cmd,p_acct,p_bookno)        #No.FUN-740033
DEFINE
    p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    p_acct          LIKE aag_file.aag01,
    p_bookno        LIKE aag_file.aag00,         #No.FUN-740033
    l_aag02         LIKE aag_file.aag02,
    l_aag07         LIKE aag_file.aag07,
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT aag02,aag07,aagacti
      INTO l_aag02,l_aag07,l_aagacti
      FROM aag_file
     WHERE aag01 = p_acct
       AND aag00 = p_bookno  #No.FUN-740033
    CASE WHEN STATUS=100          LET g_errno = 'afa-085'  #No.7926
                                  LET l_aag02   = NULL
          WHEN l_aagacti = 'N' LET g_errno = '9028'
          WHEN l_aag07 = '1'   LET g_errno = 'agl-015'
          OTHERWISE LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION
 
#FUNCTION t101_far101(p_cmd)   #FUN-AB0088 mark
FUNCTION t101_far101(p_cmd,l_far10)  #FUN-AB0088 add
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_gem01    LIKE gem_file.gem01,
      l_gemacti  LIKE gem_file.gemacti
DEFINE l_far10   LIKE far_file.far10   #No:FUN-AB0088
 
     LET g_errno = ' '
     SELECT gem01,gemacti INTO l_gem01,l_gemacti
       FROM gem_file
     #WHERE gem01 = g_far[l_ac].far10   #FUN-AB0088 mark
      WHERE gem01 = l_far10             #FUN-AB0088
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'
                                LET l_gem01 = NULL
                                LET l_gemacti = NULL
       WHEN l_gemacti = 'N' LET g_errno = '9028'
       OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
END FUNCTION
 
#FUNCTION t101_far102(p_cmd)         #FUN-AB0088 mark
FUNCTION t101_far102(p_cmd,l_type)   #No:FUN-AB0088
DEFINE
      p_cmd        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_fad03      LIKE fad_file.fad03,
      l_fad031     LIKE fad_file.fad031,
      l_fad04      LIKE fad_file.fad04,
      l_fadacti    LIKE fad_file.fadacti
DEFINE l_type   LIKE type_file.chr1   #No:FUN-AB0088
DEFINE l_far10  LIKE far_file.far10   #No:FUN-AB0088
DEFINE l_far07  LIKE far_file.far07   #No:FUN-AB0088

   #-----FUN-AB0088---add----str------
   IF l_type = '1' THEN 
      LET l_far10 = g_far[l_ac].far10
      LET l_far07 = g_far[l_ac].far07
   ELSE
      LET l_far10 = g_far2[l_ac].far102
      LET l_far07 = g_far2[l_ac].far071
   END IF
   #-----FUN-AB0088---add----end------
 
      LET g_errno = ' '
      SELECT fad03,fad04,fad031,fadacti INTO l_fad03,l_fad04,l_fad031,l_fadacti     #No.FUN-680028
        FROM fad_file
       WHERE fad04 = g_far[l_ac].far10
         AND fad03 = g_far[l_ac].far07
         AND fad01 = YEAR(g_faq.faq02)
         AND fad02 = MONTH(g_faq.faq02)
         AND fad07 = l_type   #No:FUN-AB0088
      CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-049'
                                  LET l_fad04 = NULL
                                  LET l_fadacti = NULL
        WHEN l_fadacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     LET g_far[l_ac].far07 = l_fad03
 
    #FUN-AB0088---add---str---
     IF l_type = '1' THEN
        LET g_far[l_ac].far07 = l_fad03
     ELSE
        LET g_far2[l_ac].far071 = l_fad03
     END IF
    #FUN-AB0088---add---end---
    #FUN-AB0088---mark---str-----------
    #IF g_aza.aza63 = 'Y' THEN
    #   LET g_far[l_ac].far071 = l_fad031
    #END IF
    #FUN-AB0088---mark----end--------
END FUNCTION
 
FUNCTION t101_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON far02,far03,far031,far04,far27,far05,
                      #far06,far07,far071,far08,far081,far09,far10,far11,far111,faj06     #No.FUN-680028  #FUN-AB0088 mark
                       far06,far07,far08,far09,far10,far11,faj06     #No.FUN-680028   #FUN-AB0088 add    
                       ,farud01,farud02,farud03,farud04,farud05
                       ,farud06,farud07,farud08,farud09,farud10
                       ,farud11,farud12,farud13,farud14,farud15
         FROM s_far[1].far02,s_far[1].far03,s_far[1].far031,s_far[1].far04,
              s_far[1].far27,s_far[1].far05,s_far[1].far06,s_far[1].far07,
             #FUN-AB0088---mod---str-----------
             #s_far[1].far071,s_far[1].far08,s_far[1].far081,s_far[1].far09,     #No.FUN-680028
             #s_far[1].far10,s_far[1].far11,s_far[1].far111,     #No.FUN-680028
              s_far[1].far08,s_far[1].far09,     #No.FUN-680028
              s_far[1].far10,s_far[1].far11,     #No.FUN-680028
             #FUN-AB0088---mod----end------------ 
              s_far[1].faj06
              ,s_far[1].farud01,s_far[1].farud02,s_far[1].farud03
              ,s_far[1].farud04,s_far[1].farud05,s_far[1].farud06
              ,s_far[1].farud07,s_far[1].farud08,s_far[1].farud09
              ,s_far[1].farud10,s_far[1].farud11,s_far[1].farud12
              ,s_far[1].farud13,s_far[1].farud14,s_far[1].farud15
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
    CALL t101_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t101_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    LET g_sql =
       #FUN-AB0088---mod---str---------------- 
       #"SELECT far02,far03,far031,faj06,far12,far121,far04,far27,far05,far06,far07,far071,",     #No.FUN-680028
       #"  far08,far081,far09,far10,far11,far111 ",     #No.FUN-680028
        "SELECT far02,far03,far031,faj06,far12,far121,far04,far27,far05,far06,far07,",     #No.FUN-680028
        "  far08,far09,far10,far11 ",     #No.FUN-680028
       #FUN-AB0088---mod----end------------------  
        ",farud01,farud02,farud03,farud04,farud05,",
        "farud06,farud07,farud08,farud09,farud10,",
        "farud11,farud12,farud13,farud14,farud15", 
        "  FROM far_file LEFT OUTER JOIN faj_file ON far03 = faj02 AND far031 = faj022 ",
        " WHERE far01  ='",g_faq.faq01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE t101_pb FROM g_sql
    DECLARE far_curs                       #SCROLL CURSOR
        CURSOR FOR t101_pb
 
    CALL g_far.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH far_curs INTO g_far[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_far.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_far TO s_far.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
        #IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
         IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088   
            CALL cl_set_act_visible("entry_sheet2",TRUE)
         ELSE
            CALL cl_set_act_visible("entry_sheet2",FALSE)
         END IF
 
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
         CALL t101_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t101_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t101_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t101_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t101_fetch('L')
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
 
         IF g_faq.faqconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         CALL cl_set_field_pic(g_faq.faqconf,"",g_faq.faqpost,"",g_chr,"")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
 
      ON ACTION carry_voucher #傳票拋轉 
         LET g_action_choice="carry_voucher" 
         EXIT DISPLAY 
 
      ON ACTION undo_carry_voucher #傳票拋轉還原 
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY 

      #FUN-AB0088---add---str---
      ON ACTION fin_audit2   #財簽二
         LET g_action_choice="fin_audit2"
         EXIT DISPLAY
      #FUN-AB0088---add---end---
 
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
      #@ON ACTION 過帳
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
      #@ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
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
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#---自動產生-------
FUNCTION t101_g()
 DEFINE  l_wc        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(300)
         l_sql       LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(400)
         l_faj02     LIKE faj_file.faj02,
         m_faj       RECORD LIKE faj_file.*,
         m_faa031    LIKE faa_file.faa031,
         m_fcx06     LIKE fcx_file.fcx06,
         l_faj       RECORD
               faj02     LIKE faj_file.faj02,
               faj022    LIKE faj_file.faj022,
               faj06     LIKE faj_file.faj06,
               faj26     LIKE faj_file.faj26,
               faj20     LIKE faj_file.faj20,
               faj21     LIKE faj_file.faj21,
               faj53     LIKE faj_file.faj53,
               faj531    LIKE faj_file.faj531,     #No.FUN-680028
               faj54     LIKE faj_file.faj54,
               faj541    LIKE faj_file.faj541,     #No.FUN-680028
               faj23     LIKE faj_file.faj23,
               faj24     LIKE faj_file.faj24,
               faj27     LIKE faj_file.faj27,
               faj55     LIKE faj_file.faj55,
               faj551    LIKE faj_file.faj551,    #No.FUN-680028
               #FUN-AB0088---add---str---
               faj232    LIKE faj_file.faj232, 
               faj242    LIKE faj_file.faj242,
               faj272    LIKE faj_file.faj272 
               #FUN-AB0088---add---end--- 
               END RECORD,
         ans         LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         i           LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE p_row,p_col   LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE ls_tmp STRING
 
   IF s_shut(0) THEN RETURN END IF
   IF g_faq.faq01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_faq.faqconf='X' THEN CALL cl_err(g_faq.faq01,'9024',0) RETURN END IF
   IF g_faq.faqconf='Y' THEN CALL cl_err(g_faq.faq01,'afa-107',0) RETURN END IF
   IF NOT cl_confirm('afa-103') THEN RETURN END IF     #No.MOD-490235
   LET INT_FLAG = 0

  #---------詢問是否自動新增單身--------------
      LET p_row = 8 LET p_col = 30
      OPEN WINDOW t101_w2 AT p_row,p_col WITH FORM "afa/42f/afat1012"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
      CALL cl_ui_locale("afat1012")
 
 
#FUN-B80147 --begin--
      LET g_far07 = NULL 
      LET g_far08 = NULL 
      LET g_far11 = NULL 
#FUN-B80147 --end--
 
     #CONSTRUCT l_wc ON faj01,faj02,faj022,faj52,faj51,       #No.FUN-B50118 mark
     #         faj45,faj47,faj53,faj25,faj26                  #No.FUN-B50118 mark
     #     FROM faj01,faj02,faj022,faj52,faj51,faj45,faj47,   #No.FUN-B50118 mark
     #          faj53,faj25, faj26                            #No.FUN-B50118 mark
      CONSTRUCT l_wc ON faj01,faj93,faj02,faj022,faj52,faj51,      #No.FUN-B50118 add
               faj45,faj47,faj53,faj25,faj26                       #No.FUN-B50118 add
           FROM faj01,faj93,faj02,faj022,faj52,faj51,faj45,faj47,  #No.FUN-B50118 add
                faj53,faj25, faj26                                 #No.FUN-B50118 add

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
      IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t101_w2 RETURN END IF

#FUN-B80147 --begin--
      INPUT g_far07,g_far08,g_far11 FROM far07,far08,far11
          AFTER FIELD far07
            IF NOT cl_null(g_far07) THEN
               CALL t101_acct('a',g_far07,g_bookno1)
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD far07
               END IF 
           END IF             
          AFTER FIELD far08
            IF NOT cl_null(g_far08) THEN
               CALL t101_acct('a',g_far08,g_bookno1)
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD far08
               END IF 
           END IF                    
          AFTER FIELD far11
            IF NOT cl_null(g_far11) THEN
               CALL t101_acct('a',g_far11,g_bookno1)
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD far11
               END IF 
           END IF
        
        ON ACTION controlp
           CASE 
            WHEN INFIELD(far07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_far07
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.arg1 = g_bookno1
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_far07 CLIPPED,"%' "
                 CALL cl_create_qry() RETURNING g_far07
                 DISPLAY BY NAME g_far07
                 NEXT FIELD far07
            WHEN INFIELD(far08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_far08
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.arg1 = g_bookno1
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_far08 CLIPPED,"%' "
                 CALL cl_create_qry() RETURNING g_far08
                 DISPLAY BY NAME g_far08
                 NEXT FIELD far08  
            WHEN INFIELD(far11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_far11
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.arg1 = g_bookno1
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_far11 CLIPPED,"%' "
                 CALL cl_create_qry() RETURNING g_far11
                 DISPLAY BY NAME g_far11
                 NEXT FIELD far11                          
           END CASE               
      END INPUT 
      IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t101_w2 RETURN END IF      
#FUN-B80147 --end--
      
      BEGIN WORK
      LET l_sql ="SELECT faj02,faj022,faj06,faj26,faj20,faj21,faj53,faj531,",     #No.FUN-680028
                 "faj54,faj541,faj23,faj24,faj27,faj55,faj551,",     #No.FUN-680028
                 "       faj232,faj242,faj272",   #No:FUN-AB0088
                 "  FROM faj_file",
                 " WHERE faj43 = '0'",
                 "   AND fajconf = 'Y'",
                 "   AND faj02 NOT IN (SELECT far03 FROM far_file",
                 #" WHERE far03  = faj02 ",                #TQC-AB0036 mark
                 " WHERE far03  = faj_file.faj02 ",     #TQC-AB0036 add
                 "   AND far01  = '",g_faq.faq01,"')",
                 "   AND ",l_wc CLIPPED,
                 " ORDER BY 1"
     PREPARE t101_prepare_g FROM l_sql
     IF SQLCA.SQLCODE != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0)
        ROLLBACK WORK RETURN
     END IF
     DECLARE t101_curs2 CURSOR FOR t101_prepare_g
 
     SELECT MAX(far02)+1 INTO i FROM far_file WHERE far01 = g_faq.faq01
     IF STATUS THEN CALL cl_err(' ',STATUS,0) END IF
     IF cl_null(i) THEN LET i = 1 END IF
     LET g_success = 'Y'     #No.FUN-8A0086
     CALL s_showmsg_init()   #No.FUN-710028
     FOREACH t101_curs2 INTO l_faj.*
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        
 
       IF SQLCA.sqlcode != 0 THEN
          CALL s_errmsg('','','foreach:',SQLCA.sqlcode,0)  #No.FUN-710028
          EXIT FOREACH
       END IF
        IF cl_null(l_faj.faj022) THEN
           LET l_faj.faj022 = ' '
        END IF
#FUN-B80147 --begin--
        IF NOT cl_null(g_far07) THEN 
          LET l_faj.faj53 = g_far07
        END IF 
        IF NOT cl_null(g_far08) THEN 
          LET l_faj.faj54 = g_far08
        END IF 
        IF NOT cl_null(g_far07) THEN 
          LET l_faj.faj55 = g_far11
        END IF                 
#FUN-B80147 --end--        
        INSERT INTO far_file (far01,far02,far03,far031,far04,far05,  #No.MOD-470041
                             far06,far07,far071,far08,far081,far09,far10,far11,far111,far12,     #No.FUN-680028
                             far121,far13,far27,
                             far092,far102,far272,   #FUN-AB0088
                             farlegal) #FUN-980003 add
            VALUES (g_faq.faq01,i,l_faj.faj02,l_faj.faj022,l_faj.faj26,
                    l_faj.faj20,l_faj.faj21,l_faj.faj53,l_faj.faj531,     #No.FUN-680028
                    l_faj.faj54,l_faj.faj541,     #No.FUN-680028
                    l_faj.faj23,l_faj.faj24,l_faj.faj55,l_faj.faj551,l_faj.faj02,     #No.FUN-680028
                    l_faj.faj022,g_faq.faq03,l_faj.faj27,
                    #l_faj.faj232,l_fah.faj242,l_faj.faj272,    #FUN-AB0088   #TQC-B60061
                    l_faj.faj232,l_faj.faj242,l_faj.faj272,    #FUN-AB0088    #TQC-B60061 
                    g_legal) #FUN-980003 add
       IF STATUS OR SQLCA.SQLCODE=100 THEN
          LET g_showmsg = g_faq.faq01,"/",i #No.FUN-710028
          CALL s_errmsg('far01,far02',g_showmsg,'ins far',STATUS,1)   #No.FUN-710028
          LET g_success = 'N'  #No.FUN-710028
          CONTINUE FOREACH     #No.FUN-710028
       END IF
       LET i = i + 1
     END FOREACH
     IF g_totsuccess="N" THEN                                                                                                        
        LET g_success="N"                                                                                                            
     END IF                                                                                                                          
     IF g_success = 'Y' THEN   #No.FUN-710028
        COMMIT WORK
     ELSE                      #No.FUN-710028  
        ROLLBACK WORK          #No.FUN-710028
     END IF                    #No.FUN-710028
     CLOSE WINDOW t101_w2
END FUNCTION
 
FUNCTION t101_y() 	# 確認 when g_faq.faqconf='N' (Turn to 'Y')
DEFINE l_cnt LIKE type_file.num5         #No.FUN-680070 SMALLINT
   IF s_shut(0) THEN RETURN END IF
   IF g_faq.faq01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#CHI-C30107 ---------- add ------------- begin
   IF g_faq.faqconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_faq.faqconf='Y' THEN RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 ---------- add ------------- end
    SELECT * INTO g_faq.* FROM faq_file WHERE faq01 = g_faq.faq01
   IF g_faq.faqconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_faq.faqconf='Y' THEN RETURN END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期小於關帳日期
   IF g_faq.faq02 < g_faa.faa09 THEN
      CALL cl_err(g_faq.faq01,'aap-176',1) RETURN
   END IF

  #FUN-B60140   ---start   Add
   IF g_faa.faa31 = "Y" THEN
      #-->立帳日期小於關帳日期
      IF g_faq.faq02 < g_faa.faa092 THEN
         CALL cl_err(g_faq.faq01,'aap-176',1) RETURN
      END IF
   END IF
  #FUN-B60140   ---end     Add

   SELECT COUNT(*) INTO l_cnt FROM far_file
    WHERE far01= g_faq.faq01
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   CALL s_get_doc_no(g_faq.faq01) RETURNING g_t1
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
 
   #----------------------------------- 檢查分錄底稿平衡正確否
#FUN-C30313---mark---START-----
#   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'N' THEN  #No.FUN-670060 
#      CALL s_chknpq(g_faq.faq01,'FA',1,'0',g_bookno1)    #-->NO:0151  #No.FUN-740033
#     #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 mark
#      IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #No:FUN-AB0088
#        #CALL s_chknpq(g_faq.faq01,'FA',1,'1',g_bookno2)    #-->NO:0151  #No.FUN-740033 #FUN-AB0088
#         CALL s_chknpq(g_faq.faq01,'FA',1,'1',g_faa.faa02c) #FUN-AB0088 
#      END IF
#   END IF
#FUN-C30313---mark---END-------

#FUN-C30313---add---START-----
    IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'N' THEN  
       CALL s_chknpq(g_faq.faq01,'FA',1,'0',g_bookno1)  
    END IF
    IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   
       IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'N' THEN
          CALL s_chknpq(g_faq.faq01,'FA',1,'1',g_faa.faa02c) 
       END IF
    END IF
#FUN-C30313---add---END-------
   IF g_success = 'N' THEN RETURN END IF
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
   BEGIN WORK
 
    OPEN t101_cl USING g_faq.faq01
    IF STATUS THEN
       CALL cl_err("OPEN t101_cl:", STATUS, 1)
       CLOSE t101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t101_cl INTO g_faq.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faq.faq01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t101_cl ROLLBACK WORK RETURN
    END IF
 
#FUN-C30313---mark---START-----
#   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
#      SELECT COUNT(*) INTO l_cnt FROM npq_file 
#       WHERE npq01= g_faq.faq01
#         AND npq00= 1  
#         AND npqsys= 'FA'  
#         AND npq011= 1
#      IF l_cnt = 0 THEN
#         CALL t101_gen_glcr(g_faq.*,g_fah.*)
#      END IF
#      IF g_success = 'Y' THEN 
#         CALL s_chknpq(g_faq.faq01,'FA',1,'0',g_bookno1)    #-->NO:0151  #No.FUN-740033
#        #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088
#         IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #No:FUN-AB0088
#           #CALL s_chknpq(g_faq.faq01,'FA',1,'1',g_bookno2)    #-->NO:0151  #No.FUN-740033  #FUN-AB0088 mark
#            CALL s_chknpq(g_faq.faq01,'FA',1,'1',g_faa.faa02c)   #No:FUN-AB0088 
#         END IF
#      END IF
#      IF g_success = 'N' THEN RETURN END IF  #No.FUN-680028
#   END IF
#FUN-C30313---mark---END-------

#FUN-C30313---add---START-----
       SELECT COUNT(*) INTO l_cnt FROM npq_file
        WHERE npq01= g_faq.faq01
          AND npq00= 1
          AND npqsys= 'FA'
          AND npq011= 1
      #IF l_cnt = 0 THEN                                                                   #MOD-C50255 mark
       IF l_cnt = 0 AND                                                                    #MOD-C50255 add
          ((g_fah.fahdmy3 = 'Y') OR (g_faa.faa31 = 'Y' AND g_fah.fahdmy32 = 'Y' )) THEN    #MOD-C50255 add
          CALL t101_gen_glcr(g_faq.*,g_fah.*)
       END IF
       IF g_success = 'Y' THEN
          IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
             CALL s_chknpq(g_faq.faq01,'FA',1,'0',g_bookno1)    
          END IF
          IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   
             IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN
                CALL s_chknpq(g_faq.faq01,'FA',1,'1',g_faa.faa02c) 
             END IF
          END IF
       END IF
       IF g_success = 'N' THEN RETURN END IF  
#FUN-C30313---add---END-------
 
   LET g_success = 'Y'
   CALL t101_araj_ins()
   UPDATE faq_file SET faqconf = 'Y' WHERE faq01 = g_faq.faq01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('faq01',g_faq.faq01,'upd faqconf',STATUS,1)                #No.FUN-710028
      LET g_success = 'N'
   END IF
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'Y' THEN
      LET g_faq.faqconf='Y'
      COMMIT WORK
      DISPLAY BY NAME g_faq.faqconf
      CALL cl_flow_notify(g_faq.faq01,'Y')
   ELSE
      LET g_faq.faqconf='N'
      ROLLBACK WORK
   END IF
 
   IF g_faq.faqconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_faq.faqconf,"",g_faq.faqpost,"",g_chr,"")
 
   LET g_t1 = s_get_doc_no(g_faq.faq01)
   SELECT fahpost INTO g_fahpost FROM fah_file WHERE fahslip = g_t1
   IF g_fahpost = 'Y' THEN CALL t101_s() END IF
END FUNCTION
 
FUNCTION t101_araj_ins()
 DEFINE  l_faj02     LIKE faj_file.faj02,
         m_faj       RECORD LIKE faj_file.*,
         l_far       RECORD LIKE far_file.*,
         m_faa031    LIKE faa_file.faa031,
         l_faa031    LIKE faa_file.faa031,       #No.FUN-680070 DEC(10,0)
         m_fcx06     LIKE fcx_file.fcx06,
         l_fcx06     LIKE fcx_file.fcx06,
         l_fak02     LIKE fak_file.fak02,
         l_fak022    LIKE fak_file.fak022,
         l_fak90     LIKE fak_file.fak90,
         l_fak901    LIKE fak_file.fak901,
         l_fab23     LIKE fab_file.fab23,     #殘值率 NO.A032
         l_fab232    LIKE fab_file.fab232,     #殘值率 NO.A032  #FUN-AB0088
         i           LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   l_cnt       LIKE type_File.num5         #no.CHI-8A0021 add
 
     SELECT MAX(far02) INTO i FROM far_file
      WHERE far01=g_faq.faq01
     IF cl_null(i) THEN LET i = 0 END IF
     DECLARE t101_ins_curs CURSOR FOR
      SELECT * FROM far_file WHERE far01=g_faq.faq01
     CALL s_showmsg_init()   #No.FUN-710028
     FOREACH t101_ins_curs INTO l_far.*
          IF g_success='N' THEN                                                                                                         
             LET g_totsuccess='N'                                                                                                       
             LET g_success="Y"                                                                                                          
          END IF                                                                                                                        
 
          SELECT * INTO m_faj.* FROM faj_file
             WHERE faj02=l_far.far03
               AND faj022=l_far.far031
          IF STATUS THEN
             LET g_showmsg = l_far.far03,"/",l_far.far031    #No.FUN-710028
             CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj:',STATUS,1)    #No.FUN-710028
             LET g_success='N'
          END IF
          LET i = i + 1
          SELECT faa031 INTO m_faa031 FROM faa_file WHERE faa00='0'
          IF STATUS OR m_faa031 IS NULL THEN LET m_faa031=0 END IF
          LET l_fcx06 = 0
          DECLARE t101_fak_cur CURSOR FOR
           SELECT fak02,fak022,fak90,fak901 FROM fak_file,faj_file
            WHERE faj02 = l_far.far03
              AND faj022= l_far.far031
              AND faj92 = fak02
              AND faj921= fak022
              AND fak92 = 'Y'
          FOREACH t101_fak_cur INTO l_fak02,l_fak022,l_fak90,l_fak901
             IF STATUS THEN
                LET g_showmsg = l_far.far03,"/",l_far.far031,"/",'Y'   #No.FUN-710028
                CALL s_errmsg('faj02,faj022,fak92',g_showmsg,'foreach fak',STATUS,0) EXIT FOREACH  #No.FUN-710028
             END IF
             #NO:4953考慮合併
             IF (NOT cl_null(l_fak90) OR NOT cl_null(l_fak901)) THEN
                 DECLARE t101_fak_cur1 CURSOR FOR
                  SELECT fak02,fak022 FROM fak_file
                   WHERE  fak90=l_fak90
                     AND fak901=l_fak901
                 FOREACH  t101_fak_cur1 INTO l_fak02,l_fak022
                     IF STATUS THEN
                         LET g_showmsg = l_fak90,"/",l_fak901               #No.FUN-710028
                         CALL s_errmsg('fak90,fak901',g_showmsg,'foreach fak',STATUS,0) EXIT FOREACH   #No.FUN-710028
                     END IF
                  SELECT SUM(fcx06) INTO m_fcx06 FROM fcx_file WHERE fcx01 =l_fak02
                                                                 AND fcx011=l_fak022
                  IF STATUS OR m_fcx06 IS NULL THEN CONTINUE FOREACH END IF
                      LET l_fcx06 = l_fcx06 + m_fcx06
                  END FOREACH
             ELSE #分開
                 SELECT SUM(fcx06) INTO m_fcx06 FROM fcx_file WHERE fcx01 =l_fak02
                                                                AND fcx011=l_fak022
                 IF STATUS OR m_fcx06 IS NULL THEN CONTINUE FOREACH END IF
                 LET l_fcx06 = l_fcx06 + m_fcx06
             END IF
          END FOREACH
          IF l_fcx06 = 0 THEN CONTINUE FOREACH END IF
          LET l_faa031 = m_faa031 + 1
          LET m_faj.faj01=l_faa031 USING '&&&&&&&&&&'
          LET m_faj.faj021='3'
          LET m_faj.faj022='9999'
          WHILE TRUE
              SELECT COUNT(*) INTO l_cnt FROM faj_file
               WHERE faj02 = m_faj.faj02
                 AND faj022 = m_faj.faj022 
              IF l_cnt > 0 THEN
                  LET m_faj.faj022 = m_faj.faj022 -1
                  CONTINUE WHILE
              ELSE
                  EXIT WHILE
              END IF
          END WHILE
          LET m_faj.faj43='1'
          LET m_faj.faj201='1'
          LET m_faj.faj26=g_faq.faq02
          LET m_faj.faj100=g_faq.faq02
          LET m_faj.faj13=l_fcx06
          LET m_faj.faj14=l_fcx06
          LET m_faj.faj16=l_fcx06
          LET m_faj.faj17=0
          LET m_faj.faj32=0
          LET m_faj.fajconf='N'
          LET m_faj.faj101 =0
          LET m_faj.faj102 =0
          LET m_faj.faj103 =0
          LET m_faj.faj104 =0
          #LET m_faj.faj105 = 'N' #No.FUN-B80081 mark 
          LET m_faj.faj106 =0
          LET m_faj.faj107 =0
          LET m_faj.faj108 =0
          LET m_faj.faj109 =0
          LET m_faj.faj110 =0
          LET m_faj.faj111 =0
          #-----No:FUN-AB0088-----
          LET m_faj.faj262=g_faq.faq02
          LET m_faj.faj322=0
          LET m_faj.faj1012 =0
          LET m_faj.faj1022 =0
          LET m_faj.faj1062 =0
          LET m_faj.faj1072 =0
          LET m_faj.faj1082 =0
          #-----No:FUN-AB0088 END-----
 
          IF g_aza.aza26 = '2' THEN
            #SELECT fab23 INTO l_fab23  FROM fab_file WHERE fab01 = m_faj.faj04   #FUN-AB0088 mark
             SELECT fab23,fab232 INTO l_fab23,l_fab232 FROM fab_file WHERE fab01 = m_faj.faj04   #FUN-AB0088 add 
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('fab01',m_faj.faj04,l_fab23,SQLCA.sqlcode,1)           #No.FUN-710028
                LET g_success = 'N' CONTINUE FOREACH   #No.FUN-710028
             END IF
             IF m_faj.faj28 MATCHES '[05]' THEN
                LET m_faj.faj31 = 0
             ELSE
#                LET m_faj.faj31 = (m_faj.faj14-m_faj.faj32)*l_fab23/100  #MOD-A40033 mark
                 LET m_faj.faj31 = m_faj.faj14*l_fab23/100  #MOD-A40033 
             END IF
             #-----No:FUN-AB0088-----
             IF m_faj.faj282 MATCHES '[05]' THEN
                LET m_faj.faj312 = 0
             ELSE
                LET m_faj.faj312 = m_faj.faj142*l_fab232/100 
             END IF
             #-----No:FUN-AB0088 END-----
          ELSE
             CASE m_faj.faj28
                  WHEN '0'   LET m_faj.faj31 = 0
                  WHEN '1'   LET m_faj.faj31 =
                                (m_faj.faj14-m_faj.faj32)/(m_faj.faj29 + 12)*12
                  WHEN '2'   LET m_faj.faj31 = 0
                  WHEN '3'   LET m_faj.faj31 = (m_faj.faj14-m_faj.faj32)/10
                  WHEN '4'   LET m_faj.faj31 = 0
                  WHEN '5'   LET m_faj.faj31 = 0
                  OTHERWISE EXIT CASE
             END CASE
             #-----No:FUN-AB0088-----
             CASE m_faj.faj282
                  WHEN '0'   LET m_faj.faj312 = 0
                  WHEN '1'   LET m_faj.faj312 =
                                (m_faj.faj142-m_faj.faj322)/(m_faj.faj292 + 12)*12
                  WHEN '2'   LET m_faj.faj312 = 0
                  WHEN '3'   LET m_faj.faj312 = (m_faj.faj142-m_faj.faj322)/10
                  WHEN '4'   LET m_faj.faj312 = 0
                  WHEN '5'   LET m_faj.faj312 = 0
                  OTHERWISE EXIT CASE
            END CASE
            #-----No:FUN-AB0088 END-----
          END IF
          CALL cl_digcut(m_faj.faj31,g_azi04) RETURNING m_faj.faj31
          LET m_faj.faj33 = m_faj.faj14 - m_faj.faj32

          #-----No:FUN-AB0088-----
          #CALL cl_digcut(m_faj.faj312,g_azi04) RETURNING m_faj.faj312  #CHI-C60010 mark
          CALL cl_digcut(m_faj.faj312,g_azi04_1) RETURNING m_faj.faj312   #CHI-C60010
          LET m_faj.faj332 = m_faj.faj142 - m_faj.faj322
          #-----No:FUN-AB0088 END-----
 
          IF cl_null(m_faj.faj022) THEN
             LET m_faj.faj022 = ' '
          END IF
          LET m_faj.fajoriu = g_user      #No.FUN-980030 10/01/04
          LET m_faj.fajorig = g_grup      #No.FUN-980030 10/01/04
         #CHI-C60010---str---
          CALL cl_digcut(m_faj.faj1012,g_azi04_1) RETURNING m_faj.faj1012
          CALL cl_digcut(m_faj.faj1022,g_azi04_1) RETURNING m_faj.faj1022
          CALL cl_digcut(m_faj.faj1082,g_azi04_1) RETURNING m_faj.faj1082
          CALL cl_digcut(m_faj.faj1412,g_azi04_1) RETURNING m_faj.faj1412
          CALL cl_digcut(m_faj.faj142,g_azi04_1) RETURNING m_faj.faj142
          CALL cl_digcut(m_faj.faj312,g_azi04_1) RETURNING m_faj.faj312
          CALL cl_digcut(m_faj.faj322,g_azi04_1) RETURNING m_faj.faj322
          CALL cl_digcut(m_faj.faj332,g_azi04_1) RETURNING m_faj.faj332
          CALL cl_digcut(m_faj.faj352,g_azi04_1) RETURNING m_faj.faj352
          CALL cl_digcut(m_faj.faj592,g_azi04_1) RETURNING m_faj.faj592
          CALL cl_digcut(m_faj.faj602,g_azi04_1) RETURNING m_faj.faj602
         #CHI-C60010---end---
          INSERT INTO faj_file VALUES (m_faj.*)
          IF STATUS THEN
             LET g_showmsg = m_faj.faj01,"/",m_faj.faj02,"/",m_faj.faj022           #No.FUN-710028
             CALL s_errmsg('faj01,faj02,faj022',g_showmsg,'ins faj:',STATUS,1)      #No.FUN-710028
             LET g_success='N'
          END IF

           INSERT INTO far_file (far01,far02,far03,far031,far04,far05,  #No.MOD-470041
                               #far06,far07,far071,far08,far081,far09,far10,far11,far111,far12,     #No.FUN-680028  #FUN-AB0088 mark
                                far06,far07,far08,far09,far10,far11,far12,     #No.FUN-680028  #FUN-AB0088 add
                                far121,far13,far27,
                                far042,far071,far081,far092,far102,far111,far272,  #FUN-AB0088 add
                                farlegal)         #FUN-980003 add
               VALUES (g_faq.faq01,i,m_faj.faj02,m_faj.faj022,m_faj.faj26,
                      #FUN-AB0088---mod----str------------------
                      #m_faj.faj20,m_faj.faj21,m_faj.faj53,m_faj.faj531,m_faj.faj54,m_faj.faj541,     #No.FUN-680028
                      #m_faj.faj23,m_faj.faj24,m_faj.faj55,m_faj.faj551,l_far.far12,     #No.FUN-680028
                       m_faj.faj20,m_faj.faj21,m_faj.faj53,m_faj.faj54,
                       m_faj.faj23,m_faj.faj24,m_faj.faj55,l_far.far12,
                      #FUN-AB0088---mod-----end------------------
                       m_faj.faj022,g_faq.faq03,m_faj.faj27,
                       m_faj.faj262,m_faj.faj531,m_faj.faj541,m_faj.faj232,   #FUN-AB0088 add
                       m_faj.faj242,m_faj.faj551,m_faj.faj272,                #FUN-AB0088 add        
                       g_legal) #FUN-980003 add
 
          IF STATUS THEN
             LET g_showmsg = g_faq.faq01,"/",i        #No.FUN-710028
             CALL s_errmsg('far01,far02',g_showmsg,'ins far:',STATUS,1)   #No.FUN-710028
             LET g_success='N'
          END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
END FUNCTION
 
FUNCTION t101_z() 	# 確認取消 when g_faq.faqconf='Y' (Turn to 'N')
 
   IF s_shut(0) THEN RETURN END IF
   IF g_faq.faq01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_faq.* FROM faq_file WHERE faq01 = g_faq.faq01
   IF g_faq.faqconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_faq.faqconf='N' THEN RETURN END IF
   IF g_faq.faqpost='Y' THEN
      CALL cl_err(g_faq.faqpost,'afa-106',0)
      RETURN
   END IF

   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_faq.faq02 < g_faa.faa09 THEN
      CALL cl_err(g_faq.faq01,'aap-176',1) RETURN
   END IF
 
  #FUN-B60140   ---start   Add
   IF g_faa.faa31 = "Y" THEN
      #-->立帳日期不可小於關帳日期
      IF g_faq.faq02 < g_faa.faa092 THEN
         CALL cl_err(g_faq.faq01,'aap-176',1) RETURN
      END IF
   END IF
  #FUN-B60140   ---end     Add

   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
   OPEN t101_cl USING g_faq.faq01
   IF STATUS THEN
      CALL cl_err("OPEN t101_cl:", STATUS, 1)
      CLOSE t101_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t101_cl INTO g_faq.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_faq.faq01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t101_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
   CALL t101_araj_del()
   UPDATE faq_file SET faqconf = 'N' WHERE faq01 = g_faq.faq01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN LET g_success = 'N' END IF
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'Y' THEN
      LET g_faq.faqconf='N'
      COMMIT WORK
      DISPLAY BY NAME g_faq.faqconf
   ELSE
      LET g_faq.faqconf='Y'
      ROLLBACK WORK
   END IF
   IF g_faq.faqconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_faq.faqconf,"",g_faq.faqpost,"",g_chr,"")
END FUNCTION
 
FUNCTION t101_araj_del()
  DEFINE  l_far   RECORD LIKE far_file.*
  DECLARE del_araj_cur CURSOR FOR
      SELECT * FROM far_file,faj_file 
       WHERE far01=g_faq.faq01 
         AND far03 = faj02     #財編
         AND far031= faj022    #附號
         AND faj021 = '3'      #型態:3.附加費用
     
  CALL s_showmsg_init()      #No.FUN-710028
  FOREACH del_araj_cur INTO l_far.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      DELETE FROM far_file WHERE far01=l_far.far01      #CHI-8A0021 add
                             AND far02 = l_far.far02    #CHI-8A0021 add
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN   #CHI-8A0021 add
         LET g_showmsg = l_far.far03,"/",l_far.far031    #CHI-8A0021 add
         CALL s_errmsg('far03,far031',g_showmsg,'del far:',STATUS,1)  #No.FUN-710028
         LET g_success='N' CONTINUE FOREACH  #No.FUN-710028
      END IF
      DELETE FROM faj_file WHERE faj02=l_far.far03 AND faj022=l_far.far031  #CHI-8A0021 add
                             AND faj021 = '3'   #MOD-950185
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN   #CHI-8A0021 add

         LET g_showmsg = l_far.far03,"/",l_far.far031    #CHI-8A0021 add
         CALL s_errmsg('faj02,faj022',g_showmsg,'del faj:',STATUS,1)    #No.FUN-710028
         LET g_success='N' CONTINUE FOREACH  #No.FUN-710028
      END IF
  END FOREACH
  IF g_totsuccess="N" THEN                                                                                                        
     LET g_success="N"                                                                                                            
  END IF                                                                                                                          
 
END FUNCTION
 
 
FUNCTION t101_s()
   DEFINE l_far       RECORD LIKE far_file.*,
          l_faj       RECORD LIKE faj_file.*,
          l_faj021    LIKE faj_file.faj021,
          l_faa031    LIKE faa_file.faa031,
          l_bdate,l_edate   LIKE type_file.dat,          #No.FUN-680070 DATE
          l_flag            LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE m_faj       RECORD LIKE faj_file.*   #No:A099
   DEFINE l_count     LIKE type_file.num5       #MOD-950043
   
   IF s_shut(0) THEN RETURN END IF
   IF g_faq.faq01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_faq.* FROM faq_file WHERE faq01 = g_faq.faq01
   IF g_faq.faqconf != 'Y' OR g_faq.faqpost != 'N' THEN
      CALL cl_err(g_faq.faq01,'afa-100',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_faq.faq02 < g_faa.faa09 THEN
      CALL cl_err(g_faq.faq01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-
  #FUN-B60140   ---start   Add
   IF g_faa.faa31 = "Y" THEN
      #-->立帳日期小於關帳日期
      IF g_faq.faq02 < g_faa.faa092 THEN
         CALL cl_err(g_faq.faq01,'aap-176',1) RETURN
      END IF
   END IF
  #FUN-B60140   ---end     Add
   #--->折舊年月判斷必須為當月
   #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
   #CHI-A60036 add --start--
   CALL s_get_bookno(g_faa.faa07)   
       RETURNING g_flag,g_bookno1,g_bookno2
  #FUN-B60140   ---start   Mark
 ##IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
  #IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
  #   CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
  #ELSE
  #   CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
  #END IF
  #FUN-B60140   ---end     Mark
   #CHI-A60036 add --end--
   CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate    #FUN-B60140   Add
   IF g_faq.faq02 < l_bdate OR g_faq.faq02 > l_edate THEN
      CALL cl_err(g_faq.faq02,'afa-339',0)
      RETURN
   END IF
  #FUN-B60140   ---start   Add
   IF g_faa.faa31 = "Y" THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate  #No:FUN-B60140
      IF g_faq.faq02 < l_bdate OR g_faq.faq02 > l_edate THEN
         CALL cl_err(g_faq.faq02,'afa-339',0)
         RETURN
      END IF
   END IF
  #FUN-B60140   ---end     Add
   IF g_fahpost != 'Y' THEN   #MOD-860290 add
      IF NOT cl_sure(18,20) THEN RETURN END IF
   END IF                     #MOD-860290 add
   BEGIN WORK
 
    OPEN t101_cl USING g_faq.faq01
    IF STATUS THEN
       CALL cl_err("OPEN t101_cl:", STATUS, 1)
       CLOSE t101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t101_cl INTO g_faq.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faq.faq01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t101_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
      DECLARE t101_cur2 CURSOR FOR
         SELECT * FROM far_file WHERE far01=g_faq.faq01
      CALL s_showmsg_init()    #No.FUN-710028
      FOREACH t101_cur2 INTO l_far.*
         IF g_success='N' THEN                                                                                                         
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                                                                                                                        
 
         IF SQLCA.sqlcode != 0 THEN
            CALL s_errmsg('far01',g_faq.faq01,'foreach:',SQLCA.sqlcode,0)  #No.FUN-710028
            EXIT FOREACH
         END IF
         IF cl_null(l_far.far12) THEN
            CALL s_errmsg('','',l_far.far02,'afa-338',1)  #No.FUN-710028
            LET g_success = 'N' CONTINUE FOREACH          #No.FUN-710028
         END IF
         #------- 先找出對應之 faj_file 資料
         SELECT * INTO l_faj.* FROM faj_file
                  WHERE faj02=l_far.far03 AND faj022=l_far.far031
         IF STATUS  THEN #No.7926
            LET g_showmsg = l_far.far03,"/",l_far.far031                 #No.FUN-710028
            CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)   #No.FUN-710028
            LET g_success = 'N' CONTINUE FOREACH          #No.FUN-710028
         END IF
         #-------- Update fcx_file 轉固定資產日期   NO:0070
         IF l_faj.faj92 IS NOT NULL THEN
            UPDATE fcx_file SET fcx13=g_faq.faq02
             WHERE fcx01 = l_faj.faj92
               AND fcx011= l_faj.faj921
         END IF
         IF cl_null(l_far.far031) THEN
            LET l_far.far031 = ' '
         END IF
         #CHI-C60010---str---
          CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
          CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
          CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
          CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
          CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
          CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
          CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
          CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
         #CHI-C60010---end---
         INSERT INTO fap_file (fap01,fap02,fap021,fap03,fap04,fap05,fap06,
                               fap07,fap08,fap09,fap10,fap101,fap11,fap12,
                               fap13,fap14,fap15,fap16,fap17,fap18,fap19,
                               fap20,fap201,fap21,fap22,fap23,fap24,fap25,
                               fap26,fap30,fap31,fap32,fap33,fap34,fap341,
                               fap35,fap36,fap37,fap38,fap39,fap40,fap41,
                               fap42,fap50,fap501,fap66,fap661,fap55,fap58,
                               fap59,fap60,fap61,fap62,fap63,fap65,fap75,fap76,
                               fap121,fap131,fap141,fap581,fap591,fap601,fap77,  #CHI-9B0032 add fap77
                               #FUN-AB0088---add---str----
                               fap062,fap072 ,fap082,
                               fap092,fap103,fap1012,fap112,  
                               fap152,fap162,fap212 ,fap222,
                               fap232,fap242,fap252 ,fap262,
                               fap552,fap612,fap622 ,fap56,   #TQC-B30156 add fap56 
                               #FUN-AB0088---add---end---- 
                               faplegal)     #No.FUN-680028 #FUN-980003 add
              VALUES (l_faj.faj01,l_far.far03,l_far.far031,'1',g_faq.faq02,
                      l_faj.faj43,l_faj.faj28,l_faj.faj30,l_faj.faj31,
                      l_faj.faj14,l_faj.faj141,l_faj.faj33,l_faj.faj32,
                      l_faj.faj53,l_faj.faj54,l_faj.faj55,l_faj.faj23,
                      l_faj.faj24,l_faj.faj20,l_faj.faj19,l_faj.faj21,
                      l_faj.faj17,l_faj.faj171,l_faj.faj58,l_faj.faj59,
                      l_faj.faj60,l_faj.faj34,l_faj.faj35,l_faj.faj36,
                      l_faj.faj61,l_faj.faj65,l_faj.faj66,l_faj.faj62,
                      l_faj.faj63,l_faj.faj68,l_faj.faj67,l_faj.faj69,
                      l_faj.faj70,l_faj.faj71,l_faj.faj72,l_faj.faj73,
                      l_faj.faj100,l_faj.faj201,l_far.far01,l_far.far02,
                      l_faj.faj17,l_faj.faj14,l_faj.faj32,l_far.far07,
                      l_far.far08,l_far.far11,l_far.far09,l_far.far10,
                      l_far.far05,l_far.far06,l_far.far12,l_far.far121,
                      l_faj.faj531,l_faj.faj541,l_faj.faj551,     #No.FUN-680028
                      l_far.far071,l_far.far081,l_far.far111,    #No.FUN-680028
                      l_faj.faj43,   #CHI-9B0032 add
                      #FUN-AB0088---add---str----  
                      l_faj.faj282,l_faj.faj302,l_faj.faj312, 
                      l_faj.faj142,l_faj.faj1412,l_faj.faj332,l_faj.faj322,
                      l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
                      l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362, 
                      l_faj.faj322,l_far.far092,l_far.far102,0,  #TQC-B30156 add 0
                      #FUN-AB0088---add---end----
                      g_legal)  #FUN-980003 add
       IF STATUS OR SQLCA.SQLCODE=100 THEN
          LET g_showmsg = l_far.far03,"/",l_far.far031,"/",'1',"/",g_faq.faq02          #No.FUN-710028
          CALL s_errmsg('fap02,fap021,fap03,fap04',g_showmsg,'ins fap',STATUS,1)        #No.FUN-710028
          LET g_success = 'N' CONTINUE FOREACH          #No.FUN-710028
       END IF
       #-----資本化後之財產編號相同
       IF l_far.far03 = l_far.far12 AND l_far.far031 = l_far.far121 THEN 
            UPDATE faj_file SET faj43  = '1',            #資產狀態
                                #faj432 = '1',            #FUN-AB0088 #FUN-B90096 mark
                                faj201 = '1',            #稅簽資產狀態
                                faj20  = l_far.far05,    #保管部門
                                faj21  = l_far.far06,    #存放位置
                                faj23  = l_far.far09,    #分攤方式
                                faj24  = l_far.far10,    #分攤部門
                                faj26  = l_far.far04,    #入帳日期  #MOD-910207 add
                                faj27  = l_far.far27,    #開始提列  #MOD-910207 add
                                faj53  = l_far.far07,    #資產科目
                                faj54  = l_far.far08,    #累折科目
                                faj55  = l_far.far11,    #折舊科目
                                faj531 = l_far.far071,    #資產科目2
                                faj541 = l_far.far081,    #累折科目2
                                faj551 = l_far.far111,    #折舊科目2
                                faj100 = g_faq.faq02     #最近異動日期
                                #-----No:FUN-AB0088-----
                                #faj232 = l_far.far092,    #分攤方式 #FUN-B90096 mark
                                #faj242 = l_far.far102,    #分攤部門 #FUN-B90096 mark 
                                #faj262 = l_far.far042,    #入帳日期 #FUN-B90096 mark
                                #faj272 = l_far.far272     #開始提列 #FUN-B90096 mark
                                #-----No:FUN-AB0088 END----- 
             WHERE faj02=l_far.far03 AND faj022=l_far.far031
             IF STATUS OR SQLCA.SQLCODE=100 THEN
                LET g_showmsg = l_far.far03,"/",l_far.far031                  #No.FUN-710028
                CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)    #No.FUN-710028
                LET g_success = 'N' CONTINUE FOREACH  #No.FUN-710028
             END IF
          #FUN-B90096----------add-------str
          IF g_faa.faa31 = 'Y' THEN
             UPDATE faj_file SET faj432 = '1',
                                 faj232 = l_far.far092,    #分攤方式
                                 faj242 = l_far.far102,    #分攤部門
                                 faj262 = l_far.far042,    #入帳日期
                                 faj272 = l_far.far272     #開始提列
                WHERE faj02=l_far.far03 AND faj022=l_far.far031
             IF STATUS OR SQLCA.SQLCODE=100 THEN
                LET g_showmsg = l_far.far03,"/",l_far.far031
                CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)
                LET g_success = 'N' CONTINUE FOREACH
             END IF
          END IF
          #FUN-B90096----------add-------end
       ELSE
             #-----2-1.資本化後之財產編號不同以far03,far031更新-----
             UPDATE faj_file SET faj43  = 'X',
                                 #faj432 = 'X',   #FUN-AB0088 #FUN-B90096 mark
                                 faj201 = 'X',
                                 faj100 = g_faq.faq02
             WHERE faj02 = l_far.far03 AND faj022 = l_far.far031
             IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                LET g_showmsg = l_far.far03,"/",l_far.far031                  #No.FUN-710028
                CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)    #No.FUN-710028
                LET g_success = 'N' CONTINUE FOREACH  #No.FUN-710028
             END IF
             #FUN-B90096----------add-------str
             IF g_faa.faa31 = 'Y' THEN
                UPDATE faj_file SET faj432 = 'X'
                   WHERE faj02 = l_far.far03 AND faj022 = l_far.far031
                IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                   LET g_showmsg = l_far.far03,"/",l_far.far031
                   CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)
                   LET g_success = 'N' CONTINUE FOREACH
                END IF
             END IF 
             #FUN-B90096----------add-------end 
             #-----2-2.資本化後之財產編號不同以far12,far121更新-----
             SELECT count(*) INTO g_cnt FROM faj_file
                    WHERE faj02  = l_far.far12 AND faj022 = l_far.far121
             #---------資本化後之財產編號不存在資產基本檔
         IF g_cnt = 0 THEN
             LET l_faj021 = ''            #Add No.TQC-B20051
             LET l_faj021 = l_faj.faj021  #Add No.TQC-B20051
             IF cl_null(l_faj021) THEN    #Add No.TQC-B20051
                IF not cl_null(l_far.far121) THEN
                   LET l_faj021 = '2'
                ELSE
                   LET l_faj021 = '1'
                END IF
             #Add No.TQC-B20051
             ELSE
                IF cl_null(l_far.far121) THEN
                   LET l_faj021 = '1'
                END IF
             #End Add No.TQC-B20051
             END IF                       #Add No.TQC-B20051
             SELECT max(faj01) INTO l_faa031 FROM faj_file
                IF SQLCA.sqlcode THEN  LET l_faa031 = 1 END IF
             LET l_faa031 = l_faa031 + 1 USING '&&&&&&&&&&'
             LET m_faj.* = l_faj.*
             LET m_faj.faj01 = l_faa031
             LET m_faj.faj02 = l_far.far12
             LET m_faj.faj021= l_faj021
             LET m_faj.faj022= l_far.far121
             LET m_faj.faj20 = l_far.far05
             LET m_faj.faj21 = l_far.far06
             LET m_faj.faj23 = l_far.far09
             LET m_faj.faj24 = l_far.far10
             LET m_faj.faj26 = l_far.far04
             LET m_faj.faj27 = l_far.far27
             LET m_faj.faj43 = '1'
             LET m_faj.faj53 = l_far.far07
             LET m_faj.faj54 = l_far.far08
             LET m_faj.faj55 = l_far.far11
            ##FUN-AB0088---mark---str---     
            #LET m_faj.faj531= l_far.far071
            #LET m_faj.faj541= l_far.far081
            #LET m_faj.faj551= l_far.far111
            ##FUN-AB0088---mark---end--  
             LET m_faj.faj92 = ' '
             LET m_faj.faj921= ' '
             LET m_faj.faj100= g_faq.faq02
             LET m_faj.faj201= ' '
             LET m_faj.faj203= 0
             LET m_faj.faj204= 0
             LET m_faj.faj205= 0
             LET m_faj.faj206= 0
             LET m_faj.faj101= 0
             LET m_faj.faj102= 0
             LET m_faj.faj103= 0
             LET m_faj.faj104= 0
             #LET m_faj.faj105= 'N' #No.FUN-B80081 mark
             LET m_faj.faj106= 0
             LET m_faj.faj107= 0
             LET m_faj.faj108= 0
             LET m_faj.faj109= 0
             LET m_faj.faj110= 0
             LET m_faj.faj111= 0
 
             IF cl_null(m_faj.faj022) THEN
                LET m_faj.faj022 = ' '
             END IF
             SELECT COUNT(*) INTO l_count FROM faj_file
              WHERE faj02  = m_faj.faj02 
                AND faj022 = m_faj.faj022
              IF l_count > 0 THEN 
                 CALL cl_err('','afa-105',1)
                 LET g_success = 'N'
                 CONTINUE FOREACH 
              END IF    
             LET m_faj.fajoriu = g_user      #No.FUN-980030 10/01/04
             LET m_faj.fajorig = g_grup      #No.FUN-980030 10/01/04
            #CHI-C60010---str---
             CALL cl_digcut(m_faj.faj1012,g_azi04_1) RETURNING m_faj.faj1012
             CALL cl_digcut(m_faj.faj1022,g_azi04_1) RETURNING m_faj.faj1022
             CALL cl_digcut(m_faj.faj1082,g_azi04_1) RETURNING m_faj.faj1082
             CALL cl_digcut(m_faj.faj1412,g_azi04_1) RETURNING m_faj.faj1412
             CALL cl_digcut(m_faj.faj142,g_azi04_1) RETURNING m_faj.faj142
             CALL cl_digcut(m_faj.faj312,g_azi04_1) RETURNING m_faj.faj312
             CALL cl_digcut(m_faj.faj322,g_azi04_1) RETURNING m_faj.faj322
             CALL cl_digcut(m_faj.faj332,g_azi04_1) RETURNING m_faj.faj332
             CALL cl_digcut(m_faj.faj352,g_azi04_1) RETURNING m_faj.faj352
             CALL cl_digcut(m_faj.faj592,g_azi04_1) RETURNING m_faj.faj592
             CALL cl_digcut(m_faj.faj602,g_azi04_1) RETURNING m_faj.faj602
            #CHI-C60010---end---
             INSERT INTO faj_file VALUES (m_faj.*)
             IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                LET g_showmsg = m_faj.faj01,"/",m_faj.faj02,"/",m_faj.faj022                  #No.FUN-710028
                CALL s_errmsg('faj01,faj02,faj022',g_showmsg,'ins faj',STATUS,1)              #No.FUN-710028
                LET g_success = 'N' CONTINUE FOREACH   #No.FUN-710028
             END IF
                #-----更新參數檔之已用編號-----
                 UPDATE faa_file SET faa031 = l_faa031
                 IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
                    CALL s_errmsg('faa031',l_faa031,'upd faa',STATUS,1)         #No.FUN-710028
                    LET g_success = 'N' CONTINUE FOREACH  #No.FUN-710028
                 END IF
         ELSE   #------已存在------------------
                 UPDATE faj_file SET faj13  = faj13 + l_faj.faj13, #單價
                                     faj14  = faj14 + l_faj.faj14, #本幣成本
                                     faj16  = faj16 + l_faj.faj16, #原幣成本
                                     faj17  = faj17 + l_faj.faj17, #數量
                                     faj33  = faj33 + l_faj.faj33, #未折減額
                                     faj31  = faj31 + l_faj.faj31  #殘值
                                     #-----No:FUN-AB0088-----
                                     #faj142 = faj142 + l_faj.faj142, #FUN-B90096 mark 
                                     #faj332 = faj332 + l_faj.faj332, #FUN-B90096 mark
                                     #faj312 = faj312 + l_faj.faj312  #FUN-B90096 mark  
                                     #-----No:FUN-AB0088 END-----
                  WHERE faj02  = l_far.far12 AND faj022 = l_far.far121
                  IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
                     LET g_showmsg = l_far.far12,"/",l_far.far121                 #No.FUN-710028
                     CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
                     LET g_success = 'N' CONTINUE FOREACH  #No.FUN-710028
                  END IF
                #FUN-B90096----------add-------str
                 IF g_faa.faa31 = 'Y' THEN
                    #CHI-C60010---str---
                     CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
                     CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
                     CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
                    #CHI-C60010---end---
                    UPDATE faj_file SET faj142 = faj142 + l_faj.faj142, #本幣成本 
                                        faj332 = faj332 + l_faj.faj332, #未折減額 
                                        faj312 = faj312 + l_faj.faj312  #殘值
                        WHERE faj02  = l_far.far12 AND faj022 = l_far.far121
                     IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
                        LET g_showmsg = l_far.far12,"/",l_far.far121
                        CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)
                        LET g_success = 'N' CONTINUE FOREACH
                     END IF                 
                 END IF 
                #FUN-B90096----------add-------end                   
         END IF
       END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
      #--------- 過帳(1)update faqpost ----------------#
      IF g_success = 'Y' THEN
         UPDATE faq_file SET faqpost = 'Y' WHERE faq01 = g_faq.faq01
         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('faq01',g_faq.faq01,'upd faqpost',STATUS,1)                #No.FUN-710028
            LET g_faq.faqpost='N'
            LET g_success = 'N'
         ELSE
            LET g_faq.faqpost='Y'
            DISPLAY BY NAME g_faq.faqpost
         END IF
      END IF
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'N' THEN
      ROLLBACK WORK
      LET g_faq.faqpost='N'
      DISPLAY BY NAME g_faq.faqpost
   ELSE
      COMMIT WORK
      CALL cl_flow_notify(g_faq.faq01,'S')
   END IF
 
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_faq.faq01,'" AND npp011 = 1'
      LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_faq.faquser,"' '",g_faq.faquser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_faq.faq02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"    #No.FUN-680028   #MOD-860284#FUN-860040
      CALL cl_cmdrun_wait(g_str)
#FUN-C30313---mark---START-------------------------------------
#    #FUN-B60140   ---start   Add
#     IF g_faa.faa31 = "Y" THEN
#        LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_faq.faquser,"' '",g_faq.faquser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_faq.faq02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"
#        CALL cl_cmdrun_wait(g_str)
#     END IF
#    #FUN-B60140   ---end     Add
#     SELECT faq06,faq07,faq062,faq072  #FUN-B60140   Add  faq062 faq072
#       INTO g_faq.faq06,g_faq.faq07,g_faq.faq062,g_faq.faq072   #FUN-B60140   Add faq062 faq072
#FUN-C30313---mark---END---------------------------------------
      SELECT faq06,faq07             #FUN-C30313 add
        INTO g_faq.faq06,g_faq.faq07 #FUN-C30313 add
        FROM faq_file
       WHERE faq01 = g_faq.faq01
      DISPLAY BY NAME g_faq.faq06
      DISPLAY BY NAME g_faq.faq07
      #DISPLAY BY NAME g_faq.faq062   #FUN-B60140   Add #FUN-C30313 mark
      #DISPLAY BY NAME g_faq.faq072   #FUN-B60140   Add #FUN-C30313 mark
   END IF
#FUN-C30313---add---START-----
   IF g_faa.faa31 = "Y" THEN
      IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
         LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_faq.faquser,"' '",g_faq.faquser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_faq.faq02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"
         CALL cl_cmdrun_wait(g_str)
         SELECT faq062,faq072
           INTO g_faq.faq062,g_faq.faq072
           FROM faq_file
          WHERE faq01 = g_faq.faq01
         DISPLAY BY NAME g_faq.faq062
         DISPLAY BY NAME g_faq.faq072
      END IF
   END IF
#FUN-C30313---add---END-------
 
   IF g_faq.faqconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_faq.faqconf,"",g_faq.faqpost,"",g_chr,"")
END FUNCTION
 
FUNCTION t101_w()
  DEFINE  l_sql          STRING                #No.FUN-670060
  DEFINE  l_aba19        LIKE aba_file.aba19   #No.FUN-670060
  DEFINE  l_dbs          STRING                #No.FUN-670060
   DEFINE l_far    RECORD LIKE far_file.*,
          l_faj    RECORD LIKE faj_file.*,
          l_fap    RECORD LIKE fap_file.*,
          l_faj14  LIKE faj_file.faj14,
          l_fap05  LIKE fap_file.fap05,
          l_fap12  LIKE fap_file.fap12,
          l_fap13  LIKE fap_file.fap13,
          l_fap14  LIKE fap_file.fap14,
          l_fap15  LIKE fap_file.fap15,
          l_fap16  LIKE fap_file.fap16,
          l_fap17  LIKE fap_file.fap17,
          l_fap19  LIKE fap_file.fap19,
          l_fap41  LIKE fap_file.fap41,
          l_fap42  LIKE fap_file.fap42,
          #-----No:FUN-AB0088-----
          l_fap052 LIKE fap_file.fap052,
          l_fap121 LIKE fap_file.fap121,
          l_fap131 LIKE fap_file.fap131,
          l_fap141 LIKE fap_file.fap141,
          l_fap152 LIKE fap_file.fap152,
          l_fap162 LIKE fap_file.fap162,
          #-----No:FUN-AB0088 END----- 
          l_bdate,l_edate  LIKE type_file.dat,          #No.FUN-680070 DATE
          l_flag           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
  DEFINE  l_faj021    LIKE faj_file.faj021         #Add No.TQC-B20051
 
 
   IF s_shut(0) THEN RETURN END IF
   IF g_faq.faq01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_faq.* FROM faq_file WHERE faq01 = g_faq.faq01
   IF g_faq.faqpost != 'Y' THEN
      CALL cl_err(g_faq.faq01,'afa-108',0)
      RETURN
   END IF
   IF NOT cl_null(g_faq.faq06) AND g_fah.fahglcr != 'Y' THEN 
      CALL cl_err(g_faq.faq06,'aap-145',1) RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_faq.faq02 < g_faa.faa09 THEN
      CALL cl_err(g_faq.faq01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-

  #FUN_B60140   ---start   Add
   IF g_faa.faa31 = "Y" THEN
      #-->立帳日期小於關帳日期
      IF g_faq.faq02 < g_faa.faa092 THEN
         CALL cl_err(g_faq.faq01,'aap-176',1) RETURN
      END IF
   END IF
  #FUN_B60140   ---end     Add

   #--->折舊年月判斷必須為當月
   #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
   #CHI-A60036 add --start--
   CALL s_get_bookno(g_faa.faa07)   
       RETURNING g_flag,g_bookno1,g_bookno2
  #FUN-B60140   ---start   Mark
 ##IF g_aza.aza63 = 'Y' THEN   #FUN-AB0088 mark
  #IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
  #   CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
  #ELSE
  #   CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
  #END IF
  ##CHI-A60036 add --end--
  #FUN-B60140   ---end     Mark
  #FUN-B60140   ---start   Add
   CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
   IF g_faq.faq02 < l_bdate OR g_faq.faq02 > l_edate THEN
      CALL cl_err(g_faq.faq02,'afa-339',0)
      RETURN
   END IF

   IF g_faa.faa31 = "Y" THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
      IF g_faq.faq02 < l_bdate OR g_faq.faq02 > l_edate THEN
         CALL cl_err(g_faq.faq02,'afa-339',0)
         RETURN
      END IF
   END IF
  #FUN-B60140   ---end     Add
   IF g_faq.faq02 < l_bdate OR g_faq.faq02 > l_edate THEN
      CALL cl_err(g_faq.faq02,'afa-339',0)
      RETURN
   END IF
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_faq.faq01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
   IF NOT cl_null(g_faq.faq06) OR NOT cl_null(g_faq.faq07) THEN
      IF NOT (g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y') THEN
         CALL cl_err(g_faq.faq01,'axr-370',0) RETURN
      END IF
   END IF
#FUN-C30313---add---START-----
   IF NOT cl_null(g_faq.faq062) OR NOT cl_null(g_faq.faq072) THEN
      IF NOT (g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y') THEN
         CALL cl_err(g_faq.faq01,'axr-370',0) RETURN
      END IF
   END IF
#FUN-C30313---add---END-------
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
     #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",   #FUN-A50102
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102
                  "  WHERE aba00 = '",g_faa.faa02b,"'",
                  "    AND aba01 = '",g_faq.faq06,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
      PREPARE aba_pre FROM l_sql
      DECLARE aba_cs CURSOR FOR aba_pre
      OPEN aba_cs
      FETCH aba_cs INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_faq.faq06,'axr-071',1)
         RETURN
      END IF
#FUN-C30313---mark---START--------------------------------------
#    #FUN-B60140   ---start   Add
#     IF g_faa.faa31 = "Y" THEN
#        LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),
#                    "  WHERE aba00 = '",g_faa.faa02c,"'",
#                    "    AND aba01 = '",g_faq.faq062,"'"
#        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
#        PREPARE aba_pre13 FROM l_sql
#        DECLARE aba_cs13 CURSOR FOR aba_pre13
#        OPEN aba_cs13
#        FETCH aba_cs13 INTO l_aba19
#        IF l_aba19 = 'Y' THEN
#           CALL cl_err(g_faq.faq062,'axr-071',1)
#           RETURN
#        END IF
#     END IF
#    #FUN-B60140   ---end     Add
#FUN-C30313---mark---END--------------------------------------
   END IF
#FUN-C30313---add---START-----
   IF g_faa.faa31 = "Y" THEN
      IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN
         LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),
                     "  WHERE aba00 = '",g_faa.faa02c,"'",
                     "    AND aba01 = '",g_faq.faq062,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
         PREPARE aba_pre13 FROM l_sql
         DECLARE aba_cs13 CURSOR FOR aba_pre13
         OPEN aba_cs13
         FETCH aba_cs13 INTO l_aba19
         IF l_aba19 = 'Y' THEN
            CALL cl_err(g_faq.faq062,'axr-071',1)
            RETURN
         END IF
      END IF
   END IF
#FUN-C30313---add---END-------
   IF NOT cl_sure(18,20) THEN RETURN END IF
  #---------------------------CHI-C90051--------------------(S)
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_faq.faq06,"' '1' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT faq06,faq07
        INTO g_faq.faq06,g_faq.faq07
        FROM faq_file
       WHERE faq01 = g_faq.faq01
      DISPLAY BY NAME g_faq.faq06
      DISPLAY BY NAME g_faq.faq07
      IF NOT cl_null(g_faq.faq06) THEN
         CALL cl_err('','aap-929',0)
         RETURN
      END IF
      IF g_faa.faa31 = "Y" THEN
         LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_faq.faq062,"' '1' 'Y'"
         CALL cl_cmdrun_wait(g_str)
         SELECT faq062,faq072
           INTO g_faq.faq062,g_faq.faq072
           FROM faq_file
          WHERE faq01 = g_faq.faq01
         DISPLAY BY NAME g_faq.faq062
         DISPLAY BY NAME g_faq.faq072
         IF NOT cl_null(g_faq.faq062) THEN
            CALL cl_err('','aap-929',0)
            RETURN
         END IF
      END IF
   END IF
  #---------------------------CHI-C90051--------------------(E)
   BEGIN WORK
 
    OPEN t101_cl USING g_faq.faq01
    IF STATUS THEN
       CALL cl_err("OPEN t101_cl:", STATUS, 1)
       CLOSE t101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t101_cl INTO g_faq.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faq.faq01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t101_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
   #--------- 還原過帳(2)update faj_file
   DECLARE t101_cur3 CURSOR FOR
      SELECT * FROM far_file WHERE far01=g_faq.faq01
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t101_cur3 INTO l_far.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('far01',g_faq.faq01,'foreach:',SQLCA.sqlcode,1)   #No.FUN-710028
         EXIT FOREACH
      END IF
      #----- 找出 faj_file 中對應之財產編號+附號
        SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_far.far03
                                            AND faj022=l_far.far031
        IF STATUS THEN
            CALL cl_err('sel faj',STATUS,1)
         LET g_showmsg = l_far.far03,"/",l_far.far031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,0)   #No.FUN-710028
         CONTINUE FOREACH   #No.FUN-710028
      END IF
      #------97/09/11 此筆資料已折舊仍可作過帳還原------
       IF l_faj.faj43 = '2' THEN
          CALL cl_err(l_faj.faj43,'afa-348',0)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
      #----- 找出 fap_file 之 fap05 以便 update faj_file.faj43
      SELECT fap05,fap052,fap17,fap19,fap12,fap13,fap15,fap16,fap14,fap41,fap42, #No:FUN-AB0088 add fap052
             fap121,fap131,fap141,fap152,fap162   #No:FUN-AB0088
        INTO l_fap05,l_fap052,l_fap17,l_fap19,l_fap12,l_fap13,l_fap15,l_fap16,l_fap14,   #No:FUN-AB0088 add l_fap052
             l_fap41,l_fap42,
             l_fap121,l_fap131,l_fap141,l_fap152,l_fap162   #No:FUN-AB0088  
        FROM fap_file
       WHERE fap50=l_far.far01     AND fap501=l_far.far02
         AND fap03='1'    ## 異動代號
      IF STATUS THEN #No.7926
         LET g_showmsg = l_far.far01,"/",l_far.far02,"/",'1'                           #No.FUN-710028
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'sel fap',STATUS,1)              #No.FUN-710028
         LET g_success = 'N'
      END IF
      #--------------資本化後之財產編號相同
      IF l_far.far03 = l_far.far12 AND l_far.far031 = l_far.far121 THEN 
            UPDATE faj_file SET faj43  = l_fap05,        #資產狀態
                                faj432 = l_fap052,       #FUN-AB0088  
                                faj201 = l_fap42,
                                faj20  = l_fap17,        #保管部門
                                faj21  = l_fap19,        #存放位置
                                faj23  = l_fap15,        #分攤方式
                                faj24  = l_fap16,        #分攤部門
                                faj53  = l_fap12,        #資產科目
                                faj54  = l_fap13,        #累折科目
                                faj55  = l_fap14,        #折舊科目
                                faj100 = l_fap41         #最近異動日期
                                #-----No:FUN-AB0088-----
                                #faj232 = l_fap152, #FUN-B90096 mark        
                                #faj242 = l_fap162, #FUN-B90096 mark      
                                #faj531 = l_fap121, #FUN-B90096 mark      
                                #faj541 = l_fap131, #FUN-B90096 mark     
                                #faj551 = l_fap141  #FUN-B90096 mark     
                                #-----No:FUN-AB0088 END-----
          WHERE faj02=l_far.far03 AND faj022=l_far.far031
         IF STATUS OR SQLCA.SQLCODE=100 THEN
            LET g_showmsg = l_far.far03,"/",l_far.far031                 #No.FUN-710028
            CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
            LET g_success = 'N' CONTINUE FOREACH  #No.FUN-710028
         END IF
         #FUN-B90096----------add-------str
         IF g_faa.faa31 = 'Y' THEN
            UPDATE faj_file SET faj232 = l_fap152, #分攤方式       
                                faj242 = l_fap162, #分攤部門      
                                faj531 = l_fap121, #資產科目     
                                faj541 = l_fap131, #累折科目     
                                faj551 = l_fap141  #折舊科目
               WHERE faj02=l_far.far03 AND faj022=l_far.far031
            IF STATUS OR SQLCA.SQLCODE=100 THEN
               LET g_showmsg = l_far.far03,"/",l_far.far031
               CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)
               LET g_success = 'N' CONTINUE FOREACH
            END IF            
         END IF 
         #FUN-B90096----------add-------end          
      ELSE
         #----2-1.資本化後之財產編號不同以far03,far031更新----------
         UPDATE faj_file SET faj43  = l_fap05,
                             faj201 = l_fap05,
                             faj100 = l_fap41
          WHERE faj02 = l_far.far03 AND faj022 = l_far.far031
           IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
              LET g_showmsg = l_far.far03,"/",l_far.far031                 #No.FUN-710028
              CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
              LET g_success = 'N' CONTINUE FOREACH  #No.FUN-710028
           END IF
         #----2-2.資本化後之財產編號不同以far03,far031更新----------
           SELECT faj14 INTO l_faj14 FROM faj_file
                        WHERE faj02  = l_far.far12 AND faj022 = l_far.far121
           IF STATUS THEN   
              LET g_showmsg = l_far.far12,"/",l_far.far121            #No.FUN-710028
              CALL s_errmsg('faj02,faj022',g_showmsg,' ',STATUS,1)    #No.FUN-710028
              LET g_success = 'N' END IF
           #----->本幣成本 > 資本化前之本幣成本
           IF l_faj14 > l_faj.faj14 THEN
              UPDATE faj_file SET faj13 = faj13 - l_faj.faj13,
                                  faj14 = faj14 - l_faj.faj14,
                                  faj16 = faj16 - l_faj.faj16,
                                  faj17 = faj17 - l_faj.faj17,
                                  faj33 = faj33 - l_faj.faj33, #未折減額
                                  faj31 = faj31 - l_faj.faj31
                                  #-----No:FUN-AB0088-----
                                  #faj142 = faj142 - l_faj.faj142, #FUN-B90096 mark
                                  #faj332 = faj332 - l_faj.faj332, #FUN-B90096 mark
                                  #faj312 = faj312 - l_faj.faj312 #FUN-B90096 mark
                                  #-----No:FUN-AB0088 END-----
               WHERE faj02 = l_far.far12 AND faj022 = l_far.far121
               #FUN-B90096----------add-------str
               IF g_faa.faa31 = 'Y' THEN
                 #CHI-C60010---str---
                  CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
                  CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
                  CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
                 #CHI-C60010---end---
                  UPDATE faj_file SET faj142 = faj142 - l_faj.faj142,
                                      faj332 = faj332 - l_faj.faj332, #未折減額
                                      faj312 = faj312 - l_faj.faj312
                     WHERE faj02 = l_far.far12 AND faj022 = l_far.far121
                  IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
                     LET g_showmsg = l_far.far12,"/",l_far.far121
                     CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)
                     LET g_success = 'N' CONTINUE FOREACH
                  END IF    
               END IF 
               #FUN-B90096----------add-------end
           ELSE
              #Add No.TQC-B20051
              LET l_faj021 = ''
              LET l_faj021 = l_faj.faj021
              IF cl_null(l_faj021) THEN
                 IF not cl_null(l_far.far121) THEN
                    LET l_faj021 = '2'
                 ELSE
                    LET l_faj021 = '1'
                 END IF
              #Add No.TQC-B20051
              ELSE
                 IF cl_null(l_far.far121) THEN
                    LET l_faj021 = '1'
                 END IF
              #End Add No.TQC-B20051
              END IF
              #Add No.TQC-B20051
              DELETE FROM faj_file WHERE faj02  = l_far.far12
                                     AND faj022 = l_far.far121
                                    #AND faj021 = '3'   #MOD-950185
                                     AND faj021 = l_faj021   #Mod No.TQC-B20051
              IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
                 LET g_showmsg = l_far.far12,"/",l_far.far121                 #No.FUN-710028
                 CALL s_errmsg('faj02,faj022',g_showmsg,'del faj',STATUS,1)   #No.FUN-710028
                 LET g_success = 'N'  CONTINUE FOREACH #No.FUN-710028
              END IF
           END IF
      END IF
      #--------- 還原過帳(3)delete fap_file
      DELETE FROM fap_file WHERE fap50=l_far.far01
                             AND fap501=l_far.far02
                             AND fap03 = '1'
      IF STATUS OR SQLCA.SQLCODE=100 THEN
         CALL cl_err3("del","fap_file",l_far.far01,l_far.far02,STATUS,"","del fap",1)  #No.FUN-660136
         LET g_success = 'N'  CONTINUE FOREACH #No.FUN-710028
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   #--------- 還原過帳(1)update faq_file
   IF g_success = 'Y' THEN
      UPDATE faq_file SET faqpost = 'N' WHERE faq01 = g_faq.faq01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('faq01',g_faq.faq01,'upd faqpost',STATUS,1)                #No.FUN-710028
         LET g_faq.faqpost='Y'
         LET g_success = 'N'
      ELSE
         LET g_faq.faqpost='N'
         DISPLAY BY NAME g_faq.faqpost
      END IF
   END IF
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'N' THEN
      ROLLBACK WORK
      LET g_faq.faqpost='Y'
      DISPLAY BY NAME g_faq.faqpost
      RETURN
   ELSE
      COMMIT WORK
   END IF
 #--------------------------------CHI-C90051--------------------------mark
 # IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
 #    LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_faq.faq06,"' '1' 'Y'"
 #    CALL cl_cmdrun_wait(g_str)
 #  #FUN-C30313---mark---START------------------------
 #  ##FUN-B60140   ---start   Add
 #  # IF g_faa.faa31 = "Y" THEN
 #  #    LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_faq.faq062,"' '1' 'Y'"
 #  #    CALL cl_cmdrun_wait(g_str)
 #  # END IF
 #  ##FUN-B60140   ---end     Add
 #  # SELECT faq06,faq07,faq062,faq072     #FUN-B60140   Add faq062 faq072
 #  #   INTO g_faq.faq06,g_faq.faq07,g_faq.faq062,g_faq.faq072    #FUN-B60140   Add faq062 faq072
 #  #FUN-C30313---mark---END--------------------------
 #    SELECT faq06,faq07             #FUN-C30313 add
 #      INTO g_faq.faq06,g_faq.faq07 #FUN-C30313 add
 #      FROM faq_file
 #     WHERE faq01 = g_faq.faq01
 #    DISPLAY BY NAME g_faq.faq06
 #    DISPLAY BY NAME g_faq.faq07
 #    #DISPLAY BY NAME g_faq.faq062   #FUN-B60140   Add #FUN-C30313 mark
 #    #DISPLAY BY NAME g_faq.faq072   #FUN-B60140   Add #FUN-C30313 mark
 # END IF
 ##FUN-C30313---add---START-----
 # IF g_faa.faa31 = "Y" THEN
 #    IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
 #       LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_faq.faq062,"' '1' 'Y'"
 #       CALL cl_cmdrun_wait(g_str)
 #       SELECT faq062,faq072
 #         INTO g_faq.faq062,g_faq.faq072
 #         FROM faq_file
 #        WHERE faq01 = g_faq.faq01
 #       DISPLAY BY NAME g_faq.faq062
 #       DISPLAY BY NAME g_faq.faq072         
 #    END IF
 # END IF
 ##FUN-C30313---add---END-------
 #--------------------------------CHI-C90051--------------------------mark
    IF g_faq.faqconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_faq.faqconf,"",g_faq.faqpost,"",g_chr,"")
END FUNCTION
 
#1.作废、2.取消作废
#FUNCTION t101_x()                  #FUN-D20035
FUNCTION t101_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_faq.* FROM faq_file WHERE faq01=g_faq.faq01
   IF g_faq.faq01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_faq.faqconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_faq.faqconf='X' THEN RETURN END IF
   ELSE
      IF g_faq.faqconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   BEGIN WORK
   LET g_success='Y'
 
   OPEN t101_cl USING g_faq.faq01
   IF STATUS THEN
      CALL cl_err("OPEN t101_cl:", STATUS, 1)
      CLOSE t101_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t101_cl INTO g_faq.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_faq.faq01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t101_cl ROLLBACK WORK RETURN
   END IF
    #-->作廢轉換01/08/01
   #IF cl_void(0,0,g_faq.faqconf)   THEN                                #FUN-D20035
    IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #FUN-D20035
    IF cl_void(0,0,l_flag) THEN                                         #FUN-D20035
        LET g_chr=g_faq.faqconf
       #IF g_faq.faqconf ='N' THEN                                      #FUN-D20035
        IF p_type = 1 THEN                                              #FUN-D20035
            LET g_faq.faqconf='X'
        ELSE
            LET g_faq.faqconf='N'
        END IF
 
   UPDATE faq_file SET faqconf = g_faq.faqconf,faqmodu=g_user,faqdate=TODAY
          WHERE faq01 = g_faq.faq01
   IF STATUS THEN 
      CALL cl_err3("upd","faq_file",g_faq.faq01,"",STATUS,"","upd faqconf:",1)  #No.FUN-660136
      LET g_success='N' END IF
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_faq.faq01,'V')
   ELSE
      ROLLBACK WORK
   END IF
   SELECT faqconf INTO g_faq.faqconf FROM faq_file
    WHERE faq01 = g_faq.faq01
   DISPLAY BY NAME g_faq.faqconf
  END IF
 
  IF g_faq.faqconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  CALL cl_set_field_pic(g_faq.faqconf,"",g_faq.faqpost,"",g_chr,"")
END FUNCTION
 
FUNCTION t101_gen_glcr(p_faq,p_fah)
  DEFINE p_faq     RECORD LIKE faq_file.*
  DEFINE p_fah     RECORD LIKE fah_file.*
 
    IF cl_null(p_fah.fahgslp) THEN
       CALL cl_err(p_faq.faq01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL s_showmsg_init()    #No.FUN-710028
    IF p_fah.fahdmy3 = 'Y' AND p_fah.fahglcr = 'Y' THEN #FUN-C30313 add
       CALL t101_gl(g_faq.faq01,g_faq.faq02,'0')
    END IF #FUN-C30313 add
   #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN   #FUN-AB0088 mark
    IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #No:FUN-AB0088
       IF p_fah.fahdmy32 = 'Y' AND p_fah.fahglcr = 'Y' THEN #FUN-C30313 add
          CALL t101_gl(g_faq.faq01,g_faq.faq02,'1')
       END IF #FUN-C30313 add
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t101_carry_voucher()
  DEFINE l_fahgslp    LIKE fah_file.fahgslp
  DEFINE li_result    LIKE type_file.num5          #No.FUN-680070 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF NOT cl_null(g_faq.faq06)  THEN
       CALL cl_err(g_faq.faq06,'aap-618',1)
       RETURN
    END IF
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
          IF NOT cl_null(g_faq.faq062)  THEN
             CALL cl_err(g_faq.faq062,'aap-618',1)
             RETURN
          END IF
       END IF #FUN-C30313 add
    END IF
   #FUN-B90004---End---
 
    CALL s_get_doc_no(g_faq.faq01) RETURNING g_t1
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
    IF g_fah.fahdmy3 = 'N' THEN RETURN END IF
   #IF g_fah.fahglcr = 'Y' THEN               #FUN-B90004
    IF g_fah.fahglcr = 'Y' OR ( g_fah.fahglcr = 'N' AND NOT cl_null(g_fah.fahgslp)) THEN   #FUN-B90004 
       LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
      #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",  #FUN-A50102
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102
                   "  WHERE aba00 = '",g_faa.faa02b,"'",
                   "    AND aba01 = '",g_faq.faq06,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
       PREPARE aba_pre2 FROM l_sql
       DECLARE aba_cs2 CURSOR FOR aba_pre2
       OPEN aba_cs2
       FETCH aba_cs2 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_faq.faq06,'aap-991',1)
          RETURN
       END IF
     #FUN-B90004--Begin Mark--移到下方
     ##FUN-B60140   ---start   Add
     # IF g_faa.faa31 = "Y" THEN
     #    LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'),
     #                "  WHERE aba00 = '",g_faa.faa02c,"'",
     #                "    AND aba01 = '",g_faq.faq062,"'"
     #    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     #    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
     #    PREPARE aba_pre21 FROM l_sql
     #    DECLARE aba_cs21 CURSOR FOR aba_pre21
     #    OPEN aba_cs21
     #    FETCH aba_cs21 INTO l_n
     #    IF l_n > 0 THEN
     #       CALL cl_err(g_faq.faq062,'aap-991',1)
     #       RETURN
     #    END IF
     # END IF
     ##FUN-B60140   ---end     Add
     #FUN-B90004---End Mark---
       LET l_fahgslp = g_fah.fahgslp
    ELSE
      #CALL cl_err('','aap-992',1)   #FUN-B90004 mark
       CALL cl_err('','aap-936',1)   #FUN-B90004
       RETURN

    END IF
   #FUN-B90004--Begin--
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahglcr = 'Y' OR ( g_fah.fahglcr = 'N' AND NOT cl_null(g_fah.fahgslp1)) THEN 
          LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'),
                      "  WHERE aba00 = '",g_faa.faa02c,"'",
                      "    AND aba01 = '",g_faq.faq062,"'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
          PREPARE aba_pre21 FROM l_sql
          DECLARE aba_cs21 CURSOR FOR aba_pre21
          OPEN aba_cs21
          FETCH aba_cs21 INTO l_n
          IF l_n > 0 THEN
             CALL cl_err(g_faq.faq062,'aap-991',1)
             RETURN
          END IF
       ELSE
          CALL cl_err('','aap-936',1)
          RETURN
       END IF
    END IF
   #FUN-B90004---End---
    IF cl_null(l_fahgslp) THEN
       CALL cl_err(g_faq.faq01,'axr-070',1)
       RETURN
    END IF
   #IF g_aza.aza63='Y' THEN   #MOD-860284 add   #FUN-AB0088 mark
    IF g_faa.faa31 = 'Y' THEN #FUN-AB0088
       IF cl_null(g_fah.fahgslp1) THEN
          CALL cl_err(g_faq.faq01,'axr-070',1)
          RETURN
       END IF
    END IF                    #MOD-860284 add
    LET g_wc_gl = 'npp01 = "',g_faq.faq01,'" AND npp011 = 1'
    LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_faq.faquser,"' '",g_faq.faquser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_faq.faq02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"' "  #No.FUN-680028   #MOD-860284#FUN-860040
    CALL cl_cmdrun_wait(g_str)
   #FUN-B60140   ---start   Add
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = 'Y' THEN #FUN-C30313 add
          LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_faq.faquser,"' '",g_faq.faquser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_faq.faq02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"' "
          CALL cl_cmdrun_wait(g_str)
       END IF #FUN-C30313 add
    END IF
   #FUN-B60140   ---end     Add
    SELECT faq06,faq07,faq062,faq072   #FUN-B60140   Add
      INTO g_faq.faq06,g_faq.faq07,g_faq.faq062,g_faq.faq072    #FUN-B60140   Add
      FROM faq_file
     WHERE faq01 = g_faq.faq01
    DISPLAY BY NAME g_faq.faq06
    DISPLAY BY NAME g_faq.faq07
    DISPLAY BY NAME g_faq.faq062    #FUN-B60140   Add
    DISPLAY BY NAME g_faq.faq072    #FUN-B60140   Add
    
END FUNCTION
 
FUNCTION t101_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_dbs      STRING 
  DEFINE l_sql      STRING
 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF cl_null(g_faq.faq06)  THEN
       CALL cl_err(g_faq.faq06,'aap-619',1)
       RETURN
    END IF
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
          IF cl_null(g_faq.faq062)  THEN
             CALL cl_err(g_faq.faq062,'aap-619',1)
             RETURN
          END IF
       END IF #FUN-C30313 add
    END IF
   #FUN-B90004---End---
 
    CALL s_get_doc_no(g_faq.faq01) RETURNING g_t1
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
   #IF g_fah.fahglcr = 'N' THEN     #FUN-B90004 mark
   #   CALL cl_err('','aap-990',1)  #FUN-B90004 mark
    IF g_fah.fahglcr = 'N' AND cl_null(g_fah.fahgslp) THEN    #FUN-B90004
       CALL cl_err('','aap-936',1)  #FUN-B90004
       RETURN
    END IF
   #FUN-B90004--Begin--
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahglcr = 'N' AND cl_null(g_fah.fahgslp1) THEN
          CALL cl_err('','aap-936',1)
          RETURN
       END IF
    END IF
   #FUN-B90004---End---
    LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",   #FUN-A50102
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102
                "  WHERE aba00 = '",g_faa.faa02b,"'",
                "    AND aba01 = '",g_faq.faq06,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
    PREPARE aba_pre1 FROM l_sql
    DECLARE aba_cs1 CURSOR FOR aba_pre1
    OPEN aba_cs1
    FETCH aba_cs1 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_faq.faq06,'axr-071',1)
       RETURN
    END IF
   #FUN-B60140   ---start   Add
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
          LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),
                      "  WHERE aba00 = '",g_faa.faa02c,"'",
                      "    AND aba01 = '",g_faq.faq062,"'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
          PREPARE aba_pre12 FROM l_sql
          DECLARE aba_cs12 CURSOR FOR aba_pre12
          OPEN aba_cs12
          FETCH aba_cs12 INTO l_aba19
          IF l_aba19 = 'Y' THEN
             CALL cl_err(g_faq.faq062,'axr-071',1)
             RETURN
          END IF
       END IF #FUN-C30313 add
    END IF
   #FUN-B60140   ---end     Add
    LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_faq.faq06,"' '1' 'Y'"
    CALL cl_cmdrun_wait(g_str)
   #FUN-B60140   ---start   Add
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
          LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_faq.faq062,"' '1' 'Y'"
          CALL cl_cmdrun_wait(g_str)
       END IF #FUN-C30313 add
    END IF
   #FUN-B60140   ---end     Add
    SELECT faq06,faq07,faq062,faq072    #FUN-B60140   Add
      INTO g_faq.faq06,g_faq.faq07,g_faq.faq062,g_faq.faq072   #FUN-B60140   Add
      FROM faq_file
     WHERE faq01 = g_faq.faq01
    DISPLAY BY NAME g_faq.faq06
    DISPLAY BY NAME g_faq.faq07
    DISPLAY BY NAME g_faq.faq062     #FUN-B60140    Add
    DISPLAY BY NAME g_faq.faq072     #FUN-B60140    Add
END FUNCTION

#-----No:FUN-AB0088-----
FUNCTION t101_fin_audit2()
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_rec_b2   LIKE type_file.num5
   DEFINE l_faj28    LIKE faj_file.faj28 

   OPEN WINDOW t101_w2 WITH FORM "afa/42f/afat1019"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("afat1019")

   LET g_sql = "SELECT far02,far03,far031,'',far12,far121,far042,far272,far071,far081,",
               "       far092,far102,far111",
               "  FROM far_file ",
               " WHERE far01 = '",g_faq.faq01,"' ",
               " ORDER BY far02 "

   PREPARE afat101_2_pre FROM g_sql

   DECLARE afat101_2_c CURSOR FOR afat101_2_pre

   CALL g_far2.clear()

   LET l_cnt = 1

   FOREACH afat101_2_c INTO g_far2[l_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach far2',STATUS,0)
         EXIT FOREACH
      END IF

      SELECT faj06 INTO g_far2[l_cnt].faj06
        FROM faj_file
       WHERE faj02 = g_far2[l_cnt].far03

      LET l_cnt = l_cnt + 1

   END FOREACH

   CALL g_far2.deleteElement(l_cnt)

   LET l_rec_b2 = l_cnt - 1

   LET l_ac = 1

   CALL cl_set_act_visible("cancel", FALSE)

   IF g_faq.faqconf !="N" THEN   #絋粄┪紀虫沮琩高 
      DISPLAY ARRAY g_far2 TO s_far2.* ATTRIBUTE(COUNT=l_rec_b2,UNBUFFERED)

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
      LET g_forupd_sql = "SELECT far02,far03,far031,'',far12,far121,far042,far272,far071,far081,",
                         "       far092,far102,far111",
                         "  FROM far_file",
                         " WHERE far01 = '",g_faq.faq01,"' ",
                         "   AND far02 = ? ",
                         "   FOR UPDATE "

      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)   #FUN-AB0088
      DECLARE t101_2_bcl CURSOR FROM g_forupd_sql 
       
      INPUT ARRAY g_far2 WITHOUT DEFAULTS FROM s_far2.*
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
               LET g_far2_t.* = g_far2[l_ac].* 
               OPEN t101_2_bcl USING g_far2_t.far02
               IF STATUS THEN
                  CALL cl_err("OPEN t101_2_bcl:", STATUS, 1)
               ELSE
                  FETCH t101_2_bcl INTO g_far2[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_far2_t.far02,SQLCA.sqlcode,1)
                  END IF
                  SELECT faj06 INTO g_far2[l_ac].faj06 FROM faj_file 
                   WHERE faj02=g_far2[l_ac].far03
                  SELECT MAX(faj28) INTO l_faj28 FROM faj_file
                   WHERE faj02  = g_far2[l_ac].far03
                     AND faj022 = g_far2[l_ac].far031
                     AND fajconf = 'Y'
                  IF STATUS THEN LET l_faj28=' ' END IF
               END IF
            END IF
         
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_far2[l_ac].* = g_far2_t.*
               CLOSE t101_2_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
        
            UPDATE far_file SET far042 = g_far2[l_ac].far042, 
                                far272 = g_far2[l_ac].far272, 
                                far071 = g_far2[l_ac].far071, 
                                far081 = g_far2[l_ac].far081, 
                                far092 = g_far2[l_ac].far092, 
                                far102 = g_far2[l_ac].far102, 
                                far111 = g_far2[l_ac].far111  
             WHERE far01 = g_faq.faq01
               AND far02 = g_far2_t.far02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","far_file",g_faq.faq01,g_far2_t.far02,SQLCA.sqlcode,"","",1)  
               LET g_far2[l_ac].* = g_far2_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
      
         AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_far2[l_ac].* = g_far2_t.*
               CLOSE t101_2_bcl 
               ROLLBACK WORK 
               EXIT INPUT
            END IF
            CLOSE t101_2_bcl 
            COMMIT WORK
            
        #FUN-BC0004--add-str
        BEFORE FIELD far042
            #財簽二入帳日期給默認值：財簽一的入帳日期
            IF cl_null(g_far2[l_ac].far042) THEN
               SELECT far04 INTO g_far2[l_ac].far042 FROM far_file
                WHERE far01 = g_faq.faq01
                  AND far02 = g_far2[l_ac].far02
               DISPLAY BY NAME g_far2[l_ac].far042
            END IF
            #財簽二分攤方式給默認值：財簽一的分攤方式
            IF cl_null(g_far2[l_ac].far092) THEN
               SELECT far09 INTO g_far2[l_ac].far092 FROM far_file
                WHERE far01 = g_faq.faq01
                  AND far02 = g_far2[l_ac].far02
               DISPLAY BY NAME g_far2[l_ac].far092
            END IF
        #FUN-BC0004--add-end
        
        AFTER FIELD far042
           IF cl_null(g_far[l_ac].far05) THEN
              IF g_far2[l_ac].far03 != g_far2[l_ac].far12 OR
                 g_far2[l_ac].far031 != g_far2[l_ac].far121 THEN
                 CALL s_faj27(g_far2[l_ac].far042,g_faa.faa152) RETURNING g_far2[l_ac].far272   #FUN-B60140   Mod faa15 --> faa152
                 DISPLAY BY NAME g_far2[l_ac].far272
              END IF
           END IF
 
        AFTER FIELD far071
           IF cl_null(g_far2[l_ac].far071) THEN
              IF l_faj28<>'0' THEN NEXT FIELD far071 END IF
           ELSE
              CALL t101_acct('a',g_far2[l_ac].far071,g_faa.faa02c)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_far2[l_ac].far071,g_errno,0)
                 NEXT FIELD far071
              END IF
           END IF
 
        AFTER FIELD far081
           IF cl_null(g_far2[l_ac].far081) THEN
              IF l_faj28<>'0' THEN NEXT FIELD far081 END IF
           ELSE
              CALL t101_acct('a',g_far2[l_ac].far081,g_faa.faa02c)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_far2[l_ac].far081,g_errno,0)
                 NEXT FIELD far081
              END IF
           END IF

        AFTER FIELD far092
           IF NOT cl_null(g_far2[l_ac].far092) THEN
              IF g_far2[l_ac].far092 NOT MATCHES '[12]' THEN
                 NEXT FIELD far092
              END IF
           END IF

        AFTER FIELD far102
           IF NOT cl_null(g_far2[l_ac].far092) THEN
              IF g_far2[l_ac].far092 = '1' THEN
                 CALL t101_far101('a',g_far2[l_ac].far102)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_far2[l_ac].far102,g_errno,0)
                    LET g_far2[l_ac].far102 = g_far2_t.far102
                    DISPLAY BY NAME g_far2[l_ac].far102
                    NEXT FIELD far102
                 END IF
              ELSE
                 CALL t101_far102('a','2')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_far2[l_ac].far102,g_errno,1)
                    LET g_far2[l_ac].far102 = g_far2_t.far102
                    DISPLAY BY NAME g_far2[l_ac].far102
                    NEXT FIELD far102
                 END IF
              END IF
           END IF

        AFTER FIELD far111
           IF g_far2[l_ac].far092 = '1' THEN
              IF cl_null(g_far2[l_ac].far111) THEN
                 NEXT FIELD far111
              ELSE
                 CALL t101_acct('a',g_far2[l_ac].far111,g_faa.faa02c)
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_far2[l_ac].far111,g_errno,0)
                      NEXT FIELD far111
                   END IF
              END IF
           ELSE
               LET g_far2[l_ac].far111 = ' '
           END IF

        ON ACTION controlp 
           CASE
              WHEN INFIELD(far071)  #資產科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]' "
                 LET g_qryparam.default1 = g_far2[l_ac].far071
                 LET g_qryparam.arg1 = g_faa.faa02c
                 CALL cl_create_qry() RETURNING g_far2[l_ac].far071
                 DISPLAY g_far2[l_ac].far071 TO far071
                 NEXT FIELD far071
              WHEN INFIELD(far081)  #累折科目 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]' "
                 LET g_qryparam.default1 = g_far2[l_ac].far081
                 LET g_qryparam.arg1 = g_faa.faa02c
                 CALL cl_create_qry() RETURNING g_far2[l_ac].far081
                 DISPLAY g_far2[l_ac].far081 TO far081
                 NEXT FIELD far081
              WHEN INFIELD(far102)  #分攤部門
                 IF g_far2[l_ac].far092 ='1' THEN 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.default1 = g_far2[l_ac].far102
                    CALL cl_create_qry() RETURNING g_far2[l_ac].far102
                    DISPLAY g_far2[l_ac].far102 TO far102
                    NEXT FIELD far102
                 ELSE
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ='q_fad'
                    LET g_qryparam.default1 = g_far2[l_ac].far102
                    CALL cl_create_qry() RETURNING g_far2[l_ac].far071,g_far2[l_ac].far102
                    DISPLAY BY NAME g_far2[l_ac].far071
                    DISPLAY BY NAME g_far2[l_ac].far102
                    NEXT FIELD far102
                 END IF
              WHEN INFIELD(far111)  #折舊科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]' "
                 LET g_qryparam.default1 = g_far2[l_ac].far111
                 LET g_qryparam.arg1 = g_faa.faa02c
                 CALL cl_create_qry() RETURNING g_far2[l_ac].far111
                 DISPLAY g_far2[l_ac].far111 TO far111
                 NEXT FIELD far111
              OTHERWISE
                 EXIT CASE
           END CASE

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
 
   CLOSE WINDOW t101_w2

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

END FUNCTION

#-----No:FUN-AB0088 END-----
 
#No.FUN-9C0077 程式精簡

