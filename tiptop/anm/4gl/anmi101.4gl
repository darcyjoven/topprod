# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmi101.4gl
# Descriptions...: 支票簿建檔維護
# Date & Author..: 95/09/11 By Danny
# Modify.........: 95/09/13 By Apple 支票位數檢查
#                : By Lynn 單身key完起始,截止票號,show 領用張數
# Modify.........: No.MOD-470459 04/07/20 Kammy 支票已用張數應涵蓋已作廢的
# Modify.........: No.FUN-4B0008 04/11/02 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-570108 05/07/13 By vivien KEY值更改控制
# Modify.........: No.MOD-590109 05/09/08 By kim 按"匯出Excel"無任何作用
# Modify.........: No.MOD-590070 05/09/12 By Smapmin 單身刪除有錯.
#                                                    增加報表列印功能.
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-770038 07/07/13 By Carrier 報表轉Crystal Report格式
# Modify.........: No.MOD-960180 09/06/16 By baofei AFTER INSERT段增加判斷
# Modify.........: No.MOD-970028 09/07/06 By mike 在抓取cnt3(已開票號)時,目前只抓MAX(nmd02),但有可能在anmt110也有維護作廢的支票,故也
#                                                 比較MAX(nmd02)與MAX(nnz02)那個編號較大,cnt3顯示較大的編號                         
#                                                 計算cnt(已用張數)時,應加上nmd_file與nnz_file兩邊的已開張數才對                    
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9C0177 09/12/18 By sabrina 空白支票輸入後，游標往下移，資料會不見 
# Modify.........: No:MOD-A60043 10/08/03 By sabrina 已用張數應該要扣除作廢張數，畫面和報表新增"作廢張數"欄位
# Modify.........: No:TQC-B10264 11/01/27 By yinhy 更改AFTER FIELD nmw04起始票號段查詢語句
# Modify.........: No:MOD-B30592 11/03/18 By lixia 單身刪除前,增加cnt3與cnt4的檢查
# Modify.........: No.MOD-C30412 12/03/12 By wangrr 起始票號nmw04和截止票號nmw05控管
# Modify.........: No:MOD-C90046 12/09/20 By Elise PREPARE i101_prepare2 增加 AND nm
# Modify.........: No:MOD-CB0195 13/01/03 By Polly 調整單身資料抓取簿號條件 
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_nmw           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        nmw01       LIKE nmw_file.nmw01,
        nma03       LIKE nma_file.nma03,
        nmw03       LIKE nmw_file.nmw03,
        nmw06       LIKE nmw_file.nmw06,
        nmw04       LIKE nmw_file.nmw04,
        nmw05       LIKE nmw_file.nmw05,
        cnt2        LIKE type_file.num10,      #No.FUN-680107 INTEGER
        cnt3        LIKE nmw_file.nmw04,
        cnt         LIKE type_file.num10,      #No.FUN-680107 INTEGER
        cnt4        LIKE type_file.num10       #MOD-A60043 add
                    END RECORD,
    g_nmw_t         RECORD                     #程式變數 (舊值)
        nmw01       LIKE nmw_file.nmw01,
        nma03       LIKE nma_file.nma03,
        nmw03       LIKE nmw_file.nmw03,
        nmw06       LIKE nmw_file.nmw06,
        nmw04       LIKE nmw_file.nmw04,
        nmw05       LIKE nmw_file.nmw05,
        cnt2        LIKE type_file.num10,      #No.FUN-680107 INTEGER
        cnt3        LIKE nmw_file.nmw04,
        cnt         LIKE type_file.num10,      #No.FUN-680107 INTEGER
        cnt4        LIKE type_file.num10       #MOD-A60043 add
                    END RECORD,
    g_nna04         LIKE nna_file.nna04,
    g_nna05         LIKE nna_file.nna05,
    g_wc,g_sql      STRING,                    #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,       #單身筆數 #No.FUN-680107 SMALLINT
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT #No.FUN-680107 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680107 INTEGER
DEFINE g_before_input_done LIKE type_file.num5     #FUN-570108 #No.FUN-680107 SMALLINT
DEFINE l_table   STRING  #No.FUN-770038
DEFINE g_str     STRING  #No.FUN-770038
 
 
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0082
DEFINE p_row,p_col  LIKE type_file.num5        #No.FUN-680107 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
   #No.FUN-770038  --Begin
   LET g_sql = " nmw01.nmw_file.nmw01,",
               " nma03.nma_file.nma03,",
               " nmw03.nmw_file.nmw03,",
               " nmw06.nmw_file.nmw06,",
               " nmw04.nmw_file.nmw04,",
               " nmw05.nmw_file.nmw05,",
               " cnt2.type_file.num10,",
               " cnt3.nmw_file.nmw04, ",
               " cnt.type_file.num10, ",
               " cnt4.type_file.num10 "    #MOD-A60043 add
   LET l_table = cl_prt_temptable('anmi101',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ? )  "    #MOD-A60043 add
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-770038  --End
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW i101_w AT p_row,p_col
        WITH FORM "anm/42f/anmi101"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
#    CALL i101_bf(' 1=1')   #MOD-590070
    LET g_wc = '1=1' CALL i101_bf(g_wc)   #MOD-590070
    CALL i101_menu()
    CLOSE WINDOW i101_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
FUNCTION i101_menu()
 
   WHILE TRUE
      CALL i101_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i101_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i101_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#MOD-590070
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i101_out()
            END IF
#END MOD-590070
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nmw),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i101_q()
   CALL i101_b_askkey()
END FUNCTION
 
#單身
FUNCTION i101_b()
DEFINE
    l_nmw           RECORD LIKE nmw_file.*,
    l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT #No.FUN-680107 SMALLINT
    l_n,l_a         LIKE type_file.num5,          #檢查重複用 #No.FUN-680107 SMALLINT
    l_count         LIKE type_file.num5,          #MOD-960180 
    l_cnt           LIKE type_file.num5,          #檢查重複用 #No.FUN-680107 SMALLINT
    l_cmd           LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(30)
    l_sql           LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(300)
    l_lock_sw       LIKE type_file.chr1,          #單身鎖住否 #No.FUN-680107 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,          #處理狀態 #No.FUN-680107 VARCHAR(1)
    l_being,l_end   LIKE type_file.num10,         #No.FUN-680107 INTEGER
    l_point         LIKE type_file.num5,          #No.FUN-680107 SMALLINT
    l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 VARCHAR(1) #可新增否
    l_allow_delete  LIKE type_file.num5           #No.FUN-680107 VARCHAR(1) #可刪除否
DEFINE l_nna03      LIKE nna_file.nna03           #MOD-C30412    
 
    LET g_action_choice = ""
 
    IF s_anmshut(0) THEN RETURN END IF
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT nmw01,'',nmw03,nmw06,nmw04,nmw05,0,'',0 FROM nmw_file WHERE nmw01= ? AND nmw03=? AND nmw06=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_nmw WITHOUT DEFAULTS FROM s_nmw.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
         IF g_rec_b!=0 THEN
          CALL fgl_set_arr_curr(l_ac)
         END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
           #LET g_nmw_t.* = g_nmw[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
            #IF g_nmw_t.nmw01 IS NOT NULL THEN
                LET p_cmd='u'
                LET g_nmw_t.* = g_nmw[l_ac].*  #BACKUP
#No.FUN-570108 --start
                LET g_before_input_done = FALSE
                CALL i101_set_entry(p_cmd)
                CALL i101_set_no_entry(p_cmd)
                LET g_before_input_done = TRUE
#No.FUN-570108 --end
 
                BEGIN WORK
                OPEN i101_bcl USING g_nmw_t.nmw01,g_nmw_t.nmw03,g_nmw_t.nmw06
                IF STATUS THEN
                   CALL cl_err("OPEN i101_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i101_bcl INTO g_nmw[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_nmw_t.nmw01,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      LET g_nmw_t.*=g_nmw[l_ac].*
                   END IF
                END IF
                CALL i101_nmw01(p_cmd)
                CALL i101_nmw06(p_cmd)
                CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
          #NEXT FIELD nmw01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET p_cmd='a'
#No.FUN-570108 --start
            LET g_before_input_done = FALSE
            CALL i101_set_entry(p_cmd)
            CALL i101_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570108 --end
            LET g_nmw_t.* = g_nmw[l_ac].*         #新輸入資料
            INITIALIZE g_nmw[l_ac].* TO NULL      #900423
            CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD nmw01
 
        AFTER INSERT
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
             #CLOSE i101_bcl
             #CALL g_nmw.deleteElement(l_ac)
             #IF g_rec_b != 0 THEN
             #   LET g_action_choice = "detail"
             #   LET l_ac = l_ac_t
             #END IF
             #EXIT INPUT
            END IF
#MOD-960180---begin                                                                                                                 
            LET l_count = 0                                                                                                         
            SELECT COUNT(*) INTO l_count FROM nna_file                                                                              
             WHERE nna01  = g_nmw[l_ac].nmw01                                                                                       
               AND nna021 = g_nmw[l_ac].nmw03                                                                                       
               AND nna02  = g_nmw[l_ac].nmw06                                                                                       
            IF l_count = 0 THEN                                                                                                     
               CALL cl_err('','anm-129',1)                                                                                          
               CANCEL INSERT
            END IF                                                                                                                  
#MOD-960180---end   
            INSERT INTO nmw_file(nmw01,nmw03,nmw04,nmw05,nmw06,nmw07,
                                 nmwacti,nmwuser,nmwgrup,nmwmodu,nmwdate,nmworiu,nmworig)
            VALUES(g_nmw[l_ac].nmw01,g_nmw[l_ac].nmw03,
                   g_nmw[l_ac].nmw04,g_nmw[l_ac].nmw05,
                   g_nmw[l_ac].nmw06,'','Y',g_user,
                   g_grup,'',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nmw[l_ac].nmw01,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("ins","nmw_file",g_nmw[l_ac].nmw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
              #LET g_nmw[l_ac].* = g_nmw_t.*
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE FIELD nmw03
          CALL i101_nmw01(p_cmd)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err('',g_errno,0)
             LET g_nmw[l_ac].nmw01=g_nmw_t.nmw01
             NEXT FIELD nmw01
          END IF
 
        BEFORE FIELD nmw06
          IF cl_null(g_nmw[l_ac].nmw06) OR g_nmw[l_ac].nmw06=0 THEN
             SELECT MAX(nmw06)+1 INTO g_nmw[l_ac].nmw06 FROM nmw_file
              WHERE nmw01 = g_nmw[l_ac].nmw01
                AND nmw03 = g_nmw[l_ac].nmw03
             IF cl_null(g_nmw[l_ac].nmw06) THEN LET g_nmw[l_ac].nmw06=1 END IF
          END IF
 
        AFTER FIELD nmw06
          IF g_nmw[l_ac].nmw06 != g_nmw_t.nmw06 OR
             (NOT cl_null(g_nmw[l_ac].nmw06) AND cl_null(g_nmw_t.nmw06)) THEN
             SELECT COUNT(*) INTO l_cnt FROM nmw_file
              WHERE nmw01 = g_nmw[l_ac].nmw01
                AND nmw03 = g_nmw[l_ac].nmw03
                AND nmw06 = g_nmw[l_ac].nmw06
             IF l_cnt > 0 THEN
                CALL cl_err('',-239,0)
                LET g_nmw[l_ac].nmw06 = g_nmw_t.nmw06
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_nmw[l_ac].nmw06
                #------MOD-5A0095 END------------
                NEXT FIELD nmw06
             END IF
          END IF
 
        BEFORE FIELD nmw04
          CALL i101_nmw06(p_cmd)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err('',g_errno,0)
             LET g_nmw[l_ac].nmw06=g_nmw_t.nmw06
             NEXT FIELD nmw06      
          END IF
 
        AFTER FIELD nmw04
         IF NOT cl_null(g_nmw[l_ac].nmw04) THEN
          #-->檢查支票位數 & 輸入是否正確
          IF LENGTH(g_nmw[l_ac].nmw04 CLIPPED) != g_nna04 THEN
             CALL cl_err(g_nmw[l_ac].nmw04,'anm-039',0)
             LET g_nmw[l_ac].nmw04 = g_nmw_t.nmw04
             NEXT FIELD nmw04
          END IF
          IF p_cmd = 'u' THEN   #已開票號 > 起始票號
             IF NOT cl_null(g_nmw[l_ac].cnt3)
                AND g_nmw[l_ac].cnt3 < g_nmw[l_ac].nmw04
             THEN LET g_nmw[l_ac].nmw04 = g_nmw_t.nmw04
                  NEXT FIELD nmw04
             END IF
             #96-08-30 Modify By Lynn
             LET l_point =(g_nna04 - g_nna05) + 1
             LET l_end   = g_nmw[l_ac].nmw05[l_point,g_nna04]
             LET l_being = g_nmw[l_ac].nmw04[l_point,g_nna04]
             LET g_nmw[l_ac].cnt2 = l_end - l_being + 1
             #------MOD-5A0095 START----------
             DISPLAY BY NAME g_nmw[l_ac].cnt2
             #------MOD-5A0095 END------------
          END IF
 
          LET l_n = g_nna04 - g_nna05
          LET l_cmd= g_nmw[l_ac].nmw04[1,l_n] CLIPPED
          #MOD-C30412--add--str
          IF g_nmw[l_ac].nmw04 != g_nmw_t.nmw04 OR cl_null(g_nmw_t.nmw04) THEN
             SELECT nna03 INTO l_nna03 FROM nna_file
              WHERE nna01 = g_nmw[l_ac].nmw01 
                AND nna021 = g_nmw[l_ac].nmw03
                AND nna02  = g_nmw[l_ac].nmw06        #MOD-CB0195 add                                                                                 
             IF l_nna03[1,l_n] != l_cmd THEN
                CALL cl_err(g_nmw[l_ac].nmw04,'anm-663',0) 
                NEXT FIELD nmw04
             END IF
          END IF
          #MOD-C30412--add--end
          #No.TQC-B10264  --Begin
          #LET l_sql="SELECT * FROM nmw_file ",
          #          " WHERE nmw04 MATCHES '",l_cmd CLIPPED,"*' AND ",
          #          " nmwacti = 'Y'"
          LET l_sql="SELECT nmw_file.* FROM nmw_file ,nna_file",
                    " WHERE nmw01 = nna01 AND nmw03=nna021",
                    " AND nmw01 = ',g_nmw[l_ac].nmw01,'",
                    " AND nmw03 = ',g_nmw[l_ac].nmw03,'",
                    " AND nmw04 MATCHES '",l_cmd CLIPPED,"*' AND ",
                    " nmwacti = 'Y'"
          #No.TQC-B10264  --End
          PREPARE i101_i_p FROM l_sql             # RUNTIME 編譯
          DECLARE i101_i_cs                       # SCROLL CURSOR
                     CURSOR WITH HOLD FOR i101_i_p
          LET l_a = 0
          FOREACH i101_i_cs INTO l_nmw.*
            IF STATUS THEN  EXIT FOREACH   END IF
            IF l_nmw.nmw01=g_nmw[l_ac].nmw01 AND l_nmw.nmw03=g_nmw[l_ac].nmw03
            THEN CONTINUE FOREACH END IF
            IF NOT cl_null(l_nmw.nmw04) AND NOT cl_null(l_nmw.nmw05) THEN
               IF g_nmw[l_ac].nmw04 >= l_nmw.nmw04 AND
                  g_nmw[l_ac].nmw04 <= l_nmw.nmw05 THEN
                  LET l_a = l_a + 1
               END IF
            END IF
          END FOREACH
          IF l_a > 0  THEN    #票號已存在
             CALL cl_err('','anm-109',0)
             NEXT FIELD nmw04
          END IF
         END IF
 
        AFTER FIELD nmw05
         IF NOT cl_null(g_nmw[l_ac].nmw05) THEN
          IF LENGTH(g_nmw[l_ac].nmw05 CLIPPED) != g_nna04 THEN
             CALL cl_err(g_nmw[l_ac].nmw05,'anm-039',0)
             NEXT FIELD nmw05
          END IF
          IF g_nmw[l_ac].nmw05 < g_nmw[l_ac].nmw04
          THEN LET g_nmw[l_ac].nmw05 = g_nmw_t.nmw05
          #------MOD-5A0095 START----------
          DISPLAY BY NAME g_nmw[l_ac].nmw05
          #------MOD-5A0095 END------------
               NEXT FIELD nmw04
          END IF
          IF p_cmd = 'u' THEN
             IF g_nmw[l_ac].cnt3 > g_nmw[l_ac].nmw05
             THEN LET g_nmw[l_ac].nmw05 = g_nmw_t.nmw05
             #------MOD-5A0095 START----------
             DISPLAY BY NAME g_nmw[l_ac].nmw05
             #------MOD-5A0095 END------------
                  NEXT FIELD nmw05
             END IF
          END IF
          #96-08-30 Modify By Lynn
          LET l_point =(g_nna04 - g_nna05) + 1
          LET l_end   = g_nmw[l_ac].nmw05[l_point,g_nna04]
          LET l_being = g_nmw[l_ac].nmw04[l_point,g_nna04]
          LET g_nmw[l_ac].cnt2 = l_end - l_being + 1
          #------MOD-5A0095 START----------
          DISPLAY BY NAME g_nmw[l_ac].cnt2
          #------MOD-5A0095 END------------
 
          LET l_n = g_nna04 - g_nna05
          LET l_cmd= g_nmw[l_ac].nmw05[1,l_n] CLIPPED
          #MOD-C30412--add--str
          IF g_nmw[l_ac].nmw05 != g_nmw_t.nmw05 OR cl_null(g_nmw_t.nmw05) THEN
             SELECT nna03 INTO l_nna03 FROM nna_file 
              WHERE nna01 = g_nmw[l_ac].nmw01 
                AND nna021 = g_nmw[l_ac].nmw03
                AND nna02 = g_nmw[l_ac].nmw06          #MOD-CB0195 add
             IF l_nna03[1,l_n] != l_cmd THEN
                CALL cl_err(g_nmw[l_ac].nmw05,'anm-663',0)
                NEXT FIELD nmw05
             END IF
          END IF
          #MOD-C30412--add--end
          LET l_sql="SELECT * FROM nmw_file ",
                    " WHERE nmw05 MATCHES '",l_cmd CLIPPED,"*' AND ",
                    " nmwacti = 'Y'"
          PREPARE i101_i2_p FROM l_sql             # RUNTIME 編譯
          DECLARE i101_i2_cs                       # SCROLL CURSOR
                     CURSOR WITH HOLD FOR i101_i2_p
          LET l_a = 0
          FOREACH i101_i2_cs INTO l_nmw.*
            IF STATUS THEN  EXIT FOREACH   END IF
            IF l_nmw.nmw01=g_nmw[l_ac].nmw01 AND l_nmw.nmw03=g_nmw[l_ac].nmw03
            THEN CONTINUE FOREACH END IF
            IF NOT cl_null(l_nmw.nmw04) AND NOT cl_null(l_nmw.nmw05) THEN
               IF g_nmw[l_ac].nmw05 >= l_nmw.nmw04 AND
                  g_nmw[l_ac].nmw05 <= l_nmw.nmw05
               THEN
                  LET l_a = l_a + 1
               END IF
            END IF
          END FOREACH
          IF l_a > 0  THEN    #票號已存在
             CALL cl_err('','anm-109',0)
             NEXT FIELD nmw04
          END IF
         END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_nmw_t.nmw01 IS NOT NULL THEN
                #MOD-B30592--add--str--
                IF g_nmw[l_ac].cnt3 != ' ' OR g_nmw[l_ac].cnt > 0
                   OR g_nmw[l_ac].cnt4 > 0 THEN
                   CALL cl_err("",'anm1018', 1)
                   CANCEL DELETE
                END IF
                #MOD-B30592--add--end--
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM nmw_file
                 WHERE nmw01 = g_nmw_t.nmw01
                   AND nmw03 = g_nmw_t.nmw03
                   AND nmw06 = g_nmw_t.nmw06
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_nmw_t.nmw01,SQLCA.sqlcode,0)   #No.FUN-660148
                   CALL cl_err3("del","nmw_file",g_nmw_t.nmw01,g_nmw_t.nmw03,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE i101_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
          IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_nmw[l_ac].* = g_nmw_t.*
              CLOSE i101_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_nmw[l_ac].nmw01,-263,1)
             LET g_nmw[l_ac].* = g_nmw_t.*
          ELSE
             UPDATE nmw_file SET nmw01=g_nmw[l_ac].nmw01,
                                 nmw03=g_nmw[l_ac].nmw03,
                                 nmw04=g_nmw[l_ac].nmw04,
                                 nmw05=g_nmw[l_ac].nmw05,
                                 nmw06=g_nmw[l_ac].nmw06,
                                 nmwmodu=g_user,
                                 nmwdate=g_today
              WHERE nmw01 = g_nmw_t.nmw01
                AND nmw03 = g_nmw_t.nmw03
                AND nmw06 = g_nmw_t.nmw06
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_nmw[l_ac].nmw01,SQLCA.sqlcode,0)   #No.FUN-660148
                CALL cl_err3("upd","nmw_file",g_nmw_t.nmw01,g_nmw_t.nmw03,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                LET g_nmw[l_ac].* = g_nmw_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i101_bcl
             END IF
          END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_nmw[l_ac].* = g_nmw_t.*
              #FUN-D30032--add--str--
              ELSE
                 CALL g_nmw.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30032--add--end-- 
              END IF
              CALL i101_nmw06(p_cmd)
              EXIT INPUT
           END IF
                IF g_nmw[l_ac].nmw05 < g_nmw[l_ac].nmw04
                THEN INITIALIZE g_nmw[l_ac].* TO NULL
                END IF
                IF NOT cl_null(g_nmw[l_ac].cnt3) THEN             #MOD-9C0177 add
                   IF g_nmw[l_ac].cnt3 < g_nmw[l_ac].nmw04 THEN
                      INITIALIZE g_nmw[l_ac].* TO NULL
                   END IF
                END IF                                            #MOD-9C0177 add
                IF g_nmw[l_ac].cnt3 > g_nmw[l_ac].nmw05
                THEN INITIALIZE g_nmw[l_ac].* TO NULL
                END IF
          #LET g_nmw_t.* = g_nmw[l_ac].*          # 900423
           LET l_ac_t = l_ac
           CLOSE i101_bcl
           COMMIT WORK
           CALL g_nmw.deleteElement(g_rec_b+1)    #MOD-590070
 
        ON ACTION CONTROLN
            CALL i101_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION controlp
            CASE WHEN INFIELD(nmw01)
#             CALL q_nma(0,0,g_nmw[l_ac].nmw01) RETURNING g_nmw[l_ac].nmw01
#             CALL FGL_DIALOG_SETBUFFER( g_nmw[l_ac].nmw01 )
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_nma"
              LET g_qryparam.default1 = g_nmw[l_ac].nmw01
              CALL cl_create_qry() RETURNING g_nmw[l_ac].nmw01
#             CALL FGL_DIALOG_SETBUFFER( g_nmw[l_ac].nmw01 )
              DISPLAY g_nmw[l_ac].nmw01 TO nmw01
              CALL i101_nmw01('d')
            END CASE
 
        ON ACTION CONTROLO  # 沿用所有欄位
            IF INFIELD(nmw01) THEN
               IF l_ac > 1  THEN
                  LET g_nmw[l_ac].nmw01 = g_nmw[l_ac-1].nmw01
               END IF
            END IF
 
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
 
 
        END INPUT
 
    CLOSE i101_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION  i101_nmw01(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
    l_being,l_end   LIKE type_file.num10,   #No.FUN-680107 INTEGER
    l_point         LIKE type_file.num5,    #No.FUN-680107 SMALLINT
    l_nmaacti       LIKE nma_file.nmaacti
 
    LET g_errno = ' '
    SELECT nma03,nmaacti
      INTO g_nmw[l_ac].nma03,l_nmaacti
      FROM nma_file WHERE nma01 = g_nmw[l_ac].nmw01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-013'
                                   LET g_nmw[l_ac].nma03 = NULL
         WHEN l_nmaacti='N' LET g_errno = '9028'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    IF p_cmd ='d' OR cl_null(g_errno) OR p_cmd = 'u' THEN
    END IF
END FUNCTION
 
FUNCTION  i101_nmw06(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
    l_being,l_end   LIKE type_file.num10,         #No.FUN-680107 INTEGER
    l_point         LIKE type_file.num5,          #No.FUN-680107 SMALLINT
    l_nna03         LIKE nna_file.nna03,
    l_nmaacti       LIKE nma_file.nmaacti
#MOD-970028    ---start                                                                                                             
DEFINE l_count1     LIKE nmd_file.nmd02,                                                                                            
       l_count2     LIKE type_file.num10,                                                                                           
       l_count3     LIKE nnz_file.nnz02,                                                                                            
       l_count4     LIKE type_file.num10                                                                                            
#MOD-970028   ---end     
    LET g_errno = ' '
    SELECT nna03,nna04,nna05 INTO l_nna03,g_nna04,g_nna05
      FROM nna_file,nma_file
     WHERE nna01 = g_nmw[l_ac].nmw01
       AND nna02 = g_nmw[l_ac].nmw06
       AND nna021= g_nmw[l_ac].nmw03   #BUGNO:6958
       AND nna01 = nma01 AND nmaacti = 'Y'
    CASE WHEN STATUS = 100 LET g_errno ='anm-954'
         WHEN g_nna04 is null or g_nna04 = ' ' or g_nna04 <= 0
              LET g_errno = 'anm-238'
         WHEN g_nna05 is null or g_nna05 = ' ' or g_nna05 <= 0
              LET g_errno = 'anm-239'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    IF p_cmd = 'd' or p_cmd = 'u' THEN
       LET l_point =(g_nna04 - g_nna05) + 1
       LET l_end   = g_nmw[l_ac].nmw05[l_point,g_nna04]
       LET l_being = g_nmw[l_ac].nmw04[l_point,g_nna04]
       LET g_nmw[l_ac].cnt2 = l_end - l_being + 1
#MOD-970028   ---start   
      #SELECT MAX(nmd02),COUNT(*)
      #  INTO g_nmw[l_ac].cnt3,g_nmw[l_ac].cnt FROM nmd_file
      # WHERE nmd03 = g_nmw[l_ac].nmw01
      #   AND nmd31 = g_nmw[l_ac].nmw06
      #   AND nmd02 BETWEEN g_nmw[l_ac].nmw04 AND g_nmw[l_ac].nmw05
       SELECT MAX(nmd02),COUNT(*)                                                                                                   
         INTO l_count1,l_count2 FROM nmd_file                                                                                       
        WHERE nmd03 = g_nmw[l_ac].nmw01                                                                                             
          AND nmd31 = g_nmw[l_ac].nmw06                                                                                             
          AND nmd02 BETWEEN g_nmw[l_ac].nmw04 AND g_nmw[l_ac].nmw05                                                                 
       SELECT MAX(nnz02),COUNT(*)                                                                                                   
         INTO l_count3,l_count4 FROM nnz_file                                                                                       
        WHERE nnz01 = g_nmw[l_ac].nmw01                                                                                             
          AND nnz02 BETWEEN g_nmw[l_ac].nmw04 AND g_nmw[l_ac].nmw05                                                                 
       IF cl_null(l_count1) THEN LET l_count1=' ' END IF                                                                            
       IF cl_null(l_count3) THEN LET l_count3=' ' END IF                                                                            
       IF l_count1>=l_count3 THEN                                                                                                   
          LET g_nmw[l_ac].cnt3 = l_count1                                                                                           
       ELSE                                                                                                                         
          LET g_nmw[l_ac].cnt3 = l_count3                                                                                           
       END IF                                                                                                                       
      #MOD-A60043---modify---start---
      #LET g_nmw[l_ac].cnt = l_count2+l_count4     
       LET g_nmw[l_ac].cnt = l_count2
       LET g_nmw[l_ac].cnt4 = l_count4
      #MOD-A60043---modify---end---     
#MOD-970028    ---end                  
       #  AND nmd30 <> 'X' #No.MOD-470459
    END IF
    IF p_cmd = 'a' AND g_nmw[l_ac].nmw04 IS NULL THEN
       LET g_nmw[l_ac].nmw04 = l_nna03
    END IF
    IF p_cmd ='d' OR cl_null(g_errno) OR p_cmd = 'u' THEN
    END IF
END FUNCTION
 
FUNCTION i101_b_askkey()
#DEFINE  l_wc    LIKE type_file.chr1000   #MOD-590070  #No.FUN-680107 VARCHAR(200)
 
    CLEAR FORM
   CALL g_nmw.clear()
#    CONSTRUCT l_wc ON nmw01,nmw03,nmw06,nmw04,nmw05   #MOD-590070
    CONSTRUCT g_wc ON nmw01,nmw03,nmw06,nmw04,nmw05   #MOD-590070
                 FROM s_nmw[1].nmw01,s_nmw[1].nmw03,
                      s_nmw[1].nmw06,s_nmw[1].nmw04,
                      s_nmw[1].nmw05
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
            CASE WHEN INFIELD(nmw01)
#             CALL q_nma(0,0,g_nmw[1].nmw01) RETURNING g_nmw[1].nmw01
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_nma"
              LET g_qryparam.state = "c"
              LET g_qryparam.default1 = g_nmw[1].nmw01
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO s_nmw[1].nmw01
              NEXT FIELD nmw01
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
#        LET l_wc = l_wc clipped," AND nmwuser = '",g_user,"'"   #MOD-590070
    #        LET g_wc = g_wc clipped," AND nmwuser = '",g_user,"'"   #MOD-590070
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
#        LET l_wc = l_wc clipped," AND nmwgrup MATCHES '",g_grup CLIPPED,"*'"   #MOD-590070
    #        LET g_wc = g_wc clipped," AND nmwgrup MATCHES '",g_grup CLIPPED,"*'"   #MOD-590070
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
#        LET l_wc = l_wc clipped," AND nmwgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmwuser', 'nmwgrup')
    #End:FUN-980030
 
#    CALL i101_bf(l_wc)   #MOD-590070
    CALL i101_bf(g_wc)   #MOD-590070
END FUNCTION
 
FUNCTION i101_bf(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(200)
    l_point         LIKE type_file.num10,         #No.FUN-680107 INTEGER
    l_end,l_being   LIKE type_file.num10,         #No.FUN-680107 INTEGER
    l_nna04         LIKE nna_file.nna04, 
    l_nna05         LIKE nna_file.nna05
#MOD-970028    ---start                                                                                                             
DEFINE l_count1     LIKE nmd_file.nmd02,                                                                                            
       l_count2     LIKE type_file.num10,                                                                                           
       l_count3     LIKE nnz_file.nnz02,                                                                                            
       l_count4     LIKE type_file.num10                                                                                            
#MOD-970028   ---end        
    LET g_sql =
      #"SELECT nmw01,nma03,nmw03,nmw06,nmw04,nmw05,0,'',0,nna04,nna05 ",     #MOD-A60043 mark
       "SELECT nmw01,nma03,nmw03,nmw06,nmw04,nmw05,0,'',0,0,nna04,nna05 ",   #MOD-A60043 add
       "  FROM nmw_file,nna_file,nma_file",
       " WHERE ",p_wc CLIPPED ,
       "   AND nna01 = nmw01 ",
       "   AND nna021= nmw03 ",   #BUGNO:6958
       "   AND nna02 = nmw06 ",
       "   AND nna01 = nma01 ",
       "   AND nmaacti = 'Y' ",   #MOD-C90046 add
       " ORDER BY nmw01,nmw03,nmw06 "
    PREPARE i101_prepare2 FROM g_sql      #預備一下
    DECLARE nmw_cs CURSOR FOR i101_prepare2
    CALL g_nmw.clear()
    LET g_cnt = 1
    FOREACH nmw_cs INTO g_nmw[g_cnt].*,l_nna04,l_nna05   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#MOD-970028    ---start     
       #SELECT MAX(nmd02),COUNT(*)
       #  INTO g_nmw[g_cnt].cnt3,g_nmw[g_cnt].cnt FROM nmd_file
       # WHERE nmd03 = g_nmw[g_cnt].nmw01
       #   AND nmd31 = g_nmw[g_cnt].nmw06
       #   AND nmd02 BETWEEN g_nmw[g_cnt].nmw04 AND g_nmw[g_cnt].nmw05
       #   AND nmd30 <> 'X'
        SELECT MAX(nmd02),COUNT(*)                                                                                                  
          INTO l_count1,l_count2 FROM nmd_file                                                                                      
         WHERE nmd03 = g_nmw[g_cnt].nmw01                                                                                           
           AND nmd31 = g_nmw[g_cnt].nmw06                                                                                           
           AND nmd02 BETWEEN g_nmw[g_cnt].nmw04 AND g_nmw[g_cnt].nmw05                                                              
        SELECT MAX(nnz02),COUNT(*)                                                                                                  
          INTO l_count3,l_count4 FROM nnz_file                                                                                      
         WHERE nnz01 = g_nmw[g_cnt].nmw01                                                                                           
           AND nnz02 BETWEEN g_nmw[g_cnt].nmw04 AND g_nmw[g_cnt].nmw05                                                              
        IF cl_null(l_count1) THEN LET l_count1=' ' END IF                                                                           
        IF cl_null(l_count3) THEN LET l_count3=' ' END IF                                                                           
        IF l_count1>=l_count3 THEN                                                                                                  
           LET g_nmw[g_cnt].cnt3 = l_count1                                                                                         
        ELSE                                                                                                                        
           LET g_nmw[g_cnt].cnt3 = l_count3                                                                                         
        END IF                                                                                                                      
       #MOD-A60043---modify---start---                                                                                                        
       #LET g_nmw[g_cnt].cnt = l_count2+l_count4                                                                                      
        LET g_nmw[g_cnt].cnt = l_count2
        LET g_nmw[g_cnt].cnt4 = l_count4
       #MOD-A60043---modify---end---                                                                                      
#MOD-970028    ---end            
        LET l_point = l_nna04 - l_nna05 + 1
        LET l_end   = g_nmw[g_cnt].nmw05[l_point,l_nna04]
        LET l_being = g_nmw[g_cnt].nmw04[l_point,l_nna04]
        LET g_nmw[g_cnt].cnt2 = (l_end - l_being) + 1
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_nmw.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nmw TO s_nmw.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
#MOD-590070
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
#END MOD-590070
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
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
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY  #MOD-590109
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#MOD-590070
FUNCTION i101_out()
    DEFINE
        l_nmw           RECORD LIKE nmw_file.*,
        l_name          LIKE type_file.chr20,   # External(Disk) file name #No.FUN-680107 VARCHAR(20)
        l_nma03         LIKE nma_file.nma03,
        l_nna04         LIKE nna_file.nna04,
        l_nna05         LIKE nna_file.nna05
    #No.FUN-770038  --Begin
    DEFINE
        l_being,l_end   LIKE type_file.num10,
        l_point         LIKE type_file.num5,
        l_cnt,l_cnt2    LIKE type_file.num10,
        l_cnt4          LIKE type_file.num10,            #MOD-A60043 add
        l_cnt3          LIKE nmw_file.nmw04
    #No.FUN-770038  --End  
#MOD-970028    ---start                                                                                                          
    DEFINE l_count1     LIKE nmd_file.nmd02,                                                                                        
           l_count2     LIKE type_file.num10,                                                                                       
           l_count3     LIKE nnz_file.nnz02,                                                                                        
           l_count4     LIKE type_file.num10                                                                                        
#MOD-970028   ---end       
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    #No.FUN-770038  --Begin
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    #CALL cl_outnam('anmi101') RETURNING l_name
    #No.FUN-770038  --End
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT nmw_file.*,nma03,nna04,nna05 ",
              "  FROM nmw_file,nna_file,nma_file",
              " WHERE ",g_wc CLIPPED ,
              "   AND nna01 = nmw01 ",
              "   AND nna021= nmw03 ",
              "   AND nna02 = nmw06 ",
              "   AND nna01 = nma01 ",
              " ORDER BY nmw01,nmw03,nmw06 "
    PREPARE i101_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i101_co CURSOR FOR i101_p1
 
    #START REPORT i101_rep TO l_name  #No.FUN-770038
 
    FOREACH i101_co INTO l_nmw.*,l_nma03,l_nna04,l_nna05
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
        #No.FUN-770038  --Begin
        LET l_point =(l_nna04 - l_nna05) + 1
        LET l_end   = l_nmw.nmw05[l_point,l_nna04]
        LET l_being = l_nmw.nmw04[l_point,l_nna04]
        LET l_cnt2 = l_end - l_being + 1
#MOD-970028   ---start     
       #SELECT MAX(nmd02),COUNT(*)
       #  INTO l_cnt3,l_cnt FROM nmd_file
       # WHERE nmd03 = l_nmw.nmw01
       #   AND nmd31 = l_nmw.nmw06
       #   AND nmd02 BETWEEN l_nmw.nmw04 AND l_nmw.nmw05
        SELECT MAX(nmd02),COUNT(*)                                                                                                  
          INTO l_count1,l_count2 FROM nmd_file                                                                                      
         WHERE nmd03 = l_nmw.nmw01                                                                                                  
           AND nmd31 = l_nmw.nmw06                                                                                                  
           AND nmd02 BETWEEN l_nmw.nmw04 AND l_nmw.nmw05                                                                            
        SELECT MAX(nnz02),COUNT(*)                                                                                                  
          INTO l_count3,l_count4 FROM nnz_file                                                                                      
         WHERE nnz01 = l_nmw.nmw01                                                                                                  
           AND nnz02 BETWEEN l_nmw.nmw04 AND l_nmw.nmw05                                                                            
        IF cl_null(l_count1) THEN LET l_count1=' ' END IF                                                                           
        IF cl_null(l_count3) THEN LET l_count3=' ' END IF                                                                           
        IF l_count1>=l_count3 THEN                                                                                                  
           LET l_cnt3 = l_count1                                                                                                    
        ELSE                                                                                                                        
           LET l_cnt3 = l_count3                                                                                                    
        END IF                                                                                                                      
       #MOD-A60043---modify---start---
       #LET l_cnt = l_count2+l_count4                                                                                    
        LET l_cnt = l_count2
        LET l_cnt4 = l_count4         
       #MOD-A60043---modify---end---                                                                           
#MOD-970028    ---end                   
        #OUTPUT TO REPORT i101_rep(l_nmw.*,l_nma03,l_nna04,l_nna05)
        EXECUTE insert_prep USING
                l_nmw.nmw01,l_nma03,l_nmw.nmw03,l_nmw.nmw06,l_nmw.nmw04,
                l_nmw.nmw05,l_cnt2,l_cnt3,l_cnt,l_cnt4        #MOD-A60043 add l_cnt4
        #No.FUN-770038  --End  
    END FOREACH
 
    #No.FUN-770038  --Begin
    #FINISH REPORT i101_rep
 
    #CLOSE i101_co
    #ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)
 
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_str = ''
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'nmw01,nmw03,nmw06')
            RETURNING g_str
    END IF
    CALL cl_prt_cs3('anmi101','anmi101',g_sql,g_str)
   #No.FUN-770038  --End
END FUNCTION
 
#No.FUN-770038  --Begin
#REPORT i101_rep(sr,l_nma03,l_nna04,l_nna05)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
#        sr              RECORD LIKE nmw_file.*,
#        l_nma03         LIKE nma_file.nma03,
#        l_nna04         LIKE nna_file.nna04,
#        l_nna05         LIKE nna_file.nna05,
#        l_being,l_end   LIKE type_file.num10,        #No.FUN-680107 INTEGER
#        l_point         LIKE type_file.num5,         #No.FUN-680107 SMALLINT
#        l_cnt,l_cnt2    LIKE type_file.num10,        #No.FUN-680107 INTEGER
#        l_cnt3          LIKE nmw_file.nmw04
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.nmw01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#                  g_x[38],g_x[39]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#        ON EVERY ROW
#           LET l_point =(l_nna04 - l_nna05) + 1
#           LET l_end   = sr.nmw05[l_point,l_nna04]
#           LET l_being = sr.nmw04[l_point,l_nna04]
#           LET l_cnt2 = l_end - l_being + 1
#           SELECT MAX(nmd02),COUNT(*)
#             INTO l_cnt3,l_cnt FROM nmd_file
#            WHERE nmd03 = sr.nmw01
#              AND nmd31 = sr.nmw06
#              AND nmd02 BETWEEN sr.nmw04 AND sr.nmw05
#
#            PRINT COLUMN g_c[31],sr.nmw01,
#                  COLUMN g_c[32],l_nma03,
#                  COLUMN g_c[33],sr.nmw03,
#                  COLUMN g_c[34],sr.nmw06,
#                  COLUMN g_c[35],sr.nmw04,
#                  COLUMN g_c[36],sr.nmw05,
#                  COLUMN g_c[37],l_cnt2,
#                  COLUMN g_c[38],l_cnt3,
#                  COLUMN g_c[39],l_cnt
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-770038  --End  
 
#END MOD-590070
 
#No.FUN-570108 --start
FUNCTION i101_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd='a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("nmw01,nmw03,nmw06",TRUE)
   END IF
END FUNCTION
 
FUNCTION i101_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd='u' AND  ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("nmw01,nmw03,nmw06",FALSE)
   END IF
END FUNCTION
#No.FUN-570108 --end
#Patch....NO.MOD-5A0095 <003,001,002,004,005> #
