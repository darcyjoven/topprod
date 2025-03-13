# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: gglt001.4gl
# Descriptions...: 聯屬公司異動維護作業
# Date & Author..: 01/09/24 By Debbie Hsu
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.MOD-490360 Kammy INPUT ARRAY 未加without defaults
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0048 04/12/08 By Nicola 權限控管修改
# Modify.........: NO.MOD-420449 05/07/11 By Yiting key值可更改
# Modify.........: NO.FUN-580072 1.輸入公司代碼時check asg_file ,call t002_asg()
#                                2.增加變更agli002之asb11,asb12
#                                3.單身LAYOUT改用SCROLLGRID
# Modify.........: NO.FUN-590015 05/09/08 By Dido 1.增加單頭帳別自動帶入
#                                                 2.單身下層公司視窗修改
#                                                 3.SCROLLGRID無法轉Excel所以此功能予以取消
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: NO.MOD-630094 06/03/24 BY yiting 族群代號請開放可直接輸入,而非一定需經由(^P)挑選
# Modify.........: No.TQC-660043 06/06/16 By Smapmin 將資料庫代碼改為營運中心代碼
# Modify.........: No.FUN-660123 06/06/28 By Jackho cl_err --> cl_err3
# Modify.........: No.MOD-670034 06/07/07 By day 去掉多余call的q_asb
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
# Modify.........: No.MOD-780107 07/08/17 By Sarah 1.執行"確認"要將異動後資料寫回asb_file之前,需先判斷有變更的值才需回寫,更新asb_file應以key值更新,不分asg04
#                                                  2."營運中心名稱"改成"公司名稱",統一抓asg02
# Modify.........: No.TQC-790064 07/09/21 By xiaofeizhu 查詢時狀態欄是灰色的，無法錄入
# Modify.........: No.FUN-910001 09/05/20 By jan   單身增加asd13b(股本否),asd14b(會計科目),
#                                                  當asd13b=Y時,可維護持股比例、投資股數,asd13b=N時,可維護會計科目、記帳幣別金額
# Modify.........: No.FUN-910023 09/05/20 By jan   執行確認,金額回寫至agli011時,只寫異動額(修改後金額-修改前金額)
# Modify.........: No.FUN-920112 09/05/20 By jan   1.gglt001在單身"股本asd13b"欄位勾選為'N'時，會科asd14b及金額asd12a改為required,not null
#                                                  2.gglt001在抓取ash_file時，少了一個key值條件"合併前科目"(ash04 = asd14b) 造成撈到多筆會科資料 (#1870行)
#                                                  3.維護gglt001單身股本asd13b應給予預設值Y/N
# Modify.........: NO.FUN-920211 09/05/21 BY ve007 非股本時asd13b = 'N'，不回寫asb12
# Modify.........: NO.FUN-930081 09/05/21 BY ve007 股本asd13b"欄位勾選為'N'時，會科asd14b及金額asd12a改為required,not null
# Modify.........: NO.FUN-930056 09/05/21 BY ve007 
# Modify.........: NO.TQC-940005 09/05/29 BY jan 股本asd13b"欄位勾選為'Y'時，asd07b,asd11b改為required,not null
# Modify.........: NO.FUN-970048 09/07/20 By hongmei 增加asd13b為Y時，回寫asf_file 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0099 09/12/16 By jan GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现
# Modify.........: No:FUN-B20004 11/02/09 By destiny 科目查询自动过滤
# Modify.........: No:CHI-B30045 11/03/14 By zhangweib 單身" 股本否(asd13b)" 一律預設'Y' ,NOENTRY
# Modify.........: No:MOD-B30383 11/03/14 By zhangweib 取消回寫agli011程式段, gglt001只針對agli002作更新
# Modify.........: No:FUN-B50001 11/05/05 By zhangweib agli002有加納入合併否asb06,所以gglt001相應也要增加對此欄位異動，以留下此欄位的異動記錄 
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C70033 12/07/05 By lujh 錄入，【asd06b 異動前納入合並否】欄位未賦默認值
#                                                 錄入完單身確定報錯“(-391)DS4 無法將 null 插入欄的 "欄-名稱"
# Modify.........: No:CHI-C80041 12/12/28 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds   #FUN-BB0036
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_asc          RECORD LIKE asc_file.*,
    g_asc_t        RECORD LIKE asc_file.*,
    g_asc_o        RECORD LIKE asc_file.*,
    g_asc01_t      LIKE asc_file.asc01,
    g_asc02_t      LIKE asc_file.asc02,
    g_asc03_t      LIKE asc_file.asc03,
    g_asc06_t      LIKE asc_file.asc06,
#   g_cpf   RECORD LIKE cpf_file.*,         #FUN-BB0036
    g_asd           DYNAMIC ARRAY OF RECORD
        asd04       LIKE asd_file.asd04,
        before      LIKE type_file.chr1,      #FUN-580072   #No.FUN-680098 VARCHAR(1)
        asd04b      LIKE asd_file.asd04b,
        azp02b      LIKE azp_file.azp02,
        azp03b      LIKE azp_file.azp03,
        asd05b      LIKE asd_file.asd05b,
        asd07b      LIKE asd_file.asd07b,
        asd06b      LIKE asd_file.asd06b,     #FUN-B50001 Add
        asd08b      LIKE asd_file.asd08b,
        asd11b      LIKE asd_file.asd11b,     #FUN-580072
        asd12b      LIKE asd_file.asd12b,     #FUN-580072
        after       LIKE type_file.chr1,      #FUN-580072   #No.FUN-680098 VARCHAR(1)
        asd04a      LIKE asd_file.asd04a,
        azp02a      LIKE azp_file.azp02,
        azp03a      LIKE azp_file.azp03,
        asd05a      LIKE asd_file.asd05a,
        asd13b      LIKE asd_file.asd13b,     #FUN-910001 add
        asd07a      LIKE asd_file.asd07a,
        asd06a      LIKE asd_file.asd06a,     #FUN-B50001 Add
        asd08a      LIKE asd_file.asd08a,
        asd11a      LIKE asd_file.asd11a,     #FUN-580072
        asd14b      LIKE asd_file.asd14b,     #FUN-910001 add
        asd12a      LIKE asd_file.asd12a      #FUN-580072
                    END RECORD,
    g_asd_t         RECORD
        asd04       LIKE asd_file.asd04,
        before      LIKE type_file.chr1,      #FUN-580072   #No.FUN-680098 VARCHAR(1)
        asd04b      LIKE asd_file.asd04b,
        azp02b      LIKE azp_file.azp02,
        azp03b      LIKE azp_file.azp03,
        asd05b      LIKE asd_file.asd05b,
        asd07b      LIKE asd_file.asd07b,
        asd06b      LIKE asd_file.asd06b,     #FUN-B50001 Add
        asd08b      LIKE asd_file.asd08b,
        asd11b      LIKE asd_file.asd11b,     #FUN-580072
        asd12b      LIKE asd_file.asd12b,     #FUN-580072
        after       LIKE type_file.chr1,      #FUN-580072  #No.FUN-680098 VARCHAR(1)
        asd04a      LIKE asd_file.asd04a,
        azp02a      LIKE azp_file.azp02,
        azp03a      LIKE azp_file.azp03,
        asd05a      LIKE asd_file.asd05a,
        asd13b      LIKE asd_file.asd13b,     #FUN-910001 add
        asd07a      LIKE asd_file.asd07a,
        asd06a      LIKE asd_file.asd06a,     #FUN-B50001 Add
        asd08a      LIKE asd_file.asd08a,
        asd11a      LIKE asd_file.asd11a,     #FUN-580072
        asd14b      LIKE asd_file.asd14b,     #FUN-910001 add
        asd12a      LIKE asd_file.asd12a      #FUN-580072
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,               #No.FUN-580092 HCN      
    g_rec_b         LIKE type_file.num5,      #單身筆數        #No.FUN-680098 smallint
    g_j             LIKE type_file.num5,      #No.FUN-680098   smallint
    l_cmd           LIKE type_file.chr1000,   #No.FUN-680098   VARCHAR(300)
    l_wc            LIKE type_file.chr1000,   #No.FUN-680098   VARCHAR(300)
    l_ac            LIKE type_file.num5,      #目前處理的ARRAY CNT        #No.FUN-680098 smallint
    g_before_input_done LIKE type_file.num5,  #No.FUN-680098  smallint
    g_forupd_sql    STRING,       
    g_asg04         LIKE asg_file.asg04       #NO.FUN-580072
DEFINE g_cnt        LIKE type_file.num10      #No.FUN-680098 integer
DEFINE g_msg        LIKE type_file.chr1000    #No.FUN-680098 VARCHAR(72) 
DEFINE g_row_count  LIKE type_file.num10      #No.FUN-680098 integer
DEFINE g_curs_index LIKE type_file.num10      #No.FUN-680098 integer
DEFINE g_jump       LIKE type_file.num10      #No.FUN-680098 integer
DEFINE mi_no_ask    LIKE type_file.num5       #No.FUN-680098 smallint
DEFINE g_asg03      LIKE asg_file.asg03       #FUN-920112 add
DEFINE l_asg        RECORD LIKE asg_file.*    #FUN-930056 add
DEFINE g_void       LIKE type_file.chr1       #CHI-C80041
 
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
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET g_forupd_sql = " SELECT * FROM asc_file WHERE asc06 = ? AND asc01 = ? AND asc02 = ? AND asc03 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t002_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 4 LET p_col = 18
   OPEN WINDOW t002_w AT p_row,p_col WITH FORM "ggl/42f/gglt001"
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
    CALL g_asd.clear()
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0029
 
    #-->螢幕上取單頭條件
    INITIALIZE g_asc.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON asc06,asc01,asc02,         #FUN-930056 mod 
                              ascuser,ascmodu,ascgrup,ascdate,  #No.TQC-790064 add
                              ascconf
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(asc01) #族群編號
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_asa"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO asc01
                NEXT FIELD asc01
             WHEN INFIELD(asc02) #工廠編號
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_asa3"          #FUN-930056 mod
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO asc02
                NEXT FIELD asc02
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
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ascuser', 'ascgrup')
 
    CONSTRUCT g_wc2 ON asd04,asd04b,asd07b,asd06b,asd11b,asd12b,asd08b,                #FUN-B50001 Add asd06b
                             asd04a,asd13b,asd07a,asd06a,asd11a,asd14b,asd12a,asd08a   #FUN-910001 add asd13b,asd14b    #FUN-B50001 Add asd06a
 
         FROM s_asd[1].asd04,
              s_asd[1].asd04b,                  #FUN-930056 mod
              s_asd[1].asd07b,s_asd[1].asd06b,s_asd[1].asd11b,  #FUN-B50001 Add asd06b
              s_asd[1].asd12b,s_asd[1].asd08b,  #FUN-580072
              s_asd[1].asd04a,                  #FUN-930056 mod   
              s_asd[1].asd13b,   #FUN-910001 add
              s_asd[1].asd07a,s_asd[1].asd06a,s_asd[1].asd11a,  #FUN-B50001 Add asd06a
              s_asd[1].asd14b,   #FUN-910001 add
              s_asd[1].asd12a,s_asd[1].asd08a   #FUN-580072
       BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(asd04b)   #變更前下層公司
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_asg"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_asd[1].asd04b
                NEXT FIELD asd04b
             WHEN INFIELD(asd04a)   #變更後下層公司
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_asg"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_asd[1].asd04a #No.MOD-670034
                NEXT FIELD asd04a
             WHEN INFIELD(asd14b)   #會計科目
               CALL q_m_aag2(TRUE,TRUE,g_plant,g_asd[1].asd14b,'23',g_asd[1].asd05b)         #TQC-9C0099
                    RETURNING g_qryparam.multiret                  
               DISPLAY g_qryparam.multiret TO s_asd[1].asd14b                 
               NEXT FIELD asd14b
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
       LET g_sql = "SELECT  asc01,asc02,asc03,asc06 FROM asc_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY asc01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT asc_file. asc01,asc02,asc03,asc06 ",
                   "  FROM asc_file, asd_file ",
                   " WHERE asc01 = asd01 AND asc02 = asd02 AND asc03 = asd03",
                   "  AND asc06=asd00 ",
                   "  AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY asc01"
    END IF
 
    PREPARE t002_prepare FROM g_sql
    DECLARE t002_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t002_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM asc_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT asc01) FROM asc_file,asd_file ",
                  " WHERE asd00=asc06 AND asd01=asc01 AND asd02=asc02 ",
                  "   AND asd03=asc03 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
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
               IF g_asc.asc01 IS NOT NULL THEN
                  LET g_doc.column1 = "asc01"
                  LET g_doc.value1 = g_asc.asc01
                  LET g_doc.column2 = "asc02"
                  LET g_doc.value2 = g_asc.asc02
                  LET g_doc.column3 = "asc03"
                  LET g_doc.value3 = g_asc.asc03
                  LET g_doc.column4 = "asc06"
                  LET g_doc.value4 = g_asc.asc06
                  CALL cl_doc()
               END IF
            END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t001_v()
               IF g_asc.ascconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_asc.ascconf,"","","",g_void,"")
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
   CALL g_asd.clear()
    INITIALIZE g_asc.* LIKE asc_file.*             #DEFAULT 設定
    LET g_asc01_t = NULL
    #預設值及將數值類變數清成零
    LET g_asc_t.* = g_asc.*
    LET g_asc_o.* = g_asc.*
    LET g_asc.asc06 = g_today
    LET g_asc.ascconf='N'
    LET g_asc.ascuser=g_user
    LET g_asc.ascoriu = g_user #FUN-980030
    LET g_asc.ascorig = g_grup #FUN-980030
    LET g_asc.ascdate=g_today
    LET g_asc.ascgrup=g_grup
    CALL cl_opmsg('a')
    BEGIN WORK
    WHILE TRUE
        CALL t002_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_asc.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            ROLLBACK WORK
            EXIT WHILE
        END IF
        IF cl_null(g_asc.asc06) OR cl_null(g_asc.asc01) OR  # KEY 不可空白
           cl_null(g_asc.asc02) OR cl_null(g_asc.asc03)
        THEN CONTINUE WHILE
        END IF
        INSERT INTO asc_file VALUES (g_asc.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
            CALL cl_err3("ins","asc_file",g_asc.asc01,g_asc.asc02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CONTINUE WHILE
        END IF
        COMMIT WORK
 
 
        SELECT asc06 INTO g_asc.asc06 FROM asc_file
         WHERE asc01=g_asc.asc01 AND asc02=g_asc.asc02 AND asc03=g_asc.asc03
           AND asc06=g_asc.asc06
        LET g_asc06_t = g_asc.asc06        #保留舊值
        LET g_asc01_t = g_asc.asc01        #保留舊值
        LET g_asc02_t = g_asc.asc02        #保留舊值
        LET g_asc03_t = g_asc.asc03        #保留舊值
        LET g_asc_t.* = g_asc.*
        CALL g_asd.clear()
        LET g_rec_b = 0
        CALL t002_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t002_u()
    IF s_aglshut(0) THEN RETURN END IF
    IF cl_null(g_asc.asc01) THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT ascconf INTO g_asc.ascconf FROM asc_file
     WHERE asc01 = g_asc.asc01 AND asc02 = g_asc.asc02
       AND asc03 = g_asc.asc03 AND asc06 = g_asc.asc06
    IF g_asc.ascconf='X' THEN RETURN END IF  #CHI-C80041
    IF g_asc.ascconf='Y' THEN CALL cl_err('','atp-101',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_asc01_t = g_asc.asc01
    LET g_asc02_t = g_asc.asc02
    LET g_asc03_t = g_asc.asc03
    LET g_asc06_t = g_asc.asc06
    LET g_asc_o.* = g_asc.*
    BEGIN WORK
    OPEN t002_cl USING g_asc.asc06,g_asc.asc01,g_asc.asc02,g_asc.asc03
    FETCH t002_cl INTO g_asc.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_asc.asc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t002_cl ROLLBACK WORK RETURN
    END IF
    LET g_asc.ascmodu = g_user
    LET g_asc.ascdate = g_today
    CALL t002_show()
    WHILE TRUE
        LET g_asc01_t = g_asc.asc01
        LET g_asc02_t = g_asc.asc02
        LET g_asc03_t = g_asc.asc03
        LET g_asc06_t = g_asc.asc06
        CALL t002_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_asc.*=g_asc_t.*
            CALL t002_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_asc.asc06 != g_asc06_t OR g_asc.asc01 != g_asc01_t OR
           g_asc.asc02 != g_asc02_t OR g_asc.asc03 != g_asc03_t THEN
           UPDATE asd_file SET asd00=g_asc.asc06,asd01=g_asc.asc01,
                               asd02=g_asc.asc02,asd03=g_asc.asc03
            WHERE asd00=g_asc06_t AND asd01 = g_asc01_t AND asd02=g_asc02_t
              AND asd03=g_asc03_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","asd_file",g_asc01_t,g_asc02_t,SQLCA.sqlcode,"","asd",1)  #No.FUN-660123
                CONTINUE WHILE
            END IF
        END IF
        UPDATE asc_file SET asc_file.* = g_asc.*
            WHERE asc06 = g_asc06_t AND asc01 = g_asc01_t AND asc02 = g_asc02_t AND asc03 = g_asc03_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","asc_file",g_asc01_t,g_asc02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660123
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
    l_asc06         LIKE asc_file.asc06
 
    DISPLAY BY NAME
        g_asc.asc06,g_asc.asc01,g_asc.asc02,g_asc.asc03,
        g_asc.ascconf,g_asc.ascuser,g_asc.ascgrup,
        g_asc.ascmodu,g_asc.ascdate
 
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
    INPUT BY NAME g_asc.ascoriu,g_asc.ascorig,
        g_asc.asc06,g_asc.asc01,g_asc.asc02,g_asc.asc03
        WITHOUT DEFAULTS
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t002_set_entry(p_cmd)
          CALL t002_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
        AFTER FIELD asc01  #族群編號
            IF NOT cl_null(g_asc.asc01) THEN
               SELECT count(*) INTO l_cnt FROM asa_file
                WHERE asa01=g_asc.asc01
               IF l_cnt = 0  THEN
                  CALL cl_err(g_asc.asc01,'agl-118',0)
                  LET g_asc.asc01 = g_asc_t.asc01
                  DISPLAY BY NAME g_asc.asc01
                  NEXT FIELD asc01
               END IF
            ELSE 
                CALL cl_err(g_asc.asc01,'mfg0037',0)
                NEXT FIELD asc01
            END IF
            LET g_asc_o.asc01 = g_asc.asc01
 
        BEFORE FIELD asc02 
            IF cl_null(g_asc.asc01) THEN
               CALL cl_err(g_asc.asc01,'mfg0037',0)
               NEXT FIELD asc01
            END IF
 
        AFTER FIELD asc02   #上層公司
            IF NOT cl_null(g_asc.asc02) THEN
               SELECT count(*) INTO l_cnt FROM asa_file
                WHERE asa01=g_asc.asc01 AND asa02=g_asc.asc02
               IF l_cnt = 0  THEN
                  CALL cl_err(g_asc.asc02,'agl-118',0)
                  LET g_asc.asc02 = g_asc_t.asc02
                  DISPLAY BY NAME g_asc.asc02
                  NEXT FIELD asc02
               END IF
 
               CALL t002_asc02('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_asc.asc02,g_errno,0)
                  NEXT FIELD asc02
               END IF
            END IF
            LET g_asc_o.asc02 = g_asc.asc02
 
        AFTER FIELD asc03   #上層帳別
            IF NOT cl_null(g_asc.asc03) THEN
               SELECT count(*) INTO l_cnt FROM asa_file
                WHERE asa01=g_asc.asc01 AND asa02=g_asc.asc02
                  AND asa03=g_asc.asc03
               IF l_cnt = 0  THEN
                  CALL cl_err(g_asc.asc03,'agl-118',0)
                  LET g_asc.asc03 = g_asc_t.asc03
                  DISPLAY BY NAME g_asc.asc03
                  NEXT FIELD asc03
               END IF
               #增加上層公司+帳別的合理性判斷,應存在agli009
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM asg_file
                WHERE asg01=g_asc.asc02 AND asg05=g_asc.asc03
               IF l_cnt = 0 THEN
                  CALL cl_err(g_asc.asc03,'agl-946',0)
                  NEXT FIELD asc03
               END IF
               #-->尚有未確認資料
               IF g_asc.asc01 != g_asc01_t OR g_asc01_t IS NULL OR
                  g_asc.asc02 != g_asc02_t OR g_asc02_t IS NULL OR
                  g_asc.asc03 != g_asc03_t OR g_asc03_t IS NULL OR
                  g_asc.asc06 != g_asc06_t OR g_asc03_t IS NULL THEN
                  SELECT count(*) INTO l_n FROM asc_file
                   WHERE asc01 = g_asc.asc01 AND asc02=g_asc.asc02
                     AND asc03 = g_asc.asc03 AND ascconf='N'
                   IF l_n > 0 THEN
                      CALL cl_err(g_asc.asc06,'agl-119',0)
                      NEXT FIELD asc01
                   END IF
               END IF
 
               #-->已存在較大日期者,不可再新增
               SELECT max(asc06) INTO l_asc06 FROM asc_file
                      WHERE asc01=g_asc.asc01 AND asc02=g_asc.asc02
                        AND asc03=g_asc.asc03
               IF NOT cl_null(l_asc06) AND l_asc06>=g_asc.asc06
               THEN CALL cl_err(g_asc.asc06,'agl-122',0)
                    NEXT FIELD asc01
               END IF
            END IF
 
        AFTER INPUT
           LET g_asc.ascuser = s_get_data_owner("asc_file") #FUN-C10039
           LET g_asc.ascgrup = s_get_data_group("asc_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
           LET l_flag='N'
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(asc01) #族群編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_asa"
                 LET g_qryparam.default1 = g_asc.asc01
                 CALL cl_create_qry() RETURNING g_asc.asc01,g_asc.asc02,g_asc.asc03
                 DISPLAY BY NAME g_asc.asc01,g_asc.asc02,g_asc.asc03
                 NEXT FIELD asc01
              WHEN INFIELD(asc02) #上層公司編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_asa3"          #FUN-930056 mod   #FUN-740174
                 LET g_qryparam.arg1 = g_asc.asc01      #FUN-930056 add
                 LET g_qryparam.default1 = g_asc.asc02
                 CALL cl_create_qry() RETURNING g_asc.asc02
                 DISPLAY BY NAME g_asc.asc02
                 NEXT FIELD asc02
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           DISPLAY g_fld_name,'yiting'
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION CONTROLZ
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
 
FUNCTION  t002_asc02(p_cmd)
DEFINE p_cmd            LIKE type_file.chr1,  #No.FUN-680098 VARCHAR(1)
        l_asg02         LIKE asg_file.asg02,  #NO.FUN-580072
        l_asg03         LIKE asg_file.asg03,  #NO.FUN-580072
        l_asg05         LIKE asg_file.asg05,  #NO.FUN-590015
        l_azp03         LIKE azp_file.azp03   #TQC-660043
 
    LET g_errno = ' '
 
    SELECT asg02,asg03,asg05 INTO l_asg02,l_asg03,l_asg05
      FROM asg_file
     WHERE asg01 = g_asc.asc02
 
    CASE
       WHEN SQLCA.SQLCODE=100
          LET g_errno = 'mfg9142'
          LET l_asg02 = NULL
          LET l_asg03 = NULL
          LET l_asg05 = NULL
       OTHERWISE
          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
 
    LET g_asc.asc03=l_asg05   #FUN-930056 add
 
    SELECT azp03 INTO l_azp03 FROM azp_file where azp01 = l_asg03   #TQC-660043
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_asg02  TO FORMONLY.azp02
       DISPLAY l_azp03  TO FORMONLY.azp03   #TQC-660043
       DISPLAY l_asg05  TO asc03
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION t002_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_asc.* TO NULL              #No.FUN-6B0040
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_asd.clear()
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
        INITIALIZE g_asc.* TO NULL
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
        WHEN 'N' FETCH NEXT     t002_cs INTO g_asc.asc01,
                                             g_asc.asc02,g_asc.asc03,g_asc.asc06
        WHEN 'P' FETCH PREVIOUS t002_cs INTO g_asc.asc01,
                                             g_asc.asc02,g_asc.asc03,g_asc.asc06
        WHEN 'F' FETCH FIRST    t002_cs INTO g_asc.asc01,
                                             g_asc.asc02,g_asc.asc03,g_asc.asc06
        WHEN 'L' FETCH LAST     t002_cs INTO g_asc.asc01,
                                             g_asc.asc02,g_asc.asc03,g_asc.asc06
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
            FETCH ABSOLUTE g_jump t002_cs INTO g_asc.asc01,
                                             g_asc.asc02,g_asc.asc03,g_asc.asc06
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_asc.asc01,SQLCA.sqlcode,0)
        INITIALIZE g_asc.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_asc.* FROM asc_file WHERE asc06 = g_asc.asc06 AND asc01 = g_asc.asc01 AND asc02 = g_asc.asc02 AND asc03 = g_asc.asc03
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","asc_file",g_asc.asc01,g_asc.asc02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
       INITIALIZE g_asc.* TO NULL
       RETURN
    ELSE
       LET g_data_owner = g_asc.ascuser     #No.FUN-4C0048
       LET g_data_group = g_asc.ascgrup     #No.FUN-4C0048
       CALL t002_show()
    END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t002_show()
 
    LET g_asc_t.* = g_asc.*                #保存單頭舊值
    DISPLAY BY NAME g_asc.ascoriu,g_asc.ascorig,
 
        g_asc.asc06,g_asc.asc01,g_asc.asc02,g_asc.asc03,
        g_asc.ascconf,g_asc.ascuser,g_asc.ascgrup,
        g_asc.ascmodu,g_asc.ascdate
    #CALL cl_set_field_pic(g_asc.ascconf,"","","","","")  #CHI-C80041
    IF g_asc.ascconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_asc.ascconf,"","","",g_void,"")  #CHI-C80041
    CALL t002_asc02('d')
    CALL t002_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t002_r()
  DEFINE l_n    LIKE type_file.num5          #No.FUN-680098 smallint
    IF s_aglshut(0) THEN RETURN END IF
    IF g_asc.asc01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    SELECT * INTO g_asc.* FROM asc_file
     WHERE asc01 = g_asc.asc01 AND asc02=g_asc.asc02 AND asc03=g_asc.asc03
       AND asc06 = g_asc.asc06
    IF g_asc.ascconf='X' THEN RETURN END IF  #CHI-C80041
    IF g_asc.ascconf='Y' THEN CALL cl_err('','atp-101',0) RETURN END IF
    BEGIN WORK
    OPEN t002_cl USING g_asc.asc06,g_asc.asc01,g_asc.asc02,g_asc.asc03
    FETCH t002_cl INTO g_asc.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_asc.asc01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t002_cl ROLLBACK WORK RETURN
    END IF
    CALL t002_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "asc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_asc.asc01      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "asc02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_asc.asc02      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "asc03"         #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_asc.asc03      #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "asc06"         #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_asc.asc06      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM asc_file
        WHERE asc01 = g_asc.asc01 AND asc02 = g_asc.asc02
          AND asc03 = g_asc.asc03 AND asc06 = g_asc.asc06
       DELETE FROM asd_file WHERE asd01 = g_asc.asc01 AND asd02 = g_asc.asc02
          AND asd03 = g_asc.asc03 AND asd00 = g_asc.asc06
       INITIALIZE g_asc.* TO NULL
       CALL g_asd.clear()
       CLEAR FORM
       OPEN t002_count
       FETCH t002_count INTO g_row_count
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
    l_sql           LIKE type_file.chr1000,        #No.FUN-680098     VARCHAR(150)
    l_allow_insert  LIKE type_file.num5,           #可新增否          #No.FUN-680098 smallint
    l_allow_delete  LIKE type_file.num5,           #可刪除否          #No.FUN-680098 smallint
    l_cmd           LIKE type_file.chr1            #No.FUN-680098     VARCHAR(2)
 
DEFINE l_azp03a     LIKE type_file.chr21,          #FUN-920112 add
       l_asg04      LIKE asg_file.asg04,           #FUN-920112 add
       l_aag02      LIKE aag_file.aag02,           #FUN-920112 add
       l_n1         LIKE type_file.num5,           #FUN-920112 add
       l_ash06      LIKE ash_file.ash06            #FUN-930056 add
 
    LET g_action_choice = ""
 
    IF s_aglshut(0) THEN RETURN END IF
    IF cl_null(g_asc.asc01)  THEN RETURN END IF
    SELECT * INTO g_asc.* FROM asc_file
     WHERE asc01=g_asc.asc01 AND asc02=g_asc.asc02
       AND asc03=g_asc.asc03 AND asc06=g_asc.asc06
    IF g_asc.ascconf='X' THEN RETURN END IF  #CHI-C80041
    IF g_asc.ascconf='Y' THEN
       CALL cl_err("",'aap-005',0) RETURN         #FUN-740197 
    END IF
 
    CALL cl_opmsg('b')
 
 
    LET g_forupd_sql =
        "SELECT asd04,'0',asd04b,' ',' ',asd05b,asd07b,asd06b,asd08b,asd11b,asd12b,",               #FUN-B50001 Add asd06b
        "             '1',asd04a,' ',' ',asd05a,asd13b,asd07a,asd06a,asd08a,asd11a,asd14b,asd12a",  #FUN-B50001 Add asd06a
        "  FROM asd_file ",
        "  WHERE asd00=? AND asd01=? AND asd02=? ",
        "   AND asd03=? AND asd04=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t002_bcl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    INPUT ARRAY g_asd WITHOUT DEFAULTS FROM s_asd.* #No.MOD-490360
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
            CALL cl_set_comp_entry("asd13b",FALSE)        #No.CHI-B30045    add
            BEGIN WORK
            OPEN t002_cl USING g_asc.asc06,g_asc.asc01,g_asc.asc02,g_asc.asc03
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_asc.asc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t002_cl 
               ROLLBACK WORK 
               RETURN
            ELSE
               FETCH t002_cl INTO g_asc.*            # 鎖住將被更改或取消的資料



               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_asc.asc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                  CLOSE t002_cl 
                  ROLLBACK WORK 
                  RETURN
               END IF
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_asd_t.* = g_asd[l_ac].*  #BACKUP
                OPEN t002_bcl USING g_asc.asc06,g_asc.asc01,g_asc.asc02,
                                    g_asc.asc03 ,g_asd_t.asd04
                IF STATUS THEN
                   CALL cl_err("OPEN t002_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t002_bcl INTO g_asd[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_asd_t.asd04,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   SELECT asg02,azp03
                     INTO g_asd[l_ac].azp02b,g_asd[l_ac].azp03b
                     FROM asg_file LEFT OUTER JOIN azp_file ON asg03 = azp01    #MOD-780107 OUTER azp_file
                      WHERE asg01 = g_asd[l_ac].asd04b
                   IF SQLCA.sqlcode THEN LET g_asd[l_ac].azp02b = ' '
                                         LET g_asd[l_ac].azp03b = ' '
                   END IF
                   SELECT asg02,azp03
                     INTO g_asd[l_ac].azp02a,g_asd[l_ac].azp03a
                     FROM asg_file LEFT OUTER JOIN azp_file ON asg03 = azp01    #MOD-780107 OUTER azp_file
                      WHERE asg01 = g_asd[l_ac].asd04a
                   IF SQLCA.sqlcode THEN LET g_asd[l_ac].azp02a = ' '
                                         LET g_asd[l_ac].azp03a = ' '
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
           INITIALIZE g_asd[l_ac].* TO NULL      #900423
           LET g_asd[l_ac].before = '0'
           LET g_asd[l_ac].after  = '1'
           LET g_asd_t.* = g_asd[l_ac].*         #新輸入資料
           LET g_asd[l_ac].asd13b = 'Y'          #No.CHI-B30045  add
           LET g_asd[l_ac].asd06a = 'N'          #TQC-C70033   add
           LET g_asd[l_ac].asd06b = 'N'          #TQC-C70033   add
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           CALL t002_set_entry_b()         #FUN-930056 add
           CALL t002_set_no_entry_b()      #FUN-930056 add
           CALL t002_set_no_required_b()  #FUN-930081
           CALL t002_set_required_b()    #FUN-930081
           NEXT FIELD asd04
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF

            #TQC-C70033--add--str--
            IF cl_null(g_asd[l_ac].asd07a) THEN 
                LET g_asd[l_ac].asd07a = 0
            END IF 
            IF cl_null(g_asd[l_ac].asd07b) THEN
                LET g_asd[l_ac].asd07b = 0
            END IF
            IF cl_null(g_asd[l_ac].asd11a) THEN
                LET g_asd[l_ac].asd11a = 0
            END IF
            IF cl_null(g_asd[l_ac].asd11b) THEN
                LET g_asd[l_ac].asd11b = 0
            END IF
            IF cl_null(g_asd[l_ac].asd12a) THEN
                LET g_asd[l_ac].asd12a = 0
            END IF
            IF cl_null(g_asd[l_ac].asd12b) THEN
                LET g_asd[l_ac].asd12b = 0
            END IF
            #TQC-C70033--add--end--

            INSERT INTO asd_file (asd00,asd01,asd02,asd03,asd04,
                                  asd04b,asd05b,asd07b,asd06b,asd08b,asd11b,asd12b,   #FUN-B50001 Add asd06b
                                  asd04a,asd05a,asd07a,asd06a,asd08a,asd11a,asd12a,   #FUN-B50001 Add asd06a
                                  asd13b,asd14b)   #FUN-910001 add
             VALUES(g_asc.asc06,g_asc.asc01,g_asc.asc02,g_asc.asc03,
                    g_asd[l_ac].asd04,
                    g_asd[l_ac].asd04b,g_asd[l_ac].asd05b,
                    g_asd[l_ac].asd07b,g_asd[l_ac].asd06b,g_asd[l_ac].asd08b,  #FUN-B50001 Add asd06b
                    g_asd[l_ac].asd11b,g_asd[l_ac].asd12b,  #FUN-580072
                    g_asd[l_ac].asd04a,g_asd[l_ac].asd05a,  
                    g_asd[l_ac].asd07a,g_asd[l_ac].asd06a,g_asd[l_ac].asd08a,  #FUN-B50001 Add asd06a
                    g_asd[l_ac].asd11a,g_asd[l_ac].asd12a,  #FUN-580072
                    g_asd[l_ac].asd13b,g_asd[l_ac].asd14b)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","asd_file",g_asc.asc01,g_asd[l_ac].asd04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               CANCEL INSERT
            ELSE
               LET g_rec_b = g_rec_b + 1
               DISPLAY g_rec_b TO FORMONLY.cn2
               MESSAGE 'INSERT O.K'
            END IF
 
        BEFORE FIELD asd04                        #default 序號
            IF cl_null(g_asd[l_ac].asd04) OR
                  g_asd[l_ac].asd04 = 0  THEN
                  SELECT max(asd04)+1 INTO g_asd[l_ac].asd04
                    FROM asd_file
                   WHERE asd00=g_asc.asc06 AND asd01 = g_asc.asc01
                     AND asd02=g_asc.asc02 AND asd03 = g_asc.asc03
                 IF cl_null(g_asd[l_ac].asd04) THEN
                     LET g_asd[l_ac].asd04 = 1
                 END IF
            END IF
            LET g_asd[l_ac].asd08a=g_asc.asc06
 
        AFTER FIELD asd04   #項次
            IF NOT cl_null(g_asd[l_ac].asd04) THEN
               IF g_asd[l_ac].asd04 != g_asd_t.asd04 OR
                  g_asd_t.asd04 IS NULL THEN
                   SELECT COUNT(*) INTO l_n FROM asd_file
                    WHERE asd00 = g_asc.asc06 AND asd01 = g_asc.asc01
                      AND asd02 = g_asc.asc02 AND asd03 = g_asc.asc03
                      AND asd04 = g_asd[l_ac].asd04
                   IF l_n > 1 THEN
                       LET g_asd[l_ac].asd04 = g_asd_t.asd04
                       CALL cl_err('',-239,0) NEXT FIELD asd04
                   END IF
               END IF
            END IF
            LET g_asd[l_ac].asd08a=g_asc.asc06
 
       AFTER FIELD asd04b  #變更前工廠
           #-->檢查是否存在聯屬公司層級單身檔(asb_file)
           IF NOT cl_null(g_asd[l_ac].asd04b) THEN
               SELECT COUNT(*) INTO l_cnt
                 FROM asb_file
                WHERE asb01=g_asc.asc01 AND asb02=g_asc.asc02
                  AND asb03=g_asc.asc03 AND asb04=g_asd[l_ac].asd04b
               IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
               IF l_cnt <=0  THEN
                  LET g_asd[l_ac].asd04b = g_asd_t.asd04b
                  CALL cl_err(g_asd[l_ac].asd04b,'agl-221',0) NEXT FIELD asd04b
                  NEXT FIELD asd04b
               END IF
               #-->檢查工廠與show工廠名稱/資料庫名稱
               CALL t002_asg('a1',g_asd[l_ac].asd04b,g_asd[l_ac].asd05b,p_cmd)  #NO.FUN-580072   #FUN-740174 add asd05b
               IF NOT cl_null(g_errno) THEN
                  LET g_asd[l_ac].asd04b = g_asd_t.asd04b
                  DISPLAY BY NAME g_asd[l_ac].asd04b
                  NEXT FIELD asd04b
               ELSE 
                  CALL t002_set_entry_b()
                  CALL t002_set_no_entry_b()
                  LET g_asd[l_ac].asd04a=g_asd[l_ac].asd04b
                  LET g_asd[l_ac].azp02a=g_asd[l_ac].azp02b
                  LET g_asd[l_ac].azp03a=g_asd[l_ac].azp03b
                  LET g_asd[l_ac].asd05a=g_asd[l_ac].asd05b
                  DISPLAY BY NAME g_asd[l_ac].asd04a
                  DISPLAY BY NAME g_asd[l_ac].azp02a      
                  DISPLAY BY NAME g_asd[l_ac].azp03a      
                  DISPLAY BY NAME g_asd[l_ac].asd05a      
               END IF
           END IF
 
       AFTER FIELD asd04a  #變更後工廠
           #-->檢查工廠與show工廠名稱/資料庫名稱
           IF NOT cl_null(g_asd[l_ac].asd04a) THEN
               CALL t002_asg('a2',g_asd[l_ac].asd04a,g_asd[l_ac].asd05a,p_cmd) #NO.FUN-580072   #FUN-740174 add asd05a
              IF NOT cl_null(g_errno) THEN
                 LET g_asd[l_ac].asd04a = g_asd_t.asd04a
                 DISPLAY BY NAME g_asd[l_ac].asd04a
                 NEXT FIELD asd04a
              END IF
           END IF
       
       AFTER FIELD asd05a   #變更前帳別
           IF NOT cl_null(g_asd[l_ac].asd05a) THEN
              CALL t002_asg('a2',g_asd[l_ac].asd04a,g_asd[l_ac].asd05a,p_cmd)  #NO.FUN-580072   #FUN-740174 add asd05a
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_asd[l_ac].asd05a,g_errno,1)
                 LET g_asd[l_ac].asd05a = g_asd_t.asd05a
                 DISPLAY BY NAME g_asd[l_ac].asd05a
                 NEXT FIELD asd05a
              END IF
           END IF
 
       BEFORE FIELD asd13b
           CALL t002_set_no_required_b()  #FUN-930081
 
       AFTER FIELD asd13b  #股本否
           CALL t002_set_entry_b()
           CALL t002_set_no_entry_b()
           CALL t002_set_required_b()     #FUN-930081
 
       AFTER FIELD asd07a  #持股比率
           IF NOT cl_null(g_asd[l_ac].asd07a) THEN
              IF NOT cl_null(g_asd[l_ac].asd04b) THEN
                 IF g_asd[l_ac].asd07a < 0 OR g_asd[l_ac].asd07a > 100 THEN
                    NEXT FIELD asd07a
                 END IF
              END IF
           END IF
 
       BEFORE FIELD asd14b
          LET g_asg03=''
          SELECT azp01 INTO g_asg03    
            FROM azp_file
           WHERE azp03 = g_asd[l_ac].azp03a
       
          LET l_azp03a = ''
          LET g_plant_new = g_asg03   #營運中心
          CALL s_getdbs()
          LET l_azp03a = g_dbs_new    #所屬DB
 
       AFTER FIELD asd14b
         IF NOT cl_null(g_asd[l_ac].asd14b) THEN 
            IF g_asd[l_ac].asd14b != g_asd_t.asd14b OR
               g_asd_t.asd14b IS NULL THEN
 
               LET g_sql = "SELECT COUNT(*) ",
                          #"  FROM ",l_azp03a,"asd_file",   #FUN-A50102
                           "  FROM ",cl_get_target_table(g_plant_new,'asd_file'),   #FUN-A50102
                           " WHERE asd00 = '",g_asc.asc06,"'",                
                           "   AND asd01 = '",g_asc.asc01,"'",                
                           "   AND asd02 = '",g_asc.asc02,"'",                
                           "   AND asd03 = '",g_asc.asc03,"'",                
                           "   AND asd14b = '",g_asd[l_ac].asd14b,"'"                
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
               PREPARE t002_pre_1 FROM g_sql
               DECLARE t002_cur_1 CURSOR FOR t002_pre_1
               OPEN t002_cur_1
               FETCH t002_cur_1 INTO l_n
 
               IF l_n > 0 THEN
                  CALL cl_err(g_asd[l_ac].asd14b,-239,0)
                  LET g_asd[l_ac].asd14b = g_asd_t.asd14b
                  NEXT FIELD asd14b
               END IF
 
              #LET g_sql = "SELECT COUNT(*) FROM ",l_azp03a,"aag_file",   #FUN-A50102
               LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'aag_file'), #FUN-A50102
                           " WHERE aag01 = '",g_asd[l_ac].asd14b,"'",                
                           "   AND aag00 = '",g_asd[l_ac].asd05a,"'"                
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
               PREPARE t002_pre_2 FROM g_sql
               DECLARE t002_cur_2 CURSOR FOR t002_pre_2
               OPEN t002_cur_2
               FETCH t002_cur_2 INTO l_n1
               IF l_n1 <> 1 THEN
                  CALL cl_err(g_asd[l_ac].asd14b,'aap-021',0)
                  #FUN-B20004--beatk
                  CALL q_m_aag2(FALSE,FALSE,g_plant_new,g_asd[l_ac].asd14b,'23',g_asd[l_ac].asd05b)
                     RETURNING g_asd[l_ac].asd14b       
                  #FUN-B20004--end                  
                  #LET g_asd[l_ac].asd14b = g_asd_t.asd14b
                  NEXT FIELD asd14b
               END IF
 
               SELECT * INTO l_asg.* FROM asg_file WHERE asg01=g_asd[l_ac].asd04a
 
               LET g_sql = "SELECT ash06 FROM ash_file",
                           " WHERE ash01 = '",g_asd[l_ac].asd04a,"'",                
                           "   AND ash00 = '",l_asg.asg05,"'",            
                           "   AND ash13 = '",g_asc.asc01,"'",            
                           "   AND ash04 = '",g_asd[l_ac].asd14b,"'"            
               PREPARE t002_pre_3 FROM g_sql
               DECLARE t002_cur_3 CURSOR FOR t002_pre_3
               OPEN t002_cur_3
               FETCH t002_cur_3 INTO l_ash06
               IF cl_null(l_ash06) THEN
                  CALL cl_err(g_asd[l_ac].asd14b,'agl-168',0)
                  LET g_asd[l_ac].asd14b = g_asd_t.asd14b
                  NEXT FIELD asd14b
               END IF
 
            END IF
         END IF
 
       
       BEFORE DELETE                            #是否取消單身
           IF g_asd_t.asd04 > 0 AND
              g_asd_t.asd04 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
{ckp#1}        DELETE FROM asd_file
                WHERE asd00 = g_asc.asc06 AND asd01 = g_asc.asc01
                  AND asd02 = g_asc.asc02 AND asd03 = g_asc.asc03
                  AND asd04 = g_asd_t.asd04
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","asd_file",g_asc.asc01,g_asd_t.asd04,SQLCA.sqlcode,"","",1) #NO.FUN-660123
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
              LET g_asd[l_ac].* = g_asd_t.*
              CLOSE t002_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_asd[l_ac].asd04,-263,1)
              LET g_asd[l_ac].* = g_asd_t.*
           ELSE
              UPDATE asd_file
                 SET asd04=g_asd[l_ac].asd04,
                     asd04b=g_asd[l_ac].asd04b,asd05b=g_asd[l_ac].asd05b,
                     asd07b=g_asd[l_ac].asd07b,asd06b=g_asd[l_ac].asd06b,asd08b=g_asd[l_ac].asd08b,  #FUN-B50001 Add asd06b
                     asd11b=g_asd[l_ac].asd11b,asd12b=g_asd[l_ac].asd12b,  #FUN-580072
                     asd04a=g_asd[l_ac].asd04a,asd05a=g_asd[l_ac].asd05a,
                     asd07a=g_asd[l_ac].asd07a,asd06a=g_asd[l_ac].asd06a,asd08a=g_asd[l_ac].asd08a,  #FUN-B50001 Add asd06a
                     asd11a=g_asd[l_ac].asd11a,asd12a=g_asd[l_ac].asd12a,  #FUN-580072
                     asd13b=g_asd[l_ac].asd13b,asd14b=g_asd[l_ac].asd14b   #FUN-910001 add
               WHERE asd00=g_asc.asc06 AND asd01=g_asc.asc01
                 AND asd02=g_asc.asc02 AND asd03=g_asc.asc03
                 AND asd04=g_asd_t.asd04
              IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","asd_file",g_asc.asc01,g_asc.asc02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                  LET g_asd[l_ac].* = g_asd_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
              END IF
           END IF
 
       AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac      #FUN-D30032 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_asd[l_ac].* = g_asd_t.*
              #FUN-D30032--add--str--
              ELSE
                 CALL g_asd.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30032--add--end-- 
              END IF
              CLOSE t002_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac      #FUN-D30032 Add
           CLOSE t002_bcl
           COMMIT WORK
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(asd04b)   #變更前下層公司
                  CALL q_asb(FALSE,TRUE,g_asc.asc01,g_asc.asc02,
                                        g_asc.asc03,g_asd[l_ac].asd04b)
                       RETURNING g_asd[l_ac].asd04b,g_asd[l_ac].asd05b,
                                 g_asd[l_ac].asd07b,g_asd[l_ac].asd08b
                  DISPLAY BY NAME g_asd[l_ac].asd04b
                  DISPLAY BY NAME g_asd[l_ac].asd05b
                  DISPLAY BY NAME g_asd[l_ac].asd07b
                  DISPLAY BY NAME g_asd[l_ac].asd08b
                  NEXT FIELD asd04b
             WHEN INFIELD(asd04a)   #變更後下層公司
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_asg"
                  LET g_qryparam.default1 = g_asd[l_ac].asd04a
                  CALL cl_create_qry() RETURNING g_asd[l_ac].asd04a
                  DISPLAY BY NAME g_asd[l_ac].asd04a
                  DISPLAY BY NAME g_asd[l_ac].asd04a
                  NEXT FIELD asd04a
             WHEN INFIELD(asd14b)   #會計科目
                CALL q_m_aag2(FALSE,TRUE,g_plant_new,g_asd[l_ac].asd14b,'23',g_asd[l_ac].asd05b)#TQC-9C0099 
                     RETURNING g_asd[l_ac].asd14b                  
                #DISPLAY g_qryparam.multiret TO asd14b   #FUN-B20004    
                DISPLAY g_asd[l_ac].asd14b TO asd14b     #FUN-B20004    
                NEXT FIELD asd14b
               
             OTHERWISE EXIT CASE
          END CASE
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(asd04) AND l_ac > 1 THEN
              LET g_asd[l_ac].* = g_asd[l_ac-1].*
              LET g_asd[l_ac].asd04 = NULL
              NEXT FIELD asd04
          END IF
 
       ON ACTION CONTROLZ
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
 
    LET g_asc.ascmodu = g_user
    LET g_asc.ascdate = g_today
    UPDATE asc_file SET ascmodu = g_asc.ascmodu,ascdate = g_asc.ascdate
     WHERE asc06 = g_asc.asc06 AND asc01 = g_asc.asc01 AND asc02 = g_asc.asc02 AND asc03 = g_asc.asc03
    DISPLAY BY NAME g_asc.ascmodu,g_asc.ascdate
 
    CLOSE t002_bcl
    COMMIT WORK
#   CALL t002_delall() #CHI-C30002 mark
    CALL t002_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
FUNCTION t002_asg(p_cmd,p_asg01,p_asg05,l_cmd)        #FUN-740174 add p_asg05
DEFINE p_cmd           LIKE type_file.chr2,           #No.FUN-680098  VARCHAR(2)
       l_cmd           LIKE type_file.chr1,           #No.FUN-680098  VARCHAR(2)
       p_asg01         LIKE asg_file.asg01,
       p_asg05         LIKE asg_file.asg05,           #FUN-740174 add   #帳別
       l_asg02         LIKE asg_file.asg02,
       l_asg03         LIKE asg_file.asg03,
       l_asg05         LIKE asg_file.asg05,
       l_asb07         LIKE asb_file.asb07,
       l_asb06         LIKE asb_file.asb06,           #FUN-B50001 Add
       l_asb08         LIKE asb_file.asb08,
       l_asb11         LIKE asb_file.asb11,
       l_asb12         LIKE asb_file.asb12,
       l_azp02         LIKE azp_file.azp02,  #MOD-740105 add
       l_azp03         LIKE azp_file.azp03   #TQC-660043
 
    LET g_errno = ' '
    IF p_cmd = 'a2' AND (INFIELD(asd04a) OR INFIELD(asd05a)) THEN
       IF cl_null(p_asg05) THEN   #FUN-740174 add
          SELECT asg02,asg03,asg05,'','','','',''                                  #FUN-B50001 Add ''
            INTO l_asg02,l_asg03,l_asg05,l_asb07,l_asb06,l_asb08,l_asb11,l_asb12   #FUN-B50001 Add l_asb06
            FROM asg_file
           WHERE asg01 = p_asg01
       ELSE
          SELECT asg02,asg03,asg05,'','','','',''                                  #FUN-B50001 Add ''
            INTO l_asg02,l_asg03,l_asg05,l_asb07,l_asb06,l_asb08,l_asb11,l_asb12   #FUN-B50001 Add l_asb06
            FROM asg_file
           WHERE asg01 = p_asg01
             AND asg05 = p_asg05 
       END IF
    ELSE
       IF cl_null(p_asg05) THEN   #FUN-740174 add
          SELECT asg02,asg03,asg05,asb07,asb06,asb08,asb11,asb12                   #FUN-B50001 Add asb06
            INTO l_asg02,l_asg03,l_asg05,l_asb07,l_asb06,l_asb08,l_asb11,l_asb12   #FUN-B50001 Add l_asb06
            FROM asg_file,asb_file
           WHERE asb04 = asg01
             AND asb04 = p_asg01
             AND asb01 = g_asc.asc01
             AND asb02 = g_asc.asc02
             AND asb03 = g_asc.asc03
       ELSE   #檢查公司+帳別是否存在agli009
          SELECT asg02,asg03,asg05,asb07,asb06,asb08,asb11,asb12                   #FUN-B50001 Add asb06
            INTO l_asg02,l_asg03,l_asg05,l_asb07,l_asb06,l_asb08,l_asb11,l_asb12           #FUN-B50001 Add l_asb06
            FROM asg_file,asb_file
           WHERE asb04 = asg01
             AND asb04 = p_asg01
             AND asb05 = p_asg05
             AND asb01 = g_asc.asc01
             AND asb02 = g_asc.asc02
             AND asb03 = g_asc.asc03
       END IF
    END IF    #MOD-740105 add
 
    CASE WHEN SQLCA.SQLCODE =100  
              IF cl_null(p_asg05) THEN
                 LET g_errno = 'mfg9142'
              ELSE
                 LET g_errno = 'agl-946'
              END IF
              LET l_asg02 = NULL LET l_asg03 = NULL
              LET l_asg05 = NULL LET l_asb07 = NULL
              LET l_asb08 = NULL LET l_asb11 = NULL
              LET l_asb12 = NULL
         OTHERWISE          
              LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
 
    SELECT azp02,azp03 INTO l_azp02,l_azp03 
      FROM azp_file where azp01 = l_asg03   #TQC-660043

    #TQC-C70033--add--str--
    IF cl_null(l_asb06) THEN 
       LET l_asb06 = 'N'
    END IF 
    #TQC-C70033--add--end--
 
    IF cl_null(g_errno) OR p_cmd = 'd1' OR p_cmd = 'd2' THEN
       IF p_cmd ='a1' OR p_cmd = 'd1' THEN
          LET g_asd[l_ac].azp02b = l_asg02                        #MOD-780107
          LET g_asd[l_ac].azp03b = l_azp03   #TQC-660043
          LET g_asd[l_ac].asd05b = l_asg05
          LET g_asd[l_ac].asd07b = l_asb07
          LET g_asd[l_ac].asd06b = l_asb06   #FUN-B50001 Add
          LET g_asd[l_ac].asd08b = l_asb08
          LET g_asd[l_ac].asd11b = l_asb11
          LET g_asd[l_ac].asd12b = l_asb12
          DISPLAY BY NAME g_asd[l_ac].azp02b,g_asd[l_ac].azp03b,   #MOD-740105 add
                          g_asd[l_ac].asd05b,g_asd[l_ac].asd07b,g_asd[l_ac].asd06b,  #FUN-B50001 Add asd06b 
                          g_asd[l_ac].asd08b,g_asd[l_ac].asd11b,
                          g_asd[l_ac].asd12b
       END IF
       IF p_cmd ='a2' OR p_cmd = 'd2' THEN
          IF l_cmd !='u' THEN
             LET g_asd[l_ac].azp02a = l_asg02                        #MOD-780107
             LET g_asd[l_ac].azp03a = l_azp03   #TQC-660043
             LET g_asd[l_ac].asd05a = l_asg05
             LET g_asd[l_ac].asd07a = l_asb07
             LET g_asd[l_ac].asd06a = l_asb06   #FUN-B50001 Add
             LET g_asd[l_ac].asd08a = g_asc.asc06
             LET g_asd[l_ac].asd11a = l_asb11
             LET g_asd[l_ac].asd12a = l_asb12
          END IF
          DISPLAY BY NAME g_asd[l_ac].azp02a,g_asd[l_ac].azp03a,   #MOD-740105 add
                          g_asd[l_ac].asd05a,g_asd[l_ac].asd07a,g_asd[l_ac].asd06a,  #FUN-B50001 Add asd06a
                          g_asd[l_ac].asd08a,g_asd[l_ac].asd11a,
                          g_asd[l_ac].asd12a
       END IF
    END IF
END FUNCTION
 
#檢查工廠編號
FUNCTION t002_azp(p_cmd,p_azp01)
DEFINE p_cmd           LIKE type_file.chr2,          #No.FUN-680098 VARCHAR(2)
       p_azp01         LIKE azp_file.azp01,
       l_asg02         LIKE asg_file.asg02,   #MOD-780107
       l_azp03         LIKE azp_file.azp03
 
    LET g_errno = ' '
    SELECT asg02,azp03 INTO l_asg02,l_azp03 FROM azp_file,asg_file   #MOD-780107
     WHERE azp01 = p_azp01
       AND azp053 != 'N'   #no.7431
       AND azp01 = asg03   #MOD-780107 add
    CASE WHEN SQLCA.SQLCODE =100  
            LET g_errno = 'mfg9142'
            LET l_asg02 = NULL   #MOD-780107
            LET l_azp03 = NULL
         OTHERWISE
            LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd1' OR p_cmd = 'd2' THEN
       IF p_cmd ='a1' OR p_cmd = 'd1' THEN
          LET g_asd[l_ac].azp02b = l_asg02   #MOD-780107
          LET g_asd[l_ac].azp03b = l_azp03
          DISPLAY BY NAME g_asd[l_ac].azp02b,g_asd[l_ac].azp03b   #MOD-5A0095 add
       END IF
       IF p_cmd ='a2' OR p_cmd = 'd2' THEN
          LET g_asd[l_ac].azp02a = l_asg02   #MOD-780107
          LET g_asd[l_ac].azp03a = l_azp03
          DISPLAY BY NAME g_asd[l_ac].azp02a,g_asd[l_ac].azp03a   #MOD-5A0095 add
       END IF
    END IF
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
         CALL t001_v()
         IF g_asc.ascconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_asc.ascconf,"","","",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM  asc_file
               WHERE asc01 = g_asc.asc01 AND asc02 = g_asc.asc02
                 AND asc03 = g_asc.asc03 AND asc06 = g_asc.asc06
         INITIALIZE g_asc.*  TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t002_delall()	# 未輸入單身資料, 是否取消單頭資料
#   SELECT COUNT(*) INTO g_cnt FROM asd_file
#    WHERE asd00 = g_asc.asc06 AND asd01 = g_asc.asc01 AND asd02 = g_asc.asc02
#      AND asd03 = g_asc.asc03
#   IF g_cnt = 0 THEN
#      DISPLAY 'Del All Record'
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM asc_file
#       WHERE asc01 = g_asc.asc01 AND asc02 = g_asc.asc02
#         AND asc03 = g_asc.asc03 AND asc06 = g_asc.asc06
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t002_b_askkey()
DEFINE
    l_wc2     LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON asd04,asd04b,asd05b,asd07b,asd06b,asd11b,asd12b,asd08b,           #FUN-B50001 Add asd06b
                             asd04a,asd05a,asd13b,asd07a,asd06a,asd11a,asd14b,asd12a,asd08a   #FUN-910001 add asd13b,asd14b  #FUN-B50001 Add asd06a
         FROM s_asd[1].asd04,
              s_asd[1].asd04b,s_asd[1].asd05b,
              s_asd[1].asd07b,s_asd[1].asd06b,s_asd[1].asd11b,    #FUN-B50001 Add asd06b
              s_asd[1].asd12b,s_asd[1].asd08b,  #FUN-580072
              s_asd[1].asd04a,s_asd[1].asd05a,
              s_asd[1].asd13b,   #FUN-910001 add
              s_asd[1].asd07a,s_asd[1].asd06a,s_asd[1].asd11a,    #FUN-B50001 Add asd06a
              s_asd[1].asd14b,   #FUN-910001 add
              s_asd[1].asd12a,s_asd[1].asd08a   #FUN-580072
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
       "SELECT asd04,'0',asd04b,' ',' ',asd05b,asd07b,asd06b,asd08b,asd11b,asd12b,",               #FUN-B50001 Add asd06b
       "             '1',asd04a,' ',' ',asd05a,asd13b,asd07a,asd06a,asd08a,asd11a,asd14b,asd12a",  #FUN-910001 add asd13b,asd14b   #FUN-B50001 Add asd06a
       "  FROM asd_file  ",
       " WHERE asd00='",g_asc.asc06,"' AND asd01='",g_asc.asc01,"'",
       "   AND asd02='",g_asc.asc02,"' AND asd03='",g_asc.asc03,"'",
       "   AND ",p_wc2 CLIPPED,
       " ORDER BY 1"
   PREPARE t002_pb FROM g_sql
   DECLARE asd_curs CURSOR FOR t002_pb       #SCROLL CURSOR
 
   CALL g_asd.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH asd_curs INTO g_asd[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT asg02,azp03 INTO g_asd[g_cnt].azp02b,g_asd[g_cnt].azp03b   #MOD-780107
        FROM asg_file LEFT OUTER JOIN azp_file ON asg03 = azp01    #MOD-780107 add OUTER
         WHERE asg01 = g_asd[g_cnt].asd04b
      IF SQLCA.sqlcode THEN LET g_asd[g_cnt].azp02b = ' '
                            LET g_asd[g_cnt].azp03b = ' '
      END IF
      SELECT asg02,azp03 INTO g_asd[g_cnt].azp02a,g_asd[g_cnt].azp03a   #MOD-780107
        FROM asg_file LEFT OUTER JOIN azp_file ON asg03 = azp01    #MOD-780107 add OUTER
         WHERE asg01 = g_asd[g_cnt].asd04a
      IF SQLCA.sqlcode THEN LET g_asd[g_cnt].azp02a = ' '
                            LET g_asd[g_cnt].azp03a = ' '
      END IF
     IF cl_null(g_asd[g_cnt].asd13b) THEN
        LET g_asd[g_cnt].asd13b = 'N'
     END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_asd.deleteElement(g_cnt)
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
   DISPLAY ARRAY g_asd TO s_asd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         #CALL cl_set_field_pic(g_asc.ascconf,"","","","","")  #CHI-C80041
         IF g_asc.ascconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_asc.ascconf,"","","",g_void,"")  #CHI-C80041
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
   DEFINE g_asd     RECORD LIKE asd_file.*
   DEFINE l_asg     RECORD LIKE asg_file.*   #FUN-910001 add
   DEFINE l_ash06   LIKE ash_file.ash06      #FUN-910001 add
   DEFINE l_yy      LIKE type_file.num5      #FUN-970048 add
   DEFINE l_mm      LIKE type_file.num5      #FUN-970048 add
   DEFINE l_n       LIKE type_file.num5      #FUN-910001 add
 
   IF cl_null(g_asc.asc01) THEN RETURN END IF
#CHI-C30107 -------------- add --------------- begin
   IF g_asc.ascconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_asc.ascconf='Y' THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM asd_file
    WHERE asd01=g_asc.asc01 AND asd00=g_asc.asc06
      AND asd02=g_asc.asc02 AND asd03=g_asc.asc03
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   #IF NOT cl_confirm('atp-108') THEN RETURN END IF     #TQC-C70033  mark
   IF NOT cl_confirm('axr-108') THEN RETURN END IF      #TQC-C70033  add
#CHI-C30107 -------------- add --------------- end
   SELECT * INTO g_asc.* FROM asc_file
    WHERE asc01=g_asc.asc01 AND asc02=g_asc.asc02 AND asc03=g_asc.asc03
      AND asc06=g_asc.asc06
   IF g_asc.ascconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_asc.ascconf='Y' THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM asd_file
    WHERE asd01=g_asc.asc01 AND asd00=g_asc.asc06
      AND asd02=g_asc.asc02 AND asd03=g_asc.asc03
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
#  IF NOT cl_confirm('atp-108') THEN RETURN END IF  #CHI-C30107 mark
 
   LET g_success='Y'
   BEGIN WORK
   OPEN t002_cl USING g_asc.asc06,g_asc.asc01,g_asc.asc02,g_asc.asc03
   FETCH t002_cl INTO g_asc.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_asc.asc01,SQLCA.sqlcode,0)
      CLOSE t002_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   DECLARE t002_asb CURSOR FOR              # LOCK CURSOR
    SELECT * FROM asd_file
     WHERE asd00 = g_asc.asc06 AND asd01 = g_asc.asc01
       AND asd02 = g_asc.asc02 AND asd03 = g_asc.asc03
     ORDER BY asd04
   FOREACH t002_asb INTO g_asd.*
      IF cl_null(g_asd.asd04b) AND NOT cl_null(g_asd.asd04a) THEN
         INSERT INTO asb_file (asb01,asb02,asb03,asb04,asb05,
                               asb07,asb06,asb08,asb11,asb12)                           #FUN-B50001 Add asb06
                        VALUES(g_asc.asc01, g_asc.asc02, g_asc.asc03,   
                               g_asd.asd04a, g_asd.asd05a,g_asd.asd07a,g_asd.asd06a,    #FUN-B50001 Add asd06a 
                               g_asd.asd08a,g_asd.asd11a,g_asd.asd12a)
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            CALL cl_err3("ins","asb_file",g_asc.asc01,g_asc.asc02,SQLCA.sqlcode,"","ins asb",1)  #No.FUN-660123
         END IF
      ELSE
         CALL t002_upd_asb(g_asd.*)
      END IF
#No.MOD-B30383-----Mark---BEGIN----
      #asd13b(股本否)='N'確認時,應回寫agli011
      #金額回寫至agli011時,只寫異動額(修改後金額-修改前金額),
      #例如：修改前 10000,修改後 12000,回寫asf05時應寫12000-10000=2000
#     IF g_asd.asd13b='N' THEN
#       INITIALIZE l_asg.* TO NULL
#        LET l_ash06='' LET l_yy=0  LET l_mm=0  LET l_n = 0
#        LET l_yy=YEAR(g_asc.asc06)
#        LET l_mm=MONTH(g_asc.asc06)
 
#        SELECT * INTO l_asg.* FROM asg_file WHERE asg01=g_asd.asd04a
#        SELECT ash06 INTO l_ash06 FROM ash_file
#         WHERE ash01=g_asd.asd04a AND ash00=l_asg.asg05
#           AND ash13=g_asc.asc01
#           AND ash04 = g_asd.asd14b     #FUN-920112 add
#
#        SELECT COUNT(*) INTO l_n FROM asf_file
#         WHERE asf01=g_asc.asc01 AND asf02=g_asd.asd04a
#           AND asf03=l_ash06     AND asf07=g_asd.asd14b
#           AND asf06=g_asc.asc06 #FUN-970048 add
#        IF l_n = 0 THEN            
#           INSERT INTO asf_file(asf01,asf02,asf03,asf04,asf05,
#                                asf06,asf07)  #FUN-970048
#                         VALUES(g_asc.asc01,g_asd.asd04a,l_ash06,
#                                l_asg.asg06,g_asd.asd12b-g_asd.asd12a,  #FUN-910023 mod
#                                g_asc.asc06,g_asd.asd14b)           #FUN-970048
#           IF SQLCA.sqlcode THEN
#              LET g_success='N'
#              CALL cl_err3("ins","asf_file",g_asc.asc01,g_asd.asd04a,SQLCA.sqlcode,"","ins asf",1)
#           END IF
#        ELSE
#           UPDATE asf_file SET asf05=g_asd.asd12b-g_asd.asd12a  #FUN-910023 mod
#            WHERE asf01=g_asc.asc01 AND asf02=g_asd.asd04a
#              AND asf03=l_ash06     AND asf07=g_asd.asd14b
#              AND asf06=g_asc.asc06 #FUN-970048 add
#           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#              LET g_success='N'
#              CALL cl_err3("upd","asf_file",g_asc.asc01,g_asd.asd04a,SQLCA.sqlcode,"","upd asf",1)
#           END IF
#        END IF
#     END IF
#No.MOD-B30383-----Mark---END----

   END FOREACH
   IF g_success = 'Y' THEN
      UPDATE asc_file SET ascconf='Y'
       WHERE asc01 = g_asc.asc01 AND asc02 = g_asc.asc02
         AND asc03 = g_asc.asc03 AND asc06 = g_asc.asc06
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","asc_file",g_asc.asc01,g_asc.asc02,STATUS,"","upd ascconf",1)  #No.FUN-660123
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
   SELECT ascconf INTO g_asc.ascconf FROM asc_file
    WHERE asc01 = g_asc.asc01 AND asc02 = g_asc.asc02
      AND asc03 = g_asc.asc03 AND asc06 = g_asc.asc06
   DISPLAY BY NAME g_asc.ascconf
   CALL cl_set_field_pic(g_asc.ascconf,"","","","","")
END FUNCTION
 
FUNCTION t002_z()
   DEFINE g_asd     RECORD LIKE asd_file.* 
   DEFINE l_asc06   LIKE asc_file.asc06
   DEFINE l_asg     RECORD LIKE asg_file.*   #FUN-910001 add
   DEFINE l_ash06   LIKE ash_file.ash06      #FUN-910001 add
   DEFINE l_yy      LIKE type_file.num5      #FUN-970048 add
   DEFINE l_mm      LIKE type_file.num5      #FUN-970048 add
   DEFINE l_n       LIKE type_file.num5      #FUN-910001 add
 
   IF cl_null(g_asc.asc01)  THEN RETURN END IF
   SELECT * INTO g_asc.* FROM asc_file
    WHERE asc01 = g_asc.asc01 AND asc02 = g_asc.asc02
      AND asc03 = g_asc.asc03 AND asc06 = g_asc.asc06
   IF g_asc.ascconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_asc.ascconf='N' THEN RETURN END IF
 
   #-->異動日期最大的才可取消確認
   SELECT MAX(asc06) INTO l_asc06 FROM asc_file
    WHERE asc01 = g_asc.asc01 AND asc02 = g_asc.asc02
      AND asc03 = g_asc.asc03 AND asc06 > g_asc.asc06
   IF not cl_null(l_asc06) THEN
      CALL cl_err(l_asc06,'agl-222',0) RETURN
   END IF
 
   #IF NOT cl_confirm('atp-109') THEN RETURN END IF      #TQC-C70033   mark
   IF NOT cl_confirm('axr-109') THEN RETURN END IF       #TQC-C70033   add
   LET g_success='Y'
   BEGIN WORK
   OPEN t002_cl USING g_asc.asc06,g_asc.asc01,g_asc.asc02,g_asc.asc03
   FETCH t002_cl INTO g_asc.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_asc.asc01,SQLCA.sqlcode,0)
      CLOSE t002_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   DECLARE t002_rasb CURSOR FOR
    SELECT * FROM asd_file
     WHERE asd00 = g_asc.asc06 AND asd01 = g_asc.asc01
       AND asd02 = g_asc.asc02 AND asd03 = g_asc.asc03
     ORDER BY asd04
 
   FOREACH t002_rasb INTO g_asd.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('t002_rasb',SQLCA.sqlcode,0)   
         LET g_success = 'N' EXIT FOREACH
      END IF
      IF cl_null(g_asd.asd04b) AND NOT cl_null(g_asd.asd04a) THEN
         IF g_asg04 = 'Y' THEN
            DELETE FROM asb_file
             WHERE asb01 = g_asd.asd01 AND asb02 = g_asd.asd02
               AND asb03 = g_asd.asd03 AND asb04 = g_asd.asd04a
               AND asb05 = g_asd.asd05a
         ELSE
            DELETE FROM asb_file
             WHERE asb01 = g_asd.asd01 AND asb02 = g_asd.asd02
               AND asb03 = g_asd.asd03 AND asb04 = g_asd.asd04a
         END IF  #NO.FUN-580072
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_success='N'
            CALL cl_err3("del","asb_file",g_asd.asd01,g_asd.asd02,SQLCA.sqlcode,"","asb",1)   #FUN-740197 modify
            EXIT FOREACH
         END IF
      END IF
      IF NOT cl_null(g_asd.asd04b) AND NOT cl_null(g_asd.asd04a) THEN
         IF g_asg04 = 'Y' THEN
             UPDATE asb_file SET asb07 = g_asd.asd07b,
                                 asb06 = g_asd.asd06b,  #FUN-B50001 Add asd06b
                                 asb08 = g_asd.asd08b,
                                 asb11 = g_asd.asd11b   #NO.FUN-580072
              WHERE asb01 = g_asd.asd01 AND asb02 = g_asd.asd02
                AND asb03 = g_asd.asd03 AND asb04 = g_asd.asd04a
                AND asb05 = g_asd.asd05a
             IF g_asd.asd13b ='Y' THEN                                          
                UPDATE asb_file SET asb12 = g_asd.asd12b                        
                 WHERE asb01 = g_asd.asd01 AND asb02 = g_asd.asd02              
                   AND asb03 = g_asd.asd03 AND asb04 = g_asd.asd04a             
                   AND asb05 = g_asd.asd05a  
#No.MOD-B30383-----Mark---BEGIN----
#               UPDATE asf_file SET asf05=g_asd.asd12b-g_asd.asd12a  
#                WHERE asf01=g_asc.asc01 AND asf02=g_asd.asd04a
#                  AND asf03=l_ash06     AND asf07=g_asd.asd14b
#                  AND asf06=g_asc.asc06
#               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#                  LET g_success='N'
#                  CALL cl_err3("upd","asf_file",g_asc.asc01,g_asd.asd04a,SQLCA.sqlcode,"","upd asf",1)
#               END IF
#No.MOD-B30383-----Mark---END------ 
             END IF                                                        
         ELSE
             UPDATE asb_file SET asb07 = g_asd.asd07b,
                                 asb06 = g_asd.asd06b,   #FUN-B50001 Add asd06b
                                 asb08 = g_asd.asd08b,
                                 asb11 = g_asd.asd11b   #NO.FUN-580072
              WHERE asb01 = g_asd.asd01 AND asb02 = g_asd.asd02
                AND asb03 = g_asd.asd03 AND asb04 = g_asd.asd04a
             IF g_asd.asd13b ='Y' THEN                                          
                UPDATE asb_file SET asb12 = g_asd.asd12b                        
                 WHERE asb01 = g_asd.asd01 AND asb02 = g_asd.asd02              
                   AND asb03 = g_asd.asd03 AND asb04 = g_asd.asd04a             
                   AND asb05 = g_asd.asd05a   
#No.MOD-B30383-----Mark---BEGIN----
#               UPDATE asf_file SET asf05=g_asd.asd12b-g_asd.asd12a  
#                WHERE asf01=g_asc.asc01 AND asf02=g_asd.asd04a
#                  AND asf03=l_ash06     AND asf07=g_asd.asd14b
#                  AND asf06=g_asc.asc06 
#               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#                  LET g_success='N'
#                  CALL cl_err3("upd","asf_file",g_asc.asc01,g_asd.asd04a,SQLCA.sqlcode,"","upd asf",1)
#               END IF
#No.MOD-B30383-----Mark---END------ 
             END IF                                          
         END IF  #NO.FUN-580072
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_success='N'
            CALL cl_err3("upd","asb_file",g_asd.asd01,g_asd.asd02,SQLCA.sqlcode,"","asb",1)   #FUN-740197 modify
            EXIT FOREACH
         END IF
      END IF
#No.MOD-B30383-----Mark---BEGIN----
      #asd13b(股本否)='N'取消確認時,應刪除agli011的資料
#     IF g_asd.asd13b='N' THEN
#        INITIALIZE l_asg.* TO NULL
#        LET l_ash06='' LET l_yy=0  LET l_mm=0  LET l_n = 0
#        LET l_yy=YEAR(g_asc.asc06)
#        LET l_mm=MONTH(g_asc.asc06)
#
#        SELECT * INTO l_asg.* FROM asg_file WHERE asg01=g_asd.asd04a
#        SELECT ash06 INTO l_ash06 FROM ash_file
#         WHERE ash01=g_asd.asd04a AND ash00=l_asg.asg05
#           AND ash13=g_asc.asc01
#
#        SELECT COUNT(*) INTO l_n FROM asf_file
#         WHERE asf01=g_asc.asc01 AND asf02=g_asd.asd04a
#           AND asf03=l_ash06     AND asf07=g_asd.asd14b
#           AND asf06=g_asc.asc06 #FUN-970048 add
#        IF l_n > 0 THEN            
#           DELETE FROM  asf_file
#            WHERE asf01=g_asc.asc01 AND asf02=g_asd.asd04a
#              AND asf03=l_ash06     AND asf07=g_asd.asd14b
#              AND asf06=g_asc.asc06 #FUN-970048 add
#           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#              LET g_success='N'
#              CALL cl_err3("del","asf_file",g_asc.asc01,g_asd.asd04a,SQLCA.sqlcode,"","del asf",1)
#              EXIT FOREACH
#           END IF
#        END IF
#     END IF
#No.MOD-B30383-----Mark---END------
   END FOREACH
   IF g_success = 'Y' THEN
      UPDATE asc_file SET ascconf='N'
       WHERE asc01 = g_asc.asc01 AND asc02 = g_asc.asc02
         AND asc03 = g_asc.asc03 AND asc06 = g_asc.asc06
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","asc_file",g_asc.asc01,g_asc.asc02,STATUS,"","upd ascconf",1)  #No.FUN-660123
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
   SELECT ascconf INTO g_asc.ascconf FROM asc_file
    WHERE asc01 = g_asc.asc01 AND asc02 = g_asc.asc02
      AND asc03 = g_asc.asc03 AND asc06 = g_asc.asc06
   DISPLAY BY NAME g_asc.ascconf
   CALL cl_set_field_pic(g_asc.ascconf,"","","","","")
END FUNCTION
 
FUNCTION t002_upd_asb(p_asd)
   DEFINE p_asd   RECORD LIKE asd_file.*
 
   #有異動持股比率才需做更新
   IF (NOT cl_null(p_asd.asd07a) AND p_asd.asd07a != p_asd.asd07b) THEN
      UPDATE asb_file SET asb07 = p_asd.asd07a
       WHERE asb01 = p_asd.asd01 AND asb02 = p_asd.asd02
         AND asb03 = p_asd.asd03 AND asb04 = p_asd.asd04a
         AND asb05 = p_asd.asd05a
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         LET g_success='N'
         CALL cl_err3("upd","asb_file",p_asd.asd01,p_asd.asd02,SQLCA.sqlcode,"","asb",1)   #FUN-740197 modify
         RETURN
      END IF
   END IF
 
   #有異動異動日期才需做更新
   IF (NOT cl_null(p_asd.asd08a) AND p_asd.asd08a != p_asd.asd08b) THEN
      UPDATE asb_file SET asb08 = p_asd.asd08a
       WHERE asb01 = p_asd.asd01 AND asb02 = p_asd.asd02
         AND asb03 = p_asd.asd03 AND asb04 = p_asd.asd04a
         AND asb05 = p_asd.asd05a
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         LET g_success='N'
         CALL cl_err3("upd","asb_file",p_asd.asd01,p_asd.asd02,SQLCA.sqlcode,"","asb",1)   #FUN-740197 modify
         RETURN
      END IF
   END IF
 
   #有異動投資股數才需做更新
   IF (NOT cl_null(p_asd.asd11a) AND p_asd.asd11a != p_asd.asd11b) THEN
      UPDATE asb_file SET asb11 = p_asd.asd11a
       WHERE asb01 = p_asd.asd01 AND asb02 = p_asd.asd02
         AND asb03 = p_asd.asd03 AND asb04 = p_asd.asd04a
         AND asb05 = p_asd.asd05a
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         LET g_success='N'
         CALL cl_err3("upd","asb_file",p_asd.asd01,p_asd.asd02,SQLCA.sqlcode,"","asb",1)   #FUN-740197 modify
         RETURN
      END IF
   END IF
 
   #有異動股本才需做更新
   IF (NOT cl_null(p_asd.asd12a) AND p_asd.asd12a != p_asd.asd12b) THEN
      UPDATE asb_file SET asb12 = p_asd.asd12a
       WHERE asb01 = p_asd.asd01 AND asb02 = p_asd.asd02
         AND asb03 = p_asd.asd03 AND asb04 = p_asd.asd04a
         AND asb05 = p_asd.asd05a
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         LET g_success='N'
         CALL cl_err3("upd","asb_file",p_asd.asd01,p_asd.asd02,SQLCA.sqlcode,"","asb",1)   #FUN-740197 modify
         RETURN
      END IF
   END IF

#FUN-B50001 start--
   IF (NOT cl_null(p_asd.asd06a) AND p_asd.asd06a != p_asd.asd06b) THEN
      UPDATE asb_file SET asb06 = p_asd.asd06a
       WHERE asb01 = p_asd.asd01 AND asb02 = p_asd.asd02
         AND asb03 = p_asd.asd03 AND asb04 = p_asd.asd04a
         AND asb05 = p_asd.asd05a
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         LET g_success='N'
         CALL cl_err3("upd","asb_file",p_asd.asd01,p_asd.asd02,SQLCA.sqlcode,"","asb",1)   
         RETURN
      END IF
   END IF
#FUN-B50001 end--
 
END FUNCTION
 
FUNCTION t002_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("asc06,asc01,asc02",TRUE)       #FUN-930056 mod     
   END IF
END FUNCTION
 
FUNCTION t002_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("asc06,asc01,asc02",FALSE)       #FUN-930056 mod
   END IF
END FUNCTION
 
FUNCTION t002_set_entry_b()
 
   CALL cl_set_comp_entry("asd07a,asd11a,asd14b,asd12a",TRUE)
 
   IF cl_null(g_asd[l_ac].asd04b) THEN
      CALL cl_set_comp_entry("asd04a",TRUE)
   END IF  
 
END FUNCTION
 
FUNCTION t002_set_no_entry_b()
 
   IF g_asd[l_ac].asd13b = 'Y' THEN
      CALL cl_set_comp_entry("asd14b",FALSE)         #FUN-930056 mod
      LET g_asd[l_ac].asd14b = NULL
      DISPLAY BY NAME g_asd[l_ac].asd14b
   ELSE
      CALL cl_set_comp_entry("asd07a,asd11a",FALSE)
      LET g_asd[l_ac].asd07a = NULL
      LET g_asd[l_ac].asd11a = NULL
      DISPLAY BY NAME g_asd[l_ac].asd07a
      DISPLAY BY NAME g_asd[l_ac].asd11a
   END IF
 
   IF NOT cl_null(g_asd[l_ac].asd04b) THEN
      CALL cl_set_comp_entry("asd04a",FALSE)
   END IF  
  
END FUNCTION
 
 
FUNCTION t002_set_no_required_b()  
      CALL cl_set_comp_required("asd07a,asd11a,asd14b",FALSE) #FUN-930056 mod  #TQC-940005 Add asd07a,asd11a
END FUNCTION 
 
FUNCTION t002_set_required_b()
    IF g_asd[l_ac].asd13b = 'N' THEN
      CALL cl_set_comp_required("asd14b",TRUE)        #FUN-930056 mod
    END IF
    IF g_asd[l_ac].asd13b = 'Y' THEN
      CALL cl_set_comp_required("asd07a,asd11a",TRUE)
    END IF
END FUNCTION
#No.FUN-9C0072 精簡程式碼
#CHI-C80041---begin
FUNCTION t001_v()
DEFINE l_chr LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_asc.asc06) OR cl_null(g_asc.asc01) OR cl_null(g_asc.asc02) OR cl_null(g_asc.asc03) THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t002_cl USING g_asc.asc06,g_asc.asc01,g_asc.asc02,g_asc.asc03
   IF STATUS THEN
      CALL cl_err("OPEN t002_cl:", STATUS, 1)
      CLOSE t002_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t002_cl INTO g_asc.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_asc.asc01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t002_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_asc.ascconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_asc.ascconf)   THEN 
        LET l_chr=g_asc.ascconf
        IF g_asc.ascconf='N' THEN 
            LET g_asc.ascconf='X' 
        ELSE
            LET g_asc.ascconf='N'
        END IF
        UPDATE asc_file
            SET ascconf=g_asc.ascconf,  
                ascmodu=g_user,
                ascdate=g_today
            WHERE asc01=g_asc.asc01
              AND asc02=g_asc.asc02
              AND asc03=g_asc.asc03
              AND asc06=g_asc.asc06
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","asc_file",g_asc.asc01,"",SQLCA.sqlcode,"","",1)  
            LET g_asc.ascconf=l_chr 
        END IF
        DISPLAY BY NAME g_asc.ascconf
   END IF
 
   CLOSE t002_cl
   COMMIT WORK
   CALL cl_flow_notify(g_asc.asc01,'V')
 
END FUNCTION
#CHI-C80041---end
