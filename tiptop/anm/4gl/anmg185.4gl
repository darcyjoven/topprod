# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: anmg185.4gl
# Descriptions...: 支票列印作業
# Date & Author..: 92/05/06 BY MAY
# Modify.........: 99/08/03 BY Carol:1.check update nna03之票號值
#                                    2.票號計算:有作廢票號時check票號+1
#                                    3.票號長度調整call_nna03()
# Modify.........: 00/05/12 By Kammy 加簿號
# Modify.........: No.MOD-480228 Kammy 1.若沒有符合的條件，仍會問是否更新anmt100
# Modify.........: No.MOD-4B0281 04/12/07 By Nicola 新增應付票據資料,存入資料後會出現是列印支票畫面,當回'Y'時,印出來的資料是空白的
# Modify.........: No.FUN-550057 By day   單據編號加大
# Modify.........: No.FUN-560196 05/06/22 By Nicola (A19)列印時 ins tmp:查無此錯誤訊息-11023
# Modify.........: No.TQC-650057 06/05/12 By alexstar 修改程式中cl_outnam的位置須在assign
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/09 By johnray 報表修改
# Modify.........: No.TQC-6B0130 06/11/27 By Smapmin 簿號判斷有誤時,跳回銀行欄位
# Modify.........: No.FUN-710085 07/02/09 By Rayven 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.MOD-730056 07/04/03 By Smapmin 起始支票號Default有誤
# Modify.........: No.FUN-740023 07/04/10 By Sarah 傳到cl_prt_cs3()的第二個參數打錯字
# Modify.........: No.FUN-750133 07/05/30 By kim 格式代號增加開窗
# Modify.........: No.TQC-750226 07/05/30 By anmt100確認列印支票串過來，action名稱都是英文
# Modify.........: No.MOD-760130 07/06/27 By Smapmin 受款人不足10位元的要補足10位元
# Modify.........: No.MOD-770071 07/07/17 By Smapmin 由於 anmt100 備註不見得維護實際帳號,因此請採 anmi030 帳號為主
# Modify.........: No.CHI-7A0004 07/10/08 By Smapmin 列印金額應靠左
# Modify.........: No.MOD-820172 08/02/27 By Smapmin 由預購單產生的開票資料,開立支票時要回寫預購單的支票號碼
# Modify.........: No.MOD-830042 08/03/12 By Smapmin 恢復FUN-710085/調整MOD-760130,MOD-770071,CHI-7A0004
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
# Modify.........: No.MOD-850202 08/05/26 By Sarah 重新執行時清空起始支票號(nna03)欄位
# Modify.........: No.MOD-860136 08/06/16 By Sarah anms110設定資料印在同一行,印出來卻是兩行
# Modify.........: No.FUN-860063 08/06/17 By Carol 民國年欄位放大
# Modify.........: No.MOD-870280 08/07/29 By Sarah 台灣版支票到期日應印民國年,大陸版印西元年
# Modify.........: No.FUN-830027 09/04/29 By Sabrina 回復CR功能，報表列印格式提供兩種方式讓使用者選擇：(1)zaa格式(2)cr格式
# Modify.........: No.MOD-960278 09/06/24 By Sarah 回寫nmd02前,先檢查支票號碼是否已存在,若重覆取號需提示錯誤訊息並ROLLBACK
# Modify.........: No.MOD-970233 09/07/24 By mike 在計算受款人之后要印小寫金額的空格數時，不應該用資料庫中所存的資料長度，若客戶為un
#                                                 一個中文字不等於2個byte，這樣會造成計算及版面不整齊，                             
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-950024 09/09/25 By hongmei 國字數字改由p_ze抓，不寫死
# Modify.........: No:MOD-A10047 10/01/08 By Sarah 調整參數tm.r接收的位置
# Modify.........: No.FUN-9C0073 10/01/15 By chenls 程序精簡
# Modify.........: No:MOD-A60143 10/06/22 By Dido 增加 npy02 排序 
# Modify.........: No:CHI-A60021 10/06/30 By Summer 1.nmd31增加開窗
#                                                   2.畫面增加取票日期欄位,預設值帶 銀行編號+簿號 的最小取票日期
#                                                   3.程式取消max(nna021)改用畫面所指定的取票日期 
# Modify.........: No:MOD-A70055 10/07/07 By Dido 應判斷開票單據確認後才可以列印支票
# Modify.........: No:MOD-A40099 10/08/03 By sabrina 日期抓取民國年時，USING改為'&&&' 
# Modify.........: No:MOD-B10053 11/01/07 By Dido 字碼切割需轉換為 Big-5 方式計算 
# Modify.........: No.FUN-B40087 11/06/14 By yangtt  憑證報表轉GRW
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No.FUN-C10036 12/01/11 By xuxz FUN-B80067,TQC-B90211,MOD-BC0250 追單
# Modify.........: No.FUN-C40036 12/04/10 By xujing GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50007 12/05/02 By minpp GR程序優化	
# Modify.........: No.FUN-C40036 12/07/23 By xujing GR報表列印動態簽核還原
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                        #Print condition RECORD
            wc    LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(600) #Where Condiction
            nmd03 LIKE nmd_file.nmd03,
            nmd31 LIKE nmd_file.nmd31,   #CHI-A60021 mod
            nna021 LIKE nna_file.nna021, #CHI-A60021 add
            nna03 LIKE nna_file.nna03,   #上次對帳日期
            npx01 LIKE npx_file.npx01,
            a,b   LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
            more  LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1) #是否列印其它條件
            r     LIKE type_file.chr1    #No.FUN-830027 VARCHAR(1) #選擇要列印的報表格式
           END RECORD,
       g_nna03,g_nna03_o   LIKE nna_file.nna03,
       g_nna04    LIKE nna_file.nna04,
       g_nna05    LIKE nna_file.nna05,
       g_nna021   LIKE nna_file.nna021
DEFINE g_cnt      LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_i        LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE i          LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE l_table    STRING                 #No.FUN-710085   #MOD-830042    #FUN-830027 取消mark
DEFINE g_sql      STRING                 #No.FUN-710085   #MOD-830042    #FUN-830027 取消mark
 
###GENGRE###START
TYPE sr1_t RECORD
    nmd01 LIKE nmd_file.nmd01,
    nmd02 LIKE nmd_file.nmd02,
    npy02 LIKE npy_file.npy02,
    str LIKE type_file.chr1000 
#   #FUN-C40036---mark--str---
#   sign_type LIKE type_file.chr1,
#   sign_img LIKE type_file.blob,
#   sign_show LIKE type_file.chr1,
#   sign_str LIKE type_file.chr1000
#   #FUN-C40036---mark--end---
END RECORD
###GENGRE###END

MAIN
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
 
  #LET g_sql = "nmd01.nmd_file.nmd01,nmd02.nmd_file.nmd02,str.type_file.chr1000"                          #MOD-A60143 mark
   LET g_sql = "nmd01.nmd_file.nmd01,nmd02.nmd_file.nmd02,npy02.npy_file.npy02,str.type_file.chr1000"     #MOD-A60143
   #         ,",sign_type.type_file.chr1,sign_img.type_file.blob,",           #FUN-C40036 add  #FUN-C40036 mark 
   #           "sign_show.type_file.chr1,sign_str.type_file.chr1000"          #FUN-C40036 add  #FUN-C40036 mark
   
   LET l_table = cl_prt_temptable('anmg185',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
#              " VALUES(?,?,?,?,?,?,?,?)"                                   #MOD-A60143 add ? #FUN-C40036 add 4 ? #FUN-C40036 mark
               " VALUES(?,?,?,?)"                                           #FUN-C40036 add
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM
   END IF
 
   LET g_pdate  = ARG_VAL(1)               # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.nmd03 = ARG_VAL(8)
   LET tm.nna03 = ARG_VAL(9)
   LET tm.nmd31 = ARG_VAL(9)    #CHI-A60021 mod 10->9
   LET tm.nna021 = ARG_VAL(10)  #CHI-A60021
   LET tm.nna03 = ARG_VAL(11)   #CHI-A60021 mod 9->11
   LET tm.npx01 = ARG_VAL(12)   #TQC-610058 #CHI-A60021 mod 11->12
   LET tm.a     = ARG_VAL(13)   #CHI-A60021 mod 12->13
   LET tm.b     = ARG_VAL(14)   #CHI-A60021 mod 13->14
   LET tm.r     = ARG_VAL(15)   #FUN-830027 add 選擇報表格式  #MOD-A10047 mod #CHI-A60021 mod 14->15
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16) #CHI-A60021 mod 15->16
   LET g_rep_clas = ARG_VAL(17) #CHI-A60021 mod 16->17
   LET g_template = ARG_VAL(18) #CHI-A60021 mod 17->18
   LET g_rpt_name = ARG_VAL(19)  #No:FUN-7C0078 #CHI-A60021 mod 18->19
  #LET tm.r     = ARG_VAL(18)    #FUN-830027 add 選擇報表格式  #MOD-A10047 mark
 
      IF cl_null(tm.wc) THEN   #No.MOD-4B0281
         CALL anmg185_tm()	        	# Input print condition
      ELSE
         SELECT nna03,nna04,nna05,nna021
           INTO tm.nna03,g_nna04,g_nna05,g_nna021
           FROM nna_file,nma_file
          WHERE nna01 = nma01
            AND nna01 = tm.nmd03
            AND nna02 = tm.nmd31
            AND nna021 = tm.nna021  #CHI-A60021 add
            #CHI-A60021 mark --start--
            #AND nna021= (SELECT MAX(nna021) FROM nna_file
            #              WHERE nna01=tm.nmd03
            #                AND nna02 = tm.nmd31)
            #CHI-A60021 mark --end--
         CALL anmg185()                        # Read data and create out-file
      END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION anmg185_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_cmd         LIKE type_file.chr1000,       #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
          l_flag        LIKE type_file.chr1,          #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
          l_jmp_flag    LIKE type_file.chr1           #No.FUN-680107 VARCHAR(1)
   DEFINE l_count,l_begin,l_end  LIKE type_file.num10,
          l_head        LIKE cre_file.cre08,
          l_end_c       LIKE type_file.chr9,   #LIKE cpd_file.cpd11,   #TQC-B90211
          l_n           LIKE type_file.num5,
          l_nna03       LIKE nna_file.nna03,
          l_tmp         LIKE nna_file.nna03
 
 
   LET p_row = 4 LET p_col = 19
   OPEN WINDOW anmg185_w AT p_row,p_col
        WITH FORM "anm/42f/anmg185"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a = 'Y'
   LET tm.b = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.r = '1'    #FUN-830027 預設要列印的報表格式為zaa
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmd01,nmd07
      ON ACTION locale
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
		
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmg185_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   LET tm.nna03 = ' '         #MOD-850202 add
   DISPLAY BY NAME tm.nna03   #MOD-850202 add
   INPUT BY NAME tm.nmd03,tm.nmd31,tm.nna021,tm.nna03,tm.npx01,tm.a,tm.b,tm.more, tm.r   #FUN-830027 add tm.r #CHI-A60021 add tm.nna021
                 WITHOUT DEFAULTS
 
     AFTER FIELD npx01
        SELECT COUNT(*) INTO g_cnt FROM npx_file
         WHERE npx01 = tm.npx01 AND npx02 = tm.nmd03 ##銀行要相同.
        IF g_cnt = 0 THEN CALL cl_err('err type',STATUS,0) NEXT FIELD npx01
        END IF
 
     AFTER FIELD nmd03   #銀行
        IF tm.nmd03 IS NULL OR tm.nmd03 = ' ' THEN
           CALL cl_err(tm.nmd03,'anm-003',0)
           NEXT FIELD nmd03
        ELSE
           SELECT * FROM nma_file
            WHERE nma01 = tm.nmd03
              AND nmaacti IN('Y','y')
           IF STATUS THEN
              CALL cl_err3("sel","nma_file",tm.nmd03,"","anm-017","","",0) #No.FUN-660148
              LET tm.nna03 = ' '
              NEXT FIELD nmd03
           ELSE
              DISPLAY BY NAME tm.nna03
           END IF
        END IF
 
      AFTER FIELD nmd31
          IF tm.nmd31 IS NULL OR tm.nmd31 = ' ' THEN
             CALL cl_err(tm.nmd31,'anm-003',0)
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
            #   AND nna06 IN ('y','Y')  #為可套印
            #   AND nna021= (SELECT MAX(nna021) FROM nna_file
            #           WHERE nna01=tm.nmd03
            #             AND nna02 = tm.nmd31)
            #IF STATUS THEN
            #   CALL cl_err3("sel","nna_file",tm.nmd03,tm.nmd31,"anm-954","","",0) #No.FUN-660148
            #   LET tm.nna03 = ' '
            #   NEXT FIELD nmd03   #TQC-6B0130
            #ELSE
            #   IF cl_null(tm.nna03) THEN
            #      SELECT nmw04 INTO tm.nna03 FROM nmw_file
            #         WHERE nmw01 = tm.nmd03 AND
            #               nmw06 = tm.nmd31 AND
            #               nmw03 = g_nna021
            #   END IF
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
            #       CALL g185_nna03(g_nna04,l_count,l_nna03,l_tmp) RETURNING
            #            l_nna03,l_tmp    #調整位數
            #      LET tm.nna03[1,l_count] = l_head
            #      LET tm.nna03[l_count+1,g_nna04] = l_tmp
            #   END FOR
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
                    CALL g185_nna03(g_nna04,l_count,l_nna03,l_tmp) RETURNING
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
               WHEN INFIELD(npx01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_npx'
                  LET g_qryparam.default1 = tm.npx01
                  LET g_qryparam.arg1 = tm.nmd03
                  CALL cl_create_qry() RETURNING tm.npx01
                  DISPLAY BY NAME tm.npx01
                  NEXT FIELD npx01
               WHEN INFIELD(nmd03)
    CALL cl_init_qry_var()
    LET g_qryparam.form = 'q_nma'
    LET g_qryparam.default1 = tm.nmd03
    CALL cl_create_qry() RETURNING tm.nmd03
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
      LET INT_FLAG = 0 CLOSE WINDOW anmg185_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmg185'
      IF STATUS OR l_cmd IS NULL THEN
          CALL cl_err('anmg185','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.nmd03 CLIPPED,"'",
                         " '",tm.nmd31 CLIPPED,"'",  #CHI-A60021 mod
                         " '",tm.nna021 CLIPPED,"'", #CHI-A60021 add
                         " '",tm.nna03 CLIPPED,"'",
                         " '",tm.npx01 CLIPPED,"'",   #TQC-610058
                         " '",tm.a CLIPPED,"'",   #TQC-610058
                         " '",tm.b CLIPPED,"'",   #TQC-610058
                         " '",tm.r CLIPPED,"'",   #FUN-830027 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmg185',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmg185_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmg185()
   ERROR ""
END WHILE
   CLOSE WINDOW anmg185_w
END FUNCTION
 
FUNCTION anmg185()
   DEFINE l_name	  LIKE type_file.chr20,  # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
          l_sql 	  LIKE type_file.chr1000,# RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_n       LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          l_za05	  LIKE type_file.chr1000,#標題內容 #No.FUN-680107 VARCHAR(40)
	        l_date    LIKE type_file.dat,    #No.FUN-680107 DATE
	        l_str     LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(40)
	        l_str1    LIKE type_file.chr20,  #No.FUN-680107 VARCHAR(20)
	        l_ans     LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
          l_i       LIKE type_file.num5,   #No.FUN-680107 SMALLINT
   l_head,l_head1   LIKE cre_file.cre08,   #No.FUN-680107 VARCHAR(10)
          l_end_c   LIKE type_file.chr9,   #LIKE cpd_file.cpd11,   #No.FUN-680107 VARCHAR(9)   #TQC-B90211
	        l_nna03   LIKE nna_file.nna03,
	        l_tmp     LIKE nna_file.nna03,
	  l_count,l_cnt   LIKE type_file.num10,  #No.FUN-680107 INTEGER
	        l_begin   LIKE type_file.num10,  #No.FUN-680107 INTEGER
	        l_end     LIKE type_file.num10,  #No.FUN-680107 INTEGER
          l_nmw04   LIKE nmw_file.nmw04,
          l_nmw05   LIKE nmw_file.nmw05,
          sr            RECORD
                        nmd01    LIKE nmd_file.nmd01,
                        nmd02    LIKE nmd_file.nmd02,
                        nmd04    LIKE nmd_file.nmd04,
                        nmd26    LIKE nmd_file.nmd26,
                        nmd05    LIKE nmd_file.nmd05,
                        nmd07    LIKE nmd_file.nmd07,
                        nmd08    LIKE nmd_file.nmd08,
                        nmd09    LIKE nmd_file.nmd09,
                        nmd10    LIKE nmd_file.nmd10,
                        nmd11    LIKE nmd_file.nmd11,
                        nmd14    LIKE nmd_file.nmd14,
                        nmd21    LIKE nmd_file.nmd21,
			     nt_note      LIKE type_file.chr1000          #No.FUN-680107 VARCHAR(100)
                        END RECORD
DEFINE     sr1          RECORD
                        seq      LIKE type_file.num5,   #No.FUN-680107 SMALLINT
                        nmd01    LIKE nmd_file.nmd01,   #No.FUN-550057
                        chkno    LIKE nmd_file.nmd02,   #No.FUN-680107 VARCHAR(10)
                        no_next  LIKE nna_file.nna03    #No.FUN-680107 VARCHAR(10)
                        END RECORD,
           l_seq        LIKE type_file.num5,            #No.FUN-680107 SMALLINT
           chkno_b      LIKE nmd_file.nmd02,            #No.FUN-680107 VARCHAR(10)
           chkno_e      LIKE nmd_file.nmd02,            #No.FUN-680107 VARCHAR(10)
           chkno_l      LIKE nmd_file.nmd02             #No.FUN-680107 VARCHAR(10)
   DEFINE p_row,p_col	LIKE type_file.num5             #No.FUN-680107 SMALLINT
   DEFINE l_str2        STRING                          #No.FUN-710085   #MOD-830042  #FUN-830027 取消mark
   DEFINE l_leng        LIKE type_file.num5             #No.FUN-710085   #MOD-830042  #FUN-830027 取消mark
   DEFINE l_leng2       LIKE type_file.num5             #MOD-B10053
   DEFINE l_npy         RECORD LIKE npy_file.*          #No.FUN-710085   #MOD-830042  #FUN-830027 取消mark
   DEFINE l_nma04       LIKE nma_file.nma04  #MOD-770071
   DEFINE l_using       STRING    #CHI-7A0004
   DEFINE i             LIKE type_file.num5  #CHI-7A0004
   DEFINE j             LIKE type_file.num5  #FUN-830027
   DEFINE tot           LIKE type_file.num5  #FUN-830027
   DEFINE l_ii          LIKE type_file.chr1000   #FUN-950024 add   
   DEFINE l_jj          LIKE type_file.chr1000   #FUN-950024 add
   DEFINE l_fillin      STRING                   #MOD-B10053
   DEFINE l_fillin_tmp  STRING                   #MOD-B10053
#  DEFINE l_img_blob    LIKE type_file.blob      #FUN-C40036 add    #FUN-C40036 mark

   LET j = 0
   
   IF tm.r = '2' THEN
      CALL cl_del_data(l_table)
   END IF
     #只回寫到截止票號
    #FUN-B40087------mark-----str-----
    #DROP TABLE g185_temp;
    #CREATE TEMP TABLE g185_temp(
    # seq LIKE type_file.num5,  
    # nmd01 LIKE nmd_file.nmd01,
    # chkno LIKE nmd_file.nmd02,
    # no_next LIKE nna_file.nna03);
    #FUN-B40087------mark-----end-----
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmg185'
 
   LET l_sql="SELECT nmw04,nmw05  FROM nmw_file ",        #支票簿
             " WHERE nmw01='",tm.nmd03 CLIPPED,"' AND ",
             " nmw06 = ",tm.nmd31 ," AND ",
             " nmw03 = '",tm.nna021,"'" #CHI-A60021 add
            #CHI-A60021 mark --start--
            # " nmw03 = ( ",
            # "SELECT MAX(nmw03) FROM nmw_file  ",
            # " WHERE nmw01 = '",tm.nmd03 CLIPPED,"' AND ",
            # "   nmw06 = ",tm.nmd31," AND ",
            # "   nmwacti = 'Y')"
            #CHI-A60021 mark --end--
   PREPARE g185_nmw_prepare FROM l_sql       # RUNTIME 編譯
   DECLARE g185_nmw_cs                       # SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR g185_nmw_prepare
 
     LET l_sql = "SELECT nmd01,nmd02,nmd04,nmd26,nmd05,nmd07,nmd08,nmd09,nmd10, ",
                 " nmd11,nmd14,nmd21,' '",
                 " FROM nmd_file ",
                 " WHERE ",tm.wc CLIPPED,
                 " AND (nmd02 IS NULL OR nmd02 = ' ') ",
                 " AND nmd03 = '",tm.nmd03,"' ",
                 " AND nmd31 = '",tm.nmd31,"' ",
                #" AND nmd30 <> 'X' ",                          #MOD-A70055 mark
                 " AND nmd30 = 'Y' ",                           #MOD-A70055
                 " ORDER BY nmd01 "
     PREPARE anmg185_prepare1 FROM l_sql
     IF STATUS != 0 THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM 
     END IF
     DECLARE anmg185_curs1 CURSOR FOR anmg185_prepare1
   
    #FUN-B40087-------mark-----str---- 
    #IF tm.r = '1' THEN
    #   CALL cl_outnam('anmg185') RETURNING l_name
    #END IF
    #FUN-B40087-------mark-----end-----
 
     LET g_pageno = 0
     LET g_cnt    = 1
 
    #FUN-B40087-------mark-----str----
    #IF tm.r = '1' THEN
    #   START REPORT anmg185_rep TO l_name  #No.FUN-710085 mark   #MOD-830042 取消mark
    #END IF
    #FUN-B40087-------mark-----end-----
    #FUN-C50007--ADD-STR
     DECLARE npy_curs CURSOR FOR
     SELECT * FROM npy_file
     WHERE npy01=tm.npx01 ORDER BY npy02
    #FUN-C50007--ADD--END
 
     FOREACH anmg185_curs1 INTO sr.*
       IF STATUS != 0 THEN
          CALL cl_err('foreach:',STATUS,1) LET g_success = 'N' EXIT FOREACH
       END IF
       IF g_cnt = 1 THEN  LET g_nna03 = tm.nna03 END IF   #本次作業第一次
         IF g_cnt >1 THEN
          IF l_nmw04 > g_nna03  OR l_nmw05 < g_nna03  THEN  #check是否在支票簿中
            CALL cl_err(g_nna03,'anm-647',1) LET g_success = 'N' EXIT FOREACH
         END IF
        END IF
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
                CALL g185_nna03(g_nna04,l_count,l_nna03,l_tmp) RETURNING
                     l_nna03,l_tmp   #調整位數
                LET g_nna03[l_count+1,g_nna04] = l_tmp       #下一號
                EXIT FOR
             END IF
             LET g_nna03_o = g_nna03
             LET l_tmp = g_nna03[l_count+1,g_nna04]+1
	     LET l_nna03 = g_nna03[l_count+1,g_nna04] + 1
             CALL g185_nna03(g_nna04,l_count,l_nna03,l_tmp) RETURNING
                  l_nna03,l_tmp    #調整位數
            LET g_nna03[1,l_count] = l_head
            LET g_nna03[l_count+1,g_nna04] = l_tmp
         END FOR
 
       #check支票簿中票號是否存在-----------------------------------
       LET l_count = g_nna04 - g_nna05      #全部位數減後幾位連續位數
       LET l_head  = g_nna03_o[1,l_count]
       LET l_head1 = l_head CLIPPED,'*' CLIPPED
       OPEN g185_nmw_cs
       FETCH g185_nmw_cs INTO l_nmw04,l_nmw05
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
 
       IF g_lang = '1' THEN   
          CALL cl_say(sr.nmd26,80) RETURNING l_ii,l_jj  
          LET sr.nt_note = l_ii,l_jj   
          DISPLAY l_ii 
          DISPLAY l_jj 
       ELSE
          CALL s_sayc(sr.nmd26,100) RETURNING sr.nt_note
       END IF   #FUN-950024 add
       LET sr.nmd02 = g_nna03_o
 
      #---取消mark---start--- #CR流程
      IF tm.r = '2' THEN    #FUN-830027 add
        #FUN-C50007--MARK--STR
        #  DECLARE npy_curs CURSOR FOR
        #   SELECT * FROM npy_file
        #    WHERE npy01=tm.npx01 ORDER BY npy02
        #FUN-C50007--MARK--END		
          LET l_str2 = NULL
          LET l_using = '<<<,<<<,<<<,<<<,<<<'   
          FOR i = 1 TO g_azi04
              IF i = 1 THEN 
                 LET l_using = l_using,'.#'
              ELSE
                 LET l_using = l_using,'#'
              END IF 
          END FOR

#         LOCATE l_img_blob    IN MEMORY  #FUN-C40036 add  #FUN-C40036 mark
    
          FOREACH npy_curs INTO l_npy.*
            SELECT COUNT(*) INTO tot FROM npy_file WHERE npy01 = l_npy.npy01
            LET j = j + 1
            IF j = tot THEN
               LET l_npy.npy06 = 'Y'
            END IF
             IF l_npy.npy04 != 0 THEN
                IF NOT cl_null(l_str2) THEN
                   LET l_str = l_str2
                  #EXECUTE insert_prep USING sr.nmd01,sr.nmd02,l_str                #MOD-A60143 mark
                   EXECUTE insert_prep USING sr.nmd01,sr.nmd02,l_npy.npy02,l_str    #MOD-A60143
#                                            ,"",l_img_blob,"N",""                  #FUN-C40036 add    #FUN-C40036 mark 
                   LET l_str  = NULL
                   LET l_str2 = NULL
                END IF
                FOR i = 1 TO l_npy.npy04 
                    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
#                               " VALUES('",sr.nmd01,"','",sr.nmd02,"',",l_npy.npy02,",'','',l_img_blob,'N','')"    #MOD-A60143   #FUN-C40036 add 4個簽核預設值 #FUN-C40036 mark
                                " VALUES('",sr.nmd01,"','",sr.nmd02,"',",l_npy.npy02,",'')"        #FUN-C40036 add
                    PREPARE insert_prep1 FROM g_sql
                    IF STATUS THEN
                       CALL cl_err('insert_prep1:',status,1)
                       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
                       CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
                       EXIT PROGRAM
                    END IF
                    EXECUTE insert_prep1
                END FOR
             END IF
             IF l_npy.npy05 > 0 THEN
                LET l_str2 = l_str2,l_npy.npy05 SPACES
             END IF
             CASE l_npy.npy03
               WHEN 'A' # 開票日
                    IF g_aza.aza26 = '0' THEN    #FUN-830027 add 台灣印民國年，大陸印西元年
                       LET l_str2 = l_str2,YEAR(sr.nmd07)-1911 USING '&&&',2 SPACES,      #MOD-A40099 add &
                                   MONTH(sr.nmd07) USING '&&',2 SPACES,
                                   DAY(sr.nmd07) USING '&&'
                    ELSE                             #FUN-830027 add
                       LET l_str2 = l_str2,sr.nmd07  #FUN-830027 add
                    END IF                           #FUN-830027 add
               WHEN 'B' # 到期日
                    IF g_aza.aza26 = '0' THEN    #FUN-830027 add 台灣印民國年，大陸印西元年
                       LET l_str2 = l_str2,YEAR(sr.nmd05)-1911 USING '&&&',2 SPACES,       #MOD-A40099 add &
                                   MONTH(sr.nmd05) USING '&&',2 SPACES,
                                   DAY(sr.nmd05) USING '&&'
                    ELSE                             #FUN-830027 add
                       LET l_str2 = l_str2,sr.nmd05  #FUN-830027 add
                    END IF                           #FUN-830027 add
               WHEN 'C' # 受款人
                    IF tm.a = 'Y' THEN
                      #LET l_str2 = l_str2,sr.nmd09              #MOD-B10053 mark 
                      # LET l_leng = 24 - FGL_WIDTH(sr.nmd09) #MOD-970233  #FUN-C10036 mark
                       LET l_leng = 60 - FGL_WIDTH(sr.nmd09) #FUN-10036 add
                       IF l_leng >= 0 THEN                       #MOD-B10053 mod > -> >= 
                          LET l_str2 = l_str2,sr.nmd09           #MOD-B10053 
                          LET l_str2 = l_str2,l_leng SPACES
                      #-MOD-B10053-add-
                       ELSE
                          IF l_leng < 0 THEN                     #當欄位大於 24 時,依此長度切割 
                              LET l_fillin = sr.nmd09                  
                              LET l_leng2 = l_fillin.getLength()      #Uni 字串長度
                              LET l_fillin_tmp = l_fillin 
                              FOR l_i = 1 TO l_leng2                                          
                                  LET l_fillin = l_fillin_tmp.substring(1,l_i)                   
                                  LET l_leng = FGL_WIDTH(l_fillin)    #BIG5 字串長度
                                  #IF l_leng > = 24 THEN  #FUN-C10036 mark
                                  IF l_leng > = 60 THEN #FUN-C10036 add
                                     EXIT FOR                                              
                                  END IF                                                       
                              END FOR                                                          
                              LET l_str2 = l_str2,l_fillin
                          END IF
                      #-MOD-B10053-end-
                       END IF
                    END IF
               WHEN 'D' # 帳號
                    LET l_nma04 = NULL
                    SELECT nma04 INTO l_nma04 FROM nma_file
                      WHERE nma01 = tm.nmd03
                    IF NOT cl_null(l_nma04) THEN
                       LET sr.nmd11 = l_nma04
                    END IF
                    LET l_str2 = l_str2,sr.nmd11
               WHEN 'E' # 大寫國字金額
                    LET l_str2 = l_str2,sr.nt_note 
               WHEN 'F' # 小寫數字金額
                    LET l_str2 = l_str2,cl_digcut(sr.nmd26,g_azi04) USING l_using  #CHI-7A0004  
               WHEN 'G' # 禁止背書轉讓
                    IF tm.b = 'Y' THEN
                       LET l_str2 = l_str2,'禁止背書轉讓'
                    END IF
               WHEN 'H' # 存根  受款人
                   #LET l_str2 = l_str2,sr.nmd09[1,10]        #MOD-B10053 mark
                    LET l_leng = 10 - FGL_WIDTH(sr.nmd09) #MOD-970233    
                    IF l_leng >= 0 THEN                       #MOD-B10053 mod > -> >= 
                       LET l_str2 = l_str2,sr.nmd09           #MOD-B10053 
                       LET l_str2 = l_str2,l_leng SPACES
                   #-MOD-B10053-add-
                    ELSE
                       IF l_leng < 0 THEN                     #當欄位大於 10 時,依此長度切割 
                           LET l_fillin = sr.nmd09                  
                           LET l_leng2 = l_fillin.getLength()      #Uni 字串長度
                           LET l_fillin_tmp = l_fillin 
                           FOR l_i = 1 TO l_leng2                                          
                               LET l_fillin = l_fillin_tmp.substring(1,l_i)                   
                               LET l_leng = FGL_WIDTH(l_fillin)    #BIG5 字串長度
                               IF l_leng > = 10 THEN 
                                  EXIT FOR                                              
                               END IF                                                       
                           END FOR                                                          
                           LET l_str2 = l_str2,l_fillin
                       END IF
                   #-MOD-B10053-end-
                    END IF
               WHEN 'I' # 存根  開票日
                   #台灣印民國年，大陸印西元年
                    IF g_aza.aza26 = '0' THEN    #FUN-830027 add 台灣印民國年，大陸印西元年
                       LET l_str2 = l_str2,YEAR(sr.nmd07)-1911 USING '&&&',2 SPACES,      #MOD-A40099 add &
                                   MONTH(sr.nmd07) USING '&&',2 SPACES,
                                   DAY(sr.nmd07) USING '&&'
                    ELSE                            
                       LET l_str2 = l_str2,sr.nmd07 
                    END IF                          
               WHEN 'J' # 存根  到期日
                   #台灣印民國年，大陸印西元年
                    IF g_aza.aza26 = '0' THEN    #FUN-830027 add 台灣印民國年，大陸印西元年
                       LET l_str2 = l_str2,YEAR(sr.nmd05)-1911 USING '&&&',2 SPACES,           #MOD-A40099 add &
                                   MONTH(sr.nmd05) USING '&&',2 SPACES,
                                   DAY(sr.nmd05) USING '&&'
                    ELSE                            
                       LET l_str2 = l_str2,sr.nmd05 
                    END IF                          
               WHEN 'K' # 存根  金  額
                    LET l_str2 = l_str2,cl_digcut(sr.nmd26,g_azi04) USING l_using   #本幣      #CHI-7A0004
               WHEN 'L' # 廠商編號
                    LET l_str2 = l_str2,sr.nmd08
               WHEN 'M' # 開票單,寄領方式,廠別
                    LET l_str2 = l_str2,sr.nmd01,'  ',sr.nmd14
               WHEN 'S' # 空白
                    LET l_str2 = l_str2,' '
             END CASE
             IF l_npy.npy06 = 'Y' THEN
                LET l_str = l_str2
               #EXECUTE insert_prep USING sr.nmd01,sr.nmd02,l_str                #MOD-A60143 mark
                EXECUTE insert_prep USING sr.nmd01,sr.nmd02,l_npy.npy02,l_str    #MOD-A60143
                LET l_str  = NULL
                LET l_str2 = NULL
             END IF
          END FOREACH
         LET j = 0    #FUN-830027 add
      END IF         #FUN-830027 add

      #FUN-B40087--------mark------str----- 
      #IF tm.r = '1' THEN    #FUN-830027 add 
      #   OUTPUT TO REPORT anmg185_rep(sr.*)    #No.FUN-710085   #MOD-830042 取消mark
      #END IF   #MOD-960278 add
 
      #  
      #   #只回寫到截止票號
      #   INSERT INTO g185_temp VALUES(g_cnt,sr.nmd01,g_nna03_o,g_nna03)
      #   IF STATUS THEN
      #      CALL cl_err3("ins","g185_temp","","",STATUS,"","ins tmp:",1) #No.FUN-660148
      #      EXIT FOREACH
      #   END IF
      #FUN-B40087--------mark------end-----
       LET g_cnt = g_cnt + 1
     END FOREACH
     #zaa流程 
    #FUN-B40087--------mark------str-----
    #IF tm.r = '1' THEN    
    #   FINISH REPORT anmg185_rep                    #No.FUN-710085 mark   #MOD-830042 取消mark
    #   CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-710085 mark   #MOD-830042 取消mark
    #END IF       
    #FUN-B40087--------mark------end-----
 
     #CR流程          #FUN -B40087
    #IF tm.r = '2' THEN
###GENGRE###        LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###        CALL cl_prt_cs3('anmg185','anmg185',l_sql,'')   #FUN-740023 modify
#   LET g_cr_table = l_table                   #主報表的temp table名稱       #FUN-C40036   #FUN-C40036 mark 
#   LET g_cr_apr_key_f = "nmd01"         #報表主鍵欄位名稱，用"|"隔開  #FUN-C40036         #FUN-C40036 mark
    CALL anmg185_grdata()    ###GENGRE###
    #END IF          #FUN -B40087
 
  #只回寫到截止票號
  WHILE TRUE
     IF g_cnt > 1 THEN
 
        IF g_bgjob = 'Y' THEN
           #注意：不可將此 window 拿掉，否則 anmt100串過來 cl_confirm會有問題
           OPEN WINDOW dummy AT 20,20 WITH 1 ROWS,1 COLUMNS
           CALL cl_load_act_sys('anmg185')
           CALL cl_load_act_list('anmg185')
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
 
#FUN-B40087--------mark------str-----
#       SELECT chkno INTO chkno_e FROM g185_temp
#        WHERE seq = (SELECT MAX(seq) FROM g185_temp)
#FUN-B40087--------mark------end-----
        LET chkno_l = chkno_e
 
        IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
           LET p_row = 10 LET p_col = 30
        ELSE LET p_row = 10 LET p_col = 20
        END IF
        OPEN WINDOW anmr181a_w AT p_row,p_col
         WITH FORM "anm/42f/anmr181a"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
        CALL cl_ui_locale("anmr181a")
        CALL cl_load_act_sys('anmg185')
        CALL cl_load_act_list('anmg185')
 
        DISPLAY tm.nna03,chkno_e TO chkno_b,chkno_e
        INPUT BY NAME chkno_l WITHOUT DEFAULTS
            AFTER FIELD chkno_l
               IF cl_null(chkno_l) THEN NEXT FIELD chkno_l END IF
               IF chkno_l < tm.nna03 OR chkno_l > chkno_e THEN
                  CALL cl_err('','anm-900',0)  NEXT FIELD chkno_l
               END IF
              #FUN-B40087--------mark------str-----
              #SELECT seq INTO l_seq FROM g185_temp
              # WHERE chkno = chkno_l
              #IF STATUS THEN
              #   CALL cl_err3("sel","g185_temp","","",STATUS,"","sel seq:",0) #No.FUN-660148
              #   NEXT FIELD chkno_l
              #END IF
              #FUN-B40087--------mark------end-----
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
        IF INT_FLAG THEN LET INT_FLAG = 0
           CLOSE WINDOW anmr181a_w EXIT WHILE
        END IF
 
        BEGIN WORK LET g_success='Y'
        #FUN-B40087--------mark------str-----
       #DECLARE tmp_cs CURSOR FOR
       #  SELECT * FROM g185_temp WHERE seq <= l_seq
       #FOREACH tmp_cs INTO sr1.*
       #   #回寫nmd02前,先檢查支票號碼是否已存在,若重覆取號需提示錯誤訊息
       #    LET l_cnt = 0
       #    SELECT COUNT(*) INTO l_cnt FROM nmd_file
       #     WHERE nmd01 != sr1.nmd01 AND nmd02 = sr1.chkno
       #    IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
       #    IF l_cnt > 0 THEN    #支票號碼重覆取號
       #       CALL cl_err3("sel","nmd_file",sr1.chkno,"","anm-109","","sel nmd:",1)
       #       LET g_success = 'N' EXIT FOREACH
       #    END IF
       #    #更新應付帳款之票號
       #    UPDATE nmd_file SET nmd02 = sr1.chkno
       #     WHERE nmd01 = sr1.nmd01
       #    IF STATUS THEN
       #       CALL cl_err3("upd","nmd_file",sr1.nmd01,"",STATUS,"","upd nmd:",1) #No.FUN-660148
       #       LET g_success = 'N' EXIT FOREACH
       #    END IF
       #    LET l_cnt = 0 
       #    SELECT COUNT(*) INTO l_cnt FROM ala_file
       #      WHERE ala931= sr1.nmd01
       #    IF l_cnt > 0 THEN
       #       UPDATE ala_file SET ala932=sr1.chkno
       #         WHERE ala931=sr1.nmd01
       #       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]= 0  THEN
       #          CALL cl_err3("upd","ala_file",sr1.nmd01,"",STATUS,"","upd ala:",1) 
       #          LET g_success = 'N' EXIT FOREACH
       #       END IF
       #    END IF
       #    #更新支票簿號檔之下次列印支票號
       #    UPDATE nna_file SET nna03 = sr1.no_next
       #     WHERE nna01 = tm.nmd03 AND nna02 = tm.nmd31
       #       AND nna021 = g_nna021
       #    IF STATUS != 0 THEN
       #       CALL cl_err3("upd","nna_file",tm.nmd03,tm.nmd31,STATUS,"","upd nna:",1) #No.FUN-660148
       #       LET g_success = 'N' EXIT FOREACH
       #    END IF
       #    MESSAGE "update ......"
       #    CALL ui.Interface.refresh()
       #END FOREACH
       #FUN-B40087--------mark------end-----
        IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
        MESSAGE ""
        CALL ui.Interface.refresh()
        CLOSE WINDOW anmr181a_w
     END IF
     EXIT WHILE
  END WHILE
 
END FUNCTION
 
#FUN-B40087--------mark------str-----
#REPORT anmg185_rep(sr)
#  DEFINE l_last_sw	    LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#       	      l_p_flag      LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#         l_leng        LIKE type_file.num5,   #No.FUN-680107 SMALLINT
#         l_leng2       LIKE type_file.num5,   #MOD-B10053
#         l_flag1       LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#         l_npy         RECORD LIKE npy_file.*,
#         i             LIKE type_file.num5,   #No.FUN-680107 SMALLINT
#         l_i           LIKE type_file.num5,   #MOD-B10053
#         l_nma04       LIKE nma_file.nma04,  #MOD-770071
#         sr            RECORD
#                       nmd01    LIKE nmd_file.nmd01,
#                       nmd02    LIKE nmd_file.nmd02,
#                       nmd04    LIKE nmd_file.nmd04,
#                       nmd26    LIKE nmd_file.nmd26,
#                       nmd05    LIKE nmd_file.nmd05,
#                       nmd07    LIKE nmd_file.nmd07,
#                       nmd08    LIKE nmd_file.nmd08,
#                       nmd09    LIKE nmd_file.nmd09,
#                       nmd10    LIKE nmd_file.nmd10,
#                       nmd11    LIKE nmd_file.nmd11,
#                       nmd14    LIKE nmd_file.nmd14,
#                       nmd21    LIKE nmd_file.nmd21,
#       		nt_note  LIKE type_file.chr1000 #No.FUN-680107
#                       END RECORD,
#         l_using       STRING    #CHI-7A0004
#  DEFINE l_fillin      STRING                   #MOD-B10053
#  DEFINE l_fillin_tmp  STRING                   #MOD-B10053

# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER EXTERNAL BY sr.nmd02   #NO:4773
# FORMAT
#
#  BEFORE GROUP OF sr.nmd02
#     SKIP TO TOP OF PAGE
#
#  ON EVERY ROW
#     LET l_using = '<<<,<<<,<<<,<<<,<<<'
#     FOR i = 1 TO g_azi04
#         IF i = 1 THEN
#            LET l_using = l_using,'.#'
#         ELSE
#            LET l_using = l_using,'#'
#         END IF
#     END FOR
#     DECLARE npy_curs1 CURSOR FOR      #FUN-830027 add
#      SELECT * FROM npy_file
#       WHERE npy01=tm.npx01 ORDER BY npy02
#     FOREACH npy_curs1 INTO l_npy.*    #FUN-830027 add
#        IF l_npy.npy04 != 0 THEN
#           FOR i = 1 TO l_npy.npy04 SKIP 1 LINE END FOR
#        END IF
#        IF l_npy.npy05 > 0 THEN PRINT l_npy.npy05 SPACES; END IF
#        CASE l_npy.npy03
#          WHEN 'A' # 開票日
#               IF g_aza.aza26='0' THEN   #台灣版要印民國年
#                  PRINT YEAR(sr.nmd07)-1911 USING '&&&',1 SPACES,       #MOD-A40099  add &
#                        MONTH(sr.nmd07) USING '&&',2 SPACES,
#                        DAY(sr.nmd07) USING '&&';
#               ELSE
#                  PRINT YEAR(sr.nmd07) USING '&&',2 SPACES,          
#                        MONTH(sr.nmd07) USING '&&',2 SPACES,
#                        DAY(sr.nmd07) USING '&&';
#               END IF
#          WHEN 'B' # 到期日
#               IF g_aza.aza26='0' THEN   #台灣版要印民國年
#                  PRINT YEAR(sr.nmd05)-1911 USING '&&&',1 SPACES,
#                        MONTH(sr.nmd05) USING '&&',2 SPACES,
#                        DAY(sr.nmd05) USING '&&';
#               ELSE
#                  PRINT YEAR(sr.nmd05) USING '&&',2 SPACES,         
#                        MONTH(sr.nmd05) USING '&&',2 SPACES,
#                        DAY(sr.nmd05) USING '&&';
#               END IF
#          WHEN 'C' # 受款人
#               IF tm.a = 'Y' THEN
#                 #PRINT sr.nmd09 CLIPPED;                            #MOD-B10053 mark
#                  LET l_leng = 24 - FGL_WIDTH(sr.nmd09) #MOD-970233 
#                 #IF l_leng > 0 THEN PRINT l_leng SPACES;  END IF    #MOD-B10053 mark
#                 #-MOD-B10053-add-
#                  IF l_leng >= 0 THEN 
#                     PRINT sr.nmd09 CLIPPED;
#                     PRINT l_leng SPACES;  
#                  ELSE
#                     IF l_leng < 0 THEN                     #當欄位大於 24 時,依此長度切割 
#                         LET l_fillin = sr.nmd09                  
#                         LET l_leng2 = l_fillin.getLength()      #Uni 字串長度
#                         LET l_fillin_tmp = l_fillin 
#                         FOR l_i = 1 TO l_leng2                                          
#                             LET l_fillin = l_fillin_tmp.substring(1,l_i)                   
#                             LET l_leng = FGL_WIDTH(l_fillin)    #BIG5 字串長度
#                             IF l_leng > = 24 THEN 
#                                EXIT FOR                                              
#                             END IF                                                       
#                         END FOR        
#                         LET l_fillin = l_fillin CLIPPED
#                         LET l_leng = 24 - FGL_WIDTH(l_fillin) 
#                         PRINT l_fillin ;
#                         PRINT l_leng SPACES;  
#                     END IF
#                  END IF
#                 #-MOD-B10053-end-
#               END IF
#          WHEN 'D' # 帳號
#               LET l_nma04 = NULL
#               SELECT nma04 INTO l_nma04 FROM nma_file
#                 WHERE nma01 = tm.nmd03
#               IF NOT cl_null(l_nma04) THEN
#                  LET sr.nmd11 = l_nma04
#               END IF
#               PRINT sr.nmd11;
#          WHEN 'E' # 大寫國字金額
#               PRINT sr.nt_note;
#          WHEN 'F' # 小寫數字金額
#               PRINT cl_digcut(sr.nmd26,g_azi04) USING l_using;   #CHI-7A0004   #MOD-860136 add;
#          WHEN 'G' # 禁止背書轉讓
#               IF tm.b = 'Y' THEN PRINT '禁止背書轉讓'; END IF
#          WHEN 'H' # 存根  受款人
#              #PRINT sr.nmd09[1,10];      #MOD-B10053 mark
#               LET l_leng = 10 - FGL_WIDTH(sr.nmd09)   #MOD-760130 #MOD-970233 
#              #IF l_leng > 0 THEN PRINT l_leng SPACES;  END IF   #MOD-760130   #MOD-B10053 mark
#              #-MOD-B10053-add-
#               IF l_leng >= 0 THEN 
#                  PRINT sr.nmd09;     
#                  PRINT l_leng SPACES;  
#               ELSE
#                  IF l_leng < 0 THEN                     #當欄位大於 10 時,依此長度切割 
#                      LET l_fillin = sr.nmd09                  
#                      LET l_leng2 = l_fillin.getLength()      #Uni 字串長度
#                      LET l_fillin_tmp = l_fillin 
#                      FOR l_i = 1 TO l_leng2                                          
#                          LET l_fillin = l_fillin_tmp.substring(1,l_i)                   
#                          LET l_leng = FGL_WIDTH(l_fillin)    #BIG5 字串長度
#                          IF l_leng > = 10 THEN 
#                             EXIT FOR                                              
#                          END IF                                                       
#                      END FOR                                                          
#                      LET l_fillin = l_fillin CLIPPED
#                      LET l_leng = 10 - FGL_WIDTH(l_fillin) 
#                      PRINT l_fillin ;
#                      PRINT l_leng SPACES;  
#                  END IF
#               END IF  
#              #-MOD-B10053-end-
#          WHEN 'I' # 存根  開票日
#               IF g_aza.aza26='0' THEN   #台灣版要印民國年
#                  PRINT YEAR(sr.nmd07)-1911 USING '&&&','/',
#                        MONTH(sr.nmd07) USING '&&','/',
#                        DAY(sr.nmd07) USING '&&';
#               ELSE
#                  PRINT sr.nmd07;
#               END IF
#          WHEN 'J' # 存根  到期日
#               IF g_aza.aza26='0' THEN   #台灣版要印民國年
#                  PRINT YEAR(sr.nmd05)-1911 USING '&&&','/',
#                        MONTH(sr.nmd05) USING '&&','/',
#                        DAY(sr.nmd05) USING '&&';
#               ELSE
#                  PRINT sr.nmd05;
#               END IF
#          WHEN 'K' # 存根  金  額
#               PRINT cl_digcut(sr.nmd26,g_azi04) USING l_using;   #CHI-7A0004   #MOD-860136 add;
#          WHEN 'L' # 廠商編號
#               PRINT sr.nmd08;
#          WHEN 'M' # 開票單,寄領方式,廠別
#               PRINT sr.nmd01,'  ',sr.nmd14;
#          WHEN 'S' # 空白
#               PRINT ' ';
#        END CASE
#        IF l_npy.npy06 = 'Y' THEN PRINT ' ' END IF
#     END FOREACH
#END REPORT
#FUN-B40087--------mark------end-----
 
FUNCTION g185_nna03(l_nna04,l_count,l_nna03,l_tmp)
   DEFINE l_nna04   LIKE nna_file.nna04,
	        l_nna03   LIKE nna_file.nna03,
          l_tmp     LIKE nna_file.nna03,
          l_count   LIKE type_file.num10   #No.FUN-680107 INTEGER
 
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
#No.FUN-9C0073 -----------------By chenls 10/01/15

###GENGRE###START
FUNCTION anmg185_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
   
#   LOCATE sr1.sign_img IN MEMORY        #FUN-C40036 mark
#   CALL cl_gre_init_apr()               #FUN-C40036 mark
 
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("anmg185")
        IF handler IS NOT NULL THEN
            START REPORT anmg185_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE anmg185_datacur1 CURSOR FROM l_sql
            FOREACH anmg185_datacur1 INTO sr1.*
                OUTPUT TO REPORT anmg185_rep(sr1.*)
            END FOREACH
            FINISH REPORT anmg185_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT anmg185_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5

    
    ORDER EXTERNAL BY sr1.nmd01,sr1.nmd02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.nmd01
            LET l_lineno = 0
        BEFORE GROUP OF sr1.nmd02

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            PRINTX g_lang         #FUN-B40087 add 
             
            PRINTX sr1.*

        AFTER GROUP OF sr1.nmd01
        AFTER GROUP OF sr1.nmd02

        
        ON LAST ROW

END REPORT
###GENGRE###END
