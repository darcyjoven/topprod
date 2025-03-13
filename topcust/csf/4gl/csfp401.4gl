# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asfp401.4gl
# Descriptions...: 工單－整批結案
# Date & Author..: 92/08/07 By Nora
# Modify ........: No:9308 93/03/05 By Melody 發退料日期不得小於結案日期
# Modify.........: No:8936 03/12/22 By Ching add 輸入日期 check 不可小於 sma53
# Modify.........: MOD-480414 04/09/15 By echo 一進畫面,選出資料後, '選擇'欄位請default 空白
#                                              全選總數計算錯誤，一直累加
# Modify.........: MOD-4B0023 04/11/03 By Mandy  p401_check()中的l_qty數量計算有誤
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.MOD-630039 06/03/14 By Claire  結案時該採購單其它單身工單尚未結案該採購單整張不可結案
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-650116 06/09/29 By Sarah 判斷若輸入的結案日期小於最後異動日則不予結案
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-710026 07/01/15 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-7B0099 07/11/13 By Pengu 若存在一張已作廢的完工入庫單無法做結案
# Modify.........: No.MOD-7B0106 07/11/13 By Pengu 有兩筆工單一張不結案一張要結案，結果會變成都無法結案的狀態。
# Modify.........: No.MOD-7C0178 07/12/25 By Pengu 若有作廢的退料單或發料單，會導致無法結案
# Modify.........: NO.MOD-850220 08/05/22 BY claire 入庫日判斷不取sfe_file取tlf06
# Modify.........: No.FUN-840245 08/07/15 By sherry 增加Button 入庫量>=生產量  勾選出符合資料
# Modify.........: No.MOD-890065 08/09/05 By claire 結案時,多考慮最後報工日
# Modify.........: No.MOD-890185 08/09/18 By claire 程式一開始執行時要計算勾選的筆數給 cn3
# Modify.........: NO.FUN-850052 08/10/13 BY Yiting 開窗加入篩選資料條件「完工數量>=工單數量」
# Modify.........: NO.MOD-8A0066 08/11/24 BY liuxqa 結案時，需判斷拆件式工單的入庫單是否已審核過賬，若沒有，則該工單不可結案
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-920098 09/02/10 By chenl  結案選取資料時，需判斷是否有報廢日期，若報廢日期大于結案日期則不可結案。
# Modify.........: No.FUN-910053 09/02/12 By jan sma74-->ima153

# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-970067 09/11/26 By sabrina 程式中call了2次s_showmsg_init()會造成有些訊息無法呈現
# Modify.........: No.FUN-9C0072 10/01/11 By vealxu 精簡程式碼
# Modify.........: No:CHI-A50015 10/05/13 By Summer UPDATE後增加INSERT INTO azo_file
# Modify.........: No:MOD-A50165 10/05/24 By Sarah 工單作了第一段結案後,要作第二段工時結案,查詢工單單號查不出來
# Modify.........: No.FUN-A60027 10/06/07 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No.MOD-AC0372 10/12/28 By vealxu 1.當sma72='Y'時單身資料的過濾條件應該排除掉sfb28='2' 和 sfb28='3'的資料
#                                                   2.當sma72='N'時單身資料的過濾條件維持目前的條件sfb28<>'3'
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-9A0095 11/04/14 By abby MES整合追版
# Modify.........: No.FUN-AC0074 11/04/26 BY shenyang 考慮是否有備置未發量，有產生退備單
# Modify.........: No.FUN-940103 11/05/10 By lixiang 增加規格顯示欄位
# Modify.........: No:MOD-B60019 11/06/02 By sabrina 做結案時，日期不應一開始就給' '
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No:MOD-B80137 11/08/16 By Vampire 抓 tlf06 時應只撈取 asf
# Modify.........: No:MOD-BA0149 11/10/22 By johung 修改SQL問題
# Modify.........: No:FUN-C10065 12/02/08 By Abby MES標準整合外的工單無拋轉至MES，但在進行工單結案時卻拋轉MES並回饋工單不存在，導致該類工單結案失敗。
# Modify.........: No:TQC-C30118 12/03/07 By destiny 栏位输写错误
# Modify.........: No:MOD-C30893 12/03/30 By ck2yuan 工單已確認的才可作結案,不只有非作廢
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No:CHI-CB0053 12/12/17 By Elise 將g_today 改為 g_closeday
# Modify.........: No:FUN-CC0122 13/01/18 By Nina 修正MES標準整合外的工單無拋轉至MES，但在進行工單變更時卻拋轉MES並回饋工單不存在，導致該類工單變更拋轉失敗
# Modify.........: No:MOD-D10084 13/01/25 By bart 結案日期不可小於最後入庫日期
# Modify.........: No:FUN-D10046 13/02/18 By Alberti 新增委外廠商(sfb82)做查詢與篩選
# Modify.........: No:MOD-D40084 13/04/15 By bart show錯誤訊息並return,應該return前將 g_success = 'N'
# Modify.........: No:CHI-D40028 13/04/16 By bart 修改結案日期條件
# Modify.........: No:MOD-D40119 13/04/17 By bart 將串到pcm_file的部份移除
# Modify.........: No:MOD-D50245 13/05/29 By suncx 若委外工單有收貨單,對應的(入庫量+驗退量)>=收貨數量,才可結案
# Modify.........: No:MOD-D90056 13/09/14 By Alberti 修正 計算rvv17數量無加總，若入庫單有一筆以上，所撈取的rvv17只會呈現最後一次撈取數量
# Modify.........: No:MOD-DB0150 13/11/22 By suncx 判断如果是第一段发料结案,比对最后发料日和输入的结案日,如果跨月则予以提示,但不控卡;
#                                                  如果是第二段工时结案,则比对最后报工日和输入的结案日, 如果跨月也予以提示, 但不控卡

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE g_cnt     LIKE type_file.num10          #No.FUN-680121 INTEGER
DEFINE g_msg     LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(72)
       g_rec_b   LIKE type_file.num5,          #No.FUN-680121 SMALLINT
       l_ac      LIKE type_file.num5,          #program array no        #No.FUN-680121 SMALLINT
       l_sfb     DYNAMIC ARRAY OF RECORD
                    sure     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
                    sfb01       like sfb_file.sfb01,
                    sfb02       like sfb_file.sfb02,
                    sfb81       like sfb_file.sfb81,
                    sfb87       like sfb_file.sfb87,
                    sfb44       like sfb_file.sfb44,
                    gen02       like gen_file.gen02,
                    sfb22       like sfb_file.sfb22,
                    sfb221      like sfb_file.sfb221,
                    sfb86       like sfb_file.sfb86,
                    sfb89       like sfb_file.sfb89,
                    sfb05       like sfb_file.sfb05,
                    sfb06       like sfb_file.sfb06,
                    ima02       like ima_file.ima02,
                    ima021      like ima_file.ima021,
                    sfb08       like sfb_file.sfb08,
                    sfbud07     like sfb_file.sfbud07,
                    sfb13       like sfb_file.sfb13,
                    sfb15       like sfb_file.sfb15,
                    sfbud08     like sfb_file.sfbud08,
                    sfbud09     like sfb_file.sfbud09
                 END RECORD
DEFINE g_chk     DYNAMIC ARRAY OF RECORD           #FUN-650116 add
                  sure     LIKE type_file.chr1,    #選擇
                  sfb01    LIKE sfb_file.sfb01,    #工單號碼
                  flag     LIKE type_file.chr1     #檢查後是否可結案
                 END RECORD
DEFINE g_flag    LIKE type_file.chr1    #no.FUN-850052
DEFINE g_sfk02   LIKE sfk_file.sfk02     #No.MOD-920098  #報廢日期
DEFINE g_closeday     LIKE type_file.dat           #CHI-CB0053 add
DEFINE g_f       BOOLEAN    #MOD-DB0150
define l_chk_cnt    integer

MAIN
      DEFINE   l_sl,p_row,p_col   LIKE type_file.num5       #No.FUN-680121 SMALLINT #No.FUN-6A0090

   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090

   LET p_row = 3 LET p_col = 18
   LET g_closeday = g_today                #CHI-CB0053 add

   OPEN WINDOW p401_w AT p_row,p_col WITH FORM "csf/42f/csfp401"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

   CALL cl_ui_init()

   # OPEN WINDOW p401_cw AT p_row,p_col WITH FORM "asf/42f/asfp400b"   #NO.FUN-850052
   #      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

   # CALL cl_ui_locale("asfp400b")  #NO.FUN-850052

   LET g_flag = 'N'   #NO.FUN-850052
   # INPUT BY NAME g_closeday,g_flag WITHOUT DEFAULTS   #FUN-850052   #CHI-CB0053 mod g_today->g_closeday

   #    AFTER FIELD g_closeday                         #CHI-CB0053 mod g_today->g_closeday
   #       IF NOT cl_null(g_closeday) THEN             #CHI-CB0053 mod g_today->g_closeday
   #          IF g_closeday <= g_sma.sma53 THEN        #CHI-CB0053 mod g_today->g_closeday
   #             CALL cl_err(g_closeday,'axm-164',0)   #CHI-CB0053 mod g_today->g_closeday
   #             NEXT FIELD g_closeday                 #CHI-CB0053 mod g_today->g_closeday
   #          END IF
   #       END IF

   #    ON IDLE g_idle_seconds
   #       CALL cl_on_idle()
   #       CONTINUE INPUT

   #    ON ACTION exit                            #加離開功能
   #       LET INT_FLAG = 1
   #       EXIT INPUT

   # END INPUT
   # IF INT_FLAG THEN
   #    EXIT PROGRAM
   # END IF
   # CLOSE WINDOW p401_cw

   CALL p401()
   CLOSE WINDOW p401_w               #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
END MAIN

#將資料選出, 並進行挑選
FUNCTION p401()
DEFINE
   l_flag,l_sfb04       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
   l_sl         LIKE type_file.num5,          #No.FUN-680121 SMALLINT #screen array no
   l_cnt        LIKE type_file.num5,          #所選擇筆數        #No.FUN-680121 SMALLINT
   l_cnt1       LIKE type_file.num5,          #所選擇筆數        #No.FUN-680121 SMALLINT
   l_cnt2,l_cnt3,l_cnt4       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
   l_wc,l_sql        STRING ,      #NO.FUN-910082
   l_s          LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
   DEFINE l_sfbstr  STRING                      #紀錄工單編號      #FUN-9A0095 add
   DEFINE l_sfb02 LIKE sfb_file.sfb02           #FUN-C10065 add
   define l_success_cnt     integer
   define l_errno       string

   IF s_shut(0) THEN RETURN END IF
   LET l_cnt = 0

   WHILE TRUE
      ERROR""
    let l_chk_cnt = 0
    if l_sfb.getlength() > 0 then
        #将已审核的删除
        FOR l_ac=1 TO g_rec_b
            IF l_sfb[l_ac].sure!='Y' THEN          #該單據要結案
                continue for
            END if
            let l_cnt = 0
            select count(1) into l_cnt from sfb_file where sfb01 = l_sfb[l_ac].sfb01 and sfb87 = 'Y'
            if l_cnt > 0 then
                call l_sfb.deleteElement(l_ac)
                let g_rec_b = g_rec_b - 1
            else
                let l_sfb[l_ac].sure = 'N'
            end if
        END FOR 
    end if
    if l_sfb.getlength() = 0 then
        CLEAR FORM
        CALL cl_set_comp_visible("select_all,inverse,compare,cn3",FALSE)#No.FUN-840245

            construct l_wc on   sfb01,sfb02,sfb81,sfb87,sfb44,
                                sfb22,sfb221,sfb86,sfb89,sfb05,sfb06,
                                sfb08,sfbud07,sfb13,sfb15,
                                sfbud08,sfbud09
                from s_sfb[1].sfb01,s_sfb[1].sfb02,s_sfb[1].sfb81,s_sfb[1].sfb87,s_sfb[1].sfb44,
                    s_sfb[1].sfb22,s_sfb[1].sfb221,s_sfb[1].sfb86,s_sfb[1].sfb89,s_sfb[1].sfb05,s_sfb[1].sfb06,
                    s_sfb[1].sfb08,s_sfb[1].sfbud07,s_sfb[1].sfb13,s_sfb[1].sfb15,
                    s_sfb[1].sfbud08,s_sfb[1].sfbud09

            ON ACTION CONTROLP
                CASE
                    WHEN INFIELD(sfb05)
                        CALL q_sel_ima(TRUE, "q_ima","",l_sfb[1].sfb05,"","","","","",'')  RETURNING  g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO sfb05
                        NEXT FIELD sfb05
                    when INFIELD(sfb01) --工单号
                        CALL cl_init_qry_var()
                        LET g_qryparam.state    = "c"
                        LET g_qryparam.form     = "cq_sfb05"    #MOD-530280-2,3
                        #LET g_qryparam.where = " substr(sfb01,1,",g_doc_len,") NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "
                        # LET g_qryparam.where = " sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) " #FUN-B40029 #TQC-C50227
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO sfb01
                        NEXT FIELD sfb01
                    when infield(sfb22) --订单号
                        CALL cl_init_qry_var()
                        LET g_qryparam.state    = "c"
                        LET g_qryparam.form     = "q_oea3"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO sfb22
                        NEXT FIELD sfb22
                    when infield(sfb44) --申请人
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form = "q_gen"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret 
                        DISPLAY g_qryparam.multiret TO sfb44 
                        NEXT FIELD sfb44
                    when infield(sfb86) --母工单
                        CALL cl_init_qry_var()
                        LET g_qryparam.state    = "c"
                        LET g_qryparam.form     = "q_sfb"    #TQC-7B0048
                        # LET g_qryparam.default1 = l_sfb[l_ac].sfb86
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO sfb86
                        NEXT FIELD sfb86
                    when infield(sfb89) --上阶级工单
                        CALL cl_init_qry_var()
                        LET g_qryparam.state    = "c"
                        LET g_qryparam.form     = "q_sfb"    
                        # LET g_qryparam.default1 = l_sfb[l_ac].sfb89
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO sfb89
                        NEXT FIELD sfb89
                OTHERWISE
                    EXIT CASE
                END CASE

            ON ACTION locale
                LET g_action_choice = "locale"
                CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
                EXIT CONSTRUCT
            
            on action cancel
                call l_sfb.clear()
                let g_rec_b = 0 
                let l_chk_cnt = 0
                continue construct

            ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE CONSTRUCT

            ON ACTION exit                            #加離開功能
                LET INT_FLAG = 1
                EXIT CONSTRUCT

        END CONSTRUCT
        LET l_wc = l_wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030

        IF g_action_choice = "locale" THEN  #genero
            LET g_action_choice = ""
            CALL cl_dynamic_locale()
            CONTINUE WHILE
        END IF

        IF INT_FLAG THEN
            LET INT_FLAG = 0
            EXIT WHILE
        END IF

        LET l_sql = " select 'N',sfb01,sfb02,sfb81,sfb87,sfb44,gen02,sfb22,sfb221,sfb86,sfb89,sfb05,",
                    "        sfb06,ima02,ima021,sfb08,sfbud07,sfb13,sfb15,sfbud08,sfbud09",
                    "   from sfb_file left join ima_file on ima01=sfb05",
                    "   left join gen_file on gen01 = sfb44",
                    " where sfb87 ='N' and ",l_wc CLIPPED,
                    " order by sfb01 "
        PREPARE p401_prepare FROM l_sql      #預備之
        IF SQLCA.sqlcode THEN                          #有問題了
            CALL cl_err('PREPARE:',SQLCA.sqlcode,1)
            EXIT WHILE
        END IF
        DECLARE p401_curs CURSOR FOR p401_prepare  #宣告之

        LET l_sql = "SELECT pmm01,pmm25 ",         #組合查詢句子
                    "  FROM pmm_file,pmn_file ",
                    " WHERE pmm01=pmn01 ",
                    "   AND pmn41=? "
        PREPARE pmm_prepare FROM l_sql
        IF SQLCA.sqlcode THEN                          #有問題了
            CALL cl_err('PREPARE pmm_cs:',SQLCA.sqlcode,1)
            EXIT WHILE
        END IF
        DECLARE pmm_cs CURSOR FOR pmm_prepare  #宣告之

        CALL l_sfb.clear()
        CALL g_chk.clear()   #FUN-650116 add

        LET g_cnt=1                                      #總選取筆數
        LET g_rec_b = 0
        LET l_cnt=0                                      #MOD-890185 add
        FOREACH p401_curs INTO l_sfb[g_cnt].*            #逐筆抓出
            IF SQLCA.sqlcode THEN                         #有問題
                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                EXIT FOREACH
            END IF
            LET g_cnt = g_cnt + 1                        #累加筆數
            IF g_cnt > g_max_rec THEN                    #超過肚量了
                CALL cl_err('','9035',0)
                EXIT FOREACH
            END IF
        END FOREACH
        IF g_cnt=1 THEN                                 #沒有抓到
            CALL cl_err('','mfg5052',0)                 #顯示錯誤, 並回去
            CONTINUE WHILE
        END IF

        CALL l_sfb.deleteElement(g_cnt)
        LET g_rec_b = g_cnt - 1                         #正確的總筆數
      
    end if #darcy:2023/05/25

      MESSAGE ""
      CALL cl_getmsg('mfg5049',g_lang) RETURNING g_msg
      MESSAGE g_msg
      CALL ui.Interface.refresh()
      DISPLAY g_rec_b TO FORMONLY.cn2
      DISPLAY l_chk_cnt   TO FORMONLY.cn3  #MOD-890185 add

      CALL p401_sure()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CONTINUE WHILE
      END IF

      IF NOT cl_sure(0,0) THEN
         CONTINUE WHILE
      END IF

      CALL cl_wait()

      BEGIN WORK
      LET l_sl=0
      LET g_success = 'Y'
      LET l_sfbstr = ''          #FUN-9A0095 add
      CALL s_showmsg_init()             #MOD-970067 add

     #檢查是否有未過完帳的單據，若有則產出報表，不予結案
      LET g_f = TRUE #MOD-DB0150
      let l_success_cnt = 0
      FOR l_ac=1 TO g_rec_b
        IF l_sfb[l_ac].sure!='Y' THEN          #該單據要結案
            continue for
        END IF
        let g_success = 'Y'
        call asfi301_sub_confirm(g_prog,l_sfb[l_ac].sfb01,true) returning l_errno
        if g_success ='Y' then
            call s_errmsg('sfb01',l_sfb[l_ac].sfb01,'','csf-109',1)
            let l_success_cnt = l_success_cnt + 1
        else
            call s_errmsg('sfb01',l_sfb[l_ac].sfb01,'','csf119',1)
        end if
      END FOR
      #   
      call s_errmsg('','','一共审核成功'||l_success_cnt||'笔','!',1)
      CALL s_showmsg()

    if l_success_cnt > 0 then
        if cl_confirm('csf-111') then
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag
        else
            ROLLBACK WORK
         CALL cl_end2(2) RETURNING l_flag
        end if
    end if

    IF l_flag THEN
        CONTINUE WHILE
    ELSE
        EXIT WHILE
    END IF
    ERROR""
   END WHILE
   CLOSE WINDOW p401_w
END FUNCTION

FUNCTION p401_sure()
   DEFINE l_buf           LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(80)
          l_cnt           LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
          g_i             LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
          l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
          l_allow_delete  LIKE type_file.num5          #No.FUN-680121 SMALLINT

   DEFINE l_sfe04         LIKE sfe_file.sfe04
   DEFINE l_cmd           STRING  #darcy:2022/05/12

   MESSAGE ''

   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 

   LET l_ac = 1
   CALL cl_set_comp_visible("inverse,select_all,compare,cn3",TRUE)     #No.FUN-840245
   INPUT ARRAY l_sfb WITHOUT DEFAULTS FROM s_sfb.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET l_ac = ARR_CURR()

      ON CHANGE sure
         IF NOT cl_null(l_sfb[l_ac].sure) THEN
            IF l_sfb[l_ac].sure NOT MATCHES "[YN]" THEN
               NEXT FIELD sure
            END IF
            if l_sfb[l_ac].sure = 'Y' then
                let l_chk_cnt = l_chk_cnt + 1
            else
                let l_chk_cnt = l_chk_cnt - 1
            end if
            DISPLAY l_chk_cnt TO FORMONLY.cn3
         END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION select_all
         LET l_cnt=0                #No.MOD-480414
         CALL g_chk.clear()     #FUN-650116 add
         FOR g_i = 1 TO g_rec_b     #將所有的設為選擇
            LET l_sfb[g_i].sure ='Y'
         END FOR
         let l_chk_cnt = g_rec_b
         DISPLAY l_chk_cnt TO FORMONLY.cn3

      ON ACTION inverse
         FOR g_i = 1 TO g_rec_b     #將所有的設為不選擇
            LET l_sfb[g_i].sure=iif(l_sfb[g_i].sure='Y','N','Y')
         END FOR
         let l_chk_cnt = g_rec_b - l_chk_cnt
         DISPLAY l_chk_cnt TO FORMONLY.cn3 
      
      #add by cathree 20210805
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(l_sfb),'','')

      AFTER ROW
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

      AFTER INPUT
         LET l_cnt  = 0
         DISPLAY l_cnt TO FORMONLY.cn3

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
        
        on action cancel
            call l_sfb.clear()
            let g_rec_b = 0
            let l_chk_cnt = 0
            exit input

   END INPUT

END FUNCTION

FUNCTION p401_check(l_sfb01,l_sfb05)              #CLOSE
   DEFINE l_qty,l_qty_h,l_qty_l	LIKE sfb_file.sfb09,
          l_sfe04   LIKE sfe_file.sfe04,
          l_sfb01   LIKE sfb_file.sfb01,
          l_sfb05   LIKE sfb_file.sfb05, #FUN-910053
          l_sfb08   LIKE sfb_file.sfb08,
          l_sfb09   LIKE sfb_file.sfb09,
          l_sfb10   LIKE sfb_file.sfb10,
          l_sfb11   LIKE sfb_file.sfb11,
          l_sfb12   LIKE sfb_file.sfb12,
          l_sfb81   LIKE sfb_file.sfb81,
          l_shb03   LIKE shb_file.shb03
   DEFINE  l_ima153     LIKE ima_file.ima153   #FUN-910053

   CALL s_get_ima153(l_sfb05) RETURNING l_ima153  #FUN-910053

   SELECT MAX(sfe04) INTO l_sfe04 FROM sfe_file
    WHERE sfe01 = l_sfb01
   IF STATUS AND STATUS != 100 THEN
      CALL cl_err3("sel","sfe_file",l_sfb01,"",STATUS,"","",0)    #No.FUN-660128
       RETURN
   END IF
   IF l_sfe04 > g_closeday THEN   #CHI-CB0053 mod g_today->g_closeday
      RETURN 0
   END IF

   SELECT sfb08,sfb09,sfb10,sfb11,sfb12
     INTO l_sfb08,l_sfb09,l_sfb10,l_sfb11,l_sfb12
     FROM sfb_file WHERE sfb01 = l_sfb01
   IF STATUS AND STATUS != 100 THEN
      CALL cl_err3("sel","sfb_file",l_sfb01,"",STATUS,"","",0)      #No.FUN-660128
      RETURN
   END IF
   IF g_sma.sma73 = 'Y' THEN			#工單數量是否作勾稽
      LET l_qty = l_sfb09+l_sfb10+l_sfb12         #MOD-4B0023 將l_sfb11拿掉,後續單身打V才不會錯
      LET l_qty_l = l_sfb08 * (100-l_ima153)/100   #FUN-910053
      LET l_qty_h = l_sfb08 * (100+l_ima153)/100   #FUN-910053
      IF l_qty > l_qty_h OR l_qty < l_qty_l THEN
         #RETURN 0
      END IF
   END IF
   SELECT max(shb03) INTO l_shb03 FROM shb_file
    WHERE shb05=l_sfb01
      AND shbconf = 'Y'
   IF l_shb03 is null THEN LET l_shb03=l_sfb81 END IF
   IF g_closeday < l_shb03 THEN
      RETURN 0
   END IF
   RETURN 1
END FUNCTION

FUNCTION p401_close(l_sfb01,l_sfb28)
DEFINE l_sfb01	      LIKE sfb_file.sfb01,
       l_qty,l_qty_d  LIKE sfb_file.sfb08,
       l_sfa01        LIKE sfa_file.sfa01,  #09/10/21 xiaofeizhu Add
       l_sfa03        LIKE sfa_file.sfa03,
       l_sfa05        LIKE sfa_file.sfa05,
       l_sfa06        LIKE sfa_file.sfa06,
       l_sfa08        LIKE sfa_file.sfa08,  #09/10/21 xiaofeizhu Add
       l_sfa12        LIKE sfa_file.sfa12,  #09/10/21 xiaofeizhu Add
       l_sfa13        LIKE sfa_file.sfa13,
       l_sfa25        LIKE sfa_file.sfa25,
       l_sfa27        LIKE sfa_file.sfa27,  #09/10/21 xiaofeizhu Add
       l_sfa012       LIKE sfa_file.sfa012, #FUN-A60027
       l_sfa013       LIKE sfa_file.sfa013, #FUN-A60027
       l_pmn01        LIKE pmn_file.pmn01,
       l_pmn02        LIKE pmn_file.pmn02,
       l_pmm01        LIKE pmm_file.pmm01,
       l_pmm25        LIKE pmm_file.pmm25,
       l_pmn16        LIKE pmn_file.pmn16,
       p_pmn01        LIKE pmn_file.pmn01,
       p_pmn02        LIKE pmn_file.pmn02,
       l_n            LIKE type_file.num5,          #No.FUN-680121 SMALLINT
       l_pmm          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
       l_sta          LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
       l_qty1         LIKE alh_file.alh33,          #No.FUN-680121 DECIMAL(13,3)
       l_tlf06        LIKE tlf_file.tlf06,   #FUN-650116 add
       l_sfb81        LIKE sfb_file.sfb81,   #FUN-650116 add
       l_sfb13        LIKE sfb_file.sfb13,   #FUN-650116 add
       l_sfb04        LIKE sfb_file.sfb04,
       l_sfb05        LIKE sfb_file.sfb05,
       l_sfb08        LIKE sfb_file.sfb08,
       l_sfb09        LIKE sfb_file.sfb09,
       l_sfb10        LIKE sfb_file.sfb10,
       l_sfb11        LIKE sfb_file.sfb11,
       l_sfb12        LIKE sfb_file.sfb12,
       l_sfb28        LIKE sfb_file.sfb28,
       l_sfb36        LIKE sfb_file.sfb36,
       l_sfb37        LIKE sfb_file.sfb37,
       l_sfb38        LIKE sfb_file.sfb38
DEFINE l_cci01  LIKE cci_file.cci01,              #MOD-890065 add
       l_shb03  LIKE shb_file.shb03               #MOD-890065 add
DEFINE l_msg          LIKE type_file.chr1000     #CHI-A50015 add
DEFINE l_msg1         LIKE type_file.chr1000     #CHI-A50015 add
DEFINE l_msg2         LIKE type_file.chr1000     #CHI-A50015 add
DEFINE l_sie11 LIKE sie_file.sie11          #FUN-AC0074
DEFINE l_rvu03        LIKE rvu_file.rvu03  #MOD-D10084
#MOD-DB0150 add begin----------------------------
DEFINE l_yy_j    LIKE type_file.num5
DEFINE l_yy1     LIKE type_file.num5
DEFINE l_mm_j    LIKE type_file.num5
DEFINE l_mm1     LIKE type_file.num5
DEFINE l_f       BOOLEAN
DEFINE l_flag    LIKE type_file.chr1
DEFINE l_sfp03   LIKE sfp_file.sfp03
#MOD-DB0150 add end------------------------------
define l_cnt     like type_file.num5  #darcy:2022/10/17 add

   #判斷若輸入的結案日期小於最後異動日則不予結案
   SELECT max(tlf06) INTO l_tlf06 FROM tlf_file
    WHERE tlf62=l_sfb01
      AND (tlf02=50 OR tlf03=50)
   SELECT sfb81,sfb13 INTO l_sfb81,l_sfb13 FROM sfb_file
    WHERE sfb01=l_sfb01
   IF l_tlf06 is null THEN LET l_tlf06=l_sfb81 END IF
   IF l_tlf06 is null THEN LET l_tlf06=l_sfb13 END IF
   IF g_sma.sma72 = 'N' THEN  #CHI-D40028
      IF g_closeday < l_tlf06 THEN                                #CHI-CB0053 mod g_today->g_closeday
         CALL s_errmsg('tlf62',l_sfb01,'','asf-974',1)            #NO.FUN-710026
         LET g_success='N'
         RETURN
      END IF
   END IF #CHI-D40028
#MOD-DB0150 add begin-----------------------------
   IF g_sma.sma72 = 'Y' THEN
      CALL s_yp(g_closeday) RETURNING l_yy_j,l_mm_j
      SELECT MAX(sfp03) INTO l_sfp03 FROM sfp_file,sfe_file
       WHERE sfp01 = sfe02 AND sfe01 = l_sfb01
         AND sfp04 = 'Y'   AND sfpconf = 'Y'
         AND sfp06 IN ('1','2','3','4','D')
      CALL s_yp(l_sfp03) RETURNING l_yy1,l_mm1
      LET l_f = FALSE
      IF l_yy_j = l_yy1 THEN
         IF l_mm_j != l_mm1 THEN
            LET l_f = TRUE
         END IF
      ELSE
         LET l_f = TRUE
      END IF
      IF l_f AND cl_null(l_sfb28) AND g_f THEN
         CALL cl_confirm('asf1168') RETURNING l_flag
         IF NOT l_flag THEN
            LET g_success ='N'
            RETURN
         ELSE
            LET g_f = FALSE
         END IF
      END IF
   END IF
#MOD-DB0150 add end-------------------------------
   SELECT max(shb03) INTO l_shb03 FROM shb_file
    WHERE shb05=l_sfb01
      AND shbconf = 'Y'    #FUN-A70095
   IF l_shb03 is null THEN LET l_shb03=l_sfb81 END IF
   IF g_closeday < l_shb03 THEN     #CHI-CB0053 mod g_today->g_closeday
      CALL cl_err('','asf-974',1)   #結案日不可小於最後報工日
      LET g_success ='N'  #MOD-D40084
      RETURN
   END IF
#MOD-DB0150 add begin-----------------------------
   IF g_sma.sma72 = 'Y' THEN
      CALL s_yp(l_shb03) RETURNING l_yy1,l_mm1
      LET l_f = FALSE
      IF l_yy_j = l_yy1 THEN
         IF l_mm_j != l_mm1 THEN
            LET l_f = TRUE
         END IF
      ELSE
         LET l_f = TRUE
      END IF
      IF l_f AND l_sfb28='1' AND g_f THEN
         CALL cl_confirm('asf1169') RETURNING l_flag
         IF NOT l_flag THEN
            LET g_success ='N'
            RETURN
         ELSE
            LET g_f = FALSE
         END IF
      END IF
   END IF
#MOD-DB0150 add end-------------------------------
   SELECT MAX(cci01) INTO l_cci01 FROM cci_file,ccj_file
    WHERE cci01=ccj01 AND ccj04=l_sfb01
      AND ccifirm = 'Y'
   IF l_cci01 is null THEN LET l_cci01=l_sfb81 END IF
   IF g_closeday < l_cci01 THEN     #CHI-CB0053 mod g_today->g_closeday
      CALL cl_err('','asf-974',1)   #結案日不可小於最後報工日
      LET g_success ='N'  #MOD-D40084
      RETURN
   END IF
   #MOD-D10084---begin
   #結案日期不可小於最後入庫日期
   SELECT MAX(rvu03) INTO l_rvu03
     FROM rvv_file,rvu_file
    WHERE rvv01 = rvu01
      AND rvu08 = 'SUB'
      AND rvv18 = l_sfb01
      AND rvuconf <> 'X'
   IF cl_null(l_rvu03) THEN
      LET l_rvu03 = l_sfb81
   END IF
   IF g_closeday < l_rvu03 THEN
      CALL cl_err('','asf-247',1)
      LET g_success ='N'  #MOD-D40084
      RETURN
   END IF
   #MOD-D10084---end
  #MOD-B60019---modify---start---
  #LET l_sfb36 = ''  LET l_sfb37 = ''  LET l_sfb38 =''
   SELECT sfb36,sfb37,sfb38 INTO l_sfb36,l_sfb37,l_sfb38 FROM sfb_file
    WHERE sfb01=l_sfb01
   IF cl_null(l_sfb36) THEN LET l_sfb36 = ' ' END IF
   IF cl_null(l_sfb37) THEN LET l_sfb37 = ' ' END IF
   IF cl_null(l_sfb38) THEN LET l_sfb38 = ' ' END IF
  #MOD-B60019---modify---end---

   IF g_sma.sma72 = 'Y' THEN
      #CHI-D40028---begin
      IF l_sfb28 = '1' THEN
         IF g_closeday < l_sfb36 THEN
            CALL cl_err(l_sfb01,'asf-352',0)
            LET g_success='N'
            RETURN
         END IF
      END IF
      #CHI-D40028---end
      CASE l_sfb28
         WHEN '1' LET l_sfb28 = '2'
         WHEN '2' LET l_sfb28 = '3'
         WHEN '3' LET l_sfb28 = '3'
         OTHERWISE LET l_sfb28 = '1'
      END CASE
   ELSE
      LET l_sfb28 = '3'
      LET l_sfb36=g_closeday    #CHI-CB0053 mod g_today->g_closeday
      LET l_sfb37=g_closeday    #CHI-CB0053 mod g_today->g_closeday
      LET l_sfb38=g_closeday    #CHI-CB0053 mod g_today->g_closeday
   END IF
   CASE l_sfb28
      WHEN '1' LET l_sfb36=g_closeday   #CHI-CB0053 mod g_today->g_closeday
      WHEN '2' LET l_sfb37=g_closeday   #CHI-CB0053 mod g_today->g_closeday
      WHEN '3' LET l_sfb38=g_closeday   #CHI-CB0053 mod g_today->g_closeday
      OTHERWISE EXIT CASE
   END CASE
   SELECT sfb04,sfb05,sfb08,sfb09,sfb10,sfb11,sfb12
     INTO l_sfb04,l_sfb05,l_sfb08,l_sfb09,l_sfb10,l_sfb11,l_sfb12
     FROM sfb_file
    WHERE sfb01 = l_sfb01
   LET l_qty = l_sfb09+l_sfb10+l_sfb11+l_sfb12
   IF cl_null(l_sfb08) THEN LET l_sfb08=0 END IF
   IF l_qty < l_sfb08 THEN
      LET l_qty_d = l_sfb08 - l_qty
   ELSE
      LET l_qty_d = 0
   END IF
   UPDATE sfb_file SET sfb04='8'    ,sfb28=l_sfb28,sfb36=l_sfb36,
   		       sfb37=l_sfb37,sfb38=l_sfb38
   		 WHERE sfb01=l_sfb01
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('sfb01',l_sfb01,'update:',SQLCA.sqlcode,0)               #NO.FUN-710026
      LET g_success='N'
      RETURN
   END IF
   #CHI-A50015 add --start--
   LET g_msg=TIME
  #MOD-BA0149 -- mark begin --
  #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06)
  #       VALUES ('asfp401',g_user,g_today,g_msg,l_sfb01,'UPDATE sfb_file')
  #MDO-BA0149 -- mark end --
   #MOD-BA0149 -- begin --
   INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
          VALUES ('asfp401',g_user,g_today,g_msg,l_sfb01,'UPDATE sfb_file',g_plant,g_legal)
   #MOD-BA0149 -- end --
   #CHI-A50015 add --end--
   DECLARE l_cc CURSOR FOR SELECT sfa01,sfa03,sfa08,sfa12,sfa27,sfa05,sfa06,sfa25,sfa13,sfa012,sfa013    #09/10/21 xiaofeizhu Add #FUN-A60027 add sfa012,sfa013
                FROM sfa_file WHERE sfa01 = l_sfb01
   FOREACH l_cc INTO l_sfa01,l_sfa03,l_sfa08,l_sfa12,l_sfa27,l_sfa05,l_sfa06,l_sfa25,l_sfa13,l_sfa012,l_sfa013   #09/10/21 xiaofeizhu Add  #FUN-A60027 add l_sfa012,l_sfa013
         IF g_success='N' THEN
            LET g_totsuccess='N'
            LET g_success="Y"
         END IF

      UPDATE sfa_file SET sfa25 = l_sfa05 - l_sfa06
        WHERE sfa01 = l_sfa01                                                                  #09/10/21 xiaofeizhu Add
          AND sfa03 = l_sfa03                                                                  #09/10/21 xiaofeizhu Add
          AND sfa08 = l_sfa08                                                                  #09/10/21 xiaofeizhu Add
          AND sfa12 = l_sfa12                                                                  #09/10/21 xiaofeizhu Add
          AND sfa27 = l_sfa27                                                                  #09/10/21 xiaofeizhu Add
          AND sfa012 = l_sfa012                                                                #FUN-A60027 add
          AND sfa013 = l_sfa013                                                                #FUN-A60027 add

      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('sfa_file.sfa01',l_sfa01,'Update sfa25 fail:',SQLCA.sqlcode,1)         #09/10/21 xiaofeizhu Add
         LET g_success = 'N'
         CONTINUE FOREACH                                                                     #NO.FUN-710026
      END IF
      #CHI-A50015 add --start--
      SELECT ze03 INTO l_msg1 FROM ze_file
          WHERE ze01 = 'asr-009' AND ze02 = g_lang
     #SELECT gae04 INTO l_msg2 FROM ze_file   #MOD-BA0149 mark
      SELECT gae04 INTO l_msg2 FROM gae_file  #MOD-BA0149
          WHERE gae01 = 'asfi301' AND gae02 = 'sfa27' AND gae03 = g_lang
            AND gae11 = 'N' AND gae12 = 'std'  #MOD-BA0149 add
      LET l_msg = "UPDATE sfa_file,",l_msg1,":",l_sfa03 CLIPPED,l_msg2,":",l_sfa27 CLIPPED
      LET g_msg=TIME
     #MOD-BA0149 -- mark begin --
     #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06)
     #       VALUES ('asfp401',g_user,g_today,g_msg,l_sfa01,l_msg)
     #MOD-BA0149 -- mark end --
     #MOD-BA0149 -- begin --
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
             VALUES ('asfp401',g_user,g_today,g_msg,l_sfb01,l_msg,g_plant,g_legal)
      #MOD-BA0149 -- end --
      #CHI-A50015 add --end--
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF

#NO:6961=========工單相關的採購單一併做結案==================

   DECLARE pmn_cur CURSOR FOR
    SELECT pmn01,pmn02,pmn50-pmn20-pmn55,pmn16 FROM pmn_file
     WHERE pmn41 = l_sfb01
   FOREACH pmn_cur INTO l_pmn01,l_pmn02,l_qty1,l_pmn16
         IF g_success='N' THEN
            LET g_totsuccess='N'
            LET g_success="Y"
         END IF
      IF l_pmn16 MATCHES '[678]' THEN CONTINUE FOREACH END IF
      #add darcy:2022/10/17 s---
      # 委外采购还未入库且还未结案，不允许工单结案。
      #darcy:2022/10/25 add s---
      let l_cnt = 0
      select count(1) into l_cnt from pmm_file where pmm01 = l_pmn01 and pmm18='Y'
      if l_cnt > 0 then 
      #darcy:2022/10/25 add e---
         let l_cnt = 0
         SELECT count(1) into l_cnt
           FROM rvv_file, rvu_file
          WHERE rvv01 = rvu01
            AND rvu00 = '1'
            AND rvuconf = 'Y'
            AND rvv36 = l_pmn01 AND rvv37 = l_pmn02
         if l_cnt = 0 then
            let g_showmsg=l_pmn01,"/",l_pmn02
            call s_errmsg('pmn01,pmn02',g_showmsg,'error:','csf-104',1)               #no.fun-710026
            let g_success = 'n'
            continue foreach
         end if
      end if #darcy:2022/10/25 add
      #add darcy:2022/10/17 e---
      CASE
         WHEN l_qty1 = 0 LET  l_sta = '6'
         WHEN l_qty1 > 0 LET  l_sta = '7'
         WHEN l_qty1 < 0 LET  l_sta = '8'
         OTHERWISE EXIT CASE
      END CASE
      UPDATE pmn_file SET pmn16 = l_sta, pmn57=l_qty1
       WHERE pmn01 = l_pmn01 AND pmn02 = l_pmn02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         LET g_showmsg=l_pmn01,"/",l_pmn02                                                          #NO.FUN-710026
         CALL s_errmsg('pmn01,pmn02',g_showmsg,'Update pmn16 error:',SQLCA.sqlcode,1)               #NO.FUN-710026
         LET g_success = 'N'
         CONTINUE FOREACH                                                                           #NO.FUN-710026
      END IF
      #CHI-A50015 add --start--
      SELECT ze03 INTO l_msg1 FROM ze_file
          WHERE ze01 = 'aap-417' AND ze02 = g_lang
      LET l_msg = "UPDATE pmn_file,",l_msg1,":",l_pmn02 CLIPPED
      LET g_msg=TIME
     #MOD-BA0149 -- mark begin --
     #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06)
     #       VALUES ('asfp401',g_user,g_today,g_msg,l_pmn01,l_msg)
     #MOD-BA0149 -- mark end --
      #MOD-BA0149 -- begin --
       INSERT INTO azo_file(azo01,azn02,azo03,azo04,azo05,azo06,azoplant,azolegal)
              VALUES ('asfp401',g_user,g_today,g_msg,l_pmn01,l_msg,g_plant,g_legal)
      #MOD-BA0149 -- end --
      #CHI-A50015 add --end--
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF

   #==>Update pmm_file      #多張採購單時
   FOREACH pmm_cs USING l_sfb01 INTO l_pmm01,l_pmm25
          IF g_success='N' THEN
             LET g_totsuccess='N'
             LET g_success="Y"
          END IF

      IF l_pmm25='6' THEN CONTINUE FOREACH END IF
      SELECT COUNT(*) INTO l_pmm FROM pmn_file
       WHERE pmn01 = l_pmm01 AND (pmn16 ='0' OR pmn16='1' OR pmn16='2')
      IF l_pmm IS NULL THEN LET l_pmm = 0 END IF
      IF l_pmm = 0  THEN
         UPDATE pmm_file SET pmm25 = '6'
          WHERE pmm01 = l_pmm01
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            CALL s_errmsg('pmm01',l_pmm01,'Update pmm25 fail:',SQLCA.sqlcode,1)                #NO.FUN-710026
            LET g_success = 'N'
         END IF
         #CHI-A50015 add --start--
         LET g_msg=TIME
        #MOD-BA0149 -- mark begin --
        #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06)
        #       VALUES ('asfp401',g_user,g_today,g_msg,l_pmm01,'UPDATE pmm_file')
        #MOD-BA0149 -- mark end --
         #MOD-BA0149 -- begin --
         INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
                VALUES ('asfp401',g_user,g_today,g_msg,l_pmm01,'UPDATE pmm_file',g_plant,g_legal)
         #MOD-BA0149 -- end --
         #CHI-A50015 add --end--
      END IF
   END FOREACH
    #FUN-AC0074--add--begin
   SELECT  SUM(sie11) INTO l_sie11 FROM sie_file
     WHERE  sie05 = l_sfb01
   IF l_sie11 >0 THEN
      CALL p401_yes(l_sfb05,l_sfb01)
   END IF
   #FUN-AC0074--add--end
  IF g_totsuccess="N" THEN
           LET g_success="N"
    END IF

END FUNCTION

#FUN-AC0074--add--begin
FUNCTION p401_yes(p_sfb05,p_sfb01)
DEFINE  l_sia  RECORD LIKE sia_file.*
DEFINE  p_sfb05 LIKE   sfb_file.sfb05
DEFINE  p_sfb01 LIKE   sfb_file.sfb01
DEFINE  l_sie   DYNAMIC ARRAY OF RECORD
                sie01   LIKE sie_file.sie01,
                sie02   LIKE sie_file.sie02,
                sie03   LIKE sie_file.sie03,
                sie04   LIKE sie_file.sie04,
                sie05   LIKE sie_file.sie05,
                sie06   LIKE sie_file.sie06,
                sie07   LIKE sie_file.sie07,
                sie08   LIKE sie_file.sie08,
                sie09   LIKE sie_file.sie09,
                sie10   LIKE sie_file.sie10,
                sie11   LIKE sie_file.sie11,
                sie12   LIKE sie_file.sie12,
                sie13   LIKE sie_file.sie13,
                sie14   LIKE sie_file.sie14,
                sie15   LIKE sie_file.sie15,
                sie16   LIKE sie_file.sie16,
                sie012  LIKE sie_file.sie012,
                sie013  LIKE sie_file.sie013
                END RECORD
DEFINE l_ac             LIKE type_file.num5
DEFINE g_sql            STRING
DEFINE li_result    LIKE type_file.num5
DEFINE l_err        STRING
DEFINE l_flag      LIKE type_file.chr1
DEFINE l_ima25     LIKE ima_file.ima25
DEFINE l_fac       LIKE ima_file.ima31_fac
DEFINE l_sic07_fac LIKE sic_file.sic07_fac
DEFINE l_sic02     LIKE sic_file.sic02

      LET l_sia.sia04 ='2'
      LET l_sia.sia05 = '2'
      LET l_sia.sia02 =g_today
      LET l_sia.sia03 =g_today
      LET l_sia.siaacti = 'Y'
      LET l_sia.siaconf = 'N'
      LET l_sia.siauser = g_user
      LET l_sia.siaplant = g_plant
      LET l_sia.siadate = g_today
      LET l_sia.sialegal = g_legal
      LET l_sia.siagrup = g_grup
      LET l_sia.siaoriu = g_user
      LET l_sia.siaorig = g_grup
      LET l_sia.sia06 = g_grup
         LET g_sql=" SELECT MAX(smyslip) FROM smy_file",
                   "  WHERE smysys = 'asf' AND smykind='5' ",
                   "    AND length(smyslip) = ",g_doc_len
         PREPARE p410_smy FROM g_sql
         EXECUTE p410_smy INTO l_sia.sia01
        CALL s_auto_assign_no("asf",l_sia.sia01,l_sia.sia02,"","sia_file","sia01","","","")
            RETURNING li_result,l_sia.sia01
        IF (NOT li_result) THEN
            LET g_success='N'
            RETURN
        END IF
     #INSERT INTO sia_file(sia01,sia02,sia03,sia04,ais05,sia06,siaacti, #TQC-C30118
      INSERT INTO sia_file(sia01,sia02,sia03,sia04,sia05,sia06,siaacti, #TQC-C30118
                    siaconf,siauser,siaplant,
                     siadate,sialegal,siagrup,siaoriu,siaorig)
             VALUES (l_sia.sia01,l_sia.sia02,l_sia.sia03,l_sia.sia04,l_sia.sia05,g_grup,l_sia.siaacti,
                     l_sia.siaconf,l_sia.siauser,l_sia.siaplant,
                     l_sia.siadate,l_sia.sialegal,l_sia.siagrup,l_sia.siaoriu,l_sia.siaorig)

      IF SQLCA.sqlcode THEN
         LET l_err = SQLCA.sqlcode
         CALL cl_err3("ins","sia_file",l_sia.sia01,l_sia.sia02,l_err,"","ins sia:",1)
         LET g_success = 'N'
         RETURN
      END IF
      LET l_ac =1
      LET g_sql =
             "SELECT sie01,sie02,sie03,sie04,sie05,sie06,sie07,sie08,sie09,sie10,sie11,sie12,sie13,sie14,sie15,sie16,sie012,sie013",
             " FROM sie_file",
             " WHERE sie05 = '",p_sfb01,"' AND sie11 > 0 "
      PREPARE p400_pb2 FROM g_sql
      DECLARE sie_curs2 CURSOR FOR p400_pb2
      FOREACH sie_curs2  INTO l_sie[l_ac].*
         SELECT ima25 INTO l_ima25 FROM ima_file
           WHERE ima01 = l_sie[l_ac].sie08
         CALL s_umfchk(l_sie[l_ac].sie08,l_sie[l_ac].sie07,l_ima25)
            RETURNING l_flag,l_fac
         IF l_flag THEN
            CALL cl_err('','',0)
            LET g_success = 'N'
            RETURN
         ELSE
            LET l_sic07_fac = l_fac
         END IF
         SELECT max(sic02)+1 INTO l_sic02 FROM sic_file
           WHERE sic01 = l_sia.sia01
         IF cl_NULL(l_sic02) THEN
            LET l_sic02 =1
         END IF
         INSERT INTO sic_file(sic01,sic02,sic03,sic04,sic05,
                    sic06,sic07,sic08,sic09,
                     sic10,sic11,sic012,sic013,sic15,sic12,siclegal,sicplant,sic07_fac)
             VALUES (l_sia.sia01,l_sic02,l_sie[l_ac].sie05,l_sie[l_ac].sie08,l_sie[l_ac].sie01,
                     l_sie[l_ac].sie11,l_sie[l_ac].sie07,l_sie[l_ac].sie02,l_sie[l_ac].sie03,
                     l_sie[l_ac].sie04,l_sie[l_ac].sie06,l_sie[l_ac].sie012,l_sie[l_ac].sie013,
                     l_sie[l_ac].sie15,'',g_legal,g_plant,l_sic07_fac)
      IF SQLCA.sqlcode THEN
         LET l_err = SQLCA.sqlcode
         CALL cl_err3("ins","sic_file",l_sia.sia01,l_sie[l_ac].sie15,l_err,"","ins sic:",1)
         LET g_success = 'N'
         RETURN
      END IF
      LET l_ac= l_ac+1
     END  FOREACH
     CALL i610sub_y_chk(l_sia.sia01)
     IF g_success = "Y" THEN
        CALL i610sub_y_upd(l_sia.sia01,'',TRUE)  RETURNING l_sia.*
     END IF
END FUNCTION
#FUN-AC0074 --add--end

FUNCTION p401_doc_chk()
   DEFINE l_i      LIKE type_file.num5,
          l_cnt    LIKE type_file.num5,
          l_sql        STRING,       #NO.FUN-910082
          l_docno  LIKE sfb_file.sfb01
  #MOD-D50245 add---S
   DEFINE l_rvv17a LIKE rvv_file.rvv17,
          l_rvv17b LIKE rvv_file.rvv17,
          l_rvb07  LIKE rvb_file.rvb07
  #MOD-D50245 add---E

   DROP TABLE p401_temp;
   CREATE TEMP TABLE p401_temp(
       sfb01     LIKE sfb_file.sfb01,
       type      LIKE type_file.chr1,
       docno     LIKE sfp_file.sfp01);

   LET l_sql= "INSERT INTO p401_temp (sfb01,type,docno) ",
              "               VALUES (    ?,   ?,    ?) "
   PREPARE p401_ins_p1 FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('p401_ins_p1',SQLCA.SQLCODE,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   #若發料單、退料單、完工入庫單有單據未過帳，則出報表
   FOR l_i = 1 TO g_cnt
       IF g_success='N' THEN
          LET g_totsuccess='N'
          LET g_success="Y"
       END IF

      IF g_chk[l_i].sure = 'Y' THEN
         #發料單
         LET l_cnt = 0
         DECLARE p401_chk_c1 CURSOR FOR
            SELECT COUNT(sfp01),sfp01 FROM sfp_file,sfs_file
             WHERE sfp01=sfs01
               AND sfs03=g_chk[l_i].sfb01
               AND sfp04!='Y'
               AND sfpconf != 'X'          #No.MOD-7C0178 add
               AND sfp06 IN ('1','2','3','4','D')       #FUN-C70014 add 'D'
             GROUP BY sfp01
         FOREACH p401_chk_c1 INTO l_cnt,l_docno
            IF STATUS THEN
               CALL s_errmsg('','','for sfs:',STATUS,1)                 #NO.FUN-710026
               LET g_success='N'
            EXIT FOREACH
            END IF

            IF l_cnt > 0 THEN
               EXECUTE p401_ins_p1 USING g_chk[l_i].sfb01,'1',l_docno
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] =0 THEN
                  CALL s_errmsg('','','INSERT p401_temp',SQLCA.SQLCODE,1)        #NO.FUN-710026
               END IF
               LET g_chk[l_i].flag = 'N'
            END IF
         END FOREACH

         #退料單
         LET l_cnt = 0
         DECLARE p401_chk_c2 CURSOR FOR
            SELECT COUNT(sfp01),sfp01 FROM sfp_file,sfs_file
             WHERE sfp01=sfs01
               AND sfs03=g_chk[l_i].sfb01
               AND sfp04!='Y'
               AND sfpconf != 'X'          #No.MOD-7C0178 add
               AND sfp06 IN ('6','7','8','9')
             GROUP BY sfp01
         FOREACH p401_chk_c2 INTO l_cnt,l_docno
            IF STATUS THEN
               CALL s_errmsg('','','for sfs:',STATUS,1)             #NO.FUN-710026
                    LET g_success='N' EXIT FOREACH
            END IF

            IF l_cnt > 0 THEN
               EXECUTE p401_ins_p1 USING g_chk[l_i].sfb01,'2',l_docno
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] =0 THEN
                  CALL s_errmsg('','','INSERT p401_temp',SQLCA.SQLCODE,1)   #NO.FUN-710026
               END IF
               LET g_chk[l_i].flag = 'N'
            END IF
         END FOREACH

         #完工入庫單
         LET l_cnt = 0
         DECLARE p401_chk_c3 CURSOR FOR
            SELECT COUNT(sfu01),sfu01 FROM sfu_file,sfv_file
             WHERE sfu01=sfv01
               AND sfv11=g_chk[l_i].sfb01
               AND sfupost!='Y' AND sfuconf !='X'   #No.MOD-7B0099 add sfuconf
             GROUP BY sfu01
         FOREACH p401_chk_c3 INTO l_cnt,l_docno
            IF STATUS THEN
               CALL s_errmsg('','','for sfu:',STATUS,1)       #NO.FUN-71002
               LET g_success='N' EXIT FOREACH
            END IF

            IF l_cnt > 0 THEN
               EXECUTE p401_ins_p1 USING g_chk[l_i].sfb01,'3',l_docno
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] =0 THEN
                  CALL s_errmsg('','','INSERT p401_temp',SQLCA.SQLCODE,1)      #NO.FUN-710026
               END IF
               LET g_chk[l_i].flag = 'N'
            END IF
         END FOREACH


#拆件式完工入庫單
         LET l_cnt = 0
         DECLARE p401_chk_c4 CURSOR FOR
            SELECT COUNT(ksc01),ksc01 FROM ksc_file,ksd_file
             WHERE ksc01=ksd01
               AND ksd11=g_chk[l_i].sfb01
               AND kscpost!='Y' AND kscconf !='X'   #No.MOD-7B0099 add sfuconf
             GROUP BY ksc01
         FOREACH p401_chk_c4 INTO l_cnt,l_docno
            IF STATUS THEN
               CALL s_errmsg('','','for ksc:',STATUS,1)       #NO.FUN-71002
               LET g_success='N' EXIT FOREACH
            END IF

            IF l_cnt > 0 THEN
               EXECUTE p401_ins_p1 USING g_chk[l_i].sfb01,'4',l_docno
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] =0 THEN
                  CALL s_errmsg('','','INSERT p401_temp',SQLCA.SQLCODE,1)      #NO.FUN-710026
               END IF
               LET g_chk[l_i].flag = 'N'
            END IF
         END FOREACH
        #MOD-D50245---add---S
        #委外工單有收貨單
         LET l_cnt = 0
         SELECT COUNT(rvb01) INTO l_cnt FROM rvb_file
          WHERE rvb34 = l_sfb[l_ac].sfb01
         LET l_rvv17a =0
        #SELECT rvv17 INTO l_rvv17a FROM rvv_file,rvu_file                #MOD-D90056 mark
         SELECT SUM(rvv17) INTO l_rvv17a FROM rvv_file,rvu_file           #MOD-D90056 add
          WHERE rvv01 = rvu01
            AND rvv18 = l_sfb[l_ac].sfb01
            AND rvu00 ='1'                  #入庫量
            AND rvv31 = l_sfb[l_ac].sfb05
            AND rvuconf = 'Y'    #MOD-D30235
         IF cl_null(l_rvv17a) THEN LET l_rvv17a = 0 END IF                #MOD-D90056 add

         IF l_cnt > 0 AND l_rvv17a <= 0   THEN  #委外工單有收貨單，但未有入庫，不能結案
            LET g_success= 'N'
           #CALL cl_err('','asf006',1)                                    #MOD-D90056 mark
            CALL cl_err('','asf1160',1)                                   #MOD-D90056 add
         ELSE
           #(入庫量+驗退量)>=收貨數量 才可結案
            LET l_rvv17b =0
           #SELECT rvv17 INTO l_rvv17b FROM rvv_file,rvu_file             #MOD-D90056 mark
            SELECT SUM(rvv17) INTO l_rvv17b FROM rvv_file,rvu_file        #MOD-D90056 add
             WHERE rvv01 = rvu01
               AND rvv18 = l_sfb[l_ac].sfb01
               AND rvu00 ='2'                  #驗退量
               AND rvv31 = l_sfb[l_ac].sfb05
            IF cl_null(l_rvv17b) THEN LET l_rvv17b = 0 END IF

            LET l_rvb07 =0
           #SELECT rvb07 INTO l_rvb07 FROM rvb_file         #收貨數量      #MOD-D90056 mark
            SELECT SUM(rvb07) INTO l_rvb07 FROM rvb_file    #收貨數量      #MOD-D90056 add
             WHERE rvb34 = l_sfb[l_ac].sfb01
               AND rvb05 = l_sfb[l_ac].sfb05
            IF cl_null(l_rvb07) THEN LET l_rvb07 = 0 END IF            #MOD-D90056 add

            IF (l_rvv17a + l_rvv17b) < l_rvb07 THEN
               LET g_success= 'N'
              #CALL cl_err('','asf005',1)                                 #MOD-D90056 mark
               CALL cl_err('','asf1161',1)                                #MOD-D90056 add
            END IF
         END IF
        #MOD-D50245---add---E
      ELSE
         LET g_chk[l_i].flag = 'N'
      END IF
   END FOR
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM p401_temp
   IF l_cnt > 0 THEN
      CALL s_errmsg('','','','asf-975',1)                             #NO.FUN-710026
      CALL p401_out()
   END IF

END FUNCTION

FUNCTION p401_out()
   DEFINE l_name   LIKE type_file.chr20,
          l_sql        STRING,       #NO.FUN-910082
          sr       RECORD
                    sfb01     LIKE sfb_file.sfb01,
                    type      LIKE type_file.chr1,
                    docno     LIKE sfb_file.sfb01
                   END RECORD

   CALL cl_outnam(g_prog) RETURNING l_name
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang

   # 組合出 SQL 指令
   LET l_sql = "SELECT sfb01,type,docno ",
               "  FROM p401_temp ",
               " ORDER BY sfb01,type"
   PREPARE p401_pre FROM l_sql                     # RUNTIME 編譯
   DECLARE p401_cur CURSOR FOR p401_pre

   START REPORT p401_rep TO l_name

   FOREACH p401_cur INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)    #NO.FUN-710026
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      OUTPUT TO REPORT p401_rep(sr.*)
   END FOREACH

   FINISH REPORT p401_rep

   CLOSE p401_cur
   ERROR ""
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)

END FUNCTION

REPORT p401_rep(sr)
   DEFINE sr       RECORD
                    sfb01     LIKE sfb_file.sfb01,
                    type      LIKE type_file.chr1,
                    docno     LIKE sfb_file.sfb01
                   END RECORD,
          l_trailer_sw        LIKE type_file.chr1

    OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line

    ORDER EXTERNAL BY sr.sfb01

    FORMAT
       PAGE HEADER
          PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
          PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
          PRINT
          LET g_pageno = g_pageno + 1
          LET pageno_total = PAGENO USING '<<<',"/pageno"
          PRINT g_head CLIPPED,pageno_total
          PRINT g_dash
          PRINT g_x[31],g_x[32],g_x[33]
          PRINT g_dash1
          LET l_trailer_sw = 'y'

       ON EVERY ROW
          PRINT COLUMN g_c[31],sr.sfb01;
          CASE sr.type
             WHEN '1' PRINT COLUMN g_c[32],sr.type,":",g_x[10] CLIPPED;
             WHEN '2' PRINT COLUMN g_c[32],sr.type,":",g_x[11] CLIPPED;
             WHEN '3' PRINT COLUMN g_c[32],sr.type,":",g_x[12] CLIPPED;
          END CASE
          PRINT COLUMN g_c[33],sr.docno

       ON LAST ROW
          LET l_trailer_sw = 'n'

       PAGE TRAILER
          PRINT g_dash
          IF l_trailer_sw = 'y' THEN
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
          ELSE
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
          END IF
END REPORT
#No.FUN-9C0072 精簡程式碼

#FUN-9A0095 -- add p401_mes() for MES
FUNCTION p401_mes(p_key1)
  DEFINE p_key1   STRING
  DEFINE l_mesg01 LIKE type_file.chr30

  #CALL aws_mescli
  # 傳入參數: (1)程式代號
  #           (2)功能選項：insert(新增),update(修改),delete(刪除)
  #           (3)Key
  CASE aws_mescli('asfp401','delete',p_key1)
     WHEN 1  #呼叫 MES 成功
          MESSAGE "CLOSE O.K, CLOSE MES O.K"
          LET g_success = 'Y'
     WHEN 2  #呼叫 MES 失敗
          LET g_success = 'N'
     OTHERWISE  #其他異常
          LET g_success = 'N'
  END CASE

END FUNCTION
#FUN-9A0095 -- add end-------------

#add by huicl 2021/7/5 16:31:00 -str-
FUNCTION p401_open_csfr011()
   DEFINE l_buf           LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(80)
          l_cnt           LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
          g_i             LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
          l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
          l_allow_delete  LIKE type_file.num5          #No.FUN-680121 SMALLINT

   DEFINE l_sfe04         LIKE sfe_file.sfe04

   MESSAGE ''

   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE

   LET l_ac = 1
   CALL cl_set_comp_visible("select_all,inverse,compare,cn3",TRUE)     #No.FUN-840245
   INPUT ARRAY l_sfb WITHOUT DEFAULTS FROM s_sfb.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET l_ac = ARR_CURR()


      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION open_csfr011
         CALL cl_cmdrun_wait('csfr011')

      AFTER ROW
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

      AFTER INPUT
         LET l_cnt  = 0
         CALL g_chk.clear()   #FUN-650116 add


      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

   END INPUT

END FUNCTION
#add by huicl 2021/7/5 16:31:10 -end
function p401_mrp_close()
   define l_index,l_cnt integer

   let g_success = 'Y'
   begin work

   for l_index = 1 to l_sfb.getlength()
      if l_sfb[l_index].sure != 'Y' then
         exit for
      end if
      let l_cnt = 0 
      select count(1) into l_cnt from tc_sfaa_file
       where tc_sfaa01 = l_sfb[l_index].sfb01 and tc_sfaa06 = '3'
      if l_cnt > 0 then
         update tc_sfaa_file 
            set tc_sfaa03= g_closeday ,tc_sfaa05 = g_user
          where tc_sfaa01 = l_sfb[l_index].sfb01 and tc_sfaa06 = '3'
      else
         insert into tc_sfaa_file (tc_sfaa01,tc_sfaa03,tc_sfaa05,tc_sfaa06)
          values(l_sfb[l_index].sfb01,g_closeday,g_user,'3')
      end if
      if sqlca.sqlcode then
         call cl_err('ins/upd tc_sfaa',sqlca.sqlcode,1)
         rollback work
         let g_success = 'N'
         exit for
      end if
   end for
   if g_success = 'Y' then
      message 'MRP结案成功。'
      commit work
   else
      rollback work
   end if

end function
