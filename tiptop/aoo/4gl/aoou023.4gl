# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aoou023.4gl
# Descriptions...: 訂單變更簽核作業
# Date & Author..: 00/11/15 BY Kammy
# Modify.........: No.FUN-550058 05/05/28 By vivien 單據編號格式放大  
# Modify.........: No.TQC-630106 06/03/10 By Claire DISPLAY ARRAY無控制單身筆數
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
        g_pass          LIKE azd_file.azd03,          #No.FUN-680102 VARCHAR(8)
        g_cnt           LIKE type_file.num10,         #No.FUN-680102 INTEGER
        g_msg           LIKE type_file.chr1000,       #No.FUN-680102 VARCHAR(72)
        g_chr           LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)
END GLOBALS
 
DEFINE
    g_oep RECORD LIKE oep_file.*
 
FUNCTION u023()
 
    WHENEVER ERROR CONTINUE
#   IF NOT cl_prich2('aoou023','') THEN
    IF NOT cl_chk_act_auth() THEN
         RETURN
    END IF
    CALL u023_1()                      #接受選擇
END FUNCTION
 
#將資料選出, 並進行挑選
FUNCTION u023_1()
 
DEFINE
    l_ac         LIKE type_file.num5,                    #program array no        #No.FUN-680102 SMALLINT
    l_ok         LIKE type_file.chr1,           #No.FUN-680102  VARCHAR(1)               #判斷是否取得資料
    l_exit       LIKE type_file.chr1,           #No.FUN-680102  VARCHAR(1)
    l_sl         LIKE type_file.num5,           #No.FUN-680102  smallint              #screen array no
    l_sl2        LIKE type_file.num5,           #No.FUN-680102  smallint              #screen array no
    l_cnt        LIKE type_file.num5,           #所選擇筆數        #No.FUN-680102 SMALLINT
    l_cnt1       LIKE type_file.num5,           #所選擇筆數        #No.FUN-680102 SMALLINT
    l_key1       LIKE type_file.chr20,          #No.FUN-680102 VARCHAR(20)
    l_wc         LIKE type_file.chr1000,        #No.FUN-680102 VARCHAR(1000)
    l_sql        LIKE type_file.chr1000,        #RDSQL STATEMENT  #No.FUN-680102 VARCHAR(1000)  
    l_days,l_prit LIKE type_file.num5,           #No.FUN-680102  SMALLINT
    l_oep03 ARRAY[48] OF LIKE type_file.chr2,           #No.FUN-680102 VARCHAR(2) #更動序號
    l_needs ARRAY[48] OF LIKE type_file.num5,           #No.FUN-680102 SMALLINT
    l_oep DYNAMIC ARRAY OF RECORD               #結果
        choice      LIKE type_file.chr1,           #No.FUN-680102  VARCHAR(1)    #選擇碼
    #   oep01       VARCHAR(13),               #訂單變更單號
        oep01       LIKE oep_file.oep01,    #訂單變更單號   #No.FUN-550058
        oep02       LIKE oep_file.oep02,    #變更序號
        oep04       LIKE oep_file.oep04,    #變更日期
        oea032      LIKE oea_file.oea032,   #客戶簡稱
        oea23       LIKE oea_file.oea23,    #幣別
        oepsign     LIKE oep_file.oepsign,  #簽核等級
        oepdays     LIKE oep_file.oepdays,
        oepprit     LIKE oep_file.oepprit
              END RECORD
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
    #開窗讓使用者選擇
    LET p_row = 5 LET p_col = 24
    OPEN WINDOW u023_w AT p_row,p_col WITH FORM "aoo/42f/aoou023" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_locale("aoou023")
 
    WHILE TRUE
        IF s_shut(0) THEN EXIT WHILE END IF
        LET l_exit='Y'
        CALL cl_getmsg('aoo-051',g_lang) RETURNING g_msg
        DISPLAY g_msg AT 1,1          #顯示操作指引
        CALL cl_getmsg('aoo-052',g_lang) RETURNING g_msg
        DISPLAY g_msg AT 2,1          #顯示操作指引
        CLEAR FORM
        CONSTRUCT l_wc
            ON oep01,oep02,oep04,oea032,oea23,oepsign,oepdays,oepprit
            FROM s_oep[1].oep01,s_oep[1].oep02,s_oep[1].oep04,
                 s_oep[1].oea032,s_oep[1].oea23,s_oep[1].oepsign,
                 s_oep[1].oepdays,s_oep[1].oepprit  
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
  LET l_wc = l_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            EXIT WHILE
        END IF
#.......組合查詢句子
        LET l_sql = "SELECT '',oep01,oep02,oep04,oea032,oea23,",
                    #No.TQC-9B0035 --Begin
                   #" oepsign,(oep04+oepdays)-to_date(?),oepprit",
                    " oepsign,oepdays,oepprit",
                    #No.TQC-9B0035 --End  
                    " FROM oep_file,OUTER(oea_file)",
                    " WHERE oepsign IS NOT NULL AND",
                    " oepmksg='Y' AND",
                    " oepconf='Y' AND",
                    " oep01 = oea_file.oea01 AND ",
                    " oepacti='Y' AND ",l_wc CLIPPED,
#...............去選擇單據時,加這一句條件,可以得到該使用者該簽核而未簽核的單據
                    " AND oepsseq=(SELECT (azc02-1)",
                    " FROM azc_file WHERE azc01=oepsign AND azc03=",
                    "'",g_pass,"'"," )",
                    " ORDER BY 8,9 "
 
        PREPARE u023_prepare FROM l_sql      #預備之
        IF SQLCA.sqlcode THEN                          #有問題了
            CALL cl_err('PREPARE:',SQLCA.sqlcode,1)
            EXIT WHILE
        END IF
        DECLARE u023_cs CURSOR FOR u023_prepare     #宣告之
 
        CALL l_oep.clear()
        CALL l_needs.clear()
 
#       FOR g_cnt=1 TO l.getLength()
#           INITIALIZE l_oep[g_cnt].* TO NULL
#           INITIALIZE l_needs[g_cnt] TO NULL
#       END FOR
        LET g_cnt=1                                                #總選取筆數
        #No.TQC-9B0035  --Begin
        #FOREACH u023_cs USING g_today
        #INTO l_oep[g_cnt].*,l_needs[g_cnt]
        FOREACH u023_cs INTO l_oep[g_cnt].*
        #No.TQC-9B0035  --End  
            IF SQLCA.sqlcode THEN                                  #有問題
                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                EXIT FOREACH
            END IF
            #No.TQC-9B0035  --Begin
            LET l_oep[g_cnt].oepdays = l_oep[g_cnt].oepdays + l_oep[g_cnt].oep04 - g_today
            IF cl_null(l_oep[g_cnt].oepdays) THEN LET l_oep[g_cnt].oepdays = 0 END IF
            #No.TQC-9B0035  --End  
#...........取得是否需要閱後方可簽核
            SELECT aze07 INTO l_needs[g_cnt] FROM aze_file
             WHERE aze01=l_oep[g_cnt].oepsign
            IF SQLCA.sqlcode THEN LET l_needs[g_cnt]='' END IF
 
            LET l_oep[g_cnt].oep01=l_oep[g_cnt].oep01 CLIPPED
            LET g_cnt = g_cnt + 1                           #累加筆數
            IF g_cnt > g_max_rec THEN                         #超過肚量了
                CALL cl_err( '', 9035, 0 )    #TQC-630106
                EXIT FOREACH
            END IF
        END FOREACH
        IF g_cnt=1 THEN                                     #沒有抓到
            CALL cl_err('','aoo-004',1)                     #顯示錯誤,並回去
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
        DISPLAY ARRAY l_oep TO s_oep.*  #顯示並進行選擇
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
                    CALL cl_err('','aoo-021',1)
                ELSE
                    IF cl_null(l_oep[l_ac].choice) THEN 
                        LET l_oep[l_ac].choice='Y'          #設定為選擇
                        LET l_cnt=l_cnt+1                   #累加已選筆數
                    ELSE
                        LET l_oep[l_ac].choice=''           #設定為不選擇
                        LET l_cnt=l_cnt-1                   #減少已選筆數
                    END IF
                    DISPLAY l_oep[l_ac].choice TO 
                            s_oep[l_sl].choice 
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
                FOR l_ac = 1 TO g_cnt               #將所有的設為選擇
                    IF l_ac=l_sl2 THEN
                        LET l_sl=1
                    ELSE
                        IF l_ac > l_sl2 THEN
                            LET l_sl=l_sl+1
                        END IF
                    END IF
                    IF l_needs[l_ac] != 'Y' THEN
                        LET l_oep[l_ac].choice=l_ok
                        IF l_sl < 12 AND l_sl > 0 THEN
                            DISPLAY l_oep[l_ac].choice TO s_oep[l_ac].choice
                                
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
              #----------No.TQC-610089 modify
                LET l_wc = ' oep01 = ',' "',l_oep[l_ac].oep01,'" '
               #LET l_sql="axmr800 '",g_today,"' '' '",g_lang,"'",
               #    " 'Y' 'D' '1' ' oep01="
               #LET l_sql=l_sql CLIPPED,'"',l_oep[l_ac].oep01[1,10],'" '
               #LET l_sql=l_sql CLIPPED,"' '3' 'N'"
                LET l_sql = 'axmr800 ','"',g_today,'"',
                            ' "" "',g_lang,'" "Y" "D" "1" ',
                            "'",l_wc clipped,"'",' "3" ' clipped
              #----------No.TQC-610089 end
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
        IF l_cnt < 1 THEN                 #已選筆數超過 0筆
            CONTINUE WHILE
        END IF
        IF NOT cl_sure(0,0) THEN
            CONTINUE WHILE
        END IF
        CALL cl_wait()
        LET l_sl=0
        FOR l_ac=1 TO g_cnt
            IF l_oep[l_ac].choice='Y' THEN          #該單據要簽核
                #寫入簽核過程檔
                LET g_success = 'Y'
                BEGIN WORK
{ckp#2}         LET l_key1=l_oep[l_ac].oep01 CLIPPED
{ckp#2}         LET l_key1=l_key1 CLIPPED,l_oep[l_ac].oep02 USING '&&' CLIPPED 
                INSERT INTO azd_file(azd01,azd02,azd03,azd04)
                              VALUES(l_key1,26,g_pass,g_today)
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N' 
#                  CALL cl_err('ckp#2',SQLCA.sqlcode,1)   #No.FUN-660131
                   CALL cl_err3("ins","azd_file",l_key1,g_pass,SQLCA.sqlcode,"","ckp#2",1)    #No.FUN-660131
                END IF
                #請記得要改單據性質 ----------+
{ckp#1}         UPDATE oep_file
                    SET oepsseq=oepsseq+1
                    WHERE oep01=l_oep[l_ac].oep01
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N' 
 #                  CALL cl_err('ckp#1',SQLCA.sqlcode,1)    #No.FUN-660131
                    CALL cl_err3("upd","oep_file",l_oep[l_ac].oep01,"",SQLCA.sqlcode,"","ckp#1",1)       #No.FUN-660131
                END IF
 {ckp#3}        UPDATE oep_file
                    SET oep09='1'
                    WHERE oep01=l_oep[l_ac].oep01 AND
                          oepsseq=oepsmax
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N' 
#                   CALL cl_err('ckp#3',SQLCA.sqlcode,1)   #No.FUN-660131
                    CALL cl_err3("upd","oep_file",l_oep[l_ac].oep01,"",SQLCA.sqlcode,"","ckp#3",1)        #No.FUN-660131
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
    CLOSE WINDOW u023_w
END FUNCTION
