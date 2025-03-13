# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmt300.4gl
# Descriptions...: 客戶庫存異動作業
# Date & Author..: 06/03/13 By Sarah
# Modify.........: No.FUN-630027 06/03/13 By Sarah 新增"客戶庫存異動作業"
# Modify.........: No.FUN-630027 06/03/20 By yiting 修改
# Modify.........: No.FUN-660044 06/06/12 By Sarah 1.此程式若為'客戶庫存',則單頭'已轉出貨'應被隱藏
#                                                  2.單頭輸入員工,部門代號時,都沒帶名稱出來
#                                                  3.確認扣帳後,用atmq300無法查到此筆紀錄 (32區, DS1, 單號:302-06060001)
# Modify.........: No.FUN-660050 06/06/12 By Sarah 1.增加"作廢"功能
#                                                  2.當庫存異動類別為1.客戶銷售時,寫入tuq_file數量須*(-1)
# Modify.........: No.FUN-660104 06/06/20 By cl  Error Message 調整
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.TQC-680053 06/08/16 By Sarah 因為tuq_file的index key有包含批號(tuq03),若批號沒有輸入,需給一個空白值,不然會寫不進去
# Modify.........: No.TQC-680115 06/08/23 By Sarah 複製無法選擇單別
# Modify.........: No.FUN-680120 06/09/01 By chen 類型轉換
# Modify.........: No.FUN-690023 06/09/11 By jamie 判斷occacti
# Modify.........: No.FUN-690022 06/09/20 By jamie 判斷imaacti
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0043 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: Mo.TQC-6C0112 06/12/21 By day 復制功能有問題
# Modify.........: No.FUN-710033 07/02/02 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740135 07/04/26 By arman 作廢了的資料仍然可以過帳
# Modify.........: No.FUN-790001 07/09/03 By jamie PK問題
# Modify.........: No.TQC-790079 07/09/12 By lumxa 審核過帳后作廢，過帳圖標消失
# Modify.........: No.CHI-790021 07/09/17 By kim 修改-239的寫法
# Modify.........: No.MOD-810021 08/01/03 By Carol 複製insert tus_file 時tus12給預設值'N'
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/18 By TSD.Wind 自定欄位功能修改
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-8A0086 08/10/20 By lutingting調用s_showmsg_init(給g_totsuccess賦初始值,
#                                                      不然如果一次失敗,以后都無法成功
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.FUN-940135 09/04/29 By Carrier 去掉顏色的ATTRIBUTE設置
# Modify.........: No.TQC-940094 09/05/08 By mike 無效資料不可刪除       
# Modify.........: No.FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9B0142 09/11/20 By sherry 增加參數判斷庫存不足時候不可以過賬
# Modify.........: No.FUN-9C0073 10/01/11 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A70130 10/08/06 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No:FUN-A70130 10/08/12 By huangtao 修改開窗q_oay3
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.TQC-AB0001 10/11/04 By lilingyu 輸入異動單號時,開窗查詢單別資料仍然顯示無線單別,且AFTER Field未控管單別資料
# Modify.........: No.TQC-AC0236 10/12/20 By wangxin 修改異動單號后的判斷，添加“U4”的判斷
# Modify.........: No:MOD-B30651 11/03/30 by Summer 修改判別有效天數
# Modify.........: No:FUN-B50056 11/05/16 By lixiang 增加列印
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:CHI-B40056 11/07/05 by Summer 單身商品編號開窗不應該顯示所有料件編號,批號加開窗
# Modify.........: No:TQC-C30016 12/03/01 By suncx 狀態頁簽的“資料建立者”“資料建立部門”無法下查詢條件查詢資料
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/13 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:MOD-C60131 12/06/14 By Summer 因為atmt300與atmt310共用程式,請調整q_tup的tup11改用arg2傳值,依tus08判斷給值 
# Modify.........: No:MOD-C60139 12/06/15 By Elise AND tup11 = '1'的條件改為AND tup11 = g_tus.tus08 
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:TQC-CB0019 12/11/07 By xuxz ”客戶代號“欄位開窗條件添加occ31 = ‘Y'
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:TQC-CB0036 13/03/05 By jt_chen FUNCTION t300_tut03中tup_file的where條件增加tup03
# Modify.........: No:FUN-D30024 13/03/14 By fengrui 負庫存依據imd23判斷
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_tus     RECORD LIKE tus_file.*,       #客戶庫存調整單頭檔
    g_tus_t   RECORD LIKE tus_file.*,       #客戶庫存調整單頭檔(舊值)
    g_tus_o   RECORD LIKE tus_file.*,       #客戶庫存調整單頭檔(舊值)
    g_tus01_t        LIKE tus_file.tus01,   #庫存調整號(舊值)
    g_tut            DYNAMIC ARRAY OF RECORD    #客戶庫存調整單身檔
        tut02        LIKE tut_file.tut02,   #項次
        tut08        LIKE tut_file.tut08,   #異動類型
        tut03        LIKE tut_file.tut03,   #商品編號
        ima02        LIKE ima_file.ima02,   #品名
        tut05        LIKE tut_file.tut05,   #單位
        tut06        LIKE tut_file.tut06,   #數量
        tut04        LIKE tut_file.tut04,   #批號
        tut07        LIKE tut_file.tut07,   #備注
        tutud01      LIKE tut_file.tutud01,
        tutud02      LIKE tut_file.tutud02,
        tutud03      LIKE tut_file.tutud03,
        tutud04      LIKE tut_file.tutud04,
        tutud05      LIKE tut_file.tutud05,
        tutud06      LIKE tut_file.tutud06,
        tutud07      LIKE tut_file.tutud07,
        tutud08      LIKE tut_file.tutud08,
        tutud09      LIKE tut_file.tutud09,
        tutud10      LIKE tut_file.tutud10,
        tutud11      LIKE tut_file.tutud11,
        tutud12      LIKE tut_file.tutud12,
        tutud13      LIKE tut_file.tutud13,
        tutud14      LIKE tut_file.tutud14,
        tutud15      LIKE tut_file.tutud15
                     END RECORD,
    g_tut_t          RECORD                 #客戶庫存調整單身檔 (舊值)
        tut02        LIKE tut_file.tut02,   #項次
        tut08        LIKE tut_file.tut08,   #異動類型
        tut03        LIKE tut_file.tut03,   #商品編號
        ima02        LIKE ima_file.ima02,   #品名
        tut05        LIKE tut_file.tut05,   #單位
        tut06        LIKE tut_file.tut06,   #數量
        tut04        LIKE tut_file.tut04,   #批號
        tut07        LIKE tut_file.tut07,   #備注
        tutud01      LIKE tut_file.tutud01,
        tutud02      LIKE tut_file.tutud02,
        tutud03      LIKE tut_file.tutud03,
        tutud04      LIKE tut_file.tutud04,
        tutud05      LIKE tut_file.tutud05,
        tutud06      LIKE tut_file.tutud06,
        tutud07      LIKE tut_file.tutud07,
        tutud08      LIKE tut_file.tutud08,
        tutud09      LIKE tut_file.tutud09,
        tutud10      LIKE tut_file.tutud10,
        tutud11      LIKE tut_file.tutud11,
        tutud12      LIKE tut_file.tutud12,
        tutud13      LIKE tut_file.tutud13,
        tutud14      LIKE tut_file.tutud14,
        tutud15      LIKE tut_file.tutud15
                     END RECORD,
    g_argv1          LIKE tus_file.tus08,
    g_cmd            LIKE type_file.chr1000,        #No.FUN-680120 VARCHAR(200) 
    g_t1             LIKE oay_file.oayslip,           #No.FUN-680120 VARCHAR(05) #TQC-840066
    g_wc,g_sql,g_wc2 STRING,  #No.FUN-580092 HCN
    g_rec_b          LIKE type_file.num5,             #No.FUN-680120 SMALLINT             #單身筆數
    g_flag           LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
    l_ac             LIKE type_file.num5              #No.FUN-680120 SMALLINT             #目前處理的ARRAY CNT
DEFINE p_row,p_col   LIKE type_file.num5              #No.FUN-680120 SMALLINT
DEFINE g_forupd_sql  STRING     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt         LIKE type_file.num10            #No.FUN-680120 INTEGER
DEFINE g_chr         LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
DEFINE g_i           LIKE type_file.num5             #No.FUN-680120 SMALLINT   #count/index for any purpose
DEFINE g_msg         LIKE nab_file.nab03             #No.FUN-680120 VARCHAR(72)
DEFINE g_before_input_done  LIKE type_file.num5      #No.FUN-680120 SMLLINT
DEFINE g_row_count   LIKE type_file.num10            #No.FUN-680120 INTEGER
DEFINE g_curs_index  LIKE type_file.num10            #No.FUN-680120 INTEGER
DEFINE g_jump        LIKE type_file.num10            #No.FUN-680120 INTEGER
DEFINE mi_no_ask     LIKE type_file.num5             #No.FUN-680120 SMALLINT   #No.FUN-6A0072
 
#主程式開始
MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    LET g_argv1 = ARG_VAL(1)
 
    CASE g_argv1
       WHEN "1" LET g_prog = 'atmt300'
       WHEN "2" LET g_prog = 'atmt310'
       OTHERWISE 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
       EXIT PROGRAM
          
    END CASE
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ATM")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
    IF INT_FLAG THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
       EXIT PROGRAM 
    END IF
 
 
    LET g_tus01_t = NULL                   #清除鍵值
    INITIALIZE g_tus_t.* TO NULL
    INITIALIZE g_tus.* TO NULL
 
    LET p_row = 4 LET p_col = 8
    OPEN WINDOW t300_w AT p_row,p_col WITH FORM "atm/42f/atmt300"    #顯示畫面
         ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_init()
    CALL g_x.clear()
 
    CALL cl_set_comp_visible("tus12",g_argv1!='1')   #FUN-660044 add
 
    LET g_forupd_sql ="SELECT * FROM tus_file WHERE tus01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t300_cl CURSOR FROM g_forupd_sql
    CALL t300_menu()
 
    CLOSE WINDOW t300_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
#QBE 查詢資料
FUNCTION t300_cs()
    DEFINE l_arg1      LIKE aba_file.aba18           #No.FUN-680120 VARCHAR(2)
    DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   #No.FUN-580031
    DEFINE l_sql       STRING 
 
    CLEAR FORM                             #清除畫面
    CALL g_tut.clear()
    CASE g_argv1
    #   WHEN "1" LET l_arg1 = '02'
        WHEN "1" LET l_arg1 = 'U3'                #FUN-A70130
                LET l_sql  = " AND tus08 = '1' "
    #   WHEN "2" LET l_arg1 = '03'
        WHEN "2" LET l_arg1 = 'U4'                #FUN-A70130
                LET l_sql  = " AND tus08 = '2' "
    END CASE  
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    CONSTRUCT BY NAME g_wc ON
                 tus01,tus11,tus10,tus02,tus03,tus09,tus04,tus05,tus06,
                 tusconf,tuspost,tus12,
                #tususer,tusgrup,tusmodu,tusdate,tusacti,
                 tususer,tusgrup,tusmodu,tusdate,tusacti,tusoriu,tusorig,   #TQC-C30016 add tusoriu,tusorig
                 tusud01,tusud02,tusud03,tusud04,tusud05,
                 tusud06,tusud07,tusud08,tusud09,tusud10,
                 tusud11,tusud12,tusud13,tusud14,tusud15
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION CONTROLP
          CASE WHEN INFIELD(tus01)   #異動單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_oay3"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = l_arg1 
                    LET g_qryparam.arg2 = 'atm'              #FUN-A70130 add
                    LET g_qryparam.default1 = g_tus.tus01
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tus01
                    NEXT FIELD tus01
               WHEN INFIELD(tus10)   #原始單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_oay3"           #FUN-A70130 add
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = l_arg1
                    LET g_qryparam.arg2 = 'atm'                 
                    LET g_qryparam.default1 = g_tus.tus10
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tus10
                    NEXT FIELD tus10
               WHEN INFIELD(tus03)   #客戶編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_occ"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_tus.tus03
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tus03
                    NEXT FIELD tus03
               WHEN INFIELD(tus09)   #出貨客戶
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_occ"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_tus.tus09
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tus09
                    NEXT FIELD tus09
               WHEN INFIELD(tus04)   #員工編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_tus.tus04
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tus04
                    NEXT FIELD tus04
               WHEN INFIELD(tus05)   #部門編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_tus.tus05
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tus05
                    NEXT FIELD tus05
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
 
    CONSTRUCT g_wc2 ON tut02,tut08,tut03,tut05,tut06,tut04,tut07  #螢幕上取單身條件
                       ,tutud01,tutud02,tutud03,tutud04,tutud05
                       ,tutud06,tutud07,tutud08,tutud09,tutud10
                       ,tutud11,tutud12,tutud13,tutud14,tutud15
                  FROM s_tut[1].tut02,s_tut[1].tut08,s_tut[1].tut03,s_tut[1].tut05,
                       s_tut[1].tut06,s_tut[1].tut04,s_tut[1].tut07
                       ,s_tut[1].tutud01,s_tut[1].tutud02,s_tut[1].tutud03
                       ,s_tut[1].tutud04,s_tut[1].tutud05,s_tut[1].tutud06
                       ,s_tut[1].tutud07,s_tut[1].tutud08,s_tut[1].tutud09
                       ,s_tut[1].tutud10,s_tut[1].tutud11,s_tut[1].tutud12
                       ,s_tut[1].tutud13,s_tut[1].tutud14,s_tut[1].tutud15
 
       BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD (tut03)
#FUN-AA0059---------mod------------str-----------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form="q_ima"
#               LET g_qryparam.state="c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
               #CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret #CHI-B40056 mark
#FUN-AA0059---------mod------------end-----------------
                #CHI-B40056 add --start--
                CALL cl_init_qry_var()
                LET g_qryparam.form="q_tup" 
                LET g_qryparam.state="c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                #CHI-B40056 add --end--
                DISPLAY g_qryparam.multiret TO s_tut[1].tut03
                NEXT FIELD tut03
             #CHI-B40056 add --start--
             WHEN INFIELD (tut04)
                CALL cl_init_qry_var()
                LET g_qryparam.form="q_tup1" 
                LET g_qryparam.state="c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_tut[1].tut04
                NEXT FIELD tut04
             #CHI-B40056 add --end--
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
    IF INT_FLAG THEN  RETURN END IF
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tususer', 'tusgrup')
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT tus01 FROM tus_file ",
                  " WHERE ", g_wc CLIPPED,l_sql,
                  " ORDER BY 1"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE tus_file.tus01 ",
                  "  FROM tus_file, tut_file ",
                  " WHERE tus01 = tut01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,l_sql,
                  " ORDER BY 1"
    END IF
    PREPARE t300_prepare FROM g_sql
    IF SQLCA.sqlcode THEN CALL cl_err('prepare:',SQLCA.sqlcode,0) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
       EXIT PROGRAM 
    END IF
    DECLARE t300_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t300_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM tus_file WHERE ",g_wc CLIPPED,l_sql
    ELSE
        LET g_sql="SELECT COUNT(distinct tus01)",
                  " FROM tus_file,tut_file WHERE ",
                  " tus01=tut01 AND ",g_wc CLIPPED,
                  " AND ",g_wc2 CLIPPED,l_sql
    END IF
    PREPARE t300_precount FROM g_sql
    DECLARE t300_count CURSOR FOR t300_precount
END FUNCTION
 
#中文的MENU
FUNCTION t300_menu()
 DEFINE l_no LIKE tus_file.tus01     #No.FUN-B50056
 DEFINE l_wc STRING                  #No.FUN-B50056

   WHILE TRUE
      CALL t300_bp("G")
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t300_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t300_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t300_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t300_u()
            END IF
 
     #No.FUN-B50056--add-- 列印
         WHEN "output"
            IF cl_chk_act_auth() THEN
               LET l_no = g_tus.tus01
               LET l_wc='tus01="',l_no,'"'
               LET g_msg="atmr304",
                         " '",l_wc CLIPPED,"' ",
                         " '",g_today CLIPPED,"' ''",
                         " '",g_lang CLIPPED,"' '",g_bgjob CLIPPED,"'  '' '1'"
               CALL cl_cmdrun(g_msg)
            END IF
       #No.FUN-B50056--end--

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t300_x()
               CALL cl_set_field_pic(g_tus.tusconf,"",g_tus.tuspost,"","",g_tus.tusacti)  #NO.MOD-4B0082
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t300_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t300_copy()
            END IF
 
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t300_v(1)
              IF g_tus.tusconf="X" THEN    
                CALL cl_set_field_pic("","","","","Y",g_tus.tusacti) 
              END IF 
            END IF
         #FUN-D20039 -----------sta
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t300_v(2)
              IF g_tus.tusconf="X" THEN
                CALL cl_set_field_pic("","","","","Y",g_tus.tusacti)
              END IF
            END IF
         #FUN-D20039 -----------end
 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t300_y()
                CALL cl_set_field_pic(g_tus.tusconf,"",g_tus.tuspost,"","",g_tus.tusacti)  #NO.MOD-4B0082
            END IF
 
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t300_w()
                CALL cl_set_field_pic(g_tus.tusconf,"",g_tus.tuspost,"","",g_tus.tusacti)  #NO.MOD-4B0082
            END IF
 
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t300_s()
                CALL cl_set_field_pic(g_tus.tusconf,"",g_tus.tuspost,"","",g_tus.tusacti)  #NO.MOD-4B0082
            END IF
 
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t300_z()
                CALL cl_set_field_pic(g_tus.tusconf,"",g_tus.tuspost,"","",g_tus.tusacti)  #NO.MOD-4B0082
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tus.tus01 IS NOT NULL THEN
                 LET g_doc.column1 = "tus01"
                 LET g_doc.value1 = g_tus.tus01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
 
END FUNCTION
 
#Add  輸入
FUNCTION t300_a()
DEFINE li_result   LIKE type_file.num5             #No.FUN-680120 SMALLINT    #No.FUN-550026
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    #若非由MENU進入本程式,則無新增之功能
    CLEAR FORM
    CALL g_tut.clear()                                  # 清螢墓欄位內容
    INITIALIZE g_tus.* LIKE tus_file.*
    LET g_tus01_t = NULL
    LET g_tus_t.*=g_tus.*
    LET g_tus.tus02 = g_today                    #DEFAULT
    LET g_tus.tus04 = g_user                     #DEFAULT
    LET g_tus.tus05 = g_grup                     #DEFAULT
    CALL t300_tus04('d')
    IF cl_null(g_tus.tus04) THEN
       LET g_tus.tus04 = g_user
       DISPLAY BY NAME g_tus.tus04
    END IF
    CALL t300_tus05('d')
    IF cl_null(g_tus.tus05) THEN
       LET g_tus.tus05 = g_grup
       DISPLAY BY NAME g_tus.tus05
    END IF
    CASE g_argv1
       WHEN "1" LET g_tus.tus08 = '1' 
       WHEN "2" LET g_tus.tus08 = '2'
    END CASE
    LET g_tus.tus11 = '0'
    LET g_tus.tus12 = 'N'
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_tus.tusacti ='Y'                   #有效的資料
        LET g_tus.tusconf ='N'                   #有效的資料
        LET g_tus.tuspost ='N'                   #有效的資料
        LET g_tus.tususer = g_user
        LET g_tus.tusoriu = g_user #FUN-980030
        LET g_tus.tusorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_tus.tusgrup = g_grup               #使用者所屬群
        LET g_tus.tusdate = g_today
        CALL t300_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           INITIALIZE g_tus.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        IF g_tus.tus01 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK
        IF g_tus.tus08 = '1' THEN          #TQC-AC0236 add
           #CALL s_auto_assign_no("axm",g_tus.tus01,g_tus.tus02,"","tus_file","tus01","","","") #FUN-A70130
           CALL s_auto_assign_no("atm",g_tus.tus01,g_tus.tus02,"U3","tus_file","tus01","","","") #FUN-A70130
                RETURNING li_result,g_tus.tus01
           IF (NOT li_result) THEN
              CONTINUE WHILE
           END IF          
        #TQC-AC0236 add -----------------------begin----------------------------   
        ELSE 
           CALL s_auto_assign_no("atm",g_tus.tus01,g_tus.tus02,"U4","tus_file","tus01","","","") 
                RETURNING li_result,g_tus.tus01
           IF (NOT li_result) THEN
              CONTINUE WHILE
           END IF
        END IF
        #TQC-AC0236 add ------------------------end-----------------------------
        DISPLAY BY NAME g_tus.tus01
        LET g_tus.tusplant = g_plant #FUN-980009
        LET g_tus.tuslegal = g_legal #FUN-980009
 
        INSERT INTO tus_file VALUES(g_tus.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","tus_file",g_tus.tus01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
           CONTINUE WHILE
        END IF
        COMMIT WORK
        SELECT tus01 INTO g_tus.tus01 FROM tus_file
         WHERE tus01 = g_tus.tus01
        LET g_tus01_t = g_tus.tus01        #保留舊值
        LET g_tus_t.* = g_tus.*
        CALL g_tut.clear()
        LET g_rec_b=0
        CALL t300_b()                   #輸入單身
    SELECT * FROM tus_file WHERE tus01=g_tus.tus01
    IF SQLCA.sqlcode =0 THEN
    IF g_oay.oayconf = 'Y' THEN CALL t300_y() END IF #TQC-840066
    END IF
    EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t300_i(p_cmd)
    DEFINE
        l_sw            LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1) #檢查必要欄位是否空白
        p_cmd           LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
        l_n             LIKE type_file.num5,             #No.FUN-680120 SMALLINT
        l_obw           RECORD LIKE obw_file.*
    DEFINE li_result    LIKE type_file.num5             #No.FUN-680120 SMALLINT     #No.FUN-550026
    DEFINE l_cnt        LIKE type_file.num5             #No.FUN-680120 SMALLINT
    DEFINE l_tus11      LIKE tus_file.tus11
    DEFINE l_arg1       LIKE aba_file.aba18           #No.FUN-680120 VARCHAR(2)
 
    IF s_shut(0) THEN RETURN END IF
 
    CASE g_argv1
      # WHEN "1" LET l_arg1 = '02'  
      # WHEN "2" LET l_arg1 = '03'
        WHEN "1" LET l_arg1 = 'U3'
        WHEN "2" LET l_arg1 = 'U4'
    END CASE
 
    DISPLAY BY NAME g_tus.tus08,g_tus.tus01,g_tus.tus11,g_tus.tus10,
                    g_tus.tus02,g_tus.tus03,g_tus.tus09,g_tus.tus04,
                    g_tus.tus05,g_tus.tus06,g_tus.tus12,g_tus.tusconf,
                    g_tus.tuspost,g_tus.tususer,g_tus.tusgrup,
                    g_tus.tusmodu,g_tus.tusdate,g_tus.tusacti
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_tus.tus01,g_tus.tus10,g_tus.tus02,g_tus.tus03, g_tus.tusoriu,g_tus.tusorig,
                  g_tus.tus09,g_tus.tus11,g_tus.tus04,g_tus.tus05,
                  g_tus.tus06,g_tus.tusconf,g_tus.tuspost,
                  g_tus.tususer,g_tus.tus12,g_tus.tusgrup,
                  g_tus.tusmodu,g_tus.tusdate,g_tus.tusacti,
                  g_tus.tusud01,g_tus.tusud02,g_tus.tusud03,g_tus.tusud04,
                  g_tus.tusud05,g_tus.tusud06,g_tus.tusud07,g_tus.tusud08,
                  g_tus.tusud09,g_tus.tusud10,g_tus.tusud11,g_tus.tusud12,
                  g_tus.tusud13,g_tus.tusud14,g_tus.tusud15 
                  WITHOUT DEFAULTS HELP 1
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t300_set_entry(p_cmd)
           CALL t300_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("tus01")
 
     AFTER FIELD tus01
#           IF NOT cl_null(g_tus.tus01) AND (g_tus.tus01!=g_tus01_t) THEN    #TQC-AB0001
            IF NOT cl_null(g_tus.tus01) OR  (g_tus.tus01!=g_tus01_t) THEN    #TQC-AB0001
               IF g_tus.tus08 = '1' THEN          #TQC-AC0236 add
                  #CALL s_check_no("axm",g_tus.tus01,g_tus01_t,"","tus_file","tus01","") #FUN-A70130
                  CALL s_check_no("atm",g_tus.tus01,g_tus01_t,"U3","tus_file","tus01","") #FUN-A70130
                  RETURNING li_result,g_tus.tus01
                  DISPLAY BY NAME g_tus.tus01
                  IF (NOT li_result) THEN
                      NEXT FIELD tus01
                  END IF
               #TQC-AC0236 add -----------------------begin----------------------------   
               ELSE 
                  CALL s_check_no("atm",g_tus.tus01,g_tus01_t,"U4","tus_file","tus01","") 
                  RETURNING li_result,g_tus.tus01
                  DISPLAY BY NAME g_tus.tus01
                  IF (NOT li_result) THEN
                      NEXT FIELD tus01
                  END IF
               END IF
               #TQC-AC0236 add ------------------------end-----------------------------       
           END IF     
 
     AFTER FIELD tus03
           CALL t300_tus03('a')
           IF NOT cl_null(g_errno)  THEN
              CALL cl_err('',g_errno,0)
              LET g_tus.tus03 = g_tus_t.tus03
              DISPLAY BY NAME g_tus.tus03
              NEXT FIELD tus03
           END IF
 
        AFTER FIELD tus04
           CALL t300_tus04('a')
           IF NOT cl_null(g_errno)  THEN
              CALL cl_err('',g_errno,0)
              LET g_tus.tus04 = g_tus_t.tus04
              DISPLAY BY NAME g_tus.tus04
              NEXT FIELD tus04
           END IF
 
        AFTER FIELD tus05
           CALL t300_tus05('a')
           IF NOT cl_null(g_errno)  THEN
              CALL cl_err('',g_errno,0)
              LET g_tus.tus05 = g_tus_t.tus05
              DISPLAY BY NAME g_tus.tus05
              NEXT FIELD tus05
           END IF
 
        BEFORE FIELD tus09 
           IF NOT cl_null(g_tus.tus03) THEN
               LET g_tus.tus09 = g_tus.tus03
               DISPLAY BY NAME g_tus.tus09 
           END IF
 
     AFTER FIELD tus09
           CALL t300_tus09('a')
           IF NOT cl_null(g_errno)  THEN
              CALL cl_err('',g_errno,0)
              LET g_tus.tus09 = g_tus_t.tus09
              DISPLAY BY NAME g_tus.tus09
              NEXT FIELD tus09
           END IF
 
       #找出原始單號是否存在tus_file,且為作廢單號，如存在自動把目前單號的
       # 版次依最大版次+1
        AFTER FIELD tus10
           IF NOT cl_null(g_tus.tus10) THEN
              SELECT COUNT(*) INTO l_cnt 
                FROM tus_file
               WHERE tus01 = g_tus.tus10
                 AND tusconf = 'X'
              IF l_cnt > 0 THEN
                  SELECT MAX(tus11) INTO l_tus11
                    FROM tus_file
                   WHERE tus01 = g_tus.tus10
                     AND tusconf = 'X'
                  LET g_tus.tus11 = l_tus11 + 1
              END IF
           END IF
 
 
        AFTER FIELD tusud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tusud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tusud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tusud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tusud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tusud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tusud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tusud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tusud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tusud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tusud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tusud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tusud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tusud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tusud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
                    
        AFTER INPUT
           IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                 #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(tus01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_oay3"
                    LET g_qryparam.arg1 = l_arg1
                    LET g_qryparam.arg2 = 'atm'              #FUN-A70130 add
                    CALL cl_create_qry() RETURNING g_tus.tus01
                    DISPLAY BY NAME g_tus.tus01
                    NEXT FIELD tus01
                WHEN INFIELD(tus03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_occ"
                    LET g_qryparam.default1 = g_tus.tus03
                    LET g_qryparam.where = " occ31 = 'Y' "#TQC-CB0019
                    CALL cl_create_qry() RETURNING g_tus.tus03
                    DISPLAY BY NAME g_tus.tus03
                    NEXT FIELD tus03
                WHEN INFIELD(tus04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_tus.tus04
                    CALL cl_create_qry() RETURNING g_tus.tus04
                    DISPLAY BY NAME g_tus.tus04
                    NEXT FIELD tus04
                WHEN INFIELD(tus05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_tus.tus05
                    CALL cl_create_qry() RETURNING g_tus.tus05
                    DISPLAY BY NAME g_tus.tus05
                    NEXT FIELD tus05
                WHEN INFIELD(tus09)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_occ"
                    LET g_qryparam.default1 = g_tus.tus09
                    CALL cl_create_qry() RETURNING g_tus.tus09
                    DISPLAY BY NAME g_tus.tus09
                    NEXT FIELD tus09
                WHEN INFIELD(tus10)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_tus"
                    LET g_qryparam.arg1 = g_tus.tus08   #FUN-640014 modify
                    CALL cl_create_qry() RETURNING g_tus.tus10
                    DISPLAY BY NAME g_tus.tus10
                    NEXT FIELD tus10
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
END FUNCTION
 
FUNCTION t300_tus03(p_cmd)    #人員
 DEFINE p_cmd       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
        l_occ02     LIKE occ_file.occ02,
        l_occ31     LIKE occ_file.occ31,  #No.MOD-570124
        l_occacti   LIKE occ_file.occacti
 
  LET g_errno = ' '
  SELECT occ02,occ31,occacti INTO l_occ02,l_occ31,l_occacti FROM occ_file
   WHERE occ01 = g_tus.tus03
  IF cl_null(l_occ31) THEN LET l_occ31='N' END IF
 
  CASE WHEN SQLCA.SQLCODE = 100          LET g_errno = 'anm-045'
                                         LET g_tus.tus03 = NULL
       WHEN l_occacti='N'                LET g_errno = '9028'
       WHEN l_occacti MATCHES '[PH]'     LET g_errno = '9038'  #No.FUN-690023  add
 
       WHEN l_occ31='N'   LET g_errno = 'axd-115'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_occ02 TO FORMONLY.occ02
  END IF
END FUNCTION
 
FUNCTION t300_tut03(p_cmd)    #人員
 DEFINE p_cmd       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
        l_ima02     LIKE ima_file.ima02,
        l_ima25     LIKE ima_file.ima25,
        l_imaacti   LIKE ima_file.imaacti
 DEFINE l_tut04     LIKE tut_file.tut04   #TQC-CB0036 add
 
  LET g_errno = ' '
  #TQC-CB0036 -- add start --
  LET l_tut04 = g_tut[l_ac].tut04
  IF cl_null(l_tut04) THEN
     LET l_tut04=' '
  END IF
  #TQC-CB0036 -- add end --
 #CHI-B40056 mod --start--
 #SELECT ima02,imaacti,ima25
 #  INTO g_tut[l_ac].ima02,l_imaacti,g_tut[l_ac].tut05
 #  FROM ima_file 
 # WHERE ima01 = g_tut[l_ac].tut03
  SELECT ima02,imaacti,ima25
    INTO g_tut[l_ac].ima02,l_imaacti,g_tut[l_ac].tut05
    FROM tup_file LEFT OUTER JOIN ima_file ON tup02 = ima_file.ima01
   WHERE tup01 = g_tus.tus03
    #AND tup11 = '1'          #MOD-C60139 mark
     AND tup11 = g_tus.tus08  #MOD-C60139 
     AND tup05 > 0
     AND ima_file.imaacti = 'Y'
     AND tup02 = g_tut[l_ac].tut03
     AND tup03 = l_tut04   #TQC-CB0036 add
 #CHI-B40056 mod --end--
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'ams-003'  #No.MOD-570124
                                 LET g_tut[l_ac].tut03 = NULL
                                 LET g_tut[l_ac].tut05 = NULL
        WHEN l_imaacti='N' LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'   #No.FUN-690022 add
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  DISPLAY BY NAME g_tut[l_ac].ima02
  DISPLAY BY NAME g_tut[l_ac].tut05
END FUNCTION
 
FUNCTION t300_tus04(p_cmd)    #人員
 DEFINE p_cmd       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
        l_gen02     LIKE gen_file.gen02,
        l_genacti   LIKE gen_file.genacti
 
  LET g_errno = ' '
  SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
   WHERE gen01 = g_tus.tus04
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                                 LET g_tus.tus04 = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_gen02 TO FORMONLY.gen02
  END IF
END FUNCTION
 
FUNCTION t300_tus05(p_cmd)    #部門
 DEFINE p_cmd       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
        l_gem02     LIKE gem_file.gem02,
        l_gemacti   LIKE gem_file.gemacti
 
  LET g_errno = ' '
  SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
                          WHERE gem01 = g_tus.tus05
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                 LET g_tus.tus05 = NULL
       WHEN l_gemacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_gem02 TO FORMONLY.gem02
  END IF
END FUNCTION
 
FUNCTION t300_tus09(p_cmd)   #客戶
 DEFINE p_cmd       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
        l_occ02     LIKE occ_file.occ02,
        l_occacti   LIKE occ_file.occacti
 
  LET g_errno = ' '
  SELECT occ02,occacti INTO l_occ02,l_occacti FROM occ_file
   WHERE occ01 = g_tus.tus09
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-045'
                                 LET g_tus.tus09 = NULL
       WHEN l_occacti='N' LET g_errno = '9028'
       WHEN l_occacti MATCHES '[PH]' LET g_errno = '9038'   #No.FUN-690023 add
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_occ02 TO FORMONLY.occ02_2
  END IF
END FUNCTION
 
FUNCTION t300_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    LET g_tus.tus01 = NULL                   #NO.FUN-6B0043  add
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM	
    CALL g_tut.clear()
    DISPLAY '   ' TO FORMONLY.cnt            #ATTRIBUTE(GREEN)
    CALL t300_cs()                           #宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_tus.tus01 = NULL   #MOD-660086 add
        CLEAR FORM
        RETURN
    END IF
    OPEN t300_cs  #USING g_tus.tus01                   # 從DB產生合乎條件TEMP(0-30秒)
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_tus.* TO NULL                         #顯示合乎條件筆數
    ELSE
        OPEN t300_count
        FETCH t300_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t300_t('F')
    END IF
END FUNCTION
 
FUNCTION t300_t(p_flag)
    DEFINE
        p_flag           LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t300_cs INTO g_tus.tus01
        WHEN 'P' FETCH PREVIOUS t300_cs INTO g_tus.tus01
        WHEN 'F' FETCH FIRST    t300_cs INTO g_tus.tus01
        WHEN 'L' FETCH LAST     t300_cs INTO g_tus.tus01
        WHEN '/'
         IF (NOT mi_no_ask) THEN   #No.FUN-6A0072
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
         FETCH ABSOLUTE g_jump t300_cs INTO g_tus.tus01
         LET mi_no_ask = FALSE    #No.FUN-6A0072
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_tus.* TO NULL   #No.TQC-6B0105
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
 
    SELECT * INTO g_tus.* FROM tus_file            # 重讀DB,因TEMP有不被更新特性
     WHERE tus01 = g_tus.tus01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","tus_file",g_tus.tus01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
    ELSE
       LET g_data_owner=g_tus.tususer           #FUN-4C0052權限控管
       LET g_data_group=g_tus.tusgrup
       LET g_data_plant = g_tus.tusplant #FUN-980030
       CALL t300_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t300_show()
    LET g_tus_t.* = g_tus.*
    DISPLAY BY NAME g_tus.tus08,g_tus.tus01,g_tus.tus11,g_tus.tus10, g_tus.tusoriu,g_tus.tusorig,
                    g_tus.tus02,g_tus.tus03,g_tus.tus09,g_tus.tus04,
                    g_tus.tus05,g_tus.tus06,g_tus.tus12,g_tus.tusconf,
                    g_tus.tuspost,g_tus.tususer,g_tus.tusgrup,
                    g_tus.tusmodu,g_tus.tusdate,g_tus.tusacti,
                    g_tus.tusud01,g_tus.tusud02,g_tus.tusud03,g_tus.tusud04,
                    g_tus.tusud05,g_tus.tusud06,g_tus.tusud07,g_tus.tusud08,
                    g_tus.tusud09,g_tus.tusud10,g_tus.tusud11,g_tus.tusud12,
                    g_tus.tusud13,g_tus.tusud14,g_tus.tusud15 
    CALL cl_set_field_pic(g_tus.tusconf,"",g_tus.tuspost,"","",g_tus.tusacti)  #NO.MOD-4B0082
    CALL t300_tus03('d')
    CALL t300_tus04('d')
    CALL t300_tus05('d')
    CALL t300_tus09('d')
    CALL t300_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t300_u()
    IF s_shut(0) THEN RETURN END IF
    #若非由MENU進入本程式,則無更新之功能
    IF g_tus.tus01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    SELECT * INTO g_tus.* FROM tus_file WHERE tus01=g_tus.tus01
    IF g_tus.tusacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_tus.tus01,'mfg1000',0) RETURN
    END IF
    IF g_tus.tusconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_tus.tus01,'9022',0) RETURN
    END IF
    IF g_tus.tuspost ='Y' THEN    #檢查資料是否為過帳
        CALL cl_err(g_tus.tus01,'afa-101',0) RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_tus01_t = g_tus.tus01
    LET g_tus_t.* = g_tus.*
    LET g_tus_o.* = g_tus.*
    BEGIN WORK
    OPEN t300_cl USING g_tus.tus01
    IF STATUS THEN
       CALL cl_err("OPEN t300_cl:",STATUS,1)
       CLOSE t300_cl ROLLBACK WORK RETURN
    END IF
    FETCH t300_cl INTO g_tus.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_tus.tus01,SQLCA.sqlcode,0)
       CLOSE t300_cl ROLLBACK WORK RETURN
    END IF
    LET g_tus.tusmodu=g_user                     #修改者
    LET g_tus.tusdate = g_today                  #修改日期
    CALL t300_show()                             # 顯示最新資料
    WHILE TRUE
        CALL t300_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_tus.*=g_tus_t.*
            CALL t300_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_tus.tus01 != g_tus01_t THEN
            UPDATE tut_file SET tut01= g_tus.tus01
             WHERE tut01 = g_tus01_t
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","tut_file",g_tus01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
               CONTINUE WHILE
            END IF
        END IF
        UPDATE tus_file SET tus_file.* = g_tus.*    # 更新DB
         WHERE tus01 = g_tus01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tus_file",g_tus.tus01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t300_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t300_x()
    DEFINE
        l_chr LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_tus.tus01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_tus.tusconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_tus.tus01,'9022',0)
        RETURN
    END IF
    IF g_tus.tuspost ='Y' THEN    #檢查資料是否為過帳
        CALL cl_err(g_tus.tus01,'afa-101',0)
        RETURN
    END IF
    BEGIN WORK
    OPEN t300_cl USING g_tus.tus01
    IF STATUS THEN
       CALL cl_err("OPEN t300_cl:", STATUS, 1)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t300_cl INTO g_tus.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tus.tus01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t300_show()
    IF cl_exp(0,0,g_tus.tusacti) THEN
        LET g_chr=g_tus.tusacti
        IF g_tus.tusacti='Y' THEN
            LET g_tus.tusacti='N'
        ELSE
            LET g_tus.tusacti='Y'
        END IF
        UPDATE tus_file
           SET tusacti=g_tus.tusacti,
               tusmodu=g_user, tusdate=g_today
         WHERE tus01 = g_tus.tus01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","tus_file",g_tus.tus01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            LET g_tus.tusacti=g_chr
        END IF
        DISPLAY BY NAME g_tus.tusacti #ATTRIBUTE(RED)    #No.FUN-940135
    END IF
    CLOSE t300_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t300_v(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废

    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_tus.* FROM tus_file WHERE tus01=g_tus.tus01
    IF g_tus.tus01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_tus.tusconf='X' THEN RETURN END IF
    ELSE
       IF g_tus.tusconf<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
    IF g_tus.tusconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    LET g_success = 'Y'
 
    BEGIN WORK
 
    OPEN t300_cl USING g_tus.tus01
    IF STATUS THEN
       CALL cl_err("OPEN t300_cl:", STATUS, 1)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t300_cl INTO g_tus.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tus.tus01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t300_cl ROLLBACK WORK RETURN
    END IF
    CALL t300_show()
 
    IF cl_void(0,0,g_tus.tusconf) THEN                   #確認一下
       LET g_chr=g_tus.tusconf
       IF g_tus.tusconf='N' THEN
          LET g_tus.tusconf='X'
       ELSE
          LET g_tus.tusconf='N'
       END IF
       UPDATE tus_file SET tusconf=g_tus.tusconf,        #更改有效碼
                           tusmodu=g_user,
                           tusdate=g_today
                     WHERE tus01  =g_tus.tus01
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","tus_file",g_tus.tus01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
           LET g_tus.tusconf=g_chr
           LET g_success = 'N'
       END IF
    END IF
    CLOSE t300_cl
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_flow_notify(g_tus.tus01,'V')
    ELSE
       ROLLBACK WORK
    END IF
 
    SELECT tusconf,tusmodu,tusdate
      INTO g_tus.tusconf,g_tus.tusmodu,g_tus.tusdate 
      FROM tus_file
     WHERE tus01=g_tus.tus01
    DISPLAY BY NAME g_tus.tusconf,g_tus.tusmodu,g_tus.tusdate
 
END FUNCTION
 
FUNCTION t300_r()
    DEFINE l_chr LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_tus.tus01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_tus.tusconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_tus.tus01,'9022',0)
        RETURN
    END IF
    IF g_tus.tuspost ='Y' THEN    #檢查資料是否為過帳
        CALL cl_err(g_tus.tus01,'afa-101',0)
        RETURN
    END IF
    IF g_tus.tusacti='N' THEN                                                                                                       
       CALL cl_err(g_tus.tus01,'abm-950',0)                                                                                         
       RETURN                                                                                                                       
    END IF                                                                                                                          
    BEGIN WORK
    OPEN t300_cl USING g_tus.tus01
        IF STATUS THEN
       CALL cl_err("OPEN t300_cl:", STATUS, 1)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t300_cl INTO g_tus.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tus.tus01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t300_show()
    IF cl_delh(15,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "tus01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_tus.tus01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM tus_file WHERE tus01 = g_tus.tus01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","tus_file",g_tus.tus01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
        ELSE
           DELETE FROM tut_file WHERE tut01=g_tus.tus01
           CLEAR FORM
           CALL g_tut.clear()
           OPEN t300_count
           #FUN-B50064-add-start--
           IF STATUS THEN
              CLOSE t300_cs
              CLOSE t300_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50064-add-end-- 
           FETCH t300_count INTO g_row_count
           #FUN-B50064-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE t300_cs
              CLOSE t300_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50064-add-end-- 
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN t300_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL t300_t('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE     #No.FUN-6A0072
              CALL t300_t('/')
           END IF
        END IF
    END IF
    CLOSE t300_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION t300_b()
DEFINE
    l_buf           LIKE nab_file.nab03,             #No.FUN-680120 VARCHAR(80)             #儲存尚在使用中之下游檔案之檔名
    l_ac_t          LIKE type_file.num5,             #No.FUN-680120 SMALLINT             #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,             #No.FUN-680120 SMALLINT            #檢查重複用
    l_lock_sw       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)              #單身鎖住否
    p_cmd           LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)              #處理狀態
    l_bcur          LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)             #'1':表存放位置有值,'2':則為NULL
    l_allow_insert  LIKE type_file.num5,             #No.FUN-680120 SMALLINT              #可新增否
    l_allow_delete  LIKE type_file.num5              #No.FUN-680120 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_tus.tus01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_tus.* FROM tus_file WHERE tus01=g_tus.tus01
    IF g_tus.tusacti MATCHES'[Nn]' THEN
       CALL cl_err(g_tus.tus01,'mfg1000',0)
       RETURN
    END IF
    IF g_tus.tusconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_tus.tus01,'9022',0)
        RETURN
    END IF
    IF g_tus.tuspost ='Y' THEN    #檢查資料是否為過帳
        CALL cl_err(g_tus.tus01,'afa-101',0)
        RETURN
    END IF
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
    CALL cl_opmsg('b')
 LET g_forupd_sql="SELECT tut02,tut08,tut03,'',tut05,tut06,tut04,tut07,",
                     "       tutud01,tutud02,tutud03,tutud04,tutud05,",
                     "       tutud06,tutud07,tutud08,tutud09,tutud10,",
                     "       tutud11,tutud12,tutud13,tutud14,tutud15", 
                     " FROM tut_file",
                     "  WHERE tut02=? ",
	             " AND tut01=?",
                     " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t300_bcl CURSOR FROM g_forupd_sql
    LET l_ac_t = 0
 
        INPUT ARRAY g_tut WITHOUT DEFAULTS FROM s_tut.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)
 
    BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
    BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            BEGIN WORK
              OPEN t300_cl USING g_tus.tus01
              IF STATUS THEN
                 CALL cl_err("OPEN t300_cl:", STATUS, 1)
                 CLOSE t300_cl
                 ROLLBACK WORK
                 RETURN
              END IF
              FETCH t300_cl INTO g_tus.*               # 對DB鎖定
              IF SQLCA.sqlcode THEN
                CALL cl_err(g_tus.tus01,SQLCA.sqlcode,0)
                CLOSE t300_cl ROLLBACK WORK RETURN
              END IF
              IF g_rec_b >= l_ac THEN
                 LET p_cmd='u'
                 LET g_tut_t.* = g_tut[l_ac].*  #BACKUP
                 OPEN t300_bcl USING g_tut_t.tut02,g_tus.tus01              #表示更改狀態
 
               IF STATUS THEN
                  CALL cl_err("OPEN t300_bcl:", STATUS, 1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH t300_bcl INTO g_tut[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_tut_t.tut02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  CALL t300_tut03('d')
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_tut[l_ac].* TO NULL      #900423
            LET g_tut_t.* = g_tut[l_ac].*     #新輸入資料
            LET g_tut[l_ac].tut08 = "1"   #FUN-640014 add
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD tut02
 
    AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF cl_null(g_tut[l_ac].tut04) THEN LET g_tut[l_ac].tut04=' ' END IF   #FUN-660044 add
         INSERT INTO tut_file(tut01,tut02,tut03,tut04,tut05,tut06,tut07,tut08,
                                 tutud01,tutud02,tutud03,tutud04,tutud05,tutud06,
                                 tutud07,tutud08,tutud09,tutud10,tutud11,tutud12,
                                 tutud13,tutud14,tutud15,
                                 tutplant,tutlegal) #FUN-980009
                          VALUES(g_tus.tus01,
                                 g_tut[l_ac].tut02, g_tut[l_ac].tut03,
                                 g_tut[l_ac].tut04, g_tut[l_ac].tut05,
                                 g_tut[l_ac].tut06, g_tut[l_ac].tut07,
                                 g_tut[l_ac].tut08,
                                 g_tut[l_ac].tutud01,g_tut[l_ac].tutud02,
                                 g_tut[l_ac].tutud03,g_tut[l_ac].tutud04,
                                 g_tut[l_ac].tutud05,g_tut[l_ac].tutud06,
                                 g_tut[l_ac].tutud07,g_tut[l_ac].tutud08,
                                 g_tut[l_ac].tutud09,g_tut[l_ac].tutud10,
                                 g_tut[l_ac].tutud11,g_tut[l_ac].tutud12,
                                 g_tut[l_ac].tutud13,g_tut[l_ac].tutud14,
                                 g_tut[l_ac].tutud15,
                                 g_plant,g_legal)   #FUN-980009
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","tut_file",g_tut[l_ac].tut02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        BEFORE FIELD tut02                        # dgeeault 序號
            IF g_tut[l_ac].tut02 IS NULL or g_tut[l_ac].tut02 = 0 THEN
                SELECT max(tut02)+1 INTO g_tut[l_ac].tut02 FROM tut_file
                    WHERE tut01 = g_tus.tus01
                IF g_tut[l_ac].tut02 IS NULL THEN
                    LET g_tut[l_ac].tut02 = 1
                END IF
            END IF
 
        AFTER FIELD tut02
            IF NOT cl_null(g_tut[l_ac].tut02) AND
               (g_tut[l_ac].tut02 != g_tut_t.tut02 OR
                g_tut_t.tut02 IS NULL) THEN
                SELECT count(*) INTO l_n FROM tut_file
                 WHERE tut01 = g_tus.tus01
                   AND tut02 = g_tut[l_ac].tut02
                IF l_n > 0 THEN
                    CALL cl_err(g_tut[l_ac].tut02,-239,0)
                    LET g_tut[l_ac].tut02 = g_tut_t.tut02
                    NEXT FIELD tut02
                END IF
            END IF
 
        AFTER FIELD tut03
#FUN-AA0059 ---------------------start----------------------------
            IF NOT cl_null(g_tut[l_ac].tut03) THEN
               IF NOT s_chk_item_no(g_tut[l_ac].tut03,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_tut[l_ac].tut03 = g_tut_t.tut03
                  NEXT FIELD tut03
               END IF
#FUN-AA0059 ---------------------end-------------------------------
               CALL t300_tut03('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_tut[l_ac].tut03 = g_tut_t.tut03
                  DISPLAY BY NAME g_tut[l_ac].tut03
                 NEXT FIELD tut03
               END IF
             END IF                                            #FUN-AA0059
 
        AFTER FIELD tutud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tutud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tutud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tutud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tutud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tutud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tutud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tutud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tutud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tutud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tutud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tutud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tutud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tutud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tutud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_tut_t.tut02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM tut_file
                 WHERE tut01=g_tus.tus01 AND tut02 = g_tut_t.tut02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","tut_file",g_tut_t.tut02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
            END IF
            COMMIT WORK
 
    ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tut[l_ac].* = g_tut_t.*
               CLOSE t300_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tut[l_ac].tut02,-263,1)
               LET g_tut[l_ac].* = g_tut_t.*
            ELSE
               IF cl_null(g_tut[l_ac].tut04) THEN LET g_tut[l_ac].tut04=' ' END IF   #FUN-660044 add
            UPDATE tut_file SET(tut02,tut03,tut04,tut05,tut06,tut07,tut08,
                                   tutud01,tutud02,tutud03,tutud04,tutud05,                    
                                   tutud06,tutud07,tutud08,tutud09,tutud10,                    
                                   tutud11,tutud12,tutud13,tutud14,tutud15)                    
                                 =(g_tut[l_ac].tut02,g_tut[l_ac].tut03,
                                   g_tut[l_ac].tut04,g_tut[l_ac].tut05,
                                   g_tut[l_ac].tut06,g_tut[l_ac].tut07,
                                   g_tut[l_ac].tut08,
                                   g_tut[l_ac].tutud01,g_tut[l_ac].tutud02,
                                   g_tut[l_ac].tutud03,g_tut[l_ac].tutud04,
                                   g_tut[l_ac].tutud05,g_tut[l_ac].tutud06,
                                   g_tut[l_ac].tutud07,g_tut[l_ac].tutud08,
                                   g_tut[l_ac].tutud09,g_tut[l_ac].tutud10,
                                   g_tut[l_ac].tutud11,g_tut[l_ac].tutud12,
                                   g_tut[l_ac].tutud13,g_tut[l_ac].tutud14,
                                   g_tut[l_ac].tutud15)
 
                WHERE CURRENT OF t300_bcl
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err3("upd","tut_file",g_tut[l_ac].tut02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
                   LET g_tut[l_ac].* = g_tut_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
    AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30033 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_tut[l_ac].* = g_tut_t.*
               #FUN-D30033--add--begin--
               ELSE
                  CALL g_tut.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30033--add--end----
               END IF
               CLOSE t300_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30033 add
            CLOSE t300_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL t300_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(tut02) AND l_ac > 1 THEN
                LET g_tut[l_ac].* = g_tut[l_ac-1].*
                NEXT FIELD tut02
            END IF
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(tut03)
#FUN-AA0059---------mod------------str-----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_ima"
#                 LET g_qryparam.default1=g_tut[l_ac].tut03
#                 CALL cl_create_qry() RETURNING g_tut[l_ac].tut03
                 #CHI-B40056 mark --start--
                 #CALL q_sel_ima(FALSE, "q_ima","",g_tut[l_ac].tut03,"","","","","",'' ) 
                 #   RETURNING  g_tut[l_ac].tut03 
                 #CHI-B40056 mark --end--
#FUN-AA0059---------mod------------end-----------------
                 #CHI-B40056 add --start--
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tup"
                  LET g_qryparam.default1=g_tut[l_ac].tut03
                  LET g_qryparam.arg1=g_tus.tus03
                  LET g_qryparam.arg2=g_tus.tus08 #MOD-C60131 add
                  CALL cl_create_qry() RETURNING g_tut[l_ac].tut03
                 #CHI-B40056 add --end--
                  NEXT FIELD tut03
              #CHI-B40056 add --start--
                WHEN INFIELD(tut04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tup1" 
                  LET g_qryparam.default1=g_tut[l_ac].tut04
                  LET g_qryparam.arg1=g_tus.tus03 #CHI-B40056 add
                  CALL cl_create_qry() RETURNING g_tut[l_ac].tut04
                  NEXT FIELD tut04
              #CHI-B40056 add --end--
           END CASE
 
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
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
        END INPUT
 
     LET g_tus.tusmodu = g_user
     LET g_tus.tusdate = g_today
     UPDATE tus_file SET tusmodu = g_tus.tusmodu,tusdate = g_tus.tusdate
      WHERE tus01 = g_tus.tus01
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err3("upd","tus_file",g_tus.tus01,"",SQLCA.sqlcode,"","upd tus",1)  #No.FUN-660104
     END IF
     DISPLAY BY NAME g_tus.tusmodu,g_tus.tusdate
 
    CLOSE t300_bcl
    COMMIT WORK
#   CALL t300_delall() #CHI-C30002 mark
    CALL t300_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t300_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_tus.tus01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM tus_file ",
                  "  WHERE tus01 LIKE '",l_slip,"%' ",
                  "    AND tus01 > '",g_tus.tus01,"'"
      PREPARE t300_pb1 FROM l_sql 
      EXECUTE t300_pb1 INTO l_cnt
      
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
         CALL t300_v(1)
         IF g_tus.tusconf="X" THEN    
            CALL cl_set_field_pic("","","","","Y",g_tus.tusacti) 
         END IF 
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM  tus_file WHERE tus01 = g_tus.tus01
         INITIALIZE g_tus.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t300_delall()
#   SELECT COUNT(*) INTO g_cnt FROM tut_file
#    WHERE tut01 = g_tus.tus01
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM tus_file WHERE tus01 = g_tus.tus01
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t300_b_askkey()
DEFINE
    l_wc           LIKE type_file.chr1000         #No.FUN-680120 VARCHAR(200)
 
    CONSTRUCT l_wc ON tut02,tut03,tutd05,tut06,tut04,  #螢幕上取單身條件
                      tut07,tut08
                      ,tutud01,tutud02,tutud03,tutud04,tutud05
                      ,tutud06,tutud07,tutud08,tutud09,tutud10
                      ,tutud11,tutud12,tutud13,tutud14,tutud15
       FROM s_tut[1].tut02,s_tut[1].tut03,s_tut[1].tut05,
            s_tut[1].tut06,s_tut[1].tut04,s_tut[1].tut07,s_tut[1].tut08
            ,s_tut[1].tutud01,s_tut[1].tutud02,s_tut[1].tutud03
            ,s_tut[1].tutud04,s_tut[1].tutud05,s_tut[1].tutud06
            ,s_tut[1].tutud07,s_tut[1].tutud08,s_tut[1].tutud09
            ,s_tut[1].tutud10,s_tut[1].tutud11,s_tut[1].tutud12
            ,s_tut[1].tutud13,s_tut[1].tutud14,s_tut[1].tutud15
 
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ade03) #料件編號
#FUN-AA0059---------mod------------str-----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_ima"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY g_qryparam.multiret TO s_tut[1].tut03
                  NEXT FIELD tut03
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
          CALL cl_qbe_select()
       ON ACTION qbe_save
          CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t300_b_fill(l_wc)
END FUNCTION
 
FUNCTION t300_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000          #No.FUN-680120 VARCHAR(400)
 
    LET g_sql =
    "SELECT tut02,tut08,tut03,ima02,tut05,tut06,tut04,tut07,",
        "       tutud01,tutud02,tutud03,tutud04,tutud05,",
        "       tutud06,tutud07,tutud08,tutud09,tutud10,",
        "       tutud11,tutud12,tutud13,tutud14,tutud15", 
       " FROM tut_file,ima_file",
       " WHERE tut01 = '",g_tus.tus01,"'",       # AND ",p_wc CLIPPED , FUN-8B0123 mark
       "   AND ima01 = tut03 "
    IF NOT cl_null(p_wc) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc CLIPPED   
    END IF   
    LET g_sql=g_sql CLIPPED," ORDER BY 1 "     
    DISPLAY g_sql
 
    PREPARE t300_prepare2 FROM g_sql      #預備一下
    DECLARE tut_cs CURSOR FOR t300_prepare2
    CALL g_tut.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH tut_cs INTO g_tut[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_tut.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t300_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tut TO s_tut.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
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
         CALL t300_t('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION previous
         CALL t300_t('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION jump
         CALL t300_t('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION next
         CALL t300_t('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION last
         CALL t300_t('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

    #No.FUN-B50056--add--列印
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
    #No.FUN-B50056--end--
  
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
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
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#@    ON ACTION X.作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #FUN-D20039 ------------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 ------------end
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6B0043  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION t300_copy()
    DEFINE l_newno     LIKE tus_file.tus01
    DEFINE l_oldno     LIKE tus_file.tus01
    DEFINE li_result   LIKE type_file.num5             #No.FUN-680120 SMALLINT    #No.FUN-550026
    DEFINE l_arg1      LIKE aba_file.aba00             #No.FUN-680120 VARCHAR(2)     #TQC-680115 add
 
    IF s_shut(0) THEN RETURN END IF
    IF g_tus.tus01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL t300_set_entry('a')
    LET g_before_input_done = TRUE
 
    CASE g_argv1
     #  WHEN "1" LET l_arg1 = '02'     
     #  WHEN "2" LET l_arg1 = '03'
        WHEN "1" LET l_arg1 = 'U3'
        WHEN "2" LET l_arg1 = 'U4'
    END CASE
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT l_newno FROM tus01
        BEFORE INPUT
            CALL cl_set_docno_format("tus01")
 
        AFTER FIELD tus01
            IF l_newno IS NULL THEN
                NEXT FIELD tus01
            END IF
    #CALL s_check_no("axm",l_newno,"","","tus_file","tus01","")     #TQC-680115 #FUN-A70130
    CALL s_check_no("atm",l_newno,"","U3","tus_file","tus01","")      #FUN-A70130
         RETURNING li_result,l_newno
    DISPLAY l_newno TO tus01
       IF (NOT li_result) THEN
          NEXT FIELD tus01
       END IF
 
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(tus01)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_oay3"
                LET g_qryparam.arg1 = l_arg1
                LET g_qryparam.arg2 = 'atm'       #FUN-A70130
                CALL cl_create_qry() RETURNING l_newno
                DISPLAY l_newno TO tus01
                NEXT FIELD tus01
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
    IF INT_FLAG OR l_newno IS NULL THEN
        LET INT_FLAG = 0
        RETURN
    END IF
 
    IF g_tus.tus08 = '1' THEN          #TQC-AC0236 add
       #CALL s_auto_assign_no("axm",l_newno,g_today,"","tus_file","tus01","","","") #FUN-A70130
       CALL s_auto_assign_no("atm",l_newno,g_today,"U3","tus_file","tus01","","","") #FUN-A70130
            RETURNING li_result,l_newno
       IF (NOT li_result) THEN
          RETURN
       END IF          
    #TQC-AC0236 add -----------------------begin----------------------------   
    ELSE 
       CALL s_auto_assign_no("atm",l_newno,g_today,"U4","tus_file","tus01","","","") 
            RETURNING li_result,l_newno
       IF (NOT li_result) THEN
          RETURN
       END IF
    END IF
    #TQC-AC0236 add ------------------------end-----------------------------
    DISPLAY l_newno TO tus01
 
    DROP TABLE y
    SELECT * FROM tus_file
        WHERE tus01=g_tus.tus01
        INTO TEMP y
    UPDATE y
        SET y.tus01   = l_newno,    #資料鍵值
            y.tus02   = g_today,    #資料鍵值
            y.tus12   = 'N',        #MOD-810021-add
            y.tususer = g_user,
            y.tusgrup = g_grup,
            y.tusdate = g_today,
            y.tusacti = 'Y',
            y.tusconf = 'N',
            y.tuspost = 'N'
    INSERT INTO tus_file  #複製單頭
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","tus_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
    END IF
    DROP TABLE x
    SELECT * FROM tut_file
       WHERE tut01 = g_tus.tus01
       INTO TEMP x
    UPDATE x
       SET tut01 = l_newno
    INSERT INTO tut_file    #複製單身
       SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","tut_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K' ATTRIBUTE(REVERSE)
        LET l_oldno = g_tus.tus01
        LET g_tus.tus01 = l_newno  #No.TQC-6C0112
        SELECT tus_file.* INTO g_tus.* FROM tus_file     #No.TQC-6C0112
               WHERE tus01 =  l_newno
        CALL t300_u()
        CALL t300_b()
        #SELECT tus_file.* INTO g_tus.* FROM tus_file     #No.TQC-6C0112 #FUN-C80046
        #       WHERE tus01 = l_oldno  #FUN-C80046
    END IF
    DISPLAY BY NAME g_tus.tus01
END FUNCTION
 
FUNCTION t300_y() #確認
    IF g_tus.tus01 IS NULL THEN RETURN END IF
#CHI-C30107 ------------ add -------------- begin
    IF g_tus.tusacti='N' THEN
       CALL cl_err(g_tus.tus01,'mfg1000',0)
       RETURN
    END IF
    IF g_tus.tusconf='Y' THEN RETURN END IF
    IF g_tus.tuspost='Y' THEN RETURN END IF
    IF NOT cl_confirm('axm-108') THEN RETURN END IF 
#CHI-C30107 ------------ add -------------- end
    SELECT * INTO g_tus.* FROM tus_file WHERE tus01=g_tus.tus01
    IF g_tus.tusacti='N' THEN
       CALL cl_err(g_tus.tus01,'mfg1000',0)
       RETURN
    END IF
    IF g_tus.tusconf='Y' THEN RETURN END IF
    IF g_tus.tuspost='Y' THEN RETURN END IF
#   IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
 
    LET g_success='Y'
    BEGIN WORK
    OPEN t300_cl USING g_tus.tus01
    IF STATUS THEN
       CALL cl_err("OPEN t300_cl:", STATUS, 1)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t300_cl INTO g_tus.*  # 對DB鎖定
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_tus.tus01,SQLCA.sqlcode,0)
            CLOSE t300_cl
            ROLLBACK WORK
            RETURN
        END IF
 
    UPDATE tus_file SET tusconf='Y'
        WHERE tus01 = g_tus.tus01
    IF STATUS THEN
        CALL cl_err3("upd","tus_file",g_tus.tus01,"",STATUS,"","upd tusconf",1)  #No.FUN-660104
        LET g_success='N'
    END IF
    IF g_success = 'Y' THEN
        COMMIT WORK
        CALL cl_cmmsg(1)
    ELSE
        ROLLBACK WORK
        CALL cl_rbmsg(1)
    END IF
    SELECT tusconf INTO g_tus.tusconf FROM tus_file
        WHERE tus01 = g_tus.tus01
    DISPLAY BY NAME g_tus.tusconf
END FUNCTION
 
FUNCTION t300_w() #取消確認
    IF g_tus.tus01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tus.* FROM tus_file WHERE tus01=g_tus.tus01
    IF g_tus.tusconf='N' THEN RETURN END IF
    IF g_tus.tuspost='Y' THEN RETURN END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
    OPEN t300_cl USING g_tus.tus01
    IF STATUS THEN
       CALL cl_err("OPEN t202_cl:", STATUS, 1)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t300_cl INTO g_tus.*               # 對DB鎖定
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_tus.tus01,SQLCA.sqlcode,0)
            CLOSE t300_cl
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE tus_file SET tusconf='N'
            WHERE tus01 = g_tus.tus01
        IF STATUS THEN
            CALL cl_err3("upd","tus_file",g_tus.tus01,"",STATUS,"","upd cofconf",1)  #No.FUN-660104
            LET g_success='N'
        END IF
        IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_cmmsg(1)
        ELSE
            ROLLBACK WORK
            CALL cl_rbmsg(1)
        END IF
        SELECT tusconf INTO g_tus.tusconf FROM tus_file
            WHERE tus01 = g_tus.tus01
        DISPLAY BY NAME g_tus.tusconf
END FUNCTION
 
FUNCTION t300_s()
DEFINE l_cnt  LIKE type_file.num10            #No.FUN-680120 INTEGER
   IF s_shut(0) THEN RETURN END IF
   IF g_tus.tus01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
   SELECT * INTO g_tus.* FROM tus_file WHERE tus01=g_tus.tus01
 
   IF g_tus.tusacti='N' THEN
      CALL cl_err(g_tus.tus01,'mfg1000',0)
      RETURN
   END IF
   IF g_tus.tuspost = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_tus.tusconf = 'N' THEN CALL cl_err('','mfg3550',0) RETURN END IF
   IF g_tus.tusconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF    #NO.TQC-740135
 
   SELECT COUNT(*) INTO l_cnt FROM tut_file WHERE tut01=g_tus.tus01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('mfg0176') THEN RETURN END IF
 
   BEGIN WORK LET g_success = 'Y'
 
   OPEN t300_cl USING g_tus.tus01
   IF STATUS THEN
      CALL cl_err("OPEN t300_cl:", STATUS, 1)
      CLOSE t300_cl
      ROLLBACK WORK
      RETURN
   END IF    
   FETCH t300_cl INTO g_tus.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tus.tus01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t300_cl ROLLBACK WORK RETURN
   END IF
 
   CALL t300_s1()
   CALL s_showmsg()                      #No.FUN-8A0086
   IF SQLCA.SQLCODE THEN LET g_success='N' END IF
 
   IF g_success = 'Y' THEN
      UPDATE tus_file SET tuspost='Y' WHERE tus01=g_tus.tus01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd tuspost: ',SQLCA.SQLCODE,1)
         ROLLBACK WORK RETURN
      END IF
      LET g_tus.tuspost='Y'
      DISPLAY BY NAME g_tus.tuspost ATTRIBUTE(REVERSE)
      COMMIT WORK
   ELSE
      LET g_tus.tuspost='N'
      ROLLBACK WORK
   END IF
   MESSAGE ''
END FUNCTION
 
FUNCTION t300_s1()
  DEFINE b_tut   RECORD LIKE tut_file.*
  DEFINE p_tut   RECORD
                 tut03  LIKE tut_file.tut03,   #商品編號
                 tut04  LIKE tut_file.tut04,   #批號
                 tut05  LIKE tut_file.tut05,   #單位
                 tut08  LIKE tut_file.tut08,   #庫存異動類別   #FUN-660050 add
                 tut06  LIKE tut_file.tut06    #數量
                 END RECORD
 
  #對tut中的每一筆都要insert到tuq_file中
  DECLARE t300_s1_c1 CURSOR FOR
  SELECT * FROM tut_file WHERE tut01=g_tus.tus01
  CALL s_showmsg_init()                #No.FUN-8A0086
  FOREACH t300_s1_c1 INTO b_tut.*
      IF STATUS THEN 
         EXIT FOREACH 
         LET g_success = 'N'     #No.FUN-8A0086
      END IF
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
      IF cl_null(b_tut.tut03) THEN CONTINUE FOREACH END IF
      IF cl_null(b_tut.tut04) THEN LET b_tut.tut04 = ' ' END IF   #TQC-680053 add
      #當庫存異動類別為1.客戶銷售時,寫入tuq_file數量須*(-1)
      IF b_tut.tut08='1' THEN
         LET b_tut.tut06 = b_tut.tut06*(-1)
      END IF
      CALL t300_update1(b_tut.*)
      IF g_success='N' THEN 
        CONTINUE FOREACH #No.FUN-710033    
       END IF
  END FOREACH
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
  #之所以做group by是為了防止在tut_file中出現相同料號，相同批次的數據，且
  #其總數量和adp_file.adp05的和為大于零的值，但是由于先后順序中間會使adp05
  #的值小于零，而造成不能過帳的情況
  DECLARE t300_s1_c2 CURSOR FOR
   SELECT tut03,tut04,tut05,tut08,SUM(tut06)   #FUN-660050 add tut08
     FROM tut_file
    WHERE tut01=g_tus.tus01
    GROUP BY tut03,tut04,tut05,tut08           #FUN-660050 add tut08
  FOREACH t300_s1_c2 INTO p_tut.*
      IF STATUS THEN EXIT FOREACH END IF
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
      IF cl_null(p_tut.tut03) THEN CONTINUE FOREACH END IF
      IF cl_null(p_tut.tut04) THEN LET p_tut.tut04 = ' ' END IF   #TQC-680053 add
      #當庫存異動類別為1.客戶銷售時,寫入tuq_file數量須*(-1)
      IF p_tut.tut08='1' THEN
         LET p_tut.tut06 = p_tut.tut06*(-1)
      END IF
      CALL t300_update2(p_tut.*)
      IF g_success='N' THEN 
        CONTINUE FOREACH  #No.FUN-710033  
         END IF
  END FOREACH
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
END FUNCTION
 
FUNCTION t300_update1(p_tut)
  DEFINE p_tut  RECORD LIKE tut_file.*,
         l_buf  LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(60)
         l_cnt  LIKE type_file.num5            #No.FUN-680120 SMALLINT #FUN-660050 add
 
    #先檢查是否有同樣key值的資料存在
    SELECT COUNT(*) INTO l_cnt FROM tuq_file
     WHERE tuq01 = g_tus.tus03 AND tuq02 = p_tut.tut03
       AND tuq03 = p_tut.tut04 AND tuq04 = g_tus.tus02
       AND tuq05 = p_tut.tut01 AND tuq051= p_tut.tut02
       AND tuq11 = g_tus.tus08 AND tuq12 = g_tus.tus09
    IF l_cnt > 0 THEN   #已存在
       UPDATE tuq_file SET tuq07=tuq07+p_tut.tut06,
                           tuq09=tuq09+p_tut.tut06
        WHERE tuq01 = g_tus.tus03 AND tuq02 = p_tut.tut03
          AND tuq03 = p_tut.tut04 AND tuq04 = g_tus.tus02
          AND tuq05 = p_tut.tut01 AND tuq051= p_tut.tut02
          AND tuq11 = g_tus.tus08 AND tuq12 = g_tus.tus09
       IF STATUS THEN
          LET g_showmsg = g_tus.tus03,"/",p_tut.tut03,"/",p_tut.tut04,"/",g_tus.tus02,"/",p_tut.tut01,"/",p_tut.tut02,"/",g_tus.tus08,"/",g_tus.tus09     #No.FUN-710033
          CALL s_errmsg('tuq01,yuq02,tuq03,tuq04,tuq05,tuq051,tuq11,tuq12',g_showmsg,'update tuq',STATUS,1)  #No.FUN-710033  
          LET g_success='N' 
          RETURN
       END IF
    ELSE
       INSERT INTO tuq_file(tuq01,tuq02,tuq03,
                            tuq04,tuq05,tuq051,tuq06,                          #FUN-660044 add tuq051
                            tuq07,tuq08,tuq09,
                            tuq10,tuq11,tuq12,
                            tuqplant,tuqlegal) #FUN-980009
                     VALUES(g_tus.tus03,p_tut.tut03,p_tut.tut04,
                            g_tus.tus02,g_tus.tus01,p_tut.tut02,p_tut.tut05,   #FUN-660044 add p_tut.tut02
                            p_tut.tut06,1,p_tut.tut06,
                            '3',g_tus.tus08,g_tus.tus09,
                            g_plant,g_legal)   #FUN-980009
       IF SQLCA.sqlcode THEN
          IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #CHI-790021
             LET l_buf = p_tut.tut03 CLIPPED,' ',p_tut.tut04 CLIPPED
             CALL s_errmsg('','',l_buf,'axd-031',1)  #No.FUN-710033  
             LET g_success='N' RETURN
          ELSE
             LET l_buf = p_tut.tut03 CLIPPED,' ',p_tut.tut04 CLIPPED
             CALL s_errmsg('','',l_buf,SQLCA.sqlcode,1)  #No.FUN-710033         
             LET g_success='N' RETURN
          END IF
       END IF
    END IF   #FUN-660050 add
    MESSAGE p_tut.tut03,' ',p_tut.tut04,' post ok!'
    SLEEP 0.5
END FUNCTION
 
FUNCTION t300_update2(p_tut)
  DEFINE p_tut   RECORD
                 tut03  LIKE tut_file.tut03,   #商品編號
                 tut04  LIKE tut_file.tut04,   #批號
                 tut05  LIKE tut_file.tut05,   #單位
                 tut08  LIKE tut_file.tut08,   #庫存異動類別   #FUN-660050 add
                 tut06  LIKE tut_file.tut06    #數量
                 END RECORD,
         l_buf   LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(60)
         l_ima71 LIKE ima_file.ima71,
         l_tup05 LIKE tup_file.tup05,
         l_tup06 LIKE tup_file.tup06,   #FUN-640014 add
         l_cnt   LIKE type_file.num5             #No.FUN-680120 SMALLINT
 
    SELECT COUNT(*),SUM(tup05) INTO l_cnt,l_tup05 FROM tup_file
     WHERE tup01 = g_tus.tus03
       AND tup02 = p_tut.tut03 AND tup03 = p_tut.tut04
       AND tup11 = g_tus.tus08 AND tup12 = g_tus.tus09
    IF l_tup05 IS NULL THEN LET l_tup05 = 0 END IF
    IF l_tup05 + p_tut.tut06 < 0 THEN
      #IF g_sma.sma894[2,2]='N' AND p_tut.tut08 = '1' THEN #FUN-D30024 mark
       IF p_tut.tut08 = '1' THEN  #FUN-D30024 add
          CALL s_errmsg('tup01,tup02,tup03,tup11,tup12','','','mfg-026',1)
          LET g_success='N' RETURN
          END IF
    END IF
    IF l_cnt > 0 THEN   #已存在該客戶資料
 
       UPDATE tup_file SET tup05 = tup05 + p_tut.tut06
        WHERE tup01 = g_tus.tus03 
          AND tup02 = p_tut.tut03 AND tup03 = p_tut.tut04
          AND tup11 = g_tus.tus08 AND tup12 = g_tus.tus09
       IF STATUS THEN
          LET g_showmsg = g_tus.tus03,"/",p_tut.tut03,"/",p_tut.tut04,"/",g_tus.tus08,"/",g_tus.tus09   #No.FUN-710033
          CALL s_errmsg('tup01,tup02,tup03,tup11,tup12',g_showmsg,'update tup',STATUS,1)  #No.FUN-710033    
          LET g_success='N' RETURN
       END IF
    ELSE
       SELECT ima71 INTO l_ima71 FROM ima_file
        WHERE ima01 = p_tut.tut03
      #MOD-B30651 mod --start--
      #LET l_tup06 = l_ima71+g_tus.tus02   #FUN-640014 add
       IF SQLCA.sqlcode OR cl_null(l_ima71) THEN LET l_ima71=0 END IF
       IF l_ima71 = 0 THEN 
          LET l_tup06 = g_lastdat
       ELSE 
          LET l_tup06 = g_tus.tus02 + l_ima71
       END IF
      #MOD-B30651 mod --end--
       IF cl_null(p_tut.tut04) THEN LET p_tut.tut04=' ' END IF    #FUN-790001 add
       INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,
                            tup06,tup07,tup11,tup12,
                            tupplant,tuplegal) #FUN-980009
                     VALUES(g_tus.tus03,p_tut.tut03,p_tut.tut04,p_tut.tut05,
                            p_tut.tut06,l_tup06,g_tus.tus02,
                            g_tus.tus08,g_tus.tus09,
                            g_plant,g_legal)   #FUN-980009
       IF STATUS THEN
          CALL s_errmsg('','','insert tup',STATUS,1)  #No.FUN-710033     
          LET g_success='N' RETURN
       END IF
    END IF
 
    MESSAGE p_tut.tut03,' ',p_tut.tut04,' post ok!'
    SLEEP 0.5
END FUNCTION
 
FUNCTION t300_z()
DEFINE l_cnt  LIKE type_file.num10            #No.FUN-680120 INTEGER
   IF s_shut(0) THEN RETURN END IF
   IF g_tus.tus01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
   SELECT * INTO g_tus.* FROM tus_file WHERE tus01=g_tus.tus01
 
   IF g_tus.tuspost = 'N' THEN CALL cl_err('','mfg0178',0) RETURN END IF
   IF g_tus.tusconf = 'N' THEN CALL cl_err('','mfg3550',0) RETURN END IF
 
   IF NOT cl_confirm('asf-663') THEN RETURN END IF
 
   BEGIN WORK LET g_success = 'Y'
 
   OPEN t300_cl USING g_tus.tus01  #No.MOD-570124
   FETCH t300_cl INTO g_tus.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tus.tus01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t300_cl ROLLBACK WORK RETURN
   END IF
 
   CALL t300_z1()
   IF SQLCA.SQLCODE THEN LET g_success='N' END IF
 
   IF g_success = 'Y' THEN
      UPDATE tus_file SET tuspost='N' WHERE tus01=g_tus.tus01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","tus_file",g_tus.tus01,"",SQLCA.sqlcode,"","upd tuspost: ",1)  #No.FUN-660104
         ROLLBACK WORK RETURN
      END IF
      LET g_tus.tuspost='N'
      DISPLAY BY NAME g_tus.tuspost ATTRIBUTE(REVERSE)
      COMMIT WORK
   ELSE
      LET g_tus.tuspost='Y'
      ROLLBACK WORK
   END IF
   MESSAGE ''
END FUNCTION
 
FUNCTION t300_z1()
  DEFINE b_tut RECORD LIKE tut_file.*
  DEFINE p_tut RECORD
               tut03  LIKE tut_file.tut03,   #商品編號
               tut04  LIKE tut_file.tut04,   #批號
               tut05  LIKE tut_file.tut05,   #單位
               tut08  LIKE tut_file.tut08,   #庫存異動類別   #FUN-660050 add
               tut06  LIKE tut_file.tut06    #數量
               END RECORD
 
  #對于tut中的每一筆都要insert到tuq_file中
  DECLARE t300_z1_c1 CURSOR FOR SELECT * FROM tut_file WHERE tut01=g_tus.tus01
  FOREACH t300_z1_c1 INTO b_tut.*
      IF STATUS THEN EXIT FOREACH END IF
      IF cl_null(b_tut.tut03) THEN CONTINUE FOREACH END IF
      IF cl_null(b_tut.tut04) THEN LET b_tut.tut04 = ' ' END IF   #TQC-680053 add
      #當庫存異動類別為1.客戶銷售時,寫入tuq_file數量須*(-1)
      IF b_tut.tut08='1' THEN
         LET b_tut.tut06 = b_tut.tut06*(-1)
      END IF
      CALL t300_update3(b_tut.*)
      IF g_success='N' THEN RETURN END IF
  END FOREACH
  #之所以做group by是為了防止在tut_file中出現相同料號，相同批次的數據，且
  #其總數量和adp_file.adp05的和為大于零的值，但是由于先后順序中間會使tup05
  #的值小于零，而造成不能過帳的情況
  DECLARE t300_z1_c2 CURSOR FOR
   SELECT tut03,tut04,tut05,tut08,SUM(tut06)   #FUN-660050 add tut08
     FROM tut_file
    WHERE tut01=g_tus.tus01
    GROUP BY tut03,tut04,tut05,tut08           #FUN-660050 add tut08
  FOREACH t300_z1_c2 INTO p_tut.*
      IF STATUS THEN EXIT FOREACH END IF
      IF cl_null(p_tut.tut03) THEN CONTINUE FOREACH END IF
      IF cl_null(p_tut.tut04) THEN LET p_tut.tut04 = ' ' END IF   #TQC-680053 add
      #當庫存異動類別為1.客戶銷售時,寫入tuq_file數量須*(-1)
      IF p_tut.tut08='1' THEN
         LET p_tut.tut06 = p_tut.tut06*(-1)
      END IF
      CALL t300_update4(p_tut.*)
      IF g_success='N' THEN RETURN END IF
  END FOREACH
END FUNCTION
 
FUNCTION t300_update3(p_tut)
  DEFINE p_tut     RECORD LIKE tut_file.*,
         l_buf     LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(60)
         l_tuq09   LIKE tuq_file.tuq09   #FUN-660050 add
  
    DELETE FROM tuq_file 
     WHERE tuq01 = g_tus.tus03 AND tuq02 = p_tut.tut03
       AND tuq03 = p_tut.tut04 AND tuq04 = g_tus.tus02
       AND tuq05 = p_tut.tut01 AND tuq051= p_tut.tut02
       AND tuq11 = g_tus.tus08 AND tuq12 = g_tus.tus09
    IF STATUS THEN
       LET l_buf = p_tut.tut03 CLIPPED,' ',p_tut.tut04 CLIPPED
       CALL cl_err3("del","tuq_file",l_buf,"",STATUS,"","",1)  #No.FUN-660104
       LET g_success='N' RETURN
    END IF
    MESSAGE p_tut.tut03,' ',p_tut.tut04,' undo post ok!'
    SLEEP 0.5
END FUNCTION
 
FUNCTION t300_update4(p_tut)
  DEFINE p_tut   RECORD
                 tut03  LIKE tut_file.tut03,   #商品編號
                 tut04  LIKE tut_file.tut04,   #批號
                 tut05  LIKE tut_file.tut05,   #單位
                 tut08  LIKE tut_file.tut08,   #庫存異動類別   #FUN-660050 add
                 tut06  LIKE tut_file.tut06    #數量
                 END RECORD,
         l_buf   LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(60)
         l_tup05 LIKE tup_file.tup05,
         l_cnt   LIKE type_file.num5             #No.FUN-680120SMALLINT
 
 
    UPDATE tup_file SET tup05 = tup05 - p_tut.tut06
     WHERE tup01 = g_tus.tus03
       AND tup02 = p_tut.tut03 AND tup03 = p_tut.tut04
       AND tup11 = g_tus.tus08 AND tup12 = g_tus.tus09
    IF STATUS THEN
       CALL cl_err3("upd","tup_file",g_tus.tus03,p_tut.tut03,STATUS,"","update tup",1)  #No.FUN-660104
       LET g_success='N' RETURN
    END IF
 
    LET l_tup05 = 0
    SELECT tup05 INTO l_tup05 FROM tup_file
     WHERE tup01 = g_tus.tus03
       AND tup02 = p_tut.tut03 AND tup03 = p_tut.tut04
       AND tup11 = g_tus.tus08 AND tup12 = g_tus.tus09
    IF l_tup05 = 0 THEN
       DELETE FROM tup_file
        WHERE tup01 = g_tus.tus03
          AND tup02 = p_tut.tut03 AND tup03 = p_tut.tut04
          AND tup11 = g_tus.tus08 AND tup12 = g_tus.tus09
       IF STATUS THEN
          CALL cl_err3("del","tup_file",g_tus.tus03,p_tut.tut03,STATUS,"","delete tup",1)
          LET g_success='N' RETURN
       END IF
    END IF
 
    MESSAGE p_tut.tut03,' ',p_tut.tut04,'undo post ok!'
    SLEEP 0.5
END FUNCTION
 
FUNCTION t300_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("tus01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t300_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
      IF p_cmd = 'u' AND g_chkey = 'N' THEN
         CALL cl_set_comp_entry("tus01",FALSE)
      END IF
   END IF
 
END FUNCTION
#No.FUN-9C0073 --------------By chenls   10/01/11
