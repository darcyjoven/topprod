# Prog. Version..: '5.30.06-13.04.18(00008)'     #
#
# Pattern name...: abmp610.4gl
# Descriptions...: 產品結構偵錯作業
# Date & Author..: 91/09/30 By Lee
# Modify.........: #No.MOD-490217 04/09/13 by yiting 料號欄位使用 like方式
# Modify.........: #No.MOD-530319 05/04/01 By Mandy p610()因為在s_uima146()也會CALL 到,所以要做 g_prog的轉換
#                  避免CALL cl_outnam('abmp610')時抓不到相關file而產生錯誤
# Modify.........: No.FUN-550093 05/06/03 By kim 配方BOM,特性代碼
# Modify.........: No.FUN-560021 05/06/07 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-560111 05/06/19 By Mandy 1.輸入料號後show 料件不存在(未輸入特性代碼)
# Modify.........: No.FUN-560111 05/06/19 By Mandy 2.料號開窗區分不使用特性代碼CALL q_bma,走特性代碼CALL q_bma6
# Modify.........: No.MOD-590304 05/09/14 By kim 料號放大到40
# Modify.........: No.FUN-570114 06/02/22 By saki 批次背景執行
# Modify.........: No.TQC-660046 06/06/26 By pxlpxl cl_err-->cl_err3
# Modify.........: No.TQC-640044 06/07/05 By Pengu 法偵錯主件料號
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.CHI-910021 09/01/15 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.CHI-C50062 12/08/13 By ck2yuan 未考慮取替代所造成的錯誤
# Modify.........: No.TQC-CA0025 12/10/29 By Elise 建議拿掉呼叫cl_used(1)及cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_item    LIKE bma_file.bma01,     # 主件料件編號
    g_acode   LIKE bma_file.bma06,     #FUN-550093
    max_level LIKE type_file.num5,     #No.FUN-680096 SMALLINT
    g_bmd01   LIKE bmd_file.bmd01,     # 主件料件編號
    g_bma01   ARRAY[100] OF LIKE bma_file.bma01,  #No.FUN-680096 VARCHAR(40)
    g_max     LIKE type_file.num5,     # 用來記錄目前ARRAY己使用筆數  #No.FUN-680096 SMALLINT
    g_tot     LIKE type_file.num10,     #No.FUN-680096 INTEGER
    g_err     LIKE type_file.num5      # 用來記錄發生錯誤的次數 #No.FUN-680096 SMALLINT
 
DEFINE   g_chr          LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose  #No.FUN-680096 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03,      #No.FUN-680096 VARCHAR(72)
         g_change_lang  LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
         l_flag         LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)


FUNCTION p610_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_cmd         LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(400)
          l_ima02       LIKE ima_file.ima02,
          l_item        LIKE bma_file.bma01,    #資料筆數
          lc_cmd        LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(500)
 
   OPEN WINDOW p610_w WITH FORM "abm/42f/abmp610"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("acode",g_sma.sma118='Y')
 
   CALL cl_opmsg('p')
   LET max_level =20    #No.B476
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   LET g_change_lang = FALSE
   LET g_bgjob = 'N'                               #No.FUN-570114
   CLEAR FORM
   LET l_item=''
   DISPLAY g_item TO item
   DISPLAY max_level TO max_level   #No.B476
   DISPLAY g_acode TO acode #FUN-550093

   INPUT g_item,g_acode,max_level,g_bgjob  WITHOUT DEFAULTS
    FROM item,acode,max_level,g_bgjob 
 
	BEFORE FIELD item
	    IF g_sma.sma60 = 'Y'		# 若須分段輸入
	       THEN CALL s_inp5(10,34,g_item) RETURNING g_item
	            DISPLAY  g_item TO item
	    END IF
 
      AFTER FIELD item
          IF NOT cl_null(g_item) THEN
              SELECT ima02 INTO l_ima02 FROM ima_file
               WHERE ima01 = g_item
              DISPLAY l_ima02 TO FORMONLY.ima02
             #檢查所輸入主件是否為最高階主件, 方式: 讀單身檔, 檢查其是否為元件
             #若為元件, 則表示其非最階主件, 此時, 若其再確認是此料件, 則程式便
             #開始執行
             IF g_sma.sma118 != 'Y' THEN #FUN-560111 add if 判斷
                 LET g_acode = ' '       #FUN-560111 add
                  SELECT bma01 FROM bma_file
                      WHERE bma01=g_item
                        AND bma06=g_acode  #FUN-560111 add
                  IF SQLCA.sqlcode THEN
 #                     CALL cl_err(g_item,'mfg2602',0)      #NO.TQC-660046 
                       CALL cl_err3("sel","bma_file",g_item,g_acode,"mfg2602","","",0)       #NO.TQC-660046
                      LET g_item=l_item
                      DISPLAY g_item TO item
                      NEXT FIELD item
                  END IF
                  IF l_item!=g_item OR l_item IS NULL THEN
                      SELECT count(*) INTO g_cnt
                          FROM bmb_file
                          WHERE bmb03=g_item
                            AND bmb29=g_acode #FUN-560111 add
                      IF SQLCA.sqlcode OR g_cnt IS NULL THEN
                          LET g_cnt=0
                      END IF
                      IF g_cnt > 0 THEN
                          CALL cl_err(g_item,'mfg2640',0)
                          LET l_item=g_item
                          NEXT FIELD item
                      END IF
                  END IF
              END IF
          END IF
      #FUN-560111 add
      AFTER FIELD acode
          IF g_sma.sma118 = 'Y' THEN
              IF g_acode IS NULL THEN LET g_acode = ' ' END IF
              SELECT bma01 FROM bma_file #FUN-560011
                  WHERE bma01=g_item
                    AND bma06=g_acode  #FUN-560111 add
              IF SQLCA.sqlcode THEN
                  #無此主件編號+特性代碼
 #                 CALL cl_err(g_item,'abm-618',1)     #NO.TQC-660046
                   CALL cl_err3("sel","bma_file",g_item,g_acode,"abm-618","","",1)       #NO.TQC-660046
                  LET g_item=l_item
                  DISPLAY g_item TO item
                  NEXT FIELD item
              END IF
              IF l_item!=g_item OR l_item IS NULL THEN
                  SELECT count(*) INTO g_cnt
                      FROM bmb_file
                      WHERE bmb03=g_item
                        AND bmb29=g_acode #FUN-560111 add
                  IF SQLCA.sqlcode OR g_cnt IS NULL THEN
                      LET g_cnt=0
                  END IF
                  IF g_cnt > 0 THEN
                      CALL cl_err(g_item,'mfg2640',0)
                      LET l_item=g_item
                      NEXT FIELD item
                  END IF
              END IF
          END IF
      #FUN-560111(end)
 
        AFTER FIELD max_level
            IF NOT cl_null(max_level) THEN
                IF max_level <=0 THEN
                    NEXT FIELD max_level
                END IF
            END IF
 
      ON ACTION other_condition
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                    g_bgjob,g_time,g_prtway,g_copies)
                RETURNING g_pdate,g_towhom,g_rlang,
                    g_bgjob,g_time,g_prtway,g_copies
            IF INT_FLAG THEN
                LET INT_FLAG=0
            END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
 
      ON ACTION CONTROLP
        CASE
           WHEN INFIELD(item)
              CALL cl_init_qry_var()
              #FUN-560111 add 料號開窗區分不使用特性代碼CALL q_bma,走特性代碼CALL q_bma6
              IF g_sma.sma118 != 'Y' THEN
                  LET g_qryparam.form = "q_bma"
                  LET g_qryparam.default1 = NULL
                  CALL cl_create_qry() RETURNING g_item
                  DISPLAY g_item TO item
              ELSE
                  LET g_qryparam.form = "q_bma6"
                  LET g_qryparam.default1 = NULL
                  CALL cl_create_qry() RETURNING g_item,g_acode
                  DISPLAY g_item,g_acode TO item,acode
              END IF
              #FUN-560111(end)
              NEXT FIELD item
        END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION locale
          LET g_change_lang = TRUE
          EXIT INPUT

      ON ACTION exit                            #加離開功能
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW p610_w 
     #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211  #TQC-CA0025 mark
      EXIT PROGRAM
   END IF
   IF g_change_lang = TRUE THEN
      LET g_change_lang = FALSE                   #No.FUN-570114
      CALL cl_dynamic_locale()                    #No.FUN-570114
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
       CONTINUE WHILE
   END IF
   #No.FUN-570114 --start--
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO lc_cmd FROM zz_file	
             WHERE zz01='abmp610'
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('abmp610','9031',1)
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,	
                         " '",g_item CLIPPED,"'",
                         " '",g_acode CLIPPED,"'",
                         " '",max_level CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('abmp610',g_time,lc_cmd CLIPPED)	
      END IF
      CLOSE WINDOW p610_w
     #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211  #TQC-CA0025 mark
      EXIT PROGRAM
   END IF
 
   CALL cl_wait()
   CALL p610(g_item,'abmp610') RETURNING g_i
   IF g_i <= 0 THEN CALL cl_err('','mfg2641',1) END IF
   CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
   IF l_flag THEN
      CLEAR FORM
      ERROR ""
      LET g_item=''
      LET g_acode='' #FUN-550093
      LET g_i=0
      CONTINUE WHILE
   ELSE
      EXIT WHILE
   END IF
END WHILE
   CLOSE WINDOW p610_w
END FUNCTION
 
 FUNCTION p610(p_item,p_prog) #MOD-530319
    DEFINE p_prog       LIKE type_file.chr20    #MOD-530319  #No.FUN-680096 VARCHAR(10)
    DEFINE p_item	LIKE bma_file.bma01,    #No.MOD-490217
          l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
          l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT  #No.FUN-680096 VARCHAR(601)
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          l_bma01       LIKE bma_file.bma01,    #主件料件
          l_bma06       LIKE bma_file.bma06     #FUN-550093
 
     LET g_prog= 'abmp610' #MOD-530319
     LET g_item=p_item

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
     LET l_sql= "SELECT bmd02,bmd04 FROM bmd_file ",
                " WHERE bmd01=?",
                "  AND (bmd08=? OR bmd08='ALL') ",   #CHI-C50062 add
                "  AND (bmd05 <='",g_today,"' OR bmd05 IS NULL) ", #No.8826
                "  AND (bmd06 >'",g_today, "' OR bmd06 IS NULL) ",
                "  AND bmdacti = 'Y'"                                           #CHI-910021
     PREPARE p610_pp FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('P(bmd):',SQLCA.sqlcode,1)
        CALL cl_batch_bg_javamail('N')                 #No.FUN-570114
       #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211  #TQC-CA0025 mark
        EXIT PROGRAM
     END IF
     DECLARE p610_cbmd CURSOR FOR p610_pp
 
     LET l_sql = "SELECT bma01,bma06", #FUN-550093
                 " FROM bma_file",
                 " WHERE bma01='",g_item,"'",
                 " AND bma06='",g_acode,"'" #FUN-550093
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET l_sql = l_sql CLIPPED," AND bmauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同部門的資料
     #         LET l_sql = l_sql CLIPPED," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET l_sql = l_sql CLIPPED," AND bmagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET l_sql = l_sql CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
     #End:FUN-980030
 
     PREPARE p610_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_batch_bg_javamail('N')                #No.FUN-570114
       #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211  #TQC-CA0025 mark
        EXIT PROGRAM
     END IF
     DECLARE p610_cs1 CURSOR FOR p610_prepare1
     CALL cl_outnam('abmp610') RETURNING l_name
     START REPORT p610_rep TO l_name
 
        LET g_tot=0
     LET g_err=0
     FOREACH p610_cs1 INTO l_bma01,l_bma06 #FUN-550093
       IF SQLCA.sqlcode THEN
          CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET g_max=1
       LET g_bma01[1]=l_bma01
       CALL p610_bom(0,l_bma01,l_bma06) #FUN-550093
     END FOREACH
 
     FINISH REPORT p610_rep
 
     IF g_bgjob = 'N' THEN  #FUN-570114
        ERROR ""
     END IF
     IF g_err>0 THEN
         IF g_bgjob='N' THEN
             CALL cl_getmsg('mfg2642',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_err USING '&&&& ', g_msg CLIPPED  FOR g_chr
         END IF
         CALL cl_prt(l_name,g_prtway,g_copies,g_len)
          LET g_prog=p_prog #MOD-530319
     END IF
     RETURN g_err
END FUNCTION
 
FUNCTION p610_bom(p_level,p_key,p_acode) #FUN-550093
   DEFINE p_level	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_key		LIKE bma_file.bma01,    #主件料件編號
          p_acode       LIKE bma_file.bma06,    #FUN-550093
          l_ac,i	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          b_seq		LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          sr DYNAMIC ARRAY OF RECORD            #每階存放資料
              bmb02 LIKE bmb_file.bmb02,        #元件料號
              bmb03 LIKE bmb_file.bmb03,        #元件料號
               bma01 LIKE bma_file.bma01        #No.MOD-490217
          END RECORD,
	l_tot,l_times LIKE type_file.num5,      #No.FUN-680096 SMALLINT
          l_bmd04       LIKE bmd_file.bmd04,
          l_bmd02       LIKE bmd_file.bmd02,
          l_cmd		LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(400)
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
   #CHI-C50062 str add-----
    DEFINE l_count     LIKE type_file.num5
    DEFINE l_flag      LIKE type_file.num5
    DEFINE l_temp       DYNAMIC ARRAY OF RECORD
             bmd04  LIKE bmd_file.bmd04,
             bmd02  LIKE bmd_file.bmd02,
             ima910 LIKE ima_file.ima910
          END RECORD

    LET l_count = 0
   #CHI-C50062 end add-----
 
    LET p_level = p_level + 1
    IF p_level=1 THEN
        LET sr[1].bmb03 = p_key
    END IF
    LET arrno = 600
    WHILE TRUE
    LET l_cmd=
        "SELECT bmb02,bmb03,bma01",
        " FROM bmb_file, OUTER bma_file",
        " WHERE bmb01='", p_key,"' AND bmb02 >",b_seq,
       #" AND bmb_file.bmb03 = bma_file.bma01",        #CHI-C50062 mark
        " AND bmb_file.bmb01 = bma_file.bma01",        #CHI-C50062 add
        " AND bmb_file.bmb29 = bma_file.bma06",        #CHI-C50062 add
        " AND bmb29 ='",p_acode,"'", #FUN-550093
        " AND (bmb04 <='",g_today,
        "' OR bmb04 IS NULL) AND (bmb05 >'",g_today,
        "' OR bmb05 IS NULL)",
    	" ORDER BY bmb02"
    PREPARE p610_ppp FROM l_cmd
    IF SQLCA.sqlcode THEN
       CALL cl_err('P1:',SQLCA.sqlcode,1)
       CALL cl_batch_bg_javamail('N')                #No.FUN-570114
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211  #TQC-CA0025 mark
       EXIT PROGRAM
    END IF
    DECLARE p610_cur CURSOR FOR p610_ppp
	LET l_times=1
 
        LET l_ac = 1
        FOREACH p610_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
            IF SQLCA.sqlcode THEN EXIT FOREACH END IF
            #FUN-8B0035--BEGIN--
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03 
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            #FUN-8B0035--END-- 
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
		LET g_tot=g_tot+1
#	message g_tot
            IF l_ac > arrno THEN EXIT FOREACH END IF
         END FOREACH
	LET l_tot=l_ac-1
         FOR i = 1 TO l_tot 			# 讀BUFFER傳給REPORT
#		message '<',l_times,'> ',i
#檢查看看是否在低階元件中有高階主件產生
            FOR g_cnt=1 TO g_max
                IF sr[i].bmb03 = g_bma01[g_cnt] THEN
                    LET sr[i].bma01=p_key
                    OUTPUT TO REPORT p610_rep(p_level,'0',sr[i].*)
                    LET sr[i].bma01='' #讓它不會繼續往下走無窮的迴路
                    LET g_err=g_err+1
                    EXIT FOR
                END IF
            END FOR
#檢取替/ 取代元件是否有誤
            FOREACH p610_cbmd
           #USING sr[i].bmb03            #CHI-C50062 mark
            USING sr[i].bmb03 , p_key    #CHI-C50062 add
            INTO l_bmd02,l_bmd04
                IF SQLCA.sqlcode THEN EXIT FOREACH END IF
                FOR g_cnt=1 TO g_max
                    IF l_bmd04 = g_bma01[g_cnt] THEN
                        OUTPUT TO REPORT p610_rep(p_level,l_bmd02,
                            sr[i].bmb02,l_bmd04,sr[i].bmb03)
                        LET g_err=g_err+1
                    END IF
                END FOR
               #CHI-C50062 str add-----
                LET l_count = l_count+1
                LET l_temp[l_count].bmd04 =l_bmd04
                LET l_temp[l_count].bmd02 =l_bmd02
                SELECT ima910 INTO l_temp[l_count].ima910 FROM ima_file WHERE ima01=l_bmd04
               #CHI-C50062 end add-----
            END FOREACH

            CALL p610_chksub(l_temp,p_level,l_count) RETURNING l_flag  #CHI-C50062 add
            IF l_flag = 0 THEN   CONTINUE FOR END IF                   #CHI-C50062 add

#是否尚有下階
            IF sr[i].bma01 IS NOT NULL THEN
                LET g_max=g_max+1
#判斷階數是否超過99階
              # IF g_max > 99 THEN
                IF g_max > max_level THEN   #No.B476 010507 by linda mod
                    OUTPUT TO REPORT p610_rep(101,i,sr[i].*)
                    EXIT FOR
                END IF
                LET g_bma01[g_max]=sr[i].bma01
               #CALL p610_bom(p_level,sr[i].bmb03,' ') #FUN-550093 #FUN-8B0035
                CALL p610_bom(p_level,sr[i].bmb03,l_ima910[i]) #FUN-550093#FUN-8B0035
            END IF
        END FOR
        IF l_tot < arrno OR l_tot=0 THEN                 # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[l_tot].bmb02
		let l_times=l_times+1
        END IF
    END WHILE
    LET g_max=g_max-1
    IF g_max < 0 THEN LET g_max=0 END IF  #CHI-C50062 add
END FUNCTION

#CHI-C50062 str add------
FUNCTION p610_chksub(l_temp,p_level,l_count)
    DEFINE l_temp       DYNAMIC ARRAY OF RECORD
             bmd04    LIKE bmd_file.bmd04,
             bmd02    LIKE bmd_file.bmd02,
             ima910   LIKE ima_file.ima910
          END RECORD
    DEFINE p_level     LIKE type_file.num5
    DEFINE l_count     LIKE type_file.num5
    DEFINE i           LIKE type_file.num5
    DEFINE l_num_bmb   LIKE type_file.num5
    DEFINE l_num_bmd   LIKE type_file.num5
    DEFINE l_flag      LIKE type_file.num5
    DEFINE l_fflag     LIKE type_file.num5

    LET l_flag = 1
    LET l_fflag = 1

    IF l_count = 0 THEN RETURN l_fflag END IF
    FOR i = 1 TO l_count
       FOR g_cnt=1 TO g_max
           IF l_temp[i].bmd04 = g_bma01[g_cnt] THEN
               LET l_flag = 0
               EXIT FOR
           END IF
       END FOR

       IF l_flag = 0 THEN
          LET l_fflag = 0
          LET l_flag  = 1
          CONTINUE FOR
       END IF

       LET l_num_bmb = 0
       LET l_num_bmd = 0
       SELECT COUNT(*) INTO l_num_bmb FROM bmb_file WHERE bmb01=l_temp[i].bmd04 AND bmb29=l_temp[i].ima910
       SELECT COUNT(*) INTO l_num_bmd FROM bmd_file WHERE bmd01=l_temp[i].bmd04 AND (bmd05 <=g_today OR bmd05 IS NULL)
                        AND (bmd06 >g_today OR bmd06 IS NULL)    AND bmdacti = 'Y'
       IF l_num_bmb > 0 OR l_num_bmd > 0 THEN
          CALL p610_bom(p_level-1,l_temp[i].bmd04,l_temp[i].ima910)
       END IF
    END FOR

    RETURN l_fflag

END FUNCTION
#CHI-C50062 end add------
 
REPORT p610_rep(p_level,p_i,sr)
   DEFINE l_last_sw	LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
          p_level	LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          p_i           LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
          sr  RECORD
              bmb02 LIKE bmb_file.bmb02,       #項次
              bmb03 LIKE bmb_file.bmb03,       #元件料號
              bma01 LIKE bma_file.bma01        #No.MOD-490217
          END RECORD, 
          l_now         LIKE type_file.num5    #No.FUN-680096 SMALLINT
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[13] CLIPPED,g_item
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
    ON EVERY ROW
       IF p_level=101 THEN
           CALL cl_getmsg('mfg2643',g_lang) RETURNING g_msg
           PRINT g_msg CLIPPED
       ELSE
           PRINT COLUMN g_c[31],sr.bmb03,' ',
                 COLUMN g_c[32],sr.bma01,' ',
                 COLUMN g_c[33],p_level USING '###&','  ';
           IF p_i='1' THEN
               PRINT COLUMN g_c[34],'UTE'
           ELSE
               IF p_i='2' THEN
                   PRINT 'SUB'
                   PRINT COLUMN g_c[34],'SUB'
               ELSE
                   PRINT COLUMN g_c[34],' '
               END IF
           END IF
       END IF
 
   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT g_dash
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw ='n' THEN
          PRINT g_dash
          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
          SKIP 2 LINES
      END IF
END REPORT
