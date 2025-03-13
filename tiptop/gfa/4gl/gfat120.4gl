# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: gfat120.4gl
# Descriptions...: 固定資產減值準備作業
# Date & Author..: 03/11/14 By Danny
# Modify.........: No.MOD-4A0248 04/10/26 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4C0058 04/12/08 By Smapmin 加入權限控管
# Modify.........: No.MOD-530223 05/04/14 By Smapmin 單身自動產生輸入財編後未自動產生至單身
# Modify.........: NO.FUN-550034 05/05/20 By jackie 單據編號加大
# Modify.........: No.FUN-5B0018 05/11/04 By Sarah 減值日期沒有判斷關帳日
# Modify.........: No.FUN-5B0116 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.MOD-620023 06/02/10 By Smapmin 減值準備金調增時:不可以大於已提列減值金額
#                                                              調減時:不可大於 [未折減餘額 - 已提列減值準備值]
# Modify.........: No.TQC-620120 06/03/02 By Smapmin 當附號為NULL時,LET 附號為空白
# Modify.........: No.TQC-630069 06/03/07 By Smapmin 流程訊息通知功能
# Modify.........: No.TQC-660071 06/06/14 By Smapmin 補充TQC-630069
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670060 06/08/08 By Ray 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680028 06/08/22 By Ray 多帳套修改
# Modify.........: No.FUN-690009 06/09/18 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0150 06/10/27 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0097 06/10/31 By hongmei l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-690113 06/12/06 By Smapmin 確認後不可再重新產生分錄
# Modify.........: No.MOD-720074 07/03/01 By Smapmin 檢查資產盤點期間應不可做異動
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740026 07/04/10 By Judy 會計科目加帳套 
# Modify.........: No.TQC-740305 07/04/27 By Lynn 新增取消單身刪除單頭功能
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-850068 08/05/14 By TSD.Wind 自定欄位功能修改
# Modify.........: NO.MOD-860078 08/06/10 By yiting ON IDLE處理
# Modify.........: No.MOD-970231 09/07/24 By Sarah 計算未折減額時,應抓faj33+faj331
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-980143 09/08/18 By sabrina 稅簽過帳時，計算faj103稅簽減值準備金額有誤，應同faj101計算方式(調減-調增) 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc\
# Modify.........: No.FUN-A50102 10/06/22 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A60036 10/07/12 By Summer 過帳檢查改用s_azmm,增加aza63判斷
# ModIFy.........: No:MOD-A80137 10/08/19 By Dido 過帳與取消過帳應檢核關帳日 
# Modify.........: No.FUN-AB0088 11/04/02 By chenying 因固資拆出財二功能，原本寫入fap亦有新增欄位，增加對應處理
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/06/07 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50065 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B60165 11/06/22 By Polly 財二欄位給值錯誤，導至單據無法自動產生和過帳
# Modify.........: No.TQC-B60345 11/06/27 By Sarah 過帳會出現INSERT INTO fap_file有null值的錯誤
# Modify.........: No:FUN-B80025 11/08/03 By minpp 模组程序撰写规范
# Modify.........: No:FUN-B60140 11/09/08 By minpp "財簽二二次改善" 追單
# Modify.........: NO:FUN-B90004 11/09/20 By Belle 自動拋轉傳票單別一欄有值，即可進行傳票拋轉/傳票拋轉還原
# Modify.........: No:FUN-BC0004 11/12/01 By xuxz 處理相關財簽二無法存檔問題
# Modify.........: NO:FUN-BB0122 12/01/13 By Sakura 財二預設修改
# Modify.........: No:MOD-BC0125 12/01/13 By Sakura 產生分錄及分錄底稿Action加判斷
#                                                    產生分錄(財簽二)及分錄底稿(財簽二)加判斷
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 原使用fahdmy3判斷的程式，將財二部份拆分出來使用fahdmy32處理
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:CHI-C60010 12/06/12 By jinjj 財簽二欄位需依財簽二幣別做取位
# Modify.........: No.CHI-C30107 12/06/21 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C90051 12/09/08 By Polly 將拋轉還原程式移至更新確認碼/過帳碼前處理，並判斷傳票編號如不為null時，則RETURN
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No.FUN-D20035 13/02/20 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fbs   RECORD LIKE fbs_file.*,
    g_fbs_t RECORD LIKE fbs_file.*,
    g_fbs_o RECORD LIKE fbs_file.*,
    g_fahconf       LIKE fah_file.fahconf,
    g_fahpost       LIKE fah_file.fahpost,
    g_fbt           DYNAMIC ARRAY of RECORD    #程式變數(Program Variables)
                    fbt02     LIKE fbt_file.fbt02,
                    fbt03     LIKE fbt_file.fbt03,
                    fbt031    LIKE fbt_file.fbt031,
                    faj06     LIKE faj_file.faj06,
                    fbt04     LIKE fbt_file.fbt04,
                    fbt05     LIKE fbt_file.fbt05,
                    fbt06     LIKE fbt_file.fbt06,
                    fbt07     LIKE fbt_file.fbt07,
                    fbt08     LIKE fbt_file.fbt08,
                    fbt09     LIKE fbt_file.fbt09,
                    #FUN-850068 --start---
                    fbtud01   LIKE fbt_file.fbtud01,
                    fbtud02   LIKE fbt_file.fbtud02,
                    fbtud03   LIKE fbt_file.fbtud03,
                    fbtud04   LIKE fbt_file.fbtud04,
                    fbtud05   LIKE fbt_file.fbtud05,
                    fbtud06   LIKE fbt_file.fbtud06,
                    fbtud07   LIKE fbt_file.fbtud07,
                    fbtud08   LIKE fbt_file.fbtud08,
                    fbtud09   LIKE fbt_file.fbtud09,
                    fbtud10   LIKE fbt_file.fbtud10,
                    fbtud11   LIKE fbt_file.fbtud11,
                    fbtud12   LIKE fbt_file.fbtud12,
                    fbtud13   LIKE fbt_file.fbtud13,
                    fbtud14   LIKE fbt_file.fbtud14,
                    fbtud15   LIKE fbt_file.fbtud15
                    #FUN-850068 --end--
                    END RECORD,
    g_fbt_t         RECORD
                    fbt02     LIKE fbt_file.fbt02,
                    fbt03     LIKE fbt_file.fbt03,
                    fbt031    LIKE fbt_file.fbt031,
                    faj06     LIKE faj_file.faj06,
                    fbt04     LIKE fbt_file.fbt04,
                    fbt05     LIKE fbt_file.fbt05,
                    fbt06     LIKE fbt_file.fbt06,
                    fbt07     LIKE fbt_file.fbt07,
                    fbt08     LIKE fbt_file.fbt08,
                    fbt09     LIKE fbt_file.fbt09,
                    #FUN-850068 --start---
                    fbtud01   LIKE fbt_file.fbtud01,
                    fbtud02   LIKE fbt_file.fbtud02,
                    fbtud03   LIKE fbt_file.fbtud03,
                    fbtud04   LIKE fbt_file.fbtud04,
                    fbtud05   LIKE fbt_file.fbtud05,
                    fbtud06   LIKE fbt_file.fbtud06,
                    fbtud07   LIKE fbt_file.fbtud07,
                    fbtud08   LIKE fbt_file.fbtud08,
                    fbtud09   LIKE fbt_file.fbtud09,
                    fbtud10   LIKE fbt_file.fbtud10,
                    fbtud11   LIKE fbt_file.fbtud11,
                    fbtud12   LIKE fbt_file.fbtud12,
                    fbtud13   LIKE fbt_file.fbtud13,
                    fbtud14   LIKE fbt_file.fbtud14,
                    fbtud15   LIKE fbt_file.fbtud15
                    #FUN-850068 --end--
                    END RECORD,
    g_fbt_e         DYNAMIC ARRAY of RECORD    #程式變數(Program Variables)
                    fbt11     LIKE fbt_file.fbt11,
                    fbt12     LIKE fbt_file.fbt12,
                    fbt13     LIKE fbt_file.fbt13,
                    fbt14     LIKE fbt_file.fbt14
                    END RECORD,
    g_fah           RECORD LIKE fah_file.*,
    g_fbs01_t       LIKE fbs_file.fbs01,
     g_wc,g_wc2,g_sql   string,  #No.FUN-580092 HCN
    l_modify_flag       LIKE type_file.chr1,    #NO.FUN-690009 VARCHAR(1)
    g_faj28             LIKE faj_file.faj28,    #NO.FUN-690009 VARCHAR(1)
    g_argv1             LIKE fbs_file.fbs01,    #NO.FUN-690009 VARCHAR(16)
    g_argv2             STRING,   #TQC-630069 
    g_faj141            LIKE faj_file.faj141,
    l_flag              LIKE type_file.chr1,    #NO.FUN-690009 VARCHAR(1)
    g_t1                LIKE fah_file.fahslip,  #NO.FUN-690009 VARCHAR(5)     #No.FUN-550034
    g_buf               LIKE type_file.chr50,    #NO.FUN-690009 VARCHAR(30)
    g_rec_b             LIKE type_file.num5,    #NO.FUN-690009 SMALLINT    #單身筆數
    l_ac                LIKE type_file.num5     #NO.FUN-690009 SMALLINT    #目前處理的ARRAY CNT
 
DEFINE p_row,p_col      LIKE type_file.num5     #NO.FUN-690009 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5     #NO.FUN-690009 SMALLINT
DEFINE   g_chr          LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10    #NO.FUN-690009 INTEGER
DEFINE   g_i            LIKE type_file.num5     #NO.FUN-690009 SMALLINT   #count/index for any purpose
DEFINE   g_msg          LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(72)
DEFINE   g_str          STRING     #No.FUN-670060
DEFINE   g_wc_gl        STRING     #No.FUN-670060
DEFINE   g_dbs_gl       LIKE type_file.chr21    #NO.FUN-690009 VARCHAR(21)   #No.FUN-670060
DEFINE   g_row_count    LIKE type_file.num10    #NO.FUN-690009 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #NO.FUN-690009 INTEGER
DEFINE   g_jump         LIKE type_file.num10    #NO.FUN-690009 INTEGER    #查詢指定的筆數
DEFINE   mi_no_ask      LIKE type_file.num5     #NO.FUN-690009 SMALLINT             #是否開啟指定筆視窗
DEFINE   g_flag         LIKE type_file.chr1     #FUN-740026
DEFINE   g_bookno1      LIKE aza_file.aza81     #FUN-740026
DEFINE   g_bookno2      LIKE aza_file.aza82     #FUN-740026
#FUN-AB0088---add---str---
DEFINE   g_fbt2     DYNAMIC ARRAY of RECORD    #祘Α跑计(Program Variables)
                    fbt02     LIKE fbt_file.fbt02,
                    fbt03     LIKE fbt_file.fbt03,
                    fbt031    LIKE fbt_file.fbt031,
                    faj06     LIKE faj_file.faj06,
                    faj18     LIKE faj_file.faj18,
                    fbt042    LIKE fbt_file.fbt042,
                    fbt052    LIKE fbt_file.fbt052,
                    fbt062    LIKE fbt_file.fbt062,
                    fbt072    LIKE fbt_file.fbt072,
                    fbt08     LIKE fbt_file.fbt08,
                    fbt09     LIKE fbt_file.fbt09
                    END RECORD,
    g_fbt2_t        RECORD
                    fbt02     LIKE fbt_file.fbt02,
                    fbt03     LIKE fbt_file.fbt03,
                    fbt031    LIKE fbt_file.fbt031,
                    faj06     LIKE faj_file.faj06,
                    faj18     LIKE faj_file.faj18,
                    fbt042    LIKE fbt_file.fbt042,
                    fbt052    LIKE fbt_file.fbt052,
                    fbt062    LIKE fbt_file.fbt062,
                    fbt072    LIKE fbt_file.fbt072,
                    fbt08     LIKE fbt_file.fbt08,
                    fbt09     LIKE fbt_file.fbt09
                    END RECORD
#FUN-AB0088---add---end---
#CHI-C60010---str---
DEFINE g_azi04_1  LIKE azi_file.azi04,
       g_faj143   LIKE faj_file.faj143
#CHI-C60010---end---
 
MAIN
DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0097
    l_sql         LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(200)
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("GFA")) THEN
       EXIT PROGRAM
    END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
 
    LET g_forupd_sql="SELECT * FROM fbs_file WHERE fbs01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t120_cl CURSOR FROM g_forupd_sql
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)   #TQC-630069
    LET p_row = 3 LET p_col = 3
    OPEN WINDOW t120_w AT p_row,p_col              #顯示畫面
          WITH FORM "gfa/42f/gfat120"  ATTRIBUTE (STYLE = g_win_style CLIPPED)                                            #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    
    #FUN-B60140   ---start   Add
    IF g_faa.faa31 = 'Y' THEN
       CALL cl_set_act_visible("fin_audit2,entry_sheet2",TRUE)
       CALL cl_set_act_visible("gen_entry2,post2,undo_post2",TRUE)
       CALL cl_set_act_visible("carry_voucher2,undo_carry_voucher2",TRUE)
       CALL cl_set_comp_visible("fbs042,fbs052,fbspost1",TRUE)
    ELSE
       CALL cl_set_act_visible("fin_audit2,entry_sheet2",FALSE)
       CALL cl_set_act_visible("gen_entry2,post2,undo_post2",FALSE)
       CALL cl_set_act_visible("carry_voucher2,undo_carry_voucher2",FALSE)
       CALL cl_set_comp_visible("fbs042,fbs052,fbspost1",FALSE)
    END IF
   #FUN-B60140   ---end     Add

      #CHI-C60010--add--str--
       SELECT aaa03 INTO g_faj143 FROM aaa_file
        WHERE aaa01 = g_faa.faa02c
       IF NOT cl_null(g_faj143) THEN
          SELECT azi04 INTO g_azi04_1 FROM azi_file
           WHERE azi01 = g_faj143
       END IF
      #CHI-C60010--add—end---

    #-----TQC-630069---------
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t120_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t120_a()
             END IF
          OTHERWISE   #TQC-660071
             CALL t120_q()   #TQC-660071
       END CASE
    END IF
    #-----END TQC-630069-----
 
 
    #IF NOT cl_null(g_argv1) THEN CALL t120_q() END IF   #TQC-630069
    CALL t120_menu()
    CLOSE WINDOW t120_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
END MAIN
 
FUNCTION t120_cs()
    CLEAR FORM                             #清除畫面
    CALL g_fbt.clear()
    IF cl_null(g_argv1) THEN
       CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_fbs.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
                    fbs01,fbs02,fbs04,fbs05,
                    fbs042,fbs052,                   #FUN-B60140   Add
                    fbsconf,fbspost,fbspost1,fbspost2,fbsuser,fbsgrup,fbsmodu,fbsdate,  #FUN-B60140   Add fbspost1
                    #FUN-850068   ---start---
                    fbsud01,fbsud02,fbsud03,fbsud04,fbsud05,
                    fbsud06,fbsud07,fbsud08,fbsud09,fbsud10,
                    fbsud11,fbsud12,fbsud13,fbsud14,fbsud15
                    #FUN-850068    ----end----
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
           #--No.MOD-4A0248--------
          ON ACTION CONTROLP
            CASE WHEN INFIELD(fbs01) #單據編號
                      CALL cl_init_qry_var()
                      LET g_qryparam.state= "c"
                      LET g_qryparam.form = "q_fbs"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO fbs01
                      NEXT FIELD fbs01
            OTHERWISE EXIT CASE
            END CASE
          #--END---------------
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
		#No.FUN-580031 --end--       HCN
 
 
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
    ELSE
       LET g_wc = " fbs01='",g_argv1,"'"
    END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND fbsuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND fbsgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND fbsgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fbsuser', 'fbsgrup')
    #End:FUN-980030
 
    IF cl_null(g_argv1) THEN
 CONSTRUCT g_wc2 ON fbt02,fbt03,fbt031,fbt04,fbt05,fbt06,fbt07,
                       fbt08,fbt09
                       #No.FUN-850068 --start--
                       ,fbtud01,fbtud02,fbtud03,fbtud04,fbtud05
                       ,fbtud06,fbtud07,fbtud08,fbtud09,fbtud10
                       ,fbtud11,fbtud12,fbtud13,fbtud14,fbtud15
                       #No.FUN-850068 ---end---
            FROM s_fbt[1].fbt02, s_fbt[1].fbt03, s_fbt[1].fbt031,
                 s_fbt[1].fbt04, s_fbt[1].fbt05, s_fbt[1].fbt06,
                 s_fbt[1].fbt07, s_fbt[1].fbt08, s_fbt[1].fbt09
                 #No.FUN-850068 --start--
                 ,s_fbt[1].fbtud01,s_fbt[1].fbtud02,s_fbt[1].fbtud03
                 ,s_fbt[1].fbtud04,s_fbt[1].fbtud05,s_fbt[1].fbtud06
                 ,s_fbt[1].fbtud07,s_fbt[1].fbtud08,s_fbt[1].fbtud09
                 ,s_fbt[1].fbtud10,s_fbt[1].fbtud11,s_fbt[1].fbtud12
                 ,s_fbt[1].fbtud13,s_fbt[1].fbtud14,s_fbt[1].fbtud15
                 #No.FUN-850068 ---end---
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
    ON ACTION controlp
           CASE
              WHEN INFIELD(fbt03)  #財產編號,財產附號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_faj"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO fbt03
                   NEXT FIELD fbt03
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
    #-----TQC-630069---------
    ELSE
       LET g_wc2 = " 1=1"
    #-----END TQC-630069-----
    END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT fbs01 FROM fbs_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE fbs01 ",
                   "  FROM fbs_file, fbt_file",
                   " WHERE fbs01 = fbt01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE t120_prepare FROM g_sql
    DECLARE t120_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t120_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM fbs_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT fbs01) FROM fbs_file,fbt_file",
                  " WHERE fbt01 = fbs01 ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED
    END IF
    PREPARE t120_prcount FROM g_sql
    DECLARE t120_count CURSOR WITH HOLD FOR t120_prcount
END FUNCTION
 
#中文的MENU
FUNCTION t120_menu()
   WHILE TRUE
      CALL t120_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t120_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t120_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t120_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t120_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t120_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL SHOWHELP(1)
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 #         WHEN "bnt01"  #MOD-530223
          WHEN "auto_generate"   #MOD-530223
            IF cl_chk_act_auth() THEN
               CALL t120_g()
               CALL t120_b()
            END IF
         WHEN "gen_entry"
            IF cl_chk_act_auth() AND g_fbs.fbsconf <> 'X' AND g_fah.fahfa1 = 'Y' THEN #MOD-BC0125 add fahfa1
               IF g_fbs.fbsconf = 'N' THEN   #TQC-690113
                  LET g_success='Y'
                  BEGIN WORK
                  #No.FUN-680028 --begin
                  CALL t120_gl(g_fbs.fbs01,g_fbs.fbs02,'0')
                  #FUN-B60140   ---start   Mark
                  #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                  #   CALL t120_gl(g_fbs.fbs01,g_fbs.fbs02,'1')
                  #END IF
                  #FUN-B60140   ---end     Mark
                  #No.FUN-680028 --end
                  IF g_success='Y' THEN
                     COMMIT WORK
                  ELSE
                     ROLLBACK WORK
                  END IF
               #-----TQC-690113---------
               ELSE
                  CALL cl_err(g_fbs.fbs01,'afa-350',0)
               END IF
               #-----END TQC-690113-----
            END IF
       #FUN-B60140   ---start   Add
         WHEN "gen_entry2"
            IF cl_chk_act_auth() AND g_fbs.fbsconf <> 'X' AND g_fah.fahfa2 = 'Y' THEN #MOD-BC0125 add fahfa2
               IF g_fbs.fbsconf = 'N' THEN
                  LET g_success='Y'
                  BEGIN WORK
                  CALL t120_gl(g_fbs.fbs01,g_fbs.fbs02,'1')
                  IF g_success='Y' THEN
                     COMMIT WORK
                  ELSE
                     ROLLBACK WORK
                  END IF
               ELSE
                  CALL cl_err(g_fbs.fbs01,'afa-350',0)
               END IF
            END IF
        #FUN-B60140   ---end     Add   
        WHEN "entry_sheet"
            IF cl_chk_act_auth() AND not cl_null(g_fbs.fbs01) AND g_fah.fahfa1 = 'Y' THEN #MOD-BC0125 add fahfa1
               CALL s_fsgl('FA',13,g_fbs.fbs01,0,g_faa.faa02b,1,g_fbs.fbsconf,'0',g_faa.faa02p)     #No.FUN-680028
               CALL t120_npp02('0')  #No.+087 010503 by plum     #No.FUN-680028
            END IF
         #No.FUN-680028 --begin
         WHEN "entry_sheet2"
            IF cl_chk_act_auth() AND not cl_null(g_fbs.fbs01) AND g_fah.fahfa2 = 'Y' THEN #MOD-BC0125 add fahfa2
               CALL s_fsgl('FA',13,g_fbs.fbs01,0,g_faa.faa02c,1,g_fbs.fbsconf,'1',g_faa.faa02p)     #No.FUN-680028
               CALL t120_npp02('1')  #No.+087 010503 by plum     #No.FUN-680028
            END IF
         #No.FUN-680028 --end
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t120_x() #FUN-D20035 mark
               CALL t120_x(1) #FUN-D20035 add
            END IF
         #FUN-D20035 add
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t120_x(2)
            END IF 
         #FUN-D20035 add    
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t120_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t120_z()
            END IF
         #No.FUN-670060  --Begin
         WHEN "carry_voucher"
            IF cl_chk_act_auth() THEN
#              IF g_fbs.fbsconf = 'Y' THEN  #No.FUN-680028
               IF g_fbs.fbspost = 'Y' THEN  #No.FUN-680028
                  CALL t120_carry_voucher()
               ELSE 
#                 CALL cl_err('','atm-402',1) #No.FUN-680028
                  CALL cl_err('','atm-557',1) #No.FUN-680028
               END IF
            END IF
         WHEN "undo_carry_voucher"
            IF cl_chk_act_auth() THEN
#              IF g_fbs.fbsconf = 'Y' THEN  #No.FUN-680028
               IF g_fbs.fbspost = 'Y' THEN  #No.FUN-680028
                  CALL t120_undo_carry_voucher() 
               ELSE 
#                 CALL cl_err('','atm-403',1) #No.FUN-680028
                  CALL cl_err('','atm-558',1) #No.FUN-680028
               END IF
            END IF
         #No.FUN-670060  --End  
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t120_s()
            END IF
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t120_w()
            END IF
         #FUN-B60140   ---start   Add
         WHEN "carry_voucher2"
            IF cl_chk_act_auth() THEN
               IF g_fbs.fbspost1 = 'Y' THEN
                  CALL t120_carry_voucher2()
               ELSE
                  CALL cl_err('','atm-557',1)
               END IF
            END IF
         WHEN "undo_carry_voucher2"
            IF cl_chk_act_auth() THEN
               IF g_fbs.fbspost1 = 'Y' THEN
                  CALL t120_undo_carry_voucher2()
               ELSE
                  CALL cl_err('','atm-558',1)
               END IF
            END IF
         WHEN "post2"
            IF cl_chk_act_auth() THEN
               CALL t120_s2()
            END IF
         WHEN "undo_post2"
            IF cl_chk_act_auth() THEN
               CALL t120_w2()
            END IF
        #FUN-B60140   ---end     Add
         WHEN "amend_depr_tax"
            IF cl_chk_act_auth() THEN
               CALL t120_k()
            END IF
         WHEN "post_depr_tax"
            IF cl_chk_act_auth() THEN
               CALL t120_6()
            END IF
         WHEN "undo_post_depr_tax"
            IF cl_chk_act_auth() THEN
               CALL t120_7()
            END IF
         #FUN-AB0088---add---str---
         WHEN "fin_audit2"
            IF cl_chk_act_auth() THEN
               CALL t120_fin_audit2()
            END IF  
         #FUN-AB0088---add---end---
         #No.FUN-6A0150-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_fbs.fbs01 IS NOT NULL THEN
                 LET g_doc.column1 = "fbs01"
                 LET g_doc.value1 = g_fbs.fbs01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-6A0150-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t120_a()
DEFINE li_result   LIKE type_file.num5     #NO.FUN-690009 SMALLINT      #No.FUN-550034
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_fbt.clear()
    CALL g_fbt_e.clear()
    INITIALIZE g_fbs.* TO NULL
    LET g_fbs01_t = NULL
    LET g_fbs_o.* = g_fbs.*
    LET g_fbs_t.* = g_fbs.*
 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fbs.fbs02  =g_today
        LET g_fbs.fbsconf='N'
        LET g_fbs.fbspost='N' LET g_fbs.fbspost2='N'
        LET g_fbs.fbspost1='N'     #FUN-B60140   Add
        LET g_fbs.fbsprsw=0
        LET g_fbs.fbsuser=g_user
        LET g_fbs.fbsoriu = g_user #FUN-980030
        LET g_fbs.fbsorig = g_grup #FUN-980030
        LET g_fbs.fbsgrup=g_grup
        LET g_fbs.fbsdate=g_today
        LET g_fbs.fbslegal = g_legal #FUN-980011 add
        #-----TQC-630069---------
        IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
           LET g_fbs.fbs01 = g_argv1
        END IF
        #-----END TQC-630069-----
        CALL t120_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0
           INITIALIZE g_fbs.* TO NULL
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        IF g_fbs.fbs01 IS NULL THEN       #KEY不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK
#No.FUN-550034 --start--
        CALL s_auto_assign_no("afa",g_fbs.fbs01,g_fbs.fbs02,"H","fbs_file","fbs01","","","")
             RETURNING li_result,g_fbs.fbs01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_fbs.fbs01
#       IF g_fbs.fbsauno='Y' THEN
#          CALL s_afaauno(g_fbs.fbs01,g_fbs.fbs02)
#               RETURNING g_i,g_fbs.fbs01
#          IF g_i THEN CONTINUE WHILE END IF	#有問題
#   DISPLAY BY NAME g_fbs.fbs01 # ATTRIBUTE(YELLOW)
#       END IF
#No.FUN-550034 ---end--
        INSERT INTO fbs_file VALUES (g_fbs.*)
 
        IF SQLCA.SQLCODE THEN
           CALL cl_err3("ins","fbs_file",g_fbs.fbs01,"",SQLCA.sqlcode,"","Ins",1) #FUN-B80025 ADD
           ROLLBACK WORK
#          CALL cl_err('Ins:',SQLCA.SQLCODE,1)   #No.FUN-660146
#          CALL cl_err3("ins","fbs_file",g_fbs.fbs01,"",SQLCA.sqlcode,"","Ins",1)  #No.FUN-660146  #FUN-B80025 MARK
           CONTINUE WHILE
        ELSE
           COMMIT WORK
        END IF
        CALL g_fbt.clear()
        LET g_rec_b=0
        LET g_fbs_t.* = g_fbs.*
        LET g_fbs01_t = g_fbs.fbs01
        SELECT fbs01 INTO g_fbs.fbs01
          FROM fbs_file
         WHERE fbs01 = g_fbs.fbs01
 
        CALL t120_g()
        CALL t120_b()
        #---判斷是否直接列印,確認,過帳---------
        LET g_t1 = s_get_doc_no(g_fbs.fbs01)       #No.FUN-550034
        SELECT fahconf,fahpost INTO g_fahconf,g_fahpost
          FROM fah_file
         WHERE fahslip = g_t1
        IF g_fahconf = 'Y' THEN CALL t120_y() END IF
        IF g_fahpost = 'Y' THEN 
           CALL t120_s() 
           CALL t120_s2()    #FUN-B60140   Add
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t120_u()
   IF s_shut(0) THEN RETURN END IF
 
    IF g_fbs.fbs01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fbs.* FROM fbs_file WHERE fbs01 = g_fbs.fbs01
    IF g_fbs.fbsconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
    IF g_fbs.fbsconf = 'Y' THEN CALL cl_err(' ','afa-096',0) RETURN END IF
    IF g_fbs.fbspost = 'Y' THEN CALL cl_err(' ','afa-101',0) RETURN END IF
    #FUN-B60140   ---start   Add
    IF g_faa.faa31 = "Y" THEN
       IF g_fbs.fbspost1= 'Y' THEN
          CALL cl_err(' ','afa-101',0)
          RETURN
       END IF
    END IF
   #FUN-B60140   ---end     Add
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fbs01_t = g_fbs.fbs01
    LET g_fbs_o.* = g_fbs.*
    BEGIN WORK
    OPEN t120_cl USING g_fbs.fbs01
    IF STATUS THEN
       CALL cl_err("OPEN t120_cl:",STATUS,1)
       CLOSE t120_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t120_cl INTO g_fbs.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbs.fbs01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t120_cl ROLLBACK WORK RETURN
    END IF
    CALL t120_show()
    WHILE TRUE
        LET g_fbs01_t = g_fbs.fbs01
        LET g_fbs.fbsmodu=g_user
        LET g_fbs.fbsdate=g_today
        CALL t120_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fbs.*=g_fbs_t.*
            CALL t120_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_fbs.fbs01 != g_fbs_t.fbs01 THEN
           UPDATE fbt_file SET fbt01=g_fbs.fbs01 WHERE fbt01=g_fbs_t.fbs01
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#             CALL cl_err('upd fbt01',SQLCA.SQLCODE,1)   #No.FUN-660146
              CALL cl_err3("upd","fbt_file",g_fbs_t.fbs01,"",SQLCA.sqlcode,"","upd fbt01",1)  #No.FUN-660146
              LET g_fbs.*=g_fbs_t.*
              CALL t120_show()
              CONTINUE WHILE
           END IF
        END IF
        UPDATE fbs_file SET * = g_fbs.*
         WHERE fbs01=g_fbs_t.fbs01
        IF SQLCA.SQLERRD[3] = 0 OR SQLCA.SQLCODE THEN
#          CALL cl_err(g_fbs.fbs01,SQLCA.SQLCODE,0)   #No.FUN-660146
           CALL cl_err3("upd","fbs_file",g_fbs_t.fbs01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660146
           CONTINUE WHILE
        END IF
        IF g_fbs.fbs02 != g_fbs_t.fbs02 THEN            # 更改單號
           UPDATE npp_file SET npp02=g_fbs.fbs02
            WHERE npp01=g_fbs.fbs01 AND npp00=13 AND npp011=1
              AND nppsys = 'FA'
           IF STATUS THEN 
#             CALL cl_err('upd npp02:',STATUS,1)  #No.FUN-660146
              CALL cl_err3("upd","npp_file",g_fbs_t.fbs01,"",STATUS,"","upd npp02",1)  #No.FUN-660146
           END IF
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t120_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t120_npp02(p_npptype)     #No.FUN-680028
  DEFINE p_npptype   LIKE npp_file.npptype     #No.FUN-680028

   IF p_npptype="0" THEN    #FUN-B60140   Add 
      IF g_fbs.fbs04 IS NULL OR g_fbs.fbs04=' ' THEN
         UPDATE npp_file SET npp02=g_fbs.fbs02
          WHERE npp01=g_fbs.fbs01 AND npp00=13 AND npp011=1
            AND nppsys = 'FA'
            AND npptype = p_npptype     #No.FUN-680028
         IF STATUS THEN CALL cl_err('upd npp02:',STATUS,1) END IF
      END IF
  #FUN-B60140   ---start   Add
   ELSE
      IF g_fbs.fbs042 IS NULL OR g_fbs.fbs042=' ' THEN
         UPDATE npp_file SET npp02=g_fbs.fbs02
            WHERE npp01=g_fbs.fbs01 AND npp00=13 AND npp011=1
            AND nppsys = 'FA'
            AND npptype = p_npptype
         IF STATUS THEN CALL cl_err('upd npp02:',STATUS,1) END IF
      END IF
   END IF
 #FUN-B60140   ---end     Add
END FUNCTION
 
#處理INPUT
FUNCTION t120_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1,    #NO.FUN-690009 VARCHAR(1)     #a:輸入 u:更改
         l_flag          LIKE type_file.chr1,    #NO.FUN-690009 VARCHAR(1)     #判斷必要欄位是否有輸入
         l_bdate,l_edate LIKE type_file.dat,     #NO.FUN-690009 DATE
         l_n1            LIKE type_file.num5     #NO.FUN-690009 SMALLINT
  DEFINE li_result       LIKE type_file.num5     #NO.FUN-690009 SMALLINT    #No.FUN-550034
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT BY NAME g_fbs.fbsoriu,g_fbs.fbsorig,
        g_fbs.fbs01,g_fbs.fbs02,g_fbs.fbs04,g_fbs.fbs05,g_fbs.fbs042,g_fbs.fbs052,   #FUN-B60140   Add fbs042 fbs052
        g_fbs.fbsconf,g_fbs.fbspost,g_fbs.fbspost1,g_fbs.fbspost2,                   #FUN-B60140   Add fbspost1
        g_fbs.fbsuser,g_fbs.fbsgrup,g_fbs.fbsmodu,g_fbs.fbsdate,
        #FUN-850068     ---start---
        g_fbs.fbsud01,g_fbs.fbsud02,g_fbs.fbsud03,g_fbs.fbsud04,
        g_fbs.fbsud05,g_fbs.fbsud06,g_fbs.fbsud07,g_fbs.fbsud08,
        g_fbs.fbsud09,g_fbs.fbsud10,g_fbs.fbsud11,g_fbs.fbsud12,
        g_fbs.fbsud13,g_fbs.fbsud14,g_fbs.fbsud15 
        #FUN-850068     ----end----
           WITHOUT DEFAULTS
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t120_set_entry(p_cmd)
          CALL t120_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
#No.FUN-550034 --start--
         CALL cl_set_docno_format("fbs01")
#No.FUN-550034 ---end---
 
        AFTER FIELD fbs01
            IF NOT cl_null(g_fbs.fbs01) AND (g_fbs.fbs01!=g_fbs01_t) THEN
#No.FUN-550034 --start--
    CALL s_check_no("afa",g_fbs.fbs01,g_fbs01_t,"H","fbs_file","fbs01","")
         RETURNING li_result,g_fbs.fbs01
    DISPLAY BY NAME g_fbs.fbs01
       IF (NOT li_result) THEN
          NEXT FIELD fbs01
       END IF
#           LET g_t1=g_fbs.fbs01[1,3]
#  	       CALL s_afaslip(g_t1,'H',g_sys)	    #檢查單別
#     	       IF NOT cl_null(g_errno) THEN	    #抱歉, 有問題
#          CALL cl_err(g_t1,g_errno,0)
#                 LET g_fbs.fbs01 = g_fbs_o.fbs01
#                 NEXT FIELD fbs01
#       END IF
#
               SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
#
#              IF p_cmd = 'a' THEN
#                 IF g_fbs.fbs01[1,3] IS NOT NULL  AND
#                    cl_null(g_fbs.fbs01[5,10]) AND g_fah.fahauno = 'N' THEN
#                    NEXT FIELD fbs01
#                 ELSE
#                    NEXT FIELD fbs02
#                 END IF
#              END IF
#              IF g_fbs.fbs01 != g_fbs_t.fbs01 OR g_fbs_t.fbs01 IS NULL THEN
#                 IF g_fah.fahauno = 'Y' AND
#                    NOT cl_chk_data_continue(g_fbs.fbs01[5,10]) THEN
#                    CALL cl_err('','9056',0)
#                    NEXT FIELD fbs01
#                 END IF
#                 SELECT count(*) INTO g_cnt FROM fbs_file
#                  WHERE fbs01 = g_fbs.fbs01
#                 IF g_cnt > 0 THEN   #資料重複
#                    CALL cl_err(g_fbs.fbs01,-239,0)
#                    LET g_fbs.fbs01 = g_fbs_t.fbs01
#                    DISPLAY BY NAME g_fbs.fbs01 # ATTRIBUTE(YELLOW)
#                    NEXT FIELD fbs01
#                 END IF
#              END IF
#              LET g_fbs_o.fbs01 = g_fbs.fbs01
#
#No.FUN--550034 ---end--
	    END IF
 
        AFTER FIELD fbs02
            IF NOT cl_null(g_fbs.fbs02) THEN
               CALL s_azn01(g_faa.faa07,g_faa.faa08) RETURNING l_bdate,l_edate
               IF g_fbs.fbs02 < l_bdate THEN
                  CALL cl_err(g_fbs.fbs02,'afa-130',0)
                  NEXT FIELD fbs02
               END IF
            END IF
           #start FUN-5B0018
            IF NOT cl_null(g_fbs.fbs02) THEN
               IF g_fbs.fbs02 <= g_faa.faa09 THEN
                  CALL cl_err('','mfg9999',1)
                  NEXT FIELD fbs02
               END IF
            END IF
           #end FUN-5B0018
 
        #FUN-850068     ---start---
        AFTER FIELD fbsud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbsud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbsud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbsud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbsud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbsud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbsud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbsud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbsud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbsud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbsud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbsud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbsud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbsud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbsud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-850068     ----end----
 
        AFTER INPUT
           LET g_fbs.fbsuser = s_get_data_owner("fbs_file") #FUN-C10039
           LET g_fbs.fbsgrup = s_get_data_group("fbs_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(fbs01)    #查詢單據性質
                 LET g_t1 = s_get_doc_no(g_fbs.fbs01)       #No.FUN-550034
                     #CALL q_fah( FALSE, TRUE,g_t1,'H',g_sys)  #TQC-670008
                     CALL q_fah( FALSE, TRUE,g_t1,'H','GFA')   #TQC-670008
                          RETURNING g_t1
#                     CALL FGL_DIALOG_SETBUFFER( g_t1 )
                # LET g_fbs.fbs01[1,3]=g_t1
                 LET g_fbs.fbs01=g_t1
                 DISPLAY BY NAME g_fbs.fbs01
                 NEXT FIELD fbs01
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
 
FUNCTION t120_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fbs01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t120_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fbs01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t120_fbt08(p_cmd)
DEFINE
      p_cmd      LIKE type_file.chr1,    #NO.FUN-690009 VARCHAR(1)
      l_fag03    LIKE fag_file.fag03,
      l_fagacti  LIKE fag_file.fagacti
 
    LET g_errno = ' '
    SELECT fag03,fagacti INTO l_fag03,l_fagacti
      FROM fag_file
     WHERE fag01 = g_fbt[l_ac].fbt08 AND fag02 = 'E'
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-099'
                                LET l_fag03 = NULL
                                LET l_fagacti = NULL
       WHEN l_fagacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t120_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fbs.* TO NULL               #No.FUN-6A0150
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_fbt.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t120_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_fbs.* TO NULL
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t120_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fbs.* TO NULL
    ELSE
        OPEN t120_count
        FETCH t120_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA)
        CALL t120_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t120_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,    #NO.FUN-690009 VARCHAR(1)           #處理方式
    l_fbso          LIKE type_file.num10    #NO.FUN-690009 INTEGER           #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t120_cs INTO g_fbs.fbs01
        WHEN 'P' FETCH PREVIOUS t120_cs INTO g_fbs.fbs01
        WHEN 'F' FETCH FIRST    t120_cs INTO g_fbs.fbs01
        WHEN 'L' FETCH LAST     t120_cs INTO g_fbs.fbs01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
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
            FETCH ABSOLUTE g_jump t120_cs INTO g_fbs.fbs01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbs.fbs01,SQLCA.sqlcode,0)
        INITIALIZE g_fbs.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_fbso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_fbs.* FROM fbs_file WHERE fbs01=g_fbs.fbs01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fbs.fbs01,SQLCA.sqlcode,0)   #No.FUN-660146
        CALL cl_err3("sel","fbs_file",g_fbs.fbs01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660146
        INITIALIZE g_fbs.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_fbs.fbsuser #FUN-4C0058
    LET g_data_group = g_fbs.fbsgrup #FUN-4C0058
    CALL t120_show()
END FUNCTION
 
FUNCTION t120_show()
    LET g_fbs_t.* = g_fbs.*                #保存單頭舊值
    DISPLAY BY NAME g_fbs.fbsoriu,g_fbs.fbsorig,
        g_fbs.fbs01,g_fbs.fbs02,g_fbs.fbs04,g_fbs.fbs05,g_fbs.fbs042,g_fbs.fbs052,   #FUN-B60140   Add fbs042 fbs052
        g_fbs.fbsconf,g_fbs.fbspost,g_fbs.fbspost1,g_fbs.fbspost2,                   #FUN-B60140   Add fbspost1
        g_fbs.fbsuser,g_fbs.fbsgrup,g_fbs.fbsmodu,g_fbs.fbsdate,
        #FUN-850068     ---start---
        g_fbs.fbsud01,g_fbs.fbsud02,g_fbs.fbsud03,g_fbs.fbsud04,
        g_fbs.fbsud05,g_fbs.fbsud06,g_fbs.fbsud07,g_fbs.fbsud08,
        g_fbs.fbsud09,g_fbs.fbsud10,g_fbs.fbsud11,g_fbs.fbsud12,
        g_fbs.fbsud13,g_fbs.fbsud14,g_fbs.fbsud15 
        #FUN-850068     ----end----
    LET g_t1 = s_get_doc_no(g_fbs.fbs01)       #No.FUN-550034
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
    CALL t120_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t120_r()
 DEFINE l_chr,l_sure LIKE type_file.chr1     #NO.FUN-690009] VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fbs.fbs01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fbs.* FROM fbs_file WHERE fbs01 = g_fbs.fbs01
    #-->已拋轉票不可刪除
    IF NOT cl_null(g_fbs.fbs04) THEN CALL cl_err('','afa-311',0) RETURN END IF
    IF g_fbs.fbsconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
    IF g_fbs.fbsconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fbs.fbspost = 'Y' THEN CALL cl_err(' ','afa-101',0) RETURN END IF
    
    #FUN-B60140   ---start   Add
    IF g_faa.faa31="Y" THEN
       IF NOT cl_null(g_fbs.fbs042) THEN
          CALL cl_err('','afa-311',0)
          RETURN
       END IF
       IF g_fbs.fbspost1 = 'Y' THEN
          CALL cl_err(' ','afa-101',0)
          RETURN
       END IF
    END IF
   #FUN-B60140   ---end     Add

    BEGIN WORK
    OPEN t120_cl USING g_fbs.fbs01
    IF STATUS THEN
       CALL cl_err("OPEN t120_cl:", STATUS, 1)
       CLOSE t120_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t120_cl INTO g_fbs.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fbs.fbs01,SQLCA.sqlcode,0)
       CLOSE t120_cl ROLLBACK WORK  RETURN
    END IF
    CALL t120_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fbs01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fbs.fbs01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete fbs,fbt!"
        DELETE FROM fbs_file WHERE fbs01 = g_fbs.fbs01
        IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err(g_fbs.fbs01,SQLCA.sqlcode,0)   #No.FUN-660146
             CALL cl_err3("del","fbs_file",g_fbs.fbs01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660146
        END IF
        DELETE FROM fbt_file WHERE fbt01 = g_fbs.fbs01
        DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 13
                               AND npp01 = g_fbs.fbs01
                               AND npp011= 1
        DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 13
                               AND npq01 = g_fbs.fbs01
                               AND npq011= 1

        #FUN-B40056--add--str--
        DELETE FROM tic_file WHERE tic04 = g_fbs.fbs01
        #FUN-B40056--add--end--

        INITIALIZE g_fbs.* LIKE fbs_file.*
        CLEAR FORM
        CALL g_fbt.clear()
        OPEN t120_count
        #FUN-B50065-add-start--
        IF STATUS THEN
           CLOSE t120_cl
           CLOSE t120_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50065-add-end-- 
        FETCH t120_count INTO g_row_count
        #FUN-B50065-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t120_cl
           CLOSE t120_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50065-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t120_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t120_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t120_fetch('/')
        END IF
    END IF
    CLOSE t120_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t120_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #NO.FUN-690009 SMALLINT      #未取消的ARRAY CNT
    l_row,l_col     LIKE type_file.num5,    #NO.FUN-690009 SMALLINT      #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,    #NO.FUN-690009 SMALLINT      #檢查重複用
    l_lock_sw       LIKE type_file.chr1,    #NO.FUN-690009 VARCHAR(1)       #單身鎖住否
    p_cmd           LIKE type_file.chr1,    #NO.FUN-690009 VARCHAR(1)       #處理狀態
    l_faj06         LIKE faj_file.faj06,
    l_faj100        LIKE faj_file.faj100,
    l_fbt12         LIKE fbt_file.fbt12,    #NO.FUN-690009 DECIMAL(15,0)
    l_fbt07         LIKE fbt_file.fbt07,    #MOD-530223
    l_allow_insert  LIKE type_file.num5,    #NO.FUN-690009 SMALLINT      #可新增否
    l_allow_delete  LIKE type_file.num5     #NO.FUN-690009 SMALLINT      #可刪除否
   DEFINE l_faj332   LIKE faj_file.faj332   #No:FUN-BB0122
   DEFINE l_faj3312  LIKE faj_file.faj3312   #No:FUN-BB0122
   DEFINE l_faj1012  LIKE faj_file.faj1012   #No:FUN-BB0122
 
    LET g_action_choice = ""
     LET l_fbt07 = 0   #MOD-530223
    IF g_fbs.fbs01 IS NULL THEN RETURN END IF
    IF g_fbs.fbsconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fbs.fbspost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
    IF g_fbs.fbsconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF

    #FUN-B60140   ---start   Add
    IF g_faa.faa31 = "Y" THEN
       IF g_fbs.fbspost1 = 'Y' THEN
          CALL cl_err('','afa-101',0)
          RETURN
       END IF
    END IF
   #FUN-B60140   ---end     Add

    CALL cl_opmsg('b')
    LET g_forupd_sql="SELECT fbt02,fbt03,fbt031,'',fbt04,fbt05,fbt06,",
                     "       fbt07,fbt08,fbt09, ",
                     #No.FUN-850068 --start--
                     "       fbtud01,fbtud02,fbtud03,fbtud04,fbtud05,",
                     "       fbtud06,fbtud07,fbtud08,fbtud09,fbtud10,",
                     "       fbtud11,fbtud12,fbtud13,fbtud14,fbtud15 ", 
                     #No.FUN-850068 ---end---
                     "  FROM fbt_file ",
                     " WHERE fbt01 = ? AND fbt02 = ?   ",
                     "   FOR UPDATE      "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t120_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_fbt WITHOUT DEFAULTS FROM s_fbt.*
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
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
	    BEGIN WORK
            OPEN t120_cl USING g_fbs.fbs01
            IF STATUS THEN
               CALL cl_err("OPEN t120_cl:", STATUS, 1)
               CLOSE t120_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t120_cl INTO g_fbs.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fbs.fbs01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t120_cl ROLLBACK WORK RETURN
            END IF
 
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET g_fbt_t.* = g_fbt[l_ac].*  #BACKUP
               LET l_flag = 'Y'
               OPEN t120_bcl USING g_fbs.fbs01,g_fbt_t.fbt02
               IF STATUS THEN
                  CALL cl_err("OPEN t120_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t120_bcl INTO g_fbt[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock fbt',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               SELECT faj06 INTO g_fbt[l_ac].faj06
                 FROM faj_file
                WHERE faj02=g_fbt[l_ac].fbt03
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd = 'a'
         INITIALIZE g_fbt[l_ac].* TO NULL      #900423
            LET g_fbt_t.* = g_fbt[l_ac].*             #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fbt02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            #-----TQC-620120---------
            IF cl_null(g_fbt[l_ac].fbt031) THEN
               LET g_fbt[l_ac].fbt031 = ' '
            END IF
            #-----END TQC-620120-----
            #-----No:FUN-BB0122-----
            SELECT faj332,faj3312,faj1012 
              INTO l_faj332,l_faj3312,l_faj1012
              FROM faj_file
             WHERE faj02  =g_fbt[l_ac].fbt03
               AND faj022 =g_fbt[l_ac].fbt031
            IF cl_null(l_faj332) THEN
               LET l_faj332=0
            END IF
            IF cl_null(l_faj3312) THEN
               LET l_faj3312=0
            END IF
            IF cl_null(l_faj1012) THEN
               LET l_faj1012=0
            END IF
            #-----No:FUN-BB0122 End-----
           #CHI-C60010---str---
            CALL cl_digcut(l_faj3312,g_azi04_1) RETURNING l_faj3312
            CALL cl_digcut(l_faj332,g_azi04_1) RETURNING l_faj332
            CALL cl_digcut(l_faj1012,g_azi04_1) RETURNING l_faj1012
           #CHI-C60010---end---
            INSERT INTO fbt_file(fbt01,fbt02,fbt03,fbt031,fbt04,fbt05,
                                 fbt06,fbt07,fbt08,fbt09,fbt11,fbt12,
                                 fbt13,fbt14,
                                 #FUN-850068 --start--
                                 fbtud01,fbtud02,fbtud03,
                                 fbtud04,fbtud05,fbtud06,
                                 fbtud07,fbtud08,fbtud09,
                                 fbtud10,fbtud11,fbtud12,
                                 fbtud13,fbtud14,fbtud15,
                                 #FUN-850068 --end--
                                 fbt042,fbt052,fbt062,fbt072,   #FUN-AB0088 add
                                 fbtlegal) #FUN-980011 add
                          VALUES(g_fbs.fbs01,g_fbt[l_ac].fbt02,
                                 g_fbt[l_ac].fbt03,g_fbt[l_ac].fbt031,
                                 g_fbt[l_ac].fbt04,g_fbt[l_ac].fbt05,
                                 g_fbt[l_ac].fbt06,g_fbt[l_ac].fbt07,
                                 g_fbt[l_ac].fbt08,g_fbt[l_ac].fbt09,
                                 g_fbt_e[l_ac].fbt11,g_fbt_e[l_ac].fbt12,
                                 g_fbt_e[l_ac].fbt13,g_fbt_e[l_ac].fbt14,
                                 #FUN-850068 --start--
                                 g_fbt[l_ac].fbtud01,g_fbt[l_ac].fbtud02,
                                 g_fbt[l_ac].fbtud03,g_fbt[l_ac].fbtud04,
                                 g_fbt[l_ac].fbtud05,g_fbt[l_ac].fbtud06,
                                 g_fbt[l_ac].fbtud07,g_fbt[l_ac].fbtud08,
                                 g_fbt[l_ac].fbtud09,g_fbt[l_ac].fbtud10,
                                 g_fbt[l_ac].fbtud11,g_fbt[l_ac].fbtud12,
                                 g_fbt[l_ac].fbtud13,g_fbt[l_ac].fbtud14,
                                 g_fbt[l_ac].fbtud15,
                                 #FUN-850068 --end--
                                 #0,0,' ',0, #FUN-AB0088 add #No:FUN-BB0122 mark
                                 l_faj332+l_faj3312,l_faj1012,' ',0, #No:FUN-BB0122 add               
                                 g_legal) #FUN-980011 add
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0  THEN
#              CALL cl_err('ins fbt',SQLCA.sqlcode,0)   #No.FUN-660146
               CALL cl_err3("ins","fbt_file",g_fbs.fbs01,g_fbt[l_ac].fbt02,SQLCA.sqlcode,"","ins fbt",1)  #No.FUN-660146
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE FIELD fbt02                            #defbslt 序號
            IF p_cmd = 'a' OR p_cmd = 'u' THEN
               IF g_fbt[l_ac].fbt02 IS NULL OR g_fbt[l_ac].fbt02 = 0 THEN
                  SELECT MAX(fbt02)+1 INTO g_fbt[l_ac].fbt02
                    FROM fbt_file WHERE fbt01 = g_fbs.fbs01
                  IF g_fbt[l_ac].fbt02 IS NULL THEN
                     LET g_fbt[l_ac].fbt02 = 1
                  END IF
               END IF
            END IF
 
        AFTER FIELD fbt02                        #check 序號是否重複
            IF NOT cl_null(g_fbt[l_ac].fbt02) THEN
               IF g_fbt[l_ac].fbt02 != g_fbt_t.fbt02 OR
                  g_fbt_t.fbt02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM fbt_file
                    WHERE fbt01 = g_fbs.fbs01
                      AND fbt02 = g_fbt[l_ac].fbt02
                  IF l_n > 0 THEN
                     LET g_fbt[l_ac].fbt02 = g_fbt_t.fbt02
                     CALL cl_err('',-239,0)
                     NEXT FIELD fbt02
                  END IF
               END IF
            END IF
 
        #FUN-BC0004--add--str
        AFTER FIELD fbt03
           IF g_fbt[l_ac].fbt031 IS NULL THEN
              LET g_fbt[l_ac].fbt031 = ' '
           END IF
           IF NOT cl_null(g_fbt[l_ac].fbt03) AND g_fbt[l_ac].fbt031 IS NOT NULL THEN
              IF p_cmd = 'a' OR  
                (p_cmd = 'u' AND (g_fbt[l_ac].fbt03  != g_fbt_t.fbt03  OR
                                  g_fbt[l_ac].fbt031 != g_fbt_t.fbt031)) THEN
                  CALL t120_fbt031(p_cmd)
                  SELECT COUNT(*) INTO g_cnt FROM faj_file
                   WHERE faj02  = g_fbt[l_ac].fbt03
                  IF g_cnt > 0 THEN 
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_fbt[l_ac].fbt031,g_errno,0)
                        NEXT FIELD fbt031
                     ELSE
                        #-->同張單據不可相同之財編資料
                        SELECT COUNT(*) INTO g_cnt FROM fbt_file
                         WHERE fbt03  = g_fbt[l_ac].fbt03
                           AND fbt031 = g_fbt[l_ac].fbt031
                           AND fbt01  = g_fbs.fbs01
                        IF g_cnt > 0 THEN
                           CALL cl_err(g_fbt[l_ac].fbt03,'afa-053',1)
                           LET g_fbt[l_ac].fbt03= g_fbt_t.fbt03
                           NEXT FIELD fbt03
                        END IF
                        #-->資產盤點中, 不可異動
                        SELECT COUNT(*) INTO g_cnt FROM fca_file
                         WHERE fca03  = g_fbt[l_ac].fbt03
                           AND fca031 = g_fbt[l_ac].fbt031   
                           AND fca15  = 'N'
                        IF g_cnt > 0 THEN
                           CALL cl_err(g_fbt[l_ac].fbt03,'afa-097',1)
                           LET g_fbt[l_ac].fbt03= g_fbt_t.fbt03
                           NEXT FIELD fbt03
                        END IF
                     END IF
                  ELSE
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_fbt[l_ac].fbt03,g_errno,1)
                        LET g_fbt[l_ac].fbt03= g_fbt_t.fbt03
                        NEXT FIELD fbt03
                     END IF
                  END IF
              END IF
           END IF
           DISPLAY BY NAME g_fbt[l_ac].fbt03
           DISPLAY BY NAME  g_fbt[l_ac].fbt031
        #FUN-BC0004--add--end
        AFTER FIELD fbt031
           IF g_fbt[l_ac].fbt031 IS NULL THEN
              LET g_fbt[l_ac].fbt031 = ' '
           END IF
           IF NOT cl_null(g_fbt[l_ac].fbt03) THEN
              IF p_cmd = 'a' OR
                (p_cmd = 'u' AND (g_fbt[l_ac].fbt03  != g_fbt_t.fbt03  OR
                                  g_fbt[l_ac].fbt031 != g_fbt_t.fbt031)) THEN
                #-->同張單據不可相同之財編資料
                SELECT COUNT(*) INTO g_cnt FROM fbt_file
                 WHERE fbt03  = g_fbt[l_ac].fbt03
                   AND fbt031 = g_fbt[l_ac].fbt031
                   AND fbt01  = g_fbs.fbs01
                 IF g_cnt > 0 THEN
                    CALL cl_err(g_fbt[l_ac].fbt03,'afa-053',1)
                    NEXT FIELD fbt03
                 END IF
                 #-->資產盤點中, 不可異動
                 SELECT COUNT(*) INTO g_cnt FROM fca_file
                  WHERE fca03  = g_fbt[l_ac].fbt03
                    AND fca031 = g_fbt[l_ac].fbt031
                    #AND fca02 != g_fbt[l_ac].fbt02   #MOD-720074
                    AND fca15  = 'N'
                  IF g_cnt > 0 THEN
                     CALL cl_err(g_fbt[l_ac].fbt03,'afa-097',1)
                     NEXT FIELD fbt03
                  END IF
                  CALL t120_fbt031(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_fbt[l_ac].fbt031,g_errno,1)
                     LET g_fbt[l_ac].fbt031 = g_fbt_t.fbt031 #FUN-BC0004 add
                     NEXT FIELD fbt03
                  END IF
              #    LET g_fbt_t.fbt03  = g_fbt[l_ac].fbt03 #FUN-BC0004 mark
              #    LET g_fbt_t.fbt031 = g_fbt[l_ac].fbt031#FUN-BC0004 mark
              END IF
              IF cl_null(g_fbt[l_ac].fbt05) THEN LET g_fbt[l_ac].fbt05 = 0 END IF
           END IF
 
        AFTER FIELD fbt06
            LET g_fbt_e[l_ac].fbt13 = g_fbt[l_ac].fbt06
 
        AFTER FIELD fbt07
            IF cl_null(g_fbt[l_ac].fbt07) THEN LET g_fbt[l_ac].fbt07 = 0 END IF
            IF g_fbt[l_ac].fbt07 != 0 THEN
               #-----MOD-620023---------
               #調增時:不可以大於已提列減值金額
                IF g_fbt[l_ac].fbt06 = '1' THEN
                   IF g_fbt[l_ac].fbt07 > g_fbt[l_ac].fbt05 THEN
                      CALL cl_err('','afa-042',0)
                      NEXT FIELD fbt07
                   END IF
                END IF
               #調減時:不可大於 [未折減餘額 - 已提列減值準備值]
                IF g_fbt[l_ac].fbt06 = '2' THEN
                   IF g_fbt[l_ac].fbt07 >
                      g_fbt[l_ac].fbt04-g_fbt[l_ac].fbt05 THEN
                      CALL cl_err('','afa-051',0)
                      NEXT FIELD fbt07
                   END IF
                END IF
 
#              #調增時, 不可超過未折減餘額
##MOD-530223
#              IF g_fbt[l_ac].fbt06 = '1' THEN
#                 SELECT SUM(fbt07) INTO l_fbt07 FROM fbt_file
#                        WHERE fbt03 = g_fbt[l_ac].fbt03 AND
#                           fbt031 = g_fbt[l_ac].fbt031 AND fbt01 <> g_fbs.fbs01
#                 IF cl_null(l_fbt07) THEN LET l_fbt07 = 0 END IF
#              END IF
##END MOD-530223
#              IF g_fbt[l_ac].fbt06 = '1' AND
#                  #g_fbt[l_ac].fbt07 > g_fbt[l_ac].fbt04 THEN   #MOD-530223
#                  g_fbt[l_ac].fbt07 > g_fbt[l_ac].fbt04 - l_fbt07 THEN   #MOD-530223
#                  #CALL cl_err(g_fbt[l_ac].fbt04,'afa-042',0) NEXT FIELD fbt07   #MOD-530223
#                  CALL cl_err(g_fbt[l_ac].fbt04 - l_fbt07,'afa-042',0) NEXT FIELD fbt07   #MOD-530223
#              END IF
#              #調減時, 不可超過已提列減值準備金額
#              IF g_fbt[l_ac].fbt06 = '2' AND
#                 g_fbt[l_ac].fbt07 > g_fbt[l_ac].fbt05 THEN
#                 CALL cl_err(g_fbt[l_ac].fbt07,'afa-051',0) NEXT FIELD fbt07
#              END IF
               #-----END MOD-620023-----
               LET g_fbt_e[l_ac].fbt14 = g_fbt[l_ac].fbt07
            END IF
 
        AFTER FIELD fbt08
            IF NOT cl_null(g_fbt[l_ac].fbt08) THEN
               CALL t120_fbt08('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_fbt[l_ac].fbt08 = g_fbt_t.fbt08
                  CALL cl_err(g_fbt[l_ac].fbt08,g_errno,0)
                  NEXT FIELD fbt08
               END IF
            END IF
 
        #No.FUN-850068 --start--
        AFTER FIELD fbtud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbtud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbtud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbtud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbtud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbtud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbtud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbtud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbtud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbtud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbtud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbtud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbtud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbtud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbtud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-850068 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_fbt_t.fbt02 > 0 AND g_fbt_t.fbt02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM fbt_file
                 WHERE fbt01 = g_fbs.fbs01
                   AND fbt02 = g_fbt_t.fbt02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_fbt_t.fbt02,SQLCA.sqlcode,0)   #No.FUN-660146
                   CALL cl_err3("del","fbt_file",g_fbs.fbs01,g_fbt_t.fbt02,SQLCA.sqlcode,"","",1)  #No.FUN-660146
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete Ok"
                CLOSE t120_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fbt[l_ac].* = g_fbt_t.*
               CLOSE t120_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fbt[l_ac].fbt02,-263,1)
               LET g_fbt[l_ac].* = g_fbt_t.*
            ELSE
               UPDATE fbt_file SET fbt02 = g_fbt[l_ac].fbt02,
                                   fbt03 = g_fbt[l_ac].fbt03,
                                   fbt031= g_fbt[l_ac].fbt031,
                                   fbt04 = g_fbt[l_ac].fbt04,
                                   fbt05 = g_fbt[l_ac].fbt05,
                                   fbt06 = g_fbt[l_ac].fbt06,
                                   fbt07 = g_fbt[l_ac].fbt07,
                                   fbt08 = g_fbt[l_ac].fbt08,
                                   fbt09 = g_fbt[l_ac].fbt09,
                                   fbt11 = g_fbt_e[l_ac].fbt11,
                                   fbt12 = g_fbt_e[l_ac].fbt12,
                                   fbt13 = g_fbt_e[l_ac].fbt13,
                                   fbt14 = g_fbt_e[l_ac].fbt14,
                                   #FUN-850068 --start--
                                   fbtud01 = g_fbt[l_ac].fbtud01,
                                   fbtud02 = g_fbt[l_ac].fbtud02,
                                   fbtud03 = g_fbt[l_ac].fbtud03,
                                   fbtud04 = g_fbt[l_ac].fbtud04,
                                   fbtud05 = g_fbt[l_ac].fbtud05,
                                   fbtud06 = g_fbt[l_ac].fbtud06,
                                   fbtud07 = g_fbt[l_ac].fbtud07,
                                   fbtud08 = g_fbt[l_ac].fbtud08,
                                   fbtud09 = g_fbt[l_ac].fbtud09,
                                   fbtud10 = g_fbt[l_ac].fbtud10,
                                   fbtud11 = g_fbt[l_ac].fbtud11,
                                   fbtud12 = g_fbt[l_ac].fbtud12,
                                   fbtud13 = g_fbt[l_ac].fbtud13,
                                   fbtud14 = g_fbt[l_ac].fbtud14,
                                   fbtud15 = g_fbt[l_ac].fbtud15
                                   #FUN-850068 --end-- 
                WHERE fbt01=g_fbs.fbs01 AND fbt02=g_fbt_t.fbt02
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#                 CALL cl_err(g_fbt[l_ac].fbt02,SQLCA.sqlcode,0)   #No.FUN-660146
                  CALL cl_err3("upd","fbt_file",g_fbs.fbs01,g_fbs_t.fbs02,SQLCA.sqlcode,"","",1)  #No.FUN-660146
                  LET g_fbt[l_ac].* = g_fbt_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac                #FUN-D30032 Mark
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_fbt[l_ac].* = g_fbt_t.*
               #FUN-D30032--add--str--
               ELSE
                  CALL g_fbt.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end--  
               END IF
               CLOSE t120_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac                #FUN-D30032 Add
            CLOSE t120_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fbt02) AND l_ac > 1 THEN
                LET g_fbt[l_ac].* = g_fbt[l_ac-1].*
                LET g_fbt[l_ac].fbt02 = g_rec_b + 1
                NEXT FIELD fbt02
            END IF
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLP
            CASE WHEN INFIELD(fbt03)  #財產編號,財產附號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_faj"
                   LET g_qryparam.default1 = g_fbt[l_ac].fbt03
                   LET g_qryparam.default2 = g_fbt[l_ac].fbt031
                   CALL cl_create_qry()
                        RETURNING g_fbt[l_ac].fbt03,g_fbt[l_ac].fbt031
#                   CALL FGL_DIALOG_SETBUFFER( g_fbt[l_ac].fbt03)
#                   CALL FGL_DIALOG_SETBUFFER( g_fbt[l_ac].fbt031)
                   NEXT FIELD fbt03
              WHEN INFIELD(fbt08)  #異動原因
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_fag"
                   LET g_qryparam.arg1 = "E"
                   LET g_qryparam.default1 = g_fbt[l_ac].fbt08
                   CALL cl_create_qry() RETURNING g_fbt[l_ac].fbt08
#                   CALL FGL_DIALOG_SETBUFFER( g_fbt[l_ac].fbt08 )
                   NEXT FIELD fbt08
              OTHERWISE
                 EXIT CASE
            END CASE
 
        ON ACTION mntn_depr_tax   #維護稅簽資料
            CALL t120_e(p_cmd)
 
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
 
 
      END INPUT
 
   #FUN-5B0116-begin
    LET g_fbs.fbsmodu = g_user
    LET g_fbs.fbsdate = g_today
    UPDATE fbs_file SET fbsmodu = g_fbs.fbsmodu,fbsdate = g_fbs.fbsdate
     WHERE fbs01 = g_fbs.fbs01
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#      CALL cl_err('upd fbs',SQLCA.SQLCODE,1)   #No.FUN-660146
       CALL cl_err3("upd","fbs_file",g_fbs.fbs01,"",SQLCA.sqlcode,"","upd fbs",1)  #No.FUN-660146
    END IF
    DISPLAY BY NAME g_fbs.fbsmodu,g_fbs.fbsdate
   #FUN-5B0116-end
 
      CLOSE t120_bcl
      COMMIT WORK
#     CALL t120_delall()     # No.TQC-740305 #CHI-C30002 mark
      CALL t120_delHeader()     #CHI-C30002 add
END FUNCTION
 
FUNCTION t120_fbt031(p_cmd)
DEFINE   p_cmd       LIKE type_file.chr1,    #NO.FUN-690009 VARCHAR(1)
         l_faj06     LIKE faj_file.faj06,
         l_faj33     LIKE faj_file.faj33,
         l_faj331    LIKE faj_file.faj331,   #MOD-970231 add
         l_faj43     LIKE faj_file.faj43,
         l_faj68     LIKE faj_file.faj68,
         l_fajconf   LIKE faj_file.fajconf,
         l_faj100    LIKE faj_file.faj100,
         l_faj101    LIKE faj_file.faj101,
         l_faj103    LIKE faj_file.faj103
 
     LET g_errno = ' '
     SELECT faj06,faj33,faj331,faj43,faj68,faj100,faj101,faj103,fajconf   #MOD-970231 add faj331
       INTO l_faj06,l_faj33,l_faj331,l_faj43,l_faj68,l_faj100,l_faj101,   #MOD-970231 add l_faj331
            l_faj103,l_fajconf
       FROM faj_file
      WHERE faj02  = g_fbt[l_ac].fbt03
        AND faj022 = g_fbt[l_ac].fbt031
     CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-093'
         WHEN l_faj100 > g_fbs.fbs02     LET g_errno = 'afa-113'
         WHEN l_fajconf  = 'N'           LET g_errno = 'afa-312'
         WHEN l_faj43  matches '[056X]'  LET g_errno = 'afa-313'
         OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     IF p_cmd = 'a' THEN
        LET g_fbt[l_ac].faj06 = l_faj06     #中文名稱
       #LET g_fbt[l_ac].fbt04 = l_faj33           #未折減額   #MOD-970231 mark
        LET g_fbt[l_ac].fbt04 = l_faj33+l_faj331  #未折減額   #MOD-970231
        LET g_fbt[l_ac].fbt05 = l_faj101    #已提列減值準備金額
        LET g_fbt_e[l_ac].fbt11 = l_faj68     #(稅簽)未折減額
        LET g_fbt_e[l_ac].fbt12 = l_faj103    #(稅簽)已提列減值準備金額
     END IF
END FUNCTION
 
FUNCTION t120_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(200)
 
 CONSTRUCT l_wc2 ON fbt02,fbt03,fbt031,fbt04,fbt05,fbt06,fbt07,
                       fbt08,fbt09
                       #No.FUN-850068 --start--
                       ,fbtud01,fbtud02,fbtud03,fbtud04,fbtud05
                       ,fbtud06,fbtud07,fbtud08,fbtud09,fbtud10
                       ,fbtud11,fbtud12,fbtud13,fbtud14,fbtud15
                       #No.FUN-850068 ---end---
         FROM s_fbt[1].fbt02,s_fbt[1].fbt03,s_fbt[1].fbt031,s_fbt[1].fbt04,
              s_fbt[1].fbt05,s_fbt[1].fbt06,s_fbt[1].fbt07,s_fbt[1].fbt08,
              s_fbt[1].fbt09
              #No.FUN-850068 --start--
              ,s_fbt[1].fbtud01,s_fbt[1].fbtud02,s_fbt[1].fbtud03
              ,s_fbt[1].fbtud04,s_fbt[1].fbtud05,s_fbt[1].fbtud06
              ,s_fbt[1].fbtud07,s_fbt[1].fbtud08,s_fbt[1].fbtud09
              ,s_fbt[1].fbtud10,s_fbt[1].fbtud11,s_fbt[1].fbtud12
              ,s_fbt[1].fbtud13,s_fbt[1].fbtud14,s_fbt[1].fbtud15
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
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    CALL t120_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t120_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(200)
 
    LET g_sql =
        "SELECT fbt02,fbt03,fbt031,faj06,fbt04,fbt05,fbt06,fbt07,fbt08,fbt09,",
        #No.FUN-850068 --start--
        "       fbtud01,fbtud02,fbtud03,fbtud04,fbtud05,",
        "       fbtud06,fbtud07,fbtud08,fbtud09,fbtud10,",
        "       fbtud11,fbtud12,fbtud13,fbtud14,fbtud15 ", 
        #No.FUN-850068 ---end---
        "  FROM fbt_file LEFT OUTER JOIN faj_file ON fbt_file.fbt03=faj_file.faj02 AND fbt_file.fbt031=faj_file.faj022",
        " WHERE fbt01  ='",g_fbs.fbs01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE t120_pb FROM g_sql
    DECLARE fbt_curs                       #SCROLL CURSOR
        CURSOR FOR t120_pb
 
    CALL g_fbt.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fbt_curs INTO g_fbt[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_fbt.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t120_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(1)
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fbt TO s_fbt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         #No.FUN-680028 --begin
         #IF g_aza.aza63 = 'Y' THEN   #FUN-B60140   Mark
          IF g_faa.faa31 = 'Y' THEN   #FUN-B60140   Add
            # CALL cl_set_act_visible("entry_sheet2",TRUE)   #FUN-B60140   Mark
          #FUN-B60140   ---start   Add
            CALL cl_set_act_visible("fin_audit2,entry_sheet2",TRUE)
            CALL cl_set_act_visible("gen_entry2,post2,undo_post2",TRUE)
            CALL cl_set_act_visible("carry_voucher2,undo_carry_voucher2",TRUE)
        #FUN-B60140   ---end     Add
         ELSE
          # CALL cl_set_act_visible("entry_sheet2",FALSE)  #FUN-B60140   Mark
           #FUN-B60140   ---start   Add
            CALL cl_set_act_visible("fin_audit2,entry_sheet2",FALSE)
            CALL cl_set_act_visible("gen_entry2,post2,undo_post2",FALSE)
            CALL cl_set_act_visible("carry_voucher2,undo_carry_voucher2",FALSE)
        #FUN-B60140   ---end     Add
         END IF
         #No.FUN-680028 --end
 
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
         CALL t120_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION previous
         CALL t120_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION jump
         CALL t120_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION next
         CALL t120_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION last
         CALL t120_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
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
      #@ON ACTION 會計分錄產生
      ON ACTION gen_entry
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
      #FUN-B60140   ---start   Add
      #@ON ACTION 會計分錄產生
      ON ACTION gen_entry2
         LET g_action_choice="gen_entry2"
         EXIT DISPLAY
     #FUN-B60140   ---end     Add
      #@ON ACTION 分錄底稿
      ON ACTION entry_sheet
         LET g_action_choice="entry_sheet"
         EXIT DISPLAY
      #No.FUN-680028 --begin
      #@ON ACTION 分錄底稿2
      ON ACTION entry_sheet2
         LET g_action_choice="entry_sheet2"
         EXIT DISPLAY
      #No.FUN-680028 --end
      #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #FUN-D20035 add   
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY  
      #FUN-D20035 add   
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #No.FUN-670060  --Begin
      ON ACTION carry_voucher
         LET g_action_choice="carry_voucher"
         EXIT DISPLAY
      ON ACTION undo_carry_voucher
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY
      #No.FUN-670060  --End  
      #@ON ACTION 過帳
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
      #@ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
      #FUN-B60140   ---start   Add
      ON ACTION carry_voucher2
         LET g_action_choice="carry_voucher2"
         EXIT DISPLAY
      ON ACTION undo_carry_voucher2
         LET g_action_choice="undo_carry_voucher2"
         EXIT DISPLAY
      #@ON ACTION 過帳2
      ON ACTION post2
         LET g_action_choice="post2"
         EXIT DISPLAY
      #@ON ACTION 過帳還原2
      ON ACTION undo_post2
         LET g_action_choice="undo_post2"
         EXIT DISPLAY
     #FUN-B60140   ---end     Add
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
       
      #FUN-AB0088---add---str---
      ON ACTION fin_audit2   #財簽二
         LET g_action_choice="fin_audit2"
         EXIT DISPLAY 
      #FUN-AB0088---add---end---
 
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
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION related_document                #No.FUN-6A0150  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      #FUN-810046
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t120_g()
 DEFINE  l_wc        LIKE type_file.chr1000, #NO.FUN-690009 VARCHAR(300)
         l_sql       LIKE type_file.chr1000, #NO.FUN-690009 VARCHAR(600)
         l_faj       RECORD
                     faj02     LIKE faj_file.faj02,
                     faj022    LIKE faj_file.faj022,
                     faj06     LIKE faj_file.faj06,
                     faj33     LIKE faj_file.faj33,
                     faj331    LIKE faj_file.faj331,   #MOD-970231 add
                     faj68     LIKE faj_file.faj68,
                     faj101    LIKE faj_file.faj101,
                     faj103    LIKE faj_file.faj103
                    ,faj332    LIKE faj_file.faj332,  #FUN-B60140   Add
                     faj3312   LIKE faj_file.faj3312, #FUN-B60140   Add
                     faj1012   LIKE faj_file.faj1012  #FUN-B60140   Add
                     END RECORD,
         ans         LIKE type_file.chr1,    #NO.FUN-690009 VARCHAR(1)
         l_i         LIKE type_file.num5     #NO.FUN-690009 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbs.fbs01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fbs.fbsconf='Y' THEN CALL cl_err(g_fbs.fbs01,'afa-107',0) RETURN END IF
   IF g_fbs.fbsconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   LET INT_FLAG = 0
#   CALL cl_getmsg('afa-103',g_lang) RETURNING g_msg
#   PROMPT g_msg CLIPPED ,': ' FOR ans
#   DISPLAY "ans=",ans
#     ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE PROMPT
 
 #     ON ACTION about         #MOD-4C0121
 #        CALL cl_about()      #MOD-4C0121
 
 #     ON ACTION help          #MOD-4C0121
 #        CALL cl_show_help()  #MOD-4C0121
 
 #     ON ACTION controlg      #MOD-4C0121
 #        CALL cl_cmdask()     #MOD-4C0121
 
 
#   END PROMPT
   #---------詢問是否自動新增單身--------------
#   IF ans MATCHES '[Yy]' THEN
      LET p_row = 12 LET p_col = 24
      OPEN WINDOW t120_w2 AT p_row,p_col WITH FORM "afa/42f/afat106g"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)                                            #No.FUN-580092 HCN
 
      CALL cl_ui_locale("afat106g")
      CONSTRUCT BY NAME l_wc ON faj01,faj02,faj022,faj53
 
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
      IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t120_w2 RETURN END IF
 
      BEGIN WORK
      OPEN t120_cl USING g_fbs.fbs01
 #MOD-530223
      IF STATUS THEN
         CALL cl_err("OPEN t120_cl:", STATUS, 1)
         CLOSE t120_cl
         ROLLBACK WORK
         RETURN
      END IF
 #END MOD-530223
      FETCH t120_cl INTO g_fbs.*          # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_fbs.fbs01,SQLCA.sqlcode,0)     # 資料被他人LOCK
         CLOSE t120_cl ROLLBACK WORK RETURN
      END IF
      LET g_success = 'Y'   #MOD-530223
      LET l_sql ="SELECT faj02,faj022,faj06,faj33,faj331,faj68,",   #MOD-970231 add faj331
                 "       (faj101-faj102),(faj103-faj104), ",
                 "       faj332,faj3312,(faj1012-faj1022) ",        #FUN-B60140   Add
                 "  FROM faj_file ",
                 " WHERE faj43 NOT MATCHES '[056X]' AND fajconf = 'Y' AND ",
                 l_wc CLIPPED,
                 " ORDER BY 1"
     PREPARE t120_prepare_g FROM l_sql
     IF SQLCA.SQLCODE != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0)
        CLOSE t120_cl ROLLBACK WORK RETURN
     END IF
     DECLARE t120_curs2 CURSOR FOR t120_prepare_g
 
     SELECT MAX(fbt02)+1 INTO l_i FROM fbt_file
      WHERE fbt01 = g_fbs.fbs01
      #IF SQLCA.sqlcode THEN LET l_i = 1 END IF   #MOD-530223
      IF STATUS THEN 
#      CALL  cl_err(' ',STATUS,0)  #No.FUN-660146
        CALL cl_err3("sel","fbt_file",g_fbs.fbs01,"",STATUS,"","",1) #No.FUN-660146
       END IF   #MOD-530223
     IF cl_null(l_i) THEN LET l_i = 1 END IF
      MESSAGE "WAIT !!"   #MOD-530223
      INITIALIZE l_faj.* TO NULL   #MOD-530223
     FOREACH t120_curs2 INTO l_faj.*
 
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,0)
           LET g_success='N'   #MOD-530223
          EXIT FOREACH
       END IF
       #檢查資產盤點期間應不可做異動
       SELECT COUNT(*) INTO g_cnt FROM fca_file
        WHERE fca03  = l_faj.faj02
          AND fca031 = l_faj.faj022
          AND fca15  = 'N'
           IF g_cnt > 0 THEN
              CONTINUE FOREACH
           END IF
       MESSAGE l_faj.faj02,' ',l_faj.faj022
       IF cl_null(l_faj.faj101) THEN LET l_faj.faj101 = 0 END IF
       IF cl_null(l_faj.faj1012) THEN LET l_faj.faj1012 = 0 END IF     #FUN-B60140   Add
       IF cl_null(l_faj.faj103) THEN LET l_faj.faj103 = 0 END IF
       #-----TQC-620120---------
       IF cl_null(l_faj.faj022) THEN
          LET l_faj.faj022 = ' '
       END IF
       #-----END TQC-620120-----
      #CHI-C60010---str---
       CALL cl_digcut(l_faj.faj3312,g_azi04_1) RETURNING l_faj.faj3312
       CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
       CALL cl_digcut(l_faj.faj1012,g_azi04_1) RETURNING l_faj.faj1012
      #CHI-C60010---end---
       INSERT INTO fbt_file(fbt01,fbt02,fbt03,fbt031,fbt04,
                            fbt05,fbt06,fbt07,fbt08,fbt09,fbt10,
                            fbt11,fbt12,fbt13,fbt14,
                            fbt042,fbt052,fbt062,fbt072,    #FUN-AB0088
                            fbtlegal)  #FUN-980011 add
       VALUES(g_fbs.fbs01,l_i,l_faj.faj02,l_faj.faj022,
      #       l_faj.faj33,l_faj.faj101,'1',0,'','','',               #MOD-970231 mark
              l_faj.faj33+l_faj.faj331,l_faj.faj101,'1',0,'','','',  #MOD-970231
              l_faj.faj68,l_faj.faj103,'1',0,
      #       0,0,'',0,  #FUN-AB0088     #MOD-B60165 mark 
            # 0,0,' ',0,                 #MOD-B60165 add  #FUN-B60140   Mark
              l_faj.faj332+l_faj.faj3312,l_faj.faj1012,'1',0,        #FUN-B60140   Add   
           g_legal)   #FUN-980011 add
       IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#         CALL cl_err('ins fbt',STATUS,1)   #No.FUN-660146
          CALL cl_err3("ins","fbt_file",g_fbs.fbs01,l_i,STATUS,"","ins fbt",1)  #No.FUN-660146
           LET g_success='N'   #MOD-530223
          EXIT FOREACH
       END IF
       LET l_i = l_i + 1
     END FOREACH
 #MOD-530223
     IF l_faj.faj02 IS NULL THEN
        CALL cl_err('','afa-313',1)
     END IF
 #END MOD-530223
     CLOSE t120_cl
 #     COMMIT WORK     #MOD-530223
     CLOSE WINDOW t120_w2
     IF g_success='Y' THEN
        COMMIT WORK
     ELSE
        ROLLBACK WORK
     END IF
     CALL t120_b_fill(l_wc)
#  END IF
END FUNCTION
 
FUNCTION t120_y() 	
DEFINE l_cnt LIKE type_file.num5     #NO.FUN-690009 SMALLINT
DEFINE l_n   LIKE type_file.num10    #NO.FUN-690009 INTEGER     #No.FUN-670060
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbs.fbs01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#CHI-C30107 -------------- add ------------- begin
   IF g_fbs.fbsconf='Y' THEN RETURN END IF
   IF g_fbs.fbspost='Y' THEN CALL cl_err('fbspost=Y:','afa-101',0) RETURN END IF
   IF g_fbs.fbsconf='X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_faa.faa31 = "Y" THEN
      IF g_fbs.fbspost1='Y' THEN
         CALL cl_err('fbspost1=Y:','afa-101',0)
         RETURN
      END IF
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 -------------- add ------------- end
   SELECT * INTO g_fbs.* FROM fbs_file WHERE fbs01 = g_fbs.fbs01
   IF g_fbs.fbsconf='Y' THEN RETURN END IF
   IF g_fbs.fbspost='Y' THEN CALL cl_err('fbspost=Y:','afa-101',0) RETURN END IF
   IF g_fbs.fbsconf='X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   #FUN-B60140   ---start   Add
   IF g_faa.faa31 = "Y" THEN
      IF g_fbs.fbspost1='Y' THEN
         CALL cl_err('fbspost1=Y:','afa-101',0)
         RETURN
      END IF
   END IF
  #FUN-B60140   ---end     Add
   SELECT COUNT(*) INTO l_cnt FROM fbt_file
    WHERE fbt01= g_fbs.fbs01
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0) RETURN
   END IF
   #FUN-B60140   ---start   Add
   IF g_faa.faa31= "Y" THEN
      #-->立帳日期小於關帳日期
      IF g_fbs.fbs02 < g_faa.faa092 THEN
         CALL cl_err(g_fbs.fbs01,'aap-176',1) RETURN
      END IF
   END IF
  #FUN-B60140   ---end     Add
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期小於關帳日期
   IF g_fbs.fbs02 < g_faa.faa09 THEN
      CALL cl_err(g_fbs.fbs01,'aap-176',1) RETURN
   END IF
#FUN-740026.....begin
   CALL s_get_bookno(YEAR(g_fbs.fbs02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN 
      CALL cl_err(g_fbs.fbs02,'aoo-081',1)
      LET g_success = 'N'
      RETURN
   END IF
#FUN-740026.....end  
   #----------------------------------- 檢查分錄底稿平衡正確否
#FUN-C30313---mark---START
#  IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'N' THEN  #No.FUN-670060
#     #No.FUN-680028 --begin
#     IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125 
#        CALL s_chknpq(g_fbs.fbs01,'FA',1,'0',g_bookno1)  #No.FUN-740026
#     END IF #MOD-BC0125
#    # IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN       #FUN-B60140   Mark
#      IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN #FUN-B60140 Add #MOD-BC0125
#         CALL s_chknpq(g_fbs.fbs01,'FA',1,'1',g_bookno2)  #No.FUN-740026
#     END IF
#     #No.FUN-680028 --end
#  END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'N' THEN  #No.FUN-670060
      IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125
         CALL s_chknpq(g_fbs.fbs01,'FA',1,'0',g_bookno1)  #No.FUN-740026
      END IF #MOD-BC0125
   END IF
   IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN #FUN-B60140 Add #MOD-BC0125
      IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'N' THEN
         CALL s_chknpq(g_fbs.fbs01,'FA',1,'1',g_bookno2)  #No.FUN-740026
      END IF
   END IF
#FUN-C30313---add---END-------
   IF g_success = 'N' THEN RETURN END IF
    #IF NOT cl_conf(18,10,'axm-108') THEN RETURN END IF   #MOD-530223
#   IF NOT cl_confirm('axm-108') THEN RETURN END IF   #MOD-530223 #CHI-C30107 mark
   BEGIN WORK
   OPEN t120_cl USING g_fbs.fbs01
    IF STATUS THEN
       CALL cl_err("OPEN t120_cl:", STATUS, 1)
       CLOSE t120_cl
       ROLLBACK WORK
       RETURN
    END IF
   FETCH t120_cl INTO g_fbs.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fbs.fbs01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t120_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
#FUN-C30313---mark---START
#  #No.FUN-670060  --Begin
#  IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
#     SELECT count(*) INTO l_n FROM npq_file
#      WHERE npq01 = g_fbs.fbs01
#        AND npq011 = 1
#        AND npqsys = 'FA'
#        AND npq00 = 13
#     IF l_n = 0 THEN
#        CALL t120_gen_glcr(g_fbs.*,g_fah.*)
#     END IF
#     IF g_success = 'Y' THEN 
#        #No.FUN-680028 --begin
#        IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125 
#           CALL s_chknpq(g_fbs.fbs01,'FA',1,'0',g_bookno1)   #No.FUN-740026
#        END IF #MOD-BC0125
#       #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN   #FUN-B60140   Mark
#        IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN   #FUN-B60140 Add #MOD-BC0125
#           CALL s_chknpq(g_fbs.fbs01,'FA',1,'1',g_bookno2)    #No.FUN-740026
#        END IF
#        #No.FUN-680028 --end
#     END IF
#     IF g_success = 'N' THEN RETURN END IF #No.FUN-680028
#  END IF
#  #No.FUN-670060  --End  
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
      SELECT count(*) INTO l_n FROM npq_file
       WHERE npq01 = g_fbs.fbs01
         AND npq011 = 1
         AND npqsys = 'FA'
         AND npq00 = 13
      IF l_n = 0 THEN
         CALL t120_gen_glcr(g_fbs.*,g_fah.*)
      END IF
      IF g_success = 'Y' THEN
         IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
            IF g_fah.fahfa1 = 'Y' THEN #MOD-BC0125
               CALL s_chknpq(g_fbs.fbs01,'FA',1,'0',g_bookno1)   #No.FUN-740026
            END IF #MOD-BC0125
         END IF
         IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN   #FUN-B60140 Add #MOD-BC0125
            IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN
               CALL s_chknpq(g_fbs.fbs01,'FA',1,'1',g_bookno2)    #No.FUN-740026
            END IF
         END IF
      END IF
      IF g_success = 'N' THEN RETURN END IF #No.FUN-680028
#FUN-C30313---add---END-------
   UPDATE fbs_file SET fbsconf = 'Y' WHERE fbs01 = g_fbs.fbs01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd fbsconf',STATUS,1)   #No.FUN-660146
      CALL cl_err3("upd","fbs_file",g_fbs.fbs01,"",STATUS,"","upd fbsconf",1)  #No.FUN-660146
      LET g_success = 'N'
   END IF
  
   #FUN-B60140   ---start   Add
   IF g_faa.faa31 = "Y" THEN
      LET g_t1 = s_get_doc_no(g_fbs.fbs01)
      SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
      IF g_fah.fahfa1 = "N" THEN
         UPDATE fbs_file SET fbspost = 'X',fbspost2='X' WHERE fbs01 = g_fbs.fbs01
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('fbs01',g_fbs.fbs01,'upd fbspost',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
      IF g_fah.fahfa2 = "N" THEN
         UPDATE fbs_file SET fbspost1= 'X' WHERE fbs01 = g_fbs.fbs01
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('fbs01',g_fbs.fbs01,'upd fbspost1',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
      SELECT fbspost,fbspost1,fbspost2
        INTO g_fbs.fbspost,g_fbs.fbspost1,g_fbs.fbspost2
        FROM fbs_file
       WHERE fbs01 = g_fbs.fbs01
      DISPLAY BY NAME g_fbs.fbspost,g_fbs.fbspost1,g_fbs.fbspost2
   END IF
  #FUN-B60140   ---end     Add

   CLOSE t120_cl
   IF g_success = 'Y' THEN
      LET g_fbs.fbsconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_fbs.fbs01,'Y')
      DISPLAY BY NAME g_fbs.fbsconf ATTRIBUTE(REVERSE)
   ELSE
      LET g_fbs.fbsconf='N'
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t120_z() 	
    DEFINE l_fbt03    LIKE fbt_file.fbt03    #MOD-530223
    DEFINE l_fbt031   LIKE fbt_file.fbt031   #MOD-530223
    DEFINE l_cnt      LIKE type_file.num5    #NO.FUN-690009 SMALLINT   #MOD-530223
    DEFINE l_aba19    LIKE aba_file.aba19    #No.FUN-670060
    DEFINE l_sql      LIKE type_file.chr1000 #NO.FUN-690009 VARCHAR(1000)             #No.FUN-670060
    DEFINE l_dbs      STRING                 #No.FUN-670060
 
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbs.fbs01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fbs.* FROM fbs_file WHERE fbs01 = g_fbs.fbs01
   IF g_fbs.fbsconf='N' THEN RETURN END IF
   IF g_fbs.fbspost='Y' THEN CALL cl_err('fbspost=Y:','afa-101',0) RETURN END IF
  #FUN-B60140   ---start   Add
   IF g_faa.faa31 = "Y" THEN
      IF g_fbs.fbspost1='Y' THEN
         CALL cl_err('fbspost1=Y:','afa-101',0)
         RETURN
      END IF
   END IF
  #FUN-B60140   ---end     Add
 #MOD-530223
   #-->判斷是否此張單據之後日期其資產有做減值作業
   SELECT fbt03,fbt031 INTO l_fbt03,l_fbt031 FROM fbt_file,fbs_file
          WHERE fbt01=fbs01 AND fbs01 = g_fbs.fbs01
   SELECT COUNT(*) INTO l_cnt FROM fbs_file,fbt_file
          WHERE fbs01=fbt01 AND fbt03 = l_fbt03 AND fbt031 = l_fbt031
                AND fbs02 > g_fbs.fbs02 AND fbsconf = 'Y'
   IF l_cnt > 0 THEN
      CALL cl_err('','gfa-001',1) RETURN
   END IF
 #END MOD-530223
   #-->已拋轉總帳, 不可取消確認
   IF NOT cl_null(g_fbs.fbs04) AND g_fah.fahglcr = 'N' THEN       #FUN-670060
      CALL cl_err(g_fbs.fbs04,'aap-145',1) RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_fbs.fbs02 < g_faa.faa09 THEN
      CALL cl_err(g_fbs.fbs01,'aap-176',1) RETURN
   END IF
   #FUN-B60140   ---start   Add
   IF g_faa.faa31 = "Y" THEN
      #-->已拋轉總帳, 不可取消確認
      IF NOT cl_null(g_fbs.fbs042) AND g_fah.fahglcr = 'N' THEN
         CALL cl_err(g_fbs.fbs042,'aap-145',1)
         RETURN
      END IF
      #-->立帳日期不可小於關帳日期
      IF g_fbs.fbs02 < g_faa.faa092 THEN
         CALL cl_err(g_fbs.fbs01,'aap-176',1)
         RETURN
      END IF
   END IF
  #FUN-B60140   ---end     Add
   IF g_fbs.fbsconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
    #IF NOT cl_conf(18,10,'axm-109') THEN RETURN END IF   #MOD-530223
   #No.FUN-670060  --Begin
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_fbs.fbs01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
   IF NOT cl_null(g_fbs.fbs04) THEN
      IF NOT (g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y') THEN
         CALL cl_err(g_fbs.fbs01,'axr-370',0) RETURN
      END IF
   END IF
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_plant_new=g_faa.faa02p 
      #CALL s_getdbs()        #FUN-A50102
      #LET l_dbs=g_dbs_new    #FUN-A50102
      #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_faa.faa02b,"'",
                  "    AND aba01 = '",g_fbs.fbs04,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre1 FROM l_sql
      DECLARE aba_cs1 CURSOR FOR aba_pre1
      OPEN aba_cs1
      FETCH aba_cs1 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_fbs.fbs04,'axr-071',1)
         RETURN
      END IF
 
   END IF
   #No.FUN-670060  --End   
    IF NOT cl_confirm('axm-109') THEN RETURN END IF   #MOD-530223
   BEGIN WORK
   OPEN t120_cl USING g_fbs.fbs01
    IF STATUS THEN
       CALL cl_err("OPEN t120_cl:", STATUS, 1)
       CLOSE t120_cl
       ROLLBACK WORK
       RETURN
    END IF
   FETCH t120_cl INTO g_fbs.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fbs.fbs01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t120_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
   UPDATE fbs_file SET fbsconf = 'N' WHERE fbs01 = g_fbs.fbs01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd_z fbsconf',STATUS,1)   #No.FUN-660146
      CALL cl_err3("upd","fbs_file",g_fbs.fbs01,"",STATUS,"","upd_z fbsconf",1)  #No.FUN-660146
      LET g_success = 'N'
   END IF
   #FUN_B60140   ---start   Add
   IF g_faa.faa31 = "Y" THEN
      LET g_t1 = s_get_doc_no(g_fbs.fbs01)
      SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
      IF g_fah.fahfa1 = "N" THEN
         UPDATE fbs_file SET fbspost = 'N',fbspost2='N' WHERE fbs01 = g_fbs.fbs01
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('fbs01',g_fbs.fbs01,'upd fbspost',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
      IF g_fah.fahfa2 = "N" THEN
         UPDATE fbs_file SET fbspost1= 'N' WHERE fbs01 = g_fbs.fbs01
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('fbs01',g_fbs.fbs01,'upd fbspost1',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
      SELECT fbspost,fbspost1,fbspost2
        INTO g_fbs.fbspost,g_fbs.fbspost1,g_fbs.fbspost2
        FROM fbs_file
       WHERE fbs01 = g_fbs.fbs01
      DISPLAY BY NAME g_fbs.fbspost,g_fbs.fbspost1,g_fbs.fbspost2
   END IF
  #FUN_B60140   ---end     Add
   CLOSE t120_cl
   IF g_success = 'Y' THEN
      LET g_fbs.fbsconf='N'
      COMMIT WORK
      DISPLAY BY NAME g_fbs.fbsconf ATTRIBUTE(REVERSE)
   ELSE
      LET g_fbs.fbsconf='Y'
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t120_s()
   DEFINE l_fbt       RECORD LIKE fbt_file.*,
          l_faj       RECORD LIKE faj_file.*,
          l_bdate,l_edate  LIKE type_file.dat,     #NO.FUN-690009 DATE
          l_flag      LIKE type_file.chr1,         #NO.FUN-690009 VARCHAR(01)
          l_fbt07_1   LIKE fbt_file.fbt07,
          l_fbt07_2   LIKE fbt_file.fbt07,
          m_chr       LIKE type_file.chr1          #NO.FUN-690009 VARCHAR(1)
   DEFINE l_fbt072_1  LIKE fbt_file.fbt072         #FUN-AB0088 
   DEFINE l_fbt072_2  LIKE fbt_file.fbt072         #FUN-AB0088
   DEFINE l_cnt       LIKE type_file.num5     #No:FUN-B60140
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbs.fbs01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fbs.* FROM fbs_file WHERE fbs01 = g_fbs.fbs01
   IF g_fbs.fbsconf != 'Y' OR g_fbs.fbspost != 'N' THEN
      CALL cl_err(g_fbs.fbs01,'afa-100',0) RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fbs.fbs02 < g_faa.faa09 THEN
      CALL cl_err(g_fbs.fbs01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-
   #--->折舊年月判斷
   #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
   #CHI-A60036 add --start--
   CALL s_get_bookno(g_faa.faa07)
       RETURNING g_flag,g_bookno1,g_bookno2
   #IF g_aza.aza63 = 'Y' THEN    #FUN-B60140   Mark
    IF g_faa.faa31 = 'Y' THEN    #FUN_B60140   Add
       CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
   ELSE
      CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
   END IF
   #CHI-A60036 add --end--
   IF g_fbs.fbs02 < l_bdate OR g_fbs.fbs02 > l_edate THEN
      CALL cl_err(g_fbs.fbs02,'afa-308',0) RETURN
   END IF
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t120_cl USING g_fbs.fbs01
    IF STATUS THEN
       CALL cl_err("OPEN t120_cl:", STATUS, 1)
       CLOSE t120_cl
       ROLLBACK WORK
       RETURN
    END IF
   FETCH t120_cl INTO g_fbs.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fbs.fbs01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t120_cl ROLLBACK WORK RETURN
   END IF
   DECLARE t120_cur2 CURSOR FOR
      SELECT * FROM fbt_file,faj_file
       WHERE fbt01 = g_fbs.fbs01 AND faj02 = fbt03 AND faj022 = fbt031
   IF STATUS THEN
      CALL cl_err('sel faj',STATUS,0) LET g_success = 'N' 
   END IF
   UPDATE fbs_file SET fbspost = 'Y' WHERE fbs01 = g_fbs.fbs01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd post',STATUS,0)   #No.FUN-660146
      CALL cl_err3("upd","fbs_file",g_fbs.fbs01,"",STATUS,"","upd post",1)  #No.FUN-660146
       #LET g_fbs.fbspost='N'   #MOD-530223
      LET g_success = 'N'
    #ELSE    #MOD-530223
       #LET g_fbs.fbspost='Y'   #MOD-530223
       #LET g_success = 'Y'   #MOD-530223
       #DISPLAY BY NAME g_fbs.fbspost    #MOD-530223
   END IF
   FOREACH t120_cur2 INTO l_fbt.*,l_faj.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      IF cl_null(l_faj.faj101) THEN LET l_faj.faj101 = 0 END IF
      IF cl_null(l_fbt.fbt07)  THEN LET l_fbt.fbt07  = 0 END IF
      IF cl_null(l_faj.faj1012) THEN LET l_faj.faj1012 = 0 END IF  #FUN-AB0088 
      IF cl_null(l_fbt.fbt072)  THEN LET l_fbt.fbt072 = 0 END IF   #FUN-AB0088
      SELECT SUM(fbt07) INTO l_fbt07_1 FROM fbt_file,fbs_file
       WHERE fbt03 = l_faj.faj02 AND fbt031 = l_faj.faj022
         AND fbt06 = '1' AND fbs01 = fbt01
         AND fbspost = 'Y' AND fbsconf = 'Y'
      IF cl_null(l_fbt07_1) THEN LET l_fbt07_1 = 0 END IF
      SELECT SUM(fbt07) INTO l_fbt07_2 FROM fbt_file,fbs_file
       WHERE fbt03 = l_faj.faj02 AND fbt031 = l_faj.faj022
         AND fbt06 = '2' AND fbs01 = fbt01
         AND fbspost = 'Y' AND fbsconf = 'Y'
      IF cl_null(l_fbt07_2) THEN LET l_fbt07_2 = 0 END IF
      #LET l_faj.faj101 = l_fbt07_1 - l_fbt07_2   #MOD-620023
      LET l_faj.faj101 = l_fbt07_2 - l_fbt07_1   #MOD-620023
{
      IF l_fbt.fbt06 = '2' THEN   #調減
         LET l_faj.faj101 = l_faj.faj101 - l_fbt.fbt07
         LET l_fbt.fbt07 = l_fbt.fbt07 * -1
      ELSE
         LET l_faj.faj101 = l_faj.faj101 + l_fbt.fbt07
      END IF
}

     #FUN-B60140   ---start   Mark      
     ##FUN-AB0088---add---str---
     #IF g_faa.faa31 = 'Y' THEN
     #    SELECT SUM(fbt072) INTO l_fbt072_1 FROM fbt_file,fbs_file
     #     WHERE fbt03 = l_faj.faj02 AND fbt031 = l_faj.faj022
     #       AND fbt062 = '1' AND fbs01 = fbt01
     #       AND fbspost = 'Y' AND fbsconf = 'Y'
     #    IF cl_null(l_fbt072_1) THEN LET l_fbt072_1 = 0 END IF
     #    SELECT SUM(fbt072) INTO l_fbt072_2 FROM fbt_file,fbs_file
     #     WHERE fbt03 = l_faj.faj02 AND fbt031 = l_faj.faj022
     #       AND fbt062 = '2' AND fbs01 = fbt01
     #       AND fbspost = 'Y' AND fbsconf = 'Y'
     #    IF cl_null(l_fbt072_2) THEN LET l_fbt072_2 = 0 END IF
     #    LET l_faj.faj1012 = l_fbt072_2 - l_fbt072_1 
     #END IF
     ##FUN-AB0088---add---end---  
     #FUN-B60140   ---start   Mark

      #-----TQC-620120---------
      IF cl_null(l_fbt.fbt031) THEN
         LET l_fbt.fbt031 = ' '
      END IF
      #-----END TQC-620120-----
     #CHI-C60010---str---
      CALL cl_digcut(l_faj.faj1012,g_azi04_1) RETURNING l_faj.faj1012
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj3312,g_azi04_1) RETURNING l_faj.faj3312
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_fbt.fbt072,g_azi04_1) RETURNING l_fbt.fbt072
     #CHI-C60010---end---
      #FUN_B60140   ---start   Add
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fap_file
       WHERE fap50  = l_fbt.fbt01
         AND fap501 = l_fbt.fbt02
         AND fap03  = 'E'              ## 異動代號
      IF l_cnt = 0 THEN   #無fap_file資料
     #FUN_B60140   ---end     Add
         INSERT INTO fap_file(fap01,fap02,fap021,fap03,
                              fap04,fap05,fap06,fap07,
                              fap08,fap09,fap10,fap101,
                              fap11,fap12,fap13,fap14,
                              fap15,fap16,fap17,fap18,
                              fap19,fap20,fap201,fap21,
                              fap22,fap23,fap24,fap25,
                              fap26,fap50,fap501,fap661,
                              fap55,fap52,fap53,fap54,
                              fap80,fap41,
                              fap121,fap131,fap141,     #No.FUN-680028
                             #FUN-AB0088---add---str---
                              fap052,fap062,fap072,fap082,
                              fap092,
                             #fap102,                   #No.MOD-B60165   mark
                              fap1012,fap112,
                              fap152,fap162,
                              fap212,fap222,fap232,fap242,
                              fap252,fap262,fap522,fap532,
                              fap542,fap552,fap6612,fap802,      
                           #FUN-AB0088---add---end---
                              fap103,fap512,fap562,fap572,  #TQC-B60345 add
                              fap612,fap772,                #TQC-B60345 add
                              faplegal)    #FUN-980011 add
      VALUES(l_faj.faj01,l_fbt.fbt03,l_fbt.fbt031,'E',
             g_fbs.fbs02,l_faj.faj43,l_faj.faj28, l_faj.faj30,
     #       l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33,               #MOD-970231 mark
             l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33+l_faj.faj331,  #MOD-970231
             l_faj.faj32,l_faj.faj53,l_faj.faj54, l_faj.faj55,
             l_faj.faj23,l_faj.faj24,l_faj.faj20, l_faj.faj19,
             l_faj.faj21,l_faj.faj17,l_faj.faj171,l_faj.faj58,
             l_faj.faj59,l_faj.faj60,l_faj.faj34, l_faj.faj35,
             l_faj.faj36,l_fbt.fbt01,l_fbt.fbt02, l_faj.faj14,
             l_faj.faj32,l_faj.faj30,l_faj.faj31, l_fbt.fbt07,
             l_faj.faj101,l_faj.faj100,
             l_faj.faj531,l_faj.faj541,l_faj.faj551,     #No.FUN-680028
             #FUN-AB0088---add---str---
             l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,
             l_faj.faj142,
            #l_faj.faj1412,                              #No.MOD-B60165   mark
             l_faj.faj332+l_faj.faj3312,l_faj.faj322,
             l_faj.faj232,l_faj.faj242,
             l_faj.faj582,l_faj.faj592,l_faj.faj602,l_faj.faj342,
             l_faj.faj352,l_faj.faj362,l_faj.faj302,l_faj.faj312,
             l_fbt.fbt072,
             l_faj.faj322,l_faj.faj142,l_faj.faj1012,  
             #FUN-AB0088---add---end---
             l_faj.faj1412,l_faj.faj282,l_faj.faj592,l_faj.faj602,  #TQC-B60345 add
             l_faj.faj232,l_faj.faj432,                             #TQC-B60345 add
             g_legal)    #FUN-980011 add
      #FUN-B60140   ---start   Add
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
                             fap52 = l_faj.faj30,
                             fap53 = l_faj.faj31,
                             fap54 = l_fbt.fbt07,
                             fap55 = l_faj.faj32,
                             fap661 = l_faj.faj14,
                             fap80 = l_faj.faj101,
                             fap51 = l_faj.faj28,
                             fap56 = l_faj.faj59,
                             fap57 = l_faj.faj60,
                             fap61 = l_faj.faj23,
                             fap77 = l_faj.faj43
                       WHERE fap50  = l_fbt.fbt01
                         AND fap501 = l_fbt.fbt02
                         AND fap03  = 'E'              ## 異動代號
      END IF
     #FUN-B60140   ---end     Add

      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#        CALL cl_err('ins fap',STATUS,0)   #No.FUN-660146
         CALL cl_err3("ins","fap_file",l_fbt.fbt03,l_fbt.fbt031,STATUS,"","ins fap",1)  #No.FUN-660146
         LET g_success = 'N'
      END IF
      #--------- 過帳(3)update faj_file
      UPDATE faj_file SET faj100 = g_fbs.fbs02,    #最近異動日期
                          faj101 = l_faj.faj101   #已提列減值準備金額
                       #  faj1012= l_faj.faj1012   #FUN-AB0088   #FUN-B60140   Mark
       WHERE faj02=l_fbt.fbt03 AND faj022=l_fbt.fbt031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#        CALL cl_err('upd faj',STATUS,0)   #No.FUN-660146
         CALL cl_err3("upd","faj_file",l_fbt.fbt03,l_fbt.fbt031,STATUS,"","upd faj",1)  #No.FUN-660146
         LET g_success = 'N'
      END IF
   END FOREACH
   CLOSE t120_cl
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
      LET g_fbs.fbspost='Y'
      DISPLAY BY NAME g_fbs.fbspost
   END IF
   #No.FUN-670060  --Begin
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_fbs.fbs01,'" AND npp011 = 1'
#     LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_fbs.fbs02,"' 'Y' '0' 'Y'"   #No.FUN-680028
      LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_fbs.fbs02,"' 'Y' '0' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"   #No.FUN-680028
      CALL cl_cmdrun_wait(g_str)
      SELECT fbs04,fbs05 INTO g_fbs.fbs04,g_fbs.fbs05 FROM fbs_file
       WHERE fbs01 = g_fbs.fbs01
      DISPLAY BY NAME g_fbs.fbs04
      DISPLAY BY NAME g_fbs.fbs05
   END IF
   #No.FUN-670060  --End
END FUNCTION
 
FUNCTION t120_w()
   DEFINE l_fbt    RECORD LIKE fbt_file.*,
          l_faj    RECORD LIKE faj_file.*,
          l_fap    RECORD LIKE fap_file.*,
          l_fap41  LIKE fap_file.fap41,
          l_fap54  LIKE fap_file.fap54,
          l_bdate,l_edate  LIKE type_file.dat,     #NO.FUN-690009 DATE
          l_fbt07_1 LIKE fbt_file.fbt07,
          l_fbt07_2 LIKE fbt_file.fbt07
   DEFINE l_fbt072_1 LIKE fbt_file.fbt072   #FUN-AB0088
   DEFINE l_fbt072_2 LIKE fbt_file.fbt072   #FUN-AB0088
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbs.fbs01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fbs.* FROM fbs_file WHERE fbs01 = g_fbs.fbs01
   IF g_fbs.fbspost != 'Y' THEN
      CALL cl_err(g_fbs.fbs01,'afa-108',0) RETURN
   END IF
   #FUN_B60140   ---start   Mark
   #IF g_fbs.fbspost2 = 'Y' THEN
   #   CALL cl_err(g_fbs.fbs01,'afa-952',0) RETURN
   #END IF
   #FUN_B60140   ---end     Mark
   #-->已拋轉總帳, 不可取消確認
#  IF NOT cl_null(g_fbs.fbs04) THEN   #No.FUN-680028
   IF NOT cl_null(g_fbs.fbs04) AND g_fah.fahglcr != 'Y' THEN   #No.FUN-680028
      CALL cl_err(g_fbs.fbs04,'aap-145',1) RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fbs.fbs02 < g_faa.faa09 THEN
      CALL cl_err(g_fbs.fbs01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-
   #--->折舊年月判斷
   #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
   #CHI-A60036 add --start--
   CALL s_get_bookno(g_faa.faa07)
       RETURNING g_flag,g_bookno1,g_bookno2
   #IF g_aza.aza63 = 'Y' THEN   #FUN-B60140   Mark
    IF g_faa.faa31 = 'Y' THEN   #FUN-B60140   Add
       CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
   ELSE
      CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
   END IF
   #CHI-A60036 add --end--
   IF g_fbs.fbs02 < l_bdate OR g_fbs.fbs02 > l_edate THEN
      CALL cl_err(g_fbs.fbs02,'afa-308',0) RETURN
   END IF
   IF NOT cl_sure(18,20) THEN RETURN END IF
  #------------------------------CHI-C90051----------------------------(S)
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fbs.fbs04,"' '13' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT fbs04,fbs05 INTO g_fbs.fbs04,g_fbs.fbs05 FROM fbs_file
       WHERE fbs01 = g_fbs.fbs01
      DISPLAY BY NAME g_fbs.fbs04
      DISPLAY BY NAME g_fbs.fbs05
      IF NOT cl_null(g_fbs.fbs04) THEN
         CALL cl_err('','aap-929',0)
         RETURN
      END IF
   END IF
  #------------------------------CHI-C90051----------------------------(E)
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t120_cl USING g_fbs.fbs01
    IF STATUS THEN
       CALL cl_err("OPEN t120_cl:", STATUS, 1)
       CLOSE t120_cl
       ROLLBACK WORK
       RETURN
    END IF
   FETCH t120_cl INTO g_fbs.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fbs.fbs01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t120_cl ROLLBACK WORK RETURN
   END IF
   DECLARE t120_cur3 CURSOR FOR
      SELECT * FROM fbt_file,faj_file
       WHERE fbt01 = g_fbs.fbs01 AND faj02 = fbt03 AND faj022 = fbt031
   IF STATUS THEN
      CALL cl_err('t120_cur3',STATUS,0) LET g_success = 'N' 
   END IF
   UPDATE fbs_file SET fbspost = 'N' WHERE fbs01 = g_fbs.fbs01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd post',STATUS,0)   #No.FUN-660146
      CALL cl_err3("upd","fbs_file",g_fbs.fbs01,"",STATUS,"","upd post",1)  #No.FUN-660146
      LET g_success = 'N' 
      LET g_fbs.fbspost='Y'
   END IF
   FOREACH t120_cur3 INTO l_fbt.*,l_faj.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         LET g_success = 'N' EXIT FOREACH
      END IF
      #----- 找出 fap_file 以便 update faj_file
      SELECT fap41,fap54 INTO l_fap41,l_fap54
        FROM fap_file
       WHERE fap50=l_fbt.fbt01 AND fap501=l_fbt.fbt02 AND fap03='E'
      IF STATUS THEN
#        CALL cl_err('sel fap',STATUS,0)    #No.FUN-660146
         CALL cl_err3("sel","fap_file",l_fbt.fbt01,l_fbt.fbt02,STATUS,"","sel fap",1)  #No.FUN-660146
         LET g_success = 'N'
      END IF
      IF cl_null(l_faj.faj101) THEN LET l_faj.faj101 = 0 END IF
      IF cl_null(l_faj.faj1012) THEN LET l_faj.faj1012 = 0 END IF   #FUN-AB0088
      IF cl_null(l_fap54) THEN LET l_fap54 = 0 END IF
 
#     LET l_faj.faj101 = l_faj.faj101 - l_fap54
      SELECT SUM(fbt07) INTO l_fbt07_1 FROM fbt_file,fbs_file
       WHERE fbt03 = l_faj.faj02 AND fbt031 = l_faj.faj022
         AND fbt06 = '1' AND fbs01 = fbt01
         AND fbspost = 'Y' AND fbsconf = 'Y'
      IF cl_null(l_fbt07_1) THEN LET l_fbt07_1 = 0 END IF
      SELECT SUM(fbt07) INTO l_fbt07_2 FROM fbt_file,fbs_file
       WHERE fbt03 = l_faj.faj02 AND fbt031 = l_faj.faj022
         AND fbt06 = '2' AND fbs01 = fbt01
         AND fbspost = 'Y' AND fbsconf = 'Y'
      IF cl_null(l_fbt07_2) THEN LET l_fbt07_2 = 0 END IF
      LET l_faj.faj101 = l_fbt07_1 - l_fbt07_2
 
      #FUN-B60140   ---start   Mark
      #FUN-AB0088---add---str---
      #IF g_faa.faa31 = 'Y' THEN
      #   SELECT SUM(fbt072) INTO l_fbt072_1 FROM fbt_file,fbs_file
      #    WHERE fbt03 = l_faj.faj02 AND fbt031 = l_faj.faj022
      #      AND fbt062 = '1' AND fbs01 = fbt01
      #      AND fbspost = 'Y' AND fbsconf = 'Y'
      #   IF cl_null(l_fbt072_1) THEN LET l_fbt072_1 = 0 END IF
      #   SELECT SUM(fbt072) INTO l_fbt072_2 FROM fbt_file,fbs_file
      #    WHERE fbt03 = l_faj.faj02 AND fbt031 = l_faj.faj022
      #      AND fbt062 = '2' AND fbs01 = fbt01
      #      AND fbspost = 'Y' AND fbsconf = 'Y'
      #   IF cl_null(l_fbt072_2) THEN LET l_fbt072_2 = 0 END IF
      #   LET l_faj.faj1012 = l_fbt072_1 - l_fbt072_2   
      #END IF  
      #FUN-AB0088---add---end--- 
      #FUN-B60140   ---end     Mark

      UPDATE faj_file SET faj100 = l_fap41,
                          faj101 = l_faj.faj101
                      #   faj1012 = l_faj.faj1012   #FUN-AB0088   #FUN-B60140   Mark
       WHERE faj02=l_fbt.fbt03 AND faj022=l_fbt.fbt031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#        CALL cl_err('upd faj',STATUS,0)   #No.FUN-660146
         CALL cl_err3("upd","faj_file",l_fbt.fbt03,l_fbt.fbt031,STATUS,"","upd faj",1)  #No.FUN-660146
         LET g_success = 'N' 
      END IF

      IF g_fbs.fbspost1<>'Y' AND g_fbs.fbspost2<>'Y' THEN   #FUN-B60140   Add
         #--------- 還原過帳(3)delete fap_file

         DELETE FROM fap_file WHERE fap50 =l_fbt.fbt01
                                AND fap501=l_fbt.fbt02
                                AND fap03 = 'E'
         IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#           CALL cl_err('del fap',STATUS,0)  #No.FUN-660146
            CALL cl_err3("del","fap_file",l_fbt.fbt01,l_fbt.fbt02,STATUS,"","del fap",1)  #No.FUN-660146
            LET g_success = 'N'  
         END IF
       END IF   #FUN-B60140   Add
   END FOREACH
{
   IF g_success = 'Y' THEN
      UPDATE fbs_file SET fbspost = 'N' WHERE fbs01 = g_fbs.fbs01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd post',STATUS,0)
         LET g_success = 'N' 
         LET g_fbs.fbspost='Y'
      END IF
   END IF
}
   CLOSE t120_cl
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
      LET g_fbs.fbspost='N'
      DISPLAY BY NAME g_fbs.fbspost
   END IF
  #------------------------------CHI-C90051----------------------------mark
  ##No.FUN-670060  --Begin
  #IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
  #   LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fbs.fbs04,"' '13' 'Y'"
  #   CALL cl_cmdrun_wait(g_str)
  #   SELECT fbs04,fbs05 INTO g_fbs.fbs04,g_fbs.fbs05 FROM fbs_file
  #    WHERE fbs01 = g_fbs.fbs01
  #   DISPLAY BY NAME g_fbs.fbs04
  #   DISPLAY BY NAME g_fbs.fbs05
  #END IF
  ##No.FUN-670060  --End   
  #------------------------------CHI-C90051----------------------------mark
END FUNCTION
 
#FUNCTION t120_x() #FUN-D20035 mark
FUNCTION t120_x(p_type) #FUN-D20035 add
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035 add 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_fbs.* FROM fbs_file WHERE fbs01=g_fbs.fbs01
   IF g_fbs.fbs01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fbs.fbsconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   #FUN-D20035---begin 
    IF p_type = 1 THEN 
       IF g_fbs.fbsconf='X' THEN RETURN END IF
    ELSE
       IF g_fbs.fbsconf<>'X' THEN RETURN END IF
    END IF 
    #FUN-D20035---end
   BEGIN WORK
   LET g_success='Y'
   OPEN t120_cl USING g_fbs.fbs01
   IF STATUS THEN
      CALL cl_err("OPEN t120_cl:", STATUS, 1)
      CLOSE t120_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t120_cl INTO g_fbs.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fbs.fbs01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t120_cl ROLLBACK WORK RETURN
   END IF
   #-->作廢轉換01/08/01
   IF cl_void(0,0,g_fbs.fbsconf) THEN
      LET g_chr=g_fbs.fbsconf
      IF g_fbs.fbsconf ='N' THEN
         LET g_fbs.fbsconf='X'
      ELSE
         LET g_fbs.fbsconf='N'
      END IF
      UPDATE fbs_file SET fbsconf =g_fbs.fbsconf,fbsmodu=g_user,fbsdate=TODAY
       WHERE fbs01 = g_fbs.fbs01
      IF STATUS THEN
#        CALL cl_err('upd fbsconf:',STATUS,1)  #No.FUN-660146
         CALL cl_err3("upd","fbs_file",g_fbs.fbs01,"",STATUS,"","upd fbsconf",1)  #No.FUN-660146
         LET g_success='N'  
      END IF
      IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
      SELECT fbsconf INTO g_fbs.fbsconf FROM fbs_file
       WHERE fbs01 = g_fbs.fbs01
      DISPLAY BY NAME g_fbs.fbsconf
   END IF
END FUNCTION
 
FUNCTION t120_k()
   DEFINE l_fbt     DYNAMIC ARRAY OF RECORD
                    fbt02	LIKE fbt_file.fbt02,
                    fbt03	LIKE fbt_file.fbt03,
                    fbt031	LIKE fbt_file.fbt031,
                    fbt04	LIKE fbt_file.fbt04,
                    fbt05	LIKE fbt_file.fbt05,
                    fbt06	LIKE fbt_file.fbt06,
                    fbt07	LIKE fbt_file.fbt07,
                    fbt11	LIKE fbt_file.fbt11,
                    fbt12	LIKE fbt_file.fbt12,
                    fbt13	LIKE fbt_file.fbt13,
                    fbt14	LIKE fbt_file.fbt14,
                    faj06	LIKE faj_file.faj06,
                    faj18	LIKE faj_file.faj18
                    END RECORD
   DEFINE l_fbt_t   RECORD
                    fbt02	LIKE fbt_file.fbt02,
                    fbt03	LIKE fbt_file.fbt03,
                    fbt031	LIKE fbt_file.fbt031,
                    fbt04	LIKE fbt_file.fbt04,
                    fbt05	LIKE fbt_file.fbt05,
                    fbt06	LIKE fbt_file.fbt06,
                    fbt07	LIKE fbt_file.fbt07,
                    fbt11	LIKE fbt_file.fbt11,
                    fbt12	LIKE fbt_file.fbt12,
                    fbt13	LIKE fbt_file.fbt13,
                    fbt14	LIKE fbt_file.fbt14,
                    faj06	LIKE faj_file.faj06,
                    faj18	LIKE faj_file.faj18
                    END RECORD
   DEFINE l_lock_sw       LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(01)
   DEFINE l_modify_flag   LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(01)
   DEFINE p_cmd           LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(01)
   DEFINE i,j,k           LIKE type_file.num5     #NO.FUN-690009 SMALLINT
   DEFINE ls_tmp          STRING
   DEFINE l_allow_insert  LIKE type_file.num5     #NO.FUN-690009 SMALLINT              #可新增否
   DEFINE l_allow_delete  LIKE type_file.num5     #NO.FUN-690009 SMALLINT              #可刪除否
 
   IF g_fbs.fbs01 IS NULL THEN RETURN END IF
   IF g_fbs.fbsconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   LET p_row = 8 LET p_col = 2
   OPEN WINDOW t120_w5 AT p_row,p_col
        WITH FORM "gfa/42f/gfat1202"  ATTRIBUTE (STYLE = g_win_style CLIPPED)                                               #No.FUN-580092 HCN
 
   CALL cl_ui_locale("gfat1202")
 
   DECLARE t120_kkk_c CURSOR FOR
         SELECT fbt02,fbt03,fbt031,fbt04,fbt05,fbt06,
                fbt07,fbt11,fbt12,fbt13,fbt14,faj06,faj18
           FROM fbt_file LEFT OUTER JOIN faj_file ON fbt_file.fbt03=faj_file.faj02 AND fbt_file.fbt031=faj_file.faj022
            WHERE fbt01 = g_fbs.fbs01
          ORDER BY 1
   CALL l_fbt.clear()
   LET k = 1
   FOREACH t120_kkk_c INTO l_fbt[k].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('t120_kkk_c',SQLCA.sqlcode,0) 
         EXIT FOREACH
      END IF
      LET k = k + 1
      IF k > g_max_rec THEN EXIT FOREACH END IF
   END FOREACH
   CALL g_fbt.deleteElement(k)
 
   IF g_fbs.fbspost2= 'Y' THEN
      DISPLAY ARRAY l_fbt TO s_fbt.* ATTRIBUTE(COUNT=k-1,UNBUFFERED)
 
#--NO.MOD-860078 start---
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controlg      
           CALL cl_cmdask()     
 
      END DISPLAY 
#--NO.MOD-860078 end------- 
      CLOSE WINDOW t120_w5
      RETURN
   END IF
 
   SELECT * FROM fbs_file WHERE fbs01 = g_fbs.fbs01
   DISPLAY BY NAME g_fbs.fbsconf, g_fbs.fbspost, g_fbs.fbspost2,
                   g_fbs.fbsuser, g_fbs.fbsgrup, g_fbs.fbsmodu,g_fbs.fbsdate
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_fbt WITHOUT DEFAULTS FROM s_fbt.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
          CALL fgl_set_arr_curr(l_ac)
 
      BEFORE ROW
         LET i = ARR_CURR() LET j = SCR_LINE()
         LET l_fbt_t.* = l_fbt[i].*
         LET l_lock_sw = 'N'
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_success = 'Y'
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         ELSE
            LET g_success = 'Y'
            LET p_cmd='a'
            INITIALIZE l_fbt[i].* TO NULL
         END IF
 
      AFTER FIELD fbt13
         IF cl_null(l_fbt[i].fbt13) OR
            l_fbt[i].fbt13 NOT MATCHES '[12]' THEN
            NEXT FIELD fbt13
         END IF
 
      AFTER FIELD fbt14
         IF cl_null(l_fbt[i].fbt14) THEN
            LET l_fbt[i].fbt14 = 0
         END IF
         IF l_fbt[i].fbt14 != 0 THEN
            #調增時, 不可超過未折減餘額
            IF l_fbt[i].fbt13 = '1' AND
               l_fbt[i].fbt14 > l_fbt[i].fbt11 THEN
               CALL cl_err(l_fbt[i].fbt14,'afa-042',0) NEXT FIELD fbt14
            END IF
            #調減時, 不可超過已提列減值準備金額
            IF l_fbt[i].fbt13 = '2' AND
               l_fbt[i].fbt14 > l_fbt[i].fbt12 THEN
               CALL cl_err(l_fbt[i].fbt14,'afa-051',0) NEXT FIELD fbt14
            END IF
         END IF
 
      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET l_fbt[i].* = l_fbt_t.*
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(l_fbt[i].fbt02,-263,1)
             LET l_fbt[i].* = l_fbt_t.*
          ELSE
             IF l_fbt[i].fbt03 IS NULL THEN
                INITIALIZE l_fbt[i].* TO NULL
                DISPLAY l_fbt[i].* TO s_fbt[j].*
             END IF
             UPDATE fbt_file SET fbt11 = l_fbt[i].fbt11,
                                 fbt12 = l_fbt[i].fbt12,
                                 fbt13 = l_fbt[i].fbt13,
                                 fbt14 = l_fbt[i].fbt14
              WHERE fbt01 = g_fbs.fbs01 AND fbt02 = l_fbt_t.fbt02
             IF STATUS THEN
#               CALL cl_err('upd fbt:',STATUS,1)   #No.FUN-660146
                CALL cl_err3("upd","fbt_file",g_fbs.fbs01,l_fbt_t.fbt02,STATUS,"","upd fbt",1)  #No.FUN-660146
                LET l_fbt[i].* = l_fbt_t.*
                DISPLAY l_fbt[i].* TO s_fbt[j].*
             ELSE MESSAGE "update ok"
             END IF
          END IF
 
      AFTER ROW
         IF INT_FLAG THEN EXIT INPUT END IF
 
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
   IF INT_FLAG THEN LET INT_FLAG = 0 ROLLBACK WORK END IF	
   CLOSE WINDOW t120_w5
END FUNCTION
 
FUNCTION t120_6()
   DEFINE l_fbt       RECORD LIKE fbt_file.*,
          l_faj       RECORD LIKE faj_file.*,
          l_bdate,l_edate  LIKE type_file.dat,     #NO.FUN-690009 DATE
          l_flag      LIKE type_file.chr1,         #NO.FUN-690009 VARCHAR(01)
          l_yy,l_mm   LIKE type_file.num5,         #NO.FUN-690009 SMALLINT
          l_fbt14_1   LIKE fbt_file.fbt14,
          l_fbt14_2   LIKE fbt_file.fbt14,
          m_chr       LIKE type_file.chr1          #NO.FUN-690009 VARCHAR(1)
   DEFINE l_cnt       LIKE type_file.num5          #FUN-B60140   Add
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbs.fbs01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fbs.* FROM fbs_file WHERE fbs01 = g_fbs.fbs01
   IF g_fbs.fbspost2 = 'Y' THEN RETURN END IF   #add 031130 NO.A100
  #IF g_fbs.fbsconf != 'Y' OR g_fbs.fbspost != 'Y' THEN   #FUN-B60140   Mark
   IF g_fbs.fbsconf != 'Y' THEN                           #FUN-B60140   Add
      CALL cl_err(g_fbs.fbs01,'afa-100',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa13 INTO g_faa.faa13 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #--->折舊年月判斷
   IF g_fbs.fbs02 < g_faa.faa13 THEN
      CALL cl_err(g_fbs.fbs02,'afa-308',0)
      RETURN
   END IF
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK
   OPEN t120_cl USING g_fbs.fbs01
   IF STATUS THEN
       CALL cl_err("OPEN t120_cl:", STATUS, 1)
       CLOSE t120_cl
       ROLLBACK WORK
       RETURN
    END IF
   FETCH t120_cl INTO g_fbs.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fbs.fbs01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t120_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
   DECLARE t120_cur21 CURSOR FOR
      SELECT * FROM fbt_file,faj_file
       WHERE fbt01 = g_fbs.fbs01 AND faj02 = fbt03 AND faj022 = fbt031
 
   UPDATE fbs_file SET fbspost2 = 'Y' WHERE fbs01 = g_fbs.fbs01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd post2',STATUS,0)   #No.FUN-660146
      CALL cl_err3("upd","fbs_file",g_fbs.fbs01,"",STATUS,"","upd post2",1)  #No.FUN-660146
      LET g_fbs.fbspost2='N'
      LET g_success = 'N'
   ELSE
      LET g_fbs.fbspost2='Y'
      LET g_success = 'Y'
      DISPLAY BY NAME g_fbs.fbspost2 # ATTRIBUTE(YELLOW)
   END IF
   FOREACH t120_cur21 INTO l_fbt.*,l_faj.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      SELECT SUM(fbt14) INTO l_fbt14_1 FROM fbt_file,fbs_file
       WHERE fbt03 = l_faj.faj02 AND fbt031 = l_faj.faj022
         AND fbt13 = '1' AND fbs01 = fbt01
         AND fbspost2 = 'Y' AND fbsconf = 'Y'
      IF cl_null(l_fbt14_1) THEN LET l_fbt14_1 = 0 END IF
      SELECT SUM(fbt14) INTO l_fbt14_2 FROM fbt_file,fbs_file
       WHERE fbt03 = l_faj.faj02 AND fbt031 = l_faj.faj022
         AND fbt13 = '2' AND fbs01 = fbt01
         AND fbspost2 = 'Y' AND fbsconf = 'Y'
      IF cl_null(l_fbt14_2) THEN LET l_fbt14_2 = 0 END IF
     #LET l_faj.faj103 = l_fbt14_1 - l_fbt14_2      #MOD-980143 mark
      LET l_faj.faj103 = l_fbt14_2 - l_fbt14_1      #MOD-980143 add
{
      IF l_fbt.fbt13 = '2' THEN   #調減
         LET l_faj.faj103 = l_faj.faj103 - l_fbt.fbt14
         LET l_fbt.fbt14 = l_fbt.fbt14 * -1
      ELSE
         LET l_faj.faj103 = l_faj.faj103 + l_fbt.fbt14
      END IF
}

     #CHI-C60010---str---
      CALL cl_digcut(l_faj.faj1012,g_azi04_1) RETURNING l_faj.faj1012
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj3312,g_azi04_1) RETURNING l_faj.faj3312
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_fbt.fbt072,g_azi04_1) RETURNING l_fbt.fbt072
     #CHI-C60010---end-- 
      #--->(1.1)更新稅簽異動檔
      #FUN-B60140   ---start   Add
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fap_file
       WHERE fap50  = l_fbt.fbt01
         AND fap501 = l_fbt.fbt02
         AND fap03  = 'E'              ## 異動代號
      IF l_cnt = 0 THEN   #無fap_file資料
         INSERT INTO fap_file(fap01, fap02, fap021,fap03, fap04, fap05, fap06,  fap07,
                              fap08, fap09, fap10, fap101,fap11, fap12, fap13,  fap14,
                              fap15, fap16, fap17, fap18, fap19, fap20, fap201, fap21,
                              fap22, fap23, fap24, fap25, fap26, fap50, fap501, fap661,
                              fap55, fap52, fap53, fap54, fap80, fap41, fap121, fap131,
                              fap141,fap052,fap062,fap072,fap082,fap092,fap1012,
                              fap112,fap152,fap162,fap212,fap222,fap232,fap242,
                              fap252,fap262,fap522,fap532,fap542,fap552,fap6612,
                              fap802,fap103,fap512,fap562,fap572,fap612,fap772, faplegal)
         VALUES(l_faj.faj01, l_fbt.fbt03, l_fbt.fbt031, 'E',g_fbs.fbs02,l_faj.faj43,
                l_faj.faj28, l_faj.faj30, l_faj.faj31,  l_faj.faj14,  l_faj.faj141,
                l_faj.faj33+l_faj.faj331, l_faj.faj32,  l_faj.faj53,  l_faj.faj54,
                l_faj.faj55, l_faj.faj23, l_faj.faj24,  l_faj.faj20,  l_faj.faj19,
                l_faj.faj21, l_faj.faj17, l_faj.faj171, l_faj.faj58,  l_faj.faj59,
                l_faj.faj60, l_faj.faj34, l_faj.faj35,  l_faj.faj36,  l_fbt.fbt01,
                l_fbt.fbt02, l_faj.faj14, l_faj.faj32,  l_faj.faj30,  l_faj.faj31,
                l_fbt.fbt07, l_faj.faj101,l_faj.faj100, l_faj.faj531, l_faj.faj541,
                l_faj.faj551,l_faj.faj432,l_faj.faj282, l_faj.faj302, l_faj.faj312,
                l_faj.faj142,l_faj.faj332+l_faj.faj3312,l_faj.faj322, l_faj.faj232,
                l_faj.faj242,l_faj.faj582,l_faj.faj592, l_faj.faj602, l_faj.faj342,
                l_faj.faj352,l_faj.faj362,l_faj.faj302, l_faj.faj312, l_fbt.fbt072,
                l_faj.faj322,l_faj.faj142,l_faj.faj1012,l_faj.faj1412,l_faj.faj282,
                l_faj.faj592,l_faj.faj602,l_faj.faj232, l_faj.faj432, g_legal)
      ELSE
     #FUN-B60140   ---end     Add
         UPDATE fap_file SET fap71  = l_fbt.fbt14,
                             fap78  = l_faj.faj103                  #減值
          WHERE fap50 = g_fbs.fbs01 AND fap501= l_fbt.fbt02 AND fap03 = 'E'
          END IF     #FUN-B60140   Add
          IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#            CALL cl_err('upd fap',STATUS,0)   #No.FUN-660146
             CALL cl_err3("upd","fap_file",g_fbs.fbs01,l_fbt.fbt02,STATUS,"","upd fap",1)  #No.FUN-660146
             LET g_success = 'N'
             EXIT FOREACH
          END IF
 
      UPDATE faj_file SET faj103 = l_faj.faj103    #稅簽已提列減值準備
       WHERE faj02=l_fbt.fbt03 AND faj022=l_fbt.fbt031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#        CALL cl_err('upd faj',STATUS,0)   #No.FUN-660146
         CALL cl_err3("upd","faj_file",l_fbt.fbt03,l_fbt.fbt031,STATUS,"","upd faj",1)  #No.FUN-660146
         LET g_success = 'N'
      END IF
   END FOREACH
{
      IF g_success = 'Y' THEN
         UPDATE fbs_file SET fbspost2 = 'Y' WHERE fbs01 = g_fbs.fbs01
         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('upd post2',STATUS,0)
            LET g_fbs.fbspost2='N'
            LET g_success = 'N'
         ELSE
            LET g_fbs.fbspost2='Y'
            LET g_success = 'Y'
            DISPLAY BY NAME g_fbs.fbspost2 # ATTRIBUTE(YELLOW)
         END IF
      END IF
}
   CLOSE t120_cl
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
      LET g_fbs.fbspost2='Y'
      DISPLAY BY NAME g_fbs.fbspost2
   END IF
END FUNCTION
 
FUNCTION t120_7()
   DEFINE l_fbt     RECORD LIKE fbt_file.*,
          l_faj     RECORD LIKE faj_file.*,
          l_fap71   LIKE fap_file.fap71,
          l_yy,l_mm         LIKE type_file.num5,    #NO.FUN-690009 SMALLINT
          l_bdate,l_edate   LIKE type_file.dat,     #NO.FUN-690009 DATE
          l_fbt14_1         LIKE fbt_file.fbt14,
          l_fbt14_2         LIKE fbt_file.fbt14
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbs.fbs01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fbs.* FROM fbs_file WHERE fbs01 = g_fbs.fbs01
   IF g_fbs.fbspost2 != 'Y' THEN
      CALL cl_err(g_fbs.fbs01,'afa-108',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa13 INTO g_faa.faa13 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #--->折舊年月判斷
   IF g_fbs.fbs02 < g_faa.faa13 THEN
      CALL cl_err(g_fbs.fbs02,'afa-308',0)
      RETURN
   END IF
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK
    OPEN t120_cl USING g_fbs.fbs01
    IF STATUS THEN
       CALL cl_err("OPEN t120_cl:", STATUS, 1)
       CLOSE t120_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t120_cl INTO g_fbs.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbs.fbs01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t120_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
 
   DECLARE t120_cur31 CURSOR FOR
      SELECT * FROM fbt_file,faj_file
       WHERE fbt01 = g_fbs.fbs01 AND faj02 = fbt03 AND faj022 = fbt031
 
   UPDATE fbs_file SET fbspost2 = 'N' WHERE fbs01 = g_fbs.fbs01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd post2',STATUS,0)   #No.FUN-660146
      CALL cl_err3("upd","fbs_file",g_fbs.fbs01,"",STATUS,"","upd post2",1)  #No.FUN-660146
      LET g_fbs.fbspost2='Y'
      LET g_success = 'N'
   END IF
   FOREACH t120_cur31 INTO l_fbt.*,l_faj.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      #----- 找出 fap_file 以便 update faj_file
      SELECT fap71 INTO l_fap71 FROM fap_file
       WHERE fap50=l_fbt.fbt01 AND fap501=l_fbt.fbt02 AND fap03='E'
      IF STATUS THEN
#        CALL cl_err('sel fap',STATUS,0)  #No.FUN-660146
         CALL cl_err3("sel","fap_file",l_fbt.fbt01,l_fbt.fbt02,STATUS,"","sel fap",1)  #No.FUN-660146
         LET g_success = 'N'  
      END IF
      IF cl_null(l_faj.faj103) THEN LET l_faj.faj103 = 0 END IF
      IF cl_null(l_fap71) THEN LET l_fap71 = 0 END IF
 
#     LET l_faj.faj103 = l_faj.faj103 - l_fap71
 
      SELECT SUM(fbt14) INTO l_fbt14_1 FROM fbt_file,fbs_file
       WHERE fbt03 = l_faj.faj02 AND fbt031 = l_faj.faj022
         AND fbt13 = '1' AND fbs01 = fbt01
         AND fbspost2 = 'Y' AND fbsconf = 'Y'
      IF cl_null(l_fbt14_1) THEN LET l_fbt14_1 = 0 END IF
      SELECT SUM(fbt14) INTO l_fbt14_2 FROM fbt_file,fbs_file
       WHERE fbt03 = l_faj.faj02 AND fbt031 = l_faj.faj022
         AND fbt13 = '2' AND fbs01 = fbt01
         AND fbspost2 = 'Y' AND fbsconf = 'Y'
      IF cl_null(l_fbt14_2) THEN LET l_fbt14_2 = 0 END IF
      LET l_faj.faj103 = l_fbt14_1 - l_fbt14_2
 
      #--->(1.1)更新稅簽異動檔
      UPDATE fap_file SET fap71  = 0,
                          fap78  = l_faj.faj103                  #減值
       WHERE fap50 = g_fbs.fbs01 AND fap501= l_fbt.fbt02 AND fap03 = 'E'
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#        CALL cl_err('upd fap',STATUS,0)   #No.FUN-660146
         CALL cl_err3("upd","fap_file",g_fbs.fbs01,l_fbt.fbt02,STATUS,"","upd fap",1)  #No.FUN-660146
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
      UPDATE faj_file SET faj103 = l_faj.faj103    #稅簽已提列減值準備
       WHERE faj02=l_fbt.fbt03 AND faj022=l_fbt.fbt031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#        CALL cl_err('upd faj',STATUS,0)   #No.FUN-660146
         CALL cl_err3("upd","faj_file",l_fbt.fbt03,l_fbt.fbt031,STATUS,"","upd faj",1)  #No.FUN-660146
         LET g_success = 'N'
      END IF
   END FOREACH
{
   IF g_success = 'Y' THEN
      UPDATE fbs_file SET fbspost2 = 'N' WHERE fbs01 = g_fbs.fbs01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd post2',STATUS,0)
         LET g_fbs.fbspost2='Y'
         LET g_success = 'N'
      END IF
   END IF
}
   CLOSE t120_cl
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
      LET g_fbs.fbspost2='N'
      LET g_fbs.fbspost='N'
      DISPLAY BY NAME g_fbs.fbspost2 # ATTRIBUTE(YELLOW)
   END IF
END FUNCTION
 
FUNCTION t120_e(p_cmd)        #維護稅簽資料
 DEFINE  p_cmd       LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(1)
 DEFINE  ls_tmp      STRING
 
   LET p_row = 10 LET p_col = 18
   OPEN WINDOW t120_e1 AT p_row,p_col
        WITH FORM "gfa/42f/gfat1201"  ATTRIBUTE (STYLE = g_win_style CLIPPED)                                               #No.FUN-580092 HCN
 
   CALL cl_ui_locale("gfat1201")
 
   IF p_cmd = 'u' THEN
      SELECT fbt11,fbt12,fbt13,fbt14
        INTO g_fbt_e[l_ac].fbt11,g_fbt_e[l_ac].fbt12,
             g_fbt_e[l_ac].fbt13,g_fbt_e[l_ac].fbt14
        FROM fbt_file
       WHERE fbt01 = g_fbs.fbs01
         AND fbt02 = g_fbt[l_ac].fbt02
      IF SQLCA.sqlcode THEN
         LET g_fbt_e[l_ac].fbt11 = 0   LET g_fbt_e[l_ac].fbt12 = 0
         LET g_fbt_e[l_ac].fbt13 = ''  LET g_fbt_e[l_ac].fbt14 = 0
      END IF
   END IF
   IF cl_null(g_fbt_e[l_ac].fbt11) THEN LET g_fbt_e[l_ac].fbt11 = 0 END IF
   IF cl_null(g_fbt_e[l_ac].fbt12) THEN LET g_fbt_e[l_ac].fbt12 = 0 END IF
   IF cl_null(g_fbt_e[l_ac].fbt14) THEN LET g_fbt_e[l_ac].fbt14 = 0 END IF
 
   IF g_fbt_e[l_ac].fbt14 = 0 THEN
      LET g_fbt_e[l_ac].fbt14 = g_fbt[l_ac].fbt07
   END IF
 
   INPUT g_fbt_e[l_ac].fbt11,g_fbt_e[l_ac].fbt12,
         g_fbt_e[l_ac].fbt13,g_fbt_e[l_ac].fbt14
         WITHOUT DEFAULTS FROM fbt11,fbt12,fbt13,fbt14
 
        AFTER FIELD fbt13
            IF cl_null(g_fbt_e[l_ac].fbt13) OR
               g_fbt_e[l_ac].fbt13 NOT MATCHES '[12]' THEN
               NEXT FIELD fbt13
            END IF
            LET g_fbt[l_ac].fbt06=g_fbt_e[l_ac].fbt13
        AFTER FIELD fbt14
            IF cl_null(g_fbt_e[l_ac].fbt14) THEN
               LET g_fbt_e[l_ac].fbt14 = 0
            END IF
            IF g_fbt_e[l_ac].fbt14 != 0 THEN
               #調增時, 不可超過未折減餘額
               IF g_fbt_e[l_ac].fbt13 = '1' AND
                  g_fbt_e[l_ac].fbt14 > g_fbt_e[l_ac].fbt11 THEN
                  CALL cl_err(g_fbt_e[l_ac].fbt14,'afa-042',0) NEXT FIELD fbt14
               END IF
               #調減時, 不可超過已提列減值準備金額
               IF g_fbt_e[l_ac].fbt13 = '2' AND
                  g_fbt_e[l_ac].fbt14 > g_fbt_e[l_ac].fbt12 THEN
                  CALL cl_err(g_fbt_e[l_ac].fbt14,'afa-051',0) NEXT FIELD fbt14
               END IF
               LET g_fbt[l_ac].fbt07=g_fbt_e[l_ac].fbt14
            END IF
 
        ON ACTION CONTROLG CALL cl_cmdask()
#--NO.MOD-860078 start---
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
#--NO.MOD-860078 end------- 
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t120_e1 RETURN END IF
 
   UPDATE fbt_file SET fbt11 = g_fbt_e[l_ac].fbt11,
                       fbt12 = g_fbt_e[l_ac].fbt12,
                       fbt13 = g_fbt_e[l_ac].fbt13,
                       fbt14 = g_fbt_e[l_ac].fbt14
    WHERE fbt01 = g_fbs.fbs01 AND fbt02 = g_fbt[l_ac].fbt02
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err(g_fbs.fbs01,SQLCA.sqlcode,0)   #No.FUN-660146
      CALL cl_err3("upd","fbt_file",g_fbs.fbs01,g_fbt[l_ac].fbt02,SQLCA.sqlcode,"","",1)  #No.FUN-660146
   END IF
   CLOSE WINDOW t120_e1
END FUNCTION
 
#No.FUN-670060  --Begin
FUNCTION t120_gen_glcr(p_fbs,p_fah)
  DEFINE p_fbs     RECORD LIKE fbs_file.*
  DEFINE p_fah     RECORD LIKE fah_file.*
 
    IF cl_null(p_fah.fahgslp) THEN
       CALL cl_err(p_fbs.fbs01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    #No.FUN-680028 --begin
    IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 add
       CALL t120_gl(g_fbs.fbs01,g_fbs.fbs02,'0')
    END IF #FUN-C30313 add
    #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN #FUN-C30313 mark
    IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN #FUN-C30313 add
       IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN #FUN-C30313 add
          CALL t120_gl(g_fbs.fbs01,g_fbs.fbs02,'1')
       END IF #FUN-C30313 add
    END IF
    #No.FUN-680028 --end
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t120_carry_voucher()
  DEFINE l_fahgslp    LIKE fah_file.fahgslp
  DEFINE li_result    LIKE type_file.num5     #NO.FUN-690009 SMALLINT 
  DEFINE l_dbs        STRING                                                                                                        
  DEFINE l_sql        STRING                                                                                                        
  DEFINE l_n          LIKE type_file.num5     #NO.FUN-690009 SMALLINT
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF NOT cl_null(g_fbs.fbs04)  THEN
       CALL cl_err(g_fbs.fbs04,'aap-618',1)
       RETURN
    END IF
   #FUN-B90004---End---
 
    CALL s_get_doc_no(g_fbs.fbs01) RETURNING g_t1
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
    IF g_fah.fahdmy3 = 'N' THEN RETURN END IF
   #IF g_fah.fahglcr = 'Y' THEN               #FUN-B90004
    IF g_fah.fahglcr = 'Y' OR ( g_fah.fahglcr = 'N' AND NOT cl_null(g_fah.fahgslp)) THEN   #FUN-B90004
       LET g_plant_new=g_faa.faa02p 
       #CALL s_getdbs()        #FUN-A50102 
       #LET l_dbs=g_dbs_new    #FUN-A50102 
       #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_faa.faa02b,"'",
                   "    AND aba01 = '",g_fbs.fbs04,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
       PREPARE aba_pre2 FROM l_sql
       DECLARE aba_cs2 CURSOR FOR aba_pre2
       OPEN aba_cs2
       FETCH aba_cs2 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_fbs.fbs04,'aap-991',1)
          RETURN
       END IF
 
       LET l_fahgslp = g_fah.fahgslp
    ELSE
      #CALL cl_err('','aap-992',1)   #FUN-B90004 mark
       CALL cl_err('','aap-936',1)   #FUN-B90004
       RETURN
       #開窗作業
#      LET g_plant_new= g_faa.faa02p
#      CALL s_getdbs()
#      LET g_dbs_gl=g_dbs_new      # 得資料庫名稱
 
#      OPEN WINDOW t200p AT 5,10 WITH FORM "axr/42f/axrt200_p" 
#           ATTRIBUTE (STYLE = g_win_style CLIPPED)
#      CALL cl_ui_locale("axrt200_p")
#       
#      INPUT l_fahgslp WITHOUT DEFAULTS FROM FORMONLY.gl_no
#   
#         AFTER FIELD gl_no
#            CALL s_check_no("agl",l_fahgslp,"","1","aac_file","aac01",g_dbs_gl) #No.FUN-560190
#                  RETURNING li_result,l_fahgslp
#            IF (NOT li_result) THEN
#               NEXT FIELD gl_no
#            END IF
#    
#         AFTER INPUT
#            IF INT_FLAG THEN
#               EXIT INPUT 
#            END IF
#            IF cl_null(l_fahgslp) THEN
#               CALL cl_err('','9033',0)
#               NEXT FIELD gl_no  
#            END IF
#   
#         ON ACTION CONTROLR
#            CALL cl_show_req_fields()
#         ON ACTION CONTROLG
#            CALL cl_cmdask()
#         ON ACTION CONTROLP
#            IF INFIELD(gl_no) THEN
#               CALL q_m_aac(FALSE,TRUE,g_dbs_gl,l_fahgslp,'1',' ',' ','AGL') 
#               RETURNING l_fahgslp
#               DISPLAY l_fahgslp TO FORMONLY.gl_no
#               NEXT FIELD gl_no
#            END IF
#   
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
#    
#         ON ACTION about         #MOD-4C0121
#            CALL cl_about()      #MOD-4C0121
#    
#         ON ACTION help          #MOD-4C0121
#            CALL cl_show_help()  #MOD-4C0121
#    
#         ON ACTION exit  #加離開功能genero
#            LET INT_FLAG = 1
#            EXIT INPUT
 
#      END INPUT
#      CLOSE WINDOW t200p  
    END IF
    IF cl_null(l_fahgslp) THEN
       CALL cl_err(g_fbs.fbs01,'axr-070',1)
       RETURN
    END IF
    #No.FUN-680028--begin
    IF g_aza.aza63 = 'Y' AND cl_null(g_fah.fahgslp1) THEN
       CALL cl_err(g_fbs.fbs01,'axr-070',1)
       RETURN
    END IF
    #No.FUN-680028--end  
    LET g_wc_gl = 'npp01 = "',g_fbs.fbs01,'" AND npp011 = 1'
#   LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_fbs.fbs02,"' 'Y' '0' 'Y'"  #No.FUN-680028
    LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_fbs.fbs02,"' 'Y' '0' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"  #No.FUN-680028
    CALL cl_cmdrun_wait(g_str)
    SELECT fbs04,fbs05 INTO g_fbs.fbs04,g_fbs.fbs05 FROM fbs_file
     WHERE fbs01 = g_fbs.fbs01
    DISPLAY BY NAME g_fbs.fbs04
    DISPLAY BY NAME g_fbs.fbs05
    
END FUNCTION
 
FUNCTION t120_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF cl_null(g_fbs.fbs04)  THEN
       CALL cl_err(g_fbs.fbs04,'aap-619',1)
       RETURN
    END IF
   #FUN-B90004---End---
 
    CALL s_get_doc_no(g_fbs.fbs01) RETURNING g_t1
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
   #IF g_fah.fahglcr = 'N' THEN          #FUN-B90004
   #   CALL cl_err('','aap-990',1)       #FUN-B90004
    IF g_fah.fahglcr = 'N' AND cl_null(g_fah.fahgslp) THEN    #FUN-B90004
       CALL cl_err('','aap-936',1)  #FUN-B90004
       RETURN
    END IF
 
    LET g_plant_new=g_faa.faa02p 
    #CALL s_getdbs()      #FUN-A50102
    #LET l_dbs=g_dbs_new  #FUN-A50102
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_faa.faa02b,"'",
                "    AND aba01 = '",g_fbs.fbs04,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_fbs.fbs04,'axr-071',1)
       RETURN
    END IF
 
    LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fbs.fbs04,"' '13' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT fbs04,fbs05 INTO g_fbs.fbs04,g_fbs.fbs05 FROM fbs_file
     WHERE fbs01 = g_fbs.fbs01
    DISPLAY BY NAME g_fbs.fbs04
    DISPLAY BY NAME g_fbs.fbs05
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t120_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_fbs.fbs01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fbs_file ",
                  "  WHERE fbs01 LIKE '",l_slip,"%' ",
                  "    AND fbs01 > '",g_fbs.fbs01,"'"
      PREPARE t120_pb1 FROM l_sql 
      EXECUTE t120_pb1 INTO l_cnt
      
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
         #CALL t120_x() #FUN-D20035 mark
         CALL t120_x(1) #FUN-D20035 add
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 13
                                AND npp01 = g_fbs.fbs01
                                AND npp011= 1
         DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 13
                                AND npq01 = g_fbs.fbs01
                                AND npq011= 1

         DELETE FROM tic_file WHERE tic04 = g_fbs.fbs01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM  fbs_file WHERE fbs01 = g_fbs.fbs01
         INITIALIZE g_fbs.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
# No.TQC-740305 ---begin
#FUNCTION t120_delall()
#
#   SELECT COUNT(*) INTO g_cnt FROM fbt_file
#    WHERE fbt01 = g_fbs.fbs01
#
#   IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM fbs_file WHERE fbs01 = g_fbs.fbs01
#   END IF
#
#END FUNCTION
# No.TQC-740305 ---end
#No.FUN-670060  --End  
#CHI-C30002 -------- mark -------- end

#FUN-AB0088---add---str---------
FUNCTION t120_fin_audit2()
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_rec_b2   LIKE type_file.num5
   DEFINE l_faj332   LIKE faj_file.faj332
   DEFINE l_faj3312  LIKE faj_file.faj3312
   DEFINE l_faj1012  LIKE faj_file.faj1012

   OPEN WINDOW t1209_w2 WITH FORM "gfa/42f/gfat1209"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("gfat1209")

   #FUN-BC0004--mark--str
   #LET g_sql =
   #  "SELECT fbt02,fbt03,fbt031,faj06,faj18,fbt042,fbt052,fbt06,fbt072,fbt08,fbt09 ",
   #    "  FROM fbt_file, OUTER faj_file ",
   #    " WHERE fbt01  ='",g_fbs.fbs01,"'",    #單頭 
   #    "   AND fbt03  = faj02",
   #    "   AND fbt031 = faj022",
   #    " ORDER BY fbt02 "
   #FUN-BC0004--mark--end
   #FUN-BC0004--add--str
   LET g_sql =
      "SELECT fbt02,fbt03,fbt031,'','',fbt042,fbt052,fbt06,fbt072,fbt08,fbt09 ",
      "  FROM fbt_file ",
      " WHERE fbt01  ='",g_fbs.fbs01,"'",    #單頭
      " ORDER BY fbt02 "
   #FUN-BC0004--add--end

   PREPARE gfat120_2_pre FROM g_sql

   DECLARE gfat120_2_c CURSOR FOR gfat120_2_pre

   CALL g_fbt2.clear()

   LET l_cnt = 1

   FOREACH gfat120_2_c INTO g_fbt2[l_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach fbt2',STATUS,0)
         EXIT FOREACH
      END IF

      #FUN-BC0004--add--str
      SELECT faj06,faj18 INTO g_fbt2[l_cnt].faj06,g_fbt2[l_cnt].faj18
        FROM faj_file
       WHERE faj02 = g_fbt2[l_cnt].fbt03
         AND faj022 = g_fbt2[l_cnt].fbt031
      #FUN-BC0004--add--end
      LET l_cnt = l_cnt + 1

   END FOREACH

   CALL g_fbt2.deleteElement(l_cnt)

   LET l_rec_b2 = l_cnt - 1

   LET l_ac = 1

   CALL cl_set_act_visible("cancel", FALSE)

   IF g_fbs.fbsconf !="N" THEN   #已確認或作廢單據只能查詢 
      DISPLAY ARRAY g_fbt2 TO s_fbt2.* ATTRIBUTE(COUNT=l_rec_b2,UNBUFFERED)

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
      LET g_forupd_sql="SELECT fbt02,fbt03,fbt031,'','',fbt042,fbt052,fbt06,",
                       "       fbt072,fbt08,fbt09 ",
                       "  FROM fbt_file ",
                       " WHERE fbt01 = ? AND fbt02 = ?   ",
                       "   FOR UPDATE      "
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE t120_2_bcl CURSOR FROM g_forupd_sql 
       
      INPUT ARRAY g_fbt2 WITHOUT DEFAULTS FROM s_fbt2.*
            ATTRIBUTE(COUNT=l_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
      
         BEFORE INPUT     
            CALL cl_set_comp_entry("fbt042,fbt052,fbt062",FALSE)
            IF l_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            
         BEFORE ROW            
            LET l_ac = ARR_CURR()
            BEGIN WORK
            IF l_rec_b2 >= l_ac THEN 
               LET g_fbt2_t.* = g_fbt2[l_ac].* 
               OPEN t120_2_bcl USING g_fbs.fbs01,g_fbt2_t.fbt02
               IF STATUS THEN
                  CALL cl_err("OPEN t120_2_bcl:", STATUS, 1)
               ELSE
                  FETCH t120_2_bcl INTO g_fbt2[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_fbt2_t.fbt02,SQLCA.sqlcode,1)
                  ELSE
                    ##-----No:FUN-BB0122-----
                     SELECT faj06,faj18
                       INTO g_fbt2[l_ac].faj06,g_fbt2[l_ac].faj18
                       FROM faj_file
                      WHERE faj02  =g_fbt2[l_ac].fbt03
                        AND faj022 =g_fbt2[l_ac].fbt031
                    # SELECT faj06,faj18,faj332,faj3312,faj1012 
                    #   INTO g_fbt2[l_ac].faj06,g_fbt2[l_ac].faj18,
                    #        l_faj332,l_faj3312,l_faj1012
                    #   FROM faj_file
                    #  WHERE faj02  =g_fbt2[l_ac].fbt03
                    #    AND faj022 =g_fbt2[l_ac].fbt031
                    #IF cl_null(g_fbt2[l_ac].fbt042) OR g_fbt2[l_ac].fbt042 = 0 THEN
                    #    LET g_fbt2[l_ac].fbt042 = l_faj332+l_faj3312  #未折減額  
                    #END IF
                    #IF cl_null(g_fbt2[l_ac].fbt052) OR g_fbt2[l_ac].fbt052 = 0 THEN
                    #    LET g_fbt2[l_ac].fbt052 = l_faj1012          #已提列減值準備金額
                    #END IF
					##-----No:FUN-BB0122 END-----
                  END IF
               END IF
            END IF
         
         
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fbt2[l_ac].* = g_fbt2_t.*
               CLOSE t120_2_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
       
           #CHI-C60010---str---
            CALL cl_digcut(g_fbt2[l_ac].fbt042,g_azi04_1) RETURNING g_fbt2[l_ac].fbt042
            CALL cl_digcut(g_fbt2[l_ac].fbt052,g_azi04_1) RETURNING g_fbt2[l_ac].fbt052
            CALL cl_digcut(g_fbt2[l_ac].fbt072,g_azi04_1) RETURNING g_fbt2[l_ac].fbt072
           #CHI-C60010---end--- 
            UPDATE fbt_file SET fbt042 = g_fbt2[l_ac].fbt042,
                                fbt052 = g_fbt2[l_ac].fbt052,
                                fbt062 = g_fbt2[l_ac].fbt062,
                                fbt072 = g_fbt2[l_ac].fbt072 
             WHERE fbt01 = g_fbs.fbs01
               AND fbt02 = g_fbt2_t.fbt02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","fbt_file",g_fbs.fbs01,g_fbt2_t.fbt02,SQLCA.sqlcode,"","",1)  
               LET g_fbt2[l_ac].* = g_fbt2_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF

        #FUN-BC0004--add-str
        BEFORE FIELD fbt072
           SELECT faj06,faj18,faj332,faj3312,faj1012 
             INTO g_fbt2[l_ac].faj06,g_fbt2[l_ac].faj18,
                  l_faj332,l_faj3312,l_faj1012
             FROM faj_file
            WHERE faj02  =g_fbt2[l_ac].fbt03
              AND faj022 =g_fbt2[l_ac].fbt031
           IF cl_null(g_fbt2[l_ac].fbt042) OR g_fbt2[l_ac].fbt042 = 0 THEN
              LET g_fbt2[l_ac].fbt042 = l_faj332+l_faj3312  #未折減額  
           END IF
           IF cl_null(g_fbt2[l_ac].fbt052) OR g_fbt2[l_ac].fbt052 = 0 THEN
              LET g_fbt2[l_ac].fbt052 = l_faj1012          #已提列減值準備金額
           END IF
           #CHI-C60010---str---
            CALL cl_digcut(g_fbt2[l_ac].fbt042,g_azi04_1) RETURNING g_fbt2[l_ac].fbt042
            CALL cl_digcut(g_fbt2[l_ac].fbt052,g_azi04_1) RETURNING g_fbt2[l_ac].fbt052
           #CHI-C60010---end---
           DISPLAY BY NAME g_fbt2[l_ac].fbt042
           DISPLAY BY NAME g_fbt2[l_ac].fbt052
        #FUN-BC0004--add-end
        AFTER FIELD fbt072
            CALL cl_digcut(g_fbt2[l_ac].fbt072,g_azi04_1) RETURNING g_fbt2[l_ac].fbt072 #CHI-C60010
            IF cl_null(g_fbt2[l_ac].fbt072) THEN LET g_fbt2[l_ac].fbt072 = 0 END IF
            IF g_fbt2[l_ac].fbt072 != 0 THEN
               #調增時：不可以大於已提列減值金額 
                IF g_fbt2[l_ac].fbt062 = '1' THEN
                   IF g_fbt2[l_ac].fbt072 > g_fbt2[l_ac].fbt052 THEN
                      CALL cl_err('','afa-042',0)
                      NEXT FIELD fbt072
                   END IF
                END IF
               #調減時：不可以大於[未折減餘額 - 已提列減值準備值]
                IF g_fbt2[l_ac].fbt062 = '2' THEN
                   IF g_fbt2[l_ac].fbt072 >
                      g_fbt2[l_ac].fbt042-g_fbt2[l_ac].fbt052 THEN
                      CALL cl_err('','afa-051',0)
                      NEXT FIELD fbt072
                   END IF
                END IF
            END IF

      
         AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fbt2[l_ac].* = g_fbt2_t.*
               CLOSE t120_2_bcl 
               ROLLBACK WORK 
               EXIT INPUT
            END IF
            CLOSE t120_2_bcl 
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
 
   CLOSE WINDOW t1209_w2

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

END FUNCTION
#FUN-AB0088---add---str--------- 

#FUN-B60140   ---start   Add
FUNCTION t120_s2()
   DEFINE l_fbt       RECORD LIKE fbt_file.*,
          l_faj       RECORD LIKE faj_file.*,
          l_flag      LIKE type_file.chr1,
          l_fbt07_1   LIKE fbt_file.fbt07,
          l_fbt07_2   LIKE fbt_file.fbt07,
          m_chr       LIKE type_file.chr1,
          l_bdate,l_edate  LIKE type_file.dat
   DEFINE l_fbt072_1  LIKE fbt_file.fbt072
   DEFINE l_fbt072_2  LIKE fbt_file.fbt072
   DEFINE l_cnt       LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF

   IF g_faa.faa31 = "N" THEN RETURN END IF

   IF g_fbs.fbs01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fbs.* FROM fbs_file WHERE fbs01 = g_fbs.fbs01
   IF g_fbs.fbsconf != 'Y' OR g_fbs.fbspost1!= 'N' THEN
      CALL cl_err(g_fbs.fbs01,'afa-100',0) RETURN
   END IF

   #-->立帳日期小於關帳日期
   IF g_fbs.fbs02 < g_faa.faa092 THEN
      CALL cl_err(g_fbs.fbs01,'aap-176',1) RETURN
   END IF

   #--->折舊年月判斷
   CALL s_get_bookno(g_faa.faa07) RETURNING g_flag,g_bookno1,g_bookno2
   #固資己不和二套掛勾，所以原本利用s_get_bookno取到帳別一及帳別二是用是否使用二套帳來判斷
   #此處取帳別二要重新處理，應取固資參數欄位財二帳套faa02c做為帳別二的帳套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF

   CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate

   IF g_fbs.fbs02 < l_bdate OR g_fbs.fbs02 > l_edate THEN
      CALL cl_err(g_fbs.fbs02,'afa-308',0) RETURN
   END IF

   IF NOT cl_sure(18,20) THEN RETURN END IF

   BEGIN WORK

   LET g_success = 'Y'
   OPEN t120_cl USING g_fbs.fbs01
   IF STATUS THEN
      CALL cl_err("OPEN t120_cl:", STATUS, 1)
      CLOSE t120_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t120_cl INTO g_fbs.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
         CALL cl_err(g_fbs.fbs01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t120_cl ROLLBACK WORK RETURN
   END IF
   DECLARE t120_cur22 CURSOR FOR
      SELECT * FROM fbt_file,faj_file
       WHERE fbt01 = g_fbs.fbs01 AND faj02 = fbt03 AND faj022 = fbt031
   IF STATUS THEN
      CALL cl_err('sel faj',STATUS,0) LET g_success = 'N'
   END IF

   UPDATE fbs_file SET fbspost1= 'Y' WHERE fbs01 = g_fbs.fbs01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","fbs_file",g_fbs.fbs01,"",STATUS,"","upd post1",1)
      LET g_success = 'N'
   END IF

   FOREACH t120_cur22 INTO l_fbt.*,l_faj.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      IF cl_null(l_faj.faj101) THEN LET l_faj.faj101 = 0 END IF
      IF cl_null(l_fbt.fbt07)  THEN LET l_fbt.fbt07  = 0 END IF
      IF cl_null(l_fbt.fbt072) THEN LET l_fbt.fbt072 = 0 END IF
      IF cl_null(l_faj.faj1012) THEN LET l_faj.faj1012 = 0 END IF

      SELECT SUM(fbt072) INTO l_fbt072_1 FROM fbt_file,fbs_file
       WHERE fbt03 = l_faj.faj02 AND fbt031 = l_faj.faj022
         AND fbt062 = '1' AND fbs01 = fbt01
         AND fbspost1= 'Y' AND fbsconf = 'Y'
      IF cl_null(l_fbt072_1) THEN LET l_fbt072_1 = 0 END IF
      SELECT SUM(fbt072) INTO l_fbt072_2 FROM fbt_file,fbs_file
       WHERE fbt03 = l_faj.faj02 AND fbt031 = l_faj.faj022
         AND fbt062 = '2' AND fbs01 = fbt01
         AND fbspost1= 'Y' AND fbsconf = 'Y'
      IF cl_null(l_fbt072_2) THEN LET l_fbt072_2 = 0 END IF
      LET l_faj.faj1012 = l_fbt072_2 - l_fbt072_1

      IF cl_null(l_fbt.fbt031) THEN
         LET l_fbt.fbt031 = ' '
      END IF

     #CHI-C60010---str---
      CALL cl_digcut(l_faj.faj1012,g_azi04_1) RETURNING l_faj.faj1012
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj3312,g_azi04_1) RETURNING l_faj.faj3312
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_fbt.fbt072,g_azi04_1) RETURNING l_fbt.fbt072
     #CHI-C60010---end---
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fap_file
       WHERE fap50  = l_fbt.fbt01
         AND fap501 = l_fbt.fbt02
         AND fap03  = 'E'              ## 異動代號
      IF l_cnt = 0 THEN   #無fap_file資料
         INSERT INTO fap_file(fap01,fap02,fap021,fap03,
                              fap04,fap05,fap06,fap07,
                              fap08,fap09,fap10,fap101,
                              fap11,fap12,fap13,fap14,
                              fap15,fap16,fap17,fap18,
                              fap19,fap20,fap201,fap21,
                              fap22,fap23,fap24,fap25,
                              fap26,fap50,fap501,fap661,
                              fap55,fap52,fap53,fap54,
                              fap80,fap41,
                              fap121,fap131,fap141,
                              fap052,fap062,fap072,fap082,
                              fap092,
                              fap1012,fap112,
                              fap152,fap162,
                              fap212,fap222,fap232,fap242,
                              fap252,fap262,fap522,fap532,
                              fap542,
                              fap552,fap6612,fap802,
                              fap103,fap512,fap562,fap572,
                              fap612,fap772,faplegal)
         VALUES(l_faj.faj01,l_fbt.fbt03,l_fbt.fbt031,'E',
                g_fbs.fbs02,l_faj.faj43,l_faj.faj28, l_faj.faj30,
                l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33+l_faj.faj331,
                l_faj.faj32,l_faj.faj53,l_faj.faj54, l_faj.faj55,
                l_faj.faj23,l_faj.faj24,l_faj.faj20, l_faj.faj19,
                l_faj.faj21,l_faj.faj17,l_faj.faj171,l_faj.faj58,
                l_faj.faj59,l_faj.faj60,l_faj.faj34, l_faj.faj35,
                l_faj.faj36,l_fbt.fbt01,l_fbt.fbt02, l_faj.faj14,
                l_faj.faj32,l_faj.faj30,l_faj.faj31, l_fbt.fbt07,
                l_faj.faj101,l_faj.faj100,
                l_faj.faj531,l_faj.faj541,l_faj.faj551,
                l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,
                l_faj.faj142,
                l_faj.faj332+l_faj.faj3312,l_faj.faj322,
                l_faj.faj232,l_faj.faj242,
                l_faj.faj582,l_faj.faj592,l_faj.faj602,l_faj.faj342,
                l_faj.faj352,l_faj.faj362,l_faj.faj302,l_faj.faj312,
                l_fbt.fbt072,
                l_faj.faj322,l_faj.faj142,l_faj.faj1012,
                l_faj.faj1412,l_faj.faj282,l_faj.faj592,l_faj.faj602,
                l_faj.faj232,l_faj.faj432,g_legal)
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
                             fap522 = l_faj.faj302,
                             fap532 = l_faj.faj312,
                             fap542 = l_fbt.fbt072,
                             fap552 = l_faj.faj322,
                             fap6612= l_faj.faj142,
                             fap802 = l_faj.faj1012,
                             fap512 = l_faj.faj282,
                             fap562 = l_faj.faj592,
                             fap572 = l_faj.faj602,
                             fap612 = l_faj.faj232,
                             fap772 = l_faj.faj432
                       WHERE fap50  = l_fbt.fbt01
                         AND fap501 = l_fbt.fbt02
                         AND fap03  = 'E'              ## 異動代號
      END IF
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         CALL cl_err3("ins","fap_file",l_fbt.fbt03,l_fbt.fbt031,STATUS,"","ins fap",1)
         LET g_success = 'N'
      END IF

      #--------- 過帳(3)update faj_file
      UPDATE faj_file SET faj100 = g_fbs.fbs02,    #最近異動日期
                          faj1012= l_faj.faj1012
       WHERE faj02=l_fbt.fbt03 AND faj022=l_fbt.fbt031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         CALL cl_err3("upd","faj_file",l_fbt.fbt03,l_fbt.fbt031,STATUS,"","upd faj",1)
         LET g_success = 'N'
      END IF
   END FOREACH

   CLOSE t120_cl
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
      LET g_fbs.fbspost1='Y'
      DISPLAY BY NAME g_fbs.fbspost1
   END IF

   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_fbs.fbs01,'" AND npp011 = 1'
      LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_faa.faa02p,"' 
                '",g_faa.faa02b,"' '",g_fah.fahgslp,"' '",g_fbs.fbs02,"' 'Y' '0' 'Y' 
                '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"
      CALL cl_cmdrun_wait(g_str)
      SELECT fbs042,fbs052 INTO g_fbs.fbs042,g_fbs.fbs052 FROM fbs_file
       WHERE fbs01 = g_fbs.fbs01
      DISPLAY BY NAME g_fbs.fbs042
      DISPLAY BY NAME g_fbs.fbs052
   END IF

END FUNCTION

FUNCTION t120_w2()
   DEFINE l_fbt      RECORD LIKE fbt_file.*,
          l_faj      RECORD LIKE faj_file.*,
          l_fap      RECORD LIKE fap_file.*,
          l_fap41    LIKE fap_file.fap41,
          l_fap54    LIKE fap_file.fap54,
          l_bdate,l_edate  LIKE type_file.dat,
          l_fbt07_1  LIKE fbt_file.fbt07,
          l_fbt07_2  LIKE fbt_file.fbt07
   DEFINE l_fbt072_1 LIKE fbt_file.fbt072
   DEFINE l_fbt072_2 LIKE fbt_file.fbt072

   IF s_shut(0) THEN RETURN END IF

   IF g_faa.faa31 = "N" THEN RETURN END IF

   IF g_fbs.fbs01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fbs.* FROM fbs_file WHERE fbs01 = g_fbs.fbs01

   IF g_fbs.fbspost1!= 'Y' THEN
      CALL cl_err(g_fbs.fbs01,'afa-108',0) RETURN
   END IF

   #-->已拋轉總帳, 不可取消確認
   IF NOT cl_null(g_fbs.fbs042) AND g_fah.fahglcr != 'Y' THEN
      CALL cl_err(g_fbs.fbs042,'aap-145',1) RETURN
   END IF

      #-->立帳日期小於關帳日期
   IF g_fbs.fbs02 < g_faa.faa092 THEN
      CALL cl_err(g_fbs.fbs01,'aap-176',1) RETURN
   END IF

   #--->折舊年月判斷
   CALL s_get_bookno(g_faa.faa072) RETURNING g_flag,g_bookno1,g_bookno2

   CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate

   IF g_fbs.fbs02 < l_bdate OR g_fbs.fbs02 > l_edate THEN
      CALL cl_err(g_fbs.fbs02,'afa-308',0) RETURN
   END IF

   IF NOT cl_sure(18,20) THEN RETURN END IF
  #------------------------------CHI-C90051----------------------------(S)
   IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN
      LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fbs.fbs042,"' '13' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT fbs042,fbs052 INTO g_fbs.fbs042,g_fbs.fbs052 FROM fbs_file
       WHERE fbs01 = g_fbs.fbs01
      DISPLAY BY NAME g_fbs.fbs042
      DISPLAY BY NAME g_fbs.fbs052
      IF NOT cl_null(g_fbs.fbs042) THEN
         CALL cl_err('','aap-929',0)
         RETURN
      END IF
   END IF
  #------------------------------CHI-C90051----------------------------(E)

   BEGIN WORK

   LET g_success = 'Y'

   OPEN t120_cl USING g_fbs.fbs01
   IF STATUS THEN
      CALL cl_err("OPEN t120_cl:", STATUS, 1)
      CLOSE t120_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t120_cl INTO g_fbs.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fbs.fbs01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t120_cl ROLLBACK WORK RETURN
   END IF

   DECLARE t120_cur32 CURSOR FOR
      SELECT * FROM fbt_file,faj_file
       WHERE fbt01 = g_fbs.fbs01 AND faj02 = fbt03 AND faj022 = fbt031

   IF STATUS THEN
      CALL cl_err('t120_cur3',STATUS,0) LET g_success = 'N'
   END IF

   UPDATE fbs_file SET fbspost1 = 'N' WHERE fbs01 = g_fbs.fbs01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","fbs_file",g_fbs.fbs01,"",STATUS,"","upd post1",1)
      LET g_success = 'N'
      LET g_fbs.fbspost1='Y'
   END IF

   FOREACH t120_cur32 INTO l_fbt.*,l_faj.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         LET g_success = 'N' EXIT FOREACH
      END IF
      #----- 找出 fap_file 以便 update faj_file
      SELECT fap41,fap54 INTO l_fap41,l_fap54
        FROM fap_file
       WHERE fap50=l_fbt.fbt01 AND fap501=l_fbt.fbt02 AND fap03='E'
      IF STATUS THEN
         CALL cl_err3("sel","fap_file",l_fbt.fbt01,l_fbt.fbt02,STATUS,"","sel fap",1)
         LET g_success = 'N'
      END IF
      IF cl_null(l_faj.faj101) THEN LET l_faj.faj101 = 0 END IF
      IF cl_null(l_faj.faj1012) THEN LET l_faj.faj1012 = 0 END IF
      IF cl_null(l_fap54) THEN LET l_fap54 = 0 END IF

      SELECT SUM(fbt072) INTO l_fbt072_1 FROM fbt_file,fbs_file
       WHERE fbt03 = l_faj.faj02 AND fbt031 = l_faj.faj022
         AND fbt062 = '1' AND fbs01 = fbt01
         AND fbspost1 = 'Y' AND fbsconf = 'Y'
      IF cl_null(l_fbt072_1) THEN LET l_fbt072_1 = 0 END IF

      SELECT SUM(fbt072) INTO l_fbt072_2 FROM fbt_file,fbs_file
       WHERE fbt03 = l_faj.faj02 AND fbt031 = l_faj.faj022
         AND fbt062 = '2' AND fbs01 = fbt01
         AND fbspost1 = 'Y' AND fbsconf = 'Y'
      IF cl_null(l_fbt072_2) THEN LET l_fbt072_2 = 0 END IF
      LET l_faj.faj1012 = l_fbt072_1 - l_fbt072_2

      UPDATE faj_file SET faj100 = l_fap41,
                          faj1012 = l_faj.faj1012
       WHERE faj02=l_fbt.fbt03 AND faj022=l_fbt.fbt031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         CALL cl_err3("upd","faj_file",l_fbt.fbt03,l_fbt.fbt031,STATUS,"","upd faj",1)
         LET g_success = 'N'
      END IF

      #財一與稅簽皆未過帳時，才可刪fap_file
      IF g_fbs.fbspost <>'Y' AND g_fbs.fbspost2<>'Y' THEN
         #--------- 還原過帳(3)delete fap_file
         DELETE FROM fap_file WHERE fap50 =l_fbt.fbt01
                                AND fap501=l_fbt.fbt02
                                AND fap03 = 'E'
         IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
            CALL cl_err3("del","fap_file",l_fbt.fbt01,l_fbt.fbt02,STATUS,"","del fap",1)
            LET g_success = 'N'
         END IF
      END IF
   END FOREACH

   CLOSE t120_cl
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
      LET g_fbs.fbspost1='N'
      DISPLAY BY NAME g_fbs.fbspost1
   END IF

  #------------------------------CHI-C90051----------------------------mark
  ##IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN #FUN-C30313 mark 
  #IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' AND g_success = 'Y' THEN #FUN-C30313 add   
  #   LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fbs.fbs042,"' '13' 'Y'"
  #   CALL cl_cmdrun_wait(g_str)
  #   SELECT fbs042,fbs052 INTO g_fbs.fbs042,g_fbs.fbs052 FROM fbs_file
  #    WHERE fbs01 = g_fbs.fbs01
  #   DISPLAY BY NAME g_fbs.fbs042
  #   DISPLAY BY NAME g_fbs.fbs052
  #END IF
  #------------------------------CHI-C90051----------------------------mark

END FUNCTION

FUNCTION t120_carry_voucher2()
   DEFINE l_fahgslp    LIKE fah_file.fahgslp
   DEFINE li_result    LIKE type_file.num5
   DEFINE l_dbs        STRING
   DEFINE l_sql        STRING
   DEFINE l_n          LIKE type_file.num5

   IF g_faa.faa31 = "N" THEN RETURN END IF

   IF NOT cl_confirm('aap-989') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF NOT cl_null(g_fbs.fbs042)  THEN
       CALL cl_err(g_fbs.fbs042,'aap-618',1)
       RETURN
    END IF
   #FUN-B90004---End---

   CALL s_get_doc_no(g_fbs.fbs01) RETURNING g_t1
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1

   #IF g_fah.fahdmy3 = 'N' THEN RETURN END IF #FUN-C30313 mark
   IF g_fah.fahdmy32 = 'N' THEN RETURN END IF #FUN-C30313 add

  #IF g_fah.fahglcr = 'Y' THEN     #FUN-B90004
   IF g_fah.fahglcr = 'Y' OR ( g_fah.fahglcr = 'N' AND NOT cl_null(g_fah.fahgslp1)) THEN   #FUN-B90004
      LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
      LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
                  "  WHERE aba00 = '",g_faa.faa02c,"'",
                  "    AND aba01 = '",g_fbs.fbs042,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE aba_pre22 FROM l_sql
      DECLARE aba_cs22 CURSOR FOR aba_pre22
      OPEN aba_cs22
      FETCH aba_cs22 INTO l_n
      IF l_n > 0 THEN
         CALL cl_err(g_fbs.fbs042,'aap-991',1)
         RETURN
      END IF

      LET l_fahgslp = g_fah.fahgslp
   ELSE
     #CALL cl_err('','aap-992',1)   #FUN-B90004 mark
      CALL cl_err('','aap-936',1)   #FUN-B90004
      RETURN
   END IF

   IF cl_null(g_fah.fahgslp1) THEN
      CALL cl_err(g_fbs.fbs01,'axr-070',1)
      RETURN
   END IF

   LET g_wc_gl = 'npp01 = "',g_fbs.fbs01,'" AND npp011 = 1'
   LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' 
             '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_fbs.fbs02,"' 
             'Y' '0' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"
   CALL cl_cmdrun_wait(g_str)
   SELECT fbs042,fbs052 INTO g_fbs.fbs042,g_fbs.fbs052 FROM fbs_file
    WHERE fbs01 = g_fbs.fbs01
   DISPLAY BY NAME g_fbs.fbs042
   DISPLAY BY NAME g_fbs.fbs052

END FUNCTION

FUNCTION t120_undo_carry_voucher2()
   DEFINE l_aba19    LIKE aba_file.aba19
   DEFINE l_sql      LIKE type_file.chr1000
   DEFINE l_dbs      STRING

   IF g_faa.faa31 = "N" THEN RETURN END IF

   IF NOT cl_confirm('aap-988') THEN RETURN END IF

   #FUN-B90004--Begin--
    IF cl_null(g_fbs.fbs042)  THEN
       CALL cl_err(g_fbs.fbs042,'aap-619',1)
       RETURN
    END IF
   #FUN-B90004---End---

   CALL s_get_doc_no(g_fbs.fbs01) RETURNING g_t1
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
  #IF g_fah.fahglcr = 'N' THEN     #FUN-B90004
  #   CALL cl_err('','aap-990',1)  #FUN-B90004
   IF g_fah.fahglcr = 'N' AND cl_null(g_fah.fahgslp1) THEN    #FUN-B90004
      CALL cl_err('','aap-936',1)  #FUN-B90004
      RETURN
   END IF

   LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
   LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
               "  WHERE aba00 = '",g_faa.faa02c,"'",
               "    AND aba01 = '",g_fbs.fbs042,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   PREPARE aba_pre23 FROM l_sql
   DECLARE aba_cs23 CURSOR FOR aba_pre23
   OPEN aba_cs23
   FETCH aba_cs23 INTO l_aba19
   IF l_aba19 = 'Y' THEN
      CALL cl_err(g_fbs.fbs042,'axr-071',1)
      RETURN
   END IF

   LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fbs.fbs042,"' '13' 'Y'"
   CALL cl_cmdrun_wait(g_str)
   SELECT fbs042,fbs052 INTO g_fbs.fbs042,g_fbs.fbs052 FROM fbs_file
    WHERE fbs01 = g_fbs.fbs01
   DISPLAY BY NAME g_fbs.fbs042
   DISPLAY BY NAME g_fbs.fbs052

END FUNCTION
#FUN-B60140   ---end     Add
#NO.FUN-B80025



