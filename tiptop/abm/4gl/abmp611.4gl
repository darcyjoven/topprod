# Prog. Version..: '5.30.06-13.04.18(00010)'     #
#
# Pattern name...: abmp611.4gl
# Descriptions...: 產品結構整體偵錯作業
# Input parameter:
# Return code....:
# Date & Author..: 91/10/23 By Lin
# Modify.........:#No.MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-510033 05/02/17 By Mandy 報表轉XML
# Modify.........: No.FUN-550093 05/06/06 By kim 配方BOM,特性代碼
# Modify.........: No.MOD-5B0270 05/12/07 By Pengu p611_bom 抓BOM的SQL，沒有考慮失效日
# Modify.........: NO.FUN-5B0142 06/01/03 BY yiting 加上是否顯示執行過程選項及cl_progress_bar()
# Modify.........: No.FUN-570114 06/02/22 By saki 批次背景執行
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: NO.TQC-6A0044 06/10/20 BY Claire 加上有效碼判斷
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.CHI-730011 07/08/17 By xufeng 畫面上已有是否運行本作業的選項，故去掉詢問是否運行本作業的對話框
# Modify.........: No.MOD-870061 08/07/04 By claire 沒有報表產生時不應chmod l_name,以免有警告訊息,造成user誤解
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0179 09/11/11 By sabrina 背景處理時未給g_success變數值
# Modify.........: No.FUN-9B0113 09/11/19 By alex 改chmod為使用Genero API 7*64+7*8+7=511
# Modify.........: No.TQC-A30020 10/03/11 By lilingyu 選項"是否顯示運行過程"值設置錯誤,導致勾選時,不顯示;不勾選時,顯示
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting    1、將cl_used()改成標準格式，用g_prog
#                                                            2、離開前未加cl_used(2)
# Modify.........: No:MOD-BC0192 12/02/17 By bart 無法展BOM
# Modify.........: No:MOD-C20111 12/02/23 By Elise 變數l_sw_tot數量小於10的時候，跑cl_process_bar時會一直出錯的問題
# Modify.........: No:MOD-C20196 12/02/28 By Elise create temp table加上index
# Modify.........: No:CHI-C30056 12/03/14 By ck2yuan 改善效能,將定義cursor 搬到迴圈外面,避免多次連接資料庫造成效能降低
# Modify.........: No:CHI-C50062 12/05/24 By ck2yuan 未考慮替代料的替代料或往外延伸的情況

IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm RECORD                           # 是否執行本作業
             a   LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
             t   LIKE type_file.chr1     #NO.FUN-5B0142 #No.FUN-680096 VARCHAR(1)
       END RECORD,
    g_bmd01 LIKE bmd_file.bmd01,         # 主件料件編號
    g_item  LIKE bma_file.bma01,         # 第0階的主件料件編號
    g_bma01 ARRAY[100] OF LIKE bma_file.bma01, # 已被使用主件編號,' ',特性代碼 #FUN-550093
    g_max LIKE type_file.num5,           # 用來記錄目前ARRAY己使用筆數  #No.FUN-680096 SMALLINT
    g_err LIKE type_file.num5,           # 用來記錄發生錯誤的次數  #No.FUN-680096 INTEGER
    g_tot,g_tot2 LIKE type_file.num10    #No.FUN-680096 INTEGER
 
DEFINE   g_chr           LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03,      #No.FUN-680096   VARCHAR(72)
         l_flag          LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
         g_change_lang   LIKE type_file.chr1     #是否有做語言切換 #No.FUN-680096 VARCHAR(1)
#       l_time         LIKE type_file.chr8              #No.FUN-6A0060
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   #No.FUN-570114 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.a    = ARG_VAL(1)
   LET tm.t    = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No.FUN-570114 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-570114 --start--
#      LET g_pdate = ARG_VAL(1)		# Get arguments from command line
#      LET g_towhom = ARG_VAL(2)
#      LET g_rlang = ARG_VAL(3)
#      LET g_bgjob = ARG_VAL(4)
#      LET g_prtway = ARG_VAL(5)
#      LET g_copies = ARG_VAL(6)
#      LET tm.a = ARG_VAL(7)
#  #No.FUN-570264 --start--
#  LET g_rep_user = ARG_VAL(8)
#  LET g_rep_clas = ARG_VAL(9)
#  LET g_template = ARG_VAL(10)
#  #No.FUN-570264 ---end---
#  IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
#     THEN CALL p611_tm(0,0)			# Input print condition
#     ELSE CALL p611()			# Read bmata and create out-file
#  END IF
 
   # CALL cl_used('abmp611',g_time,1) RETURNING g_time    #No.FUN-6A0060   #FUN-B30211
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0060    #FUN-B30211
    WHILE TRUE
     #CHI-730011 --end  
     IF g_bgjob = 'N' THEN
        CALL p611_tm(0,0)
        LET g_success = 'Y'
        #CHI-730011 --begin
        IF tm.a = 'N' THEN
           LET g_success = 'N'
        END IF
       #IF cl_sure(21,21) THEN   #CHI-730011
           IF tm.a='Y' THEN
              CALL cl_wait()
              CALL p611()
              DROP TABLE  p611_tm1
           END IF
           IF g_success = 'Y' THEN
              CALL cl_end2(1) RETURNING l_flag          #作業成功是否繼續執行
           ELSE
              CALL cl_end2(2) RETURNING l_flag          #作業失敗是否繼續執行
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p611_w
              EXIT WHILE
           END IF
     #CHI-730011  --begin
     #  ELSE
     #     CONTINUE WHILE
     #  END IF
     #CHI-730011  --end  
        CLOSE WINDOW p611_w
     ELSE
        IF tm.a='Y' THEN 
           LET g_success = 'Y'    #No:MOD-9A0179 add
           CALL p611() 
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
  END WHILE
  #CALL cl_used('abmp611',g_time,2) RETURNING g_time   #No.FUN-6A0060     #FUN-B30211
  CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0060     #FUN-B30211
   #No.FUN-570114 ---end---
END MAIN
 
FUNCTION p611_tm(p_row,p_col)
   DEFINE   p_row,p_col	  LIKE type_file.num5,     #No.FUN-680096 SMALLINT
            l_cmd         LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(400)
            l_item        LIKE type_file.chr20,    #No.FUN-680096 VARCHAR(20)
            lc_cmd        LIKE type_file.chr1000   #No.FUN-570114  #No.FUN-680096  VARCHAR(500)
 
 
   LET p_row = 5 LET p_col = 9
 
   OPEN WINDOW p611_w AT p_row,p_col
        WITH FORM "abm/42f/abmp611"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   IF s_shut(0) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0060     #FUN-B30211
      EXIT PROGRAM
   END IF                #檢查權限
WHILE TRUE
      LET g_pdate = g_today
      LET g_rlang = g_lang
      LET g_bgjob = 'N'
      LET g_copies = '1'
      LET g_towhom = NULL
     #LET tm.a='N'  #CHI-730011
      LET tm.a='Y'  #CHI-730011
      LET tm.t='Y'  #NO.FUN-5B0142
      LET g_change_lang = FALSE
      CLEAR FORM
      LET l_item=''
      DISPLAY tm.a TO FORMONLY.a
#      INPUT BY NAME tm.a WITHOUT DEFAULTS
      INPUT BY NAME tm.a,tm.t,g_bgjob WITHOUT DEFAULTS  #NO.FUN-5B0142  #No.FUN-570114
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         AFTER FIELD a
            IF tm.a NOT MATCHES "[YyNn]"  OR tm.a IS NULL THEN
               NEXT FIELD a
            END IF
 
         #No.FUN-570114 --start--
         ON CHANGE g_bgjob
            IF g_bgjob = "Y" THEN
               LET tm.t = "N"
               DISPLAY BY NAME tm.t
               CALL cl_set_comp_entry("t",FALSE)
            ELSE
               CALL cl_set_comp_entry("t",TRUE)
            END IF
         #No.FUN-570114 ---end---
 
 
         ON ACTION other_condition
 
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang, g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang, g_bgjob,g_time,g_prtway,g_copies
            IF INT_FLAG THEN
               LET INT_FLAG=0
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
 
         ON ACTION locale
#            CALL cl_dynamic_locale()               #No.FUN-570114
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
             LET g_change_lang = TRUE
             EXIT INPUT
         ON ACTION exit                            #加離開功能
             LET INT_FLAG = 1
             EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p611_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0060     #FUN-B30211
         EXIT PROGRAM
      END IF
      IF g_change_lang = TRUE THEN
         LET g_change_lang = FALSE              #No.FUN-570114
         CALL cl_dynamic_locale()               #No.FUN-570114
         CALL cl_show_fld_cont()                #No.FUN-570114  No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
 
      #No.FUN-570114 --start--
#     IF g_bgjob = 'Y' THEN
#        SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
#         WHERE zz01='abmp611'
#        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
#           CALL cl_err('abmp611','9031',1)
#        ELSE
#           LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
#                           " '",g_pdate CLIPPED,"'",
#                           " '",g_towhom CLIPPED,"'",
#                           " '",g_lang CLIPPED,"'",
#                           " '",g_bgjob CLIPPED,"'",
#                           " '",g_prtway CLIPPED,"'",
#                           " '",g_copies CLIPPED,"'",
#                           " '",tm.a CLIPPED,"'",
#                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
#                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
#                        " '",g_template CLIPPED,"'"            #No.FUN-570264
#           CALL cl_cmdat('abmp611',g_time,l_cmd)	# Execute cmd at later time
#        END IF
#        CLOSE WINDOW p611_w
#        EXIT PROGRAM
#     END IF
#     IF tm.a='Y' THEN
#        CALL cl_wait()
#        CALL p611()
#        DROP TABLE  p611_tm1
#     END IF
      ERROR ""
#     CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#     IF l_flag THEN
#        CLEAR FORM
#        ERROR ""
#        LET g_item=''
#        CONTINUE WHILE
#     ELSE
#        EXIT WHILE
#     END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = 'abmp611'
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('abmp611','9031',1)
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",tm.a CLIPPED,"'",
                      " '",tm.t CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('abmp611',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p611_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0060     #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
   END WHILE
#  CLOSE WINDOW p611_w
   #No.FUN-570114 ---end---
END FUNCTION
 
FUNCTION p611()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT     #No.FUN-680096 VARCHAR(601)
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          l_cmd         LIKE type_file.chr50,   #No.FUN-680096 VARCHAR(30)
          l_cnt         LIKE type_file.num10,   #bma_file read count  #No.FUN-680096 INTEGER
          l_flag        LIKE type_file.chr1,    #是否執行過的旗標        #No.FUN-680096 VARCHAR(1)
          l_bma01       LIKE bma_file.bma01,    #主件料件
          l_bma06       LIKE bma_file.bma06,    #FUN-550093
          l_bma01_t     LIKE bma_file.bma01,    #FUN-5B0142
          l_cnt1        LIKE type_file.num10,   #NO.FUN-5B0142 #No.FUN-680096 INTEGER
          l_sw_tot      LIKE type_file.num10,   #NO.FUN-5B0142 #No.FUN-680096 INTEGER
          l_sw          LIKE type_file.num10,   #NO.FUN-5B0142 #No.FUN-680096 INTEGER
          l_count       LIKE type_file.num5     #NO.FUN-5B0142 #No.FUN-680096 SMALLINT
 
     #    DROP  TABLE  p611_tm1
     #此TEMP TABLE主要的目地是將已展開過的主件編號做MARK
     #若flag='Y'表示已展過,所以不再展開,以節省執行時間
#No.FUN-680096------------------begin----------------
          CREATE TEMP TABLE p611_tm1(
              bma01    LIKE bma_file.bma01,
              bma06    LIKE bma_file.bma06,
              flag     LIKE type_file.chr1)
#No.FUN-680096----------------end---------------------
          
          CREATE INDEX p611_index ON p611_tm1(bma01)   #MOD-C20196 add
 
       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql= "SELECT bmd02,bmd04 FROM bmd_file WHERE bmd01=?",
                "  AND (bmd08=? OR bmd08='ALL') ",                 #CHI-C50062 add
                "  AND (bmd05 <='",g_today,"' OR bmd05 IS NULL) ", #No.8821
                "  AND (bmd06 >'",g_today, "' OR bmd06 IS NULL) ",
                "  AND bmdacti = 'Y'"                                           #CHI-910021
     PREPARE p611_pp FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('P(bmd):',SQLCA.sqlcode,1)
        CALL cl_batch_bg_javamail('N')                #No.FUN-570114
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0060     #FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE p611_cbmd CURSOR FOR p611_pp
 
  # 組合SQL,讀取所有的主件
     LET l_sql = "SELECT bma01,bma06 ", #FUN-550093
                 " FROM  bma_file",
                 " WHERE bmaacti='Y' "
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
 
     PREPARE p611_p1 FROM l_sql
     PREPARE p611_p2 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_batch_bg_javamail('N')                #No.FUN-570114
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0060     #FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE p611_cs1 CURSOR FOR p611_p1
 
     DECLARE p611_cs2 CURSOR FOR p611_p2
     #先將所有的主件編號放入TEMP TABLE,並將flag設成'N',表尚未展開過
     FOREACH p611_cs2  INTO l_bma01,l_bma06 #FUN-550093
         INSERT INTO p611_tm1  VALUES (l_bma01,l_bma06,'N') #FUN-550093
     END FOREACH
     #----------NO.FUN-5B0142 START-------
    #IF tm.t = 'N' AND g_bgjob = "N" THEN                   #No.FUN-570114  #TQC-A30020
     IF tm.t = 'Y' AND g_bgjob = "N" THEN                                   #TQC-A30020
         LET l_count = 1
         SELECT COUNT(*) INTO l_sw_tot
           FROM p611_tm1
         IF l_sw_tot>0 THEN
             IF l_sw_tot > 10 THEN
                 LET l_sw = l_sw_tot /10
                 CALL cl_progress_bar(10)
                 CALL cl_ui_locale("cl_progress_bar")  #TQC-A30020
            #END IF                                    #MOD-C20111 mark
            #MOD-C20111----add----str----
             ELSE
                  CALL cl_progress_bar(l_sw_tot)
                  CALL cl_ui_locale("cl_progress_bar")
             END IF
            #MOD-C20111----add----end----
         #MOD-C20111----mark----str----
         #ELSE
         #    CALL cl_progress_bar(l_sw_tot)
         #    CALL cl_ui_locale("cl_progress_bar")  #TQC-A30020
         #MOD-C20111----mark----end----
         END IF
    END IF
    #-------------NO.FUN-5B0142 END--------
 
     CALL cl_outnam('abmp611') RETURNING l_name
 
     START REPORT p611_rep TO l_name
     LET g_pageno = 0

     CALL p611_def_cur()   #CHI-C30056 add
 
     LET g_err=0
     LET g_item=' '
     LET l_bma01=' '
	LET g_tot=0
	LET g_tot2=0
     LET l_cnt = 0
     FOREACH p611_cs1 INTO l_bma01,l_bma06 #FUN-550093
       IF SQLCA.sqlcode THEN CALL cl_err('F1:',SQLCA.sqlcode,1)
          #IF tm.t = 'N' AND g_bgjob = "N" THEN CALL cl_close_progress_bar() END IF #NO.FUN-5B0142   #No.FUN-570114  #TQC-A30020
           IF tm.t = 'Y' AND g_bgjob = "N" THEN CALL cl_close_progress_bar() END IF #NO.FUN-5B0142   #TQC-A30020
           EXIT FOREACH
       END IF
       LET l_cnt1 = l_cnt1 + 1  #NO.MOD-5B0142 ADD
       LET g_max=1
       LET g_item=l_bma01
       LET g_bma01[1]=l_bma01,' ',l_bma06 #FUN-550093
       #NO.FUN-5B0142 START------
       #SELECT flag INTO l_flag
       #  FROM p611_tm1
       # WHERE bma01=l_bma01
       #   AND bma06=l_bma06 #FUN-5500903
       SELECT flag,bma01 INTO l_flag,l_bma01_t
         FROM p611_tm1
        WHERE bma01=l_bma01
          AND bma06=l_bma06 #FUN-5500903
       IF tm.t = 'Y' AND g_bgjob = "N" THEN   #No.FUN-570114
           MESSAGE l_bma01_t CLIPPED
       END IF
       #NO.FUN-5B0142 END--------
       IF l_flag='N' THEN      #若flag='N',表示此主件尚未展開
          CALL p611_bom(0,l_bma01,l_bma06) #FUN-550093
       END IF
#------No.FUN-5B0142 add
      #IF tm.t = 'N' AND g_bgjob = "N" THEN   #No.FUN-570114  #TQC-A30020
       IF tm.t = 'Y' AND g_bgjob = "N" THEN   #TQC-A30020
          IF l_sw_tot > 10 THEN  #筆數合計
             IF l_count = 10 AND l_cnt1 = l_sw_tot THEN
                 CALL cl_progressing(" ")
             END IF
             IF (l_cnt1 mod l_sw) = 0 AND l_count < 10 THEN  #分割完的倍數時才呼
                  CALL cl_progressing(" ")
                  LET l_count = l_count + 1
             END IF
          ELSE
              CALL cl_progressing(" ")
          END IF
       END IF
#------No.FUN-5B0142 end
 
     END FOREACH
 
    #DISPLAY "" AT 2,1
     FINISH REPORT p611_rep
     IF g_bgjob = 'N' THEN      #FUN-570114
        ERROR ""
     END IF
     IF g_err>0 THEN
         IF g_bgjob='N' THEN
             CALL cl_getmsg('mfg2642',g_lang) RETURNING g_msg
             #MESSAGE g_err USING '&&&& ', g_msg CLIPPED #No:8460  #NO.FUN-5B014
             #CALL ui.Interface.refresh() #NO.FUN-5B0142
             CALL cl_anykey('')
          # LET INT_FLAG = 0  ######add for prompt bug
          #  PROMPT g_err USING '&&&& ', g_msg CLIPPED  FOR g_chr
         END IF
         IF g_bgjob = 'N' THEN        #FUN-570114
            CALL cl_prt(l_name,g_prtway,g_copies,g_len)
         END  IF
     ELSE
        #LET l_cmd = "chmod 777 ", l_name #MOD-870061 mark
        #LET l_cmd = "chmod 777 ", l_name CLIPPED," 2>/dev/null"   #MOD-870061 
        #RUN l_cmd                        
         IF os.Path.chrwx(l_name CLIPPED, 511) THEN  #FUN-9B0113 7*64+7*8+7=511
         END IF

    #    IF g_bgjob='N' THEN
    #        CALL cl_getmsg('mfg2641',g_lang) RETURNING g_msg
    #       LET INT_FLAG = 0  ######add for prompt bug
    #        PROMPT g_msg CLIPPED FOR g_chr
    #           ON IDLE g_idle_seconds
    #              CALL cl_on_idle()
#   #               CONTINUE PROMPT
    #
    #        END PROMPT
    #    END IF
         IF g_bgjob = 'N' THEN
#             CALL cl_err(0,'mfg2641',1)
              CALL cl_err('','mfg2641',1) #NO.FUN-5B0142
#             MESSAGE g_msg CLIPPED #No:8460 #NO.FUN-5B0142 MARK
#             CALL ui.Interface.refresh()    #NO.FUN-5B0142 MARK
             CALL cl_anykey('')
         END IF
     END IF
    #DISPLAY "                    " AT 2,1
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
END FUNCTION

#CHI-C30056 str add------------------
FUNCTION p611_def_cur()
   DEFINE l_cmd    LIKE type_file.chr1000

   LET l_cmd=
       "SELECT bmb02,bmb03,bma01",
       " FROM bmb_file LEFT OUTER JOIN bma_file",
      #" ON bmb03 = bma01 AND bmaacti = 'Y' ",  #CHI-C50062 mark
       " ON bmb01 = bma01 AND bmaacti = 'Y' ",  #CHI-C50062 add
       " WHERE bmb01= ? AND bmb02 > ? ",
       " AND bmb29 = bma06",                    #CHI-C50062 add
       " AND bmb29 = ? ",
       " AND (bmb04 <= ? OR bmb04 IS NULL)",
       " AND (bmb05 > ? OR bmb05 IS NULL)",
       " order by bmb02 "
   PREPARE p611_ppp FROM l_cmd
   IF SQLCA.sqlcode THEN
      CALL cl_err('P1:',SQLCA.sqlcode,1)
      CALL cl_batch_bg_javamail('N')
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE p611_cur CURSOR FOR p611_ppp

END FUNCTION
#CHI-C30056 end add------------------
 
FUNCTION p611_bom(p_level,p_key,p_acode) #FUN-550093
   DEFINE p_level	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_key		LIKE bma_file.bma01,    #主件料件編號
          p_acode       LIKE bma_file.bma06,    #FUN-550093
          l_flag        LIKE type_file.chr1,    #是否執行過的旗標     #No.FUN-680096 VARCHAR(1)
          l_ac,i	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,    #No.FUN-680096 SMALLINT
	l_tot,l_times   LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          b_seq		LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          sr DYNAMIC ARRAY OF RECORD            #每階存放資料
              bmb02 LIKE bmb_file.bmb02,        #元件料號
              bmb03 LIKE bmb_file.bmb03,        #元件料號
               bma01 LIKE bma_file.bma01        #No.MOD-490217
          END RECORD,
          l_bmd04       LIKE bmd_file.bmd04,    #取代/替代料件編號
          l_bmd02       LIKE bmd_file.bmd02,    #取/替代類別
          l_cmd		LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(400)
          l_tmp         LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(61)
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015
  #CHI-C50062 str add-----
   DEFINE l_count     LIKE type_file.num5
   DEFINE l_flag2     LIKE type_file.num5
   DEFINE l_temp       DYNAMIC ARRAY OF RECORD
            bmd04  LIKE bmd_file.bmd04,
            bmd02  LIKE bmd_file.bmd02,
            ima910 LIKE ima_file.ima910
         END RECORD
  #CHI-C50062 end add----- 

# 	display p_level at 2,1
    LET p_level = p_level + 1
    IF p_level=1 THEN
        LET sr[1].bmb03 = p_key
    END IF
    LET arrno = 600
 
	LET l_times=1
 WHILE TRUE
   #CHI-C30056 str mark---------------------
   #LET l_cmd=
   #    "SELECT bmb02,bmb03,bma01",
   #    " FROM bmb_file LEFT OUTER JOIN bma_file",
   #    " ON bmb03 = bma01 AND bmaacti = 'Y' ",     #No:MOD-BC0192 modify
   #    " WHERE bmb01='", p_key,"' AND bmb02 >",b_seq,
   #    " AND bmb29 = '",p_acode,"'", #FUN-550093
   #  #------No.MOD-5B0270 add
   #    " AND (bmb04 <='",g_today,
   #    "' OR bmb04 IS NULL) AND (bmb05 >'",g_today,
   #    "' OR bmb05 IS NULL)",
   #  #------No.MOD-5B0270 end
   #   #" AND bmaacti = 'Y'",    #TQC-6A0044 add    #No:MOD-BC0192 mark
   #    " order by bmb02"
   #PREPARE p611_ppp FROM l_cmd
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err('P1:',SQLCA.sqlcode,1)
   #   CALL cl_batch_bg_javamail('N')                #No.FUN-570114
   #   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0060     #FUN-B30211
   #   EXIT PROGRAM
   #END IF
   #DECLARE p611_cur CURSOR FOR p611_ppp
   #CHI-C30056 end mark---------------------
#   WHILE TRUE
        LET l_ac = 1
        LET l_count = 0                         #CHI-C50062 add
       #FOREACH p611_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER                   #CHI-C30056 mark
        FOREACH p611_cur USING p_key,b_seq,p_acode,g_today,g_today INTO sr[l_ac].*        #CHI-C30056 add
        
            IF SQLCA.sqlcode THEN EXIT FOREACH END IF
            #FUN-8B0015--BEGIN--                                                                                                     
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            #FUN-8B0015--END-- 
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
            IF l_ac > arrno THEN EXIT FOREACH END IF
		let g_tot=g_tot+1
                #message g_tot #NO.FUN-5B0142 MARK
                #CALL ui.Interface.refresh()  #NO.FUN-5B0142 MARK
         END FOREACH
	let l_tot=l_ac-1
         FOR i = 1 TO l_tot 			# 讀BUFFER傳給REPORT
{
            IF g_bgjob='N' THEN
                MESSAGE "COMPONENT:",p_key CLIPPED,
                    "-",sr[i].bmb02 USING '&&&&',
                    "-",sr[i].bmb03
                CALL ui.Interface.refresh()
            END IF
}
                LET g_tot2=g_tot2+1
#		message '<',l_times,'> ',i
#               CALL ui.Interface.refresh()
#檢查看看是否在低階元件中有高階主件產生
            FOR g_cnt=1 TO g_max
            #FUN-550093................begin
            #   IF sr[i].bmb03 = g_bma01[g_cnt] THEN
                LET l_tmp=sr[i].bmb03,' ',p_acode
                IF l_tmp = g_bma01[g_cnt] THEN
            #FUN-550093................end
            LET INT_FLAG = 0  ######add for prompt bug
#                   PROMPT 'ERROR:',sr[i].bmb03 CLIPPED FOR g_chr
                    LET sr[i].bma01=p_key
                    OUTPUT TO REPORT p611_rep(p_level,'0',sr[i].*,p_acode) #FUN-550093
                    LET sr[i].bma01='' #讓它不會繼續往下走無窮的迴路
                    LET g_err=g_err+1
                    EXIT FOR
                END IF
            END FOR
#檢查取替/ 取代元件是否有誤
            LET INT_FLAG = 0  ######add for prompt bug
#           PROMPT SQLCA.sqlcode,'-',sqlca.sqlerrd[3] USING '&&&&' for g_chr
#           LET g_bmd01=sr[i].bmb03
            FOREACH p611_cbmd
           #USING sr[i].bmb03            #CHI-C50062 mark
            USING sr[i].bmb03 , p_key    #CHI-C50062 add
            INTO l_bmd02,l_bmd04
                IF SQLCA.sqlcode THEN EXIT FOREACH END IF
#                IF g_bgjob='N' THEN
#                    MESSAGE "UTE/SUB:",l_bmd04
#                    CALL ui.Interface.refresh()
#                END IF
                FOR g_cnt=1 TO g_max
                    #FUN-550011................begin
                   #IF l_bmd04 = g_bma01[g_cnt] THEN
                    LET l_tmp = l_bmd04,' ',p_acode
                    IF l_tmp = g_bma01[g_cnt] THEN
                    #FUN-550011................end
                        OUTPUT TO REPORT p611_rep(p_level,l_bmd02,
                            sr[i].bmb02,l_bmd04,sr[i].bmb03,p_acode) #FUN-550093
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

            CALL p611_chksub(l_temp,p_level,l_count) RETURNING l_flag2  #CHI-C50062 add
            IF l_flag2 = 0 THEN   CONTINUE FOR END IF                   #CHI-C50062 add

#是否尚有下階
            IF sr[i].bma01 IS NOT NULL THEN        #表示尚有下階
                LET g_max=g_max+1
#判斷階數是否超過20階
                IF g_max > 20 THEN
                    OUTPUT TO REPORT p611_rep(101,i,sr[i].*,p_acode) #FUN-550093
                    EXIT FOR
                END IF
                LET g_bma01[g_max]=sr[i].bma01,' ',p_acode     #將主件之料號存到ARRAY #FUN-550093
               #CALL p611_bom(p_level,sr[i].bmb03,' ') #FUN-550093 #FUN-8B0015
                CALL p611_bom(p_level,sr[i].bmb03,l_ima910[i]) #FUN-8B0015
                UPDATE p611_tm1  #將TEMP TABLE內,已展開的主件之flag設為'Y'
                   SET flag='Y' WHERE bma01=sr[i].bmb03
                                  AND bma06=p_acode #FUN-550093
            END IF
        END FOR
        IF l_tot < arrno OR l_tot=0 THEN                 # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[l_tot].bmb02
		LET l_times=l_times+1
        END IF
    END WHILE
    LET g_max=g_max-1
    IF g_max < 0 THEN LET g_max=0 END IF    #CHI-C50062 add
END FUNCTION
 
#CHI-C50062 str add------
FUNCTION p611_chksub(l_temp,p_level,l_count)
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
          CALL p611_bom(p_level-1,l_temp[i].bmd04,l_temp[i].ima910)
       END IF
    END FOR

    RETURN l_fflag

END FUNCTION
#CHI-C50062 end add------

REPORT p611_rep(p_level,p_i,sr,p_acode) #FUN-550093
   DEFINE l_last_sw	LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
          p_key		LIKE bma_file.bma01,   #主件料件編號
          p_acode       LIKE bma_file.bma06,   #FUN-550093
          p_level	LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          p_i           LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
          sr  RECORD
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
               bma01 LIKE bma_file.bma01    #No.MOD-490217
          END RECORD,
          l_now        LIKE type_file.num5     #No.FUN-680096 SMALLINT
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
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[36],g_x[35] #FUN-550093
      PRINT g_dash1
      LET l_last_sw = 'n'
 
    ON EVERY ROW
       IF p_level=101 THEN
           CALL cl_getmsg('mfg2643',g_lang) RETURNING g_msg
           PRINT g_msg CLIPPED
       ELSE
           PRINT COLUMN g_c[31],g_item,
                 COLUMN g_c[32],p_level USING '###&',
                 COLUMN g_c[33],sr.bmb03,
                 COLUMN g_c[34],sr.bma01,
                 COLUMN g_c[36],p_acode; #FUN-550093
           IF p_i='1' THEN
               PRINT COLUMN g_c[35],'UTE'
           ELSE
               IF p_i='2' THEN
                   PRINT COLUMN g_c[35],'SUB'
               ELSE
                   PRINT COLUMN g_c[35],' '
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
