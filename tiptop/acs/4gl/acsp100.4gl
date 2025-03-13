# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: acsp100.4gl
# Descriptions...: single-part-cost roll up-standard cost
# Date & Author..: 92/01/18 By pin
# Modify.........: 92/02/22 By pin
# Modify.........: 92/07/22 By pin
# Modify.........: 92/07/30 By pin
#                  a.'NULL' INITIALIZE TO ZERO
#                   - 將數值欄位如果為 NULL, 則清為 0.
#                  b.FREE STOCK 處理
#                  c.ADD VALUE 處理
#                   -若不將人工/製費清空, 則直接將料件成本要素及成本項目
#                    結構複製過來, 因此, 毋需再產生附加成本部份.
#                  d.成本項目處理
#                   - 若使用成本中心計算其成本,且亦使用成本項目結構時,將
#                     廠外加工成本/廠外加工固定/變動製造費用之成本相加,
#                     彙集至成本項目編號 "UNKNOW"==>為了成本要素與成本
#                     項目值能BALANCE.
#                   - 若使用成本項目結構, 該成本項目為 "NULL" 時,
#                     彙集至成本項目編號 "NULL"==>為了成本要素與成本
#                     項目值能BALANCE.
#                  e.是否考慮損耗率[Y/N]
#                   -算成本時檢查是否需考慮損耗率
#                  f.若在料件成本要素未打採購成本, 則沿用下階所捲算之材
#                    料成本,否則使用採購成本,並且不將下階之人工/製費捲
#                    算至上階.
# Release 4.0....: 92/07/31 By Jones
#-----------------------------------------------------------------------
# modify(93/04/21):系統shutdown 處理
#                  加二欄位(1.目前版本是否正使用中) (2.執行環境)
# Modify.........: No.FUN-550100 05/05/25 By ching 特性BOM功能修改
# Modify.........: No.MOD-580325 05/08/29 By day  將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.FUN-570142 06/03/01 By yiting 批次背景執行
# Modify.........: No.FUN-660089 06/06/16 By cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680071 06/09/08 By chen 類型轉換
# Modify.........: No.FUN-6A0064 06/10/27 By king l_time轉g_time
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.FUN-980002 09/08/06 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B80022 11/08/03 By fanbj          未加離開前得cl_used(2)

DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD			     	# Print condition RECORD
              item_no    LIKE ima_file.ima01,    #No.FUN-680071 VARCHAR(20)      # item no.
              version    LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)      # simulation version.
              x          LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)      # execute environment
              rout       LIKE type_file.num5,    #No.FUN-680071 SMALLINT      # routing no.
              effectiv   LIKE type_file.dat,     #No.FUN-680071 DATE          # effective date.
	      free_stock LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)      # cost roll up including free
				         	 # stock and 'miscellaneous' part.
	      m_pur      LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)      # cost roll up make part use
					         # purchasing cost instead of
					         # manufacturing cost  (Y/N)
	      p_mak      LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)      # cost roll up purchase part
				        	 # use manufacturing cost instead
					         # of purchasing cost  (Y/N)
	  lab_bud        LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)      # zero the labor and burden cost
					         # of the purchase part and
					         # miscellaneous part  (Y/N)
          e              LIKE type_file.chr1,      # Prog. Version..: '5.30.06-13.03.12(01)      # including scrap rate [Y/N)
	  f              LIKE type_file.chr1,      # Prog. Version..: '5.30.06-13.03.12(01)      # variable report print flag
	  h              LIKE type_file.chr1000    #No.FUN-680071 VARCHAR(50)       # simulation version  description.
              END RECORD,
          l_ima08   LIKE ima_file.ima08,# part's source code.
          p_time    LIKE type_file.chr8,    #No.FUN-680071 VARCHAR(08)
          l_chr     LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(1)
          l_msg     LIKE ze_file.ze03,      #No.FUN-680071 VARCHAR(50)
          l_cmd     LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(70)
          l_lock    LIKE type_file.num5,    #No.FUN-680071 smallint
          l_n       LIKE type_file.num5     #No.FUN-680071 SMALLINT
DEFINE   g_change_lang   LIKE type_file.chr1      #No.FUN-680071 VARCHAR(1)         #No.FUN-570142
DEFINE   g_msg           LIKE type_file.chr1000   #No.FUN-680071 VARCHAR(72)

MAIN
    DEFINE   l_flag        LIKE type_file.chr1       #No.FUN-570142  #No.FUN-680071 VARCHAR(1)
    DEFINE   ls_date  STRING           #No.FUN-570142
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
  #No.FUN-570142--start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.item_no     = ARG_VAL(1)
   LET tm.version     = ARG_VAL(2)
   LET tm.x           = ARG_VAL(3)
   LET tm.rout        = ARG_VAL(4)
   LET ls_date        = ARG_VAL(5)
   LET tm.effectiv = cl_batch_bg_date_convert(ls_date)
   LET tm.free_stock  = ARG_VAL(6)
   LET tm.m_pur       = ARG_VAL(7)
   LET tm.p_mak       = ARG_VAL(8)
   LET tm.lab_bud     = ARG_VAL(9)
   LET tm.e           = ARG_VAL(10)
   LET tm.f           = ARG_VAL(11)
   LET tm.h           = ARG_VAL(12)
   LET g_bgjob= ARG_VAL(13)
   IF cl_null(g_bgjob)THEN
       LET g_bgjob="N"
   END IF
  #No.FUN-570142--end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACS")) THEN
      EXIT PROGRAM
   END IF
 
   IF s_shut(0) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

    WHILE TRUE
    IF g_bgjob="N" THEN
       CALL p100_tm()
       IF NOT cl_sure(17,23) THEN      # if not execute then continue
          CONTINUE WHILE               # input next part to execute
       END IF
       IF g_sma.sma24 MATCHES '[Yy]' THEN
          CALL cl_getmsg('mfg6015',g_lang) RETURNING l_msg
          IF NOT cl_prompt(0,0,l_msg) THEN
             CLOSE WINDOW p100_w
             EXIT WHILE
          END IF
       END IF
       CALL cl_wait()
       LET g_success='Y'
       BEGIN WORK
       CALL p100_cur()
       IF g_success='Y' THEN
          COMMIT WORK
          CALL cl_end2(1) RETURNING l_flag
       ELSE
          ROLLBACK WORK
          CALL cl_end2(2) RETURNING l_flag
       END IF
       IF l_flag THEN
          CONTINUE WHILE
       ELSE
          CLOSE WINDOW p100_w
          EXIT WHILE
       END IF
    ELSE
      LET g_success='Y'
      BEGIN WORK
      CALL p100_cur()
      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
        ROLLBACK WORK
      END IF
          CALL cl_batch_bg_javamail(g_success)
          EXIT WHILE
    END IF
  END WHILE

  CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#NO.FUN-570142 START------
FUNCTION p100_tm()
 
  DEFINE lc_cmd        LIKE type_file.chr1000    #No.FUN-680071 VARCHAR(500) #No.FUN-570142
 
   OPEN WINDOW acsp100_w WITH FORM "acs/42f/acsp100"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   WHILE TRUE                           # use while loop ,can execute
                                        # one more time
      LET tm.version     = '0'            # default simulation version "0"
      LET tm.x           = '2'            # default execute enveronment "2"
      LET tm.effectiv    = g_today        # default effective date system date
      LET tm.rout        = 1              # default main route no.
      LET tm.free_stock  = 'Y'            # default including free_stock "Yes"
      LET tm.m_pur       = 'N'            # default make use purchase "No"
      LET tm.p_mak       = 'N'            # default purchase use make "No"
      LET tm.lab_bud     = 'Y'            # default zero labor/burder "Yes"
   #  LET tm.p_cost      = 'N'            # default purchase use least price "No"
      LET tm.e           = 'Y'            # default including srcap rate "Yes"
      LET tm.f           = 'N'            # default print variable report "No "
      LET g_bgjob       = 'N'  #NO.FUN-570142 ADD
 
      #INPUT BY NAME tm.* WITHOUT DEFAULTS  #input condition
      INPUT BY NAME tm.*,g_bgjob WITHOUT DEFAULTS  #input condition
 
       ON ACTION locale
         # CALL cl_dynamic_locale()                 #No.FUN-570142
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           LET g_change_lang=TRUE        #No.FUN-570142
           EXIT INPUT                    #No.FUN-570142
 
         AFTER FIELD  item_no    #item no, must input
            IF cl_null(tm.item_no) THEN
               NEXT FIELD item_no
            END IF
            SELECT ima08 INTO l_ima08
              FROM ima_file    #check 是否存在料件主檔
             WHERE ima01= tm.item_no
               AND imaacti IN ('Y','y')
            IF SQLCA.sqlcode !=0 THEN                 #不存在, 重輸
#              CALL cl_err(tm.item_no,'mfg0002',0)   #No.FUN-660089
               CALL cl_err3("sel","ima_file",tm.item_no,"","mfg0002","","",0)     #No.FUN-660089
               NEXT FIELD item_no
            ELSE
               IF l_ima08 IS NULL OR l_ima08 MATCHES '[CcAaDdPpWwZzVv]' THEN
                  CALL cl_err(tm.item_no,'mfg6004',0)   
                  NEXT FIELD item_no
               END IF
            END IF
         AFTER FIELD version             #simulation version
            IF cl_null(tm.version) THEN
               NEXT FIELD version
            ELSE
               IF tm.version NOT MATCHES '[0-9]' THEN
                  CALL cl_err(tm.version,'mfg6005',0)
                  NEXT FIELD version
               END IF
            END IF
            #**************************************************************#
            #---> The version is running ?
            SELECT csc01 FROM csc_file WHERE csc01 =tm.version AND csc14 IN ('Y','y')
            IF SQLCA.SQLCODE=0 THEN
#              CALL cl_err(tm.version,'mfg9181',0)   #No.FUN-660089
               CALL cl_err3("sel","csc_file",tm.version,"","mfg9181","","",0)     #No.FUN-660089
               NEXT FIELD version
            END IF
           #---> The  execute environment setup ?
            SELECT COUNT(*) INTO l_n FROM csc_file WHERE csc14 IN ('y','Y') AND csc15 ='2'
            IF l_n >0 THEN
               CALL cl_getmsg('mfg9182',g_lang) RETURNING g_msg
               CALL cl_msgany(0,0,g_msg)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
            END IF
 
         AFTER FIELD x                   #execute environment
            IF cl_null(tm.x) OR tm.x NOT MATCHES '[12]' THEN
               NEXT FIELD x
            END IF
 
         AFTER FIELD rout                #routing no.
            IF cl_null(tm.rout) THEN
               NEXT FIELD rout
            END IF
 
         AFTER FIELD effectiv            #effective date
            IF cl_null(tm.effectiv) THEN
               NEXT FIELD effectiv
            END IF
 
         AFTER FIELD free_stock          #including free stock part
            IF cl_null(tm.free_stock) THEN
               NEXT FIELD free_stock
            ELSE
               IF tm.free_stock NOT MATCHES '[YyNn]' THEN
                  NEXT FIELD free_stock
               END IF
            END IF
          		
         AFTER FIELD m_pur              #make part use purchase cost
            IF cl_null(tm.m_pur) THEN
               NEXT FIELD m_pur
            ELSE
               IF tm.m_pur NOT MATCHES '[YyNn]' THEN
                  NEXT FIELD m_pur
               END IF
            END IF
 
         AFTER FIELD p_mak             #purchase part use make cost
            IF cl_null(tm.p_mak) THEN
               NEXT FIELD p_mak
            ELSE
               IF tm.p_mak NOT MATCHES '[YyNn]' THEN
                  NEXT FIELD p_mak
               END IF
            END IF
 
         AFTER FIELD lab_bud          #zero labor/burden
            IF cl_null(tm.lab_bud) THEN
               NEXT FIELD lab_bud
            ELSE
               IF tm.lab_bud NOT MATCHES '[YyNn]' THEN
                  NEXT FIELD lab_bud
               END IF
            END IF
{
         AFTER FIELD p_cost          #use nearest list price
            IF tm.p_cost IS NULL OR tm.p_cost = ' ' THEN
               NEXT FIELD p_cost
            ELSE
               IF tm.p_cost NOT MATCHES '[YyNn]' THEN
                  NEXT FIELD p_cost
               END IF
            END IF
 
}
         AFTER FIELD e               #including scrap rate
            IF cl_null(tm.e) THEN
               NEXT FIELD e
            ELSE
               IF tm.e NOT MATCHES '[YyNn]' THEN
                  NEXT FIELD e
               END IF
            END IF
 
         AFTER FIELD f               #variable report list
            IF cl_null(tm.f) THEN
               NEXT FIELD f
            ELSE
               IF tm.f NOT MATCHES '[YyNn]' THEN
                  NEXT FIELD f
               END IF
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
      IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #No.FUN-550037 hmf
      END IF
 
      IF INT_FLAG THEN                          #when user press interrupt key
         LET INT_FLAG=0               #int_flat recover and exit
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM                 # program
      END IF
 
    IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "acsp100"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('acsp100','9031',1)    
        ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                   " '",tm.item_no CLIPPED,"'",
                   " '",tm.version CLIPPED,"'",
                   " '",tm.x CLIPPED,"'",
                   " '",tm.rout CLIPPED,"'",
                   " '",tm.effectiv CLIPPED,"'",
                   " '",tm.free_stock CLIPPED,"'",
                   " '",tm.m_pur CLIPPED,"'",
                   " '",tm.p_mak CLIPPED,"'",
                   " '",tm.lab_bud CLIPPED,"'",
                   " '",tm.e CLIPPED,"'",
                   " '",tm.f CLIPPED,"'",
                   " '",tm.h CLIPPED,"'",
                   " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('acsp100',g_time,lc_cmd CLIPPED)
       END IF
         CLOSE WINDOW p100_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
     END IF
   #No.FUN-570142--end---
     EXIT WHILE
 END WHILE
 
END FUNCTION
#No.FUN-570142--end---
 
#No.FUN-570142--start---
FUNCTION p100_cur()
 
  WHILE TRUE
            LET INT_FLAG = 0  ######add for prompt bug
#     prompt 'input lab/burden 計算方式(1/2/3):' for l_chr
#     let g_sma.sma23=l_chr
      IF NOT cl_sure(17,23) THEN                # if not execute then continue
         CONTINUE WHILE               # input next part to execute
      END IF
      IF g_sma.sma24 MATCHES '[Yy]' THEN
         CALL cl_getmsg('mfg6015',g_lang) RETURNING l_msg
         IF NOT cl_prompt(0,0,l_msg) THEN
            EXIT WHILE
         END IF
      END IF
      CALL cl_wait()
      IF tm.x='2' THEN #不允許別人使用時,將系統 shutdown,且lock 相關檔案
         CALL p100_lock2() returning l_lock  #將系統shutdown
         IF l_lock THEN
            CALL cl_err(' ','mfg6027',0)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time     # FUN-B80022
            exit program
         END IF
         IF p100_waitlock() THEN
            CALL p100_unlock2()
            EXIT WHILE
         END IF
      END IF
      CALL p100_tmp()
      CALL insert_csc()
      CALL cost_roll_up()
      IF tm.x='2' THEN #不允許別人使用時,將系統 還原
         CALL p100_unlock2()                 #UNLOCK
      END IF
      DELETE FROM csa_file WHERE csa02='#'
      DELETE FROM csb_file WHERE csb02='#'
      DELETE FROM csc_file WHERE csc01='#'
      UPDATE csc_file SET csc14='N' WHERE csc01=tm.version
 
      IF tm.f MATCHES '[Yy]' THEN
         CALL p100_prt()
      END IF
      ERROR ''
      IF NOT cl_cont(17,23) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
#NO.FUN-570142 END----------
 
#--->列印差異報表
FUNCTION p100_prt()
 
    OPEN WINDOW p100_prt AT 17,09 WITH 4 ROWS, 50 COLUMNS
                    					
    WHILE TRUE
     CALL cl_getmsg('mfg6022',g_lang) RETURNING l_msg
    #DISPLAY l_msg at 1,1       #CHI-A70049 mark
     CALL cl_getmsg('mfg6023',g_lang) RETURNING l_msg
    #DISPLAY l_msg at 2,1       #CHI-A70049 mark
     CALL cl_getmsg('mfg6024',g_lang) RETURNING l_msg
    #DISPLAY l_msg at 3,1       #CHI-A70049 mark
     CALL cl_getmsg('mfg6025',g_lang) RETURNING l_msg
            LET INT_FLAG = 0  ######add for prompt bug
     IF g_bgjob="N"  THEN        #NO.FUN-570142
         PROMPT l_msg  clipped  FOR l_chr
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
#           CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
     END PROMPT
     END IF
     IF int_flag THEN LET int_flag = 0 EXIT WHILE END IF
     CASE l_chr
          WHEN '1'
               LET l_cmd="acsr302", " '",g_today clipped,"' ",
                                    " '",g_user  clipped,"' ",
                                    " '",g_lang  clipped,"' "," 'Y' ",
                                        " ' ' "," '1'",
                                        " '1=1' ",
                                    " '",tm.version clipped,"'"
               CALL cl_cmdrun(l_cmd)
          WHEN '2'
               LET l_cmd="acsr303", " '",g_today clipped,"' ",
                                    " '",g_user  clipped,"' ",
                                    " '",g_lang  clipped,"' "," 'Y' ",
                                        " ' ' "," '1'",
                                        " '1=1' ",
                                    " '",tm.version clipped,"'"
               CALL cl_cmdrun(l_cmd)
          OTHERWISE EXIT CASE
     END CASE
    END WHILE
     CLOSE WINDOW p100_prt
END FUNCTION
 
 
FUNCTION p100_lock2()
  DEFINE  l_st    LIKE type_file.chr1      #No.FUN-680071 VARCHAR(01)
{
	UPDATE sma_file
		SET sma01='N'
		WHERE sma00='0'
	IF SQLCA.SQLERRD[3]=0 THEN CALL cl_err('','mfg6026',0) RETURN 1 END IF
	RETURN 0
}
   CALL s_psdm('acsp100',tm.version) RETURNING l_st
   IF l_st ='Y' THEN
        RETURN 0
   ELSE RETURN 1
   END IF
END FUNCTION
 
#============================================================#
#  在執行後, 不允許其他人同時更新資料庫時, 將資料庫重新開放  #
#============================================================#
FUNCTION p100_unlock2()
 DEFINE  l_st    LIKE type_file.chr1      #No.FUN-680071 VARCHAR(01)
 
    CALL p100_unwaitlock()
{
	UPDATE sma_file
		SET sma01='Y'
		WHERE sma00='0'
}
    CALL s_prsm()
END FUNCTION
 
#--->不允許別人使用時,除了將系統shutdown外,
#    還需檢查是否有人在執行中....
#============================================================
#   執行環境為不允許其它使用者同時使用時，將相關檔案皆鎖住
#============================================================
 
FUNCTION p100_waitlock()
   DEFINE l_no,p_no      LIKE type_file.num10     #No.FUN-680071 integer
 
   LET p_no=0
   LET l_no=0
#---->#參數檔
  IF s_locktab('sma_file','系統參數檔(sma_file)') THEN RETURN 1 END IF
 
#---->#料件主檔
  IF s_locktab('ima_file','料件主檔(ima_file)')  THEN RETURN 1 END IF
 
#---->#BOM 單頭檔
  IF s_locktab('bma_file','BOM 單頭檔(bma_file)') THEN RETURN 1 END IF
 
#---->#BOM 單身檔
  IF s_locktab('bmb_file','BOM 單身檔(bmb_file)') THEN RETURN 1 END IF
 
#---->#料件成本要素模擬檔
  IF s_locktab('csa_file','料件成本要素模擬檔(csa_file)') THEN RETURN 1 END IF
 
#---->#料件成本項目模擬檔
  IF s_locktab('csb_file','料件成本項目模擬檔(csb_file)') THEN RETURN 1 END IF
 
#---->#成本模代號主檔
  IF s_locktab('csc_file','料件成本項目模擬檔(csb_file)') THEN RETURN 1 END IF
 
IF g_sma.sma23 MATCHES '[13]' THEN
#---->#工作站主檔
  IF s_locktab('eca_file','工作站主檔(eca_file)') THEN RETURN 1 END IF
#---->#製程主檔
  IF s_locktab('ecb_file','製程主檔(ecb_file)') THEN  RETURN 1 END IF
END IF
 
#---->#成本中心主檔
IF g_sma.sma23 !='2' THEN
  IF  s_locktab('smh_file','成本中心檔(smh_file)') THEN RETURN 1 END IF
END IF
 
IF g_sma.sma58 MATCHES '[yY]' THEN
  IF s_locktab('csd_file','料件附加成本檔(csd_file)') THEN RETURN 1 END IF
  IF s_locktab('cse_file','料件附加成本項目檔(cse_file)') THEN RETURN 1
  END IF
#---->#料件成本項目檔
  IF s_locktab('iml_file','料件成本項目檔(iml_file)') THEN RETURN 1 END IF
END IF
#---->#料件成本要素檔
  IF s_locktab('imb_file','料件成本要素檔(imb_file)') THEN RETURN 1 END IF
 
RETURN 0
 
END FUNCTION
 
#============================================================
#  成 本 捲 算 作 業 結 束 ，則 鎖 住 的 檔 案 釋 放 回 去
#============================================================
FUNCTION p100_unwaitlock()
 
  UNLOCK TABLE sma_file
  UNLOCK TABLE ima_file
  UNLOCK TABLE bma_file
  UNLOCK TABLE bmb_file
  UNLOCK TABLE csa_file
  UNLOCK TABLE csb_file
  UNLOCK TABLE csc_file
  UNLOCK TABLE imb_file
  IF g_sma.sma23 MATCHES '[13]'
     THEN UNLOCK TABLE eca_file
          UNLOCK TABLE ecb_file
  END IF
  IF g_sma.sma23 ='2'
     THEN UNLOCK TABLE smh_file
  END IF
  IF g_sma.sma58 MATCHES '[yY]'
     THEN UNLOCK TABLE csd_file
          UNLOCK TABLE cse_file
          UNLOCK TABLE iml_file
  END IF
END FUNCTION
 #--->將模擬前之模擬版本資料做備份, 以便restore回來
 FUNCTION p100_tmp()
 
   DELETE FROM csa_file WHERE csa02='#'
   DELETE FROM csb_file WHERE csb02='#'
   DELETE FROM csc_file WHERE csc01='#'
   UPDATE csa_file SET csa02='#'
          WHERE csa02= tm.version #模擬版本
   IF SQLCA.sqlcode !=0 THEN ERROR SQLCA.sqlcode END IF
   UPDATE csb_file SET csb02='#'
          WHERE csb02= tm.version #模擬版本
   IF SQLCA.sqlcode !=0 THEN ERROR SQLCA.sqlcode END IF
   UPDATE csc_file SET csc01='#'
          WHERE csc01= tm.version #模擬版本
   IF SQLCA.sqlcode !=0 THEN ERROR SQLCA.sqlcode  END IF
 
 END FUNCTION
 
#--->模擬不成功時, 將資料restore回來
 FUNCTION p100_restore()
 
#將模擬不成功之殘值清除掉
   DELETE FROM csa_file WHERE csa02= tm.version
   DELETE FROM csb_file WHERE csb02= tm.version
   DELETE FROM csc_file WHERE csc01= tm.version
 
#將原資料restore 回來
   UPDATE csa_file SET csa02=tm.version
          WHERE csa02= '#' #模擬版本
   IF SQLCA.sqlcode !=0 THEN ERROR SQLCA.sqlcode END IF
   UPDATE csb_file SET csb02=tm.version
          WHERE csb02= '#' #模擬版本
   IF SQLCA.sqlcode !=0 THEN ERROR SQLCA.sqlcode END IF
   UPDATE csc_file SET csc01= tm.version
          WHERE csc01= '#' #模擬版本
   IF SQLCA.sqlcode !=0 THEN ERROR SQLCA.sqlcode  END IF
 
END FUNCTION
 
 
#-----●●●● 程式處理邏輯●●●● -------(1992/01/22 by pin)
#     1.開始時,將未模擬之前資料備份,以備擬不成功時restore 回來
#     2.為單一料件成本逆算
#     2.開始以此料件做ｂｏｍ展開
#     3.ｂｏｍ展開過程中,計算各料件的上/下階各成本要數
#     4.產生每料件成本要素模擬資料檔, 料件成本項目檔, 料件成本項目結構檔
 
FUNCTION cost_roll_up()
   DEFINE g_material     LIKE type_file.num20_6,   #No.FUN-680071 decimal(20,6)
          g_labor_cost   LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)      #labor cost
          g_ind_labor    LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)      #indirect labor cost
		  g_fix_bud      LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)      #fixed burden cost
		  g_var_bud      LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)      #variable burden cost
		  g_outside_cost LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)      #outside process cost
		  g_out_fix_bud  LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)      #outside process fixed burden cost
		  g_out_var_bud  LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)      #outside process varia.burden cost
		  g_mac_cost     LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)     #machine cost
		  g_add_val      LIKE type_file.chr1,      #No.FUN-680071 DECIMAL(20,6)     #add values
		  l_ima871   LIKE ima_file.ima871,
       s_aa RECORD
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb07 LIKE bmb_file.bmb07,    #底數
              bmb08 LIKE bmb_file.bmb08,    #scrap rate
              bmb10_fac2 LIKE bmb_file.bmb10_fac2, #發料/成本換算率
              bma01 LIKE bma_file.bma01,    #No.FUN-680120 VARCHAR(20)               #assembly part
              ima08 LIKE ima_file.ima08,    #來源
              ima53 LIKE ima_file.ima53,    #最近採購單價(本幣)
              ima87 LIKE ima_file.ima87,    #材料成本項目
              ima871 LIKE ima_file.ima871,  #材料製造費用分攤率
              ima872 LIKE ima_file.ima872,  #材料製造費用成本項目
              ima44 LIKE ima_file.ima44,    #採購單位
              ima86 LIKE ima_file.ima86,    #成本單位
              ima34 LIKE ima_file.ima34,    #成本中心
              ima58 LIKE ima_file.ima58,    #最後人工工時
              ima873 LIKE ima_file.ima873,  #人工製/費用分攤率
              ima874 LIKE ima_file.ima874,  #人工製/費用成本項目
              imb111 LIKE imb_file.imb111,  #本階材料成本
              imb118 LIKE imb_file.imb118,  #採購成本
              imb116 LIKE imb_file.imb116,  #廠外加工成本
              imb1171 LIKE imb_file.imb1171,  #廠外加工固定製費
              imb1172 LIKE imb_file.imb1172   #廠外加工變動製費
          END RECORD,
          l_ind_m     LIKE type_file.num20_6,        #No.FUN-680071 DECIMAL(20,6)
          g_ind_m     LIKE type_file.num20_6,        #No.FUN-680071 DECIMAL(20,6)
          d1,d2,d3,d4,d5,d6,d7,d8,d9,d10  LIKE type_file.num20_6,        #No.FUN-680071 DECIMAL(20,6)
          l_n  LIKE type_file.num5,    #No.FUN-680071 SMALLINT
	     pur_cost, l_add_val     LIKE type_file.num20_6        #No.FUN-680071 DECIMAL(20,6)
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550100
 
   #FUN-550100
   LET l_ima910=''
   SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=tm.item_no
   IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
   #--
 
  #CALL p100_tmp()
 
#---->處理來源碼非P/V/W/Z/A 無產品結構料件成本逆算,假設其來源碼有誤
  SELECT ' ',' ',1,1,0,0,' ',
         ima08,ima53,ima87,ima871,ima872,ima44,ima86,ima34,
         ima58,ima873,ima874,imb111,imb118,imb116,imb1171,imb1172
    INTO s_aa.* FROM ima_file LEFT JOIN imb_file ON ima01=imb_file.imb01
   WHERE ima01= tm.item_no  #主件編號
 IF SQLCA.sqlcode !=0 THEN initialize s_aa.* TO NULL END IF
 LET s_aa.bmb03=tm.item_no
 IF s_aa.ima08 NOT MATCHES '[PpVvWwZz]' THEN   #檢查其是否有產品結構
     SELECT count(*) into l_n FROM bmb_file
      WHERE bmb01 = s_aa.bmb03    #料件編號
        AND bmb29 = l_ima910      #FUN-550100
        and (bmb04 <=tm.effectiv or bmb04 is null) #生效日控制
        and (bmb05 > tm.effectiv or bmb05 is null)
     IF l_n=0 THEN
        CALL cl_getmsg('mfg6018',g_lang) RETURNING l_msg
        IF not cl_prompt(0,0,l_msg) THEN
               CALL p100_restore()
               CALL p100_unlock2()                 #UNLOCK
               CALL cl_batch_bg_javamail("N")      #NO.FUN-570142
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
        ELSE CALL p100_pvwz('P',s_aa.ima44,s_aa.ima86, #以最下階計算
                           s_aa.bmb03,s_aa.ima53,s_aa.imb118,s_aa.imb111,
                           s_aa.ima872,s_aa.ima871,s_aa.ima87)
                 returning pur_cost, l_add_val,l_ind_m
        END IF
     ELSE    #------為一般自製料-------#
        CALL acsp100_bom(0,tm.item_no,l_ima910) #FUN-550100 #level,item no.
        RETURNING g_material,               #下階材料成本
                  g_labor_cost,  g_ind_labor,             #及下階人工/製費
                  g_fix_bud   ,  g_var_bud,
                  g_outside_cost,g_out_fix_bud,
                  g_out_var_bud, g_mac_cost,
                  g_add_val    , g_ind_m
        CALL s_in_csa(tm.item_no,     #料件編號
     	         s_aa.ima871,    #indirect material factor
     		 g_material,     #下階material cost
     		 '1',            #standard cost
     		  0,             #採購成本(P/V)
     	  	  0,             #本階材料成本(W/Z)
     		  s_aa.ima872,   #間接材料成本項目
     		  0,             #本階間接材料成本
                  0,             #附加成本
                  tm.version)    #simulation version.
 
        IF g_sma.sma58 MATCHES '[Yy]' THEN
           CALL insert_cote2(tm.item_no,'1')   #複製下階成本項目資料
        END IF
{
        CALL lab_burden(s_aa.*,g_material)
             RETURNING  d1,             #本階labor cost
     		   d2,             #本階indirect labor cost
     		   d3,             #本階fixed burder cost
     		   d4,             #本階variable burder cost
                        d5,             #本階outside process cost
     		   d6,             #本階outside fixed burden
     		   d7,             #    outside variable burden
     		   d8,             #    machine cost
                        d9,             #    add values
		           d10             #    indirect material cost
}
#--->更新料件上/下階成本要素
           CALL lb_bd_update(s_aa.bmb03,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,
                          g_labor_cost,g_ind_labor,g_fix_bud,g_var_bud,
                          g_outside_cost,g_out_fix_bud,g_out_var_bud,
                          g_mac_cost,g_add_val,g_ind_m)
 
 
      END IF
   END IF
END FUNCTION
 
FUNCTION acsp100_bom(p_level,p_key,p_key2)  #FUN-550100
   DEFINE p_level 	LIKE type_file.num5,      #No.FUN-680071 SMALLINT
          p_key		LIKE bma_file.bma01,  #主件料件編號
          p_key2	LIKE ima_file.ima910,   #FUN-550100
          l_ac,i	LIKE type_file.num5,    #No.FUN-680071 SMALLINT
          arrno		LIKE type_file.num5,      #No.FUN-680071 SMALLINT	          #BUFFER SIZE (可存筆數)
          b_seq		LIKE type_file.num5,      #No.FUN-680071 SMALLINT             #當BUFFER滿時,重新讀單身之起始序號
          pur_cost  LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)        #採購成本
          g_cost    LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
          t_cost    LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
          sr DYNAMIC ARRAY OF RECORD         #每階存放資料
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb07 LIKE bmb_file.bmb07,    #底數
              bmb08 LIKE bmb_file.bmb08,    #scrap rate
              bmb10_fac2 LIKE bmb_file.bmb10_fac2, #發料/成本換算率
              bma01 LIKE bma_file.bma01,    #No.FUN-680071 VARCHAR(20)               #assembly part
              ima08 LIKE ima_file.ima08,    #來源
              ima53 LIKE ima_file.ima53,    #最近採購單價(本幣)
              ima87 LIKE ima_file.ima87,    #材料成本項目
              ima871 LIKE ima_file.ima871,  #材料製造費用分攤率
              ima872 LIKE ima_file.ima872,  #材料製造費用成本項目
              ima44 LIKE ima_file.ima44,    #採購單位
              ima86 LIKE ima_file.ima86,    #成本單位
              ima34 LIKE ima_file.ima34,    #成本中心
              ima58 LIKE ima_file.ima58,    #最後人工工時
              ima873 LIKE ima_file.ima873,  #人工製/費用分攤率
              ima874 LIKE ima_file.ima874,  #人工製/費用成本項目
              imb111 LIKE imb_file.imb111,  #本階材料成本
              imb118 LIKE imb_file.imb118,  #採購成本
              imb116 LIKE imb_file.imb116,  #廠外加工成本
              imb1171 LIKE imb_file.imb1171,  #廠外加工固定製費
              imb1172 LIKE imb_file.imb1172   #廠外加工變動製費
          END RECORD,
          l_material    LIKE imb_file.imb111,  #材料成本
          l_material_t  LIKE imb_file.imb111,  #材料成本
#-->labor/burden
          labor_cost    LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #labor cost
          ind_labor     LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #indirect labor cost
		  fix_bud       LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #fixed burden cost
		  var_bud       LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #variable burden cost
		  outside_cost  LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #outside process cost
		  out_fix_bud   LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #outside process fixed burden cost
		  out_var_bud   LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #outside process varia.burden cost
		  mac_cost      LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #machine cost
		  add_val       LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #add values
		  ind_m         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #indirect material cost
          l_labor_cost_t   LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)    #labor cost
          l_ind_labor_t    LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)    #indirect labor cost
		  l_fix_bud_t      LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)    #fixed burden cost
		  l_var_bud_t      LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)    #variable burden cost
		  l_outside_cost_t LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)    #outside process cost
		  l_out_fix_bud_t  LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)    #outside process fixed burden cost
		  l_out_var_bud_t  LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)    #outside process varia.burden cost
		  l_mac_cost_t     LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)    #machine cost
		  l_add_val_t   LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #add values
		  l_ind_m_t     LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #indirect material cost
          a1,b1         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #labor cost
          a2,b2         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #indirect labor cost
		  a3,b3         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #fixed burden cost
		  a4,b4         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #variable burden cost
		  a5,b5         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #outside process cost
		  a6,b6         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #outside process fixed burden cost
		  a7,b7         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #outside process varia.burden cost
		  a8,b8         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #machine cost
		  a9,b9         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #add values
		  a10,b10       LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)       #indirect material cost
		  l_add_val     LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
		  l_ind_m       LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
          l_cmd		LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(600)
     DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    LET p_level = p_level + 1
    IF p_level > 20 THEN
        CALL cl_err(p_level,'mfg2644',2)
         CALL p100_restore()
        CALL p100_unlock2()                 #UNLOCK
        CALL cl_batch_bg_javamail("N")      #NO.FUN-570142
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
    END IF
    LET arrno = 600
        LET l_cmd=
            "SELECT bmb03,bmb02,bmb06,bmb07,bmb08,bmb10_fac2,bma01,",
            "       ima08,ima53,ima87,ima871,ima872,ima44,ima86,ima34,",
            "       ima58,ima873,ima874,",
            "       imb111,imb118,imb116,imb1171,imb1172 " ,
            " FROM bmb_file LEFT JOIN imb_file ON bmb03 = imb_file.imb01 LEFT JOIN ima_file ON bmb03 = ima_file.ima01 LEFT JOIN bma_file ON bmb03 = bma_file.bma01",
            " WHERE bmb01='", p_key,"' AND bmb02 >",b_seq,
            "   AND bmb29 ='",p_key2,"' "  #FUN-550100
#生效日及失效日的判斷
        IF tm.effectiv IS NOT NULL THEN
            LET l_cmd=l_cmd CLIPPED, " AND (bmb04 <='",tm.effectiv,
            "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effectiv,
            "' OR bmb05 IS NULL)"
        END IF
 
#組完後的句子, 將準備成可以用的查詢命令
        PREPARE acsp100_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN CALL cl_err('Prepare:',SQLCA.sqlcode,1)
                       CALL p100_restore()
                       CALL p100_unlock2()                 #UNLOCK
                       CALL cl_batch_bg_javamail("N")      #NO.FUN-570142
                       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
                       EXIT PROGRAM
        END IF
        DECLARE acsp100_cur CURSOR FOR acsp100_ppp
 
    WHILE TRUE
        LET l_material_t=0
        LET l_labor_cost_t =0
        LET l_ind_labor_t=0
    	LET l_fix_bud_t =0
    	LET l_var_bud_t=0
		LET l_outside_cost_t=0
		LET l_out_fix_bud_t =0
		LET l_out_var_bud_t =0
		LET l_mac_cost_t   =0
		LET l_add_val_t  =0
		LET l_ind_m_t  =0
        LET l_ac = 1
        FOREACH acsp100_cur INTO sr[l_ac].*           #將資料丟入陣列中
{------>a. "NULL" INITIALIZE TO ZERO }
        IF sr[l_ac].bmb10_fac2 IS NULL THEN LET sr[l_ac].bmb10_fac2=1 END IF
        IF sr[l_ac].ima871     IS NULL THEN LET sr[l_ac].ima871=0 END IF
        IF sr[l_ac].ima873     IS NULL THEN LET sr[l_ac].ima873=0 END IF
        IF sr[l_ac].imb111     IS NULL THEN LET sr[l_ac].imb111=0 END IF
        IF sr[l_ac].imb118     IS NULL THEN LET sr[l_ac].imb118=0 END IF
        IF sr[l_ac].imb116     IS NULL THEN LET sr[l_ac].imb116=0 END IF
        IF sr[l_ac].imb1171    IS NULL THEN LET sr[l_ac].imb1171=0 END IF
        IF sr[l_ac].imb1172    IS NULL THEN LET sr[l_ac].imb1172=0 END IF
        IF sr[l_ac].bmb06      IS NULL THEN LET sr[l_ac].bmb07=0 END IF
        IF sr[l_ac].bmb07      IS NULL THEN LET sr[l_ac].bmb07=1 END IF
        IF sr[l_ac].bmb08      IS NULL THEN LET sr[l_ac].bmb08=0 END IF
 {------>e. '是否考慮損耗率'}
        IF tm.e MATCHES '[Nn]' THEN LET sr[l_ac].bmb08=0 END IF
            #FUN-8B0035--BEGIN--
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            #FUN-8B0035--END-- 
            LET l_ac = l_ac + 1
            IF l_ac >= arrno THEN EXIT FOREACH END IF
         END FOREACH
 
FOR i = 1 TO l_ac-1
    IF sr[i].bma01 IS NOT NULL  AND
	   sr[i].ima08 NOT MATCHES '[pPVvWwzZ]'
         THEN           #表非最下階元件
               #CALL acsp100_bom(p_level,sr[i].bmb03,' ') #再往下展  #FUN-550100#FUN-8B0035
                CALL acsp100_bom(p_level,sr[i].bmb03,l_ima910[i]) #再往下展  #FUN-8B0035
                     RETURNING l_material,            #由下階所累計之材料成本
                               labor_cost, ind_labor, #及下階人工/製費
                               fix_bud   , var_bud,
                               outside_cost,out_fix_bud,
                               out_var_bud, mac_cost,
                               add_val    , ind_m
                IF l_material IS NULL THEN LET l_material = 0 END IF
                IF labor_cost IS NULL THEN LET labor_cost = 0 END IF
		IF ind_labor  IS NULL THEN LET ind_labor  = 0 END IF
		IF fix_bud    IS NULL THEN LET fix_bud    = 0 END IF
		IF var_bud    IS NULL THEN LET var_bud    = 0 END IF
		IF outside_cost IS NULL THEN LET outside_cost=0 END IF
		IF out_fix_bud  IS NULL THEN LET out_fix_bud =0  END IF
		IF out_var_bud  IS NULL THEN LET out_var_bud =0  END IF
		IF mac_cost     IS NULL THEN LET mac_cost    =0  END IF
		IF add_val      IS NULL THEN LET add_val     =0  END IF
		IF ind_m        IS NULL THEN LET ind_m       =0  END IF
		CALL s_in_csa (sr[i].bmb03,sr[i].ima871,l_material,'1',0,0,
                               sr[i].ima872,0,0,tm.version)
		IF g_sma.sma58 MATCHES '[Yy]' THEN        #有使用成本項目結構
	           CALL insert_cote2(sr[i].bmb03,'1')
		END IF
                CALL lab_burden(sr[i].*,l_material) RETURNING
                                       a1,    a2,    a3,     a4,
                                       a5,    a6,    a7,     a8,
                                       a9,    a10             #本階人工/製費
#--->更新料件上/下階成本要素
                CALL lb_bd_update(sr[i].bmb03,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,
                                  labor_cost,ind_labor,fix_bud,var_bud,
                                  outside_cost,out_fix_bud,out_var_bud,
                                  mac_cost,add_val,ind_m)
                LET a1=a1+labor_cost
                LET a2=a2+ind_labor
                LET a3=a3+fix_bud
                LET a4=a4+var_bud
                LET a5=a5+outside_cost
                LET a6=a6+out_fix_bud
                LET a7=a7+out_var_bud
                LET a8=a8+mac_cost
                LET a9=a9+add_val
                LET a10=a10+ind_m
#---->毛需求量=發料單位, 需轉成成本單位
 
                LET a1=a1*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
                      *(1+sr[i].bmb08/100)
                LET a2=a2*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
                      *(1+sr[i].bmb08/100)
                LET a3=a3*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
                      *(1+sr[i].bmb08/100)
                LET a4=a4*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
                      *(1+sr[i].bmb08/100)
                LET a5=a5*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
                      *(1+sr[i].bmb08/100)
                LET a6=a6*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
                      *(1+sr[i].bmb08/100)
                LET a7=a7*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
                      *(1+sr[i].bmb08/100)
                LET a8=a8*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
                      *(1+sr[i].bmb08/100)
                LET a9=a9*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
                      *(1+sr[i].bmb08/100)
                LET a10=a10*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2 #間接材料
                      *(1+sr[i].bmb08/100)
# ------------>    f.若在料件成本要素未打採購成本, 則沿用下階所捲算之材
#                    料成本,否則使用採購成本,並且不將下階之人工/製費捲
#                    算至上階.
                IF tm.m_pur MATCHES '[Yy]'  #自製以採購計
 		     	  THEN IF sr[i].imb118 !=0 THEN
                          LET l_material=sr[i].imb118
                       END IF
				END IF
				LET g_cost=l_material*sr[i].bmb06/sr[i].bmb07*      #材料成本
                           (1+sr[i].bmb08/100)*sr[i].bmb10_fac2
 
                LET l_material_t=l_material_t+g_cost  #累計材料成本
            IF tm.m_pur MATCHES '[Nn]' OR
              (tm.m_pur MATCHES '[yY]' AND sr[i].imb118=0)
             THEN
                LET l_labor_cost_t= l_labor_cost_t+a1 #累計人工成本
                LET l_ind_labor_t = l_ind_labor_t+a2 #累計間接人工
                LET l_fix_bud_t   = l_fix_bud_t+a3 #累計固製費
                LET l_var_bud_t   = l_var_bud_t+a4 #累計變製費
                LET l_outside_cost_t=l_outside_cost_t+a5#廠外
                LET l_out_fix_bud_t =l_out_fix_bud_t+a6#廠外固製費
                LET l_out_var_bud_t =l_out_var_bud_t+a7#廠外變製費
                LET l_mac_cost_t    =l_mac_cost_t+a8 #機器成本
                LET l_add_val_t     =l_add_val_t+a9 #附加成本
                LET l_ind_m_t       =l_ind_m_t+a10 #間接材料
           END IF
           IF g_bgjob = 'N' THEN  #NO.FUN-570142 
               MESSAGE '料件編號:',sr[i].bmb03 clipped,' '
           END IF  
     ELSE #無下階之元件
        CALL p100_pvwz(sr[i].ima08,sr[i].ima44,sr[i].ima86,
                       sr[i].bmb03,sr[i].ima53,sr[i].imb118,
                       sr[i].imb111,sr[i].ima872,sr[i].ima871,sr[i].ima87)
					    returning pur_cost, l_add_val,l_ind_m
        IF tm.p_mak MATCHES '[Yy]' THEN  #採購以自製計(將上/下階非採購成本之值相加)
                                    #當上階之下階材料成本
            SELECT imb111+imb121+imb112+imb212+imb1131+imb213+
                    imb1132+imb2132+imb114+imb214+imb115+imb215+
		    imb116+imb216+imb1171+imb2171+imb1172+imb2172+
		    imb119+imb219+imb120+imb130
              INTO pur_cost
              FROM imb_file WHERE imb01=sr[i].bmb03
	    IF SQLCA.sqlcode !=0 THEN LET pur_cost=0 END IF
        END IF
        LET t_cost=pur_cost*sr[i].bmb06/sr[i].bmb07*sr[i].bmb10_fac2
	    		   *(1+sr[i].bmb08/100)#單價*QPA/底數*(1+SCRAP RATE)
        IF sr[i].bmb08 IS NULL THEN LET sr[i].bmb08 = 0 END IF
        LET l_material_t= l_material_t+ t_cost  #累計下階材料成本
        LET l_add_val_t=l_add_val_t+(l_add_val*sr[i].bmb06/sr[i].bmb07
					*sr[i].bmb10_fac2)
					*(1+sr[i].bmb08/100)
        LET l_ind_m_t=l_ind_m_t+(l_ind_m*sr[i].bmb06/sr[i].bmb07
					*sr[i].bmb10_fac2)
					*(1+sr[i].bmb08/100)
	                                #產生成本項目檔資料
    END IF
    IF g_bgjob = 'N' THEN  #NO.FUN-570142
        MESSAGE '料件編號:',sr[i].bmb03 clipped,' '
    END IF
 
 END FOR
 IF l_ac < arrno OR l_ac=1 THEN         # BOM單身已讀完
    EXIT WHILE
 ELSE
    LET b_seq = sr[arrno].bmb02
 END IF
 END WHILE
    RETURN l_material_t, l_labor_cost_t, l_ind_labor_t   ,l_fix_bud_t,
                         l_var_bud_t   , l_outside_cost_t,l_out_fix_bud_t,
                         l_out_var_bud_t,l_mac_cost_t    ,l_add_val_t ,
                         l_ind_m_t
END FUNCTION
 
#-----處理沒有下階的元件(P/V/W/Z)
FUNCTION p100_pvwz
(l_ima08,l_ima44,l_ima86,l_bmb03,l_ima53,l_imb118,l_imb111,yy,l_ima871,l_ima87)
 
 DEFINE unit_price    LIKE imb_file.imb111,  #材料成本
        l_ima08       LIKE ima_file.ima08,   #SOURCE CODE
        l_ima44       LIKE ima_file.ima44,   #採購單位
        l_ima86       LIKE ima_file.ima44,   #成本單位
        l_bmb03       LIKE bmb_file.bmb03,   #元件編號
        l_ima53       LIKE ima_file.ima53,   #最近採購單價
        l_imb118      LIKE imb_file.imb118,  #purchase cost
        l_imb111      LIKE imb_file.imb111,  #本階材料成本
		yy            LIKE ima_file.ima872,  #間接材料成本項目
        l_imb         record like imb_file.*,
        l_iml         record like iml_file.*,
		l_ima871      LIKE ima_file.ima871,
		l_ima87       LIKE ima_file.ima87 ,
		ind_m         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
		add_val       LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
        l_return      LIKE type_file.chr1      # Prog. Version..: '5.30.06-13.03.12(01)               # SQLCA.sqlcode
 
 
#----->ZERO FLAG=FLAUSE,COPY RECORD FROM iml_file,imb_fie to csb_file,csa_file
 
 SELECT * INTO l_imb.* FROM imb_file WHERE imb01=l_bmb03 #料件
 IF SQLCA.sqlcode !=0
#     THEN
#           CALL cl_err(l_bmb03,'mfg6019',1)   #No.FUN-660089
      THEN
#           CALL cl_err(l_bmb03,'mfg6019',1)   #No.FUN-660089
            CALL cl_err3("sel","imb_file",l_bmb03,"","mfg6019","","",1)     #No.FUN-660089
         CALL p100_restore()
         CALL p100_unlock2()                 #UNLOCK
         CALL cl_batch_bg_javamail("N")      #NO.FUN-570142
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM 
 END IF
 IF cl_null(l_imb.imb111) THEN LET l_imb.imb111=0 END IF
 IF cl_null(l_imb.imb112) THEN LET l_imb.imb112=0 END IF
 IF cl_null(l_imb.imb1131) THEN LET l_imb.imb1131=0 END IF
 IF cl_null(l_imb.imb1132) THEN LET l_imb.imb1132=0 END IF
 IF cl_null(l_imb.imb114) THEN LET l_imb.imb114=0 END IF
 IF cl_null(l_imb.imb115) THEN LET l_imb.imb115=0 END IF
 IF cl_null(l_imb.imb116) THEN LET l_imb.imb116=0 END IF
 IF cl_null(l_imb.imb1171) THEN LET l_imb.imb1171=0 END IF
 IF cl_null(l_imb.imb1172) THEN LET l_imb.imb1172=0 END IF
 IF cl_null(l_imb.imb119) THEN LET l_imb.imb119=0 END IF
 IF cl_null(l_imb.imb118) THEN LET l_imb.imb118=0 END IF
 IF cl_null(l_imb.imb120) THEN LET l_imb.imb120=0 END IF
 IF cl_null(l_imb.imb121) THEN LET l_imb.imb121=0 END IF
 IF cl_null(l_imb.imb122) THEN LET l_imb.imb122=0 END IF
 IF cl_null(l_imb.imb1231) THEN LET l_imb.imb1231=0 END IF
 IF cl_null(l_imb.imb1232) THEN LET l_imb.imb1232=0 END IF
 IF cl_null(l_imb.imb124) THEN LET l_imb.imb124=0 END IF
 IF cl_null(l_imb.imb125) THEN LET l_imb.imb125=0 END IF
 IF cl_null(l_imb.imb126) THEN LET l_imb.imb126=0 END IF
 IF cl_null(l_imb.imb1271) THEN LET l_imb.imb1271=0 END IF
 IF cl_null(l_imb.imb1272) THEN LET l_imb.imb1272=0 END IF
 IF cl_null(l_imb.imb129) THEN LET l_imb.imb129=0 END IF
 IF cl_null(l_imb.imb130) THEN LET l_imb.imb130=0 END IF
 IF tm.lab_bud MATCHES '[Nn]'   #是否將非材料成本要素欄位全部清為零
    THEN
         INSERT INTO  csa_file(csa01         ,csa02  ,    csa03 ,
                               csa0301       ,csa0302,
							   csa0303       ,csa0304,
							   csa0305       ,csa0306,
							   csa0307       ,csa0308,
							   csa0309       ,csa0310,
							   csa0311       ,csa0312,
							   csa0321       ,csa0322,
							   csa0323       ,csa0324,
							   csa0325       ,csa0326,
							   csa0327       ,csa0328,
							   csa0329       ,csa0330,
							   csa0331       ,csaacti,
							   csauser       ,csagrup,
							   #csamodu       ,csadate,csaoriu,csaorig) #FUN-980002
							   csamodu       ,csadate,  #FUN-980002
                                                           csaplant      ,csalegal) #FUN-980002
                       VALUES (l_bmb03       ,tm.version,'1',
                                l_imb.imb111  , l_imb.imb112,
						    	l_imb.imb1131, l_imb.imb1132,
							    l_imb.imb114 , l_imb.imb115 ,
								l_imb.imb116 , l_imb.imb1171 ,
								l_imb.imb1172, l_imb.imb119 ,
								l_imb.imb118 , l_imb.imb120 ,
								l_imb.imb121 , l_imb.imb122,
								l_imb.imb1231, l_imb.imb1232,
								l_imb.imb124,  l_imb.imb125,
								l_imb.imb126,  l_imb.imb1271,
								l_imb.imb1272, l_imb.imb129,
								l_imb.imb130 ,   'Y'       ,
								g_user       ,g_grup       ,
								#g_user       ,g_today, g_user, g_grup) #FUN-980002      #No.FUN-980030 10/01/04  insert columns oriu, orig
								g_user       ,g_today,  #FUN-980002
                                                                g_plant      ,g_legal)  #FUN-980002
             IF  g_sma.sma58 MATCHES '[Yy]'
                THEN DECLARE pvwz_cursor CURSOR FOR select * from iml_file
			        					   WHERE iml01=l_bmb03 #料件編號
		             FOREACH pvwz_cursor INTO l_iml.*
		             IF SQLCA.sqlcode !=0 THEN ERROR 'iml_file'
                         EXIT FOREACH END IF
		             CALL   insert_cote(l_bmb03,l_iml.iml02,l_iml.iml031,'1')
	                 END FOREACH
             END IF
			 LET unit_price=l_imb.imb118              #material cost
			 LET ind_m     =l_imb.imb118*l_ima871     #indirect material cost
#---> c.ADD VALUE 處理
#       -若不將人工/製費清空, 則直接將料件成本要素及成本項目
#        結構複製過來, 因此, 毋需再產生附加成本部份.
#            CALL s_add_val(l_bmb03,'1',tm.version) returning add_val
  ELSE
      IF l_ima08 MATCHES '[pP]'         #採購料件
		 THEN
			  LET unit_price=l_imb.imb118           #material cost
			  LET ind_m     =l_imb.imb118*l_ima871  #indirect material cost
		      CALL s_in_csa                               #放入採購成本
			       (l_bmb03,0,0,'1',unit_price,0,yy,ind_m,add_val,tm.version)
	          IF g_sma.sma58 MATCHES '[Yy]'  #有使用成本項目結構
	             THEN CALL insert_cote(l_bmb03,l_ima87,unit_price,'1')
                      CALL insert_cote(l_bmb03,l_ima87,ind_m,'1')
	          END IF
              CALL s_add_val(l_bmb03,'1',tm.version)  RETURNING add_val
 
         ELSE  #SOURCE CODE =V,W,Z
			  LET unit_price=l_imb.imb111          #material cost
			  LET ind_m     =l_imb.imb111*l_ima871 #indirect material cost
              CALL s_in_csa                                #本階材料成本
				  (l_bmb03,0,0,'1',0,unit_price,yy,ind_m,add_val,tm.version)
              IF tm.free_stock MATCHES '[Nn]'      #大宗料件及雜項料件包含
				 THEN  LET unit_price = 0          #不包含時,不累算至上一階
					   LET ind_m=0
              END IF
	          IF g_sma.sma58 MATCHES '[Yy]'  #有使用成本項目結構
	             THEN CALL insert_cote(l_bmb03,l_ima87,unit_price,'1')
                      CALL insert_cote(l_bmb03,l_ima87,ind_m,'1')
	          END IF
              CALL s_add_val(l_bmb03,'1',tm.version)  RETURNING add_val
 
        END IF
 END IF
 
	 RETURN unit_price,add_val,ind_m
END FUNCTION
 
#---->1.新增最下階成本項目資料(成本=算出之單位成本)
FUNCTION insert_cote(part_no,cost_cote,s_material,l_status)
   DEFINE part_no   LIKE csb_file.csb01,    #No.FUN-680071 VARCHAR(20)       #料件
		  cost_cote  LIKE csb_file.csb04,      # Prog. Version..: '5.30.06-13.03.12(06)       #成本項目
		  s_material LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6) #成本
		  l_status   LIKE type_file.chr1,      # Prog. Version..: '5.30.06-13.03.12(01)      #1.standard 2.current 3.propose
		  l_n       LIKE type_file.num5    #No.FUN-680071 SMALLINT
 
#92/07/30 by pin
  IF cost_cote IS NULL OR cost_cote=' '
	 THEN LET cost_cote='NULL'         #歸於成本項目 'NULL'
  END IF
  IF s_material IS NULL
	 THEN LET s_material=0
		  RETURN
   END IF
						
  SELECT count(*) INTO l_n FROM csb_file   WHERE csb01=part_no
	 AND csb02=tm.version AND csb03=l_status AND csb04=cost_cote
 
 IF l_n = 0 THEN
	INSERT INTO csb_file (csb01,csb02,csb03,csb04,csb05,csbplant,csblegal) #FUN-980002 #add csbplant,csblegal
	     VALUES(part_no, tm.version,l_status  ,cost_cote,s_material,g_plant,g_legal) #FUN-980002 add g_plant,g_legal
	IF SQLCA.sqlcode !=0 THEN
#No.MOD-580325-begin
#                  CALL cl_err(part_no clipped,'acs-001',0)   #No.FUN-660089
                   CALL cl_err3("ins","csb_file",part_no clipped,"","acs-001","","",0)     #No.FUN-660089
#                    ELSE CALL cl_err(part_no clipped,'acs-002',0)   #No.FUN-660089
                     ELSE 
#                         CALL cl_err(part_no clipped,'acs-002',0)   #No.FUN-660089
                          CALL cl_err3("sel","csb_file","","","acs-002","","",0)     #No.FUN-660089
#                  ERROR '新增此',part_no clipped,'料件失敗!!!' sleep 2
#                   ELSE MESSAGE '料件編號:',part_no clipped,' 新增完成 '
#No.MOD-580325-end
	END IF
 ELSE
    UPDATE csb_file set csb05=csb05+s_material
    WHERE csb01=part_no
	AND csb02=tm.version
    AND csb03=l_status
	AND csb04=cost_cote
 END IF
END FUNCTION
 
#---複製下階成本項目至本階(需考慮下階QPA,底數,損耗率)
FUNCTION insert_cote2(part_no,l_status)
   DEFINE part_no   LIKE csb_file.csb01,    #No.FUN-680071 VARCHAR(20)             #item no.
          l_item    LIKE csb_file.csb01,    #No.FUN-680071 VARCHAR(20)             #item no.
		  t_cost    LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)        #此料件的材料成本(含損耗率,需求量)
		  l_bmb06   LIKE bmb_file.bmb06,  #QPA
		  l_bmb07   LIKE bmb_file.bmb07,  #底數
		  l_bmb08   LIKE bmb_file.bmb08,  #scrap rate%
          l_bmb10_fac2 LIKE bmb_file.bmb10_fac2, #發料/成本轉換率
          l_csb04   LIKE csb_file.csb04,  #成本項目
          l_csb05   LIKE csb_file.csb05,  #成本
          l_n       LIKE type_file.num5,    #No.FUN-680071 SMALLINT
		  l_status  LIKE type_file.chr1      # Prog. Version..: '5.30.06-13.03.12(01)              #1.standard 2.current 3.propose
 
	DECLARE insert_cote2 CURSOR FOR    #將此料件下階的元件抓取出來
            select bmb03,bmb06,bmb07,bmb08,bmb10_fac2 from bmb_file
             where bmb01 = part_no       #料件編號
               and (bmb04 <=tm.effectiv or bmb04 is null) #生效日控制
               and (bmb05 > tm.effectiv or bmb05 is null)
 
	FOREACH insert_cote2 INTO l_item,l_bmb06,l_bmb07,l_bmb08,l_bmb10_fac2
{------>a."NULL" INITIALIZE TO ZERO}
    IF l_bmb06 IS NULL THEN LET l_bmb06=0 END IF
    IF l_bmb07 IS NULL THEN LET l_bmb07=1 END IF
    IF l_bmb08 IS NULL THEN LET l_bmb08=0 END IF
    IF l_bmb10_fac2 IS NULL THEN LET l_bmb10_fac2=1 END IF
{------>e.是否考慮損耗率}
     IF tm.e MATCHES '[Nn]' THEN LET l_bmb08=0 END IF
    IF SQLCA.sqlcode !=0 THEN EXIT FOREACH END IF
    DECLARE insert_cote_c CURSOR FOR #將元件的成本項目抓出
	   SELECT csb04,csb05 FROM  csb_file
						  WHERE csb01=l_item       #元件編號
						  AND  csb02=tm.version    #模擬版本
						  AND  csb03=l_status      #1.standard 2.current 3.pro
 
		FOREACH insert_cote_c INTO l_csb04,l_csb05 #成本項目,成本
		IF SQLCA.sqlcode !=0 THEN EXIT FOREACH END IF
#92/07/31 by pin
        IF l_csb04 IS NULL OR l_csb04=' '
           THEN LET l_csb04='NULL'           #歸於成本項目 'NULL'
        END IF
		IF l_csb05 IS NULL THEN LET l_csb05=0 END IF
#--->下階成本項目成本*下階QPA/底數*(1+SCRAP RATE)
        LET t_cost=l_csb05*l_bmb06/l_bmb07*(1+(l_bmb08/100))*l_bmb10_fac2
		IF  t_cost IS NULL
     		THEN LET t_cost=0
	    		 CONTINUE FOREACH
    	 END IF
        SELECT count(*) INTO l_n FROM csb_file
										where csb01 = part_no
										  and csb02 = tm.version
										  and csb03 = l_status
										  and csb04 = l_csb04
        IF l_n=0
           THEN
              INSERT INTO csb_file (csb01, csb02  ,  csb03,   csb04 ,csb05 ,csbplant ,csblegal) #FUN-980002
	     	         VALUES  (part_no, tm.version,l_status  ,  l_csb04,t_cost,g_plant,g_legal) #FUN-980002
		
		      IF SQLCA.sqlcode !=0
#No.MOD-580325-begin
#                    THEN 
#                          CALL cl_err(part_no clipped,'acs-001',0)   #No.FUN-660089
                     THEN 
#                         CALL cl_err(part_no clipped,'acs-001',0)   #No.FUN-660089
                          CALL cl_err3("ins","csb_file",part_no clipped,"","acs-001","","",0)     #No.FUN-660089
#                    ELSE
#                         CALL cl_err(part_no clipped,'acs-002',0)   #No.FUN-660089
                     ELSE
#                         CALL cl_err(part_no clipped,'acs-002',0)   #No.FUN-660089
                          CALL cl_err3("ins","csb_file",part_no clipped,"","acs-002","","",0)     #No.FUN-660089
#                  THEN ERROR '新增此',part_no clipped,'料件失敗!!!' sleep 2
#                  ELSE MESSAGE '料件編號:',part_no clipped,' 新增完成 '
#No.MOD-580325-end
              END IF
           ELSE UPDATE csb_file set csb05=csb05+t_cost
										where csb01 = part_no
										  and csb02 = tm.version
										  and csb03 = l_status
										  and csb04 = l_csb04
		END IF
		END FOREACH
	END FOREACH
   END FUNCTION
 
#----->計算除材料成本外之成本要素
 
FUNCTION lab_burden(l_aa,m_material)
 DEFINE l_aa RECORD
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb07 LIKE bmb_file.bmb07,    #底數
              bmb08 LIKE bmb_file.bmb08,    #scrap rate
              bmb10_fac2 LIKE bmb_file.bmb10_fac2, #發料/成本換算率
              bma01 LIKE bma_file.bma01,    #No.FUN-680071 VARCHAR(20)               #assembly part
              ima08 LIKE ima_file.ima08,    #來源
              ima53 LIKE ima_file.ima53,    #最近採購單價(本幣)
              ima87 LIKE ima_file.ima87,    #材料成本項目
              ima871 LIKE ima_file.ima871,  #材料製造費用分攤率
              ima872 LIKE ima_file.ima872,  #材料製造費用成本項目
              ima44 LIKE ima_file.ima44,    #採購單位
              ima86 LIKE ima_file.ima86,    #成本單位
              ima34 LIKE ima_file.ima34,    #成本中心
              ima58 LIKE ima_file.ima58,    #最後人工工時
              ima873 LIKE ima_file.ima873,  #人工製/費用分攤率
              ima874 LIKE ima_file.ima874,  #人工製/費用成本項目
              imb111 LIKE imb_file.imb111,  #本階材料成本
              imb118 LIKE imb_file.imb118,  #採購成本
              imb116 LIKE imb_file.imb116,  #廠外加工成本
              imb1171 LIKE imb_file.imb1171,  #廠外加工固定製費
              imb1172 LIKE imb_file.imb1172   #廠外加工變動製費
          END RECORD,
         m_material LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)          #下階材料成本
         m_ima873   LIKE ima_file.ima873,
         c1         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
         c2         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
         c3         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
         c4         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
         c5         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
         c6         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
         c7         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
         c8         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
         c9         LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6) 
         c10        LIKE type_file.chr1       #No.FUN-680071 DECIMAL(20,6)
 
 IF g_sma.sma23 IS NULL OR g_sma.sma23= ' '  #成本取得方式
						OR g_sma.sma23 NOT MATCHES '[123]'
	THEN CALL cl_err(g_sma.sma23,'mfg6007',1)
         CALL p100_restore()
         CALL p100_unlock2()                 #UNLOCK
         CALL cl_batch_bg_javamail("N")      #NO.FUN-570142
	 CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211	 
         EXIT PROGRAM
 END IF
 
 CASE g_sma.sma23
	  WHEN '1'  CALL use_cost_center(l_aa.*,m_material,l_aa.ima873)
											         #成本取得方式,使用成本中心
                         returning c1,c2,c3,c4,c5,c6,c7,c8,c9,c10
 	  WHEN '2'  CALL use_rout_wc        #使用製程/工作站
                     (l_aa.bmb03,m_material,l_aa.ima873,l_aa.ima874,'r' )
                         returning c1,c2,c3,c4,c5,c6,c7,c8,c9,c10
      WHEN '3'                                  #成本取得方式,使用 '1' 或 '2'
	          IF l_aa.ima34 IS NOT NULL  AND l_aa.ima34 !=' '
				 THEN   CALL use_cost_center(l_aa.*,m_material,l_aa.ima873)
                         returning c1,c2,c3,c4,c5,c6,c7,c8,c9,c10
				 ELSE   CALL use_rout_wc
                        (l_aa.bmb03,m_material,l_aa.ima873,l_aa.ima874,'r')
                         returning c1,c2,c3,c4,c5,c6,c7,c8,c9,c10
			  END IF
      OTHERWISE    let c1=0    let c2=0
                   let c3=0    let c4=0
                   let c5=0    let c6=0
                   let c7=0    let c8=0
                   let c9=0    let c10=0
 END CASE
 IF c1 IS NULL THEN LET c1=0 END IF
 IF c2 IS NULL THEN LET c2=0 END IF
 IF c3 IS NULL THEN LET c3=0 END IF
 IF c4 IS NULL THEN LET c4=0 END IF
 IF c5 IS NULL THEN LET c5=0 END IF
 IF c6 IS NULL THEN LET c6=0 END IF
 IF c7 IS NULL THEN LET c7=0 END IF
 IF c8 IS NULL THEN LET c8=0 END IF
 IF c9 IS NULL THEN LET c9=0 END IF
 IF c10 IS NULL THEN LET c10=0 END IF
 RETURN c1,c2,c3,c4,c5,c6,c7,c8,c9,c10
END FUNCTION
 
FUNCTION use_cost_center(p_aa,p_material,l_ima873 )
DEFINE p_aa  RECORD
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb07 LIKE bmb_file.bmb07,    #底數
              bmb08 LIKE bmb_file.bmb08,    #scrap rate
              bmb10_fac2 LIKE bmb_file.bmb10_fac2, #發料/成本換算率
              bma01 LIKE bma_file.bma01,    #No.FUN-680071 VARCHAR(20)               #assembly part
              ima08 LIKE ima_file.ima08,    #來源
              ima53 LIKE ima_file.ima53,    #最近採購單價(本幣)
              ima87 LIKE ima_file.ima87,    #材料成本項目
              ima871 LIKE ima_file.ima871,  #材料製造費用分攤率
              ima872 LIKE ima_file.ima872,  #材料製造費用成本項目
              ima44 LIKE ima_file.ima44,    #採購單位
              ima86 LIKE ima_file.ima86,    #成本單位
              ima34 LIKE ima_file.ima34,    #成本中心
              ima58 LIKE ima_file.ima58,    #最後人工工時
              ima873 LIKE ima_file.ima873,  #人工製/費用分攤率
              ima874 LIKE ima_file.ima874,  #人工製/費用成本項目
              imb111 LIKE imb_file.imb111,  #本階材料成本
              imb118 LIKE imb_file.imb118,  #採購成本
              imb116 LIKE imb_file.imb116,  #廠外加工成本
              imb1171 LIKE imb_file.imb1171,  #廠外加工固定製費
              imb1172 LIKE imb_file.imb1172   #廠外加工變動製費
          END RECORD,
    l_smh  RECORD LIKE smh_file.*,
    l_csa0301     LIKE csa_file.csa0301,
    l_csa0303     LIKE csa_file.csa0303,    #direct labor cost
    l_csa0304     LIKE csa_file.csa0304,    #indirect labor cost
    l_csa0305     LIKE csa_file.csa0305,    #fixed burden
    l_csa0306     LIKE csa_file.csa0306,    #variable burden
    l_csa0307     LIKE csa_file.csa0307,    #outside process cost
    l_csa0308     LIKE csa_file.csa0308,    #outside process fixed burden
    l_csa0309     LIKE csa_file.csa0308,    #outside process varia.burden
    l_csa0310     LIKE csa_file.csa0310,    #machine cost
    l_csa0312     LIKE csa_file.csa0312,    #add values
    x1,x2,x3,x4,x5,x6,x7,x8,x9  LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
    p_material    LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)            #下階材料成本
    l_csa789      LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
    l_ima873      LIKE ima_file.ima873
 
    IF p_aa.ima08 MATCHES '[xX]' THEN RETURN 0,0,0,0,0,0,0,0,0,0 END IF
    IF p_aa.ima34 IS NULL  AND p_aa.ima08 NOT MATCHES '[xX]'
      THEN  CALL cl_err(p_aa.ima34,'mfg6010',1)
             CALL p100_restore()
             CALL p100_unlock2()                 #UNLOCK
             CALL cl_batch_bg_javamail("N")      #NO.FUN-570142
	     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211	     
             EXIT PROGRAM
     END IF
 
 SELECT * INTO l_smh.*  FROM smh_file WHERE smh01=p_aa.ima34  #cost center no.
   IF SQLCA.sqlcode !=0
 	  THEN
#           CALL cl_err(p_aa.ima34,'mfg6010',1)   #No.FUN-660089
            CALL cl_err3("sel","smh_file",p_aa.ima34,"","mfg6010","","",1)     #No.FUN-660089
            CALL p100_restore()
            CALL p100_unlock2()                 #UNLOCK
            CALL cl_batch_bg_javamail("N")      #NO.FUN-570142
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
            EXIT PROGRAM
   END IF
 
#---->本階 direct labor cost
   LET l_csa0303=p_aa.ima58*l_smh.smh103 #本階人工成本=最後人工工時*工資率
 
#---->本階 indirect labor cost
   LET l_csa0304=l_csa0303*p_aa.ima873   #間接人工費用=人工成本*分攤率
 
#---->本階 fixed/variable burden cost
   CASE l_smh.smh105
        WHEN '1' #製/費用分攤基準,為直接人工成本
        LET l_csa0305= l_csa0303  * l_smh.smh106 #人工成本*製費分攤率
        LET l_csa0306= l_csa0303  * l_smh.smh108 #人工成本*製費分攤率
        WHEN '2' #製/費用分攤基準,為直接人工小時
        LET l_csa0305= p_aa.ima58 * l_smh.smh106 #最後人工小時*製費成本率
        LET l_csa0306= p_aa.ima58 * l_smh.smh108 #最後人工小時*製費成本率
        WHEN '3' #製/費用分攤基準,為直接材料成本
#       SELECT csa0301 INTO l_csa0301 FROM csa_file WHERE csa01=p_aa.bmb03
#                                                    AND  csa02=tm.version
#       IF SQLCA.sqlcode !=0 THEN LET l_csa0301=0 END IF
        LET l_csa0305= p_material * l_smh.smh106 #(已+下)階材料成本*製費分攤率
        LET l_csa0306= p_material * l_smh.smh108 #(上+下)材料成本*製費分攤率
        WHEN '4' #製/費用分攤基準,為生產數量
        LET l_csa0305= l_smh.smh106             #製費分攤率(固定金額)
        LET l_csa0306= l_smh.smh108             #製費分攤率(固定金額)
        OTHERWISE LET l_csa0305=0
  END CASE
#----->本階廠外加工成本/outside process fix/variable burden cost/matchine cost
  CASE g_sma.sma61   #廠外加工成本取得方式,為僅使用料件主檔內的廠外加工成本
       WHEN '1' LET l_csa0307 = p_aa.imb116  #廠外加工成本
                LET l_csa0308 = p_aa.imb1171 #outside process fixed burden cost
                LET l_csa0309 = p_aa.imb1172 #outside process varia.burden cost
                LET l_csa0310 = 0            #不考慮機器成本machine cost
  #92/01/27 modify 若使用成本中心時,只能使用 '1' 方式
  #    WHEN '2' CALL use_rout_wc
  #                  (p_aa.bmb03,p_material,p_aa.ima873,p_aa.ima874,'c')
  #                  RETURNING x1,x2,x3,x4,x5,x6,x7,x8,x9
  #              LET l_csa0307=x5
  #              LET l_csa0308=x6
  #              LET l_csa0309=x7
  #              LET l_csa0310=x8
 
       OTHERWISE LET l_csa0307=0
                 LET l_csa0308=0
                 LET l_csa0309=0
				 LET l_csa0310=0
   END CASE
  IF g_sma.sma58 MATCHES '[Yy]'   #有使用成本項目結構
	 THEN
#---->增加各成本要素的成本項目
#---->人工成本項目
   IF l_smh.smh104 IS NULL THEN LET l_smh.smh104=' ' END IF
   CALL insert_cote (p_aa.bmb03,l_smh.smh104,l_csa0303,'1')
#---->間接人工成本項目
   IF p_aa.ima874 IS NULL then LET p_aa.ima874=' ' END IF
   CALL insert_cote (p_aa.bmb03,p_aa.ima874,l_csa0304,'1')
#---->固定製造費用成本項目
   IF l_smh.smh107 IS NULL THEN LET l_smh.smh107=' ' END IF
   CALL insert_cote (p_aa.bmb03,l_smh.smh107,l_csa0305,'1')
#---->變動製造費用成本項目
   IF l_smh.smh109 IS NULL THEN LET l_smh.smh109=' ' END IF
   CALL insert_cote (p_aa.bmb03,l_smh.smh109,l_csa0306,'1')
#------>92/07/31 BY pin
# d - 若使用成本中心計算其成本,且亦使用成本項目結構時,將
#   廠外加工成本/廠外加工固定/變動製造費用之成本相加,
#   彙集至成本項目編號 "UNKNOW"==>為了成本要素與成本
#   項目值能BALANCE.
    LET l_csa789=l_csa0307+l_csa0308+l_csa0309
   CALL insert_cote (p_aa.bmb03,'UNKNOW',l_csa789,'1')
#----->附加成本(add values)
   CALL s_add_val(p_aa.bmb03,'1',tm.version)  RETURNING l_csa0312
   END IF
 
 RETURN l_csa0303,l_csa0304,l_csa0305,l_csa0306,
        l_csa0307,l_csa0308,l_csa0309,l_csa0310,l_csa0312,0
 END FUNCTION
 
#----->更新料件各上/下階成本要素
 
FUNCTION lb_bd_update(x_item,u_a1,u_a2,u_a3,u_a4,u_a5,u_a6,u_a7,u_a8,u_a9,u_a10
		                    ,d_a1,d_a2,d_a3,d_a4,d_a5,d_a6,d_a7,d_a8,d_a9,d_a10)
 
DEFINE u_a1,u_a2,u_a3,u_a4,u_a5,u_a6,u_a7,u_a8,u_a9 LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6) #上階成本要素
       d_a1,d_a2,d_a3,d_a4,d_a5,d_a6,d_a7,d_a8,d_a9 LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6) #下階成本要素
       u_a10 LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)   #本階間接材料成本
       d_a10 LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)   #下階間接材料成本
       p_ln  LIKE type_file.num5,      #No.FUN-680071 smallint
       x_item LIKE csa_file.csa01    #No.FUN-680071 VARCHAR(20)
						
 
      IF cl_null(u_a1) THEN LET u_a1=0 END IF
      IF cl_null(u_a2) THEN LET u_a2=0 END IF
      IF cl_null(u_a3) THEN LET u_a3=0 END IF
      IF cl_null(u_a4) THEN LET u_a4=0 END IF
      IF cl_null(u_a5) THEN LET u_a5=0 END IF
      IF cl_null(u_a6) THEN LET u_a6=0 END IF
      IF cl_null(u_a7) THEN LET u_a7=0 END IF
      IF cl_null(u_a8) THEN LET u_a8=0 END IF
      IF cl_null(u_a9) THEN LET u_a9=0 END IF
      IF cl_null(u_a10) THEN LET u_a10=0 END IF
      IF cl_null(d_a1) THEN LET d_a1=0 END IF
      IF cl_null(d_a2) THEN LET d_a2=0 END IF
      IF cl_null(d_a3) THEN LET d_a3=0 END IF
      IF cl_null(d_a4) THEN LET d_a4=0 END IF
      IF cl_null(d_a5) THEN LET d_a5=0 END IF
      IF cl_null(d_a6) THEN LET d_a6=0 END IF
      IF cl_null(d_a7) THEN LET d_a7=0 END IF
      IF cl_null(d_a8) THEN LET d_a8=0 END IF
      IF cl_null(d_a9) THEN LET d_a9=0 END IF
      IF cl_null(d_a10) THEN LET d_a10=0 END IF
 
	  SELECT COUNT(*) INTO p_ln FROM csa_file
								WHERE csa01=x_item     #item no.
								  AND csa02=tm.version #simulation version
	  IF p_ln!=0
		 THEN UPDATE csa_file
                     SET csa0302=u_a10,   #本階indirect material cost
					     csa0303=u_a1,    #本階direct labor cost
						 csa0304=u_a2,    #本階indirect labor cost
						 csa0305=u_a3,    #本階direct labor cost
						 csa0306=u_a4,    #本階fixed burden cost
						 csa0307=u_a5,    #本階variable burden cost
						 csa0308=u_a6,    #本階outside process cost
						 csa0309=u_a7,    #本階outside fixed burden cost
						 csa0310=u_a8,    #本階outside varia.burden cost
						 csa0312=u_a9,    #本階add value cost
 
                         csa0322=d_a10,    #下階indirect material cost
					     csa0323=d_a1,    #下階direct labor cost
						 csa0324=d_a2,    #下階indirect labor cost
						 csa0325=d_a3,    #下階direct labor cost
						 csa0326=d_a4,    #下階fixed burden cost
						 csa0327=d_a5,    #下階variable burden cost
						 csa0328=d_a6,    #下階outside process cost
						 csa0329=d_a7,    #下階outside fixed burden cost
						 csa0330=d_a8,    #下階outside varia.burden cost
						 csa0331=d_a9     #下階add value cost
					WHERE csa01=x_item     #item no.
					  AND csa02=tm.version #simulation version
         END IF
END FUNCTION
 
#--->人工成本取得方式為 -------製程與工作站--------------------
 
FUNCTION  use_rout_wc(w_item,w_material,w_ima873,w_ima874,l_flag)
  DEFINE w_item     LIKE ima_file.ima01,      #No.FUN-680071CHAR(20)                      #料件編號
         w_material LIKE oeb_file.oeb13,    #No.FUN-680071 DECIMAL(20,6)             #本階材料成本
         w_ima873   LIKE ima_file.ima873,      #間接材料製/費用分攤率
		 l_flag     LIKE type_file.chr1,                    #'c':cost center 'r':routing  #No.FUN-680071 VARCHAR(1)
         l_eca04 LIKE eca_file.eca04,
         l_eca06 LIKE eca_file.eca06,
		 l_eca14 LIKE eca_file.eca14,
		 l_eca15 LIKE eca_file.eca15,
		 l_eca16 LIKE eca_file.eca16,
		 l_eca17 LIKE eca_file.eca17,
		 l_eca18 LIKE eca_file.eca18,
		 l_eca19 LIKE eca_file.eca19,
		 l_eca20 LIKE eca_file.eca20,
		 l_eca21 LIKE eca_file.eca21,
		 l_eca201 LIKE eca_file.eca201,
		 l_eca211 LIKE eca_file.eca211,
		 l_eca22 LIKE eca_file.eca22,
		 l_eca23 LIKE eca_file.eca23,
		 l_eca24 LIKE eca_file.eca24,
		 l_eca25 LIKE eca_file.eca25,
		 l_eca37 LIKE eca_file.eca37,
		 l_eca38 LIKE eca_file.eca38,
		 l_eca39 LIKE eca_file.eca39,
		 l_eca40 LIKE eca_file.eca40,
		 l_eca41 LIKE eca_file.eca41,
         l_ecb03 LIKE ecb_file.ecb03,
		 l_ecb18 LIKE ecb_file.ecb18,
		 l_ecb19 LIKE ecb_file.ecb19,
		 l_ecb20 LIKE ecb_file.ecb20,
		 l_ecb21 LIKE ecb_file.ecb21,
		 l_ecb22 LIKE ecb_file.ecb22,
		 l_ecb23 LIKE ecb_file.ecb23,
		 l_ecb24 LIKE ecb_file.ecb24,
		 l_ecb25 LIKE ecb_file.ecb25,
         l_ecb15 LIKE ecb_file.ecb15,
         l_ecb16 LIKE ecb_file.ecb16,
		 l_ima561 LIKE ima_file.ima561,
		 l_csa0303 LIKE csa_file.csa0303,
		 l_csa0304 LIKE csa_file.csa0304,
		 l_csa0305 LIKE csa_file.csa0305,
		 l_csa0306 LIKE csa_file.csa0306,
		 l_csa0307 LIKE csa_file.csa0307,
		 l_csa0308 LIKE csa_file.csa0308,
		 l_csa0309 LIKE csa_file.csa0309,
		 l_csa0310 LIKE csa_file.csa0310,
		 l_csa0312 LIKE csa_file.csa0312,
         t_csa0304 LIKE csa_file.csa0304,
         t_csa0305 LIKE csa_file.csa0305,
         t_csa0306 LIKE csa_file.csa0306,
         t_csa0307 LIKE csa_file.csa0307,
         t_csa0308 LIKE csa_file.csa0308,
         t_csa0309 LIKE csa_file.csa0309,
         t_csa0310 LIKE csa_file.csa0310,
         l_ima571  LIKE ima_file.ima571,
         yn        LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(01)
	 lab_hour,mat_hour   LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
         setup_cost,run_cost LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
         mat_setup,mat_run   LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
         x_csa0303 LIKE csa_file.csa0303,
         x_csa0310 LIKE csa_file.csa0310,
         x_lab_hour LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
         x_mat_hour LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
         w_ima874 LIKE ima_file.ima874,
         l_ima55  LIKE ima_file.ima55,
         l_ima86  LIKE ima_file.ima86,
		 p_flag   LIKE type_file.num5,      #No.FUN-680071 SMALLINT
		 l_factor LIKE type_file.num20_6,   #No.FUN-680071 DECIMAL(20,6)
         s_cmd   LIKE type_file.chr1000   #No.FUN-680071 VARCHAR(500)
 
 
   		  LET l_csa0303=0 LET l_csa0304=0
		  LET l_csa0305=0 LET l_csa0306=0
		  LET l_csa0307=0 LET l_csa0308=0
		  LET l_csa0309=0 LET l_csa0310=0
		  LET l_csa0312=0
   SELECT ima571 INTO l_ima571 FROM ima_file WHERE ima01=w_item #料號
   IF SQLCA.sqlcode THEN LET l_ima571=' ' END IF
   LET s_cmd=
         " SELECT eca04,eca06,eca14,eca15,eca16,eca17,eca18,eca19,",
               " eca20,eca21,eca201,eca211,eca22,eca23,eca24,eca25,",
               " eca37,eca38,eca39,eca40,eca41,",
               " ecb03,ecb18,ecb19,ecb20,ecb21,ecb22,ecb23,ecb24,ecb25,ecb15,",
               " ecb16,ima561 ",
               " FROM ecb_file,eca_file,ima_file ",
               " WHERE eca01=ecb08 ",  #工作站編號
			   " AND  ima01=ecb01 ",  #料件編號
               " AND  ecb01=?     ",  #料件編號
               " AND  ecb02=?     ",  #主製程編號
               " AND (ecb04 <=?  OR ecb04 IS NULL)",  #生效日控制
               " AND (ecb05 > ?  OR ecb05 IS NULL)",
               " AND  ecbacti IN ('Yy') ",
               " ORDER BY ecb03 "
  PREPARE wc1 FROM s_cmd
  DECLARE wc_rout_cur CURSOR FOR   wc1
 
  IF l_ima571 IS NULL OR l_ima571=' '   #表有自己製程,並非與其他料件共用
     THEN OPEN wc_rout_cur USING w_item,tm.rout,tm.effectiv,tm.effectiv
  ELSE    OPEN wc_rout_cur USING l_ima571,tm.rout,tm.effectiv,tm.effectiv
  END IF
  LET yn=0
 
 WHILE TRUE
 
  FETCH  wc_rout_cur INTO l_eca04, l_eca06, l_eca14, l_eca15,
                           l_eca16, l_eca17, l_eca18,
                           l_eca19, l_eca20, l_eca21, l_eca201,
                           l_eca211,l_eca22, l_eca23, l_eca24,
						   l_eca25, l_eca37, l_eca38, l_eca39,
						   l_eca40, l_eca41, l_ecb03, l_ecb18, l_ecb19,
						   l_ecb20, l_ecb21, l_ecb22, l_ecb23,
						   l_ecb24, l_ecb25, l_ecb15, l_ecb16,l_ima561
  IF SQLCA.sqlcode = NOTFOUND THEN EXIT WHILE END IF
  LET yn=yn+1     #判斷是否有製程資料
 
  IF l_ecb16 IS NULL OR  l_ecb16=0 THEN LET l_ecb16=1 END IF
  IF l_ima561 IS NULL OR  l_ima561=0 THEN LET l_ima561=1 END IF
  IF l_ecb21  IS NULL OR  l_ecb21=0 THEN LET l_ecb21=1 END IF
     LET setup_cost=0   LET run_cost=0
     LET lab_hour  =0   LET mat_hour=0
     LET mat_setup =0   LET mat_run =0
  IF l_eca04 ='0'  #正常工作站
	 THEN
	   CASE l_eca06
	   WHEN '2'   #人工產能
		  IF l_eca14='2'   #unit/hour   #僅run time 考慮,因為設置成本都以hr/unit
			 THEN LET setup_cost=(l_ecb18/l_ima561/60*l_eca16)   #設置成本
			      LET   run_cost=(1/l_ecb19/60*l_eca18)          #生產成本
                 LET x_csa0303=setup_cost+run_cost  #本站成本
                 LET l_csa0303=l_csa0303 +      #直接人工成本
				                setup_cost+     #設置成本
					              run_cost      #生產成本
                  LET x_lab_hour= (l_ecb18/l_ima561/60) #本站人工小時
							    +(1/l_ecb19/60)
		          LET lab_hour =lab_hour +      #直接人工小時
                                x_lab_hour
			 ELSE LET setup_cost=(l_ecb18/l_ima561/60*l_eca16)    #設置成本
                  LET   run_cost=(l_ecb19/60*l_eca18)             #生產成本
                  LET x_csa0303=setup_cost+run_cost  #本站成本
                  LET l_csa0303=l_csa0303 +      #直接人工成本
                                x_csa0303
                  LET x_lab_hour=(l_ecb18/l_ima561/60)
							    +(l_ecb19/60)
		          LET lab_hour=lab_hour +        #直接人工小時
                               x_lab_hour
		   END IF
	   WHEN '1'  #機器產能
		  IF l_eca14='2'  #unit/hour
			 THEN  #--------直接人工成本-----#
				   LET setup_cost=(l_ecb20/l_ima561/60*l_ecb15/l_ecb16*l_eca16)
				   LET   run_cost=(1/l_ecb21/60*l_ecb15/l_ecb16*l_eca18)
                   LET x_csa0303=setup_cost+run_cost
				   LET l_csa0303=l_csa0303 +      #直接人工成本
                                 x_csa0303
				   #--------直接人工小時----#
                  LET x_lab_hour= (l_ecb20/l_ima561/60*l_ecb15/l_ecb16)
							    + (1/l_ecb21/60*l_ecb15/l_ecb16)
				  LET lab_hour =lab_hour +      #直接人工小時
                                x_lab_hour
                 #--------機器成本---------#
				  LET  mat_setup =(l_ecb20/l_ima561/60*l_eca20) #機器設置成本
				  LET  mat_run   =(1/l_ecb21/60*l_eca201)       #機器生產成本
                  LET x_csa0310= mat_setup+mat_run #本站機器成本
				  LET l_csa0310= l_csa0310+       #機器成本
                                 x_csa0310
				  #------機器小時----------#
                  LET x_mat_hour= (l_ecb20/l_ima561/60)
							    + (1/l_ecb21/60)
				  LET mat_hour=mat_hour+       #機器小時
                               x_mat_hour
			 ELSE  #--------直接人工成本-----#
				   LET setup_cost=(l_ecb20/l_ima561/60*l_ecb15/l_ecb16*l_eca16)
				   LET run_cost=(l_ecb21/60*l_ecb15/l_ecb16*l_eca18)
                   LET x_csa0303=setup_cost+run_cost
				   LET l_csa0303=l_csa0303 +     #直接人工成本
                                 x_csa0303
				   #--------直接人工小時----#
                   LET x_lab_hour= (l_ecb20/l_ima561/60*l_ecb15/l_ecb16)
							     + (l_ecb21/60*l_ecb15/l_ecb16)
				   LET lab_hour =lab_hour +      #直接人工小時
                                 x_lab_hour
                 #--------機器成本---------#
				  LET  mat_setup =(l_ecb20/l_ima561/60*l_eca20) #機器設置成本
				  LET  mat_run   =(l_ecb21/60*l_eca201)         #機器生產成本
                  LET x_csa0310= mat_setup+mat_run
				  LET l_csa0310= l_csa0310+       #機器成本
								 mat_setup+       #機器設置成本
								 mat_run          #機器生產成本
				  #------機器小時----------#
                  LET x_mat_hour= (l_ecb20/l_ima561/60)
							    +(l_ecb21/60)
				  LET mat_hour =mat_hour +       #機器小時
                                x_mat_hour
			END IF
	END CASE
#---->計算indirect labor cost
#---->當為人工產能只能以[1256]計算其製/費用
#---->當為機器產能只能以[3456]計算其製/費用
#     直接人工成本*直接人工製/費用分攤率
           LET t_csa0304=x_csa0303*w_ima873
           LET l_csa0304=l_csa0304+t_csa0304
           CASE l_eca15
                   WHEN '1' #直接人工成本
                   IF l_eca06 = '2'    #人工產能
                     THEN LET t_csa0305=x_csa0303*l_eca22
                          LET t_csa0306=x_csa0303*l_eca24
                          LET l_csa0305=l_csa0305+t_csa0305
                          LET l_csa0306=l_csa0306+t_csa0306
                   END IF
                   WHEN '2' #直接人工小時
                   IF l_eca06 = '2'
                     THEN LET t_csa0305=x_lab_hour*l_eca22
                          LET t_csa0306=x_lab_hour*l_eca24
                          LET l_csa0305=l_csa0305+t_csa0305
                          LET l_csa0306=l_csa0306+t_csa0306
                   END IF
                   WHEN '3' #機器成本
                    IF l_eca06='1'      #機器產能
                      THEN LET t_csa0305=x_csa0310*l_eca22
                           LET t_csa0306=x_csa0310*l_eca24
                           LET l_csa0305=l_csa0305+t_csa0305
                           LET l_csa0306=l_csa0306+t_csa0306
                    END IF
                   WHEN '4' #機器小時
                    IF l_eca06='1'      #機器產能
                       THEN LET t_csa0305=x_mat_hour*l_eca22
                            LET t_csa0306=x_mat_hour*l_eca24
                            LET l_csa0305=l_csa0305+t_csa0305
                            LET l_csa0306=l_csa0306+t_csa0306
                    END IF
                   WHEN '5' #直接材料成本
                    LET t_csa0305=w_material*l_eca22
                    LET t_csa0306=w_material*l_eca24
                    LET l_csa0305=l_csa0305+t_csa0305
                    LET l_csa0306=l_csa0306+t_csa0306
                   WHEN '6' #生產數量
                    LET t_csa0305=l_eca22
                    LET t_csa0306=l_eca24
                    LET l_csa0305=l_csa0305+t_csa0305
                    LET l_csa0306=l_csa0306+t_csa0306
                   OTHERWISE
                    LET l_csa0305= l_csa0305+0
                    LET l_csa0306= l_csa0306+0
                  END CASE
#----------->增加各成本要素的成本項目
#---因此段在使用cost center算時, 被使用到(在廠外加工資料取得方式='2' 時)
        IF g_sma.sma58 MATCHES '[Yy]'
           THEN
#-----人工設置成本項目-----
               IF l_flag!='c'   #'c' 表在使用cost center方式時,已產生過了
                  THEN IF l_eca17 IS NULL THEN LET l_eca17=' ' END IF
                       CALL insert_cote (w_item,l_eca17,setup_cost,'1')
                            LET setup_cost=0
               END IF
#-----人工生產成本項目-----
              IF l_flag!='c'   #'c' 表在使用cost center方式時,已產生過了
                 THEN IF l_eca19 IS NULL THEN LET l_eca19=' ' END IF
                     CALL insert_cote (w_item,l_eca19,run_cost,'1')
                          LET run_cost=0
              END IF
#-----間接人工成本項目-----
              IF l_flag!='c'
                 THEN IF w_ima874 IS NULL THEN LET w_ima874=' ' END IF
                      CALL insert_cote
                           (w_item,w_ima874,t_csa0304,'1')
               END IF
#-----機器設置成本項目-----
              IF l_eca21 IS NULL THEN LET l_eca21=' ' END IF
              CALL insert_cote (w_item,l_eca21,mat_setup,'1')
#-----機器生產成本項目-----
              IF l_eca211 IS NULL THEN LET l_eca211=' ' END IF
              CALL insert_cote (w_item,l_eca211,mat_run,'1')
#-----固定製/費用成本項目
             IF l_flag!='c'   #'c' 表在使用cost center方式時,已產生過了
                THEN IF l_eca23 IS NULL THEN LET l_eca23=' ' END IF
                     CALL insert_cote (w_item,l_eca23,t_csa0305,'1')
             END IF
#-----變動製/費用成本項目
            IF l_flag!='c'   #'c' 表在使用cost center方式時,已產生過了
               THEN IF l_eca25 IS NULL THEN LET l_eca25=' ' END IF
                    CALL insert_cote (w_item,l_eca25,t_csa0306,'1')
            END IF
 ELSE   #廠外/廠內加工
     LET l_csa0307=l_csa0307+l_ecb23
     IF l_eca04 = '2' #廠內加工
        THEN LET t_csa0308=l_ecb23*l_eca38
             LET t_csa0309=l_ecb23*l_eca40
             LET l_csa0308=l_csa0308+t_csa0308
             LET l_csa0309=l_csa0309+t_csa0309
     END IF
#-----廠外加工成本項目
    IF g_sma.sma58 MATCHES '[Yy]'
       THEN IF l_eca37 IS NULL THEN LET l_eca37=' ' END IF
            CALL insert_cote (w_item,l_eca37,l_ecb23,'1')
#-----廠外加工固定製/費用成本項目
            IF l_eca39 IS NULL THEN LET l_eca39=' ' END IF
            CALL insert_cote (w_item,l_eca39,t_csa0308,'1')
#-----廠外加工變動製/費用成本項目
           IF l_eca41 IS NULL THEN LET l_eca41=' ' END IF
           CALL insert_cote (w_item,l_eca41,t_csa0309,'1')
        END IF
     END IF
END IF
 
END WHILE
CLOSE wc_rout_cur
IF yn=0
   THEN  CALL cl_err(w_item,'mfg6030',1)
            CALL p100_restore()
            CALL p100_unlock2()                 #UNLOCK
            CALL cl_batch_bg_javamail("N")      #NO.FUN-570142
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
   END IF
 
#----->附加成本(add values)
 IF l_flag !='c'
    THEN CALL s_add_val(w_item,'1',tm.version)  RETURNING l_csa0312
 END IF
#--->算出結果為生產單位, 需轉成成本單位
   SELECT ima55,ima86 INTO l_ima55,l_ima86 FROM ima_file WHERE ima01=w_item
   IF SQLCA.sqlcode THEN LET l_ima55=' '   LET l_ima86=' ' END IF
   IF l_ima55 != l_ima86
      THEN CALL  s_umfchk(w_item,l_ima55,l_ima86) returning p_flag,l_factor
           IF p_flag THEN CALL cl_err(w_item,'mfg6043',1)
                          CALL p100_restore()
                          CALL p100_unlock2()                 #UNLOCK
                          CALL cl_batch_bg_javamail("N")      #NO.FUN-570142
                          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
                          EXIT PROGRAM
           END IF
           LET l_csa0303=l_csa0303*l_factor
           LET l_csa0304=l_csa0304*l_factor
           LET l_csa0305=l_csa0305*l_factor
           LET l_csa0306=l_csa0306*l_factor
           LET l_csa0307=l_csa0307*l_factor
           LET l_csa0308=l_csa0308*l_factor
           LET l_csa0309=l_csa0309*l_factor
           LET l_csa0310=l_csa0310*l_factor
   END IF
# l_csa0312 為成本單位,故不需轉換
RETURN l_csa0303,l_csa0304,l_csa0305,l_csa0306,
       l_csa0307,l_csa0308,l_csa0309,l_csa0310,
       l_csa0312,0
END FUNCTION
FUNCTION insert_csc()
 
   INSERT INTO csc_file (csc01   ,   csc02    ,   csc03    ,
                         csc04   ,   csc05    ,   csc06    ,
                         csc07   ,   csc08    ,   csc09    ,
						 csc10   ,   csc11    ,   csc12    ,
						 csc13   ,   csc14    ,   csc15    ,
						 csc16 )
				VALUES(tm.version,   '1'      ,  g_today   ,
					   l_time    ,  p_time    ,  g_user    ,
					   tm.item_no,tm.effectiv ,   1        ,
					   tm.free_stock,tm.m_pur ,tm.p_mak    ,
#				       tm.lab_bud   ,tm.p_cost,' '         ,
 				       tm.lab_bud   ,'Y'      ,tm.x        ,
					   tm.h)
  IF SQLCA.sqlcode =0
	 THEN #message '成本模擬檔新增完成!!! '
	 ELSE error   '成本模擬檔新失敗!! '
  END IF
 
  DELETE from csb_file where csb05=0 or csb05 is null
 
END FUNCTION
#Patch....NO.TQC-610035 <001> #
#TQC-790177
