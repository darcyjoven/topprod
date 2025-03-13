# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aoou022.4gl
# Descriptions...: 訂單資料簽核作業
# Date & Author..: 00/10/25 By Kammy
# Modify.........: No.FUN-550058 05/05/28 By vivien 單據編號格式放大  
# Modify.........: No.TQC-610089 06/05/17 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0035 09/11/10 By Carrier SQL STANDARDIZE -to_date
#
 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
     DEFINE
        g_pass          LIKE azd_file.azd03,           #No.FUN-680102CHAR(08), 
        g_cnt           LIKE type_file.num10,          #No.FUN-680102 INTEGER
        g_msg           LIKE type_file.chr1000,       #No.FUN-680102CHAR(72),
        g_chr           LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
END GLOBALS
 
FUNCTION u022()
 
    WHENEVER ERROR CONTINUE
#   IF NOT cl_prich2('aoou022','') THEN
    IF NOT cl_chk_act_auth() THEN
         RETURN
    END IF
    CALL u022_1()                      #接受選擇
END FUNCTION
 
#將資料選出, 並進行挑選
FUNCTION u022_1()
DEFINE
# genero  script marked     l_arrno   LIKE type_file.num5,           #No.FUN-680102      SMALLINT,             #program array no
    l_ac         LIKE type_file.num5,                    #program array no        #No.FUN-680102 SMALLINT
    l_ok         LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01),                 #判斷是否取得資料
    l_exit       LIKE type_file.chr1,           #No.FUN-680102CHAR(01), 
    l_sl         LIKE type_file.num5,           #No.FUN-680102 SMALLINT,            #screen array no
    l_sl2        LIKE type_file.num5,           #No.FUN-680102 SMALLINT,                 #screen array no
    l_cnt        LIKE type_file.num5,                    #所選擇筆數        #No.FUN-680102 SMALLINT
    l_cnt1       LIKE type_file.num5,                    #所選擇筆數        #No.FUN-680102 SMALLINT
    l_wc         LIKE type_file.chr1000,       #No.FUN-680102CHAR(1000),
    l_sql        LIKE type_file.chr1000,               #RDSQL STATEMENT        #No.FUN-680102CHAR(1000),
    l_days,l_prit LIKE type_file.num5,           #No.FUN-680102SMALLINT,
    l_needs ARRAY[48] OF LIKE type_file.chr1,           #No.FUN-680102CHAR(01),
    l_oea DYNAMIC ARRAY OF RECORD               #結果
        choice     LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01),             #選擇碼
    #   oea01       VARCHAR(13),               #報價單號
        oea01       LIKE oea_file.oea01,    #報價單號    #No.FUN-550058
        oea02       LIKE oea_file.oea02,    #報價日期
        oea032      LIKE oea_file.oea032,   #帳款客戶
        oea23       LIKE oea_file.oea23,    #幣別 
        oeasign     LIKE oea_file.oeasign,  #簽核等級
        oeadays     LIKE oea_file.oeadays,
        oeaprit     LIKE oea_file.oeaprit
              END RECORD
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
    #開窗讓使用者選擇
    LET p_row = 5 LET p_col = 25
    OPEN WINDOW u022_w AT p_row,p_col WITH FORM "aoo/42f/aoou022" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_locale("aoou022")
 
# genero  script marked     LET l_arrno=48                              #程式陣列個數, 共 4頁
    WHILE TRUE
        IF s_shut(0) THEN EXIT WHILE END IF
        LET l_exit='Y'
        CALL cl_getmsg('aoo-051',g_lang) RETURNING g_msg
        DISPLAY g_msg AT 1,1          #顯示操作指引
        CALL cl_getmsg('aoo-052',g_lang) RETURNING g_msg
        DISPLAY g_msg AT 2,1          #顯示操作指引
        CLEAR FORM
        CONSTRUCT l_wc ON oea01,oea02,oea032,oea23,oeasign,oeadays,oeaprit 
            FROM s_oea[1].oea01,s_oea[1].oea02,s_oea[1].oea032,
                 s_oea[1].oea23,s_oea[1].oeasign,
                 s_oea[1].oeadays,s_oea[1].oeaprit 
 
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
  LET l_wc = l_wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup') #FUN-980030
 
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            EXIT WHILE
        END IF
        LET l_sql = "SELECT ",                      #組合查詢句子
            "'', oea01,oea02,oea032,",
            #No.TQC-9B0035  --Begin
          # " oea23,oeasign,(oea02+oeadays)-to_date(?),oeaprit",
            " oea23,oeasign,oeadays,oeaprit",
            #No.TQC-9B0035  --End  
            " FROM oea_file ",
            " WHERE oeasign IS NOT NULL AND",
            " oeamksg='Y' AND",
            " oeaconf='Y' AND",
            " oea49='0' ",
            " AND ",l_wc CLIPPED,
            #-[這一句話很重要]-----------------------------------------------
            #去選擇單據時, 加這一句條件, 可以得到該使用者該簽核而未簽核的單據
            " AND oeasseq=(SELECT (azc02 - 1)",
            " FROM azc_file WHERE azc01=oeasign AND azc03='",g_pass,"')",
            " ORDER BY 6,7 "
 
 
        PREPARE u022_prepare FROM l_sql      #預備之
        IF SQLCA.sqlcode THEN                          #有問題了
            CALL cl_err('PREPARE:',SQLCA.sqlcode,1)
            EXIT WHILE
        END IF
        DECLARE u022_curs CURSOR FOR u022_prepare     #宣告之
 
        CALL l_oea.clear()
 
#       FOR g_cnt=1 TO l.getLength()
#           INITIALIZE l_oea[g_cnt].* TO NULL
#       END FOR
        LET g_cnt=1                                         #總選取筆數
        #No.TQC-9B0035  --Begin
        #FOREACH u022_curs USING g_today
        #    INTO l_oea[g_cnt].*,l_needs[g_cnt],l_days,l_prit
        FOREACH u022_curs INTO l_oea[g_cnt].*
        #No.TQC-9B0035  --End  
            IF SQLCA.sqlcode THEN                                  #有問題
                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                EXIT FOREACH
            END IF
            #No.TQC-9B0035  --Begin
            LET l_oea[g_cnt].oeadays = l_oea[g_cnt].oeadays + l_oea[g_cnt].oea02 - g_today
            IF cl_null(l_oea[g_cnt].oeadays) THEN LET l_oea[g_cnt].oeadays = 0 END IF
            #No.TQC-9B0035  --End  
#取得是否需要閱後方可簽核
            SELECT aze07 INTO l_needs[g_cnt]   #簽核等級單頭檔
                FROM aze_file
                WHERE aze01=l_oea[g_cnt].oeasign
            IF SQLCA.sqlcode THEN
                LET l_needs[g_cnt]=''
            END IF
            LET l_oea[g_cnt].oea01=l_oea[g_cnt].oea01 CLIPPED
            LET g_cnt = g_cnt + 1                           #累加筆數
            IF g_cnt > g_max_rec THEN                         #超過肚量了
                CALL cl_err('','9035',0)
                EXIT FOREACH
            END IF
        END FOREACH
        IF g_cnt=1 THEN                                     #沒有抓到
            CALL cl_err('','aoo-004',0)                     #顯示錯誤, 並回去
            CONTINUE WHILE
        END IF
        LET g_cnt=g_cnt-1                                   #正確的總筆數
        CALL SET_COUNT(g_cnt)                               #告之DISPALY ARRAY
        CALL cl_getmsg('aoo-050',g_lang) RETURNING g_msg
        DISPLAY "" AT 1,1             #清除不要的資訊
        DISPLAY g_msg AT 2,1          #顯示操作指引
        DISPLAY g_cnt TO FORMONLY.cnt  #顯示總筆數
        LET l_cnt=0                                     #已選筆數
        DISPLAY l_cnt TO FORMONLY.cmt 
        CALL cl_set_act_visible("accept,cancel", FALSE)
        DISPLAY ARRAY l_oea TO s_oea.*  #顯示並進行選擇
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
            ON ACTION select_cancel  #選擇或取消
                LET l_ac = ARR_CURR()
                LET l_sl = SCR_LINE()
                IF l_needs[l_ac]='Y' THEN
                    CALL cl_err('','aoo-021',0)
                ELSE
                    IF cl_null(l_oea[l_ac].choice) THEN
                        LET l_oea[l_ac].choice='Y'          #設定為選擇
                        LET l_cnt=l_cnt+1                   #累加已選筆數
                    ELSE
                        LET l_oea[l_ac].choice=''           #設定為不選擇
                        LET l_cnt=l_cnt-1                   #減少已選筆數
                    END IF
                    DISPLAY l_oea[l_ac].choice TO
                        s_oea[l_sl].choice 
                    DISPLAY l_cnt TO FORMONLY.cmt 
                END IF
            ON ACTION select_all  #整批
                IF l_cnt=0 THEN
                    LET l_ok='Y'
                    LET l_cnt=g_cnt                     #設定已選筆數
                ELSE
                    LET l_ok=NULL
                    LET l_cnt=0                         #設定已選筆數
                END IF
#因為screen array的位置和program array的位置會改變, 因此, 在此必需
#透過一些簡單的計算方式, 方可確保在顯示時會正確, 做法為:
#1.先取得目前所在的ARR_CURR()及SCR_LINE()而在畫面中的起始位置為
#  ARR_CURR()-SCR_LINE()+1
#2.在for loop中判斷, 若其arr_curr小於起始位置時, 則不為任何動作
#  若arr_curr大於起始位置, 並且小於畫面可容納的範圍, 並且該行可以
#  簽核, 則顯示之; 若超出畫面可顯示範圍, 則不顯示
                LET l_cnt1=0        
                LET l_ac = ARR_CURR()
                LET l_sl = SCR_LINE()
                LET l_sl2=l_ac-l_sl+1
                LET l_sl=0
                FOR l_ac = 1 TO g_cnt                   #將所有的設為選擇
#在此計算screen array的正確位置, 方法為:
#開始時, 將其值設成零, 若其值等於起始位置, 則設定其值為1
#若大於起始位, 則每次累加一
                    IF l_ac=l_sl2 THEN
                        LET l_sl=1
                    ELSE
                        IF l_ac > l_sl2 THEN
                            LET l_sl=l_sl+1
                        END IF
                    END IF
                    IF l_needs[l_ac] != 'Y' THEN
#在這裡判斷是否在螢幕顯示範圍內
                        LET l_oea[l_ac].choice=l_ok
                        IF l_sl < 12 AND l_sl > 0 THEN
                            DISPLAY l_oea[l_ac].choice TO s_oea[l_sl].choice
                            
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
 
 
              #----------------No.TQC-610089 modify
               LET l_wc='oea01="',l_oea[l_ac].oea01,'"'
               LET l_sql = "axmr400",
                            " '",g_today CLIPPED,"' ''",
                            " '",g_lang CLIPPED,"' 'Y' 'V' '1'",
                            " '",l_wc CLIPPED,"' "    
              #----------------No.TQC-610089 end
 
         ## 若在 GUI 的環境下將 'D':pg 改為 'V':dsview
          --# CALL fgl_init4js()
          --# IF fgl_fglgui()>0  # GUI OR WEB
          --#    THEN
          --#    LET l_sql="axmr410 '",l_oea[l_ac].oea01[1,10],"' '",
          --#              g_today,"' ' ' '",g_lang,"'",
          --#              " 'Y' 'V' '1' "
          --# END IF
 
                LET l_sql=l_sql CLIPPED, "' 'N' 'Y' 'N'"
                CALL cl_cmdrun(l_sql)
                   error ' '
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
            IF l_oea[l_ac].choice='Y' THEN          #該單據要簽核
                #寫入簽核過程檔
                LET g_success = 'Y'
                BEGIN WORK
    #           LET l_oea[l_ac].oea01=l_oea[l_ac].oea01[1,10] 
                LET l_oea[l_ac].oea01=l_oea[l_ac].oea01[1,g_no_ep]   #No.FUN-550058 
                INSERT INTO azd_file(azd01,azd02,azd03,azd04)
                    VALUES(l_oea[l_ac].oea01,25,g_pass,g_today)
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N' 
#                  CALL cl_err('ckp#2',SQLCA.sqlcode,1)   #No.FUN-660131
                   CALL cl_err3("ins","azd_file",l_oea[l_ac].oea01,g_pass,SQLCA.sqlcode,"","ckp#2",1)    #No.FUN-660131
                END IF
                #請記得要改單據性質 ----------+
                #更新已簽核順序
{chkp#1}        UPDATE oea_file
                    SET oeasseq=oeasseq+1
                    WHERE oea01=l_oea[l_ac].oea01
                UPDATE oea_file
                    SET oea49='1'
                    WHERE oea01=l_oea[l_ac].oea01 AND
                          oeasseq=oeasmax
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N' 
#                  CALL cl_err('ckp#1',SQLCA.sqlcode,1)   #No.FUN-660131
                   CALL cl_err3("upd","oea_file",l_oea[l_ac].oea01,"",SQLCA.sqlcode,"","ckp#1",1)    #No.FUN-660131
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
    END WHILE
    CLOSE WINDOW u022_w
END FUNCTION
