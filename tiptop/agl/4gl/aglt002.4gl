# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aglt002.4gl
# Descriptions...: 聯屬公司異動維護作業
# Date & Author..: 01/09/24 By Debbie Hsu
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.MOD-490360 Kammy INPUT ARRAY 未加without defaults
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0048 04/12/08 By Nicola 權限控管修改
# Modify.........: NO.MOD-420449 05/07/11 By Yiting key值可更改
# Modify.........: NO.FUN-580072 1.輸入公司代碼時check axz_file ,call t002_axz()
#                                2.增加變更agli002之axb11,axb12
#                                3.單身LAYOUT改用SCROLLGRID
# Modify.........: NO.FUN-590015 05/09/08 By Dido 1.增加單頭帳別自動帶入
#                                                 2.單身下層公司視窗修改
#                                                 3.SCROLLGRID無法轉Excel所以此功能予以取消
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: NO.MOD-630094 06/03/24 BY yiting 族群代號請開放可直接輸入,而非一定需經由(^P)挑選
# Modify.........: No.TQC-660043 06/06/16 By Smapmin 將資料庫代碼改為營運中心代碼
# Modify.........: No.FUN-660123 06/06/28 By Jackho cl_err --> cl_err3
# Modify.........: No.MOD-670034 06/07/07 By day 去掉多余call的q_axb
# Modify.........: No.FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740105 07/04/24 By Sarah 1.查詢後,單身"營運中心"及"資料庫名稱"未show 2.若為新的子公司加入時, 無法透過異動作業作增加的動作
# Modify.........: No.FUN-740174 07/04/25 By Sarah 新增公司,帳別合理性應要加判斷agli009
# Modify.........: No.TQC-740295 07/04/25 By Sarah 下層公司提供開窗功能,變更前無輸入應可輸入新公司
# Modify.........: No.FUN-740197 07/05/03 By Sarah 若資料確認時,單身異動出現'己確認(作廢)'訊息,此作業無作廢功能,請訊息修正
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760150 07/06/20 By Sarah 合併報表改善漏改部分修正
# Modify.........: No.MOD-780107 07/08/17 By Sarah 1.執行"確認"要將異動後資料寫回axb_file之前,需先判斷有變更的值才需回寫,更新axb_file應以key值更新,不分axz04
#                                                  2."營運中心名稱"改成"公司名稱",統一抓axz02
# Modify.........: No.TQC-790064 07/09/21 By xiaofeizhu 查詢時狀態欄是灰色的，無法錄入
# Modify.........: No.FUN-910001 09/05/20 By jan   單身增加axd13b(股本否),axd14b(會計科目),
#                                                  當axd13b=Y時,可維護持股比例、投資股數,axd13b=N時,可維護會計科目、記帳幣別金額
# Modify.........: No.FUN-910023 09/05/20 By jan   執行確認,金額回寫至agli011時,只寫異動額(修改後金額-修改前金額)
# Modify.........: No.FUN-920112 09/05/20 By jan   1.aglt002在單身"股本axd13b"欄位勾選為'N'時，會科axd14b及金額axd12a改為required,not null
#                                                  2.aglt002在抓取axe_file時，少了一個key值條件"合併前科目"(axe04 = axd14b) 造成撈到多筆會科資料 (#1870行)
#                                                  3.維護aglt002單身股本axd13b應給予預設值Y/N
# Modify.........: NO.FUN-920211 09/05/21 BY ve007 非股本時axd13b = 'N'，不回寫axb12
# Modify.........: NO.FUN-930081 09/05/21 BY ve007 股本axd13b"欄位勾選為'N'時，會科axd14b及金額axd12a改為required,not null
# Modify.........: NO.FUN-930056 09/05/21 BY ve007 
# Modify.........: NO.TQC-940005 09/05/29 BY jan 股本axd13b"欄位勾選為'Y'時，axd07b,axd11b改為required,not null
# Modify.........: NO.FUN-970048 09/07/20 By hongmei 增加axd13b為Y時，回寫axr_file 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0099 09/12/16 By jan GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现
# Modify.........: No:FUN-B20004 11/02/09 By destiny 科目查询自动过滤
# Modify.........: No:CHI-B30045 11/03/14 By zhangweib 單身" 股本否(axd13b)" 一律預設'Y' ,NOENTRY
# Modify.........: No:MOD-B30383 11/03/14 By zhangweib 取消回寫agli011程式段, aglt002只針對agli002作更新
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B90211 11/10/03 By Smapmin 人事table drop
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/08 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.MOD-CC0132 12/12/18 By Polly 調整抓取異動日期條件
# Modify.........: No:FUN-C50059 12/12/20 By Belle 原寫回axb_file欄位改寫至axbb_file
# Modify.........: No:CHI-C80041 13/01/04 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No.FUN-CC0105 13/01/11 By apo 挪用axd14b欄位來回寫"長期投資"(axbb10)
# Modify.........: No.FUN-D20050 13/02/25 By Lori 移除畫面上的"股本否"(axd13b)
# Modify.........: No.FUN-D20049 13/03/22 By Lori axd14b改為非必填
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
#模組變數(Module Variables)
DEFINE
    g_axc          RECORD LIKE axc_file.*,
    g_axc_t        RECORD LIKE axc_file.*,
    g_axc_o        RECORD LIKE axc_file.*,
    g_axc01_t      LIKE axc_file.axc01,
    g_axc02_t      LIKE axc_file.axc02,
    g_axc03_t      LIKE axc_file.axc03,
    g_axc06_t      LIKE axc_file.axc06,
    #g_cpf   RECORD LIKE cpf_file.*,   #TQC-B90211
    g_axd           DYNAMIC ARRAY OF RECORD
        axd04       LIKE axd_file.axd04,
        before      LIKE type_file.chr1,      #FUN-580072   #No.FUN-680098 VARCHAR(1)
        axd04b      LIKE axd_file.axd04b,
        azp02b      LIKE azp_file.azp02,
        azp03b      LIKE azp_file.azp03,
        axd05b      LIKE axd_file.axd05b,
        axd07b      LIKE axd_file.axd07b,
        axd08b      LIKE axd_file.axd08b,
        axd11b      LIKE axd_file.axd11b,     #FUN-580072
        axd12b      LIKE axd_file.axd12b,     #FUN-580072
        after       LIKE type_file.chr1,      #FUN-580072   #No.FUN-680098 VARCHAR(1)
        axd04a      LIKE axd_file.axd04a,
        azp02a      LIKE azp_file.azp02,
        azp03a      LIKE azp_file.azp03,
        axd05a      LIKE axd_file.axd05a,
       #axd13b      LIKE axd_file.axd13b,     #FUN-910001 add   #FUN-D20050 mark 
        axd07a      LIKE axd_file.axd07a,
        axd08a      LIKE axd_file.axd08a,
        axd11a      LIKE axd_file.axd11a,     #FUN-580072
        axd14b      LIKE axd_file.axd14b,     #FUN-910001 add
        axd12a      LIKE axd_file.axd12a      #FUN-580072
                    END RECORD,
    g_axd_t         RECORD
        axd04       LIKE axd_file.axd04,
        before      LIKE type_file.chr1,      #FUN-580072   #No.FUN-680098 VARCHAR(1)
        axd04b      LIKE axd_file.axd04b,
        azp02b      LIKE azp_file.azp02,
        azp03b      LIKE azp_file.azp03,
        axd05b      LIKE axd_file.axd05b,
        axd07b      LIKE axd_file.axd07b,
        axd08b      LIKE axd_file.axd08b,
        axd11b      LIKE axd_file.axd11b,     #FUN-580072
        axd12b      LIKE axd_file.axd12b,     #FUN-580072
        after       LIKE type_file.chr1,      #FUN-580072  #No.FUN-680098 VARCHAR(1)
        axd04a      LIKE axd_file.axd04a,
        azp02a      LIKE azp_file.azp02,
        azp03a      LIKE azp_file.azp03,
        axd05a      LIKE axd_file.axd05a,
       #axd13b      LIKE axd_file.axd13b,     #FUN-910001 add   #FUN-D20050 mark
        axd07a      LIKE axd_file.axd07a,
        axd08a      LIKE axd_file.axd08a,
        axd11a      LIKE axd_file.axd11a,     #FUN-580072
        axd14b      LIKE axd_file.axd14b,     #FUN-910001 add
        axd12a      LIKE axd_file.axd12a      #FUN-580072
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,               #No.FUN-580092 HCN      
    g_rec_b         LIKE type_file.num5,      #單身筆數        #No.FUN-680098 smallint
    g_j             LIKE type_file.num5,      #No.FUN-680098   smallint
    l_cmd           LIKE type_file.chr1000,   #No.FUN-680098   VARCHAR(300)
   #l_wc            LIKE type_file.chr1000,   #No.FUN-680098   VARCHAR(300) #MOD-CC0132 mark
    l_wc            STRING,                   #MOD-CC0132 add
    l_ac            LIKE type_file.num5,      #目前處理的ARRAY CNT        #No.FUN-680098 smallint
    g_before_input_done LIKE type_file.num5,  #No.FUN-680098  smallint
    g_forupd_sql    STRING,       
    g_axz04         LIKE axz_file.axz04       #NO.FUN-580072
DEFINE g_cnt        LIKE type_file.num10      #No.FUN-680098 integer
DEFINE g_msg        LIKE type_file.chr1000    #No.FUN-680098 VARCHAR(72) 
DEFINE g_row_count  LIKE type_file.num10      #No.FUN-680098 integer
DEFINE g_curs_index LIKE type_file.num10      #No.FUN-680098 integer
DEFINE g_jump       LIKE type_file.num10      #No.FUN-680098 integer
DEFINE mi_no_ask    LIKE type_file.num5       #No.FUN-680098 smallint
DEFINE g_axz03      LIKE axz_file.axz03       #FUN-920112 add
DEFINE l_axz        RECORD LIKE axz_file.*    #FUN-930056 add
DEFINE g_void       LIKE type_file.chr1       #CHI-C80041
DEFINE g_aaz641      LIKE aaz_file.aaz641     #FUN-CC0105
DEFINE g_plant_axz03 LIKE type_file.chr10     #FUN-CC0105

#主程式開始
MAIN
DEFINE p_row,p_col    LIKE type_file.num5            #No.FUN-680098 smallint
 
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
 
   LET g_forupd_sql = " SELECT * FROM axc_file WHERE axc06 = ? AND axc01 = ? AND axc02 = ? AND axc03 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t002_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 4 LET p_col = 18
   OPEN WINDOW t002_w AT p_row,p_col WITH FORM "agl/42f/aglt002"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL t002_menu()
   CLOSE WINDOW t002_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION t002_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_axd.clear()
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0029
 
    #-->螢幕上取單頭條件
    INITIALIZE g_axc.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON axc06,axc01,axc02,         #FUN-930056 mod 
                              axcuser,axcmodu,axcgrup,axcdate,  #No.TQC-790064 add
                              axcconf
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(axc01) #族群編號
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_axa"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO axc01
                NEXT FIELD axc01
             WHEN INFIELD(axc02) #工廠編號
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_axa3"          #FUN-930056 mod
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO axc02
                NEXT FIELD axc02
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
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('axcuser', 'axcgrup')
 
    CONSTRUCT g_wc2 ON axd04,axd04b,axd07b,axd11b,axd12b,axd08b, 
                            #axd04a,axd13b,axd07a,axd11a,axd14b,axd12a,axd08a   #FUN-910001 add axd13b,axd14b    #FUN-D20050 mark
                             axd04a,axd07a,axd11a,axd14b,axd12a,axd08a          #FUN-D20050 add
 
         FROM s_axd[1].axd04,
              s_axd[1].axd04b,                  #FUN-930056 mod
              s_axd[1].axd07b,s_axd[1].axd11b,
              s_axd[1].axd12b,s_axd[1].axd08b,  #FUN-580072
              s_axd[1].axd04a,                  #FUN-930056 mod   
             #s_axd[1].axd13b,                  #FUN-910001 add    #FUN-D20050 mark
              s_axd[1].axd07a,s_axd[1].axd11a,
              s_axd[1].axd14b,                  #FUN-910001 add
              s_axd[1].axd12a,s_axd[1].axd08a   #FUN-580072
       BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(axd04b)   #變更前下層公司
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_axz"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_axd[1].axd04b
                NEXT FIELD axd04b
             WHEN INFIELD(axd04a)   #變更後下層公司
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_axz"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_axd[1].axd04a #No.MOD-670034
                NEXT FIELD axd04a
             WHEN INFIELD(axd14b)   #會計科目
               #FUN-CC0105--str
               CALL s_get_aaz641(g_plant) RETURNING g_aaz641 
               CALL q_m_aag2(TRUE,TRUE,g_plant,g_axd[1].axd14b,'23',g_aaz641)         
                    RETURNING g_qryparam.multiret
               #FUN-CC0105--end
               #CALL q_m_aag2(TRUE,TRUE,g_plant,g_axd[1].axd14b,'23',g_axd[1].axd05b)         #TQC-9C0099  #FUN-CC0105 mark
               #     RETURNING g_qryparam.multiret                                            #FUN-CC0105 mark   
               DISPLAY g_qryparam.multiret TO s_axd[1].axd14b                 
               NEXT FIELD axd14b
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
 
       ON ACTION qbe_save
          CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  axc01,axc02,axc03,axc06 FROM axc_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY axc01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT axc_file. axc01,axc02,axc03,axc06 ",
                   "  FROM axc_file, axd_file ",
                   " WHERE axc01 = axd01 AND axc02 = axd02 AND axc03 = axd03",
                   "  AND axc06=axd00 ",
                   "  AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY axc01"
    END IF
 
    PREPARE t002_prepare FROM g_sql
    DECLARE t002_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t002_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM axc_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT axc01) FROM axc_file,axd_file ",
                  " WHERE axd00=axc06 AND axd01=axc01 AND axd02=axc02 ",
                  "   AND axd03=axc03 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t002_precount FROM g_sql
    DECLARE t002_count CURSOR FOR t002_precount
END FUNCTION
 
FUNCTION t002_menu()
 
   WHILE TRUE
      CALL t002_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t002_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t002_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t002_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t002_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t002_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t002_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t002_z()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_axc.axc01 IS NOT NULL THEN
                  LET g_doc.column1 = "axc01"
                  LET g_doc.value1 = g_axc.axc01
                  LET g_doc.column2 = "axc02"
                  LET g_doc.value2 = g_axc.axc02
                  LET g_doc.column3 = "axc03"
                  LET g_doc.value3 = g_axc.axc03
                  LET g_doc.column4 = "axc06"
                  LET g_doc.value4 = g_axc.axc06
                  CALL cl_doc()
               END IF
            END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t002_v()
               IF g_axc.axcconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_axc.axcconf,"","","",g_void,"")
            END IF
         #CHI-C80041---end 
      END CASE
   END WHILE
END FUNCTION
#Add  輸入
FUNCTION t002_a()
    IF s_aglshut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
   CALL g_axd.clear()
    INITIALIZE g_axc.* LIKE axc_file.*             #DEFAULT 設定
    LET g_axc01_t = NULL
    #預設值及將數值類變數清成零
    LET g_axc_t.* = g_axc.*
    LET g_axc_o.* = g_axc.*
    LET g_axc.axc06 = g_today
    LET g_axc.axcconf='N'
    LET g_axc.axcuser=g_user
    LET g_axc.axcoriu = g_user #FUN-980030
    LET g_axc.axcorig = g_grup #FUN-980030
    LET g_axc.axcdate=g_today
    LET g_axc.axcgrup=g_grup
    CALL cl_opmsg('a')
    BEGIN WORK
    WHILE TRUE
        CALL t002_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_axc.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            ROLLBACK WORK
            EXIT WHILE
        END IF
        IF cl_null(g_axc.axc06) OR cl_null(g_axc.axc01) OR  # KEY 不可空白
           cl_null(g_axc.axc02) OR cl_null(g_axc.axc03)
        THEN CONTINUE WHILE
        END IF
        INSERT INTO axc_file VALUES (g_axc.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
            CALL cl_err3("ins","axc_file",g_axc.axc01,g_axc.axc02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CONTINUE WHILE
        END IF
        COMMIT WORK
 
 
        SELECT axc06 INTO g_axc.axc06 FROM axc_file
         WHERE axc01=g_axc.axc01 AND axc02=g_axc.axc02 AND axc03=g_axc.axc03
           AND axc06=g_axc.axc06
        LET g_axc06_t = g_axc.axc06        #保留舊值
        LET g_axc01_t = g_axc.axc01        #保留舊值
        LET g_axc02_t = g_axc.axc02        #保留舊值
        LET g_axc03_t = g_axc.axc03        #保留舊值
        LET g_axc_t.* = g_axc.*
        CALL g_axd.clear()
        LET g_rec_b = 0
        CALL t002_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t002_u()
    IF s_aglshut(0) THEN RETURN END IF
    IF cl_null(g_axc.axc01) THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT axcconf INTO g_axc.axcconf FROM axc_file
     WHERE axc01 = g_axc.axc01 AND axc02 = g_axc.axc02
       AND axc03 = g_axc.axc03 AND axc06 = g_axc.axc06
    IF g_axc.axcconf='X' THEN RETURN END IF  #CHI-C80041
    IF g_axc.axcconf='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_axc01_t = g_axc.axc01
    LET g_axc02_t = g_axc.axc02
    LET g_axc03_t = g_axc.axc03
    LET g_axc06_t = g_axc.axc06
    LET g_axc_o.* = g_axc.*
    BEGIN WORK
    OPEN t002_cl USING g_axc.axc06,g_axc.axc01,g_axc.axc02,g_axc.axc03
    FETCH t002_cl INTO g_axc.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_axc.axc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t002_cl ROLLBACK WORK RETURN
    END IF
    LET g_axc.axcmodu = g_user
    LET g_axc.axcdate = g_today
    CALL t002_show()
    WHILE TRUE
        LET g_axc01_t = g_axc.axc01
        LET g_axc02_t = g_axc.axc02
        LET g_axc03_t = g_axc.axc03
        LET g_axc06_t = g_axc.axc06
        CALL t002_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_axc.*=g_axc_t.*
            CALL t002_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_axc.axc06 != g_axc06_t OR g_axc.axc01 != g_axc01_t OR
           g_axc.axc02 != g_axc02_t OR g_axc.axc03 != g_axc03_t THEN
           UPDATE axd_file SET axd00=g_axc.axc06,axd01=g_axc.axc01,
                               axd02=g_axc.axc02,axd03=g_axc.axc03
            WHERE axd00=g_axc06_t AND axd01 = g_axc01_t AND axd02=g_axc02_t
              AND axd03=g_axc03_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","axd_file",g_axc01_t,g_axc02_t,SQLCA.sqlcode,"","axd",1)  #No.FUN-660123
                CONTINUE WHILE
            END IF
        END IF
        UPDATE axc_file SET axc_file.* = g_axc.*
            WHERE axc06 = g_axc06_t AND axc01 = g_axc01_t AND axc02 = g_axc02_t AND axc03 = g_axc03_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","axc_file",g_axc01_t,g_axc02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t002_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION t002_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,       #判斷必要欄位是否有輸入        #No.FUN-680098 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改  #No.FUN-680098 VARCHAR(1)
    l_n,l_cnt       LIKE type_file.num5,       #No.FUN-680098  smallint
    l_axc06         LIKE axc_file.axc06
 
    DISPLAY BY NAME
        g_axc.axc06,g_axc.axc01,g_axc.axc02,g_axc.axc03,
        g_axc.axcconf,g_axc.axcuser,g_axc.axcgrup,
        g_axc.axcmodu,g_axc.axcdate
 
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
    INPUT BY NAME g_axc.axcoriu,g_axc.axcorig,
        g_axc.axc06,g_axc.axc01,g_axc.axc02,g_axc.axc03
        WITHOUT DEFAULTS
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t002_set_entry(p_cmd)
          CALL t002_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
        AFTER FIELD axc01  #族群編號
            IF NOT cl_null(g_axc.axc01) THEN
               SELECT count(*) INTO l_cnt FROM axa_file
                WHERE axa01=g_axc.axc01
               IF l_cnt = 0  THEN
                  CALL cl_err(g_axc.axc01,'agl-118',0)
                  LET g_axc.axc01 = g_axc_t.axc01
                  DISPLAY BY NAME g_axc.axc01
                  NEXT FIELD axc01
               END IF
            ELSE 
                CALL cl_err(g_axc.axc01,'mfg0037',0)
                NEXT FIELD axc01
            END IF
            LET g_axc_o.axc01 = g_axc.axc01
 
        BEFORE FIELD axc02 
            IF cl_null(g_axc.axc01) THEN
               CALL cl_err(g_axc.axc01,'mfg0037',0)
               NEXT FIELD axc01
            END IF
 
        AFTER FIELD axc02   #上層公司
            IF NOT cl_null(g_axc.axc02) THEN
               SELECT count(*) INTO l_cnt FROM axa_file
                WHERE axa01=g_axc.axc01 AND axa02=g_axc.axc02
               IF l_cnt = 0  THEN
                  CALL cl_err(g_axc.axc02,'agl-118',0)
                  LET g_axc.axc02 = g_axc_t.axc02
                  DISPLAY BY NAME g_axc.axc02
                  NEXT FIELD axc02
               END IF
 
               CALL t002_axc02('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_axc.axc02,g_errno,0)
                  NEXT FIELD axc02
               END IF
            END IF
            LET g_axc_o.axc02 = g_axc.axc02
 
        AFTER FIELD axc03   #上層帳別
            IF NOT cl_null(g_axc.axc03) THEN
               SELECT count(*) INTO l_cnt FROM axa_file
                WHERE axa01=g_axc.axc01 AND axa02=g_axc.axc02
                  AND axa03=g_axc.axc03
               IF l_cnt = 0  THEN
                  CALL cl_err(g_axc.axc03,'agl-118',0)
                  LET g_axc.axc03 = g_axc_t.axc03
                  DISPLAY BY NAME g_axc.axc03
                  NEXT FIELD axc03
               END IF
               #增加上層公司+帳別的合理性判斷,應存在agli009
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM axz_file
                WHERE axz01=g_axc.axc02 AND axz05=g_axc.axc03
               IF l_cnt = 0 THEN
                  CALL cl_err(g_axc.axc03,'agl-946',0)
                  NEXT FIELD axc03
               END IF
               #-->尚有未確認資料
               IF g_axc.axc01 != g_axc01_t OR g_axc01_t IS NULL OR
                  g_axc.axc02 != g_axc02_t OR g_axc02_t IS NULL OR
                  g_axc.axc03 != g_axc03_t OR g_axc03_t IS NULL OR
                  g_axc.axc06 != g_axc06_t OR g_axc03_t IS NULL THEN
                  SELECT count(*) INTO l_n FROM axc_file
                   WHERE axc01 = g_axc.axc01 AND axc02=g_axc.axc02
                     AND axc03 = g_axc.axc03 AND axcconf='N'
                   IF l_n > 0 THEN
                      CALL cl_err(g_axc.axc06,'agl-119',0)
                      NEXT FIELD axc01
                   END IF
               END IF
 
               #-->已存在較大日期者,不可再新增
               SELECT max(axc06) INTO l_axc06 FROM axc_file
                      WHERE axc01=g_axc.axc01 AND axc02=g_axc.axc02
                        AND axc03=g_axc.axc03
               IF NOT cl_null(l_axc06) AND l_axc06>=g_axc.axc06
               THEN CALL cl_err(g_axc.axc06,'agl-122',0)
                    NEXT FIELD axc01
               END IF
            END IF
 
        AFTER INPUT
           LET g_axc.axcuser = s_get_data_owner("axc_file") #FUN-C10039
           LET g_axc.axcgrup = s_get_data_group("axc_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
           LET l_flag='N'
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(axc01) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axa"
                 LET g_qryparam.default1 = g_axc.axc01
                 CALL cl_create_qry() RETURNING g_axc.axc01,g_axc.axc02,g_axc.axc03
                 DISPLAY BY NAME g_axc.axc01,g_axc.axc02,g_axc.axc03
                 NEXT FIELD axc01
              WHEN INFIELD(axc02) #上層公司編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axa3"          #FUN-930056 mod   #FUN-740174
                 LET g_qryparam.arg1 = g_axc.axc01      #FUN-930056 add
                 LET g_qryparam.default1 = g_axc.axc02
                 CALL cl_create_qry() RETURNING g_axc.axc02
                 DISPLAY BY NAME g_axc.axc02
                 NEXT FIELD axc02
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           DISPLAY g_fld_name,'yiting'
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
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
        ON ACTION controls                                        
           CALL cl_set_head_visible("","AUTO")                    
 
    END INPUT
END FUNCTION
 
FUNCTION  t002_axc02(p_cmd)
DEFINE p_cmd            LIKE type_file.chr1,  #No.FUN-680098 VARCHAR(1)
        l_axz02         LIKE axz_file.axz02,  #NO.FUN-580072
        l_axz03         LIKE axz_file.axz03,  #NO.FUN-580072
        l_axz05         LIKE axz_file.axz05,  #NO.FUN-590015
        l_azp03         LIKE azp_file.azp03   #TQC-660043
 
    LET g_errno = ' '
 
    SELECT axz02,axz03,axz05 INTO l_axz02,l_axz03,l_axz05
      FROM axz_file
     WHERE axz01 = g_axc.axc02
 
    CASE
       WHEN SQLCA.SQLCODE=100
          LET g_errno = 'mfg9142'
          LET l_axz02 = NULL
          LET l_axz03 = NULL
          LET l_axz05 = NULL
       OTHERWISE
          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
 
    LET g_axc.axc03=l_axz05   #FUN-930056 add
 
    SELECT azp03 INTO l_azp03 FROM azp_file where azp01 = l_axz03   #TQC-660043
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_axz02  TO FORMONLY.azp02
       DISPLAY l_azp03  TO FORMONLY.azp03   #TQC-660043
       DISPLAY l_axz05  TO axc03
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION t002_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_axc.* TO NULL              #No.FUN-6B0040
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_axd.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t002_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t002_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_axc.* TO NULL
    ELSE
        OPEN t002_count
        FETCH t002_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t002_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t002_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式        #No.FUN-680098   VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數      #No.FUN-680098   integer
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t002_cs INTO g_axc.axc01,
                                             g_axc.axc02,g_axc.axc03,g_axc.axc06
        WHEN 'P' FETCH PREVIOUS t002_cs INTO g_axc.axc01,
                                             g_axc.axc02,g_axc.axc03,g_axc.axc06
        WHEN 'F' FETCH FIRST    t002_cs INTO g_axc.axc01,
                                             g_axc.axc02,g_axc.axc03,g_axc.axc06
        WHEN 'L' FETCH LAST     t002_cs INTO g_axc.axc01,
                                             g_axc.axc02,g_axc.axc03,g_axc.axc06
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
            FETCH ABSOLUTE g_jump t002_cs INTO g_axc.axc01,
                                             g_axc.axc02,g_axc.axc03,g_axc.axc06
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_axc.axc01,SQLCA.sqlcode,0)
        INITIALIZE g_axc.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_axc.* FROM axc_file WHERE axc06 = g_axc.axc06 AND axc01 = g_axc.axc01 AND axc02 = g_axc.axc02 AND axc03 = g_axc.axc03
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","axc_file",g_axc.axc01,g_axc.axc02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
       INITIALIZE g_axc.* TO NULL
       RETURN
    ELSE
       LET g_data_owner = g_axc.axcuser     #No.FUN-4C0048
       LET g_data_group = g_axc.axcgrup     #No.FUN-4C0048
       CALL t002_show()
    END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t002_show()
 
    LET g_axc_t.* = g_axc.*                #保存單頭舊值
    DISPLAY BY NAME g_axc.axcoriu,g_axc.axcorig,
 
        g_axc.axc06,g_axc.axc01,g_axc.axc02,g_axc.axc03,
        g_axc.axcconf,g_axc.axcuser,g_axc.axcgrup,
        g_axc.axcmodu,g_axc.axcdate
    #CALL cl_set_field_pic(g_axc.axcconf,"","","","","")  #CHI-C80041
    IF g_axc.axcconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_axc.axcconf,"","","",g_void,"")  #CHI-C80041
    CALL t002_axc02('d')
    CALL t002_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t002_r()
  DEFINE l_n    LIKE type_file.num5          #No.FUN-680098 smallint
    IF s_aglshut(0) THEN RETURN END IF
    IF g_axc.axc01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    SELECT * INTO g_axc.* FROM axc_file
     WHERE axc01 = g_axc.axc01 AND axc02=g_axc.axc02 AND axc03=g_axc.axc03
       AND axc06 = g_axc.axc06
    IF g_axc.axcconf='X' THEN RETURN END IF  #CHI-C80041
    IF g_axc.axcconf='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    BEGIN WORK
    OPEN t002_cl USING g_axc.axc06,g_axc.axc01,g_axc.axc02,g_axc.axc03
    FETCH t002_cl INTO g_axc.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_axc.axc01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t002_cl ROLLBACK WORK RETURN
    END IF
    CALL t002_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "axc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_axc.axc01      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "axc02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_axc.axc02      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "axc03"         #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_axc.axc03      #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "axc06"         #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_axc.axc06      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM axc_file
        WHERE axc01 = g_axc.axc01 AND axc02 = g_axc.axc02
          AND axc03 = g_axc.axc03 AND axc06 = g_axc.axc06
       DELETE FROM axd_file WHERE axd01 = g_axc.axc01 AND axd02 = g_axc.axc02
          AND axd03 = g_axc.axc03 AND axd00 = g_axc.axc06
       INITIALIZE g_axc.* TO NULL
       CALL g_axd.clear()
       CLEAR FORM
       OPEN t002_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE t002_cl
          CLOSE t002_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end-- 
       FETCH t002_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t002_cl
          CLOSE t002_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t002_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t002_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t002_fetch('/')
       END IF
    END IF
    CLOSE t002_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION t002_b()
DEFINE
    l_ac_t          LIKE type_file.num5,           #未取消的ARRAY CNT #No.FUN-680098  smallint
    l_n,l_cnt,l_num,l_numcr,l_numma,l_nummi LIKE  type_file.num5,     #檢查重複用 #No.FUN-680098   smallint
    l_lock_sw       LIKE type_file.chr1,           #單身鎖住否        #No.FUN-680098 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,           #處理狀態          #No.FUN-680098 VARCHAR(1)
   #l_sql           LIKE type_file.chr1000,        #No.FUN-680098     VARCHAR(150) #MOD-CC0132 mark
    l_sql           STRING,                        #MOD-CC0132 add
    l_allow_insert  LIKE type_file.num5,           #可新增否          #No.FUN-680098 smallint
    l_allow_delete  LIKE type_file.num5,           #可刪除否          #No.FUN-680098 smallint
    l_cmd           LIKE type_file.chr1            #No.FUN-680098     VARCHAR(2)
 
DEFINE l_azp03a     LIKE type_file.chr21,          #FUN-920112 add
       l_axz04      LIKE axz_file.axz04,           #FUN-920112 add
       l_aag02      LIKE aag_file.aag02,           #FUN-920112 add
       l_n1         LIKE type_file.num5,           #FUN-920112 add
       l_axe06      LIKE axe_file.axe06            #FUN-930056 add
 
    LET g_action_choice = ""
 
    IF s_aglshut(0) THEN RETURN END IF
    IF cl_null(g_axc.axc01)  THEN RETURN END IF
    SELECT * INTO g_axc.* FROM axc_file
     WHERE axc01=g_axc.axc01 AND axc02=g_axc.axc02
       AND axc03=g_axc.axc03 AND axc06=g_axc.axc06
    IF g_axc.axcconf='X' THEN RETURN END IF  #CHI-C80041
    IF g_axc.axcconf='Y' THEN
       CALL cl_err("",'aap-005',0) RETURN         #FUN-740197 
    END IF
 
    CALL cl_opmsg('b')
 
 
    LET g_forupd_sql =
        "SELECT axd04,'0',axd04b,' ',' ',axd05b,axd07b,axd08b,axd11b,axd12b,",
       #"             '1',axd04a,' ',' ',axd05a,axd13b,axd07a,axd08a,axd11a,axd14b,axd12a",     #FUN-D20050 mark
        "             '1',axd04a,' ',' ',axd05a,axd07a,axd08a,axd11a,axd14b,axd12a",            #FUN-D20050 add
        "  FROM axd_file ",
        "  WHERE axd00=? AND axd01=? AND axd02=? ",
        "   AND axd03=? AND axd04=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t002_bcl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    INPUT ARRAY g_axd WITHOUT DEFAULTS FROM s_axd.* #No.MOD-490360
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
           #CALL cl_set_comp_entry("axd13b",FALSE)        #No.CHI-B30045    add     #FUN-D20050 mark
            BEGIN WORK
            OPEN t002_cl USING g_axc.axc06,g_axc.axc01,g_axc.axc02,g_axc.axc03
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_axc.axc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t002_cl ROLLBACK WORK RETURN






            ELSE
               FETCH t002_cl INTO g_axc.*            # 鎖住將被更改或取消的資料
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_axc.axc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                  CLOSE t002_cl ROLLBACK WORK RETURN
               END IF
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_axd_t.* = g_axd[l_ac].*  #BACKUP
                OPEN t002_bcl USING g_axc.axc06,g_axc.axc01,g_axc.axc02,
                                    g_axc.axc03 ,g_axd_t.axd04
                IF STATUS THEN
                   CALL cl_err("OPEN t002_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t002_bcl INTO g_axd[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_axd_t.axd04,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   SELECT axz02,azp03
                     INTO g_axd[l_ac].azp02b,g_axd[l_ac].azp03b
                     FROM axz_file LEFT OUTER JOIN azp_file ON axz03 = azp01    #MOD-780107 OUTER azp_file
                      WHERE axz01 = g_axd[l_ac].axd04b
                   IF SQLCA.sqlcode THEN LET g_axd[l_ac].azp02b = ' '
                                         LET g_axd[l_ac].azp03b = ' '
                   END IF
                   SELECT axz02,azp03
                     INTO g_axd[l_ac].azp02a,g_axd[l_ac].azp03a
                     FROM axz_file LEFT OUTER JOIN azp_file ON axz03 = azp01    #MOD-780107 OUTER azp_file
                      WHERE axz01 = g_axd[l_ac].axd04a
                   IF SQLCA.sqlcode THEN LET g_axd[l_ac].azp02a = ' '
                                         LET g_axd[l_ac].azp03a = ' '
                   END IF
 
                END IF
                CALL cl_show_fld_cont()         #FUN-550037(smin)
                CALL t002_set_entry_b()         #FUN-930056 add
                CALL t002_set_no_entry_b()      #FUN-930056 add
                CALL t002_set_no_required_b()   #FUN-930081
                CALL t002_set_required_b()      #FUN-930081
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_axd[l_ac].* TO NULL      #900423
           LET g_axd[l_ac].before = '0'
           LET g_axd[l_ac].after  = '1'
           LET g_axd_t.* = g_axd[l_ac].*         #新輸入資料
          #LET g_axd[l_ac].axd13b = 'Y'          #No.CHI-B30045  add   #FUN-D20050 mark
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           CALL t002_set_entry_b()         #FUN-930056 add
           CALL t002_set_no_entry_b()      #FUN-930056 add
           CALL t002_set_no_required_b()  #FUN-930081
           CALL t002_set_required_b()    #FUN-930081
           NEXT FIELD axd04
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO axd_file (axd00,axd01,axd02,axd03,axd04,
                                  axd04b,axd05b,axd07b,axd08b,axd11b,axd12b,
                                  axd04a,axd05a,axd07a,axd08a,axd11a,axd12a,
                                 #axd13b,axd14b)   #FUN-910001 add     #FUN-D20050 mark
                                  axd14b)          #FUN-D20050 add
             VALUES(g_axc.axc06,g_axc.axc01,g_axc.axc02,g_axc.axc03,
                    g_axd[l_ac].axd04,
                    g_axd[l_ac].axd04b,g_axd[l_ac].axd05b,
                    g_axd[l_ac].axd07b,g_axd[l_ac].axd08b,
                    g_axd[l_ac].axd11b,g_axd[l_ac].axd12b,  #FUN-580072
                    g_axd[l_ac].axd04a,g_axd[l_ac].axd05a,
                    g_axd[l_ac].axd07a,g_axd[l_ac].axd08a,
                    g_axd[l_ac].axd11a,g_axd[l_ac].axd12a,  #FUN-580072
                   #g_axd[l_ac].axd13b,                     #FUN-D20050 mark
                    g_axd[l_ac].axd14b)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","axd_file",g_axc.axc01,g_axd[l_ac].axd04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               CANCEL INSERT
            ELSE
               LET g_rec_b = g_rec_b + 1
               DISPLAY g_rec_b TO FORMONLY.cn2
               MESSAGE 'INSERT O.K'
            END IF
 
        BEFORE FIELD axd04                        #default 序號
            IF cl_null(g_axd[l_ac].axd04) OR
                  g_axd[l_ac].axd04 = 0  THEN
                  SELECT max(axd04)+1 INTO g_axd[l_ac].axd04
                    FROM axd_file
                   WHERE axd00=g_axc.axc06 AND axd01 = g_axc.axc01
                     AND axd02=g_axc.axc02 AND axd03 = g_axc.axc03
                 IF cl_null(g_axd[l_ac].axd04) THEN
                     LET g_axd[l_ac].axd04 = 1
                 END IF
            END IF
            LET g_axd[l_ac].axd08a=g_axc.axc06
 
        AFTER FIELD axd04   #項次
            IF NOT cl_null(g_axd[l_ac].axd04) THEN
               IF g_axd[l_ac].axd04 != g_axd_t.axd04 OR
                  g_axd_t.axd04 IS NULL THEN
                   SELECT COUNT(*) INTO l_n FROM axd_file
                    WHERE axd00 = g_axc.axc06 AND axd01 = g_axc.axc01
                      AND axd02 = g_axc.axc02 AND axd03 = g_axc.axc03
                      AND axd04 = g_axd[l_ac].axd04
                   IF l_n > 1 THEN
                       LET g_axd[l_ac].axd04 = g_axd_t.axd04
                       CALL cl_err('',-239,0) NEXT FIELD axd04
                   END IF
               END IF
            END IF
            LET g_axd[l_ac].axd08a=g_axc.axc06
 
       AFTER FIELD axd04b  #變更前工廠
           #-->檢查是否存在聯屬公司層級單身檔(axb_file)
           IF NOT cl_null(g_axd[l_ac].axd04b) THEN
               SELECT COUNT(*) INTO l_cnt
                 FROM axb_file
                WHERE axb01=g_axc.axc01 AND axb02=g_axc.axc02
                  AND axb03=g_axc.axc03 AND axb04=g_axd[l_ac].axd04b
               IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
               IF l_cnt <=0  THEN
                  LET g_axd[l_ac].axd04b = g_axd_t.axd04b
                  CALL cl_err(g_axd[l_ac].axd04b,'agl-221',0) NEXT FIELD axd04b
                  NEXT FIELD axd04b
               END IF
               #-->檢查工廠與show工廠名稱/資料庫名稱
               CALL t002_axz('a1',g_axd[l_ac].axd04b,g_axd[l_ac].axd05b,p_cmd)  #NO.FUN-580072   #FUN-740174 add axd05b
               IF NOT cl_null(g_errno) THEN
                  LET g_axd[l_ac].axd04b = g_axd_t.axd04b
                  DISPLAY BY NAME g_axd[l_ac].axd04b
                  NEXT FIELD axd04b
               ELSE 
                  CALL t002_set_entry_b()
                  CALL t002_set_no_entry_b()
                  LET g_axd[l_ac].axd04a=g_axd[l_ac].axd04b
                  LET g_axd[l_ac].azp02a=g_axd[l_ac].azp02b
                  LET g_axd[l_ac].azp03a=g_axd[l_ac].azp03b
                  LET g_axd[l_ac].axd05a=g_axd[l_ac].axd05b
                  DISPLAY BY NAME g_axd[l_ac].axd04a
                  DISPLAY BY NAME g_axd[l_ac].azp02a      
                  DISPLAY BY NAME g_axd[l_ac].azp03a      
                  DISPLAY BY NAME g_axd[l_ac].axd05a      
               END IF
           END IF
 
       AFTER FIELD axd04a  #變更後工廠
           #-->檢查工廠與show工廠名稱/資料庫名稱
           IF NOT cl_null(g_axd[l_ac].axd04a) THEN
               CALL t002_axz('a2',g_axd[l_ac].axd04a,g_axd[l_ac].axd05a,p_cmd) #NO.FUN-580072   #FUN-740174 add axd05a
              IF NOT cl_null(g_errno) THEN
                 LET g_axd[l_ac].axd04a = g_axd_t.axd04a
                 DISPLAY BY NAME g_axd[l_ac].axd04a
                 NEXT FIELD axd04a
              END IF
           END IF
       
       AFTER FIELD axd05a   #變更前帳別
           IF NOT cl_null(g_axd[l_ac].axd05a) THEN
              CALL t002_axz('a2',g_axd[l_ac].axd04a,g_axd[l_ac].axd05a,p_cmd)  #NO.FUN-580072   #FUN-740174 add axd05a
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_axd[l_ac].axd05a,g_errno,1)
                 LET g_axd[l_ac].axd05a = g_axd_t.axd05a
                 DISPLAY BY NAME g_axd[l_ac].axd05a
                 NEXT FIELD axd05a
              END IF
           END IF

      #FUN-S20050 mark begin--- 
      #BEFORE FIELD axd13b
      #    CALL t002_set_no_required_b()  #FUN-930081
 
      #AFTER FIELD axd13b  #股本否
      #    CALL t002_set_entry_b()
      #    CALL t002_set_no_entry_b()
      #    CALL t002_set_required_b()     #FUN-930081
      #FUN-S20050 mark end-----
 
       AFTER FIELD axd07a  #持股比率
           IF NOT cl_null(g_axd[l_ac].axd07a) THEN
              IF NOT cl_null(g_axd[l_ac].axd04b) THEN
                 IF g_axd[l_ac].axd07a < 0 OR g_axd[l_ac].axd07a > 100 THEN
                    NEXT FIELD axd07a
                 END IF
              END IF
           END IF
 
       BEFORE FIELD axd14b
          LET g_axz03=''
          SELECT azp01 INTO g_axz03    
            FROM azp_file
           WHERE azp03 = g_axd[l_ac].azp03a
       
          LET l_azp03a = ''
          LET g_plant_new = g_axz03   #營運中心
          CALL s_getdbs()
          LET l_azp03a = g_dbs_new    #所屬DB
 
       AFTER FIELD axd14b
         IF NOT cl_null(g_axd[l_ac].axd14b) THEN 
            IF g_axd[l_ac].axd14b != g_axd_t.axd14b OR
               g_axd_t.axd14b IS NULL THEN
 
               LET g_sql = "SELECT COUNT(*) ",
                          #"  FROM ",l_azp03a,"axd_file",   #FUN-A50102
                           "  FROM ",cl_get_target_table(g_plant_new,'axd_file'),   #FUN-A50102
                           " WHERE axd00 = '",g_axc.axc06,"'",                
                           "   AND axd01 = '",g_axc.axc01,"'",                
                           "   AND axd02 = '",g_axc.axc02,"'",                
                           "   AND axd03 = '",g_axc.axc03,"'",                
                           "   AND axd14b = '",g_axd[l_ac].axd14b,"'"                
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
               PREPARE t002_pre_1 FROM g_sql
               DECLARE t002_cur_1 CURSOR FOR t002_pre_1
               OPEN t002_cur_1
               FETCH t002_cur_1 INTO l_n
 
               IF l_n > 0 THEN
                  CALL cl_err(g_axd[l_ac].axd14b,-239,0)
                  LET g_axd[l_ac].axd14b = g_axd_t.axd14b
                  NEXT FIELD axd14b
               END IF
              #FUN-CC0105--str
               CALL s_aaz641_dbs(g_axc.axc01,g_axc.axc02) RETURNING g_plant_axz03
               CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641
              #FUN-CC0105--end 
              #LET g_sql = "SELECT COUNT(*) FROM ",l_azp03a,"aag_file",   #FUN-A50102
               LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'aag_file'), #FUN-A50102
                           " WHERE aag01 = '",g_axd[l_ac].axd14b,"'",                
                          #"   AND aag00 = '",g_axd[l_ac].axd05a,"'"   #FUN-CC0105 mark
                           "   AND aag00 = '",g_aaz641,"'"             #FUN-CC0105 
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
               PREPARE t002_pre_2 FROM g_sql
               DECLARE t002_cur_2 CURSOR FOR t002_pre_2
               OPEN t002_cur_2
               FETCH t002_cur_2 INTO l_n1
               IF l_n1 <> 1 THEN
                  CALL cl_err(g_axd[l_ac].axd14b,'aap-021',0)
                  #FUN-B20004--begin
                 #CALL q_m_aag2(FALSE,FALSE,g_plant_new,g_axd[l_ac].axd14b,'23',g_axd[l_ac].axd05b)   #FUN-CC0105 mark
                  CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_axd[l_ac].axd14b,'23',g_aaz641)           #FUN-CC0105
                     RETURNING g_axd[l_ac].axd14b       
                  #FUN-B20004--end                  
                  #LET g_axd[l_ac].axd14b = g_axd_t.axd14b
                  NEXT FIELD axd14b
               END IF
              #FUN-CC0105--mark--str
              #SELECT * INTO l_axz.* FROM axz_file WHERE axz01=g_axd[l_ac].axd04a
 
              #LET g_sql = "SELECT axe06 FROM axe_file",
              #            " WHERE axe01 = '",g_axd[l_ac].axd04a,"'",                
              #           #"   AND axe00 = '",l_axz.axz05,"'",           #FUN-CC0105 mark
              #            "   AND axe00 = '",g_aaz641,"'",              #FUN-CC0105 
              #            "   AND axe13 = '",g_axc.axc01,"'",            
              #            "   AND axe04 = '",g_axd[l_ac].axd14b,"'"            
              #PREPARE t002_pre_3 FROM g_sql
              #DECLARE t002_cur_3 CURSOR FOR t002_pre_3
              #OPEN t002_cur_3
              #FETCH t002_cur_3 INTO l_axe06
              #IF cl_null(l_axe06) THEN
              #   CALL cl_err(g_axd[l_ac].axd14b,'agl-168',0)
              #   LET g_axd[l_ac].axd14b = g_axd_t.axd14b
              #   NEXT FIELD axd14b
              #END IF
              #FUN-CC0105--mark--end
 
            END IF
         END IF
 
       
       BEFORE DELETE                            #是否取消單身
           IF g_axd_t.axd04 > 0 AND
              g_axd_t.axd04 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
{ckp#1}        DELETE FROM axd_file
                WHERE axd00 = g_axc.axc06 AND axd01 = g_axc.axc01
                  AND axd02 = g_axc.axc02 AND axd03 = g_axc.axc03
                  AND axd04 = g_axd_t.axd04
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","axd_file",g_axc.axc01,g_axd_t.axd04,SQLCA.sqlcode,"","",1) #NO.FUN-660123
                   ROLLBACK WORK
                   CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
           COMMIT WORK
           END IF
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_axd[l_ac].* = g_axd_t.*
              CLOSE t002_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_axd[l_ac].axd04,-263,1)
              LET g_axd[l_ac].* = g_axd_t.*
           ELSE
              UPDATE axd_file
                 SET axd04=g_axd[l_ac].axd04,
                     axd04b=g_axd[l_ac].axd04b,axd05b=g_axd[l_ac].axd05b,
                     axd07b=g_axd[l_ac].axd07b,axd08b=g_axd[l_ac].axd08b,
                     axd11b=g_axd[l_ac].axd11b,axd12b=g_axd[l_ac].axd12b,  #FUN-580072
                     axd04a=g_axd[l_ac].axd04a,axd05a=g_axd[l_ac].axd05a,
                     axd07a=g_axd[l_ac].axd07a,axd08a=g_axd[l_ac].axd08a,
                     axd11a=g_axd[l_ac].axd11a,axd12a=g_axd[l_ac].axd12a,  #FUN-580072
                    #axd13b=g_axd[l_ac].axd13b,axd14b=g_axd[l_ac].axd14b   #FUN-910001 add    #FUN-D20050 mark
                     axd14b=g_axd[l_ac].axd14b                             #FUN-D20050 add
               WHERE axd00=g_axc.axc06 AND axd01=g_axc.axc01
                 AND axd02=g_axc.axc02 AND axd03=g_axc.axc03
                 AND axd04=g_axd_t.axd04
              IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","axd_file",g_axc.axc01,g_axc.axc02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                  LET g_axd[l_ac].* = g_axd_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
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
                 LET g_axd[l_ac].* = g_axd_t.*
              #FUN-D30032--add--begin--
              ELSE
                 CALL g_axd.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30032--add--end----
              END IF
              CLOSE t002_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30032 add
           CLOSE t002_bcl
           COMMIT WORK
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(axd04b)   #變更前下層公司
                 #CALL q_axb(FALSE,TRUE,g_axc.axc01,g_axc.axc02,		   #FUN-C50059 mark
				  CALL q_axbb(FALSE,TRUE,g_axc.axc01,g_axc.axc02,          #FUN-C50059
                                        g_axc.axc03,g_axd[l_ac].axd04b)
                       RETURNING g_axd[l_ac].axd04b,g_axd[l_ac].axd05b,
                                 g_axd[l_ac].axd07b,g_axd[l_ac].axd08b
                  DISPLAY BY NAME g_axd[l_ac].axd04b
                  DISPLAY BY NAME g_axd[l_ac].axd05b
                  DISPLAY BY NAME g_axd[l_ac].axd07b
                  DISPLAY BY NAME g_axd[l_ac].axd08b
                  NEXT FIELD axd04b
             WHEN INFIELD(axd04a)   #變更後下層公司
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_axz"
                  LET g_qryparam.default1 = g_axd[l_ac].axd04a
                  CALL cl_create_qry() RETURNING g_axd[l_ac].axd04a
                  DISPLAY BY NAME g_axd[l_ac].axd04a
                  DISPLAY BY NAME g_axd[l_ac].axd04a
                  NEXT FIELD axd04a
             WHEN INFIELD(axd14b)   #會計科目
                #CALL q_m_aag2(FALSE,TRUE,g_plant_new,g_axd[l_ac].axd14b,'23',g_axd[l_ac].axd05b)#TQC-9C0099   #FUN-CC0105 mark
                #     RETURNING g_axd[l_ac].axd14b                                                             #FUN-CC0105 mark
                #FUN-CC0105--str
                CALL s_aaz641_dbs(g_axc.axc01,g_axc.axc02) RETURNING g_plant_axz03
                CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641 
                CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_axd[l_ac].axd14b,'23',g_aaz641)   #FUN-CC0105
                     RETURNING g_axd[l_ac].axd14b                  
                #FUN-CC0105--end
                #DISPLAY g_qryparam.multiret TO axd14b   #FUN-B20004    
                DISPLAY g_axd[l_ac].axd14b TO axd14b     #FUN-B20004    
                NEXT FIELD axd14b
               
             OTHERWISE EXIT CASE
          END CASE
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(axd04) AND l_ac > 1 THEN
              LET g_axd[l_ac].* = g_axd[l_ac-1].*
              LET g_axd[l_ac].axd04 = NULL
              NEXT FIELD axd04
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
          DISPLAY g_fld_name,'yiting'
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
 
    LET g_axc.axcmodu = g_user
    LET g_axc.axcdate = g_today
    UPDATE axc_file SET axcmodu = g_axc.axcmodu,axcdate = g_axc.axcdate
     WHERE axc06 = g_axc.axc06 AND axc01 = g_axc.axc01 AND axc02 = g_axc.axc02 AND axc03 = g_axc.axc03
    DISPLAY BY NAME g_axc.axcmodu,g_axc.axcdate
 
    CLOSE t002_bcl
    COMMIT WORK
#   CALL t002_delall()        #CHI-C30002 mark
    CALL t002_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t002_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin 
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() THEN
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
         CALL t002_v()
         IF g_axc.axcconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_axc.axcconf,"","","",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM axc_file WHERE axc06 = g_axc.axc06 AND axc01 = g_axc.axc01
                                AND axc03 = g_axc.axc03 AND axc02 = g_axc.axc02
         INITIALIZE g_axc.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t002_axz(p_cmd,p_axz01,p_axz05,l_cmd)        #FUN-740174 add p_axz05
DEFINE p_cmd           LIKE type_file.chr2,           #No.FUN-680098  VARCHAR(2)
       l_cmd           LIKE type_file.chr1,           #No.FUN-680098  VARCHAR(2)
       p_axz01         LIKE axz_file.axz01,
       p_axz05         LIKE axz_file.axz05,           #FUN-740174 add   #帳別
       l_axz02         LIKE axz_file.axz02,
       l_axz03         LIKE axz_file.axz03,
       l_axz05         LIKE axz_file.axz05,
	  #FUN-C50059--mark--
      #l_axb07         LIKE axb_file.axb07,
      #l_axb08         LIKE axb_file.axb08,
      #l_axb11         LIKE axb_file.axb11,
      #l_axb12         LIKE axb_file.axb12,
      #FUN-C50059--mark--
      #FUN-C50059--
       l_axbb06        LIKE axbb_file.axbb06,   #異動日期
       l_axbb07        LIKE axbb_file.axbb07,   #持股比率
       l_axbb08        LIKE axbb_file.axbb08,   #投資股數
       l_axbb09        LIKE axbb_file.axbb09,   #股本
      #FUN-C50059--
       l_azp02         LIKE azp_file.azp02,  #MOD-740105 add
       l_azp03         LIKE azp_file.azp03   #TQC-660043
 
    LET g_errno = ' '
    IF p_cmd = 'a2' AND (INFIELD(axd04a) OR INFIELD(axd05a)) THEN
       IF cl_null(p_axz05) THEN   #FUN-740174 add
          SELECT axz02,axz03,axz05,'','','',''
           #INTO l_axz02,l_axz03,l_axz05,l_axb07,l_axb08,l_axb11,l_axb12        #FUN-C50059 mark
            INTO l_axz02,l_axz03,l_axz05,l_axbb06,l_axbb07,l_axbb08,l_axbb09    #FUN-C50059
            FROM axz_file
           WHERE axz01 = p_axz01
       ELSE
          SELECT axz02,axz03,axz05,'','','',''
           #INTO l_axz02,l_axz03,l_axz05,l_axb07,l_axb08,l_axb11,l_axb12        #FUN-C50059 mark
            INTO l_axz02,l_axz03,l_axz05,l_axbb06,l_axbb07,l_axbb08,l_axbb09    #FUN-C50059
            FROM axz_file
           WHERE axz01 = p_axz01
             AND axz05 = p_axz05 
       END IF
    ELSE
       IF cl_null(p_axz05) THEN   #FUN-740174 add
		 #FUN-C50059--mark--
         #SELECT axz02,axz03,axz05,axb07,axb08,axb11,axb12
         #  INTO l_axz02,l_axz03,l_axz05,l_axb07,l_axb08,l_axb11,l_axb12
         #  FROM axz_file,axb_file
         # WHERE axb04 = axz01
         #   AND axb04 = p_axz01
         #   AND axb01 = g_axc.axc01
         #   AND axb02 = g_axc.axc02
         #   AND axb03 = g_axc.axc03
         #FUN-C50059--mark--
         #FUN-C50059--
          SELECT axz02,axz03,axz05,axbb06,axbb07,axbb08,axbb09
            INTO l_axz02,l_axz03,l_axz05,l_axbb06,l_axbb07,l_axbb08,l_axbb09
            FROM axz_file,axbb_file
           WHERE axbb04 = axz01 AND axbb04 = p_axz01
             AND axbb01 = g_axc.axc01
             AND axbb02 = g_axc.axc02
             AND axbb03 = g_axc.axc03
            #-----------------------MOD-CC0132------------------(S)
            #--MOD-CC0132--mark
            #AND axbb06 = (SELECT MAX(axbb06) FROM axbb_file
            #               WHERE axbb01 = axbb01 AND axbb02 = axbb02
            #                 AND axbb03 = axbb03 AND axbb04 = axbb04
            #                 AND axbb05 = axbb05)
            #--MOD-CC0132--mark
             AND axbb06 = (SELECT MAX(axbb06) FROM axbb_file
                             WHERE axbb01 = g_axc.axc01 AND axbb02 = g_axc.axc02
                               AND axbb03 = g_axc.axc03 AND axbb04 = p_axz01
                               AND axbb05 = p_axz05)
            #-----------------------MOD-CC0132------------------(E)
         #FUN-C50059--
       ELSE   #檢查公司+帳別是否存在agli009
		 #FUN-C50059--mark--
         #SELECT axz02,axz03,axz05,axb07,axb08,axb11,axb12
         #  INTO l_axz02,l_axz03,l_axz05,l_axb07,l_axb08,l_axb11,l_axb12
         #  FROM axz_file,axb_file
         # WHERE axb04 = axz01
         #   AND axb04 = p_axz01
         #   AND axb05 = p_axz05
         #   AND axb01 = g_axc.axc01
         #   AND axb02 = g_axc.axc02
         #   AND axb03 = g_axc.axc03
         #FUN-C50059--mark--
         #FUN-C50059--
          SELECT axz02,axz03,axz05,axbb06,axbb07,axbb08,axbb09
            INTO l_axz02,l_axz03,l_axz05,l_axbb06,l_axbb07,l_axbb08,l_axbb09
            FROM axz_file,axbb_file
           WHERE axbb04 = axz01
             AND axbb04 = p_axz01
             AND axbb05 = p_axz05
             AND axbb01 = g_axc.axc01
             AND axbb02 = g_axc.axc02
             AND axbb03 = g_axc.axc03
            #-----------------------MOD-CC0132------------------(S)
            #--MOD-CC0132--mark
            #AND axbb06 = (SELECT MAX(axbb06) FROM axbb_file
            #               WHERE axbb01 = axbb01 AND axbb02 = axbb02
            #                 AND axbb03 = axbb03 AND axbb04 = axbb04
            #                 AND axbb05 = axbb05)
            #--MOD-CC0132--mark
             AND axbb06 = (SELECT MAX(axbb06) FROM axbb_file
                             WHERE axbb01 = g_axc.axc01 AND axbb02 = g_axc.axc02
                               AND axbb03 = g_axc.axc03 AND axbb04 = p_axz01
                               AND axbb05 = p_axz05)
            #-----------------------MOD-CC0132------------------(E)
         #FUN-C50059--
       END IF
    END IF    #MOD-740105 add
 
    CASE WHEN SQLCA.SQLCODE =100  
              IF cl_null(p_axz05) THEN
                 LET g_errno = 'mfg9142'
              ELSE
                 LET g_errno = 'agl-946'
              END IF
              LET l_axz02 = NULL LET l_axz03 = NULL
              LET l_axz05 = NULL 
             #FUN-C50059--mark--
             #LET l_axb07 = NULL LET l_axb08 = NULL
             #LET l_axb11 = NULL LET l_axb12 = NULL
             #FUN-C50059--mark--
             #FUN-C50059--
              LET l_axbb06 = NULL LET l_axbb07 = NULL
              LET l_axbb08 = NULL LET l_axbb09 = NULL
             #FUN-C50059--
         OTHERWISE          
              LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
 
    SELECT azp02,azp03 INTO l_azp02,l_azp03 
      FROM azp_file where azp01 = l_axz03   #TQC-660043
 
    IF cl_null(g_errno) OR p_cmd = 'd1' OR p_cmd = 'd2' THEN
       IF p_cmd ='a1' OR p_cmd = 'd1' THEN
          LET g_axd[l_ac].azp02b = l_axz02                        #MOD-780107
          LET g_axd[l_ac].azp03b = l_azp03   #TQC-660043
          LET g_axd[l_ac].axd05b = l_axz05
		 #FUN-C50059--mark--
         #LET g_axd[l_ac].axd07b = l_axb07
         #LET g_axd[l_ac].axd08b = l_axb08
         #LET g_axd[l_ac].axd11b = l_axb11
         #LET g_axd[l_ac].axd12b = l_axb12
         #FUN-C50059--mark--
         #FUN-C50059--
          LET g_axd[l_ac].axd07b = l_axbb07
          LET g_axd[l_ac].axd08b = l_axbb06
          LET g_axd[l_ac].axd11b = l_axbb08
          LET g_axd[l_ac].axd12b = l_axbb09
         #FUN-C50059--
          DISPLAY BY NAME g_axd[l_ac].azp02b,g_axd[l_ac].azp03b,   #MOD-740105 add
                          g_axd[l_ac].axd05b,g_axd[l_ac].axd07b,
                          g_axd[l_ac].axd08b,g_axd[l_ac].axd11b,
                          g_axd[l_ac].axd12b
       END IF
       IF p_cmd ='a2' OR p_cmd = 'd2' THEN
          IF l_cmd !='u' THEN
             LET g_axd[l_ac].azp02a = l_axz02                        #MOD-780107
             LET g_axd[l_ac].azp03a = l_azp03   #TQC-660043
             LET g_axd[l_ac].axd05a = l_axz05
            #LET g_axd[l_ac].axd07a = l_axb07     #FUN-C50059 mark
             LET g_axd[l_ac].axd08a = g_axc.axc06
            #LET g_axd[l_ac].axd11a = l_axb11     #FUN-C50059 mark
            #LET g_axd[l_ac].axd12a = l_axb12     #FUN-C50059 mark
            #FUN-C50059--
             LET g_axd[l_ac].axd07a = l_axbb07    #FUN-C50059
             LET g_axd[l_ac].axd11a = l_axbb08    #FUN-C50059
             LET g_axd[l_ac].axd12a = l_axbb09    #FUN-C50059
            #FUN-C50059--
          END IF
          DISPLAY BY NAME g_axd[l_ac].azp02a,g_axd[l_ac].azp03a,   #MOD-740105 add
                          g_axd[l_ac].axd05a,g_axd[l_ac].axd07a,
                          g_axd[l_ac].axd08a,g_axd[l_ac].axd11a,
                          g_axd[l_ac].axd12a
       END IF
    END IF
END FUNCTION
 
#檢查工廠編號
FUNCTION t002_azp(p_cmd,p_azp01)
DEFINE p_cmd           LIKE type_file.chr2,          #No.FUN-680098 VARCHAR(2)
       p_azp01         LIKE azp_file.azp01,
       l_axz02         LIKE axz_file.axz02,   #MOD-780107
       l_azp03         LIKE azp_file.azp03
 
    LET g_errno = ' '
    SELECT axz02,azp03 INTO l_axz02,l_azp03 FROM azp_file,axz_file   #MOD-780107
     WHERE azp01 = p_azp01
       AND azp053 != 'N'   #no.7431
       AND azp01 = axz03   #MOD-780107 add
    CASE WHEN SQLCA.SQLCODE =100  
            LET g_errno = 'mfg9142'
            LET l_axz02 = NULL   #MOD-780107
            LET l_azp03 = NULL
         OTHERWISE
            LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd1' OR p_cmd = 'd2' THEN
       IF p_cmd ='a1' OR p_cmd = 'd1' THEN
          LET g_axd[l_ac].azp02b = l_axz02   #MOD-780107
          LET g_axd[l_ac].azp03b = l_azp03
          DISPLAY BY NAME g_axd[l_ac].azp02b,g_axd[l_ac].azp03b   #MOD-5A0095 add
       END IF
       IF p_cmd ='a2' OR p_cmd = 'd2' THEN
          LET g_axd[l_ac].azp02a = l_axz02   #MOD-780107
          LET g_axd[l_ac].azp03a = l_azp03
          DISPLAY BY NAME g_axd[l_ac].azp02a,g_axd[l_ac].azp03a   #MOD-5A0095 add
       END IF
    END IF
END FUNCTION

#CHI-C30002 -------- mark -------- begin 
#FUNCTION t002_delall()	# 未輸入單身資料, 是否取消單頭資料
#   SELECT COUNT(*) INTO g_cnt FROM axd_file
#    WHERE axd00 = g_axc.axc06 AND axd01 = g_axc.axc01 AND axd02 = g_axc.axc02
#      AND axd03 = g_axc.axc03
#   IF g_cnt = 0 THEN
#      DISPLAY 'Del All Record'
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM axc_file
#       WHERE axc01 = g_axc.axc01 AND axc02 = g_axc.axc02
#         AND axc03 = g_axc.axc03 AND axc06 = g_axc.axc06
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t002_b_askkey()
DEFINE
   #l_wc2     LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(200) #MOD-CC0132 mark
    l_wc2     STRING                   #MOD-CC0132 add
 
    CONSTRUCT l_wc2 ON axd04,axd04b,axd05b,axd07b,axd11b,axd12b,axd08b,
                            #axd04a,axd05a,axd13b,axd07a,axd11a,axd14b,axd12a,axd08a   #FUN-910001 add axd13b,axd14b    #FUN-D20050 mark
                             axd04a,axd05a,axd07a,axd11a,axd14b,axd12a,axd08a          #FUN-D20050 add
         FROM s_axd[1].axd04,
              s_axd[1].axd04b,s_axd[1].axd05b,
              s_axd[1].axd07b,s_axd[1].axd11b,
              s_axd[1].axd12b,s_axd[1].axd08b,  #FUN-580072
              s_axd[1].axd04a,s_axd[1].axd05a,
             #s_axd[1].axd13b,                  #FUN-910001 add       #FUN-D20050 mark
              s_axd[1].axd07a,s_axd[1].axd11a,
              s_axd[1].axd14b,                  #FUN-910001 add
              s_axd[1].axd12a,s_axd[1].axd08a   #FUN-580072
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
    CALL t002_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t002_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2      LIKE type_file.chr1000     #No.FUN-680098  VARCHAR(200)
 
   IF p_wc2 IS NULL THEN LET p_wc2=" 1=1 " END IF
   LET g_sql =
       "SELECT axd04,'0',axd04b,' ',' ',axd05b,axd07b,axd08b,axd11b,axd12b,",
      #"             '1',axd04a,' ',' ',axd05a,axd13b,axd07a,axd08a,axd11a,axd14b,axd12a",  #FUN-910001 add axd13b,axd14b    #FUN-D20050 mark
       "             '1',axd04a,' ',' ',axd05a,axd07a,axd08a,axd11a,axd14b,axd12a",         #FUN-D20050 add
       "  FROM axd_file  ",
       " WHERE axd00='",g_axc.axc06,"' AND axd01='",g_axc.axc01,"'",
       "   AND axd02='",g_axc.axc02,"' AND axd03='",g_axc.axc03,"'",
       "   AND ",p_wc2 CLIPPED,
       " ORDER BY 1"
   PREPARE t002_pb FROM g_sql
   DECLARE axd_curs CURSOR FOR t002_pb       #SCROLL CURSOR
 
   CALL g_axd.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH axd_curs INTO g_axd[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT axz02,azp03 INTO g_axd[g_cnt].azp02b,g_axd[g_cnt].azp03b   #MOD-780107
        FROM axz_file LEFT OUTER JOIN azp_file ON axz03 = azp01    #MOD-780107 add OUTER
         WHERE axz01 = g_axd[g_cnt].axd04b
      IF SQLCA.sqlcode THEN LET g_axd[g_cnt].azp02b = ' '
                            LET g_axd[g_cnt].azp03b = ' '
      END IF
      SELECT axz02,azp03 INTO g_axd[g_cnt].azp02a,g_axd[g_cnt].azp03a   #MOD-780107
        FROM axz_file LEFT OUTER JOIN azp_file ON axz03 = azp01    #MOD-780107 add OUTER
         WHERE axz01 = g_axd[g_cnt].axd04a
      IF SQLCA.sqlcode THEN LET g_axd[g_cnt].azp02a = ' '
                            LET g_axd[g_cnt].azp03a = ' '
      END IF

     #FUN-D20050 mark begin-----
     #IF cl_null(g_axd[g_cnt].axd13b) THEN
     #   LET g_axd[g_cnt].axd13b = 'N'
     #END IF
     #FUN-D20050 mark end-------

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_axd.deleteElement(g_cnt)
   LET g_rec_b=g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION t002_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_axd TO s_axd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t002_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t002_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t002_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t002_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t002_fetch('L')
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
         #CALL cl_set_field_pic(g_axc.axcconf,"","","","","")  #CHI-C80041
         IF g_axc.axcconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_axc.axcconf,"","","",g_void,"")  #CHI-C80041
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end
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
 
    #@ON ACTION 相關文件
      ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t002_y()   #確認
   DEFINE g_axd     RECORD LIKE axd_file.*
   DEFINE l_axz     RECORD LIKE axz_file.*   #FUN-910001 add
   DEFINE l_axe06   LIKE axe_file.axe06      #FUN-910001 add
   DEFINE l_yy      LIKE type_file.num5      #FUN-970048 add
   DEFINE l_mm      LIKE type_file.num5      #FUN-970048 add
   DEFINE l_n       LIKE type_file.num5      #FUN-910001 add
 
#CHI-C30107 --------- add --------- begin
   IF cl_null(g_axc.axc01) THEN RETURN END IF
   IF g_axc.axcconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_axc.axcconf='Y' THEN RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 --------- add --------- end
   IF cl_null(g_axc.axc01) THEN RETURN END IF
   SELECT * INTO g_axc.* FROM axc_file
    WHERE axc01=g_axc.axc01 AND axc02=g_axc.axc02 AND axc03=g_axc.axc03
      AND axc06=g_axc.axc06
   IF g_axc.axcconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_axc.axcconf='Y' THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM axd_file
    WHERE axd01=g_axc.axc01 AND axd00=g_axc.axc06
      AND axd02=g_axc.axc02 AND axd03=g_axc.axc03
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
 
   LET g_success='Y'
   BEGIN WORK
   OPEN t002_cl USING g_axc.axc06,g_axc.axc01,g_axc.axc02,g_axc.axc03
   FETCH t002_cl INTO g_axc.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_axc.axc01,SQLCA.sqlcode,0)
      CLOSE t002_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   DECLARE t002_axb CURSOR FOR              # LOCK CURSOR
    SELECT * FROM axd_file
     WHERE axd00 = g_axc.axc06 AND axd01 = g_axc.axc01
       AND axd02 = g_axc.axc02 AND axd03 = g_axc.axc03
     ORDER BY axd04
   FOREACH t002_axb INTO g_axd.*
      IF cl_null(g_axd.axd04b) AND NOT cl_null(g_axd.axd04a) THEN
        #FUN-C50059--
         LET l_n = 0
         SELECT count(*) INTO l_n FROM axb_file
          WHERE axb01 = g_axc.axc01 AND axb02 = g_axc.axc02 
            AND axb03 = g_axc.axc03 AND axb04 = g_axd.axd04a
            AND axb05 = g_axd.axd05a 
         IF l_n = 0 THEN
        #FUN-C50059--
            INSERT INTO axb_file (axb01,axb02,axb03,axb04,axb05)    #FUN-C50059	mod
                                 #axb07,axb08,axb11,axb12)		    #FUN-C50059 mark
                        VALUES(g_axc.axc01, g_axc.axc02, g_axc.axc03,
                               g_axd.axd04a, g_axd.axd05a)  #,g_axd.axd07a,   #FUN-C50059 mod
                              #g_axd.axd08a,g_axd.axd11a,g_axd.axd12a)		  #FUN-C50059 mark
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            CALL cl_err3("ins","axb_file",g_axc.axc01,g_axc.axc02,SQLCA.sqlcode,"","ins axb",1)  #No.FUN-660123
         END IF
       END IF    #FUN-C50059--
        #CHI-C50059--
         LET l_n = 0
         SELECT count(*) INTO l_n FROM axbb_file
          WHERE axbb01 = g_axc.axc01 AND axbb02 = g_axc.axc02
            AND axbb03 = g_axc.axc03 AND axbb04 = g_axd.axd04a
            AND axbb05 = g_axd.axd05a AND axbb06 = g_axd.axd08a
         IF cl_null(g_axd.axd12a) THEN LET g_axd.axd12a = 0 END IF
         IF l_n = 0 THEN
            INSERT INTO axbb_file (axbb01,axbb02,axbb03,axbb04,axbb05, 
                                   #axbb07,axbb06,axbb08,axbb09)           #FUN-CC0105 mark
                                   axbb07,axbb06,axbb08,axbb09,axbb10)     #FUN-CC0105
                            VALUES(g_axc.axc01, g_axc.axc02, g_axc.axc03,
                                   g_axd.axd04a, g_axd.axd05a,g_axd.axd07a,
                                   #g_axd.axd08a,g_axd.axd11a,g_axd.axd12a)               #FUN-CC0105 mark
                                   g_axd.axd08a,g_axd.axd11a,g_axd.axd12a,g_axd.axd14b)   #FUN-CC0105
            IF SQLCA.sqlcode THEN
               LET g_success='N'
               CALL cl_err3("ins","axbb_file",g_axc.axc01,g_axc.axc02,SQLCA.sqlcode,"","ins axb",1) 
            END IF
      ELSE
           #UPDATE axbb_file SET axbb07 = p_axd.axd07a,axbb08 = g_axd.axd11a ,axbb09 = g_axd.axd12a   #FUN-CC0105 mark
            UPDATE axbb_file SET axbb07 = p_axd.axd07a,axbb08 = g_axd.axd11a ,axbb09 = g_axd.axd12a,axbb10 = p_axd.axd14b   #FUN-CC0105
             WHERE axbb01 = g_axc.axc01 AND axbb02 = g_axc.axc02
               AND axbb03 = g_axc.axc03 AND axbb04 = g_axd.axd04a
               AND axbb05 = g_axd.axd05a AND axbb06 = g_axd.axd08a
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
               LET g_success='N'
               CALL cl_err3("upd","axb_file",g_axc.axc01,g_axc.axc02,SQLCA.sqlcode,"","axb",1)
               RETURN
            END IF
         END IF
        #CHI-C50059--
      ELSE
		#CALL t002_upd_axb(g_axd.*)                 #FUN-C50059 mark
        #FUN-C50059--
         LET l_n = 0
         SELECT count(*) INTO l_n FROM axbb_file
          WHERE axbb01 = g_axd.axd01 AND axbb02 = g_axd.axd02
            AND axbb03 = g_axd.axd03 AND axbb04 = g_axd.axd04a
            AND axbb05 = g_axd.axd05a AND axbb06 = g_axd.axd08a
         IF l_n = 0 THEN
            INSERT INTO axbb_file (axbb01,axbb02,axbb03,axbb04,axbb05,
                                   #axbb07,axbb06,axbb08,axbb09)           #FUN-CC0105 mark
                                   axbb07,axbb06,axbb08,axbb09,axbb10)     #FUN-CC0105
                            VALUES(g_axc.axc01, g_axc.axc02, g_axc.axc03,
                                   g_axd.axd04a, g_axd.axd05a,g_axd.axd07a,
                                   #g_axd.axd08a,g_axd.axd11a,g_axd.axd12a)             #FUN-CC0105 mark
                                   g_axd.axd08a,g_axd.axd11a,g_axd.axd12a,g_axd.axd14b) #FUN-CC0105
         ELSE
            CALL t002_upd_axbb(g_axd.*)
         END IF
        #FUN-C50059--
      END IF
#No.MOD-B30383-----Mark---BEGIN----
      #axd13b(股本否)='N'確認時,應回寫agli011
      #金額回寫至agli011時,只寫異動額(修改後金額-修改前金額),
      #例如：修改前 10000,修改後 12000,回寫axr05時應寫12000-10000=2000
#     IF g_axd.axd13b='N' THEN
#       INITIALIZE l_axz.* TO NULL
#        LET l_axe06='' LET l_yy=0  LET l_mm=0  LET l_n = 0
#        LET l_yy=YEAR(g_axc.axc06)
#        LET l_mm=MONTH(g_axc.axc06)
 
#        SELECT * INTO l_axz.* FROM axz_file WHERE axz01=g_axd.axd04a
#        SELECT axe06 INTO l_axe06 FROM axe_file
#         WHERE axe01=g_axd.axd04a AND axe00=l_axz.axz05
#           AND axe13=g_axc.axc01
#           AND axe04 = g_axd.axd14b     #FUN-920112 add
#
#        SELECT COUNT(*) INTO l_n FROM axr_file
#         WHERE axr01=g_axc.axc01 AND axr02=g_axd.axd04a
#           AND axr03=l_axe06     AND axr07=g_axd.axd14b
#           AND axr06=g_axc.axc06 #FUN-970048 add
#        IF l_n = 0 THEN            
#           INSERT INTO axr_file(axr01,axr02,axr03,axr04,axr05,
#                                axr06,axr07)  #FUN-970048
#                         VALUES(g_axc.axc01,g_axd.axd04a,l_axe06,
#                                l_axz.axz06,g_axd.axd12b-g_axd.axd12a,  #FUN-910023 mod
#                                g_axc.axc06,g_axd.axd14b)           #FUN-970048
#           IF SQLCA.sqlcode THEN
#              LET g_success='N'
#              CALL cl_err3("ins","axr_file",g_axc.axc01,g_axd.axd04a,SQLCA.sqlcode,"","ins axr",1)
#           END IF
#        ELSE
#           UPDATE axr_file SET axr05=g_axd.axd12b-g_axd.axd12a  #FUN-910023 mod
#            WHERE axr01=g_axc.axc01 AND axr02=g_axd.axd04a
#              AND axr03=l_axe06     AND axr07=g_axd.axd14b
#              AND axr06=g_axc.axc06 #FUN-970048 add
#           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#              LET g_success='N'
#              CALL cl_err3("upd","axr_file",g_axc.axc01,g_axd.axd04a,SQLCA.sqlcode,"","upd axr",1)
#           END IF
#        END IF
#     END IF
#No.MOD-B30383-----Mark---END----

   END FOREACH
   IF g_success = 'Y' THEN
      UPDATE axc_file SET axcconf='Y'
       WHERE axc01 = g_axc.axc01 AND axc02 = g_axc.axc02
         AND axc03 = g_axc.axc03 AND axc06 = g_axc.axc06
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","axc_file",g_axc.axc01,g_axc.axc02,STATUS,"","upd axcconf",1)  #No.FUN-660123
         LET g_success='N'
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT axcconf INTO g_axc.axcconf FROM axc_file
    WHERE axc01 = g_axc.axc01 AND axc02 = g_axc.axc02
      AND axc03 = g_axc.axc03 AND axc06 = g_axc.axc06
   DISPLAY BY NAME g_axc.axcconf
   CALL cl_set_field_pic(g_axc.axcconf,"","","","","")
END FUNCTION
 
FUNCTION t002_z()
   DEFINE g_axd     RECORD LIKE axd_file.* 
   DEFINE l_axc06   LIKE axc_file.axc06
   DEFINE l_axz     RECORD LIKE axz_file.*   #FUN-910001 add
   DEFINE l_axe06   LIKE axe_file.axe06      #FUN-910001 add
   DEFINE l_yy      LIKE type_file.num5      #FUN-970048 add
   DEFINE l_mm      LIKE type_file.num5      #FUN-970048 add
   DEFINE l_n       LIKE type_file.num5      #FUN-910001 add
 
   IF cl_null(g_axc.axc01)  THEN RETURN END IF
   SELECT * INTO g_axc.* FROM axc_file
    WHERE axc01 = g_axc.axc01 AND axc02 = g_axc.axc02
      AND axc03 = g_axc.axc03 AND axc06 = g_axc.axc06
   IF g_axc.axcconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_axc.axcconf='N' THEN RETURN END IF
 
   #-->異動日期最大的才可取消確認
   SELECT MAX(axc06) INTO l_axc06 FROM axc_file
    WHERE axc01 = g_axc.axc01 AND axc02 = g_axc.axc02
      AND axc03 = g_axc.axc03 AND axc06 > g_axc.axc06
   IF not cl_null(l_axc06) THEN
      CALL cl_err(l_axc06,'agl-222',0) RETURN
   END IF
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   LET g_success='Y'
   BEGIN WORK
   OPEN t002_cl USING g_axc.axc06,g_axc.axc01,g_axc.axc02,g_axc.axc03
   FETCH t002_cl INTO g_axc.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_axc.axc01,SQLCA.sqlcode,0)
      CLOSE t002_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   DECLARE t002_raxb CURSOR FOR
    SELECT * FROM axd_file
     WHERE axd00 = g_axc.axc06 AND axd01 = g_axc.axc01
       AND axd02 = g_axc.axc02 AND axd03 = g_axc.axc03
     ORDER BY axd04
 
   FOREACH t002_raxb INTO g_axd.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('t002_raxb',SQLCA.sqlcode,0)   
         LET g_success = 'N' EXIT FOREACH
      END IF
      IF cl_null(g_axd.axd04b) AND NOT cl_null(g_axd.axd04a) THEN
         IF g_axz04 = 'Y' THEN
           #FUN-C50059
            LET l_n = 0
            SELECT count(*) INTO l_n FROM axbb_file
             WHERE axbb01 = g_axd.axd01 AND axbb02 = g_axd.axd02
               AND axbb03 = g_axd.axd03 AND axbb04 = g_axd.axd04a
               AND axbb05 = g_axd.axd05a
            IF l_n = 1 THEN
           #FUN-C50059 
            DELETE FROM axb_file
             WHERE axb01 = g_axd.axd01 AND axb02 = g_axd.axd02
               AND axb03 = g_axd.axd03 AND axb04 = g_axd.axd04a
               AND axb05 = g_axd.axd05a
            END IF
           #FUN-C50059--
            DELETE FROM axbb_file
             WHERE axbb01 = g_axd.axd01 AND axbb02 = g_axd.axd02
               AND axbb03 = g_axd.axd03 AND axbb04 = g_axd.axd04a
               AND axbb05 = g_axd.axd05a AND axbb06 = g_axd.axd08a
           #FUN-C50059--
         ELSE
           #FUN-C50059--
            LET l_n = 0
            SELECT count(*) INTO l_n FROM axbb_file
             WHERE axbb01 = g_axd.axd01 AND axbb02 = g_axd.axd02
               AND axbb03 = g_axd.axd03 AND axbb04 = g_axd.axd04a
               AND axbb05 = g_axd.axd05a
            IF l_n = 1 THEN 
           #FUN-C50059--
            DELETE FROM axb_file
             WHERE axb01 = g_axd.axd01 AND axb02 = g_axd.axd02
               AND axb03 = g_axd.axd03 AND axb04 = g_axd.axd04a
            END IF
           #FUN-C50059--
            DELETE FROM axbb_file
             WHERE axbb01 = g_axd.axd01 AND axbb02 = g_axd.axd02
               AND axbb03 = g_axd.axd03 AND axbb04 = g_axd.axd04a
               AND axbb06 = g_axd.axd08a
           #FUN-C50059--
         END IF  #NO:FUN-580072
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_success='N'
            CALL cl_err3("del","axb_file",g_axd.axd01,g_axd.axd02,SQLCA.sqlcode,"","axb",1)   #FUN-740197 modify
            EXIT FOREACH
         END IF
      END IF
      IF NOT cl_null(g_axd.axd04b) AND NOT cl_null(g_axd.axd04a) THEN
         IF g_axz04 = 'Y' THEN
           #FUN-C50059--
            DELETE FROM axbb_file
             WHERE axbb01 = g_axd.axd01 AND axbb02 = g_axd.axd02
               AND axbb03 = g_axd.axd03 AND axbb04 = g_axd.axd04a
               AND axbb05 = g_axd.axd05a AND axbb06 = g_axd.axd08a
           #FUN-C50059--
           #FUN-C50059--mark--
           # UPDATE axb_file SET axb07 = g_axd.axd07b,
           #                     axb08 = g_axd.axd08b,
           #                     axb11 = g_axd.axd11b   #NO.FUN-580072
           #  WHERE axb01 = g_axd.axd01 AND axb02 = g_axd.axd02
           #    AND axb03 = g_axd.axd03 AND axb04 = g_axd.axd04a
           #    AND axb05 = g_axd.axd05a
           # IF g_axd.axd13b ='Y' THEN                                          
           #    UPDATE axb_file SET axb12 = g_axd.axd12b                        
           #     WHERE axb01 = g_axd.axd01 AND axb02 = g_axd.axd02              
           #       AND axb03 = g_axd.axd03 AND axb04 = g_axd.axd04a             
           #       AND axb05 = g_axd.axd05a  
            #  #No.MOD-B30383-----Mark---BEGIN----
            #  #UPDATE axr_file SET axr05=g_axd.axd12b-g_axd.axd12a  
            #  # WHERE axr01=g_axc.axc01 AND axr02=g_axd.axd04a
            #  #   AND axr03=l_axe06     AND axr07=g_axd.axd14b
            #  #   AND axr06=g_axc.axc06
            #  #IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            #  #   LET g_success='N'
            #  #   CALL cl_err3("upd","axr_file",g_axc.axc01,g_axd.axd04a,SQLCA.sqlcode,"","upd axr",1)
            #  #END IF
            #   #No.MOD-B30383-----Mark---END------ 
            #END IF                                                        
           #FUN-C50059--mark--
         ELSE 
           #FUN-C50059--
            DELETE FROM axbb_file
             WHERE axbb01 = g_axd.axd01 AND axbb02 = g_axd.axd02
               AND axbb03 = g_axd.axd03 AND axbb04 = g_axd.axd04a
               AND axbb06 = g_axd.axd08a
           #FUN-C50059--
           #FUN-C50059--mark--
           # UPDATE axb_file SET axb07 = g_axd.axd07b,
           #                     axb08 = g_axd.axd08b,
           #                     axb11 = g_axd.axd11b   #NO.FUN-580072
           #  WHERE axb01 = g_axd.axd01 AND axb02 = g_axd.axd02
           #    AND axb03 = g_axd.axd03 AND axb04 = g_axd.axd04a
           # IF g_axd.axd13b ='Y' THEN                                          
           #    UPDATE axb_file SET axb12 = g_axd.axd12b                        
           #     WHERE axb01 = g_axd.axd01 AND axb02 = g_axd.axd02              
           #       AND axb03 = g_axd.axd03 AND axb04 = g_axd.axd04a             
           #       AND axb05 = g_axd.axd05a   
           #   #No.MOD-B30383-----Mark---BEGIN----
           #   #UPDATE axr_file SET axr05=g_axd.axd12b-g_axd.axd12a  
           #   # WHERE axr01=g_axc.axc01 AND axr02=g_axd.axd04a
           #   #   AND axr03=l_axe06     AND axr07=g_axd.axd14b
           #   #   AND axr06=g_axc.axc06 
           #   #IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           #   #   LET g_success='N'
           #   #   CALL cl_err3("upd","axr_file",g_axc.axc01,g_axd.axd04a,SQLCA.sqlcode,"","upd axr",1)
            #  #END IF
            #  #No.MOD-B30383-----Mark---END------ 
            #END IF
			#FUN-C50059--mark--
         END IF  #NO.FUN-580072
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_success='N'
           #CALL cl_err3("upd","axb_file",g_axd.axd01,g_axd.axd02,SQLCA.sqlcode,"","axb",1)     #FUN-C50059 mark #FUN-740197 modify
            CALL cl_err3("upd","axbb_file",g_axd.axd01,g_axd.axd02,SQLCA.sqlcode,"","axbb",1)   #FUN-C50059
            EXIT FOREACH
         END IF
      END IF
#No.MOD-B30383-----Mark---BEGIN----
      #axd13b(股本否)='N'取消確認時,應刪除agli011的資料
#     IF g_axd.axd13b='N' THEN
#        INITIALIZE l_axz.* TO NULL
#        LET l_axe06='' LET l_yy=0  LET l_mm=0  LET l_n = 0
#        LET l_yy=YEAR(g_axc.axc06)
#        LET l_mm=MONTH(g_axc.axc06)
#
#        SELECT * INTO l_axz.* FROM axz_file WHERE axz01=g_axd.axd04a
#        SELECT axe06 INTO l_axe06 FROM axe_file
#         WHERE axe01=g_axd.axd04a AND axe00=l_axz.axz05
#           AND axe13=g_axc.axc01
#
#        SELECT COUNT(*) INTO l_n FROM axr_file
#         WHERE axr01=g_axc.axc01 AND axr02=g_axd.axd04a
#           AND axr03=l_axe06     AND axr07=g_axd.axd14b
#           AND axr06=g_axc.axc06 #FUN-970048 add
#        IF l_n > 0 THEN            
#           DELETE FROM  axr_file
#            WHERE axr01=g_axc.axc01 AND axr02=g_axd.axd04a
#              AND axr03=l_axe06     AND axr07=g_axd.axd14b
#              AND axr06=g_axc.axc06 #FUN-970048 add
#           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#              LET g_success='N'
#              CALL cl_err3("del","axr_file",g_axc.axc01,g_axd.axd04a,SQLCA.sqlcode,"","del axr",1)
#              EXIT FOREACH
#           END IF
#        END IF
#     END IF
#No.MOD-B30383-----Mark---END------
   END FOREACH
   IF g_success = 'Y' THEN
      UPDATE axc_file SET axcconf='N'
       WHERE axc01 = g_axc.axc01 AND axc02 = g_axc.axc02
         AND axc03 = g_axc.axc03 AND axc06 = g_axc.axc06
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","axc_file",g_axc.axc01,g_axc.axc02,STATUS,"","upd axcconf",1)  #No.FUN-660123
         LET g_success='N'
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT axcconf INTO g_axc.axcconf FROM axc_file
    WHERE axc01 = g_axc.axc01 AND axc02 = g_axc.axc02
      AND axc03 = g_axc.axc03 AND axc06 = g_axc.axc06
   DISPLAY BY NAME g_axc.axcconf
   CALL cl_set_field_pic(g_axc.axcconf,"","","","","")
END FUNCTION
 
#FUNCTION t002_upd_axb(p_axd)         #FUN-C50059 mark
FUNCTION t002_upd_axbb(p_axd)         #FUN-C50059
   DEFINE p_axd   RECORD LIKE axd_file.*
 
   #有異動持股比率才需做更新
   IF (NOT cl_null(p_axd.axd07a) AND p_axd.axd07a != p_axd.axd07b) THEN
	 #FUN-C50059--mark--
     #UPDATE axb_file SET axb07 = p_axd.axd07a
     # WHERE axb01 = p_axd.axd01 AND axb02 = p_axd.axd02
     #   AND axb03 = p_axd.axd03 AND axb04 = p_axd.axd04a
     #   AND axb05 = p_axd.axd05a
     #FUN-C50059--mark--
     #FUN-C50059--
     #UPDATE axbb_file SET axbb07 = p_axd.axd07a   #FUN-CC0105 mark
      UPDATE axbb_file SET axbb07 = p_axd.axd07a,axbb10 = p_axd.axd14b   #FUN-CC0105
       WHERE axbb01 = p_axd.axd01 AND axbb02 = p_axd.axd02
         AND axbb03 = p_axd.axd03 AND axbb04 = p_axd.axd04a
         AND axbb05 = p_axd.axd05a
         AND axbb06 = p_axd.axd08a
     #FUN-C50059--
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         LET g_success='N'
        #CALL cl_err3("upd","axb_file",p_axd.axd01,p_axd.axd02,SQLCA.sqlcode,"","axb",1)     #FUN-C50059 mark #FUN-740197 modify
         CALL cl_err3("upd","axbb_file",p_axd.axd01,p_axd.axd02,SQLCA.sqlcode,"","axbb",1)   #FUN-C50059
         RETURN
      END IF
   END IF
  #FUN-C50059--mark--
  ##有異動異動日期才需做更新
  #IF (NOT cl_null(p_axd.axd08a) AND p_axd.axd08a != p_axd.axd08b) THEN
  #   UPDATE axb_file SET axb08 = p_axd.axd08a
  #    WHERE axb01 = p_axd.axd01 AND axb02 = p_axd.axd02
  #      AND axb03 = p_axd.axd03 AND axb04 = p_axd.axd04a
  #      AND axb05 = p_axd.axd05a
  #   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
  #      LET g_success='N'
  #      CALL cl_err3("upd","axb_file",p_axd.axd01,p_axd.axd02,SQLCA.sqlcode,"","axb",1)   #FUN-740197 modify
  #      RETURN
  #   END IF
  #END IF
  #FUN-C50059--mark--
 
   #有異動投資股數才需做更新
   IF (NOT cl_null(p_axd.axd11a) AND p_axd.axd11a != p_axd.axd11b) THEN
     #FUN-C50059--mark--
     #UPDATE axb_file SET axb11 = p_axd.axd11a
     # WHERE axb01 = p_axd.axd01 AND axb02 = p_axd.axd02
     #   AND axb03 = p_axd.axd03 AND axb04 = p_axd.axd04a
     #   AND axb05 = p_axd.axd05a
     #FUN-C50059--mark--
      UPDATE axbb_file SET axbb08 = p_axd.axd11a
       WHERE axbb01 = p_axd.axd01 AND axbb02 = p_axd.axd02
         AND axbb03 = p_axd.axd03 AND axbb04 = p_axd.axd04a
         AND axbb05 = p_axd.axd05a
         AND axbb06 = p_axd.axd08a
     #FUN-C50059--
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         LET g_success='N'
        #CALL cl_err3("upd","axb_file",p_axd.axd01,p_axd.axd02,SQLCA.sqlcode,"","axb",1)     #FUN-C50059 mark #FUN-740197 modify
         CALL cl_err3("upd","axbb_file",p_axd.axd01,p_axd.axd02,SQLCA.sqlcode,"","axbb",1)   #FUN-C50059
         RETURN
      END IF
   END IF
 
   #有異動股本才需做更新
   IF (NOT cl_null(p_axd.axd12a) AND p_axd.axd12a != p_axd.axd12b) THEN
     #FUN-C50059--mark--
     #UPDATE axb_file SET axb12 = p_axd.axd12a
     # WHERE axb01 = p_axd.axd01 AND axb02 = p_axd.axd02
     #   AND axb03 = p_axd.axd03 AND axb04 = p_axd.axd04a
     #   AND axb05 = p_axd.axd05a
     #FUN-C50059--mark--
     #FUN-C50059--
      UPDATE axbb_file SET axbb09 = p_axd.axd12a
       WHERE axbb01 = p_axd.axd01 AND axbb02 = p_axd.axd02
         AND axbb03 = p_axd.axd03 AND axbb04 = p_axd.axd04a
         AND axbb05 = p_axd.axd05a
         AND axbb06 = p_axd.axd08a
     #FUN-C50059--
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         LET g_success='N'
        #CALL cl_err3("upd","axb_file",p_axd.axd01,p_axd.axd02,SQLCA.sqlcode,"","axb",1)     #FUN-C50059 mark #FUN-740197 modify
         CALL cl_err3("upd","axbb_file",p_axd.axd01,p_axd.axd02,SQLCA.sqlcode,"","axbb",1)   #FUN-C50059
         RETURN
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t002_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("axc06,axc01,axc02",TRUE)       #FUN-930056 mod     
   END IF
END FUNCTION
 
FUNCTION t002_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("axc06,axc01,axc02",FALSE)       #FUN-930056 mod
   END IF
END FUNCTION
 
FUNCTION t002_set_entry_b()
 
   CALL cl_set_comp_entry("axd07a,axd11a,axd14b,axd12a",TRUE)
 
   IF cl_null(g_axd[l_ac].axd04b) THEN
      CALL cl_set_comp_entry("axd04a",TRUE)
   END IF  
 
END FUNCTION
 
FUNCTION t002_set_no_entry_b()

  #FUN-D20050 mark begin--- 
  #IF g_axd[l_ac].axd13b = 'Y' THEN
  #   #CALL cl_set_comp_entry("axd14b",FALSE)     #FUN-930056 mod   #FUN-CC0105 mark
  #   CALL cl_set_comp_entry("axd14b",TRUE)       #FUN-CC0105
  #   #LET g_axd[l_ac].axd14b = NULL              #FUN-CC0105 mark
  #   #DISPLAY BY NAME g_axd[l_ac].axd14b         #FUN-CC0105 mark
  #ELSE
  #   CALL cl_set_comp_entry("axd07a,axd11a",FALSE)
  #   LET g_axd[l_ac].axd07a = NULL
  #   LET g_axd[l_ac].axd11a = NULL
  #   DISPLAY BY NAME g_axd[l_ac].axd07a
  #   DISPLAY BY NAME g_axd[l_ac].axd11a
  #END IF
  #FUN-D20050 mark end-----
 
   IF NOT cl_null(g_axd[l_ac].axd04b) THEN
      CALL cl_set_comp_entry("axd04a",FALSE)
   END IF  
  
END FUNCTION
 
 
FUNCTION t002_set_no_required_b()  
      CALL cl_set_comp_required("axd07a,axd11a,axd14b",FALSE) #FUN-930056 mod  #TQC-940005 Add axd07a,axd11a
END FUNCTION 
 
FUNCTION t002_set_required_b()
    #FUN-CC0105-str
    #IF g_axd[l_ac].axd13b = 'N' THEN
    #  CALL cl_set_comp_required("axd14b",TRUE)        #FUN-930056 mod
    #END IF
    #FUN-CC0105-end
   #FUN-D20050 mark begin---
   #IF g_axd[l_ac].axd13b = 'Y' THEN
   #  CALL cl_set_comp_required("axd07a,axd11a",TRUE)
   #END IF
   #FUN-D20050 mark end-----
   #CALL cl_set_comp_required("axd14b,axd12a",TRUE)    #FUN-CC0105    #FUN-D20049 mark
    CALL cl_set_comp_required("axd12a",TRUE)           #FUN-D20049 add
END FUNCTION
#No.FUN-9C0072 精簡程式碼
#CHI-C80041---begin
FUNCTION t002_v()
DEFINE l_chr LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_axc.axc06) OR cl_null(g_axc.axc01) OR cl_null(g_axc.axc02) OR cl_null(g_axc.axc03) THEN
      CALL cl_err('',-400,0) 
      RETURN 
   END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t002_cl USING g_axc.axc06,g_axc.axc01,g_axc.axc02,g_axc.axc03
   IF STATUS THEN
      CALL cl_err("OPEN t002_cl:", STATUS, 1)
      CLOSE t002_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t002_cl INTO g_axc.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_axc.axc01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t002_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_axc.axcconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_axc.axcconf)   THEN 
        LET l_chr=g_axc.axcconf
        IF g_axc.axcconf='N' THEN 
            LET g_axc.axcconf='X' 
        ELSE
            LET g_axc.axcconf='N'
        END IF
        UPDATE axc_file
            SET axcconf=g_axc.axcconf,  
                axcmodu=g_user,
                axcdate=g_today
            WHERE axc06=g_axc.axc06
              AND axc01=g_axc.axc01
              AND axc02=g_axc.axc02
              AND axc03=g_axc.axc03
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","axc_file",g_axc.axc01,"",SQLCA.sqlcode,"","",1)  
            LET g_axc.axcconf=l_chr 
        END IF
        DISPLAY BY NAME g_axc.axcconf
   END IF
 
   CLOSE t002_cl
   COMMIT WORK
   CALL cl_flow_notify(g_axc.axc01,'V')
 
END FUNCTION
#CHI-C80041---end
