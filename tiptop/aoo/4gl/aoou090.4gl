# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aoou090.4gl
# Descriptions...: E.C.R.單資料簽核作業
# Date & Author..: 92/05/15 By Jones
# Modify.........: 92/09/24 By Pin
#                  簽核處理修正(順序以簽核剩餘天數,簽核完成天數來排)
#                  因劃面編幅有限,無法顯示剩餘天數與簽核完成天數
# Modify.........: No.MOD-4B0058 04/12/06 By Echo  aoos010設定不使用 EasyFlow 但單據設定需簽核(使用tiptop簡易簽核)
# Modify.........: No.FUN-550058 05/05/28 By vivien 單據編號格式放大  
# Modify.........: No.TQC-610068 06/01/20 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換
#
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
     DEFINE
        g_pass          LIKE azd_file.azd03,           #No.FUN-680102 VARCHAR(08),
        g_cnt           LIKE type_file.num10,          #No.FUN-680102 INTEGER
        g_msg           LIKE type_file.chr1000,        #No.FUN-680102 VARCHAR(72),
        g_chr           LIKE type_file.chr1            #No.FUN-680102 VARCHAR(1)
END GLOBALS
 
FUNCTION u090()
 
    WHENEVER ERROR CONTINUE
 
#    IF NOT cl_prich2('aoou090','') THEN
#    IF NOT cl_chk_act_auth() THEN
#         RETURN
#    END IF
    CALL u090_1()                      #接受選擇
END FUNCTION
 
#將資料選出, 並進行挑選
FUNCTION u090_1()
DEFINE
# genero  script marked     l_arrno      LIKE type_file.num5,           #No.FUN-680102   SMALLINT,           #program array no
    l_ac         LIKE type_file.num5,        #program array no        #No.FUN-680102 SMALLINT
    l_ok         LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01),                #判斷是否取得資料
    l_exit       LIKE type_file.chr1,        #No.FUN-680102CHAR(01),
    l_sl         LIKE type_file.num5,        #No.FUN-680102 SMALLINT,           #screen array no
    l_sl2        LIKE type_file.num5,        #No.FUN-680102 SMALLINT,            #screen array no
    l_cnt        LIKE type_file.num5,        #所選擇筆數        #No.FUN-680102 SMALLINT
    l_cnt1       LIKE type_file.num5,        #所選擇筆數        #No.FUN-680102 SMALLINT
    l_wc         LIKE type_file.chr1000,     #No.FUN-680102CHAR(1000),
    l_sql        LIKE type_file.chr1000,     #RDSQL STATEMENT        #No.FUN-680102CHAR(1000),
    l_days,l_prit LIKE type_file.num5,       #No.FUN-680102SMALLINT,
    l_needs ARRAY[48] OF LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01), #是否需要閱後方可簽核
    l_bmr DYNAMIC ARRAY OF RECORD               #結果
        choice      LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01),             #選擇碼
        bmr01       LIKE bmr_file.bmr01,    #E.C.R.單號
        bmr02       LIKE bmr_file.bmr02,    #填單日期
		gen02       LIKE gen_file.gen02,    #申請部門
		gem02       LIKE gem_file.gem02,    #申請部門
        bmrsign     LIKE bmr_file.bmrsign,  #簽核等級
        bmrdays     LIKE bmr_file.bmrdays,
        bmrprit     LIKE bmr_file.bmrprit
              END RECORD
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE g_i             LIKE type_file.num5,                #可新增否        #No.FUN-680102 SMALLINT
       l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680102 SMALLINT
       l_allow_delete  LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
    LET p_row = 5 LET p_col = 24
    OPEN WINDOW u090_w AT p_row,p_col                    #開窗讓使用者選擇
        WITH FORM "aoo/42f/aoou090" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_locale("aoou090")
 
    WHILE TRUE
        IF s_shut(0) THEN EXIT WHILE END IF
        LET l_exit='Y'
        CALL cl_getmsg('aoo-051',g_lang) RETURNING g_msg
        DISPLAY g_msg AT 1,1          #顯示操作指引
        CALL cl_getmsg('aoo-052',g_lang) RETURNING g_msg
        DISPLAY g_msg AT 2,1          #顯示操作指引
        CLEAR FORM
        CALL cl_set_comp_visible("select_all,cancel_all,cmt",FALSE)
        CONSTRUCT l_wc ON bmr01,bmr02,gen02,gem02,bmrsign,bmrdays,bmrprit
            FROM s_bmr[1].bmr01,s_bmr[1].bmr02,
                 s_bmr[1].gen02,s_bmr[1].gem02,s_bmr[1].bmrsign,     
                 s_bmr[1].bmrdays,s_bmr[1].bmrprit       
 
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
  LET l_wc = l_wc CLIPPED,cl_get_extra_cond('bmruser', 'bmrgrup') #FUN-980030
 
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            EXIT WHILE
        END IF
        LET l_sql = "SELECT ",                      #組合查詢句子
#---->modify by pin ----->(bmr02+bmrdays)-to_date(?)
            "'N', bmr01,bmr02,gen02,gem02,bmrsign,bmrdays,bmrprit",
            " FROM bmr_file,gen_file,gem_file",
            " WHERE bmrsign IS NOT NULL AND",
            " bmracti='Y'",
            " AND bmr06 = gen01 AND gen03 = gem01",
            " AND bmr49 = 'S' AND bmr48='Y' ",
            " AND ",l_wc CLIPPED ,
            #-[這一句話很重要]-----------------------------------------------
            #去選擇單據時, 加這一句條件, 可以得到該使用者該簽核而未簽核的單據
            " AND bmrsseq=(SELECT (azc02-1)", #已簽核順序=順序-1
            " FROM azc_file WHERE azc01=bmrsign AND azc03='",g_pass,"')",
            " ORDER BY 7,8 "
            #庫存調撥單單頭檔之簽核等級等於簽核等級檔中之簽核等級
			#且簽核等級檔中之人員代碼等於所輸入之人員代碼
        PREPARE u090_prepare FROM l_sql      #預備之
        IF SQLCA.sqlcode THEN                          #有問題了
            CALL cl_err('PREPARE:',SQLCA.sqlcode,1)
            EXIT WHILE
        END IF
        DECLARE u090_curs CURSOR FOR u090_prepare     #宣告之
 
        CALL l_bmr.clear()
 
#       FOR g_cnt=1 TO l.getLength()
#           INITIALIZE l_bmr[g_cnt].* TO NULL
#       END FOR
        LET g_cnt=1                                         #總選取筆數
        FOREACH u090_curs  #USING g_today
            INTO l_bmr[g_cnt].*,l_days,l_prit
            IF SQLCA.sqlcode THEN                                  #有問題
                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                EXIT FOREACH
            END IF
            LET l_bmr[g_cnt].bmrdays = l_bmr[g_cnt].bmr02 - g_today + l_bmr[g_cnt].bmrdays
#           ERROR 'l_days,l_prit,l_bmr[g_cnt].bmr01',l_days,l_prit,
#                  ' ',l_bmr[g_cnt].bmr01 sleep 3
#取得是否需要閱後方可簽核
            SELECT aze07 INTO l_needs[g_cnt]   #簽核等級單頭檔
                FROM aze_file
                WHERE aze01=l_bmr[g_cnt].bmrsign
            IF SQLCA.sqlcode THEN
                LET l_needs[g_cnt]=''
            END IF
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
        CALL l_bmr.deleteElement(g_cnt)
        LET g_cnt=g_cnt-1                                   #正確的總筆數
        CALL SET_COUNT(g_cnt)                               #告之DISPALY ARRAY
        CALL cl_getmsg('aoo-050',g_lang) RETURNING g_msg
        DISPLAY "" AT 1,1             #清除不要的資訊
        DISPLAY g_msg AT 2,1          #顯示操作指引
        DISPLAY g_cnt TO FORMONLY.cnt  #顯示總筆數
        LET l_cnt=0                                     #已選筆數
        DISPLAY l_cnt TO FORMONLY.cmt 
       #CALL cl_set_act_visible("accept,cancel", FALSE)
        LET l_allow_insert = FALSE
        LET l_allow_delete = FALSE
 
        LET l_ac = 1
        CALL cl_set_comp_visible("select_all,cancel_all,cmt",TRUE)
        INPUT ARRAY l_bmr WITHOUT DEFAULTS FROM s_bmr.*
               ATTRIBUTE(COUNT=g_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
          BEFORE INPUT
              IF g_cnt != 0 THEN
                CALL fgl_set_arr_curr(l_ac)
          END IF
 
          BEFORE ROW
              LET l_ac = ARR_CURR()
 
          ON CHANGE choice
             IF NOT cl_null(l_bmr[l_ac].choice) THEN
                IF l_bmr[l_ac].choice NOT MATCHES "[YN]" THEN
                     NEXT FIELD choice
                END IF
                LET l_cnt = 0
                FOR g_i =1 TO g_cnt
                 IF l_bmr[g_i].choice = 'Y' THEN
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
                   LET l_bmr[g_i].choice = 'Y'
                   DISPLAY BY NAME l_bmr[g_i].choice
                   LET l_cnt = l_cnt +1
               END FOR
               display l_cnt TO FORMONLY.cmt
 
            ON ACTION cancel_all
               FOR g_i = 1 TO g_cnt     #將所有的設為選擇
                   LET l_bmr[g_i].choice="N"
               END FOR
               LET l_cnt = 0
               DISPLAY l_cnt TO FORMONLY.cmt
 {
            ON ACTION select_cancel  #選擇或取消
                LET l_ac = ARR_CURR()
                LET l_sl = SCR_LINE()
                IF l_needs[l_ac]='Y' THEN
                    CALL cl_err('','aoo-021',0)
                ELSE
                    IF cl_null(l_bmr[l_ac].choice) THEN
                        LET l_bmr[l_ac].choice='Y'          #設定為選擇
                        LET l_cnt=l_cnt+1                   #累加已選筆數
                    ELSE
                        LET l_bmr[l_ac].choice=''           #設定為不選擇
                        LET l_cnt=l_cnt-1                   #減少已選筆數
                    END IF
                    DISPLAY l_bmr[l_ac].choice TO
                        s_bmr[l_sl].choice 
                    DISPLAY l_cnt TO FORMONLY.cmt 
                END IF
            ON ACTION select_all #整批
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
                        LET l_bmr[l_ac].choice=l_ok
                        IF l_sl < 12 AND l_sl > 0 THEN
                            DISPLAY l_bmr[l_ac].choice TO s_bmr[l_sl].choice
                            
                        END IF
                    ELSE
                        LET l_cnt1=l_cnt1+1               #設定已選筆數
                    END IF
                END FOR
                IF l_ok='Y' THEN
                    LET l_cnt=l_cnt-l_cnt1
                END IF
                DISPLAY l_cnt TO FORMONLY.cmt 
}
            ON ACTION view_report  #查詢單據內容
                CALL cl_wait()
                LET l_ac = ARR_CURR()
               #TQC-610068-begin
               # LET l_sql="abmr901 '",g_today,"' '' '",g_lang,"'",
               #     " 'Y' 'D' '1' ' bmr01="
                 LET l_sql = "abmr901 '",g_today,"' '",g_user,"' '",g_lang,"' ",
                     " 'Y' 'D' '1' '",l_bmr[l_ac].bmr01,"' 'Y' 'Y' "
               #TQC-610068-end
         ## 若在 GUI 的環境下將 'D':pg 改為 'V':dsview
          --# CALL fgl_init4js()
          --# IF fgl_fglgui()>0  # GUI OR WEB
          --#    THEN
          --#    LET l_sql="abmr901 '",g_today,"' '' '",g_lang,"'",
          --#       " 'Y' 'V' '1' ' bmr01="
          --# END IF
 
            #   LET l_sql=l_sql CLIPPED,'"',l_bmr[l_ac].bmr01[1,10],'"'
                LET l_sql=l_sql CLIPPED,'"',l_bmr[l_ac].bmr01[1,g_no_ep],'"'   #No.FUN-550058
                LET l_sql=l_sql CLIPPED, "' 'N' 'N'"
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
      #  CALL cl_set_act_visible("accept,cancel", TRUE)
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
            IF l_bmr[l_ac].choice='Y' THEN          #該單據要簽核
                #寫入簽核過程檔
                LET g_success = 'Y'
                BEGIN WORK
            #   LET l_bmr[l_ac].bmr01=l_bmr[l_ac].bmr01[1,10]
                LET l_bmr[l_ac].bmr01=l_bmr[l_ac].bmr01[1,g_no_ep]   #No.FUN-550058
   {ckp#1}      INSERT INTO azd_file(azd01,azd02,azd03,azd04)
                    VALUES(l_bmr[l_ac].bmr01,10,g_pass,g_today)
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N' 
                   CALL cl_err('ckp#1',SQLCA.sqlcode,1)
                END IF
                #請記得要改單據性質 ----------+
                #更新已簽核順序
   {ckp#2}      UPDATE bmr_file      #將已簽核等級加 1
                    SET bmrsseq=bmrsseq+1    
                    WHERE bmr01=l_bmr[l_ac].bmr01
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N' 
                   CALL cl_err('ckp#2',SQLCA.sqlcode,1)
                END IF
   {ckp#3}      UPDATE bmr_file
                    SET bmr49='1'
                    WHERE bmr01=l_bmr[l_ac].bmr01 AND
                          bmrsseq=bmrsmax #若已簽等級等於應簽等級時
									      #update 簽核否為'Y'			
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N' 
                   CALL cl_err('ckp#3',SQLCA.sqlcode,1)
                END IF
                #更改單身之狀況碼
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
        EXIT WHILE
    END WHILE
    CLOSE WINDOW u090_w
END FUNCTION
