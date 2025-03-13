# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: anmg181.4gl
# Descriptions...: 支票列印作業
# Date & Author..: 92/05/06 BY MAY
# Modify.........: 99/08/03 BY Carol:1.check update nna03之票號值
#                                    2.票號計算:有作廢票號時check票號+1
#                                    3.票號長度調整call_nna03()
# Modify.........: 00/05/12 By Kammy 加簿號
# Modify.........: No.MOD-480228 Kammy 1.若獨立 run 程式 cl_confirm前不要開小窗
# Modify.........: No.MOD-4B0281 04/12/07 By Nicola 新增應付票據資料,存入資料後會出現是列印支票畫面,當回'Y'時,印出來的資料是空白的
# Modify.........: No.FUN-550057 By day   單據編號加大
# Modify.........: No.FUN-560196 05/06/22 By Nicola (A19)列印時 ins tmp:查無此錯誤訊息-11023
# Modify.........: No.MOD-570383 05/08/08 By Smapmin 系統應判斷開票單據確認後才可以列印支票
# Modify.........: NO.MOD-570217 05/07/15 By Yiting 同時有二個user執行該程式,會造成取到同票號且會寫入支票檔內
# Modify.........: No.MOD-5A0284 05/10/21 By Smapmin 將原本的mark拿掉
# Modify.........: No.MOD-5B0184 05/11/29 By Smapmin 空白支票之簿號第一次列印時,因無已開票號,因此需以起始票號為default值
# Modify.........: No.TQC-650057 06/05/12 By alexstar 修改程式中cl_outnam的位置須在assign
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/09 By johnray 報表修改
# Modify.........: No.FUN-710085 07/02/02 By Rayven 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加 CR 參數
# Modify.........: No.MOD-730056 07/04/03 By Smapmin 起始支票號Default有誤
# Modify.........: No.MOD-7C0027 07/12/05 By Smapmin 由背景執行時未default支票號碼
# Modify.........: No.MOD-820172 08/02/27 By Smapmin 由預購單產生的開票資料,開立支票時要回寫預購單的支票號碼
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
# Modify.........: No.MOD-870280 08/07/29 By Sarah 將CR Temptable的nmd07,nmd05改為chr10,台灣版支票到期日應印民國年,大陸版印西元年
# Modify.........: No.TQC-950165 09/05/26 By liuxqa anmt110確認列印支票串過來，action 名稱都是英文。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A60021 10/06/30 By Summer 1.nmd31增加開窗
#                                                   2.畫面增加取票日期欄位,預設值帶 銀行編號+簿號 的最小取票日期
#                                                   3.程式取消max(nna021)改用畫面所指定的取票日期 
# Modify.........: No.FUN-B40087 11/05/16 By yangtt  憑證報表轉GRW
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                      #Print condition RECORD
              wc  LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(600) #Where Condiction
              nmd03 LIKE nmd_file.nmd03,
              nmd31 LIKE nmd_file.nmd31,  #CHI-A60021 mod
              nna021 LIKE nna_file.nna021,#CHI-A60021 add
              nna03 LIKE nna_file.nna03,  #上次對帳日期
              more  LIKE type_file.chr1   #No.FUN-680107 VARCHAR(1) #是否列印其它條件
              END RECORD,
          g_nna03,g_nna03_o   LIKE nna_file.nna03,
          g_nna04   LIKE nna_file.nna04,
          g_nna05   LIKE nna_file.nna05,
          g_nna021  LIKE nna_file.nna021
 
DEFINE   g_cnt      LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_i        LIKE type_file.num5    #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   i          LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE   l_table    STRING                 #No.FUN-710085
DEFINE   g_sql      STRING                 #No.FUN-710085
DEFINE   g_str      STRING                 #No.FUN-710085
 
###GENGRE###START
TYPE sr1_t RECORD
    nmd07 LIKE type_file.chr10,
    nmd05 LIKE type_file.chr10,
    nmd09 LIKE nmd_file.nmd09,
    nmd04 LIKE nmd_file.nmd04,
    nt_note LIKE type_file.chr1000,
    azi04 LIKE azi_file.azi04
END RECORD
###GENGRE###END

MAIN
   #-----MOD-7C0027---------
   DEFINE l_count,l_begin,l_end  LIKE type_file.num10,
          l_head  LIKE nna_file.nna03,
          l_end_c LIKE type_file.chr9,   #LIKE cpd_file.cpd11,   #TQC-b90211
          l_n     LIKE type_file.num5,
          l_nna03   LIKE nna_file.nna03,
          l_tmp     LIKE nna_file.nna03
   #-----END MOD-7C0027-----
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT	                  # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
   #No.FUN-710085 --start--
  #LET g_sql = "nmd07.nmd_file.nmd07,nmd05.nmd_file.nmd05,",    #MOD-870280 mark
   LET g_sql = "nmd07.type_file.chr10,nmd05.type_file.chr10,",  #MOD-870280
               "nmd09.nmd_file.nmd09,nmd04.nmd_file.nmd04,",
               "nt_note.type_file.chr1000,azi04.azi_file.azi04"
 
   LET l_table = cl_prt_temptable('anmg181',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM
   END IF
   #No.FUN-710085 --end--
 
   LET g_pdate = ARG_VAL(1)               # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.nmd03 = ARG_VAL(8)
   LET tm.nmd31  = ARG_VAL(9)    #CHI-A60021 mod 10->9
   LET tm.nna021  = ARG_VAL(10)  #CHI-A60021 add
   LET tm.nna03  = ARG_VAL(11)   #CHI-A60021 mod 9->11
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)  #CHI-A60021 mod 11->12
   LET g_rep_clas = ARG_VAL(13)  #CHI-A60021 mod 12->13
   LET g_template = ARG_VAL(14)  #CHI-A60021 mod 13->14
   LET g_rpt_name = ARG_VAL(15)  #No:FUN-7C0078  #CHI-A60021 mod 14->15
   #No.FUN-570264 ---end---
   #IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN	# If background job sw is off
      IF cl_null(tm.wc) THEN   #No.MOD-4B0281
         CALL anmg181_tm()	        	# Input print condition
      ELSE
         SELECT nna03,nna04,nna05,nna021 INTO
            tm.nna03,g_nna04,g_nna05,g_nna021 FROM nna_file,nma_file
          WHERE nna01 = nma01
            AND nna01 = tm.nmd03
            AND nna02 = tm.nmd31
            AND nna021= tm.nna021 #CHI-A60021 add 
            #CHI-A60021 mark --start--
            #AND nna021= (SELECT MAX(nna021) FROM nna_file
            #              WHERE nna01=tm.nmd03
            #                AND nna02 = tm.nmd31)
            #CHI-A60021 mark --end--
         #-----MOD-7C0027---------
         IF cl_null(tm.nna03) THEN
            SELECT nmw04 INTO tm.nna03 FROM nmw_file
               WHERE nmw01 = tm.nmd03 AND
                     nmw06 = tm.nmd31 AND
                     nmw03 = g_nna021
         END IF
         LET l_count = g_nna04 - g_nna05      #全部位數減後幾位連續位數
         LET l_head  = tm.nna03[1,l_count]
         LET l_begin = tm.nna03[l_count+1,g_nna04]
         FOR i = 1 TO g_nna05
             LET l_end_c = l_end_c CLIPPED,'9'
         END FOR
         LET l_end=l_end_c
         FOR i = l_begin TO l_end
             LET l_count = g_nna04 - g_nna05           #全部位數減後幾位連續位數
             SELECT COUNT(*) INTO l_n  FROM nnz_file   #檢查是否存在作廢檔
              WHERE nnz01=tm.nmd03 AND nnz02=tm.nna03
             IF l_n =0  THEN
                EXIT FOR
             END IF
             LET g_nna03_o = tm.nna03
             LET l_tmp = tm.nna03[l_count+1,g_nna04]+1
	     LET l_nna03 = tm.nna03[l_count+1,g_nna04] + 1
             CALL g181_nna03(g_nna04,l_count,l_nna03,l_tmp) RETURNING
                  l_nna03,l_tmp    #調整位數
            LET tm.nna03[1,l_count] = l_head
            LET tm.nna03[l_count+1,g_nna04] = l_tmp
         END FOR
         #-----END MOD-7C0027-----
         CALL anmg181()                           # Read data and create out-file
      END IF
   #END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION anmg181_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_cmd         LIKE type_file.chr1000,       #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
          l_flag        LIKE type_file.chr1,          #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
          l_jmp_flag    LIKE type_file.chr1           #No.FUN-680107 VARCHAR(1)
   #-----MOD-730056---------
   DEFINE l_count,l_begin,l_end  LIKE type_file.num10,
          l_head        LIKE nna_file.nna03,
          l_end_c       LIKE type_file.chr9,      #LIKE cpd_file.cpd11,   #TQC-B90211
          l_n           LIKE type_file.num5,
          l_nna03       LIKE nna_file.nna03,
          l_tmp         LIKE nna_file.nna03
   #-----END MOD-730056-----
 
 
   LET p_row = 4 LET p_col = 19
   OPEN WINDOW anmg181_w AT p_row,p_col
        WITH FORM "anm/42f/anmg181"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmd01,nmd07
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
 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
		
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmg181_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.nmd03,tm.nmd31,tm.nna021,tm.nna03,tm.more  #CHI-A60021 add tm.nna021
                 WITHOUT DEFAULTS
 
     AFTER FIELD nmd03   #銀行
        IF tm.nmd03 IS NULL OR tm.nmd03 = ' ' THEN
           CALL cl_err(tm.nmd03,'anm-003',0)
           NEXT FIELD nmd03
        ELSE
           SELECT * FROM nma_file
            WHERE nma01 = tm.nmd03
              AND nmaacti IN ('Y','y')
           IF STATUS THEN
#             CALL cl_err(tm.nmd03,'anm-017',0)   #No.FUN-660148
              CALL cl_err3("sel","nma_file",tm.nmd03,"","anm-017","","",0) #No.FUN-660148
              LET tm.nna03 = ' '
              NEXT FIELD nmd03
           ELSE
              DISPLAY BY NAME tm.nna03
           END IF
        END IF
 
      AFTER FIELD nmd31
          #-----MOD-730056---------
          #IF tm.nmd03 IS NULL OR tm.nmd03 = ' ' THEN
          #   CALL cl_err(tm.nmd03,'anm-003',0)
          IF tm.nmd31 IS NULL OR tm.nmd31 = ' ' THEN
             CALL cl_err(tm.nmd31,'anm-003',0)
          #-----END MOD-730056-----
             NEXT FIELD nmd31
          ELSE
             #CHI-A60021 add --start--
             IF cl_null(tm.nna021) THEN
                SELECT MIN(nmw03) INTO g_nna021 FROM nmw_file
                 WHERE nmw01=tm.nmd03
                   AND nmw06 = tm.nmd31
                LET tm.nna021 = g_nna021
             END IF
             #CHI-A60021 add --end--
            #CHI-A60021 搬到nna021做 --start-- 
            #SELECT nna03,nna04,nna05,nna021
            #  INTO tm.nna03,g_nna04,g_nna05,g_nna021
            # FROM nna_file
            # WHERE nna01 = tm.nmd03
            #   AND nna02 = tm.nmd31
            #   AND nna06 IN ('Y','y')  #為可套印
            #   AND nna021= (SELECT MAX(nna021) FROM nna_file
            #           WHERE nna01=tm.nmd03
            #             AND nna02 = tm.nmd31)
            #IF STATUS THEN
#           #   CALL cl_err(tm.nmd31,'anm-954',0)   #No.FUN-660148
            #   CALL cl_err3("sel","nna_file",tm.nmd03,tm.nmd03,"anm-954","","",0) #No.FUN-660148
            #   LET tm.nna03 = ' '
            #   NEXT FIELD nmd31
            #ELSE
#MOD-5B0184
            #  IF cl_null(tm.nna03) THEN
            #     SELECT nmw04 INTO tm.nna03 FROM nmw_file
            #        WHERE nmw01 = tm.nmd03 AND
            #              nmw06 = tm.nmd31 AND
            #              nmw03 = g_nna021
            #  END IF
#END MOD-5B0184
            #   #-----MOD-730056---------
            #   LET l_count = g_nna04 - g_nna05      #全部位數減後幾位連續位數
            #   LET l_head  = tm.nna03[1,l_count]
            #   LET l_begin = tm.nna03[l_count+1,g_nna04]
            #   FOR i = 1 TO g_nna05
            #       LET l_end_c = l_end_c CLIPPED,'9'
            #   END FOR
            #   LET l_end=l_end_c
            #   FOR i = l_begin TO l_end
            #       LET l_count = g_nna04 - g_nna05           #全部位數減後幾位連續位數
            #       SELECT COUNT(*) INTO l_n  FROM nnz_file   #檢查是否存在作廢檔
            #        WHERE nnz01=tm.nmd03 AND nnz02=tm.nna03
            #       IF l_n =0  THEN
            #          EXIT FOR
            #       END IF
            #       LET g_nna03_o = tm.nna03
            #       LET l_tmp = tm.nna03[l_count+1,g_nna04]+1
	    #       LET l_nna03 = tm.nna03[l_count+1,g_nna04] + 1
            #       CALL g181_nna03(g_nna04,l_count,l_nna03,l_tmp) RETURNING
            #            l_nna03,l_tmp    #調整位數
            #      LET tm.nna03[1,l_count] = l_head
            #      LET tm.nna03[l_count+1,g_nna04] = l_tmp
            #   END FOR
            #   #-----END MOD-730056-----
            #   DISPLAY BY NAME tm.nna03
            #END IF
            #CHI-A60021 搬到nna021做 --end-- 
          END IF
 
      #CHI-A60021 add --start--
      AFTER FIELD nna021
         IF tm.nna021 IS NULL OR tm.nna021 = ' ' THEN
            CALL cl_err(tm.nna021,'anm-003',0)
            NEXT FIELD nna021
          ELSE
             SELECT nna03,nna04,nna05
               INTO tm.nna03,g_nna04,g_nna05
              FROM nna_file
              WHERE nna01 = tm.nmd03
                AND nna02 = tm.nmd31
                AND nna06 IN ('y','Y')  #為可套印
                AND nna021 = tm.nna021 
             IF STATUS THEN
                CALL cl_err3("sel","nna_file",tm.nmd03,tm.nmd31,"anm-954","","",0)
                LET tm.nna03 = ' '
                NEXT FIELD nmd03
             ELSE
                IF cl_null(tm.nna03) THEN
                   SELECT nmw04 INTO tm.nna03 FROM nmw_file
                      WHERE nmw01 = tm.nmd03 AND
                            nmw06 = tm.nmd31 AND
                            nmw03 = g_nna021
                END IF
                LET l_count = g_nna04 - g_nna05      #全部位數減後幾位連續位數
                LET l_head  = tm.nna03[1,l_count]
                LET l_begin = tm.nna03[l_count+1,g_nna04]
                FOR i = 1 TO g_nna05
                    LET l_end_c = l_end_c CLIPPED,'9'
                END FOR
                LET l_end=l_end_c
                FOR i = l_begin TO l_end
                    LET l_count = g_nna04 - g_nna05           #全部位數減後幾位連續位數
                    SELECT COUNT(*) INTO l_n  FROM nnz_file   #檢查是否存在作廢檔
                     WHERE nnz01=tm.nmd03 AND nnz02=tm.nna03
                    IF l_n =0  THEN
                       EXIT FOR
                    END IF
                    LET g_nna03_o = tm.nna03
                    LET l_tmp = tm.nna03[l_count+1,g_nna04]+1
	            LET l_nna03 = tm.nna03[l_count+1,g_nna04] + 1
                    CALL g181_nna03(g_nna04,l_count,l_nna03,l_tmp) RETURNING
                         l_nna03,l_tmp    #調整位數
                   LET tm.nna03[1,l_count] = l_head
                   LET tm.nna03[l_count+1,g_nna04] = l_tmp
                END FOR
                DISPLAY BY NAME tm.nna03
             END IF
          END IF
      #CHI-A60021 add --end--

      AFTER FIELD nna03
         IF tm.nna03 IS NULL OR tm.nna03 = ' ' THEN
            CALL cl_err(tm.nna03,'anm-003',0)
            NEXT FIELD nna03
         END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
     AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
       LET l_flag='N'
       IF INT_FLAG THEN EXIT INPUT  END IF
       IF tm.nmd03 IS NULL THEN
           LET l_flag='Y'
           DISPLAY BY NAME tm.nmd03
           NEXT FIELD nmd03
       END IF
       IF tm.nna03 IS NULL THEN
           LET l_flag='Y'
           DISPLAY BY NAME tm.nna03
           NEXT FIELD nna03
       END IF
       IF l_flag='Y' THEN
          CALL cl_err('','9033',0)
          NEXT FIELD nna03
       END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON ACTION CONTROLP
           CASE
               WHEN INFIELD(nmd03)
#                 CALL q_nma(0,0,tm.nmd03) RETURNING tm.nmd03
#                 CALL FGL_DIALOG_SETBUFFER( tm.nmd03 )
    CALL cl_init_qry_var()
    LET g_qryparam.form = 'q_nma'
    LET g_qryparam.default1 = tm.nmd03
    CALL cl_create_qry() RETURNING tm.nmd03
#    CALL FGL_DIALOG_SETBUFFER( tm.nmd03 )
                  DISPLAY BY NAME tm.nmd03
                  NEXT FIELD nmd03
              #CHI-A60021 add --start--
              WHEN INFIELD(nmd31)
                 CALL q_nmw(FALSE,TRUE,tm.nna021,tm.nmd03) RETURNING tm.nmd31,tm.nna021,tm.nna03
                 DISPLAY BY NAME tm.nmd31
                 NEXT FIELD nmd31
              #CHI-A60021 add --end--
              OTHERWISE EXIT CASE
          END CASE
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmg181_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmg181'
      IF STATUS OR l_cmd IS NULL THEN
          CALL cl_err('anmg181','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.nmd03 CLIPPED,"'",
                         " '",tm.nmd31 CLIPPED,"'",  #CHI-A60021 mod
                         " '",tm.nna021 CLIPPED,"'", #CHI-A60021 add
                         " '",tm.nna03 CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmg181',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmg181_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmg181()
   ERROR ""
END WHILE
   CLOSE WINDOW anmg181_w
END FUNCTION
 
FUNCTION anmg181()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#         l_time    LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_n       LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_za05    LIKE type_file.chr1000, #標題內容 #No.FUN-680107 VARCHAR(40)
	  l_date    LIKE type_file.dat,     #No.FUN-680107 DATE
	  l_str     LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(40)
	  l_str1    LIKE type_file.chr20,   #No.FUN-680107 VARCHAR(20)
	  l_ans     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          l_i       LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_head    LIKE nna_file.nna03,    #No.FUN-680107 VARCHAR(10)
          l_head1   LIKE nna_file.nna03,    #No.FUN-680107 VARCHAR(10)
          l_end_c   LIKE type_file.chr9,    #LIKE cpd_file.cpd11,    #No.FUN-680107 VARCHAR(9)   #TQC-B90211
	  l_nna03   LIKE nna_file.nna03,
          l_tmp     LIKE nna_file.nna03,
	  l_count   LIKE type_file.num10,   #No.FUN-680107 INTEGER
	  l_cnt     LIKE type_file.num10,   #No.FUN-680107 INTEGER
	  l_begin   LIKE type_file.num10,   #No.FUN-680107 INTEGER
	  l_end     LIKE type_file.num10,   #No.FUN-680107 INTEGER
          l_nmw04   LIKE nmw_file.nmw04,
          l_nmw05   LIKE nmw_file.nmw05,
          l_nmd05   LIKE type_file.chr10,   #MOD-870280 add
          l_nmd07   LIKE type_file.chr10,   #MOD-870280 add
          sr        RECORD
                     nmd01    LIKE nmd_file.nmd01,
                     nmd04    LIKE nmd_file.nmd04,
                     nmd05    LIKE nmd_file.nmd05,
                     nmd07    LIKE nmd_file.nmd07,
                     nmd08    LIKE nmd_file.nmd08,
                     nmd09    LIKE nmd_file.nmd09,
                     nmd21    LIKE nmd_file.nmd21,
                     nt_note  LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(100)
                    END RECORD,
          sr1       RECORD
                     seq      LIKE type_file.num5,    #No.FUN-680107 SMALLINT
                     nmd01    LIKE nmd_file.nmd01,    #No.FUN-550057 
                     chkno    LIKE nmd_file.nmd02,    #No.FUN-680107 VARCHAR(10)
                     no_next  LIKE nna_file.nna03     #No.FUN-680107 VARCHAR(10)
                    END RECORD,
          l_seq     LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          chkno_b   LIKE nmd_file.nmd02,   #No.FUN-680107 VARCHAR(10)
          chkno_e   LIKE nmd_file.nmd02,   #No.FUN-680107 VARCHAR(10)
          chkno_l   LIKE nmd_file.nmd02,   #No.FUN-680107 VARCHAR(10)
          p_row     LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          p_col     LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
     #no.4849 只回寫到截止票號
#    DROP TABLE g181_temp;
#No.FUN-680107 --start 
#    CREATE TEMP TABLE g181_temp
#    (seq       smallint,       #序號
#     nmd01     VARCHAR(16),       #開票單號  #No.FUN-560196
#     chkno     VARCHAR(10),       #回寫的支票號碼
#     no_next   VARCHAR(10)        #下次列印支票號
#    );

#FUN-B40087 -----mark str-------- 
     #No.FUN-680107--欄位類型修改
#    CREATE TEMP TABLE g181_temp
#    (seq   LIKE type_file.num5,  
#     nmd01 LIKE nmd_file.nmd01,
#     chkno LIKE nmd_file.nmd02,
#     no_next LIKE nna_file.nna03
#    );
     #No.FUN-680107 --end
#FUN-B40087 -----mark  end ----
 
     #no.4849(end)
 
     CALL cl_del_data(l_table)  #No.FUN-710085     
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmg181'
#NO.CHI-6A0004--BEGIN
#   SELECT azi04,azi05 INTO g_azi04,g_azi05
#		FROM azi_file WHERE azi01 = g_aza.aza17
#
#   IF STATUS THEN 
#     CALL cl_err(g_azi05,STATUS,0) #FUN-660148
#      CALL cl_err3("sel","azi_file",g_aza.aza17,"",STATUS,"","",0) #FUN-660148
#      END IF
#NO.CHI-6A0004--END
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND nmduser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND nmdgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND nmdgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup')
   #End:FUN-980030
 
   LET l_sql="SELECT nmw04,nmw05  FROM nmw_file ",        #支票簿
             " WHERE nmw01='",tm.nmd03 CLIPPED, "' AND ",
             "  nmw06 = ",tm.nmd31," AND ",
             "  nmw03 = '",tm.nna021,"'" #CHI-A60021 add
            #CHI-A60021 mark --start--
            # " nmw03 = ( ",
            # "SELECT MAX(nmw03) FROM nmw_file  ",
            # " WHERE nmw01 = '",tm.nmd03 CLIPPED,"' AND ",
            # "   nmw06 = ",tm.nmd31," AND ",
            # "   nmwacti = 'Y')"
            #CHI-A60021 mark --end--
   PREPARE g181_nmw_prepare FROM l_sql       # RUNTIME 編譯
   DECLARE g181_nmw_cs                       # SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR g181_nmw_prepare
 
     LET l_sql = "SELECT nmd01,nmd04,nmd05,nmd07,nmd08,nmd09,nmd21,' '",
                 " FROM nmd_file ",
 #                 " WHERE nmd30 <> 'X' AND ",tm.wc CLIPPED,   #MOD-570383
                  " WHERE nmd30 = 'Y' AND ",tm.wc CLIPPED,   #MOD-570383
                 " AND (nmd02 IS NULL OR nmd02 = ' ') ",
                 " AND nmd03 = '",tm.nmd03,"' ",   #MOD-5A0284
                 " AND nmd31 = '",tm.nmd31,"' ",   #MOD-5A0284
                 " ORDER BY nmd01 "
     PREPARE anmg181_prepare1 FROM l_sql
     IF STATUS != 0 THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM 
     END IF
     DECLARE anmg181_curs1 CURSOR FOR anmg181_prepare1
#    CALL cl_outnam('anmg181') RETURNING l_name  #No.FUN-710085 mark
#No.TQC-6A0110 -- begin --
#   #TQC-650057---start---
#     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#   #TQC-650057---end---
#No.TQC-6A0110 -- end --
     LET g_pageno = 0
     LET g_cnt    = 1
 
#    START REPORT anmg181_rep TO l_name  #No.FUN-710085 mark
     FOREACH anmg181_curs1 INTO sr.*
       IF STATUS != 0 THEN
          CALL cl_err('foreach:',STATUS,1) LET g_success = 'N' EXIT FOREACH
       END IF
       IF g_cnt = 1 THEN  LET g_nna03 = tm.nna03 END IF   #本次作業第一次
       #No.+001 010320 add by linda
       IF g_cnt >1 THEN
         IF l_nmw04 > g_nna03  OR l_nmw05 < g_nna03  THEN  #check是否在支票簿中
            CALL cl_err(g_nna03,'anm-647',1) LET g_success = 'N' EXIT FOREACH
         END IF
       END IF
       #No.+001 end
         #-------- modify by kammy in 99/07/02 NO:0373----------
         LET l_count = g_nna04 - g_nna05      #全部位數減後幾位連續位數
         LET l_head  = g_nna03[1,l_count]
         LET l_begin = g_nna03[l_count+1,g_nna04]
         FOR i = 1 TO g_nna05
             LET l_end_c = l_end_c CLIPPED,'9'
         END FOR
         LET l_end=l_end_c
         FOR i = l_begin TO l_end
             LET l_count = g_nna04 - g_nna05           #全部位數減後幾位連續位數
             SELECT COUNT(*) INTO l_n  FROM nnz_file   #檢查是否存在作廢檔
              WHERE nnz01=tm.nmd03 AND nnz02=g_nna03
             IF l_n =0  THEN
                LET g_nna03_o = g_nna03
	        LET l_nna03 = g_nna03[l_count+1,g_nna04]+1
                LET l_tmp   = g_nna03[l_count+1,g_nna04]+1
                CALL g181_nna03(g_nna04,l_count,l_nna03,l_tmp) RETURNING
                     l_nna03,l_tmp   #調整位數
                LET g_nna03[l_count+1,g_nna04] = l_tmp       #下一號
                EXIT FOR
             END IF
             LET g_nna03_o = g_nna03
             LET l_tmp = g_nna03[l_count+1,g_nna04]+1
	     LET l_nna03 = g_nna03[l_count+1,g_nna04] + 1
          #  LET g_nna03 [l_count+1,g_nna04] = l_tmp
	  #  LET l_nna03 = g_nna03[l_count+1,g_nna04] + 1
             CALL g181_nna03(g_nna04,l_count,l_nna03,l_tmp) RETURNING
                  l_nna03,l_tmp    #調整位數
            LET g_nna03[1,l_count] = l_head
            LET g_nna03[l_count+1,g_nna04] = l_tmp
         END FOR
         #----------------------------------------------------------
 
       #------check支票簿中票號是否存在--------------------------
       LET l_count = g_nna04 - g_nna05      #全部位數減後幾位連續位數
       LET l_head  = g_nna03_o[1,l_count]
       LET l_head1 = l_head CLIPPED,'*' CLIPPED
       OPEN g181_nmw_cs
       FETCH g181_nmw_cs INTO l_nmw04,l_nmw05
       IF ( cl_null(l_nmw04) OR cl_null(l_nmw05) ) THEN
             CALL cl_err(g_nna03,'anm-647',1) LET g_success = 'N' EXIT FOREACH
       END IF
 
       IF l_nmw04 > g_nna03_o OR l_nmw05 < g_nna03_o THEN #check是否在支票簿中
          CALL cl_err(g_nna03_o,'anm-647',1) LET g_success = 'N' EXIT FOREACH
       END IF
       #----------------------------------------------------------
       #取得下次回寫票號
       LET g_nna03[1,l_count] = l_head
       LET g_nna03[l_count+1,g_nna04] = l_nna03
 
       CALL s_sayc(sr.nmd04,100) RETURNING sr.nt_note
 
      #str MOD-870280 add
       LET l_nmd07 = ' '   LET l_nmd05 = ' '
       IF g_aza.aza26='0' THEN   #台灣版要印民國年
          LET l_nmd07 = YEAR(sr.nmd07)-1911 USING '&&&','/',
                        MONTH(sr.nmd07) USING '&&','/',
                        DAY(sr.nmd07) USING '&&'
          LET l_nmd05 = YEAR(sr.nmd05)-1911 USING '&&&','/',
                        MONTH(sr.nmd05) USING '&&','/',
                        DAY(sr.nmd05) USING '&&'
       ELSE
          LET l_nmd07 = YEAR(sr.nmd07) USING '&&&&','/',
                        MONTH(sr.nmd07) USING '&&','/',
                        DAY(sr.nmd07) USING '&&'
          LET l_nmd05 = YEAR(sr.nmd05) USING '&&&&','/',
                        MONTH(sr.nmd05) USING '&&','/',
                        DAY(sr.nmd05) USING '&&'
       END IF
      #end MOD-870280 add
 
       #No.TQC-710085
       SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=sr.nmd21
       EXECUTE insert_prep USING
         #sr.nmd07,sr.nmd05,sr.nmd09,sr.nmd04,sr.nt_note,t_azi04   #MOD-870280 mark
          l_nmd07,l_nmd05,sr.nmd09,sr.nmd04,sr.nt_note,t_azi04     #MOD-870280
       #No.FUN-710085
 
#      OUTPUT TO REPORT anmg181_rep(sr.*)  #No.FUN-710085 mark

#FUN-B40087 mark  ----str 
       #no.4849 只回寫到截止票號
#      INSERT INTO g181_temp VALUES(g_cnt,sr.nmd01,g_nna03_o,g_nna03)    #FUN-B40087 mark
#      IF STATUS THEN
#         CALL cl_err('ins tmp:',STATUS,1)   #No.FUN-660148
#         CALL cl_err3("ins","g181_temp","","",STATUS,"","ins tmp:",1) #No.FUN-660148
#         EXIT FOREACH
#      END IF
#FUN-B40087 mark  -----end
       #no.4849 (end)
 
       LET g_cnt = g_cnt + 1
     END FOREACH
#    FINISH REPORT anmg181_rep                     #No.FUN-710085 mark 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #No.FUN-710085 mark
 
     #No.FUN-710085 --start--
     CALL cl_wcchp(tm.wc,'nmd01,nmd07')
          RETURNING tm.wc
###GENGRE###     LET g_str = tm.wc,";",g_zz05
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730088
   # CALL cl_prt_cs3('anmg181',l_sql,g_str)
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###     CALL cl_prt_cs3('anmg181','anmg181',l_sql,g_str)
    CALL anmg181_grdata()    ###GENGRE###
     #No.FUN-710085 --end--
 
  #no.4849 只回寫到截止票號
  WHILE TRUE
     IF g_cnt > 1 THEN
 
         #No.MOD-480228
        IF g_bgjob = 'Y' THEN
           #注意：不可將此 window 拿掉，否則 anmt100串過來 cl_confirm會有問題
           OPEN WINDOW dummy AT 20,20 WITH 1 ROWS,1 COLUMNS
#No.TQC-950165 add by liuxqa 
           CALL cl_load_act_sys('anmg181')
           CALL cl_load_act_list('anmg181')
#No.TQC-950165 add by liuxqa 
           IF NOT cl_confirm('anm-110') THEN
              CLOSE WINDOW dummy
              EXIT WHILE
           ELSE
              CLOSE WINDOW dummy
           END IF
        ELSE
           IF NOT cl_confirm('anm-110') THEN
              EXIT WHILE
           END IF
        END IF
         #No.MOD-480228 (end)
#FUN-B40087 mark----str   
#       SELECT chkno INTO chkno_e FROM g181_temp
#        WHERE seq = (SELECT MAX(seq) FROM g181_temp)
#        LET chkno_l = chkno_e
#FUN-B40087 mark----end
        display 'kammy test:'
        LET p_row = 10 LET p_col = 20
        OPEN WINDOW anmg181a_w AT p_row,p_col
         WITH FORM "anm/42f/anmg181a"
               ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
        CALL cl_ui_locale("anmg181a")
#No.TQC-950165 add --begin--
        CALL cl_load_act_sys('anmg181')
        CALL cl_load_act_list('anmg181')
#No.tqc-950165 add --end--
 
        DISPLAY tm.nna03,chkno_e TO chkno_b,chkno_e
        INPUT BY NAME chkno_l WITHOUT DEFAULTS
            AFTER FIELD chkno_l
               IF cl_null(chkno_l) THEN NEXT FIELD chkno_l END IF
               IF chkno_l < tm.nna03 OR chkno_l > chkno_e THEN
                  CALL cl_err('','anm-900',0)  NEXT FIELD chkno_l
               END IF
#FUN-B40087 mark----str
#              SELECT seq INTO l_seq FROM g181_temp
#               WHERE chkno = chkno_l
#              IF STATUS THEN
#                 CALL cl_err('sel seq:',STATUS,0)   #No.FUN-660148
#                 CALL cl_err3("sel","g181_temp",chkno_l,"",STATUS,"","sel seq:",0) #No.FUN-660148
#                 NEXT FIELD chkno_l
#              END IF
#FUN-B40087 mark----end
     	   ON IDLE g_idle_seconds
     	      CALL cl_on_idle()
     	      CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
     	
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
     	END INPUT
#       IF INT_FLAG THEN LET INT_FLAG = 0
#          CLOSE WINDOW anmg181a_w EXIT WHILE
#       END IF
 
#       BEGIN WORK LET g_success='Y'
#FUN-B40087 mark----str
#       DECLARE tmp_cs CURSOR FOR
#         SELECT * FROM g181_temp WHERE seq <= l_seq
#       FOREACH tmp_cs INTO sr1.*
#
#        #MOD-570217
#       LET l_cnt = 0
#       SELECT COUNT(*) INTO l_cnt  FROM nmd_file
#        WHERE nmd02 = sr1.chkno
#       IF l_cnt > 0 THEN
#          CALL cl_err('ins nmd:',-239,0)
#          LET g_success = 'N'
#          EXIT FOREACH
#       END IF
#       #--end
#
#           #更新應付帳款之票號
#           UPDATE nmd_file SET nmd02 = sr1.chkno,
#                               nmd31 = tm.nmd31      #No:7345
#            WHERE nmd01 = sr1.nmd01
#           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]= 0  THEN
#              CALL cl_err('upd nmd:',STATUS,1)   #No.FUN-660148
#              CALL cl_err3("upd","nmd_file",sr1.nmd01,"",STATUS,"","upd nmd:",1) #No.FUN-660148
#              LET g_success = 'N' EXIT FOREACH
#           END IF
#           #-----MOD-820172---------
#           LET l_cnt = 0 
#           SELECT COUNT(*) INTO l_cnt FROM ala_file
#             WHERE ala931= sr1.nmd01
#           IF l_cnt > 0 THEN
#              UPDATE ala_file SET ala932=sr1.chkno
#                WHERE ala931=sr1.nmd01
#              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]= 0  THEN
#                 CALL cl_err3("upd","ala_file",sr1.nmd01,"",STATUS,"","upd ala:",1) 
#                 LET g_success = 'N' EXIT FOREACH
#              END IF
#           END IF
#           #-----END MOD-820172-----
#           #更新支票簿號檔之下次列印支票號
#           UPDATE nna_file SET nna03 = sr1.no_next
#            WHERE nna01 = tm.nmd03 AND nna02 = tm.nmd31
#              AND nna021 = g_nna021
#           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]= 0  THEN
#              CALL cl_err('upd nna:',STATUS,1)   #No.FUN-660148
#              CALL cl_err3("upd","nna_file",tm.nmd03,tm.nmd31,STATUS,"","upd nna:",1) #No.FUN-660148
#              LET g_success = 'N' EXIT FOREACH
#           END IF
#           MESSAGE "update ......"
#           CALL ui.Interface.refresh()
#       END FOREACH
#       IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
        MESSAGE ""
        CALL ui.Interface.refresh()
        CLOSE WINDOW anmg181a_w
     END IF
     EXIT WHILE
  END WHILE
#FUN-B40087 mark-----end
  #no.4849(end)
#  CLOSE WINDOW anmg181a_w 
END FUNCTION
 
#No.FUN-710085 --start-- mark
{REPORT anmg181_rep(sr)
   DEFINE l_last_sw	    LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_p_flag      LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_flag1       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          sr            RECORD
                        nmd01    LIKE nmd_file.nmd01,
                        nmd04    LIKE nmd_file.nmd04,
                        nmd05    LIKE nmd_file.nmd05,
                        nmd07    LIKE nmd_file.nmd07,
                        nmd08    LIKE nmd_file.nmd08,
                        nmd09    LIKE nmd_file.nmd09,
                        nmd21    LIKE nmd_file.nmd21,
                        nt_note  LIKE type_file.chr1000#No.FUN-680107 VARCHAR(100)
                        END RECORD
  OUTPUT TOP MARGIN 0
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN 5
         PAGE LENGTH g_page_line
  FORMAT
 
   ON EVERY ROW
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=sr.nmd21
      PRINT COLUMN 25,sr.nmd07 CLIPPED
      PRINT COLUMN 25,sr.nmd05 CLIPPED
      PRINT COLUMN 25,sr.nmd09 CLIPPED
      PRINT COLUMN 25,cl_numfor(sr.nmd04,18,t_azi04),' ',sr.nt_note CLIPPED
END REPORT}
#No.FUN-710085 --end--
 
FUNCTION g181_nna03(l_nna04,l_count,l_nna03,l_tmp)
   DEFINE l_nna04   LIKE nna_file.nna04,
	        l_nna03   LIKE nna_file.nna03,
          l_tmp     LIKE nna_file.nna03,
          l_count   LIKE type_file.num10 	#No.FUN-680107 INTEGER
 
	     CASE l_nna04-l_count
                  WHEN 1 LET l_nna03 = l_nna03 USING  '&'
                         LET l_tmp   = l_tmp   USING  '&'
	          WHEN 2 LET l_nna03 = l_nna03 USING  '&&'
                         LET l_tmp   = l_tmp   USING  '&&'
                  WHEN 3 LET l_nna03 = l_nna03 USING  '&&&'
                         LET l_tmp   = l_tmp   USING  '&&&'
                  WHEN 4 LET l_nna03 = l_nna03 USING  '&&&&'
                         LET l_tmp   = l_tmp   USING  '&&&&'
                  WHEN 5 LET l_nna03 = l_nna03 USING  '&&&&&'
                         LET l_tmp   = l_tmp   USING  '&&&&&'
                  WHEN 6 LET l_nna03 = l_nna03 USING  '&&&&&&'
                         LET l_tmp   = l_tmp   USING  '&&&&&&'
                  WHEN 7 LET l_nna03 = l_nna03 USING  '&&&&&&&'
                         LET l_tmp   = l_tmp   USING  '&&&&&&&'
                  WHEN 8 LET l_nna03 = l_nna03 USING  '&&&&&&&&'
                         LET l_tmp   = l_tmp   USING  '&&&&&&&&'
                  WHEN 9 LET l_nna03 = l_nna03 USING  '&&&&&&&&&'
                         LET l_tmp   = l_tmp   USING  '&&&&&&&&&'
                  WHEN 10 LET l_nna03 = l_nna03 USING '&&&&&&&&&&'
                          LET l_tmp   = l_tmp   USING '&&&&&&&&&&'
                  OTHERWISE EXIT  CASE
            END CASE
   RETURN l_nna03,l_tmp
END FUNCTION
#Patch....NO.TQC-610036 <001> #

###GENGRE###START
FUNCTION anmg181_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("anmg181")
        IF handler IS NOT NULL THEN
            START REPORT anmg181_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE anmg181_datacur1 CURSOR FROM l_sql
            FOREACH anmg181_datacur1 INTO sr1.*
                OUTPUT TO REPORT anmg181_rep(sr1.*)
            END FOREACH
            FINISH REPORT anmg181_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT anmg181_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_nmd04_fmt  STRING    #FUN-B40087 
    
    ORDER EXTERNAL BY sr1.nmd07
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.nmd07
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            LET l_nmd04_fmt = cl_gr_numfmt('nmd_file','nmd04',sr1.azi04)   #FUN-B40087
            PRINTX l_nmd04_fmt                                             #FUN-B40087 

            PRINTX sr1.*

        AFTER GROUP OF sr1.nmd07

        
        ON LAST ROW

END REPORT
###GENGRE###END
