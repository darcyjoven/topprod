# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aecu660.4gl
# Descriptions...: 更新產品結構損耗率作業
# Date & Author..: 92/01/06 By Lin
# Modify.........: No.TQC-620147 06/02/27 By Claire 修改對話框呈現方式
# Modify.........: No.TQC-630026 06/03/10 By Pengu 已建立產品結購與產品製程資料,但無法維護損耗率 
# Modify.........: No.FUN-660091 05/06/15 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-680073 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6C0193 07/01/05 By Ray 增加運行成功提示
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2)
# Modify.........: No.FUN-C40007 13/01/10 By Nina 只要程式有UPDATE bmb_file 的任何一個欄位時,多加bmbdate=g_today 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD				 # Print condition RECORD
		wc  	  LIKE type_file.chr1000,#No.FUN-680073  VARCHAR(300) #Where condition
   		ym        LIKE type_file.dat     #No.FUN-680073  # 有效日期 DATE
              END RECORD,
          g_bma01         LIKE bma_file.bma01,  #產品結構單頭
          g_bmb09         LIKE bmb_file.bmb09,  #作業序號
          g_bma01_a       LIKE bma_file.bma01  #產品結構單頭
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680073 INTEGER
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
   CALL u660_tm(0,0)			# Input print condition
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION u660_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680073 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680073 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW u660_w AT p_row,p_col WITH FORM "aec/42f/aecu660"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   IF g_sma.sma54='N' THEN    #有使用製程時,才可使用本作業
      CALL cl_err('','mfg5030',1)
      CLOSE WINDOW u660_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.ym = g_today	#有效日期
WHILE TRUE
 
   CONSTRUCT tm.wc ON ima06,ima01 FROM ima06,ima01
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW u660_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   LET l_cmd="SELECT COUNT(DISTINCT ima01) FROM ima_file,bma_file",
               " WHERE ima01=bma01 AND ima08 NOT IN ('C','D','A','P','Z','V','W') ",
               " AND ",tm.wc CLIPPED
   PREPARE u660_pre FROM l_cmd
   IF SQLCA.sqlcode THEN CALL cl_err('P0:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
   END IF
   DECLARE u660_cnt CURSOR FOR u660_pre
   OPEN u660_cnt
   FETCH u660_cnt INTO g_cnt   #計算處理筆數
       IF SQLCA.sqlcode OR g_cnt IS NULL OR g_cnt = 0 THEN
            CALL cl_err(g_cnt,'mfg2601',0)
            CONTINUE WHILE
       ELSE
           LET g_cnt=sqlca.sqlerrd[3]
       END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW u660_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aecu660()
#No.TQC-6C0193 --begin
   CALL cl_end(18,20)
   IF NOT cl_cont(17,20) THEN
      EXIT WHILE
   END IF
#No.TQC-6C0193 --end
   UNLOCK TABLE ima_file
   UNLOCK TABLE ecb_file
   ERROR ""
END WHILE
   CLOSE WINDOW u660_w
END FUNCTION
 
#-----------☉ 程式處理邏輯 ☉--------------------1991/08/03(Lee)-
# aecu660()      從單頭讀取合乎條件的主件資料
# u660_bom()  處理元件及其相關的展開資料
FUNCTION aecu660()
   DEFINE l_name	LIKE type_file.chr20,        #No.FUN-680073 VARCHAR(20)  #External(Disk) file name
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0100
          l_sql         LIKE type_file.chr1000,      #No.FUN-680073 VARCHAR(600) # RDSQL STATEMENT
          l_sql2	LIKE type_file.chr1000,      #No.FUN-680073 VARCHAR(600) #RDSQL STATEMENT
          l_za05        LIKE type_file.chr1000,      #No.FUN-680073 VARCHAR(40)
          l_ima01 LIKE ima_file.ima01,               #主件料件編號
          l_ima08 LIKE ima_file.ima08                #來源碼
 
       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同部門的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
#    BEGIN WORK
#    LOCK TABLE ima_file  IN SHARE MODE
#    LOCK TABLE ecb_file  IN SHARE MODE
     LET l_sql = " SELECT ima01,ima08 ", #找合乎條件且在產品結構單頭中的ima資料
                 " FROM ima_file,bma_file ",
                 " WHERE ima08 NOT IN ('C','D','A','P','Z','V','W') ",
                 " AND ",tm.wc CLIPPED,
                 " AND bma01=ima01 AND bmaacti='Y' ",
                 " AND imaacti='Y' ",
                 " ORDER BY ima01 "
     PREPARE u660_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211    
        EXIT PROGRAM END IF
     DECLARE u660_cs1  CURSOR FOR u660_prepare1
     FOREACH u660_cs1 INTO l_ima01,l_ima08
       IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode !=100
              THEN CALL cl_err('foreach:',SQLCA.sqlcode,1)
                   EXIT FOREACH END IF
       #主件料號之來源碼='X' or 'K' 時,且sma29='Y' 則不往下展,因為已被其它
       #主件展過了.
      #---------No.FUN-670041 modify
      #IF l_ima08 MATCHES '[XK]' AND g_sma.sma29='Y' THEN
       IF l_ima08 MATCHES '[XK]' THEN
      #---------No.FUN-670041 end
          CONTINUE FOREACH
       END IF
       LET g_bma01=l_ima01   #記錄IMA主件料號
       CALL u660_bom(l_ima01)
     END FOREACH
 
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
END FUNCTION
 
FUNCTION u660_bom(p_key)
   DEFINE p_level	LIKE type_file.num5,         #No.FUN-680073 SMALLINT
          p_key		LIKE bma_file.bma01,         #主件料件編號
          l_ac,i	LIKE type_file.num5,         #No.FUN-680073 SMALLINT
          arrno		LIKE type_file.num5,         #No.FUN-680073 SMALLINT  #BUFFER SIZE (可存筆數)
          b_seq		LIKE type_file.num5,         #No.FUN-680073 SMALLINT  #當BUFFER滿時,重新讀單身之起始序號
          l_chr	 	LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
          l_sw 		LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
          p_ima01 LIKE ima_file.ima01,               #主件料件編號
          p_ima08 LIKE ima_file.ima08,               #來源碼
          l_ecb14 LIKE ecb_file.ecb14,               #損耗率
          l_msg         LIKE type_file.chr1000,      #No.FUN-680073 VARCHAR(78)
          l_msg1        LIKE type_file.chr1000,      #No.FUN-680073 VARCHAR(78)
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
            bma01 LIKE bma_file.bma01,    #主件料件編號
            bmb02 LIKE bmb_file.bmb02,    #項次
            bmb03 LIKE bmb_file.bmb03,    #元件料件編號
            bmb09 LIKE bmb_file.bmb09,    #作業序號
            ima08 LIKE ima_file.ima08     #來源碼
          END RECORD,
          l_ima94       LIKE ima_file.ima94,    #No.TQC-630026 add
          l_ima571      LIKE ima_file.ima571,   #No.TQC-630026 add
          l_sql2        LIKE type_file.chr1000  #No.FUN-680073 VARCHAR(400)
 
  LET arrno = 100
  WHILE  TRUE
    LET l_sql2=
        "SELECT bma01,bmb02,bmb03,bmb09,ima08 ",
        "  FROM bmb_file LEFT OUTER JOIN bma_file ON bmb_file.bmb03=bma_file.bma01  LEFT OUTER JOIN ima_file ON bmb_file.bmb03 = ima_file.ima01",
        " WHERE bmb01='", p_key,"' AND bmb02 >",b_seq,
        #生效日及失效日的判斷
        " AND (bmb04 <='",tm.ym,
        "' OR bmb04 IS NULL) AND (bmb05 >'",tm.ym, "' OR bmb05 IS NULL)",
    #   " AND bmaacti='Y' AND imaacti='Y' ",
        " ORDER BY bmb02,bmb03,bmb09 "
    PREPARE u660_prepare2 FROM l_sql2
    IF SQLCA.sqlcode THEN CALL cl_err('P1:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211          
       EXIT PROGRAM END IF
    DECLARE u660_cs2 CURSOR FOR u660_prepare2
 
    LET l_ac = 1
    FOREACH u660_cs2 INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
       IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode !=100
              THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
            IF l_ac >= arrno THEN EXIT FOREACH END IF
    END FOREACH
    LET g_bmb09=NULL
    FOR i = 1 TO l_ac-1			# 讀BUFFER傳給REPORT
       LET l_sw='Y'
    #  IF g_bmb09 != sr[i].bmb09 OR g_bmb09 IS NULL THEN
          LET l_ecb14=NULL            #作業序號不同時,才SELECT損耗率
   #----------------No.TQC-630026 modify
          LET l_ecb14 = NULL
          SELECT ima94,ima571 INTO l_ima94,l_ima571 FROM ima_file
                  WHERE ima01 = g_bma01
          IF SQLCA.sqlcode THEN 
#         CALL cl_err('',SQLCA.sqlcode,1)  #No.FUN-660091
          CALL cl_err3("sel","ima_file",g_bma01,"",SQLCA.sqlcode,"","",1) #FUN-660091     
          END IF
          DECLARE u660_cs3 CURSOR FOR 
              SELECT ecb14 FROM ecb_file WHERE ecb01 = l_ima571
                 AND ecb02 = l_ima94 AND ecb06 = sr[i].bmb09
          OPEN  u660_cs3
          FETCH u660_cs3 INTO l_ecb14
                      
         #SELECT ecb14 INTO l_ecb14
         #   FROM ecb_file
         #   WHERE ecb01=g_bma01 AND ecb02=1 AND ecb03=sr[i].bmb09
   #----------------No.TQC-630026 end
    #  END IF
       IF SQLCA.sqlcode THEN
             LET l_sw='N'
            #--------No.FUN-670041 modify
            #IF sr[i].ima08 NOT MATCHES '[XK]'  OR
            #     ( sr[i].ima08 MATCHES '[XK]'  AND g_sma.sma29='N' ) THEN
             IF sr[i].ima08 NOT MATCHES '[XK]' THEN
            #--------No.FUN-670041 end
                #TQC-620147-begin
                CALL cl_err(g_bma01,'mfg5032',0)
         	#CALL  cl_getmsg('mfg5031',0) RETURNING l_msg
                #LET l_msg1=l_msg[1,2] ,g_bma01 CLIPPED,l_msg[3,4],
                #           sr[i].bmb03 CLIPPED,l_msg[5,37]
                #LET g_chr = ' '
                #WHILE g_chr NOT MATCHES "[YyNn]" OR g_chr IS NULL
                #  PROMPT l_msg1 CLIPPED
                #         FOR CHAR g_chr
                 IF INT_FLAG THEN LET INT_FLAG = 0 
                    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
                    EXIT PROGRAM END IF
                #END WHILE
                #IF g_chr MATCHES '[nN]' THEN
                #   EXIT PROGRAM
                #END IF
                #TQC-620147-end
             END IF
       END IF
       IF l_sw='Y' THEN
              #屬於這些來源碼時,更新其損耗率,且除了'X','K'外,不再往下展
              IF sr[i].ima08 MATCHES '[MUSRPVWXK]' AND l_ecb14 IS NOT NULL THEN
                 UPDATE bmb_file SET bmb08=l_ecb14,
                                     bmbdate=g_today     #FUN-C40007 add
                     WHERE bmb01=p_key AND bmb03=sr[i].bmb03
                           AND bmb02=sr[i].bmb02 AND
                           ( bmb04 IS NULL OR bmb04 <= tm.ym )
                           AND ( bmb05 > tm.ym OR bmb05 IS NULL )
                IF SQLCA.sqlcode THEN
#                   CALL cl_err('',SQLCA.sqlcode,0)  #No.FUN-660091
                    CALL cl_err3("upd","bmb_file",p_key,sr[i].bmb02,SQLCA.sqlcode,"","",0) #FUN-660091
                    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
                    EXIT PROGRAM END IF
              END IF
       END IF
#      COMMIT WORK
       #來源碼='X' or 'K'時,sma29必須='Y'且存在[主件檔](bma_file)
       #中,才要繼續往下展
      #--------No.FUN-670041 modify
      #IF sr[i].ima08 MATCHES '[XK]' AND g_sma.sma29='Y'
       IF sr[i].ima08 MATCHES '[XK]' 
      #--------No.FUN-670041 modify
                          AND sr[i].bma01 IS NOT NULL THEN
          CALL u660_bom(sr[i].bmb03)
       END IF
       LET g_bmb09=sr[i].bmb09
    END FOR
    IF l_ac < arrno OR l_ac=1 THEN                 # BOM單身已讀完
        EXIT WHILE
     ELSE
        LET b_seq = sr[arrno].bmb02   #ARRAY已滿,但尚有單身未展時,必須往下展
     END IF
  END WHILE
END FUNCTION
 
#Patch....NO.TQC-610035 <001> #
 
