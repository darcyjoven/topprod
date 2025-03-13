# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aoou013.4gl
# Descriptions...: 採購簽核
# Date & Author..: 91/04/22 By Lee
# Modify.........: 92/09/24 By Pin
#                  簽核處理修正(順序以簽核剩餘天數,簽核完成天數來排)
#                  因劃面編幅有限,無法顯示剩餘天數與簽核完成天數
# Modify.........: 99/04/15 By Carol SQL加pmm18='Y' 
# Modify.........: No.MOD-480488 04/09/16 Melody 權限應在主程式 apmu010判斷就好
# Modify.........: No.MOD-4B0058 04/12/06 By Echo  aoos010設定不使用 EasyFlow 但單據設定需簽核(使用tiptop簡易簽核)
# Modify.........: No.FUN-550058 05/05/28 By vivien 單據編號格式放大  
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
     DEFINE
        g_pass          LIKE azd_file.azd03,           #No.FUN-680102CHAR(08),
        g_cnt           LIKE type_file.num10,          #No.FUN-680102 INTEGER
        g_msg           LIKE type_file.chr1000,        #No.FUN-680102CHAR(72),
        g_chr           LIKE type_file.chr1            #No.FUN-680102 VARCHAR(1)
END GLOBALS
 
DEFINE g_pmm RECORD LIKE pmm_file.*
 
FUNCTION u013()
 
    WHENEVER ERROR CONTINUE
 
#   IF NOT cl_prich2('aoou013','') THEN
 #No.MOD-480488
#   IF NOT cl_chk_act_auth() THEN
#        RETURN
#   END IF
    CALL u013_1()                      #接受選擇
END FUNCTION
 
#將資料選出, 並進行挑選
FUNCTION u013_1()
DEFINE
# genero  script marked     l_arrno      SMALLINT,                  #program array no
    l_ac         LIKE type_file.num5,                    #program array no        #No.FUN-680102 SMALLINT
    l_ok         LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01),                #判斷是否取得資料
    l_exit       LIKE type_file.chr1,           #No.FUN-680102CHAR(01),
    l_sl         LIKE type_file.num5,           #No.FUN-680102 SMALLINT,                 #screen array no
    l_sl2        LIKE type_file.num5,           #No.FUN-680102 SMALLINT,             #screen array no
    l_cnt        LIKE type_file.num5,                    #所選擇筆數        #No.FUN-680102 SMALLINT
    l_cnt1       LIKE type_file.num5,                    #所選擇筆數        #No.FUN-680102 SMALLINT
    l_wc         LIKE type_file.chr1000,         #No.FUN-680102CHAR(1000),
    l_sql        LIKE type_file.chr1000,         #RDSQL STATEMENT        #No.FUN-680102CHAR(1000)
    l_days,l_prit LIKE type_file.num5,           #No.FUN-680102SMALLINT,
    l_pmm03 ARRAY[48] OF LIKE type_file.chr2,    # Prog. Version..: '5.30.06-13.03.12(02), #更動序號
    l_needs ARRAY[48] OF LIKE type_file.chr1,    #No.FUN-680102CHAR(01),
    l_pmm DYNAMIC ARRAY OF RECORD                #結果
        choice      LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01),             #選擇碼
        pmm01       LIKE azd_file.azd01,    #No.FUN-680102  VARCHAR(16),            #報價單號   #No.FUN-550058
        pmm02       LIKE pmm_file.pmm02,    #報價日期
        pmm04       LIKE pmm_file.pmm04,    #有效日期
        pmc03       LIKE pmc_file.pmc03,    #帳款客戶
        pmm22       LIKE pmm_file.pmm22,    #總金額
        pmmsign     LIKE pmm_file.pmmsign,  #簽核等級
        pmmdays     LIKE pmm_file.pmmdays,
        pmmprit     LIKE pmm_file.pmmprit
              END RECORD
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE g_i             LIKE type_file.num5,                #可新增否        #No.FUN-680102 SMALLINT
       l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680102 SMALLINT
        l_allow_delete LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
 
    LET p_row = 3 LET p_col = 20
    #開窗讓使用者選擇
    OPEN WINDOW u013_w AT p_row,p_col WITH FORM "aoo/42f/aoou013" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_locale("aoou013")
    CALL cl_set_comp_visible("select_all,cancel_all,cmt",FALSE)
    WHILE TRUE
        IF s_shut(0) THEN EXIT WHILE END IF
        LET l_exit='Y'
        CALL cl_getmsg('aoo-051',g_lang) RETURNING g_msg
        DISPLAY g_msg AT 1,1          #顯示操作指引
        CALL cl_getmsg('aoo-052',g_lang) RETURNING g_msg
        DISPLAY g_msg AT 2,1          #顯示操作指引
        CLEAR FORM
        CONSTRUCT l_wc ON pmm01,pmm02,pmm04,pmc03,pmm22,
                 pmmsign,pmmdays,pmmprit
            FROM s_pmm[1].pmm01,s_pmm[1].pmm02,s_pmm[1].pmm04,
                 s_pmm[1].pmc03,s_pmm[1].pmm22,s_pmm[1].pmmsign,
                 s_pmm[1].pmmdays,s_pmm[1].pmmprit  
 
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
  LET l_wc = l_wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup') #FUN-980030
 
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            EXIT WHILE
        END IF
        LET l_sql = "SELECT ",                      #組合查詢句子
            "'N',pmm01,pmm02,pmm04,pmc03,",
#---->modify by pin ----->(pmm04+pmmdays)-to_date(?)?
            "pmm22,pmmsign,pmmdays,pmmprit",
            " FROM pmm_file LEFT OUTER JOIN pmc_file ON  pmm09 = pmc_file.pmc01",
            " WHERE pmmsign IS NOT NULL AND",
            " pmmmksg='Y' AND",
            " pmm18='Y' AND",
            
            " pmm25='S' AND pmmacti='Y'",
            " AND ",l_wc CLIPPED,
            #去選擇單據時, 加這一句條件, 可以得到該使用者該簽核而未簽核的單據
            " AND pmmsseq=(SELECT (azc02-1)",
            " FROM azc_file WHERE azc01=pmmsign AND azc03=",
            "'",g_pass,"'"," )",
            " ORDER BY 8,9 "
 
        PREPARE u013_prepare FROM l_sql      #預備之
        IF SQLCA.sqlcode THEN                          #有問題了
            CALL cl_err('PREPARE:',SQLCA.sqlcode,1)
            EXIT WHILE
        END IF
        DECLARE u013_cs CURSOR FOR u013_prepare     #宣告之
 
        CALL l_pmm.clear()
#       FOR g_cnt=1 TO l.getLength()
#           INITIALIZE l_pmm[g_cnt].* TO NULL
#       END FOR
        LET g_cnt=1                                         #總選取筆數
        FOREACH u013_cs # USING g_today
            INTO l_pmm[g_cnt].* # ,l_pmm03[g_cnt],l_needs[g_cnt],l_days,l_prit
            LET l_pmm[g_cnt].pmmdays = l_pmm[g_cnt].pmm04 - g_today + l_pmm[g_cnt].pmmdays
            IF SQLCA.sqlcode THEN                                  #有問題
                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                EXIT FOREACH
            END IF
         #  ERROR 'l_days,l_prit,l_pmm[g_cnt].pmm01',l_days,l_prit,
         #         ' ',l_pmm[g_cnt].pmm01 sleep 3 
 #取得廠商簡稱
            SELECT pmc03 INTO l_pmm[g_cnt].pmc03
                FROM pmc_file
                WHERE pmc01=l_pmm[g_cnt].pmc03
            IF SQLCA.sqlcode THEN
                LET l_pmm[g_cnt].pmc03=''
            END IF
#取得是否需要閱後方可簽核
            SELECT aze07 INTO l_needs[g_cnt]
                FROM aze_file
                WHERE aze01=l_pmm[g_cnt].pmmsign
            IF SQLCA.sqlcode THEN
                LET l_needs[g_cnt]=''
            END IF
            IF NOT cl_null(l_pmm03[g_cnt]) THEN
               LET l_pmm[g_cnt].pmm01=l_pmm[g_cnt].pmm01 CLIPPED,
                '-',l_pmm03[g_cnt] CLIPPED
            END IF
            LET g_cnt = g_cnt + 1                           #累加筆數
            IF g_cnt > g_max_rec THEN                       #超過肚量了
                EXIT FOREACH
            END IF
        END FOREACH
        IF g_cnt=1 THEN                                     #沒有抓到
            CALL cl_err('','aoo-004',1)                     #顯示錯誤, 並回去
            CONTINUE WHILE
        END IF
        CALL l_pmm.deleteElement(g_cnt)
        LET g_cnt=g_cnt-1                                   #正確的總筆數
        CALL SET_COUNT(g_cnt)                               #告之DISPALY ARRAY
       IF g_cnt > g_max_rec THEN           #ARRAY太大時,必須顯示一個訊息
          CALL cl_err('','9035',0)
       END IF
        CALL cl_getmsg('aoo-050',g_lang) RETURNING g_msg
        DISPLAY "" AT 1,1             #清除不要的資訊
        DISPLAY g_msg AT 2,1          #顯示操作指引
        DISPLAY g_cnt TO FORMONLY.cnt  #顯示總筆數
        LET l_cnt=0                                     #已選筆數
       
        CALL cl_set_comp_visible("select_all,cancel_all,cmt",TRUE)
 
       DISPLAY l_cnt TO FORMONLY.cmt
       LET l_allow_insert = FALSE
       LET l_allow_delete = FALSE
 
       LET l_ac = 1
       INPUT ARRAY l_pmm WITHOUT DEFAULTS FROM s_pmm.*
           ATTRIBUTE(COUNT=g_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
            INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
          BEFORE INPUT
              IF g_cnt != 0 THEN
                CALL fgl_set_arr_curr(l_ac)
          END IF
 
          BEFORE ROW
              LET l_ac = ARR_CURR()
 
          ON CHANGE choice
             IF NOT cl_null(l_pmm[l_ac].choice) THEN
                IF l_pmm[l_ac].choice NOT MATCHES "[YN]" THEN
                     NEXT FIELD choice
                END IF
                LET l_cnt = 0
                FOR g_i =1 TO g_cnt
                 IF l_pmm[g_i].choice = 'Y' THEN
                   LET l_cnt = l_cnt + 1
                 END IF
                END FOR
                DISPLAY l_cnt TO FORMONLY.cmt
              END IF
 
 
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
 
            ON ACTION CONTROLG
               CALL cl_cmdask()
 
            ON ACTION CONTROLN  #重查
                LET l_exit='N'
                EXIT INPUT
 
            ON ACTION select_all
               LET l_cnt = 0
               FOR g_i = 1 to g_cnt
                   LET l_pmm[g_i].choice = 'Y'
                   DISPLAY BY NAME l_pmm[g_i].choice
                   LET l_cnt = l_cnt +1
               END FOR
               display l_cnt TO FORMONLY.cmt
 
            ON ACTION cancel_all
               FOR g_i = 1 TO g_cnt     #將所有的設為選擇
                   LET l_pmm[g_i].choice="N"
               END FOR
               LET l_cnt = 0
               DISPLAY l_cnt TO FORMONLY.cmt
 
            ON ACTION view_report  #查詢單據內容
                CALL cl_wait()
                LET l_ac = ARR_CURR()
 
                LET l_sql="apmr900 '",g_today,"' '' '",g_lang,"'",
                    " 'Y' 'D' '1' ' pmm01="
         ## 若在 GUI 的環境下將 'D':pg 改為 'V':dsview
          --# CALL fgl_init4js()
          --# IF fgl_fglgui()>0  # GUI OR WEB
          --#    THEN
          --#    LET l_sql="apmr900 '",g_today,"' '' '",g_lang,"'",
          --#       " 'Y' 'V' '1' ' pmm01="
          --# END IF
 
            #   LET l_sql=l_sql CLIPPED,'"',l_pmm[l_ac].pmm01[1,10],'"'
                LET l_sql=l_sql CLIPPED,'"',l_pmm[l_ac].pmm01[1,g_no_ep],'"'   #No.FUN-550058
                LET l_sql=l_sql CLIPPED, "' 'N' 'Y' 'N'"
                CALL cl_cmdrun(l_sql)
                LET l_needs[l_ac]='N'
                ERROR ''
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
        
        END INPUT
        #CALL cl_set_act_visible("accept,cancel", TRUE)
        IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF #使用者中斷
        IF l_exit='N' THEN
            CONTINUE WHILE
        END IF
        IF l_cnt < 1 THEN                               #已選筆數超過 0筆
            CONTINUE WHILE
        END IF
        IF NOT cl_sure(0,0) THEN
            CONTINUE WHILE
        END IF
        CALL cl_wait()
        LET l_sl=0
        FOR l_ac=1 TO g_cnt
            IF l_pmm[l_ac].choice='Y' THEN          #該單據要簽核
                #寫入簽核過程檔
                LET g_success = 'Y'
                BEGIN WORK
    #           LET l_pmm[l_ac].pmm01=l_pmm[l_ac].pmm01[1,10] 
                LET l_pmm[l_ac].pmm01=l_pmm[l_ac].pmm01[1,g_no_ep]     #No.FUN-550058
                INSERT INTO azd_file(azd01,azd02,azd03,azd04)
                    VALUES(l_pmm[l_ac].pmm01,3,g_pass,g_today)
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N' 
#                  CALL cl_err('ckp#2',SQLCA.sqlcode,1)   #No.FUN-660131
                   CALL cl_err3("ins","azd_file",l_pmm[l_ac].pmm01,g_pass,SQLCA.sqlcode,"","ckp#2",1)    #No.FUN-660131
                END IF
                #請記得要改單據性質 ----------+
                # 1-報價單 2-銷貨單 3-出貨單 4-發票 5-貸項通知單
                # 6-請購單 7-採購單
                #更新已簽核順序
{ckp#1}         UPDATE pmm_file
                    SET pmmsseq=pmmsseq+1
                    WHERE pmm01=l_pmm[l_ac].pmm01
                IF SQLCA.sqlcode  THEN     #NO:4699將SQLCA.sqlerrd[3]=0拿掉
                   LET g_success = 'N' 
 #                  CALL cl_err('ckp#1',SQLCA.sqlcode,1)  #No.FUN-660131
                    CALL cl_err3("upd","pmm_file",l_pmm[l_ac].pmm01,"",SQLCA.sqlcode,"","ckp#1",1)   #No.FUN-660131
                END IF
 {ckp#3}        UPDATE pmm_file
                    SET pmm25='1'
                    WHERE pmm01=l_pmm[l_ac].pmm01 AND
                          pmmsseq=pmmsmax
                IF SQLCA.sqlcode THEN       #NO:4699將SQLCA.sqlerrd[3]=0拿掉 
                   LET g_success = 'N' 
#                   CALL cl_err('ckp#3',SQLCA.sqlcode,1)   #No.FUN-660131
                    CALL cl_err3("upd","pmm_file",l_pmm[l_ac].pmm01,"",SQLCA.sqlcode,"","ckp#3",1)  #No.FUN-660131
                END IF
                IF SQLCA.SQLERRD[3]=1 THEN
 {ckp#4}            UPDATE pmn_file
                        SET pmn16='1'
                        WHERE pmn01=l_pmm[l_ac].pmm01
                    IF SQLCA.sqlcode THEN
                        LET g_success = 'N' 
#                        CALL cl_err('ckp#4',SQLCA.sqlcode,1)  #No.FUN-660131
                         CALL cl_err3("upd","pmn_file",l_pmm[l_ac].pmm01,"",SQLCA.sqlcode,"","ckp#4",1)  #No.FUN-660131
                    END IF
                END IF
                LET l_sl=l_sl+1
                MESSAGE '(',l_sl USING '##&',') Row(s) Processed'
                IF g_success ='Y' THEN 
                  CALL cl_cmmsg(1) COMMIT WORK 
                ELSE    
                  CALL cl_rbmsg(1) ROLLBACK WORK
                END IF
                IF l_sl=l_cnt THEN
                    EXIT FOR
                END IF
            END IF
        END FOR
#       EXIT WHILE
    END WHILE
    CLOSE WINDOW u013_w
END FUNCTION
