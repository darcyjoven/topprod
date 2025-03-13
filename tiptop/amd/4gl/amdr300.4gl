# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: amdr300.4gl
# Descriptions...: 進銷項媒體錯誤檢查程式
# Date & Author..: 96/06/13 By Joan
# Modify.........: No.9017 04/01/12 By Kitty plant長度修改
# Modify.........: No.9739 04/07/09 By Nicola 報表中"發票日"欄位,在非作廢或空白發票應印發票年月,而非資料年月
# Modify.........: No.FUN-510019 05/01/11 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-580098 05/10/26 By CoCo BOTTOM MARGIN g_bottom_margin改5
# Modify.........: No.FUN-660060 06/06/26 By rainy 期間置於中間
# Modify.........: No.FUN-680074 06/08/24 By huchenghao 類型轉換
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0116 06/11/08 By king 改正報表中有關錯誤
# Modify.........: No.TQC-6A0093 06/11/09 By Carrier 接下線沒有打印
# Modify.........: No.TQC-710009 07/01/04 By Rayven 報表同時打印出接下頁及結束字樣
# Modify.........: No.FUN-750098 07/06/06 By hongmei Crystal Report修改
# Modify.........: No.MOD-960055 09/06/04 By Sarah 應抓目前所在DB的zo_file資料
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A90057 10/09/08 By Dido 發票字軌檢核應排除聯數為 '0','4','X' 資料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc     LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(1000)
           byy    LIKE type_file.num5,       #No.FUN-680074 SMALLINT
           bmm    LIKE type_file.num5,       #No.FUN-680074 SMALLINT
           eyy    LIKE type_file.num5,       #No.FUN-680074 SMALLINT
           emm    LIKE type_file.num5,       #No.FUN-680074 SMALLINT
           ama08  LIKE ama_file.ama08,
           ama09  LIKE ama_file.ama09
           END RECORD,
       g_idx      LIKE type_file.num10,      #No.FUN-680074 INTEGER
       g_ary      DYNAMIC ARRAY OF RECORD
	   plant   LIKE azp_file.azp01,      #No.FUN-680074 VARCHAR(10) #No:9017
	   dbs_new LIKE type_file.chr21      #No.FUN-680074 VARCHAR(21)
	   END RECORD,
       g_zo06  LIKE zo_file.zo06,            #No.FUN-680074 VARCHAR(08)
       g_zo11  LIKE zo_file.zo11              #No.FUN-680074 VARCHAR(09)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680074 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680074 VARCHAR(72)
DEFINE   g_str           STRING       #No.FUN-750098
DEFINE   l_table         STRING       #No.FUN-750098
DEFINE   g_sql           STRING       #No.FUN-750098
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
   #No.FUN-750098-------Begin
   LET g_sql = " amd171.amd_file.amd171,",
               " amd28.amd_file.amd28,",
               " amd01.amd_file.amd01,",
               " amd03.amd_file.amd03,",
               " amd04.amd_file.amd04,",
               " amd05.amd_file.amd05,",
               " amd172.amd_file.amd172,",
               " amd08.amd_file.amd08,",
               " amd07.amd_file.amd07,",
               " apk25.apk_file.apk25,",
               " mark1.type_file.chr1,",
               " mark2.type_file.chr1,",
               " mark3.type_file.chr1,",
               " mark4.type_file.chr1,",
               " mark5.type_file.chr1,",
               " mark6.type_file.chr1,",
               " mark8.type_file.chr1"
 
   LET l_table = cl_prt_temptable('amdr300',g_sql) CLIPPED                                                               
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   
               " VALUES(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF           
   #No.FUN-750098---------End
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
{-->genero拿掉azq部份
 
   DECLARE m_plant_c CURSOR FOR
     SELECT azq01,azp03
       FROM azq_file,azp_file
     WHERE azp01=azq01 AND azq03 = 'AAP'
       AND azp053 != 'N' #no.7431
     ORDER BY 1
   LET g_idx = 1
   FOREACH m_plant_c INTO g_ary[g_idx].plant,g_ary[g_idx].dbs_new
      IF g_idx >= 9 THEN EXIT FOREACH END IF
      LET g_idx = g_idx + 1
   END FOREACH
}
   SELECT zo06,zo11 INTO g_zo06,g_zo11
  #  FROM ds07.dbo.zo_file   #MOD-960055 mark
     FROM zo_file        #MOD-960055
    WHERE zo01=g_lang
   LET tm.byy = ARG_VAL(1)
   LET tm.bmm = ARG_VAL(2)
   LET tm.eyy = ARG_VAL(3)
   LET tm.emm = ARG_VAL(4)
   CALL r300_tm(0,0)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION r300_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680074 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680074 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 6 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 4 LET p_col = 16
   ELSE LET p_row = 6 LET p_col = 15
   END IF
   OPEN WINDOW r300_w AT p_row,p_col
        WITH FORM "amd/42f/amdr300"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.byy=YEAR(g_today)
   LET tm.eyy=YEAR(g_today)
   LET tm.bmm=MONTH(g_today)
   LET tm.emm=MONTH(g_today)
   LET tm.ama08= tm.eyy
   LET tm.ama09= tm.emm
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON amd28,amd172,amd171
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
      
   END IF
   INPUT BY NAME tm.byy,tm.bmm,tm.eyy,tm.emm,tm.ama08,tm.ama09
		 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD byy
         IF cl_null(tm.byy) THEN NEXT FIELD byy END IF
      AFTER FIELD bmm
         IF cl_null(tm.bmm) THEN NEXT FIELD bmm END IF
         IF tm.bmm > 12 OR tm.bmm < 1 THEN NEXT FIELD bmm END IF
      AFTER FIELD eyy
         IF cl_null(tm.eyy) THEN NEXT FIELD eyy END IF
         IF tm.eyy < tm.byy THEN NEXT FIELD eyy END IF
      AFTER FIELD emm
         IF cl_null(tm.emm) THEN NEXT FIELD emm END IF
         IF tm.emm > 12 OR tm.emm < 1 THEN NEXT FIELD emm END IF
         IF tm.byy+tm.bmm > tm.eyy+tm.emm THEN
            NEXT FIELD emm
         END IF
	 IF tm.emm = 12 THEN
            LET tm.ama08= tm.eyy + 1
	    LET tm.ama09= 1
         ELSE
            LET tm.ama08= tm.eyy
            LET tm.ama09= tm.emm + 1
         END IF
         DISPLAY BY NAME tm.ama08,tm.ama09
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM 
   END IF
   CALL cl_wait()
   CALL r300()
   ERROR ""
END WHILE
   CLOSE WINDOW r300_w
END FUNCTION
 
FUNCTION r300()
   DEFINE l_name    LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0068
          l_sql     STRING,                    # RDSQL STATEMENT        #No.FUN-680074
          l_amb03   LIKE amb_file.amb03,
	  l_flag    LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
	  l_stat    LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
          l_num,l_yy,l_mm   LIKE type_file.num5,       #No.FUN-680074 SMALLINT
          l_byy     LIKE type_file.num10,      #INTEGER    #No.FUN-750098
          l_eyy     LIKE type_file.num10,      #INTEGER    #No.FUN-750098
          sr        RECORD
                    amd171  LIKE amd_file.amd171, #格式
                    ama03   LIKE ama_file.ama03,  #稅籍編號
                    amd175  LIKE amd_file.amd175, #流水號
                    amd173  LIKE amd_file.amd173, #年度
                    amd174  LIKE amd_file.amd174, #月份
                    ama02   LIKE ama_file.ama02,  #買方統一編號
                    amd04   LIKE amd_file.amd04,  #賣方統一編號
                    amd03   LIKE amd_file.amd03,  #發票編號
                    amd031  LIKE amd_file.amd031, #發票聯數        #MOD-A90057
                    amd08   LIKE amd_file.amd08,  #扣抵金額
                    amd172  LIKE amd_file.amd172, #課稅別
                    amd07   LIKE amd_file.amd07,  #扣抵稅額
                    amd17   LIKE amd_file.amd17,  #扣抵代號
                    amd09   LIKE amd_file.amd09,  #彙加註記
                    amd10   LIKE amd_file.amd10,  #洋菸酒註記
	            amd01   LIKE amd_file.amd01,
	            amd02   LIKE amd_file.amd02,
	            amd28   LIKE amd_file.amd28,
	            amd05   LIKE amd_file.amd05,
                    amd05y  LIKE amd_file.amd173,     #No.FUN-680074  VARCHAR(2)#No:9739
                    amd05m  LIKE amd_file.amd174,     #No.FUN-680074  VARCHAR(2)#No:9739
	            mark1  LIKE type_file.chr1,       #No.FUN-680074  VARCHAR(1)   #無傳票號碼
	            mark2  LIKE type_file.chr1,       #No.FUN-680074  VARCHAR(1)   #格式為空白
	            mark3  LIKE type_file.chr1,       #No.FUN-680074  VARCHAR(1)   #資料年度/月份為空白
	            mark4  LIKE type_file.chr1,       #No.FUN-680074  VARCHAR(1)   #稅額事後 * 0.05 > 1
	            mark5  LIKE type_file.chr1,       #No.FUN-680074  VARCHAR(1)   #發票號碼為空白
	            mark6  LIKE type_file.chr1,       #No.FUN-680074  VARCHAR(1)   #稅額錯誤
	            mark7  LIKE type_file.chr1,       #No.FUN-680074  VARCHAR(1)   #統一編號錯誤
                    mark8  LIKE type_file.chr1,       #No.FUN-680074  VARCHAR(1)   #統一編號錯誤
                    apk25  LIKE type_file.chr20       #No.FUN-680074  VARCHAR(18)
                    END RECORD
#No.FUN-750098 -- begin --
{  DEFINE sr1 RECORD
              amd171 LIKE amd_file.amd171,
              amd28  LIKE amd_file.amd28,
              amd01  LIKE amd_file.amd01,
              amd03  LIKE amd_file.amd03,
              amd04  LIKE amd_file.amd04,
              amd05  LIKE amd_file.amd05,
              amd172 LIKE amd_file.amd172,
              amd08  LIKE amd_file.amd08,
              amd07  LIKE amd_file.amd07,
              apk25  LIKE apk_file.apk25,
              mark1  LIKE type_file.chr1,
              mark2  LIKE type_file.chr1,
              mark3  LIKE type_file.chr1,
              mark4  LIKE type_file.chr1,
              mark5  LIKE type_file.chr1,
              mark6  LIKE type_file.chr1,
              mark7  LIKE type_file.chr1,
              mark8  LIKE type_file.chr1
              END RECORD
}
#No.FUN-750098 -- end --
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 120 END IF
#   FOR g_i = 1 TO g_len            #750098 
#      LET g_dash[g_i,g_i] = '='  #750098
#   END FOR                                       
#   CALL cl_outnam('amdr300') RETURNING l_name      #No.FUN-750098
#   START REPORT r300_rep TO l_name                 #No.FUN-750098
    #No.FUN-750098------Begin
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    #No.FUN-750098------End
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET tm.wc = tm.wc clipped," AND amduser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET tm.wc = tm.wc clipped," AND amdgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc = tm.wc clipped," AND amdgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('amduser', 'amdgrup')
    #End:FUN-980030
 
    #-->進項
    LET l_sql = "SELECT amd171,ama03,amd175,amd173,amd174,ama02,amd04,",
               #" amd03,amd08,amd172,amd07,amd17,amd09,amd10,",              #MOD-A90057 mark
                " amd03,amd031,amd08,amd172,amd07,amd17,amd09,amd10,",       #MOD-A90057
                " amd01,amd02,amd28,",
                " amd05,'','','','','','','','','','',''",
                "  FROM amd_file,",
                " OUTER ama_file ",
                 " WHERE amd_file.amd22= ama_file.ama01 ",
                "   AND (amd173*12+amd174) BETWEEN ",
                     (tm.byy*12+tm.bmm)," AND ",
                     (tm.eyy*12+tm.emm),
                "   AND  amd17 IN ('1','2')    ",
                "   AND  amd172 IN ('1','2','3')  ",
                "   AND ",tm.wc CLIPPED
    PREPARE r300_prepare1 FROM l_sql        
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
       EXIT PROGRAM
    END IF
    DECLARE r300_curs1 CURSOR FOR r300_prepare1 
     
    LET l_byy = tm.byy - 1911                      #No.FUN-750098
    LET l_eyy = tm.eyy - 1911                      #No.FUN-750098
    LET l_stat = 'N'
    LET sr.mark1 = NULL
    LET sr.mark2 = NULL
    LET sr.mark3 = NULL
    LET sr.mark4 = NULL
    LET sr.mark5 = NULL
    LET sr.mark6 = NULL
    LET sr.mark8 = NULL 
    FOREACH r300_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET l_flag='N'
       IF (sr.amd171='21' OR sr.amd171='25' OR sr.amd171 = '22') THEN
           SELECT apk25 into sr.apk25 from apk_file
            WHERE apk01 = sr.amd01 AND apk02 = sr.amd02
       END IF
       #----(1)-----無傳票編號-------
       IF sr.amd28=' ' OR sr.amd28 IS NULL THEN
          LET sr.mark1='*'
          LET l_flag='Y'
       END IF
       #----(2)-----申報格式空白/不為'21'/'22'/'25'-----
       IF sr.amd171=' '  OR sr.amd171 IS NULL AND NOT
         (sr.amd171='21' OR sr.amd171='22' OR sr.amd171='23' OR
          sr.amd171='24' OR sr.amd171='25' OR sr.amd171='28' OR sr.amd171='29' OR
          sr.amd171='31' OR sr.amd171='32' OR sr.amd171='33' OR
          sr.amd171='34' OR sr.amd171='35' OR sr.amd171='36') THEN
          LET sr.mark2='*'
          LET l_flag='Y'
       END IF
       #----(3)(4)--資料年度空白 --------------
       IF cl_null(sr.amd173) OR cl_null(sr.amd174) THEN
          LET sr.mark3='*'
          LET l_flag='Y'
       END IF
       #----(5)-----未稅金額 --------------
       IF sr.amd172 = '1' THEN              #稅額
          IF (sr.amd08*0.05-sr.amd07)>1 THEN
             LET sr.mark4='*'
             LET l_flag='Y'
          END IF
       END IF
       #----(6)-----申報格式21/25但發票號碼空白------------
       IF (sr.amd171='21' OR sr.amd171='25' OR sr.amd171='28' OR sr.amd171='29' ) AND   #bug no:7393
          (sr.amd03=' ' OR sr.amd03 IS NULL ) THEN
          LET sr.mark5='*'
          LET l_flag='Y'
       END IF
       #----(6-2)-----格式為 28/29 時，要為14碼其他為10碼--------
       #BUGNO4197
       LET l_num = LENGTH(sr.amd03)
       IF sr.amd171 = '28' OR sr.amd171 = '29'  #bug no:7393
       THEN
          IF l_num != 14 THEN LET sr.mark5='*' LET l_flag = 'Y' END IF
       ELSE
         #IF l_num != 10 THEN LET sr.mark5='*' LET l_flag = 'Y' END IF     #MOD-A90057 mark
         #-MOD-A90057-add-
          IF l_num != 10 AND (sr.amd031='2' OR sr.amd031='3') THEN 
             LET sr.mark5='*' 
             LET l_flag = 'Y' 
          END IF
         #-MOD-A90057-end-
       END IF
       #BUGNO4197..end
       #----(7)-----是不為正確的發票字軌------------
      #IF (sr.amd171='21' OR sr.amd171='25')   THEN                                     #MOD-A90057 mark
       IF (sr.amd171='21' OR sr.amd171='25') AND (sr.amd031='2' OR sr.amd031='3') THEN  #MOD-A90057
          LET l_amb03=sr.amd03[1,2]
          IF l_amb03!=' ' AND l_amb03 IS NOT NULL THEN
             IF sr.amd03[3,3] matches "[1234567890]" THEN
                LET l_yy = YEAR(sr.amd05)
                LET l_mm = MONTH(sr.amd05)
                CALL s_apkchk(l_yy,l_mm,l_amb03,sr.amd171)
                   RETURNING g_errno,g_msg
                IF g_errno MATCHES '[1234]' THEN
                   IF g_errno='4'  THEN
                      LET sr.mark2='*'
                   ELSE
                     LET sr.mark3='*'
                   END IF
                   LET sr.mark5='*'
                   LET l_flag='Y'
                END IF
             ELSE
                LET sr.mark5='*'
                LET l_flag='Y'
             END IF
          END IF
       END IF
       #----(8)-----稅額------------
       IF sr.amd172 = '1' THEN
          IF sr.amd07 = 0  THEN LET sr.mark6='*' LET l_flag='Y' END IF
       ELSE
          IF sr.amd07 != 0 THEN LET sr.mark6='*' LET l_flag='Y' END IF
       END IF
       #BUGNO4197
       #----(9)-----申報格式不為'22''28''29'且廠商統一編號為空白或null-----
       IF sr.amd171!='22' AND sr.amd171!='28' AND sr.amd171!='29' AND  #bug no:7393
          (sr.amd04=' ' OR sr.amd04 IS NULL) THEN
          LET sr.mark8='*'
          LET l_flag='Y'
       END IF
       #----(10)-----統一編號為空白或null-----
       IF sr.amd171!='22' AND sr.amd171!='28' AND sr.amd171!='29' THEN #bug no:7393
          IF NOT s_chkban(sr.amd04) THEN
             LET sr.mark8='*'
             LET l_flag='Y'
          END IF
       END IF
       #----(11)-----格式為 22 時，不為正確的發票字軌------------
       IF sr.amd171='22' THEN
          IF sr.amd172 = '2' THEN   #no:6374:sr.amd17 = '3'拿掉
             SLEEP 0
          ELSE
             IF sr.amd031='2' OR sr.amd031='3' THEN              #MOD-A90057
                LET l_amb03=sr.amd03[1,2]
                IF l_amb03!=' ' AND l_amb03 IS NOT NULL THEN
                   IF sr.amd03[3,3] matches "[1234567890]" THEN
                      LET l_yy = YEAR(sr.amd05)
                      LET l_mm = MONTH(sr.amd05)
                      CALL s_apkchk(l_yy,l_mm,l_amb03,sr.amd171)
                         RETURNING g_errno,g_msg
                      IF g_errno MATCHES '[1234]' THEN
                         IF g_errno='4'  THEN
                            LET sr.mark2='*'
                         ELSE
                            LET sr.mark3='*'
                         END IF
                         LET sr.mark5='*'
                         LET l_flag='Y'
                      END IF
                   ELSE
                      LET sr.mark5='*'
                      LET l_flag='Y'
                   END IF
                ELSE
                   LET sr.mark5='*'
                   LET l_flag='Y'
                END IF
             END IF                                              #MOD-A90057
          END IF
       END IF
       #----(12)-----扣抵為 '3' ，稅額為 '2' 不檢查統一編號是否完整性
       #             且為銷項不用 check
       IF sr.amd171[1,1] matches '2*' AND sr.amd171!='28' AND sr.amd171!='29'  THEN  #bug no:7393
          IF sr.amd17 = '3' AND sr.amd172= '2' THEN
             SLEEP 0
          ELSE
             IF NOT s_chkban(sr.amd04) THEN
                LET sr.mark8='*'
                LET l_flag='Y'
             END IF
          END IF
       END IF
       #----(13)-----格式 36/31/32/35 時，判斷資料年月與發票需同一月份
       IF sr.amd171 = '36' OR sr.amd171 ='31' OR
          sr.amd171 = '32' OR sr.amd171 = '35' THEN
          LET l_yy = YEAR(sr.amd05)
          LET l_mm = MONTH(sr.amd05)
          IF (l_yy * 12 + l_mm) != (sr.amd173 * 12 + sr.amd174) THEN
             LET sr.mark3='*'
             LET l_flag='Y'
          END IF
       END IF
 
       #----(14)-----格式 21/22/25 時，判斷發票年月 >= 申報年月
       IF sr.amd171 ='21' OR sr.amd171 ='22' OR sr.amd171 ='25' THEN
          LET l_yy = YEAR(sr.amd05)
          LET l_mm = MONTH(sr.amd05)
          IF (l_yy * 12 + l_mm) >= (tm.ama08 * 12 + tm.ama09) THEN
             LET sr.mark3='*'
             LET l_flag='Y'
          END IF
       END IF
 
       IF l_flag='Y' THEN
          LET sr.amd173=sr.amd173-1911
          LET sr.amd05y=Year(sr.amd05)-1911     #No:9739
          LET sr.amd05m=Month(sr.amd05)         #No:9739
          LET l_stat = 'Y'
#No.FUN-750098 -- begin --
#         OUTPUT TO REPORT r300_rep(sr.*)
     #    LET sr1.amd171 = sr.mark2,sr.amd171 CLIPPED
     #    LET sr1.amd28  = sr.mark1,sr.amd28 CLIPPED
     #    LET sr1.amd01  = sr.amd01 CLIPPED
     #    LET sr1.amd03  = sr.mark5,sr.amd03 CLIPPED
     #    LET sr1.amd04  = sr.mark8,sr.amd04 CLIPPED
     #    LET sr1.amd05  = sr.mark3,sr.amd05y USING '&&',sr.amd05m USING '&&'
     #    LET sr1.amd172 = sr.mark6,sr.amd172
     #    LET sr1.amd08  = cl_numfor(sr.amd08,18,g_azi04)
     #    LET sr1.amd07  = sr.mark4,cl_numfor(sr.amd07,18,g_azi04)
     #    LET sr1.apk25  = sr.apk25
          EXECUTE insert_prep USING
             sr.amd171,sr.amd28,sr.amd01,
             sr.amd03,sr.amd04,sr.amd05,
             sr.amd172,sr.amd08,sr.amd07,sr.apk25,sr.mark1,
             sr.mark2,sr.mark3,sr.mark4,sr.mark5,sr.mark6,sr.mark8
          INITIALIZE sr.* TO NULL
#No.FUN-750098 -- end --
       END IF
 
    END FOREACH
   #END FOR
 
    IF l_stat = 'N' THEN
       INITIALIZE sr.* TO NULL
       LET sr.amd28 = '無錯誤!!'
#No.FUN-750098 -- begin --
#      OUTPUT TO REPORT r300_rep(sr.*)
#      LET l_byy = tm.byy - 1911                      #No.FUN-750098
#      LET l_eyy = tm.eyy - 1911                      #No.FUN-750098
   #   LET sr1.amd171 = sr.mark2,sr.amd171 CLIPPED
   #   LET sr1.amd28  = sr.mark1,sr.amd28 CLIPPED
   #   LET sr1.amd01  = sr.amd01 CLIPPED
   #   LET sr1.amd03  = sr.mark5,sr.amd03 CLIPPED
   #   LET sr1.amd04  = sr.mark8,sr.amd04 CLIPPED
   #   LET sr1.amd05  = sr.mark3,sr.amd05y USING '&&',sr.amd05m USING '&&'
   #   LET sr1.amd172 = sr.mark6,sr.amd172
   #   LET sr1.amd08  = cl_numfor(sr.amd08,38,g_azi04)
   #   LET sr1.amd07  = sr.mark4,cl_numfor(sr.amd07,18,g_azi04)
   #   LET sr1.apk25  = sr.apk25
       EXECUTE insert_prep USING
          sr.amd171,sr.amd28,sr.amd01,
          sr.amd03,sr.amd04,sr.amd05,
          sr.amd172,sr.amd08,sr.amd07,sr.apk25,sr.mark1,
          sr.mark2,sr.mark3,sr.mark4,sr.mark5,sr.mark6,sr.mark8
       INITIALIZE sr.* TO NULL
#No.FUN-750098 -- end --
    END IF
#   FINISH REPORT r300_rep                         #No.FUN-750098 
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)    #No.FUN-750098
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'amd28,amd172,amd171') 
            RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str = l_byy,";",tm.bmm,";",l_eyy,";",tm.emm,";",g_str,";",g_azi04        #No.FUN-750098
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  #No.FUN-750098
    CALL cl_prt_cs3('amdr300','amdr300',l_sql,g_str)         #No.FUN-750098 
END FUNCTION
 
#No.FUN-750098--------Begin
{
REPORT r300_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
       l_byy        LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_eyy        LIKE type_file.num10,      #No.FUN-680074 INTEGER
       g_head1      STRING,                    #No.FUN-680074
       str          STRING,                    #No.FUN-680074
       sr           RECORD
                    amd171  LIKE amd_file.amd171, #格式
                    ama03   LIKE ama_file.ama03,  #稅籍編號
                    amd175  LIKE amd_file.amd175, #流水號
                    amd173  LIKE amd_file.amd173, #年度
                    amd174  LIKE amd_file.amd174, #月份
                    ama02   LIKE ama_file.ama02,  #買方統一編號
                    amd04   LIKE amd_file.amd04,  #賣方統一編號
                    amd03   LIKE amd_file.amd03,  #發票編號
                    amd08   LIKE amd_file.amd08,  #扣抵金額
                    amd172  LIKE amd_file.amd172, #課稅別
                    amd07   LIKE amd_file.amd07,  #扣抵稅額
                    amd17   LIKE amd_file.amd17,  #扣抵代號
                    amd09   LIKE amd_file.amd09,  #彙加註記
                    amd10   LIKE amd_file.amd10,  #洋菸酒註記
	            amd01   LIKE amd_file.amd01,
	            amd02   LIKE amd_file.amd02,
	            amd28   LIKE amd_file.amd28,
	            amd05   LIKE amd_file.amd05,
                    amd05y  LIKE aba_file.aba18,       #No.FUN-680074 VARCHAR(2) #No:9739
                    amd05m  LIKE aba_file.aba18,       #No.FUN-680074 VARCHAR(2) #No:9739
	            mark1   LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
	            mark2   LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
	            mark3   LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
	            mark4   LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
	            mark5   LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
	            mark6   LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
	            mark7   LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
                    mark8   LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
                    apk25   LIKE apk_file.apk25        #No.FUN-680074 VARCHAR(18)
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin #FUN-580098
         PAGE LENGTH g_page_line
  ORDER BY sr.amd28,sr.amd01
  FORMAT
 
    PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT #No.TQC-710009
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED, pageno_total   #No.TQC-710009 mark
      LET l_byy = tm.byy - 1911
      LET l_eyy = tm.eyy - 1911
      LET g_head1 = g_x[4] CLIPPED,l_byy USING '##',
                    g_x[5] CLIPPED,tm.bmm USING '##',
                    g_x[7] CLIPPED,l_eyy USING '##',
                    g_x[5] CLIPPED,tm.emm USING '##',g_x[6]
      #PRINT g_head1                       #FUN-660060
      PRINT COLUMN (g_len-25)/2+1,g_head1  #FUN-660060
      PRINT g_head CLIPPED, pageno_total   #No.TQC-710009
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
            g_x[38],g_x[39],g_x[40]
      PRINT g_dash1
      LET l_last_sw = 'n'  #No.TQC-6A0093
 
   ON EVERY ROW
      LET str = sr.mark2 ,sr.amd171 CLIPPED
      PRINT COLUMN g_c[31],str;
      LET str = sr.mark1 ,sr.amd28 CLIPPED
      PRINT COLUMN g_c[32],str;
      PRINT COLUMN g_c[33],sr.amd01;
      LET str = sr.mark5,sr.amd03 CLIPPED
      PRINT COLUMN g_c[34],str;
      LET str = sr.mark8,sr.amd04 CLIPPED
      PRINT COLUMN g_c[35],str;
      LET str = sr.mark3,sr.amd05y USING '&&',sr.amd05m USING '&&'  #No:9739
      PRINT COLUMN g_c[36],str;
      LET str = sr.mark6,sr.amd172
      PRINT COLUMN g_c[37],str;
      PRINT COLUMN g_c[38],cl_numfor(sr.amd08,38,g_azi04);
      LET str = sr.mark4,cl_numfor(sr.amd07,18,g_azi04)
      PRINT COLUMN g_c[39],str;
      PRINT COLUMN g_c[40],sr.apk25
      LET l_last_sw = 'n'  #No.TQC-710009
 
#NO.TQC-6A0116 start--                                                          
   ON LAST ROW                                                                  
      PRINT g_dash[1,g_len]                                                     
      LET l_last_sw = 'y'                                                       
      PRINT g_x[8] CLIPPED, COLUMN (g_len-9), g_x[10] CLIPPED                   
                                                                                
   PAGE TRAILER                                                                 
      IF l_last_sw = 'n'                                                        
         THEN PRINT g_dash[1,g_len]                                             
              PRINT g_x[8] CLIPPED,COLUMN (g_len-9), g_x[9] CLIPPED             
         ELSE SKIP 2 LINE                                                       
      END IF                                                                    
#NO.TQC-6A0116 start--        
END REPORT
}
#No.FUN-750098--------End
