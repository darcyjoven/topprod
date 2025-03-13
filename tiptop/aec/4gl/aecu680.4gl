# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aecu680.4gl
# Descriptions...: 最大累計前置時間計算作業                
# Date & Author..: 92/03/13 By pin
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-760201 07/06/28 By jamie l_cmd語法錯誤
# Modify.........: No.FUN-710073 07/11/29 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')
# Modify.........: No.CHI-810015 08/01/17 By jamie 將FUN-710073修改部份還原
# Modify.........: No.FUN-840194 08/06/23 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD	                               # Print condition RECORD
                          c    LIKE type_file.dat,     # No.FUN-680073  DATE # Effective date.
                          b    LIKE type_file.chr1     # Prog. Version..: '5.30.06-13.03.12(01) # 重新計算料件主檔前置時間否:[N/Y]
              END RECORD,
          l_cmd        LIKE type_file.chr1000,      #No.FUN-680073 VARCHAR(70)
          l_lock       LIKE type_file.num5,         # No.FUN-680073 smallint
          p_row,p_col  LIKE type_file.num5,         #No.FUN-680073 SMALLINT SMALLINT
 	  g_wc         STRING,                      #No.FUN-580092 HCN  
          l_msg        LIKE type_file.chr1000       # No.FUN-680073 VARCHAR(60)
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
   IF s_shut(0) THEN 
      EXIT PROGRAM 
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0100
 
   OPEN WINDOW aecu680_w WITH FORM "aec/42f/aecu680" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   WHILE TRUE                           # use while loop ,can execute
      LET tm.c    = TODAY               # default ce date system date
      LET tm.b    = 'N'                 # default recompute lead time   "No"
      CONSTRUCT g_wc ON ima06,ima01 FROM ima06,ima01
 
   ON ACTION locale
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
   ON ACTION about         #MOD-4C0121
      CALL cl_about()      #MOD-4C0121
 
   ON ACTION help          #MOD-4C0121
      CALL cl_show_help()  #MOD-4C0121
 
   ON ACTION controlg      #MOD-4C0121
      CALL cl_cmdask()     #MOD-4C0121
      
  END CONSTRUCT
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
      IF INT_FLAG THEN 
         LET INT_FLAG=0 
         EXIT PROGRAM
      END IF
 
      INPUT BY NAME tm.* WITHOUT DEFAULTS  #input condition
  
   ON ACTION locale
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
         
         AFTER FIELD c            #Effective date
            IF cl_null(tm.c) THEN
               NEXT FIELD c
            END IF
 
         AFTER FIELD b            #重新計算料件主檔前置時間否  
            IF cl_null(tm.b) THEN
               NEXT FIELD b
            END IF
            IF tm.b NOT MATCHES '[YyNn]' THEN
               NEXT FIELD b
            END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG 
         CALL cl_cmdask()	# Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      
      END INPUT
 
      IF INT_FLAG THEN                         #when user press interrupt key
         LET INT_FLAG=0               #int_flat recover and exit 
         EXIT PROGRAM                 # program
      END IF
 
      IF tm.b MATCHES '[Yy]' THEN
	 CALL  cl_cmdrun("aecu620")
      END IF
      CALL cl_getmsg('mfg6052',g_lang)
      RETURNING l_msg
      MESSAGE l_msg clipped 
      CALL u680_comp()
      
      MESSAGE ' '
      CALL cl_end(17,20)
      IF NOT cl_cont(17,20) THEN
         EXIT WHILE 
      END IF
   END WHILE
   CLOSE WINDOW aecu680_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 FUNCTION u680_comp() 
   DEFINE l_sql   LIKE type_file.chr1000,                  #No.FUN-680073  VARCHAR(300)
          l_ima RECORD 
                ima01 LIKE ima_file.ima01,
                p_day LIKE ima_file.ima50, #ima50+ima48+ima49+ima491
                l_day LIKE ima_file.ima62, #ima59+ima60+ima61
                ima62 LIKE ima_file.ima62,
                ima08 LIKE ima_file.ima08
               #ima56 LIKE ima_file.ima56  #CHI-810015 mark #FUN-710073 add
                END RECORD,
                acc_day LIKE ima_file.ima62,
                l_ima853 LIKE ima_file.ima853,
                m_day   LIKE ima_file.ima62,
                l_n     LIKE type_file.num5     #No.FUN-680073 SMALLINT
 
#---------------------------------------------------------------------+
#                 program begin                                       |
#----------------------------------------------------------------------
 
 
#---->抓取料件主檔資料
  LET l_sql=" SELECT  ima01,(ima50+ima48+ima49+ima491), ",
           #"               (ima59+ima60+ima61),ima62,ima08,ima56 ",   #CHI-810015 mark #FUN-710073 add 
           #"               (ima59+ima60+ima61),ima62,ima08 ",         #CHI-810015 mod  #FUN-710073 add  #FUN-840914 mod
            "               (ima59+ima60/ima601+ima61),ima62,ima08 ",         #CHI-810015 mod  #FUN-710073 add  #FUN-840914 mod
            " FROM ima_file ",
            " WHERE imaacti IN('Y','y') ", 
            " AND ",g_wc clipped 
 
  PREPARE u680_prepare FROM l_sql
  IF SQLCA.sqlcode THEN CALL cl_err('prepare',SQLCA.sqlcode,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
     EXIT PROGRAM END IF
  DECLARE u680_cur CURSOR FOR u680_prepare
 
     UPDATE ima_file SET ima853='N',
                         imadate = g_today    #FUN-C30315 add
     FOREACH u680_cur INTO l_ima.*
     IF SQLCA.sqlcode !=0 THEN 
		CALL cl_err('foreach',SQLCA.sqlcode,1) EXIT FOREACH END IF
#----->檢查此料件是否之前被算過
        SELECT ima853 into l_ima853 FROM ima_file WHERE ima853 IN ('Y','y')
									  AND ima01=l_ima.ima01  #part no.
        IF SQLCA.sqlcode =0  THEN   #表被捲算過,讀下一筆
           INITIALIZE l_ima.* TO NULL 
           CONTINUE FOREACH
        ELSE
           IF l_ima.ima08 NOT MATCHES '[PpVvWwZz]' THEN #檢查其是否有產品結構
              SELECT count(*) into l_n FROM bmb_file
               WHERE bmb01 = l_ima.ima01    #料件編號
                 and (bmb04 <=tm.c or bmb04 is null) 
                 and (bmb05 > tm.c or bmb05 is null)
              IF SQLCA.sqlcode THEN    #無,視作採購料件
	         CALL u680_pvwz(l_ima.p_day,l_ima.ima01)
              ELSE    #------為一般自製料-------#
                 CALL aecu680_bom(0,l_ima.ima01) RETURNING  acc_day
                 LET m_day=acc_day+l_ima.l_day                 #CHI-810015mark還原 #FUN-710073 mark
                #LET m_day=acc_day+(l_ima.l_day/l_ima.ima56)   #CHI-810015mark     #FUN-710073 mod
                 CALL u680_pvwz(m_day,l_ima.ima01)
              END IF
           ELSE #---->處理來源碼為 P/V/W/Z
              IF l_ima.ima08 MATCHES '[PVWZ]' THEN    #當為最下階料件時
                 CALL u680_pvwz(l_ima.p_day,l_ima.ima01)
              END IF
           END IF
         END IF
      END FOREACH
 CLOSE WINDOW u680_wsg 
END FUNCTION
 
FUNCTION u680_pvwz(p_day,l_ima01)
DEFINE p_day   LIKE ima_file.ima50,
	   l_ima01 LIKE ima_file.ima01
 
UPDATE ima_file SET ima62=p_day,
                    imadate = g_today,         #FUN-C30315 add
 				ima853='Y'
				WHERE  ima01=l_ima01
 
END FUNCTION
 
FUNCTION aecu680_bom(p_level,p_key)
   DEFINE#p_level	SMALLINT,
          p_level       LIKE type_file.num5,     # No.FUN-680073 SMALLINT,
          p_key		LIKE bma_file.bma01,     #主件料件編號
          l_ac,i	LIKE type_file.num5,     # No.FUN-680073 SMALLINT SMALLINT
          arrno         LIKE type_file.num5,     # No.FUN-680073  SMALLINT, #BUFFER SIZE (可存筆數
          b_seq         LIKE type_file.chr1,     # No.FUN-680073 SMALLINT,  #當BUFFER滿時,重新讀單身之起始序號
          sr DYNAMIC ARRAY OF RECORD             #每階存放資料
                   bmb03 LIKE bmb_file.bmb03,         #元件料號
                   bmb02 LIKE bmb_file.bmb02,         #項次
                   bma01 LIKE bma_file.bma01,    #主件料號
                   p_day LIKE ima_file.ima50,    #請購+採購+到廠+入庫前置期
                   l_day LIKE ima_file.ima62,    #固定+變動+Q.C 前置時間
                   ima62 LIKE ima_file.ima62,    #累計前置時間
                   ima08 LIKE ima_file.ima08
                  #ima56 LIKE ima_file.ima56     #CHI-810015mark #FUN-710073 mod
                END RECORD, 
          l_acc_day_t LIKE ima_file.ima62,
          l_acc_day   LIKE ima_file.ima62,
          max_day     LIKE ima_file.ima62,
          l_ima853    LIKE ima_file.ima853,
          l_cmd       LIKE type_file.chr1000       #No.FUN-680073
 
    LET p_level = p_level + 1
    IF p_level > 20 THEN
        CALL cl_err(p_level,'mfg2644',2)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
    END IF
    LET arrno = 100
    IF cl_null(b_seq) THEN LET b_seq=0 END IF  #TQC-760201 add
    WHILE TRUE
        LET l_cmd=
            "SELECT bmb03,bmb02,bma01,(ima50+ima48+ima49+ima491), ",
                 #" (ima59+ima60+ima61),ima62,ima08,ima56 ",     #CHI-810015 mark #FUN-710073 add ima56
                 #" (ima59+ima60+ima61),ima62,ima08 ",           #CHI-810015 mod  #FUN-710073 add ima56
                  " (ima59+ima60/ima601+ima61),ima62,ima08 ",    #CHI-810015 mod  #FUN-710073 add ima56  #FUN-840194 mod
            " FROM bmb_file LEFT OUTER JOIN ima_file ON bmb_file.bmb03=ima_file.ima01  LEFT OUTER JOIN bma_file ON bmb_file.bmb03=bma_file.bma01",
           #" WHERE bmb01='", p_key,"' AND bmb02 >",b_seq,           #TQC-760201 mark
            " WHERE bmb01='", p_key,"' AND bmb02 > '", b_seq, "' "  #TQC-760201 mod
           #" AND bmb03 = ima_file.ima01",   #TQC-760201 mark
           #" AND bmb03 = bma_file.bma01"    #TQC-760201 mark
 
        #生效日及失效日的判斷
        IF tm.c IS NOT NULL THEN
            LET l_cmd=l_cmd CLIPPED, " AND (bmb04 <='",tm.c,
            "' OR bmb04 IS NULL) AND (bmb05 >'",tm.c,
            "' OR bmb05 IS NULL)"
        END IF
 
        #組完後的句子, 將準備成可以用的查詢命令
        PREPARE aecu680_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN CALL cl_err('Prepare:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM END IF
        DECLARE aecu680_cur CURSOR FOR aecu680_ppp
 
        LET l_acc_day=0
        LET max_day=0
        LET l_ac = 1
 
        FOREACH aecu680_cur INTO sr[l_ac].*           #將資料丟入陣列中
            LET l_ac = l_ac + 1
            IF l_ac >= arrno THEN EXIT FOREACH END IF
        END FOREACH
 
  FOR i = 1 TO l_ac-1
      IF sr[i].bma01 IS NOT NULL  AND 
         sr[i].ima08 NOT MATCHES '[pPVvWwzZ]' THEN   #表非最下階元件
                                                     #----->檢查此料件是否之前被算過
         IF sr[i].bmb03 IS NULL THEN LET sr[i].bmb03=' ' END IF
         SELECT ima853 INTO l_ima853
           FROM ima_file WHERE ima853 IN ('Y','y')
            AND ima01=sr[i].bmb03                     #part no.
         IF SQLCA.sqlcode =0                      #表此料件之前已做過, 不再做一次
            THEN LET l_acc_day= sr[i].ima62           #CHI-810015 mark還原 #FUN-710073 mark
            #LET l_acc_day= sr[i].ima62/sr[i].ima56   #CHI-810015 mark     #FUN-710073 mod
         ELSE 
            CALL aecu680_bom(p_level,sr[i].bmb03) #再往下展
            RETURNING l_acc_day 
            LET l_acc_day=l_acc_day+sr[i].l_day                 #CHI-810015 mark還原 #FUN-710073 mark 
           #LET l_acc_day=l_acc_day+(sr[i].l_day/sr[i].ima56)   #CHI-810015 mark     #FUN-710073 mod
            CALL u680_pvwz(l_acc_day,sr[i].bmb03)
         END IF   #抓取同階最大者
         IF max_day < l_acc_day  THEN
            LET max_day=l_acc_day
         END IF
      ELSE #無下階之元件
           #----->檢查此料件是否之前被算過
           IF sr[i].bmb03 IS NULL THEN LET sr[i].bmb03=' ' END IF
           SELECT ima853 INTO l_ima853 
             FROM ima_file WHERE ima853 IN ('Y','y')
              AND ima01=sr[i].bmb03  #part no.
           IF SQLCA.sqlcode =0       #表此料件之前已做過, 不再做一次
              THEN LET l_acc_day=sr[i].ima62            #CHI-810015mark還原 #FUN-710073 mark
             #LET l_acc_day= sr[i].ima62/sr[i].ima56    #CHI-810015mark     #FUN-710073 mod
           ELSE 
              LET l_acc_day=sr[i].p_day 
              CALL u680_pvwz(l_acc_day,sr[i].bmb03)
           END IF
           IF max_day< l_acc_day THEN #將最大者丟入max_day
              LET max_day=l_acc_day
           END IF
      END IF
  END FOR
      IF l_ac < arrno OR l_ac=1 THEN         # BOM單身已讀完
         EXIT WHILE
      ELSE
         LET b_seq = sr[arrno].bmb02
      END IF
 END WHILE
  RETURN max_day #最大累計前置時間
END FUNCTION
 
