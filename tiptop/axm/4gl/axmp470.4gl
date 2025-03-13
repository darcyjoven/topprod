# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: axmp470.4gl
# Descriptions...: 客戶驗收作業
# Date & Author..: 06/01/05 By Carrier
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.MOD-6A0089 06/10/18 By Mandy 只要一壓單身馬上當
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-710046 07/01/18 By Carrier 錯誤訊息匯整
# Modify.........: No.CHI-710059 07/02/02 By jamie ogb14應為ogb917*ogb13
# Modify.........: No.FUN-7B0018 08/03/06 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-890068 08/09/05 By chenl  預設ogb17='N'，即不勾選多倉儲.
# Modify.........: No.FUN-8A0086 08/10/21 By lutingting完善錯誤訊息匯總
# Modify.........: No.MOD-8A0196 08/10/24 By Smapmin 修改單頭需簽收出貨單號開窗的qry
# Modify.........: No.MOD-920349 09/02/26 By Smapmin 修改變數定義
# Modify.........: No.FUN-950097 09/06/12 By chenmoyan 增加報表功能
# Modify.........: No.FUN-870007 09/08/13 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980010 09/08/20 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-970068 09/09/10 By mike 報表訂單單號目前是列印oga16，建議調整為印單身的訂單單號ogb31，因可能多張訂單合并出
# Modify.........: No:FUN-9C0071 10/01/08 By huangrh 精簡程式
# Modify.........: No:TQC-A50006 10/05/04 By lilingyu run出畫面後,點擊"退出"按鈕,畫面並未推出,而是進入查詢狀態
# Modify.........: No:TQC-A50044 10/05/14 By Carrier TQC-950086 追单
# Modify.........: No.FUN-A60004 10/08/16 By vealxu 功能單
# Modify.........: NO.FUN-A80134 10/08/25 BY yiting 簽收日應以出貨單上的"預計簽收日"自動帶入
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga57,ogb50欄位預設值修正
# Modify.........: No.MOD-AC0374 10/12/28 By zhangweib 進入客戶簽收單作業(axmp470)無法過濾產生資料
# Modify.........: No:CHI-AC0034 11/01/06 By Summer 產生的簽收單,若是替代的要多新增ogc_file
# Modify.........: No:MOD-B30010 11/03/01 By Summer 列印段的outer語法有錯,導致沒有occ_file的資料就印不出來
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:CHI-B30093 11/04/26 By lilingyu 出貨簽收批號管理
# Modify.........: No:CHI-B60054 11/06/08 By yinhy MARK掉CHI-B30093單號更改內容
# Modify.........: No:MOD-B80078 11/08/08 By johung 判斷行業別執行axmt628
# Modify.........: No:FUN-BB0084 11/12/22 By lixh1 增加數量欄位小數取位
# Modify.........: No:FUN-BB0083 11/12/22 By xujing 增加數量欄位小數取位
# Modify.........: No:FUN-BB0167 12/02/22 By suncx 無訂單出貨也可以客戶簽收
# Modify.........: No:MOD-C30821 12/03/22 By Vampire 原幣含稅未稅金額取位應該用t_azi04   
# Modify.........: No:FUN-C30310 12/04/02 By bart 由出貨簽收多倉儲批時,應依出貨單的批號/bin/date code產生資料
# Modify.........: No:FUN-910115 12/05/10 By Vampire axmt628 新增做廢功能
# Modify.........: No:FUN-C40072 12/05/29 By Sakura 1.多角出貨單(oga09='4')也要可轉簽收單 2.如為多角簽收單需判斷，多角流程資料
# Modify.........: No:TQC-C60031 12/06/04 By bart 寫入簽收單單頭的oga66與oga67時,應抓取出貨單單頭的oga66與oga67才對
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52       
# Modify.........: No:TQC-C70019 12/07/05 By zhuhao 單身筆數賦值
# Modify.........: No:MOD-C70078 12/07/09 By Elise 替代同一顆料,不同倉庫出時,調整將數量sum起來寫入ogc_file
# Modify.........: No:TQC-C70158 12/07/24 By dongsz axmp4701增加“輸入日期”欄位
# Modify.........: No.FUN-C80001 12/08/29 By bart 多角拋轉時，批號需一併拋轉sma96
# Modify.........: No:MOD-C80161 12/09/20 By SunLM  chr1000--->STRING
# Modify.........: No.FUN-CB0087 12/12/20 By xianghui 庫存理由碼改善
# Modify.........: No:MOD-CA0168 13/02/01 By Elise (1) IF tm.a = 'Y' THEN RETURN END IF請增加訊息,已簽收,無法再次拋轉
#                                                  (2) 改判斷不等於作廢
# Modify.........: No:MOD-DA0082 13/10/14 By SunLM 增加項次條件關聯

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
    g_exit          LIKE type_file.chr1,                #No.FUN-680137 VARCHAR(01)
    tm              RECORD
         #wc         LIKE type_file.chr1000,             #No.FUN-680137 VARCHAR(500) ##MOD-C80161 mark
         wc         STRING,                              #MOD-C80161 ADD 
         a          LIKE type_file.chr1                 #No.FUN-680137 VARCHAR(01)
                    END RECORD,
    g_oga           DYNAMIC ARRAY OF RECORD
         sure       like type_file.chr1,
         b          LIKE type_file.chr1,                #No.FUN-680137 VARCHAR(01)
         c          LIKE oga_file.oga01,
         oga03b     LIKE oga_file.oga03,
         oga032b    LIKE oga_file.oga032,
         oga01b     LIKE oga_file.oga01,
         oga02b     LIKE oga_file.oga02,
         oga16      LIKE oga_file.oga16,
         oga011     LIKE oga_file.oga011,
         oga04      LIKE oga_file.oga04,
         occ02      LIKE occ_file.occ02
                    END RECORD,
    g_oga01         LIKE oga_file.oga01,
    l_exit,g_sw     LIKE type_file.chr1,     #No.FUN-680137 VARCHAR(01)  #目前處理的ARRAY CNT
    g_sql           STRING,   #MOD-920349
    l_ac,l_k        LIKE type_file.num5,     #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_sl            LIKE type_file.num5        #目前處理的SCREEN LINE    #No.FUN-680137 SMALLINT
DEFINE t_oga        RECORD LIKE oga_file.*
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   i               LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   l_table         LIKE type_file.chr1000       #No.FUN-950097
DEFINE g_ima918     LIKE ima_file.ima918  #CHI-AC0034 add
DEFINE g_ima921     LIKE ima_file.ima921  #CHI-AC0034 add
 
MAIN
   OPTIONS
      INPUT NO WRAP,
      FIELD ORDER FORM
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
      RETURNING g_time    #No.FUN-6A0094
 
   LET g_sql="oga03.oga_file.oga03,",
             "oga032.oga_file.oga032,",
             "oga01.oga_file.oga01,",
             "oga01b.oga_file.oga01,",
             "oga02.oga_file.oga02,",
             "oga011.oga_file.oga011,",
             "oga04.oga_file.oga04,",
             "occ02.occ_file.occ02,",
             "oga23.oga_file.oga23,",
             "oga24.oga_file.oga24,",
             "ogb03.ogb_file.ogb03,",
             "oga16.oga_file.oga16,",
             "oeb03.oeb_file.oeb03,",
             "oeb04.oeb_file.oeb04,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "oeb12.oeb_file.oeb12,",
             "oeb13.oeb_file.oeb13,",
             "oeb14t.oeb_file.oeb14t,", #CHI-970068 add ,                                                                           
             "ogb31.ogb_file.ogb31"     #CHI-970068   
   LET l_table = cl_prt_temptable('axmp470',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)" #CHI-970068 add ?   
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   OPEN WINDOW p470_w WITH FORM "axm/42f/axmp470"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL p470()
   CALL p470_menu()
 
   CLOSE WINDOW p470_w
   CALL  cl_used(g_prog,g_time,2)   #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
        RETURNING g_time    #No.FUN-6A0094
END MAIN
 
FUNCTION p470()
   DEFINE   l_sql  STRING   #MOD-920349 
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-550067        #No.FUN-680137 SMALLINT
   CLEAR FORM
   CALL g_oga.clear()
   DISPLAY ARRAY g_oga TO s_oga.* 
#      BEFORE ROW                                 #No.MOD-AC0374
       BEFORE DISPLAY                             #No.MOD-AC0374
          EXIT DISPLAY
   END DISPLAY
   CALL cl_set_head_visible("grid01","YES")       #No.FUN-6A0092

#TQC-A50006 --begin--
  IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p470_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
#TQC-A50006 --end--
 
  #CONSTRUCT BY NAME tm.wc ON oga02,oga01,oga03,oga032                      #FUN-A60004
   CONSTRUCT BY NAME tm.wc ON oga02,oga03,oga72,oga01,oga032                #FUN-A60004
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oga01) #查詢單据
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oga14"   #MOD-8A0196 q_oga7-->q_oga14
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = '2'   #MOD-8A0196 7-->2
                 LET g_qryparam.arg2 = '4'   #FUN-C40072 add
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oga01
                 NEXT FIELD oga01
            WHEN INFIELD(oga03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_occ"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oga03
                 NEXT FIELD oga03
         END CASE
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p470_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   LET tm.a    ='N'
   DISPLAY BY NAME tm.a
 
   INPUT BY NAME tm.a WITHOUT DEFAULTS
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p470_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   CALL p470_b_fill()
 
END FUNCTION
 
FUNCTION p470_b_fill()                 #單身填充
  DEFINE l_sql      STRING,   #MOD-920349 
         l_cnt      LIKE type_file.num5,          #No.FUN-680137 SMALLINT
         l_oga01    LIKE oga_file.oga01,
         l_oga09    LIKE oga_file.oga09           #FUN-C40072 add

#FUN-C40072---add---START
    LET l_sql = " SELECT oga09 FROM oga_file ",
                "  WHERE oga09 IN ('2','4') ",
                "   AND ",tm.wc
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    PREPARE oga09_pre1 FROM l_sql
    DECLARE oga09_cs1 CURSOR FOR oga09_pre1
    OPEN oga09_cs1
    IF STATUS THEN
       CALL cl_err('open oga09',STATUS,1)
    END IF
    FETCH oga09_cs1 INTO l_oga09
    IF STATUS THEN
    CALL cl_err('fetch oga09',STATUS,1)
    END IF

    IF l_oga09 = '4' THEN
       LET l_sql = " SELECT 'N','','',oga03,oga032,oga01,oga02,oga16,oga011,",   #darcy:2023/05/04 add 'N'
                   "        oga04,occ02 ",
                   "   FROM oga_file,OUTER occ_file,oea_file,poz_file",
                   "  WHERE oga04 = occ_file.occ01",
                   "    AND oga16 = oea_file.oea01",
                   "    AND oea904 = poz_file.poz01",
                   "    AND ogaconf='Y' AND ogapost='Y'",
                   "    AND oga65='Y' ",
                   "    AND oga09 IN ('4') ",
                   "    AND poz00='1' and poz011='2' and poz19='N'",
                   "    AND ",tm.wc CLIPPED,
                   " ORDER BY oga03,oga01 "
    ELSE
#FUN-C40072---add-----END
       LET l_sql = " SELECT 'N','','',oga03,oga032,oga01,oga02,oga16,oga011,",   #darcy:2023/05/04 add 'N'
                   "        oga04,occ02 ",
                  #MOD-B30010 mod --start--
                  #"   FROM oga_file,OUTER occ_file",
                  #"  WHERE oga_file.oga04 = occ_file.occ01", 
                  #"    AND ogaconf='Y' AND ogapost='Y'", 
                   "   FROM oga_file LEFT OUTER JOIN occ_file ON occ01=oga04",
                   "  WHERE ogaconf='Y' AND ogapost='Y'", 
                  #MOD-B30010 mod --end--
                   "    AND oga65='Y' ",
                  #"    AND oga09='2' ",   #FUN-BB0167 mark
                   "    AND oga09 IN ('2','3') ",    #FUN-BB0167       
                   "    AND ",tm.wc CLIPPED,
                   " ORDER BY oga03,oga01 "
    END IF #FUN-C40072 add
    PREPARE p470_prepare FROM l_sql
    MESSAGE " SEARCHING! "
    CALL ui.Interface.refresh()
    CALL g_oga.clear()
    DECLARE p470_cur CURSOR FOR p470_prepare
    LET g_cnt = 1
    FOREACH p470_cur INTO g_oga[g_cnt].*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT COUNT(*) INTO l_cnt FROM ogb_file 
        WHERE ogb01=g_oga[g_cnt].oga01b AND ogb12 <>0
       IF l_cnt = 0 THEN CONTINUE FOREACH END IF
       
       SELECT COUNT(*) INTO l_cnt FROM ogb_file,oga_file
        WHERE oga01=ogb01 AND oga01=g_oga[g_cnt].oga01b
          AND ogb03 NOT IN (SELECT ogb03 FROM ogb_file,oga_file
                             WHERE oga01=ogb01 AND oga011=g_oga[g_cnt].oga01b
                               AND oga09 ='8')
 
       #出貨單與驗收單是一對一的，不可能對多張
       LET l_oga01 = NULL
       DECLARE p470_s_oga01_cur SCROLL CURSOR FOR
        SELECT oga01 FROM oga_file
         WHERE oga011 = g_oga[g_cnt].oga01b
           AND oga09 = '8' AND ogaconf <> 'X' #FUN-910115 add
           #AND oga09 = '8'                   #FUN-910115 mark
         ORDER BY oga01
       OPEN p470_s_oga01_cur
       FETCH FIRST p470_s_oga01_cur INTO l_oga01
       CLOSE p470_s_oga01_cur
       IF tm.a = 'Y' THEN
          IF cl_null(l_oga01) THEN CONTINUE FOREACH END IF
          LET g_oga[g_cnt].b = 'Y'
          LET g_oga[g_cnt].c = l_oga01
       ELSE
          IF NOT cl_null(l_oga01) THEN 
             IF l_cnt = 0 THEN
                CONTINUE FOREACH
             ELSE
                LET g_oga[g_cnt].b = 'Y'
                LET g_oga[g_cnt].c = l_oga01
             END IF
          ELSE
             LET g_oga[g_cnt].b = 'N'
             LET g_oga[g_cnt].c = NULL
          END IF
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_oga.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cnt    #TQC-C70019
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p470_bp(p_ud)               #show資料
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
    define l_i             integer     #darcy:2023/05/04 add
 
    IF p_ud <> "G" THEN                               #MOD-6A0089 mod
        RETURN
    END IF
 
    CALL SET_COUNT(g_rec_b)   #告訴I.單身筆數
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
   #  DISPLAY ARRAY g_oga TO s_oga.* ATTRIBUTE(COUNT=g_rec_b) #darcy:2023/05/04 mark
   #darcy:2023/05/04 mark s---
    input array g_oga without defaults from s_oga.*
        attribute(count=g_rec_b,maxcount=g_max_rec,unbuffered,
        insert row=false,delete row=false,append row=false)
   #darcy:2023/05/04 mark e---

       BEFORE ROW
          LET l_ac = ARR_CURR()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          call cl_set_comp_entry('sure',g_oga[l_ac].b='N')
 
       ON ACTION cancel
          LET INT_FLAG=FALSE 		#MOD-570244	mars
          LET g_action_choice="exit"
          EXIT input #DISPLAY     #darcy:2023/05/04 mod display => input
 
       ON ACTION exit
          LET g_action_choice="exit"
          EXIT input #DISPLAY    #darcy:2023/05/04 mod display => input
 
       ON ACTION query
          LET g_action_choice="query"
          EXIT input #DISPLAY    #darcy:2023/05/04 mod display => input
       
       ON ACTION output
          LET g_action_choice="output"
          EXIT input #DISPLAY     #darcy:2023/05/04 mod display => input
 
       ON ACTION gen_on_check_note
          LET g_action_choice="gen_on_check_note"
          EXIT input #DISPLAY    #darcy:2023/05/04 mod display => input
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE input #DISPLAY #darcy:2023/05/04 mod display => input
 
       ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("grid01","AUTO")           #No.FUN-6A0092
      
       #darcy:2023/05/04 add s---
       before field sure
        call cl_set_comp_entry('sure',g_oga[l_ac].b='N')
       on change sure
         message ''
       on action checkall
         for l_i =1 to g_oga.getlength()
            let g_oga[l_i].sure = 'Y'
         end for
       on action inverse
         for l_i =1 to g_oga.getlength()
            let g_oga[l_i].sure = iif(g_oga[l_i].sure='N','Y','N')
         end for
       #darcy:2023/05/04 add e---
 
      AFTER input #DISPLAY #darcy:2023/05/04 mod display => input
         CONTINUE input #DISPLAY  #darcy:2023/05/04 mod display => input
 
 
    END input #DISPLAY  #darcy:2023/05/04 mod display => input
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

# 出货签收
FUNCTION p470_gen()
  DEFINE l_oga01    LIKE oga_file.oga01
  define l_i,l_j,l_cnt        integer  #darcy:2023/05/05 add
  define l_str          string
  DEFINE  l_oga69      LIKE oga_file.oga69
 
     IF g_rec_b < 1 THEN RETURN END IF
    #IF tm.a = 'Y' THEN RETURN END IF #MOD-CA0168 mark
     IF tm.a = 'Y' THEN CALL cl_err("","axm1170",0) RETURN END IF  #MOD-CA0168 add
    #  IF g_oga[l_ac].oga01b IS NULL THEN RETURN END IF #darcy:2023/05/05 mark
    #darcy:2023/05/05 add s---
    call p470_get_oga() returning l_oga01,l_oga69

    begin work
    let g_success = 'Y'
    let l_j = l_ac
    let l_str = ' oga01 in ("x"'
    for l_i = 1 to g_oga.getlength()
        if g_oga[l_i].sure != 'Y' then
            continue for
        end if
        let l_cnt = 0
        select count(*) into l_cnt from ogb_file,oga_file
         where oga01=ogb01 and oga01=g_oga[l_i].oga01b
           and ogb03 not in (select ogb03 from ogb_file,oga_file
                            where oga01=ogb01 and oga011=g_oga[l_i].oga01b
                            and oga09 ='8' and ogaconf <> 'X')
        if l_cnt = 0 then
            continue for
        end if
        let l_ac = l_i
        call p470_ins_t628(l_oga01,l_oga69)
        if g_success = 'N' then
            rollback work
            exit for
        end if
        if not cl_null(g_oga01) then
            let l_str = l_str,',"',g_oga01,'"'
        end if
        let g_oga[l_i].sure = 'N'
        let g_oga[l_i].b = 'Y'
        let g_oga[l_i].c = g_oga01
    end for
    let l_ac = l_j
    let l_str = l_str,")"
    call s_showmsg()
    if g_success = 'Y' then
        commit work
        for l_i = 1 to g_oga.getlength()
            if g_oga[l_i].sure != 'Y' then
                continue for
            end if
            if g_success = 'Y' then
                display by name g_oga[l_i].*
            else
                let g_oga[l_i].sure = 'Y'
                let g_oga[l_i].b='N'
                let g_oga[l_i].c = ''
            end if
        end for
    else
        rollback work
    end if
    call p470_open_axmt628(l_str)

    #darcy:2023/05/05 add e--- 
 
END FUNCTION
 
FUNCTION p470_ins_t628(l_oga01,l_oga69)
   DEFINE l_oga01      LIKE oga_file.oga01
   DEFINE l_oga69      LIKE oga_file.oga69          #TQC-C70158 add
   DEFINE l_oayslip    LIKE oay_file.oayslip
   DEFINE l_cnt        LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE li_result    LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE l_idb        RECORD LIKE idb_file.*       #FUN-C30310 add

#    call p470_get_oga() returning l_oga01,l_oga69
 
   CALL p470_ins_oga(l_oga01,l_oga69)          #TQC-C70158 add l_oga69
   IF g_success = 'N' THEN RETURN END IF
 
   CALL p470_ins_ogb()
   IF g_success = 'N' THEN RETURN END IF
   #FUN-C30310---begin
   IF s_industry('icd') THEN
      DROP TABLE b
      SELECT * FROM idb_file WHERE 1 != 1 INTO TEMP b
      INSERT INTO b (idb01,idb02,idb03,idb04,idb05,idb06,idb07,idb08,idb09,idb10,
                     idb11,idb12,idb13,idb14,idb15,idb16,idb17,idb18,idb19,idb20,
                     idb21,idb25,idbplant,idblegal)
      SELECT idd01,idd02,idd03,idd04,idd05,idd06,idd10,idd11,idd08,idd29,
             idd13,idd07,idd15,idd16,idd17,idd18,idd19,idd20,idd21,idd22,
             idd23,idd25,iddplant,iddlegal
        FROM idd_file WHERE idd10 = t_oga.oga01 AND idd12=1
      UPDATE b SET idb16=0 WHERE idb16 IS NULL
      UPDATE b SET idb07=g_oga01
      INSERT INTO idb_file SELECT * FROM b

      DECLARE p470_idb_cs CURSOR FOR
         SELECT * FROM idb_file WHERE idb07=g_oga01
      FOREACH p470_idb_cs INTO l_idb.*
         UPDATE idc_file SET idc21 = idc21 + l_idb.idb11
          WHERE idc01 = l_idb.idb01 AND idc02 = l_idb.idb02
            AND idc03 = l_idb.idb03 AND idc04 = l_idb.idb04
            AND idc05 = l_idb.idb05 AND idc06 = l_idb.idb06
      END FOREACH

      #ICD行業別時,多倉儲批資料應將出貨單的資料帶過來,只是把倉庫跟儲位換成簽收在途倉庫跟無儲位
      DROP TABLE c
      INSERT INTO c SELECT * FROM ogc_file WHERE ogc01 = t_oga.oga01
      UPDATE c SET ogc01=g_oga01,ogc09=t_oga.oga66,ogc091=t_oga.oga67
      INSERT INTO ogc_file SELECT * FROM c
   END IF
   #FUN-C30310---end
END FUNCTION
 
FUNCTION p470_ins_oga(p_slip,p_date)                #TQC-C70158 add p_date
   DEFINE p_slip       LIKE oay_file.oayslip
   DEFINE l_oga        RECORD LIKE oga_file.*
   DEFINE li_result    LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE p_date       LIKE oga_file.oga69          #TQC-C70158 add
 
   CALL s_auto_assign_no("axm",p_slip,g_oga[l_ac].oga02b,"","oga_file","oga01","","","")
        RETURNING li_result,g_oga01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   SELECT * INTO t_oga.* FROM oga_file WHERE oga01 = g_oga[l_ac].oga01b
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","oga_file",g_oga[l_ac].oga01b,"",SQLCA.sqlcode,"","sel oga01b",1)   #No.FUN-660167
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_oga.* = t_oga.*
   LET l_oga.oga01  = g_oga01
   #--FUN-A80134 start--
   IF NOT cl_null(t_oga.oga72) THEN
       LET l_oga.oga02 = t_oga.oga72
   END IF
   #---FUN-A80134 end---     
   LET l_oga.oga011 = t_oga.oga01
   LET l_oga.oga09  = '8'
   LET l_oga.oga65  = 'N'
   #LET l_oga.oga66  = g_oaz.oaz74  #TQC-C60031
   #LET l_oga.oga67  = g_oaz.oaz75  #TQC-C60031
   LET l_oga.oga66  = t_oga.oga66   #TQC-C60031
   LET l_oga.oga67  = t_oga.oga67   #TQC-C60031
   LET l_oga.oga69  = p_date        #TQC-C70158 add
   LET l_oga.ogaconf= 'N'                #確認否/作廢碼
   LET l_oga.ogapost= 'N'                #出貨扣帳否
   LET l_oga.ogaprsw= 0                  #列印次數
   LET l_oga.ogauser= g_user             #資料所有者
   LET l_oga.ogagrup= g_grup             #資料所有部門
   LET l_oga.ogadate= g_today            #最近修改日
   LET l_oga.oga55  = '0'
   LET l_oga.oga57  = '1'          #FUN-AC0055 add
   SELECT oayapr INTO l_oga.ogamksg FROM oay_file WHERE oayslip = p_slip
   LET l_oga.oga85=' '  #No.FUN-870007
   LET l_oga.oga94='N'  #No.FUN-870007
 
   LET l_oga.ogaplant = g_plant 
   LET l_oga.ogalegal = g_legal 
 
   LET l_oga.ogaoriu = g_user      #No.FUN-980030 10/01/04
   LET l_oga.ogaorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO oga_file VALUES(l_oga.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("ins","oay_file",p_slip,"",SQLCA.sqlcode,"","ins_oga()",1)   #No.FUN-660167
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION

FUNCTION p470_ins_ogb()
  DEFINE l_ogb      RECORD LIKE ogb_file.*
  DEFINE t_ogb      RECORD LIKE ogb_file.*
  DEFINE l_oga66    LIKE oga_file.oga66
  DEFINE l_oga67    LIKE oga_file.oga67
  DEFINE l_ogb12a   LIKE ogb_file.ogb912,
         l_ogb12b   LIKE ogb_file.ogb912
  DEFINE l_ogb912a  LIKE ogb_file.ogb912,
         l_ogb912b  LIKE ogb_file.ogb912,
         l_ogb915a  LIKE ogb_file.ogb915,
         l_ogb915b  LIKE ogb_file.ogb915,
         l_ogb917a  LIKE ogb_file.ogb917,
         l_ogb917b  LIKE ogb_file.ogb917
  DEFINE l_ogbi     RECORD LIKE ogbi_file.*    #No.FUN-7B0018
  DEFINE l_ogc      RECORD LIKE ogc_file.*     #CHI-AC0034 add
  DEFINE l_ogc12a   LIKE ogc_file.ogc12        #CHI-AC0034 add
  DEFINE l_ogc12b   LIKE ogc_file.ogc12        #CHI-AC0034 add
  DEFINE l_rvbs     RECORD LIKE rvbs_file.*    #CHI-AC0034 add
  DEFINE l_rvbs06a  LIKE rvbs_file.rvbs06      #CHI-AC0034 add
  DEFINE l_rvbs06b  LIKE rvbs_file.rvbs06      #CHI-AC0034 add
  DEFINE l_oga23    LIKE oga_file.oga23        #MOD-C30821 add
  DEFINE l_ogg      RECORD LIKE ogg_file.*     #FUN-C80001
  DEFINE l_fac   LIKE ima_file.ima31_fac       #FUN-C80001
  DEFINE l_img09 LIKE img_file.img09           #FUN-C80001
  DEFINE l_flag  LIKE type_file.num5           #FUN-C80001
  DEFINE l_oga14 LIKE oga_file.oga14  #FUN-CB0087
  DEFINE l_oga15 LIKE oga_file.oga15  #FUN-CB0087
#CHI-B60054  --Begin #MARK掉CHI-B30093更改
#CHI-B30093 --begin--  
#  DEFINE l_sql      STRING                    
#  DEFINE l_ogc_1    RECORD LIKE ogc_file.*     
#  DEFINE l_ogb03_t   LIKE ogb_file.ogb03         
#  DEFINE l_ogb03_cur LIKE ogb_file.ogb03          
#  DEFINE l_cnt       LIKE type_file.num5           
#  
#    LET l_cnt = 0 
#  
#    LET l_sql = "SELECT * FROM ogc_file WHERE ogc01 ='",g_oga[l_ac].oga01b,"'"  #,
##                "   AND ogc03 = ?"  
#    PREPARE p470_ogc092 FROM l_sql
#    DECLARE p470_ogc092_cs CURSOR FOR p470_ogc092 
#CHI-B30093 --end--  
#CHI-B60054  --End #MARK掉CHI-B30093更改

    DECLARE p470_ogb_cur CURSOR FOR
     SELECT * FROM ogb_file WHERE ogb01 = g_oga[l_ac].oga01b
    
    CALL s_showmsg_init()   #No.FUN-710046
    FOREACH p470_ogb_cur INTO t_ogb.*
       IF SQLCA.sqlcode != 0 THEN
          CALL s_errmsg("ogb01",g_oga[l_ac].oga01b,"ogb_cur:",SQLCA.sqlcode,0)
          LET g_success= 'N'                  #No.FUN-8A0086
          EXIT FOREACH
       END IF
       IF g_success = "N" THEN
          LET g_totsuccess = "N"
          LET g_success = "Y"
       END IF
       LET l_ogb.* = t_ogb.*
       LET l_ogb.ogb01 =  g_oga01
       LET l_ogb12a = 0  LET l_ogb912a = 0  LET l_ogb915a = 0  LET l_ogb917a = 0
      #IF t_oga.oga09 = '2' THEN   #FUN-BB0167 #FUN-C40072 mark
       IF t_oga.oga09 MATCHES '[24]' THEN      #FUN-C40072 add 2:一般出貨單4:三角貿易出貨單
          SELECT SUM(ogb12),SUM(ogb912),SUM(ogb915),SUM(ogb917)
            INTO l_ogb12a,l_ogb912a,l_ogb915a,l_ogb917a
            FROM ogb_file,oga_file
          #WHERE ogb01 = oga01 AND oga09 = '2' AND oga65='Y'                  #FUN-C40072 mark
           WHERE ogb01 = oga01 AND (oga09 = '2' OR oga09 = '4') AND oga65='Y' #FUN-C40072 add 4
             AND oga01 = g_oga[l_ac].oga01b
             AND ogb03 = l_ogb.ogb03 #MOD-4B0107
             AND ogb31 = l_ogb.ogb31
             AND ogb32 = l_ogb.ogb32
             AND ogb04 = l_ogb.ogb04 #BugNo:4541
             AND ogaconf = 'Y'
             AND ogapost = 'Y'
       #FUN-BB0167 START---------------
       ELSE
          SELECT SUM(ogb12),SUM(ogb912),SUM(ogb915),SUM(ogb917)
            INTO l_ogb12a,l_ogb912a,l_ogb915a,l_ogb917a
            FROM ogb_file,oga_file
           WHERE ogb01 = oga01 AND oga09 = '3' AND oga65='Y'
             AND oga01 = g_oga[l_ac].oga01b
             AND ogb03 = l_ogb.ogb03 #MOD-4B0107
             AND ogb04 = l_ogb.ogb04 #BugNo:4541
             AND ogaconf = 'Y'
             AND ogapost = 'Y'
       END IF
       #FUN-BB0167 END------------------
 
       IF cl_null(l_ogb12a)  THEN LET l_ogb12a = 0 END IF
       IF cl_null(l_ogb912a) THEN LET l_ogb912a= 0 END IF
       IF cl_null(l_ogb915a) THEN LET l_ogb915a= 0 END IF
       IF cl_null(l_ogb917a) THEN LET l_ogb917a= 0 END IF
       # 此出貨通知單已耗用在出貨單的量
       LET l_ogb12b = 0
      #IF t_oga.oga09 = '2' THEN   #FUN-BB0167          #FUN-C40072 mark
       IF t_oga.oga09 MATCHES '[24]' THEN   #FUN-BB0167 #FUN-C40072 add
          SELECT SUM(ogb12),SUM(ogb912),SUM(ogb915),SUM(ogb917)
            INTO l_ogb12b,l_ogb912b,l_ogb915b,l_ogb917b
            FROM ogb_file,oga_file
           WHERE ogb01 = oga01 AND oga09 IN ('8','9')  #No.7992  #No.FUN-610057
             AND oga011= g_oga[l_ac].oga01b
             AND ogb03 = l_ogb.ogb03 #MOD-4B0107
             AND ogb31 = l_ogb.ogb31
             AND ogb32 = l_ogb.ogb32
             AND ogb04 = l_ogb.ogb04 #BugNo:4541
             AND ogaconf != 'X'   #No.MOD-570312
       #FUN-BB0167 START---------------
       ELSE
          SELECT SUM(ogb12),SUM(ogb912),SUM(ogb915),SUM(ogb917)
            INTO l_ogb12b,l_ogb912b,l_ogb915b,l_ogb917b
            FROM ogb_file,oga_file
           WHERE ogb01 = oga01 AND oga09 IN ('8','9')  #No.7992  #No.FUN-610057
             AND oga011= g_oga[l_ac].oga01b
             AND ogb03 = l_ogb.ogb03 #MOD-4B0107
             AND ogb04 = l_ogb.ogb04 #BugNo:4541
             AND ogaconf != 'X'   #No.MOD-570312
       END IF
       #FUN-BB0167 END------------------
       IF cl_null(l_ogb12b)  THEN LET l_ogb12b = 0 END IF
       IF cl_null(l_ogb912b) THEN LET l_ogb912b= 0 END IF
       IF cl_null(l_ogb915b) THEN LET l_ogb915b= 0 END IF
       IF cl_null(l_ogb917b) THEN LET l_ogb917b= 0 END IF
       LET l_ogb.ogb12 = l_ogb12a - l_ogb12b
       LET l_ogb.ogb912= l_ogb912a- l_ogb912b
       LET l_ogb.ogb915= l_ogb915a- l_ogb915b
       LET l_ogb.ogb917= l_ogb917a- l_ogb917b
       LET l_ogb.ogb16 = l_ogb.ogb12 * l_ogb.ogb15_fac
       LET l_ogb.ogb16 = s_digqty(l_ogb.ogb16,l_ogb.ogb15) #FUN-BB0083 add
       IF l_ogb.ogb12 = 0 THEN CONTINUE FOREACH END IF
       IF t_oga.oga213 = 'N' THEN
           LET l_ogb.ogb14 =l_ogb.ogb917*l_ogb.ogb13   #CHI-710059 mod
           LET l_ogb.ogb14t=l_ogb.ogb14*(1+t_oga.oga211/100)
       ELSE
           LET l_ogb.ogb14t=l_ogb.ogb917*l_ogb.ogb13   #CHI-710059 mod 
           LET l_ogb.ogb14 =l_ogb.ogb14t/(1+t_oga.oga211/100)
       END IF
       #MOD-C30821 ----- mark start -----
       #CALL cl_digcut(l_ogb.ogb14,g_azi04) RETURNING l_ogb.ogb14
       #CALL cl_digcut(l_ogb.ogb14t,g_azi04)RETURNING l_ogb.ogb14t
       #MOD-C30821 ----- mark end -----
       #SELECT oga66,oga67 INTO l_oga66,l_oga67 FROM oga_file              #MOD-C30821 mark
       SELECT oga66,oga67,oga23 INTO l_oga66,l_oga67,l_oga23 FROM oga_file #MOD-C30821 add
        WHERE oga01 = g_oga[l_ac].oga01b
       #MOD-C30821 ----- add start -----
       SELECT azi04 INTO t_azi04
         FROM azi_file
        WHERE azi01 = l_oga23
       IF cl_null(t_azi04) THEN LET t_azi04=0 END IF
       CALL cl_digcut(l_ogb.ogb14,t_azi04) RETURNING l_ogb.ogb14
       CALL cl_digcut(l_ogb.ogb14t,t_azi04)RETURNING l_ogb.ogb14t
       #MOD-C30821 ----- add add -----
       LET l_ogb.ogb09 = l_oga66
       LET l_ogb.ogb091= l_oga67
       LET l_ogb.ogb65  = NULL
       IF g_aaz.aaz90='Y' THEN
          SELECT ogb930 INTO l_ogb.ogb930 FROM ogb_file
                                       # WHERE oga01 = g_oga[l_ac].oga01b  #No.TQC-A50044
                                         WHERE ogb01 = g_oga[l_ac].oga01b  #No.TQC-A50044
                                           AND ogb03 = l_ogb.ogb03
          IF SQLCA.sqlcode THEN
             LET l_ogb.ogb930 = NULL
          END IF
       END IF
       LET l_ogb.ogb1014   = 'N'                 #保稅放行否  #FUN-6B0044
      #LET l_ogb.ogb17     ='N'    #No.MOD-890068  #CHI-AC0034 mark
       LET l_ogb.ogb44='1' #No.FUN-870007
       LET l_ogb.ogb47=0   #No.FUN-870007
#FUN-AB0061 -----------add start----------------                             
       IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37=0 THEN           
          LET l_ogb.ogb37=l_ogb.ogb13                         
       END IF                                                                             
#FUN-AB0061 -----------add end----------------   
       LET l_ogb.ogbplant = g_plant 
       LET l_ogb.ogblegal = g_legal 
 
#FUN-AC0055 mark ---------------------begin-----------------------
##FUN-AB0096 -----------add start-------------
#       IF cl_null(l_ogb.ogb50) THEN
#          LET l_ogb.ogb50 = '1'
#       END IF 
##FUN-AB0096 ----------add end--------------  
#FUN-AC0055 mark ----------------------end------------------------
        #FUN-C50097 ADD BEGIN-----
      IF cl_null(l_ogb.ogb50) THEN 
        LET l_ogb.ogb50 = 0
      END IF 
      IF cl_null(l_ogb.ogb51) THEN 
        LET l_ogb.ogb51 = 0
      END IF 
      IF cl_null(l_ogb.ogb52) THEN 
        LET l_ogb.ogb52 = 0
      END IF     
      IF cl_null(l_ogb.ogb53) THEN 
        LET l_ogb.ogb53 = 0
      END IF 
      IF cl_null(l_ogb.ogb54) THEN 
        LET l_ogb.ogb54 = 0
      END IF 
      IF cl_null(l_ogb.ogb55) THEN 
        LET l_ogb.ogb55 = 0
      END IF                                         
        #FUN-C50097 ADD END-------      
    #FUN-CB0087--add--str--
    IF g_aza.aza115 = 'Y' THEN
       SELECT oga14,oga15 INTO l_oga14,l_oga15 FROM oga_file WHERE oga01 = l_ogb.ogb01
       CALL s_reason_code(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15) RETURNING l_ogb.ogb65
       IF cl_null(l_ogb.ogb65) THEN
          CALL cl_err(l_ogb.ogb65,'aim-425',1)
          LET g_success="N"
          RETURN
       END IF
    END IF
    #FUN-CB0087--add--end--             
    INSERT INTO ogb_file VALUES(l_ogb.*)
#CHI-B60054  --Begin #MARK掉CHI-B30093更改
#CHI-B30093 --begin--        
#   IF l_ogb.ogb17 = 'Y' THEN           
#        FOREACH p470_ogc092_cs INTO l_ogc_1.*                       
#          LET l_ogc_1.ogc01 = l_ogb.ogb01
#          LET l_ogc_1.ogc09 = l_ogb.ogb09         
#          LET l_ogc_1.ogc091= l_ogb.ogb091            
#          INSERT INTO ogc_file VALUES(l_ogc_1.*)                   
#          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN     
#             LET g_showmsg=l_ogc_1.ogc01,"/",l_ogc_1.ogc092             
#             CALL s_errmsg("ogc01,ogc092",g_showmsg,"ins_ogc():",SQLCA.sqlcode,1)             
#             LET g_success = 'N'     
#             EXIT FOREACH 
#          END IF 
#       END FOREACH 
#   END IF     
#CHI-B30093 --end--
#CHI-B60054  --End #MARK掉CHI-B30093更改
       
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN         #CHI-B30093    #CHI-B60054 #MARK掉CHI-B30093更改
#       IF STATUS THEN                                        #CHI-B30093  #CHI-B60054 #MARK掉CHI-B30093更改  
          LET g_showmsg=l_ogb.ogb01,"/",l_ogb.ogb03
          CALL s_errmsg("ogb01,ogb03",g_showmsg,"ins_ogb():",SQLCA.sqlcode,1)
          LET g_success = 'N'
          CONTINUE FOREACH
       ELSE
          IF NOT s_industry('std') THEN
             INITIALIZE l_ogbi.* TO NULL
             LET l_ogbi.ogbi01 = l_ogb.ogb01
             LET l_ogbi.ogbi03 = l_ogb.ogb03
             IF NOT s_ins_ogbi(l_ogbi.*,'') THEN
                LET g_success = 'N'
                CONTINUE FOREACH
             END IF
          END IF
       END IF
       #CHI-AC0034 add --start--
       LET g_ima918 = '' 
       LET g_ima921 = '' 
       SELECT ima918,ima921 INTO g_ima918,g_ima921 
         FROM ima_file
        WHERE ima01 = l_ogb.ogb04
          AND imaacti = "Y"
       
       IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
          DECLARE p470_g_rvbs_1 CURSOR FOR SELECT * FROM rvbs_file
                                         WHERE rvbs01 = g_oga[l_ac].oga01b
                                           AND rvbs02 = l_ogb.ogb03
          LET i = 1  
          FOREACH p470_g_rvbs_1 INTO l_rvbs.*
             IF STATUS THEN
                CALL cl_err('rvbs',STATUS,1)
             END IF
       
             LET l_rvbs.rvbs00 = 'axmt628' 
             LET l_rvbs.rvbs01 = g_oga01
             LET l_rvbs.rvbs022 = i  
             LEt l_rvbs.rvbs13 = 0  

             #檢查銷退數必須 =出貨單上的數量-簽收單上的數量
             LET l_rvbs06a = 0
             SELECT SUM(rvbs06) INTO l_rvbs06a
               FROM rvbs_file
              WHERE rvbs01=g_oga[l_ac].oga01b 
                AND rvbs02= l_ogb.ogb03
                AND rvbs13 = l_rvbs.rvbs13   
                AND rvbs09 = -1  
                AND rvbs03=l_rvbs.rvbs03
                AND rvbs04=l_rvbs.rvbs04
             IF cl_null(l_rvbs06a) THEN
                LET l_rvbs06a = 0
             END IF

             #已簽收數量
             LET l_rvbs06b = 0
             SELECT SUM(rvbs06) INTO l_rvbs06b
               FROM ogb_file,oga_file,rvbs_file
              WHERE ogb01 = oga01 AND oga09 IN ('8') 
                AND oga01 = g_oga[l_ac].oga01b
                AND ogb03 = l_ogb.ogb03
                AND oga01 = rvbs01
                AND ogb03 = rvbs02
                AND rvbs13 = l_rvbs.rvbs13  
                AND rvbs09 = -1
                AND ogaconf != 'X' 
                AND rvbs03=l_rvbs.rvbs03
                AND rvbs04=l_rvbs.rvbs04
             IF cl_null(l_rvbs06b) THEN
                LET l_rvbs06b = 0
             END IF

             LET l_rvbs.rvbs06 = l_rvbs06a - l_rvbs06b
       
             INSERT INTO rvbs_file VALUES(l_rvbs.*)
             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)  
             END IF
             LET i = i + 1 
          END FOREACH
       END IF

       #IF l_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨 #FUN-C80001
       IF l_ogb.ogb17='Y' THEN  #FUN-C80001
          DECLARE p470_ogc_cur CURSOR FOR
          #SELECT * FROM ogc_file             #MOD-C70078 mark
           SELECT ogc17,ogc092 FROM ogc_file  #MOD-C70078
            WHERE ogc01= g_oga[l_ac].oga01b
              AND ogc03= l_ogb.ogb03
            GROUP BY ogc17,ogc092             #MOD-C70078
         #FOREACH p470_ogc_cur INTO l_ogc.*                   #MOD-C70078 mark
          FOREACH p470_ogc_cur INTO l_ogc.ogc17,l_ogc.ogc092  #MOD-C70078
             IF SQLCA.sqlcode != 0 THEN
                CALL s_errmsg("ogc01",g_oga[l_ac].oga01b,"ogc_cur:",SQLCA.sqlcode,0)
                LET g_success= 'N'  
                EXIT FOREACH
             END IF
             IF g_success = "N" THEN
                LET g_totsuccess = "N"
                LET g_success = "Y"
             END IF

            #MOD-C70078---add---S---
             SELECT * INTO l_ogc.* FROM ogc_file
              WHERE ogc01= g_oga[l_ac].oga01b
                AND ogc03= l_ogb.ogb03
                AND ogc17= l_ogc.ogc17
                AND ogc092= l_ogc.ogc092

             SELECT SUM(ogc12) INTO l_ogc.ogc12 FROM ogc_file
              WHERE ogc01= g_oga[l_ac].oga01b
                AND ogc03= l_ogb.ogb03
                AND ogc092= l_ogc.ogc092  #FUN-C80001
              GROUP BY ogc17,ogc092
            #MOD-C70078---add---E---

             LET l_ogc12a = 0 
             SELECT SUM(ogc12) INTO l_ogc12a
               FROM ogb_file,oga_file,ogc_file
              WHERE ogb01 = oga01 
                AND ogb01 = ogc01
                AND ogb03 = ogc03 #MOD-DA0082 add
              # AND oga09 = '2' AND oga65='Y'     #FUN-BB0167 mark
               #AND (oga09 = '2' OR oga09 = '3') AND oga65='Y'  #FUN-BB0167   #FUN-C40072 mark
                AND (oga09 = '2' OR oga09 = '3' OR oga09 = '4') AND oga65='Y' #FUN-C40072 add 4 
                AND ogc01 = g_oga[l_ac].oga01b
                AND ogc03 = l_ogb.ogb03 
                AND ogb31 = l_ogb.ogb31
                AND ogb32 = l_ogb.ogb32
                AND ogb04 = l_ogb.ogb04 
                AND ogc092= l_ogc.ogc092  #FUN-C80001
                AND ogaconf = 'Y'
                AND ogapost = 'Y'
                AND ogc17 = l_ogc.ogc17 
             IF cl_null(l_ogc12a)  THEN LET l_ogc12a = 0 END IF

             LET l_ogc12b = 0
             SELECT SUM(ogc12) INTO l_ogc12b
               FROM ogb_file,oga_file,ogc_file
              WHERE ogb01 = oga01 
                AND ogb01 = ogc01
                AND ogb03 = ogc03 #MOD-DA0082 add
                AND oga09 IN ('8','9')  
                AND ogc01 = g_oga[l_ac].oga01b
                AND ogc03 = l_ogb.ogb03 
                AND ogb31 = l_ogb.ogb31
                AND ogb32 = l_ogb.ogb32
                AND ogb04 = l_ogb.ogb04 
                AND ogc092= l_ogc.ogc092  #FUN-C80001
                AND ogaconf != 'X'  
                AND ogc17 = l_ogc.ogc17 
             IF cl_null(l_ogc12b)  THEN LET l_ogc12b = 0 END IF

             LET l_ogc.ogc12 = l_ogc12a - l_ogc12b
             LET l_ogc.ogc16 = l_ogc.ogc12 * l_ogc.ogc15_fac
             LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15)  #FUN-BB0084
             IF l_ogc.ogc12 = 0 THEN CONTINUE FOREACH END IF

             LET l_ogc.ogc01 = g_oga01
             LET l_ogc.ogc09 = l_oga66
             LET l_ogc.ogc091= l_oga67
             
             IF NOT s_industry('icd') THEN  #FUN-C30310
                INSERT INTO ogc_file VALUES(l_ogc.*)
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                   CALL s_errmsg('','',"ins ogc",SQLCA.sqlcode,1)  
                   LET g_success='N'
                END IF
             END IF  #FUN-C30310

             LET g_ima918 = ''   
             LET g_ima921 = ''  
             SELECT ima918,ima921 INTO g_ima918,g_ima921 
               FROM ima_file
              WHERE ima01 = l_ogc.ogc17
                AND imaacti = "Y"

             IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                DECLARE p470_g_rvbs_2 CURSOR FOR SELECT * FROM rvbs_file
                                               WHERE rvbs01 = g_oga[l_ac].oga01b
                                                 AND rvbs02 = l_ogb.ogb03
                                                 AND rvbs13 = l_ogc.ogc18
                LET i = 1
                FOREACH p470_g_rvbs_2 INTO l_rvbs.*
                   IF STATUS THEN
                      CALL cl_err('rvbs',STATUS,1)
                   END IF
             
                   LET l_rvbs.rvbs00 = 'axmt628' 
                   LET l_rvbs.rvbs01 = g_oga01
                   LET l_rvbs.rvbs022 = i 

                   #檢查銷退數必須 =出貨單上的數量-簽收單上的數量
                   LET l_rvbs06a = 0
                   SELECT SUM(rvbs06) INTO l_rvbs06a
                     FROM rvbs_file
                   #WHERE rvbs01= l_oga.oga011
                    WHERE rvbs01= g_oga[l_ac].oga01b
                      AND rvbs02= l_ogb.ogb03
                      AND rvbs13 = l_rvbs.rvbs13   
                      AND rvbs09 = -1  
                      AND rvbs03=l_rvbs.rvbs03
                      AND rvbs04=l_rvbs.rvbs04
                   IF cl_null(l_rvbs06a) THEN
                      LET l_rvbs06a = 0
                   END IF

                   #已簽收數量
                   LET l_rvbs06b = 0
                   SELECT SUM(rvbs06) INTO l_rvbs06b
                     FROM ogb_file,oga_file,rvbs_file
                    WHERE ogb01 = oga01 AND oga09 IN ('8') 
                     #AND oga011 = l_oga.oga011
                      AND oga01 = g_oga[l_ac].oga01b
                      AND ogb03 = l_ogb.ogb03
                      AND oga01 = rvbs01
                      AND ogb03 = rvbs02
                      AND rvbs13 = l_rvbs.rvbs13  
                      AND rvbs09 = -1
                      AND ogaconf != 'X' 
                      AND rvbs03=l_rvbs.rvbs03
                      AND rvbs04=l_rvbs.rvbs04
                   IF cl_null(l_rvbs06b) THEN
                      LET l_rvbs06b = 0
                   END IF

                   LET l_rvbs.rvbs06 = l_rvbs06a - l_rvbs06b
             
                   INSERT INTO rvbs_file VALUES(l_rvbs.*)
                   IF STATUS OR SQLCA.SQLCODE THEN
                      CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)  
                   END IF
                   LET i = i + 1 
                END FOREACH
             END IF
          END FOREACH
          #FUN-C80001---begin
          IF g_sma.sma115 = 'Y' THEN
             DECLARE p470_ins_ogg_c1 CURSOR FOR
              SELECT ogg17,ogg092,ogg20 FROM ogg_file  
               WHERE ogg01= g_oga[l_ac].oga01b
                 AND ogg03= l_ogb.ogb03
               GROUP BY ogg17,ogg092 ,ogg20   
             FOREACH p470_ins_ogg_c1 INTO l_ogg.ogg17,l_ogg.ogg092,l_ogg.ogg20 
                IF STATUS THEN
                   CALL s_errmsg('','',"p470_ins_ogg_cl foreach:",SQLCA.sqlcode,1) 
                   EXIT FOREACH
                END IF
                IF g_success = "N" THEN
                   LET g_totsuccess = "N"
                   LET g_success = "Y"
                END IF
                SELECT * INTO l_ogg.* FROM ogg_file
                 WHERE ogg01= g_oga[l_ac].oga01b
                   AND ogg03= l_ogb.ogb03
                   AND ogg17= l_ogg.ogg17
                   AND ogg092= l_ogg.ogg092
                   AND ogg20= l_ogg.ogg20
   
                SELECT SUM(ogg12) INTO l_ogg.ogg12 FROM ogg_file
                 WHERE ogg01= g_oga[l_ac].oga01b
                   AND ogg03= l_ogb.ogb03
                   AND ogg092= l_ogg.ogg092    
                   AND ogg20= l_ogg.ogg20
                 GROUP BY ogg17,ogg092
                
                LET l_fac = 1
                SELECT img09 INTO l_img09 FROM img_file
                 WHERE img01 = l_ogb.ogb04
                   AND img02 = l_ogg.ogg09
                   AND img03 = l_ogg.ogg091
                   AND img04 = l_ogg.ogg092
                IF l_ogb.ogb05 <> l_img09 THEN
                   CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) 
                        RETURNING l_flag,l_fac
                   IF l_flag = 1 THEN
                      CALL cl_err('','mfg3075',1)
                      LET l_fac = 1
                   END IF
                END IF
                LET l_ogg.ogg16 = l_ogg.ogg12 * l_fac

                LET l_ogg.ogg01 = g_oga01
                LET l_ogg.ogg09 = l_oga66
                LET l_ogg.ogg091= l_oga67

                IF cl_null(l_ogg.ogg01) THEN LET l_ogg.ogg01=' ' END IF
                IF cl_null(l_ogg.ogg03) THEN LET l_ogg.ogg03=0 END IF
                IF cl_null(l_ogg.ogg09) THEN LET l_ogg.ogg09=' ' END IF
                IF cl_null(l_ogg.ogg091) THEN LET l_ogg.ogg091=' ' END IF
                IF cl_null(l_ogg.ogg092) THEN LET l_ogg.ogg092=' ' END IF
                IF cl_null(l_ogg.ogg17) THEN LET l_ogg.ogg17=' ' END IF
                IF cl_null(l_ogg.ogg12) THEN LET l_ogg.ogg12=0 END IF
                IF cl_null(l_ogg.ogg15_fac) THEN LET l_ogg.ogg15_fac=0 END IF
                IF cl_null(l_ogg.ogg16) THEN LET l_ogg.ogg16=0 END IF
                IF cl_null(l_ogg.ogg13) THEN LET l_ogg.ogg13=0 END IF 

                IF NOT s_industry('icd') THEN 
                   INSERT INTO ogg_file VALUES(l_ogg.*)
                   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                      CALL s_errmsg('','',"ins ogg",SQLCA.sqlcode,1)  
                      LET g_success='N'
                   END IF
                END IF
                
                LET g_ima918 = ''   
                LET g_ima921 = ''  
                SELECT ima918,ima921 INTO g_ima918,g_ima921 
                  FROM ima_file
                 WHERE ima01 = l_ogg.ogg17
                   AND imaacti = "Y"

                IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                   DECLARE p470_g_rvbs_3 CURSOR FOR SELECT * FROM rvbs_file
                                                  WHERE rvbs01 = g_oga[l_ac].oga01b
                                                    AND rvbs02 = l_ogb.ogb03
                                                    AND rvbs13 = l_ogg.ogg18
                   LET i = 1
                   FOREACH p470_g_rvbs_3 INTO l_rvbs.*
                      IF STATUS THEN
                         CALL cl_err('rvbs',STATUS,1)
                      END IF
             
                      LET l_rvbs.rvbs00 = 'axmt628' 
                      LET l_rvbs.rvbs01 = g_oga01
                      LET l_rvbs.rvbs022 = i 
                   
                      #檢查銷退數必須 =出貨單上的數量-簽收單上的數量
                      LET l_rvbs06a = 0
                      SELECT SUM(rvbs06) INTO l_rvbs06a
                        FROM rvbs_file
                       WHERE rvbs01= g_oga[l_ac].oga01b
                         AND rvbs02= l_ogb.ogb03
                         AND rvbs13 = l_rvbs.rvbs13   
                         AND rvbs09 = -1  
                         AND rvbs03=l_rvbs.rvbs03
                         AND rvbs04=l_rvbs.rvbs04
                      IF cl_null(l_rvbs06a) THEN
                         LET l_rvbs06a = 0
                      END IF

                      #已簽收數量
                      LET l_rvbs06b = 0
                      SELECT SUM(rvbs06) INTO l_rvbs06b
                        FROM ogb_file,oga_file,rvbs_file
                       WHERE ogb01 = oga01 AND oga09 IN ('8') 
                         AND oga01 = g_oga[l_ac].oga01b
                         AND ogb03 = l_ogb.ogb03
                         AND oga01 = rvbs01
                         AND ogb03 = rvbs02
                         AND rvbs13 = l_rvbs.rvbs13  
                         AND rvbs09 = -1
                         AND ogaconf != 'X' 
                         AND rvbs03=l_rvbs.rvbs03
                         AND rvbs04=l_rvbs.rvbs04
                      IF cl_null(l_rvbs06b) THEN
                         LET l_rvbs06b = 0
                      END IF

                      LET l_rvbs.rvbs06 = l_rvbs06a - l_rvbs06b
             
                      INSERT INTO rvbs_file VALUES(l_rvbs.*)
                      IF STATUS OR SQLCA.SQLCODE THEN
                         CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)  
                      END IF
                      LET i = i + 1 
                   END FOREACH 
                END IF 
             END FOREACH    
          END IF 
          #FUN-C80001---end
       END IF
       #CHI-AC0034 add --end--
    END FOREACH
    IF g_totsuccess = 'N' THEN
       LET g_success = 'N'
    END IF
 
END FUNCTION
 
FUNCTION p470_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(100)
 
   WHILE TRUE
      CALL p470_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN 
               CALL p470()
            END IF 
         WHEN "gen_on_check_note"
            IF cl_chk_act_auth() THEN
               CALL p470_gen()
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL p470_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p470_qry_on_check_note()
   DEFINE l_str   STRING
   DEFINE l_oga01 LIKE oga_file.oga01
   DEFINE l_flag  LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
   DECLARE p470_qry_on_check_cur CURSOR FOR
    SELECT oga01 FROM oga_file
     WHERE oga01  = g_oga01
       AND oga09 = '8'
     ORDER BY oga01
 
   LET l_flag = 0
   LET l_str="oga01 IN ("
 
   FOREACH p470_qry_on_check_cur INTO l_oga01
      IF STATUS THEN
         EXIT FOREACH
      END IF
 
      IF l_flag = 0 THEN
         LET l_str=l_str CLIPPED,'"',l_oga01,'"'
      ELSE
         LET l_str=l_str CLIPPED,',"',l_oga01,'"'
      END IF
 
      LET l_flag = l_flag + 1
   END FOREACH
 
   IF l_flag = 0 THEN
      LET l_str=" 0=1"
   ELSE
      LET l_str=l_str CLIPPED,")"
   END IF
 
#  LET g_sql="axmt628 '' '",l_str CLIPPED,"'"   #MOD-B80078 mark
#MOD-B80078 -- begin --
   CASE g_sma.sma124
      WHEN 'std'
         LET g_sql="axmt628 '' '",l_str CLIPPED,"'"
      WHEN 'icd'
         LET g_sql="axmt628_icd '' '",l_str CLIPPED,"'"
      OTHERWISE
         LET g_sql="axmt628 '' '",l_str CLIPPED,"'"
   END CASE
#MOD-B80078 -- end --
   CALL cl_cmdrun_wait(g_sql)
 
END FUNCTION
 
FUNCTION p470_out()
   DEFINE l_name        LIKE type_file.chr20,
          l_sql         LIKE type_file.chr1000,
          l_chr         LIKE type_file.chr1,
          l_cnt         LIKE type_file.num5,
          l_oga01       LIKE oga_file.oga01,
          l_wc          LIKE type_file.chr1000,   #No.TQC-A50044
          g_str         LIKE type_file.chr1000,
          sr            RECORD
                oga03   LIKE oga_file.oga03,
                oga032  LIKE oga_file.oga032,
                oga01   LIKE oga_file.oga01,
                oga01b  LIKE oga_file.oga01,
                oga02   LIKE oga_file.oga02,
                oga011  LIKE oga_file.oga011,
                oga04   LIKE oga_file.oga04,
                occ02   LIKE occ_file.occ02,
                oga23   LIKE oga_file.oga23,
                oga24   LIKE oga_file.oga24,
                ogb03   LIKE ogb_file.ogb03,
                oga16   LIKE oga_file.oga16,
                oeb03   LIKE oeb_file.oeb03,
                oeb04   LIKE oeb_file.oeb04,
                ima02   LIKE ima_file.ima02,
                ima021  LIKE ima_file.ima021,
                oeb12   LIKE oeb_file.oeb12,
                oeb13   LIKE oeb_file.oeb13,
                oeb14t  LIKE oeb_file.oeb14t, #CHI-970068 add ,                                                                     
                ogb31   LIKE ogb_file.ogb31   #CHI-970068       
               END RECORD
   CALL cl_del_data(l_table)
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   LET l_sql = " SELECT DISTINCT oga03,'','',oga01,oga02,oga011,oga04,occ02,",                                                      
               "        oga23,oga24,ogb03,oga16,ogb32,ogb04,'','',",                                                                
               "        ogb12,ogb13,ogb14t,ogb31", #CHI-970068 add ogb31                                                                                              
              #MOD-B30010 mod --start--
              #"   FROM oga_file,OUTER occ_file,",                                                                                  
              #"                 OUTER ogb_file",                                                                                   
              #"  WHERE oga04 = occ01",   
              #"    AND oga01 = ogb01",                                                                          
              #"    AND ogaconf='Y' AND ogapost='Y'",                                                                               
               "   FROM oga_file LEFT OUTER JOIN occ_file ON occ01=oga04",                                                                                  
               "                 LEFT OUTER JOIN ogb_file ON ogb01=oga01 AND ogb1005='1'",                                                                                   
               "  WHERE ogaconf='Y' AND ogapost='Y'",                                                                               
              #MOD-B30010 mod --end--
               "    AND oga65='Y' ",                                                                                                
              #"    AND oga09='2' ",               #FUN-BB0167 mark                                                                                 
               "    AND oga09 IN ('2','3','4') ",      #FUN-BB0167 #FUN-C40072 add 4
              #"    AND ogb1005='1'",#MOD-B30010 mark                                                                                               
               "    AND ",tm.wc CLIPPED
   PREPARE p470_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE p470_curs1 CURSOR FOR p470_prepare1
   FOREACH p470_curs1 INTO sr.*
      IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) 
         EXIT FOREACH
      END IF

      #No.TQC-A50044  --Begin
      SELECT COUNT(*) INTO l_cnt FROM ogb_file                                  
        WHERE ogb01=sr.oga01b AND ogb12 <>0                                     
       IF l_cnt = 0 THEN CONTINUE FOREACH END IF      
      #No.TQC-A50044  --End  
                                                                                
      SELECT COUNT(*) INTO l_cnt FROM ogb_file,oga_file                        
       WHERE oga01=ogb01 AND oga01=sr.oga01b                         
         AND ogb03 NOT IN (SELECT ogb03 FROM ogb_file,oga_file                 
                             WHERE oga01=ogb01 AND oga011=sr.oga01b   
                               AND oga09 ='8')                                  
      LET l_oga01 = NULL                                                       
      DECLARE p470_oga01_cur SCROLL CURSOR FOR                               
         SELECT oga01 FROM oga_file                                              
          WHERE oga011 = sr.oga01b                                     
            AND oga09 = '8'                                                      
          ORDER BY oga01                                                         
      OPEN p470_oga01_cur
      FETCH FIRST p470_oga01_cur INTO l_oga01                                
      CLOSE p470_oga01_cur                                                   
      IF tm.a = 'Y' THEN                                                       
         IF cl_null(l_oga01) THEN CONTINUE FOREACH END IF                      
         LET sr.oga01 = l_oga01                                          
      ELSE                                                                     
         IF NOT cl_null(l_oga01) THEN                                          
            IF l_cnt = 0 THEN                                                  
               CONTINUE FOREACH                                                
            ELSE                                                               
               LET sr.oga01 = l_oga01                                    
            END IF                                                             
         ELSE                                                                  
            LET sr.oga01 = NULL                                          
         END IF                                                                
      END IF
      SELECT occ02 INTO sr.oga032 FROM occ_file                                                                                     
       WHERE occ01=sr.oga03
      SELECT ima02,ima021 INTO sr.ima02,sr.ima021                                                                                   
        FROM ima_file                                                                                                               
       WHERE ima01=sr.oeb04                                                                                                         
      EXECUTE insert_prep USING sr.*
   END FOREACH
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   CALL cl_wcchp(tm.wc,'oga02,oga01,oga03,oga032')
        RETURNING l_wc     #No.TQC-A50044
   LET g_str = l_wc        #No.TQC-A50044
   LET l_sql = " SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   CALL cl_prt_cs3('axmp470','axmp470',l_sql,g_str)
END FUNCTION
#No:FUN-9C0071--------精簡程式-----

function p470_get_oga()
    DEFINE l_oga01      LIKE oga_file.oga01
    DEFINE l_oga69      LIKE oga_file.oga69          #TQC-C70158 add
    DEFINE l_oayslip    LIKE oay_file.oayslip
    DEFINE l_cnt        LIKE type_file.num5          #No.FUN-680137 SMALLINT
    DEFINE li_result    LIKE type_file.num5          #No.FUN-680137 SMALLINT
    DEFINE l_idb        RECORD LIKE idb_file.*       #FUN-C30310 add
    LET l_oga69 = g_today                            #TQC-C70158 add
 
   OPEN WINDOW p4701_w WITH FORM "axm/42f/axmp4701"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("axmp4701")
 
   INPUT l_oga01,l_oga69 WITHOUT DEFAULTS FROM oga01,oga69    #TQC-C70158 add l_oga69,oga69
       AFTER FIELD oga01
         IF NOT cl_null(l_oga01) THEN
            CALL s_check_no("axm",l_oga01,"","58","oga_file","oga01","")
                 RETURNING li_result,l_oga01
            IF (NOT li_result) THEN
               NEXT FIELD oga01
            END IF
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oga01)    #修改為hot code
                LET l_oayslip=s_get_doc_no(l_oga01)
                CALL q_oay(FALSE,TRUE,l_oayslip,'58','AXM') RETURNING l_oayslip
                LET l_oga01 = l_oayslip
                DISPLAY l_oga01 TO FORMONLY.oga01
                NEXT FIELD oga01
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
      LET INT_FLAG=0
      LET g_success = 'N'
      CLOSE WINDOW p4701_w
      RETURN
   END IF
 
   CLOSE WINDOW p4701_w

    return l_oga01,l_oga69
end function

# 打开axmt628
FUNCTION p470_open_axmt628(p_str)
    define p_str        string
    LET g_sql="axmt628 '' '",p_str CLIPPED,"'"
    CALL cl_cmdrun_wait(g_sql)
 
END FUNCTION
