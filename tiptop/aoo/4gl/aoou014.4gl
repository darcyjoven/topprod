# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aoou014.4gl
# Descriptions...: 傳票簽核
# Date & Author..: 92/02/28 BY MAY
# Modify.........: 92/09/24 By Pin
#                  簽核處理修正(順序以簽核剩餘天數,簽核完成天數來排)
#                  因劃面編幅有限,無法顯示剩餘天數與簽核完成天數
# Modify.........: No.MOD-4C0171 05/02/15 By Smapmin 接收參數時,第一個必為帳別,若第一個不是帳別,則加入Null
# Modify.........: No.FUN-550058 05/05/28 By vivien 單據編號格式放大  
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0035 09/11/10 By Carrier SQL STANDARDIZE -to_date
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
     DEFINE
        g_pass          LIKE azd_file.azd03,           #No.FUN-680102CHAR(08),
        g_cnt           LIKE type_file.num10,          #No.FUN-680102 INTEGER
        g_msg           LIKE type_file.chr1000,        #No.FUN-680102CHAR(72),
        g_chr           LIKE type_file.chr1            #No.FUN-680102 VARCHAR(1)
END GLOBALS
 
DEFINE
    g_aba RECORD LIKE aba_file.*,
    g_bookno     LIKE aaa_file.aaa01 
 
FUNCTION u014(p_dbs)
   DEFINE p_dbs LIKE type_file.chr21              #No.FUN-680102CHAR(21) 
 
    WHENEVER ERROR CONTINUE
#   IF NOT cl_prich2('aoou014','') THEN
    IF NOT cl_chk_act_auth() THEN
       RETURN
    END IF
    SELECT aaz64 INTO g_bookno FROM aaz_file 
    CALL u014_1(p_dbs)                      #接受選擇
END FUNCTION
 
#將資料選出, 並進行挑選
FUNCTION u014_1(l_dbs)
DEFINE
    l_dbs  , p_dbs LIKE type_file.chr21,       #No.FUN-680102  VARCHAR(21)  
    l_ac         LIKE type_file.num5,                    #program array no        #No.FUN-680102 SMALLINT
    l_ok         LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01),                #判斷是否取得資料
    l_exit       LIKE type_file.chr1,           #No.FUN-680102CHAR(01),
    l_sl         LIKE type_file.num5,           #No.FUN-680102SMALLINT,             #screen array no
    l_sl2        LIKE type_file.num5,           #No.FUN-680102  SMALLINT,     #screen array no
    l_cnt        LIKE type_file.num5,                    #所選擇筆數        #No.FUN-680102 SMALLINT
    l_cnt1       LIKE type_file.num5,                    #所選擇筆數        #No.FUN-680102 SMALLINT
    l_wc         LIKE type_file.chr1000,      #No.FUN-680102CHAR(1000),
    l_sql        LIKE type_file.chr1000,                #RDSQL STATEMENT        #No.FUN-680102CHAR(1000),
    l_days,l_prit LIKE type_file.num5,           #No.FUN-680102SMALLINT,
    l_aba03 ARRAY[48] OF LIKE type_file.chr2,  # Prog. Version..: '5.30.06-13.03.12(02), #更動序號
    l_needs ARRAY[48] OF LIKE type_file.chr1,           #No.FUN-680102CHAR(01),
    l_aba DYNAMIC ARRAY OF RECORD               #結果
        choice      LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01),             #選擇碼
        aba01       LIKE aba_file.aba01,    #報價單號   #No.FUN-550058
        aba06       LIKE aba_file.aba06,    #有效日期
        aba02       LIKE aba_file.aba02,    #報價日期
        aba05       LIKE aba_file.aba05,    #帳款客戶
        aba08       LIKE aba_file.aba08,    #總金額
        abasign     LIKE aba_file.abasign,
        abadays     LIKE aba_file.abadays,
        abaprit     LIKE aba_file.abaprit
              END RECORD
     
    OPEN WINDOW u014_w WITH FORM "aoo/42f/aoou014" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("aoou014")
 
    WHILE TRUE
        IF s_shut(0) THEN EXIT WHILE END IF
        LET l_exit='Y'
        CALL cl_getmsg('aoo-051',g_lang) RETURNING g_msg
        DISPLAY g_msg AT 1,1          #顯示操作指引
        CALL cl_getmsg('aoo-052',g_lang) RETURNING g_msg
        DISPLAY g_msg AT 2,1          #顯示操作指引
        CLEAR FORM
        CONSTRUCT l_wc ON aba01,aba06,aba02,aba05,aba08,abasign,abadays,abaprit
            FROM s_aba[1].aba01,s_aba[1].aba06,s_aba[1].aba02,
                 s_aba[1].aba05,s_aba[1].aba08,s_aba[1].abasign,
                 s_aba[1].abadays,s_aba[1].abaprit 
 
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
  LET l_wc = l_wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup') #FUN-980030
 
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            EXIT WHILE
        END IF
        LET l_sql = "SELECT ",                      #組合查詢句子
            "'',aba01,aba06,aba02,aba05,",
#---->modify by pin ----->(aba05+abadays)-to_date(?)?
            #No.TQC-9B0035  --Begin
           #"aba08,abasign,(aba05+abadays)-to_date(?)?,abaprit",
            "aba08,abasign,abadays,abaprit",
            #No.TQC-9B0035  --End  
            " FROM aba_file",
            " WHERE aba00 = '",g_bookno,"' AND abamksg='Y' AND",
#未過帳資料才可簽核
            " abapost ='N' AND abaacti='Y'",
            " AND aba19='Y'",   #確認
            " AND ",l_wc CLIPPED,
            #-[這一句話很重要]-----------------------------------------------
            #去選擇單據時, 加這一句條件, 可以得到該使用者該簽核而未簽核的單據
            " AND abasseq=(SELECT (azc02-1)",
            " FROM azc_file WHERE azc01=abasign AND azc03='",g_pass,"')",
            " ORDER BY 8,9"
 
        PREPARE u014_prepare FROM l_sql      #預備之
        IF SQLCA.sqlcode THEN                          #有問題了
            CALL cl_err('PREPARE:',SQLCA.sqlcode,1)
            EXIT WHILE
        END IF
        DECLARE u014_cs CURSOR FOR u014_prepare     #宣告之
 
        CALL l_aba.clear()
 
#       FOR g_cnt=1 TO l.getLength()
#           INITIALIZE l_aba[g_cnt].* TO NULL
#       END FOR
        LET g_cnt=1                                         #總選取筆數
        #No.TQC-9B0035  --Begin
        #FOREACH u014_cs USING g_today
        #    INTO l_aba[g_cnt].*,l_needs[g_cnt],l_days,l_prit
        FOREACH u014_cs INTO l_aba[g_cnt].*
        #No.TQC-9B0035  --End  
            IF SQLCA.sqlcode THEN                                  #有問題
                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                EXIT FOREACH
            END IF
#           ERROR 'l_days,l_prit,l_aba[g_cnt].aba01',l_days,l_prit,
#                ' ',l_aba[g_cnt].aba01 sleep 3 
#取得是否需要閱後方可簽核
#
            #No.TQC-9B0035  --Begin
            LET l_aba[g_cnt].abadays = l_aba[g_cnt].aba05 + l_aba[g_cnt].abadays - g_today
            IF cl_null(l_aba[g_cnt].abadays) THEN LET l_aba[g_cnt].abadays = 0 END IF
            #No.TQC-9B0035  --End  
 
            SELECT aze07 INTO l_needs[g_cnt]
                FROM aze_file
                WHERE aze01=l_aba[g_cnt].abasign
            IF SQLCA.sqlcode THEN
                LET l_needs[g_cnt]=''
            END IF
 
#           LET l_aba[g_cnt].aba01=l_aba[g_cnt].aba01 CLIPPED,
#               '-',l_aba03[g_cnt] CLIPPED
 
            LET g_cnt = g_cnt + 1                           #累加筆數
            IF g_cnt > g_max_rec THEN                         #超過肚量了
                EXIT FOREACH
            END IF
        END FOREACH
        IF g_cnt=1 THEN                                     #沒有抓到
            CALL cl_err('','aoo-004',0)                     #顯示錯誤, 並回去
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

        DISPLAY ARRAY l_aba TO s_aba.*  #顯示並進行選擇
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
            ON ACTION CONTROLG
                CALL cl_cmdask()
            ON ACTION CONTROLN  #重查
                LET l_exit='N'
                EXIT DISPLAY
            ON ACTION select_cancel  #選擇或取消
                LET l_ac = ARR_CURR()
                LET l_sl = SCR_LINE()
                IF l_needs[l_ac]='Y' THEN
                    CALL cl_err('','aoo-021',0)
                ELSE
                    IF cl_null(l_aba[l_ac].choice) THEN
                        LET l_aba[l_ac].choice='Y'          #設定為選擇
                        LET l_cnt=l_cnt+1                   #累加已選筆數
                    ELSE
                        LET l_aba[l_ac].choice=''           #設定為不選擇
                        LET l_cnt=l_cnt-1                   #減少已選筆數
                    END IF
                    DISPLAY l_aba[l_ac].choice TO
                        s_aba[l_sl].choice 
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
                        LET l_aba[l_ac].choice=l_ok
                        IF l_sl < 12 AND l_sl > 0 THEN
                            DISPLAY l_aba[l_ac].choice TO s_aba[l_ac].choice
                                
                        END IF
                    ELSE
                        LET l_cnt1=l_cnt1+1               #設定已選筆數
                    END IF
                END FOR
                IF l_ok='Y' THEN
                    LET l_cnt=l_cnt-l_cnt1
                END IF
                DISPLAY l_cnt TO FORMONLY.cmt 
 
            ON ACTION view_report  #查詢單據內容
                CALL cl_wait()
                LET l_ac = ARR_CURR()
                 LET l_sql="aglr903 '' '",g_bookno,"' '",l_dbs,"' '",g_today,"' '' '",g_lang,"'",   #MOD-4C0171
                    " 'Y' 'D' '1' ' aba01="
         ## 若在 GUI 的環境下將 'D':pg 改為 'V':dsview
          --# CALL fgl_init4js()
          --# IF fgl_fglgui()>0  # GUI OR WEB
          --#    THEN
          --#    LET l_sql="aglr903 '",g_bookno,"' '",l_dbs,"' '",g_today,"' '' '",g_lang,"'",
          --#       " 'Y' 'V' '1' ' aba01="
          --# END IF
 
            #   LET l_sql=l_sql CLIPPED,'"',l_aba[l_ac].aba01[1,12],'"'
                LET l_sql=l_sql CLIPPED,'"',l_aba[l_ac].aba01[1,g_no_ep],'"'   #No.FUN-550058
                LET l_sql=l_sql CLIPPED, "' '3' '3' 'Y' '3'"
                CALL cl_cmdrun(l_sql)
                LET l_needs[l_ac]='N'
 
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
            IF l_aba[l_ac].choice='Y' THEN          #該單據要簽核
                #寫入簽核過程檔
                LET g_success = 'Y'
                BEGIN WORK
{ckp#1}       # LET l_aba[l_ac].aba01=l_aba[l_ac].aba01[1,10] 
                INSERT INTO azd_file(azd01,azd02,azd03,azd04)
                    VALUES(l_aba[l_ac].aba01,4,g_pass,g_today)
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N' 
#                  CALL cl_err('ckp#1',SQLCA.sqlcode,1)   #No.FUN-660131
                   CALL cl_err3("ins","azd_file",l_aba[l_ac].aba01,g_pass,SQLCA.sqlcode,"","ckp#1",1)    #No.FUN-660131
                END IF
                #請記得要改單據性質 ----------+
                # 1-報價單 2-銷貨單 3-出貨單 4-發票 5-貸項通知單
                # 6-請購單 7-採購單 8-傳票單
                #更新已簽核順序
{ckp#2}         UPDATE aba_file
                    SET abasseq=abasseq+1
                    WHERE aba01=l_aba[l_ac].aba01 and
                          aba00= g_bookno
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N' 
 #                  CALL cl_err('ckp#2',SQLCA.sqlcode,1)   #No.FUN-660131
                    CALL cl_err3("upd","aba_file",l_aba[l_ac].aba01,g_bookno,SQLCA.sqlcode,"","ckp#2",1)  #No.FUN-660131
                END IF
## No:      modify 1998/12/19 ----------------------------
 {ckp#3}        UPDATE aba_file
                    SET aba20='1'   #狀態碼 (0.開立 1.核准)
                    WHERE aba01=l_aba[l_ac].aba01 AND
                          abasseq=abasmax
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N'
#                   CALL cl_err('ckp#3',SQLCA.sqlcode,1)    #No.FUN-660131
                    CALL cl_err3("upd","aba_file",l_aba[l_ac].aba01,"",SQLCA.sqlcode,"","ckp#3",1)  #No.FUN-660131
                END IF
## --------------------------------------------------------
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
    CLOSE WINDOW u014_w
END FUNCTION
