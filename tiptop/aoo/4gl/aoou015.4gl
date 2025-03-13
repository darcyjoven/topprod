# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aoou015.4gl
# Descriptions...: 無交期採購單
# Date & Author..: 01/04/03 By Kammy
# Modify.........: No.FUN-550058 05/05/28 By vivien 單據編號格式放大  
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換
#
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
     DEFINE
        g_pass          LIKE azd_file.azd03,           #No.FUN-680102CHAR(08),
        g_cnt           LIKE type_file.num10,          #No.FUN-680102 INTEGER
        g_msg           LIKE type_file.chr1000,        #No.FUN-680102 VARCHAR(72),
        g_chr           LIKE type_file.chr1            #No.FUN-680102 VARCHAR(1)
END GLOBALS
 
DEFINE
    g_pom RECORD LIKE pom_file.*
 
FUNCTION u015()
 
    WHENEVER ERROR CONTINUE
#    IF NOT cl_prich2('aoou015','') THEN
    IF NOT cl_chk_act_auth() THEN
       RETURN
    END IF
    CALL u015_1()                      #接受選擇
END FUNCTION
 
#將資料選出, 並進行挑選
FUNCTION u015_1()
DEFINE
# genero  script marked     l_arrno      SMALLINT,                  #program array no
    l_ac         LIKE type_file.num5,                    #program array no        #No.FUN-680102 SMALLINT
    l_ok         LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01),                 #判斷是否取得資料
    l_exit       LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(01),
    l_sl         LIKE type_file.num5,           #No.FUN-680102 SMALLINT,            #screen array no
    l_sl2        LIKE type_file.num5,           #No.FUN-680102 SMALLINT,            #screen array no
    l_cnt        LIKE type_file.num5,                    #所選擇筆數 #No.FUN-680102 SMALLINT
    l_cnt1       LIKE type_file.num5,                    #所選擇筆數 #No.FUN-680102 SMALLINT
    l_wc         LIKE type_file.chr1000,       #No.FUN-680102CHAR(1000),
    l_sql        LIKE type_file.chr1000,                #RDSQL  STATEMENT        #No.FUN-680102CHAR(1000),
    l_days,l_prit LIKE type_file.num5,           #No.FUN-680102 SMALLINT,
    l_pom03 ARRAY[48] OF LIKE type_file.chr2,    # Prog. Version..: '5.30.06-13.03.12(02), #更動序號
    l_needs ARRAY[48] OF LIKE type_file.chr1,    #No.FUN-680102 VARCHAR(01),
    l_pom DYNAMIC ARRAY OF RECORD                #結果
        choice      LIKE type_file.chr1,         # Prog. Version..: '5.30.06-13.03.12(01),            #選擇碼
    #    pom01       VARCHAR(13),               #單號
        pom01       LIKE pom_file.pom01,    #單號   #No.FUN-550058
        pom04       LIKE pom_file.pom04,    #日期
        pmc03       LIKE pmc_file.pmc03,    #廠商編號
        pom22       LIKE pom_file.pom22,    #總金額
        pomsign     LIKE pom_file.pomsign,  #簽核等級
        pomdays     LIKE pom_file.pomdays,
        pomprit     LIKE pom_file.pomprit
              END RECORD
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
         LET p_row = 5 LET p_col = 24
    OPEN WINDOW u015_w AT p_row,p_col                    #開窗讓使用者選擇
        WITH FORM "aoo/42f/aoou015" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_locale("aoou015")
 
    WHILE TRUE
        IF s_shut(0) THEN EXIT WHILE END IF
        LET l_exit='Y'
        CALL cl_getmsg('aoo-051',g_lang) RETURNING g_msg
        DISPLAY g_msg AT 1,1          #顯示操作指引
        CALL cl_getmsg('aoo-052',g_lang) RETURNING g_msg
        DISPLAY g_msg AT 2,1          #顯示操作指引
        CLEAR FORM
        CONSTRUCT l_wc ON pom01,pom04,pmc03,pom22,
                 pomsign,pomdays,pomprit
            FROM s_pom[1].pom01,s_pom[1].pom04,
                 s_pom[1].pmc03,s_pom[1].pom22,s_pom[1].pomsign,
                 s_pom[1].pomdays,s_pom[1].pomprit  
 
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
  LET l_wc = l_wc CLIPPED,cl_get_extra_cond('pomuser', 'pomgrup') #FUN-980030
 
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            EXIT WHILE
        END IF
        LET l_sql = "SELECT ",                      #組合查詢句子
            "'',pom01,pom04,pmc03,",
#---->modify by pin ----->(pom04+pomdays)-?
            "pom22,pomsign,(pom04+pomdays)-?,pomprit",
            " FROM pom_file,OUTER(pmc_file)",
            " WHERE pomsign IS NOT NULL AND",
            " pommksg='Y' AND",
            " pom18='Y' AND",
            " pom09 = pmc_file.pmc01 AND ",
            " pom25='0' AND pomacti='Y'",
            " AND ",l_wc CLIPPED,
            #去選擇單據時, 加這一句條件, 可以得到該使用者該簽核而未簽核的單據
            " AND pomsseq=(SELECT (azc02-1)",
            " FROM azc_file WHERE azc01=pomsign AND azc03=",
            "'",g_pass,"'"," )",
            " ORDER BY 7,8 "
 
        PREPARE u015_prepare FROM l_sql      #預備之
        IF SQLCA.sqlcode THEN                          #有問題了
            CALL cl_err('PREPARE:',SQLCA.sqlcode,1)
            EXIT WHILE
        END IF
        DECLARE u015_cs CURSOR FOR u015_prepare     #宣告之
 
        CALL l_pom.clear()
 
#       FOR g_cnt=1 TO l.getLength()
#           INITIALIZE l_pom[g_cnt].* TO NULL
#       END FOR
        LET g_cnt=1                                         #總選取筆數
        FOREACH u015_cs USING g_today
            INTO l_pom[g_cnt].*,l_pom03[g_cnt],l_needs[g_cnt],l_days,l_prit
            IF SQLCA.sqlcode THEN                                  #有問題
                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                EXIT FOREACH
            END IF
         #  ERROR 'l_days,l_prit,l_pom[g_cnt].pom01',l_days,l_prit,
         #         ' ',l_pom[g_cnt].pom01 sleep 3 
#取得是否需要閱後方可簽核
            SELECT aze07 INTO l_needs[g_cnt]
                FROM aze_file
                WHERE aze01=l_pom[g_cnt].pomsign
            IF SQLCA.sqlcode THEN
                LET l_needs[g_cnt]=''
            END IF
            IF NOT cl_null(l_pom03[g_cnt]) THEN
               LET l_pom[g_cnt].pom01=l_pom[g_cnt].pom01 CLIPPED,
                '-',l_pom03[g_cnt] CLIPPED
            END IF
            LET g_cnt = g_cnt + 1                           #累加筆數
            IF g_cnt > g_max_rec THEN                         #超過肚量了
                EXIT FOREACH
            END IF
        END FOREACH
        IF g_cnt=1 THEN                                     #沒有抓到
            CALL cl_err('','aoo-004',1)                     #顯示錯誤, 並回去
            CONTINUE WHILE
        END IF
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
        DISPLAY l_cnt TO FORMONLY.cmt 
        CALL cl_set_act_visible("accept,cancel", FALSE)
        DISPLAY ARRAY l_pom TO s_pom.*  #顯示並進行選擇
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
            ON ACTION CONTROLG
                CALL cl_cmdask()
            ON ACTION CONTROLN  #重查
                LET l_exit='N'
                EXIT DISPLAY
            ON ACTION select_cancel #選擇或取消
                LET l_ac = ARR_CURR()
                LET l_sl = SCR_LINE()
                IF l_needs[l_ac]='Y' THEN
                    CALL cl_err('','aoo-021',1)
                ELSE
                    IF cl_null(l_pom[l_ac].choice) THEN
                        LET l_pom[l_ac].choice='Y'          #設定為選擇
                        LET l_cnt=l_cnt+1                   #累加已選筆數
                    ELSE
                        LET l_pom[l_ac].choice=''           #設定為不選擇
                        LET l_cnt=l_cnt-1                   #減少已選筆數
                    END IF
                    DISPLAY l_pom[l_ac].choice TO
                        s_pom[l_sl].choice 
                    DISPLAY l_cnt TO FORMONLY.cmt 
                END IF
            ON ACTION select_all  #整批
                IF l_cnt=0 THEN
                    LET l_ok='Y'
                    LET l_cnt=g_cnt                 #設定已選筆數
                ELSE
                    LET l_ok=NULL
                    LET l_cnt=0                     #設定已選筆數
                END IF
                LET l_cnt1=0        
                LET l_ac = ARR_CURR()
                LET l_sl = SCR_LINE()
                LET l_sl2=l_ac-l_sl+1
                LET l_sl=0
                FOR l_ac = 1 TO g_cnt                   #將所有的設為選擇
                    IF l_ac=l_sl2 THEN
                        LET l_sl=1
                    ELSE
                        IF l_ac > l_sl2 THEN
                            LET l_sl=l_sl+1
                        END IF
                    END IF
                    IF l_needs[l_ac] != 'Y' THEN
                        LET l_pom[l_ac].choice=l_ok
                        IF l_sl < 12 AND l_sl > 0 THEN
                            DISPLAY l_pom[l_ac].choice TO s_pom[l_ac].choice
                                
                        END IF
                    ELSE
                        LET l_cnt1=l_cnt1+1               #設定已選筆數
                    END IF
                END FOR
                IF l_ok='Y' THEN
                    LET l_cnt=l_cnt-l_cnt1
                END IF
                DISPLAY l_cnt TO FORMONLY.cmt 
            ON ACTION view_report #查詢單據內容
                CALL cl_wait()
                LET l_ac = ARR_CURR()
 
                LET l_sql="apmr900 '",g_today,"' '' '",g_lang,"'",
                    " 'Y' 'D' '1' ' pom01="
         ## 若在 GUI 的環境下將 'D':pg 改為 'V':dsview
          --# CALL fgl_init4js()
          --# IF fgl_fglgui()>0  # GUI OR WEB
          --#    THEN
          --#    LET l_sql="apmr900 '",g_today,"' '' '",g_lang,"'",
          --#       " 'Y' 'V' '1' ' pom01="
          --# END IF
 
            #   LET l_sql=l_sql CLIPPED,'"',l_pom[l_ac].pom01[1,10],'"'
                LET l_sql=l_sql CLIPPED,'"',l_pom[l_ac].pom01[1,g_no_ep],'"'  #No.FUN-550058
                LET l_sql=l_sql CLIPPED, "' 'N' 'Y' 'N'"
                CALL cl_cmdrun(l_sql)
                LET l_needs[l_ac]='N'
                ERROR ''
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
        
        END DISPLAY
        CALL cl_set_act_visible("accept,cancel", TRUE)
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
            IF l_pom[l_ac].choice='Y' THEN          #該單據要簽核
                #寫入簽核過程檔
                LET g_success = 'Y'
                BEGIN WORK
    #           LET l_pom[l_ac].pom01=l_pom[l_ac].pom01[1,10] 
                LET l_pom[l_ac].pom01=l_pom[l_ac].pom01[1,g_no_ep]   #No.FUN-550058
                INSERT INTO azd_file(azd01,azd02,azd03,azd04)
                    VALUES(l_pom[l_ac].pom01,3,g_pass,g_today)
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N' 
#                  CALL cl_err('ckp#2',SQLCA.sqlcode,1)   #No.FUN-660131
                   CALL cl_err3("ins","azd_file",l_pom[l_ac].pom01,g_pass,SQLCA.sqlcode,"","ckp#2",1)    #No.FUN-660131
                END IF
                #請記得要改單據性質 ----------+
                # 1-報價單 2-銷貨單 3-出貨單 4-發票 5-貸項通知單
                # 6-請購單 7-採購單
                #更新已簽核順序
{ckp#1}         UPDATE pom_file
                    SET pomsseq=pomsseq+1
                    WHERE pom01=l_pom[l_ac].pom01
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N' 
 #                  CALL cl_err('ckp#1',SQLCA.sqlcode,1)   #No.FUN-660131
                    CALL cl_err3("upd","pom_file",l_pom[l_ac].pom01,"",SQLCA.sqlcode,"","ckp#1",1)   #No.FUN-660131
                END IF
 {ckp#3}        UPDATE pom_file
                    SET pom25='1'
                    WHERE pom01=l_pom[l_ac].pom01 AND
                          pomsseq=pomsmax
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N' 
 #                  CALL cl_err('ckp#3',SQLCA.sqlcode,1)    #No.FUN-660131
                    CALL cl_err3("upd","pom_file",l_pom[l_ac].pom01,"",SQLCA.sqlcode,"","ckp#3",1)  #No.FUN-660131
                END IF
                IF SQLCA.SQLERRD[3]=1 THEN
 {ckp#4}            UPDATE pon_file
                        SET pon16='1'
                        WHERE pon01=l_pom[l_ac].pom01
                    IF SQLCA.sqlcode THEN
                        LET g_success = 'N' 
#                        CALL cl_err('ckp#4',SQLCA.sqlcode,1)   #No.FUN-660131
                         CALL cl_err3("upd","pon_file",l_pom[l_ac].pom01,"",SQLCA.sqlcode,"","ckp#4",1) #No.FUN-660131
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
    CLOSE WINDOW u015_w
END FUNCTION
