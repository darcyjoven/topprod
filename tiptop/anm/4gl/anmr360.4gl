# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmr360.4gl
# Descriptions...: 銀行存款匯差調整明細表
# Date & Author..: 94/04/22 By Apple
#                : 96/06/14 By Lynn  銀行編號(nmp01) 取6碼
# Modify.........: No.9022 04/01/08 Kammy Count nme_file時，少了年月條件
# Modify.........: No.MOD-4A0041 04/10/05 By Mandy Oracle DEFINE ROWID_NO INTEGER  應該轉為char(18)
# Modify.........: No.MOD-4A0041 在convert 作業中_rowid 才會做正確的轉換
# Modify.........: No.MOD-4B0028 04/11/09 By Nicola 本程式須tm.chg matches '[yY]'才須做insert動作!!
# Modify.........: No.FUN-4C0098 05/01/03 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.MOD-730026 07/03/07 By Smapmin 修改幣別取位問題
# Modify.........: No.FUN-740028 07/04/10 By ARMAN  會計科目加帳套
# Modify.........: No.FUN-750151 07/06/15 By kim ins_nme 請標準化 , 建 p_ze 抓!
# Modify.........: No.FUN-7A0036 07/11/07 By lutingting  修改為用Crystal Report
# Modify.........: No.FUN-870151 08/08/19 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.FUN-840015 08/08/27 By xiaofeizhu 相關nmz35的地方都要判斷，分為匯差利得(nmz23)/匯差損失(nmz53)
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/23 By baofei GP集團架構修改,sub相關參數 
# Modify.........: No.FUN-980025 09/09/23 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.FUN-9C0012 09/12/02 By ddestiny nem_file补PK，在insert表时给PK字段预设值
# Modify.........: No:CHI-B20020 10/02/23 By Summer 1.當產生異動記錄為 N 時,若當月已有 nme_file,則詢問是否刪除,如詢問需要刪除再于以刪除
#                                                   2.當產生異動記錄為 Y 時,無條件先刪除再重新產生當月 nme_file
# Modify.........: No:FUN-B20073 11/02/24 By lilingyu 科目查詢自動過濾-hcode
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No.FUN-B40056 11/06/07 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/18 By elva 现金流量表修正
# Modify.........: No:TQC-B70209 11/07/29 By guoch tic_file删除时逻辑错误，进行bug修复
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file 
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file 
# Modify.........: No:MOD-BB0308 11/11/28 By Sarah 修正CHI-B20020,SQL裡使用tm.sdate過濾資料時應用nme16而非nme02
# Modify.........: No.MOD-C40136 12/04/24 By Polly 1.增加nms13欄位匯兌損失科目，並將nmc04改為nms12匯兌盈餘科目
# Modify.........: No.MOD-C80046 12/08/07 By Polly 寫入nme08時，取消小於零將nme08乘以-1的動作
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		      
              wc    LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(600)
	            sdate LIKE type_file.dat,    #No.FUN-680107 DATE
              scur  LIKE azi_file.azi01,         #No.FUN-680107 VARCHAR(4)
              sex   LIKE nme_file.nme07,         #No.FUN-680107 DEC(8,4)
              chg   LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
             #nmc04 LIKE nmc_file.nmc04,         #MOD-C40136 mark
              nms12 LIKE nms_file.nms12,         #MOD-C40136 add
              nms13 LIKE nms_file.nms13,         #MOD-C40136 add
              more  LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
              END RECORD,
          t_azi04_2 LIKE azi_file.azi04,       #NO.CHI_6A0004
          g_nmc04   LIKE nmc_file.nmc04, 
          g_nmc05   LIKE nmc_file.nmc05, 
        g_plant_gl  LIKE type_file.chr10,       #No.FUN-980025 VARCHAR(10)
	  g_dbs_gl  LIKE type_file.chr21        #No.FUN-680107 VARCHAR(21)
 
DEFINE    g_cnt     LIKE type_file.num10        #No.FUN-680107 INTEGER
DEFINE    g_i       LIKE type_file.num5         #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE    g_msg     LIKE type_file.chr1000      #No.FUN-680107 VARCHAR(72)
DEFINE    g_head1   STRING
DEFINE    l_table   STRING                      #No.FUN-7A0036
DEFINE    g_str     STRING                      #No.FUN-7A0036
DEFINE    g_sql     STRING                      #No.FUN-7A0036
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
#No.FUN-7A0036--start--
   LET g_sql = "nmp01.nmp_file.nmp01,",
               "nma02.nma_file.nma02,",
               "nmp16.nmp_file.nmp16,",
               "nmp19.nmp_file.nmp19,",
               "local.nmp_file.nmp19,",
               "diff.nmp_file.nmp19,",
               "azi04.azi_file.azi04,",
               "azi07.azi_file.azi07 "       #No.FUN-870151
   LET l_table = cl_prt_temptable('anmr360',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES (?,?,?,?,?,?,?,?)"  #No.FUN-870151 Add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-7A0036--end--
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.sdate  = ARG_VAL(8)
   LET tm.scur   = ARG_VAL(9)
   LET tm.sex    = ARG_VAL(10)
   LET tm.chg    = ARG_VAL(11)
  #LET tm.nmc04  = ARG_VAL(12)    #MOD-C40136 mark
   LET tm.nms12  = ARG_VAL(12)    #MOD-C40136 add
   LET tm.nms13  = ARG_VAL(13)    #MOD-C40136 add
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr360_tm()	        	# Input print condition
      ELSE CALL anmr360()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr360_tm()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col LIKE type_file.num5,   #No.FUN-680107 SMALLINT
       l_cmd	   LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(400)
       l_flag      LIKE type_file.chr1,   #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
       l_jmp_flag  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 5 LET p_col = 12
   OPEN WINDOW anmr360_w AT p_row,p_col
        WITH FORM "anm/42f/anmr360" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.sdate = g_today
   LET tm.chg  = 'N'
   LET tm.more = 'N'    
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_plant_new = g_nmz.nmz02p
   LET g_plant_gl = g_nmz.nmz02p
  #-------------------MOD-C40136------------------(S)
   IF g_nmz.nmz11 = 'N' THEN
      SELECT nms12,nms13 INTO tm.nms12,tm.nms13
        FROM nms_file
       WHERE (nms01 = ' ' OR nms01 IS NULL)
   END IF
  #-------------------MOD-C40136------------------(E)
   CALL s_getdbs()
   LET g_dbs_gl = g_dbs_new 
#  SELECT nmc04,nmc05 INTO tm.nmc04,g_nmc05 FROM nmc_file          #FUN-840015 MARK 
#                    WHERE nmc01 = g_nmz.nmz35                     #FUN-840015 MARK
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nma01
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmauser', 'nmagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
		 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmr360_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
  #INPUT BY NAME tm.sdate,tm.scur,tm.sex,tm.nmc04,tm.chg,tm.more             #MOD-C40136 mark
   INPUT BY NAME tm.sdate,tm.scur,tm.sex,tm.nms12,tm.nms13,tm.chg,tm.more    #MOD-C40136 add
                   WITHOUT DEFAULTS 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD chg  
         IF tm.chg IS NULL OR tm.chg NOT MATCHES'[YN]'
         THEN NEXT FIELD chg 
         END IF
 
      AFTER FIELD scur 
         IF tm.scur IS NULL OR tm.scur = ' ' OR tm.scur = g_aza.aza17  
         THEN NEXT FIELD scur 
         ELSE SELECT azi04 INTO t_azi04_2 FROM azi_file  #NO.CHI-6A0004  
                           WHERE azi01 = tm.scur
                             AND aziacti IN ('y','Y')
              IF SQLCA.sqlcode THEN 
                 CALL cl_err(tm.scur,'anm-007',0)
                 NEXT FIELD scur
              END IF
         END IF
 
      AFTER FIELD sex  
         IF tm.sex IS NULL OR tm.sex <=0 
         THEN NEXT FIELD sex 
         END IF

     #-----------------------------------------MOD-C40136-------------------------------(S)
     #--MOD-C40136--mark
     #AFTER FIELD nmc04
     #   IF tm.nmc04 IS NULL OR tm.nmc04 = ' ' THEN 
     #      NEXT FIELD nmc04
     #   ELSE 
     #      IF g_nmz.nmz02 = 'Y' THEN
     #        #CALL s_m_aag(g_dbs_gl,tm.nmc04,g_aza.aza81) RETURNING g_msg   #NO.FUN-740028  #FUN-990069
     #         CALL s_m_aag(g_nmz.nmz02p,tm.nmc04,g_aza.aza81) RETURNING g_msg   #NO.FUN-740028      #FUN-990069
     #         IF NOT cl_null(g_errno) THEN
     #            CALL cl_err('',g_errno,0)
     #           #FUN-B20073 --begin--
     #            CALL q_m_aag(FALSE,FALSE,g_plant_gl,tm.nmc04,'23',g_aza.aza81) 
     #                 RETURNING tm.nmc04     
     #            DISPLAY BY NAME tm.nmc04                      
     #           #FUN-B20073 --end--            
     #            NEXT FIELD nmc04
     #         END IF
     #      END IF
     #   END IF
     #--MOD-C40136--mark

      AFTER FIELD nms12
         IF tm.nms12 IS NULL OR tm.nms12 = ' ' THEN
            NEXT FIELD nms12
         ELSE
            IF g_nmz.nmz02 = 'Y' THEN
               CALL s_m_aag(g_nmz.nmz02p,tm.nms12,g_aza.aza81) RETURNING g_msg
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  CALL q_m_aag(FALSE,FALSE,g_plant_gl,tm.nms12,'23',g_aza.aza81)
                  RETURNING tm.nms12
                  DISPLAY BY NAME tm.nms12
                  NEXT FIELD nms12
               END IF
            END IF
         END IF

      AFTER FIELD nms13
         IF tm.nms13 IS NULL OR tm.nms13 = ' ' THEN
            NEXT FIELD nms13
         ELSE
            IF g_nmz.nmz02 = 'Y' THEN
               CALL s_m_aag(g_nmz.nmz02p,tm.nms13,g_aza.aza81) RETURNING g_msg
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  CALL q_m_aag(FALSE,FALSE,g_plant_gl,tm.nms13,'23',g_aza.aza81)
                  RETURNING tm.nms13
                  DISPLAY BY NAME tm.nms13
                  NEXT FIELD nms13
               END IF
            END IF
         END IF
     #-----------------------------------------MOD-C40136-------------------------------(E)
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL 
            OR cl_null(tm.more)
         THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
     AFTER INPUT 
       IF INT_FLAG THEN EXIT INPUT  END IF
       IF tm.sdate IS NULL OR tm.sdate = ' ' THEN  
           DISPLAY BY NAME tm.sdate 
           NEXT FIELD sdate
       END IF
       IF tm.sex IS NULL OR tm.sex = ' ' OR tm.sex <= 0
       THEN DISPLAY BY NAME tm.sex 
            NEXT FIELD sex  
       END IF
 
    ON ACTION CONTROLP
       CASE
         WHEN INFIELD(scur)
             #CALL q_azi(10,26,tm.scur) RETURNING tm.scur  
             #CALL FGL_DIALOG_SETBUFFER( tm.scur )
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_azi'
              LET g_qryparam.default1 = tm.scur
              CALL cl_create_qry() RETURNING tm.scur
             #CALL FGL_DIALOG_SETBUFFER( tm.scur )
              DISPLAY BY NAME tm.scur    
              NEXT FIELD scur
        #-------------------------------MOD-C40136---------------------------------------(S)
        #--MOD-C40136-mark
        #WHEN INFIELD(nmc04)
        #    #CALL q_m_aag(10,10,g_dbs_gl,tm.nmc04,'23') RETURNING tm.nmc04
        #    #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,tm.nmc04,'23',g_aza.aza81) RETURNING tm.nmc04         #NO.FUN-740028   #No.FUN-980025
        #     CALL q_m_aag(FALSE,TRUE,g_plant_gl,tm.nmc04,'23',g_aza.aza81) RETURNING tm.nmc04       #No.FUN-980025
        #    #CALL FGL_DIALOG_SETBUFFER( tm.nmc04 )
        #     DISPLAY BY NAME tm.nmc04  
        #     NEXT FIELD nmc04 
        #--MOD-C40136-mark

         WHEN INFIELD(nms12)
            CALL q_m_aag(FALSE,TRUE,g_plant_gl,tm.nms12,'23',g_aza.aza81) RETURNING tm.nms12
            DISPLAY BY NAME tm.nms12
            NEXT FIELD nms12

         WHEN INFIELD(nms13)
            CALL q_m_aag(FALSE,TRUE,g_plant_gl,tm.nms13,'23',g_aza.aza81) RETURNING tm.nms13
            DISPLAY BY NAME tm.nms13
            NEXT FIELD nms13
        #-------------------------------MOD-C40136---------------------------------------(E)

         OTHERWISE EXIT CASE
       END CASE

   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmr360_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr360'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('anmr360','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,	
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang   CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.sdate CLIPPED,"'",
                         " '",tm.scur  CLIPPED,"'",
                         " '",tm.sex   CLIPPED,"'",
                         " '",tm.chg   CLIPPED,"'",
                        #" '",tm.nmc04  CLIPPED,"'",            #TQC-610058 #MOD-C40136 mark
                         " '",tm.nms12  CLIPPED,"'",            #MOD-C40136 add
                         " '",tm.nms13  CLIPPED,"'",            #MOD-C40136 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr360',g_time,l_cmd)	
      END IF
      CLOSE WINDOW anmr360_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr360()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr360_w
END FUNCTION
   
FUNCTION anmr360()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05	LIKE type_file.chr1000,         #No.FUN-680107 VARCHAR(40)
          sr            RECORD 
		  nmp01 LIKE nmp_file.nmp01, nmp02 LIKE nmp_file.nmp02,nmp03 LIKE nmp_file.nmp03,   #銀行編號
                  nma02  LIKE nma_file.nma02,   #簡稱
                  nma10  LIKE nma_file.nma10,   #存款幣別
		  nmp16  LIKE nmp_file.nmp16,   #結存(原幣)
		  nmp19  LIKE nmp_file.nmp19,   #結存(本幣)
                  local  LIKE nmp_file.nmp19,   #調整後金額(本幣)
                  diff   LIKE nmp_file.nmp19    #匯差調整(本幣)
              END RECORD,
              l_year   LIKE type_file.num10,    #No.FUN-680107 INTEGER
              l_month  LIKE type_file.num10     #No.FUN-680107 INTEGER
   DEFINE l_del	       LIKE type_file.chr1      #CHI-B20020 add
   DEFINE l_msg1       LIKE type_file.chr1000   #CHI-B20020 add
   DEFINE l_msg2       LIKE type_file.chr1000   #CHI-B20020 add
   DEFINE l_msg3       LIKE type_file.chr1000   #CHI-B20020 add
   DEFINE l_yy,l_mm    STRING                   #CHI-B20020 add
   DEFINE l_nme08      LIKE nme_file.nme08      #金額(本幣) #CHI-B20020 add
 
     CALL cl_del_data(l_table)                  #No.FUN-7A0036
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'anmr360'   #No.FUN-7A0036
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#NO.CHI-6A0004--BEGIN
#     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
# 		FROM azi_file WHERE azi01 = g_aza.aza17  
#
#       IF SQLCA.sqlcode THEN 
#         CALL cl_err(g_azi04,SQLCA.sqlcode,0)    #No.FUN-660148
#          CALL cl_err3("sel","azi_file",g_aza.aza17,"",SQLCA.sqlcode,"","",0) #No.FUN-660148
#       END IF
#NO.CHI-6A0004--END 
#  CALL cl_outnam('anmr360') RETURNING l_name     #No.FUN-7A0036  Mark
#  START REPORT anmr360_rep TO l_name             #No.FUN-7A0036  Mark
#  LET g_pageno  = 0                              #No.FUN-7A0036  Mark 
   LET g_success ='Y'
   LET l_year   = YEAR(tm.sdate)
   LET l_month  = MONTH(tm.sdate)
   LET l_sql = "SELECT nmp01,nmp02,nmp03,nma02,nma10,",
               " nmp16,nmp19,'','' ",
               " FROM  nmp_file, nma_file ",
               " WHERE nmp01 = nma01 ",
               "   AND nma10 = '",tm.scur,"'",       #幣別
               "   AND nmp02 = ",l_year,             #年別
               "   AND nmp03 = ",l_month,            #期別
               "   AND ",tm.wc clipped
    PREPARE anmr360_prepare FROM l_sql
    DECLARE anmr360_curs CURSOR FOR anmr360_prepare
    #CHI-B20020 add --start--
    LET l_del = 'N'
    IF tm.chg matches '[nN]' THEN 
       LET g_cnt = 0
       LET l_sql = "SELECT COUNT(*) FROM nme_file ",
                   " WHERE nme12 = 'adjust'",
                  #"   AND YEAR(nme02) = ",l_year,   #MOD-BB0308 mark
                  #"   AND MONTH(nme02)= ",l_month,  #MOD-BB0308 mark
                   "   AND YEAR(nme16) = ",l_year,   #MOD-BB0308
                   "   AND MONTH(nme16)= ",l_month,  #MOD-BB0308
                   "   AND nme01 IN (SELECT nma01 FROM nma_file WHERE ",tm.wc clipped,")"
       PREPARE r360_p1 FROM l_sql
       DECLARE r360_c1 CURSOR FOR r360_p1
       OPEN r360_c1
       FETCH r360_c1 INTO g_cnt 
       CLOSE r360_c1
       IF g_cnt > 0 THEN
          LET l_yy = l_year
          LET l_mm = l_month
          CALL cl_getmsg('anm-156',g_lang) RETURNING l_msg1
          CALL cl_getmsg('anm-157',g_lang) RETURNING l_msg2
          CALL cl_getmsg('anm-155',g_lang) RETURNING l_msg3
          LET g_msg =  l_yy.trim() ,l_msg1 CLIPPED,l_mm.trim() ,l_msg2 CLIPPED,l_msg3 CLIPPED
          IF cl_confirm(g_msg) THEN
             LET l_del = 'Y'
          END IF
       END IF
    END IF
    #CHI-B20020 add --end--
   #IF tm.chg matches '[yY]' THEN   #MOD-4B0028 #CHI-B20020 mark
    IF tm.chg matches '[yY]' OR l_del = 'Y' THEN   #CHI-B20020
       BEGIN WORK
    END IF
    FOREACH anmr360_curs INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach',SQLCA.sqlcode,0)
           LET g_success = 'N'   #MOD-4B0028 
          EXIT FOREACH
       END IF
       #CHI-B20020 add --start--
       LET l_nme08 = 0
       IF tm.chg matches '[yY]' OR l_del = 'Y' THEN
          CALL r360_del_nme(sr.nmp01,sr.nmp02,sr.nmp03) RETURNING l_nme08
       END IF
       #CHI-B20020 add --end--
       LET sr.local =  sr.nmp16 * tm.sex
      #LET sr.diff  =  sr.local - sr.nmp19 #CHI-B20020 mark
       LET sr.diff  =  sr.local - (sr.nmp19 - l_nme08) #CHI-B20020
       LET sr.diff = cl_digcut(sr.diff,g_azi04)   #MOD-730026
#       EXECUTE insert_prep USING                                          #No.FUN-7A0036
#         sr.nmp01,sr.nma02,sr.nmp16,sr.nmp19,sr.local,sr.diff,t_azi04_2   #No.FUN-7A0036
#      OUTPUT TO REPORT anmr360_rep(sr.*)                                  #No.FUN-7A0036  Mark
       IF tm.chg matches'[Yy]' AND sr.diff != 0 THEN
          IF sr.diff > 0 THEN                                              #No.FUN-840015 
             SELECT COUNT(*) INTO g_cnt FROM nme_file
              WHERE nme01 = sr.nmp01
                AND nme03 = g_nmz.nmz35
                AND nme12 = 'adjust'  #no.6001
               #AND YEAR(nme02) = l_year   #No.9022   #MOD-BB0308 mark
               #AND MONTH(nme02)= l_month  #No.9022   #MOD-BB0308 mark
                AND YEAR(nme16) = l_year   #No.9022   #MOD-BB0308
                AND MONTH(nme16)= l_month  #No.9022   #MOD-BB0308
          ELSE                                                             #No.FUN-840015
             SELECT COUNT(*) INTO g_cnt FROM nme_file                      #No.FUN-840015
              WHERE nme01 = sr.nmp01                                       #No.FUN-840015
                AND nme03 = g_nmz.nmz53                                    #No.FUN-840015
                AND nme12 = 'adjust'                                       #No.FUN-840015
               #AND YEAR(nme02) = l_year                                   #No.FUN-840015  #MOD-BB0308 mark
               #AND MONTH(nme02)= l_month                                  #No.FUN-840015  #MOD-BB0308 mark
                AND YEAR(nme16) = l_year                                   #No.FUN-840015  #MOD-BB0308
                AND MONTH(nme16)= l_month                                  #No.FUN-840015  #MOD-BB0308
          END IF                                                           #No.FUN-840015
         { #No.B367 010416 by plum 不管有無資料,都應ins nme
          IF g_cnt > 0 THEN
             CALL cl_err('',-239,0)
             IF NOT cl_confirm('axm-108') THEN CONTINUE FOREACH END IF
              CALL r360_ins_nme(sr.nmp01,sr.diff,sr.nmp02,sr.nmp03) #MOD-4A0041
          END IF
         }
          IF g_cnt > 0 THEN
             CALL cl_err(sr.nmp01,-239,1)
          ELSE
              CALL r360_ins_nme(sr.nmp01,sr.diff,sr.nmp02,sr.nmp03) #MOD-4A0041
          END IF
         #No.B367 ...end
       END IF
       SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01 = tm.scur  #No.FUN-870151
       EXECUTE insert_prep USING                                          #No.FUN-7A0036                                    
           sr.nmp01,sr.nma02,sr.nmp16,sr.nmp19,sr.local,sr.diff,t_azi04_2   #No.FUN-7A0036 
           ,t_azi07   #No.FUN-870151
    END FOREACH
     
   #IF tm.chg matches '[yY]' THEN #CHI-B20020 mark
    IF tm.chg matches '[yY]' OR l_del = 'Y' THEN   #CHI-B20020
       IF g_success = 'Y' THEN
          CALL cl_cmmsg(1)
          COMMIT WORK
       ELSE
          CALL cl_rbmsg(1)
          ROLLBACK WORK
       END IF
    END IF
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(tm.wc,'nma01')                                                                                                 
           RETURNING tm.wc                                                                                                          
    LET g_str = tm.wc                                                                                                               
    END IF 
    LET g_str = tm.wc,";",tm.sdate,";",tm.scur,";",tm.sex,";",g_azi04
    CALL cl_prt_cs3('anmr360','anmr360',g_sql,g_str)
#   FINISH REPORT anmr360_rep                     #No.FUN-7A0036  Mark  
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #No.FUN-7A0036  Mark
END FUNCTION
   
 FUNCTION r360_ins_nme(p_nmp01,p_nme08,p_nmp02,p_nmp03) #MOD-4A0041
  DEFINE p_nmp01 LIKE nmp_file.nmp01, p_nmp02 LIKE nmp_file.nmp02, p_nmp03 LIKE nmp_file.nmp03,    #銀行編號
          p_nme08  LIKE nme_file.nme08,    #金額(本幣)
          l_refno  LIKE nme_file.nme12,
          g_nme    RECORD LIKE nme_file.*
#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
 
    LET g_nme.nme00 = 0            
    LET g_nme.nme01 = p_nmp01              #銀行編號
    LET g_nme.nme02 = TODAY                #異動日期
    IF p_nme08 > 0 THEN                    #FUN-840015
       LET g_nme.nme03 = g_nmz.nmz35       #異動碼
    ELSE                                   #FUN-840015
       LET g_nme.nme03 = g_nmz.nmz53       #FUN-840015
    END IF                                 #FUN-840015   
   #LET g_nme.nme04 = p_nme08 / tm.sex     #金額(原幣)
    LET g_nme.nme04 = 0                    #金額(原幣)
   #LET g_nme.nme05 = '匯差調整'           #摘要 #FUN-750151
    LET g_nme.nme05 = cl_getmsg('anm-121',g_lang) #摘要 #FUN-750151
   #--------------------------MOD-C40136-------------------(S)
    IF p_nme08 < 0 THEN
      #LET g_nme.nme06 = tm.nmc04             #對方科目  #MOD-C40136 mark
       LET g_nme.nme06 = tm.nms13             #對方科目
      #LET p_nme08 = p_nme08 * -1             #MOD-C80046 mark
    ELSE
       LET g_nme.nme06 = tm.nms12
    END IF
   #--------------------------MOD-C40136-------------------(E)
    LET g_nme.nme07 = tm.sex               #匯率    
    LET g_nme.nme08 = p_nme08              #本幣金額     
    LET g_nme.nme12 = 'adjust'             #參考單號  no.6001
    LET g_nme.nme16 = tm.sdate
    LET g_nme.nme14 = g_nmc05              #現金變動碼
    LET g_nme.nme22 = '07'   #CHI-B20020 add
    LET g_nme.nmeacti = 'Y'
    LET g_nme.nmegrup = g_grup
    LET g_nme.nmeuser = g_user
    LET g_nme.nmedate = g_today
    #FUN-980005 add legal 
    LET g_nme.nmelegal = g_legal
    LET g_nme.nme21=1     #No.FUN-9C0012 
    #FUN-980005 end legal 
    LET g_nme.nmeoriu = g_user      #No.FUN-980030 10/01/04
    LET g_nme.nmeorig = g_grup      #No.FUN-980030 10/01/04

#FUN-B30166--add--str
   LET l_date1 = g_today
   LET l_year = YEAR(l_date1)USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_time = TIME(CURRENT)
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   SELECT MAX(nme27) + 1 INTO g_nme.nme27 FROM nme_file
    WHERE nme27[1,14] = l_dt
   IF cl_null(g_nme.nme27) THEN
      LET g_nme.nme27 = l_dt,'000001'
   END if
#FUN-B30166--add--end

    INSERT INTO nme_file VALUES(g_nme.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err('r360_ins_nme:',SQLCA.sqlcode,1)   #No.FUN-660148
        CALL cl_err3("ins","nme_file",g_nme.nme02,"",SQLCA.sqlcode,"","r360_ins_nme:",1) #No.FUN-660148
        LET g_success = 'N' 
    END IF                          
    CALL s_flows_nme(g_nme.*,'1',g_plant)   #No.FUN-B90062  
    UPDATE nmp_file SET nmp17 = nmp17 + p_nme08,   #總帳存入
                        nmp19 = nmp19 + p_nme08    #總帳結存
                     WHERE nmp01 = p_nmp01 AND nmp02 = p_nmp02 AND nmp03 = p_nmp03 #MOD-4A0041
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
#      CALL cl_err('upate nmp17',SQLCA.sqlcode,1)   #No.FUN-660148
       CALL cl_err3("upd","nmp_file",p_nmp01,"",SQLCA.sqlcode,"","update nmp17",1) #No.FUN-660148
       LET g_success ='N'
    END IF
END FUNCTION

#CHI-B20020 add --start--
FUNCTION r360_del_nme(p_nmp01,p_nmp02,p_nmp03)
  DEFINE  p_nmp01  LIKE nmp_file.nmp01,    #銀行編號
          p_nmp02  LIKE nmp_file.nmp02, 
          p_nmp03  LIKE nmp_file.nmp03, 
          l_nme08  LIKE nme_file.nme08,    #金額(本幣)
          l_year   LIKE type_file.num10,  
          l_month  LIKE type_file.num10   

    LET l_year   = YEAR(tm.sdate)
    LET l_month  = MONTH(tm.sdate)

    SELECT SUM(nme08) INTO l_nme08 FROM nme_file
     WHERE nme01 = p_nmp01
       AND nme12 = 'adjust'
      #AND YEAR(nme02) = l_year   #MOD-BB0308 mark
      #AND MONTH(nme02)= l_month  #MOD-BB0308 mark
       AND YEAR(nme16) = l_year   #MOD-BB0308
       AND MONTH(nme16)= l_month  #MOD-BB0308
    IF cl_null(l_nme08) THEN LET l_nme08 = 0 END IF

    UPDATE nmp_file SET nmp17 = nmp17 - l_nme08,   #總帳存入
                        nmp19 = nmp19 - l_nme08    #總帳結存
                     WHERE nmp01 = p_nmp01 AND nmp02 = p_nmp02 AND nmp03 = p_nmp03 
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
       CALL cl_err3("upd","nmp_file",p_nmp01,"",SQLCA.sqlcode,"","update nmp17",1) 
       LET g_success ='N'
    END IF
    #TQC-B70209 --begin
    IF g_nmz.nmz70 ='1' THEN
       DELETE FROM tic_file
        WHERE tic04 in (
       SELECT nme12 FROM nme_file 
        WHERE nme01 = p_nmp01
          AND nme12 = 'adjust'
         #AND YEAR(nme02) = l_year     #MOD-BB0308 mark
         #AND MONTH(nme02)= l_month )  #MOD-BB0308 mark
          AND YEAR(nme16) = l_year     #MOD-BB0308
          AND MONTH(nme16)= l_month )  #MOD-BB0308
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","tic_file",p_nmp01,"",SQLCA.sqlcode,"","r360_del_tic:",1) 
          LET g_success = 'N' 
       END IF      
    END IF      
    #TQC-B70209 --end
    DELETE FROM nme_file
     WHERE nme01 = p_nmp01
       AND nme12 = 'adjust'
      #AND YEAR(nme02) = l_year    #MOD-BB0308 mark
      #AND MONTH(nme02)= l_month   #MOD-BB0308 mark
       AND YEAR(nme16) = l_year    #MOD-BB0308
       AND MONTH(nme16)= l_month   #MOD-BB0308
    IF SQLCA.sqlcode THEN
       CALL cl_err3("del","nme_file",p_nmp01,"",SQLCA.sqlcode,"","r360_del_nme:",1) 
       LET g_success = 'N' 
    END IF       
    #TQC-B70209 --begin mark
    #FUN-B40056  --Begin
   # IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
   #    DELETE FROM tic_file
   #     WHERE tic04 in (
   #    SELECT nme12 FROM nme_file 
   #     WHERE nme01 = p_nmp01
   #       AND nme12 = 'adjust'
   #       AND YEAR(nme02) = l_year   
   #       AND MONTH(nme02)= l_month )
   #    IF SQLCA.sqlcode THEN
   #       CALL cl_err3("del","tic_file",p_nmp01,"",SQLCA.sqlcode,"","r360_del_tic:",1) 
   #       LET g_success = 'N' 
   #    END IF      
   # END IF      
    #FUN-B40056  --End                  
    #TQC-B70209  --end mark
    RETURN l_nme08
END FUNCTION
#CHI-B20020 add --end--
 
#No.FUN-7A0036--start--
{
REPORT anmr360_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,        #No.FUN-680107 VARCHAR(1)
          sr  RECORD 
		  nmp01 LIKE nmp_file.nmp01, nmp02 LIKE nmp_file.nmp02,nmp03 LIKE nmp_file.nmp03,   #銀行編號
                  nma02  LIKE nma_file.nma02,   #簡稱
                  nma10  LIKE nma_file.nma10,   #存款幣別
		  nmp16  LIKE nmp_file.nmp16,   #結存(原幣)
		  nmp19  LIKE nmp_file.nmp19,   #結存(本幣)
                  local  LIKE nmp_file.nmp19,   #調整後金額(本幣)
                  diff   LIKE nmp_file.nmp19    #匯差調整(本幣)
              END RECORD,
          l_nmp16    LIKE nmp_file.nmp16,
          l_nmp19    LIKE nmp_file.nmp19, 
          l_local    LIKE nmp_file.nmp19,
          l_diff     LIKE nmp_file.nmp19
 
  OUTPUT TOP MARGIN g_top_margin 
         LEFT MARGIN g_left_margin 
         BOTTOM MARGIN g_bottom_margin 
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.nmp01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]    #No.TQC-6A0110
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]    #No.TQC-6A0110
      LET g_head1=g_x[11] CLIPPED,tm.sdate,COLUMN g_c[33],g_x[12] CLIPPED,tm.scur,
                  ' ',g_x[13] CLIPPED,tm.sex
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31] clipped,g_x[32] clipped,g_x[33] clipped,g_x[34] clipped,
            g_x[35] clipped,g_x[36] clipped
      PRINT g_dash1 
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      #96-06-14 Modify By Lynn
      PRINT COLUMN g_c[31],sr.nmp01[1,8],
            COLUMN g_c[32],sr.nma02[1,14],
            COLUMN g_c[33],cl_numfor(sr.nmp16,33,t_azi04_2) CLIPPED, #原幣結存 #NO.CHI-6A0004
            COLUMN g_c[34],cl_numfor(sr.nmp19,34,g_azi04)   CLIPPED, #本幣結存
            COLUMN g_c[35],cl_numfor(sr.local,35,g_azi04)   CLIPPED, #調整後金額
            COLUMN g_c[36],cl_numfor(sr.diff,36,g_azi04)    CLIPPED  #匯差調整  
 
   ON LAST ROW
      LET l_nmp16 = SUM(sr.nmp16)
      LET l_nmp19 = SUM(sr.nmp19)
      LET l_local = SUM(sr.local)
      LET l_diff  = SUM(sr.diff)
      PRINT column g_c[32],g_x[14] clipped,
            COLUMN g_c[33],cl_numfor(l_nmp16,33,t_azi04_2) CLIPPED,  #原幣結存 #NO.CHI-6A0004
            COLUMN g_c[34],cl_numfor(l_nmp19,34,g_azi04)   CLIPPED,  #本幣結存
            COLUMN g_c[35],cl_numfor(l_local,35,g_azi04)   CLIPPED,  #調整後金額
            COLUMN g_c[36],cl_numfor(l_diff,36,g_azi04)    CLIPPED   #匯差調整  
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF g_pageno = 0 OR l_last_sw = 'y'
         THEN PRINT g_dash[1,g_len]
              PRINT column 6,g_x[9] clipped,'             ',g_x[10] clipped
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#No.FUN-7A0036--end--
