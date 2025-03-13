# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: armt200.4gl
# Descriptions...: RMA覆出單維護作業
# Date & Author..: 98/03/16 By alen
# MODI           : 98/04/01 by plum
# Modify.........: No.FUN-4B0035 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4B0058 04/11/24 By Mandy 匯率加開窗功能
# Modify.........: No.FUN-4C0055 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-4C0085 04/12/16 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.FUN-550064 05/05/30 By Trisy 單據編號加大
# Modify.........: No.TQC-630066 06/03/07 By Kevin 流程訊息通知功能修改
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.MOD-650086 06/05/19 By Pengu 做確認的動作時,應該要卡 armt160 覆出單未確認的單據.
# Modify.........: No.TQC-660046 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-650142 06/06/28 By Sarah 未稅金額、稅額、含稅金額計算公式應參考稅別的設定,包括含稅及不含稅
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-660212 06/08/29 By Sarah g_tot沒有初始值
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/30 By dxfwo ?位?型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6A0018 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740129 07/04/19 By sherry  沒有結案時選擇取消結案按鈕，無報錯提示信息。
#       ............................................ 對已扣帳信息進行扣帳，報錯信息有誤“扣帳后不能結案”，是可以結案的。
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760026 07/06/05 By rainy   未結案的單據要修改時卻出現已結案的訊息
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/24 By TSD.Wind 自定功能欄位修改
# Modify.........: No.MOD-840662 08/04/28 By claire 依BDL版,單身無新增功能
# Modify.........: No.CHI-840072 08/04/30 By claire 依TQC-6C0213(modify armp130) rme19仍為原幣,不*匯率
# Modify.........: No.MOD-950152 09/05/27 By Smapmin 抓取材料成本時,先抓取最接近單據日的ccc23,若無再抓取最接近單據日的cca23
#                                                    開放原幣應收未稅金額可修改
# Modify.........: No.MOD-970013 09/07/06 By Smapmin rme22/rme08應秀出帳款上的發票資訊
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0203 /10/01/04 By lilingyu 單頭"稅前金額",單身"金額成本應收"等字段未控管負數
# Modify.........: No:TQC-A10026 10/01/07 By Carrier 汇率非负控管
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No:MOD-AA0009 10/10/04 By sabrina 已產生應收帳款時，不可以取消確認
# Modify.........: No:CHI-AB0009 10/11/12 By Summer 計算單頭的應收(rme18)跟單身的應收(rmf17)應該都要用rme30來計算
# Modify.........: No.FUN-A10132 11/04/20 By wuxj   複出單號，RMA單號新增開窗
# Modify.........: No.CHI-B60093 11/06/30 By Vampire 依 ccz28 成本計算類別取得平均成本
# Modify.........: No.MOD-BC0001 11/12/01 By ck2yuan rmf14取為應為t_azi04作取位而非g_rme.rme16
# Modify.........: No.FUN-910088 11/12/22 By chenjing 增加數量欄位小數取位
# Modify.........: No.CHI-BC0035 12/02/03 By ck2yuan 覆出日期應為rme021,故將rme02改成rme021
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.MOD-B90261 12/08/09 By ck2yuan 金額應用t_azi04做取位而非g_azi04

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_rme   RECORD LIKE rme_file.*,
    g_rme_t RECORD LIKE rme_file.*,
    g_rme_o RECORD LIKE rme_file.*,
    l_oap           RECORD LIKE oap_file.*,
    b_rmf   RECORD LIKE rmf_file.*,
    g_rmf           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    rmf02     LIKE rmf_file.rmf02,
                    rmf03     LIKE rmf_file.rmf03,
                    rmf06     LIKE rmf_file.rmf06,
                    rmf061    LIKE rmf_file.rmf061,
                    rmf04     LIKE rmf_file.rmf04,
                    rmf21     LIKE rmf_file.rmf21,
                    rmf12     LIKE rmf_file.rmf12,
                    rmf13     LIKE rmf_file.rmf13,
                    rmf14     LIKE rmf_file.rmf14,
                    rmf16     LIKE rmf_file.rmf16,
                    rmf17     LIKE rmf_file.rmf17,
                    rmf31     LIKE rmf_file.rmf31,
                    rmf33     LIKE rmf_file.rmf33,
                    rmf25     LIKE rmf_file.rmf25,
                    #FUN-840068 --start---
                    rmfud01   LIKE rmf_file.rmfud01,
                    rmfud02   LIKE rmf_file.rmfud02,
                    rmfud03   LIKE rmf_file.rmfud03,
                    rmfud04   LIKE rmf_file.rmfud04,
                    rmfud05   LIKE rmf_file.rmfud05,
                    rmfud06   LIKE rmf_file.rmfud06,
                    rmfud07   LIKE rmf_file.rmfud07,
                    rmfud08   LIKE rmf_file.rmfud08,
                    rmfud09   LIKE rmf_file.rmfud09,
                    rmfud10   LIKE rmf_file.rmfud10,
                    rmfud11   LIKE rmf_file.rmfud11,
                    rmfud12   LIKE rmf_file.rmfud12,
                    rmfud13   LIKE rmf_file.rmfud13,
                    rmfud14   LIKE rmf_file.rmfud14,
                    rmfud15   LIKE rmf_file.rmfud15
                    #FUN-840068 --end--
                    END RECORD,
    g_rmf_t         RECORD
                    rmf02     LIKE rmf_file.rmf02,
                    rmf03     LIKE rmf_file.rmf03,
                    rmf06     LIKE rmf_file.rmf06,
                    rmf061    LIKE rmf_file.rmf061,
                    rmf04     LIKE rmf_file.rmf04,
                    rmf21     LIKE rmf_file.rmf21,
                    rmf12     LIKE rmf_file.rmf12,
                    rmf13     LIKE rmf_file.rmf13,
                    rmf14     LIKE rmf_file.rmf14,
                    rmf16     LIKE rmf_file.rmf16,
                    rmf17     LIKE rmf_file.rmf17,
                    rmf31     LIKE rmf_file.rmf31,
                    rmf33     LIKE rmf_file.rmf33,
                    rmf25     LIKE rmf_file.rmf25,
                    #FUN-840068 --start---
                    rmfud01   LIKE rmf_file.rmfud01,
                    rmfud02   LIKE rmf_file.rmfud02,
                    rmfud03   LIKE rmf_file.rmfud03,
                    rmfud04   LIKE rmf_file.rmfud04,
                    rmfud05   LIKE rmf_file.rmfud05,
                    rmfud06   LIKE rmf_file.rmfud06,
                    rmfud07   LIKE rmf_file.rmfud07,
                    rmfud08   LIKE rmf_file.rmfud08,
                    rmfud09   LIKE rmf_file.rmfud09,
                    rmfud10   LIKE rmf_file.rmfud10,
                    rmfud11   LIKE rmf_file.rmfud11,
                    rmfud12   LIKE rmf_file.rmfud12,
                    rmfud13   LIKE rmf_file.rmfud13,
                    rmfud14   LIKE rmf_file.rmfud14,
                    rmfud15   LIKE rmf_file.rmfud15
                    #FUN-840068 --end--
                    END RECORD,
    g_rmf_o         RECORD
                    rmf02     LIKE rmf_file.rmf02,
                    rmf03     LIKE rmf_file.rmf03,
                    rmf06     LIKE rmf_file.rmf06,
                    rmf061    LIKE rmf_file.rmf061,
                    rmf04     LIKE rmf_file.rmf04,
                    rmf21     LIKE rmf_file.rmf21,
                    rmf12     LIKE rmf_file.rmf12,
                    rmf13     LIKE rmf_file.rmf13,
                    rmf14     LIKE rmf_file.rmf14,
                    rmf16     LIKE rmf_file.rmf16,
                    rmf17     LIKE rmf_file.rmf17,
                    rmf31     LIKE rmf_file.rmf31,
                    rmf33     LIKE rmf_file.rmf33,
                    rmf25     LIKE rmf_file.rmf25,
                    #FUN-840068 --start---
                    rmfud01   LIKE rmf_file.rmfud01,
                    rmfud02   LIKE rmf_file.rmfud02,
                    rmfud03   LIKE rmf_file.rmfud03,
                    rmfud04   LIKE rmf_file.rmfud04,
                    rmfud05   LIKE rmf_file.rmfud05,
                    rmfud06   LIKE rmf_file.rmfud06,
                    rmfud07   LIKE rmf_file.rmfud07,
                    rmfud08   LIKE rmf_file.rmfud08,
                    rmfud09   LIKE rmf_file.rmfud09,
                    rmfud10   LIKE rmf_file.rmfud10,
                    rmfud11   LIKE rmf_file.rmfud11,
                    rmfud12   LIKE rmf_file.rmfud12,
                    rmfud13   LIKE rmf_file.rmfud13,
                    rmfud14   LIKE rmf_file.rmfud14,
                    rmfud15   LIKE rmf_file.rmfud15
                    #FUN-840068 --end--
                    END RECORD,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
#   g_t1                VARCHAR(3),
    g_t1                LIKE oay_file.oayslip,                     #No.FUN-550064  #No.FUN-690010 VARCHAR(05)
    g_buf,g_buf1        LIKE type_file.chr50,   #No.FUN-690010 VARCHAR(30)
    l_azi01         LIKE azi_file.azi01,
    l_gem02         LIKE gem_file.gem02,
    l_gen02         LIKE gen_file.gen02,
    g_tot           LIKE rmc_file.rmc31,  #NO:7257
    l_occ           RECORD LIKE occ_file.*,
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    p_row,p_col     LIKE type_file.num5,    #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT

DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690010 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0085
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("ARM")) THEN
       EXIT PROGRAM
    END IF

    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW t200_w AT p_row,p_col WITH FORM "arm/42f/armt200"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()

    LET g_forupd_sql = " SELECT * FROM rme_file WHERE  rme01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t200_cl CURSOR FROM g_forupd_sql

    CALL t200_menu()
    CLOSE WINDOW t200_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
END MAIN

FUNCTION t200_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_rmf.clear()
    WHILE TRUE
      CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_rme.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON            # 螢幕上取單頭條件
        rme01,rme021,rme011,rme03,rme04,rme041,rme13,rme12,rme21,rmeconf,   #CHI-BC0035 rme02->rme021
        rmepost,rme28,
        rme29,rme16,rme17,rme15,rme151,rme152,rme153,rme10,
        rme30,   #FUN-660212 add
        rme18,rme181,rme182,
        #rme19,rme191,rme192,rme22,rme08,rme09,   #MOD-970013
        rme19,rme191,rme192,rme09,   #MOD-970013
        rmeuser,rmegrup,rmemodu,rmedate,rmevoid,
        #FUN-840068   ---start---
        rmeud01,rmeud02,rmeud03,rmeud04,rmeud05,
        rmeud06,rmeud07,rmeud08,rmeud09,rmeud10,
        rmeud11,rmeud12,rmeud13,rmeud14,rmeud15
        #FUN-840068    ----end----
        #No.FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No.FUN-580031 --end--       HCN

        ON ACTION CONTROLP
           CASE WHEN INFIELD(rme03)  # 帳款客戶查詢
#                    CALL q_occ(05,11,g_rme.rme03) RETURNING g_rme.rme03
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_occ"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rme03
                     NEXT FIELD rme03

#----No.FUN-A10132---begin
               WHEN INFIELD(rme01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_rme01"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rme01
                     NEXT FIELD rme01
               WHEN INFIELD(rme011)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_rma01"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rme011
                     NEXT FIELD rme011
#----No.FUN-A10132---end

               WHEN INFIELD(rme13)
#                    CALL q_gem(05,11,g_rme.rme13) RETURNING g_rme.rme13
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gem"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rme13
                     LET g_qryparam.default1 = g_rme.rme13
                     NEXT FIELD rme13
               WHEN INFIELD(rme12)
#                    CALL q_gen(05,11,g_rme.rme12) RETURNING g_rme.rme12
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rme12
                     NEXT FIELD rme12
               WHEN INFIELD(rme15)  # 稅別
#                    CALL q_gec(05,11,g_rme.rme15,'2') RETURNING g_rme.rme15
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gec"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rme15
                     NEXT FIELD rme15
               WHEN INFIELD(rme16)  # 幣別資料查詢
#                    CALL q_azi(05,11,g_rme.rme16) RETURNING g_rme.rme16
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rme16
                     NEXT FIELD rme16
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
      IF INT_FLAG THEN RETURN END IF
      EXIT WHILE
    END WHILE
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND rmeuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND rmegrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF

    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND rmegrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rmeuser', 'rmegrup')
    #End:FUN-980030

    LET g_wc = g_wc clipped
    CONSTRUCT g_wc2 ON rmf02,rmf03,rmf06,rmf061,rmf04,rmf21,rmf12,rmc13,rmf14,rmf16,
                       rmf17,rmf31,rmf33,rmf25
                       #No.FUN-840068 --start--
                       ,rmfud01,rmfud02,rmfud03,rmfud04,rmfud05
                       ,rmfud06,rmfud07,rmfud08,rmfud09,rmfud10
                       ,rmfud11,rmfud12,rmfud13,rmfud14,rmfud15
                       #No.FUN-840068 ---end---
        FROM s_rmf[1].rmf02, s_rmf[1].rmf03, s_rmf[1].rmf06, s_rmf[1].rmf061, s_rmf[1].rmf04, s_rmf[1].rmf21,
             s_rmf[1].rmf12, s_rmf[1].rmf13, s_rmf[1].rmf14,
             s_rmf[1].rmf16, s_rmf[1].rmf17, s_rmf[1].rmf31,
             s_rmf[1].rmf33, s_rmf[1].rmf25
             #No.FUN-840068 --start--
             ,s_rmf[1].rmfud01,s_rmf[1].rmfud02,s_rmf[1].rmfud03
             ,s_rmf[1].rmfud04,s_rmf[1].rmfud05,s_rmf[1].rmfud06
             ,s_rmf[1].rmfud07,s_rmf[1].rmfud08,s_rmf[1].rmfud09
             ,s_rmf[1].rmfud10,s_rmf[1].rmfud11,s_rmf[1].rmfud12
             ,s_rmf[1].rmfud13,s_rmf[1].rmfud14,s_rmf[1].rmfud15
             #No.FUN-840068 ---end---
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
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
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
       LET g_sql = "SELECT rme01 FROM rme_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY rme01"
     ELSE                                       # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE rme01 ",
                   "  FROM rme_file, rmf_file",
                   " WHERE rme01 = rmf01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY rme01"
    END IF

    PREPARE t200_prepare FROM g_sql
    DECLARE t200_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t200_prepare

    IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM rme_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT rme01) FROM rme_file,rmf_file WHERE ",
                  "rmf01=rme01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t200_precount FROM g_sql
    DECLARE t200_count CURSOR FOR t200_precount
END FUNCTION

FUNCTION t200_menu()
   WHILE TRUE
      CALL t200_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t200_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t200_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "單頭"
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t200_u()
            END IF
       #@WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t200_y()
            END IF
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t200_z()
            END IF
       #@WHEN "扣帳"
         WHEN "deduct"
            IF cl_chk_act_auth() THEN
               CALL t200_s()
            END IF
       #@WHEN "結案"
         WHEN "close_the_case"
            IF cl_chk_act_auth() THEN
               CALL t200_v('Y')
            END IF
       #@WHEN "取消結案"
         WHEN "undo_close"
            IF cl_chk_act_auth() THEN
               CALL t200_v('N')
             END IF
       #@WHEN "拋轉應收帳款"
         WHEN "carry_to_a_r"
            IF cl_chk_act_auth() THEN
               CALL t200_g()
            END IF
       #No.+311 010628 by plum add
       #@WHEN "應收帳款查詢"
         WHEN "query_ar"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_rme.rme10[4,10]) THEN
                  LET g_msg="axrt300 '",g_rme.rme10,"' '' '14'" #No.TQC-630066
                  #CALL cl_cmdrun(g_msg CLIPPED)      #FUN-660216 remark
                  CALL cl_cmdrun_wait(g_msg CLIPPED)  #FUN-660216 add
               END IF
               SELECT rme10 INTO g_rme.rme10 FROM rme_file
               WHERE rme01=g_rme.rme01
               DISPLAY BY NAME g_rme.rme10
            END IF
       #No.+311..end
       #@WHEN "用料成本重計"    #NO:7257
         WHEN "recal_mat_cost"
            IF cl_chk_act_auth() THEN
               CALL t200_t()
            END IF
         WHEN "exporttoexcel"     #FUN-4B0035
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rmf),'','')
            END IF

         #No.FUN-6A0018-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_rme.rme01 IS NOT NULL THEN
                 LET g_doc.column1 = "rme01"
                 LET g_doc.value1 = g_rme.rme01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0018-------add--------end----
      END CASE
   END WHILE
    MESSAGE ""
END FUNCTION

FUNCTION t200_u()
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
    SELECT * INTO g_rmz.* FROM rmz_file
    IF g_rme.rme01 IS NULL THEN CALL cl_err('',-400,0)      RETURN END IF
    IF g_rme.rmeconf = 'Y' THEN CALL cl_err('',9003,0)      RETURN END IF
    #IF g_rme.rmepost = 'Y' THEN CALL cl_err('','aap-730',0) RETURN END IF   #TQC-760026
    IF g_rme.rmepost = 'Y' THEN CALL cl_err('','arm-800',0) RETURN END IF    #TQC-760026
    IF g_rme.rmevoid = 'N' THEN CALL cl_err('',9027,0)      RETURN END IF
    IF g_rme.rme28   = 'Y' THEN CALL cl_err('','aap-730',0)   RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_rme_o.* = g_rme.*
    LET g_rme_t.* = g_rme.*
    BEGIN WORK

    OPEN t200_cl USING g_rme.rme01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t200_cl ROLLBACK WORK RETURN
    END IF
   #CALL t200_show()
    WHILE TRUE
        IF g_rme.rme30  IS NULL THEN LET g_rme.rme30 =0 END IF   #FUN-660212 add
        DISPLAY BY NAME g_rme.rme30                              #FUN-660212 add
        IF g_rme.rme18  IS NULL THEN LET g_rme.rme18 =0 END IF
        IF g_rme.rme181 IS NULL THEN LET g_rme.rme181=0 END IF
        IF g_rme.rme182 IS NULL THEN LET g_rme.rme182=0 END IF
        IF g_rme.rme19  IS NULL THEN LET g_rme.rme19 =0 END IF
        IF g_rme.rme191 IS NULL THEN LET g_rme.rme191=0 END IF
        IF g_rme.rme192 IS NULL THEN LET g_rme.rme192=0 END IF
        LET g_rme.rmemodu=g_user
        LET g_rme.rmedate=g_today
      # IF g_rme.rme10 IS NULL THEN LET g_rme.rme10=g_rmz.rmz11 END IF
        CALL t200_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_rme.*=g_rme_o.*
            CALL t200_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE rme_file SET * = g_rme.* WHERE rme01 = g_rme.rme01
        IF STATUS THEN
 #       CALL cl_err(g_rme.rme01,STATUS,0) # FUN-660111
        CALL cl_err3("upd","rme_file",g_rme_o.rme01,"",STATUS,"","",1) #FUN-660111
        CONTINUE WHILE END IF
        EXIT WHILE
    END WHILE
    CLOSE t200_cl
    COMMIT WORK

END FUNCTION

#處理單頭的INPUT
FUNCTION t200_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改  #No.FUN-690010 VARCHAR(1)
         l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #No.FUN-690010 VARCHAR(1)
         l_n1            LIKE type_file.num5    #No.FUN-690010 SMALLINT
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME
        g_rme.rme01,g_rme.rme021,g_rme.rme011,g_rme.rme03,g_rme.rme04,      #CHI-BC0035 rme02->rme021
        g_rme.rme041,g_rme.rme13,g_rme.rme12,g_rme.rme21,g_rme.rmeconf,
        g_rme.rme29,g_rme.rme16,g_rme.rme17,
        g_rme.rme15,g_rme.rme151,g_rme.rme152,g_rme.rme153,g_rme.rme10,
        g_rme.rme30,   #FUN-660212 add
        g_rme.rme18,g_rme.rme181,g_rme.rme182,
        #g_rme.rme22,g_rme.rme08,g_rme.rme09,   #MOD-970013
        g_rme.rme09,   #MOD-970013
        g_rme.rmeuser,g_rme.rmegrup,g_rme.rmemodu,g_rme.rmedate,g_rme.rmevoid,
        #FUN-840068     ---start---
        g_rme.rmeud01,g_rme.rmeud02,g_rme.rmeud03,g_rme.rmeud04,
        g_rme.rmeud05,g_rme.rmeud06,g_rme.rmeud07,g_rme.rmeud08,
        g_rme.rmeud09,g_rme.rmeud10,g_rme.rmeud11,g_rme.rmeud12,
        g_rme.rmeud13,g_rme.rmeud14,g_rme.rmeud15
        #FUN-840068     ----end----
           WITHOUT DEFAULTS

        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t200_set_entry(p_cmd)
            CALL t200_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         #No.FUN-550064 --start--
         CALL cl_set_docno_format("rme10")
         #No.FUN-550064 ---end---

        AFTER FIELD rme03          #退貨客戶->秀出 rme04,041,12,16,17
          IF NOT cl_null(g_rme.rme03) THEN
              IF g_rme_t.rme03 != g_rme.rme03 OR g_rme_t.rme03 IS NULL  THEN
                 CALL t200_addr()
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('select occ',SQLCA.sqlcode,0) NEXT FIELD rme03
                 END IF
                #IF cl_null(g_rme.rme04) THEN
                    LET g_rme.rme04 = l_occ.occ02    # 退貨客戶簡稱
                #END IF
                #IF cl_null(g_rme.rme041) THEN
                    LET g_rme.rme041 = l_occ.occ11   # 統一編號
                #END IF
                 LET g_rme.rme12 = l_occ.occ04       # 負責業務員編號
                 LET g_rme.rme16 = l_occ.occ42       # 幣別
                 SELECT azk04 INTO g_rme.rme17 FROM azk_file   # 當日賣出匯率
                        WHERE g_rme.rme16 = azk01
                 CALL t200_show2()
                 DISPLAY BY NAME g_rme.rme04,g_rme.rme041,g_rme.rme12,g_rme.rme16,
                                 g_rme.rme17
              END IF
              LET g_rme_t.rme03 = g_rme.rme03
          END IF

        AFTER FIELD rme13              #業務部門
          IF NOT cl_null(g_rme.rme13) THEN
              IF g_rme_t.rme13 != g_rme.rme13 OR g_rme_t.rme13 IS NULL THEN
                 SELECT gem02 INTO l_gem02 FROM gem_file
                  WHERE g_rme.rme13 = gem01
                    AND gemacti='Y'   #NO:6950
                 IF STATUS THEN
           #         CALL cl_err('select gem',STATUS,0) # FUN-660111
                    CALL cl_err3("sel","gem_file",g_rme.rme13,"",STATUS,"","select gem",1) #FUN-660111
                    NEXT FIELD rme13
                 END IF
                 DISPLAY l_gem02 TO gem02
              END IF
              LET g_rme_t.rme13 = g_rme.rme13
          END IF

        AFTER FIELD rme12              #業務人員
          IF NOT cl_null(g_rme.rme12) THEN
              IF g_rme_t.rme12 != g_rme.rme12 OR g_rme_t.rme12 IS NULL THEN
                 SELECT gen02 INTO l_gen02 FROM gen_file
                         WHERE gen01=g_rme.rme12
                 IF STATUS THEN
   #                 CALL cl_err('select gen',STATUS,0) # FUN-660111
                    CALL cl_err3("sel","gen_file",g_rme.rme12,"",STATUS,"","select gen",1) #FUN-660111
                    NEXT FIELD rme12
                    END IF
                 DISPLAY l_gen02 TO gen02
              END IF
              LET g_rme_t.rme12 = g_rme.rme12
          END IF

        AFTER FIELD rme15              #稅別稅率->rme151,152,153
          IF NOT cl_null(g_rme.rme15) THEN
              IF g_rme_t.rme15 != g_rme.rme15 OR g_rme_t.rme15 IS NULL THEN
                 SELECT gec04,gec05,gec07
                        INTO g_rme.rme151,g_rme.rme152,g_rme.rme153
                        FROM gec_file WHERE gec01=g_rme.rme15
                                        AND gec011='2'  #銷項
                 IF STATUS THEN
        #            CALL cl_err('select gec',STATUS,0)# FUN-660111
                    CALL cl_err3("sel","gec_file",g_rme.rme15,"",STATUS,"","select gec",1) #FUN-660111
                     NEXT FIELD rme15
                 END IF
                 DISPLAY BY NAME g_rme.rme151, g_rme.rme152, g_rme.rme153
                 CALL t200_bu()   #FUN-650142 add
              END IF
              LET g_rme_t.rme15 = g_rme.rme15
          END IF

        BEFORE FIELD rme16
             CALL t200_set_entry(p_cmd)

        AFTER FIELD rme16              #幣別: rme16 匯率->rme17
          IF NOT cl_null(g_rme.rme16) THEN
             #IF g_rme.rme16 != g_rme_o.rme16 THEN
              SELECT azi01 INTO l_azi01 FROM azi_file WHERE azi01=g_rme.rme16
              IF STATUS THEN
    #             CALL cl_err('select azi',STATUS,0)# FUN-660111
                 CALL cl_err3("sel","azi_file",g_rme.rme16,"",STATUS,"","select azi",1) #FUN-660111
                  NEXT FIELD rme16
              END IF
              IF g_rme.rme17=0 OR cl_null(g_rme.rme17) THEN
                 CALL s_curr3(g_rme.rme16,g_rme.rme021,g_rmz.rmz15)     #CHI-BC0035 rme02->rme021
                             RETURNING g_rme.rme17
                 DISPLAY BY NAME g_rme.rme17
              END IF
             #END IF
              DISPLAY BY NAME g_rme.rme16
              LET g_rme_t.rme16 = g_rme.rme16
          END IF
          CALL t200_set_no_entry(p_cmd)

     BEFORE FIELD rme17
          IF g_rme.rme16 = g_aza.aza17 THEN
             LET g_rme.rme17='1'
             LET g_rme_t.rme17 = g_rme.rme17
             DISPLAY BY NAME g_rme.rme17
          END IF
          LET g_rme_t.rme17 = g_rme.rme17
          DISPLAY BY NAME g_rme.rme17

     AFTER FIELD rme17
          IF cl_null(g_rme.rme17) THEN NEXT FIELD rme17 END IF

          #FUN-4C0085
          IF g_rme.rme17 IS NOT NULL THEN
             IF g_rme.rme16=g_aza.aza17 THEN
                LET g_rme.rme17 =1
                DISPLAY BY NAME g_rme.rme17
             END IF
          END IF
          #--END
          #No.TQC-A10026  --Begin
          IF g_rme.rme17 < 0 THEN
             CALL cl_err('','aec-020',0)
             NEXT FIELD rme17
          END IF
          #No.TQC-A10026  --End
          LET g_rme_t.rme17 = g_rme.rme17

        AFTER FIELD rme29              #內外銷別
          IF cl_null(g_rme.rme29) THEN NEXT FIELD rme29 END IF

       #start FUN-660212 add
        AFTER FIELD rme30
          IF cl_null(g_rme.rme30) Or g_rme.rme30<0 THEN
             CALL cl_err('','mfg3291',1)
             NEXT FIELD rme30
          END IF
       #end FUN-660212 add

       #-----MOD-950152---------
        AFTER FIELD rme18
#TQC-9C0203 --begin--
          IF NOT cl_null(g_rme.rme18) THEN
              IF g_rme.rme18 < 0 THEN
                CALL cl_err('','aec-020',0)
                 NEXT FIELD CURRENT
              END IF
           END IF
#TQC-9C0203 --end--
          IF g_rme.rme153 = 'N'  THEN # 不內含
             IF g_rme.rme17 > 0 THEN   #匯率
                SELECT azi04 INTO t_azi04 FROM azi_file
                 WHERE azi01 = g_rme.rme16
                LET g_rme.rme181 = (g_rme.rme18 * g_rme.rme151)/100
                LET g_rme.rme182 = g_rme.rme18 + g_rme.rme181
                CALL cl_digcut(g_rme.rme18,t_azi04) RETURNING g_rme.rme18
                CALL cl_digcut(g_rme.rme181,t_azi04) RETURNING g_rme.rme181
                CALL cl_digcut(g_rme.rme182,t_azi04) RETURNING g_rme.rme182
                LET g_rme.rme19 = g_rme.rme18
                LET g_rme.rme191 = (g_rme.rme19 * g_rme.rme151)/100
                LET g_rme.rme192 = g_rme.rme19 + g_rme.rme191
                CALL cl_digcut(g_rme.rme19,t_azi04) RETURNING g_rme.rme19
                CALL cl_digcut(g_rme.rme191,t_azi04) RETURNING g_rme.rme191
                CALL cl_digcut(g_rme.rme192,t_azi04) RETURNING g_rme.rme192    #MOD-B90261 modify  g_azi04 -> t_azi04
             ELSE
                LET g_rme.rme18 = 0
                LET g_rme.rme181= 0
                LET g_rme.rme182= 0
                LET g_rme.rme19 = 0
                LET g_rme.rme191= 0
                LET g_rme.rme192= 0
             END IF
          ELSE
             IF g_rme.rme17 > 0 THEN   #匯率
                SELECT azi04 INTO t_azi04 FROM azi_file
                  WHERE azi01 = g_rme.rme16
                LET g_rme.rme182 = g_rme.rme18 * (1+g_rme.rme151/100)
                LET g_rme.rme181 = g_rme.rme182 - g_rme.rme18
                CALL cl_digcut(g_rme.rme18,t_azi04) RETURNING g_rme.rme18
                CALL cl_digcut(g_rme.rme181,t_azi04) RETURNING g_rme.rme181
                CALL cl_digcut(g_rme.rme182,t_azi04) RETURNING g_rme.rme182
                LET g_rme.rme19 = g_rme.rme18
                LET g_rme.rme192 = g_rme.rme19 * (1+g_rme.rme151/100)
                LET g_rme.rme191 = g_rme.rme192 - g_rme.rme19
                CALL cl_digcut(g_rme.rme19,t_azi04) RETURNING g_rme.rme19
                CALL cl_digcut(g_rme.rme191,t_azi04) RETURNING g_rme.rme191
                CALL cl_digcut(g_rme.rme192,t_azi04) RETURNING g_rme.rme192    #MOD-B90261 modify  g_azi04 -> t_azi04
             ELSE
                LET g_rme.rme18 = 0
                LET g_rme.rme181= 0
                LET g_rme.rme182= 0
                LET g_rme.rme19 = 0
                LET g_rme.rme191= 0
                LET g_rme.rme192= 0
             END IF
          END IF
          DISPLAY BY NAME g_rme.rme18,g_rme.rme181,g_rme.rme182,
                          g_rme.rme19,g_rme.rme191,g_rme.rme192
       #-----END MOD-950152-----

        #FUN-840068     ---start---
        AFTER FIELD rmeud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840068     ----end----

        ON KEY(F1) NEXT FIELD rme01
        ON KEY(F2) NEXT FIELD rme29
        ON ACTION CONTROLP
           CASE WHEN INFIELD(rme03)  # 帳款客戶查詢
#                    CALL q_occ(05,11,g_rme.rme03) RETURNING g_rme.rme03
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_occ"
                     LET g_qryparam.default1 = g_rme.rme03
                     CALL cl_create_qry() RETURNING g_rme.rme03
#                     CALL FGL_DIALOG_SETBUFFER( g_rme.rme03 )
                     DISPLAY BY NAME g_rme.rme03
                     NEXT FIELD rme03
   
#----No.FUN-A10132---begin---
               WHEN INFIELD(rme011)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_rma01"
                     LET g_qryparam.default1 = g_rme.rme011
                     CALL cl_create_qry() RETURNING g_rme.rme011
                     DISPLAY BY NAME g_rme.rme011
                     NEXT FIELD rme011
#----No.FUN-A10132---end
            
                WHEN INFIELD(rme13)
#                    CALL q_gem(05,11,g_rme.rme13) RETURNING g_rme.rme13
#                    CALL FGL_DIALOG_SETBUFFER( g_rme.rme13 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gem"
                     LET g_qryparam.default1 = g_rme.rme13
                     CALL cl_create_qry() RETURNING g_rme.rme13
#                     CALL FGL_DIALOG_SETBUFFER( g_rme.rme13 )
                     DISPLAY BY NAME g_rme.rme13
                     NEXT FIELD rme13
               WHEN INFIELD(rme12)
#                    CALL q_gen(05,11,g_rme.rme12) RETURNING g_rme.rme12
#                    CALL FGL_DIALOG_SETBUFFER( g_rme.rme12 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen"
                     LET g_qryparam.default1 = g_rme.rme12
                     CALL cl_create_qry() RETURNING g_rme.rme12
#                     CALL FGL_DIALOG_SETBUFFER( g_rme.rme12 )
                     DISPLAY BY NAME g_rme.rme12
                     NEXT FIELD rme12
               WHEN INFIELD(rme15)  # 稅別
#                    CALL q_gec(05,11,g_rme.rme15,'2') RETURNING g_rme.rme15
#                    CALL FGL_DIALOG_SETBUFFER( g_rme.rme15 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gec"
                     LET g_qryparam.default1 = g_rme.rme15
                     LET g_qryparam.arg1 = '2'
                     CALL cl_create_qry() RETURNING g_rme.rme15
#                     CALL FGL_DIALOG_SETBUFFER( g_rme.rme15 )
                     DISPLAY BY NAME g_rme.rme15
                     NEXT FIELD rme15
               WHEN INFIELD(rme16)  # 幣別資料查詢
#                    CALL q_azi(05,11,g_rme.rme16) RETURNING g_rme.rme16
#                    CALL FGL_DIALOG_SETBUFFER( g_rme.rme16 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi"
                     LET g_qryparam.default1 = g_rme.rme16
                     CALL cl_create_qry() RETURNING g_rme.rme16
#                     CALL FGL_DIALOG_SETBUFFER( g_rme.rme16 )
                     DISPLAY BY NAME g_rme.rme16
                     NEXT FIELD rme16
                #FUN-4B0058
                WHEN INFIELD(rme17)
                   CALL s_rate(g_rme.rme16,g_rme.rme17) RETURNING g_rme.rme17
                   DISPLAY BY NAME g_rme.rme17
                   NEXT FIELD rme17
                #FUN-4B0058(end)
            END CASE

        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

       #MOD-650015 --start
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(rme01) THEN
        #        LET g_rme.* = g_rme_t.*
        #        CALL t200_show()
        #        NEXT FIELD rme01
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


FUNCTION t200_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rme.* TO NULL              #No.FUN-6A0018
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t200_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_rme.* TO NULL RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_rme.* TO NULL
    ELSE
        OPEN t200_count
        FETCH t200_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t200_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION

FUNCTION t200_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-690010 INTEGER

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t200_cs INTO g_rme.rme01
        WHEN 'P' FETCH PREVIOUS t200_cs INTO g_rme.rme01
        WHEN 'F' FETCH FIRST    t200_cs INTO g_rme.rme01
        WHEN 'L' FETCH LAST     t200_cs INTO g_rme.rme01
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
            FETCH ABSOLUTE g_jump t200_cs INTO g_rme.rme01
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)
        INITIALIZE g_rme.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
    IF SQLCA.sqlcode THEN
 #       CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)# FUN-660111
        CALL cl_err3("sel","rme_file",g_rme.rme01,"",SQLCA.sqlcode,"","",1) #FUN-660111
        INITIALIZE g_rme.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_rme.rmeuser #FUN-4C0055
        LET g_data_group = g_rme.rmegrup #FUN-4C0055
        LET g_data_plant = g_rme.rmeplant #FUN-980030
    END IF

    CALL t200_show()
END FUNCTION

FUNCTION t200_show()
    SELECT oma05,oma10 INTO g_rme.rme22,g_rme.rme08 FROM oma_file WHERE oma01 = g_rme.rme10   #MOD-970013
    LET g_rme_t.* = g_rme.*                #保存單頭舊值

    DISPLAY BY NAME
        g_rme.rme01,g_rme.rme021,g_rme.rme03,g_rme.rme04,g_rme.rme041,  #CHI-BC0035 rme02->rme021
        g_rme.rme08,g_rme.rme09,g_rme.rme10,g_rme.rme12,g_rme.rme13,
        g_rme.rme15,g_rme.rme151,g_rme.rme152,g_rme.rme153,
        g_rme.rme16,g_rme.rme17, g_rme.rme30,   #FUN-660212 add g_rme.rme30
        g_rme.rme18,g_rme.rme181,g_rme.rme182,
        g_rme.rme19,g_rme.rme191,g_rme.rme192,g_rme.rme21,g_rme.rme22,
        g_rme.rme29,g_rme.rme011,
        g_rme.rmeconf,
        g_rme.rmepost,
        g_rme.rme28  ,
        g_rme.rmeuser,g_rme.rmegrup,
        g_rme.rmemodu,g_rme.rmedate,g_rme.rmevoid,
        #FUN-840068     ---start---
        g_rme.rmeud01,g_rme.rmeud02,g_rme.rmeud03,g_rme.rmeud04,
        g_rme.rmeud05,g_rme.rmeud06,g_rme.rmeud07,g_rme.rmeud08,
        g_rme.rmeud09,g_rme.rmeud10,g_rme.rmeud11,g_rme.rmeud12,
        g_rme.rmeud13,g_rme.rmeud14,g_rme.rmeud15
        #FUN-840068     ----end----
    #CKP
    CALL cl_set_field_pic(g_rme.rmeconf,"","","","",g_rme.rmevoid)

    CALL t200_addr()             # 找出送貨地址
    CALL t200_show2()            # 找出業務部門,人員
    CALL t200_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

FUNCTION t200_addr()
   {CALL s_addr(g_rme.rme01,g_rme.rme03,g_rme.rme041)
         RETURNING l_occ.occ241,l_occ.occ242,l_occ.occ243 }
    LET g_msg=""
    SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_rme.rme03
    LET g_msg=l_occ.occ241 CLIPPED,' ',l_occ.occ242 CLIPPED,' ',l_occ.occ243
    DISPLAY g_msg TO addr
END FUNCTION

FUNCTION t200_show2()
    LET l_gem02="" LET l_gen02=""
    IF g_rme.rme13 IS NULL THEN
       SELECT gen02,gen03 INTO l_gen02,g_rme.rme13 FROM gen_file
              WHERE gen01=g_rme.rme12
    ELSE
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rme.rme12
    END IF
    SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_rme.rme13
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    DISPLAY l_gem02,l_gen02 TO gem02,gen02  #部門名稱,業務姓名
END FUNCTION

FUNCTION t200_t()     #成本重計NO:7257 add
    DEFINE l_rmc  RECORD LIKE rmc_file.*,
           l_rmd  RECORD LIKE rmd_file.*,
           l_yy,l_mm LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
           l_rmd13   LIKE rmd_file.rmd13,
           l_rmd14   LIKE rmd_file.rmd14,
           l_rmc13   LIKE rmc_file.rmc13

    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
    #若覆出單號為空白,或此覆出單已被確認,或立帳單號不為空白時不可執行: 成本重計
    IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
    IF cl_null(g_rme.rme01) THEN CALL cl_err('','mfg9201',0)
       RETURN END IF
    IF g_rme.rmeconf = 'Y' THEN CALL cl_err('conf=Y',9023,0)
       RETURN END IF
    IF NOT cl_null(g_rme.rme10) THEN CALL cl_err(g_rme.rme10,'arm-024',0)
       RETURN END IF

    DECLARE rmc_curs CURSOR FOR
     SELECT * FROM rmc_file WHERE rmc23 = g_rme.rme01
    IF STATUS THEN
 #   CALL cl_err('rmc_curs',STATUS,1) # FUN-660111
    CALL cl_err3("sel","rmc_file",g_rme.rme01,"",STATUS,"","rmc_curs",1) #FUN-660111
    RETURN END IF

    LET g_sql='SELECT * FROM rmd_file WHERE rmd01 = ? AND rmd03 = ? '
    PREPARE rmd_pre1 FROM g_sql              # RUNTIME 編譯
    IF STATUS THEN CALL cl_err('rmd_pre1',STATUS,1) RETURN END IF
    DECLARE rmd_curs CURSOR FOR rmd_pre1
    IF STATUS THEN CALL cl_err('rmd_curs',STATUS,1) RETURN END IF

    BEGIN WORK


    OPEN t200_cl USING g_rme.rme01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t200_cl ROLLBACK WORK RETURN
    END IF
    LET g_success='Y'
    FOREACH rmc_curs INTO l_rmc.*
    #  IF l_rmc.rmc04 ='MISC' THEN CONTINUE FOREACH END IF
       FOREACH rmd_curs USING l_rmc.rmc01,l_rmc.rmc02 INTO l_rmd.*
        LET l_rmd13= null
        # IF l_rmd.rmd12 <=0 THEN CONTINUE FOREACH END IF
        # IF l_rmd.rmd13 = 0 OR cl_null(l_rmd.rmd13) THEN
          IF l_rmd.rmd04 !='MISC' THEN
             CALL s_yp(l_rmc.rmc08) RETURNING l_yy,l_mm
            #-----MOD-950152---------
            #CALL s_lsperiod(l_yy,l_mm) RETURNING l_yy,l_mm
            ##ccc_file: 庫存月加權成本資料 ccc23(本月平均單價)
            #SELECT ccc23 INTO l_rmd13 FROM ccc_file
            # WHERE ccc01 = l_rmd.rmd04 AND ccc02=l_yy AND ccc03=l_mm
            #   AND ccc07 = '1'                      #No.FUN-840041
            #CHI-B60093 --- modify --- start ---
            # SELECT ccc23 INTO l_rmd13 FROM ccc_file
            #  WHERE ccc01 = l_rmd.rmd04 AND ccc07 = '1'
            #    AND ccc02*12+ccc03 =
            #        (SELECT MAX(ccc02*12+ccc03) FROM ccc_file
            #          WHERE ccc01 = l_rmd.rmd04 AND ccc07 = '1'
            #            AND ccc02*12+ccc03 <= l_yy*12+l_mm)
             SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'
             CALL t200_get_ccc23('1',l_rmd.rmd04,l_yy,l_mm) RETURNING l_rmd13
            #CHI-B60093 --- modify ---  end  ---
             IF cl_null(l_rmd13) THEN
            #CHI-B60093 --- modify --- start ---
            #    SELECT cca23 INTO l_rmd13 FROM cca_file
            #     WHERE cca01 = l_rmd.rmd04 AND cca06 = '1'
            #       AND cca02*12+cca03 =
            #           (SELECT MAX(cca02*12+cca03) FROM cca_file
            #             WHERE cca01 = l_rmd.rmd04 AND cca06 = '1'
            #               AND cca02*12+cca03 <= l_yy*12+l_mm)
             CALL t200_get_ccc23('2',l_rmd.rmd04,l_yy,l_mm) RETURNING l_rmd13
            #CHI-B60093 --- modify ---  end  ---
             END IF
             #-----END MOD-950152-----
          END IF
          IF cl_null(l_rmd13) THEN LET l_rmd13 = 0 END IF
          LET l_rmd14 = l_rmd.rmd12 * l_rmd13
          UPDATE rmd_file SET rmd13 = l_rmd13, rmd14 = l_rmd14
           WHERE rmd01 = l_rmd.rmd01 AND rmd02 = l_rmd.rmd02
             AND rmd03 = l_rmd.rmd03
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
    #        CALL cl_err('upd rmd',STATUS,1)# FUN-660111
            CALL cl_err3("upd","rmd_file",l_rmd.rmd01,l_rmd.rmd02,STATUS,"","upd rmd",1) #FUN-660111
             LET g_success = 'N'
          END IF
        # END IF
       END FOREACH
       LET l_rmc13 = 0
       SELECT SUM(rmd14) INTO l_rmc13 FROM rmd_file
        WHERE rmd01 = l_rmc.rmc01 AND rmd03 = l_rmc.rmc02
          AND rmd12 >0
      # WHERE rmd01 = l_rmd.rmd01 AND rmd03 = l_rmd.rmd02
       IF cl_null(l_rmc13) THEN LET l_rmc13 = 0 END IF
       UPDATE rmc_file SET rmc13 = l_rmc13
        WHERE rmc01 = l_rmc.rmc01 AND rmc02 = l_rmc.rmc02
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
   #       CALL cl_err('upd rmc',STATUS,1)# FUN-660111
          CALL cl_err3("upd","rmc_file",l_rmc.rmc01,l_rmc.rmc02,STATUS,"","upd rmc",1) #FUN-660111
          LET g_success = 'N'
       END IF
    END FOREACH
    IF g_success = 'Y' THEN
       CALL cl_cmmsg(4)
       COMMIT WORK
    ELSE
       CALL cl_rbmsg(4)
       ROLLBACK WORK
    END IF
    CALL t200_b_fill('1=1')
    CALL t200_bu1('t')
END FUNCTION

FUNCTION t200_bu1(p_cmd)  #NO:7257 new add
    DEFINE g_rme18   LIKE rme_file.rme18
    DEFINE g_rme182  LIKE rme_file.rme182   #FUN-650142 add
    DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)

    IF g_rme.rmeconf='Y' THEN RETURN END IF

   #start FUN-660212 add
    #總用料成本 g_tot = total(rmc12+rmc13)
    SELECT SUM(rmc12+rmc13) INTO g_tot
      FROM rmc_file
     WHERE rmc23 = g_rme.rme01 AND rmc09 = 'Y'
    IF cl_null(g_tot) THEN LET g_tot=0 END IF
   #end FUN-660212 add

   #start FUN-650142 modify
   #IF g_rme.rme17 > 0 THEN   #匯率
   #   LET g_rme18 = g_tot * g_rme.rme30 / g_rme.rme17
   #   IF p_cmd='t' OR
   #      (g_rme.rme18 = g_rme_t.rme18 AND g_rme18 = g_rme_t.rme18) THEN
   #      LET g_rme.rme18 = g_tot * g_rme.rme30 / g_rme.rme17
   #   END IF
   #   CALL cl_digcut(g_rme.rme18,g_azi04) RETURNING g_rme.rme18
   #ELSE
   #   LET g_rme.rme18 = 0
   #END IF
   #
   #LET g_rme.rme181 = (g_rme.rme18 * g_rme.rme151) / 100
   #CALL cl_digcut(g_rme.rme181,g_azi04) RETURNING g_rme.rme181
   #LET g_rme.rme182 = g_rme.rme18 + g_rme.rme181
   #LET g_rme.rme19 = g_rme.rme18 * g_rme.rme17
   #CALL cl_digcut(g_rme.rme19,t_azi04) RETURNING g_rme.rme19
   #LET g_rme.rme191 = (g_rme.rme19 * g_rme.rme151) / 100
   #CALL cl_digcut(g_rme.rme191,t_azi04) RETURNING g_rme.rme191
   #LET g_rme.rme192 = g_rme.rme19 + g_rme.rme191

    #計算公式應參考稅別的設定,包括含稅及不含稅
     IF g_rme.rme153 = 'N'  THEN # 不內含
        IF g_rme.rme17 > 0 THEN   #匯率
          #LET g_rme18 = g_tot * g_rme.rme30 / g_rme.rme17 #CHI-AB0009 mark
           LET g_rme18 = g_tot * (1+(g_rme.rme30/100)) / g_rme.rme17 #CHI-AB0009
           IF p_cmd='t' OR
              (g_rme.rme18 = g_rme_t.rme18 AND g_rme18 = g_rme_t.rme18) THEN
             #LET g_rme.rme18 = g_tot * g_rme.rme30 / g_rme.rme17 #CHI-AB0009 mark
              LET g_rme.rme18 = g_tot * (1+(g_rme.rme30/100)) / g_rme.rme17 #CHI-AB0009
           END IF
           CALL cl_digcut(g_rme.rme18,t_azi04) RETURNING g_rme.rme18                #MOD-B90261 modify  g_azi04 -> t_azi04
           LET g_rme.rme181 = (g_rme.rme18 * g_rme.rme151)/100   #原幣應收稅額
           LET g_rme.rme182 = g_rme.rme18 + g_rme.rme181         #原幣應收含稅金額
           CALL cl_digcut(g_rme.rme18,t_azi04) RETURNING g_rme.rme18                #MOD-B90261 modify  g_azi04 -> t_azi04
           CALL cl_digcut(g_rme.rme181,t_azi04) RETURNING g_rme.rme181              #MOD-B90261 modify  g_azi04 -> t_azi04
           CALL cl_digcut(g_rme.rme182,t_azi04) RETURNING g_rme.rme182              #MOD-B90261 modify  g_azi04 -> t_azi04
          #LET g_rme.rme19 = g_rme.rme18 * g_rme.rme17           #本幣應收未稅金額  #CHI-840072 mark
           LET g_rme.rme19 = g_rme.rme18                         #原幣應收未稅金額  #CHI-840072
           CALL cl_digcut(g_rme.rme19,t_azi04) RETURNING g_rme.rme19
           LET g_rme.rme191 = (g_rme.rme19 * g_rme.rme151)/100   #本幣應收稅額
           CALL cl_digcut(g_rme.rme191,t_azi04) RETURNING g_rme.rme191
           LET g_rme.rme192 = g_rme.rme19 + g_rme.rme191         #本幣應收含稅金額
           CALL cl_digcut(g_rme.rme192,t_azi04) RETURNING g_rme.rme192              #MOD-B90261 modify  g_azi04 -> t_azi04
        ELSE
           LET g_rme.rme18 = 0
           LET g_rme.rme181= 0
           LET g_rme.rme182= 0
           LET g_rme.rme19 = 0
           LET g_rme.rme191= 0
           LET g_rme.rme192= 0
        END IF
     ELSE
        IF g_rme.rme17 > 0 THEN   #匯率
          #LET g_rme182= g_tot * g_rme.rme30 / g_rme.rme17 #CHI-AB0009 mark
           LET g_rme182 = g_tot * (1+(g_rme.rme30/100)) / g_rme.rme17 #CHI-AB0009
           IF p_cmd='t' OR
              (g_rme.rme182= g_rme_t.rme182 AND g_rme182 = g_rme_t.rme182) THEN
             #LET g_rme.rme182= g_tot * g_rme.rme30 / g_rme.rme17 #CHI-AB0009 mark
              LET g_rme.rme182 = g_tot * (1+(g_rme.rme30/100)) / g_rme.rme17 #CHI-AB0009
           END IF
           LET g_rme.rme18 = g_rme.rme182/(1+g_rme.rme151/100)   #原幣應收未稅金額
           LET g_rme.rme181 = g_rme.rme182 - g_rme.rme18         #原幣應收稅額
           CALL cl_digcut(g_rme.rme18,t_azi04) RETURNING g_rme.rme18                #MOD-B90261 modify  g_azi04 -> t_azi04
           CALL cl_digcut(g_rme.rme181,t_azi04) RETURNING g_rme.rme181              #MOD-B90261 modify  g_azi04 -> t_azi04 
           CALL cl_digcut(g_rme.rme182,t_azi04) RETURNING g_rme.rme182              #MOD-B90261 modify  g_azi04 -> t_azi04 
          #LET g_rme.rme192= g_rme.rme182 * g_rme.rme17          #本幣應收含稅金額  #CHI-840072 mark
           LET g_rme.rme192= g_rme.rme182                        #原幣應收含稅金額  #CHI-840072
           CALL cl_digcut(g_rme.rme192,t_azi04) RETURNING g_rme.rme192              #MOD-B90261 modify  g_azi04 -> t_azi04
           LET g_rme.rme19 = g_rme.rme192/(1+g_rme.rme151/100)   #本幣應收未稅金額
           CALL cl_digcut(g_rme.rme19,t_azi04) RETURNING g_rme.rme19
           LET g_rme.rme191 = g_rme.rme192 - g_rme.rme19         #本幣應收稅額
           CALL cl_digcut(g_rme.rme191,t_azi04) RETURNING g_rme.rme191              #MOD-B90261 modify  g_azi04 -> t_azi04
        ELSE
           LET g_rme.rme18 = 0
           LET g_rme.rme181= 0
           LET g_rme.rme182= 0
           LET g_rme.rme19 = 0
           LET g_rme.rme191= 0
           LET g_rme.rme192= 0
        END IF
     END IF
   #end FUN-650142 modify

    DISPLAY BY NAME g_rme.rme18,g_rme.rme181,g_rme.rme182,
                    g_rme.rme19,g_rme.rme191,g_rme.rme192
    UPDATE rme_file SET * = g_rme.* WHERE rme01 = g_rme.rme01
    IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
   #    CALL cl_err('upd rme',STATUS,1)# FUN-660111
       CALL cl_err3("upd","rme_file",g_rme_t.rme01,"",STATUS,"","upd rme",1) #FUN-660111
       RETURN
    END IF
END FUNCTION

FUNCTION t200_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_row,l_col     LIKE type_file.num5,    #No.FUN-690010 SMALLINT,              #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690010 VARCHAR(1)
    l_possible      LIKE type_file.num5,    #No.FUN-690010 SMALLINT,              #用來設定判斷重複的可能性
    l_b2            LIKE type_file.chr50,   #No.FUN-690010 VARCHAR(30),
    l_ima35,l_ima36 LIKE ima_file.ima35,    #No.FUN-690010 VARCHAR(10),
#    l_qty           LIKE ima_file.ima26,    #No.FUN-690010 DECIMAL(15,3),#FUN-A20044
    l_qty           LIKE type_file.num15_3,    #No.FUN-690010 DECIMAL(15,3),#FUN-A20044
    l_flag          LIKE type_file.num10,   #No.FUN-690010 INTEGER,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690010 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690010 SMALLINT

    LET g_action_choice = ""
    SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
    IF g_rme.rme01 IS NULL THEN CALL cl_err('',-400,0)      RETURN END IF
    IF g_rme.rmeconf = 'Y' THEN CALL cl_err('',9003,0)      RETURN END IF
    #IF g_rme.rmepost = 'Y' THEN CALL cl_err('','aap-730',0) RETURN END IF   #TQC-760026
    IF g_rme.rmepost = 'Y' THEN CALL cl_err('','arm-800',0) RETURN END IF    #TQC-760026
    IF g_rme.rmevoid = 'N' THEN CALL cl_err('',9027,0)      RETURN END IF
    IF g_rme.rme28   = 'Y' THEN CALL cl_err('','aap-730',0)   RETURN END IF  #TQC-760026
    CALL cl_opmsg('b')

    SELECT azi04 INTO t_azi04 FROM azi_file   #MOD-BC0001 add 重抓azi04
     WHERE azi01 = g_rme.rme16                #MOD-BC0001 add


    LET g_forupd_sql =
     "  SELECT rmf02,rmf03,rmf06,rmf061,rmf04,rmf21,rmf12,rmf13,rmf14, ",
     "         rmf16,rmf17,rmf31,rmf33,rmf25, ",
     #No.FUN-840068 --start--
     "         rmfud01,rmfud02,rmfud03,rmfud04,rmfud05,",
     "         rmfud06,rmfud07,rmfud08,rmfud09,rmfud10,",
     "         rmfud11,rmfud12,rmfud13,rmfud14,rmfud15 ",
     #No.FUN-840068 ---end---
     "  FROM rmf_file ",
     "   WHERE rmf01= ? ",
     "    AND rmf02= ? ",
     "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t200_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    LET l_ac_t = 0

     #LET l_allow_insert = cl_detail_input_auth("insert")  #MOD-840662 mark
      LET l_allow_insert = FALSE                           #MOD-840662
      LET l_allow_delete = cl_detail_input_auth("delete")

      INPUT ARRAY g_rmf WITHOUT DEFAULTS FROM s_rmf.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            BEGIN WORK

            OPEN t200_cl USING g_rme.rme01
            IF STATUS THEN
               CALL cl_err("OPEN t200_cl:", STATUS, 1)
               CLOSE t200_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t200_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                CLOSE t200_cl ROLLBACK WORK RETURN
            END IF

            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_rmf_t.* = g_rmf[l_ac].*  #BACKUP
               LET g_rmf_o.* = g_rmf[l_ac].*  #BACKUP
                OPEN t200_bcl USING g_rme.rme01,g_rmf_t.rmf02
                IF STATUS THEN
                    CALL cl_err("OPEN t200_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t200_bcl INTO g_rmf[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err('lock rmf',SQLCA.sqlcode,0)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD rmf21

       #MOD-840662-begin-mark
       # AFTER INSERT
       #     IF INT_FLAG THEN
       #        CALL cl_err('',9001,0)
       #        LET INT_FLAG = 0
       #        CANCEL INSERT
       #     END IF
       #     IF cl_null(g_rmf[l_ac].rmf14) THEN
       #         LET g_rmf[l_ac].rmf14=0
       #     END IF
       #     IF cl_null(g_rmf[l_ac].rmf16) THEN
       #         LET g_rmf[l_ac].rmf14=0
       #     END IF
       #     IF cl_null(g_rmf[l_ac].rmf17) THEN
       #         LET g_rmf[l_ac].rmf14=0
       #     END IF
       #     INSERT INTO rmf_file VALUES(b_rmf.*)
       #     IF SQLCA.sqlcode THEN
    #  #          CALL cl_err('ins rmf',SQLCA.sqlcode,0)# FUN-660111
       #         CALL cl_err3("ins","rmf_file",b_rmf.rmf01,b_rmf.rmf02,SQLCA.sqlcode,"","ins rmf",1) #FUN-660111
       #         #CKP
       #         ROLLBACK WORK
       #         CANCEL INSERT
       #     ELSE
       #         MESSAGE 'INSERT O.K'
       #         LET g_rec_b=g_rec_b+1
       #         DISPLAY g_rec_b TO FORMONLY.cn2
       #         CALL t200_bu()
       #         COMMIT WORK
       #     END IF

       # BEFORE INSERT
       #         LET l_n = ARR_COUNT()
       #         LET p_cmd='a'
       #         INITIALIZE g_rmf[l_ac].* TO NULL      #900423
       #        #LET b_rmf.rmf01=g_rme.rme01
       #         LET g_rmf[l_ac].rmf12=0
       #         LET g_rmf[l_ac].rmf13=0
       #         LET g_rmf[l_ac].rmf14=0
       #         LET g_rmf[l_ac].rmf16=0
       #         LET g_rmf[l_ac].rmf17=0
       #         LET g_rmf[l_ac].rmf31=0
       #         LET g_rmf[l_ac].rmf33=0
       #         LET g_rmf[l_ac].rmf21='N'
       #         LET g_rmf[l_ac].rmf25='5'
       #         LET g_rmf_t.* = g_rmf[l_ac].*             #新輸入資料
       #         CALL cl_show_fld_cont()     #FUN-550037(smin)
       #         NEXT FIELD rmf21
        #MOD-840662-end-mark

        AFTER FIELD rmf21
           IF NOT cl_null(g_rmf[l_ac].rmf21) THEN
              IF g_rmf[l_ac].rmf21 NOT MATCHES '[YN]' THEN
                  NEXT FIELD rmf21
              END IF
           END IF

        AFTER FIELD rmf12
           IF NOT cl_null(g_rmf[l_ac].rmf12) THEN
              LET g_rmf[l_ac].rmf12 = s_digqty(g_rmf[l_ac].rmf12,g_rmf[l_ac].rmf04)   #FUN-910088--add--
              DISPLAY BY NAME g_rmf[l_ac].rmf12                                       #FUN-910088--add--
               IF g_rmf[l_ac].rmf12 < 0 THEN
                   NEXT FIELD rmf12
               END IF
               IF g_rmf_o.rmf12 != g_rmf[l_ac].rmf12 THEN
                  LET g_rmf[l_ac].rmf14 = g_rmf[l_ac].rmf12 * g_rmf[l_ac].rmf13
                  #CALL cl_digcut(g_rmf[l_ac].rmf14,g_rme.rme16)  #MOD-BC0001 mark
                  CALL cl_digcut(g_rmf[l_ac].rmf14,t_azi04)       #MOD-BC0001 add
                       RETURNING g_rmf[l_ac].rmf14
               END IF
               LET g_rmf_t.rmf12 = g_rmf[l_ac].rmf12
           END IF

        AFTER FIELD rmf13
           IF NOT cl_null(g_rmf[l_ac].rmf13) THEN
               IF g_rmf[l_ac].rmf13 < 0 THEN
                   NEXT FIELD rmf13
               END IF
               IF g_rmf_o.rmf13 != g_rmf[l_ac].rmf13 THEN
                  LET g_rmf[l_ac].rmf14 = g_rmf[l_ac].rmf12 * g_rmf[l_ac].rmf13
                  #CALL cl_digcut(g_rmf[l_ac].rmf14,g_rme.rme16)  #MOD-BC0001 mark
                  CALL cl_digcut(g_rmf[l_ac].rmf14,t_azi04)       #MOD-BC0001 mark
                       RETURNING g_rmf[l_ac].rmf14
               END IF
               LET g_rmf_t.rmf13 = g_rmf[l_ac].rmf13
           END IF

#TQC-9C0203 --begin--
        AFTER FIELD rmf14
           IF NOT cl_null(g_rmf[l_ac].rmf14) THEN
              IF g_rmf[l_ac].rmf14 < 0 THEN
                 CALL cl_err('','aec-020',0)
                  NEXT FIELD CURRENT
               END IF
           END IF

        AFTER FIELD rmf17
           IF NOT cl_null(g_rmf[l_ac].rmf17) THEN
              IF g_rmf[l_ac].rmf17 < 0 THEN
                 CALL cl_err('','aec-020',0)
                  NEXT FIELD CURRENT
               END IF
           END IF
#TQC-9C0203 --end--

        AFTER FIELD rmf16   #NO:7257
#TQC-9C0203 --begin--
           IF NOT cl_null(g_rmf[l_ac].rmf16) THEN
              IF g_rmf[l_ac].rmf16 < 0 THEN
                 CALL cl_err('','aec-020',0)
                  NEXT FIELD CURRENT
               END IF
           END IF
#TQC-9C0203 --end--
          #LET g_rmf[l_ac].rmf17=g_rmf[l_ac].rmf16 * (1+(g_rmz.rmz21/100)) #CHI-AB0009 mark
           LET g_rmf[l_ac].rmf17=g_rmf[l_ac].rmf16 * (1+(g_rme.rme30/100)) #CHI-AB0009

        #No.FUN-840068 --start--
        AFTER FIELD rmfud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmfud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmfud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmfud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmfud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmfud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmfud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmfud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmfud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmfud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmfud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmfud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmfud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmfud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmfud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840068 ---end---

        BEFORE DELETE                            #是否取消單身
            IF g_rmf_t.rmf02 > 0 AND g_rmf_t.rmf02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM rmf_file
                    WHERE rmf01 = g_rme.rme01 AND rmf02 = g_rmf_t.rmf02
                IF SQLCA.sqlcode THEN
        #           CALL cl_err(g_rmf_t.rmf02,SQLCA.sqlcode,0)# FUN-660111
                    CALL cl_err3("del","rmf_file",g_rme.rme01,g_rmf_t.rmf02,SQLCA.sqlcode,"","",1) #FUN-660111
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rmf[l_ac].* = g_rmf_t.*
               CLOSE t200_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_rmf[l_ac].rmf02,-263,1)
                LET g_rmf[l_ac].* = g_rmf_t.*
            ELSE
                IF g_rmf[l_ac].rmf02 = 0 OR g_rmf[l_ac].rmf02 IS NULL THEN
                   LET g_rmf[l_ac].rmf12=0
                   LET g_rmf[l_ac].rmf13=0
                   LET g_rmf[l_ac].rmf14=0
                   LET g_rmf[l_ac].rmf16=0
                   LET g_rmf[l_ac].rmf17=0
                   LET g_rmf[l_ac].rmf21='N'
                END IF
                UPDATE rmf_file SET
                       rmf21=g_rmf[l_ac].rmf21,
                       rmf12=g_rmf[l_ac].rmf12,
                       rmf13=g_rmf[l_ac].rmf13,
                       rmf14=g_rmf[l_ac].rmf14,
                       rmf16=g_rmf[l_ac].rmf16,
                       rmf17=g_rmf[l_ac].rmf17,
                       rmf31=g_rmf[l_ac].rmf31,
                       rmf33=g_rmf[l_ac].rmf33,
                       rmf25=g_rmf[l_ac].rmf25,
                       #FUN-840068 --start--
                       rmfud01 = g_rmf[l_ac].rmfud01,
                       rmfud02 = g_rmf[l_ac].rmfud02,
                       rmfud03 = g_rmf[l_ac].rmfud03,
                       rmfud04 = g_rmf[l_ac].rmfud04,
                       rmfud05 = g_rmf[l_ac].rmfud05,
                       rmfud06 = g_rmf[l_ac].rmfud06,
                       rmfud07 = g_rmf[l_ac].rmfud07,
                       rmfud08 = g_rmf[l_ac].rmfud08,
                       rmfud09 = g_rmf[l_ac].rmfud09,
                       rmfud10 = g_rmf[l_ac].rmfud10,
                       rmfud11 = g_rmf[l_ac].rmfud11,
                       rmfud12 = g_rmf[l_ac].rmfud12,
                       rmfud13 = g_rmf[l_ac].rmfud13,
                       rmfud14 = g_rmf[l_ac].rmfud14,
                       rmfud15 = g_rmf[l_ac].rmfud15
                       #FUN-840068 --end--
                   WHERE rmf01=g_rme.rme01 AND rmf02=g_rmf_t.rmf02
                IF SQLCA.sqlcode THEN
 #                  CALL cl_err('upd rmf',SQLCA.sqlcode,0)# FUN-660111
                   CALL cl_err3("upd","rmf_file",g_rme.rme01,g_rmf_t.rmf02,SQLCA.sqlcode,"","upd rmf",1) #FUN-660111
                   LET g_rmf[l_ac].* = g_rmf_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                   CALL t200_bu()
                END IF
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_rmf[l_ac].* = g_rmf_t.*
               END IF
               CLOSE t200_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           #CKP
           #LET g_rmf_t.* = g_rmf[l_ac].*          # 900423
            CLOSE t200_bcl
            COMMIT WORK

      # ON ACTION CONTROLN
      #     CALL t200_b_askkey()
      #     EXIT INPUT

      { ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(rmf21) AND l_ac > 1 THEN
                LET g_rmf[l_ac].* = g_rmf[l_ac-1].*
                LET g_rmf[l_ac].rmf02 = NULL
                NEXT FIELD rmf02
            END IF}

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG CALL cl_cmdask()

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
#NO.FUN-6B0031--BEGIN
        ON ACTION CONTROLS
           CALL cl_set_head_visible("","AUTO")
#NO.FUN-6B0031--END

      END INPUT
      UPDATE rme_file SET rmemodu = g_user,rmedate = g_today
        WHERE rme01 = g_rme.rme01
    CLOSE t200_bcl
    COMMIT WORK

END FUNCTION

FUNCTION t200_bu()

  #start FUN-650142 modify
  # SELECT SUM(rmf17) INTO g_rme.rme18 FROM rmf_file
  #  WHERE rmf01 = g_rme.rme01 AND rmf21="Y"
  # IF cl_null(g_rme.rme18) THEN LET g_rme.rme18 = 0 END IF
  #
  ##No.+323 010629 by plum
  ##LET g_rme.rme181 = g_rme.rme18 * g_rme.rme151
  # LET g_rme.rme181 = (g_rme.rme18 * g_rme.rme151)/100
  ##No.+323 ..end
  # LET g_rme.rme182 = g_rme.rme18 + g_rme.rme181

   #計算公式應參考稅別的設定,包括含稅及不含稅
    IF g_rme.rme153 = 'N'  THEN # 不內含
       SELECT SUM(rmf17) INTO g_rme.rme18 FROM rmf_file      #原幣應收未稅金額
        WHERE rmf01 = g_rme.rme01 AND rmf21="Y"
       IF cl_null(g_rme.rme18) THEN LET g_rme.rme18 = 0 END IF
       CALL cl_digcut(g_rme.rme18,t_azi04) RETURNING g_rme.rme18                #MOD-B90261 modify  g_azi04 -> t_azi04
       LET g_rme.rme181 = (g_rme.rme18 * g_rme.rme151)/100   #原幣應收稅額
       CALL cl_digcut(g_rme.rme181,t_azi04) RETURNING g_rme.rme181              #MOD-B90261 modify  g_azi04 -> t_azi04
       LET g_rme.rme182 = g_rme.rme18 + g_rme.rme181         #原幣應收含稅金額
       CALL cl_digcut(g_rme.rme182,t_azi04) RETURNING g_rme.rme182              #MOD-B90261 modify  g_azi04 -> t_azi04

      #LET g_rme.rme19 = g_rme.rme18 * g_rme.rme17           #本幣應收未稅金額  #CHI-840072 mark
       LET g_rme.rme19 = g_rme.rme18                         #原幣應收未稅金額  #CHI-840072
       CALL cl_digcut(g_rme.rme19,t_azi04) RETURNING g_rme.rme19
       LET g_rme.rme191 = (g_rme.rme19 * g_rme.rme151)/100   #本幣應收稅額
       CALL cl_digcut(g_rme.rme191,t_azi04) RETURNING g_rme.rme191
       LET g_rme.rme192 = g_rme.rme19 + g_rme.rme191         #本幣應收含稅金額
       CALL cl_digcut(g_rme.rme192,t_azi04) RETURNING g_rme.rme192              #MOD-B90261 modify  g_azi04 -> t_azi04
    ELSE
       SELECT SUM(rmf17) INTO g_rme.rme182 FROM rmf_file     #原幣應收含稅金額
        WHERE rmf01 = g_rme.rme01 AND rmf21="Y"
       IF cl_null(g_rme.rme182) THEN LET g_rme.rme182 = 0 END IF
       CALL cl_digcut(g_rme.rme182,t_azi04) RETURNING g_rme.rme182              #MOD-B90261 modify  g_azi04 -> t_azi04
       LET g_rme.rme18 = g_rme.rme182/(1+g_rme.rme151/100)   #原幣應收未稅金額
       CALL cl_digcut(g_rme.rme18,t_azi04) RETURNING g_rme.rme18                #MOD-B90261 modify  g_azi04 -> t_azi04
       LET g_rme.rme181 = g_rme.rme182 - g_rme.rme18         #原幣應收稅額
       CALL cl_digcut(g_rme.rme181,t_azi04) RETURNING g_rme.rme181

      #LET g_rme.rme192= g_rme.rme182 * g_rme.rme17          #本幣應收含稅金額  #CHI-840072 mark
       LET g_rme.rme192= g_rme.rme182                        #原幣應收含稅金額  #CHI-840072
       CALL cl_digcut(g_rme.rme192,t_azi04) RETURNING g_rme.rme192              #MOD-B90261 modify  g_azi04 -> t_azi04
       LET g_rme.rme19 = g_rme.rme192/(1+g_rme.rme151/100)   #本幣應收未稅金額
       CALL cl_digcut(g_rme.rme19,t_azi04) RETURNING g_rme.rme19
       LET g_rme.rme191 = g_rme.rme192 - g_rme.rme19         #本幣應收稅額
       CALL cl_digcut(g_rme.rme191,t_azi04) RETURNING g_rme.rme191              #MOD-B90261 modify  g_azi04 -> t_azi04
    END IF
  #end FUN-650142 modify

    UPDATE rme_file SET rme18 = g_rme.rme18,
                        rme181= g_rme.rme181,
                        rme182= g_rme.rme182,
                        rme19 = g_rme.rme19,    #FUN-650142 add
                        rme191= g_rme.rme191,   #FUN-650142 add
                        rme192= g_rme.rme192    #FUN-650142 add
                  WHERE rme01 = g_rme.rme01
    IF STATUS THEN
 #   CALL cl_err('_bu():upd rme',STATUS,0)# FUN-660111
    CALL cl_err3("upd","rme_file",g_rme.rme01,"",STATUS,"","rme_file",1) #FUN-660111
     END IF
    DISPLAY BY NAME g_rme.rme18,g_rme.rme181,g_rme.rme182,
                    g_rme.rme19,g_rme.rme191,g_rme.rme192
END FUNCTION

FUNCTION t200_b_move_to()
   LET g_rmf[l_ac].rmf02 = b_rmf.rmf02  LET g_rmf[l_ac].rmf03 = b_rmf.rmf03
   LET g_rmf[l_ac].rmf04 = b_rmf.rmf04  LET g_rmf[l_ac].rmf21 = b_rmf.rmf21
   LET g_rmf[l_ac].rmf12 = b_rmf.rmf12  LET g_rmf[l_ac].rmf14 = b_rmf.rmf14
   LET g_rmf[l_ac].rmf06 = b_rmf.rmf06  LET g_rmf[l_ac].rmf13 = b_rmf.rmf13
   LET g_rmf[l_ac].rmf16 = b_rmf.rmf16  LET g_rmf[l_ac].rmf17 = b_rmf.rmf17
   LET g_rmf[l_ac].rmf31 = b_rmf.rmf31  LET g_rmf[l_ac].rmf33 = b_rmf.rmf33
   LET g_rmf[l_ac].rmf31 = b_rmf.rmf25  LET g_rmf[l_ac].rmf061 = b_rmf.rmf061
   #FUN-840068 --start--
   LET g_rmf[l_ac].rmfud01 = b_rmf.rmfud01
   LET g_rmf[l_ac].rmfud02 = b_rmf.rmfud02
   LET g_rmf[l_ac].rmfud03 = b_rmf.rmfud03
   LET g_rmf[l_ac].rmfud04 = b_rmf.rmfud04
   LET g_rmf[l_ac].rmfud05 = b_rmf.rmfud05
   LET g_rmf[l_ac].rmfud06 = b_rmf.rmfud06
   LET g_rmf[l_ac].rmfud07 = b_rmf.rmfud07
   LET g_rmf[l_ac].rmfud08 = b_rmf.rmfud08
   LET g_rmf[l_ac].rmfud09 = b_rmf.rmfud09
   LET g_rmf[l_ac].rmfud10 = b_rmf.rmfud10
   LET g_rmf[l_ac].rmfud11 = b_rmf.rmfud11
   LET g_rmf[l_ac].rmfud12 = b_rmf.rmfud12
   LET g_rmf[l_ac].rmfud13 = b_rmf.rmfud13
   LET g_rmf[l_ac].rmfud14 = b_rmf.rmfud14
   LET g_rmf[l_ac].rmfud15 = b_rmf.rmfud15
   #FUN-840068 --end--
END FUNCTION

FUNCTION t200_b_move_back()
   LET b_rmf.rmf02 = g_rmf[l_ac].rmf02  LET b_rmf.rmf03 = g_rmf[l_ac].rmf03
   LET b_rmf.rmf04 = g_rmf[l_ac].rmf04  LET b_rmf.rmf21 = g_rmf[l_ac].rmf21
   LET b_rmf.rmf12 = g_rmf[l_ac].rmf12  LET b_rmf.rmf14 = g_rmf[l_ac].rmf14
   LET b_rmf.rmf06 = g_rmf[l_ac].rmf06  LET b_rmf.rmf13 = g_rmf[l_ac].rmf13
   LET b_rmf.rmf16 = g_rmf[l_ac].rmf16  LET b_rmf.rmf17 = g_rmf[l_ac].rmf17
   LET b_rmf.rmf31 = g_rmf[l_ac].rmf31  LET b_rmf.rmf33 = g_rmf[l_ac].rmf33
   LET b_rmf.rmf25 = g_rmf[l_ac].rmf25  LET b_rmf.rmf061 = g_rmf[l_ac].rmf061
   #FUN-840068 --start--
   LET b_rmf.rmfud01 = g_rmf[l_ac].rmfud01
   LET b_rmf.rmfud02 = g_rmf[l_ac].rmfud02
   LET b_rmf.rmfud03 = g_rmf[l_ac].rmfud03
   LET b_rmf.rmfud04 = g_rmf[l_ac].rmfud04
   LET b_rmf.rmfud05 = g_rmf[l_ac].rmfud05
   LET b_rmf.rmfud06 = g_rmf[l_ac].rmfud06
   LET b_rmf.rmfud07 = g_rmf[l_ac].rmfud07
   LET b_rmf.rmfud08 = g_rmf[l_ac].rmfud08
   LET b_rmf.rmfud09 = g_rmf[l_ac].rmfud09
   LET b_rmf.rmfud10 = g_rmf[l_ac].rmfud10
   LET b_rmf.rmfud11 = g_rmf[l_ac].rmfud11
   LET b_rmf.rmfud12 = g_rmf[l_ac].rmfud12
   LET b_rmf.rmfud13 = g_rmf[l_ac].rmfud13
   LET b_rmf.rmfud14 = g_rmf[l_ac].rmfud14
   LET b_rmf.rmfud15 = g_rmf[l_ac].rmfud15
   #FUN-840068 --end--
END FUNCTION

FUNCTION t200_delall()
    IF g_cnt = 0 THEN                   # 未輸入單身資料, 則取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM rme_file WHERE rme01 = g_rme.rme01
    END IF
END FUNCTION

FUNCTION t200_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
    CONSTRUCT l_wc2 ON rmf02,rmf03,rmf04,rmf21,rmf12,rmf13,rmf14,
                       rmf06,rmf16,rmf061,rmf17,rmf31,rmf33,rmf25
                       #No.FUN-840068 --start--
                       ,rmfud01,rmfud02,rmfud03,rmfud04,rmfud05
                       ,rmfud06,rmfud07,rmfud08,rmfud09,rmfud10
                       ,rmfud11,rmfud12,rmfud13,rmfud14,rmfud15
                       #No.FUN-840068 ---end---
            FROM s_rmf[1].rmf02, s_rmf[1].rmf03, s_rmf[1].rmf04, s_rmf[1].rmf21,
                 s_rmf[1].rmf12, s_rmf[1].rmf13, s_rmf[1].rmf14, s_rmf[1].rmf06,
                 s_rmf[1].rmf16, s_rmf[1].rmf061,s_rmf[1].rmf17, s_rmf[1].rmf31,
                 s_rmf[1].rmf33, s_rmf[1].rmf25
                 #No.FUN-840068 --start--
                 ,s_rmf[1].rmfud01,s_rmf[1].rmfud02,s_rmf[1].rmfud03
                 ,s_rmf[1].rmfud04,s_rmf[1].rmfud05,s_rmf[1].rmfud06
                 ,s_rmf[1].rmfud07,s_rmf[1].rmfud08,s_rmf[1].rmfud09
                 ,s_rmf[1].rmfud10,s_rmf[1].rmfud11,s_rmf[1].rmfud12
                 ,s_rmf[1].rmfud13,s_rmf[1].rmfud14,s_rmf[1].rmfud15
                 #No.FUN-840068 ---end---
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
    CALL t200_b_fill(l_wc2)
END FUNCTION

FUNCTION t200_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)

    LET g_sql =
        "SELECT rmf02,rmf03,rmf06,rmf061,rmf04,rmf21,rmf12,rmf13,rmf14,",
        "       rmf16,rmf17,rmf31,rmf33,rmf25, ",
        #No.FUN-840068 --start--
        "       rmfud01,rmfud02,rmfud03,rmfud04,rmfud05,",
        "       rmfud06,rmfud07,rmfud08,rmfud09,rmfud10,",
        "       rmfud11,rmfud12,rmfud13,rmfud14,rmfud15 ",
        #No.FUN-840068 ---end---
        " FROM rmf_file,rme_file ",
        " WHERE rmf01 ='",g_rme.rme01,"'",  #單頭
        " AND rmf01=rme01 ",
        " AND ",p_wc2 CLIPPED,              #單身
        " ORDER BY 1"

    PREPARE t200_pb FROM g_sql
    DECLARE rmf_curs                       #SCROLL CURSOR
        CURSOR FOR t200_pb

    CALL g_rmf.clear()
    LET g_cnt = 1
    FOREACH rmf_curs INTO g_rmf[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        #IF g_rmf[g_cnt].rmf21 IS NULL THEN   #NO:6935
        #   LET g_rmf[g_cnt].rmf21='Y'  END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #CKP
    CALL g_rmf.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION t200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rmf TO s_rmf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL t200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION previous
         CALL t200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION jump
         CALL t200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION next
         CALL t200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST


      ON ACTION last
         CALL t200_fetch('L')
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
         #CKP
         CALL cl_set_field_pic(g_rme.rmeconf,"","","","",g_rme.rmevoid)
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 單頭修改
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
    #@ON ACTION 扣帳
      ON ACTION deduct
         LET g_action_choice="deduct"
         EXIT DISPLAY
    #@ON ACTION 結案
      ON ACTION close_the_case
         LET g_action_choice="close_the_case"
         EXIT DISPLAY
    #@ON ACTION 取消結案
      ON ACTION undo_close
         LET g_action_choice="undo_close"
         EXIT DISPLAY
    #@ON ACTION 拋轉應收帳款
      ON ACTION carry_to_a_r
         LET g_action_choice="carry_to_a_r"
         EXIT DISPLAY
    #@ON ACTION 應收帳款查詢
      ON ACTION query_ar
         LET g_action_choice="query_ar"
         EXIT DISPLAY
    #@ON ACTION 用料成本重計
      ON ACTION recal_mat_cost
         LET g_action_choice="recal_mat_cost"
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

      ON ACTION exporttoexcel       #FUN-4B0035
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION related_document                #No.FUN-6A0018  相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY

      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#NO.FUN-6B0031--BEGIN
        ON ACTION CONTROLS
           CALL cl_set_head_visible("","AUTO")
#NO.FUN-6B0031--END
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION t200_y()               # when g_rme.rmeconf='N' (Turn to 'Y')
  #DEFINE g_start,g_end   LIKE apm_file.apm01     #No.FUN-690010 VARCHAR(10)
   DEFINE l_cnt LIKE type_file.num5               #No.FUN-690010 SMALLINT

  #IF NOT cl_confirm('aap-222') THEN RETURN END IF
#CHI-C30107 ----------------- add ----------------- begin
   IF g_rme.rme01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rme.rmevoid='N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rme.rmeconf="Y" THEN CALL cl_err('conf=Y',9023,0) RETURN END IF
   IF g_rme.rmegen ="N" THEN CALL cl_err('armt160','arm-542',0) RETURN END IF  
   IF g_rme.rme28 = "Y" THEN CALL cl_err('','aap-730',0)  RETURN END IF
   IF NOT cl_upsw(18,10,'N') THEN RETURN END IF 
#CHI-C30107 ----------------- add ----------------- end
   SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
   IF g_rme.rme01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rme.rmevoid='N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rme.rmeconf="Y" THEN CALL cl_err('conf=Y',9023,0) RETURN END IF
   IF g_rme.rmegen ="N" THEN CALL cl_err('armt160','arm-542',0) RETURN END IF   #No.MOD-650086 add
   IF g_rme.rme28 = "Y" THEN CALL cl_err('','aap-730',0)  RETURN END IF

#---BUGNO:7379---無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rmf_file
    WHERE rmf01=g_rme.rme01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
#---BUGNO:7379 END---------------

#  IF NOT cl_upsw(18,10,'N') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK LET g_success = 'Y'


    OPEN t200_cl USING g_rme.rme01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t200_cl ROLLBACK WORK RETURN
    END IF

   CALL t200_y1()
   IF g_success = 'Y' THEN
      LET g_rme.rmeconf='Y' COMMIT WORK
      CALL cl_cmmsg(3)
   ELSE
      LET g_rme.rmeconf='N' ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_rme.rmeconf
    #CKP
    CALL cl_set_field_pic(g_rme.rmeconf,"","","","",g_rme.rmevoid)
END FUNCTION

FUNCTION t200_y1()
   IF s_shut(0) THEN LET g_success = 'N' RETURN END IF
   UPDATE rme_file SET rmeconf = 'Y' WHERE rme01 = g_rme.rme01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
   #   CALL cl_err('upd rmeconf',STATUS,0)# FUN-660111
       CALL cl_err3("upd","rme_file",g_Rme.rme01,"",STATUS,"","upd rmeconf",1) #FUN-660111
       LET g_success = 'N' RETURN
   END IF
END FUNCTION

FUNCTION t200_z()       # when g_rme.rmeconf='Y' (Turn to 'N')
  DEFINE l_cnt     LIKE type_file.num5     #MOD-AA0009

   SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
   IF g_rme.rme01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rme.rmevoid='N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rme.rmeconf="N" THEN CALL cl_err('conf=N',9025,0) RETURN END IF
   IF g_rme.rmepost='Y' THEN CALL cl_err('post=Y','arm-035',0) RETURN END IF
   IF g_rme.rme28 = "Y" THEN CALL cl_err('','aap-730',0)  RETURN END IF

  #MOD-AA0009---add---start---
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM oma_file
    WHERE oma01 = g_rme.rme10
      AND oma00 = '14'
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN
      CALL cl_err(g_rme.rme01,'axm-610',1)
      RETURN
   END IF
  #MOD-AA0009---add---end---
   IF NOT cl_upsw(18,10,'Y') THEN RETURN END IF

   BEGIN WORK LET g_success = 'Y'


    OPEN t200_cl USING g_rme.rme01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t200_cl ROLLBACK WORK RETURN
    END IF

   CALL t200_z1()
   IF g_success = 'Y' THEN
      LET g_rme.rmeconf='N' COMMIT WORK
      CALL cl_cmmsg(3) sleep 1
   ELSE
      LET g_rme.rmeconf='Y' ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_rme.rmeconf
    #CKP
    CALL cl_set_field_pic(g_rme.rmeconf,"","","","",g_rme.rmevoid)
END FUNCTION

FUNCTION t200_z1()
   IF s_shut(0) THEN LET g_success = 'N' RETURN END IF
   UPDATE rme_file SET rmeconf = 'N' WHERE rme01 = g_rme.rme01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
 #     CALL cl_err('upd rmeconf',STATUS,0)# FUN-660111
       CALL cl_err3("upd","rme_file",g_rme.rme01,"",STATUS,"","upd rmeconf",1) #FUN-660111
       LET g_success = 'N' RETURN
   END IF
END FUNCTION

FUNCTION t200_s()                       # when g_rme.rmepost='N' (Turn to 'Y')
   DEFINE p_cmd         LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
   IF g_rme.rme01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rme.rmevoid='N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rme.rmeconf='N' THEN CALL cl_err('conf=N','aap-717',0) RETURN END IF
   IF g_rme.rmepost='Y' THEN CALL cl_err('post=Y','arm-035',0) RETURN END IF
   IF g_rme.rme28 = "Y" THEN CALL cl_err('','aap-730',0) RETURN END IF

   IF NOT cl_sure(0,0) THEN RETURN END IF
   BEGIN WORK LET g_success = 'Y'


    OPEN t200_cl USING g_rme.rme01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t200_cl ROLLBACK WORK RETURN
    END IF

   CALL t200_s1()
   IF g_success="Y" THEN
       LET g_rme.rmepost='Y'  #MOD-490245
      DISPLAY BY NAME g_rme.rmepost
      UPDATE rme_file SET rmepost='Y' WHERE rme01=g_rme.rme01
      COMMIT WORK
      CALL cl_cmmsg(3)
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION t200_s1()
   IF s_shut(0) THEN LET g_success = 'N' RETURN END IF
   UPDATE rmc_file SET rmc21 = '1',rmc22 = g_today
      WHERE rmc23 = g_rme.rme01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
  #    CALL cl_err('upd rmc:',STATUS,0)# FUN-660111
       CALL cl_err3("upd","rmc_file",g_Rme.rme01,"",STATUS,"","upd rmc:",1) #FUN-660111
       LET g_success = 'N'
   END IF
END FUNCTION

FUNCTION t200_g()
   DEFINE  l_cnt    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
           g_cmd    LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(300)

   IF s_shut(0) THEN RETURN END IF
   IF NOT cl_sure(0,0) THEN RETURN END IF
   SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
   IF g_rme.rme01 IS NULL THEN CALL cl_err('','aar-011',0) RETURN END IF
   IF g_rme.rmevoid='N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rme.rmeconf='N' THEN CALL cl_err('conf=N','aap-717',0) RETURN END IF
  #IF g_rme.rmepost='Y' THEN CALL cl_err('post=Y',9059,0) RETURN END IF
  #IF g_rme.rme28 = "Y" THEN CALL cl_err('','aap-730',0) RETURN END IF
  #No.+311 010628 by plum
   IF NOT cl_null(g_rme.rme10[4,10]) THEN
      CALL cl_err(g_rme.rme10,'arm-024',0) RETURN
   END IF
  #No.+311...end
   INPUT BY NAME g_rme.rme16,g_rme.rme17,
                 g_rme.rme19,g_rme.rme191,g_rme.rme192
            WITHOUT DEFAULTS

      AFTER FIELD rme16              #幣別: rme16 匯率->rme17
        IF NOT cl_null(g_rme.rme16) THEN
            IF g_rme.rme16 = 0 THEN
                NEXT FIELD rme16
            END IF
            SELECT azi01 INTO l_azi01 FROM azi_file WHERE azi01=g_rme.rme16
            IF STATUS THEN
       #        CALL cl_err('select azi',STATUS,0)# FUN-660111
                CALL cl_err3("sel","azi_file",g_Rme.rme16,"",STATUS,"","select azi",1) #FUN-660111
                NEXT FIELD rme16
            END IF
            IF g_rme.rme17=0 OR cl_null(g_rme.rme17) THEN
               CALL s_curr3(g_rme.rme16,g_rme.rme021,g_rmz.rmz15) RETURNING g_rme.rme17      #CHI-BC0035 rme02->rme021
               DISPLAY BY NAME g_rme.rme17
            END IF
            DISPLAY BY NAME g_rme.rme16
        END IF

      BEFORE FIELD rme17
           IF g_rme.rme16 = g_aza.aza17 THEN
              LET g_rme.rme17='1'
              DISPLAY BY NAME g_rme.rme17
           END IF
           DISPLAY BY NAME g_rme.rme17

      AFTER FIELD rme17
           IF NOT cl_null(g_rme.rme17) THEN
              IF g_rme.rme17 = 0 THEN
                  NEXT FIELD rme17
              END IF
           END IF

      AFTER FIELD rme19
         IF NOT cl_null(g_rme.rme19) THEN
             IF g_rme.rme19 = 0 THEN
                 NEXT FIELD rme19
             END IF
             #LET g_rme.rme191 = g_rme.rme19 * g_rme.rme151                #MOD-530655
              LET g_rme.rme191 = (g_rme.rme19 * g_rme.rme151) / 100        #MOD-530655
              CALL cl_digcut(g_rme.rme191,t_azi04) RETURNING g_rme.rme191  #MOD-530655
             LET g_rme.rme192 = g_rme.rme19 + g_rme.rme191
             DISPLAY BY NAME g_rme.rme19,g_rme.rme191,g_rme.rme192
         END IF

      ON ACTION CONTROLP
         CASE WHEN INFIELD(rme16)  # 幣別資料查詢
#                CALL q_azi(05,11,g_rme.rme16) RETURNING g_rme.rme16
#                CALL FGL_DIALOG_SETBUFFER( g_rme.rme16 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_rme.rme16
                 CALL cl_create_qry() RETURNING g_rme.rme16
#                 CALL FGL_DIALOG_SETBUFFER( g_rme.rme16 )
                 DISPLAY BY NAME g_rme.rme16
                 NEXT FIELD rme16
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
       LET g_rme.*=g_rme_t.*
       CALL t200_show()
       CALL cl_err('','9001',0)
       RETURN
   END IF
   BEGIN WORK LET g_success = 'Y'

   #No.+311 010628 by plum
   #IF cl_null(g_rme.rme10) THEN
    IF cl_null(g_rme.rme10) OR cl_null(g_rme.rme10[4,10]) THEN
   #No.+311...end
       LET g_rme.rme10=g_rmz.rmz11
       IF cl_null(g_rme.rme021) THEN
          LET g_rme.rme021=g_today
       END IF
       UPDATE rme_file SET rme16 = g_rme.rme16,
                           rme17 = g_rme.rme17,
                           rme19 = g_rme.rme19,
                           rme191= g_rme.rme191,
                           rme192= g_rme.rme192
                     WHERE rme01 = g_rme.rme01
       IF STATUS THEN
   #       CALL cl_err(g_rme.rme01,STATUS,0)# FUN-660111
           CALL cl_err3("upd","rme_file",g_rme_t.rme01,"",STATUS,"","",1) #FUN-660111
          LET g_rme.*=g_rme_t.*
          CALL t200_show()
          CALL cl_err('','9001',0)
          ROLLBACK WORK
       ELSE
          COMMIT WORK
          CALL cl_cmmsg(3)
       END IF
       LET g_cmd = "armp130 '",g_rme.rme01,"' '",g_rme.rme10,"' ",
                   "'",g_rme.rme021,"'"
       CALL cl_cmdrun_wait(g_cmd CLIPPED)
       SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
       DISPLAY BY NAME g_rme.rme10
   ELSE
      CALL cl_err(g_rme.rme10,'arm-024',0)
   END IF
END FUNCTION

FUNCTION t200_v(l_chk)
   DEFINE l_chk   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
   IF g_rme.rme01 IS NULL THEN CALL cl_err('','aar-011',0) RETURN END IF
   IF g_rme.rmevoid='N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF l_chk="Y" THEN
      IF g_rme.rme28 = "Y"   THEN CALL cl_err(' ','aap-730',0) RETURN END IF
      IF g_rme.rmeconf='N' THEN CALL cl_err('conf=N',9026,0) RETURN END IF
                                      #MOD-490245
      IF g_rme.rmepost='N' THEN CALL cl_err('post=N','aim-206',0) RETURN END IF
   ELSE
    #  IF g_rme.rme28 = "N" THEN RETURN END IF  #MOD-490245
       IF g_rme.rme28 = "N" THEN CALL cl_err('','9020',0) RETURN END IF  #MOD-490245      #No.TQC-740129
   END IF

   IF NOT cl_sure(0,0) THEN RETURN END IF

   BEGIN WORK LET g_success = 'Y'


    OPEN t200_cl USING g_rme.rme01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t200_cl ROLLBACK WORK RETURN
    END IF

    UPDATE rme_file SET rme28 = l_chk #MOD-490245
     WHERE rme01 = g_rme.rme01
   IF SQLCA.sqlerrd[3]=0 THEN
 #     CALL cl_err(' ','mfg0073',0)# FUN-660111
       CALL cl_err3("upd","rme_file",g_rme.rme01,"","mfg0073",""," ",1) #FUN-660111
       LET g_success="N"
   END IF
   IF g_success="Y" THEN
       LET g_rme.rme28=l_chk  #MOD-490245
      DISPLAY BY NAME g_rme.rme28
      COMMIT WORK
      CALL cl_cmmsg(3)
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION

#CHI-B60093 --- modify --- start ---
FUNCTION t200_get_ccc23(p_flag,p_ccc01,p_yy,p_mm)
   DEFINE p_ccc01      LIKE ccc_file.ccc01
   DEFINE p_flag       LIKE type_file.chr1
   DEFINE p_yy         LIKE ccc_file.ccc02
   DEFINE p_mm         LIKE ccc_file.ccc03
   DEFINE l_chr        LIKE type_file.chr1
   DEFINE l_ccc23      LIKE ccc_file.ccc23
   DEFINE l_ccc23_sum  LIKE ccc_file.ccc23
   DEFINE l_ccc02      LIKE ccc_file.ccc02
   DEFINE l_ccc03      LIKE ccc_file.ccc03
   DEFINE l_ccc02_t    LIKE ccc_file.ccc02
   DEFINE l_ccc03_t    LIKE ccc_file.ccc03
   DEFINE l_cnt        LIKE type_file.num5

   LET l_ccc23 = 0
   LET l_ccc23_sum = 0
   LET l_cnt = 0
   LET l_ccc02_t = NULL
   LET l_ccc03_t = NULL
   LET l_chr = 'N'
   IF p_flag = '1' THEN
      DECLARE ccc_ym CURSOR FOR
        SELECT ccc02,ccc03,ccc23 FROM ccc_file
         WHERE ccc01 = p_ccc01
           AND ccc07 = g_ccz.ccz28
           AND ccc02*12+ccc03<=p_yy*12+p_mm
         ORDER BY ccc02 DESC, ccc03 DESC
      IF g_ccz.ccz28 MATCHES "[12]" THEN
      #成本參數設定月加權平均
         FOREACH ccc_ym INTO l_ccc02,l_ccc03,l_ccc23
            LET l_ccc23_sum = l_ccc23
            LET l_cnt = l_cnt + 1
            LET l_chr = 'Y'
            EXIT FOREACH
         END FOREACH
      ELSE
         FOREACH ccc_ym INTO l_ccc02,l_ccc03,l_ccc23
            IF NOT cl_null(l_ccc02_t) AND NOT cl_null(l_ccc03_t)
               AND (l_ccc02 *12+ l_ccc03) <> (l_ccc02_t*12+l_ccc03_t) THEN
               EXIT FOREACH
            ELSE
               LET l_ccc23_sum = l_ccc23_sum + l_ccc23
               LET l_cnt = l_cnt + 1
               LET l_ccc02_t = l_ccc02
               LET l_ccc03_t = l_ccc03
               LET l_chr = 'Y'
            END IF
         END FOREACH
      END IF
   ELSE
      DECLARE cca_ym CURSOR FOR
         SELECT cca02,cca03,cca12 FROM cca_file
          WHERE cca01 = p_ccc01
           AND cca06 = g_ccz.ccz28
           AND cca02*12+cca03<=p_yy*12+p_mm
          ORDER BY cca02 DESC, cca03 DESC
      IF g_ccz.ccz28 MATCHES "[12]" THEN
      #成本參數設定月加權平均
         FOREACH cca_ym INTO l_ccc02,l_ccc03,l_ccc23
            LET l_ccc23_sum = l_ccc23
            LET l_cnt = l_cnt + 1
            LET l_chr = 'Y'
            EXIT FOREACH
         END FOREACH
      ELSE
         FOREACH cca_ym INTO l_ccc02,l_ccc03,l_ccc23
            IF NOT cl_null(l_ccc02_t) AND NOT cl_null(l_ccc03_t)
               AND (l_ccc02 *12+ l_ccc03) <> (l_ccc02_t*12+l_ccc03_t) THEN
               EXIT FOREACH
            ELSE
               LET l_ccc23_sum = l_ccc23_sum + l_ccc23
               LET l_cnt = l_cnt + 1
               LET l_ccc02_t = l_ccc02
               LET l_ccc03_t = l_ccc03
               LET l_chr = 'Y'
            END IF
         END FOREACH
      END IF
   END IF
   IF l_cnt = 0 THEN LET l_cnt = 1 END IF
   LET l_ccc23_sum = l_ccc23_sum / l_cnt
   IF l_chr = 'N' THEN
      RETURN NULL
   ELSE
      RETURN l_ccc23_sum
   END IF

END FUNCTION
#CHI-B60093 --- modify ---  end  ---



#genero
#單頭
FUNCTION t200_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rme01",TRUE)
   END IF

   IF INFIELD(rme16) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rme17",TRUE)
   END IF

END FUNCTION

FUNCTION t200_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rme01",FALSE)
   END IF

   IF INFIELD(rme16) OR (NOT g_before_input_done) THEN
       IF g_rme.rme17 = '1' AND g_rme.rme16 = g_aza.aza17 THEN
           CALL cl_set_comp_entry("rme17",FALSE)
       END IF
   END IF

END FUNCTION
#Patch....NO.TQC-610037 <001> #
