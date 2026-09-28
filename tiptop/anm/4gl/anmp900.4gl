# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmp900.4gl
# Descriptions...: 委花旗代付款產生作業
# Date & Author..: 97/07/21 BY lydia
# Modify ........: 98/12/29 By Iris 花旗開票碼(nmd30)改為 nmd32
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: NO.FUN-550057 05/05/30 By jackie 單據編號加大
# Modify.........: No.FUN-580098 05/10/26 By CoCo BOTTOM MARGIN g_bottom_margin改5
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6C0176 06/12/28 By Smapmin 修改下載方法
# Modify.........: No.FUN-710024 07/01/18 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
# Modify.........: No.FUN-870151 08/08/19 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.TQC-940177 09/05/12 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990048 09/09/14 By sabrina 不需join rvb_file 
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: NO.MOD-A10088 10/01/15 BY yiting FGL_GETEN-->FGL_GETENV
# Modify.........: No.FUN-A60056 10/07/08 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.FUN-A50102 10/07/19 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD		            # Print condition RECORD
           wc  LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(300) #Where Condiction
	      nmd03 LIKE nmd_file.nmd03,
	      nmd06 LIKE nmd_file.nmd06,
	      nma13 LIKE nma_file.nma13,
              fname LIKE type_file.chr20,   #No.FUN-680107 VARCHAR(16)
              more  LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1) #是否列印其它條件
              END RECORD,
	  l_cmd     LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(100)
          g_code    LIKE type_file.chr3,    #No.FUN-680107 VARCHAR(3) #代碼
          g_nma14   LIKE nma_file.nma14,
          g_nma15   LIKE nma_file.nma15,
          g_year    LIKE type_file.num10,   #No.FUN-680107 INTEGER
          g_month   LIKE type_file.num10,   #No.FUN-680107 INTEGER
          g_date    LIKE type_file.dat,     #No.FUN-680107 DATE
          g_dash_1  LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(100)
 DEFINE   g_i       LIKE type_file.num5     #count/index for any purpose #No.FUN-680107 SMALLINT
 DEFINE   g_flag    LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.nmd03 = ARG_VAL(8)
   LET tm.nma13  = ARG_VAL(9)
   LET tm.more  = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	THEN    # If background job sw is off
      CALL anmp900_tm()	                        # Input print condition
      CLOSE WINDOW anmp900_w
   ELSE
       SELECT nma13,nma14,nma15 INTO tm.nma13,g_nma14,g_nma15 FROM nma_file
        WHERE nma01 = tm.nmd03
       CALL anmp900()           # Read data and create out-file
       IF g_success = 'Y' THEN
          CALL cl_cmmsg(1)
       ELSE
          CALL cl_rbmsg(1)
       END IF
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmp900_tm()
   DEFINE   lc_cmd        LIKE type_file.chr1000,      #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
            l_flag        LIKE type_file.chr1,         #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
            l_jmp_flag    LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   OPEN WINDOW anmp900_w WITH FORM "anm/42f/anmp900"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.nmd03= '104'
   LET tm.nmd06= '01'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON nmd01,nmd07
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
        ON ACTION locale                    #genero
           LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           EXIT CONSTRUCT
 
         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup') #FUN-980030
 
      IF g_action_choice = "locale" THEN  #genero
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
 
      IF tm.wc = ' 1=1 ' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.nmd03,tm.nmd06,tm.more WITHOUT DEFAULTS
 
         AFTER FIELD nmd03
            IF NOT cl_null(tm.nmd03) THEN
               SELECT nma13,nma14,nma15 INTO tm.nma13,g_nma14,g_nma15
                 FROM nma_file
                WHERE nma01 = tm.nmd03
               IF SQLCA.sqlcode  THEN
#                 CALL cl_err(tm.nmd03,'anm-017',0)   #No.FUN-660148
                  CALL cl_err3("sel","nma_file",tm.nmd03,"","anm-017","","",0) #No.FUN-660148
                  LET tm.nma13 = ' '
                  NEXT FIELD nmd03
               END IF
            END IF
 
         AFTER FIELD nmd06 #票別一
            IF NOT cl_null(tm.nmd06) THEN
               SELECT * FROM nmo_file WHERE nmo01=tm.nmd06
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(tm.nmd06,'anm-086',0)   #No.FUN-660148
                  CALL cl_err3("sel","nmo_file",tm.nmd06,"","anm-086","","",0) #No.FUN-660148
                  NEXT FIELD nmd06
               ELSE
                  IF tm.nmd06='01' THEN
                     LET tm.fname='dsc-nm1.txt'
                     LET g_code='CHU'
                  ELSE
                     LET tm.fname='dsc-nm2.txt'
                     LET g_code='PDC'
                  END IF
                  DISPLAY BY NAME tm.fname
               END IF
            END IF
 
         AFTER FIELD more
            IF NOT cl_null(tm.more) THEN
               IF tm.more NOT MATCHES "[YN]" THEN
                  NEXT FIELD more
               END IF
               IF tm.more = 'Y' THEN
                  CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                 g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies
               END IF
            END IF
 
         AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            IF INT_FLAG THEN
               EXIT INPUT
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
 
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='anmp900'
         IF STATUS OR l_cmd IS NULL THEN
             CALL cl_err('anmp900','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.nmd03 CLIPPED,"'",
                            " '",tm.nma13 CLIPPED,"'",
                            " '",tm.more CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('anmp900',g_time,l_cmd)	# Execute cmd at later time
         END IF
         EXIT WHILE
      END IF
      CALL cl_wait()
      CALL anmp900()
      IF g_success = 'Y' THEN
         CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
      ELSE
         CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
      END IF
      IF g_flag THEN
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
      ERROR ""
   END WHILE
 
END FUNCTION
 
FUNCTION anmp900()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0082
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT #No.FUN-680107 VARCHAR(600)
          l_za05    LIKE type_file.chr1000, #標題內容 #No.FUN-680107 VARCHAR(40)
	  l_str     LIKE aaf_file.aaf03,    #No.FUN-680107 VARCHAR(40)
	  l_str1    LIKE type_file.chr20,   #No.FUN-680107 VARCHAR(20)
	  l_ans     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
	  l_inv     LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(80)
	  l_date    LIKE type_file.dat,     #No.FUN-680107 DATE
	  l_flag    LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
	  l_count   LIKE type_file.num10,   #No.FUN-680107 INTEGER #總筆
	  l_amt     LIKE type_file.num20_6, #No.FUN-680107 DEC(20,6) #No.FUN-4C0010
#	  l_npb05   LIKE npb_file.npb05,
          sr        RECORD
             f1     LIKE type_file.chr3,    #No.FUN-680107 VARCHAR(3)
             f2     LIKE type_file.chr6,    #No.FUN-680107 VARCHAR(6)
             nma04  LIKE nma_file.nma04,    #No.FUN-680107 VARCHAR(10) #銀行帳號
             nmd09  LIKE nmd_file.nmd09,    #No.FUN-680107 VARCHAR(70) #廠商全名
             nmd04  LIKE nmd_file.nmd04,    #No.FUN-680107 VARCHAR(15) #金額
#            nmd01  VARCHAR(12),               #開票編號
             nmd01  LIKE nmd_file.nmd01,    #No.FUN-680107 VARCHAR(16) #No.FUN-550057
             nmd091 LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(34) #收件人名稱
             pmc53  LIKE pmc_file.pmc53,    #No.FUN-680107 VARCHAR(105)#收件人地址
             nmd05  LIKE nmd_file.nmd05,    # Prog. Version..: '5.30.06-13.03.12(08) #到期日
             f3     LIKE type_file.chr4,    #No.FUN-680107 VARCHAR(4)  #MAIL
             pmc27  LIKE pmc_file.pmc27,    #No.FUN-680107 VARCHAR(1)  #寄領方式 1:寄出2:自領3:其他
             pmc52  LIKE pmc_file.pmc52,    #No.FUN-680107 VARCHAR(40) #發票地址
             pmc55  LIKE pmc_file.pmc55,    # Prog. Version..: '5.30.06-13.03.12(01) #是否繳切結書1:未2:已0:不需
    #        nmd10  VARCHAR(10),               #付款單號
             nmd10  LIKE nmd_file.nmd10,    #No.FUN-680107 VARCHAR(16) #No.FUN-550057
             nmd101 LIKE nmd_file.nmd101,   #No.FUN-680107 SMALLINT #付款單項次
             pmc910 LIKE pmc_file.pmc910    #No.FUN-680107 VARCHAR(3)
             END RECORD
     DEFINE    l_source,l_target,l_status STRING   #TQC-6C0176
 
 
     LET l_sql = " SELECT '','',nma04,nmd09,nmd04,nmd01",
                 "        ,nmd09,pmc53,nmd05,'MAIL',pmc27,pmc52,'2' ",
                 "        ,nmd10,nmd101,pmc910",
                 " FROM nma_file,nmd_file,pmc_file ",
                 " WHERE ",tm.wc CLIPPED,
 	         " AND (nmd02 IS NULL OR nmd02 = ' ') ",
                 " AND pmc01 = nmd08 ",
                 " AND nmd03 = nma01 ",
                 " AND nmd30 <> 'X' ",
                 " AND nmd03 = '",tm.nmd03 CLIPPED,"' ",
                 " AND nmd06 = '",tm.nmd06 CLIPPED,"' ",
                 " AND (nmd32!='Y' OR nmd32 IS NULL) " #未委花旗開票者
     PREPARE anmp900_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',STATUS,1)
        LET g_success = 'N'
        RETURN
     END IF
     DECLARE anmp900_curs1 CURSOR FOR anmp900_prepare1
     IF SQLCA.sqlcode THEN
        CALL cl_err('declare:',STATUS,1)
        LET g_success = 'N'
        RETURN
     END IF
 
 
     CALL cl_outnam('anmp900') RETURNING l_name
     LET l_count = 0
     LET l_amt = 0
 
     START REPORT anmp900_rep TO l_name
     LET g_pageno = 0
 
     BEGIN WORK
 
     LET g_success = 'Y'
     CALL s_showmsg_init()   #No.FUN-710024
     FOREACH anmp900_curs1 INTO sr.*
       MESSAGE g_x[49] CLIPPED,sr.nmd01
       CALL ui.Interface.refresh()
       IF STATUS != 0 THEN
#No.FUN-710024--begin
#          CALL cl_err('foreach:',STATUS,1) 
          CALL s_errmsg('','','foreach:',STATUS,1)
          LET g_success = 'N'
          EXIT FOREACH
#No.FUN-710024--end
       END IF
       IF sr.nmd09 IS NULL OR sr.nmd09=' ' THEN
          ERROR sr.nmd01,g_x[50]
          CONTINUE FOREACH
       END IF
       IF sr.nmd04 <0 OR sr.nmd04=0 OR sr.nmd04 IS NULL THEN
          ERROR sr.nmd01,g_x[51]
          CONTINUE FOREACH
       END IF
       IF sr.nmd05 IS NULL OR sr.nmd05=' ' THEN
          ERROR sr.nmd01,g_x[52]
          CONTINUE FOREACH
       END IF
       LET sr.f1=g_code
       LET sr.f2='020926'
       LET sr.f3='MAIL'
       LET l_inv=NULL
       IF sr.pmc53 IS NULL OR sr.pmc53=' ' THEN
          LET sr.pmc53=sr.pmc52 #發票地址
       END IF
       IF sr.pmc53 IS NULL OR sr.pmc53=' ' THEN
          ERROR sr.nmd01,g_x[54]
          CONTINUE FOREACH
       END IF
       LET l_count=l_count+1
       LET l_amt=l_amt+sr.nmd04
 
       OUTPUT TO REPORT anmp900_rep(sr.*,l_inv)
          CALL p900(sr.nmd10,'anmp9001.out')
          DROP TABLE anmp9001
#No.FUN-680107 -- start欄位類型修改
#         CREATE TEMP TABLE anmp9001 (l_inv VARCHAR(75))
          CREATE TEMP TABLE anmp9001(
                 l_inv LIKE type_file.chr1000)
#No.FUN-680107 --end
          LOAD FROM 'anmp9001.out' INSERT INTO anmp9001
          DECLARE q_cur2 CURSOR FOR SELECT * FROM anmp9001
          FOREACH q_cur2 INTO l_inv
            IF STATUS THEN
               CALL cl_err('foreach q_cur2:',STATUS,1)
               EXIT FOREACH
            END IF
            OUTPUT TO REPORT anmp900_rep(sr.*,l_inv)
          END FOREACH
 
       UPDATE nmd_file SET nmd15=g_today,
                           nmd16=g_user,
                           nmd32='Y'  #已委開票
          WHERE nmd01=sr.nmd01
       IF SQLCA.sqlcode THEN
#         CALL cl_err('update nmd32:',SQLCA.sqlcode,0)   #No.FUN-660148
#No.FUN-710024--begin
#          CALL cl_err3("upd","nmd_file",sr.nmd01,"",SQLCA.sqlcode,"","update nmd32:",0) #No.FUN-660148
          CALL s_errmsg('nmd01',sr.nmd01,'update nmd32:',SQLCA.sqlcode,1)
          LET g_success='N'
#          EXIT FOREACH  
          CONTINUE FOREACH
#No.FUN-710024--end
       END IF
     END FOREACH
 
     FINISH REPORT anmp900_rep
 
 
     IF g_success = 'N' THEN
        CALL cl_rbmsg(1)
        ROLLBACK WORK
        RETURN
     END IF
     MESSAGE g_x[55] CLIPPED,l_count,g_x[56] CLIPPED,l_amt
     CALL ui.Interface.refresh()
     SLEEP 3
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
     CALL s_showmsg()          #No.FUN-710024
     IF NOT cl_confirm('anm-950') THEN
        LET g_success = 'N'
        ROLLBACK WORK
        RETURN
     ELSE
        COMMIT WORK
     END IF
     #------------ Download 至 PC C:/TIPTOP 目錄下
    #No.+366 010705 plum
#    LET l_cmd = "chmod 777 ", tm.fname                   #No.FUN-9C0009
#    RUN l_cmd                                            #No.FUN-9C0009
     IF os.Path.chrwx(tm.fname CLIPPED,511) THEN END IF   #No.FUN-9C0009
    #No.+366..end
     LET l_cmd="cp ",l_name CLIPPED," ",tm.fname CLIPPED
     RUN l_cmd
     #-----TQC-6C0176---------
     #IF tm.nmd06='01' THEN
     #   LET l_cmd="dtcput $TEMPDIR/dsc-nm1.txt 'c:\\tiptop\\dsc-nm1.txt' "
     #ELSE
     #   LET l_cmd="dtcput $TEMPDIR/dsc-nm2.txt 'c:\\tiptop\\dsc-nm2.txt' "
     #END IF
     #RUN l_cmd
     IF tm.nmd06='01' THEN
        LET l_source = os.Path.join( FGL_GETENV("TEMPDIR"),"dsc-nm1.txt")
        LET l_target = "c:\\tiptop\\dsc-nm1.txt"
        LET l_status = cl_download_file(l_source,l_target)
     ELSE
        #LET l_source = os.Path.join( FGL_GETEN("TEMPDIR"),"dsc-nm2.txt")
        LET l_source = os.Path.join( FGL_GETENV("TEMPDIR"),"dsc-nm2.txt")  #MOD-A10088 mod
        LET l_target = "c:\\tiptop\\dsc-nm2.txt"
        LET l_status = cl_download_file(l_source,l_target)
     END IF
     IF l_status THEN
        CALL cl_err(l_source,"amd-020",1)
     ELSE
        CALL cl_err(l_source,"amd-021",1)
     END IF
     #-----END TQC-6C0176----- 
END FUNCTION
 
REPORT anmp900_rep(sr,l_inv)
   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          l_p_flag      LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          l_flag1       LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          l_nmd14       LIKE nmd_file.nmd14,    #No.FUN-680107 VARCHAR(4)
          l_pmc48       LIKE pmc_file.pmc48,    #No.FUN-680107 VARCHAR(8) 
          l_inv         LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(80)
          sr            RECORD
             f1     LIKE type_file.chr3,        #No.FUN-680107 VARCHAR(3)
             f2     LIKE type_file.chr6,        #No.FUN-680107 VARCHAR(6)
             nma04  LIKE nma_file.nma04,        #No.FUN-680107 VARCHAR(10)
             nmd09  LIKE nmd_file.nmd09,        #No.FUN-680107 VARCHAR(70)
             nmd04  LIKE nmd_file.nmd04,        #No.FUN-680107 VARCHAR(75)
#            nmd01  VARCHAR(12),
             nmd01  LIKE nmd_file.nmd01,        #No.FUN-680107 VARCHAR(16) #No.FUN-550057
             nmd091 LIKE type_file.chr1000,     #No.FUN-680107 VARCHAR(34)
             pmc53  LIKE pmc_file.pmc53,        #No.FUN-680107 VARCHAR(105)
             nmd05  LIKE nmd_file.nmd05,        #No.FUN-680107 VARCHAR(8)
             f3     LIKE type_file.chr4,        #No.FUN-680107 VARCHAR(4)
             pmc27  LIKE pmc_file.pmc27,        #No.FUN-680107 VARCHAR(1)  #寄領方式 1:寄出2:自領3:其他
             pmc52  LIKE pmc_file.pmc52,        #No.FUN-680107 VARCHAR(40) #發票地址
             pmc55  LIKE pmc_file.pmc55,        #No.FUN-680107 VARCHAR(1)  #是否繳切結書1:未2:已3:不需
#            nmd10  VARCHAR(10),                   #付款單號
             nmd10  LIKE nmd_file.nmd10,        #No.FUN-680107 VARCHAR(16) #No.FUN-550057
             nmd101 LIKE nmd_file.nmd101,       #No.FUN-680107 SMALLINT #付款單項次
             pmc910 LIKE pmc_file.pmc910        #No.FUN-680107 VARCHAR(3)
             END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  FORMAT
 
   ON EVERY ROW
      IF l_inv IS NULL THEN
         PRINT sr.f1,
            COLUMN 04,sr.f2,
            COLUMN 10,sr.nma04[1,10],
            COLUMN 20,sr.nmd09[1,70],
            COLUMN 90,sr.nmd04 USING '###############',
            COLUMN 105,sr.nmd01,
            COLUMN 115,sr.nmd09[1,34],
            COLUMN 149,sr.pmc53,
            COLUMN 254,YEAR(sr.nmd05) USING '&&&&',
            COLUMN 258,MONTH(sr.nmd05) USING '&&',
            COLUMN 260,DAY(sr.nmd05) USING '&&',
            COLUMN 262,sr.f3
      ELSE
         PRINT 'INV',l_inv[1,75]
      END IF
END REPORT
 
FUNCTION p900(l_apf01,l_name)
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0082
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT #No.FUN-680107 VARCHAR(900)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(40)
          l_apz04p  LIKE apz_file.apz04p,
          l_apf01   LIKE apf_file.apf01,
          l_order   ARRAY[5] OF LIKE cre_file.cre08,         #No.FUN-680107 ARRAY[5] OF VARCHAR(10)
          sr1              RECORD apf01 LIKE apf_file.apf01, #付款單單頭檔
                                  apf02 LIKE apf_file.apf02,
                                  apf03 LIKE apf_file.apf03,
                                  apf04 LIKE apf_file.apf04,
                                  apf05 LIKE apf_file.apf05,
                                  apf06 LIKE apf_file.apf06,
                                  apf07 LIKE apf_file.apf07,
                                  apf08 LIKE apf_file.apf08,
                                  apf09 LIKE apf_file.apf09,
                                  apf10 LIKE apf_file.apf10,
                                  apf43 LIKE apf_file.apf43,
                                  apf44 LIKE apf_file.apf44,
                                  apf41 LIKE apf_file.apf41,
                                  apfmksg LIKE apf_file.apfmksg,
                                  apfprno LIKE apf_file.apfprno,
                                  apf12 LIKE apf_file.apf12,
                                  apg02 LIKE apg_file.apg02,
                                  apg03 LIKE apg_file.apg03,
                                  apg04 LIKE apg_file.apg04,
                                  apg05 LIKE apg_file.apg05
                        END RECORD,
        l_dbs_anm,l_dbs LIKE type_file.chr20   #No.FUN-680107 VARCHAR(20)
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmp900'
     LET g_len=75
     FOR g_i = 1 TO g_len
         LET g_dash[g_i,g_i] = '='
         LET g_dash_1[g_i,g_i] = '-'
     END FOR
 
     LET l_sql = "SELECT ",
                 " apf01, apf02, apf03, apf04, apf05, apf06,",
                 " apf07, apf08, apf09, apf10, apf43, apf44,",
                 " apf41, apfmksg, apfprno, apf12,",
                 " apg02, apg03,  apg04, apg05   ",
                 " FROM apf_file, apg_file ",
                 " WHERE apf01 = apg01 ",
                 " AND apf01 ='",l_apf01 CLIPPED,"'",
                 " AND apf41 <> 'X' ",
                 " AND apf00 ='33' "
     PREPARE p900_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)  
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE p900_curs1 CURSOR FOR p900_prepare1
 
     #-->列印付款單的貸方
     SELECT apz04p INTO l_apz04p FROM apz_file WHERE apz00='0'
     SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_apz04p
#TQC-940177  --start  
    {IF l_dbs IS NOT NULL AND l_dbs != ' '
     THEN LET l_dbs_anm = l_dbs clipped,"." clipped
     ELSE LET l_dbs_anm = ' '
     END IF
    }
     IF l_dbs IS NOT NULL AND l_dbs != ' '      
     THEN LET l_dbs_anm = s_dbstring(l_dbs clipped)
     ELSE LET l_dbs_anm = ' '  
     END IF   
#TQC-940177  --end   
     LET l_sql = " SELECT aph01,aph02,aph03,aph04,aph05,aph06",
                 ",aph07,aph08,aph09,nma02 ",
                 #" FROM aph_file LEFT OUTER JOIN ",l_dbs_anm CLIPPED," nma_file ",
                 " FROM aph_file LEFT OUTER JOIN ",cl_get_target_table(l_apz04p,'nma_file'), #FUN-A50102
                 " ON aph08 = nma_file.nma01 WHERE aph01 = ?"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102								
	 CALL cl_parse_qry_sql(l_sql,l_apz04p) RETURNING l_sql     #FUN-A50102            
     PREPARE aph_prepare FROM l_sql
     DECLARE aph_curs CURSOR FOR aph_prepare
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('perpare aph_fiie error!',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
      #-->額外備註列印
       LET l_sql = " SELECT apd03 FROM apd_file ",
                   "  WHERE apd01 =  ? "
       PREPARE apd_prepare FROM l_sql
       DECLARE apd_curs CURSOR FOR apd_prepare
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('perpare apd_fiie error!',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
           EXIT PROGRAM
        END IF
 
     START REPORT p900_rep TO l_name
# genero  sript marked      LET g_pageno = 0
     FOREACH p900_curs1 INTO sr1.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       OUTPUT TO REPORT p900_rep(sr1.*)
     END FOREACH
 
     FINISH REPORT p900_rep
    #No.+366 010705 plum
#    LET l_cmd = "chmod 777 anmp9001.out"               #No.FUN-9C0009
#    RUN l_cmd                                          #No.FUN-9C0009
     IF os.Path.chrwx("anmp9001.out",511) THEN END IF   #No.FUN-9C0009
    #No.+366..end
END FUNCTION
 
REPORT p900_rep(sr1)
   DEFINE l_last_sw        LIKE type_file.chr1,              #No.FUN-680107 VARCHAR(1)
          sr1              RECORD apf01 LIKE apf_file.apf01, #付款單單頭檔
                                  apf02 LIKE apf_file.apf02,
                                  apf03 LIKE apf_file.apf03,
                                  apf04 LIKE apf_file.apf04,
                                  apf05 LIKE apf_file.apf05,
                                  apf06 LIKE apf_file.apf06,
                                  apf07 LIKE apf_file.apf07,
                                  apf08 LIKE apf_file.apf08,
                                  apf09 LIKE apf_file.apf09,
                                  apf10 LIKE apf_file.apf10,
                                  apf43 LIKE apf_file.apf43,
                                  apf44 LIKE apf_file.apf44,
                                  apf41 LIKE apf_file.apf41,
                                  apfmksg LIKE apf_file.apfmksg,
                                  apfprno LIKE apf_file.apfprno,
                                  apf12 LIKE apf_file.apf12,
                                  apg02 LIKE apg_file.apg02,
                                  apg03 LIKE apg_file.apg03,
                                  apg04 LIKE apg_file.apg04,
                                  apg05 LIKE apg_file.apg05
                           END RECORD,
          sr12             RECORD apa02 LIKE apa_file.apa02,
                                  apa08 LIKE apa_file.apa08,
                                  apa09 LIKE apa_file.apa09,
                                  apa12 LIKE apa_file.apa12,
                                  apa24 LIKE apa_file.apa24,
                                  apa31 LIKE apa_file.apa31,
                                  apa32 LIKE apa_file.apa32,
                                  apa60 LIKE apa_file.apa60,
                                  apa61 LIKE apa_file.apa61,
                                  apb04 LIKE apb_file.apb04, #應付帳款單身檔
                                  apb06 LIKE apb_file.apb06,
                                  apb08 LIKE apb_file.apb08,
                                  apb09 LIKE apb_file.apb09,
                                  apb10 LIKE apb_file.apb10,
                                  apb13 LIKE apb_file.apb13,
                                  apb15 LIKE apb_file.apb15,
                                  apb14 LIKE apb_file.apb14,
                                 #rvb05 LIKE rvb_file.rvb05, #驗收單身檔        #TQC-990048 mark
                                  azi03 LIKE azi_file.azi03, #幣別檔
                                  azi04 LIKE azi_file.azi04,
                                  azi05 LIKE azi_file.azi05,
                                  azi07 LIKE azi_file.azi07   #No.FUN-870151
                       END RECORD,
          sr2              RECORD aph01 LIKE aph_file.aph01,
                                  aph02 LIKE aph_file.aph02,
                                  aph03 LIKE aph_file.aph03,
                                  aph04 LIKE aph_file.aph04,
                                  aph05 LIKE aph_file.aph05,
                                  aph06 LIKE aph_file.aph06,
                                  aph07 LIKE aph_file.aph07,
                                  aph08 LIKE aph_file.aph08,
                                  aph09 LIKE aph_file.aph09,
                                  nma02 LIKE nma_file.nma02
                       END RECORD,
      l_sql        LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(600)
      l_cnt        LIKE type_file.num5,          #No.FUN-680107 SMALLINT
      l_pritem     LIKE type_file.num5,          #No.FUN-680107 SMALLINT
      l_miscnum    LIKE type_file.num5,          #No.FUN-680107 SMALLINT
      l_amt        LIKE type_file.num20_6,       #No.FUN-4C0010 #No.FUN-680107 DECIMAL(20,6)
      l_tot1,l_tot2,l_tot3 LIKE type_file.num20_6,#No.FUN-4C0010 #No.FUN-680107 DECIMAL(20,6)
      l_apk03      LIKE apk_file.apk03,
      l_apk05      LIKE apk_file.apk05,
      l_apk06      LIKE apk_file.apk06,
      l_apk07      LIKE apk_file.apk07,
      l_apk08      LIKE apk_file.apk08,
      l_nmd02      LIKE nmd_file.nmd02,
      l_apd03      LIKE apd_file.apd03           #備註檔
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin  #FUN-580098
         PAGE LENGTH g_page_line
  ORDER BY sr1.apf01,sr1.apg02
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
      PRINT g_dash[1,g_len]
 
   BEFORE GROUP OF sr1.apf01    #付款單號
      IF PAGENO > 1 OR LINENO > 9
         THEN SKIP TO TOP OF PAGE
      END IF
      LET l_tot1 = 0
      LET l_tot2 = 0 LET l_tot3 = 0
 
      PRINT COLUMN 1,  g_x[11] CLIPPED , sr1.apf01,
            COLUMN 25, g_x[12] CLIPPED , sr1.apf04,
            COLUMN 54, g_x[15] CLIPPED , sr1.apf05
      PRINT COLUMN 1,  g_x[14] CLIPPED , sr1.apf02,
            COLUMN 25, g_x[13] CLIPPED , cl_numfor(sr1.apf08,13,sr12.azi04),
            COLUMN 54, g_x[16] CLIPPED , sr1.apf06,
           #COLUMN 68, sr1.apf07 USING '####&.&&'            #No.FUN-870151
            COLUMN 68, cl_numfor(sr1.apf07,68,sr12.azi07)    #No.FUN-870151
      PRINT COLUMN 1,  g_x[17] CLIPPED , sr1.apf03,
            COLUMN 25, g_x[18] CLIPPED , cl_numfor(sr1.apf09,13,sr12.azi04),
            COLUMN 54, g_x[19] CLIPPED , sr1.apfmksg,
            COLUMN 68, g_x[20] CLIPPED , sr1.apf41
      PRINT COLUMN 1,  g_x[21] CLIPPED , sr1.apf12,
            COLUMN 25, g_x[22] CLIPPED , cl_numfor(sr1.apf10,13,sr12.azi04),
            COLUMN 54, g_x[23] CLIPPED , sr1.apf44
      PRINT g_dash_1[1,g_len]
      PRINT g_x[57] CLIPPED,g_x[58] CLIPPED
      PRINT '-------- ------------ -------- --------',
            ' ----------------------  ----------'
      LET l_last_sw = 'n'
 
      #--->列印付款單貸方資料
      FOREACH  aph_curs USING sr1.apf01 INTO sr2.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach apf_file error !',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           CASE WHEN sr2.aph03 = '1' PRINT COLUMN 1, g_x[35] CLIPPED;
                WHEN sr2.aph03 = '2' PRINT COLUMN 1, g_x[36] CLIPPED;
                WHEN sr2.aph03 = '3' PRINT COLUMN 1, g_x[37] CLIPPED;
                WHEN sr2.aph03 = '4' PRINT COLUMN 1, g_x[38] CLIPPED;
                WHEN sr2.aph03 = '5' PRINT COLUMN 1, g_x[39] CLIPPED;
                WHEN sr2.aph03 = '6' PRINT COLUMN 1, g_x[44] CLIPPED;
                WHEN sr2.aph03 = '7' PRINT COLUMN 1, g_x[40] CLIPPED;
                WHEN sr2.aph03 = '8' PRINT COLUMN 1, g_x[41] CLIPPED;
                WHEN sr2.aph03 = '9' PRINT COLUMN 1, g_x[42] CLIPPED;
           END CASE
           PRINT COLUMN 9 , cl_numfor(sr2.aph05,12,sr12.azi04) CLIPPED ,
                 COLUMN 23, sr2.aph06 ,
                 COLUMN 32, sr2.aph07 ,
                 COLUMN 41, sr2.aph08 CLIPPED,' ',sr2.nma02 CLIPPED;
                 IF sr2.aph03 MATCHES "[6789]"
                    THEN PRINT COLUMN 65, sr2.aph04 CLIPPED
                    ELSE PRINT COLUMN 65, l_nmd02  CLIPPED
                 END IF
           LET l_tot1 = l_tot1 + sr2.aph05
      END FOREACH
      PRINT ' '
      #--->付款單借方資料表頭
      PRINT COLUMN 2, g_x[43] CLIPPED,
            COLUMN 9, cl_numfor(l_tot1,12,sr12.azi04) CLIPPED
      PRINT g_dash_1[1,g_len]
      PRINT g_x[26] CLIPPED, g_x[27] CLIPPED, g_x[28] CLIPPED
      PRINT "-- ---------- ---------- -------- ---------- -------- ---------- ----------"
   BEFORE GROUP OF sr1.apg02                  #借方項次
     LET g_plant_new = sr1.apg03
     #CALL s_getdbs()             #FUN-A50102 
     LET l_sql=" SELECT apk03,apk05,apk06,apk07,apk08 ",
               #" FROM  ",g_dbs_new CLIPPED," apk_file ",
               " FROM  ",cl_get_target_table(sr1.apg03,'apk_file'), #FUN-A50102
               " WHERE apk01 =  ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr1.apg03) RETURNING l_sql     #FUN-A50102 
     PREPARE p900_premisc FROM l_sql
     DECLARE p900_misc CURSOR FOR p900_premisc
     #-->各廠的請款資料讀取
     LET l_sql = " SELECT apa02, apa08, apa09, apa12, apa24, apa31, ",
                 " apa32, apa60, apa61,",
                 " apb04, apb06, apb08, apb09, apb10, apb13, apb15, apb14,",
                 " azi03, azi04, azi05,azi07 ",   #No.FUN-870151 Add azi07
                 #" FROM  ",g_dbs_new CLIPPED," apa_file,OUTER ",
                 " FROM  ",cl_get_target_table(sr1.apg03,'apa_file'), #FUN-A50102
                 " ,OUTER ",
                #           " LEFT JOIN apb_file LEFT JOIN rvb_file ",    #FUN-A60056
                            " LEFT JOIN apb_file LEFT JOIN ",cl_get_target_table(sr1.apg03,'rvb_file'),   #FUN-A60056
                 " ON apa01 = apb_file.apb01 ",
                 "  WHERE apa01 = '",sr1.apg04,"'",
                 "   AND apa42 = 'N' ",
                 "   AND apa13 = azi01 " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr1.apg03) RETURNING l_sql  #FUN-A60056
     PREPARE p900_ppay FROM l_sql
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT PROGRAM
       END IF
     LET l_pritem = 1
     DECLARE p900_cpay CURSOR FOR p900_ppay
     FOREACH p900_cpay INTO sr12.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreac p900_cpay',SQLCA.sqlcode,0)
           EXIT FOREACH
        END IF
         LET l_amt = sr12.apa31 + sr12.apa32 - sr12.apa60 - sr12.apa61
         IF l_pritem = 1 THEN
            IF sr12.apa08 = 'MISC' THEN
               LET l_miscnum = 1
               FOREACH p900_misc USING sr1.apg04
                                 INTO l_apk03,l_apk05,l_apk06,l_apk07,l_apk08
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('misc invoice',SQLCA.sqlcode,0)
                     EXIT FOREACH
                  END IF
                  IF l_miscnum = 1 THEN
                      PRINT sr1.apg02 USING '##',' ',       #借方項次
                            sr1.apg04;                      #帳款編號
                  END IF
                  PRINT column 15,
                       l_apk03,' ',                         #發票號碼
                       l_apk05,                             #發票日期
                       cl_numfor(l_apk08,10,sr12.azi04),    #貨款
                       cl_numfor(l_apk07,08,sr12.azi04),    #稅額
                       cl_numfor(l_apk06,10,sr12.azi04),    #合計
                       cl_numfor(l_apk06,10,sr12.azi04)     #沖帳金額
                  let l_miscnum = l_miscnum + 1
               END FOREACH
            ELSE
               PRINT sr1.apg02 USING '##',' ',               #借方項次
                     sr1.apg04,' ',                          #帳款編號
                     sr12.apa08,' ',                         #發票號碼
                     sr12.apa09,                             #發票日期
                     cl_numfor(sr12.apa31,10,sr12.azi04),    #貨款
                     cl_numfor(sr12.apa32,08,sr12.azi04),    #稅額
                     cl_numfor(l_amt,10,sr12.azi04),         #合計
                     cl_numfor(sr1.apg05,10,sr12.azi04)      #本次沖帳金額
            END IF
            LET l_tot2 = l_tot2 + l_amt
            LET l_tot3 = l_tot3 + sr1.apg05
         END IF
         #-->已開立折讓資料
          IF sr12.apa60 > 0 AND l_pritem = 1 THEN
             LET sr12.apa60 = sr12.apa60 * -1
             LET sr12.apa61 = sr12.apa61 * -1
             PRINT COLUMN 22,g_x[44] CLIPPED, COLUMN 29,
                   cl_numfor(sr12.apa60,12,sr12.azi04),
                   cl_numfor(sr12.apa61,12,sr12.azi04)
          END IF
          LET l_pritem = l_pritem + 1
 
     END FOREACH
 
   AFTER GROUP OF sr1.apf01
      PRINT ' '
      #-->合計資料列印
      PRINT COLUMN 40, g_x[43] CLIPPED,
            COLUMN 54, cl_numfor(l_tot2,10,sr12.azi04) CLIPPED,
            COLUMN 65, cl_numfor(l_tot3,10,sr12.azi04) CLIPPED
      LET l_last_sw = 'y'
      LET g_pageno = 0
 
   ON LAST ROW
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      PRINT g_dash[1,g_len]
END REPORT
#Patch....NO.TQC-610036 <001,002,003,004> #
